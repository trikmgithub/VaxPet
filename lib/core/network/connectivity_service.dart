import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isConnected = true;
  bool _hasShownNoConnectionDialog = false;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  // Thêm callback để thông báo thay đổi connectivity cho UI
  Function(bool)? onConnectivityChanged;

  /// Khởi tạo service kiểm tra kết nối
  Future<void> initialize() async {
    try {
      print('Starting ConnectivityService initialization...');

      // Khởi tạo local notifications trước
      await _initializeLocalNotifications();
      print('Local notifications initialized');

      // Đảm bảo connectivity plugin được khởi tạo
      await Future.delayed(const Duration(milliseconds: 500));

      // Kiểm tra kết nối ban đầu với retry
      await _checkInitialConnectionWithRetry();

      // Lắng nghe thay đổi kết nối với error handling tốt hơn
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          print('ConnectivityService stream error: $error');
          // Thử khởi tạo lại sau lỗi
          Future.delayed(const Duration(seconds: 2), () {
            _reinitializeConnectivityListener();
          });
        },
        cancelOnError: false,
      );

      print('ConnectivityService initialized successfully');
    } catch (e) {
      print('ConnectivityService initialization failed: $e');
      // Thử khởi tạo lại sau 3 giây
      Future.delayed(const Duration(seconds: 3), () {
        initialize();
      });
    }
  }

  /// Khởi tạo local notifications
  Future<void> _initializeLocalNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon'); // Đổi từ ic_launcher sang launcher_icon

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin?.initialize(initializationSettings);
  }

  /// Kiểm tra kết nối ban đầu với retry
  Future<void> _checkInitialConnectionWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final List<ConnectivityResult> connectivityResult =
            await _connectivity.checkConnectivity().timeout(
          const Duration(seconds: 10),
        );
        print('Initial connectivity check attempt ${i + 1}: $connectivityResult');
        _onConnectivityChanged(connectivityResult);
        return; // Thành công, thoát khỏi loop
      } catch (e) {
        print('Connectivity check attempt ${i + 1} failed: $e');
        if (i < maxRetries - 1) {
          await Future.delayed(Duration(seconds: (i + 1) * 2));
        }
      }
    }
    // Nếu tất cả attempts đều fail, assume no connection
    print('All connectivity checks failed, assuming no connection');
    _onConnectivityChanged([ConnectivityResult.none]);
  }

  /// Khởi tạo lại connectivity listener sau lỗi
  Future<void> _reinitializeConnectivityListener() async {
    try {
      await _connectivitySubscription?.cancel();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _onConnectivityChanged,
        onError: (error) {
          print('ConnectivityService stream error (reinit): $error');
        },
        cancelOnError: false,
      );
      print('Connectivity listener reinitialized');
    } catch (e) {
      print('Failed to reinitialize connectivity listener: $e');
    }
  }

  /// Xử lý khi trạng thái kết nối thay đổi
  void _onConnectivityChanged(List<ConnectivityResult> result) {
    try {
      final bool isConnected = result.any((element) =>
          element != ConnectivityResult.none);

      // Log connectivity changes cho cả debug và production
      print('Connectivity changed: $isConnected, Results: $result');

      if (_isConnected != isConnected) {
        _isConnected = isConnected;

        if (!isConnected) {
          print('No connection detected - showing notification');
          _showNoConnectionNotification();
        } else {
          print('Connection restored');
          _hasShownNoConnectionDialog = false;
        }
      }

      // Gọi callback thông báo thay đổi connectivity cho UI
      onConnectivityChanged?.call(isConnected);
    } catch (e) {
      print('Error in _onConnectivityChanged: $e');
    }
  }

  /// Hiển thị thông báo khi không có kết nối
  void _showNoConnectionNotification() {
    if (_hasShownNoConnectionDialog) return;

    _hasShownNoConnectionDialog = true;

    // Hiển thị thông báo local notification
    _showLocalNotification();
  }

  /// Hiển thị local notification
  Future<void> _showLocalNotification() async {
    try {
      // Kiểm tra xem notifications plugin đã được khởi tạo chưa
      if (_flutterLocalNotificationsPlugin == null) {
        print('FlutterLocalNotificationsPlugin not initialized');
        return;
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'connectivity_channel',
        'Kết nối mạng',
        channelDescription: 'Thông báo về tình trạng kết nối mạng',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon', // Đổi từ ic_launcher sang launcher_icon
        enableVibration: true,
        playSound: true,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin?.show(
        0,
        'Không có kết nối mạng',
        'Vui lòng bật WiFi hoặc dữ liệu di động để tiếp tục sử dụng ứng dụng.',
        platformChannelSpecifics,
      );

      print('Local notification shown successfully');
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  /// Hiển thị dialog thông báo không có kết nối
  static void showNoConnectionDialog(BuildContext context) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text('Không có kết nối mạng'),
            ],
          ),
          content: const Text(
            'Vui lòng bật WiFi hoặc dữ liệu di động để tiếp tục sử dụng ứng dụng.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đã hiểu'),
            ),
          ],
        );
      },
    );
  }

  /// Kiểm tra xem có kết nối internet không với timeout
  Future<bool> hasConnection({Duration timeout = const Duration(seconds: 5)}) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await _connectivity.checkConnectivity().timeout(timeout);
      final hasConnection = connectivityResult.any((element) =>
          element != ConnectivityResult.none);

      print('Connection check result: $hasConnection');
      return hasConnection;
    } catch (e) {
      print('Error checking connection: $e');
      return false;
    }
  }

  /// Getter để lấy trạng thái kết nối hiện tại
  bool get isConnected => _isConnected;

  /// Hủy đăng ký lắng nghe
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

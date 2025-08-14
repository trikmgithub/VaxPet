import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
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

  /// Khởi tạo service kiểm tra kết nối
  Future<void> initialize() async {
    // Kiểm tra kết nối ban đầu
    await _checkInitialConnection();

    // Lắng nghe thay đổi kết nối
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  /// Kiểm tra kết nối ban đầu
  Future<void> _checkInitialConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    _onConnectivityChanged(connectivityResult);
  }

  /// Xử lý khi trạng thái kết nối thay đổi
  void _onConnectivityChanged(List<ConnectivityResult> result) {
    final bool isConnected = result.any((element) =>
        element != ConnectivityResult.none);

    if (_isConnected != isConnected) {
      _isConnected = isConnected;

      if (!isConnected) {
        _showNoConnectionNotification();
      } else {
        _hasShownNoConnectionDialog = false;
      }
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
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'connectivity_channel',
      'Kết nối mạng',
      channelDescription: 'Thông báo về tình trạng kết nối mạng',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.show(
      0,
      'Không có kết nối mạng',
      'Vui lòng bật WiFi hoặc dữ liệu di động để tiếp tục sử dụng ứng dụng.',
      platformChannelSpecifics,
    );
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

  /// Kiểm tra xem có kết nối internet không
  Future<bool> hasConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
    return connectivityResult.any((element) =>
        element != ConnectivityResult.none);
  }

  /// Getter để lấy trạng thái kết nối hiện tại
  bool get isConnected => _isConnected;

  /// Hủy đăng ký lắng nghe
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Khởi tạo notification service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Khởi tạo timezone
    tz.initializeTimeZones();

    // Cấu hình cho Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // Cấu hình cho iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Cấu hình tổng thể
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Khởi tạo plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Xử lý khi người dùng tap vào notification
        _handleNotificationTap(response);
      },
    );

    _isInitialized = true;
  }

  // Xử lý khi người dùng tap vào notification
  static void _handleNotificationTap(NotificationResponse response) {
    // Có thể navigate đến trang cụ thể hoặc thực hiện action khác
    print('Notification tapped: ${response.payload}');
  }

  // Yêu cầu quyền cho Android 13+
  static Future<bool> requestPermission() async {
    if (!_isInitialized) await initialize();

    // Yêu cầu quyền cho Android 13+
    final bool? granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return granted ?? true;
  }

  // Hiển thị thông báo ngay lập tức
  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'appointment_channel',
        'Lịch hẹn',
        channelDescription: 'Thông báo về lịch hẹn thú cưng',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        color: Color(0xFF6366F1), // Màu primary của app
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Hiển thị thông báo về lịch hẹn
  static Future<void> showAppointmentNotification(int appointmentCount) async {
    if (appointmentCount <= 0) return;

    String title;
    String body;

    if (appointmentCount == 1) {
      title = '🐾 Bạn có 1 lịch hẹn hôm nay!';
      body = 'Đừng quên đưa thú cưng đi khám nhé!';
    } else {
      title = '🐾 Bạn có $appointmentCount lịch hẹn hôm nay!';
      body = 'Kiểm tra chi tiết các lịch hẹn của bạn.';
    }

    await showInstantNotification(
      id: 1001, // ID cố định cho appointment notifications
      title: title,
      body: body,
      payload: 'appointment_$appointmentCount',
    );
  }

  // Lên lịch thông báo cho tương lai
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel',
        'Lịch hẹn sắp tới',
        channelDescription: 'Thông báo nhắc nhở lịch hẹn sắp tới',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        color: Color(0xFF6366F1),
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // Hủy một thông báo cụ thể
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Hủy tất cả thông báo
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Lấy thông báo đang chờ
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}

/*import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
  try {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // استخدم named parameter
    await _notifications.initialize(settings: initSettings);
    
    print('✅ Notifications initialized successfully');
  } catch (e) {
    print('❌ Error initializing notifications: $e');
  }
}

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'tasbeeh_channel',
        'Tasbeeh Notifications',
        channelDescription: 'Notifications for Tasbeeh app',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        id: 0,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      );
      
      print('✅ Notification sent: $title');
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id: id);
      print('✅ Notification cancelled: $id');
    } catch (e) {
      print('❌ Error cancelling notification: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      print('✅ All notifications cancelled');
    } catch (e) {
      print('❌ Error cancelling all notifications: $e');
    }
  }
}*/
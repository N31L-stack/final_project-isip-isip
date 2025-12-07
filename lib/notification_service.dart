import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> initialize() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Initialize timezone
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
        
  final InitializationSettings initializationSettings = InitializationSettings(
  android: androidInitializationSettings,
  iOS: DarwinInitializationSettings(),  
  macOS: DarwinInitializationSettings(), 
);
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> showAppointmentNotification({
    required String title,
    required String body,
    required String appointmentId,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'appointment_channel',
      'Appointment Updates',
      channelDescription: 'Notifications for appointment status changes',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleReminderNotification({
    required String title,
    required String body,
    required DateTime appointmentTime,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Appointment Reminders',
      channelDescription: 'Notifications for upcoming appointments',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    
    await _notificationsPlugin.zonedSchedule(
      appointmentTime.millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(appointmentTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
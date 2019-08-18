import 'package:class_resources/models/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  static initModelSettings() {
    var initSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initSettingsIOS = IOSInitializationSettings();
    return InitializationSettings(initSettingsAndroid, initSettingsIOS);
  }

  static final classNotificationChannel = NotificationDetails(
    AndroidNotificationDetails(
      'class-events',
      'Class Events',
      'Event related to class like class dismissal etc',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      enableVibration: true,
      playSound: true,
    ),
    IOSNotificationDetails(),
  );

  static final defaultNotificationChannel = NotificationDetails(
    AndroidNotificationDetails(
      'default',
      'Default',
      'Default Notifications Channel',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      enableVibration: true,
    ),
    IOSNotificationDetails(),
  );

  void initFcmListeners(topic) async {
    /// TODO: show token somewhere for debugging
    // await _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic(topic);

    /// TODO: support background notifications
    /// Background notifications not yet supported
    /// waiting for https://github.com/flutter/plugins/pull/1900 to be merged

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        NotificationModel.instance.addNotification(
            AppNotification(
              title: message["notification"]["title"],
              body: message["notification"]["body"],
              data: message["data"],
            ),
            show: true);
      },
      onResume: (Map<String, dynamic> message) async {
        NotificationModel.instance.addNotification(AppNotification(
          title: message["data"]["title"],
          body: message["data"]["body"],
          data: message["data"],
        ));
      },
      onLaunch: (Map<String, dynamic> message) async {
        NotificationModel.instance.addNotification(AppNotification(
          title: message["data"]["title"],
          body: message["data"]["body"],
          data: message["data"],
        ));
      },
    );
  }
}

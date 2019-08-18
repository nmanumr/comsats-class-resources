import 'dart:convert';

import 'package:class_resources/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationModel extends Model {
  static final NotificationModel instance = NotificationModel();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  List<AppNotification> notifications = [];

  Future onSelectNotification(String payload) async {
    /// TODO: show notifications tab
  }

  NotificationModel() {
    notifications = [];
    var settings = NotificationUtils.initModelSettings();
    _flutterLocalNotificationsPlugin.initialize(settings,
        onSelectNotification: onSelectNotification);
  }
    
  addNotification(AppNotification notification, {bool show: false}) async {
    if (show)
      await _flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        NotificationUtils.classNotificationChannel,
        payload: jsonEncode(notification.data),
      );
    notifications.add(notification);
    notifyListeners();
  }

  removeNotification(num index) {
    notifications.removeAt(index);
    notifyListeners();
  }
}

class AppNotification {
  String title;
  String body;
  String id;
  dynamic data;

  AppNotification({this.title, this.body, this.data});
}

import 'dart:developer';

import 'package:flutter/services.dart';

class TimeTableScreenWidget{
  static const platform = const MethodChannel('com.firebaseapp.comsats_cr/timetable_widget');

  static void refreshWidget() {
    try {
      platform.invokeMethod('refresh_timetable_widget');
    } on PlatformException catch (e) {
      log("Failed to refresh: '${e.message}'.");
    }
  }
}

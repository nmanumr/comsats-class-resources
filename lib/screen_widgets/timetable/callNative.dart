import 'dart:developer';

import '../../models/event.model.dart';
import 'package:flutter/services.dart';

class CallNative{
  static const platform = const MethodChannel('com.firebaseapp.comsats_cr/timetable_widget');

  void updateWidget(List events) {
    try {
      platform.invokeMethod('update_timetable_widget', {"todaysTimetableEvents" : _getData(events)});
    } on PlatformException catch (e) {
      log("Failed to update: '${e.message}'.");
    }
  }

  void refreshWidget() {
    try {
      platform.invokeMethod('refresh_timetable_widget');
    } on PlatformException catch (e) {
      log("Failed to refresh: '${e.message}'.");
    }
  }

  _EventToPass _convertToE2P(EventModel eventModel){
    return _EventToPass(
        eventModel.course.title + (eventModel.isLab?"(Lab)":""),
        eventModel.location,
        eventModel.startTime.toString(),
        eventModel.endTime.toString()
    );
  }
  List _getData(List events){
    List x;
    for(EventModel event in events){
      if(event.eventType == EventType.ClassEvent){
        x.add(_convertToE2P(event));
      }
    }
    return x;
  }

}

class _EventToPass{
  String sub;
  String loc;
  String startTime;
  String endTime;

  _EventToPass(this.sub, this.loc, this.startTime, this.endTime);
}
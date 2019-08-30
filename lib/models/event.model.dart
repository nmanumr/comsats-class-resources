import 'dart:ui';

import 'package:class_resources/models/base.model.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

enum EventType { reminder, event }

class EventModel extends Model with BaseModel, EventData {
  CourseModel course;

  EventModel({
    Map<String, dynamic> data,
    DocumentReference ref,
    this.course,
  }){
    load(ref: ref, data: data);
  }
}

class EventData {
  String title;
  String location;
  String repeat;
  DateTime startTime;
  DateTime endTime;
  EventType eventType;
  CourseModel course;
  String eventSlot;
  Color color;

  /// First datetime to start repeating event from
  DateTime eventStart;

  /// Last datetime to stop repeating event to
  DateTime eventEnd;

  loadData(Map<String, dynamic> data) {
    title = data["title"];
    location = data["location"];
    eventType = data["eventType"];
    course = data["course"];
    eventSlot = data["eventSlot"];
    color = data["color"];

    startTime = data["startTime"] != null
        ? (data["startTime"] as Timestamp).toDate()
        : null;
    eventEnd = data["endTime"] != null
        ? (data["endTime"] as Timestamp).toDate()
        : null;
    eventStart = data["eventStart"] != null
        ? (data["eventStart"] as Timestamp).toDate()
        : null;
    eventEnd = data["eventEnd"] != null
        ? (data["eventEnd"] as Timestamp).toDate()
        : null;
  }
}

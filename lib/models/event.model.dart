import 'dart:ui';

import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';
import "package:meta/meta.dart";
import 'package:class_resources/models/course.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

enum EventType { ClassEvent, Reminder }

class EventModel extends Model {
  String title;
  String location;
  String teacher;
  TimeOfDay startTime;
  TimeOfDay endTime;
  EventType eventType;
  CourseModel course;
  num weekday;
  bool isLab;
  String eventSlot;
  
  Color color;

  DocumentReference ref;

  loadData(Map<String, dynamic> data) {
    location = data["location"];
    teacher = data["teacher"];
    eventSlot = data["eventSlot"];
    weekday = data["weekday"];

    startTime = timeOfDayFromString(data["startTime"]);
    endTime = timeOfDayFromString(data["endTime"]);

    isLab = data["isLab"];
    title = (isLab ? "(Lab) " : "") + this.course.title;
    color = data["color"] ?? HexColor(generateColor(title));
  }

  TimeOfDay timeOfDayFromString(String time) {
    var t = time.split(":");
    return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }

  EventModel({
    Map<String, dynamic> data,
    this.ref,
    @required this.eventType,
    @required this.course,
  }) {
    loadData(data);
  }
}

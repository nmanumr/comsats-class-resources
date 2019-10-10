import 'dart:ui';

import 'package:class_resources/utils/colors.dart';
import 'package:class_resources/utils/datetime.dart';
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

  EventModel({
    Map<String, dynamic> data,
    this.ref,
    @required this.eventType,
    @required this.course,
  }) {
    loadData(data);
  }

  toJson(){
    return {
      "location": this.location,
      "teacher": this.teacher,
      "eventSlot": this.eventSlot,
      "weekday": this.weekday,
      "startTime": timeOfDayToString(this.startTime),
      "endTime": timeOfDayToString(this.endTime),
      "isLab": this.isLab,
      "title": this.title,
      "color": "${this.color.red}, ${this.color.green}, ${this.color.blue}"
    };
  }
}

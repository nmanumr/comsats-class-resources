import 'package:class_resources/models/course.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model {
  final String title;
  final String location;
  final String repeat;
  final Timestamp startTime;
  final Timestamp endTime;
  final EventType eventType;
  final CourseModel course;
  final String eventSlot;
  final color;

  /// First datetime to start repeating event from
  final DateTime eventStart;

  /// Last datetime to stop repeating event to
  final DateTime eventEnd;

  EventModel({
    this.title,
    this.location,
    this.endTime,
    this.repeat,
    this.startTime,
    this.eventStart,
    this.eventEnd,
    this.eventType,
    this.color,
    this.course,
    this.eventSlot
  });

  static EventModel eventFromDocument(DocumentSnapshot doc, CourseModel course) {
    DateTime eventStart, eventEnd;
    if (doc.data["eventStart"] != null)
      eventStart = doc.data["eventStart"].toDate();
    if (doc.data["eventEnd"] != null) eventEnd = doc.data["eventEnd"].toDate();

    return EventModel(
      title: doc.data["title"],
      location: doc.data["location"],
      eventType: doc.data["eventType"],
      repeat: doc.data["repeat"],
      endTime: doc.data["endTime"],
      startTime: doc.data["startTime"],
      eventSlot: doc.data["eventSlot"],
      eventStart: eventStart,
      eventEnd: eventEnd,
      color: HexColor(generateColor(doc.data["title"], l: 40)).withAlpha(200),
      course: course,
    );
  }
}

enum EventType { reminder, event }

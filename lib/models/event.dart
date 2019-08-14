import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model {
  final String title;
  final String location;
  final String repeat;
  final Timestamp startTime;
  final Timestamp endTime;
  final EventType eventType;

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
    this.eventType
  });

  static EventModel eventFromDocument(DocumentSnapshot doc) {
    DateTime eventStart, eventEnd;
    if(doc.data["eventStart"] != null)
      eventStart = doc.data["eventStart"].toDate();
    if(doc.data["eventEnd"] != null)
      eventEnd = doc.data["eventEnd"].toDate();

    return EventModel(
      title: doc.data["title"],
      location: doc.data["location"],
      eventType: doc.data["eventType"],
      repeat: doc.data["repeat"],
      endTime: doc.data["endTime"],
      startTime: doc.data["startTime"],
      eventStart: eventStart,
      eventEnd: eventEnd,
    );
  }
}

enum EventType{
  reminder,
  event
}
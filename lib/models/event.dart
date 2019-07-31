import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class EventModel extends Model {
  final String title;
  final String location;
  final String repeat;
  final Timestamp startTime;
  final Timestamp endTime;

  EventModel({
    this.title,
    this.location,
    this.endTime,
    this.repeat,
    this.startTime,
  });

  static EventModel eventFromDocument(DocumentSnapshot doc) {
    return EventModel(
      title: doc.data["title"],
      location: doc.data["location"],
      repeat: doc.data["repeat"],
      endTime: doc.data["endTime"],
      startTime: doc.data["startTime"],
    );
  }
}

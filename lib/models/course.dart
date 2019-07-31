import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'event.dart';

class CourseModel extends Model {
  String code;
  String title;
  String teacher;
  String creditHours;
  String klassName;
  DocumentReference klass;
  DocumentReference semester;

  bool isLoading = true;
  final DocumentReference ref;
  Firestore _firestore = Firestore.instance;

  CourseModel({this.ref}) {
    loadCourse();
  }

  loadCourse() {
    this.ref.snapshots().listen((document) {
      code = document.data["code"];
      title = document.data["title"];
      klass = document.data["class"];
      teacher = document.data["teacher"];
      semester = document.data["semester"];
      creditHours = document.data["creditHours"];

      klassName = klass.documentID;
      isLoading = false;
      notifyListeners();
    });
  }

  getCourseResources() {
    return _firestore.collection("${ref.path}/resources").snapshots();
  }

  Future<List<EventModel>> getAllEvents(){
    var completer = new Completer<List<EventModel>>();
    List<EventModel> events = [];

    _firestore.collection("${ref.path}/timetable").snapshots().listen(
      (data) {
        for (var document in data.documents) {
          events.add(EventModel.eventFromDocument(document));
        }
        completer.complete(events);
      },
    );

    return completer.future;
  }
}

import 'dart:async';
import 'package:class_resources/models/profile.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'event.dart';

class CourseModel extends Model {
  String code;
  String title;
  String teacher;
  String creditHours;
  String klassName;
  List maintainers;
  DocumentReference klass;
  DocumentReference semester;

  bool isLoading = true;
  final DocumentReference ref;
  Firestore _firestore = Firestore.instance;
  final ProfileModel user;

  StreamSubscription _courseStreamlistener;
  StreamSubscription _eventsStreamlistener;

  CourseModel({@required this.ref, @required this.user}) {
    loadCourse();
  }

  void close() {
    _courseStreamlistener.cancel();
    if (_eventsStreamlistener != null) {
      _eventsStreamlistener.cancel();
    }
  }

  loadCourse() {
    _courseStreamlistener = this.ref.snapshots().listen((document) {
      code = document.data["code"];
      title = document.data["title"];
      klass = document.data["class"];
      teacher = document.data["teacher"];
      semester = document.data["semester"];
      semester = document.data["semester"];
      maintainers = document.data["maintainers"] ?? [];
      creditHours = document.data["creditHours"];

      klassName = klass.documentID;
      isLoading = false;
      notifyListeners();
    });
  }

  getCourseResources() {
    return _firestore
        .collection("${ref.path}/resources")
        .orderBy("date")
        .snapshots();
  }

  Future<List<EventModel>> getAllEvents() {
    var completer = new Completer<List<EventModel>>();
    List<EventModel> events = [];

    _eventsStreamlistener =
        _firestore.collection("${ref.path}/events").snapshots().listen((data) {
      for (var document in data.documents) {
        events.add(EventModel.eventFromDocument(document, this));
      }
      completer.complete(events);
      _eventsStreamlistener.cancel();
    });

    return completer.future;
  }
}

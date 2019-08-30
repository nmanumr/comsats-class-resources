import 'package:class_resources/mixins/firestore.mixin.dart';
import 'package:class_resources/models/base.model.dart';
import 'package:class_resources/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'event.model.dart';

class CourseModel extends Model with BaseModel, CourseData, FirestoreMixin {
  ProfileModel user;

  CourseModel({
    Map<String, dynamic> data,
    DocumentReference ref,
    this.user,
  }){
    load(data: data, ref: ref);
  }

  Stream<QuerySnapshot> getCourseResources() =>
      collectionSnapshots("resources");

  Stream<QuerySnapshot> getCourseAssignments() =>
      collectionSnapshots("assignments");

  Stream<List<EventModel>> getAllEvents() {
    return collectionSnapshots("events").map(
      (data) => data.documents.map(
        (eventDoc) => EventModel(
          data: eventDoc.data,
          ref: eventDoc.reference,
          course: this,
        ),
      ).toList(),
    );
  }
}

class CourseData {
  String code;
  String title;
  String teacher;
  String creditHours;
  String klassName;
  List maintainers;
  DocumentReference klass;
  DocumentReference semester;

  loadData(Map<String, dynamic> data) {
    code = data["code"];
    title = data["title"];
    klass = data["class"];
    teacher = data["teacher"];
    semester = data["semester"];
    semester = data["semester"];
    maintainers = data["maintainers"] ?? [];
    creditHours = data["creditHours"];
  }
}

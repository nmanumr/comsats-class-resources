import 'package:class_resources/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class SemesterModel extends Model {
  String name;
  List<CourseModel> courses = [];
  DocumentReference ref;
  bool isCurrent = false;

  SemesterModel({DocumentSnapshot doc, this.isCurrent}) {
    this.name = doc.data["name"];
    ref = doc.reference;

    for (DocumentReference courseRef in doc.data["courses"]) {
      courses.add(CourseModel(ref: courseRef));
    }
  }
}

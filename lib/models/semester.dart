import 'package:class_resources/models/course.dart';
import 'package:class_resources/models/profile.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class SemesterModel extends Model {
  String name;
  List<CourseModel> courses = [];
  DocumentReference ref;
  bool isCurrent = false;
  final ProfileModel user;

  SemesterModel({@required DocumentSnapshot doc, this.isCurrent, @required this.user}) {
    this.name = doc.data["name"];
    ref = doc.reference;

    for (DocumentReference courseRef in doc.data["courses"]) {
      courses.add(CourseModel(ref: courseRef, user: this.user));
    }
  }

  void close(){
    for(var course in courses){
      course.close();
    }
  }
}

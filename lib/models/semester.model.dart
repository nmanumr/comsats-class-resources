import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class SemesterModel extends Model {
  String name;
  bool isCurrent;
  ProfileModel user;
  List<CourseModel> courses = [];

  DocumentReference ref;

  SemesterModel({
    @required this.user,
    this.ref,
    Map<String, dynamic> data,
  }) {
    loadData(data);
  }

  loadData(Map<String, dynamic> data) {
    name = data["name"];
    // rawCourses = (data["courses"] as List).cast<DocumentReference>();
    isCurrent = data["isCurrent"] ?? false;

    courses = (data["courses"] as List)
        .cast<DocumentReference>()
        .map<CourseModel>((course) {
      return CourseModel(ref: course, user: user);
    }).toList();
  }

  Future<void> close() async {
    for(var course in courses){
      await course.service.close();
    }
  }
}

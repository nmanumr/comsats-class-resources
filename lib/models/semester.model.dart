import 'package:class_resources/models/base.model.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/profile.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class SemesterModel extends Model with BaseModel, SemesterData {
  /// user profile model
  ProfileModel user;

  /// Resolved course models
  List<CourseModel> courses = [];

  SemesterModel({
    Map<String, dynamic> data,
    DocumentReference ref,
    @required this.user,
  }) {
    load(ref: ref, data: data);
  }

  @override
  void destroy() {
    for (var course in courses) course.destroy();
    super.destroy();
  }

  void loadCourse() {
    for (DocumentReference courseRef in this.rawCourses) {
      print(courseRef.path);
      courses.add(CourseModel(ref: courseRef, user: this.user));
    }
  }
}

class SemesterData {
  /// name of the semester
  String name;

  /// True if its current semester
  bool isCurrent;

  /// raw references to courses
  List<DocumentReference> rawCourses;

  /// Overriden in model class
  loadCourse() {}

  loadData(Map<String, dynamic> data) {
    name = data["name"];
    rawCourses = (data["courses"] as List).cast<DocumentReference>();
    isCurrent = data["isCurrent"] ?? false;

    loadCourse();
  }
}
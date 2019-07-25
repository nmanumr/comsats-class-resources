import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

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

  CourseModel({this.ref}) {
    loadCourse();
  }

  /// loads course data from firestore db
  loadCourse() {
    this.ref.snapshots().listen((document) {
      code = document.data["code"];
      title = document.data["title"];
      klass = document.data["class"];
      teacher = document.data["teacher"];
      semester = document.data["semester"];
      creditHours = document.data["creditHours"];

      klassName = klass.path.split("/").last;
      isLoading = false;
      notifyListeners();
    });
  }
}

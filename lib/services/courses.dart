import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  Course({this.code, this.color, this.creditHours, this.teacher, this.title});

  String code;
  String color;
  String creditHours;
  String teacher;
  String title;
}

class CoursesService {
  final Firestore _firestore = Firestore.instance;

  getUserCourses(String uid) {
    return _firestore.collection('users').document(uid).snapshots();
  }
}

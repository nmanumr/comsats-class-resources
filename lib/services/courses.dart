import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

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

  getAllCourses() {
    return _firestore.collection('subjects').snapshots();
  }

  _updateUserCourses(String uid, DocumentReference course, bool opIsAdd) async {
    var func = (opIsAdd ? FieldValue.arrayUnion : FieldValue.arrayRemove);
    return await _firestore.collection('users').document(uid).updateData({
      "subjects": func([course])
    });
  }

  addCourse(String uid, DocumentReference course) async {
    return await _updateUserCourses(uid, course, true);
  }

  removeCourse(String uid, DocumentReference course) async {
    return await _updateUserCourses(uid, course, false);
  }

  syncWithClass() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'syncUserCourses',
    );

    return await callable.call();
  }
}

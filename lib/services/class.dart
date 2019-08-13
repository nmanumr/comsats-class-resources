import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class KlassService {
  final Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getAllClasses() {
    return _firestore.collection("/classes").snapshots();
  }

  Stream<QuerySnapshot> getClassSemesters(String klass) {
    return _firestore.collection('$klass/semesters').snapshots();
  }

  createCourse({
    String title,
    String teacher,
    String creditHours,
    String code,
    String klass,
    String semester,
  }) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'addCourseToClass',
    );

    return await callable.call({
      "title": title,
      "creditHours": creditHours,
      "code": code,
      "klass": klass,
      "semester": semester,
      "teacher": teacher,
    });
  }

  changeClass(String klass) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'syncUserCourses',
    );

    return await callable.call({
      "class": klass,
    });
  }
}

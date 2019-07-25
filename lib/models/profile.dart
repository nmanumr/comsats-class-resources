import 'package:class_resources/components/course-item.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/models/course.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileModel extends Model {
  String rollNum;
  String name;
  String email;
  String id;
  String klass;
  bool isProfileComplete;
  DocumentReference klassRef;

  final AuthService auth = AuthService();
  final Firestore _firestore = Firestore.instance;
  bool isLoading = true;

  bool isCoursesLoading = true;
  List<Widget> coursesList = [];

  ProfileModel() {
    auth.getCurrentUser().then((val) {
      id = val.uid;
      _loadProfile(id);
      _buildCoursesList();
    });
  }

  void _loadProfile(String id) {
    auth.getProfile(id).listen((val) {
      rollNum = val.data['rollNum'];
      name = val.data['name'];
      email = val.data['email'];
      klassRef = val.data['class'];
      klass = val.data['class'].path;
      rollNum = val.data['rollNum'];
      isProfileComplete = val.data['profile_completed'];

      isLoading = false;
      notifyListeners();
    });
  }

  void _buildCoursesList() {
    getUserSemester().listen((query) {
      for (var semester in query.documents.reversed) {
        coursesList.add(ListHeader(text: semester["name"]));
        for (DocumentReference course in semester["courses"]) {
          coursesList.add(CourseItem(
            model: CourseModel(ref: course),
          ));
        }
      }
      isCoursesLoading = false;
      notifyListeners();
    });
  }

  Stream<QuerySnapshot> getUserSemester() {
    return _firestore.collection('users/$id/semesters').snapshots();
  }

  Future updateProfile({String name, String rollNum, String klass}) async {
    await auth.updateProfile(
      id,
      Profile(
        name: name ?? this.name,
        rollNum: rollNum ?? this.rollNum,
        klass: klass ?? this.klass,
      ),
    );
  }
}

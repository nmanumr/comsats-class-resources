import 'package:class_resources/services/course.service.dart';
import 'package:meta/meta.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import 'class.model.dart';


class CourseModel extends Model {
  ProfileModel user;
  String code;
  String title;
  String teacher;
  String creditHours;
  List maintainers;
  DocumentReference ref;
  KlassModel klass;

  bool isLoading = true;
  CourseService service;

  loadData(Map<String, dynamic> data) {
    code = data["code"];
    title = data["title"];
    klass = KlassModel.fromRef(data["class"]);
    teacher = data["teacher"];
    maintainers = data["maintainers"] ?? [];
    creditHours = data["creditHours"];

    isLoading = false;
    notifyListeners();
  }

  CourseModel({
    this.ref,
    @required this.user,
  }){
    service = CourseService(this, ref);
  }
}
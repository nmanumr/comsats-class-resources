import 'package:class_resources/models/base.model.dart';
import 'package:class_resources/models/class.model.dart';
import 'package:class_resources/models/semester.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileModel extends Model with BaseModel, ProfileData {
  UserModel user;

  ProfileModel({
    Map<String, dynamic> data,
    DocumentReference ref,
    this.user,
  }) {
    load(ref: ref, data: data);
  }


  loadData(Map<String, dynamic> data) {
    name = data["name"];
    id = data["id"];
    rollNum = data["rollNum"];
    klass = KlassModel.fromRef(data["class"] as DocumentReference);
    crntSemester = SemesterModel(ref: data["class"] as DocumentReference, user: this);
  }
}

class ProfileData {
  String name;
  String id;
  String rollNum;
  KlassModel klass;
  SemesterModel crntSemester;  
}

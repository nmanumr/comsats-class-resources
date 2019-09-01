import 'package:class_resources/models/class.model.dart';
import 'package:class_resources/models/semester.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/services/profile.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

enum ProfileStatus {
  Loading,
  LoadingSemesters,
  Loaded,
  Error,
}

class ProfileModel extends Model {
  UserModel user;
  String name;
  String id;
  String rollNum;
  KlassModel klass;
  ProfileService service;
  List<SemesterModel> semesters = [];
  ProfileStatus status;

  bool loading = true;

  ProfileModel(this.user) {
    service = ProfileService(user, this);
  }

  loadData(Map<String, dynamic> data) {
    // profile doesn't exists
    if (data == null)
      status = ProfileStatus.Error;

    else {
      name = data["name"];
      id = data["id"];
      rollNum = data["rollNum"];
      klass = KlassModel.fromRef(data["class"] as DocumentReference);
      loading = false;

      status = ProfileStatus.Loaded;
    }

    // only subscribe semesters once
    if (semesters.isEmpty) loadSemesters(user.uid);

    notifyListeners();
    return;
  }

  /// load user semester
  loadSemesters(String userId) {
    setStatus(ProfileStatus.LoadingSemesters);

    service.subscribeCollection("/users/$userId/semesters/", (data) {

      semesters = data.documents
          .map<SemesterModel>((doc) => SemesterModel(
                data: doc.data,
                ref: doc.reference,
                user: this,
              ))
          .toList();
      setStatus(ProfileStatus.Loaded);
    });
  }

  setStatus(ProfileStatus status){
    this.status = status;
    notifyListeners();
  }

  close() => service.close();
}

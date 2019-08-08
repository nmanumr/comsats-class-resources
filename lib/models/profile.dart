import 'dart:async';

import 'package:class_resources/models/semester.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileModel extends Model {
  String rollNum;
  String name;
  String email;
  String id;
  String klass;
  DocumentReference klassRef;
  DocumentReference crntSemesterRef;

  final AuthService auth = AuthService();
  final Firestore _firestore = Firestore.instance;

  List<SemesterModel> semesters = [];

  bool isProfileLoading = true;
  bool isSemestersLoading = true;

  StreamSubscription _profileStreamlistener;
  StreamSubscription _semesterStreamlistener;

  ProfileModel() {
    auth.getCurrentUser().then((val) {
      id = val.uid;
      _loadProfile(id);
    });
  }

  void close(){
    _profileStreamlistener.cancel();
    _semesterStreamlistener.cancel();
    
    for(var semester in semesters){
      semester.close();
    }
  }

  void _loadProfile(String id) {
    _profileStreamlistener = auth.getProfile(id).listen((val) {
      rollNum = val.data['rollNum'];
      name = val.data['name'];
      email = val.data['email'];
      klassRef = val.data['class'];
      klass = val.data['class']?.path;
      rollNum = val.data['rollNum'];
      crntSemesterRef = val.data["currentSemester"];

      isProfileLoading = false;
      _loadSemesters();
      notifyListeners();
    });
  }

  void _loadSemesters() {
    _semesterStreamlistener = _firestore.collection('users/$id/semesters').snapshots().listen((data) {
      for (var document in data.documents) {
        semesters.add(SemesterModel(
          doc: document,
          isCurrent: document.reference.path == crntSemesterRef.path,
          user: this
        ));
      }

      this.isSemestersLoading = false;
      notifyListeners();
    });
  }

  SemesterModel getCrntSemester() {
    int index = semesters.indexWhere((smtr)=> smtr.isCurrent);
    if (index >= 0) 
      return semesters[index];
    return null;
  }
}

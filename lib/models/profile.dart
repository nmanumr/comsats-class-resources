import 'dart:async';

import 'package:class_resources/models/semester.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

enum ProfileStatus { ProfileError, AuthError, Loading, Success }

class ProfileModel extends Model {
  String rollNum;
  String name;
  String email;
  String id;
  String klass;
  String photoUrl;
  bool isGoogleProvider;
  DocumentReference klassRef;
  DocumentReference crntSemesterRef;

  final AuthService auth = AuthService();
  final Firestore _firestore = Firestore.instance;

  List<SemesterModel> semesters = [];

  ProfileStatus profileStatus = ProfileStatus.Loading;
  bool isSemestersLoading = true;

  StreamSubscription _profileStreamlistener;
  StreamSubscription _semesterStreamlistener;

  ProfileModel() {
    auth.getCurrentUser().then((val) {
      // user has been deleted but is still logged
      if (val == null) {
        profileStatus = ProfileStatus.AuthError;
        notifyListeners();
      } else {
        id = val.uid;
        email = val.email;
        isGoogleProvider =
            val.providerData.any((data) => data.providerId == "google.com") ?? false;
        photoUrl = val.photoUrl;
        _loadProfile(id);
      }
    });
  }

  void close() {
    if (_profileStreamlistener != null) _profileStreamlistener.cancel();
    if (_semesterStreamlistener != null) _semesterStreamlistener.cancel();

    for (var semester in semesters) {
      semester.close();
    }
  }

  void _loadProfile(String id) {
    _profileStreamlistener = auth.getProfile(id).listen((val) {
      // profile doesn't exists
      if (val.data == null) {
        profileStatus = ProfileStatus.ProfileError;
        notifyListeners();
      }

      rollNum = val.data['rollNum'];
      name = val.data['name'];
      klassRef = val.data['class'];
      klass = val.data['class']?.path;
      rollNum = val.data['rollNum'];
      crntSemesterRef = val.data["currentSemester"];

      profileStatus = ProfileStatus.Success;
      _loadSemesters();
      notifyListeners();
    });
  }

  void _loadSemesters() {
    _semesterStreamlistener =
        _firestore.collection('users/$id/semesters').snapshots().listen((data) {
      for (var document in data.documents) {
        semesters.add(
          SemesterModel(
            doc: document,
            isCurrent: document.reference.path == crntSemesterRef.path,
            user: this,
          ),
        );
      }

      this.isSemestersLoading = false;
      notifyListeners();
    });
  }

  SemesterModel getCrntSemester() {
    int index = semesters.indexWhere((smtr) => smtr.isCurrent);
    if (index >= 0) return semesters[index];
    return null;
  }
}

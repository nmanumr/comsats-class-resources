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
  bool isProfileComplete;
  DocumentReference klassRef;
  DocumentReference crntSemesterRef;

  final AuthService auth = AuthService();
  final Firestore _firestore = Firestore.instance;

  List<SemesterModel> semesters = [];

  bool isProfileLoading = true;
  bool isSemestersLoading = true;

  ProfileModel() {
    auth.getCurrentUser().then((val) {
      id = val.uid;
      _loadProfile(id);
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
      crntSemesterRef = val.data["currentSemester"];

      isProfileLoading = false;
      _loadSemesters();
      notifyListeners();
    });
  }

  void _loadSemesters() {
    _firestore.collection('users/$id/semesters').snapshots().listen((data) {
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

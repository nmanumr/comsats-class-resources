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
  List<dynamic> subjects;

  final AuthService auth = AuthService();
  bool isLoading = true;

  ProfileModel() {
    auth.getCurrentUser().then((val){
      id = val.uid;
      _loadProfile(id);
    });
  }

  void _loadProfile(String id) {
    auth.getProfile(id).listen((val){
      rollNum = val.data['rollNum'];
      name = val.data['name'];
      email = val.data['email'];
      klassRef = val.data['class'];
      klass = val.data['class'].path;
      rollNum = val.data['rollNum'];
      subjects = val.data['subjects'];
      isProfileComplete = val.data['profile_completed'];

      isLoading = false;
      notifyListeners();
    });
  }

  Future updateProfile({String name, String rollNum, String klass}) async{
    await auth.updateProfile(id, Profile(
      name: name ?? this.name,
      rollNum: rollNum ?? this.rollNum,
      klass: klass ?? this.klass
    ));
  }
}
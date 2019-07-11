import 'package:class_resources/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileScopedModel extends Model {
  String rollNum;
  String name;
  String email;
  String id;
  String klass;
  DocumentReference klassRef;
  List<DocumentReference> subjects;

  final AuthService auth = AuthService();
  bool isLoading = true;

  ProfileScopedModel() {
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

      notifyListeners();
    });
  }

  // TODO: update profile
  Future updatePofile() async {
    
  }
}
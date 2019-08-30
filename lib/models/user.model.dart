import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

enum AccountStatus { ProfileError, AuthError, Loading, Success }

class UserData {
  String email;
  String name;
  String photoUrl;
  String uid;
  List<String> providers;
  AccountStatus status;

  loadData(FirebaseUser data) {
    if (data == null)
      status = AccountStatus.AuthError;

    else {
      uid = data.uid;
      email = data.email;
      photoUrl = data.photoUrl;
      name = data.displayName;
      providers = data.providerData.map((d) => d.providerId).toList();
    }
  }
}

class UserModel extends Model with UserData {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel() {
    _firebaseAuth.currentUser().then((data) {
      loadData(data);
      notifyListeners();
    });
  }
}

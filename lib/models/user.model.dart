import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/services/user.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

enum AccountStatus { AuthError, Loading, Success, LoggedOut }

class UserModel extends Model {
  String email;
  String name;
  String photoUrl;
  String uid;
  List<UserInfo> providers;
  AccountStatus status = AccountStatus.Loading;
  UserService service;

  ProfileModel profile;

  UserModel(String uid) {
    if (uid == null || uid.isEmpty)
      status = AccountStatus.LoggedOut;
    else {
      status = AccountStatus.Loading;
      service = UserService(uid, this);
    }
  }

  UserModel.fromData(FirebaseUser data) {
    service = UserService.fromData(this);
    loadData(data);
  }

  loadData(FirebaseUser data) {
    if (data == null)
      status = AccountStatus.AuthError;
    else {
      uid = data.uid;
      email = data.email;
      photoUrl = data.photoUrl;
      name = data.displayName;
      providers = data.providerData;
      profile = ProfileModel(this);
      status = AccountStatus.Success;
    }

    notifyListeners();
  }

  setStatus(AccountStatus status) {
    status = status;
    notifyListeners();
  }

  hasProvider(String providerId) {
    for (var provider in providers)
      if (provider.providerId == providerId) return true;

    return false;
  }
}

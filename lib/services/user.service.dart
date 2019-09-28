import 'package:class_resources/models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  UserModel model;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  UserService(String uid, this.model) {
    if (uid != "") {
      getCurrentUser().then((data) {
        model.loadData(data);
      }).catchError((e) {
        model.setStatus(AccountStatus.AuthError);
      });
    }
  }

  UserService.fromData(this.model);

  /// Save User id to shared preferences
  /// to presistant user login
  Future<void> saveUserId(uid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", uid);
  }

  /// signup user with email and password
  Future<UserModel> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )) as FirebaseUser;
    saveUserId(user.uid);

    this.model.loadData(user);
    return this.model;
  }

  /// Sign in user with google signin provider
  Future<UserModel> signinWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _firebaseAuth.signInWithCredential(credential)) as FirebaseUser;

    saveUserId(user.uid);
    this.model.loadData(user);
    return this.model;
  }

  /// Sign user with email, password
  Future<UserModel> signIn(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)) as FirebaseUser;

    saveUserId(user.uid);
    this.model.loadData(user);
    return this.model;
  }

  /// Sign out user
  Future<void> signOut() async {
    await this.close();
    _firebaseAuth.signOut();
    saveUserId(null);
  }

  /// get current user instance
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  /// reset user password
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// change user password
  Future<void> changePassword(String password) async {
    var user = await getCurrentUser();
    await user.updatePassword(password);
  }

  /// change user email
  Future<void> changeEmail(String email) async {
    var user = await getCurrentUser();
    await user.updateEmail(email);
  }

  Future<bool> hasProfile(String uid) async {
    var doc = await _firestore.document("/users/$uid/").get();
    return doc.exists;
  }

  Future<void> close() async {
    await this.model.profile.service.close();
  }
}

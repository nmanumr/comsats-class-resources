import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _firestore = Firestore.instance;
  

  Future setUserId(uid) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("uid", uid);
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    setUserId(user.uid);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Stream<DocumentSnapshot> getProfile(userId) {
    return _firestore.collection("users").document(userId).snapshots();
  }

  Future<void> signOut() async {
    _firebaseAuth.signOut();
    setUserId("");
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> signUp(Profile profile) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: profile.email,
      password: profile.password,
    );

    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = profile.name;
    await user.updateProfile(info);
    await updateProfile(user.uid, profile);
    setUserId(user.uid);
  }

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        await _firebaseAuth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  updateProfile(String uid, Profile profile) async {
    DocumentReference profileRef = _firestore.document("users/${uid}");
    DocumentSnapshot document = await profileRef.get();

    if (document.exists) {
      await profileRef.updateData({
        "rollNum": profile.rollNum ?? "",
        "email": profile.email,
        "id": uid,
        "subjects": [],
        "name": profile.name ?? "",
        "class": _firestore.document("classes/${profile.klass ?? 'null'}"),
        "profile_completed": true
      });
    } else {
      await profileRef.setData({
        "rollNum": profile.rollNum ?? "",
        "email": profile.email,
        "id": uid,
        "subjects": [],
        "name": profile.name ?? "",
        "class": _firestore.document("classes/${profile.klass ?? 'null'}"),
        "profile_completed": false
      });
    }
    return true;
  }
}

class Profile {
  Profile({
    this.rollNum,
    this.email,
    this.password,
    this.id,
    this.klass,
    this.klassRef,
    this.name,
    this.subjects,
  });

  String rollNum;
  String password;
  String email;
  String id;
  String name;
  String klass;
  DocumentReference klassRef;
  List<DocumentReference> subjects;
}

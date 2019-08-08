import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _firestore = Firestore.instance;

  Future setUserId(uid) async {
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

  Future<void> changePassword(String password) async {
    var user = await getCurrentUser();
    await user.updatePassword(password);
  }

  Future<void> changeEmail(String email) async {
    var user = await getCurrentUser();
    await user.updateEmail(email);
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
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
    return user;
  }

  updateProfile(String name, String rollNum) async {
    var user = await getCurrentUser();
    DocumentReference profileRef = _firestore.document("users/${user.uid}");
    DocumentSnapshot document = await profileRef.get();

    profileUpdate(Map<String, dynamic> data) => document.exists
        ? profileRef.updateData(data)
        : profileRef.setData(data, merge: true);

    profileUpdate({
      "rollNum": rollNum,
      "id": user.uid,
      "name": name,
    });
  }
}

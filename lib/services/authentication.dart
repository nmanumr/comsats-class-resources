import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    createUserProfileIfNotExists(user, Profile());
    return user;
  }

  Future<DocumentSnapshot> getUserProfile() async {
    FirebaseUser user = await getCurrentUser();
    return await _firestore.collection("users").document(user.uid).get();
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> signUp(Profile profile) async {
    DocumentReference x = _firestore.document("classes/${profile.klass}");
    print("TEST: ${x.path}");
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: profile.email,
      password: profile.password,
    );
    return await createUserProfileIfNotExists(user, profile);
  }

  createUserProfileIfNotExists(FirebaseUser user, Profile profile) async {
    DocumentReference profileRef =
        _firestore.collection("users").document(user.uid);

    profileRef.get().then((doc) {
      if (!doc.exists) {
        _firestore.collection("users").document(user.uid).setData({
          "rollNum": profile.rollNum ?? user.email.substring(0, 12),
          "email": profile.email,
          "id": user.uid,
          "subjects": [],
          "name": profile.name ?? "",
          "class": _firestore.document("classes/${profile.klass}")
        });
      }
    });
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

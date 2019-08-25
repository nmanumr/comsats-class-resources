import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMixin {
  Firestore _firestore = Firestore.instance;

  /// To be intialed by parent class
  DocumentReference ref;

  Stream<QuerySnapshot> collectionSnapshots(String name){
    return _firestore.collection("${ref.path}/$name").snapshots();
  }
}

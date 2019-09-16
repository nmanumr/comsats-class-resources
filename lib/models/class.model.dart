import 'dart:async';

import 'package:class_resources/models/profile.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class KlassModel extends Model {
  String name;
  String cr;

  DocumentReference ref;
  bool isLoading = true;
  StreamSubscription _sub;
  ProfileModel profile;

  KlassModel.fromRef(DocumentReference ref) {
    this.ref = ref;
    _sub = ref.snapshots().listen((doc) {
      loadData(doc.data);
    });
  }

  loadData(Map<String, dynamic> data) {
    name = data["name"];
    cr = data["CR"];
    isLoading = false;
    notifyListeners();
  }

  /// To be called when model destory
  Future<void> close() async {
    if (_sub != null) await _sub.cancel();
  }
}

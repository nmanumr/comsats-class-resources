import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class KlassModel extends Model {
  String name;
  DocumentReference currentSemester;
  String cr;

  DocumentReference ref;
  bool isLoading = true;
  StreamSubscription _sub;

  KlassModel.fromdoc(Map<String, dynamic> data, {this.ref}) {
    loadData(data);
  }

  KlassModel.fromRef(DocumentReference ref) {
    this.ref = ref;
    _sub = ref.snapshots().listen((doc) {
      isLoading = false;
      loadData(doc.data);
      notifyListeners();
    });
  }

  loadData(Map<String, dynamic> data) {
    name = data["name"];
    currentSemester = data["currentSemester"];
    cr = data["CR"];
    isLoading = false;
    notifyListeners();
  }

  /// To be called when model destory
  void close() {
    if (_sub != null) _sub.cancel();
  }
}

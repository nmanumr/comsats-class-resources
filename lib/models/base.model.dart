import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel<T> extends Model {
  T data;
  bool isLoading = true;
  DocumentReference ref;

  StreamSubscription _sub;

  BaseModel(this.data, {this.ref}) : isLoading = false;

  BaseModel.fromRef(DocumentReference ref) {
    ref = ref;
    _sub = ref.snapshots().listen((doc) {
      data = doc.data as T;
      isLoading = false;
      notifyListeners();
    });
  }

  destroy() {
    if (_sub != null) _sub.cancel();
  }
}

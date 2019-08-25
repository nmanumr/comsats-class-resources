import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  /// Raw data of the model
  Map<String, dynamic> raw;

  /// Is model data loading
  bool isLoading = true;
  DocumentReference ref;

  StreamSubscription _sub;

  BaseModel({Map<String, dynamic> data, this.ref}) {
    if (data == null)
      _sub = ref.snapshots().listen((doc) {
        // cannot find any way to manipulate all class field from map directly
        raw = doc.data;
        isLoading = false;

        onDataLoaded();
        notifyListeners();
      });
    else {
      raw = data;
      onDataLoaded();
    }
  }

  /// Build Model from document
  BaseModel.fromdoc(this.raw, {this.ref}) : isLoading = false {
    onDataLoaded();
  }

  /// Build Model from document reference
  BaseModel.fromRef(DocumentReference ref) {
    ref = ref;
    _sub = ref.snapshots().listen((doc) {
      raw = doc.data;
      isLoading = false;
      onDataLoaded();
      notifyListeners();
    });
  }

  /// Does nothing
  /// To be overriden by super class
  void loadData(Map<String, dynamic> data) {
  }

  /// called when data has been loaded
  void onDataLoaded() => loadData(raw);

  /// To be called when model destory
  void destroy() {
    if (_sub != null) _sub.cancel();
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class BaseModel {
  /// Raw data of the model
  Map<String, dynamic> raw;

  /// Is model data loading
  bool isLoading = true;
  DocumentReference ref;

  StreamSubscription _sub;

  load({Map<String, dynamic> data, @required ref}) {
    this.ref = ref;
    
    if (data == null)
      loadfromRef(ref);
    else
      loadFromdoc(data, ref: ref);
  }

  /// Build Model from document
  loadFromdoc(raw, {DocumentReference ref}) {
    this.raw = raw;
    this.ref = ref;
    isLoading = false;
    onDataLoaded();
  }

  /// Build Model from document reference
  loadfromRef(DocumentReference ref) {
    this.ref = ref;
    _sub = ref.snapshots().listen((doc) {
      raw = doc.data;
      isLoading = false;
      onDataLoaded();
      notifyListeners();
    });
  }

  /// Does nothing
  /// To be overriden by super class
  void loadData(Map<String, dynamic> data) {}

  /// Does nothing
  /// To be overriden by super class
  notifyListeners() {}

  /// called when data has been loaded
  void onDataLoaded() => loadData(raw);

  /// To be called when model destory
  void close() {
    if (_sub != null) _sub.cancel();
  }
}

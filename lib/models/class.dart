import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

class KlassModel extends Model {
  String name;
  DocumentReference currentSemester;
  DocumentReference ref;
  String cr;

  KlassModel({this.name, this.cr, this.currentSemester, @required this.ref});

  static Future<KlassModel> fromRef(DocumentReference ref) async {
    var doc = await ref.get();
    return KlassModel(
      cr: doc.data["CR"],
      currentSemester: doc.data["currentSemester"],
      name: doc.data["name"],
      ref: ref
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:class_resources/models/base.model.dart';
import 'package:scoped_model/scoped_model.dart';

class KlassModel extends Model with BaseModel, KlassData {
  KlassModel.fromdoc(Map<String, dynamic> data, {DocumentReference ref}) {
    load(data: data, ref: ref);
  }

  KlassModel.fromRef(DocumentReference ref) {
    load(ref: ref);
  }
}

class KlassData {
  String name;
  DocumentReference currentSemester;
  String cr;

  loadData(Map<String, dynamic> data) {
    name = data["name"];
    currentSemester = data["currentSemester"];
    cr = data["cr"];
  }
}

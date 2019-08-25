import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:class_resources/models/base.model.dart';

class KlassModel extends BaseModel with KlassData {
  KlassModel.fromdoc(Map<String, dynamic> data, {DocumentReference ref})
      : super.fromdoc(data, ref: ref);

  KlassModel.fromRef(DocumentReference ref) : super.fromRef(ref);
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

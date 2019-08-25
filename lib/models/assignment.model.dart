import 'package:class_resources/models/base.model.dart';
import 'package:class_resources/models/resource.model.dart';
import 'package:class_resources/services/download-manager.dart';
import 'package:class_resources/mixins/downloadable.mixin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel extends BaseModel with Downloadable, ResourceData {
  DownloadManager downloadManager;

  AssignmentModel({
    Map<String, dynamic> data,
    DocumentReference ref,
    this.downloadManager,
  }) : super(data: data, ref: ref);


  @override
  notifyModelListeners() {
    notifyListeners();
  }

  @override
  void loadData(Map<String, dynamic> data) {
    super.loadData(data);
    name = data["title"] ?? data["name"];
  }
}
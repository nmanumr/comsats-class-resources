import 'package:class_resources/models/base.model.dart';
import 'package:class_resources/services/download-manager.dart';
import 'package:class_resources/mixins/downloadable.mixin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ResourceModel extends Model with BaseModel, Downloadable {
  DownloadManager downloadManager;
  String name;
  String driveFileId;

  String _downloadUrl;
  String _openUrl;
  DateTime date;
  String uploadedBy;
  String mimeType;
  String extension;
  bool isHeading;
  String documentId;

  set downloadUrl(String url) {
    if (url != null)
      _downloadUrl = url;
    else
      _downloadUrl =
          "https://drive.google.com/uc?id=$driveFileId&export=download";
  }

  get downloadUrl => _downloadUrl;

  set openUrl(String url) {
    if (url != null)
      _openUrl = url;
    else
      _openUrl = "https://drive.google.com/file/d/$driveFileId/view";
  }

  get openUrl => _openUrl;

  get formatedDate => this.date != null
      ? DateFormat("EEE, MMMM d, yyyy").format(this.date)
      : "";

  loadData(Map<String, dynamic> data) {
    name = data["name"];
    driveFileId = data["driveFileId"];
    downloadUrl = data["downloadUrl"];
    openUrl = data["openUrl"];
    date = data["date"] != null ? (data["date"] as Timestamp).toDate(): null;
    mimeType = data["mimeType"];
    uploadedBy = data["uploadedBy"];
    extension = data["ext"];
    isHeading = data["isHeading"] ?? false;
  }

  ResourceModel({
    Map<String, dynamic> data,
    DocumentReference ref,
    this.downloadManager,
  }) {
    load(ref: ref, data: data);
  }

  @override
  notifyModelListeners() {
    notifyListeners();
  }
}
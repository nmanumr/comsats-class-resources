import 'package:class_resources/services/download-manager.dart';
import 'package:class_resources/utils/downloadable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ResourceModel extends Model with Downloadable {
  Timestamp date;
  String name;
  String uploadedBy;
  bool isHeading;
  String documentId;

  DocumentReference ref;
  bool loading = true;

  ResourceModel({this.ref}) {
    documentId = ref.documentID;
    loadPath();
  }

  @override
  notifyModelListeners(){
    notifyListeners();
  }

  static fromDocument(DocumentSnapshot doc, DownloadManager downloadManager) {
    var res = ResourceModel(ref: doc.reference);
    res.date = doc.data["date"];
    res.driveFileId = doc.data["driveFileId"];
    res.downloadUrl = doc.data["downloadUrl"];
    res.openUrl = doc.data["openUrl"];
    res.name = doc.data["name"];
    res.uploadedBy = doc.data["uploadedBy"];
    res.mimeType = doc.data["mimeType"];
    res.ext = doc.data["ext"];
    res.isHeading = doc.data["isHeading"];

    res.loading = false;
    res.downloadManager = downloadManager;

    return res;
  }

  loadRef() async {
    var doc = await this.ref.get();
    this.date = doc.data["date"];
    this.driveFileId = doc.data["driveFileId"];
    this.downloadUrl = doc.data["downloadUrl"];
    this.openUrl = doc.data["openUrl"];
    this.name = doc.data["name"];
    this.uploadedBy = doc.data["uploadedBy"];
    this.mimeType = doc.data["mimeType"];
    this.ext = doc.data["ext"];
    this.isHeading = doc.data["isHeading"];

    this.loading = false;
    notifyListeners();
  }

  String formateDate() {
    if (this.date != null)
      return DateFormat("EEE, MMMM d, yyyy").format(this.date.toDate());
    return "";
  }
}

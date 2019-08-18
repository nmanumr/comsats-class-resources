import 'package:class_resources/models/course.dart';
import 'package:class_resources/models/event.dart';
import 'package:class_resources/services/download-manager.dart';
import 'package:class_resources/utils/downloadable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class AssignmentModel extends Model with Downloadable {
  String uploadedBy;
  String driveFileId;
  DateTime date;
  String mimeType;
  String ext;
  EventModel event;
  CourseModel course;
  DocumentReference ref;
  DownloadManager downloadManager;
  bool loading = true;

  AssignmentModel(
      {this.uploadedBy,
      this.driveFileId,
      this.mimeType,
      this.event,
      this.course,
      this.ext,
      this.downloadManager}) {
    documentId = ref.documentID;
    loadPath();
  }

  AssignmentModel.fromDocument(DocumentSnapshot doc, this.downloadManager) {
    name = doc.data["title"];
    date = (doc.data["date"] as Timestamp).toDate();
    driveFileId = doc.data["driveFileId"];
    mimeType = doc.data["mimeType"];
    uploadedBy = doc.data["uploadedBy"];
    ext = doc.data["ext"];
    documentId = doc.documentID;

    EventModel.fromDocumentRef(doc.data["event"] as DocumentReference).then(
      (model) {
        event = model;
        notifyListeners();
      },
    );
    loadPath();
  }

  @override
  notifyModelListeners() {
    print("notifyModelListeners");
    notifyListeners();
  }

  String formateDate() {
    if (this.date != null)
      return DateFormat("EEE, MMMM d, yyyy").format(this.date);
    return "";
  }
}

import 'dart:io';
import 'package:class_resources/services/download-manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class ResourceModel extends Model {
  Timestamp date;
  String driveFileId;
  String downloadUrl;
  String openUrl;
  String name;
  String mimeType;
  String ext;
  String uploadedBy;
  bool isHeading;

  DocumentReference ref;
  DownloadManager downloadManager;
  bool loading = true;
  DownloadTaskStatus downloadStatus = DownloadTaskStatus.undefined;
  String _downloadTaskId;
  String _localPath;

  ResourceModel({this.ref}) {
    loadPath();
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

  loadDownloadStatus() async {
    if (await File("$_localPath/${this.ref.documentID}.${this.ext}").exists()) {
      this.downloadStatus = DownloadTaskStatus.complete;
    } else {
      this.downloadStatus =
          await downloadManager.getDownloadStatus(this.getDownloadUrl());
    }
    notifyListeners();
  }

  loadPath() async {
    Directory appDocDir = await getExternalStorageDirectory();
    _localPath = appDocDir.path + '/Download';
    loadDownloadStatus();
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

  String getDownloadUrl() {
    if (downloadUrl != null) return downloadUrl;
    return "https://drive.google.com/uc?id=$driveFileId&export=download";
  }

  String getOpenUrl() {
    if (openUrl != null) return openUrl;
    return "https://drive.google.com/file/d/$driveFileId/view";
  }

  open() {
    OpenFile.open("$_localPath/${this.ref.documentID}.${this.ext}",
        type: this.mimeType);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openInBrowser() {
    _launchURL(this.getOpenUrl());
  }

  share() {
    Share.file(
      path: "$_localPath/${this.ref.documentID}.${this.ext}",
      mimeType: ShareType.fromMimeType(this.mimeType),
      title: this.name,
      text: this.name,
    ).share();
  }

  delete() {
    File downloadedFile =
        File("$_localPath/${this.ref.documentID}.${this.ext}");
    downloadedFile.deleteSync();
    downloadStatus = DownloadTaskStatus.undefined;
    notifyListeners();
  }

  getDownloadStatusStream() {
    return downloadManager.listenDownloadTask(_downloadTaskId);
  }

  markDownloadStatus(DownloadTaskStatus status) {
    downloadStatus = status;
    notifyListeners();
  }

  pauseDownloading() async {
    await downloadManager.pauseTask(_downloadTaskId);
    markDownloadStatus(DownloadTaskStatus.paused);
  }

  resumeDownloading() async {
    _downloadTaskId = await downloadManager.resumeTask(_downloadTaskId);
    markDownloadStatus(DownloadTaskStatus.enqueued);
  }

  cancelDownloading() async {
    await downloadManager.cancelTask(_downloadTaskId);
    markDownloadStatus(DownloadTaskStatus.undefined);
  }

  download() async {
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) savedDir.create();

    _downloadTaskId = await downloadManager.startDownload(this.getDownloadUrl(),
        _localPath, "${this.ref.documentID}.${this.ext}");

    downloadStatus = DownloadTaskStatus.enqueued;
    notifyListeners();
  }
}

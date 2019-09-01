import 'dart:io';

import 'package:class_resources/services/download-manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Downloadable {
  factory Downloadable._() => null;

  String mimeType;
  String documentId;
  String driveFileId;
  String ext;
  String name;
  DownloadManager downloadManager;
  DownloadTaskStatus downloadStatus = DownloadTaskStatus.undefined;
  
  String _localPath;
  String _downloadUrl;
  String _openUrl;
  String _downloadTaskId;

  notifyModelListeners() => null;

  open() {
    OpenFile.open("$_localPath/$documentId.$ext", type: this.mimeType);
  }

  loadPath() async {
    Directory appDocDir = await getExternalStorageDirectory();
    _localPath = appDocDir.path + '/Download';
    loadDownloadStatus();
  }

  loadDownloadStatus() async {
    if (await File("$_localPath/$documentId.$ext").exists()) {
      this.downloadStatus = DownloadTaskStatus.complete;
    } else {
      this.downloadStatus =
          await downloadManager.getDownloadStatus(this.getDownloadUrl());
    }
    notifyModelListeners();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getDownloadUrl() {
    if (_downloadUrl != null) return _downloadUrl;
    return "https://drive.google.com/uc?id=$driveFileId&export=download";
  }

  String getOpenUrl() {
    if (_openUrl != null) return _openUrl;
    return "https://drive.google.com/file/d/$driveFileId/view";
  }

  openInBrowser() {
    _launchURL(this.getOpenUrl());
  }

  share() {
    Share.file(
      path: "$_localPath/$documentId.$ext",
      mimeType: ShareType.fromMimeType(this.mimeType),
      title: this.name,
      text: this.name,
    ).share();
  }

  delete() {
    File downloadedFile = File("$_localPath/$documentId.$ext");
    downloadedFile.deleteSync();
    downloadStatus = DownloadTaskStatus.undefined;
    notifyModelListeners();
  }

  getDownloadStatusStream() {
    return downloadManager.listenDownloadTask(_downloadTaskId);
  }

  markDownloadStatus(DownloadTaskStatus status) {
    downloadStatus = status;
    notifyModelListeners();
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

    _downloadTaskId = await downloadManager.startDownload(
        this.getDownloadUrl(), _localPath, "$documentId.$ext");

    downloadStatus = DownloadTaskStatus.enqueued;
    notifyModelListeners();
  }
}

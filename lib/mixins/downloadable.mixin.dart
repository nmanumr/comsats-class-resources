import 'dart:io';

import 'package:class_resources/services/download-manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  String downloadUrl;
  String openUrl;
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
    this.downloadStatus =
        await downloadManager.getDownloadStatus(this.downloadUrl);
    if (this.downloadStatus == DownloadTaskStatus.undefined &&
        await File("$_localPath/$documentId.$ext").exists()) {
      this.downloadStatus = DownloadTaskStatus.complete;
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

  openInBrowser() {
    _launchURL(this.openUrl);
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
    if (_downloadTaskId == null) {
      Fluttertoast.showToast(
        msg: "Download is not resumeable.",
      );
      await cancelDownloading();
      markDownloadStatus(DownloadTaskStatus.undefined);
    } else {
      markDownloadStatus(DownloadTaskStatus.enqueued);
    }
  }

  cancelDownloading() async {
    try {
      await downloadManager.cancelTask(_downloadTaskId);
      delete();
    } catch (_) {}
    markDownloadStatus(DownloadTaskStatus.undefined);
  }

  download() async {
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) savedDir.create();

    _downloadTaskId = await downloadManager.startDownload(
        this.downloadUrl, _localPath, "$documentId.$ext");

    downloadStatus = DownloadTaskStatus.enqueued;
    notifyModelListeners();
  }
}

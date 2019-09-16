import 'dart:async';

import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadService {
  Future<String> startDownload(
      String url, String saveDir, String fileName) async {
    var tasks = await getTasksByUrl(url);
    if (tasks.isNotEmpty) return tasks[0].taskId;

    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: saveDir,
      showNotification: true,
      openFileFromNotification: false,
      fileName: fileName,
    );
  }

  Stream<DownloadStatus> listenDownloadTask(String task) {
    var controller = StreamController<DownloadStatus>();
    FlutterDownloader.registerCallback((id, status, progress) {
      if (task == id) {
        controller.add(DownloadStatus(progress: progress, status: status));

        if (status != DownloadTaskStatus.running) controller.close();
      }
    });
    return controller.stream;
  }

  Future<List<DownloadTask>> getTasksByUrl(String url) async {
    return await FlutterDownloader.loadTasksWithRawQuery(
        query:
            'SELECT * FROM task WHERE url="$url" AND (status=2 OR status=6 OR status=1);');
  }

  Future<DownloadTaskStatus> getDownloadStatus(String url) async {
    var tasks = await getTasksByUrl(url);
    return (tasks ?? []).isNotEmpty
        ? tasks[0].status
        : DownloadTaskStatus.undefined;
  }

  Future<Null> cancelTask(String taskId) async {
    return await FlutterDownloader.remove(taskId: taskId);
  }

  Future<Null> pauseTask(String taskId) async {
    return await FlutterDownloader.pause(taskId: taskId);
  }

  Future<String> resumeTask(String taskId) async {
    return await FlutterDownloader.resume(taskId: taskId);
  }
}

class DownloadStatus {
  DownloadTaskStatus status;
  int progress;

  DownloadStatus({this.progress, this.status});
}

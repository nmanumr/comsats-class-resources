import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/resource.model.dart';
import 'package:class_resources/services/download-manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:scoped_model/scoped_model.dart';

class CourseResource extends StatelessWidget {
  final ResourceModel model;

  CourseResource({
    @required this.model,
  });

  progressIndicator({double value}) {
    return SizedBox(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        value: value,
      ),
      height: 40,
      width: 40,
    );
  }

  showBottomAction(context) {
    var downloadCompleted = model.downloadStatus == DownloadTaskStatus.complete;
    var downloadRunning = [
      DownloadTaskStatus.running,
      DownloadTaskStatus.enqueued,
      DownloadTaskStatus.paused,
    ].contains(model.downloadStatus);

    List<Widget> children = [
      ListTile(
        title: Text(model.name ?? "", overflow: TextOverflow.ellipsis),
        subtitle: Text(model.formatedDate),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.open_in_browser),
        title: Text('Open in Browser'),
        onTap: () {
          Navigator.pop(context);
          model.openInBrowser();
        },
      ),
    ];

    if (downloadRunning) {
      bool paused = model.downloadStatus == DownloadTaskStatus.paused;
      children.addAll([
        ListTile(
          leading: Icon(paused ? Icons.play_arrow : Icons.pause),
          title: Text(paused ? 'Resume download' : 'Pause download'),
          onTap: () {
            Navigator.pop(context);
            paused ? model.resumeDownloading() : model.pauseDownloading();
          },
        ),
        ListTile(
          leading: Icon(Icons.clear),
          title: Text('Cancel download'),
          onTap: () {
            Navigator.pop(context);
            model.cancelDownloading();
          },
        )
      ]);
    } else {
      children.insert(
        2,
        ListTile(
          leading:
              Icon(downloadCompleted ? Icons.open_in_new : Icons.file_download),
          title: Text(downloadCompleted ? 'Open File' : 'Download'),
          onTap: () {
            downloadCompleted ? model.open() : model.download();
            Navigator.pop(context);
          },
        ),
      );
      if (downloadCompleted) {
        children.addAll([
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () {
              Navigator.pop(context);
              model.share();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              model.delete();
            },
          )
        ]);
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: children,
          ),
        );
      },
    );
  }

  getTrailingWidget() {
    if ((model.isHeading) ||
        model.downloadStatus == DownloadTaskStatus.undefined) return null;

    if (model.downloadStatus == DownloadTaskStatus.complete)
      return Icon(Icons.offline_pin);

    if (model.downloadStatus == DownloadTaskStatus.paused)
      return Icon(Icons.pause);

    return StreamBuilder(
      stream: model.getDownloadStatusStream(),
      builder: (context, AsyncSnapshot<DownloadStatus> snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return progressIndicator();

        if (snap.data.status == DownloadTaskStatus.paused)
          return Icon(Icons.pause);

        if (snap.data.status == DownloadTaskStatus.complete) {
          model.markDownloadStatus(DownloadTaskStatus.complete);
          return Icon(Icons.offline_pin);
        }

        if (snap.data.status == DownloadTaskStatus.enqueued)
          return progressIndicator();

        if (snap.data.status == DownloadTaskStatus.failed)
          model.markDownloadStatus(DownloadTaskStatus.undefined);

        if (snap.data.status == DownloadTaskStatus.running) {
          print(snap.data.progress);
          if (snap.data.progress > 0 && snap.data.progress <= 100) {
            var val = snap.data.progress / 100.0;
            return Stack(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: Text("${snap.data.progress} %",
                        style: TextStyle(fontSize: 10.0)),
                  ),
                ),
                progressIndicator(value: val),
              ],
            );
          }
          return progressIndicator();
        }

        return progressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<ResourceModel>(
        builder: (ctx, _, model) {
          print("building...");
          if (model.isHeading) return ListHeader(text: model.name);

          return ListTile(
            leading: FileTypeAvatar(fileType: model.ext),
            title: Text(model.name ?? "", overflow: TextOverflow.ellipsis),
            subtitle: Text(model.formatedDate),
            trailing: getTrailingWidget(),
            onTap: () {
              if (model.downloadStatus == DownloadTaskStatus.complete)
                model.open();
              else
                showBottomAction(ctx);
            },
            onLongPress: () {
              showBottomAction(ctx);
            },
          );
        },
      ),
    );
  }
}

class CourseResources extends StatelessWidget {
  CourseResources({this.model});

  final CourseModel model;
  final DownloadManager _downloadManager = DownloadManager();

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onSuccess(QuerySnapshot query) {
    List<Widget> children = query.documents
        .map((doc) => CourseResource(
              model: ResourceModel(
                ref: doc.reference,
                data: doc.data,
                downloadManager: _downloadManager,
              ),
            ))
        .toList();

    if (children.isNotEmpty)
      return ListView(
        children: children,
      );

    return EmptyState(
      text: "No resource found",
      icon: Icons.collections_bookmark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: model.service.getCourseResources(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader();

        return onSuccess(snapshot.data);
      },
    );
  }
}

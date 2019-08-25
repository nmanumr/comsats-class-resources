import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/assignment.model.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/resource.model.dart';
import 'package:class_resources/services/download-manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:scoped_model/scoped_model.dart';


// TODO: make it better
class CourseResource extends StatelessWidget {
  final dynamic model;

  CourseResource({
    @required this.model,
  });

  progressIndicator({double value}) {
    return SizedBox(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        value: value,
      ),
      height: 20,
      width: 20,
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
      // bool paused = model.downloadStatus == DownloadTaskStatus.paused;
      children.addAll([
        // Disabled Pause we cannot check if the
        // download is resumable or not
        // ListTile(
        //   leading: Icon(paused ? Icons.play_arrow : Icons.pause),
        //   title: Text(paused ? 'Resume' : 'Pause'),
        //   onTap: () {
        //     Navigator.pop(context);
        //     paused ? model.resumeDownloading() : model.pauseDownloading();
        //   },
        // ),
        ListTile(
          leading: Icon(Icons.clear),
          title: Text('Cancel'),
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
    if ((model is ResourceModel && model.isHeading) ||
        model.downloadStatus == DownloadTaskStatus.undefined) return null;

    if (model.downloadStatus == DownloadTaskStatus.complete)
      return Icon(Icons.offline_pin);

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
          if (snap.data.progress > 0 && snap.data.progress <= 100)
            return progressIndicator(value: snap.data.progress.toDouble());
          return progressIndicator();
        }

        return progressIndicator();
      },
    );
  }

  Widget _buildModelDescendant(context, child, model) {
    if (model is ResourceModel && model.isHeading)
      return ListHeader(text: model.name);

    return ListTile(
      leading: FileTypeAvatar(fileType: model.extension),
      title: Text(model.name ?? "", overflow: TextOverflow.ellipsis),
      subtitle: Text(model.formatedDate),
      trailing: getTrailingWidget(),
      onTap: () {
        if (model.downloadStatus == DownloadTaskStatus.complete)
          model.open();
        else
          showBottomAction(context);
      },
      onLongPress: () {
        showBottomAction(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (model is ResourceModel) {
      return ScopedModel(
        model: model as ResourceModel,
        child: ScopedModelDescendant<ResourceModel>(
          builder: _buildModelDescendant,
        ),
      );
    }
    return ScopedModel(
      model: model as AssignmentModel,
      child: ScopedModelDescendant<AssignmentModel>(
        builder: _buildModelDescendant,
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
                  data: doc.data, downloadManager: _downloadManager),
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
      stream: model.getCourseResources(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader();

        return onSuccess(snapshot.data);
      },
    );
  }
}

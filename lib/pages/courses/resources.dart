import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/course.dart';
import 'package:class_resources/models/resource.dart';
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
      height: 20,
      width: 20,
    );
  }

  showBottomAction(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text(model.name ?? "", overflow: TextOverflow.ellipsis),
                subtitle: Text(model.formateDate()),
              ),
              Divider(),
              model.downloadStatus == DownloadTaskStatus.complete
                  ? ListTile(
                      leading: Icon(Icons.open_in_new),
                      title: Text('Open'),
                      onTap: () {
                        Navigator.pop(context);
                        model.open();
                      },
                    )
                  : ListTile(
                      leading: Icon(Icons.file_download),
                      title: Text('Download'),
                      onTap: () {
                        Navigator.pop(context);
                        model.download();
                      },
                    ),
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text('Open in Browser'),
                onTap: () {
                  Navigator.pop(context);
                  model.openInBrowser();
                },
              ),
              model.downloadStatus == DownloadTaskStatus.complete
                  ? ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share'),
                      onTap: () {
                        Navigator.pop(context);
                        model.share();
                      },
                    )
                  : Text(""),
              model.downloadStatus == DownloadTaskStatus.complete
                  ? ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                      onTap: () {
                        Navigator.pop(context);
                        model.delete();
                      },
                    )
                  : Text(""),
            ],
          ),
        );
      },
    );
  }

  getTrailingWidget() {
    if (model.isHeading || model.downloadStatus == DownloadTaskStatus.undefined)
      return null;

    if (model.downloadStatus == DownloadTaskStatus.complete)
      return Icon(Icons.offline_pin);

    return StreamBuilder(
      stream: model.getDownloadStatusStream(),
      builder: (context, AsyncSnapshot<DownloadStatus> snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return progressIndicator();

        print("Status: ${snap.data.status}");
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
          if (snap.data.progress >= 0 && snap.data.progress <= 100)
            return progressIndicator(value: snap.data.progress.toDouble());
          return progressIndicator();
        }

        return Text("");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<ResourceModel>(
        builder: (context, child, model) {
          if (model.isHeading) return ListHeader(text: model.name);
          return ListTile(
            leading: TextAvatar(
              text: model.name,
            ),
            title: Text(model.name ?? "", overflow: TextOverflow.ellipsis),
            subtitle: Text(model.formateDate()),
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
              model: ResourceModel.fromDocument(doc, _downloadManager),
            ))
        .toList();

    return ListView(
      children: children,
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

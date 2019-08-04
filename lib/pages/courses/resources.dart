import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/course.dart';
import 'package:class_resources/models/resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CourseResource extends StatelessWidget {
  final ResourceModel model;

  CourseResource({this.model});

  showBottomAction(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  title:
                      Text(model.name ?? "", overflow: TextOverflow.ellipsis),
                  subtitle: Text(model.formateDate())),
              Divider(),
              model.isDownloaded
                  ? ListTile(
                      leading: Icon(Icons.open_in_new),
                      title: Text('Open'),
                      onTap: () => model.open(),
                    )
                  : ListTile(
                      leading: Icon(Icons.file_download),
                      title: Text('Download'),
                      onTap: () => model.download(),
                    ),
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text('Open in Browser'),
                onTap: () => model.openInBrowser(),
              ),
              model.isDownloaded ?ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () => model.share(),
              ): Text(""),
              model.isDownloaded ?ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () => model.delete(),
              ): Text(""),
            ],
          ),
        );
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
            trailing: model.isDownloaded ? Icon(Icons.cloud_done) : Text(""),
            onTap: () {
              if (model.isDownloaded)
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

  Widget onError(err) {
    return Text('Error: $err');
  }

  Widget onSuccess(QuerySnapshot query) {
    List<Widget> children = query.documents
        .map((doc) => CourseResource(
              model: ResourceModel.fromDocument(doc),
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

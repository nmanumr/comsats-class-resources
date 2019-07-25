import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/course.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CourseItem extends StatelessWidget {
  CourseItem({this.model});

  final CourseModel model;

  buildLoading() {
    return ListTile(
      leading: TextAvatar(text: "..."),
      title: Text(model.ref.path),
      subtitle: Text("loading.."),
    );
  }

  buildLoaded() {
    return ListTile(
      leading: TextAvatar(
        text: model.title + model.klassName,
      ),
      title: Text(model.title),
      subtitle: Text("${model.klassName} - ${model.teacher}" ?? ""),
      onTap: () {},
      onLongPress: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<CourseModel>(
        builder: (context, child, model) {
          if (model.isLoading) buildLoading();
          return buildLoaded();
        },
      ),
    );
  }
}

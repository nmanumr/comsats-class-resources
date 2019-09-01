import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/class.model.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/pages/courses/course-details.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CourseItem extends StatelessWidget {
  CourseItem({this.model});

  final CourseModel model;

  buildLoading() {
    return ListTile(
      leading: TextAvatar(text: "..."),
      title: Text(model.ref.path),
      subtitle: Text("loading"),
    );
  }

  buildLoaded(BuildContext context) {
    return Hero(
      tag: model.ref.path,
      child: Material(
        child: ListTile(
          leading: TextAvatar(
            text: (model.title ?? ""),
          ),
          title: Text(model.title ?? ""),
          subtitle: ScopedModel(
            model: model.klass,
            child: ScopedModelDescendant<KlassModel>(
              builder: (context, child, klassModel) {
                return Text("${klassModel.name} - ${model.teacher}" ?? "");
              },
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CourseDetail(model: model, tag: model.ref.path),
              ),
            );
          },
          onLongPress: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<CourseModel>(
        builder: (context, child, model) {
          if (model.isLoading || model.klass == null) return buildLoading();
          return buildLoaded(context);
        },
      ),
    );
  }
}

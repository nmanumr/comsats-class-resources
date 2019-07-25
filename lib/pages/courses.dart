import 'package:class_resources/components/buttons.dart';
import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CoursesPage extends StatelessWidget {
  CoursesPage({@required this.model});

  final ProfileModel model;

  Widget getEmptyState() {
    return EmptyState(
      icon: Icons.library_books,
      text: "No course added",
      button: PrimaryFlatButton(
        child: Text("Add Courses"),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: ScopedModelDescendant<ProfileModel>(
        builder: (context, child, model) {
          return Scaffold(
            // key: PageStorageKey('courses'),
            appBar: centeredAppBar(context, "Courses"),
            body: Builder(
              builder: (context) {
                if (model.isCoursesLoading) return Loader();
                if (model.coursesList.length == 1) return getEmptyState();

                return ListView(
                  key: PageStorageKey('courses'),
                  children: model.coursesList,
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, "/add-course");
              },
            ),
          );
        },
      ),
    );
  }
}

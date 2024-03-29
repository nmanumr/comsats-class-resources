import 'package:class_resources/components/buttons.dart';
import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/course-item.dart';
import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.model.dart';
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
                if (model.status == ProfileStatus.LoadingSemesters ||
                    model.status == ProfileStatus.Loading) return Loader();
                    
                if (model.semesters.isEmpty) return getEmptyState();

                List<Widget> children = [];
                var added = [];
                for (var semester in model.semesters.reversed) {
                  if (added.contains(semester.ref.documentID)) continue;
                  children.add(ListHeader(text: semester.name));
                  added.add(semester.ref.documentID);

                  for (var course in semester.courses)
                    children.add(CourseItem(model: course));
                }

                return ListView(
                  key: PageStorageKey('courses'),
                  children: children,
                );
              },
            ),

            // floatingActionButton: FloatingActionButton(
            //   child: Icon(Icons.edit),
            //   onPressed: () {
            //     Navigator.pushNamed(context, "/add-course");
            //   },
            // ),
          );
        },
      ),
    );
  }
}

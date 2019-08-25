import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/pages/courses/about.dart';
import 'package:class_resources/pages/courses/assignments.dart';
import 'package:class_resources/pages/courses/resources.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatelessWidget {
  CourseDetail({@required this.model, this.tag});

  final CourseModel model;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;

    return Scaffold(
      key: PageStorageKey("Course Details"),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Material(
                color: Theme.of(context).primaryColorLight,
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Expanded(
                          child: Hero(
                            tag: tag,
                            child: Material(
                              color: Theme.of(context).primaryColorLight,
                              child: ListTile(
                                leading: TextAvatar(
                                  text: (model.title ?? "") +
                                      (model.klassName ?? ""),
                                ),
                                title: Text(model.title ?? ""),
                                subtitle: Text(
                                    "${model.klassName} - ${model.teacher}" ??
                                        ""),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 48),
                      child: Container(
                        child: Center(
                          child: TabBar(
                            isScrollable: true,
                            indicatorWeight: 3.0,
                            tabs: [
                              Tab(text: "Resources"),
                              Tab(text: "Assignments"),
                              Tab(text: "About"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                key: PageStorageKey("Course-${model.code}"),
                children: <Widget>[
                  CourseResources(model: model),
                  CourseAssignments(model: model),
                  CourseAbout(model: model),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

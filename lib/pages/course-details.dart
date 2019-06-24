import 'package:class_resources/components/course-resources.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseDetailPage extends StatefulWidget {
  CourseDetailPage({Key key, @required this.course}) : super(key: key);

  final DocumentSnapshot course;

  @override
  _CourseDetailPageState createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    final onPrimaryTextStyle =
        TextStyle(color: Theme.of(context).colorScheme.onPrimary);
    final onPrimaryTextStyleDull =
        TextStyle(color: Theme.of(context).colorScheme.onPrimary.withAlpha(170));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(75.0),
          child: Hero(
            tag: widget.course.data['code'],
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: textCircularAvatar(
                    widget.course.data['title'],
                    widget.course.data['color']
                  ),
                  title: Text(
                    widget.course.data['title'],
                    style: onPrimaryTextStyle,
                  ),
                  subtitle: Text(
                    "${widget.course.data['code']} - ${widget.course.data['teacher']}",
                    style: onPrimaryTextStyleDull,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: 48),
              child: Container(
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Center(
                  child: TabBar(
                    labelColor: Theme.of(context).colorScheme.onSurface,
                    isScrollable: true,
                    tabs: [
                      Tab(text: "Resources"),
                      Tab(text: "Assignments"),
                      Tab(text: "Stared"),
                      Tab(text: "About"),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  CourseResources(resources: widget.course.data['resources'],),
                  Center(
                    child: Text("data2"),
                  ),
                  Center(
                    child: Text("data3"),
                  ),
                  Center(
                    child: Text("About"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

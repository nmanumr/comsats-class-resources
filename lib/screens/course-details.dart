import 'package:class_resources/components/text-avatar.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  CourseScreen({Key key, @required this.code}) : super(key: key);

  final String code;

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
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
            tag: widget.code,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: textCircularAvatar('Descrete Structures'),
                  title: Text(
                    'Descrete Structures',
                    style: onPrimaryTextStyle,
                  ),
                  subtitle: Text(
                    "CSC103 - Muhammad Adnan",
                    style: onPrimaryTextStyleDull,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
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
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Center(
                    child: Text("data1"),
                  ),
                  Center(
                    child: Text("data2"),
                  ),
                  Center(
                    child: Text("data3"),
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

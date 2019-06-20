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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
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
                color: Theme.of(context).primaryColorDark,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text("DS"),
                  ),
                  title: Text('Descrete Structures'),
                  subtitle: Text("CSC103 - Muhammad Adnan"),
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
                      color: Theme.of(context)
                          .primaryIconTheme
                          .color
                          .withAlpha(30),
                    ),
                  ),
                ),
                child: Center(
                  child: TabBar(
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

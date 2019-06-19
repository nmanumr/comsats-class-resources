import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  final numIter = 6;

  @override
  bool get wantKeepAlive => true;

  Widget _buildRow(int i) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: CircleAvatar(
            child: Text("DS"),
          ),
          title: Text('Descrete Structures'),
          subtitle: Text("CSC103 - Muhammad Adnan"),
        ),
      ),
      color: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: numIter * 2,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (BuildContext ctx, int i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2 + 1;
        return _buildRow(index);
      },
    );
  }
}

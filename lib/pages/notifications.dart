import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with AutomaticKeepAliveClientMixin<NotificationsScreen> {
  @override
  bool get wantKeepAlive => true;

  final numIter = 5;

  Widget _buildRow(int i) {
    return Material(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          isThreeLine: true,
          leading: Icon(Icons.add_alert),
          title: Text('PPIT Assignment'),
          subtitle: Text("New PPIT Assignment has been added\nAdded by: Nauman Umer"),

        ),
      ),
      color: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
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

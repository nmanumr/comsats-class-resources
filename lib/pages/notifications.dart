import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Widget _buildRow(AppNotification notification, num index) {
    return Dismissible(
      key: Key(notification.hashCode.toString()),
      onDismissed: (_) {
        NotificationModel.instance.removeNotification(index);
      },
      child: ListTile(
        leading: Icon(Icons.notifications),
        title: Text(notification.title ?? ""),
        subtitle: Text(notification.body ?? ""),
      ),
      background: Container(
        color: Theme.of(context).accentColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[Icon(Icons.delete), Icon(Icons.delete)],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNotifications(NotificationModel model) {
    List<Widget> children = [];
    if (model.notifications.length > 0) {
      children.add(ListHeader(text: "Notifications"));
    }
    for (num i = model.notifications.length - 1; i >= 0; i--) {
      children.add(_buildRow(model.notifications[i], i));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: NotificationModel.instance,
      child: Scaffold(
        appBar: centeredAppBar(context, "Notifications"),
        body: ScopedModelDescendant<NotificationModel>(
          builder: (context, child, model) {
            if (model.notifications.length == 0)
              return Padding(
                padding: EdgeInsets.only(top: 60),
                child: IllustartedPage(
                  imagePath: "assets/images/chore_list.png",
                  headingText: "No Notification",
                ),
              );
            return ListView(
              children: <Widget>[
                ..._buildNotifications(model),
              ],
            );
          },
        ),
      ),
    );
  }
}

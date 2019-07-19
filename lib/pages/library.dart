import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final String name = "Nauman Umer";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Menu"),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: TextAvatar(
                      text: name,
                      color: Theme.of(context).accentColor
                    ),
                    title: Text(name),
                    subtitle: Text("FA18-BCS-162"),
                  ),
                  ListTile(
                    title: Text("Update Profile"),
                    leading: Icon(Icons.person),
                    onTap: (){
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  ListTile(
                    title: Text("Update Email"),
                    leading: Icon(Icons.email),
                    onTap: (){},
                  ),
                  ListTile(
                    title: Text("Change Password"),
                    leading: Icon(Icons.vpn_key),
                    onTap: (){},
                  ),
                  ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.exit_to_app),
                    onTap: (){},
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Share this app"),
                    leading: Icon(Icons.share),
                    onTap: (){},
                  ),
                  ListTile(
                    title: Text("Privacy Polices"),
                    leading: Icon(Icons.info),
                    onTap: (){},
                  ),
                  ListTile(
                    title: Text("About"),
                    leading: Icon(Icons.info),
                    onTap: (){},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

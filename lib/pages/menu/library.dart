import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LibraryPage extends StatelessWidget {
  final String name = "Nauman Umer";

  ListTile profileTile(BuildContext ctx, ProfileModel model) {
    if ((model.name ?? "").isEmpty) {
      return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Theme.of(ctx).accentColor,
        ),
        title: Text("Your Name", style: TextStyle(fontStyle: FontStyle.italic)),
        subtitle: Text(
          "Roll Number",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    } else {
      return ListTile(
        leading: TextAvatar(text: name),
        title: Text(model.name),
        subtitle: Text(model.rollNum),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Menu"),
      body: Container(
        child: ScopedModelDescendant<ProfileModel>(
          builder: (context, child, model) => Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    profileTile(context, model),
                    ListTile(
                      title: Text("Update Profile"),
                      leading: Icon(Icons.person),
                      onTap: () {
                        Navigator.pushNamed(context, '/edit-profile');
                      },
                    ),
                    ListTile(
                      title: Text("Update Email"),
                      leading: Icon(Icons.email),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("Change Password"),
                      leading: Icon(Icons.vpn_key),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      title: Text("Share this app"),
                      leading: Icon(Icons.share),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("Source Code"),
                      leading: Icon(Icons.code),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("More Apps"),
                      leading: Icon(Icons.apps),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text("License"),
                      leading: Icon(Icons.receipt),
                      onTap: ()=> Navigator.pushNamed(context, '/license'),
                    ),
                    ListTile(
                      title: Text("Privacy Policy"),
                      leading: Icon(Icons.security),
                      onTap: () => Navigator.pushNamed(context, '/privacypolicy'),
                    ),
                    ListTile(
                      title: Text("About App"),
                      leading: Icon(Icons.info_outline),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: "COMSATS Class Resources",
                        applicationVersion: "v0.1",
                        applicationLegalese: "(c) 2019 Nauman Umer",
                        applicationIcon: Image.asset("assets/images/logo.png", width: 50),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

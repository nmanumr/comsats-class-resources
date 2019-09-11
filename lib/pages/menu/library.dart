import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/components/theme-chooser.dart';
import 'package:class_resources/models/theme.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:class_resources/pages/auth/update-profile.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryPage extends StatelessWidget {
  final UserModel user;
  LibraryPage(this.user);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ListTile profileTile(BuildContext ctx) {
    if ((user.profile.name ?? "").isEmpty) {
      return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Theme.of(ctx).accentColor,
        ),
        title: Text("Your Name", style: TextStyle(fontStyle: FontStyle.italic)),
        subtitle: Text(
          "Your Email",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    } else if (user.photoUrl != null) {
      return ListTile(
        leading: TextAvatar(text: user.profile.name, photoUrl: user.photoUrl),
        title: Text(user.profile.name),
        subtitle: Text(user.email ?? " "),
      );
    } else {
      return ListTile(
        leading: TextAvatar(text: user.profile.name),
        title: Text(user.profile.name),
        subtitle: Text(user.email ?? " "),
      );
    }
  }

  List<Widget> profileActions(context) {
    List<Widget> actions = [
      profileTile(context),
      ListTile(
        title: Text("Update Profile"),
        leading: Icon(Icons.person),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UpdateProfile(
                profile: user.profile,
              ),
            ),
          );
        },
      ),
    ];

    if (!user.hasProvider("google.com")) {
      actions.addAll([
        ListTile(
          title: Text("Update Email"),
          leading: Icon(Icons.email),
          onTap: () => Navigator.pushNamed(context, '/changeEmail'),
        ),
        ListTile(
          title: Text("Change Password"),
          leading: Icon(Icons.vpn_key),
          onTap: () => Navigator.pushNamed(context, '/changepass'),
        ),
      ]);
    }

    actions.add(ListTile(
      title: Text("Logout"),
      leading: Icon(Icons.exit_to_app),
      onTap: () {
        user.service.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
      },
    ));

    return actions;
  }

  void showChooser(context) {
    var _themeModel = ThemeModel();
    showDialog<void>(
        context: context,
        builder: (context) {
          return ThemeSwitcherDialog(themeModel: _themeModel);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Menu"),
      body: Container(
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) => Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ...profileActions(context),
                    Divider(),
                    ListTile(
                      title: Text("Share this app"),
                      leading: Icon(Icons.share),
                      onTap: () => Share.plainText(
                        text:
                            'Hi, checkout this Class Resource Management app https://ccrr.page.link/app',
                      ).share(),
                    ),
                    ListTile(
                      title: Text("Source Code"),
                      leading: Icon(Icons.code),
                      onTap: () => _launchURL(
                        "https://github.com/nmanumr/comsats-class-resources",
                      ),
                    ),
                    ListTile(
                      title: Text("More Apps"),
                      leading: Icon(Icons.apps),
                      onTap: () => _launchURL(
                        "https://play.google.com/store/apps/developer?id=A-Plus+Developers",
                      ),
                    ),
                    ListTile(
                      title: Text("License"),
                      leading: Icon(Icons.receipt),
                      onTap: () => Navigator.pushNamed(context, '/license'),
                    ),
                    ListTile(
                      title: Text("Privacy Policy"),
                      leading: Icon(Icons.security),
                      onTap: () =>
                          Navigator.pushNamed(context, '/privacypolicy'),
                    ),
                    // ListTile(
                    //   title: Text("Theme"),
                    //   leading: Icon(Icons.format_paint),
                    //   onTap: (){
                    //     showChooser(context);
                    //   },
                    // ),
                    ListTile(
                      title: Text("About App"),
                      leading: Icon(Icons.info_outline),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: "COMSATS Class Resources",
                        applicationVersion: "v1.2",
                        applicationLegalese: "(c) 2019 Nauman Umer",
                        applicationIcon:
                            Image.asset("assets/images/logo.png", width: 50),
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

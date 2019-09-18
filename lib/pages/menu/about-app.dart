import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:class_resources/flutter_version.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  bool isLoading = true;
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      this.packageInfo = packageInfo;
      setState(() => isLoading = false);
    });
  }

  paddedList(title, subtitle) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(title),
      ),
      subtitle: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(subtitle),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "About App"),
      body: isLoading
          ? Loader()
          : ListView(
              children: <Widget>[
                paddedList(
                  packageInfo.appName,
                  "Version: ${packageInfo.version}",
                ),
                paddedList("Build Number", packageInfo.buildNumber),
                paddedList("Copyright", "2019 - 2022 Nauman Umer"),
                paddedList("License", "GNU GPL v3.0"),
                ListHeader(text: "Flutter"),
                paddedList("Flutter version", version["frameworkVersion"]),
                paddedList("Flutter SDK channel", version["channel"]),
                paddedList("Dart SDK version", version["dartSdkVersion"]),
              ],
            ),
    );
  }
}

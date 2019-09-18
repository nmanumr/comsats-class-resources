import 'dart:convert';

import 'package:class_resources/components/text-avatar.dart';
import 'package:http/http.dart' as http;
import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorsList extends StatefulWidget {
  @override
  _AuthorsListState createState() => _AuthorsListState();
}

class _AuthorsListState extends State<AuthorsList> {
  bool isLoading = true;
  var authors = [];

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  _fetchPost() async {
    try {
      final response = await http.get(
          'https://api.github.com/repos/nmanumr/comsats-class-resources/contributors');

      setState(() {
        authors = json.decode(response.body);
        isLoading = false;
      });
    } catch (e) {}
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget authorTile(author) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(author["avatar_url"]),
          backgroundColor: Colors.white),
      title: Text(author["login"]),
      subtitle: Text("${author["contributions"]} contributions"),
      trailing: Icon(Icons.open_in_new),
      onTap: () =>
          _launchURL("https://github.com/nmanumr/comsats-class-resources"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Authors"),
      body: isLoading
          ? Loader()
          : ListView(
              children: authors.map((e) => authorTile(e)).toList(),
            ),
    );
  }
}

import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';

class AppLicensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "App License"),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
            child: Text(
              "This app uses GNU GPL v3 license, summary of which is given below:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ListHeader(text: "Permissions"),
          ListTile(
            leading: Icon(Icons.done, color: HexColor("#0ec254")),
            title: Text("Commercial use"),
            subtitle: Text("This software and derivatives may be used for commercial purposes."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.done, color: HexColor("#0ec254")),
            title: Text("Modification"),
            subtitle: Text("This software may be modified."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.done, color: HexColor("#0ec254")),
            title: Text("Distribution"),
            subtitle: Text("This software may be distributed."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.done, color: HexColor("#0ec254")),
            title: Text("Patent use"),
            subtitle: Text("This license provides an express grant of patent rights from contributors."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.done, color: HexColor("#0ec254")),
            title: Text("Private use"),
            subtitle: Text("This software may be used and modified in private."),
            isThreeLine: true,
          ),
          ListHeader(text: "Limitations"),
          ListTile(
            leading: Icon(Icons.close, color: HexColor("#f04141")),
            title: Text("Liability"),
            subtitle: Text("This license includes a limitation of liability."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.close, color: HexColor("#f04141")),
            title: Text("Warranty"),
            subtitle: Text("The license explicitly states that it does NOT provide any warranty."),
            isThreeLine: true,
          ),
          ListHeader(text: "Conditions"),
          ListTile(
            leading: Icon(Icons.error_outline, color: HexColor("#3171e0")),
            title: Text("License and copyright notice"),
            subtitle: Text("A copy of the license and copyright notice must be included with the software."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.error_outline, color: HexColor("#3171e0")),
            title: Text("State changes"),
            subtitle: Text("Changes made to the code must be documented."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.error_outline, color: HexColor("#3171e0")),
            title: Text("Disclose source"),
            subtitle: Text("Source code must be made available when the software is distributed."),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.error_outline, color: HexColor("#3171e0")),
            title: Text("Same license"),
            subtitle: Text("Modifications must be released under the same license when distributing the software. In some cases a similaror related license may be used."),
            isThreeLine: true,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.open_in_new),
            title: Text("Open full license"),
            onTap: ()=>{},
          ),
          Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text(""),
          )
        ],
      ),
    );
  }
}

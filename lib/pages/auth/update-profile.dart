import 'package:class_resources/components/buttons.dart';
import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/illustrated-form.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/class.model.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:class_resources/utils/route-transition.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:class_resources/components/input.dart';
import 'package:scoped_model/scoped_model.dart';

import 'change-class.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({
    @required this.profile,
    this.navigateToDashboard = false,
  });

  final ProfileModel profile;

  /// if true will navigate to dashboard Route
  /// otherwise just closes itself
  final bool navigateToDashboard;

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MaskedTextController _rollumController =
      MaskedTextController(mask: 'AA00-AAA-000');
  TextEditingController _nameController = TextEditingController();
  bool isLoading = false;

  void onError(err) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('${err.message}'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }

  void submit() async {
    setState(() => isLoading = true);
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await widget.profile.service.updateProfile(
          rollNum: _rollumController.text.toUpperCase(),
          name: _nameController.text,
        );
        setState(() => isLoading = false);
        if (widget.navigateToDashboard)
          Navigator.push(
            context,
            EnterExitRoute(
              exitPage: this.widget,
              enterPage: ChangeClass(widget.profile, navigateToDashboard: true),
            ),
          );
        else
          Navigator.pop(context);
      } catch (e) {
        setState(() => isLoading = true);
        onError(e);
      }
    }
  }

  Widget buildClassTile() {
    return ScopedModel(
      model: widget.profile.klass,
      child: ScopedModelDescendant<KlassModel>(
        builder: (context, _, model) {
          if (model.isLoading) {
            return Loader();
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: OutlineButton(
              // padding: EdgeInsets.fromLTRB(20, 15, 10, 15),
              child: SizedBox(
                width: double.infinity,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.class_),
                    backgroundColor: HexColor(generateColor(model.name)),
                    foregroundColor: Colors.white,
                  ),
                  title: Text(model.name),
                  subtitle: Text("CR: " + model.cr ?? ""),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeClass(widget.profile),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: centeredAppBar(context,
          widget.navigateToDashboard ? "Create Profile" : "Update Profile"),
      body: illustratedForm(
          key: _formKey,
          imagePath: "assets/images/profile.png",
          isLoading: isLoading,
          children: [
            PaddedInput(
              label: "Your Name",
              initialValue: widget.profile.name,
              controller: _nameController,
              validator: nameValidator,
            ),
            PaddedInput(
              label: "Your Roll Number",
              initialValue: widget.profile.rollNum,
              controller: _rollumController,
              validator: rollNumValidator,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(" "),
                  RaisedButton.icon(
                    icon: Icon(widget.navigateToDashboard
                        ? Icons.keyboard_arrow_right
                        : Icons.check),
                    label: Text(widget.navigateToDashboard ? "Next" : "Save"),
                    onPressed: submit,
                  ),
                ],
              ),
            ),
            ...(widget.profile.klass != null
                ? [ListHeader(text: "Your Class"), buildClassTile()]
                : []),
            ...(widget.profile.klass == null && !widget.navigateToDashboard
                ? [
                    ListHeader(text: "Your Class"),
                    EmptyState(
                      text: "No class selected",
                      button: PrimaryFlatButton(
                        child: Text("Select Class"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChangeClass(widget.profile),
                            ),
                          );
                        },
                      ),
                    )
                  ]
                : []),
          ],
          primaryButton: Text("")),
    );
  }
}

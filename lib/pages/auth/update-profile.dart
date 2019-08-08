import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/utils/validator.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:class_resources/models/profile.dart';
import 'package:class_resources/components/input.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  var controller = MaskedTextController(mask: 'AA00-AAA-000');

  String name = "";
  String rollNum = "";
  String klass = "";
  List<String> _klasses = <String>[
    '',
    'FA18-BCS-A',
    'FA18-BCS-B',
    'FA18-BCS-C',
    'FA18-BCS-D',
    'FA18-BCS-E'
  ];

  void onError(ctx, err) {
    Scaffold.of(ctx).showSnackBar(
      SnackBar(
        content: Text('${err.message}'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      ),
    );
  }

  void onSubmit(ctx, ProfileModel model) async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await model.updateProfile(
          name: name,
          rollNum: rollNum,
          klass: klass,
        );
        Navigator.pop(ctx);
      } catch (e) {
        onError(ctx, e);
      }
    }
  }

  Widget classesDropDown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: FormField(
        validator: (_) {
          return (klass ?? "") != '' ? null : 'Field can not be empty';
        },
        builder: (FormFieldState state) {
          return InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Classes',
              errorText: state.hasError ? state.errorText : null,
            ),
            isEmpty: klass == '' || klass == null,
            child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                value: klass,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    klass = newValue;
                  });
                },
                items: _klasses.map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: ProfileModel(),
      child: Scaffold(
        appBar: centeredAppBar(context, "Profile"),
        body: ScopedModelDescendant<ProfileModel>(
          builder: (context, child, model) {
            controller.text = model.rollNum;
            var nameCtrl = TextEditingController(text: model.name);
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: <Widget>[
                    PaddedInput(
                      label: "Your Name",
                      validator: notEmptyValidator,
                      controller: nameCtrl,
                      onSave: (val) => setState(() => name = val),
                    ),
                    PaddedInput(
                      label: "Roll Number (AA00-AAA-000)",
                      validator: notEmptyValidator,
                      controller: controller,
                      onSave: (val) => setState(() => rollNum = val),
                    ),
                    classesDropDown(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Builder(builder: (ctx) {
                        return Row(
                          children: <Widget>[
                            Expanded(child: Center()),
                            RaisedButton(
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 25.0),
                              onPressed: () => onSubmit(context, model),
                              child: Text('Update'),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

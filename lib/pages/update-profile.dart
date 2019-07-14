import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import 'package:class_resources/models/profile.dart';
import 'package:class_resources/services/authentication.dart';
import 'package:class_resources/components/paddedInput.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();
  var controller = new MaskedTextController(mask: 'AA00-AAA-000');

  Profile profile = Profile();

  String klass;
  List<String> _klasses = <String>[
    '',
    'FA18-BCS-A',
    'FA18-BCS-B',
    'FA18-BCS-C',
    'FA18-BCS-D',
    'FA18-BCS-E'
  ];

  String notEmptyValidator(String val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
  }

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

  void onSubmit(ctx) async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        await ScopedModel.of<ProfileModel>(context).updateProfile(
          name: profile.name,
          rollNum: profile.rollNum,
          klass: profile.klass,
        );
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
                    profile.klass = newValue;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: <Widget>[
              PaddedInput(
                label: "Your Name",
                validator: notEmptyValidator,
                controller: TextEditingController()..text = profile.name,
                onChanged: (val) => profile.name = val,
                onSave: (val) => profile.name = val,
              ),
              PaddedInput(
                label: "Roll Number (AA00-AAA-000)",
                validator: notEmptyValidator,
                controller: controller,
                onSave: (value) => profile.rollNum = value,
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
                        onPressed: () => onSubmit(context),
                        child: Text('Update'),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

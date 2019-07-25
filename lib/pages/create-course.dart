import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/services/class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CreateCourse extends StatefulWidget {
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  final _formKey = GlobalKey<FormState>();
  KlassService klassService = KlassService();
  final courseCodeCtrl = MaskedTextController(mask: 'AAA000');
  final tCreditHourseCtrl = MaskedTextController(mask: '0');
  final lCreditHourseCtrl = MaskedTextController(mask: '0');

  List<Option> klasses = [];
  List<Option> semesters = [];
  bool isLoading = true;

  String title = "";
  String code = "";
  int theroyCh = 0;
  int labCh = 0;
  String teacher = "";
  String klass = "";
  String semester = "";

  String notEmptyValidator(val) {
    return (val ?? "") != '' ? null : 'Field can not be empty';
  }

  setSelectedClass(String val) {
    setState(() {
      klass = val;
      isLoading = true;
    });

    var stream;
    stream = klassService.getClassSemesters(klass).listen((data) {
      setState(() {
        semesters = data.documents
            .map((doc) =>
                Option(text: doc.data["name"], val: doc.reference.path))
            .toList();
        isLoading = false;
        stream.cancel();
      });
    });
  }

  getSemesterDropDown() {
    if (semesters.length == 0) return Text("");

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: SelectField(
        // validator: notEmptyValidator,
        label: "Semester",
        options: semesters,
        onChanged: (val) => setState(() => semester = val),
      ),
    );
  }

  getClassDropDown() {
    if (klasses.length == 0) return Text("");

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: SelectField(
        // validator: notEmptyValidator,
        label: "Classes",
        options: klasses,
        onChanged: setSelectedClass,
      ),
    );
  }

  onSumbit() {
    _formKey.currentState.save();
    // if (_formKey.currentState.validate()) {
      print("fsdfsdfsd");
      klassService.createCourse(
        title: title,
        creditHours: "${labCh + theroyCh}($theroyCh, $labCh)",
        code: code,
        klass: klass,
        semester: semester,
        teacher: teacher,
      );
    // }
  }

  @override
  Widget build(BuildContext context) {
    var stream;
    stream = klassService.getAllClasses().listen((val) {
      setState(() {
        klasses = val.documents
            .map((doc) =>
                Option(text: doc.data["name"], val: doc.reference.path))
            .toList();
        isLoading = false;
        stream.cancel();
      });
    });

    return Scaffold(
      appBar: centeredAppBar(context, "Add Course"),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            isLoading ? LinearProgressIndicator() : Text(""),
            PaddedInput(
              label: "Title",
              // validator: notEmptyValidator,
              onChanged: (val) => setState(() => title = val),
              inputType: TextInputType.text,
              // errorText: ,
            ),
            PaddedInput(
              label: "Code",
              // validator: notEmptyValidator,
              onSave: (val) => setState(() => code = val),
              inputType: TextInputType.text,
              controller: courseCodeCtrl,
            ),
            PaddedInput(
              label: "Theory credit hours",
              // validator: notEmptyValidator,
              onChanged: (val) => setState(() => theroyCh = int.parse(val)),
              inputType: TextInputType.number,
              controller: tCreditHourseCtrl,
            ),
            PaddedInput(
              label: "Lab credit hours",
              // validator: notEmptyValidator,
              onChanged: (val) => setState(() => labCh = int.parse(val)),
              inputType: TextInputType.number,
              controller: lCreditHourseCtrl,
            ),
            PaddedInput(
              label: "Teacher",
              // validator: notEmptyValidator,
              onChanged: (val) => setState(() => teacher = val),
              inputType: TextInputType.text,
            ),
            getClassDropDown(),
            getSemesterDropDown(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(" "),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                  onPressed: onSumbit,
                  child: Text('Create Class'),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

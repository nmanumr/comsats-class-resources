import 'dart:async';

import 'package:class_resources/components/buttons.dart';
import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/illustrated-page.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/semester.model.dart';
import 'package:class_resources/models/task.model.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_utils/date_utils.dart';

class HomePage extends StatefulWidget {
  final ProfileModel userProfile;

  HomePage({this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List hashs = [];
  List<TaskModel> events = [];
  List<StreamSubscription> subscriptions = [];
  bool isLoading = true;

  @override
  void dispose() {
    for (var sub in this.subscriptions) {
      sub.cancel();
    }
    hashs = [];
    super.dispose();
  }

  void loadData() {
    var semester = widget.userProfile.service.getCurrentSemester();
    if (semester != null && events.isEmpty) _fetchTasks(semester);
  }

  _fetchTasks(SemesterModel semester) {
    for (var course in semester.courses) {
      subscriptions.add(
        course.service.getCourseTasks().listen((data) {
          setState(() {
            isLoading = false;
            for (var task in data) {
              if (hashs.contains(task.title)) continue;

              hashs.add(task.title);
              events.add(task);
            }
          });
        }),
      );
    }
  }

  DateTime dateTimeFromTime(TimeOfDay t) {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  _humanize(TimeOfDay t) {
    return """
      ${t.hour % 12}:
      ${t.minute < 10 ? (t.minute.toString() + "0") : t.minute}
      ${t.hour > 12 ? "PM" : "AM"}
    """
        .replaceAll("\n", " ")
        .replaceAll(RegExp(r'\s+'), " ");
  }

  Widget _taskTile(TaskModel model) {
    return ListTile(
      leading: CircleAvatar(
          child: Icon(model.getIcon()),
          backgroundColor: HexColor(generateColor(model.title)).withAlpha(130),
          foregroundColor: Colors.white),
      title: Text(model.title),
      subtitle:
          Text(DateFormat("EEE, MMMM d, yyyy (h:m a)").format(model.dueDate)),
      onTap: () {},
    );
  }

  int _compareTasks(TaskModel t1, TaskModel t2) {
    return t1.dueDate.isBefore(t2.dueDate) ? -1 : 1;
  }

  List<Widget> getDayEventTiles(int i) {
    var date = DateTime.now().add(Duration(days: i));
    return (events.where((e) => Utils.isSameDay(date, e.dueDate)).toList()
          ..sort(_compareTasks))
        .map(_taskTile)
        .toList();
  }

  Widget noSubjectView() {
    return EmptyState(
      icon: Icons.library_books,
      text: "No course added",
      button: PrimaryFlatButton(
        child: Text("Add Courses"),
        onPressed: () {},
      ),
    );
  }

  Widget noEventView() {
    return IllustartedPage(
      imagePath: "assets/images/chore_list.png",
      headingText: "All Set",
      subheadingText: "No task pending",
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: widget.userProfile,
      child: ScopedModelDescendant<ProfileModel>(
        builder: (context, child, model) {
          return Scaffold(
            key: PageStorageKey('home'),
            appBar: centeredAppBar(context, "Tasks"),
            body: Builder(
              builder: (context) {
                if (model.status == ProfileStatus.LoadingSemesters ||
                    model.status == ProfileStatus.Loading) return Loader();

                if (model.semesters.isEmpty) return noSubjectView();

                if (events.isEmpty && !isLoading) return noEventView();

                if (events.isEmpty && isLoading) {
                  loadData();
                  return Loader();
                }

                var sortedEvents = events..sort(_compareTasks);
                return ListView.builder(
                  itemCount: sortedEvents.last.dueDate
                          .difference(DateTime.now())
                          .inDays +
                      3,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      return isLoading
                          ? LinearProgressIndicator()
                          : SizedBox(height: 6);
                    }

                    var events = getDayEventTiles(i - 1);
                    if (events.isEmpty) return SizedBox();

                    return Column(children: [
                      ListHeader(
                          text: DateFormat("EEEE, MMM d").format(
                              DateTime.now().add(Duration(days: i - 1)))),
                      ...events
                    ]);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

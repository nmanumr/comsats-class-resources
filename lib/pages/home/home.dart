import 'dart:async';

import 'package:class_resources/components/buttons.dart';
import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/components/text-avatar.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/semester.model.dart';
import 'package:class_resources/models/task.model.dart';
import 'package:class_resources/pages/timetable/event-detail.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final ProfileModel userProfile;

  HomePage({this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> todayEvents = [];
  List<EventModel> tomorrowEvents = [];
  List hashs = [];
  List<TaskModel> tasks = [];

  List<StreamSubscription> subscriptions = [];

  bool isLoading = true;

  _fetchTasks(SemesterModel semester) {
    for (var course in semester.courses) {
      subscriptions.add(
        course.service.getCourseTasks().listen((data) {
          isLoading = false;
          setState(() {
            for (var task in data) {
              if (hashs.contains(task.title)) continue;

              hashs.add(task.title);
              tasks.add(task);
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

  _fetchLectures(SemesterModel semester) {
    for (var course in semester.courses) {
      subscriptions.add(course.service.getTimetable().listen(
        (data) {
          setState(() {
            isLoading = false;
            for (var event in data) {
              if (hashs.contains(event.title)) continue;

              var now = DateTime.now();
              hashs.add(event.title);

              if (event.weekday == now.weekday &&
                  dateTimeFromTime(event.startTime).isAfter(now))
                todayEvents.add(event);
              else if (event.weekday - 1 == now.weekday)
                tomorrowEvents.add(event);
            }
          });
        },
      ));
    }
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

  Widget _eventTile(EventModel model) {
    return ListTile(
      leading: TextAvatar(
          text: model.title.replaceAll(RegExp(r"^\s*\(\w+\)\s*"), "")),
      title: Text(model.title ?? ""),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("${_humanize(model.startTime)} -- ${_humanize(model.endTime)}"),
          Text(model.location ?? ''),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetails(model: model),
          ),
        );
      },
    );
  }

  int _compareClasses(EventModel e1, EventModel e2) {
    return e1.startTime.hour < e2.startTime.hour ? -1 : 1;
  }

  int _compareTasks(TaskModel t1, TaskModel t2) {
    return t1.dueDate.isBefore(t2.dueDate) ? -1 : 1;
  }

  Widget getEmptyState() {
    return EmptyState(
      icon: Icons.library_books,
      text: "No course added",
      button: PrimaryFlatButton(
        child: Text("Add Courses"),
        onPressed: () {},
      ),
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
            appBar: centeredAppBar(context, "Home"),
            body: Builder(
              builder: (context) {
                if (model.status == ProfileStatus.LoadingSemesters ||
                    model.status == ProfileStatus.Loading) return Loader();

                if (model.semesters.isEmpty) return getEmptyState();

                var semester = widget.userProfile.service.getCurrentSemester();
                if (semester != null) {
                  if (todayEvents.isEmpty && tomorrowEvents.isEmpty)
                    _fetchLectures(semester);
                  if (tasks.isEmpty) _fetchTasks(semester);
                }

                return ListView(
                  children: [
                    isLoading ? LinearProgressIndicator() : SizedBox(height: 6),
                    ...(tasks.isNotEmpty
                        ? [
                            ListHeader(text: "My Tasks"),
                            ...(tasks..sort(_compareTasks))
                                .map(_taskTile)
                                .toList(),
                          ]
                        : []),
                    ...(todayEvents.isNotEmpty
                        ? [
                            ListHeader(text: "Today Classes"),
                            ...(todayEvents..sort(_compareClasses))
                                .map(_eventTile)
                                .toList()
                          ]
                        : []),
                    ...(tomorrowEvents.isNotEmpty
                        ? [
                            ListHeader(text: "Tommorrow Classes"),
                            ...(tomorrowEvents..sort(_compareClasses))
                                .map(_eventTile)
                                .toList()
                          ]
                        : []),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

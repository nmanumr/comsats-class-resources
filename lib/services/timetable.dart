/// Time table service that save all the
/// events to a local file for widget to access
/// 
/// File path: $application_directory/timetable.enc
/// 
/// JSON Properties:
/// - status: "success" | "loggedOut" | "error"
/// - lastUpdate: file write time ie. 2019-10-11 00:25:39.543310
/// - error: "NO_USER" | "NO_PROFILE" (if status "error")
/// - eventsLength: lenght of events (if status "success")
/// - events: list of events (if status "success")
/// 
/// Each event have following properties:
/// - location: room of lecture
/// - teacher: teacher name
/// - eventSlot: lecture slot (will be between 1-7 for COMSATS)
/// - weekday: weekday strating from 1
/// - startTime: in hh:mm format where hh is between 0-23
/// - endTime: in hh:mm format where hh is between 0-23
/// - isLab: is lab lecture
/// - title: event title (Lab) included for lab events
/// - color: if event in "r, g, b" format

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:class_resources/app_widgets/timetable/timeTableAppWidget.dart';


class TimeTableService {
  List<StreamSubscription> subscriptions = [];
  List<EventModel> events = [];
  UserModel user;

  /// created when user model is initialized
  TimeTableService(this.user);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/timetable.enc');
  }

  /// Will be called each time when new data is loaded
  /// for user or profile
  void update() async {
    if(user.profile == null || user.profile.status == ProfileStatus.Loading || user.status == AccountStatus.LoggedOut)
      return;
    if (user.status == AccountStatus.LoggedOut) {
      return this.saveLoggedOut();
    } else if (user.status == AccountStatus.AuthError) {
      return this.saveError("NO_USER");
    } else if (user.profile.status == ProfileStatus.Error) {
      return this.saveError("NO_PROFILE");
    }

    var semester = this.user.profile.service.getCurrentSemester();
    if (semester == null) return;
    for (var course in semester.courses) {
      subscriptions.add(course.service.getTimetable().listen(
        (data) {
          this.events.addAll(data);
          this.saveEvents();
        },
      ));
    }
  }

  /// called when user profile is closed
  void dispose() {
    for (var sub in subscriptions) sub.cancel();
  }

  /// If a user have 6 courses this method
  /// will also be called 6 times
  void saveEvents() async {
    var eventsJson = json.encode({
      "status": "success",
      "lastUpdate": DateTime.now().toString(),
      "eventsLength": this.events.length,
      "events": this.events.map((e) => e.toJson()).toList()
    });
    final file = await _localFile;
    file.writeAsString(eventsJson);
    print("wrote");

    TimeTableAppWidget.refreshWidget();
  }

  void saveLoggedOut() async {
    var eventsJson = json.encode({
      "status": "loggedOut",
      "lastUpdate": DateTime.now().toString(),
    });
    final file = await _localFile;
    file.writeAsString(eventsJson);

    TimeTableAppWidget.refreshWidget();
  }

  void saveError(String error) async {
    var eventsJson = json.encode({
      "status": "error",
      "error": error,
      "lastUpdate": DateTime.now().toString(),
    });
    final file = await _localFile;
    file.writeAsString(eventsJson);

    TimeTableAppWidget.refreshWidget();
  }
}

import 'package:class_resources/models/event.dart';
import 'package:class_resources/models/profile.dart';
import 'package:scoped_model/scoped_model.dart';

class TimeTableModel extends Model {
  final ProfileModel user;
  bool isLoading = false;

  List<EventModel> events = [];

  TimeTableModel({this.user}) {
    loadEvents();
  }

  loadEvents() async {
    // var courses = user.getCurrentCourses();
    // for (var course in courses) {
    //   var courseEvents = await course.getAllEvents();
    //   events.addAll(courseEvents);
    //   notifyListeners();
    // }
  }
}

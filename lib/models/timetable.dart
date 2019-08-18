import 'package:meta/meta.dart';
import 'package:class_resources/models/event.dart';
import 'package:class_resources/models/profile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_utils/date_utils.dart';

class TimeTableModel extends Model {
  final ProfileModel user;
  bool isLoading = false;

  List<EventModel> events = [];

  TimeTableModel({@required this.user}) {
    loadEvents();
  }

  loadEvents() async {
    isLoading = true;
    events = [];
    notifyListeners();
    var courses = user.getCrntSemester()?.courses ?? [];
    for (var course in courses) {
      var courseEvents = await course.getAllEvents();
      events.addAll(courseEvents);

      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  List<EventModel> getEventForDay(DateTime date) {
    List<EventModel> crntEvents = [];
    for (var event in events) {
      var eventDate = event.startTime.toDate();

      // skip event if [date] is out of event start and end limits
      if (event.eventStart != null && date.isBefore(event.eventStart)) continue;
      if (event.eventEnd != null && date.isAfter(event.eventEnd)) continue;

      if (Utils.isSameDay(date, eventDate))
        crntEvents.add(event);
      else if (event.repeat == "weekly" && eventDate.weekday == date.weekday)
        crntEvents.add(event);
    }

    return crntEvents;
  }
}

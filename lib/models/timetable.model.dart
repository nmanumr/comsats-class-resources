import 'package:class_resources/mixins/firestore-service.mixin.dart';
import 'package:scoped_model/scoped_model.dart';

import 'course.model.dart';
import 'event.model.dart';

class TimetableModel extends Model with FirestoreServiceMixin {
  String name;
  DateTime startTime;
  DateTime endTime;

  bool isLoading = true;
  List<CourseModel> _courses;
  List<EventModel> classEvents;

  TimetableModel(List<CourseModel> courses){
    _courses = courses;
  }

  loadData(){
    for(var course in _courses){
      subscribeStream<List<EventModel>>(course.service.getTimetable(), (events){
        classEvents.addAll(events);
        notifyListeners();
      });
    }
  }
}

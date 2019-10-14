import 'package:class_resources/mixins/firestore-service.mixin.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:class_resources/models/task.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:path/path.dart' as p;

class CourseService with FirestoreServiceMixin {
  CourseModel model;
  DocumentReference ref;

  CourseService(this.model, this.ref) {
    subscribeDocument(this.ref.path, (doc) {
      model.loadData(doc.data);
    });
  }

  Stream<QuerySnapshot> relativeCollectionSnapsots(relativePath) {
    var path = p.join(this.ref.path, relativePath);
    return firestore.collection(path).orderBy("date").snapshots();
  }

  Stream<QuerySnapshot> getCourseResources() {
    return relativeCollectionSnapsots("resources");
  }

  Stream<QuerySnapshot> getCourseAssignments() {
    return relativeCollectionSnapsots("assignments");
  }

  Stream<List<TaskModel>> getCourseTasks() {
    var path = p.join(this.ref.path, "tasks");
    return firestore
        .collection(path)
        .where("dueDate", isGreaterThan: Timestamp.now())
        .snapshots()
        .map((data) => data.documents
            .map((task) => TaskModel.fromJson(task.data, this.model))
            .toList());
  }

  Stream<List<EventModel>> getTimetable() {
    var path = p.join(this.ref.path, "timetable");
    return firestore.collection(path).snapshots().map(
          (data) => data.documents
              .map(
                (eventDoc) => EventModel(
                  data: eventDoc.data,
                  eventType: EventType.ClassEvent,
                  ref: eventDoc.reference,
                  course: this.model,
                ),
              )
              .toList(),
        );
  }

  static createCourse({
    String title,
    String teacher,
    String creditHours,
    String code,
    String klass,
    String semester,
  }) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'addCourseToClass',
    );

    return await callable.call({
      "title": title,
      "creditHours": creditHours,
      "code": code,
      "klass": klass,
      "semester": semester,
      "teacher": teacher,
    });
  }
}

import 'package:class_resources/mixins/firestore-service.mixin.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/event.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
}

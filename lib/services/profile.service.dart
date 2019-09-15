import 'package:class_resources/mixins/firestore-service.mixin.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/semester.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ProfileService with FirestoreServiceMixin {
  ProfileModel model;

  ProfileService(UserModel user, this.model) {
    subscribeDocument("/users/${user.uid}", (doc) {
      model.loadData(doc.data);
    });
  }

  Future<void> refresh() async {
    await close();
    model.semesters = [];
    model.klass = null;
    subscribeDocument("/users/${model.user.uid}", (doc) {
      model.loadData(doc.data);
    });
  }

  /// return users lastest semester
  SemesterModel getCurrentSemester() {
    if (model.semesters == null) return null;

    for (var semester in model.semesters) {
      if (semester.isCurrent) return semester;
    }

    return null;
  }

  updateProfile({String rollNum, String name}) async {
    var uid = model.user.uid;
    DocumentReference profileRef = firestore.document("users/$uid");
    DocumentSnapshot document = await profileRef.get();

    profileUpdate(Map<String, dynamic> data) => document.exists
        ? profileRef.updateData(data)
        : profileRef.setData(data, merge: true);

    profileUpdate({
      "rollNum": rollNum,
      "id": uid,
      "name": name,
    });
  }

  @override
  Future<void> close() async {
    for (var semester in model.semesters) {
      await semester.close();
    }
    await model.klass.close();
    return await super.close();
  }

  changeClass(String klass) async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'syncUserCourses',
    );

    return await callable.call({
      "class": klass,
    });
  }
}

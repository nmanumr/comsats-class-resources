import 'package:class_resources/mixins/firestore-service.mixin.dart';
import 'package:class_resources/models/profile.model.dart';
import 'package:class_resources/models/semester.model.dart';
import 'package:class_resources/models/user.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService with FirestoreServiceMixin {
  ProfileModel model;

  ProfileService(UserModel user, this.model) {
    subscribeDocument("/users/${user.uid}", (doc) {
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

  updateProfile(rollNum, name) async {
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
}

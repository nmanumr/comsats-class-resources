import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { deleteCollection } from './utils';

admin.initializeApp();
const db = admin.firestore();

/**
 * Adds a course to class
 * @param data Course
 */
export const addCourseToClass = functions.https.onCall(async (data, _) => {
    const klass: string = data.klass;
    const klassName = klass.split("/").pop();
    const semester: string = data.semester;
    const semesterName = semester.split("/").pop();
    const courseRef = db.doc(`/subjects/${klassName}--${data.code}`);

    await courseRef.set({
        "code": data.code,
        "creditHours": data.creditHours,
        "class": db.doc(klass),
        "semester": db.doc(semester),
        "teacher": data.teacher,
        "title": data.title,
        "resources": []
    });

    return db.doc(`/classes/${klassName}/semesters/${semesterName}`).update({
        courses: admin.firestore.FieldValue.arrayUnion(courseRef)
    });
});


/**
 * Add course to user Profile
 */
export const addCourseToUser = functions.https.onCall(async (data, context) => {
    if (!context.auth) return;

    const courseRef = db.doc(data.course);
    const semester: string = data.semester;
    const userd: string = context.auth.uid;


    return db.doc(`/users/${userd}/semesters/${semester}`).set({
        name: semester,
        courses: admin.firestore.FieldValue.arrayUnion([courseRef])
    }, { merge: true });
});


/**
 * Synchronize user courses with user class courses
 */
export const syncUserCourses = functions.https.onCall(async (_, context) => {
    if (!context.auth) return;

    const userd: string = context.auth.uid;
    const user = await db.doc(`/users/${userd}/`).get();

    await deleteCollection(db, `/users/${userd}/semesters/`, 10);

    const snapshot = await db.collection(`${user.get("class")["path"]}/semesters/`).get();
    for (const doc of snapshot.docs) {
        await db.doc(`/users/${userd}/semesters/${doc.get("name")}/`).set(doc.data());
    }
});

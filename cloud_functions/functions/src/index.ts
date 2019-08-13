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
export const syncUserCourses = functions.https.onCall(async (data, context) => {
    if (!context.auth) return;
    if (!data['class']) return;

    const klassRef = db.doc(`/classes/${data['class']}`);
    const klass = await db.doc(`/classes/${data['class']}`).get();
    const userid: string = context.auth.uid;
    const semesters = await db.collection(`${klassRef.path}/semesters/`).get();

    await deleteCollection(db, `/users/${userid}/semesters/`, 10);

    for (const doc of semesters.docs) {
        await db.doc(`/users/${userid}/semesters/${doc.get("name")}/`).set(doc.data());
    }

    await db.doc(`/users/${userid}/`).update({
        "class": klassRef,
        "currentSemester": klass.get("currentSemester")
    })
});

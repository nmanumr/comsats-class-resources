import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { Course } from './models';

admin.initializeApp();
const db = admin.firestore();

/**
 * Adds a course to class
 * @param data {course: Course, klass: string, semester: string}
 */
export const addCourseToClass = functions.https.onCall(async (data, _) => {
    const course: Course = JSON.parse(data.course);
    const klass: string = data.klass;
    const semester: string = data.semester;

    const courseRef = await db.collection('/subjects').add(course);

    return db.doc(`/classes/${klass}/semesters/${semester}`).set({
        name: semester,
        courses: admin.firestore.FieldValue.arrayUnion([courseRef])
    }, { merge: true });
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
 * Invokes when new user is created
 */
// export const addUserProfile = functions.auth.user().onCreate((user) => {
//     return db.doc(`/users/${user.uid}`).set(<UserProfile>{
//         class: db.doc("/classes/null"),
//         email: user.email,
//         name: user.displayName,
//         id: user.uid,
//         profile_completed: false,
//         rollNum: ""
//     }, { merge: true })
// })
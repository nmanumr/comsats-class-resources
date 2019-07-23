import { firestore } from "firebase-admin";

export interface UserProfile {
    email: string;
    id: string;
    name: string;
    profile_completed: boolean;
    rollNum: string;
    class: firestore.DocumentReference;
}

export interface Class {
    name: string;
}

export interface Course {
    title: String;
    teacher: String;
    resources: firestore.DocumentReference[];
    creditHours: string;
    color: string;
    code: string;
    klass: firestore.DocumentReference;
}
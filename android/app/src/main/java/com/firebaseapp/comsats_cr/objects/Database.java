package com.firebaseapp.comsats_cr.objects;

import android.util.Log;

import com.firebaseapp.comsats_cr.interfaces.onCompleted;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreSettings;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.Source;

import java.util.ArrayList;
import java.util.Collections;

import static android.content.ContentValues.TAG;

public class Database{

    private static String uid;
    private static Query query;
    private static final ArrayList<DocumentReference> courseReference = new ArrayList<>(); // Static Variable to hold Reference of Courses
    private static final ArrayList<Event> timetableevents = new ArrayList<>(); // Static Timetable Holder for all Events

    public Database(){
        this(uid);
    }
    public Database(String uid) {
        Database.uid = uid;
        FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
                .setPersistenceEnabled(true)
                .setCacheSizeBytes(FirebaseFirestoreSettings.CACHE_SIZE_UNLIMITED)
                .build();
        FirebaseFirestore ff = FirebaseFirestore.getInstance();
        ff.setFirestoreSettings(settings);

        query =  ff.collection("users").document(uid).collection("semesters").whereEqualTo("isCurrent", true);
    }

    public void updateData(onCompleted listener, boolean hard){
        query.get(hard? Source.SERVER: Source.DEFAULT).addOnCompleteListener(task -> {
            if(task.isSuccessful() && task.getResult()!=null){
                courseReference.clear();
                for(DocumentSnapshot documentSnapshot: task.getResult()){
                    courseReference.addAll((ArrayList<DocumentReference>) documentSnapshot.get("courses"));
                    break;
                }
                getTimeTable(listener);
            }else
                Log.i(TAG, "syncCourses: Error Loading Courses");
        });
    }

    private ArrayList<Event> getTodaysEvents(){
        ArrayList<Event> events = new ArrayList<>();
        for (Event e: timetableevents)
            if (e.getWeekday() == Event.getCurrentWeekDay())
                events.add(e);
        return events;
    }
    private void getTimeTable(onCompleted listener){
        if(!courseReference.isEmpty()) {
            timetableevents.clear();
            for (DocumentReference DR : courseReference) {
                DR.get().addOnCompleteListener(_task -> {
                    if (_task.isSuccessful() && _task.getResult() != null) {
                        String subName = _task.getResult().getString("title");
                        DR.collection("timetable").get().addOnCompleteListener(task -> {
                            if (task.isSuccessful() && task.getResult() != null) {
                                for (DocumentSnapshot documentSnapshot : task.getResult().getDocuments()) {
                                    Event event = new Event();
                                    event.setSub(subName);
                                    event.setLoc(documentSnapshot.getString("location"));
                                    event.setStartTime(documentSnapshot.getString("startTime"));
                                    event.setEndTime(documentSnapshot.getString("endTime"));
                                    event.setLab(documentSnapshot.getBoolean("isLab"));
                                    event.setWeekday(documentSnapshot.getLong("weekday"));
                                    event.setTeacher(documentSnapshot.getString("teacher"));
                                    timetableevents.add(event);
                                    Collections.sort(timetableevents, new Event());
                                    listener.timetableReceived(getTodaysEvents());
                                }
                            }
                        });
                    }
                });
            }
        } else
            Log.i(TAG, "getTimeTable: No data in CourseReference");
    }
}
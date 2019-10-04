package com.firebaseapp.comsats_cr.objects;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreSettings;
import com.google.firebase.firestore.Query;
import java.util.ArrayList;
import java.util.Collections;

import static android.content.ContentValues.TAG;
import static android.content.Context.MODE_PRIVATE;

public class Database{

    private Context context;
    private final FirebaseFirestore ff;
    private String uid;
    private Query query;

    private static final ArrayList<DocumentReference> courseReference = new ArrayList<>(); // Static Variable to hold Reference of Courses
    private static final ArrayList<Event> timetableevents = new ArrayList<>(); // Static Timetable Holder for all Events


    public Database(Context context) {
        this.context = context;

        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
        FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
                .setPersistenceEnabled(true)
                .setCacheSizeBytes(FirebaseFirestoreSettings.CACHE_SIZE_UNLIMITED)
                .build();
        ff = FirebaseFirestore.getInstance();
        ff.setFirestoreSettings(settings);

        uid = prefs.getString("flutter.uid", "");
        if(uid.equals("")){
            //TODO:: handle null UID
        }else{
            query =  ff.collection("users").document(uid).collection("semesters").whereEqualTo("isCurrent", true);
        }
    }

    public ArrayList<Event> getTodaysEvents(){
        ArrayList<Event> events = new ArrayList<>();
        for (Event e: timetableevents)
            if (e.getWeekday() == Event.getCurrentWeekDay())
                events.add(e);
        return events;
    }
    private void syncCourses(){

    }
    private void getTimeTable(){
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
                                    timetableevents.add(event);
                                    Collections.sort(timetableevents, new Event());
                                }
                            }
                        });
                    }
                });
            }
        } else
            Log.i(TAG, "getTimeTable: No data in CourseReference");
    }
    public void updateData(Boolean hard){
        if(hard){
            //Get data from Server
            ff.enableNetwork().addOnCompleteListener(task -> {
                if (task.isSuccessful()){
                    getTimeTable();
                }else
                    Log.i(TAG, "updateData: EnableNetwork Failed!");
            });
        }else{
            // Get Cached Data
            ff.disableNetwork().addOnCompleteListener(task -> {
               if (task.isSuccessful()){
                    getTimeTable();
               }else{
                   Log.i(TAG, "updateData: DisableNetwork Failed!");
               }
            });
        }
    }
}
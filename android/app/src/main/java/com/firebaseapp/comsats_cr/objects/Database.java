package com.firebaseapp.comsats_cr.objects;

import android.util.Log;

import com.firebaseapp.comsats_cr.interfaces.OnCompleted;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.Source;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Objects;

import static android.content.ContentValues.TAG;

public class Database{

    private static Query query;
    private static final ArrayList<DocumentReference> courseReference = new ArrayList<>(); // Static Variable to hold Reference of Courses
    private static final ArrayList<Event> timeTableEvents = new ArrayList<>(); // Static Timetable Holder for all Events

    public Database(String uid) {
        /*
        FirebaseFirestoreSettings settings = new FirebaseFirestoreSettings.Builder()
                .setPersistenceEnabled(true)
                .setCacheSizeBytes(FirebaseFirestoreSettings.CACHE_SIZE_UNLIMITED)
                .build();
         */
        FirebaseFirestore ff = FirebaseFirestore.getInstance();
        //ff.setFirestoreSettings(settings);

        query =  ff.collection("users").document(uid).collection("semesters").whereEqualTo("isCurrent", true);
    }

    /**
     * Public Interface to trigger Fire-store Actions
     * @param listener Interface that notifies when action is completed
     * @param hard Notifies if cache is sufficient or New data should be fetched
     */
    synchronized public void updateData(OnCompleted listener, boolean hard){
        getCourseReferences(hard, () -> {
            if(!courseReference.isEmpty()) {
                timeTableEvents.clear();
                for (int i = 0, courseReferenceSize = courseReference.size(); i < courseReferenceSize; i++) {
                    DocumentReference DR = courseReference.get(i);
                    int finalI = i;
                    getName(DR, hard, subName ->
                            getEvents(DR, subName, hard, () -> {
                                if(finalI == courseReferenceSize-1)
                                    listener.timetableReceived(getTodayEvents());
                            })
                    );
                }
            } else
                Log.i(TAG, "getTimeTable: No data in CourseReference");
        });
    }

    /**
     * returns Events that are going to occur today
     * @return timetable of current day
     */
    synchronized private ArrayList<Event> getTodayEvents(){
        ArrayList<Event> events = new ArrayList<>();
        for (Event e: timeTableEvents)
            if (e.getWeekday() == Event.getCurrentWeekDay())
                events.add(e);
        return events;
    }

    @SuppressWarnings("unchecked")
    synchronized private void getCourseReferences(boolean hard, UpdateListener listener){
        query.get(hard? Source.DEFAULT: Source.CACHE).addOnCompleteListener(task -> {
            if(task.isSuccessful() && task.getResult()!=null){
                courseReference.addAll(
                        (ArrayList<DocumentReference>) Objects.requireNonNull(
                                task.getResult().getDocuments().get(0).get("courses")));
                listener.onUpdate();
            }
        });
    }
    synchronized private void saveData(String subName ,DocumentSnapshot DS){
        Event event = new Event();
        event.setSub(subName);
        event.setLoc(DS.getString("location"));
        event.setStartTime(DS.getString("startTime"));
        event.setEndTime(DS.getString("endTime"));
        event.setLab(DS.getBoolean("isLab"));
        event.setWeekday(Objects.requireNonNull(DS.getLong("weekday")));
        event.setTeacher(DS.getString("teacher"));
        timeTableEvents.add(event);
    }
    synchronized private void getName(DocumentReference DR, boolean hard , NameListener listener){
        DR.get(hard? Source.DEFAULT: Source.CACHE).addOnCompleteListener(task ->{
            if (task.isSuccessful() && task.getResult() != null) {
                String subName = task.getResult().getString("title");
                listener.onNameReceived(subName);
            }
        });
    }
    synchronized private void getEvents(DocumentReference DR, String subName, boolean hard, UpdateListener listener){
        DR.collection("timetable").get(hard? Source.DEFAULT: Source.CACHE).addOnCompleteListener(task ->{
            if(task.isSuccessful() && task.getResult()!=null){
                for (DocumentSnapshot DS : task.getResult().getDocuments()) {
                    saveData(subName, DS);
                }
                Collections.sort(timeTableEvents, new Event());
                listener.onUpdate();
            }
        });
    }

    private interface UpdateListener {
        void onUpdate();
    }
    private interface NameListener {
        void onNameReceived(String subName);
    }
}
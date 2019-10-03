package com.firebaseapp.comsats_cr.objects;


import android.content.Context;
import android.content.SharedPreferences;
import android.provider.CalendarContract;

import androidx.annotation.NonNull;

import com.firebaseapp.comsats_cr.widgets.TimeTableWidget;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.Calendar;

import static android.content.Context.MODE_PRIVATE;

public class Database{
    private Context context;
    private final FirebaseFirestore ff = FirebaseFirestore.getInstance();
    private String uid = "";

    private final Query query =  ff.collection("users").document(uid).collection("semesters").whereEqualTo("isCurrent", true);
    private ArrayList<DocumentReference> courceReference;
    private ArrayList<Event> timetableevents = new ArrayList<>();

    public Database(Context context) {
        this.context = context;
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
        uid = prefs.getString("flutter.uid", "");
        if(uid.equals("")){
            //TODO:: handle null UID
        }
    }

    /*
    public void getTimeTable(){
       query.get().addOnCompleteListener(task -> {
           if((task.isSuccessful()) && (task.getResult() != null)){
               //Parse Courses Reference List
               for (QueryDocumentSnapshot document : task.getResult()) {
                   courceReference = (ArrayList<DocumentReference>) document.get("courses");
                   break;
               }
               if(courceReference!=null){
                   for (DocumentReference dr: courceReference) {
                       Event x = new Event();
                       dr.get().addOnCompleteListener(task1 -> {
                           if(task1.isSuccessful() && task1.getResult()!= null){
                               x.setSub(task1.getResult().getString("title"));
                           }
                       });
                       dr.collection("timetable").whereEqualTo("weekday", Event.getCurrentWeekDay()).get().addOnCompleteListener(task2 -> {
                            if(task2.isSuccessful() && task2.getResult()!=null){
                               for (QueryDocumentSnapshot document: task2.getResult()) {
                                   Event y = new Event();
                                   y.setLoc(document.getString("location"));
                                   y.setStartTime(document.getString("startTime"));
                                   y.setEndTime(document.getString("endTime"));
                                   y.setSub(x.getSub() + (document.getBoolean("isLab")?" (Lab)":""));

                                   timetableevents.add(y);
                               }
                               TimeTableWidget.timetable.clear();
                               TimeTableWidget.timetable.addAll(timetableevents);
                               TimeTableWidget.sendRefreshBroadcast(context);
                            }
                       });
                   }
               }
           }
       });
    }
    */
}
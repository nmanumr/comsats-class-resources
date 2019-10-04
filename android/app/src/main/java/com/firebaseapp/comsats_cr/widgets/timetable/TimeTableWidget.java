package com.firebaseapp.comsats_cr.widgets.timetable;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

import com.firebaseapp.comsats_cr.interfaces.onCompleted;
import com.firebaseapp.comsats_cr.objects.Database;
import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.R;

import java.util.ArrayList;

import static android.content.Context.MODE_PRIVATE;

public class TimeTableWidget extends AppWidgetProvider {

    public static final ArrayList<Event> timetable = new ArrayList<>();
    private static Database db;

    public TimeTableWidget() { }

    private static Database getDbInstance(Context context){
        if(db==null)
            db = new Database(getUID(context));
        return db;
    }

    private static String getUID(Context context){
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE);
        String uid = prefs.getString("flutter.uid", "");
        //if(uid.equals(""))
        //TODO:: handle null UID

        //TEMP
        uid = "NEJaBszMj7cK86PTPD7rmmyZyYV2";
        return uid;
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {

        updateTimetable(context);
        //removePastEvents();

        // update Views
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.time_table_widget);
        Intent intent = new Intent(context, TimeTableWidgetService.class);
        views.setRemoteAdapter(R.id.timetable_list, intent);
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        getDbInstance(context);
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    @Override
    public void onReceive(final Context context, Intent intent) {
        final String action = intent.getAction();
        if (action.equals(AppWidgetManager.ACTION_APPWIDGET_UPDATE)) {
            AppWidgetManager mgr = AppWidgetManager.getInstance(context);
            ComponentName cn = new ComponentName(context, TimeTableWidget.class);
            mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.timetable_list);
        }
        super.onReceive(context, intent);
    }

    public static void sendRefreshBroadcast(Context context) {
        Intent intent = new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        intent.setComponent(new ComponentName(context, TimeTableWidget.class));
        context.sendBroadcast(intent);
    }

    private static void removePastEvents(){
        for(Event e : timetable){
            if(e.getEndTime()!=null)
                if(Event.isPast(e.getEndTime()))
                    timetable.remove(e);
        }
    }
    private static void updateTimetable(Context context){

        // Get data from Database
        db.updateData(true, timetable -> {
            TimeTableWidget.timetable.clear();
            TimeTableWidget.timetable.addAll(timetable);
            TimeTableWidget.sendRefreshBroadcast(context);
        });

        // In case of empty Timetable
        if (timetable.isEmpty()){
            timetable.add(new Event());
        }
    }
}


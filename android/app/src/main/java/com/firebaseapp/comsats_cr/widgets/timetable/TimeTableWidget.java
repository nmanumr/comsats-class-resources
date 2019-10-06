package com.firebaseapp.comsats_cr.widgets.timetable;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.RemoteViews;

import com.firebaseapp.comsats_cr.objects.Database;
import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.R;

import java.util.ArrayList;
import java.util.Iterator;

import static android.content.ContentValues.TAG;
import static android.content.Context.MODE_PRIVATE;

public class TimeTableWidget extends AppWidgetProvider {

    public static final String SOFT_UPDATE_WIDGET = "soft_update";
    public static final String HARD_UPDATE_WIDGET = "hard_update";

    public static final ArrayList<Event> timetable = new ArrayList<>();
    private static Database db;

    public static void sendRefreshBroadcast(Context context, boolean hard) {
        Intent intent = new Intent(hard?HARD_UPDATE_WIDGET:SOFT_UPDATE_WIDGET);
        intent.setComponent(new ComponentName(context, TimeTableWidget.class));
        context.sendBroadcast(intent);
    }

    private static Database getDbInstance(Context context){
        if(db==null)
            if(getUID(context)==null)
                return null;
            else
                db = new Database(getUID(context));
        return db;
    }
    private static String getUID(Context context){
        return  context.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE).getString("flutter.uid", null);
    }
    private static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {

        updateTimetable(context, false);

        // update Views
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.time_table_widget);
        Intent intent = new Intent(context, TimeTableWidgetService.class);
        views.setRemoteAdapter(R.id.timetable_list, intent);
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }
    private static void removePastEvents(){
        Iterator<Event> iter = timetable.iterator();
        while(iter.hasNext()){
            Event x = iter.next();
            if(x.getEndTime()!=null)
                if(Event.isPast(x.getEndTime()))
                    iter.remove();
        }

        if (timetable.isEmpty()){
            timetable.add(new Event());
        }
    }
    private static void updateTimetable(Context context, boolean hard){
        Log.i(TAG, "updateTimetable: called");
        // Get data from Database
        if(getDbInstance(context) == null){
            timetable.clear();
            timetable.add(new Event(Event.NO_AUTH));
            sendRefreshBroadcast(context, false);
        }else
            getDbInstance(context).updateData( timetable-> {
                TimeTableWidget.timetable.clear();
                TimeTableWidget.timetable.addAll(timetable);
                removePastEvents();
                TimeTableWidget.sendRefreshBroadcast(context, false);
            }, hard);
    }
    private static void setNextUpdateAlarm(){

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
        if(getDbInstance(context) == null){
            timetable.clear();
            timetable.add(new Event(Event.NO_AUTH));
            sendRefreshBroadcast(context, true);
        }
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    @Override
    public void onReceive(final Context context, Intent intent) {
        final String action = intent.getAction();
        if (action.equals(SOFT_UPDATE_WIDGET)) {
            AppWidgetManager mgr = AppWidgetManager.getInstance(context);
            ComponentName cn = new ComponentName(context, TimeTableWidget.class);
            mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.timetable_list);
        }else if(action.equals(HARD_UPDATE_WIDGET)){
            updateTimetable(context, true);
            sendRefreshBroadcast(context, false);
        }
        super.onReceive(context, intent);
    }
}


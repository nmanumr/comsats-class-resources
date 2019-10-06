package com.firebaseapp.comsats_cr.widgets.timetable;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.provider.CalendarContract;
import android.util.Log;
import android.widget.RemoteViews;

import com.firebaseapp.comsats_cr.objects.Database;
import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.R;

import java.time.Duration;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Objects;

import static android.content.ContentValues.TAG;
import static android.content.Context.MODE_PRIVATE;

public class TimeTableWidget extends AppWidgetProvider {

    public static final String SOFT_UPDATE_WIDGET = "soft_update";
    public static final String HARD_UPDATE_WIDGET = "hard_update";

    private static final int ALARM_REQUEST_CODE = 0;

    public static final ArrayList<Event> timetable = new ArrayList<>();
    private static Database db;

    /**
     * Sends Update Signal to the widget when called
     * @param context Application Context
     * @param hard show weather cache is required or fresh data from Fire-store
     */
    public static void sendRefreshBroadcast(Context context, boolean hard) {
        Intent intent = new Intent(hard?HARD_UPDATE_WIDGET:SOFT_UPDATE_WIDGET);
        intent.setComponent(new ComponentName(context, TimeTableWidget.class));
        context.sendBroadcast(intent);
    }

    /**
     * Initialize and returns Database Instance
     * @param context Application Context
     * @return Database Instance to send update calls and receive data
     */
    private static Database getDbInstance(Context context){
        if(db==null)
            if(getUID(context)==null)
                return null;
            else
                db = new Database(getUID(context));
        return db;
    }

    /**
     * Returns User ID saved in shared preferences by flutter Application
     * @param context Application Context
     * @return UID from Shared Preferences
     * @see android.content.SharedPreferences
     */
    private static String getUID(Context context){
        return  context.getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE).getString("flutter.uid", null);
    }

    /**
     * perform certain tasks when update is called
     * @param context Application Context
     * @param appWidgetManager App Widget Manager - responsible for Managing all Widgets
     * @param appWidgetId App Widget Id - id of certain widget
     */
    private static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {

        updateTimetable(context, false);
        setNextUpdateAlarm(context);

        // update Views
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.time_table_widget);
        Intent intent = new Intent(context, TimeTableWidgetService.class);
        views.setRemoteAdapter(R.id.timetable_list, intent);
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    /**
     * Remove events from the timetable static variable
     * to ensure upcoming events displayed only
     */
    private static void removePastEvents(){
        Iterator<Event> iterator = timetable.iterator();
        while(iterator.hasNext()){
            Event x = iterator.next();
            if(x.getEndTime()!=null)
                if(Event.isPast(x.getEndTime()))
                    iterator.remove();
        }

        if (timetable.isEmpty()){
            timetable.add(new Event());
        }
    }

    /**
     * Updates static Timetable variable with new event values
     * @param context Application Context
     * @param hard Checks weather Content needs to be fetched from Database or cache
     */
    private static void updateTimetable(Context context, boolean hard){
        Log.i(TAG, "updateTimetable: called");
        // Get data from Database
        if(getDbInstance(context) == null){
            timetable.clear();
            timetable.add(new Event(Event.NO_AUTH));
            sendRefreshBroadcast(context, false);
        }else
            Objects.requireNonNull(getDbInstance(context)).updateData(timetable-> {
                TimeTableWidget.timetable.clear();
                TimeTableWidget.timetable.addAll(timetable);
                removePastEvents();
                TimeTableWidget.sendRefreshBroadcast(context, false);
            }, hard);
    }

    /**
     * sets alarm service to trigger updates at certain time
     * @param context Application Context
     */
    private static void setNextUpdateAlarm(Context context){
        Log.i(TAG, "setNextUpdateAlarm: called");
        Calendar calendar = Calendar.getInstance();
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        assert alarmManager != null;

        Intent intent;
        long delay;

        if(timetable.size() == 1){
            // schedule update for next day
            long millisPast = (
                    calendar.get(Calendar.HOUR_OF_DAY)*60*60*1000
                            + calendar.get(Calendar.MINUTE)*60*1000
                            + calendar.get(Calendar.SECOND)*1000
                            + calendar.get(Calendar.MILLISECOND)
            );
            delay = (24*60*60*1000) - millisPast;
            intent = new Intent(HARD_UPDATE_WIDGET);
        }else{
            // schedule for event's end time
            delay = convertToMillis(Event.formatTime(timetable.get(0).getEndTime(), false));
            intent = new Intent(SOFT_UPDATE_WIDGET);
        }

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, ALARM_REQUEST_CODE, intent, 0);
        alarmManager.cancel(pendingIntent); // Cancel every previous Alarm Set

        alarmManager.setRepeating(
                AlarmManager.RTC,
                calendar.getTimeInMillis(),
                delay,
                pendingIntent
        );
        Log.i(TAG, "setNextUpdateAlarm: Alarm will trigger in > " + (float) delay/1000/60/60 + " Hour");
    }

    /**
     * Converts the time to milli Seconds
     * @param time 24 Hour Formatted time in String Format as received from Fire-store
     * @return Time in MilliSeconds in type ling
     */
    private static long convertToMillis(String time){
        return (long) Double.parseDouble(time.trim().replace(":", ".")) * 1000;
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
            sendRefreshBroadcast(context, false);
        }
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    @Override
    public void onReceive(final Context context, Intent intent) {
        final String action = intent.getAction();
        if (action != null) {
            if (action.equals(SOFT_UPDATE_WIDGET)) {
                    AppWidgetManager mgr = AppWidgetManager.getInstance(context);
                    ComponentName cn = new ComponentName(context, TimeTableWidget.class);
                    mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.timetable_list);
                } else if (action.equals(HARD_UPDATE_WIDGET)) {
                    updateTimetable(context, true);
                }
        }
        super.onReceive(context, intent);
    }
}


package com.firebaseapp.comsats_cr.widgets.timetable;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.RemoteViews;

import com.firebaseapp.comsats_cr.Helpers.Database;
import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.R;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class TimeTableWidget extends AppWidgetProvider {

    private static final int ALARM_REQUEST_CODE = 0;

    public static final ArrayList<Event> timetable = new ArrayList<>();

    private Database DB = null;

    private Database getDBInstance(Context context){
        if(DB == null)
            DB = new Database(context);
        return DB;
    }

    /**
     * Sends Update Signal to the widget when called
     * @param context Application Context
     */
    synchronized public static void sendRefreshBroadcast(Context context) {
        Log.i("CALLS", "> Broadcast sent");
        Intent intent = new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        intent.setComponent(new ComponentName(context, TimeTableWidget.class));
        context.sendBroadcast(intent);
    }

    /**
     * sets alarm service to trigger updates at certain time
     * @param context Application Context
     */
    synchronized private static void setNextUpdateAlarm(Context context){
        Calendar calendar = Calendar.getInstance();
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        long delay;
        long currentTimeInMilli = (calendar.get(Calendar.HOUR_OF_DAY)*60*60*1000 + calendar.get(Calendar.MINUTE)*60*1000 + calendar.get(Calendar.SECOND)*1000 + calendar.get(Calendar.MILLISECOND));
        if(timetable.isEmpty()){
            return;
        } else if(timetable.get(0).getEndTime() == null){
            // schedule update for next day
            delay = (24*60*60*1000) - currentTimeInMilli;
        }else{
            // schedule for event's end time
            delay = convertToMillis(Event.formatTime(timetable.get(0).getEndTime(), false)) - currentTimeInMilli;
        }

        Log.i("CALLS", "next Alarm Update after: " + delay + " ms");

        PendingIntent pendingIntent = PendingIntent.getBroadcast(context, ALARM_REQUEST_CODE, new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE), 0);
        if (alarmManager != null) {
            alarmManager.cancel(pendingIntent); // Cancel every previous Alarm Set
            alarmManager.setRepeating(
                    AlarmManager.RTC_WAKEUP,
                    calendar.getTimeInMillis(),
                    delay,
                    pendingIntent
            );
        }
    }

    /**
     * Converts the time to milli Seconds
     * @param time 24 Hour Formatted time in String Format as received from Fire-store
     * @return Time in MilliSeconds in type ling
     */
    synchronized private static long convertToMillis(String time){
        Date date = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault());
            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));
            date = sdf.parse("1970-01-01 " + time + ":00.000");
        } catch (ParseException e) {
            e.printStackTrace();
        }
        assert date != null;
        return date.getTime();
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them

        Log.i("CALLS","> onUpdate, new Data:" + timetable.toString());
        setNextUpdateAlarm(context);

        for (int appWidgetId : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.time_table_widget);
            Intent intent = new Intent(context, TimeTableWidgetService.class);
            views.setRemoteAdapter(R.id.timetable_list, intent);
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        Log.i("CALLS", "> On Enabled: new widget created");
        sendRefreshBroadcast(context);
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
        Log.i("CALLS", "> on disabled");
        timetable.clear();
    }

    @Override
    public void onReceive(final Context context, Intent intent) {
        Log.i("CALLS", "> Broadcast Received, action : " + intent.getAction());
        final String action = intent.getAction();

        if (action != null) {
            if (action.equals(AppWidgetManager.ACTION_APPWIDGET_UPDATE)) {
                timetable.clear();
                timetable.addAll(getDBInstance(context).getEvents());
                if(timetable.isEmpty())
                    timetable.add(new Event());

                AppWidgetManager mgr = AppWidgetManager.getInstance(context);
                ComponentName cn = new ComponentName(context, TimeTableWidget.class);
                mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.timetable_list);
            }
        }
        super.onReceive(context, intent);
    }
}


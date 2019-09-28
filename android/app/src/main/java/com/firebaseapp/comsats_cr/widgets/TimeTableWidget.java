package com.firebaseapp.comsats_cr.widgets;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.widget.RemoteViews;

import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.R;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

public class TimeTableWidget extends AppWidgetProvider {

    public static final ArrayList<Event> timetable = new ArrayList<>();

    public TimeTableWidget() {
        this(new ArrayList<Event>());
    }

    public TimeTableWidget(ArrayList<Event> timetable) {
        TimeTableWidget.timetable.addAll(timetable);
    }

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.time_table_widget);
        Intent intent = new Intent(context, TimeTableWidgetService.class);
        views.setRemoteAdapter(R.id.list_item, intent);
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
            mgr.notifyAppWidgetViewDataChanged(mgr.getAppWidgetIds(cn), R.id.list_item);
        }
        super.onReceive(context, intent);
    }

    public static void sendRefreshBroadcast(Context context) {
        Intent intent = new Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE);
        intent.setComponent(new ComponentName(context, TimeTableWidget.class));
        context.sendBroadcast(intent);
    }

    public static String formatTime(Date time){
        SimpleDateFormat dateFormat = new SimpleDateFormat("KK:mm a", Locale.getDefault());
        return dateFormat.format(time);
    }
}


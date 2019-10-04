package com.firebaseapp.comsats_cr.widgets.timetable;

import android.content.Context;
import android.os.Binder;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.firebaseapp.comsats_cr.R;
import com.firebaseapp.comsats_cr.objects.Event;

public class TimeTableWidgetAdapter implements RemoteViewsService.RemoteViewsFactory {

    private Context mContext;

    public TimeTableWidgetAdapter(Context applicationContext) {
        mContext = applicationContext;
    }

    @Override
    public void onCreate() {

    }

    @Override
    public void onDataSetChanged() {
        final long identityToken = Binder.clearCallingIdentity();
        Binder.restoreCallingIdentity(identityToken);
    }

    @Override
    public void onDestroy() {
    }

    @Override
    public int getCount() {
        return TimeTableWidget.timetable.size();
    }

    @Override
    public RemoteViews getViewAt(int position) {

        RemoteViews rv = new RemoteViews(mContext.getPackageName(), R.layout.list_view_timetable);

        String sub = TimeTableWidget.timetable.get(position).getSub();
        boolean isEmpty = sub.equals(Event.NO_EVENT) || sub.equals(Event.NO_AUTH);
        if(!isEmpty){
            String startTime = Event.formatTime(TimeTableWidget.timetable.get(position).getStartTime(), true);
            String endTime = Event.formatTime(TimeTableWidget.timetable.get(position).getEndTime(), true);

            rv.setTextViewText(R.id.events_name, TimeTableWidget.timetable.get(position).getSub());
            rv.setTextViewText(R.id.events_loc, TimeTableWidget.timetable.get(position).getLoc());
            rv.setTextViewText(R.id.events_time, startTime + " - " + endTime);

            rv.setViewVisibility(R.id.events_loc, View.VISIBLE);
            rv.setViewVisibility(R.id.events_time, View.VISIBLE);
            rv.setViewVisibility(R.id.loc_icon, View.VISIBLE);
        }else{
            rv.setTextViewText(R.id.events_name, Event.NO_EVENT);
            rv.setViewVisibility(R.id.events_loc, View.GONE);
            rv.setViewVisibility(R.id.events_time, View.GONE);
            rv.setViewVisibility(R.id.loc_icon, View.GONE);
        }

        return rv;
    }

    @Override
    public RemoteViews getLoadingView() {
        return null;
    }

    @Override
    public int getViewTypeCount() {
        return 1;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

}
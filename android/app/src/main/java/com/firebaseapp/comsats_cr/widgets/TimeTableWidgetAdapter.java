package com.firebaseapp.comsats_cr.widgets;

import android.content.Context;
import android.os.Binder;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import com.firebaseapp.comsats_cr.R;

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
        rv.setTextViewText(R.id.events_name, TimeTableWidget.timetable.get(position).getSub());
        rv.setTextViewText(R.id.events_loc, TimeTableWidget.timetable.get(position).getLoc());
        rv.setTextViewText(R.id.events_time, TimeTableWidget.timetable.get(position).getStartTime() + " - " + TimeTableWidget.timetable.get(position).getEndTime());
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
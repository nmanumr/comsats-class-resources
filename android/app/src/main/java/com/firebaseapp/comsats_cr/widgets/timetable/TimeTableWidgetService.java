package com.firebaseapp.comsats_cr.widgets.timetable;


import android.content.Intent;
import android.widget.RemoteViewsService;

class TimeTableWidgetService extends RemoteViewsService {

    @Override
    public RemoteViewsService.RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new TimeTableWidgetAdapter(this.getApplicationContext());
    }
}
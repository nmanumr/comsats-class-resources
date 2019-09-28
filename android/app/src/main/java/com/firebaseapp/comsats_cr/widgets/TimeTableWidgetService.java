package com.firebaseapp.comsats_cr.widgets;


import android.content.Intent;
import android.widget.RemoteViewsService;

public class TimeTableWidgetService extends RemoteViewsService {

    @Override
    public RemoteViewsService.RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new TimeTableWidgetAdapter(this.getApplicationContext());
    }
}
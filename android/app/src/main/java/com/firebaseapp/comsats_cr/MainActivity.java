package com.firebaseapp.comsats_cr;

import android.os.Bundle;

import com.firebaseapp.comsats_cr.widgets.TimeTableWidget;

import java.util.Objects;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.firebaseapp.comsats_cr/timetable_widget";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("refresh_timetable_widget"))
                TimeTableWidget.sendRefreshBroadcast(getApplicationContext());
            else if(call.method.equals("update_timetable_widget")){
                if(call.argument("todaysTimetableEvents") != null) {
                    TimeTableWidget.timetable.clear();
                    TimeTableWidget.timetable.addAll(Objects.requireNonNull(call.argument("todaysTimetableEvents")));
                    TimeTableWidget.sendRefreshBroadcast(getApplicationContext());
                }else
                    result.error("1", "Null_Exception", "todaysTimetableEvents is contains null value.");
            }else
                result.notImplemented();
        });
    }
}
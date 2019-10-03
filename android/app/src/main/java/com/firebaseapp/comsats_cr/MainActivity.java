package com.firebaseapp.comsats_cr;

import android.content.SharedPreferences;
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

        // Method Channel
//        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
//            if (call.method.equals("refresh_timetable_widget"))
//                TimeTableWidget.sendRefreshBroadcast(getApplicationContext());
//            else
//                result.notImplemented();
//        });
    }
}

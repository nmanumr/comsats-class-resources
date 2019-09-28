package com.firebaseapp.comsats_cr;

import android.os.Bundle;

import androidx.annotation.NonNull;

import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.widgets.TimeTableWidget;

import java.util.ArrayList;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "com.firebaseapp.comsats_cr/timetable_widget";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
      if (call.method.equals("refresh_timetable_widget")) {
        try {
          TimeTableWidget.sendRefreshBroadcast(getApplicationContext());
        } catch (Exception e) {
          result.error("-1", "unexpected Error", null);
        }
      }else if(call.method.equals("update_timetable_widget")){
        //TODO:: ADD CODE
      }else{
        result.notImplemented();
      }
    });
  }
}

package com.firebaseapp.comsats_cr.Helpers;

import android.content.Context;
import android.util.Log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;

public class Logger {

    public static void write(Context context, String text) {
        File logFile = new File(context.getExternalFilesDir(null), "timetable_widget_log.txt");
        if (!logFile.exists()) {
            try {
                if (!logFile.createNewFile()) {
                    Log.e("LOGGER", "create log file error");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        try {
            text += " - " + Calendar.getInstance().getTime();
            //BufferedWriter for performance, true to set append to file flag
            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
            buf.append(text);
            buf.newLine();
            buf.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

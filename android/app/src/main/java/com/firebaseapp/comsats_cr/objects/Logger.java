package com.firebaseapp.comsats_cr.objects;

import android.os.Environment;
import android.util.Log;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;

public class Logger {


    private static final String path = getInternalStoragePath() + "/crlog.txt";

    public static void write(String text)
    {
        File logFile = new File(path);
        if (!logFile.exists())
        {
            try
            {
                if(!logFile.createNewFile()){
                    Log.e("LOGGER", "create log file error");
                }
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
        }
        try
        {
            text += " - " + Calendar.getInstance().getTime();
            //BufferedWriter for performance, true to set append to file flag
            BufferedWriter buf = new BufferedWriter(new FileWriter(logFile, true));
            buf.append(text);
            buf.newLine();
            buf.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    private static String getInternalStoragePath() {
        return Environment.getExternalStorageDirectory().getAbsolutePath();
    }
}

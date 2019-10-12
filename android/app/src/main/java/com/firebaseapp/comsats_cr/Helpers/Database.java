package com.firebaseapp.comsats_cr.Helpers;

import android.content.Context;
import android.util.Log;

import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.objects.JSONTimetable;
import com.google.gson.Gson;

import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Iterator;

public class Database{
    private Context context;

    public Database(Context context) {
        this.context = context;
    }

    synchronized public ArrayList<Event> getEvents(){
        // Get All Events from File if available and update the variable
        ArrayList<Event> timetable = new ArrayList<>();
        String jsongString = readFromJsonFile();
        JSONArray jarray;
        try {
            jarray = new JSONArray(jsongString);
        } catch (JSONException e) {
            Logger.write(context, "Can't Fetch JSON from file");
        }
        if(jsongString!=null){
            // TODO:: get Timetable from JSON and update
            Gson gson = new Gson();
            JSONTimetable jsonTimetable = gson.fromJson(readFromJsonFile(), JSONTimetable.class);
            if(jsonTimetable.getStatus().equals("success"))
                timetable = jsonTimetable.getEvents();
        }
        return getTodayEvents(timetable);
    }

    synchronized private ArrayList<Event> getTodayEvents(ArrayList<Event> timeTableEvents){
        ArrayList<Event> events = new ArrayList<>();
        for (Event e: timeTableEvents)
            if (e.getWeekday() == Event.getCurrentWeekDay())
                events.add(e);

        return removePastEvents(events);
    }

    synchronized private ArrayList<Event> removePastEvents(ArrayList<Event> timeTableEvents){
        Logger.write(context, "> remove Past Events called");
        Iterator<Event> iterator = timeTableEvents.iterator();
        while(iterator.hasNext()){
            Event x = iterator.next();
            if(x.getEndTime()!=null)
                if(Event.isPast(x.getEndTime()))
                    iterator.remove();
        }
        Logger.write(context, "after removing, new data: " + timeTableEvents.toString());

        if (timeTableEvents.isEmpty())
            timeTableEvents.add(new Event(Event.NO_EVENT));

        return timeTableEvents;
    }

    private String readFromJsonFile() {

        String ret = "";
        InputStream inputStream = null;
        try {
            File timeTableFile = new File(context.getExternalFilesDir(null), "timetable.json");
            inputStream = context.openFileInput(timeTableFile.getAbsolutePath());

            if ( inputStream != null ) {
                InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
                BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
                String receiveString = "";
                StringBuilder stringBuilder = new StringBuilder();

                while ( (receiveString = bufferedReader.readLine()) != null ) {
                    stringBuilder.append(receiveString);
                }

                ret = stringBuilder.toString();
            }
        }
        catch (FileNotFoundException e) {
            Log.e("readFromJsonFile", "File not found: " + e.toString());
            Logger.write(context, "File not found: " + e.toString());
        } catch (IOException e) {
            Log.e("readFromJsonFile", "Can not read file: " + e.toString());
            Logger.write(context, "Can not read file: " + e.toString());
        }
        finally {
            try {
                if (inputStream != null)
                    inputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return ret;
    }
}
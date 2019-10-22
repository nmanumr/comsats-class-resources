package com.firebaseapp.comsats_cr.Helpers;

import android.content.Context;
import android.util.Log;

import com.firebaseapp.comsats_cr.objects.Event;
import com.firebaseapp.comsats_cr.objects.JSONTimetable;
import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;

import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class Database{
    private Context context;

    public Database(Context context) {
        this.context = context;
    }

    synchronized public ArrayList<Event> getEvents(){
        // Get All Events from File if available and update the variable
        ArrayList<Event> timetable = new ArrayList<>();
        Gson gson = new Gson();

        String json = readFromJsonFile();
        JSONTimetable jsonTimetable;

        if(json!=null) {
            JsonReader result = new JsonReader(new StringReader(json));
            result.setLenient(true);

            jsonTimetable = gson.fromJson(result, JSONTimetable.class);

            if(jsonTimetable != null)
                switch(jsonTimetable.getStatus()){
                    case JSONTimetable.STATUS_SUCCESS:
                        timetable.clear();
                        timetable.addAll(jsonTimetable.getEvents());
                        break;
                    case JSONTimetable.STATUS_LOGGED_OUT:
                        timetable.add(new Event(Event.NO_AUTH));
                        break;
                    case JSONTimetable.STATUS_ERROR:
                        break;
                }
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
        Iterator<Event> iterator = timeTableEvents.iterator();
        while(iterator.hasNext()){
            Event x = iterator.next();
            if(x.getEndTime()!=null)
                if(Event.isPast(x.getEndTime()))
                    iterator.remove();
        }

        if (timeTableEvents.isEmpty())
            timeTableEvents.add(new Event());
        Collections.sort(timeTableEvents, new Event());
        return timeTableEvents;
    }

    private String readFromJsonFile() {

        String ret = "";
        InputStream inputStream = null;
        try {
            File timeTableFile = new File(context.getExternalFilesDir(null), "timetable.enc");
            inputStream = new FileInputStream(timeTableFile);

            InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            String receiveString;
            StringBuilder stringBuilder = new StringBuilder();

            while ( (receiveString = bufferedReader.readLine()) != null ) {
                stringBuilder.append(receiveString);
            }

            ret = stringBuilder.toString();
        }
        catch (FileNotFoundException e) {
            Log.e("readFromJsonFile", "File not found: " + e.toString());
        } catch (IOException e) {
            Log.e("readFromJsonFile", "Can not read file: " + e.toString());
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
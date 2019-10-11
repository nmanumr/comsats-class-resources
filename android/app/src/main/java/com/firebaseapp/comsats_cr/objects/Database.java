package com.firebaseapp.comsats_cr.objects;

import android.content.Context;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Iterator;

public class Database{

    private final ArrayList<Event> timeTableEvents;
    private Context context;

    public Database(Context context) {
        this.context = context;
        timeTableEvents = new ArrayList<>();
    }

    /**
     * returns Events that are going to occur today
     * @return timetable of current day
     */
    synchronized public ArrayList<Event> getTodayEvents(){
        ArrayList<Event> events = new ArrayList<>();
        for (Event e: timeTableEvents)
            if (e.getWeekday() == Event.getCurrentWeekDay())
                events.add(e);

        removePastEvents();
        return events;
    }

    synchronized private void getEvents(){
        // Get All Events from File if available and update the variable

    }

    /**
     * Remove events from the timetable static variable
     * to ensure upcoming events displayed only
     */
    synchronized private void removePastEvents(){
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
    }

    public JSONObject loadJSONFromFile() {
        String json = null;
        JSONObject jsonObject  = null;
        try {
            File timeTableFile = new File(context.getExternalFilesDir(null), "timetable.json");
            if(timeTableFile.exists()){
                InputStream is = new FileInputStream(timeTableFile);
                int size = is.available();
                byte[] buffer = new byte[size];
                is.read(buffer);
                is.close();
                json = new String(buffer, StandardCharsets.UTF_8);
                jsonObject = new JSONObject(json);
            }
        } catch (IOException | JSONException ex) {
            ex.printStackTrace();
            return null;
        }
        return jsonObject;
    }
}
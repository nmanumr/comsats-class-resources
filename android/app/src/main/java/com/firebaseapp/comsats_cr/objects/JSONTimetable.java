package com.firebaseapp.comsats_cr.objects;

import java.util.ArrayList;

public class JSONTimetable {

    public final static String STATUS_SUCCESS = "success";
    public final static String STATUS_LOGGED_OUT = "loggedOut";
    public final static String STATUS_ERROR = "error";

    private String status;
    private String error;
    private String lastUpdate;
    private int eventLength;
    private ArrayList<JSONEvent> events;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(String lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public int getEventLength() {
        return eventLength;
    }

    public void setEventLength(int eventLength) {
        this.eventLength = eventLength;
    }

    public ArrayList<Event> getEvents() {
        ArrayList<Event> x = new ArrayList<>();
        for(JSONEvent jsonEvent: events){
            Event y = new Event();
            y.setSub(jsonEvent.title);
            y.setLab(jsonEvent.isLab);
            y.setLoc(jsonEvent.location);
            y.setStartTime(jsonEvent.startTime);
            y.setEndTime(jsonEvent.endTime);
            y.setWeekday(jsonEvent.weekday);
            y.setTeacher(jsonEvent.teacher);
            x.add(y);
        }
        return x;
    }

    public void setEvents(ArrayList<JSONEvent> events) {
        this.events = events;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    class JSONEvent {
        private String location;
        private String teacher;
        private int eventSlot;
        private int weekday;
        private String startTime;
        private String endTime;
        private boolean isLab;
        private String title;
        private String color;

        public JSONEvent(String location, String teacher, int eventSlot, int weekday, String startTime, String endTime, boolean isLab, String title, String color) {
            this.location = location;
            this.teacher = teacher;
            this.eventSlot = eventSlot;
            this.weekday = weekday;
            this.startTime = startTime;
            this.endTime = endTime;
            this.isLab = isLab;
            this.title = title;
            this.color = color;
        }
    }
}





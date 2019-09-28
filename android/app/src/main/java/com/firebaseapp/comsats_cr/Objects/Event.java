package com.firebaseapp.comsats_cr.Objects;

public class Event {
    private String sub;
    private String loc;
    private String startTime;
    private String endTime;

    public Event() {
    }

    public Event(String sub, String loc, String startTime, String endTime) {
        this.sub = sub;
        this.loc = loc;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public String getSub() {
        return sub;
    }

    public void setSub(String sub) {
        this.sub = sub;
    }

    public String getLoc() {
        return loc;
    }

    public void setLoc(String loc) {
        this.loc = loc;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }
}

package com.firebaseapp.comsats_cr.objects;

import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import static android.content.ContentValues.TAG;

public class Event {
    private String sub;
    private String loc;
    private Date startTime;
    private Date endTime;
    private int weekday;
    private String teacher;
    private Boolean isLab;

    public Event() {
    }

    public Event(String sub, String loc, Date startTime, Date endTime, int weekday, String teacher, Boolean isLab) {
        this.sub = sub;
        this.loc = loc;
        this.startTime = startTime;
        this.endTime = endTime;
        this.weekday = weekday;
        this.teacher = teacher;
        this.isLab = isLab;
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

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = formatTime(startTime, false);
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = formatTime(endTime, false);
    }

    public int getWeekday() {
        return weekday;
    }

    public void setWeekday(int weekday) {
        this.weekday = weekday;
    }

    public String getTeacher() {
        return teacher;
    }

    public void setTeacher(String teacher) {
        this.teacher = teacher;
    }

    public Boolean getLab() {
        return isLab;
    }

    public void setLab(Boolean lab) {
        isLab = lab;
    }

    public static String formatTime(Date time, Boolean to12){
        SimpleDateFormat dateFormat = new SimpleDateFormat(to12?"KK:mm a":"HH:mm", Locale.getDefault());
        return dateFormat.format(time);
    }

    private static Date formatTime(String time, Boolean frm12){
        Date d = Calendar.getInstance().getTime();
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat(frm12?"KK:mm a":"HH:mm", Locale.getDefault());
            d = dateFormat.parse(time);
        }catch(ParseException e){
            Log.e(TAG, "formatTime: " + e.getMessage(), e);
        }
        return d;
    }

    public static String getCurrentTime(Boolean to12){
        SimpleDateFormat dateFormat = new SimpleDateFormat(to12?"KK:mm a":"HH:mm", Locale.getDefault());
        return dateFormat.format(Calendar.getInstance().getTime());
    }

    public static int getCurrentWeekDay(){
        return Calendar.getInstance().get(Calendar.DAY_OF_WEEK)-1;
    }

    public static Boolean isPast(Date d){
        return Integer.parseInt(Event.formatTime(d, false).substring(0, 4).replace(":", ""))
                <= Integer.parseInt(getCurrentTime(false).substring(0, 4).replace(":", ""));
    }
}

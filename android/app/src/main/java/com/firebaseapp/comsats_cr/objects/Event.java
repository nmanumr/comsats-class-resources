package com.firebaseapp.comsats_cr.objects;

import android.util.Log;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.Locale;

import static android.content.ContentValues.TAG;

public class Event implements Comparator<Event> {

    public static String NO_EVENT = "No Event!";
    public static String NO_AUTH = "LogIn or SignUp First";

    private String sub;
    private String loc;
    private Date startTime;
    private Date endTime;
    private int weekday;
    private String teacher;
    private Boolean isLab;


    // Constructors
    public Event() {
        this(NO_EVENT);
    }

    public Event(String name) {
        this(name, null,null, null ,getCurrentWeekDay(),null,false);
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

    // Getter Setters

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

    public void setWeekday(Long weekday) {
        this.weekday = weekday.intValue();
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

    // Methods

    public static String formatTime(Date time, Boolean to12){
        String T;
        if(time!=null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat(to12 ? "KK:mm a" : "HH:mm", Locale.getDefault());
            T = dateFormat.format(time);
        }else{
            T = null;
        }
        return T;
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

    public static boolean isPast(Date d){
        if(d!=null)
            return Integer.parseInt(Event.formatTime(d, false).substring(0, 4).replace(":", ""))
                    <= Integer.parseInt(getCurrentTime(false).substring(0, 4).replace(":", ""));
        else
            return false;
    }

    @Override
    public int compare(Event event, Event t1) {
        return event.getStartTime().compareTo(t1.getStartTime());
    }
}

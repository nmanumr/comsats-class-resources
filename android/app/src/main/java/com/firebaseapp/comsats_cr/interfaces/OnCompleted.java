package com.firebaseapp.comsats_cr.interfaces;

import com.firebaseapp.comsats_cr.objects.Event;

import java.util.ArrayList;

public interface OnCompleted {
    void timetableReceived(ArrayList<Event> timetable);
}
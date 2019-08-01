import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.dart';
import 'package:class_resources/models/timetable.dart';
import 'package:class_resources/pages/timetable/calender-day.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:table_calendar/table_calendar.dart';

class TimeTablePage extends StatefulWidget {
  TimeTablePage({this.userModel});

  final ProfileModel userModel;

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage>
    with TickerProviderStateMixin {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  CalendarController _calendarController;
  PageController _pageController;

  num initialPosition;
  num lastPos;
  bool posUpdated = true;
  bool pageUpdatedLocally = false;

  TimeTableModel model;

  @override
  void initState() {
    super.initState();
    model = TimeTableModel(user: widget.userModel);
    _calendarController = CalendarController();
    _selectedDay = DateTime.now();
    initialPosition = _selectedDay.weekday;
    lastPos = _selectedDay.weekday;
    print(_selectedDay);
    _events = {};
    _visibleEvents = _events;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      pageUpdatedLocally = true;
      _selectedDay = day;
      _pageController.animateToPage(day.weekday,
          duration: Duration(milliseconds: 700), curve: Curves.easeOut);
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
          (entry) =>
              entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(context, "Time Table", actions: [
        IconButton(
          icon: Icon(Icons.today),
          onPressed: () {
            setState(() {
              _selectedDay = DateTime.now();
            });
          },
        )
      ]),
      body: ScopedModel(
        model: model,
        child: ScopedModelDescendant<TimeTableModel>(
          builder: (context, child, model) {
            if (model.isLoading) return Loader();
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTableCalendar(),
                const SizedBox(height: 8.0),
                Expanded(child: _buildEventList()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF5EBBC8),
      ),
      width: 7.0,
      height: 7.0,
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _visibleEvents,
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
      },
      headerVisible: false,
      calendarStyle: CalendarStyle(
          selectedColor: Theme.of(context).accentColor.withAlpha(155),
          todayColor: Theme.of(context).accentColor.withAlpha(40),
          markersColor: Color(0xFF5EBBC8),
          weekendStyle: TextStyle(color: Colors.white.withAlpha(200)),
          outsideWeekendStyle: TextStyle(color: Colors.white.withAlpha(100)),
          weekdayStyle: TextStyle(color: Colors.white),
          holidayStyle: TextStyle(color: Colors.white.withAlpha(100))),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        leftChevronIcon: Icon(Icons.chevron_left),
        rightChevronIcon: Icon(Icons.chevron_right),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white.withAlpha(180)),
        weekendStyle: TextStyle(color: Colors.white.withAlpha(180)),
      ),
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          var children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                bottom: 10,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildEventsMarker(date, events),
                ),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventList() {
    _pageController = PageController(initialPage: initialPosition);

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (pos) {
        var newDate = _selectedDay, crntPos = lastPos;
        if (pos > lastPos) {
          newDate = _selectedDay.add(Duration(days: 1));
          if (!pageUpdatedLocally) crntPos += 1;
        } else if (pos < lastPos && !pageUpdatedLocally) {
          newDate = _selectedDay.subtract(Duration(days: 1));
          if (!pageUpdatedLocally) crntPos -= 1;
        }

        if (pos == 0 && !pageUpdatedLocally) {
          newDate = _selectedDay.subtract(Duration(days: 1));
          _pageController.jumpToPage(7);
          crntPos = 7;
        } else if (pos == 8 && !pageUpdatedLocally) {
          newDate = _selectedDay.add(Duration(days: 1));
          _pageController.jumpToPage(1);
          crntPos = 1;
        }
        _calendarController.setSelectedDay(newDate);

        setState(() {
          pageUpdatedLocally = false;
          lastPos = crntPos;
          posUpdated = true;
          _selectedDay = newDate;
        });
      },
      itemCount: 9,
      itemBuilder: (context, pos) {
        var date = _selectedDay;
        if ((lastPos > pos && !posUpdated) ||
            (posUpdated && lastPos == pos + 1))
          date = date.subtract(Duration(days: 1));
        else if ((lastPos < pos && !posUpdated) ||
            (posUpdated && lastPos == pos - 1))
          date = date.add(Duration(days: 1));

        posUpdated = false;
        return CalendarDay(
          model: model,
          day: date,
        );
      },
    );
  }
}

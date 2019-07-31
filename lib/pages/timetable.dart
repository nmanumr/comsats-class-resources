import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/profile.dart';
import 'package:class_resources/models/timetable.dart';
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
  List _selectedEvents;
  CalendarController _calendarController;

  TimeTableModel model;

  @override
  void initState() {
    super.initState();
    model = TimeTableModel(user: widget.userModel);
    _calendarController = CalendarController();
    _selectedDay = DateTime.now();
    _events = {};

    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
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
              _selectedEvents = _events[_selectedDay] ?? [];
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
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
      },
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
    print(DateTime.now().weekday);
    return PageView.builder(
      controller: PageController(initialPage: DateTime.now().weekday - 1),
      itemCount: 7,
      itemBuilder: (context, position) {
        return Text("$position");
        // return ListView(
        //   children: _selectedEvents
        //       .map((event) => Container(
        //             decoration: BoxDecoration(
        //               border: Border.all(width: 0.8),
        //               borderRadius: BorderRadius.circular(12.0),
        //             ),
        //             margin: const EdgeInsets.symmetric(
        //                 horizontal: 8.0, vertical: 4.0),
        //             child: ListTile(
        //               title: Text(event.toString()),
        //               onTap: () => print('$event tapped!'),
        //             ),
        //           ))
        //       .toList(),
        // );
      },
    );
  }
}

import 'package:class_resources/components/empty-state.dart';
import 'package:class_resources/components/list-header.dart';
import 'package:class_resources/components/loader.dart';
import 'package:class_resources/models/course.model.dart';
import 'package:class_resources/models/task.model.dart';
import 'package:class_resources/pages/home/task-detail.dart';
import 'package:class_resources/utils/colors.dart';
import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseTasks extends StatefulWidget {
  final CourseModel course;

  CourseTasks(this.course);

  @override
  _CourseTasksState createState() => _CourseTasksState();
}

class _CourseTasksState extends State<CourseTasks> {
  bool isLoading = true;

  Widget onError(err) {
    return Text('Error: $err');
  }

  int _compareTasks(TaskModel t1, TaskModel t2) {
    return t1.dueDate.isBefore(t2.dueDate) ? -1 : 1;
  }

  Widget _taskTile(TaskModel model) {
    return ListTile(
      leading: Hero(
        tag: "${model.hashCode}-c",
        child: CircleAvatar(
            child: Icon(model.getIcon()),
            backgroundColor:
                HexColor(generateColor(model.title)).withAlpha(130),
            foregroundColor: Colors.white),
      ),
      title: Hero(
        tag: model.hashCode,
        child: Material(
          color: Colors.transparent,
          child: Text(model.title),
        ),
      ),
      subtitle:
          Text(DateFormat("EEE, MMMM d, yyyy (h:m a)").format(model.dueDate)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetail(model),
          ),
        );
      },
    );
  }

  List<Widget> getDayEventTiles(List<TaskModel> events, int i) {
    var date = DateTime.now().add(Duration(days: i));
    return (events.where((e) => Utils.isSameDay(date, e.dueDate)).toList()
          ..sort(_compareTasks))
        .map(_taskTile)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: widget.course.service.getCourseTasks(),
      builder: (BuildContext ctx, AsyncSnapshot<List<TaskModel>> snapshot) {
        if (snapshot.hasError) return onError(snapshot.error);

        if (snapshot.connectionState == ConnectionState.waiting)
          return Loader();

        if (snapshot.data.length == 0)
          return EmptyState(
            text: "No task pending",
            icon: Icons.playlist_add_check,
          );

        var sortedEvents = snapshot.data..sort(_compareTasks);

        return ListView.builder(
          itemCount:
              sortedEvents.last.dueDate.difference(DateTime.now()).inDays + 2,
          itemBuilder: (ctx, i) {
            var events = getDayEventTiles(sortedEvents, i);
            if (events.isEmpty) return SizedBox();

            return Column(children: [
              ListHeader(
                  text: DateFormat("EEEE, MMM d")
                      .format(DateTime.now().add(Duration(days: i)))),
              ...events
            ]);
          },
        );
      },
    );
  }
}

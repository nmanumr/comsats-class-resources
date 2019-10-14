import 'package:class_resources/models/course.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

enum TaskType { Assignment, Quiz, Exam, Other }

class TaskModel extends Model {
  String title;
  TaskType type;
  DateTime dueDate;
  String desc;
  String annoucmentTemplate;
  String room;
  bool isLab;

  CourseModel course;

  TaskModel({this.title, this.dueDate, this.type});

  TaskModel.fromJson(Map<String, dynamic> data, this.course) {
    this.title = data["title"];
    this.dueDate = data["dueDate"] != null
        ? (data["dueDate"] as Timestamp).toDate()
        : null;
    this.type = this.getTaskType(data["type"]);
    this.desc = data["desc"];
    this.annoucmentTemplate = data["annoucmentTemplate"];
    this.room = data["room"];
    this.isLab = data["isLab"] ?? false;
  }

  TaskType getTaskType(String type) {
    switch (type) {
      case "assignment":
        return TaskType.Assignment;

      case "quiz":
        return TaskType.Quiz;

      case "exam":
        return TaskType.Exam;

      default:
        return TaskType.Other;
    }
  }

  String humanize() {
    switch (this.type) {
      case TaskType.Assignment:
        return "Please submit your ${this.title} before *${DateFormat("EEEE, MMM d").format(this.dueDate)}*";

      case TaskType.Exam:
      case TaskType.Quiz:
      case TaskType.Other:
        return "${this.title} will be at *${DateFormat("EEEE, MMM d").format(this.dueDate)}* in *${this.room}*";
    }
  }

  String getAnnoucmentTemplate() {
    if (annoucmentTemplate != null) return annoucmentTemplate;

    var text = [
      "*${this.course.code} - ${this.course.title}*",
      humanize(),
    ];

    if (this.desc != null)
      text.addAll([
        "```",
        "${this.desc}",
        "```",
      ]);

    if (this.isLab) text[0] = "*(Lab) ${text[0].substring(1)}";
    return text.join("\n");
  }

  IconData getIcon() {
    switch (this.type) {
      case TaskType.Assignment:
        return Icons.assignment;

      case TaskType.Quiz:
        return Icons.playlist_add_check;

      default:
        return Icons.done_all;
    }
  }
}

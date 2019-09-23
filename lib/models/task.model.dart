import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

enum TaskType { Assignment, Quiz, Other }

class TaskModel extends Model {
  String title;
  TaskType type;
  DateTime dueDate;

  TaskModel({this.title, this.dueDate, this.type});

  TaskModel.fromJson(Map<String, dynamic> data) {
    this.title = data["title"];
    this.dueDate = data["dueDate"] != null
        ? (data["dueDate"] as Timestamp).toDate()
        : null;
    this.type = data["type"] == "assignment"
        ? TaskType.Assignment
        : data["type"] == "quiz" ? TaskType.Quiz : TaskType.Other;
  }

  IconData getIcon(){
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

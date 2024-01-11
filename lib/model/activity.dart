import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.Hms();

enum Category { learning, reading, excersing, working }

const categoryIcon = {
  Category.learning: Icons.edit_attributes,
  Category.reading: Icons.book,
  Category.excersing: Icons.sports_bar,
  Category.working: Icons.work_history,
};

class Activity {
  Activity({
    required this.title,
    required this.time,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final DateTime time;
  final DateTime date;
  final Category category;

  String get formattedDate => dateFormatter.format(date);
  String get formattedTime => timeFormatter.format(time);
}

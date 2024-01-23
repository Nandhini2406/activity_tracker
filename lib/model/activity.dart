import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final dateFormatter = DateFormat.yMd();
final timeFormatter = DateFormat.Hms();

enum Category { learning, reading, excersing, working }

const categoryIcon = {
  Category.learning: Icons.note_alt_outlined,
  Category.reading: Icons.menu_book_sharp,
  Category.excersing: Icons.self_improvement_sharp,
  Category.working: Icons.laptop_mac_rounded,
};

class Activity {
  Activity(
    id, {
    required this.title,
    required this.time,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final Duration time;
  final DateTime date;
  final Category category;

  String get formattedDate => dateFormatter.format(date);
  // String get formattedTime => timeFormatter.format(time);

  // Convert Activity to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time.inMilliseconds, 
      'date': date.toIso8601String(), 
      'category': category.toString(),
    };
  }

// Create Activity from JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      json['id'] ?? uuid.v4(),
      title: json['title'] ?? '',
      time: Duration(
          milliseconds: json['time'] ?? 0), 
      date: DateTime.parse(
          json['date'] ?? ''), 
      category: Category.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => Category.learning,
      ),
    );
  }
}

class ActivityBucket {
  const ActivityBucket({
    required this.category,
    required this.activities,
  });

  ActivityBucket.forCategory(List<Activity> allActivities, this.category)
      : activities = allActivities
            .where((activity) => activity.category == category)
            .toList();

  final Category category;
  final List<Activity> activities;

  double get totalTimeSpent {
    double time = 0;
    for (final act in activities) {
      final activityTime = act.time.inMinutes.toDouble();
      time += activityTime;
    }
    return time;
  }
}

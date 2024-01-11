import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';
import 'package:activity_tracker/widgets/activity_list.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final List<Activity> _dailyActivities = [
    Activity(
      title: 'Udemy Training',
      time: DateTime.timestamp(),
      date: DateTime.now(),
      category: Category.learning,
    ),
    Activity(
      title: 'Good Books',
      time: DateTime.timestamp(),
      date: DateTime.now(),
      category: Category.reading,
    ),
    Activity(
      title: 'Brick Task',
      time: DateTime.timestamp(),
      date: DateTime.now(),
      category: Category.working,
    ),
    Activity(
      title: 'Stretching',
      time: DateTime.timestamp(),
      date: DateTime.now(),
      category: Category.excersing,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const Text('Chart'),
            Expanded(child: ActivityList(activity: _dailyActivities))
          ],
        ),
      ),
    );
  }
}

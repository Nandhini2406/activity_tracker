import 'package:activity_tracker/widgets/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({
    super.key,
    required this.activity,
  });
  final List<Activity> activity;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activity.length,
      
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(activity[index]),
        onDismissed: (direction) {
          //delete activity
        },
        child: ActivityItem(activity[index]),
      ),
    );
  }
}

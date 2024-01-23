import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/model/activity.dart';
import 'package:activity_tracker/providers/activity_provider.dart';
import 'package:activity_tracker/widgets/activity_list/activity_item.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({
    super.key,
    required this.activity,
    required this.onDelete,
  });
  final List<Activity> activity;
   final void Function() onDelete;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activity.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(activity[index]),
        background: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          ),
        ),
        onDismissed: (direction) {
          //delete activity
          onDelete();
          final removedActivity = activity.removeAt(index);

          final activityProvider =
              Provider.of<ActivityProvider>(context, listen: false);
          activityProvider.removeActivity(removedActivity);
        },
        child: ActivityItem(activity[index]),
      ),
    );
  }
}

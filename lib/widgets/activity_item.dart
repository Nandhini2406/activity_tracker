import 'package:activity_tracker/model/activity.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem(
    this.activity, {
    super.key,
  });
  final Activity activity;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity.title),
            Row(
              children: [
                Icon(categoryIcon[activity.category], size: 20),
                Text(
                  activity.category.name,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${activity.time.inHours}Hour ${activity.time.inMinutes}Minutes',
                ),
                const Spacer(),
                Text(
                  activity.formattedDate,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

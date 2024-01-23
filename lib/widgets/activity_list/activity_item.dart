import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';

class ActivityItem extends StatelessWidget {
  const ActivityItem(
    this.activity, {
    super.key,
  });

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Spacer(),
                Text(
                  '${activity.time.inHours}h ${activity.time.inMinutes.remainder(60)}m',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(categoryIcon[activity.category], size: 25),
                    const SizedBox(width: 6),
                    Text(
                      activity.category.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(activity.formattedDate),
              ],
            )
          ],
        ),
      ),
    );
  }
}

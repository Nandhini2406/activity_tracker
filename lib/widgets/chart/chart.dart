import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';
import 'package:activity_tracker/widgets/chart/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.activities});

  final List<Activity> activities;

  List<ActivityBucket> get buckets {
    return [
      ActivityBucket.forCategory(activities, Category.excersing),
      ActivityBucket.forCategory(activities, Category.learning),
      ActivityBucket.forCategory(activities, Category.reading),
      ActivityBucket.forCategory(activities, Category.working),
    ];
  }

  double get maxTotalTime { //Total time spent in all activity
    double maxTotalTime = 0;

    for (final bucket in buckets) {
      if (bucket.totalTimeSpent > maxTotalTime) {
        maxTotalTime = bucket.totalTimeSpent;
      }
    }
    return maxTotalTime;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =  // revisit this section for this
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.3),
            Theme.of(context).colorScheme.primary.withOpacity(0.0)
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets) // alternative to map()
                  ChartBar(
                    fill: bucket.totalTimeSpent == 0
                        ? 0
                        : bucket.totalTimeSpent / maxTotalTime,
                  )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: buckets // for ... in
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcon[bucket.category],
                        color: isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}

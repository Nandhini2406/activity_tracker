import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:activity_tracker/model/activity.dart';
import 'package:activity_tracker/providers/activity_provider.dart';
import 'package:activity_tracker/widgets/activity_list/activity_list.dart';
import 'package:activity_tracker/widgets/add_activity.dart';
import 'package:activity_tracker/widgets/chart/chart.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // final List<Activity> _dailyActivities = [];
  
  void addActivityModal() {
    showModalBottomSheet(
      // isScrollControlled: true, // shows full screen modal
      context: context,
      builder: (ctx) => const AddActivity(),
    );
  }

  void deleteActivityModal() {
    // Save the deleted activity for undo
    Activity? lastDeletedActivity;
    final providerActivity =
        Provider.of<ActivityProvider>(context, listen: false);
    setState(() {
      // Get the deleted activity
      final deletedActivity = providerActivity.dailyActivities.first;
      lastDeletedActivity = deletedActivity;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Activity deleted',
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          //undo delete action
          if (lastDeletedActivity != null) {
            // Add the activity back to the list

            providerActivity.addActivity(lastDeletedActivity!);
          }
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final providerActivity = Provider.of<ActivityProvider>(context);

    Widget mainContent = const Center(
      child: Text(
        'No activity found, Add some activity',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );

    if (providerActivity.dailyActivities.isNotEmpty) {
      mainContent = ActivityList(
        activity: providerActivity.dailyActivities,
        onDelete: deleteActivityModal,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker'),
        actions: [
          IconButton(
            onPressed: addActivityModal,
            icon: const Icon(
              Icons.add,
              size: 25.5,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Chart(activities: providerActivity.dailyActivities),
          Expanded(
            child: mainContent,
          )
        ],
      ),
    );
  }
}

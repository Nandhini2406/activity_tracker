import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_list/activity_list.dart';
import '../widgets/add_activity.dart';
import '../widgets/chart/chart.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  void addActivityModal() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true, // shows full screen modal
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
      final deletedActivity = providerActivity.dailyActivities.last;
      lastDeletedActivity = deletedActivity;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Activity deleted',
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo', //undo delete action
        onPressed: () {
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
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
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
      body: width < 600
          ? Column(
              children: [
                Chart(activities: providerActivity.dailyActivities),
                Expanded(
                  child: mainContent,
                )
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(activities: providerActivity.dailyActivities),
                ),
                Expanded(
                  child: mainContent,
                )
              ],
            ),
    );
  }
}

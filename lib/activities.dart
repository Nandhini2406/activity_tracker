import 'package:activity_tracker/widgets/add_activity.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';
import 'package:activity_tracker/widgets/activity_list.dart';
import 'package:activity_tracker/providers/activity_provider.dart';
import 'package:provider/provider.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final List<Activity> _dailyActivities = [
    // Activity(
    //   title: 'Udemy Training',
    //   time: DateTime.timestamp(),
    //   date: DateTime.now(),
    //   category: Category.learning,
    // ),
    // Activity(
    //   title: 'Good Books',
    //   time: DateTime.timestamp(),
    //   date: DateTime.now(),
    //   category: Category.reading,
    // ),
  ];

  void addActivityModal() {
    showModalBottomSheet(
      // isScrollControlled: true, // shows full screen modal
      context: context,
      builder: (ctx) => const AddActivity(),
    );
  }

  void deleteActivityModal() {
    setState(() {
      //Delete activity
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text(
        'Activity deleted',
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          //undo delete action
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    Widget mainContent = const Center(
      child: Text(
        'No activity found, Add some activity',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );

    if (activityProvider.dailyActivities.isNotEmpty) {
      mainContent = ActivityList(activity: activityProvider.dailyActivities);
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
          Container(
            height: 250,
            width: double.infinity,
            color: const Color.fromARGB(255, 178, 209, 236),
            child: const Text('Chart'),
          ),
          Expanded(
            child: mainContent,
          )
        ],
      ),
    );
  }
}

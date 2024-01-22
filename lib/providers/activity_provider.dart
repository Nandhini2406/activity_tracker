import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';

class ActivityProvider extends ChangeNotifier {
  List<Activity> _dailyActivities = [];

  List<Activity> get dailyActivities => _dailyActivities;

  void addActivity(Activity activity) {
    _dailyActivities.add(activity);
    notifyListeners();
  }
}

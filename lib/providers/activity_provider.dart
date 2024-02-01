import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/activity.dart';

class ActivityProvider extends ChangeNotifier {
  List<Activity> _dailyActivities = [];

  List<Activity> get dailyActivities => _dailyActivities;

  ActivityProvider() {
    _loadActivities();
  }

  void addActivity(Activity newActivity) {
    _dailyActivities.add(newActivity);
    notifyListeners();
    _saveActivities();
  }

  void removeActivity(Activity activity) {
    _dailyActivities.remove(activity);
    notifyListeners();
    _saveActivities();
  }

// Load activities from SharedPreferences // Get explanation from GPT
  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? activityStrings =
        prefs.getStringList('daily_activities');

    if (activityStrings != null) {
      _dailyActivities = activityStrings.map((activityString) {
        Map<String, dynamic> jsonMap = jsonDecode(activityString);
        return Activity.fromJson(jsonMap);
      }).toList();

      notifyListeners();
    }
  }

// Save activities to SharedPreferences
  Future<void> _saveActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> activityStrings = _dailyActivities.map((activity) {
      return jsonEncode(activity.toJson());
    }).toList();

    prefs.setStringList('daily_activities', activityStrings);
  }
}

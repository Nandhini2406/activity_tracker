import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/activity.dart';
import '../providers/activity_provider.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({super.key});

  @override
  State<AddActivity> createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _enteredActivity = TextEditingController();

  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  Duration _timeSpent = Duration();

  DateTime? _selectedDate;
  Category _selectedCategory = Category.learning;

  @override
  void dispose() {
    super.dispose();
    _enteredActivity.dispose();
  }

  void _calculateTimeSpent() {
    if (_selectedStartTime != null && _selectedEndTime != null) {
      final startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );

      final endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedEndTime!.hour,
        _selectedEndTime!.minute,
      );
      final timeDifference = endTime.difference(startTime);
      final hours = timeDifference.inHours;
      final minutes = timeDifference.inMinutes.remainder(60);

      setState(() {
        _timeSpent = Duration(hours: hours, minutes: minutes);
      });
    }
  }

  void _presentTimePicker() async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      if (_selectedStartTime == null) {
        _selectedStartTime = pickedTime;
      } else {
        _selectedEndTime = pickedTime;
        _calculateTimeSpent();
      }
    });
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showInvalidAlert() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Enter the valid data in the input field'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Enter the valid data in the input field'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  void onAddActivity() {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    final totalTime = _timeSpent.inHours < 0;

    if (_enteredActivity.text.trim().isEmpty ||
        totalTime ||
        _selectedDate == null) {
      _showInvalidAlert();
      return;
    }

    print(_enteredActivity.text);
    print(_timeSpent.inMinutes.toDouble());
    print(dateFormatter.format(_selectedDate!));
    print(_selectedCategory.name);
    final newActivity = Activity(
      1,
      title: _enteredActivity.text,
      time: _timeSpent,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    activityProvider.addActivity(newActivity);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keybroadSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: 600,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, keybroadSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _enteredActivity,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            labelText: 'New Activity',
                          ),
                        ),
                      ),
                      SizedBox(width: width / 3),
                    ],
                  )
                else
                  TextField(
                    controller: _enteredActivity,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'New Activity',
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _presentTimePicker,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Time',
                          ),
                          child: Text(
                            _selectedStartTime != null
                                ? _selectedStartTime!.format(context)
                                : '',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: _presentTimePicker,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Time',
                          ),
                          child: Text(
                            _selectedEndTime != null
                                ? _selectedEndTime!.format(context)
                                : '',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time Spend',
                        ),
                        child: Text(
                          _timeSpent.inHours >= 0
                              ? '${_timeSpent.inHours}h ${_timeSpent.inMinutes.remainder(60)}m'
                              : '',
                        ),
                      ),
                    ),
                    // const Spacer(),
                    const SizedBox(width: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : dateFormatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton(
                      alignment: Alignment.topLeft,
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        // if (value == null) {
                        //   return;
                        // }
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: onAddActivity,
                      child: const Text('Add Activity'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

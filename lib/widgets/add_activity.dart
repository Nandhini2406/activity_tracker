import 'package:flutter/material.dart';
import 'package:activity_tracker/model/activity.dart';
import 'package:activity_tracker/providers/activity_provider.dart';
import 'package:provider/provider.dart';

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

  void onAddActivity() {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    final totalTime = _timeSpent.inHours < 0;

    if (_enteredActivity.text.trim().isEmpty ||
        totalTime ||
        _selectedDate == null) {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: Column(
        children: [
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
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         controller: _enteredStartTime,
          //         keyboardType: TextInputType.datetime,
          //         decoration: const InputDecoration(
          //           labelText: 'Start Time',
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     Expanded(
          //       child: TextField(
          //         controller: _enteredEndTime,
          //         keyboardType: TextInputType.datetime,
          //         decoration: const InputDecoration(
          //           labelText: 'End Time',
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextField(
          //         controller: _enteredTimeSpend,
          //         keyboardType: TextInputType.datetime,
          //         decoration: const InputDecoration(
          //           labelText: 'Time Spend',
          //         ),
          //       ),
          //     ),
          //     //Datepicker to select date
          //   ],
          // ),
          // const SizedBox(height: 10),
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
    );
  }
}
// class _AddActivityState extends State<AddActivity> {
//   final _enteredActivity = TextEditingController();
//   var _enteredStartTime = TextEditingController();
//   final _enteredEndTime = TextEditingController();
//   final _enteredTimeSpend = TextEditingController();
//   TimeOfDay? _selectedStartTime;
//   TimeOfDay? _selectedEndTime;
//   Duration? _timeSpent;
//   @override
//   void dispose() {
//     super.dispose();
//     _enteredActivity.dispose();
//     _enteredStartTime.dispose();
//     _enteredEndTime.dispose();
//     _enteredTimeSpend.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           TextField(
//             controller: _enteredActivity,
//             maxLength: 50,
//             decoration: const InputDecoration(
//               labelText: 'New Activity',
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _enteredStartTime,
//                   onTap: () async {
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (pickedTime != null) {
//                       setState(() {
//                         _enteredStartTime = TimeOfDay(
//                             hour: pickedTime.hour,
//                             minute: pickedTime.minute) as TextEditingController;
//                       });
//                     }
//                     // if (pickedTime != null) {
//                     //   setState(() {
//                     //     _selectedStartTime = DateTime(
//                     //       DateTime.now().year,
//                     //       DateTime.now().month,
//                     //       DateTime.now().day,
//                     //       pickedTime.hour,
//                     //       pickedTime.minute,
//                     //     );
//                     //     _enteredStartTime =
//                     //         _selectedEndTime as TextEditingController;
//                     //   });
//                     // }
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Start Time',
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: TextField(
//                   // controller: _enteredEndTime,
//                   onTap: () async {
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
//                     if (pickedTime != null) {
//                       setState(() {
//                         _selectedEndTime = TimeOfDay(
//                             hour: pickedTime.hour, minute: pickedTime.minute);
//                       });
//                     }
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'End Time',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // const SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _enteredTimeSpend,
//                   readOnly: true,
//                   decoration: const InputDecoration(
//                     labelText: 'Time Spend',
//                     suffixIcon: Icon(Icons.access_time),
//                   ),
//                 ),
//               ),
//               //Datepicker to select date
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Cancel'),
//               ),
//               const SizedBox(width: 5),
//               ElevatedButton(
//                 onPressed: () {
//                   print(_enteredActivity.text);
//                   print(_selectedStartTime);
//                   print(_selectedEndTime);
//                   print(_timeSpent);
//                 },
//                 child: const Text('Add Activity'),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

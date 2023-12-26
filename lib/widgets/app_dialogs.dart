import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//----------------------------------------------------------------------------//
//Dialog Template
//----------------------------------------------------------------------------//
// Future<T?> showTemplateDialog<T>(
//     BuildContext context,
//     String title,
//     String emoji,
//     bool closeOnClickOutside,
//     List<Widget> actions,
//     Widget child) {
//   return showDialog<T>(
//     barrierDismissible: closeOnClickOutside,
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         insetPadding: EdgeInsets.only(
//             bottom: (MediaQuery.of(context).size.height * (1 / 3)),
//             left: 50,
//             right: 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         child: contentBox(context, context, title, child, emoji, actions),
//       );
//     },
//   );
// }

Future<T?> showTemplateDialog<T>(
  BuildContext context,
  String title,
  String emoji,
  bool closeOnClickOutside,
  List<Widget> actions,
  Widget child,
) {
  return showGeneralDialog(
    barrierDismissible: closeOnClickOutside,
    barrierLabel: "Dismiss",
    transitionDuration: const Duration(milliseconds: 100),
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, animation, secondaryAnimation, widget) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
        child: Dialog(
          insetPadding: EdgeInsets.only(
              bottom: (MediaQuery.of(context).size.height * (1 / 3)),
              left: 50,
              right: 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, context, title, child, emoji, actions),
        ),
      );
    },
  );
}

contentBox(content, context, title, child, emoji, actions) {
  return Stack(
    children: <Widget>[
      Container(
        padding:
            const EdgeInsets.only(left: 20, top: 50, right: 20, bottom: 20),
        margin: const EdgeInsets.only(top: 45),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30),
              child,
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: actions,
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 20,
        right: 20,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).cardColor,
          radius: 45,
          child: ClipRRect(
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 48,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

//----------------------------------------------------------------------------//
//Start date change dialog
//----------------------------------------------------------------------------//
Future<bool> showChangeStartDate(BuildContext context) async {
  return await showTemplateDialog<bool>(
        context,
        "Change Start Date?",
        "📅",
        true,
        [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await showConfirmDialogStartDate(context);
              Navigator.of(context).pop(result);
            },
            child: const Text("Confirm"),
          ),
        ],
        const Text(
            "Changing your start date will delete your failed days and streak."),
      ) ??
      false;
}

Future<bool> showConfirmDialogStartDate(BuildContext context) async {
  return await showTemplateDialog<bool>(
        context,
        "Are You Sure?",
        "❗",
        true,
        [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text("Confirm"),
          ),
        ],
        const Text(
          "Changing your start date will delete your failed days and streak!",
        ),
      ) ??
      false;
}

//----------------------------------------------------------------------------//
//Failed Dialog
//----------------------------------------------------------------------------//
List<String> motivationalQuotes = [
  "You're stronger than you think, don't stop climbing that ladder.", // 1
  "You're closer to the top than the bottom, move forward!", // 2
  "Believe in yourself and get closer to 100% again!", // 3
  "It's okay to fail sometimes. Move forward and get closer to 100% again!", // 4
  "Stay positive and keep moving forward.", // 5
  "Hard work pays off in the end. Keep going!", // 6
  "Challenges make you stronger. Go for a new streak record!", // 7
  "Remember the number of successful days and keep going!", // 8
  "Keep pushing yourself forward; success is just around the corner.", // 9
  "With each challenge, you become a stronger version of yourself.", // 10
  "Don't let a setback define your journey; keep moving forward.", // 11
  "Success is not final, and failure is not fatal. Keep going.", // 12
];

void iFailedTodayDialog(BuildContext context) {
  final random = Random();
  final selectedQuote =
      motivationalQuotes[random.nextInt(motivationalQuotes.length)];
  showTemplateDialog(
    context,
    "Oops!",
    "🩹",
    true,
    [
      ElevatedButton(
        child: const Text('Ok!'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
    Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          selectedQuote,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}

//----------------------------------------------------------------------------//
//Goal information Dialog
//----------------------------------------------------------------------------//
void goalDialog(BuildContext context) {
  showTemplateDialog(
    context,
    "Goal",
    "🥅",
    true,
    [
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Ok"),
      )
    ],
    const Text(
        "Your goal changes based on the percentage of successfull days.\n\nIf you are a certain number of days over your current goal, your goal will be increased."),
  );
}

//----------------------------------------------------------------------------//
//Reset data Dialog
//----------------------------------------------------------------------------//
Future<void> showResetDialog(BuildContext context, Function resetData) async {
  return showTemplateDialog(
    context,
    "Reset",
    "🗑️",
    true,
    [
      ElevatedButton(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      ElevatedButton(
        child: const Text('Reset'),
        onPressed: () async {
          await showConfirmDialogReset(context, resetData);
          Navigator.of(context).pop();
        },
      ),
    ],
    const Text(
        'This will delete your failed days, streak, and set your start date to today.'),
  );
}

Future<bool> showConfirmDialogReset(
    BuildContext context, Function resetData) async {
  return await showTemplateDialog<bool>(
        context,
        "Are You Sure?",
        "❗",
        true,
        [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              resetData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed days and start date have been reset'),
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text("Confirm"),
          ),
        ],
        const Text(
          "Resetting will delete your failed days, streak and will set your start date to today!",
        ),
      ) ??
      false;
}

//----------------------------------------------------------------------------//
//Day information Dialog
//----------------------------------------------------------------------------//
class DayInformationTextWidget extends StatelessWidget {
  final String text;
  final String variable;

  DayInformationTextWidget({required this.text, required this.variable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Text(variable),
        ],
      ),
    );
  }
}

Future<void> showDayInformation(BuildContext context, int succeededDays,
    double avgDaysOfSuccess, int failedDays) {
  return showTemplateDialog(
    context,
    "Your Data in Days",
    "📆",
    true,
    [
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Ok"))
    ],
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DayInformationTextWidget(
            text: "Days succeeded:", variable: "$succeededDays"),
        DayInformationTextWidget(
            text: "Times failed:", variable: "$failedDays"),
        DayInformationTextWidget(
            text: "Average no. days before failure:",
            variable: "$avgDaysOfSuccess"),
      ],
    ),
  );
}

//----------------------------------------------------------------------------//
//Addiction info Dialog
//----------------------------------------------------------------------------//
Future<void> showAddictionInformation(BuildContext context, String addiction,
    DateTime startDate, double percentageGoal) {
  return showTemplateDialog(
    context,
    addiction[0].toUpperCase() + addiction.substring(1),
    "👋",
    true,
    [
      ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Ok"))
    ],
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DayInformationTextWidget(
            text: "Start Date:",
            variable: (DateFormat('dd-MM-yyyy').format(startDate)).toString()),
        DayInformationTextWidget(
            text: "Goal", variable: "${(percentageGoal * 100).toString()}%")
      ],
    ),
  );
}

//----------------------------------------------------------------------------//
//Enter addiction dialog if not known
//----------------------------------------------------------------------------//
Future<void> showAddAddictionName(BuildContext context) async {
  String addiction = "";
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return showTemplateDialog(
      context,
      "Add the Name of Your Addiction/Habit",
      "🖊️",
      false,
      [
        ElevatedButton(
            onPressed: () {
              if (addiction.isNotEmpty) {
                addiction = addiction.toLowerCase();
                prefs.setString('addiction', addiction);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please input your addiction/habit.'),
                  ),
                );
              }
            },
            child: const Text("Save"))
      ],
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("Please enter the name of your addiction/habit."),
          TextField(
            onChanged: (text) {
              addiction = text;
            },
          )
        ],
      ));
}
// final NotificationService notificationService = NotificationService();

// void requestPermissions(context) async {
//   await notificationService.requestNotificationPermissions(context);
// }

// Future<TimeOfDay?> _selectTime(BuildContext context) async {
//   final TimeOfDay? picked = await showTimePicker(
//     context: context,
//     initialTime: TimeOfDay.now(),
//   );
//   if (picked != null && picked != const TimeOfDay(hour: 0, minute: 0)) {
//     return picked;
//   }
// }

// Future<TimeOfDay?> showAddNotificationsDialog(
//     BuildContext context, TimeOfDay? picked) {
//   return showDialog<TimeOfDay>(
//     context: context,
//     builder: (BuildContext context) {
//       TimeOfDay? selectedTime;
//       return AlertDialog(
//         title: const Text("Add Daily Reminder"),
//         content: SingleChildScrollView(
//           child: Column(
//             children: [
//               const Text(
//                 "Add a daily reminder to ask if you've failed by selecting a time",
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 child: const Text("Select time for daily reminder"),
//                 onPressed: () async {
//                   picked = await _selectTime(context);
//                   if (picked != null) {
//                     selectedTime = picked;
//                     Navigator.of(context).pop(selectedTime);
//                   }
//                   debugPrint(picked?.format(context));
//                   AndroidFlutterLocalNotificationsPlugin()
//                       .requestExactAlarmsPermission();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                           'Daily reminder set to ${picked?.format(context)}'),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//               if (picked != null &&
//                   picked != const TimeOfDay(hour: 0, minute: 0))
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         top: 8.0, bottom: 8.0, left: 15, right: 15),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Current Selected Time',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Text(
//                           '${picked?.format(context)}',
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             child: const Text("Cancel"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
//}

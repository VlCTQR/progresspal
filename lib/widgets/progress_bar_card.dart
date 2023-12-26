import 'package:flutter/material.dart';
import 'package:trackerstacker/in_app_tour_target.dart';
import 'package:trackerstacker/widgets/progress_bar.dart';
import 'package:trackerstacker/widgets/progress_bar_day_info.dart';
import 'package:trackerstacker/widgets/start_date_text.dart';
import 'package:trackerstacker/widgets/app_dialogs.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ProgressBarCard extends StatefulWidget {
  final double percentage;
  final int succeededDays;
  final int failedDays;
  final DateTime startDate;
  final String formattedStartDate;
  final String addiction;
  VoidCallback incrementFailedDays;
  final BuildContext context;
  late bool showGoal;

  final GlobalKey addictionKey;
  final GlobalKey progressBarKey;
  final GlobalKey daysKey;
  final GlobalKey percentageKey;
  final GlobalKey failedKey;

  ProgressBarCard({
    Key? key,
    required this.percentage,
    required this.succeededDays,
    required this.failedDays,
    required this.formattedStartDate,
    required this.startDate,
    required this.addiction,
    required this.incrementFailedDays,
    required this.context,
    required this.addictionKey,
    required this.progressBarKey,
    required this.daysKey,
    required this.percentageKey,
    required this.failedKey,
  }) : super(key: key);

  @override
  _ProgressBarCardState createState() => _ProgressBarCardState();
}

class _ProgressBarCardState extends State<ProgressBarCard> {
  @override
  void initState() {
    super.initState();
  }

  double calculatePercentageGoal() {
    // List of possible goals
    final possibleGoals = [
      //0.5, // once every 2 days
      0.66666, // 3 days
      //0.75, // 4 days
      0.8, // 5 days
      //0.833333, // 6 days
      0.8571, // 7 days
      0.90,
      0.9333,
      0.95,
      0.9667
    ];
    // Iterate through the list and find the goal higher than the current percentage
    for (final goal in possibleGoals) {
      if (goal > widget.percentage / 100) {
        widget.showGoal = true;
        return goal;
      }
    }

    // If none is found, return the last goal (highest one)
    widget.showGoal = false;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final percentageGoal = calculatePercentageGoal();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            children: <Widget>[
              // StartDateText(formattedStartDate: formattedStartDate),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showAddictionInformation(context, widget.addiction,
                      widget.startDate, percentageGoal);
                },
                child: SizedBox(
                    width: 325,
                    child: Row(
                      key: widget.addictionKey,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "My success in quitting ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.addiction,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 5),
              ProgressBar(
                  key: widget.progressBarKey,
                  percentage: widget.percentage,
                  percentageGoal: percentageGoal),
              DayInfo(
                  key: widget.daysKey,
                  percentage: widget.percentage,
                  succeededDays: widget.succeededDays,
                  failedDays: widget.failedDays,
                  startDate: widget.startDate),
              const SizedBox(height: 50),
              const Text(
                "I succeeded for",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                key: widget.percentageKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.percentage.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                key: widget.failedKey,
                onPressed: widget.incrementFailedDays,
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  backgroundColor: Colors.deepPurple[200],
                ),
                child: const Text(
                  'I Failed',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

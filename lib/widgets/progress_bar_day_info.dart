import 'package:flutter/material.dart';
import 'app_dialogs.dart';

class DayInfo extends StatelessWidget {
  final double percentage;
  final int succeededDays;
  final int failedDays;
  final DateTime startDate;

  const DayInfo(
      {Key? key,
      required this.percentage,
      required this.succeededDays,
      required this.failedDays,
      required this.startDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          showDayInformation(
              context,
              succeededDays,
              double.parse(
                  (DateTime.now().difference(startDate).inDays / failedDays)
                      .toStringAsFixed(2)),
              failedDays);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$succeededDays',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: percentage != 100,
              child: Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepPurple[300]!, Colors.purple[600]!],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: percentage != 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${(DateTime.now().difference(startDate).inDays / failedDays).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: percentage != 100,
              child: Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple[600]!, Colors.deepPurple[300]!],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$failedDays',
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

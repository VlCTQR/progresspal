import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final double percentage;
  final DateTime startDate;
  final int failedDays;
  VoidCallback incrementFailedDays;

  MainCard({
    Key? key,
    required this.percentage,
    required this.startDate,
    required this.failedDays,
    required this.incrementFailedDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: Column(
              children: [
                const Text(
                  'Percentage of succeeded days:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${percentage.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Visibility(
                  visible: percentage != 100,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.black,
                          ),
                          Text(
                            " You statistically fail once every ${(DateTime.now().difference(startDate).inDays / failedDays).toStringAsFixed(2)} days",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: incrementFailedDays,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple[200] ?? Colors.purple,
                    ),
                  ),
                  child: const Text(
                    'I Failed',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

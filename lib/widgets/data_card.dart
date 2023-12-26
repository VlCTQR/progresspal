import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final int failedDays;
  final int streak;
  final int highestStreak;

  const DataCard(
      {Key? key,
      required this.failedDays,
      required this.streak,
      required this.highestStreak})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Streak',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    "lib/assets/fire_icon.png",
                    scale: 15,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Current Streak: $streak',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    "lib/assets/fire_icon.png",
                    scale: 15,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Highest Streak: $highestStreak',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

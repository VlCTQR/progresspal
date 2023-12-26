import 'package:flutter/material.dart';

class StartDateText extends StatelessWidget {
  final String formattedStartDate;

  StartDateText({required this.formattedStartDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: 'Start date: ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: formattedStartDate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

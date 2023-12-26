import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percentage;
  final double percentageGoal;
  const ProgressBar(
      {Key? key, required this.percentage, required this.percentageGoal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: 70,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 8, right: 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.deepPurple[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 8, right: 8),
            child: FractionallySizedBox(
              widthFactor: percentage / 100.0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple[700]!, Colors.purple[600]!]),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 25),
            child: FractionallySizedBox(
              widthFactor: percentage / 100,
              heightFactor: 1.3,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  RotationTransition(
                    turns: const AlwaysStoppedAnimation(35 / 360),
                    child: Card(
                      elevation: 0,
                      child: Container(
                          width: 20, height: 80, color: Colors.deepPurple[300]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Card voor het verbergen van overlappende kleuren boven
          const Card(
            elevation: 0,
            child: SizedBox(
              height: 16,
              width: 400,
            ),
          ),
          //Card voor het verbergen van overlappende kleuren onder
          const Positioned(
            top: 56,
            child: Card(
              elevation: 0,
              child: SizedBox(
                height: 16,
                width: 340,
              ),
            ),
          ),
          //Percentage goal streepje
          Padding(
            padding:
                const EdgeInsets.only(top: 20, bottom: 10, left: 8, right: 8),
            child: FractionallySizedBox(
              widthFactor: percentageGoal,
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  RotationTransition(
                    turns: const AlwaysStoppedAnimation(35 / 360),
                    child: Container(
                      width: 2,
                      height: 60,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Gedraaid blokje linkerkant
          const RotationTransition(
            turns: AlwaysStoppedAnimation(35 / 360),
            child: Card(
              elevation: 0,
              child: SizedBox(
                width: 15,
                height: 70,
              ),
            ),
          ),
          //Blokje linkerkant
          const Card(
            elevation: 0,
            child: SizedBox(
              width: 20,
              height: 30,
            ),
          ),
          //Gedraaid blokje rechterkant
          Positioned(
            left: MediaQuery.of(context).size.width * 0.81,
            child: const RotationTransition(
              turns: AlwaysStoppedAnimation(35 / 360),
              child: Card(
                elevation: 0,
                child: SizedBox(
                  width: 15,
                  height: 75,
                ),
              ),
            ),
          ),
          //Blokje rechterkant
          Positioned(
            left: MediaQuery.of(context).size.width * 0.82,
            child: const RotationTransition(
              turns: AlwaysStoppedAnimation(35 / 360),
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Card(
                  elevation: 0,
                  child: SizedBox(
                    width: 35,
                    height: 54,
                    //color: Color.fromRGBO(179, 146, 255, 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

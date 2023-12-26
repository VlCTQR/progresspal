import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void addTarget(List<TargetFocus> targets, GlobalKey keyTarget, String title,
    String? body, String emoji) {
  GlobalKey nextButtonKey = GlobalKey();

  targets.add(TargetFocus(
    keyTarget: keyTarget,
    alignSkip: Alignment.bottomCenter,
    radius: 10,
    shape: ShapeLightFocus.RRect,
    pulseVariation: Tween(begin: 1.0, end: 0.99),
    focusAnimationDuration: const Duration(milliseconds: 400),
    unFocusAnimationDuration: const Duration(milliseconds: 200),
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        builder: (context, controller) {
          void goToNextTarget() {
            controller.next();
          }

          return Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 250,
                  padding: const EdgeInsets.only(
                      left: 20, top: 50, right: 20, bottom: 20),
                  margin: const EdgeInsets.only(top: 45),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: const Color.fromRGBO(179, 146, 255, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        if (body != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            body,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton(
                          key: nextButtonKey,
                          onPressed: goToNextTarget,
                          child: const Text("Next"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                top: 20,
                child: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(179, 146, 255, 1),
                  radius: 30,
                  child: ClipRRect(
                    child: Text(
                      emoji,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ],
  ));
}

List<TargetFocus> targetsAppbar({
  required GlobalKey startDateKey,
  required GlobalKey resetKey,
  required GlobalKey themeKey,
}) {
  List<TargetFocus> targets = [];

  addTarget(targets, startDateKey, "Change the Start Date", null, "📆");
  addTarget(targets, resetKey, "Reset Data", null, "🗑️");
  addTarget(targets, themeKey, "Change Theme Mode", null, "🌗");

  return targets;
}

List<TargetFocus> targetsProgressbarCard({
  required GlobalKey addictionKey,
  required GlobalKey progressBarKey,
  required GlobalKey daysKey,
  required GlobalKey percentageKey,
  required GlobalKey failedKey,
}) {
  List<TargetFocus> targets = [];

  addTarget(targets, addictionKey, "Your Addiction",
      "Press the text to get more information", "👋");
  addTarget(targets, progressBarKey, "Your Progress",
      "Visually represents your success", "🌡");
  addTarget(targets, daysKey, "Your Success in Days",
      "Press the area to get more information", "📊");
  addTarget(targets, percentageKey, "Your Progress",
      "Presented as a big number", "💯");
  addTarget(targets, failedKey, "The Button",
      "Press this button everytime you fail", "📉");

  return targets;
}

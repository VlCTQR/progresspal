import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackerstacker/main.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionScreenWidget extends StatefulWidget {
  const IntroductionScreenWidget();

  @override
  _IntroductionScreenWidgetState createState() =>
      _IntroductionScreenWidgetState();
}

class _IntroductionScreenWidgetState extends State<IntroductionScreenWidget> {
  final introKey = GlobalKey<IntroductionScreenState>();
  final TextEditingController addictionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    addictionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      freeze: true,
      pages: [
        PageViewModel(
          image: Image.asset(
            "lib/assets/logo.png",
            width: 200,
            height: 200,
          ),
          title: "Welcome to ProgressPal",
          // body:
          //     "Unlike traditional streak-based apps, we focus on your journey to recovery by tracking the percentage of successful days compared to the days you faced challenges.\n\n Your progress, not perfection, is what matters most.",
          bodyWidget: Column(
            children: [
              const Text(
                  "Unlike traditional streak-based apps, we focus on your journey to recovery by tracking the percentage of successful days compared to the days you faced challenges.\n\n Your progress, not perfection, is what matters most."),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () => introKey.currentState?.next(),
                  child: const Text("Next")),
            ],
          ),
        ),
        PageViewModel(
          image: Image.asset(
            "lib/assets/logo.png",
            width: 200,
            height: 200,
          ),
          title: "What addiction/habit are you trying to quit?",
          bodyWidget: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: addictionController,
                  // decoration: InputDecoration(
                  //   labelText: 'Enter your addiction/habit',
                  // ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  String enteredText = addictionController.text;
                  enteredText = enteredText.toLowerCase();

                  if (enteredText.isNotEmpty) {
                    // Opslaan in shared preferences
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('addiction', enteredText);

                    // Ga verder naar de volgende pagina
                    introKey.currentState?.next();
                  } else {
                    // Toon een Snackbar als het veld leeg is
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please input your addiction/habit.'),
                      ),
                    );
                  }
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ),
        PageViewModel(
          image: Image.asset(
            "lib/assets/logo.png",
            width: 200,
            height: 200,
          ),
          title: "It's Your Time for Change",
          // body:
          //     "Start your journey with ProgressPal with pressing the button \"Start Journey\".\n\nWe wish you much success.",
          bodyWidget: Column(
            children: [
              const Text(
                  "Start your journey with ProgressPal with pressing the button \"Start Journey\".\n\nWe wish you much success."),
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: 'ProgressPal'),
                        ),
                      ),
                  child: const Text("Start Journey")),
            ],
          ),
        ),
      ],
      onDone: () async {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('first_time', false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'ProgressPal'),
          ),
        );
      },
      showDoneButton: false,
      //done: const Text("Start Journey"),
      showNextButton: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:trackerstacker/in_app_tour_target.dart';
import 'package:trackerstacker/screens/introduction_screen.dart';
import 'package:trackerstacker/widgets/progress_bar_card.dart';
import 'package:trackerstacker/widgets/data_card.dart';
import 'package:provider/provider.dart';
import 'package:trackerstacker/configuration/theme_manager.dart';
//import 'package:trackerstacker/widgets/main_card.dart';
import 'package:trackerstacker/widgets/app_dialogs.dart';
//import 'package:trackerstacker/configuration/ad_helper.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('first_time') ?? true;
  //bool isFirstTime = true;
  int? savedThemeMode = prefs.getInt('theme_mode');

  // If no theme mode is saved, use the system's theme mode
  if (savedThemeMode == null) {
    final Brightness platformBrightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    savedThemeMode = platformBrightness == Brightness.light ? 0 : 1;
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager()..toggleTheme(savedThemeMode == 1),
      child: Builder(
        builder: (context) {
          final themeManager = Provider.of<ThemeManager>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ProgressPal',
            themeMode: themeManager.themeMode,
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.grey[300],
              scaffoldBackgroundColor: Colors.grey[300],
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.black,
              scaffoldBackgroundColor: Colors.black,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              cardTheme:
                  const CardTheme(color: Color.fromRGBO(179, 146, 255, 1)),
            ),
            home: isFirstTime
                ? MyApp(
                    isFirstTime: isFirstTime,
                  )
                : const MyHomePage(title: 'ProgressPal'),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  const MyApp({Key? key, required this.isFirstTime}) : super(key: key);

  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  //   return MobileAds.instance.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    //_initGoogleMobileAds();
    return isFirstTime
        ? const IntroductionScreenWidget()
        : const MyHomePage(title: 'ProgressPal');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _startDate = DateTime.now();
  int _failedDays = 0;
  double _percentage = 100.0;
  int _streak = 0;
  int _highestStreak = 0;
  String _addiction = "";
  TimeOfDay? _selectedTime;
  //BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _checkStartDate();
    _loadData();
    _loadSelectedTime();
    _initAddAppTourAppbar();
    _initAddAppTourProgressBar();
    _showAppTour();

    //_loadBannerAd();
  }

  // @override
  // void dispose() {
  //   _bannerAd?.dispose();
  //   super.dispose();
  // }

  // Future<void> _loadBannerAd() async {
  //   final ad = BannerAd(
  //     adUnitId: AdHelper.bannerAdUnitId,
  //     request: AdRequest(),
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       onAdLoaded: (ad) {
  //         setState(() {
  //           _bannerAd = ad as BannerAd;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, err) {
  //         debugPrint('Failed to load a banner ad: ${err.message}');
  //         ad.dispose();
  //       },
  //     ),
  //   );
  //   await ad.load();
  // }

  _checkStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('start_date');
    final streakStartDay = prefs.getString('streak_start_date');
    final highestStreak = prefs.getInt('highest_streak');
    if (storedDate != null) {
      debugPrint('Start Date in SharedPreferences: $storedDate');
      debugPrint('Streak Start Date: $streakStartDay');
      debugPrint('Highest Streak: ${highestStreak.toString()}');
    } else {
      debugPrint('Start Date not found in SharedPreferences.');
    }
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if there is a stored start date, if not, set it to the current date
    final storedDate = prefs.getString('start_date');
    if (storedDate == null) {
      final currentDate = DateTime.now().toIso8601String();
      prefs.setString('start_date', currentDate);
    } else {
      final today = DateTime.now();
      final startDate = DateTime.parse(storedDate);
      final daysSinceStart = today.difference(startDate).inDays;

      setState(() {
        _startDate = startDate;
        _failedDays = prefs.getInt('failed_days') ?? 0;

        // Check if there are more failed days than days since the start date
        if (_failedDays >= daysSinceStart) {
          _percentage = 0.0;
          _streak = 0;
        } else {
          _highestStreak = prefs.getInt('highest_streak') ?? 0;
          _percentage = (_failedDays == 0)
              ? 100.0
              : (daysSinceStart - _failedDays) / daysSinceStart * 100;

          final streakStartDate = prefs.getString('streak_start_date');
          if (streakStartDate != null) {
            final streakStart = DateTime.parse(streakStartDate);
            final today = DateTime.now();
            if (today.isAfter(streakStart)) {
              _streak = today.difference(streakStart).inDays;
              if (_streak > _highestStreak) {
                _highestStreak = _streak;
                prefs.setInt('highest_streak', _highestStreak);
              }
            }
          }
        }
      });
    }
    final savedAddiction = prefs.getString('addiction');
    //final savedAddiction = null;
    if (savedAddiction != null) {
      setState(() {
        _addiction = savedAddiction;
      });
    } else {
      await showAddAddictionName(context);
      tutorialCoachMarkAppbar.show(context: context);
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool confirmChange = await showChangeStartDate(context);

    if (confirmChange) {
      _resetData();
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          final themeMode = Provider.of<ThemeManager>(context).themeMode;
          if (themeMode == ThemeMode.dark) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      onPrimary: Colors.white,
                      surface: Colors.grey[900],
                      onSurface: Colors.white,
                    ),
              ),
              child: child!,
            );
          } else {
            return child!;
          }
        },
      );
      if (picked != null) {
        // Calculate the new streak start date
        final DateTime newStartDate = picked;
        final DateTime today = DateTime.now();

        // Calculate the new streak by comparing the new start date to today
        int newStreak = today.isAfter(newStartDate)
            ? today.difference(newStartDate).inDays
            : 0;

        setState(() {
          _startDate = newStartDate;
          _failedDays = 0;
          _streak = newStreak;
          prefs.setString('start_date', newStartDate.toIso8601String());
          prefs.setString('streak_start_date', newStartDate.toIso8601String());
          _checkStartDate();
          _loadData();
        });
      }
    }
  }

  _incrementFailedDays() async {
    int recentStreak = _streak;
    _streak = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _failedDays++;

      // Check if there are more failed days than days since the start date
      if (_failedDays >= DateTime.now().difference(_startDate).inDays) {
        _percentage = 0.0;
      } else {
        final today = DateTime.now();
        DateTime streakStart =
            today.add(const Duration(days: 1)); // Default to tomorrow
        final streakStartDate = prefs.getString('streak_start_date');
        if (streakStartDate != null) {
          streakStart = DateTime.parse(streakStartDate);
        }
        if (today.isAfter(streakStart)) {
          recentStreak = today.difference(streakStart).inDays;
          if (recentStreak > _highestStreak) {
            _highestStreak = recentStreak;
            prefs.setInt('highest_streak', _highestStreak);
          }
        }
      }

      prefs.setString('streak_start_date', DateTime.now().toIso8601String());

      prefs.setInt('failed_days', _failedDays);
    });

    iFailedTodayDialog(context);
    _loadData();
  }

  _resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _startDate = DateTime.now();
      _failedDays = 0;
      _percentage = 100.0;
      _streak = 0;
      _highestStreak = 0;
    });

    final currentDate = _startDate.toIso8601String();
    prefs.setString('start_date', currentDate);
    prefs.setInt('failed_days', 0);
    prefs.setInt('highest_streak', _highestStreak);
    prefs.remove('streak_start_date');
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      // Verwerk hier de geselecteerde tijd
    }
  }

  Future<void> _loadSelectedTime() async {
    final prefs = await SharedPreferences.getInstance();
    final int? hour = prefs.getInt('selectedHour');
    final int? minute = prefs.getInt('selectedMinute');

    if (hour != null && minute != null) {
      setState(() {
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
        debugPrint(_selectedTime?.format(context));
      });
    }
  }

  // Future<void> _saveSelectedTime(TimeOfDay time) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('selectedHour', time.hour);
  //   await prefs.setInt('selectedMinute', time.minute);
  //   NotificationService().scheduleNotification();
  //   debugPrint(time.format(context));
  // }

  final startDateKey = GlobalKey();
  final resetKey = GlobalKey();
  final themeKey = GlobalKey();

  final addictionKey = GlobalKey();
  final progressBarKey = GlobalKey();
  final daysKey = GlobalKey();
  final percentageKey = GlobalKey();
  final failedKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMarkAppbar;
  late TutorialCoachMark tutorialCoachMarkProgressBarCard;

  void _initAddAppTourProgressBar() async {
    tutorialCoachMarkProgressBarCard = TutorialCoachMark(
        targets: targetsProgressbarCard(
            addictionKey: addictionKey,
            progressBarKey: progressBarKey,
            daysKey: daysKey,
            percentageKey: percentageKey,
            failedKey: failedKey),
        colorShadow: Colors.deepPurple,
        paddingFocus: 10,
        hideSkip: true,
        opacityShadow: 0.8,
        onFinish: () async {
          debugPrint("Completed Tour ProgressBar");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('first_time', false);
        });
  }

  void _initAddAppTourAppbar() {
    tutorialCoachMarkAppbar = TutorialCoachMark(
        targets: targetsAppbar(
            startDateKey: startDateKey, resetKey: resetKey, themeKey: themeKey),
        colorShadow: Colors.deepPurple,
        paddingFocus: 10,
        hideSkip: true,
        opacityShadow: 0.8,
        onFinish: () {
          debugPrint("Completed Tour Appbar");
          tutorialCoachMarkProgressBarCard.show(context: context);
        });
  }

  void _showAppTour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_time') ?? true) {
      tutorialCoachMarkAppbar.show(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedStartDate = DateFormat('dd-MM-yyyy').format(_startDate);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purple[600]!,
                Colors.deepPurple[300]!,
              ],
            ),
          ),
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            key: startDateKey,
            icon: const Icon(Icons.edit),
            onPressed: () {
              _selectStartDate(context);
            },
          ),
          IconButton(
            key: resetKey,
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showResetDialog(context, _resetData);
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.notification_add),
          //   onPressed: () async {
          //     final TimeOfDay? time =
          //         await showAddNotificationsDialog(context, _selectedTime);
          //     if (time != null) {
          //       setState(() {
          //         _selectedTime = time;
          //       });
          //       await _saveSelectedTime(time);
          //     }
          //   },
          // ),
          IconButton(
            key: themeKey,
            icon: Icon(
                Provider.of<ThemeManager>(context).themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
            onPressed: () {
              final themeManager =
                  Provider.of<ThemeManager>(context, listen: false);
              themeManager.toggleTheme(
                themeManager.themeMode == ThemeMode.dark ? false : true,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                ProgressBarCard(
                  //key: progressBarKey,
                  percentage: _percentage,
                  succeededDays: DateTime.now().difference(_startDate).inDays -
                      _failedDays,
                  failedDays: _failedDays,
                  formattedStartDate: formattedStartDate,
                  startDate: _startDate,
                  addiction: _addiction,
                  incrementFailedDays: _incrementFailedDays,
                  context: context,
                  addictionKey: addictionKey,
                  progressBarKey: progressBarKey,
                  daysKey: daysKey,
                  percentageKey: percentageKey,
                  failedKey: failedKey,
                ),
                const SizedBox(height: 30),
                // MainCard(
                //   percentage: _percentage,
                //   startDate: _startDate,
                //   failedDays: _failedDays,
                //   incrementFailedDays: _incrementFailedDays,
                // ),
                // const SizedBox(height: 30),
                DataCard(
                  failedDays: _failedDays,
                  streak: _streak,
                  highestStreak: _highestStreak,
                ),
              ],
            ),
          ),
          // Visibility(
          //   visible: _bannerAd != null,
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       width: _bannerAd!.size.width.toDouble(),
          //       height: _bannerAd!.size.height.toDouble(),
          //       child: AdWidget(ad: _bannerAd!),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

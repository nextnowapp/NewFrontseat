// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:nextschool/screens/frontseat/landing_screen.dart';
import 'package:nextschool/utils/FunctionsData.dart';
import 'package:nextschool/utils/Utils.dart';
import 'package:nextschool/utils/widget/customLoader.dart';
// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  Animation? animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    Route route;
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween(begin: 30.0, end: 90.0).animate(controller);
    controller.forward();

    getBooleanValue('isLogged').then((value) {
      if (value) {
        // FirebaseCrashlytics.instance.log("Test Crash");
        // FirebaseCrashlytics.instance.crash();
        Utils.getStringValue('rule').then((rule) {
          Utils.getIntValue('zoom').then((zoom) {
            print('Getting rule and zoom value : $rule $zoom');
            AppFunction.getFunctions(context, rule, zoom.toString());
          });
        });
      } else {
        route = MaterialPageRoute(builder: (context) => const LandingScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFC7EAFF),
      child: const Center(child: CustomLoader()),
    );
  }

  Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
}

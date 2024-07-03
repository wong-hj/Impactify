import 'package:flutter/material.dart';
import 'package:impactify_app/screens/onboarding/onboarding_screen.dart';
import 'package:impactify_app/screens/user/community.dart';
import 'package:impactify_app/screens/user/event_details.dart';
import 'package:impactify_app/screens/user/events.dart';
import 'package:impactify_app/screens/user/home.dart';
import 'package:impactify_app/screens/user/home_screen.dart';
import 'package:impactify_app/screens/user/login.dart';
import 'theming/custom_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: //const OnboardingScreens(),
      //Login(),
      //Home(),
      //BottomNavBar()
      //Events(),
      //HomeScreen()
      //Community()
      EventDetail(),
    );
  }
}

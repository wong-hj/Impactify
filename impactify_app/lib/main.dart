import 'package:flutter/material.dart';
import 'package:impactify_app/screens/onboarding/onboarding_screen.dart';
import 'package:impactify_app/screens/user/addPost.dart';
import 'package:impactify_app/screens/user/bookmark.dart';
import 'package:impactify_app/screens/user/community.dart';
import 'package:impactify_app/screens/user/editProfile.dart';
import 'package:impactify_app/screens/user/eventDetails.dart';
import 'package:impactify_app/screens/user/events.dart';
import 'package:impactify_app/screens/user/home.dart';
import 'package:impactify_app/screens/user/home_screen.dart';
import 'package:impactify_app/screens/user/login.dart';
import 'package:impactify_app/screens/user/profile.dart';
import 'package:impactify_app/screens/user/signup.dart';
import 'theming/custom_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => OnboardingScreens(),
          '/login': (context) => Login(),
          '/signup': (context) => SignUp(),
          '/home': (context) => Home(),
          '/events': (context) => Events(),
          '/eventDetail': (context) => EventDetail(),
          '/addPost': (context) => AddPost(),
          '/community': (context) => Community(),
          '/editProfile': (context) => EditProfile(),
          '/homeScreen': (context) => HomeScreen(),
          '/profile': (context) => Profile(),
          '/bookmark': (context) => Bookmark(),

        }

        );
  }
}

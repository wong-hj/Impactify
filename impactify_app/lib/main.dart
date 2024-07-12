import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/providers/speech_provider.dart';
import 'package:impactify_app/providers/user_provider.dart';
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
import 'package:impactify_app/screens/user/schedule.dart';
import 'package:impactify_app/screens/user/speechDetails.dart';
import 'theming/custom_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    //final user = ref.watch(userProvider.notifier);

    return MaterialApp(
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      initialRoute: authState.userData != null ? '/homeScreen' : '/',
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
        '/speechDetail': (context) => SpeechDetail(),
      },
    );
  }
}

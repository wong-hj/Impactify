import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/providers/bookmark_provider.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/providers/participation_provider.dart';
import 'package:impactify_app/providers/post_provider.dart';
import 'package:impactify_app/providers/speech_provider.dart';
import 'package:impactify_app/providers/user_provider.dart';
import 'package:impactify_app/screens/onboarding/onboarding_screen.dart';
import 'package:impactify_app/screens/user/addPost.dart';
import 'package:impactify_app/screens/user/bookmark.dart';
import 'package:impactify_app/screens/user/community.dart';
import 'package:impactify_app/screens/user/editPost.dart';
import 'package:impactify_app/screens/user/editProfile.dart';
import 'package:impactify_app/screens/user/eventDetails.dart';
import 'package:impactify_app/screens/user/events.dart';
import 'package:impactify_app/screens/user/home.dart';
import 'package:impactify_app/screens/user/home_screen.dart';
import 'package:impactify_app/screens/user/login.dart';
import 'package:impactify_app/screens/user/profile.dart';
import 'package:impactify_app/screens/user/recording.dart';
import 'package:impactify_app/screens/user/signup.dart';
import 'package:impactify_app/screens/user/schedule.dart';
import 'package:impactify_app/screens/user/speechDetails.dart';
import 'package:impactify_app/screens/user/userPost.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'theming/custom_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (_) => AuthProvider()..checkCurrentUser()),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (context) => UserProvider(null),
          update: (context, authProvider, userProvider) {
            userProvider?.initialize(authProvider.user);
            return userProvider!;
          }),
          ChangeNotifierProvider(create: (context) => EventProvider()), 
          ChangeNotifierProvider(create: (_) => BookmarkProvider()),
          ChangeNotifierProvider(create: (_) => SpeechProvider()),
          ChangeNotifierProvider(create: (_) => ParticipationProvider()),
          ChangeNotifierProvider(create: (_) => PostProvider()),

      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner:false,
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            initialRoute: authProvider.userData != null ? '/homeScreen' : '/',
            routes: {
              '/': (context) => 
              OnboardingScreens(),
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
              '/recording': (context) => Recording(),
              '/userPost': (context) => UserPost(),
              '/editPost': (context) => EditPost(),
              '/schedule': (context) => Schedule(),
            },
          );
        },
      ),
    );
  }
}

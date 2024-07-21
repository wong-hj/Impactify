import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/providers/auth_provider.dart';
import 'package:impactify_management/providers/post_provider.dart';
import 'package:impactify_management/providers/user_provider.dart';
import 'package:impactify_management/screens/add_project.dart';
import 'package:impactify_management/screens/attendees.dart';
import 'package:impactify_management/screens/dashboard.dart';
import 'package:impactify_management/screens/home_screen.dart';
import 'package:impactify_management/screens/login.dart';
import 'package:impactify_management/screens/manage_project.dart';
import 'package:impactify_management/screens/manage_speech.dart';
import 'package:impactify_management/screens/pdfviewer.dart';
import 'package:impactify_management/screens/profile.dart';
import 'package:impactify_management/screens/project_details.dart';
import 'package:impactify_management/screens/recording.dart';
import 'package:impactify_management/screens/signup.dart';
import 'package:impactify_management/screens/speech_details.dart';
import 'package:impactify_management/screens/terms.dart';
import 'package:impactify_management/screens/view_post.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ActivityProvider()),
          ChangeNotifierProvider(create: (_) => PostProvider()),
        ],
        child: MaterialApp(
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          initialRoute: '/login',
          routes: {
            '/login': (context) => Login(),
            '/signup': (context) => SignUp(),
            '/terms': (context) => Terms(),
            '/homeScreen': (context) => HomeScreen(),
            '/dashboard': (context) => Dashboard(),
            '/profile': (context) => Profile(),
            '/pdfViewer': (context) => PDFViewerCachedFromUrl(),
            '/manageProject': (context) => ManageProject(),
            '/manageSpeech': (context) => ManageSpeech(),
            '/projectDetail': (context) => ProjectDetail(),
            '/speechDetail': (context) => SpeechDetail(),
            '/attendees': (context) => Attendees(),
            '/recording': (context) => Recording(),
            '/viewPost': (context) => ViewPost(),
            '/addProject': (context) => AddProject(),



          },
        ));
  }
}

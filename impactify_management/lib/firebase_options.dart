// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBSxrAM8U54JxMdCaFboUoONylVEcGCGhg',
    appId: '1:1038533174457:web:68a902e9ae25ef59676768',
    messagingSenderId: '1038533174457',
    projectId: 'impactifyapp-1fcfa',
    authDomain: 'impactifyapp-1fcfa.firebaseapp.com',
    storageBucket: 'impactifyapp-1fcfa.appspot.com',
    measurementId: 'G-39WP4XVTZG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6yfWj8LmwCAbanbwAJp36apec856KOIg',
    appId: '1:1038533174457:android:9c86985c0a91434b676768',
    messagingSenderId: '1038533174457',
    projectId: 'impactifyapp-1fcfa',
    storageBucket: 'impactifyapp-1fcfa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcNYvSDlatiiKntlSC9OXZ-N8wH4zvusg',
    appId: '1:1038533174457:ios:ef6ab679f18eded9676768',
    messagingSenderId: '1038533174457',
    projectId: 'impactifyapp-1fcfa',
    storageBucket: 'impactifyapp-1fcfa.appspot.com',
    androidClientId: '1038533174457-978mj1dsepdkua5slhifev0h6kcbl0sm.apps.googleusercontent.com',
    iosClientId: '1038533174457-tii892r6actgha68db6qonopaorsau7v.apps.googleusercontent.com',
    iosBundleId: 'com.example.impactifyManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcNYvSDlatiiKntlSC9OXZ-N8wH4zvusg',
    appId: '1:1038533174457:ios:ef6ab679f18eded9676768',
    messagingSenderId: '1038533174457',
    projectId: 'impactifyapp-1fcfa',
    storageBucket: 'impactifyapp-1fcfa.appspot.com',
    androidClientId: '1038533174457-978mj1dsepdkua5slhifev0h6kcbl0sm.apps.googleusercontent.com',
    iosClientId: '1038533174457-tii892r6actgha68db6qonopaorsau7v.apps.googleusercontent.com',
    iosBundleId: 'com.example.impactifyManagement',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBSxrAM8U54JxMdCaFboUoONylVEcGCGhg',
    appId: '1:1038533174457:web:721dfa4360c65fb5676768',
    messagingSenderId: '1038533174457',
    projectId: 'impactifyapp-1fcfa',
    authDomain: 'impactifyapp-1fcfa.firebaseapp.com',
    storageBucket: 'impactifyapp-1fcfa.appspot.com',
    measurementId: 'G-FN977NL2CH',
  );
}
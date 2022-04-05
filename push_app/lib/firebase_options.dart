// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAMWCE4el57JT32okLiHyTyE6DN6AJW3s8',
    appId: '1:950473088719:web:27a0d0c8f4b8bf3fde61ba',
    messagingSenderId: '950473088719',
    projectId: 'push-mess-app',
    authDomain: 'push-mess-app.firebaseapp.com',
    storageBucket: 'push-mess-app.appspot.com',
    measurementId: 'G-K63CB78J35',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBP7HQLy7pCvCud4HJH4l8gFpXoyA1_7z0',
    appId: '1:950473088719:android:0f9bbba5516baf3cde61ba',
    messagingSenderId: '950473088719',
    projectId: 'push-mess-app',
    storageBucket: 'push-mess-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAPhaOav2QfwXWtR_K4YZhcrer3iwKf3KA',
    appId: '1:950473088719:ios:c41010f6a40b0b01de61ba',
    messagingSenderId: '950473088719',
    projectId: 'push-mess-app',
    storageBucket: 'push-mess-app.appspot.com',
    iosClientId: '950473088719-f2tcr6fvrndto125bgu7imioag81kei5.apps.googleusercontent.com',
    iosBundleId: 'com.example.pushApp',
  );
}

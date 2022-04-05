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
    apiKey: 'AIzaSyAxnz8UjfVItYHfm9lYRp_CV1GP28SlGTs',
    appId: '1:884950978793:web:94b4d59ada97cea83fe078',
    messagingSenderId: '884950978793',
    projectId: 'push-message-one-signal',
    authDomain: 'push-message-one-signal.firebaseapp.com',
    storageBucket: 'push-message-one-signal.appspot.com',
    measurementId: 'G-PZF2J6TTW9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWpsU0HdjaDxddxIbYrIbZs_-6Df9v_hk',
    appId: '1:884950978793:android:869fd42a8177cf253fe078',
    messagingSenderId: '884950978793',
    projectId: 'push-message-one-signal',
    storageBucket: 'push-message-one-signal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDknxNgPGerJQt4W9v_0BjgRReLe9dAuHA',
    appId: '1:884950978793:ios:b1afe8f8b1d02d273fe078',
    messagingSenderId: '884950978793',
    projectId: 'push-message-one-signal',
    storageBucket: 'push-message-one-signal.appspot.com',
    iosClientId: '884950978793-1s91n0efkcfjqo6os761ttdl6jv92kh9.apps.googleusercontent.com',
    iosBundleId: 'com.example.pushApp',
  );
}

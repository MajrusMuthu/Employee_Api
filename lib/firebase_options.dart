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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCE877PxZJ7BFqfZXw8OgQTrQIzfYWrsCg',
    appId: '1:537045896708:web:b5feb39af2b2942bd36f51',
    messagingSenderId: '537045896708',
    projectId: 'employeeapp-31972',
    authDomain: 'employeeapp-31972.firebaseapp.com',
    storageBucket: 'employeeapp-31972.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCs7auENMKAiSXVCBhcUto_NSxiNckdaS8',
    appId: '1:537045896708:android:f52ed01b446f3fe2d36f51',
    messagingSenderId: '537045896708',
    projectId: 'employeeapp-31972',
    storageBucket: 'employeeapp-31972.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRpylgyx7a4slK0uKnxWthIJghcRZLtCM',
    appId: '1:537045896708:ios:6b970d6ffae196a2d36f51',
    messagingSenderId: '537045896708',
    projectId: 'employeeapp-31972',
    storageBucket: 'employeeapp-31972.appspot.com',
    iosBundleId: 'com.example.employeeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRpylgyx7a4slK0uKnxWthIJghcRZLtCM',
    appId: '1:537045896708:ios:c9ce42f8e3ccc5afd36f51',
    messagingSenderId: '537045896708',
    projectId: 'employeeapp-31972',
    storageBucket: 'employeeapp-31972.appspot.com',
    iosBundleId: 'com.example.employeeApp.RunnerTests',
  );
}
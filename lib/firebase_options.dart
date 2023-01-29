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
    apiKey: 'AIzaSyCb6Bqh7ypzCJiIGjdmZMJ8XOgQbfPn6DQ',
    appId: '1:365012797790:web:8de0ed9def241fe8a667cf',
    messagingSenderId: '365012797790',
    projectId: 'ligaportugal-16dad',
    authDomain: 'ligaportugal-16dad.firebaseapp.com',
    storageBucket: 'ligaportugal-16dad.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBn2tAhFw1lokVYC1MjGMp0XSO9g_5IXn8',
    appId: '1:365012797790:android:51f553fc0906ed3ca667cf',
    messagingSenderId: '365012797790',
    projectId: 'ligaportugal-16dad',
    storageBucket: 'ligaportugal-16dad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBT3k-o0axPQswOT4IaE7CtuV7AzvMSocg',
    appId: '1:365012797790:ios:7ef0a98fef4e48ada667cf',
    messagingSenderId: '365012797790',
    projectId: 'ligaportugal-16dad',
    storageBucket: 'ligaportugal-16dad.appspot.com',
    iosClientId: '365012797790-ru05mblspi72s170c1nk2fvte494rjd1.apps.googleusercontent.com',
    iosBundleId: 'com.pedroruben.ligaportugal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBT3k-o0axPQswOT4IaE7CtuV7AzvMSocg',
    appId: '1:365012797790:ios:7ef0a98fef4e48ada667cf',
    messagingSenderId: '365012797790',
    projectId: 'ligaportugal-16dad',
    storageBucket: 'ligaportugal-16dad.appspot.com',
    iosClientId: '365012797790-ru05mblspi72s170c1nk2fvte494rjd1.apps.googleusercontent.com',
    iosBundleId: 'com.pedroruben.ligaportugal',
  );
}

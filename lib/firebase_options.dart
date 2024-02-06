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
    apiKey: 'AIzaSyCOWGsETiT2B2Z-k1hK_syl-sjtqXoWODQ',
    appId: '1:683810352443:web:af84ed344fb900f4f8db1e',
    messagingSenderId: '683810352443',
    projectId: 'curfind',
    authDomain: 'curfind.firebaseapp.com',
    storageBucket: 'curfind.appspot.com',
    measurementId: 'G-FGQ2W6K9G3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_bpQOYD6ePJ61Zf00ZJIpBDQ1GmYk-d4',
    appId: '1:683810352443:android:0bdd78dafcc852f3f8db1e',
    messagingSenderId: '683810352443',
    projectId: 'curfind',
    storageBucket: 'curfind.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjdJrneLN6UpSpDUyNFLC9rGCtwbj5Pms',
    appId: '1:683810352443:ios:ecfae93778427127f8db1e',
    messagingSenderId: '683810352443',
    projectId: 'curfind',
    storageBucket: 'curfind.appspot.com',
    iosClientId: '683810352443-nmvobahg573jd4imncqv0vhfcl3da2kq.apps.googleusercontent.com',
    iosBundleId: 'com.example.curfind',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjdJrneLN6UpSpDUyNFLC9rGCtwbj5Pms',
    appId: '1:683810352443:ios:73cd119db0264236f8db1e',
    messagingSenderId: '683810352443',
    projectId: 'curfind',
    storageBucket: 'curfind.appspot.com',
    iosClientId: '683810352443-mhqva2gk29mrqlti623nv161vvf40obp.apps.googleusercontent.com',
    iosBundleId: 'com.example.curfind.RunnerTests',
  );
}

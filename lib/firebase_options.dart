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
    apiKey: 'AIzaSyC6E5VX2xgUpH_oleJfOnUwYXKWUR_Vuo8',
    appId: '1:70719600871:web:8e0de0dcebf7e00c5fca42',
    messagingSenderId: '70719600871',
    projectId: 'sporty-4aff4',
    authDomain: 'sporty-4aff4.firebaseapp.com',
    storageBucket: 'sporty-4aff4.firebasestorage.app',
    measurementId: 'G-2GF9T24EEE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB0BPFnpZGwBuOIOSqrsbyAh7Lb9yBBfJo',
    appId: '1:70719600871:android:af0ab8f2145516525fca42',
    messagingSenderId: '70719600871',
    projectId: 'sporty-4aff4',
    storageBucket: 'sporty-4aff4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTRv4DIi-orIIWuRrrpghxCLjO8yAgtuU',
    appId: '1:70719600871:ios:be052552533308575fca42',
    messagingSenderId: '70719600871',
    projectId: 'sporty-4aff4',
    storageBucket: 'sporty-4aff4.firebasestorage.app',
    iosBundleId: 'com.example.sporty',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTRv4DIi-orIIWuRrrpghxCLjO8yAgtuU',
    appId: '1:70719600871:ios:be052552533308575fca42',
    messagingSenderId: '70719600871',
    projectId: 'sporty-4aff4',
    storageBucket: 'sporty-4aff4.firebasestorage.app',
    iosBundleId: 'com.example.sporty',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6E5VX2xgUpH_oleJfOnUwYXKWUR_Vuo8',
    appId: '1:70719600871:web:bb98f7e146fc0b265fca42',
    messagingSenderId: '70719600871',
    projectId: 'sporty-4aff4',
    authDomain: 'sporty-4aff4.firebaseapp.com',
    storageBucket: 'sporty-4aff4.firebasestorage.app',
    measurementId: 'G-P3MG4NS6JS',
  );

}
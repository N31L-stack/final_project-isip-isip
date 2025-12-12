// File: lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform; // <--- ADDED kIsWeb HERE

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) { // <--- CHECK FOR WEB FIRST USING kIsWeb
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for iOS.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for macOS.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for Windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for Linux.',
        );
      // The default case will now only be reached if it's not web and not one of the explicitly handled TargetPlatform values
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    // *** IMPORTANT: FILL THESE IN WITH YOUR REAL ANDROID VALUES ***
    apiKey: 'YOUR_ANDROID_API_KEY_FROM_FIREBASE_CONSOLE',
    appId: 'YOUR_ANDROID_APP_ID_FROM_FIREBASE_CONSOLE',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID_FROM_FIREBASE_CONSOLE',
    projectId: 'isip-isip-c0e40',
    databaseURL: 'https://isip-isip-c0e40-default-rtdb.firebaseio.com',
    storageBucket: 'isip-isip-c0e40.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDHGj0deXKvbgihBNA1F49J3j8uQSjOJ2A",
    authDomain: "isip-isip-c0e40.firebaseapp.com",
    databaseURL: "https://isip-isip-c0e40-default-rtdb.firebaseio.com",
    projectId: "isip-isip-c0e40",
    storageBucket: "isip-isip-c0e40.firebasestorage.app",
    messagingSenderId: "578317813548",
    appId: "1:578317813548:web:93449c4c5e8ea9892e4e89",
    measurementId: "G-5FQJ7F2WVF",
  );
}

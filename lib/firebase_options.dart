// File generated manually from the values in frontend/.env (Firebase
// project: openwisdom1-70fb5). Only a *web* app was registered in that
// Firebase project, so the android/ios blocks below reuse the web app's
// apiKey/appId as a starting point — they will work for email/password
// auth but Google Sign-In on native platforms typically needs a real
// platform-specific OAuth client. For a fully correct native setup, run:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=openwisdom1-70fb5
//
// which will register Android/iOS apps in the Firebase console and
// regenerate this file (and drop in google-services.json /
// GoogleService-Info.plist) automatically. See README.md.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      default:
        return web;
    }
  }

  static const web = FirebaseOptions(
    apiKey: 'AIzaSyDhf8uW1ZEV4r5bmq1mkrceEvBbczf3pAg',
    appId: '1:668435507016:web:c32005cd951eeacda2357d',
    messagingSenderId: '668435507016',
    projectId: 'openwisdom1-70fb5',
    authDomain: 'openwisdom1-70fb5.firebaseapp.com',
    storageBucket: 'openwisdom1-70fb5.firebasestorage.app',
    measurementId: 'G-0FHTTQ8SGE',
  );

  // NOTE: same appId as web — replace via `flutterfire configure` for a
  // real Android app registration (needed for Google Sign-In to work
  // reliably, and to attach the correct SHA-1 fingerprint).
  static const android = FirebaseOptions(
    apiKey: 'AIzaSyDhf8uW1ZEV4r5bmq1mkrceEvBbczf3pAg',
    appId: '1:668435507016:web:c32005cd951eeacda2357d',
    messagingSenderId: '668435507016',
    projectId: 'openwisdom1-70fb5',
    storageBucket: 'openwisdom1-70fb5.firebasestorage.app',
  );

  // NOTE: same caveat as android — replace via `flutterfire configure`.
  static const ios = FirebaseOptions(
    apiKey: 'AIzaSyDhf8uW1ZEV4r5bmq1mkrceEvBbczf3pAg',
    appId: '1:668435507016:web:c32005cd951eeacda2357d',
    messagingSenderId: '668435507016',
    projectId: 'openwisdom1-70fb5',
    storageBucket: 'openwisdom1-70fb5.firebasestorage.app',
    iosBundleId: 'com.yumtreat.app',
  );
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

///Get the Current PlatFrom and initialize Firebase
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
      default:
        throw UnsupportedError('Current platform is not supported.');
    }
  }

  ///Firebase Option For the Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwZOx0RuCv4h6Ueg3X3W9BXdLJT990eLY',
    appId: '1:757239413803:android:5988d0e1a01733f8387e6e',
    messagingSenderId: '757239413803',
    projectId: 'fingerprint-bba55',
  );

  ///Firebase Option For the IOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwZOx0RuCv4h6Ueg3X3W9BXdLJT990eLY',
    appId: '1:757239413803:android:5988d0e1a01733f8387e6e',
    messagingSenderId: '757239413803',
    projectId: 'fingerprint-bba55',
  );

  ///Firebase Option For the Web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwZOx0RuCv4h6Ueg3X3W9BXdLJT990eLY',
    appId: '1:757239413803:android:5988d0e1a01733f8387e6e',
    messagingSenderId: '757239413803',
    projectId: 'fingerprint-bba55',
  );
}

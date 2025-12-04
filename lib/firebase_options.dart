// ignore_for_file: constant_identifier_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDVzqXnt-PZAfD5lmVR1AZ9DcQKFVd5JDw',
    appId: '1:887389400100:web:50b1ba62da234b4eadfcb1',
    messagingSenderId: '887389400100',
    projectId: 'cash-flow-x',
    authDomain: 'cash-flow-x.firebaseapp.com',
    storageBucket: 'cash-flow-x.firebasestorage.app',
    databaseURL: 'https://cash-flow-x-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVzqXnt-PZAfD5lmVR1AZ9DcQKFVd5JDw',
    appId: '1:887389400100:android:50b1ba62da234b4eadfcb1',
    messagingSenderId: '887389400100',
    projectId: 'cash-flow-x',
    storageBucket: 'cash-flow-x.firebasestorage.app',
    databaseURL: 'https://cash-flow-x-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVzqXnt-PZAfD5lmVR1AZ9DcQKFVd5JDw',
    appId: '1:887389400100:ios:50b1ba62da234b4eadfcb1',
    messagingSenderId: '887389400100',
    projectId: 'cash-flow-x',
    storageBucket: 'cash-flow-x.firebasestorage.app',
    iosBundleId: 'com.abrar.cashflowx',
    databaseURL: 'https://cash-flow-x-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDVzqXnt-PZAfD5lmVR1AZ9DcQKFVd5JDw',
    appId: '1:887389400100:ios:50b1ba62da234b4eadfcb1',
    messagingSenderId: '887389400100',
    projectId: 'cash-flow-x',
    storageBucket: 'cash-flow-x.firebasestorage.app',
    iosBundleId: 'com.abrar.cashflowx.desktop',
    databaseURL: 'https://cash-flow-x-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVzqXnt-PZAfD5lmVR1AZ9DcQKFVd5JDw',
    appId: '1:887389400100:web:50b1ba62da234b4eadfcb1',
    messagingSenderId: '887389400100',
    projectId: 'cash-flow-x',
    storageBucket: 'cash-flow-x.firebasestorage.app',
    databaseURL: 'https://cash-flow-x-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDVzqXnt-PZAfD5lmVR1AZ9DcQKFVd5JDw',
    appId: '1:887389400100:web:50b1ba62da234b4eadfcb1',
    messagingSenderId: '887389400100',
    projectId: 'cash-flow-x',
    storageBucket: 'cash-flow-x.firebasestorage.app',
    databaseURL: 'https://cash-flow-x-default-rtdb.firebaseio.com',
  );
}

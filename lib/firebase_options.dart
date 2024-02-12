import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }else
      {
        return android;
      }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyDgG-bDm_DwXEgSqgA9vtsuz7IJxqK3bqU",
    authDomain: "lab3-201139.firebaseapp.com",
    projectId: "lab3-201139",
    storageBucket: "lab3-201139.appspot.com",
    messagingSenderId: "372784989721",
    appId: "1:372784989721:web:b0a8c71d01c82b8ef4cc88",
    measurementId: "G-87JPVC7KWY"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCBj7F1zS-peOgSdaLPqT3w_iVpwCEHTLA",
    projectId: "lab3-201139",
    storageBucket: "lab3-201139.appspot.com",
    messagingSenderId: "372784989721",
    appId: "1:372784989721:android:a91904946bca2a13f4cc88",
  );
}

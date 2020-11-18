import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/login.dart';
import 'package:music_app/screens/music.dart';
import 'package:music_app/screens/oauth.dart';
import 'package:music_app/screens/player.dart';
import 'package:music_app/screens/splash.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  // runApp(DevicePreview(
  //   builder: (context) => SplashScreen(),
  // ));
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

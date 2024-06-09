import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tbd/home.dart';
import 'package:tbd/login.dart';
import 'package:tbd/phone.dart';
import 'package:tbd/register.dart';
import 'package:tbd/tb_detection.dart';

import 'otp.dart';
import 'urbansound.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "emailsignin",
    options: FirebaseOptions(
      //apiKey: "AIzaSyD1C8QaEAxv9QJIm2DDF9N3_b3UZv5o",
      //appId: "1:270790104828:web:1da6b11a4729a7d79729",
      //messagingSenderId: "2707901048",
      //projectId: "todo-app-firebase-ce8",
      apiKey: "AIzaSyC3zDHBhFlBmx8z0kgMlXSmu_qHFU_al0Y",
      appId: "1:465000710339:android:6b7f2903e7e4a991ebe276",
      projectId: "myapp-emailsignin",
      messagingSenderId: "465000710339",
    ),
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'tb-dection',
    routes: {
      'login': (context) => Mylogin(),
      'register': (context) => MyRegister(),
      'home': (context) => MyApp(),
      'phone': (context) => MyPhone(),
      'otp': (context) => MyOtp(),
      "tb-dection": (context) => tb_detection(),
      'urbansound': (context) => urbansound(),
    },
  ));
}

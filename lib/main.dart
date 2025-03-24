import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'SplashScreen/Splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB8xIcEY2kcR2Dtj7Lgf5nyYVCf7IwFjfU",
        appId: "1:491794031269:android:98900d71f19354c8ea634c",
        messagingSenderId: "",
        projectId: "influencehub-7b9ab",
        storageBucket: "influencehub-7b9ab.firebasestorage.app",
      ),
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

    ),
  );
}


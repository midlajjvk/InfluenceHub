import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencehub/SignIn.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogPage();
  }

  void _navigateToLogPage() async {
    await Future.delayed(Duration(seconds: 3));

    if (!mounted) return; // Prevent navigation if widget is disposed

   Get.off(()=> LogPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          'assets/animations/Animation - 1740372053149.json',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

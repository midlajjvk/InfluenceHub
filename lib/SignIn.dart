import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SignUpSelection.dart';
import 'brand/Home/BrandHome.dart';
import 'influencer/Home/HomeInfluencer.dart';
import 'influencer/SignUp/SignUpInfluencer.dart';

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
      home: LogPage(),

    ),
  );
}

class LogPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Step 1: Check if user exists in "users" collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // Normal user found
          String name = userDoc.get('fullName') ?? "Unknown";
          Get.off(() => HomeUser(name: name, userId: user.uid));
          return;
        }

        // Step 2: Check if user exists in "brands" collection
        DocumentSnapshot brandDoc = await FirebaseFirestore.instance
            .collection('brands')
            .doc(user.uid)
            .get();

        if (brandDoc.exists) {
          // Brand user found
          String brandName = brandDoc.get('brandName') ?? "brands";
          Get.off(() => BrandHomePage(brandId: user.uid, name: brandName));
          return;
        }

        // Step 3: If neither found, show error
        throw Exception("User data not found in Firestore.");
      } else {
        throw Exception("User not found in Firebase Authentication.");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Login failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(


        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(style: TextStyle(color: Colors.white),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),

                      prefixIcon: Icon(Icons.email,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your email";
                      }
                      if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                      prefixIcon: Icon(Icons.lock,color: Colors.white,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        _signIn(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please check your email and password",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: Text(
                      "Login",style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Get.to(SelectionPage());
                    },
                    child: Text(
                      "Not a user? Create an account!",style: TextStyle(color: Colors.white),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

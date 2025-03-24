import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'DetailsPage.dart';
import '../../SignIn.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: InfluencerSignUp(),
    );
  }
}

class InfluencerSignUpController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign up logic with Firebase Authentication only
  Future<void> signUp(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validate fields
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // Validate email format
    if (!EmailValidator.validate(email)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    }

    // Validate password length
    if (password.length < 6) {
      Get.snackbar("Error", "Password should be at least 6 characters");
      return;
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


      String userId = userCredential.user?.uid ?? '';

      if (userId.isEmpty) {
        Get.snackbar("Error", "Failed to retrieve user ID");
        return;
      }

      // Navigate to the DetailsPage, passing the userId
      Get.off(() => DetailsPage(userId: userId));

      // Clear the form fields
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      Get.snackbar("Error", "Error: ${e.toString()}");
    }
  }
}

class InfluencerSignUp extends StatelessWidget {
  final InfluencerSignUpController controller = Get.put(InfluencerSignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/iinfluencer.jpg"),fit: BoxFit.cover  )

        ),
        child: Center(
          child: SingleChildScrollView(

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // Center all content
                children: [
                  // Center the text widget
                  Center(
                    child: Text(
                      'Create Your Influencer Account',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller.passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Center the SignUp button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[100]),
                      onPressed: () => controller.signUp(context),
                      child: Text('Sign Up'),
                    ),
                  ),
                  // Center the "Already have an account?" text button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => LogPage());
                      },
                      child: Text("Already have an account? Sign In"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:influencehub/brand/SignUpBrand/SignupDetails.dart';

class SaveDataPage extends StatefulWidget {
  @override
  _SaveDataPageState createState() => _SaveDataPageState();
}

class _SaveDataPageState extends State<SaveDataPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> imageList = [
    'assets/images/puma.png',
    'assets/images/nike.png',
    'assets/images/adidas.png',
  ];

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? userId = userCredential.user?.uid;
        if (userId == null) {
          print('User ID is null. Registration failed.');
          return;
        }

        await FirebaseFirestore.instance
            .collection('brand_signup_details')
            .doc(userId)
            .set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('Brand registered successfully: $userId');
        print('Navigating to details page...');

        Get.off(() => SignupDetails(brandId: userId));
      } catch (e) {
        print('Error during registration: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              scrollDirection: Axis.vertical,
              height: double.infinity,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 300),
              autoPlayCurve: Curves.ease,
            ),
            items: imageList.map((image) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Email',
                          labelStyle: TextStyle(color: Colors.white)),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.white),
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Password',
                          labelStyle: TextStyle(color: Colors.white)),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveData,
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



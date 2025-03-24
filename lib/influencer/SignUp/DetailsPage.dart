// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../Home/HomeInfluencer.dart';
//
// class DetailsPage extends StatefulWidget {
//   final String userId;
//
//   DetailsPage({required this.userId});
//
//   @override
//   _DetailsPageState createState() => _DetailsPageState();
// }
//
// class _DetailsPageState extends State<DetailsPage> {
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController whatsappController = TextEditingController();
//   final TextEditingController instagramController =
//   TextEditingController();
//
//   String selectedGender = 'Male';
//   String? selectedCategory; // Initially null for "Select" hint.
//
//   List<String> categories = ['Fashion', 'Food', 'Tech', 'Cosmetics'];
//   List<String> genders = ['Male', 'Female', 'Other'];
//
//   // Validation Method
//   bool validateInputs() {
//     if (fullNameController.text.trim().isEmpty ||
//         ageController.text.trim().isEmpty ||
//         pincodeController.text.trim().isEmpty ||
//         locationController.text.trim().isEmpty ||
//         whatsappController.text.trim().isEmpty ||
//         instagramController.text.trim().isEmpty ||
//         selectedCategory == null) {
//       Get.snackbar("Error", "Please fill in all fields.");
//       return false;
//     }
//
//     int? age = int.tryParse(ageController.text.trim());
//     if (age == null || age < 10 || age > 60) {
//       Get.snackbar("Error", "Age must be a number between 10 and 60.");
//       return false;
//     }
//
//     if (!RegExp(r'^\d{6}$').hasMatch(pincodeController.text.trim())) {
//       Get.snackbar("Error", "Enter a valid pincode.");
//       return false;
//     }
//
//     if (!RegExp(r'^\d{10}$').hasMatch(whatsappController.text.trim())) {
//       Get.snackbar("Error", "Invalid number.");
//       return false;
//     }
//
//     return true;
//   }
//
//   Future<void> saveUserDetails() async {
//     if (!validateInputs()) return;
//
//     String fullName = fullNameController.text.trim();
//     String age = ageController.text.trim();
//     String pincode = pincodeController.text.trim();
//     String location = locationController.text.trim();
//     String whatsapp = whatsappController.text.trim();
//     String instagram = instagramController.text.trim();
//
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//
//       if (user == null) {
//         Get.snackbar("Error", "User not authenticated");
//         return;
//       }
//
//       String userId = user.uid;
//       String email = user.email ?? "No Email"; // Fetch email from FirebaseAuth
//
//       await FirebaseFirestore.instance.collection('users').doc(userId).set({
//         'userId': userId,
//         'email': email, // Store email in Firestore
//         'fullName': fullName,
//         'age': age,
//         'gender': selectedGender,
//         'pincode': pincode,
//         'location': location,
//         'whatsapp': whatsapp,
//         'category': selectedCategory,
//         'instagram': instagram,
//       });
//
//       Get.snackbar("Success", "Details saved successfully!", colorText: Colors.white);
//
//       Get.off(() => HomeUser(name: fullName, userId: userId)); // Pass the name
//     } catch (e) {
//       Get.snackbar("Error", "Error: $e", colorText: Colors.white);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           decoration: BoxDecoration(
//            image: DecorationImage(image: AssetImage("assets/images/iinfluencer.jpg"),fit: BoxFit.cover,)
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(top: 70.0, left: 30, right: 30),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Title
//                   Text(
//                     'Enter Your Details Here',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 30),
//
//                   // Full Name Field
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Full Name:', style: TextStyle(fontSize: 16)),
//                   ),
//                   TextField(
//                     controller: fullNameController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter your full name',
//                     ),
//                   ),
//                   SizedBox(height: 16),
//
//                   // Age Field
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Age:', style: TextStyle(fontSize: 16)),
//                   ),
//                   TextField(
//                     controller: ageController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter your age',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   SizedBox(height: 16),
//
//                   // Gender Selection (Radio Buttons)
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Gender:', style: TextStyle(fontSize: 16)),
//                   ),
//                   Row(
//                     children: genders.map((gender) {
//                       return Row(
//                         children: [
//                           Radio<String>(
//                             value: gender,
//                             groupValue: selectedGender,
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedGender = value!;
//                               });
//                             },
//                           ),
//                           Text(gender),
//                         ],
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 16),
//
//                   // Pincode Field
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Pincode:', style: TextStyle(fontSize: 16)),
//                   ),
//                   TextField(
//                     controller: pincodeController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter your pincode',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   SizedBox(height: 16),
//
//                   // Location Field
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Location:', style: TextStyle(fontSize: 16)),
//                   ),
//                   TextField(
//                     controller: locationController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter your location',
//                     ),
//                   ),
//                   SizedBox(height: 16),
//
//                   // WhatsApp Number Field
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('WhatsApp Number:', style: TextStyle(fontSize: 16)),
//                   ),
//                   TextField(
//                     controller: whatsappController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter your WhatsApp number',
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   SizedBox(height: 16),
//
//                   // Instagram URL Field
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Instagram URL:', style: TextStyle(fontSize: 16)),
//                   ),
//                   TextField(
//                     controller: instagramController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter your Instagram URL',
//                     ),
//                     keyboardType: TextInputType.url,
//                   ),
//                   SizedBox(height: 16),
//
//                   // Category Selection
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text('Category:', style: TextStyle(fontSize: 16)),
//                   ),
//                   DropdownButton<String>(
//                     hint: Text('Select'), // Hint text for dropdown
//                     value: selectedCategory,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedCategory = newValue!;
//                       });
//                     },
//                     items: categories
//                         .map<DropdownMenuItem<String>>((String category) {
//                       return DropdownMenuItem<String>(
//                         value: category,
//                         child: Text(category),
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 20),
//
//                   // Save Button
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: saveUserDetails,
//                       child: Text("Save Details"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Home/HomeInfluencer.dart';

class DetailsPage extends StatefulWidget {
  final String userId;

  DetailsPage({required this.userId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  String selectedGender = 'Male';
  String? selectedCategory; // Initially null for "Select" hint.

  List<String> categories = ['Fashion', 'Food', 'Tech', 'Cosmetics'];
  List<String> genders = ['Male', 'Female', 'Other'];

  // Validation Method
  bool validateInputs() {
    if (fullNameController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        whatsappController.text.trim().isEmpty ||
        instagramController.text.trim().isEmpty ||
        selectedCategory == null) {
      Get.snackbar("Error", "Please fill in all fields.");
      return false;
    }

    int? age = int.tryParse(ageController.text.trim());
    if (age == null || age < 10 || age > 60) {
      Get.snackbar("Error", "Age must be a number between 10 and 60.");
      return false;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(pincodeController.text.trim())) {
      Get.snackbar("Error", "Enter a valid pincode.");
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(whatsappController.text.trim())) {
      Get.snackbar("Error", "Invalid WhatsApp number.");
      return false;
    }

    // Validate Instagram URL
    if (!RegExp(r'^(https?:\/\/)?(www\.)?instagram\.com\/[A-Za-z0-9_.]+\/?$')
        .hasMatch(instagramController.text.trim())) {
      Get.snackbar("Error", "Enter a valid Instagram profile link.");
      return false;
    }

    return true;
  }

  Future<void> saveUserDetails() async {
    if (!validateInputs()) return;

    String fullName = fullNameController.text.trim();
    String age = ageController.text.trim();
    String pincode = pincodeController.text.trim();
    String location = locationController.text.trim();
    String whatsapp = whatsappController.text.trim();
    String instagram = instagramController.text.trim();

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.snackbar("Error", "User not authenticated");
        return;
      }

      String userId = user.uid;
      String email = user.email ?? "No Email"; // Fetch email from FirebaseAuth

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'userId': userId,
        'email': email, // Store email in Firestore
        'fullName': fullName,
        'age': age,
        'gender': selectedGender,
        'pincode': pincode,
        'location': location,
        'whatsapp': whatsapp,
        'category': selectedCategory,
        'instagram': instagram,
        'userType': 'Influencer'
      });

      Get.snackbar("Success", "Details saved successfully!", colorText: Colors.white);
      Get.off(() => HomeUser(name: fullName, userId: userId)); // Pass the name
    } catch (e) {
      Get.snackbar("Error", "Error: $e", colorText: Colors.white);
    }
  }

  // Open Instagram in Browser/App
  void openInstagram(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open Instagram link.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/iinfluencer.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Enter Your Details Here',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                buildTextField('Full Name:', fullNameController),
                buildTextField('Age:', ageController, isNumeric: true),

                // Gender Selection
                buildGenderSelection(),

                buildTextField('Pincode:', pincodeController, isNumeric: true),
                buildTextField('Location:', locationController),
                buildTextField('WhatsApp Number:', whatsappController, isNumeric: true),

                // Instagram Field with Link Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Instagram URL:', style: TextStyle(fontSize: 16)),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: instagramController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter your Instagram URL',
                        ),
                        keyboardType: TextInputType.url,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.link, color: Colors.blue),
                      onPressed: () {
                        if (instagramController.text.isNotEmpty) {
                          openInstagram(instagramController.text.trim());
                        } else {
                          Get.snackbar("Error", "No Instagram URL provided.");
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Category Selection
                buildDropdownField('Category:', categories, selectedCategory, (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                }),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: saveUserDetails,
                  child: Text("Save Details"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for TextFields
  Widget buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text(label, style: TextStyle(fontSize: 16))),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter your $label'.toLowerCase(),
          ),
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  // Helper method for Dropdown
  Widget buildDropdownField(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text(label, style: TextStyle(fontSize: 16))),
        DropdownButton<String>(
          hint: Text('Select'),
          value: selectedValue,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
        ),
      ],
    );
  }

  // Helper method for Gender Selection
  Widget buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: Text('Gender:', style: TextStyle(fontSize: 16))),
        Row(
          children: genders.map((gender) {
            return Row(
              children: [
                Radio<String>(
                  value: gender,
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                Text(gender),
              ],
            );
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

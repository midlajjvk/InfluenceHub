import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:influencehub/brand/SignUpBrand/SignupDetails.dart';

import '../../SignIn.dart';

Widget SettingsPagebrand(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              'Account Handle',
              style: TextStyle(color: Colors.black),
            ),
            leading: Icon(Icons.account_circle, color: Colors.black),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete Account'),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Account Deletion'),
                                content: Text(
                                    'Are you sure you want to delete your account? This action cannot be undone.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.pop(context); // Close dialog
                                      try {
                                        User? currentUser =
                                            FirebaseAuth.instance.currentUser;

                                        if (currentUser != null) {
                                          String userId = currentUser.uid;

                                          // Delete Firestore data from both collections
                                          await FirebaseFirestore.instance
                                              .collection('brands')
                                              .doc(userId)
                                              .delete();
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  'brand_signup_details')
                                              .doc(userId)
                                              .delete();

                                          // Reauthenticate if required
                                          try {
                                            await currentUser.delete();
                                          } on FirebaseAuthException catch (e) {
                                            if (e.code ==
                                                'requires-recent-login') {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LogPage()),
                                                (route) => false,
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Please log in again to delete your account.'),
                                                ),
                                              );
                                              return;
                                            }
                                          }

                                          // Sign out after deletion
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LogPage()),
                                            (route) => false,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Account deleted successfully.')),
                                          );
                                        } else {
                                          throw 'No user is currently signed in.';
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text('Error: $e')),
                                        );
                                      }
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogPage()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logged out successfully.')),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Divider(),
        Container(
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              'Report a Problem',
              style: TextStyle(color: Colors.black),
            ),
            leading: Icon(Icons.report_problem, color: Colors.black),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  TextEditingController _problemController =
                      TextEditingController();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe the problem:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _problemController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your problem here...',
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                String problem = _problemController.text.trim();
                                if (problem.isNotEmpty) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Problem submitted successfully.')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please describe the problem.')),
                                  );
                                }
                              },
                              child: Text('Submit'),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close modal
                              },
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Divider(),
        Container(
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(leading: Icon(Icons.add_circle_outline,color: Colors.black,),
              title: Text(
                'Add New Product',
                style: TextStyle(color: Colors.black),
              ),onTap:(){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignupDetails(brandId: "brandId")));
              },
            ))
      ],
    ),
  );
}

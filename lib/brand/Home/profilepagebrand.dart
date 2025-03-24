import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'editprofile.dart';

class BrandProfilePage extends StatefulWidget {
  @override
  _BrandProfilePageState createState() => _BrandProfilePageState();
}

class _BrandProfilePageState extends State<BrandProfilePage> {
  Future<Map<String, dynamic>?> fetchBrandDetails() async {
    String brandId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('brands')
          .doc(brandId)
          .get();

      if (doc.exists) {
        return doc.data(); // Return the document data as a Map
      } else {
        return null; // Return null if the document does not exist
      }
    } catch (e) {
      print("Error fetching brand details: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchBrandDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No brand details found.'));
          }

          // Extract brand data
          Map<String, dynamic> brandData = snapshot.data!;
          String brandName = brandData['brandName'] ?? 'Unknown';
          String website = brandData['website'] ?? 'No website';
          int? yearStarted = brandData['yearStarted'];
          String category = brandData['category'] ?? 'Not specified';
          String extraDetails =
              brandData['extraDetails'] ?? 'No details provided';

          return Padding(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "$brandName",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          buildDetailRow('Website', brandData['website']),
                          buildDetailRow('Since', brandData['yearStarted']),
                          buildDetailRow('Category', brandData['category']),
                          buildDetailRow(
                              'Extra Details', brandData['extraDetails']),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBrandProfilePage(
                                      brandId: FirebaseAuth.instance.currentUser!.uid,
                                      userId: FirebaseAuth.instance.currentUser!.uid, // If needed
                                    ),
                                  ),
                                );

                              },
                              child: Text('Edit Profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget buildDetailRow(String label, dynamic value) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$label ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text('$value', style: TextStyle(fontSize: 18)),
          ],
        ),
        Divider(color: Colors.black, height: 25),
      ],
    );
  }
}

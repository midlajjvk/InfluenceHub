import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../chat/chat.dart';

class BrandDetailCardPage extends StatelessWidget {
  final String brandId;
  final String brandName;
  final String category;
  final int yearStarted;
  final String productName;
  final String userId;

  BrandDetailCardPage({
    required this.brandId,
    required this.brandName,
    required this.category,
    required this.yearStarted,
    required this.productName,
    required this.userId,
  });
  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }

  Future<void> sendCollabRequest() async {
    String influencerId = FirebaseAuth.instance.currentUser!.uid;

    try {
      var existingRequest = await FirebaseFirestore.instance
          .collection('collabRequests')
          .where('brandId', isEqualTo: brandId)
          .where('influencerId', isEqualTo: influencerId)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        Get.snackbar("Info", "Collab request already sent!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
        return;
      }

      await FirebaseFirestore.instance.collection('collabRequests').add({
        'brandId': brandId,
        'brandName': brandName,
        'influencerId': influencerId,
        'productName': productName,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Collab request sent successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (error) {
      Get.snackbar("Error", "Failed to send collab request!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Brand Details",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Container(
          width: 300,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.purple[100],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                brandName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Product: $productName"),
              SizedBox(height: 10),
              Text("Category: $category"),
              SizedBox(height: 10),
              Text("Year Started: $yearStarted"),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => ChatScreen(
                        influencerId: getCurrentUserId(),
                        brandId: brandId,
                        brandName: brandName,
                      ));
                },
                child: Text("Chat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: sendCollabRequest,
                child: Text("Request Collab"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[300],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

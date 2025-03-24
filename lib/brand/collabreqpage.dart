import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollabRequestPage extends StatelessWidget {
  final String brandId;

  CollabRequestPage({required this.brandId});

  /// ✅ Function to send a notification when a collab request is accepted
  Future<void> acceptCollabRequest(String influencerId, String brandId) async {
    try {
      print("🔍 Fetching brand details for brandId: $brandId");

      // ✅ Fetch brand details from Firestore
      DocumentSnapshot brandSnapshot = await FirebaseFirestore.instance
          .collection('brands')
          .doc(brandId)
          .get();

      if (!brandSnapshot.exists) {
        print("❌ Error: Brand not found in Firestore!");
        return;
      }

      String brandName = brandSnapshot['brandName'] ?? "Unknown Brand";
      print("✅ Brand found: $brandName");

      // ✅ Attempt to store notification in Firestore
      DocumentReference notificationRef = await FirebaseFirestore.instance.collection('notifications').add({
        'influencerId': influencerId,
        'brandId': brandId,
        'brandName': brandName,
        'message': "Collab request accepted by $brandName",
        'timestamp': FieldValue.serverTimestamp(),
        'seen': false,
      });

      print("✅ Notification successfully stored in Firestore! ID: ${notificationRef.id}");
    } catch (error) {
      print("❌ Error storing notification: $error");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collab Requests'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('collabRequests')
            .where('brandId', isEqualTo: brandId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Collab Requests Yet!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;

              String influencerId = request['influencerId'] ?? '';

              if (influencerId.isEmpty) {
                return SizedBox();
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(influencerId)
                    .get(),
                builder: (context, influencerSnapshot) {
                  if (influencerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return SizedBox();
                  }

                  if (!influencerSnapshot.hasData ||
                      !influencerSnapshot.data!.exists) {
                    return SizedBox();
                  }

                  var influencerData =
                      influencerSnapshot.data!.data() as Map<String, dynamic>;

                  return Card(
                    color: Colors.purple[100],
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: Text(
                        influencerData['fullName'] ?? "Unknown",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${influencerData['email'] ?? 'N/A'}"),
                          Text("Age: ${influencerData['age'] ?? 'N/A'}"),
                          Text("Gender: ${influencerData['gender'] ?? 'N/A'}"),
                          Text(
                              "Location: ${influencerData['location'] ?? 'N/A'}"),
                          Text(
                              "WhatsApp: ${influencerData['whatsapp'] ?? 'N/A'}"),
                          Text.rich(
                            TextSpan(
                              text: "Instagram: ",
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: influencerData['instagram'] ?? 'N/A',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await acceptCollabRequest(influencerId, brandId);

                          // ✅ Update collab request status
                          FirebaseFirestore.instance
                              .collection('collabRequests')
                              .doc(requests[index].id)
                              .update({'status': 'accepted'});

                          Get.snackbar(
                            "Success",
                            "Collab request accepted!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

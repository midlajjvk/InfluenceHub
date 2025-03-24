import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editprofile.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userDetailsFuture;

  @override
  void initState() {
    super.initState();
    userDetailsFuture = fetchUserDetails(widget.userId);
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw 'User details not found';
      }
    } catch (e) {
      throw 'Error fetching user details: $e';
    }
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No user details found.'));
        } else {
          final userDetails = snapshot.data!;
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
                        buildDetailRow('Full Name', userDetails['fullName']),
                        buildDetailRow('Age', userDetails['age']),
                        buildDetailRow('Gender', userDetails['gender']),
                        buildDetailRow('Pincode', userDetails['pincode']),
                        buildDetailRow('Location', userDetails['location']),
                        buildDetailRow('WhatsApp', userDetails['whatsapp']),
                        buildDetailRow('Category', userDetails['category']),
                        buildDetailRow('Instagram', userDetails['instagram']),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfilePage(userId: widget.userId),
                                ),
                              );
                              setState(() {
                                userDetailsFuture = fetchUserDetails(widget.userId);
                              });
                            },
                            child: Text("Edit"),
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
      },
    );
  }
}

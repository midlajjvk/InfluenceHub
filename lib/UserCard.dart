import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'brand/Home/detailedcardinfluencer.dart';

class InfluencerList extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchInfluencers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('users').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchInfluencers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Error fetching influencers',
                  style: TextStyle(color: Colors.white)));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('No influencers found',
                  style: TextStyle(color: Colors.white)));
        }

        List<Map<String, dynamic>> influencers = snapshot.data!;

        return ListView.builder(
          itemCount: influencers.length,
          itemBuilder: (context, index) {
            var influencer = influencers[index];

            return UserCard(
              name: influencer['fullName'] ?? 'Unknown',
              category: influencer['category'] ?? 'Not specified',
              location: influencer['location'] ?? 'Unknown',
              instagram: influencer['instagram'] ?? '',
            );
          },
        );
      },
    );
  }
}

// ---------------------------------

class UserCard extends StatelessWidget {
  final String name;
  final String category;
  final String location;
  final String instagram;

  UserCard({
    required this.name,
    required this.category,
    required this.location,
    required this.instagram,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to InfluencerDetailPage with influencer details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfluencerDetailPage(
              name: name,
              category: category,
              location: location,
              instagram: instagram,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.purple[100],
        elevation: 2,
        shadowColor: Colors.white,
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          subtitle: Text(
            "$category | $location",
            style: TextStyle(color: Colors.black54),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.message, color: Colors.green),
                onPressed: () {}, // Placeholder for messaging
              ),
              IconButton(
                icon: Image.asset('assets/images/instagram (1).png',
                    width: 24, height: 24),
                onPressed: () {
                  // Open Instagram Profile Link (Implementation needed)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

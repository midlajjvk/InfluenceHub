import 'package:flutter/material.dart';

class InfluencerDetailPage extends StatelessWidget {
  final String name;
  final String category;
  final String location;
  final String instagram;

  InfluencerDetailPage({
    required this.name,
    required this.category,
    required this.location,
    required this.instagram,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: $category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Location: $location",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Instagram: ", style: TextStyle(fontSize: 16)),
                GestureDetector(
                  onTap: () {
                    // Open Instagram link (requires implementation)
                  },
                  child: Text(
                    instagram,
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to list
                },
                child: Text("Back"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

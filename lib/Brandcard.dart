import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'influencer/Home/detailedcard.dart';

class BrandList extends StatelessWidget {
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('brands').get();

    return snapshot.docs.map((doc) {
      var data = doc.data();
      return {
        'id': doc.id,
        'brandName': data['brandName'] ?? '',
        'category': data['category'] ?? '',
        'yearStarted': data['yearStarted'] ?? 0,
        'productName': data['productName'] ?? '',
        'userId': data['userId'] ?? '',
        'website': data['website'] ?? '',
        'extraDetails': data['extraDetails'] ?? '',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBrands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('No brands found', style: TextStyle(color: Colors.white)));
        }

        List<Map<String, dynamic>> brands = snapshot.data!;

        return ListView.builder(
          itemCount: brands.length,
          itemBuilder: (context, index) {
            var brandDoc = brands[index];

            return BrandCard(
              brandId: brandDoc['id'],
              brandName: brandDoc['brandName'],
              category: brandDoc['category'],
              yearStarted: brandDoc['yearStarted'],
              productName: brandDoc['productName'],
              userId: brandDoc['userId'],
              website: brandDoc['website'],
              extraDetails: brandDoc['extraDetails'],
            );
          },
        );
      },
    );
  }
}

class BrandCard extends StatelessWidget {
  final String brandId;
  final String brandName;
  final String category;
  final String website;
  final int yearStarted;
  final String extraDetails;
  final String productName;
  final String userId;

  BrandCard({
    required this.brandId,
    required this.brandName,
    required this.category,
    required this.website,
    required this.yearStarted,
    required this.extraDetails,
    required this.productName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.purple[100],
      elevation: 2,
      shadowColor: Colors.white,
      child: ListTile(
        title: Text(
          brandName,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
        ),
        subtitle: Text(
          "$category | $productName",
          style: TextStyle(color: Colors.black54),
        ),
        trailing: ElevatedButton.icon(
          onPressed: () {
            Get.to(() => BrandDetailCardPage(
              brandId: brandId,
              brandName: brandName,
              category: category,
              yearStarted: yearStarted,
              productName: productName,
              userId: userId,
            ));
          },
          label: Text("View\nMore", style: TextStyle(fontSize: 10)),
          icon: FaIcon(FontAwesomeIcons.arrowRight, size: 12),
          style: ElevatedButton.styleFrom(
              elevation: 0, backgroundColor: Colors.purple[200]),
        ),
      ),
    );
  }
}

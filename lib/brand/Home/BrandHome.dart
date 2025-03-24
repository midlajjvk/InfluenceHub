import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:influencehub/brand/collabreqpage.dart';
import '../../UserCard.dart';
import '../SignUpBrand/SignupDetails.dart';
import 'profilepagebrand.dart';
import 'settingsbrand.dart';
import 'drawer.dart';

class BrandHomePage extends StatefulWidget {
  final String name;
  final String brandId;

  BrandHomePage({required this.name, required this.brandId});

  @override
  _BrandHomePageState createState() => _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {
  int _selectedIndex = 0;

  Stream<int> getCollabRequestCount() {
    return FirebaseFirestore.instance
        .collection('collabRequests')
        .where('brandId', isEqualTo: widget.brandId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      InfluencerList(),
      SettingsPagebrand(context),
      BrandProfilePage()
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          StreamBuilder<int>(
            stream: getCollabRequestCount(),
            builder: (context, snapshot) {
              int count = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => CollabRequestPage(brandId: widget.brandId));
                    },
                    icon: Icon(Icons.notifications),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          count.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],

        title: Text('Influence Hub',
            style: GoogleFonts.kaushanScript(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,

      ),
      drawer:
          BrandDrawer(onItemSelected: _onItemTapped, userId: widget.brandId),
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignupDetails(brandId: widget.brandId)),
                );
              },
              label: Text('Add New Product',
                  style: TextStyle(
                      color: Colors.purple[100], fontWeight: FontWeight.bold)),
              backgroundColor: Colors.black,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:influencehub/SignIn.dart';

class BrandDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final String userId;

  BrandDrawer({required this.onItemSelected, required this.userId});

  Future<String> fetchBrandName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('brands')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return snapshot.data()?['brandName'] ?? 'brands';
      } else {
        return 'brands';
      }
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple[100],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[300],
            ),
            child: FutureBuilder<String>(
              future: fetchBrandName(),
              builder: (context, snapshot) {
                String brandName = 'Loading...';
                if (snapshot.connectionState == ConnectionState.done) {
                  brandName = snapshot.data ?? 'brands';
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey, $brandName',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              onItemSelected(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LogPage()));
            },
          ),
        ],
      ),
    );
  }
}

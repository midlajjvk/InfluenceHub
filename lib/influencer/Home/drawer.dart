
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../SignIn.dart';
import 'editprofile.dart';

class AppDrawer extends StatelessWidget {
  final String userId;
  final String userName; // New parameter
  final VoidCallback onLogout;
  final VoidCallback onShowSettings;

  AppDrawer({
    required this.userId,
    required this.userName, // Accept userName
    required this.onLogout,
    required this.onShowSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple[100],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(margin: EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
              color: Colors.purple[300],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey, $userName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Get.to(() => EditProfilePage(userId: userId));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              onShowSettings();
              Navigator.pop(context);
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:influencehub/Brandcard.dart';
import 'package:influencehub/influencer/Home/profilepageinfluencer.dart';
import '../../brand/SignUpBrand/SignupBrand.dart';
import 'drawer.dart';
import 'settings.dart';

class HomeUser extends StatefulWidget {
  final String name;
  final String userId;

  HomeUser({required this.name, required this.userId});

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  int _currentIndex = 0;
  late Future<Map<String, dynamic>> userDetailsFuture;
  final List<Widget> _pages = [];
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    userDetailsFuture = fetchUserDetails(widget.userId);
    _pages.addAll([
      BrandList(),
      ProfilePage(userId: widget.userId),
      SettingsPage(context),
    ]);
    _fetchNotifications();
  }

  // Fetch user details from Firestore
  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw 'User details not found';
      }
    } catch (e) {
      throw 'Error fetching user details: $e';
    }
  }

  // Fetch the count of new notifications (accepted collab requests)
  void _fetchNotifications() async {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('influencerId', isEqualTo: widget.userId)
        .where('seen', isEqualTo: false) // ✅ Only count unseen notifications
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        _notificationCount =
            querySnapshot.docs.length; // ✅ Dynamically update UI
      });
    });
  }

  // Open the notification list
  void _showNotifications() {
    Get.bottomSheet(
      Container(
        height: 400,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Text(
              "Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('influencerId', isEqualTo: widget.userId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No notifications yet."));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;

                      return ListTile(
                        leading:
                            Icon(Icons.notifications, color: Colors.purple),
                        title: Text(data['message'] ?? "No message"),
                        subtitle: Text(
                          data['timestamp'] != null
                              ? "${data['timestamp'].toDate().toLocal().day}-${data['timestamp'].toDate().toLocal().month}-${data['timestamp'].toDate().toLocal().year}"
                              : "No date",
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('notifications')
                                .doc(doc.id)
                                .update({'seen': true});
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Influence Hub",
              style: GoogleFonts.kaushanScript(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            ImageIcon(AssetImage("assets/icons/img.png"), color: Colors.orange),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white, size: 28),
                onPressed: _showNotifications,
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    constraints: BoxConstraints(minWidth: 10, minHeight: 10),
                    child: Text(
                      '$_notificationCount',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: FutureBuilder<Map<String, dynamic>>(
        future: userDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer();
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Drawer(
              child: Center(child: Text('Error loading user details')),
            );
          } else {
            final userName = snapshot.data!['fullName'];
            return AppDrawer(
              userId: widget.userId,
              userName: userName,
              onLogout: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged out successfully.')),
                );
              },
              onShowSettings: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            );
          }
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: "Search Here..",
              hintStyle: TextStyle(color: Colors.grey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Expanded(child: _pages[_currentIndex]),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SaveDataPage()));
              },
              child: Text(
                "Do you own a brand? \n "
                "        Add it now",
                style: TextStyle(color: Colors.purple[100], fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.purple,
      ),
    );
  }
}

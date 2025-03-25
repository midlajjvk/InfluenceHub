// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:influencehub/Brandcard.dart';
// import 'package:influencehub/influencer/Home/profilepageinfluencer.dart';
// import '../../brand/SignUpBrand/SignupBrand.dart';
// import 'drawer.dart';
// import 'settings.dart';
//
// class HomeUser extends StatefulWidget {
//   final String name;
//   final String userId;
//
//   HomeUser({required this.name, required this.userId});
//
//   @override
//   _HomeUserState createState() => _HomeUserState();
// }
//
// class _HomeUserState extends State<HomeUser> {
//   TextEditingController _searchController = TextEditingController();
//   String _searchQuery = "";
//   int _currentIndex = 0;
//   late Future<Map<String, dynamic>> userDetailsFuture;
//   final List<Widget> _pages = [];
//   int _notificationCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       setState(() {
//         _searchQuery = _searchController.text.trim().toLowerCase();
//       });
//     });
//     userDetailsFuture = fetchUserDetails(widget.userId);
//     _pages.addAll([
//       BrandList(
//         searchQuery: '',
//       ),
//       ProfilePage(userId: widget.userId),
//       SettingsPage(context),
//     ]);
//     _fetchNotifications();
//   }
//
//   Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
//     try {
//       DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//           .instance
//           .collection('users')
//           .doc(userId)
//           .get();
//
//       if (snapshot.exists) {
//         return snapshot.data()!;
//       } else {
//         throw 'User details not found';
//       }
//     } catch (e) {
//       throw 'Error fetching user details: $e';
//     }
//   }
//
//   void _fetchNotifications() async {
//     FirebaseFirestore.instance
//         .collection('notifications')
//         .where('influencerId', isEqualTo: widget.userId)
//         .where('seen', isEqualTo: false)
//         .snapshots()
//         .listen((querySnapshot) {
//       setState(() {
//         _notificationCount = querySnapshot.docs.length;
//       });
//     });
//   }
//
//   void _showNotifications() {
//     Get.bottomSheet(
//       Container(
//         height: 400,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           children: [
//             Text("Notifications",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('notifications')
//                     .where('influencerId', isEqualTo: widget.userId)
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return Center(child: Text("No notifications yet."));
//                   }
//                   return ListView(
//                     children: snapshot.data!.docs.map((doc) {
//                       var data = doc.data() as Map<String, dynamic>;
//                       return ListTile(
//                         leading:
//                             Icon(Icons.notifications, color: Colors.purple),
//                         title: Text(data['message'] ?? "No message"),
//                         subtitle: Text(
//                           data['timestamp'] != null
//                               ? "${data['timestamp'].toDate().toLocal().day}-${data['timestamp'].toDate().toLocal().month}-${data['timestamp'].toDate().toLocal().year}"
//                               : "No date",
//                         ),
//                         trailing: IconButton(
//                           icon: Icon(Icons.check, color: Colors.green),
//                           onPressed: () {
//                             FirebaseFirestore.instance
//                                 .collection('notifications')
//                                 .doc(doc.id)
//                                 .update({'seen': true});
//                           },
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Influence Hub",
//             style: GoogleFonts.kaushanScript(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//         actions: [
//           Stack(
//             children: [
//               IconButton(
//                 icon: Icon(Icons.notifications, color: Colors.white, size: 28),
//                 onPressed: _showNotifications,
//               ),
//               if (_notificationCount > 0)
//                 Positioned(
//                   right: 11,
//                   top: 11,
//                   child: Container(
//                     padding: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     constraints: BoxConstraints(minWidth: 10, minHeight: 10),
//                     child: Text('$_notificationCount',
//                         style: TextStyle(color: Colors.white, fontSize: 8),
//                         textAlign: TextAlign.center),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//       drawer: FutureBuilder<Map<String, dynamic>>(
//         future: userDetailsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Drawer();
//           } else if (snapshot.hasError || !snapshot.hasData) {
//             return Drawer(
//                 child: Center(child: Text('Error loading user details')));
//           } else {
//             final userName = snapshot.data!['fullName'];
//             return AppDrawer(
//                 userId: widget.userId,
//                 userName: userName,
//                 onLogout: () {},
//                 onShowSettings: () {});
//           }
//         },
//       ),
//       body: _currentIndex == 0
//           ? Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(10),
//                   child: TextField(
//                     controller: _searchController,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.search, color: Colors.white),
//                       hintText: "Search by brand name or category...",
//                       hintStyle: TextStyle(color: Colors.grey),
//                       filled: true,
//                       fillColor: Colors.grey[900],
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                     ),
//                   ),
//                 ),
//                 Expanded(child: BrandList(searchQuery: _searchQuery)),
//               ],
//             )
//           : _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.black,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//         unselectedItemColor: Colors.white,
//         selectedItemColor: Colors.purple,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:influencehub/Brandcard.dart';
import 'package:influencehub/influencer/Home/profilepageinfluencer.dart';
import '../../brand/SignUpBrand/SignupBrand.dart';
import '../../chat/chat.dart';
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
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _currentIndex = 0;
  late Future<Map<String, dynamic>> userDetailsFuture;
  final List<Widget> _pages = [];
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    userDetailsFuture = fetchUserDetails(widget.userId);
    _pages.addAll([
      BrandList(searchQuery: ''),
      ProfilePage(userId: widget.userId),
      SettingsPage(context),
    ]);
    _fetchNotifications();
  }

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

  void _fetchNotifications() async {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('influencerId', isEqualTo: widget.userId)
        .where('seen', isEqualTo: false)
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        _notificationCount = querySnapshot.docs.length;
      });
    });
  }

  Stream<int> getUnreadMessageCount() {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: widget.userId)
        .snapshots()
        .asyncMap((snapshot) async {
      int unreadCount = 0;
      for (var chatDoc in snapshot.docs) {
        final messages = await chatDoc.reference
            .collection('messages')
            .where('senderId', isNotEqualTo: widget.userId)
            .where('isRead', isEqualTo: false)
            .get();
        unreadCount += messages.docs.length;
      }
      return unreadCount;
    });
  }

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
            Text("Notifications",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Influence Hub",
          style: GoogleFonts.kaushanScript(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white),
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
          StreamBuilder<int>(
            stream: getUnreadMessageCount(),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.chat, color: Colors.white, size: 28),
                    onPressed: () {
                      Get.to(() => InfluencerChatsListPage(influencerId: widget.userId));
                    },
                  ),
                  if (unreadCount > 0)
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
                          '$unreadCount',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
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
                child: Center(child: Text('Error loading user details')));
          } else {
            final userName = snapshot.data!['fullName'];
            return AppDrawer(
                userId: widget.userId,
                userName: userName,
                onLogout: () {},
                onShowSettings: () {});
          }
        },
      ),
      body: _currentIndex == 0
          ? Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: "Search by brand name or category...",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          Expanded(child: BrandList(searchQuery: _searchQuery)),
        ],
      )
          : _pages[_currentIndex],
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

class InfluencerChatsListPage extends StatelessWidget {
  final String influencerId;

  const InfluencerChatsListPage({required this.influencerId});

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: influencerId)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.white)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No chats yet', style: TextStyle(color: Colors.white)));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
            var chatData = chats[index].data() as Map<String, dynamic>;
            var participants = List<dynamic>.from(chatData['participants'] ?? []);
            var otherUserId =
            participants.firstWhere((id) => id != influencerId, orElse: () => '');
            var lastMessage = chatData['lastMessage'] as String? ?? '';
            var chatName = chatData['brandName'] as String? ?? 'Chat';
            var chatId = _getChatId(influencerId, otherUserId);

            if (otherUserId == '') {
              return SizedBox.shrink();
            }

            return ListTile(
              title: Text(chatName, style: TextStyle(color: Colors.white)),
              subtitle: Text(
                lastMessage,
                style: TextStyle(color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Get.to(() => ChatScreen(
                  chatId: chatId,
                  otherUserId: otherUserId,
                  chatName: chatName,
                ));
              },
              tileColor: Colors.grey[900],
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          },
          );        },
      ),
    );
  }
}
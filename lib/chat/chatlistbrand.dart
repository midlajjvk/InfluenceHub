import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat.dart'; // Import the unified ChatScreen

class ChatsListPage extends StatelessWidget {
  final String brandId;

  const ChatsListPage({required this.brandId});

  String _getChatId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<String> _fetchUserName(String userId) async {
    try {
      // Try fetching from 'users' collection
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data()?['fullName'] ?? 'Unknown User';
      }

      // Try fetching from 'influencers' collection
      var influencerDoc = await FirebaseFirestore.instance
          .collection('influencers')
          .doc(userId)
          .get();

      if (influencerDoc.exists) {
        return influencerDoc.data()?['fullName'] ?? 'Unknown User';
      }

      // Fallback if no name is found
      return 'Unknown User';
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Unknown User';
    }
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
            .where('participants', arrayContains: brandId)
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
                child: Text('No chats yet',
                    style: TextStyle(color: Colors.white)));
          }

          var chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chatData = chats[index].data() as Map<String, dynamic>;
              var participants = List<dynamic>.from(chatData['participants'] ?? []);
              var otherUserId = participants.firstWhere(
                    (id) => id != brandId,
                orElse: () => '',
              );
              var lastMessage = chatData['lastMessage'] as String? ?? '';
              var chatId = _getChatId(brandId, otherUserId);

              if (otherUserId == '') {
                return SizedBox.shrink();
              }

              return FutureBuilder<String>(
                future: _fetchUserName(otherUserId),
                builder: (context, userNameSnapshot) {
                  String chatName = userNameSnapshot.data ?? 'Loading...';

                  if (userNameSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...', style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        lastMessage,
                        style: TextStyle(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tileColor: Colors.grey[900],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    );
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
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String influencerId;
  final String brandId;
  final String brandName;

  ChatScreen({required this.influencerId, required this.brandId, required this.brandName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Ensure the chat exists and return chat ID
  Future<String> getChatId() async {
    List<String> ids = [widget.influencerId, widget.brandId];
    ids.sort();
    String chatId = ids.join("_");

    DocumentReference chatDoc = _firestore.collection('chats').doc(chatId);
    DocumentSnapshot chatSnapshot = await chatDoc.get();

    if (!chatSnapshot.exists) {
      await chatDoc.set({
        'influencerId': widget.influencerId,
        'brandId': widget.brandId,
        'lastMessage': "",
        'timestamp': Timestamp.now(),
      });
    }

    return chatId;
  }

  // 🔹 Send Message
  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String chatId = await getChatId();

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': widget.influencerId,
      'receiverId': widget.brandId,
      'text': _messageController.text.trim(),
      'timestamp': Timestamp.now(),
    });

    // 🔹 Update last message in chat document
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': _messageController.text.trim(),
      'timestamp': Timestamp.now(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brandName,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 🔹 Display Chat Messages
          Expanded(
            child: FutureBuilder<String>(
              future: getChatId(), // Ensure chat exists first
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                String chatId = snapshot.data!;
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (!messageSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var messages = messageSnapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var messageData = messages[index].data() as Map<String, dynamic>;
                        bool isMe = messageData['senderId'] == widget.influencerId;

                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.purple : Colors.grey[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              messageData['text'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Message Input Field
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

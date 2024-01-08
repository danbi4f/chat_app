import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final db = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController messageController = TextEditingController();

  submitMessage() async {
    final enteredMessage = messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await db.collection('users').doc(user.uid).get();

    db.collection('chat').add(
      {
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username'],
        'userImage': userData.data()!['image_url'],
      },
    );

    messageController.clear();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                label: Text('Send a message..'),
              ),
            ),
          ),
          IconButton(
            onPressed: submitMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

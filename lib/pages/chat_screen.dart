import 'package:chat_app/widgets/chat_messege.dart';
import 'package:chat_app/widgets/new_messege.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FlutterChat'),
          actions: [
            IconButton(
              onPressed: () {
                firebase.signOut();
              },
              icon: const Icon(Icons.exit_to_app_rounded),
            ),
          ],
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ChatMessages(),
            NewMessage(),
          ],
        ));
  }
}

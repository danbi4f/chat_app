import 'package:chat_app/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: db.collection('chat').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No message found'),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong..'),
          );
        }
        final loadedMessage = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
          itemCount: loadedMessage.length,
          itemBuilder: (context, index) {
            //
            //
            final chatMessage = loadedMessage[index].data();
            final nextChatMessage = index + 1 < loadedMessage.length
                ? loadedMessage[index + 1].data()
                : null;
            //
            //
            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            //
            //
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;
            //
            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser!.uid == currentMessageUserId,
              );
            } else {
              MessageBubble.first(
                message: chatMessage['text'],
                isMe: authenticatedUser!.uid == currentMessageUserId,
                username: chatMessage['username'],
                userImage: chatMessage['userImage'],
              );
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.message,
    required this.isMe,
    required this.username,
    required this.userImage,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : username = null,
        userImage = null,
        isFirstInSequence = false;

  final bool isFirstInSequence;
  final String? username;
  final String? userImage;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: 15,
            right: isMe ? 0 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                userImage!,
              ),
            ),
          ),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    if (username != null) Text(username!),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(message),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}

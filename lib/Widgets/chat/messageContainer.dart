
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  final String message;
  final bool isMe;
  final key;
  final username;
  final String userImage;
  const MessageContainer(
      {required this.message,
      required this.isMe,
      required this.username,
      required this.userImage,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: isMe
                      ? const Color.fromARGB(255, 226, 150, 175)
                      : const Color.fromARGB(255, 163, 161, 162),
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(12),
                      bottomRight: !isMe
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                      topLeft: isMe
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                      topRight: const Radius.circular(12))),
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                );
              }),
            ),
          ],
        ),
        Positioned(
          top: -7,
          left: isMe ? MediaQuery.of(context).size.width * 0.67 : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isMe)
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userImage),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(username),
                ),
                if (isMe)
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userImage),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

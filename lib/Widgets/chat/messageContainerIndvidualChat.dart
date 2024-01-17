import 'package:flutter/material.dart';

class MessageContainerIndvidualChat extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;

  MessageContainerIndvidualChat(
      {required this.message,
      required this.isMe,
      required this.username,
      required this.userImage,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onPanStart: (val) {},
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(userImage),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            constraints: message.length > 50
                ? BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  )
                : null,
            decoration: BoxDecoration(
                color: !isMe
                    ? const Color.fromARGB(255, 176, 176, 176)
                    : const Color.fromARGB(255, 50, 145, 240),
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
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    message,
                    style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
          if (isMe)
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(userImage),
            ),
        ],
      ),
    );
  }
}

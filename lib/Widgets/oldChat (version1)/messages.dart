import 'package:chatapp/Widgets/oldChat%20(version1)/messageContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapShotData) {
          final fireData = FirebaseAuth.instance.currentUser;
          if (snapShotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDoc = snapShotData.data!.docs;
          return ListView.builder(
              reverse: true,
              itemCount: chatDoc.length,
              itemBuilder: (ctx, index) => MessageContainer(
                    message: chatDoc[index]['text'],
                    isMe: chatDoc[index]['uid'] == fireData!.uid,
                    username: chatDoc[index]['username'],
                    userImage: chatDoc[index]['userImageURL'],
                    key: ValueKey(chatDoc[index].id),
                  ));
        });
  }
}

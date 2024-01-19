// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatapp/Widgets/chat/messageContainerIndvidualChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatWindow extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> groupInfo;
  const GroupChatWindow({
    Key? key,
    required this.groupInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Column(
        children: [
          Card(
            elevation: 10,
            color: const Color(0xffd9edf8),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(groupInfo.data()['groupImageURL']),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      groupInfo.data()['groupName'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 237, 236, 236),
              height: MediaQuery.of(context).size.height * 0.85,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Groups/${groupInfo.id}/messages')
                    .orderBy('createdAt', descending: false)
                    .snapshots(),
                builder: (context, messagesData) {
                  if (messagesData.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Image.asset('assets/Images/loading.gif')),
                    );
                  }
                  final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      memberDetails = messagesData.data!.docs;

                  if (memberDetails.isEmpty) {
                    return const Center(
                      child: Text('Start to chat'),
                    );
                  }
                  return ListView.builder(
                      itemCount: memberDetails.length,
                      itemBuilder: (context, index) {
                        return MessageContainerIndvidualChat(
                            message: memberDetails[index].data()['text'],
                            isMe: currentUser!.uid ==
                                memberDetails[index].data()['id'],
                            username: memberDetails[index].data()['username'],
                            userImage: memberDetails[index].data()['imageURL']);
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

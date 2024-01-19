
import 'package:chatapp/Widgets/oldChat%20(version1)/messageContainerIndvidualChat.dart';
import 'package:chatapp/Widgets/chats/sendNewIndividualMsg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatWindow extends StatefulWidget {
  final dynamic receiverInfo;

  const ChatWindow({required this.receiverInfo, Key? key}) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  Map<String, dynamic>? senderDetails;
  SendNewIndividualMsg? sendNewIndividualMsg;
  @override
  void initState() {
    super.initState();
    sendNewIndividualMsg = SendNewIndividualMsg(
      receiverInfo: widget.receiverInfo.data(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String receiverId = widget.receiverInfo['id'].toString().substring(0, 7);
    String senderId = user!.uid.substring(0, 7);
    print('receiver Id : $receiverId');
    print('sender Id : $senderId');

    String mergedString = receiverId + senderId;
    List<String> characterList = mergedString.split('');
    // Sort the list of characters in descending order
    characterList.sort((a, b) => b.compareTo(a));

    // Convert the sorted list back to a string
    String uniqueKey = characterList.join('').trim();

    print('UniqueKey : $uniqueKey');
    return Scaffold(
      body: Center(
        child: GestureDetector(
              onTap: () {
                onTapFunction(sendNewIndividualMsg!.getFocus);
              },
              child: SizedBox(
                height: double.infinity,
                child: Column(
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
                                  icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded)),
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    widget.receiverInfo.data()['imageURL']),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.receiverInfo.data()['userName'],
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
                                .collection(
                                    'IndividualMessages/$uniqueKey/chating')
                                .orderBy('createdAt', descending: false)
                                .snapshots(),
                            builder: (context, messagesData) {
                              if (messagesData.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: Image.asset(
                                        'assets/Images/loading.gif'),
                                  ),
                                );
                              }
                              final chatDoc = messagesData.data!.docs;
                              if (chatDoc.isEmpty) {
                                  return const Center(
                                    child: Text('Start to chat'),
                                  );
                                }
                              print('Chat Document');
                              return ListView.builder(
                                itemCount: chatDoc.length,
                                itemBuilder: (context, index) =>
                                    MessageContainerIndvidualChat(
                                        message: chatDoc[index].data()['text'],
                                        isMe: chatDoc[index].data()['uid'] ==
                                            user.uid,
                                        username:
                                            chatDoc[index].data()['username'],
                                        userImage: chatDoc[index]
                                            .data()['userImageURL']),
                              );
                            }),
                      ),
                    ),
                    sendNewIndividualMsg!,
                  ],
                ),
              
            ),
          
        ),
      ),
    );
  }

  void onTapFunction(FocusNode focusNode1) {
    if (focusNode1.hasFocus) {
      focusNode1.unfocus();
    }
  }
}

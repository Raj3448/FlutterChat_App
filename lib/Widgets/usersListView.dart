import 'package:chatapp/screens/Chats/chatWindow.dart';
import 'package:chatapp/screens/GroupChats/group_chat_window.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> user;

  bool isGroup;

  UsersListView({required this.user, required this.isGroup, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isGroup) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => GroupChatWindow(groupInfo: user,)));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatWindow(receiverInfo: user)));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 235, 235),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: ListTile(
            leading: Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                  user.data()[isGroup ? 'groupImageURL' : 'imageURL'],
                  fit: BoxFit.cover),
            ),
            title: Text(
              user.data()[isGroup ? 'groupName' : 'userName'],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            trailing: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset('assets/Images/dots.png', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

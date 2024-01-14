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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('usersDoc')
              .doc(user!.uid)
              .get(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Image.asset('assets/Images/loading.gif'),
                ),
              );
            }
            // if (state is AuthSuccess && senderDetails == null) {
            //   CollectionReference<Map<String, dynamic>> collectionReference =
            //       FirebaseFirestore.instance.collection('usersDoc');

            //   collectionReference
            //       .where('id', isEqualTo: state.UID)
            //       .get()
            //       .then((value) {
            //     for (QueryDocumentSnapshot<Map<String, dynamic>> document
            //         in value.docs) {
            //       print('Sender Document Details : ${document.data()}');
            //       setState(() {
            //         senderDetails = document.data();
            //       });
            //     }
            //     return value;
            //   });
            // }
            return SizedBox(
              child: Column(
                children: [
                  Text(
                      'Receiver Name : ${widget.receiverInfo.data()['userName']}'),
                  Text('Sender Name : ${snapShot.data!.data()!['userName']}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

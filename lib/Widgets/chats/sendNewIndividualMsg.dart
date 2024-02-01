import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendNewIndividualMsg extends StatefulWidget {
  final Map<String, dynamic> receiverInfo;
  SendNewIndividualMsg({required this.receiverInfo, Key? key})
      : super(key: key);
  final FocusNode focusNode = FocusNode();
  get getFocus => focusNode;
  @override
  State<SendNewIndividualMsg> createState() => _SendNewIndividualMsgState();
}

class _SendNewIndividualMsgState extends State<SendNewIndividualMsg> {
  final _controller = TextEditingController();
  String newMessage = '';

  void _submit() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = FirebaseAuth.instance.currentUser;
    final authData = await FirebaseFirestore.instance
        .collection('usersDoc')
        .doc(user!.uid)
        .get();
    String receiverId = widget.receiverInfo['id'].toString().substring(0, 7);
    String senderId = user.uid.substring(0, 7);
    print('receiver Id : $receiverId');
    print('sender Id : $senderId');

    String mergedString = receiverId + senderId;
    List<String> characterList = mergedString.split('');
    // Sort the list of characters in descending order
    characterList.sort((a, b) => b.compareTo(a));

    // Convert the sorted list back to a string
    String uniqueKey = characterList.join('').trim();
    print('UniqueKey : $uniqueKey');

    FirebaseFirestore.instance
        .collection('IndividualMessages/$uniqueKey/chating')
        .add({
      'text': newMessage,
      'createdAt': Timestamp.now(),
      'uid': user.uid,
      'username': authData['userName'],
      'userImageURL': authData['imageURL'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.08,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              decoration: const InputDecoration(
                  hintText: 'Send a message...',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  )),
              onChanged: (val) {
                setState(() {
                  newMessage = val;
                });
              },
              onSubmitted: newMessage.trim().isEmpty ? null : (_) => _submit(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 152, 98, 245)),
            child: IconButton(
                onPressed: newMessage.trim().isEmpty ? null : _submit,
                icon: const Icon(
                  Icons.send,
                  size: 30,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}

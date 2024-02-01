import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewMessageTextField extends StatefulWidget {
  NewMessageTextField({super.key});
  FocusNode focusNode = FocusNode();
  get getFocus => focusNode;

  @override
  State<NewMessageTextField> createState() => _NewMessageTextFieldState();
}

class _NewMessageTextFieldState extends State<NewMessageTextField> {
  final _controller = TextEditingController();
  String newMessage = '';

  void _submit() async{
    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = FirebaseAuth.instance.currentUser;
    final authData =
        await FirebaseFirestore.instance.collection('usersDoc').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': newMessage,
      'createdAt': Timestamp.now(),
      'uid': user.uid,
      'username': authData['userName'],
      'userImageURL': authData['imageURL'],
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.08,
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: widget.focusNode,
              decoration: const InputDecoration(
                label: Text('Send a message...'),
              ),
              onChanged: (val) {
                setState(() {
                  newMessage = val;
                });
              },
              onSubmitted: newMessage.trim().isEmpty ? null : (_) => _submit(),
            ),
          ),
          IconButton(
              onPressed: newMessage.trim().isEmpty ? null : _submit,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

import 'package:chatapp/bloc/GroupDetails/bloc/group_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendNewMessageInGrp extends StatefulWidget {
  var focusNode = FocusNode();
  //Id for accessing the message collection
  String documentId;

  get getFouusNode => focusNode;

  SendNewMessageInGrp({required this.documentId, Key? key}) : super(key: key);

  @override
  State<SendNewMessageInGrp> createState() => _SendNewMessageInGrpState();
}

class _SendNewMessageInGrpState extends State<SendNewMessageInGrp> {
  String newMessage = '';

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
              focusNode: widget.focusNode,
              decoration: const InputDecoration(
                label: Text('Send a message...'),
              ),
              onChanged: (val) {
                setState(() {
                  newMessage = val;
                });
              },
              onSubmitted: newMessage.trim().isEmpty
                  ? null
                  : (value) {
                      context
                          .read<GroupDetailsBloc>()
                          .add(AddGroupMessage(msgAndDocId: (
                            newMessage.trim(),
                            widget.documentId,
                          )));
                      widget.focusNode.unfocus();
                    },
            ),
          ),
          IconButton(
              onPressed: newMessage.trim().isEmpty
                  ? null
                  : () {
                      context
                          .read<GroupDetailsBloc>()
                          .add(AddGroupMessage(msgAndDocId: (
                            newMessage.trim(),
                            widget.documentId,
                          )));
                      widget.focusNode.unfocus();
                    },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

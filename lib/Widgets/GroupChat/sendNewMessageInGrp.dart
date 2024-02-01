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
  final TextEditingController _controller = TextEditingController();
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
              onSubmitted: newMessage.trim().isEmpty
                  ? null
                  : (value) {
                      context
                          .read<GroupDetailsBloc>()
                          .add(AddGroupMessage(msgAndDocId: (
                            newMessage.trim(),
                            widget.documentId,
                          ), context: context));
                      widget.focusNode.unfocus();
                      _controller.clear();
                    },
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
                onPressed: newMessage.trim().isEmpty
                    ? null
                    : () {
                        context
                            .read<GroupDetailsBloc>()
                            .add(AddGroupMessage(msgAndDocId: (
                              newMessage.trim(),
                              widget.documentId,
                            ), context: context));
                        widget.focusNode.unfocus();
                        _controller.clear();
                      },
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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chatapp/cubit/UserDetailsCubit/UserDetailsCubit.dart';
import 'package:chatapp/services/userInfo_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantsList extends StatefulWidget {
  final Map<String, dynamic> participantsList;

  ParticipantsList({
    Key? key,
    required this.participantsList,
  }) : super(key: key);

  @override
  State<ParticipantsList> createState() => _ParticipantsListState();
}

class _ParticipantsListState extends State<ParticipantsList> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = context
        .read<UserDetailsCubit>()
        .getIsUserDetailsIsExisted(widget.participantsList['id']);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: ListTile(
          leading: Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(widget.participantsList['imageURL'],
                fit: BoxFit.cover),
          ),
          title: Text(
            widget.participantsList['userName'],
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          trailing: Checkbox(
              value: isSelected,
              onChanged: (value) {
                isSelected = (value!);

                if (value) {
                  context
                      .read<UserDetailsCubit>()
                      .addUserDetailsInList(UserDetails(
                        id: widget.participantsList['id'],
                        username: widget.participantsList['userName'],
                        imageUrl: widget.participantsList['imageURL'],
                        email: widget.participantsList['email'],
                      ));
                } else {
                  context.read<UserDetailsCubit>().removeUserDetailsInList(
                      id: widget.participantsList['id']);
                }
              })),
    );
  }
}

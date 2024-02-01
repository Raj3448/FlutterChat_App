import 'dart:io';

import 'package:chatapp/cubit/UserDetailsCubit/UserDetailsCubit.dart';
import 'package:chatapp/models/userInfo_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uuid/uuid.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  Uuid uuid = const Uuid();
  GroupDetailsBloc() : super(GroupDetailsInitial()) {
    on<AddGroupDetailsInDatabase>((event, emit) async {
      emit(GroupDetailsLoading());
      if (event.groupImage == null ||
          event.groupName == null ||
          event.userDetailList.isEmpty) {
        emit(GroupDetailsFailure(error: 'Field is missing'));
        return;
      }
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection('Groups');
      //Generating unique id
      String uniqueId = uuid.v4();
      //save image file on firebase storage
      final Reference imageRefrence = FirebaseStorage.instance
          .ref()
          .child('GroupImage')
          .child('$uniqueId.jpg');
      await imageRefrence
          .putFile(event.groupImage!)
          .whenComplete(
              () => print('GroupImage Uploaded Successfully.....!!!'));
      String groupImgUrl = await imageRefrence.getDownloadURL();
      final currentUser = FirebaseAuth.instance.currentUser;
      DocumentReference<Map<String, dynamic>> documentReference =
          await collectionReference.add({
        'id': uniqueId,
        'groupName': event.groupName!.trim(),
        'groupImageURL': groupImgUrl,
        'UID': currentUser!.uid,
      });
      CollectionReference<Map<String, dynamic>> subCollectionReference =
          documentReference.collection('usersList');
      for (UserDetails userDetails in event.userDetailList) {
        subCollectionReference.add(userDetails.toJson());
      }
      emit(GroupDetailsSuccess());
    });

    on<AddGroupMessage>((event, emit) async {
      emit(GroupDetailsLoading());
      
      final Map<String, dynamic>? userData =
          await event.context.read<UserDetailsCubit>().getCurrentUserDetails();

      
          await FirebaseFirestore.instance
              .collection('Groups/${event.msgAndDocId.$2}/messages')
              .add({
        'id': userData!['id'],
        'text': event.msgAndDocId.$1,
        'createdAt': Timestamp.now(),
        'imageURL': userData['imageURL'],
        'userName': userData['userName']
      });
      emit(GroupDetailsSuccess());
    });
  }
}

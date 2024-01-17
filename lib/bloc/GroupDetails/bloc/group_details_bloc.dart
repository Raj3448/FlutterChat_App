import 'dart:io';

import 'package:chatapp/services/userInfo_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'group_details_event.dart';
part 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  Uuid uuid = const Uuid();
  GroupDetailsBloc() : super(GroupDetailsInitial()) {
    on<AddGroupDetails>((event, emit) async {
      emit(GroupDetailsInitial());
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection('Groups');
      //Generating unique id
      String uniqueId = uuid.v4();
      //save image file on firebase storage
      final Reference imageRefrence = FirebaseStorage.instance
          .ref()
          .child('GroupImage')
          .child('$uniqueId.jpg');
      final TaskSnapshot imageSnapShot = await imageRefrence
          .putFile(event.groupImage)
          .whenComplete(
              () => print('GroupImage Uploaded Successfully.....!!!'));
      String groupImgUrl = await imageRefrence.getDownloadURL();
      DocumentReference<Map<String, dynamic>> documentReference =
          await collectionReference.add({
        'id': uniqueId,
        'groupName': event.groupName,
        'groupImageURL': groupImgUrl,
      });
      CollectionReference<Map<String, dynamic>> subCollectionReference =
          documentReference.collection('usersList');
      // subCollectionReference.add({
      //   'members': ,
      // });
    });
  }
}

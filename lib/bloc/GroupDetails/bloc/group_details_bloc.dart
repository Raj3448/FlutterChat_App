import 'dart:io';

import 'package:chatapp/services/userInfo_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;

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
      final TaskSnapshot imageSnapShot = await imageRefrence
          .putFile(event.groupImage!)
          .whenComplete(
              () => print('GroupImage Uploaded Successfully.....!!!'));
      String groupImgUrl = await imageRefrence.getDownloadURL();
      DocumentReference<Map<String, dynamic>> documentReference =
          await collectionReference.add({
        'id': uniqueId,
        'groupName': event.groupName!.trim(),
        'groupImageURL': groupImgUrl,
      });
      CollectionReference<Map<String, dynamic>> subCollectionReference =
          documentReference.collection('usersList');
      for (UserDetails userDetails in event.userDetailList) {
        subCollectionReference.add(userDetails.toJson());
      }
      emit(GroupDetailsSuccess());
    });
    //   on<AddGroupImage>((event, emit) async {
    //     emit(GroupDetailsInitial());
    //     final XFile? receivedImage = await ImagePicker().pickImage(
    //         source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    //     if (receivedImage == null) {
    //       return;
    //     }
    //     File storedImage = File(receivedImage.path);
    //     emit(GroupImageGetSuccessfully(storedImage: storedImage));
    //     _getDirectory(receivedImage);

    //   });
    // }

    // Future<void> _getDirectory(XFile receivedImage) async {
    //   final appDirectory =
    //       await sysPathProvider.getApplicationDocumentsDirectory();
    //   final imageFile = File(receivedImage.path);
    //   final fileName = path.basename(imageFile.path);
    //   final storageResponse =
    //       await imageFile.copy('${appDirectory.path}/$fileName');

    //   print("Image Added Succesfully at :- $storageResponse");
    // }
  }
}

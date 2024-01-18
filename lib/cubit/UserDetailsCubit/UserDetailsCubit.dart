import 'dart:io';

import 'package:chatapp/services/userInfo_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;

part 'UserDetailsState.dart';

class UserDetailsCubit extends Cubit<UserDetailState> {
  UserDetailsCubit() : super(UserDetailsInitialState());

  List<UserDetails> _SelectedUserList = [];

  get getSelectedUserList {
    return [..._SelectedUserList];
  }

  bool getIsUserDetailsIsExisted(String id) {
    bool isExist = _SelectedUserList.any((element) => (element.id == id));
    return isExist;
  }

  void addUserDetailsInList(UserDetails userDetails) {
    emit(UserDetailsInitialState());
    Uuid uuid = Uuid();
    for (int i = 0; i < 10; i++) {
      print('UniqueId ${i + 1} : ${uuid.v4()}');
    }
    _SelectedUserList.add(userDetails);
    emit(UserDetailsSuccessState(selectedUserDetails: _SelectedUserList));
  }

  void removeUserDetailsInList({required String id}) {
    emit(UserDetailsInitialState());

    _SelectedUserList.removeWhere((element) => element.id == id);

    emit(UserDetailsSuccessState(selectedUserDetails: _SelectedUserList));
  }

  void resetAllOverList() {
    emit(UserDetailsInitialState());
    _SelectedUserList.clear();
    emit(UserDetailsSuccessState(selectedUserDetails: _SelectedUserList));
  }

  Future<File> getSelcetedImage() async {
    emit(UserDetailsInitialState());
    final XFile? receivedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    File storedImage = File(receivedImage!.path);

    _getDirectory(receivedImage);
    if (receivedImage != null) {
      emit(UserDetailsSuccessState(selectedUserDetails: getSelectedUserList));
    }
    return storedImage;
  }

  Future<void> _getDirectory(XFile receivedImage) async {
    final appDirectory =
        await sysPathProvider.getApplicationDocumentsDirectory();
    final imageFile = File(receivedImage.path);
    final fileName = path.basename(imageFile.path);
    final storageResponse =
        await imageFile.copy('${appDirectory.path}/$fileName');

    print("Image Added Succesfully at :- $storageResponse");
  }
}

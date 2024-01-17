import 'package:chatapp/services/userInfo_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
}

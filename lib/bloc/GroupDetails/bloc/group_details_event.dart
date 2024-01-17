// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'group_details_bloc.dart';

@immutable
sealed class GroupDetailsEvent {}

class AddGroupDetails extends GroupDetailsEvent {
  String groupName;
  File groupImage;
  List<UserDetails> userDetailList;
  AddGroupDetails({
    required this.groupName,
    required this.groupImage,
    required this.userDetailList,
  });
}

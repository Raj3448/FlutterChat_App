part of 'group_details_bloc.dart';

@immutable
sealed class GroupDetailsState {}

final class GroupDetailsInitial extends GroupDetailsState {}

final class GroupDetailsLoading extends GroupDetailsState {}

final class GroupDetailsSuccess extends GroupDetailsState {}

final class GroupImageGetSuccessfully extends GroupDetailsState {
  File storedImage;
  GroupImageGetSuccessfully({required this.storedImage});
}

final class GroupDetailsFailure extends GroupDetailsState {
  final String error;
  GroupDetailsFailure({required this.error});
}

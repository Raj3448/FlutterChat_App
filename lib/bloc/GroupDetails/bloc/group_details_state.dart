part of 'group_details_bloc.dart';

@immutable
sealed class GroupDetailsState {}

final class GroupDetailsInitial extends GroupDetailsState {}
final class GroupDetailsLoading extends GroupDetailsState {}
final class GroupDetailsSuccess extends GroupDetailsState {}
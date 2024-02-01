// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userInfo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => UserDetails(
      id: json['id'] as String,
      username: json['userName'] as String,
      imageUrl: json['imageURL'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.username,
      'imageURL': instance.imageUrl,
      'email': instance.email,
    };

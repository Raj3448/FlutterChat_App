import 'package:json_annotation/json_annotation.dart';
part 'userInfo_dto.g.dart';

@JsonSerializable()
class UserDetails {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "userName")
  String username;
  @JsonKey(name: "imageURL")
  String imageUrl;
  @JsonKey(name: "email")
  String email;

  UserDetails({
    required this.id,
    required this.username,
    required this.imageUrl,
    required this.email,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}

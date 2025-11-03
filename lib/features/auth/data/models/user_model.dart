import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    this.name,
    required this.email,
    this.profilePictureUrl,
    this.storageQuotaBytes,
    this.storageUsedBytes,
  });

  final String? name;
  final String email;
  final String? profilePictureUrl;
  final int? storageQuotaBytes;
  final int? storageUsedBytes;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

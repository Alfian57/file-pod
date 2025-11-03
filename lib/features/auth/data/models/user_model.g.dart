// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  name: json['name'] as String?,
  email: json['email'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  storageQuotaBytes: (json['storageQuotaBytes'] as num?)?.toInt(),
  storageUsedBytes: (json['storageUsedBytes'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'profilePictureUrl': instance.profilePictureUrl,
  'storageQuotaBytes': instance.storageQuotaBytes,
  'storageUsedBytes': instance.storageUsedBytes,
};

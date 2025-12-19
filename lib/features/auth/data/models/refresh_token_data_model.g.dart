// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenDataModel _$RefreshTokenDataModelFromJson(
  Map<String, dynamic> json,
) => RefreshTokenDataModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$RefreshTokenDataModelToJson(
  RefreshTokenDataModel instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};

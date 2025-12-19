import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_data_model.g.dart';

@JsonSerializable()
class RefreshTokenDataModel {
  final String accessToken;
  final String refreshToken;

  RefreshTokenDataModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenDataModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenDataModelToJson(this);
}

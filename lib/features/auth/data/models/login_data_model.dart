import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'login_data_model.g.dart';

@JsonSerializable()
class LoginDataModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) =>
      _$LoginDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'share_response_model.g.dart';

@JsonSerializable()
class ShareResponseModel {
  ShareResponseModel({required this.linkToken, required this.shareUrl});

  factory ShareResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShareResponseModelFromJson(json);

  final String linkToken;
  final String shareUrl;

  Map<String, dynamic> toJson() => _$ShareResponseModelToJson(this);
}

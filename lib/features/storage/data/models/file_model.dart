import 'package:json_annotation/json_annotation.dart';

part 'file_model.g.dart';

@JsonSerializable()
class FileModel {
  FileModel({
    required this.id,
    required this.originalName,
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    required this.createdAt,
  });

  final String id;
  final String originalName;
  final String filename;
  final String mimeType;
  final String? sizeBytes;
  final String createdAt;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileModelToJson(this);
}

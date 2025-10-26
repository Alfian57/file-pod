// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileModel _$FileModelFromJson(Map<String, dynamic> json) => FileModel(
  id: json['id'] as String,
  originalName: json['originalName'] as String,
  filename: json['filename'] as String,
  mimeType: json['mimeType'] as String,
  sizeBytes: json['sizeBytes'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$FileModelToJson(FileModel instance) => <String, dynamic>{
  'id': instance.id,
  'originalName': instance.originalName,
  'filename': instance.filename,
  'mimeType': instance.mimeType,
  'sizeBytes': instance.sizeBytes,
  'createdAt': instance.createdAt,
};

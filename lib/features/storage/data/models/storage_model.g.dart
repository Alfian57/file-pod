// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageModel _$StorageModelFromJson(Map<String, dynamic> json) => StorageModel(
  folders: (json['folders'] as List<dynamic>)
      .map((e) => FolderModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  files: (json['files'] as List<dynamic>)
      .map((e) => FileModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StorageModelToJson(StorageModel instance) =>
    <String, dynamic>{'folders': instance.folders, 'files': instance.files};

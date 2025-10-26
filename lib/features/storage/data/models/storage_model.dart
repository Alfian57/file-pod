import 'package:file_pod/features/storage/data/models/file_model.dart';
import 'package:file_pod/features/storage/data/models/folder_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'storage_model.g.dart';

@JsonSerializable()
class StorageModel {
  StorageModel({required this.folders, required this.files});

  final List<FolderModel> folders;
  final List<FileModel> files;

  factory StorageModel.fromJson(Map<String, dynamic> json) =>
      _$StorageModelFromJson(json);

  Map<String, dynamic> toJson() => _$StorageModelToJson(this);
}

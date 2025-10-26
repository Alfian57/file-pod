import 'package:equatable/equatable.dart';
import 'package:file_pod/features/storage/domain/entities/file_entity.dart';
import 'package:file_pod/features/storage/domain/entities/folder_entity.dart';

class StorageEntity extends Equatable {
  const StorageEntity({required this.folders, required this.files});

  final List<FolderEntity> folders;
  final List<FileEntity> files;

  @override
  List<Object?> get props => [folders, files];
}

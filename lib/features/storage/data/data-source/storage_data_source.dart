import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';

abstract class StorageDataSource {
  Future<StorageEntity> getStorage();
  Future<StorageEntity> getStorageDetail(String folderId);
  Future<void> createFolder(String name, String? parentFolderId);
  Future<void> deleteFolder(String folderId);
  Future<void> uploadFile(String filePath, String? folderId);
  Future<void> deleteFile(String fileId);
}

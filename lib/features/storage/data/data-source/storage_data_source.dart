import 'package:file_pod/features/storage/domain/entities/share_response_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';

abstract class StorageDataSource {
  Future<StorageEntity> getStorage({String? sortBy, String? sortOrder});
  Future<StorageEntity> getStorageDetail(
    String folderId, {
    String? sortBy,
    String? sortOrder,
  });
  Future<void> createFolder(String name, String? parentFolderId);
  Future<void> deleteFolder(String folderId);
  Future<void> uploadFile(String filePath, String? folderId);
  Future<void> deleteFile(String fileId);
  Future<List<int>> downloadFile(String fileId);
  Future<ShareResponseEntity> shareFile(String fileId, String? password);
  Future<ShareResponseEntity> shareFolder(String folderId, String? password);
}

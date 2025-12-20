import 'package:file_pod/features/storage/domain/entities/share_response_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';

abstract class StorageDataSource {
  Future<StorageEntity> getStorage({
    String? sortBy,
    String? sortOrder,
    String? search,
    String? type,
  });
  Future<StorageEntity> getStorageDetail(
    String folderId, {
    String? sortBy,
    String? sortOrder,
    String? search,
    String? type,
  });
  Future<void> createFolder(String name, String? parentFolderId, {String? color});
  Future<void> deleteFolder(String folderId);
  Future<void> uploadFile(String filePath, String? folderId,
      {void Function(int sent, int total)? onProgress});
  Future<void> deleteFile(String fileId);
  Future<List<int>> downloadFile(String fileId);
  Future<ShareResponseEntity> shareFile(String fileId, String? password);
  Future<ShareResponseEntity> shareFolder(String folderId, String? password);
  Future<void> renameFolder(String folderId, String name);
  Future<void> renameFile(String fileId, String name);
}

import 'package:dartz/dartz.dart';
import 'package:file_pod/features/storage/domain/entities/share_response_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';

abstract class StorageRepository {
  Future<Either<String, StorageEntity>> getStorage({
    String? sortBy,
    String? sortOrder,
    String? search,
    String? type,
  });
  Future<Either<String, StorageEntity>> getStorageDetail(
    String folderId, {
    String? sortBy,
    String? sortOrder,
    String? search,
    String? type,
  });
  Future<Either<String, Unit>> createFolder(
    String name,
    String? parentFolderId, {
    String? color,
  });
  Future<Either<String, Unit>> deleteFolder(String folderId);
  Future<Either<String, Unit>> uploadFile(String filePath, String? folderId,
      {void Function(int sent, int total)? onProgress});
  Future<Either<String, Unit>> deleteFile(String fileId);
  Future<Either<String, List<int>>> downloadFile(String fileId);
  Future<Either<String, ShareResponseEntity>> shareFile(
    String fileId,
    String? password,
  );
  Future<Either<String, ShareResponseEntity>> shareFolder(
    String folderId,
    String? password,
  );
  Future<Either<String, Unit>> renameFolder(String folderId, String name);
  Future<Either<String, Unit>> renameFile(String fileId, String name);
}

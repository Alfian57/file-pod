import 'package:dartz/dartz.dart';
import 'package:file_pod/features/storage/domain/entities/share_response_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';

abstract class StorageRepository {
  Future<Either<String, StorageEntity>> getStorage({
    String? sortBy,
    String? sortOrder,
  });
  Future<Either<String, StorageEntity>> getStorageDetail(
    String folderId, {
    String? sortBy,
    String? sortOrder,
  });
  Future<Either<String, Unit>> createFolder(
    String name,
    String? parentFolderId,
  );
  Future<Either<String, Unit>> deleteFolder(String folderId);
  Future<Either<String, Unit>> uploadFile(String filePath, String? folderId);
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
}

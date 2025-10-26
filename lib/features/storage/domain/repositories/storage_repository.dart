import 'package:dartz/dartz.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';

abstract class StorageRepository {
  Future<Either<String, StorageEntity>> getStorage();
  Future<Either<String, StorageEntity>> getStorageDetail(String folderId);
  Future<Either<String, Unit>> createFolder(
    String name,
    String? parentFolderId,
  );
  Future<Either<String, Unit>> deleteFolder(String folderId);
  Future<Either<String, Unit>> uploadFile(String filePath, String? folderId);
  Future<Either<String, Unit>> deleteFile(String fileId);
}

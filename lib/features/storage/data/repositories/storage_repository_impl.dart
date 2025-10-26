import 'package:dartz/dartz.dart';
import 'package:file_pod/features/storage/data/data-source/storage_data_source.dart';
import 'package:file_pod/features/storage/data/data-source/storage_data_source_impl.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';
import 'package:file_pod/features/storage/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl({required this.storageDataSource});

  final StorageDataSource storageDataSource;

  @override
  Future<Either<String, StorageEntity>> getStorage() async {
    try {
      final storage = await storageDataSource.getStorage();
      return Right(storage);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, StorageEntity>> getStorageDetail(
    String folderId,
  ) async {
    try {
      final storage = await storageDataSource.getStorageDetail(folderId);
      return Right(storage);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, Unit>> createFolder(
    String name,
    String? parentFolderId,
  ) async {
    try {
      await storageDataSource.createFolder(name, parentFolderId);
      return const Right(unit);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, Unit>> deleteFolder(String folderId) async {
    try {
      await storageDataSource.deleteFolder(folderId);
      return const Right(unit);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, Unit>> uploadFile(
    String filePath,
    String? folderId,
  ) async {
    try {
      await storageDataSource.uploadFile(filePath, folderId);
      return const Right(unit);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, Unit>> deleteFile(String fileId) async {
    try {
      await storageDataSource.deleteFile(fileId);
      return const Right(unit);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }
}

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final ds = ref.read(storageDataSourceProvider);
  return StorageRepositoryImpl(storageDataSource: ds);
});

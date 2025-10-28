import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/core/utils/api_message_extractor.dart';
import 'package:file_pod/features/storage/data/data-source/storage_api_service.dart';
import 'package:file_pod/features/storage/data/data-source/storage_data_source.dart';
import 'package:file_pod/features/storage/data/models/storage_model.dart';
import 'package:file_pod/features/storage/domain/entities/file_entity.dart';
import 'package:file_pod/features/storage/domain/entities/folder_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageDataSourceImpl implements StorageDataSource {
  StorageDataSourceImpl({required StorageApiService apiService})
    : _apiService = apiService;

  final StorageApiService _apiService;

  @override
  Future<StorageEntity> getStorage() async {
    final Response<ApiResponseModel<StorageModel>> res = await _apiService
        .getStorage();

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to get storage (${res.statusCode})';
      throw Exception(apiMessage);
    }

    final storageData = res.body?.data;
    if (storageData == null) {
      throw Exception('Storage response missing data');
    }

    return StorageEntity(
      folders: storageData.folders
          .map(
            (folder) => FolderEntity(
              id: folder.id,
              name: folder.name,
              createdAt: folder.createdAt,
            ),
          )
          .toList(),
      files: storageData.files
          .map(
            (file) => FileEntity(
              id: file.id,
              originalName: file.originalName,
              filename: file.filename,
              mimeType: file.mimeType,
              sizeBytes: file.sizeBytes,
              createdAt: file.createdAt,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<StorageEntity> getStorageDetail(String folderId) async {
    final Response<ApiResponseModel<StorageModel>> res = await _apiService
        .getStorageDetail(folderId);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to get storage detail (${res.statusCode})';
      throw Exception(apiMessage);
    }

    final storageData = res.body?.data;
    if (storageData == null) {
      throw Exception('Storage detail response missing data');
    }

    return StorageEntity(
      folders: storageData.folders
          .map(
            (folder) => FolderEntity(
              id: folder.id,
              name: folder.name,
              createdAt: folder.createdAt,
            ),
          )
          .toList(),
      files: storageData.files
          .map(
            (file) => FileEntity(
              id: file.id,
              originalName: file.originalName,
              filename: file.filename,
              mimeType: file.mimeType,
              sizeBytes: file.sizeBytes,
              createdAt: file.createdAt,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> createFolder(String name, String? parentFolderId) async {
    final body = {
      'name': name,
      if (parentFolderId != null) 'parentFolderId': parentFolderId,
    };

    final Response<ApiResponseModel<dynamic>> res = await _apiService
        .createFolder(body);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to create folder (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    final Response<ApiResponseModel<dynamic>> res = await _apiService
        .deleteFolder(folderId);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to delete folder (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<void> uploadFile(String filePath, String? folderId) async {
    final Response<ApiResponseModel<dynamic>> res = await _apiService
        .uploadFile(filePath, folderId);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to upload file (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<void> deleteFile(String fileId) async {
    final Response<ApiResponseModel<dynamic>> res = await _apiService
        .deleteFile(fileId);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to delete file (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<List<int>> downloadFile(String fileId) async {
    try {
      final Response<dynamic> res = await _apiService.downloadFile(fileId);

      print('Download response status: ${res.statusCode}');
      print('Download response isSuccessful: ${res.isSuccessful}');
      print('Download response body type: ${res.body.runtimeType}');
      print('Download response bodyBytes length: ${res.bodyBytes.length}');

      if (!res.isSuccessful) {
        throw Exception('Failed to download file (${res.statusCode})');
      }

      // Return bodyBytes directly
      return res.bodyBytes;
    } catch (e) {
      print('Download error: $e');
      rethrow;
    }
  }
}

final storageDataSourceProvider = Provider<StorageDataSource>((ref) {
  final apiService = ref.read(storageApiServiceProvider);
  return StorageDataSourceImpl(apiService: apiService);
});

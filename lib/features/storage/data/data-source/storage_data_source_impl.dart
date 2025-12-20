import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/core/utils/api_message_extractor.dart';
import 'package:file_pod/features/storage/data/data-source/storage_api_service.dart';
import 'package:file_pod/features/storage/data/data-source/storage_data_source.dart';
import 'package:file_pod/features/storage/data/models/file_model.dart';
import 'package:file_pod/features/storage/data/models/folder_model.dart';
import 'package:file_pod/features/storage/data/models/share_response_model.dart';
import 'package:file_pod/features/storage/data/models/storage_model.dart';
import 'package:file_pod/features/storage/domain/entities/file_entity.dart';
import 'package:file_pod/features/storage/domain/entities/folder_entity.dart';
import 'package:file_pod/features/storage/domain/entities/share_response_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';
import 'package:file_pod/core/constants/storage_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart' as dio_client;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageDataSourceImpl implements StorageDataSource {
  StorageDataSourceImpl({required StorageApiService apiService})
    : _apiService = apiService;

  final StorageApiService _apiService;

  @override
  Future<StorageEntity> getStorage({
    String? sortBy,
    String? sortOrder,
    String? search,
    String? type,
  }) async {
    final Response<ApiResponseModel<StorageModel>> res =
        await _apiService.getStorage(
      sortBy: sortBy,
      sortOrder: sortOrder,
      search: search,
      type: type,
    );

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
              color: folder.color,
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
  Future<StorageEntity> getStorageDetail(
    String folderId, {
    String? sortBy,
    String? sortOrder,
    String? search,
    String? type,
  }) async {
    final Response<ApiResponseModel<StorageModel>> res =
        await _apiService.getStorageDetail(
      folderId,
      sortBy: sortBy,
      sortOrder: sortOrder,
      search: search,
      type: type,
    );

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
              color: folder.color,
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
      ancestors: storageData.ancestors
              ?.map((folder) => FolderEntity(
                    id: folder.id,
                    name: folder.name,
                    createdAt: folder.createdAt,
                    color: folder.color,
                  ))
              .toList() ??
          [],
    );
  }

  @override
  Future<void> createFolder(
    String name,
    String? parentFolderId, {
    String? color,
  }) async {
    final body = {
      'name': name,
      if (parentFolderId != null) 'parentFolderId': parentFolderId,
      if (color != null) 'color': color,
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
  Future<void> uploadFile(String filePath, String? folderId,
      {void Function(int, int)? onProgress}) async {
    try {
      final dio = dio_client.Dio();
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: StorageKeys.accessToken);

      final baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8080';
      final cleanBase = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;
      final url = '$cleanBase/api/my-storage/upload';

      final formData = dio_client.FormData.fromMap({
        'files': await dio_client.MultipartFile.fromFile(filePath),
        if (folderId != null) 'folderId': folderId,
      });

      await dio.post(
        url,
        data: formData,
        options: dio_client.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
        onSendProgress: onProgress,
      );
    } catch (e) {
      if (e is dio_client.DioException) {
        final msg = e.response?.data['message'] ?? e.message;
        throw Exception('Failed to upload file: $msg');
      }
      throw Exception('Failed to upload file: $e');
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

      if (!res.isSuccessful) {
        throw Exception('Failed to download file (${res.statusCode})');
      }

      // Return bodyBytes directly
      return res.bodyBytes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ShareResponseEntity> shareFile(String fileId, String? password) async {
    final body = <String, dynamic>{};
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final Response<ApiResponseModel<ShareResponseModel>> res = await _apiService
        .shareFile(fileId, body);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to share file (${res.statusCode})';
      throw Exception(apiMessage);
    }

    final shareData = res.body?.data;
    if (shareData == null) {
      throw Exception('Share file response missing data');
    }

    return ShareResponseEntity(
      linkToken: shareData.linkToken,
      shareUrl: shareData.shareUrl,
    );
  }

  @override
  Future<ShareResponseEntity> shareFolder(
    String folderId,
    String? password,
  ) async {
    final body = <String, dynamic>{};
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final Response<ApiResponseModel<ShareResponseModel>> res = await _apiService
        .shareFolder(folderId, body);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to share folder (${res.statusCode})';
      throw Exception(apiMessage);
    }

    final shareData = res.body?.data;
    if (shareData == null) {
      throw Exception('Share folder response missing data');
    }

    return ShareResponseEntity(
      linkToken: shareData.linkToken,
      shareUrl: shareData.shareUrl,
    );
  }

  @override
  Future<void> renameFolder(String folderId, String name) async {
    final Response<ApiResponseModel<FolderModel>> res = await _apiService
        .renameFolder(folderId, {'name': name});

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to rename folder (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<void> renameFile(String fileId, String name) async {
    final Response<ApiResponseModel<FileModel>> res = await _apiService
        .renameFile(fileId, {'name': name});

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to rename file (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }
}

final storageDataSourceProvider = Provider<StorageDataSource>((ref) {
  final apiService = ref.read(storageApiServiceProvider);
  return StorageDataSourceImpl(apiService: apiService);
});

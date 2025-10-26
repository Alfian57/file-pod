// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$StorageApiService extends StorageApiService {
  _$StorageApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = StorageApiService;

  @override
  Future<Response<ApiResponseModel<StorageModel>>> getStorage() {
    final Uri $url = Uri.parse('/api/my-storage');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponseModel<StorageModel>, StorageModel>($request);
  }

  @override
  Future<Response<ApiResponseModel<StorageModel>>> getStorageDetail(String id) {
    final Uri $url = Uri.parse('/api/my-storage/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponseModel<StorageModel>, StorageModel>($request);
  }

  @override
  Future<Response<ApiResponseModel<dynamic>>> createFolder(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/my-storage/folder');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponseModel<dynamic>, ApiResponseModel<dynamic>>(
      $request,
    );
  }

  @override
  Future<Response<ApiResponseModel<dynamic>>> deleteFolder(String id) {
    final Uri $url = Uri.parse('/api/my-storage/folder/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<ApiResponseModel<dynamic>, ApiResponseModel<dynamic>>(
      $request,
    );
  }

  @override
  Future<Response<ApiResponseModel<dynamic>>> uploadFile(
    String filePath,
    String? folderId,
  ) {
    final Uri $url = Uri.parse('/api/my-storage/upload');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String?>('folderId', folderId),
      PartValueFile<String>('files', filePath),
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<ApiResponseModel<dynamic>, ApiResponseModel<dynamic>>(
      $request,
    );
  }

  @override
  Future<Response<ApiResponseModel<dynamic>>> deleteFile(String id) {
    final Uri $url = Uri.parse('/api/my-storage/file/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<ApiResponseModel<dynamic>, ApiResponseModel<dynamic>>(
      $request,
    );
  }
}

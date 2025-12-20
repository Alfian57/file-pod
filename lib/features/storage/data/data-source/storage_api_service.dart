import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/features/storage/data/models/file_model.dart';
import 'package:file_pod/features/storage/data/models/folder_model.dart';
import 'package:file_pod/features/storage/data/models/share_response_model.dart';
import 'package:file_pod/features/storage/data/models/storage_model.dart';
import 'package:file_pod/features/storage/data/models/storage_statistics_model.dart';

part 'storage_api_service.chopper.dart';

@ChopperApi(baseUrl: '/api/my-storage')
abstract class StorageApiService extends ChopperService {
  @GET(path: '')
  Future<Response<ApiResponseModel<StorageModel>>> getStorage({
    @Query('sortBy') String? sortBy,
    @Query('sortOrder') String? sortOrder,
    @Query('search') String? search,
    @Query('type') String? type,
  });

  @GET(path: '/{id}')
  Future<Response<ApiResponseModel<StorageModel>>> getStorageDetail(
    @Path('id') String id, {
    @Query('sortBy') String? sortBy,
    @Query('sortOrder') String? sortOrder,
    @Query('search') String? search,
    @Query('type') String? type,
  });

  @GET(path: '/statistics')
  Future<Response<ApiResponseModel<StorageStatisticsModel>>> getStatistics();

  @POST(path: '/folder')
  Future<Response<ApiResponseModel<dynamic>>> createFolder(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(path: '/folder/{id}')
  Future<Response<ApiResponseModel<dynamic>>> deleteFolder(
    @Path('id') String id,
  );

  @POST(path: '/upload')
  @multipart
  Future<Response<ApiResponseModel<dynamic>>> uploadFile(
    @PartFile('files') String filePath,
    @Part('folderId') String? folderId,
  );

  @DELETE(path: '/file/{id}')
  Future<Response<ApiResponseModel<dynamic>>> deleteFile(@Path('id') String id);

  @GET(path: '/file/{id}')
  Future<Response<dynamic>> downloadFile(@Path('id') String id);

  @POST(path: '/file/{id}/share')
  Future<Response<ApiResponseModel<ShareResponseModel>>> shareFile(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/folder/{id}/share')
  Future<Response<ApiResponseModel<ShareResponseModel>>> shareFolder(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: '/folder/{id}/rename')
  Future<Response<ApiResponseModel<FolderModel>>> renameFolder(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH(path: '/file/{id}/rename')
  Future<Response<ApiResponseModel<FileModel>>> renameFile(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  static StorageApiService create([ChopperClient? client]) {
    return _$StorageApiService(client);
  }
}

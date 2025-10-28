import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/features/storage/data/models/storage_model.dart';

part 'storage_api_service.chopper.dart';

@ChopperApi(baseUrl: '/api/my-storage')
abstract class StorageApiService extends ChopperService {
  @GET(path: '')
  Future<Response<ApiResponseModel<StorageModel>>> getStorage();

  @GET(path: '/{id}')
  Future<Response<ApiResponseModel<StorageModel>>> getStorageDetail(
    @Path('id') String id,
  );

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

  static StorageApiService create([ChopperClient? client]) {
    return _$StorageApiService(client);
  }
}

import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/features/auth/data/models/user_model.dart';

part 'profile_api_service.chopper.dart';

@ChopperApi(baseUrl: '/api/auth')
abstract class ProfileApiService extends ChopperService {
  @GET(path: '/user')
  Future<Response<ApiResponseModel<UserModel>>> getCurrentUser();

  @PUT(path: '/profile')
  @multipart
  Future<Response<ApiResponseModel<dynamic>>> updateProfile({
    @Part('name') String? name,
    @PartFile('profilePicture') String? profilePicturePath,
  });

  @PUT(path: '/password')
  Future<Response<ApiResponseModel<dynamic>>> updatePassword(
    @Body() Map<String, dynamic> body,
  );

  static ProfileApiService create([ChopperClient? client]) {
    return _$ProfileApiService(client);
  }
}

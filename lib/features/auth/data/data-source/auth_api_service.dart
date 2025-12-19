import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/features/auth/data/models/login_data_model.dart';
import 'package:file_pod/features/auth/data/models/refresh_token_data_model.dart';
import 'package:file_pod/features/auth/data/models/user_model.dart';

part 'auth_api_service.chopper.dart';

@ChopperApi(baseUrl: '/api/auth')
abstract class AuthApiService extends ChopperService {
  @POST(path: '/login')
  Future<Response<ApiResponseModel<LoginDataModel>>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/register')
  Future<Response<ApiResponseModel<dynamic>>> register(
    @Body() Map<String, dynamic> body,
  );

  @GET(path: '/user')
  Future<Response<ApiResponseModel<UserModel>>> getCurrentUser();

  @POST(path: '/refresh-token')
  Future<Response<ApiResponseModel<RefreshTokenDataModel>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/logout')
  Future<Response<ApiResponseModel<dynamic>>> logout(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/google')
  Future<Response<ApiResponseModel<LoginDataModel>>> loginWithGoogle(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/github')
  Future<Response<ApiResponseModel<LoginDataModel>>> loginWithGitHub(
    @Body() Map<String, dynamic> body,
  );

  static AuthApiService create([ChopperClient? client]) {
    return _$AuthApiService(client);
  }
}


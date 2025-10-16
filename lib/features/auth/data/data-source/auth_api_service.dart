import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/features/auth/data/models/login_data_model.dart';

part 'auth_api_service.chopper.dart';

@ChopperApi(baseUrl: '/api/auth')
abstract class AuthApiService extends ChopperService {
  @POST(path: '/login')
  Future<Response<ApiResponseModel<LoginDataModel>>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/register')
  Future<Response<Map<String, dynamic>>> register(
    @Body() Map<String, dynamic> body,
  );

  static AuthApiService create([ChopperClient? client]) {
    return _$AuthApiService(client);
  }
}

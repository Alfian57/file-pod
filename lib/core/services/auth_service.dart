import 'package:chopper/chopper.dart';

part 'auth_service.chopper.dart';

@ChopperApi(baseUrl: '/api/auth')
abstract class AuthService extends ChopperService {
  @POST(path: '/login')
  Future<Response<Map<String, dynamic>>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST(path: '/register')
  Future<Response<Map<String, dynamic>>> register(
    @Body() Map<String, dynamic> body,
  );

  static AuthService create([ChopperClient? client]) => _$AuthService(client);
}

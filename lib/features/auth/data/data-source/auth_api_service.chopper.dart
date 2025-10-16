// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthApiService extends AuthApiService {
  _$AuthApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthApiService;

  @override
  Future<Response<ApiResponseModel<LoginDataModel>>> login(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/auth/login');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponseModel<LoginDataModel>, LoginDataModel>(
      $request,
    );
  }

  @override
  Future<Response<Map<String, dynamic>>> register(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('/api/auth/register');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Map<String, dynamic>, Map<String, dynamic>>($request);
  }
}

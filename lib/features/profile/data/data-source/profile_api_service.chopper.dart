// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ProfileApiService extends ProfileApiService {
  _$ProfileApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ProfileApiService;

  @override
  Future<Response<ApiResponseModel<UserModel>>> getCurrentUser() {
    final Uri $url = Uri.parse('/api/auth/user');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponseModel<UserModel>, UserModel>($request);
  }

  @override
  Future<Response<ApiResponseModel<dynamic>>> updateProfile({
    String? name,
    String? profilePicturePath,
  }) {
    final Uri $url = Uri.parse('/api/auth/profile');
    final List<PartValue> $parts = <PartValue>[
      PartValue<String?>('name', name),
      PartValueFile<String?>('profilePicture', profilePicturePath),
    ];
    final Request $request = Request(
      'PUT',
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
  Future<Response<ApiResponseModel<dynamic>>> updatePassword(
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('/api/auth/password');
    final $body = body;
    final Request $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<ApiResponseModel<dynamic>, ApiResponseModel<dynamic>>(
      $request,
    );
  }
}

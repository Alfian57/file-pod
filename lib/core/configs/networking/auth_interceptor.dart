import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:file_pod/core/constants/storage_keys.dart';

class AuthInterceptor implements Interceptor {
  AuthInterceptor(this._storage);

  final FlutterSecureStorage _storage;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;

    // Get access token from secure storage
    final accessToken = await _storage.read(key: StorageKeys.accessToken);

    // If token exists, add it to the Authorization header with Bearer prefix
    if (accessToken != null && accessToken.isNotEmpty) {
      final updatedRequest = applyHeader(
        request,
        'Authorization',
        'Bearer $accessToken',
        override: true,
      );
      return chain.proceed(updatedRequest);
    }

    // If no token, proceed with original request
    return chain.proceed(request);
  }
}

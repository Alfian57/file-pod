import 'dart:async';
import 'dart:convert';
import 'package:chopper/chopper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:file_pod/core/constants/storage_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthInterceptor implements Interceptor {
  AuthInterceptor(this._storage);

  final FlutterSecureStorage _storage;

  // Lock to prevent multiple concurrent refresh requests
  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;

    // Skip auth for login, register, and refresh-token endpoints
    final path = request.url.path;
    if (path.endsWith('/login') ||
        path.endsWith('/register') ||
        path.endsWith('/refresh-token')) {
      return chain.proceed(request);
    }

    // Get access token from secure storage
    String? accessToken = await _storage.read(key: StorageKeys.accessToken);

    // If token exists, add it to the Authorization header with Bearer prefix
    if (accessToken != null && accessToken.isNotEmpty) {
      final updatedRequest = applyHeader(
        request,
        'Authorization',
        'Bearer $accessToken',
        override: true,
      );

      final response = await chain.proceed(updatedRequest);

      // If 401 Unauthorized, try to refresh token
      if (response.statusCode == 401) {
        final newAccessToken = await _tryRefreshToken();
        if (newAccessToken != null) {
          // Retry original request with new token
          final retryRequest = applyHeader(
            request,
            'Authorization',
            'Bearer $newAccessToken',
            override: true,
          );
          return chain.proceed(retryRequest);
        }
      }

      return response;
    }

    // If no token, proceed with original request
    return chain.proceed(request);
  }

  Future<String?> _tryRefreshToken() async {
    // If already refreshing, wait for the current refresh to complete
    if (_isRefreshing) {
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
      if (refreshToken == null || refreshToken.isEmpty) {
        _completeRefresh(null);
        return null;
      }

      final baseUrl = (dotenv.env['BASE_URL'] ??
              dotenv.env['VAR_NAME'] ??
              'http://localhost:8080')
          .trim();

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['data']['accessToken'] as String?;
        final newRefreshToken = data['data']['refreshToken'] as String?;

        if (newAccessToken != null && newRefreshToken != null) {
          await _storage.write(
            key: StorageKeys.accessToken,
            value: newAccessToken,
          );
          await _storage.write(
            key: StorageKeys.refreshToken,
            value: newRefreshToken,
          );
          _completeRefresh(newAccessToken);
          return newAccessToken;
        }
      }

      // Refresh failed, clear tokens
      await _clearTokens();
      _completeRefresh(null);
      return null;
    } catch (e) {
      await _clearTokens();
      _completeRefresh(null);
      return null;
    }
  }

  void _completeRefresh(String? token) {
    _isRefreshing = false;
    _refreshCompleter?.complete(token);
    _refreshCompleter = null;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userName);
    await _storage.delete(key: StorageKeys.userEmail);
    await _storage.delete(key: StorageKeys.userProfilePictureUrl);
  }
}

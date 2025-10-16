import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/core/providers/secure_storage_provider.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/core/constants/storage_keys.dart';
import 'package:file_pod/features/auth/data/data-source/auth_api_service.dart';
import 'package:file_pod/core/utils/api_message_extractor.dart';
import 'package:file_pod/features/auth/data/data-source/auth_data_source.dart';
import 'package:file_pod/features/auth/data/models/login_data_model.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({
    required AuthApiService apiService,
    required FlutterSecureStorage storage,
  }) : _apiService = apiService,
       _storage = storage;

  final AuthApiService _apiService;
  final FlutterSecureStorage _storage;

  @override
  Future<UserEntity> getCurrentUser() async {
    // TODO: Implement proper user fetching from API if needed
    return UserEntity(name: 'Guest', email: '');
  }

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    final body = {'email': email, 'password': password};

    final Response<ApiResponseModel<LoginDataModel>> res = await _apiService
        .login(body);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Login failed (${res.statusCode})';
      throw Exception(apiMessage);
    }

    final loginData = res.body?.data;
    if (loginData == null) {
      throw Exception('Login response missing data');
    }
    final accessToken = loginData.accessToken;
    final refreshToken = loginData.refreshToken;
    final user = loginData.user;
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    await _storage.write(key: StorageKeys.userName, value: user.name);
    await _storage.write(key: StorageKeys.userEmail, value: user.email);
    await _storage.write(
      key: StorageKeys.userProfilePictureUrl,
      value: user.profilePictureUrl ?? '',
    );
  }

  @override
  Future<void> register(UserEntity user) async {
    final body = {
      'name': user.name,
      'email': user.email,
      'password': user.password,
    };

    final Response<Map<String, dynamic>> res = await _apiService.register(body);

    if (res.statusCode != 201 && !res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Register failed (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userName);
    await _storage.delete(key: StorageKeys.userEmail);
    await _storage.delete(key: StorageKeys.userProfilePictureUrl);
  }
}

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final apiService = ref.read(authApiServiceProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthDataSourceImpl(apiService: apiService, storage: storage);
});

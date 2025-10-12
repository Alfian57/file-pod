import 'package:chopper/chopper.dart';
import 'package:file_pod/core/providers/secure_storage_provider.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/features/auth/data/data-source/auth_data_source.dart';
import 'package:file_pod/features/auth/data/models/user_model.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl({required this.client, required this.ref});

  final ChopperClient client;
  final Ref ref;
  @override
  Future<UserEntity> getCurrentUser() async {
    // Not defined in Swagger; for now, read minimal data from storage
    final storage = ref.read(secureStorageProvider);
    final email = await storage.read(key: 'user_email');
    final name = await storage.read(key: 'user_name');
    final id = await storage.read(key: 'user_id');
    if (email == null || name == null || id == null) {
      throw Exception('No user');
    }
    return UserModel(id: id, name: name, email: email, password: '');
  }

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    final req = Request(
      'POST',
      Uri.parse('${client.baseUrl}/api/auth/login'),
      client.baseUrl,
      body: {'email': email, 'password': password},
    );
    final Response<Map<String, dynamic>> res = await client
        .send<Map<String, dynamic>, Map<String, dynamic>>(req);
    if (!res.isSuccessful) {
      throw Exception(res.error ?? 'Login failed (${res.statusCode})');
    }
    final body = res.body;
    final data = body?['data'] as Map<String, dynamic>?;
    final token = data?['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Token missing in response');
    }
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: 'auth_token', value: token);
    // Optionally store basic user info if returned by API in future
  }

  @override
  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: 'auth_token');
  }

  @override
  Future<void> register(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    final body = {
      'name': model.name,
      'email': model.email,
      'password': model.password,
    };
    final req = Request(
      'POST',
      Uri.parse('${client.baseUrl}/api/auth/register'),
      client.baseUrl,
      body: body,
    );
    final Response<Map<String, dynamic>> res = await client
        .send<Map<String, dynamic>, Map<String, dynamic>>(req);
    if (res.statusCode != 201 && !res.isSuccessful) {
      throw Exception(res.error ?? 'Register failed (${res.statusCode})');
    }
  }
}

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final client = ref.read(apiProvider);
  return AuthDataSourceImpl(client: client, ref: ref);
});

import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_pod/features/auth/data/data-source/auth_api_service.dart';
import 'package:file_pod/features/storage/data/data-source/storage_api_service.dart';
import 'package:file_pod/core/configs/networking/json_serializable_converter.dart';
import 'package:file_pod/core/configs/networking/auth_interceptor.dart';
import 'package:file_pod/core/providers/secure_storage_provider.dart';

final apiProvider = Provider<ChopperClient>((ref) {
  final storage = ref.read(secureStorageProvider);

  final client = ChopperClient(
    baseUrl: Uri.parse(
      (dotenv.env['BASE_URL'] ??
              dotenv.env['VAR_NAME'] ??
              'http://localhost:8080')
          .trim(),
    ),
    services: [AuthApiService.create(), StorageApiService.create()],
    converter: JsonSerializableConverter(),
    errorConverter: JsonConverter(),
    interceptors: [
      HeadersInterceptor({'Accept': 'application/json'}),
      AuthInterceptor(storage),
      HttpLoggingInterceptor(),
    ],
  );

  return client;
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final client = ref.watch(apiProvider);
  return client.getService<AuthApiService>();
});

final storageApiServiceProvider = Provider<StorageApiService>((ref) {
  final client = ref.watch(apiProvider);
  return client.getService<StorageApiService>();
});

import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_pod/features/auth/data/data-source/auth_api_service.dart';
import 'package:file_pod/core/configs/networking/json_serializable_converter.dart';

final apiProvider = Provider<ChopperClient>((ref) {
  final client = ChopperClient(
    baseUrl: Uri.parse(
      (dotenv.env['BASE_URL'] ??
              dotenv.env['VAR_NAME'] ??
              'http://localhost:8080')
          .trim(),
    ),
    services: [AuthApiService.create()],
    converter: JsonSerializableConverter(),
    errorConverter: JsonConverter(),
    interceptors: [
      HttpLoggingInterceptor(),
      HeadersInterceptor({'Accept': 'application/json'}),
    ],
  );

  return client;
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final client = ref.watch(apiProvider);
  return client.getService<AuthApiService>();
});

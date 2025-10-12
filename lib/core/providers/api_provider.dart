import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<ChopperClient>((ref) {
  final client = ChopperClient(
    baseUrl: Uri.parse(
      (dotenv.env['BASE_URL'] ??
              dotenv.env['VAR_NAME'] ??
              'http://localhost:8080')
          .trim(),
    ),
    services: [
      // ApiService.create(),
    ],
    converter: JsonConverter(),
    errorConverter: JsonConverter(),
    interceptors: [
      HttpLoggingInterceptor(),
      HeadersInterceptor({'Accept': 'application/json'}),
    ],
  );

  return client;
});

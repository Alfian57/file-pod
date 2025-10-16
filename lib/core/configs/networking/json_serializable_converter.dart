import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/features/auth/data/models/login_data_model.dart';
import 'package:file_pod/features/auth/data/models/user_model.dart';

final Map<Type, Function> _jsonFactories = {
  LoginDataModel: (json) => LoginDataModel.fromJson(json),
  UserModel: (json) => UserModel.fromJson(json),
  // Add other model factories here
};

class JsonSerializableConverter extends JsonConverter {
  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    // Avoid using super.decodeJson(response) to prevent FutureOr/type
    // mismatches across Chopper versions. Decode explicitly from
    // response.body which may be a String or already decoded object.
    final dynamic rawBody = response.body;
    dynamic decoded;
    if (rawBody is String) {
      try {
        decoded = jsonDecode(rawBody);
      } catch (_) {
        decoded = rawBody;
      }
    } else {
      decoded = rawBody;
    }

    // Only attempt to decode as ApiResponseModel when the expected
    // compile-time BodyType looks like an ApiResponseModel. This avoids
    // the case where endpoints that return a plain Map (for example
    // register returning {message, data:null}) are erroneously treated
    // as ApiResponseModel and cause cast errors.
    final bodyTypeStr = BodyType.toString();
    final looksLikeApiResponse = bodyTypeStr.contains('ApiResponseModel');

    if (looksLikeApiResponse && decoded is Map<String, dynamic>) {
      if (decoded.containsKey('message') && decoded.containsKey('data')) {
        return _decodeGenericApiResponse<BodyType, InnerType>(
          response,
          decoded,
        );
      }
    }

    final factory = _jsonFactories[InnerType];
    if (factory == null) {
      return response.copyWith<BodyType>(body: decoded as BodyType);
    }

    final converted = factory(decoded) as InnerType;
    return response.copyWith<BodyType>(body: converted as BodyType);
  }

  Response<BodyType> _decodeGenericApiResponse<BodyType, InnerType>(
    Response response,
    Map<String, dynamic> jsonBody,
  ) {
    final innerFactory = _jsonFactories[InnerType];

    final bool dataIsNull = jsonBody['data'] == null;

    if (innerFactory == null) {
      if (!dataIsNull) {
        throw Exception(
          'Factory not found for type $InnerType but response contains non-null data',
        );
      }

      final body = ApiResponseModel.fromJson(jsonBody, (_) => null) as BodyType;
      return response.copyWith<BodyType>(body: body);
    }

    final body =
        ApiResponseModel.fromJson(
              jsonBody,
              (dataJson) => innerFactory(dataJson as Map<String, dynamic>),
            )
            as BodyType;

    return response.copyWith<BodyType>(body: body);
  }
}

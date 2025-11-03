import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/core/utils/api_message_extractor.dart';
import 'package:file_pod/features/auth/data/models/user_model.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/profile/data/data-source/profile_api_service.dart';
import 'package:file_pod/features/profile/data/data-source/profile_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileDataSourceImpl implements ProfileDataSource {
  ProfileDataSourceImpl({required ProfileApiService apiService})
    : _apiService = apiService;

  final ProfileApiService _apiService;

  @override
  Future<UserEntity> getCurrentUser() async {
    final Response<ApiResponseModel<UserModel>> res = await _apiService
        .getCurrentUser();

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to get user profile (${res.statusCode})';
      throw Exception(apiMessage);
    }

    final userData = res.body?.data;
    if (userData == null) {
      throw Exception('User profile response missing data');
    }

    return UserEntity(
      name: userData.name ?? '',
      email: userData.email,
      profilePictureUrl: userData.profilePictureUrl,
      storageQuotaBytes: userData.storageQuotaBytes,
      storageUsedBytes: userData.storageUsedBytes,
    );
  }

  @override
  Future<void> updateProfile(String? name, String? profilePicturePath) async {
    final Response<ApiResponseModel<dynamic>> res = await _apiService
        .updateProfile(name: name, profilePicturePath: profilePicturePath);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to update profile (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }

  @override
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    final body = {'oldPassword': oldPassword, 'newPassword': newPassword};

    final Response<ApiResponseModel<dynamic>> res = await _apiService
        .updatePassword(body);

    if (!res.isSuccessful) {
      final maybeMsgFromBody = extractApiMessage(res.body);
      final apiMessage =
          maybeMsgFromBody ??
          extractApiMessage(res.error) ??
          'Failed to update password (${res.statusCode})';
      throw Exception(apiMessage);
    }
  }
}

final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  final apiService = ref.read(profileApiServiceProvider);
  return ProfileDataSourceImpl(apiService: apiService);
});

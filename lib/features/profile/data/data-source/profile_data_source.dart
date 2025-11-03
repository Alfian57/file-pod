import 'package:file_pod/features/auth/domain/entities/user_entity.dart';

abstract class ProfileDataSource {
  Future<UserEntity> getCurrentUser();
  Future<void> updateProfile(String? name, String? profilePicturePath);
  Future<void> updatePassword(String oldPassword, String newPassword);
}

import 'package:dartz/dartz.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<String, UserEntity>> getCurrentUser();
  Future<Either<String, Unit>> updateProfile(
    String? name,
    String? profilePicturePath,
  );
  Future<Either<String, Unit>> updatePassword(
    String oldPassword,
    String newPassword,
  );
}

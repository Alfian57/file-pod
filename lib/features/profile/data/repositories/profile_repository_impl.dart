import 'package:dartz/dartz.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/profile/data/data-source/profile_data_source.dart';
import 'package:file_pod/features/profile/data/data-source/profile_data_source_impl.dart';
import 'package:file_pod/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.profileDataSource});

  final ProfileDataSource profileDataSource;

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    try {
      final user = await profileDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, Unit>> updateProfile(
    String? name,
    String? profilePicturePath,
  ) async {
    try {
      await profileDataSource.updateProfile(name, profilePicturePath);
      return const Right(unit);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }

  @override
  Future<Either<String, Unit>> updatePassword(
    String oldPassword,
    String newPassword,
  ) async {
    try {
      await profileDataSource.updatePassword(oldPassword, newPassword);
      return const Right(unit);
    } catch (e) {
      final msg = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      return Left(msg);
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final ds = ref.read(profileDataSourceProvider);
  return ProfileRepositoryImpl(profileDataSource: ds);
});

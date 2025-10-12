import 'package:dartz/dartz.dart';
import 'package:file_pod/features/auth/data/data-source/auth_data_source.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/auth/data/data-source/auth_data_source_impl.dart';
import 'package:file_pod/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDataSource});

  final AuthDataSource authDataSource;

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    try {
      final user = await authDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await authDataSource.loginWithEmailAndPassword(email, password);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> logout() async {
    try {
      await authDataSource.logout();
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> register(UserEntity user) async {
    try {
      await authDataSource.register(user);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final ds = ref.read(authDataSourceProvider);
  return AuthRepositoryImpl(authDataSource: ds);
});

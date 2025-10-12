import 'package:dartz/dartz.dart';
import 'package:file_pod/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, Unit>> loginWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<String, Unit>> register(UserEntity user);
  Future<Either<String, Unit>> logout();
  Future<Either<String, UserEntity>> getCurrentUser();
}

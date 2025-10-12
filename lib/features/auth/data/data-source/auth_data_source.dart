import 'package:file_pod/features/auth/domain/entities/user_entity.dart';

abstract class AuthDataSource {
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> register(UserEntity user);
  Future<void> logout();
  Future<UserEntity> getCurrentUser();
}

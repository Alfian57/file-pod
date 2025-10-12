import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/auth/domain/repositories/auth_repository.dart';
import 'package:file_pod/features/auth/data/repositories/auth_repository_impl.dart';

class AuthState {
  const AuthState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthState copyWith({bool? isLoading, String? error}) =>
      AuthState(isLoading: isLoading ?? this.isLoading, error: error);
}

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  Future<Either<String, Unit>> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.loginWithEmailAndPassword(email, password);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((l) => l, (_) => null),
    );
    return res;
  }

  Future<Either<String, Unit>> register(UserEntity user) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.register(user);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((l) => l, (_) => null),
    );
    return res;
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

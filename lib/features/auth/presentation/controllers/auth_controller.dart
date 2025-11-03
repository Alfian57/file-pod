import 'package:file_pod/core/providers/auth_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/auth/domain/repositories/auth_repository.dart';
import 'package:file_pod/features/auth/data/repositories/auth_repository_impl.dart';

class AuthState {
  const AuthState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    final resolvedError = clearError ? null : (error ?? this.error);
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: resolvedError,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.loginWithEmailAndPassword(email, password);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((l) => l, (_) => null),
    );

    // Update auth state after successful login
    res.fold(
      (_) => null,
      (_) => ref.read(authStateProvider.notifier).setAuthenticated(true),
    );
  }

  Future<void> register(UserEntity user) async {
    state = state.copyWith(isLoading: true, error: null);
    final res = await _repo.register(user);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((l) => l, (_) => null),
    );
  }

  Future<void> logout() async {
    await _repo.logout();
    ref.read(authStateProvider.notifier).setAuthenticated(false);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

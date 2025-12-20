import 'package:file_pod/features/auth/domain/entities/user_entity.dart';
import 'package:file_pod/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:file_pod/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileState {
  const ProfileState({
    this.isLoading = false,
    this.error,
    this.user,
    this.successMessage,
  });

  final bool isLoading;
  final String? error;
  final UserEntity? user;
  final String? successMessage;

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    UserEntity? user,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      user: user ?? this.user,
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

class ProfileController extends Notifier<ProfileState> {
  late ProfileRepository _repo;

  @override
  ProfileState build() {
    _repo = ref.watch(profileRepositoryProvider);
    return const ProfileState();
  }

  Future<void> getCurrentUser() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      clearError: true,
      clearSuccess: true,
    );
    final res = await _repo.getCurrentUser();
    state = state.copyWith(
      isLoading: false,
      user: res.fold((_) => null, (user) => user),
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> updateProfile(String? name, String? profilePicturePath) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      clearError: true,
      clearSuccess: true,
    );
    final res = await _repo.updateProfile(name, profilePicturePath);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
      successMessage: res.fold(
        (_) => null,
        (_) => 'Profile updated successfully',
      ),
    );

    // Reload user data after successful update
    if (res.isRight()) {
      await getCurrentUser();
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      clearError: true,
      clearSuccess: true,
    );
    final res = await _repo.updatePassword(oldPassword, newPassword);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
      successMessage: res.fold(
        (_) => null,
        (_) => 'Password updated successfully',
      ),
    );
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);

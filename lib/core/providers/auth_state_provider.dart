import 'package:file_pod/core/constants/storage_keys.dart';
import 'package:file_pod/core/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStateNotifier extends Notifier<AsyncValue<bool>> {
  late final FlutterSecureStorage _storage;

  @override
  AsyncValue<bool> build() {
    _storage = ref.read(secureStorageProvider);
    checkAuthStatus();
    return const AsyncValue.loading();
  }

  Future<void> checkAuthStatus() async {
    state = const AsyncValue.loading();
    try {
      final accessToken = await _storage.read(key: StorageKeys.accessToken);
      final isAuthenticated = accessToken != null && accessToken.isNotEmpty;
      state = AsyncValue.data(isAuthenticated);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void setAuthenticated(bool value) {
    state = AsyncValue.data(value);
  }
}

final authStateProvider = NotifierProvider<AuthStateNotifier, AsyncValue<bool>>(
  AuthStateNotifier.new,
);

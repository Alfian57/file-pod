import 'package:file_pod/features/storage/data/repositories/storage_repository_impl.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';
import 'package:file_pod/features/storage/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageState {
  const StorageState({
    this.isLoading = false,
    this.error,
    this.storage,
    this.storageDetail,
  });

  final bool isLoading;
  final String? error;
  final StorageEntity? storage;
  final StorageEntity? storageDetail;

  StorageState copyWith({
    bool? isLoading,
    String? error,
    StorageEntity? storage,
    StorageEntity? storageDetail,
    bool clearError = false,
  }) {
    final resolvedError = clearError ? null : (error ?? this.error);
    return StorageState(
      isLoading: isLoading ?? this.isLoading,
      error: resolvedError,
      storage: storage ?? this.storage,
      storageDetail: storageDetail ?? this.storageDetail,
    );
  }
}

class StorageController extends Notifier<StorageState> {
  late final StorageRepository _repo;

  @override
  StorageState build() {
    _repo = ref.read(storageRepositoryProvider);
    return const StorageState();
  }

  Future<void> getStorage() async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.getStorage();
    state = state.copyWith(
      isLoading: false,
      storage: res.fold((_) => null, (storage) => storage),
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> getStorageDetail(String folderId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.getStorageDetail(folderId);
    state = state.copyWith(
      isLoading: false,
      storageDetail: res.fold((_) => null, (storage) => storage),
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> createFolder(String name, String? parentFolderId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.createFolder(name, parentFolderId);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> deleteFolder(String folderId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.deleteFolder(folderId);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> uploadFile(String filePath, String? folderId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.uploadFile(filePath, folderId);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> deleteFile(String fileId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.deleteFile(fileId);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
  }
}

final storageControllerProvider =
    NotifierProvider<StorageController, StorageState>(StorageController.new);

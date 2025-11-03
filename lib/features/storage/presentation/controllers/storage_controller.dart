import 'package:file_pod/features/storage/data/repositories/storage_repository_impl.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';
import 'package:file_pod/features/storage/domain/enums/sort_options.dart';
import 'package:file_pod/features/storage/domain/repositories/storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageState {
  const StorageState({
    this.isLoading = false,
    this.error,
    this.storage,
    this.storageDetail,
    this.sortBy = SortBy.createdAt,
    this.sortOrder = SortOrder.asc,
  });

  final bool isLoading;
  final String? error;
  final StorageEntity? storage;
  final StorageEntity? storageDetail;
  final SortBy sortBy;
  final SortOrder sortOrder;

  StorageState copyWith({
    bool? isLoading,
    String? error,
    StorageEntity? storage,
    StorageEntity? storageDetail,
    SortBy? sortBy,
    SortOrder? sortOrder,
    bool clearError = false,
  }) {
    final resolvedError = clearError ? null : (error ?? this.error);
    return StorageState(
      isLoading: isLoading ?? this.isLoading,
      error: resolvedError,
      storage: storage ?? this.storage,
      storageDetail: storageDetail ?? this.storageDetail,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class StorageController extends Notifier<StorageState> {
  late final StorageRepository _repo;

  @override
  StorageState build() {
    // Using watch for dependency injection, which is proper for Riverpod
    _repo = ref.watch(storageRepositoryProvider);
    return const StorageState();
  }

  Future<void> getStorage() async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.getStorage(
      sortBy: state.sortBy.value,
      sortOrder: state.sortOrder.value,
    );
    state = state.copyWith(
      isLoading: false,
      storage: res.fold((_) => null, (storage) => storage),
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> getStorageDetail(String folderId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.getStorageDetail(
      folderId,
      sortBy: state.sortBy.value,
      sortOrder: state.sortOrder.value,
    );
    state = state.copyWith(
      isLoading: false,
      storageDetail: res.fold((_) => null, (storage) => storage),
      error: res.fold((error) => error, (_) => null),
    );
  }

  void setSortBy(SortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void setSortOrder(SortOrder sortOrder) {
    state = state.copyWith(sortOrder: sortOrder);
  }

  void updateSortOptions(SortBy sortBy, SortOrder sortOrder) {
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
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

  Future<List<int>?> downloadFile(String fileId) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.downloadFile(fileId);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
    return res.fold((_) => null, (fileBytes) => fileBytes);
  }
}

final storageControllerProvider =
    NotifierProvider<StorageController, StorageState>(StorageController.new);

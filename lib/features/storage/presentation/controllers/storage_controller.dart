import 'package:file_pod/features/storage/data/repositories/storage_repository_impl.dart';
import 'package:file_pod/features/storage/domain/entities/share_response_entity.dart';
import 'package:file_pod/features/storage/domain/entities/storage_entity.dart';
import 'package:file_pod/features/storage/domain/enums/sort_options.dart';
import 'package:file_pod/features/storage/domain/repositories/storage_repository.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class StorageState {
  const StorageState({
    this.isLoading = false,
    this.error,
    this.storage,
    this.storageDetail,
    this.sortBy = SortBy.createdAt,
    this.sortOrder = SortOrder.asc,
    this.uploadProgress,
    this.isUploading = false,
    this.searchQuery,
    this.filterType,
    this.currentFolderId,
  });

  final bool isLoading;
  final String? error;
  final StorageEntity? storage;
  final StorageEntity? storageDetail;
  final SortBy sortBy;
  final SortOrder sortOrder;
  final double? uploadProgress;
  final bool isUploading;
  final String? searchQuery;
  final String? filterType;
  final String? currentFolderId;

  StorageState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    StorageEntity? storage,
    StorageEntity? storageDetail,
    SortBy? sortBy,
    SortOrder? sortOrder,
    double? uploadProgress,
    bool? isUploading,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? filterType,
    bool clearFilterType = false,
    String? currentFolderId,
    bool clearCurrentFolderId = false,
  }) {
    return StorageState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      storage: storage ?? this.storage,
      storageDetail: storageDetail ?? this.storageDetail,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploading: isUploading ?? this.isUploading,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
      currentFolderId: clearCurrentFolderId ? null : (currentFolderId ?? this.currentFolderId),
    );
  }
}

class StorageController extends Notifier<StorageState> {
  late final StorageRepository _repo;

  @override
  StorageState build() {
    _repo = ref.watch(storageRepositoryProvider);
    return const StorageState();
  }

  Future<void> getStorage() async {
    state = state.copyWith(isLoading: true, error: null, clearError: true, currentFolderId: null);
    // When fetching root, we might want to respect search/filter too
    final res = await _repo.getStorage(
      sortBy: state.sortBy.value,
      sortOrder: state.sortOrder.value,
      search: state.searchQuery,
      type: state.filterType,
    );
    state = state.copyWith(
      isLoading: false,
      storage: res.fold((_) => null, (storage) => storage),
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> getStorageDetail(String folderId) async {
    state = state.copyWith(
      isLoading: true, 
      error: null, 
      clearError: true, 
      currentFolderId: folderId // Track current folder
    );
    final res = await _repo.getStorageDetail(
      folderId,
      sortBy: state.sortBy.value,
      sortOrder: state.sortOrder.value,
      search: state.searchQuery,
      type: state.filterType,
    );
    state = state.copyWith(
      isLoading: false,
      storageDetail: res.fold((_) => null, (storage) => storage),
      error: res.fold((error) => error, (_) => null),
    );
  }

  void setSearchQuery(String query) {
    if (state.searchQuery == query) return;
    state = state.copyWith(
      searchQuery: query,
      clearSearchQuery: query.isEmpty, // Treat empty string as "clear" (null)
    );
    _refreshCurrentView();
  }

  void setFilterType(String? type) {
    if (state.filterType == type) return;
    print('StorageController: Setting filter type to: $type');
    state = state.copyWith(
      filterType: type, 
      clearFilterType: type == null,
    );
    _refreshCurrentView();
  }

  void clearFilters() {
    state = state.copyWith(
      clearSearchQuery: true, 
      clearFilterType: true,
    ); 
    _refreshCurrentView();
  }

  void _refreshCurrentView() {
    if (state.currentFolderId != null) {
      getStorageDetail(state.currentFolderId!);
    } else {
      getStorage();
    }
  }

  void setSortBy(SortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void setSortOrder(SortOrder sortOrder) {
    state = state.copyWith(sortOrder: sortOrder);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void updateSortOptions(SortBy sortBy, SortOrder sortOrder) {
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
  }

  Future<void> createFolder(String name, String? parentFolderId, {String? color}) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.createFolder(name, parentFolderId, color: color);
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
    state = state.copyWith(
      isLoading: true,
      isUploading: true,
      uploadProgress: 0.0,
      error: null,
      clearError: true,
    );
    final res = await _repo.uploadFile(
      filePath,
      folderId,
      onProgress: (sent, total) {
        if (total > 0) {
          state = state.copyWith(
            uploadProgress: sent / total,
            isLoading: true, // Keep loading state true
            isUploading: true,
          );
        }
      },
    );
    state = state.copyWith(
      isLoading: false,
      isUploading: false,
      uploadProgress: null,
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

  Future<ShareResponseEntity?> shareFile(
    String fileId,
    String? password,
  ) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.shareFile(fileId, password);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
    return res.fold((_) => null, (shareResponse) => shareResponse);
  }

  Future<ShareResponseEntity?> shareFolder(
    String folderId,
    String? password,
  ) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.shareFolder(folderId, password);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
    return res.fold((_) => null, (shareResponse) => shareResponse);
  }

  Future<void> renameFolder(String folderId, String name) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.renameFolder(folderId, name);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> renameFile(String fileId, String name) async {
    state = state.copyWith(isLoading: true, error: null, clearError: true);
    final res = await _repo.renameFile(fileId, name);
    state = state.copyWith(
      isLoading: false,
      error: res.fold((error) => error, (_) => null),
    );
  }

  Future<void> exportCurrentView() async {
    // Determine what to export based on current view/state
    final storage = state.storage;
    final detail = state.storageDetail;
    final currentId = state.currentFolderId;

    if (currentId == null && storage == null) return;
    if (currentId != null && detail == null) return;

    final folders = currentId == null ? storage!.folders : detail!.folders;
    final files = currentId == null ? storage!.files : detail!.files;

    final buffer = StringBuffer();
    buffer.writeln('Type,Name,Created At,Size');

    for (final folder in folders) {
      buffer.writeln('Folder,"${folder.name}",${folder.createdAt},');
    }

    for (final file in files) {
      buffer.writeln('File,"${file.originalName}",${file.createdAt},${file.sizeBytes}');
    }

    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/storage_export_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(path);
      await file.writeAsString(buffer.toString());
      
      await Share.shareXFiles([XFile(path)], text: 'Storage Export');
    } catch (e) {
      state = state.copyWith(error: 'Failed to export: $e', clearError: false);
    }
  }
}

final storageControllerProvider =
    NotifierProvider<StorageController, StorageState>(StorageController.new);

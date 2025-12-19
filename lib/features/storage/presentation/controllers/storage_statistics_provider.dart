import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/features/storage/data/data-source/storage_api_service.dart';
import 'package:file_pod/features/storage/data/models/storage_statistics_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageStatisticsNotifier
    extends AutoDisposeAsyncNotifier<StorageStatisticsModel?> {
  late final StorageApiService _apiService;

  @override
  Future<StorageStatisticsModel?> build() async {
    _apiService = ref.read(storageApiServiceProvider);
    return _fetchStatistics();
  }

  Future<StorageStatisticsModel?> _fetchStatistics() async {
    final Response<ApiResponseModel<StorageStatisticsModel>> response =
        await _apiService.getStatistics();

    if (!response.isSuccessful) {
      throw Exception(
        response.error?.toString() ?? 'Failed to fetch statistics',
      );
    }

    return response.body?.data;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStatistics());
  }
}

final storageStatisticsProvider = AsyncNotifierProvider.autoDispose<
    StorageStatisticsNotifier, StorageStatisticsModel?>(
  StorageStatisticsNotifier.new,
);

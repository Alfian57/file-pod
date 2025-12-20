import 'dart:io';
import 'package:chopper/chopper.dart';
import 'package:file_pod/core/models/api_response_model.dart';
import 'package:file_pod/core/providers/api_provider.dart';
import 'package:file_pod/features/storage/data/data-source/storage_api_service.dart';
import 'package:file_pod/features/storage/data/models/storage_statistics_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class StorageStatisticsNotifier
    extends AsyncNotifier<StorageStatisticsModel?> {
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

  Future<void> exportStatistics() async {
    final stats = state.value;
    if (stats == null) return;

    final buffer = StringBuffer();
    buffer.writeln('Category,Size Bytes,Count');
    
    for (final category in stats.categories) {
      buffer.writeln('${category.category},${category.sizeBytes},${category.count ?? 0}');
    }
    
    buffer.writeln('');
    buffer.writeln('Total Storage,${stats.totalBytes},');
    buffer.writeln('Used Storage,${stats.usedBytes},');
    buffer.writeln('Available Storage,${stats.availableBytes},');

    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/storage_statistics.csv';
      final file = File(path);
      await file.writeAsString(buffer.toString());
      
      await Share.shareXFiles([XFile(path)], text: 'Storage Statistics');
    } catch (e) {
      // Handle error gracefully or rethrow?
      // For now just print or ignore
      print('Error exporting statistics: $e');
    }
  }
}

final storageStatisticsProvider = AsyncNotifierProvider.autoDispose<
    StorageStatisticsNotifier, StorageStatisticsModel?>(
  StorageStatisticsNotifier.new,
);

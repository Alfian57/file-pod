import 'package:json_annotation/json_annotation.dart';

part 'storage_statistics_model.g.dart';

@JsonSerializable()
class StorageCategoryModel {
  final String category;
  final String sizeBytes;
  final int count;

  StorageCategoryModel({
    required this.category,
    required this.sizeBytes,
    required this.count,
  });

  factory StorageCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$StorageCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StorageCategoryModelToJson(this);
}

@JsonSerializable()
class StorageStatisticsModel {
  final String totalBytes;
  final String usedBytes;
  final String availableBytes;
  final List<StorageCategoryModel> categories;

  StorageStatisticsModel({
    required this.totalBytes,
    required this.usedBytes,
    required this.availableBytes,
    required this.categories,
  });

  factory StorageStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$StorageStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StorageStatisticsModelToJson(this);
}

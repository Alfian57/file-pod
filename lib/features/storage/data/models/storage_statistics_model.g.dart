// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageCategoryModel _$StorageCategoryModelFromJson(
  Map<String, dynamic> json,
) => StorageCategoryModel(
  category: json['category'] as String,
  sizeBytes: json['sizeBytes'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$StorageCategoryModelToJson(
  StorageCategoryModel instance,
) => <String, dynamic>{
  'category': instance.category,
  'sizeBytes': instance.sizeBytes,
  'count': instance.count,
};

StorageStatisticsModel _$StorageStatisticsModelFromJson(
  Map<String, dynamic> json,
) => StorageStatisticsModel(
  totalBytes: json['totalBytes'] as String,
  usedBytes: json['usedBytes'] as String,
  availableBytes: json['availableBytes'] as String,
  categories: (json['categories'] as List<dynamic>)
      .map((e) => StorageCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StorageStatisticsModelToJson(
  StorageStatisticsModel instance,
) => <String, dynamic>{
  'totalBytes': instance.totalBytes,
  'usedBytes': instance.usedBytes,
  'availableBytes': instance.availableBytes,
  'categories': instance.categories,
};

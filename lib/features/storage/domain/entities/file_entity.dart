import 'package:equatable/equatable.dart';

class FileEntity extends Equatable {
  const FileEntity({
    required this.id,
    required this.originalName,
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    required this.createdAt,
  });

  final String id;
  final String originalName;
  final String filename;
  final String mimeType;
  final String? sizeBytes;
  final String createdAt;

  @override
  List<Object?> get props => [
    id,
    originalName,
    filename,
    mimeType,
    sizeBytes,
    createdAt,
  ];
}

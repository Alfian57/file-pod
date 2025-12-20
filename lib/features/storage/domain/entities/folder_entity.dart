import 'package:equatable/equatable.dart';

class FolderEntity extends Equatable {
  const FolderEntity({
    required this.id,
    required this.name,
    required this.createdAt,
    this.color,
  });

  final String id;
  final String name;
  final String createdAt;
  final String? color;

  @override
  List<Object?> get props => [id, name, createdAt, color];
}

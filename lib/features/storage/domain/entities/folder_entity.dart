import 'package:equatable/equatable.dart';

class FolderEntity extends Equatable {
  const FolderEntity({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String createdAt;

  @override
  List<Object?> get props => [id, name, createdAt];
}

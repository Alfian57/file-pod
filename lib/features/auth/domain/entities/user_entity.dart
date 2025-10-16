import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.name,
    required this.email,
    this.password,
    this.profilePictureUrl,
    this.storageQuotaBytes,
    this.storageUsedBytes,
  });

  final String name;
  final String email;
  final String? password;
  final String? profilePictureUrl;
  final int? storageQuotaBytes;
  final int? storageUsedBytes;

  @override
  List<Object?> get props => [name, email, password];
}

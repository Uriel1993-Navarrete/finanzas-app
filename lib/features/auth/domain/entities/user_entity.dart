import 'package:equatable/equatable.dart';

/// Entidad de Usuario
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime? lastSignIn;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.createdAt,
    this.lastSignIn,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        createdAt,
        lastSignIn,
      ];
}

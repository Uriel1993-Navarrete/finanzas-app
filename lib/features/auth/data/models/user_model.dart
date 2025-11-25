import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

/// Modelo de Usuario para la capa de datos
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.phoneNumber,
    required super.createdAt,
    super.lastSignIn,
  });

  /// Crea un UserModel desde un User de Supabase
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['full_name'] as String? ??
          user.userMetadata?['name'] as String?,
      photoUrl: user.userMetadata?['avatar_url'] as String? ??
          user.userMetadata?['picture'] as String?,
      phoneNumber: user.phone,
      createdAt: DateTime.parse(user.createdAt),
      lastSignIn: user.lastSignInAt != null
          ? DateTime.parse(user.lastSignInAt!)
          : null,
    );
  }

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'created_at': createdAt.toIso8601String(),
      'last_sign_in': lastSignIn?.toIso8601String(),
    };
  }

  /// Crea un UserModel desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      photoUrl: json['photo_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastSignIn: json['last_sign_in'] != null
          ? DateTime.parse(json['last_sign_in'] as String)
          : null,
    );
  }
}

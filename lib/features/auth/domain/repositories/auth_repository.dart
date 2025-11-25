import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Repositorio de autenticación
abstract class AuthRepository {
  /// Obtiene el usuario actual
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Inicia sesión con Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Inicia sesión con email y contraseña
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Registra un nuevo usuario con email y contraseña
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Cierra sesión
  Future<Either<Failure, void>> signOut();

  /// Restablece la contraseña
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Escucha cambios en el estado de autenticación
  Stream<UserEntity?> get authStateChanges;
}

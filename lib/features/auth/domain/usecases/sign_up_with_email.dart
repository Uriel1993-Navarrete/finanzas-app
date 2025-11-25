import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para registrarse con email
class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    String? displayName,
  }) async {
    return await repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}

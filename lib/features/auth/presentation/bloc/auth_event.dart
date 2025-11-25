part of 'auth_bloc.dart';

/// Eventos de autenticación
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Verificar estado de autenticación
class AuthCheckRequested extends AuthEvent {}

/// Iniciar sesión con email
class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Iniciar sesión con Google
class AuthSignInWithGoogleRequested extends AuthEvent {}

/// Registrarse
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Cerrar sesión
class AuthSignOutRequested extends AuthEvent {}

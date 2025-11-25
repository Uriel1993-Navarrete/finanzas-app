part of 'auth_bloc.dart';

/// Estados de autenticación
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuthInitial extends AuthState {}

/// Cargando
class AuthLoading extends AuthState {}

/// Autenticado
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// No autenticado
class AuthUnauthenticated extends AuthState {}

/// Error
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

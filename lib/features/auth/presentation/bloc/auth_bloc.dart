import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utils/logger.dart';
import '../../../categories/domain/usecases/initialize_default_categories.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_email.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_with_email.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc de autenticación
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser getCurrentUser;
  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;
  final InitializeDefaultCategories initializeDefaultCategories;

  AuthBloc({
    required this.getCurrentUser,
    required this.signInWithEmail,
    required this.signInWithGoogle,
    required this.signUpWithEmail,
    required this.signOut,
    required this.initializeDefaultCategories,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmailRequested);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogleRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentUser();
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (user) => user != null
          ? emit(AuthAuthenticated(user: user))
          : emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onSignInWithEmailRequested(
    AuthSignInWithEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Iniciando sesión con email', tag: 'AUTH', data: {
      'email': event.email,
    });
    emit(AuthLoading());
    final result = await signInWithEmail(
      email: event.email,
      password: event.password,
    );
    await result.fold(
      (failure) async {
        AppLogger.error('Error al iniciar sesión con email', tag: 'AUTH', data: {
          'email': event.email,
          'failureType': failure.runtimeType.toString(),
          'failureMessage': failure.message,
        });
        emit(AuthError(message: failure.message));
      },
      (user) async {
        AppLogger.info('Inicio de sesión con email exitoso', tag: 'AUTH', data: {
          'userId': user.id,
          'email': user.email,
        });

        // Inicializar categorías predeterminadas si el usuario no tiene
        AppLogger.debug('Inicializando categorías predeterminadas si es necesario', tag: 'AUTH');
        await initializeDefaultCategories(user.id);

        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onSignInWithGoogleRequested(
    AuthSignInWithGoogleRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.info('Registrando nuevo usuario con email', tag: 'AUTH', data: {
      'email': event.email,
      'hasDisplayName': event.displayName != null,
    });
    emit(AuthLoading());
    final result = await signUpWithEmail(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    );
    await result.fold(
      (failure) async {
        AppLogger.error('Error al registrar usuario', tag: 'AUTH', data: {
          'email': event.email,
          'failureType': failure.runtimeType.toString(),
          'failureMessage': failure.message,
        });
        emit(AuthError(message: failure.message));
      },
      (user) async {
        AppLogger.info('Registro exitoso', tag: 'AUTH', data: {
          'userId': user.id,
          'email': user.email,
        });

        // Inicializar categorías predeterminadas para el nuevo usuario
        AppLogger.info('Inicializando categorías predeterminadas para nuevo usuario', tag: 'AUTH');
        await initializeDefaultCategories(user.id);

        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOut();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}

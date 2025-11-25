import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/logger.dart';
import '../models/user_model.dart';

/// Data Source remoto de autenticación
abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });
  Future<void> signOut();
  Future<void> resetPassword({required String email});
  Stream<UserModel?> get authStateChanges;
}

/// Implementación del Data Source remoto con Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.supabaseClient,
    required this.googleSignIn,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabaseUser(user);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    AppLogger.info('Iniciando proceso de login con Google', tag: 'AUTH');

    try {
      // Iniciar sesión con Google
      AppLogger.debug('Llamando a googleSignIn.signIn()', tag: 'AUTH');
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        AppLogger.warning('Usuario canceló el login con Google', tag: 'AUTH');
        throw Exception('Inicio de sesión cancelado');
      }

      AppLogger.info('Usuario de Google obtenido: ${googleUser.email}', tag: 'AUTH');

      AppLogger.debug('Obteniendo tokens de autenticación de Google', tag: 'AUTH');
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      AppLogger.debug(
        'Tokens obtenidos',
        tag: 'AUTH',
        data: {
          'hasAccessToken': accessToken != null,
          'hasIdToken': idToken != null,
          'accessTokenLength': accessToken?.length ?? 0,
          'idTokenLength': idToken?.length ?? 0,
        },
      );

      if (accessToken == null) {
        AppLogger.error('No se pudo obtener el token de acceso', tag: 'AUTH');
        throw Exception('No se pudo obtener el token de acceso');
      }
      if (idToken == null) {
        AppLogger.error('No se pudo obtener el ID token', tag: 'AUTH');
        throw Exception('No se pudo obtener el ID token');
      }

      // Autenticar con Supabase usando el token de Google
      AppLogger.info('Autenticando con Supabase usando tokens de Google', tag: 'AUTH');
      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        AppLogger.error('Supabase no devolvió un usuario', tag: 'AUTH');
        throw Exception('Error al autenticar con Supabase');
      }

      AppLogger.info(
        'Login con Google exitoso',
        tag: 'AUTH',
        data: {
          'userId': response.user!.id,
          'email': response.user!.email,
        },
      );

      return UserModel.fromSupabaseUser(response.user!);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al iniciar sesión con Google',
        tag: 'AUTH',
        error: e,
        stackTrace: stackTrace,
        data: {
          'errorType': e.runtimeType.toString(),
          'errorMessage': e.toString(),
        },
      );
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    AppLogger.info('Iniciando proceso de login con email', tag: 'AUTH', data: {
      'email': email,
    });

    try {
      AppLogger.debug('Llamando a supabaseClient.auth.signInWithPassword', tag: 'AUTH');
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      AppLogger.debug('Respuesta de Supabase recibida', tag: 'AUTH', data: {
        'hasUser': response.user != null,
        'hasSession': response.session != null,
      });

      if (response.user == null) {
        AppLogger.error('Supabase no devolvió un usuario', tag: 'AUTH');
        throw Exception('Error al iniciar sesión');
      }

      AppLogger.info('Login con email exitoso', tag: 'AUTH', data: {
        'userId': response.user!.id,
        'email': response.user!.email,
      });

      return UserModel.fromSupabaseUser(response.user!);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al iniciar sesión con email',
        tag: 'AUTH',
        error: e,
        stackTrace: stackTrace,
        data: {
          'errorType': e.runtimeType.toString(),
          'errorMessage': e.toString(),
          'email': email,
        },
      );

      // Detectar si el error es por credenciales inválidas (posiblemente email no confirmado)
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('invalid') && errorMessage.contains('credentials')) {
        throw Exception(
          'Credenciales inválidas. Si acabas de registrarte, verifica que hayas confirmado tu email. '
          'Revisa tu bandeja de entrada o spam.'
        );
      }

      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    AppLogger.info('Iniciando proceso de registro con email', tag: 'AUTH', data: {
      'email': email,
      'hasDisplayName': displayName != null,
    });

    try {
      AppLogger.debug('Llamando a supabaseClient.auth.signUp', tag: 'AUTH');
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'full_name': displayName} : null,
      );

      AppLogger.debug('Respuesta de registro recibida', tag: 'AUTH', data: {
        'hasUser': response.user != null,
        'hasSession': response.session != null,
      });

      if (response.user == null) {
        AppLogger.error('Supabase no devolvió un usuario al registrarse', tag: 'AUTH');
        throw Exception('Error al registrarse');
      }

      AppLogger.info('Registro con email exitoso', tag: 'AUTH', data: {
        'userId': response.user!.id,
        'email': response.user!.email,
        'emailConfirmedAt': response.user!.emailConfirmedAt ?? 'no confirmado',
      });

      // Log adicional si el email no está confirmado
      if (response.user!.emailConfirmedAt == null) {
        AppLogger.warning(
          'Email no confirmado - el usuario necesitará confirmar su email para poder iniciar sesión',
          tag: 'AUTH',
          data: {'email': email},
        );
      }

      return UserModel.fromSupabaseUser(response.user!);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al registrarse con email',
        tag: 'AUTH',
        error: e,
        stackTrace: stackTrace,
        data: {
          'errorType': e.runtimeType.toString(),
          'errorMessage': e.toString(),
          'email': email,
        },
      );
      throw Exception('Error al registrarse: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Google si está autenticado
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      // Cerrar sesión en Supabase
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Error al restablecer contraseña: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return supabaseClient.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user);
    });
  }
}

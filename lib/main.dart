import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'core/config/app_config.dart';
import 'core/config/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/transactions/presentation/bloc/transaction_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar logger
  await AppLogger().init();
  AppLogger.info('Aplicación iniciada', tag: 'MAIN');

  try {
    // Inicializar Supabase
    AppLogger.info('Inicializando Supabase...', tag: 'MAIN');
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    AppLogger.info('Supabase inicializado correctamente', tag: 'MAIN');

    // Inicializar inyección de dependencias
    AppLogger.info('Inicializando dependencias...', tag: 'MAIN');
    await initializeDependencies();
    AppLogger.info('Dependencias inicializadas', tag: 'MAIN');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Error durante la inicialización',
      tag: 'MAIN',
      error: e,
      stackTrace: stackTrace,
    );
  }

  runApp(const FinanzasApp());
}

class FinanzasApp extends StatelessWidget {
  const FinanzasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => sl<TransactionBloc>(),
        ),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Wrapper que maneja el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashPage();
        }

        if (state is AuthAuthenticated) {
          return const DashboardPage();
        }

        // AuthUnauthenticated o AuthError
        return const LoginPage();
      },
    );
  }
}

/// Página de splash
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                size: 120,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                AppConfig.appName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Administra tus finanzas personales',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Versión ${AppConfig.version}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

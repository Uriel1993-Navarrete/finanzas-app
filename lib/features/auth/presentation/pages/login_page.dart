import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_text_field.dart';
import 'signup_page.dart';

/// Pantalla de inicio de sesión
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmail() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthSignInWithEmailRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _signInWithGoogle() {
    context.read<AuthBloc>().add(AuthSignInWithGoogleRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo y título
                  const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Finanzas App',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Administra tus finanzas personales',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 48),

                  // Título del formulario
                  Text(
                    'Iniciar Sesión',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),

                  // Formulario
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          label: 'Correo electrónico',
                          hint: 'tu@email.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          enabled: !isLoading,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo';
                            }
                            if (!value.contains('@')) {
                              return 'Ingresa un correo válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Contraseña',
                          hint: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outline,
                          enabled: !isLoading,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón de inicio de sesión con email
                  AuthButton(
                    text: 'Iniciar Sesión',
                    onPressed: isLoading ? null : _signInWithEmail,
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 24),

                  // Google Sign In - Comentado temporalmente hasta configurar Google Cloud Console
                  // Divisor
                  // Row(
                  //   children: [
                  //     const Expanded(child: Divider()),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'O continúa con',
                  //         style: Theme.of(context).textTheme.bodySmall,
                  //       ),
                  //     ),
                  //     const Expanded(child: Divider()),
                  //   ],
                  // ),

                  // const SizedBox(height: 24),

                  // Botón de Google
                  // AuthButton(
                  //   text: 'Continuar con Google',
                  //   onPressed: isLoading ? null : _signInWithGoogle,
                  //   isLoading: false,
                  //   icon: Icons.g_mobiledata,
                  //   backgroundColor: Colors.white,
                  //   textColor: AppColors.textPrimary,
                  //   hasBorder: true,
                  // ),

                  // const SizedBox(height: 24),

                  // Link a registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpPage(),
                                  ),
                                );
                              },
                        child: const Text('Regístrate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación
class AppColors {
  // Colores principales
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00D9A5);
  static const Color accent = Color(0xFFFF6584);

  // Colores de estado
  static const Color success = Color(0xFF00D9A5);
  static const Color error = Color(0xFFFF6584);
  static const Color warning = Color(0xFFFFB84D);
  static const Color info = Color(0xFF4D9FFF);

  // Colores de tipo de transacción
  static const Color income = Color(0xFF00D9A5);
  static const Color expense = Color(0xFFFF6584);
  static const Color savings = Color(0xFF6C63FF);

  // Colores de fondo
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);

  // Colores de texto
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textDisabled = Color(0xFFADB5BD);

  // Colores de bordes
  static const Color border = Color(0xFFDEE2E6);
  static const Color divider = Color(0xFFE9ECEF);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00D9A5), Color(0xFF00C996)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF6584), Color(0xFFFF4D6D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

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

  // Paleta de colores para categorías personalizadas
  /// Colores disponibles para que los usuarios elijan al crear/editar categorías
  static const List<Color> categoryColorPalette = [
    // Rojos y rosas
    Color(0xFFE63946), // Rojo fuerte
    Color(0xFFFF6B9D), // Rosa chicle
    Color(0xFFFE4164), // Rosa coral
    Color(0xFFFF6584), // Rosa salmón (expense)
    Color(0xFFFF1744), // Rojo material

    // Naranjas
    Color(0xFFFF9770), // Naranja pastel
    Color(0xFFFF8C42), // Naranja vivo
    Color(0xFFFFB84D), // Naranja dorado (warning)
    Color(0xFFFF6F00), // Naranja oscuro
    Color(0xFFFF9100), // Naranja material

    // Amarillos
    Color(0xFFFFC857), // Amarillo brillante
    Color(0xFFFFEB3B), // Amarillo material
    Color(0xFFFDD835), // Amarillo limón
    Color(0xFFFFD700), // Dorado

    // Verdes
    Color(0xFF00D9A5), // Verde menta (income/success)
    Color(0xFF4CAF50), // Verde material
    Color(0xFF00C853), // Verde brillante
    Color(0xFF69F0AE), // Verde claro
    Color(0xFF26A69A), // Verde azulado
    Color(0xFF66BB6A), // Verde pasto

    // Azules
    Color(0xFF6C63FF), // Azul purpura (primary)
    Color(0xFF4D9FFF), // Azul cielo (info)
    Color(0xFF2196F3), // Azul material
    Color(0xFF03A9F4), // Azul claro
    Color(0xFF00BCD4), // Cian
    Color(0xFF40C4FF), // Azul celeste
    Color(0xFF1E88E5), // Azul royal

    // Púrpuras y violetas
    Color(0xFF9C27B0), // Púrpura material
    Color(0xFFAB47BC), // Púrpura claro
    Color(0xFF7B1FA2), // Púrpura oscuro
    Color(0xFFE040FB), // Púrpura brillante
    Color(0xFFBA68C8), // Lavanda

    // Marrones y tierras
    Color(0xFF8D6E63), // Marrón material
    Color(0xFFA1887F), // Marrón claro
    Color(0xFF6D4C41), // Marrón chocolate
    Color(0xFFD7CCC8), // Beige

    // Grises
    Color(0xFF78909C), // Gris azulado
    Color(0xFF90A4AE), // Gris claro
    Color(0xFF607D8B), // Gris material
    Color(0xFF546E7A), // Gris oscuro

    // Colores especiales
    Color(0xFFEC407A), // Rosa fuerte
    Color(0xFFAB47BC), // Púrpura vibrante
    Color(0xFF5C6BC0), // Índigo
    Color(0xFF26C6DA), // Cian claro
    Color(0xFF66BB6A), // Verde lima
    Color(0xFFD4E157), // Lima amarillo
    Color(0xFFFFCA28), // Ámbar
    Color(0xFFFF7043), // Naranja profundo
  ];

  /// Obtiene un color de la paleta por índice
  /// Si el índice está fuera de rango, retorna el color primario
  static Color getCategoryColor(int index) {
    if (index < 0 || index >= categoryColorPalette.length) {
      return primary;
    }
    return categoryColorPalette[index];
  }

  /// Busca el índice de un color en la paleta
  /// Retorna -1 si el color no está en la paleta
  static int findColorIndex(Color color) {
    return categoryColorPalette.indexOf(color);
  }

  /// Convierte un valor hexadecimal a Color
  /// Útil para guardar/recuperar colores de la base de datos
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convierte un Color a valor hexadecimal
  /// Útil para guardar colores en la base de datos
  static String toHex(Color color) {
    // Usar alpha, red, green, blue en lugar de .value (deprecado)
    final int value = (color.a.toInt() << 24) |
        (color.r.toInt() << 16) |
        (color.g.toInt() << 8) |
        color.b.toInt();
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

import 'package:intl/intl.dart';

/// Utilidades de formateo
class Formatters {
  /// Formatea un número como moneda
  static String currency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(
      locale: 'es_MX',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Formatea una fecha
  static String date(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(format, 'es_MX');
    return formatter.format(date);
  }

  /// Formatea una fecha con hora
  static String dateTime(DateTime date, {String format = 'dd/MM/yyyy HH:mm'}) {
    final formatter = DateFormat(format, 'es_MX');
    return formatter.format(date);
  }

  /// Formatea una fecha en formato relativo (Hoy, Ayer, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);

    if (dateDay == today) {
      return 'Hoy';
    } else if (dateDay == yesterday) {
      return 'Ayer';
    } else if (dateDay.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE', 'es_MX').format(date);
    } else {
      return DateFormat('dd/MM/yyyy', 'es_MX').format(date);
    }
  }

  /// Formatea un porcentaje
  static String percentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Formatea un número con separadores de miles
  static String number(double value, {int decimals = 0}) {
    final formatter = NumberFormat('#,##0.${'0' * decimals}', 'es_MX');
    return formatter.format(value);
  }

  /// Formatea una moneda de forma compacta (K, M, B)
  /// Ej: 1,234 → $1.2K, 1,234,567 → $1.2M
  static String compactCurrency(double amount, {String symbol = '\$'}) {
    if (amount.abs() < 1000) {
      return currency(amount, symbol: symbol);
    }

    final absAmount = amount.abs();
    String suffix;
    double divisor;

    if (absAmount >= 1000000000) {
      suffix = 'B';
      divisor = 1000000000;
    } else if (absAmount >= 1000000) {
      suffix = 'M';
      divisor = 1000000;
    } else {
      suffix = 'K';
      divisor = 1000;
    }

    final compact = amount / divisor;
    return '$symbol${compact.toStringAsFixed(1)}$suffix';
  }
}

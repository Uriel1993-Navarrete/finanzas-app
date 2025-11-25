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
}

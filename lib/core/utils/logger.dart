import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// Sistema de logging para capturar errores y eventos
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  static final List<LogEntry> _logs = [];
  static const int _maxLogs = 1000;
  File? _logFile;

  /// Inicializa el logger
  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _logFile = File('${directory.path}/app_logs.txt');

      // Limpiar logs antiguos si el archivo es muy grande
      if (await _logFile!.exists()) {
        final size = await _logFile!.length();
        if (size > 1024 * 1024) { // 1 MB
          await _logFile!.delete();
        }
      }
    } catch (e) {
      print('Error inicializando logger: $e');
    }
  }

  /// Registra un log de información
  static void info(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  /// Registra un log de advertencia
  static void warning(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  /// Registra un log de error
  static void error(String message, {String? tag, dynamic error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );
  }

  /// Registra un log de depuración
  static void debug(String message, {String? tag, Map<String, dynamic>? data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? data,
  }) {
    final entry = LogEntry(
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
      timestamp: DateTime.now(),
    );

    // Agregar a la lista en memoria
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }

    // Imprimir en consola
    print(entry.toString());

    // Guardar en archivo
    _instance._writeToFile(entry);
  }

  Future<void> _writeToFile(LogEntry entry) async {
    try {
      if (_logFile != null) {
        await _logFile!.writeAsString(
          '${entry.toString()}\n',
          mode: FileMode.append,
        );
      }
    } catch (e) {
      print('Error escribiendo log: $e');
    }
  }

  /// Obtiene todos los logs en memoria
  static List<LogEntry> getLogs() {
    return List.unmodifiable(_logs);
  }

  /// Obtiene logs por nivel
  static List<LogEntry> getLogsByLevel(LogLevel level) {
    return _logs.where((log) => log.level == level).toList();
  }

  /// Obtiene logs por tag
  static List<LogEntry> getLogsByTag(String tag) {
    return _logs.where((log) => log.tag == tag).toList();
  }

  /// Limpia todos los logs
  static Future<void> clearLogs() async {
    _logs.clear();
    try {
      if (_instance._logFile != null && await _instance._logFile!.exists()) {
        await _instance._logFile!.delete();
      }
    } catch (e) {
      print('Error limpiando logs: $e');
    }
  }

  /// Obtiene la ruta del archivo de logs
  static Future<String?> getLogFilePath() async {
    return _instance._logFile?.path;
  }

  /// Exporta los logs como texto
  static String exportLogsAsText() {
    final buffer = StringBuffer();
    buffer.writeln('=== LOGS DE LA APLICACIÓN ===');
    buffer.writeln('Generado: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}');
    buffer.writeln('Total de logs: ${_logs.length}');
    buffer.writeln('');

    for (final log in _logs) {
      buffer.writeln(log.toString());
      buffer.writeln('---');
    }

    return buffer.toString();
  }
}

/// Niveles de log
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Entrada de log
class LogEntry {
  final LogLevel level;
  final String message;
  final String? tag;
  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  LogEntry({
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    this.data,
    required this.timestamp,
  });

  String get levelString {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    final timeStr = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(timestamp);

    buffer.write('[$timeStr] [$levelString]');
    if (tag != null) {
      buffer.write(' [$tag]');
    }
    buffer.write(': $message');

    if (data != null && data!.isNotEmpty) {
      buffer.write('\n  Data: $data');
    }

    if (error != null) {
      buffer.write('\n  Error: $error');
    }

    if (stackTrace != null) {
      buffer.write('\n  Stack trace:\n$stackTrace');
    }

    return buffer.toString();
  }
}

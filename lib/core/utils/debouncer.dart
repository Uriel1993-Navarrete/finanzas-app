import 'dart:async';
import 'package:flutter/foundation.dart';

/// Clase helper para implementar debouncing
/// Útil para búsquedas en tiempo real, evitando múltiples llamadas innecesarias
///
/// Ejemplo de uso:
/// ```dart
/// final debouncer = Debouncer(duration: Duration(milliseconds: 500));
///
/// TextField(
///   onChanged: (value) {
///     debouncer.run(() {
///       // Realizar búsqueda con el valor
///       searchCategories(value);
///     });
///   },
/// )
/// ```
class Debouncer {
  /// Duración del retraso antes de ejecutar la acción
  final Duration duration;

  /// Timer interno para controlar el debounce
  Timer? _timer;

  /// Constructor del Debouncer
  /// [duration] - Tiempo de espera antes de ejecutar la acción (default: 300ms)
  Debouncer({
    this.duration = const Duration(milliseconds: 300),
  });

  /// Ejecuta la acción después del tiempo de debounce
  /// Si se llama múltiples veces, cancela las ejecuciones anteriores
  /// y reinicia el timer
  void run(VoidCallback action) {
    // Cancelar el timer anterior si existe
    _timer?.cancel();

    // Crear nuevo timer
    _timer = Timer(duration, action);
  }

  /// Cancela cualquier acción pendiente
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Libera los recursos del debouncer
  /// Debe llamarse cuando ya no se necesite el debouncer
  void dispose() {
    cancel();
  }

  /// Verifica si hay una acción pendiente
  bool get isActive => _timer?.isActive ?? false;
}

/// Versión del Debouncer que acepta funciones con parámetros
/// Útil cuando necesitas pasar argumentos a la función debounced
///
/// Ejemplo de uso:
/// ```dart
/// final debouncer = DebouncerWithParam<String>(
///   duration: Duration(milliseconds: 500),
/// );
///
/// TextField(
///   onChanged: (value) {
///     debouncer.run(value, (query) {
///       searchCategories(query);
///     });
///   },
/// )
/// ```
class DebouncerWithParam<T> {
  /// Duración del retraso antes de ejecutar la acción
  final Duration duration;

  /// Timer interno para controlar el debounce
  Timer? _timer;

  /// Constructor del DebouncerWithParam
  /// [duration] - Tiempo de espera antes de ejecutar la acción (default: 300ms)
  DebouncerWithParam({
    this.duration = const Duration(milliseconds: 300),
  });

  /// Ejecuta la acción con el parámetro después del tiempo de debounce
  /// Si se llama múltiples veces, cancela las ejecuciones anteriores
  /// y reinicia el timer con el nuevo parámetro
  void run(T parameter, ValueChanged<T> action) {
    // Cancelar el timer anterior si existe
    _timer?.cancel();

    // Crear nuevo timer
    _timer = Timer(duration, () => action(parameter));
  }

  /// Cancela cualquier acción pendiente
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Libera los recursos del debouncer
  /// Debe llamarse cuando ya no se necesite el debouncer
  void dispose() {
    cancel();
  }

  /// Verifica si hay una acción pendiente
  bool get isActive => _timer?.isActive ?? false;
}

/// Throttler - Similar al debouncer pero ejecuta la acción inmediatamente
/// y luego ignora las llamadas subsecuentes durante el período de throttle
///
/// Útil para limitar la frecuencia de ejecución de acciones como scroll events
///
/// Ejemplo de uso:
/// ```dart
/// final throttler = Throttler(duration: Duration(milliseconds: 1000));
///
/// ScrollController(
///   onScroll: () {
///     throttler.run(() {
///       print('Scroll position: ${controller.offset}');
///     });
///   },
/// )
/// ```
class Throttler {
  /// Duración del período de throttle
  final Duration duration;

  /// Timestamp de la última ejecución
  DateTime? _lastExecutionTime;

  /// Constructor del Throttler
  /// [duration] - Tiempo mínimo entre ejecuciones (default: 1000ms)
  Throttler({
    this.duration = const Duration(milliseconds: 1000),
  });

  /// Ejecuta la acción si ha pasado suficiente tiempo desde la última ejecución
  /// Si no ha pasado el tiempo necesario, ignora la llamada
  void run(VoidCallback action) {
    final now = DateTime.now();

    // Si es la primera ejecución o ha pasado el tiempo de throttle
    if (_lastExecutionTime == null ||
        now.difference(_lastExecutionTime!) >= duration) {
      _lastExecutionTime = now;
      action();
    }
  }

  /// Reinicia el throttler
  void reset() {
    _lastExecutionTime = null;
  }

  /// Verifica si el throttler está en período de espera
  bool get isThrottled {
    if (_lastExecutionTime == null) return false;
    final now = DateTime.now();
    return now.difference(_lastExecutionTime!) < duration;
  }
}

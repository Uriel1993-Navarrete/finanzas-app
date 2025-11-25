/// Excepciones de la aplicación

/// Excepción del servidor
class ServerException implements Exception {
  final String message;

  const ServerException({required this.message});

  @override
  String toString() => message;
}

/// Excepción de caché
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => message;
}

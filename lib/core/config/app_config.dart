/// Configuración global de la aplicación
class AppConfig {
  // Nombre de la aplicación
  static const String appName = 'Finanzas App';

  // Versión
  static const String version = '1.0.0';

  // URLs de Supabase (DEBES REEMPLAZAR CON TUS PROPIOS VALORES)
  static const String supabaseUrl = 'https://xnutivkahzjjoybkkizh.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhudXRpdmthaHpqam95YmtraXpoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5MDgyNzEsImV4cCI6MjA3OTQ4NDI3MX0.rBOmCtjDnxdte6fYBrYQugRhJcU4lpf8T-mBwsryHwM';

  // Formato de moneda
  static const String currencySymbol = '\$';
  static const String locale = 'es_MX';

  // Configuración de paginación
  static const int itemsPerPage = 20;

  // Configuración de caché
  static const Duration cacheExpiration = Duration(hours: 1);
}

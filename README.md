# Finanzas App - Aplicación de Finanzas Personales

Una aplicación multiplataforma desarrollada en Flutter para la gestión completa de finanzas personales, con soporte para ingresos, egresos, planes de ahorro, presupuestos y análisis financiero.

## Características principales

- ✅ **Autenticación**: Login con Google y Facebook
- ✅ **Dashboard**: Vista general de tu situación financiera
- ✅ **Transacciones**: Registro de ingresos y egresos con categorías y subcategorías
- ✅ **Categorización**: Sistema jerárquico de categorías personalizables
- ✅ **Planes de Ahorro**: Crea y sigue el progreso de tus metas de ahorro
- ✅ **Presupuestos**: Define límites de gasto y recibe alertas
- ✅ **Análisis Visual**: Gráficos y reportes detallados
- ✅ **Exportación**: Exporta tus datos a PDF y Excel
- ✅ **Multiplataforma**: Android, iOS, Web y Windows

## Tecnologías utilizadas

### Framework y lenguaje
- **Flutter 3.38.3** - Framework multiplataforma
- **Dart 3.10+** - Lenguaje de programación

### Arquitectura
- **Clean Architecture** - Separación en capas (Domain, Data, Presentation)
- **Bloc/Cubit** - Gestión de estado
- **GetIt** - Inyección de dependencias

### Backend y Base de Datos
- **Supabase** - Backend as a Service
  - PostgreSQL - Base de datos relacional
  - Auth - Autenticación y autorización
  - Storage - Almacenamiento de archivos
  - Row Level Security (RLS) - Seguridad a nivel de fila

### Librerías principales
- `flutter_bloc` - Gestión de estado
- `supabase_flutter` - Cliente de Supabase
- `google_sign_in` - Autenticación con Google
- `fl_chart` - Gráficos y visualizaciones
- `pdf` & `printing` - Exportación a PDF
- `syncfusion_flutter_xlsio` - Exportación a Excel
- `google_fonts` - Fuentes personalizadas
- `intl` - Internacionalización y formateo

## Estructura del proyecto

```
lib/
├── core/                          # Núcleo de la aplicación
│   ├── config/                    # Configuraciones (Supabase, DI)
│   ├── constants/                 # Constantes (colores, etc.)
│   ├── theme/                     # Tema de la aplicación
│   ├── utils/                     # Utilidades (formatters, etc.)
│   └── errors/                    # Manejo de errores
│
├── features/                      # Características/Módulos
│   ├── auth/                      # Autenticación
│   │   ├── data/                  # Capa de datos
│   │   │   ├── datasources/       # Fuentes de datos (API, local)
│   │   │   ├── models/            # Modelos de datos
│   │   │   └── repositories/      # Implementación de repositorios
│   │   ├── domain/                # Lógica de negocio
│   │   │   ├── entities/          # Entidades del dominio
│   │   │   ├── repositories/      # Interfaces de repositorios
│   │   │   └── usecases/          # Casos de uso
│   │   └── presentation/          # Capa de presentación
│   │       ├── bloc/              # Blocs/Cubits
│   │       ├── pages/             # Páginas/Pantallas
│   │       └── widgets/           # Widgets reutilizables
│   │
│   ├── dashboard/                 # Dashboard principal
│   ├── transactions/              # Transacciones (ingresos/egresos)
│   ├── categories/                # Categorías y subcategorías
│   ├── savings/                   # Planes de ahorro
│   ├── budgets/                   # Presupuestos
│   └── reports/                   # Reportes y gráficos
│
└── main.dart                      # Punto de entrada
```

## Instalación y configuración

### Prerrequisitos

1. **Flutter SDK 3.10+** instalado
2. **Git** instalado
3. Cuenta en **Supabase** (gratuita)
4. (Opcional) Android Studio para desarrollo Android
5. (Opcional) Xcode para desarrollo iOS (solo macOS)

### Pasos de instalación

1. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd finanzas-app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Supabase**
   - Sigue las instrucciones detalladas en `SETUP_SUPABASE.md`
   - Crea un proyecto en Supabase
   - Ejecuta el script SQL de `supabase_schema.sql`
   - Configura las credenciales en `lib/core/config/app_config.dart`

4. **Ejecutar la aplicación**
   ```bash
   # Web
   flutter run -d chrome

   # Android
   flutter run -d android

   # Windows
   flutter run -d windows
   ```

## Modelo de datos

### Tablas principales

1. **categories** - Categorías y subcategorías de transacciones
2. **transactions** - Registro de ingresos y egresos
3. **savings_plans** - Planes de ahorro con metas
4. **budgets** - Presupuestos con límites y alertas

Ver `supabase_schema.sql` para el esquema completo.

## Roadmap de desarrollo

### Fase 1: Base (Completada)
- ✅ Configuración del proyecto
- ✅ Arquitectura limpia con Bloc
- ✅ Modelos de datos
- ✅ Configuración de Supabase
- ✅ Tema y diseño base

### Fase 2: Autenticación (En progreso)
- ⏳ Login con Google
- ⏳ Login con Facebook
- ⏳ Manejo de sesión
- ⏳ Flujo de onboarding

### Fase 3: Funcionalidades principales
- ⏳ Dashboard con resumen
- ⏳ CRUD de categorías
- ⏳ CRUD de transacciones
- ⏳ Gestión de planes de ahorro
- ⏳ Sistema de presupuestos

### Fase 4: Análisis y reportes
- ⏳ Gráficos de gastos/ingresos
- ⏳ Análisis por categorías
- ⏳ Reportes mensuales/anuales
- ⏳ Exportación a PDF/Excel

### Fase 5: Características avanzadas
- ⏳ Notificaciones push
- ⏳ Modo oscuro
- ⏳ Múltiples monedas
- ⏳ Recordatorios de pagos
- ⏳ Backup y restauración

## Comandos útiles

```bash
# Verificar instalación de Flutter
flutter doctor

# Obtener dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Generar APK para Android
flutter build apk

# Generar aplicación para Windows
flutter build windows

# Ejecutar tests
flutter test

# Limpiar proyecto
flutter clean
```

## Contribuir

Este es un proyecto en desarrollo activo. Si quieres contribuir:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## Licencia

Este proyecto es privado y está en desarrollo.

## Contacto

Para preguntas o sugerencias, abre un issue en el repositorio.

---

**Versión actual**: 1.0.0 (En desarrollo)

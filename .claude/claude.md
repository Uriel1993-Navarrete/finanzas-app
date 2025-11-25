# Instrucciones de Desarrollo para Claude Code

## Principios Fundamentales

### 1. Pruebas Básicas Obligatorias

**SIEMPRE** se deben realizar pruebas básicas antes de considerar una tarea como completada:

- ✅ **Compilación**: Verificar que el código compile sin errores
  ```bash
  flutter analyze
  flutter build apk --debug
  ```

- ✅ **Funcionalidad**: Probar la funcionalidad implementada
  - Ejecutar la aplicación y validar el flujo completo
  - Probar casos de éxito y casos de error
  - Validar con diferentes datos de entrada

- ✅ **Integración**: Verificar que no se rompan funcionalidades existentes
  - Probar flujos relacionados
  - Verificar que el estado de la aplicación se mantenga correctamente

- ✅ **Base de Datos**: Si hay cambios en Supabase
  - Verificar que las consultas funcionen
  - Validar permisos RLS
  - Probar creación, lectura, actualización y eliminación de datos

### 2. Respetar el Diseño General de la Aplicación

**IMPORTANTE**: Mantener la consistencia en toda la aplicación:

#### Arquitectura
- **Clean Architecture**: Respetar la separación de capas
  ```
  features/
  ├── domain/         # Entidades, casos de uso, repositorios (interfaces)
  ├── data/          # Modelos, datasources, repositorios (implementaciones)
  └── presentation/  # Páginas, widgets, BLoC/Cubit
  ```

- **BLoC Pattern**: Usar BLoC para manejo de estado
  - Events para acciones del usuario
  - States para representar el estado de la UI
  - NO mezclar lógica de negocio en la UI

#### Diseño Visual
- **Colores**: Usar constantes de `AppColors`
  - `AppColors.primary`, `AppColors.income`, `AppColors.expense`, etc.
  
- **Tema**: Respetar el tema definido en `AppTheme`
  - Usar `Theme.of(context)` para acceder a estilos
  
- **Componentes Reutilizables**: 
  - Crear widgets reutilizables en lugar de duplicar código
  - Mantener consistencia en espaciados, tamaños, y estilos

#### Patrones de Código
- **Inyección de Dependencias**: Usar `get_it` (service locator `sl`)
- **Manejo de Errores**: Usar `Either<Failure, Success>` de dartz
- **Logging**: Usar `AppLogger` para debug y tracking
- **Nombrado**: 
  - Clases: PascalCase
  - Métodos/Variables: camelCase
  - Constantes: camelCase con `const`
  - Privados: prefijo con `_`

### 3. Checklist Antes de Completar una Tarea

Antes de marcar una tarea como completada, verificar:

- [ ] El código compila sin errores ni warnings
- [ ] La funcionalidad fue probada manualmente
- [ ] Se respeta la arquitectura Clean Architecture
- [ ] Se usa BLoC para manejo de estado
- [ ] Se respetan los colores y estilos del diseño
- [ ] Se agregaron logs apropiados con `AppLogger`
- [ ] No se rompieron funcionalidades existentes
- [ ] El código está documentado (comentarios donde sea necesario)
- [ ] Se siguieron las convenciones de nombrado
- [ ] Si hay cambios en BD, se probaron las consultas en Supabase

### 4. Flujo de Trabajo con Git

- Trabajar en rama `develop`
- Crear commits descriptivos
- Hacer push frecuente para no perder trabajo
- Merge a `main` solo cuando la funcionalidad esté completamente probada

### 5. Comunicación con el Usuario

- Reportar problemas encontrados durante las pruebas
- Solicitar aclaraciones cuando algo no esté claro
- Informar sobre limitaciones o trade-offs en las soluciones propuestas
- Sugerir mejoras basadas en best practices

---

**Recuerda**: La calidad sobre la velocidad. Es mejor tomarse tiempo para hacer las cosas bien que entregar código roto.

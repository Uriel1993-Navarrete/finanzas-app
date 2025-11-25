# 🗺️ Roadmap de Desarrollo - App Finanzas Personal

## 📊 Estado Actual

### ✅ Fase 1: Funcionalidad Básica (COMPLETADA)
- [x] Sistema de autenticación (Email + Google)
- [x] Registro de ingresos y egresos
- [x] Categorías predeterminadas (5 ingresos, 9 gastos)
- [x] Balance mensual general
- [x] Dashboard con transacciones recientes
- [x] Integración con Supabase
- [x] Clean Architecture + BLoC Pattern

---

## 🎯 Próximas Funcionalidades Prioritarias

### 🏗️ Fase 1.5: Gestión de Categorías Personalizadas
**Prioridad: CRÍTICA** | **Estimado: 2-3 días**

**¿Por qué es importante?**
Base fundamental para presupuestos. Permite a los usuarios crear, editar y organizar sus propias categorías y subcategorías adaptadas a su estilo de vida.

**Funcionalidades:**
- [ ] Ver lista de categorías actuales (ingresos y gastos)
- [ ] Crear nuevas categorías con nombre, ícono y color
- [ ] Editar categorías existentes
- [ ] Eliminar categorías (con validación si tienen transacciones)
- [ ] Crear subcategorías dentro de categorías principales
- [ ] Organizar categorías por orden de preferencia
- [ ] Filtrar categorías por tipo (ingreso/gasto)
- [ ] Búsqueda de categorías

**UI/UX:**
- Nueva sección en menú lateral o pestaña de configuración
- Lista con swipe para editar/eliminar
- FloatingActionButton para crear nueva
- Dialog/Bottom sheet para formulario de creación/edición
- Selector de iconos predefinidos
- Selector de colores
- Confirmación antes de eliminar

**Validaciones:**
- No permitir eliminar categorías con transacciones asociadas
- Nombres únicos por tipo (ingreso/gasto)
- Al menos 1 categoría de cada tipo debe existir

**Impacto:** ⭐⭐⭐⭐⭐ (Crítico - Base para presupuestos y personalización)

---

### 🔥 Fase 2: Presupuestos y Control de Gastos
**Prioridad: CRÍTICA** | **Estimado: 1 semana**

**¿Por qué es importante?**
Permitirá a los usuarios establecer límites de gasto por categoría y recibir alertas cuando se acerquen al límite.

**Funcionalidades:**
- [ ] Crear presupuesto mensual por categoría
- [ ] Visualizar progreso del presupuesto en tiempo real
- [ ] Alertas cuando se alcance el 80% y 100% del presupuesto
- [ ] Gráfica de comparación: gastado vs presupuestado
- [ ] Histórico de presupuestos (últimos 6 meses)
- [ ] Sugerencias de presupuesto basadas en gastos históricos

**UI/UX:**
- Card visual con barra de progreso por categoría
- Colores: Verde (bajo), Amarillo (80%), Rojo (>100%)
- Acceso rápido desde dashboard
- Notificaciones push cuando se exceda

**Impacto:** ⭐⭐⭐⭐⭐ (Alto - Control total de gastos)

---

### ⚡ Fase 3: Atajos Rápidos para Gastos Frecuentes
**Prioridad: ALTA** | **Estimado: 3-4 días**

**¿Por qué es importante?**
Facilitar el registro de gastos recurrentes con un solo tap, mejorando la experiencia de usuario.

**Funcionalidades:**
- [ ] Widget de atajos en el dashboard (ej: Café, Uber, Almuerzo)
- [ ] Configurar gastos favoritos con monto predefinido
- [ ] Registro rápido con 1 tap (monto + categoría preconfigurados)
- [ ] Editar/personalizar atajos
- [ ] Hasta 8 atajos visibles en pantalla principal
- [ ] Historial de gastos por atajo

**UI/UX:**
- Botones circulares con iconos
- Scroll horizontal de atajos
- Tap largo para editar
- Confirmación rápida con animación
- Posición: Justo debajo del balance en dashboard

**Impacto:** ⭐⭐⭐⭐⭐ (Alto - Mejora significativa en usabilidad)

---

### 📊 Fase 4: Reportes y Estadísticas Visuales
**Prioridad: ALTA** | **Estimado: 1 semana**

**¿Por qué es importante?**
Permite a los usuarios entender sus patrones de gasto y tomar decisiones informadas.

**Funcionalidades:**
- [ ] Gráfica de pastel: Distribución de gastos por categoría
- [ ] Gráfica de líneas: Tendencia de ingresos vs gastos (últimos 6 meses)
- [ ] Gráfica de barras: Comparación mensual
- [ ] Top 5 categorías con mayor gasto
- [ ] Análisis de tendencias (gastos crecientes/decrecientes)
- [ ] Filtros: por fecha, categoría, tipo
- [ ] Exportar reportes a PDF/Excel

**UI/UX:**
- Nueva pestaña "Estadísticas" en bottom navigation
- Gráficas interactivas (tap para ver detalles)
- Animaciones suaves al cargar datos
- Modo oscuro compatible

**Impacto:** ⭐⭐⭐⭐ (Medio-Alto - Insights valiosos)

---

### 💰 Fase 5: Planes de Ahorro Funcionales
**Prioridad: MEDIA-ALTA** | **Estimado: 4-5 días**

**¿Por qué es importante?**
Ayuda a los usuarios a alcanzar metas financieras específicas (vacaciones, emergencias, compras grandes).

**Funcionalidades:**
- [ ] Crear plan de ahorro con meta y fecha límite
- [ ] Aportar dinero al plan desde saldo disponible
- [ ] Visualizar progreso con barra animada
- [ ] Sugerencias de ahorro mensuales
- [ ] Notificaciones de recordatorio para aportar
- [ ] Historial de aportes
- [ ] Completar plan y celebrar el logro
- [ ] Múltiples planes simultáneos

**UI/UX:**
- Cards con animación de progreso
- Confetti animation al completar meta
- Iconos personalizables por plan
- Arrastrar para aportar (gesture)

**Impacto:** ⭐⭐⭐⭐ (Medio-Alto - Motivación financiera)

---

### 🔔 Fase 6: Recordatorios de Pagos Recurrentes
**Prioridad: MEDIA** | **Estimado: 3-4 días**

**¿Por qué es importante?**
Evita pagos tardíos y multas, mejorando la organización financiera.

**Funcionalidades:**
- [ ] Crear recordatorios con fecha y monto
- [ ] Categorizar como recurrente (mensual, semanal, anual)
- [ ] Notificaciones push 1 día antes
- [ ] Marcar como pagado desde la notificación
- [ ] Lista de próximos pagos en dashboard
- [ ] Historial de pagos completados

**UI/UX:**
- Badge en ícono de notificaciones
- Lista expandible en dashboard
- Swipe para marcar como pagado
- Colores según urgencia

**Impacto:** ⭐⭐⭐ (Medio - Conveniencia)

---

## 📅 Cronograma Sugerido

| Fase | Funcionalidad | Duración | Fecha Inicio | Fecha Fin |
|------|--------------|----------|--------------|-----------|
| 1.5 | Gestión de Categorías | 2-3 días | TBD | TBD |
| 2 | Presupuestos | 1 semana | TBD | TBD |
| 3 | Atajos Rápidos | 3-4 días | TBD | TBD |
| 4 | Reportes y Estadísticas | 1 semana | TBD | TBD |
| 5 | Planes de Ahorro | 4-5 días | TBD | TBD |
| 6 | Recordatorios | 3-4 días | TBD | TBD |

**Tiempo total estimado:** 5-6 semanas

---

## 🎨 Principios de Diseño UI/UX

### Modernidad e Intuitividad
1. **Minimalismo**: Evitar sobrecarga visual
2. **Acceso rápido**: Máximo 2 taps para acciones frecuentes
3. **Feedback visual**: Animaciones suaves y confirmaciones
4. **Consistencia**: Mismo estilo en toda la app
5. **Accesibilidad**: Botones grandes, contraste adecuado

### Atajos Importantes
- Widget de atajos siempre visible en dashboard
- FAB (Floating Action Button) para nueva transacción rápida
- Gestos: Swipe para acciones secundarias
- Bottom sheet para acciones contextuales

---

## 🔄 Proceso de Desarrollo por Fase

Para cada fase, seguir estos pasos:

1. **Planificación** (10% del tiempo)
   - Definir casos de uso
   - Diseñar mockups de UI
   - Identificar dependencias

2. **Desarrollo** (60% del tiempo)
   - Implementar capa domain
   - Implementar capa data
   - Implementar capa presentation
   - Integrar con Supabase si aplica

3. **Pruebas** (20% del tiempo)
   - Pruebas manuales de flujos
   - Pruebas de integración
   - Validar en diferentes dispositivos

4. **Refinamiento** (10% del tiempo)
   - Ajustar UI/UX según feedback
   - Optimizar rendimiento
   - Documentar

---

## 📈 Métricas de Éxito

Cada fase debe cumplir:
- ✅ 100% funcional sin errores críticos
- ✅ UI responsiva y fluida (60 FPS)
- ✅ Tiempos de carga < 2 segundos
- ✅ Código documentado
- ✅ Pruebas manuales completadas
- ✅ Feedback positivo del usuario

---

## 🚀 Futuras Mejoras (Backlog)

- Sincronización multi-dispositivo en tiempo real
- Modo offline con sincronización posterior
- Compartir gastos con otros usuarios (gastos compartidos)
- Integración con bancos (Open Banking)
- Reconocimiento de recibos con IA
- Análisis predictivo de gastos
- Gamificación (logros, racha de ahorro)
- Widget de iOS/Android

---

**Última actualización:** 2025-11-25
**Versión:** 1.0

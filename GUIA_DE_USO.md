# Guía de Uso - Finanzas App

## Primeros Pasos

### 1. Configurar Supabase

Antes de usar la aplicación, necesitas configurar Supabase:

1. **Crear proyecto en Supabase**
   - Ve a https://supabase.com y crea una cuenta
   - Crea un nuevo proyecto
   - Guarda las credenciales (URL y Anon Key)

2. **Ejecutar el esquema de base de datos**
   - En Supabase, ve a SQL Editor
   - Copia y pega el contenido de `supabase_schema.sql`
   - Ejecuta el script (Run)
   - Verifica que se crearon 4 tablas: categories, transactions, savings_plans, budgets

3. **Configurar credenciales en la app**
   - Abre `lib/core/config/app_config.dart`
   - Reemplaza `supabaseUrl` y `supabaseAnonKey` con tus credenciales

4. **Configurar autenticación con Google (Opcional)**
   - Sigue las instrucciones en `SETUP_SUPABASE.md`

### 2. Ejecutar la Aplicación

```bash
# En Web (recomendado para empezar)
./srcflutter/bin/flutter run -d chrome

# En Windows
./srcflutter/bin/flutter run -d windows

# En Android (requiere Android Studio)
./srcflutter/bin/flutter run -d android
```

---

## Funcionalidades Principales

### 🔐 Autenticación

**Registro de Usuario**
1. En la pantalla de login, toca "Regístrate"
2. Completa tus datos:
   - Nombre completo
   - Correo electrónico
   - Contraseña (mínimo 6 caracteres)
3. Confirma tu contraseña
4. Toca "Crear Cuenta"

**Inicio de Sesión**
- Con email y contraseña
- O con tu cuenta de Google

**Cerrar Sesión**
- Desde el Dashboard, toca el menú (⋮)
- Selecciona "Cerrar sesión"

---

### 📊 Dashboard (Pantalla Principal)

El Dashboard te muestra:

**Tarjeta de Balance**
- Balance total del mes actual
- Total de ingresos del mes
- Total de gastos del mes
- Los montos se actualizan automáticamente

**Acciones Rápidas**
- **Ingreso**: Agregar un nuevo ingreso
- **Gasto**: Agregar un nuevo gasto
- **Ahorro**: Crear plan de ahorro (próximamente)

**Transacciones Recientes**
- Muestra las últimas 5 transacciones
- Toca "Ver todas" para ver la lista completa
- Pull to refresh para actualizar

**Navegación Inferior**
- 🏠 Inicio: Dashboard principal
- 📄 Transacciones: Ver todas las transacciones
- 📊 Estadísticas: Gráficos (próximamente)
- 👤 Perfil: Configuración (próximamente)

**Botón Flotante (+)**
- Toca para abrir menú rápido
- Selecciona "Agregar ingreso" o "Agregar gasto"

---

### 💰 Agregar Ingreso

1. **Desde el Dashboard**:
   - Toca el botón "Ingreso" en acciones rápidas, O
   - Toca el botón flotante (+) y selecciona "Agregar ingreso"

2. **Completar el formulario**:
   - **Monto** (requerido): Cantidad del ingreso
   - **Categoría** (requerido): Selecciona de las disponibles:
     - Salario
     - Freelance
     - Inversiones
     - Bonos
     - Otros Ingresos
   - **Fecha**: Selecciona la fecha (por defecto hoy)
   - **Descripción**: Breve descripción (ej: "Salario Enero 2025")
   - **Notas**: Detalles adicionales (opcional)

3. **Guardar**:
   - Toca "Guardar"
   - Verás un mensaje de confirmación
   - El Dashboard se actualiza automáticamente

**Consejos**:
- Sé descriptivo en la descripción para encontrar fácilmente tus ingresos
- Usa las notas para detalles importantes (ej: "Incluye bono de productividad")

---

### 💸 Agregar Egreso (Gasto)

1. **Desde el Dashboard**:
   - Toca el botón "Gasto" en acciones rápidas, O
   - Toca el botón flotante (+) y selecciona "Agregar gasto"

2. **Completar el formulario**:
   - **Monto** (requerido): Cantidad gastada
   - **Categoría** (requerido): Selecciona de las 9 categorías:
     - 🍽️ Alimentación
     - 🚗 Transporte
     - 🏠 Vivienda
     - 🎬 Entretenimiento
     - 🏥 Salud
     - 📚 Educación
     - 🛍️ Compras
     - 📱 Servicios
     - 📂 Otros Gastos
   - **Fecha**: Selecciona cuándo hiciste el gasto
   - **Descripción**: ¿En qué gastaste? (ej: "Compra en supermercado")
   - **Notas**: Detalles (ej: "Despensa mensual")

3. **Guardar**:
   - Toca "Guardar"
   - El gasto se registra inmediatamente
   - El balance se actualiza

**Consejos**:
- Registra tus gastos inmediatamente para no olvidarlos
- Usa categorías específicas para mejor análisis
- Revisa tus gastos semanalmente

---

### 📋 Ver Lista de Transacciones

**Acceder a la lista**:
- Desde Dashboard, toca "Ver todas" en transacciones recientes
- O usa la navegación inferior: Transacciones

**En la lista puedes**:
- Ver todas tus transacciones ordenadas por fecha
- Ver el monto, categoría y fecha de cada una
- Deslizar para actualizar (pull to refresh)
- Eliminar transacciones:
  1. Toca el ícono de basura (🗑️)
  2. Confirma la eliminación

**Agregar nueva transacción**:
- Toca el botón flotante (+) en la esquina inferior
- Selecciona tipo (Ingreso/Egreso)

---

### 🎨 Categorías Predeterminadas

**Categorías de Ingresos**:
1. 💼 Salario - Ingresos por trabajo
2. 💻 Freelance - Trabajos independientes
3. 📈 Inversiones - Rendimientos
4. 🎁 Bonos - Bonificaciones y premios
5. ➕ Otros Ingresos

**Categorías de Gastos**:
1. 🍽️ Alimentación - Comida y bebida
2. 🚗 Transporte - Gasolina, pasajes, Uber
3. 🏠 Vivienda - Renta, hipoteca, servicios
4. 🎬 Entretenimiento - Cine, streaming, diversión
5. 🏥 Salud - Medicina, doctor, gym
6. 📚 Educación - Cursos, libros, colegiatura
7. 🛍️ Compras - Ropa, electrónicos
8. 📱 Servicios - Netflix, Spotify, internet
9. 📂 Otros Gastos

**Nota**: Próximamente podrás crear categorías personalizadas y subcategorías.

---

## Consejos y Mejores Prácticas

### 📝 Registro de Transacciones

1. **Sé consistente**
   - Registra tus gastos diariamente
   - No dejes acumular transacciones

2. **Sé específico**
   - Usa descripciones claras
   - "Gasolina" es mejor que "Gasto"
   - Aprovecha el campo de notas

3. **Categoriza correctamente**
   - Usa la categoría más específica
   - Esto ayudará en los reportes

### 💡 Gestión Financiera

1. **Revisa tu Dashboard diariamente**
   - Conoce tu balance actual
   - Identifica patrones de gasto

2. **Analiza mensualmente**
   - Compara ingresos vs gastos
   - Identifica áreas de mejora

3. **Planifica con anticipación**
   - Registra ingresos fijos al inicio del mes
   - Establece límites mentales por categoría

---

## Solución de Problemas

### "No se pueden cargar las transacciones"
1. Verifica tu conexión a internet
2. Confirma que Supabase esté configurado correctamente
3. Revisa que las credenciales en `app_config.dart` sean correctas

### "Error al crear transacción"
1. Verifica que hayas seleccionado una categoría
2. Asegúrate de que el monto sea mayor a 0
3. Confirma que tengas conexión a internet

### "No aparece mi transacción"
1. Desliza hacia abajo para refrescar (pull to refresh)
2. Verifica la fecha de la transacción
3. Revisa si estás en la pestaña correcta (Ingresos/Egresos)

### "Balance en $0"
- Esto es normal si no has registrado transacciones este mes
- El balance muestra solo el mes actual
- Agrega tus primeras transacciones para ver el balance

---

## Próximas Funcionalidades

🚧 En desarrollo:
- ✅ Categorías personalizadas
- ✅ Subcategorías
- 📊 Gráficos y estadísticas
- 💾 Exportación a PDF/Excel
- 🎯 Planes de ahorro
- 💰 Presupuestos con alertas
- 📅 Gastos recurrentes
- 🔔 Notificaciones
- 🌙 Modo oscuro

---

## Soporte

¿Necesitas ayuda?
- Revisa esta guía completa
- Consulta `SETUP_SUPABASE.md` para problemas de configuración
- Consulta `GUIA_COMPILACION_APK.md` para generar APK

---

¡Disfruta administrando tus finanzas! 💰✨

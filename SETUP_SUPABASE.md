# Configuración de Supabase para Finanzas App

## Paso 1: Crear un proyecto en Supabase

1. Ve a [https://supabase.com](https://supabase.com) y crea una cuenta o inicia sesión
2. Haz clic en "New Project"
3. Completa los datos:
   - **Name**: Finanzas App (o el nombre que prefieras)
   - **Database Password**: Elige una contraseña segura (guárdala en un lugar seguro)
   - **Region**: Selecciona la región más cercana a ti
4. Haz clic en "Create new project" y espera a que se complete la configuración

## Paso 2: Obtener las credenciales

1. Una vez creado el proyecto, ve a **Settings** (configuración) en el menú lateral
2. Selecciona **API**
3. Copia los siguientes valores:
   - **Project URL**: Este es tu `supabaseUrl`
   - **anon public**: Esta es tu `supabaseAnonKey`

## Paso 3: Configurar las credenciales en la app

1. Abre el archivo `lib/core/config/app_config.dart`
2. Reemplaza los valores:

```dart
static const String supabaseUrl = 'TU_URL_DE_SUPABASE_AQUI';
static const String supabaseAnonKey = 'TU_ANON_KEY_AQUI';
```

## Paso 4: Crear las tablas de la base de datos

1. En Supabase, ve a **SQL Editor** en el menú lateral
2. Haz clic en **New Query**
3. Copia todo el contenido del archivo `supabase_schema.sql` de este proyecto
4. Pega el SQL en el editor
5. Haz clic en **Run** para ejecutar el script
6. Verifica que se crearon las tablas en **Database** > **Tables**

Deberías ver las siguientes tablas:
- ✅ categories
- ✅ transactions
- ✅ savings_plans
- ✅ budgets

## Paso 5: Configurar autenticación con Google

1. Ve a **Authentication** > **Providers** en Supabase
2. Busca **Google** y habilítalo
3. Necesitarás crear credenciales de OAuth en Google Cloud Console:

   a. Ve a [Google Cloud Console](https://console.cloud.google.com/)
   b. Crea un nuevo proyecto o selecciona uno existente
   c. Ve a **APIs & Services** > **Credentials**
   d. Haz clic en **Create Credentials** > **OAuth client ID**
   e. Selecciona **Web application**
   f. En **Authorized redirect URIs**, agrega:
      ```
      https://[TU_PROYECTO_REF].supabase.co/auth/v1/callback
      ```
   g. Copia el **Client ID** y **Client Secret**
   h. Pégalos en Supabase en la configuración de Google provider
   i. Guarda los cambios

## Paso 6: Configurar autenticación con Facebook (Opcional)

1. Ve a **Authentication** > **Providers** en Supabase
2. Busca **Facebook** y habilítalo
3. Necesitarás crear una app en Facebook Developers:

   a. Ve a [Facebook Developers](https://developers.facebook.com/)
   b. Crea una nueva app
   c. Agrega el producto **Facebook Login**
   d. En la configuración de Facebook Login, agrega:
      ```
      https://[TU_PROYECTO_REF].supabase.co/auth/v1/callback
      ```
   e. Copia el **App ID** y **App Secret**
   f. Pégalos en Supabase en la configuración de Facebook provider
   g. Guarda los cambios

## Paso 7: Verificar la configuración

1. Asegúrate de que todas las credenciales estén correctamente configuradas
2. Verifica que las políticas RLS (Row Level Security) estén habilitadas
3. Prueba la conexión ejecutando la app

## Seguridad

⚠️ **IMPORTANTE**:
- Nunca compartas tu `supabaseAnonKey` públicamente
- No subas el archivo `app_config.dart` con credenciales reales a repositorios públicos
- Considera usar variables de entorno para producción

## Siguientes pasos

Una vez completada la configuración:
1. La app se conectará automáticamente a Supabase
2. Los usuarios podrán registrarse e iniciar sesión
3. Todos los datos se sincronizarán en tiempo real
4. Las políticas RLS garantizan que cada usuario solo vea sus propios datos

## Soporte

Si encuentras algún problema:
- Revisa los logs en Supabase: **Logs Explorer**
- Verifica que las políticas RLS estén activas
- Asegúrate de que las credenciales sean correctas

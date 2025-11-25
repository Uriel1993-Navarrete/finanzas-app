# Guía de Compilación de APK para Android

## Requisitos Previos

### 1. Instalar Android Studio

1. Descarga Android Studio desde: https://developer.android.com/studio
2. Durante la instalación, asegúrate de instalar:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (opcional, para emulador)

### 2. Configurar Variables de Entorno

Agrega las siguientes rutas a tus variables de entorno:

```
ANDROID_HOME = C:\Users\TU_USUARIO\AppData\Local\Android\Sdk
```

Y agrega a PATH:
```
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\tools
```

### 3. Verificar Instalación

Ejecuta en la terminal:
```bash
flutter doctor
```

Deberías ver:
- ✅ Flutter
- ✅ Android toolchain
- ✅ Chrome

## Comandos de Compilación

### Compilar APK de Debug (para pruebas)

```bash
flutter build apk --debug
```

El APK se generará en: `build\app\outputs\flutter-apk\app-debug.apk`

### Compilar APK de Release (para producción)

```bash
flutter build apk --release
```

El APK se generará en: `build\app\outputs\flutter-apk\app-release.apk`

### Compilar App Bundle (recomendado para Google Play Store)

```bash
flutter build appbundle --release
```

El bundle se generará en: `build\app\outputs\bundle\release\app-release.aab`

## Configuración Adicional para Producción

### 1. Firmar la Aplicación

Para publicar en Play Store, necesitas firmar tu app:

1. Genera un keystore:
```bash
keytool -genkey -v -keystore finanzas-app-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias finanzas
```

2. Crea el archivo `android/key.properties`:
```properties
storePassword=TU_PASSWORD
keyPassword=TU_PASSWORD
keyAlias=finanzas
storeFile=../finanzas-app-key.jks
```

3. Actualiza `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 2. Optimizar el APK

#### Reducir tamaño con split per ABI:

En `android/app/build.gradle`:
```gradle
android {
    ...
    splits {
        abi {
            enable true
            reset()
            include 'armeabi-v7a', 'arm64-v8a', 'x86_64'
            universalApk true
        }
    }
}
```

#### Habilitar ProGuard/R8 (ofuscación):

En `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        signingConfig signingConfigs.release
    }
}
```

## Instalar APK en Dispositivo

### Vía USB

1. Habilita "Opciones de desarrollador" en tu dispositivo Android
2. Activa "Depuración USB"
3. Conecta el dispositivo
4. Ejecuta:
```bash
flutter install
```

O instala el APK directamente:
```bash
adb install build\app\outputs\flutter-apk\app-release.apk
```

### Vía Transferencia de Archivos

1. Copia el APK a tu dispositivo
2. Abre el APK desde el explorador de archivos
3. Permite instalación de fuentes desconocidas si es necesario

## Solución de Problemas Comunes

### Error: "SDK location not found"

Crea el archivo `android/local.properties`:
```properties
sdk.dir=C:\\Users\\TU_USUARIO\\AppData\\Local\\Android\\Sdk
```

### Error: "Gradle build failed"

1. Limpia el proyecto:
```bash
flutter clean
flutter pub get
```

2. Actualiza Gradle:
En `android/gradle/wrapper/gradle-wrapper.properties`, usa:
```
distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
```

### Error: "Minimum SDK version"

En `android/app/build.gradle`, asegúrate de tener:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
    }
}
```

## Publicar en Google Play Store

1. Crea una cuenta de desarrollador en: https://play.google.com/console
2. Crea una nueva aplicación
3. Completa la información requerida
4. Sube el App Bundle (.aab)
5. Completa las capturas de pantalla y descripciones
6. Envía para revisión

## Checklist Final

Antes de publicar, verifica:

- [ ] La app funciona correctamente en debug y release
- [ ] Todas las funcionalidades están probadas
- [ ] Los permisos en AndroidManifest.xml son correctos
- [ ] El ícono de la app está configurado
- [ ] El nombre de la app es correcto
- [ ] La versión y build number están actualizados en pubspec.yaml
- [ ] Has firmado la app con tu keystore
- [ ] El tamaño del APK/AAB es razonable (<50MB idealmente)

## Recursos Adicionales

- [Documentación oficial de Flutter - Build & Release Android](https://docs.flutter.dev/deployment/android)
- [Guía de Google Play Console](https://support.google.com/googleplay/android-developer)

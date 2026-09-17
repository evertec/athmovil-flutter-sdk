# Flutter ya aplica sus reglas por defecto (getDefaultProguardFile),
# aqui solo se agregan las especificas de esta app de ejemplo.

# shared_preferences_android usa reflexion sobre sus clases internas
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Evitar warnings de clases opcionales que Retrofit/OkHttp referencian
# pero que no siempre estan en el classpath (no son obligatorias)
-dontwarn okhttp3.internal.platform.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# Mantener anotaciones a nivel de app (necesario en algunas versiones de AGP/R8)
-keepattributes *Annotation*

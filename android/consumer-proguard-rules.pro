# Mantener modelos (CRÍTICO para Gson)
-keep class com.evertec.athmovil.athmovil_checkout_flutter.models.** { *; }

# Mantener constructores
-keepclassmembers class com.evertec.athmovil.athmovil_checkout_flutter.models.** {
    public <init>(...);
}

# Gson
-keepattributes Signature
-keepattributes *Annotation*

-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Retrofit necesita esto (CRÍTICO)
-keepattributes Signature
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations

# Mantener interfaces de Retrofit
-keep interface retrofit2.** { *; }
-keep class retrofit2.** { *; }

# Mantener tus servicios
-keep interface com.evertec.athmovil.athmovil_checkout_flutter.** { *; }

# Mantener anotaciones HTTP (GET, POST, etc.)
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}

# Gson
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*
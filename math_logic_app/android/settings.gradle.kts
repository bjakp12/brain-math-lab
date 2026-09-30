pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Matriks terverifikasi Flutter 3.47: AGP 9.1.0 + Gradle 9.3.1 + KGP 2.4.0.
// JANGAN naikkan ke AGP/Gradle 10 sebelum didukung resmi (lihat BUILD_MATRIX.md).
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    // Tanpa KGP: Kotlin disediakan built-in oleh AGP 9 (android.builtInKotlin=true).
}

include(":app")

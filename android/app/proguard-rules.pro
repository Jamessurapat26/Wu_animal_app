# TensorFlow Lite - keep all necessary classes
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.**

# GPU Delegate
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.**

# Prevent R8 from removing used classes/methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes Signature
-keepattributes *Annotation*

# Flutter plugin entry points
-keep class io.flutter.plugin.common.MethodChannel {
    *;
}
-keep class io.flutter.embedding.engine.FlutterEngine {
    *;
}

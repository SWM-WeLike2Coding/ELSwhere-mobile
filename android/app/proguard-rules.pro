-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn javax.annotation.concurrent.**
# Keep Google API Client Library classes
-keep class com.google.api.client.** { *; }
-dontwarn com.google.api.client.**

# Keep Joda-Time classes (if you use Joda-Time in your project)
-keep class org.joda.time.** { *; }
-dontwarn org.joda.time.**

# Optional: For Tink library classes
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

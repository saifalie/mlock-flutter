-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}



-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

-dontwarn proguard.annotation.**
-keep class proguard.annotation.** { *; }
-keepnames class proguard.annotation.Keep
-keepnames class proguard.annotation.KeepClassMembers
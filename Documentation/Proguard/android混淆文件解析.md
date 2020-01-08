``` text

# This is a configuration file for ProGuard.
# http://proguard.sourceforge.net/index.html#manual/usage.html
#
# This file is no longer maintained and is not used by new (2.2+) versions of the
# Android plugin for Gradle. Instead, the Android plugin for Gradle generates the
# default rules at build time and stores them in the build directory.

# 混淆时不生成大小写混合的类名
-dontusemixedcaseclassnames
# 不忽略非公共的类库
-dontskipnonpubliclibraryclasses
# 混淆过程中打印详细的信息
-verbose

# Optimization is turned off by default. Dex does not like code run
# through the ProGuard optimize and preverify steps (and performs some
# of these optimizations on its own).
# 关闭优化
-dontoptimize
# 不预校验
-dontpreverify
# Note that if you want to enable optimization, you cannot just
# include optimization flags in your own project configuration file;
# instead you will need to point to the
# "proguard-android-optimize.txt" file instead of this one from your
# project.properties file.

# Annotation注释不能混淆
-keepattributes *Annotation*
-keep public class com.google.vending.licensing.ILicensingService
-keep public class com.android.vending.licensing.ILicensingService

# For native methods, see http://proguard.sourceforge.net/manual/examples.html#native
# 对于NDK开发，本地的native方法不能混淆
-keepclasseswithmembernames class * {
    native <methods>;
}

# keep setters in Views so that animations can still work.
# see http://proguard.sourceforge.net/manual/examples.html#beans
# 继承了view类的set，get方法不混淆(* 代替任意字符)
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

# We want to keep methods in Activity that could be used in the XML attribute onClick
# 保持Activity子类里面的参数类型为View的方法不被混淆，例如XML中的onClick方法
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

# For enumeration classes, see http://proguard.sourceforge.net/manual/examples.html#enumerations
# 保持枚举enum类型的values(),valueOf(java.lang.String)成员不被混淆
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
# 保持Parceable接口类型里面的Creator成员不被混淆
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}
# 保持R类静态成员不被混淆
-keepclassmembers class **.R$* {
    public static <fields>;
}

# The support library contains references to newer platform versions.
# Don't warn about those in case this app is linking against an older
# platform version.  We know about them, and they are safe.
# 不警告support包中不使用的引用 they are safe
-dontwarn android.support.**

# Understand the @Keep support annotation.
-keep class android.support.annotation.Keep

-keep @android.support.annotation.Keep class * {*;}
# 保持使用Keep注解的方法及类不被混淆
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <methods>;
}

# 保持了使用keep注解的成员域及类不被混淆
-keepclasseswithmembers class * {
    @android.support.annotation.Keep <fields>;
}

-keepclasseswithmembers class * {
    @android.support.annotation.Keep <init>(...);
}

```


``` java
#压缩级别0-7，Android一般为5(对代码迭代优化的次数)
-optimizationpasses 5 

#不使用大小写混合类名
-dontusemixedcaseclassnames 

 #混淆时记录日志
-verbose

#不警告org.greenrobot.greendao.database包及其子包里面未应用的应用
-dontwarn org.greenrobot.greendao.database.**
-dontwarn rx.**
-dontwarn org.codehaus.jackson.**
......
#保持jackson包以及其子包的类和类成员不被混淆
-keep class org.codehaus.jackson.** {*;}
#--------重要说明-------
#-keep class 类名 {*;}
#-keepclassmembers class 类名{*;}
#一个*表示保持了该包下的类名不被混淆；
# -keep class org.codehaus.jackson.*
#二个**表示保持该包以及它包含的所有子包下的类名不被混淆
# -keep class org.codehaus.jackson.** 
#------------------------
#保持类名、类里面的方法和变量不被混淆
-keep class org.codehaus.jackson.** {*;}
#不混淆类ClassTwoOne的类名以及类里面的public成员和方法
#public 可以换成其他java属性如private、public static 、final等
#还可以使<init>表示构造方法、<methods>表示方法、<fields>表示成员，
#这些前面也可以加public等java属性限定
-keep class com.dev.demo.two.ClassTwoOne {
    public *;
}
#不混淆类名，以及里面的构造函数
-keep class com.dev.demo.ClassOne {
    public <init>();
}
#不混淆类名，以及参数为int 的构造函数
-keep class com.dev.demo.two.ClassTwoTwo {
    public <init>(int);
}
#不混淆类的public修饰的方法，和private修饰的变量
-keepclassmembers class com.dev.demo.two.ClassTwoThree {
    public <methods>;
    private <fields>;
}
#不混淆内部类，需要用$修饰
#不混淆内部类ClassTwoTwoInner以及里面的全部成员
-keep class com.dev.demo.two.ClassTwoTwo$ClassTwoTwoInner{*;}
......
```
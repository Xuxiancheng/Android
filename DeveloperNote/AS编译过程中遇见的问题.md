# AS工程编译过程中遇见的问题

## 前言

主要搜集一些使用AS过程中出现的问题。

## 使用或覆盖了已过时的 API。

使用或覆盖了已过时的 API。 注: 有关详细信息, 请使用 -Xlint:deprecation 重新编译。

找到build.gradle(app)，在allprojects中加入以下代码：

``` groovy
gradle.projectsEvaluated {
    tasks.withType(JavaCompile) {
        options.compilerArgs << "-Xlint:unchecked" << "-Xlint:deprecation"
    }
}
```

## Program type already present:com.xx.xx

gradle编译出现Program type already present:com.xx.xx

仔细读一下错误信息还是可以看出来的,其实就是这个类已经加载或存在了,也就是说很大的可能是因为重复引入了这个类,所以就去检查了这个类都存在哪些jar包中,最后在引用里发现这两个引用里面都有这个类,所以这个问题去掉一个就解决了,当遇到这个问题的时候可以*检查下jar包有没有重复的*。

## Job failed see logs for details

打包的时候提示：Job failed see logs for details，百度了一下，说可能是混淆文件的问题，

解决方法是在主 app的proguard-rules.pro混淆文件中添加了一句话  

``` java
-ignorewarnings # 抑制警告
```

## INSTALL_FAILED_SHARED_USER_INCOMPATIBLE

这是由于使用了sharedUserId后，使用不同的签名造成的。

Android中共享UID可以让多个应用使用通过Process ID可以共享内存空间外，

解决办法：删除android:sharedUserId

``` xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          package="com.xxx.vvv"
          android:sharedUserId="android.uid.system">
```


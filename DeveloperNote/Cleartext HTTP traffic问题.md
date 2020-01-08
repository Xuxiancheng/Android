##  Android高版本联网报错:Cleartext HTTP traffic to xxx not解决方法

### 原因说明

为保证用户数据和设备的安全，Google针对下一代 Android 系统(Android P) 的应用程序，将要求默认使用加密连接，这意味着 Android P 将禁止 App 使用所有未加密的连接，因此运行 Android P 系统的安卓设备无论是接收或者发送流量，未来都不能明码传输，需要使用下一代(Transport Layer Security)传输层安全协议，而 Android Nougat 和 Oreo 则不受影响。



因此在Android P 使用HttpUrlConnection进行http请求会出现以下异常：

```java
W/System.err: java.io.IOException: Cleartext HTTP traffic to **** not permitted
```

使用OKHttp请求则出现:

```java
java.net.UnknownServiceException: CLEARTEXT communication ** not permitted by network security policy
```



在Android P系统的设备上，如果应用使用的是非加密的明文流量的http网络请求，则会导致该应用无法进行网络请求，https则不会受影响，同样地，如果应用嵌套了webview，webview也只能使用https请求。

### 解决方法

#### （1）APP改用https请求

#### （2）targetSdkVersion <=27

#### （3）更改网络安全配置

1. 在res文件夹下创建一个xml文件夹，然后创建一个network_security_config.xml文件，文件内容如下：

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

2. 接着，在AndroidManifest.xml文件下的application标签增加以下属性：

```xml
 android:networkSecurityConfig="@xml/network_security_config"
```

#### （4）清单文件中直接更改

1. 在AndroidManifest.xml配置文件的<application>标签中直接插入

```xml
android:usesCleartextTraffic="true"
```
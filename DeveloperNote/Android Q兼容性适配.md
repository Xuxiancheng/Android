# Android Q适配(部分)

在Android 10 版本中，官方改动较大，相应的适配成本较高，尤其是对于隐私性的保护导致在以前版本中使用的很多方法失效，因此写下这篇文档，供项目参考。

## 一. 亮点

### 1. 创新技术和新体验

1. 支持可折叠设备
2. 5G网络
3. 通知中的智能回复
4. 深色主题
5. 手势导航
6. 设置面板
7. 共享快捷方式

### 2. 用户隐私设置

隐私权是 Android 10 的其中一个主要关注点，相关改进包括在平台中提供更强大的保护措施以及在设计新功能时谨记隐私性。Android 10  基于先前版本构建，并引入了大量变更（如改进了系统界面、让权限授予更加严格以及对应用能够使用哪些数据实施了限制），目的是保护隐私权并赋予用户更多控制权。

1. 赋予用户对位置数据的更多控制权

> 用户可以通过新的权限选项更好地控制他们的位置数据；现在，他们可以允许应用仅在实际使用（在前台运行）时访问位置信息。对于大部分应用来说，这提供了足够的访问级别；而对于用户来说，这在确保透明度和控制权方面是一项重大改进。                                                                                                                                                              

![](https://developer.android.com/images/about/versions/10/overview/location.png)

​																*用户现在可以选择在应用在前台运行时授予其访问位置信息的权限*

2. 在扫描网络时保护位置数据

​           用于扫描网络的大多数API都需要粗略位置权限

3. 阻止设备跟踪

> 应用无法再访问不可重置的设备标识符（可用于跟踪），包括设备 IMEI、序列号和类似标识符。设备的 MAC 地址也会默认在连接到 WLAN 网络时随机分配。

4. 保护外部存储设备中的用户数据

> Android 10 引入了一些变更，目的是让用户更好地控制外部存储设备中的文件以及其中的应用数据。应用可以将自己的文件存储在专用沙盒中，但必须使用 MediaStore 来访问共享媒体文件，并使用系统文件选择器访问新的“下载内容”集合中的共享文件。

5. 屏蔽意外中断

​           Android 10 可阻止应用从后台启动，从后台启动会使应用意外跳转到前台并从其他应用获得焦点。

### 3. 安全性

...关系不大，暂不列出



## 二.适配



### 1. 隐私权和位置信息

Android 10 中引入了大量变更(如改进了系统界面、让权限授予更加严格以及对应用能够使用哪些数据实施了限制)，目的是保护隐私权并赋予用户控制权。

#### 1.1 概览

#### **重大隐私权限变更**

* 分区存储
* 增强了用户对位置权限的控制力
* 系统执行后台Activity
* 不可重置的硬件标志符
* 无限扫描权限

#### **其它隐私权变更**

##### 标志符和数据

针对硬件标志符(如IMEI、序列号、MAC和类似数据)实施了新限制

* 移除了联系人亲密程度信息
* 随机分配MAC地址
* 对`/proc/net`文件心痛的访问权限实施了限制
* 对不可重置的设备标志符实施了限制
* 限制了对剪贴板数据的访问权限
* 保护USB设备序列号

###### 摄像头和连接性

针对摄像头元数据和连接API提供了更强大的保护措施

* 对访问摄像头详情和元数据的权限实施了限制
* 对启用和停用WLAN实施了限制
* 对直接访问已配置的WLAN网络实施了限制
* 一些电话API、蓝牙API和WLAN API需要精确位置权限

###### 权限

针对权限模型和要求的一些变更

* 限制对屏幕内容的访问
* 面向用户的权限检查(针对旧版本)
* 身体活动识别
* 从界面中移除了权限组



#### 1.2  Android 10中的隐私权变更

##### 重大变更

###### 外部存储访问权限限定为应用文件和媒体

> 默认情况下，对于以 Android 10 及更高版本为目标平台的应用，其[访问权限范围限定为外部存储](https://developer.android.com/training/data-storage/files/external-scoped)，即分区存储。此类应用可以查看外部存储设备内以下类型的文件，无需请求任何与存储相关的用户权限：
>
> - 特定于应用的目录中的文件（使用 [`getExternalFilesDir()`](https://developer.android.com/reference/android/content/Context#getExternalFilesDir(java.lang.String)) 访问）。
> - 应用创建的照片、视频和音频片段（通过[媒体库](https://developer.android.com/training/data-storage/files/media)访问）。

简单总结：

1. 对于App内部存储路径与外部存储路径，不需要 `READ_EXTERNAL_STORAGE `与 `WRITE_EXTERNAL_STORAGE `权限：

- 内部存储路径 /data/data/<包名>/
- 外部存储路径 /storage/Android/data/<包名>/

2. 读写自己App的多媒体文件和下载目录的其它文件时无需任何权限，但是只能通过`媒体库`访问

3.  访问其它App创建的共享文件时，需要申请`READ_EXTERNAL_STORAGE`权限
4. 除多媒体文件外的其它文件，只能够通过系统自带的文件浏览器访问



###### 在后台运行时访问设备位置信息需要权限

为了让用户更好地控制应用对位置信息的访问权限，Android 10 引入了 [`ACCESS_BACKGROUND_LOCATION`](https://developer.android.com/reference/android/Manifest.permission.html#ACCESS_BACKGROUND_LOCATION) 权限。

与 [`ACCESS_FINE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission.html#ACCESS_FINE_LOCATION) 和 [`ACCESS_COARSE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission.html#ACCESS_COARSE_LOCATION) 权限不同，`ACCESS_BACKGROUND_LOCATION` 权限仅会影响应用在后台运行时对位置信息的访问权限。除非符合以下条件之一，否则应用将被视为在后台访问位置信息：

- 属于该应用的 Activity 可见。

- 该应用运行的某个前台设备已声明[前台服务类型](https://developer.android.com/guide/topics/manifest/service-element#foregroundservicetype)为 `location`。

  要声明您的应用中的某个服务的前台服务类型，请将应用的 `targetSdkVersion` 或 `compileSdkVersion` 设置为 `29` 或更高版本。详细了解前台服务如何[继续执行用户发起的需要访问位置信息的操作](https://developer.android.com/training/location/receive-location-updates#continue-user-initiated-action)。

以 Android 9 或更低版本为目标平台时自动授予访问权限

如果您的应用在 Android 10 或更高版本上运行，但其目标平台是 Android 9（API 级别 28）或更低版本，则该平台具有以下行为：

- 如果您的应用为 [`ACCESS_FINE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission.html#ACCESS_FINE_LOCATION) 或 [`ACCESS_COARSE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission.html#ACCESS_COARSE_LOCATION) 声明了 [``](https://developer.android.com/guide/topics/manifest/uses-permission-element) 元素，则系统会在安装期间自动为 `ACCESS_BACKGROUND_LOCATION` 添加 `` 元素。
- 如果您的应用请求了 `ACCESS_FINE_LOCATION` 或 `ACCESS_COARSE_LOCATION`，系统会自动将 `ACCESS_BACKGROUND_LOCATION` 添加到请求中。



##### 标志符和数据

###### 移除了联系人亲密程度信息

> 从 Android 10 开始，平台不再跟踪联系人亲密程度信息。因此，如果您的应用对用户的联系人进行搜索，系统将不会按互动频率对搜索结果排序。

###### 随机分配MAC地址

默认情况下，在搭载 Android 10 或更高版本的设备上，系统会传输随机分配的 MAC 地址。

**WIFI Mac 与 蓝牙Mac 均获取不到或获取的都是默认值**

> 如果您的应用处理[企业使用场景](https://developers.google.com/android/work/)，平台会提供 API，用于执行与 MAC 地址相关的几个操作。
>
> - **获取随机分配的 MAC 地址**：设备所有者应用和资料所有者应用可以通过调用 [`getRandomizedMacAddress()`](https://developer.android.com/reference/android/net/wifi/WifiConfiguration.html#getRandomizedMacAddress()) 检索分配给特定网络的随机分配 MAC 地址。
> - **获取实际的出厂 MAC 地址**：设备所有者应用可以通过调用 [`getWifiMacAddress()`](https://developer.android.com/reference/android/app/admin/DevicePolicyManager.html#getWifiMacAddress(android.content.ComponentName)) 检索设备的实际硬件 MAC 地址。此方法对于跟踪设备队列非常有用。

###### 对`/proc/net`文件系统的访问权限实施了限制

在搭载 Android 10 或更高版本的设备上，应用无法访问 `/proc/net`，其中包含与设备的网络状态相关的信息。需要访问这些信息的应用（如 VPN）应使用 [`NetworkStatsManager`](https://developer.android.com/reference/android/app/usage/NetworkStatsManager) 或 [`ConnectivityManager`](https://developer.android.com/reference/android/net/ConnectivityManager) 类。



######  对不可重置的设备标识符实施了限制

从 Android 10 开始，应用必须具有 `READ_PRIVILEGED_PHONE_STATE` 特许权限才能访问设备的不可重置标识符（包含 IMEI 和序列号）。

> 受影响的方法包括：
>
> - ```
>   Build
>   ```
>
>   - [`getSerial()`](https://developer.android.com/reference/android/os/Build#getSerial())
>
> - ```
>   TelephonyManager
>   ```
>
>   - [`getImei()`](https://developer.android.com/reference/android/telephony/TelephonyManager#getImei(int))
>   - [`getDeviceId()`](https://developer.android.com/reference/android/telephony/TelephonyManager#getDeviceId(int))
>   - [`getMeid()`](https://developer.android.com/reference/android/telephony/TelephonyManager#getMeid(int))
>   - [`getSimSerialNumber()`](https://developer.android.com/reference/android/telephony/TelephonyManager#getSimSerialNumber())
>   - [`getSubscriberId()`](https://developer.android.com/reference/android/telephony/TelephonyManager#getSubscriberId())

如果您的应用没有该权限，但您仍尝试查询不可重置标识符的相关信息，则平台的响应会因目标 SDK 版本而异：

- 如果应用以 Android 10 或更高版本为目标平台，则会发生 [`SecurityException`](https://developer.android.com/reference/java/lang/SecurityException)。
- 如果应用以 Android 9（API 级别 28）或更低版本为目标平台，则相应方法会返回 `null` 或占位符数据（如果应用具有 [`READ_PHONE_STATE`](https://developer.android.com/reference/android/Manifest.permission.html#READ_PHONE_STATE) 权限）。否则，会发生 `SecurityException`。



###### 限制了对剪贴板数据的访问权限

除非您的应用是默认[输入法 (IME)](https://developer.android.com/guide/topics/text/creating-input-method) 或是目前处于焦点的应用，否则它无法访问 Android 10 或更高版本平台上的剪贴板数据。



###### 保护 USB 设备序列号

如果您的应用以 Android 10 或更高版本为目标平台，则该应用只能在用户授予其访问 USB 设备或配件的权限后才能读取序列号。



##### 连接性

###### 对启用和停用 WLAN 实施了限制



以 Android 10 或更高版本为目标平台的应用无法启用或停用 WLAN。[`WifiManager.setWifiEnabled()`](https://developer.android.com/reference/android/net/wifi/WifiManager#setWifiEnabled(boolean)) 方法始终返回 `false`。



###### 一些电话 API、蓝牙 API 和 WLAN API 需要精确位置权限

如果应用以 Android 10 或更高版本为目标平台，则它必须具有 [`ACCESS_FINE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION) 权限才能使用 WLAN、WLAN 感知或蓝牙 API 中的一些方法。以下部分列举了受影响的类和方法。

> **注意:** 如果您的应用在 Android 10 或更高版本平台上运行，但其目标平台是 Android 9（API 级别 28）或更低版本，则只要您的应用已声明 [`ACCESS_COARSE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission#ACCESS_COARSE_LOCATION) 或 [`ACCESS_FINE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION) 权限，您就可以使用受影响的 API（[`WifiP2pManager`](https://developer.android.com/reference/android/net/wifi/p2p/WifiP2pManager) API 除外）。

电话

- `TelephonyManager`
  - `getCellLocation()`
  - `getAllCellInfo()`
  - `requestNetworkScan()`
  - `requestCellInfoUpdate()`
  - `getAvailableNetworks()`
  - `getServiceState()`
- `TelephonyScanManager`
  - `requestNetworkScan()`
- `TelephonyScanManager.NetworkScanCallback`
  - `onResults()`
- `PhoneStateListener`
  - `onCellLocationChanged()`
  - `onCellInfoChanged()`
  - `onServiceStateChanged()`

WLAN

- `WifiManager`
  - `startScan()`
  - `getScanResults()`
  - `getConnectionInfo()`
  - `getConfiguredNetworks()`
- [`WifiAwareManager`](https://developer.android.com/reference/android/net/wifi/aware/WifiAwareManager)
- [`WifiP2pManager`](https://developer.android.com/reference/android/net/wifi/p2p/WifiP2pManager)
- [`WifiRttManager`](https://developer.android.com/reference/android/net/wifi/rtt/WifiRttManager)

蓝牙

- `BluetoothAdapter`
  - `startDiscovery()`
  - `startLeScan()`
- [`BluetoothAdapter.LeScanCallback`](https://developer.android.com/reference/android/bluetooth/BluetoothAdapter.LeScanCallback)
- `BluetoothLeScanner`
  - `startScan()`



###### 限制对明目内容的访问

为了保护用户的屏幕内容，Android 10 更改了 `READ_FRAME_BUFFER`、`CAPTURE_VIDEO_OUTPUT` 和 `CAPTURE_SECURE_VIDEO_OUTPUT` 权限的作用域，从而禁止以静默方式访问设备的屏幕内容。从 Android 10 开始，这些权限只能[通过签名访问](https://developer.android.com/guide/topics/permissions/overview#signature_permissions)。

需要访问设备屏幕内容的应用应使用 [`MediaProjection`](https://developer.android.com/reference/android/media/projection/MediaProjection) API，此 API 会显示提示，要求用户同意访问。



###### 面向用户的权限检查(针对旧版本)

如果您的应用以 Android 5.1（API 级别 22）或更低版本为目标平台，则用户首次在搭载 Android 10 或更高版本的平台上使用您的应用时，系统会向其显示权限屏幕，如图 1 所示。此屏幕让用户有机会撤消系统先前在安装时向应用授予的访问权限。



### 2. 针对应用的行为变更



#### 2.1 限制非SDK接口

为了帮助确保应用的稳定性和兼容性，Android 平台开始限制应用在 Android 9（API 级别 28）中使用[非 SDK 接口](https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces)。Android 10 包含更新后的受限制非 SDK 接口列表（基于与 Android 开发者之间的协作以及最新的内部测试）。

**Android 9.0开始部分反射方法开始失效，谷歌开始禁止开发者调用非SDK方法，到了10之后又进一步增加了非SDK的数量**

在10中的非SDK方法包含以下部分：

> 说明：
>
> 1. greylist：灰名单,即当前版本中仍然能够使用的非SDK接口，但是下一个版本中可能变成**被限制的非SDK接口**
> 2. blacklist：黑名单，使用了就会报错，无论是否是适配了Android Q版本
> 3.  greylist-max-o：在`targetSDK<=O`中能使用，但是在`targetSDK>=P`中被限制的非SDK接口
> 4.  greylist-max-p： 在`targetSDK<=P`中能使用，但是在`targetSDK>=Q`中被限制的非SDK接口



##### 浅灰和深灰列表命名变化

在 Android 9（API 级别 28）中，灰名单分为以下两个列表：

- 包含非 SDK 接口（无论目标 API 级别是什么，您都可以使用这些接口）的浅灰列表。
- 包含非 SDK 接口（如果您的应用的目标 API 级别是 28 或更高，您将无法使用这些接口）的深灰列表。

从 Android 10 开始，我们现在将这两个列表都称为灰名单，但列入灰名单且受目标 API 级别限制的非 SDK 接口（之前列入浅灰列表）现在也会由可在其中使用此类接口的最高目标 SDK 版本引用。



**🌟突破口(可进一步研究)** 

#####  `adb`更改非 SDK 接口权限

在 Android 10 中，可用于授予对非 SDK 接口的访问权限的命令已更改。您可以更改 API 强制执行政策，以允许在开发设备上访问非 SDK 接口。为此，请使用以下 ADB 命令：

```shell
adb shell settings put global hidden_api_policy  1
```

要将 API 强制执行政策重置为默认设置，请使用以下命令：

```shell
adb shell settings delete global hidden_api_policy
```

这些命令无需设备启用 root 权限即可执行。

您可以将 API 强制执行政策中的整数设置为以下某个值：

- 0：停用所有非 SDK 接口检测。如果使用此设置，系统会停止输出有关非 SDK 接口使用情况的所有日志消息，并阻止您[使用 `StrictMode` API](https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces#test-strictmode-api) 测试应用。建议不要使用此设置。
- 1：允许访问所有非 SDK 接口，但同时输出日志消息，并且在其中显示针对所有非 SDK 接口使用情况的警告。如果使用此设置，您仍可以[使用 `StrictMode` API](https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces#test-strictmode-api) 来测试应用。
- 2：禁止使用已针对您的[目标 API 级别](https://developer.android.com/distribute/best-practices/develop/target-sdk)列入黑名单或受限灰名单的非 SDK 接口。


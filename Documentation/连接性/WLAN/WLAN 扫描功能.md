# WLAN 扫描功能

## [WLAN 扫描流程](https://developer.android.google.cn/guide/topics/connectivity/wifi-scan#wifi-scan-process)

### 扫描流程分为三步

* 为`SCAN_RESULTS_AVAILABLE_ACTION`注册一个广播接收器®️。

  系统会在完成扫描请求时调用此监听器，提供其成功/失败状态。**对于搭载 Android 10（API 级别 29）及更高版本的设备，系统将针对平台或其他应用在设备上执行的所有完整 WLAN 扫描发送此广播。应用可以使用广播被动监听设备上所有扫描的完成情况，无需发出自己的扫描。**

  > 注意高版本的扫描方式，WiFiManager.startScan()方法在9.0之时已经被废弃，未来的版本将会移除!

* 使用`WifiManager.startScan()`请求扫描。

  请**务必检查**方法的返回状态，因为调用可能因以下任一原因失败：

  * 由于短时间扫描过多，扫描请求可能遭到节流。
  * 设备处于空闲状态，扫描已停用。
  * WLAN 硬件报告扫描失败。

* 使用`WifiManager.getScanResults()`获取扫描结果

  系统返回的扫描结果为最近更新的结果，但如果当前扫描尚未完成或成功，可能会返回以前扫描的结果。也就是说，如果在收到成功的 [`SCAN_RESULTS_AVAILABLE_ACTION`](https://developer.android.google.cn/reference/android/net/wifi/WifiManager#SCAN_RESULTS_AVAILABLE_ACTION) 广播前调用此方法，您可能会获得较旧的扫描结果。

  

###  代码实现

``` java
WifiManager wifiManager = (WifiManager)
                   context.getSystemService(Context.WIFI_SERVICE);

BroadcastReceiver wifiScanReceiver = new BroadcastReceiver() {
  @Override
  public void onReceive(Context c, Intent intent) {
    boolean success = intent.getBooleanExtra(
                       WifiManager.EXTRA_RESULTS_UPDATED, false);
    if (success) {
      scanSuccess();
    } else {
      // scan failure handling
      scanFailure();
    }
  }
};

IntentFilter intentFilter = new IntentFilter();
intentFilter.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION);
context.registerReceiver(wifiScanReceiver, intentFilter);

boolean success = wifiManager.startScan();
if (!success) {
  // scan failure handling
  scanFailure();
}

....

private void scanSuccess() {
  List<ScanResult> results = wifiManager.getScanResults();
  ... use new scan results ...
}

private void scanFailure() {
  // handle failure: new scan did NOT succeed
  // consider using old scan results: these are the OLD results!
  List<ScanResult> results = wifiManager.getScanResults();
  ... potentially use older scan results ...
}
```

> 需要进行权限申请🈸️，且各个版本中的申请的权限还不一样😭

## 限制🚫

Android 8.0（API 级别 26）引入了有关权限和 WLAN 扫描允许频率的限制。

为了提高网络性能和安全性，延长电池续航时间，Android 9（API 级别 28）收紧了权限要求，并进一步限制 WLAN 扫描频率。

### 权限

#### **Android 8.0 和 Android 8.1**

成功调用 `WifiManager.getScanResults()` 需要以下任意一项权限：

* `ACCESS_FINE_LOCATION`
* `ACCESS_COARSE_LOCATION`
* `CHANGE_WIFI_STATE`

对于上述权限，如果调用应用一项都不具备，调用将会失败，并显示 `SecurityException`。

> 或者，在搭载 Android 8.0（API 级别 26）及更高版本的设备上，您可以使用 [`CompanionDeviceManager`](https://developer.android.google.cn/reference/android/companion/CompanionDeviceManager) 代表应用对附近的配套设备执行扫描，而不需要位置权限。如需详细了解此选项，请参阅[配套设备配对](https://developer.android.google.cn/guide/topics/connectivity/companion-device-pairing)。

#### **Android 9**

成功调用 `WifiManager.startScan()` 需要满足以下所有条件：

* 应用拥有 `ACCESS_FINE_LOCATION` 或 `ACCESS_COARSE_LOCATION`权限。
* 应用拥有 `CHANGE_WIFI_STATE`权限。
* 设备已启用位置信息服务（位于**设置 > 位置信息**下）。

#### **Android 10及更高版本**

成功调用 `WifiManager.startScan()`] 需要满足以下**所有**条件：

* 如果您的应用以 Android 10（API 级别 29）SDK 或更高版本为目标平台，应用需要拥有 `ACCESS_FINE_LOCATION` 权限。
* 如果您的应用以低于 Android 10（API 级别 29）的 SDK 为目标平台，应用需要拥有 `ACCESS_COARSE_LOCATION`或 `ACCESS_FINE_LOCATION` 权限。
* 应用拥有 `CHANGE_WIFI_STATE` 权限。
* 设备已启用位置信息服务（位于**设置** > **位置信息**下）。

若要成功调用 `WifiManager.getScanResults()`，请确保满足以下所有条件：

* 如果您的应用以 Android 10（API 级别 29）SDK 或更高版本为目标平台，应用需要拥有 `ACCESS_FINE_LOCATION` 权限。
* 如果您的应用以低于 Android 10（API 级别 29）的 SDK 为目标平台，应用需要拥有 `ACCESS_COARSE_LOCATION` 或 `ACCESS_FINE_LOCATION` 权限。
* 应用拥有 `ACCESS_WIFI_STATE`权限。
* 设备已启用位置信息服务（位于**设置** > **位置信息**下）。

如果调用应用无法满足上述所有要求，调用将失败，并显示 `SecurityException`。

> 可以看出随着Android版本的增加，Wi-Fi信息获取的条件变得越来越严格

### 节流

使用 `WifiManager.startScan()`扫描的频率适用以下限制。

#### **Android 8.0 和 Android 8.1**：

每个后台应用可以在 30 分钟内扫描一次。

#### **Android 9**：

每个前台应用可以在 2 分钟内扫描四次。这样便可在短时间内进行多次扫描。

所有后台应用总共可以在 30 分钟内扫描一次。

#### **Android 10 及更高版本**：

适用 Android 9 的节流限制。新增一个开发者选项，用户可以关闭节流功能以便进行本地测试（位于**开发者选项 >** **网络 > WLAN 扫描调节**下）。

## 其它

Android获取自身连接🔗的`WIFI`信息：

``` java
WifiManager wifi_service = (WifiManager)getSystemService(WIFI_SERVICE); 
WifiInfo wifiInfo = wifi_service.getConnectionInfo();
```

其中wifiInfo有以下的方法： 

``` java
wifiinfo.getBSSID()； //Mac地址
wifiinfo.getSSID()；  //名称
wifiinfo.getIpAddress()；//获取IP地址
wifiinfo.getMacAddress()；//获取MAC地址，用处不大，都是默认值
wifiinfo.getNetworkId()；//获取网络ID。 
wifiinfo.getLinkSpeed()；//获取连接速度，可以让用户获知这一信息
wifiinfo.getRssi()；//获取RSSI，RSSI就是接受信号强度指示
```

> 信号强度就靠wifiinfo.getRssi()这个方法。得到的值是一个0到-100的区间值，是一个int型数据，其中0到-50表示信号最好，-50到-70表示信号偏差，小于-70表示最差，有可能连接不上或者掉线，一般Wifi已断则值为-200。

> 🌟，注意📢广播及权限申请
>
> ``` java
> registerReceiver(rssiReceiver,new IntentFilter(WifiManager.RSSI_CHANGED_ACTION));
> ```
>
> ``` xml
> <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
> ```

## 参数分析

Android的参数大致分成两块：系统服务参数和平台系统信息。
系统服务参数：Android的系统服务不仅指服务组件，而且还包括Android 系统提供的服务功能。Android为这些系统服务参数提供了接口---管理器，不同的组件会有不同的管理器进行管理，主要有Wi-Fi管理，连接管理，电话管理，电源管理，振动管理，音量管理，输入法管理，窗口管理等等，我们通过这些系统服务接口就可以方便地获取系统信息。

``` java
WifiManager wifi_service = (WifiManager)getSystemService(WIFI_SERVICE);
//获取Wi-Fi配置接口的属性
List wifiConfig = wifi_service.getConfiguredNetworks();
//wifiConfig中包含四个属性：
  BSSID：BSS是一种特殊的Ad-hoc LAN(一种支持点对点访问的无线网络应用模式)的应用，一个无线网络至少由一个连接到有线网络的AP和若干无线工作站组成，这种配置称为一个基本服务装置。一群计算机设定相同的 BSS名称，即可自成一个group，而此BSS名称，即所谓BSSID。通常，手机WLAN中，bssid其实就是无线路由的MAC地址。
  networkid：网络ID。
  PreSharedKey：无线网络的安全认证模式。
  SSID：SSID(Service Set Identif)用于标识无线局域网，SSID不同的无线网络是无法进行互访的。
//获取Wi-Fi的连接信息
WifiInfo wifiinfo = wifi_service.getConnectionInfo();
     wifiinfo.getBSSID()：获取BSSIS(上面已说明)。
        wifiinfo.getSSID()：获取SSID(上面已说明)。
     wifiinfo.getIpAddress()：获取IP地址。
     wifiinfo.getMacAddress()：获取MAC地址。
     wifiinfo.getNetworkId()：获取网络ID。
        wifiinfo.getLinkSpeed()：获取连接速度，可以让用户获知这一信息。
     wifiinfo.getRssi()：获取RSSI，RSSI就是接受信号强度指示。在这可以直    
             接和华为提供的Wi-Fi信号阈值进行比较来提供给用户，让用户对网络 
             或地理位置做出调整来获得最好的连接效果。
    
//获取DHCP信息 
DhcpInfo dhcpinfo = wifi_service.getDhcpInfo();
   ipAddress：获取IP地址。
   gateway：获取网关。
   netmask：获取子网掩码。
   dns1：获取DNS。
   dns2：获取备用DNS。
   serverAddress：获取服务器地址。

     //获取扫描信息
List scanResult = wifi_service.getScanResults();
        BSSID：获取BSSID(上面已说明)。
        SSID：获取网络名(上面已说明)。
        level：获取信号等级。
        frequency：获取频率。
        capabilites：对该访问点安全方面的描述。
    //获取Wi-Fi的网络状态
int wifiState = wifi_service.getWifiState();
        WIFI_STATE_DISABLING：常量0，表示停用中。
   WIFI_STATE_DISABLED：常量1，表示不可用。
        WIFI_STATE_ENABLING：常量2，表示启动中。
        WIFI_STATE_ENABLED：常量3，表示准备就绪。
        WIFI_STATE_UNKNOWN：常量4，表示未知状态。
    说明：进行网络连接的时候，这些状态都会被显示在Notification上，直
         接可以通过此处获取各个状态来完成华为的Notification中Wi- Fi
         状态显示的需求。

//连接管理：
ConnectivityManager connectionManager = (ConnectivityManager) 
                          getSystemService(CONNECTIVITY_SERVICE);     
    //获取网络的状态信息，有下面三种方式 
NetworkInfo networkInfo = connectionManager.getActiveNetworkInfo();
NetworkInfo wifiInfo =     
       connectionManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
NetworkInfo mobileInfo = 
       connectionManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
    getDetailedState()：获取详细状态。
    getExtraInfo()：获取附加信息。
    getReason()：获取连接失败的原因。
    getType()：获取网络类型(一般为移动或Wi-Fi)。
    getTypeName()：获取网络类型名称(一般取值“WIFI”或“MOBILE”)。
    isAvailable()：判断该网络是否可用。
    isConnected()：判断是否已经连接。
    isConnectedOrConnecting()：判断是否已经连接或正在连接。
    isFailover()：判断是否连接失败。
    isRoaming()：判断是否漫游。
   
    //网络状态侦听器的使用
    在程序中写一个Service类继承BroadcasrReceiver：
    public class NetMonitor extends BroadcastReceiver {
      public void onReceive(Context context, Intent intent) {
         }
     }
   // 在androidManifest.xml中申明该Rervice：
    <service android:name="NetMonitor" android:lable="NetMonitor">
         <intent-filter>
            <action android:name="android.net.conn.CONNECTIVITY_CHANGE" />
         </intent-filter>
     </service>
    // 当网络状态发生改变的时候，就可以通过该Rervice监听到该变化，并作出相应的动作。
```


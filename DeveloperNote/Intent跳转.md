# Intent跳转

## 设置界面

### 应用详情界面

```java
/**
  * android 9 之后应用无法手动去卸载app
  * 跳转到应用详情界面，手动卸载
  * @param packageName
  */
private void gotoPermission(String packageName){
     if (Build.VERSION.SDK_INT>=29) {
          Intent intent = new Intent();
          intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
          intent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
          intent.setData(Uri.fromParts("package", packageName, null));
          startActivity(intent);
      }
}
```

### 其它

```java
ACTION_ACCESSIBILITY_SETTINGS ：    // 跳转系统的辅助功能界面  

           Intent intent =  new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);    
           startActivity(intent);    

ACTION_ADD_ACCOUNT ：               // 显示添加帐户创建一个新的帐户屏幕。【测试跳转到微信登录界面】     

           Intent intent =  new Intent(Settings.ACTION_ADD_ACCOUNT);    
           startActivity(intent);  

ACTION_AIRPLANE_MODE_SETTINGS：       // 飞行模式，无线网和网络设置界面  

           Intent intent =  new Intent(Settings.ACTION_AIRPLANE_MODE_SETTINGS);    
           startActivity(intent);  

        或者：  

     ACTION_WIRELESS_SETTINGS  ：        

                Intent intent =  new Intent(Settings.ACTION_WIFI_SETTINGS);    
                startActivity(intent);  

ACTION_APN_SETTINGS：                 //  跳转 APN设置界面  

           Intent intent =  new Intent(Settings.ACTION_APN_SETTINGS);    
           startActivity(intent);  

【需要参数】 ACTION_APPLICATION_DETAILS_SETTINGS：   // 根据包名跳转到系统自带的应用程序信息界面     

               Uri packageURI = Uri.parse("package:" + "com.tencent.WBlog");  
               Intent intent =  new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,packageURI);    
               startActivity(intent);  

ACTION_APPLICATION_DEVELOPMENT_SETTINGS :  // 跳转开发人员选项界面  

           Intent intent =  new Intent(Settings.ACTION_APPLICATION_DEVELOPMENT_SETTINGS);    
           startActivity(intent);  

ACTION_APPLICATION_SETTINGS ：      // 跳转应用程序列表界面  

           Intent intent =  new Intent(Settings.ACTION_APPLICATION_SETTINGS);    
           startActivity(intent);  

       或者：  

      ACTION_MANAGE_ALL_APPLICATIONS_SETTINGS   // 跳转到应用程序界面【所有的】  

             Intent intent =  new Intent(Settings.ACTION_MANAGE_ALL_APPLICATIONS_SETTINGS);    
             startActivity(intent);  

       或者：  

       ACTION_MANAGE_APPLICATIONS_SETTINGS  ：//  跳转 应用程序列表界面【已安装的】  

             Intent intent =  new Intent(Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS);    
             startActivity(intent);  



ACTION_BLUETOOTH_SETTINGS  ：      // 跳转系统的蓝牙设置界面  

           Intent intent =  new Intent(Settings.ACTION_BLUETOOTH_SETTINGS);    
           startActivity(intent);  

ACTION_DATA_ROAMING_SETTINGS ：   //  跳转到移动网络设置界面  

           Intent intent =  new Intent(Settings.ACTION_DATA_ROAMING_SETTINGS);    
           startActivity(intent);  

ACTION_DATE_SETTINGS ：           //  跳转日期时间设置界面  

            Intent intent =  new Intent(Settings.ACTION_DATA_ROAMING_SETTINGS);    
            startActivity(intent);  

ACTION_DEVICE_INFO_SETTINGS  ：    // 跳转手机状态界面  

            Intent intent =  new Intent(Settings.ACTION_DEVICE_INFO_SETTINGS);    
            startActivity(intent);  

ACTION_DISPLAY_SETTINGS  ：        // 跳转手机显示界面  

            Intent intent =  new Intent(Settings.ACTION_DISPLAY_SETTINGS);    
            startActivity(intent);  

ACTION_DREAM_SETTINGS     【API 18及以上 没测试】  

            Intent intent =  new Intent(Settings.ACTION_DREAM_SETTINGS);    
            startActivity(intent);  


ACTION_INPUT_METHOD_SETTINGS ：    // 跳转语言和输入设备  

            Intent intent =  new Intent(Settings.ACTION_INPUT_METHOD_SETTINGS);    
            startActivity(intent);  

ACTION_INPUT_METHOD_SUBTYPE_SETTINGS  【API 11及以上】  //  跳转 语言选择界面 【多国语言选择】  

             Intent intent =  new Intent(Settings.ACTION_INPUT_METHOD_SUBTYPE_SETTINGS);    
             startActivity(intent);  

ACTION_INTERNAL_STORAGE_SETTINGS         // 跳转存储设置界面【内部存储】  

             Intent intent =  new Intent(Settings.ACTION_INTERNAL_STORAGE_SETTINGS);    
             startActivity(intent);  

      或者：  

        ACTION_MEMORY_CARD_SETTINGS    ：   // 跳转 存储设置 【记忆卡存储】  

             Intent intent =  new Intent(Settings.ACTION_MEMORY_CARD_SETTINGS);    
             startActivity(intent);  


ACTION_LOCALE_SETTINGS  ：         // 跳转语言选择界面【仅有English 和 中文两种选择】    

              Intent intent =  new Intent(Settings.ACTION_LOCALE_SETTINGS);    
              startActivity(intent);  


ACTION_LOCATION_SOURCE_SETTINGS :    //  跳转位置服务界面【管理已安装的应用程序。】  

              Intent intent =  new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);    
              startActivity(intent);  

ACTION_NETWORK_OPERATOR_SETTINGS ： // 跳转到 显示设置选择网络运营商。  

              Intent intent =  new Intent(Settings.ACTION_NETWORK_OPERATOR_SETTINGS);    
              startActivity(intent);  

ACTION_NFCSHARING_SETTINGS  ：       // 显示NFC共享设置。 【API 14及以上】  

              Intent intent =  new Intent(Settings.ACTION_NFCSHARING_SETTINGS);    
              startActivity(intent);  

ACTION_NFC_SETTINGS  ：           // 显示NFC设置。这显示了用户界面,允许NFC打开或关闭。  【API 16及以上】  

              Intent intent =  new Intent(Settings.ACTION_NFC_SETTINGS);    
              startActivity(intent);  

ACTION_PRIVACY_SETTINGS ：       //  跳转到备份和重置界面  

              Intent intent =  new Intent(Settings.ACTION_PRIVACY_SETTINGS);    
              startActivity(intent);  

ACTION_QUICK_LAUNCH_SETTINGS  ： // 跳转快速启动设置界面  

               Intent intent =  new Intent(Settings.ACTION_QUICK_LAUNCH_SETTINGS);    
               startActivity(intent);  

ACTION_SEARCH_SETTINGS    ：    // 跳转到 搜索设置界面  

               Intent intent =  new Intent(Settings.ACTION_SEARCH_SETTINGS);    
               startActivity(intent);  

ACTION_SECURITY_SETTINGS  ：     // 跳转到安全设置界面  

               Intent intent =  new Intent(Settings.ACTION_SECURITY_SETTINGS);    
               startActivity(intent);  

ACTION_SETTINGS   ：                // 跳转到设置界面  

                Intent intent =  new Intent(Settings.ACTION_SETTINGS);    
                startActivity(intent);  

ACTION_SOUND_SETTINGS                // 跳转到声音设置界面  

                 Intent intent =  new Intent(Settings.ACTION_SOUND_SETTINGS);    
                 startActivity(intent);  

ACTION_SYNC_SETTINGS ：             // 跳转账户同步界面  

                Intent intent =  new Intent(Settings.ACTION_SYNC_SETTINGS);    
                startActivity(intent);  

ACTION_USER_DICTIONARY_SETTINGS ：  //  跳转用户字典界面 
```

##  功能性

###  卸载自身

通过Uri卸载自身应用，但是在`Android 9`之后失效了

```Java
Uri packageUri = Uri.parse("package:"+MainActivity.this.getPackageName());
Intent intent = new Intent(Intent.ACTION_DELETE,packageUri);
startActivity(intent);
```

**添加权限**

`<permission android:name="android.permission.DELETE_PACKAGES" />`
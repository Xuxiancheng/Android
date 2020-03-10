# OAID 简介

**`Android 10` 之后的替代方案**

## 起源

![](https://cdn.sspai.com/2020/01/07/49fd5f56b7435212b9d55cb02975a48f.png)

至此，国内的 `App`和广告跟踪服务急需一种替代方案以避免广告流量的损失，`OAID`顺势而生。

 开发者文档中对 `Android 10` 限制设备标识符读取的说明` OAID `的本质其实是一种在国行系统内使用的、应对 `Android 10` 限制读取 `IMEI `的、「拯救」国内移动广告的广告跟踪标识符，其背后是 `移动安全联盟`（Mobile Security Alliance，简称 MSA）。

## 简介

根据联盟官网以及开发文档，这个「本土化」标识符体系除了 `OAID`，还包含`UDID`、`VAID` 和` AAID` 一共四种标识符。

![](https://cdn.sspai.com/2020/01/12/a9e9a1ea2686e5f4b69bbff2900e50e4.png)



![](https://cdn.sspai.com/2020/01/12/76f846d2807c1f2ce38801a1c632d53b.png)



在理想状态下，引入`OAID`既能保证广告平台的正常运作,也能减少对用户带来的影响，因为第三方`App`无需请求权限即可使用`OAID`完成广告行为，而该过程匿名，用来可以随时重置`OAID`。

![](https://cdn.sspai.com/2020/01/07/f47ff201e962fd657bb1d85a952c10b0.png?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

主流手机厂商都已经在其开发平台上提供了`Android 10`的适配指引，如有疑问可以去各个厂商的开发文档中寻找解决方案。

## 适配

如果有疑问可以查看此文档，下文只是对其作出一些简单的说明，简要介绍如何获取`OAID`

[移动智能终端补充设备标识体系统一调用-开发者说明文档](https://swsdl.vivo.com.cn/appstore/developer/uploadfile/20191109/d6Ybr5/移动智能终端补充设备标识体系统一调用SDK开发者说明文档v1.10.pdf)

### `SDK`获取

`MSA`统一`SDK`下载地址:

移动安全联盟官网:[http://www.msa-alliance.cn/](http://www.msa-alliance.cn/)

将下载好的压缩包解压，我们需要其中的`*.aar`及`*.json`文件。

### 调用方法

1. 把 `miit_mdid_x.x.x.aar`拷贝到项目的`libs`目录下,并设置依赖,其中`x.x.x`代表版本号。

   找到项目的`bulid.gradle`文件,在 `dependencies`处添加:

    ``` groovy
   implementation files("libs/miit_mdid_1.0.10.aar")
    ```

2.  将 `supplierconfig.json`拷贝到项目`assets`目录下，此处我并未修改其中的对应内容(注意)

2.  混淆设置:

    ```groovy
   -keep class com.bun.miitmdid.core.** {*;}
   ```

4.  代码调用:

   * 初始化`sdk`
     在应用`application`的`onCreate`中调用方法:

      ``` java
     protected void onCreate(Bundle savedInstanceState) {
          super.onCreate(savedInstanceState);
          JLibrary.InitEntry(this);
          setContentView(R.layout.activity_main);
     } 
      ```
   * 获取设备ID
     反射调用方法：
     ``` java
     package com.example.basicdemo;
     import android.os.Bundle;
     import android.os.Handler;
     import android.os.Message;
     import android.util.Log;
     import android.view.View;
     import android.widget.TextView;
     import android.widget.Toast;
     
     import androidx.annotation.NonNull;
     import androidx.appcompat.app.AppCompatActivity;
     
     import com.bun.miitmdid.core.IIdentifierListener;
     import com.bun.miitmdid.core.JLibrary;
     import com.bun.miitmdid.core.MdidSdkHelper;
     import com.bun.miitmdid.supplier.IdSupplier;
     
     public class MainActivity extends AppCompatActivity {
       final Handler handler = new Handler(){
         @Override
         public void handleMessage(@NonNull Message msg) {
             super.handleMessage(msg);
             switch (msg.what){
                 case 0:
                     Bundle bundle = msg.getData();
                     textView.setText(bundle.getString("id"));
                     break;
                 case 1:
                     textView.setText("not supported!");
                     break;
             }
         }
     };
     
     private TextView textView;
     
     @Override
     protected void onCreate(Bundle savedInstanceState) {
         super.onCreate(savedInstanceState);
         JLibrary.InitEntry(this);
         setContentView(R.layout.activity_main);
     
         textView = findViewById(R.id.content);
     
         findViewById(R.id.button).setOnClickListener(new View.OnClickListener() {
             @Override
             public void onClick(View v) {
             
                 MdidSdkHelper.InitSdk(MainActivity.this, true, new IIdentifierListener() {
                     @Override
                     public void OnSupport(boolean b, IdSupplier idSupplier) {
                         if (idSupplier.isSupported()){
                             Message message   = new Message();
                             message.what = 0;
                             Bundle bundle = new Bundle();
                             bundle.putString("id",idSupplier.getOAID());
                             message.setData(bundle);
                             handler.sendMessage(message);
                         }else {
                             handler.sendEmptyMessage(1);
                         }
                     }
                 });
     
             }
         });
     }}
     ```



## 注意

此处文档只是简单的介绍了如何获取`OAID`，如果有疑问，可以去主流厂商的开发者网站上寻找适配文档。
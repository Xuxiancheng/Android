# adbkey与adbkey.pub原理

## 前言

用adb调试android设备时，首次连接时，会出现一个授权提示：

``` shell
error: device unauthorized. Please check the confirmation dialog on your device
```

这时候，正常情况下，在手机上会出现一个提示框，让用户确认是否授权这个PC设备允许调试，你只需要点击确认就可以了！

## 原理

在我们的PC机（以windows为例）上启动了adb.exe进程时，adb会在本地生成一对密钥adbkey(私钥)与adbkey.pub(公钥);

根据弹框提示“The computer's RSA key fingerprint is:xxxx”，可以看出是一对RSA算法的密钥，其中公钥是用来发送给手机的；

当你执行“adb shell”时，adb.exe会将当前PC的公钥(或者公钥的hash值)(fingerprint)发送给android设备；这时，如果android上已经保存了这台PC的公钥，则匹配出对应的公钥进行认证，建立adb连接；如果android上没有保存这台PC的公钥，则会弹出提示框，让你确认是否允许这台机器进行adb连接，当你点击了允许授权之后，android就会保存了这台PC的adbkey.pub(公钥)；

**那么问题来了，这些密钥在PC与Android上分别存储在哪里？**

首先PC上，以Windows7为例，当你首次启动adb.exe时，会在C盘的当前用户的目录下生成一个".android"目录，其中adbkey与adbkey.pub就在这个目录下；（adb.exe会在启动时读取这两个文件(没有就重新生成)，所以如果你要是删除或者修改了这两个文件之后，必须要关闭adb.exe进程，重启之后才能生效；）

其次Android上，PC的公钥被保存在一个文件中"/data/misc/adb/adb_keys”；

在知道了adb这种认证的原理之后，你可以在不希望自己android设备授权任何PC设备进行adb链接时，清除"/data/misc/adb/adb_keys"文件；

也可以在没有屏幕的情况下，让已经认证过的PC将你PC上的adbkey.pub中的公钥导入到android中的"/data/misc/adb/adb_keys"文件中，或者将已经认证过的PC机上的adbkey与adbkey.pub拷贝到本机上覆盖你自己的adbkey与adbkey.pub，然后重启adb.exe，即可执行adb命令；
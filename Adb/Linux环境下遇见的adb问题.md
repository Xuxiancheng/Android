# Linux环境下遇见的adb问题

## 1. no permissions问题

说明：连接安卓设备，并开启usb调试，使用adb devices发现显示出来的竟然是?????? no permissions

解决方法：

- 查看连接设备，记录设备ID号

```shell
lsusb

#运行lsusb命令，查看有哪些设备连接

# 结果

Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 0bda:0129 Realtek Semiconductor Corp. RTS5129 Card Reader Controller
Bus 001 Device 005: ID 0cf3:e005 Atheros Communications, Inc.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

> 如上则可以查看到新连接的Android设备信息，注意其ID号，这里是2207和0010

- 添加rules文件

```shell
cd /etc/udev/rules.d/
ls

# 结果如下,名称可能不同

51-android.rules

# 然后编辑该文件

sudo vim 51-android.rules

# 然后加入如下代码

SUBSYSTEM=="usb",ATTRS{idVendor}=="2207",ATTRS{idProduct}=="0010",MODE="0666"
```

> 这里2207和0010则分别是上一步中查看到的android设备的额ID信息，MODE应该是表示权限。

- 重启服务

```shell
sudo chmod a+rx /etc/udev/rules.d/51-android.rules
sudo service udev restart
```



## 2.adb devices为空

说明：运行adb devices列表为空，而lsusb却能看到已经连接的Android设备

解决方法：

```shell
# 编辑adb_usb.ini文件
sudo vim ~/.android/adb_usb.ini
# 加入 0x0bb4 然后执行
sudo service udev restart
android update adb
```

## 3.出现no permission的终极解决方法

出现这种情况的原因是当前用户没有权限，需要对adb命令进行提权操作

验证:

```shell
#首先杀掉adb service进程,否则影响后续adb的识别结果
adb kill-service

sudo -s

adb devices 
#adb会正常出现
```

解决方法:

```shell
which adb 

------------
/usr/lib/adb
------------

sudo chown  root.xxc adb

sudo chmod 6755  /usr/lib/adb
#提权操作

adb kill-server
```

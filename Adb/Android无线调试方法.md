# Android 无线调试方法

## 非ROOT手机

1. 首先保证电脑和手机在统一局域网.并知道手机的局域网 ip

2. 手机打开开发者选项中的usb调试

3. 输入以下命令:

```shell
adb tcpip 5555
adb connect <DEVICE_IP_ADDRESS>
```

4. 取消USB连接

   ```shell
   adb usb
   ```

   

## ROOT手机

1. 保证手机root

2. 手机与电脑在同一局域网内

3. 手机中有终端应用

   ```shell
   su           //获取root权限
   setprop service.adb.tcp.port 7890  //设置监听的端口，端口可以自定义，如7890，5555是默认的
   stop adbd    //关闭adbd
   start adbd   //重新启动adbd
   ```

4. 电脑中输入以下命令

   ```shell
   //手机的ip地址，假设为192.168.168.127
   adb connect 192.168.168.127：7890
   //如果不输入端口号，默认是5555，自定义的端口号必须写明，对应第1步中自定义的端口号，例如：192.168.168.127:7890
   ```

5.  配置成功，命令行显示：“connected to XXXXXXX”，然后就可以调试程序了
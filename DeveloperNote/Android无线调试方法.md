### Android 无线调试方法

1.首先保证电脑和手机在统一局域网.并知道手机的局域网 ip 

2.手机打开开发者选项中的usb调试

3.输入以下命令:

```shell
	adb tcpip 5555

    adb connect <DEVICE_IP_ADDRESS>
```

4.取消USB连接


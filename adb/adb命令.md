# adb命令

##  一.启动应用命令

```shell
adb shell monkey -p com.android.settings -c android.intent.category.LAUNCHER 1
//打开设置
adb shell am start -n com.android.settings/.Settings
//两者等价
```

## 二.settings命令

1.获取输入法

```shell
adb shell settings get secure default_input_method
//输出  com.sohu.inputmethod.sogouoem/.SogouIME  
```

2.修改默认输入法

```shell
adb shell settings put secure default_input_method    com.sohu.inputmothod.sougouem/.SougouIME
```

3.获取亮度是为自动获取

```shell
adb shell settings get system screen_brightness_mode
```

4.获取当前亮度

```shell
adb shell settings get system screen_brightness
```

5.更改亮度值

```shell
#亮度值在0-255之间
adb shell settings put system screen_brightness 150
```

6.获取屏幕休眠时间

```shell
adb shell settings get system screen_off_timeout
```

7.修改屏幕休眠时间

```shell
adb shell settings put system screen_off_timeout  600000
```


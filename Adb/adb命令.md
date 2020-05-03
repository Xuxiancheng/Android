# adb命令

## 一.启动应用命令

```shell
adb shell monkey -p com.android.settings -c android.intent.category.LAUNCHER 1
//打开设置
adb shell am start -n com.android.settings/.Settings
//两者等价
```

## 二.settings命令

1. 获取输入法

```shell
adb shell settings get secure default_input_method
//输出  com.sohu.inputmethod.sogouoem/.SogouIME  
```

2. 修改默认输入法

```shell
adb shell settings put secure default_input_method    com.sohu.inputmothod.sougouem/.SougouIME
```

3. 获取亮度是为自动获取

```shell
adb shell settings get system screen_brightness_mode
```

4. 获取当前亮度

```shell
adb shell settings get system screen_brightness
```

5. 更改亮度值

```shell
#亮度值在0-255之间
adb shell settings put system screen_brightness 150
```

6. 获取屏幕休眠时间

```shell
adb shell settings get system screen_off_timeout
```

7. 修改屏幕休眠时间

```shell
adb shell settings put system screen_off_timeout  600000
```

8. 修改Android高版本中的Wi-Fi有叉号的问题

```shell
adb shell settings put global captive_portal_https_url https://captive.v2ex.co/generate_204
```

> 默认的Android系统访问的特定服务器地址国内无法访问,出现x号

9. 获取当前应用的包名

```shell
adb shell dumpsys window | grep  mCurrentFocus | awk  '{print $3}'|awk -F / '{print $1}'
```
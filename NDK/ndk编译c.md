# NDK编译C说明

## 一.配置好NDK编译环境

## 二.编译C语言(无需Android Studio)

### 1. 建立目录,里面会包含C语言源文件及Android.mk文件

hello.c

``` c

    #include <stdio.h>
     
    int main()
    {
        printf("hello tubashu!\n");
        return 0;
    }

```

Android.mk

``` mk

LOCAL_PATH:=$(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE:=hello
LOCAL_SRC_FILES:=hello.c
include $(BUILD_EXECUTABLE)

```

### 2.编译C语言

进入到此目录下,命令行执行以下命令

``` shell

ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk

```

### 3.CPU架构查找

adb 命令输入

```

adb shell getprop |grep cpu

```

命令行显示

```

[ro.product.cpu.abi]: [arm64-v8a]
[ro.product.cpu.abilist]: [arm64-v8a,armeabi-v7a,armeabi]
[ro.product.cpu.abilist32]: [armeabi-v7a,armeabi]
[ro.product.cpu.abilist64]: [arm64-v8a]
[ro.vendor.product.cpu.abilist]: [arm64-v8a,armeabi-v7a,armeabi]
[ro.vendor.product.cpu.abilist32]: [armeabi-v7a,armeabi]
[ro.vendor.product.cpu.abilist64]: [arm64-v8a]

```
#!/bin/sh

echo "获取设备信息"

echo  "初始化中..."

adb devices

echo "############"

echo "品牌:"  ` adb shell getprop ro.product.brand`

echo "设备名：" `adb shell getprop ro.product.name`

echo "手机名称："  `adb shell getprop net.hostname`

echo "设备序列号:" `adb get-serialno`

echo  "CPU信息:"    `adb shell cat /proc/cpuinfo |grep Hardware |awk '{print $3}'`

echo "Wifi Mac地址:"  `adb shell "cat /sys/class/net/wlan0/address"`

echo "CPU 类型:"   `adb shell getprop ro.product.cpu.abi`

echo "Android Id:"  `adb shell settings get secure android_id`

echo "时区："  `adb shell getprop persist.sys.timezone`

echo "系统版本："  `adb shell getprop ro.build.software.version`

echo "sdk 版本："  `adb shell getprop ro.product.first_api_level`

echo "product.device："  `adb shell getprop ro.product.device`

echo  "型号 ："  `adb shell getprop ro.product.model`

echo "是否解锁：" `adb shell getprop ro.secureboot.lockstate`

echo "手机分辨率:"  `adb shell "dumpsys window | grep mUnrestrictedScreen"|awk '{print $2}'`
# adb shell  wm sizeadb shell settings get secure android_id

echo "手机物理密度:"   `adb shell wm density|awk '{print $3}'`

echo "当前手机电量:"  `adb shell dumpsys battery |grep level|awk '{print $2}'`

#可用feature
#adb shell pm list features  

echo "每个应用内存的上限:"  `adb shell getprop dalvik.vm.heapsize`

echo "安全补丁日期:"  `adb shell getprop ro.build.version.security_patch`
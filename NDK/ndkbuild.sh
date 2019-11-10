#!bin/sh

# $1 = c语言文件名(仅文件名,不带后缀)   $2 = C文件路径(路径名,无需带/)

 #编译的核心脚本
 build(){ 
   ndk-build NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk
 }

# 写入Android.mk文件
 writeMk(){
    echo "LOCAL_PATH:=\$(call my-dir)" >> $2/Android.mk
    echo "include \$(CLEAR_VARS)"      >> $2/Android.mk
    echo "LOCAL_MODULE:= $1"           >> $2/Android.mk
    echo "LOCAL_SRC_FILES:= $1.c"      >> $2/Android.mk 
    echo "include \$(BUILD_EXECUTABLE)">> $2/Android.mk
 }

 connectDevice(){

    echo "********设备名称************"

    echo "      `adb devices|busybox grep [0-9]|busybox awk '{print$1}'`"

    echo "*********设备CPU***********"

    cpu=`adb shell getprop ro.product.cpu.abi`

    echo "     ${cpu} "

    echo "******************************"
   
    
    #busybox find libs -name "arm64-v8a"  -exec echo {} \;

    adb push libs/${cpu}/$1  /data/local/tmp/ > /dev/null

    adb shell chmod +x /data/local/tmp/$1  > /dev/null

    adb shell ./data/local/tmp/$1

    echo "\n"
    
 }



echo "######## start build #########"

writeMk $1 $2

cd $2

build  > /dev/null

rm -rf  Android.mk

connectDevice $1

echo "########## build end ##########"


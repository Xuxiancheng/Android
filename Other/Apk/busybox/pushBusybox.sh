#!/bin/sh

##################################
#
#将busybox导入到手机的/data/local/tmp目录下
#
##################################


adb push busybox  /data/local/tmp
adb push sourceBusybox.sh  /data/local/tmp

adb shell 'chmod 777 /data/local/tmp/busybox'
adb shell 'sh /data/local/tmp/sourceBusybox.sh'
adb shell 'source /data/local/tmp/sourceBusybox.sh'

echo "进入到/data/local/tmp中使用source sourceBusybox.sh来激活alias"

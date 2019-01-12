#!/bin/sh

#####################
#
#git提交前的初始化操作
#1.删除无用的resource文件
#2.自动提交代码，以后可能要做的功能模块
#
#####################



#删除多余的resource文件
find . -name "*.resource"|xargs rm -rf

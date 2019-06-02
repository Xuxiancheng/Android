#!/bin/sh


#获取第三方app
getApp(){
    if test -e  ./app   
    then 
           echo "app文件已存在"
    else 
            mkdir app/
    fi
    get3AppList=`adb shell pm list packages -$1|awk -F  ":"   '{print $2}'`
    echo "############################################"
    echo "总数量:" `adb shell pm list packages -$1|awk -F  ":"   '{print $2}'|wc -l`
    echo "############################################"
    for s  in $get3AppList
    do  
        echo  ${s}
        pullApp  ${s}
    done
}

#将app拉取至本地
pullApp(){

        name=$1
        echo "获取:"${name}
        path=`adb shell pm path $1|awk -F ":" '{print $2}'`
        echo "${path}"
        #adb pull  ${path}   app/
        #mv  app/base.apk   app/${name}
        
}



###################################
# 获取手机上的app
# 1.获取手机上的第三方app    1
# 2.获取手机上的指定app         2
###################################
echo "##############初始化中...##########"
adb devices
echo "###############################"

if   test $1 -eq 1 
then 
    echo "############获取第三方app"
    getApp 3
    echo "############获取第三方app---完成"
elif  test $1 -eq 2
then
    echo "############获取系统app"
    getApp  s
    echo "############获取系统app-------完成"
else
    echo "输入参数错误"
     echo "输入   ./getApp.sh 1    获取第三方app"
     echo "输入   ./getApp.sh 2    获取系统app"
     echo "#########################"
fi

#!/bin/sh

#####################
#
#git提交前的初始化操作
#1.删除无用的resource文件
#2.自动提交代码，以后可能要做的功能模块
#
#####################

#提交函数
pushFun(){
    checkout_brance="xxc_$1_$2"
    echo $checkout_brance    
    git checkout -b $checkout_brance
    git add .
    git commit -m "$input"
    git checkout master
    git merge --no-ff $checkout_brance
    git status
    git push origin master
    git branch -d $checkout_brance
}


#删除多余的resource文件
#find . -name "*.resource"|xargs rm -rf

#echo "删除多余文件完成"

echo "正在拉取最新的仓库..."

git pull

echo "拉取最新仓库代码完成!"

echo "################################"

curtime=`date -u +%Y%m%d`

echo "当前日期:"$curtime

echo "################################"

git status  > /dev/null

echo "若不想提交，输入n:"

read -p "请填写提交的内容:---->" input

if [ "n"  = $input ]
then
	exit
fi

echo "提交内容为:---->"$input

read -p "确认是否提交:y&n---->" push

if [ "y" = $push ]
then 
	echo "开始提交!"
	pushFun $curtime $input
	echo "提交完成!"
else 
	exit
fi

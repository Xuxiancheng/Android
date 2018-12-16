### Git技巧

搜集些平时开发时遇见的问题及技巧

1.终端显示乱码

```shell
git config --global core.quotepath false
```

2.git 中有不想提交想忽略的文件

创建.gitignore文件，在文件夹中写入你想忽略的文件，然后再提交至git中即可


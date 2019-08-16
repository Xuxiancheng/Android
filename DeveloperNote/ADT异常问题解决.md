# ADT开发中碰见的异常问题

## 1. 错误：Failed to load E:\android\sdk\build-tools\28\lib\dx.jar

**原因:**

**eclipse自动使用最高版本的SDK，ADT比SDK版本低导致**

**解决方法:**

打开**project.properties** 文件，添加如下内容(版本号示具体情况):

sdk.buildtools=25.0.2     //设置sdk使用的buildtools版本  指定版本编译
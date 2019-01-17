#  引用Android库注意的问题

## Eclipse

#### 1.库中存在四大组件

ADT插件并不会自动合并 library 中的 AndroidManifest 文件，AndroidManifest.xml只有main project的有效，需要把Lib project的 AndroidManifest 里的权限和Activity申明都写道main project的AndroidManifest 里;

可在项目的project.properties文件中配置一下ADT才会合并 library 中的 AndroidManifest文件，如下：

```text
manifestmerger.enabled=true
//此属性需要 ADT 17 以上版本(但是我没试过)
```

#### 2.资源文件是否可以放在库项目中

可以应用lib project里res下面的资源，但是资源名字不能一样，否则只能用到main project下的资源

#### 3.库项目中存在引用外部的jar包

lib project有外部lib jar包时， main project也需要引入改jar包，但是在新版本的ADT中可以自动添加

#### 4.库项目中无法获取R.java文件问题

**lib project 的R文件不是final的，不能switch case来处理**

####  5.Library中的asset文件问题

ADT插件并不会自动将 library 里的 asset 资源合并到你的项目中，因此你需要手动拷贝

####  6.无法调用So文件问题

ADT插件不会自动导入 library 中 libs 目录下的 jar 包 或 so 文件( ADT 到 17 以上版本可自动导入)

所以最保险的方法是手动拷贝到main project项目中


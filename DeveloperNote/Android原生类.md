## 开发类

### 检查包签名

``` java
PackageManager.checkSignatures ();
```

### 开启Fragment的debug日志记录

``` java
FragmentManager.enableDebugLogging () ;
```

### 内存紧张时候Android系统回调此方法，可以在里面进行内存回收

``` java
onTrimMemory 
```

### SDK自带打印时间戳工具。可以分析某个方法执行的时间。用以性能分析。

``` java
TimingLogger timings = new TimingLogger(TAG, "methodA"); 
// ... do some work A ... 
timings.addSplit("work A");
// ... do some work B ... 
timings.addSplit("work B");
// ... do some work C ... 
timings.addSplit("work C");
timings.dumpToLog(); //输出到日志
------------------------------------------------------
The dumpToLog call would add the following to the log:
D/TAG ( 3459): methodA: begin 
D/TAG ( 3459): methodA: 9 ms, work A 
D/TAG ( 3459): methodA: 1 ms, work B 
D/TAG ( 3459): methodA: 6 ms, work C 
D/TAG ( 3459): methodA: end, 16 ms 
```

但是，使用的时候会发现，有可能打印不出log，没关系，在命令行输入这条命令：

``` shell
adb shell setprop log.tag.TAG VERBOSE  //注意这里的tag.后面跟的TAG需要和设置的一样
//这条命令的意思是，把TAG为timing的这条log级别设置为VERBOSE，在v以上的Log都能打印出来。
```

### 注册activity的生命周期方法回调。

``` java
Application.registerActivityLifecycleCallbacks 注册activity的生命周期方法回调。
可以用做全局Activity关闭管理，
获取栈顶Acitivity弹出提示框………………
```

### Log打印崩溃日志

``` java
Log.getStackTraceString()
```

> 方便的日志类工具,方法Log.v()、Log.d()、Log.i()、Log.w()和Log.e()都是将信息打印到LogCat中，有时候需要将出错的信息插入到数据库或一个自定义的日志文件中，那么这种情况就需要将出错的信息以字符串的形式返回来，也就是使用static String getStackTraceString(Throwable tr)方法的时候。

### 模拟睡眠与网络延迟

``` java
SystemClock.sleep() 这个方法在保证一定时间的 sleep 时很方便，通常我用来进行 debug 和模拟网络延时。
```

### ArrayList等替代方法

SparseArray——Map的高效优化版本。推荐了解姐妹类SparseBooleanArray、SparseIntArray和SparseLongArray。



## 格式化相关

### 格式化日期

``` java
DateUtils.formatDateTime()   格式化时间日期格式。
DateFormat.format("yyyy-MM-dd HH:mm:ss", System.currentTimeMillis()); 
DateFormat.format("yy/MM/dd", Calendar.getInstance());
DateFormat.format("yyyy", new Date(2016,11,17));
```

### 格式化文件大小

把文件大小转换为KB，MB，GB这样的字符串,但是要注意输入的最大值是long.max_value

``` java
Formatter.formatFileSize()
```

### 电话号码格式化

``` java
PhoneNumberUtils.formatNumber ()
```

## 日期工具

Android本身提供的日期时间工具类，里面有很多实用的工具集合。

``` java
DateUtils.isToady()   判断传入的日期时间是否为当天。
  
DateUtils.getRelativeTimeSpanString  可以计算时间间隔比如“几天前”，“几个月前”，等等  
```

## 存储相关

``` java
Context.getCacheDir() 获取系统默认的缓存路径。
  
ActivityManager.clearApplicationUserData() 清理用户产生的数据。恢复的干净的初始阶段。  
```

## 文字相关

``` java
Linkify.addLinks() 为一个TextView添加链接。
  
TextUtils.isEmpty()  判空 同java中StringUtils.isEmpty()
  
UrlQuerySanitizer 对一个URL链接进行检查和数据提取、解析等。  
```

## 控件相关

```java
AutoScrollHelper 在滚动View中长按边缘滚动工具类。
  
ViewStub初始化阶段不加载任何View，然而随后以加载开发者给定布局文件。在懒加载 模式的View初始化过程中适合占位。
  
ThumbnailUtils 处理缩略图，可以处理本地视频获取第一针图片
  
android:weightSum 控制根布局总的权重和。(不常用)线性布局权重子控件直接设置亦可
  
ValueAnimator.reverse() 取消正在执行的动画。  
  
TextView.setError() 在验证用户输入的时候很棒。  
  
ActionBar.hide()/.show()顾名思义，隐藏和显示ActionBar，可以优雅地在全屏和带Actionbar之间转换。
  
Activity.onBackPressed()很方便的管理back键的方法，有时候需要自己控制返回键的事件的时候，可以重写一下。比如加入 “点两下back键退出” 功能。  
```

## 排序

``` java
AlphabetIndexer 字母索引类。 
SortedList 排序列表。
```

## 事务相关

(触摸，点击事件分发……)

```java
android:duplicateParentState="true"  子View跟随其Parent的状态，如按击等。比如某个按钮很小，想要扩大其点击区域，通常会再给其包裹一层布局，将点击事件写到Parent上，这时候如果希望被包裹按钮的点击效果对应的Selector继续生效，就这么做。
  
getParent().requestDisallowInterceptTouchEvent(true) 屏蔽父view对事件的拦截处理。
  
HandlerThread 用以实现常见的Thread+Handler模型实现的复合型类。  
  
PackageManager.setComponentEnabledSetting()——可以用来启动或者禁用程序清单中的组件。对于关闭不需要的功能组件是非常赞的，比如关掉一个当前不用的广播接收器。  
```

## 界面相关

### 过渡

``` java
android:animateLayoutChanges="true" 使布局中的某些子view的消失和增加具有动画平滑过渡效果。
  
SurfaceView.getHolder().setFormat(PixelFormat.TRANSLUCENT) 设置SurfaceView透明。
  
ArgbEvaluator.evaluate(float fraction, Object startValue, ObjectendValue) 颜色渐变，常见于导航栏、标题栏的颜色。  
```

### Fragment

``` java
FragmentManager.enableDebugLogging () 开启Fragment的debug日志记录。**
```

Fragment的setUserVisibleHint 在这个方法里面可以实现Fragment的懒加载，比如：

``` java
@Override  
public void setUserVisibleHint(boolean isVisibleToUser) {   
       if (isVisibleToUser) {  
             //加载
        } else {  
             //不加载
        }  
}  
```

### 强制重建Activity

``` java
Activity.recreate ()——强制让 Activity 重建。
```


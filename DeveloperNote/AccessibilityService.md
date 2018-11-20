## AccessibilitService学习
### 什么是辅助功能
辅助功能（AccessibilityService）是一个Android系统提供的一种服务，继承自Service类。AccessibilityService运行在后台，能够监听系统发出的一些事件(AccessibilityEvent)，这些事件主要是UI界面一系列的状态变化，比如按钮点击、输入框内容变化、焦点变化等等，查找当前窗口的元素并能够模拟点击等事件。[官网文档](https://developer.android.com/guide/topics/ui/accessibility/services)

>几个比较重要的类:
>
>AccessibilityService 
>继承自Service服务，所以说就是一个服务，不过是由系统来start，我们不能手动配置，所以之后配置要指定action和permission
>
>AccessibilityServiceInfo 
>把你要监控的配置相关的信息封装成一个对象，可以有两种设置方式，一个是代码设置(setServiceInfo(AccessibilityServiceInfo))，另一个是通过xml指定(推荐)。
>
>AccessibilityEvent 
>看成一个封装好的事件，在AccessibilityService的重写方法中作为参数传回来，包含当前的所有事件，你只需要解这个对象就可以得到你想要的信息啦
>
>AccessibilityNodeInfo 
这个对象封装的是节点信息，说白了就是得到一个控件树，也可以代表一个控件，重点关注对象，是通过AccessibilityEvent取到的


### 如何使用
AccessibilityService很简单，一般只需要三部就可以使用:
#### 1.继承系统AccessibilityService
```java
public class MyAccessibility extends AccessibilityService {

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        //系统定时回调函数，会把屏幕信息不断送给你
    }

    @Override
    public void onInterrupt() {
    	//中断处理的回调
    }
}
```
**必须继承的类 AccessibilityService**
#### 2.xml配置文件
在资源目录res下新建xml文件夹，新建accessibility.xml文件，写入：
```xml
<?xml version="1.0" encoding="utf-8"?>
<accessibility-service xmlns:android="http://schemas.android.com/apk/res/android"
                       android:accessibilityEventTypes="typeAllMask"
                       android:description="辅助功能的描述"
                       android:accessibilityFeedbackType="feedbackSpoken"
                       android:canRetrieveWindowContent="true"
                       android:notificationTimeout="1000"/>
```
>放在Android项目的res目录下的xml下，否则Android studio识别不到

  .  description 为 用户允许应用的辅助功能的说明字符串
  
  .  packageNames，当没有指定时，默认辅助所有的应用，如指定需要监听的包名（你可以通过|来进行分隔）
  
  .  typeAllMask是设置响应事件的类型
  
  .  feedbackGeneric是设置回馈给用户的方式，有语音播出和振动


#### 3. 注册
在AndroidMainifest中注册：
```xml
<service
    android:name=".MyAccessibility"
    android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE">
    <intent-filter>
        <action android:name="android.accessibilityservice.AccessibilityService"/>
    </intent-filter>

    <meta-data
        android:name="android.accessibilityservice"
        android:resource="@xml/accessibility"/>
</service>
```
> android:name=".MyAccessibility" 自己重写的服务名称
> 
> android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE" 权限
>
>android:resource="@xml/accessibility" 配置文件

到此为止就可以使用辅助功能了！

### 重要的代码

```java
/**
     * Check当前辅助服务是否启用
     *
     * @param serviceName serviceName
     * @return 是否启用
     */
    private boolean checkAccessibilityEnabled(String serviceName) {
        List<AccessibilityServiceInfo> accessibilityServices =
                mAccessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_GENERIC);
        for (AccessibilityServiceInfo info : accessibilityServices) {
            if (info.getId().equals(serviceName)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 前往开启辅助服务界面
     */
    public void goAccess() {
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        mContext.startActivity(intent);
    }

    /**
     * 模拟点击事件
     *
     * @param nodeInfo nodeInfo
     */
    public void performViewClick(AccessibilityNodeInfo nodeInfo) {
        if (nodeInfo == null) {
            return;
        }
        while (nodeInfo != null) {
            if (nodeInfo.isClickable()) {
                nodeInfo.performAction(AccessibilityNodeInfo.ACTION_CLICK);
                break;
            }
            nodeInfo = nodeInfo.getParent();
        }
    }

    /**
     * 模拟返回操作
     */
    public void performBackClick() {
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        performGlobalAction(GLOBAL_ACTION_BACK);
    }
```




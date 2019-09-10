# Handler的正确用法

## 一.什么是内存泄漏

> 1. 内存泄漏的定义:本该被回收的对象不能被回收而停留在内存中。
> 2. 内存泄漏出现的原因: 当一个对象已经不能被使用时，本该被回收但却应为有另一个正在使用的对象持有它的引用而导致它不能被回收。这就导致了内存泄漏。

## 二.Handler的一般用法

1. 使用内部类
2. 匿名内部类

在平常的使用过程中这两种方式用到的都比较多，在此不做赘述。

两种方式虽然都可以运行成功，但是这两种方式代码会出现严重警告:

> 1. ⚠️警告的原因 = 该Handler类由于未设置为静态类，从而有内存泄漏的风险
> 2. 最终额内存泄漏发生在handler类的外部类:MainActivity类（Handler所在的类中）

![](https://user-gold-cdn.xitu.io/2018/1/25/1612ab4656582136?imageView2/0/w/1280/h/960/ignore-error/1)

相信上述的图片在使用过程中都会遇到过吧！

## 三.原因分析

### 储备知识

* 主线程的Looper对象的生命周期 = 该应用程序的生命周期
* 在Java中，**非静态内部类**&**匿名内部类**都默认持有外部类的引用

### 原因描述

1. 一般而言，如果等待handler处理完成所有的程序或者没有处理时，此时如果推出当前的activity，

由于没有持有外部类的引用，所以便会正常处理，引用都会最终销毁。

![](https://user-gold-cdn.xitu.io/2018/1/25/1612ab4657b6d030?imageView2/0/w/1280/h/960/ignore-error/1)


2. 如果当handler正在处理消息或者还有未处理的消息时,此时若是推出当前的activity，则由于相互引用的关系，

垃圾回收器无法回收，从而导致了内存泄漏。

![](https://user-gold-cdn.xitu.io/2018/1/25/1612ab4658738bd8?imageView2/0/w/1280/h/960/ignore-error/1)

#### 总结:

* 当handler消息队列还有未处理的消息或者正在处理消息时,存在引用关系: "未被处理/正在处理的消息-->Handler实例

---> 外部类"。

* 若出现Handler的生命周期>外部的生命周期时(即Handler消息队列中还有未处理的消息/正在处理的消息，而外部类需要销毁时),将使得外部类无法被垃圾回收器回收♻️，从而造成内存泄漏。

## 四.解决方案

从上面的分析中可以看出，造成内存泄漏的原因无外乎两个:

1. Handler消息队列中有未处理的消息
2. Handler消息队列中有正在处理的消息

解决的方法就是让上述的条件不成立即可。

### 解决方案1 当外部类的生命周期结束时，清空Handler中的消息队列

* 不仅使得“未被处理 / 正处理的消息 -> Handler实例 -> 外部类” 的引用关系 不复存在，同时 使得 Handler的生命周期（即 消息存在的时期） 与外部类的生命周期同步

* 具体方案 当 外部类（此处以Activity为例） 结束生命周期时（此时系统会调用onDestroy（）），清除 Handler消息队列里的所有消息（调用removeCallbacksAndMessages(null)）

``` java
@Override
    protected void onDestroy() {
        super.onDestroy();
        mHandler.removeCallbacksAndMessages(null);
        // 外部类Activity生命周期结束时，同时清空消息队列 & 结束Handler生命周期
    }

```

### 解决方案2 静态内部类及弱引用 **推荐使用**

* 原理 静态内部类 不默认持有外部类的引用，从而使得 “未被处理 / 正处理的消息 -> Handler实例 -> 外部类” 的引用关系 的引用关系 不复存在。

* 具体方案 将Handler的子类设置成 静态内部类

> 1. 同时，还可加上 使用WeakReference弱引用持有Activity实例
> 2. 原因：弱引用的对象拥有短暂的生命周期。在垃圾回收器线程扫描时，一旦发现了只具有弱引用的对象，不管当前内存空间足够与否，都会回收它的内存

``` java
 static class MyHandler extends Handler {

        WeakReference<MainActivity> activityWeakReference ;

        private MyHandler(MainActivity activity) {
            activityWeakReference = new WeakReference<>(activity);
        }

        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);
            final MainActivity activity = activityWeakReference.get();
            if (activity == null || activity.isFinishing()) {
                return;
            }
            if (msg.what==1){
                activity.i = activity.i + 10;
                activity.progressBar.setProgress(activity.i);
            }
        }

    }
```
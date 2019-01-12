# Android 样式开发：SHAPE

1. 位置

##### 一般用shape定义的xml文件存放在drawable目录下，若项目没有该目录则新建一个，而不要将它放到drawable-hdpi等目录中。

2. 作用

##### 使用shape可以自定义形状，可以定义下面四种类型的形状，通过android:shape属性指定：
 .  rectangle: 矩形，默认的形状，可以画出直角矩形、圆角矩形、弧形等
 
 .  oval: 椭圆形，用得比较多的是画正圆
 
 .  line: 线形，可以画实线和虚线
 
 .  ring: 环形，可以画环形进度条
 
 3. 详细

>### rectangle 默认的形状，也是用的最多的


 ##### solid: 设置形状填充的颜色，只有android:color一个属性
 
>android:color 填充的颜色

##### padding: 设置内容与形状边界的内间距，可分别设置左右上下的距离

>android:left 左内间距
>
>android:right 右内间距
>
>android:top 上内间距
>
>android:bottom 下内间距

##### gradient: 设置形状的渐变颜色，可以是线性渐变、辐射渐变、扫描性渐变

>android:type 渐变的类型
>
>linear 线性渐变，默认的渐变类型
>
>radial 放射渐变，设置该项时，android:gradientRadius也必须设置
>
>sweep 扫描性渐变
>
>android:startColor 渐变开始的颜色
>
>android:endColor 渐变结束的颜色
>
>android:centerColor 渐变中间的颜色
>
>android:angle 渐变的角度，线性渐变时才有效，必须是45的倍数，0表示从左到右，90表示从下到上
>
>android:centerX 渐变中心的相对X坐标，放射渐变时才有效，在0.0到1.0之间，默认为0.5，表示在正中间
>
>android:centerY 渐变中心的相对X坐标，放射渐变时才有效，
在0.0到1.0之间，默认为0.5，表示在正中间
>
>android:gradientRadius 渐变的半径，只有渐变类型为radial时才使用
>
>android:useLevel 如果为true，则可在LevelListDrawable中使用

##### corners: 设置圆角，只适用于rectangle类型，可分别设置四个角不同半径的圆角，当设置的圆角半径很大时，比如200dp，就可变成弧形边了

>android:radius 圆角半径，会被下面每个特定的圆角属性重写
>
>android:topLeftRadius 左上角的半径
>
>android:topRightRadius 右上角的半径
>
>android:bottomLeftRadius 左下角的半径
>
>android:bottomRightRadius 右下角的半径

##### stroke: 设置描边，可描成实线或虚线

>android:color 描边的颜色
>
>android:width 描边的宽度
>
>android:dashWidth 设置虚线时的横线长度
>
>android:dashGap 设置虚线时的横线之间的距离

4. 实际运用

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- android:shape指定形状类型，默认为rectangle -->
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <!-- solid指定形状的填充色，只有android:color一个属性 -->
    <solid android:color="#2F90BD" />
    <!-- padding设置内容区域离边界的间距 -->
    <padding
        android:bottom="12dp"
        android:left="12dp"
        android:right="12dp"
        android:top="12dp" />
    <!-- corners设置圆角，只适用于rectangle -->
    <corners android:radius="200dp" />
    <!-- stroke设置描边 -->
    <stroke
        android:width="2dp"
        android:color="@android:color/darker_gray"
        android:dashGap="4dp"
        android:dashWidth="4dp" />
</shape>
```

> ### oval

oval用来画椭圆，而在实际应用中，更多是画正圆，比如消息提示，圆形按钮等

>注意，使用radial渐变时，必须指定渐变的半径，即android:gradientRadius属性。

```xml
<?xml version="1.0" encoding="utf-8"?>
<!-- android:shape指定形状类型，默认为rectangle -->
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="oval">
    <!-- padding设置内间距 -->
    <padding
        android:bottom="4dp"
        android:left="4dp"
        android:right="4dp"
        android:top="4dp" />
    <!-- size设置形状的大小 -->
    <size
        android:width="40dp"
        android:height="40dp" />
    <!-- gradient设置渐变 -->
    <gradient
        android:endColor="#000000"
        android:gradientRadius="40dp"
        android:startColor="#FFFFFF"
        android:type="radial" />
</shape>

```
 
 
 >### line

line主要用于画分割线，是通过stroke和size特性组合来实现的

```xml
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="line">
    <!-- 实际显示的线 -->
    <stroke
        android:width="1dp"
        android:color="#2F90BD"
        android:dashGap="2dp"
        android:dashWidth="4dp" />
    <!-- 形状的高度 -->
    <size android:height="4dp" />
</shape>
```

>注意点：
>
>    . 只能画水平线，画不了竖线；
>    
>    . 线的高度是通过stroke的android:width属性设置的；
>    
>    . size的android:height属性定义的是整个形状区域的高度；
>    
>    . size的height必须大于stroke的width，否则，线无法显示；
>    
>    . 线在整个形状区域中是居中显示的；
>    
>    . 线左右两边会留有空白间距，线越粗，空白越大；
>    
>    . 引用虚线的view需要添加属性android:layerType，值设为"software"，否则显示不了虚线。


### ring
 首先，shape根元素有些属性只适用于ring类型，先过目下这些属性吧：

    android:innerRadius 内环的半径
    android:innerRadiusRatio 浮点型，以环的宽度比率来表示内环的半径，默认为3，表示内环半径为环的宽度除以3，该值会被android:innerRadius覆盖
    android:thickness 环的厚度
    android:thicknessRatio 浮点型，以环的宽度比率来表示环的厚度，默认为9，表示环的厚度为环的宽度除以9，该值会被android:thickness覆盖
    android:useLevel 一般为false，否则可能环形无法显示，只有作为LevelListDrawable使用时才设为true



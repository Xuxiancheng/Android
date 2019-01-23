## 过时API的替换方法

### 获取图片资源过时方法替换

```java
Drawable drawable = ContextCompat.getDrawable(context,R.drawable.img); //recommend

Drawable getDrawable(int id, Resources.Theme theme);// above API19  , 第二个参数@theme可以为空值.或Context.getDrawable(int)
```

### 获取屏幕宽高过时方法替换

```java
WindowManager manager = this.getWindowManager();

DisplayMetrics outMetrics = new DisplayMetrics();

manager.getDefaultDisplay().getMetrics(outMetrics);

int width2 = outMetrics.widthPixels;

int height2 = outMetrics.heightPixels;

//或者：

Resources resources = this.getResources();

DisplayMetrics dm = resources.getDisplayMetrics();

float density1 = dm.density;

int width3 = dm.widthPixels;

int height3 = dm.heightPixels;
```

### getColor 过时的替代方法

```java
ContextCompat.getColor(context, R.color.color_name)l
```
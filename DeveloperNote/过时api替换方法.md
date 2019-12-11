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

//或者
DisplayMetrics dm = new DisplayMetrics();
this.getWindowManager().getDefaultDisplay().getMetrics(dm);
int width = dm.widthPixels;
int height = dm.heightPixels;

//或者
Displaydisplay = getWindowManager().getDefaultDisplay();
Point size = newPoint();
display.getSize(size);
width = size.x;
height = size.y;
```

### getColor 过时的替代方法

```java
ContextCompat.getColor(context, R.color.color_name)l
```

### BitDrawabel 过时方法替代

在popupWindow中使用此方法创建一个空白的背景时显示过时

```
popupWindow.setBackgroundDrawable(new Drawable(andorid.graphics.Color.WHITE));
//android.graphics.Color.TRANSPARENT
```

### ViewPager中的setOnPageChangeListener 方法替代

```java
mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
@Override
public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

}

@Override
public void onPageSelected(int position) {
    selectedTab(position);
}

@Override
public void onPageScrollStateChanged(int state) {

}
});
```


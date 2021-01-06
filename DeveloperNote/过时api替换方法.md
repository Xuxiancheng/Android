## 过时API的替换方法

### 获取图片资源过时方法替换

```java
Drawable drawable = ContextCompat.getDrawable(context,R.drawable.img); //recommend

Drawable getDrawable(int id, Resources.Theme theme);// above API19  , 第二个参数@theme可以为空值.或Context.getDrawable(int)
```

### 获取屏幕宽高过时方法替换

```java
	public static Point getSizeNew(Context ctx) {
		WindowManager wm = (WindowManager) ctx.getSystemService(Context.WINDOW_SERVICE);
		DisplayMetrics dm = new DisplayMetrics();
		wm.getDefaultDisplay().getMetrics(dm);
		Point size = new Point();
		size.x = dm.widthPixels;
		size.y = dm.heightPixels;
		return size;
	}
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


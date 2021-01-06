##  res目录结构

res是Android项目工程中存放各类的目录，主要包括布局、图形与配置等等。res的子目录主要有：

1. anim : 存放动画的描述文件 
2. drawable :  存放各类图形的描述文件，包括drawable的描述文件，以及三种图片格式：png（推荐）、jpg（支持）、gif（不推荐，因为ImageView只显示gif的第一帧）。以drawable打头的有好几个目录，分别存放不同分辨率的图片。
3. layout : 存放页面的布局文件，主要在Acitivity、Fragment以及部分自定义控件中使用 
4. menu : 存放菜单的布局文件 
5. raw : 存放原始格式的文件，一般是二进制的流文件，比如音频文件、视频文件等等 
6. values : 存放各类参数的配置文件，具体的配置文件说明如下 :
 ——arrays.xml : 存放各类数组的定义文件，字符串数组的根节点为string-array，整型数组的根节点为integer-array 
 ——booleans.xml : 存放布尔类型的定义文件，根节点为resources，元素节点为bool 
 ——attrs.xml : 存放自定义控件的属性信息，根节点为resources，元素节点为declare-styleable——attr 
 ——colors.xml : 存放颜色的定义文件，根节点为resources，元素节点为color 
 ——dimens.xml : 存放像素的定义文件，根节点为resources，元素节点为dimen 
 ——ids.xml : 存放控件id的定义文件，根节点为resources，元素节点为item，type为id 
 ——integers.xml : 存放整数类型的定义文件，根节点为resources，元素节点为integer 
 ——strings.xml : 存放字符串类型的定义文件，根节点为resources，元素节点为string 
 ——styles.xml : 存放控件风格的定义文件，根节点为resources，元素节点为style——item 
7. xml : 存放其他的xml文件，比如说存放SearchView的searchable.xml属性定义文件

## 代码获取res配置

anim、layout、menu这三个目录下分别是动画、页面和菜单的描述文件，在代码中不会解析出具体的数据结构，使用时只需在调用处填写描述文件的资源id，如R.anim.example、R.layout.example、R.menu.example。 



其余目录下面的配置文件，一般需要在代码中解析数据结构，比如说图像、字符串、整型数、二进制流等等。具体的代码调用方式如下：

 drawable : 一般使用`getResources().getDrawable(R.drawable.example);`，

​						gif文件使用`getResources().getMovie(R.drawable.example); `
 		

raw : `getResources().openRawResource(R.raw.example); `



values : 
 ——arrays.xml : 解析字符串数组使用`getResources().getStringArray(R.array.city);`，

​						解析整型数组使用`getResources().getIntArray(R.array.code); `
 ——attrs.xml : 代码中不解析该文件的数据结构，在自定义控件的构造函数中通过如下方式使用：

`TypedArray  attrArray=getContext().obtainStyledAttributes( attrs,  R.styleable.example); `
 ——booleans.xml : `getResources().getBoolean(R.bool.example); `
 ——colors.xml : `getResources().getColor(R.color.example); `
 ——dimens.xml :` getResources().getDimension(R.dimen.example); `
 ——ids.xml : 代码中不使用该文件配置，在布局文件中使用为：android:id="@id/..."（注意与一般情况相比去掉了加号） 
 ——integers.xml : `getResources().getInteger(R.integer.example); `
 ——strings.xml : `getResources().getString(R.string.example); `
 ——styles.xml : 代码中不解析该文件的数据结构，布局文件的使用在控件内部加上style属性：style="@style/example" 
	  

 xml :` getResources().getXml(R.xml.example);`



## assets目录下的文件读取

assets目录用于存放应用程序的资产文件，该目录下的文件不会被系统编译，所以无法通过R.*.*这种方式来访问。Android专门为assets目录提供了一个工具类AssetManager，通过该工具，我们能够以字节流方式打开assets下的文件，并将字节流转换为文本或者图像。

AssetManager提供了如下方法用于处理assets： 
 1、 String[] list(String path); 
 列出该目录下的下级文件和文件夹名称 
 2、 InputStream open(String fileName); 
 以顺序读取模式打开文件，默认模式为ACCESS_STREAMING 
 3、 InputStream open(String fileName, int accessMode); 
 以指定模式打开文件。读取模式有以下几种： 
 ACCESS_UNKNOWN : 未指定具体的读取模式 
 ACCESS_RANDOM : 随机读取 
 ACCESS_STREAMING : 顺序读取 
 ACCESS_BUFFER : 缓存读取 
 4、 void close() 
 关闭AssetManager实例

## assets下的文件操作

assets目录下主要存放四种文件：文本文件、图像文件、网页文件（包括html中引用的js/ccs/jpg等资源）、音频视频文件 



 文本文件的读取操作：使用InputStream的read方法读出字节数组，然后按照指定字符编码将其转换为字符串。 
 		 图像文件的读取操作：使用BitmapFactory的decodeStream方法，将字节流转化为位图。 
		  网页文件的读取操作：使用WebView的loadUrl方法，直接将网页文件加载到WebView控件中。 
		  音频视频文件的读取操作：暂无

``` java
	private String getTxtFromAssets(String fileName) {
		String result = "";
		try {
			InputStream is = getAssets().open(fileName);
			int lenght = is.available();
			byte[]  buffer = new byte[lenght];
			is.read(buffer);
			result = new String(buffer, "utf8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private Bitmap getImgFromAssets(String fileName) {
		Bitmap bitmap = null;
		try {
			InputStream is = getAssets().open(fileName);
			bitmap = BitmapFactory.decodeStream(is);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bitmap;
	}
```
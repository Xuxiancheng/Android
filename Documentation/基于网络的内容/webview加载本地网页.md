# WebView加载本地网页

核心代码

``` Java
 WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setAllowContentAccess(true);
        webSettings.setSupportZoom(false);
        webSettings.setBlockNetworkImage(false);
				webview.setHorizontalScrollBarEnable(false);
				webview.setVerticalScrollBarEnable(false);
//这是放在相对路径下或绝对路径下
//        webView.loadDataWithBaseURL("/sdcard/Download", "", "text/html", "utf-8", null);
//这是放在assets目录中
        webView.loadDataWithBaseURL("file:android_asset/",readFile(),"text/html"
            ,"utf-8",null);
```

> 在网页中图片的路径一定要加file://前缀，否则无法识别路径!

禁止webview左右滑动,重写了`onScrollChanged`方法

``` java
public class MyWebView extends WebView{
    public MyWebView(Context context) {
        super(context);
    }

    public MyWebView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyWebView(Context context, AttributeSet attrs, int defStyleAttr）{
        super(context, attrs, defStyleAttr);
    }
    //重写onScrollChanged 方法
    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);
        scrollTo(l,0);
    }
} 
```

上面重写了onScrollChanged 方法当webview 滚动的时候回调，在方法中我们可以调用scrollTo(x,y) 来控制其滚动到某个位置。

> ##### 禁止左右滚动：在onScrollChanged中设置 scrollTo(0,y)
>
> ##### 禁止上下滚动：在onScrollChanged中调用 scrollTo(x,0)

网页中的图片自适应

``` html
<img style="max-width:100%;height:auto" src="file///sdcard/1.png" />
```

webview 销毁

由于WebView是依附于Activity的，Activity的生命周期和WebView启动的线程的生命周期是不一致的，这会导致WebView一直持有对这个Activity的引用而无法释放

在 Activity销毁WebView的时，需要在onDestroy()中：先让WebView加载null内容，再移除WebView，然后再将WebView.destroy()，最后WebView置空。

``` java
@Override 
protected void onDestroy() {  
    if (mWebView != null) {
        mWebView.loadDataWithBaseURL(null, "", "text/html", "utf-8", null); 
        mWebView.clearHistory(); 
        mLayout.removeView(mWebView); 
         mWebView.destroy(); 
         mWebView = null; 
    } 
        super.onDestroy(); 
}
```


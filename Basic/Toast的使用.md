# Toast的使用方式
> Toast只能用来显示，而不能用于任何点击操作
> 如果需要点击操作，建议学习 Snackbar
> 官方也支持使用Snackbar
*********************
## 代码

### １．自定义shape

```xml
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android">

    <solid android:color="#BADB66" />

    <stroke android:width="1px"
        android:color="#FFFFFF"
        />

    <corners
        android:radius="50px"
        />

    <padding android:bottom="5dp"
        android:left="5dp"
        android:right="5dp"
        android:top="5dp"
        />

</shape>
```

### 2.自定义布局
```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="horizontal"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:id="@+id/lly_toast"
    android:background="@drawable/toast_shape"
    >


    <ImageView
        android:id="@+id/image"
        android:layout_width="24dp"
        android:layout_height="24dp"
        android:layout_marginLeft="10dp"
        android:src="@mipmap/ic_launcher"
        />

    <TextView
        android:id="@+id/text"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:layout_marginLeft="10dp"
        android:textSize="20sp"
        />

</LinearLayout>
```
注意此处的　android:id="@+id/lly_toast"，这是必须有的


### 3.java代码
```java
package com.example.xxc.toast;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.example.xxc.layouts.R;

public class ToastDemo extends AppCompatActivity {

    private Button button;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        init();
    }

    private void init(){
        button=findViewById(R.id.button);

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                firstShowToast(ToastDemo.this,"hello",Toast.LENGTH_SHORT);
//                secondShowToast(ToastDemo.this,"hello",Toast.LENGTH_SHORT);
                customeToast(ToastDemo.this,"hello",Toast.LENGTH_SHORT);
            }
        });
    }

    /**
     * 第一种自定义方式 ,定义位置
     * @param mContext
     * @param str
     * @param showTime  显示时间，只能是ＬＯＮＧH和SHORT两种
     */
    private void firstShowToast(Context mContext, String str, int showTime){
        Toast toast=Toast.makeText(mContext,str,showTime);
        toast.setGravity(Gravity.CENTER_VERTICAL|Gravity.CENTER_HORIZONTAL,0,0);
        TextView textView=toast.getView().findViewById(android.R.id.message);
        toast.show();
    }

    /**
     * 第二种自定义方式，自定义图片
     * @param mContext
     * @param str
     * @param showTime
     */
    private void secondShowToast(Context mContext,String str,int showTime){

        Toast toast=Toast.makeText(mContext,str,showTime);
        toast.setGravity(Gravity.CENTER_HORIZONTAL|Gravity.BOTTOM,0,0);
        LinearLayout layout= (LinearLayout) toast.getView();
        ImageView imageView=new ImageView(this);
        imageView.setImageResource(R.mipmap.ic_launcher);
        layout.addView(imageView);
//        TextView textView=toast.getView().findViewById(android.R.id.message);
        toast.show();
    }


    /**
     * 完全自定义
     * @param string
     * @param time
     */
    private void customeToast(Context mContext,String string,int time){
//        LayoutInflater layoutInflater=getLayoutInflater();
//        View view=layoutInflater.inflate(R.layout.view_toast_custom,(ViewGroup)findViewById(R.id.lly_toast));

        View view=LayoutInflater.from(mContext).inflate(R.layout.view_toast_custom,
                (ViewGroup)findViewById(R.id.lly_toast));

        ImageView imageView=view.findViewById(R.id.image);
        TextView textView=view.findViewById(R.id.text);
        textView.setText(string);
        Toast toast=new Toast(mContext);
        toast.setGravity(Gravity.CENTER,0,0);
        toast.setDuration(time);
        toast.setView(view);
        toast.show();
    }
}

```

# GridView学习笔记
1.介绍
多控件布局，与listview一样都是可以在有限的空间布局中显示更多的数据，
gridview多用于网格式的布局，像九宫格布局是最常见的。
2.使用步骤
. 布局中添加控件，设置属性(也可以在代码中设置)
. 自定义适配器(自定义布局)
. 设置适配器

3.属性
```
numColumns="auto_fit"     //GridView的列数设置为自动

verticalSpacing="10dp"    //两行之间的边距

horizontalSpacing="10dp"  //两列之间的边距

scrollbars="none"         //隐藏GridView的滚动条

listSelector="@android:color/transparent"  
//选择时的背景颜色，一般设置成透明的格式

columnWidth=”90dp "      //每列的宽度，也就是Item的宽度

stretchMode=”columnWidth"//缩放与列宽大小同步

cacheColorHint="#00000000" //去除拖动时默认的黑色背景

fadeScrollbars="true" //为true实现滚动条的自动隐藏和显示

fastScrollEnabled="true" //GridView出现快速滚动的按钮
(至少滚动4页才会显示)

fadingEdge="none" //GridView衰落(褪去)边缘颜色为空，缺省值是vertical。(可以理解为上下边缘的提示色)

fadingEdgeLength="10dip" //定义的衰落(褪去)边缘的长度

stackFromBottom="true" //设置为true时，你做好的列表就会显示你列表的最下面

stackFromBottom="true" //设置为true时，你做好的列表就会显示你列表的最下面

transcriptMode="alwaysScroll" //当你动态添加数据时，列表将自动往下滚动最新的条目可以自动滚动到可视范围内

drawSelectorOnTop="false" //点击某条记录不放，颜色会在记录的后面成为背景色,内容的文字可见(缺省为false)
```
4.具体用法
1.gridview布局
``` xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:background="#EEEEEE"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <GridView
        android:layout_margin="10dp"
        android:id="@+id/help_gridview_layout"
        android:layout_height="match_parent"
        android:layout_width="match_parent"
        android:numColumns="auto_fit"
        android:elevation="3dp"
        android:verticalSpacing="10dp"
        android:horizontalSpacing="10dp"
        android:scrollbars="none"
        android:listSelector="@android:color/transparent"
        />
</LinearLayout>
```

2.griditem
```java
package com.example.xxc.gridview;

public class GridItem {

    private String imgContent;

    private int imgSrc;

    public String getImgContent() {
        return imgContent;
    }

    public int getImgSrc() {
        return imgSrc;
    }

    public void setImgContent(String imgContent) {
        this.imgContent = imgContent;
    }

    public void setImgSrc(int imgSrc) {
        this.imgSrc = imgSrc;
    }

}

```


3.adapter
```java
package com.example.xxc.gridview;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.xxc.studydemo.R;

import java.util.ArrayList;

public class HelpGridViewAdapter  extends BaseAdapter {

    private Context mContext;

    private ArrayList<GridItem> gridItemArrayList = null;



    public HelpGridViewAdapter(Context mContext,ArrayList<GridItem> gridItemArrayList){

        this.mContext = mContext;

        this.gridItemArrayList = gridItemArrayList;

    }

    @Override
    public int getCount() {
        return gridItemArrayList.size();
    }

    @Override
    public Object getItem(int position) {
        return gridItemArrayList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        ViewHolder viewHolder = null;

        if (convertView==null){

            convertView = View.inflate(mContext,R.layout.help_custome_gridview_layout,null);

            viewHolder = new ViewHolder();

            viewHolder.imageView = convertView.findViewById(R.id.image);

            viewHolder.textView  = convertView.findViewById(R.id.text);

            convertView.setTag(viewHolder);

        }else {

            viewHolder = (ViewHolder) convertView.getTag();

        }

        GridItem gridItem = null ;

        gridItem = gridItemArrayList.get(position);

        viewHolder.imageView.setImageResource(gridItem.getImgSrc());

        viewHolder.textView.setText(gridItem.getImgContent());

        return convertView;
    }

    class ViewHolder {

       public ImageView imageView;

       public TextView textView;

    }


}

```

4.custome_layout
```xml
<?xml version="1.0" encoding="utf-8"?>


    <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
        android:id="@+id/card_view"
        android:layout_height="wrap_content"
        android:layout_width="wrap_content"
        android:orientation="vertical"
        android:elevation="3dp"
        android:layout_gravity="center"
        android:background="@drawable/fragment_dialog_backgroud"
        >

    <ImageView
        android:layout_margin="3dp"
        android:id="@+id/image"
        android:layout_height="120dp"
        android:layout_width="120dp"
        android:src="@mipmap/ic_launcher"
        android:layout_gravity="center"
        />

    <TextView
        android:layout_margin="3dp"
        android:id="@+id/text"
        android:layout_height="wrap_content"
        android:layout_width="wrap_content"
        android:text="@string/app_name"
        android:layout_gravity="center"
        android:gravity="center"
        />

    </LinearLayout>
```

5.how to use?
```java
package com.example.xxc.gridview;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.widget.GridView;

import com.example.xxc.studydemo.R;

import java.util.ArrayList;

public class Gridviewdemo extends AppCompatActivity {


    private GridView  gridView;

    private ArrayList<GridItem> gridItemArrayList;

    private HelpGridViewAdapter helpGridViewAdapter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.gridview_layout);

        initLayout();


    }

    /**
     * 初始化布局
     */
    private void initLayout(){

        gridView = findViewById(R.id.help_gridview_layout);

        gridItemArrayList = new ArrayList<>();

        initDatas();

        helpGridViewAdapter = new HelpGridViewAdapter(this,gridItemArrayList);

        gridView.setAdapter(helpGridViewAdapter);

    }

    /**
     * 加载数据
     */
    private void initDatas(){

        GridItem gridItem = null ;

        int [] imgsrc = {R.drawable.csdn,R.drawable.github,R.drawable.ins, R.drawable.momo, R.drawable.pinterest,
                R.drawable.qq, R.drawable.twitter, R.drawable.wechat,R.drawable.weibo };

        String [] imgConten = {"csdn","github","ins","momo","pinterest","qq","twitter","wechat","weibo"};

        for (int i=0;i<imgsrc.length;i++){
            gridItem = new GridItem();
            gridItem.setImgSrc(imgsrc[i]);
            gridItem.setImgContent(imgConten[i]);
            gridItemArrayList.add(gridItem);
        }

    }

}
```
6.效果

![](Screen/gridview.png)


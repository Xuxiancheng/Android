#  RecycleView 学习

## 创建流程

### 导入依赖

```gradle
implementation 'com.android.support:recyclerview-v7:28.0.0'
```
### 布局
#### recycleview布局

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <android.support.v7.widget.RecyclerView
        android:id="@+id/recycleview"
        android:layout_height="wrap_content"
        android:layout_width="match_parent"
        android:scrollbars="vertical"
        />
</LinearLayout>
```

####  自定义的recycle的布局

```xml
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
android:id="@+id/text_frame_layout"
android:layout_width="wrap_content"
android:layout_height="wrap_content"
android:background="@drawable/dialog_back_shape"
android:padding="10dp">

<TextView
    android:id="@+id/text"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="hello,world!"
    android:textColor="@android:color/black"
    android:textSize="15sp" />
</FrameLayout>
```



### 代码实现

#### 使用

```java
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Toast;
import java.util.ArrayList;

public class RecycleView_Main_Activity extends AppCompatActivity {


    private RecyclerView recyclerView;

    private MyRecycleViewAdapter recycleAdapter;

    private RecyclerView.LayoutManager recyclerViewManager;

    private ArrayList<String> mDatas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.recycleview_main);


        recyclerView = findViewById(R.id.recycleview);

        //窗口管理器
        recyclerViewManager = new LinearLayoutManager(this);

//        recyclerViewManager = new GridLayoutManager(this,5);

//        recyclerViewManager = new StaggeredGridLayoutManager(3,StaggeredGridLayoutManager.VERTICAL);


        recyclerView.setLayoutManager(recyclerViewManager);

        mDatas = new ArrayList<String>();

        for (int i=0;i<10;i++) {
            mDatas.add("-->"+i);
        }

        //适配器
        recycleAdapter = new MyRecycleViewAdapter(mDatas);

        recyclerView.setAdapter(recycleAdapter);

        //点击事件需要自己写
        recycleAdapter.setOnItemClickListener(new MyRecycleViewAdapter.OnItemClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public void onItemClick(final View view, int position) {
                //设置点击动画
                view.animate()
                        .translationZ(15f)
                        .setDuration(300)
                        .setListener(new AnimatorListenerAdapter() {
                            @Override
                            public void onAnimationEnd(Animator animation) {
                                super.onAnimationEnd(animation);
                                view.animate()
                                        .translationZ(1f)
                                        .setDuration(500)
                                        .start();
                            }
                        }).start();

                Toast.makeText(RecycleView_Main_Activity.this, "positon:"+position, Toast.LENGTH_SHORT).show();

            }
        });

    }
}
```

#### recycleview 适配器

```java
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.util.List;

public class MyRecycleViewAdapter extends RecyclerView.Adapter<MyRecycleViewAdapter.ViewHolder> {

    private List<String> mDatas;

    //构造函数,传入数据
    public MyRecycleViewAdapter(List<String> data){
        mDatas = data ;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        //加载示图
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.custome_recycleview,
                viewGroup,false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder viewHolder, int i) {
        //绑定
        viewHolder.textView.setText(mDatas.get(i)+"-->"+i);
    }

    @Override
    public int getItemCount() {
        //默认写就可以了
        return mDatas.size();
    }


    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener{

        private TextView textView;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            //找到控件
            textView = itemView.findViewById(R.id.text);
            //设置点击事件
            textView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (itemClickListener != null){
                itemClickListener.onItemClick(v,getLayoutPosition());
            }
        }
    }

    //点击事件 接口回调
    public OnItemClickListener itemClickListener;

    public void setOnItemClickListener(OnItemClickListener listener){
        itemClickListener = listener;
    }

    public interface OnItemClickListener{
        void onItemClick(View view,int position);
    }
}

```


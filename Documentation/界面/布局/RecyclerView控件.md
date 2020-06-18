# RecyclerView控件

## 概述

从Android 5.0开始，谷歌公司推出了一个用于大量数据展示的新控件RecylerView，可以用来代替传统的ListView，更加强大和灵活。RecyclerView的官方定义如下：

> A flexible view for providing a limited window into a large data set.

RecyclerView是**support-v7包**中的**新组件**，是一个强大的滑动组件，与经典的ListView相比，同样拥有item回收复用的功能，这一点从它的名字Recyclerview即回收view也可以看出。

## 优点

RecyclerView并不会完全替代ListView（这点从ListView没有被标记为@Deprecated可以看出），两者的使用场景不一样。但是RecyclerView的出现会让很多开源项目被废弃，例如横向滚动的ListView, 横向滚动的GridView, 瀑布流控件，因为RecyclerView能够实现所有这些功能。

比如：有一个需求是**屏幕竖着**的时候的显示形式是**ListView**，屏幕**横着**的时候的显示形式是2列的**GridView**，此时如果用**RecyclerView**，则通过设置LayoutManager**一行代码实现替换**。

RecylerView相对于ListView的优点罗列如下：

* RecyclerView**封装了viewholder**的回收复用，也就是说RecyclerView**标准化了ViewHolder**，**编写Adapter面向**的是**ViewHolder**而不再是View了，复用的逻辑被封装了，写起来更加简单。
  直接省去了listview中convertView.setTag(holder)和convertView.getTag()这些繁琐的步骤。
* 提供了一种**插拔式的体验**，**高度的解耦**，异常的灵活，针对一个Item的显示RecyclerView专门抽取出了**相应的类**，来**控制Item的显示**，使其的扩展性非常强。
* 设置**布局管理器**以控制**Item**的**布局方式**，**横向**、**竖向**以及**瀑布流**方式
  例如：你想控制横向或者纵向滑动列表效果可以通过**LinearLayoutManager**这个类来进行控制(与GridView效果对应的是**GridLayoutManager**,与**瀑布流**对应的还**StaggeredGridLayoutManager**等)。也就是说RecyclerView不再拘泥于ListView的线性展示方式，它也可以实现GridView的效果等多种效果。
* 可设置**Item的间隔样式**（可绘制）
  通过**继承RecyclerView的ItemDecoration**这个类，然后针对自己的业务需求去书写代码。
* 可以控制**Item增删的动画**，可以通过**ItemAnimator**这个类进行控制，当然针对增删的动画，RecyclerView有其自己默认的实现。

## 缺点

Item的点击和长按事件，需要用户自己去实现。

## 基本使用

### 初始化

``` java
recyclerView = (RecyclerView) findViewById(R.id.recyclerView);  
LinearLayoutManager layoutManager = new LinearLayoutManager(this );  
//设置布局管理器  
recyclerView.setLayoutManager(layoutManager);  
//设置为垂直布局，这也是默认的  
layoutManager.setOrientation(OrientationHelper. VERTICAL);  
//设置Adapter  
recyclerView.setAdapter(recycleAdapter);  
 //设置分隔线  
recyclerView.addItemDecoration( new DividerGridItemDecoration(this ));  
//设置增加或删除条目的动画  
recyclerView.setItemAnimator( new DefaultItemAnimator());  
```

在使用RecyclerView时候，必须指定一个适配器Adapter和一个布局管理器LayoutManager。适配器继承**`RecyclerView.Adapter`**类，具体实现类似ListView的适配器，取决于数据信息以及展示的UI。布局管理器用于确定RecyclerView中Item的展示方式以及决定何时复用已经不可见的Item，避免重复创建以及执行高成本的`findViewById()`方法。

可以看见RecyclerView相比ListView会多出许多操作，这也是RecyclerView灵活的地方，它将许多动能暴露出来，用户可以选择性的自定义属性以满足需求。

### 适配器

标准实现步骤如下：
① **创建Adapter**：创建一个**继承`RecyclerView.Adapter<VH>`**的Adapter类（VH是ViewHolder的类名）
② **创建ViewHolder**：在Adapter中创建一个**继承`RecyclerView.ViewHolder`**的静态内部类，记为VH。ViewHolder的实现和ListView的ViewHolder实现几乎一样。
③ 在**Adapter中实现3个方法**：

* **onCreateViewHolder()**
  这个方法主要**生成**为**每个Item inflater出一个View**，但是该方法**返回**的是一个**ViewHolder**。该方法把View直接封装在ViewHolder中，然后我们面向的是ViewHolder这个实例，当然这个ViewHolder需要我们自己去编写。

需要**注意**的是在`onCreateViewHolder()`中，映射**Layout必须为**

```java
View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_1, parent, false);
```

而不能是：

```java
View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_1, null);
```

* **onBindViewHolder()**
  这个方法主要用于**适配渲染数据到View**中。方法**提供**给你了一**viewHolder**而不是原来的convertView。
* **getItemCount()**
  这个方法就**类似**于BaseAdapter的**getCount**方法了，即总共有多少个条目。

可以看出，RecyclerView将ListView中`getView()`的功能拆分成了`onCreateViewHolder()`和`onBindViewHolder()`。

``` java
// ① 创建Adapter
public class NormalAdapter extends RecyclerView.Adapter<NormalAdapter.VH>{
    //② 创建ViewHolder
    public static class VH extends RecyclerView.ViewHolder{
        public final TextView title;
        public VH(View v) {
            super(v);
            title = (TextView) v.findViewById(R.id.title);
        }
    }
    
    private List<String> mDatas;
    public NormalAdapter(List<String> data) {
        this.mDatas = data;
    }

    //③ 在Adapter中实现3个方法
    @Override
    public void onBindViewHolder(VH holder, int position) {
        holder.title.setText(mDatas.get(position));
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //item 点击事件
            }
        });
    }

    @Override
    public int getItemCount() {
        return mDatas.size();
    }

    @Override
    public VH onCreateViewHolder(ViewGroup parent, int viewType) {
        //LayoutInflater.from指定写法
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_1, parent, false);
        return new VH(v);
    }
}
```

## Layout Manager布局管理器

## Adapter适配器


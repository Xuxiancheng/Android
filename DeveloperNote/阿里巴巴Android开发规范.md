# 阿里巴巴开发规范

## 前言

**良好的代码规范的作用：**

* 提升程序稳定性, 减少代码隐患, 降低故障率;
* 增强可扩展性, 大幅提高维护效率;
* 统一标准, 提升多人协作效率;
* 方便新人快速上手, 在项目组人员发生变动时保证项目进度;

**根据约束力强弱分为两部分:**

* 强制: 如果不遵守会导致代码严重混乱, 后期维护复杂,     甚至会出现严重bug;
* 推荐: 如果不遵守可能会导致代码描述不清, 理解困难,     导致功能越多维护越难的问题;

## 系统设计

### 强制

1. 不允许出现两段相同的逻辑块，必须抽出为共同方法，差异性使用参数控制，避免修改多处时导致遗漏;
1. 不允许出现两段相同的处于同一逻辑组的复杂布局,     必须抽为单独的include/merge;
1. 不允许父类中出现子类具体方法,     如果需要的话可以父类定义抽象方法, 交由子类实现;
1. 不允许`Activity`内多`Fragment`之间的直接沟通,必须通过`Activity`中转;

### 推荐

1. 推荐使用`MVP`活着`MVVM`架构;

1. 推荐使用`Kotlin`语言;

1. 采用模块分类方式替代文件类别方式, 方便快速查找模块相关内容, 例: 

   LoginActivity/LoginPreenter/LoginHttpRequest/LoginBean/LoginAdapter等所属同一登录模块的文件放入一个文件夹, 而不是所有activity放入一个文件夹, 所有adapter放入一个文件夹.

## 命名方式

见`代码命名规范`

## 可见性

### 强制

1. 所有新定义的类/方法, 默认写成private,     只有在其他类需要引用时再看情况标为public, protected, package-private;

### 推荐

1. java定义的父类中定义的方法如果子类重写会导致问题时,     添加final关键字;

## 注释相关

### 强制

1. 类/复杂或者不能从方法名字看出意图的方法必须添加注释, 当类/方法添加注释时, 必须使用此类型注释:


 ``` java
/**
* Created by XXX on 2019/6/19.
* 描述此类作用, 逻辑复杂的说明一下主要思路
*/
public class LoginPresenter {
 /**
 * 用于进行网络请求
 * @params xxx XXX
 */
 public void doLoginRequest(...){}
}
 ```

2. 变量注释不允许使用与类/方法一致的注释形式;

3. 方法注释中不允许出现@params, @return的参数描述错误的情况, 必须实时更新;

### 推荐

1. 一段逻辑建议使用`/**/`的方式；

2. 方法/参数建议添加 @Nullable,     @NotNull, @UiThread 等注解;

## Android基本组件

### 强制

1. Intent通信时不允许传递超过1M的数据,     可以采用外部Presenter中转或者EventBus传递的方式;

1. Intent隐式启动时必须检查目标是否存在,     否则会出现目标未找到崩溃:

   ``` java
   if (getPackageManager().resolveActivity(intent, PackageManager.MATCH_DEFAULT_ ONLY) != null);
   ```

3. Activity/Service/BroadcastReceiver内如果有耗时操作,     必须采用多线程进行处理;

4. 应用内部发送广播时,     只能使用LocalBroadcastManager.getInstance(this).sendBroadcast(intent), 不允许     context.sendBroadcast(intent), 避免外部应用拦截;

5. 不允许在Application中缓存数据,     全局的共享数据可以使用某presenter存储, 或者使用SharedPreference读写;

6. Activity或者Fragment中动态注册BroadCastReceiver时，registerReceiver和unregisterReceiver必须要成对出现;

7. 使用 Adapter 的时候，如果你使用了 ViewHolder 做缓存，在 getView()的 方法中无论这项 convertView 的每个子控件是否需要设置属性(比如某个 TextView 设置的文本可能为 null，某个按钮的背景色为透明，某控件的颜色为透明等)，都需 要为其显式设置属性(Textview 的文本为空也需要设置 setText("")，背景透明也需要 设置)，否则在滑动的过程中，因为 adapter item 复用的原因，会出现内容的显示错 乱。

8. Activity 或者 Fragment 中动态注册 BroadCastReceiver 时，registerReceiver() 和 unregisterReceiver()要成对出现。

   > 如果 registerReceiver()和 unregisterReceiver()不成对出现，则可能导致已经注册的
   >
   > receiver 没有在合适的时机注销，导致内存泄漏，占用内存空间，加重 SystemService
   >
   > 负担。部分华为的机型会对 receiver 进行资源管控，单个应用注册过多 receiver 会触发管
   >
   > 控模块抛出异常，应用直接崩溃。
   >
   > Activity 的生命周期不对应，可能出现多次 onResume 造成 receiver 注册多个，但
   >
   > 最终只注销一个，其余 receiver 产生内存泄漏。

   

### 推荐

1. Activity#onPause/onStop中结合isFinishing的判断来执行资源的释放,     必免放在执行时机较晚的Activity#onDestroy()中执行;
1. 不要在Activity#onPause中执行耗时操作,     这样会导致界面跳转卡顿, 可以放入Activity#onStop中执行;
1. Activity#onSaveInstanceState()方法不是 Activity 生命周期方法，也不保证 一定会被调用。它是用来在 Activity 被意外销毁时保存 UI 状态的，只能用于保存临 时性数据，例如 UI 控件的属性等，不能跟数据的持久化存储混为一谈。持久化存储 应该在 Activity#onPause()/onStop()中实行。

## UI布局

### 强制

1. 布局xml优先使用ConstraintLayout,     可以保证无嵌套的情况下完成包括部分控件同时显隐需求在内的99%的布局要求;

1. 不允许使用ScrollView包裹ListView/GridView/ExpandableListVIew等列表View,     复杂多项式列表可以使用多ItemType进行处理;

1. 布局中不得不使用 ViewGroup 多重嵌套时，不要使用 LinearLayout 嵌套， 改用 RelativeLayout，可以有效降低嵌套数。

   > Android 应用页面上任何一个 View 都需要经过 measure、layout、draw 三个步骤
   >
   > 才能被正确的渲染。从 xml layout 的顶部节点开始进行 measure，每个子节点都需 要向自己的父节点提供自己的尺寸来决定展示的位置，在此过程中可能还会重新
   >
   > measure(由此可能导致 measure 的时间消耗为原来的 2-3 倍)。节点所处位置越
   >
   > 深，套嵌带来的 measure 越多，计算就会越费时。这就是为什么扁平的 View 结构
   >
   > 会性能更好。
   >
   > 同时，页面拥上的 View 越多，measure、layout、draw 所花费的时间就越久。要缩 短这个时间，关键是保持 View 的树形结构尽量扁平，而且要移除所有不需要渲染的
   >
   > View。理想情况下，总共的 measure，layout，draw 时间应该被很好的控制在 16ms
   >
   > 以内，以保证滑动屏幕时 UI 的流畅。
   >
   > 要找到那些多余的 View(增加渲染延迟的 view)，可以用 Android Studio Monitor
   >
   > 里的 Hierarachy Viewer 工具，可视化的查看所有的 view。

4. 不能使用 ScrollView 包裹 ListView/GridView/ExpandableListVIew;因为这 样会把 ListView 的所有 Item 都加载到内存中，要消耗巨大的内存和 cpu 去绘制图 面。
	
	> ScrollView 中嵌套 List 或 RecyclerView 的做法官方明确禁止。除了开发过程中遇到
	> 的各种视觉和交互问题，这种做法对性能也有较大损耗。ListView 等 UI 组件自身有
	> 垂直滚动功能，也没有必要在嵌套一层 ScrollView。目前为了较好的 UI 体验，更贴
	> 近 Material Design 的设计，推荐使用 NestedScrollView

### 推荐

1. 在Activity中显示对话框或弹出浮层时,     尽量使用DialogFragment, 而非Dialog/AlertDialog, 便于随Activity生命周期管理弹窗的生命周期;

2. 添 加 Fragment 时 ， 确 保 FragmentTransaction#commit() 在 Activity#onPostResume()或者 FragmentActivity#onResumeFragments()内调用。 不要随意使用 FragmentTransaction#commitAllowingStateLoss()来代替，任何 commitAllowingStateLoss()的使用必须经过 code review，确保无负面影响。

   > Activity 可能因为各种原因被销毁，Android 支持页面被销毁前通过 Activity#onSaveInstanceState() 保 存 自 己 的 状 态 。 但 如 果FragmentTransaction.commit()发生在 Activity 状态保存之后，就会导致 Activity 重 建、恢复状态时无法还原页面状态，从而可能出错。为了避免给用户造成不好的体验，系统会抛出 IllegalStateExceptionStateLoss 异常。
   >
   > 推荐的做法是在 Activity 的onPostResume() 或 onResumeFragments() ( 对 FragmentActivity ) 里 执 行 FragmentTransaction.commit()，如有必要也可在 onCreate()里执行。不要随意改用FragmentTransaction.commitAllowingStateLoss()或者直接使用 try-catch 避免 crash，这不是问题的根本解决之道，当且仅当你确认 Activity 重建、恢复状态时，
   >
   > 本次 commit 丢失不会造成影响时才可这么做。

3. 不要在 Activity#onDestroy()内执行释放资源的工作，例如一些工作线程的 销毁和停止，因为 onDestroy()执行的时机可能较晚。可根据实际需要，在 Activity#onPause()/onStop()中结合 isFinishing()的判断来执行。

4. 如非必须，避免使用嵌套的 Fragment。

   > 嵌套 Fragment 是在 Android API 17 添加到 SDK 以及 Support 库中的功能，
   >
   > Fragment 嵌套使用会有一些坑，容易出现 bug，比较常见的问题有如下几种:
   >
   > 1. 1)  onActivityResult()方法的处理错乱，内嵌的 Fragment 可能收不到该方法的回调，
   >
   >    需要由宿主 Fragment 进行转发处理;
   >
   > 1. 2)  突变动画效果;
   >
   > 1. 3)  被继承的 setRetainInstance()，导致在 Fragment 重建时多次触发不必要的逻 辑。
   >
   > 非必须的场景尽可能避免使用嵌套 Fragment，如需使用请注意上述问题。

5. Service 需要以多线程来并发处理多个启动请求，建议使用 IntentService， 可避免各种复杂的设置。

   > Service 组件一般运行主线程，应当避免耗时操作，如果有耗时操作应该在 Worker
   >  线程执行。 可以使用 IntentService 执行后台任务。

6. 当前 Activity 的 onPause 方法执行结束后才会执行下一个 Activity 的 onCreate 方法，所以在 onPause 方法中不适合做耗时较长的工作，这会影响到页面之间的跳 转效率。

6. 使用 Toast 时，建议定义一个全局的 Toast 对象，这样可以避免连续显示 Toast 时不能取消上一次 Toast 消息的情况(如果你有连续弹出 Toast 的情况，避免 使用 Toast.makeText)。

6. 文本大小使用单位 dp，view 大小使用单位 dp。对于 Textview，如果在文 字大小确定的情况下推荐使用 wrap_content 布局避免出现文字显示不全的适配问 题。

6. 灵活使用布局，推荐 Merge、ViewStub 来优化布局，尽可能多的减少 UI 布局层级，推荐使用 FrameLayout，LinearLayout、RelativeLayout 次之。

6. 不能在 Activity 没有完全显示时显示 PopupWindow 和 Dialog。

   

## 进程/现成/消息通信

### 强制

1. 存在多进程的情况时,     Application中的初始化代码要根据进程分别处理, 避免初始化不必要的业务;

1. 新建线程时,     必须通过线程池的方式, 不允许采用new Thread()的方式;

   使用线程池的好处是减少在创建和销毁线程上所花的时间以及系统资源的开销，解 决资源不足的问题。如果不使用线程池，有可能造成系统创建大量同类线程而导致消耗完内存或者“过度切换”的问题。另外创建匿名线程不便于后续的资源使用分析，

   对性能分析等会造成困扰。

   ``` java
   int NUMBER_OF_CORES = Runtime.getRuntime().availableProcessors();
   int KEEP_ALIVE_TIME = 1;
   TimeUnit KEEP_ALIVE_TIME_UNIT = TimeUnit.SECONDS; BlockingQueue<Runnable> taskQueue = new LinkedBlockingQueue<Runnable>();
   ExecutorService executorService = new ThreadPoolExecutor(NUMBER_OF_CORES, NUMBER_OF_CORES*2, KEEP_ALIVE_TIME, KEEP_ALIVE_TIME_UNIT, taskQueue, new BackgroundThreadFactory(), new DefaultRejectedExecutionHandler());
   //执行任务
   executorService.execute(new Runnnable() { ...
   });
   ```

   线程池不允许使用 Executors 去创建，而是通过 ThreadPoolExecutor 的方 式，这样的处理方式让写的同学更加明确线程池的运行规则，规避资源耗尽的风险。

   > Executors 返回的线程池对象的弊端如下:
   >
   >  1):
   >
   > FixedThreadPool 和 SingleThreadPool : 允 许 的 请 求 队 列 长 度 为
   >
   > Integer.MAX_VALUE，可能会堆积大量的请求，从而导致 OOM;
   >
   > 2):
   >
   > CachedThreadPool 和 ScheduledThreadPool : 允 许 的 创 建 线 程 数 量 为
   >
   > Integer.MAX_VALUE，可能会创建大量的线程，从而导致 OOM。

1. Activity/Fragment中使用Handler时,     必须使用静态内部类+WeakReferences方式或者在onStop中调用handler.removeCallbacksAndMessages;

1. 避免在 Service#onStartCommand()/onBind()方法中执行耗时操作，如果确 实有需求，应改用 IntentService 或采用其他异步机制完成。

1. 避免在 BroadcastReceiver#onReceive()中执行耗时操作，如果有耗时工作， 应该创建 IntentService 完成，而不应该在 BroadcastReceiver 内创建子线程去做。

   > 由于该方法是在主线程执行，如果执行耗时操作会导致 UI 不流畅。可以使用 IntentService 、 创 建 HandlerThread 或 者 调 用 Context#registerReceiver
   >
   > (BroadcastReceiver, IntentFilter, String, Handler)方法等方式，在其他 Wroker 线程
   >
   > 执行 onReceive 方法。BroadcastReceiver#onReceive()方法耗时超过 10 秒钟，可
   >
   > 能会被系统杀死。

### 推荐

1. 多进程间共享数据使用ContentProvider替代SharedPreferences#MODE_MULTI_PROCESS;

## 文件/数据库

### 使用

1. 使用系统API获取文件路径, 避免手拼字符串, 例:     android.os.Environment#getExternalStorageDirectory(),     Context#getFilesDir(), 错误示例: File file = new     File("/mnt/sdcard/Download/Album", name);

1. 当使用外部存储时, 必须检查外部存储的可用性:     Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState());

1. 数据库Cursor使用之后必须关闭, 以免内存泄漏;

1. 执行 SQL 语句时，应使用 SQLiteDatabase#insert()、update()、delete()， 不要使用 SQLiteDatabase#execSQL()，以免 SQL 注入风险。

   ``` java
   public int updateUserPhoto(SQLiteDatabase db, String userId, String content) {
     ContentValues cv = new ContentValues();
   	cv.put("content", content);
   	String[] args = {String.valueOf(userId)};
   	return db.update(TUserPhoto, cv, "userId=?", args);
   }
   ```

1. 如果 ContentProvider 管理的数据存储在 SQL 数据库中，应该避免将不受 信任的外部数据直接拼接在原始 SQL 语句中，可使用一个用于将 ? 作为可替换参 数的选择子句以及一个单独的选择参数数组，会避免 SQL 注入。

   ``` java
   // 使用一个可替换参数
   String mSelectionClause = "var = ?"; 
   String[] selectionArgs = {""};
   selectionArgs[0] = mUserInput;
   ```

### 推荐

1. SharedPreference仅存储简单数据类型,     不要存储复杂数据, 如json数据/Bitmap编码等;

1. SharedPreference提交数据时,     尽量使用Editor#apply(), 而非Editor#commit();一般来讲，

   仅当需要确定提交结果，并据此有后续操作时，才使 用 Editor#commit()。

   > SharedPreference 相关修改使用 apply 方法进行提交会先写入内存，然后异步写入 磁盘，commit 方法是直接写入磁盘。如果频繁操作的话 apply 的性能会优于 commit，apply 会将最后修改内容写入磁盘。但是如果希望立刻获取存储操作的结果，并据此做相应的其他操作，应当使用 commit。



## 图片/动画

### 强制

1. 加载大图时必须在子线程中处理, 否则会卡UI;
1. 在Activity.onPause()/onStop()中关闭当前activity正在执行的动画;
1. png 图片使用 tinypng 或者类似工具压缩处理，减少包体积。

### 推荐

1. Android图片建议转化为WebP格式, 可以减少APK体积;

1. 动画尽量不要使用AnimationDrawable,     占用非常多内存;

1. 使用ARGB_565代替ARGB_888, 减少内存占用;

   > 但是一定要注意 RGB_565 是没有透明度的，如果图片本身需要保留透明度，那么
   >
   > 就不能使用 RGB_56
   
    ``` java
   Config config = drawableSave.getOpacity() != PixelFormat.OPAQUE ? Config.ARGB_8888 :    Config.RGB_565;
   Bitmap bitmap = Bitmap.createBitmap(w, h, config);
    ```

1. 当Animation执行结束时, 调用View.clearAnimation()释放相关资源;

1. 应根据实际展示需要，压缩图片，而不是直接显示原图。手机屏幕比较小，

   直接显示原图，并不会增加视觉上的收益，但是却会耗费大量宝贵的内存

1. 使用完毕的图片，应该及时回收，释放宝贵的内存。

1. 针对不同的屏幕密度，提供对应的图片资源，使内存占用和显示效果达到 合理的平衡。如果为了节省包体积，可以在不影响 UI 效果的前提下，省略低密度图 片。

1. 尽量减少Bitmap(BitmapDrawable)的使用，尽量使用纯色(ColorDrawable)、 渐变色(GradientDrawable)、StateSelector(StateListDrawable)等与 Shape 结 合的形式构建绘图。

1. 谨慎使用 gif 图片，注意限制每个页面允许同时播放的 gif 图片，以及单个 gif 图片的大小。

1. 大图片资源不要直接打包到 apk，可以考虑通过文件仓库远程下载，减小包 体积。



> **Glide的解码格式是RGB565，Picasso是ARGB8888 ，所以同一个图片，picasso更清晰，但是更耗内存。**

## 安全性

### 强制

1. 上线包必须混淆;
1. 加解密的秘钥/盐不允许硬编码到代码中, 以防反编译获取;
1. Https处理时必须校验证书, 不允许直接接受任意证书;
1. 使用Android的AES/DES/DESede加密算法时,     不要使用默认的加密模式ECB, 应显示指定使用CBC/CFB加密模式;
1. 禁止把敏感信息打印到log中;
1. 在应用发布时必须确保android:debuggable为false;
1. 必须利用X509TrustManager子类中的checkServerTrusted函数效验服务器端证书的合法性,
1. 必须将android:allowbackup属性设置为false,     防止adb backup导出应用数据;
1. AndroidAPP在HTTPS通信中，验证策略需要改成严格模式。说明:Android APP 在 HTTPS 通信中，使用 ALLOW_ALL_HOSTNAME_VERIFIER，表示允许和 所有的 HOST 建立 SSL 通信，这会存在中间人攻击的风险，最终导致敏感信息可能 会被劫持，以及其他形式的攻击。
1. 使用 Android 的 AES/DES/DESede 加密算法时，不要使用默认的加密模式 ECB，应显示指定使用 CBC 或 CFB 加密模式。

### 推荐

1. Android5.0 以后安全性要求较高的应用应该使用 window.setFlag (LayoutParam.FLAG_SECURE) 禁止录屏。

1. 加密算法:使用不安全的 Hash 算法(MD5/SHA-1)加密信息，存在被破解

   的风险，建议使用 SHA-256 等安全性更高的 Hash 算法。

1. 
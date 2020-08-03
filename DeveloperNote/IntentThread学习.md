# IntentThread学习

## 前言

我们要在子线程中调用Looper.prepare() 为一个线程开启一个消息循环，默认情况下Android中新诞生的线程是没有开启消息循环的。（主线程除外，主线程系统会自动为其创建Looper对象，开启消息循环。） Looper对象通过MessageQueue来存放消息和事件。一个线程只能有一个Looper，对应一个MessageQueue。 然后通过Looper.loop() 让Looper开始工作，从消息队列里取消息，处理消息。

然而这一切都可以用HandlerThread类来帮我们做这些逻辑操作。

## 使用

> HandlerThread本质上就是一个普通Thread,只不过内部建立了Looper.

``` java
public class MainActivity extends AppCompatActivity {

    private HandlerThread myHandlerThread ;
    private Handler handler ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //创建一个线程,线程名字：handler-thread
        myHandlerThread = new HandlerThread( "handler-thread") ;
        //开启一个线程,记住要先开启才能够使用
        myHandlerThread.start();
        //在这个线程中创建一个handler对象
        handler = new Handler( myHandlerThread.getLooper() ){
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                //这个方法是运行在 handler-thread 线程中的 ，可以执行耗时操作
                Log.d( "handler " , "消息： " + msg.what + "  线程： " + Thread.currentThread().getName()  ) ;
            }
        };

        //在主线程给handler发送消息
        handler.sendEmptyMessage( 1 ) ;

        new Thread(new Runnable() {
            @Override
            public void run() {
             //在子线程给handler发送数据
             handler.sendEmptyMessage( 2 ) ;
            }
        }).start() ;

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //释放资源
        myHandlerThread.quit() ;
    }
}
```

**注意⚠️**

1. 线程要先开启才能勾“绑定”`Handler`；

   ``` java
   myHandlerThread.start();
   ```

1. `Handler`要发送消息才能够使用；

   ``` java
   handler.sendEmptyMessage( 1 ) ;
   ```

3. 记得释放资源;

   ``` java
   //释放资源
   myHandlerThread.quit() ;
   ```

   > 1. 当我们调用Looper的quit方法时，实际上执行了MessageQueue中的removeAllMessagesLocked方法，该方法的作用是把MessageQueue消息池中所有的消息全部清空，无论是延迟消息（延迟消息是指通过sendMessageDelayed或通过postDelayed等方法发送的需要延迟执行的消息）还是非延迟消息。
   >
   > 2. 当我们调用Looper的quitSafely方法时，实际上执行了MessageQueue中的removeAllFutureMessagesLocked方法，通过名字就可以看出，该方法只会清空MessageQueue消息池中所有的延迟消息，并将消息池中所有的非延迟消息派发出去让Handler去处理，quitSafely相比于quit方法安全之处在于清空消息之前会派发所有的非延迟消息。
   >
   > 3. 无论是调用了quit方法还是quitSafely方法只会，Looper就不再接收新的消息。即在调用了Looper的quit或quitSafely方法之后，消息循环就终结了，这时候再通过Handler调用sendMessage或post等方法发送消息时均返回false，表示消息没有成功放入消息队列MessageQueue中，因为消息队列已经退出了。
   >
   > **需要注意的是Looper的quit方法从API Level 1就存在了，但是Looper的quitSafely方法从API Level 18才添加进来。**

## 总结

* HandlerThread将loop转到子线程中处理，说白了就是将分担MainLooper的工作量，降低了主线程的压力，使主界面更流畅。
* 开启一个线程起到多个线程的作用。处理任务是串行执行，按消息发送顺序进行处理。HandlerThread本质是一个线程，在线程内部，代码是串行处理的。
* 但是由于每一个任务都将以队列的方式逐个被执行到，一旦队列中有某个任务执行时间过长，那么就会导致后续的任务都会被延迟处理。(这个跟IntentService是一样的!)
* HandlerThread拥有自己的消息队列，它不会干扰或阻塞UI线程。
* 对于网络IO操作，HandlerThread并不适合，因为它只有一个线程，还得排队一个一个等着。
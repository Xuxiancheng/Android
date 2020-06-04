

# Volley 概览

Volley 是一个可让 Android 应用更轻松、（最重要的是）更快捷地联网的 HTTP 库。您可以在 [GitHub](https://github.com/google/volley) 上获取 Volley。

Volley 具有以下优势：

* 自动网络请求调度。
* 多个并发网络连接。
* 透明磁盘和具有标准 HTTP [缓存一致性](https://en.wikipedia.org/wiki/Cache_coherence)的内存响应缓存。
* 支持请求优先级。
* 取消请求 API。您可以取消单个请求，也可以设置要取消的请求的时间段或范围。
* 可轻松自定义，例如自定义重试和退避时间。
* 强大的排序功能，让您可以轻松使用从网络异步提取的数据正确填充界面。
* 调试和跟踪工具。

Volley 在用于填充界面的远程过程调用 (RPC) 类型的操作方面表现出色，例如以结构化数据的形式获取搜索结果页面。它可以轻松集成任何协议，并且开箱后即支持原始字符串、图片和 JSON。Volley 提供对您所需功能的内置支持，因此您无需编写样板代码，且可以专注于特定于应用的逻辑。

Volley 不适用于下载大量内容的操作或流式传输操作，因为在解析过程中，Volley 会将所有响应存储在内存中。对于下载大量内容的操作，请考虑使用 `DownloadManager` 等替代方法。



## 使用

将以下依赖项添加到应用的 build.gradle 文件中：

``` gradle
    dependencies {
        ...
        implementation 'com.android.volley:volley:1.1.1'
    }
```



## 发送简单的请求

可以通过创建 `RequestQueue` 并向其传递 `Request` 对象来使用 Volley。`RequestQueue` 管理用于运行网络操作、向缓存读写数据以及解析响应的工作器线程。请求解析原始响应，而 Volley 负责将已解析的响应分派回主线程以供传送。

> 这与OKHTTP不同！

### 添加 INTERNET 权限

要使用 Volley，您必须将 `android.permission.INTERNET` 权限添加到应用的清单中。否则，您的应用将无法连接到网络。

``` xml
<uses-permission android:name="android.permission.INTERNET" />
```

### 使用 newRequestQueue

Volley 提供了一种便捷方法 `Volley.newRequestQueue`，该方法会使用默认值为您设置一个 `RequestQueue`，并启动该队列。例如：

``` java
    final TextView textView = (TextView) findViewById(R.id.text);
    // ...

    // Instantiate the RequestQueue.
    RequestQueue queue = Volley.newRequestQueue(this);
    String url ="http://www.google.com";

    // Request a string response from the provided URL.
    StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
        @Override
        public void onResponse(String response) {
            // Display the first 500 characters of the response string.
            textView.setText("Response is: "+ response.substring(0,500));
        }
    }, new Response.ErrorListener() {
        @Override
        public void onErrorResponse(VolleyError error) {
            textView.setText("That didn't work!");
        }
    });

    // Add the request to the RequestQueue.
    queue.add(stringRequest);
    
```

> Volley 始终在主线程上传送已解析的响应。在主线程上运行便于使用接收的数据填充界面控件，因为您可以直接从响应处理程序随意修改界面控件。对于库提供的许多重要语义（特别是与取消请求相关的语义）来说，这尤为重要。

### 发送请求

要发送请求，您只需构建一个请求，并使用 `add()` 将其添加到 `RequestQueue`，如上文所示。您添加请求后，它会经过管道，得到处理，然后其原始响应会被解析并传送。

您调用 `add()` 时，Volley 会运行一个缓存处理线程和一个网络分派线程池。将一个请求添加到队列后，缓存线程会拾取该请求并对其进行分类：如果该请求可以通过缓存处理，则系统会在缓存线程上解析缓存的响应，并在主线程上传送解析后的响应。如果该请求无法通过缓存处理，则系统会将其放置到网络队列中。第一个可用的网络线程会从队列中获取该请求，执行 HTTP 事务，在工作器线程上解析响应，将响应写入缓存，然后将解析后的响应发送回主线程以供传送。

请注意，阻塞 I/O 和解析/解码等开销大的操作都是在工作器线程上完成的。您可以添加来自任意线程的请求，但响应始终会在主线程上传送。

![](https://developer.android.google.cn/images/training/volley-request.png)

### 取消请求

要取消请求，请在您的 `Request` 对象上调用 `cancel()`。取消请求后，Volley 可以确保您的响应处理程序永远不会被调用。实际上，这意味着您可以在 Activity 的 `onStop()` 方法中取消所有待处理的请求，并且无论是否已调用 `onSaveInstanceState()`，您都无需通过检查 `getActivity() == null` 丢弃响应处理程序，或其他防御性样板。



要利用此行为，您通常需要跟踪所有传输中的请求，以便能够在适当的时间取消它们。有一种更简单的方法：您可以将一个标记对象与每个请求相关联。然后，使用该标记提供要取消的请求范围。例如，您可以使用代表其发出请求的 `Activity` 标记所有相应请求，然后从 `onStop()` 调用 `requestQueue.cancelAll(this)`。同样，您可以标记 `ViewPager` 标签中的所有缩略图请求（使用其各自的标签），并在用户执行滑动操作时取消，以确保新标签不会被来自其他标签的请求阻止。

以下是为标记使用字符串值的示例：

#### 1. 定义标记并将其添加到请求中。

``` java
    public static final String TAG = "MyTag";
    StringRequest stringRequest; // Assume this exists.
    RequestQueue requestQueue;  // Assume this exists.

    // Set the tag on the request.
    stringRequest.setTag(TAG);

    // Add the request to the RequestQueue.
    requestQueue.add(stringRequest);
   
```

#### 2.在 Activity 的 `onStop()` 方法中，取消所有具有此标记的请求。

``` java
    @Override
    protected void onStop () {
        super.onStop();
        if (requestQueue != null) {
            requestQueue.cancelAll(TAG);
        }
    }

```

> 取消请求时应小心谨慎。如果您依赖响应处理程序推进状态或启动其他流程，则需要考虑这一点。再次声明，取消后响应处理程序将不会被调用。

## 设置 RequestQueue

介绍将 `RequestQueue` 创建为单例这种推荐做法，这样做会使 `RequestQueue` 在整个生命周期内持续不断运行。

### 设置网络和缓存

`RequestQueue` 需要两样东西才能发挥作用：一样是网络，用于执行请求传输操作，另一样是缓存，用于处理缓存。Volley 工具箱中提供了这两样东西的标准实现：`DiskBasedCache` 可提供每次响应一个文件的缓存（以及内存索引），而 `BasicNetwork` 则可根据您的首选 HTTP 客户端提供网络传输。

`BasicNetwork` 是 Volley 的默认网络实现。您必须使用自己的应用连接到网络所用的 HTTP 客户端来初始化 `BasicNetwork`。这通常是一个 `HttpURLConnection`。

``` java
    RequestQueue requestQueue;

    // Instantiate the cache
    Cache cache = new DiskBasedCache(getCacheDir(), 1024 * 1024); // 1MB cap

    // Set up the network to use HttpURLConnection as the HTTP client.
    Network network = new BasicNetwork(new HurlStack());

    // Instantiate the RequestQueue with the cache and network.
    requestQueue = new RequestQueue(cache, network);

    // Start the queue
    requestQueue.start();

    String url ="http://www.example.com";

    // Formulate the request and handle the response.
    StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
            new Response.Listener<String>() {
        @Override
        public void onResponse(String response) {
            // Do something with the response
        }
    },
        new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                // Handle error
        }
    });

    // Add the request to the RequestQueue.
    requestQueue.add(stringRequest);

    // ...
    
```

如果您只需要发出一个一次性请求但又不想离开任何线程池，则可以在任何需要的地方创建 `RequestQueue`，并使用[发送简单请求](https://developer.android.google.cn/training/volley/simple)中介绍的 `Volley.newRequestQueue()` 方法，在响应或错误返回后对 `RequestQueue` 调用 `stop()`。不过，比较常见的用例是将 `RequestQueue` 创建为单例，以使其在您应用的整个生命周期内不断运行（如下一节所述）。

### 使用单例模式

如果您的应用经常使用网络，那么最有效的方式可能是设置单个 `RequestQueue` 实例，使其在您应用的整个生命周期内不断运行。您可以通过多种方式实现此目标。建议您实现包含 `RequestQueue` 和其他 Volley 功能的单例类。另一种方法是子类化 `Application` 并在 `Application.onCreate()` 中设置 `RequestQueue`。但我们[不建议](https://developer.android.google.cn/reference/android/app/Application)采用这种方法；静态单例能够以更加模块化的方式提供相同的功能。

这里有一个很关键的点是，您必须使用 `Application` 上下文（而不是 `Activity` 上下文）对 `RequestQueue` 进行实例化。这样可确保 `RequestQueue` 在您应用的整个生命周期内不断运行，而不是在每次重新创建 Activity（例如，当用户旋转设备时）后都重新创建。

> `Application` 上下文

以下示例展示了提供 `RequestQueue` 和 `ImageLoader` 功能的单例类：

``` java
    public class MySingleton {
        private static MySingleton instance;
        private RequestQueue requestQueue;
        private ImageLoader imageLoader;
        private static Context ctx;

        private MySingleton(Context context) {
            ctx = context;
            requestQueue = getRequestQueue();

            imageLoader = new ImageLoader(requestQueue,
                    new ImageLoader.ImageCache() {
                private final LruCache<String, Bitmap>
                        cache = new LruCache<String, Bitmap>(20);

                @Override
                public Bitmap getBitmap(String url) {
                    return cache.get(url);
                }

                @Override
                public void putBitmap(String url, Bitmap bitmap) {
                    cache.put(url, bitmap);
                }
            });
        }

        public static synchronized MySingleton getInstance(Context context) {
            if (instance == null) {
                instance = new MySingleton(context);
            }
            return instance;
        }

        public RequestQueue getRequestQueue() {
            if (requestQueue == null) {
                // getApplicationContext() is key, it keeps you from leaking the
                // Activity or BroadcastReceiver if someone passes one in.
                requestQueue = Volley.newRequestQueue(ctx.getApplicationContext());
            }
            return requestQueue;
        }

        public <T> void addToRequestQueue(Request<T> req) {
            getRequestQueue().add(req);
        }

        public ImageLoader getImageLoader() {
            return imageLoader;
        }
    }
```

下面列举了一些示例来说明如何使用单例类执行 `RequestQueue` 操作：

``` java
    // Get a RequestQueue
    RequestQueue queue = MySingleton.getInstance(this.getApplicationContext()).
        getRequestQueue();

    // ...

    // Add a request (in this example, called stringRequest) to your RequestQueue.
    MySingleton.getInstance(this).addToRequestQueue(stringRequest);
```

## 发出标准请求

介绍了如何使用 Volley 支持的常见请求类型：

* `StringRequest`。指定网址并接收响应中的原始字符串。请参阅[设置请求队列](https://developer.android.google.cn/training/volley/requestqueue)查看示例。
* `JsonObjectRequest` 和 `JsonArrayRequest`（都是 `JsonRequest` 的子类）。指定网址并分别获取响应中的 JSON 对象或数组。

### 请求 JSON

Volley 为 JSON 请求提供了以下类：

* `JsonArrayRequest` - 用于在给定网址检索 `JSONArray` 响应正文的请求。
* `JsonObjectRequest` - 用于在给定网址检索 `JSONObject` 响应正文的请求，允许传入可选的 `JSONObject` 作为请求正文的一部分。

> 这两个类均基于通用基类 `JsonRequest`。

``` java
    String url = "http://my-json-feed";

    JsonObjectRequest jsonObjectRequest = new JsonObjectRequest
            (Request.Method.GET, url, null, new Response.Listener<JSONObject>() {

        @Override
        public void onResponse(JSONObject response) {
            textView.setText("Response: " + response.toString());
        }
    }, new Response.ErrorListener() {

        @Override
        public void onErrorResponse(VolleyError error) {
            // TODO: Handle error

        }
    });

    // Access the RequestQueue through your singleton class.
    MySingleton.getInstance(this).addToRequestQueue(jsonObjectRequest);
    
```

## 实现自定义请求

为没有开箱后即支持 Volley 的类型实现您自己的自定义请求类型。

### 编写自定义请求

大多数请求的工具箱中都有可供使用的实现；如果您的响应是字符串、图片或 JSON，那么您可能不需要实现自定义 `Request`。

如果您确实需要实现自定义请求，则只需执行以下操作即可：

* 扩展 `Request` 类，其中 `` 表示请求期望的已解析响应的类型。因此，如果已解析的响应是字符串，请通过扩展 `Request` 创建自定义请求。如要查看扩展 `Request` 的示例，请参阅 Volley 工具箱类 `StringRequest` 和 `ImageRequest`。
* 实现抽象方法 `parseNetworkResponse()` 和 `deliverResponse()`，详细说明如下所示。

### parseNetworkResponse

`Response` 封装给定类型（例如字符串、图片或 JSON）的用于传送的已解析响应。下面的示例展示了 `parseNetworkResponse()` 实现：

``` java
    @Override
    protected Response<T> parseNetworkResponse(
            NetworkResponse response) {
        try {
            String json = new String(response.data,
            HttpHeaderParser.parseCharset(response.headers));
        return Response.success(gson.fromJson(json, clazz),
        HttpHeaderParser.parseCacheHeaders(response));
        }
        // handle errors
    // ...
    }
    
```

请注意以下几点：

* `parseNetworkResponse()` 将 `NetworkResponse` 作为其参数，其中包含响应负载作为字节 []、HTTP 状态代码以及响应标头。
* 您的实现必须返回 `Response`，其中包含您输入的响应对象和缓存元数据，或者解析失败时出现的错误。

如果您的协议具有非标准缓存语义，您可以自行构建一个 `Cache.Entry`，但大多数请求都支持下述示例：

``` java
    return Response.success(myDecodedObject,
            HttpHeaderParser.parseCacheHeaders(response));
    
```

Volley 从工作线程调用 `parseNetworkResponse()`。这样可确保昂贵的解析操作（例如将 JPEG 解码为位图）不会阻止界面线程。

### deliverResponse

Volley 使用您在 `parseNetworkResponse()` 中返回的对象在主线程上回调您。大多数请求都会在这里调用回调接口，例如：

``` java
    protected void deliverResponse(T response) {
            listener.onResponse(response);
    
```


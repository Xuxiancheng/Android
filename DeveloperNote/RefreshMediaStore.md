#刷新MediaStore的方法
1、获取多媒体文件
MediaStore这个类是android系统提供的一个多媒体数据库，android中多媒体信息都可以从这里提取。Android把所有的多媒体数据库接口进行了封装，所有的数据库不用自己进行创建，直接调用利用ContentResolver去掉用那些封装好的接口就可以进行数据库的操作了。 
路径是在 /data/data/com.android.providers.media/databases/external.db 
在这个db的files表中可以查看所有多媒体信息.

```java
//获取视频文件
 private boolean getVideos() {
        Uri videoUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        ContentResolver cr = MediaMainActivity.this.getContentResolver();
        String[] projection = new String[]{
                MediaStore.Video.VideoColumns._ID,
                MediaStore.Video.VideoColumns.DATA,
                MediaStore.Video.VideoColumns.TITLE,
                MediaStore.Video.VideoColumns.SIZE,
                MediaStore.Video.VideoColumns.DATE_TAKEN,
                MediaStore.Video.VideoColumns.DATE_MODIFIED,
                MediaStore.Video.VideoColumns.DURATION,
                MediaStore.Video.VideoColumns.RESOLUTION,
                MediaStore.Video.VideoColumns.LATITUDE,
                MediaStore.Video.VideoColumns.LONGITUDE,
                MediaStore.Video.Thumbnails.DATA,
                MediaStore.Video.VideoColumns.HEIGHT,
                MediaStore.Video.VideoColumns.WIDTH,
        };

        Cursor cursor = cr.query(videoUri, projection, null, null, null);
        if (cursor == null) {
            return false;
        }
        if (cursor.getCount() != 0) {
            String path="";
            while (cursor.moveToNext()) {
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media._ID));
                stringBuilder.append("id-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DATA));
                stringBuilder.append("path-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.TITLE));
                stringBuilder.append("title-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.SIZE));
                stringBuilder.append("size-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DATE_TAKEN));
                stringBuilder.append("add-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DATE_MODIFIED));
                stringBuilder.append("modified-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.DURATION));
                stringBuilder.append("duration-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.RESOLUTION));
                stringBuilder.append("resolution-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.LATITUDE));
                stringBuilder.append("latitude-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Media.LONGITUDE));
                stringBuilder.append("longtitude-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Thumbnails.DATA));
                stringBuilder.append("thumbnails_data-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Thumbnails.WIDTH));
                stringBuilder.append("thumbnails_width-->" + path + "\n");
                path = cursor.getString(cursor.getColumnIndex(MediaStore.Video.Thumbnails.HEIGHT));
                stringBuilder.append("thumbnails_height-->" + path + "\n");
                stringBuilder.append("----------------------------------\n");
            }
        }
        if (cursor!=null) {
            cursor.close();
        }
        return true;
    }
```


2.坑
2.1 .nomedia
>“.nomedia”文件放在任何一个文件夹下都会把该文件夹下所有媒体文件（图片，mp3,视频）隐藏起来不会在系统图库，铃声中出现。 
通俗来说就是用来屏蔽媒体软件扫描的。在文件夹里放了这个文件，播放软件或者阅读软件就扫描不到这个文件夹的东西了。

2.2 对于多媒体库的刷新 
通过adb去push多媒体数据的时候，利用1中获取多媒体文件的方式是没法展示出来的，实际上是由于文件传到本地了，但是多媒体库并没有遍历这些文件，导致在external.db中并没有存储这些文件的信息

方法一
```java
 /**
     * 通知媒体库更新文件夹
     * @param context
     * @param filePath 文件夹
     *
     * */
    public void scanFile(Context context, String filePath) {
        Intent scanIntent = new Intent(Intent.ACTION_MEDIA_MOUNTED);
        scanIntent.setData(Uri.fromFile(new File(filePath)));
        context.sendBroadcast(scanIntent);
    }
```
>**该方法在4.4以后就被禁止使用了，4.4以后会报权限的错误**

方法二
```java
new SingleMediaScanner(this,new File("遍历的文件夹路径");
```
```java
public class SingleMediaScanner implements MediaScannerConnectionClient  {

    private MediaScannerConnection mMs;
    private File mFile;

    public SingleMediaScanner(Context context, File f) {
        mFile = f;
        mMs = new MediaScannerConnection(context, this);
        mMs.connect();
    }

    @Override
    public void onMediaScannerConnected() {
        mMs.scanFile(mFile.getAbsolutePath(), null);
    }

    @Override
    public void onScanCompleted(String path, Uri uri) {
        mMs.disconnect();
    }
}
```
>没用

方法三
```java
public static final String ACTION_MEDIA_SCANNER_SCAN_DIR =  "android.intent.action.MEDIA_SCANNER_SCAN_DIR";
    public void scanDirAsync(Context ctx, String dir) {
        Intent scanIntent = new Intent(ACTION_MEDIA_SCANNER_SCAN_DIR);
        scanIntent.setData(Uri.fromFile(new File(dir)));
        ctx.sendBroadcast(scanIntent);
    }
```
>也没效果

终极大招:
**１.通过adb命令去主动遍历多媒体库**
```shell
adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED -d file:///sdcard/+"你自己的路径"
```
**2.重启手机**



# Android 权限申请
## 一. 权限分类
### 1. 正常权限
### 2. 危险权限

|权限组|权限名|
|:-:|:-:|
|CALENDAR|READ_CALENDAR|
||WRITE_CALENDAR|
|CAMERA|CAMERA|
|CONTACTS|READ_CONTACTS|
||WRITE_CONTACTS|
||GET_ACCOUNTS|
|LOCATION|ACCESS_FINE_LOCATION|
||ACCESS_COARSE_LOCATION|
|MICROPHONE|RECORD_AUDIO|
|PHONE|READ_PHONE_STATE|
||CALL_PHONE|
||READ_CALL_LOG|
||WRITE_CALL_LOG|
||ADD_VOICEMAIL|
||USE_SIP|
||PROCESS_OUTGOING_CALLS|
|SENSORS|BODY_SENSORS|
|SMS|SEND_SMS|
||RECEIVE_SMS|
||READ_SMS|
||RECEIVE_WAP_PUSH|
||RECEIVE_MMS|
|STORAGE|READ_EXTERNAL_STORAGE|
||WRITE_EXTERNAL_STORAGE|

> 危险除了在清单文件中申声明外,还需要在代码中动态申请;  

## 二. 权限申请流程
### 1. 清单文件声明

``` xml
<uses-permission android:name=“android.permission.READ_EXTERNAL_STORAGE”/>
<uses-permission android:name=“android.permission.WRITE_EXTERNAL_STORAGE”/>
```

### 2. 权限检查
在申请权限前需要先提前检查应用是否拥有此权限

``` java
int readPermissionCheckID = ContextCompat.checkSelfPermission(PermissionRequest.this,Manifest.permission.WRITE_EXTERNAL_STORAGE);
        if (readPermissionCheckID == PackageManager.PERMISSION_GRANTED){
            Toast.makeText(this,"有读的权限",Toast.LENGTH_SHORT).show();
        }else {
            Toast.makeText(this, “没有读的权限”, Toast.LENGTH_SHORT).show();       
 }
```

`ContextCompat.checkSelfPermission`方法用来检查是否拥有权限

### 3. 权限申请
``` java 
ActivityCompat.requestPermissions(PermissionRequest.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
        2);
```

### 4. 权限回调

``` java 
@Override
public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    if (grantResults.length>0&&grantResults[0]==PackageManager.PERMISSION_GRANTED){
        Toast.makeText(this, "同意权限", Toast.LENGTH_SHORT).show();
    }else {
        Toast.makeText(this, "不同意此权限", Toast.LENGTH_SHORT).show();
    }
}
```
### 5.权限用途解释
在全新啊申请过程中，有的权限有被客户禁止的风险，因此需要在用户拒绝时对用户解释申请此权限的用途；

``` java 
if(ActivityCompat.shouldShowRequestPermissionRationale(PermissionRequest.this,Manifest.permission.WRITE_EXTERNAL_STORAGE)){
    new AlertDialog.Builder(PermissionRequest.this)
            .setTitle("权限申请解释")
            .setMessage("此权限用于在sdcard目录下书写✍️数据,并无其它用途!”)
            .setPositiveButton(“再次申请一次”, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialogInterface, int i) {
                    ActivityCompat.requestPermissions(PermissionRequest.this,new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                            2);
                }
            })
            .setNegativeButton("以后再说",null)
            .create()
            .show();
}
```
此方法在第一次被用户拒绝时返回false，当客户第二次申请时和选择不再询问时会返回true，此时需要跟用户解释此权限的用途。

## 三. 权限组
如果当一个权限组内的某一个权限被授予时，当应用再申请同一个权限组内的其它权限时，系统会自动授予其它权限。

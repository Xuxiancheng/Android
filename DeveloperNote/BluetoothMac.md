## 如何在Android6.0版本后获取蓝牙MAC地址
1.利用net.vidageek(第三方jar包)
```java
Object bluetoothManageService = new Mirror().on(adapter).get().field("mService");
if (bluetoothManageService == null)
    return null;
Object address = new Mirror().on(bluetoothManageService).invoke().method("getAddress").withoutArgs();
if (address != null && address instanceof String) {
    return (String) address;
} else {
    return null;
}
```
2.利用反射方法
```java
private String getBluetoothMacAddress() {
    BluetoothAdapter bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    String bluetoothMacAddress = "";
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M){
        try {
            Field mServiceField = bluetoothAdapter.getClass().getDeclaredField("mService");
            mServiceField.setAccessible(true);

            Object btManagerService = mServiceField.get(bluetoothAdapter);

            if (btManagerService != null) {
                bluetoothMacAddress = (String) btManagerService.getClass().getMethod("getAddress").invoke(btManagerService);
            }
        } catch (NoSuchFieldException e) {

        } catch (NoSuchMethodException e) {

        } catch (IllegalAccessException e) {

        } catch (InvocationTargetException e) {

        }
    } else {
        bluetoothMacAddress = bluetoothAdapter.getAddress();
    }
    return bluetoothMacAddress;
}
```

3.旧版本获取蓝牙MAC的地址
```java
BluetoothAdapter adapter = BluetoothAdapter.getDefaultAdapter();
```
```java
//获取适配器的第二种方法
BluetoothAdapter adapter = (BluetoothAdapter) getApplicationContext().getSystemService(BLUETOOTH_SERVICE);
```

##### 安卓6以后的版本使用此方法拿不到真实的MAC地址
```java
String macAddr = adapter.getAddress();
```
## Android Cursor 正确的遍历方法

```java
//cursor不为空，moveToFirst为true说明有数据

//记着用不能直接用while循环遍历，要不然死的很惨的
if(cursor!=null&&cursor.moveToFirst()){

      do{

      }while(cursor.moveToNext);

}

或着

if(cursor!=null&&cursor.moveToFirst()){

       while (!result.isAfterLast()) {

      }

}
```

 moveToFirst里面对pos和count做了判断了

```java
// Make sure position isn't past the end of the cursor
final int count = getCount();
if (position >= count) {
mPos = count;
return false;
}
```
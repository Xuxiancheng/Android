#sqlite学习
1.创建数据库
```java
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class SqliteCreateUtils extends SQLiteOpenHelper {

    private static final String CREATE_BOOK="create table Book("+
            "id integer primary key autoincrement,"
            +"author text,"
            +"price real,"
            +"pages integer,"
            +"name text)";



    public SqliteCreateUtils(Context context, String name, SQLiteDatabase.CursorFactory factory, int version) {
        super(context, name, factory, version);

    }

    //第一次创建数据库，回调该方法
    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(CREATE_BOOK);
    }

    //升级数据库
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
```
调用构造函数
```java
new SqliteCreateUtils(MainActivity.this,"demo.db",null,1);
```

获得SqliteDatabase对象
```java
//   sqLiteDatabase=sqliteCreateUtils.getWritableDatabase();
// 使用  getWritableDatabase()方法会在磁盘空间满时出现异常，而下面这种方法只会以只读方式打开数据库
sqLiteDatabase=sqliteCreateUtils.getReadableDatabase();
```

2,数据库四大操作，增删查改
```java
//增
ContentValues contentValues=new ContentValues();
                    contentValues.put("id",1);
                    contentValues.put("author","xxc");
                    contentValues.put("price",12.0);
                    contentValues.put("pages",22);
                    contentValues.put("name","hello_world!");
sqLiteDatabase.insert("book",null,contentValues);

//查
StringBuilder stringBuilder=new StringBuilder();
Cursor cursor=sqLiteDatabase.rawQuery("select * from book",null);
while (cursor.moveToNext()){
    stringBuilder.append(cursor.getInt(cursor.getColumnIndex("id"))+"\n");
    stringBuilder.append(cursor.getString(cursor.getColumnIndex("author"))+"\n");
    stringBuilder.append(cursor.getDouble(cursor.getColumnIndex("price"))+"\n");
    stringBuilder.append(cursor.getInt(cursor.getColumnIndex("pages"))+"\n");
    stringBuilder.append(cursor.getString(cursor.getColumnIndex("name"))+"\n");               
     }
if (null!=cursor){  
    cursor.close();
    }

 //改
ContentValues contentValues=new ContentValues();
                 contentValues.put("price",222.0);
sqLiteDatabase.update("book",contentValues,"name=?",new String[]{"hello_world!"});   
```
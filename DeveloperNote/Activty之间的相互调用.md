# Activity之间的相互调用

###  Activity A:



```java
//Activity B的报名，和需要打开的具体类名  
			ComponentName componentName = new ComponentName("com.example.xxc.studydemo", "com.example.xxc.popuviewdemo.CustomePopuView");
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putString("KEY","VALUE");
            intent.setComponent(componentName);
            intent.putExtras(bundle);
            startActivityForResult(intent,1);
```



```java
 @Override
protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode==RESULT_OK&&requestCode==1){
            Toast.makeText(this, "hi.activity!", Toast.LENGTH_SHORT).show();
        }
 }
```





### Activity B:



```java
		Bundle bundle = this.getIntent().getExtras();
        if (bundle!=null){
            String string = bundle.getString("KEY","hello");
            button.setText(string);
        }
```



```java
////Activity A的报名，和需要打开的具体类名  
	ComponentName componentName = new ComponentName("com.example.xxc.xhunterserver",
                        "com.example.xxc.xhunterserver.MainActivity");
    Intent intent = getIntent();
    Bundle bundle = intent.getExtras();
    bundle.putString("aaa", "back");//添加要返回给页面1的数据
    intent.setComponent(componentName);
    intent.putExtras(bundle);
    setResult(Activity.RESULT_OK, intent);//返回页面1
    finish();
```




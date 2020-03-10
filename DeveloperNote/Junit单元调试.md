# 单元调试

测试项目中某个方法是否运行正常的一种模块化调试方式。

## 位置

### 单元测试代码存储位置

``` text
app/src
     ├── androidTestjava (仪器化单元测试、UI测试)
     ├── main/java (业务代码)
     └── test/java  (本地单元测试)
```

## 注解解释🎍

### 详解

1. @Test : 测试方法，测试程序会运行的方法，后边可以跟参数代表不同的测试，如(expected=XXException.class) 异常测试，(timeout=xxx)超时测试

2. @Ignore : 被忽略的测试方法

3. @Before: 每一个测试方法之前运行

4. @After : 每一个测试方法之后运行

5. @BeforeClass: 所有测试开始之前运行

6. @AfterClass: 所有测试结束之后运行

### 运行顺序

@BeforeClass>@Before>@Test>@After>@AfterClass

测试中的只需要用到`@Before @Test @After`

## 举例🌰

代码中存在如下方法，但是不确定是否运行正常。

```java
public class Example {

    public int add(int a , int b){
        return a+b;
    }

}
```

进行单元调试

```java
public class ExampleUnitTest {

    @Before
    public void start(){
        //调试时第一次调用，初始化操作
        System.out.println("start");
    }

    @Test
    public void testAdd() {
        System.out.println("真正的测试类");
        Example example = new Example();
        int sum = example.add(1,2);
    }

    @After
    public void  end(){
       //调试后最后调用，用于进行清理操作
        System.out.println("end");
    }

}
```


####判断手机是否root?
1.搜索手机中的指定文件
```java
 private boolean isRoot() {
        boolean isRoot = false;
        String[] rootFiles = {"/system/bin/su", "/system/xbin/su"};
        for (String s : rootFiles) {
            File file = new File(s);
            if (file.exists()) {
                isRoot = true;
            }
        }
        return isRoot;
    }
```
>但是此方法会有遗漏

2.使用which命令
```java
private String runCommandShell(String string) throws IOException {
        StringBuilder result = new StringBuilder("");
        Process process = null;
        try {
            process = Runtime.getRuntime().exec(string);
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (process == null) {
            return result.toString();
        }

        InputStream inputStream = process.getInputStream();
        InputStreamReader inputStreamReader = new InputStreamReader(inputStream);
        BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
        String line = "";
        while ((line = bufferedReader.readLine()) != null) {
            result.append(line);
        }
        if (bufferedReader != null) {
            bufferedReader.close();
        }
        if (inputStream != null) {
            inputStream.close();
        }
        if (inputStream != null) {
            inputStream.close();
        }
        if (process != null) {
            process.destroy();
        }
        if (null == result) {
            result.append("");
        }
        return result.toString();

    }
```

```shell
#若是root的手机会有返回值
which su
#或者输入su,但是会有弹窗，影响体验
su
```

>但是此方法有问题，手机中可能没有which命令，可以在/sdcard/目录下push进一个busybox


3.判断是否有可执行权限
```shell
ls -l /system/bin/su                                         
-rwxr-xr-x root     shell      109252 2017-07-19 10:18 su
```

```java
private boolean isRoot() {
        boolean isRoot = false;
        String[] rootFiles = {"/system/bin/su", "/system/xbin/su"};
        for (String s : rootFiles) {
            File file = new File(s);
            if (file.exists() && file.isFile() && isExecutable(s)) {
                isRoot = true;
            }
        }
        return isRoot;
    }


    private static boolean isExecutable(String filePath) {
        Process p = null;
        try {
            p = Runtime.getRuntime().exec("ls -l " + filePath);
            // 获取返回内容
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    p.getInputStream()));
            String str = in.readLine();
            if (str != null && str.length() >= 4) {
                char flag = str.charAt(3);
                if (flag == 's' || flag == 'x')
                    return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (p != null) {
                p.destroy();
            }
        }
        return false;
    }
```
>此方法较为全面，但是还有遗漏的手机，比如手机的rom包更改过就无法判断，因为在手机中没有su这个文件

4.使用id命令
```shell
shell@P826T20:/ $ su
root@P826T20:/ # id
uid=0(root) gid=0(root) context=u:r:init:s0
```
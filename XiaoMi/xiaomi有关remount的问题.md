### 小米手机如何Remount?

```shell
$ adb root
restarting adbd as root
$ adb remount
dm_verity is enabled on the system partition.
Use "adb disable-verity" to disable verity.
If you do not, remount may succeed, however, you will still not be able to write to these volumes.
remount succeeded
$ adb disable-verity
Verity disabled on /system
Now reboot your device for settings to take effect
$ adb reboot
$ adb root
restarting adbd as root
$ adb remount
remount succeeded
```

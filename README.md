# rsync-&lt;arch&gt;
使用 Android NDK 为不同的移动架构构建 [rsync](https://rsync.samba.org) 可执行文件

## Clone
```bash
  $ git clone https://github.com/daliujs/rsync-mobile
  $ git submodule update --init --recursive
```

## Build
```bash
  // for build rsync-<arch>
  $ ./ndk_build.sh
  // for test bin files
  $ ./test.sh
```

## Android rsync-&lt;arch&gt; 文件

1. 需要放到 /system/bin 目录下
```bash
  $ adb root
  $ adb push rsync-<arch> /system/bin
```
2. 修改owner & group 及执行权限 (注，如果需要的话)
```bash
  $ adb shell
  $ chown root:shell /system/bin/rsync-<arch>
  $ chmod a+x /system/bin/rsync-<arch>
```
3. 修改文件属性
```bash
$ chmod 755 /system/bin/rsync-<arch>
```

## Android rsync-&lt;arch&gt; daemon 服务端
1. Rsync Daemon配置文件

```bash
$ cat rsyncd.conf

address = 0.0.0.0
port = 873
uid = 1000
gid = 1000
strict modes = false
use chroot = false
auth users = wanba
secrets file = /<path-to>/rsync.pass
lock file = /<path-to>/rsync.lock 
log file = /<path-to>/rsyncd.log

[sdcard_android_data]
path = /sdcard/Android/data/
comment = SD Android Data
list = true
read only = false
#write only = true

[sdcard_apks]
path = /sdcard/Apks/
comment = SD Apks
list = true
read only = false
#write only = true
```

2. secrets 文件
```bash
$ cat rsync.pass

wanba:123456
```

3. 需要把client端ip以及名称写入 /etc/hosts
```bash
$ cat /etc/hosts

127.0.0.1		    localhost
10.1.7.180		  bogon
```
4. 启动 Rsync Daemon 服务
```bash
$ rsync-<arch>  --daemon --verbose --config=/<path-to>/rsyncd.conf
```
## Android rsync-&lt;arch&gt; 客户端

1. Password 文件
```bash
$ cat password 
123456
```

2. 客户端 upload 文件到 服务端
```bash
$ rsync-<arch> -rv --password-file=password ./* rsync://wanba@<server-ip>/sdcard_android_data
$ rsync-<arch> -rv --password-file=password ./* wanba@10.1.3.86::sdcard_apks
```

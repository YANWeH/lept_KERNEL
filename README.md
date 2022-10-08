# 基于Centos7搭建MIT6.828实验环境

xv6 是一个类Unix的教学操作系统（MIT基于Unix v6 的重新实现），而 JOS 是在xv6的基础上改写，让我们能在其上进行实验的 OS。 所以，实际上当我们遇到不会实现的实验或不清晰实现的过程时，可以去参考 xv6 相应部分的源码

## 1 安装依赖包：

```shell
$ yum install libX11 libX11-devel SDL2 SDL2-devel -y
```

这个是我一开始在网上查到的，然后就安装上了，但一开始没有想到自己的linux是不支持图形界面的。如果是使用的linux图形界面就必须安装，如果是命令行的话其实是不需要的

```shell
$ yum install -y glib*
$ yum install zlib*
$ yum install autoconf
$ yum install SDL-devel  //如果没有图形界面而是命令行的话，不需要安装
$ yum install libtool*
$ yum install wget  	   //有的话就不用安装
```



## 2 创建6.828

完全跟着[MIT6.828官网](https://pdos.csail.mit.edu/6.828/2018/labs/lab1/)的步骤进行就行了。

```shell
$ mkdir 6.828
$ cd 6.828
$ cd lab
```

此时官网是默认系统中安装了qemu，但其实还没有安装。



## 3 安装qemu

```shell
$ git clone https://github.com/mit-pdos/6.828-qemu.git qemu
```

直接使用[官网提供的qemu](https://pdos.csail.mit.edu/6.828/2018/tools.html)就行了，是最合适的

```shell
$ cd qemu/
$ ./configure --disable-kvm --disable-werror --prefix=$HMOE --target-list="i386-softmmu x86_64-softmmu"			
```

上面的configure是没有关闭SDL的，如果系统不支持图形界面的话，之后启动就会报错

```shell
Could not initialize SDL(No available video device) - exiting
```

所以，如果只支持命令行的话，就需要加上`--disable-sdl`如果支持图形界面则不需要



执行configure后可能会报错：

```shell
ERROR: pixman >= 0.21.8 not present. Your options:
         (1) Preferred: Install the pixman devel package (any recent
             distro should have packages as Xorg needs pixman too).
         (2) Fetch the pixman submodule, using:
             git submodule update --init pixman
```

选择第二种方法：

```shell
$ git submodule update --init pixman
```

然后再执行configure，出现一下信息，说明成功了：

```shell
......
usb net redir     no
OpenGL support    yes
libiscsi support  no
libnfs support    no
build guest agent yes
QGA VSS support   no
seccomp support   no
coroutine backend ucontext
coroutine pool    yes
GlusterFS support no
Archipelago support no
gcov              gcov
gcov enabled      no
TPM support       yes
libssh2 support   no
TPM passthrough   yes
QOM debugging     yes
vhdx              no
Quorum            no
lzo support       no
snappy support    no
bzip2 support     no
NUMA host support no
```

使用vim 编辑qemu/qga/commands-posix.c

添加头文件`#include<sys/sysmacros.h>`

然后执行`make && make install`

至此，qemu安装成功



## 4 验证安装是否成功

此时应该在qemu的工作目录下，返回上一级lab/

```shell
$ cd ..
$ make
$ make qemu
```

如果出现一下画面就表示环境搭建成功：

```shell
qemu-system-i386 -drive file=obj/kern/kernel.img,index=0,media=disk,format=raw -serial mon:stdio -gdb tcp::25000 -D qemu.log 
VNC server running on `::1:5900'
6828 decimal is XXX octal!
entering test_backtrace 5
entering test_backtrace 4
entering test_backtrace 3
entering test_backtrace 2
entering test_backtrace 1
entering test_backtrace 0
leaving test_backtrace 0
leaving test_backtrace 1
leaving test_backtrace 2
leaving test_backtrace 3
leaving test_backtrace 4
leaving test_backtrace 5
Welcome to the JOS kernel monitor!
Type 'help' for a list of commands.
K> 
```

退出方法：`ctrl + a`然后松手，在键入`x`即可退出。



# 参考文章：

[MIT 6.828 JOS学习笔记1. Lab 1 Part 1: PC Bootstrap - fatsheep9146 - 博客园 (cnblogs.com)](https://www.cnblogs.com/fatsheep9146/p/5068353.html)
# Lab 5: File system, Spawn and Shell

本lab将实现JOS的文件系统，只要包括如下四部分：

1. 引入一个**文件系统进程（FS进程）**的特殊进程，该进程提供文件操作的接口。
2. **建立RPC机制**，客户端进程向FS进程发送请求，FS进程真正执行文件操作，并将数据返回给客户端进程。
3. 更高级的抽象，引入**文件描述符**。通过文件描述符这一层抽象就可以将**控制台，pipe，普通文件**，统统按照文件来对待。（文件描述符和pipe实现原理）
4. 支持从磁盘**加载程序**并运行。

##  File system preliminaries

完成一个相对简单的文件系统，其可以实现创建、读、写以及删除在分层目录结构中组织的文件。目前我们的OS只支持单用户，因此我们的文件系统也不支持UNIX文件拥有或权限的概念。同时也不支持硬链接、符号链接、时间戳或是特别的设备文件。

## Sectors and Blocks

大部分磁盘都是以Sector为粒度进行读写，JOS中Sectors为512字节。文件系统以block为单位分配和使用磁盘。注意区别，sector size是磁盘的属性，block size是操作系统使用磁盘的粒度。JOS的文件系统的block size被定为4096字节。

## Superblocks

文件系统使用一些特殊的block保存文件系统属性元数据，比如block size, disk size, 根目录位置等。这些特殊的block叫做superblocks。
我们的文件系统使用一个superblock，位于磁盘的block 1。block 0被用来保存boot loader和分区表。很多文件系统维护多个superblock，这样当一个损坏时，依然可以正常运行。
磁盘结构如下：

![](images\lab5_part1_disk_layout.jpg)

文件系统使用struct File结构描述文件，该结构包含文件名，大小，类型，保存文件内容的block号。struct File结构的f_direct数组保存前NDIRECT（10）个block号，这样对于10*4096=40KB的文件不需要额外的空间来记录内容block号。对于更大的文件我们分配一个额外的block来保存4096/4=1024 block号。所以我们的文件系统允许文件最多拥有1034个block，一个文件最大为4MB

![](images\lab5_part1_file结构.jpg)



## The Block Cache

文件系统最大支持3GB，文件系统进程保留从0x10000000 (DISKMAP)到0xD0000000 (DISKMAP+DISKMAX)固定3GB的内存空间作为磁盘的缓存。比如block 0被映射到虚拟地址0x10000000，block 1被映射到虚拟地址0x10001000以此类推。
如果将整个磁盘全部读到内存将非常耗时，所以我们将实现按需加载，只有当访问某个bolck对应的内存地址时出现页错误，才将该block从磁盘加载到对应的内存区域，然后重新执行内存访问指令。

`bc_pgfault`:

是FS进程缺页处理函数，负责将数据从磁盘读取到对应的内存。

`flush_block`:

将内存中addr地址上得数据写回磁盘，如果没有被映射或者不是脏块则直接return

![](images\lab5_part1_fs进程虚拟地址空间和磁盘.jpg)

### File Operations

基本的文件系统操作：

1. `file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)`：

   查找f指向文件结构的第filebno个block的存储地址，保存到ppdiskbno中。如果f->f_indirect还没有分配，且alloc为真，那么将分配新的block作为该文件的f->f_indirect。类比页表管理的pgdir_walk()。

2. `file_get_block(struct File *f, uint32_t filebno, char **blk)`：

   该函数查找文件第filebno个block对应的虚拟地址addr，将其保存到blk地址处。

3. `walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)`：

   解析路径path，填充pdir和pf地址处的File结构。比如/aa/bb/cc.c那么pdir指向代表bb目录的File结构，pf指向代表cc.c文件的File结构。又比如/aa/bb/cc.c，但是cc.c此时还不存在，那么pdir依旧指向代表bb目录的File结构，但是pf地址处应该为0，lastelem指向的字符串应该是cc.c。

4. `dir_lookup(struct File *dir, const char *name, struct File **file)`：

   该函数查找dir指向的文件内容，寻找File.name为name的File结构，并保存到file地址处。

5. `dir_alloc_file(struct File *dir, struct File **file)`：

   在dir目录文件的内容中寻找一个未被使用的File结构，将其地址保存到file的地址处。

文件操作：

1. `file_create(const char *path, struct File **pf)`：

   创建path，如果创建成功pf指向新创建的File指针。

2. `file_open(const char *path, struct File **pf)`：

   寻找path对应的File结构地址，保存到pf地址处。

3. `file_read(struct File *f, void *buf, size_t count, off_t offset)`：

   文件f中的offset字节处读取count字节到buf处。

4. `file_write(struct File *f, const void *buf, size_t count, off_t offset)`：

   将buf处的count字节写到文件f的offset开始的位置。



### The file system interface

RPC: Remote Procedure Call 

通过网络从远程计算机程序上请求服务，而不需要了解底层网络技术的协议。RPC协议假定某些传输协议的存在，如TCP或UDP，为通信程序之间携带信息数据。在OSI网络通信模型中，RPC跨越了传输层和应用层。RPC使得开发包括网络分布式多程序在内的应用程序更加容易。

本质上RPC还是借助IPC机制实现的，普通进程通过IPC向FS进程间发送具体操作和操作数据，然后FS进程执行文件操作，最后又将结果通过IPC返回给普通进程。

![](images\lab5_part1_文件系统数据结构.jpg)

![](images\lab5_part1_fs调用过程.jpg)

客户端进程向FS进程发送请求，FS进程真正执行文件操作。客户端进程的实现在lib/file.c，lib/fd.c中。客户端进程和FS进程交互可总结为下图：

![](images\lab5_fs进程实现原理.jpg)



### Spawning Processes

`spawn(const char *prog, const char **argv)`做如下一系列动作：

1. 从文件系统打开prog程序文件
2. 调用系统调用sys_exofork()创建一个新的Env结构
3. 调用系统调用sys_env_set_trapframe()，设置新的Env结构的Trapframe字段（该字段包含寄存器信息）。
4. 根据ELF文件中program herder，将用户程序以Segment读入内存，并映射到指定的线性地址处。
5. 调用系统调用sys_env_set_status()设置新的Env结构状态为ENV_RUNNABLE。



### Sharing library state across fork and spawn

UNIX文件描述符包括pipe，console I/O。 在JOS中，这些设备类型都有1个与与它关联的struct Dev，里面有实现read/write等文件操作的函数指针。在lib/fd.c中实现了传统UNIX的文件描述符接口。
　　在lib/fd.c中也包括每个客户进程的文件描述符表布局，开始于FSTABLE。这块空间为每个描述符保留了1个页的地址空间。 在任何时候，只有当文件描述符在使用中才在文件描述符表中映射页。
　　我们想要共享文件描述符状态在调用fork和spawn创建新进程。当下，fork函数使用COW会将状态复制1份而不是共享。在spawn中，状态则不会被拷贝而是完全舍弃。
　　所以我们将改变fork来共享状态。在inc/lib.h中新定义了PTE_SHARE位来标识页共享。当页表入口中设置了该位，则应该从父进程中拷贝PTE映射到子进程在fork和spawn时。



### The keyboard interface

实现 I/O 重定向。第一反映就是解析`<`后的文件，通过打开文件获得文件描述符，再将此文件描述符传入关联到标准输入 0（使用`dup`实现），最后关闭之前获得的描述符。



引入**文件描述符**。通过文件描述符这一层抽象就可以将**控制台，pipe，普通文件**，统统按照文件来对待。文件描述符和pipe的原理总结如下：

![](images\lab5_fd实现原理_pipe实现原理.png)

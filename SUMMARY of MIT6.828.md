# lab1：Booting a PC

使用GNU汇编程序

GDT表：在保护模式下对内存进行寻址

`((void (*)(void)) (ELFHDR->e_entry))();`:将ELFHDR->e_entry（整数）强制类型转化为函数指针，其类型为(void (*)(void)：参数为void，返回值为void的函数指针类型

![](images\sum_lab1_load_kernel.png)

`CR0`中含有控制处理器操作模式和状态的系统控制标志；

`CR1`保留不用；

`CR2`含有导致页错误的线性地址；

`CR3`中含有页目录表物理内存基地址，因此该寄存器也被称为页目录基地址寄存器PDBR（Page-Directory Base addressRegister）



esp:指向当前栈帧的顶部。

ebp:指向当前栈帧的底部。

eip:CPU下次要执行的指令的地址，指向当前栈帧中执行的指令（可以理解为读取esp地址中所对应的信息）



## lab1总结

逻辑地址 线性地址 物理地址

逻辑地址：（段基址：段内偏移）==线性地址

实模式与保护模式（GDT LDT）

**PC启动后的运行顺序为 BIOS --> boot loader --> 操作系统内核**

boot loader：

1. 创建两个全局描述符表项（代码段和数据段），然后进入保护模式
2. 从磁盘加载kernel到内存

elf文件：把程序存放在磁盘上的一种数据结构



# Lab 2: Memory Management

内存管理两个组件：

1. 物理内存分配器：pages（4096b）
2. 虚拟内存：将内核和用户软件使用的虚拟地址映射到物理内存中的地址

`boot_alloc( )`函数：启动时初始化n个byte的空间

`mem_init ( )`函数：将空间划分为有pageinfo结构的页

`page_init()`函数：初始化页面，标记哪些能用哪些不能用

`page_alloc( )`函数：分配页面

`page_free( )`函数：释放页面



`pgdir_walk( )`：实现虚拟地址到物理地址的翻译，create控制在不存在的情况下是否分配新的物理地址给对应的虚拟地址，返回虚拟地址对应的页目录项（PTE），由于页目录项是存的物理地址，而可进行直接操作的是虚拟地址，因此返回的是PTE对应的虚拟地址

`boot_map_region( )`：将虚拟地址映射到指定的物理地址上

`page_lookup( )`：返回虚拟地址对应的物理页面，并且将PTE存到pte_store中

`page_remove( )`：取消虚拟地址映射的物理地址

`page_insert( )`：将物理页面映射到虚拟地址上





## lab2总结

物理内存分配 虚拟内存映射至物理内存

一页（4096byte）

struct PageInfo：指向下一个空闲页的指针，当前页的引用次数

TLB：缓存常访问的页表或页目录

内核地址空间映射物理地址关系图：

![](images\sum_lab2_内核空间映射物理地址.jpg)

分页机制：保护模式下进行，创建页表页目录，载入到cr3寄存器，设置cr0的PG位为1



# Lab 3: User Environments

环境env==进程

内联汇编：相当于用汇编语句写成的内联函数

```assembly
asm("movl %ecx, %eax"); /* 把 ecx 内容移动到 eax */

__asm__("movb %bh , (%eax)"); /* 把bh中一个字节的内容移动到eax指向的内存 */
```

`env_init( )`：初始化envs数组，构建env_free_list链表

`env_setup_vm( )`：初始化e指向的Env结构代表的用户环境的线性地址空间，设置e->env_pgdir字段

`region_alloc( )`：操作e->env_pgdir，为[va, va+len)分配物理空间

`load_icode( )`：加载binary地址开始处的ELF文件

`env_create( )`：从env_free_list链表拿一个Env结构，加载从binary地址开始处的ELF可执行文件到该Env结构

`env_run( )`：执行用户环境

为了防止中断发生时，当前运行的代码不会跳转到内核的任意位置执行，x86提供了两种机制：

1. 中断描述符表IDT：中断发生时处理程序入口
2. 任务状态段TSS：中断发生时，处理器状态，比如eip和cs寄存器的值





## lab3总结

完成env映射后的虚拟地址与物理地址的关系图：

![](images\sum_lab3_虚拟到物理.jpg)

用户环境设置：加载用户页目录表，载入struct env_tf中的寄存器的值（包括ds es esp等等）



系统调用的完整流程：以user/hello.c为例，其中调用了cprintf()，注意这是lib/print.c中的cprintf，该cprintf()最终会调用lib/syscall.c中的sys_cputs()，sys_cputs()又会调用lib/syscall.c中的syscall()，该函数将系统调用号放入%eax寄存器，五个参数依次放入in DX, CX, BX, DI, SI，然后执行指令int 0x30，发生中断后，去IDT中查找中断处理函数，最终会走到kern/trap.c的trap_dispatch()中，我们根据中断号0x30，又会调用kern/syscall.c中的syscall()函数（注意这时候我们已经进入了内核模式CPL=0），在该函数中根据系统调用号调用kern/print.c中的cprintf()函数，该函数最终调用kern/console.c中的cputchar()将字符串打印到控制台。当trap_dispatch()返回后，trap()会调用`env_run(curenv);`，该函数前面讲过，会将curenv->env_tf结构中保存的寄存器快照重新恢复到寄存器中，这样又会回到用户程序系统调用之后的那条指令运行，只是这时候已经执行了系统调用并且寄存器eax中保存着系统调用的返回值。任务完成重新回到用户模式CPL=3。



# Lab 4: Preemptive Multitasking

抢占式多用户环境

多处理器——对称多处理（SMP），分为两类：

引导处理器（BSP）：初始化系统和引导操作系统

应用处理器（AP）：只有在操作系统启动并运行后，由 BSP 激活

在SMP系统中，每个CPU都有一个本地APIC（高级可编程中断处理器），负责在整个系统中提供中断

内存映射IO（MMIO）：这样就能通过访问内存达到访问设备寄存器的目的

每个CPU独有的变量：

- 内核栈
- TSS描述符
- 每个核当前执行的任务
- 每个核的寄存器

自旋锁（spin_lock）：忙等待，不会主动放弃CPU，需要抢占式调度器，才能切换线程或进程

互斥锁（mutex）：主动放弃CPU，进入睡眠（挂起）状态，在解锁后由内核主动唤醒

轮询调度机制——sched_yield（）：选择一个新的环境（进程）运行，循环方式搜索envs数组。

同时将sched_yield（）加入系统调用中，使得用户环境可以主动发出调用该函数的请求，从而自愿放弃CPU，执行其他环境（进程）

COW写时复制——在父进程创建子进程时，仅复制内存的映射，在进程修改内容时才copy出一个备份。



用户缺页中断：执行内核函数链：trap()->trap_dispatch()->page_fault_handler()

page_fault_handler()切换栈到用户异常栈，并且压入UTrapframe结构，然后调用curenv->env_pgfault_upcall（系统调用sys_env_set_pgfault_upcall()设置）处代码。又重新回到用户态。

用户异常栈是每个进程必须都有的，因此无论fork是不是COW技术，都必须分配给子进程一个物理页（硬拷贝）作为异常栈

COW主要流程就是：
　　1、申请新的物理页，映射到子进程的(UXSTACKTOP-PGSIZE)位置上去。
　　2、父进程的PFTEMP位置也映射到子进程新申请的物理页上去，这样父进程也可以访问这一页。
　　3、在父进程空间中，将用户错误栈全部拷贝到子进程的错误栈上去，也就是刚刚申请的那一页。
　　4、然后父进程解除对PFTEMP的映射。
　　5、最后把子进程的状态设置为可运行。



环境（进程）采用时间片调度算法



进程间通信（IPC）：

- 管道
- 共享内存
- 消息队列
- 信号量与PV操作
- 信号
- socket

信号与中断的相似点：
（1）采用了相同的异步通信方式；
（2）当检测出有信号或中断请求时，都暂停正在执行的程序而转去执行相应的处理程序；
（3）都在处理完毕后返回到原来的断点；
（4）对信号或中断都可进行屏蔽。
信号与中断的区别：
（1）中断有优先级，而信号没有优先级，所有的信号都是平等的；
（2）信号处理程序是在 用户态 下运行的，而中断处理程序是在 核心态 下运行；
（3）中断响应是及时的，而信号响应通常都有较大的时间延迟。





## lab4总结

整个启动过程大概如下：
　　 `i386_init`–>BSP获得锁–>`boot_ap`–>(BSP建立为每个cpu建立idle任务、建立用户任务，`mp_main`)—>BSP的`sched_yield`–>其中的`env_run`释放锁–>AP1获得锁–>执行sched_yield–>释放锁–>AP2获得锁–>执行sched_yield–>释放锁…..



# Lab 5: File system, Spawn and Shell

文件系统

扇区：磁盘硬件的属性，512字节

块：操作系统读取一次磁盘的的大小，UNIX xv6文件系统使用512字节，本实验使用4096字节，方便匹配处理器的页面大小

超级块Superblocks：保存文件系统属性元数据，比如block size, disk size, 根目录位置等

将IDE磁盘驱动程序实现为用户级文件系统环境（进程）的一部分

bitmap：将磁盘上的每个块用一位来记录是否使用





## lab5总结

采用文件管理系统环境（进程），用户进程请求文件操作时，通过RPC协议采用IPC机制进行通信

将用户环境看作客户端，文件系统看作服务端

# Lab4_Preemptive Multitasking

**把SMP技术应用在单个CPU中，为了与SMP区分，单个物理CPU内，等同原来单个CPU的模块称之为Core（核心），这样的CPU称之为多核CPU。**

我们将让 JOS 支持对称多处理器（symmetric multiprocessing，SMP），这是一种多处理器模型，其中所有CPU都具有对系统资源（如内存和I / O总线）的等效访问。虽然所有CPU在SMP中功能相同，但在引导过程中它们可分为两种类型：

- 引导处理器（BSP）：负责初始化系统和引导操作系统;
- 应用程序处理器（AP）：只有在操作系统启动并运行后，BSP才会激活应用程序处理器。

在SMP系统中，每个CPU都有一个附带的本地APIC（LAPIC）单元。

APIC:Advanced Programmable Interrupt Controller高级可编程中断控制器 。APIC 是装置的扩充组合用来驱动 Interrupt 控制器 [1] 。在目前的建置中，系统的每一个部份都是经由 APIC Bus 连接的。"本机 APIC" 为系统的一部份，负责传递 Interrupt 至指定的处理器；举例来说，当一台机器上有三个处理器则它必须相对的要有三个本机 APIC。

LAPIC单元负责在整个系统中提供中断。 LAPIC还为其连接的CPU提供唯一标识符。 在本实验中，我们使用LAPIC单元的以下基本功能（在`kern/lapic.c`中）：

- 根据LAPIC识别码（APIC ID）区别我们的代码运行在哪个CPU上。（`cpunum()`）
- 从BSP向APs发送`STARTUP`处理器间中断（IPI）去唤醒其他的CPU。（`lapic_startap()`）
- 在Part C，我们编写LAPIC的内置定时器来触发时钟中断，以支持抢占式多任务（`pic_init()`）。

## Part A: Multiprocessor Support and Cooperative Multitasking

### Multiprocessor Support

处理器通过内存映射IO(MMIO)的方式访问它的LAPIC。在MMIO中，一部分物理地址被硬连接到一些IO设备的寄存器，导致操作内存的指令load/store可以直接操作设备的寄存器。

[内存映射IO与端口映射IO](https://blog.csdn.net/qq_43606914/article/details/106959334)：

MMIO(Memory mapping [I/O](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/I%2FO/84718))即[内存映射I/O](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/%E5%86%85%E5%AD%98%E6%98%A0%E5%B0%84I%2FO)，它是PCI规范的一部分，[I/O设备](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/I%2FO%E8%AE%BE%E5%A4%87/9688581)被放置在内存空间而不是I/O空间。从处理器的角度看，内存映射I/O后系统设备访问起来和内存一样。这样访问AGP/PCI-E显卡上的[帧缓存](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/%E5%B8%A7%E7%BC%93%E5%AD%98)，BIOS，PCI设备就可以使用读写内存一样的[汇编指令](https://link.zhihu.com/?target=https%3A//baike.baidu.com/item/%E6%B1%87%E7%BC%96%E6%8C%87%E4%BB%A4)完成，简化了程序设计的难度和接口的复杂性。

PortIO和MMIO 的主要区别
1）前者不占用CPU的物理地址空间，后者占有（这是对x86架构说的，一些架构，如IA64，port I/O占用物理地址空间）。

2）前者是顺序访问。也就是说在一条I/O指令完成前，下一条指令不会执行。例如通过Port I/O对设备发起了操作，造成了设备寄存器状态变化，这个变化在下一条指令执行前生效。uncache的MMIO通过uncahce memory的特性保证顺序性。

3）使用方式不同

由于port I/O有独立的64K I/O地址空间，但CPU的地址线只有一套，所以必须区分地址属于物理地址空间还是I/O地址空间。

kern/pmap.c : : `mmio_map_region`:

设置个静态变量记录每次变化后的虚拟基地址，使用boot_map_region函数将[pa,pa+size)的物理地址映射到[base,base+size)，记得把size roundup到PGSIZE。由于这是设备内存并不是正常的DRAM，所以使用cache缓存访问是不安全的，我们可以用页的标志位来实现。



### Application Processor Bootstrap

在启动APs之前，BSP应该先收集关于多处理器系统的配置信息，比如CPU总数，CPUs的APIC ID，LAPIC单元的MMIO地址等。在kern/mpconfig文件中的mp_init()函数通过读BIOS设定的MP配置表获取这些信息。
boot_aps(kern/init.c)函数驱使AP引导程序。APs开始于实模式，跟BSP的开始相同，故此boot_aps函数拷贝AP入口代码(kern/mpentry.S)到实模式下的内存寻址空间。但是跟BSP不一样的是，我们需要有一些控制当AP开始执行时。我们将拷贝入口代码到0x7000(MPENTRY_PADDR)。
之后，boot_aps函数通过发送STARTUP的IPI(处理器间中断)信号到AP的LAPIC单元来一个个地激活AP。在kern/mpentry.S中的入口代码跟boot/boot.S中的代码类似。在一些简短的配置后，它使AP进入开启分页机制的保护模式，调用C语言的setup函数mp_main。



整理一下程序运行过程，此过程一直都运行在CPU0，即BSP上，工作在保护模式。

- i386_init调用了boot_aps()，也就是在BSP中引导其他CPU开始运行
- boot_aps调用`memmove`将每个CPU的boot代码加载到固定位置
- 最后调用`lapic_startap`执行其bootloader启动对应的CPU



### Per-CPU State and Initialization

当编写一个多进程OS时，这是非常重要的去区分哪些是每个进程私有的CPU状态，哪些是整个系统共享的全局状态。在kern/cpu.h中定义了大部分的per-CPU状态。
　　 每个CPU独有的变量应该有：

- 内核栈，因为不同的核可能同时进入到内核中执行，因此需要有不同的内核栈
- TSS描述符
- 每个核的当前执行的任务
- 每个核的寄存器

在一个多任务环境中，当发生了任务切换，需保护现场，因此每个任务的应当用一个额外的内存区域保存相关信息，即任务状态段(TSS)；TSS格式固定，104个字节，处理器固件能识别TSS中元素，并在任务切换时读取其中信息。

[任务状态段TSS及TSS描述符、局部描述符表LDT及LDT描述符](https://blog.csdn.net/MJ_Lee/article/details/104419980)

![](images\lab4_partA_GDT_LDT_TSS.jpg)

kern/pmap.c : :`mem_init_mp`:

将内核栈线性地址映射到percpu_kstacks处的物理地址处。

kern/trap.c : :`trap_init_percpu`:

由于有多个CPU，所以在这里不能使用原先的全局变量ts，应该利用thiscpu指向的CpuInfo结构体和cpunum函数来为每个核的TSS进行初始化



### locking

 在mp_main函数中初始化AP后，代码就会进入自旋。在让AP进行更多操作之前，我们首先要解决多CPU同时运行在内核时产生的竞争问题。最简单的办法是实现1个大内核锁，1次只让一个进程进入内核模式，当离开内核时释放锁。

在kern/spinlock.h中声明了大内核锁，提供了lock_kernel和unlock_kernel函数来快捷地获得和释放锁。总共有四处用到大内核锁：

- 在启动的时候，BSP启动其余的CPU之前，BSP需要取得内核锁

- mp_main中，也就是CPU被启动之后执行的第一个函数，这里应该是调用调度函数，选择一个进程来执行的，但是在执行调度函数之前，必须获取锁

- trap函数也要修改，因为可以访问临界区的CPU只能有一个，所以从用户态陷入到内核态的话，要加锁，因为可能多个CPU同时陷入内核态

- env_run函数，也就是启动进程的函数，之前在试验3中实现的，在这个函数执行结束之后，就将跳回到用户态，此时离开内核，也就是需要将内核锁释放

  加锁后，将原有的并行执行过程在关键位置变为串行执行过程，整个启动过程大概如下：

  i386_init–>BSP获得锁–>boot_ap–>(BSP建立为每个cpu建立idle任务、建立用户任务，mp_main)—>BSP的sched_yield–>其中的env_run释放锁–>AP1获得锁–>执行sched_yield–>释放锁–>AP2获得锁–>执行sched_yield–>释放锁…..



### Round-Robin Scheduling

kern/sched.c : :`sched_yield`:

轮循调度机制： 主要是在sched_yield函数内实现，从该核上一次运行的进程开始，在进程描述符表中寻找下一个可以运行的进程，如果没找到而且上一个进程依然是可以运行的，那么就可以继续运行上一个进程，同时将这个算法实现为了一个系统调用，进程可以主动放弃CPU



### System Calls for Environment Creation

虽然内核现在有能力运行和切换多用户级进程，但是它仍然只能跑内核初始创建的进程。现在将实现必要的JOS系统调用来运行用户进程来创建和启动其它新的用户进程。

Unix提供fork()系统调用创建新的进程，fork()拷贝父进程的地址空间和寄存器状态到子进程。父进程从fork()返回的是子进程的进程ID，而子进程从fork()返回的是0。父进程和子进程有独立的地址空间，任何一方修改了内存，不会影响到另一方。
现在需要实现如下系统调用：

1. `sys_exofork()`：
   创建一个新的进程，用户地址空间没有映射，不能运行，寄存器状态和父环境一致。在父进程中sys_exofork()返回新进程的envid，子进程返回0。
2. `sys_env_set_status`：设置一个特定进程的状态为ENV_RUNNABLE或ENV_NOT_RUNNABLE。
3. `sys_page_alloc`：为特定进程分配一个物理页，映射指定线性地址va到该物理页。
4. `sys_page_map`：拷贝页表，使指定进程共享当前进程相同的映射关系。本质上是修改特定进程的页目录和页表。
5. `sys_page_unmap`：解除页映射关系。本质上是修改指定用户环境的页目录和页表。



### 遇到的BUG：

```shell
dumbfork: Timeout! FAIL (32.4s) 
    AssertionError:      + cc kern/init.c
         + ld obj/kern/kernel
         + mk obj/kern/kernel.img
         qemu: terminating on signal 15 from pid 12559
    MISSING '.00000000. new env 00001000'
    MISSING '.00001000. new env 00001001'
    MISSING '0: I am the parent.'
    MISSING '9: I am the parent.'
    MISSING '0: I am the child.'
    MISSING '9: I am the child.'
    MISSING '19: I am the child.'
    MISSING '.00001000. exiting gracefully'
    MISSING '.00001000. free env 00001000'
    MISSING '.00001001. exiting gracefully'
    MISSING '.00001001. free env 00001001'
```

一开始以为是自己写的代码内容或者结构有问题，花了3天时间反复查找都没有找到错误。最后在网上的提示下意识到可能是gradelib.py中的timeout时间限制问题：

```python
class Runner():
    def __init__(self, *default_monitors):
        self.__default_monitors = default_monitors

    def run_qemu(self, *monitors, **kw):
        """Run a QEMU-based test.  monitors should functions that will
        be called with this Runner instance once QEMU and GDB are
        started.  Typically, they should register callbacks that throw
        TerminateTest when stop events occur.  The target_base
        argument gives the make target to run.  The make_args argument
        should be a list of additional arguments to pass to make.  The
        timeout argument bounds how long to run before returning."""

        def run_qemu_kw(target_base="qemu", make_args=[], timeout=100):
            return target_base, make_args, timeout
        target_base, make_args, timeout = run_qemu_kw(**kw)
```

将原本的timeout=30改为100，终于能通过了。

只能怪自己的电脑太拉了，该换电脑了:cry:



## PartB:Copy-on-Write Fork

子进程在被创建之后很可能立刻执行exec()了，之前做的一系列的拷贝就是无用功了。

fork()函数创建了调用进程的一份拷贝，但很多应用程序要求子进程执行与其父进程不同的代码。**exec函数提供了用新映象覆盖调用进程映象的功能。** 组合使用fork-exec的传统方法是子进程（用exec函数）执行新程序（新的代码段），而父进程继续执行原来的代码。

实现fork()有多种方式，一种是将父进程的内容全部拷贝一次，这样的话父进程和子进程就能做到进程隔离，但是这种方式非常耗时，需要在物理内存中复制父进程的内容。
另一种方式叫做**写时拷贝的技术(copy on write)**，父进程将自己的页目录和页表复制给子进程，这样父进程和子进程就能访问相同的内容。只有当一方执行写操作时，才复制这一物理页。这样既能做到地址空间隔离，又能节省了大量的拷贝工作。

![](images\lab4_partB_COW.jpg)

想要实现写时拷贝的fork()需要先实现用户级别的缺页中断处理函数。

### User-level page fault handling

1个用户级写时拷贝的fork函数需要在写保护页时触发page fault，所以我们第一步应该先规定或者确立一个page fault处理例程，每个进程需要向内核注册这个处理例程，只需要传递一个函数指针即可，sys_env_set_pgfault_upcall函数将当前进程的page fault处理例程设置为func指向的函数。

kern/syscall.c : :`sys_env_set_pgfault_upcall`:

该系统调用为指定的用户环境设置env_pgfault_upcall。缺页中断发生时，会执行env_pgfault_upcall指定位置的代码。当执行env_pgfault_upcall指定位置的代码时，栈已经转到异常栈，并且压入了UTrapframe结构。

#### Normal and Exception Stacks in User Environments

在正常运行期间，用户进程运行在用户栈上，栈顶寄存器ESP指向USTACKTOP处，堆栈数据位于USTACKTOP-PGSIZE 与USTACKTOP-1之间的页。当在用户模式发生1个page fault时，内核将在专门处理page fault的用户异常栈上重新启动进程。

到目前为止出现三个栈：

```shell
[KSTACKTOP-KSTKSIZE,  KSTACKTOP) 
　　内核态系统栈

[UXSTACKTOP - PGSIZE, UXSTACKTOP )
　　用户态错误处理栈

[UTEXT, USTACKTOP)
　　用户态运行栈
```

用户定义注册了自己的中断处理程序之后，相应的例程运行时的栈，整个过程如下：
首先陷入到内核，栈位置从用户运行栈切换到内核栈，进入到trap中，进行中断处理分发，进入到`page_fault_handler()`
当确认是用户程序触发的page fault的时候(内核触发的直接panic了)，为其在用户错误栈里分配一个`UTrapframe`的大小。
把栈切换到用户错误栈，运行响应的用户中断处理程序，中断处理程序可能会触发另外一个同类型的中断，这个时候就会产生递归式的处理。处理完成之后，返回到用户运行栈。

可以将用户自己定义的用户处理进程当作是一次函数调用看待，当错误发生的时候，调用一个函数，但实际上还是当前这个进程，并没有发生变化。所以当切换到异常栈的时候，依然运行当前进程，但只是运行的中断处理函数，所以说此时的栈指针发生了变化，而且程序计数器eip也发生了变化，同时还需要知道的是引发错误的地址在哪。这些都是要在切换到异常栈的时候需要传递的信息。和之前从用户栈切换到内核栈一样，这里是通过在栈上构造结构体，传递指针完成的。

整体上讲，当正常执行过程中发生了页错误，那么栈的切换是
　　用户运行栈—>内核栈—>异常栈
　　而如果在异常处理程序中发生了也错误，那么栈的切换是
　　异常栈—>内核栈—>异常栈

`page_fault_handler`:

在该函数中应该做如下几件事：

1. 判断curenv->env_pgfault_upcall是否设置，如果没有设置也就没办法修复，直接销毁该进程。

2. 修改esp，切换到用户异常栈。

3. 在栈上压入一个UTrapframe结构。

4. 将eip设置为curenv->env_pgfault_upcall，然后回到用户态执行curenv->env_pgfault_upcall处的代码。

   

#### User-mode Page Fault Entrypoint

当从用户定义的处理函数返回之后，如何从用户错误栈直接返回到用户运行栈。

lib/pfentry : :`_pgfault_upcall`:

是所有用户页错误处理程序的入口，在这里调用用户自定义的处理程序，并在处理完成后，从错误栈中保存的UTrapframe中恢复相应信息，然后跳回到发生错误之前的指令，恢复原来的进程运行。[详细分析](https://blog.csdn.net/bysui/article/details/51842817)



### 缺页处理小结：

1. 引发缺页中断，执行内核函数链：trap()->trap_dispatch()->page_fault_handler()
2. page_fault_handler()切换栈到用户异常栈，并且压入UTrapframe结构，然后调用curenv->env_pgfault_upcall（系统调用sys_env_set_pgfault_upcall()设置）处代码。又重新回到用户态。
3. 进入_pgfault_upcall处的代码执行，调用_pgfault_handler（库函数set_pgfault_handler()设置）处的代码，最后返回到缺页中断发生时的那条指令重新执行。

![](images\lab4_partB_缺页异常处理逻辑.jpg)



#### Implementing Copy-on-Write Fork

与`dumfork`不同的是，fork 只复制了页映射关系，并且只在尝试对页进行写操作时才进行页内容的 copy。

`fork`控制流如下：

1. parent 注册 handler
2. parent call `sys_exofork` 创建子进程
3. 对每个处于 `UTOP`之下的可写或COW页进行复制`duppage`。**它应该将 copy-on-write 页面映射到子进程的地址空间，然后重新映射 copy-on-write 页面到它自己的地址空间。**

此处的顺序十分重要——先将子进程的页标记为`COW`，然后将父进程的页标记为`COW`：

猜测：如果先将父进程标记为COW，此时，如果有另一个进程抢占CPU，那么此时的子进程此时的状态并没有COW，则如果子进程被改变时，并不会发生COW，以至于修改了与父进程共享的内存

lab/fork.c : :`pgfault`:已经发生COW（即有进程修改了页内容）则需要进行复制

1. `pgfault()`检查错误是否为写入FEC_WR（在错误代码中检查），并且页面的 PTE 是否标记为 `PTE_COW`。如果没有，请panic。
2. `pgfault()`在临时位置分配映射的新页面，并将错误页面的内容复制到其中。然后，错误处理程序使用读/写权限将新页面映射到会修改该页的进程中的地址，以代替旧的只读映射。

`duppage`:

进行COW方式的页复制（相当于复制映射，而不是复制页本身），所以将当前进程的第pn页对应的物理页的映射到envid的第pn页上去，同时将这一页都标记为COW。

`fork`:

设置异常处理函数，创建子进程，映射页面到子进程，为子进程分配用户异常栈并设置 `pgfault_upcall` 入口，将子进程设置为可运行的



## Part C: Preemptive Multitasking and Inter-Process communication (IPC)

实现抢占非协作式环境，并且实现进程间通信

### Clock Interrupts and Preemption

如果一个进程获得CPU后一直死循环而不主动让出CPU的控制权， 整个系统都将 halt。为了允许内核抢占正在运行的环境，强行重获CPU控制权，我们必须扩展JOS内核以支持来自时钟的外部硬件中断。

外部中断（如设备中断）被称为 IRQs。 IRQ号到 IDT 项的映射不是固定的，其会加上一个IRQ_OFFSET的偏移，在`picirq.c `的`pic_init`中进行了这个映射过程。外部中断的初始化，实际上就是对硬件 8259A的初始化



### Handling Clock Interrupts



### Inter-Process communication (IPC)

`sys_ipc_recv`:

其功能是当一个进程试图去接收信息的时候，应该将自己标记为正在接收信息，而且为了不浪费CPU资源，应该同时标记自己为ENV_NOT_RUNNABLE，只有当有进程向自己发了信息之后，才会重新恢复可运行。最后将自己标记为不可运行之后，调用调度器运行其他进程。

env_ipc_recving：
　　当进程使用env_ipc_recv函数等待信息时，会将这个成员设置为1，然后堵塞等待；当一个进程向它发消息解除堵塞后，发送进程将此成员修改为0。
env_ipc_dstva：
　　如果进程要接受消息并且是传送页，保存页映射的地址，且该地址<=UTOP。
env_ipc_value：
　　若等待消息的进程接收到消息，发送方将接收方此成员设置为消息值。
env_ipc_from：
	　发送方负责设置该成员为自己的envid号。
env_ipc_perm：
　　如果进程要接收消息并且传送页，那么发送方发送页之后将传送的页权限赋给这个成员。

`sys_ipc_try_send`:

权限是否符合要求，要传送的页有没有，能不能将这一页映射到对方页表中去等等。如果srcva是在UTOP之下，那么说明是要共享内存，那就首先要在发送方的页表中找到srcva对应的页表项，然后在接收方给定的虚地址处插入这个页表项。接收完成之后，重新将当前进程设置为可运行，同时把env_ipc_recving设置为0，以防止其他的进程再发送，覆盖掉当前的内容。

![](images\lab4_partC_IPC原理.jpg)



`thisenv`在`lib/libmain.c`中定义。`const volatile struct Env *thisenv;`。`currenv`在`kern/env.h`中定义`#define curenv (thiscpu->cpu_env) `。thisenv到底起到了什么作用？记录需要运行的用户环境，可以传递给`env_run()`去运行。 而curenv实实在在得记录了当前CUP运行的环境。

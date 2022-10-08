# lab3:User Environment

主要介绍JOS中的进程，异常处理，系统调用。内容上分为三部分：

1. 用户环境建立，可以加载用户ELF文件并执行。（目前还没有文件系统，需要在内核代码硬编码需要加载的用户程序）

2. 建立异常处理机制，异常发生时能从用户态进入内核进行处理，然后返回用户态。

3. 借助异常处理机制，提供系统调用的能力。

   

## Part A: User Environments and Exception Handling

用户环境指的就是一个应用程序运行在系统中所需要的一个上下文环境，操作系统内核使用数据结构 Env 来记录每一个用户环境的信息。

```c
struct Env *envs = NULL;    //所有的 Env 结构体
struct Env *curenv = NULL;   //目前正在运行的用户环境
static struct Env *env_free_list;  //还没有被使用的 Env 结构体链表
```

```c
struct Env {
　　　　struct Trapframe env_tf;      //saved registers
　　　　struct Env * env_link;         //next free Env
　　　　envid_t env_id;　　            //Unique environment identifier
　　　　envid_t env_parent_id;        //envid of this env's parent
　　　　enum EnvType env_type;　　//Indicates special system environment
　　　　unsigned env_status;　　   //Status of the environment
　　　　uint32_t env_runs;         //Number of the times environment has run
　　　　pde_t *env_pgdir;　　　　//Kernel virtual address of page dir.

};　　
```

env_tf:
　　这个类型的结构体在inc/trap.h文件中被定义，里面存放着当用户环境暂停运行时，所有重要寄存器的值。内核也会在系统从用户态切换到内核态时保存这些值，这样的话用户环境可以在之后被恢复，继续执行。

env_link:
　　这个指针指向在env_free_list中，该结构体的后一个free的Env结构体。当然前提是这个结构体还没有被分配给任意一个用户环境时，该域才有用。

env_id:
　　这个值可以唯一的确定使用这个结构体的用户环境是什么。当这个用户环境终止，内核会把这个结构体分配给另外一个不同的环境，这个新的环境会有不同的env_id值。

env_parent_id:
　　创建这个用户环境的父用户环境的env_id

env_type:
　　用于区别出来某个特定的用户环境。对于大多数环境来说，它的值都是 ENV_TYPE_USER.

env_status:
　　这个变量存放以下可能的值
　　ENV_FREE: 代表这个结构体是不活跃的，应该在链表env_free_list中。
　　ENV_RUNNABLE: 代表这个结构体对应的用户环境已经就绪，等待被分配处理机。
　　ENV_RUNNING: 代表这个结构体对应的用户环境正在运行。
　　ENV_NOT_RUNNABLE: 代表这个结构体所代表的是一个活跃的用户环境，但是它不能被调度运行，因为它在等待其他环境传递给它的消息。
　　ENV_DYING: 代表这个结构体对应的是一个僵尸环境。一个僵尸环境在下一次陷入内核时会被释放回收。

env_pgdir:
　　这个变量存放着这个环境的页目录的虚拟地址

　　就像Unix中的进程一样，一个JOS环境中结合了“线程”和“地址空间”的概念。线程通常是由被保存的寄存器的值来定义的，而地址空间则是由env_pgdir所指向的页目录表还有页表来定义的。为了运行一个用户环境，内核必须设置合适的寄存器的值以及合适的地址空间。

在物理地址上分配一个env数组，然后虚拟地址上的env数组映射到物理地址上：

![](images\lab3_partA_虚拟地址空间到物理地址空间映射.jpg)

`env_init`:

参数：

1. void

初始化envs数组，构建env_free_list链表，注意顺序，envs[0]应该在链表头部位置。

还要调用 env_init_percpu，这个函数要配置段式内存管理系统，让它所管理的段，可能具有两种访问优先级其中的一种，一个是内核运行时的0优先级，以及用户运行时的3优先级。

`env_setup_vm`:

参数：

1. struct Env *e：ENV结构指针

返回值：0表示成功，-E_NO_MEM表示失败，没有足够物理地址。
作用：初始化e指向的Env结构代表的用户环境的线性地址空间，设置e->env_pgdir字段

`region_alloc`:

参数：

1. struct Env *e：需要操作的用户环境
2. void *va：虚拟地址
3. size_t len：长度

作用：操作e->env_pgdir，为[va, va+len)分配物理空间。

`load_icode`:

参数：

1. struct Env *e：需要操作的用户环境
2. uint8_t *binary：可执行用户代码的起始地址

作用：加载binary地址开始处的ELF文件。

![](images\lab3_partA_ELF.jpg)

`env_create`:

参数：

1. uint8_t *binary：将要加载的可执行文件的起始位置
2. enum EnvType type：用户环境类型

作用：从env_free_list链表拿一个Env结构，加载从binary地址开始处的ELF可执行文件到该Env结构。

`env_run`:

参数：

1. struct Env *e：需要执行的用户环境

作用：执行e指向的用户环境

env创建流程：

![](images\lab3_partA_env创建流程.jpg)

用户环境的代码被调用前，操作系统一共按顺序执行了以下几个函数：

　　　　* start (kern/entry.S)

　　　　* i386_init (kern/init.c)

　　　　　　　cons_init

　　　　　　　mem_init

　　　　　　　env_init

　　　　　　　trap_init （目前还未实现）

　　　　   　　env_create

　　　　   　　env_run

　　　　　　　　env_pop_tf

　　一旦你完成上述子函数的代码，并且在QEMU下编译运行，系统会进入用户空间，并且开始执行hello程序，直到它做出一个系统调用指令int。但是这个系统调用指令不能成功运行，因为到目前为止，JOS还没有设置相关硬件来实现从用户态向内核态的转换功能。当CPU发现，它没有被设置成能够处理这种系统调用中断时，它会触发一个保护异常，然后发现这个保护异常也无法处理，从而又产生一个错误异常，然后又发现仍旧无法解决问题，所以最后放弃，我们把这个叫做"triple fault"。通常来说，接下来CPU会复位，系统会重启。



### Handling Intrrupts and Exceptions

一个**中断**指的是由外部异步事件引起的处理器控制权转移，比如外部IO设备发送来的中断信号。

一个**异常**则是由于当前正在运行的指令所带来的同步的处理器控制权的转移，比如除零溢出异常。

#### 中断向量表：

处理器保证中断和异常只能够引起内核进入到一些特定的，被事先定义好的程序入口点，而不是由触发中断的程序来决定中断程序入口点。
　　X86允许多达256个不同的中断和异常，每一个都配备一个独一无二的中断向量。一个向量指的就是0到255中的一个数。一个中断向量的值是根据中断源来决定的：不同设备，错误条件，以及对内核的请求都会产生出不同的中断和中断向量的组合。CPU将使用这个向量作为这个中断在中断向量表中的索引，这个表是由内核设置的，放在内核空间中，和GDT很像。通过这个表中的任意一个表项，处理器可以知道：
　　*需要加载到EIP寄存器中的值，这个值指向了处理这个中断的中断处理程序的位置。
　　*需要加载到CS寄存器中的值，里面还包含了这个中断处理程序的运行特权级。（即这个程序是在用户态还是内核态下运行。）

#### 任务状态段：

处理器还需要一个地方来存放，当异常/中断发生时，处理器的状态，比如EIP和CS寄存器的值。这样的话，中断处理程序一会可以重新返回到原来的程序中。这段内存自然也要保护起来，不能被用户态的程序所篡改。
　　正因为如此，当一个x86处理器要处理一个中断，异常并且使运行特权级从用户态转为内核态时，它也会把它的堆栈切换到内核空间中。一个叫做 “任务状态段（TSS）”的数据结构将会详细记录这个堆栈所在的段的段描述符和地址。处理器会把SS，ESP，EFLAGS，CS，EIP以及一个可选错误码等等这些值压入到这个堆栈上。然后加载中断处理程序的CS，EIP值，并且设置ESP，SS寄存器指向新的堆栈。
　　尽管TSS非常大，并且还有很多其他的功能，但是JOS仅仅使用它来定义处理器从用户态转向内核态所采用的内核堆栈，由于JOS中的内核态指的就是特权级0，所以处理器用TSS中的ESP0，SS0字段来指明这个内核堆栈的位置，大小。



整个操作系统的中断控制流程为：
　　1. trap_init() 先将所有中断处理函数的起始地址放到中断向量表IDT中。
　　2. 当中断发生时，不管是外部中断还是内部中断，处理器捕捉到该中断，进入核心态，根据中断向量去查询中断向量表，找到对应的表项
　　3. 保存被中断的程序的上下文到内核堆栈中，调用这个表项中指明的中断处理函数。
　　4. 执行中断处理函数。
　　5. 执行完成后，恢复被中断的进程的上下文，返回用户态，继续运行这个进程。

![](images\lab3_partA_寄存器.jpg)

由用户程序切换到内核，我们需要保存用户程序的各个寄存器信息，这些信息都被保存到用户程序的Trapframe里面。**_alltraps要做的事情就是构建一个trapframe接着代码跳转到trap()当中去执行。**帮助理解，下面是trapframe的图示:

![](images\lab3_partA_trap后压入.jpg)

`SETGATE`:

SETGATE宏的定义：
　　#define SETGATE(gate, istrap, sel, off, dpl)
　　其中gate是idt表的index入口，istrap判断是异常还是中断，sel为代码段选择符，off表示对应的处理函数地址，dpl表示触发该异常或中断的用户权限。



## PartB:Page Faults, Breakpoints Exceptions, and System Calls

### Handling Page faults：

volatile提醒编译器它后面所定义的变量随时都有可能改变，因此编译后的程序每次需要存储或读取这个变量的时候，告诉编译器对该变量不做优化，都会直接从变量内存地址中读取数据，从而可以提供对特殊地址的稳定访问。

如果没有volatile关键字，则编译器可能优化读取和存储，可能暂时使用寄存器中的值，如果这个变量由别的程序更新了的话，将出现不一致的现象。（简洁的说就是：volatile关键词影响编译器编译的结果，用volatile声明的变量表示该变量随时可能发生变化，与该变量有关的运算，不要进行编译优化，以免出错）

const, volatile同时修饰一个变量

（1）合法性

​      “volatile”的含义并非是“non-const”，volatile 和 const 不构成反义词，所以可以放一起修饰一个变量。

（2）同时修饰一个变量的含义

​     表示一个变量在程序编译期不能被修改且不能被优化；在程序运行期，变量值可修改，但每次用到该变量的值都要从内存中读取，以防止意外错误。

**volatile一般用处：**

**1）并行设备的硬件寄存器（如：状态寄存器）**

**2）中断服务程序中修改的供其它程序检测的变量，需要加volatile；**

**3）多任务环境下各任务间共享的标志，应该加volatile；**

**4）存储器映射的硬件寄存器通常也要加volatile说明，因为每次对它的读写都可能由不同意义**



DPL字段代表的含义是段描述符优先级（Descriptor Privileged Level），如果我们想要当前执行的程序能够跳转到这个描述符所指向的程序哪里继续执行的话，有个要求，就是要求当前运行程序的CPL，RPL的最大值需要小于等于DPL，否则就会出现优先级低的代码试图去访问优先级高的代码的情况，就会触发general protection exception。



#### 缺页错误的分类处理

缺页中断会交给PageFaultHandler处理，其根据缺页中断的不同类型会进行不同的处理：

- Hard Page Fault 也被称为Major Page Fault，翻译为硬缺页错误/主要缺页错误，这时物理内存中没有对应的页帧，需要CPU打开磁盘设备读取到物理内存中，再让MMU建立VA和PA的映射。
- Soft Page Fault 也被称为Minor Page Fault，翻译为软缺页错误/次要缺页错误，这时物理内存中是存在对应页帧的，只不过可能是其他进程调入的，发出缺页异常的进程不知道而已，此时MMU只需要建立映射即可，无需从磁盘读取写入内存，一般出现在多进程共享内存区域。
- Invalid Page Fault 翻译为无效缺页错误，比如进程访问的内存地址越界访问，又比如对空指针解引用内核就会报segment fault错误中断进程直接挂掉。

![](images\lab3_partB_缺页异常处理.jpg)



### Page faults and memory protection

大部分系统调用接口让用户程序传递一个指针参数给内核。这些指针指向的是用户缓冲区。通过这种方式，系统调用在执行时就可以解引用这些指针。但是这里有两个问题：

1. 在内核中的page fault要比在用户程序中的page fault更严重。如果内核在操作自己的数据结构时出现 page faults，这是一个内核的bug，而且异常处理程序会中断整个内核。但是当内核在解引用由用户程序传递来的指针时，它需要一种方法去记录此时出现的任何page faults都是由用户程序带来的。
2. 内核通常比用户程序有着更高的内存访问权限。用户程序很有可能要传递一个指针给系统调用，这个指针指向的内存区域是内核可以进行读写的，但是用户程序不能。此时内核必须小心的去解析这个指针，否则的话内核的重要信息很有可能被泄露。



## 本实验大致做了三件事：

1. 进程建立，可以加载用户ELF文件并执行。

   内核维护一个名叫envs的Env数组，每个Env结构对应一个进程，Env结构最重要的字段有Trapframe env_tf（该字段中断发生时可以保持寄存器的状态），pde_t *env_pgdir（该进程的页目录地址）。进程对应的内核数据结构可以用下图总结：

![](images\lab3_conclusion_进程抽象.jpg)

​		定义了env_init()，env_create()等函数，初始化Env结构，将Env结构Trapframe env_tf中的寄存器值设置到寄存器中，从而执行该Env。

2.创建异常处理函数，建立并加载IDT，使JOS能支持中断处理。要能说出中断发生时的详细步骤。需要搞清楚内核态和用户态转换方式：通过中断机制可以从用户环境进入内核态。使用iret指令从内核态回到用户环境。中断发生过程以及中断返回过程和系统调用原理可以总结为下图：

![](images\lab3_conclusion_中断过程以及系统调用.jpg)

# lab2:memory management

## Part 1: Physical Page Management

物理内存分布图:

![](images\lab2_part1_physical_memory.jpg)

内存管理有两个组成部分。

第一个部分是内核的物理内存分配器，以致于内核可以分配和释放内存。 分配器将以`4096`字节为操作单位，称为一个页面。 我们的任务是维护一个数据结构，去记录哪些物理页面是空闲的，哪些是已分配的，以及共享每个已分配页面的进程数。 我们还要编写例程来分配和释放内存页面。

内存管理的第二个组件是虚拟内存，它将内核和用户软件使用的虚拟地址映射到物理内存中的地址。 当指令使用内存时，x86硬件的内存管理单元（MMU）执行映射，查询一组页表。 我们根据任务提供的规范修改JOS以设置MMU的页面表。

![](images\lab2_part1_JOS物理内存状态.jpg)

大致上可以分为三部分：

1. 0x00000~0xA0000：这部分叫做basemem，是可用的。
2. 接着是0xA0000~0x100000：这部分叫做IO Hole，不可用。
3. 再接着就是0x100000以上的部分：这部分叫做extmem，可用。
   kern/pmap.c中的i386_detect_memory()统计有多少可用的物理内存，将总共的可用物理内存页数保存到全局变量npages中，basemem部分可用的物理内存页数保存到npages_basemem中。

`BSS段通常是指用来存放程序中未初始化的或者初始化为0的全局变量和静态变量的一块内存区域。特点是可读写的，在程序执行之前BSS段会自动清0。`



## exercise1：

`boot_alloc()`:

在执行boot_alloc之后的布局：

![](images\lab2_part1_JOS物理内存状态after_bool_alloc.jpg)

```c
kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
```

`kern_pgdir`：虚拟内存地址指针,分配一个页，作为页目录表，用来记录页的信息，如数量，使用情况等

`UVPT`是指向虚拟内存起始地址的，因此，需要将它和`kern_pgdir`映射起来

```c
kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
```

```c
pages = (struct PageInfo*)boot_alloc(sizeof(struct PageInfo)*npages);
memset(pages, 0, sizeof(struct PageInfo)*npages);
```

然后将内存分配成一页一页的，使用struct PageInfo记录每一页的信息，如下一页的指针，当前页引用次数。用PageInfo的数组保存所有struct PageInfo。



`page_init()`:

![](images\lab2_part1_page_init.jpg)

`page_alloc()`和`page_free()`比较简单

**总结**
在这个练习里面总共写了四个函数。`boot_alloc( )`函数，`mem_init ( )`函数，`page_init()`函数，`page_alloc( )`函数，`page_free( )`函数。

纵向分析一下这五个函数，但从名字来说可以分三类，boot，memory和page层面。

boot，启动层面，`boot_alloc() `做了启动时先分配了N个byte空间的功能。这一步做完就有了一定的空间。

memory，内存层面，`mem_init() `引入了数据结构Page_Info，做完这一步就将引入的空间在内存中划分成了页的层次。刚才分配了n个byte的空间，那么在这里就同样对应着npage*sizeof(Page_Info)个byte的页面，也就是npage个页面。

page，页面层面，`page_init()`是页面的初始化，初始化做的就是标记页表中哪些可以用，哪些不能用，把能用的链接起来。`page_alloc( )`就是分配这些能用的页面，`page_free（）`就是释放掉页面。

所以，事实上，这个实验基本就完成了内存层面初始化页面以及页面的基本操作（包括删除和分配）。

执行完mem_init()后的物理内存如下：

![](images\lab2_part1_physical_memory_after_pages.jpg)

## Part 2: Virtual Memory

### 虚拟地址、逻辑地址、线性地址、物理地址的区别：

段⻚式内存管理实现的⽅式： 

先将程序划分为多个有逻辑意义的段，也就是前⾯提到的分段机制； 

接着再把每个段划分为多个⻚，也就是对分段划分出来的连续空间，再划分固定⼤⼩的⻚；

这样，地址结构就由段号、段内⻚号和⻚内位移三部分组成

由此，**逻辑地址**是由段+偏移量组成，逻辑地址与虚拟地址没有明确分别，**虚拟地址（逻辑地址）**从段号到页号的翻译成为**线性地址**，然后线性地址通过页号+页内位移翻译成**物理地址**

![](images\lab2_part2_虚拟线性物理地址.jpg)

![](images\lab2_part2_虚拟线性物理.jpg)

`KADDR()`：物理地址转化为虚拟地址

`PADDR()`：虚拟地址转化为物理地址

类型`uintptr_t`表示不透明的虚拟地址，`physaddr_t`表示物理地址。 

这两种类型实际上只是32位整数（`uint32_t`）的同义词，因此编译器不会阻止您将一种类型分配给另一种类型！

| 名词     | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| 页目录表 | 存放各个页目录项的表，页目录常驻内存，页目录表的物理地址存在寄存器CR3中 |
| 页目录项 | 存放各个二级页表起始物理地址                                 |
| 页表     | 存放页表项                                                   |
| 页表项   | 页表项的高20位存放各页的对应的物理地址的高20位               |

`pgdir_walk()`:

参数：

1. pgdir:页目录虚拟地址
2. va:虚拟地址
3. create:布尔值

返回值：页表项的地址，如果没有则新建一个
作用：给定pgdir，指向一个页目录，该函数返回一个虚拟地址指针指向虚拟地址va对应的页表项(PTE),没有则根据create，为1则需要创建一个页表并返回，为0则返回null。

```c
 A linear address 'la' has a three-part structure as follows:

 +--------10------+-------10-------+---------12----------+
 | Page Directory |   Page Table   | Offset within Page  |
 |      Index     |      Index     |                     |
 +----------------+----------------+---------------------+
  \--- PDX(la) --/ \--- PTX(la) --/ \---- PGOFF(la) ----/
  \---------- PGNUM(la) ----------/
```

```c
//页属于线性地址
逻辑地址->虚拟地址->线性地址->物理地址
static inline physaddr_t
page2pa(struct PageInfo *pp)//一个页对应的物理地址
{
        return (pp - pages) << PGSHIFT;
}
 
static inline struct PageInfo*
pa2page(physaddr_t pa)//一个物理地址对应的页
{
        if (PGNUM(pa) >= npages)
                panic("pa2page called with invalid pa");
        return &pages[PGNUM(pa)];
}
 
static inline void*
page2kva(struct PageInfo *pp)一个页对应的内核虚拟地址
{
        return KADDR(page2pa(pp));
}
```

**出现过的错误：**

```shell
kernel panic at kern/pmap.c:790: 
assertion failed: PTE_ADDR(kern_pgdir[0]) == page2pa(pp0)
```

出现这个错误的原因是页表项指向的物理地址有问题，看了网上的很多对应的代码，最后发现，问题出现在`page_walk`这个函数中：

```c
错误代码：
	pde_t va_dir_entry = pgdir[PDX(va)];
	if (!(va_dir_entry & PTE_P))
	{
		if (!create)
			return NULL;
		else
		{
			struct PageInfo *pp = page_alloc(ALLOC_ZERO);
			if (pp == NULL)
				return NULL;
			pp->pp_ref++;
			va_dir_entry = page2pa(pp) | PTE_U | PTE_P | PTE_W;
		}
	}
	return (pte_t *)KADDR(PTE_ADDR(va_dir_entry)) + PTX(va); //返回页表项的虚拟地址

修改后，正确的代码：
	// pgdir中页目录项存的是指向二级页表的物理地址指针，所以需要指针操作
	//如果只是取出其整数，则是拷贝而已，并不能改变pgdir中的实际页目录项指向
	//这样的话，当创建一个新页表时，不能将页目录项指向正确的页表地址
	pde_t *va_dir_entry = &pgdir[PDX(va)];
	if (!(*va_dir_entry & PTE_P))
	{
		if (!create)
			return NULL;
		else
		{
			struct PageInfo *pp = page_alloc(ALLOC_ZERO);
			if (pp == NULL)
				return NULL;
			pp->pp_ref++;
			*va_dir_entry = page2pa(pp) | PTE_U | PTE_P | PTE_W;
		}
	}
	return (pte_t *)KADDR(PTE_ADDR(*va_dir_entry)) + PTX(va); //返回页表项的虚拟地址
```



`boot_map_region`:

参数：

1. pgdir:页目录指针
2. va:虚拟地址
3. size:大小
4. pa:物理地址
5. perm:权限

作用：通过修改pgdir指向的树，将[va, va+size)对应的虚拟地址空间映射到物理地址空间[pa, pa+size)。va和pa都是页对齐的。

`page_insert()`:

参数：

1. pgdir:页目录指针
2. pp:PageInfo结构指针，代表一个物理页
3. va:虚拟地址
4. perm：权限

返回值：0代表成功，-E_NO_MEM代表物理空间不足。
作用：修改pgdir对应的树结构，使va映射到pp对应的物理页处。

`page_lookup()`:

参数：

1. pgdir:页目录地址
2. va:虚拟地址
3. pte_store:一个指针类型，指向pte_t *类型的变量

返回值：PageInfo*
作用：通过查找pgdir指向的树结构，返回va对应的PTE所指向的物理地址对应的PageInfo结构地址。

`page_remove`:

参数：

1. pgdir:页目录地址
2. va:虚拟地址

作用：修改pgdir指向的树结构，解除va的映射关系。



## part3:Kernel Address Space

```c
/*
 * Virtual memory map:                                Permissions
 *                                                    kernel/user
 *
 *    4 Gig -------->  +------------------------------+
 *                     |                              | RW/--
 *                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                     :              .               :
 *                     :              .               :
 *                     :              .               :
 *                     |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~| RW/--
 *                     |                              | RW/--
 *                     |   Remapped Physical Memory   | RW/--
 *                     |                              | RW/--
 *    KERNBASE, ---->  +------------------------------+ 0xf0000000      --+
 *    KSTACKTOP        |     CPU0's Kernel Stack      | RW/--  KSTKSIZE   |
 *                     | - - - - - - - - - - - - - - -|                   |
 *                     |      Invalid Memory (*)      | --/--  KSTKGAP    |
 *                     +------------------------------+                   |
 *                     |     CPU1's Kernel Stack      | RW/--  KSTKSIZE   |
 *                     | - - - - - - - - - - - - - - -|                 PTSIZE
 *                     |      Invalid Memory (*)      | --/--  KSTKGAP    |
 *                     +------------------------------+                   |
 *                     :              .               :                   |
 *                     :              .               :                   |
 *    MMIOLIM ------>  +------------------------------+ 0xefc00000      --+
 *                     |       Memory-mapped I/O      | RW/--  PTSIZE
 * ULIM, MMIOBASE -->  +------------------------------+ 0xef800000
 *                     |  Cur. Page Table (User R-)   | R-/R-  PTSIZE
 *    UVPT      ---->  +------------------------------+ 0xef400000
 *                     |          RO PAGES            | R-/R-  PTSIZE
 *    UPAGES    ---->  +------------------------------+ 0xef000000
 *                     |           RO ENVS            | R-/R-  PTSIZE
 * UTOP,UENVS ------>  +------------------------------+ 0xeec00000
 * UXSTACKTOP -/       |     User Exception Stack     | RW/RW  PGSIZE
 *                     +------------------------------+ 0xeebff000
 *                     |       Empty Memory (*)       | --/--  PGSIZE
 *    USTACKTOP  --->  +------------------------------+ 0xeebfe000
 *                     |      Normal User Stack       | RW/RW  PGSIZE
 *                     +------------------------------+ 0xeebfd000
 *                     |                              |
 *                     |                              |
 *                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *                     .                              .
 *                     .                              .
 *                     .                              .
 *                     |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
 *                     |     Program Data & Heap      |
 *    UTEXT -------->  +------------------------------+ 0x00800000
 *    PFTEMP ------->  |       Empty Memory (*)       |        PTSIZE
 *                     |                              |
 *    UTEMP -------->  +------------------------------+ 0x00400000      --+
 *                     |       Empty Memory (*)       |                   |
 *                     | - - - - - - - - - - - - - - -|                   |
 *                     |  User STAB Data (optional)   |                 PTSIZE
 *    USTABDATA ---->  +------------------------------+ 0x00200000        |
 *                     |       Empty Memory (*)       |                   |
 *    0 ------------>  +------------------------------+                 --+
 *
 * (*) Note: The kernel ensures that "Invalid Memory" is *never* mapped.
 *     "Empty Memory" is normally unmapped, but user programs may map pages
 *     there if desired.  JOS user programs map pages temporarily at UTEMP.
 */

```

JOS把32位线性地址虚拟空间划分成两个部分。其中用户环境（进程运行环境）通常占据低地址的那部分，叫用户地址空间。而操作系统内核总是占据高地址的部分，叫内核地址空间。由定义在inc/memlayout.h中的ULIM分割。ULIM以上的部分用户没有权限访问，内核有读写权限。JOS为内核保留了接近256MB的虚拟地址空间。这就可以理解了，为什么在实验1中要给操作系统设计一个高地址的地址空间。如果不这样做，用户环境的地址空间就不够了。

调用mem_init（）后虚拟地址映射物理地址关系图：

![](images\lab2_part3_虚拟地址空间到物理地址空间映射.jpg)


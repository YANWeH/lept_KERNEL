
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 ca 1a 00 00       	call   801afb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800075:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800085:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0b                	je     800095 <ide_probe_disk1+0x36>
	     x++)
  80008a:	83 c1 01             	add    $0x1,%ecx
	for (x = 0;
  80008d:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800093:	75 f0                	jne    800085 <ide_probe_disk1+0x26>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800095:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009a:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009f:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a6:	0f 9e c3             	setle  %bl
  8000a9:	83 ec 08             	sub    $0x8,%esp
  8000ac:	0f b6 c3             	movzbl %bl,%eax
  8000af:	50                   	push   %eax
  8000b0:	68 80 3d 80 00       	push   $0x803d80
  8000b5:	e8 7c 1b 00 00       	call   801c36 <cprintf>
	return (x < 1000);
}
  8000ba:	89 d8                	mov    %ebx,%eax
  8000bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    

008000c1 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
  8000c7:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000ca:	83 f8 01             	cmp    $0x1,%eax
  8000cd:	77 07                	ja     8000d6 <ide_set_disk+0x15>
		panic("bad disk number");
	diskno = d;
  8000cf:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		panic("bad disk number");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 97 3d 80 00       	push   $0x803d97
  8000de:	6a 3a                	push   $0x3a
  8000e0:	68 a7 3d 80 00       	push   $0x803da7
  8000e5:	e8 71 1a 00 00       	call   801b5b <_panic>

008000ea <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	83 ec 0c             	sub    $0xc,%esp
  8000f3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8000f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	0f 87 87 00 00 00    	ja     80018f <ide_read+0xa5>

	ide_wait_ready(0);
  800108:	b8 00 00 00 00       	mov    $0x0,%eax
  80010d:	e8 21 ff ff ff       	call   800033 <ide_wait_ready>
  800112:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800117:	89 f0                	mov    %esi,%eax
  800119:	ee                   	out    %al,(%dx)
  80011a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  80011f:	89 f8                	mov    %edi,%eax
  800121:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  800122:	89 f8                	mov    %edi,%eax
  800124:	c1 e8 08             	shr    $0x8,%eax
  800127:	ba f4 01 00 00       	mov    $0x1f4,%edx
  80012c:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  80012d:	89 f8                	mov    %edi,%eax
  80012f:	c1 e8 10             	shr    $0x10,%eax
  800132:	ba f5 01 00 00       	mov    $0x1f5,%edx
  800137:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800138:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  80013f:	c1 e0 04             	shl    $0x4,%eax
  800142:	83 e0 10             	and    $0x10,%eax
  800145:	83 c8 e0             	or     $0xffffffe0,%eax
  800148:	c1 ef 18             	shr    $0x18,%edi
  80014b:	83 e7 0f             	and    $0xf,%edi
  80014e:	09 f8                	or     %edi,%eax
  800150:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800155:	ee                   	out    %al,(%dx)
  800156:	b8 20 00 00 00       	mov    $0x20,%eax
  80015b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	c1 e6 09             	shl    $0x9,%esi
  800164:	01 de                	add    %ebx,%esi
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	39 f3                	cmp    %esi,%ebx
  800168:	74 3b                	je     8001a5 <ide_read+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  80016a:	b8 01 00 00 00       	mov    $0x1,%eax
  80016f:	e8 bf fe ff ff       	call   800033 <ide_wait_ready>
  800174:	85 c0                	test   %eax,%eax
  800176:	78 32                	js     8001aa <ide_read+0xc0>
	asm volatile("cld\n\trepne\n\tinsl"
  800178:	89 df                	mov    %ebx,%edi
  80017a:	b9 80 00 00 00       	mov    $0x80,%ecx
  80017f:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800184:	fc                   	cld    
  800185:	f2 6d                	repnz insl (%dx),%es:(%edi)
	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800187:	81 c3 00 02 00 00    	add    $0x200,%ebx
  80018d:	eb d7                	jmp    800166 <ide_read+0x7c>
	assert(nsecs <= 256);
  80018f:	68 b0 3d 80 00       	push   $0x803db0
  800194:	68 bd 3d 80 00       	push   $0x803dbd
  800199:	6a 44                	push   $0x44
  80019b:	68 a7 3d 80 00       	push   $0x803da7
  8001a0:	e8 b6 19 00 00       	call   801b5b <_panic>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	57                   	push   %edi
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8001be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c1:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c4:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001ca:	0f 87 87 00 00 00    	ja     800257 <ide_write+0xa5>

	ide_wait_ready(0);
  8001d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d5:	e8 59 fe ff ff       	call   800033 <ide_wait_ready>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001da:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8001df:	89 f8                	mov    %edi,%eax
  8001e1:	ee                   	out    %al,(%dx)
  8001e2:	ba f3 01 00 00       	mov    $0x1f3,%edx
  8001e7:	89 f0                	mov    %esi,%eax
  8001e9:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
  8001ea:	89 f0                	mov    %esi,%eax
  8001ec:	c1 e8 08             	shr    $0x8,%eax
  8001ef:	ba f4 01 00 00       	mov    $0x1f4,%edx
  8001f4:	ee                   	out    %al,(%dx)
	outb(0x1F5, (secno >> 16) & 0xFF);
  8001f5:	89 f0                	mov    %esi,%eax
  8001f7:	c1 e8 10             	shr    $0x10,%eax
  8001fa:	ba f5 01 00 00       	mov    $0x1f5,%edx
  8001ff:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800200:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800207:	c1 e0 04             	shl    $0x4,%eax
  80020a:	83 e0 10             	and    $0x10,%eax
  80020d:	83 c8 e0             	or     $0xffffffe0,%eax
  800210:	c1 ee 18             	shr    $0x18,%esi
  800213:	83 e6 0f             	and    $0xf,%esi
  800216:	09 f0                	or     %esi,%eax
  800218:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80021d:	ee                   	out    %al,(%dx)
  80021e:	b8 30 00 00 00       	mov    $0x30,%eax
  800223:	ba f7 01 00 00       	mov    $0x1f7,%edx
  800228:	ee                   	out    %al,(%dx)
  800229:	c1 e7 09             	shl    $0x9,%edi
  80022c:	01 df                	add    %ebx,%edi
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80022e:	39 fb                	cmp    %edi,%ebx
  800230:	74 3b                	je     80026d <ide_write+0xbb>
		if ((r = ide_wait_ready(1)) < 0)
  800232:	b8 01 00 00 00       	mov    $0x1,%eax
  800237:	e8 f7 fd ff ff       	call   800033 <ide_wait_ready>
  80023c:	85 c0                	test   %eax,%eax
  80023e:	78 32                	js     800272 <ide_write+0xc0>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800240:	89 de                	mov    %ebx,%esi
  800242:	b9 80 00 00 00       	mov    $0x80,%ecx
  800247:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80024c:	fc                   	cld    
  80024d:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80024f:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800255:	eb d7                	jmp    80022e <ide_write+0x7c>
	assert(nsecs <= 256);
  800257:	68 b0 3d 80 00       	push   $0x803db0
  80025c:	68 bd 3d 80 00       	push   $0x803dbd
  800261:	6a 5d                	push   $0x5d
  800263:	68 a7 3d 80 00       	push   $0x803da7
  800268:	e8 ee 18 00 00       	call   801b5b <_panic>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *)utf->utf_fault_va;
  800282:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800284:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028a:	89 c6                	mov    %eax,%esi
  80028c:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void *)DISKMAP || addr >= (void *)(DISKMAP + DISKSIZE))
  80028f:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800294:	0f 87 95 00 00 00    	ja     80032f <bc_pgfault+0xb5>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
			  utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80029a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	74 09                	je     8002ac <bc_pgfault+0x32>
  8002a3:	39 70 04             	cmp    %esi,0x4(%eax)
  8002a6:	0f 86 9e 00 00 00    	jbe    80034a <bc_pgfault+0xd0>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = (void *)ROUNDDOWN(addr, PGSIZE);
  8002ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_alloc(0, addr, PTE_P | PTE_W | PTE_U)) < 0)
  8002b2:	83 ec 04             	sub    $0x4,%esp
  8002b5:	6a 07                	push   $0x7
  8002b7:	53                   	push   %ebx
  8002b8:	6a 00                	push   $0x0
  8002ba:	e8 8f 23 00 00       	call   80264e <sys_page_alloc>
  8002bf:	83 c4 10             	add    $0x10,%esp
  8002c2:	85 c0                	test   %eax,%eax
  8002c4:	0f 88 92 00 00 00    	js     80035c <bc_pgfault+0xe2>
		panic("bc_pgfault failed: sys_page_alloc: %e", r);

	if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0)
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	6a 08                	push   $0x8
  8002cf:	53                   	push   %ebx
  8002d0:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  8002d7:	50                   	push   %eax
  8002d8:	e8 0d fe ff ff       	call   8000ea <ide_read>
  8002dd:	83 c4 10             	add    $0x10,%esp
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	0f 88 86 00 00 00    	js     80036e <bc_pgfault+0xf4>
		panic("bc_pgfault failed: ide_read: %e", r);

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8002e8:	89 d8                	mov    %ebx,%eax
  8002ea:	c1 e8 0c             	shr    $0xc,%eax
  8002ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8002fc:	50                   	push   %eax
  8002fd:	53                   	push   %ebx
  8002fe:	6a 00                	push   $0x0
  800300:	53                   	push   %ebx
  800301:	6a 00                	push   $0x0
  800303:	e8 89 23 00 00       	call   802691 <sys_page_map>
  800308:	83 c4 20             	add    $0x20,%esp
  80030b:	85 c0                	test   %eax,%eax
  80030d:	78 71                	js     800380 <bc_pgfault+0x106>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80030f:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  800316:	74 10                	je     800328 <bc_pgfault+0xae>
  800318:	83 ec 0c             	sub    $0xc,%esp
  80031b:	56                   	push   %esi
  80031c:	e8 0d 05 00 00       	call   80082e <block_is_free>
  800321:	83 c4 10             	add    $0x10,%esp
  800324:	84 c0                	test   %al,%al
  800326:	75 6a                	jne    800392 <bc_pgfault+0x118>
		panic("reading free block %08x\n", blockno);
}
  800328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80032b:	5b                   	pop    %ebx
  80032c:	5e                   	pop    %esi
  80032d:	5d                   	pop    %ebp
  80032e:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	ff 72 04             	pushl  0x4(%edx)
  800335:	53                   	push   %ebx
  800336:	ff 72 28             	pushl  0x28(%edx)
  800339:	68 d4 3d 80 00       	push   $0x803dd4
  80033e:	6a 25                	push   $0x25
  800340:	68 24 3f 80 00       	push   $0x803f24
  800345:	e8 11 18 00 00       	call   801b5b <_panic>
		panic("reading non-existent block %08x\n", blockno);
  80034a:	56                   	push   %esi
  80034b:	68 04 3e 80 00       	push   $0x803e04
  800350:	6a 29                	push   $0x29
  800352:	68 24 3f 80 00       	push   $0x803f24
  800357:	e8 ff 17 00 00       	call   801b5b <_panic>
		panic("bc_pgfault failed: sys_page_alloc: %e", r);
  80035c:	50                   	push   %eax
  80035d:	68 28 3e 80 00       	push   $0x803e28
  800362:	6a 33                	push   $0x33
  800364:	68 24 3f 80 00       	push   $0x803f24
  800369:	e8 ed 17 00 00       	call   801b5b <_panic>
		panic("bc_pgfault failed: ide_read: %e", r);
  80036e:	50                   	push   %eax
  80036f:	68 50 3e 80 00       	push   $0x803e50
  800374:	6a 36                	push   $0x36
  800376:	68 24 3f 80 00       	push   $0x803f24
  80037b:	e8 db 17 00 00       	call   801b5b <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800380:	50                   	push   %eax
  800381:	68 70 3e 80 00       	push   $0x803e70
  800386:	6a 3b                	push   $0x3b
  800388:	68 24 3f 80 00       	push   $0x803f24
  80038d:	e8 c9 17 00 00       	call   801b5b <_panic>
		panic("reading free block %08x\n", blockno);
  800392:	56                   	push   %esi
  800393:	68 2c 3f 80 00       	push   $0x803f2c
  800398:	6a 41                	push   $0x41
  80039a:	68 24 3f 80 00       	push   $0x803f24
  80039f:	e8 b7 17 00 00       	call   801b5b <_panic>

008003a4 <diskaddr>:
{
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	83 ec 08             	sub    $0x8,%esp
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8003ad:	85 c0                	test   %eax,%eax
  8003af:	74 19                	je     8003ca <diskaddr+0x26>
  8003b1:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  8003b7:	85 d2                	test   %edx,%edx
  8003b9:	74 05                	je     8003c0 <diskaddr+0x1c>
  8003bb:	39 42 04             	cmp    %eax,0x4(%edx)
  8003be:	76 0a                	jbe    8003ca <diskaddr+0x26>
	return (char *)(DISKMAP + blockno * BLKSIZE);
  8003c0:	05 00 00 01 00       	add    $0x10000,%eax
  8003c5:	c1 e0 0c             	shl    $0xc,%eax
}
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  8003ca:	50                   	push   %eax
  8003cb:	68 90 3e 80 00       	push   $0x803e90
  8003d0:	6a 09                	push   $0x9
  8003d2:	68 24 3f 80 00       	push   $0x803f24
  8003d7:	e8 7f 17 00 00       	call   801b5b <_panic>

008003dc <va_is_mapped>:
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  8003e2:	89 d0                	mov    %edx,%eax
  8003e4:	c1 e8 16             	shr    $0x16,%eax
  8003e7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8003ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f3:	f6 c1 01             	test   $0x1,%cl
  8003f6:	74 0d                	je     800405 <va_is_mapped+0x29>
  8003f8:	c1 ea 0c             	shr    $0xc,%edx
  8003fb:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800402:	83 e0 01             	and    $0x1,%eax
  800405:	83 e0 01             	and    $0x1,%eax
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <va_is_dirty>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	c1 e8 0c             	shr    $0xc,%eax
  800413:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80041a:	c1 e8 06             	shr    $0x6,%eax
  80041d:	83 e0 01             	and    $0x1,%eax
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <flush_block>:
// nothing.
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void flush_block(void *addr)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	56                   	push   %esi
  800426:	53                   	push   %ebx
  800427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void *)DISKMAP || addr >= (void *)(DISKMAP + DISKSIZE))
  80042a:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800430:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800435:	77 1f                	ja     800456 <flush_block+0x34>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	int r;
	addr = (void *)ROUNDDOWN(addr, PGSIZE);
  800437:	89 de                	mov    %ebx,%esi
  800439:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (va_is_mapped(addr) && va_is_dirty(addr))
  80043f:	83 ec 0c             	sub    $0xc,%esp
  800442:	56                   	push   %esi
  800443:	e8 94 ff ff ff       	call   8003dc <va_is_mapped>
  800448:	83 c4 10             	add    $0x10,%esp
  80044b:	84 c0                	test   %al,%al
  80044d:	75 19                	jne    800468 <flush_block+0x46>
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
			panic("flush_block failed: sys_page_map: %e", r);
	}

	// panic("flush_block not implemented");
}
  80044f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800452:	5b                   	pop    %ebx
  800453:	5e                   	pop    %esi
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  800456:	53                   	push   %ebx
  800457:	68 45 3f 80 00       	push   $0x803f45
  80045c:	6a 50                	push   $0x50
  80045e:	68 24 3f 80 00       	push   $0x803f24
  800463:	e8 f3 16 00 00       	call   801b5b <_panic>
	if (va_is_mapped(addr) && va_is_dirty(addr))
  800468:	83 ec 0c             	sub    $0xc,%esp
  80046b:	56                   	push   %esi
  80046c:	e8 99 ff ff ff       	call   80040a <va_is_dirty>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	84 c0                	test   %al,%al
  800476:	74 d7                	je     80044f <flush_block+0x2d>
		r = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	6a 08                	push   $0x8
  80047d:	56                   	push   %esi
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  80047e:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  800484:	c1 eb 0c             	shr    $0xc,%ebx
		r = ide_write(blockno * BLKSECTS, addr, BLKSECTS);
  800487:	c1 e3 03             	shl    $0x3,%ebx
  80048a:	53                   	push   %ebx
  80048b:	e8 22 fd ff ff       	call   8001b2 <ide_write>
		if (r < 0)
  800490:	83 c4 10             	add    $0x10,%esp
  800493:	85 c0                	test   %eax,%eax
  800495:	78 39                	js     8004d0 <flush_block+0xae>
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800497:	89 f0                	mov    %esi,%eax
  800499:	c1 e8 0c             	shr    $0xc,%eax
  80049c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	25 07 0e 00 00       	and    $0xe07,%eax
  8004ab:	50                   	push   %eax
  8004ac:	56                   	push   %esi
  8004ad:	6a 00                	push   $0x0
  8004af:	56                   	push   %esi
  8004b0:	6a 00                	push   $0x0
  8004b2:	e8 da 21 00 00       	call   802691 <sys_page_map>
  8004b7:	83 c4 20             	add    $0x20,%esp
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	79 91                	jns    80044f <flush_block+0x2d>
			panic("flush_block failed: sys_page_map: %e", r);
  8004be:	50                   	push   %eax
  8004bf:	68 d8 3e 80 00       	push   $0x803ed8
  8004c4:	6a 5b                	push   $0x5b
  8004c6:	68 24 3f 80 00       	push   $0x803f24
  8004cb:	e8 8b 16 00 00       	call   801b5b <_panic>
			panic("flush_block failed: ide_write: %e", r);
  8004d0:	50                   	push   %eax
  8004d1:	68 b4 3e 80 00       	push   $0x803eb4
  8004d6:	6a 59                	push   $0x59
  8004d8:	68 24 3f 80 00       	push   $0x803f24
  8004dd:	e8 79 16 00 00       	call   801b5b <_panic>

008004e2 <bc_init>:

	cprintf("block cache is good\n");
}

void bc_init(void)
{
  8004e2:	55                   	push   %ebp
  8004e3:	89 e5                	mov    %esp,%ebp
  8004e5:	53                   	push   %ebx
  8004e6:	81 ec 20 02 00 00    	sub    $0x220,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8004ec:	68 7a 02 80 00       	push   $0x80027a
  8004f1:	e8 68 23 00 00       	call   80285e <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8004f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004fd:	e8 a2 fe ff ff       	call   8003a4 <diskaddr>
  800502:	83 c4 0c             	add    $0xc,%esp
  800505:	68 08 01 00 00       	push   $0x108
  80050a:	50                   	push   %eax
  80050b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  800511:	50                   	push   %eax
  800512:	e8 cc 1e 00 00       	call   8023e3 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800517:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80051e:	e8 81 fe ff ff       	call   8003a4 <diskaddr>
  800523:	83 c4 08             	add    $0x8,%esp
  800526:	68 60 3f 80 00       	push   $0x803f60
  80052b:	50                   	push   %eax
  80052c:	e8 24 1d 00 00       	call   802255 <strcpy>
	flush_block(diskaddr(1));
  800531:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800538:	e8 67 fe ff ff       	call   8003a4 <diskaddr>
  80053d:	89 04 24             	mov    %eax,(%esp)
  800540:	e8 dd fe ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800545:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80054c:	e8 53 fe ff ff       	call   8003a4 <diskaddr>
  800551:	89 04 24             	mov    %eax,(%esp)
  800554:	e8 83 fe ff ff       	call   8003dc <va_is_mapped>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	84 c0                	test   %al,%al
  80055e:	0f 84 d1 01 00 00    	je     800735 <bc_init+0x253>
	assert(!va_is_dirty(diskaddr(1)));
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	6a 01                	push   $0x1
  800569:	e8 36 fe ff ff       	call   8003a4 <diskaddr>
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	e8 94 fe ff ff       	call   80040a <va_is_dirty>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	84 c0                	test   %al,%al
  80057b:	0f 85 ca 01 00 00    	jne    80074b <bc_init+0x269>
	sys_page_unmap(0, diskaddr(1));
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	6a 01                	push   $0x1
  800586:	e8 19 fe ff ff       	call   8003a4 <diskaddr>
  80058b:	83 c4 08             	add    $0x8,%esp
  80058e:	50                   	push   %eax
  80058f:	6a 00                	push   $0x0
  800591:	e8 3d 21 00 00       	call   8026d3 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800596:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80059d:	e8 02 fe ff ff       	call   8003a4 <diskaddr>
  8005a2:	89 04 24             	mov    %eax,(%esp)
  8005a5:	e8 32 fe ff ff       	call   8003dc <va_is_mapped>
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	84 c0                	test   %al,%al
  8005af:	0f 85 ac 01 00 00    	jne    800761 <bc_init+0x27f>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8005b5:	83 ec 0c             	sub    $0xc,%esp
  8005b8:	6a 01                	push   $0x1
  8005ba:	e8 e5 fd ff ff       	call   8003a4 <diskaddr>
  8005bf:	83 c4 08             	add    $0x8,%esp
  8005c2:	68 60 3f 80 00       	push   $0x803f60
  8005c7:	50                   	push   %eax
  8005c8:	e8 2e 1d 00 00       	call   8022fb <strcmp>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	85 c0                	test   %eax,%eax
  8005d2:	0f 85 9f 01 00 00    	jne    800777 <bc_init+0x295>
	memmove(diskaddr(1), &backup, sizeof backup);
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	6a 01                	push   $0x1
  8005dd:	e8 c2 fd ff ff       	call   8003a4 <diskaddr>
  8005e2:	83 c4 0c             	add    $0xc,%esp
  8005e5:	68 08 01 00 00       	push   $0x108
  8005ea:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  8005f0:	53                   	push   %ebx
  8005f1:	50                   	push   %eax
  8005f2:	e8 ec 1d 00 00       	call   8023e3 <memmove>
	flush_block(diskaddr(1));
  8005f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005fe:	e8 a1 fd ff ff       	call   8003a4 <diskaddr>
  800603:	89 04 24             	mov    %eax,(%esp)
  800606:	e8 17 fe ff ff       	call   800422 <flush_block>
	memmove(&backup, diskaddr(1), sizeof backup);
  80060b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800612:	e8 8d fd ff ff       	call   8003a4 <diskaddr>
  800617:	83 c4 0c             	add    $0xc,%esp
  80061a:	68 08 01 00 00       	push   $0x108
  80061f:	50                   	push   %eax
  800620:	53                   	push   %ebx
  800621:	e8 bd 1d 00 00       	call   8023e3 <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  800626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80062d:	e8 72 fd ff ff       	call   8003a4 <diskaddr>
  800632:	83 c4 08             	add    $0x8,%esp
  800635:	68 60 3f 80 00       	push   $0x803f60
  80063a:	50                   	push   %eax
  80063b:	e8 15 1c 00 00       	call   802255 <strcpy>
	flush_block(diskaddr(1) + 20);
  800640:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800647:	e8 58 fd ff ff       	call   8003a4 <diskaddr>
  80064c:	83 c0 14             	add    $0x14,%eax
  80064f:	89 04 24             	mov    %eax,(%esp)
  800652:	e8 cb fd ff ff       	call   800422 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80065e:	e8 41 fd ff ff       	call   8003a4 <diskaddr>
  800663:	89 04 24             	mov    %eax,(%esp)
  800666:	e8 71 fd ff ff       	call   8003dc <va_is_mapped>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	84 c0                	test   %al,%al
  800670:	0f 84 17 01 00 00    	je     80078d <bc_init+0x2ab>
	sys_page_unmap(0, diskaddr(1));
  800676:	83 ec 0c             	sub    $0xc,%esp
  800679:	6a 01                	push   $0x1
  80067b:	e8 24 fd ff ff       	call   8003a4 <diskaddr>
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	50                   	push   %eax
  800684:	6a 00                	push   $0x0
  800686:	e8 48 20 00 00       	call   8026d3 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  80068b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800692:	e8 0d fd ff ff       	call   8003a4 <diskaddr>
  800697:	89 04 24             	mov    %eax,(%esp)
  80069a:	e8 3d fd ff ff       	call   8003dc <va_is_mapped>
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	84 c0                	test   %al,%al
  8006a4:	0f 85 fc 00 00 00    	jne    8007a6 <bc_init+0x2c4>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	6a 01                	push   $0x1
  8006af:	e8 f0 fc ff ff       	call   8003a4 <diskaddr>
  8006b4:	83 c4 08             	add    $0x8,%esp
  8006b7:	68 60 3f 80 00       	push   $0x803f60
  8006bc:	50                   	push   %eax
  8006bd:	e8 39 1c 00 00       	call   8022fb <strcmp>
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	0f 85 f2 00 00 00    	jne    8007bf <bc_init+0x2dd>
	memmove(diskaddr(1), &backup, sizeof backup);
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	6a 01                	push   $0x1
  8006d2:	e8 cd fc ff ff       	call   8003a4 <diskaddr>
  8006d7:	83 c4 0c             	add    $0xc,%esp
  8006da:	68 08 01 00 00       	push   $0x108
  8006df:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8006e5:	52                   	push   %edx
  8006e6:	50                   	push   %eax
  8006e7:	e8 f7 1c 00 00       	call   8023e3 <memmove>
	flush_block(diskaddr(1));
  8006ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006f3:	e8 ac fc ff ff       	call   8003a4 <diskaddr>
  8006f8:	89 04 24             	mov    %eax,(%esp)
  8006fb:	e8 22 fd ff ff       	call   800422 <flush_block>
	cprintf("block cache is good\n");
  800700:	c7 04 24 9c 3f 80 00 	movl   $0x803f9c,(%esp)
  800707:	e8 2a 15 00 00       	call   801c36 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  80070c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800713:	e8 8c fc ff ff       	call   8003a4 <diskaddr>
  800718:	83 c4 0c             	add    $0xc,%esp
  80071b:	68 08 01 00 00       	push   $0x108
  800720:	50                   	push   %eax
  800721:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800727:	50                   	push   %eax
  800728:	e8 b6 1c 00 00       	call   8023e3 <memmove>
}
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800733:	c9                   	leave  
  800734:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800735:	68 82 3f 80 00       	push   $0x803f82
  80073a:	68 bd 3d 80 00       	push   $0x803dbd
  80073f:	6a 6e                	push   $0x6e
  800741:	68 24 3f 80 00       	push   $0x803f24
  800746:	e8 10 14 00 00       	call   801b5b <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80074b:	68 67 3f 80 00       	push   $0x803f67
  800750:	68 bd 3d 80 00       	push   $0x803dbd
  800755:	6a 6f                	push   $0x6f
  800757:	68 24 3f 80 00       	push   $0x803f24
  80075c:	e8 fa 13 00 00       	call   801b5b <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800761:	68 81 3f 80 00       	push   $0x803f81
  800766:	68 bd 3d 80 00       	push   $0x803dbd
  80076b:	6a 73                	push   $0x73
  80076d:	68 24 3f 80 00       	push   $0x803f24
  800772:	e8 e4 13 00 00       	call   801b5b <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800777:	68 00 3f 80 00       	push   $0x803f00
  80077c:	68 bd 3d 80 00       	push   $0x803dbd
  800781:	6a 76                	push   $0x76
  800783:	68 24 3f 80 00       	push   $0x803f24
  800788:	e8 ce 13 00 00       	call   801b5b <_panic>
	assert(va_is_mapped(diskaddr(1)));
  80078d:	68 82 3f 80 00       	push   $0x803f82
  800792:	68 bd 3d 80 00       	push   $0x803dbd
  800797:	68 87 00 00 00       	push   $0x87
  80079c:	68 24 3f 80 00       	push   $0x803f24
  8007a1:	e8 b5 13 00 00       	call   801b5b <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  8007a6:	68 81 3f 80 00       	push   $0x803f81
  8007ab:	68 bd 3d 80 00       	push   $0x803dbd
  8007b0:	68 8f 00 00 00       	push   $0x8f
  8007b5:	68 24 3f 80 00       	push   $0x803f24
  8007ba:	e8 9c 13 00 00       	call   801b5b <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8007bf:	68 00 3f 80 00       	push   $0x803f00
  8007c4:	68 bd 3d 80 00       	push   $0x803dbd
  8007c9:	68 92 00 00 00       	push   $0x92
  8007ce:	68 24 3f 80 00       	push   $0x803f24
  8007d3:	e8 83 13 00 00       	call   801b5b <_panic>

008007d8 <check_super>:
// Super block
// --------------------------------------------------------------

// Validate the file system super-block.
void check_super(void)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  8007de:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8007e3:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8007e9:	75 1b                	jne    800806 <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE / BLKSIZE)
  8007eb:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8007f2:	77 26                	ja     80081a <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  8007f4:	83 ec 0c             	sub    $0xc,%esp
  8007f7:	68 ef 3f 80 00       	push   $0x803fef
  8007fc:	e8 35 14 00 00       	call   801c36 <cprintf>
}
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	c9                   	leave  
  800805:	c3                   	ret    
		panic("bad file system magic number");
  800806:	83 ec 04             	sub    $0x4,%esp
  800809:	68 b1 3f 80 00       	push   $0x803fb1
  80080e:	6a 0e                	push   $0xe
  800810:	68 ce 3f 80 00       	push   $0x803fce
  800815:	e8 41 13 00 00       	call   801b5b <_panic>
		panic("file system is too large");
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	68 d6 3f 80 00       	push   $0x803fd6
  800822:	6a 11                	push   $0x11
  800824:	68 ce 3f 80 00       	push   $0x803fce
  800829:	e8 2d 13 00 00       	call   801b5b <_panic>

0080082e <block_is_free>:
// --------------------------------------------------------------

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool block_is_free(uint32_t blockno)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800835:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
		return 0;
  80083b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (super == 0 || blockno >= super->s_nblocks)
  800840:	85 d2                	test   %edx,%edx
  800842:	74 1d                	je     800861 <block_is_free+0x33>
  800844:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800847:	76 18                	jbe    800861 <block_is_free+0x33>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  800849:	89 cb                	mov    %ecx,%ebx
  80084b:	c1 eb 05             	shr    $0x5,%ebx
  80084e:	b8 01 00 00 00       	mov    $0x1,%eax
  800853:	d3 e0                	shl    %cl,%eax
  800855:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80085b:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  80085e:	0f 95 c0             	setne  %al
		return 1;
	return 0;
}
  800861:	5b                   	pop    %ebx
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <free_block>:

// Mark a block free in the bitmap
void free_block(uint32_t blockno)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	53                   	push   %ebx
  800868:	83 ec 04             	sub    $0x4,%esp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  80086e:	85 c9                	test   %ecx,%ecx
  800870:	74 1a                	je     80088c <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno / 32] |= 1 << (blockno % 32);
  800872:	89 cb                	mov    %ecx,%ebx
  800874:	c1 eb 05             	shr    $0x5,%ebx
  800877:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80087d:	b8 01 00 00 00       	mov    $0x1,%eax
  800882:	d3 e0                	shl    %cl,%eax
  800884:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800887:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    
		panic("attempt to free zero block");
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	68 03 40 80 00       	push   $0x804003
  800894:	6a 2a                	push   $0x2a
  800896:	68 ce 3f 80 00       	push   $0x803fce
  80089b:	e8 bb 12 00 00       	call   801b5b <_panic>

008008a0 <alloc_block>:
// Return block number allocated on success,
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int alloc_block(void)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	56                   	push   %esi
  8008a4:	53                   	push   %ebx
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 1; blockno < super->s_nblocks; ++blockno)
  8008a5:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8008aa:	8b 70 04             	mov    0x4(%eax),%esi
  8008ad:	bb 01 00 00 00       	mov    $0x1,%ebx
  8008b2:	39 de                	cmp    %ebx,%esi
  8008b4:	76 45                	jbe    8008fb <alloc_block+0x5b>
	{
		if (block_is_free(blockno))
  8008b6:	53                   	push   %ebx
  8008b7:	e8 72 ff ff ff       	call   80082e <block_is_free>
  8008bc:	83 c4 04             	add    $0x4,%esp
  8008bf:	84 c0                	test   %al,%al
  8008c1:	75 05                	jne    8008c8 <alloc_block+0x28>
	for (blockno = 1; blockno < super->s_nblocks; ++blockno)
  8008c3:	83 c3 01             	add    $0x1,%ebx
  8008c6:	eb ea                	jmp    8008b2 <alloc_block+0x12>
		{
			bitmap[blockno / 32] &= ~(1 << (blockno % 32));
  8008c8:	89 d8                	mov    %ebx,%eax
  8008ca:	c1 e8 05             	shr    $0x5,%eax
  8008cd:	c1 e0 02             	shl    $0x2,%eax
  8008d0:	89 c6                	mov    %eax,%esi
  8008d2:	03 35 08 a0 80 00    	add    0x80a008,%esi
  8008d8:	ba 01 00 00 00       	mov    $0x1,%edx
  8008dd:	89 d9                	mov    %ebx,%ecx
  8008df:	d3 e2                	shl    %cl,%edx
  8008e1:	f7 d2                	not    %edx
  8008e3:	21 16                	and    %edx,(%esi)
			flush_block(&bitmap[blockno / 32]);
  8008e5:	83 ec 0c             	sub    $0xc,%esp
  8008e8:	03 05 08 a0 80 00    	add    0x80a008,%eax
  8008ee:	50                   	push   %eax
  8008ef:	e8 2e fb ff ff       	call   800422 <flush_block>
			return blockno;
  8008f4:	89 d8                	mov    %ebx,%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	eb 05                	jmp    800900 <alloc_block+0x60>
		}
	}
	// panic("alloc_block not implemented");
	return -E_NO_DISK;
  8008fb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800900:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800903:	5b                   	pop    %ebx
  800904:	5e                   	pop    %esi
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	57                   	push   %edi
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	83 ec 1c             	sub    $0x1c,%esp
  800910:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// LAB 5: Your code here.
	if (filebno >= NDIRECT + NINDIRECT)
  800913:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800919:	0f 87 a0 00 00 00    	ja     8009bf <file_block_walk+0xb8>
		return -E_INVAL;
	uint32_t *indirects;
	int bno;
	if (filebno < NDIRECT)
  80091f:	83 fa 09             	cmp    $0x9,%edx
  800922:	77 1c                	ja     800940 <file_block_walk+0x39>
	{
		if (ppdiskbno)
			*ppdiskbno = f->f_direct + filebno;
		return 0;
  800924:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (ppdiskbno)
  800929:	85 c9                	test   %ecx,%ecx
  80092b:	74 09                	je     800936 <file_block_walk+0x2f>
			*ppdiskbno = f->f_direct + filebno;
  80092d:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  800934:	89 01                	mov    %eax,(%ecx)
		if (ppdiskbno)
			*ppdiskbno = &(indirects[filebno - NDIRECT]);
	}
	return 0;
	// panic("file_block_walk not implemented");
}
  800936:	89 d8                	mov    %ebx,%eax
  800938:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5f                   	pop    %edi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    
  800940:	89 ce                	mov    %ecx,%esi
  800942:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800945:	89 c7                	mov    %eax,%edi
		if (f->f_indirect)
  800947:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  80094d:	85 c0                	test   %eax,%eax
  80094f:	75 4b                	jne    80099c <file_block_walk+0x95>
			if (!alloc)
  800951:	84 db                	test   %bl,%bl
  800953:	74 74                	je     8009c9 <file_block_walk+0xc2>
			if ((bno = alloc_block()) < 0)
  800955:	e8 46 ff ff ff       	call   8008a0 <alloc_block>
  80095a:	89 c3                	mov    %eax,%ebx
  80095c:	85 c0                	test   %eax,%eax
  80095e:	78 d6                	js     800936 <file_block_walk+0x2f>
			f->f_indirect = bno;
  800960:	89 87 b0 00 00 00    	mov    %eax,0xb0(%edi)
			memset(diskaddr(bno), 0, BLKSIZE);
  800966:	83 ec 0c             	sub    $0xc,%esp
  800969:	50                   	push   %eax
  80096a:	e8 35 fa ff ff       	call   8003a4 <diskaddr>
  80096f:	83 c4 0c             	add    $0xc,%esp
  800972:	68 00 10 00 00       	push   $0x1000
  800977:	6a 00                	push   $0x0
  800979:	50                   	push   %eax
  80097a:	e8 17 1a 00 00       	call   802396 <memset>
			flush_block(diskaddr(bno));
  80097f:	89 1c 24             	mov    %ebx,(%esp)
  800982:	e8 1d fa ff ff       	call   8003a4 <diskaddr>
  800987:	89 04 24             	mov    %eax,(%esp)
  80098a:	e8 93 fa ff ff       	call   800422 <flush_block>
			indirects = diskaddr(bno);
  80098f:	89 1c 24             	mov    %ebx,(%esp)
  800992:	e8 0d fa ff ff       	call   8003a4 <diskaddr>
  800997:	83 c4 10             	add    $0x10,%esp
  80099a:	eb 0c                	jmp    8009a8 <file_block_walk+0xa1>
			indirects = diskaddr(f->f_indirect);
  80099c:	83 ec 0c             	sub    $0xc,%esp
  80099f:	50                   	push   %eax
  8009a0:	e8 ff f9 ff ff       	call   8003a4 <diskaddr>
  8009a5:	83 c4 10             	add    $0x10,%esp
	return 0;
  8009a8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (ppdiskbno)
  8009ad:	85 f6                	test   %esi,%esi
  8009af:	74 85                	je     800936 <file_block_walk+0x2f>
			*ppdiskbno = &(indirects[filebno - NDIRECT]);
  8009b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009b4:	8d 44 b8 d8          	lea    -0x28(%eax,%edi,4),%eax
  8009b8:	89 06                	mov    %eax,(%esi)
  8009ba:	e9 77 ff ff ff       	jmp    800936 <file_block_walk+0x2f>
		return -E_INVAL;
  8009bf:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  8009c4:	e9 6d ff ff ff       	jmp    800936 <file_block_walk+0x2f>
				return -E_NOT_FOUND;
  8009c9:	bb f5 ff ff ff       	mov    $0xfffffff5,%ebx
  8009ce:	e9 63 ff ff ff       	jmp    800936 <file_block_walk+0x2f>

008009d3 <check_bitmap>:
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	56                   	push   %esi
  8009d7:	53                   	push   %ebx
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009d8:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8009dd:	8b 70 04             	mov    0x4(%eax),%esi
  8009e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009e5:	89 d8                	mov    %ebx,%eax
  8009e7:	c1 e0 0f             	shl    $0xf,%eax
  8009ea:	39 c6                	cmp    %eax,%esi
  8009ec:	76 2b                	jbe    800a19 <check_bitmap+0x46>
		assert(!block_is_free(2 + i));
  8009ee:	8d 43 02             	lea    0x2(%ebx),%eax
  8009f1:	50                   	push   %eax
  8009f2:	e8 37 fe ff ff       	call   80082e <block_is_free>
  8009f7:	83 c4 04             	add    $0x4,%esp
  8009fa:	84 c0                	test   %al,%al
  8009fc:	75 05                	jne    800a03 <check_bitmap+0x30>
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8009fe:	83 c3 01             	add    $0x1,%ebx
  800a01:	eb e2                	jmp    8009e5 <check_bitmap+0x12>
		assert(!block_is_free(2 + i));
  800a03:	68 1e 40 80 00       	push   $0x80401e
  800a08:	68 bd 3d 80 00       	push   $0x803dbd
  800a0d:	6a 55                	push   $0x55
  800a0f:	68 ce 3f 80 00       	push   $0x803fce
  800a14:	e8 42 11 00 00       	call   801b5b <_panic>
	assert(!block_is_free(0));
  800a19:	83 ec 0c             	sub    $0xc,%esp
  800a1c:	6a 00                	push   $0x0
  800a1e:	e8 0b fe ff ff       	call   80082e <block_is_free>
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	84 c0                	test   %al,%al
  800a28:	75 28                	jne    800a52 <check_bitmap+0x7f>
	assert(!block_is_free(1));
  800a2a:	83 ec 0c             	sub    $0xc,%esp
  800a2d:	6a 01                	push   $0x1
  800a2f:	e8 fa fd ff ff       	call   80082e <block_is_free>
  800a34:	83 c4 10             	add    $0x10,%esp
  800a37:	84 c0                	test   %al,%al
  800a39:	75 2d                	jne    800a68 <check_bitmap+0x95>
	cprintf("bitmap is good\n");
  800a3b:	83 ec 0c             	sub    $0xc,%esp
  800a3e:	68 58 40 80 00       	push   $0x804058
  800a43:	e8 ee 11 00 00       	call   801c36 <cprintf>
}
  800a48:	83 c4 10             	add    $0x10,%esp
  800a4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    
	assert(!block_is_free(0));
  800a52:	68 34 40 80 00       	push   $0x804034
  800a57:	68 bd 3d 80 00       	push   $0x803dbd
  800a5c:	6a 58                	push   $0x58
  800a5e:	68 ce 3f 80 00       	push   $0x803fce
  800a63:	e8 f3 10 00 00       	call   801b5b <_panic>
	assert(!block_is_free(1));
  800a68:	68 46 40 80 00       	push   $0x804046
  800a6d:	68 bd 3d 80 00       	push   $0x803dbd
  800a72:	6a 59                	push   $0x59
  800a74:	68 ce 3f 80 00       	push   $0x803fce
  800a79:	e8 dd 10 00 00       	call   801b5b <_panic>

00800a7e <fs_init>:
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	83 ec 08             	sub    $0x8,%esp
	if (ide_probe_disk1())
  800a84:	e8 d6 f5 ff ff       	call   80005f <ide_probe_disk1>
  800a89:	84 c0                	test   %al,%al
  800a8b:	75 41                	jne    800ace <fs_init+0x50>
		ide_set_disk(0);
  800a8d:	83 ec 0c             	sub    $0xc,%esp
  800a90:	6a 00                	push   $0x0
  800a92:	e8 2a f6 ff ff       	call   8000c1 <ide_set_disk>
  800a97:	83 c4 10             	add    $0x10,%esp
	bc_init();
  800a9a:	e8 43 fa ff ff       	call   8004e2 <bc_init>
	super = diskaddr(1);
  800a9f:	83 ec 0c             	sub    $0xc,%esp
  800aa2:	6a 01                	push   $0x1
  800aa4:	e8 fb f8 ff ff       	call   8003a4 <diskaddr>
  800aa9:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800aae:	e8 25 fd ff ff       	call   8007d8 <check_super>
	bitmap = diskaddr(2);
  800ab3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800aba:	e8 e5 f8 ff ff       	call   8003a4 <diskaddr>
  800abf:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800ac4:	e8 0a ff ff ff       	call   8009d3 <check_bitmap>
}
  800ac9:	83 c4 10             	add    $0x10,%esp
  800acc:	c9                   	leave  
  800acd:	c3                   	ret    
		ide_set_disk(1);
  800ace:	83 ec 0c             	sub    $0xc,%esp
  800ad1:	6a 01                	push   $0x1
  800ad3:	e8 e9 f5 ff ff       	call   8000c1 <ide_set_disk>
  800ad8:	83 c4 10             	add    $0x10,%esp
  800adb:	eb bd                	jmp    800a9a <fs_init+0x1c>

00800add <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	53                   	push   %ebx
  800ae1:	83 ec 20             	sub    $0x20,%esp
	// LAB 5: Your code here.
	uint32_t *ppdiskbno;
	int ret = file_block_walk(f, filebno, &ppdiskbno, 1);
  800ae4:	6a 01                	push   $0x1
  800ae6:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	e8 13 fe ff ff       	call   800907 <file_block_walk>
  800af4:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	85 c0                	test   %eax,%eax
  800afb:	78 5e                	js     800b5b <file_get_block+0x7e>
		return ret;
	int bno;
	if (*ppdiskbno == 0)
  800afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b00:	83 38 00             	cmpl   $0x0,(%eax)
  800b03:	75 3c                	jne    800b41 <file_get_block+0x64>
	{
		if ((bno = alloc_block()) < 0)
  800b05:	e8 96 fd ff ff       	call   8008a0 <alloc_block>
  800b0a:	89 c3                	mov    %eax,%ebx
  800b0c:	85 c0                	test   %eax,%eax
  800b0e:	78 4b                	js     800b5b <file_get_block+0x7e>
			return bno;
		*ppdiskbno = bno;
  800b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b13:	89 18                	mov    %ebx,(%eax)
		memset(diskaddr(bno), 0, BLKSIZE);
  800b15:	83 ec 0c             	sub    $0xc,%esp
  800b18:	53                   	push   %ebx
  800b19:	e8 86 f8 ff ff       	call   8003a4 <diskaddr>
  800b1e:	83 c4 0c             	add    $0xc,%esp
  800b21:	68 00 10 00 00       	push   $0x1000
  800b26:	6a 00                	push   $0x0
  800b28:	50                   	push   %eax
  800b29:	e8 68 18 00 00       	call   802396 <memset>
		flush_block(diskaddr(bno));
  800b2e:	89 1c 24             	mov    %ebx,(%esp)
  800b31:	e8 6e f8 ff ff       	call   8003a4 <diskaddr>
  800b36:	89 04 24             	mov    %eax,(%esp)
  800b39:	e8 e4 f8 ff ff       	call   800422 <flush_block>
  800b3e:	83 c4 10             	add    $0x10,%esp
	}
	*blk = diskaddr(*ppdiskbno);
  800b41:	83 ec 0c             	sub    $0xc,%esp
  800b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b47:	ff 30                	pushl  (%eax)
  800b49:	e8 56 f8 ff ff       	call   8003a4 <diskaddr>
  800b4e:	8b 55 10             	mov    0x10(%ebp),%edx
  800b51:	89 02                	mov    %eax,(%edx)
	return 0;
  800b53:	83 c4 10             	add    $0x10,%esp
  800b56:	bb 00 00 00 00       	mov    $0x0,%ebx

	// panic("file_get_block not implemented");
}
  800b5b:	89 d8                	mov    %ebx,%eax
  800b5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b60:	c9                   	leave  
  800b61:	c3                   	ret    

00800b62 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	57                   	push   %edi
  800b66:	56                   	push   %esi
  800b67:	53                   	push   %ebx
  800b68:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800b6e:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800b74:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800b7a:	eb 03                	jmp    800b7f <walk_path+0x1d>
		p++;
  800b7c:	83 c0 01             	add    $0x1,%eax
	while (*p == '/')
  800b7f:	80 38 2f             	cmpb   $0x2f,(%eax)
  800b82:	74 f8                	je     800b7c <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800b84:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800b8a:	83 c1 08             	add    $0x8,%ecx
  800b8d:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800b93:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800b9a:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800ba0:	85 c9                	test   %ecx,%ecx
  800ba2:	74 06                	je     800baa <walk_path+0x48>
		*pdir = 0;
  800ba4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800baa:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800bb0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  800bb6:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0')
  800bbb:	e9 b4 01 00 00       	jmp    800d74 <walk_path+0x212>
	{
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800bc0:	83 c7 01             	add    $0x1,%edi
		while (*path != '/' && *path != '\0')
  800bc3:	0f b6 17             	movzbl (%edi),%edx
  800bc6:	80 fa 2f             	cmp    $0x2f,%dl
  800bc9:	74 04                	je     800bcf <walk_path+0x6d>
  800bcb:	84 d2                	test   %dl,%dl
  800bcd:	75 f1                	jne    800bc0 <walk_path+0x5e>
		if (path - p >= MAXNAMELEN)
  800bcf:	89 fb                	mov    %edi,%ebx
  800bd1:	29 c3                	sub    %eax,%ebx
  800bd3:	83 fb 7f             	cmp    $0x7f,%ebx
  800bd6:	0f 8f 70 01 00 00    	jg     800d4c <walk_path+0x1ea>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800bdc:	83 ec 04             	sub    $0x4,%esp
  800bdf:	53                   	push   %ebx
  800be0:	50                   	push   %eax
  800be1:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800be7:	50                   	push   %eax
  800be8:	e8 f6 17 00 00       	call   8023e3 <memmove>
		name[path - p] = '\0';
  800bed:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800bf4:	00 
  800bf5:	83 c4 10             	add    $0x10,%esp
  800bf8:	eb 03                	jmp    800bfd <walk_path+0x9b>
		p++;
  800bfa:	83 c7 01             	add    $0x1,%edi
	while (*p == '/')
  800bfd:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800c00:	74 f8                	je     800bfa <walk_path+0x98>
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800c02:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c08:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800c0f:	0f 85 3e 01 00 00    	jne    800d53 <walk_path+0x1f1>
	assert((dir->f_size % BLKSIZE) == 0);
  800c15:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c1b:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800c20:	0f 85 98 00 00 00    	jne    800cbe <walk_path+0x15c>
	nblock = dir->f_size / BLKSIZE;
  800c26:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800c2c:	85 c0                	test   %eax,%eax
  800c2e:	0f 48 c2             	cmovs  %edx,%eax
  800c31:	c1 f8 0c             	sar    $0xc,%eax
  800c34:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	for (i = 0; i < nblock; i++)
  800c3a:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800c41:	00 00 00 
			if (strcmp(f[j].f_name, name) == 0)
  800c44:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  800c4a:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++)
  800c50:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800c56:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  800c5c:	74 79                	je     800cd7 <walk_path+0x175>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800c67:	50                   	push   %eax
  800c68:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800c6e:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800c74:	e8 64 fe ff ff       	call   800add <file_get_block>
  800c79:	83 c4 10             	add    $0x10,%esp
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	0f 88 fc 00 00 00    	js     800d80 <walk_path+0x21e>
  800c84:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  800c8a:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0)
  800c90:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800c96:	83 ec 08             	sub    $0x8,%esp
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	e8 5b 16 00 00       	call   8022fb <strcmp>
  800ca0:	83 c4 10             	add    $0x10,%esp
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	0f 84 af 00 00 00    	je     800d5a <walk_path+0x1f8>
  800cab:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800cb1:	39 fb                	cmp    %edi,%ebx
  800cb3:	75 db                	jne    800c90 <walk_path+0x12e>
	for (i = 0; i < nblock; i++)
  800cb5:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800cbc:	eb 92                	jmp    800c50 <walk_path+0xee>
	assert((dir->f_size % BLKSIZE) == 0);
  800cbe:	68 68 40 80 00       	push   $0x804068
  800cc3:	68 bd 3d 80 00       	push   $0x803dbd
  800cc8:	68 da 00 00 00       	push   $0xda
  800ccd:	68 ce 3f 80 00       	push   $0x803fce
  800cd2:	e8 84 0e 00 00       	call   801b5b <_panic>
  800cd7:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800cdd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
			if (r == -E_NOT_FOUND && *path == '\0')
  800ce2:	80 3f 00             	cmpb   $0x0,(%edi)
  800ce5:	0f 85 a4 00 00 00    	jne    800d8f <walk_path+0x22d>
				if (pdir)
  800ceb:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	74 08                	je     800cfd <walk_path+0x19b>
					*pdir = dir;
  800cf5:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cfb:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800cfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d01:	74 15                	je     800d18 <walk_path+0x1b6>
					strcpy(lastelem, name);
  800d03:	83 ec 08             	sub    $0x8,%esp
  800d06:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d0c:	50                   	push   %eax
  800d0d:	ff 75 08             	pushl  0x8(%ebp)
  800d10:	e8 40 15 00 00       	call   802255 <strcpy>
  800d15:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  800d18:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			return r;
  800d24:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d29:	eb 64                	jmp    800d8f <walk_path+0x22d>
		}
	}

	if (pdir)
  800d2b:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d31:	85 c0                	test   %eax,%eax
  800d33:	74 02                	je     800d37 <walk_path+0x1d5>
		*pdir = dir;
  800d35:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800d37:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800d3d:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800d43:	89 08                	mov    %ecx,(%eax)
	return 0;
  800d45:	b8 00 00 00 00       	mov    $0x0,%eax
  800d4a:	eb 43                	jmp    800d8f <walk_path+0x22d>
			return -E_BAD_PATH;
  800d4c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800d51:	eb 3c                	jmp    800d8f <walk_path+0x22d>
			return -E_NOT_FOUND;
  800d53:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800d58:	eb 35                	jmp    800d8f <walk_path+0x22d>
  800d5a:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800d60:	89 f8                	mov    %edi,%eax
  800d62:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0)
  800d68:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800d6e:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0')
  800d74:	80 38 00             	cmpb   $0x0,(%eax)
  800d77:	74 b2                	je     800d2b <walk_path+0x1c9>
  800d79:	89 c7                	mov    %eax,%edi
  800d7b:	e9 43 fe ff ff       	jmp    800bc3 <walk_path+0x61>
  800d80:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
			if (r == -E_NOT_FOUND && *path == '\0')
  800d86:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d89:	0f 84 4e ff ff ff    	je     800cdd <walk_path+0x17b>
}
  800d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <file_open>:
}

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int file_open(const char *path, struct File **pf)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800d9d:	6a 00                	push   $0x0
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	ba 00 00 00 00       	mov    $0x0,%edx
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	e8 b3 fd ff ff       	call   800b62 <walk_path>
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	57                   	push   %edi
  800db5:	56                   	push   %esi
  800db6:	53                   	push   %ebx
  800db7:	83 ec 2c             	sub    $0x2c,%esp
  800dba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dbd:	8b 4d 14             	mov    0x14(%ebp),%ecx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  800dc9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (offset >= f->f_size)
  800dce:	39 ca                	cmp    %ecx,%edx
  800dd0:	0f 8e 80 00 00 00    	jle    800e56 <file_read+0xa5>

	count = MIN(count, f->f_size - offset);
  800dd6:	29 ca                	sub    %ecx,%edx
  800dd8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ddb:	89 d0                	mov    %edx,%eax
  800ddd:	0f 47 45 10          	cmova  0x10(%ebp),%eax
  800de1:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count;)
  800de4:	89 ce                	mov    %ecx,%esi
  800de6:	01 c1                	add    %eax,%ecx
  800de8:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800deb:	89 f3                	mov    %esi,%ebx
  800ded:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800df0:	76 61                	jbe    800e53 <file_read+0xa2>
	{
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800df2:	83 ec 04             	sub    $0x4,%esp
  800df5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800df8:	50                   	push   %eax
  800df9:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800dff:	85 f6                	test   %esi,%esi
  800e01:	0f 49 c6             	cmovns %esi,%eax
  800e04:	c1 f8 0c             	sar    $0xc,%eax
  800e07:	50                   	push   %eax
  800e08:	ff 75 08             	pushl  0x8(%ebp)
  800e0b:	e8 cd fc ff ff       	call   800add <file_get_block>
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	85 c0                	test   %eax,%eax
  800e15:	78 3f                	js     800e56 <file_read+0xa5>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800e17:	89 f2                	mov    %esi,%edx
  800e19:	c1 fa 1f             	sar    $0x1f,%edx
  800e1c:	c1 ea 14             	shr    $0x14,%edx
  800e1f:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800e22:	25 ff 0f 00 00       	and    $0xfff,%eax
  800e27:	29 d0                	sub    %edx,%eax
  800e29:	ba 00 10 00 00       	mov    $0x1000,%edx
  800e2e:	29 c2                	sub    %eax,%edx
  800e30:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e33:	29 d9                	sub    %ebx,%ecx
  800e35:	89 cb                	mov    %ecx,%ebx
  800e37:	39 ca                	cmp    %ecx,%edx
  800e39:	0f 46 da             	cmovbe %edx,%ebx
		memmove(buf, blk + pos % BLKSIZE, bn);
  800e3c:	83 ec 04             	sub    $0x4,%esp
  800e3f:	53                   	push   %ebx
  800e40:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e43:	50                   	push   %eax
  800e44:	57                   	push   %edi
  800e45:	e8 99 15 00 00       	call   8023e3 <memmove>
		pos += bn;
  800e4a:	01 de                	add    %ebx,%esi
		buf += bn;
  800e4c:	01 df                	add    %ebx,%edi
  800e4e:	83 c4 10             	add    $0x10,%esp
  800e51:	eb 98                	jmp    800deb <file_read+0x3a>
	}

	return count;
  800e53:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e59:	5b                   	pop    %ebx
  800e5a:	5e                   	pop    %esi
  800e5b:	5f                   	pop    %edi
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <file_set_size>:
	}
}

// Set the size of file f, truncating or extending as necessary.
int file_set_size(struct File *f, off_t newsize)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 2c             	sub    $0x2c,%esp
  800e67:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800e6a:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800e70:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e73:	7f 1f                	jg     800e94 <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	56                   	push   %esi
  800e82:	e8 9b f5 ff ff       	call   800422 <flush_block>
	return 0;
}
  800e87:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5f                   	pop    %edi
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800e94:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800e9a:	05 ff 0f 00 00       	add    $0xfff,%eax
  800e9f:	0f 49 f8             	cmovns %eax,%edi
  800ea2:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea8:	05 fe 1f 00 00       	add    $0x1ffe,%eax
  800ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb0:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800eb6:	0f 49 c2             	cmovns %edx,%eax
  800eb9:	c1 f8 0c             	sar    $0xc,%eax
  800ebc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800ebf:	89 c3                	mov    %eax,%ebx
  800ec1:	eb 3c                	jmp    800eff <file_set_size+0xa1>
	if (new_nblocks <= NDIRECT && f->f_indirect)
  800ec3:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800ec7:	77 ac                	ja     800e75 <file_set_size+0x17>
  800ec9:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	74 a2                	je     800e75 <file_set_size+0x17>
		free_block(f->f_indirect);
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	50                   	push   %eax
  800ed7:	e8 88 f9 ff ff       	call   800864 <free_block>
		f->f_indirect = 0;
  800edc:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ee3:	00 00 00 
  800ee6:	83 c4 10             	add    $0x10,%esp
  800ee9:	eb 8a                	jmp    800e75 <file_set_size+0x17>
			cprintf("warning: file_free_block: %e", r);
  800eeb:	83 ec 08             	sub    $0x8,%esp
  800eee:	50                   	push   %eax
  800eef:	68 85 40 80 00       	push   $0x804085
  800ef4:	e8 3d 0d 00 00       	call   801c36 <cprintf>
  800ef9:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800efc:	83 c3 01             	add    $0x1,%ebx
  800eff:	39 df                	cmp    %ebx,%edi
  800f01:	76 c0                	jbe    800ec3 <file_set_size+0x65>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	6a 00                	push   $0x0
  800f08:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800f0b:	89 da                	mov    %ebx,%edx
  800f0d:	89 f0                	mov    %esi,%eax
  800f0f:	e8 f3 f9 ff ff       	call   800907 <file_block_walk>
  800f14:	83 c4 10             	add    $0x10,%esp
  800f17:	85 c0                	test   %eax,%eax
  800f19:	78 d0                	js     800eeb <file_set_size+0x8d>
	if (*ptr)
  800f1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f1e:	8b 00                	mov    (%eax),%eax
  800f20:	85 c0                	test   %eax,%eax
  800f22:	74 d8                	je     800efc <file_set_size+0x9e>
		free_block(*ptr);
  800f24:	83 ec 0c             	sub    $0xc,%esp
  800f27:	50                   	push   %eax
  800f28:	e8 37 f9 ff ff       	call   800864 <free_block>
		*ptr = 0;
  800f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f36:	83 c4 10             	add    $0x10,%esp
  800f39:	eb c1                	jmp    800efc <file_set_size+0x9e>

00800f3b <file_write>:
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
  800f41:	83 ec 2c             	sub    $0x2c,%esp
  800f44:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f47:	8b 75 14             	mov    0x14(%ebp),%esi
	if (offset + count > f->f_size)
  800f4a:	89 f0                	mov    %esi,%eax
  800f4c:	03 45 10             	add    0x10(%ebp),%eax
  800f4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f55:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  800f5b:	77 68                	ja     800fc5 <file_write+0x8a>
	for (pos = offset; pos < offset + count;)
  800f5d:	89 f3                	mov    %esi,%ebx
  800f5f:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
  800f62:	76 74                	jbe    800fd8 <file_write+0x9d>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f6a:	50                   	push   %eax
  800f6b:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
  800f71:	85 f6                	test   %esi,%esi
  800f73:	0f 49 c6             	cmovns %esi,%eax
  800f76:	c1 f8 0c             	sar    $0xc,%eax
  800f79:	50                   	push   %eax
  800f7a:	ff 75 08             	pushl  0x8(%ebp)
  800f7d:	e8 5b fb ff ff       	call   800add <file_get_block>
  800f82:	83 c4 10             	add    $0x10,%esp
  800f85:	85 c0                	test   %eax,%eax
  800f87:	78 52                	js     800fdb <file_write+0xa0>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f89:	89 f2                	mov    %esi,%edx
  800f8b:	c1 fa 1f             	sar    $0x1f,%edx
  800f8e:	c1 ea 14             	shr    $0x14,%edx
  800f91:	8d 04 16             	lea    (%esi,%edx,1),%eax
  800f94:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f99:	29 d0                	sub    %edx,%eax
  800f9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800fa0:	29 c1                	sub    %eax,%ecx
  800fa2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fa5:	29 da                	sub    %ebx,%edx
  800fa7:	39 d1                	cmp    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(blk + pos % BLKSIZE, buf, bn);
  800fae:	83 ec 04             	sub    $0x4,%esp
  800fb1:	53                   	push   %ebx
  800fb2:	57                   	push   %edi
  800fb3:	03 45 e4             	add    -0x1c(%ebp),%eax
  800fb6:	50                   	push   %eax
  800fb7:	e8 27 14 00 00       	call   8023e3 <memmove>
		pos += bn;
  800fbc:	01 de                	add    %ebx,%esi
		buf += bn;
  800fbe:	01 df                	add    %ebx,%edi
  800fc0:	83 c4 10             	add    $0x10,%esp
  800fc3:	eb 98                	jmp    800f5d <file_write+0x22>
		if ((r = file_set_size(f, offset + count)) < 0)
  800fc5:	83 ec 08             	sub    $0x8,%esp
  800fc8:	50                   	push   %eax
  800fc9:	51                   	push   %ecx
  800fca:	e8 8f fe ff ff       	call   800e5e <file_set_size>
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	79 87                	jns    800f5d <file_write+0x22>
  800fd6:	eb 03                	jmp    800fdb <file_write+0xa0>
	return count;
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800fdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <file_flush>:
// Flush the contents and metadata of file f out to disk.
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void file_flush(struct File *f)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	56                   	push   %esi
  800fe7:	53                   	push   %ebx
  800fe8:	83 ec 10             	sub    $0x10,%esp
  800feb:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++)
  800fee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff3:	eb 03                	jmp    800ff8 <file_flush+0x15>
  800ff5:	83 c3 01             	add    $0x1,%ebx
  800ff8:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  800ffe:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  801004:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  80100a:	85 c9                	test   %ecx,%ecx
  80100c:	0f 49 c1             	cmovns %ecx,%eax
  80100f:	c1 f8 0c             	sar    $0xc,%eax
  801012:	39 d8                	cmp    %ebx,%eax
  801014:	7e 3b                	jle    801051 <file_flush+0x6e>
	{
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	6a 00                	push   $0x0
  80101b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  80101e:	89 da                	mov    %ebx,%edx
  801020:	89 f0                	mov    %esi,%eax
  801022:	e8 e0 f8 ff ff       	call   800907 <file_block_walk>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	78 c7                	js     800ff5 <file_flush+0x12>
			pdiskbno == NULL || *pdiskbno == 0)
  80102e:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801031:	85 c0                	test   %eax,%eax
  801033:	74 c0                	je     800ff5 <file_flush+0x12>
			pdiskbno == NULL || *pdiskbno == 0)
  801035:	8b 00                	mov    (%eax),%eax
  801037:	85 c0                	test   %eax,%eax
  801039:	74 ba                	je     800ff5 <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	50                   	push   %eax
  80103f:	e8 60 f3 ff ff       	call   8003a4 <diskaddr>
  801044:	89 04 24             	mov    %eax,(%esp)
  801047:	e8 d6 f3 ff ff       	call   800422 <flush_block>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	eb a4                	jmp    800ff5 <file_flush+0x12>
	}
	flush_block(f);
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	56                   	push   %esi
  801055:	e8 c8 f3 ff ff       	call   800422 <flush_block>
	if (f->f_indirect)
  80105a:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	75 07                	jne    80106e <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  801067:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80106a:	5b                   	pop    %ebx
  80106b:	5e                   	pop    %esi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  80106e:	83 ec 0c             	sub    $0xc,%esp
  801071:	50                   	push   %eax
  801072:	e8 2d f3 ff ff       	call   8003a4 <diskaddr>
  801077:	89 04 24             	mov    %eax,(%esp)
  80107a:	e8 a3 f3 ff ff       	call   800422 <flush_block>
  80107f:	83 c4 10             	add    $0x10,%esp
}
  801082:	eb e3                	jmp    801067 <file_flush+0x84>

00801084 <file_create>:
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
  80108a:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801090:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801096:	50                   	push   %eax
  801097:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  80109d:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	e8 b7 fa ff ff       	call   800b62 <walk_path>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	0f 84 0e 01 00 00    	je     8011c4 <file_create+0x140>
	if (r != -E_NOT_FOUND || dir == 0)
  8010b6:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8010b9:	74 08                	je     8010c3 <file_create+0x3f>
}
  8010bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010be:	5b                   	pop    %ebx
  8010bf:	5e                   	pop    %esi
  8010c0:	5f                   	pop    %edi
  8010c1:	5d                   	pop    %ebp
  8010c2:	c3                   	ret    
	if (r != -E_NOT_FOUND || dir == 0)
  8010c3:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  8010c9:	85 db                	test   %ebx,%ebx
  8010cb:	74 ee                	je     8010bb <file_create+0x37>
	assert((dir->f_size % BLKSIZE) == 0);
  8010cd:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  8010d3:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8010d8:	75 5c                	jne    801136 <file_create+0xb2>
	nblock = dir->f_size / BLKSIZE;
  8010da:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8010e0:	85 c0                	test   %eax,%eax
  8010e2:	0f 48 c2             	cmovs  %edx,%eax
  8010e5:	c1 f8 0c             	sar    $0xc,%eax
  8010e8:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++)
  8010ee:	be 00 00 00 00       	mov    $0x0,%esi
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8010f3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++)
  8010f9:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8010ff:	0f 84 8b 00 00 00    	je     801190 <file_create+0x10c>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801105:	83 ec 04             	sub    $0x4,%esp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	e8 cd f9 ff ff       	call   800add <file_get_block>
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	85 c0                	test   %eax,%eax
  801115:	78 a4                	js     8010bb <file_create+0x37>
  801117:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80111d:	8d 88 00 10 00 00    	lea    0x1000(%eax),%ecx
			if (f[j].f_name[0] == '\0')
  801123:	80 38 00             	cmpb   $0x0,(%eax)
  801126:	74 27                	je     80114f <file_create+0xcb>
  801128:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  80112d:	39 c8                	cmp    %ecx,%eax
  80112f:	75 f2                	jne    801123 <file_create+0x9f>
	for (i = 0; i < nblock; i++)
  801131:	83 c6 01             	add    $0x1,%esi
  801134:	eb c3                	jmp    8010f9 <file_create+0x75>
	assert((dir->f_size % BLKSIZE) == 0);
  801136:	68 68 40 80 00       	push   $0x804068
  80113b:	68 bd 3d 80 00       	push   $0x803dbd
  801140:	68 f5 00 00 00       	push   $0xf5
  801145:	68 ce 3f 80 00       	push   $0x803fce
  80114a:	e8 0c 0a 00 00       	call   801b5b <_panic>
				*file = &f[j];
  80114f:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  801155:	83 ec 08             	sub    $0x8,%esp
  801158:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80115e:	50                   	push   %eax
  80115f:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  801165:	e8 eb 10 00 00       	call   802255 <strcpy>
	*pf = f;
  80116a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116d:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  801173:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801175:	83 c4 04             	add    $0x4,%esp
  801178:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  80117e:	e8 60 fe ff ff       	call   800fe3 <file_flush>
	return 0;
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	e9 2b ff ff ff       	jmp    8010bb <file_create+0x37>
	dir->f_size += BLKSIZE;
  801190:	81 83 80 00 00 00 00 	addl   $0x1000,0x80(%ebx)
  801197:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	e8 32 f9 ff ff       	call   800add <file_get_block>
  8011ab:	83 c4 10             	add    $0x10,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	0f 88 05 ff ff ff    	js     8010bb <file_create+0x37>
	*file = &f[0];
  8011b6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8011bc:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8011c2:	eb 91                	jmp    801155 <file_create+0xd1>
		return -E_FILE_EXISTS;
  8011c4:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8011c9:	e9 ed fe ff ff       	jmp    8010bb <file_create+0x37>

008011ce <fs_sync>:

// Sync the entire file system.  A big hammer.
void fs_sync(void)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	53                   	push   %ebx
  8011d2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  8011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
  8011da:	eb 17                	jmp    8011f3 <fs_sync+0x25>
		flush_block(diskaddr(i));
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	53                   	push   %ebx
  8011e0:	e8 bf f1 ff ff       	call   8003a4 <diskaddr>
  8011e5:	89 04 24             	mov    %eax,(%esp)
  8011e8:	e8 35 f2 ff ff       	call   800422 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  8011ed:	83 c3 01             	add    $0x1,%ebx
  8011f0:	83 c4 10             	add    $0x10,%esp
  8011f3:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8011f8:	39 58 04             	cmp    %ebx,0x4(%eax)
  8011fb:	77 df                	ja     8011dc <fs_sync+0xe>
}
  8011fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801200:	c9                   	leave  
  801201:	c3                   	ret    

00801202 <serve_sync>:
	file_flush(o->o_file);
	return 0;
}

int serve_sync(envid_t envid, union Fsipc *req)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801208:	e8 c1 ff ff ff       	call   8011ce <fs_sync>
	return 0;
}
  80120d:	b8 00 00 00 00       	mov    $0x0,%eax
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <serve_init>:
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	ba 60 50 80 00       	mov    $0x805060,%edx
	uintptr_t va = FILEVA;
  80121c:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++)
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801226:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd *)va;
  801228:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  80122b:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++)
  801231:	83 c0 01             	add    $0x1,%eax
  801234:	83 c2 10             	add    $0x10,%edx
  801237:	3d 00 04 00 00       	cmp    $0x400,%eax
  80123c:	75 e8                	jne    801226 <serve_init+0x12>
}
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <openfile_alloc>:
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	57                   	push   %edi
  801244:	56                   	push   %esi
  801245:	53                   	push   %ebx
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++)
  80124c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801251:	89 de                	mov    %ebx,%esi
  801253:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd))
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
  80125f:	e8 6a 1f 00 00       	call   8031ce <pageref>
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	85 c0                	test   %eax,%eax
  801269:	74 17                	je     801282 <openfile_alloc+0x42>
  80126b:	83 f8 01             	cmp    $0x1,%eax
  80126e:	74 30                	je     8012a0 <openfile_alloc+0x60>
	for (i = 0; i < MAXOPEN; i++)
  801270:	83 c3 01             	add    $0x1,%ebx
  801273:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  801279:	75 d6                	jne    801251 <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  80127b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801280:	eb 4f                	jmp    8012d1 <openfile_alloc+0x91>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P | PTE_U | PTE_W)) < 0)
  801282:	83 ec 04             	sub    $0x4,%esp
  801285:	6a 07                	push   $0x7
  801287:	89 d8                	mov    %ebx,%eax
  801289:	c1 e0 04             	shl    $0x4,%eax
  80128c:	ff b0 6c 50 80 00    	pushl  0x80506c(%eax)
  801292:	6a 00                	push   $0x0
  801294:	e8 b5 13 00 00       	call   80264e <sys_page_alloc>
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 31                	js     8012d1 <openfile_alloc+0x91>
			opentab[i].o_fileid += MAXOPEN;
  8012a0:	c1 e3 04             	shl    $0x4,%ebx
  8012a3:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8012aa:	04 00 00 
			*o = &opentab[i];
  8012ad:	81 c6 60 50 80 00    	add    $0x805060,%esi
  8012b3:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8012b5:	83 ec 04             	sub    $0x4,%esp
  8012b8:	68 00 10 00 00       	push   $0x1000
  8012bd:	6a 00                	push   $0x0
  8012bf:	ff b3 6c 50 80 00    	pushl  0x80506c(%ebx)
  8012c5:	e8 cc 10 00 00       	call   802396 <memset>
			return (*o)->o_fileid;
  8012ca:	8b 07                	mov    (%edi),%eax
  8012cc:	8b 00                	mov    (%eax),%eax
  8012ce:	83 c4 10             	add    $0x10,%esp
}
  8012d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d4:	5b                   	pop    %ebx
  8012d5:	5e                   	pop    %esi
  8012d6:	5f                   	pop    %edi
  8012d7:	5d                   	pop    %ebp
  8012d8:	c3                   	ret    

008012d9 <openfile_lookup>:
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	57                   	push   %edi
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	83 ec 18             	sub    $0x18,%esp
  8012e2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  8012e5:	89 fb                	mov    %edi,%ebx
  8012e7:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8012ed:	89 de                	mov    %ebx,%esi
  8012ef:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012f2:	ff b6 6c 50 80 00    	pushl  0x80506c(%esi)
	o = &opentab[fileid % MAXOPEN];
  8012f8:	81 c6 60 50 80 00    	add    $0x805060,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  8012fe:	e8 cb 1e 00 00       	call   8031ce <pageref>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	83 f8 01             	cmp    $0x1,%eax
  801309:	7e 1d                	jle    801328 <openfile_lookup+0x4f>
  80130b:	c1 e3 04             	shl    $0x4,%ebx
  80130e:	39 bb 60 50 80 00    	cmp    %edi,0x805060(%ebx)
  801314:	75 19                	jne    80132f <openfile_lookup+0x56>
	*po = o;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	89 30                	mov    %esi,(%eax)
	return 0;
  80131b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801323:	5b                   	pop    %ebx
  801324:	5e                   	pop    %esi
  801325:	5f                   	pop    %edi
  801326:	5d                   	pop    %ebp
  801327:	c3                   	ret    
		return -E_INVAL;
  801328:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132d:	eb f1                	jmp    801320 <openfile_lookup+0x47>
  80132f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801334:	eb ea                	jmp    801320 <openfile_lookup+0x47>

00801336 <serve_set_size>:
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	53                   	push   %ebx
  80133a:	83 ec 18             	sub    $0x18,%esp
  80133d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801340:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801343:	50                   	push   %eax
  801344:	ff 33                	pushl  (%ebx)
  801346:	ff 75 08             	pushl  0x8(%ebp)
  801349:	e8 8b ff ff ff       	call   8012d9 <openfile_lookup>
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	85 c0                	test   %eax,%eax
  801353:	78 14                	js     801369 <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801355:	83 ec 08             	sub    $0x8,%esp
  801358:	ff 73 04             	pushl  0x4(%ebx)
  80135b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135e:	ff 70 04             	pushl  0x4(%eax)
  801361:	e8 f8 fa ff ff       	call   800e5e <file_set_size>
  801366:	83 c4 10             	add    $0x10,%esp
}
  801369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <serve_read>:
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	53                   	push   %ebx
  801372:	83 ec 18             	sub    $0x18,%esp
  801375:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0)
  801378:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137b:	50                   	push   %eax
  80137c:	ff 33                	pushl  (%ebx)
  80137e:	ff 75 08             	pushl  0x8(%ebp)
  801381:	e8 53 ff ff ff       	call   8012d9 <openfile_lookup>
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	85 c0                	test   %eax,%eax
  80138b:	78 25                	js     8013b2 <serve_read+0x44>
	if ((r = file_read(of->o_file, ret->ret_buf, req->req_n, of->o_fd->fd_offset)) < 0)
  80138d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801390:	8b 50 0c             	mov    0xc(%eax),%edx
  801393:	ff 72 04             	pushl  0x4(%edx)
  801396:	ff 73 04             	pushl  0x4(%ebx)
  801399:	53                   	push   %ebx
  80139a:	ff 70 04             	pushl  0x4(%eax)
  80139d:	e8 0f fa ff ff       	call   800db1 <file_read>
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	78 09                	js     8013b2 <serve_read+0x44>
	of->o_fd->fd_offset += r;
  8013a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8013af:	01 42 04             	add    %eax,0x4(%edx)
}
  8013b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <serve_write>:
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 18             	sub    $0x18,%esp
  8013be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &of)) < 0)
  8013c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	ff 33                	pushl  (%ebx)
  8013c7:	ff 75 08             	pushl  0x8(%ebp)
  8013ca:	e8 0a ff ff ff       	call   8012d9 <openfile_lookup>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	78 28                	js     8013fe <serve_write+0x47>
	if ((r = file_write(of->o_file, req->req_buf, req->req_n, of->o_fd->fd_offset)) < 0)
  8013d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8013dc:	ff 72 04             	pushl  0x4(%edx)
  8013df:	ff 73 04             	pushl  0x4(%ebx)
  8013e2:	83 c3 08             	add    $0x8,%ebx
  8013e5:	53                   	push   %ebx
  8013e6:	ff 70 04             	pushl  0x4(%eax)
  8013e9:	e8 4d fb ff ff       	call   800f3b <file_write>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	78 09                	js     8013fe <serve_write+0x47>
	of->o_fd->fd_offset += r;
  8013f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f8:	8b 52 0c             	mov    0xc(%edx),%edx
  8013fb:	01 42 04             	add    %eax,0x4(%edx)
}
  8013fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <serve_stat>:
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	53                   	push   %ebx
  801407:	83 ec 18             	sub    $0x18,%esp
  80140a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80140d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801410:	50                   	push   %eax
  801411:	ff 33                	pushl  (%ebx)
  801413:	ff 75 08             	pushl  0x8(%ebp)
  801416:	e8 be fe ff ff       	call   8012d9 <openfile_lookup>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	85 c0                	test   %eax,%eax
  801420:	78 3f                	js     801461 <serve_stat+0x5e>
	strcpy(ret->ret_name, o->o_file->f_name);
  801422:	83 ec 08             	sub    $0x8,%esp
  801425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801428:	ff 70 04             	pushl  0x4(%eax)
  80142b:	53                   	push   %ebx
  80142c:	e8 24 0e 00 00       	call   802255 <strcpy>
	ret->ret_size = o->o_file->f_size;
  801431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801434:	8b 50 04             	mov    0x4(%eax),%edx
  801437:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  80143d:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  801443:	8b 40 04             	mov    0x4(%eax),%eax
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  801450:	0f 94 c0             	sete   %al
  801453:	0f b6 c0             	movzbl %al,%eax
  801456:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <serve_flush>:
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80146c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146f:	50                   	push   %eax
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	ff 30                	pushl  (%eax)
  801475:	ff 75 08             	pushl  0x8(%ebp)
  801478:	e8 5c fe ff ff       	call   8012d9 <openfile_lookup>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	85 c0                	test   %eax,%eax
  801482:	78 16                	js     80149a <serve_flush+0x34>
	file_flush(o->o_file);
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	ff 70 04             	pushl  0x4(%eax)
  80148d:	e8 51 fb ff ff       	call   800fe3 <file_flush>
	return 0;
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <serve_open>:
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	53                   	push   %ebx
  8014a0:	81 ec 18 04 00 00    	sub    $0x418,%esp
  8014a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  8014a9:	68 00 04 00 00       	push   $0x400
  8014ae:	53                   	push   %ebx
  8014af:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014b5:	50                   	push   %eax
  8014b6:	e8 28 0f 00 00       	call   8023e3 <memmove>
	path[MAXPATHLEN - 1] = 0;
  8014bb:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0)
  8014bf:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8014c5:	89 04 24             	mov    %eax,(%esp)
  8014c8:	e8 73 fd ff ff       	call   801240 <openfile_alloc>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	0f 88 f0 00 00 00    	js     8015c8 <serve_open+0x12c>
	if (req->req_omode & O_CREAT)
  8014d8:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8014df:	74 33                	je     801514 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0)
  8014e1:	83 ec 08             	sub    $0x8,%esp
  8014e4:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	e8 8d fb ff ff       	call   801084 <file_create>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	79 37                	jns    801535 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8014fe:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801505:	0f 85 bd 00 00 00    	jne    8015c8 <serve_open+0x12c>
  80150b:	83 f8 f3             	cmp    $0xfffffff3,%eax
  80150e:	0f 85 b4 00 00 00    	jne    8015c8 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0)
  801514:	83 ec 08             	sub    $0x8,%esp
  801517:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80151d:	50                   	push   %eax
  80151e:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	e8 6d f8 ff ff       	call   800d97 <file_open>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	0f 88 93 00 00 00    	js     8015c8 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC)
  801535:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  80153c:	74 17                	je     801555 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0)
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	6a 00                	push   $0x0
  801543:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  801549:	e8 10 f9 ff ff       	call   800e5e <file_set_size>
  80154e:	83 c4 10             	add    $0x10,%esp
  801551:	85 c0                	test   %eax,%eax
  801553:	78 73                	js     8015c8 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0)
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80155e:	50                   	push   %eax
  80155f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801565:	50                   	push   %eax
  801566:	e8 2c f8 ff ff       	call   800d97 <file_open>
  80156b:	83 c4 10             	add    $0x10,%esp
  80156e:	85 c0                	test   %eax,%eax
  801570:	78 56                	js     8015c8 <serve_open+0x12c>
	o->o_file = f;
  801572:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801578:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80157e:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  801581:	8b 50 0c             	mov    0xc(%eax),%edx
  801584:	8b 08                	mov    (%eax),%ecx
  801586:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801589:	8b 48 0c             	mov    0xc(%eax),%ecx
  80158c:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801592:	83 e2 03             	and    $0x3,%edx
  801595:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801598:	8b 40 0c             	mov    0xc(%eax),%eax
  80159b:	8b 15 64 90 80 00    	mov    0x809064,%edx
  8015a1:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  8015a3:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015a9:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8015af:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  8015b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P | PTE_U | PTE_W | PTE_SHARE;
  8015ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bd:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <serve>:
	[FSREQ_WRITE] = (fshandler)serve_write,
	[FSREQ_SET_SIZE] = (fshandler)serve_set_size,
	[FSREQ_SYNC] = serve_sync};

void serve(void)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	56                   	push   %esi
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 10             	sub    $0x10,%esp
	void *pg;

	while (1)
	{
		perm = 0;
		req = ipc_recv((int32_t *)&whom, fsreq, &perm);
  8015d5:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  8015d8:	8d 75 f4             	lea    -0xc(%ebp),%esi
  8015db:	eb 68                	jmp    801645 <serve+0x78>
					req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P))
		{
			cprintf("Invalid request from %08x: no argument page\n",
  8015dd:	83 ec 08             	sub    $0x8,%esp
  8015e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e3:	68 a4 40 80 00       	push   $0x8040a4
  8015e8:	e8 49 06 00 00       	call   801c36 <cprintf>
					whom);
			continue; // just leave it hanging...
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	eb 53                	jmp    801645 <serve+0x78>
		}

		pg = NULL;
		if (req == FSREQ_OPEN)
		{
			r = serve_open(whom, (struct Fsreq_open *)fsreq, &pg, &perm);
  8015f2:	53                   	push   %ebx
  8015f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	ff 35 44 50 80 00    	pushl  0x805044
  8015fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801600:	e8 97 fe ff ff       	call   80149c <serve_open>
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	eb 19                	jmp    801623 <serve+0x56>
		{
			r = handlers[req](whom, fsreq);
		}
		else
		{
			cprintf("Invalid request code %d from %08x\n", req, whom);
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	ff 75 f4             	pushl  -0xc(%ebp)
  801610:	50                   	push   %eax
  801611:	68 d4 40 80 00       	push   $0x8040d4
  801616:	e8 1b 06 00 00       	call   801c36 <cprintf>
  80161b:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  801623:	ff 75 f0             	pushl  -0x10(%ebp)
  801626:	ff 75 ec             	pushl  -0x14(%ebp)
  801629:	50                   	push   %eax
  80162a:	ff 75 f4             	pushl  -0xc(%ebp)
  80162d:	e8 1e 13 00 00       	call   802950 <ipc_send>
		sys_page_unmap(0, fsreq);
  801632:	83 c4 08             	add    $0x8,%esp
  801635:	ff 35 44 50 80 00    	pushl  0x805044
  80163b:	6a 00                	push   $0x0
  80163d:	e8 91 10 00 00       	call   8026d3 <sys_page_unmap>
  801642:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  801645:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *)&whom, fsreq, &perm);
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	53                   	push   %ebx
  801650:	ff 35 44 50 80 00    	pushl  0x805044
  801656:	56                   	push   %esi
  801657:	e8 8d 12 00 00       	call   8028e9 <ipc_recv>
		if (!(perm & PTE_P))
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801663:	0f 84 74 ff ff ff    	je     8015dd <serve+0x10>
		pg = NULL;
  801669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN)
  801670:	83 f8 01             	cmp    $0x1,%eax
  801673:	0f 84 79 ff ff ff    	je     8015f2 <serve+0x25>
		else if (req < ARRAY_SIZE(handlers) && handlers[req])
  801679:	83 f8 08             	cmp    $0x8,%eax
  80167c:	77 8c                	ja     80160a <serve+0x3d>
  80167e:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	74 81                	je     80160a <serve+0x3d>
			r = handlers[req](whom, fsreq);
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	ff 35 44 50 80 00    	pushl  0x805044
  801692:	ff 75 f4             	pushl  -0xc(%ebp)
  801695:	ff d2                	call   *%edx
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	eb 87                	jmp    801623 <serve+0x56>

0080169c <umain>:
	}
}

void umain(int argc, char **argv)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  8016a2:	c7 05 60 90 80 00 f7 	movl   $0x8040f7,0x809060
  8016a9:	40 80 00 
	cprintf("FS is running\n");
  8016ac:	68 fa 40 80 00       	push   $0x8040fa
  8016b1:	e8 80 05 00 00       	call   801c36 <cprintf>
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  8016b6:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  8016bb:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  8016c0:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  8016c2:	c7 04 24 09 41 80 00 	movl   $0x804109,(%esp)
  8016c9:	e8 68 05 00 00       	call   801c36 <cprintf>

	serve_init();
  8016ce:	e8 41 fb ff ff       	call   801214 <serve_init>
	fs_init();
  8016d3:	e8 a6 f3 ff ff       	call   800a7e <fs_init>
	serve();
  8016d8:	e8 f0 fe ff ff       	call   8015cd <serve>

008016dd <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	53                   	push   %ebx
  8016e1:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  8016e4:	6a 07                	push   $0x7
  8016e6:	68 00 10 00 00       	push   $0x1000
  8016eb:	6a 00                	push   $0x0
  8016ed:	e8 5c 0f 00 00       	call   80264e <sys_page_alloc>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	0f 88 6a 02 00 00    	js     801967 <fs_test+0x28a>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	68 00 10 00 00       	push   $0x1000
  801705:	ff 35 08 a0 80 00    	pushl  0x80a008
  80170b:	68 00 10 00 00       	push   $0x1000
  801710:	e8 ce 0c 00 00       	call   8023e3 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801715:	e8 86 f1 ff ff       	call   8008a0 <alloc_block>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	85 c0                	test   %eax,%eax
  80171f:	0f 88 54 02 00 00    	js     801979 <fs_test+0x29c>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801725:	8d 50 1f             	lea    0x1f(%eax),%edx
  801728:	85 c0                	test   %eax,%eax
  80172a:	0f 49 d0             	cmovns %eax,%edx
  80172d:	c1 fa 05             	sar    $0x5,%edx
  801730:	89 c3                	mov    %eax,%ebx
  801732:	c1 fb 1f             	sar    $0x1f,%ebx
  801735:	c1 eb 1b             	shr    $0x1b,%ebx
  801738:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
  80173b:	83 e1 1f             	and    $0x1f,%ecx
  80173e:	29 d9                	sub    %ebx,%ecx
  801740:	b8 01 00 00 00       	mov    $0x1,%eax
  801745:	d3 e0                	shl    %cl,%eax
  801747:	85 04 95 00 10 00 00 	test   %eax,0x1000(,%edx,4)
  80174e:	0f 84 37 02 00 00    	je     80198b <fs_test+0x2ae>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801754:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  80175a:	85 04 91             	test   %eax,(%ecx,%edx,4)
  80175d:	0f 85 3e 02 00 00    	jne    8019a1 <fs_test+0x2c4>
	cprintf("alloc_block is good\n");
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	68 60 41 80 00       	push   $0x804160
  80176b:	e8 c6 04 00 00       	call   801c36 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801770:	83 c4 08             	add    $0x8,%esp
  801773:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	68 75 41 80 00       	push   $0x804175
  80177c:	e8 16 f6 ff ff       	call   800d97 <file_open>
  801781:	83 c4 10             	add    $0x10,%esp
  801784:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801787:	74 08                	je     801791 <fs_test+0xb4>
  801789:	85 c0                	test   %eax,%eax
  80178b:	0f 88 26 02 00 00    	js     8019b7 <fs_test+0x2da>
		panic("file_open /not-found: %e", r);
	else if (r == 0)
  801791:	85 c0                	test   %eax,%eax
  801793:	0f 84 30 02 00 00    	je     8019c9 <fs_test+0x2ec>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80179f:	50                   	push   %eax
  8017a0:	68 99 41 80 00       	push   $0x804199
  8017a5:	e8 ed f5 ff ff       	call   800d97 <file_open>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	85 c0                	test   %eax,%eax
  8017af:	0f 88 28 02 00 00    	js     8019dd <fs_test+0x300>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  8017b5:	83 ec 0c             	sub    $0xc,%esp
  8017b8:	68 b9 41 80 00       	push   $0x8041b9
  8017bd:	e8 74 04 00 00       	call   801c36 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8017c2:	83 c4 0c             	add    $0xc,%esp
  8017c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c8:	50                   	push   %eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ce:	e8 0a f3 ff ff       	call   800add <file_get_block>
  8017d3:	83 c4 10             	add    $0x10,%esp
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	0f 88 11 02 00 00    	js     8019ef <fs_test+0x312>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  8017de:	83 ec 08             	sub    $0x8,%esp
  8017e1:	68 00 43 80 00       	push   $0x804300
  8017e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e9:	e8 0d 0b 00 00       	call   8022fb <strcmp>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	0f 85 08 02 00 00    	jne    801a01 <fs_test+0x324>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8017f9:	83 ec 0c             	sub    $0xc,%esp
  8017fc:	68 df 41 80 00       	push   $0x8041df
  801801:	e8 30 04 00 00       	call   801c36 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	0f b6 10             	movzbl (%eax),%edx
  80180c:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  80180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801811:	c1 e8 0c             	shr    $0xc,%eax
  801814:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	a8 40                	test   $0x40,%al
  801820:	0f 84 ef 01 00 00    	je     801a15 <fs_test+0x338>
	file_flush(f);
  801826:	83 ec 0c             	sub    $0xc,%esp
  801829:	ff 75 f4             	pushl  -0xc(%ebp)
  80182c:	e8 b2 f7 ff ff       	call   800fe3 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	c1 e8 0c             	shr    $0xc,%eax
  801837:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	a8 40                	test   $0x40,%al
  801843:	0f 85 e2 01 00 00    	jne    801a2b <fs_test+0x34e>
	cprintf("file_flush is good\n");
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	68 13 42 80 00       	push   $0x804213
  801851:	e8 e0 03 00 00       	call   801c36 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801856:	83 c4 08             	add    $0x8,%esp
  801859:	6a 00                	push   $0x0
  80185b:	ff 75 f4             	pushl  -0xc(%ebp)
  80185e:	e8 fb f5 ff ff       	call   800e5e <file_set_size>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	0f 88 d3 01 00 00    	js     801a41 <fs_test+0x364>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801878:	0f 85 d5 01 00 00    	jne    801a53 <fs_test+0x376>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80187e:	c1 e8 0c             	shr    $0xc,%eax
  801881:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801888:	a8 40                	test   $0x40,%al
  80188a:	0f 85 d9 01 00 00    	jne    801a69 <fs_test+0x38c>
	cprintf("file_truncate is good\n");
  801890:	83 ec 0c             	sub    $0xc,%esp
  801893:	68 67 42 80 00       	push   $0x804267
  801898:	e8 99 03 00 00       	call   801c36 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  80189d:	c7 04 24 00 43 80 00 	movl   $0x804300,(%esp)
  8018a4:	e8 75 09 00 00       	call   80221e <strlen>
  8018a9:	83 c4 08             	add    $0x8,%esp
  8018ac:	50                   	push   %eax
  8018ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b0:	e8 a9 f5 ff ff       	call   800e5e <file_set_size>
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	0f 88 bf 01 00 00    	js     801a7f <fs_test+0x3a2>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	c1 ea 0c             	shr    $0xc,%edx
  8018c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018cf:	f6 c2 40             	test   $0x40,%dl
  8018d2:	0f 85 b9 01 00 00    	jne    801a91 <fs_test+0x3b4>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	8d 55 f0             	lea    -0x10(%ebp),%edx
  8018de:	52                   	push   %edx
  8018df:	6a 00                	push   $0x0
  8018e1:	50                   	push   %eax
  8018e2:	e8 f6 f1 ff ff       	call   800add <file_get_block>
  8018e7:	83 c4 10             	add    $0x10,%esp
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	0f 88 b5 01 00 00    	js     801aa7 <fs_test+0x3ca>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  8018f2:	83 ec 08             	sub    $0x8,%esp
  8018f5:	68 00 43 80 00       	push   $0x804300
  8018fa:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fd:	e8 53 09 00 00       	call   802255 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801905:	c1 e8 0c             	shr    $0xc,%eax
  801908:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	a8 40                	test   $0x40,%al
  801914:	0f 84 9f 01 00 00    	je     801ab9 <fs_test+0x3dc>
	file_flush(f);
  80191a:	83 ec 0c             	sub    $0xc,%esp
  80191d:	ff 75 f4             	pushl  -0xc(%ebp)
  801920:	e8 be f6 ff ff       	call   800fe3 <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801928:	c1 e8 0c             	shr    $0xc,%eax
  80192b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	a8 40                	test   $0x40,%al
  801937:	0f 85 92 01 00 00    	jne    801acf <fs_test+0x3f2>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801940:	c1 e8 0c             	shr    $0xc,%eax
  801943:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80194a:	a8 40                	test   $0x40,%al
  80194c:	0f 85 93 01 00 00    	jne    801ae5 <fs_test+0x408>
	cprintf("file rewrite is good\n");
  801952:	83 ec 0c             	sub    $0xc,%esp
  801955:	68 a7 42 80 00       	push   $0x8042a7
  80195a:	e8 d7 02 00 00       	call   801c36 <cprintf>
}
  80195f:	83 c4 10             	add    $0x10,%esp
  801962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801965:	c9                   	leave  
  801966:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  801967:	50                   	push   %eax
  801968:	68 18 41 80 00       	push   $0x804118
  80196d:	6a 12                	push   $0x12
  80196f:	68 2b 41 80 00       	push   $0x80412b
  801974:	e8 e2 01 00 00       	call   801b5b <_panic>
		panic("alloc_block: %e", r);
  801979:	50                   	push   %eax
  80197a:	68 35 41 80 00       	push   $0x804135
  80197f:	6a 17                	push   $0x17
  801981:	68 2b 41 80 00       	push   $0x80412b
  801986:	e8 d0 01 00 00       	call   801b5b <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  80198b:	68 45 41 80 00       	push   $0x804145
  801990:	68 bd 3d 80 00       	push   $0x803dbd
  801995:	6a 19                	push   $0x19
  801997:	68 2b 41 80 00       	push   $0x80412b
  80199c:	e8 ba 01 00 00       	call   801b5b <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8019a1:	68 c0 42 80 00       	push   $0x8042c0
  8019a6:	68 bd 3d 80 00       	push   $0x803dbd
  8019ab:	6a 1b                	push   $0x1b
  8019ad:	68 2b 41 80 00       	push   $0x80412b
  8019b2:	e8 a4 01 00 00       	call   801b5b <_panic>
		panic("file_open /not-found: %e", r);
  8019b7:	50                   	push   %eax
  8019b8:	68 80 41 80 00       	push   $0x804180
  8019bd:	6a 1f                	push   $0x1f
  8019bf:	68 2b 41 80 00       	push   $0x80412b
  8019c4:	e8 92 01 00 00       	call   801b5b <_panic>
		panic("file_open /not-found succeeded!");
  8019c9:	83 ec 04             	sub    $0x4,%esp
  8019cc:	68 e0 42 80 00       	push   $0x8042e0
  8019d1:	6a 21                	push   $0x21
  8019d3:	68 2b 41 80 00       	push   $0x80412b
  8019d8:	e8 7e 01 00 00       	call   801b5b <_panic>
		panic("file_open /newmotd: %e", r);
  8019dd:	50                   	push   %eax
  8019de:	68 a2 41 80 00       	push   $0x8041a2
  8019e3:	6a 23                	push   $0x23
  8019e5:	68 2b 41 80 00       	push   $0x80412b
  8019ea:	e8 6c 01 00 00       	call   801b5b <_panic>
		panic("file_get_block: %e", r);
  8019ef:	50                   	push   %eax
  8019f0:	68 cc 41 80 00       	push   $0x8041cc
  8019f5:	6a 27                	push   $0x27
  8019f7:	68 2b 41 80 00       	push   $0x80412b
  8019fc:	e8 5a 01 00 00       	call   801b5b <_panic>
		panic("file_get_block returned wrong data");
  801a01:	83 ec 04             	sub    $0x4,%esp
  801a04:	68 28 43 80 00       	push   $0x804328
  801a09:	6a 29                	push   $0x29
  801a0b:	68 2b 41 80 00       	push   $0x80412b
  801a10:	e8 46 01 00 00       	call   801b5b <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801a15:	68 f8 41 80 00       	push   $0x8041f8
  801a1a:	68 bd 3d 80 00       	push   $0x803dbd
  801a1f:	6a 2d                	push   $0x2d
  801a21:	68 2b 41 80 00       	push   $0x80412b
  801a26:	e8 30 01 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801a2b:	68 f7 41 80 00       	push   $0x8041f7
  801a30:	68 bd 3d 80 00       	push   $0x803dbd
  801a35:	6a 2f                	push   $0x2f
  801a37:	68 2b 41 80 00       	push   $0x80412b
  801a3c:	e8 1a 01 00 00       	call   801b5b <_panic>
		panic("file_set_size: %e", r);
  801a41:	50                   	push   %eax
  801a42:	68 27 42 80 00       	push   $0x804227
  801a47:	6a 33                	push   $0x33
  801a49:	68 2b 41 80 00       	push   $0x80412b
  801a4e:	e8 08 01 00 00       	call   801b5b <_panic>
	assert(f->f_direct[0] == 0);
  801a53:	68 39 42 80 00       	push   $0x804239
  801a58:	68 bd 3d 80 00       	push   $0x803dbd
  801a5d:	6a 34                	push   $0x34
  801a5f:	68 2b 41 80 00       	push   $0x80412b
  801a64:	e8 f2 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a69:	68 4d 42 80 00       	push   $0x80424d
  801a6e:	68 bd 3d 80 00       	push   $0x803dbd
  801a73:	6a 35                	push   $0x35
  801a75:	68 2b 41 80 00       	push   $0x80412b
  801a7a:	e8 dc 00 00 00       	call   801b5b <_panic>
		panic("file_set_size 2: %e", r);
  801a7f:	50                   	push   %eax
  801a80:	68 7e 42 80 00       	push   $0x80427e
  801a85:	6a 39                	push   $0x39
  801a87:	68 2b 41 80 00       	push   $0x80412b
  801a8c:	e8 ca 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801a91:	68 4d 42 80 00       	push   $0x80424d
  801a96:	68 bd 3d 80 00       	push   $0x803dbd
  801a9b:	6a 3a                	push   $0x3a
  801a9d:	68 2b 41 80 00       	push   $0x80412b
  801aa2:	e8 b4 00 00 00       	call   801b5b <_panic>
		panic("file_get_block 2: %e", r);
  801aa7:	50                   	push   %eax
  801aa8:	68 92 42 80 00       	push   $0x804292
  801aad:	6a 3c                	push   $0x3c
  801aaf:	68 2b 41 80 00       	push   $0x80412b
  801ab4:	e8 a2 00 00 00       	call   801b5b <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801ab9:	68 f8 41 80 00       	push   $0x8041f8
  801abe:	68 bd 3d 80 00       	push   $0x803dbd
  801ac3:	6a 3e                	push   $0x3e
  801ac5:	68 2b 41 80 00       	push   $0x80412b
  801aca:	e8 8c 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801acf:	68 f7 41 80 00       	push   $0x8041f7
  801ad4:	68 bd 3d 80 00       	push   $0x803dbd
  801ad9:	6a 40                	push   $0x40
  801adb:	68 2b 41 80 00       	push   $0x80412b
  801ae0:	e8 76 00 00 00       	call   801b5b <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801ae5:	68 4d 42 80 00       	push   $0x80424d
  801aea:	68 bd 3d 80 00       	push   $0x803dbd
  801aef:	6a 41                	push   $0x41
  801af1:	68 2b 41 80 00       	push   $0x80412b
  801af6:	e8 60 00 00 00       	call   801b5b <_panic>

00801afb <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b03:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801b06:	e8 05 0b 00 00       	call   802610 <sys_getenvid>
  801b0b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b10:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b13:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b18:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b1d:	85 db                	test   %ebx,%ebx
  801b1f:	7e 07                	jle    801b28 <libmain+0x2d>
		binaryname = argv[0];
  801b21:	8b 06                	mov    (%esi),%eax
  801b23:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801b28:	83 ec 08             	sub    $0x8,%esp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
  801b2d:	e8 6a fb ff ff       	call   80169c <umain>

	// exit gracefully
	exit();
  801b32:	e8 0a 00 00 00       	call   801b41 <exit>
}
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    

00801b41 <exit>:

#include <inc/lib.h>

void exit(void)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
  801b44:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801b47:	e8 67 10 00 00       	call   802bb3 <close_all>
	sys_env_destroy(0);
  801b4c:	83 ec 0c             	sub    $0xc,%esp
  801b4f:	6a 00                	push   $0x0
  801b51:	e8 79 0a 00 00       	call   8025cf <sys_env_destroy>
}
  801b56:	83 c4 10             	add    $0x10,%esp
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801b60:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801b63:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801b69:	e8 a2 0a 00 00       	call   802610 <sys_getenvid>
  801b6e:	83 ec 0c             	sub    $0xc,%esp
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	56                   	push   %esi
  801b78:	50                   	push   %eax
  801b79:	68 58 43 80 00       	push   $0x804358
  801b7e:	e8 b3 00 00 00       	call   801c36 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801b83:	83 c4 18             	add    $0x18,%esp
  801b86:	53                   	push   %ebx
  801b87:	ff 75 10             	pushl  0x10(%ebp)
  801b8a:	e8 56 00 00 00       	call   801be5 <vcprintf>
	cprintf("\n");
  801b8f:	c7 04 24 65 3f 80 00 	movl   $0x803f65,(%esp)
  801b96:	e8 9b 00 00 00       	call   801c36 <cprintf>
  801b9b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b9e:	cc                   	int3   
  801b9f:	eb fd                	jmp    801b9e <_panic+0x43>

00801ba1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801bab:	8b 13                	mov    (%ebx),%edx
  801bad:	8d 42 01             	lea    0x1(%edx),%eax
  801bb0:	89 03                	mov    %eax,(%ebx)
  801bb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801bb9:	3d ff 00 00 00       	cmp    $0xff,%eax
  801bbe:	74 09                	je     801bc9 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801bc0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801bc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	68 ff 00 00 00       	push   $0xff
  801bd1:	8d 43 08             	lea    0x8(%ebx),%eax
  801bd4:	50                   	push   %eax
  801bd5:	e8 b8 09 00 00       	call   802592 <sys_cputs>
		b->idx = 0;
  801bda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	eb db                	jmp    801bc0 <putch+0x1f>

00801be5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801bee:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bf5:	00 00 00 
	b.cnt = 0;
  801bf8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801bff:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801c0e:	50                   	push   %eax
  801c0f:	68 a1 1b 80 00       	push   $0x801ba1
  801c14:	e8 1a 01 00 00       	call   801d33 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801c19:	83 c4 08             	add    $0x8,%esp
  801c1c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801c22:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801c28:	50                   	push   %eax
  801c29:	e8 64 09 00 00       	call   802592 <sys_cputs>

	return b.cnt;
}
  801c2e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c3c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801c3f:	50                   	push   %eax
  801c40:	ff 75 08             	pushl  0x8(%ebp)
  801c43:	e8 9d ff ff ff       	call   801be5 <vcprintf>
	va_end(ap);

	return cnt;
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	57                   	push   %edi
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 1c             	sub    $0x1c,%esp
  801c53:	89 c7                	mov    %eax,%edi
  801c55:	89 d6                	mov    %edx,%esi
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801c60:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801c63:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c66:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c6b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c6e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801c71:	39 d3                	cmp    %edx,%ebx
  801c73:	72 05                	jb     801c7a <printnum+0x30>
  801c75:	39 45 10             	cmp    %eax,0x10(%ebp)
  801c78:	77 7a                	ja     801cf4 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801c7a:	83 ec 0c             	sub    $0xc,%esp
  801c7d:	ff 75 18             	pushl  0x18(%ebp)
  801c80:	8b 45 14             	mov    0x14(%ebp),%eax
  801c83:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801c86:	53                   	push   %ebx
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	83 ec 08             	sub    $0x8,%esp
  801c8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c90:	ff 75 e0             	pushl  -0x20(%ebp)
  801c93:	ff 75 dc             	pushl  -0x24(%ebp)
  801c96:	ff 75 d8             	pushl  -0x28(%ebp)
  801c99:	e8 a2 1e 00 00       	call   803b40 <__udivdi3>
  801c9e:	83 c4 18             	add    $0x18,%esp
  801ca1:	52                   	push   %edx
  801ca2:	50                   	push   %eax
  801ca3:	89 f2                	mov    %esi,%edx
  801ca5:	89 f8                	mov    %edi,%eax
  801ca7:	e8 9e ff ff ff       	call   801c4a <printnum>
  801cac:	83 c4 20             	add    $0x20,%esp
  801caf:	eb 13                	jmp    801cc4 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801cb1:	83 ec 08             	sub    $0x8,%esp
  801cb4:	56                   	push   %esi
  801cb5:	ff 75 18             	pushl  0x18(%ebp)
  801cb8:	ff d7                	call   *%edi
  801cba:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801cbd:	83 eb 01             	sub    $0x1,%ebx
  801cc0:	85 db                	test   %ebx,%ebx
  801cc2:	7f ed                	jg     801cb1 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	56                   	push   %esi
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cce:	ff 75 e0             	pushl  -0x20(%ebp)
  801cd1:	ff 75 dc             	pushl  -0x24(%ebp)
  801cd4:	ff 75 d8             	pushl  -0x28(%ebp)
  801cd7:	e8 84 1f 00 00       	call   803c60 <__umoddi3>
  801cdc:	83 c4 14             	add    $0x14,%esp
  801cdf:	0f be 80 7b 43 80 00 	movsbl 0x80437b(%eax),%eax
  801ce6:	50                   	push   %eax
  801ce7:	ff d7                	call   *%edi
}
  801ce9:	83 c4 10             	add    $0x10,%esp
  801cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf7:	eb c4                	jmp    801cbd <printnum+0x73>

00801cf9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801cff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801d03:	8b 10                	mov    (%eax),%edx
  801d05:	3b 50 04             	cmp    0x4(%eax),%edx
  801d08:	73 0a                	jae    801d14 <sprintputch+0x1b>
		*b->buf++ = ch;
  801d0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d0d:	89 08                	mov    %ecx,(%eax)
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	88 02                	mov    %al,(%edx)
}
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <printfmt>:
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801d1c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801d1f:	50                   	push   %eax
  801d20:	ff 75 10             	pushl  0x10(%ebp)
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 05 00 00 00       	call   801d33 <vprintfmt>
}
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <vprintfmt>:
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	57                   	push   %edi
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 2c             	sub    $0x2c,%esp
  801d3c:	8b 75 08             	mov    0x8(%ebp),%esi
  801d3f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801d42:	8b 7d 10             	mov    0x10(%ebp),%edi
  801d45:	e9 c1 03 00 00       	jmp    80210b <vprintfmt+0x3d8>
		padc = ' ';
  801d4a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  801d4e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  801d55:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  801d5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801d63:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801d68:	8d 47 01             	lea    0x1(%edi),%eax
  801d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d6e:	0f b6 17             	movzbl (%edi),%edx
  801d71:	8d 42 dd             	lea    -0x23(%edx),%eax
  801d74:	3c 55                	cmp    $0x55,%al
  801d76:	0f 87 12 04 00 00    	ja     80218e <vprintfmt+0x45b>
  801d7c:	0f b6 c0             	movzbl %al,%eax
  801d7f:	ff 24 85 c0 44 80 00 	jmp    *0x8044c0(,%eax,4)
  801d86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801d89:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801d8d:	eb d9                	jmp    801d68 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801d92:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801d96:	eb d0                	jmp    801d68 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801d98:	0f b6 d2             	movzbl %dl,%edx
  801d9b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801da3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801da6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801da9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  801dad:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801db0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801db3:	83 f9 09             	cmp    $0x9,%ecx
  801db6:	77 55                	ja     801e0d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  801db8:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  801dbb:	eb e9                	jmp    801da6 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  801dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801dc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc8:	8d 40 04             	lea    0x4(%eax),%eax
  801dcb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801dce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801dd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dd5:	79 91                	jns    801d68 <vprintfmt+0x35>
				width = precision, precision = -1;
  801dd7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801dda:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ddd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801de4:	eb 82                	jmp    801d68 <vprintfmt+0x35>
  801de6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de9:	85 c0                	test   %eax,%eax
  801deb:	ba 00 00 00 00       	mov    $0x0,%edx
  801df0:	0f 49 d0             	cmovns %eax,%edx
  801df3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801df6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801df9:	e9 6a ff ff ff       	jmp    801d68 <vprintfmt+0x35>
  801dfe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801e01:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801e08:	e9 5b ff ff ff       	jmp    801d68 <vprintfmt+0x35>
  801e0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801e10:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e13:	eb bc                	jmp    801dd1 <vprintfmt+0x9e>
			lflag++;
  801e15:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801e18:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801e1b:	e9 48 ff ff ff       	jmp    801d68 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801e20:	8b 45 14             	mov    0x14(%ebp),%eax
  801e23:	8d 78 04             	lea    0x4(%eax),%edi
  801e26:	83 ec 08             	sub    $0x8,%esp
  801e29:	53                   	push   %ebx
  801e2a:	ff 30                	pushl  (%eax)
  801e2c:	ff d6                	call   *%esi
			break;
  801e2e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801e31:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801e34:	e9 cf 02 00 00       	jmp    802108 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  801e39:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3c:	8d 78 04             	lea    0x4(%eax),%edi
  801e3f:	8b 00                	mov    (%eax),%eax
  801e41:	99                   	cltd   
  801e42:	31 d0                	xor    %edx,%eax
  801e44:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801e46:	83 f8 0f             	cmp    $0xf,%eax
  801e49:	7f 23                	jg     801e6e <vprintfmt+0x13b>
  801e4b:	8b 14 85 20 46 80 00 	mov    0x804620(,%eax,4),%edx
  801e52:	85 d2                	test   %edx,%edx
  801e54:	74 18                	je     801e6e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  801e56:	52                   	push   %edx
  801e57:	68 cf 3d 80 00       	push   $0x803dcf
  801e5c:	53                   	push   %ebx
  801e5d:	56                   	push   %esi
  801e5e:	e8 b3 fe ff ff       	call   801d16 <printfmt>
  801e63:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e66:	89 7d 14             	mov    %edi,0x14(%ebp)
  801e69:	e9 9a 02 00 00       	jmp    802108 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  801e6e:	50                   	push   %eax
  801e6f:	68 93 43 80 00       	push   $0x804393
  801e74:	53                   	push   %ebx
  801e75:	56                   	push   %esi
  801e76:	e8 9b fe ff ff       	call   801d16 <printfmt>
  801e7b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801e7e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801e81:	e9 82 02 00 00       	jmp    802108 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  801e86:	8b 45 14             	mov    0x14(%ebp),%eax
  801e89:	83 c0 04             	add    $0x4,%eax
  801e8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e92:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  801e94:	85 ff                	test   %edi,%edi
  801e96:	b8 8c 43 80 00       	mov    $0x80438c,%eax
  801e9b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  801e9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ea2:	0f 8e bd 00 00 00    	jle    801f65 <vprintfmt+0x232>
  801ea8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801eac:	75 0e                	jne    801ebc <vprintfmt+0x189>
  801eae:	89 75 08             	mov    %esi,0x8(%ebp)
  801eb1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801eb4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801eb7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801eba:	eb 6d                	jmp    801f29 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  801ebc:	83 ec 08             	sub    $0x8,%esp
  801ebf:	ff 75 d0             	pushl  -0x30(%ebp)
  801ec2:	57                   	push   %edi
  801ec3:	e8 6e 03 00 00       	call   802236 <strnlen>
  801ec8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801ecb:	29 c1                	sub    %eax,%ecx
  801ecd:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801ed0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801ed3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801ed7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801eda:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801edd:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801edf:	eb 0f                	jmp    801ef0 <vprintfmt+0x1bd>
					putch(padc, putdat);
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	53                   	push   %ebx
  801ee5:	ff 75 e0             	pushl  -0x20(%ebp)
  801ee8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801eea:	83 ef 01             	sub    $0x1,%edi
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	85 ff                	test   %edi,%edi
  801ef2:	7f ed                	jg     801ee1 <vprintfmt+0x1ae>
  801ef4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801ef7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801efa:	85 c9                	test   %ecx,%ecx
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
  801f01:	0f 49 c1             	cmovns %ecx,%eax
  801f04:	29 c1                	sub    %eax,%ecx
  801f06:	89 75 08             	mov    %esi,0x8(%ebp)
  801f09:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f0c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f0f:	89 cb                	mov    %ecx,%ebx
  801f11:	eb 16                	jmp    801f29 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  801f13:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801f17:	75 31                	jne    801f4a <vprintfmt+0x217>
					putch(ch, putdat);
  801f19:	83 ec 08             	sub    $0x8,%esp
  801f1c:	ff 75 0c             	pushl  0xc(%ebp)
  801f1f:	50                   	push   %eax
  801f20:	ff 55 08             	call   *0x8(%ebp)
  801f23:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f26:	83 eb 01             	sub    $0x1,%ebx
  801f29:	83 c7 01             	add    $0x1,%edi
  801f2c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  801f30:	0f be c2             	movsbl %dl,%eax
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 59                	je     801f90 <vprintfmt+0x25d>
  801f37:	85 f6                	test   %esi,%esi
  801f39:	78 d8                	js     801f13 <vprintfmt+0x1e0>
  801f3b:	83 ee 01             	sub    $0x1,%esi
  801f3e:	79 d3                	jns    801f13 <vprintfmt+0x1e0>
  801f40:	89 df                	mov    %ebx,%edi
  801f42:	8b 75 08             	mov    0x8(%ebp),%esi
  801f45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f48:	eb 37                	jmp    801f81 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  801f4a:	0f be d2             	movsbl %dl,%edx
  801f4d:	83 ea 20             	sub    $0x20,%edx
  801f50:	83 fa 5e             	cmp    $0x5e,%edx
  801f53:	76 c4                	jbe    801f19 <vprintfmt+0x1e6>
					putch('?', putdat);
  801f55:	83 ec 08             	sub    $0x8,%esp
  801f58:	ff 75 0c             	pushl  0xc(%ebp)
  801f5b:	6a 3f                	push   $0x3f
  801f5d:	ff 55 08             	call   *0x8(%ebp)
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	eb c1                	jmp    801f26 <vprintfmt+0x1f3>
  801f65:	89 75 08             	mov    %esi,0x8(%ebp)
  801f68:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801f6b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801f6e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801f71:	eb b6                	jmp    801f29 <vprintfmt+0x1f6>
				putch(' ', putdat);
  801f73:	83 ec 08             	sub    $0x8,%esp
  801f76:	53                   	push   %ebx
  801f77:	6a 20                	push   $0x20
  801f79:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801f7b:	83 ef 01             	sub    $0x1,%edi
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 ff                	test   %edi,%edi
  801f83:	7f ee                	jg     801f73 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  801f85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f88:	89 45 14             	mov    %eax,0x14(%ebp)
  801f8b:	e9 78 01 00 00       	jmp    802108 <vprintfmt+0x3d5>
  801f90:	89 df                	mov    %ebx,%edi
  801f92:	8b 75 08             	mov    0x8(%ebp),%esi
  801f95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f98:	eb e7                	jmp    801f81 <vprintfmt+0x24e>
	if (lflag >= 2)
  801f9a:	83 f9 01             	cmp    $0x1,%ecx
  801f9d:	7e 3f                	jle    801fde <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  801f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa2:	8b 50 04             	mov    0x4(%eax),%edx
  801fa5:	8b 00                	mov    (%eax),%eax
  801fa7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801faa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801fad:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb0:	8d 40 08             	lea    0x8(%eax),%eax
  801fb3:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  801fb6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fba:	79 5c                	jns    802018 <vprintfmt+0x2e5>
				putch('-', putdat);
  801fbc:	83 ec 08             	sub    $0x8,%esp
  801fbf:	53                   	push   %ebx
  801fc0:	6a 2d                	push   $0x2d
  801fc2:	ff d6                	call   *%esi
				num = -(long long) num;
  801fc4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fc7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801fca:	f7 da                	neg    %edx
  801fcc:	83 d1 00             	adc    $0x0,%ecx
  801fcf:	f7 d9                	neg    %ecx
  801fd1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801fd4:	b8 0a 00 00 00       	mov    $0xa,%eax
  801fd9:	e9 10 01 00 00       	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  801fde:	85 c9                	test   %ecx,%ecx
  801fe0:	75 1b                	jne    801ffd <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  801fe2:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe5:	8b 00                	mov    (%eax),%eax
  801fe7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801fea:	89 c1                	mov    %eax,%ecx
  801fec:	c1 f9 1f             	sar    $0x1f,%ecx
  801fef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff5:	8d 40 04             	lea    0x4(%eax),%eax
  801ff8:	89 45 14             	mov    %eax,0x14(%ebp)
  801ffb:	eb b9                	jmp    801fb6 <vprintfmt+0x283>
		return va_arg(*ap, long);
  801ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  802000:	8b 00                	mov    (%eax),%eax
  802002:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802005:	89 c1                	mov    %eax,%ecx
  802007:	c1 f9 1f             	sar    $0x1f,%ecx
  80200a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80200d:	8b 45 14             	mov    0x14(%ebp),%eax
  802010:	8d 40 04             	lea    0x4(%eax),%eax
  802013:	89 45 14             	mov    %eax,0x14(%ebp)
  802016:	eb 9e                	jmp    801fb6 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  802018:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80201b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80201e:	b8 0a 00 00 00       	mov    $0xa,%eax
  802023:	e9 c6 00 00 00       	jmp    8020ee <vprintfmt+0x3bb>
	if (lflag >= 2)
  802028:	83 f9 01             	cmp    $0x1,%ecx
  80202b:	7e 18                	jle    802045 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80202d:	8b 45 14             	mov    0x14(%ebp),%eax
  802030:	8b 10                	mov    (%eax),%edx
  802032:	8b 48 04             	mov    0x4(%eax),%ecx
  802035:	8d 40 08             	lea    0x8(%eax),%eax
  802038:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80203b:	b8 0a 00 00 00       	mov    $0xa,%eax
  802040:	e9 a9 00 00 00       	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  802045:	85 c9                	test   %ecx,%ecx
  802047:	75 1a                	jne    802063 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  802049:	8b 45 14             	mov    0x14(%ebp),%eax
  80204c:	8b 10                	mov    (%eax),%edx
  80204e:	b9 00 00 00 00       	mov    $0x0,%ecx
  802053:	8d 40 04             	lea    0x4(%eax),%eax
  802056:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802059:	b8 0a 00 00 00       	mov    $0xa,%eax
  80205e:	e9 8b 00 00 00       	jmp    8020ee <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  802063:	8b 45 14             	mov    0x14(%ebp),%eax
  802066:	8b 10                	mov    (%eax),%edx
  802068:	b9 00 00 00 00       	mov    $0x0,%ecx
  80206d:	8d 40 04             	lea    0x4(%eax),%eax
  802070:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  802073:	b8 0a 00 00 00       	mov    $0xa,%eax
  802078:	eb 74                	jmp    8020ee <vprintfmt+0x3bb>
	if (lflag >= 2)
  80207a:	83 f9 01             	cmp    $0x1,%ecx
  80207d:	7e 15                	jle    802094 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80207f:	8b 45 14             	mov    0x14(%ebp),%eax
  802082:	8b 10                	mov    (%eax),%edx
  802084:	8b 48 04             	mov    0x4(%eax),%ecx
  802087:	8d 40 08             	lea    0x8(%eax),%eax
  80208a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80208d:	b8 08 00 00 00       	mov    $0x8,%eax
  802092:	eb 5a                	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  802094:	85 c9                	test   %ecx,%ecx
  802096:	75 17                	jne    8020af <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  802098:	8b 45 14             	mov    0x14(%ebp),%eax
  80209b:	8b 10                	mov    (%eax),%edx
  80209d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a2:	8d 40 04             	lea    0x4(%eax),%eax
  8020a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8020a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8020ad:	eb 3f                	jmp    8020ee <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8020af:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b2:	8b 10                	mov    (%eax),%edx
  8020b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b9:	8d 40 04             	lea    0x4(%eax),%eax
  8020bc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8020bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8020c4:	eb 28                	jmp    8020ee <vprintfmt+0x3bb>
			putch('0', putdat);
  8020c6:	83 ec 08             	sub    $0x8,%esp
  8020c9:	53                   	push   %ebx
  8020ca:	6a 30                	push   $0x30
  8020cc:	ff d6                	call   *%esi
			putch('x', putdat);
  8020ce:	83 c4 08             	add    $0x8,%esp
  8020d1:	53                   	push   %ebx
  8020d2:	6a 78                	push   $0x78
  8020d4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8020d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d9:	8b 10                	mov    (%eax),%edx
  8020db:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8020e0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8020e3:	8d 40 04             	lea    0x4(%eax),%eax
  8020e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8020e9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8020f5:	57                   	push   %edi
  8020f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8020f9:	50                   	push   %eax
  8020fa:	51                   	push   %ecx
  8020fb:	52                   	push   %edx
  8020fc:	89 da                	mov    %ebx,%edx
  8020fe:	89 f0                	mov    %esi,%eax
  802100:	e8 45 fb ff ff       	call   801c4a <printnum>
			break;
  802105:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  802108:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80210b:	83 c7 01             	add    $0x1,%edi
  80210e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  802112:	83 f8 25             	cmp    $0x25,%eax
  802115:	0f 84 2f fc ff ff    	je     801d4a <vprintfmt+0x17>
			if (ch == '\0')
  80211b:	85 c0                	test   %eax,%eax
  80211d:	0f 84 8b 00 00 00    	je     8021ae <vprintfmt+0x47b>
			putch(ch, putdat);
  802123:	83 ec 08             	sub    $0x8,%esp
  802126:	53                   	push   %ebx
  802127:	50                   	push   %eax
  802128:	ff d6                	call   *%esi
  80212a:	83 c4 10             	add    $0x10,%esp
  80212d:	eb dc                	jmp    80210b <vprintfmt+0x3d8>
	if (lflag >= 2)
  80212f:	83 f9 01             	cmp    $0x1,%ecx
  802132:	7e 15                	jle    802149 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  802134:	8b 45 14             	mov    0x14(%ebp),%eax
  802137:	8b 10                	mov    (%eax),%edx
  802139:	8b 48 04             	mov    0x4(%eax),%ecx
  80213c:	8d 40 08             	lea    0x8(%eax),%eax
  80213f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802142:	b8 10 00 00 00       	mov    $0x10,%eax
  802147:	eb a5                	jmp    8020ee <vprintfmt+0x3bb>
	else if (lflag)
  802149:	85 c9                	test   %ecx,%ecx
  80214b:	75 17                	jne    802164 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80214d:	8b 45 14             	mov    0x14(%ebp),%eax
  802150:	8b 10                	mov    (%eax),%edx
  802152:	b9 00 00 00 00       	mov    $0x0,%ecx
  802157:	8d 40 04             	lea    0x4(%eax),%eax
  80215a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80215d:	b8 10 00 00 00       	mov    $0x10,%eax
  802162:	eb 8a                	jmp    8020ee <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  802164:	8b 45 14             	mov    0x14(%ebp),%eax
  802167:	8b 10                	mov    (%eax),%edx
  802169:	b9 00 00 00 00       	mov    $0x0,%ecx
  80216e:	8d 40 04             	lea    0x4(%eax),%eax
  802171:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  802174:	b8 10 00 00 00       	mov    $0x10,%eax
  802179:	e9 70 ff ff ff       	jmp    8020ee <vprintfmt+0x3bb>
			putch(ch, putdat);
  80217e:	83 ec 08             	sub    $0x8,%esp
  802181:	53                   	push   %ebx
  802182:	6a 25                	push   $0x25
  802184:	ff d6                	call   *%esi
			break;
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	e9 7a ff ff ff       	jmp    802108 <vprintfmt+0x3d5>
			putch('%', putdat);
  80218e:	83 ec 08             	sub    $0x8,%esp
  802191:	53                   	push   %ebx
  802192:	6a 25                	push   $0x25
  802194:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	89 f8                	mov    %edi,%eax
  80219b:	eb 03                	jmp    8021a0 <vprintfmt+0x46d>
  80219d:	83 e8 01             	sub    $0x1,%eax
  8021a0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8021a4:	75 f7                	jne    80219d <vprintfmt+0x46a>
  8021a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021a9:	e9 5a ff ff ff       	jmp    802108 <vprintfmt+0x3d5>
}
  8021ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    

008021b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 18             	sub    $0x18,%esp
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8021c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8021c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8021cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 26                	je     8021fd <vsnprintf+0x47>
  8021d7:	85 d2                	test   %edx,%edx
  8021d9:	7e 22                	jle    8021fd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8021db:	ff 75 14             	pushl  0x14(%ebp)
  8021de:	ff 75 10             	pushl  0x10(%ebp)
  8021e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8021e4:	50                   	push   %eax
  8021e5:	68 f9 1c 80 00       	push   $0x801cf9
  8021ea:	e8 44 fb ff ff       	call   801d33 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8021ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	83 c4 10             	add    $0x10,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    
		return -E_INVAL;
  8021fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802202:	eb f7                	jmp    8021fb <vsnprintf+0x45>

00802204 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80220a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80220d:	50                   	push   %eax
  80220e:	ff 75 10             	pushl  0x10(%ebp)
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	ff 75 08             	pushl  0x8(%ebp)
  802217:	e8 9a ff ff ff       	call   8021b6 <vsnprintf>
	va_end(ap);

	return rc;
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
  802229:	eb 03                	jmp    80222e <strlen+0x10>
		n++;
  80222b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80222e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802232:	75 f7                	jne    80222b <strlen+0xd>
	return n;
}
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80223f:	b8 00 00 00 00       	mov    $0x0,%eax
  802244:	eb 03                	jmp    802249 <strnlen+0x13>
		n++;
  802246:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802249:	39 d0                	cmp    %edx,%eax
  80224b:	74 06                	je     802253 <strnlen+0x1d>
  80224d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  802251:	75 f3                	jne    802246 <strnlen+0x10>
	return n;
}
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	53                   	push   %ebx
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80225f:	89 c2                	mov    %eax,%edx
  802261:	83 c1 01             	add    $0x1,%ecx
  802264:	83 c2 01             	add    $0x1,%edx
  802267:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80226b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80226e:	84 db                	test   %bl,%bl
  802270:	75 ef                	jne    802261 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802272:	5b                   	pop    %ebx
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	53                   	push   %ebx
  802279:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80227c:	53                   	push   %ebx
  80227d:	e8 9c ff ff ff       	call   80221e <strlen>
  802282:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	01 d8                	add    %ebx,%eax
  80228a:	50                   	push   %eax
  80228b:	e8 c5 ff ff ff       	call   802255 <strcpy>
	return dst;
}
  802290:	89 d8                	mov    %ebx,%eax
  802292:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	56                   	push   %esi
  80229b:	53                   	push   %ebx
  80229c:	8b 75 08             	mov    0x8(%ebp),%esi
  80229f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022a2:	89 f3                	mov    %esi,%ebx
  8022a4:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8022a7:	89 f2                	mov    %esi,%edx
  8022a9:	eb 0f                	jmp    8022ba <strncpy+0x23>
		*dst++ = *src;
  8022ab:	83 c2 01             	add    $0x1,%edx
  8022ae:	0f b6 01             	movzbl (%ecx),%eax
  8022b1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8022b4:	80 39 01             	cmpb   $0x1,(%ecx)
  8022b7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8022ba:	39 da                	cmp    %ebx,%edx
  8022bc:	75 ed                	jne    8022ab <strncpy+0x14>
	}
	return ret;
}
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	5b                   	pop    %ebx
  8022c1:	5e                   	pop    %esi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    

008022c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	56                   	push   %esi
  8022c8:	53                   	push   %ebx
  8022c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8022cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d2:	89 f0                	mov    %esi,%eax
  8022d4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8022d8:	85 c9                	test   %ecx,%ecx
  8022da:	75 0b                	jne    8022e7 <strlcpy+0x23>
  8022dc:	eb 17                	jmp    8022f5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8022de:	83 c2 01             	add    $0x1,%edx
  8022e1:	83 c0 01             	add    $0x1,%eax
  8022e4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8022e7:	39 d8                	cmp    %ebx,%eax
  8022e9:	74 07                	je     8022f2 <strlcpy+0x2e>
  8022eb:	0f b6 0a             	movzbl (%edx),%ecx
  8022ee:	84 c9                	test   %cl,%cl
  8022f0:	75 ec                	jne    8022de <strlcpy+0x1a>
		*dst = '\0';
  8022f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8022f5:	29 f0                	sub    %esi,%eax
}
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802304:	eb 06                	jmp    80230c <strcmp+0x11>
		p++, q++;
  802306:	83 c1 01             	add    $0x1,%ecx
  802309:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80230c:	0f b6 01             	movzbl (%ecx),%eax
  80230f:	84 c0                	test   %al,%al
  802311:	74 04                	je     802317 <strcmp+0x1c>
  802313:	3a 02                	cmp    (%edx),%al
  802315:	74 ef                	je     802306 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802317:	0f b6 c0             	movzbl %al,%eax
  80231a:	0f b6 12             	movzbl (%edx),%edx
  80231d:	29 d0                	sub    %edx,%eax
}
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    

00802321 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	53                   	push   %ebx
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232b:	89 c3                	mov    %eax,%ebx
  80232d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802330:	eb 06                	jmp    802338 <strncmp+0x17>
		n--, p++, q++;
  802332:	83 c0 01             	add    $0x1,%eax
  802335:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  802338:	39 d8                	cmp    %ebx,%eax
  80233a:	74 16                	je     802352 <strncmp+0x31>
  80233c:	0f b6 08             	movzbl (%eax),%ecx
  80233f:	84 c9                	test   %cl,%cl
  802341:	74 04                	je     802347 <strncmp+0x26>
  802343:	3a 0a                	cmp    (%edx),%cl
  802345:	74 eb                	je     802332 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802347:	0f b6 00             	movzbl (%eax),%eax
  80234a:	0f b6 12             	movzbl (%edx),%edx
  80234d:	29 d0                	sub    %edx,%eax
}
  80234f:	5b                   	pop    %ebx
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    
		return 0;
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	eb f6                	jmp    80234f <strncmp+0x2e>

00802359 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802363:	0f b6 10             	movzbl (%eax),%edx
  802366:	84 d2                	test   %dl,%dl
  802368:	74 09                	je     802373 <strchr+0x1a>
		if (*s == c)
  80236a:	38 ca                	cmp    %cl,%dl
  80236c:	74 0a                	je     802378 <strchr+0x1f>
	for (; *s; s++)
  80236e:	83 c0 01             	add    $0x1,%eax
  802371:	eb f0                	jmp    802363 <strchr+0xa>
			return (char *) s;
	return 0;
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802378:	5d                   	pop    %ebp
  802379:	c3                   	ret    

0080237a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802384:	eb 03                	jmp    802389 <strfind+0xf>
  802386:	83 c0 01             	add    $0x1,%eax
  802389:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80238c:	38 ca                	cmp    %cl,%dl
  80238e:	74 04                	je     802394 <strfind+0x1a>
  802390:	84 d2                	test   %dl,%dl
  802392:	75 f2                	jne    802386 <strfind+0xc>
			break;
	return (char *) s;
}
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    

00802396 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	57                   	push   %edi
  80239a:	56                   	push   %esi
  80239b:	53                   	push   %ebx
  80239c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80239f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8023a2:	85 c9                	test   %ecx,%ecx
  8023a4:	74 13                	je     8023b9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8023a6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8023ac:	75 05                	jne    8023b3 <memset+0x1d>
  8023ae:	f6 c1 03             	test   $0x3,%cl
  8023b1:	74 0d                	je     8023c0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8023b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b6:	fc                   	cld    
  8023b7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8023b9:	89 f8                	mov    %edi,%eax
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5f                   	pop    %edi
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    
		c &= 0xFF;
  8023c0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8023c4:	89 d3                	mov    %edx,%ebx
  8023c6:	c1 e3 08             	shl    $0x8,%ebx
  8023c9:	89 d0                	mov    %edx,%eax
  8023cb:	c1 e0 18             	shl    $0x18,%eax
  8023ce:	89 d6                	mov    %edx,%esi
  8023d0:	c1 e6 10             	shl    $0x10,%esi
  8023d3:	09 f0                	or     %esi,%eax
  8023d5:	09 c2                	or     %eax,%edx
  8023d7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8023d9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8023dc:	89 d0                	mov    %edx,%eax
  8023de:	fc                   	cld    
  8023df:	f3 ab                	rep stos %eax,%es:(%edi)
  8023e1:	eb d6                	jmp    8023b9 <memset+0x23>

008023e3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8023e3:	55                   	push   %ebp
  8023e4:	89 e5                	mov    %esp,%ebp
  8023e6:	57                   	push   %edi
  8023e7:	56                   	push   %esi
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023f1:	39 c6                	cmp    %eax,%esi
  8023f3:	73 35                	jae    80242a <memmove+0x47>
  8023f5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8023f8:	39 c2                	cmp    %eax,%edx
  8023fa:	76 2e                	jbe    80242a <memmove+0x47>
		s += n;
		d += n;
  8023fc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8023ff:	89 d6                	mov    %edx,%esi
  802401:	09 fe                	or     %edi,%esi
  802403:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802409:	74 0c                	je     802417 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80240b:	83 ef 01             	sub    $0x1,%edi
  80240e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  802411:	fd                   	std    
  802412:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802414:	fc                   	cld    
  802415:	eb 21                	jmp    802438 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802417:	f6 c1 03             	test   $0x3,%cl
  80241a:	75 ef                	jne    80240b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80241c:	83 ef 04             	sub    $0x4,%edi
  80241f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802422:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  802425:	fd                   	std    
  802426:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802428:	eb ea                	jmp    802414 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80242a:	89 f2                	mov    %esi,%edx
  80242c:	09 c2                	or     %eax,%edx
  80242e:	f6 c2 03             	test   $0x3,%dl
  802431:	74 09                	je     80243c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802433:	89 c7                	mov    %eax,%edi
  802435:	fc                   	cld    
  802436:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802438:	5e                   	pop    %esi
  802439:	5f                   	pop    %edi
  80243a:	5d                   	pop    %ebp
  80243b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80243c:	f6 c1 03             	test   $0x3,%cl
  80243f:	75 f2                	jne    802433 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802441:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  802444:	89 c7                	mov    %eax,%edi
  802446:	fc                   	cld    
  802447:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802449:	eb ed                	jmp    802438 <memmove+0x55>

0080244b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80244e:	ff 75 10             	pushl  0x10(%ebp)
  802451:	ff 75 0c             	pushl  0xc(%ebp)
  802454:	ff 75 08             	pushl  0x8(%ebp)
  802457:	e8 87 ff ff ff       	call   8023e3 <memmove>
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	56                   	push   %esi
  802462:	53                   	push   %ebx
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	8b 55 0c             	mov    0xc(%ebp),%edx
  802469:	89 c6                	mov    %eax,%esi
  80246b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80246e:	39 f0                	cmp    %esi,%eax
  802470:	74 1c                	je     80248e <memcmp+0x30>
		if (*s1 != *s2)
  802472:	0f b6 08             	movzbl (%eax),%ecx
  802475:	0f b6 1a             	movzbl (%edx),%ebx
  802478:	38 d9                	cmp    %bl,%cl
  80247a:	75 08                	jne    802484 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80247c:	83 c0 01             	add    $0x1,%eax
  80247f:	83 c2 01             	add    $0x1,%edx
  802482:	eb ea                	jmp    80246e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802484:	0f b6 c1             	movzbl %cl,%eax
  802487:	0f b6 db             	movzbl %bl,%ebx
  80248a:	29 d8                	sub    %ebx,%eax
  80248c:	eb 05                	jmp    802493 <memcmp+0x35>
	}

	return 0;
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802493:	5b                   	pop    %ebx
  802494:	5e                   	pop    %esi
  802495:	5d                   	pop    %ebp
  802496:	c3                   	ret    

00802497 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8024a0:	89 c2                	mov    %eax,%edx
  8024a2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8024a5:	39 d0                	cmp    %edx,%eax
  8024a7:	73 09                	jae    8024b2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8024a9:	38 08                	cmp    %cl,(%eax)
  8024ab:	74 05                	je     8024b2 <memfind+0x1b>
	for (; s < ends; s++)
  8024ad:	83 c0 01             	add    $0x1,%eax
  8024b0:	eb f3                	jmp    8024a5 <memfind+0xe>
			break;
	return (void *) s;
}
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	57                   	push   %edi
  8024b8:	56                   	push   %esi
  8024b9:	53                   	push   %ebx
  8024ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024c0:	eb 03                	jmp    8024c5 <strtol+0x11>
		s++;
  8024c2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8024c5:	0f b6 01             	movzbl (%ecx),%eax
  8024c8:	3c 20                	cmp    $0x20,%al
  8024ca:	74 f6                	je     8024c2 <strtol+0xe>
  8024cc:	3c 09                	cmp    $0x9,%al
  8024ce:	74 f2                	je     8024c2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8024d0:	3c 2b                	cmp    $0x2b,%al
  8024d2:	74 2e                	je     802502 <strtol+0x4e>
	int neg = 0;
  8024d4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8024d9:	3c 2d                	cmp    $0x2d,%al
  8024db:	74 2f                	je     80250c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024dd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8024e3:	75 05                	jne    8024ea <strtol+0x36>
  8024e5:	80 39 30             	cmpb   $0x30,(%ecx)
  8024e8:	74 2c                	je     802516 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	75 0a                	jne    8024f8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8024ee:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  8024f3:	80 39 30             	cmpb   $0x30,(%ecx)
  8024f6:	74 28                	je     802520 <strtol+0x6c>
		base = 10;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802500:	eb 50                	jmp    802552 <strtol+0x9e>
		s++;
  802502:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  802505:	bf 00 00 00 00       	mov    $0x0,%edi
  80250a:	eb d1                	jmp    8024dd <strtol+0x29>
		s++, neg = 1;
  80250c:	83 c1 01             	add    $0x1,%ecx
  80250f:	bf 01 00 00 00       	mov    $0x1,%edi
  802514:	eb c7                	jmp    8024dd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802516:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80251a:	74 0e                	je     80252a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  80251c:	85 db                	test   %ebx,%ebx
  80251e:	75 d8                	jne    8024f8 <strtol+0x44>
		s++, base = 8;
  802520:	83 c1 01             	add    $0x1,%ecx
  802523:	bb 08 00 00 00       	mov    $0x8,%ebx
  802528:	eb ce                	jmp    8024f8 <strtol+0x44>
		s += 2, base = 16;
  80252a:	83 c1 02             	add    $0x2,%ecx
  80252d:	bb 10 00 00 00       	mov    $0x10,%ebx
  802532:	eb c4                	jmp    8024f8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  802534:	8d 72 9f             	lea    -0x61(%edx),%esi
  802537:	89 f3                	mov    %esi,%ebx
  802539:	80 fb 19             	cmp    $0x19,%bl
  80253c:	77 29                	ja     802567 <strtol+0xb3>
			dig = *s - 'a' + 10;
  80253e:	0f be d2             	movsbl %dl,%edx
  802541:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  802544:	3b 55 10             	cmp    0x10(%ebp),%edx
  802547:	7d 30                	jge    802579 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  802549:	83 c1 01             	add    $0x1,%ecx
  80254c:	0f af 45 10          	imul   0x10(%ebp),%eax
  802550:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802552:	0f b6 11             	movzbl (%ecx),%edx
  802555:	8d 72 d0             	lea    -0x30(%edx),%esi
  802558:	89 f3                	mov    %esi,%ebx
  80255a:	80 fb 09             	cmp    $0x9,%bl
  80255d:	77 d5                	ja     802534 <strtol+0x80>
			dig = *s - '0';
  80255f:	0f be d2             	movsbl %dl,%edx
  802562:	83 ea 30             	sub    $0x30,%edx
  802565:	eb dd                	jmp    802544 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  802567:	8d 72 bf             	lea    -0x41(%edx),%esi
  80256a:	89 f3                	mov    %esi,%ebx
  80256c:	80 fb 19             	cmp    $0x19,%bl
  80256f:	77 08                	ja     802579 <strtol+0xc5>
			dig = *s - 'A' + 10;
  802571:	0f be d2             	movsbl %dl,%edx
  802574:	83 ea 37             	sub    $0x37,%edx
  802577:	eb cb                	jmp    802544 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  802579:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80257d:	74 05                	je     802584 <strtol+0xd0>
		*endptr = (char *) s;
  80257f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802582:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802584:	89 c2                	mov    %eax,%edx
  802586:	f7 da                	neg    %edx
  802588:	85 ff                	test   %edi,%edi
  80258a:	0f 45 c2             	cmovne %edx,%eax
}
  80258d:	5b                   	pop    %ebx
  80258e:	5e                   	pop    %esi
  80258f:	5f                   	pop    %edi
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    

00802592 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	57                   	push   %edi
  802596:	56                   	push   %esi
  802597:	53                   	push   %ebx
	asm volatile("int %1\n"
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025a3:	89 c3                	mov    %eax,%ebx
  8025a5:	89 c7                	mov    %eax,%edi
  8025a7:	89 c6                	mov    %eax,%esi
  8025a9:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    

008025b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	57                   	push   %edi
  8025b4:	56                   	push   %esi
  8025b5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8025b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025bb:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c0:	89 d1                	mov    %edx,%ecx
  8025c2:	89 d3                	mov    %edx,%ebx
  8025c4:	89 d7                	mov    %edx,%edi
  8025c6:	89 d6                	mov    %edx,%esi
  8025c8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8025ca:	5b                   	pop    %ebx
  8025cb:	5e                   	pop    %esi
  8025cc:	5f                   	pop    %edi
  8025cd:	5d                   	pop    %ebp
  8025ce:	c3                   	ret    

008025cf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	57                   	push   %edi
  8025d3:	56                   	push   %esi
  8025d4:	53                   	push   %ebx
  8025d5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8025d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8025e5:	89 cb                	mov    %ecx,%ebx
  8025e7:	89 cf                	mov    %ecx,%edi
  8025e9:	89 ce                	mov    %ecx,%esi
  8025eb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	7f 08                	jg     8025f9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8025f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025f4:	5b                   	pop    %ebx
  8025f5:	5e                   	pop    %esi
  8025f6:	5f                   	pop    %edi
  8025f7:	5d                   	pop    %ebp
  8025f8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8025f9:	83 ec 0c             	sub    $0xc,%esp
  8025fc:	50                   	push   %eax
  8025fd:	6a 03                	push   $0x3
  8025ff:	68 7f 46 80 00       	push   $0x80467f
  802604:	6a 23                	push   $0x23
  802606:	68 9c 46 80 00       	push   $0x80469c
  80260b:	e8 4b f5 ff ff       	call   801b5b <_panic>

00802610 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	57                   	push   %edi
  802614:	56                   	push   %esi
  802615:	53                   	push   %ebx
	asm volatile("int %1\n"
  802616:	ba 00 00 00 00       	mov    $0x0,%edx
  80261b:	b8 02 00 00 00       	mov    $0x2,%eax
  802620:	89 d1                	mov    %edx,%ecx
  802622:	89 d3                	mov    %edx,%ebx
  802624:	89 d7                	mov    %edx,%edi
  802626:	89 d6                	mov    %edx,%esi
  802628:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80262a:	5b                   	pop    %ebx
  80262b:	5e                   	pop    %esi
  80262c:	5f                   	pop    %edi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    

0080262f <sys_yield>:

void
sys_yield(void)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	57                   	push   %edi
  802633:	56                   	push   %esi
  802634:	53                   	push   %ebx
	asm volatile("int %1\n"
  802635:	ba 00 00 00 00       	mov    $0x0,%edx
  80263a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80263f:	89 d1                	mov    %edx,%ecx
  802641:	89 d3                	mov    %edx,%ebx
  802643:	89 d7                	mov    %edx,%edi
  802645:	89 d6                	mov    %edx,%esi
  802647:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802649:	5b                   	pop    %ebx
  80264a:	5e                   	pop    %esi
  80264b:	5f                   	pop    %edi
  80264c:	5d                   	pop    %ebp
  80264d:	c3                   	ret    

0080264e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80264e:	55                   	push   %ebp
  80264f:	89 e5                	mov    %esp,%ebp
  802651:	57                   	push   %edi
  802652:	56                   	push   %esi
  802653:	53                   	push   %ebx
  802654:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802657:	be 00 00 00 00       	mov    $0x0,%esi
  80265c:	8b 55 08             	mov    0x8(%ebp),%edx
  80265f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802662:	b8 04 00 00 00       	mov    $0x4,%eax
  802667:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80266a:	89 f7                	mov    %esi,%edi
  80266c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80266e:	85 c0                	test   %eax,%eax
  802670:	7f 08                	jg     80267a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802672:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802675:	5b                   	pop    %ebx
  802676:	5e                   	pop    %esi
  802677:	5f                   	pop    %edi
  802678:	5d                   	pop    %ebp
  802679:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	50                   	push   %eax
  80267e:	6a 04                	push   $0x4
  802680:	68 7f 46 80 00       	push   $0x80467f
  802685:	6a 23                	push   $0x23
  802687:	68 9c 46 80 00       	push   $0x80469c
  80268c:	e8 ca f4 ff ff       	call   801b5b <_panic>

00802691 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	57                   	push   %edi
  802695:	56                   	push   %esi
  802696:	53                   	push   %ebx
  802697:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80269a:	8b 55 08             	mov    0x8(%ebp),%edx
  80269d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8026a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8026ab:	8b 75 18             	mov    0x18(%ebp),%esi
  8026ae:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	7f 08                	jg     8026bc <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8026b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026b7:	5b                   	pop    %ebx
  8026b8:	5e                   	pop    %esi
  8026b9:	5f                   	pop    %edi
  8026ba:	5d                   	pop    %ebp
  8026bb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	50                   	push   %eax
  8026c0:	6a 05                	push   $0x5
  8026c2:	68 7f 46 80 00       	push   $0x80467f
  8026c7:	6a 23                	push   $0x23
  8026c9:	68 9c 46 80 00       	push   $0x80469c
  8026ce:	e8 88 f4 ff ff       	call   801b5b <_panic>

008026d3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8026d3:	55                   	push   %ebp
  8026d4:	89 e5                	mov    %esp,%ebp
  8026d6:	57                   	push   %edi
  8026d7:	56                   	push   %esi
  8026d8:	53                   	push   %ebx
  8026d9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8026dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8026ec:	89 df                	mov    %ebx,%edi
  8026ee:	89 de                	mov    %ebx,%esi
  8026f0:	cd 30                	int    $0x30
	if(check && ret > 0)
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	7f 08                	jg     8026fe <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8026f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8026f9:	5b                   	pop    %ebx
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8026fe:	83 ec 0c             	sub    $0xc,%esp
  802701:	50                   	push   %eax
  802702:	6a 06                	push   $0x6
  802704:	68 7f 46 80 00       	push   $0x80467f
  802709:	6a 23                	push   $0x23
  80270b:	68 9c 46 80 00       	push   $0x80469c
  802710:	e8 46 f4 ff ff       	call   801b5b <_panic>

00802715 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	57                   	push   %edi
  802719:	56                   	push   %esi
  80271a:	53                   	push   %ebx
  80271b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80271e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802723:	8b 55 08             	mov    0x8(%ebp),%edx
  802726:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802729:	b8 08 00 00 00       	mov    $0x8,%eax
  80272e:	89 df                	mov    %ebx,%edi
  802730:	89 de                	mov    %ebx,%esi
  802732:	cd 30                	int    $0x30
	if(check && ret > 0)
  802734:	85 c0                	test   %eax,%eax
  802736:	7f 08                	jg     802740 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802738:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802740:	83 ec 0c             	sub    $0xc,%esp
  802743:	50                   	push   %eax
  802744:	6a 08                	push   $0x8
  802746:	68 7f 46 80 00       	push   $0x80467f
  80274b:	6a 23                	push   $0x23
  80274d:	68 9c 46 80 00       	push   $0x80469c
  802752:	e8 04 f4 ff ff       	call   801b5b <_panic>

00802757 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	57                   	push   %edi
  80275b:	56                   	push   %esi
  80275c:	53                   	push   %ebx
  80275d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802760:	bb 00 00 00 00       	mov    $0x0,%ebx
  802765:	8b 55 08             	mov    0x8(%ebp),%edx
  802768:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80276b:	b8 09 00 00 00       	mov    $0x9,%eax
  802770:	89 df                	mov    %ebx,%edi
  802772:	89 de                	mov    %ebx,%esi
  802774:	cd 30                	int    $0x30
	if(check && ret > 0)
  802776:	85 c0                	test   %eax,%eax
  802778:	7f 08                	jg     802782 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80277a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80277d:	5b                   	pop    %ebx
  80277e:	5e                   	pop    %esi
  80277f:	5f                   	pop    %edi
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802782:	83 ec 0c             	sub    $0xc,%esp
  802785:	50                   	push   %eax
  802786:	6a 09                	push   $0x9
  802788:	68 7f 46 80 00       	push   $0x80467f
  80278d:	6a 23                	push   $0x23
  80278f:	68 9c 46 80 00       	push   $0x80469c
  802794:	e8 c2 f3 ff ff       	call   801b5b <_panic>

00802799 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
  80279c:	57                   	push   %edi
  80279d:	56                   	push   %esi
  80279e:	53                   	push   %ebx
  80279f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8027a2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027b2:	89 df                	mov    %ebx,%edi
  8027b4:	89 de                	mov    %ebx,%esi
  8027b6:	cd 30                	int    $0x30
	if(check && ret > 0)
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	7f 08                	jg     8027c4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8027bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027bf:	5b                   	pop    %ebx
  8027c0:	5e                   	pop    %esi
  8027c1:	5f                   	pop    %edi
  8027c2:	5d                   	pop    %ebp
  8027c3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8027c4:	83 ec 0c             	sub    $0xc,%esp
  8027c7:	50                   	push   %eax
  8027c8:	6a 0a                	push   $0xa
  8027ca:	68 7f 46 80 00       	push   $0x80467f
  8027cf:	6a 23                	push   $0x23
  8027d1:	68 9c 46 80 00       	push   $0x80469c
  8027d6:	e8 80 f3 ff ff       	call   801b5b <_panic>

008027db <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	57                   	push   %edi
  8027df:	56                   	push   %esi
  8027e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8027e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8027ec:	be 00 00 00 00       	mov    $0x0,%esi
  8027f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8027f7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8027f9:	5b                   	pop    %ebx
  8027fa:	5e                   	pop    %esi
  8027fb:	5f                   	pop    %edi
  8027fc:	5d                   	pop    %ebp
  8027fd:	c3                   	ret    

008027fe <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	57                   	push   %edi
  802802:	56                   	push   %esi
  802803:	53                   	push   %ebx
  802804:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802807:	b9 00 00 00 00       	mov    $0x0,%ecx
  80280c:	8b 55 08             	mov    0x8(%ebp),%edx
  80280f:	b8 0d 00 00 00       	mov    $0xd,%eax
  802814:	89 cb                	mov    %ecx,%ebx
  802816:	89 cf                	mov    %ecx,%edi
  802818:	89 ce                	mov    %ecx,%esi
  80281a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80281c:	85 c0                	test   %eax,%eax
  80281e:	7f 08                	jg     802828 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802823:	5b                   	pop    %ebx
  802824:	5e                   	pop    %esi
  802825:	5f                   	pop    %edi
  802826:	5d                   	pop    %ebp
  802827:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802828:	83 ec 0c             	sub    $0xc,%esp
  80282b:	50                   	push   %eax
  80282c:	6a 0d                	push   $0xd
  80282e:	68 7f 46 80 00       	push   $0x80467f
  802833:	6a 23                	push   $0x23
  802835:	68 9c 46 80 00       	push   $0x80469c
  80283a:	e8 1c f3 ff ff       	call   801b5b <_panic>

0080283f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	57                   	push   %edi
  802843:	56                   	push   %esi
  802844:	53                   	push   %ebx
	asm volatile("int %1\n"
  802845:	ba 00 00 00 00       	mov    $0x0,%edx
  80284a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80284f:	89 d1                	mov    %edx,%ecx
  802851:	89 d3                	mov    %edx,%ebx
  802853:	89 d7                	mov    %edx,%edi
  802855:	89 d6                	mov    %edx,%esi
  802857:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802859:	5b                   	pop    %ebx
  80285a:	5e                   	pop    %esi
  80285b:	5f                   	pop    %edi
  80285c:	5d                   	pop    %ebp
  80285d:	c3                   	ret    

0080285e <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  802864:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  80286b:	74 0a                	je     802877 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  802875:	c9                   	leave  
  802876:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802877:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80287c:	8b 40 48             	mov    0x48(%eax),%eax
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	6a 07                	push   $0x7
  802884:	68 00 f0 bf ee       	push   $0xeebff000
  802889:	50                   	push   %eax
  80288a:	e8 bf fd ff ff       	call   80264e <sys_page_alloc>
  80288f:	83 c4 10             	add    $0x10,%esp
  802892:	85 c0                	test   %eax,%eax
  802894:	78 1b                	js     8028b1 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802896:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80289b:	8b 40 48             	mov    0x48(%eax),%eax
  80289e:	83 ec 08             	sub    $0x8,%esp
  8028a1:	68 c3 28 80 00       	push   $0x8028c3
  8028a6:	50                   	push   %eax
  8028a7:	e8 ed fe ff ff       	call   802799 <sys_env_set_pgfault_upcall>
  8028ac:	83 c4 10             	add    $0x10,%esp
  8028af:	eb bc                	jmp    80286d <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  8028b1:	50                   	push   %eax
  8028b2:	68 aa 46 80 00       	push   $0x8046aa
  8028b7:	6a 22                	push   $0x22
  8028b9:	68 c2 46 80 00       	push   $0x8046c2
  8028be:	e8 98 f2 ff ff       	call   801b5b <_panic>

008028c3 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028c3:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028c4:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  8028c9:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028cb:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8028ce:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8028d2:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8028d5:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8028d9:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8028dd:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8028df:	83 c4 08             	add    $0x8,%esp
	popal
  8028e2:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8028e3:	83 c4 04             	add    $0x4,%esp
	popfl
  8028e6:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8028e7:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8028e8:	c3                   	ret    

008028e9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028e9:	55                   	push   %ebp
  8028ea:	89 e5                	mov    %esp,%ebp
  8028ec:	56                   	push   %esi
  8028ed:	53                   	push   %ebx
  8028ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8028f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8028f7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8028f9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8028fe:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802901:	83 ec 0c             	sub    $0xc,%esp
  802904:	50                   	push   %eax
  802905:	e8 f4 fe ff ff       	call   8027fe <sys_ipc_recv>
	if (from_env_store)
  80290a:	83 c4 10             	add    $0x10,%esp
  80290d:	85 f6                	test   %esi,%esi
  80290f:	74 14                	je     802925 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802911:	ba 00 00 00 00       	mov    $0x0,%edx
  802916:	85 c0                	test   %eax,%eax
  802918:	78 09                	js     802923 <ipc_recv+0x3a>
  80291a:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  802920:	8b 52 74             	mov    0x74(%edx),%edx
  802923:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802925:	85 db                	test   %ebx,%ebx
  802927:	74 14                	je     80293d <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802929:	ba 00 00 00 00       	mov    $0x0,%edx
  80292e:	85 c0                	test   %eax,%eax
  802930:	78 09                	js     80293b <ipc_recv+0x52>
  802932:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  802938:	8b 52 78             	mov    0x78(%edx),%edx
  80293b:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80293d:	85 c0                	test   %eax,%eax
  80293f:	78 08                	js     802949 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802941:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802946:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802949:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    

00802950 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
  802953:	57                   	push   %edi
  802954:	56                   	push   %esi
  802955:	53                   	push   %ebx
  802956:	83 ec 0c             	sub    $0xc,%esp
  802959:	8b 7d 08             	mov    0x8(%ebp),%edi
  80295c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80295f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802962:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802964:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802969:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80296c:	ff 75 14             	pushl  0x14(%ebp)
  80296f:	53                   	push   %ebx
  802970:	56                   	push   %esi
  802971:	57                   	push   %edi
  802972:	e8 64 fe ff ff       	call   8027db <sys_ipc_try_send>
		if (ret == 0)
  802977:	83 c4 10             	add    $0x10,%esp
  80297a:	85 c0                	test   %eax,%eax
  80297c:	74 1e                	je     80299c <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80297e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802981:	75 07                	jne    80298a <ipc_send+0x3a>
			sys_yield();
  802983:	e8 a7 fc ff ff       	call   80262f <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802988:	eb e2                	jmp    80296c <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80298a:	50                   	push   %eax
  80298b:	68 d0 46 80 00       	push   $0x8046d0
  802990:	6a 3d                	push   $0x3d
  802992:	68 e4 46 80 00       	push   $0x8046e4
  802997:	e8 bf f1 ff ff       	call   801b5b <_panic>
	}
	// panic("ipc_send not implemented");
}
  80299c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80299f:	5b                   	pop    %ebx
  8029a0:	5e                   	pop    %esi
  8029a1:	5f                   	pop    %edi
  8029a2:	5d                   	pop    %ebp
  8029a3:	c3                   	ret    

008029a4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029a4:	55                   	push   %ebp
  8029a5:	89 e5                	mov    %esp,%ebp
  8029a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029af:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029b2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029b8:	8b 52 50             	mov    0x50(%edx),%edx
  8029bb:	39 ca                	cmp    %ecx,%edx
  8029bd:	74 11                	je     8029d0 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8029bf:	83 c0 01             	add    $0x1,%eax
  8029c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029c7:	75 e6                	jne    8029af <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ce:	eb 0b                	jmp    8029db <ipc_find_env+0x37>
			return envs[i].env_id;
  8029d0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8029d8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    

008029dd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	05 00 00 00 30       	add    $0x30000000,%eax
  8029e8:	c1 e8 0c             	shr    $0xc,%eax
}
  8029eb:	5d                   	pop    %ebp
  8029ec:	c3                   	ret    

008029ed <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8029ed:	55                   	push   %ebp
  8029ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8029f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029fd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    

00802a04 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a0a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802a0f:	89 c2                	mov    %eax,%edx
  802a11:	c1 ea 16             	shr    $0x16,%edx
  802a14:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a1b:	f6 c2 01             	test   $0x1,%dl
  802a1e:	74 2a                	je     802a4a <fd_alloc+0x46>
  802a20:	89 c2                	mov    %eax,%edx
  802a22:	c1 ea 0c             	shr    $0xc,%edx
  802a25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802a2c:	f6 c2 01             	test   $0x1,%dl
  802a2f:	74 19                	je     802a4a <fd_alloc+0x46>
  802a31:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  802a36:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802a3b:	75 d2                	jne    802a0f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802a3d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802a43:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  802a48:	eb 07                	jmp    802a51 <fd_alloc+0x4d>
			*fd_store = fd;
  802a4a:	89 01                	mov    %eax,(%ecx)
			return 0;
  802a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a51:	5d                   	pop    %ebp
  802a52:	c3                   	ret    

00802a53 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802a53:	55                   	push   %ebp
  802a54:	89 e5                	mov    %esp,%ebp
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802a59:	83 f8 1f             	cmp    $0x1f,%eax
  802a5c:	77 36                	ja     802a94 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802a5e:	c1 e0 0c             	shl    $0xc,%eax
  802a61:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802a66:	89 c2                	mov    %eax,%edx
  802a68:	c1 ea 16             	shr    $0x16,%edx
  802a6b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a72:	f6 c2 01             	test   $0x1,%dl
  802a75:	74 24                	je     802a9b <fd_lookup+0x48>
  802a77:	89 c2                	mov    %eax,%edx
  802a79:	c1 ea 0c             	shr    $0xc,%edx
  802a7c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802a83:	f6 c2 01             	test   $0x1,%dl
  802a86:	74 1a                	je     802aa2 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a8b:	89 02                	mov    %eax,(%edx)
	return 0;
  802a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a92:	5d                   	pop    %ebp
  802a93:	c3                   	ret    
		return -E_INVAL;
  802a94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802a99:	eb f7                	jmp    802a92 <fd_lookup+0x3f>
		return -E_INVAL;
  802a9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa0:	eb f0                	jmp    802a92 <fd_lookup+0x3f>
  802aa2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa7:	eb e9                	jmp    802a92 <fd_lookup+0x3f>

00802aa9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802aa9:	55                   	push   %ebp
  802aaa:	89 e5                	mov    %esp,%ebp
  802aac:	83 ec 08             	sub    $0x8,%esp
  802aaf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ab2:	ba 70 47 80 00       	mov    $0x804770,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802ab7:	b8 64 90 80 00       	mov    $0x809064,%eax
		if (devtab[i]->dev_id == dev_id) {
  802abc:	39 08                	cmp    %ecx,(%eax)
  802abe:	74 33                	je     802af3 <dev_lookup+0x4a>
  802ac0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  802ac3:	8b 02                	mov    (%edx),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	75 f3                	jne    802abc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802ac9:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802ace:	8b 40 48             	mov    0x48(%eax),%eax
  802ad1:	83 ec 04             	sub    $0x4,%esp
  802ad4:	51                   	push   %ecx
  802ad5:	50                   	push   %eax
  802ad6:	68 f0 46 80 00       	push   $0x8046f0
  802adb:	e8 56 f1 ff ff       	call   801c36 <cprintf>
	*dev = 0;
  802ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802ae9:	83 c4 10             	add    $0x10,%esp
  802aec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    
			*dev = devtab[i];
  802af3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802af6:	89 01                	mov    %eax,(%ecx)
			return 0;
  802af8:	b8 00 00 00 00       	mov    $0x0,%eax
  802afd:	eb f2                	jmp    802af1 <dev_lookup+0x48>

00802aff <fd_close>:
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
  802b02:	57                   	push   %edi
  802b03:	56                   	push   %esi
  802b04:	53                   	push   %ebx
  802b05:	83 ec 1c             	sub    $0x1c,%esp
  802b08:	8b 75 08             	mov    0x8(%ebp),%esi
  802b0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b0e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b11:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802b12:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802b18:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b1b:	50                   	push   %eax
  802b1c:	e8 32 ff ff ff       	call   802a53 <fd_lookup>
  802b21:	89 c3                	mov    %eax,%ebx
  802b23:	83 c4 08             	add    $0x8,%esp
  802b26:	85 c0                	test   %eax,%eax
  802b28:	78 05                	js     802b2f <fd_close+0x30>
	    || fd != fd2)
  802b2a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  802b2d:	74 16                	je     802b45 <fd_close+0x46>
		return (must_exist ? r : 0);
  802b2f:	89 f8                	mov    %edi,%eax
  802b31:	84 c0                	test   %al,%al
  802b33:	b8 00 00 00 00       	mov    $0x0,%eax
  802b38:	0f 44 d8             	cmove  %eax,%ebx
}
  802b3b:	89 d8                	mov    %ebx,%eax
  802b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802b40:	5b                   	pop    %ebx
  802b41:	5e                   	pop    %esi
  802b42:	5f                   	pop    %edi
  802b43:	5d                   	pop    %ebp
  802b44:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802b45:	83 ec 08             	sub    $0x8,%esp
  802b48:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802b4b:	50                   	push   %eax
  802b4c:	ff 36                	pushl  (%esi)
  802b4e:	e8 56 ff ff ff       	call   802aa9 <dev_lookup>
  802b53:	89 c3                	mov    %eax,%ebx
  802b55:	83 c4 10             	add    $0x10,%esp
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	78 15                	js     802b71 <fd_close+0x72>
		if (dev->dev_close)
  802b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5f:	8b 40 10             	mov    0x10(%eax),%eax
  802b62:	85 c0                	test   %eax,%eax
  802b64:	74 1b                	je     802b81 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  802b66:	83 ec 0c             	sub    $0xc,%esp
  802b69:	56                   	push   %esi
  802b6a:	ff d0                	call   *%eax
  802b6c:	89 c3                	mov    %eax,%ebx
  802b6e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  802b71:	83 ec 08             	sub    $0x8,%esp
  802b74:	56                   	push   %esi
  802b75:	6a 00                	push   $0x0
  802b77:	e8 57 fb ff ff       	call   8026d3 <sys_page_unmap>
	return r;
  802b7c:	83 c4 10             	add    $0x10,%esp
  802b7f:	eb ba                	jmp    802b3b <fd_close+0x3c>
			r = 0;
  802b81:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b86:	eb e9                	jmp    802b71 <fd_close+0x72>

00802b88 <close>:

int
close(int fdnum)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b8e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b91:	50                   	push   %eax
  802b92:	ff 75 08             	pushl  0x8(%ebp)
  802b95:	e8 b9 fe ff ff       	call   802a53 <fd_lookup>
  802b9a:	83 c4 08             	add    $0x8,%esp
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	78 10                	js     802bb1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  802ba1:	83 ec 08             	sub    $0x8,%esp
  802ba4:	6a 01                	push   $0x1
  802ba6:	ff 75 f4             	pushl  -0xc(%ebp)
  802ba9:	e8 51 ff ff ff       	call   802aff <fd_close>
  802bae:	83 c4 10             	add    $0x10,%esp
}
  802bb1:	c9                   	leave  
  802bb2:	c3                   	ret    

00802bb3 <close_all>:

void
close_all(void)
{
  802bb3:	55                   	push   %ebp
  802bb4:	89 e5                	mov    %esp,%ebp
  802bb6:	53                   	push   %ebx
  802bb7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802bba:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802bbf:	83 ec 0c             	sub    $0xc,%esp
  802bc2:	53                   	push   %ebx
  802bc3:	e8 c0 ff ff ff       	call   802b88 <close>
	for (i = 0; i < MAXFD; i++)
  802bc8:	83 c3 01             	add    $0x1,%ebx
  802bcb:	83 c4 10             	add    $0x10,%esp
  802bce:	83 fb 20             	cmp    $0x20,%ebx
  802bd1:	75 ec                	jne    802bbf <close_all+0xc>
}
  802bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bd6:	c9                   	leave  
  802bd7:	c3                   	ret    

00802bd8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802bd8:	55                   	push   %ebp
  802bd9:	89 e5                	mov    %esp,%ebp
  802bdb:	57                   	push   %edi
  802bdc:	56                   	push   %esi
  802bdd:	53                   	push   %ebx
  802bde:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802be1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802be4:	50                   	push   %eax
  802be5:	ff 75 08             	pushl  0x8(%ebp)
  802be8:	e8 66 fe ff ff       	call   802a53 <fd_lookup>
  802bed:	89 c3                	mov    %eax,%ebx
  802bef:	83 c4 08             	add    $0x8,%esp
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	0f 88 81 00 00 00    	js     802c7b <dup+0xa3>
		return r;
	close(newfdnum);
  802bfa:	83 ec 0c             	sub    $0xc,%esp
  802bfd:	ff 75 0c             	pushl  0xc(%ebp)
  802c00:	e8 83 ff ff ff       	call   802b88 <close>

	newfd = INDEX2FD(newfdnum);
  802c05:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c08:	c1 e6 0c             	shl    $0xc,%esi
  802c0b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802c11:	83 c4 04             	add    $0x4,%esp
  802c14:	ff 75 e4             	pushl  -0x1c(%ebp)
  802c17:	e8 d1 fd ff ff       	call   8029ed <fd2data>
  802c1c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802c1e:	89 34 24             	mov    %esi,(%esp)
  802c21:	e8 c7 fd ff ff       	call   8029ed <fd2data>
  802c26:	83 c4 10             	add    $0x10,%esp
  802c29:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802c2b:	89 d8                	mov    %ebx,%eax
  802c2d:	c1 e8 16             	shr    $0x16,%eax
  802c30:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802c37:	a8 01                	test   $0x1,%al
  802c39:	74 11                	je     802c4c <dup+0x74>
  802c3b:	89 d8                	mov    %ebx,%eax
  802c3d:	c1 e8 0c             	shr    $0xc,%eax
  802c40:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802c47:	f6 c2 01             	test   $0x1,%dl
  802c4a:	75 39                	jne    802c85 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802c4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4f:	89 d0                	mov    %edx,%eax
  802c51:	c1 e8 0c             	shr    $0xc,%eax
  802c54:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802c5b:	83 ec 0c             	sub    $0xc,%esp
  802c5e:	25 07 0e 00 00       	and    $0xe07,%eax
  802c63:	50                   	push   %eax
  802c64:	56                   	push   %esi
  802c65:	6a 00                	push   $0x0
  802c67:	52                   	push   %edx
  802c68:	6a 00                	push   $0x0
  802c6a:	e8 22 fa ff ff       	call   802691 <sys_page_map>
  802c6f:	89 c3                	mov    %eax,%ebx
  802c71:	83 c4 20             	add    $0x20,%esp
  802c74:	85 c0                	test   %eax,%eax
  802c76:	78 31                	js     802ca9 <dup+0xd1>
		goto err;

	return newfdnum;
  802c78:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  802c7b:	89 d8                	mov    %ebx,%eax
  802c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c80:	5b                   	pop    %ebx
  802c81:	5e                   	pop    %esi
  802c82:	5f                   	pop    %edi
  802c83:	5d                   	pop    %ebp
  802c84:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802c85:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802c8c:	83 ec 0c             	sub    $0xc,%esp
  802c8f:	25 07 0e 00 00       	and    $0xe07,%eax
  802c94:	50                   	push   %eax
  802c95:	57                   	push   %edi
  802c96:	6a 00                	push   $0x0
  802c98:	53                   	push   %ebx
  802c99:	6a 00                	push   $0x0
  802c9b:	e8 f1 f9 ff ff       	call   802691 <sys_page_map>
  802ca0:	89 c3                	mov    %eax,%ebx
  802ca2:	83 c4 20             	add    $0x20,%esp
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	79 a3                	jns    802c4c <dup+0x74>
	sys_page_unmap(0, newfd);
  802ca9:	83 ec 08             	sub    $0x8,%esp
  802cac:	56                   	push   %esi
  802cad:	6a 00                	push   $0x0
  802caf:	e8 1f fa ff ff       	call   8026d3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802cb4:	83 c4 08             	add    $0x8,%esp
  802cb7:	57                   	push   %edi
  802cb8:	6a 00                	push   $0x0
  802cba:	e8 14 fa ff ff       	call   8026d3 <sys_page_unmap>
	return r;
  802cbf:	83 c4 10             	add    $0x10,%esp
  802cc2:	eb b7                	jmp    802c7b <dup+0xa3>

00802cc4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802cc4:	55                   	push   %ebp
  802cc5:	89 e5                	mov    %esp,%ebp
  802cc7:	53                   	push   %ebx
  802cc8:	83 ec 14             	sub    $0x14,%esp
  802ccb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802cce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802cd1:	50                   	push   %eax
  802cd2:	53                   	push   %ebx
  802cd3:	e8 7b fd ff ff       	call   802a53 <fd_lookup>
  802cd8:	83 c4 08             	add    $0x8,%esp
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	78 3f                	js     802d1e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802cdf:	83 ec 08             	sub    $0x8,%esp
  802ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ce5:	50                   	push   %eax
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	ff 30                	pushl  (%eax)
  802ceb:	e8 b9 fd ff ff       	call   802aa9 <dev_lookup>
  802cf0:	83 c4 10             	add    $0x10,%esp
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	78 27                	js     802d1e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802cf7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cfa:	8b 42 08             	mov    0x8(%edx),%eax
  802cfd:	83 e0 03             	and    $0x3,%eax
  802d00:	83 f8 01             	cmp    $0x1,%eax
  802d03:	74 1e                	je     802d23 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 35                	je     802d44 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802d0f:	83 ec 04             	sub    $0x4,%esp
  802d12:	ff 75 10             	pushl  0x10(%ebp)
  802d15:	ff 75 0c             	pushl  0xc(%ebp)
  802d18:	52                   	push   %edx
  802d19:	ff d0                	call   *%eax
  802d1b:	83 c4 10             	add    $0x10,%esp
}
  802d1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d21:	c9                   	leave  
  802d22:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802d23:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d28:	8b 40 48             	mov    0x48(%eax),%eax
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	53                   	push   %ebx
  802d2f:	50                   	push   %eax
  802d30:	68 34 47 80 00       	push   $0x804734
  802d35:	e8 fc ee ff ff       	call   801c36 <cprintf>
		return -E_INVAL;
  802d3a:	83 c4 10             	add    $0x10,%esp
  802d3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802d42:	eb da                	jmp    802d1e <read+0x5a>
		return -E_NOT_SUPP;
  802d44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802d49:	eb d3                	jmp    802d1e <read+0x5a>

00802d4b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	57                   	push   %edi
  802d4f:	56                   	push   %esi
  802d50:	53                   	push   %ebx
  802d51:	83 ec 0c             	sub    $0xc,%esp
  802d54:	8b 7d 08             	mov    0x8(%ebp),%edi
  802d57:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d5f:	39 f3                	cmp    %esi,%ebx
  802d61:	73 25                	jae    802d88 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	89 f0                	mov    %esi,%eax
  802d68:	29 d8                	sub    %ebx,%eax
  802d6a:	50                   	push   %eax
  802d6b:	89 d8                	mov    %ebx,%eax
  802d6d:	03 45 0c             	add    0xc(%ebp),%eax
  802d70:	50                   	push   %eax
  802d71:	57                   	push   %edi
  802d72:	e8 4d ff ff ff       	call   802cc4 <read>
		if (m < 0)
  802d77:	83 c4 10             	add    $0x10,%esp
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	78 08                	js     802d86 <readn+0x3b>
			return m;
		if (m == 0)
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 06                	je     802d88 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802d82:	01 c3                	add    %eax,%ebx
  802d84:	eb d9                	jmp    802d5f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802d86:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802d88:	89 d8                	mov    %ebx,%eax
  802d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d8d:	5b                   	pop    %ebx
  802d8e:	5e                   	pop    %esi
  802d8f:	5f                   	pop    %edi
  802d90:	5d                   	pop    %ebp
  802d91:	c3                   	ret    

00802d92 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802d92:	55                   	push   %ebp
  802d93:	89 e5                	mov    %esp,%ebp
  802d95:	53                   	push   %ebx
  802d96:	83 ec 14             	sub    $0x14,%esp
  802d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802d9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d9f:	50                   	push   %eax
  802da0:	53                   	push   %ebx
  802da1:	e8 ad fc ff ff       	call   802a53 <fd_lookup>
  802da6:	83 c4 08             	add    $0x8,%esp
  802da9:	85 c0                	test   %eax,%eax
  802dab:	78 3a                	js     802de7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802dad:	83 ec 08             	sub    $0x8,%esp
  802db0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db3:	50                   	push   %eax
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	ff 30                	pushl  (%eax)
  802db9:	e8 eb fc ff ff       	call   802aa9 <dev_lookup>
  802dbe:	83 c4 10             	add    $0x10,%esp
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	78 22                	js     802de7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802dcc:	74 1e                	je     802dec <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd1:	8b 52 0c             	mov    0xc(%edx),%edx
  802dd4:	85 d2                	test   %edx,%edx
  802dd6:	74 35                	je     802e0d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	ff 75 10             	pushl  0x10(%ebp)
  802dde:	ff 75 0c             	pushl  0xc(%ebp)
  802de1:	50                   	push   %eax
  802de2:	ff d2                	call   *%edx
  802de4:	83 c4 10             	add    $0x10,%esp
}
  802de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dea:	c9                   	leave  
  802deb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802dec:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802df1:	8b 40 48             	mov    0x48(%eax),%eax
  802df4:	83 ec 04             	sub    $0x4,%esp
  802df7:	53                   	push   %ebx
  802df8:	50                   	push   %eax
  802df9:	68 50 47 80 00       	push   $0x804750
  802dfe:	e8 33 ee ff ff       	call   801c36 <cprintf>
		return -E_INVAL;
  802e03:	83 c4 10             	add    $0x10,%esp
  802e06:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e0b:	eb da                	jmp    802de7 <write+0x55>
		return -E_NOT_SUPP;
  802e0d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802e12:	eb d3                	jmp    802de7 <write+0x55>

00802e14 <seek>:

int
seek(int fdnum, off_t offset)
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
  802e17:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802e1d:	50                   	push   %eax
  802e1e:	ff 75 08             	pushl  0x8(%ebp)
  802e21:	e8 2d fc ff ff       	call   802a53 <fd_lookup>
  802e26:	83 c4 08             	add    $0x8,%esp
  802e29:	85 c0                	test   %eax,%eax
  802e2b:	78 0e                	js     802e3b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802e36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e3b:	c9                   	leave  
  802e3c:	c3                   	ret    

00802e3d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802e3d:	55                   	push   %ebp
  802e3e:	89 e5                	mov    %esp,%ebp
  802e40:	53                   	push   %ebx
  802e41:	83 ec 14             	sub    $0x14,%esp
  802e44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e47:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e4a:	50                   	push   %eax
  802e4b:	53                   	push   %ebx
  802e4c:	e8 02 fc ff ff       	call   802a53 <fd_lookup>
  802e51:	83 c4 08             	add    $0x8,%esp
  802e54:	85 c0                	test   %eax,%eax
  802e56:	78 37                	js     802e8f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802e58:	83 ec 08             	sub    $0x8,%esp
  802e5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e5e:	50                   	push   %eax
  802e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e62:	ff 30                	pushl  (%eax)
  802e64:	e8 40 fc ff ff       	call   802aa9 <dev_lookup>
  802e69:	83 c4 10             	add    $0x10,%esp
  802e6c:	85 c0                	test   %eax,%eax
  802e6e:	78 1f                	js     802e8f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802e77:	74 1b                	je     802e94 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7c:	8b 52 18             	mov    0x18(%edx),%edx
  802e7f:	85 d2                	test   %edx,%edx
  802e81:	74 32                	je     802eb5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802e83:	83 ec 08             	sub    $0x8,%esp
  802e86:	ff 75 0c             	pushl  0xc(%ebp)
  802e89:	50                   	push   %eax
  802e8a:	ff d2                	call   *%edx
  802e8c:	83 c4 10             	add    $0x10,%esp
}
  802e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    
			thisenv->env_id, fdnum);
  802e94:	a1 10 a0 80 00       	mov    0x80a010,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802e99:	8b 40 48             	mov    0x48(%eax),%eax
  802e9c:	83 ec 04             	sub    $0x4,%esp
  802e9f:	53                   	push   %ebx
  802ea0:	50                   	push   %eax
  802ea1:	68 10 47 80 00       	push   $0x804710
  802ea6:	e8 8b ed ff ff       	call   801c36 <cprintf>
		return -E_INVAL;
  802eab:	83 c4 10             	add    $0x10,%esp
  802eae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eb3:	eb da                	jmp    802e8f <ftruncate+0x52>
		return -E_NOT_SUPP;
  802eb5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802eba:	eb d3                	jmp    802e8f <ftruncate+0x52>

00802ebc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802ebc:	55                   	push   %ebp
  802ebd:	89 e5                	mov    %esp,%ebp
  802ebf:	53                   	push   %ebx
  802ec0:	83 ec 14             	sub    $0x14,%esp
  802ec3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802ec6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ec9:	50                   	push   %eax
  802eca:	ff 75 08             	pushl  0x8(%ebp)
  802ecd:	e8 81 fb ff ff       	call   802a53 <fd_lookup>
  802ed2:	83 c4 08             	add    $0x8,%esp
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	78 4b                	js     802f24 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802ed9:	83 ec 08             	sub    $0x8,%esp
  802edc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802edf:	50                   	push   %eax
  802ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee3:	ff 30                	pushl  (%eax)
  802ee5:	e8 bf fb ff ff       	call   802aa9 <dev_lookup>
  802eea:	83 c4 10             	add    $0x10,%esp
  802eed:	85 c0                	test   %eax,%eax
  802eef:	78 33                	js     802f24 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802ef8:	74 2f                	je     802f29 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802efa:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802efd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802f04:	00 00 00 
	stat->st_isdir = 0;
  802f07:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802f0e:	00 00 00 
	stat->st_dev = dev;
  802f11:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802f17:	83 ec 08             	sub    $0x8,%esp
  802f1a:	53                   	push   %ebx
  802f1b:	ff 75 f0             	pushl  -0x10(%ebp)
  802f1e:	ff 50 14             	call   *0x14(%eax)
  802f21:	83 c4 10             	add    $0x10,%esp
}
  802f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802f27:	c9                   	leave  
  802f28:	c3                   	ret    
		return -E_NOT_SUPP;
  802f29:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802f2e:	eb f4                	jmp    802f24 <fstat+0x68>

00802f30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802f30:	55                   	push   %ebp
  802f31:	89 e5                	mov    %esp,%ebp
  802f33:	56                   	push   %esi
  802f34:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802f35:	83 ec 08             	sub    $0x8,%esp
  802f38:	6a 00                	push   $0x0
  802f3a:	ff 75 08             	pushl  0x8(%ebp)
  802f3d:	e8 e7 01 00 00       	call   803129 <open>
  802f42:	89 c3                	mov    %eax,%ebx
  802f44:	83 c4 10             	add    $0x10,%esp
  802f47:	85 c0                	test   %eax,%eax
  802f49:	78 1b                	js     802f66 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802f4b:	83 ec 08             	sub    $0x8,%esp
  802f4e:	ff 75 0c             	pushl  0xc(%ebp)
  802f51:	50                   	push   %eax
  802f52:	e8 65 ff ff ff       	call   802ebc <fstat>
  802f57:	89 c6                	mov    %eax,%esi
	close(fd);
  802f59:	89 1c 24             	mov    %ebx,(%esp)
  802f5c:	e8 27 fc ff ff       	call   802b88 <close>
	return r;
  802f61:	83 c4 10             	add    $0x10,%esp
  802f64:	89 f3                	mov    %esi,%ebx
}
  802f66:	89 d8                	mov    %ebx,%eax
  802f68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f6b:	5b                   	pop    %ebx
  802f6c:	5e                   	pop    %esi
  802f6d:	5d                   	pop    %ebp
  802f6e:	c3                   	ret    

00802f6f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
  802f72:	56                   	push   %esi
  802f73:	53                   	push   %ebx
  802f74:	89 c6                	mov    %eax,%esi
  802f76:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802f78:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802f7f:	74 27                	je     802fa8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802f81:	6a 07                	push   $0x7
  802f83:	68 00 b0 80 00       	push   $0x80b000
  802f88:	56                   	push   %esi
  802f89:	ff 35 00 a0 80 00    	pushl  0x80a000
  802f8f:	e8 bc f9 ff ff       	call   802950 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802f94:	83 c4 0c             	add    $0xc,%esp
  802f97:	6a 00                	push   $0x0
  802f99:	53                   	push   %ebx
  802f9a:	6a 00                	push   $0x0
  802f9c:	e8 48 f9 ff ff       	call   8028e9 <ipc_recv>
}
  802fa1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fa4:	5b                   	pop    %ebx
  802fa5:	5e                   	pop    %esi
  802fa6:	5d                   	pop    %ebp
  802fa7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802fa8:	83 ec 0c             	sub    $0xc,%esp
  802fab:	6a 01                	push   $0x1
  802fad:	e8 f2 f9 ff ff       	call   8029a4 <ipc_find_env>
  802fb2:	a3 00 a0 80 00       	mov    %eax,0x80a000
  802fb7:	83 c4 10             	add    $0x10,%esp
  802fba:	eb c5                	jmp    802f81 <fsipc+0x12>

00802fbc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
  802fbf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc8:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd0:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802fd5:	ba 00 00 00 00       	mov    $0x0,%edx
  802fda:	b8 02 00 00 00       	mov    $0x2,%eax
  802fdf:	e8 8b ff ff ff       	call   802f6f <fsipc>
}
  802fe4:	c9                   	leave  
  802fe5:	c3                   	ret    

00802fe6 <devfile_flush>:
{
  802fe6:	55                   	push   %ebp
  802fe7:	89 e5                	mov    %esp,%ebp
  802fe9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802ff7:	ba 00 00 00 00       	mov    $0x0,%edx
  802ffc:	b8 06 00 00 00       	mov    $0x6,%eax
  803001:	e8 69 ff ff ff       	call   802f6f <fsipc>
}
  803006:	c9                   	leave  
  803007:	c3                   	ret    

00803008 <devfile_stat>:
{
  803008:	55                   	push   %ebp
  803009:	89 e5                	mov    %esp,%ebp
  80300b:	53                   	push   %ebx
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	8b 40 0c             	mov    0xc(%eax),%eax
  803018:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80301d:	ba 00 00 00 00       	mov    $0x0,%edx
  803022:	b8 05 00 00 00       	mov    $0x5,%eax
  803027:	e8 43 ff ff ff       	call   802f6f <fsipc>
  80302c:	85 c0                	test   %eax,%eax
  80302e:	78 2c                	js     80305c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  803030:	83 ec 08             	sub    $0x8,%esp
  803033:	68 00 b0 80 00       	push   $0x80b000
  803038:	53                   	push   %ebx
  803039:	e8 17 f2 ff ff       	call   802255 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80303e:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803043:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803049:	a1 84 b0 80 00       	mov    0x80b084,%eax
  80304e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803054:	83 c4 10             	add    $0x10,%esp
  803057:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80305c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80305f:	c9                   	leave  
  803060:	c3                   	ret    

00803061 <devfile_write>:
{
  803061:	55                   	push   %ebp
  803062:	89 e5                	mov    %esp,%ebp
  803064:	83 ec 0c             	sub    $0xc,%esp
  803067:	8b 45 10             	mov    0x10(%ebp),%eax
  80306a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80306f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  803074:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803077:	8b 55 08             	mov    0x8(%ebp),%edx
  80307a:	8b 52 0c             	mov    0xc(%edx),%edx
  80307d:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	fsipcbuf.write.req_n = n;
  803083:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, n);
  803088:	50                   	push   %eax
  803089:	ff 75 0c             	pushl  0xc(%ebp)
  80308c:	68 08 b0 80 00       	push   $0x80b008
  803091:	e8 4d f3 ff ff       	call   8023e3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  803096:	ba 00 00 00 00       	mov    $0x0,%edx
  80309b:	b8 04 00 00 00       	mov    $0x4,%eax
  8030a0:	e8 ca fe ff ff       	call   802f6f <fsipc>
}
  8030a5:	c9                   	leave  
  8030a6:	c3                   	ret    

008030a7 <devfile_read>:
{
  8030a7:	55                   	push   %ebp
  8030a8:	89 e5                	mov    %esp,%ebp
  8030aa:	56                   	push   %esi
  8030ab:	53                   	push   %ebx
  8030ac:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b5:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  8030ba:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8030c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8030c5:	b8 03 00 00 00       	mov    $0x3,%eax
  8030ca:	e8 a0 fe ff ff       	call   802f6f <fsipc>
  8030cf:	89 c3                	mov    %eax,%ebx
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	78 1f                	js     8030f4 <devfile_read+0x4d>
	assert(r <= n);
  8030d5:	39 f0                	cmp    %esi,%eax
  8030d7:	77 24                	ja     8030fd <devfile_read+0x56>
	assert(r <= PGSIZE);
  8030d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8030de:	7f 33                	jg     803113 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8030e0:	83 ec 04             	sub    $0x4,%esp
  8030e3:	50                   	push   %eax
  8030e4:	68 00 b0 80 00       	push   $0x80b000
  8030e9:	ff 75 0c             	pushl  0xc(%ebp)
  8030ec:	e8 f2 f2 ff ff       	call   8023e3 <memmove>
	return r;
  8030f1:	83 c4 10             	add    $0x10,%esp
}
  8030f4:	89 d8                	mov    %ebx,%eax
  8030f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8030f9:	5b                   	pop    %ebx
  8030fa:	5e                   	pop    %esi
  8030fb:	5d                   	pop    %ebp
  8030fc:	c3                   	ret    
	assert(r <= n);
  8030fd:	68 84 47 80 00       	push   $0x804784
  803102:	68 bd 3d 80 00       	push   $0x803dbd
  803107:	6a 7b                	push   $0x7b
  803109:	68 8b 47 80 00       	push   $0x80478b
  80310e:	e8 48 ea ff ff       	call   801b5b <_panic>
	assert(r <= PGSIZE);
  803113:	68 96 47 80 00       	push   $0x804796
  803118:	68 bd 3d 80 00       	push   $0x803dbd
  80311d:	6a 7c                	push   $0x7c
  80311f:	68 8b 47 80 00       	push   $0x80478b
  803124:	e8 32 ea ff ff       	call   801b5b <_panic>

00803129 <open>:
{
  803129:	55                   	push   %ebp
  80312a:	89 e5                	mov    %esp,%ebp
  80312c:	56                   	push   %esi
  80312d:	53                   	push   %ebx
  80312e:	83 ec 1c             	sub    $0x1c,%esp
  803131:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  803134:	56                   	push   %esi
  803135:	e8 e4 f0 ff ff       	call   80221e <strlen>
  80313a:	83 c4 10             	add    $0x10,%esp
  80313d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803142:	7f 6c                	jg     8031b0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  803144:	83 ec 0c             	sub    $0xc,%esp
  803147:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80314a:	50                   	push   %eax
  80314b:	e8 b4 f8 ff ff       	call   802a04 <fd_alloc>
  803150:	89 c3                	mov    %eax,%ebx
  803152:	83 c4 10             	add    $0x10,%esp
  803155:	85 c0                	test   %eax,%eax
  803157:	78 3c                	js     803195 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  803159:	83 ec 08             	sub    $0x8,%esp
  80315c:	56                   	push   %esi
  80315d:	68 00 b0 80 00       	push   $0x80b000
  803162:	e8 ee f0 ff ff       	call   802255 <strcpy>
	fsipcbuf.open.req_omode = mode;
  803167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316a:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80316f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803172:	b8 01 00 00 00       	mov    $0x1,%eax
  803177:	e8 f3 fd ff ff       	call   802f6f <fsipc>
  80317c:	89 c3                	mov    %eax,%ebx
  80317e:	83 c4 10             	add    $0x10,%esp
  803181:	85 c0                	test   %eax,%eax
  803183:	78 19                	js     80319e <open+0x75>
	return fd2num(fd);
  803185:	83 ec 0c             	sub    $0xc,%esp
  803188:	ff 75 f4             	pushl  -0xc(%ebp)
  80318b:	e8 4d f8 ff ff       	call   8029dd <fd2num>
  803190:	89 c3                	mov    %eax,%ebx
  803192:	83 c4 10             	add    $0x10,%esp
}
  803195:	89 d8                	mov    %ebx,%eax
  803197:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80319a:	5b                   	pop    %ebx
  80319b:	5e                   	pop    %esi
  80319c:	5d                   	pop    %ebp
  80319d:	c3                   	ret    
		fd_close(fd, 0);
  80319e:	83 ec 08             	sub    $0x8,%esp
  8031a1:	6a 00                	push   $0x0
  8031a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8031a6:	e8 54 f9 ff ff       	call   802aff <fd_close>
		return r;
  8031ab:	83 c4 10             	add    $0x10,%esp
  8031ae:	eb e5                	jmp    803195 <open+0x6c>
		return -E_BAD_PATH;
  8031b0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8031b5:	eb de                	jmp    803195 <open+0x6c>

008031b7 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8031b7:	55                   	push   %ebp
  8031b8:	89 e5                	mov    %esp,%ebp
  8031ba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8031bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8031c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8031c7:	e8 a3 fd ff ff       	call   802f6f <fsipc>
}
  8031cc:	c9                   	leave  
  8031cd:	c3                   	ret    

008031ce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8031ce:	55                   	push   %ebp
  8031cf:	89 e5                	mov    %esp,%ebp
  8031d1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8031d4:	89 d0                	mov    %edx,%eax
  8031d6:	c1 e8 16             	shr    $0x16,%eax
  8031d9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8031e0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8031e5:	f6 c1 01             	test   $0x1,%cl
  8031e8:	74 1d                	je     803207 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8031ea:	c1 ea 0c             	shr    $0xc,%edx
  8031ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8031f4:	f6 c2 01             	test   $0x1,%dl
  8031f7:	74 0e                	je     803207 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8031f9:	c1 ea 0c             	shr    $0xc,%edx
  8031fc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803203:	ef 
  803204:	0f b7 c0             	movzwl %ax,%eax
}
  803207:	5d                   	pop    %ebp
  803208:	c3                   	ret    

00803209 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803209:	55                   	push   %ebp
  80320a:	89 e5                	mov    %esp,%ebp
  80320c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80320f:	68 a2 47 80 00       	push   $0x8047a2
  803214:	ff 75 0c             	pushl  0xc(%ebp)
  803217:	e8 39 f0 ff ff       	call   802255 <strcpy>
	return 0;
}
  80321c:	b8 00 00 00 00       	mov    $0x0,%eax
  803221:	c9                   	leave  
  803222:	c3                   	ret    

00803223 <devsock_close>:
{
  803223:	55                   	push   %ebp
  803224:	89 e5                	mov    %esp,%ebp
  803226:	53                   	push   %ebx
  803227:	83 ec 10             	sub    $0x10,%esp
  80322a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80322d:	53                   	push   %ebx
  80322e:	e8 9b ff ff ff       	call   8031ce <pageref>
  803233:	83 c4 10             	add    $0x10,%esp
		return 0;
  803236:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80323b:	83 f8 01             	cmp    $0x1,%eax
  80323e:	74 07                	je     803247 <devsock_close+0x24>
}
  803240:	89 d0                	mov    %edx,%eax
  803242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803245:	c9                   	leave  
  803246:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  803247:	83 ec 0c             	sub    $0xc,%esp
  80324a:	ff 73 0c             	pushl  0xc(%ebx)
  80324d:	e8 b7 02 00 00       	call   803509 <nsipc_close>
  803252:	89 c2                	mov    %eax,%edx
  803254:	83 c4 10             	add    $0x10,%esp
  803257:	eb e7                	jmp    803240 <devsock_close+0x1d>

00803259 <devsock_write>:
{
  803259:	55                   	push   %ebp
  80325a:	89 e5                	mov    %esp,%ebp
  80325c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80325f:	6a 00                	push   $0x0
  803261:	ff 75 10             	pushl  0x10(%ebp)
  803264:	ff 75 0c             	pushl  0xc(%ebp)
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	ff 70 0c             	pushl  0xc(%eax)
  80326d:	e8 74 03 00 00       	call   8035e6 <nsipc_send>
}
  803272:	c9                   	leave  
  803273:	c3                   	ret    

00803274 <devsock_read>:
{
  803274:	55                   	push   %ebp
  803275:	89 e5                	mov    %esp,%ebp
  803277:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80327a:	6a 00                	push   $0x0
  80327c:	ff 75 10             	pushl  0x10(%ebp)
  80327f:	ff 75 0c             	pushl  0xc(%ebp)
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	ff 70 0c             	pushl  0xc(%eax)
  803288:	e8 ed 02 00 00       	call   80357a <nsipc_recv>
}
  80328d:	c9                   	leave  
  80328e:	c3                   	ret    

0080328f <fd2sockid>:
{
  80328f:	55                   	push   %ebp
  803290:	89 e5                	mov    %esp,%ebp
  803292:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  803295:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803298:	52                   	push   %edx
  803299:	50                   	push   %eax
  80329a:	e8 b4 f7 ff ff       	call   802a53 <fd_lookup>
  80329f:	83 c4 10             	add    $0x10,%esp
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	78 10                	js     8032b6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  8032af:	39 08                	cmp    %ecx,(%eax)
  8032b1:	75 05                	jne    8032b8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8032b3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8032b6:	c9                   	leave  
  8032b7:	c3                   	ret    
		return -E_NOT_SUPP;
  8032b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8032bd:	eb f7                	jmp    8032b6 <fd2sockid+0x27>

008032bf <alloc_sockfd>:
{
  8032bf:	55                   	push   %ebp
  8032c0:	89 e5                	mov    %esp,%ebp
  8032c2:	56                   	push   %esi
  8032c3:	53                   	push   %ebx
  8032c4:	83 ec 1c             	sub    $0x1c,%esp
  8032c7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8032c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032cc:	50                   	push   %eax
  8032cd:	e8 32 f7 ff ff       	call   802a04 <fd_alloc>
  8032d2:	89 c3                	mov    %eax,%ebx
  8032d4:	83 c4 10             	add    $0x10,%esp
  8032d7:	85 c0                	test   %eax,%eax
  8032d9:	78 43                	js     80331e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8032db:	83 ec 04             	sub    $0x4,%esp
  8032de:	68 07 04 00 00       	push   $0x407
  8032e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8032e6:	6a 00                	push   $0x0
  8032e8:	e8 61 f3 ff ff       	call   80264e <sys_page_alloc>
  8032ed:	89 c3                	mov    %eax,%ebx
  8032ef:	83 c4 10             	add    $0x10,%esp
  8032f2:	85 c0                	test   %eax,%eax
  8032f4:	78 28                	js     80331e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 15 80 90 80 00    	mov    0x809080,%edx
  8032ff:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803304:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80330b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80330e:	83 ec 0c             	sub    $0xc,%esp
  803311:	50                   	push   %eax
  803312:	e8 c6 f6 ff ff       	call   8029dd <fd2num>
  803317:	89 c3                	mov    %eax,%ebx
  803319:	83 c4 10             	add    $0x10,%esp
  80331c:	eb 0c                	jmp    80332a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80331e:	83 ec 0c             	sub    $0xc,%esp
  803321:	56                   	push   %esi
  803322:	e8 e2 01 00 00       	call   803509 <nsipc_close>
		return r;
  803327:	83 c4 10             	add    $0x10,%esp
}
  80332a:	89 d8                	mov    %ebx,%eax
  80332c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80332f:	5b                   	pop    %ebx
  803330:	5e                   	pop    %esi
  803331:	5d                   	pop    %ebp
  803332:	c3                   	ret    

00803333 <accept>:
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
  803336:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	e8 4e ff ff ff       	call   80328f <fd2sockid>
  803341:	85 c0                	test   %eax,%eax
  803343:	78 1b                	js     803360 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	ff 75 10             	pushl  0x10(%ebp)
  80334b:	ff 75 0c             	pushl  0xc(%ebp)
  80334e:	50                   	push   %eax
  80334f:	e8 0e 01 00 00       	call   803462 <nsipc_accept>
  803354:	83 c4 10             	add    $0x10,%esp
  803357:	85 c0                	test   %eax,%eax
  803359:	78 05                	js     803360 <accept+0x2d>
	return alloc_sockfd(r);
  80335b:	e8 5f ff ff ff       	call   8032bf <alloc_sockfd>
}
  803360:	c9                   	leave  
  803361:	c3                   	ret    

00803362 <bind>:
{
  803362:	55                   	push   %ebp
  803363:	89 e5                	mov    %esp,%ebp
  803365:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	e8 1f ff ff ff       	call   80328f <fd2sockid>
  803370:	85 c0                	test   %eax,%eax
  803372:	78 12                	js     803386 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	ff 75 10             	pushl  0x10(%ebp)
  80337a:	ff 75 0c             	pushl  0xc(%ebp)
  80337d:	50                   	push   %eax
  80337e:	e8 2f 01 00 00       	call   8034b2 <nsipc_bind>
  803383:	83 c4 10             	add    $0x10,%esp
}
  803386:	c9                   	leave  
  803387:	c3                   	ret    

00803388 <shutdown>:
{
  803388:	55                   	push   %ebp
  803389:	89 e5                	mov    %esp,%ebp
  80338b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	e8 f9 fe ff ff       	call   80328f <fd2sockid>
  803396:	85 c0                	test   %eax,%eax
  803398:	78 0f                	js     8033a9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80339a:	83 ec 08             	sub    $0x8,%esp
  80339d:	ff 75 0c             	pushl  0xc(%ebp)
  8033a0:	50                   	push   %eax
  8033a1:	e8 41 01 00 00       	call   8034e7 <nsipc_shutdown>
  8033a6:	83 c4 10             	add    $0x10,%esp
}
  8033a9:	c9                   	leave  
  8033aa:	c3                   	ret    

008033ab <connect>:
{
  8033ab:	55                   	push   %ebp
  8033ac:	89 e5                	mov    %esp,%ebp
  8033ae:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	e8 d6 fe ff ff       	call   80328f <fd2sockid>
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	78 12                	js     8033cf <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8033bd:	83 ec 04             	sub    $0x4,%esp
  8033c0:	ff 75 10             	pushl  0x10(%ebp)
  8033c3:	ff 75 0c             	pushl  0xc(%ebp)
  8033c6:	50                   	push   %eax
  8033c7:	e8 57 01 00 00       	call   803523 <nsipc_connect>
  8033cc:	83 c4 10             	add    $0x10,%esp
}
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <listen>:
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	e8 b0 fe ff ff       	call   80328f <fd2sockid>
  8033df:	85 c0                	test   %eax,%eax
  8033e1:	78 0f                	js     8033f2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8033e3:	83 ec 08             	sub    $0x8,%esp
  8033e6:	ff 75 0c             	pushl  0xc(%ebp)
  8033e9:	50                   	push   %eax
  8033ea:	e8 69 01 00 00       	call   803558 <nsipc_listen>
  8033ef:	83 c4 10             	add    $0x10,%esp
}
  8033f2:	c9                   	leave  
  8033f3:	c3                   	ret    

008033f4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8033f4:	55                   	push   %ebp
  8033f5:	89 e5                	mov    %esp,%ebp
  8033f7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8033fa:	ff 75 10             	pushl  0x10(%ebp)
  8033fd:	ff 75 0c             	pushl  0xc(%ebp)
  803400:	ff 75 08             	pushl  0x8(%ebp)
  803403:	e8 3c 02 00 00       	call   803644 <nsipc_socket>
  803408:	83 c4 10             	add    $0x10,%esp
  80340b:	85 c0                	test   %eax,%eax
  80340d:	78 05                	js     803414 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80340f:	e8 ab fe ff ff       	call   8032bf <alloc_sockfd>
}
  803414:	c9                   	leave  
  803415:	c3                   	ret    

00803416 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803416:	55                   	push   %ebp
  803417:	89 e5                	mov    %esp,%ebp
  803419:	53                   	push   %ebx
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80341f:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  803426:	74 26                	je     80344e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803428:	6a 07                	push   $0x7
  80342a:	68 00 c0 80 00       	push   $0x80c000
  80342f:	53                   	push   %ebx
  803430:	ff 35 04 a0 80 00    	pushl  0x80a004
  803436:	e8 15 f5 ff ff       	call   802950 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80343b:	83 c4 0c             	add    $0xc,%esp
  80343e:	6a 00                	push   $0x0
  803440:	6a 00                	push   $0x0
  803442:	6a 00                	push   $0x0
  803444:	e8 a0 f4 ff ff       	call   8028e9 <ipc_recv>
}
  803449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80344c:	c9                   	leave  
  80344d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80344e:	83 ec 0c             	sub    $0xc,%esp
  803451:	6a 02                	push   $0x2
  803453:	e8 4c f5 ff ff       	call   8029a4 <ipc_find_env>
  803458:	a3 04 a0 80 00       	mov    %eax,0x80a004
  80345d:	83 c4 10             	add    $0x10,%esp
  803460:	eb c6                	jmp    803428 <nsipc+0x12>

00803462 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803462:	55                   	push   %ebp
  803463:	89 e5                	mov    %esp,%ebp
  803465:	56                   	push   %esi
  803466:	53                   	push   %ebx
  803467:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803472:	8b 06                	mov    (%esi),%eax
  803474:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803479:	b8 01 00 00 00       	mov    $0x1,%eax
  80347e:	e8 93 ff ff ff       	call   803416 <nsipc>
  803483:	89 c3                	mov    %eax,%ebx
  803485:	85 c0                	test   %eax,%eax
  803487:	78 20                	js     8034a9 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803489:	83 ec 04             	sub    $0x4,%esp
  80348c:	ff 35 10 c0 80 00    	pushl  0x80c010
  803492:	68 00 c0 80 00       	push   $0x80c000
  803497:	ff 75 0c             	pushl  0xc(%ebp)
  80349a:	e8 44 ef ff ff       	call   8023e3 <memmove>
		*addrlen = ret->ret_addrlen;
  80349f:	a1 10 c0 80 00       	mov    0x80c010,%eax
  8034a4:	89 06                	mov    %eax,(%esi)
  8034a6:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8034a9:	89 d8                	mov    %ebx,%eax
  8034ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8034ae:	5b                   	pop    %ebx
  8034af:	5e                   	pop    %esi
  8034b0:	5d                   	pop    %ebp
  8034b1:	c3                   	ret    

008034b2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034b2:	55                   	push   %ebp
  8034b3:	89 e5                	mov    %esp,%ebp
  8034b5:	53                   	push   %ebx
  8034b6:	83 ec 08             	sub    $0x8,%esp
  8034b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8034bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bf:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8034c4:	53                   	push   %ebx
  8034c5:	ff 75 0c             	pushl  0xc(%ebp)
  8034c8:	68 04 c0 80 00       	push   $0x80c004
  8034cd:	e8 11 ef ff ff       	call   8023e3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8034d2:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  8034d8:	b8 02 00 00 00       	mov    $0x2,%eax
  8034dd:	e8 34 ff ff ff       	call   803416 <nsipc>
}
  8034e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8034e5:	c9                   	leave  
  8034e6:	c3                   	ret    

008034e7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8034e7:	55                   	push   %ebp
  8034e8:	89 e5                	mov    %esp,%ebp
  8034ea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  8034f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034f8:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  8034fd:	b8 03 00 00 00       	mov    $0x3,%eax
  803502:	e8 0f ff ff ff       	call   803416 <nsipc>
}
  803507:	c9                   	leave  
  803508:	c3                   	ret    

00803509 <nsipc_close>:

int
nsipc_close(int s)
{
  803509:	55                   	push   %ebp
  80350a:	89 e5                	mov    %esp,%ebp
  80350c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80350f:	8b 45 08             	mov    0x8(%ebp),%eax
  803512:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803517:	b8 04 00 00 00       	mov    $0x4,%eax
  80351c:	e8 f5 fe ff ff       	call   803416 <nsipc>
}
  803521:	c9                   	leave  
  803522:	c3                   	ret    

00803523 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803523:	55                   	push   %ebp
  803524:	89 e5                	mov    %esp,%ebp
  803526:	53                   	push   %ebx
  803527:	83 ec 08             	sub    $0x8,%esp
  80352a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803535:	53                   	push   %ebx
  803536:	ff 75 0c             	pushl  0xc(%ebp)
  803539:	68 04 c0 80 00       	push   $0x80c004
  80353e:	e8 a0 ee ff ff       	call   8023e3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803543:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803549:	b8 05 00 00 00       	mov    $0x5,%eax
  80354e:	e8 c3 fe ff ff       	call   803416 <nsipc>
}
  803553:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803556:	c9                   	leave  
  803557:	c3                   	ret    

00803558 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803558:	55                   	push   %ebp
  803559:	89 e5                	mov    %esp,%ebp
  80355b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803566:	8b 45 0c             	mov    0xc(%ebp),%eax
  803569:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  80356e:	b8 06 00 00 00       	mov    $0x6,%eax
  803573:	e8 9e fe ff ff       	call   803416 <nsipc>
}
  803578:	c9                   	leave  
  803579:	c3                   	ret    

0080357a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80357a:	55                   	push   %ebp
  80357b:	89 e5                	mov    %esp,%ebp
  80357d:	56                   	push   %esi
  80357e:	53                   	push   %ebx
  80357f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  80358a:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803590:	8b 45 14             	mov    0x14(%ebp),%eax
  803593:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803598:	b8 07 00 00 00       	mov    $0x7,%eax
  80359d:	e8 74 fe ff ff       	call   803416 <nsipc>
  8035a2:	89 c3                	mov    %eax,%ebx
  8035a4:	85 c0                	test   %eax,%eax
  8035a6:	78 1f                	js     8035c7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8035a8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8035ad:	7f 21                	jg     8035d0 <nsipc_recv+0x56>
  8035af:	39 c6                	cmp    %eax,%esi
  8035b1:	7c 1d                	jl     8035d0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8035b3:	83 ec 04             	sub    $0x4,%esp
  8035b6:	50                   	push   %eax
  8035b7:	68 00 c0 80 00       	push   $0x80c000
  8035bc:	ff 75 0c             	pushl  0xc(%ebp)
  8035bf:	e8 1f ee ff ff       	call   8023e3 <memmove>
  8035c4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8035c7:	89 d8                	mov    %ebx,%eax
  8035c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8035cc:	5b                   	pop    %ebx
  8035cd:	5e                   	pop    %esi
  8035ce:	5d                   	pop    %ebp
  8035cf:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8035d0:	68 ae 47 80 00       	push   $0x8047ae
  8035d5:	68 bd 3d 80 00       	push   $0x803dbd
  8035da:	6a 62                	push   $0x62
  8035dc:	68 c3 47 80 00       	push   $0x8047c3
  8035e1:	e8 75 e5 ff ff       	call   801b5b <_panic>

008035e6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8035e6:	55                   	push   %ebp
  8035e7:	89 e5                	mov    %esp,%ebp
  8035e9:	53                   	push   %ebx
  8035ea:	83 ec 04             	sub    $0x4,%esp
  8035ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  8035f8:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8035fe:	7f 2e                	jg     80362e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803600:	83 ec 04             	sub    $0x4,%esp
  803603:	53                   	push   %ebx
  803604:	ff 75 0c             	pushl  0xc(%ebp)
  803607:	68 0c c0 80 00       	push   $0x80c00c
  80360c:	e8 d2 ed ff ff       	call   8023e3 <memmove>
	nsipcbuf.send.req_size = size;
  803611:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803617:	8b 45 14             	mov    0x14(%ebp),%eax
  80361a:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  80361f:	b8 08 00 00 00       	mov    $0x8,%eax
  803624:	e8 ed fd ff ff       	call   803416 <nsipc>
}
  803629:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80362c:	c9                   	leave  
  80362d:	c3                   	ret    
	assert(size < 1600);
  80362e:	68 cf 47 80 00       	push   $0x8047cf
  803633:	68 bd 3d 80 00       	push   $0x803dbd
  803638:	6a 6d                	push   $0x6d
  80363a:	68 c3 47 80 00       	push   $0x8047c3
  80363f:	e8 17 e5 ff ff       	call   801b5b <_panic>

00803644 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803644:	55                   	push   %ebp
  803645:	89 e5                	mov    %esp,%ebp
  803647:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80364a:	8b 45 08             	mov    0x8(%ebp),%eax
  80364d:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803652:	8b 45 0c             	mov    0xc(%ebp),%eax
  803655:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  80365a:	8b 45 10             	mov    0x10(%ebp),%eax
  80365d:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803662:	b8 09 00 00 00       	mov    $0x9,%eax
  803667:	e8 aa fd ff ff       	call   803416 <nsipc>
}
  80366c:	c9                   	leave  
  80366d:	c3                   	ret    

0080366e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80366e:	55                   	push   %ebp
  80366f:	89 e5                	mov    %esp,%ebp
  803671:	56                   	push   %esi
  803672:	53                   	push   %ebx
  803673:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803676:	83 ec 0c             	sub    $0xc,%esp
  803679:	ff 75 08             	pushl  0x8(%ebp)
  80367c:	e8 6c f3 ff ff       	call   8029ed <fd2data>
  803681:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803683:	83 c4 08             	add    $0x8,%esp
  803686:	68 db 47 80 00       	push   $0x8047db
  80368b:	53                   	push   %ebx
  80368c:	e8 c4 eb ff ff       	call   802255 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803691:	8b 46 04             	mov    0x4(%esi),%eax
  803694:	2b 06                	sub    (%esi),%eax
  803696:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80369c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8036a3:	00 00 00 
	stat->st_dev = &devpipe;
  8036a6:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  8036ad:	90 80 00 
	return 0;
}
  8036b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8036b8:	5b                   	pop    %ebx
  8036b9:	5e                   	pop    %esi
  8036ba:	5d                   	pop    %ebp
  8036bb:	c3                   	ret    

008036bc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8036bc:	55                   	push   %ebp
  8036bd:	89 e5                	mov    %esp,%ebp
  8036bf:	53                   	push   %ebx
  8036c0:	83 ec 0c             	sub    $0xc,%esp
  8036c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8036c6:	53                   	push   %ebx
  8036c7:	6a 00                	push   $0x0
  8036c9:	e8 05 f0 ff ff       	call   8026d3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8036ce:	89 1c 24             	mov    %ebx,(%esp)
  8036d1:	e8 17 f3 ff ff       	call   8029ed <fd2data>
  8036d6:	83 c4 08             	add    $0x8,%esp
  8036d9:	50                   	push   %eax
  8036da:	6a 00                	push   $0x0
  8036dc:	e8 f2 ef ff ff       	call   8026d3 <sys_page_unmap>
}
  8036e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8036e4:	c9                   	leave  
  8036e5:	c3                   	ret    

008036e6 <_pipeisclosed>:
{
  8036e6:	55                   	push   %ebp
  8036e7:	89 e5                	mov    %esp,%ebp
  8036e9:	57                   	push   %edi
  8036ea:	56                   	push   %esi
  8036eb:	53                   	push   %ebx
  8036ec:	83 ec 1c             	sub    $0x1c,%esp
  8036ef:	89 c7                	mov    %eax,%edi
  8036f1:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8036f3:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8036f8:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8036fb:	83 ec 0c             	sub    $0xc,%esp
  8036fe:	57                   	push   %edi
  8036ff:	e8 ca fa ff ff       	call   8031ce <pageref>
  803704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803707:	89 34 24             	mov    %esi,(%esp)
  80370a:	e8 bf fa ff ff       	call   8031ce <pageref>
		nn = thisenv->env_runs;
  80370f:	8b 15 10 a0 80 00    	mov    0x80a010,%edx
  803715:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803718:	83 c4 10             	add    $0x10,%esp
  80371b:	39 cb                	cmp    %ecx,%ebx
  80371d:	74 1b                	je     80373a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80371f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803722:	75 cf                	jne    8036f3 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803724:	8b 42 58             	mov    0x58(%edx),%eax
  803727:	6a 01                	push   $0x1
  803729:	50                   	push   %eax
  80372a:	53                   	push   %ebx
  80372b:	68 e2 47 80 00       	push   $0x8047e2
  803730:	e8 01 e5 ff ff       	call   801c36 <cprintf>
  803735:	83 c4 10             	add    $0x10,%esp
  803738:	eb b9                	jmp    8036f3 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80373a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80373d:	0f 94 c0             	sete   %al
  803740:	0f b6 c0             	movzbl %al,%eax
}
  803743:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803746:	5b                   	pop    %ebx
  803747:	5e                   	pop    %esi
  803748:	5f                   	pop    %edi
  803749:	5d                   	pop    %ebp
  80374a:	c3                   	ret    

0080374b <devpipe_write>:
{
  80374b:	55                   	push   %ebp
  80374c:	89 e5                	mov    %esp,%ebp
  80374e:	57                   	push   %edi
  80374f:	56                   	push   %esi
  803750:	53                   	push   %ebx
  803751:	83 ec 28             	sub    $0x28,%esp
  803754:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  803757:	56                   	push   %esi
  803758:	e8 90 f2 ff ff       	call   8029ed <fd2data>
  80375d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80375f:	83 c4 10             	add    $0x10,%esp
  803762:	bf 00 00 00 00       	mov    $0x0,%edi
  803767:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80376a:	74 4f                	je     8037bb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80376c:	8b 43 04             	mov    0x4(%ebx),%eax
  80376f:	8b 0b                	mov    (%ebx),%ecx
  803771:	8d 51 20             	lea    0x20(%ecx),%edx
  803774:	39 d0                	cmp    %edx,%eax
  803776:	72 14                	jb     80378c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  803778:	89 da                	mov    %ebx,%edx
  80377a:	89 f0                	mov    %esi,%eax
  80377c:	e8 65 ff ff ff       	call   8036e6 <_pipeisclosed>
  803781:	85 c0                	test   %eax,%eax
  803783:	75 3a                	jne    8037bf <devpipe_write+0x74>
			sys_yield();
  803785:	e8 a5 ee ff ff       	call   80262f <sys_yield>
  80378a:	eb e0                	jmp    80376c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80378c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80378f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803793:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803796:	89 c2                	mov    %eax,%edx
  803798:	c1 fa 1f             	sar    $0x1f,%edx
  80379b:	89 d1                	mov    %edx,%ecx
  80379d:	c1 e9 1b             	shr    $0x1b,%ecx
  8037a0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8037a3:	83 e2 1f             	and    $0x1f,%edx
  8037a6:	29 ca                	sub    %ecx,%edx
  8037a8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8037ac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8037b0:	83 c0 01             	add    $0x1,%eax
  8037b3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8037b6:	83 c7 01             	add    $0x1,%edi
  8037b9:	eb ac                	jmp    803767 <devpipe_write+0x1c>
	return i;
  8037bb:	89 f8                	mov    %edi,%eax
  8037bd:	eb 05                	jmp    8037c4 <devpipe_write+0x79>
				return 0;
  8037bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8037c7:	5b                   	pop    %ebx
  8037c8:	5e                   	pop    %esi
  8037c9:	5f                   	pop    %edi
  8037ca:	5d                   	pop    %ebp
  8037cb:	c3                   	ret    

008037cc <devpipe_read>:
{
  8037cc:	55                   	push   %ebp
  8037cd:	89 e5                	mov    %esp,%ebp
  8037cf:	57                   	push   %edi
  8037d0:	56                   	push   %esi
  8037d1:	53                   	push   %ebx
  8037d2:	83 ec 18             	sub    $0x18,%esp
  8037d5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8037d8:	57                   	push   %edi
  8037d9:	e8 0f f2 ff ff       	call   8029ed <fd2data>
  8037de:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8037e0:	83 c4 10             	add    $0x10,%esp
  8037e3:	be 00 00 00 00       	mov    $0x0,%esi
  8037e8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8037eb:	74 47                	je     803834 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8037ed:	8b 03                	mov    (%ebx),%eax
  8037ef:	3b 43 04             	cmp    0x4(%ebx),%eax
  8037f2:	75 22                	jne    803816 <devpipe_read+0x4a>
			if (i > 0)
  8037f4:	85 f6                	test   %esi,%esi
  8037f6:	75 14                	jne    80380c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8037f8:	89 da                	mov    %ebx,%edx
  8037fa:	89 f8                	mov    %edi,%eax
  8037fc:	e8 e5 fe ff ff       	call   8036e6 <_pipeisclosed>
  803801:	85 c0                	test   %eax,%eax
  803803:	75 33                	jne    803838 <devpipe_read+0x6c>
			sys_yield();
  803805:	e8 25 ee ff ff       	call   80262f <sys_yield>
  80380a:	eb e1                	jmp    8037ed <devpipe_read+0x21>
				return i;
  80380c:	89 f0                	mov    %esi,%eax
}
  80380e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803811:	5b                   	pop    %ebx
  803812:	5e                   	pop    %esi
  803813:	5f                   	pop    %edi
  803814:	5d                   	pop    %ebp
  803815:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803816:	99                   	cltd   
  803817:	c1 ea 1b             	shr    $0x1b,%edx
  80381a:	01 d0                	add    %edx,%eax
  80381c:	83 e0 1f             	and    $0x1f,%eax
  80381f:	29 d0                	sub    %edx,%eax
  803821:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803826:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803829:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80382c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  80382f:	83 c6 01             	add    $0x1,%esi
  803832:	eb b4                	jmp    8037e8 <devpipe_read+0x1c>
	return i;
  803834:	89 f0                	mov    %esi,%eax
  803836:	eb d6                	jmp    80380e <devpipe_read+0x42>
				return 0;
  803838:	b8 00 00 00 00       	mov    $0x0,%eax
  80383d:	eb cf                	jmp    80380e <devpipe_read+0x42>

0080383f <pipe>:
{
  80383f:	55                   	push   %ebp
  803840:	89 e5                	mov    %esp,%ebp
  803842:	56                   	push   %esi
  803843:	53                   	push   %ebx
  803844:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  803847:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80384a:	50                   	push   %eax
  80384b:	e8 b4 f1 ff ff       	call   802a04 <fd_alloc>
  803850:	89 c3                	mov    %eax,%ebx
  803852:	83 c4 10             	add    $0x10,%esp
  803855:	85 c0                	test   %eax,%eax
  803857:	78 5b                	js     8038b4 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803859:	83 ec 04             	sub    $0x4,%esp
  80385c:	68 07 04 00 00       	push   $0x407
  803861:	ff 75 f4             	pushl  -0xc(%ebp)
  803864:	6a 00                	push   $0x0
  803866:	e8 e3 ed ff ff       	call   80264e <sys_page_alloc>
  80386b:	89 c3                	mov    %eax,%ebx
  80386d:	83 c4 10             	add    $0x10,%esp
  803870:	85 c0                	test   %eax,%eax
  803872:	78 40                	js     8038b4 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  803874:	83 ec 0c             	sub    $0xc,%esp
  803877:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80387a:	50                   	push   %eax
  80387b:	e8 84 f1 ff ff       	call   802a04 <fd_alloc>
  803880:	89 c3                	mov    %eax,%ebx
  803882:	83 c4 10             	add    $0x10,%esp
  803885:	85 c0                	test   %eax,%eax
  803887:	78 1b                	js     8038a4 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803889:	83 ec 04             	sub    $0x4,%esp
  80388c:	68 07 04 00 00       	push   $0x407
  803891:	ff 75 f0             	pushl  -0x10(%ebp)
  803894:	6a 00                	push   $0x0
  803896:	e8 b3 ed ff ff       	call   80264e <sys_page_alloc>
  80389b:	89 c3                	mov    %eax,%ebx
  80389d:	83 c4 10             	add    $0x10,%esp
  8038a0:	85 c0                	test   %eax,%eax
  8038a2:	79 19                	jns    8038bd <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8038a4:	83 ec 08             	sub    $0x8,%esp
  8038a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8038aa:	6a 00                	push   $0x0
  8038ac:	e8 22 ee ff ff       	call   8026d3 <sys_page_unmap>
  8038b1:	83 c4 10             	add    $0x10,%esp
}
  8038b4:	89 d8                	mov    %ebx,%eax
  8038b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8038b9:	5b                   	pop    %ebx
  8038ba:	5e                   	pop    %esi
  8038bb:	5d                   	pop    %ebp
  8038bc:	c3                   	ret    
	va = fd2data(fd0);
  8038bd:	83 ec 0c             	sub    $0xc,%esp
  8038c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8038c3:	e8 25 f1 ff ff       	call   8029ed <fd2data>
  8038c8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038ca:	83 c4 0c             	add    $0xc,%esp
  8038cd:	68 07 04 00 00       	push   $0x407
  8038d2:	50                   	push   %eax
  8038d3:	6a 00                	push   $0x0
  8038d5:	e8 74 ed ff ff       	call   80264e <sys_page_alloc>
  8038da:	89 c3                	mov    %eax,%ebx
  8038dc:	83 c4 10             	add    $0x10,%esp
  8038df:	85 c0                	test   %eax,%eax
  8038e1:	0f 88 8c 00 00 00    	js     803973 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8038e7:	83 ec 0c             	sub    $0xc,%esp
  8038ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8038ed:	e8 fb f0 ff ff       	call   8029ed <fd2data>
  8038f2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8038f9:	50                   	push   %eax
  8038fa:	6a 00                	push   $0x0
  8038fc:	56                   	push   %esi
  8038fd:	6a 00                	push   $0x0
  8038ff:	e8 8d ed ff ff       	call   802691 <sys_page_map>
  803904:	89 c3                	mov    %eax,%ebx
  803906:	83 c4 20             	add    $0x20,%esp
  803909:	85 c0                	test   %eax,%eax
  80390b:	78 58                	js     803965 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  80390d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803910:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803916:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  803922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803925:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  80392b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80392d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803930:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803937:	83 ec 0c             	sub    $0xc,%esp
  80393a:	ff 75 f4             	pushl  -0xc(%ebp)
  80393d:	e8 9b f0 ff ff       	call   8029dd <fd2num>
  803942:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803945:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803947:	83 c4 04             	add    $0x4,%esp
  80394a:	ff 75 f0             	pushl  -0x10(%ebp)
  80394d:	e8 8b f0 ff ff       	call   8029dd <fd2num>
  803952:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803955:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803958:	83 c4 10             	add    $0x10,%esp
  80395b:	bb 00 00 00 00       	mov    $0x0,%ebx
  803960:	e9 4f ff ff ff       	jmp    8038b4 <pipe+0x75>
	sys_page_unmap(0, va);
  803965:	83 ec 08             	sub    $0x8,%esp
  803968:	56                   	push   %esi
  803969:	6a 00                	push   $0x0
  80396b:	e8 63 ed ff ff       	call   8026d3 <sys_page_unmap>
  803970:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  803973:	83 ec 08             	sub    $0x8,%esp
  803976:	ff 75 f0             	pushl  -0x10(%ebp)
  803979:	6a 00                	push   $0x0
  80397b:	e8 53 ed ff ff       	call   8026d3 <sys_page_unmap>
  803980:	83 c4 10             	add    $0x10,%esp
  803983:	e9 1c ff ff ff       	jmp    8038a4 <pipe+0x65>

00803988 <pipeisclosed>:
{
  803988:	55                   	push   %ebp
  803989:	89 e5                	mov    %esp,%ebp
  80398b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80398e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803991:	50                   	push   %eax
  803992:	ff 75 08             	pushl  0x8(%ebp)
  803995:	e8 b9 f0 ff ff       	call   802a53 <fd_lookup>
  80399a:	83 c4 10             	add    $0x10,%esp
  80399d:	85 c0                	test   %eax,%eax
  80399f:	78 18                	js     8039b9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8039a1:	83 ec 0c             	sub    $0xc,%esp
  8039a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8039a7:	e8 41 f0 ff ff       	call   8029ed <fd2data>
	return _pipeisclosed(fd, p);
  8039ac:	89 c2                	mov    %eax,%edx
  8039ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b1:	e8 30 fd ff ff       	call   8036e6 <_pipeisclosed>
  8039b6:	83 c4 10             	add    $0x10,%esp
}
  8039b9:	c9                   	leave  
  8039ba:	c3                   	ret    

008039bb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8039bb:	55                   	push   %ebp
  8039bc:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8039be:	b8 00 00 00 00       	mov    $0x0,%eax
  8039c3:	5d                   	pop    %ebp
  8039c4:	c3                   	ret    

008039c5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8039c5:	55                   	push   %ebp
  8039c6:	89 e5                	mov    %esp,%ebp
  8039c8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8039cb:	68 fa 47 80 00       	push   $0x8047fa
  8039d0:	ff 75 0c             	pushl  0xc(%ebp)
  8039d3:	e8 7d e8 ff ff       	call   802255 <strcpy>
	return 0;
}
  8039d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8039dd:	c9                   	leave  
  8039de:	c3                   	ret    

008039df <devcons_write>:
{
  8039df:	55                   	push   %ebp
  8039e0:	89 e5                	mov    %esp,%ebp
  8039e2:	57                   	push   %edi
  8039e3:	56                   	push   %esi
  8039e4:	53                   	push   %ebx
  8039e5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8039eb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8039f0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8039f6:	eb 2f                	jmp    803a27 <devcons_write+0x48>
		m = n - tot;
  8039f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8039fb:	29 f3                	sub    %esi,%ebx
  8039fd:	83 fb 7f             	cmp    $0x7f,%ebx
  803a00:	b8 7f 00 00 00       	mov    $0x7f,%eax
  803a05:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803a08:	83 ec 04             	sub    $0x4,%esp
  803a0b:	53                   	push   %ebx
  803a0c:	89 f0                	mov    %esi,%eax
  803a0e:	03 45 0c             	add    0xc(%ebp),%eax
  803a11:	50                   	push   %eax
  803a12:	57                   	push   %edi
  803a13:	e8 cb e9 ff ff       	call   8023e3 <memmove>
		sys_cputs(buf, m);
  803a18:	83 c4 08             	add    $0x8,%esp
  803a1b:	53                   	push   %ebx
  803a1c:	57                   	push   %edi
  803a1d:	e8 70 eb ff ff       	call   802592 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  803a22:	01 de                	add    %ebx,%esi
  803a24:	83 c4 10             	add    $0x10,%esp
  803a27:	3b 75 10             	cmp    0x10(%ebp),%esi
  803a2a:	72 cc                	jb     8039f8 <devcons_write+0x19>
}
  803a2c:	89 f0                	mov    %esi,%eax
  803a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803a31:	5b                   	pop    %ebx
  803a32:	5e                   	pop    %esi
  803a33:	5f                   	pop    %edi
  803a34:	5d                   	pop    %ebp
  803a35:	c3                   	ret    

00803a36 <devcons_read>:
{
  803a36:	55                   	push   %ebp
  803a37:	89 e5                	mov    %esp,%ebp
  803a39:	83 ec 08             	sub    $0x8,%esp
  803a3c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  803a41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803a45:	75 07                	jne    803a4e <devcons_read+0x18>
}
  803a47:	c9                   	leave  
  803a48:	c3                   	ret    
		sys_yield();
  803a49:	e8 e1 eb ff ff       	call   80262f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  803a4e:	e8 5d eb ff ff       	call   8025b0 <sys_cgetc>
  803a53:	85 c0                	test   %eax,%eax
  803a55:	74 f2                	je     803a49 <devcons_read+0x13>
	if (c < 0)
  803a57:	85 c0                	test   %eax,%eax
  803a59:	78 ec                	js     803a47 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  803a5b:	83 f8 04             	cmp    $0x4,%eax
  803a5e:	74 0c                	je     803a6c <devcons_read+0x36>
	*(char*)vbuf = c;
  803a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  803a63:	88 02                	mov    %al,(%edx)
	return 1;
  803a65:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6a:	eb db                	jmp    803a47 <devcons_read+0x11>
		return 0;
  803a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  803a71:	eb d4                	jmp    803a47 <devcons_read+0x11>

00803a73 <cputchar>:
{
  803a73:	55                   	push   %ebp
  803a74:	89 e5                	mov    %esp,%ebp
  803a76:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  803a79:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  803a7f:	6a 01                	push   $0x1
  803a81:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a84:	50                   	push   %eax
  803a85:	e8 08 eb ff ff       	call   802592 <sys_cputs>
}
  803a8a:	83 c4 10             	add    $0x10,%esp
  803a8d:	c9                   	leave  
  803a8e:	c3                   	ret    

00803a8f <getchar>:
{
  803a8f:	55                   	push   %ebp
  803a90:	89 e5                	mov    %esp,%ebp
  803a92:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  803a95:	6a 01                	push   $0x1
  803a97:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803a9a:	50                   	push   %eax
  803a9b:	6a 00                	push   $0x0
  803a9d:	e8 22 f2 ff ff       	call   802cc4 <read>
	if (r < 0)
  803aa2:	83 c4 10             	add    $0x10,%esp
  803aa5:	85 c0                	test   %eax,%eax
  803aa7:	78 08                	js     803ab1 <getchar+0x22>
	if (r < 1)
  803aa9:	85 c0                	test   %eax,%eax
  803aab:	7e 06                	jle    803ab3 <getchar+0x24>
	return c;
  803aad:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803ab1:	c9                   	leave  
  803ab2:	c3                   	ret    
		return -E_EOF;
  803ab3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803ab8:	eb f7                	jmp    803ab1 <getchar+0x22>

00803aba <iscons>:
{
  803aba:	55                   	push   %ebp
  803abb:	89 e5                	mov    %esp,%ebp
  803abd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803ac0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803ac3:	50                   	push   %eax
  803ac4:	ff 75 08             	pushl  0x8(%ebp)
  803ac7:	e8 87 ef ff ff       	call   802a53 <fd_lookup>
  803acc:	83 c4 10             	add    $0x10,%esp
  803acf:	85 c0                	test   %eax,%eax
  803ad1:	78 11                	js     803ae4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad6:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803adc:	39 10                	cmp    %edx,(%eax)
  803ade:	0f 94 c0             	sete   %al
  803ae1:	0f b6 c0             	movzbl %al,%eax
}
  803ae4:	c9                   	leave  
  803ae5:	c3                   	ret    

00803ae6 <opencons>:
{
  803ae6:	55                   	push   %ebp
  803ae7:	89 e5                	mov    %esp,%ebp
  803ae9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  803aec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803aef:	50                   	push   %eax
  803af0:	e8 0f ef ff ff       	call   802a04 <fd_alloc>
  803af5:	83 c4 10             	add    $0x10,%esp
  803af8:	85 c0                	test   %eax,%eax
  803afa:	78 3a                	js     803b36 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803afc:	83 ec 04             	sub    $0x4,%esp
  803aff:	68 07 04 00 00       	push   $0x407
  803b04:	ff 75 f4             	pushl  -0xc(%ebp)
  803b07:	6a 00                	push   $0x0
  803b09:	e8 40 eb ff ff       	call   80264e <sys_page_alloc>
  803b0e:	83 c4 10             	add    $0x10,%esp
  803b11:	85 c0                	test   %eax,%eax
  803b13:	78 21                	js     803b36 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b18:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  803b1e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  803b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b23:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803b2a:	83 ec 0c             	sub    $0xc,%esp
  803b2d:	50                   	push   %eax
  803b2e:	e8 aa ee ff ff       	call   8029dd <fd2num>
  803b33:	83 c4 10             	add    $0x10,%esp
}
  803b36:	c9                   	leave  
  803b37:	c3                   	ret    
  803b38:	66 90                	xchg   %ax,%ax
  803b3a:	66 90                	xchg   %ax,%ax
  803b3c:	66 90                	xchg   %ax,%ax
  803b3e:	66 90                	xchg   %ax,%ax

00803b40 <__udivdi3>:
  803b40:	55                   	push   %ebp
  803b41:	57                   	push   %edi
  803b42:	56                   	push   %esi
  803b43:	53                   	push   %ebx
  803b44:	83 ec 1c             	sub    $0x1c,%esp
  803b47:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  803b4b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  803b4f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b53:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  803b57:	85 d2                	test   %edx,%edx
  803b59:	75 35                	jne    803b90 <__udivdi3+0x50>
  803b5b:	39 f3                	cmp    %esi,%ebx
  803b5d:	0f 87 bd 00 00 00    	ja     803c20 <__udivdi3+0xe0>
  803b63:	85 db                	test   %ebx,%ebx
  803b65:	89 d9                	mov    %ebx,%ecx
  803b67:	75 0b                	jne    803b74 <__udivdi3+0x34>
  803b69:	b8 01 00 00 00       	mov    $0x1,%eax
  803b6e:	31 d2                	xor    %edx,%edx
  803b70:	f7 f3                	div    %ebx
  803b72:	89 c1                	mov    %eax,%ecx
  803b74:	31 d2                	xor    %edx,%edx
  803b76:	89 f0                	mov    %esi,%eax
  803b78:	f7 f1                	div    %ecx
  803b7a:	89 c6                	mov    %eax,%esi
  803b7c:	89 e8                	mov    %ebp,%eax
  803b7e:	89 f7                	mov    %esi,%edi
  803b80:	f7 f1                	div    %ecx
  803b82:	89 fa                	mov    %edi,%edx
  803b84:	83 c4 1c             	add    $0x1c,%esp
  803b87:	5b                   	pop    %ebx
  803b88:	5e                   	pop    %esi
  803b89:	5f                   	pop    %edi
  803b8a:	5d                   	pop    %ebp
  803b8b:	c3                   	ret    
  803b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803b90:	39 f2                	cmp    %esi,%edx
  803b92:	77 7c                	ja     803c10 <__udivdi3+0xd0>
  803b94:	0f bd fa             	bsr    %edx,%edi
  803b97:	83 f7 1f             	xor    $0x1f,%edi
  803b9a:	0f 84 98 00 00 00    	je     803c38 <__udivdi3+0xf8>
  803ba0:	89 f9                	mov    %edi,%ecx
  803ba2:	b8 20 00 00 00       	mov    $0x20,%eax
  803ba7:	29 f8                	sub    %edi,%eax
  803ba9:	d3 e2                	shl    %cl,%edx
  803bab:	89 54 24 08          	mov    %edx,0x8(%esp)
  803baf:	89 c1                	mov    %eax,%ecx
  803bb1:	89 da                	mov    %ebx,%edx
  803bb3:	d3 ea                	shr    %cl,%edx
  803bb5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  803bb9:	09 d1                	or     %edx,%ecx
  803bbb:	89 f2                	mov    %esi,%edx
  803bbd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bc1:	89 f9                	mov    %edi,%ecx
  803bc3:	d3 e3                	shl    %cl,%ebx
  803bc5:	89 c1                	mov    %eax,%ecx
  803bc7:	d3 ea                	shr    %cl,%edx
  803bc9:	89 f9                	mov    %edi,%ecx
  803bcb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  803bcf:	d3 e6                	shl    %cl,%esi
  803bd1:	89 eb                	mov    %ebp,%ebx
  803bd3:	89 c1                	mov    %eax,%ecx
  803bd5:	d3 eb                	shr    %cl,%ebx
  803bd7:	09 de                	or     %ebx,%esi
  803bd9:	89 f0                	mov    %esi,%eax
  803bdb:	f7 74 24 08          	divl   0x8(%esp)
  803bdf:	89 d6                	mov    %edx,%esi
  803be1:	89 c3                	mov    %eax,%ebx
  803be3:	f7 64 24 0c          	mull   0xc(%esp)
  803be7:	39 d6                	cmp    %edx,%esi
  803be9:	72 0c                	jb     803bf7 <__udivdi3+0xb7>
  803beb:	89 f9                	mov    %edi,%ecx
  803bed:	d3 e5                	shl    %cl,%ebp
  803bef:	39 c5                	cmp    %eax,%ebp
  803bf1:	73 5d                	jae    803c50 <__udivdi3+0x110>
  803bf3:	39 d6                	cmp    %edx,%esi
  803bf5:	75 59                	jne    803c50 <__udivdi3+0x110>
  803bf7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bfa:	31 ff                	xor    %edi,%edi
  803bfc:	89 fa                	mov    %edi,%edx
  803bfe:	83 c4 1c             	add    $0x1c,%esp
  803c01:	5b                   	pop    %ebx
  803c02:	5e                   	pop    %esi
  803c03:	5f                   	pop    %edi
  803c04:	5d                   	pop    %ebp
  803c05:	c3                   	ret    
  803c06:	8d 76 00             	lea    0x0(%esi),%esi
  803c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  803c10:	31 ff                	xor    %edi,%edi
  803c12:	31 c0                	xor    %eax,%eax
  803c14:	89 fa                	mov    %edi,%edx
  803c16:	83 c4 1c             	add    $0x1c,%esp
  803c19:	5b                   	pop    %ebx
  803c1a:	5e                   	pop    %esi
  803c1b:	5f                   	pop    %edi
  803c1c:	5d                   	pop    %ebp
  803c1d:	c3                   	ret    
  803c1e:	66 90                	xchg   %ax,%ax
  803c20:	31 ff                	xor    %edi,%edi
  803c22:	89 e8                	mov    %ebp,%eax
  803c24:	89 f2                	mov    %esi,%edx
  803c26:	f7 f3                	div    %ebx
  803c28:	89 fa                	mov    %edi,%edx
  803c2a:	83 c4 1c             	add    $0x1c,%esp
  803c2d:	5b                   	pop    %ebx
  803c2e:	5e                   	pop    %esi
  803c2f:	5f                   	pop    %edi
  803c30:	5d                   	pop    %ebp
  803c31:	c3                   	ret    
  803c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803c38:	39 f2                	cmp    %esi,%edx
  803c3a:	72 06                	jb     803c42 <__udivdi3+0x102>
  803c3c:	31 c0                	xor    %eax,%eax
  803c3e:	39 eb                	cmp    %ebp,%ebx
  803c40:	77 d2                	ja     803c14 <__udivdi3+0xd4>
  803c42:	b8 01 00 00 00       	mov    $0x1,%eax
  803c47:	eb cb                	jmp    803c14 <__udivdi3+0xd4>
  803c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803c50:	89 d8                	mov    %ebx,%eax
  803c52:	31 ff                	xor    %edi,%edi
  803c54:	eb be                	jmp    803c14 <__udivdi3+0xd4>
  803c56:	66 90                	xchg   %ax,%ax
  803c58:	66 90                	xchg   %ax,%ax
  803c5a:	66 90                	xchg   %ax,%ax
  803c5c:	66 90                	xchg   %ax,%ax
  803c5e:	66 90                	xchg   %ax,%ax

00803c60 <__umoddi3>:
  803c60:	55                   	push   %ebp
  803c61:	57                   	push   %edi
  803c62:	56                   	push   %esi
  803c63:	53                   	push   %ebx
  803c64:	83 ec 1c             	sub    $0x1c,%esp
  803c67:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  803c6b:	8b 74 24 30          	mov    0x30(%esp),%esi
  803c6f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  803c73:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c77:	85 ed                	test   %ebp,%ebp
  803c79:	89 f0                	mov    %esi,%eax
  803c7b:	89 da                	mov    %ebx,%edx
  803c7d:	75 19                	jne    803c98 <__umoddi3+0x38>
  803c7f:	39 df                	cmp    %ebx,%edi
  803c81:	0f 86 b1 00 00 00    	jbe    803d38 <__umoddi3+0xd8>
  803c87:	f7 f7                	div    %edi
  803c89:	89 d0                	mov    %edx,%eax
  803c8b:	31 d2                	xor    %edx,%edx
  803c8d:	83 c4 1c             	add    $0x1c,%esp
  803c90:	5b                   	pop    %ebx
  803c91:	5e                   	pop    %esi
  803c92:	5f                   	pop    %edi
  803c93:	5d                   	pop    %ebp
  803c94:	c3                   	ret    
  803c95:	8d 76 00             	lea    0x0(%esi),%esi
  803c98:	39 dd                	cmp    %ebx,%ebp
  803c9a:	77 f1                	ja     803c8d <__umoddi3+0x2d>
  803c9c:	0f bd cd             	bsr    %ebp,%ecx
  803c9f:	83 f1 1f             	xor    $0x1f,%ecx
  803ca2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ca6:	0f 84 b4 00 00 00    	je     803d60 <__umoddi3+0x100>
  803cac:	b8 20 00 00 00       	mov    $0x20,%eax
  803cb1:	89 c2                	mov    %eax,%edx
  803cb3:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cb7:	29 c2                	sub    %eax,%edx
  803cb9:	89 c1                	mov    %eax,%ecx
  803cbb:	89 f8                	mov    %edi,%eax
  803cbd:	d3 e5                	shl    %cl,%ebp
  803cbf:	89 d1                	mov    %edx,%ecx
  803cc1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803cc5:	d3 e8                	shr    %cl,%eax
  803cc7:	09 c5                	or     %eax,%ebp
  803cc9:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ccd:	89 c1                	mov    %eax,%ecx
  803ccf:	d3 e7                	shl    %cl,%edi
  803cd1:	89 d1                	mov    %edx,%ecx
  803cd3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803cd7:	89 df                	mov    %ebx,%edi
  803cd9:	d3 ef                	shr    %cl,%edi
  803cdb:	89 c1                	mov    %eax,%ecx
  803cdd:	89 f0                	mov    %esi,%eax
  803cdf:	d3 e3                	shl    %cl,%ebx
  803ce1:	89 d1                	mov    %edx,%ecx
  803ce3:	89 fa                	mov    %edi,%edx
  803ce5:	d3 e8                	shr    %cl,%eax
  803ce7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  803cec:	09 d8                	or     %ebx,%eax
  803cee:	f7 f5                	div    %ebp
  803cf0:	d3 e6                	shl    %cl,%esi
  803cf2:	89 d1                	mov    %edx,%ecx
  803cf4:	f7 64 24 08          	mull   0x8(%esp)
  803cf8:	39 d1                	cmp    %edx,%ecx
  803cfa:	89 c3                	mov    %eax,%ebx
  803cfc:	89 d7                	mov    %edx,%edi
  803cfe:	72 06                	jb     803d06 <__umoddi3+0xa6>
  803d00:	75 0e                	jne    803d10 <__umoddi3+0xb0>
  803d02:	39 c6                	cmp    %eax,%esi
  803d04:	73 0a                	jae    803d10 <__umoddi3+0xb0>
  803d06:	2b 44 24 08          	sub    0x8(%esp),%eax
  803d0a:	19 ea                	sbb    %ebp,%edx
  803d0c:	89 d7                	mov    %edx,%edi
  803d0e:	89 c3                	mov    %eax,%ebx
  803d10:	89 ca                	mov    %ecx,%edx
  803d12:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  803d17:	29 de                	sub    %ebx,%esi
  803d19:	19 fa                	sbb    %edi,%edx
  803d1b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  803d1f:	89 d0                	mov    %edx,%eax
  803d21:	d3 e0                	shl    %cl,%eax
  803d23:	89 d9                	mov    %ebx,%ecx
  803d25:	d3 ee                	shr    %cl,%esi
  803d27:	d3 ea                	shr    %cl,%edx
  803d29:	09 f0                	or     %esi,%eax
  803d2b:	83 c4 1c             	add    $0x1c,%esp
  803d2e:	5b                   	pop    %ebx
  803d2f:	5e                   	pop    %esi
  803d30:	5f                   	pop    %edi
  803d31:	5d                   	pop    %ebp
  803d32:	c3                   	ret    
  803d33:	90                   	nop
  803d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d38:	85 ff                	test   %edi,%edi
  803d3a:	89 f9                	mov    %edi,%ecx
  803d3c:	75 0b                	jne    803d49 <__umoddi3+0xe9>
  803d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803d43:	31 d2                	xor    %edx,%edx
  803d45:	f7 f7                	div    %edi
  803d47:	89 c1                	mov    %eax,%ecx
  803d49:	89 d8                	mov    %ebx,%eax
  803d4b:	31 d2                	xor    %edx,%edx
  803d4d:	f7 f1                	div    %ecx
  803d4f:	89 f0                	mov    %esi,%eax
  803d51:	f7 f1                	div    %ecx
  803d53:	e9 31 ff ff ff       	jmp    803c89 <__umoddi3+0x29>
  803d58:	90                   	nop
  803d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803d60:	39 dd                	cmp    %ebx,%ebp
  803d62:	72 08                	jb     803d6c <__umoddi3+0x10c>
  803d64:	39 f7                	cmp    %esi,%edi
  803d66:	0f 87 21 ff ff ff    	ja     803c8d <__umoddi3+0x2d>
  803d6c:	89 da                	mov    %ebx,%edx
  803d6e:	89 f0                	mov    %esi,%eax
  803d70:	29 f8                	sub    %edi,%eax
  803d72:	19 ea                	sbb    %ebp,%edx
  803d74:	e9 14 ff ff ff       	jmp    803c8d <__umoddi3+0x2d>

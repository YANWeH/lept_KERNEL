
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 20 12 f0       	mov    $0xf0122000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 5e 00 00 00       	call   f010009c <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void _panic(const char *file, int line, const char *fmt, ...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100048:	83 3d 98 ee 2a f0 00 	cmpl   $0x0,0xf02aee98
f010004f:	74 0f                	je     f0100060 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100051:	83 ec 0c             	sub    $0xc,%esp
f0100054:	6a 00                	push   $0x0
f0100056:	e8 1d 09 00 00       	call   f0100978 <monitor>
f010005b:	83 c4 10             	add    $0x10,%esp
f010005e:	eb f1                	jmp    f0100051 <_panic+0x11>
	panicstr = fmt;
f0100060:	89 35 98 ee 2a f0    	mov    %esi,0xf02aee98
	asm volatile("cli; cld");
f0100066:	fa                   	cli    
f0100067:	fc                   	cld    
	va_start(ap, fmt);
f0100068:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006b:	e8 63 60 00 00       	call   f01060d3 <cpunum>
f0100070:	ff 75 0c             	pushl  0xc(%ebp)
f0100073:	ff 75 08             	pushl  0x8(%ebp)
f0100076:	50                   	push   %eax
f0100077:	68 a0 6c 10 f0       	push   $0xf0106ca0
f010007c:	e8 af 38 00 00       	call   f0103930 <cprintf>
	vcprintf(fmt, ap);
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	53                   	push   %ebx
f0100085:	56                   	push   %esi
f0100086:	e8 7f 38 00 00       	call   f010390a <vcprintf>
	cprintf("\n");
f010008b:	c7 04 24 1d 75 10 f0 	movl   $0xf010751d,(%esp)
f0100092:	e8 99 38 00 00       	call   f0103930 <cprintf>
f0100097:	83 c4 10             	add    $0x10,%esp
f010009a:	eb b5                	jmp    f0100051 <_panic+0x11>

f010009c <i386_init>:
{
f010009c:	55                   	push   %ebp
f010009d:	89 e5                	mov    %esp,%ebp
f010009f:	53                   	push   %ebx
f01000a0:	83 ec 04             	sub    $0x4,%esp
	cons_init();
f01000a3:	e8 c7 05 00 00       	call   f010066f <cons_init>
	cprintf("6828 decimal is %o octal!\n", 6828);
f01000a8:	83 ec 08             	sub    $0x8,%esp
f01000ab:	68 ac 1a 00 00       	push   $0x1aac
f01000b0:	68 0c 6d 10 f0       	push   $0xf0106d0c
f01000b5:	e8 76 38 00 00       	call   f0103930 <cprintf>
	mem_init();
f01000ba:	e8 a6 12 00 00       	call   f0101365 <mem_init>
	env_init();
f01000bf:	e8 30 30 00 00       	call   f01030f4 <env_init>
	trap_init();
f01000c4:	e8 49 39 00 00       	call   f0103a12 <trap_init>
	mp_init();
f01000c9:	e8 f3 5c 00 00       	call   f0105dc1 <mp_init>
	lapic_init();
f01000ce:	e8 1a 60 00 00       	call   f01060ed <lapic_init>
	pic_init();
f01000d3:	e8 65 37 00 00       	call   f010383d <pic_init>
	time_init();
f01000d8:	e8 1e 69 00 00       	call   f01069fb <time_init>
	pci_init();
f01000dd:	e8 f9 68 00 00       	call   f01069db <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f01000e2:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f01000e9:	e8 55 62 00 00       	call   f0106343 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01000ee:	83 c4 10             	add    $0x10,%esp
f01000f1:	83 3d a0 ee 2a f0 07 	cmpl   $0x7,0xf02aeea0
f01000f8:	76 27                	jbe    f0100121 <i386_init+0x85>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01000fa:	83 ec 04             	sub    $0x4,%esp
f01000fd:	b8 26 5d 10 f0       	mov    $0xf0105d26,%eax
f0100102:	2d ac 5c 10 f0       	sub    $0xf0105cac,%eax
f0100107:	50                   	push   %eax
f0100108:	68 ac 5c 10 f0       	push   $0xf0105cac
f010010d:	68 00 70 00 f0       	push   $0xf0007000
f0100112:	e8 e5 59 00 00       	call   f0105afc <memmove>
f0100117:	83 c4 10             	add    $0x10,%esp
	for (c = cpus; c < cpus + ncpu; c++)
f010011a:	bb 20 f0 2a f0       	mov    $0xf02af020,%ebx
f010011f:	eb 19                	jmp    f010013a <i386_init+0x9e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100121:	68 00 70 00 00       	push   $0x7000
f0100126:	68 c4 6c 10 f0       	push   $0xf0106cc4
f010012b:	6a 5f                	push   $0x5f
f010012d:	68 27 6d 10 f0       	push   $0xf0106d27
f0100132:	e8 09 ff ff ff       	call   f0100040 <_panic>
f0100137:	83 c3 74             	add    $0x74,%ebx
f010013a:	6b 05 c4 f3 2a f0 74 	imul   $0x74,0xf02af3c4,%eax
f0100141:	05 20 f0 2a f0       	add    $0xf02af020,%eax
f0100146:	39 c3                	cmp    %eax,%ebx
f0100148:	73 4c                	jae    f0100196 <i386_init+0xfa>
		if (c == cpus + cpunum()) // We've started already.
f010014a:	e8 84 5f 00 00       	call   f01060d3 <cpunum>
f010014f:	6b c0 74             	imul   $0x74,%eax,%eax
f0100152:	05 20 f0 2a f0       	add    $0xf02af020,%eax
f0100157:	39 c3                	cmp    %eax,%ebx
f0100159:	74 dc                	je     f0100137 <i386_init+0x9b>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010015b:	89 d8                	mov    %ebx,%eax
f010015d:	2d 20 f0 2a f0       	sub    $0xf02af020,%eax
f0100162:	c1 f8 02             	sar    $0x2,%eax
f0100165:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f010016b:	c1 e0 0f             	shl    $0xf,%eax
f010016e:	05 00 80 2b f0       	add    $0xf02b8000,%eax
f0100173:	a3 9c ee 2a f0       	mov    %eax,0xf02aee9c
		lapic_startap(c->cpu_id, PADDR(code));
f0100178:	83 ec 08             	sub    $0x8,%esp
f010017b:	68 00 70 00 00       	push   $0x7000
f0100180:	0f b6 03             	movzbl (%ebx),%eax
f0100183:	50                   	push   %eax
f0100184:	e8 b5 60 00 00       	call   f010623e <lapic_startap>
f0100189:	83 c4 10             	add    $0x10,%esp
		while (c->cpu_status != CPU_STARTED)
f010018c:	8b 43 04             	mov    0x4(%ebx),%eax
f010018f:	83 f8 01             	cmp    $0x1,%eax
f0100192:	75 f8                	jne    f010018c <i386_init+0xf0>
f0100194:	eb a1                	jmp    f0100137 <i386_init+0x9b>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100196:	83 ec 08             	sub    $0x8,%esp
f0100199:	6a 01                	push   $0x1
f010019b:	68 90 bd 1d f0       	push   $0xf01dbd90
f01001a0:	e8 48 31 00 00       	call   f01032ed <env_create>
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001a5:	83 c4 08             	add    $0x8,%esp
f01001a8:	6a 02                	push   $0x2
f01001aa:	68 ac 52 23 f0       	push   $0xf02352ac
f01001af:	e8 39 31 00 00       	call   f01032ed <env_create>
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001b4:	83 c4 08             	add    $0x8,%esp
f01001b7:	6a 00                	push   $0x0
f01001b9:	68 44 ba 1c f0       	push   $0xf01cba44
f01001be:	e8 2a 31 00 00       	call   f01032ed <env_create>
	kbd_intr();
f01001c3:	e8 4c 04 00 00       	call   f0100614 <kbd_intr>
	sched_yield();
f01001c8:	e8 e3 45 00 00       	call   f01047b0 <sched_yield>

f01001cd <mp_main>:
{
f01001cd:	55                   	push   %ebp
f01001ce:	89 e5                	mov    %esp,%ebp
f01001d0:	83 ec 08             	sub    $0x8,%esp
	lcr3(PADDR(kern_pgdir));
f01001d3:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
	if ((uint32_t)kva < KERNBASE)
f01001d8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01001dd:	77 12                	ja     f01001f1 <mp_main+0x24>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01001df:	50                   	push   %eax
f01001e0:	68 e8 6c 10 f0       	push   $0xf0106ce8
f01001e5:	6a 76                	push   $0x76
f01001e7:	68 27 6d 10 f0       	push   $0xf0106d27
f01001ec:	e8 4f fe ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01001f1:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01001f6:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01001f9:	e8 d5 5e 00 00       	call   f01060d3 <cpunum>
f01001fe:	83 ec 08             	sub    $0x8,%esp
f0100201:	50                   	push   %eax
f0100202:	68 33 6d 10 f0       	push   $0xf0106d33
f0100207:	e8 24 37 00 00       	call   f0103930 <cprintf>
	lapic_init();
f010020c:	e8 dc 5e 00 00       	call   f01060ed <lapic_init>
	env_init_percpu();
f0100211:	e8 ae 2e 00 00       	call   f01030c4 <env_init_percpu>
	trap_init_percpu();
f0100216:	e8 29 37 00 00       	call   f0103944 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f010021b:	e8 b3 5e 00 00       	call   f01060d3 <cpunum>
f0100220:	6b d0 74             	imul   $0x74,%eax,%edx
f0100223:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100226:	b8 01 00 00 00       	mov    $0x1,%eax
f010022b:	f0 87 82 20 f0 2a f0 	lock xchg %eax,-0xfd50fe0(%edx)
f0100232:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f0100239:	e8 05 61 00 00       	call   f0106343 <spin_lock>
	sched_yield();
f010023e:	e8 6d 45 00 00       	call   f01047b0 <sched_yield>

f0100243 <_warn>:
}

/* like panic, but don't */
void _warn(const char *file, int line, const char *fmt, ...)
{
f0100243:	55                   	push   %ebp
f0100244:	89 e5                	mov    %esp,%ebp
f0100246:	53                   	push   %ebx
f0100247:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010024a:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010024d:	ff 75 0c             	pushl  0xc(%ebp)
f0100250:	ff 75 08             	pushl  0x8(%ebp)
f0100253:	68 49 6d 10 f0       	push   $0xf0106d49
f0100258:	e8 d3 36 00 00       	call   f0103930 <cprintf>
	vcprintf(fmt, ap);
f010025d:	83 c4 08             	add    $0x8,%esp
f0100260:	53                   	push   %ebx
f0100261:	ff 75 10             	pushl  0x10(%ebp)
f0100264:	e8 a1 36 00 00       	call   f010390a <vcprintf>
	cprintf("\n");
f0100269:	c7 04 24 1d 75 10 f0 	movl   $0xf010751d,(%esp)
f0100270:	e8 bb 36 00 00       	call   f0103930 <cprintf>
	va_end(ap);
}
f0100275:	83 c4 10             	add    $0x10,%esp
f0100278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010027b:	c9                   	leave  
f010027c:	c3                   	ret    

f010027d <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010027d:	55                   	push   %ebp
f010027e:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100280:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100285:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100286:	a8 01                	test   $0x1,%al
f0100288:	74 0b                	je     f0100295 <serial_proc_data+0x18>
f010028a:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010028f:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100290:	0f b6 c0             	movzbl %al,%eax
}
f0100293:	5d                   	pop    %ebp
f0100294:	c3                   	ret    
		return -1;
f0100295:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010029a:	eb f7                	jmp    f0100293 <serial_proc_data+0x16>

f010029c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010029c:	55                   	push   %ebp
f010029d:	89 e5                	mov    %esp,%ebp
f010029f:	53                   	push   %ebx
f01002a0:	83 ec 04             	sub    $0x4,%esp
f01002a3:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01002a5:	ff d3                	call   *%ebx
f01002a7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01002aa:	74 2d                	je     f01002d9 <cons_intr+0x3d>
		if (c == 0)
f01002ac:	85 c0                	test   %eax,%eax
f01002ae:	74 f5                	je     f01002a5 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01002b0:	8b 0d 24 e2 2a f0    	mov    0xf02ae224,%ecx
f01002b6:	8d 51 01             	lea    0x1(%ecx),%edx
f01002b9:	89 15 24 e2 2a f0    	mov    %edx,0xf02ae224
f01002bf:	88 81 20 e0 2a f0    	mov    %al,-0xfd51fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01002c5:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01002cb:	75 d8                	jne    f01002a5 <cons_intr+0x9>
			cons.wpos = 0;
f01002cd:	c7 05 24 e2 2a f0 00 	movl   $0x0,0xf02ae224
f01002d4:	00 00 00 
f01002d7:	eb cc                	jmp    f01002a5 <cons_intr+0x9>
	}
}
f01002d9:	83 c4 04             	add    $0x4,%esp
f01002dc:	5b                   	pop    %ebx
f01002dd:	5d                   	pop    %ebp
f01002de:	c3                   	ret    

f01002df <kbd_proc_data>:
{
f01002df:	55                   	push   %ebp
f01002e0:	89 e5                	mov    %esp,%ebp
f01002e2:	53                   	push   %ebx
f01002e3:	83 ec 04             	sub    $0x4,%esp
f01002e6:	ba 64 00 00 00       	mov    $0x64,%edx
f01002eb:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01002ec:	a8 01                	test   $0x1,%al
f01002ee:	0f 84 fa 00 00 00    	je     f01003ee <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01002f4:	a8 20                	test   $0x20,%al
f01002f6:	0f 85 f9 00 00 00    	jne    f01003f5 <kbd_proc_data+0x116>
f01002fc:	ba 60 00 00 00       	mov    $0x60,%edx
f0100301:	ec                   	in     (%dx),%al
f0100302:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100304:	3c e0                	cmp    $0xe0,%al
f0100306:	0f 84 8e 00 00 00    	je     f010039a <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f010030c:	84 c0                	test   %al,%al
f010030e:	0f 88 99 00 00 00    	js     f01003ad <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f0100314:	8b 0d 00 e0 2a f0    	mov    0xf02ae000,%ecx
f010031a:	f6 c1 40             	test   $0x40,%cl
f010031d:	74 0e                	je     f010032d <kbd_proc_data+0x4e>
		data |= 0x80;
f010031f:	83 c8 80             	or     $0xffffff80,%eax
f0100322:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100324:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100327:	89 0d 00 e0 2a f0    	mov    %ecx,0xf02ae000
	shift |= shiftcode[data];
f010032d:	0f b6 d2             	movzbl %dl,%edx
f0100330:	0f b6 82 c0 6e 10 f0 	movzbl -0xfef9140(%edx),%eax
f0100337:	0b 05 00 e0 2a f0    	or     0xf02ae000,%eax
	shift ^= togglecode[data];
f010033d:	0f b6 8a c0 6d 10 f0 	movzbl -0xfef9240(%edx),%ecx
f0100344:	31 c8                	xor    %ecx,%eax
f0100346:	a3 00 e0 2a f0       	mov    %eax,0xf02ae000
	c = charcode[shift & (CTL | SHIFT)][data];
f010034b:	89 c1                	mov    %eax,%ecx
f010034d:	83 e1 03             	and    $0x3,%ecx
f0100350:	8b 0c 8d a0 6d 10 f0 	mov    -0xfef9260(,%ecx,4),%ecx
f0100357:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010035b:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010035e:	a8 08                	test   $0x8,%al
f0100360:	74 0d                	je     f010036f <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f0100362:	89 da                	mov    %ebx,%edx
f0100364:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100367:	83 f9 19             	cmp    $0x19,%ecx
f010036a:	77 74                	ja     f01003e0 <kbd_proc_data+0x101>
			c += 'A' - 'a';
f010036c:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010036f:	f7 d0                	not    %eax
f0100371:	a8 06                	test   $0x6,%al
f0100373:	75 31                	jne    f01003a6 <kbd_proc_data+0xc7>
f0100375:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010037b:	75 29                	jne    f01003a6 <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f010037d:	83 ec 0c             	sub    $0xc,%esp
f0100380:	68 63 6d 10 f0       	push   $0xf0106d63
f0100385:	e8 a6 35 00 00       	call   f0103930 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010038a:	b8 03 00 00 00       	mov    $0x3,%eax
f010038f:	ba 92 00 00 00       	mov    $0x92,%edx
f0100394:	ee                   	out    %al,(%dx)
f0100395:	83 c4 10             	add    $0x10,%esp
f0100398:	eb 0c                	jmp    f01003a6 <kbd_proc_data+0xc7>
		shift |= E0ESC;
f010039a:	83 0d 00 e0 2a f0 40 	orl    $0x40,0xf02ae000
		return 0;
f01003a1:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01003a6:	89 d8                	mov    %ebx,%eax
f01003a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01003ab:	c9                   	leave  
f01003ac:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01003ad:	8b 0d 00 e0 2a f0    	mov    0xf02ae000,%ecx
f01003b3:	89 cb                	mov    %ecx,%ebx
f01003b5:	83 e3 40             	and    $0x40,%ebx
f01003b8:	83 e0 7f             	and    $0x7f,%eax
f01003bb:	85 db                	test   %ebx,%ebx
f01003bd:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003c0:	0f b6 d2             	movzbl %dl,%edx
f01003c3:	0f b6 82 c0 6e 10 f0 	movzbl -0xfef9140(%edx),%eax
f01003ca:	83 c8 40             	or     $0x40,%eax
f01003cd:	0f b6 c0             	movzbl %al,%eax
f01003d0:	f7 d0                	not    %eax
f01003d2:	21 c8                	and    %ecx,%eax
f01003d4:	a3 00 e0 2a f0       	mov    %eax,0xf02ae000
		return 0;
f01003d9:	bb 00 00 00 00       	mov    $0x0,%ebx
f01003de:	eb c6                	jmp    f01003a6 <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f01003e0:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01003e3:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01003e6:	83 fa 1a             	cmp    $0x1a,%edx
f01003e9:	0f 42 d9             	cmovb  %ecx,%ebx
f01003ec:	eb 81                	jmp    f010036f <kbd_proc_data+0x90>
		return -1;
f01003ee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003f3:	eb b1                	jmp    f01003a6 <kbd_proc_data+0xc7>
		return -1;
f01003f5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01003fa:	eb aa                	jmp    f01003a6 <kbd_proc_data+0xc7>

f01003fc <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01003fc:	55                   	push   %ebp
f01003fd:	89 e5                	mov    %esp,%ebp
f01003ff:	57                   	push   %edi
f0100400:	56                   	push   %esi
f0100401:	53                   	push   %ebx
f0100402:	83 ec 1c             	sub    $0x1c,%esp
f0100405:	89 c7                	mov    %eax,%edi
	for (i = 0;
f0100407:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010040c:	be fd 03 00 00       	mov    $0x3fd,%esi
f0100411:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100416:	eb 09                	jmp    f0100421 <cons_putc+0x25>
f0100418:	89 ca                	mov    %ecx,%edx
f010041a:	ec                   	in     (%dx),%al
f010041b:	ec                   	in     (%dx),%al
f010041c:	ec                   	in     (%dx),%al
f010041d:	ec                   	in     (%dx),%al
	     i++)
f010041e:	83 c3 01             	add    $0x1,%ebx
f0100421:	89 f2                	mov    %esi,%edx
f0100423:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100424:	a8 20                	test   $0x20,%al
f0100426:	75 08                	jne    f0100430 <cons_putc+0x34>
f0100428:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010042e:	7e e8                	jle    f0100418 <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f0100430:	89 f8                	mov    %edi,%eax
f0100432:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100435:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010043a:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010043b:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100440:	be 79 03 00 00       	mov    $0x379,%esi
f0100445:	b9 84 00 00 00       	mov    $0x84,%ecx
f010044a:	eb 09                	jmp    f0100455 <cons_putc+0x59>
f010044c:	89 ca                	mov    %ecx,%edx
f010044e:	ec                   	in     (%dx),%al
f010044f:	ec                   	in     (%dx),%al
f0100450:	ec                   	in     (%dx),%al
f0100451:	ec                   	in     (%dx),%al
f0100452:	83 c3 01             	add    $0x1,%ebx
f0100455:	89 f2                	mov    %esi,%edx
f0100457:	ec                   	in     (%dx),%al
f0100458:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010045e:	7f 04                	jg     f0100464 <cons_putc+0x68>
f0100460:	84 c0                	test   %al,%al
f0100462:	79 e8                	jns    f010044c <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100464:	ba 78 03 00 00       	mov    $0x378,%edx
f0100469:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f010046d:	ee                   	out    %al,(%dx)
f010046e:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100473:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100478:	ee                   	out    %al,(%dx)
f0100479:	b8 08 00 00 00       	mov    $0x8,%eax
f010047e:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010047f:	89 fa                	mov    %edi,%edx
f0100481:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100487:	89 f8                	mov    %edi,%eax
f0100489:	80 cc 07             	or     $0x7,%ah
f010048c:	85 d2                	test   %edx,%edx
f010048e:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f0100491:	89 f8                	mov    %edi,%eax
f0100493:	0f b6 c0             	movzbl %al,%eax
f0100496:	83 f8 09             	cmp    $0x9,%eax
f0100499:	0f 84 b6 00 00 00    	je     f0100555 <cons_putc+0x159>
f010049f:	83 f8 09             	cmp    $0x9,%eax
f01004a2:	7e 73                	jle    f0100517 <cons_putc+0x11b>
f01004a4:	83 f8 0a             	cmp    $0xa,%eax
f01004a7:	0f 84 9b 00 00 00    	je     f0100548 <cons_putc+0x14c>
f01004ad:	83 f8 0d             	cmp    $0xd,%eax
f01004b0:	0f 85 d6 00 00 00    	jne    f010058c <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f01004b6:	0f b7 05 28 e2 2a f0 	movzwl 0xf02ae228,%eax
f01004bd:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01004c3:	c1 e8 16             	shr    $0x16,%eax
f01004c6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01004c9:	c1 e0 04             	shl    $0x4,%eax
f01004cc:	66 a3 28 e2 2a f0    	mov    %ax,0xf02ae228
	if (crt_pos >= CRT_SIZE) {
f01004d2:	66 81 3d 28 e2 2a f0 	cmpw   $0x7cf,0xf02ae228
f01004d9:	cf 07 
f01004db:	0f 87 ce 00 00 00    	ja     f01005af <cons_putc+0x1b3>
	outb(addr_6845, 14);
f01004e1:	8b 0d 30 e2 2a f0    	mov    0xf02ae230,%ecx
f01004e7:	b8 0e 00 00 00       	mov    $0xe,%eax
f01004ec:	89 ca                	mov    %ecx,%edx
f01004ee:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01004ef:	0f b7 1d 28 e2 2a f0 	movzwl 0xf02ae228,%ebx
f01004f6:	8d 71 01             	lea    0x1(%ecx),%esi
f01004f9:	89 d8                	mov    %ebx,%eax
f01004fb:	66 c1 e8 08          	shr    $0x8,%ax
f01004ff:	89 f2                	mov    %esi,%edx
f0100501:	ee                   	out    %al,(%dx)
f0100502:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100507:	89 ca                	mov    %ecx,%edx
f0100509:	ee                   	out    %al,(%dx)
f010050a:	89 d8                	mov    %ebx,%eax
f010050c:	89 f2                	mov    %esi,%edx
f010050e:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010050f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100512:	5b                   	pop    %ebx
f0100513:	5e                   	pop    %esi
f0100514:	5f                   	pop    %edi
f0100515:	5d                   	pop    %ebp
f0100516:	c3                   	ret    
	switch (c & 0xff) {
f0100517:	83 f8 08             	cmp    $0x8,%eax
f010051a:	75 70                	jne    f010058c <cons_putc+0x190>
		if (crt_pos > 0) {
f010051c:	0f b7 05 28 e2 2a f0 	movzwl 0xf02ae228,%eax
f0100523:	66 85 c0             	test   %ax,%ax
f0100526:	74 b9                	je     f01004e1 <cons_putc+0xe5>
			crt_pos--;
f0100528:	83 e8 01             	sub    $0x1,%eax
f010052b:	66 a3 28 e2 2a f0    	mov    %ax,0xf02ae228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100531:	0f b7 c0             	movzwl %ax,%eax
f0100534:	66 81 e7 00 ff       	and    $0xff00,%di
f0100539:	83 cf 20             	or     $0x20,%edi
f010053c:	8b 15 2c e2 2a f0    	mov    0xf02ae22c,%edx
f0100542:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100546:	eb 8a                	jmp    f01004d2 <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f0100548:	66 83 05 28 e2 2a f0 	addw   $0x50,0xf02ae228
f010054f:	50 
f0100550:	e9 61 ff ff ff       	jmp    f01004b6 <cons_putc+0xba>
		cons_putc(' ');
f0100555:	b8 20 00 00 00       	mov    $0x20,%eax
f010055a:	e8 9d fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f010055f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100564:	e8 93 fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f0100569:	b8 20 00 00 00       	mov    $0x20,%eax
f010056e:	e8 89 fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f0100573:	b8 20 00 00 00       	mov    $0x20,%eax
f0100578:	e8 7f fe ff ff       	call   f01003fc <cons_putc>
		cons_putc(' ');
f010057d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100582:	e8 75 fe ff ff       	call   f01003fc <cons_putc>
f0100587:	e9 46 ff ff ff       	jmp    f01004d2 <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f010058c:	0f b7 05 28 e2 2a f0 	movzwl 0xf02ae228,%eax
f0100593:	8d 50 01             	lea    0x1(%eax),%edx
f0100596:	66 89 15 28 e2 2a f0 	mov    %dx,0xf02ae228
f010059d:	0f b7 c0             	movzwl %ax,%eax
f01005a0:	8b 15 2c e2 2a f0    	mov    0xf02ae22c,%edx
f01005a6:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005aa:	e9 23 ff ff ff       	jmp    f01004d2 <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005af:	a1 2c e2 2a f0       	mov    0xf02ae22c,%eax
f01005b4:	83 ec 04             	sub    $0x4,%esp
f01005b7:	68 00 0f 00 00       	push   $0xf00
f01005bc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005c2:	52                   	push   %edx
f01005c3:	50                   	push   %eax
f01005c4:	e8 33 55 00 00       	call   f0105afc <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01005c9:	8b 15 2c e2 2a f0    	mov    0xf02ae22c,%edx
f01005cf:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01005d5:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01005db:	83 c4 10             	add    $0x10,%esp
f01005de:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01005e3:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005e6:	39 d0                	cmp    %edx,%eax
f01005e8:	75 f4                	jne    f01005de <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01005ea:	66 83 2d 28 e2 2a f0 	subw   $0x50,0xf02ae228
f01005f1:	50 
f01005f2:	e9 ea fe ff ff       	jmp    f01004e1 <cons_putc+0xe5>

f01005f7 <serial_intr>:
	if (serial_exists)
f01005f7:	80 3d 34 e2 2a f0 00 	cmpb   $0x0,0xf02ae234
f01005fe:	75 02                	jne    f0100602 <serial_intr+0xb>
f0100600:	f3 c3                	repz ret 
{
f0100602:	55                   	push   %ebp
f0100603:	89 e5                	mov    %esp,%ebp
f0100605:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100608:	b8 7d 02 10 f0       	mov    $0xf010027d,%eax
f010060d:	e8 8a fc ff ff       	call   f010029c <cons_intr>
}
f0100612:	c9                   	leave  
f0100613:	c3                   	ret    

f0100614 <kbd_intr>:
{
f0100614:	55                   	push   %ebp
f0100615:	89 e5                	mov    %esp,%ebp
f0100617:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f010061a:	b8 df 02 10 f0       	mov    $0xf01002df,%eax
f010061f:	e8 78 fc ff ff       	call   f010029c <cons_intr>
}
f0100624:	c9                   	leave  
f0100625:	c3                   	ret    

f0100626 <cons_getc>:
{
f0100626:	55                   	push   %ebp
f0100627:	89 e5                	mov    %esp,%ebp
f0100629:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f010062c:	e8 c6 ff ff ff       	call   f01005f7 <serial_intr>
	kbd_intr();
f0100631:	e8 de ff ff ff       	call   f0100614 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100636:	8b 15 20 e2 2a f0    	mov    0xf02ae220,%edx
	return 0;
f010063c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f0100641:	3b 15 24 e2 2a f0    	cmp    0xf02ae224,%edx
f0100647:	74 18                	je     f0100661 <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f0100649:	8d 4a 01             	lea    0x1(%edx),%ecx
f010064c:	89 0d 20 e2 2a f0    	mov    %ecx,0xf02ae220
f0100652:	0f b6 82 20 e0 2a f0 	movzbl -0xfd51fe0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f0100659:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010065f:	74 02                	je     f0100663 <cons_getc+0x3d>
}
f0100661:	c9                   	leave  
f0100662:	c3                   	ret    
			cons.rpos = 0;
f0100663:	c7 05 20 e2 2a f0 00 	movl   $0x0,0xf02ae220
f010066a:	00 00 00 
f010066d:	eb f2                	jmp    f0100661 <cons_getc+0x3b>

f010066f <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010066f:	55                   	push   %ebp
f0100670:	89 e5                	mov    %esp,%ebp
f0100672:	57                   	push   %edi
f0100673:	56                   	push   %esi
f0100674:	53                   	push   %ebx
f0100675:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100678:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010067f:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100686:	5a a5 
	if (*cp != 0xA55A) {
f0100688:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010068f:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100693:	0f 84 de 00 00 00    	je     f0100777 <cons_init+0x108>
		addr_6845 = MONO_BASE;
f0100699:	c7 05 30 e2 2a f0 b4 	movl   $0x3b4,0xf02ae230
f01006a0:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006a3:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01006a8:	8b 3d 30 e2 2a f0    	mov    0xf02ae230,%edi
f01006ae:	b8 0e 00 00 00       	mov    $0xe,%eax
f01006b3:	89 fa                	mov    %edi,%edx
f01006b5:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01006b6:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006b9:	89 ca                	mov    %ecx,%edx
f01006bb:	ec                   	in     (%dx),%al
f01006bc:	0f b6 c0             	movzbl %al,%eax
f01006bf:	c1 e0 08             	shl    $0x8,%eax
f01006c2:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006c4:	b8 0f 00 00 00       	mov    $0xf,%eax
f01006c9:	89 fa                	mov    %edi,%edx
f01006cb:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01006cc:	89 ca                	mov    %ecx,%edx
f01006ce:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01006cf:	89 35 2c e2 2a f0    	mov    %esi,0xf02ae22c
	pos |= inb(addr_6845 + 1);
f01006d5:	0f b6 c0             	movzbl %al,%eax
f01006d8:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01006da:	66 a3 28 e2 2a f0    	mov    %ax,0xf02ae228
	kbd_intr();
f01006e0:	e8 2f ff ff ff       	call   f0100614 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f01006e5:	83 ec 0c             	sub    $0xc,%esp
f01006e8:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01006ef:	25 fd ff 00 00       	and    $0xfffd,%eax
f01006f4:	50                   	push   %eax
f01006f5:	e8 c5 30 00 00       	call   f01037bf <irq_setmask_8259A>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01006fa:	bb 00 00 00 00       	mov    $0x0,%ebx
f01006ff:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f0100704:	89 d8                	mov    %ebx,%eax
f0100706:	89 ca                	mov    %ecx,%edx
f0100708:	ee                   	out    %al,(%dx)
f0100709:	bf fb 03 00 00       	mov    $0x3fb,%edi
f010070e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100713:	89 fa                	mov    %edi,%edx
f0100715:	ee                   	out    %al,(%dx)
f0100716:	b8 0c 00 00 00       	mov    $0xc,%eax
f010071b:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100720:	ee                   	out    %al,(%dx)
f0100721:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100726:	89 d8                	mov    %ebx,%eax
f0100728:	89 f2                	mov    %esi,%edx
f010072a:	ee                   	out    %al,(%dx)
f010072b:	b8 03 00 00 00       	mov    $0x3,%eax
f0100730:	89 fa                	mov    %edi,%edx
f0100732:	ee                   	out    %al,(%dx)
f0100733:	ba fc 03 00 00       	mov    $0x3fc,%edx
f0100738:	89 d8                	mov    %ebx,%eax
f010073a:	ee                   	out    %al,(%dx)
f010073b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100740:	89 f2                	mov    %esi,%edx
f0100742:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100743:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100748:	ec                   	in     (%dx),%al
f0100749:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010074b:	83 c4 10             	add    $0x10,%esp
f010074e:	3c ff                	cmp    $0xff,%al
f0100750:	0f 95 05 34 e2 2a f0 	setne  0xf02ae234
f0100757:	89 ca                	mov    %ecx,%edx
f0100759:	ec                   	in     (%dx),%al
f010075a:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010075f:	ec                   	in     (%dx),%al
	if (serial_exists)
f0100760:	80 fb ff             	cmp    $0xff,%bl
f0100763:	75 2d                	jne    f0100792 <cons_init+0x123>
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
		cprintf("Serial port does not exist!\n");
f0100765:	83 ec 0c             	sub    $0xc,%esp
f0100768:	68 6f 6d 10 f0       	push   $0xf0106d6f
f010076d:	e8 be 31 00 00       	call   f0103930 <cprintf>
f0100772:	83 c4 10             	add    $0x10,%esp
}
f0100775:	eb 3c                	jmp    f01007b3 <cons_init+0x144>
		*cp = was;
f0100777:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010077e:	c7 05 30 e2 2a f0 d4 	movl   $0x3d4,0xf02ae230
f0100785:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100788:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f010078d:	e9 16 ff ff ff       	jmp    f01006a8 <cons_init+0x39>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f0100792:	83 ec 0c             	sub    $0xc,%esp
f0100795:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f010079c:	25 ef ff 00 00       	and    $0xffef,%eax
f01007a1:	50                   	push   %eax
f01007a2:	e8 18 30 00 00       	call   f01037bf <irq_setmask_8259A>
	if (!serial_exists)
f01007a7:	83 c4 10             	add    $0x10,%esp
f01007aa:	80 3d 34 e2 2a f0 00 	cmpb   $0x0,0xf02ae234
f01007b1:	74 b2                	je     f0100765 <cons_init+0xf6>
}
f01007b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01007b6:	5b                   	pop    %ebx
f01007b7:	5e                   	pop    %esi
f01007b8:	5f                   	pop    %edi
f01007b9:	5d                   	pop    %ebp
f01007ba:	c3                   	ret    

f01007bb <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007bb:	55                   	push   %ebp
f01007bc:	89 e5                	mov    %esp,%ebp
f01007be:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007c1:	8b 45 08             	mov    0x8(%ebp),%eax
f01007c4:	e8 33 fc ff ff       	call   f01003fc <cons_putc>
}
f01007c9:	c9                   	leave  
f01007ca:	c3                   	ret    

f01007cb <getchar>:

int
getchar(void)
{
f01007cb:	55                   	push   %ebp
f01007cc:	89 e5                	mov    %esp,%ebp
f01007ce:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007d1:	e8 50 fe ff ff       	call   f0100626 <cons_getc>
f01007d6:	85 c0                	test   %eax,%eax
f01007d8:	74 f7                	je     f01007d1 <getchar+0x6>
		/* do nothing */;
	return c;
}
f01007da:	c9                   	leave  
f01007db:	c3                   	ret    

f01007dc <iscons>:

int
iscons(int fdnum)
{
f01007dc:	55                   	push   %ebp
f01007dd:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01007df:	b8 01 00 00 00       	mov    $0x1,%eax
f01007e4:	5d                   	pop    %ebp
f01007e5:	c3                   	ret    

f01007e6 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01007e6:	55                   	push   %ebp
f01007e7:	89 e5                	mov    %esp,%ebp
f01007e9:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01007ec:	68 c0 6f 10 f0       	push   $0xf0106fc0
f01007f1:	68 de 6f 10 f0       	push   $0xf0106fde
f01007f6:	68 e3 6f 10 f0       	push   $0xf0106fe3
f01007fb:	e8 30 31 00 00       	call   f0103930 <cprintf>
f0100800:	83 c4 0c             	add    $0xc,%esp
f0100803:	68 78 70 10 f0       	push   $0xf0107078
f0100808:	68 ec 6f 10 f0       	push   $0xf0106fec
f010080d:	68 e3 6f 10 f0       	push   $0xf0106fe3
f0100812:	e8 19 31 00 00       	call   f0103930 <cprintf>
f0100817:	83 c4 0c             	add    $0xc,%esp
f010081a:	68 a0 70 10 f0       	push   $0xf01070a0
f010081f:	68 f5 6f 10 f0       	push   $0xf0106ff5
f0100824:	68 e3 6f 10 f0       	push   $0xf0106fe3
f0100829:	e8 02 31 00 00       	call   f0103930 <cprintf>
	return 0;
}
f010082e:	b8 00 00 00 00       	mov    $0x0,%eax
f0100833:	c9                   	leave  
f0100834:	c3                   	ret    

f0100835 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100835:	55                   	push   %ebp
f0100836:	89 e5                	mov    %esp,%ebp
f0100838:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010083b:	68 ff 6f 10 f0       	push   $0xf0106fff
f0100840:	e8 eb 30 00 00       	call   f0103930 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100845:	83 c4 08             	add    $0x8,%esp
f0100848:	68 0c 00 10 00       	push   $0x10000c
f010084d:	68 cc 70 10 f0       	push   $0xf01070cc
f0100852:	e8 d9 30 00 00       	call   f0103930 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f0100857:	83 c4 0c             	add    $0xc,%esp
f010085a:	68 0c 00 10 00       	push   $0x10000c
f010085f:	68 0c 00 10 f0       	push   $0xf010000c
f0100864:	68 f4 70 10 f0       	push   $0xf01070f4
f0100869:	e8 c2 30 00 00       	call   f0103930 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f010086e:	83 c4 0c             	add    $0xc,%esp
f0100871:	68 89 6c 10 00       	push   $0x106c89
f0100876:	68 89 6c 10 f0       	push   $0xf0106c89
f010087b:	68 18 71 10 f0       	push   $0xf0107118
f0100880:	e8 ab 30 00 00       	call   f0103930 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100885:	83 c4 0c             	add    $0xc,%esp
f0100888:	68 00 e0 2a 00       	push   $0x2ae000
f010088d:	68 00 e0 2a f0       	push   $0xf02ae000
f0100892:	68 3c 71 10 f0       	push   $0xf010713c
f0100897:	e8 94 30 00 00       	call   f0103930 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010089c:	83 c4 0c             	add    $0xc,%esp
f010089f:	68 08 00 2f 00       	push   $0x2f0008
f01008a4:	68 08 00 2f f0       	push   $0xf02f0008
f01008a9:	68 60 71 10 f0       	push   $0xf0107160
f01008ae:	e8 7d 30 00 00       	call   f0103930 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008b3:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f01008b6:	b8 07 04 2f f0       	mov    $0xf02f0407,%eax
f01008bb:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f01008c0:	c1 f8 0a             	sar    $0xa,%eax
f01008c3:	50                   	push   %eax
f01008c4:	68 84 71 10 f0       	push   $0xf0107184
f01008c9:	e8 62 30 00 00       	call   f0103930 <cprintf>
	return 0;
}
f01008ce:	b8 00 00 00 00       	mov    $0x0,%eax
f01008d3:	c9                   	leave  
f01008d4:	c3                   	ret    

f01008d5 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f01008d5:	55                   	push   %ebp
f01008d6:	89 e5                	mov    %esp,%ebp
f01008d8:	56                   	push   %esi
f01008d9:	53                   	push   %ebx
f01008da:	83 ec 2c             	sub    $0x2c,%esp
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01008dd:	89 eb                	mov    %ebp,%ebx
	// Your code here.
	uint32_t *ebp;
	struct Eipdebuginfo info;
	int result;
	ebp = (uint32_t*)read_ebp();
	cprintf("Stack backtrace:\n");
f01008df:	68 18 70 10 f0       	push   $0xf0107018
f01008e4:	e8 47 30 00 00       	call   f0103930 <cprintf>
	while(ebp != 0)
f01008e9:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n",
		ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
		memset(&info, 0, sizeof(struct Eipdebuginfo));
f01008ec:	8d 75 e0             	lea    -0x20(%ebp),%esi
	while(ebp != 0)
f01008ef:	eb 25                	jmp    f0100916 <mon_backtrace+0x41>
		{
			cprintf("failed to get debuginfo for eip %x.\n", ebp[1]);
		}
		else
		{
			cprintf("\t%s:%d: %.*s+%u\n", info.eip_file, info.eip_line,
f01008f1:	83 ec 08             	sub    $0x8,%esp
f01008f4:	8b 43 04             	mov    0x4(%ebx),%eax
f01008f7:	2b 45 f0             	sub    -0x10(%ebp),%eax
f01008fa:	50                   	push   %eax
f01008fb:	ff 75 e8             	pushl  -0x18(%ebp)
f01008fe:	ff 75 ec             	pushl  -0x14(%ebp)
f0100901:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100904:	ff 75 e0             	pushl  -0x20(%ebp)
f0100907:	68 2a 70 10 f0       	push   $0xf010702a
f010090c:	e8 1f 30 00 00       	call   f0103930 <cprintf>
f0100911:	83 c4 20             	add    $0x20,%esp
			info.eip_fn_namelen, info.eip_fn_name, ebp[1] - info.eip_fn_addr);
		}
		ebp = (uint32_t*)*ebp;
f0100914:	8b 1b                	mov    (%ebx),%ebx
	while(ebp != 0)
f0100916:	85 db                	test   %ebx,%ebx
f0100918:	74 52                	je     f010096c <mon_backtrace+0x97>
		cprintf("  ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n",
f010091a:	ff 73 18             	pushl  0x18(%ebx)
f010091d:	ff 73 14             	pushl  0x14(%ebx)
f0100920:	ff 73 10             	pushl  0x10(%ebx)
f0100923:	ff 73 0c             	pushl  0xc(%ebx)
f0100926:	ff 73 08             	pushl  0x8(%ebx)
f0100929:	ff 73 04             	pushl  0x4(%ebx)
f010092c:	53                   	push   %ebx
f010092d:	68 b0 71 10 f0       	push   $0xf01071b0
f0100932:	e8 f9 2f 00 00       	call   f0103930 <cprintf>
		memset(&info, 0, sizeof(struct Eipdebuginfo));
f0100937:	83 c4 1c             	add    $0x1c,%esp
f010093a:	6a 18                	push   $0x18
f010093c:	6a 00                	push   $0x0
f010093e:	56                   	push   %esi
f010093f:	e8 6b 51 00 00       	call   f0105aaf <memset>
		result = debuginfo_eip(ebp[1], &info);
f0100944:	83 c4 08             	add    $0x8,%esp
f0100947:	56                   	push   %esi
f0100948:	ff 73 04             	pushl  0x4(%ebx)
f010094b:	e8 18 46 00 00       	call   f0104f68 <debuginfo_eip>
		if(0 != result)
f0100950:	83 c4 10             	add    $0x10,%esp
f0100953:	85 c0                	test   %eax,%eax
f0100955:	74 9a                	je     f01008f1 <mon_backtrace+0x1c>
			cprintf("failed to get debuginfo for eip %x.\n", ebp[1]);
f0100957:	83 ec 08             	sub    $0x8,%esp
f010095a:	ff 73 04             	pushl  0x4(%ebx)
f010095d:	68 e8 71 10 f0       	push   $0xf01071e8
f0100962:	e8 c9 2f 00 00       	call   f0103930 <cprintf>
f0100967:	83 c4 10             	add    $0x10,%esp
f010096a:	eb a8                	jmp    f0100914 <mon_backtrace+0x3f>
	}
	return 0;
}
f010096c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100971:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100974:	5b                   	pop    %ebx
f0100975:	5e                   	pop    %esi
f0100976:	5d                   	pop    %ebp
f0100977:	c3                   	ret    

f0100978 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100978:	55                   	push   %ebp
f0100979:	89 e5                	mov    %esp,%ebp
f010097b:	57                   	push   %edi
f010097c:	56                   	push   %esi
f010097d:	53                   	push   %ebx
f010097e:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100981:	68 10 72 10 f0       	push   $0xf0107210
f0100986:	e8 a5 2f 00 00       	call   f0103930 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f010098b:	c7 04 24 34 72 10 f0 	movl   $0xf0107234,(%esp)
f0100992:	e8 99 2f 00 00       	call   f0103930 <cprintf>

	if (tf != NULL)
f0100997:	83 c4 10             	add    $0x10,%esp
f010099a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f010099e:	74 57                	je     f01009f7 <monitor+0x7f>
		print_trapframe(tf);
f01009a0:	83 ec 0c             	sub    $0xc,%esp
f01009a3:	ff 75 08             	pushl  0x8(%ebp)
f01009a6:	e8 e3 36 00 00       	call   f010408e <print_trapframe>
f01009ab:	83 c4 10             	add    $0x10,%esp
f01009ae:	eb 47                	jmp    f01009f7 <monitor+0x7f>
		while (*buf && strchr(WHITESPACE, *buf))
f01009b0:	83 ec 08             	sub    $0x8,%esp
f01009b3:	0f be c0             	movsbl %al,%eax
f01009b6:	50                   	push   %eax
f01009b7:	68 3f 70 10 f0       	push   $0xf010703f
f01009bc:	e8 b1 50 00 00       	call   f0105a72 <strchr>
f01009c1:	83 c4 10             	add    $0x10,%esp
f01009c4:	85 c0                	test   %eax,%eax
f01009c6:	74 0a                	je     f01009d2 <monitor+0x5a>
			*buf++ = 0;
f01009c8:	c6 03 00             	movb   $0x0,(%ebx)
f01009cb:	89 f7                	mov    %esi,%edi
f01009cd:	8d 5b 01             	lea    0x1(%ebx),%ebx
f01009d0:	eb 6b                	jmp    f0100a3d <monitor+0xc5>
		if (*buf == 0)
f01009d2:	80 3b 00             	cmpb   $0x0,(%ebx)
f01009d5:	74 73                	je     f0100a4a <monitor+0xd2>
		if (argc == MAXARGS-1) {
f01009d7:	83 fe 0f             	cmp    $0xf,%esi
f01009da:	74 09                	je     f01009e5 <monitor+0x6d>
		argv[argc++] = buf;
f01009dc:	8d 7e 01             	lea    0x1(%esi),%edi
f01009df:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f01009e3:	eb 39                	jmp    f0100a1e <monitor+0xa6>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f01009e5:	83 ec 08             	sub    $0x8,%esp
f01009e8:	6a 10                	push   $0x10
f01009ea:	68 44 70 10 f0       	push   $0xf0107044
f01009ef:	e8 3c 2f 00 00       	call   f0103930 <cprintf>
f01009f4:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f01009f7:	83 ec 0c             	sub    $0xc,%esp
f01009fa:	68 3b 70 10 f0       	push   $0xf010703b
f01009ff:	e8 45 4e 00 00       	call   f0105849 <readline>
f0100a04:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a06:	83 c4 10             	add    $0x10,%esp
f0100a09:	85 c0                	test   %eax,%eax
f0100a0b:	74 ea                	je     f01009f7 <monitor+0x7f>
	argv[argc] = 0;
f0100a0d:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a14:	be 00 00 00 00       	mov    $0x0,%esi
f0100a19:	eb 24                	jmp    f0100a3f <monitor+0xc7>
			buf++;
f0100a1b:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a1e:	0f b6 03             	movzbl (%ebx),%eax
f0100a21:	84 c0                	test   %al,%al
f0100a23:	74 18                	je     f0100a3d <monitor+0xc5>
f0100a25:	83 ec 08             	sub    $0x8,%esp
f0100a28:	0f be c0             	movsbl %al,%eax
f0100a2b:	50                   	push   %eax
f0100a2c:	68 3f 70 10 f0       	push   $0xf010703f
f0100a31:	e8 3c 50 00 00       	call   f0105a72 <strchr>
f0100a36:	83 c4 10             	add    $0x10,%esp
f0100a39:	85 c0                	test   %eax,%eax
f0100a3b:	74 de                	je     f0100a1b <monitor+0xa3>
			*buf++ = 0;
f0100a3d:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100a3f:	0f b6 03             	movzbl (%ebx),%eax
f0100a42:	84 c0                	test   %al,%al
f0100a44:	0f 85 66 ff ff ff    	jne    f01009b0 <monitor+0x38>
	argv[argc] = 0;
f0100a4a:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100a51:	00 
	if (argc == 0)
f0100a52:	85 f6                	test   %esi,%esi
f0100a54:	74 a1                	je     f01009f7 <monitor+0x7f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a56:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100a5b:	83 ec 08             	sub    $0x8,%esp
f0100a5e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a61:	ff 34 85 60 72 10 f0 	pushl  -0xfef8da0(,%eax,4)
f0100a68:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a6b:	e8 a4 4f 00 00       	call   f0105a14 <strcmp>
f0100a70:	83 c4 10             	add    $0x10,%esp
f0100a73:	85 c0                	test   %eax,%eax
f0100a75:	74 20                	je     f0100a97 <monitor+0x11f>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100a77:	83 c3 01             	add    $0x1,%ebx
f0100a7a:	83 fb 03             	cmp    $0x3,%ebx
f0100a7d:	75 dc                	jne    f0100a5b <monitor+0xe3>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100a7f:	83 ec 08             	sub    $0x8,%esp
f0100a82:	ff 75 a8             	pushl  -0x58(%ebp)
f0100a85:	68 61 70 10 f0       	push   $0xf0107061
f0100a8a:	e8 a1 2e 00 00       	call   f0103930 <cprintf>
f0100a8f:	83 c4 10             	add    $0x10,%esp
f0100a92:	e9 60 ff ff ff       	jmp    f01009f7 <monitor+0x7f>
			return commands[i].func(argc, argv, tf);
f0100a97:	83 ec 04             	sub    $0x4,%esp
f0100a9a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100a9d:	ff 75 08             	pushl  0x8(%ebp)
f0100aa0:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0100aa3:	52                   	push   %edx
f0100aa4:	56                   	push   %esi
f0100aa5:	ff 14 85 68 72 10 f0 	call   *-0xfef8d98(,%eax,4)
			if (runcmd(buf, tf) < 0)
f0100aac:	83 c4 10             	add    $0x10,%esp
f0100aaf:	85 c0                	test   %eax,%eax
f0100ab1:	0f 89 40 ff ff ff    	jns    f01009f7 <monitor+0x7f>
				break;
	}
}
f0100ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100aba:	5b                   	pop    %ebx
f0100abb:	5e                   	pop    %esi
f0100abc:	5f                   	pop    %edi
f0100abd:	5d                   	pop    %ebp
f0100abe:	c3                   	ret    

f0100abf <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0100abf:	55                   	push   %ebp
f0100ac0:	89 e5                	mov    %esp,%ebp
f0100ac2:	56                   	push   %esi
f0100ac3:	53                   	push   %ebx
f0100ac4:	89 c6                	mov    %eax,%esi
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100ac6:	83 ec 0c             	sub    $0xc,%esp
f0100ac9:	50                   	push   %eax
f0100aca:	e8 c2 2c 00 00       	call   f0103791 <mc146818_read>
f0100acf:	89 c3                	mov    %eax,%ebx
f0100ad1:	83 c6 01             	add    $0x1,%esi
f0100ad4:	89 34 24             	mov    %esi,(%esp)
f0100ad7:	e8 b5 2c 00 00       	call   f0103791 <mc146818_read>
f0100adc:	c1 e0 08             	shl    $0x8,%eax
f0100adf:	09 d8                	or     %ebx,%eax
}
f0100ae1:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0100ae4:	5b                   	pop    %ebx
f0100ae5:	5e                   	pop    %esi
f0100ae6:	5d                   	pop    %ebp
f0100ae7:	c3                   	ret    

f0100ae8 <boot_alloc>:
// before the page_free_list list has been set up.
// Note that when this function is called, we are still using entry_pgdir,
// which only maps the first 4MB of physical memory.
static void *
boot_alloc(uint32_t n)
{
f0100ae8:	89 c2                	mov    %eax,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree)
f0100aea:	83 3d 38 e2 2a f0 00 	cmpl   $0x0,0xf02ae238
f0100af1:	74 31                	je     f0100b24 <boot_alloc+0x3c>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	if (n == 0)
f0100af3:	85 d2                	test   %edx,%edx
f0100af5:	74 3e                	je     f0100b35 <boot_alloc+0x4d>
		return nextfree;
	result = nextfree;
f0100af7:	a1 38 e2 2a f0       	mov    0xf02ae238,%eax
	nextfree = ROUNDUP(nextfree + n, PGSIZE);
f0100afc:	8d 94 10 ff 0f 00 00 	lea    0xfff(%eax,%edx,1),%edx
f0100b03:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100b09:	89 15 38 e2 2a f0    	mov    %edx,0xf02ae238
	if ((uint32_t)nextfree - KERNBASE > (npages * PGSIZE))
f0100b0f:	81 c2 00 00 00 10    	add    $0x10000000,%edx
f0100b15:	8b 0d a0 ee 2a f0    	mov    0xf02aeea0,%ecx
f0100b1b:	c1 e1 0c             	shl    $0xc,%ecx
f0100b1e:	39 ca                	cmp    %ecx,%edx
f0100b20:	77 19                	ja     f0100b3b <boot_alloc+0x53>
		panic("Out of memory!\n");
	return result;
}
f0100b22:	f3 c3                	repz ret 
		nextfree = ROUNDUP((char *)end, PGSIZE);
f0100b24:	b8 07 10 2f f0       	mov    $0xf02f1007,%eax
f0100b29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b2e:	a3 38 e2 2a f0       	mov    %eax,0xf02ae238
f0100b33:	eb be                	jmp    f0100af3 <boot_alloc+0xb>
		return nextfree;
f0100b35:	a1 38 e2 2a f0       	mov    0xf02ae238,%eax
f0100b3a:	c3                   	ret    
{
f0100b3b:	55                   	push   %ebp
f0100b3c:	89 e5                	mov    %esp,%ebp
f0100b3e:	83 ec 0c             	sub    $0xc,%esp
		panic("Out of memory!\n");
f0100b41:	68 84 72 10 f0       	push   $0xf0107284
f0100b46:	6a 72                	push   $0x72
f0100b48:	68 94 72 10 f0       	push   $0xf0107294
f0100b4d:	e8 ee f4 ff ff       	call   f0100040 <_panic>

f0100b52 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100b52:	89 d1                	mov    %edx,%ecx
f0100b54:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100b57:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100b5a:	a8 01                	test   $0x1,%al
f0100b5c:	74 52                	je     f0100bb0 <check_va2pa+0x5e>
		return ~0;
	p = (pte_t *)KADDR(PTE_ADDR(*pgdir));
f0100b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100b63:	89 c1                	mov    %eax,%ecx
f0100b65:	c1 e9 0c             	shr    $0xc,%ecx
f0100b68:	3b 0d a0 ee 2a f0    	cmp    0xf02aeea0,%ecx
f0100b6e:	73 25                	jae    f0100b95 <check_va2pa+0x43>
	if (!(p[PTX(va)] & PTE_P))
f0100b70:	c1 ea 0c             	shr    $0xc,%edx
f0100b73:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100b79:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100b80:	89 c2                	mov    %eax,%edx
f0100b82:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100b85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b8a:	85 d2                	test   %edx,%edx
f0100b8c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100b91:	0f 44 c2             	cmove  %edx,%eax
f0100b94:	c3                   	ret    
{
f0100b95:	55                   	push   %ebp
f0100b96:	89 e5                	mov    %esp,%ebp
f0100b98:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100b9b:	50                   	push   %eax
f0100b9c:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0100ba1:	68 90 03 00 00       	push   $0x390
f0100ba6:	68 94 72 10 f0       	push   $0xf0107294
f0100bab:	e8 90 f4 ff ff       	call   f0100040 <_panic>
		return ~0;
f0100bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100bb5:	c3                   	ret    

f0100bb6 <check_page_free_list>:
{
f0100bb6:	55                   	push   %ebp
f0100bb7:	89 e5                	mov    %esp,%ebp
f0100bb9:	57                   	push   %edi
f0100bba:	56                   	push   %esi
f0100bbb:	53                   	push   %ebx
f0100bbc:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bbf:	84 c0                	test   %al,%al
f0100bc1:	0f 85 86 02 00 00    	jne    f0100e4d <check_page_free_list+0x297>
	if (!page_free_list)
f0100bc7:	83 3d 40 e2 2a f0 00 	cmpl   $0x0,0xf02ae240
f0100bce:	74 0a                	je     f0100bda <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100bd0:	be 00 04 00 00       	mov    $0x400,%esi
f0100bd5:	e9 ce 02 00 00       	jmp    f0100ea8 <check_page_free_list+0x2f2>
		panic("'page_free_list' is a null pointer!");
f0100bda:	83 ec 04             	sub    $0x4,%esp
f0100bdd:	68 50 75 10 f0       	push   $0xf0107550
f0100be2:	68 c1 02 00 00       	push   $0x2c1
f0100be7:	68 94 72 10 f0       	push   $0xf0107294
f0100bec:	e8 4f f4 ff ff       	call   f0100040 <_panic>
f0100bf1:	50                   	push   %eax
f0100bf2:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0100bf7:	6a 58                	push   $0x58
f0100bf9:	68 a0 72 10 f0       	push   $0xf01072a0
f0100bfe:	e8 3d f4 ff ff       	call   f0100040 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c03:	8b 1b                	mov    (%ebx),%ebx
f0100c05:	85 db                	test   %ebx,%ebx
f0100c07:	74 41                	je     f0100c4a <check_page_free_list+0x94>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100c09:	89 d8                	mov    %ebx,%eax
f0100c0b:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0100c11:	c1 f8 03             	sar    $0x3,%eax
f0100c14:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100c17:	89 c2                	mov    %eax,%edx
f0100c19:	c1 ea 16             	shr    $0x16,%edx
f0100c1c:	39 f2                	cmp    %esi,%edx
f0100c1e:	73 e3                	jae    f0100c03 <check_page_free_list+0x4d>
	if (PGNUM(pa) >= npages)
f0100c20:	89 c2                	mov    %eax,%edx
f0100c22:	c1 ea 0c             	shr    $0xc,%edx
f0100c25:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f0100c2b:	73 c4                	jae    f0100bf1 <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100c2d:	83 ec 04             	sub    $0x4,%esp
f0100c30:	68 80 00 00 00       	push   $0x80
f0100c35:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100c3a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100c3f:	50                   	push   %eax
f0100c40:	e8 6a 4e 00 00       	call   f0105aaf <memset>
f0100c45:	83 c4 10             	add    $0x10,%esp
f0100c48:	eb b9                	jmp    f0100c03 <check_page_free_list+0x4d>
	first_free_page = (char *)boot_alloc(0);
f0100c4a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c4f:	e8 94 fe ff ff       	call   f0100ae8 <boot_alloc>
f0100c54:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c57:	8b 15 40 e2 2a f0    	mov    0xf02ae240,%edx
		assert(pp >= pages);
f0100c5d:	8b 0d a8 ee 2a f0    	mov    0xf02aeea8,%ecx
		assert(pp < pages + npages);
f0100c63:	a1 a0 ee 2a f0       	mov    0xf02aeea0,%eax
f0100c68:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100c6b:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100c6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(((char *)pp - (char *)pages) % sizeof(*pp) == 0);
f0100c71:	89 4d d0             	mov    %ecx,-0x30(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0100c74:	be 00 00 00 00       	mov    $0x0,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100c79:	e9 04 01 00 00       	jmp    f0100d82 <check_page_free_list+0x1cc>
		assert(pp >= pages);
f0100c7e:	68 ae 72 10 f0       	push   $0xf01072ae
f0100c83:	68 ba 72 10 f0       	push   $0xf01072ba
f0100c88:	68 de 02 00 00       	push   $0x2de
f0100c8d:	68 94 72 10 f0       	push   $0xf0107294
f0100c92:	e8 a9 f3 ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f0100c97:	68 cf 72 10 f0       	push   $0xf01072cf
f0100c9c:	68 ba 72 10 f0       	push   $0xf01072ba
f0100ca1:	68 df 02 00 00       	push   $0x2df
f0100ca6:	68 94 72 10 f0       	push   $0xf0107294
f0100cab:	e8 90 f3 ff ff       	call   f0100040 <_panic>
		assert(((char *)pp - (char *)pages) % sizeof(*pp) == 0);
f0100cb0:	68 74 75 10 f0       	push   $0xf0107574
f0100cb5:	68 ba 72 10 f0       	push   $0xf01072ba
f0100cba:	68 e0 02 00 00       	push   $0x2e0
f0100cbf:	68 94 72 10 f0       	push   $0xf0107294
f0100cc4:	e8 77 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != 0);
f0100cc9:	68 e3 72 10 f0       	push   $0xf01072e3
f0100cce:	68 ba 72 10 f0       	push   $0xf01072ba
f0100cd3:	68 e3 02 00 00       	push   $0x2e3
f0100cd8:	68 94 72 10 f0       	push   $0xf0107294
f0100cdd:	e8 5e f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100ce2:	68 f4 72 10 f0       	push   $0xf01072f4
f0100ce7:	68 ba 72 10 f0       	push   $0xf01072ba
f0100cec:	68 e4 02 00 00       	push   $0x2e4
f0100cf1:	68 94 72 10 f0       	push   $0xf0107294
f0100cf6:	e8 45 f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100cfb:	68 a4 75 10 f0       	push   $0xf01075a4
f0100d00:	68 ba 72 10 f0       	push   $0xf01072ba
f0100d05:	68 e5 02 00 00       	push   $0x2e5
f0100d0a:	68 94 72 10 f0       	push   $0xf0107294
f0100d0f:	e8 2c f3 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100d14:	68 0d 73 10 f0       	push   $0xf010730d
f0100d19:	68 ba 72 10 f0       	push   $0xf01072ba
f0100d1e:	68 e6 02 00 00       	push   $0x2e6
f0100d23:	68 94 72 10 f0       	push   $0xf0107294
f0100d28:	e8 13 f3 ff ff       	call   f0100040 <_panic>
	if (PGNUM(pa) >= npages)
f0100d2d:	89 c7                	mov    %eax,%edi
f0100d2f:	c1 ef 0c             	shr    $0xc,%edi
f0100d32:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100d35:	76 1b                	jbe    f0100d52 <check_page_free_list+0x19c>
	return (void *)(pa + KERNBASE);
f0100d37:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
		assert(page2pa(pp) < EXTPHYSMEM || (char *)page2kva(pp) >= first_free_page);
f0100d3d:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100d40:	77 22                	ja     f0100d64 <check_page_free_list+0x1ae>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100d42:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100d47:	0f 84 98 00 00 00    	je     f0100de5 <check_page_free_list+0x22f>
			++nfree_extmem;
f0100d4d:	83 c3 01             	add    $0x1,%ebx
f0100d50:	eb 2e                	jmp    f0100d80 <check_page_free_list+0x1ca>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d52:	50                   	push   %eax
f0100d53:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0100d58:	6a 58                	push   $0x58
f0100d5a:	68 a0 72 10 f0       	push   $0xf01072a0
f0100d5f:	e8 dc f2 ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *)page2kva(pp) >= first_free_page);
f0100d64:	68 c8 75 10 f0       	push   $0xf01075c8
f0100d69:	68 ba 72 10 f0       	push   $0xf01072ba
f0100d6e:	68 e7 02 00 00       	push   $0x2e7
f0100d73:	68 94 72 10 f0       	push   $0xf0107294
f0100d78:	e8 c3 f2 ff ff       	call   f0100040 <_panic>
			++nfree_basemem;
f0100d7d:	83 c6 01             	add    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100d80:	8b 12                	mov    (%edx),%edx
f0100d82:	85 d2                	test   %edx,%edx
f0100d84:	74 78                	je     f0100dfe <check_page_free_list+0x248>
		assert(pp >= pages);
f0100d86:	39 d1                	cmp    %edx,%ecx
f0100d88:	0f 87 f0 fe ff ff    	ja     f0100c7e <check_page_free_list+0xc8>
		assert(pp < pages + npages);
f0100d8e:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f0100d91:	0f 86 00 ff ff ff    	jbe    f0100c97 <check_page_free_list+0xe1>
		assert(((char *)pp - (char *)pages) % sizeof(*pp) == 0);
f0100d97:	89 d0                	mov    %edx,%eax
f0100d99:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100d9c:	a8 07                	test   $0x7,%al
f0100d9e:	0f 85 0c ff ff ff    	jne    f0100cb0 <check_page_free_list+0xfa>
	return (pp - pages) << PGSHIFT;
f0100da4:	c1 f8 03             	sar    $0x3,%eax
f0100da7:	c1 e0 0c             	shl    $0xc,%eax
		assert(page2pa(pp) != 0);
f0100daa:	85 c0                	test   %eax,%eax
f0100dac:	0f 84 17 ff ff ff    	je     f0100cc9 <check_page_free_list+0x113>
		assert(page2pa(pp) != IOPHYSMEM);
f0100db2:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100db7:	0f 84 25 ff ff ff    	je     f0100ce2 <check_page_free_list+0x12c>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100dbd:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100dc2:	0f 84 33 ff ff ff    	je     f0100cfb <check_page_free_list+0x145>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100dc8:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100dcd:	0f 84 41 ff ff ff    	je     f0100d14 <check_page_free_list+0x15e>
		assert(page2pa(pp) < EXTPHYSMEM || (char *)page2kva(pp) >= first_free_page);
f0100dd3:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100dd8:	0f 87 4f ff ff ff    	ja     f0100d2d <check_page_free_list+0x177>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100dde:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100de3:	75 98                	jne    f0100d7d <check_page_free_list+0x1c7>
f0100de5:	68 27 73 10 f0       	push   $0xf0107327
f0100dea:	68 ba 72 10 f0       	push   $0xf01072ba
f0100def:	68 e9 02 00 00       	push   $0x2e9
f0100df4:	68 94 72 10 f0       	push   $0xf0107294
f0100df9:	e8 42 f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_basemem > 0);
f0100dfe:	85 f6                	test   %esi,%esi
f0100e00:	7e 19                	jle    f0100e1b <check_page_free_list+0x265>
	assert(nfree_extmem > 0);
f0100e02:	85 db                	test   %ebx,%ebx
f0100e04:	7e 2e                	jle    f0100e34 <check_page_free_list+0x27e>
	cprintf("check_page_free_list() succeeded!\n");
f0100e06:	83 ec 0c             	sub    $0xc,%esp
f0100e09:	68 0c 76 10 f0       	push   $0xf010760c
f0100e0e:	e8 1d 2b 00 00       	call   f0103930 <cprintf>
}
f0100e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100e16:	5b                   	pop    %ebx
f0100e17:	5e                   	pop    %esi
f0100e18:	5f                   	pop    %edi
f0100e19:	5d                   	pop    %ebp
f0100e1a:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100e1b:	68 44 73 10 f0       	push   $0xf0107344
f0100e20:	68 ba 72 10 f0       	push   $0xf01072ba
f0100e25:	68 f1 02 00 00       	push   $0x2f1
f0100e2a:	68 94 72 10 f0       	push   $0xf0107294
f0100e2f:	e8 0c f2 ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0100e34:	68 56 73 10 f0       	push   $0xf0107356
f0100e39:	68 ba 72 10 f0       	push   $0xf01072ba
f0100e3e:	68 f2 02 00 00       	push   $0x2f2
f0100e43:	68 94 72 10 f0       	push   $0xf0107294
f0100e48:	e8 f3 f1 ff ff       	call   f0100040 <_panic>
	if (!page_free_list)
f0100e4d:	a1 40 e2 2a f0       	mov    0xf02ae240,%eax
f0100e52:	85 c0                	test   %eax,%eax
f0100e54:	0f 84 80 fd ff ff    	je     f0100bda <check_page_free_list+0x24>
		struct PageInfo **tp[2] = {&pp1, &pp2};
f0100e5a:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100e5d:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100e60:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100e63:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100e66:	89 c2                	mov    %eax,%edx
f0100e68:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100e6e:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100e74:	0f 95 c2             	setne  %dl
f0100e77:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100e7a:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100e7e:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100e80:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link)
f0100e84:	8b 00                	mov    (%eax),%eax
f0100e86:	85 c0                	test   %eax,%eax
f0100e88:	75 dc                	jne    f0100e66 <check_page_free_list+0x2b0>
		*tp[1] = 0;
f0100e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100e8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100e93:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100e99:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100e9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100e9e:	a3 40 e2 2a f0       	mov    %eax,0xf02ae240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ea3:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100ea8:	8b 1d 40 e2 2a f0    	mov    0xf02ae240,%ebx
f0100eae:	e9 52 fd ff ff       	jmp    f0100c05 <check_page_free_list+0x4f>

f0100eb3 <page_init>:
{
f0100eb3:	55                   	push   %ebp
f0100eb4:	89 e5                	mov    %esp,%ebp
f0100eb6:	57                   	push   %edi
f0100eb7:	56                   	push   %esi
f0100eb8:	53                   	push   %ebx
f0100eb9:	83 ec 0c             	sub    $0xc,%esp
	pages[0].pp_ref = 1;
f0100ebc:	a1 a8 ee 2a f0       	mov    0xf02aeea8,%eax
f0100ec1:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0100ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	size_t kernel_end_page = PADDR(boot_alloc(0)) / PGSIZE;
f0100ecd:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ed2:	e8 11 fc ff ff       	call   f0100ae8 <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0100ed7:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100edc:	76 20                	jbe    f0100efe <page_init+0x4b>
	return (physaddr_t)kva - KERNBASE;
f0100ede:	05 00 00 00 10       	add    $0x10000000,%eax
f0100ee3:	c1 e8 0c             	shr    $0xc,%eax
		if (i >= npages_basemem && i < kernel_end_page)
f0100ee6:	8b 3d 44 e2 2a f0    	mov    0xf02ae244,%edi
f0100eec:	8b 35 40 e2 2a f0    	mov    0xf02ae240,%esi
	for (i = 1; i < npages; i++)
f0100ef2:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100ef7:	ba 01 00 00 00       	mov    $0x1,%edx
f0100efc:	eb 41                	jmp    f0100f3f <page_init+0x8c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100efe:	50                   	push   %eax
f0100eff:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0100f04:	68 45 01 00 00       	push   $0x145
f0100f09:	68 94 72 10 f0       	push   $0xf0107294
f0100f0e:	e8 2d f1 ff ff       	call   f0100040 <_panic>
		else if (i == mpentry)
f0100f13:	83 fa 07             	cmp    $0x7,%edx
f0100f16:	74 4e                	je     f0100f66 <page_init+0xb3>
			pages[i].pp_ref = 0;
f0100f18:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
f0100f1f:	89 cb                	mov    %ecx,%ebx
f0100f21:	03 1d a8 ee 2a f0    	add    0xf02aeea8,%ebx
f0100f27:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
			pages[i].pp_link = page_free_list;
f0100f2d:	89 33                	mov    %esi,(%ebx)
			page_free_list = &pages[i];
f0100f2f:	89 ce                	mov    %ecx,%esi
f0100f31:	03 35 a8 ee 2a f0    	add    0xf02aeea8,%esi
f0100f37:	b9 01 00 00 00       	mov    $0x1,%ecx
	for (i = 1; i < npages; i++)
f0100f3c:	83 c2 01             	add    $0x1,%edx
f0100f3f:	39 15 a0 ee 2a f0    	cmp    %edx,0xf02aeea0
f0100f45:	76 34                	jbe    f0100f7b <page_init+0xc8>
		if (i >= npages_basemem && i < kernel_end_page)
f0100f47:	39 c2                	cmp    %eax,%edx
f0100f49:	73 c8                	jae    f0100f13 <page_init+0x60>
f0100f4b:	39 d7                	cmp    %edx,%edi
f0100f4d:	77 c4                	ja     f0100f13 <page_init+0x60>
			pages[i].pp_ref = 1;
f0100f4f:	8b 1d a8 ee 2a f0    	mov    0xf02aeea8,%ebx
f0100f55:	8d 1c d3             	lea    (%ebx,%edx,8),%ebx
f0100f58:	66 c7 43 04 01 00    	movw   $0x1,0x4(%ebx)
			pages[i].pp_link = NULL;
f0100f5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
f0100f64:	eb d6                	jmp    f0100f3c <page_init+0x89>
			pages[i].pp_ref = 1;
f0100f66:	8b 1d a8 ee 2a f0    	mov    0xf02aeea8,%ebx
f0100f6c:	66 c7 43 3c 01 00    	movw   $0x1,0x3c(%ebx)
			pages[i].pp_link = NULL;
f0100f72:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
f0100f79:	eb c1                	jmp    f0100f3c <page_init+0x89>
f0100f7b:	84 c9                	test   %cl,%cl
f0100f7d:	75 08                	jne    f0100f87 <page_init+0xd4>
}
f0100f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f82:	5b                   	pop    %ebx
f0100f83:	5e                   	pop    %esi
f0100f84:	5f                   	pop    %edi
f0100f85:	5d                   	pop    %ebp
f0100f86:	c3                   	ret    
f0100f87:	89 35 40 e2 2a f0    	mov    %esi,0xf02ae240
f0100f8d:	eb f0                	jmp    f0100f7f <page_init+0xcc>

f0100f8f <page_alloc>:
{
f0100f8f:	55                   	push   %ebp
f0100f90:	89 e5                	mov    %esp,%ebp
f0100f92:	53                   	push   %ebx
f0100f93:	83 ec 04             	sub    $0x4,%esp
	if (page_free_list == NULL)
f0100f96:	8b 1d 40 e2 2a f0    	mov    0xf02ae240,%ebx
f0100f9c:	85 db                	test   %ebx,%ebx
f0100f9e:	74 13                	je     f0100fb3 <page_alloc+0x24>
	page_free_list = page_free_list->pp_link;
f0100fa0:	8b 03                	mov    (%ebx),%eax
f0100fa2:	a3 40 e2 2a f0       	mov    %eax,0xf02ae240
	res->pp_link = NULL;
f0100fa7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if (alloc_flags & ALLOC_ZERO)
f0100fad:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f0100fb1:	75 07                	jne    f0100fba <page_alloc+0x2b>
}
f0100fb3:	89 d8                	mov    %ebx,%eax
f0100fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100fb8:	c9                   	leave  
f0100fb9:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f0100fba:	89 d8                	mov    %ebx,%eax
f0100fbc:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0100fc2:	c1 f8 03             	sar    $0x3,%eax
f0100fc5:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0100fc8:	89 c2                	mov    %eax,%edx
f0100fca:	c1 ea 0c             	shr    $0xc,%edx
f0100fcd:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f0100fd3:	73 1a                	jae    f0100fef <page_alloc+0x60>
		memset(page2kva(res), '\0', PGSIZE);
f0100fd5:	83 ec 04             	sub    $0x4,%esp
f0100fd8:	68 00 10 00 00       	push   $0x1000
f0100fdd:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f0100fdf:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100fe4:	50                   	push   %eax
f0100fe5:	e8 c5 4a 00 00       	call   f0105aaf <memset>
f0100fea:	83 c4 10             	add    $0x10,%esp
f0100fed:	eb c4                	jmp    f0100fb3 <page_alloc+0x24>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100fef:	50                   	push   %eax
f0100ff0:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0100ff5:	6a 58                	push   $0x58
f0100ff7:	68 a0 72 10 f0       	push   $0xf01072a0
f0100ffc:	e8 3f f0 ff ff       	call   f0100040 <_panic>

f0101001 <page_free>:
{
f0101001:	55                   	push   %ebp
f0101002:	89 e5                	mov    %esp,%ebp
f0101004:	83 ec 08             	sub    $0x8,%esp
f0101007:	8b 45 08             	mov    0x8(%ebp),%eax
	if (pp->pp_link != NULL || pp->pp_ref != 0)
f010100a:	83 38 00             	cmpl   $0x0,(%eax)
f010100d:	75 16                	jne    f0101025 <page_free+0x24>
f010100f:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101014:	75 0f                	jne    f0101025 <page_free+0x24>
	pp->pp_link = page_free_list;
f0101016:	8b 15 40 e2 2a f0    	mov    0xf02ae240,%edx
f010101c:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f010101e:	a3 40 e2 2a f0       	mov    %eax,0xf02ae240
}
f0101023:	c9                   	leave  
f0101024:	c3                   	ret    
		panic("pp->pp_link is not NULL or pp->pp_ref is not zero\n");
f0101025:	83 ec 04             	sub    $0x4,%esp
f0101028:	68 30 76 10 f0       	push   $0xf0107630
f010102d:	68 84 01 00 00       	push   $0x184
f0101032:	68 94 72 10 f0       	push   $0xf0107294
f0101037:	e8 04 f0 ff ff       	call   f0100040 <_panic>

f010103c <page_decref>:
{
f010103c:	55                   	push   %ebp
f010103d:	89 e5                	mov    %esp,%ebp
f010103f:	83 ec 08             	sub    $0x8,%esp
f0101042:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f0101045:	0f b7 42 04          	movzwl 0x4(%edx),%eax
f0101049:	83 e8 01             	sub    $0x1,%eax
f010104c:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101050:	66 85 c0             	test   %ax,%ax
f0101053:	74 02                	je     f0101057 <page_decref+0x1b>
}
f0101055:	c9                   	leave  
f0101056:	c3                   	ret    
		page_free(pp);
f0101057:	83 ec 0c             	sub    $0xc,%esp
f010105a:	52                   	push   %edx
f010105b:	e8 a1 ff ff ff       	call   f0101001 <page_free>
f0101060:	83 c4 10             	add    $0x10,%esp
}
f0101063:	eb f0                	jmp    f0101055 <page_decref+0x19>

f0101065 <pgdir_walk>:
{
f0101065:	55                   	push   %ebp
f0101066:	89 e5                	mov    %esp,%ebp
f0101068:	56                   	push   %esi
f0101069:	53                   	push   %ebx
f010106a:	8b 75 0c             	mov    0xc(%ebp),%esi
	pde_t *va_dir_entry = &pgdir[PDX(va)];
f010106d:	89 f3                	mov    %esi,%ebx
f010106f:	c1 eb 16             	shr    $0x16,%ebx
f0101072:	c1 e3 02             	shl    $0x2,%ebx
f0101075:	03 5d 08             	add    0x8(%ebp),%ebx
	if (!(*va_dir_entry & PTE_P))
f0101078:	f6 03 01             	testb  $0x1,(%ebx)
f010107b:	75 2d                	jne    f01010aa <pgdir_walk+0x45>
		if (!create)
f010107d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101081:	74 67                	je     f01010ea <pgdir_walk+0x85>
		struct PageInfo *pp = page_alloc(ALLOC_ZERO);
f0101083:	83 ec 0c             	sub    $0xc,%esp
f0101086:	6a 01                	push   $0x1
f0101088:	e8 02 ff ff ff       	call   f0100f8f <page_alloc>
		if (pp == NULL)
f010108d:	83 c4 10             	add    $0x10,%esp
f0101090:	85 c0                	test   %eax,%eax
f0101092:	74 5d                	je     f01010f1 <pgdir_walk+0x8c>
		pp->pp_ref++;
f0101094:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101099:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f010109f:	c1 f8 03             	sar    $0x3,%eax
f01010a2:	c1 e0 0c             	shl    $0xc,%eax
		*va_dir_entry = page2pa(pp) | PTE_U | PTE_P | PTE_W;
f01010a5:	83 c8 07             	or     $0x7,%eax
f01010a8:	89 03                	mov    %eax,(%ebx)
	return (pte_t *)KADDR(PTE_ADDR(*va_dir_entry)) + PTX(va); //返回页表项的虚拟地址
f01010aa:	8b 03                	mov    (%ebx),%eax
f01010ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f01010b1:	89 c2                	mov    %eax,%edx
f01010b3:	c1 ea 0c             	shr    $0xc,%edx
f01010b6:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f01010bc:	73 17                	jae    f01010d5 <pgdir_walk+0x70>
f01010be:	c1 ee 0a             	shr    $0xa,%esi
f01010c1:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f01010c7:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
}
f01010ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01010d1:	5b                   	pop    %ebx
f01010d2:	5e                   	pop    %esi
f01010d3:	5d                   	pop    %ebp
f01010d4:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010d5:	50                   	push   %eax
f01010d6:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01010db:	68 bc 01 00 00       	push   $0x1bc
f01010e0:	68 94 72 10 f0       	push   $0xf0107294
f01010e5:	e8 56 ef ff ff       	call   f0100040 <_panic>
			return NULL;
f01010ea:	b8 00 00 00 00       	mov    $0x0,%eax
f01010ef:	eb dd                	jmp    f01010ce <pgdir_walk+0x69>
			return NULL;
f01010f1:	b8 00 00 00 00       	mov    $0x0,%eax
f01010f6:	eb d6                	jmp    f01010ce <pgdir_walk+0x69>

f01010f8 <boot_map_region>:
{
f01010f8:	55                   	push   %ebp
f01010f9:	89 e5                	mov    %esp,%ebp
f01010fb:	57                   	push   %edi
f01010fc:	56                   	push   %esi
f01010fd:	53                   	push   %ebx
f01010fe:	83 ec 1c             	sub    $0x1c,%esp
f0101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101104:	8b 45 08             	mov    0x8(%ebp),%eax
	size_t pgs = size / PGSIZE;
f0101107:	89 cb                	mov    %ecx,%ebx
f0101109:	c1 eb 0c             	shr    $0xc,%ebx
	if (size % PGSIZE != 0)
f010110c:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
		pgs++;
f0101112:	83 f9 01             	cmp    $0x1,%ecx
f0101115:	83 db ff             	sbb    $0xffffffff,%ebx
f0101118:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	for (int i = 0; i < pgs; ++i)
f010111b:	89 c3                	mov    %eax,%ebx
f010111d:	be 00 00 00 00       	mov    $0x0,%esi
		pte_t *pg_table_entry = pgdir_walk(pgdir, (void *)va, 1);
f0101122:	89 d7                	mov    %edx,%edi
f0101124:	29 c7                	sub    %eax,%edi
		*pg_table_entry = pa | perm | PTE_P;
f0101126:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101129:	83 c8 01             	or     $0x1,%eax
f010112c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	for (int i = 0; i < pgs; ++i)
f010112f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
f0101132:	74 41                	je     f0101175 <boot_map_region+0x7d>
		pte_t *pg_table_entry = pgdir_walk(pgdir, (void *)va, 1);
f0101134:	83 ec 04             	sub    $0x4,%esp
f0101137:	6a 01                	push   $0x1
f0101139:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f010113c:	50                   	push   %eax
f010113d:	ff 75 e0             	pushl  -0x20(%ebp)
f0101140:	e8 20 ff ff ff       	call   f0101065 <pgdir_walk>
		if (pg_table_entry == NULL)
f0101145:	83 c4 10             	add    $0x10,%esp
f0101148:	85 c0                	test   %eax,%eax
f010114a:	74 12                	je     f010115e <boot_map_region+0x66>
		*pg_table_entry = pa | perm | PTE_P;
f010114c:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010114f:	09 da                	or     %ebx,%edx
f0101151:	89 10                	mov    %edx,(%eax)
		pa += PGSIZE;
f0101153:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (int i = 0; i < pgs; ++i)
f0101159:	83 c6 01             	add    $0x1,%esi
f010115c:	eb d1                	jmp    f010112f <boot_map_region+0x37>
			panic("no enough memory to allocate for page!");
f010115e:	83 ec 04             	sub    $0x4,%esp
f0101161:	68 64 76 10 f0       	push   $0xf0107664
f0101166:	68 d6 01 00 00       	push   $0x1d6
f010116b:	68 94 72 10 f0       	push   $0xf0107294
f0101170:	e8 cb ee ff ff       	call   f0100040 <_panic>
}
f0101175:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101178:	5b                   	pop    %ebx
f0101179:	5e                   	pop    %esi
f010117a:	5f                   	pop    %edi
f010117b:	5d                   	pop    %ebp
f010117c:	c3                   	ret    

f010117d <page_lookup>:
{
f010117d:	55                   	push   %ebp
f010117e:	89 e5                	mov    %esp,%ebp
f0101180:	53                   	push   %ebx
f0101181:	83 ec 08             	sub    $0x8,%esp
f0101184:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *va_table_entry = pgdir_walk(pgdir, va, 0);
f0101187:	6a 00                	push   $0x0
f0101189:	ff 75 0c             	pushl  0xc(%ebp)
f010118c:	ff 75 08             	pushl  0x8(%ebp)
f010118f:	e8 d1 fe ff ff       	call   f0101065 <pgdir_walk>
	if (va_table_entry == NULL || !(*va_table_entry & PTE_P))
f0101194:	83 c4 10             	add    $0x10,%esp
f0101197:	85 c0                	test   %eax,%eax
f0101199:	74 3a                	je     f01011d5 <page_lookup+0x58>
f010119b:	f6 00 01             	testb  $0x1,(%eax)
f010119e:	74 3c                	je     f01011dc <page_lookup+0x5f>
	if (pte_store != NULL)
f01011a0:	85 db                	test   %ebx,%ebx
f01011a2:	74 02                	je     f01011a6 <page_lookup+0x29>
		*pte_store = va_table_entry;
f01011a4:	89 03                	mov    %eax,(%ebx)
f01011a6:	8b 00                	mov    (%eax),%eax
f01011a8:	c1 e8 0c             	shr    $0xc,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01011ab:	39 05 a0 ee 2a f0    	cmp    %eax,0xf02aeea0
f01011b1:	76 0e                	jbe    f01011c1 <page_lookup+0x44>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01011b3:	8b 15 a8 ee 2a f0    	mov    0xf02aeea8,%edx
f01011b9:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01011bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01011bf:	c9                   	leave  
f01011c0:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01011c1:	83 ec 04             	sub    $0x4,%esp
f01011c4:	68 8c 76 10 f0       	push   $0xf010768c
f01011c9:	6a 51                	push   $0x51
f01011cb:	68 a0 72 10 f0       	push   $0xf01072a0
f01011d0:	e8 6b ee ff ff       	call   f0100040 <_panic>
		return NULL;
f01011d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01011da:	eb e0                	jmp    f01011bc <page_lookup+0x3f>
f01011dc:	b8 00 00 00 00       	mov    $0x0,%eax
f01011e1:	eb d9                	jmp    f01011bc <page_lookup+0x3f>

f01011e3 <tlb_invalidate>:
{
f01011e3:	55                   	push   %ebp
f01011e4:	89 e5                	mov    %esp,%ebp
f01011e6:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f01011e9:	e8 e5 4e 00 00       	call   f01060d3 <cpunum>
f01011ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01011f1:	83 b8 28 f0 2a f0 00 	cmpl   $0x0,-0xfd50fd8(%eax)
f01011f8:	74 16                	je     f0101210 <tlb_invalidate+0x2d>
f01011fa:	e8 d4 4e 00 00       	call   f01060d3 <cpunum>
f01011ff:	6b c0 74             	imul   $0x74,%eax,%eax
f0101202:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0101208:	8b 55 08             	mov    0x8(%ebp),%edx
f010120b:	39 50 60             	cmp    %edx,0x60(%eax)
f010120e:	75 06                	jne    f0101216 <tlb_invalidate+0x33>
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101210:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101213:	0f 01 38             	invlpg (%eax)
}
f0101216:	c9                   	leave  
f0101217:	c3                   	ret    

f0101218 <page_remove>:
{
f0101218:	55                   	push   %ebp
f0101219:	89 e5                	mov    %esp,%ebp
f010121b:	56                   	push   %esi
f010121c:	53                   	push   %ebx
f010121d:	83 ec 14             	sub    $0x14,%esp
f0101220:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101223:	8b 75 0c             	mov    0xc(%ebp),%esi
	pte_t *va_table_entry = NULL;
f0101226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	struct PageInfo *pp = page_lookup(pgdir, va, &va_table_entry);
f010122d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101230:	50                   	push   %eax
f0101231:	56                   	push   %esi
f0101232:	53                   	push   %ebx
f0101233:	e8 45 ff ff ff       	call   f010117d <page_lookup>
	if (pp == NULL)
f0101238:	83 c4 10             	add    $0x10,%esp
f010123b:	85 c0                	test   %eax,%eax
f010123d:	75 07                	jne    f0101246 <page_remove+0x2e>
}
f010123f:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101242:	5b                   	pop    %ebx
f0101243:	5e                   	pop    %esi
f0101244:	5d                   	pop    %ebp
f0101245:	c3                   	ret    
	page_decref(pp);
f0101246:	83 ec 0c             	sub    $0xc,%esp
f0101249:	50                   	push   %eax
f010124a:	e8 ed fd ff ff       	call   f010103c <page_decref>
	tlb_invalidate(pgdir, va);
f010124f:	83 c4 08             	add    $0x8,%esp
f0101252:	56                   	push   %esi
f0101253:	53                   	push   %ebx
f0101254:	e8 8a ff ff ff       	call   f01011e3 <tlb_invalidate>
	*va_table_entry = 0;
f0101259:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010125c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0101262:	83 c4 10             	add    $0x10,%esp
f0101265:	eb d8                	jmp    f010123f <page_remove+0x27>

f0101267 <page_insert>:
{
f0101267:	55                   	push   %ebp
f0101268:	89 e5                	mov    %esp,%ebp
f010126a:	57                   	push   %edi
f010126b:	56                   	push   %esi
f010126c:	53                   	push   %ebx
f010126d:	83 ec 10             	sub    $0x10,%esp
f0101270:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101273:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *va_table_entry = pgdir_walk(pgdir, va, 1);
f0101276:	6a 01                	push   $0x1
f0101278:	ff 75 10             	pushl  0x10(%ebp)
f010127b:	57                   	push   %edi
f010127c:	e8 e4 fd ff ff       	call   f0101065 <pgdir_walk>
	if (va_table_entry == NULL)
f0101281:	83 c4 10             	add    $0x10,%esp
f0101284:	85 c0                	test   %eax,%eax
f0101286:	74 73                	je     f01012fb <page_insert+0x94>
f0101288:	89 c6                	mov    %eax,%esi
	if (*va_table_entry & PTE_P)
f010128a:	8b 00                	mov    (%eax),%eax
f010128c:	a8 01                	test   $0x1,%al
f010128e:	74 26                	je     f01012b6 <page_insert+0x4f>
		if (PTE_ADDR(*va_table_entry) == page2pa(pp))
f0101290:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	return (pp - pages) << PGSHIFT;
f0101295:	89 da                	mov    %ebx,%edx
f0101297:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f010129d:	c1 fa 03             	sar    $0x3,%edx
f01012a0:	c1 e2 0c             	shl    $0xc,%edx
f01012a3:	39 d0                	cmp    %edx,%eax
f01012a5:	74 43                	je     f01012ea <page_insert+0x83>
		page_remove(pgdir, va);
f01012a7:	83 ec 08             	sub    $0x8,%esp
f01012aa:	ff 75 10             	pushl  0x10(%ebp)
f01012ad:	57                   	push   %edi
f01012ae:	e8 65 ff ff ff       	call   f0101218 <page_remove>
f01012b3:	83 c4 10             	add    $0x10,%esp
	pp->pp_ref++;
f01012b6:	66 83 43 04 01       	addw   $0x1,0x4(%ebx)
f01012bb:	2b 1d a8 ee 2a f0    	sub    0xf02aeea8,%ebx
f01012c1:	c1 fb 03             	sar    $0x3,%ebx
f01012c4:	c1 e3 0c             	shl    $0xc,%ebx
	*va_table_entry = page2pa(pp) | PTE_P | perm;
f01012c7:	8b 45 14             	mov    0x14(%ebp),%eax
f01012ca:	83 c8 01             	or     $0x1,%eax
f01012cd:	09 c3                	or     %eax,%ebx
f01012cf:	89 1e                	mov    %ebx,(%esi)
	pgdir[PDX(va)] |= perm;
f01012d1:	8b 45 10             	mov    0x10(%ebp),%eax
f01012d4:	c1 e8 16             	shr    $0x16,%eax
f01012d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01012da:	09 0c 87             	or     %ecx,(%edi,%eax,4)
	return 0;
f01012dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01012e5:	5b                   	pop    %ebx
f01012e6:	5e                   	pop    %esi
f01012e7:	5f                   	pop    %edi
f01012e8:	5d                   	pop    %ebp
f01012e9:	c3                   	ret    
			*va_table_entry = page2pa(pp) | perm | PTE_P;
f01012ea:	8b 55 14             	mov    0x14(%ebp),%edx
f01012ed:	83 ca 01             	or     $0x1,%edx
f01012f0:	09 d0                	or     %edx,%eax
f01012f2:	89 06                	mov    %eax,(%esi)
			return 0;
f01012f4:	b8 00 00 00 00       	mov    $0x0,%eax
f01012f9:	eb e7                	jmp    f01012e2 <page_insert+0x7b>
		return -E_NO_MEM;
f01012fb:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101300:	eb e0                	jmp    f01012e2 <page_insert+0x7b>

f0101302 <mmio_map_region>:
{
f0101302:	55                   	push   %ebp
f0101303:	89 e5                	mov    %esp,%ebp
f0101305:	56                   	push   %esi
f0101306:	53                   	push   %ebx
	void *start = (void *)base;
f0101307:	8b 35 00 43 12 f0    	mov    0xf0124300,%esi
	size = ROUNDUP(size, PGSIZE);
f010130d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101310:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f0101316:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (base + size >= MMIOLIM || base + size < base)
f010131c:	89 f0                	mov    %esi,%eax
f010131e:	01 d8                	add    %ebx,%eax
f0101320:	72 2c                	jb     f010134e <mmio_map_region+0x4c>
f0101322:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101327:	77 25                	ja     f010134e <mmio_map_region+0x4c>
	boot_map_region(kern_pgdir, base, size, pa, PTE_W | PTE_PCD | PTE_PWT);
f0101329:	83 ec 08             	sub    $0x8,%esp
f010132c:	6a 1a                	push   $0x1a
f010132e:	ff 75 08             	pushl  0x8(%ebp)
f0101331:	89 d9                	mov    %ebx,%ecx
f0101333:	89 f2                	mov    %esi,%edx
f0101335:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f010133a:	e8 b9 fd ff ff       	call   f01010f8 <boot_map_region>
	base += size;
f010133f:	01 1d 00 43 12 f0    	add    %ebx,0xf0124300
}
f0101345:	89 f0                	mov    %esi,%eax
f0101347:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010134a:	5b                   	pop    %ebx
f010134b:	5e                   	pop    %esi
f010134c:	5d                   	pop    %ebp
f010134d:	c3                   	ret    
		panic("mmio_map_region failed: size is too big!\n");
f010134e:	83 ec 04             	sub    $0x4,%esp
f0101351:	68 ac 76 10 f0       	push   $0xf01076ac
f0101356:	68 6d 02 00 00       	push   $0x26d
f010135b:	68 94 72 10 f0       	push   $0xf0107294
f0101360:	e8 db ec ff ff       	call   f0100040 <_panic>

f0101365 <mem_init>:
{
f0101365:	55                   	push   %ebp
f0101366:	89 e5                	mov    %esp,%ebp
f0101368:	57                   	push   %edi
f0101369:	56                   	push   %esi
f010136a:	53                   	push   %ebx
f010136b:	83 ec 3c             	sub    $0x3c,%esp
	basemem = nvram_read(NVRAM_BASELO);
f010136e:	b8 15 00 00 00       	mov    $0x15,%eax
f0101373:	e8 47 f7 ff ff       	call   f0100abf <nvram_read>
f0101378:	89 c3                	mov    %eax,%ebx
	extmem = nvram_read(NVRAM_EXTLO);
f010137a:	b8 17 00 00 00       	mov    $0x17,%eax
f010137f:	e8 3b f7 ff ff       	call   f0100abf <nvram_read>
f0101384:	89 c6                	mov    %eax,%esi
	ext16mem = nvram_read(NVRAM_EXT16LO) * 64;
f0101386:	b8 34 00 00 00       	mov    $0x34,%eax
f010138b:	e8 2f f7 ff ff       	call   f0100abf <nvram_read>
f0101390:	c1 e0 06             	shl    $0x6,%eax
	if (ext16mem)
f0101393:	85 c0                	test   %eax,%eax
f0101395:	0f 85 e4 00 00 00    	jne    f010147f <mem_init+0x11a>
		totalmem = 1 * 1024 + extmem;
f010139b:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
f01013a1:	85 f6                	test   %esi,%esi
f01013a3:	0f 44 c3             	cmove  %ebx,%eax
	npages = totalmem / (PGSIZE / 1024);
f01013a6:	89 c2                	mov    %eax,%edx
f01013a8:	c1 ea 02             	shr    $0x2,%edx
f01013ab:	89 15 a0 ee 2a f0    	mov    %edx,0xf02aeea0
	npages_basemem = basemem / (PGSIZE / 1024);
f01013b1:	89 da                	mov    %ebx,%edx
f01013b3:	c1 ea 02             	shr    $0x2,%edx
f01013b6:	89 15 44 e2 2a f0    	mov    %edx,0xf02ae244
	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f01013bc:	89 c2                	mov    %eax,%edx
f01013be:	29 da                	sub    %ebx,%edx
f01013c0:	52                   	push   %edx
f01013c1:	53                   	push   %ebx
f01013c2:	50                   	push   %eax
f01013c3:	68 d8 76 10 f0       	push   $0xf01076d8
f01013c8:	e8 63 25 00 00       	call   f0103930 <cprintf>
	kern_pgdir = (pde_t *)boot_alloc(PGSIZE);
f01013cd:	b8 00 10 00 00       	mov    $0x1000,%eax
f01013d2:	e8 11 f7 ff ff       	call   f0100ae8 <boot_alloc>
f01013d7:	a3 a4 ee 2a f0       	mov    %eax,0xf02aeea4
	memset(kern_pgdir, 0, PGSIZE);
f01013dc:	83 c4 0c             	add    $0xc,%esp
f01013df:	68 00 10 00 00       	push   $0x1000
f01013e4:	6a 00                	push   $0x0
f01013e6:	50                   	push   %eax
f01013e7:	e8 c3 46 00 00       	call   f0105aaf <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01013ec:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
	if ((uint32_t)kva < KERNBASE)
f01013f1:	83 c4 10             	add    $0x10,%esp
f01013f4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01013f9:	0f 86 8a 00 00 00    	jbe    f0101489 <mem_init+0x124>
	return (physaddr_t)kva - KERNBASE;
f01013ff:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101405:	83 ca 05             	or     $0x5,%edx
f0101408:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo *)boot_alloc(sizeof(struct PageInfo) * npages);
f010140e:	a1 a0 ee 2a f0       	mov    0xf02aeea0,%eax
f0101413:	c1 e0 03             	shl    $0x3,%eax
f0101416:	e8 cd f6 ff ff       	call   f0100ae8 <boot_alloc>
f010141b:	a3 a8 ee 2a f0       	mov    %eax,0xf02aeea8
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f0101420:	83 ec 04             	sub    $0x4,%esp
f0101423:	8b 0d a0 ee 2a f0    	mov    0xf02aeea0,%ecx
f0101429:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f0101430:	52                   	push   %edx
f0101431:	6a 00                	push   $0x0
f0101433:	50                   	push   %eax
f0101434:	e8 76 46 00 00       	call   f0105aaf <memset>
	envs = (struct Env *)boot_alloc(sizeof(struct Env) * NENV);
f0101439:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f010143e:	e8 a5 f6 ff ff       	call   f0100ae8 <boot_alloc>
f0101443:	a3 48 e2 2a f0       	mov    %eax,0xf02ae248
	memset(envs, 0, sizeof(struct Env) * NENV);
f0101448:	83 c4 0c             	add    $0xc,%esp
f010144b:	68 00 f0 01 00       	push   $0x1f000
f0101450:	6a 00                	push   $0x0
f0101452:	50                   	push   %eax
f0101453:	e8 57 46 00 00       	call   f0105aaf <memset>
	page_init();
f0101458:	e8 56 fa ff ff       	call   f0100eb3 <page_init>
	check_page_free_list(1);
f010145d:	b8 01 00 00 00       	mov    $0x1,%eax
f0101462:	e8 4f f7 ff ff       	call   f0100bb6 <check_page_free_list>
	if (!pages)
f0101467:	83 c4 10             	add    $0x10,%esp
f010146a:	83 3d a8 ee 2a f0 00 	cmpl   $0x0,0xf02aeea8
f0101471:	74 2b                	je     f010149e <mem_init+0x139>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101473:	a1 40 e2 2a f0       	mov    0xf02ae240,%eax
f0101478:	bb 00 00 00 00       	mov    $0x0,%ebx
f010147d:	eb 3b                	jmp    f01014ba <mem_init+0x155>
		totalmem = 16 * 1024 + ext16mem;
f010147f:	05 00 40 00 00       	add    $0x4000,%eax
f0101484:	e9 1d ff ff ff       	jmp    f01013a6 <mem_init+0x41>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101489:	50                   	push   %eax
f010148a:	68 e8 6c 10 f0       	push   $0xf0106ce8
f010148f:	68 96 00 00 00       	push   $0x96
f0101494:	68 94 72 10 f0       	push   $0xf0107294
f0101499:	e8 a2 eb ff ff       	call   f0100040 <_panic>
		panic("'pages' is a null pointer!");
f010149e:	83 ec 04             	sub    $0x4,%esp
f01014a1:	68 67 73 10 f0       	push   $0xf0107367
f01014a6:	68 05 03 00 00       	push   $0x305
f01014ab:	68 94 72 10 f0       	push   $0xf0107294
f01014b0:	e8 8b eb ff ff       	call   f0100040 <_panic>
		++nfree;
f01014b5:	83 c3 01             	add    $0x1,%ebx
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01014b8:	8b 00                	mov    (%eax),%eax
f01014ba:	85 c0                	test   %eax,%eax
f01014bc:	75 f7                	jne    f01014b5 <mem_init+0x150>
	assert((pp0 = page_alloc(0)));
f01014be:	83 ec 0c             	sub    $0xc,%esp
f01014c1:	6a 00                	push   $0x0
f01014c3:	e8 c7 fa ff ff       	call   f0100f8f <page_alloc>
f01014c8:	89 c7                	mov    %eax,%edi
f01014ca:	83 c4 10             	add    $0x10,%esp
f01014cd:	85 c0                	test   %eax,%eax
f01014cf:	0f 84 12 02 00 00    	je     f01016e7 <mem_init+0x382>
	assert((pp1 = page_alloc(0)));
f01014d5:	83 ec 0c             	sub    $0xc,%esp
f01014d8:	6a 00                	push   $0x0
f01014da:	e8 b0 fa ff ff       	call   f0100f8f <page_alloc>
f01014df:	89 c6                	mov    %eax,%esi
f01014e1:	83 c4 10             	add    $0x10,%esp
f01014e4:	85 c0                	test   %eax,%eax
f01014e6:	0f 84 14 02 00 00    	je     f0101700 <mem_init+0x39b>
	assert((pp2 = page_alloc(0)));
f01014ec:	83 ec 0c             	sub    $0xc,%esp
f01014ef:	6a 00                	push   $0x0
f01014f1:	e8 99 fa ff ff       	call   f0100f8f <page_alloc>
f01014f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01014f9:	83 c4 10             	add    $0x10,%esp
f01014fc:	85 c0                	test   %eax,%eax
f01014fe:	0f 84 15 02 00 00    	je     f0101719 <mem_init+0x3b4>
	assert(pp1 && pp1 != pp0);
f0101504:	39 f7                	cmp    %esi,%edi
f0101506:	0f 84 26 02 00 00    	je     f0101732 <mem_init+0x3cd>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010150c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010150f:	39 c6                	cmp    %eax,%esi
f0101511:	0f 84 34 02 00 00    	je     f010174b <mem_init+0x3e6>
f0101517:	39 c7                	cmp    %eax,%edi
f0101519:	0f 84 2c 02 00 00    	je     f010174b <mem_init+0x3e6>
	return (pp - pages) << PGSHIFT;
f010151f:	8b 0d a8 ee 2a f0    	mov    0xf02aeea8,%ecx
	assert(page2pa(pp0) < npages * PGSIZE);
f0101525:	8b 15 a0 ee 2a f0    	mov    0xf02aeea0,%edx
f010152b:	c1 e2 0c             	shl    $0xc,%edx
f010152e:	89 f8                	mov    %edi,%eax
f0101530:	29 c8                	sub    %ecx,%eax
f0101532:	c1 f8 03             	sar    $0x3,%eax
f0101535:	c1 e0 0c             	shl    $0xc,%eax
f0101538:	39 d0                	cmp    %edx,%eax
f010153a:	0f 83 24 02 00 00    	jae    f0101764 <mem_init+0x3ff>
f0101540:	89 f0                	mov    %esi,%eax
f0101542:	29 c8                	sub    %ecx,%eax
f0101544:	c1 f8 03             	sar    $0x3,%eax
f0101547:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages * PGSIZE);
f010154a:	39 c2                	cmp    %eax,%edx
f010154c:	0f 86 2b 02 00 00    	jbe    f010177d <mem_init+0x418>
f0101552:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101555:	29 c8                	sub    %ecx,%eax
f0101557:	c1 f8 03             	sar    $0x3,%eax
f010155a:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages * PGSIZE);
f010155d:	39 c2                	cmp    %eax,%edx
f010155f:	0f 86 31 02 00 00    	jbe    f0101796 <mem_init+0x431>
	fl = page_free_list;
f0101565:	a1 40 e2 2a f0       	mov    0xf02ae240,%eax
f010156a:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f010156d:	c7 05 40 e2 2a f0 00 	movl   $0x0,0xf02ae240
f0101574:	00 00 00 
	assert(!page_alloc(0));
f0101577:	83 ec 0c             	sub    $0xc,%esp
f010157a:	6a 00                	push   $0x0
f010157c:	e8 0e fa ff ff       	call   f0100f8f <page_alloc>
f0101581:	83 c4 10             	add    $0x10,%esp
f0101584:	85 c0                	test   %eax,%eax
f0101586:	0f 85 23 02 00 00    	jne    f01017af <mem_init+0x44a>
	page_free(pp0);
f010158c:	83 ec 0c             	sub    $0xc,%esp
f010158f:	57                   	push   %edi
f0101590:	e8 6c fa ff ff       	call   f0101001 <page_free>
	page_free(pp1);
f0101595:	89 34 24             	mov    %esi,(%esp)
f0101598:	e8 64 fa ff ff       	call   f0101001 <page_free>
	page_free(pp2);
f010159d:	83 c4 04             	add    $0x4,%esp
f01015a0:	ff 75 d4             	pushl  -0x2c(%ebp)
f01015a3:	e8 59 fa ff ff       	call   f0101001 <page_free>
	assert((pp0 = page_alloc(0)));
f01015a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01015af:	e8 db f9 ff ff       	call   f0100f8f <page_alloc>
f01015b4:	89 c6                	mov    %eax,%esi
f01015b6:	83 c4 10             	add    $0x10,%esp
f01015b9:	85 c0                	test   %eax,%eax
f01015bb:	0f 84 07 02 00 00    	je     f01017c8 <mem_init+0x463>
	assert((pp1 = page_alloc(0)));
f01015c1:	83 ec 0c             	sub    $0xc,%esp
f01015c4:	6a 00                	push   $0x0
f01015c6:	e8 c4 f9 ff ff       	call   f0100f8f <page_alloc>
f01015cb:	89 c7                	mov    %eax,%edi
f01015cd:	83 c4 10             	add    $0x10,%esp
f01015d0:	85 c0                	test   %eax,%eax
f01015d2:	0f 84 09 02 00 00    	je     f01017e1 <mem_init+0x47c>
	assert((pp2 = page_alloc(0)));
f01015d8:	83 ec 0c             	sub    $0xc,%esp
f01015db:	6a 00                	push   $0x0
f01015dd:	e8 ad f9 ff ff       	call   f0100f8f <page_alloc>
f01015e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01015e5:	83 c4 10             	add    $0x10,%esp
f01015e8:	85 c0                	test   %eax,%eax
f01015ea:	0f 84 0a 02 00 00    	je     f01017fa <mem_init+0x495>
	assert(pp1 && pp1 != pp0);
f01015f0:	39 fe                	cmp    %edi,%esi
f01015f2:	0f 84 1b 02 00 00    	je     f0101813 <mem_init+0x4ae>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01015f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01015fb:	39 c6                	cmp    %eax,%esi
f01015fd:	0f 84 29 02 00 00    	je     f010182c <mem_init+0x4c7>
f0101603:	39 c7                	cmp    %eax,%edi
f0101605:	0f 84 21 02 00 00    	je     f010182c <mem_init+0x4c7>
	assert(!page_alloc(0));
f010160b:	83 ec 0c             	sub    $0xc,%esp
f010160e:	6a 00                	push   $0x0
f0101610:	e8 7a f9 ff ff       	call   f0100f8f <page_alloc>
f0101615:	83 c4 10             	add    $0x10,%esp
f0101618:	85 c0                	test   %eax,%eax
f010161a:	0f 85 25 02 00 00    	jne    f0101845 <mem_init+0x4e0>
f0101620:	89 f0                	mov    %esi,%eax
f0101622:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0101628:	c1 f8 03             	sar    $0x3,%eax
f010162b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010162e:	89 c2                	mov    %eax,%edx
f0101630:	c1 ea 0c             	shr    $0xc,%edx
f0101633:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f0101639:	0f 83 1f 02 00 00    	jae    f010185e <mem_init+0x4f9>
	memset(page2kva(pp0), 1, PGSIZE);
f010163f:	83 ec 04             	sub    $0x4,%esp
f0101642:	68 00 10 00 00       	push   $0x1000
f0101647:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101649:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010164e:	50                   	push   %eax
f010164f:	e8 5b 44 00 00       	call   f0105aaf <memset>
	page_free(pp0);
f0101654:	89 34 24             	mov    %esi,(%esp)
f0101657:	e8 a5 f9 ff ff       	call   f0101001 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f010165c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101663:	e8 27 f9 ff ff       	call   f0100f8f <page_alloc>
f0101668:	83 c4 10             	add    $0x10,%esp
f010166b:	85 c0                	test   %eax,%eax
f010166d:	0f 84 fd 01 00 00    	je     f0101870 <mem_init+0x50b>
	assert(pp && pp0 == pp);
f0101673:	39 c6                	cmp    %eax,%esi
f0101675:	0f 85 0e 02 00 00    	jne    f0101889 <mem_init+0x524>
	return (pp - pages) << PGSHIFT;
f010167b:	89 f2                	mov    %esi,%edx
f010167d:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f0101683:	c1 fa 03             	sar    $0x3,%edx
f0101686:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101689:	89 d0                	mov    %edx,%eax
f010168b:	c1 e8 0c             	shr    $0xc,%eax
f010168e:	3b 05 a0 ee 2a f0    	cmp    0xf02aeea0,%eax
f0101694:	0f 83 08 02 00 00    	jae    f01018a2 <mem_init+0x53d>
	return (void *)(pa + KERNBASE);
f010169a:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f01016a0:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
		assert(c[i] == 0);
f01016a6:	80 38 00             	cmpb   $0x0,(%eax)
f01016a9:	0f 85 05 02 00 00    	jne    f01018b4 <mem_init+0x54f>
f01016af:	83 c0 01             	add    $0x1,%eax
	for (i = 0; i < PGSIZE; i++)
f01016b2:	39 d0                	cmp    %edx,%eax
f01016b4:	75 f0                	jne    f01016a6 <mem_init+0x341>
	page_free_list = fl;
f01016b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01016b9:	a3 40 e2 2a f0       	mov    %eax,0xf02ae240
	page_free(pp0);
f01016be:	83 ec 0c             	sub    $0xc,%esp
f01016c1:	56                   	push   %esi
f01016c2:	e8 3a f9 ff ff       	call   f0101001 <page_free>
	page_free(pp1);
f01016c7:	89 3c 24             	mov    %edi,(%esp)
f01016ca:	e8 32 f9 ff ff       	call   f0101001 <page_free>
	page_free(pp2);
f01016cf:	83 c4 04             	add    $0x4,%esp
f01016d2:	ff 75 d4             	pushl  -0x2c(%ebp)
f01016d5:	e8 27 f9 ff ff       	call   f0101001 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01016da:	a1 40 e2 2a f0       	mov    0xf02ae240,%eax
f01016df:	83 c4 10             	add    $0x10,%esp
f01016e2:	e9 eb 01 00 00       	jmp    f01018d2 <mem_init+0x56d>
	assert((pp0 = page_alloc(0)));
f01016e7:	68 82 73 10 f0       	push   $0xf0107382
f01016ec:	68 ba 72 10 f0       	push   $0xf01072ba
f01016f1:	68 0d 03 00 00       	push   $0x30d
f01016f6:	68 94 72 10 f0       	push   $0xf0107294
f01016fb:	e8 40 e9 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101700:	68 98 73 10 f0       	push   $0xf0107398
f0101705:	68 ba 72 10 f0       	push   $0xf01072ba
f010170a:	68 0e 03 00 00       	push   $0x30e
f010170f:	68 94 72 10 f0       	push   $0xf0107294
f0101714:	e8 27 e9 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101719:	68 ae 73 10 f0       	push   $0xf01073ae
f010171e:	68 ba 72 10 f0       	push   $0xf01072ba
f0101723:	68 0f 03 00 00       	push   $0x30f
f0101728:	68 94 72 10 f0       	push   $0xf0107294
f010172d:	e8 0e e9 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101732:	68 c4 73 10 f0       	push   $0xf01073c4
f0101737:	68 ba 72 10 f0       	push   $0xf01072ba
f010173c:	68 12 03 00 00       	push   $0x312
f0101741:	68 94 72 10 f0       	push   $0xf0107294
f0101746:	e8 f5 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010174b:	68 14 77 10 f0       	push   $0xf0107714
f0101750:	68 ba 72 10 f0       	push   $0xf01072ba
f0101755:	68 13 03 00 00       	push   $0x313
f010175a:	68 94 72 10 f0       	push   $0xf0107294
f010175f:	e8 dc e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp0) < npages * PGSIZE);
f0101764:	68 34 77 10 f0       	push   $0xf0107734
f0101769:	68 ba 72 10 f0       	push   $0xf01072ba
f010176e:	68 14 03 00 00       	push   $0x314
f0101773:	68 94 72 10 f0       	push   $0xf0107294
f0101778:	e8 c3 e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp1) < npages * PGSIZE);
f010177d:	68 54 77 10 f0       	push   $0xf0107754
f0101782:	68 ba 72 10 f0       	push   $0xf01072ba
f0101787:	68 15 03 00 00       	push   $0x315
f010178c:	68 94 72 10 f0       	push   $0xf0107294
f0101791:	e8 aa e8 ff ff       	call   f0100040 <_panic>
	assert(page2pa(pp2) < npages * PGSIZE);
f0101796:	68 74 77 10 f0       	push   $0xf0107774
f010179b:	68 ba 72 10 f0       	push   $0xf01072ba
f01017a0:	68 16 03 00 00       	push   $0x316
f01017a5:	68 94 72 10 f0       	push   $0xf0107294
f01017aa:	e8 91 e8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01017af:	68 d6 73 10 f0       	push   $0xf01073d6
f01017b4:	68 ba 72 10 f0       	push   $0xf01072ba
f01017b9:	68 1d 03 00 00       	push   $0x31d
f01017be:	68 94 72 10 f0       	push   $0xf0107294
f01017c3:	e8 78 e8 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f01017c8:	68 82 73 10 f0       	push   $0xf0107382
f01017cd:	68 ba 72 10 f0       	push   $0xf01072ba
f01017d2:	68 24 03 00 00       	push   $0x324
f01017d7:	68 94 72 10 f0       	push   $0xf0107294
f01017dc:	e8 5f e8 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f01017e1:	68 98 73 10 f0       	push   $0xf0107398
f01017e6:	68 ba 72 10 f0       	push   $0xf01072ba
f01017eb:	68 25 03 00 00       	push   $0x325
f01017f0:	68 94 72 10 f0       	push   $0xf0107294
f01017f5:	e8 46 e8 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f01017fa:	68 ae 73 10 f0       	push   $0xf01073ae
f01017ff:	68 ba 72 10 f0       	push   $0xf01072ba
f0101804:	68 26 03 00 00       	push   $0x326
f0101809:	68 94 72 10 f0       	push   $0xf0107294
f010180e:	e8 2d e8 ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f0101813:	68 c4 73 10 f0       	push   $0xf01073c4
f0101818:	68 ba 72 10 f0       	push   $0xf01072ba
f010181d:	68 28 03 00 00       	push   $0x328
f0101822:	68 94 72 10 f0       	push   $0xf0107294
f0101827:	e8 14 e8 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010182c:	68 14 77 10 f0       	push   $0xf0107714
f0101831:	68 ba 72 10 f0       	push   $0xf01072ba
f0101836:	68 29 03 00 00       	push   $0x329
f010183b:	68 94 72 10 f0       	push   $0xf0107294
f0101840:	e8 fb e7 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101845:	68 d6 73 10 f0       	push   $0xf01073d6
f010184a:	68 ba 72 10 f0       	push   $0xf01072ba
f010184f:	68 2a 03 00 00       	push   $0x32a
f0101854:	68 94 72 10 f0       	push   $0xf0107294
f0101859:	e8 e2 e7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010185e:	50                   	push   %eax
f010185f:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0101864:	6a 58                	push   $0x58
f0101866:	68 a0 72 10 f0       	push   $0xf01072a0
f010186b:	e8 d0 e7 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101870:	68 e5 73 10 f0       	push   $0xf01073e5
f0101875:	68 ba 72 10 f0       	push   $0xf01072ba
f010187a:	68 2f 03 00 00       	push   $0x32f
f010187f:	68 94 72 10 f0       	push   $0xf0107294
f0101884:	e8 b7 e7 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101889:	68 03 74 10 f0       	push   $0xf0107403
f010188e:	68 ba 72 10 f0       	push   $0xf01072ba
f0101893:	68 30 03 00 00       	push   $0x330
f0101898:	68 94 72 10 f0       	push   $0xf0107294
f010189d:	e8 9e e7 ff ff       	call   f0100040 <_panic>
f01018a2:	52                   	push   %edx
f01018a3:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01018a8:	6a 58                	push   $0x58
f01018aa:	68 a0 72 10 f0       	push   $0xf01072a0
f01018af:	e8 8c e7 ff ff       	call   f0100040 <_panic>
		assert(c[i] == 0);
f01018b4:	68 13 74 10 f0       	push   $0xf0107413
f01018b9:	68 ba 72 10 f0       	push   $0xf01072ba
f01018be:	68 33 03 00 00       	push   $0x333
f01018c3:	68 94 72 10 f0       	push   $0xf0107294
f01018c8:	e8 73 e7 ff ff       	call   f0100040 <_panic>
		--nfree;
f01018cd:	83 eb 01             	sub    $0x1,%ebx
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01018d0:	8b 00                	mov    (%eax),%eax
f01018d2:	85 c0                	test   %eax,%eax
f01018d4:	75 f7                	jne    f01018cd <mem_init+0x568>
	assert(nfree == 0);
f01018d6:	85 db                	test   %ebx,%ebx
f01018d8:	0f 85 64 09 00 00    	jne    f0102242 <mem_init+0xedd>
	cprintf("check_page_alloc() succeeded!\n");
f01018de:	83 ec 0c             	sub    $0xc,%esp
f01018e1:	68 94 77 10 f0       	push   $0xf0107794
f01018e6:	e8 45 20 00 00       	call   f0103930 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f01018eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018f2:	e8 98 f6 ff ff       	call   f0100f8f <page_alloc>
f01018f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018fa:	83 c4 10             	add    $0x10,%esp
f01018fd:	85 c0                	test   %eax,%eax
f01018ff:	0f 84 56 09 00 00    	je     f010225b <mem_init+0xef6>
	assert((pp1 = page_alloc(0)));
f0101905:	83 ec 0c             	sub    $0xc,%esp
f0101908:	6a 00                	push   $0x0
f010190a:	e8 80 f6 ff ff       	call   f0100f8f <page_alloc>
f010190f:	89 c3                	mov    %eax,%ebx
f0101911:	83 c4 10             	add    $0x10,%esp
f0101914:	85 c0                	test   %eax,%eax
f0101916:	0f 84 58 09 00 00    	je     f0102274 <mem_init+0xf0f>
	assert((pp2 = page_alloc(0)));
f010191c:	83 ec 0c             	sub    $0xc,%esp
f010191f:	6a 00                	push   $0x0
f0101921:	e8 69 f6 ff ff       	call   f0100f8f <page_alloc>
f0101926:	89 c6                	mov    %eax,%esi
f0101928:	83 c4 10             	add    $0x10,%esp
f010192b:	85 c0                	test   %eax,%eax
f010192d:	0f 84 5a 09 00 00    	je     f010228d <mem_init+0xf28>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101933:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101936:	0f 84 6a 09 00 00    	je     f01022a6 <mem_init+0xf41>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010193c:	39 c3                	cmp    %eax,%ebx
f010193e:	0f 84 7b 09 00 00    	je     f01022bf <mem_init+0xf5a>
f0101944:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101947:	0f 84 72 09 00 00    	je     f01022bf <mem_init+0xf5a>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f010194d:	a1 40 e2 2a f0       	mov    0xf02ae240,%eax
f0101952:	89 45 cc             	mov    %eax,-0x34(%ebp)
	page_free_list = 0;
f0101955:	c7 05 40 e2 2a f0 00 	movl   $0x0,0xf02ae240
f010195c:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010195f:	83 ec 0c             	sub    $0xc,%esp
f0101962:	6a 00                	push   $0x0
f0101964:	e8 26 f6 ff ff       	call   f0100f8f <page_alloc>
f0101969:	83 c4 10             	add    $0x10,%esp
f010196c:	85 c0                	test   %eax,%eax
f010196e:	0f 85 64 09 00 00    	jne    f01022d8 <mem_init+0xf73>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *)0x0, &ptep) == NULL);
f0101974:	83 ec 04             	sub    $0x4,%esp
f0101977:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010197a:	50                   	push   %eax
f010197b:	6a 00                	push   $0x0
f010197d:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101983:	e8 f5 f7 ff ff       	call   f010117d <page_lookup>
f0101988:	83 c4 10             	add    $0x10,%esp
f010198b:	85 c0                	test   %eax,%eax
f010198d:	0f 85 5e 09 00 00    	jne    f01022f1 <mem_init+0xf8c>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101993:	6a 02                	push   $0x2
f0101995:	6a 00                	push   $0x0
f0101997:	53                   	push   %ebx
f0101998:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f010199e:	e8 c4 f8 ff ff       	call   f0101267 <page_insert>
f01019a3:	83 c4 10             	add    $0x10,%esp
f01019a6:	85 c0                	test   %eax,%eax
f01019a8:	0f 89 5c 09 00 00    	jns    f010230a <mem_init+0xfa5>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01019ae:	83 ec 0c             	sub    $0xc,%esp
f01019b1:	ff 75 d4             	pushl  -0x2c(%ebp)
f01019b4:	e8 48 f6 ff ff       	call   f0101001 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01019b9:	6a 02                	push   $0x2
f01019bb:	6a 00                	push   $0x0
f01019bd:	53                   	push   %ebx
f01019be:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f01019c4:	e8 9e f8 ff ff       	call   f0101267 <page_insert>
f01019c9:	83 c4 20             	add    $0x20,%esp
f01019cc:	85 c0                	test   %eax,%eax
f01019ce:	0f 85 4f 09 00 00    	jne    f0102323 <mem_init+0xfbe>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01019d4:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
	return (pp - pages) << PGSHIFT;
f01019da:	8b 0d a8 ee 2a f0    	mov    0xf02aeea8,%ecx
f01019e0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f01019e3:	8b 17                	mov    (%edi),%edx
f01019e5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01019eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01019ee:	29 c8                	sub    %ecx,%eax
f01019f0:	c1 f8 03             	sar    $0x3,%eax
f01019f3:	c1 e0 0c             	shl    $0xc,%eax
f01019f6:	39 c2                	cmp    %eax,%edx
f01019f8:	0f 85 3e 09 00 00    	jne    f010233c <mem_init+0xfd7>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f01019fe:	ba 00 00 00 00       	mov    $0x0,%edx
f0101a03:	89 f8                	mov    %edi,%eax
f0101a05:	e8 48 f1 ff ff       	call   f0100b52 <check_va2pa>
f0101a0a:	89 da                	mov    %ebx,%edx
f0101a0c:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101a0f:	c1 fa 03             	sar    $0x3,%edx
f0101a12:	c1 e2 0c             	shl    $0xc,%edx
f0101a15:	39 d0                	cmp    %edx,%eax
f0101a17:	0f 85 38 09 00 00    	jne    f0102355 <mem_init+0xff0>
	assert(pp1->pp_ref == 1);
f0101a1d:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101a22:	0f 85 46 09 00 00    	jne    f010236e <mem_init+0x1009>
	assert(pp0->pp_ref == 1);
f0101a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101a2b:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101a30:	0f 85 51 09 00 00    	jne    f0102387 <mem_init+0x1022>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0101a36:	6a 02                	push   $0x2
f0101a38:	68 00 10 00 00       	push   $0x1000
f0101a3d:	56                   	push   %esi
f0101a3e:	57                   	push   %edi
f0101a3f:	e8 23 f8 ff ff       	call   f0101267 <page_insert>
f0101a44:	83 c4 10             	add    $0x10,%esp
f0101a47:	85 c0                	test   %eax,%eax
f0101a49:	0f 85 51 09 00 00    	jne    f01023a0 <mem_init+0x103b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101a4f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101a54:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0101a59:	e8 f4 f0 ff ff       	call   f0100b52 <check_va2pa>
f0101a5e:	89 f2                	mov    %esi,%edx
f0101a60:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f0101a66:	c1 fa 03             	sar    $0x3,%edx
f0101a69:	c1 e2 0c             	shl    $0xc,%edx
f0101a6c:	39 d0                	cmp    %edx,%eax
f0101a6e:	0f 85 45 09 00 00    	jne    f01023b9 <mem_init+0x1054>
	assert(pp2->pp_ref == 1);
f0101a74:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101a79:	0f 85 53 09 00 00    	jne    f01023d2 <mem_init+0x106d>

	// should be no free memory
	assert(!page_alloc(0));
f0101a7f:	83 ec 0c             	sub    $0xc,%esp
f0101a82:	6a 00                	push   $0x0
f0101a84:	e8 06 f5 ff ff       	call   f0100f8f <page_alloc>
f0101a89:	83 c4 10             	add    $0x10,%esp
f0101a8c:	85 c0                	test   %eax,%eax
f0101a8e:	0f 85 57 09 00 00    	jne    f01023eb <mem_init+0x1086>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0101a94:	6a 02                	push   $0x2
f0101a96:	68 00 10 00 00       	push   $0x1000
f0101a9b:	56                   	push   %esi
f0101a9c:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101aa2:	e8 c0 f7 ff ff       	call   f0101267 <page_insert>
f0101aa7:	83 c4 10             	add    $0x10,%esp
f0101aaa:	85 c0                	test   %eax,%eax
f0101aac:	0f 85 52 09 00 00    	jne    f0102404 <mem_init+0x109f>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101ab2:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ab7:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0101abc:	e8 91 f0 ff ff       	call   f0100b52 <check_va2pa>
f0101ac1:	89 f2                	mov    %esi,%edx
f0101ac3:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f0101ac9:	c1 fa 03             	sar    $0x3,%edx
f0101acc:	c1 e2 0c             	shl    $0xc,%edx
f0101acf:	39 d0                	cmp    %edx,%eax
f0101ad1:	0f 85 46 09 00 00    	jne    f010241d <mem_init+0x10b8>
	assert(pp2->pp_ref == 1);
f0101ad7:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101adc:	0f 85 54 09 00 00    	jne    f0102436 <mem_init+0x10d1>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101ae2:	83 ec 0c             	sub    $0xc,%esp
f0101ae5:	6a 00                	push   $0x0
f0101ae7:	e8 a3 f4 ff ff       	call   f0100f8f <page_alloc>
f0101aec:	83 c4 10             	add    $0x10,%esp
f0101aef:	85 c0                	test   %eax,%eax
f0101af1:	0f 85 58 09 00 00    	jne    f010244f <mem_init+0x10ea>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *)KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101af7:	8b 15 a4 ee 2a f0    	mov    0xf02aeea4,%edx
f0101afd:	8b 02                	mov    (%edx),%eax
f0101aff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101b04:	89 c1                	mov    %eax,%ecx
f0101b06:	c1 e9 0c             	shr    $0xc,%ecx
f0101b09:	3b 0d a0 ee 2a f0    	cmp    0xf02aeea0,%ecx
f0101b0f:	0f 83 53 09 00 00    	jae    f0102468 <mem_init+0x1103>
	return (void *)(pa + KERNBASE);
f0101b15:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) == ptep + PTX(PGSIZE));
f0101b1d:	83 ec 04             	sub    $0x4,%esp
f0101b20:	6a 00                	push   $0x0
f0101b22:	68 00 10 00 00       	push   $0x1000
f0101b27:	52                   	push   %edx
f0101b28:	e8 38 f5 ff ff       	call   f0101065 <pgdir_walk>
f0101b2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101b30:	8d 51 04             	lea    0x4(%ecx),%edx
f0101b33:	83 c4 10             	add    $0x10,%esp
f0101b36:	39 d0                	cmp    %edx,%eax
f0101b38:	0f 85 3f 09 00 00    	jne    f010247d <mem_init+0x1118>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W | PTE_U) == 0);
f0101b3e:	6a 06                	push   $0x6
f0101b40:	68 00 10 00 00       	push   $0x1000
f0101b45:	56                   	push   %esi
f0101b46:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101b4c:	e8 16 f7 ff ff       	call   f0101267 <page_insert>
f0101b51:	83 c4 10             	add    $0x10,%esp
f0101b54:	85 c0                	test   %eax,%eax
f0101b56:	0f 85 3a 09 00 00    	jne    f0102496 <mem_init+0x1131>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101b5c:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
f0101b62:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101b67:	89 f8                	mov    %edi,%eax
f0101b69:	e8 e4 ef ff ff       	call   f0100b52 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101b6e:	89 f2                	mov    %esi,%edx
f0101b70:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f0101b76:	c1 fa 03             	sar    $0x3,%edx
f0101b79:	c1 e2 0c             	shl    $0xc,%edx
f0101b7c:	39 d0                	cmp    %edx,%eax
f0101b7e:	0f 85 2b 09 00 00    	jne    f01024af <mem_init+0x114a>
	assert(pp2->pp_ref == 1);
f0101b84:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101b89:	0f 85 39 09 00 00    	jne    f01024c8 <mem_init+0x1163>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U);
f0101b8f:	83 ec 04             	sub    $0x4,%esp
f0101b92:	6a 00                	push   $0x0
f0101b94:	68 00 10 00 00       	push   $0x1000
f0101b99:	57                   	push   %edi
f0101b9a:	e8 c6 f4 ff ff       	call   f0101065 <pgdir_walk>
f0101b9f:	83 c4 10             	add    $0x10,%esp
f0101ba2:	f6 00 04             	testb  $0x4,(%eax)
f0101ba5:	0f 84 36 09 00 00    	je     f01024e1 <mem_init+0x117c>
	assert(kern_pgdir[0] & PTE_U);
f0101bab:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0101bb0:	f6 00 04             	testb  $0x4,(%eax)
f0101bb3:	0f 84 41 09 00 00    	je     f01024fa <mem_init+0x1195>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0101bb9:	6a 02                	push   $0x2
f0101bbb:	68 00 10 00 00       	push   $0x1000
f0101bc0:	56                   	push   %esi
f0101bc1:	50                   	push   %eax
f0101bc2:	e8 a0 f6 ff ff       	call   f0101267 <page_insert>
f0101bc7:	83 c4 10             	add    $0x10,%esp
f0101bca:	85 c0                	test   %eax,%eax
f0101bcc:	0f 85 41 09 00 00    	jne    f0102513 <mem_init+0x11ae>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_W);
f0101bd2:	83 ec 04             	sub    $0x4,%esp
f0101bd5:	6a 00                	push   $0x0
f0101bd7:	68 00 10 00 00       	push   $0x1000
f0101bdc:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101be2:	e8 7e f4 ff ff       	call   f0101065 <pgdir_walk>
f0101be7:	83 c4 10             	add    $0x10,%esp
f0101bea:	f6 00 02             	testb  $0x2,(%eax)
f0101bed:	0f 84 39 09 00 00    	je     f010252c <mem_init+0x11c7>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0101bf3:	83 ec 04             	sub    $0x4,%esp
f0101bf6:	6a 00                	push   $0x0
f0101bf8:	68 00 10 00 00       	push   $0x1000
f0101bfd:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101c03:	e8 5d f4 ff ff       	call   f0101065 <pgdir_walk>
f0101c08:	83 c4 10             	add    $0x10,%esp
f0101c0b:	f6 00 04             	testb  $0x4,(%eax)
f0101c0e:	0f 85 31 09 00 00    	jne    f0102545 <mem_init+0x11e0>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void *)PTSIZE, PTE_W) < 0);
f0101c14:	6a 02                	push   $0x2
f0101c16:	68 00 00 40 00       	push   $0x400000
f0101c1b:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101c1e:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101c24:	e8 3e f6 ff ff       	call   f0101267 <page_insert>
f0101c29:	83 c4 10             	add    $0x10,%esp
f0101c2c:	85 c0                	test   %eax,%eax
f0101c2e:	0f 89 2a 09 00 00    	jns    f010255e <mem_init+0x11f9>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, PTE_W) == 0);
f0101c34:	6a 02                	push   $0x2
f0101c36:	68 00 10 00 00       	push   $0x1000
f0101c3b:	53                   	push   %ebx
f0101c3c:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101c42:	e8 20 f6 ff ff       	call   f0101267 <page_insert>
f0101c47:	83 c4 10             	add    $0x10,%esp
f0101c4a:	85 c0                	test   %eax,%eax
f0101c4c:	0f 85 25 09 00 00    	jne    f0102577 <mem_init+0x1212>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0101c52:	83 ec 04             	sub    $0x4,%esp
f0101c55:	6a 00                	push   $0x0
f0101c57:	68 00 10 00 00       	push   $0x1000
f0101c5c:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101c62:	e8 fe f3 ff ff       	call   f0101065 <pgdir_walk>
f0101c67:	83 c4 10             	add    $0x10,%esp
f0101c6a:	f6 00 04             	testb  $0x4,(%eax)
f0101c6d:	0f 85 1d 09 00 00    	jne    f0102590 <mem_init+0x122b>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101c73:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
f0101c79:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c7e:	89 f8                	mov    %edi,%eax
f0101c80:	e8 cd ee ff ff       	call   f0100b52 <check_va2pa>
f0101c85:	89 c1                	mov    %eax,%ecx
f0101c87:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101c8a:	89 d8                	mov    %ebx,%eax
f0101c8c:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0101c92:	c1 f8 03             	sar    $0x3,%eax
f0101c95:	c1 e0 0c             	shl    $0xc,%eax
f0101c98:	39 c1                	cmp    %eax,%ecx
f0101c9a:	0f 85 09 09 00 00    	jne    f01025a9 <mem_init+0x1244>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101ca0:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101ca5:	89 f8                	mov    %edi,%eax
f0101ca7:	e8 a6 ee ff ff       	call   f0100b52 <check_va2pa>
f0101cac:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101caf:	0f 85 0d 09 00 00    	jne    f01025c2 <mem_init+0x125d>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101cb5:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101cba:	0f 85 1b 09 00 00    	jne    f01025db <mem_init+0x1276>
	assert(pp2->pp_ref == 0);
f0101cc0:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101cc5:	0f 85 29 09 00 00    	jne    f01025f4 <mem_init+0x128f>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101ccb:	83 ec 0c             	sub    $0xc,%esp
f0101cce:	6a 00                	push   $0x0
f0101cd0:	e8 ba f2 ff ff       	call   f0100f8f <page_alloc>
f0101cd5:	83 c4 10             	add    $0x10,%esp
f0101cd8:	85 c0                	test   %eax,%eax
f0101cda:	0f 84 2d 09 00 00    	je     f010260d <mem_init+0x12a8>
f0101ce0:	39 c6                	cmp    %eax,%esi
f0101ce2:	0f 85 25 09 00 00    	jne    f010260d <mem_init+0x12a8>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101ce8:	83 ec 08             	sub    $0x8,%esp
f0101ceb:	6a 00                	push   $0x0
f0101ced:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101cf3:	e8 20 f5 ff ff       	call   f0101218 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101cf8:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
f0101cfe:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d03:	89 f8                	mov    %edi,%eax
f0101d05:	e8 48 ee ff ff       	call   f0100b52 <check_va2pa>
f0101d0a:	83 c4 10             	add    $0x10,%esp
f0101d0d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101d10:	0f 85 10 09 00 00    	jne    f0102626 <mem_init+0x12c1>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101d16:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d1b:	89 f8                	mov    %edi,%eax
f0101d1d:	e8 30 ee ff ff       	call   f0100b52 <check_va2pa>
f0101d22:	89 da                	mov    %ebx,%edx
f0101d24:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f0101d2a:	c1 fa 03             	sar    $0x3,%edx
f0101d2d:	c1 e2 0c             	shl    $0xc,%edx
f0101d30:	39 d0                	cmp    %edx,%eax
f0101d32:	0f 85 07 09 00 00    	jne    f010263f <mem_init+0x12da>
	assert(pp1->pp_ref == 1);
f0101d38:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101d3d:	0f 85 15 09 00 00    	jne    f0102658 <mem_init+0x12f3>
	assert(pp2->pp_ref == 0);
f0101d43:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101d48:	0f 85 23 09 00 00    	jne    f0102671 <mem_init+0x130c>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, 0) == 0);
f0101d4e:	6a 00                	push   $0x0
f0101d50:	68 00 10 00 00       	push   $0x1000
f0101d55:	53                   	push   %ebx
f0101d56:	57                   	push   %edi
f0101d57:	e8 0b f5 ff ff       	call   f0101267 <page_insert>
f0101d5c:	83 c4 10             	add    $0x10,%esp
f0101d5f:	85 c0                	test   %eax,%eax
f0101d61:	0f 85 23 09 00 00    	jne    f010268a <mem_init+0x1325>
	assert(pp1->pp_ref);
f0101d67:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101d6c:	0f 84 31 09 00 00    	je     f01026a3 <mem_init+0x133e>
	assert(pp1->pp_link == NULL);
f0101d72:	83 3b 00             	cmpl   $0x0,(%ebx)
f0101d75:	0f 85 41 09 00 00    	jne    f01026bc <mem_init+0x1357>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void *)PGSIZE);
f0101d7b:	83 ec 08             	sub    $0x8,%esp
f0101d7e:	68 00 10 00 00       	push   $0x1000
f0101d83:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101d89:	e8 8a f4 ff ff       	call   f0101218 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0101d8e:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
f0101d94:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d99:	89 f8                	mov    %edi,%eax
f0101d9b:	e8 b2 ed ff ff       	call   f0100b52 <check_va2pa>
f0101da0:	83 c4 10             	add    $0x10,%esp
f0101da3:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101da6:	0f 85 29 09 00 00    	jne    f01026d5 <mem_init+0x1370>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0101dac:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101db1:	89 f8                	mov    %edi,%eax
f0101db3:	e8 9a ed ff ff       	call   f0100b52 <check_va2pa>
f0101db8:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101dbb:	0f 85 2d 09 00 00    	jne    f01026ee <mem_init+0x1389>
	assert(pp1->pp_ref == 0);
f0101dc1:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101dc6:	0f 85 3b 09 00 00    	jne    f0102707 <mem_init+0x13a2>
	assert(pp2->pp_ref == 0);
f0101dcc:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101dd1:	0f 85 49 09 00 00    	jne    f0102720 <mem_init+0x13bb>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0101dd7:	83 ec 0c             	sub    $0xc,%esp
f0101dda:	6a 00                	push   $0x0
f0101ddc:	e8 ae f1 ff ff       	call   f0100f8f <page_alloc>
f0101de1:	83 c4 10             	add    $0x10,%esp
f0101de4:	39 c3                	cmp    %eax,%ebx
f0101de6:	0f 85 4d 09 00 00    	jne    f0102739 <mem_init+0x13d4>
f0101dec:	85 c0                	test   %eax,%eax
f0101dee:	0f 84 45 09 00 00    	je     f0102739 <mem_init+0x13d4>

	// should be no free memory
	assert(!page_alloc(0));
f0101df4:	83 ec 0c             	sub    $0xc,%esp
f0101df7:	6a 00                	push   $0x0
f0101df9:	e8 91 f1 ff ff       	call   f0100f8f <page_alloc>
f0101dfe:	83 c4 10             	add    $0x10,%esp
f0101e01:	85 c0                	test   %eax,%eax
f0101e03:	0f 85 49 09 00 00    	jne    f0102752 <mem_init+0x13ed>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101e09:	8b 0d a4 ee 2a f0    	mov    0xf02aeea4,%ecx
f0101e0f:	8b 11                	mov    (%ecx),%edx
f0101e11:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101e17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e1a:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0101e20:	c1 f8 03             	sar    $0x3,%eax
f0101e23:	c1 e0 0c             	shl    $0xc,%eax
f0101e26:	39 c2                	cmp    %eax,%edx
f0101e28:	0f 85 3d 09 00 00    	jne    f010276b <mem_init+0x1406>
	kern_pgdir[0] = 0;
f0101e2e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0101e34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e37:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101e3c:	0f 85 42 09 00 00    	jne    f0102784 <mem_init+0x141f>
	pp0->pp_ref = 0;
f0101e42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101e45:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0101e4b:	83 ec 0c             	sub    $0xc,%esp
f0101e4e:	50                   	push   %eax
f0101e4f:	e8 ad f1 ff ff       	call   f0101001 <page_free>
	va = (void *)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0101e54:	83 c4 0c             	add    $0xc,%esp
f0101e57:	6a 01                	push   $0x1
f0101e59:	68 00 10 40 00       	push   $0x401000
f0101e5e:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101e64:	e8 fc f1 ff ff       	call   f0101065 <pgdir_walk>
f0101e69:	89 c7                	mov    %eax,%edi
f0101e6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *)KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0101e6e:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0101e73:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101e76:	8b 40 04             	mov    0x4(%eax),%eax
f0101e79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101e7e:	8b 0d a0 ee 2a f0    	mov    0xf02aeea0,%ecx
f0101e84:	89 c2                	mov    %eax,%edx
f0101e86:	c1 ea 0c             	shr    $0xc,%edx
f0101e89:	83 c4 10             	add    $0x10,%esp
f0101e8c:	39 ca                	cmp    %ecx,%edx
f0101e8e:	0f 83 09 09 00 00    	jae    f010279d <mem_init+0x1438>
	assert(ptep == ptep1 + PTX(va));
f0101e94:	2d fc ff ff 0f       	sub    $0xffffffc,%eax
f0101e99:	39 c7                	cmp    %eax,%edi
f0101e9b:	0f 85 11 09 00 00    	jne    f01027b2 <mem_init+0x144d>
	kern_pgdir[PDX(va)] = 0;
f0101ea1:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ea4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f0101eab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101eae:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
	return (pp - pages) << PGSHIFT;
f0101eb4:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0101eba:	c1 f8 03             	sar    $0x3,%eax
f0101ebd:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101ec0:	89 c2                	mov    %eax,%edx
f0101ec2:	c1 ea 0c             	shr    $0xc,%edx
f0101ec5:	39 d1                	cmp    %edx,%ecx
f0101ec7:	0f 86 fe 08 00 00    	jbe    f01027cb <mem_init+0x1466>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0101ecd:	83 ec 04             	sub    $0x4,%esp
f0101ed0:	68 00 10 00 00       	push   $0x1000
f0101ed5:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f0101eda:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101edf:	50                   	push   %eax
f0101ee0:	e8 ca 3b 00 00       	call   f0105aaf <memset>
	page_free(pp0);
f0101ee5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0101ee8:	89 3c 24             	mov    %edi,(%esp)
f0101eeb:	e8 11 f1 ff ff       	call   f0101001 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0101ef0:	83 c4 0c             	add    $0xc,%esp
f0101ef3:	6a 01                	push   $0x1
f0101ef5:	6a 00                	push   $0x0
f0101ef7:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0101efd:	e8 63 f1 ff ff       	call   f0101065 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f0101f02:	89 fa                	mov    %edi,%edx
f0101f04:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f0101f0a:	c1 fa 03             	sar    $0x3,%edx
f0101f0d:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0101f10:	89 d0                	mov    %edx,%eax
f0101f12:	c1 e8 0c             	shr    $0xc,%eax
f0101f15:	83 c4 10             	add    $0x10,%esp
f0101f18:	3b 05 a0 ee 2a f0    	cmp    0xf02aeea0,%eax
f0101f1e:	0f 83 b9 08 00 00    	jae    f01027dd <mem_init+0x1478>
	return (void *)(pa + KERNBASE);
f0101f24:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *)page2kva(pp0);
f0101f2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101f2d:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for (i = 0; i < NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0101f33:	f6 00 01             	testb  $0x1,(%eax)
f0101f36:	0f 85 b3 08 00 00    	jne    f01027ef <mem_init+0x148a>
f0101f3c:	83 c0 04             	add    $0x4,%eax
	for (i = 0; i < NPTENTRIES; i++)
f0101f3f:	39 d0                	cmp    %edx,%eax
f0101f41:	75 f0                	jne    f0101f33 <mem_init+0xbce>
	kern_pgdir[0] = 0;
f0101f43:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0101f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0101f4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101f51:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0101f57:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0101f5a:	89 0d 40 e2 2a f0    	mov    %ecx,0xf02ae240

	// free the pages we took
	page_free(pp0);
f0101f60:	83 ec 0c             	sub    $0xc,%esp
f0101f63:	50                   	push   %eax
f0101f64:	e8 98 f0 ff ff       	call   f0101001 <page_free>
	page_free(pp1);
f0101f69:	89 1c 24             	mov    %ebx,(%esp)
f0101f6c:	e8 90 f0 ff ff       	call   f0101001 <page_free>
	page_free(pp2);
f0101f71:	89 34 24             	mov    %esi,(%esp)
f0101f74:	e8 88 f0 ff ff       	call   f0101001 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t)mmio_map_region(0, 4097);
f0101f79:	83 c4 08             	add    $0x8,%esp
f0101f7c:	68 01 10 00 00       	push   $0x1001
f0101f81:	6a 00                	push   $0x0
f0101f83:	e8 7a f3 ff ff       	call   f0101302 <mmio_map_region>
f0101f88:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t)mmio_map_region(0, 4096);
f0101f8a:	83 c4 08             	add    $0x8,%esp
f0101f8d:	68 00 10 00 00       	push   $0x1000
f0101f92:	6a 00                	push   $0x0
f0101f94:	e8 69 f3 ff ff       	call   f0101302 <mmio_map_region>
f0101f99:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0101f9b:	8d 83 00 20 00 00    	lea    0x2000(%ebx),%eax
f0101fa1:	83 c4 10             	add    $0x10,%esp
f0101fa4:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0101faa:	0f 86 58 08 00 00    	jbe    f0102808 <mem_init+0x14a3>
f0101fb0:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0101fb5:	0f 87 4d 08 00 00    	ja     f0102808 <mem_init+0x14a3>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0101fbb:	8d 96 00 20 00 00    	lea    0x2000(%esi),%edx
f0101fc1:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0101fc7:	0f 87 54 08 00 00    	ja     f0102821 <mem_init+0x14bc>
f0101fcd:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0101fd3:	0f 86 48 08 00 00    	jbe    f0102821 <mem_init+0x14bc>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0101fd9:	89 da                	mov    %ebx,%edx
f0101fdb:	09 f2                	or     %esi,%edx
f0101fdd:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0101fe3:	0f 85 51 08 00 00    	jne    f010283a <mem_init+0x14d5>
	// check that they don't overlap
	assert(mm1 + 8192 <= mm2);
f0101fe9:	39 c6                	cmp    %eax,%esi
f0101feb:	0f 82 62 08 00 00    	jb     f0102853 <mem_init+0x14ee>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0101ff1:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
f0101ff7:	89 da                	mov    %ebx,%edx
f0101ff9:	89 f8                	mov    %edi,%eax
f0101ffb:	e8 52 eb ff ff       	call   f0100b52 <check_va2pa>
f0102000:	85 c0                	test   %eax,%eax
f0102002:	0f 85 64 08 00 00    	jne    f010286c <mem_init+0x1507>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f0102008:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f010200e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102011:	89 c2                	mov    %eax,%edx
f0102013:	89 f8                	mov    %edi,%eax
f0102015:	e8 38 eb ff ff       	call   f0100b52 <check_va2pa>
f010201a:	3d 00 10 00 00       	cmp    $0x1000,%eax
f010201f:	0f 85 60 08 00 00    	jne    f0102885 <mem_init+0x1520>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102025:	89 f2                	mov    %esi,%edx
f0102027:	89 f8                	mov    %edi,%eax
f0102029:	e8 24 eb ff ff       	call   f0100b52 <check_va2pa>
f010202e:	85 c0                	test   %eax,%eax
f0102030:	0f 85 68 08 00 00    	jne    f010289e <mem_init+0x1539>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f0102036:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f010203c:	89 f8                	mov    %edi,%eax
f010203e:	e8 0f eb ff ff       	call   f0100b52 <check_va2pa>
f0102043:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102046:	0f 85 6b 08 00 00    	jne    f01028b7 <mem_init+0x1552>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void *)mm1, 0) & (PTE_W | PTE_PWT | PTE_PCD));
f010204c:	83 ec 04             	sub    $0x4,%esp
f010204f:	6a 00                	push   $0x0
f0102051:	53                   	push   %ebx
f0102052:	57                   	push   %edi
f0102053:	e8 0d f0 ff ff       	call   f0101065 <pgdir_walk>
f0102058:	83 c4 10             	add    $0x10,%esp
f010205b:	f6 00 1a             	testb  $0x1a,(%eax)
f010205e:	0f 84 6c 08 00 00    	je     f01028d0 <mem_init+0x156b>
	assert(!(*pgdir_walk(kern_pgdir, (void *)mm1, 0) & PTE_U));
f0102064:	83 ec 04             	sub    $0x4,%esp
f0102067:	6a 00                	push   $0x0
f0102069:	53                   	push   %ebx
f010206a:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0102070:	e8 f0 ef ff ff       	call   f0101065 <pgdir_walk>
f0102075:	83 c4 10             	add    $0x10,%esp
f0102078:	f6 00 04             	testb  $0x4,(%eax)
f010207b:	0f 85 68 08 00 00    	jne    f01028e9 <mem_init+0x1584>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void *)mm1, 0) = 0;
f0102081:	83 ec 04             	sub    $0x4,%esp
f0102084:	6a 00                	push   $0x0
f0102086:	53                   	push   %ebx
f0102087:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f010208d:	e8 d3 ef ff ff       	call   f0101065 <pgdir_walk>
f0102092:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *)mm1 + PGSIZE, 0) = 0;
f0102098:	83 c4 0c             	add    $0xc,%esp
f010209b:	6a 00                	push   $0x0
f010209d:	ff 75 d4             	pushl  -0x2c(%ebp)
f01020a0:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f01020a6:	e8 ba ef ff ff       	call   f0101065 <pgdir_walk>
f01020ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void *)mm2, 0) = 0;
f01020b1:	83 c4 0c             	add    $0xc,%esp
f01020b4:	6a 00                	push   $0x0
f01020b6:	56                   	push   %esi
f01020b7:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f01020bd:	e8 a3 ef ff ff       	call   f0101065 <pgdir_walk>
f01020c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f01020c8:	c7 04 24 06 75 10 f0 	movl   $0xf0107506,(%esp)
f01020cf:	e8 5c 18 00 00       	call   f0103930 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01020d4:	a1 a8 ee 2a f0       	mov    0xf02aeea8,%eax
	if ((uint32_t)kva < KERNBASE)
f01020d9:	83 c4 10             	add    $0x10,%esp
f01020dc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01020e1:	0f 86 1b 08 00 00    	jbe    f0102902 <mem_init+0x159d>
f01020e7:	83 ec 08             	sub    $0x8,%esp
f01020ea:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01020ec:	05 00 00 00 10       	add    $0x10000000,%eax
f01020f1:	50                   	push   %eax
f01020f2:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01020f7:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01020fc:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0102101:	e8 f2 ef ff ff       	call   f01010f8 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U);
f0102106:	a1 48 e2 2a f0       	mov    0xf02ae248,%eax
	if ((uint32_t)kva < KERNBASE)
f010210b:	83 c4 10             	add    $0x10,%esp
f010210e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102113:	0f 86 fe 07 00 00    	jbe    f0102917 <mem_init+0x15b2>
f0102119:	83 ec 08             	sub    $0x8,%esp
f010211c:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f010211e:	05 00 00 00 10       	add    $0x10000000,%eax
f0102123:	50                   	push   %eax
f0102124:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102129:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f010212e:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0102133:	e8 c0 ef ff ff       	call   f01010f8 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f0102138:	83 c4 10             	add    $0x10,%esp
f010213b:	b8 00 a0 11 f0       	mov    $0xf011a000,%eax
f0102140:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102145:	0f 86 e1 07 00 00    	jbe    f010292c <mem_init+0x15c7>
	boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W);
f010214b:	83 ec 08             	sub    $0x8,%esp
f010214e:	6a 02                	push   $0x2
f0102150:	68 00 a0 11 00       	push   $0x11a000
f0102155:	b9 00 80 00 00       	mov    $0x8000,%ecx
f010215a:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010215f:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f0102164:	e8 8f ef ff ff       	call   f01010f8 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W);
f0102169:	83 c4 08             	add    $0x8,%esp
f010216c:	6a 02                	push   $0x2
f010216e:	6a 00                	push   $0x0
f0102170:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0102175:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010217a:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f010217f:	e8 74 ef ff ff       	call   f01010f8 <boot_map_region>
f0102184:	c7 45 cc 00 00 2b f0 	movl   $0xf02b0000,-0x34(%ebp)
f010218b:	bf 00 00 2f f0       	mov    $0xf02f0000,%edi
f0102190:	83 c4 10             	add    $0x10,%esp
f0102193:	bb 00 00 2b f0       	mov    $0xf02b0000,%ebx
f0102198:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f010219d:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f01021a3:	0f 86 98 07 00 00    	jbe    f0102941 <mem_init+0x15dc>
		boot_map_region(kern_pgdir,
f01021a9:	83 ec 08             	sub    $0x8,%esp
f01021ac:	6a 02                	push   $0x2
f01021ae:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f01021b4:	50                   	push   %eax
f01021b5:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01021ba:	89 f2                	mov    %esi,%edx
f01021bc:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
f01021c1:	e8 32 ef ff ff       	call   f01010f8 <boot_map_region>
f01021c6:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f01021cc:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	for (i = 0; i < NCPU; ++i)
f01021d2:	83 c4 10             	add    $0x10,%esp
f01021d5:	39 fb                	cmp    %edi,%ebx
f01021d7:	75 c4                	jne    f010219d <mem_init+0xe38>
	pgdir = kern_pgdir;
f01021d9:	8b 3d a4 ee 2a f0    	mov    0xf02aeea4,%edi
	n = ROUNDUP(npages * sizeof(struct PageInfo), PGSIZE);
f01021df:	a1 a0 ee 2a f0       	mov    0xf02aeea0,%eax
f01021e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
f01021e7:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01021ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01021f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01021f6:	a1 a8 ee 2a f0       	mov    0xf02aeea8,%eax
f01021fb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01021fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
	return (physaddr_t)kva - KERNBASE;
f0102201:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi
	for (i = 0; i < n; i += PGSIZE)
f0102207:	bb 00 00 00 00       	mov    $0x0,%ebx
f010220c:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f010220f:	0f 86 71 07 00 00    	jbe    f0102986 <mem_init+0x1621>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102215:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f010221b:	89 f8                	mov    %edi,%eax
f010221d:	e8 30 e9 ff ff       	call   f0100b52 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102222:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102229:	0f 86 27 07 00 00    	jbe    f0102956 <mem_init+0x15f1>
f010222f:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f0102232:	39 d0                	cmp    %edx,%eax
f0102234:	0f 85 33 07 00 00    	jne    f010296d <mem_init+0x1608>
	for (i = 0; i < n; i += PGSIZE)
f010223a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102240:	eb ca                	jmp    f010220c <mem_init+0xea7>
	assert(nfree == 0);
f0102242:	68 1d 74 10 f0       	push   $0xf010741d
f0102247:	68 ba 72 10 f0       	push   $0xf01072ba
f010224c:	68 40 03 00 00       	push   $0x340
f0102251:	68 94 72 10 f0       	push   $0xf0107294
f0102256:	e8 e5 dd ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f010225b:	68 82 73 10 f0       	push   $0xf0107382
f0102260:	68 ba 72 10 f0       	push   $0xf01072ba
f0102265:	68 a4 03 00 00       	push   $0x3a4
f010226a:	68 94 72 10 f0       	push   $0xf0107294
f010226f:	e8 cc dd ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102274:	68 98 73 10 f0       	push   $0xf0107398
f0102279:	68 ba 72 10 f0       	push   $0xf01072ba
f010227e:	68 a5 03 00 00       	push   $0x3a5
f0102283:	68 94 72 10 f0       	push   $0xf0107294
f0102288:	e8 b3 dd ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010228d:	68 ae 73 10 f0       	push   $0xf01073ae
f0102292:	68 ba 72 10 f0       	push   $0xf01072ba
f0102297:	68 a6 03 00 00       	push   $0x3a6
f010229c:	68 94 72 10 f0       	push   $0xf0107294
f01022a1:	e8 9a dd ff ff       	call   f0100040 <_panic>
	assert(pp1 && pp1 != pp0);
f01022a6:	68 c4 73 10 f0       	push   $0xf01073c4
f01022ab:	68 ba 72 10 f0       	push   $0xf01072ba
f01022b0:	68 a9 03 00 00       	push   $0x3a9
f01022b5:	68 94 72 10 f0       	push   $0xf0107294
f01022ba:	e8 81 dd ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01022bf:	68 14 77 10 f0       	push   $0xf0107714
f01022c4:	68 ba 72 10 f0       	push   $0xf01072ba
f01022c9:	68 aa 03 00 00       	push   $0x3aa
f01022ce:	68 94 72 10 f0       	push   $0xf0107294
f01022d3:	e8 68 dd ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01022d8:	68 d6 73 10 f0       	push   $0xf01073d6
f01022dd:	68 ba 72 10 f0       	push   $0xf01072ba
f01022e2:	68 b1 03 00 00       	push   $0x3b1
f01022e7:	68 94 72 10 f0       	push   $0xf0107294
f01022ec:	e8 4f dd ff ff       	call   f0100040 <_panic>
	assert(page_lookup(kern_pgdir, (void *)0x0, &ptep) == NULL);
f01022f1:	68 b4 77 10 f0       	push   $0xf01077b4
f01022f6:	68 ba 72 10 f0       	push   $0xf01072ba
f01022fb:	68 b4 03 00 00       	push   $0x3b4
f0102300:	68 94 72 10 f0       	push   $0xf0107294
f0102305:	e8 36 dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f010230a:	68 e8 77 10 f0       	push   $0xf01077e8
f010230f:	68 ba 72 10 f0       	push   $0xf01072ba
f0102314:	68 b7 03 00 00       	push   $0x3b7
f0102319:	68 94 72 10 f0       	push   $0xf0107294
f010231e:	e8 1d dd ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102323:	68 18 78 10 f0       	push   $0xf0107818
f0102328:	68 ba 72 10 f0       	push   $0xf01072ba
f010232d:	68 bb 03 00 00       	push   $0x3bb
f0102332:	68 94 72 10 f0       	push   $0xf0107294
f0102337:	e8 04 dd ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010233c:	68 48 78 10 f0       	push   $0xf0107848
f0102341:	68 ba 72 10 f0       	push   $0xf01072ba
f0102346:	68 bc 03 00 00       	push   $0x3bc
f010234b:	68 94 72 10 f0       	push   $0xf0107294
f0102350:	e8 eb dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102355:	68 70 78 10 f0       	push   $0xf0107870
f010235a:	68 ba 72 10 f0       	push   $0xf01072ba
f010235f:	68 bd 03 00 00       	push   $0x3bd
f0102364:	68 94 72 10 f0       	push   $0xf0107294
f0102369:	e8 d2 dc ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f010236e:	68 28 74 10 f0       	push   $0xf0107428
f0102373:	68 ba 72 10 f0       	push   $0xf01072ba
f0102378:	68 be 03 00 00       	push   $0x3be
f010237d:	68 94 72 10 f0       	push   $0xf0107294
f0102382:	e8 b9 dc ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102387:	68 39 74 10 f0       	push   $0xf0107439
f010238c:	68 ba 72 10 f0       	push   $0xf01072ba
f0102391:	68 bf 03 00 00       	push   $0x3bf
f0102396:	68 94 72 10 f0       	push   $0xf0107294
f010239b:	e8 a0 dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f01023a0:	68 a0 78 10 f0       	push   $0xf01078a0
f01023a5:	68 ba 72 10 f0       	push   $0xf01072ba
f01023aa:	68 c2 03 00 00       	push   $0x3c2
f01023af:	68 94 72 10 f0       	push   $0xf0107294
f01023b4:	e8 87 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01023b9:	68 dc 78 10 f0       	push   $0xf01078dc
f01023be:	68 ba 72 10 f0       	push   $0xf01072ba
f01023c3:	68 c3 03 00 00       	push   $0x3c3
f01023c8:	68 94 72 10 f0       	push   $0xf0107294
f01023cd:	e8 6e dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01023d2:	68 4a 74 10 f0       	push   $0xf010744a
f01023d7:	68 ba 72 10 f0       	push   $0xf01072ba
f01023dc:	68 c4 03 00 00       	push   $0x3c4
f01023e1:	68 94 72 10 f0       	push   $0xf0107294
f01023e6:	e8 55 dc ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f01023eb:	68 d6 73 10 f0       	push   $0xf01073d6
f01023f0:	68 ba 72 10 f0       	push   $0xf01072ba
f01023f5:	68 c7 03 00 00       	push   $0x3c7
f01023fa:	68 94 72 10 f0       	push   $0xf0107294
f01023ff:	e8 3c dc ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0102404:	68 a0 78 10 f0       	push   $0xf01078a0
f0102409:	68 ba 72 10 f0       	push   $0xf01072ba
f010240e:	68 ca 03 00 00       	push   $0x3ca
f0102413:	68 94 72 10 f0       	push   $0xf0107294
f0102418:	e8 23 dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010241d:	68 dc 78 10 f0       	push   $0xf01078dc
f0102422:	68 ba 72 10 f0       	push   $0xf01072ba
f0102427:	68 cb 03 00 00       	push   $0x3cb
f010242c:	68 94 72 10 f0       	push   $0xf0107294
f0102431:	e8 0a dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102436:	68 4a 74 10 f0       	push   $0xf010744a
f010243b:	68 ba 72 10 f0       	push   $0xf01072ba
f0102440:	68 cc 03 00 00       	push   $0x3cc
f0102445:	68 94 72 10 f0       	push   $0xf0107294
f010244a:	e8 f1 db ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f010244f:	68 d6 73 10 f0       	push   $0xf01073d6
f0102454:	68 ba 72 10 f0       	push   $0xf01072ba
f0102459:	68 d0 03 00 00       	push   $0x3d0
f010245e:	68 94 72 10 f0       	push   $0xf0107294
f0102463:	e8 d8 db ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102468:	50                   	push   %eax
f0102469:	68 c4 6c 10 f0       	push   $0xf0106cc4
f010246e:	68 d3 03 00 00       	push   $0x3d3
f0102473:	68 94 72 10 f0       	push   $0xf0107294
f0102478:	e8 c3 db ff ff       	call   f0100040 <_panic>
	assert(pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) == ptep + PTX(PGSIZE));
f010247d:	68 0c 79 10 f0       	push   $0xf010790c
f0102482:	68 ba 72 10 f0       	push   $0xf01072ba
f0102487:	68 d4 03 00 00       	push   $0x3d4
f010248c:	68 94 72 10 f0       	push   $0xf0107294
f0102491:	e8 aa db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W | PTE_U) == 0);
f0102496:	68 4c 79 10 f0       	push   $0xf010794c
f010249b:	68 ba 72 10 f0       	push   $0xf01072ba
f01024a0:	68 d7 03 00 00       	push   $0x3d7
f01024a5:	68 94 72 10 f0       	push   $0xf0107294
f01024aa:	e8 91 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024af:	68 dc 78 10 f0       	push   $0xf01078dc
f01024b4:	68 ba 72 10 f0       	push   $0xf01072ba
f01024b9:	68 d8 03 00 00       	push   $0x3d8
f01024be:	68 94 72 10 f0       	push   $0xf0107294
f01024c3:	e8 78 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01024c8:	68 4a 74 10 f0       	push   $0xf010744a
f01024cd:	68 ba 72 10 f0       	push   $0xf01072ba
f01024d2:	68 d9 03 00 00       	push   $0x3d9
f01024d7:	68 94 72 10 f0       	push   $0xf0107294
f01024dc:	e8 5f db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U);
f01024e1:	68 90 79 10 f0       	push   $0xf0107990
f01024e6:	68 ba 72 10 f0       	push   $0xf01072ba
f01024eb:	68 da 03 00 00       	push   $0x3da
f01024f0:	68 94 72 10 f0       	push   $0xf0107294
f01024f5:	e8 46 db ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01024fa:	68 5b 74 10 f0       	push   $0xf010745b
f01024ff:	68 ba 72 10 f0       	push   $0xf01072ba
f0102504:	68 db 03 00 00       	push   $0x3db
f0102509:	68 94 72 10 f0       	push   $0xf0107294
f010250e:	e8 2d db ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W) == 0);
f0102513:	68 a0 78 10 f0       	push   $0xf01078a0
f0102518:	68 ba 72 10 f0       	push   $0xf01072ba
f010251d:	68 de 03 00 00       	push   $0x3de
f0102522:	68 94 72 10 f0       	push   $0xf0107294
f0102527:	e8 14 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_W);
f010252c:	68 c4 79 10 f0       	push   $0xf01079c4
f0102531:	68 ba 72 10 f0       	push   $0xf01072ba
f0102536:	68 df 03 00 00       	push   $0x3df
f010253b:	68 94 72 10 f0       	push   $0xf0107294
f0102540:	e8 fb da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0102545:	68 f8 79 10 f0       	push   $0xf01079f8
f010254a:	68 ba 72 10 f0       	push   $0xf01072ba
f010254f:	68 e0 03 00 00       	push   $0x3e0
f0102554:	68 94 72 10 f0       	push   $0xf0107294
f0102559:	e8 e2 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void *)PTSIZE, PTE_W) < 0);
f010255e:	68 30 7a 10 f0       	push   $0xf0107a30
f0102563:	68 ba 72 10 f0       	push   $0xf01072ba
f0102568:	68 e3 03 00 00       	push   $0x3e3
f010256d:	68 94 72 10 f0       	push   $0xf0107294
f0102572:	e8 c9 da ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, PTE_W) == 0);
f0102577:	68 68 7a 10 f0       	push   $0xf0107a68
f010257c:	68 ba 72 10 f0       	push   $0xf01072ba
f0102581:	68 e6 03 00 00       	push   $0x3e6
f0102586:	68 94 72 10 f0       	push   $0xf0107294
f010258b:	e8 b0 da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *)PGSIZE, 0) & PTE_U));
f0102590:	68 f8 79 10 f0       	push   $0xf01079f8
f0102595:	68 ba 72 10 f0       	push   $0xf01072ba
f010259a:	68 e7 03 00 00       	push   $0x3e7
f010259f:	68 94 72 10 f0       	push   $0xf0107294
f01025a4:	e8 97 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01025a9:	68 a4 7a 10 f0       	push   $0xf0107aa4
f01025ae:	68 ba 72 10 f0       	push   $0xf01072ba
f01025b3:	68 ea 03 00 00       	push   $0x3ea
f01025b8:	68 94 72 10 f0       	push   $0xf0107294
f01025bd:	e8 7e da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01025c2:	68 d0 7a 10 f0       	push   $0xf0107ad0
f01025c7:	68 ba 72 10 f0       	push   $0xf01072ba
f01025cc:	68 eb 03 00 00       	push   $0x3eb
f01025d1:	68 94 72 10 f0       	push   $0xf0107294
f01025d6:	e8 65 da ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 2);
f01025db:	68 71 74 10 f0       	push   $0xf0107471
f01025e0:	68 ba 72 10 f0       	push   $0xf01072ba
f01025e5:	68 ed 03 00 00       	push   $0x3ed
f01025ea:	68 94 72 10 f0       	push   $0xf0107294
f01025ef:	e8 4c da ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f01025f4:	68 82 74 10 f0       	push   $0xf0107482
f01025f9:	68 ba 72 10 f0       	push   $0xf01072ba
f01025fe:	68 ee 03 00 00       	push   $0x3ee
f0102603:	68 94 72 10 f0       	push   $0xf0107294
f0102608:	e8 33 da ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f010260d:	68 00 7b 10 f0       	push   $0xf0107b00
f0102612:	68 ba 72 10 f0       	push   $0xf01072ba
f0102617:	68 f1 03 00 00       	push   $0x3f1
f010261c:	68 94 72 10 f0       	push   $0xf0107294
f0102621:	e8 1a da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102626:	68 24 7b 10 f0       	push   $0xf0107b24
f010262b:	68 ba 72 10 f0       	push   $0xf01072ba
f0102630:	68 f5 03 00 00       	push   $0x3f5
f0102635:	68 94 72 10 f0       	push   $0xf0107294
f010263a:	e8 01 da ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010263f:	68 d0 7a 10 f0       	push   $0xf0107ad0
f0102644:	68 ba 72 10 f0       	push   $0xf01072ba
f0102649:	68 f6 03 00 00       	push   $0x3f6
f010264e:	68 94 72 10 f0       	push   $0xf0107294
f0102653:	e8 e8 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102658:	68 28 74 10 f0       	push   $0xf0107428
f010265d:	68 ba 72 10 f0       	push   $0xf01072ba
f0102662:	68 f7 03 00 00       	push   $0x3f7
f0102667:	68 94 72 10 f0       	push   $0xf0107294
f010266c:	e8 cf d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102671:	68 82 74 10 f0       	push   $0xf0107482
f0102676:	68 ba 72 10 f0       	push   $0xf01072ba
f010267b:	68 f8 03 00 00       	push   $0x3f8
f0102680:	68 94 72 10 f0       	push   $0xf0107294
f0102685:	e8 b6 d9 ff ff       	call   f0100040 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void *)PGSIZE, 0) == 0);
f010268a:	68 48 7b 10 f0       	push   $0xf0107b48
f010268f:	68 ba 72 10 f0       	push   $0xf01072ba
f0102694:	68 fb 03 00 00       	push   $0x3fb
f0102699:	68 94 72 10 f0       	push   $0xf0107294
f010269e:	e8 9d d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f01026a3:	68 93 74 10 f0       	push   $0xf0107493
f01026a8:	68 ba 72 10 f0       	push   $0xf01072ba
f01026ad:	68 fc 03 00 00       	push   $0x3fc
f01026b2:	68 94 72 10 f0       	push   $0xf0107294
f01026b7:	e8 84 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f01026bc:	68 9f 74 10 f0       	push   $0xf010749f
f01026c1:	68 ba 72 10 f0       	push   $0xf01072ba
f01026c6:	68 fd 03 00 00       	push   $0x3fd
f01026cb:	68 94 72 10 f0       	push   $0xf0107294
f01026d0:	e8 6b d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01026d5:	68 24 7b 10 f0       	push   $0xf0107b24
f01026da:	68 ba 72 10 f0       	push   $0xf01072ba
f01026df:	68 01 04 00 00       	push   $0x401
f01026e4:	68 94 72 10 f0       	push   $0xf0107294
f01026e9:	e8 52 d9 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01026ee:	68 80 7b 10 f0       	push   $0xf0107b80
f01026f3:	68 ba 72 10 f0       	push   $0xf01072ba
f01026f8:	68 02 04 00 00       	push   $0x402
f01026fd:	68 94 72 10 f0       	push   $0xf0107294
f0102702:	e8 39 d9 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102707:	68 b4 74 10 f0       	push   $0xf01074b4
f010270c:	68 ba 72 10 f0       	push   $0xf01072ba
f0102711:	68 03 04 00 00       	push   $0x403
f0102716:	68 94 72 10 f0       	push   $0xf0107294
f010271b:	e8 20 d9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102720:	68 82 74 10 f0       	push   $0xf0107482
f0102725:	68 ba 72 10 f0       	push   $0xf01072ba
f010272a:	68 04 04 00 00       	push   $0x404
f010272f:	68 94 72 10 f0       	push   $0xf0107294
f0102734:	e8 07 d9 ff ff       	call   f0100040 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102739:	68 a8 7b 10 f0       	push   $0xf0107ba8
f010273e:	68 ba 72 10 f0       	push   $0xf01072ba
f0102743:	68 07 04 00 00       	push   $0x407
f0102748:	68 94 72 10 f0       	push   $0xf0107294
f010274d:	e8 ee d8 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0102752:	68 d6 73 10 f0       	push   $0xf01073d6
f0102757:	68 ba 72 10 f0       	push   $0xf01072ba
f010275c:	68 0a 04 00 00       	push   $0x40a
f0102761:	68 94 72 10 f0       	push   $0xf0107294
f0102766:	e8 d5 d8 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010276b:	68 48 78 10 f0       	push   $0xf0107848
f0102770:	68 ba 72 10 f0       	push   $0xf01072ba
f0102775:	68 0d 04 00 00       	push   $0x40d
f010277a:	68 94 72 10 f0       	push   $0xf0107294
f010277f:	e8 bc d8 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102784:	68 39 74 10 f0       	push   $0xf0107439
f0102789:	68 ba 72 10 f0       	push   $0xf01072ba
f010278e:	68 0f 04 00 00       	push   $0x40f
f0102793:	68 94 72 10 f0       	push   $0xf0107294
f0102798:	e8 a3 d8 ff ff       	call   f0100040 <_panic>
f010279d:	50                   	push   %eax
f010279e:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01027a3:	68 16 04 00 00       	push   $0x416
f01027a8:	68 94 72 10 f0       	push   $0xf0107294
f01027ad:	e8 8e d8 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f01027b2:	68 c5 74 10 f0       	push   $0xf01074c5
f01027b7:	68 ba 72 10 f0       	push   $0xf01072ba
f01027bc:	68 17 04 00 00       	push   $0x417
f01027c1:	68 94 72 10 f0       	push   $0xf0107294
f01027c6:	e8 75 d8 ff ff       	call   f0100040 <_panic>
f01027cb:	50                   	push   %eax
f01027cc:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01027d1:	6a 58                	push   $0x58
f01027d3:	68 a0 72 10 f0       	push   $0xf01072a0
f01027d8:	e8 63 d8 ff ff       	call   f0100040 <_panic>
f01027dd:	52                   	push   %edx
f01027de:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01027e3:	6a 58                	push   $0x58
f01027e5:	68 a0 72 10 f0       	push   $0xf01072a0
f01027ea:	e8 51 d8 ff ff       	call   f0100040 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f01027ef:	68 dd 74 10 f0       	push   $0xf01074dd
f01027f4:	68 ba 72 10 f0       	push   $0xf01072ba
f01027f9:	68 21 04 00 00       	push   $0x421
f01027fe:	68 94 72 10 f0       	push   $0xf0107294
f0102803:	e8 38 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8192 < MMIOLIM);
f0102808:	68 cc 7b 10 f0       	push   $0xf0107bcc
f010280d:	68 ba 72 10 f0       	push   $0xf01072ba
f0102812:	68 31 04 00 00       	push   $0x431
f0102817:	68 94 72 10 f0       	push   $0xf0107294
f010281c:	e8 1f d8 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8192 < MMIOLIM);
f0102821:	68 f4 7b 10 f0       	push   $0xf0107bf4
f0102826:	68 ba 72 10 f0       	push   $0xf01072ba
f010282b:	68 32 04 00 00       	push   $0x432
f0102830:	68 94 72 10 f0       	push   $0xf0107294
f0102835:	e8 06 d8 ff ff       	call   f0100040 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f010283a:	68 1c 7c 10 f0       	push   $0xf0107c1c
f010283f:	68 ba 72 10 f0       	push   $0xf01072ba
f0102844:	68 34 04 00 00       	push   $0x434
f0102849:	68 94 72 10 f0       	push   $0xf0107294
f010284e:	e8 ed d7 ff ff       	call   f0100040 <_panic>
	assert(mm1 + 8192 <= mm2);
f0102853:	68 f4 74 10 f0       	push   $0xf01074f4
f0102858:	68 ba 72 10 f0       	push   $0xf01072ba
f010285d:	68 36 04 00 00       	push   $0x436
f0102862:	68 94 72 10 f0       	push   $0xf0107294
f0102867:	e8 d4 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f010286c:	68 44 7c 10 f0       	push   $0xf0107c44
f0102871:	68 ba 72 10 f0       	push   $0xf01072ba
f0102876:	68 38 04 00 00       	push   $0x438
f010287b:	68 94 72 10 f0       	push   $0xf0107294
f0102880:	e8 bb d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1 + PGSIZE) == PGSIZE);
f0102885:	68 68 7c 10 f0       	push   $0xf0107c68
f010288a:	68 ba 72 10 f0       	push   $0xf01072ba
f010288f:	68 39 04 00 00       	push   $0x439
f0102894:	68 94 72 10 f0       	push   $0xf0107294
f0102899:	e8 a2 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f010289e:	68 98 7c 10 f0       	push   $0xf0107c98
f01028a3:	68 ba 72 10 f0       	push   $0xf01072ba
f01028a8:	68 3a 04 00 00       	push   $0x43a
f01028ad:	68 94 72 10 f0       	push   $0xf0107294
f01028b2:	e8 89 d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2 + PGSIZE) == ~0);
f01028b7:	68 bc 7c 10 f0       	push   $0xf0107cbc
f01028bc:	68 ba 72 10 f0       	push   $0xf01072ba
f01028c1:	68 3b 04 00 00       	push   $0x43b
f01028c6:	68 94 72 10 f0       	push   $0xf0107294
f01028cb:	e8 70 d7 ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void *)mm1, 0) & (PTE_W | PTE_PWT | PTE_PCD));
f01028d0:	68 e8 7c 10 f0       	push   $0xf0107ce8
f01028d5:	68 ba 72 10 f0       	push   $0xf01072ba
f01028da:	68 3d 04 00 00       	push   $0x43d
f01028df:	68 94 72 10 f0       	push   $0xf0107294
f01028e4:	e8 57 d7 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void *)mm1, 0) & PTE_U));
f01028e9:	68 30 7d 10 f0       	push   $0xf0107d30
f01028ee:	68 ba 72 10 f0       	push   $0xf01072ba
f01028f3:	68 3e 04 00 00       	push   $0x43e
f01028f8:	68 94 72 10 f0       	push   $0xf0107294
f01028fd:	e8 3e d7 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102902:	50                   	push   %eax
f0102903:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0102908:	68 be 00 00 00       	push   $0xbe
f010290d:	68 94 72 10 f0       	push   $0xf0107294
f0102912:	e8 29 d7 ff ff       	call   f0100040 <_panic>
f0102917:	50                   	push   %eax
f0102918:	68 e8 6c 10 f0       	push   $0xf0106ce8
f010291d:	68 c7 00 00 00       	push   $0xc7
f0102922:	68 94 72 10 f0       	push   $0xf0107294
f0102927:	e8 14 d7 ff ff       	call   f0100040 <_panic>
f010292c:	50                   	push   %eax
f010292d:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0102932:	68 d4 00 00 00       	push   $0xd4
f0102937:	68 94 72 10 f0       	push   $0xf0107294
f010293c:	e8 ff d6 ff ff       	call   f0100040 <_panic>
f0102941:	53                   	push   %ebx
f0102942:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0102947:	68 1a 01 00 00       	push   $0x11a
f010294c:	68 94 72 10 f0       	push   $0xf0107294
f0102951:	e8 ea d6 ff ff       	call   f0100040 <_panic>
f0102956:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102959:	68 e8 6c 10 f0       	push   $0xf0106ce8
f010295e:	68 58 03 00 00       	push   $0x358
f0102963:	68 94 72 10 f0       	push   $0xf0107294
f0102968:	e8 d3 d6 ff ff       	call   f0100040 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010296d:	68 64 7d 10 f0       	push   $0xf0107d64
f0102972:	68 ba 72 10 f0       	push   $0xf01072ba
f0102977:	68 58 03 00 00       	push   $0x358
f010297c:	68 94 72 10 f0       	push   $0xf0107294
f0102981:	e8 ba d6 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102986:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102989:	c1 e6 0c             	shl    $0xc,%esi
f010298c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102991:	39 f3                	cmp    %esi,%ebx
f0102993:	73 32                	jae    f01029c7 <mem_init+0x1662>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102995:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f010299b:	89 f8                	mov    %edi,%eax
f010299d:	e8 b0 e1 ff ff       	call   f0100b52 <check_va2pa>
f01029a2:	39 c3                	cmp    %eax,%ebx
f01029a4:	75 08                	jne    f01029ae <mem_init+0x1649>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01029ac:	eb e3                	jmp    f0102991 <mem_init+0x162c>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01029ae:	68 98 7d 10 f0       	push   $0xf0107d98
f01029b3:	68 ba 72 10 f0       	push   $0xf01072ba
f01029b8:	68 5c 03 00 00       	push   $0x35c
f01029bd:	68 94 72 10 f0       	push   $0xf0107294
f01029c2:	e8 79 d6 ff ff       	call   f0100040 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01029c7:	c7 45 d4 00 00 2b f0 	movl   $0xf02b0000,-0x2c(%ebp)
f01029ce:	be 00 80 ff ef       	mov    $0xefff8000,%esi
			assert(check_va2pa(pgdir, base + KSTKGAP + i) == PADDR(percpu_kstacks[n]) + i);
f01029d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01029d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01029d9:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f01029df:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01029e2:	89 f3                	mov    %esi,%ebx
f01029e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01029e7:	05 00 80 00 20       	add    $0x20008000,%eax
f01029ec:	89 75 c8             	mov    %esi,-0x38(%ebp)
f01029ef:	89 c6                	mov    %eax,%esi
f01029f1:	89 da                	mov    %ebx,%edx
f01029f3:	89 f8                	mov    %edi,%eax
f01029f5:	e8 58 e1 ff ff       	call   f0100b52 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f01029fa:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102a01:	0f 86 af 00 00 00    	jbe    f0102ab6 <mem_init+0x1751>
f0102a07:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102a0a:	39 d0                	cmp    %edx,%eax
f0102a0c:	0f 85 bb 00 00 00    	jne    f0102acd <mem_init+0x1768>
f0102a12:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102a18:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f0102a1b:	75 d4                	jne    f01029f1 <mem_init+0x168c>
f0102a1d:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102a20:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102a26:	89 da                	mov    %ebx,%edx
f0102a28:	89 f8                	mov    %edi,%eax
f0102a2a:	e8 23 e1 ff ff       	call   f0100b52 <check_va2pa>
f0102a2f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a32:	0f 85 ae 00 00 00    	jne    f0102ae6 <mem_init+0x1781>
f0102a38:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102a3e:	39 f3                	cmp    %esi,%ebx
f0102a40:	75 e4                	jne    f0102a26 <mem_init+0x16c1>
f0102a42:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102a48:	81 45 cc 00 80 01 00 	addl   $0x18000,-0x34(%ebp)
f0102a4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102a52:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
	for (n = 0; n < NCPU; n++)
f0102a59:	3d 00 00 37 f0       	cmp    $0xf0370000,%eax
f0102a5e:	0f 85 6f ff ff ff    	jne    f01029d3 <mem_init+0x166e>
	for (i = 0; i < NPDENTRIES; i++)
f0102a64:	b8 00 00 00 00       	mov    $0x0,%eax
			if (i >= PDX(KERNBASE))
f0102a69:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102a6e:	0f 87 8b 00 00 00    	ja     f0102aff <mem_init+0x179a>
				assert(pgdir[i] == 0);
f0102a74:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102a78:	0f 85 c4 00 00 00    	jne    f0102b42 <mem_init+0x17dd>
	for (i = 0; i < NPDENTRIES; i++)
f0102a7e:	83 c0 01             	add    $0x1,%eax
f0102a81:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102a86:	0f 87 cf 00 00 00    	ja     f0102b5b <mem_init+0x17f6>
		switch (i)
f0102a8c:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102a92:	83 fa 04             	cmp    $0x4,%edx
f0102a95:	77 d2                	ja     f0102a69 <mem_init+0x1704>
			assert(pgdir[i] & PTE_P);
f0102a97:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102a9b:	75 e1                	jne    f0102a7e <mem_init+0x1719>
f0102a9d:	68 1f 75 10 f0       	push   $0xf010751f
f0102aa2:	68 ba 72 10 f0       	push   $0xf01072ba
f0102aa7:	68 73 03 00 00       	push   $0x373
f0102aac:	68 94 72 10 f0       	push   $0xf0107294
f0102ab1:	e8 8a d5 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ab6:	ff 75 c4             	pushl  -0x3c(%ebp)
f0102ab9:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0102abe:	68 64 03 00 00       	push   $0x364
f0102ac3:	68 94 72 10 f0       	push   $0xf0107294
f0102ac8:	e8 73 d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i) == PADDR(percpu_kstacks[n]) + i);
f0102acd:	68 c0 7d 10 f0       	push   $0xf0107dc0
f0102ad2:	68 ba 72 10 f0       	push   $0xf01072ba
f0102ad7:	68 64 03 00 00       	push   $0x364
f0102adc:	68 94 72 10 f0       	push   $0xf0107294
f0102ae1:	e8 5a d5 ff ff       	call   f0100040 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102ae6:	68 08 7e 10 f0       	push   $0xf0107e08
f0102aeb:	68 ba 72 10 f0       	push   $0xf01072ba
f0102af0:	68 66 03 00 00       	push   $0x366
f0102af5:	68 94 72 10 f0       	push   $0xf0107294
f0102afa:	e8 41 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102aff:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102b02:	f6 c2 01             	test   $0x1,%dl
f0102b05:	74 22                	je     f0102b29 <mem_init+0x17c4>
				assert(pgdir[i] & PTE_W);
f0102b07:	f6 c2 02             	test   $0x2,%dl
f0102b0a:	0f 85 6e ff ff ff    	jne    f0102a7e <mem_init+0x1719>
f0102b10:	68 30 75 10 f0       	push   $0xf0107530
f0102b15:	68 ba 72 10 f0       	push   $0xf01072ba
f0102b1a:	68 79 03 00 00       	push   $0x379
f0102b1f:	68 94 72 10 f0       	push   $0xf0107294
f0102b24:	e8 17 d5 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_P);
f0102b29:	68 1f 75 10 f0       	push   $0xf010751f
f0102b2e:	68 ba 72 10 f0       	push   $0xf01072ba
f0102b33:	68 78 03 00 00       	push   $0x378
f0102b38:	68 94 72 10 f0       	push   $0xf0107294
f0102b3d:	e8 fe d4 ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] == 0);
f0102b42:	68 41 75 10 f0       	push   $0xf0107541
f0102b47:	68 ba 72 10 f0       	push   $0xf01072ba
f0102b4c:	68 7c 03 00 00       	push   $0x37c
f0102b51:	68 94 72 10 f0       	push   $0xf0107294
f0102b56:	e8 e5 d4 ff ff       	call   f0100040 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102b5b:	83 ec 0c             	sub    $0xc,%esp
f0102b5e:	68 2c 7e 10 f0       	push   $0xf0107e2c
f0102b63:	e8 c8 0d 00 00       	call   f0103930 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102b68:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0102b6d:	83 c4 10             	add    $0x10,%esp
f0102b70:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102b75:	0f 86 fe 01 00 00    	jbe    f0102d79 <mem_init+0x1a14>
	return (physaddr_t)kva - KERNBASE;
f0102b7b:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102b80:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102b83:	b8 00 00 00 00       	mov    $0x0,%eax
f0102b88:	e8 29 e0 ff ff       	call   f0100bb6 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102b8d:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS | CR0_EM);
f0102b90:	83 e0 f3             	and    $0xfffffff3,%eax
f0102b93:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102b98:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102b9b:	83 ec 0c             	sub    $0xc,%esp
f0102b9e:	6a 00                	push   $0x0
f0102ba0:	e8 ea e3 ff ff       	call   f0100f8f <page_alloc>
f0102ba5:	89 c3                	mov    %eax,%ebx
f0102ba7:	83 c4 10             	add    $0x10,%esp
f0102baa:	85 c0                	test   %eax,%eax
f0102bac:	0f 84 dc 01 00 00    	je     f0102d8e <mem_init+0x1a29>
	assert((pp1 = page_alloc(0)));
f0102bb2:	83 ec 0c             	sub    $0xc,%esp
f0102bb5:	6a 00                	push   $0x0
f0102bb7:	e8 d3 e3 ff ff       	call   f0100f8f <page_alloc>
f0102bbc:	89 c7                	mov    %eax,%edi
f0102bbe:	83 c4 10             	add    $0x10,%esp
f0102bc1:	85 c0                	test   %eax,%eax
f0102bc3:	0f 84 de 01 00 00    	je     f0102da7 <mem_init+0x1a42>
	assert((pp2 = page_alloc(0)));
f0102bc9:	83 ec 0c             	sub    $0xc,%esp
f0102bcc:	6a 00                	push   $0x0
f0102bce:	e8 bc e3 ff ff       	call   f0100f8f <page_alloc>
f0102bd3:	89 c6                	mov    %eax,%esi
f0102bd5:	83 c4 10             	add    $0x10,%esp
f0102bd8:	85 c0                	test   %eax,%eax
f0102bda:	0f 84 e0 01 00 00    	je     f0102dc0 <mem_init+0x1a5b>
	page_free(pp0);
f0102be0:	83 ec 0c             	sub    $0xc,%esp
f0102be3:	53                   	push   %ebx
f0102be4:	e8 18 e4 ff ff       	call   f0101001 <page_free>
	return (pp - pages) << PGSHIFT;
f0102be9:	89 f8                	mov    %edi,%eax
f0102beb:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0102bf1:	c1 f8 03             	sar    $0x3,%eax
f0102bf4:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102bf7:	89 c2                	mov    %eax,%edx
f0102bf9:	c1 ea 0c             	shr    $0xc,%edx
f0102bfc:	83 c4 10             	add    $0x10,%esp
f0102bff:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f0102c05:	0f 83 ce 01 00 00    	jae    f0102dd9 <mem_init+0x1a74>
	memset(page2kva(pp1), 1, PGSIZE);
f0102c0b:	83 ec 04             	sub    $0x4,%esp
f0102c0e:	68 00 10 00 00       	push   $0x1000
f0102c13:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102c15:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c1a:	50                   	push   %eax
f0102c1b:	e8 8f 2e 00 00       	call   f0105aaf <memset>
	return (pp - pages) << PGSHIFT;
f0102c20:	89 f0                	mov    %esi,%eax
f0102c22:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0102c28:	c1 f8 03             	sar    $0x3,%eax
f0102c2b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102c2e:	89 c2                	mov    %eax,%edx
f0102c30:	c1 ea 0c             	shr    $0xc,%edx
f0102c33:	83 c4 10             	add    $0x10,%esp
f0102c36:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f0102c3c:	0f 83 a9 01 00 00    	jae    f0102deb <mem_init+0x1a86>
	memset(page2kva(pp2), 2, PGSIZE);
f0102c42:	83 ec 04             	sub    $0x4,%esp
f0102c45:	68 00 10 00 00       	push   $0x1000
f0102c4a:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102c4c:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c51:	50                   	push   %eax
f0102c52:	e8 58 2e 00 00       	call   f0105aaf <memset>
	page_insert(kern_pgdir, pp1, (void *)PGSIZE, PTE_W);
f0102c57:	6a 02                	push   $0x2
f0102c59:	68 00 10 00 00       	push   $0x1000
f0102c5e:	57                   	push   %edi
f0102c5f:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0102c65:	e8 fd e5 ff ff       	call   f0101267 <page_insert>
	assert(pp1->pp_ref == 1);
f0102c6a:	83 c4 20             	add    $0x20,%esp
f0102c6d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102c72:	0f 85 85 01 00 00    	jne    f0102dfd <mem_init+0x1a98>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102c78:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f0102c7f:	01 01 01 
f0102c82:	0f 85 8e 01 00 00    	jne    f0102e16 <mem_init+0x1ab1>
	page_insert(kern_pgdir, pp2, (void *)PGSIZE, PTE_W);
f0102c88:	6a 02                	push   $0x2
f0102c8a:	68 00 10 00 00       	push   $0x1000
f0102c8f:	56                   	push   %esi
f0102c90:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0102c96:	e8 cc e5 ff ff       	call   f0101267 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102c9b:	83 c4 10             	add    $0x10,%esp
f0102c9e:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0102ca5:	02 02 02 
f0102ca8:	0f 85 81 01 00 00    	jne    f0102e2f <mem_init+0x1aca>
	assert(pp2->pp_ref == 1);
f0102cae:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102cb3:	0f 85 8f 01 00 00    	jne    f0102e48 <mem_init+0x1ae3>
	assert(pp1->pp_ref == 0);
f0102cb9:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0102cbe:	0f 85 9d 01 00 00    	jne    f0102e61 <mem_init+0x1afc>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0102cc4:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0102ccb:	03 03 03 
	return (pp - pages) << PGSHIFT;
f0102cce:	89 f0                	mov    %esi,%eax
f0102cd0:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0102cd6:	c1 f8 03             	sar    $0x3,%eax
f0102cd9:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102cdc:	89 c2                	mov    %eax,%edx
f0102cde:	c1 ea 0c             	shr    $0xc,%edx
f0102ce1:	3b 15 a0 ee 2a f0    	cmp    0xf02aeea0,%edx
f0102ce7:	0f 83 8d 01 00 00    	jae    f0102e7a <mem_init+0x1b15>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102ced:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0102cf4:	03 03 03 
f0102cf7:	0f 85 8f 01 00 00    	jne    f0102e8c <mem_init+0x1b27>
	page_remove(kern_pgdir, (void *)PGSIZE);
f0102cfd:	83 ec 08             	sub    $0x8,%esp
f0102d00:	68 00 10 00 00       	push   $0x1000
f0102d05:	ff 35 a4 ee 2a f0    	pushl  0xf02aeea4
f0102d0b:	e8 08 e5 ff ff       	call   f0101218 <page_remove>
	assert(pp2->pp_ref == 0);
f0102d10:	83 c4 10             	add    $0x10,%esp
f0102d13:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102d18:	0f 85 87 01 00 00    	jne    f0102ea5 <mem_init+0x1b40>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102d1e:	8b 0d a4 ee 2a f0    	mov    0xf02aeea4,%ecx
f0102d24:	8b 11                	mov    (%ecx),%edx
f0102d26:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f0102d2c:	89 d8                	mov    %ebx,%eax
f0102d2e:	2b 05 a8 ee 2a f0    	sub    0xf02aeea8,%eax
f0102d34:	c1 f8 03             	sar    $0x3,%eax
f0102d37:	c1 e0 0c             	shl    $0xc,%eax
f0102d3a:	39 c2                	cmp    %eax,%edx
f0102d3c:	0f 85 7c 01 00 00    	jne    f0102ebe <mem_init+0x1b59>
	kern_pgdir[0] = 0;
f0102d42:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102d48:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102d4d:	0f 85 84 01 00 00    	jne    f0102ed7 <mem_init+0x1b72>
	pp0->pp_ref = 0;
f0102d53:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f0102d59:	83 ec 0c             	sub    $0xc,%esp
f0102d5c:	53                   	push   %ebx
f0102d5d:	e8 9f e2 ff ff       	call   f0101001 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0102d62:	c7 04 24 c0 7e 10 f0 	movl   $0xf0107ec0,(%esp)
f0102d69:	e8 c2 0b 00 00       	call   f0103930 <cprintf>
}
f0102d6e:	83 c4 10             	add    $0x10,%esp
f0102d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102d74:	5b                   	pop    %ebx
f0102d75:	5e                   	pop    %esi
f0102d76:	5f                   	pop    %edi
f0102d77:	5d                   	pop    %ebp
f0102d78:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102d79:	50                   	push   %eax
f0102d7a:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0102d7f:	68 ed 00 00 00       	push   $0xed
f0102d84:	68 94 72 10 f0       	push   $0xf0107294
f0102d89:	e8 b2 d2 ff ff       	call   f0100040 <_panic>
	assert((pp0 = page_alloc(0)));
f0102d8e:	68 82 73 10 f0       	push   $0xf0107382
f0102d93:	68 ba 72 10 f0       	push   $0xf01072ba
f0102d98:	68 53 04 00 00       	push   $0x453
f0102d9d:	68 94 72 10 f0       	push   $0xf0107294
f0102da2:	e8 99 d2 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0102da7:	68 98 73 10 f0       	push   $0xf0107398
f0102dac:	68 ba 72 10 f0       	push   $0xf01072ba
f0102db1:	68 54 04 00 00       	push   $0x454
f0102db6:	68 94 72 10 f0       	push   $0xf0107294
f0102dbb:	e8 80 d2 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0102dc0:	68 ae 73 10 f0       	push   $0xf01073ae
f0102dc5:	68 ba 72 10 f0       	push   $0xf01072ba
f0102dca:	68 55 04 00 00       	push   $0x455
f0102dcf:	68 94 72 10 f0       	push   $0xf0107294
f0102dd4:	e8 67 d2 ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102dd9:	50                   	push   %eax
f0102dda:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0102ddf:	6a 58                	push   $0x58
f0102de1:	68 a0 72 10 f0       	push   $0xf01072a0
f0102de6:	e8 55 d2 ff ff       	call   f0100040 <_panic>
f0102deb:	50                   	push   %eax
f0102dec:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0102df1:	6a 58                	push   $0x58
f0102df3:	68 a0 72 10 f0       	push   $0xf01072a0
f0102df8:	e8 43 d2 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f0102dfd:	68 28 74 10 f0       	push   $0xf0107428
f0102e02:	68 ba 72 10 f0       	push   $0xf01072ba
f0102e07:	68 5a 04 00 00       	push   $0x45a
f0102e0c:	68 94 72 10 f0       	push   $0xf0107294
f0102e11:	e8 2a d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0102e16:	68 4c 7e 10 f0       	push   $0xf0107e4c
f0102e1b:	68 ba 72 10 f0       	push   $0xf01072ba
f0102e20:	68 5b 04 00 00       	push   $0x45b
f0102e25:	68 94 72 10 f0       	push   $0xf0107294
f0102e2a:	e8 11 d2 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0102e2f:	68 70 7e 10 f0       	push   $0xf0107e70
f0102e34:	68 ba 72 10 f0       	push   $0xf01072ba
f0102e39:	68 5d 04 00 00       	push   $0x45d
f0102e3e:	68 94 72 10 f0       	push   $0xf0107294
f0102e43:	e8 f8 d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102e48:	68 4a 74 10 f0       	push   $0xf010744a
f0102e4d:	68 ba 72 10 f0       	push   $0xf01072ba
f0102e52:	68 5e 04 00 00       	push   $0x45e
f0102e57:	68 94 72 10 f0       	push   $0xf0107294
f0102e5c:	e8 df d1 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102e61:	68 b4 74 10 f0       	push   $0xf01074b4
f0102e66:	68 ba 72 10 f0       	push   $0xf01072ba
f0102e6b:	68 5f 04 00 00       	push   $0x45f
f0102e70:	68 94 72 10 f0       	push   $0xf0107294
f0102e75:	e8 c6 d1 ff ff       	call   f0100040 <_panic>
f0102e7a:	50                   	push   %eax
f0102e7b:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0102e80:	6a 58                	push   $0x58
f0102e82:	68 a0 72 10 f0       	push   $0xf01072a0
f0102e87:	e8 b4 d1 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0102e8c:	68 94 7e 10 f0       	push   $0xf0107e94
f0102e91:	68 ba 72 10 f0       	push   $0xf01072ba
f0102e96:	68 61 04 00 00       	push   $0x461
f0102e9b:	68 94 72 10 f0       	push   $0xf0107294
f0102ea0:	e8 9b d1 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102ea5:	68 82 74 10 f0       	push   $0xf0107482
f0102eaa:	68 ba 72 10 f0       	push   $0xf01072ba
f0102eaf:	68 63 04 00 00       	push   $0x463
f0102eb4:	68 94 72 10 f0       	push   $0xf0107294
f0102eb9:	e8 82 d1 ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102ebe:	68 48 78 10 f0       	push   $0xf0107848
f0102ec3:	68 ba 72 10 f0       	push   $0xf01072ba
f0102ec8:	68 66 04 00 00       	push   $0x466
f0102ecd:	68 94 72 10 f0       	push   $0xf0107294
f0102ed2:	e8 69 d1 ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f0102ed7:	68 39 74 10 f0       	push   $0xf0107439
f0102edc:	68 ba 72 10 f0       	push   $0xf01072ba
f0102ee1:	68 68 04 00 00       	push   $0x468
f0102ee6:	68 94 72 10 f0       	push   $0xf0107294
f0102eeb:	e8 50 d1 ff ff       	call   f0100040 <_panic>

f0102ef0 <user_mem_check>:
{
f0102ef0:	55                   	push   %ebp
f0102ef1:	89 e5                	mov    %esp,%ebp
f0102ef3:	57                   	push   %edi
f0102ef4:	56                   	push   %esi
f0102ef5:	53                   	push   %ebx
f0102ef6:	83 ec 0c             	sub    $0xc,%esp
f0102ef9:	8b 75 14             	mov    0x14(%ebp),%esi
	size_t start = (size_t)ROUNDDOWN(va, PGSIZE);
f0102efc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0102eff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	size_t end = (size_t)ROUNDUP(va + len, PGSIZE);
f0102f05:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0102f08:	03 7d 10             	add    0x10(%ebp),%edi
f0102f0b:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
f0102f11:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	while (start < end)
f0102f17:	39 fb                	cmp    %edi,%ebx
f0102f19:	73 4e                	jae    f0102f69 <user_mem_check+0x79>
		pte_t *pte = pgdir_walk(env->env_pgdir, (void *)start, 0);
f0102f1b:	83 ec 04             	sub    $0x4,%esp
f0102f1e:	6a 00                	push   $0x0
f0102f20:	53                   	push   %ebx
f0102f21:	8b 45 08             	mov    0x8(%ebp),%eax
f0102f24:	ff 70 60             	pushl  0x60(%eax)
f0102f27:	e8 39 e1 ff ff       	call   f0101065 <pgdir_walk>
		if (start >= ULIM ||
f0102f2c:	83 c4 10             	add    $0x10,%esp
f0102f2f:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102f35:	77 18                	ja     f0102f4f <user_mem_check+0x5f>
f0102f37:	85 c0                	test   %eax,%eax
f0102f39:	74 14                	je     f0102f4f <user_mem_check+0x5f>
			!(*pte & PTE_P) ||
f0102f3b:	8b 00                	mov    (%eax),%eax
			!pte ||
f0102f3d:	a8 01                	test   $0x1,%al
f0102f3f:	74 0e                	je     f0102f4f <user_mem_check+0x5f>
			((*pte & perm) != perm))
f0102f41:	21 f0                	and    %esi,%eax
			!(*pte & PTE_P) ||
f0102f43:	39 c6                	cmp    %eax,%esi
f0102f45:	75 08                	jne    f0102f4f <user_mem_check+0x5f>
		start += PGSIZE;
f0102f47:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102f4d:	eb c8                	jmp    f0102f17 <user_mem_check+0x27>
			user_mem_check_addr = start > (size_t)va ? start : (size_t)va;
f0102f4f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0102f52:	0f 42 5d 0c          	cmovb  0xc(%ebp),%ebx
f0102f56:	89 1d 3c e2 2a f0    	mov    %ebx,0xf02ae23c
			return -E_FAULT;
f0102f5c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0102f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0102f64:	5b                   	pop    %ebx
f0102f65:	5e                   	pop    %esi
f0102f66:	5f                   	pop    %edi
f0102f67:	5d                   	pop    %ebp
f0102f68:	c3                   	ret    
	return 0;
f0102f69:	b8 00 00 00 00       	mov    $0x0,%eax
f0102f6e:	eb f1                	jmp    f0102f61 <user_mem_check+0x71>

f0102f70 <user_mem_assert>:
{
f0102f70:	55                   	push   %ebp
f0102f71:	89 e5                	mov    %esp,%ebp
f0102f73:	53                   	push   %ebx
f0102f74:	83 ec 04             	sub    $0x4,%esp
f0102f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0)
f0102f7a:	8b 45 14             	mov    0x14(%ebp),%eax
f0102f7d:	83 c8 04             	or     $0x4,%eax
f0102f80:	50                   	push   %eax
f0102f81:	ff 75 10             	pushl  0x10(%ebp)
f0102f84:	ff 75 0c             	pushl  0xc(%ebp)
f0102f87:	53                   	push   %ebx
f0102f88:	e8 63 ff ff ff       	call   f0102ef0 <user_mem_check>
f0102f8d:	83 c4 10             	add    $0x10,%esp
f0102f90:	85 c0                	test   %eax,%eax
f0102f92:	78 05                	js     f0102f99 <user_mem_assert+0x29>
}
f0102f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0102f97:	c9                   	leave  
f0102f98:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0102f99:	83 ec 04             	sub    $0x4,%esp
f0102f9c:	ff 35 3c e2 2a f0    	pushl  0xf02ae23c
f0102fa2:	ff 73 48             	pushl  0x48(%ebx)
f0102fa5:	68 ec 7e 10 f0       	push   $0xf0107eec
f0102faa:	e8 81 09 00 00       	call   f0103930 <cprintf>
		env_destroy(env); // may not return
f0102faf:	89 1c 24             	mov    %ebx,(%esp)
f0102fb2:	e8 9e 06 00 00       	call   f0103655 <env_destroy>
f0102fb7:	83 c4 10             	add    $0x10,%esp
}
f0102fba:	eb d8                	jmp    f0102f94 <user_mem_assert+0x24>

f0102fbc <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0102fbc:	55                   	push   %ebp
f0102fbd:	89 e5                	mov    %esp,%ebp
f0102fbf:	57                   	push   %edi
f0102fc0:	56                   	push   %esi
f0102fc1:	53                   	push   %ebx
f0102fc2:	83 ec 0c             	sub    $0xc,%esp
f0102fc5:	89 c7                	mov    %eax,%edi
	//
	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
	void *begin = ROUNDDOWN(va, PGSIZE);
f0102fc7:	89 d3                	mov    %edx,%ebx
f0102fc9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	void *end = ROUNDUP(va + len, PGSIZE);
f0102fcf:	8d b4 0a ff 0f 00 00 	lea    0xfff(%edx,%ecx,1),%esi
f0102fd6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	while (begin < end)
f0102fdc:	39 f3                	cmp    %esi,%ebx
f0102fde:	73 3f                	jae    f010301f <region_alloc+0x63>
	{
		struct PageInfo *pg = page_alloc(0);
f0102fe0:	83 ec 0c             	sub    $0xc,%esp
f0102fe3:	6a 00                	push   $0x0
f0102fe5:	e8 a5 df ff ff       	call   f0100f8f <page_alloc>
		if (pg == NULL)
f0102fea:	83 c4 10             	add    $0x10,%esp
f0102fed:	85 c0                	test   %eax,%eax
f0102fef:	74 17                	je     f0103008 <region_alloc+0x4c>
			panic("page allocation failed!");
		page_insert(e->env_pgdir, pg, begin, PTE_W | PTE_U);
f0102ff1:	6a 06                	push   $0x6
f0102ff3:	53                   	push   %ebx
f0102ff4:	50                   	push   %eax
f0102ff5:	ff 77 60             	pushl  0x60(%edi)
f0102ff8:	e8 6a e2 ff ff       	call   f0101267 <page_insert>
		begin += PGSIZE;
f0102ffd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103003:	83 c4 10             	add    $0x10,%esp
f0103006:	eb d4                	jmp    f0102fdc <region_alloc+0x20>
			panic("page allocation failed!");
f0103008:	83 ec 04             	sub    $0x4,%esp
f010300b:	68 21 7f 10 f0       	push   $0xf0107f21
f0103010:	68 3a 01 00 00       	push   $0x13a
f0103015:	68 39 7f 10 f0       	push   $0xf0107f39
f010301a:	e8 21 d0 ff ff       	call   f0100040 <_panic>
	}
}
f010301f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103022:	5b                   	pop    %ebx
f0103023:	5e                   	pop    %esi
f0103024:	5f                   	pop    %edi
f0103025:	5d                   	pop    %ebp
f0103026:	c3                   	ret    

f0103027 <envid2env>:
{
f0103027:	55                   	push   %ebp
f0103028:	89 e5                	mov    %esp,%ebp
f010302a:	56                   	push   %esi
f010302b:	53                   	push   %ebx
f010302c:	8b 45 08             	mov    0x8(%ebp),%eax
f010302f:	8b 55 10             	mov    0x10(%ebp),%edx
	if (envid == 0)
f0103032:	85 c0                	test   %eax,%eax
f0103034:	74 2e                	je     f0103064 <envid2env+0x3d>
	e = &envs[ENVX(envid)];
f0103036:	89 c3                	mov    %eax,%ebx
f0103038:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f010303e:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f0103041:	03 1d 48 e2 2a f0    	add    0xf02ae248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid)
f0103047:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f010304b:	74 31                	je     f010307e <envid2env+0x57>
f010304d:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103050:	75 2c                	jne    f010307e <envid2env+0x57>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id)
f0103052:	84 d2                	test   %dl,%dl
f0103054:	75 38                	jne    f010308e <envid2env+0x67>
	*env_store = e;
f0103056:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103059:	89 18                	mov    %ebx,(%eax)
	return 0;
f010305b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103060:	5b                   	pop    %ebx
f0103061:	5e                   	pop    %esi
f0103062:	5d                   	pop    %ebp
f0103063:	c3                   	ret    
		*env_store = curenv;
f0103064:	e8 6a 30 00 00       	call   f01060d3 <cpunum>
f0103069:	6b c0 74             	imul   $0x74,%eax,%eax
f010306c:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0103072:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103075:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103077:	b8 00 00 00 00       	mov    $0x0,%eax
f010307c:	eb e2                	jmp    f0103060 <envid2env+0x39>
		*env_store = 0;
f010307e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103087:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010308c:	eb d2                	jmp    f0103060 <envid2env+0x39>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id)
f010308e:	e8 40 30 00 00       	call   f01060d3 <cpunum>
f0103093:	6b c0 74             	imul   $0x74,%eax,%eax
f0103096:	39 98 28 f0 2a f0    	cmp    %ebx,-0xfd50fd8(%eax)
f010309c:	74 b8                	je     f0103056 <envid2env+0x2f>
f010309e:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01030a1:	e8 2d 30 00 00       	call   f01060d3 <cpunum>
f01030a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01030a9:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f01030af:	3b 70 48             	cmp    0x48(%eax),%esi
f01030b2:	74 a2                	je     f0103056 <envid2env+0x2f>
		*env_store = 0;
f01030b4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01030b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01030bd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01030c2:	eb 9c                	jmp    f0103060 <envid2env+0x39>

f01030c4 <env_init_percpu>:
{
f01030c4:	55                   	push   %ebp
f01030c5:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f01030c7:	b8 20 43 12 f0       	mov    $0xf0124320,%eax
f01030cc:	0f 01 10             	lgdtl  (%eax)
	asm volatile("movw %%ax,%%gs"
f01030cf:	b8 23 00 00 00       	mov    $0x23,%eax
f01030d4:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs"
f01030d6:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es"
f01030d8:	b8 10 00 00 00       	mov    $0x10,%eax
f01030dd:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds"
f01030df:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss"
f01030e1:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n"
f01030e3:	ea ea 30 10 f0 08 00 	ljmp   $0x8,$0xf01030ea
	asm volatile("lldt %0" : : "r" (sel));
f01030ea:	b8 00 00 00 00       	mov    $0x0,%eax
f01030ef:	0f 00 d0             	lldt   %ax
}
f01030f2:	5d                   	pop    %ebp
f01030f3:	c3                   	ret    

f01030f4 <env_init>:
{
f01030f4:	55                   	push   %ebp
f01030f5:	89 e5                	mov    %esp,%ebp
f01030f7:	56                   	push   %esi
f01030f8:	53                   	push   %ebx
		envs[i].env_id = 0;
f01030f9:	8b 35 48 e2 2a f0    	mov    0xf02ae248,%esi
f01030ff:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f0103105:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f0103108:	ba 00 00 00 00       	mov    $0x0,%edx
f010310d:	89 c1                	mov    %eax,%ecx
f010310f:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i].env_status = ENV_FREE;
f0103116:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
		envs[i].env_link = env_free_list;
f010311d:	89 50 44             	mov    %edx,0x44(%eax)
f0103120:	83 e8 7c             	sub    $0x7c,%eax
		env_free_list = &envs[i];
f0103123:	89 ca                	mov    %ecx,%edx
	for (i = NENV - 1; i >= 0; --i)
f0103125:	39 d8                	cmp    %ebx,%eax
f0103127:	75 e4                	jne    f010310d <env_init+0x19>
f0103129:	89 35 4c e2 2a f0    	mov    %esi,0xf02ae24c
	env_init_percpu();
f010312f:	e8 90 ff ff ff       	call   f01030c4 <env_init_percpu>
}
f0103134:	5b                   	pop    %ebx
f0103135:	5e                   	pop    %esi
f0103136:	5d                   	pop    %ebp
f0103137:	c3                   	ret    

f0103138 <env_alloc>:
{
f0103138:	55                   	push   %ebp
f0103139:	89 e5                	mov    %esp,%ebp
f010313b:	53                   	push   %ebx
f010313c:	83 ec 04             	sub    $0x4,%esp
	if (!(e = env_free_list))
f010313f:	8b 1d 4c e2 2a f0    	mov    0xf02ae24c,%ebx
f0103145:	85 db                	test   %ebx,%ebx
f0103147:	0f 84 92 01 00 00    	je     f01032df <env_alloc+0x1a7>
	if (!(p = page_alloc(ALLOC_ZERO)))
f010314d:	83 ec 0c             	sub    $0xc,%esp
f0103150:	6a 01                	push   $0x1
f0103152:	e8 38 de ff ff       	call   f0100f8f <page_alloc>
f0103157:	83 c4 10             	add    $0x10,%esp
f010315a:	85 c0                	test   %eax,%eax
f010315c:	0f 84 84 01 00 00    	je     f01032e6 <env_alloc+0x1ae>
	return (pp - pages) << PGSHIFT;
f0103162:	89 c2                	mov    %eax,%edx
f0103164:	2b 15 a8 ee 2a f0    	sub    0xf02aeea8,%edx
f010316a:	c1 fa 03             	sar    $0x3,%edx
f010316d:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f0103170:	89 d1                	mov    %edx,%ecx
f0103172:	c1 e9 0c             	shr    $0xc,%ecx
f0103175:	3b 0d a0 ee 2a f0    	cmp    0xf02aeea0,%ecx
f010317b:	0f 83 37 01 00 00    	jae    f01032b8 <env_alloc+0x180>
	return (void *)(pa + KERNBASE);
f0103181:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103187:	89 53 60             	mov    %edx,0x60(%ebx)
	p->pp_ref++;
f010318a:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
f010318f:	b8 00 00 00 00       	mov    $0x0,%eax
		e->env_pgdir[i] = 0;
f0103194:	8b 53 60             	mov    0x60(%ebx),%edx
f0103197:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
f010319e:	83 c0 04             	add    $0x4,%eax
	for (i = 0; i < PDX(UTOP); ++i)
f01031a1:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f01031a6:	75 ec                	jne    f0103194 <env_alloc+0x5c>
		e->env_pgdir[i] = kern_pgdir[i];
f01031a8:	8b 15 a4 ee 2a f0    	mov    0xf02aeea4,%edx
f01031ae:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
f01031b1:	8b 53 60             	mov    0x60(%ebx),%edx
f01031b4:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f01031b7:	83 c0 04             	add    $0x4,%eax
	for (i = PDX(UTOP); i < NPDENTRIES; ++i)
f01031ba:	3d 00 10 00 00       	cmp    $0x1000,%eax
f01031bf:	75 e7                	jne    f01031a8 <env_alloc+0x70>
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f01031c1:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01031c4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01031c9:	0f 86 fb 00 00 00    	jbe    f01032ca <env_alloc+0x192>
	return (physaddr_t)kva - KERNBASE;
f01031cf:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01031d5:	83 ca 05             	or     $0x5,%edx
f01031d8:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f01031de:	8b 43 48             	mov    0x48(%ebx),%eax
f01031e1:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0) // Don't create a negative env_id.
f01031e6:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f01031eb:	ba 00 10 00 00       	mov    $0x1000,%edx
f01031f0:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f01031f3:	89 da                	mov    %ebx,%edx
f01031f5:	2b 15 48 e2 2a f0    	sub    0xf02ae248,%edx
f01031fb:	c1 fa 02             	sar    $0x2,%edx
f01031fe:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f0103204:	09 d0                	or     %edx,%eax
f0103206:	89 43 48             	mov    %eax,0x48(%ebx)
	e->env_parent_id = parent_id;
f0103209:	8b 45 0c             	mov    0xc(%ebp),%eax
f010320c:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f010320f:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103216:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f010321d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103224:	83 ec 04             	sub    $0x4,%esp
f0103227:	6a 44                	push   $0x44
f0103229:	6a 00                	push   $0x0
f010322b:	53                   	push   %ebx
f010322c:	e8 7e 28 00 00       	call   f0105aaf <memset>
	e->env_tf.tf_ds = GD_UD | 3;
f0103231:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103237:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f010323d:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103243:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f010324a:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	e->env_tf.tf_eflags |= FL_IF;
f0103250:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	e->env_pgfault_upcall = 0;
f0103257:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)
	e->env_ipc_recving = 0;
f010325e:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	env_free_list = e->env_link;
f0103262:	8b 43 44             	mov    0x44(%ebx),%eax
f0103265:	a3 4c e2 2a f0       	mov    %eax,0xf02ae24c
	*newenv_store = e;
f010326a:	8b 45 08             	mov    0x8(%ebp),%eax
f010326d:	89 18                	mov    %ebx,(%eax)
	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010326f:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103272:	e8 5c 2e 00 00       	call   f01060d3 <cpunum>
f0103277:	6b c0 74             	imul   $0x74,%eax,%eax
f010327a:	83 c4 10             	add    $0x10,%esp
f010327d:	ba 00 00 00 00       	mov    $0x0,%edx
f0103282:	83 b8 28 f0 2a f0 00 	cmpl   $0x0,-0xfd50fd8(%eax)
f0103289:	74 11                	je     f010329c <env_alloc+0x164>
f010328b:	e8 43 2e 00 00       	call   f01060d3 <cpunum>
f0103290:	6b c0 74             	imul   $0x74,%eax,%eax
f0103293:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0103299:	8b 50 48             	mov    0x48(%eax),%edx
f010329c:	83 ec 04             	sub    $0x4,%esp
f010329f:	53                   	push   %ebx
f01032a0:	52                   	push   %edx
f01032a1:	68 44 7f 10 f0       	push   $0xf0107f44
f01032a6:	e8 85 06 00 00       	call   f0103930 <cprintf>
	return 0;
f01032ab:	83 c4 10             	add    $0x10,%esp
f01032ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01032b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01032b6:	c9                   	leave  
f01032b7:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01032b8:	52                   	push   %edx
f01032b9:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01032be:	6a 58                	push   $0x58
f01032c0:	68 a0 72 10 f0       	push   $0xf01072a0
f01032c5:	e8 76 cd ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01032ca:	50                   	push   %eax
f01032cb:	68 e8 6c 10 f0       	push   $0xf0106ce8
f01032d0:	68 d6 00 00 00       	push   $0xd6
f01032d5:	68 39 7f 10 f0       	push   $0xf0107f39
f01032da:	e8 61 cd ff ff       	call   f0100040 <_panic>
		return -E_NO_FREE_ENV;
f01032df:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01032e4:	eb cd                	jmp    f01032b3 <env_alloc+0x17b>
		return -E_NO_MEM;
f01032e6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01032eb:	eb c6                	jmp    f01032b3 <env_alloc+0x17b>

f01032ed <env_create>:
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void env_create(uint8_t *binary, enum EnvType type)
{
f01032ed:	55                   	push   %ebp
f01032ee:	89 e5                	mov    %esp,%ebp
f01032f0:	57                   	push   %edi
f01032f1:	56                   	push   %esi
f01032f2:	53                   	push   %ebx
f01032f3:	83 ec 34             	sub    $0x34,%esp
	// LAB 3: Your code here.
	struct Env *e;
	if (env_alloc(&e, 0) != 0)
f01032f6:	6a 00                	push   $0x0
f01032f8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01032fb:	50                   	push   %eax
f01032fc:	e8 37 fe ff ff       	call   f0103138 <env_alloc>
f0103301:	83 c4 10             	add    $0x10,%esp
f0103304:	85 c0                	test   %eax,%eax
f0103306:	75 47                	jne    f010334f <env_create+0x62>
f0103308:	89 c6                	mov    %eax,%esi
		panic("env_create failed: env_alloc failed.\n");
	load_icode(e, binary);
f010330a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010330d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (header->e_magic != ELF_MAGIC)
f0103310:	8b 45 08             	mov    0x8(%ebp),%eax
f0103313:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f0103319:	75 4b                	jne    f0103366 <env_create+0x79>
	if (header->e_entry == 0)
f010331b:	8b 45 08             	mov    0x8(%ebp),%eax
f010331e:	8b 40 18             	mov    0x18(%eax),%eax
f0103321:	85 c0                	test   %eax,%eax
f0103323:	74 58                	je     f010337d <env_create+0x90>
	e->env_tf.tf_eip = header->e_entry;
f0103325:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0103328:	89 42 30             	mov    %eax,0x30(%edx)
	struct Proghdr *ph = (struct Proghdr *)((uint8_t *)header + header->e_phoff);
f010332b:	8b 45 08             	mov    0x8(%ebp),%eax
f010332e:	8b 58 1c             	mov    0x1c(%eax),%ebx
	int ph_num = header->e_phnum;
f0103331:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103335:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	lcr3(PADDR(e->env_pgdir)); //加载用户空间页目录
f0103338:	8b 42 60             	mov    0x60(%edx),%eax
	if ((uint32_t)kva < KERNBASE)
f010333b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103340:	76 52                	jbe    f0103394 <env_create+0xa7>
	return (physaddr_t)kva - KERNBASE;
f0103342:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103347:	0f 22 d8             	mov    %eax,%cr3
f010334a:	03 5d 08             	add    0x8(%ebp),%ebx
f010334d:	eb 77                	jmp    f01033c6 <env_create+0xd9>
		panic("env_create failed: env_alloc failed.\n");
f010334f:	83 ec 04             	sub    $0x4,%esp
f0103352:	68 7c 7f 10 f0       	push   $0xf0107f7c
f0103357:	68 a4 01 00 00       	push   $0x1a4
f010335c:	68 39 7f 10 f0       	push   $0xf0107f39
f0103361:	e8 da cc ff ff       	call   f0100040 <_panic>
		panic("load_icode failed:the binary is not elf.\n");
f0103366:	83 ec 04             	sub    $0x4,%esp
f0103369:	68 a4 7f 10 f0       	push   $0xf0107fa4
f010336e:	68 78 01 00 00       	push   $0x178
f0103373:	68 39 7f 10 f0       	push   $0xf0107f39
f0103378:	e8 c3 cc ff ff       	call   f0100040 <_panic>
		panic("load_icode failed:the elf can't be excuted.\n");
f010337d:	83 ec 04             	sub    $0x4,%esp
f0103380:	68 d0 7f 10 f0       	push   $0xf0107fd0
f0103385:	68 7a 01 00 00       	push   $0x17a
f010338a:	68 39 7f 10 f0       	push   $0xf0107f39
f010338f:	e8 ac cc ff ff       	call   f0100040 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103394:	50                   	push   %eax
f0103395:	68 e8 6c 10 f0       	push   $0xf0106ce8
f010339a:	68 81 01 00 00       	push   $0x181
f010339f:	68 39 7f 10 f0       	push   $0xf0107f39
f01033a4:	e8 97 cc ff ff       	call   f0100040 <_panic>
				panic("load_icode failed:p_memsz<p_filesz.\n");
f01033a9:	83 ec 04             	sub    $0x4,%esp
f01033ac:	68 00 80 10 f0       	push   $0xf0108000
f01033b1:	68 89 01 00 00       	push   $0x189
f01033b6:	68 39 7f 10 f0       	push   $0xf0107f39
f01033bb:	e8 80 cc ff ff       	call   f0100040 <_panic>
	for (i = 0; i < ph_num; ++i)
f01033c0:	83 c6 01             	add    $0x1,%esi
f01033c3:	83 c3 20             	add    $0x20,%ebx
f01033c6:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f01033c9:	74 42                	je     f010340d <env_create+0x120>
		if (ph[i].p_type == ELF_PROG_LOAD)
f01033cb:	83 3b 01             	cmpl   $0x1,(%ebx)
f01033ce:	75 f0                	jne    f01033c0 <env_create+0xd3>
			if (ph[i].p_memsz < ph[i].p_filesz)
f01033d0:	8b 4b 14             	mov    0x14(%ebx),%ecx
f01033d3:	3b 4b 10             	cmp    0x10(%ebx),%ecx
f01033d6:	72 d1                	jb     f01033a9 <env_create+0xbc>
			region_alloc(e, (void *)ph[i].p_va, ph[i].p_memsz);
f01033d8:	8b 53 08             	mov    0x8(%ebx),%edx
f01033db:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01033de:	e8 d9 fb ff ff       	call   f0102fbc <region_alloc>
			memset((void *)ph[i].p_va, 0, ph[i].p_memsz);
f01033e3:	83 ec 04             	sub    $0x4,%esp
f01033e6:	ff 73 14             	pushl  0x14(%ebx)
f01033e9:	6a 00                	push   $0x0
f01033eb:	ff 73 08             	pushl  0x8(%ebx)
f01033ee:	e8 bc 26 00 00       	call   f0105aaf <memset>
			memcpy((void *)ph[i].p_va, binary + ph[i].p_offset, ph[i].p_filesz);
f01033f3:	83 c4 0c             	add    $0xc,%esp
f01033f6:	ff 73 10             	pushl  0x10(%ebx)
f01033f9:	8b 45 08             	mov    0x8(%ebp),%eax
f01033fc:	03 43 04             	add    0x4(%ebx),%eax
f01033ff:	50                   	push   %eax
f0103400:	ff 73 08             	pushl  0x8(%ebx)
f0103403:	e8 5c 27 00 00       	call   f0105b64 <memcpy>
f0103408:	83 c4 10             	add    $0x10,%esp
f010340b:	eb b3                	jmp    f01033c0 <env_create+0xd3>
	lcr3(PADDR(kern_pgdir));
f010340d:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0103412:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103417:	76 30                	jbe    f0103449 <env_create+0x15c>
	return (physaddr_t)kva - KERNBASE;
f0103419:	05 00 00 00 10       	add    $0x10000000,%eax
f010341e:	0f 22 d8             	mov    %eax,%cr3
	region_alloc(e, (void *)(USTACKTOP - PGSIZE), PGSIZE);
f0103421:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103426:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f010342b:	8b 45 d0             	mov    -0x30(%ebp),%eax
f010342e:	e8 89 fb ff ff       	call   f0102fbc <region_alloc>
	e->env_type = type;
f0103433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103439:	89 48 50             	mov    %ecx,0x50(%eax)

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if (type == ENV_TYPE_FS)
f010343c:	83 f9 01             	cmp    $0x1,%ecx
f010343f:	74 1d                	je     f010345e <env_create+0x171>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
}
f0103441:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103444:	5b                   	pop    %ebx
f0103445:	5e                   	pop    %esi
f0103446:	5f                   	pop    %edi
f0103447:	5d                   	pop    %ebp
f0103448:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103449:	50                   	push   %eax
f010344a:	68 e8 6c 10 f0       	push   $0xf0106ce8
f010344f:	68 90 01 00 00       	push   $0x190
f0103454:	68 39 7f 10 f0       	push   $0xf0107f39
f0103459:	e8 e2 cb ff ff       	call   f0100040 <_panic>
		e->env_tf.tf_eflags |= FL_IOPL_MASK;
f010345e:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
}
f0103465:	eb da                	jmp    f0103441 <env_create+0x154>

f0103467 <env_free>:

//
// Frees env e and all memory it uses.
//
void env_free(struct Env *e)
{
f0103467:	55                   	push   %ebp
f0103468:	89 e5                	mov    %esp,%ebp
f010346a:	57                   	push   %edi
f010346b:	56                   	push   %esi
f010346c:	53                   	push   %ebx
f010346d:	83 ec 1c             	sub    $0x1c,%esp
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103470:	e8 5e 2c 00 00       	call   f01060d3 <cpunum>
f0103475:	6b c0 74             	imul   $0x74,%eax,%eax
f0103478:	8b 55 08             	mov    0x8(%ebp),%edx
f010347b:	39 90 28 f0 2a f0    	cmp    %edx,-0xfd50fd8(%eax)
f0103481:	75 14                	jne    f0103497 <env_free+0x30>
		lcr3(PADDR(kern_pgdir));
f0103483:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0103488:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010348d:	76 56                	jbe    f01034e5 <env_free+0x7e>
	return (physaddr_t)kva - KERNBASE;
f010348f:	05 00 00 00 10       	add    $0x10000000,%eax
f0103494:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103497:	8b 45 08             	mov    0x8(%ebp),%eax
f010349a:	8b 58 48             	mov    0x48(%eax),%ebx
f010349d:	e8 31 2c 00 00       	call   f01060d3 <cpunum>
f01034a2:	6b c0 74             	imul   $0x74,%eax,%eax
f01034a5:	ba 00 00 00 00       	mov    $0x0,%edx
f01034aa:	83 b8 28 f0 2a f0 00 	cmpl   $0x0,-0xfd50fd8(%eax)
f01034b1:	74 11                	je     f01034c4 <env_free+0x5d>
f01034b3:	e8 1b 2c 00 00       	call   f01060d3 <cpunum>
f01034b8:	6b c0 74             	imul   $0x74,%eax,%eax
f01034bb:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f01034c1:	8b 50 48             	mov    0x48(%eax),%edx
f01034c4:	83 ec 04             	sub    $0x4,%esp
f01034c7:	53                   	push   %ebx
f01034c8:	52                   	push   %edx
f01034c9:	68 59 7f 10 f0       	push   $0xf0107f59
f01034ce:	e8 5d 04 00 00       	call   f0103930 <cprintf>
f01034d3:	83 c4 10             	add    $0x10,%esp
f01034d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01034dd:	8b 7d 08             	mov    0x8(%ebp),%edi
f01034e0:	e9 8f 00 00 00       	jmp    f0103574 <env_free+0x10d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034e5:	50                   	push   %eax
f01034e6:	68 e8 6c 10 f0       	push   $0xf0106ce8
f01034eb:	68 bb 01 00 00       	push   $0x1bb
f01034f0:	68 39 7f 10 f0       	push   $0xf0107f39
f01034f5:	e8 46 cb ff ff       	call   f0100040 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01034fa:	50                   	push   %eax
f01034fb:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0103500:	68 cb 01 00 00       	push   $0x1cb
f0103505:	68 39 7f 10 f0       	push   $0xf0107f39
f010350a:	e8 31 cb ff ff       	call   f0100040 <_panic>
f010350f:	83 c3 04             	add    $0x4,%ebx
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t *)KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++)
f0103512:	39 f3                	cmp    %esi,%ebx
f0103514:	74 21                	je     f0103537 <env_free+0xd0>
		{
			if (pt[pteno] & PTE_P)
f0103516:	f6 03 01             	testb  $0x1,(%ebx)
f0103519:	74 f4                	je     f010350f <env_free+0xa8>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010351b:	83 ec 08             	sub    $0x8,%esp
f010351e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103521:	01 d8                	add    %ebx,%eax
f0103523:	c1 e0 0a             	shl    $0xa,%eax
f0103526:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103529:	50                   	push   %eax
f010352a:	ff 77 60             	pushl  0x60(%edi)
f010352d:	e8 e6 dc ff ff       	call   f0101218 <page_remove>
f0103532:	83 c4 10             	add    $0x10,%esp
f0103535:	eb d8                	jmp    f010350f <env_free+0xa8>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103537:	8b 47 60             	mov    0x60(%edi),%eax
f010353a:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010353d:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	if (PGNUM(pa) >= npages)
f0103544:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103547:	3b 05 a0 ee 2a f0    	cmp    0xf02aeea0,%eax
f010354d:	73 6a                	jae    f01035b9 <env_free+0x152>
		page_decref(pa2page(pa));
f010354f:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103552:	a1 a8 ee 2a f0       	mov    0xf02aeea8,%eax
f0103557:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010355a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f010355d:	50                   	push   %eax
f010355e:	e8 d9 da ff ff       	call   f010103c <page_decref>
f0103563:	83 c4 10             	add    $0x10,%esp
f0103566:	83 45 dc 04          	addl   $0x4,-0x24(%ebp)
f010356a:	8b 45 dc             	mov    -0x24(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++)
f010356d:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103572:	74 59                	je     f01035cd <env_free+0x166>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103574:	8b 47 60             	mov    0x60(%edi),%eax
f0103577:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010357a:	8b 04 10             	mov    (%eax,%edx,1),%eax
f010357d:	a8 01                	test   $0x1,%al
f010357f:	74 e5                	je     f0103566 <env_free+0xff>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103581:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0103586:	89 c2                	mov    %eax,%edx
f0103588:	c1 ea 0c             	shr    $0xc,%edx
f010358b:	89 55 d8             	mov    %edx,-0x28(%ebp)
f010358e:	39 15 a0 ee 2a f0    	cmp    %edx,0xf02aeea0
f0103594:	0f 86 60 ff ff ff    	jbe    f01034fa <env_free+0x93>
	return (void *)(pa + KERNBASE);
f010359a:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01035a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01035a3:	c1 e2 14             	shl    $0x14,%edx
f01035a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01035a9:	8d b0 00 10 00 f0    	lea    -0xffff000(%eax),%esi
f01035af:	f7 d8                	neg    %eax
f01035b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01035b4:	e9 5d ff ff ff       	jmp    f0103516 <env_free+0xaf>
		panic("pa2page called with invalid pa");
f01035b9:	83 ec 04             	sub    $0x4,%esp
f01035bc:	68 8c 76 10 f0       	push   $0xf010768c
f01035c1:	6a 51                	push   $0x51
f01035c3:	68 a0 72 10 f0       	push   $0xf01072a0
f01035c8:	e8 73 ca ff ff       	call   f0100040 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01035cd:	8b 45 08             	mov    0x8(%ebp),%eax
f01035d0:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01035d3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01035d8:	76 52                	jbe    f010362c <env_free+0x1c5>
	e->env_pgdir = 0;
f01035da:	8b 55 08             	mov    0x8(%ebp),%edx
f01035dd:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
	return (physaddr_t)kva - KERNBASE;
f01035e4:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01035e9:	c1 e8 0c             	shr    $0xc,%eax
f01035ec:	3b 05 a0 ee 2a f0    	cmp    0xf02aeea0,%eax
f01035f2:	73 4d                	jae    f0103641 <env_free+0x1da>
	page_decref(pa2page(pa));
f01035f4:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01035f7:	8b 15 a8 ee 2a f0    	mov    0xf02aeea8,%edx
f01035fd:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f0103600:	50                   	push   %eax
f0103601:	e8 36 da ff ff       	call   f010103c <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103606:	8b 45 08             	mov    0x8(%ebp),%eax
f0103609:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f0103610:	a1 4c e2 2a f0       	mov    0xf02ae24c,%eax
f0103615:	8b 55 08             	mov    0x8(%ebp),%edx
f0103618:	89 42 44             	mov    %eax,0x44(%edx)
	env_free_list = e;
f010361b:	89 15 4c e2 2a f0    	mov    %edx,0xf02ae24c
}
f0103621:	83 c4 10             	add    $0x10,%esp
f0103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103627:	5b                   	pop    %ebx
f0103628:	5e                   	pop    %esi
f0103629:	5f                   	pop    %edi
f010362a:	5d                   	pop    %ebp
f010362b:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010362c:	50                   	push   %eax
f010362d:	68 e8 6c 10 f0       	push   $0xf0106ce8
f0103632:	68 da 01 00 00       	push   $0x1da
f0103637:	68 39 7f 10 f0       	push   $0xf0107f39
f010363c:	e8 ff c9 ff ff       	call   f0100040 <_panic>
		panic("pa2page called with invalid pa");
f0103641:	83 ec 04             	sub    $0x4,%esp
f0103644:	68 8c 76 10 f0       	push   $0xf010768c
f0103649:	6a 51                	push   $0x51
f010364b:	68 a0 72 10 f0       	push   $0xf01072a0
f0103650:	e8 eb c9 ff ff       	call   f0100040 <_panic>

f0103655 <env_destroy>:
// Frees environment e.
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void env_destroy(struct Env *e)
{
f0103655:	55                   	push   %ebp
f0103656:	89 e5                	mov    %esp,%ebp
f0103658:	53                   	push   %ebx
f0103659:	83 ec 04             	sub    $0x4,%esp
f010365c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e)
f010365f:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103663:	74 21                	je     f0103686 <env_destroy+0x31>
	{
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103665:	83 ec 0c             	sub    $0xc,%esp
f0103668:	53                   	push   %ebx
f0103669:	e8 f9 fd ff ff       	call   f0103467 <env_free>

	if (curenv == e)
f010366e:	e8 60 2a 00 00       	call   f01060d3 <cpunum>
f0103673:	6b c0 74             	imul   $0x74,%eax,%eax
f0103676:	83 c4 10             	add    $0x10,%esp
f0103679:	39 98 28 f0 2a f0    	cmp    %ebx,-0xfd50fd8(%eax)
f010367f:	74 1e                	je     f010369f <env_destroy+0x4a>
	{
		curenv = NULL;
		sched_yield();
	}
}
f0103681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103684:	c9                   	leave  
f0103685:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e)
f0103686:	e8 48 2a 00 00       	call   f01060d3 <cpunum>
f010368b:	6b c0 74             	imul   $0x74,%eax,%eax
f010368e:	39 98 28 f0 2a f0    	cmp    %ebx,-0xfd50fd8(%eax)
f0103694:	74 cf                	je     f0103665 <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103696:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f010369d:	eb e2                	jmp    f0103681 <env_destroy+0x2c>
		curenv = NULL;
f010369f:	e8 2f 2a 00 00       	call   f01060d3 <cpunum>
f01036a4:	6b c0 74             	imul   $0x74,%eax,%eax
f01036a7:	c7 80 28 f0 2a f0 00 	movl   $0x0,-0xfd50fd8(%eax)
f01036ae:	00 00 00 
		sched_yield();
f01036b1:	e8 fa 10 00 00       	call   f01047b0 <sched_yield>

f01036b6 <env_pop_tf>:
// This exits the kernel and starts executing some environment's code.
//
// This function does not return.
//
void env_pop_tf(struct Trapframe *tf)
{
f01036b6:	55                   	push   %ebp
f01036b7:	89 e5                	mov    %esp,%ebp
f01036b9:	53                   	push   %ebx
f01036ba:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f01036bd:	e8 11 2a 00 00       	call   f01060d3 <cpunum>
f01036c2:	6b c0 74             	imul   $0x74,%eax,%eax
f01036c5:	8b 98 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%ebx
f01036cb:	e8 03 2a 00 00       	call   f01060d3 <cpunum>
f01036d0:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01036d3:	8b 65 08             	mov    0x8(%ebp),%esp
f01036d6:	61                   	popa   
f01036d7:	07                   	pop    %es
f01036d8:	1f                   	pop    %ds
f01036d9:	83 c4 08             	add    $0x8,%esp
f01036dc:	cf                   	iret   
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		:
		: "g"(tf)
		: "memory");
	panic("iret failed"); /* mostly to placate the compiler */
f01036dd:	83 ec 04             	sub    $0x4,%esp
f01036e0:	68 6f 7f 10 f0       	push   $0xf0107f6f
f01036e5:	68 12 02 00 00       	push   $0x212
f01036ea:	68 39 7f 10 f0       	push   $0xf0107f39
f01036ef:	e8 4c c9 ff ff       	call   f0100040 <_panic>

f01036f4 <env_run>:
// Note: if this is the first call to env_run, curenv is NULL.
//
// This function does not return.
//
void env_run(struct Env *e)
{
f01036f4:	55                   	push   %ebp
f01036f5:	89 e5                	mov    %esp,%ebp
f01036f7:	53                   	push   %ebx
f01036f8:	83 ec 04             	sub    $0x4,%esp
f01036fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if (curenv != NULL && curenv->env_status == ENV_RUNNING)
f01036fe:	e8 d0 29 00 00       	call   f01060d3 <cpunum>
f0103703:	6b c0 74             	imul   $0x74,%eax,%eax
f0103706:	83 b8 28 f0 2a f0 00 	cmpl   $0x0,-0xfd50fd8(%eax)
f010370d:	74 14                	je     f0103723 <env_run+0x2f>
f010370f:	e8 bf 29 00 00       	call   f01060d3 <cpunum>
f0103714:	6b c0 74             	imul   $0x74,%eax,%eax
f0103717:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f010371d:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103721:	74 38                	je     f010375b <env_run+0x67>
		curenv->env_status = ENV_RUNNABLE;
	curenv = e;
f0103723:	e8 ab 29 00 00       	call   f01060d3 <cpunum>
f0103728:	6b c0 74             	imul   $0x74,%eax,%eax
f010372b:	89 98 28 f0 2a f0    	mov    %ebx,-0xfd50fd8(%eax)
	e->env_status = ENV_RUNNING;
f0103731:	c7 43 54 03 00 00 00 	movl   $0x3,0x54(%ebx)
	e->env_runs++;
f0103738:	83 43 58 01          	addl   $0x1,0x58(%ebx)
	lcr3(PADDR(e->env_pgdir));
f010373c:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f010373f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103744:	77 2c                	ja     f0103772 <env_run+0x7e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103746:	50                   	push   %eax
f0103747:	68 e8 6c 10 f0       	push   $0xf0106ce8
f010374c:	68 34 02 00 00       	push   $0x234
f0103751:	68 39 7f 10 f0       	push   $0xf0107f39
f0103756:	e8 e5 c8 ff ff       	call   f0100040 <_panic>
		curenv->env_status = ENV_RUNNABLE;
f010375b:	e8 73 29 00 00       	call   f01060d3 <cpunum>
f0103760:	6b c0 74             	imul   $0x74,%eax,%eax
f0103763:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0103769:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103770:	eb b1                	jmp    f0103723 <env_run+0x2f>
	return (physaddr_t)kva - KERNBASE;
f0103772:	05 00 00 00 10       	add    $0x10000000,%eax
f0103777:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010377a:	83 ec 0c             	sub    $0xc,%esp
f010377d:	68 c0 43 12 f0       	push   $0xf01243c0
f0103782:	e8 59 2c 00 00       	call   f01063e0 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103787:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&e->env_tf);
f0103789:	89 1c 24             	mov    %ebx,(%esp)
f010378c:	e8 25 ff ff ff       	call   f01036b6 <env_pop_tf>

f0103791 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103791:	55                   	push   %ebp
f0103792:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103794:	8b 45 08             	mov    0x8(%ebp),%eax
f0103797:	ba 70 00 00 00       	mov    $0x70,%edx
f010379c:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010379d:	ba 71 00 00 00       	mov    $0x71,%edx
f01037a2:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01037a3:	0f b6 c0             	movzbl %al,%eax
}
f01037a6:	5d                   	pop    %ebp
f01037a7:	c3                   	ret    

f01037a8 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01037a8:	55                   	push   %ebp
f01037a9:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01037ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01037ae:	ba 70 00 00 00       	mov    $0x70,%edx
f01037b3:	ee                   	out    %al,(%dx)
f01037b4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01037b7:	ba 71 00 00 00       	mov    $0x71,%edx
f01037bc:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01037bd:	5d                   	pop    %ebp
f01037be:	c3                   	ret    

f01037bf <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01037bf:	55                   	push   %ebp
f01037c0:	89 e5                	mov    %esp,%ebp
f01037c2:	56                   	push   %esi
f01037c3:	53                   	push   %ebx
f01037c4:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f01037c7:	66 a3 a8 43 12 f0    	mov    %ax,0xf01243a8
	if (!didinit)
f01037cd:	80 3d 50 e2 2a f0 00 	cmpb   $0x0,0xf02ae250
f01037d4:	75 07                	jne    f01037dd <irq_setmask_8259A+0x1e>
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
}
f01037d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01037d9:	5b                   	pop    %ebx
f01037da:	5e                   	pop    %esi
f01037db:	5d                   	pop    %ebp
f01037dc:	c3                   	ret    
f01037dd:	89 c6                	mov    %eax,%esi
f01037df:	ba 21 00 00 00       	mov    $0x21,%edx
f01037e4:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, (char)(mask >> 8));
f01037e5:	66 c1 e8 08          	shr    $0x8,%ax
f01037e9:	ba a1 00 00 00       	mov    $0xa1,%edx
f01037ee:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f01037ef:	83 ec 0c             	sub    $0xc,%esp
f01037f2:	68 25 80 10 f0       	push   $0xf0108025
f01037f7:	e8 34 01 00 00       	call   f0103930 <cprintf>
f01037fc:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 16; i++)
f01037ff:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103804:	0f b7 f6             	movzwl %si,%esi
f0103807:	f7 d6                	not    %esi
f0103809:	eb 08                	jmp    f0103813 <irq_setmask_8259A+0x54>
	for (i = 0; i < 16; i++)
f010380b:	83 c3 01             	add    $0x1,%ebx
f010380e:	83 fb 10             	cmp    $0x10,%ebx
f0103811:	74 18                	je     f010382b <irq_setmask_8259A+0x6c>
		if (~mask & (1<<i))
f0103813:	0f a3 de             	bt     %ebx,%esi
f0103816:	73 f3                	jae    f010380b <irq_setmask_8259A+0x4c>
			cprintf(" %d", i);
f0103818:	83 ec 08             	sub    $0x8,%esp
f010381b:	53                   	push   %ebx
f010381c:	68 ff 84 10 f0       	push   $0xf01084ff
f0103821:	e8 0a 01 00 00       	call   f0103930 <cprintf>
f0103826:	83 c4 10             	add    $0x10,%esp
f0103829:	eb e0                	jmp    f010380b <irq_setmask_8259A+0x4c>
	cprintf("\n");
f010382b:	83 ec 0c             	sub    $0xc,%esp
f010382e:	68 1d 75 10 f0       	push   $0xf010751d
f0103833:	e8 f8 00 00 00       	call   f0103930 <cprintf>
f0103838:	83 c4 10             	add    $0x10,%esp
f010383b:	eb 99                	jmp    f01037d6 <irq_setmask_8259A+0x17>

f010383d <pic_init>:
{
f010383d:	55                   	push   %ebp
f010383e:	89 e5                	mov    %esp,%ebp
f0103840:	57                   	push   %edi
f0103841:	56                   	push   %esi
f0103842:	53                   	push   %ebx
f0103843:	83 ec 0c             	sub    $0xc,%esp
	didinit = 1;
f0103846:	c6 05 50 e2 2a f0 01 	movb   $0x1,0xf02ae250
f010384d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103852:	bb 21 00 00 00       	mov    $0x21,%ebx
f0103857:	89 da                	mov    %ebx,%edx
f0103859:	ee                   	out    %al,(%dx)
f010385a:	b9 a1 00 00 00       	mov    $0xa1,%ecx
f010385f:	89 ca                	mov    %ecx,%edx
f0103861:	ee                   	out    %al,(%dx)
f0103862:	bf 11 00 00 00       	mov    $0x11,%edi
f0103867:	be 20 00 00 00       	mov    $0x20,%esi
f010386c:	89 f8                	mov    %edi,%eax
f010386e:	89 f2                	mov    %esi,%edx
f0103870:	ee                   	out    %al,(%dx)
f0103871:	b8 20 00 00 00       	mov    $0x20,%eax
f0103876:	89 da                	mov    %ebx,%edx
f0103878:	ee                   	out    %al,(%dx)
f0103879:	b8 04 00 00 00       	mov    $0x4,%eax
f010387e:	ee                   	out    %al,(%dx)
f010387f:	b8 03 00 00 00       	mov    $0x3,%eax
f0103884:	ee                   	out    %al,(%dx)
f0103885:	bb a0 00 00 00       	mov    $0xa0,%ebx
f010388a:	89 f8                	mov    %edi,%eax
f010388c:	89 da                	mov    %ebx,%edx
f010388e:	ee                   	out    %al,(%dx)
f010388f:	b8 28 00 00 00       	mov    $0x28,%eax
f0103894:	89 ca                	mov    %ecx,%edx
f0103896:	ee                   	out    %al,(%dx)
f0103897:	b8 02 00 00 00       	mov    $0x2,%eax
f010389c:	ee                   	out    %al,(%dx)
f010389d:	b8 01 00 00 00       	mov    $0x1,%eax
f01038a2:	ee                   	out    %al,(%dx)
f01038a3:	bf 68 00 00 00       	mov    $0x68,%edi
f01038a8:	89 f8                	mov    %edi,%eax
f01038aa:	89 f2                	mov    %esi,%edx
f01038ac:	ee                   	out    %al,(%dx)
f01038ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
f01038b2:	89 c8                	mov    %ecx,%eax
f01038b4:	ee                   	out    %al,(%dx)
f01038b5:	89 f8                	mov    %edi,%eax
f01038b7:	89 da                	mov    %ebx,%edx
f01038b9:	ee                   	out    %al,(%dx)
f01038ba:	89 c8                	mov    %ecx,%eax
f01038bc:	ee                   	out    %al,(%dx)
	if (irq_mask_8259A != 0xFFFF)
f01038bd:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01038c4:	66 83 f8 ff          	cmp    $0xffff,%ax
f01038c8:	74 0f                	je     f01038d9 <pic_init+0x9c>
		irq_setmask_8259A(irq_mask_8259A);
f01038ca:	83 ec 0c             	sub    $0xc,%esp
f01038cd:	0f b7 c0             	movzwl %ax,%eax
f01038d0:	50                   	push   %eax
f01038d1:	e8 e9 fe ff ff       	call   f01037bf <irq_setmask_8259A>
f01038d6:	83 c4 10             	add    $0x10,%esp
}
f01038d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01038dc:	5b                   	pop    %ebx
f01038dd:	5e                   	pop    %esi
f01038de:	5f                   	pop    %edi
f01038df:	5d                   	pop    %ebp
f01038e0:	c3                   	ret    

f01038e1 <irq_eoi>:

void
irq_eoi(void)
{
f01038e1:	55                   	push   %ebp
f01038e2:	89 e5                	mov    %esp,%ebp
f01038e4:	b8 20 00 00 00       	mov    $0x20,%eax
f01038e9:	ba 20 00 00 00       	mov    $0x20,%edx
f01038ee:	ee                   	out    %al,(%dx)
f01038ef:	ba a0 00 00 00       	mov    $0xa0,%edx
f01038f4:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01038f5:	5d                   	pop    %ebp
f01038f6:	c3                   	ret    

f01038f7 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01038f7:	55                   	push   %ebp
f01038f8:	89 e5                	mov    %esp,%ebp
f01038fa:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f01038fd:	ff 75 08             	pushl  0x8(%ebp)
f0103900:	e8 b6 ce ff ff       	call   f01007bb <cputchar>
	*cnt++;
}
f0103905:	83 c4 10             	add    $0x10,%esp
f0103908:	c9                   	leave  
f0103909:	c3                   	ret    

f010390a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010390a:	55                   	push   %ebp
f010390b:	89 e5                	mov    %esp,%ebp
f010390d:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103917:	ff 75 0c             	pushl  0xc(%ebp)
f010391a:	ff 75 08             	pushl  0x8(%ebp)
f010391d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103920:	50                   	push   %eax
f0103921:	68 f7 38 10 f0       	push   $0xf01038f7
f0103926:	e8 33 1a 00 00       	call   f010535e <vprintfmt>
	return cnt;
}
f010392b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010392e:	c9                   	leave  
f010392f:	c3                   	ret    

f0103930 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103930:	55                   	push   %ebp
f0103931:	89 e5                	mov    %esp,%ebp
f0103933:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103936:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103939:	50                   	push   %eax
f010393a:	ff 75 08             	pushl  0x8(%ebp)
f010393d:	e8 c8 ff ff ff       	call   f010390a <vcprintf>
	va_end(ap);

	return cnt;
}
f0103942:	c9                   	leave  
f0103943:	c3                   	ret    

f0103944 <trap_init_percpu>:
	trap_init_percpu();
}

// Initialize and load the per-CPU TSS and IDT
void trap_init_percpu(void)
{
f0103944:	55                   	push   %ebp
f0103945:	89 e5                	mov    %esp,%ebp
f0103947:	57                   	push   %edi
f0103948:	56                   	push   %esi
f0103949:	53                   	push   %ebx
f010394a:	83 ec 1c             	sub    $0x1c,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	int i = cpunum();
f010394d:	e8 81 27 00 00       	call   f01060d3 <cpunum>
f0103952:	89 c6                	mov    %eax,%esi
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
f0103954:	e8 7a 27 00 00       	call   f01060d3 <cpunum>
f0103959:	6b c0 74             	imul   $0x74,%eax,%eax
f010395c:	89 f1                	mov    %esi,%ecx
f010395e:	c1 e1 10             	shl    $0x10,%ecx
f0103961:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103966:	29 ca                	sub    %ecx,%edx
f0103968:	89 90 30 f0 2a f0    	mov    %edx,-0xfd50fd0(%eax)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f010396e:	e8 60 27 00 00       	call   f01060d3 <cpunum>
f0103973:	6b c0 74             	imul   $0x74,%eax,%eax
f0103976:	66 c7 80 34 f0 2a f0 	movw   $0x10,-0xfd50fcc(%eax)
f010397d:	10 00 
	thiscpu->cpu_ts.ts_iomb = sizeof(struct Taskstate);
f010397f:	e8 4f 27 00 00       	call   f01060d3 <cpunum>
f0103984:	6b c0 74             	imul   $0x74,%eax,%eax
f0103987:	66 c7 80 92 f0 2a f0 	movw   $0x68,-0xfd50f6e(%eax)
f010398e:	68 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + i] = SEG16(STS_T32A, (uint32_t)(&thiscpu->cpu_ts),
f0103990:	8d 5e 05             	lea    0x5(%esi),%ebx
f0103993:	e8 3b 27 00 00       	call   f01060d3 <cpunum>
f0103998:	89 c7                	mov    %eax,%edi
f010399a:	e8 34 27 00 00       	call   f01060d3 <cpunum>
f010399f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01039a2:	e8 2c 27 00 00       	call   f01060d3 <cpunum>
f01039a7:	66 c7 04 dd 40 43 12 	movw   $0x67,-0xfedbcc0(,%ebx,8)
f01039ae:	f0 67 00 
f01039b1:	6b ff 74             	imul   $0x74,%edi,%edi
f01039b4:	81 c7 2c f0 2a f0    	add    $0xf02af02c,%edi
f01039ba:	66 89 3c dd 42 43 12 	mov    %di,-0xfedbcbe(,%ebx,8)
f01039c1:	f0 
f01039c2:	6b 55 e4 74          	imul   $0x74,-0x1c(%ebp),%edx
f01039c6:	81 c2 2c f0 2a f0    	add    $0xf02af02c,%edx
f01039cc:	c1 ea 10             	shr    $0x10,%edx
f01039cf:	88 14 dd 44 43 12 f0 	mov    %dl,-0xfedbcbc(,%ebx,8)
f01039d6:	c6 04 dd 46 43 12 f0 	movb   $0x40,-0xfedbcba(,%ebx,8)
f01039dd:	40 
f01039de:	6b c0 74             	imul   $0x74,%eax,%eax
f01039e1:	05 2c f0 2a f0       	add    $0xf02af02c,%eax
f01039e6:	c1 e8 18             	shr    $0x18,%eax
f01039e9:	88 04 dd 47 43 12 f0 	mov    %al,-0xfedbcb9(,%ebx,8)
									sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + i].sd_s = 0;
f01039f0:	c6 04 dd 45 43 12 f0 	movb   $0x89,-0xfedbcbb(,%ebx,8)
f01039f7:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + (i << 3));
f01039f8:	8d 34 f5 28 00 00 00 	lea    0x28(,%esi,8),%esi
	asm volatile("ltr %0" : : "r" (sel));
f01039ff:	0f 00 de             	ltr    %si
	asm volatile("lidt (%0)" : : "r" (p));
f0103a02:	b8 ac 43 12 f0       	mov    $0xf01243ac,%eax
f0103a07:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103a0a:	83 c4 1c             	add    $0x1c,%esp
f0103a0d:	5b                   	pop    %ebx
f0103a0e:	5e                   	pop    %esi
f0103a0f:	5f                   	pop    %edi
f0103a10:	5d                   	pop    %ebp
f0103a11:	c3                   	ret    

f0103a12 <trap_init>:
{
f0103a12:	55                   	push   %ebp
f0103a13:	89 e5                	mov    %esp,%ebp
f0103a15:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_DIVIDE], 0, GD_KT, divide_handler, 0);
f0103a18:	b8 d4 45 10 f0       	mov    $0xf01045d4,%eax
f0103a1d:	66 a3 60 e2 2a f0    	mov    %ax,0xf02ae260
f0103a23:	66 c7 05 62 e2 2a f0 	movw   $0x8,0xf02ae262
f0103a2a:	08 00 
f0103a2c:	c6 05 64 e2 2a f0 00 	movb   $0x0,0xf02ae264
f0103a33:	c6 05 65 e2 2a f0 8e 	movb   $0x8e,0xf02ae265
f0103a3a:	c1 e8 10             	shr    $0x10,%eax
f0103a3d:	66 a3 66 e2 2a f0    	mov    %ax,0xf02ae266
	SETGATE(idt[T_DEBUG], 0, GD_KT, debug_handler, 0);
f0103a43:	b8 de 45 10 f0       	mov    $0xf01045de,%eax
f0103a48:	66 a3 68 e2 2a f0    	mov    %ax,0xf02ae268
f0103a4e:	66 c7 05 6a e2 2a f0 	movw   $0x8,0xf02ae26a
f0103a55:	08 00 
f0103a57:	c6 05 6c e2 2a f0 00 	movb   $0x0,0xf02ae26c
f0103a5e:	c6 05 6d e2 2a f0 8e 	movb   $0x8e,0xf02ae26d
f0103a65:	c1 e8 10             	shr    $0x10,%eax
f0103a68:	66 a3 6e e2 2a f0    	mov    %ax,0xf02ae26e
	SETGATE(idt[T_NMI], 0, GD_KT, nmi_handler, 0);
f0103a6e:	b8 e8 45 10 f0       	mov    $0xf01045e8,%eax
f0103a73:	66 a3 70 e2 2a f0    	mov    %ax,0xf02ae270
f0103a79:	66 c7 05 72 e2 2a f0 	movw   $0x8,0xf02ae272
f0103a80:	08 00 
f0103a82:	c6 05 74 e2 2a f0 00 	movb   $0x0,0xf02ae274
f0103a89:	c6 05 75 e2 2a f0 8e 	movb   $0x8e,0xf02ae275
f0103a90:	c1 e8 10             	shr    $0x10,%eax
f0103a93:	66 a3 76 e2 2a f0    	mov    %ax,0xf02ae276
	SETGATE(idt[T_BRKPT], 0, GD_KT, brkpt_handler, 3);
f0103a99:	b8 f2 45 10 f0       	mov    $0xf01045f2,%eax
f0103a9e:	66 a3 78 e2 2a f0    	mov    %ax,0xf02ae278
f0103aa4:	66 c7 05 7a e2 2a f0 	movw   $0x8,0xf02ae27a
f0103aab:	08 00 
f0103aad:	c6 05 7c e2 2a f0 00 	movb   $0x0,0xf02ae27c
f0103ab4:	c6 05 7d e2 2a f0 ee 	movb   $0xee,0xf02ae27d
f0103abb:	c1 e8 10             	shr    $0x10,%eax
f0103abe:	66 a3 7e e2 2a f0    	mov    %ax,0xf02ae27e
	SETGATE(idt[T_OFLOW], 0, GD_KT, oflow_handler, 0);
f0103ac4:	b8 fc 45 10 f0       	mov    $0xf01045fc,%eax
f0103ac9:	66 a3 80 e2 2a f0    	mov    %ax,0xf02ae280
f0103acf:	66 c7 05 82 e2 2a f0 	movw   $0x8,0xf02ae282
f0103ad6:	08 00 
f0103ad8:	c6 05 84 e2 2a f0 00 	movb   $0x0,0xf02ae284
f0103adf:	c6 05 85 e2 2a f0 8e 	movb   $0x8e,0xf02ae285
f0103ae6:	c1 e8 10             	shr    $0x10,%eax
f0103ae9:	66 a3 86 e2 2a f0    	mov    %ax,0xf02ae286
	SETGATE(idt[T_BOUND], 0, GD_KT, bound_handler, 0);
f0103aef:	b8 06 46 10 f0       	mov    $0xf0104606,%eax
f0103af4:	66 a3 88 e2 2a f0    	mov    %ax,0xf02ae288
f0103afa:	66 c7 05 8a e2 2a f0 	movw   $0x8,0xf02ae28a
f0103b01:	08 00 
f0103b03:	c6 05 8c e2 2a f0 00 	movb   $0x0,0xf02ae28c
f0103b0a:	c6 05 8d e2 2a f0 8e 	movb   $0x8e,0xf02ae28d
f0103b11:	c1 e8 10             	shr    $0x10,%eax
f0103b14:	66 a3 8e e2 2a f0    	mov    %ax,0xf02ae28e
	SETGATE(idt[T_ILLOP], 0, GD_KT, illop_handler, 0);
f0103b1a:	b8 10 46 10 f0       	mov    $0xf0104610,%eax
f0103b1f:	66 a3 90 e2 2a f0    	mov    %ax,0xf02ae290
f0103b25:	66 c7 05 92 e2 2a f0 	movw   $0x8,0xf02ae292
f0103b2c:	08 00 
f0103b2e:	c6 05 94 e2 2a f0 00 	movb   $0x0,0xf02ae294
f0103b35:	c6 05 95 e2 2a f0 8e 	movb   $0x8e,0xf02ae295
f0103b3c:	c1 e8 10             	shr    $0x10,%eax
f0103b3f:	66 a3 96 e2 2a f0    	mov    %ax,0xf02ae296
	SETGATE(idt[T_DEVICE], 0, GD_KT, device_handler, 0);
f0103b45:	b8 1a 46 10 f0       	mov    $0xf010461a,%eax
f0103b4a:	66 a3 98 e2 2a f0    	mov    %ax,0xf02ae298
f0103b50:	66 c7 05 9a e2 2a f0 	movw   $0x8,0xf02ae29a
f0103b57:	08 00 
f0103b59:	c6 05 9c e2 2a f0 00 	movb   $0x0,0xf02ae29c
f0103b60:	c6 05 9d e2 2a f0 8e 	movb   $0x8e,0xf02ae29d
f0103b67:	c1 e8 10             	shr    $0x10,%eax
f0103b6a:	66 a3 9e e2 2a f0    	mov    %ax,0xf02ae29e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, dblflt_handler, 0);
f0103b70:	b8 24 46 10 f0       	mov    $0xf0104624,%eax
f0103b75:	66 a3 a0 e2 2a f0    	mov    %ax,0xf02ae2a0
f0103b7b:	66 c7 05 a2 e2 2a f0 	movw   $0x8,0xf02ae2a2
f0103b82:	08 00 
f0103b84:	c6 05 a4 e2 2a f0 00 	movb   $0x0,0xf02ae2a4
f0103b8b:	c6 05 a5 e2 2a f0 8e 	movb   $0x8e,0xf02ae2a5
f0103b92:	c1 e8 10             	shr    $0x10,%eax
f0103b95:	66 a3 a6 e2 2a f0    	mov    %ax,0xf02ae2a6
	SETGATE(idt[T_TSS], 0, GD_KT, tss_handler, 0);
f0103b9b:	b8 2c 46 10 f0       	mov    $0xf010462c,%eax
f0103ba0:	66 a3 b0 e2 2a f0    	mov    %ax,0xf02ae2b0
f0103ba6:	66 c7 05 b2 e2 2a f0 	movw   $0x8,0xf02ae2b2
f0103bad:	08 00 
f0103baf:	c6 05 b4 e2 2a f0 00 	movb   $0x0,0xf02ae2b4
f0103bb6:	c6 05 b5 e2 2a f0 8e 	movb   $0x8e,0xf02ae2b5
f0103bbd:	c1 e8 10             	shr    $0x10,%eax
f0103bc0:	66 a3 b6 e2 2a f0    	mov    %ax,0xf02ae2b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, segnp_handler, 0);
f0103bc6:	b8 34 46 10 f0       	mov    $0xf0104634,%eax
f0103bcb:	66 a3 b8 e2 2a f0    	mov    %ax,0xf02ae2b8
f0103bd1:	66 c7 05 ba e2 2a f0 	movw   $0x8,0xf02ae2ba
f0103bd8:	08 00 
f0103bda:	c6 05 bc e2 2a f0 00 	movb   $0x0,0xf02ae2bc
f0103be1:	c6 05 bd e2 2a f0 8e 	movb   $0x8e,0xf02ae2bd
f0103be8:	c1 e8 10             	shr    $0x10,%eax
f0103beb:	66 a3 be e2 2a f0    	mov    %ax,0xf02ae2be
	SETGATE(idt[T_STACK], 0, GD_KT, stack_handler, 0);
f0103bf1:	b8 3c 46 10 f0       	mov    $0xf010463c,%eax
f0103bf6:	66 a3 c0 e2 2a f0    	mov    %ax,0xf02ae2c0
f0103bfc:	66 c7 05 c2 e2 2a f0 	movw   $0x8,0xf02ae2c2
f0103c03:	08 00 
f0103c05:	c6 05 c4 e2 2a f0 00 	movb   $0x0,0xf02ae2c4
f0103c0c:	c6 05 c5 e2 2a f0 8e 	movb   $0x8e,0xf02ae2c5
f0103c13:	c1 e8 10             	shr    $0x10,%eax
f0103c16:	66 a3 c6 e2 2a f0    	mov    %ax,0xf02ae2c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, gpflt_handler, 0);
f0103c1c:	b8 44 46 10 f0       	mov    $0xf0104644,%eax
f0103c21:	66 a3 c8 e2 2a f0    	mov    %ax,0xf02ae2c8
f0103c27:	66 c7 05 ca e2 2a f0 	movw   $0x8,0xf02ae2ca
f0103c2e:	08 00 
f0103c30:	c6 05 cc e2 2a f0 00 	movb   $0x0,0xf02ae2cc
f0103c37:	c6 05 cd e2 2a f0 8e 	movb   $0x8e,0xf02ae2cd
f0103c3e:	c1 e8 10             	shr    $0x10,%eax
f0103c41:	66 a3 ce e2 2a f0    	mov    %ax,0xf02ae2ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, pgflt_handler, 0);
f0103c47:	b8 4c 46 10 f0       	mov    $0xf010464c,%eax
f0103c4c:	66 a3 d0 e2 2a f0    	mov    %ax,0xf02ae2d0
f0103c52:	66 c7 05 d2 e2 2a f0 	movw   $0x8,0xf02ae2d2
f0103c59:	08 00 
f0103c5b:	c6 05 d4 e2 2a f0 00 	movb   $0x0,0xf02ae2d4
f0103c62:	c6 05 d5 e2 2a f0 8e 	movb   $0x8e,0xf02ae2d5
f0103c69:	c1 e8 10             	shr    $0x10,%eax
f0103c6c:	66 a3 d6 e2 2a f0    	mov    %ax,0xf02ae2d6
	SETGATE(idt[T_FPERR], 0, GD_KT, fperr_handler, 0);
f0103c72:	b8 50 46 10 f0       	mov    $0xf0104650,%eax
f0103c77:	66 a3 e0 e2 2a f0    	mov    %ax,0xf02ae2e0
f0103c7d:	66 c7 05 e2 e2 2a f0 	movw   $0x8,0xf02ae2e2
f0103c84:	08 00 
f0103c86:	c6 05 e4 e2 2a f0 00 	movb   $0x0,0xf02ae2e4
f0103c8d:	c6 05 e5 e2 2a f0 8e 	movb   $0x8e,0xf02ae2e5
f0103c94:	c1 e8 10             	shr    $0x10,%eax
f0103c97:	66 a3 e6 e2 2a f0    	mov    %ax,0xf02ae2e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, align_handler, 0);
f0103c9d:	b8 56 46 10 f0       	mov    $0xf0104656,%eax
f0103ca2:	66 a3 e8 e2 2a f0    	mov    %ax,0xf02ae2e8
f0103ca8:	66 c7 05 ea e2 2a f0 	movw   $0x8,0xf02ae2ea
f0103caf:	08 00 
f0103cb1:	c6 05 ec e2 2a f0 00 	movb   $0x0,0xf02ae2ec
f0103cb8:	c6 05 ed e2 2a f0 8e 	movb   $0x8e,0xf02ae2ed
f0103cbf:	c1 e8 10             	shr    $0x10,%eax
f0103cc2:	66 a3 ee e2 2a f0    	mov    %ax,0xf02ae2ee
	SETGATE(idt[T_MCHK], 0, GD_KT, mchk_handler, 0);
f0103cc8:	b8 5a 46 10 f0       	mov    $0xf010465a,%eax
f0103ccd:	66 a3 f0 e2 2a f0    	mov    %ax,0xf02ae2f0
f0103cd3:	66 c7 05 f2 e2 2a f0 	movw   $0x8,0xf02ae2f2
f0103cda:	08 00 
f0103cdc:	c6 05 f4 e2 2a f0 00 	movb   $0x0,0xf02ae2f4
f0103ce3:	c6 05 f5 e2 2a f0 8e 	movb   $0x8e,0xf02ae2f5
f0103cea:	c1 e8 10             	shr    $0x10,%eax
f0103ced:	66 a3 f6 e2 2a f0    	mov    %ax,0xf02ae2f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, simderr_handler, 0);
f0103cf3:	b8 60 46 10 f0       	mov    $0xf0104660,%eax
f0103cf8:	66 a3 f8 e2 2a f0    	mov    %ax,0xf02ae2f8
f0103cfe:	66 c7 05 fa e2 2a f0 	movw   $0x8,0xf02ae2fa
f0103d05:	08 00 
f0103d07:	c6 05 fc e2 2a f0 00 	movb   $0x0,0xf02ae2fc
f0103d0e:	c6 05 fd e2 2a f0 8e 	movb   $0x8e,0xf02ae2fd
f0103d15:	c1 e8 10             	shr    $0x10,%eax
f0103d18:	66 a3 fe e2 2a f0    	mov    %ax,0xf02ae2fe
	SETGATE(idt[T_SYSCALL], 0, GD_KT, syscall_handler, 3);
f0103d1e:	b8 66 46 10 f0       	mov    $0xf0104666,%eax
f0103d23:	66 a3 e0 e3 2a f0    	mov    %ax,0xf02ae3e0
f0103d29:	66 c7 05 e2 e3 2a f0 	movw   $0x8,0xf02ae3e2
f0103d30:	08 00 
f0103d32:	c6 05 e4 e3 2a f0 00 	movb   $0x0,0xf02ae3e4
f0103d39:	c6 05 e5 e3 2a f0 ee 	movb   $0xee,0xf02ae3e5
f0103d40:	c1 e8 10             	shr    $0x10,%eax
f0103d43:	66 a3 e6 e3 2a f0    	mov    %ax,0xf02ae3e6
	SETGATE(idt[IRQ_OFFSET + 0], 0, GD_KT, irq0_handler, 0);
f0103d49:	b8 6c 46 10 f0       	mov    $0xf010466c,%eax
f0103d4e:	66 a3 60 e3 2a f0    	mov    %ax,0xf02ae360
f0103d54:	66 c7 05 62 e3 2a f0 	movw   $0x8,0xf02ae362
f0103d5b:	08 00 
f0103d5d:	c6 05 64 e3 2a f0 00 	movb   $0x0,0xf02ae364
f0103d64:	c6 05 65 e3 2a f0 8e 	movb   $0x8e,0xf02ae365
f0103d6b:	c1 e8 10             	shr    $0x10,%eax
f0103d6e:	66 a3 66 e3 2a f0    	mov    %ax,0xf02ae366
	SETGATE(idt[IRQ_OFFSET + 1], 0, GD_KT, irq1_handler, 0);
f0103d74:	b8 72 46 10 f0       	mov    $0xf0104672,%eax
f0103d79:	66 a3 68 e3 2a f0    	mov    %ax,0xf02ae368
f0103d7f:	66 c7 05 6a e3 2a f0 	movw   $0x8,0xf02ae36a
f0103d86:	08 00 
f0103d88:	c6 05 6c e3 2a f0 00 	movb   $0x0,0xf02ae36c
f0103d8f:	c6 05 6d e3 2a f0 8e 	movb   $0x8e,0xf02ae36d
f0103d96:	c1 e8 10             	shr    $0x10,%eax
f0103d99:	66 a3 6e e3 2a f0    	mov    %ax,0xf02ae36e
	SETGATE(idt[IRQ_OFFSET + 2], 0, GD_KT, irq2_handler, 0);
f0103d9f:	b8 78 46 10 f0       	mov    $0xf0104678,%eax
f0103da4:	66 a3 70 e3 2a f0    	mov    %ax,0xf02ae370
f0103daa:	66 c7 05 72 e3 2a f0 	movw   $0x8,0xf02ae372
f0103db1:	08 00 
f0103db3:	c6 05 74 e3 2a f0 00 	movb   $0x0,0xf02ae374
f0103dba:	c6 05 75 e3 2a f0 8e 	movb   $0x8e,0xf02ae375
f0103dc1:	c1 e8 10             	shr    $0x10,%eax
f0103dc4:	66 a3 76 e3 2a f0    	mov    %ax,0xf02ae376
	SETGATE(idt[IRQ_OFFSET + 3], 0, GD_KT, irq3_handler, 0);
f0103dca:	b8 7e 46 10 f0       	mov    $0xf010467e,%eax
f0103dcf:	66 a3 78 e3 2a f0    	mov    %ax,0xf02ae378
f0103dd5:	66 c7 05 7a e3 2a f0 	movw   $0x8,0xf02ae37a
f0103ddc:	08 00 
f0103dde:	c6 05 7c e3 2a f0 00 	movb   $0x0,0xf02ae37c
f0103de5:	c6 05 7d e3 2a f0 8e 	movb   $0x8e,0xf02ae37d
f0103dec:	c1 e8 10             	shr    $0x10,%eax
f0103def:	66 a3 7e e3 2a f0    	mov    %ax,0xf02ae37e
	SETGATE(idt[IRQ_OFFSET + 4], 0, GD_KT, irq4_handler, 0);
f0103df5:	b8 84 46 10 f0       	mov    $0xf0104684,%eax
f0103dfa:	66 a3 80 e3 2a f0    	mov    %ax,0xf02ae380
f0103e00:	66 c7 05 82 e3 2a f0 	movw   $0x8,0xf02ae382
f0103e07:	08 00 
f0103e09:	c6 05 84 e3 2a f0 00 	movb   $0x0,0xf02ae384
f0103e10:	c6 05 85 e3 2a f0 8e 	movb   $0x8e,0xf02ae385
f0103e17:	c1 e8 10             	shr    $0x10,%eax
f0103e1a:	66 a3 86 e3 2a f0    	mov    %ax,0xf02ae386
	SETGATE(idt[IRQ_OFFSET + 5], 0, GD_KT, irq5_handler, 0);
f0103e20:	b8 8a 46 10 f0       	mov    $0xf010468a,%eax
f0103e25:	66 a3 88 e3 2a f0    	mov    %ax,0xf02ae388
f0103e2b:	66 c7 05 8a e3 2a f0 	movw   $0x8,0xf02ae38a
f0103e32:	08 00 
f0103e34:	c6 05 8c e3 2a f0 00 	movb   $0x0,0xf02ae38c
f0103e3b:	c6 05 8d e3 2a f0 8e 	movb   $0x8e,0xf02ae38d
f0103e42:	c1 e8 10             	shr    $0x10,%eax
f0103e45:	66 a3 8e e3 2a f0    	mov    %ax,0xf02ae38e
	SETGATE(idt[IRQ_OFFSET + 6], 0, GD_KT, irq6_handler, 0);
f0103e4b:	b8 90 46 10 f0       	mov    $0xf0104690,%eax
f0103e50:	66 a3 90 e3 2a f0    	mov    %ax,0xf02ae390
f0103e56:	66 c7 05 92 e3 2a f0 	movw   $0x8,0xf02ae392
f0103e5d:	08 00 
f0103e5f:	c6 05 94 e3 2a f0 00 	movb   $0x0,0xf02ae394
f0103e66:	c6 05 95 e3 2a f0 8e 	movb   $0x8e,0xf02ae395
f0103e6d:	c1 e8 10             	shr    $0x10,%eax
f0103e70:	66 a3 96 e3 2a f0    	mov    %ax,0xf02ae396
	SETGATE(idt[IRQ_OFFSET + 7], 0, GD_KT, irq7_handler, 0);
f0103e76:	b8 96 46 10 f0       	mov    $0xf0104696,%eax
f0103e7b:	66 a3 98 e3 2a f0    	mov    %ax,0xf02ae398
f0103e81:	66 c7 05 9a e3 2a f0 	movw   $0x8,0xf02ae39a
f0103e88:	08 00 
f0103e8a:	c6 05 9c e3 2a f0 00 	movb   $0x0,0xf02ae39c
f0103e91:	c6 05 9d e3 2a f0 8e 	movb   $0x8e,0xf02ae39d
f0103e98:	c1 e8 10             	shr    $0x10,%eax
f0103e9b:	66 a3 9e e3 2a f0    	mov    %ax,0xf02ae39e
	SETGATE(idt[IRQ_OFFSET + 8], 0, GD_KT, irq8_handler, 0);
f0103ea1:	b8 9c 46 10 f0       	mov    $0xf010469c,%eax
f0103ea6:	66 a3 a0 e3 2a f0    	mov    %ax,0xf02ae3a0
f0103eac:	66 c7 05 a2 e3 2a f0 	movw   $0x8,0xf02ae3a2
f0103eb3:	08 00 
f0103eb5:	c6 05 a4 e3 2a f0 00 	movb   $0x0,0xf02ae3a4
f0103ebc:	c6 05 a5 e3 2a f0 8e 	movb   $0x8e,0xf02ae3a5
f0103ec3:	c1 e8 10             	shr    $0x10,%eax
f0103ec6:	66 a3 a6 e3 2a f0    	mov    %ax,0xf02ae3a6
	SETGATE(idt[IRQ_OFFSET + 9], 0, GD_KT, irq9_handler, 0);
f0103ecc:	b8 a2 46 10 f0       	mov    $0xf01046a2,%eax
f0103ed1:	66 a3 a8 e3 2a f0    	mov    %ax,0xf02ae3a8
f0103ed7:	66 c7 05 aa e3 2a f0 	movw   $0x8,0xf02ae3aa
f0103ede:	08 00 
f0103ee0:	c6 05 ac e3 2a f0 00 	movb   $0x0,0xf02ae3ac
f0103ee7:	c6 05 ad e3 2a f0 8e 	movb   $0x8e,0xf02ae3ad
f0103eee:	c1 e8 10             	shr    $0x10,%eax
f0103ef1:	66 a3 ae e3 2a f0    	mov    %ax,0xf02ae3ae
	SETGATE(idt[IRQ_OFFSET + 10], 0, GD_KT, irq10_handler, 0);
f0103ef7:	b8 a8 46 10 f0       	mov    $0xf01046a8,%eax
f0103efc:	66 a3 b0 e3 2a f0    	mov    %ax,0xf02ae3b0
f0103f02:	66 c7 05 b2 e3 2a f0 	movw   $0x8,0xf02ae3b2
f0103f09:	08 00 
f0103f0b:	c6 05 b4 e3 2a f0 00 	movb   $0x0,0xf02ae3b4
f0103f12:	c6 05 b5 e3 2a f0 8e 	movb   $0x8e,0xf02ae3b5
f0103f19:	c1 e8 10             	shr    $0x10,%eax
f0103f1c:	66 a3 b6 e3 2a f0    	mov    %ax,0xf02ae3b6
	SETGATE(idt[IRQ_OFFSET + 11], 0, GD_KT, irq11_handler, 0);
f0103f22:	b8 ae 46 10 f0       	mov    $0xf01046ae,%eax
f0103f27:	66 a3 b8 e3 2a f0    	mov    %ax,0xf02ae3b8
f0103f2d:	66 c7 05 ba e3 2a f0 	movw   $0x8,0xf02ae3ba
f0103f34:	08 00 
f0103f36:	c6 05 bc e3 2a f0 00 	movb   $0x0,0xf02ae3bc
f0103f3d:	c6 05 bd e3 2a f0 8e 	movb   $0x8e,0xf02ae3bd
f0103f44:	c1 e8 10             	shr    $0x10,%eax
f0103f47:	66 a3 be e3 2a f0    	mov    %ax,0xf02ae3be
	SETGATE(idt[IRQ_OFFSET + 12], 0, GD_KT, irq12_handler, 0);
f0103f4d:	b8 b4 46 10 f0       	mov    $0xf01046b4,%eax
f0103f52:	66 a3 c0 e3 2a f0    	mov    %ax,0xf02ae3c0
f0103f58:	66 c7 05 c2 e3 2a f0 	movw   $0x8,0xf02ae3c2
f0103f5f:	08 00 
f0103f61:	c6 05 c4 e3 2a f0 00 	movb   $0x0,0xf02ae3c4
f0103f68:	c6 05 c5 e3 2a f0 8e 	movb   $0x8e,0xf02ae3c5
f0103f6f:	c1 e8 10             	shr    $0x10,%eax
f0103f72:	66 a3 c6 e3 2a f0    	mov    %ax,0xf02ae3c6
	SETGATE(idt[IRQ_OFFSET + 13], 0, GD_KT, irq13_handler, 0);
f0103f78:	b8 ba 46 10 f0       	mov    $0xf01046ba,%eax
f0103f7d:	66 a3 c8 e3 2a f0    	mov    %ax,0xf02ae3c8
f0103f83:	66 c7 05 ca e3 2a f0 	movw   $0x8,0xf02ae3ca
f0103f8a:	08 00 
f0103f8c:	c6 05 cc e3 2a f0 00 	movb   $0x0,0xf02ae3cc
f0103f93:	c6 05 cd e3 2a f0 8e 	movb   $0x8e,0xf02ae3cd
f0103f9a:	c1 e8 10             	shr    $0x10,%eax
f0103f9d:	66 a3 ce e3 2a f0    	mov    %ax,0xf02ae3ce
	SETGATE(idt[IRQ_OFFSET + 14], 0, GD_KT, irq14_handler, 0);
f0103fa3:	b8 c0 46 10 f0       	mov    $0xf01046c0,%eax
f0103fa8:	66 a3 d0 e3 2a f0    	mov    %ax,0xf02ae3d0
f0103fae:	66 c7 05 d2 e3 2a f0 	movw   $0x8,0xf02ae3d2
f0103fb5:	08 00 
f0103fb7:	c6 05 d4 e3 2a f0 00 	movb   $0x0,0xf02ae3d4
f0103fbe:	c6 05 d5 e3 2a f0 8e 	movb   $0x8e,0xf02ae3d5
f0103fc5:	c1 e8 10             	shr    $0x10,%eax
f0103fc8:	66 a3 d6 e3 2a f0    	mov    %ax,0xf02ae3d6
	SETGATE(idt[IRQ_OFFSET + 15], 0, GD_KT, irq15_handler, 0);
f0103fce:	b8 c6 46 10 f0       	mov    $0xf01046c6,%eax
f0103fd3:	66 a3 d8 e3 2a f0    	mov    %ax,0xf02ae3d8
f0103fd9:	66 c7 05 da e3 2a f0 	movw   $0x8,0xf02ae3da
f0103fe0:	08 00 
f0103fe2:	c6 05 dc e3 2a f0 00 	movb   $0x0,0xf02ae3dc
f0103fe9:	c6 05 dd e3 2a f0 8e 	movb   $0x8e,0xf02ae3dd
f0103ff0:	c1 e8 10             	shr    $0x10,%eax
f0103ff3:	66 a3 de e3 2a f0    	mov    %ax,0xf02ae3de
	trap_init_percpu();
f0103ff9:	e8 46 f9 ff ff       	call   f0103944 <trap_init_percpu>
}
f0103ffe:	c9                   	leave  
f0103fff:	c3                   	ret    

f0104000 <print_regs>:
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
	}
}

void print_regs(struct PushRegs *regs)
{
f0104000:	55                   	push   %ebp
f0104001:	89 e5                	mov    %esp,%ebp
f0104003:	53                   	push   %ebx
f0104004:	83 ec 0c             	sub    $0xc,%esp
f0104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f010400a:	ff 33                	pushl  (%ebx)
f010400c:	68 39 80 10 f0       	push   $0xf0108039
f0104011:	e8 1a f9 ff ff       	call   f0103930 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104016:	83 c4 08             	add    $0x8,%esp
f0104019:	ff 73 04             	pushl  0x4(%ebx)
f010401c:	68 48 80 10 f0       	push   $0xf0108048
f0104021:	e8 0a f9 ff ff       	call   f0103930 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104026:	83 c4 08             	add    $0x8,%esp
f0104029:	ff 73 08             	pushl  0x8(%ebx)
f010402c:	68 57 80 10 f0       	push   $0xf0108057
f0104031:	e8 fa f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104036:	83 c4 08             	add    $0x8,%esp
f0104039:	ff 73 0c             	pushl  0xc(%ebx)
f010403c:	68 66 80 10 f0       	push   $0xf0108066
f0104041:	e8 ea f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104046:	83 c4 08             	add    $0x8,%esp
f0104049:	ff 73 10             	pushl  0x10(%ebx)
f010404c:	68 75 80 10 f0       	push   $0xf0108075
f0104051:	e8 da f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104056:	83 c4 08             	add    $0x8,%esp
f0104059:	ff 73 14             	pushl  0x14(%ebx)
f010405c:	68 84 80 10 f0       	push   $0xf0108084
f0104061:	e8 ca f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104066:	83 c4 08             	add    $0x8,%esp
f0104069:	ff 73 18             	pushl  0x18(%ebx)
f010406c:	68 93 80 10 f0       	push   $0xf0108093
f0104071:	e8 ba f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0104076:	83 c4 08             	add    $0x8,%esp
f0104079:	ff 73 1c             	pushl  0x1c(%ebx)
f010407c:	68 a2 80 10 f0       	push   $0xf01080a2
f0104081:	e8 aa f8 ff ff       	call   f0103930 <cprintf>
}
f0104086:	83 c4 10             	add    $0x10,%esp
f0104089:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010408c:	c9                   	leave  
f010408d:	c3                   	ret    

f010408e <print_trapframe>:
{
f010408e:	55                   	push   %ebp
f010408f:	89 e5                	mov    %esp,%ebp
f0104091:	56                   	push   %esi
f0104092:	53                   	push   %ebx
f0104093:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104096:	e8 38 20 00 00       	call   f01060d3 <cpunum>
f010409b:	83 ec 04             	sub    $0x4,%esp
f010409e:	50                   	push   %eax
f010409f:	53                   	push   %ebx
f01040a0:	68 06 81 10 f0       	push   $0xf0108106
f01040a5:	e8 86 f8 ff ff       	call   f0103930 <cprintf>
	print_regs(&tf->tf_regs);
f01040aa:	89 1c 24             	mov    %ebx,(%esp)
f01040ad:	e8 4e ff ff ff       	call   f0104000 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01040b2:	83 c4 08             	add    $0x8,%esp
f01040b5:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01040b9:	50                   	push   %eax
f01040ba:	68 24 81 10 f0       	push   $0xf0108124
f01040bf:	e8 6c f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01040c4:	83 c4 08             	add    $0x8,%esp
f01040c7:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01040cb:	50                   	push   %eax
f01040cc:	68 37 81 10 f0       	push   $0xf0108137
f01040d1:	e8 5a f8 ff ff       	call   f0103930 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01040d6:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f01040d9:	83 c4 10             	add    $0x10,%esp
f01040dc:	83 f8 13             	cmp    $0x13,%eax
f01040df:	76 1f                	jbe    f0104100 <print_trapframe+0x72>
		return "System call";
f01040e1:	ba b1 80 10 f0       	mov    $0xf01080b1,%edx
	if (trapno == T_SYSCALL)
f01040e6:	83 f8 30             	cmp    $0x30,%eax
f01040e9:	74 1c                	je     f0104107 <print_trapframe+0x79>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01040eb:	8d 50 e0             	lea    -0x20(%eax),%edx
	return "(unknown trap)";
f01040ee:	83 fa 10             	cmp    $0x10,%edx
f01040f1:	ba bd 80 10 f0       	mov    $0xf01080bd,%edx
f01040f6:	b9 d0 80 10 f0       	mov    $0xf01080d0,%ecx
f01040fb:	0f 43 d1             	cmovae %ecx,%edx
f01040fe:	eb 07                	jmp    f0104107 <print_trapframe+0x79>
		return excnames[trapno];
f0104100:	8b 14 85 e0 83 10 f0 	mov    -0xfef7c20(,%eax,4),%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104107:	83 ec 04             	sub    $0x4,%esp
f010410a:	52                   	push   %edx
f010410b:	50                   	push   %eax
f010410c:	68 4a 81 10 f0       	push   $0xf010814a
f0104111:	e8 1a f8 ff ff       	call   f0103930 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104116:	83 c4 10             	add    $0x10,%esp
f0104119:	39 1d 60 ea 2a f0    	cmp    %ebx,0xf02aea60
f010411f:	0f 84 a6 00 00 00    	je     f01041cb <print_trapframe+0x13d>
	cprintf("  err  0x%08x", tf->tf_err);
f0104125:	83 ec 08             	sub    $0x8,%esp
f0104128:	ff 73 2c             	pushl  0x2c(%ebx)
f010412b:	68 6b 81 10 f0       	push   $0xf010816b
f0104130:	e8 fb f7 ff ff       	call   f0103930 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f0104135:	83 c4 10             	add    $0x10,%esp
f0104138:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f010413c:	0f 85 ac 00 00 00    	jne    f01041ee <print_trapframe+0x160>
				tf->tf_err & 1 ? "protection" : "not-present");
f0104142:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104145:	89 c2                	mov    %eax,%edx
f0104147:	83 e2 01             	and    $0x1,%edx
f010414a:	b9 df 80 10 f0       	mov    $0xf01080df,%ecx
f010414f:	ba ea 80 10 f0       	mov    $0xf01080ea,%edx
f0104154:	0f 44 ca             	cmove  %edx,%ecx
f0104157:	89 c2                	mov    %eax,%edx
f0104159:	83 e2 02             	and    $0x2,%edx
f010415c:	be f6 80 10 f0       	mov    $0xf01080f6,%esi
f0104161:	ba fc 80 10 f0       	mov    $0xf01080fc,%edx
f0104166:	0f 45 d6             	cmovne %esi,%edx
f0104169:	83 e0 04             	and    $0x4,%eax
f010416c:	b8 01 81 10 f0       	mov    $0xf0108101,%eax
f0104171:	be 36 82 10 f0       	mov    $0xf0108236,%esi
f0104176:	0f 44 c6             	cmove  %esi,%eax
f0104179:	51                   	push   %ecx
f010417a:	52                   	push   %edx
f010417b:	50                   	push   %eax
f010417c:	68 79 81 10 f0       	push   $0xf0108179
f0104181:	e8 aa f7 ff ff       	call   f0103930 <cprintf>
f0104186:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104189:	83 ec 08             	sub    $0x8,%esp
f010418c:	ff 73 30             	pushl  0x30(%ebx)
f010418f:	68 88 81 10 f0       	push   $0xf0108188
f0104194:	e8 97 f7 ff ff       	call   f0103930 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104199:	83 c4 08             	add    $0x8,%esp
f010419c:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01041a0:	50                   	push   %eax
f01041a1:	68 97 81 10 f0       	push   $0xf0108197
f01041a6:	e8 85 f7 ff ff       	call   f0103930 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01041ab:	83 c4 08             	add    $0x8,%esp
f01041ae:	ff 73 38             	pushl  0x38(%ebx)
f01041b1:	68 aa 81 10 f0       	push   $0xf01081aa
f01041b6:	e8 75 f7 ff ff       	call   f0103930 <cprintf>
	if ((tf->tf_cs & 3) != 0)
f01041bb:	83 c4 10             	add    $0x10,%esp
f01041be:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01041c2:	75 3c                	jne    f0104200 <print_trapframe+0x172>
}
f01041c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01041c7:	5b                   	pop    %ebx
f01041c8:	5e                   	pop    %esi
f01041c9:	5d                   	pop    %ebp
f01041ca:	c3                   	ret    
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01041cb:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01041cf:	0f 85 50 ff ff ff    	jne    f0104125 <print_trapframe+0x97>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01041d5:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01041d8:	83 ec 08             	sub    $0x8,%esp
f01041db:	50                   	push   %eax
f01041dc:	68 5c 81 10 f0       	push   $0xf010815c
f01041e1:	e8 4a f7 ff ff       	call   f0103930 <cprintf>
f01041e6:	83 c4 10             	add    $0x10,%esp
f01041e9:	e9 37 ff ff ff       	jmp    f0104125 <print_trapframe+0x97>
		cprintf("\n");
f01041ee:	83 ec 0c             	sub    $0xc,%esp
f01041f1:	68 1d 75 10 f0       	push   $0xf010751d
f01041f6:	e8 35 f7 ff ff       	call   f0103930 <cprintf>
f01041fb:	83 c4 10             	add    $0x10,%esp
f01041fe:	eb 89                	jmp    f0104189 <print_trapframe+0xfb>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104200:	83 ec 08             	sub    $0x8,%esp
f0104203:	ff 73 3c             	pushl  0x3c(%ebx)
f0104206:	68 b9 81 10 f0       	push   $0xf01081b9
f010420b:	e8 20 f7 ff ff       	call   f0103930 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104210:	83 c4 08             	add    $0x8,%esp
f0104213:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104217:	50                   	push   %eax
f0104218:	68 c8 81 10 f0       	push   $0xf01081c8
f010421d:	e8 0e f7 ff ff       	call   f0103930 <cprintf>
f0104222:	83 c4 10             	add    $0x10,%esp
}
f0104225:	eb 9d                	jmp    f01041c4 <print_trapframe+0x136>

f0104227 <page_fault_handler>:
	else
		sched_yield();
}

void page_fault_handler(struct Trapframe *tf)
{
f0104227:	55                   	push   %ebp
f0104228:	89 e5                	mov    %esp,%ebp
f010422a:	57                   	push   %edi
f010422b:	56                   	push   %esi
f010422c:	53                   	push   %ebx
f010422d:	83 ec 0c             	sub    $0xc,%esp
f0104230:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104233:	0f 20 d6             	mov    %cr2,%esi
	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	// LAB 3: Your code here.
	if ((tf->tf_cs & 3) == 0)
f0104236:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010423a:	74 5d                	je     f0104299 <page_fault_handler+0x72>
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
	struct UTrapframe *utf;
	if (curenv->env_pgfault_upcall) //判断
f010423c:	e8 92 1e 00 00       	call   f01060d3 <cpunum>
f0104241:	6b c0 74             	imul   $0x74,%eax,%eax
f0104244:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f010424a:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010424e:	75 5e                	jne    f01042ae <page_fault_handler+0x87>
		env_run(curenv);
	}
	else
	{
		// Destroy the environment that caused the fault.
		cprintf("[%08x] user fault va %08x ip %08x\n",
f0104250:	8b 7b 30             	mov    0x30(%ebx),%edi
				curenv->env_id, fault_va, tf->tf_eip);
f0104253:	e8 7b 1e 00 00       	call   f01060d3 <cpunum>
		cprintf("[%08x] user fault va %08x ip %08x\n",
f0104258:	57                   	push   %edi
f0104259:	56                   	push   %esi
				curenv->env_id, fault_va, tf->tf_eip);
f010425a:	6b c0 74             	imul   $0x74,%eax,%eax
		cprintf("[%08x] user fault va %08x ip %08x\n",
f010425d:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104263:	ff 70 48             	pushl  0x48(%eax)
f0104266:	68 b0 83 10 f0       	push   $0xf01083b0
f010426b:	e8 c0 f6 ff ff       	call   f0103930 <cprintf>
		print_trapframe(tf);
f0104270:	89 1c 24             	mov    %ebx,(%esp)
f0104273:	e8 16 fe ff ff       	call   f010408e <print_trapframe>
		env_destroy(curenv);
f0104278:	e8 56 1e 00 00       	call   f01060d3 <cpunum>
f010427d:	83 c4 04             	add    $0x4,%esp
f0104280:	6b c0 74             	imul   $0x74,%eax,%eax
f0104283:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f0104289:	e8 c7 f3 ff ff       	call   f0103655 <env_destroy>
	}
}
f010428e:	83 c4 10             	add    $0x10,%esp
f0104291:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104294:	5b                   	pop    %ebx
f0104295:	5e                   	pop    %esi
f0104296:	5f                   	pop    %edi
f0104297:	5d                   	pop    %ebp
f0104298:	c3                   	ret    
		panic("page_falut in kernel mode, fault address %d\n", fault_va);
f0104299:	56                   	push   %esi
f010429a:	68 80 83 10 f0       	push   $0xf0108380
f010429f:	68 84 01 00 00       	push   $0x184
f01042a4:	68 db 81 10 f0       	push   $0xf01081db
f01042a9:	e8 92 bd ff ff       	call   f0100040 <_panic>
		if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP)
f01042ae:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01042b1:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
			utf = (struct UTrapframe *)(UXSTACKTOP - sizeof(struct UTrapframe));
f01042b7:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
		if (tf->tf_esp >= UXSTACKTOP - PGSIZE && tf->tf_esp < UXSTACKTOP)
f01042bc:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01042c2:	77 05                	ja     f01042c9 <page_fault_handler+0xa2>
			utf = (struct UTrapframe *)(tf->tf_esp - sizeof(struct UTrapframe) - 4);
f01042c4:	83 e8 38             	sub    $0x38,%eax
f01042c7:	89 c7                	mov    %eax,%edi
		user_mem_assert(curenv, (const void *)utf, sizeof(struct UTrapframe), PTE_P | PTE_W | PTE_U);
f01042c9:	e8 05 1e 00 00       	call   f01060d3 <cpunum>
f01042ce:	6a 07                	push   $0x7
f01042d0:	6a 34                	push   $0x34
f01042d2:	57                   	push   %edi
f01042d3:	6b c0 74             	imul   $0x74,%eax,%eax
f01042d6:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f01042dc:	e8 8f ec ff ff       	call   f0102f70 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f01042e1:	89 fa                	mov    %edi,%edx
f01042e3:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f01042e5:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01042e8:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_err = tf->tf_trapno;
f01042eb:	8b 43 28             	mov    0x28(%ebx),%eax
f01042ee:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f01042f1:	8d 7f 08             	lea    0x8(%edi),%edi
f01042f4:	b9 08 00 00 00       	mov    $0x8,%ecx
f01042f9:	89 de                	mov    %ebx,%esi
f01042fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eflags = tf->tf_eflags;
f01042fd:	8b 43 38             	mov    0x38(%ebx),%eax
f0104300:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_eip = tf->tf_eip;
f0104303:	8b 43 30             	mov    0x30(%ebx),%eax
f0104306:	89 d7                	mov    %edx,%edi
f0104308:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_esp = tf->tf_esp;
f010430b:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010430e:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uint32_t)curenv->env_pgfault_upcall;
f0104311:	e8 bd 1d 00 00       	call   f01060d3 <cpunum>
f0104316:	6b c0 74             	imul   $0x74,%eax,%eax
f0104319:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f010431f:	8b 58 64             	mov    0x64(%eax),%ebx
f0104322:	e8 ac 1d 00 00       	call   f01060d3 <cpunum>
f0104327:	6b c0 74             	imul   $0x74,%eax,%eax
f010432a:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104330:	89 58 30             	mov    %ebx,0x30(%eax)
		curenv->env_tf.tf_esp = (uint32_t)utf;
f0104333:	e8 9b 1d 00 00       	call   f01060d3 <cpunum>
f0104338:	6b c0 74             	imul   $0x74,%eax,%eax
f010433b:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104341:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f0104344:	e8 8a 1d 00 00       	call   f01060d3 <cpunum>
f0104349:	83 c4 04             	add    $0x4,%esp
f010434c:	6b c0 74             	imul   $0x74,%eax,%eax
f010434f:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f0104355:	e8 9a f3 ff ff       	call   f01036f4 <env_run>

f010435a <trap>:
{
f010435a:	55                   	push   %ebp
f010435b:	89 e5                	mov    %esp,%ebp
f010435d:	57                   	push   %edi
f010435e:	56                   	push   %esi
f010435f:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::
f0104362:	fc                   	cld    
	if (panicstr)
f0104363:	83 3d 98 ee 2a f0 00 	cmpl   $0x0,0xf02aee98
f010436a:	74 01                	je     f010436d <trap+0x13>
		asm volatile("hlt");
f010436c:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f010436d:	e8 61 1d 00 00       	call   f01060d3 <cpunum>
f0104372:	6b d0 74             	imul   $0x74,%eax,%edx
f0104375:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104378:	b8 01 00 00 00       	mov    $0x1,%eax
f010437d:	f0 87 82 20 f0 2a f0 	lock xchg %eax,-0xfd50fe0(%edx)
f0104384:	83 f8 02             	cmp    $0x2,%eax
f0104387:	0f 84 c5 00 00 00    	je     f0104452 <trap+0xf8>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010438d:	9c                   	pushf  
f010438e:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f010438f:	f6 c4 02             	test   $0x2,%ah
f0104392:	0f 85 cf 00 00 00    	jne    f0104467 <trap+0x10d>
	if ((tf->tf_cs & 3) == 3)
f0104398:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010439c:	83 e0 03             	and    $0x3,%eax
f010439f:	66 83 f8 03          	cmp    $0x3,%ax
f01043a3:	0f 84 d7 00 00 00    	je     f0104480 <trap+0x126>
	last_tf = tf;
f01043a9:	89 35 60 ea 2a f0    	mov    %esi,0xf02aea60
	if (tf->tf_trapno == T_PGFLT)
f01043af:	8b 46 28             	mov    0x28(%esi),%eax
f01043b2:	83 f8 0e             	cmp    $0xe,%eax
f01043b5:	0f 84 6a 01 00 00    	je     f0104525 <trap+0x1cb>
	if (tf->tf_trapno == T_BRKPT)
f01043bb:	83 f8 03             	cmp    $0x3,%eax
f01043be:	0f 84 72 01 00 00    	je     f0104536 <trap+0x1dc>
	if (tf->tf_trapno == T_SYSCALL)
f01043c4:	8b 46 28             	mov    0x28(%esi),%eax
f01043c7:	83 f8 30             	cmp    $0x30,%eax
f01043ca:	0f 84 77 01 00 00    	je     f0104547 <trap+0x1ed>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS)
f01043d0:	83 f8 27             	cmp    $0x27,%eax
f01043d3:	0f 84 92 01 00 00    	je     f010456b <trap+0x211>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER)
f01043d9:	83 f8 20             	cmp    $0x20,%eax
f01043dc:	0f 84 a6 01 00 00    	je     f0104588 <trap+0x22e>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD)
f01043e2:	83 f8 21             	cmp    $0x21,%eax
f01043e5:	0f 84 a7 01 00 00    	je     f0104592 <trap+0x238>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL)
f01043eb:	83 f8 24             	cmp    $0x24,%eax
f01043ee:	0f 84 a8 01 00 00    	je     f010459c <trap+0x242>
	print_trapframe(tf);
f01043f4:	83 ec 0c             	sub    $0xc,%esp
f01043f7:	56                   	push   %esi
f01043f8:	e8 91 fc ff ff       	call   f010408e <print_trapframe>
	if (tf->tf_cs == GD_KT)
f01043fd:	83 c4 10             	add    $0x10,%esp
f0104400:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104405:	0f 84 9b 01 00 00    	je     f01045a6 <trap+0x24c>
		env_destroy(curenv);
f010440b:	e8 c3 1c 00 00       	call   f01060d3 <cpunum>
f0104410:	83 ec 0c             	sub    $0xc,%esp
f0104413:	6b c0 74             	imul   $0x74,%eax,%eax
f0104416:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f010441c:	e8 34 f2 ff ff       	call   f0103655 <env_destroy>
f0104421:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104424:	e8 aa 1c 00 00       	call   f01060d3 <cpunum>
f0104429:	6b c0 74             	imul   $0x74,%eax,%eax
f010442c:	83 b8 28 f0 2a f0 00 	cmpl   $0x0,-0xfd50fd8(%eax)
f0104433:	74 18                	je     f010444d <trap+0xf3>
f0104435:	e8 99 1c 00 00       	call   f01060d3 <cpunum>
f010443a:	6b c0 74             	imul   $0x74,%eax,%eax
f010443d:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104443:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104447:	0f 84 70 01 00 00    	je     f01045bd <trap+0x263>
		sched_yield();
f010444d:	e8 5e 03 00 00       	call   f01047b0 <sched_yield>
	spin_lock(&kernel_lock);
f0104452:	83 ec 0c             	sub    $0xc,%esp
f0104455:	68 c0 43 12 f0       	push   $0xf01243c0
f010445a:	e8 e4 1e 00 00       	call   f0106343 <spin_lock>
f010445f:	83 c4 10             	add    $0x10,%esp
f0104462:	e9 26 ff ff ff       	jmp    f010438d <trap+0x33>
	assert(!(read_eflags() & FL_IF));
f0104467:	68 e7 81 10 f0       	push   $0xf01081e7
f010446c:	68 ba 72 10 f0       	push   $0xf01072ba
f0104471:	68 4f 01 00 00       	push   $0x14f
f0104476:	68 db 81 10 f0       	push   $0xf01081db
f010447b:	e8 c0 bb ff ff       	call   f0100040 <_panic>
f0104480:	83 ec 0c             	sub    $0xc,%esp
f0104483:	68 c0 43 12 f0       	push   $0xf01243c0
f0104488:	e8 b6 1e 00 00       	call   f0106343 <spin_lock>
		assert(curenv);
f010448d:	e8 41 1c 00 00       	call   f01060d3 <cpunum>
f0104492:	6b c0 74             	imul   $0x74,%eax,%eax
f0104495:	83 c4 10             	add    $0x10,%esp
f0104498:	83 b8 28 f0 2a f0 00 	cmpl   $0x0,-0xfd50fd8(%eax)
f010449f:	74 3e                	je     f01044df <trap+0x185>
		if (curenv->env_status == ENV_DYING)
f01044a1:	e8 2d 1c 00 00       	call   f01060d3 <cpunum>
f01044a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01044a9:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f01044af:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01044b3:	74 43                	je     f01044f8 <trap+0x19e>
		curenv->env_tf = *tf;
f01044b5:	e8 19 1c 00 00       	call   f01060d3 <cpunum>
f01044ba:	6b c0 74             	imul   $0x74,%eax,%eax
f01044bd:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f01044c3:	b9 11 00 00 00       	mov    $0x11,%ecx
f01044c8:	89 c7                	mov    %eax,%edi
f01044ca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f01044cc:	e8 02 1c 00 00       	call   f01060d3 <cpunum>
f01044d1:	6b c0 74             	imul   $0x74,%eax,%eax
f01044d4:	8b b0 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%esi
f01044da:	e9 ca fe ff ff       	jmp    f01043a9 <trap+0x4f>
		assert(curenv);
f01044df:	68 00 82 10 f0       	push   $0xf0108200
f01044e4:	68 ba 72 10 f0       	push   $0xf01072ba
f01044e9:	68 58 01 00 00       	push   $0x158
f01044ee:	68 db 81 10 f0       	push   $0xf01081db
f01044f3:	e8 48 bb ff ff       	call   f0100040 <_panic>
			env_free(curenv);
f01044f8:	e8 d6 1b 00 00       	call   f01060d3 <cpunum>
f01044fd:	83 ec 0c             	sub    $0xc,%esp
f0104500:	6b c0 74             	imul   $0x74,%eax,%eax
f0104503:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f0104509:	e8 59 ef ff ff       	call   f0103467 <env_free>
			curenv = NULL;
f010450e:	e8 c0 1b 00 00       	call   f01060d3 <cpunum>
f0104513:	6b c0 74             	imul   $0x74,%eax,%eax
f0104516:	c7 80 28 f0 2a f0 00 	movl   $0x0,-0xfd50fd8(%eax)
f010451d:	00 00 00 
			sched_yield();
f0104520:	e8 8b 02 00 00       	call   f01047b0 <sched_yield>
		page_fault_handler(tf);
f0104525:	83 ec 0c             	sub    $0xc,%esp
f0104528:	56                   	push   %esi
f0104529:	e8 f9 fc ff ff       	call   f0104227 <page_fault_handler>
f010452e:	83 c4 10             	add    $0x10,%esp
f0104531:	e9 ee fe ff ff       	jmp    f0104424 <trap+0xca>
		monitor(tf);
f0104536:	83 ec 0c             	sub    $0xc,%esp
f0104539:	56                   	push   %esi
f010453a:	e8 39 c4 ff ff       	call   f0100978 <monitor>
f010453f:	83 c4 10             	add    $0x10,%esp
f0104542:	e9 7d fe ff ff       	jmp    f01043c4 <trap+0x6a>
		tf->tf_regs.reg_eax = syscall(regs.reg_eax, regs.reg_edx,
f0104547:	83 ec 08             	sub    $0x8,%esp
f010454a:	ff 76 04             	pushl  0x4(%esi)
f010454d:	ff 36                	pushl  (%esi)
f010454f:	ff 76 10             	pushl  0x10(%esi)
f0104552:	ff 76 18             	pushl  0x18(%esi)
f0104555:	ff 76 14             	pushl  0x14(%esi)
f0104558:	ff 76 1c             	pushl  0x1c(%esi)
f010455b:	e8 ec 02 00 00       	call   f010484c <syscall>
f0104560:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104563:	83 c4 20             	add    $0x20,%esp
f0104566:	e9 b9 fe ff ff       	jmp    f0104424 <trap+0xca>
		cprintf("Spurious interrupt on irq 7\n");
f010456b:	83 ec 0c             	sub    $0xc,%esp
f010456e:	68 07 82 10 f0       	push   $0xf0108207
f0104573:	e8 b8 f3 ff ff       	call   f0103930 <cprintf>
		print_trapframe(tf);
f0104578:	89 34 24             	mov    %esi,(%esp)
f010457b:	e8 0e fb ff ff       	call   f010408e <print_trapframe>
f0104580:	83 c4 10             	add    $0x10,%esp
f0104583:	e9 9c fe ff ff       	jmp    f0104424 <trap+0xca>
		lapic_eoi();
f0104588:	e8 92 1c 00 00       	call   f010621f <lapic_eoi>
		sched_yield();
f010458d:	e8 1e 02 00 00       	call   f01047b0 <sched_yield>
		kbd_intr();
f0104592:	e8 7d c0 ff ff       	call   f0100614 <kbd_intr>
f0104597:	e9 88 fe ff ff       	jmp    f0104424 <trap+0xca>
		serial_intr();
f010459c:	e8 56 c0 ff ff       	call   f01005f7 <serial_intr>
f01045a1:	e9 7e fe ff ff       	jmp    f0104424 <trap+0xca>
		panic("unhandled trap in kernel");
f01045a6:	83 ec 04             	sub    $0x4,%esp
f01045a9:	68 24 82 10 f0       	push   $0xf0108224
f01045ae:	68 34 01 00 00       	push   $0x134
f01045b3:	68 db 81 10 f0       	push   $0xf01081db
f01045b8:	e8 83 ba ff ff       	call   f0100040 <_panic>
		env_run(curenv);
f01045bd:	e8 11 1b 00 00       	call   f01060d3 <cpunum>
f01045c2:	83 ec 0c             	sub    $0xc,%esp
f01045c5:	6b c0 74             	imul   $0x74,%eax,%eax
f01045c8:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f01045ce:	e8 21 f1 ff ff       	call   f01036f4 <env_run>
f01045d3:	90                   	nop

f01045d4 <divide_handler>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(divide_handler,T_DIVIDE)
f01045d4:	6a 00                	push   $0x0
f01045d6:	6a 00                	push   $0x0
f01045d8:	e9 ef 00 00 00       	jmp    f01046cc <_alltraps>
f01045dd:	90                   	nop

f01045de <debug_handler>:
TRAPHANDLER_NOEC(debug_handler,T_DEBUG)
f01045de:	6a 00                	push   $0x0
f01045e0:	6a 01                	push   $0x1
f01045e2:	e9 e5 00 00 00       	jmp    f01046cc <_alltraps>
f01045e7:	90                   	nop

f01045e8 <nmi_handler>:
TRAPHANDLER_NOEC(nmi_handler,T_NMI)
f01045e8:	6a 00                	push   $0x0
f01045ea:	6a 02                	push   $0x2
f01045ec:	e9 db 00 00 00       	jmp    f01046cc <_alltraps>
f01045f1:	90                   	nop

f01045f2 <brkpt_handler>:
TRAPHANDLER_NOEC(brkpt_handler,T_BRKPT)
f01045f2:	6a 00                	push   $0x0
f01045f4:	6a 03                	push   $0x3
f01045f6:	e9 d1 00 00 00       	jmp    f01046cc <_alltraps>
f01045fb:	90                   	nop

f01045fc <oflow_handler>:
TRAPHANDLER_NOEC(oflow_handler,T_OFLOW)
f01045fc:	6a 00                	push   $0x0
f01045fe:	6a 04                	push   $0x4
f0104600:	e9 c7 00 00 00       	jmp    f01046cc <_alltraps>
f0104605:	90                   	nop

f0104606 <bound_handler>:
TRAPHANDLER_NOEC(bound_handler,T_BOUND)
f0104606:	6a 00                	push   $0x0
f0104608:	6a 05                	push   $0x5
f010460a:	e9 bd 00 00 00       	jmp    f01046cc <_alltraps>
f010460f:	90                   	nop

f0104610 <illop_handler>:
TRAPHANDLER_NOEC(illop_handler,T_ILLOP)
f0104610:	6a 00                	push   $0x0
f0104612:	6a 06                	push   $0x6
f0104614:	e9 b3 00 00 00       	jmp    f01046cc <_alltraps>
f0104619:	90                   	nop

f010461a <device_handler>:
TRAPHANDLER_NOEC(device_handler,T_DEVICE)
f010461a:	6a 00                	push   $0x0
f010461c:	6a 07                	push   $0x7
f010461e:	e9 a9 00 00 00       	jmp    f01046cc <_alltraps>
f0104623:	90                   	nop

f0104624 <dblflt_handler>:
TRAPHANDLER(dblflt_handler,T_DBLFLT)
f0104624:	6a 08                	push   $0x8
f0104626:	e9 a1 00 00 00       	jmp    f01046cc <_alltraps>
f010462b:	90                   	nop

f010462c <tss_handler>:
TRAPHANDLER(tss_handler,T_TSS)
f010462c:	6a 0a                	push   $0xa
f010462e:	e9 99 00 00 00       	jmp    f01046cc <_alltraps>
f0104633:	90                   	nop

f0104634 <segnp_handler>:
TRAPHANDLER(segnp_handler,T_SEGNP)
f0104634:	6a 0b                	push   $0xb
f0104636:	e9 91 00 00 00       	jmp    f01046cc <_alltraps>
f010463b:	90                   	nop

f010463c <stack_handler>:
TRAPHANDLER(stack_handler,T_STACK)
f010463c:	6a 0c                	push   $0xc
f010463e:	e9 89 00 00 00       	jmp    f01046cc <_alltraps>
f0104643:	90                   	nop

f0104644 <gpflt_handler>:
TRAPHANDLER(gpflt_handler,T_GPFLT)
f0104644:	6a 0d                	push   $0xd
f0104646:	e9 81 00 00 00       	jmp    f01046cc <_alltraps>
f010464b:	90                   	nop

f010464c <pgflt_handler>:
TRAPHANDLER(pgflt_handler,T_PGFLT)
f010464c:	6a 0e                	push   $0xe
f010464e:	eb 7c                	jmp    f01046cc <_alltraps>

f0104650 <fperr_handler>:
TRAPHANDLER_NOEC(fperr_handler,T_FPERR)
f0104650:	6a 00                	push   $0x0
f0104652:	6a 10                	push   $0x10
f0104654:	eb 76                	jmp    f01046cc <_alltraps>

f0104656 <align_handler>:
TRAPHANDLER(align_handler,T_ALIGN)
f0104656:	6a 11                	push   $0x11
f0104658:	eb 72                	jmp    f01046cc <_alltraps>

f010465a <mchk_handler>:
TRAPHANDLER_NOEC(mchk_handler,T_MCHK)
f010465a:	6a 00                	push   $0x0
f010465c:	6a 12                	push   $0x12
f010465e:	eb 6c                	jmp    f01046cc <_alltraps>

f0104660 <simderr_handler>:
TRAPHANDLER_NOEC(simderr_handler,T_SIMDERR)
f0104660:	6a 00                	push   $0x0
f0104662:	6a 13                	push   $0x13
f0104664:	eb 66                	jmp    f01046cc <_alltraps>

f0104666 <syscall_handler>:
TRAPHANDLER_NOEC(syscall_handler,T_SYSCALL)
f0104666:	6a 00                	push   $0x0
f0104668:	6a 30                	push   $0x30
f010466a:	eb 60                	jmp    f01046cc <_alltraps>

f010466c <irq0_handler>:

TRAPHANDLER_NOEC(irq0_handler,IRQ_OFFSET+0)
f010466c:	6a 00                	push   $0x0
f010466e:	6a 20                	push   $0x20
f0104670:	eb 5a                	jmp    f01046cc <_alltraps>

f0104672 <irq1_handler>:
TRAPHANDLER_NOEC(irq1_handler,IRQ_OFFSET+1)
f0104672:	6a 00                	push   $0x0
f0104674:	6a 21                	push   $0x21
f0104676:	eb 54                	jmp    f01046cc <_alltraps>

f0104678 <irq2_handler>:
TRAPHANDLER_NOEC(irq2_handler,IRQ_OFFSET+2)
f0104678:	6a 00                	push   $0x0
f010467a:	6a 22                	push   $0x22
f010467c:	eb 4e                	jmp    f01046cc <_alltraps>

f010467e <irq3_handler>:
TRAPHANDLER_NOEC(irq3_handler,IRQ_OFFSET+3)
f010467e:	6a 00                	push   $0x0
f0104680:	6a 23                	push   $0x23
f0104682:	eb 48                	jmp    f01046cc <_alltraps>

f0104684 <irq4_handler>:
TRAPHANDLER_NOEC(irq4_handler,IRQ_OFFSET+4)
f0104684:	6a 00                	push   $0x0
f0104686:	6a 24                	push   $0x24
f0104688:	eb 42                	jmp    f01046cc <_alltraps>

f010468a <irq5_handler>:
TRAPHANDLER_NOEC(irq5_handler,IRQ_OFFSET+5)
f010468a:	6a 00                	push   $0x0
f010468c:	6a 25                	push   $0x25
f010468e:	eb 3c                	jmp    f01046cc <_alltraps>

f0104690 <irq6_handler>:
TRAPHANDLER_NOEC(irq6_handler,IRQ_OFFSET+6)
f0104690:	6a 00                	push   $0x0
f0104692:	6a 26                	push   $0x26
f0104694:	eb 36                	jmp    f01046cc <_alltraps>

f0104696 <irq7_handler>:
TRAPHANDLER_NOEC(irq7_handler,IRQ_OFFSET+7)
f0104696:	6a 00                	push   $0x0
f0104698:	6a 27                	push   $0x27
f010469a:	eb 30                	jmp    f01046cc <_alltraps>

f010469c <irq8_handler>:
TRAPHANDLER_NOEC(irq8_handler,IRQ_OFFSET+8)
f010469c:	6a 00                	push   $0x0
f010469e:	6a 28                	push   $0x28
f01046a0:	eb 2a                	jmp    f01046cc <_alltraps>

f01046a2 <irq9_handler>:
TRAPHANDLER_NOEC(irq9_handler,IRQ_OFFSET+9)
f01046a2:	6a 00                	push   $0x0
f01046a4:	6a 29                	push   $0x29
f01046a6:	eb 24                	jmp    f01046cc <_alltraps>

f01046a8 <irq10_handler>:
TRAPHANDLER_NOEC(irq10_handler,IRQ_OFFSET+10)
f01046a8:	6a 00                	push   $0x0
f01046aa:	6a 2a                	push   $0x2a
f01046ac:	eb 1e                	jmp    f01046cc <_alltraps>

f01046ae <irq11_handler>:
TRAPHANDLER_NOEC(irq11_handler,IRQ_OFFSET+11)
f01046ae:	6a 00                	push   $0x0
f01046b0:	6a 2b                	push   $0x2b
f01046b2:	eb 18                	jmp    f01046cc <_alltraps>

f01046b4 <irq12_handler>:
TRAPHANDLER_NOEC(irq12_handler,IRQ_OFFSET+12)
f01046b4:	6a 00                	push   $0x0
f01046b6:	6a 2c                	push   $0x2c
f01046b8:	eb 12                	jmp    f01046cc <_alltraps>

f01046ba <irq13_handler>:
TRAPHANDLER_NOEC(irq13_handler,IRQ_OFFSET+13)
f01046ba:	6a 00                	push   $0x0
f01046bc:	6a 2d                	push   $0x2d
f01046be:	eb 0c                	jmp    f01046cc <_alltraps>

f01046c0 <irq14_handler>:
TRAPHANDLER_NOEC(irq14_handler,IRQ_OFFSET+14)
f01046c0:	6a 00                	push   $0x0
f01046c2:	6a 2e                	push   $0x2e
f01046c4:	eb 06                	jmp    f01046cc <_alltraps>

f01046c6 <irq15_handler>:
TRAPHANDLER_NOEC(irq15_handler,IRQ_OFFSET+15)
f01046c6:	6a 00                	push   $0x0
f01046c8:	6a 2f                	push   $0x2f
f01046ca:	eb 00                	jmp    f01046cc <_alltraps>

f01046cc <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds
f01046cc:	1e                   	push   %ds
	pushl %es
f01046cd:	06                   	push   %es
	pushal
f01046ce:	60                   	pusha  

	movl $GD_KD, %eax
f01046cf:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds
f01046d4:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f01046d6:	8e c0                	mov    %eax,%es

	push %esp
f01046d8:	54                   	push   %esp
	call trap
f01046d9:	e8 7c fc ff ff       	call   f010435a <trap>

f01046de <sched_halt>:

// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void sched_halt(void)
{
f01046de:	55                   	push   %ebp
f01046df:	89 e5                	mov    %esp,%ebp
f01046e1:	83 ec 08             	sub    $0x8,%esp
f01046e4:	a1 48 e2 2a f0       	mov    0xf02ae248,%eax
f01046e9:	83 c0 54             	add    $0x54,%eax
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++)
f01046ec:	b9 00 00 00 00       	mov    $0x0,%ecx
	{
		if ((envs[i].env_status == ENV_RUNNABLE ||
			 envs[i].env_status == ENV_RUNNING ||
f01046f1:	8b 10                	mov    (%eax),%edx
f01046f3:	83 ea 01             	sub    $0x1,%edx
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01046f6:	83 fa 02             	cmp    $0x2,%edx
f01046f9:	76 2d                	jbe    f0104728 <sched_halt+0x4a>
	for (i = 0; i < NENV; i++)
f01046fb:	83 c1 01             	add    $0x1,%ecx
f01046fe:	83 c0 7c             	add    $0x7c,%eax
f0104701:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104707:	75 e8                	jne    f01046f1 <sched_halt+0x13>
			 envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV)
	{
		cprintf("No runnable environments in the system!\n");
f0104709:	83 ec 0c             	sub    $0xc,%esp
f010470c:	68 30 84 10 f0       	push   $0xf0108430
f0104711:	e8 1a f2 ff ff       	call   f0103930 <cprintf>
f0104716:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104719:	83 ec 0c             	sub    $0xc,%esp
f010471c:	6a 00                	push   $0x0
f010471e:	e8 55 c2 ff ff       	call   f0100978 <monitor>
f0104723:	83 c4 10             	add    $0x10,%esp
f0104726:	eb f1                	jmp    f0104719 <sched_halt+0x3b>
	if (i == NENV)
f0104728:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f010472e:	74 d9                	je     f0104709 <sched_halt+0x2b>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104730:	e8 9e 19 00 00       	call   f01060d3 <cpunum>
f0104735:	6b c0 74             	imul   $0x74,%eax,%eax
f0104738:	c7 80 28 f0 2a f0 00 	movl   $0x0,-0xfd50fd8(%eax)
f010473f:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104742:	a1 a4 ee 2a f0       	mov    0xf02aeea4,%eax
	if ((uint32_t)kva < KERNBASE)
f0104747:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010474c:	76 50                	jbe    f010479e <sched_halt+0xc0>
	return (physaddr_t)kva - KERNBASE;
f010474e:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104753:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104756:	e8 78 19 00 00       	call   f01060d3 <cpunum>
f010475b:	6b d0 74             	imul   $0x74,%eax,%edx
f010475e:	83 c2 04             	add    $0x4,%edx
	asm volatile("lock; xchgl %0, %1"
f0104761:	b8 02 00 00 00       	mov    $0x2,%eax
f0104766:	f0 87 82 20 f0 2a f0 	lock xchg %eax,-0xfd50fe0(%edx)
	spin_unlock(&kernel_lock);
f010476d:	83 ec 0c             	sub    $0xc,%esp
f0104770:	68 c0 43 12 f0       	push   $0xf01243c0
f0104775:	e8 66 1c 00 00       	call   f01063e0 <spin_unlock>
	asm volatile("pause");
f010477a:	f3 90                	pause  
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
		:
		: "a"(thiscpu->cpu_ts.ts_esp0));
f010477c:	e8 52 19 00 00       	call   f01060d3 <cpunum>
f0104781:	6b c0 74             	imul   $0x74,%eax,%eax
	asm volatile(
f0104784:	8b 80 30 f0 2a f0    	mov    -0xfd50fd0(%eax),%eax
f010478a:	bd 00 00 00 00       	mov    $0x0,%ebp
f010478f:	89 c4                	mov    %eax,%esp
f0104791:	6a 00                	push   $0x0
f0104793:	6a 00                	push   $0x0
f0104795:	fb                   	sti    
f0104796:	f4                   	hlt    
f0104797:	eb fd                	jmp    f0104796 <sched_halt+0xb8>
}
f0104799:	83 c4 10             	add    $0x10,%esp
f010479c:	c9                   	leave  
f010479d:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010479e:	50                   	push   %eax
f010479f:	68 e8 6c 10 f0       	push   $0xf0106ce8
f01047a4:	6a 4d                	push   $0x4d
f01047a6:	68 59 84 10 f0       	push   $0xf0108459
f01047ab:	e8 90 b8 ff ff       	call   f0100040 <_panic>

f01047b0 <sched_yield>:
{
f01047b0:	55                   	push   %ebp
f01047b1:	89 e5                	mov    %esp,%ebp
f01047b3:	57                   	push   %edi
f01047b4:	56                   	push   %esi
f01047b5:	53                   	push   %ebx
f01047b6:	83 ec 0c             	sub    $0xc,%esp
	idle = curenv;
f01047b9:	e8 15 19 00 00       	call   f01060d3 <cpunum>
f01047be:	6b c0 74             	imul   $0x74,%eax,%eax
f01047c1:	8b b8 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%edi
	size_t i = idle != NULL ? ENVX(idle->env_id) + 1 : 0;
f01047c7:	b8 00 00 00 00       	mov    $0x0,%eax
f01047cc:	85 ff                	test   %edi,%edi
f01047ce:	74 0b                	je     f01047db <sched_yield+0x2b>
f01047d0:	8b 47 48             	mov    0x48(%edi),%eax
f01047d3:	25 ff 03 00 00       	and    $0x3ff,%eax
f01047d8:	83 c0 01             	add    $0x1,%eax
		if (envs[i].env_status == ENV_RUNNABLE)
f01047db:	8b 0d 48 e2 2a f0    	mov    0xf02ae248,%ecx
f01047e1:	ba 00 04 00 00       	mov    $0x400,%edx
f01047e6:	6b d8 7c             	imul   $0x7c,%eax,%ebx
f01047e9:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
f01047ec:	83 7e 54 02          	cmpl   $0x2,0x54(%esi)
f01047f0:	74 24                	je     f0104816 <sched_yield+0x66>
	for (j = 0; j != NENV; j++, i = (i + 1) % NENV)
f01047f2:	83 c0 01             	add    $0x1,%eax
f01047f5:	25 ff 03 00 00       	and    $0x3ff,%eax
f01047fa:	83 ea 01             	sub    $0x1,%edx
f01047fd:	75 e7                	jne    f01047e6 <sched_yield+0x36>
	if (idle && idle->env_status == ENV_RUNNING)
f01047ff:	85 ff                	test   %edi,%edi
f0104801:	74 06                	je     f0104809 <sched_yield+0x59>
f0104803:	83 7f 54 03          	cmpl   $0x3,0x54(%edi)
f0104807:	74 24                	je     f010482d <sched_yield+0x7d>
	sched_halt();
f0104809:	e8 d0 fe ff ff       	call   f01046de <sched_halt>
}
f010480e:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104811:	5b                   	pop    %ebx
f0104812:	5e                   	pop    %esi
f0104813:	5f                   	pop    %edi
f0104814:	5d                   	pop    %ebp
f0104815:	c3                   	ret    
			envs[i].env_cpunum = cpunum();
f0104816:	e8 b8 18 00 00       	call   f01060d3 <cpunum>
f010481b:	89 46 5c             	mov    %eax,0x5c(%esi)
			env_run(envs + i);
f010481e:	83 ec 0c             	sub    $0xc,%esp
f0104821:	03 1d 48 e2 2a f0    	add    0xf02ae248,%ebx
f0104827:	53                   	push   %ebx
f0104828:	e8 c7 ee ff ff       	call   f01036f4 <env_run>
		curenv->env_cpunum = cpunum();
f010482d:	e8 a1 18 00 00       	call   f01060d3 <cpunum>
f0104832:	6b c0 74             	imul   $0x74,%eax,%eax
f0104835:	8b 98 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%ebx
f010483b:	e8 93 18 00 00       	call   f01060d3 <cpunum>
f0104840:	89 43 5c             	mov    %eax,0x5c(%ebx)
		env_run(idle);
f0104843:	83 ec 0c             	sub    $0xc,%esp
f0104846:	57                   	push   %edi
f0104847:	e8 a8 ee ff ff       	call   f01036f4 <env_run>

f010484c <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f010484c:	55                   	push   %ebp
f010484d:	89 e5                	mov    %esp,%ebp
f010484f:	57                   	push   %edi
f0104850:	56                   	push   %esi
f0104851:	53                   	push   %ebx
f0104852:	83 ec 1c             	sub    $0x1c,%esp
f0104855:	8b 45 08             	mov    0x8(%ebp),%eax
	// Return any appropriate return value.
	// LAB 3: Your code here.

	// panic("syscall not implemented");

	switch (syscallno)
f0104858:	83 f8 0d             	cmp    $0xd,%eax
f010485b:	0f 87 0d 06 00 00    	ja     f0104e6e <syscall+0x622>
f0104861:	ff 24 85 a0 84 10 f0 	jmp    *-0xfef7b60(,%eax,4)
	user_mem_assert(curenv, s, len, 0);
f0104868:	e8 66 18 00 00       	call   f01060d3 <cpunum>
f010486d:	6a 00                	push   $0x0
f010486f:	ff 75 10             	pushl  0x10(%ebp)
f0104872:	ff 75 0c             	pushl  0xc(%ebp)
f0104875:	6b c0 74             	imul   $0x74,%eax,%eax
f0104878:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f010487e:	e8 ed e6 ff ff       	call   f0102f70 <user_mem_assert>
	cprintf("%.*s", len, s);
f0104883:	83 c4 0c             	add    $0xc,%esp
f0104886:	ff 75 0c             	pushl  0xc(%ebp)
f0104889:	ff 75 10             	pushl  0x10(%ebp)
f010488c:	68 66 84 10 f0       	push   $0xf0108466
f0104891:	e8 9a f0 ff ff       	call   f0103930 <cprintf>
f0104896:	83 c4 10             	add    $0x10,%esp
	{
	case SYS_cputs:
		sys_cputs((char *)a1, (size_t)a2);
		return 0;
f0104899:	bb 00 00 00 00       	mov    $0x0,%ebx
	case SYS_env_set_trapframe:
		return sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
	default:
		return -E_INVAL;
	}
}
f010489e:	89 d8                	mov    %ebx,%eax
f01048a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01048a3:	5b                   	pop    %ebx
f01048a4:	5e                   	pop    %esi
f01048a5:	5f                   	pop    %edi
f01048a6:	5d                   	pop    %ebp
f01048a7:	c3                   	ret    
	return cons_getc();
f01048a8:	e8 79 bd ff ff       	call   f0100626 <cons_getc>
f01048ad:	89 c3                	mov    %eax,%ebx
		return sys_cgetc();
f01048af:	eb ed                	jmp    f010489e <syscall+0x52>
	return curenv->env_id;
f01048b1:	e8 1d 18 00 00       	call   f01060d3 <cpunum>
f01048b6:	6b c0 74             	imul   $0x74,%eax,%eax
f01048b9:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f01048bf:	8b 58 48             	mov    0x48(%eax),%ebx
		return sys_getenvid();
f01048c2:	eb da                	jmp    f010489e <syscall+0x52>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01048c4:	83 ec 04             	sub    $0x4,%esp
f01048c7:	6a 01                	push   $0x1
f01048c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01048cc:	50                   	push   %eax
f01048cd:	ff 75 0c             	pushl  0xc(%ebp)
f01048d0:	e8 52 e7 ff ff       	call   f0103027 <envid2env>
f01048d5:	89 c3                	mov    %eax,%ebx
f01048d7:	83 c4 10             	add    $0x10,%esp
f01048da:	85 c0                	test   %eax,%eax
f01048dc:	78 c0                	js     f010489e <syscall+0x52>
	if (e == curenv)
f01048de:	e8 f0 17 00 00       	call   f01060d3 <cpunum>
f01048e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01048e6:	6b c0 74             	imul   $0x74,%eax,%eax
f01048e9:	39 90 28 f0 2a f0    	cmp    %edx,-0xfd50fd8(%eax)
f01048ef:	74 3d                	je     f010492e <syscall+0xe2>
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f01048f1:	8b 5a 48             	mov    0x48(%edx),%ebx
f01048f4:	e8 da 17 00 00       	call   f01060d3 <cpunum>
f01048f9:	83 ec 04             	sub    $0x4,%esp
f01048fc:	53                   	push   %ebx
f01048fd:	6b c0 74             	imul   $0x74,%eax,%eax
f0104900:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104906:	ff 70 48             	pushl  0x48(%eax)
f0104909:	68 86 84 10 f0       	push   $0xf0108486
f010490e:	e8 1d f0 ff ff       	call   f0103930 <cprintf>
f0104913:	83 c4 10             	add    $0x10,%esp
	env_destroy(e);
f0104916:	83 ec 0c             	sub    $0xc,%esp
f0104919:	ff 75 e4             	pushl  -0x1c(%ebp)
f010491c:	e8 34 ed ff ff       	call   f0103655 <env_destroy>
f0104921:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104924:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_destroy((envid_t)a1);
f0104929:	e9 70 ff ff ff       	jmp    f010489e <syscall+0x52>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f010492e:	e8 a0 17 00 00       	call   f01060d3 <cpunum>
f0104933:	83 ec 08             	sub    $0x8,%esp
f0104936:	6b c0 74             	imul   $0x74,%eax,%eax
f0104939:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f010493f:	ff 70 48             	pushl  0x48(%eax)
f0104942:	68 6b 84 10 f0       	push   $0xf010846b
f0104947:	e8 e4 ef ff ff       	call   f0103930 <cprintf>
f010494c:	83 c4 10             	add    $0x10,%esp
f010494f:	eb c5                	jmp    f0104916 <syscall+0xca>
	sched_yield();
f0104951:	e8 5a fe ff ff       	call   f01047b0 <sched_yield>
	int ret = env_alloc(&e, curenv->env_id);
f0104956:	e8 78 17 00 00       	call   f01060d3 <cpunum>
f010495b:	83 ec 08             	sub    $0x8,%esp
f010495e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104961:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104967:	ff 70 48             	pushl  0x48(%eax)
f010496a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010496d:	50                   	push   %eax
f010496e:	e8 c5 e7 ff ff       	call   f0103138 <env_alloc>
f0104973:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104975:	83 c4 10             	add    $0x10,%esp
f0104978:	85 c0                	test   %eax,%eax
f010497a:	0f 88 1e ff ff ff    	js     f010489e <syscall+0x52>
	e->env_status = ENV_NOT_RUNNABLE;
f0104980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104983:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	e->env_tf = curenv->env_tf;
f010498a:	e8 44 17 00 00       	call   f01060d3 <cpunum>
f010498f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104992:	8b b0 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%esi
f0104998:	b9 11 00 00 00       	mov    $0x11,%ecx
f010499d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01049a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_regs.reg_eax = 0;
f01049a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01049a5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return e->env_id;
f01049ac:	8b 58 48             	mov    0x48(%eax),%ebx
		return sys_exofork();
f01049af:	e9 ea fe ff ff       	jmp    f010489e <syscall+0x52>
	int ret = envid2env(envid, &e, 1);
f01049b4:	83 ec 04             	sub    $0x4,%esp
f01049b7:	6a 01                	push   $0x1
f01049b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01049bc:	50                   	push   %eax
f01049bd:	ff 75 0c             	pushl  0xc(%ebp)
f01049c0:	e8 62 e6 ff ff       	call   f0103027 <envid2env>
f01049c5:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f01049c7:	83 c4 10             	add    $0x10,%esp
f01049ca:	85 c0                	test   %eax,%eax
f01049cc:	0f 88 cc fe ff ff    	js     f010489e <syscall+0x52>
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
f01049d2:	8b 45 10             	mov    0x10(%ebp),%eax
f01049d5:	83 e8 02             	sub    $0x2,%eax
f01049d8:	a9 fd ff ff ff       	test   $0xfffffffd,%eax
f01049dd:	75 13                	jne    f01049f2 <syscall+0x1a6>
	e->env_status = status;
f01049df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01049e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01049e5:	89 48 54             	mov    %ecx,0x54(%eax)
	return 0;
f01049e8:	bb 00 00 00 00       	mov    $0x0,%ebx
f01049ed:	e9 ac fe ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f01049f2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_env_set_status((envid_t)a1, (int)a2);
f01049f7:	e9 a2 fe ff ff       	jmp    f010489e <syscall+0x52>
	int ret = envid2env(envid, &e, 1);
f01049fc:	83 ec 04             	sub    $0x4,%esp
f01049ff:	6a 01                	push   $0x1
f0104a01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a04:	50                   	push   %eax
f0104a05:	ff 75 0c             	pushl  0xc(%ebp)
f0104a08:	e8 1a e6 ff ff       	call   f0103027 <envid2env>
f0104a0d:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104a0f:	83 c4 10             	add    $0x10,%esp
f0104a12:	85 c0                	test   %eax,%eax
f0104a14:	0f 88 84 fe ff ff    	js     f010489e <syscall+0x52>
	if ((uintptr_t)va >= UTOP || PGOFF(va))
f0104a1a:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104a21:	77 65                	ja     f0104a88 <syscall+0x23c>
f0104a23:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104a2a:	75 66                	jne    f0104a92 <syscall+0x246>
	if ((perm & flag) != flag || (perm & ~(PTE_SYSCALL)) != 0)
f0104a2c:	8b 45 14             	mov    0x14(%ebp),%eax
f0104a2f:	83 e0 05             	and    $0x5,%eax
f0104a32:	83 f8 05             	cmp    $0x5,%eax
f0104a35:	75 65                	jne    f0104a9c <syscall+0x250>
f0104a37:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0104a3a:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104a40:	75 64                	jne    f0104aa6 <syscall+0x25a>
	struct PageInfo *pg = page_alloc(1);
f0104a42:	83 ec 0c             	sub    $0xc,%esp
f0104a45:	6a 01                	push   $0x1
f0104a47:	e8 43 c5 ff ff       	call   f0100f8f <page_alloc>
f0104a4c:	89 c6                	mov    %eax,%esi
	if (pg == NULL)
f0104a4e:	83 c4 10             	add    $0x10,%esp
f0104a51:	85 c0                	test   %eax,%eax
f0104a53:	74 5b                	je     f0104ab0 <syscall+0x264>
	if (page_insert(e->env_pgdir, pg, va, perm) < 0)
f0104a55:	ff 75 14             	pushl  0x14(%ebp)
f0104a58:	ff 75 10             	pushl  0x10(%ebp)
f0104a5b:	50                   	push   %eax
f0104a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104a5f:	ff 70 60             	pushl  0x60(%eax)
f0104a62:	e8 00 c8 ff ff       	call   f0101267 <page_insert>
f0104a67:	83 c4 10             	add    $0x10,%esp
f0104a6a:	85 c0                	test   %eax,%eax
f0104a6c:	0f 89 2c fe ff ff    	jns    f010489e <syscall+0x52>
		page_free(pg);
f0104a72:	83 ec 0c             	sub    $0xc,%esp
f0104a75:	56                   	push   %esi
f0104a76:	e8 86 c5 ff ff       	call   f0101001 <page_free>
f0104a7b:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f0104a7e:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
f0104a83:	e9 16 fe ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104a88:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a8d:	e9 0c fe ff ff       	jmp    f010489e <syscall+0x52>
f0104a92:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104a97:	e9 02 fe ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104a9c:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104aa1:	e9 f8 fd ff ff       	jmp    f010489e <syscall+0x52>
f0104aa6:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104aab:	e9 ee fd ff ff       	jmp    f010489e <syscall+0x52>
		return -E_NO_MEM;
f0104ab0:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
		return sys_page_alloc((envid_t)a1, (void *)a2, (int)a3);
f0104ab5:	e9 e4 fd ff ff       	jmp    f010489e <syscall+0x52>
	int ret = envid2env(srcenvid, &se, 1);
f0104aba:	83 ec 04             	sub    $0x4,%esp
f0104abd:	6a 01                	push   $0x1
f0104abf:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104ac2:	50                   	push   %eax
f0104ac3:	ff 75 0c             	pushl  0xc(%ebp)
f0104ac6:	e8 5c e5 ff ff       	call   f0103027 <envid2env>
f0104acb:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104acd:	83 c4 10             	add    $0x10,%esp
f0104ad0:	85 c0                	test   %eax,%eax
f0104ad2:	0f 88 c6 fd ff ff    	js     f010489e <syscall+0x52>
	ret = envid2env(dstenvid, &de, 1);
f0104ad8:	83 ec 04             	sub    $0x4,%esp
f0104adb:	6a 01                	push   $0x1
f0104add:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104ae0:	50                   	push   %eax
f0104ae1:	ff 75 14             	pushl  0x14(%ebp)
f0104ae4:	e8 3e e5 ff ff       	call   f0103027 <envid2env>
f0104ae9:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104aeb:	83 c4 10             	add    $0x10,%esp
f0104aee:	85 c0                	test   %eax,%eax
f0104af0:	0f 88 a8 fd ff ff    	js     f010489e <syscall+0x52>
	if ((uintptr_t)srcva >= UTOP || PGOFF(srcva) ||
f0104af6:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104afd:	0f 87 83 00 00 00    	ja     f0104b86 <syscall+0x33a>
f0104b03:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104b0a:	0f 85 80 00 00 00    	jne    f0104b90 <syscall+0x344>
f0104b10:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104b17:	77 77                	ja     f0104b90 <syscall+0x344>
		(uintptr_t)dstva >= UTOP || PGOFF(dstva))
f0104b19:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f0104b20:	75 78                	jne    f0104b9a <syscall+0x34e>
	if ((perm & flag) != flag || (perm & ~(PTE_SYSCALL)) != 0)
f0104b22:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104b25:	83 e0 05             	and    $0x5,%eax
f0104b28:	83 f8 05             	cmp    $0x5,%eax
f0104b2b:	75 77                	jne    f0104ba4 <syscall+0x358>
f0104b2d:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
f0104b30:	81 e3 f8 f1 ff ff    	and    $0xfffff1f8,%ebx
f0104b36:	75 76                	jne    f0104bae <syscall+0x362>
	struct PageInfo *pg = page_lookup(se->env_pgdir, srcva, &entry);
f0104b38:	83 ec 04             	sub    $0x4,%esp
f0104b3b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104b3e:	50                   	push   %eax
f0104b3f:	ff 75 10             	pushl  0x10(%ebp)
f0104b42:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104b45:	ff 70 60             	pushl  0x60(%eax)
f0104b48:	e8 30 c6 ff ff       	call   f010117d <page_lookup>
	if (pg == NULL)
f0104b4d:	83 c4 10             	add    $0x10,%esp
f0104b50:	85 c0                	test   %eax,%eax
f0104b52:	74 64                	je     f0104bb8 <syscall+0x36c>
	if ((perm & PTE_W) && (*entry & PTE_W) == 0)
f0104b54:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104b58:	74 08                	je     f0104b62 <syscall+0x316>
f0104b5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104b5d:	f6 02 02             	testb  $0x2,(%edx)
f0104b60:	74 60                	je     f0104bc2 <syscall+0x376>
	if (page_insert(de->env_pgdir, pg, dstva, perm) < 0)
f0104b62:	ff 75 1c             	pushl  0x1c(%ebp)
f0104b65:	ff 75 18             	pushl  0x18(%ebp)
f0104b68:	50                   	push   %eax
f0104b69:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104b6c:	ff 70 60             	pushl  0x60(%eax)
f0104b6f:	e8 f3 c6 ff ff       	call   f0101267 <page_insert>
f0104b74:	83 c4 10             	add    $0x10,%esp
		return -E_NO_MEM;
f0104b77:	85 c0                	test   %eax,%eax
f0104b79:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104b7e:	0f 48 d8             	cmovs  %eax,%ebx
f0104b81:	e9 18 fd ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104b86:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b8b:	e9 0e fd ff ff       	jmp    f010489e <syscall+0x52>
f0104b90:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b95:	e9 04 fd ff ff       	jmp    f010489e <syscall+0x52>
f0104b9a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104b9f:	e9 fa fc ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104ba4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104ba9:	e9 f0 fc ff ff       	jmp    f010489e <syscall+0x52>
f0104bae:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bb3:	e9 e6 fc ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104bb8:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bbd:	e9 dc fc ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104bc2:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104bc7:	e9 d2 fc ff ff       	jmp    f010489e <syscall+0x52>
	int ret = envid2env(envid, &e, 1);
f0104bcc:	83 ec 04             	sub    $0x4,%esp
f0104bcf:	6a 01                	push   $0x1
f0104bd1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104bd4:	50                   	push   %eax
f0104bd5:	ff 75 0c             	pushl  0xc(%ebp)
f0104bd8:	e8 4a e4 ff ff       	call   f0103027 <envid2env>
f0104bdd:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104bdf:	83 c4 10             	add    $0x10,%esp
f0104be2:	85 c0                	test   %eax,%eax
f0104be4:	0f 88 b4 fc ff ff    	js     f010489e <syscall+0x52>
	if ((uintptr_t)va >= UTOP || PGOFF(va))
f0104bea:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104bf1:	77 27                	ja     f0104c1a <syscall+0x3ce>
f0104bf3:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104bfa:	75 28                	jne    f0104c24 <syscall+0x3d8>
	page_remove(e->env_pgdir, va);
f0104bfc:	83 ec 08             	sub    $0x8,%esp
f0104bff:	ff 75 10             	pushl  0x10(%ebp)
f0104c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c05:	ff 70 60             	pushl  0x60(%eax)
f0104c08:	e8 0b c6 ff ff       	call   f0101218 <page_remove>
f0104c0d:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104c10:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104c15:	e9 84 fc ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104c1a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104c1f:	e9 7a fc ff ff       	jmp    f010489e <syscall+0x52>
f0104c24:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_page_unmap((envid_t)a1, (void *)a2);
f0104c29:	e9 70 fc ff ff       	jmp    f010489e <syscall+0x52>
	if (envid2env(envid, &e, 1) < 0)
f0104c2e:	83 ec 04             	sub    $0x4,%esp
f0104c31:	6a 01                	push   $0x1
f0104c33:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c36:	50                   	push   %eax
f0104c37:	ff 75 0c             	pushl  0xc(%ebp)
f0104c3a:	e8 e8 e3 ff ff       	call   f0103027 <envid2env>
f0104c3f:	83 c4 10             	add    $0x10,%esp
f0104c42:	85 c0                	test   %eax,%eax
f0104c44:	78 13                	js     f0104c59 <syscall+0x40d>
	e->env_pgfault_upcall = func;
f0104c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c49:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104c4c:	89 78 64             	mov    %edi,0x64(%eax)
	return 0;
f0104c4f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104c54:	e9 45 fc ff ff       	jmp    f010489e <syscall+0x52>
		return -E_BAD_ENV;
f0104c59:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
		return sys_env_set_pgfault_upcall(a1, (void *)a2);
f0104c5e:	e9 3b fc ff ff       	jmp    f010489e <syscall+0x52>
	int ret = envid2env(envid, &dste, 0);
f0104c63:	83 ec 04             	sub    $0x4,%esp
f0104c66:	6a 00                	push   $0x0
f0104c68:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104c6b:	50                   	push   %eax
f0104c6c:	ff 75 0c             	pushl  0xc(%ebp)
f0104c6f:	e8 b3 e3 ff ff       	call   f0103027 <envid2env>
f0104c74:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104c76:	83 c4 10             	add    $0x10,%esp
f0104c79:	85 c0                	test   %eax,%eax
f0104c7b:	0f 88 1d fc ff ff    	js     f010489e <syscall+0x52>
	if (dste->env_ipc_recving == 0 || dste->env_ipc_from != 0)
f0104c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104c84:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104c88:	0f 84 d8 00 00 00    	je     f0104d66 <syscall+0x51a>
f0104c8e:	83 78 74 00          	cmpl   $0x0,0x74(%eax)
f0104c92:	0f 85 d8 00 00 00    	jne    f0104d70 <syscall+0x524>
	if (srcva < (void *)UTOP)
f0104c98:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104c9f:	0f 87 88 00 00 00    	ja     f0104d2d <syscall+0x4e1>
		if (PGOFF(srcva) || (perm & PTE_P) == 0 || (perm & PTE_U) == 0 || (perm & ~(PTE_SYSCALL)))
f0104ca5:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104cac:	0f 85 c8 00 00 00    	jne    f0104d7a <syscall+0x52e>
f0104cb2:	8b 45 18             	mov    0x18(%ebp),%eax
f0104cb5:	25 fd f1 ff ff       	and    $0xfffff1fd,%eax
f0104cba:	83 f8 05             	cmp    $0x5,%eax
f0104cbd:	0f 85 c1 00 00 00    	jne    f0104d84 <syscall+0x538>
		if ((pg = page_lookup(curenv->env_pgdir, srcva, &pte)) == NULL)
f0104cc3:	e8 0b 14 00 00       	call   f01060d3 <cpunum>
f0104cc8:	83 ec 04             	sub    $0x4,%esp
f0104ccb:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104cce:	52                   	push   %edx
f0104ccf:	ff 75 14             	pushl  0x14(%ebp)
f0104cd2:	6b c0 74             	imul   $0x74,%eax,%eax
f0104cd5:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104cdb:	ff 70 60             	pushl  0x60(%eax)
f0104cde:	e8 9a c4 ff ff       	call   f010117d <page_lookup>
f0104ce3:	83 c4 10             	add    $0x10,%esp
f0104ce6:	85 c0                	test   %eax,%eax
f0104ce8:	0f 84 a0 00 00 00    	je     f0104d8e <syscall+0x542>
		if ((perm & PTE_W) && !(*pte & PTE_W))
f0104cee:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104cf2:	74 0c                	je     f0104d00 <syscall+0x4b4>
f0104cf4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104cf7:	f6 02 02             	testb  $0x2,(%edx)
f0104cfa:	0f 84 98 00 00 00    	je     f0104d98 <syscall+0x54c>
		if (dste->env_ipc_dstva)
f0104d00:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104d03:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0104d06:	85 c9                	test   %ecx,%ecx
f0104d08:	74 23                	je     f0104d2d <syscall+0x4e1>
			if ((ret = page_insert(dste->env_pgdir, pg, dste->env_ipc_dstva, perm)) < 0)
f0104d0a:	ff 75 18             	pushl  0x18(%ebp)
f0104d0d:	51                   	push   %ecx
f0104d0e:	50                   	push   %eax
f0104d0f:	ff 72 60             	pushl  0x60(%edx)
f0104d12:	e8 50 c5 ff ff       	call   f0101267 <page_insert>
f0104d17:	89 c3                	mov    %eax,%ebx
f0104d19:	83 c4 10             	add    $0x10,%esp
f0104d1c:	85 c0                	test   %eax,%eax
f0104d1e:	0f 88 7a fb ff ff    	js     f010489e <syscall+0x52>
			dste->env_ipc_perm = perm;
f0104d24:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104d27:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104d2a:	89 78 78             	mov    %edi,0x78(%eax)
	dste->env_ipc_from = curenv->env_id;
f0104d2d:	e8 a1 13 00 00       	call   f01060d3 <cpunum>
f0104d32:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104d35:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d38:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104d3e:	8b 40 48             	mov    0x48(%eax),%eax
f0104d41:	89 42 74             	mov    %eax,0x74(%edx)
	dste->env_ipc_recving = 0;
f0104d44:	c6 42 68 00          	movb   $0x0,0x68(%edx)
	dste->env_ipc_value = value;
f0104d48:	8b 45 10             	mov    0x10(%ebp),%eax
f0104d4b:	89 42 70             	mov    %eax,0x70(%edx)
	dste->env_status = ENV_RUNNABLE;
f0104d4e:	c7 42 54 02 00 00 00 	movl   $0x2,0x54(%edx)
	dste->env_tf.tf_regs.reg_eax = 0;
f0104d55:	c7 42 1c 00 00 00 00 	movl   $0x0,0x1c(%edx)
	return 0;
f0104d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104d61:	e9 38 fb ff ff       	jmp    f010489e <syscall+0x52>
		return -E_IPC_NOT_RECV;
f0104d66:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104d6b:	e9 2e fb ff ff       	jmp    f010489e <syscall+0x52>
f0104d70:	bb f9 ff ff ff       	mov    $0xfffffff9,%ebx
f0104d75:	e9 24 fb ff ff       	jmp    f010489e <syscall+0x52>
			return -E_INVAL;
f0104d7a:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104d7f:	e9 1a fb ff ff       	jmp    f010489e <syscall+0x52>
f0104d84:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104d89:	e9 10 fb ff ff       	jmp    f010489e <syscall+0x52>
			return -E_INVAL;
f0104d8e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104d93:	e9 06 fb ff ff       	jmp    f010489e <syscall+0x52>
			return -E_INVAL;
f0104d98:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
		return sys_ipc_try_send((envid_t)a1, (uint32_t)a2, (void *)a3, (unsigned)a4);
f0104d9d:	e9 fc fa ff ff       	jmp    f010489e <syscall+0x52>
	if (dstva < (void *)UTOP && PGOFF(dstva))
f0104da2:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104da9:	77 13                	ja     f0104dbe <syscall+0x572>
f0104dab:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104db2:	74 0a                	je     f0104dbe <syscall+0x572>
		return sys_ipc_recv((void *)a1);
f0104db4:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104db9:	e9 e0 fa ff ff       	jmp    f010489e <syscall+0x52>
	curenv->env_ipc_recving = 1;
f0104dbe:	e8 10 13 00 00       	call   f01060d3 <cpunum>
f0104dc3:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dc6:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104dcc:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_dstva = dstva;
f0104dd0:	e8 fe 12 00 00       	call   f01060d3 <cpunum>
f0104dd5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dd8:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104dde:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104de1:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0104de4:	e8 ea 12 00 00       	call   f01060d3 <cpunum>
f0104de9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104dec:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104df2:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_ipc_from = 0;
f0104df9:	e8 d5 12 00 00       	call   f01060d3 <cpunum>
f0104dfe:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e01:	8b 80 28 f0 2a f0    	mov    -0xfd50fd8(%eax),%eax
f0104e07:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
	sched_yield();
f0104e0e:	e8 9d f9 ff ff       	call   f01047b0 <sched_yield>
	int ret = envid2env(envid, &e, 1);
f0104e13:	83 ec 04             	sub    $0x4,%esp
f0104e16:	6a 01                	push   $0x1
f0104e18:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104e1b:	50                   	push   %eax
f0104e1c:	ff 75 0c             	pushl  0xc(%ebp)
f0104e1f:	e8 03 e2 ff ff       	call   f0103027 <envid2env>
f0104e24:	89 c3                	mov    %eax,%ebx
	if (ret < 0)
f0104e26:	83 c4 10             	add    $0x10,%esp
f0104e29:	85 c0                	test   %eax,%eax
f0104e2b:	0f 88 6d fa ff ff    	js     f010489e <syscall+0x52>
	user_mem_assert(e, tf, sizeof(struct Trapframe), PTE_U);
f0104e31:	6a 04                	push   $0x4
f0104e33:	6a 44                	push   $0x44
f0104e35:	ff 75 10             	pushl  0x10(%ebp)
f0104e38:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104e3b:	e8 30 e1 ff ff       	call   f0102f70 <user_mem_assert>
	e->env_tf = *tf;
f0104e40:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104e45:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104e48:	8b 75 10             	mov    0x10(%ebp),%esi
f0104e4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	e->env_tf.tf_cs |= 3;
f0104e4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104e50:	66 83 4a 34 03       	orw    $0x3,0x34(%edx)
	e->env_tf.tf_eflags &= (~FL_IOPL_MASK);
f0104e55:	8b 42 38             	mov    0x38(%edx),%eax
f0104e58:	80 e4 cf             	and    $0xcf,%ah
	e->env_tf.tf_eflags |= FL_IF;
f0104e5b:	80 cc 02             	or     $0x2,%ah
f0104e5e:	89 42 38             	mov    %eax,0x38(%edx)
f0104e61:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104e64:	bb 00 00 00 00       	mov    $0x0,%ebx
		return sys_env_set_trapframe((envid_t)a1, (struct Trapframe *)a2);
f0104e69:	e9 30 fa ff ff       	jmp    f010489e <syscall+0x52>
		return -E_INVAL;
f0104e6e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0104e73:	e9 26 fa ff ff       	jmp    f010489e <syscall+0x52>

f0104e78 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
			   int type, uintptr_t addr)
{
f0104e78:	55                   	push   %ebp
f0104e79:	89 e5                	mov    %esp,%ebp
f0104e7b:	57                   	push   %edi
f0104e7c:	56                   	push   %esi
f0104e7d:	53                   	push   %ebx
f0104e7e:	83 ec 14             	sub    $0x14,%esp
f0104e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104e84:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104e87:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104e8a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104e8d:	8b 32                	mov    (%edx),%esi
f0104e8f:	8b 01                	mov    (%ecx),%eax
f0104e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104e94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r)
f0104e9b:	eb 2f                	jmp    f0104ecc <stab_binsearch+0x54>
	{
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0104e9d:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0104ea0:	39 c6                	cmp    %eax,%esi
f0104ea2:	7f 49                	jg     f0104eed <stab_binsearch+0x75>
f0104ea4:	0f b6 0a             	movzbl (%edx),%ecx
f0104ea7:	83 ea 0c             	sub    $0xc,%edx
f0104eaa:	39 f9                	cmp    %edi,%ecx
f0104eac:	75 ef                	jne    f0104e9d <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr)
f0104eae:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104eb1:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104eb4:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104eb8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104ebb:	73 35                	jae    f0104ef2 <stab_binsearch+0x7a>
		{
			*region_left = m;
f0104ebd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104ec0:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
f0104ec2:	8d 73 01             	lea    0x1(%ebx),%esi
		any_matches = 1;
f0104ec5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r)
f0104ecc:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0104ecf:	7f 4e                	jg     f0104f1f <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f0104ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104ed4:	01 f0                	add    %esi,%eax
f0104ed6:	89 c3                	mov    %eax,%ebx
f0104ed8:	c1 eb 1f             	shr    $0x1f,%ebx
f0104edb:	01 c3                	add    %eax,%ebx
f0104edd:	d1 fb                	sar    %ebx
f0104edf:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104ee2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104ee5:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104ee9:	89 d8                	mov    %ebx,%eax
		while (m >= l && stabs[m].n_type != type)
f0104eeb:	eb b3                	jmp    f0104ea0 <stab_binsearch+0x28>
			l = true_m + 1;
f0104eed:	8d 73 01             	lea    0x1(%ebx),%esi
			continue;
f0104ef0:	eb da                	jmp    f0104ecc <stab_binsearch+0x54>
		}
		else if (stabs[m].n_value > addr)
f0104ef2:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104ef5:	76 14                	jbe    f0104f0b <stab_binsearch+0x93>
		{
			*region_right = m - 1;
f0104ef7:	83 e8 01             	sub    $0x1,%eax
f0104efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104efd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104f00:	89 03                	mov    %eax,(%ebx)
		any_matches = 1;
f0104f02:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104f09:	eb c1                	jmp    f0104ecc <stab_binsearch+0x54>
		}
		else
		{
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104f0b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104f0e:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f0104f10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104f14:	89 c6                	mov    %eax,%esi
		any_matches = 1;
f0104f16:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104f1d:	eb ad                	jmp    f0104ecc <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f0104f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0104f23:	74 16                	je     f0104f3b <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
	else
	{
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0104f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104f28:	8b 00                	mov    (%eax),%eax
			 l > *region_left && stabs[l].n_type != type;
f0104f2a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104f2d:	8b 0e                	mov    (%esi),%ecx
f0104f2f:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104f32:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0104f35:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f0104f39:	eb 12                	jmp    f0104f4d <stab_binsearch+0xd5>
		*region_right = *region_left - 1;
f0104f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f3e:	8b 00                	mov    (%eax),%eax
f0104f40:	83 e8 01             	sub    $0x1,%eax
f0104f43:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0104f46:	89 07                	mov    %eax,(%edi)
f0104f48:	eb 16                	jmp    f0104f60 <stab_binsearch+0xe8>
			 l--)
f0104f4a:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0104f4d:	39 c1                	cmp    %eax,%ecx
f0104f4f:	7d 0a                	jge    f0104f5b <stab_binsearch+0xe3>
			 l > *region_left && stabs[l].n_type != type;
f0104f51:	0f b6 1a             	movzbl (%edx),%ebx
f0104f54:	83 ea 0c             	sub    $0xc,%edx
f0104f57:	39 fb                	cmp    %edi,%ebx
f0104f59:	75 ef                	jne    f0104f4a <stab_binsearch+0xd2>
			/* do nothing */;
		*region_left = l;
f0104f5b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104f5e:	89 07                	mov    %eax,(%edi)
	}
}
f0104f60:	83 c4 14             	add    $0x14,%esp
f0104f63:	5b                   	pop    %ebx
f0104f64:	5e                   	pop    %esi
f0104f65:	5f                   	pop    %edi
f0104f66:	5d                   	pop    %ebp
f0104f67:	c3                   	ret    

f0104f68 <debuginfo_eip>:
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0104f68:	55                   	push   %ebp
f0104f69:	89 e5                	mov    %esp,%ebp
f0104f6b:	57                   	push   %edi
f0104f6c:	56                   	push   %esi
f0104f6d:	53                   	push   %ebx
f0104f6e:	83 ec 4c             	sub    $0x4c,%esp
f0104f71:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104f74:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104f77:	c7 06 d8 84 10 f0    	movl   $0xf01084d8,(%esi)
	info->eip_line = 0;
f0104f7d:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0104f84:	c7 46 08 d8 84 10 f0 	movl   $0xf01084d8,0x8(%esi)
	info->eip_fn_namelen = 9;
f0104f8b:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0104f92:	89 7e 10             	mov    %edi,0x10(%esi)
	info->eip_fn_narg = 0;
f0104f95:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM)
f0104f9c:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104fa2:	0f 86 2a 01 00 00    	jbe    f01050d2 <debuginfo_eip+0x16a>
	{
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0104fa8:	c7 45 b8 3f 96 11 f0 	movl   $0xf011963f,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104faf:	c7 45 b4 a5 55 11 f0 	movl   $0xf01155a5,-0x4c(%ebp)
		stab_end = __STAB_END__;
f0104fb6:	bb a4 55 11 f0       	mov    $0xf01155a4,%ebx
		stabs = __STAB_BEGIN__;
f0104fbb:	c7 45 bc c8 8c 10 f0 	movl   $0xf0108cc8,-0x44(%ebp)
			user_mem_check(curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0)
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104fc2:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0104fc5:	39 4d b4             	cmp    %ecx,-0x4c(%ebp)
f0104fc8:	0f 83 7e 02 00 00    	jae    f010524c <debuginfo_eip+0x2e4>
f0104fce:	80 79 ff 00          	cmpb   $0x0,-0x1(%ecx)
f0104fd2:	0f 85 7b 02 00 00    	jne    f0105253 <debuginfo_eip+0x2eb>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104fd8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104fdf:	2b 5d bc             	sub    -0x44(%ebp),%ebx
f0104fe2:	c1 fb 02             	sar    $0x2,%ebx
f0104fe5:	69 c3 ab aa aa aa    	imul   $0xaaaaaaab,%ebx,%eax
f0104feb:	83 e8 01             	sub    $0x1,%eax
f0104fee:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104ff1:	83 ec 08             	sub    $0x8,%esp
f0104ff4:	57                   	push   %edi
f0104ff5:	6a 64                	push   $0x64
f0104ff7:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104ffa:	89 d1                	mov    %edx,%ecx
f0104ffc:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104fff:	8b 5d bc             	mov    -0x44(%ebp),%ebx
f0105002:	89 d8                	mov    %ebx,%eax
f0105004:	e8 6f fe ff ff       	call   f0104e78 <stab_binsearch>
	if (lfile == 0)
f0105009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010500c:	83 c4 10             	add    $0x10,%esp
f010500f:	85 c0                	test   %eax,%eax
f0105011:	0f 84 43 02 00 00    	je     f010525a <debuginfo_eip+0x2f2>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105017:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f010501a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010501d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105020:	83 ec 08             	sub    $0x8,%esp
f0105023:	57                   	push   %edi
f0105024:	6a 24                	push   $0x24
f0105026:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0105029:	89 d1                	mov    %edx,%ecx
f010502b:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010502e:	89 d8                	mov    %ebx,%eax
f0105030:	e8 43 fe ff ff       	call   f0104e78 <stab_binsearch>

	if (lfun <= rfun)
f0105035:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105038:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010503b:	83 c4 10             	add    $0x10,%esp
f010503e:	39 d0                	cmp    %edx,%eax
f0105040:	0f 8f 39 01 00 00    	jg     f010517f <debuginfo_eip+0x217>
	{
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105046:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
f0105049:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
f010504c:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
f010504f:	8b 1b                	mov    (%ebx),%ebx
f0105051:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0105054:	2b 4d b4             	sub    -0x4c(%ebp),%ecx
f0105057:	39 cb                	cmp    %ecx,%ebx
f0105059:	73 06                	jae    f0105061 <debuginfo_eip+0xf9>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010505b:	03 5d b4             	add    -0x4c(%ebp),%ebx
f010505e:	89 5e 08             	mov    %ebx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105061:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
f0105064:	8b 4b 08             	mov    0x8(%ebx),%ecx
f0105067:	89 4e 10             	mov    %ecx,0x10(%esi)
		addr -= info->eip_fn_addr;
f010506a:	29 cf                	sub    %ecx,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f010506c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f010506f:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105072:	83 ec 08             	sub    $0x8,%esp
f0105075:	6a 3a                	push   $0x3a
f0105077:	ff 76 08             	pushl  0x8(%esi)
f010507a:	e8 14 0a 00 00       	call   f0105a93 <strfind>
f010507f:	2b 46 08             	sub    0x8(%esi),%eax
f0105082:	89 46 0c             	mov    %eax,0xc(%esi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105085:	83 c4 08             	add    $0x8,%esp
f0105088:	57                   	push   %edi
f0105089:	6a 44                	push   $0x44
f010508b:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f010508e:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105091:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105094:	89 f8                	mov    %edi,%eax
f0105096:	e8 dd fd ff ff       	call   f0104e78 <stab_binsearch>
	if (lline <= rline)
f010509b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f010509e:	83 c4 10             	add    $0x10,%esp
f01050a1:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f01050a4:	0f 8f b7 01 00 00    	jg     f0105261 <debuginfo_eip+0x2f9>
		info->eip_line = stabs[lline].n_desc;
f01050aa:	89 d0                	mov    %edx,%eax
f01050ac:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01050af:	c1 e2 02             	shl    $0x2,%edx
f01050b2:	0f b7 4c 17 06       	movzwl 0x6(%edi,%edx,1),%ecx
f01050b7:	89 4e 04             	mov    %ecx,0x4(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01050ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f01050bd:	8d 54 17 04          	lea    0x4(%edi,%edx,1),%edx
f01050c1:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01050c5:	bf 01 00 00 00       	mov    $0x1,%edi
f01050ca:	89 75 0c             	mov    %esi,0xc(%ebp)
f01050cd:	e9 cc 00 00 00       	jmp    f010519e <debuginfo_eip+0x236>
		if (user_mem_check(curenv, usd, sizeof(*usd), PTE_U) < 0)
f01050d2:	e8 fc 0f 00 00       	call   f01060d3 <cpunum>
f01050d7:	6a 04                	push   $0x4
f01050d9:	6a 10                	push   $0x10
f01050db:	68 00 00 20 00       	push   $0x200000
f01050e0:	6b c0 74             	imul   $0x74,%eax,%eax
f01050e3:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f01050e9:	e8 02 de ff ff       	call   f0102ef0 <user_mem_check>
f01050ee:	83 c4 10             	add    $0x10,%esp
f01050f1:	85 c0                	test   %eax,%eax
f01050f3:	0f 88 45 01 00 00    	js     f010523e <debuginfo_eip+0x2d6>
		stabs = usd->stabs;
f01050f9:	8b 0d 00 00 20 00    	mov    0x200000,%ecx
f01050ff:	89 4d bc             	mov    %ecx,-0x44(%ebp)
		stab_end = usd->stab_end;
f0105102:	8b 1d 04 00 20 00    	mov    0x200004,%ebx
		stabstr = usd->stabstr;
f0105108:	a1 08 00 20 00       	mov    0x200008,%eax
f010510d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		stabstr_end = usd->stabstr_end;
f0105110:	8b 15 0c 00 20 00    	mov    0x20000c,%edx
f0105116:	89 55 b8             	mov    %edx,-0x48(%ebp)
		if (user_mem_check(curenv, stabs, stab_end - stabs, PTE_U) < 0 ||
f0105119:	e8 b5 0f 00 00       	call   f01060d3 <cpunum>
f010511e:	6a 04                	push   $0x4
f0105120:	89 da                	mov    %ebx,%edx
f0105122:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f0105125:	29 ca                	sub    %ecx,%edx
f0105127:	c1 fa 02             	sar    $0x2,%edx
f010512a:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0105130:	52                   	push   %edx
f0105131:	51                   	push   %ecx
f0105132:	6b c0 74             	imul   $0x74,%eax,%eax
f0105135:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f010513b:	e8 b0 dd ff ff       	call   f0102ef0 <user_mem_check>
f0105140:	83 c4 10             	add    $0x10,%esp
f0105143:	85 c0                	test   %eax,%eax
f0105145:	0f 88 fa 00 00 00    	js     f0105245 <debuginfo_eip+0x2dd>
			user_mem_check(curenv, stabstr, stabstr_end - stabstr, PTE_U) < 0)
f010514b:	e8 83 0f 00 00       	call   f01060d3 <cpunum>
f0105150:	6a 04                	push   $0x4
f0105152:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105155:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
f0105158:	29 ca                	sub    %ecx,%edx
f010515a:	52                   	push   %edx
f010515b:	51                   	push   %ecx
f010515c:	6b c0 74             	imul   $0x74,%eax,%eax
f010515f:	ff b0 28 f0 2a f0    	pushl  -0xfd50fd8(%eax)
f0105165:	e8 86 dd ff ff       	call   f0102ef0 <user_mem_check>
		if (user_mem_check(curenv, stabs, stab_end - stabs, PTE_U) < 0 ||
f010516a:	83 c4 10             	add    $0x10,%esp
f010516d:	85 c0                	test   %eax,%eax
f010516f:	0f 89 4d fe ff ff    	jns    f0104fc2 <debuginfo_eip+0x5a>
			return -1;
f0105175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010517a:	e9 ee 00 00 00       	jmp    f010526d <debuginfo_eip+0x305>
		info->eip_fn_addr = addr;
f010517f:	89 7e 10             	mov    %edi,0x10(%esi)
		lline = lfile;
f0105182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105185:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105188:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010518b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010518e:	e9 df fe ff ff       	jmp    f0105072 <debuginfo_eip+0x10a>
f0105193:	83 e8 01             	sub    $0x1,%eax
f0105196:	83 ea 0c             	sub    $0xc,%edx
f0105199:	89 f9                	mov    %edi,%ecx
f010519b:	88 4d c4             	mov    %cl,-0x3c(%ebp)
f010519e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	while (lline >= lfile && stabs[lline].n_type != N_SOL && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01051a1:	39 c3                	cmp    %eax,%ebx
f01051a3:	7f 24                	jg     f01051c9 <debuginfo_eip+0x261>
f01051a5:	0f b6 0a             	movzbl (%edx),%ecx
f01051a8:	80 f9 84             	cmp    $0x84,%cl
f01051ab:	74 46                	je     f01051f3 <debuginfo_eip+0x28b>
f01051ad:	80 f9 64             	cmp    $0x64,%cl
f01051b0:	75 e1                	jne    f0105193 <debuginfo_eip+0x22b>
f01051b2:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01051b6:	74 db                	je     f0105193 <debuginfo_eip+0x22b>
f01051b8:	8b 75 0c             	mov    0xc(%ebp),%esi
f01051bb:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01051bf:	74 3b                	je     f01051fc <debuginfo_eip+0x294>
f01051c1:	8b 7d c0             	mov    -0x40(%ebp),%edi
f01051c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f01051c7:	eb 33                	jmp    f01051fc <debuginfo_eip+0x294>
f01051c9:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01051cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01051cf:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		for (lline = lfun + 1;
			 lline < rfun && stabs[lline].n_type == N_PSYM;
			 lline++)
			info->eip_fn_narg++;

	return 0;
f01051d2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f01051d7:	39 da                	cmp    %ebx,%edx
f01051d9:	0f 8d 8e 00 00 00    	jge    f010526d <debuginfo_eip+0x305>
		for (lline = lfun + 1;
f01051df:	83 c2 01             	add    $0x1,%edx
f01051e2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f01051e5:	89 d0                	mov    %edx,%eax
f01051e7:	8d 14 52             	lea    (%edx,%edx,2),%edx
f01051ea:	8b 7d bc             	mov    -0x44(%ebp),%edi
f01051ed:	8d 54 97 04          	lea    0x4(%edi,%edx,4),%edx
f01051f1:	eb 32                	jmp    f0105225 <debuginfo_eip+0x2bd>
f01051f3:	8b 75 0c             	mov    0xc(%ebp),%esi
f01051f6:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01051fa:	75 1d                	jne    f0105219 <debuginfo_eip+0x2b1>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01051fc:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01051ff:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105202:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0105205:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105208:	8b 7d b4             	mov    -0x4c(%ebp),%edi
f010520b:	29 f8                	sub    %edi,%eax
f010520d:	39 c2                	cmp    %eax,%edx
f010520f:	73 bb                	jae    f01051cc <debuginfo_eip+0x264>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105211:	89 f8                	mov    %edi,%eax
f0105213:	01 d0                	add    %edx,%eax
f0105215:	89 06                	mov    %eax,(%esi)
f0105217:	eb b3                	jmp    f01051cc <debuginfo_eip+0x264>
f0105219:	8b 7d c0             	mov    -0x40(%ebp),%edi
f010521c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010521f:	eb db                	jmp    f01051fc <debuginfo_eip+0x294>
			info->eip_fn_narg++;
f0105221:	83 46 14 01          	addl   $0x1,0x14(%esi)
		for (lline = lfun + 1;
f0105225:	39 c3                	cmp    %eax,%ebx
f0105227:	7e 3f                	jle    f0105268 <debuginfo_eip+0x300>
			 lline < rfun && stabs[lline].n_type == N_PSYM;
f0105229:	0f b6 0a             	movzbl (%edx),%ecx
f010522c:	83 c0 01             	add    $0x1,%eax
f010522f:	83 c2 0c             	add    $0xc,%edx
f0105232:	80 f9 a0             	cmp    $0xa0,%cl
f0105235:	74 ea                	je     f0105221 <debuginfo_eip+0x2b9>
	return 0;
f0105237:	b8 00 00 00 00       	mov    $0x0,%eax
f010523c:	eb 2f                	jmp    f010526d <debuginfo_eip+0x305>
			return -1;
f010523e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105243:	eb 28                	jmp    f010526d <debuginfo_eip+0x305>
			return -1;
f0105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010524a:	eb 21                	jmp    f010526d <debuginfo_eip+0x305>
		return -1;
f010524c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105251:	eb 1a                	jmp    f010526d <debuginfo_eip+0x305>
f0105253:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105258:	eb 13                	jmp    f010526d <debuginfo_eip+0x305>
		return -1;
f010525a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010525f:	eb 0c                	jmp    f010526d <debuginfo_eip+0x305>
		return -1;
f0105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105266:	eb 05                	jmp    f010526d <debuginfo_eip+0x305>
	return 0;
f0105268:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010526d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105270:	5b                   	pop    %ebx
f0105271:	5e                   	pop    %esi
f0105272:	5f                   	pop    %edi
f0105273:	5d                   	pop    %ebp
f0105274:	c3                   	ret    

f0105275 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105275:	55                   	push   %ebp
f0105276:	89 e5                	mov    %esp,%ebp
f0105278:	57                   	push   %edi
f0105279:	56                   	push   %esi
f010527a:	53                   	push   %ebx
f010527b:	83 ec 1c             	sub    $0x1c,%esp
f010527e:	89 c7                	mov    %eax,%edi
f0105280:	89 d6                	mov    %edx,%esi
f0105282:	8b 45 08             	mov    0x8(%ebp),%eax
f0105285:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105288:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010528b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f010528e:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105291:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105296:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105299:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f010529c:	39 d3                	cmp    %edx,%ebx
f010529e:	72 05                	jb     f01052a5 <printnum+0x30>
f01052a0:	39 45 10             	cmp    %eax,0x10(%ebp)
f01052a3:	77 7a                	ja     f010531f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01052a5:	83 ec 0c             	sub    $0xc,%esp
f01052a8:	ff 75 18             	pushl  0x18(%ebp)
f01052ab:	8b 45 14             	mov    0x14(%ebp),%eax
f01052ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
f01052b1:	53                   	push   %ebx
f01052b2:	ff 75 10             	pushl  0x10(%ebp)
f01052b5:	83 ec 08             	sub    $0x8,%esp
f01052b8:	ff 75 e4             	pushl  -0x1c(%ebp)
f01052bb:	ff 75 e0             	pushl  -0x20(%ebp)
f01052be:	ff 75 dc             	pushl  -0x24(%ebp)
f01052c1:	ff 75 d8             	pushl  -0x28(%ebp)
f01052c4:	e8 87 17 00 00       	call   f0106a50 <__udivdi3>
f01052c9:	83 c4 18             	add    $0x18,%esp
f01052cc:	52                   	push   %edx
f01052cd:	50                   	push   %eax
f01052ce:	89 f2                	mov    %esi,%edx
f01052d0:	89 f8                	mov    %edi,%eax
f01052d2:	e8 9e ff ff ff       	call   f0105275 <printnum>
f01052d7:	83 c4 20             	add    $0x20,%esp
f01052da:	eb 13                	jmp    f01052ef <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01052dc:	83 ec 08             	sub    $0x8,%esp
f01052df:	56                   	push   %esi
f01052e0:	ff 75 18             	pushl  0x18(%ebp)
f01052e3:	ff d7                	call   *%edi
f01052e5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f01052e8:	83 eb 01             	sub    $0x1,%ebx
f01052eb:	85 db                	test   %ebx,%ebx
f01052ed:	7f ed                	jg     f01052dc <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01052ef:	83 ec 08             	sub    $0x8,%esp
f01052f2:	56                   	push   %esi
f01052f3:	83 ec 04             	sub    $0x4,%esp
f01052f6:	ff 75 e4             	pushl  -0x1c(%ebp)
f01052f9:	ff 75 e0             	pushl  -0x20(%ebp)
f01052fc:	ff 75 dc             	pushl  -0x24(%ebp)
f01052ff:	ff 75 d8             	pushl  -0x28(%ebp)
f0105302:	e8 69 18 00 00       	call   f0106b70 <__umoddi3>
f0105307:	83 c4 14             	add    $0x14,%esp
f010530a:	0f be 80 e2 84 10 f0 	movsbl -0xfef7b1e(%eax),%eax
f0105311:	50                   	push   %eax
f0105312:	ff d7                	call   *%edi
}
f0105314:	83 c4 10             	add    $0x10,%esp
f0105317:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010531a:	5b                   	pop    %ebx
f010531b:	5e                   	pop    %esi
f010531c:	5f                   	pop    %edi
f010531d:	5d                   	pop    %ebp
f010531e:	c3                   	ret    
f010531f:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0105322:	eb c4                	jmp    f01052e8 <printnum+0x73>

f0105324 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105324:	55                   	push   %ebp
f0105325:	89 e5                	mov    %esp,%ebp
f0105327:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f010532a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f010532e:	8b 10                	mov    (%eax),%edx
f0105330:	3b 50 04             	cmp    0x4(%eax),%edx
f0105333:	73 0a                	jae    f010533f <sprintputch+0x1b>
		*b->buf++ = ch;
f0105335:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105338:	89 08                	mov    %ecx,(%eax)
f010533a:	8b 45 08             	mov    0x8(%ebp),%eax
f010533d:	88 02                	mov    %al,(%edx)
}
f010533f:	5d                   	pop    %ebp
f0105340:	c3                   	ret    

f0105341 <printfmt>:
{
f0105341:	55                   	push   %ebp
f0105342:	89 e5                	mov    %esp,%ebp
f0105344:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0105347:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010534a:	50                   	push   %eax
f010534b:	ff 75 10             	pushl  0x10(%ebp)
f010534e:	ff 75 0c             	pushl  0xc(%ebp)
f0105351:	ff 75 08             	pushl  0x8(%ebp)
f0105354:	e8 05 00 00 00       	call   f010535e <vprintfmt>
}
f0105359:	83 c4 10             	add    $0x10,%esp
f010535c:	c9                   	leave  
f010535d:	c3                   	ret    

f010535e <vprintfmt>:
{
f010535e:	55                   	push   %ebp
f010535f:	89 e5                	mov    %esp,%ebp
f0105361:	57                   	push   %edi
f0105362:	56                   	push   %esi
f0105363:	53                   	push   %ebx
f0105364:	83 ec 2c             	sub    $0x2c,%esp
f0105367:	8b 75 08             	mov    0x8(%ebp),%esi
f010536a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f010536d:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105370:	e9 c1 03 00 00       	jmp    f0105736 <vprintfmt+0x3d8>
		padc = ' ';
f0105375:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0105379:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0105380:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f0105387:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f010538e:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105393:	8d 47 01             	lea    0x1(%edi),%eax
f0105396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105399:	0f b6 17             	movzbl (%edi),%edx
f010539c:	8d 42 dd             	lea    -0x23(%edx),%eax
f010539f:	3c 55                	cmp    $0x55,%al
f01053a1:	0f 87 12 04 00 00    	ja     f01057b9 <vprintfmt+0x45b>
f01053a7:	0f b6 c0             	movzbl %al,%eax
f01053aa:	ff 24 85 20 86 10 f0 	jmp    *-0xfef79e0(,%eax,4)
f01053b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f01053b4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f01053b8:	eb d9                	jmp    f0105393 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f01053ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f01053bd:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f01053c1:	eb d0                	jmp    f0105393 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f01053c3:	0f b6 d2             	movzbl %dl,%edx
f01053c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f01053c9:	b8 00 00 00 00       	mov    $0x0,%eax
f01053ce:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f01053d1:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01053d4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f01053d8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f01053db:	8d 4a d0             	lea    -0x30(%edx),%ecx
f01053de:	83 f9 09             	cmp    $0x9,%ecx
f01053e1:	77 55                	ja     f0105438 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f01053e3:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f01053e6:	eb e9                	jmp    f01053d1 <vprintfmt+0x73>
			precision = va_arg(ap, int);
f01053e8:	8b 45 14             	mov    0x14(%ebp),%eax
f01053eb:	8b 00                	mov    (%eax),%eax
f01053ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01053f0:	8b 45 14             	mov    0x14(%ebp),%eax
f01053f3:	8d 40 04             	lea    0x4(%eax),%eax
f01053f6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f01053f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f01053fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105400:	79 91                	jns    f0105393 <vprintfmt+0x35>
				width = precision, precision = -1;
f0105402:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105405:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105408:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f010540f:	eb 82                	jmp    f0105393 <vprintfmt+0x35>
f0105411:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105414:	85 c0                	test   %eax,%eax
f0105416:	ba 00 00 00 00       	mov    $0x0,%edx
f010541b:	0f 49 d0             	cmovns %eax,%edx
f010541e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0105421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105424:	e9 6a ff ff ff       	jmp    f0105393 <vprintfmt+0x35>
f0105429:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f010542c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0105433:	e9 5b ff ff ff       	jmp    f0105393 <vprintfmt+0x35>
f0105438:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010543b:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010543e:	eb bc                	jmp    f01053fc <vprintfmt+0x9e>
			lflag++;
f0105440:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105443:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0105446:	e9 48 ff ff ff       	jmp    f0105393 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f010544b:	8b 45 14             	mov    0x14(%ebp),%eax
f010544e:	8d 78 04             	lea    0x4(%eax),%edi
f0105451:	83 ec 08             	sub    $0x8,%esp
f0105454:	53                   	push   %ebx
f0105455:	ff 30                	pushl  (%eax)
f0105457:	ff d6                	call   *%esi
			break;
f0105459:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f010545c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f010545f:	e9 cf 02 00 00       	jmp    f0105733 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
f0105464:	8b 45 14             	mov    0x14(%ebp),%eax
f0105467:	8d 78 04             	lea    0x4(%eax),%edi
f010546a:	8b 00                	mov    (%eax),%eax
f010546c:	99                   	cltd   
f010546d:	31 d0                	xor    %edx,%eax
f010546f:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105471:	83 f8 0f             	cmp    $0xf,%eax
f0105474:	7f 23                	jg     f0105499 <vprintfmt+0x13b>
f0105476:	8b 14 85 80 87 10 f0 	mov    -0xfef7880(,%eax,4),%edx
f010547d:	85 d2                	test   %edx,%edx
f010547f:	74 18                	je     f0105499 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f0105481:	52                   	push   %edx
f0105482:	68 cc 72 10 f0       	push   $0xf01072cc
f0105487:	53                   	push   %ebx
f0105488:	56                   	push   %esi
f0105489:	e8 b3 fe ff ff       	call   f0105341 <printfmt>
f010548e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105491:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105494:	e9 9a 02 00 00       	jmp    f0105733 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
f0105499:	50                   	push   %eax
f010549a:	68 fa 84 10 f0       	push   $0xf01084fa
f010549f:	53                   	push   %ebx
f01054a0:	56                   	push   %esi
f01054a1:	e8 9b fe ff ff       	call   f0105341 <printfmt>
f01054a6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f01054a9:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f01054ac:	e9 82 02 00 00       	jmp    f0105733 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
f01054b1:	8b 45 14             	mov    0x14(%ebp),%eax
f01054b4:	83 c0 04             	add    $0x4,%eax
f01054b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01054ba:	8b 45 14             	mov    0x14(%ebp),%eax
f01054bd:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f01054bf:	85 ff                	test   %edi,%edi
f01054c1:	b8 f3 84 10 f0       	mov    $0xf01084f3,%eax
f01054c6:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f01054c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01054cd:	0f 8e bd 00 00 00    	jle    f0105590 <vprintfmt+0x232>
f01054d3:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f01054d7:	75 0e                	jne    f01054e7 <vprintfmt+0x189>
f01054d9:	89 75 08             	mov    %esi,0x8(%ebp)
f01054dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01054df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f01054e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01054e5:	eb 6d                	jmp    f0105554 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f01054e7:	83 ec 08             	sub    $0x8,%esp
f01054ea:	ff 75 d0             	pushl  -0x30(%ebp)
f01054ed:	57                   	push   %edi
f01054ee:	e8 5c 04 00 00       	call   f010594f <strnlen>
f01054f3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01054f6:	29 c1                	sub    %eax,%ecx
f01054f8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f01054fb:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f01054fe:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0105502:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105505:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105508:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f010550a:	eb 0f                	jmp    f010551b <vprintfmt+0x1bd>
					putch(padc, putdat);
f010550c:	83 ec 08             	sub    $0x8,%esp
f010550f:	53                   	push   %ebx
f0105510:	ff 75 e0             	pushl  -0x20(%ebp)
f0105513:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0105515:	83 ef 01             	sub    $0x1,%edi
f0105518:	83 c4 10             	add    $0x10,%esp
f010551b:	85 ff                	test   %edi,%edi
f010551d:	7f ed                	jg     f010550c <vprintfmt+0x1ae>
f010551f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0105522:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0105525:	85 c9                	test   %ecx,%ecx
f0105527:	b8 00 00 00 00       	mov    $0x0,%eax
f010552c:	0f 49 c1             	cmovns %ecx,%eax
f010552f:	29 c1                	sub    %eax,%ecx
f0105531:	89 75 08             	mov    %esi,0x8(%ebp)
f0105534:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105537:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f010553a:	89 cb                	mov    %ecx,%ebx
f010553c:	eb 16                	jmp    f0105554 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f010553e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105542:	75 31                	jne    f0105575 <vprintfmt+0x217>
					putch(ch, putdat);
f0105544:	83 ec 08             	sub    $0x8,%esp
f0105547:	ff 75 0c             	pushl  0xc(%ebp)
f010554a:	50                   	push   %eax
f010554b:	ff 55 08             	call   *0x8(%ebp)
f010554e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105551:	83 eb 01             	sub    $0x1,%ebx
f0105554:	83 c7 01             	add    $0x1,%edi
f0105557:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f010555b:	0f be c2             	movsbl %dl,%eax
f010555e:	85 c0                	test   %eax,%eax
f0105560:	74 59                	je     f01055bb <vprintfmt+0x25d>
f0105562:	85 f6                	test   %esi,%esi
f0105564:	78 d8                	js     f010553e <vprintfmt+0x1e0>
f0105566:	83 ee 01             	sub    $0x1,%esi
f0105569:	79 d3                	jns    f010553e <vprintfmt+0x1e0>
f010556b:	89 df                	mov    %ebx,%edi
f010556d:	8b 75 08             	mov    0x8(%ebp),%esi
f0105570:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105573:	eb 37                	jmp    f01055ac <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f0105575:	0f be d2             	movsbl %dl,%edx
f0105578:	83 ea 20             	sub    $0x20,%edx
f010557b:	83 fa 5e             	cmp    $0x5e,%edx
f010557e:	76 c4                	jbe    f0105544 <vprintfmt+0x1e6>
					putch('?', putdat);
f0105580:	83 ec 08             	sub    $0x8,%esp
f0105583:	ff 75 0c             	pushl  0xc(%ebp)
f0105586:	6a 3f                	push   $0x3f
f0105588:	ff 55 08             	call   *0x8(%ebp)
f010558b:	83 c4 10             	add    $0x10,%esp
f010558e:	eb c1                	jmp    f0105551 <vprintfmt+0x1f3>
f0105590:	89 75 08             	mov    %esi,0x8(%ebp)
f0105593:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105596:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105599:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010559c:	eb b6                	jmp    f0105554 <vprintfmt+0x1f6>
				putch(' ', putdat);
f010559e:	83 ec 08             	sub    $0x8,%esp
f01055a1:	53                   	push   %ebx
f01055a2:	6a 20                	push   $0x20
f01055a4:	ff d6                	call   *%esi
			for (; width > 0; width--)
f01055a6:	83 ef 01             	sub    $0x1,%edi
f01055a9:	83 c4 10             	add    $0x10,%esp
f01055ac:	85 ff                	test   %edi,%edi
f01055ae:	7f ee                	jg     f010559e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f01055b0:	8b 45 cc             	mov    -0x34(%ebp),%eax
f01055b3:	89 45 14             	mov    %eax,0x14(%ebp)
f01055b6:	e9 78 01 00 00       	jmp    f0105733 <vprintfmt+0x3d5>
f01055bb:	89 df                	mov    %ebx,%edi
f01055bd:	8b 75 08             	mov    0x8(%ebp),%esi
f01055c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01055c3:	eb e7                	jmp    f01055ac <vprintfmt+0x24e>
	if (lflag >= 2)
f01055c5:	83 f9 01             	cmp    $0x1,%ecx
f01055c8:	7e 3f                	jle    f0105609 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f01055ca:	8b 45 14             	mov    0x14(%ebp),%eax
f01055cd:	8b 50 04             	mov    0x4(%eax),%edx
f01055d0:	8b 00                	mov    (%eax),%eax
f01055d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01055d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
f01055d8:	8b 45 14             	mov    0x14(%ebp),%eax
f01055db:	8d 40 08             	lea    0x8(%eax),%eax
f01055de:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f01055e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01055e5:	79 5c                	jns    f0105643 <vprintfmt+0x2e5>
				putch('-', putdat);
f01055e7:	83 ec 08             	sub    $0x8,%esp
f01055ea:	53                   	push   %ebx
f01055eb:	6a 2d                	push   $0x2d
f01055ed:	ff d6                	call   *%esi
				num = -(long long) num;
f01055ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01055f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01055f5:	f7 da                	neg    %edx
f01055f7:	83 d1 00             	adc    $0x0,%ecx
f01055fa:	f7 d9                	neg    %ecx
f01055fc:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01055ff:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105604:	e9 10 01 00 00       	jmp    f0105719 <vprintfmt+0x3bb>
	else if (lflag)
f0105609:	85 c9                	test   %ecx,%ecx
f010560b:	75 1b                	jne    f0105628 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f010560d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105610:	8b 00                	mov    (%eax),%eax
f0105612:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105615:	89 c1                	mov    %eax,%ecx
f0105617:	c1 f9 1f             	sar    $0x1f,%ecx
f010561a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010561d:	8b 45 14             	mov    0x14(%ebp),%eax
f0105620:	8d 40 04             	lea    0x4(%eax),%eax
f0105623:	89 45 14             	mov    %eax,0x14(%ebp)
f0105626:	eb b9                	jmp    f01055e1 <vprintfmt+0x283>
		return va_arg(*ap, long);
f0105628:	8b 45 14             	mov    0x14(%ebp),%eax
f010562b:	8b 00                	mov    (%eax),%eax
f010562d:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105630:	89 c1                	mov    %eax,%ecx
f0105632:	c1 f9 1f             	sar    $0x1f,%ecx
f0105635:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105638:	8b 45 14             	mov    0x14(%ebp),%eax
f010563b:	8d 40 04             	lea    0x4(%eax),%eax
f010563e:	89 45 14             	mov    %eax,0x14(%ebp)
f0105641:	eb 9e                	jmp    f01055e1 <vprintfmt+0x283>
			num = getint(&ap, lflag);
f0105643:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105646:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f0105649:	b8 0a 00 00 00       	mov    $0xa,%eax
f010564e:	e9 c6 00 00 00       	jmp    f0105719 <vprintfmt+0x3bb>
	if (lflag >= 2)
f0105653:	83 f9 01             	cmp    $0x1,%ecx
f0105656:	7e 18                	jle    f0105670 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
f0105658:	8b 45 14             	mov    0x14(%ebp),%eax
f010565b:	8b 10                	mov    (%eax),%edx
f010565d:	8b 48 04             	mov    0x4(%eax),%ecx
f0105660:	8d 40 08             	lea    0x8(%eax),%eax
f0105663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105666:	b8 0a 00 00 00       	mov    $0xa,%eax
f010566b:	e9 a9 00 00 00       	jmp    f0105719 <vprintfmt+0x3bb>
	else if (lflag)
f0105670:	85 c9                	test   %ecx,%ecx
f0105672:	75 1a                	jne    f010568e <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
f0105674:	8b 45 14             	mov    0x14(%ebp),%eax
f0105677:	8b 10                	mov    (%eax),%edx
f0105679:	b9 00 00 00 00       	mov    $0x0,%ecx
f010567e:	8d 40 04             	lea    0x4(%eax),%eax
f0105681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105684:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105689:	e9 8b 00 00 00       	jmp    f0105719 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f010568e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105691:	8b 10                	mov    (%eax),%edx
f0105693:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105698:	8d 40 04             	lea    0x4(%eax),%eax
f010569b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010569e:	b8 0a 00 00 00       	mov    $0xa,%eax
f01056a3:	eb 74                	jmp    f0105719 <vprintfmt+0x3bb>
	if (lflag >= 2)
f01056a5:	83 f9 01             	cmp    $0x1,%ecx
f01056a8:	7e 15                	jle    f01056bf <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
f01056aa:	8b 45 14             	mov    0x14(%ebp),%eax
f01056ad:	8b 10                	mov    (%eax),%edx
f01056af:	8b 48 04             	mov    0x4(%eax),%ecx
f01056b2:	8d 40 08             	lea    0x8(%eax),%eax
f01056b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01056b8:	b8 08 00 00 00       	mov    $0x8,%eax
f01056bd:	eb 5a                	jmp    f0105719 <vprintfmt+0x3bb>
	else if (lflag)
f01056bf:	85 c9                	test   %ecx,%ecx
f01056c1:	75 17                	jne    f01056da <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
f01056c3:	8b 45 14             	mov    0x14(%ebp),%eax
f01056c6:	8b 10                	mov    (%eax),%edx
f01056c8:	b9 00 00 00 00       	mov    $0x0,%ecx
f01056cd:	8d 40 04             	lea    0x4(%eax),%eax
f01056d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01056d3:	b8 08 00 00 00       	mov    $0x8,%eax
f01056d8:	eb 3f                	jmp    f0105719 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f01056da:	8b 45 14             	mov    0x14(%ebp),%eax
f01056dd:	8b 10                	mov    (%eax),%edx
f01056df:	b9 00 00 00 00       	mov    $0x0,%ecx
f01056e4:	8d 40 04             	lea    0x4(%eax),%eax
f01056e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f01056ea:	b8 08 00 00 00       	mov    $0x8,%eax
f01056ef:	eb 28                	jmp    f0105719 <vprintfmt+0x3bb>
			putch('0', putdat);
f01056f1:	83 ec 08             	sub    $0x8,%esp
f01056f4:	53                   	push   %ebx
f01056f5:	6a 30                	push   $0x30
f01056f7:	ff d6                	call   *%esi
			putch('x', putdat);
f01056f9:	83 c4 08             	add    $0x8,%esp
f01056fc:	53                   	push   %ebx
f01056fd:	6a 78                	push   $0x78
f01056ff:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105701:	8b 45 14             	mov    0x14(%ebp),%eax
f0105704:	8b 10                	mov    (%eax),%edx
f0105706:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010570b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f010570e:	8d 40 04             	lea    0x4(%eax),%eax
f0105711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105714:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f0105719:	83 ec 0c             	sub    $0xc,%esp
f010571c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f0105720:	57                   	push   %edi
f0105721:	ff 75 e0             	pushl  -0x20(%ebp)
f0105724:	50                   	push   %eax
f0105725:	51                   	push   %ecx
f0105726:	52                   	push   %edx
f0105727:	89 da                	mov    %ebx,%edx
f0105729:	89 f0                	mov    %esi,%eax
f010572b:	e8 45 fb ff ff       	call   f0105275 <printnum>
			break;
f0105730:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f0105733:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105736:	83 c7 01             	add    $0x1,%edi
f0105739:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f010573d:	83 f8 25             	cmp    $0x25,%eax
f0105740:	0f 84 2f fc ff ff    	je     f0105375 <vprintfmt+0x17>
			if (ch == '\0')
f0105746:	85 c0                	test   %eax,%eax
f0105748:	0f 84 8b 00 00 00    	je     f01057d9 <vprintfmt+0x47b>
			putch(ch, putdat);
f010574e:	83 ec 08             	sub    $0x8,%esp
f0105751:	53                   	push   %ebx
f0105752:	50                   	push   %eax
f0105753:	ff d6                	call   *%esi
f0105755:	83 c4 10             	add    $0x10,%esp
f0105758:	eb dc                	jmp    f0105736 <vprintfmt+0x3d8>
	if (lflag >= 2)
f010575a:	83 f9 01             	cmp    $0x1,%ecx
f010575d:	7e 15                	jle    f0105774 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
f010575f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105762:	8b 10                	mov    (%eax),%edx
f0105764:	8b 48 04             	mov    0x4(%eax),%ecx
f0105767:	8d 40 08             	lea    0x8(%eax),%eax
f010576a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010576d:	b8 10 00 00 00       	mov    $0x10,%eax
f0105772:	eb a5                	jmp    f0105719 <vprintfmt+0x3bb>
	else if (lflag)
f0105774:	85 c9                	test   %ecx,%ecx
f0105776:	75 17                	jne    f010578f <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
f0105778:	8b 45 14             	mov    0x14(%ebp),%eax
f010577b:	8b 10                	mov    (%eax),%edx
f010577d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105782:	8d 40 04             	lea    0x4(%eax),%eax
f0105785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105788:	b8 10 00 00 00       	mov    $0x10,%eax
f010578d:	eb 8a                	jmp    f0105719 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f010578f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105792:	8b 10                	mov    (%eax),%edx
f0105794:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105799:	8d 40 04             	lea    0x4(%eax),%eax
f010579c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010579f:	b8 10 00 00 00       	mov    $0x10,%eax
f01057a4:	e9 70 ff ff ff       	jmp    f0105719 <vprintfmt+0x3bb>
			putch(ch, putdat);
f01057a9:	83 ec 08             	sub    $0x8,%esp
f01057ac:	53                   	push   %ebx
f01057ad:	6a 25                	push   $0x25
f01057af:	ff d6                	call   *%esi
			break;
f01057b1:	83 c4 10             	add    $0x10,%esp
f01057b4:	e9 7a ff ff ff       	jmp    f0105733 <vprintfmt+0x3d5>
			putch('%', putdat);
f01057b9:	83 ec 08             	sub    $0x8,%esp
f01057bc:	53                   	push   %ebx
f01057bd:	6a 25                	push   $0x25
f01057bf:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f01057c1:	83 c4 10             	add    $0x10,%esp
f01057c4:	89 f8                	mov    %edi,%eax
f01057c6:	eb 03                	jmp    f01057cb <vprintfmt+0x46d>
f01057c8:	83 e8 01             	sub    $0x1,%eax
f01057cb:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f01057cf:	75 f7                	jne    f01057c8 <vprintfmt+0x46a>
f01057d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01057d4:	e9 5a ff ff ff       	jmp    f0105733 <vprintfmt+0x3d5>
}
f01057d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01057dc:	5b                   	pop    %ebx
f01057dd:	5e                   	pop    %esi
f01057de:	5f                   	pop    %edi
f01057df:	5d                   	pop    %ebp
f01057e0:	c3                   	ret    

f01057e1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01057e1:	55                   	push   %ebp
f01057e2:	89 e5                	mov    %esp,%ebp
f01057e4:	83 ec 18             	sub    $0x18,%esp
f01057e7:	8b 45 08             	mov    0x8(%ebp),%eax
f01057ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01057ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01057f0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01057f4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01057f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01057fe:	85 c0                	test   %eax,%eax
f0105800:	74 26                	je     f0105828 <vsnprintf+0x47>
f0105802:	85 d2                	test   %edx,%edx
f0105804:	7e 22                	jle    f0105828 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105806:	ff 75 14             	pushl  0x14(%ebp)
f0105809:	ff 75 10             	pushl  0x10(%ebp)
f010580c:	8d 45 ec             	lea    -0x14(%ebp),%eax
f010580f:	50                   	push   %eax
f0105810:	68 24 53 10 f0       	push   $0xf0105324
f0105815:	e8 44 fb ff ff       	call   f010535e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f010581a:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010581d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105820:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105823:	83 c4 10             	add    $0x10,%esp
}
f0105826:	c9                   	leave  
f0105827:	c3                   	ret    
		return -E_INVAL;
f0105828:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010582d:	eb f7                	jmp    f0105826 <vsnprintf+0x45>

f010582f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010582f:	55                   	push   %ebp
f0105830:	89 e5                	mov    %esp,%ebp
f0105832:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105835:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105838:	50                   	push   %eax
f0105839:	ff 75 10             	pushl  0x10(%ebp)
f010583c:	ff 75 0c             	pushl  0xc(%ebp)
f010583f:	ff 75 08             	pushl  0x8(%ebp)
f0105842:	e8 9a ff ff ff       	call   f01057e1 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105847:	c9                   	leave  
f0105848:	c3                   	ret    

f0105849 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105849:	55                   	push   %ebp
f010584a:	89 e5                	mov    %esp,%ebp
f010584c:	57                   	push   %edi
f010584d:	56                   	push   %esi
f010584e:	53                   	push   %ebx
f010584f:	83 ec 0c             	sub    $0xc,%esp
f0105852:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105855:	85 c0                	test   %eax,%eax
f0105857:	74 11                	je     f010586a <readline+0x21>
		cprintf("%s", prompt);
f0105859:	83 ec 08             	sub    $0x8,%esp
f010585c:	50                   	push   %eax
f010585d:	68 cc 72 10 f0       	push   $0xf01072cc
f0105862:	e8 c9 e0 ff ff       	call   f0103930 <cprintf>
f0105867:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f010586a:	83 ec 0c             	sub    $0xc,%esp
f010586d:	6a 00                	push   $0x0
f010586f:	e8 68 af ff ff       	call   f01007dc <iscons>
f0105874:	89 c7                	mov    %eax,%edi
f0105876:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105879:	be 00 00 00 00       	mov    $0x0,%esi
f010587e:	eb 4b                	jmp    f01058cb <readline+0x82>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f0105880:	b8 00 00 00 00       	mov    $0x0,%eax
			if (c != -E_EOF)
f0105885:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105888:	75 08                	jne    f0105892 <readline+0x49>
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f010588a:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010588d:	5b                   	pop    %ebx
f010588e:	5e                   	pop    %esi
f010588f:	5f                   	pop    %edi
f0105890:	5d                   	pop    %ebp
f0105891:	c3                   	ret    
				cprintf("read error: %e\n", c);
f0105892:	83 ec 08             	sub    $0x8,%esp
f0105895:	53                   	push   %ebx
f0105896:	68 df 87 10 f0       	push   $0xf01087df
f010589b:	e8 90 e0 ff ff       	call   f0103930 <cprintf>
f01058a0:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01058a3:	b8 00 00 00 00       	mov    $0x0,%eax
f01058a8:	eb e0                	jmp    f010588a <readline+0x41>
			if (echoing)
f01058aa:	85 ff                	test   %edi,%edi
f01058ac:	75 05                	jne    f01058b3 <readline+0x6a>
			i--;
f01058ae:	83 ee 01             	sub    $0x1,%esi
f01058b1:	eb 18                	jmp    f01058cb <readline+0x82>
				cputchar('\b');
f01058b3:	83 ec 0c             	sub    $0xc,%esp
f01058b6:	6a 08                	push   $0x8
f01058b8:	e8 fe ae ff ff       	call   f01007bb <cputchar>
f01058bd:	83 c4 10             	add    $0x10,%esp
f01058c0:	eb ec                	jmp    f01058ae <readline+0x65>
			buf[i++] = c;
f01058c2:	88 9e 80 ea 2a f0    	mov    %bl,-0xfd51580(%esi)
f01058c8:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f01058cb:	e8 fb ae ff ff       	call   f01007cb <getchar>
f01058d0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f01058d2:	85 c0                	test   %eax,%eax
f01058d4:	78 aa                	js     f0105880 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01058d6:	83 f8 08             	cmp    $0x8,%eax
f01058d9:	0f 94 c2             	sete   %dl
f01058dc:	83 f8 7f             	cmp    $0x7f,%eax
f01058df:	0f 94 c0             	sete   %al
f01058e2:	08 c2                	or     %al,%dl
f01058e4:	74 04                	je     f01058ea <readline+0xa1>
f01058e6:	85 f6                	test   %esi,%esi
f01058e8:	7f c0                	jg     f01058aa <readline+0x61>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01058ea:	83 fb 1f             	cmp    $0x1f,%ebx
f01058ed:	7e 1a                	jle    f0105909 <readline+0xc0>
f01058ef:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01058f5:	7f 12                	jg     f0105909 <readline+0xc0>
			if (echoing)
f01058f7:	85 ff                	test   %edi,%edi
f01058f9:	74 c7                	je     f01058c2 <readline+0x79>
				cputchar(c);
f01058fb:	83 ec 0c             	sub    $0xc,%esp
f01058fe:	53                   	push   %ebx
f01058ff:	e8 b7 ae ff ff       	call   f01007bb <cputchar>
f0105904:	83 c4 10             	add    $0x10,%esp
f0105907:	eb b9                	jmp    f01058c2 <readline+0x79>
		} else if (c == '\n' || c == '\r') {
f0105909:	83 fb 0a             	cmp    $0xa,%ebx
f010590c:	74 05                	je     f0105913 <readline+0xca>
f010590e:	83 fb 0d             	cmp    $0xd,%ebx
f0105911:	75 b8                	jne    f01058cb <readline+0x82>
			if (echoing)
f0105913:	85 ff                	test   %edi,%edi
f0105915:	75 11                	jne    f0105928 <readline+0xdf>
			buf[i] = 0;
f0105917:	c6 86 80 ea 2a f0 00 	movb   $0x0,-0xfd51580(%esi)
			return buf;
f010591e:	b8 80 ea 2a f0       	mov    $0xf02aea80,%eax
f0105923:	e9 62 ff ff ff       	jmp    f010588a <readline+0x41>
				cputchar('\n');
f0105928:	83 ec 0c             	sub    $0xc,%esp
f010592b:	6a 0a                	push   $0xa
f010592d:	e8 89 ae ff ff       	call   f01007bb <cputchar>
f0105932:	83 c4 10             	add    $0x10,%esp
f0105935:	eb e0                	jmp    f0105917 <readline+0xce>

f0105937 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105937:	55                   	push   %ebp
f0105938:	89 e5                	mov    %esp,%ebp
f010593a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f010593d:	b8 00 00 00 00       	mov    $0x0,%eax
f0105942:	eb 03                	jmp    f0105947 <strlen+0x10>
		n++;
f0105944:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f0105947:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f010594b:	75 f7                	jne    f0105944 <strlen+0xd>
	return n;
}
f010594d:	5d                   	pop    %ebp
f010594e:	c3                   	ret    

f010594f <strnlen>:

int
strnlen(const char *s, size_t size)
{
f010594f:	55                   	push   %ebp
f0105950:	89 e5                	mov    %esp,%ebp
f0105952:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105955:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105958:	b8 00 00 00 00       	mov    $0x0,%eax
f010595d:	eb 03                	jmp    f0105962 <strnlen+0x13>
		n++;
f010595f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105962:	39 d0                	cmp    %edx,%eax
f0105964:	74 06                	je     f010596c <strnlen+0x1d>
f0105966:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010596a:	75 f3                	jne    f010595f <strnlen+0x10>
	return n;
}
f010596c:	5d                   	pop    %ebp
f010596d:	c3                   	ret    

f010596e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010596e:	55                   	push   %ebp
f010596f:	89 e5                	mov    %esp,%ebp
f0105971:	53                   	push   %ebx
f0105972:	8b 45 08             	mov    0x8(%ebp),%eax
f0105975:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105978:	89 c2                	mov    %eax,%edx
f010597a:	83 c1 01             	add    $0x1,%ecx
f010597d:	83 c2 01             	add    $0x1,%edx
f0105980:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0105984:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105987:	84 db                	test   %bl,%bl
f0105989:	75 ef                	jne    f010597a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f010598b:	5b                   	pop    %ebx
f010598c:	5d                   	pop    %ebp
f010598d:	c3                   	ret    

f010598e <strcat>:

char *
strcat(char *dst, const char *src)
{
f010598e:	55                   	push   %ebp
f010598f:	89 e5                	mov    %esp,%ebp
f0105991:	53                   	push   %ebx
f0105992:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105995:	53                   	push   %ebx
f0105996:	e8 9c ff ff ff       	call   f0105937 <strlen>
f010599b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f010599e:	ff 75 0c             	pushl  0xc(%ebp)
f01059a1:	01 d8                	add    %ebx,%eax
f01059a3:	50                   	push   %eax
f01059a4:	e8 c5 ff ff ff       	call   f010596e <strcpy>
	return dst;
}
f01059a9:	89 d8                	mov    %ebx,%eax
f01059ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01059ae:	c9                   	leave  
f01059af:	c3                   	ret    

f01059b0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01059b0:	55                   	push   %ebp
f01059b1:	89 e5                	mov    %esp,%ebp
f01059b3:	56                   	push   %esi
f01059b4:	53                   	push   %ebx
f01059b5:	8b 75 08             	mov    0x8(%ebp),%esi
f01059b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01059bb:	89 f3                	mov    %esi,%ebx
f01059bd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01059c0:	89 f2                	mov    %esi,%edx
f01059c2:	eb 0f                	jmp    f01059d3 <strncpy+0x23>
		*dst++ = *src;
f01059c4:	83 c2 01             	add    $0x1,%edx
f01059c7:	0f b6 01             	movzbl (%ecx),%eax
f01059ca:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01059cd:	80 39 01             	cmpb   $0x1,(%ecx)
f01059d0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f01059d3:	39 da                	cmp    %ebx,%edx
f01059d5:	75 ed                	jne    f01059c4 <strncpy+0x14>
	}
	return ret;
}
f01059d7:	89 f0                	mov    %esi,%eax
f01059d9:	5b                   	pop    %ebx
f01059da:	5e                   	pop    %esi
f01059db:	5d                   	pop    %ebp
f01059dc:	c3                   	ret    

f01059dd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01059dd:	55                   	push   %ebp
f01059de:	89 e5                	mov    %esp,%ebp
f01059e0:	56                   	push   %esi
f01059e1:	53                   	push   %ebx
f01059e2:	8b 75 08             	mov    0x8(%ebp),%esi
f01059e5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01059e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01059eb:	89 f0                	mov    %esi,%eax
f01059ed:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01059f1:	85 c9                	test   %ecx,%ecx
f01059f3:	75 0b                	jne    f0105a00 <strlcpy+0x23>
f01059f5:	eb 17                	jmp    f0105a0e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01059f7:	83 c2 01             	add    $0x1,%edx
f01059fa:	83 c0 01             	add    $0x1,%eax
f01059fd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0105a00:	39 d8                	cmp    %ebx,%eax
f0105a02:	74 07                	je     f0105a0b <strlcpy+0x2e>
f0105a04:	0f b6 0a             	movzbl (%edx),%ecx
f0105a07:	84 c9                	test   %cl,%cl
f0105a09:	75 ec                	jne    f01059f7 <strlcpy+0x1a>
		*dst = '\0';
f0105a0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105a0e:	29 f0                	sub    %esi,%eax
}
f0105a10:	5b                   	pop    %ebx
f0105a11:	5e                   	pop    %esi
f0105a12:	5d                   	pop    %ebp
f0105a13:	c3                   	ret    

f0105a14 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105a14:	55                   	push   %ebp
f0105a15:	89 e5                	mov    %esp,%ebp
f0105a17:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105a1d:	eb 06                	jmp    f0105a25 <strcmp+0x11>
		p++, q++;
f0105a1f:	83 c1 01             	add    $0x1,%ecx
f0105a22:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f0105a25:	0f b6 01             	movzbl (%ecx),%eax
f0105a28:	84 c0                	test   %al,%al
f0105a2a:	74 04                	je     f0105a30 <strcmp+0x1c>
f0105a2c:	3a 02                	cmp    (%edx),%al
f0105a2e:	74 ef                	je     f0105a1f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105a30:	0f b6 c0             	movzbl %al,%eax
f0105a33:	0f b6 12             	movzbl (%edx),%edx
f0105a36:	29 d0                	sub    %edx,%eax
}
f0105a38:	5d                   	pop    %ebp
f0105a39:	c3                   	ret    

f0105a3a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105a3a:	55                   	push   %ebp
f0105a3b:	89 e5                	mov    %esp,%ebp
f0105a3d:	53                   	push   %ebx
f0105a3e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a41:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105a44:	89 c3                	mov    %eax,%ebx
f0105a46:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105a49:	eb 06                	jmp    f0105a51 <strncmp+0x17>
		n--, p++, q++;
f0105a4b:	83 c0 01             	add    $0x1,%eax
f0105a4e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f0105a51:	39 d8                	cmp    %ebx,%eax
f0105a53:	74 16                	je     f0105a6b <strncmp+0x31>
f0105a55:	0f b6 08             	movzbl (%eax),%ecx
f0105a58:	84 c9                	test   %cl,%cl
f0105a5a:	74 04                	je     f0105a60 <strncmp+0x26>
f0105a5c:	3a 0a                	cmp    (%edx),%cl
f0105a5e:	74 eb                	je     f0105a4b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105a60:	0f b6 00             	movzbl (%eax),%eax
f0105a63:	0f b6 12             	movzbl (%edx),%edx
f0105a66:	29 d0                	sub    %edx,%eax
}
f0105a68:	5b                   	pop    %ebx
f0105a69:	5d                   	pop    %ebp
f0105a6a:	c3                   	ret    
		return 0;
f0105a6b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105a70:	eb f6                	jmp    f0105a68 <strncmp+0x2e>

f0105a72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105a72:	55                   	push   %ebp
f0105a73:	89 e5                	mov    %esp,%ebp
f0105a75:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105a7c:	0f b6 10             	movzbl (%eax),%edx
f0105a7f:	84 d2                	test   %dl,%dl
f0105a81:	74 09                	je     f0105a8c <strchr+0x1a>
		if (*s == c)
f0105a83:	38 ca                	cmp    %cl,%dl
f0105a85:	74 0a                	je     f0105a91 <strchr+0x1f>
	for (; *s; s++)
f0105a87:	83 c0 01             	add    $0x1,%eax
f0105a8a:	eb f0                	jmp    f0105a7c <strchr+0xa>
			return (char *) s;
	return 0;
f0105a8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105a91:	5d                   	pop    %ebp
f0105a92:	c3                   	ret    

f0105a93 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105a93:	55                   	push   %ebp
f0105a94:	89 e5                	mov    %esp,%ebp
f0105a96:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a99:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105a9d:	eb 03                	jmp    f0105aa2 <strfind+0xf>
f0105a9f:	83 c0 01             	add    $0x1,%eax
f0105aa2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0105aa5:	38 ca                	cmp    %cl,%dl
f0105aa7:	74 04                	je     f0105aad <strfind+0x1a>
f0105aa9:	84 d2                	test   %dl,%dl
f0105aab:	75 f2                	jne    f0105a9f <strfind+0xc>
			break;
	return (char *) s;
}
f0105aad:	5d                   	pop    %ebp
f0105aae:	c3                   	ret    

f0105aaf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105aaf:	55                   	push   %ebp
f0105ab0:	89 e5                	mov    %esp,%ebp
f0105ab2:	57                   	push   %edi
f0105ab3:	56                   	push   %esi
f0105ab4:	53                   	push   %ebx
f0105ab5:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105abb:	85 c9                	test   %ecx,%ecx
f0105abd:	74 13                	je     f0105ad2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105abf:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0105ac5:	75 05                	jne    f0105acc <memset+0x1d>
f0105ac7:	f6 c1 03             	test   $0x3,%cl
f0105aca:	74 0d                	je     f0105ad9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105acc:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105acf:	fc                   	cld    
f0105ad0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105ad2:	89 f8                	mov    %edi,%eax
f0105ad4:	5b                   	pop    %ebx
f0105ad5:	5e                   	pop    %esi
f0105ad6:	5f                   	pop    %edi
f0105ad7:	5d                   	pop    %ebp
f0105ad8:	c3                   	ret    
		c &= 0xFF;
f0105ad9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105add:	89 d3                	mov    %edx,%ebx
f0105adf:	c1 e3 08             	shl    $0x8,%ebx
f0105ae2:	89 d0                	mov    %edx,%eax
f0105ae4:	c1 e0 18             	shl    $0x18,%eax
f0105ae7:	89 d6                	mov    %edx,%esi
f0105ae9:	c1 e6 10             	shl    $0x10,%esi
f0105aec:	09 f0                	or     %esi,%eax
f0105aee:	09 c2                	or     %eax,%edx
f0105af0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0105af2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105af5:	89 d0                	mov    %edx,%eax
f0105af7:	fc                   	cld    
f0105af8:	f3 ab                	rep stos %eax,%es:(%edi)
f0105afa:	eb d6                	jmp    f0105ad2 <memset+0x23>

f0105afc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105afc:	55                   	push   %ebp
f0105afd:	89 e5                	mov    %esp,%ebp
f0105aff:	57                   	push   %edi
f0105b00:	56                   	push   %esi
f0105b01:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b04:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105b0a:	39 c6                	cmp    %eax,%esi
f0105b0c:	73 35                	jae    f0105b43 <memmove+0x47>
f0105b0e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105b11:	39 c2                	cmp    %eax,%edx
f0105b13:	76 2e                	jbe    f0105b43 <memmove+0x47>
		s += n;
		d += n;
f0105b15:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105b18:	89 d6                	mov    %edx,%esi
f0105b1a:	09 fe                	or     %edi,%esi
f0105b1c:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105b22:	74 0c                	je     f0105b30 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105b24:	83 ef 01             	sub    $0x1,%edi
f0105b27:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105b2a:	fd                   	std    
f0105b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105b2d:	fc                   	cld    
f0105b2e:	eb 21                	jmp    f0105b51 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105b30:	f6 c1 03             	test   $0x3,%cl
f0105b33:	75 ef                	jne    f0105b24 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105b35:	83 ef 04             	sub    $0x4,%edi
f0105b38:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105b3b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105b3e:	fd                   	std    
f0105b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105b41:	eb ea                	jmp    f0105b2d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105b43:	89 f2                	mov    %esi,%edx
f0105b45:	09 c2                	or     %eax,%edx
f0105b47:	f6 c2 03             	test   $0x3,%dl
f0105b4a:	74 09                	je     f0105b55 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0105b4c:	89 c7                	mov    %eax,%edi
f0105b4e:	fc                   	cld    
f0105b4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105b51:	5e                   	pop    %esi
f0105b52:	5f                   	pop    %edi
f0105b53:	5d                   	pop    %ebp
f0105b54:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105b55:	f6 c1 03             	test   $0x3,%cl
f0105b58:	75 f2                	jne    f0105b4c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105b5a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105b5d:	89 c7                	mov    %eax,%edi
f0105b5f:	fc                   	cld    
f0105b60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105b62:	eb ed                	jmp    f0105b51 <memmove+0x55>

f0105b64 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105b64:	55                   	push   %ebp
f0105b65:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0105b67:	ff 75 10             	pushl  0x10(%ebp)
f0105b6a:	ff 75 0c             	pushl  0xc(%ebp)
f0105b6d:	ff 75 08             	pushl  0x8(%ebp)
f0105b70:	e8 87 ff ff ff       	call   f0105afc <memmove>
}
f0105b75:	c9                   	leave  
f0105b76:	c3                   	ret    

f0105b77 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105b77:	55                   	push   %ebp
f0105b78:	89 e5                	mov    %esp,%ebp
f0105b7a:	56                   	push   %esi
f0105b7b:	53                   	push   %ebx
f0105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
f0105b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105b82:	89 c6                	mov    %eax,%esi
f0105b84:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105b87:	39 f0                	cmp    %esi,%eax
f0105b89:	74 1c                	je     f0105ba7 <memcmp+0x30>
		if (*s1 != *s2)
f0105b8b:	0f b6 08             	movzbl (%eax),%ecx
f0105b8e:	0f b6 1a             	movzbl (%edx),%ebx
f0105b91:	38 d9                	cmp    %bl,%cl
f0105b93:	75 08                	jne    f0105b9d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105b95:	83 c0 01             	add    $0x1,%eax
f0105b98:	83 c2 01             	add    $0x1,%edx
f0105b9b:	eb ea                	jmp    f0105b87 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0105b9d:	0f b6 c1             	movzbl %cl,%eax
f0105ba0:	0f b6 db             	movzbl %bl,%ebx
f0105ba3:	29 d8                	sub    %ebx,%eax
f0105ba5:	eb 05                	jmp    f0105bac <memcmp+0x35>
	}

	return 0;
f0105ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105bac:	5b                   	pop    %ebx
f0105bad:	5e                   	pop    %esi
f0105bae:	5d                   	pop    %ebp
f0105baf:	c3                   	ret    

f0105bb0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105bb0:	55                   	push   %ebp
f0105bb1:	89 e5                	mov    %esp,%ebp
f0105bb3:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105bb9:	89 c2                	mov    %eax,%edx
f0105bbb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105bbe:	39 d0                	cmp    %edx,%eax
f0105bc0:	73 09                	jae    f0105bcb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105bc2:	38 08                	cmp    %cl,(%eax)
f0105bc4:	74 05                	je     f0105bcb <memfind+0x1b>
	for (; s < ends; s++)
f0105bc6:	83 c0 01             	add    $0x1,%eax
f0105bc9:	eb f3                	jmp    f0105bbe <memfind+0xe>
			break;
	return (void *) s;
}
f0105bcb:	5d                   	pop    %ebp
f0105bcc:	c3                   	ret    

f0105bcd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105bcd:	55                   	push   %ebp
f0105bce:	89 e5                	mov    %esp,%ebp
f0105bd0:	57                   	push   %edi
f0105bd1:	56                   	push   %esi
f0105bd2:	53                   	push   %ebx
f0105bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105bd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105bd9:	eb 03                	jmp    f0105bde <strtol+0x11>
		s++;
f0105bdb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f0105bde:	0f b6 01             	movzbl (%ecx),%eax
f0105be1:	3c 20                	cmp    $0x20,%al
f0105be3:	74 f6                	je     f0105bdb <strtol+0xe>
f0105be5:	3c 09                	cmp    $0x9,%al
f0105be7:	74 f2                	je     f0105bdb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0105be9:	3c 2b                	cmp    $0x2b,%al
f0105beb:	74 2e                	je     f0105c1b <strtol+0x4e>
	int neg = 0;
f0105bed:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0105bf2:	3c 2d                	cmp    $0x2d,%al
f0105bf4:	74 2f                	je     f0105c25 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105bf6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f0105bfc:	75 05                	jne    f0105c03 <strtol+0x36>
f0105bfe:	80 39 30             	cmpb   $0x30,(%ecx)
f0105c01:	74 2c                	je     f0105c2f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0105c03:	85 db                	test   %ebx,%ebx
f0105c05:	75 0a                	jne    f0105c11 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105c07:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f0105c0c:	80 39 30             	cmpb   $0x30,(%ecx)
f0105c0f:	74 28                	je     f0105c39 <strtol+0x6c>
		base = 10;
f0105c11:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c16:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105c19:	eb 50                	jmp    f0105c6b <strtol+0x9e>
		s++;
f0105c1b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f0105c1e:	bf 00 00 00 00       	mov    $0x0,%edi
f0105c23:	eb d1                	jmp    f0105bf6 <strtol+0x29>
		s++, neg = 1;
f0105c25:	83 c1 01             	add    $0x1,%ecx
f0105c28:	bf 01 00 00 00       	mov    $0x1,%edi
f0105c2d:	eb c7                	jmp    f0105bf6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105c2f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105c33:	74 0e                	je     f0105c43 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f0105c35:	85 db                	test   %ebx,%ebx
f0105c37:	75 d8                	jne    f0105c11 <strtol+0x44>
		s++, base = 8;
f0105c39:	83 c1 01             	add    $0x1,%ecx
f0105c3c:	bb 08 00 00 00       	mov    $0x8,%ebx
f0105c41:	eb ce                	jmp    f0105c11 <strtol+0x44>
		s += 2, base = 16;
f0105c43:	83 c1 02             	add    $0x2,%ecx
f0105c46:	bb 10 00 00 00       	mov    $0x10,%ebx
f0105c4b:	eb c4                	jmp    f0105c11 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105c4d:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105c50:	89 f3                	mov    %esi,%ebx
f0105c52:	80 fb 19             	cmp    $0x19,%bl
f0105c55:	77 29                	ja     f0105c80 <strtol+0xb3>
			dig = *s - 'a' + 10;
f0105c57:	0f be d2             	movsbl %dl,%edx
f0105c5a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105c5d:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105c60:	7d 30                	jge    f0105c92 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f0105c62:	83 c1 01             	add    $0x1,%ecx
f0105c65:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105c69:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105c6b:	0f b6 11             	movzbl (%ecx),%edx
f0105c6e:	8d 72 d0             	lea    -0x30(%edx),%esi
f0105c71:	89 f3                	mov    %esi,%ebx
f0105c73:	80 fb 09             	cmp    $0x9,%bl
f0105c76:	77 d5                	ja     f0105c4d <strtol+0x80>
			dig = *s - '0';
f0105c78:	0f be d2             	movsbl %dl,%edx
f0105c7b:	83 ea 30             	sub    $0x30,%edx
f0105c7e:	eb dd                	jmp    f0105c5d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0105c80:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105c83:	89 f3                	mov    %esi,%ebx
f0105c85:	80 fb 19             	cmp    $0x19,%bl
f0105c88:	77 08                	ja     f0105c92 <strtol+0xc5>
			dig = *s - 'A' + 10;
f0105c8a:	0f be d2             	movsbl %dl,%edx
f0105c8d:	83 ea 37             	sub    $0x37,%edx
f0105c90:	eb cb                	jmp    f0105c5d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105c92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105c96:	74 05                	je     f0105c9d <strtol+0xd0>
		*endptr = (char *) s;
f0105c98:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105c9b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105c9d:	89 c2                	mov    %eax,%edx
f0105c9f:	f7 da                	neg    %edx
f0105ca1:	85 ff                	test   %edi,%edi
f0105ca3:	0f 45 c2             	cmovne %edx,%eax
}
f0105ca6:	5b                   	pop    %ebx
f0105ca7:	5e                   	pop    %esi
f0105ca8:	5f                   	pop    %edi
f0105ca9:	5d                   	pop    %ebp
f0105caa:	c3                   	ret    
f0105cab:	90                   	nop

f0105cac <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0105cac:	fa                   	cli    

	xorw    %ax, %ax
f0105cad:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0105caf:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105cb1:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105cb3:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0105cb5:	0f 01 16             	lgdtl  (%esi)
f0105cb8:	74 70                	je     f0105d2a <mpsearch1+0x3>
	movl    %cr0, %eax
f0105cba:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0105cbd:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0105cc1:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105cc4:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105cca:	08 00                	or     %al,(%eax)

f0105ccc <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0105ccc:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0105cd0:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0105cd2:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0105cd4:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0105cd6:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0105cda:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0105cdc:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0105cde:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl    %eax, %cr3
f0105ce3:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0105ce6:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0105ce9:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0105cee:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0105cf1:	8b 25 9c ee 2a f0    	mov    0xf02aee9c,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0105cf7:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0105cfc:	b8 cd 01 10 f0       	mov    $0xf01001cd,%eax
	call    *%eax
f0105d01:	ff d0                	call   *%eax

f0105d03 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0105d03:	eb fe                	jmp    f0105d03 <spin>
f0105d05:	8d 76 00             	lea    0x0(%esi),%esi

f0105d08 <gdt>:
	...
f0105d10:	ff                   	(bad)  
f0105d11:	ff 00                	incl   (%eax)
f0105d13:	00 00                	add    %al,(%eax)
f0105d15:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105d1c:	00                   	.byte 0x0
f0105d1d:	92                   	xchg   %eax,%edx
f0105d1e:	cf                   	iret   
	...

f0105d20 <gdtdesc>:
f0105d20:	17                   	pop    %ss
f0105d21:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105d26 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105d26:	90                   	nop

f0105d27 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0105d27:	55                   	push   %ebp
f0105d28:	89 e5                	mov    %esp,%ebp
f0105d2a:	57                   	push   %edi
f0105d2b:	56                   	push   %esi
f0105d2c:	53                   	push   %ebx
f0105d2d:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0105d30:	8b 0d a0 ee 2a f0    	mov    0xf02aeea0,%ecx
f0105d36:	89 c3                	mov    %eax,%ebx
f0105d38:	c1 eb 0c             	shr    $0xc,%ebx
f0105d3b:	39 cb                	cmp    %ecx,%ebx
f0105d3d:	73 1a                	jae    f0105d59 <mpsearch1+0x32>
	return (void *)(pa + KERNBASE);
f0105d3f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0105d45:	8d 34 02             	lea    (%edx,%eax,1),%esi
	if (PGNUM(pa) >= npages)
f0105d48:	89 f0                	mov    %esi,%eax
f0105d4a:	c1 e8 0c             	shr    $0xc,%eax
f0105d4d:	39 c8                	cmp    %ecx,%eax
f0105d4f:	73 1a                	jae    f0105d6b <mpsearch1+0x44>
	return (void *)(pa + KERNBASE);
f0105d51:	81 ee 00 00 00 10    	sub    $0x10000000,%esi

	for (; mp < end; mp++)
f0105d57:	eb 27                	jmp    f0105d80 <mpsearch1+0x59>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105d59:	50                   	push   %eax
f0105d5a:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0105d5f:	6a 57                	push   $0x57
f0105d61:	68 7d 89 10 f0       	push   $0xf010897d
f0105d66:	e8 d5 a2 ff ff       	call   f0100040 <_panic>
f0105d6b:	56                   	push   %esi
f0105d6c:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0105d71:	6a 57                	push   $0x57
f0105d73:	68 7d 89 10 f0       	push   $0xf010897d
f0105d78:	e8 c3 a2 ff ff       	call   f0100040 <_panic>
f0105d7d:	83 c3 10             	add    $0x10,%ebx
f0105d80:	39 f3                	cmp    %esi,%ebx
f0105d82:	73 2e                	jae    f0105db2 <mpsearch1+0x8b>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105d84:	83 ec 04             	sub    $0x4,%esp
f0105d87:	6a 04                	push   $0x4
f0105d89:	68 8d 89 10 f0       	push   $0xf010898d
f0105d8e:	53                   	push   %ebx
f0105d8f:	e8 e3 fd ff ff       	call   f0105b77 <memcmp>
f0105d94:	83 c4 10             	add    $0x10,%esp
f0105d97:	85 c0                	test   %eax,%eax
f0105d99:	75 e2                	jne    f0105d7d <mpsearch1+0x56>
f0105d9b:	89 da                	mov    %ebx,%edx
f0105d9d:	8d 7b 10             	lea    0x10(%ebx),%edi
		sum += ((uint8_t *)addr)[i];
f0105da0:	0f b6 0a             	movzbl (%edx),%ecx
f0105da3:	01 c8                	add    %ecx,%eax
f0105da5:	83 c2 01             	add    $0x1,%edx
	for (i = 0; i < len; i++)
f0105da8:	39 fa                	cmp    %edi,%edx
f0105daa:	75 f4                	jne    f0105da0 <mpsearch1+0x79>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0105dac:	84 c0                	test   %al,%al
f0105dae:	75 cd                	jne    f0105d7d <mpsearch1+0x56>
f0105db0:	eb 05                	jmp    f0105db7 <mpsearch1+0x90>
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0105db2:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f0105db7:	89 d8                	mov    %ebx,%eax
f0105db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105dbc:	5b                   	pop    %ebx
f0105dbd:	5e                   	pop    %esi
f0105dbe:	5f                   	pop    %edi
f0105dbf:	5d                   	pop    %ebp
f0105dc0:	c3                   	ret    

f0105dc1 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0105dc1:	55                   	push   %ebp
f0105dc2:	89 e5                	mov    %esp,%ebp
f0105dc4:	57                   	push   %edi
f0105dc5:	56                   	push   %esi
f0105dc6:	53                   	push   %ebx
f0105dc7:	83 ec 1c             	sub    $0x1c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0105dca:	c7 05 c0 f3 2a f0 20 	movl   $0xf02af020,0xf02af3c0
f0105dd1:	f0 2a f0 
	if (PGNUM(pa) >= npages)
f0105dd4:	83 3d a0 ee 2a f0 00 	cmpl   $0x0,0xf02aeea0
f0105ddb:	0f 84 87 00 00 00    	je     f0105e68 <mp_init+0xa7>
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0105de1:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0105de8:	85 c0                	test   %eax,%eax
f0105dea:	0f 84 8e 00 00 00    	je     f0105e7e <mp_init+0xbd>
		p <<= 4;	// Translate from segment to PA
f0105df0:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0105df3:	ba 00 04 00 00       	mov    $0x400,%edx
f0105df8:	e8 2a ff ff ff       	call   f0105d27 <mpsearch1>
f0105dfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105e00:	85 c0                	test   %eax,%eax
f0105e02:	0f 84 9a 00 00 00    	je     f0105ea2 <mp_init+0xe1>
	if (mp->physaddr == 0 || mp->type != 0) {
f0105e08:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0105e0b:	8b 41 04             	mov    0x4(%ecx),%eax
f0105e0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105e11:	85 c0                	test   %eax,%eax
f0105e13:	0f 84 a8 00 00 00    	je     f0105ec1 <mp_init+0x100>
f0105e19:	80 79 0b 00          	cmpb   $0x0,0xb(%ecx)
f0105e1d:	0f 85 9e 00 00 00    	jne    f0105ec1 <mp_init+0x100>
f0105e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e26:	c1 e8 0c             	shr    $0xc,%eax
f0105e29:	3b 05 a0 ee 2a f0    	cmp    0xf02aeea0,%eax
f0105e2f:	0f 83 a1 00 00 00    	jae    f0105ed6 <mp_init+0x115>
	return (void *)(pa + KERNBASE);
f0105e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e38:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f0105e3e:	89 de                	mov    %ebx,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0105e40:	83 ec 04             	sub    $0x4,%esp
f0105e43:	6a 04                	push   $0x4
f0105e45:	68 92 89 10 f0       	push   $0xf0108992
f0105e4a:	53                   	push   %ebx
f0105e4b:	e8 27 fd ff ff       	call   f0105b77 <memcmp>
f0105e50:	83 c4 10             	add    $0x10,%esp
f0105e53:	85 c0                	test   %eax,%eax
f0105e55:	0f 85 92 00 00 00    	jne    f0105eed <mp_init+0x12c>
f0105e5b:	0f b7 7b 04          	movzwl 0x4(%ebx),%edi
f0105e5f:	01 df                	add    %ebx,%edi
	sum = 0;
f0105e61:	89 c2                	mov    %eax,%edx
f0105e63:	e9 a2 00 00 00       	jmp    f0105f0a <mp_init+0x149>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105e68:	68 00 04 00 00       	push   $0x400
f0105e6d:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0105e72:	6a 6f                	push   $0x6f
f0105e74:	68 7d 89 10 f0       	push   $0xf010897d
f0105e79:	e8 c2 a1 ff ff       	call   f0100040 <_panic>
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0105e7e:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0105e85:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0105e88:	2d 00 04 00 00       	sub    $0x400,%eax
f0105e8d:	ba 00 04 00 00       	mov    $0x400,%edx
f0105e92:	e8 90 fe ff ff       	call   f0105d27 <mpsearch1>
f0105e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105e9a:	85 c0                	test   %eax,%eax
f0105e9c:	0f 85 66 ff ff ff    	jne    f0105e08 <mp_init+0x47>
	return mpsearch1(0xF0000, 0x10000);
f0105ea2:	ba 00 00 01 00       	mov    $0x10000,%edx
f0105ea7:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0105eac:	e8 76 fe ff ff       	call   f0105d27 <mpsearch1>
f0105eb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if ((mp = mpsearch()) == 0)
f0105eb4:	85 c0                	test   %eax,%eax
f0105eb6:	0f 85 4c ff ff ff    	jne    f0105e08 <mp_init+0x47>
f0105ebc:	e9 a8 01 00 00       	jmp    f0106069 <mp_init+0x2a8>
		cprintf("SMP: Default configurations not implemented\n");
f0105ec1:	83 ec 0c             	sub    $0xc,%esp
f0105ec4:	68 f0 87 10 f0       	push   $0xf01087f0
f0105ec9:	e8 62 da ff ff       	call   f0103930 <cprintf>
f0105ece:	83 c4 10             	add    $0x10,%esp
f0105ed1:	e9 93 01 00 00       	jmp    f0106069 <mp_init+0x2a8>
f0105ed6:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105ed9:	68 c4 6c 10 f0       	push   $0xf0106cc4
f0105ede:	68 90 00 00 00       	push   $0x90
f0105ee3:	68 7d 89 10 f0       	push   $0xf010897d
f0105ee8:	e8 53 a1 ff ff       	call   f0100040 <_panic>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0105eed:	83 ec 0c             	sub    $0xc,%esp
f0105ef0:	68 20 88 10 f0       	push   $0xf0108820
f0105ef5:	e8 36 da ff ff       	call   f0103930 <cprintf>
f0105efa:	83 c4 10             	add    $0x10,%esp
f0105efd:	e9 67 01 00 00       	jmp    f0106069 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105f02:	0f b6 0b             	movzbl (%ebx),%ecx
f0105f05:	01 ca                	add    %ecx,%edx
f0105f07:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105f0a:	39 fb                	cmp    %edi,%ebx
f0105f0c:	75 f4                	jne    f0105f02 <mp_init+0x141>
	if (sum(conf, conf->length) != 0) {
f0105f0e:	84 d2                	test   %dl,%dl
f0105f10:	75 16                	jne    f0105f28 <mp_init+0x167>
	if (conf->version != 1 && conf->version != 4) {
f0105f12:	0f b6 56 06          	movzbl 0x6(%esi),%edx
f0105f16:	80 fa 01             	cmp    $0x1,%dl
f0105f19:	74 05                	je     f0105f20 <mp_init+0x15f>
f0105f1b:	80 fa 04             	cmp    $0x4,%dl
f0105f1e:	75 1d                	jne    f0105f3d <mp_init+0x17c>
f0105f20:	0f b7 4e 28          	movzwl 0x28(%esi),%ecx
f0105f24:	01 d9                	add    %ebx,%ecx
f0105f26:	eb 36                	jmp    f0105f5e <mp_init+0x19d>
		cprintf("SMP: Bad MP configuration checksum\n");
f0105f28:	83 ec 0c             	sub    $0xc,%esp
f0105f2b:	68 54 88 10 f0       	push   $0xf0108854
f0105f30:	e8 fb d9 ff ff       	call   f0103930 <cprintf>
f0105f35:	83 c4 10             	add    $0x10,%esp
f0105f38:	e9 2c 01 00 00       	jmp    f0106069 <mp_init+0x2a8>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0105f3d:	83 ec 08             	sub    $0x8,%esp
f0105f40:	0f b6 d2             	movzbl %dl,%edx
f0105f43:	52                   	push   %edx
f0105f44:	68 78 88 10 f0       	push   $0xf0108878
f0105f49:	e8 e2 d9 ff ff       	call   f0103930 <cprintf>
f0105f4e:	83 c4 10             	add    $0x10,%esp
f0105f51:	e9 13 01 00 00       	jmp    f0106069 <mp_init+0x2a8>
		sum += ((uint8_t *)addr)[i];
f0105f56:	0f b6 13             	movzbl (%ebx),%edx
f0105f59:	01 d0                	add    %edx,%eax
f0105f5b:	83 c3 01             	add    $0x1,%ebx
	for (i = 0; i < len; i++)
f0105f5e:	39 d9                	cmp    %ebx,%ecx
f0105f60:	75 f4                	jne    f0105f56 <mp_init+0x195>
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0105f62:	02 46 2a             	add    0x2a(%esi),%al
f0105f65:	75 29                	jne    f0105f90 <mp_init+0x1cf>
	if ((conf = mpconfig(&mp)) == 0)
f0105f67:	81 7d e4 00 00 00 10 	cmpl   $0x10000000,-0x1c(%ebp)
f0105f6e:	0f 84 f5 00 00 00    	je     f0106069 <mp_init+0x2a8>
		return;
	ismp = 1;
f0105f74:	c7 05 00 f0 2a f0 01 	movl   $0x1,0xf02af000
f0105f7b:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0105f7e:	8b 46 24             	mov    0x24(%esi),%eax
f0105f81:	a3 00 00 2f f0       	mov    %eax,0xf02f0000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105f86:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0105f89:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105f8e:	eb 4d                	jmp    f0105fdd <mp_init+0x21c>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0105f90:	83 ec 0c             	sub    $0xc,%esp
f0105f93:	68 98 88 10 f0       	push   $0xf0108898
f0105f98:	e8 93 d9 ff ff       	call   f0103930 <cprintf>
f0105f9d:	83 c4 10             	add    $0x10,%esp
f0105fa0:	e9 c4 00 00 00       	jmp    f0106069 <mp_init+0x2a8>
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0105fa5:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0105fa9:	74 11                	je     f0105fbc <mp_init+0x1fb>
				bootcpu = &cpus[ncpu];
f0105fab:	6b 05 c4 f3 2a f0 74 	imul   $0x74,0xf02af3c4,%eax
f0105fb2:	05 20 f0 2a f0       	add    $0xf02af020,%eax
f0105fb7:	a3 c0 f3 2a f0       	mov    %eax,0xf02af3c0
			if (ncpu < NCPU) {
f0105fbc:	a1 c4 f3 2a f0       	mov    0xf02af3c4,%eax
f0105fc1:	83 f8 07             	cmp    $0x7,%eax
f0105fc4:	7f 2f                	jg     f0105ff5 <mp_init+0x234>
				cpus[ncpu].cpu_id = ncpu;
f0105fc6:	6b d0 74             	imul   $0x74,%eax,%edx
f0105fc9:	88 82 20 f0 2a f0    	mov    %al,-0xfd50fe0(%edx)
				ncpu++;
f0105fcf:	83 c0 01             	add    $0x1,%eax
f0105fd2:	a3 c4 f3 2a f0       	mov    %eax,0xf02af3c4
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0105fd7:	83 c7 14             	add    $0x14,%edi
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105fda:	83 c3 01             	add    $0x1,%ebx
f0105fdd:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f0105fe1:	39 d8                	cmp    %ebx,%eax
f0105fe3:	76 4b                	jbe    f0106030 <mp_init+0x26f>
		switch (*p) {
f0105fe5:	0f b6 07             	movzbl (%edi),%eax
f0105fe8:	84 c0                	test   %al,%al
f0105fea:	74 b9                	je     f0105fa5 <mp_init+0x1e4>
f0105fec:	3c 04                	cmp    $0x4,%al
f0105fee:	77 1c                	ja     f010600c <mp_init+0x24b>
			continue;
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105ff0:	83 c7 08             	add    $0x8,%edi
			continue;
f0105ff3:	eb e5                	jmp    f0105fda <mp_init+0x219>
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0105ff5:	83 ec 08             	sub    $0x8,%esp
f0105ff8:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0105ffc:	50                   	push   %eax
f0105ffd:	68 c8 88 10 f0       	push   $0xf01088c8
f0106002:	e8 29 d9 ff ff       	call   f0103930 <cprintf>
f0106007:	83 c4 10             	add    $0x10,%esp
f010600a:	eb cb                	jmp    f0105fd7 <mp_init+0x216>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f010600c:	83 ec 08             	sub    $0x8,%esp
		switch (*p) {
f010600f:	0f b6 c0             	movzbl %al,%eax
			cprintf("mpinit: unknown config type %x\n", *p);
f0106012:	50                   	push   %eax
f0106013:	68 f0 88 10 f0       	push   $0xf01088f0
f0106018:	e8 13 d9 ff ff       	call   f0103930 <cprintf>
			ismp = 0;
f010601d:	c7 05 00 f0 2a f0 00 	movl   $0x0,0xf02af000
f0106024:	00 00 00 
			i = conf->entry;
f0106027:	0f b7 5e 22          	movzwl 0x22(%esi),%ebx
f010602b:	83 c4 10             	add    $0x10,%esp
f010602e:	eb aa                	jmp    f0105fda <mp_init+0x219>
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106030:	a1 c0 f3 2a f0       	mov    0xf02af3c0,%eax
f0106035:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f010603c:	83 3d 00 f0 2a f0 00 	cmpl   $0x0,0xf02af000
f0106043:	75 2c                	jne    f0106071 <mp_init+0x2b0>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0106045:	c7 05 c4 f3 2a f0 01 	movl   $0x1,0xf02af3c4
f010604c:	00 00 00 
		lapicaddr = 0;
f010604f:	c7 05 00 00 2f f0 00 	movl   $0x0,0xf02f0000
f0106056:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106059:	83 ec 0c             	sub    $0xc,%esp
f010605c:	68 10 89 10 f0       	push   $0xf0108910
f0106061:	e8 ca d8 ff ff       	call   f0103930 <cprintf>
		return;
f0106066:	83 c4 10             	add    $0x10,%esp
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
	}
}
f0106069:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010606c:	5b                   	pop    %ebx
f010606d:	5e                   	pop    %esi
f010606e:	5f                   	pop    %edi
f010606f:	5d                   	pop    %ebp
f0106070:	c3                   	ret    
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106071:	83 ec 04             	sub    $0x4,%esp
f0106074:	ff 35 c4 f3 2a f0    	pushl  0xf02af3c4
f010607a:	0f b6 00             	movzbl (%eax),%eax
f010607d:	50                   	push   %eax
f010607e:	68 97 89 10 f0       	push   $0xf0108997
f0106083:	e8 a8 d8 ff ff       	call   f0103930 <cprintf>
	if (mp->imcrp) {
f0106088:	83 c4 10             	add    $0x10,%esp
f010608b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010608e:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106092:	74 d5                	je     f0106069 <mp_init+0x2a8>
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106094:	83 ec 0c             	sub    $0xc,%esp
f0106097:	68 3c 89 10 f0       	push   $0xf010893c
f010609c:	e8 8f d8 ff ff       	call   f0103930 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01060a1:	b8 70 00 00 00       	mov    $0x70,%eax
f01060a6:	ba 22 00 00 00       	mov    $0x22,%edx
f01060ab:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01060ac:	ba 23 00 00 00       	mov    $0x23,%edx
f01060b1:	ec                   	in     (%dx),%al
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f01060b2:	83 c8 01             	or     $0x1,%eax
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01060b5:	ee                   	out    %al,(%dx)
f01060b6:	83 c4 10             	add    $0x10,%esp
f01060b9:	eb ae                	jmp    f0106069 <mp_init+0x2a8>

f01060bb <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f01060bb:	55                   	push   %ebp
f01060bc:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f01060be:	8b 0d 04 00 2f f0    	mov    0xf02f0004,%ecx
f01060c4:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f01060c7:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f01060c9:	a1 04 00 2f f0       	mov    0xf02f0004,%eax
f01060ce:	8b 40 20             	mov    0x20(%eax),%eax
}
f01060d1:	5d                   	pop    %ebp
f01060d2:	c3                   	ret    

f01060d3 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f01060d3:	55                   	push   %ebp
f01060d4:	89 e5                	mov    %esp,%ebp
	if (lapic)
f01060d6:	8b 15 04 00 2f f0    	mov    0xf02f0004,%edx
		return lapic[ID] >> 24;
	return 0;
f01060dc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lapic)
f01060e1:	85 d2                	test   %edx,%edx
f01060e3:	74 06                	je     f01060eb <cpunum+0x18>
		return lapic[ID] >> 24;
f01060e5:	8b 42 20             	mov    0x20(%edx),%eax
f01060e8:	c1 e8 18             	shr    $0x18,%eax
}
f01060eb:	5d                   	pop    %ebp
f01060ec:	c3                   	ret    

f01060ed <lapic_init>:
	if (!lapicaddr)
f01060ed:	a1 00 00 2f f0       	mov    0xf02f0000,%eax
f01060f2:	85 c0                	test   %eax,%eax
f01060f4:	75 02                	jne    f01060f8 <lapic_init+0xb>
f01060f6:	f3 c3                	repz ret 
{
f01060f8:	55                   	push   %ebp
f01060f9:	89 e5                	mov    %esp,%ebp
f01060fb:	83 ec 10             	sub    $0x10,%esp
	lapic = mmio_map_region(lapicaddr, 4096);
f01060fe:	68 00 10 00 00       	push   $0x1000
f0106103:	50                   	push   %eax
f0106104:	e8 f9 b1 ff ff       	call   f0101302 <mmio_map_region>
f0106109:	a3 04 00 2f f0       	mov    %eax,0xf02f0004
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f010610e:	ba 27 01 00 00       	mov    $0x127,%edx
f0106113:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106118:	e8 9e ff ff ff       	call   f01060bb <lapicw>
	lapicw(TDCR, X1);
f010611d:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106122:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106127:	e8 8f ff ff ff       	call   f01060bb <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f010612c:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106131:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106136:	e8 80 ff ff ff       	call   f01060bb <lapicw>
	lapicw(TICR, 10000000); 
f010613b:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106140:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106145:	e8 71 ff ff ff       	call   f01060bb <lapicw>
	if (thiscpu != bootcpu)
f010614a:	e8 84 ff ff ff       	call   f01060d3 <cpunum>
f010614f:	6b c0 74             	imul   $0x74,%eax,%eax
f0106152:	05 20 f0 2a f0       	add    $0xf02af020,%eax
f0106157:	83 c4 10             	add    $0x10,%esp
f010615a:	39 05 c0 f3 2a f0    	cmp    %eax,0xf02af3c0
f0106160:	74 0f                	je     f0106171 <lapic_init+0x84>
		lapicw(LINT0, MASKED);
f0106162:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106167:	b8 d4 00 00 00       	mov    $0xd4,%eax
f010616c:	e8 4a ff ff ff       	call   f01060bb <lapicw>
	lapicw(LINT1, MASKED);
f0106171:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106176:	b8 d8 00 00 00       	mov    $0xd8,%eax
f010617b:	e8 3b ff ff ff       	call   f01060bb <lapicw>
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106180:	a1 04 00 2f f0       	mov    0xf02f0004,%eax
f0106185:	8b 40 30             	mov    0x30(%eax),%eax
f0106188:	c1 e8 10             	shr    $0x10,%eax
f010618b:	3c 03                	cmp    $0x3,%al
f010618d:	77 7c                	ja     f010620b <lapic_init+0x11e>
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f010618f:	ba 33 00 00 00       	mov    $0x33,%edx
f0106194:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106199:	e8 1d ff ff ff       	call   f01060bb <lapicw>
	lapicw(ESR, 0);
f010619e:	ba 00 00 00 00       	mov    $0x0,%edx
f01061a3:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01061a8:	e8 0e ff ff ff       	call   f01060bb <lapicw>
	lapicw(ESR, 0);
f01061ad:	ba 00 00 00 00       	mov    $0x0,%edx
f01061b2:	b8 a0 00 00 00       	mov    $0xa0,%eax
f01061b7:	e8 ff fe ff ff       	call   f01060bb <lapicw>
	lapicw(EOI, 0);
f01061bc:	ba 00 00 00 00       	mov    $0x0,%edx
f01061c1:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01061c6:	e8 f0 fe ff ff       	call   f01060bb <lapicw>
	lapicw(ICRHI, 0);
f01061cb:	ba 00 00 00 00       	mov    $0x0,%edx
f01061d0:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01061d5:	e8 e1 fe ff ff       	call   f01060bb <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f01061da:	ba 00 85 08 00       	mov    $0x88500,%edx
f01061df:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01061e4:	e8 d2 fe ff ff       	call   f01060bb <lapicw>
	while(lapic[ICRLO] & DELIVS)
f01061e9:	8b 15 04 00 2f f0    	mov    0xf02f0004,%edx
f01061ef:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01061f5:	f6 c4 10             	test   $0x10,%ah
f01061f8:	75 f5                	jne    f01061ef <lapic_init+0x102>
	lapicw(TPR, 0);
f01061fa:	ba 00 00 00 00       	mov    $0x0,%edx
f01061ff:	b8 20 00 00 00       	mov    $0x20,%eax
f0106204:	e8 b2 fe ff ff       	call   f01060bb <lapicw>
}
f0106209:	c9                   	leave  
f010620a:	c3                   	ret    
		lapicw(PCINT, MASKED);
f010620b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106210:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106215:	e8 a1 fe ff ff       	call   f01060bb <lapicw>
f010621a:	e9 70 ff ff ff       	jmp    f010618f <lapic_init+0xa2>

f010621f <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f010621f:	83 3d 04 00 2f f0 00 	cmpl   $0x0,0xf02f0004
f0106226:	74 14                	je     f010623c <lapic_eoi+0x1d>
{
f0106228:	55                   	push   %ebp
f0106229:	89 e5                	mov    %esp,%ebp
		lapicw(EOI, 0);
f010622b:	ba 00 00 00 00       	mov    $0x0,%edx
f0106230:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106235:	e8 81 fe ff ff       	call   f01060bb <lapicw>
}
f010623a:	5d                   	pop    %ebp
f010623b:	c3                   	ret    
f010623c:	f3 c3                	repz ret 

f010623e <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f010623e:	55                   	push   %ebp
f010623f:	89 e5                	mov    %esp,%ebp
f0106241:	56                   	push   %esi
f0106242:	53                   	push   %ebx
f0106243:	8b 75 08             	mov    0x8(%ebp),%esi
f0106246:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0106249:	b8 0f 00 00 00       	mov    $0xf,%eax
f010624e:	ba 70 00 00 00       	mov    $0x70,%edx
f0106253:	ee                   	out    %al,(%dx)
f0106254:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106259:	ba 71 00 00 00       	mov    $0x71,%edx
f010625e:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f010625f:	83 3d a0 ee 2a f0 00 	cmpl   $0x0,0xf02aeea0
f0106266:	74 7e                	je     f01062e6 <lapic_startap+0xa8>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106268:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f010626f:	00 00 
	wrv[1] = addr >> 4;
f0106271:	89 d8                	mov    %ebx,%eax
f0106273:	c1 e8 04             	shr    $0x4,%eax
f0106276:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f010627c:	c1 e6 18             	shl    $0x18,%esi
f010627f:	89 f2                	mov    %esi,%edx
f0106281:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106286:	e8 30 fe ff ff       	call   f01060bb <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f010628b:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106290:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106295:	e8 21 fe ff ff       	call   f01060bb <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f010629a:	ba 00 85 00 00       	mov    $0x8500,%edx
f010629f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01062a4:	e8 12 fe ff ff       	call   f01060bb <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01062a9:	c1 eb 0c             	shr    $0xc,%ebx
f01062ac:	80 cf 06             	or     $0x6,%bh
		lapicw(ICRHI, apicid << 24);
f01062af:	89 f2                	mov    %esi,%edx
f01062b1:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01062b6:	e8 00 fe ff ff       	call   f01060bb <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01062bb:	89 da                	mov    %ebx,%edx
f01062bd:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01062c2:	e8 f4 fd ff ff       	call   f01060bb <lapicw>
		lapicw(ICRHI, apicid << 24);
f01062c7:	89 f2                	mov    %esi,%edx
f01062c9:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01062ce:	e8 e8 fd ff ff       	call   f01060bb <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01062d3:	89 da                	mov    %ebx,%edx
f01062d5:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01062da:	e8 dc fd ff ff       	call   f01060bb <lapicw>
		microdelay(200);
	}
}
f01062df:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01062e2:	5b                   	pop    %ebx
f01062e3:	5e                   	pop    %esi
f01062e4:	5d                   	pop    %ebp
f01062e5:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01062e6:	68 67 04 00 00       	push   $0x467
f01062eb:	68 c4 6c 10 f0       	push   $0xf0106cc4
f01062f0:	68 98 00 00 00       	push   $0x98
f01062f5:	68 b4 89 10 f0       	push   $0xf01089b4
f01062fa:	e8 41 9d ff ff       	call   f0100040 <_panic>

f01062ff <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01062ff:	55                   	push   %ebp
f0106300:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0106302:	8b 55 08             	mov    0x8(%ebp),%edx
f0106305:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010630b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106310:	e8 a6 fd ff ff       	call   f01060bb <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0106315:	8b 15 04 00 2f f0    	mov    0xf02f0004,%edx
f010631b:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106321:	f6 c4 10             	test   $0x10,%ah
f0106324:	75 f5                	jne    f010631b <lapic_ipi+0x1c>
		;
}
f0106326:	5d                   	pop    %ebp
f0106327:	c3                   	ret    

f0106328 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0106328:	55                   	push   %ebp
f0106329:	89 e5                	mov    %esp,%ebp
f010632b:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f010632e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0106334:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106337:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010633a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106341:	5d                   	pop    %ebp
f0106342:	c3                   	ret    

f0106343 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106343:	55                   	push   %ebp
f0106344:	89 e5                	mov    %esp,%ebp
f0106346:	56                   	push   %esi
f0106347:	53                   	push   %ebx
f0106348:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010634b:	83 3b 00             	cmpl   $0x0,(%ebx)
f010634e:	75 07                	jne    f0106357 <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0106350:	ba 01 00 00 00       	mov    $0x1,%edx
f0106355:	eb 34                	jmp    f010638b <spin_lock+0x48>
f0106357:	8b 73 08             	mov    0x8(%ebx),%esi
f010635a:	e8 74 fd ff ff       	call   f01060d3 <cpunum>
f010635f:	6b c0 74             	imul   $0x74,%eax,%eax
f0106362:	05 20 f0 2a f0       	add    $0xf02af020,%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0106367:	39 c6                	cmp    %eax,%esi
f0106369:	75 e5                	jne    f0106350 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f010636b:	8b 5b 04             	mov    0x4(%ebx),%ebx
f010636e:	e8 60 fd ff ff       	call   f01060d3 <cpunum>
f0106373:	83 ec 0c             	sub    $0xc,%esp
f0106376:	53                   	push   %ebx
f0106377:	50                   	push   %eax
f0106378:	68 c4 89 10 f0       	push   $0xf01089c4
f010637d:	6a 41                	push   $0x41
f010637f:	68 26 8a 10 f0       	push   $0xf0108a26
f0106384:	e8 b7 9c ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106389:	f3 90                	pause  
f010638b:	89 d0                	mov    %edx,%eax
f010638d:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f0106390:	85 c0                	test   %eax,%eax
f0106392:	75 f5                	jne    f0106389 <spin_lock+0x46>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106394:	e8 3a fd ff ff       	call   f01060d3 <cpunum>
f0106399:	6b c0 74             	imul   $0x74,%eax,%eax
f010639c:	05 20 f0 2a f0       	add    $0xf02af020,%eax
f01063a1:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f01063a4:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f01063a7:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01063a9:	b8 00 00 00 00       	mov    $0x0,%eax
f01063ae:	eb 0b                	jmp    f01063bb <spin_lock+0x78>
		pcs[i] = ebp[1];          // saved %eip
f01063b0:	8b 4a 04             	mov    0x4(%edx),%ecx
f01063b3:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f01063b6:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f01063b8:	83 c0 01             	add    $0x1,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f01063bb:	83 f8 09             	cmp    $0x9,%eax
f01063be:	7f 14                	jg     f01063d4 <spin_lock+0x91>
f01063c0:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f01063c6:	77 e8                	ja     f01063b0 <spin_lock+0x6d>
f01063c8:	eb 0a                	jmp    f01063d4 <spin_lock+0x91>
		pcs[i] = 0;
f01063ca:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f01063d1:	83 c0 01             	add    $0x1,%eax
f01063d4:	83 f8 09             	cmp    $0x9,%eax
f01063d7:	7e f1                	jle    f01063ca <spin_lock+0x87>
#endif
}
f01063d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01063dc:	5b                   	pop    %ebx
f01063dd:	5e                   	pop    %esi
f01063de:	5d                   	pop    %ebp
f01063df:	c3                   	ret    

f01063e0 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01063e0:	55                   	push   %ebp
f01063e1:	89 e5                	mov    %esp,%ebp
f01063e3:	57                   	push   %edi
f01063e4:	56                   	push   %esi
f01063e5:	53                   	push   %ebx
f01063e6:	83 ec 4c             	sub    $0x4c,%esp
f01063e9:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f01063ec:	83 3e 00             	cmpl   $0x0,(%esi)
f01063ef:	75 35                	jne    f0106426 <spin_unlock+0x46>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01063f1:	83 ec 04             	sub    $0x4,%esp
f01063f4:	6a 28                	push   $0x28
f01063f6:	8d 46 0c             	lea    0xc(%esi),%eax
f01063f9:	50                   	push   %eax
f01063fa:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01063fd:	53                   	push   %ebx
f01063fe:	e8 f9 f6 ff ff       	call   f0105afc <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106403:	8b 46 08             	mov    0x8(%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106406:	0f b6 38             	movzbl (%eax),%edi
f0106409:	8b 76 04             	mov    0x4(%esi),%esi
f010640c:	e8 c2 fc ff ff       	call   f01060d3 <cpunum>
f0106411:	57                   	push   %edi
f0106412:	56                   	push   %esi
f0106413:	50                   	push   %eax
f0106414:	68 f0 89 10 f0       	push   $0xf01089f0
f0106419:	e8 12 d5 ff ff       	call   f0103930 <cprintf>
f010641e:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106421:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106424:	eb 61                	jmp    f0106487 <spin_unlock+0xa7>
	return lock->locked && lock->cpu == thiscpu;
f0106426:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106429:	e8 a5 fc ff ff       	call   f01060d3 <cpunum>
f010642e:	6b c0 74             	imul   $0x74,%eax,%eax
f0106431:	05 20 f0 2a f0       	add    $0xf02af020,%eax
	if (!holding(lk)) {
f0106436:	39 c3                	cmp    %eax,%ebx
f0106438:	75 b7                	jne    f01063f1 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f010643a:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106441:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106448:	b8 00 00 00 00       	mov    $0x0,%eax
f010644d:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0106450:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106453:	5b                   	pop    %ebx
f0106454:	5e                   	pop    %esi
f0106455:	5f                   	pop    %edi
f0106456:	5d                   	pop    %ebp
f0106457:	c3                   	ret    
					pcs[i] - info.eip_fn_addr);
f0106458:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f010645a:	83 ec 04             	sub    $0x4,%esp
f010645d:	89 c2                	mov    %eax,%edx
f010645f:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106462:	52                   	push   %edx
f0106463:	ff 75 b0             	pushl  -0x50(%ebp)
f0106466:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106469:	ff 75 ac             	pushl  -0x54(%ebp)
f010646c:	ff 75 a8             	pushl  -0x58(%ebp)
f010646f:	50                   	push   %eax
f0106470:	68 36 8a 10 f0       	push   $0xf0108a36
f0106475:	e8 b6 d4 ff ff       	call   f0103930 <cprintf>
f010647a:	83 c4 20             	add    $0x20,%esp
f010647d:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106480:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106483:	39 c3                	cmp    %eax,%ebx
f0106485:	74 2d                	je     f01064b4 <spin_unlock+0xd4>
f0106487:	89 de                	mov    %ebx,%esi
f0106489:	8b 03                	mov    (%ebx),%eax
f010648b:	85 c0                	test   %eax,%eax
f010648d:	74 25                	je     f01064b4 <spin_unlock+0xd4>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f010648f:	83 ec 08             	sub    $0x8,%esp
f0106492:	57                   	push   %edi
f0106493:	50                   	push   %eax
f0106494:	e8 cf ea ff ff       	call   f0104f68 <debuginfo_eip>
f0106499:	83 c4 10             	add    $0x10,%esp
f010649c:	85 c0                	test   %eax,%eax
f010649e:	79 b8                	jns    f0106458 <spin_unlock+0x78>
				cprintf("  %08x\n", pcs[i]);
f01064a0:	83 ec 08             	sub    $0x8,%esp
f01064a3:	ff 36                	pushl  (%esi)
f01064a5:	68 4d 8a 10 f0       	push   $0xf0108a4d
f01064aa:	e8 81 d4 ff ff       	call   f0103930 <cprintf>
f01064af:	83 c4 10             	add    $0x10,%esp
f01064b2:	eb c9                	jmp    f010647d <spin_unlock+0x9d>
		panic("spin_unlock");
f01064b4:	83 ec 04             	sub    $0x4,%esp
f01064b7:	68 55 8a 10 f0       	push   $0xf0108a55
f01064bc:	6a 67                	push   $0x67
f01064be:	68 26 8a 10 f0       	push   $0xf0108a26
f01064c3:	e8 78 9b ff ff       	call   f0100040 <_panic>

f01064c8 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f01064c8:	55                   	push   %ebp
f01064c9:	89 e5                	mov    %esp,%ebp
f01064cb:	57                   	push   %edi
f01064cc:	56                   	push   %esi
f01064cd:	53                   	push   %ebx
f01064ce:	83 ec 1c             	sub    $0x1c,%esp
f01064d1:	8b 7d 10             	mov    0x10(%ebp),%edi
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f01064d4:	eb 03                	jmp    f01064d9 <pci_attach_match+0x11>
f01064d6:	83 c7 0c             	add    $0xc,%edi
f01064d9:	89 fe                	mov    %edi,%esi
f01064db:	8b 47 08             	mov    0x8(%edi),%eax
f01064de:	85 c0                	test   %eax,%eax
f01064e0:	74 3f                	je     f0106521 <pci_attach_match+0x59>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f01064e2:	8b 1f                	mov    (%edi),%ebx
f01064e4:	3b 5d 08             	cmp    0x8(%ebp),%ebx
f01064e7:	75 ed                	jne    f01064d6 <pci_attach_match+0xe>
f01064e9:	8b 56 04             	mov    0x4(%esi),%edx
f01064ec:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01064ef:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01064f2:	75 e2                	jne    f01064d6 <pci_attach_match+0xe>
			int r = list[i].attachfn(pcif);
f01064f4:	83 ec 0c             	sub    $0xc,%esp
f01064f7:	ff 75 14             	pushl  0x14(%ebp)
f01064fa:	ff d0                	call   *%eax
			if (r > 0)
f01064fc:	83 c4 10             	add    $0x10,%esp
f01064ff:	85 c0                	test   %eax,%eax
f0106501:	7f 1e                	jg     f0106521 <pci_attach_match+0x59>
				return r;
			if (r < 0)
f0106503:	85 c0                	test   %eax,%eax
f0106505:	79 cf                	jns    f01064d6 <pci_attach_match+0xe>
				cprintf("pci_attach_match: attaching "
f0106507:	83 ec 0c             	sub    $0xc,%esp
f010650a:	50                   	push   %eax
f010650b:	ff 76 08             	pushl  0x8(%esi)
f010650e:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106511:	53                   	push   %ebx
f0106512:	68 70 8a 10 f0       	push   $0xf0108a70
f0106517:	e8 14 d4 ff ff       	call   f0103930 <cprintf>
f010651c:	83 c4 20             	add    $0x20,%esp
f010651f:	eb b5                	jmp    f01064d6 <pci_attach_match+0xe>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0106521:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106524:	5b                   	pop    %ebx
f0106525:	5e                   	pop    %esi
f0106526:	5f                   	pop    %edi
f0106527:	5d                   	pop    %ebp
f0106528:	c3                   	ret    

f0106529 <pci_conf1_set_addr>:
{
f0106529:	55                   	push   %ebp
f010652a:	89 e5                	mov    %esp,%ebp
f010652c:	53                   	push   %ebx
f010652d:	83 ec 04             	sub    $0x4,%esp
f0106530:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0106533:	3d ff 00 00 00       	cmp    $0xff,%eax
f0106538:	77 37                	ja     f0106571 <pci_conf1_set_addr+0x48>
	assert(dev < 32);
f010653a:	83 fa 1f             	cmp    $0x1f,%edx
f010653d:	77 48                	ja     f0106587 <pci_conf1_set_addr+0x5e>
	assert(func < 8);
f010653f:	83 f9 07             	cmp    $0x7,%ecx
f0106542:	77 59                	ja     f010659d <pci_conf1_set_addr+0x74>
	assert(offset < 256);
f0106544:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f010654a:	77 67                	ja     f01065b3 <pci_conf1_set_addr+0x8a>
	assert((offset & 0x3) == 0);
f010654c:	f6 c3 03             	test   $0x3,%bl
f010654f:	75 78                	jne    f01065c9 <pci_conf1_set_addr+0xa0>
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106551:	c1 e1 08             	shl    $0x8,%ecx
	uint32_t v = (1 << 31) |		// config-space
f0106554:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f010655a:	09 d9                	or     %ebx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f010655c:	c1 e2 0b             	shl    $0xb,%edx
	uint32_t v = (1 << 31) |		// config-space
f010655f:	09 d1                	or     %edx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106561:	c1 e0 10             	shl    $0x10,%eax
	uint32_t v = (1 << 31) |		// config-space
f0106564:	09 c8                	or     %ecx,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106566:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f010656b:	ef                   	out    %eax,(%dx)
}
f010656c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010656f:	c9                   	leave  
f0106570:	c3                   	ret    
	assert(bus < 256);
f0106571:	68 c8 8b 10 f0       	push   $0xf0108bc8
f0106576:	68 ba 72 10 f0       	push   $0xf01072ba
f010657b:	6a 2b                	push   $0x2b
f010657d:	68 d2 8b 10 f0       	push   $0xf0108bd2
f0106582:	e8 b9 9a ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f0106587:	68 dd 8b 10 f0       	push   $0xf0108bdd
f010658c:	68 ba 72 10 f0       	push   $0xf01072ba
f0106591:	6a 2c                	push   $0x2c
f0106593:	68 d2 8b 10 f0       	push   $0xf0108bd2
f0106598:	e8 a3 9a ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f010659d:	68 e6 8b 10 f0       	push   $0xf0108be6
f01065a2:	68 ba 72 10 f0       	push   $0xf01072ba
f01065a7:	6a 2d                	push   $0x2d
f01065a9:	68 d2 8b 10 f0       	push   $0xf0108bd2
f01065ae:	e8 8d 9a ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f01065b3:	68 ef 8b 10 f0       	push   $0xf0108bef
f01065b8:	68 ba 72 10 f0       	push   $0xf01072ba
f01065bd:	6a 2e                	push   $0x2e
f01065bf:	68 d2 8b 10 f0       	push   $0xf0108bd2
f01065c4:	e8 77 9a ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f01065c9:	68 fc 8b 10 f0       	push   $0xf0108bfc
f01065ce:	68 ba 72 10 f0       	push   $0xf01072ba
f01065d3:	6a 2f                	push   $0x2f
f01065d5:	68 d2 8b 10 f0       	push   $0xf0108bd2
f01065da:	e8 61 9a ff ff       	call   f0100040 <_panic>

f01065df <pci_conf_read>:
{
f01065df:	55                   	push   %ebp
f01065e0:	89 e5                	mov    %esp,%ebp
f01065e2:	53                   	push   %ebx
f01065e3:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01065e6:	8b 48 08             	mov    0x8(%eax),%ecx
f01065e9:	8b 58 04             	mov    0x4(%eax),%ebx
f01065ec:	8b 00                	mov    (%eax),%eax
f01065ee:	8b 40 04             	mov    0x4(%eax),%eax
f01065f1:	52                   	push   %edx
f01065f2:	89 da                	mov    %ebx,%edx
f01065f4:	e8 30 ff ff ff       	call   f0106529 <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f01065f9:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01065fe:	ed                   	in     (%dx),%eax
}
f01065ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106602:	c9                   	leave  
f0106603:	c3                   	ret    

f0106604 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0106604:	55                   	push   %ebp
f0106605:	89 e5                	mov    %esp,%ebp
f0106607:	57                   	push   %edi
f0106608:	56                   	push   %esi
f0106609:	53                   	push   %ebx
f010660a:	81 ec 00 01 00 00    	sub    $0x100,%esp
f0106610:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0106612:	6a 48                	push   $0x48
f0106614:	6a 00                	push   $0x0
f0106616:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106619:	50                   	push   %eax
f010661a:	e8 90 f4 ff ff       	call   f0105aaf <memset>
	df.bus = bus;
f010661f:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106622:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
f0106629:	83 c4 10             	add    $0x10,%esp
	int totaldev = 0;
f010662c:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0106633:	00 00 00 
f0106636:	e9 25 01 00 00       	jmp    f0106760 <pci_scan_bus+0x15c>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010663b:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0106641:	83 ec 08             	sub    $0x8,%esp
f0106644:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0106648:	57                   	push   %edi
f0106649:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f010664a:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010664d:	0f b6 c0             	movzbl %al,%eax
f0106650:	50                   	push   %eax
f0106651:	51                   	push   %ecx
f0106652:	89 d0                	mov    %edx,%eax
f0106654:	c1 e8 10             	shr    $0x10,%eax
f0106657:	50                   	push   %eax
f0106658:	0f b7 d2             	movzwl %dx,%edx
f010665b:	52                   	push   %edx
f010665c:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0106662:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f0106668:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f010666e:	ff 70 04             	pushl  0x4(%eax)
f0106671:	68 9c 8a 10 f0       	push   $0xf0108a9c
f0106676:	e8 b5 d2 ff ff       	call   f0103930 <cprintf>
				 PCI_SUBCLASS(f->dev_class),
f010667b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106681:	83 c4 30             	add    $0x30,%esp
f0106684:	53                   	push   %ebx
f0106685:	68 f4 43 12 f0       	push   $0xf01243f4
				 PCI_SUBCLASS(f->dev_class),
f010668a:	89 c2                	mov    %eax,%edx
f010668c:	c1 ea 10             	shr    $0x10,%edx
		pci_attach_match(PCI_CLASS(f->dev_class),
f010668f:	0f b6 d2             	movzbl %dl,%edx
f0106692:	52                   	push   %edx
f0106693:	c1 e8 18             	shr    $0x18,%eax
f0106696:	50                   	push   %eax
f0106697:	e8 2c fe ff ff       	call   f01064c8 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f010669c:	83 c4 10             	add    $0x10,%esp
f010669f:	85 c0                	test   %eax,%eax
f01066a1:	0f 84 88 00 00 00    	je     f010672f <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f01066a7:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01066ae:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f01066b4:	39 85 18 ff ff ff    	cmp    %eax,-0xe8(%ebp)
f01066ba:	0f 83 92 00 00 00    	jae    f0106752 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f01066c0:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f01066c6:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f01066cc:	b9 12 00 00 00       	mov    $0x12,%ecx
f01066d1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f01066d3:	ba 00 00 00 00       	mov    $0x0,%edx
f01066d8:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f01066de:	e8 fc fe ff ff       	call   f01065df <pci_conf_read>
f01066e3:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f01066e9:	66 83 f8 ff          	cmp    $0xffff,%ax
f01066ed:	74 b8                	je     f01066a7 <pci_scan_bus+0xa3>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01066ef:	ba 3c 00 00 00       	mov    $0x3c,%edx
f01066f4:	89 d8                	mov    %ebx,%eax
f01066f6:	e8 e4 fe ff ff       	call   f01065df <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f01066fb:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f01066fe:	ba 08 00 00 00       	mov    $0x8,%edx
f0106703:	89 d8                	mov    %ebx,%eax
f0106705:	e8 d5 fe ff ff       	call   f01065df <pci_conf_read>
f010670a:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106710:	89 c1                	mov    %eax,%ecx
f0106712:	c1 e9 18             	shr    $0x18,%ecx
	const char *class = pci_class[0];
f0106715:	be 10 8c 10 f0       	mov    $0xf0108c10,%esi
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f010671a:	83 f9 06             	cmp    $0x6,%ecx
f010671d:	0f 87 18 ff ff ff    	ja     f010663b <pci_scan_bus+0x37>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0106723:	8b 34 8d 84 8c 10 f0 	mov    -0xfef737c(,%ecx,4),%esi
f010672a:	e9 0c ff ff ff       	jmp    f010663b <pci_scan_bus+0x37>
				 PCI_PRODUCT(f->dev_id),
f010672f:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0106735:	53                   	push   %ebx
f0106736:	68 80 ee 2a f0       	push   $0xf02aee80
f010673b:	89 c2                	mov    %eax,%edx
f010673d:	c1 ea 10             	shr    $0x10,%edx
f0106740:	52                   	push   %edx
f0106741:	0f b7 c0             	movzwl %ax,%eax
f0106744:	50                   	push   %eax
f0106745:	e8 7e fd ff ff       	call   f01064c8 <pci_attach_match>
f010674a:	83 c4 10             	add    $0x10,%esp
f010674d:	e9 55 ff ff ff       	jmp    f01066a7 <pci_scan_bus+0xa3>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106752:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0106755:	83 c0 01             	add    $0x1,%eax
f0106758:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f010675b:	83 f8 1f             	cmp    $0x1f,%eax
f010675e:	77 5c                	ja     f01067bc <pci_scan_bus+0x1b8>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0106760:	ba 0c 00 00 00       	mov    $0xc,%edx
f0106765:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106768:	e8 72 fe ff ff       	call   f01065df <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f010676d:	89 c2                	mov    %eax,%edx
f010676f:	c1 ea 10             	shr    $0x10,%edx
f0106772:	83 e2 7f             	and    $0x7f,%edx
f0106775:	83 fa 01             	cmp    $0x1,%edx
f0106778:	77 d8                	ja     f0106752 <pci_scan_bus+0x14e>
		totaldev++;
f010677a:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)
		struct pci_func f = df;
f0106781:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0106787:	8d 75 a0             	lea    -0x60(%ebp),%esi
f010678a:	b9 12 00 00 00       	mov    $0x12,%ecx
f010678f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106791:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0106798:	00 00 00 
f010679b:	25 00 00 80 00       	and    $0x800000,%eax
f01067a0:	83 f8 01             	cmp    $0x1,%eax
f01067a3:	19 c0                	sbb    %eax,%eax
f01067a5:	83 e0 f9             	and    $0xfffffff9,%eax
f01067a8:	83 c0 08             	add    $0x8,%eax
f01067ab:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f01067b1:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01067b7:	e9 f2 fe ff ff       	jmp    f01066ae <pci_scan_bus+0xaa>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f01067bc:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f01067c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01067c5:	5b                   	pop    %ebx
f01067c6:	5e                   	pop    %esi
f01067c7:	5f                   	pop    %edi
f01067c8:	5d                   	pop    %ebp
f01067c9:	c3                   	ret    

f01067ca <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01067ca:	55                   	push   %ebp
f01067cb:	89 e5                	mov    %esp,%ebp
f01067cd:	57                   	push   %edi
f01067ce:	56                   	push   %esi
f01067cf:	53                   	push   %ebx
f01067d0:	83 ec 1c             	sub    $0x1c,%esp
f01067d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01067d6:	ba 1c 00 00 00       	mov    $0x1c,%edx
f01067db:	89 d8                	mov    %ebx,%eax
f01067dd:	e8 fd fd ff ff       	call   f01065df <pci_conf_read>
f01067e2:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f01067e4:	ba 18 00 00 00       	mov    $0x18,%edx
f01067e9:	89 d8                	mov    %ebx,%eax
f01067eb:	e8 ef fd ff ff       	call   f01065df <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f01067f0:	83 e7 0f             	and    $0xf,%edi
f01067f3:	83 ff 01             	cmp    $0x1,%edi
f01067f6:	74 56                	je     f010684e <pci_bridge_attach+0x84>
f01067f8:	89 c6                	mov    %eax,%esi
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01067fa:	83 ec 04             	sub    $0x4,%esp
f01067fd:	6a 08                	push   $0x8
f01067ff:	6a 00                	push   $0x0
f0106801:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0106804:	57                   	push   %edi
f0106805:	e8 a5 f2 ff ff       	call   f0105aaf <memset>
	nbus.parent_bridge = pcif;
f010680a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f010680d:	89 f0                	mov    %esi,%eax
f010680f:	0f b6 c4             	movzbl %ah,%eax
f0106812:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0106815:	83 c4 08             	add    $0x8,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0106818:	c1 ee 10             	shr    $0x10,%esi
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f010681b:	89 f1                	mov    %esi,%ecx
f010681d:	0f b6 f1             	movzbl %cl,%esi
f0106820:	56                   	push   %esi
f0106821:	50                   	push   %eax
f0106822:	ff 73 08             	pushl  0x8(%ebx)
f0106825:	ff 73 04             	pushl  0x4(%ebx)
f0106828:	8b 03                	mov    (%ebx),%eax
f010682a:	ff 70 04             	pushl  0x4(%eax)
f010682d:	68 0c 8b 10 f0       	push   $0xf0108b0c
f0106832:	e8 f9 d0 ff ff       	call   f0103930 <cprintf>

	pci_scan_bus(&nbus);
f0106837:	83 c4 20             	add    $0x20,%esp
f010683a:	89 f8                	mov    %edi,%eax
f010683c:	e8 c3 fd ff ff       	call   f0106604 <pci_scan_bus>
	return 1;
f0106841:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0106846:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106849:	5b                   	pop    %ebx
f010684a:	5e                   	pop    %esi
f010684b:	5f                   	pop    %edi
f010684c:	5d                   	pop    %ebp
f010684d:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010684e:	ff 73 08             	pushl  0x8(%ebx)
f0106851:	ff 73 04             	pushl  0x4(%ebx)
f0106854:	8b 03                	mov    (%ebx),%eax
f0106856:	ff 70 04             	pushl  0x4(%eax)
f0106859:	68 d8 8a 10 f0       	push   $0xf0108ad8
f010685e:	e8 cd d0 ff ff       	call   f0103930 <cprintf>
		return 0;
f0106863:	83 c4 10             	add    $0x10,%esp
f0106866:	b8 00 00 00 00       	mov    $0x0,%eax
f010686b:	eb d9                	jmp    f0106846 <pci_bridge_attach+0x7c>

f010686d <pci_conf_write>:
{
f010686d:	55                   	push   %ebp
f010686e:	89 e5                	mov    %esp,%ebp
f0106870:	56                   	push   %esi
f0106871:	53                   	push   %ebx
f0106872:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106874:	8b 48 08             	mov    0x8(%eax),%ecx
f0106877:	8b 70 04             	mov    0x4(%eax),%esi
f010687a:	8b 00                	mov    (%eax),%eax
f010687c:	8b 40 04             	mov    0x4(%eax),%eax
f010687f:	83 ec 0c             	sub    $0xc,%esp
f0106882:	52                   	push   %edx
f0106883:	89 f2                	mov    %esi,%edx
f0106885:	e8 9f fc ff ff       	call   f0106529 <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010688a:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f010688f:	89 d8                	mov    %ebx,%eax
f0106891:	ef                   	out    %eax,(%dx)
}
f0106892:	83 c4 10             	add    $0x10,%esp
f0106895:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106898:	5b                   	pop    %ebx
f0106899:	5e                   	pop    %esi
f010689a:	5d                   	pop    %ebp
f010689b:	c3                   	ret    

f010689c <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010689c:	55                   	push   %ebp
f010689d:	89 e5                	mov    %esp,%ebp
f010689f:	57                   	push   %edi
f01068a0:	56                   	push   %esi
f01068a1:	53                   	push   %ebx
f01068a2:	83 ec 2c             	sub    $0x2c,%esp
f01068a5:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f01068a8:	b9 07 00 00 00       	mov    $0x7,%ecx
f01068ad:	ba 04 00 00 00       	mov    $0x4,%edx
f01068b2:	89 f8                	mov    %edi,%eax
f01068b4:	e8 b4 ff ff ff       	call   f010686d <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01068b9:	be 10 00 00 00       	mov    $0x10,%esi
f01068be:	eb 27                	jmp    f01068e7 <pci_func_enable+0x4b>
			base = PCI_MAPREG_MEM_ADDR(oldv);
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01068c0:	89 c3                	mov    %eax,%ebx
f01068c2:	83 e3 fc             	and    $0xfffffffc,%ebx
f01068c5:	f7 db                	neg    %ebx
f01068c7:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f01068c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01068cc:	83 e0 fc             	and    $0xfffffffc,%eax
f01068cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		bar_width = 4;
f01068d2:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f01068d9:	eb 74                	jmp    f010694f <pci_func_enable+0xb3>
	     bar += bar_width)
f01068db:	03 75 e4             	add    -0x1c(%ebp),%esi
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01068de:	83 fe 27             	cmp    $0x27,%esi
f01068e1:	0f 87 c4 00 00 00    	ja     f01069ab <pci_func_enable+0x10f>
		uint32_t oldv = pci_conf_read(f, bar);
f01068e7:	89 f2                	mov    %esi,%edx
f01068e9:	89 f8                	mov    %edi,%eax
f01068eb:	e8 ef fc ff ff       	call   f01065df <pci_conf_read>
f01068f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f01068f3:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01068f8:	89 f2                	mov    %esi,%edx
f01068fa:	89 f8                	mov    %edi,%eax
f01068fc:	e8 6c ff ff ff       	call   f010686d <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0106901:	89 f2                	mov    %esi,%edx
f0106903:	89 f8                	mov    %edi,%eax
f0106905:	e8 d5 fc ff ff       	call   f01065df <pci_conf_read>
		bar_width = 4;
f010690a:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		if (rv == 0)
f0106911:	85 c0                	test   %eax,%eax
f0106913:	74 c6                	je     f01068db <pci_func_enable+0x3f>
		int regnum = PCI_MAPREG_NUM(bar);
f0106915:	8d 4e f0             	lea    -0x10(%esi),%ecx
f0106918:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010691b:	c1 e9 02             	shr    $0x2,%ecx
f010691e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0106921:	a8 01                	test   $0x1,%al
f0106923:	75 9b                	jne    f01068c0 <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0106925:	89 c2                	mov    %eax,%edx
f0106927:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f010692a:	83 fa 04             	cmp    $0x4,%edx
f010692d:	0f 94 c1             	sete   %cl
f0106930:	0f b6 c9             	movzbl %cl,%ecx
f0106933:	8d 1c 8d 04 00 00 00 	lea    0x4(,%ecx,4),%ebx
f010693a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f010693d:	89 c3                	mov    %eax,%ebx
f010693f:	83 e3 f0             	and    $0xfffffff0,%ebx
f0106942:	f7 db                	neg    %ebx
f0106944:	21 c3                	and    %eax,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0106946:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106949:	83 e0 f0             	and    $0xfffffff0,%eax
f010694c:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f010694f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106952:	89 f2                	mov    %esi,%edx
f0106954:	89 f8                	mov    %edi,%eax
f0106956:	e8 12 ff ff ff       	call   f010686d <pci_conf_write>
f010695b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010695e:	01 f8                	add    %edi,%eax
		f->reg_base[regnum] = base;
f0106960:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0106963:	89 50 14             	mov    %edx,0x14(%eax)
		f->reg_size[regnum] = size;
f0106966:	89 58 2c             	mov    %ebx,0x2c(%eax)

		if (size && !base)
f0106969:	85 db                	test   %ebx,%ebx
f010696b:	0f 84 6a ff ff ff    	je     f01068db <pci_func_enable+0x3f>
f0106971:	85 d2                	test   %edx,%edx
f0106973:	0f 85 62 ff ff ff    	jne    f01068db <pci_func_enable+0x3f>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0106979:	8b 47 0c             	mov    0xc(%edi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f010697c:	83 ec 0c             	sub    $0xc,%esp
f010697f:	53                   	push   %ebx
f0106980:	52                   	push   %edx
f0106981:	ff 75 d4             	pushl  -0x2c(%ebp)
f0106984:	89 c2                	mov    %eax,%edx
f0106986:	c1 ea 10             	shr    $0x10,%edx
f0106989:	52                   	push   %edx
f010698a:	0f b7 c0             	movzwl %ax,%eax
f010698d:	50                   	push   %eax
f010698e:	ff 77 08             	pushl  0x8(%edi)
f0106991:	ff 77 04             	pushl  0x4(%edi)
f0106994:	8b 07                	mov    (%edi),%eax
f0106996:	ff 70 04             	pushl  0x4(%eax)
f0106999:	68 3c 8b 10 f0       	push   $0xf0108b3c
f010699e:	e8 8d cf ff ff       	call   f0103930 <cprintf>
f01069a3:	83 c4 30             	add    $0x30,%esp
f01069a6:	e9 30 ff ff ff       	jmp    f01068db <pci_func_enable+0x3f>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f01069ab:	8b 47 0c             	mov    0xc(%edi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f01069ae:	83 ec 08             	sub    $0x8,%esp
f01069b1:	89 c2                	mov    %eax,%edx
f01069b3:	c1 ea 10             	shr    $0x10,%edx
f01069b6:	52                   	push   %edx
f01069b7:	0f b7 c0             	movzwl %ax,%eax
f01069ba:	50                   	push   %eax
f01069bb:	ff 77 08             	pushl  0x8(%edi)
f01069be:	ff 77 04             	pushl  0x4(%edi)
f01069c1:	8b 07                	mov    (%edi),%eax
f01069c3:	ff 70 04             	pushl  0x4(%eax)
f01069c6:	68 98 8b 10 f0       	push   $0xf0108b98
f01069cb:	e8 60 cf ff ff       	call   f0103930 <cprintf>
}
f01069d0:	83 c4 20             	add    $0x20,%esp
f01069d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01069d6:	5b                   	pop    %ebx
f01069d7:	5e                   	pop    %esi
f01069d8:	5f                   	pop    %edi
f01069d9:	5d                   	pop    %ebp
f01069da:	c3                   	ret    

f01069db <pci_init>:

int
pci_init(void)
{
f01069db:	55                   	push   %ebp
f01069dc:	89 e5                	mov    %esp,%ebp
f01069de:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f01069e1:	6a 08                	push   $0x8
f01069e3:	6a 00                	push   $0x0
f01069e5:	68 8c ee 2a f0       	push   $0xf02aee8c
f01069ea:	e8 c0 f0 ff ff       	call   f0105aaf <memset>

	return pci_scan_bus(&root_bus);
f01069ef:	b8 8c ee 2a f0       	mov    $0xf02aee8c,%eax
f01069f4:	e8 0b fc ff ff       	call   f0106604 <pci_scan_bus>
}
f01069f9:	c9                   	leave  
f01069fa:	c3                   	ret    

f01069fb <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f01069fb:	55                   	push   %ebp
f01069fc:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f01069fe:	c7 05 94 ee 2a f0 00 	movl   $0x0,0xf02aee94
f0106a05:	00 00 00 
}
f0106a08:	5d                   	pop    %ebp
f0106a09:	c3                   	ret    

f0106a0a <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0106a0a:	a1 94 ee 2a f0       	mov    0xf02aee94,%eax
f0106a0f:	83 c0 01             	add    $0x1,%eax
f0106a12:	a3 94 ee 2a f0       	mov    %eax,0xf02aee94
	if (ticks * 10 < ticks)
f0106a17:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0106a1a:	01 d2                	add    %edx,%edx
f0106a1c:	39 d0                	cmp    %edx,%eax
f0106a1e:	77 02                	ja     f0106a22 <time_tick+0x18>
f0106a20:	f3 c3                	repz ret 
{
f0106a22:	55                   	push   %ebp
f0106a23:	89 e5                	mov    %esp,%ebp
f0106a25:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f0106a28:	68 a0 8c 10 f0       	push   $0xf0108ca0
f0106a2d:	6a 13                	push   $0x13
f0106a2f:	68 bb 8c 10 f0       	push   $0xf0108cbb
f0106a34:	e8 07 96 ff ff       	call   f0100040 <_panic>

f0106a39 <time_msec>:
}

unsigned int
time_msec(void)
{
f0106a39:	55                   	push   %ebp
f0106a3a:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0106a3c:	a1 94 ee 2a f0       	mov    0xf02aee94,%eax
f0106a41:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0106a44:	01 c0                	add    %eax,%eax
}
f0106a46:	5d                   	pop    %ebp
f0106a47:	c3                   	ret    
f0106a48:	66 90                	xchg   %ax,%ax
f0106a4a:	66 90                	xchg   %ax,%ax
f0106a4c:	66 90                	xchg   %ax,%ax
f0106a4e:	66 90                	xchg   %ax,%ax

f0106a50 <__udivdi3>:
f0106a50:	55                   	push   %ebp
f0106a51:	57                   	push   %edi
f0106a52:	56                   	push   %esi
f0106a53:	53                   	push   %ebx
f0106a54:	83 ec 1c             	sub    $0x1c,%esp
f0106a57:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f0106a5b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0106a5f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0106a63:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0106a67:	85 d2                	test   %edx,%edx
f0106a69:	75 35                	jne    f0106aa0 <__udivdi3+0x50>
f0106a6b:	39 f3                	cmp    %esi,%ebx
f0106a6d:	0f 87 bd 00 00 00    	ja     f0106b30 <__udivdi3+0xe0>
f0106a73:	85 db                	test   %ebx,%ebx
f0106a75:	89 d9                	mov    %ebx,%ecx
f0106a77:	75 0b                	jne    f0106a84 <__udivdi3+0x34>
f0106a79:	b8 01 00 00 00       	mov    $0x1,%eax
f0106a7e:	31 d2                	xor    %edx,%edx
f0106a80:	f7 f3                	div    %ebx
f0106a82:	89 c1                	mov    %eax,%ecx
f0106a84:	31 d2                	xor    %edx,%edx
f0106a86:	89 f0                	mov    %esi,%eax
f0106a88:	f7 f1                	div    %ecx
f0106a8a:	89 c6                	mov    %eax,%esi
f0106a8c:	89 e8                	mov    %ebp,%eax
f0106a8e:	89 f7                	mov    %esi,%edi
f0106a90:	f7 f1                	div    %ecx
f0106a92:	89 fa                	mov    %edi,%edx
f0106a94:	83 c4 1c             	add    $0x1c,%esp
f0106a97:	5b                   	pop    %ebx
f0106a98:	5e                   	pop    %esi
f0106a99:	5f                   	pop    %edi
f0106a9a:	5d                   	pop    %ebp
f0106a9b:	c3                   	ret    
f0106a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106aa0:	39 f2                	cmp    %esi,%edx
f0106aa2:	77 7c                	ja     f0106b20 <__udivdi3+0xd0>
f0106aa4:	0f bd fa             	bsr    %edx,%edi
f0106aa7:	83 f7 1f             	xor    $0x1f,%edi
f0106aaa:	0f 84 98 00 00 00    	je     f0106b48 <__udivdi3+0xf8>
f0106ab0:	89 f9                	mov    %edi,%ecx
f0106ab2:	b8 20 00 00 00       	mov    $0x20,%eax
f0106ab7:	29 f8                	sub    %edi,%eax
f0106ab9:	d3 e2                	shl    %cl,%edx
f0106abb:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106abf:	89 c1                	mov    %eax,%ecx
f0106ac1:	89 da                	mov    %ebx,%edx
f0106ac3:	d3 ea                	shr    %cl,%edx
f0106ac5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0106ac9:	09 d1                	or     %edx,%ecx
f0106acb:	89 f2                	mov    %esi,%edx
f0106acd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106ad1:	89 f9                	mov    %edi,%ecx
f0106ad3:	d3 e3                	shl    %cl,%ebx
f0106ad5:	89 c1                	mov    %eax,%ecx
f0106ad7:	d3 ea                	shr    %cl,%edx
f0106ad9:	89 f9                	mov    %edi,%ecx
f0106adb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0106adf:	d3 e6                	shl    %cl,%esi
f0106ae1:	89 eb                	mov    %ebp,%ebx
f0106ae3:	89 c1                	mov    %eax,%ecx
f0106ae5:	d3 eb                	shr    %cl,%ebx
f0106ae7:	09 de                	or     %ebx,%esi
f0106ae9:	89 f0                	mov    %esi,%eax
f0106aeb:	f7 74 24 08          	divl   0x8(%esp)
f0106aef:	89 d6                	mov    %edx,%esi
f0106af1:	89 c3                	mov    %eax,%ebx
f0106af3:	f7 64 24 0c          	mull   0xc(%esp)
f0106af7:	39 d6                	cmp    %edx,%esi
f0106af9:	72 0c                	jb     f0106b07 <__udivdi3+0xb7>
f0106afb:	89 f9                	mov    %edi,%ecx
f0106afd:	d3 e5                	shl    %cl,%ebp
f0106aff:	39 c5                	cmp    %eax,%ebp
f0106b01:	73 5d                	jae    f0106b60 <__udivdi3+0x110>
f0106b03:	39 d6                	cmp    %edx,%esi
f0106b05:	75 59                	jne    f0106b60 <__udivdi3+0x110>
f0106b07:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0106b0a:	31 ff                	xor    %edi,%edi
f0106b0c:	89 fa                	mov    %edi,%edx
f0106b0e:	83 c4 1c             	add    $0x1c,%esp
f0106b11:	5b                   	pop    %ebx
f0106b12:	5e                   	pop    %esi
f0106b13:	5f                   	pop    %edi
f0106b14:	5d                   	pop    %ebp
f0106b15:	c3                   	ret    
f0106b16:	8d 76 00             	lea    0x0(%esi),%esi
f0106b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0106b20:	31 ff                	xor    %edi,%edi
f0106b22:	31 c0                	xor    %eax,%eax
f0106b24:	89 fa                	mov    %edi,%edx
f0106b26:	83 c4 1c             	add    $0x1c,%esp
f0106b29:	5b                   	pop    %ebx
f0106b2a:	5e                   	pop    %esi
f0106b2b:	5f                   	pop    %edi
f0106b2c:	5d                   	pop    %ebp
f0106b2d:	c3                   	ret    
f0106b2e:	66 90                	xchg   %ax,%ax
f0106b30:	31 ff                	xor    %edi,%edi
f0106b32:	89 e8                	mov    %ebp,%eax
f0106b34:	89 f2                	mov    %esi,%edx
f0106b36:	f7 f3                	div    %ebx
f0106b38:	89 fa                	mov    %edi,%edx
f0106b3a:	83 c4 1c             	add    $0x1c,%esp
f0106b3d:	5b                   	pop    %ebx
f0106b3e:	5e                   	pop    %esi
f0106b3f:	5f                   	pop    %edi
f0106b40:	5d                   	pop    %ebp
f0106b41:	c3                   	ret    
f0106b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0106b48:	39 f2                	cmp    %esi,%edx
f0106b4a:	72 06                	jb     f0106b52 <__udivdi3+0x102>
f0106b4c:	31 c0                	xor    %eax,%eax
f0106b4e:	39 eb                	cmp    %ebp,%ebx
f0106b50:	77 d2                	ja     f0106b24 <__udivdi3+0xd4>
f0106b52:	b8 01 00 00 00       	mov    $0x1,%eax
f0106b57:	eb cb                	jmp    f0106b24 <__udivdi3+0xd4>
f0106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106b60:	89 d8                	mov    %ebx,%eax
f0106b62:	31 ff                	xor    %edi,%edi
f0106b64:	eb be                	jmp    f0106b24 <__udivdi3+0xd4>
f0106b66:	66 90                	xchg   %ax,%ax
f0106b68:	66 90                	xchg   %ax,%ax
f0106b6a:	66 90                	xchg   %ax,%ax
f0106b6c:	66 90                	xchg   %ax,%ax
f0106b6e:	66 90                	xchg   %ax,%ax

f0106b70 <__umoddi3>:
f0106b70:	55                   	push   %ebp
f0106b71:	57                   	push   %edi
f0106b72:	56                   	push   %esi
f0106b73:	53                   	push   %ebx
f0106b74:	83 ec 1c             	sub    $0x1c,%esp
f0106b77:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f0106b7b:	8b 74 24 30          	mov    0x30(%esp),%esi
f0106b7f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0106b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0106b87:	85 ed                	test   %ebp,%ebp
f0106b89:	89 f0                	mov    %esi,%eax
f0106b8b:	89 da                	mov    %ebx,%edx
f0106b8d:	75 19                	jne    f0106ba8 <__umoddi3+0x38>
f0106b8f:	39 df                	cmp    %ebx,%edi
f0106b91:	0f 86 b1 00 00 00    	jbe    f0106c48 <__umoddi3+0xd8>
f0106b97:	f7 f7                	div    %edi
f0106b99:	89 d0                	mov    %edx,%eax
f0106b9b:	31 d2                	xor    %edx,%edx
f0106b9d:	83 c4 1c             	add    $0x1c,%esp
f0106ba0:	5b                   	pop    %ebx
f0106ba1:	5e                   	pop    %esi
f0106ba2:	5f                   	pop    %edi
f0106ba3:	5d                   	pop    %ebp
f0106ba4:	c3                   	ret    
f0106ba5:	8d 76 00             	lea    0x0(%esi),%esi
f0106ba8:	39 dd                	cmp    %ebx,%ebp
f0106baa:	77 f1                	ja     f0106b9d <__umoddi3+0x2d>
f0106bac:	0f bd cd             	bsr    %ebp,%ecx
f0106baf:	83 f1 1f             	xor    $0x1f,%ecx
f0106bb2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106bb6:	0f 84 b4 00 00 00    	je     f0106c70 <__umoddi3+0x100>
f0106bbc:	b8 20 00 00 00       	mov    $0x20,%eax
f0106bc1:	89 c2                	mov    %eax,%edx
f0106bc3:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106bc7:	29 c2                	sub    %eax,%edx
f0106bc9:	89 c1                	mov    %eax,%ecx
f0106bcb:	89 f8                	mov    %edi,%eax
f0106bcd:	d3 e5                	shl    %cl,%ebp
f0106bcf:	89 d1                	mov    %edx,%ecx
f0106bd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106bd5:	d3 e8                	shr    %cl,%eax
f0106bd7:	09 c5                	or     %eax,%ebp
f0106bd9:	8b 44 24 04          	mov    0x4(%esp),%eax
f0106bdd:	89 c1                	mov    %eax,%ecx
f0106bdf:	d3 e7                	shl    %cl,%edi
f0106be1:	89 d1                	mov    %edx,%ecx
f0106be3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106be7:	89 df                	mov    %ebx,%edi
f0106be9:	d3 ef                	shr    %cl,%edi
f0106beb:	89 c1                	mov    %eax,%ecx
f0106bed:	89 f0                	mov    %esi,%eax
f0106bef:	d3 e3                	shl    %cl,%ebx
f0106bf1:	89 d1                	mov    %edx,%ecx
f0106bf3:	89 fa                	mov    %edi,%edx
f0106bf5:	d3 e8                	shr    %cl,%eax
f0106bf7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f0106bfc:	09 d8                	or     %ebx,%eax
f0106bfe:	f7 f5                	div    %ebp
f0106c00:	d3 e6                	shl    %cl,%esi
f0106c02:	89 d1                	mov    %edx,%ecx
f0106c04:	f7 64 24 08          	mull   0x8(%esp)
f0106c08:	39 d1                	cmp    %edx,%ecx
f0106c0a:	89 c3                	mov    %eax,%ebx
f0106c0c:	89 d7                	mov    %edx,%edi
f0106c0e:	72 06                	jb     f0106c16 <__umoddi3+0xa6>
f0106c10:	75 0e                	jne    f0106c20 <__umoddi3+0xb0>
f0106c12:	39 c6                	cmp    %eax,%esi
f0106c14:	73 0a                	jae    f0106c20 <__umoddi3+0xb0>
f0106c16:	2b 44 24 08          	sub    0x8(%esp),%eax
f0106c1a:	19 ea                	sbb    %ebp,%edx
f0106c1c:	89 d7                	mov    %edx,%edi
f0106c1e:	89 c3                	mov    %eax,%ebx
f0106c20:	89 ca                	mov    %ecx,%edx
f0106c22:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0106c27:	29 de                	sub    %ebx,%esi
f0106c29:	19 fa                	sbb    %edi,%edx
f0106c2b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f0106c2f:	89 d0                	mov    %edx,%eax
f0106c31:	d3 e0                	shl    %cl,%eax
f0106c33:	89 d9                	mov    %ebx,%ecx
f0106c35:	d3 ee                	shr    %cl,%esi
f0106c37:	d3 ea                	shr    %cl,%edx
f0106c39:	09 f0                	or     %esi,%eax
f0106c3b:	83 c4 1c             	add    $0x1c,%esp
f0106c3e:	5b                   	pop    %ebx
f0106c3f:	5e                   	pop    %esi
f0106c40:	5f                   	pop    %edi
f0106c41:	5d                   	pop    %ebp
f0106c42:	c3                   	ret    
f0106c43:	90                   	nop
f0106c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106c48:	85 ff                	test   %edi,%edi
f0106c4a:	89 f9                	mov    %edi,%ecx
f0106c4c:	75 0b                	jne    f0106c59 <__umoddi3+0xe9>
f0106c4e:	b8 01 00 00 00       	mov    $0x1,%eax
f0106c53:	31 d2                	xor    %edx,%edx
f0106c55:	f7 f7                	div    %edi
f0106c57:	89 c1                	mov    %eax,%ecx
f0106c59:	89 d8                	mov    %ebx,%eax
f0106c5b:	31 d2                	xor    %edx,%edx
f0106c5d:	f7 f1                	div    %ecx
f0106c5f:	89 f0                	mov    %esi,%eax
f0106c61:	f7 f1                	div    %ecx
f0106c63:	e9 31 ff ff ff       	jmp    f0106b99 <__umoddi3+0x29>
f0106c68:	90                   	nop
f0106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0106c70:	39 dd                	cmp    %ebx,%ebp
f0106c72:	72 08                	jb     f0106c7c <__umoddi3+0x10c>
f0106c74:	39 f7                	cmp    %esi,%edi
f0106c76:	0f 87 21 ff ff ff    	ja     f0106b9d <__umoddi3+0x2d>
f0106c7c:	89 da                	mov    %ebx,%edx
f0106c7e:	89 f0                	mov    %esi,%eax
f0106c80:	29 f8                	sub    %edi,%eax
f0106c82:	19 ea                	sbb    %ebp,%edx
f0106c84:	e9 14 ff ff ff       	jmp    f0106b9d <__umoddi3+0x2d>

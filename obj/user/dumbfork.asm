
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 a3 01 00 00       	call   8001d4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 07                	push   $0x7
  800043:	53                   	push   %ebx
  800044:	56                   	push   %esi
  800045:	e8 dd 0c 00 00       	call   800d27 <sys_page_alloc>
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	78 4a                	js     80009b <duppage+0x68>
		panic("sys_page_alloc: %e", r);
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 07                	push   $0x7
  800056:	68 00 00 40 00       	push   $0x400000
  80005b:	6a 00                	push   $0x0
  80005d:	53                   	push   %ebx
  80005e:	56                   	push   %esi
  80005f:	e8 06 0d 00 00       	call   800d6a <sys_page_map>
  800064:	83 c4 20             	add    $0x20,%esp
  800067:	85 c0                	test   %eax,%eax
  800069:	78 42                	js     8000ad <duppage+0x7a>
		panic("sys_page_map: %e", r);
	memmove(UTEMP, addr, PGSIZE);
  80006b:	83 ec 04             	sub    $0x4,%esp
  80006e:	68 00 10 00 00       	push   $0x1000
  800073:	53                   	push   %ebx
  800074:	68 00 00 40 00       	push   $0x400000
  800079:	e8 3e 0a 00 00       	call   800abc <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80007e:	83 c4 08             	add    $0x8,%esp
  800081:	68 00 00 40 00       	push   $0x400000
  800086:	6a 00                	push   $0x0
  800088:	e8 1f 0d 00 00       	call   800dac <sys_page_unmap>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	85 c0                	test   %eax,%eax
  800092:	78 2b                	js     8000bf <duppage+0x8c>
		panic("sys_page_unmap: %e", r);
}
  800094:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800097:	5b                   	pop    %ebx
  800098:	5e                   	pop    %esi
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80009b:	50                   	push   %eax
  80009c:	68 e0 23 80 00       	push   $0x8023e0
  8000a1:	6a 20                	push   $0x20
  8000a3:	68 f3 23 80 00       	push   $0x8023f3
  8000a8:	e8 87 01 00 00       	call   800234 <_panic>
		panic("sys_page_map: %e", r);
  8000ad:	50                   	push   %eax
  8000ae:	68 03 24 80 00       	push   $0x802403
  8000b3:	6a 22                	push   $0x22
  8000b5:	68 f3 23 80 00       	push   $0x8023f3
  8000ba:	e8 75 01 00 00       	call   800234 <_panic>
		panic("sys_page_unmap: %e", r);
  8000bf:	50                   	push   %eax
  8000c0:	68 14 24 80 00       	push   $0x802414
  8000c5:	6a 25                	push   $0x25
  8000c7:	68 f3 23 80 00       	push   $0x8023f3
  8000cc:	e8 63 01 00 00       	call   800234 <_panic>

008000d1 <dumbfork>:

envid_t
dumbfork(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	56                   	push   %esi
  8000d5:	53                   	push   %ebx
  8000d6:	83 ec 10             	sub    $0x10,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8000d9:	b8 07 00 00 00       	mov    $0x7,%eax
  8000de:	cd 30                	int    $0x30
  8000e0:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  8000e2:	85 c0                	test   %eax,%eax
  8000e4:	78 0f                	js     8000f5 <dumbfork+0x24>
  8000e6:	89 c6                	mov    %eax,%esi
		panic("sys_exofork: %e", envid);
	if (envid == 0) {
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	74 1b                	je     800107 <dumbfork+0x36>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8000ec:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  8000f3:	eb 3f                	jmp    800134 <dumbfork+0x63>
		panic("sys_exofork: %e", envid);
  8000f5:	50                   	push   %eax
  8000f6:	68 27 24 80 00       	push   $0x802427
  8000fb:	6a 37                	push   $0x37
  8000fd:	68 f3 23 80 00       	push   $0x8023f3
  800102:	e8 2d 01 00 00       	call   800234 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
  800107:	e8 dd 0b 00 00       	call   800ce9 <sys_getenvid>
  80010c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800111:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800114:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800119:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  80011e:	eb 43                	jmp    800163 <dumbfork+0x92>
		duppage(envid, addr);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	52                   	push   %edx
  800124:	56                   	push   %esi
  800125:	e8 09 ff ff ff       	call   800033 <duppage>
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80012a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800137:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  80013d:	72 e1                	jb     800120 <dumbfork+0x4f>

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  80013f:	83 ec 08             	sub    $0x8,%esp
  800142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800145:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80014a:	50                   	push   %eax
  80014b:	53                   	push   %ebx
  80014c:	e8 e2 fe ff ff       	call   800033 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  800151:	83 c4 08             	add    $0x8,%esp
  800154:	6a 02                	push   $0x2
  800156:	53                   	push   %ebx
  800157:	e8 92 0c 00 00       	call   800dee <sys_env_set_status>
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	85 c0                	test   %eax,%eax
  800161:	78 09                	js     80016c <dumbfork+0x9b>
		panic("sys_env_set_status: %e", r);

	return envid;
}
  800163:	89 d8                	mov    %ebx,%eax
  800165:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800168:	5b                   	pop    %ebx
  800169:	5e                   	pop    %esi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    
		panic("sys_env_set_status: %e", r);
  80016c:	50                   	push   %eax
  80016d:	68 37 24 80 00       	push   $0x802437
  800172:	6a 4c                	push   $0x4c
  800174:	68 f3 23 80 00       	push   $0x8023f3
  800179:	e8 b6 00 00 00       	call   800234 <_panic>

0080017e <umain>:
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 0c             	sub    $0xc,%esp
	who = dumbfork();
  800187:	e8 45 ff ff ff       	call   8000d1 <dumbfork>
  80018c:	89 c7                	mov    %eax,%edi
  80018e:	85 c0                	test   %eax,%eax
  800190:	be 4e 24 80 00       	mov    $0x80244e,%esi
  800195:	b8 55 24 80 00       	mov    $0x802455,%eax
  80019a:	0f 44 f0             	cmove  %eax,%esi
	for (i = 0; i < (who ? 10 : 20); i++) {
  80019d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001a2:	eb 1f                	jmp    8001c3 <umain+0x45>
  8001a4:	83 fb 13             	cmp    $0x13,%ebx
  8001a7:	7f 23                	jg     8001cc <umain+0x4e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	68 5b 24 80 00       	push   $0x80245b
  8001b3:	e8 57 01 00 00       	call   80030f <cprintf>
		sys_yield();
  8001b8:	e8 4b 0b 00 00       	call   800d08 <sys_yield>
	for (i = 0; i < (who ? 10 : 20); i++) {
  8001bd:	83 c3 01             	add    $0x1,%ebx
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	85 ff                	test   %edi,%edi
  8001c5:	74 dd                	je     8001a4 <umain+0x26>
  8001c7:	83 fb 09             	cmp    $0x9,%ebx
  8001ca:	7e dd                	jle    8001a9 <umain+0x2b>
}
  8001cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001cf:	5b                   	pop    %ebx
  8001d0:	5e                   	pop    %esi
  8001d1:	5f                   	pop    %edi
  8001d2:	5d                   	pop    %ebp
  8001d3:	c3                   	ret    

008001d4 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8001d4:	55                   	push   %ebp
  8001d5:	89 e5                	mov    %esp,%ebp
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001df:	e8 05 0b 00 00       	call   800ce9 <sys_getenvid>
  8001e4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f1:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f6:	85 db                	test   %ebx,%ebx
  8001f8:	7e 07                	jle    800201 <libmain+0x2d>
		binaryname = argv[0];
  8001fa:	8b 06                	mov    (%esi),%eax
  8001fc:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	e8 73 ff ff ff       	call   80017e <umain>

	// exit gracefully
	exit();
  80020b:	e8 0a 00 00 00       	call   80021a <exit>
}
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800216:	5b                   	pop    %ebx
  800217:	5e                   	pop    %esi
  800218:	5d                   	pop    %ebp
  800219:	c3                   	ret    

0080021a <exit>:

#include <inc/lib.h>

void exit(void)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800220:	e8 e8 0e 00 00       	call   80110d <close_all>
	sys_env_destroy(0);
  800225:	83 ec 0c             	sub    $0xc,%esp
  800228:	6a 00                	push   $0x0
  80022a:	e8 79 0a 00 00       	call   800ca8 <sys_env_destroy>
}
  80022f:	83 c4 10             	add    $0x10,%esp
  800232:	c9                   	leave  
  800233:	c3                   	ret    

00800234 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800239:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800242:	e8 a2 0a 00 00       	call   800ce9 <sys_getenvid>
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	56                   	push   %esi
  800251:	50                   	push   %eax
  800252:	68 78 24 80 00       	push   $0x802478
  800257:	e8 b3 00 00 00       	call   80030f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025c:	83 c4 18             	add    $0x18,%esp
  80025f:	53                   	push   %ebx
  800260:	ff 75 10             	pushl  0x10(%ebp)
  800263:	e8 56 00 00 00       	call   8002be <vcprintf>
	cprintf("\n");
  800268:	c7 04 24 6b 24 80 00 	movl   $0x80246b,(%esp)
  80026f:	e8 9b 00 00 00       	call   80030f <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800277:	cc                   	int3   
  800278:	eb fd                	jmp    800277 <_panic+0x43>

0080027a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	53                   	push   %ebx
  80027e:	83 ec 04             	sub    $0x4,%esp
  800281:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800284:	8b 13                	mov    (%ebx),%edx
  800286:	8d 42 01             	lea    0x1(%edx),%eax
  800289:	89 03                	mov    %eax,(%ebx)
  80028b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800292:	3d ff 00 00 00       	cmp    $0xff,%eax
  800297:	74 09                	je     8002a2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800299:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	68 ff 00 00 00       	push   $0xff
  8002aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ad:	50                   	push   %eax
  8002ae:	e8 b8 09 00 00       	call   800c6b <sys_cputs>
		b->idx = 0;
  8002b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	eb db                	jmp    800299 <putch+0x1f>

008002be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ce:	00 00 00 
	b.cnt = 0;
  8002d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002db:	ff 75 0c             	pushl  0xc(%ebp)
  8002de:	ff 75 08             	pushl  0x8(%ebp)
  8002e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e7:	50                   	push   %eax
  8002e8:	68 7a 02 80 00       	push   $0x80027a
  8002ed:	e8 1a 01 00 00       	call   80040c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f2:	83 c4 08             	add    $0x8,%esp
  8002f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800301:	50                   	push   %eax
  800302:	e8 64 09 00 00       	call   800c6b <sys_cputs>

	return b.cnt;
}
  800307:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800315:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800318:	50                   	push   %eax
  800319:	ff 75 08             	pushl  0x8(%ebp)
  80031c:	e8 9d ff ff ff       	call   8002be <vcprintf>
	va_end(ap);

	return cnt;
}
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	83 ec 1c             	sub    $0x1c,%esp
  80032c:	89 c7                	mov    %eax,%edi
  80032e:	89 d6                	mov    %edx,%esi
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	8b 55 0c             	mov    0xc(%ebp),%edx
  800336:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800339:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800344:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800347:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80034a:	39 d3                	cmp    %edx,%ebx
  80034c:	72 05                	jb     800353 <printnum+0x30>
  80034e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800351:	77 7a                	ja     8003cd <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 18             	pushl  0x18(%ebp)
  800359:	8b 45 14             	mov    0x14(%ebp),%eax
  80035c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035f:	53                   	push   %ebx
  800360:	ff 75 10             	pushl  0x10(%ebp)
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	ff 75 dc             	pushl  -0x24(%ebp)
  80036f:	ff 75 d8             	pushl  -0x28(%ebp)
  800372:	e8 19 1e 00 00       	call   802190 <__udivdi3>
  800377:	83 c4 18             	add    $0x18,%esp
  80037a:	52                   	push   %edx
  80037b:	50                   	push   %eax
  80037c:	89 f2                	mov    %esi,%edx
  80037e:	89 f8                	mov    %edi,%eax
  800380:	e8 9e ff ff ff       	call   800323 <printnum>
  800385:	83 c4 20             	add    $0x20,%esp
  800388:	eb 13                	jmp    80039d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80038a:	83 ec 08             	sub    $0x8,%esp
  80038d:	56                   	push   %esi
  80038e:	ff 75 18             	pushl  0x18(%ebp)
  800391:	ff d7                	call   *%edi
  800393:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800396:	83 eb 01             	sub    $0x1,%ebx
  800399:	85 db                	test   %ebx,%ebx
  80039b:	7f ed                	jg     80038a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	56                   	push   %esi
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8003aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8003b0:	e8 fb 1e 00 00       	call   8022b0 <__umoddi3>
  8003b5:	83 c4 14             	add    $0x14,%esp
  8003b8:	0f be 80 9b 24 80 00 	movsbl 0x80249b(%eax),%eax
  8003bf:	50                   	push   %eax
  8003c0:	ff d7                	call   *%edi
}
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c8:	5b                   	pop    %ebx
  8003c9:	5e                   	pop    %esi
  8003ca:	5f                   	pop    %edi
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    
  8003cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d0:	eb c4                	jmp    800396 <printnum+0x73>

008003d2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d2:	55                   	push   %ebp
  8003d3:	89 e5                	mov    %esp,%ebp
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003dc:	8b 10                	mov    (%eax),%edx
  8003de:	3b 50 04             	cmp    0x4(%eax),%edx
  8003e1:	73 0a                	jae    8003ed <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e6:	89 08                	mov    %ecx,(%eax)
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	88 02                	mov    %al,(%edx)
}
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <printfmt>:
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f5:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 10             	pushl  0x10(%ebp)
  8003fc:	ff 75 0c             	pushl  0xc(%ebp)
  8003ff:	ff 75 08             	pushl  0x8(%ebp)
  800402:	e8 05 00 00 00       	call   80040c <vprintfmt>
}
  800407:	83 c4 10             	add    $0x10,%esp
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <vprintfmt>:
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	57                   	push   %edi
  800410:	56                   	push   %esi
  800411:	53                   	push   %ebx
  800412:	83 ec 2c             	sub    $0x2c,%esp
  800415:	8b 75 08             	mov    0x8(%ebp),%esi
  800418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80041b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041e:	e9 c1 03 00 00       	jmp    8007e4 <vprintfmt+0x3d8>
		padc = ' ';
  800423:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800427:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800435:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800441:	8d 47 01             	lea    0x1(%edi),%eax
  800444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800447:	0f b6 17             	movzbl (%edi),%edx
  80044a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044d:	3c 55                	cmp    $0x55,%al
  80044f:	0f 87 12 04 00 00    	ja     800867 <vprintfmt+0x45b>
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	ff 24 85 e0 25 80 00 	jmp    *0x8025e0(,%eax,4)
  80045f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800462:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800466:	eb d9                	jmp    800441 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80046b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80046f:	eb d0                	jmp    800441 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800471:	0f b6 d2             	movzbl %dl,%edx
  800474:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800477:	b8 00 00 00 00       	mov    $0x0,%eax
  80047c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80047f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800482:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800486:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800489:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048c:	83 f9 09             	cmp    $0x9,%ecx
  80048f:	77 55                	ja     8004e6 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800491:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800494:	eb e9                	jmp    80047f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049e:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a1:	8d 40 04             	lea    0x4(%eax),%eax
  8004a4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ae:	79 91                	jns    800441 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004bd:	eb 82                	jmp    800441 <vprintfmt+0x35>
  8004bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c2:	85 c0                	test   %eax,%eax
  8004c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c9:	0f 49 d0             	cmovns %eax,%edx
  8004cc:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d2:	e9 6a ff ff ff       	jmp    800441 <vprintfmt+0x35>
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004da:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004e1:	e9 5b ff ff ff       	jmp    800441 <vprintfmt+0x35>
  8004e6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ec:	eb bc                	jmp    8004aa <vprintfmt+0x9e>
			lflag++;
  8004ee:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f4:	e9 48 ff ff ff       	jmp    800441 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8d 78 04             	lea    0x4(%eax),%edi
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	ff 30                	pushl  (%eax)
  800505:	ff d6                	call   *%esi
			break;
  800507:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80050a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050d:	e9 cf 02 00 00       	jmp    8007e1 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800512:	8b 45 14             	mov    0x14(%ebp),%eax
  800515:	8d 78 04             	lea    0x4(%eax),%edi
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	99                   	cltd   
  80051b:	31 d0                	xor    %edx,%eax
  80051d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051f:	83 f8 0f             	cmp    $0xf,%eax
  800522:	7f 23                	jg     800547 <vprintfmt+0x13b>
  800524:	8b 14 85 40 27 80 00 	mov    0x802740(,%eax,4),%edx
  80052b:	85 d2                	test   %edx,%edx
  80052d:	74 18                	je     800547 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80052f:	52                   	push   %edx
  800530:	68 79 28 80 00       	push   $0x802879
  800535:	53                   	push   %ebx
  800536:	56                   	push   %esi
  800537:	e8 b3 fe ff ff       	call   8003ef <printfmt>
  80053c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800542:	e9 9a 02 00 00       	jmp    8007e1 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800547:	50                   	push   %eax
  800548:	68 b3 24 80 00       	push   $0x8024b3
  80054d:	53                   	push   %ebx
  80054e:	56                   	push   %esi
  80054f:	e8 9b fe ff ff       	call   8003ef <printfmt>
  800554:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800557:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80055a:	e9 82 02 00 00       	jmp    8007e1 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056d:	85 ff                	test   %edi,%edi
  80056f:	b8 ac 24 80 00       	mov    $0x8024ac,%eax
  800574:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80057b:	0f 8e bd 00 00 00    	jle    80063e <vprintfmt+0x232>
  800581:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800585:	75 0e                	jne    800595 <vprintfmt+0x189>
  800587:	89 75 08             	mov    %esi,0x8(%ebp)
  80058a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800590:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800593:	eb 6d                	jmp    800602 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	ff 75 d0             	pushl  -0x30(%ebp)
  80059b:	57                   	push   %edi
  80059c:	e8 6e 03 00 00       	call   80090f <strnlen>
  8005a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a4:	29 c1                	sub    %eax,%ecx
  8005a6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005ac:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b8:	eb 0f                	jmp    8005c9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005ba:	83 ec 08             	sub    $0x8,%esp
  8005bd:	53                   	push   %ebx
  8005be:	ff 75 e0             	pushl  -0x20(%ebp)
  8005c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	83 ef 01             	sub    $0x1,%edi
  8005c6:	83 c4 10             	add    $0x10,%esp
  8005c9:	85 ff                	test   %edi,%edi
  8005cb:	7f ed                	jg     8005ba <vprintfmt+0x1ae>
  8005cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005d0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	0f 49 c1             	cmovns %ecx,%eax
  8005dd:	29 c1                	sub    %eax,%ecx
  8005df:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e5:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e8:	89 cb                	mov    %ecx,%ebx
  8005ea:	eb 16                	jmp    800602 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005f0:	75 31                	jne    800623 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	50                   	push   %eax
  8005f9:	ff 55 08             	call   *0x8(%ebp)
  8005fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ff:	83 eb 01             	sub    $0x1,%ebx
  800602:	83 c7 01             	add    $0x1,%edi
  800605:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800609:	0f be c2             	movsbl %dl,%eax
  80060c:	85 c0                	test   %eax,%eax
  80060e:	74 59                	je     800669 <vprintfmt+0x25d>
  800610:	85 f6                	test   %esi,%esi
  800612:	78 d8                	js     8005ec <vprintfmt+0x1e0>
  800614:	83 ee 01             	sub    $0x1,%esi
  800617:	79 d3                	jns    8005ec <vprintfmt+0x1e0>
  800619:	89 df                	mov    %ebx,%edi
  80061b:	8b 75 08             	mov    0x8(%ebp),%esi
  80061e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800621:	eb 37                	jmp    80065a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800623:	0f be d2             	movsbl %dl,%edx
  800626:	83 ea 20             	sub    $0x20,%edx
  800629:	83 fa 5e             	cmp    $0x5e,%edx
  80062c:	76 c4                	jbe    8005f2 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062e:	83 ec 08             	sub    $0x8,%esp
  800631:	ff 75 0c             	pushl  0xc(%ebp)
  800634:	6a 3f                	push   $0x3f
  800636:	ff 55 08             	call   *0x8(%ebp)
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	eb c1                	jmp    8005ff <vprintfmt+0x1f3>
  80063e:	89 75 08             	mov    %esi,0x8(%ebp)
  800641:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800644:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800647:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80064a:	eb b6                	jmp    800602 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064c:	83 ec 08             	sub    $0x8,%esp
  80064f:	53                   	push   %ebx
  800650:	6a 20                	push   $0x20
  800652:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800654:	83 ef 01             	sub    $0x1,%edi
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	85 ff                	test   %edi,%edi
  80065c:	7f ee                	jg     80064c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
  800664:	e9 78 01 00 00       	jmp    8007e1 <vprintfmt+0x3d5>
  800669:	89 df                	mov    %ebx,%edi
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800671:	eb e7                	jmp    80065a <vprintfmt+0x24e>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7e 3f                	jle    8006b7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 50 04             	mov    0x4(%eax),%edx
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800683:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8d 40 08             	lea    0x8(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800693:	79 5c                	jns    8006f1 <vprintfmt+0x2e5>
				putch('-', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 2d                	push   $0x2d
  80069b:	ff d6                	call   *%esi
				num = -(long long) num;
  80069d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a3:	f7 da                	neg    %edx
  8006a5:	83 d1 00             	adc    $0x0,%ecx
  8006a8:	f7 d9                	neg    %ecx
  8006aa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b2:	e9 10 01 00 00       	jmp    8007c7 <vprintfmt+0x3bb>
	else if (lflag)
  8006b7:	85 c9                	test   %ecx,%ecx
  8006b9:	75 1b                	jne    8006d6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c3:	89 c1                	mov    %eax,%ecx
  8006c5:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d4:	eb b9                	jmp    80068f <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006de:	89 c1                	mov    %eax,%ecx
  8006e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e9:	8d 40 04             	lea    0x4(%eax),%eax
  8006ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ef:	eb 9e                	jmp    80068f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006f7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fc:	e9 c6 00 00 00       	jmp    8007c7 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800701:	83 f9 01             	cmp    $0x1,%ecx
  800704:	7e 18                	jle    80071e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	8b 48 04             	mov    0x4(%eax),%ecx
  80070e:	8d 40 08             	lea    0x8(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800714:	b8 0a 00 00 00       	mov    $0xa,%eax
  800719:	e9 a9 00 00 00       	jmp    8007c7 <vprintfmt+0x3bb>
	else if (lflag)
  80071e:	85 c9                	test   %ecx,%ecx
  800720:	75 1a                	jne    80073c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 10                	mov    (%eax),%edx
  800727:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800732:	b8 0a 00 00 00       	mov    $0xa,%eax
  800737:	e9 8b 00 00 00       	jmp    8007c7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80073c:	8b 45 14             	mov    0x14(%ebp),%eax
  80073f:	8b 10                	mov    (%eax),%edx
  800741:	b9 00 00 00 00       	mov    $0x0,%ecx
  800746:	8d 40 04             	lea    0x4(%eax),%eax
  800749:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800751:	eb 74                	jmp    8007c7 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800753:	83 f9 01             	cmp    $0x1,%ecx
  800756:	7e 15                	jle    80076d <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	8b 48 04             	mov    0x4(%eax),%ecx
  800760:	8d 40 08             	lea    0x8(%eax),%eax
  800763:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800766:	b8 08 00 00 00       	mov    $0x8,%eax
  80076b:	eb 5a                	jmp    8007c7 <vprintfmt+0x3bb>
	else if (lflag)
  80076d:	85 c9                	test   %ecx,%ecx
  80076f:	75 17                	jne    800788 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 10                	mov    (%eax),%edx
  800776:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077b:	8d 40 04             	lea    0x4(%eax),%eax
  80077e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800781:	b8 08 00 00 00       	mov    $0x8,%eax
  800786:	eb 3f                	jmp    8007c7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8b 10                	mov    (%eax),%edx
  80078d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800798:	b8 08 00 00 00       	mov    $0x8,%eax
  80079d:	eb 28                	jmp    8007c7 <vprintfmt+0x3bb>
			putch('0', putdat);
  80079f:	83 ec 08             	sub    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 30                	push   $0x30
  8007a5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a7:	83 c4 08             	add    $0x8,%esp
  8007aa:	53                   	push   %ebx
  8007ab:	6a 78                	push   $0x78
  8007ad:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 10                	mov    (%eax),%edx
  8007b4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007b9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007bc:	8d 40 04             	lea    0x4(%eax),%eax
  8007bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007c7:	83 ec 0c             	sub    $0xc,%esp
  8007ca:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007ce:	57                   	push   %edi
  8007cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	89 da                	mov    %ebx,%edx
  8007d7:	89 f0                	mov    %esi,%eax
  8007d9:	e8 45 fb ff ff       	call   800323 <printnum>
			break;
  8007de:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	83 c7 01             	add    $0x1,%edi
  8007e7:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007eb:	83 f8 25             	cmp    $0x25,%eax
  8007ee:	0f 84 2f fc ff ff    	je     800423 <vprintfmt+0x17>
			if (ch == '\0')
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	0f 84 8b 00 00 00    	je     800887 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	53                   	push   %ebx
  800800:	50                   	push   %eax
  800801:	ff d6                	call   *%esi
  800803:	83 c4 10             	add    $0x10,%esp
  800806:	eb dc                	jmp    8007e4 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800808:	83 f9 01             	cmp    $0x1,%ecx
  80080b:	7e 15                	jle    800822 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	8b 10                	mov    (%eax),%edx
  800812:	8b 48 04             	mov    0x4(%eax),%ecx
  800815:	8d 40 08             	lea    0x8(%eax),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80081b:	b8 10 00 00 00       	mov    $0x10,%eax
  800820:	eb a5                	jmp    8007c7 <vprintfmt+0x3bb>
	else if (lflag)
  800822:	85 c9                	test   %ecx,%ecx
  800824:	75 17                	jne    80083d <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800826:	8b 45 14             	mov    0x14(%ebp),%eax
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800830:	8d 40 04             	lea    0x4(%eax),%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800836:	b8 10 00 00 00       	mov    $0x10,%eax
  80083b:	eb 8a                	jmp    8007c7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8b 10                	mov    (%eax),%edx
  800842:	b9 00 00 00 00       	mov    $0x0,%ecx
  800847:	8d 40 04             	lea    0x4(%eax),%eax
  80084a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084d:	b8 10 00 00 00       	mov    $0x10,%eax
  800852:	e9 70 ff ff ff       	jmp    8007c7 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800857:	83 ec 08             	sub    $0x8,%esp
  80085a:	53                   	push   %ebx
  80085b:	6a 25                	push   $0x25
  80085d:	ff d6                	call   *%esi
			break;
  80085f:	83 c4 10             	add    $0x10,%esp
  800862:	e9 7a ff ff ff       	jmp    8007e1 <vprintfmt+0x3d5>
			putch('%', putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	53                   	push   %ebx
  80086b:	6a 25                	push   $0x25
  80086d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	89 f8                	mov    %edi,%eax
  800874:	eb 03                	jmp    800879 <vprintfmt+0x46d>
  800876:	83 e8 01             	sub    $0x1,%eax
  800879:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087d:	75 f7                	jne    800876 <vprintfmt+0x46a>
  80087f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800882:	e9 5a ff ff ff       	jmp    8007e1 <vprintfmt+0x3d5>
}
  800887:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80088a:	5b                   	pop    %ebx
  80088b:	5e                   	pop    %esi
  80088c:	5f                   	pop    %edi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 18             	sub    $0x18,%esp
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ac:	85 c0                	test   %eax,%eax
  8008ae:	74 26                	je     8008d6 <vsnprintf+0x47>
  8008b0:	85 d2                	test   %edx,%edx
  8008b2:	7e 22                	jle    8008d6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b4:	ff 75 14             	pushl  0x14(%ebp)
  8008b7:	ff 75 10             	pushl  0x10(%ebp)
  8008ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008bd:	50                   	push   %eax
  8008be:	68 d2 03 80 00       	push   $0x8003d2
  8008c3:	e8 44 fb ff ff       	call   80040c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d1:	83 c4 10             	add    $0x10,%esp
}
  8008d4:	c9                   	leave  
  8008d5:	c3                   	ret    
		return -E_INVAL;
  8008d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008db:	eb f7                	jmp    8008d4 <vsnprintf+0x45>

008008dd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e3:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e6:	50                   	push   %eax
  8008e7:	ff 75 10             	pushl  0x10(%ebp)
  8008ea:	ff 75 0c             	pushl  0xc(%ebp)
  8008ed:	ff 75 08             	pushl  0x8(%ebp)
  8008f0:	e8 9a ff ff ff       	call   80088f <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    

008008f7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800902:	eb 03                	jmp    800907 <strlen+0x10>
		n++;
  800904:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800907:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80090b:	75 f7                	jne    800904 <strlen+0xd>
	return n;
}
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800918:	b8 00 00 00 00       	mov    $0x0,%eax
  80091d:	eb 03                	jmp    800922 <strnlen+0x13>
		n++;
  80091f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800922:	39 d0                	cmp    %edx,%eax
  800924:	74 06                	je     80092c <strnlen+0x1d>
  800926:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80092a:	75 f3                	jne    80091f <strnlen+0x10>
	return n;
}
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	53                   	push   %ebx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800938:	89 c2                	mov    %eax,%edx
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
  800940:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800944:	88 5a ff             	mov    %bl,-0x1(%edx)
  800947:	84 db                	test   %bl,%bl
  800949:	75 ef                	jne    80093a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80094b:	5b                   	pop    %ebx
  80094c:	5d                   	pop    %ebp
  80094d:	c3                   	ret    

0080094e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	53                   	push   %ebx
  800952:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800955:	53                   	push   %ebx
  800956:	e8 9c ff ff ff       	call   8008f7 <strlen>
  80095b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	01 d8                	add    %ebx,%eax
  800963:	50                   	push   %eax
  800964:	e8 c5 ff ff ff       	call   80092e <strcpy>
	return dst;
}
  800969:	89 d8                	mov    %ebx,%eax
  80096b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	56                   	push   %esi
  800974:	53                   	push   %ebx
  800975:	8b 75 08             	mov    0x8(%ebp),%esi
  800978:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097b:	89 f3                	mov    %esi,%ebx
  80097d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800980:	89 f2                	mov    %esi,%edx
  800982:	eb 0f                	jmp    800993 <strncpy+0x23>
		*dst++ = *src;
  800984:	83 c2 01             	add    $0x1,%edx
  800987:	0f b6 01             	movzbl (%ecx),%eax
  80098a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098d:	80 39 01             	cmpb   $0x1,(%ecx)
  800990:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800993:	39 da                	cmp    %ebx,%edx
  800995:	75 ed                	jne    800984 <strncpy+0x14>
	}
	return ret;
}
  800997:	89 f0                	mov    %esi,%eax
  800999:	5b                   	pop    %ebx
  80099a:	5e                   	pop    %esi
  80099b:	5d                   	pop    %ebp
  80099c:	c3                   	ret    

0080099d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009ab:	89 f0                	mov    %esi,%eax
  8009ad:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b1:	85 c9                	test   %ecx,%ecx
  8009b3:	75 0b                	jne    8009c0 <strlcpy+0x23>
  8009b5:	eb 17                	jmp    8009ce <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009b7:	83 c2 01             	add    $0x1,%edx
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009c0:	39 d8                	cmp    %ebx,%eax
  8009c2:	74 07                	je     8009cb <strlcpy+0x2e>
  8009c4:	0f b6 0a             	movzbl (%edx),%ecx
  8009c7:	84 c9                	test   %cl,%cl
  8009c9:	75 ec                	jne    8009b7 <strlcpy+0x1a>
		*dst = '\0';
  8009cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ce:	29 f0                	sub    %esi,%eax
}
  8009d0:	5b                   	pop    %ebx
  8009d1:	5e                   	pop    %esi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009da:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009dd:	eb 06                	jmp    8009e5 <strcmp+0x11>
		p++, q++;
  8009df:	83 c1 01             	add    $0x1,%ecx
  8009e2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009e5:	0f b6 01             	movzbl (%ecx),%eax
  8009e8:	84 c0                	test   %al,%al
  8009ea:	74 04                	je     8009f0 <strcmp+0x1c>
  8009ec:	3a 02                	cmp    (%edx),%al
  8009ee:	74 ef                	je     8009df <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f0:	0f b6 c0             	movzbl %al,%eax
  8009f3:	0f b6 12             	movzbl (%edx),%edx
  8009f6:	29 d0                	sub    %edx,%eax
}
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a04:	89 c3                	mov    %eax,%ebx
  800a06:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a09:	eb 06                	jmp    800a11 <strncmp+0x17>
		n--, p++, q++;
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a11:	39 d8                	cmp    %ebx,%eax
  800a13:	74 16                	je     800a2b <strncmp+0x31>
  800a15:	0f b6 08             	movzbl (%eax),%ecx
  800a18:	84 c9                	test   %cl,%cl
  800a1a:	74 04                	je     800a20 <strncmp+0x26>
  800a1c:	3a 0a                	cmp    (%edx),%cl
  800a1e:	74 eb                	je     800a0b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a20:	0f b6 00             	movzbl (%eax),%eax
  800a23:	0f b6 12             	movzbl (%edx),%edx
  800a26:	29 d0                	sub    %edx,%eax
}
  800a28:	5b                   	pop    %ebx
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    
		return 0;
  800a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a30:	eb f6                	jmp    800a28 <strncmp+0x2e>

00800a32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3c:	0f b6 10             	movzbl (%eax),%edx
  800a3f:	84 d2                	test   %dl,%dl
  800a41:	74 09                	je     800a4c <strchr+0x1a>
		if (*s == c)
  800a43:	38 ca                	cmp    %cl,%dl
  800a45:	74 0a                	je     800a51 <strchr+0x1f>
	for (; *s; s++)
  800a47:	83 c0 01             	add    $0x1,%eax
  800a4a:	eb f0                	jmp    800a3c <strchr+0xa>
			return (char *) s;
	return 0;
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5d:	eb 03                	jmp    800a62 <strfind+0xf>
  800a5f:	83 c0 01             	add    $0x1,%eax
  800a62:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a65:	38 ca                	cmp    %cl,%dl
  800a67:	74 04                	je     800a6d <strfind+0x1a>
  800a69:	84 d2                	test   %dl,%dl
  800a6b:	75 f2                	jne    800a5f <strfind+0xc>
			break;
	return (char *) s;
}
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	57                   	push   %edi
  800a73:	56                   	push   %esi
  800a74:	53                   	push   %ebx
  800a75:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7b:	85 c9                	test   %ecx,%ecx
  800a7d:	74 13                	je     800a92 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a85:	75 05                	jne    800a8c <memset+0x1d>
  800a87:	f6 c1 03             	test   $0x3,%cl
  800a8a:	74 0d                	je     800a99 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8f:	fc                   	cld    
  800a90:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a92:	89 f8                	mov    %edi,%eax
  800a94:	5b                   	pop    %ebx
  800a95:	5e                   	pop    %esi
  800a96:	5f                   	pop    %edi
  800a97:	5d                   	pop    %ebp
  800a98:	c3                   	ret    
		c &= 0xFF;
  800a99:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9d:	89 d3                	mov    %edx,%ebx
  800a9f:	c1 e3 08             	shl    $0x8,%ebx
  800aa2:	89 d0                	mov    %edx,%eax
  800aa4:	c1 e0 18             	shl    $0x18,%eax
  800aa7:	89 d6                	mov    %edx,%esi
  800aa9:	c1 e6 10             	shl    $0x10,%esi
  800aac:	09 f0                	or     %esi,%eax
  800aae:	09 c2                	or     %eax,%edx
  800ab0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ab2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab5:	89 d0                	mov    %edx,%eax
  800ab7:	fc                   	cld    
  800ab8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aba:	eb d6                	jmp    800a92 <memset+0x23>

00800abc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	57                   	push   %edi
  800ac0:	56                   	push   %esi
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aca:	39 c6                	cmp    %eax,%esi
  800acc:	73 35                	jae    800b03 <memmove+0x47>
  800ace:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad1:	39 c2                	cmp    %eax,%edx
  800ad3:	76 2e                	jbe    800b03 <memmove+0x47>
		s += n;
		d += n;
  800ad5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad8:	89 d6                	mov    %edx,%esi
  800ada:	09 fe                	or     %edi,%esi
  800adc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae2:	74 0c                	je     800af0 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae4:	83 ef 01             	sub    $0x1,%edi
  800ae7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aea:	fd                   	std    
  800aeb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aed:	fc                   	cld    
  800aee:	eb 21                	jmp    800b11 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af0:	f6 c1 03             	test   $0x3,%cl
  800af3:	75 ef                	jne    800ae4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af5:	83 ef 04             	sub    $0x4,%edi
  800af8:	8d 72 fc             	lea    -0x4(%edx),%esi
  800afb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afe:	fd                   	std    
  800aff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b01:	eb ea                	jmp    800aed <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b03:	89 f2                	mov    %esi,%edx
  800b05:	09 c2                	or     %eax,%edx
  800b07:	f6 c2 03             	test   $0x3,%dl
  800b0a:	74 09                	je     800b15 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b0c:	89 c7                	mov    %eax,%edi
  800b0e:	fc                   	cld    
  800b0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b11:	5e                   	pop    %esi
  800b12:	5f                   	pop    %edi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b15:	f6 c1 03             	test   $0x3,%cl
  800b18:	75 f2                	jne    800b0c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1d:	89 c7                	mov    %eax,%edi
  800b1f:	fc                   	cld    
  800b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b22:	eb ed                	jmp    800b11 <memmove+0x55>

00800b24 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b27:	ff 75 10             	pushl  0x10(%ebp)
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 87 ff ff ff       	call   800abc <memmove>
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	89 c6                	mov    %eax,%esi
  800b44:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b47:	39 f0                	cmp    %esi,%eax
  800b49:	74 1c                	je     800b67 <memcmp+0x30>
		if (*s1 != *s2)
  800b4b:	0f b6 08             	movzbl (%eax),%ecx
  800b4e:	0f b6 1a             	movzbl (%edx),%ebx
  800b51:	38 d9                	cmp    %bl,%cl
  800b53:	75 08                	jne    800b5d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b55:	83 c0 01             	add    $0x1,%eax
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	eb ea                	jmp    800b47 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b5d:	0f b6 c1             	movzbl %cl,%eax
  800b60:	0f b6 db             	movzbl %bl,%ebx
  800b63:	29 d8                	sub    %ebx,%eax
  800b65:	eb 05                	jmp    800b6c <memcmp+0x35>
	}

	return 0;
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5d                   	pop    %ebp
  800b6f:	c3                   	ret    

00800b70 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7e:	39 d0                	cmp    %edx,%eax
  800b80:	73 09                	jae    800b8b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b82:	38 08                	cmp    %cl,(%eax)
  800b84:	74 05                	je     800b8b <memfind+0x1b>
	for (; s < ends; s++)
  800b86:	83 c0 01             	add    $0x1,%eax
  800b89:	eb f3                	jmp    800b7e <memfind+0xe>
			break;
	return (void *) s;
}
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b99:	eb 03                	jmp    800b9e <strtol+0x11>
		s++;
  800b9b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9e:	0f b6 01             	movzbl (%ecx),%eax
  800ba1:	3c 20                	cmp    $0x20,%al
  800ba3:	74 f6                	je     800b9b <strtol+0xe>
  800ba5:	3c 09                	cmp    $0x9,%al
  800ba7:	74 f2                	je     800b9b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba9:	3c 2b                	cmp    $0x2b,%al
  800bab:	74 2e                	je     800bdb <strtol+0x4e>
	int neg = 0;
  800bad:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb2:	3c 2d                	cmp    $0x2d,%al
  800bb4:	74 2f                	je     800be5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bbc:	75 05                	jne    800bc3 <strtol+0x36>
  800bbe:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc1:	74 2c                	je     800bef <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc3:	85 db                	test   %ebx,%ebx
  800bc5:	75 0a                	jne    800bd1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bcc:	80 39 30             	cmpb   $0x30,(%ecx)
  800bcf:	74 28                	je     800bf9 <strtol+0x6c>
		base = 10;
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd9:	eb 50                	jmp    800c2b <strtol+0x9e>
		s++;
  800bdb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bde:	bf 00 00 00 00       	mov    $0x0,%edi
  800be3:	eb d1                	jmp    800bb6 <strtol+0x29>
		s++, neg = 1;
  800be5:	83 c1 01             	add    $0x1,%ecx
  800be8:	bf 01 00 00 00       	mov    $0x1,%edi
  800bed:	eb c7                	jmp    800bb6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bef:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf3:	74 0e                	je     800c03 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf5:	85 db                	test   %ebx,%ebx
  800bf7:	75 d8                	jne    800bd1 <strtol+0x44>
		s++, base = 8;
  800bf9:	83 c1 01             	add    $0x1,%ecx
  800bfc:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c01:	eb ce                	jmp    800bd1 <strtol+0x44>
		s += 2, base = 16;
  800c03:	83 c1 02             	add    $0x2,%ecx
  800c06:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c0b:	eb c4                	jmp    800bd1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c10:	89 f3                	mov    %esi,%ebx
  800c12:	80 fb 19             	cmp    $0x19,%bl
  800c15:	77 29                	ja     800c40 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c17:	0f be d2             	movsbl %dl,%edx
  800c1a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c20:	7d 30                	jge    800c52 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c22:	83 c1 01             	add    $0x1,%ecx
  800c25:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c2b:	0f b6 11             	movzbl (%ecx),%edx
  800c2e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c31:	89 f3                	mov    %esi,%ebx
  800c33:	80 fb 09             	cmp    $0x9,%bl
  800c36:	77 d5                	ja     800c0d <strtol+0x80>
			dig = *s - '0';
  800c38:	0f be d2             	movsbl %dl,%edx
  800c3b:	83 ea 30             	sub    $0x30,%edx
  800c3e:	eb dd                	jmp    800c1d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c40:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c43:	89 f3                	mov    %esi,%ebx
  800c45:	80 fb 19             	cmp    $0x19,%bl
  800c48:	77 08                	ja     800c52 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c4a:	0f be d2             	movsbl %dl,%edx
  800c4d:	83 ea 37             	sub    $0x37,%edx
  800c50:	eb cb                	jmp    800c1d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c56:	74 05                	je     800c5d <strtol+0xd0>
		*endptr = (char *) s;
  800c58:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c5b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5d:	89 c2                	mov    %eax,%edx
  800c5f:	f7 da                	neg    %edx
  800c61:	85 ff                	test   %edi,%edi
  800c63:	0f 45 c2             	cmovne %edx,%eax
}
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	57                   	push   %edi
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	89 c7                	mov    %eax,%edi
  800c80:	89 c6                	mov    %eax,%esi
  800c82:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    

00800c89 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c94:	b8 01 00 00 00       	mov    $0x1,%eax
  800c99:	89 d1                	mov    %edx,%ecx
  800c9b:	89 d3                	mov    %edx,%ebx
  800c9d:	89 d7                	mov    %edx,%edi
  800c9f:	89 d6                	mov    %edx,%esi
  800ca1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca3:	5b                   	pop    %ebx
  800ca4:	5e                   	pop    %esi
  800ca5:	5f                   	pop    %edi
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	57                   	push   %edi
  800cac:	56                   	push   %esi
  800cad:	53                   	push   %ebx
  800cae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbe:	89 cb                	mov    %ecx,%ebx
  800cc0:	89 cf                	mov    %ecx,%edi
  800cc2:	89 ce                	mov    %ecx,%esi
  800cc4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc6:	85 c0                	test   %eax,%eax
  800cc8:	7f 08                	jg     800cd2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccd:	5b                   	pop    %ebx
  800cce:	5e                   	pop    %esi
  800ccf:	5f                   	pop    %edi
  800cd0:	5d                   	pop    %ebp
  800cd1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd2:	83 ec 0c             	sub    $0xc,%esp
  800cd5:	50                   	push   %eax
  800cd6:	6a 03                	push   $0x3
  800cd8:	68 9f 27 80 00       	push   $0x80279f
  800cdd:	6a 23                	push   $0x23
  800cdf:	68 bc 27 80 00       	push   $0x8027bc
  800ce4:	e8 4b f5 ff ff       	call   800234 <_panic>

00800ce9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cef:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf4:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf9:	89 d1                	mov    %edx,%ecx
  800cfb:	89 d3                	mov    %edx,%ebx
  800cfd:	89 d7                	mov    %edx,%edi
  800cff:	89 d6                	mov    %edx,%esi
  800d01:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <sys_yield>:

void
sys_yield(void)
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d13:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d18:	89 d1                	mov    %edx,%ecx
  800d1a:	89 d3                	mov    %edx,%ebx
  800d1c:	89 d7                	mov    %edx,%edi
  800d1e:	89 d6                	mov    %edx,%esi
  800d20:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	be 00 00 00 00       	mov    $0x0,%esi
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d43:	89 f7                	mov    %esi,%edi
  800d45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	7f 08                	jg     800d53 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	50                   	push   %eax
  800d57:	6a 04                	push   $0x4
  800d59:	68 9f 27 80 00       	push   $0x80279f
  800d5e:	6a 23                	push   $0x23
  800d60:	68 bc 27 80 00       	push   $0x8027bc
  800d65:	e8 ca f4 ff ff       	call   800234 <_panic>

00800d6a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d73:	8b 55 08             	mov    0x8(%ebp),%edx
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d81:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d84:	8b 75 18             	mov    0x18(%ebp),%esi
  800d87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	7f 08                	jg     800d95 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	5d                   	pop    %ebp
  800d94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d95:	83 ec 0c             	sub    $0xc,%esp
  800d98:	50                   	push   %eax
  800d99:	6a 05                	push   $0x5
  800d9b:	68 9f 27 80 00       	push   $0x80279f
  800da0:	6a 23                	push   $0x23
  800da2:	68 bc 27 80 00       	push   $0x8027bc
  800da7:	e8 88 f4 ff ff       	call   800234 <_panic>

00800dac <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc5:	89 df                	mov    %ebx,%edi
  800dc7:	89 de                	mov    %ebx,%esi
  800dc9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	7f 08                	jg     800dd7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd7:	83 ec 0c             	sub    $0xc,%esp
  800dda:	50                   	push   %eax
  800ddb:	6a 06                	push   $0x6
  800ddd:	68 9f 27 80 00       	push   $0x80279f
  800de2:	6a 23                	push   $0x23
  800de4:	68 bc 27 80 00       	push   $0x8027bc
  800de9:	e8 46 f4 ff ff       	call   800234 <_panic>

00800dee <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	57                   	push   %edi
  800df2:	56                   	push   %esi
  800df3:	53                   	push   %ebx
  800df4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e02:	b8 08 00 00 00       	mov    $0x8,%eax
  800e07:	89 df                	mov    %ebx,%edi
  800e09:	89 de                	mov    %ebx,%esi
  800e0b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	7f 08                	jg     800e19 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e19:	83 ec 0c             	sub    $0xc,%esp
  800e1c:	50                   	push   %eax
  800e1d:	6a 08                	push   $0x8
  800e1f:	68 9f 27 80 00       	push   $0x80279f
  800e24:	6a 23                	push   $0x23
  800e26:	68 bc 27 80 00       	push   $0x8027bc
  800e2b:	e8 04 f4 ff ff       	call   800234 <_panic>

00800e30 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	b8 09 00 00 00       	mov    $0x9,%eax
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7f 08                	jg     800e5b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	50                   	push   %eax
  800e5f:	6a 09                	push   $0x9
  800e61:	68 9f 27 80 00       	push   $0x80279f
  800e66:	6a 23                	push   $0x23
  800e68:	68 bc 27 80 00       	push   $0x8027bc
  800e6d:	e8 c2 f3 ff ff       	call   800234 <_panic>

00800e72 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e72:	55                   	push   %ebp
  800e73:	89 e5                	mov    %esp,%ebp
  800e75:	57                   	push   %edi
  800e76:	56                   	push   %esi
  800e77:	53                   	push   %ebx
  800e78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e7b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e8b:	89 df                	mov    %ebx,%edi
  800e8d:	89 de                	mov    %ebx,%esi
  800e8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e91:	85 c0                	test   %eax,%eax
  800e93:	7f 08                	jg     800e9d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	50                   	push   %eax
  800ea1:	6a 0a                	push   $0xa
  800ea3:	68 9f 27 80 00       	push   $0x80279f
  800ea8:	6a 23                	push   $0x23
  800eaa:	68 bc 27 80 00       	push   $0x8027bc
  800eaf:	e8 80 f3 ff ff       	call   800234 <_panic>

00800eb4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec5:	be 00 00 00 00       	mov    $0x0,%esi
  800eca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecd:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    

00800ed7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eed:	89 cb                	mov    %ecx,%ebx
  800eef:	89 cf                	mov    %ecx,%edi
  800ef1:	89 ce                	mov    %ecx,%esi
  800ef3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	7f 08                	jg     800f01 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efc:	5b                   	pop    %ebx
  800efd:	5e                   	pop    %esi
  800efe:	5f                   	pop    %edi
  800eff:	5d                   	pop    %ebp
  800f00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f01:	83 ec 0c             	sub    $0xc,%esp
  800f04:	50                   	push   %eax
  800f05:	6a 0d                	push   $0xd
  800f07:	68 9f 27 80 00       	push   $0x80279f
  800f0c:	6a 23                	push   $0x23
  800f0e:	68 bc 27 80 00       	push   $0x8027bc
  800f13:	e8 1c f3 ff ff       	call   800234 <_panic>

00800f18 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	57                   	push   %edi
  800f1c:	56                   	push   %esi
  800f1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800f23:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f28:	89 d1                	mov    %edx,%ecx
  800f2a:	89 d3                	mov    %edx,%ebx
  800f2c:	89 d7                	mov    %edx,%edi
  800f2e:	89 d6                	mov    %edx,%esi
  800f30:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	05 00 00 00 30       	add    $0x30000000,%eax
  800f42:	c1 e8 0c             	shr    $0xc,%eax
}
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f57:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f5c:	5d                   	pop    %ebp
  800f5d:	c3                   	ret    

00800f5e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f64:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	c1 ea 16             	shr    $0x16,%edx
  800f6e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f75:	f6 c2 01             	test   $0x1,%dl
  800f78:	74 2a                	je     800fa4 <fd_alloc+0x46>
  800f7a:	89 c2                	mov    %eax,%edx
  800f7c:	c1 ea 0c             	shr    $0xc,%edx
  800f7f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f86:	f6 c2 01             	test   $0x1,%dl
  800f89:	74 19                	je     800fa4 <fd_alloc+0x46>
  800f8b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f90:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f95:	75 d2                	jne    800f69 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f97:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f9d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fa2:	eb 07                	jmp    800fab <fd_alloc+0x4d>
			*fd_store = fd;
  800fa4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fb3:	83 f8 1f             	cmp    $0x1f,%eax
  800fb6:	77 36                	ja     800fee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb8:	c1 e0 0c             	shl    $0xc,%eax
  800fbb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fc0:	89 c2                	mov    %eax,%edx
  800fc2:	c1 ea 16             	shr    $0x16,%edx
  800fc5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fcc:	f6 c2 01             	test   $0x1,%dl
  800fcf:	74 24                	je     800ff5 <fd_lookup+0x48>
  800fd1:	89 c2                	mov    %eax,%edx
  800fd3:	c1 ea 0c             	shr    $0xc,%edx
  800fd6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fdd:	f6 c2 01             	test   $0x1,%dl
  800fe0:	74 1a                	je     800ffc <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe5:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	5d                   	pop    %ebp
  800fed:	c3                   	ret    
		return -E_INVAL;
  800fee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff3:	eb f7                	jmp    800fec <fd_lookup+0x3f>
		return -E_INVAL;
  800ff5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ffa:	eb f0                	jmp    800fec <fd_lookup+0x3f>
  800ffc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801001:	eb e9                	jmp    800fec <fd_lookup+0x3f>

00801003 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100c:	ba 4c 28 80 00       	mov    $0x80284c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801011:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801016:	39 08                	cmp    %ecx,(%eax)
  801018:	74 33                	je     80104d <dev_lookup+0x4a>
  80101a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80101d:	8b 02                	mov    (%edx),%eax
  80101f:	85 c0                	test   %eax,%eax
  801021:	75 f3                	jne    801016 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801023:	a1 08 40 80 00       	mov    0x804008,%eax
  801028:	8b 40 48             	mov    0x48(%eax),%eax
  80102b:	83 ec 04             	sub    $0x4,%esp
  80102e:	51                   	push   %ecx
  80102f:	50                   	push   %eax
  801030:	68 cc 27 80 00       	push   $0x8027cc
  801035:	e8 d5 f2 ff ff       	call   80030f <cprintf>
	*dev = 0;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    
			*dev = devtab[i];
  80104d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801050:	89 01                	mov    %eax,(%ecx)
			return 0;
  801052:	b8 00 00 00 00       	mov    $0x0,%eax
  801057:	eb f2                	jmp    80104b <dev_lookup+0x48>

00801059 <fd_close>:
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	57                   	push   %edi
  80105d:	56                   	push   %esi
  80105e:	53                   	push   %ebx
  80105f:	83 ec 1c             	sub    $0x1c,%esp
  801062:	8b 75 08             	mov    0x8(%ebp),%esi
  801065:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801068:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80106b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801072:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801075:	50                   	push   %eax
  801076:	e8 32 ff ff ff       	call   800fad <fd_lookup>
  80107b:	89 c3                	mov    %eax,%ebx
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	78 05                	js     801089 <fd_close+0x30>
	    || fd != fd2)
  801084:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801087:	74 16                	je     80109f <fd_close+0x46>
		return (must_exist ? r : 0);
  801089:	89 f8                	mov    %edi,%eax
  80108b:	84 c0                	test   %al,%al
  80108d:	b8 00 00 00 00       	mov    $0x0,%eax
  801092:	0f 44 d8             	cmove  %eax,%ebx
}
  801095:	89 d8                	mov    %ebx,%eax
  801097:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80109a:	5b                   	pop    %ebx
  80109b:	5e                   	pop    %esi
  80109c:	5f                   	pop    %edi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010a5:	50                   	push   %eax
  8010a6:	ff 36                	pushl  (%esi)
  8010a8:	e8 56 ff ff ff       	call   801003 <dev_lookup>
  8010ad:	89 c3                	mov    %eax,%ebx
  8010af:	83 c4 10             	add    $0x10,%esp
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	78 15                	js     8010cb <fd_close+0x72>
		if (dev->dev_close)
  8010b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010b9:	8b 40 10             	mov    0x10(%eax),%eax
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	74 1b                	je     8010db <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	56                   	push   %esi
  8010c4:	ff d0                	call   *%eax
  8010c6:	89 c3                	mov    %eax,%ebx
  8010c8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8010cb:	83 ec 08             	sub    $0x8,%esp
  8010ce:	56                   	push   %esi
  8010cf:	6a 00                	push   $0x0
  8010d1:	e8 d6 fc ff ff       	call   800dac <sys_page_unmap>
	return r;
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	eb ba                	jmp    801095 <fd_close+0x3c>
			r = 0;
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	eb e9                	jmp    8010cb <fd_close+0x72>

008010e2 <close>:

int
close(int fdnum)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010eb:	50                   	push   %eax
  8010ec:	ff 75 08             	pushl  0x8(%ebp)
  8010ef:	e8 b9 fe ff ff       	call   800fad <fd_lookup>
  8010f4:	83 c4 08             	add    $0x8,%esp
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	78 10                	js     80110b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	6a 01                	push   $0x1
  801100:	ff 75 f4             	pushl  -0xc(%ebp)
  801103:	e8 51 ff ff ff       	call   801059 <fd_close>
  801108:	83 c4 10             	add    $0x10,%esp
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <close_all>:

void
close_all(void)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	53                   	push   %ebx
  801111:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801114:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	53                   	push   %ebx
  80111d:	e8 c0 ff ff ff       	call   8010e2 <close>
	for (i = 0; i < MAXFD; i++)
  801122:	83 c3 01             	add    $0x1,%ebx
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	83 fb 20             	cmp    $0x20,%ebx
  80112b:	75 ec                	jne    801119 <close_all+0xc>
}
  80112d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801130:	c9                   	leave  
  801131:	c3                   	ret    

00801132 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	57                   	push   %edi
  801136:	56                   	push   %esi
  801137:	53                   	push   %ebx
  801138:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80113b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	ff 75 08             	pushl  0x8(%ebp)
  801142:	e8 66 fe ff ff       	call   800fad <fd_lookup>
  801147:	89 c3                	mov    %eax,%ebx
  801149:	83 c4 08             	add    $0x8,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	0f 88 81 00 00 00    	js     8011d5 <dup+0xa3>
		return r;
	close(newfdnum);
  801154:	83 ec 0c             	sub    $0xc,%esp
  801157:	ff 75 0c             	pushl  0xc(%ebp)
  80115a:	e8 83 ff ff ff       	call   8010e2 <close>

	newfd = INDEX2FD(newfdnum);
  80115f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801162:	c1 e6 0c             	shl    $0xc,%esi
  801165:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80116b:	83 c4 04             	add    $0x4,%esp
  80116e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801171:	e8 d1 fd ff ff       	call   800f47 <fd2data>
  801176:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801178:	89 34 24             	mov    %esi,(%esp)
  80117b:	e8 c7 fd ff ff       	call   800f47 <fd2data>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801185:	89 d8                	mov    %ebx,%eax
  801187:	c1 e8 16             	shr    $0x16,%eax
  80118a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801191:	a8 01                	test   $0x1,%al
  801193:	74 11                	je     8011a6 <dup+0x74>
  801195:	89 d8                	mov    %ebx,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
  80119a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011a1:	f6 c2 01             	test   $0x1,%dl
  8011a4:	75 39                	jne    8011df <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011a9:	89 d0                	mov    %edx,%eax
  8011ab:	c1 e8 0c             	shr    $0xc,%eax
  8011ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011b5:	83 ec 0c             	sub    $0xc,%esp
  8011b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bd:	50                   	push   %eax
  8011be:	56                   	push   %esi
  8011bf:	6a 00                	push   $0x0
  8011c1:	52                   	push   %edx
  8011c2:	6a 00                	push   $0x0
  8011c4:	e8 a1 fb ff ff       	call   800d6a <sys_page_map>
  8011c9:	89 c3                	mov    %eax,%ebx
  8011cb:	83 c4 20             	add    $0x20,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 31                	js     801203 <dup+0xd1>
		goto err;

	return newfdnum;
  8011d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8011d5:	89 d8                	mov    %ebx,%eax
  8011d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011da:	5b                   	pop    %ebx
  8011db:	5e                   	pop    %esi
  8011dc:	5f                   	pop    %edi
  8011dd:	5d                   	pop    %ebp
  8011de:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011df:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ee:	50                   	push   %eax
  8011ef:	57                   	push   %edi
  8011f0:	6a 00                	push   $0x0
  8011f2:	53                   	push   %ebx
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 70 fb ff ff       	call   800d6a <sys_page_map>
  8011fa:	89 c3                	mov    %eax,%ebx
  8011fc:	83 c4 20             	add    $0x20,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	79 a3                	jns    8011a6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	56                   	push   %esi
  801207:	6a 00                	push   $0x0
  801209:	e8 9e fb ff ff       	call   800dac <sys_page_unmap>
	sys_page_unmap(0, nva);
  80120e:	83 c4 08             	add    $0x8,%esp
  801211:	57                   	push   %edi
  801212:	6a 00                	push   $0x0
  801214:	e8 93 fb ff ff       	call   800dac <sys_page_unmap>
	return r;
  801219:	83 c4 10             	add    $0x10,%esp
  80121c:	eb b7                	jmp    8011d5 <dup+0xa3>

0080121e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	53                   	push   %ebx
  801222:	83 ec 14             	sub    $0x14,%esp
  801225:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801228:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122b:	50                   	push   %eax
  80122c:	53                   	push   %ebx
  80122d:	e8 7b fd ff ff       	call   800fad <fd_lookup>
  801232:	83 c4 08             	add    $0x8,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 3f                	js     801278 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801239:	83 ec 08             	sub    $0x8,%esp
  80123c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80123f:	50                   	push   %eax
  801240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801243:	ff 30                	pushl  (%eax)
  801245:	e8 b9 fd ff ff       	call   801003 <dev_lookup>
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 27                	js     801278 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801254:	8b 42 08             	mov    0x8(%edx),%eax
  801257:	83 e0 03             	and    $0x3,%eax
  80125a:	83 f8 01             	cmp    $0x1,%eax
  80125d:	74 1e                	je     80127d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801262:	8b 40 08             	mov    0x8(%eax),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	74 35                	je     80129e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	ff 75 10             	pushl  0x10(%ebp)
  80126f:	ff 75 0c             	pushl  0xc(%ebp)
  801272:	52                   	push   %edx
  801273:	ff d0                	call   *%eax
  801275:	83 c4 10             	add    $0x10,%esp
}
  801278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80127d:	a1 08 40 80 00       	mov    0x804008,%eax
  801282:	8b 40 48             	mov    0x48(%eax),%eax
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	53                   	push   %ebx
  801289:	50                   	push   %eax
  80128a:	68 10 28 80 00       	push   $0x802810
  80128f:	e8 7b f0 ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129c:	eb da                	jmp    801278 <read+0x5a>
		return -E_NOT_SUPP;
  80129e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a3:	eb d3                	jmp    801278 <read+0x5a>

008012a5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	57                   	push   %edi
  8012a9:	56                   	push   %esi
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 0c             	sub    $0xc,%esp
  8012ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b9:	39 f3                	cmp    %esi,%ebx
  8012bb:	73 25                	jae    8012e2 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	89 f0                	mov    %esi,%eax
  8012c2:	29 d8                	sub    %ebx,%eax
  8012c4:	50                   	push   %eax
  8012c5:	89 d8                	mov    %ebx,%eax
  8012c7:	03 45 0c             	add    0xc(%ebp),%eax
  8012ca:	50                   	push   %eax
  8012cb:	57                   	push   %edi
  8012cc:	e8 4d ff ff ff       	call   80121e <read>
		if (m < 0)
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	85 c0                	test   %eax,%eax
  8012d6:	78 08                	js     8012e0 <readn+0x3b>
			return m;
		if (m == 0)
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	74 06                	je     8012e2 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8012dc:	01 c3                	add    %eax,%ebx
  8012de:	eb d9                	jmp    8012b9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e0:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8012e2:	89 d8                	mov    %ebx,%eax
  8012e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	53                   	push   %ebx
  8012f0:	83 ec 14             	sub    $0x14,%esp
  8012f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f9:	50                   	push   %eax
  8012fa:	53                   	push   %ebx
  8012fb:	e8 ad fc ff ff       	call   800fad <fd_lookup>
  801300:	83 c4 08             	add    $0x8,%esp
  801303:	85 c0                	test   %eax,%eax
  801305:	78 3a                	js     801341 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130d:	50                   	push   %eax
  80130e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801311:	ff 30                	pushl  (%eax)
  801313:	e8 eb fc ff ff       	call   801003 <dev_lookup>
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	85 c0                	test   %eax,%eax
  80131d:	78 22                	js     801341 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801322:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801326:	74 1e                	je     801346 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132b:	8b 52 0c             	mov    0xc(%edx),%edx
  80132e:	85 d2                	test   %edx,%edx
  801330:	74 35                	je     801367 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801332:	83 ec 04             	sub    $0x4,%esp
  801335:	ff 75 10             	pushl  0x10(%ebp)
  801338:	ff 75 0c             	pushl  0xc(%ebp)
  80133b:	50                   	push   %eax
  80133c:	ff d2                	call   *%edx
  80133e:	83 c4 10             	add    $0x10,%esp
}
  801341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801344:	c9                   	leave  
  801345:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801346:	a1 08 40 80 00       	mov    0x804008,%eax
  80134b:	8b 40 48             	mov    0x48(%eax),%eax
  80134e:	83 ec 04             	sub    $0x4,%esp
  801351:	53                   	push   %ebx
  801352:	50                   	push   %eax
  801353:	68 2c 28 80 00       	push   $0x80282c
  801358:	e8 b2 ef ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801365:	eb da                	jmp    801341 <write+0x55>
		return -E_NOT_SUPP;
  801367:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136c:	eb d3                	jmp    801341 <write+0x55>

0080136e <seek>:

int
seek(int fdnum, off_t offset)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801374:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801377:	50                   	push   %eax
  801378:	ff 75 08             	pushl  0x8(%ebp)
  80137b:	e8 2d fc ff ff       	call   800fad <fd_lookup>
  801380:	83 c4 08             	add    $0x8,%esp
  801383:	85 c0                	test   %eax,%eax
  801385:	78 0e                	js     801395 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	53                   	push   %ebx
  80139b:	83 ec 14             	sub    $0x14,%esp
  80139e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	53                   	push   %ebx
  8013a6:	e8 02 fc ff ff       	call   800fad <fd_lookup>
  8013ab:	83 c4 08             	add    $0x8,%esp
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 37                	js     8013e9 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b8:	50                   	push   %eax
  8013b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bc:	ff 30                	pushl  (%eax)
  8013be:	e8 40 fc ff ff       	call   801003 <dev_lookup>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 1f                	js     8013e9 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d1:	74 1b                	je     8013ee <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8013d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d6:	8b 52 18             	mov    0x18(%edx),%edx
  8013d9:	85 d2                	test   %edx,%edx
  8013db:	74 32                	je     80140f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	ff 75 0c             	pushl  0xc(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	ff d2                	call   *%edx
  8013e6:	83 c4 10             	add    $0x10,%esp
}
  8013e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    
			thisenv->env_id, fdnum);
  8013ee:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013f3:	8b 40 48             	mov    0x48(%eax),%eax
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	53                   	push   %ebx
  8013fa:	50                   	push   %eax
  8013fb:	68 ec 27 80 00       	push   $0x8027ec
  801400:	e8 0a ef ff ff       	call   80030f <cprintf>
		return -E_INVAL;
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140d:	eb da                	jmp    8013e9 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80140f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801414:	eb d3                	jmp    8013e9 <ftruncate+0x52>

00801416 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 14             	sub    $0x14,%esp
  80141d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801423:	50                   	push   %eax
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 81 fb ff ff       	call   800fad <fd_lookup>
  80142c:	83 c4 08             	add    $0x8,%esp
  80142f:	85 c0                	test   %eax,%eax
  801431:	78 4b                	js     80147e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801433:	83 ec 08             	sub    $0x8,%esp
  801436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801439:	50                   	push   %eax
  80143a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143d:	ff 30                	pushl  (%eax)
  80143f:	e8 bf fb ff ff       	call   801003 <dev_lookup>
  801444:	83 c4 10             	add    $0x10,%esp
  801447:	85 c0                	test   %eax,%eax
  801449:	78 33                	js     80147e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80144b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801452:	74 2f                	je     801483 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801454:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801457:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80145e:	00 00 00 
	stat->st_isdir = 0;
  801461:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801468:	00 00 00 
	stat->st_dev = dev;
  80146b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	53                   	push   %ebx
  801475:	ff 75 f0             	pushl  -0x10(%ebp)
  801478:	ff 50 14             	call   *0x14(%eax)
  80147b:	83 c4 10             	add    $0x10,%esp
}
  80147e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801481:	c9                   	leave  
  801482:	c3                   	ret    
		return -E_NOT_SUPP;
  801483:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801488:	eb f4                	jmp    80147e <fstat+0x68>

0080148a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	56                   	push   %esi
  80148e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80148f:	83 ec 08             	sub    $0x8,%esp
  801492:	6a 00                	push   $0x0
  801494:	ff 75 08             	pushl  0x8(%ebp)
  801497:	e8 e7 01 00 00       	call   801683 <open>
  80149c:	89 c3                	mov    %eax,%ebx
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 1b                	js     8014c0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014a5:	83 ec 08             	sub    $0x8,%esp
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	50                   	push   %eax
  8014ac:	e8 65 ff ff ff       	call   801416 <fstat>
  8014b1:	89 c6                	mov    %eax,%esi
	close(fd);
  8014b3:	89 1c 24             	mov    %ebx,(%esp)
  8014b6:	e8 27 fc ff ff       	call   8010e2 <close>
	return r;
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 f3                	mov    %esi,%ebx
}
  8014c0:	89 d8                	mov    %ebx,%eax
  8014c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    

008014c9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	56                   	push   %esi
  8014cd:	53                   	push   %ebx
  8014ce:	89 c6                	mov    %eax,%esi
  8014d0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014d2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014d9:	74 27                	je     801502 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014db:	6a 07                	push   $0x7
  8014dd:	68 00 50 80 00       	push   $0x805000
  8014e2:	56                   	push   %esi
  8014e3:	ff 35 00 40 80 00    	pushl  0x804000
  8014e9:	e8 d0 0b 00 00       	call   8020be <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8014ee:	83 c4 0c             	add    $0xc,%esp
  8014f1:	6a 00                	push   $0x0
  8014f3:	53                   	push   %ebx
  8014f4:	6a 00                	push   $0x0
  8014f6:	e8 5c 0b 00 00       	call   802057 <ipc_recv>
}
  8014fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fe:	5b                   	pop    %ebx
  8014ff:	5e                   	pop    %esi
  801500:	5d                   	pop    %ebp
  801501:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	6a 01                	push   $0x1
  801507:	e8 06 0c 00 00       	call   802112 <ipc_find_env>
  80150c:	a3 00 40 80 00       	mov    %eax,0x804000
  801511:	83 c4 10             	add    $0x10,%esp
  801514:	eb c5                	jmp    8014db <fsipc+0x12>

00801516 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	8b 40 0c             	mov    0xc(%eax),%eax
  801522:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80152f:	ba 00 00 00 00       	mov    $0x0,%edx
  801534:	b8 02 00 00 00       	mov    $0x2,%eax
  801539:	e8 8b ff ff ff       	call   8014c9 <fsipc>
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <devfile_flush>:
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801546:	8b 45 08             	mov    0x8(%ebp),%eax
  801549:	8b 40 0c             	mov    0xc(%eax),%eax
  80154c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801551:	ba 00 00 00 00       	mov    $0x0,%edx
  801556:	b8 06 00 00 00       	mov    $0x6,%eax
  80155b:	e8 69 ff ff ff       	call   8014c9 <fsipc>
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <devfile_stat>:
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	53                   	push   %ebx
  801566:	83 ec 04             	sub    $0x4,%esp
  801569:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	8b 40 0c             	mov    0xc(%eax),%eax
  801572:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801577:	ba 00 00 00 00       	mov    $0x0,%edx
  80157c:	b8 05 00 00 00       	mov    $0x5,%eax
  801581:	e8 43 ff ff ff       	call   8014c9 <fsipc>
  801586:	85 c0                	test   %eax,%eax
  801588:	78 2c                	js     8015b6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80158a:	83 ec 08             	sub    $0x8,%esp
  80158d:	68 00 50 80 00       	push   $0x805000
  801592:	53                   	push   %ebx
  801593:	e8 96 f3 ff ff       	call   80092e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801598:	a1 80 50 80 00       	mov    0x805080,%eax
  80159d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015a3:	a1 84 50 80 00       	mov    0x805084,%eax
  8015a8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <devfile_write>:
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8015c9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8015ce:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d4:	8b 52 0c             	mov    0xc(%edx),%edx
  8015d7:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8015dd:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8015e2:	50                   	push   %eax
  8015e3:	ff 75 0c             	pushl  0xc(%ebp)
  8015e6:	68 08 50 80 00       	push   $0x805008
  8015eb:	e8 cc f4 ff ff       	call   800abc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8015f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f5:	b8 04 00 00 00       	mov    $0x4,%eax
  8015fa:	e8 ca fe ff ff       	call   8014c9 <fsipc>
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <devfile_read>:
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	56                   	push   %esi
  801605:	53                   	push   %ebx
  801606:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801609:	8b 45 08             	mov    0x8(%ebp),%eax
  80160c:	8b 40 0c             	mov    0xc(%eax),%eax
  80160f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801614:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	b8 03 00 00 00       	mov    $0x3,%eax
  801624:	e8 a0 fe ff ff       	call   8014c9 <fsipc>
  801629:	89 c3                	mov    %eax,%ebx
  80162b:	85 c0                	test   %eax,%eax
  80162d:	78 1f                	js     80164e <devfile_read+0x4d>
	assert(r <= n);
  80162f:	39 f0                	cmp    %esi,%eax
  801631:	77 24                	ja     801657 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801633:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801638:	7f 33                	jg     80166d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	50                   	push   %eax
  80163e:	68 00 50 80 00       	push   $0x805000
  801643:	ff 75 0c             	pushl  0xc(%ebp)
  801646:	e8 71 f4 ff ff       	call   800abc <memmove>
	return r;
  80164b:	83 c4 10             	add    $0x10,%esp
}
  80164e:	89 d8                	mov    %ebx,%eax
  801650:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    
	assert(r <= n);
  801657:	68 60 28 80 00       	push   $0x802860
  80165c:	68 67 28 80 00       	push   $0x802867
  801661:	6a 7b                	push   $0x7b
  801663:	68 7c 28 80 00       	push   $0x80287c
  801668:	e8 c7 eb ff ff       	call   800234 <_panic>
	assert(r <= PGSIZE);
  80166d:	68 87 28 80 00       	push   $0x802887
  801672:	68 67 28 80 00       	push   $0x802867
  801677:	6a 7c                	push   $0x7c
  801679:	68 7c 28 80 00       	push   $0x80287c
  80167e:	e8 b1 eb ff ff       	call   800234 <_panic>

00801683 <open>:
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	56                   	push   %esi
  801687:	53                   	push   %ebx
  801688:	83 ec 1c             	sub    $0x1c,%esp
  80168b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80168e:	56                   	push   %esi
  80168f:	e8 63 f2 ff ff       	call   8008f7 <strlen>
  801694:	83 c4 10             	add    $0x10,%esp
  801697:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80169c:	7f 6c                	jg     80170a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80169e:	83 ec 0c             	sub    $0xc,%esp
  8016a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a4:	50                   	push   %eax
  8016a5:	e8 b4 f8 ff ff       	call   800f5e <fd_alloc>
  8016aa:	89 c3                	mov    %eax,%ebx
  8016ac:	83 c4 10             	add    $0x10,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 3c                	js     8016ef <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016b3:	83 ec 08             	sub    $0x8,%esp
  8016b6:	56                   	push   %esi
  8016b7:	68 00 50 80 00       	push   $0x805000
  8016bc:	e8 6d f2 ff ff       	call   80092e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8016d1:	e8 f3 fd ff ff       	call   8014c9 <fsipc>
  8016d6:	89 c3                	mov    %eax,%ebx
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	78 19                	js     8016f8 <open+0x75>
	return fd2num(fd);
  8016df:	83 ec 0c             	sub    $0xc,%esp
  8016e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e5:	e8 4d f8 ff ff       	call   800f37 <fd2num>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	83 c4 10             	add    $0x10,%esp
}
  8016ef:	89 d8                	mov    %ebx,%eax
  8016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    
		fd_close(fd, 0);
  8016f8:	83 ec 08             	sub    $0x8,%esp
  8016fb:	6a 00                	push   $0x0
  8016fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801700:	e8 54 f9 ff ff       	call   801059 <fd_close>
		return r;
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	eb e5                	jmp    8016ef <open+0x6c>
		return -E_BAD_PATH;
  80170a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80170f:	eb de                	jmp    8016ef <open+0x6c>

00801711 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801717:	ba 00 00 00 00       	mov    $0x0,%edx
  80171c:	b8 08 00 00 00       	mov    $0x8,%eax
  801721:	e8 a3 fd ff ff       	call   8014c9 <fsipc>
}
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80172e:	68 93 28 80 00       	push   $0x802893
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	e8 f3 f1 ff ff       	call   80092e <strcpy>
	return 0;
}
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <devsock_close>:
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	53                   	push   %ebx
  801746:	83 ec 10             	sub    $0x10,%esp
  801749:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80174c:	53                   	push   %ebx
  80174d:	e8 f9 09 00 00       	call   80214b <pageref>
  801752:	83 c4 10             	add    $0x10,%esp
		return 0;
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80175a:	83 f8 01             	cmp    $0x1,%eax
  80175d:	74 07                	je     801766 <devsock_close+0x24>
}
  80175f:	89 d0                	mov    %edx,%eax
  801761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801764:	c9                   	leave  
  801765:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801766:	83 ec 0c             	sub    $0xc,%esp
  801769:	ff 73 0c             	pushl  0xc(%ebx)
  80176c:	e8 b7 02 00 00       	call   801a28 <nsipc_close>
  801771:	89 c2                	mov    %eax,%edx
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	eb e7                	jmp    80175f <devsock_close+0x1d>

00801778 <devsock_write>:
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80177e:	6a 00                	push   $0x0
  801780:	ff 75 10             	pushl  0x10(%ebp)
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	ff 70 0c             	pushl  0xc(%eax)
  80178c:	e8 74 03 00 00       	call   801b05 <nsipc_send>
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <devsock_read>:
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801799:	6a 00                	push   $0x0
  80179b:	ff 75 10             	pushl  0x10(%ebp)
  80179e:	ff 75 0c             	pushl  0xc(%ebp)
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	ff 70 0c             	pushl  0xc(%eax)
  8017a7:	e8 ed 02 00 00       	call   801a99 <nsipc_recv>
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <fd2sockid>:
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8017b4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8017b7:	52                   	push   %edx
  8017b8:	50                   	push   %eax
  8017b9:	e8 ef f7 ff ff       	call   800fad <fd_lookup>
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	78 10                	js     8017d5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8017ce:	39 08                	cmp    %ecx,(%eax)
  8017d0:	75 05                	jne    8017d7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    
		return -E_NOT_SUPP;
  8017d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017dc:	eb f7                	jmp    8017d5 <fd2sockid+0x27>

008017de <alloc_sockfd>:
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 1c             	sub    $0x1c,%esp
  8017e6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8017e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	e8 6d f7 ff ff       	call   800f5e <fd_alloc>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 43                	js     80183d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8017fa:	83 ec 04             	sub    $0x4,%esp
  8017fd:	68 07 04 00 00       	push   $0x407
  801802:	ff 75 f4             	pushl  -0xc(%ebp)
  801805:	6a 00                	push   $0x0
  801807:	e8 1b f5 ff ff       	call   800d27 <sys_page_alloc>
  80180c:	89 c3                	mov    %eax,%ebx
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	85 c0                	test   %eax,%eax
  801813:	78 28                	js     80183d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801818:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80181e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801823:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80182a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	50                   	push   %eax
  801831:	e8 01 f7 ff ff       	call   800f37 <fd2num>
  801836:	89 c3                	mov    %eax,%ebx
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	eb 0c                	jmp    801849 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	56                   	push   %esi
  801841:	e8 e2 01 00 00       	call   801a28 <nsipc_close>
		return r;
  801846:	83 c4 10             	add    $0x10,%esp
}
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184e:	5b                   	pop    %ebx
  80184f:	5e                   	pop    %esi
  801850:	5d                   	pop    %ebp
  801851:	c3                   	ret    

00801852 <accept>:
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	e8 4e ff ff ff       	call   8017ae <fd2sockid>
  801860:	85 c0                	test   %eax,%eax
  801862:	78 1b                	js     80187f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	ff 75 10             	pushl  0x10(%ebp)
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	50                   	push   %eax
  80186e:	e8 0e 01 00 00       	call   801981 <nsipc_accept>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	85 c0                	test   %eax,%eax
  801878:	78 05                	js     80187f <accept+0x2d>
	return alloc_sockfd(r);
  80187a:	e8 5f ff ff ff       	call   8017de <alloc_sockfd>
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <bind>:
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	e8 1f ff ff ff       	call   8017ae <fd2sockid>
  80188f:	85 c0                	test   %eax,%eax
  801891:	78 12                	js     8018a5 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	ff 75 10             	pushl  0x10(%ebp)
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	50                   	push   %eax
  80189d:	e8 2f 01 00 00       	call   8019d1 <nsipc_bind>
  8018a2:	83 c4 10             	add    $0x10,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <shutdown>:
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	e8 f9 fe ff ff       	call   8017ae <fd2sockid>
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	78 0f                	js     8018c8 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8018b9:	83 ec 08             	sub    $0x8,%esp
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	e8 41 01 00 00       	call   801a06 <nsipc_shutdown>
  8018c5:	83 c4 10             	add    $0x10,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <connect>:
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
  8018cd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	e8 d6 fe ff ff       	call   8017ae <fd2sockid>
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 12                	js     8018ee <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	ff 75 10             	pushl  0x10(%ebp)
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	50                   	push   %eax
  8018e6:	e8 57 01 00 00       	call   801a42 <nsipc_connect>
  8018eb:	83 c4 10             	add    $0x10,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <listen>:
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	e8 b0 fe ff ff       	call   8017ae <fd2sockid>
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 0f                	js     801911 <listen+0x21>
	return nsipc_listen(r, backlog);
  801902:	83 ec 08             	sub    $0x8,%esp
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	50                   	push   %eax
  801909:	e8 69 01 00 00       	call   801a77 <nsipc_listen>
  80190e:	83 c4 10             	add    $0x10,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <socket>:

int
socket(int domain, int type, int protocol)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801919:	ff 75 10             	pushl  0x10(%ebp)
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	ff 75 08             	pushl  0x8(%ebp)
  801922:	e8 3c 02 00 00       	call   801b63 <nsipc_socket>
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 05                	js     801933 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80192e:	e8 ab fe ff ff       	call   8017de <alloc_sockfd>
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	53                   	push   %ebx
  801939:	83 ec 04             	sub    $0x4,%esp
  80193c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80193e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801945:	74 26                	je     80196d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801947:	6a 07                	push   $0x7
  801949:	68 00 60 80 00       	push   $0x806000
  80194e:	53                   	push   %ebx
  80194f:	ff 35 04 40 80 00    	pushl  0x804004
  801955:	e8 64 07 00 00       	call   8020be <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80195a:	83 c4 0c             	add    $0xc,%esp
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	e8 ef 06 00 00       	call   802057 <ipc_recv>
}
  801968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	6a 02                	push   $0x2
  801972:	e8 9b 07 00 00       	call   802112 <ipc_find_env>
  801977:	a3 04 40 80 00       	mov    %eax,0x804004
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	eb c6                	jmp    801947 <nsipc+0x12>

00801981 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801991:	8b 06                	mov    (%esi),%eax
  801993:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801998:	b8 01 00 00 00       	mov    $0x1,%eax
  80199d:	e8 93 ff ff ff       	call   801935 <nsipc>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 20                	js     8019c8 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	ff 35 10 60 80 00    	pushl  0x806010
  8019b1:	68 00 60 80 00       	push   $0x806000
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	e8 fe f0 ff ff       	call   800abc <memmove>
		*addrlen = ret->ret_addrlen;
  8019be:	a1 10 60 80 00       	mov    0x806010,%eax
  8019c3:	89 06                	mov    %eax,(%esi)
  8019c5:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8019c8:	89 d8                	mov    %ebx,%eax
  8019ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5e                   	pop    %esi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	53                   	push   %ebx
  8019d5:	83 ec 08             	sub    $0x8,%esp
  8019d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019e3:	53                   	push   %ebx
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	68 04 60 80 00       	push   $0x806004
  8019ec:	e8 cb f0 ff ff       	call   800abc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8019f1:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8019f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019fc:	e8 34 ff ff ff       	call   801935 <nsipc>
}
  801a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a17:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801a1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801a21:	e8 0f ff ff ff       	call   801935 <nsipc>
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <nsipc_close>:

int
nsipc_close(int s)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801a36:	b8 04 00 00 00       	mov    $0x4,%eax
  801a3b:	e8 f5 fe ff ff       	call   801935 <nsipc>
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	53                   	push   %ebx
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801a54:	53                   	push   %ebx
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	68 04 60 80 00       	push   $0x806004
  801a5d:	e8 5a f0 ff ff       	call   800abc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801a62:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801a68:	b8 05 00 00 00       	mov    $0x5,%eax
  801a6d:	e8 c3 fe ff ff       	call   801935 <nsipc>
}
  801a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a88:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a8d:	b8 06 00 00 00       	mov    $0x6,%eax
  801a92:	e8 9e fe ff ff       	call   801935 <nsipc>
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	56                   	push   %esi
  801a9d:	53                   	push   %ebx
  801a9e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801aa9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ab7:	b8 07 00 00 00       	mov    $0x7,%eax
  801abc:	e8 74 fe ff ff       	call   801935 <nsipc>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	78 1f                	js     801ae6 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801ac7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801acc:	7f 21                	jg     801aef <nsipc_recv+0x56>
  801ace:	39 c6                	cmp    %eax,%esi
  801ad0:	7c 1d                	jl     801aef <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	50                   	push   %eax
  801ad6:	68 00 60 80 00       	push   $0x806000
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	e8 d9 ef ff ff       	call   800abc <memmove>
  801ae3:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ae6:	89 d8                	mov    %ebx,%eax
  801ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801aef:	68 9f 28 80 00       	push   $0x80289f
  801af4:	68 67 28 80 00       	push   $0x802867
  801af9:	6a 62                	push   $0x62
  801afb:	68 b4 28 80 00       	push   $0x8028b4
  801b00:	e8 2f e7 ff ff       	call   800234 <_panic>

00801b05 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	53                   	push   %ebx
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801b17:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b1d:	7f 2e                	jg     801b4d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	53                   	push   %ebx
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	68 0c 60 80 00       	push   $0x80600c
  801b2b:	e8 8c ef ff ff       	call   800abc <memmove>
	nsipcbuf.send.req_size = size;
  801b30:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801b36:	8b 45 14             	mov    0x14(%ebp),%eax
  801b39:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801b3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b43:	e8 ed fd ff ff       	call   801935 <nsipc>
}
  801b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    
	assert(size < 1600);
  801b4d:	68 c0 28 80 00       	push   $0x8028c0
  801b52:	68 67 28 80 00       	push   $0x802867
  801b57:	6a 6d                	push   $0x6d
  801b59:	68 b4 28 80 00       	push   $0x8028b4
  801b5e:	e8 d1 e6 ff ff       	call   800234 <_panic>

00801b63 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801b79:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b81:	b8 09 00 00 00       	mov    $0x9,%eax
  801b86:	e8 aa fd ff ff       	call   801935 <nsipc>
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	56                   	push   %esi
  801b91:	53                   	push   %ebx
  801b92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	ff 75 08             	pushl  0x8(%ebp)
  801b9b:	e8 a7 f3 ff ff       	call   800f47 <fd2data>
  801ba0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ba2:	83 c4 08             	add    $0x8,%esp
  801ba5:	68 cc 28 80 00       	push   $0x8028cc
  801baa:	53                   	push   %ebx
  801bab:	e8 7e ed ff ff       	call   80092e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801bb0:	8b 46 04             	mov    0x4(%esi),%eax
  801bb3:	2b 06                	sub    (%esi),%eax
  801bb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801bbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bc2:	00 00 00 
	stat->st_dev = &devpipe;
  801bc5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801bcc:	30 80 00 
	return 0;
}
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    

00801bdb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	53                   	push   %ebx
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801be5:	53                   	push   %ebx
  801be6:	6a 00                	push   $0x0
  801be8:	e8 bf f1 ff ff       	call   800dac <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801bed:	89 1c 24             	mov    %ebx,(%esp)
  801bf0:	e8 52 f3 ff ff       	call   800f47 <fd2data>
  801bf5:	83 c4 08             	add    $0x8,%esp
  801bf8:	50                   	push   %eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	e8 ac f1 ff ff       	call   800dac <sys_page_unmap>
}
  801c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <_pipeisclosed>:
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	57                   	push   %edi
  801c09:	56                   	push   %esi
  801c0a:	53                   	push   %ebx
  801c0b:	83 ec 1c             	sub    $0x1c,%esp
  801c0e:	89 c7                	mov    %eax,%edi
  801c10:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c12:	a1 08 40 80 00       	mov    0x804008,%eax
  801c17:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	57                   	push   %edi
  801c1e:	e8 28 05 00 00       	call   80214b <pageref>
  801c23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c26:	89 34 24             	mov    %esi,(%esp)
  801c29:	e8 1d 05 00 00       	call   80214b <pageref>
		nn = thisenv->env_runs;
  801c2e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801c34:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801c37:	83 c4 10             	add    $0x10,%esp
  801c3a:	39 cb                	cmp    %ecx,%ebx
  801c3c:	74 1b                	je     801c59 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801c3e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c41:	75 cf                	jne    801c12 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801c43:	8b 42 58             	mov    0x58(%edx),%eax
  801c46:	6a 01                	push   $0x1
  801c48:	50                   	push   %eax
  801c49:	53                   	push   %ebx
  801c4a:	68 d3 28 80 00       	push   $0x8028d3
  801c4f:	e8 bb e6 ff ff       	call   80030f <cprintf>
  801c54:	83 c4 10             	add    $0x10,%esp
  801c57:	eb b9                	jmp    801c12 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801c59:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c5c:	0f 94 c0             	sete   %al
  801c5f:	0f b6 c0             	movzbl %al,%eax
}
  801c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c65:	5b                   	pop    %ebx
  801c66:	5e                   	pop    %esi
  801c67:	5f                   	pop    %edi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <devpipe_write>:
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	57                   	push   %edi
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 28             	sub    $0x28,%esp
  801c73:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801c76:	56                   	push   %esi
  801c77:	e8 cb f2 ff ff       	call   800f47 <fd2data>
  801c7c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	bf 00 00 00 00       	mov    $0x0,%edi
  801c86:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c89:	74 4f                	je     801cda <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801c8e:	8b 0b                	mov    (%ebx),%ecx
  801c90:	8d 51 20             	lea    0x20(%ecx),%edx
  801c93:	39 d0                	cmp    %edx,%eax
  801c95:	72 14                	jb     801cab <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c97:	89 da                	mov    %ebx,%edx
  801c99:	89 f0                	mov    %esi,%eax
  801c9b:	e8 65 ff ff ff       	call   801c05 <_pipeisclosed>
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	75 3a                	jne    801cde <devpipe_write+0x74>
			sys_yield();
  801ca4:	e8 5f f0 ff ff       	call   800d08 <sys_yield>
  801ca9:	eb e0                	jmp    801c8b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801cab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cae:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801cb2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801cb5:	89 c2                	mov    %eax,%edx
  801cb7:	c1 fa 1f             	sar    $0x1f,%edx
  801cba:	89 d1                	mov    %edx,%ecx
  801cbc:	c1 e9 1b             	shr    $0x1b,%ecx
  801cbf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801cc2:	83 e2 1f             	and    $0x1f,%edx
  801cc5:	29 ca                	sub    %ecx,%edx
  801cc7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801ccb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ccf:	83 c0 01             	add    $0x1,%eax
  801cd2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801cd5:	83 c7 01             	add    $0x1,%edi
  801cd8:	eb ac                	jmp    801c86 <devpipe_write+0x1c>
	return i;
  801cda:	89 f8                	mov    %edi,%eax
  801cdc:	eb 05                	jmp    801ce3 <devpipe_write+0x79>
				return 0;
  801cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    

00801ceb <devpipe_read>:
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	57                   	push   %edi
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 18             	sub    $0x18,%esp
  801cf4:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801cf7:	57                   	push   %edi
  801cf8:	e8 4a f2 ff ff       	call   800f47 <fd2data>
  801cfd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	be 00 00 00 00       	mov    $0x0,%esi
  801d07:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d0a:	74 47                	je     801d53 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d0c:	8b 03                	mov    (%ebx),%eax
  801d0e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d11:	75 22                	jne    801d35 <devpipe_read+0x4a>
			if (i > 0)
  801d13:	85 f6                	test   %esi,%esi
  801d15:	75 14                	jne    801d2b <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d17:	89 da                	mov    %ebx,%edx
  801d19:	89 f8                	mov    %edi,%eax
  801d1b:	e8 e5 fe ff ff       	call   801c05 <_pipeisclosed>
  801d20:	85 c0                	test   %eax,%eax
  801d22:	75 33                	jne    801d57 <devpipe_read+0x6c>
			sys_yield();
  801d24:	e8 df ef ff ff       	call   800d08 <sys_yield>
  801d29:	eb e1                	jmp    801d0c <devpipe_read+0x21>
				return i;
  801d2b:	89 f0                	mov    %esi,%eax
}
  801d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5e                   	pop    %esi
  801d32:	5f                   	pop    %edi
  801d33:	5d                   	pop    %ebp
  801d34:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d35:	99                   	cltd   
  801d36:	c1 ea 1b             	shr    $0x1b,%edx
  801d39:	01 d0                	add    %edx,%eax
  801d3b:	83 e0 1f             	and    $0x1f,%eax
  801d3e:	29 d0                	sub    %edx,%eax
  801d40:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d48:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801d4b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801d4e:	83 c6 01             	add    $0x1,%esi
  801d51:	eb b4                	jmp    801d07 <devpipe_read+0x1c>
	return i;
  801d53:	89 f0                	mov    %esi,%eax
  801d55:	eb d6                	jmp    801d2d <devpipe_read+0x42>
				return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	eb cf                	jmp    801d2d <devpipe_read+0x42>

00801d5e <pipe>:
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	56                   	push   %esi
  801d62:	53                   	push   %ebx
  801d63:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d69:	50                   	push   %eax
  801d6a:	e8 ef f1 ff ff       	call   800f5e <fd_alloc>
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	85 c0                	test   %eax,%eax
  801d76:	78 5b                	js     801dd3 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	68 07 04 00 00       	push   $0x407
  801d80:	ff 75 f4             	pushl  -0xc(%ebp)
  801d83:	6a 00                	push   $0x0
  801d85:	e8 9d ef ff ff       	call   800d27 <sys_page_alloc>
  801d8a:	89 c3                	mov    %eax,%ebx
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	85 c0                	test   %eax,%eax
  801d91:	78 40                	js     801dd3 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d93:	83 ec 0c             	sub    $0xc,%esp
  801d96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d99:	50                   	push   %eax
  801d9a:	e8 bf f1 ff ff       	call   800f5e <fd_alloc>
  801d9f:	89 c3                	mov    %eax,%ebx
  801da1:	83 c4 10             	add    $0x10,%esp
  801da4:	85 c0                	test   %eax,%eax
  801da6:	78 1b                	js     801dc3 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801da8:	83 ec 04             	sub    $0x4,%esp
  801dab:	68 07 04 00 00       	push   $0x407
  801db0:	ff 75 f0             	pushl  -0x10(%ebp)
  801db3:	6a 00                	push   $0x0
  801db5:	e8 6d ef ff ff       	call   800d27 <sys_page_alloc>
  801dba:	89 c3                	mov    %eax,%ebx
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	79 19                	jns    801ddc <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801dc3:	83 ec 08             	sub    $0x8,%esp
  801dc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc9:	6a 00                	push   $0x0
  801dcb:	e8 dc ef ff ff       	call   800dac <sys_page_unmap>
  801dd0:	83 c4 10             	add    $0x10,%esp
}
  801dd3:	89 d8                	mov    %ebx,%eax
  801dd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd8:	5b                   	pop    %ebx
  801dd9:	5e                   	pop    %esi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    
	va = fd2data(fd0);
  801ddc:	83 ec 0c             	sub    $0xc,%esp
  801ddf:	ff 75 f4             	pushl  -0xc(%ebp)
  801de2:	e8 60 f1 ff ff       	call   800f47 <fd2data>
  801de7:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de9:	83 c4 0c             	add    $0xc,%esp
  801dec:	68 07 04 00 00       	push   $0x407
  801df1:	50                   	push   %eax
  801df2:	6a 00                	push   $0x0
  801df4:	e8 2e ef ff ff       	call   800d27 <sys_page_alloc>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	0f 88 8c 00 00 00    	js     801e92 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e06:	83 ec 0c             	sub    $0xc,%esp
  801e09:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0c:	e8 36 f1 ff ff       	call   800f47 <fd2data>
  801e11:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e18:	50                   	push   %eax
  801e19:	6a 00                	push   $0x0
  801e1b:	56                   	push   %esi
  801e1c:	6a 00                	push   $0x0
  801e1e:	e8 47 ef ff ff       	call   800d6a <sys_page_map>
  801e23:	89 c3                	mov    %eax,%ebx
  801e25:	83 c4 20             	add    $0x20,%esp
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 58                	js     801e84 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e35:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e44:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801e4a:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5c:	e8 d6 f0 ff ff       	call   800f37 <fd2num>
  801e61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e64:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801e66:	83 c4 04             	add    $0x4,%esp
  801e69:	ff 75 f0             	pushl  -0x10(%ebp)
  801e6c:	e8 c6 f0 ff ff       	call   800f37 <fd2num>
  801e71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e74:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801e77:	83 c4 10             	add    $0x10,%esp
  801e7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e7f:	e9 4f ff ff ff       	jmp    801dd3 <pipe+0x75>
	sys_page_unmap(0, va);
  801e84:	83 ec 08             	sub    $0x8,%esp
  801e87:	56                   	push   %esi
  801e88:	6a 00                	push   $0x0
  801e8a:	e8 1d ef ff ff       	call   800dac <sys_page_unmap>
  801e8f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e92:	83 ec 08             	sub    $0x8,%esp
  801e95:	ff 75 f0             	pushl  -0x10(%ebp)
  801e98:	6a 00                	push   $0x0
  801e9a:	e8 0d ef ff ff       	call   800dac <sys_page_unmap>
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	e9 1c ff ff ff       	jmp    801dc3 <pipe+0x65>

00801ea7 <pipeisclosed>:
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ead:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb0:	50                   	push   %eax
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	e8 f4 f0 ff ff       	call   800fad <fd_lookup>
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	78 18                	js     801ed8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec6:	e8 7c f0 ff ff       	call   800f47 <fd2data>
	return _pipeisclosed(fd, p);
  801ecb:	89 c2                	mov    %eax,%edx
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	e8 30 fd ff ff       	call   801c05 <_pipeisclosed>
  801ed5:	83 c4 10             	add    $0x10,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801eea:	68 eb 28 80 00       	push   $0x8028eb
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	e8 37 ea ff ff       	call   80092e <strcpy>
	return 0;
}
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <devcons_write>:
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	57                   	push   %edi
  801f02:	56                   	push   %esi
  801f03:	53                   	push   %ebx
  801f04:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f0a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f0f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f15:	eb 2f                	jmp    801f46 <devcons_write+0x48>
		m = n - tot;
  801f17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f1a:	29 f3                	sub    %esi,%ebx
  801f1c:	83 fb 7f             	cmp    $0x7f,%ebx
  801f1f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f24:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	53                   	push   %ebx
  801f2b:	89 f0                	mov    %esi,%eax
  801f2d:	03 45 0c             	add    0xc(%ebp),%eax
  801f30:	50                   	push   %eax
  801f31:	57                   	push   %edi
  801f32:	e8 85 eb ff ff       	call   800abc <memmove>
		sys_cputs(buf, m);
  801f37:	83 c4 08             	add    $0x8,%esp
  801f3a:	53                   	push   %ebx
  801f3b:	57                   	push   %edi
  801f3c:	e8 2a ed ff ff       	call   800c6b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801f41:	01 de                	add    %ebx,%esi
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f49:	72 cc                	jb     801f17 <devcons_write+0x19>
}
  801f4b:	89 f0                	mov    %esi,%eax
  801f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f50:	5b                   	pop    %ebx
  801f51:	5e                   	pop    %esi
  801f52:	5f                   	pop    %edi
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    

00801f55 <devcons_read>:
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 08             	sub    $0x8,%esp
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f64:	75 07                	jne    801f6d <devcons_read+0x18>
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    
		sys_yield();
  801f68:	e8 9b ed ff ff       	call   800d08 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801f6d:	e8 17 ed ff ff       	call   800c89 <sys_cgetc>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	74 f2                	je     801f68 <devcons_read+0x13>
	if (c < 0)
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 ec                	js     801f66 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801f7a:	83 f8 04             	cmp    $0x4,%eax
  801f7d:	74 0c                	je     801f8b <devcons_read+0x36>
	*(char*)vbuf = c;
  801f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f82:	88 02                	mov    %al,(%edx)
	return 1;
  801f84:	b8 01 00 00 00       	mov    $0x1,%eax
  801f89:	eb db                	jmp    801f66 <devcons_read+0x11>
		return 0;
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	eb d4                	jmp    801f66 <devcons_read+0x11>

00801f92 <cputchar>:
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f9e:	6a 01                	push   $0x1
  801fa0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fa3:	50                   	push   %eax
  801fa4:	e8 c2 ec ff ff       	call   800c6b <sys_cputs>
}
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <getchar>:
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801fb4:	6a 01                	push   $0x1
  801fb6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801fb9:	50                   	push   %eax
  801fba:	6a 00                	push   $0x0
  801fbc:	e8 5d f2 ff ff       	call   80121e <read>
	if (r < 0)
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	78 08                	js     801fd0 <getchar+0x22>
	if (r < 1)
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	7e 06                	jle    801fd2 <getchar+0x24>
	return c;
  801fcc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    
		return -E_EOF;
  801fd2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801fd7:	eb f7                	jmp    801fd0 <getchar+0x22>

00801fd9 <iscons>:
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fdf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe2:	50                   	push   %eax
  801fe3:	ff 75 08             	pushl  0x8(%ebp)
  801fe6:	e8 c2 ef ff ff       	call   800fad <fd_lookup>
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	78 11                	js     802003 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801ffb:	39 10                	cmp    %edx,(%eax)
  801ffd:	0f 94 c0             	sete   %al
  802000:	0f b6 c0             	movzbl %al,%eax
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <opencons>:
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80200b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200e:	50                   	push   %eax
  80200f:	e8 4a ef ff ff       	call   800f5e <fd_alloc>
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	78 3a                	js     802055 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	68 07 04 00 00       	push   $0x407
  802023:	ff 75 f4             	pushl  -0xc(%ebp)
  802026:	6a 00                	push   $0x0
  802028:	e8 fa ec ff ff       	call   800d27 <sys_page_alloc>
  80202d:	83 c4 10             	add    $0x10,%esp
  802030:	85 c0                	test   %eax,%eax
  802032:	78 21                	js     802055 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80203d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	50                   	push   %eax
  80204d:	e8 e5 ee ff ff       	call   800f37 <fd2num>
  802052:	83 c4 10             	add    $0x10,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	56                   	push   %esi
  80205b:	53                   	push   %ebx
  80205c:	8b 75 08             	mov    0x8(%ebp),%esi
  80205f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802062:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802065:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802067:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80206c:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	50                   	push   %eax
  802073:	e8 5f ee ff ff       	call   800ed7 <sys_ipc_recv>
	if (from_env_store)
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	85 f6                	test   %esi,%esi
  80207d:	74 14                	je     802093 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  80207f:	ba 00 00 00 00       	mov    $0x0,%edx
  802084:	85 c0                	test   %eax,%eax
  802086:	78 09                	js     802091 <ipc_recv+0x3a>
  802088:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80208e:	8b 52 74             	mov    0x74(%edx),%edx
  802091:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802093:	85 db                	test   %ebx,%ebx
  802095:	74 14                	je     8020ab <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802097:	ba 00 00 00 00       	mov    $0x0,%edx
  80209c:	85 c0                	test   %eax,%eax
  80209e:	78 09                	js     8020a9 <ipc_recv+0x52>
  8020a0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020a6:	8b 52 78             	mov    0x78(%edx),%edx
  8020a9:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 08                	js     8020b7 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8020af:	a1 08 40 80 00       	mov    0x804008,%eax
  8020b4:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8020b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ba:	5b                   	pop    %ebx
  8020bb:	5e                   	pop    %esi
  8020bc:	5d                   	pop    %ebp
  8020bd:	c3                   	ret    

008020be <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 0c             	sub    $0xc,%esp
  8020c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8020ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8020d0:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8020d2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8020d7:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8020da:	ff 75 14             	pushl  0x14(%ebp)
  8020dd:	53                   	push   %ebx
  8020de:	56                   	push   %esi
  8020df:	57                   	push   %edi
  8020e0:	e8 cf ed ff ff       	call   800eb4 <sys_ipc_try_send>
		if (ret == 0)
  8020e5:	83 c4 10             	add    $0x10,%esp
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	74 1e                	je     80210a <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8020ec:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020ef:	75 07                	jne    8020f8 <ipc_send+0x3a>
			sys_yield();
  8020f1:	e8 12 ec ff ff       	call   800d08 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8020f6:	eb e2                	jmp    8020da <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  8020f8:	50                   	push   %eax
  8020f9:	68 f7 28 80 00       	push   $0x8028f7
  8020fe:	6a 3d                	push   $0x3d
  802100:	68 0b 29 80 00       	push   $0x80290b
  802105:	e8 2a e1 ff ff       	call   800234 <_panic>
	}
	// panic("ipc_send not implemented");
}
  80210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5f                   	pop    %edi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    

00802112 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80211d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802120:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802126:	8b 52 50             	mov    0x50(%edx),%edx
  802129:	39 ca                	cmp    %ecx,%edx
  80212b:	74 11                	je     80213e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80212d:	83 c0 01             	add    $0x1,%eax
  802130:	3d 00 04 00 00       	cmp    $0x400,%eax
  802135:	75 e6                	jne    80211d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	eb 0b                	jmp    802149 <ipc_find_env+0x37>
			return envs[i].env_id;
  80213e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802141:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802146:	8b 40 48             	mov    0x48(%eax),%eax
}
  802149:	5d                   	pop    %ebp
  80214a:	c3                   	ret    

0080214b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802151:	89 d0                	mov    %edx,%eax
  802153:	c1 e8 16             	shr    $0x16,%eax
  802156:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80215d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802162:	f6 c1 01             	test   $0x1,%cl
  802165:	74 1d                	je     802184 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802167:	c1 ea 0c             	shr    $0xc,%edx
  80216a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802171:	f6 c2 01             	test   $0x1,%dl
  802174:	74 0e                	je     802184 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802176:	c1 ea 0c             	shr    $0xc,%edx
  802179:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802180:	ef 
  802181:	0f b7 c0             	movzwl %ax,%eax
}
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    
  802186:	66 90                	xchg   %ax,%ax
  802188:	66 90                	xchg   %ax,%ax
  80218a:	66 90                	xchg   %ax,%ax
  80218c:	66 90                	xchg   %ax,%ax
  80218e:	66 90                	xchg   %ax,%ax

00802190 <__udivdi3>:
  802190:	55                   	push   %ebp
  802191:	57                   	push   %edi
  802192:	56                   	push   %esi
  802193:	53                   	push   %ebx
  802194:	83 ec 1c             	sub    $0x1c,%esp
  802197:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80219b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80219f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8021a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8021a7:	85 d2                	test   %edx,%edx
  8021a9:	75 35                	jne    8021e0 <__udivdi3+0x50>
  8021ab:	39 f3                	cmp    %esi,%ebx
  8021ad:	0f 87 bd 00 00 00    	ja     802270 <__udivdi3+0xe0>
  8021b3:	85 db                	test   %ebx,%ebx
  8021b5:	89 d9                	mov    %ebx,%ecx
  8021b7:	75 0b                	jne    8021c4 <__udivdi3+0x34>
  8021b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8021be:	31 d2                	xor    %edx,%edx
  8021c0:	f7 f3                	div    %ebx
  8021c2:	89 c1                	mov    %eax,%ecx
  8021c4:	31 d2                	xor    %edx,%edx
  8021c6:	89 f0                	mov    %esi,%eax
  8021c8:	f7 f1                	div    %ecx
  8021ca:	89 c6                	mov    %eax,%esi
  8021cc:	89 e8                	mov    %ebp,%eax
  8021ce:	89 f7                	mov    %esi,%edi
  8021d0:	f7 f1                	div    %ecx
  8021d2:	89 fa                	mov    %edi,%edx
  8021d4:	83 c4 1c             	add    $0x1c,%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5f                   	pop    %edi
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    
  8021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021e0:	39 f2                	cmp    %esi,%edx
  8021e2:	77 7c                	ja     802260 <__udivdi3+0xd0>
  8021e4:	0f bd fa             	bsr    %edx,%edi
  8021e7:	83 f7 1f             	xor    $0x1f,%edi
  8021ea:	0f 84 98 00 00 00    	je     802288 <__udivdi3+0xf8>
  8021f0:	89 f9                	mov    %edi,%ecx
  8021f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8021f7:	29 f8                	sub    %edi,%eax
  8021f9:	d3 e2                	shl    %cl,%edx
  8021fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021ff:	89 c1                	mov    %eax,%ecx
  802201:	89 da                	mov    %ebx,%edx
  802203:	d3 ea                	shr    %cl,%edx
  802205:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802209:	09 d1                	or     %edx,%ecx
  80220b:	89 f2                	mov    %esi,%edx
  80220d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802211:	89 f9                	mov    %edi,%ecx
  802213:	d3 e3                	shl    %cl,%ebx
  802215:	89 c1                	mov    %eax,%ecx
  802217:	d3 ea                	shr    %cl,%edx
  802219:	89 f9                	mov    %edi,%ecx
  80221b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80221f:	d3 e6                	shl    %cl,%esi
  802221:	89 eb                	mov    %ebp,%ebx
  802223:	89 c1                	mov    %eax,%ecx
  802225:	d3 eb                	shr    %cl,%ebx
  802227:	09 de                	or     %ebx,%esi
  802229:	89 f0                	mov    %esi,%eax
  80222b:	f7 74 24 08          	divl   0x8(%esp)
  80222f:	89 d6                	mov    %edx,%esi
  802231:	89 c3                	mov    %eax,%ebx
  802233:	f7 64 24 0c          	mull   0xc(%esp)
  802237:	39 d6                	cmp    %edx,%esi
  802239:	72 0c                	jb     802247 <__udivdi3+0xb7>
  80223b:	89 f9                	mov    %edi,%ecx
  80223d:	d3 e5                	shl    %cl,%ebp
  80223f:	39 c5                	cmp    %eax,%ebp
  802241:	73 5d                	jae    8022a0 <__udivdi3+0x110>
  802243:	39 d6                	cmp    %edx,%esi
  802245:	75 59                	jne    8022a0 <__udivdi3+0x110>
  802247:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80224a:	31 ff                	xor    %edi,%edi
  80224c:	89 fa                	mov    %edi,%edx
  80224e:	83 c4 1c             	add    $0x1c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    
  802256:	8d 76 00             	lea    0x0(%esi),%esi
  802259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802260:	31 ff                	xor    %edi,%edi
  802262:	31 c0                	xor    %eax,%eax
  802264:	89 fa                	mov    %edi,%edx
  802266:	83 c4 1c             	add    $0x1c,%esp
  802269:	5b                   	pop    %ebx
  80226a:	5e                   	pop    %esi
  80226b:	5f                   	pop    %edi
  80226c:	5d                   	pop    %ebp
  80226d:	c3                   	ret    
  80226e:	66 90                	xchg   %ax,%ax
  802270:	31 ff                	xor    %edi,%edi
  802272:	89 e8                	mov    %ebp,%eax
  802274:	89 f2                	mov    %esi,%edx
  802276:	f7 f3                	div    %ebx
  802278:	89 fa                	mov    %edi,%edx
  80227a:	83 c4 1c             	add    $0x1c,%esp
  80227d:	5b                   	pop    %ebx
  80227e:	5e                   	pop    %esi
  80227f:	5f                   	pop    %edi
  802280:	5d                   	pop    %ebp
  802281:	c3                   	ret    
  802282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802288:	39 f2                	cmp    %esi,%edx
  80228a:	72 06                	jb     802292 <__udivdi3+0x102>
  80228c:	31 c0                	xor    %eax,%eax
  80228e:	39 eb                	cmp    %ebp,%ebx
  802290:	77 d2                	ja     802264 <__udivdi3+0xd4>
  802292:	b8 01 00 00 00       	mov    $0x1,%eax
  802297:	eb cb                	jmp    802264 <__udivdi3+0xd4>
  802299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	89 d8                	mov    %ebx,%eax
  8022a2:	31 ff                	xor    %edi,%edi
  8022a4:	eb be                	jmp    802264 <__udivdi3+0xd4>
  8022a6:	66 90                	xchg   %ax,%ax
  8022a8:	66 90                	xchg   %ax,%ax
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__umoddi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 1c             	sub    $0x1c,%esp
  8022b7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8022bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8022bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8022c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022c7:	85 ed                	test   %ebp,%ebp
  8022c9:	89 f0                	mov    %esi,%eax
  8022cb:	89 da                	mov    %ebx,%edx
  8022cd:	75 19                	jne    8022e8 <__umoddi3+0x38>
  8022cf:	39 df                	cmp    %ebx,%edi
  8022d1:	0f 86 b1 00 00 00    	jbe    802388 <__umoddi3+0xd8>
  8022d7:	f7 f7                	div    %edi
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	83 c4 1c             	add    $0x1c,%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5e                   	pop    %esi
  8022e2:	5f                   	pop    %edi
  8022e3:	5d                   	pop    %ebp
  8022e4:	c3                   	ret    
  8022e5:	8d 76 00             	lea    0x0(%esi),%esi
  8022e8:	39 dd                	cmp    %ebx,%ebp
  8022ea:	77 f1                	ja     8022dd <__umoddi3+0x2d>
  8022ec:	0f bd cd             	bsr    %ebp,%ecx
  8022ef:	83 f1 1f             	xor    $0x1f,%ecx
  8022f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022f6:	0f 84 b4 00 00 00    	je     8023b0 <__umoddi3+0x100>
  8022fc:	b8 20 00 00 00       	mov    $0x20,%eax
  802301:	89 c2                	mov    %eax,%edx
  802303:	8b 44 24 04          	mov    0x4(%esp),%eax
  802307:	29 c2                	sub    %eax,%edx
  802309:	89 c1                	mov    %eax,%ecx
  80230b:	89 f8                	mov    %edi,%eax
  80230d:	d3 e5                	shl    %cl,%ebp
  80230f:	89 d1                	mov    %edx,%ecx
  802311:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802315:	d3 e8                	shr    %cl,%eax
  802317:	09 c5                	or     %eax,%ebp
  802319:	8b 44 24 04          	mov    0x4(%esp),%eax
  80231d:	89 c1                	mov    %eax,%ecx
  80231f:	d3 e7                	shl    %cl,%edi
  802321:	89 d1                	mov    %edx,%ecx
  802323:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802327:	89 df                	mov    %ebx,%edi
  802329:	d3 ef                	shr    %cl,%edi
  80232b:	89 c1                	mov    %eax,%ecx
  80232d:	89 f0                	mov    %esi,%eax
  80232f:	d3 e3                	shl    %cl,%ebx
  802331:	89 d1                	mov    %edx,%ecx
  802333:	89 fa                	mov    %edi,%edx
  802335:	d3 e8                	shr    %cl,%eax
  802337:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80233c:	09 d8                	or     %ebx,%eax
  80233e:	f7 f5                	div    %ebp
  802340:	d3 e6                	shl    %cl,%esi
  802342:	89 d1                	mov    %edx,%ecx
  802344:	f7 64 24 08          	mull   0x8(%esp)
  802348:	39 d1                	cmp    %edx,%ecx
  80234a:	89 c3                	mov    %eax,%ebx
  80234c:	89 d7                	mov    %edx,%edi
  80234e:	72 06                	jb     802356 <__umoddi3+0xa6>
  802350:	75 0e                	jne    802360 <__umoddi3+0xb0>
  802352:	39 c6                	cmp    %eax,%esi
  802354:	73 0a                	jae    802360 <__umoddi3+0xb0>
  802356:	2b 44 24 08          	sub    0x8(%esp),%eax
  80235a:	19 ea                	sbb    %ebp,%edx
  80235c:	89 d7                	mov    %edx,%edi
  80235e:	89 c3                	mov    %eax,%ebx
  802360:	89 ca                	mov    %ecx,%edx
  802362:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802367:	29 de                	sub    %ebx,%esi
  802369:	19 fa                	sbb    %edi,%edx
  80236b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80236f:	89 d0                	mov    %edx,%eax
  802371:	d3 e0                	shl    %cl,%eax
  802373:	89 d9                	mov    %ebx,%ecx
  802375:	d3 ee                	shr    %cl,%esi
  802377:	d3 ea                	shr    %cl,%edx
  802379:	09 f0                	or     %esi,%eax
  80237b:	83 c4 1c             	add    $0x1c,%esp
  80237e:	5b                   	pop    %ebx
  80237f:	5e                   	pop    %esi
  802380:	5f                   	pop    %edi
  802381:	5d                   	pop    %ebp
  802382:	c3                   	ret    
  802383:	90                   	nop
  802384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802388:	85 ff                	test   %edi,%edi
  80238a:	89 f9                	mov    %edi,%ecx
  80238c:	75 0b                	jne    802399 <__umoddi3+0xe9>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f7                	div    %edi
  802397:	89 c1                	mov    %eax,%ecx
  802399:	89 d8                	mov    %ebx,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	f7 f1                	div    %ecx
  80239f:	89 f0                	mov    %esi,%eax
  8023a1:	f7 f1                	div    %ecx
  8023a3:	e9 31 ff ff ff       	jmp    8022d9 <__umoddi3+0x29>
  8023a8:	90                   	nop
  8023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b0:	39 dd                	cmp    %ebx,%ebp
  8023b2:	72 08                	jb     8023bc <__umoddi3+0x10c>
  8023b4:	39 f7                	cmp    %esi,%edi
  8023b6:	0f 87 21 ff ff ff    	ja     8022dd <__umoddi3+0x2d>
  8023bc:	89 da                	mov    %ebx,%edx
  8023be:	89 f0                	mov    %esi,%eax
  8023c0:	29 f8                	sub    %edi,%eax
  8023c2:	19 ea                	sbb    %ebp,%edx
  8023c4:	e9 14 ff ff ff       	jmp    8022dd <__umoddi3+0x2d>

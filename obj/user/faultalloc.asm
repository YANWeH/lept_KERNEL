
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 99 00 00 00       	call   8000ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 60 23 80 00       	push   $0x802360
  800045:	e8 bb 01 00 00       	call   800205 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 bf 0b 00 00       	call   800c1d <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 ac 23 80 00       	push   $0x8023ac
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 60 07 00 00       	call   8007d3 <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 80 23 80 00       	push   $0x802380
  800085:	6a 0e                	push   $0xe
  800087:	68 6a 23 80 00       	push   $0x80236a
  80008c:	e8 99 00 00 00       	call   80012a <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 8c 0d 00 00       	call   800e2d <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	68 ef be ad de       	push   $0xdeadbeef
  8000a9:	68 7c 23 80 00       	push   $0x80237c
  8000ae:	e8 52 01 00 00       	call   800205 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	68 fe bf fe ca       	push   $0xcafebffe
  8000bb:	68 7c 23 80 00       	push   $0x80237c
  8000c0:	e8 40 01 00 00       	call   800205 <cprintf>
}
  8000c5:	83 c4 10             	add    $0x10,%esp
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    

008000ca <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000ca:	55                   	push   %ebp
  8000cb:	89 e5                	mov    %esp,%ebp
  8000cd:	56                   	push   %esi
  8000ce:	53                   	push   %ebx
  8000cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d5:	e8 05 0b 00 00       	call   800bdf <sys_getenvid>
  8000da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e7:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ec:	85 db                	test   %ebx,%ebx
  8000ee:	7e 07                	jle    8000f7 <libmain+0x2d>
		binaryname = argv[0];
  8000f0:	8b 06                	mov    (%esi),%eax
  8000f2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	56                   	push   %esi
  8000fb:	53                   	push   %ebx
  8000fc:	e8 90 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  800101:	e8 0a 00 00 00       	call   800110 <exit>
}
  800106:	83 c4 10             	add    $0x10,%esp
  800109:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5d                   	pop    %ebp
  80010f:	c3                   	ret    

00800110 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800110:	55                   	push   %ebp
  800111:	89 e5                	mov    %esp,%ebp
  800113:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800116:	e8 73 0f 00 00       	call   80108e <close_all>
	sys_env_destroy(0);
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	6a 00                	push   $0x0
  800120:	e8 79 0a 00 00       	call   800b9e <sys_env_destroy>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	c9                   	leave  
  800129:	c3                   	ret    

0080012a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	56                   	push   %esi
  80012e:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80012f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800132:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800138:	e8 a2 0a 00 00       	call   800bdf <sys_getenvid>
  80013d:	83 ec 0c             	sub    $0xc,%esp
  800140:	ff 75 0c             	pushl  0xc(%ebp)
  800143:	ff 75 08             	pushl  0x8(%ebp)
  800146:	56                   	push   %esi
  800147:	50                   	push   %eax
  800148:	68 d8 23 80 00       	push   $0x8023d8
  80014d:	e8 b3 00 00 00       	call   800205 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800152:	83 c4 18             	add    $0x18,%esp
  800155:	53                   	push   %ebx
  800156:	ff 75 10             	pushl  0x10(%ebp)
  800159:	e8 56 00 00 00       	call   8001b4 <vcprintf>
	cprintf("\n");
  80015e:	c7 04 24 68 28 80 00 	movl   $0x802868,(%esp)
  800165:	e8 9b 00 00 00       	call   800205 <cprintf>
  80016a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80016d:	cc                   	int3   
  80016e:	eb fd                	jmp    80016d <_panic+0x43>

00800170 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	53                   	push   %ebx
  800174:	83 ec 04             	sub    $0x4,%esp
  800177:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017a:	8b 13                	mov    (%ebx),%edx
  80017c:	8d 42 01             	lea    0x1(%edx),%eax
  80017f:	89 03                	mov    %eax,(%ebx)
  800181:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800184:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800188:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018d:	74 09                	je     800198 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80018f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800196:	c9                   	leave  
  800197:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	68 ff 00 00 00       	push   $0xff
  8001a0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 b8 09 00 00       	call   800b61 <sys_cputs>
		b->idx = 0;
  8001a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001af:	83 c4 10             	add    $0x10,%esp
  8001b2:	eb db                	jmp    80018f <putch+0x1f>

008001b4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c4:	00 00 00 
	b.cnt = 0;
  8001c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d1:	ff 75 0c             	pushl  0xc(%ebp)
  8001d4:	ff 75 08             	pushl  0x8(%ebp)
  8001d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001dd:	50                   	push   %eax
  8001de:	68 70 01 80 00       	push   $0x800170
  8001e3:	e8 1a 01 00 00       	call   800302 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e8:	83 c4 08             	add    $0x8,%esp
  8001eb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f7:	50                   	push   %eax
  8001f8:	e8 64 09 00 00       	call   800b61 <sys_cputs>

	return b.cnt;
}
  8001fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020e:	50                   	push   %eax
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	e8 9d ff ff ff       	call   8001b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800217:	c9                   	leave  
  800218:	c3                   	ret    

00800219 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	57                   	push   %edi
  80021d:	56                   	push   %esi
  80021e:	53                   	push   %ebx
  80021f:	83 ec 1c             	sub    $0x1c,%esp
  800222:	89 c7                	mov    %eax,%edi
  800224:	89 d6                	mov    %edx,%esi
  800226:	8b 45 08             	mov    0x8(%ebp),%eax
  800229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800240:	39 d3                	cmp    %edx,%ebx
  800242:	72 05                	jb     800249 <printnum+0x30>
  800244:	39 45 10             	cmp    %eax,0x10(%ebp)
  800247:	77 7a                	ja     8002c3 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800249:	83 ec 0c             	sub    $0xc,%esp
  80024c:	ff 75 18             	pushl  0x18(%ebp)
  80024f:	8b 45 14             	mov    0x14(%ebp),%eax
  800252:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800255:	53                   	push   %ebx
  800256:	ff 75 10             	pushl  0x10(%ebp)
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	ff 75 e0             	pushl  -0x20(%ebp)
  800262:	ff 75 dc             	pushl  -0x24(%ebp)
  800265:	ff 75 d8             	pushl  -0x28(%ebp)
  800268:	e8 a3 1e 00 00       	call   802110 <__udivdi3>
  80026d:	83 c4 18             	add    $0x18,%esp
  800270:	52                   	push   %edx
  800271:	50                   	push   %eax
  800272:	89 f2                	mov    %esi,%edx
  800274:	89 f8                	mov    %edi,%eax
  800276:	e8 9e ff ff ff       	call   800219 <printnum>
  80027b:	83 c4 20             	add    $0x20,%esp
  80027e:	eb 13                	jmp    800293 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	56                   	push   %esi
  800284:	ff 75 18             	pushl  0x18(%ebp)
  800287:	ff d7                	call   *%edi
  800289:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028c:	83 eb 01             	sub    $0x1,%ebx
  80028f:	85 db                	test   %ebx,%ebx
  800291:	7f ed                	jg     800280 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800293:	83 ec 08             	sub    $0x8,%esp
  800296:	56                   	push   %esi
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029d:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 85 1f 00 00       	call   802230 <__umoddi3>
  8002ab:	83 c4 14             	add    $0x14,%esp
  8002ae:	0f be 80 fb 23 80 00 	movsbl 0x8023fb(%eax),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff d7                	call   *%edi
}
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002be:	5b                   	pop    %ebx
  8002bf:	5e                   	pop    %esi
  8002c0:	5f                   	pop    %edi
  8002c1:	5d                   	pop    %ebp
  8002c2:	c3                   	ret    
  8002c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c6:	eb c4                	jmp    80028c <printnum+0x73>

008002c8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ce:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d2:	8b 10                	mov    (%eax),%edx
  8002d4:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d7:	73 0a                	jae    8002e3 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002d9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dc:	89 08                	mov    %ecx,(%eax)
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	88 02                	mov    %al,(%edx)
}
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <printfmt>:
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002eb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ee:	50                   	push   %eax
  8002ef:	ff 75 10             	pushl  0x10(%ebp)
  8002f2:	ff 75 0c             	pushl  0xc(%ebp)
  8002f5:	ff 75 08             	pushl  0x8(%ebp)
  8002f8:	e8 05 00 00 00       	call   800302 <vprintfmt>
}
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <vprintfmt>:
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 2c             	sub    $0x2c,%esp
  80030b:	8b 75 08             	mov    0x8(%ebp),%esi
  80030e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800311:	8b 7d 10             	mov    0x10(%ebp),%edi
  800314:	e9 c1 03 00 00       	jmp    8006da <vprintfmt+0x3d8>
		padc = ' ';
  800319:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800324:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800332:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8d 47 01             	lea    0x1(%edi),%eax
  80033a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033d:	0f b6 17             	movzbl (%edi),%edx
  800340:	8d 42 dd             	lea    -0x23(%edx),%eax
  800343:	3c 55                	cmp    $0x55,%al
  800345:	0f 87 12 04 00 00    	ja     80075d <vprintfmt+0x45b>
  80034b:	0f b6 c0             	movzbl %al,%eax
  80034e:	ff 24 85 40 25 80 00 	jmp    *0x802540(,%eax,4)
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800358:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80035c:	eb d9                	jmp    800337 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800361:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800365:	eb d0                	jmp    800337 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800367:	0f b6 d2             	movzbl %dl,%edx
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036d:	b8 00 00 00 00       	mov    $0x0,%eax
  800372:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800375:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800378:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80037c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80037f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800382:	83 f9 09             	cmp    $0x9,%ecx
  800385:	77 55                	ja     8003dc <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800387:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038a:	eb e9                	jmp    800375 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80038c:	8b 45 14             	mov    0x14(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 40 04             	lea    0x4(%eax),%eax
  80039a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a4:	79 91                	jns    800337 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ac:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b3:	eb 82                	jmp    800337 <vprintfmt+0x35>
  8003b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b8:	85 c0                	test   %eax,%eax
  8003ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bf:	0f 49 d0             	cmovns %eax,%edx
  8003c2:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c8:	e9 6a ff ff ff       	jmp    800337 <vprintfmt+0x35>
  8003cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d7:	e9 5b ff ff ff       	jmp    800337 <vprintfmt+0x35>
  8003dc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e2:	eb bc                	jmp    8003a0 <vprintfmt+0x9e>
			lflag++;
  8003e4:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ea:	e9 48 ff ff ff       	jmp    800337 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8d 78 04             	lea    0x4(%eax),%edi
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	53                   	push   %ebx
  8003f9:	ff 30                	pushl  (%eax)
  8003fb:	ff d6                	call   *%esi
			break;
  8003fd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800400:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800403:	e9 cf 02 00 00       	jmp    8006d7 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8d 78 04             	lea    0x4(%eax),%edi
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	99                   	cltd   
  800411:	31 d0                	xor    %edx,%eax
  800413:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800415:	83 f8 0f             	cmp    $0xf,%eax
  800418:	7f 23                	jg     80043d <vprintfmt+0x13b>
  80041a:	8b 14 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edx
  800421:	85 d2                	test   %edx,%edx
  800423:	74 18                	je     80043d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800425:	52                   	push   %edx
  800426:	68 fd 27 80 00       	push   $0x8027fd
  80042b:	53                   	push   %ebx
  80042c:	56                   	push   %esi
  80042d:	e8 b3 fe ff ff       	call   8002e5 <printfmt>
  800432:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800435:	89 7d 14             	mov    %edi,0x14(%ebp)
  800438:	e9 9a 02 00 00       	jmp    8006d7 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80043d:	50                   	push   %eax
  80043e:	68 13 24 80 00       	push   $0x802413
  800443:	53                   	push   %ebx
  800444:	56                   	push   %esi
  800445:	e8 9b fe ff ff       	call   8002e5 <printfmt>
  80044a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800450:	e9 82 02 00 00       	jmp    8006d7 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	83 c0 04             	add    $0x4,%eax
  80045b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800463:	85 ff                	test   %edi,%edi
  800465:	b8 0c 24 80 00       	mov    $0x80240c,%eax
  80046a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800471:	0f 8e bd 00 00 00    	jle    800534 <vprintfmt+0x232>
  800477:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047b:	75 0e                	jne    80048b <vprintfmt+0x189>
  80047d:	89 75 08             	mov    %esi,0x8(%ebp)
  800480:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800483:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800486:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800489:	eb 6d                	jmp    8004f8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	ff 75 d0             	pushl  -0x30(%ebp)
  800491:	57                   	push   %edi
  800492:	e8 6e 03 00 00       	call   800805 <strnlen>
  800497:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049a:	29 c1                	sub    %eax,%ecx
  80049c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80049f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ac:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ae:	eb 0f                	jmp    8004bf <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b0:	83 ec 08             	sub    $0x8,%esp
  8004b3:	53                   	push   %ebx
  8004b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ef 01             	sub    $0x1,%edi
  8004bc:	83 c4 10             	add    $0x10,%esp
  8004bf:	85 ff                	test   %edi,%edi
  8004c1:	7f ed                	jg     8004b0 <vprintfmt+0x1ae>
  8004c3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004c9:	85 c9                	test   %ecx,%ecx
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	0f 49 c1             	cmovns %ecx,%eax
  8004d3:	29 c1                	sub    %eax,%ecx
  8004d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004db:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004de:	89 cb                	mov    %ecx,%ebx
  8004e0:	eb 16                	jmp    8004f8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e6:	75 31                	jne    800519 <vprintfmt+0x217>
					putch(ch, putdat);
  8004e8:	83 ec 08             	sub    $0x8,%esp
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	50                   	push   %eax
  8004ef:	ff 55 08             	call   *0x8(%ebp)
  8004f2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 eb 01             	sub    $0x1,%ebx
  8004f8:	83 c7 01             	add    $0x1,%edi
  8004fb:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ff:	0f be c2             	movsbl %dl,%eax
  800502:	85 c0                	test   %eax,%eax
  800504:	74 59                	je     80055f <vprintfmt+0x25d>
  800506:	85 f6                	test   %esi,%esi
  800508:	78 d8                	js     8004e2 <vprintfmt+0x1e0>
  80050a:	83 ee 01             	sub    $0x1,%esi
  80050d:	79 d3                	jns    8004e2 <vprintfmt+0x1e0>
  80050f:	89 df                	mov    %ebx,%edi
  800511:	8b 75 08             	mov    0x8(%ebp),%esi
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800517:	eb 37                	jmp    800550 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800519:	0f be d2             	movsbl %dl,%edx
  80051c:	83 ea 20             	sub    $0x20,%edx
  80051f:	83 fa 5e             	cmp    $0x5e,%edx
  800522:	76 c4                	jbe    8004e8 <vprintfmt+0x1e6>
					putch('?', putdat);
  800524:	83 ec 08             	sub    $0x8,%esp
  800527:	ff 75 0c             	pushl  0xc(%ebp)
  80052a:	6a 3f                	push   $0x3f
  80052c:	ff 55 08             	call   *0x8(%ebp)
  80052f:	83 c4 10             	add    $0x10,%esp
  800532:	eb c1                	jmp    8004f5 <vprintfmt+0x1f3>
  800534:	89 75 08             	mov    %esi,0x8(%ebp)
  800537:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800540:	eb b6                	jmp    8004f8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	53                   	push   %ebx
  800546:	6a 20                	push   $0x20
  800548:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054a:	83 ef 01             	sub    $0x1,%edi
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	85 ff                	test   %edi,%edi
  800552:	7f ee                	jg     800542 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
  80055a:	e9 78 01 00 00       	jmp    8006d7 <vprintfmt+0x3d5>
  80055f:	89 df                	mov    %ebx,%edi
  800561:	8b 75 08             	mov    0x8(%ebp),%esi
  800564:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800567:	eb e7                	jmp    800550 <vprintfmt+0x24e>
	if (lflag >= 2)
  800569:	83 f9 01             	cmp    $0x1,%ecx
  80056c:	7e 3f                	jle    8005ad <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 50 04             	mov    0x4(%eax),%edx
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8d 40 08             	lea    0x8(%eax),%eax
  800582:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800585:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800589:	79 5c                	jns    8005e7 <vprintfmt+0x2e5>
				putch('-', putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	6a 2d                	push   $0x2d
  800591:	ff d6                	call   *%esi
				num = -(long long) num;
  800593:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800596:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800599:	f7 da                	neg    %edx
  80059b:	83 d1 00             	adc    $0x0,%ecx
  80059e:	f7 d9                	neg    %ecx
  8005a0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a8:	e9 10 01 00 00       	jmp    8006bd <vprintfmt+0x3bb>
	else if (lflag)
  8005ad:	85 c9                	test   %ecx,%ecx
  8005af:	75 1b                	jne    8005cc <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b9:	89 c1                	mov    %eax,%ecx
  8005bb:	c1 f9 1f             	sar    $0x1f,%ecx
  8005be:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 40 04             	lea    0x4(%eax),%eax
  8005c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ca:	eb b9                	jmp    800585 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d4:	89 c1                	mov    %eax,%ecx
  8005d6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	eb 9e                	jmp    800585 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f2:	e9 c6 00 00 00       	jmp    8006bd <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005f7:	83 f9 01             	cmp    $0x1,%ecx
  8005fa:	7e 18                	jle    800614 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8b 10                	mov    (%eax),%edx
  800601:	8b 48 04             	mov    0x4(%eax),%ecx
  800604:	8d 40 08             	lea    0x8(%eax),%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060f:	e9 a9 00 00 00       	jmp    8006bd <vprintfmt+0x3bb>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	75 1a                	jne    800632 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062d:	e9 8b 00 00 00       	jmp    8006bd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800642:	b8 0a 00 00 00       	mov    $0xa,%eax
  800647:	eb 74                	jmp    8006bd <vprintfmt+0x3bb>
	if (lflag >= 2)
  800649:	83 f9 01             	cmp    $0x1,%ecx
  80064c:	7e 15                	jle    800663 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 10                	mov    (%eax),%edx
  800653:	8b 48 04             	mov    0x4(%eax),%ecx
  800656:	8d 40 08             	lea    0x8(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065c:	b8 08 00 00 00       	mov    $0x8,%eax
  800661:	eb 5a                	jmp    8006bd <vprintfmt+0x3bb>
	else if (lflag)
  800663:	85 c9                	test   %ecx,%ecx
  800665:	75 17                	jne    80067e <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 10                	mov    (%eax),%edx
  80066c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800671:	8d 40 04             	lea    0x4(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800677:	b8 08 00 00 00       	mov    $0x8,%eax
  80067c:	eb 3f                	jmp    8006bd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 10                	mov    (%eax),%edx
  800683:	b9 00 00 00 00       	mov    $0x0,%ecx
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068e:	b8 08 00 00 00       	mov    $0x8,%eax
  800693:	eb 28                	jmp    8006bd <vprintfmt+0x3bb>
			putch('0', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	53                   	push   %ebx
  800699:	6a 30                	push   $0x30
  80069b:	ff d6                	call   *%esi
			putch('x', putdat);
  80069d:	83 c4 08             	add    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 78                	push   $0x78
  8006a3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8b 10                	mov    (%eax),%edx
  8006aa:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006af:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006bd:	83 ec 0c             	sub    $0xc,%esp
  8006c0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006c4:	57                   	push   %edi
  8006c5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c8:	50                   	push   %eax
  8006c9:	51                   	push   %ecx
  8006ca:	52                   	push   %edx
  8006cb:	89 da                	mov    %ebx,%edx
  8006cd:	89 f0                	mov    %esi,%eax
  8006cf:	e8 45 fb ff ff       	call   800219 <printnum>
			break;
  8006d4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006da:	83 c7 01             	add    $0x1,%edi
  8006dd:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e1:	83 f8 25             	cmp    $0x25,%eax
  8006e4:	0f 84 2f fc ff ff    	je     800319 <vprintfmt+0x17>
			if (ch == '\0')
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	0f 84 8b 00 00 00    	je     80077d <vprintfmt+0x47b>
			putch(ch, putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	50                   	push   %eax
  8006f7:	ff d6                	call   *%esi
  8006f9:	83 c4 10             	add    $0x10,%esp
  8006fc:	eb dc                	jmp    8006da <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006fe:	83 f9 01             	cmp    $0x1,%ecx
  800701:	7e 15                	jle    800718 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800703:	8b 45 14             	mov    0x14(%ebp),%eax
  800706:	8b 10                	mov    (%eax),%edx
  800708:	8b 48 04             	mov    0x4(%eax),%ecx
  80070b:	8d 40 08             	lea    0x8(%eax),%eax
  80070e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800711:	b8 10 00 00 00       	mov    $0x10,%eax
  800716:	eb a5                	jmp    8006bd <vprintfmt+0x3bb>
	else if (lflag)
  800718:	85 c9                	test   %ecx,%ecx
  80071a:	75 17                	jne    800733 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80071c:	8b 45 14             	mov    0x14(%ebp),%eax
  80071f:	8b 10                	mov    (%eax),%edx
  800721:	b9 00 00 00 00       	mov    $0x0,%ecx
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	b8 10 00 00 00       	mov    $0x10,%eax
  800731:	eb 8a                	jmp    8006bd <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800743:	b8 10 00 00 00       	mov    $0x10,%eax
  800748:	e9 70 ff ff ff       	jmp    8006bd <vprintfmt+0x3bb>
			putch(ch, putdat);
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	53                   	push   %ebx
  800751:	6a 25                	push   $0x25
  800753:	ff d6                	call   *%esi
			break;
  800755:	83 c4 10             	add    $0x10,%esp
  800758:	e9 7a ff ff ff       	jmp    8006d7 <vprintfmt+0x3d5>
			putch('%', putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	53                   	push   %ebx
  800761:	6a 25                	push   $0x25
  800763:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800765:	83 c4 10             	add    $0x10,%esp
  800768:	89 f8                	mov    %edi,%eax
  80076a:	eb 03                	jmp    80076f <vprintfmt+0x46d>
  80076c:	83 e8 01             	sub    $0x1,%eax
  80076f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800773:	75 f7                	jne    80076c <vprintfmt+0x46a>
  800775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800778:	e9 5a ff ff ff       	jmp    8006d7 <vprintfmt+0x3d5>
}
  80077d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800780:	5b                   	pop    %ebx
  800781:	5e                   	pop    %esi
  800782:	5f                   	pop    %edi
  800783:	5d                   	pop    %ebp
  800784:	c3                   	ret    

00800785 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800785:	55                   	push   %ebp
  800786:	89 e5                	mov    %esp,%ebp
  800788:	83 ec 18             	sub    $0x18,%esp
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800794:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800798:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80079b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007a2:	85 c0                	test   %eax,%eax
  8007a4:	74 26                	je     8007cc <vsnprintf+0x47>
  8007a6:	85 d2                	test   %edx,%edx
  8007a8:	7e 22                	jle    8007cc <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007aa:	ff 75 14             	pushl  0x14(%ebp)
  8007ad:	ff 75 10             	pushl  0x10(%ebp)
  8007b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b3:	50                   	push   %eax
  8007b4:	68 c8 02 80 00       	push   $0x8002c8
  8007b9:	e8 44 fb ff ff       	call   800302 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    
		return -E_INVAL;
  8007cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d1:	eb f7                	jmp    8007ca <vsnprintf+0x45>

008007d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007dc:	50                   	push   %eax
  8007dd:	ff 75 10             	pushl  0x10(%ebp)
  8007e0:	ff 75 0c             	pushl  0xc(%ebp)
  8007e3:	ff 75 08             	pushl  0x8(%ebp)
  8007e6:	e8 9a ff ff ff       	call   800785 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f8:	eb 03                	jmp    8007fd <strlen+0x10>
		n++;
  8007fa:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007fd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800801:	75 f7                	jne    8007fa <strlen+0xd>
	return n;
}
  800803:	5d                   	pop    %ebp
  800804:	c3                   	ret    

00800805 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800805:	55                   	push   %ebp
  800806:	89 e5                	mov    %esp,%ebp
  800808:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080e:	b8 00 00 00 00       	mov    $0x0,%eax
  800813:	eb 03                	jmp    800818 <strnlen+0x13>
		n++;
  800815:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800818:	39 d0                	cmp    %edx,%eax
  80081a:	74 06                	je     800822 <strnlen+0x1d>
  80081c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800820:	75 f3                	jne    800815 <strnlen+0x10>
	return n;
}
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	53                   	push   %ebx
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80082e:	89 c2                	mov    %eax,%edx
  800830:	83 c1 01             	add    $0x1,%ecx
  800833:	83 c2 01             	add    $0x1,%edx
  800836:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80083a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80083d:	84 db                	test   %bl,%bl
  80083f:	75 ef                	jne    800830 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800841:	5b                   	pop    %ebx
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	53                   	push   %ebx
  800848:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084b:	53                   	push   %ebx
  80084c:	e8 9c ff ff ff       	call   8007ed <strlen>
  800851:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	01 d8                	add    %ebx,%eax
  800859:	50                   	push   %eax
  80085a:	e8 c5 ff ff ff       	call   800824 <strcpy>
	return dst;
}
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800864:	c9                   	leave  
  800865:	c3                   	ret    

00800866 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	56                   	push   %esi
  80086a:	53                   	push   %ebx
  80086b:	8b 75 08             	mov    0x8(%ebp),%esi
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800871:	89 f3                	mov    %esi,%ebx
  800873:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800876:	89 f2                	mov    %esi,%edx
  800878:	eb 0f                	jmp    800889 <strncpy+0x23>
		*dst++ = *src;
  80087a:	83 c2 01             	add    $0x1,%edx
  80087d:	0f b6 01             	movzbl (%ecx),%eax
  800880:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800883:	80 39 01             	cmpb   $0x1,(%ecx)
  800886:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800889:	39 da                	cmp    %ebx,%edx
  80088b:	75 ed                	jne    80087a <strncpy+0x14>
	}
	return ret;
}
  80088d:	89 f0                	mov    %esi,%eax
  80088f:	5b                   	pop    %ebx
  800890:	5e                   	pop    %esi
  800891:	5d                   	pop    %ebp
  800892:	c3                   	ret    

00800893 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	56                   	push   %esi
  800897:	53                   	push   %ebx
  800898:	8b 75 08             	mov    0x8(%ebp),%esi
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a1:	89 f0                	mov    %esi,%eax
  8008a3:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a7:	85 c9                	test   %ecx,%ecx
  8008a9:	75 0b                	jne    8008b6 <strlcpy+0x23>
  8008ab:	eb 17                	jmp    8008c4 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008ad:	83 c2 01             	add    $0x1,%edx
  8008b0:	83 c0 01             	add    $0x1,%eax
  8008b3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008b6:	39 d8                	cmp    %ebx,%eax
  8008b8:	74 07                	je     8008c1 <strlcpy+0x2e>
  8008ba:	0f b6 0a             	movzbl (%edx),%ecx
  8008bd:	84 c9                	test   %cl,%cl
  8008bf:	75 ec                	jne    8008ad <strlcpy+0x1a>
		*dst = '\0';
  8008c1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008c4:	29 f0                	sub    %esi,%eax
}
  8008c6:	5b                   	pop    %ebx
  8008c7:	5e                   	pop    %esi
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d3:	eb 06                	jmp    8008db <strcmp+0x11>
		p++, q++;
  8008d5:	83 c1 01             	add    $0x1,%ecx
  8008d8:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008db:	0f b6 01             	movzbl (%ecx),%eax
  8008de:	84 c0                	test   %al,%al
  8008e0:	74 04                	je     8008e6 <strcmp+0x1c>
  8008e2:	3a 02                	cmp    (%edx),%al
  8008e4:	74 ef                	je     8008d5 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e6:	0f b6 c0             	movzbl %al,%eax
  8008e9:	0f b6 12             	movzbl (%edx),%edx
  8008ec:	29 d0                	sub    %edx,%eax
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	53                   	push   %ebx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	89 c3                	mov    %eax,%ebx
  8008fc:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ff:	eb 06                	jmp    800907 <strncmp+0x17>
		n--, p++, q++;
  800901:	83 c0 01             	add    $0x1,%eax
  800904:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800907:	39 d8                	cmp    %ebx,%eax
  800909:	74 16                	je     800921 <strncmp+0x31>
  80090b:	0f b6 08             	movzbl (%eax),%ecx
  80090e:	84 c9                	test   %cl,%cl
  800910:	74 04                	je     800916 <strncmp+0x26>
  800912:	3a 0a                	cmp    (%edx),%cl
  800914:	74 eb                	je     800901 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800916:	0f b6 00             	movzbl (%eax),%eax
  800919:	0f b6 12             	movzbl (%edx),%edx
  80091c:	29 d0                	sub    %edx,%eax
}
  80091e:	5b                   	pop    %ebx
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    
		return 0;
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	eb f6                	jmp    80091e <strncmp+0x2e>

00800928 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800932:	0f b6 10             	movzbl (%eax),%edx
  800935:	84 d2                	test   %dl,%dl
  800937:	74 09                	je     800942 <strchr+0x1a>
		if (*s == c)
  800939:	38 ca                	cmp    %cl,%dl
  80093b:	74 0a                	je     800947 <strchr+0x1f>
	for (; *s; s++)
  80093d:	83 c0 01             	add    $0x1,%eax
  800940:	eb f0                	jmp    800932 <strchr+0xa>
			return (char *) s;
	return 0;
  800942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800953:	eb 03                	jmp    800958 <strfind+0xf>
  800955:	83 c0 01             	add    $0x1,%eax
  800958:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80095b:	38 ca                	cmp    %cl,%dl
  80095d:	74 04                	je     800963 <strfind+0x1a>
  80095f:	84 d2                	test   %dl,%dl
  800961:	75 f2                	jne    800955 <strfind+0xc>
			break;
	return (char *) s;
}
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	57                   	push   %edi
  800969:	56                   	push   %esi
  80096a:	53                   	push   %ebx
  80096b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800971:	85 c9                	test   %ecx,%ecx
  800973:	74 13                	je     800988 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800975:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097b:	75 05                	jne    800982 <memset+0x1d>
  80097d:	f6 c1 03             	test   $0x3,%cl
  800980:	74 0d                	je     80098f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800982:	8b 45 0c             	mov    0xc(%ebp),%eax
  800985:	fc                   	cld    
  800986:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800988:	89 f8                	mov    %edi,%eax
  80098a:	5b                   	pop    %ebx
  80098b:	5e                   	pop    %esi
  80098c:	5f                   	pop    %edi
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    
		c &= 0xFF;
  80098f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800993:	89 d3                	mov    %edx,%ebx
  800995:	c1 e3 08             	shl    $0x8,%ebx
  800998:	89 d0                	mov    %edx,%eax
  80099a:	c1 e0 18             	shl    $0x18,%eax
  80099d:	89 d6                	mov    %edx,%esi
  80099f:	c1 e6 10             	shl    $0x10,%esi
  8009a2:	09 f0                	or     %esi,%eax
  8009a4:	09 c2                	or     %eax,%edx
  8009a6:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009a8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ab:	89 d0                	mov    %edx,%eax
  8009ad:	fc                   	cld    
  8009ae:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b0:	eb d6                	jmp    800988 <memset+0x23>

008009b2 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	57                   	push   %edi
  8009b6:	56                   	push   %esi
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c0:	39 c6                	cmp    %eax,%esi
  8009c2:	73 35                	jae    8009f9 <memmove+0x47>
  8009c4:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c7:	39 c2                	cmp    %eax,%edx
  8009c9:	76 2e                	jbe    8009f9 <memmove+0x47>
		s += n;
		d += n;
  8009cb:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ce:	89 d6                	mov    %edx,%esi
  8009d0:	09 fe                	or     %edi,%esi
  8009d2:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d8:	74 0c                	je     8009e6 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009da:	83 ef 01             	sub    $0x1,%edi
  8009dd:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e0:	fd                   	std    
  8009e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e3:	fc                   	cld    
  8009e4:	eb 21                	jmp    800a07 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e6:	f6 c1 03             	test   $0x3,%cl
  8009e9:	75 ef                	jne    8009da <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009eb:	83 ef 04             	sub    $0x4,%edi
  8009ee:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009f4:	fd                   	std    
  8009f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f7:	eb ea                	jmp    8009e3 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f9:	89 f2                	mov    %esi,%edx
  8009fb:	09 c2                	or     %eax,%edx
  8009fd:	f6 c2 03             	test   $0x3,%dl
  800a00:	74 09                	je     800a0b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a02:	89 c7                	mov    %eax,%edi
  800a04:	fc                   	cld    
  800a05:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a07:	5e                   	pop    %esi
  800a08:	5f                   	pop    %edi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0b:	f6 c1 03             	test   $0x3,%cl
  800a0e:	75 f2                	jne    800a02 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a10:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a13:	89 c7                	mov    %eax,%edi
  800a15:	fc                   	cld    
  800a16:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a18:	eb ed                	jmp    800a07 <memmove+0x55>

00800a1a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a1d:	ff 75 10             	pushl  0x10(%ebp)
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	ff 75 08             	pushl  0x8(%ebp)
  800a26:	e8 87 ff ff ff       	call   8009b2 <memmove>
}
  800a2b:	c9                   	leave  
  800a2c:	c3                   	ret    

00800a2d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a2d:	55                   	push   %ebp
  800a2e:	89 e5                	mov    %esp,%ebp
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a38:	89 c6                	mov    %eax,%esi
  800a3a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a3d:	39 f0                	cmp    %esi,%eax
  800a3f:	74 1c                	je     800a5d <memcmp+0x30>
		if (*s1 != *s2)
  800a41:	0f b6 08             	movzbl (%eax),%ecx
  800a44:	0f b6 1a             	movzbl (%edx),%ebx
  800a47:	38 d9                	cmp    %bl,%cl
  800a49:	75 08                	jne    800a53 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a4b:	83 c0 01             	add    $0x1,%eax
  800a4e:	83 c2 01             	add    $0x1,%edx
  800a51:	eb ea                	jmp    800a3d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a53:	0f b6 c1             	movzbl %cl,%eax
  800a56:	0f b6 db             	movzbl %bl,%ebx
  800a59:	29 d8                	sub    %ebx,%eax
  800a5b:	eb 05                	jmp    800a62 <memcmp+0x35>
	}

	return 0;
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a6f:	89 c2                	mov    %eax,%edx
  800a71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a74:	39 d0                	cmp    %edx,%eax
  800a76:	73 09                	jae    800a81 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a78:	38 08                	cmp    %cl,(%eax)
  800a7a:	74 05                	je     800a81 <memfind+0x1b>
	for (; s < ends; s++)
  800a7c:	83 c0 01             	add    $0x1,%eax
  800a7f:	eb f3                	jmp    800a74 <memfind+0xe>
			break;
	return (void *) s;
}
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	57                   	push   %edi
  800a87:	56                   	push   %esi
  800a88:	53                   	push   %ebx
  800a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a8f:	eb 03                	jmp    800a94 <strtol+0x11>
		s++;
  800a91:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a94:	0f b6 01             	movzbl (%ecx),%eax
  800a97:	3c 20                	cmp    $0x20,%al
  800a99:	74 f6                	je     800a91 <strtol+0xe>
  800a9b:	3c 09                	cmp    $0x9,%al
  800a9d:	74 f2                	je     800a91 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a9f:	3c 2b                	cmp    $0x2b,%al
  800aa1:	74 2e                	je     800ad1 <strtol+0x4e>
	int neg = 0;
  800aa3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aa8:	3c 2d                	cmp    $0x2d,%al
  800aaa:	74 2f                	je     800adb <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aac:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ab2:	75 05                	jne    800ab9 <strtol+0x36>
  800ab4:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab7:	74 2c                	je     800ae5 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab9:	85 db                	test   %ebx,%ebx
  800abb:	75 0a                	jne    800ac7 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800abd:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ac2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac5:	74 28                	je     800aef <strtol+0x6c>
		base = 10;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  800acc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800acf:	eb 50                	jmp    800b21 <strtol+0x9e>
		s++;
  800ad1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ad4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad9:	eb d1                	jmp    800aac <strtol+0x29>
		s++, neg = 1;
  800adb:	83 c1 01             	add    $0x1,%ecx
  800ade:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae3:	eb c7                	jmp    800aac <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ae9:	74 0e                	je     800af9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aeb:	85 db                	test   %ebx,%ebx
  800aed:	75 d8                	jne    800ac7 <strtol+0x44>
		s++, base = 8;
  800aef:	83 c1 01             	add    $0x1,%ecx
  800af2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800af7:	eb ce                	jmp    800ac7 <strtol+0x44>
		s += 2, base = 16;
  800af9:	83 c1 02             	add    $0x2,%ecx
  800afc:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b01:	eb c4                	jmp    800ac7 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b03:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b06:	89 f3                	mov    %esi,%ebx
  800b08:	80 fb 19             	cmp    $0x19,%bl
  800b0b:	77 29                	ja     800b36 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b0d:	0f be d2             	movsbl %dl,%edx
  800b10:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b13:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b16:	7d 30                	jge    800b48 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b18:	83 c1 01             	add    $0x1,%ecx
  800b1b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b1f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b21:	0f b6 11             	movzbl (%ecx),%edx
  800b24:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b27:	89 f3                	mov    %esi,%ebx
  800b29:	80 fb 09             	cmp    $0x9,%bl
  800b2c:	77 d5                	ja     800b03 <strtol+0x80>
			dig = *s - '0';
  800b2e:	0f be d2             	movsbl %dl,%edx
  800b31:	83 ea 30             	sub    $0x30,%edx
  800b34:	eb dd                	jmp    800b13 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b36:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b39:	89 f3                	mov    %esi,%ebx
  800b3b:	80 fb 19             	cmp    $0x19,%bl
  800b3e:	77 08                	ja     800b48 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b40:	0f be d2             	movsbl %dl,%edx
  800b43:	83 ea 37             	sub    $0x37,%edx
  800b46:	eb cb                	jmp    800b13 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4c:	74 05                	je     800b53 <strtol+0xd0>
		*endptr = (char *) s;
  800b4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b51:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b53:	89 c2                	mov    %eax,%edx
  800b55:	f7 da                	neg    %edx
  800b57:	85 ff                	test   %edi,%edi
  800b59:	0f 45 c2             	cmovne %edx,%eax
}
  800b5c:	5b                   	pop    %ebx
  800b5d:	5e                   	pop    %esi
  800b5e:	5f                   	pop    %edi
  800b5f:	5d                   	pop    %ebp
  800b60:	c3                   	ret    

00800b61 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b72:	89 c3                	mov    %eax,%ebx
  800b74:	89 c7                	mov    %eax,%edi
  800b76:	89 c6                	mov    %eax,%esi
  800b78:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	57                   	push   %edi
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b85:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b8f:	89 d1                	mov    %edx,%ecx
  800b91:	89 d3                	mov    %edx,%ebx
  800b93:	89 d7                	mov    %edx,%edi
  800b95:	89 d6                	mov    %edx,%esi
  800b97:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b99:	5b                   	pop    %ebx
  800b9a:	5e                   	pop    %esi
  800b9b:	5f                   	pop    %edi
  800b9c:	5d                   	pop    %ebp
  800b9d:	c3                   	ret    

00800b9e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
  800ba4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	89 cb                	mov    %ecx,%ebx
  800bb6:	89 cf                	mov    %ecx,%edi
  800bb8:	89 ce                	mov    %ecx,%esi
  800bba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	7f 08                	jg     800bc8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc8:	83 ec 0c             	sub    $0xc,%esp
  800bcb:	50                   	push   %eax
  800bcc:	6a 03                	push   $0x3
  800bce:	68 ff 26 80 00       	push   $0x8026ff
  800bd3:	6a 23                	push   $0x23
  800bd5:	68 1c 27 80 00       	push   $0x80271c
  800bda:	e8 4b f5 ff ff       	call   80012a <_panic>

00800bdf <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	57                   	push   %edi
  800be3:	56                   	push   %esi
  800be4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bea:	b8 02 00 00 00       	mov    $0x2,%eax
  800bef:	89 d1                	mov    %edx,%ecx
  800bf1:	89 d3                	mov    %edx,%ebx
  800bf3:	89 d7                	mov    %edx,%edi
  800bf5:	89 d6                	mov    %edx,%esi
  800bf7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bf9:	5b                   	pop    %ebx
  800bfa:	5e                   	pop    %esi
  800bfb:	5f                   	pop    %edi
  800bfc:	5d                   	pop    %ebp
  800bfd:	c3                   	ret    

00800bfe <sys_yield>:

void
sys_yield(void)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c26:	be 00 00 00 00       	mov    $0x0,%esi
  800c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c31:	b8 04 00 00 00       	mov    $0x4,%eax
  800c36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c39:	89 f7                	mov    %esi,%edi
  800c3b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	7f 08                	jg     800c49 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c49:	83 ec 0c             	sub    $0xc,%esp
  800c4c:	50                   	push   %eax
  800c4d:	6a 04                	push   $0x4
  800c4f:	68 ff 26 80 00       	push   $0x8026ff
  800c54:	6a 23                	push   $0x23
  800c56:	68 1c 27 80 00       	push   $0x80271c
  800c5b:	e8 ca f4 ff ff       	call   80012a <_panic>

00800c60 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c77:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7f:	85 c0                	test   %eax,%eax
  800c81:	7f 08                	jg     800c8b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8b:	83 ec 0c             	sub    $0xc,%esp
  800c8e:	50                   	push   %eax
  800c8f:	6a 05                	push   $0x5
  800c91:	68 ff 26 80 00       	push   $0x8026ff
  800c96:	6a 23                	push   $0x23
  800c98:	68 1c 27 80 00       	push   $0x80271c
  800c9d:	e8 88 f4 ff ff       	call   80012a <_panic>

00800ca2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbb:	89 df                	mov    %ebx,%edi
  800cbd:	89 de                	mov    %ebx,%esi
  800cbf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc1:	85 c0                	test   %eax,%eax
  800cc3:	7f 08                	jg     800ccd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	83 ec 0c             	sub    $0xc,%esp
  800cd0:	50                   	push   %eax
  800cd1:	6a 06                	push   $0x6
  800cd3:	68 ff 26 80 00       	push   $0x8026ff
  800cd8:	6a 23                	push   $0x23
  800cda:	68 1c 27 80 00       	push   $0x80271c
  800cdf:	e8 46 f4 ff ff       	call   80012a <_panic>

00800ce4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ced:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfd:	89 df                	mov    %ebx,%edi
  800cff:	89 de                	mov    %ebx,%esi
  800d01:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7f 08                	jg     800d0f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	50                   	push   %eax
  800d13:	6a 08                	push   $0x8
  800d15:	68 ff 26 80 00       	push   $0x8026ff
  800d1a:	6a 23                	push   $0x23
  800d1c:	68 1c 27 80 00       	push   $0x80271c
  800d21:	e8 04 f4 ff ff       	call   80012a <_panic>

00800d26 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
  800d2c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d3f:	89 df                	mov    %ebx,%edi
  800d41:	89 de                	mov    %ebx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 09                	push   $0x9
  800d57:	68 ff 26 80 00       	push   $0x8026ff
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 1c 27 80 00       	push   $0x80271c
  800d63:	e8 c2 f3 ff ff       	call   80012a <_panic>

00800d68 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d81:	89 df                	mov    %ebx,%edi
  800d83:	89 de                	mov    %ebx,%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 0a                	push   $0xa
  800d99:	68 ff 26 80 00       	push   $0x8026ff
  800d9e:	6a 23                	push   $0x23
  800da0:	68 1c 27 80 00       	push   $0x80271c
  800da5:	e8 80 f3 ff ff       	call   80012a <_panic>

00800daa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbb:	be 00 00 00 00       	mov    $0x0,%esi
  800dc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5f                   	pop    %edi
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de3:	89 cb                	mov    %ecx,%ebx
  800de5:	89 cf                	mov    %ecx,%edi
  800de7:	89 ce                	mov    %ecx,%esi
  800de9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 0d                	push   $0xd
  800dfd:	68 ff 26 80 00       	push   $0x8026ff
  800e02:	6a 23                	push   $0x23
  800e04:	68 1c 27 80 00       	push   $0x80271c
  800e09:	e8 1c f3 ff ff       	call   80012a <_panic>

00800e0e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e14:	ba 00 00 00 00       	mov    $0x0,%edx
  800e19:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e1e:	89 d1                	mov    %edx,%ecx
  800e20:	89 d3                	mov    %edx,%ebx
  800e22:	89 d7                	mov    %edx,%edi
  800e24:	89 d6                	mov    %edx,%esi
  800e26:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  800e33:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800e3a:	74 0a                	je     800e46 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  800e46:	a1 08 40 80 00       	mov    0x804008,%eax
  800e4b:	8b 40 48             	mov    0x48(%eax),%eax
  800e4e:	83 ec 04             	sub    $0x4,%esp
  800e51:	6a 07                	push   $0x7
  800e53:	68 00 f0 bf ee       	push   $0xeebff000
  800e58:	50                   	push   %eax
  800e59:	e8 bf fd ff ff       	call   800c1d <sys_page_alloc>
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	85 c0                	test   %eax,%eax
  800e63:	78 1b                	js     800e80 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800e65:	a1 08 40 80 00       	mov    0x804008,%eax
  800e6a:	8b 40 48             	mov    0x48(%eax),%eax
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	68 92 0e 80 00       	push   $0x800e92
  800e75:	50                   	push   %eax
  800e76:	e8 ed fe ff ff       	call   800d68 <sys_env_set_pgfault_upcall>
  800e7b:	83 c4 10             	add    $0x10,%esp
  800e7e:	eb bc                	jmp    800e3c <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  800e80:	50                   	push   %eax
  800e81:	68 2a 27 80 00       	push   $0x80272a
  800e86:	6a 22                	push   $0x22
  800e88:	68 42 27 80 00       	push   $0x802742
  800e8d:	e8 98 f2 ff ff       	call   80012a <_panic>

00800e92 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e92:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e93:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e98:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e9a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  800e9d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  800ea1:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  800ea4:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  800ea8:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  800eac:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  800eae:	83 c4 08             	add    $0x8,%esp
	popal
  800eb1:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800eb2:	83 c4 04             	add    $0x4,%esp
	popfl
  800eb5:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800eb6:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800eb7:	c3                   	ret    

00800eb8 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	05 00 00 00 30       	add    $0x30000000,%eax
  800ec3:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    

00800ec8 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ec8:	55                   	push   %ebp
  800ec9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ed3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed8:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    

00800edf <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ee5:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800eea:	89 c2                	mov    %eax,%edx
  800eec:	c1 ea 16             	shr    $0x16,%edx
  800eef:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef6:	f6 c2 01             	test   $0x1,%dl
  800ef9:	74 2a                	je     800f25 <fd_alloc+0x46>
  800efb:	89 c2                	mov    %eax,%edx
  800efd:	c1 ea 0c             	shr    $0xc,%edx
  800f00:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f07:	f6 c2 01             	test   $0x1,%dl
  800f0a:	74 19                	je     800f25 <fd_alloc+0x46>
  800f0c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f11:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f16:	75 d2                	jne    800eea <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f18:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f1e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f23:	eb 07                	jmp    800f2c <fd_alloc+0x4d>
			*fd_store = fd;
  800f25:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f34:	83 f8 1f             	cmp    $0x1f,%eax
  800f37:	77 36                	ja     800f6f <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f39:	c1 e0 0c             	shl    $0xc,%eax
  800f3c:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f41:	89 c2                	mov    %eax,%edx
  800f43:	c1 ea 16             	shr    $0x16,%edx
  800f46:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f4d:	f6 c2 01             	test   $0x1,%dl
  800f50:	74 24                	je     800f76 <fd_lookup+0x48>
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	c1 ea 0c             	shr    $0xc,%edx
  800f57:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f5e:	f6 c2 01             	test   $0x1,%dl
  800f61:	74 1a                	je     800f7d <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f66:	89 02                	mov    %eax,(%edx)
	return 0;
  800f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    
		return -E_INVAL;
  800f6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f74:	eb f7                	jmp    800f6d <fd_lookup+0x3f>
		return -E_INVAL;
  800f76:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7b:	eb f0                	jmp    800f6d <fd_lookup+0x3f>
  800f7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f82:	eb e9                	jmp    800f6d <fd_lookup+0x3f>

00800f84 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 08             	sub    $0x8,%esp
  800f8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f8d:	ba d0 27 80 00       	mov    $0x8027d0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f92:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f97:	39 08                	cmp    %ecx,(%eax)
  800f99:	74 33                	je     800fce <dev_lookup+0x4a>
  800f9b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f9e:	8b 02                	mov    (%edx),%eax
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 f3                	jne    800f97 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fa4:	a1 08 40 80 00       	mov    0x804008,%eax
  800fa9:	8b 40 48             	mov    0x48(%eax),%eax
  800fac:	83 ec 04             	sub    $0x4,%esp
  800faf:	51                   	push   %ecx
  800fb0:	50                   	push   %eax
  800fb1:	68 50 27 80 00       	push   $0x802750
  800fb6:	e8 4a f2 ff ff       	call   800205 <cprintf>
	*dev = 0;
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    
			*dev = devtab[i];
  800fce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd1:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd8:	eb f2                	jmp    800fcc <dev_lookup+0x48>

00800fda <fd_close>:
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	83 ec 1c             	sub    $0x1c,%esp
  800fe3:	8b 75 08             	mov    0x8(%ebp),%esi
  800fe6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fe9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fec:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fed:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ff3:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ff6:	50                   	push   %eax
  800ff7:	e8 32 ff ff ff       	call   800f2e <fd_lookup>
  800ffc:	89 c3                	mov    %eax,%ebx
  800ffe:	83 c4 08             	add    $0x8,%esp
  801001:	85 c0                	test   %eax,%eax
  801003:	78 05                	js     80100a <fd_close+0x30>
	    || fd != fd2)
  801005:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801008:	74 16                	je     801020 <fd_close+0x46>
		return (must_exist ? r : 0);
  80100a:	89 f8                	mov    %edi,%eax
  80100c:	84 c0                	test   %al,%al
  80100e:	b8 00 00 00 00       	mov    $0x0,%eax
  801013:	0f 44 d8             	cmove  %eax,%ebx
}
  801016:	89 d8                	mov    %ebx,%eax
  801018:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801020:	83 ec 08             	sub    $0x8,%esp
  801023:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801026:	50                   	push   %eax
  801027:	ff 36                	pushl  (%esi)
  801029:	e8 56 ff ff ff       	call   800f84 <dev_lookup>
  80102e:	89 c3                	mov    %eax,%ebx
  801030:	83 c4 10             	add    $0x10,%esp
  801033:	85 c0                	test   %eax,%eax
  801035:	78 15                	js     80104c <fd_close+0x72>
		if (dev->dev_close)
  801037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80103a:	8b 40 10             	mov    0x10(%eax),%eax
  80103d:	85 c0                	test   %eax,%eax
  80103f:	74 1b                	je     80105c <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801041:	83 ec 0c             	sub    $0xc,%esp
  801044:	56                   	push   %esi
  801045:	ff d0                	call   *%eax
  801047:	89 c3                	mov    %eax,%ebx
  801049:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	56                   	push   %esi
  801050:	6a 00                	push   $0x0
  801052:	e8 4b fc ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	eb ba                	jmp    801016 <fd_close+0x3c>
			r = 0;
  80105c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801061:	eb e9                	jmp    80104c <fd_close+0x72>

00801063 <close>:

int
close(int fdnum)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801069:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80106c:	50                   	push   %eax
  80106d:	ff 75 08             	pushl  0x8(%ebp)
  801070:	e8 b9 fe ff ff       	call   800f2e <fd_lookup>
  801075:	83 c4 08             	add    $0x8,%esp
  801078:	85 c0                	test   %eax,%eax
  80107a:	78 10                	js     80108c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80107c:	83 ec 08             	sub    $0x8,%esp
  80107f:	6a 01                	push   $0x1
  801081:	ff 75 f4             	pushl  -0xc(%ebp)
  801084:	e8 51 ff ff ff       	call   800fda <fd_close>
  801089:	83 c4 10             	add    $0x10,%esp
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <close_all>:

void
close_all(void)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	53                   	push   %ebx
  801092:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801095:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	53                   	push   %ebx
  80109e:	e8 c0 ff ff ff       	call   801063 <close>
	for (i = 0; i < MAXFD; i++)
  8010a3:	83 c3 01             	add    $0x1,%ebx
  8010a6:	83 c4 10             	add    $0x10,%esp
  8010a9:	83 fb 20             	cmp    $0x20,%ebx
  8010ac:	75 ec                	jne    80109a <close_all+0xc>
}
  8010ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010bc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010bf:	50                   	push   %eax
  8010c0:	ff 75 08             	pushl  0x8(%ebp)
  8010c3:	e8 66 fe ff ff       	call   800f2e <fd_lookup>
  8010c8:	89 c3                	mov    %eax,%ebx
  8010ca:	83 c4 08             	add    $0x8,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	0f 88 81 00 00 00    	js     801156 <dup+0xa3>
		return r;
	close(newfdnum);
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	ff 75 0c             	pushl  0xc(%ebp)
  8010db:	e8 83 ff ff ff       	call   801063 <close>

	newfd = INDEX2FD(newfdnum);
  8010e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e3:	c1 e6 0c             	shl    $0xc,%esi
  8010e6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010ec:	83 c4 04             	add    $0x4,%esp
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	e8 d1 fd ff ff       	call   800ec8 <fd2data>
  8010f7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010f9:	89 34 24             	mov    %esi,(%esp)
  8010fc:	e8 c7 fd ff ff       	call   800ec8 <fd2data>
  801101:	83 c4 10             	add    $0x10,%esp
  801104:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801106:	89 d8                	mov    %ebx,%eax
  801108:	c1 e8 16             	shr    $0x16,%eax
  80110b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801112:	a8 01                	test   $0x1,%al
  801114:	74 11                	je     801127 <dup+0x74>
  801116:	89 d8                	mov    %ebx,%eax
  801118:	c1 e8 0c             	shr    $0xc,%eax
  80111b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801122:	f6 c2 01             	test   $0x1,%dl
  801125:	75 39                	jne    801160 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801127:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e8 0c             	shr    $0xc,%eax
  80112f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	25 07 0e 00 00       	and    $0xe07,%eax
  80113e:	50                   	push   %eax
  80113f:	56                   	push   %esi
  801140:	6a 00                	push   $0x0
  801142:	52                   	push   %edx
  801143:	6a 00                	push   $0x0
  801145:	e8 16 fb ff ff       	call   800c60 <sys_page_map>
  80114a:	89 c3                	mov    %eax,%ebx
  80114c:	83 c4 20             	add    $0x20,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	78 31                	js     801184 <dup+0xd1>
		goto err;

	return newfdnum;
  801153:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801156:	89 d8                	mov    %ebx,%eax
  801158:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80115b:	5b                   	pop    %ebx
  80115c:	5e                   	pop    %esi
  80115d:	5f                   	pop    %edi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801160:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801167:	83 ec 0c             	sub    $0xc,%esp
  80116a:	25 07 0e 00 00       	and    $0xe07,%eax
  80116f:	50                   	push   %eax
  801170:	57                   	push   %edi
  801171:	6a 00                	push   $0x0
  801173:	53                   	push   %ebx
  801174:	6a 00                	push   $0x0
  801176:	e8 e5 fa ff ff       	call   800c60 <sys_page_map>
  80117b:	89 c3                	mov    %eax,%ebx
  80117d:	83 c4 20             	add    $0x20,%esp
  801180:	85 c0                	test   %eax,%eax
  801182:	79 a3                	jns    801127 <dup+0x74>
	sys_page_unmap(0, newfd);
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	56                   	push   %esi
  801188:	6a 00                	push   $0x0
  80118a:	e8 13 fb ff ff       	call   800ca2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80118f:	83 c4 08             	add    $0x8,%esp
  801192:	57                   	push   %edi
  801193:	6a 00                	push   $0x0
  801195:	e8 08 fb ff ff       	call   800ca2 <sys_page_unmap>
	return r;
  80119a:	83 c4 10             	add    $0x10,%esp
  80119d:	eb b7                	jmp    801156 <dup+0xa3>

0080119f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 14             	sub    $0x14,%esp
  8011a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ac:	50                   	push   %eax
  8011ad:	53                   	push   %ebx
  8011ae:	e8 7b fd ff ff       	call   800f2e <fd_lookup>
  8011b3:	83 c4 08             	add    $0x8,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 3f                	js     8011f9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011ba:	83 ec 08             	sub    $0x8,%esp
  8011bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c0:	50                   	push   %eax
  8011c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c4:	ff 30                	pushl  (%eax)
  8011c6:	e8 b9 fd ff ff       	call   800f84 <dev_lookup>
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 27                	js     8011f9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d5:	8b 42 08             	mov    0x8(%edx),%eax
  8011d8:	83 e0 03             	and    $0x3,%eax
  8011db:	83 f8 01             	cmp    $0x1,%eax
  8011de:	74 1e                	je     8011fe <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e3:	8b 40 08             	mov    0x8(%eax),%eax
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	74 35                	je     80121f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011ea:	83 ec 04             	sub    $0x4,%esp
  8011ed:	ff 75 10             	pushl  0x10(%ebp)
  8011f0:	ff 75 0c             	pushl  0xc(%ebp)
  8011f3:	52                   	push   %edx
  8011f4:	ff d0                	call   *%eax
  8011f6:	83 c4 10             	add    $0x10,%esp
}
  8011f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fc:	c9                   	leave  
  8011fd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011fe:	a1 08 40 80 00       	mov    0x804008,%eax
  801203:	8b 40 48             	mov    0x48(%eax),%eax
  801206:	83 ec 04             	sub    $0x4,%esp
  801209:	53                   	push   %ebx
  80120a:	50                   	push   %eax
  80120b:	68 94 27 80 00       	push   $0x802794
  801210:	e8 f0 ef ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80121d:	eb da                	jmp    8011f9 <read+0x5a>
		return -E_NOT_SUPP;
  80121f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801224:	eb d3                	jmp    8011f9 <read+0x5a>

00801226 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
  80122c:	83 ec 0c             	sub    $0xc,%esp
  80122f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801232:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801235:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123a:	39 f3                	cmp    %esi,%ebx
  80123c:	73 25                	jae    801263 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123e:	83 ec 04             	sub    $0x4,%esp
  801241:	89 f0                	mov    %esi,%eax
  801243:	29 d8                	sub    %ebx,%eax
  801245:	50                   	push   %eax
  801246:	89 d8                	mov    %ebx,%eax
  801248:	03 45 0c             	add    0xc(%ebp),%eax
  80124b:	50                   	push   %eax
  80124c:	57                   	push   %edi
  80124d:	e8 4d ff ff ff       	call   80119f <read>
		if (m < 0)
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	78 08                	js     801261 <readn+0x3b>
			return m;
		if (m == 0)
  801259:	85 c0                	test   %eax,%eax
  80125b:	74 06                	je     801263 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80125d:	01 c3                	add    %eax,%ebx
  80125f:	eb d9                	jmp    80123a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801261:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801263:	89 d8                	mov    %ebx,%eax
  801265:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801268:	5b                   	pop    %ebx
  801269:	5e                   	pop    %esi
  80126a:	5f                   	pop    %edi
  80126b:	5d                   	pop    %ebp
  80126c:	c3                   	ret    

0080126d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80126d:	55                   	push   %ebp
  80126e:	89 e5                	mov    %esp,%ebp
  801270:	53                   	push   %ebx
  801271:	83 ec 14             	sub    $0x14,%esp
  801274:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801277:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127a:	50                   	push   %eax
  80127b:	53                   	push   %ebx
  80127c:	e8 ad fc ff ff       	call   800f2e <fd_lookup>
  801281:	83 c4 08             	add    $0x8,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	78 3a                	js     8012c2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128e:	50                   	push   %eax
  80128f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801292:	ff 30                	pushl  (%eax)
  801294:	e8 eb fc ff ff       	call   800f84 <dev_lookup>
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 22                	js     8012c2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a7:	74 1e                	je     8012c7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012ac:	8b 52 0c             	mov    0xc(%edx),%edx
  8012af:	85 d2                	test   %edx,%edx
  8012b1:	74 35                	je     8012e8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	ff 75 10             	pushl  0x10(%ebp)
  8012b9:	ff 75 0c             	pushl  0xc(%ebp)
  8012bc:	50                   	push   %eax
  8012bd:	ff d2                	call   *%edx
  8012bf:	83 c4 10             	add    $0x10,%esp
}
  8012c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8012cc:	8b 40 48             	mov    0x48(%eax),%eax
  8012cf:	83 ec 04             	sub    $0x4,%esp
  8012d2:	53                   	push   %ebx
  8012d3:	50                   	push   %eax
  8012d4:	68 b0 27 80 00       	push   $0x8027b0
  8012d9:	e8 27 ef ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  8012de:	83 c4 10             	add    $0x10,%esp
  8012e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e6:	eb da                	jmp    8012c2 <write+0x55>
		return -E_NOT_SUPP;
  8012e8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ed:	eb d3                	jmp    8012c2 <write+0x55>

008012ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	ff 75 08             	pushl  0x8(%ebp)
  8012fc:	e8 2d fc ff ff       	call   800f2e <fd_lookup>
  801301:	83 c4 08             	add    $0x8,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	78 0e                	js     801316 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801308:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80130e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801311:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801316:	c9                   	leave  
  801317:	c3                   	ret    

00801318 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 14             	sub    $0x14,%esp
  80131f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801322:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	53                   	push   %ebx
  801327:	e8 02 fc ff ff       	call   800f2e <fd_lookup>
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 37                	js     80136a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	ff 30                	pushl  (%eax)
  80133f:	e8 40 fc ff ff       	call   800f84 <dev_lookup>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 1f                	js     80136a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801352:	74 1b                	je     80136f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801354:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801357:	8b 52 18             	mov    0x18(%edx),%edx
  80135a:	85 d2                	test   %edx,%edx
  80135c:	74 32                	je     801390 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80135e:	83 ec 08             	sub    $0x8,%esp
  801361:	ff 75 0c             	pushl  0xc(%ebp)
  801364:	50                   	push   %eax
  801365:	ff d2                	call   *%edx
  801367:	83 c4 10             	add    $0x10,%esp
}
  80136a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80136f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801374:	8b 40 48             	mov    0x48(%eax),%eax
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	53                   	push   %ebx
  80137b:	50                   	push   %eax
  80137c:	68 70 27 80 00       	push   $0x802770
  801381:	e8 7f ee ff ff       	call   800205 <cprintf>
		return -E_INVAL;
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138e:	eb da                	jmp    80136a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801390:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801395:	eb d3                	jmp    80136a <ftruncate+0x52>

00801397 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	53                   	push   %ebx
  80139b:	83 ec 14             	sub    $0x14,%esp
  80139e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a4:	50                   	push   %eax
  8013a5:	ff 75 08             	pushl  0x8(%ebp)
  8013a8:	e8 81 fb ff ff       	call   800f2e <fd_lookup>
  8013ad:	83 c4 08             	add    $0x8,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 4b                	js     8013ff <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ba:	50                   	push   %eax
  8013bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013be:	ff 30                	pushl  (%eax)
  8013c0:	e8 bf fb ff ff       	call   800f84 <dev_lookup>
  8013c5:	83 c4 10             	add    $0x10,%esp
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	78 33                	js     8013ff <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013d3:	74 2f                	je     801404 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013d5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013d8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013df:	00 00 00 
	stat->st_isdir = 0;
  8013e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013e9:	00 00 00 
	stat->st_dev = dev;
  8013ec:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f2:	83 ec 08             	sub    $0x8,%esp
  8013f5:	53                   	push   %ebx
  8013f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8013f9:	ff 50 14             	call   *0x14(%eax)
  8013fc:	83 c4 10             	add    $0x10,%esp
}
  8013ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801402:	c9                   	leave  
  801403:	c3                   	ret    
		return -E_NOT_SUPP;
  801404:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801409:	eb f4                	jmp    8013ff <fstat+0x68>

0080140b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	56                   	push   %esi
  80140f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801410:	83 ec 08             	sub    $0x8,%esp
  801413:	6a 00                	push   $0x0
  801415:	ff 75 08             	pushl  0x8(%ebp)
  801418:	e8 e7 01 00 00       	call   801604 <open>
  80141d:	89 c3                	mov    %eax,%ebx
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	78 1b                	js     801441 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801426:	83 ec 08             	sub    $0x8,%esp
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	50                   	push   %eax
  80142d:	e8 65 ff ff ff       	call   801397 <fstat>
  801432:	89 c6                	mov    %eax,%esi
	close(fd);
  801434:	89 1c 24             	mov    %ebx,(%esp)
  801437:	e8 27 fc ff ff       	call   801063 <close>
	return r;
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	89 f3                	mov    %esi,%ebx
}
  801441:	89 d8                	mov    %ebx,%eax
  801443:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801446:	5b                   	pop    %ebx
  801447:	5e                   	pop    %esi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	89 c6                	mov    %eax,%esi
  801451:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801453:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80145a:	74 27                	je     801483 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80145c:	6a 07                	push   $0x7
  80145e:	68 00 50 80 00       	push   $0x805000
  801463:	56                   	push   %esi
  801464:	ff 35 00 40 80 00    	pushl  0x804000
  80146a:	e8 d0 0b 00 00       	call   80203f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80146f:	83 c4 0c             	add    $0xc,%esp
  801472:	6a 00                	push   $0x0
  801474:	53                   	push   %ebx
  801475:	6a 00                	push   $0x0
  801477:	e8 5c 0b 00 00       	call   801fd8 <ipc_recv>
}
  80147c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801483:	83 ec 0c             	sub    $0xc,%esp
  801486:	6a 01                	push   $0x1
  801488:	e8 06 0c 00 00       	call   802093 <ipc_find_env>
  80148d:	a3 00 40 80 00       	mov    %eax,0x804000
  801492:	83 c4 10             	add    $0x10,%esp
  801495:	eb c5                	jmp    80145c <fsipc+0x12>

00801497 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ab:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b5:	b8 02 00 00 00       	mov    $0x2,%eax
  8014ba:	e8 8b ff ff ff       	call   80144a <fsipc>
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <devfile_flush>:
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8014cd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d7:	b8 06 00 00 00       	mov    $0x6,%eax
  8014dc:	e8 69 ff ff ff       	call   80144a <fsipc>
}
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <devfile_stat>:
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	53                   	push   %ebx
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f3:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fd:	b8 05 00 00 00       	mov    $0x5,%eax
  801502:	e8 43 ff ff ff       	call   80144a <fsipc>
  801507:	85 c0                	test   %eax,%eax
  801509:	78 2c                	js     801537 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	68 00 50 80 00       	push   $0x805000
  801513:	53                   	push   %ebx
  801514:	e8 0b f3 ff ff       	call   800824 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801519:	a1 80 50 80 00       	mov    0x805080,%eax
  80151e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801524:	a1 84 50 80 00       	mov    0x805084,%eax
  801529:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <devfile_write>:
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	8b 45 10             	mov    0x10(%ebp),%eax
  801545:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80154a:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80154f:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801552:	8b 55 08             	mov    0x8(%ebp),%edx
  801555:	8b 52 0c             	mov    0xc(%edx),%edx
  801558:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80155e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	68 08 50 80 00       	push   $0x805008
  80156c:	e8 41 f4 ff ff       	call   8009b2 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801571:	ba 00 00 00 00       	mov    $0x0,%edx
  801576:	b8 04 00 00 00       	mov    $0x4,%eax
  80157b:	e8 ca fe ff ff       	call   80144a <fsipc>
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <devfile_read>:
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
  801587:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	8b 40 0c             	mov    0xc(%eax),%eax
  801590:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801595:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80159b:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a0:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a5:	e8 a0 fe ff ff       	call   80144a <fsipc>
  8015aa:	89 c3                	mov    %eax,%ebx
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 1f                	js     8015cf <devfile_read+0x4d>
	assert(r <= n);
  8015b0:	39 f0                	cmp    %esi,%eax
  8015b2:	77 24                	ja     8015d8 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015b4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015b9:	7f 33                	jg     8015ee <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015bb:	83 ec 04             	sub    $0x4,%esp
  8015be:	50                   	push   %eax
  8015bf:	68 00 50 80 00       	push   $0x805000
  8015c4:	ff 75 0c             	pushl  0xc(%ebp)
  8015c7:	e8 e6 f3 ff ff       	call   8009b2 <memmove>
	return r;
  8015cc:	83 c4 10             	add    $0x10,%esp
}
  8015cf:	89 d8                	mov    %ebx,%eax
  8015d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d4:	5b                   	pop    %ebx
  8015d5:	5e                   	pop    %esi
  8015d6:	5d                   	pop    %ebp
  8015d7:	c3                   	ret    
	assert(r <= n);
  8015d8:	68 e4 27 80 00       	push   $0x8027e4
  8015dd:	68 eb 27 80 00       	push   $0x8027eb
  8015e2:	6a 7b                	push   $0x7b
  8015e4:	68 00 28 80 00       	push   $0x802800
  8015e9:	e8 3c eb ff ff       	call   80012a <_panic>
	assert(r <= PGSIZE);
  8015ee:	68 0b 28 80 00       	push   $0x80280b
  8015f3:	68 eb 27 80 00       	push   $0x8027eb
  8015f8:	6a 7c                	push   $0x7c
  8015fa:	68 00 28 80 00       	push   $0x802800
  8015ff:	e8 26 eb ff ff       	call   80012a <_panic>

00801604 <open>:
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 1c             	sub    $0x1c,%esp
  80160c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80160f:	56                   	push   %esi
  801610:	e8 d8 f1 ff ff       	call   8007ed <strlen>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80161d:	7f 6c                	jg     80168b <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801625:	50                   	push   %eax
  801626:	e8 b4 f8 ff ff       	call   800edf <fd_alloc>
  80162b:	89 c3                	mov    %eax,%ebx
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 3c                	js     801670 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801634:	83 ec 08             	sub    $0x8,%esp
  801637:	56                   	push   %esi
  801638:	68 00 50 80 00       	push   $0x805000
  80163d:	e8 e2 f1 ff ff       	call   800824 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801642:	8b 45 0c             	mov    0xc(%ebp),%eax
  801645:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80164a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164d:	b8 01 00 00 00       	mov    $0x1,%eax
  801652:	e8 f3 fd ff ff       	call   80144a <fsipc>
  801657:	89 c3                	mov    %eax,%ebx
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 19                	js     801679 <open+0x75>
	return fd2num(fd);
  801660:	83 ec 0c             	sub    $0xc,%esp
  801663:	ff 75 f4             	pushl  -0xc(%ebp)
  801666:	e8 4d f8 ff ff       	call   800eb8 <fd2num>
  80166b:	89 c3                	mov    %eax,%ebx
  80166d:	83 c4 10             	add    $0x10,%esp
}
  801670:	89 d8                	mov    %ebx,%eax
  801672:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    
		fd_close(fd, 0);
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	6a 00                	push   $0x0
  80167e:	ff 75 f4             	pushl  -0xc(%ebp)
  801681:	e8 54 f9 ff ff       	call   800fda <fd_close>
		return r;
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	eb e5                	jmp    801670 <open+0x6c>
		return -E_BAD_PATH;
  80168b:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801690:	eb de                	jmp    801670 <open+0x6c>

00801692 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801698:	ba 00 00 00 00       	mov    $0x0,%edx
  80169d:	b8 08 00 00 00       	mov    $0x8,%eax
  8016a2:	e8 a3 fd ff ff       	call   80144a <fsipc>
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8016af:	68 17 28 80 00       	push   $0x802817
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	e8 68 f1 ff ff       	call   800824 <strcpy>
	return 0;
}
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <devsock_close>:
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 10             	sub    $0x10,%esp
  8016ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016cd:	53                   	push   %ebx
  8016ce:	e8 f9 09 00 00       	call   8020cc <pageref>
  8016d3:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016d6:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8016db:	83 f8 01             	cmp    $0x1,%eax
  8016de:	74 07                	je     8016e7 <devsock_close+0x24>
}
  8016e0:	89 d0                	mov    %edx,%eax
  8016e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	ff 73 0c             	pushl  0xc(%ebx)
  8016ed:	e8 b7 02 00 00       	call   8019a9 <nsipc_close>
  8016f2:	89 c2                	mov    %eax,%edx
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	eb e7                	jmp    8016e0 <devsock_close+0x1d>

008016f9 <devsock_write>:
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8016ff:	6a 00                	push   $0x0
  801701:	ff 75 10             	pushl  0x10(%ebp)
  801704:	ff 75 0c             	pushl  0xc(%ebp)
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	ff 70 0c             	pushl  0xc(%eax)
  80170d:	e8 74 03 00 00       	call   801a86 <nsipc_send>
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <devsock_read>:
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80171a:	6a 00                	push   $0x0
  80171c:	ff 75 10             	pushl  0x10(%ebp)
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	ff 70 0c             	pushl  0xc(%eax)
  801728:	e8 ed 02 00 00       	call   801a1a <nsipc_recv>
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <fd2sockid>:
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801735:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801738:	52                   	push   %edx
  801739:	50                   	push   %eax
  80173a:	e8 ef f7 ff ff       	call   800f2e <fd_lookup>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	85 c0                	test   %eax,%eax
  801744:	78 10                	js     801756 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801749:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80174f:	39 08                	cmp    %ecx,(%eax)
  801751:	75 05                	jne    801758 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801753:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    
		return -E_NOT_SUPP;
  801758:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80175d:	eb f7                	jmp    801756 <fd2sockid+0x27>

0080175f <alloc_sockfd>:
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	83 ec 1c             	sub    $0x1c,%esp
  801767:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801769:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176c:	50                   	push   %eax
  80176d:	e8 6d f7 ff ff       	call   800edf <fd_alloc>
  801772:	89 c3                	mov    %eax,%ebx
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	85 c0                	test   %eax,%eax
  801779:	78 43                	js     8017be <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	68 07 04 00 00       	push   $0x407
  801783:	ff 75 f4             	pushl  -0xc(%ebp)
  801786:	6a 00                	push   $0x0
  801788:	e8 90 f4 ff ff       	call   800c1d <sys_page_alloc>
  80178d:	89 c3                	mov    %eax,%ebx
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	85 c0                	test   %eax,%eax
  801794:	78 28                	js     8017be <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80179f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8017a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8017ab:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8017ae:	83 ec 0c             	sub    $0xc,%esp
  8017b1:	50                   	push   %eax
  8017b2:	e8 01 f7 ff ff       	call   800eb8 <fd2num>
  8017b7:	89 c3                	mov    %eax,%ebx
  8017b9:	83 c4 10             	add    $0x10,%esp
  8017bc:	eb 0c                	jmp    8017ca <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	56                   	push   %esi
  8017c2:	e8 e2 01 00 00       	call   8019a9 <nsipc_close>
		return r;
  8017c7:	83 c4 10             	add    $0x10,%esp
}
  8017ca:	89 d8                	mov    %ebx,%eax
  8017cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <accept>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	e8 4e ff ff ff       	call   80172f <fd2sockid>
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	78 1b                	js     801800 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	ff 75 10             	pushl  0x10(%ebp)
  8017eb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ee:	50                   	push   %eax
  8017ef:	e8 0e 01 00 00       	call   801902 <nsipc_accept>
  8017f4:	83 c4 10             	add    $0x10,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 05                	js     801800 <accept+0x2d>
	return alloc_sockfd(r);
  8017fb:	e8 5f ff ff ff       	call   80175f <alloc_sockfd>
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <bind>:
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	e8 1f ff ff ff       	call   80172f <fd2sockid>
  801810:	85 c0                	test   %eax,%eax
  801812:	78 12                	js     801826 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	ff 75 10             	pushl  0x10(%ebp)
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	50                   	push   %eax
  80181e:	e8 2f 01 00 00       	call   801952 <nsipc_bind>
  801823:	83 c4 10             	add    $0x10,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <shutdown>:
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	e8 f9 fe ff ff       	call   80172f <fd2sockid>
  801836:	85 c0                	test   %eax,%eax
  801838:	78 0f                	js     801849 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	50                   	push   %eax
  801841:	e8 41 01 00 00       	call   801987 <nsipc_shutdown>
  801846:	83 c4 10             	add    $0x10,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <connect>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	e8 d6 fe ff ff       	call   80172f <fd2sockid>
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 12                	js     80186f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80185d:	83 ec 04             	sub    $0x4,%esp
  801860:	ff 75 10             	pushl  0x10(%ebp)
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	50                   	push   %eax
  801867:	e8 57 01 00 00       	call   8019c3 <nsipc_connect>
  80186c:	83 c4 10             	add    $0x10,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <listen>:
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	e8 b0 fe ff ff       	call   80172f <fd2sockid>
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 0f                	js     801892 <listen+0x21>
	return nsipc_listen(r, backlog);
  801883:	83 ec 08             	sub    $0x8,%esp
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	50                   	push   %eax
  80188a:	e8 69 01 00 00       	call   8019f8 <nsipc_listen>
  80188f:	83 c4 10             	add    $0x10,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <socket>:

int
socket(int domain, int type, int protocol)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80189a:	ff 75 10             	pushl  0x10(%ebp)
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	e8 3c 02 00 00       	call   801ae4 <nsipc_socket>
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 05                	js     8018b4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8018af:	e8 ab fe ff ff       	call   80175f <alloc_sockfd>
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018bf:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8018c6:	74 26                	je     8018ee <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8018c8:	6a 07                	push   $0x7
  8018ca:	68 00 60 80 00       	push   $0x806000
  8018cf:	53                   	push   %ebx
  8018d0:	ff 35 04 40 80 00    	pushl  0x804004
  8018d6:	e8 64 07 00 00       	call   80203f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8018db:	83 c4 0c             	add    $0xc,%esp
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	e8 ef 06 00 00       	call   801fd8 <ipc_recv>
}
  8018e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	6a 02                	push   $0x2
  8018f3:	e8 9b 07 00 00       	call   802093 <ipc_find_env>
  8018f8:	a3 04 40 80 00       	mov    %eax,0x804004
  8018fd:	83 c4 10             	add    $0x10,%esp
  801900:	eb c6                	jmp    8018c8 <nsipc+0x12>

00801902 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	56                   	push   %esi
  801906:	53                   	push   %ebx
  801907:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801912:	8b 06                	mov    (%esi),%eax
  801914:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801919:	b8 01 00 00 00       	mov    $0x1,%eax
  80191e:	e8 93 ff ff ff       	call   8018b6 <nsipc>
  801923:	89 c3                	mov    %eax,%ebx
  801925:	85 c0                	test   %eax,%eax
  801927:	78 20                	js     801949 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	ff 35 10 60 80 00    	pushl  0x806010
  801932:	68 00 60 80 00       	push   $0x806000
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 73 f0 ff ff       	call   8009b2 <memmove>
		*addrlen = ret->ret_addrlen;
  80193f:	a1 10 60 80 00       	mov    0x806010,%eax
  801944:	89 06                	mov    %eax,(%esi)
  801946:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801949:	89 d8                	mov    %ebx,%eax
  80194b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80194e:	5b                   	pop    %ebx
  80194f:	5e                   	pop    %esi
  801950:	5d                   	pop    %ebp
  801951:	c3                   	ret    

00801952 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	53                   	push   %ebx
  801956:	83 ec 08             	sub    $0x8,%esp
  801959:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801964:	53                   	push   %ebx
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	68 04 60 80 00       	push   $0x806004
  80196d:	e8 40 f0 ff ff       	call   8009b2 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801972:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801978:	b8 02 00 00 00       	mov    $0x2,%eax
  80197d:	e8 34 ff ff ff       	call   8018b6 <nsipc>
}
  801982:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801995:	8b 45 0c             	mov    0xc(%ebp),%eax
  801998:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80199d:	b8 03 00 00 00       	mov    $0x3,%eax
  8019a2:	e8 0f ff ff ff       	call   8018b6 <nsipc>
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <nsipc_close>:

int
nsipc_close(int s)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8019b7:	b8 04 00 00 00       	mov    $0x4,%eax
  8019bc:	e8 f5 fe ff ff       	call   8018b6 <nsipc>
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 08             	sub    $0x8,%esp
  8019ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019d5:	53                   	push   %ebx
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	68 04 60 80 00       	push   $0x806004
  8019de:	e8 cf ef ff ff       	call   8009b2 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019e3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019e9:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ee:	e8 c3 fe ff ff       	call   8018b6 <nsipc>
}
  8019f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a0e:	b8 06 00 00 00       	mov    $0x6,%eax
  801a13:	e8 9e fe ff ff       	call   8018b6 <nsipc>
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	56                   	push   %esi
  801a1e:	53                   	push   %ebx
  801a1f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a2a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a30:	8b 45 14             	mov    0x14(%ebp),%eax
  801a33:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a38:	b8 07 00 00 00       	mov    $0x7,%eax
  801a3d:	e8 74 fe ff ff       	call   8018b6 <nsipc>
  801a42:	89 c3                	mov    %eax,%ebx
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 1f                	js     801a67 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801a48:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801a4d:	7f 21                	jg     801a70 <nsipc_recv+0x56>
  801a4f:	39 c6                	cmp    %eax,%esi
  801a51:	7c 1d                	jl     801a70 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	50                   	push   %eax
  801a57:	68 00 60 80 00       	push   $0x806000
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	e8 4e ef ff ff       	call   8009b2 <memmove>
  801a64:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a67:	89 d8                	mov    %ebx,%eax
  801a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6c:	5b                   	pop    %ebx
  801a6d:	5e                   	pop    %esi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a70:	68 23 28 80 00       	push   $0x802823
  801a75:	68 eb 27 80 00       	push   $0x8027eb
  801a7a:	6a 62                	push   $0x62
  801a7c:	68 38 28 80 00       	push   $0x802838
  801a81:	e8 a4 e6 ff ff       	call   80012a <_panic>

00801a86 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a98:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a9e:	7f 2e                	jg     801ace <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	53                   	push   %ebx
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	68 0c 60 80 00       	push   $0x80600c
  801aac:	e8 01 ef ff ff       	call   8009b2 <memmove>
	nsipcbuf.send.req_size = size;
  801ab1:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aba:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801abf:	b8 08 00 00 00       	mov    $0x8,%eax
  801ac4:	e8 ed fd ff ff       	call   8018b6 <nsipc>
}
  801ac9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    
	assert(size < 1600);
  801ace:	68 44 28 80 00       	push   $0x802844
  801ad3:	68 eb 27 80 00       	push   $0x8027eb
  801ad8:	6a 6d                	push   $0x6d
  801ada:	68 38 28 80 00       	push   $0x802838
  801adf:	e8 46 e6 ff ff       	call   80012a <_panic>

00801ae4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801b02:	b8 09 00 00 00       	mov    $0x9,%eax
  801b07:	e8 aa fd ff ff       	call   8018b6 <nsipc>
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	56                   	push   %esi
  801b12:	53                   	push   %ebx
  801b13:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b16:	83 ec 0c             	sub    $0xc,%esp
  801b19:	ff 75 08             	pushl  0x8(%ebp)
  801b1c:	e8 a7 f3 ff ff       	call   800ec8 <fd2data>
  801b21:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b23:	83 c4 08             	add    $0x8,%esp
  801b26:	68 50 28 80 00       	push   $0x802850
  801b2b:	53                   	push   %ebx
  801b2c:	e8 f3 ec ff ff       	call   800824 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b31:	8b 46 04             	mov    0x4(%esi),%eax
  801b34:	2b 06                	sub    (%esi),%eax
  801b36:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b3c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b43:	00 00 00 
	stat->st_dev = &devpipe;
  801b46:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b4d:	30 80 00 
	return 0;
}
  801b50:	b8 00 00 00 00       	mov    $0x0,%eax
  801b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5e                   	pop    %esi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    

00801b5c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 0c             	sub    $0xc,%esp
  801b63:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b66:	53                   	push   %ebx
  801b67:	6a 00                	push   $0x0
  801b69:	e8 34 f1 ff ff       	call   800ca2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b6e:	89 1c 24             	mov    %ebx,(%esp)
  801b71:	e8 52 f3 ff ff       	call   800ec8 <fd2data>
  801b76:	83 c4 08             	add    $0x8,%esp
  801b79:	50                   	push   %eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	e8 21 f1 ff ff       	call   800ca2 <sys_page_unmap>
}
  801b81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <_pipeisclosed>:
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	57                   	push   %edi
  801b8a:	56                   	push   %esi
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 1c             	sub    $0x1c,%esp
  801b8f:	89 c7                	mov    %eax,%edi
  801b91:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b93:	a1 08 40 80 00       	mov    0x804008,%eax
  801b98:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b9b:	83 ec 0c             	sub    $0xc,%esp
  801b9e:	57                   	push   %edi
  801b9f:	e8 28 05 00 00       	call   8020cc <pageref>
  801ba4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba7:	89 34 24             	mov    %esi,(%esp)
  801baa:	e8 1d 05 00 00       	call   8020cc <pageref>
		nn = thisenv->env_runs;
  801baf:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801bb5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	39 cb                	cmp    %ecx,%ebx
  801bbd:	74 1b                	je     801bda <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bbf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc2:	75 cf                	jne    801b93 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bc4:	8b 42 58             	mov    0x58(%edx),%eax
  801bc7:	6a 01                	push   $0x1
  801bc9:	50                   	push   %eax
  801bca:	53                   	push   %ebx
  801bcb:	68 57 28 80 00       	push   $0x802857
  801bd0:	e8 30 e6 ff ff       	call   800205 <cprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	eb b9                	jmp    801b93 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bda:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bdd:	0f 94 c0             	sete   %al
  801be0:	0f b6 c0             	movzbl %al,%eax
}
  801be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be6:	5b                   	pop    %ebx
  801be7:	5e                   	pop    %esi
  801be8:	5f                   	pop    %edi
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    

00801beb <devpipe_write>:
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	57                   	push   %edi
  801bef:	56                   	push   %esi
  801bf0:	53                   	push   %ebx
  801bf1:	83 ec 28             	sub    $0x28,%esp
  801bf4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bf7:	56                   	push   %esi
  801bf8:	e8 cb f2 ff ff       	call   800ec8 <fd2data>
  801bfd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	bf 00 00 00 00       	mov    $0x0,%edi
  801c07:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c0a:	74 4f                	je     801c5b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c0c:	8b 43 04             	mov    0x4(%ebx),%eax
  801c0f:	8b 0b                	mov    (%ebx),%ecx
  801c11:	8d 51 20             	lea    0x20(%ecx),%edx
  801c14:	39 d0                	cmp    %edx,%eax
  801c16:	72 14                	jb     801c2c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c18:	89 da                	mov    %ebx,%edx
  801c1a:	89 f0                	mov    %esi,%eax
  801c1c:	e8 65 ff ff ff       	call   801b86 <_pipeisclosed>
  801c21:	85 c0                	test   %eax,%eax
  801c23:	75 3a                	jne    801c5f <devpipe_write+0x74>
			sys_yield();
  801c25:	e8 d4 ef ff ff       	call   800bfe <sys_yield>
  801c2a:	eb e0                	jmp    801c0c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c2f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c33:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c36:	89 c2                	mov    %eax,%edx
  801c38:	c1 fa 1f             	sar    $0x1f,%edx
  801c3b:	89 d1                	mov    %edx,%ecx
  801c3d:	c1 e9 1b             	shr    $0x1b,%ecx
  801c40:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c43:	83 e2 1f             	and    $0x1f,%edx
  801c46:	29 ca                	sub    %ecx,%edx
  801c48:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c4c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c50:	83 c0 01             	add    $0x1,%eax
  801c53:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c56:	83 c7 01             	add    $0x1,%edi
  801c59:	eb ac                	jmp    801c07 <devpipe_write+0x1c>
	return i;
  801c5b:	89 f8                	mov    %edi,%eax
  801c5d:	eb 05                	jmp    801c64 <devpipe_write+0x79>
				return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c67:	5b                   	pop    %ebx
  801c68:	5e                   	pop    %esi
  801c69:	5f                   	pop    %edi
  801c6a:	5d                   	pop    %ebp
  801c6b:	c3                   	ret    

00801c6c <devpipe_read>:
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	57                   	push   %edi
  801c70:	56                   	push   %esi
  801c71:	53                   	push   %ebx
  801c72:	83 ec 18             	sub    $0x18,%esp
  801c75:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c78:	57                   	push   %edi
  801c79:	e8 4a f2 ff ff       	call   800ec8 <fd2data>
  801c7e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	be 00 00 00 00       	mov    $0x0,%esi
  801c88:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c8b:	74 47                	je     801cd4 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c8d:	8b 03                	mov    (%ebx),%eax
  801c8f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c92:	75 22                	jne    801cb6 <devpipe_read+0x4a>
			if (i > 0)
  801c94:	85 f6                	test   %esi,%esi
  801c96:	75 14                	jne    801cac <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c98:	89 da                	mov    %ebx,%edx
  801c9a:	89 f8                	mov    %edi,%eax
  801c9c:	e8 e5 fe ff ff       	call   801b86 <_pipeisclosed>
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	75 33                	jne    801cd8 <devpipe_read+0x6c>
			sys_yield();
  801ca5:	e8 54 ef ff ff       	call   800bfe <sys_yield>
  801caa:	eb e1                	jmp    801c8d <devpipe_read+0x21>
				return i;
  801cac:	89 f0                	mov    %esi,%eax
}
  801cae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cb1:	5b                   	pop    %ebx
  801cb2:	5e                   	pop    %esi
  801cb3:	5f                   	pop    %edi
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb6:	99                   	cltd   
  801cb7:	c1 ea 1b             	shr    $0x1b,%edx
  801cba:	01 d0                	add    %edx,%eax
  801cbc:	83 e0 1f             	and    $0x1f,%eax
  801cbf:	29 d0                	sub    %edx,%eax
  801cc1:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc9:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ccc:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ccf:	83 c6 01             	add    $0x1,%esi
  801cd2:	eb b4                	jmp    801c88 <devpipe_read+0x1c>
	return i;
  801cd4:	89 f0                	mov    %esi,%eax
  801cd6:	eb d6                	jmp    801cae <devpipe_read+0x42>
				return 0;
  801cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdd:	eb cf                	jmp    801cae <devpipe_read+0x42>

00801cdf <pipe>:
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	56                   	push   %esi
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ce7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cea:	50                   	push   %eax
  801ceb:	e8 ef f1 ff ff       	call   800edf <fd_alloc>
  801cf0:	89 c3                	mov    %eax,%ebx
  801cf2:	83 c4 10             	add    $0x10,%esp
  801cf5:	85 c0                	test   %eax,%eax
  801cf7:	78 5b                	js     801d54 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	68 07 04 00 00       	push   $0x407
  801d01:	ff 75 f4             	pushl  -0xc(%ebp)
  801d04:	6a 00                	push   $0x0
  801d06:	e8 12 ef ff ff       	call   800c1d <sys_page_alloc>
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	85 c0                	test   %eax,%eax
  801d12:	78 40                	js     801d54 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	e8 bf f1 ff ff       	call   800edf <fd_alloc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	83 c4 10             	add    $0x10,%esp
  801d25:	85 c0                	test   %eax,%eax
  801d27:	78 1b                	js     801d44 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	68 07 04 00 00       	push   $0x407
  801d31:	ff 75 f0             	pushl  -0x10(%ebp)
  801d34:	6a 00                	push   $0x0
  801d36:	e8 e2 ee ff ff       	call   800c1d <sys_page_alloc>
  801d3b:	89 c3                	mov    %eax,%ebx
  801d3d:	83 c4 10             	add    $0x10,%esp
  801d40:	85 c0                	test   %eax,%eax
  801d42:	79 19                	jns    801d5d <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d44:	83 ec 08             	sub    $0x8,%esp
  801d47:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4a:	6a 00                	push   $0x0
  801d4c:	e8 51 ef ff ff       	call   800ca2 <sys_page_unmap>
  801d51:	83 c4 10             	add    $0x10,%esp
}
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d59:	5b                   	pop    %ebx
  801d5a:	5e                   	pop    %esi
  801d5b:	5d                   	pop    %ebp
  801d5c:	c3                   	ret    
	va = fd2data(fd0);
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	ff 75 f4             	pushl  -0xc(%ebp)
  801d63:	e8 60 f1 ff ff       	call   800ec8 <fd2data>
  801d68:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d6a:	83 c4 0c             	add    $0xc,%esp
  801d6d:	68 07 04 00 00       	push   $0x407
  801d72:	50                   	push   %eax
  801d73:	6a 00                	push   $0x0
  801d75:	e8 a3 ee ff ff       	call   800c1d <sys_page_alloc>
  801d7a:	89 c3                	mov    %eax,%ebx
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	0f 88 8c 00 00 00    	js     801e13 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d87:	83 ec 0c             	sub    $0xc,%esp
  801d8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d8d:	e8 36 f1 ff ff       	call   800ec8 <fd2data>
  801d92:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d99:	50                   	push   %eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	56                   	push   %esi
  801d9d:	6a 00                	push   $0x0
  801d9f:	e8 bc ee ff ff       	call   800c60 <sys_page_map>
  801da4:	89 c3                	mov    %eax,%ebx
  801da6:	83 c4 20             	add    $0x20,%esp
  801da9:	85 c0                	test   %eax,%eax
  801dab:	78 58                	js     801e05 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801db6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dcb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddd:	e8 d6 f0 ff ff       	call   800eb8 <fd2num>
  801de2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801de7:	83 c4 04             	add    $0x4,%esp
  801dea:	ff 75 f0             	pushl  -0x10(%ebp)
  801ded:	e8 c6 f0 ff ff       	call   800eb8 <fd2num>
  801df2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801df5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e00:	e9 4f ff ff ff       	jmp    801d54 <pipe+0x75>
	sys_page_unmap(0, va);
  801e05:	83 ec 08             	sub    $0x8,%esp
  801e08:	56                   	push   %esi
  801e09:	6a 00                	push   $0x0
  801e0b:	e8 92 ee ff ff       	call   800ca2 <sys_page_unmap>
  801e10:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e13:	83 ec 08             	sub    $0x8,%esp
  801e16:	ff 75 f0             	pushl  -0x10(%ebp)
  801e19:	6a 00                	push   $0x0
  801e1b:	e8 82 ee ff ff       	call   800ca2 <sys_page_unmap>
  801e20:	83 c4 10             	add    $0x10,%esp
  801e23:	e9 1c ff ff ff       	jmp    801d44 <pipe+0x65>

00801e28 <pipeisclosed>:
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e31:	50                   	push   %eax
  801e32:	ff 75 08             	pushl  0x8(%ebp)
  801e35:	e8 f4 f0 ff ff       	call   800f2e <fd_lookup>
  801e3a:	83 c4 10             	add    $0x10,%esp
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	78 18                	js     801e59 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	ff 75 f4             	pushl  -0xc(%ebp)
  801e47:	e8 7c f0 ff ff       	call   800ec8 <fd2data>
	return _pipeisclosed(fd, p);
  801e4c:	89 c2                	mov    %eax,%edx
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	e8 30 fd ff ff       	call   801b86 <_pipeisclosed>
  801e56:	83 c4 10             	add    $0x10,%esp
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	5d                   	pop    %ebp
  801e64:	c3                   	ret    

00801e65 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e6b:	68 6f 28 80 00       	push   $0x80286f
  801e70:	ff 75 0c             	pushl  0xc(%ebp)
  801e73:	e8 ac e9 ff ff       	call   800824 <strcpy>
	return 0;
}
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <devcons_write>:
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	57                   	push   %edi
  801e83:	56                   	push   %esi
  801e84:	53                   	push   %ebx
  801e85:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e8b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e90:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e96:	eb 2f                	jmp    801ec7 <devcons_write+0x48>
		m = n - tot;
  801e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e9b:	29 f3                	sub    %esi,%ebx
  801e9d:	83 fb 7f             	cmp    $0x7f,%ebx
  801ea0:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801ea5:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	53                   	push   %ebx
  801eac:	89 f0                	mov    %esi,%eax
  801eae:	03 45 0c             	add    0xc(%ebp),%eax
  801eb1:	50                   	push   %eax
  801eb2:	57                   	push   %edi
  801eb3:	e8 fa ea ff ff       	call   8009b2 <memmove>
		sys_cputs(buf, m);
  801eb8:	83 c4 08             	add    $0x8,%esp
  801ebb:	53                   	push   %ebx
  801ebc:	57                   	push   %edi
  801ebd:	e8 9f ec ff ff       	call   800b61 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ec2:	01 de                	add    %ebx,%esi
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eca:	72 cc                	jb     801e98 <devcons_write+0x19>
}
  801ecc:	89 f0                	mov    %esi,%eax
  801ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ed1:	5b                   	pop    %ebx
  801ed2:	5e                   	pop    %esi
  801ed3:	5f                   	pop    %edi
  801ed4:	5d                   	pop    %ebp
  801ed5:	c3                   	ret    

00801ed6 <devcons_read>:
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ee1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ee5:	75 07                	jne    801eee <devcons_read+0x18>
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    
		sys_yield();
  801ee9:	e8 10 ed ff ff       	call   800bfe <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801eee:	e8 8c ec ff ff       	call   800b7f <sys_cgetc>
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	74 f2                	je     801ee9 <devcons_read+0x13>
	if (c < 0)
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 ec                	js     801ee7 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801efb:	83 f8 04             	cmp    $0x4,%eax
  801efe:	74 0c                	je     801f0c <devcons_read+0x36>
	*(char*)vbuf = c;
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	88 02                	mov    %al,(%edx)
	return 1;
  801f05:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0a:	eb db                	jmp    801ee7 <devcons_read+0x11>
		return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f11:	eb d4                	jmp    801ee7 <devcons_read+0x11>

00801f13 <cputchar>:
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f1f:	6a 01                	push   $0x1
  801f21:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f24:	50                   	push   %eax
  801f25:	e8 37 ec ff ff       	call   800b61 <sys_cputs>
}
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <getchar>:
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f35:	6a 01                	push   $0x1
  801f37:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f3a:	50                   	push   %eax
  801f3b:	6a 00                	push   $0x0
  801f3d:	e8 5d f2 ff ff       	call   80119f <read>
	if (r < 0)
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	78 08                	js     801f51 <getchar+0x22>
	if (r < 1)
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	7e 06                	jle    801f53 <getchar+0x24>
	return c;
  801f4d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    
		return -E_EOF;
  801f53:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f58:	eb f7                	jmp    801f51 <getchar+0x22>

00801f5a <iscons>:
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f63:	50                   	push   %eax
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	e8 c2 ef ff ff       	call   800f2e <fd_lookup>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	85 c0                	test   %eax,%eax
  801f71:	78 11                	js     801f84 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f7c:	39 10                	cmp    %edx,(%eax)
  801f7e:	0f 94 c0             	sete   %al
  801f81:	0f b6 c0             	movzbl %al,%eax
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <opencons>:
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8f:	50                   	push   %eax
  801f90:	e8 4a ef ff ff       	call   800edf <fd_alloc>
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	78 3a                	js     801fd6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	68 07 04 00 00       	push   $0x407
  801fa4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa7:	6a 00                	push   $0x0
  801fa9:	e8 6f ec ff ff       	call   800c1d <sys_page_alloc>
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	78 21                	js     801fd6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fbe:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	50                   	push   %eax
  801fce:	e8 e5 ee ff ff       	call   800eb8 <fd2num>
  801fd3:	83 c4 10             	add    $0x10,%esp
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	56                   	push   %esi
  801fdc:	53                   	push   %ebx
  801fdd:	8b 75 08             	mov    0x8(%ebp),%esi
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801fe6:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801fe8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fed:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	50                   	push   %eax
  801ff4:	e8 d4 ed ff ff       	call   800dcd <sys_ipc_recv>
	if (from_env_store)
  801ff9:	83 c4 10             	add    $0x10,%esp
  801ffc:	85 f6                	test   %esi,%esi
  801ffe:	74 14                	je     802014 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802000:	ba 00 00 00 00       	mov    $0x0,%edx
  802005:	85 c0                	test   %eax,%eax
  802007:	78 09                	js     802012 <ipc_recv+0x3a>
  802009:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80200f:	8b 52 74             	mov    0x74(%edx),%edx
  802012:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802014:	85 db                	test   %ebx,%ebx
  802016:	74 14                	je     80202c <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802018:	ba 00 00 00 00       	mov    $0x0,%edx
  80201d:	85 c0                	test   %eax,%eax
  80201f:	78 09                	js     80202a <ipc_recv+0x52>
  802021:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802027:	8b 52 78             	mov    0x78(%edx),%edx
  80202a:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	78 08                	js     802038 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802030:	a1 08 40 80 00       	mov    0x804008,%eax
  802035:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
  802042:	57                   	push   %edi
  802043:	56                   	push   %esi
  802044:	53                   	push   %ebx
  802045:	83 ec 0c             	sub    $0xc,%esp
  802048:	8b 7d 08             	mov    0x8(%ebp),%edi
  80204b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80204e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802051:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802053:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802058:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80205b:	ff 75 14             	pushl  0x14(%ebp)
  80205e:	53                   	push   %ebx
  80205f:	56                   	push   %esi
  802060:	57                   	push   %edi
  802061:	e8 44 ed ff ff       	call   800daa <sys_ipc_try_send>
		if (ret == 0)
  802066:	83 c4 10             	add    $0x10,%esp
  802069:	85 c0                	test   %eax,%eax
  80206b:	74 1e                	je     80208b <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80206d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802070:	75 07                	jne    802079 <ipc_send+0x3a>
			sys_yield();
  802072:	e8 87 eb ff ff       	call   800bfe <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802077:	eb e2                	jmp    80205b <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802079:	50                   	push   %eax
  80207a:	68 7b 28 80 00       	push   $0x80287b
  80207f:	6a 3d                	push   $0x3d
  802081:	68 8f 28 80 00       	push   $0x80288f
  802086:	e8 9f e0 ff ff       	call   80012a <_panic>
	}
	// panic("ipc_send not implemented");
}
  80208b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80208e:	5b                   	pop    %ebx
  80208f:	5e                   	pop    %esi
  802090:	5f                   	pop    %edi
  802091:	5d                   	pop    %ebp
  802092:	c3                   	ret    

00802093 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80209e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8020a1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8020a7:	8b 52 50             	mov    0x50(%edx),%edx
  8020aa:	39 ca                	cmp    %ecx,%edx
  8020ac:	74 11                	je     8020bf <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8020ae:	83 c0 01             	add    $0x1,%eax
  8020b1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020b6:	75 e6                	jne    80209e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020bd:	eb 0b                	jmp    8020ca <ipc_find_env+0x37>
			return envs[i].env_id;
  8020bf:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020c7:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    

008020cc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020d2:	89 d0                	mov    %edx,%eax
  8020d4:	c1 e8 16             	shr    $0x16,%eax
  8020d7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020e3:	f6 c1 01             	test   $0x1,%cl
  8020e6:	74 1d                	je     802105 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020e8:	c1 ea 0c             	shr    $0xc,%edx
  8020eb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020f2:	f6 c2 01             	test   $0x1,%dl
  8020f5:	74 0e                	je     802105 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020f7:	c1 ea 0c             	shr    $0xc,%edx
  8020fa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802101:	ef 
  802102:	0f b7 c0             	movzwl %ax,%eax
}
  802105:	5d                   	pop    %ebp
  802106:	c3                   	ret    
  802107:	66 90                	xchg   %ax,%ax
  802109:	66 90                	xchg   %ax,%ax
  80210b:	66 90                	xchg   %ax,%ax
  80210d:	66 90                	xchg   %ax,%ax
  80210f:	90                   	nop

00802110 <__udivdi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80211b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80211f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802123:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802127:	85 d2                	test   %edx,%edx
  802129:	75 35                	jne    802160 <__udivdi3+0x50>
  80212b:	39 f3                	cmp    %esi,%ebx
  80212d:	0f 87 bd 00 00 00    	ja     8021f0 <__udivdi3+0xe0>
  802133:	85 db                	test   %ebx,%ebx
  802135:	89 d9                	mov    %ebx,%ecx
  802137:	75 0b                	jne    802144 <__udivdi3+0x34>
  802139:	b8 01 00 00 00       	mov    $0x1,%eax
  80213e:	31 d2                	xor    %edx,%edx
  802140:	f7 f3                	div    %ebx
  802142:	89 c1                	mov    %eax,%ecx
  802144:	31 d2                	xor    %edx,%edx
  802146:	89 f0                	mov    %esi,%eax
  802148:	f7 f1                	div    %ecx
  80214a:	89 c6                	mov    %eax,%esi
  80214c:	89 e8                	mov    %ebp,%eax
  80214e:	89 f7                	mov    %esi,%edi
  802150:	f7 f1                	div    %ecx
  802152:	89 fa                	mov    %edi,%edx
  802154:	83 c4 1c             	add    $0x1c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802160:	39 f2                	cmp    %esi,%edx
  802162:	77 7c                	ja     8021e0 <__udivdi3+0xd0>
  802164:	0f bd fa             	bsr    %edx,%edi
  802167:	83 f7 1f             	xor    $0x1f,%edi
  80216a:	0f 84 98 00 00 00    	je     802208 <__udivdi3+0xf8>
  802170:	89 f9                	mov    %edi,%ecx
  802172:	b8 20 00 00 00       	mov    $0x20,%eax
  802177:	29 f8                	sub    %edi,%eax
  802179:	d3 e2                	shl    %cl,%edx
  80217b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80217f:	89 c1                	mov    %eax,%ecx
  802181:	89 da                	mov    %ebx,%edx
  802183:	d3 ea                	shr    %cl,%edx
  802185:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802189:	09 d1                	or     %edx,%ecx
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802191:	89 f9                	mov    %edi,%ecx
  802193:	d3 e3                	shl    %cl,%ebx
  802195:	89 c1                	mov    %eax,%ecx
  802197:	d3 ea                	shr    %cl,%edx
  802199:	89 f9                	mov    %edi,%ecx
  80219b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80219f:	d3 e6                	shl    %cl,%esi
  8021a1:	89 eb                	mov    %ebp,%ebx
  8021a3:	89 c1                	mov    %eax,%ecx
  8021a5:	d3 eb                	shr    %cl,%ebx
  8021a7:	09 de                	or     %ebx,%esi
  8021a9:	89 f0                	mov    %esi,%eax
  8021ab:	f7 74 24 08          	divl   0x8(%esp)
  8021af:	89 d6                	mov    %edx,%esi
  8021b1:	89 c3                	mov    %eax,%ebx
  8021b3:	f7 64 24 0c          	mull   0xc(%esp)
  8021b7:	39 d6                	cmp    %edx,%esi
  8021b9:	72 0c                	jb     8021c7 <__udivdi3+0xb7>
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e5                	shl    %cl,%ebp
  8021bf:	39 c5                	cmp    %eax,%ebp
  8021c1:	73 5d                	jae    802220 <__udivdi3+0x110>
  8021c3:	39 d6                	cmp    %edx,%esi
  8021c5:	75 59                	jne    802220 <__udivdi3+0x110>
  8021c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021ca:	31 ff                	xor    %edi,%edi
  8021cc:	89 fa                	mov    %edi,%edx
  8021ce:	83 c4 1c             	add    $0x1c,%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5f                   	pop    %edi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    
  8021d6:	8d 76 00             	lea    0x0(%esi),%esi
  8021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021e0:	31 ff                	xor    %edi,%edi
  8021e2:	31 c0                	xor    %eax,%eax
  8021e4:	89 fa                	mov    %edi,%edx
  8021e6:	83 c4 1c             	add    $0x1c,%esp
  8021e9:	5b                   	pop    %ebx
  8021ea:	5e                   	pop    %esi
  8021eb:	5f                   	pop    %edi
  8021ec:	5d                   	pop    %ebp
  8021ed:	c3                   	ret    
  8021ee:	66 90                	xchg   %ax,%ax
  8021f0:	31 ff                	xor    %edi,%edi
  8021f2:	89 e8                	mov    %ebp,%eax
  8021f4:	89 f2                	mov    %esi,%edx
  8021f6:	f7 f3                	div    %ebx
  8021f8:	89 fa                	mov    %edi,%edx
  8021fa:	83 c4 1c             	add    $0x1c,%esp
  8021fd:	5b                   	pop    %ebx
  8021fe:	5e                   	pop    %esi
  8021ff:	5f                   	pop    %edi
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    
  802202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802208:	39 f2                	cmp    %esi,%edx
  80220a:	72 06                	jb     802212 <__udivdi3+0x102>
  80220c:	31 c0                	xor    %eax,%eax
  80220e:	39 eb                	cmp    %ebp,%ebx
  802210:	77 d2                	ja     8021e4 <__udivdi3+0xd4>
  802212:	b8 01 00 00 00       	mov    $0x1,%eax
  802217:	eb cb                	jmp    8021e4 <__udivdi3+0xd4>
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	89 d8                	mov    %ebx,%eax
  802222:	31 ff                	xor    %edi,%edi
  802224:	eb be                	jmp    8021e4 <__udivdi3+0xd4>
  802226:	66 90                	xchg   %ax,%ax
  802228:	66 90                	xchg   %ax,%ax
  80222a:	66 90                	xchg   %ax,%ax
  80222c:	66 90                	xchg   %ax,%ax
  80222e:	66 90                	xchg   %ax,%ax

00802230 <__umoddi3>:
  802230:	55                   	push   %ebp
  802231:	57                   	push   %edi
  802232:	56                   	push   %esi
  802233:	53                   	push   %ebx
  802234:	83 ec 1c             	sub    $0x1c,%esp
  802237:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80223b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80223f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802247:	85 ed                	test   %ebp,%ebp
  802249:	89 f0                	mov    %esi,%eax
  80224b:	89 da                	mov    %ebx,%edx
  80224d:	75 19                	jne    802268 <__umoddi3+0x38>
  80224f:	39 df                	cmp    %ebx,%edi
  802251:	0f 86 b1 00 00 00    	jbe    802308 <__umoddi3+0xd8>
  802257:	f7 f7                	div    %edi
  802259:	89 d0                	mov    %edx,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	83 c4 1c             	add    $0x1c,%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5f                   	pop    %edi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
  802265:	8d 76 00             	lea    0x0(%esi),%esi
  802268:	39 dd                	cmp    %ebx,%ebp
  80226a:	77 f1                	ja     80225d <__umoddi3+0x2d>
  80226c:	0f bd cd             	bsr    %ebp,%ecx
  80226f:	83 f1 1f             	xor    $0x1f,%ecx
  802272:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802276:	0f 84 b4 00 00 00    	je     802330 <__umoddi3+0x100>
  80227c:	b8 20 00 00 00       	mov    $0x20,%eax
  802281:	89 c2                	mov    %eax,%edx
  802283:	8b 44 24 04          	mov    0x4(%esp),%eax
  802287:	29 c2                	sub    %eax,%edx
  802289:	89 c1                	mov    %eax,%ecx
  80228b:	89 f8                	mov    %edi,%eax
  80228d:	d3 e5                	shl    %cl,%ebp
  80228f:	89 d1                	mov    %edx,%ecx
  802291:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802295:	d3 e8                	shr    %cl,%eax
  802297:	09 c5                	or     %eax,%ebp
  802299:	8b 44 24 04          	mov    0x4(%esp),%eax
  80229d:	89 c1                	mov    %eax,%ecx
  80229f:	d3 e7                	shl    %cl,%edi
  8022a1:	89 d1                	mov    %edx,%ecx
  8022a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8022a7:	89 df                	mov    %ebx,%edi
  8022a9:	d3 ef                	shr    %cl,%edi
  8022ab:	89 c1                	mov    %eax,%ecx
  8022ad:	89 f0                	mov    %esi,%eax
  8022af:	d3 e3                	shl    %cl,%ebx
  8022b1:	89 d1                	mov    %edx,%ecx
  8022b3:	89 fa                	mov    %edi,%edx
  8022b5:	d3 e8                	shr    %cl,%eax
  8022b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022bc:	09 d8                	or     %ebx,%eax
  8022be:	f7 f5                	div    %ebp
  8022c0:	d3 e6                	shl    %cl,%esi
  8022c2:	89 d1                	mov    %edx,%ecx
  8022c4:	f7 64 24 08          	mull   0x8(%esp)
  8022c8:	39 d1                	cmp    %edx,%ecx
  8022ca:	89 c3                	mov    %eax,%ebx
  8022cc:	89 d7                	mov    %edx,%edi
  8022ce:	72 06                	jb     8022d6 <__umoddi3+0xa6>
  8022d0:	75 0e                	jne    8022e0 <__umoddi3+0xb0>
  8022d2:	39 c6                	cmp    %eax,%esi
  8022d4:	73 0a                	jae    8022e0 <__umoddi3+0xb0>
  8022d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022da:	19 ea                	sbb    %ebp,%edx
  8022dc:	89 d7                	mov    %edx,%edi
  8022de:	89 c3                	mov    %eax,%ebx
  8022e0:	89 ca                	mov    %ecx,%edx
  8022e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022e7:	29 de                	sub    %ebx,%esi
  8022e9:	19 fa                	sbb    %edi,%edx
  8022eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022ef:	89 d0                	mov    %edx,%eax
  8022f1:	d3 e0                	shl    %cl,%eax
  8022f3:	89 d9                	mov    %ebx,%ecx
  8022f5:	d3 ee                	shr    %cl,%esi
  8022f7:	d3 ea                	shr    %cl,%edx
  8022f9:	09 f0                	or     %esi,%eax
  8022fb:	83 c4 1c             	add    $0x1c,%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5e                   	pop    %esi
  802300:	5f                   	pop    %edi
  802301:	5d                   	pop    %ebp
  802302:	c3                   	ret    
  802303:	90                   	nop
  802304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802308:	85 ff                	test   %edi,%edi
  80230a:	89 f9                	mov    %edi,%ecx
  80230c:	75 0b                	jne    802319 <__umoddi3+0xe9>
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	31 d2                	xor    %edx,%edx
  802315:	f7 f7                	div    %edi
  802317:	89 c1                	mov    %eax,%ecx
  802319:	89 d8                	mov    %ebx,%eax
  80231b:	31 d2                	xor    %edx,%edx
  80231d:	f7 f1                	div    %ecx
  80231f:	89 f0                	mov    %esi,%eax
  802321:	f7 f1                	div    %ecx
  802323:	e9 31 ff ff ff       	jmp    802259 <__umoddi3+0x29>
  802328:	90                   	nop
  802329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802330:	39 dd                	cmp    %ebx,%ebp
  802332:	72 08                	jb     80233c <__umoddi3+0x10c>
  802334:	39 f7                	cmp    %esi,%edi
  802336:	0f 87 21 ff ff ff    	ja     80225d <__umoddi3+0x2d>
  80233c:	89 da                	mov    %ebx,%edx
  80233e:	89 f0                	mov    %esi,%eax
  802340:	29 f8                	sub    %edi,%eax
  802342:	19 ea                	sbb    %ebp,%edx
  802344:	e9 14 ff ff ff       	jmp    80225d <__umoddi3+0x2d>

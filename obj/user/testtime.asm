
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
	unsigned now = sys_time_msec();
  80003a:	e8 f9 0d 00 00       	call   800e38 <sys_time_msec>
	unsigned end = now + sec * 1000;
  80003f:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800046:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800048:	85 c0                	test   %eax,%eax
  80004a:	79 05                	jns    800051 <sleep+0x1e>
  80004c:	83 f8 f1             	cmp    $0xfffffff1,%eax
  80004f:	7d 18                	jge    800069 <sleep+0x36>
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
  800051:	39 d8                	cmp    %ebx,%eax
  800053:	76 2b                	jbe    800080 <sleep+0x4d>
		panic("sleep: wrap");
  800055:	83 ec 04             	sub    $0x4,%esp
  800058:	68 22 23 80 00       	push   $0x802322
  80005d:	6a 0d                	push   $0xd
  80005f:	68 12 23 80 00       	push   $0x802312
  800064:	e8 eb 00 00 00       	call   800154 <_panic>
		panic("sys_time_msec: %e", (int)now);
  800069:	50                   	push   %eax
  80006a:	68 00 23 80 00       	push   $0x802300
  80006f:	6a 0b                	push   $0xb
  800071:	68 12 23 80 00       	push   $0x802312
  800076:	e8 d9 00 00 00       	call   800154 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  80007b:	e8 a8 0b 00 00       	call   800c28 <sys_yield>
	while (sys_time_msec() < end)
  800080:	e8 b3 0d 00 00       	call   800e38 <sys_time_msec>
  800085:	39 d8                	cmp    %ebx,%eax
  800087:	72 f2                	jb     80007b <sleep+0x48>
}
  800089:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80008c:	c9                   	leave  
  80008d:	c3                   	ret    

0080008e <umain>:

void
umain(int argc, char **argv)
{
  80008e:	55                   	push   %ebp
  80008f:	89 e5                	mov    %esp,%ebp
  800091:	53                   	push   %ebx
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  80009a:	e8 89 0b 00 00       	call   800c28 <sys_yield>
	for (i = 0; i < 50; i++)
  80009f:	83 eb 01             	sub    $0x1,%ebx
  8000a2:	75 f6                	jne    80009a <umain+0xc>

	cprintf("starting count down: ");
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	68 2e 23 80 00       	push   $0x80232e
  8000ac:	e8 7e 01 00 00       	call   80022f <cprintf>
  8000b1:	83 c4 10             	add    $0x10,%esp
	for (i = 5; i >= 0; i--) {
  8000b4:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	53                   	push   %ebx
  8000bd:	68 44 23 80 00       	push   $0x802344
  8000c2:	e8 68 01 00 00       	call   80022f <cprintf>
		sleep(1);
  8000c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <sleep>
	for (i = 5; i >= 0; i--) {
  8000d3:	83 eb 01             	sub    $0x1,%ebx
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	83 fb ff             	cmp    $0xffffffff,%ebx
  8000dc:	75 db                	jne    8000b9 <umain+0x2b>
	}
	cprintf("\n");
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	68 c4 27 80 00       	push   $0x8027c4
  8000e6:	e8 44 01 00 00       	call   80022f <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8000eb:	cc                   	int3   
	breakpoint();
}
  8000ec:	83 c4 10             	add    $0x10,%esp
  8000ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fc:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ff:	e8 05 0b 00 00       	call   800c09 <sys_getenvid>
  800104:	25 ff 03 00 00       	and    $0x3ff,%eax
  800109:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80010c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800111:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800116:	85 db                	test   %ebx,%ebx
  800118:	7e 07                	jle    800121 <libmain+0x2d>
		binaryname = argv[0];
  80011a:	8b 06                	mov    (%esi),%eax
  80011c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800121:	83 ec 08             	sub    $0x8,%esp
  800124:	56                   	push   %esi
  800125:	53                   	push   %ebx
  800126:	e8 63 ff ff ff       	call   80008e <umain>

	// exit gracefully
	exit();
  80012b:	e8 0a 00 00 00       	call   80013a <exit>
}
  800130:	83 c4 10             	add    $0x10,%esp
  800133:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800136:	5b                   	pop    %ebx
  800137:	5e                   	pop    %esi
  800138:	5d                   	pop    %ebp
  800139:	c3                   	ret    

0080013a <exit>:

#include <inc/lib.h>

void exit(void)
{
  80013a:	55                   	push   %ebp
  80013b:	89 e5                	mov    %esp,%ebp
  80013d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800140:	e8 e8 0e 00 00       	call   80102d <close_all>
	sys_env_destroy(0);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	6a 00                	push   $0x0
  80014a:	e8 79 0a 00 00       	call   800bc8 <sys_env_destroy>
}
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	56                   	push   %esi
  800158:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800159:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80015c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800162:	e8 a2 0a 00 00       	call   800c09 <sys_getenvid>
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	ff 75 0c             	pushl  0xc(%ebp)
  80016d:	ff 75 08             	pushl  0x8(%ebp)
  800170:	56                   	push   %esi
  800171:	50                   	push   %eax
  800172:	68 54 23 80 00       	push   $0x802354
  800177:	e8 b3 00 00 00       	call   80022f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80017c:	83 c4 18             	add    $0x18,%esp
  80017f:	53                   	push   %ebx
  800180:	ff 75 10             	pushl  0x10(%ebp)
  800183:	e8 56 00 00 00       	call   8001de <vcprintf>
	cprintf("\n");
  800188:	c7 04 24 c4 27 80 00 	movl   $0x8027c4,(%esp)
  80018f:	e8 9b 00 00 00       	call   80022f <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800197:	cc                   	int3   
  800198:	eb fd                	jmp    800197 <_panic+0x43>

0080019a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	53                   	push   %ebx
  80019e:	83 ec 04             	sub    $0x4,%esp
  8001a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a4:	8b 13                	mov    (%ebx),%edx
  8001a6:	8d 42 01             	lea    0x1(%edx),%eax
  8001a9:	89 03                	mov    %eax,(%ebx)
  8001ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ae:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b7:	74 09                	je     8001c2 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c0:	c9                   	leave  
  8001c1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c2:	83 ec 08             	sub    $0x8,%esp
  8001c5:	68 ff 00 00 00       	push   $0xff
  8001ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cd:	50                   	push   %eax
  8001ce:	e8 b8 09 00 00       	call   800b8b <sys_cputs>
		b->idx = 0;
  8001d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d9:	83 c4 10             	add    $0x10,%esp
  8001dc:	eb db                	jmp    8001b9 <putch+0x1f>

008001de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ee:	00 00 00 
	b.cnt = 0;
  8001f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fb:	ff 75 0c             	pushl  0xc(%ebp)
  8001fe:	ff 75 08             	pushl  0x8(%ebp)
  800201:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800207:	50                   	push   %eax
  800208:	68 9a 01 80 00       	push   $0x80019a
  80020d:	e8 1a 01 00 00       	call   80032c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800212:	83 c4 08             	add    $0x8,%esp
  800215:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	e8 64 09 00 00       	call   800b8b <sys_cputs>

	return b.cnt;
}
  800227:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800235:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800238:	50                   	push   %eax
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	e8 9d ff ff ff       	call   8001de <vcprintf>
	va_end(ap);

	return cnt;
}
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	57                   	push   %edi
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
  800249:	83 ec 1c             	sub    $0x1c,%esp
  80024c:	89 c7                	mov    %eax,%edi
  80024e:	89 d6                	mov    %edx,%esi
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	8b 55 0c             	mov    0xc(%ebp),%edx
  800256:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800259:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80025c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800264:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800267:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80026a:	39 d3                	cmp    %edx,%ebx
  80026c:	72 05                	jb     800273 <printnum+0x30>
  80026e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800271:	77 7a                	ja     8002ed <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800273:	83 ec 0c             	sub    $0xc,%esp
  800276:	ff 75 18             	pushl  0x18(%ebp)
  800279:	8b 45 14             	mov    0x14(%ebp),%eax
  80027c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027f:	53                   	push   %ebx
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	ff 75 e0             	pushl  -0x20(%ebp)
  80028c:	ff 75 dc             	pushl  -0x24(%ebp)
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 19 1e 00 00       	call   8020b0 <__udivdi3>
  800297:	83 c4 18             	add    $0x18,%esp
  80029a:	52                   	push   %edx
  80029b:	50                   	push   %eax
  80029c:	89 f2                	mov    %esi,%edx
  80029e:	89 f8                	mov    %edi,%eax
  8002a0:	e8 9e ff ff ff       	call   800243 <printnum>
  8002a5:	83 c4 20             	add    $0x20,%esp
  8002a8:	eb 13                	jmp    8002bd <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	56                   	push   %esi
  8002ae:	ff 75 18             	pushl  0x18(%ebp)
  8002b1:	ff d7                	call   *%edi
  8002b3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b6:	83 eb 01             	sub    $0x1,%ebx
  8002b9:	85 db                	test   %ebx,%ebx
  8002bb:	7f ed                	jg     8002aa <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	56                   	push   %esi
  8002c1:	83 ec 04             	sub    $0x4,%esp
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ca:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d0:	e8 fb 1e 00 00       	call   8021d0 <__umoddi3>
  8002d5:	83 c4 14             	add    $0x14,%esp
  8002d8:	0f be 80 77 23 80 00 	movsbl 0x802377(%eax),%eax
  8002df:	50                   	push   %eax
  8002e0:	ff d7                	call   *%edi
}
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e8:	5b                   	pop    %ebx
  8002e9:	5e                   	pop    %esi
  8002ea:	5f                   	pop    %edi
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    
  8002ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002f0:	eb c4                	jmp    8002b6 <printnum+0x73>

008002f2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f8:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fc:	8b 10                	mov    (%eax),%edx
  8002fe:	3b 50 04             	cmp    0x4(%eax),%edx
  800301:	73 0a                	jae    80030d <sprintputch+0x1b>
		*b->buf++ = ch;
  800303:	8d 4a 01             	lea    0x1(%edx),%ecx
  800306:	89 08                	mov    %ecx,(%eax)
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	88 02                	mov    %al,(%edx)
}
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <printfmt>:
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800315:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800318:	50                   	push   %eax
  800319:	ff 75 10             	pushl  0x10(%ebp)
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	e8 05 00 00 00       	call   80032c <vprintfmt>
}
  800327:	83 c4 10             	add    $0x10,%esp
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <vprintfmt>:
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	57                   	push   %edi
  800330:	56                   	push   %esi
  800331:	53                   	push   %ebx
  800332:	83 ec 2c             	sub    $0x2c,%esp
  800335:	8b 75 08             	mov    0x8(%ebp),%esi
  800338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80033e:	e9 c1 03 00 00       	jmp    800704 <vprintfmt+0x3d8>
		padc = ' ';
  800343:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800347:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80034e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800355:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80035c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8d 47 01             	lea    0x1(%edi),%eax
  800364:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800367:	0f b6 17             	movzbl (%edi),%edx
  80036a:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036d:	3c 55                	cmp    $0x55,%al
  80036f:	0f 87 12 04 00 00    	ja     800787 <vprintfmt+0x45b>
  800375:	0f b6 c0             	movzbl %al,%eax
  800378:	ff 24 85 c0 24 80 00 	jmp    *0x8024c0(,%eax,4)
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800382:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800386:	eb d9                	jmp    800361 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80038f:	eb d0                	jmp    800361 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800391:	0f b6 d2             	movzbl %dl,%edx
  800394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800397:	b8 00 00 00 00       	mov    $0x0,%eax
  80039c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80039f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ac:	83 f9 09             	cmp    $0x9,%ecx
  8003af:	77 55                	ja     800406 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003b1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b4:	eb e9                	jmp    80039f <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 40 04             	lea    0x4(%eax),%eax
  8003c4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ce:	79 91                	jns    800361 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003dd:	eb 82                	jmp    800361 <vprintfmt+0x35>
  8003df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e9:	0f 49 d0             	cmovns %eax,%edx
  8003ec:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f2:	e9 6a ff ff ff       	jmp    800361 <vprintfmt+0x35>
  8003f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fa:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800401:	e9 5b ff ff ff       	jmp    800361 <vprintfmt+0x35>
  800406:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800409:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80040c:	eb bc                	jmp    8003ca <vprintfmt+0x9e>
			lflag++;
  80040e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800411:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800414:	e9 48 ff ff ff       	jmp    800361 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800419:	8b 45 14             	mov    0x14(%ebp),%eax
  80041c:	8d 78 04             	lea    0x4(%eax),%edi
  80041f:	83 ec 08             	sub    $0x8,%esp
  800422:	53                   	push   %ebx
  800423:	ff 30                	pushl  (%eax)
  800425:	ff d6                	call   *%esi
			break;
  800427:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042d:	e9 cf 02 00 00       	jmp    800701 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 78 04             	lea    0x4(%eax),%edi
  800438:	8b 00                	mov    (%eax),%eax
  80043a:	99                   	cltd   
  80043b:	31 d0                	xor    %edx,%eax
  80043d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043f:	83 f8 0f             	cmp    $0xf,%eax
  800442:	7f 23                	jg     800467 <vprintfmt+0x13b>
  800444:	8b 14 85 20 26 80 00 	mov    0x802620(,%eax,4),%edx
  80044b:	85 d2                	test   %edx,%edx
  80044d:	74 18                	je     800467 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80044f:	52                   	push   %edx
  800450:	68 59 27 80 00       	push   $0x802759
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 b3 fe ff ff       	call   80030f <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800462:	e9 9a 02 00 00       	jmp    800701 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800467:	50                   	push   %eax
  800468:	68 8f 23 80 00       	push   $0x80238f
  80046d:	53                   	push   %ebx
  80046e:	56                   	push   %esi
  80046f:	e8 9b fe ff ff       	call   80030f <printfmt>
  800474:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800477:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047a:	e9 82 02 00 00       	jmp    800701 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	83 c0 04             	add    $0x4,%eax
  800485:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80048d:	85 ff                	test   %edi,%edi
  80048f:	b8 88 23 80 00       	mov    $0x802388,%eax
  800494:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800497:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049b:	0f 8e bd 00 00 00    	jle    80055e <vprintfmt+0x232>
  8004a1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a5:	75 0e                	jne    8004b5 <vprintfmt+0x189>
  8004a7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ad:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b3:	eb 6d                	jmp    800522 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bb:	57                   	push   %edi
  8004bc:	e8 6e 03 00 00       	call   80082f <strnlen>
  8004c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c4:	29 c1                	sub    %eax,%ecx
  8004c6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004c9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004cc:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004d6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	eb 0f                	jmp    8004e9 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	53                   	push   %ebx
  8004de:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	83 ef 01             	sub    $0x1,%edi
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	85 ff                	test   %edi,%edi
  8004eb:	7f ed                	jg     8004da <vprintfmt+0x1ae>
  8004ed:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f0:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004f3:	85 c9                	test   %ecx,%ecx
  8004f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fa:	0f 49 c1             	cmovns %ecx,%eax
  8004fd:	29 c1                	sub    %eax,%ecx
  8004ff:	89 75 08             	mov    %esi,0x8(%ebp)
  800502:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800505:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800508:	89 cb                	mov    %ecx,%ebx
  80050a:	eb 16                	jmp    800522 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800510:	75 31                	jne    800543 <vprintfmt+0x217>
					putch(ch, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	50                   	push   %eax
  800519:	ff 55 08             	call   *0x8(%ebp)
  80051c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80051f:	83 eb 01             	sub    $0x1,%ebx
  800522:	83 c7 01             	add    $0x1,%edi
  800525:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800529:	0f be c2             	movsbl %dl,%eax
  80052c:	85 c0                	test   %eax,%eax
  80052e:	74 59                	je     800589 <vprintfmt+0x25d>
  800530:	85 f6                	test   %esi,%esi
  800532:	78 d8                	js     80050c <vprintfmt+0x1e0>
  800534:	83 ee 01             	sub    $0x1,%esi
  800537:	79 d3                	jns    80050c <vprintfmt+0x1e0>
  800539:	89 df                	mov    %ebx,%edi
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800541:	eb 37                	jmp    80057a <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800543:	0f be d2             	movsbl %dl,%edx
  800546:	83 ea 20             	sub    $0x20,%edx
  800549:	83 fa 5e             	cmp    $0x5e,%edx
  80054c:	76 c4                	jbe    800512 <vprintfmt+0x1e6>
					putch('?', putdat);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	6a 3f                	push   $0x3f
  800556:	ff 55 08             	call   *0x8(%ebp)
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	eb c1                	jmp    80051f <vprintfmt+0x1f3>
  80055e:	89 75 08             	mov    %esi,0x8(%ebp)
  800561:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800564:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800567:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80056a:	eb b6                	jmp    800522 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	53                   	push   %ebx
  800570:	6a 20                	push   $0x20
  800572:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800574:	83 ef 01             	sub    $0x1,%edi
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	85 ff                	test   %edi,%edi
  80057c:	7f ee                	jg     80056c <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80057e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800581:	89 45 14             	mov    %eax,0x14(%ebp)
  800584:	e9 78 01 00 00       	jmp    800701 <vprintfmt+0x3d5>
  800589:	89 df                	mov    %ebx,%edi
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800591:	eb e7                	jmp    80057a <vprintfmt+0x24e>
	if (lflag >= 2)
  800593:	83 f9 01             	cmp    $0x1,%ecx
  800596:	7e 3f                	jle    8005d7 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b3:	79 5c                	jns    800611 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	53                   	push   %ebx
  8005b9:	6a 2d                	push   $0x2d
  8005bb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c3:	f7 da                	neg    %edx
  8005c5:	83 d1 00             	adc    $0x0,%ecx
  8005c8:	f7 d9                	neg    %ecx
  8005ca:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d2:	e9 10 01 00 00       	jmp    8006e7 <vprintfmt+0x3bb>
	else if (lflag)
  8005d7:	85 c9                	test   %ecx,%ecx
  8005d9:	75 1b                	jne    8005f6 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e3:	89 c1                	mov    %eax,%ecx
  8005e5:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e8:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 40 04             	lea    0x4(%eax),%eax
  8005f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f4:	eb b9                	jmp    8005af <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f9:	8b 00                	mov    (%eax),%eax
  8005fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fe:	89 c1                	mov    %eax,%ecx
  800600:	c1 f9 1f             	sar    $0x1f,%ecx
  800603:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800606:	8b 45 14             	mov    0x14(%ebp),%eax
  800609:	8d 40 04             	lea    0x4(%eax),%eax
  80060c:	89 45 14             	mov    %eax,0x14(%ebp)
  80060f:	eb 9e                	jmp    8005af <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800611:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800614:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800617:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061c:	e9 c6 00 00 00       	jmp    8006e7 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800621:	83 f9 01             	cmp    $0x1,%ecx
  800624:	7e 18                	jle    80063e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8b 10                	mov    (%eax),%edx
  80062b:	8b 48 04             	mov    0x4(%eax),%ecx
  80062e:	8d 40 08             	lea    0x8(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800634:	b8 0a 00 00 00       	mov    $0xa,%eax
  800639:	e9 a9 00 00 00       	jmp    8006e7 <vprintfmt+0x3bb>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	75 1a                	jne    80065c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800652:	b8 0a 00 00 00       	mov    $0xa,%eax
  800657:	e9 8b 00 00 00       	jmp    8006e7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	b9 00 00 00 00       	mov    $0x0,%ecx
  800666:	8d 40 04             	lea    0x4(%eax),%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800671:	eb 74                	jmp    8006e7 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800673:	83 f9 01             	cmp    $0x1,%ecx
  800676:	7e 15                	jle    80068d <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 10                	mov    (%eax),%edx
  80067d:	8b 48 04             	mov    0x4(%eax),%ecx
  800680:	8d 40 08             	lea    0x8(%eax),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800686:	b8 08 00 00 00       	mov    $0x8,%eax
  80068b:	eb 5a                	jmp    8006e7 <vprintfmt+0x3bb>
	else if (lflag)
  80068d:	85 c9                	test   %ecx,%ecx
  80068f:	75 17                	jne    8006a8 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8b 10                	mov    (%eax),%edx
  800696:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069b:	8d 40 04             	lea    0x4(%eax),%eax
  80069e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a6:	eb 3f                	jmp    8006e7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b2:	8d 40 04             	lea    0x4(%eax),%eax
  8006b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006bd:	eb 28                	jmp    8006e7 <vprintfmt+0x3bb>
			putch('0', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	53                   	push   %ebx
  8006c3:	6a 30                	push   $0x30
  8006c5:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c7:	83 c4 08             	add    $0x8,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	6a 78                	push   $0x78
  8006cd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 10                	mov    (%eax),%edx
  8006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006d9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006dc:	8d 40 04             	lea    0x4(%eax),%eax
  8006df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006ee:	57                   	push   %edi
  8006ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f2:	50                   	push   %eax
  8006f3:	51                   	push   %ecx
  8006f4:	52                   	push   %edx
  8006f5:	89 da                	mov    %ebx,%edx
  8006f7:	89 f0                	mov    %esi,%eax
  8006f9:	e8 45 fb ff ff       	call   800243 <printnum>
			break;
  8006fe:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800701:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800704:	83 c7 01             	add    $0x1,%edi
  800707:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070b:	83 f8 25             	cmp    $0x25,%eax
  80070e:	0f 84 2f fc ff ff    	je     800343 <vprintfmt+0x17>
			if (ch == '\0')
  800714:	85 c0                	test   %eax,%eax
  800716:	0f 84 8b 00 00 00    	je     8007a7 <vprintfmt+0x47b>
			putch(ch, putdat);
  80071c:	83 ec 08             	sub    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	50                   	push   %eax
  800721:	ff d6                	call   *%esi
  800723:	83 c4 10             	add    $0x10,%esp
  800726:	eb dc                	jmp    800704 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800728:	83 f9 01             	cmp    $0x1,%ecx
  80072b:	7e 15                	jle    800742 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 10                	mov    (%eax),%edx
  800732:	8b 48 04             	mov    0x4(%eax),%ecx
  800735:	8d 40 08             	lea    0x8(%eax),%eax
  800738:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073b:	b8 10 00 00 00       	mov    $0x10,%eax
  800740:	eb a5                	jmp    8006e7 <vprintfmt+0x3bb>
	else if (lflag)
  800742:	85 c9                	test   %ecx,%ecx
  800744:	75 17                	jne    80075d <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800746:	8b 45 14             	mov    0x14(%ebp),%eax
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800750:	8d 40 04             	lea    0x4(%eax),%eax
  800753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800756:	b8 10 00 00 00       	mov    $0x10,%eax
  80075b:	eb 8a                	jmp    8006e7 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8b 10                	mov    (%eax),%edx
  800762:	b9 00 00 00 00       	mov    $0x0,%ecx
  800767:	8d 40 04             	lea    0x4(%eax),%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80076d:	b8 10 00 00 00       	mov    $0x10,%eax
  800772:	e9 70 ff ff ff       	jmp    8006e7 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	53                   	push   %ebx
  80077b:	6a 25                	push   $0x25
  80077d:	ff d6                	call   *%esi
			break;
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	e9 7a ff ff ff       	jmp    800701 <vprintfmt+0x3d5>
			putch('%', putdat);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	53                   	push   %ebx
  80078b:	6a 25                	push   $0x25
  80078d:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	89 f8                	mov    %edi,%eax
  800794:	eb 03                	jmp    800799 <vprintfmt+0x46d>
  800796:	83 e8 01             	sub    $0x1,%eax
  800799:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80079d:	75 f7                	jne    800796 <vprintfmt+0x46a>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a2:	e9 5a ff ff ff       	jmp    800701 <vprintfmt+0x3d5>
}
  8007a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5f                   	pop    %edi
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
  8007b2:	83 ec 18             	sub    $0x18,%esp
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007be:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c2:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cc:	85 c0                	test   %eax,%eax
  8007ce:	74 26                	je     8007f6 <vsnprintf+0x47>
  8007d0:	85 d2                	test   %edx,%edx
  8007d2:	7e 22                	jle    8007f6 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d4:	ff 75 14             	pushl  0x14(%ebp)
  8007d7:	ff 75 10             	pushl  0x10(%ebp)
  8007da:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007dd:	50                   	push   %eax
  8007de:	68 f2 02 80 00       	push   $0x8002f2
  8007e3:	e8 44 fb ff ff       	call   80032c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
}
  8007f4:	c9                   	leave  
  8007f5:	c3                   	ret    
		return -E_INVAL;
  8007f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fb:	eb f7                	jmp    8007f4 <vsnprintf+0x45>

008007fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800806:	50                   	push   %eax
  800807:	ff 75 10             	pushl  0x10(%ebp)
  80080a:	ff 75 0c             	pushl  0xc(%ebp)
  80080d:	ff 75 08             	pushl  0x8(%ebp)
  800810:	e8 9a ff ff ff       	call   8007af <vsnprintf>
	va_end(ap);

	return rc;
}
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80081d:	b8 00 00 00 00       	mov    $0x0,%eax
  800822:	eb 03                	jmp    800827 <strlen+0x10>
		n++;
  800824:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800827:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082b:	75 f7                	jne    800824 <strlen+0xd>
	return n;
}
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800835:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800838:	b8 00 00 00 00       	mov    $0x0,%eax
  80083d:	eb 03                	jmp    800842 <strnlen+0x13>
		n++;
  80083f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800842:	39 d0                	cmp    %edx,%eax
  800844:	74 06                	je     80084c <strnlen+0x1d>
  800846:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084a:	75 f3                	jne    80083f <strnlen+0x10>
	return n;
}
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800858:	89 c2                	mov    %eax,%edx
  80085a:	83 c1 01             	add    $0x1,%ecx
  80085d:	83 c2 01             	add    $0x1,%edx
  800860:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800864:	88 5a ff             	mov    %bl,-0x1(%edx)
  800867:	84 db                	test   %bl,%bl
  800869:	75 ef                	jne    80085a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80086b:	5b                   	pop    %ebx
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	53                   	push   %ebx
  800872:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800875:	53                   	push   %ebx
  800876:	e8 9c ff ff ff       	call   800817 <strlen>
  80087b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	01 d8                	add    %ebx,%eax
  800883:	50                   	push   %eax
  800884:	e8 c5 ff ff ff       	call   80084e <strcpy>
	return dst;
}
  800889:	89 d8                	mov    %ebx,%eax
  80088b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	56                   	push   %esi
  800894:	53                   	push   %ebx
  800895:	8b 75 08             	mov    0x8(%ebp),%esi
  800898:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089b:	89 f3                	mov    %esi,%ebx
  80089d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a0:	89 f2                	mov    %esi,%edx
  8008a2:	eb 0f                	jmp    8008b3 <strncpy+0x23>
		*dst++ = *src;
  8008a4:	83 c2 01             	add    $0x1,%edx
  8008a7:	0f b6 01             	movzbl (%ecx),%eax
  8008aa:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ad:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b3:	39 da                	cmp    %ebx,%edx
  8008b5:	75 ed                	jne    8008a4 <strncpy+0x14>
	}
	return ret;
}
  8008b7:	89 f0                	mov    %esi,%eax
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	56                   	push   %esi
  8008c1:	53                   	push   %ebx
  8008c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008cb:	89 f0                	mov    %esi,%eax
  8008cd:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d1:	85 c9                	test   %ecx,%ecx
  8008d3:	75 0b                	jne    8008e0 <strlcpy+0x23>
  8008d5:	eb 17                	jmp    8008ee <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d7:	83 c2 01             	add    $0x1,%edx
  8008da:	83 c0 01             	add    $0x1,%eax
  8008dd:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008e0:	39 d8                	cmp    %ebx,%eax
  8008e2:	74 07                	je     8008eb <strlcpy+0x2e>
  8008e4:	0f b6 0a             	movzbl (%edx),%ecx
  8008e7:	84 c9                	test   %cl,%cl
  8008e9:	75 ec                	jne    8008d7 <strlcpy+0x1a>
		*dst = '\0';
  8008eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ee:	29 f0                	sub    %esi,%eax
}
  8008f0:	5b                   	pop    %ebx
  8008f1:	5e                   	pop    %esi
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fd:	eb 06                	jmp    800905 <strcmp+0x11>
		p++, q++;
  8008ff:	83 c1 01             	add    $0x1,%ecx
  800902:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800905:	0f b6 01             	movzbl (%ecx),%eax
  800908:	84 c0                	test   %al,%al
  80090a:	74 04                	je     800910 <strcmp+0x1c>
  80090c:	3a 02                	cmp    (%edx),%al
  80090e:	74 ef                	je     8008ff <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800910:	0f b6 c0             	movzbl %al,%eax
  800913:	0f b6 12             	movzbl (%edx),%edx
  800916:	29 d0                	sub    %edx,%eax
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 55 0c             	mov    0xc(%ebp),%edx
  800924:	89 c3                	mov    %eax,%ebx
  800926:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800929:	eb 06                	jmp    800931 <strncmp+0x17>
		n--, p++, q++;
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800931:	39 d8                	cmp    %ebx,%eax
  800933:	74 16                	je     80094b <strncmp+0x31>
  800935:	0f b6 08             	movzbl (%eax),%ecx
  800938:	84 c9                	test   %cl,%cl
  80093a:	74 04                	je     800940 <strncmp+0x26>
  80093c:	3a 0a                	cmp    (%edx),%cl
  80093e:	74 eb                	je     80092b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800940:	0f b6 00             	movzbl (%eax),%eax
  800943:	0f b6 12             	movzbl (%edx),%edx
  800946:	29 d0                	sub    %edx,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    
		return 0;
  80094b:	b8 00 00 00 00       	mov    $0x0,%eax
  800950:	eb f6                	jmp    800948 <strncmp+0x2e>

00800952 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80095c:	0f b6 10             	movzbl (%eax),%edx
  80095f:	84 d2                	test   %dl,%dl
  800961:	74 09                	je     80096c <strchr+0x1a>
		if (*s == c)
  800963:	38 ca                	cmp    %cl,%dl
  800965:	74 0a                	je     800971 <strchr+0x1f>
	for (; *s; s++)
  800967:	83 c0 01             	add    $0x1,%eax
  80096a:	eb f0                	jmp    80095c <strchr+0xa>
			return (char *) s;
	return 0;
  80096c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80097d:	eb 03                	jmp    800982 <strfind+0xf>
  80097f:	83 c0 01             	add    $0x1,%eax
  800982:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800985:	38 ca                	cmp    %cl,%dl
  800987:	74 04                	je     80098d <strfind+0x1a>
  800989:	84 d2                	test   %dl,%dl
  80098b:	75 f2                	jne    80097f <strfind+0xc>
			break;
	return (char *) s;
}
  80098d:	5d                   	pop    %ebp
  80098e:	c3                   	ret    

0080098f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80098f:	55                   	push   %ebp
  800990:	89 e5                	mov    %esp,%ebp
  800992:	57                   	push   %edi
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 7d 08             	mov    0x8(%ebp),%edi
  800998:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099b:	85 c9                	test   %ecx,%ecx
  80099d:	74 13                	je     8009b2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80099f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a5:	75 05                	jne    8009ac <memset+0x1d>
  8009a7:	f6 c1 03             	test   $0x3,%cl
  8009aa:	74 0d                	je     8009b9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009af:	fc                   	cld    
  8009b0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b2:	89 f8                	mov    %edi,%eax
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5f                   	pop    %edi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    
		c &= 0xFF;
  8009b9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009bd:	89 d3                	mov    %edx,%ebx
  8009bf:	c1 e3 08             	shl    $0x8,%ebx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 18             	shl    $0x18,%eax
  8009c7:	89 d6                	mov    %edx,%esi
  8009c9:	c1 e6 10             	shl    $0x10,%esi
  8009cc:	09 f0                	or     %esi,%eax
  8009ce:	09 c2                	or     %eax,%edx
  8009d0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d5:	89 d0                	mov    %edx,%eax
  8009d7:	fc                   	cld    
  8009d8:	f3 ab                	rep stos %eax,%es:(%edi)
  8009da:	eb d6                	jmp    8009b2 <memset+0x23>

008009dc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	57                   	push   %edi
  8009e0:	56                   	push   %esi
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ea:	39 c6                	cmp    %eax,%esi
  8009ec:	73 35                	jae    800a23 <memmove+0x47>
  8009ee:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f1:	39 c2                	cmp    %eax,%edx
  8009f3:	76 2e                	jbe    800a23 <memmove+0x47>
		s += n;
		d += n;
  8009f5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f8:	89 d6                	mov    %edx,%esi
  8009fa:	09 fe                	or     %edi,%esi
  8009fc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a02:	74 0c                	je     800a10 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a04:	83 ef 01             	sub    $0x1,%edi
  800a07:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0a:	fd                   	std    
  800a0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0d:	fc                   	cld    
  800a0e:	eb 21                	jmp    800a31 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a10:	f6 c1 03             	test   $0x3,%cl
  800a13:	75 ef                	jne    800a04 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a15:	83 ef 04             	sub    $0x4,%edi
  800a18:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a1e:	fd                   	std    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb ea                	jmp    800a0d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a23:	89 f2                	mov    %esi,%edx
  800a25:	09 c2                	or     %eax,%edx
  800a27:	f6 c2 03             	test   $0x3,%dl
  800a2a:	74 09                	je     800a35 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a2c:	89 c7                	mov    %eax,%edi
  800a2e:	fc                   	cld    
  800a2f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a31:	5e                   	pop    %esi
  800a32:	5f                   	pop    %edi
  800a33:	5d                   	pop    %ebp
  800a34:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a35:	f6 c1 03             	test   $0x3,%cl
  800a38:	75 f2                	jne    800a2c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a3d:	89 c7                	mov    %eax,%edi
  800a3f:	fc                   	cld    
  800a40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a42:	eb ed                	jmp    800a31 <memmove+0x55>

00800a44 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a47:	ff 75 10             	pushl  0x10(%ebp)
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	ff 75 08             	pushl  0x8(%ebp)
  800a50:	e8 87 ff ff ff       	call   8009dc <memmove>
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a62:	89 c6                	mov    %eax,%esi
  800a64:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a67:	39 f0                	cmp    %esi,%eax
  800a69:	74 1c                	je     800a87 <memcmp+0x30>
		if (*s1 != *s2)
  800a6b:	0f b6 08             	movzbl (%eax),%ecx
  800a6e:	0f b6 1a             	movzbl (%edx),%ebx
  800a71:	38 d9                	cmp    %bl,%cl
  800a73:	75 08                	jne    800a7d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a75:	83 c0 01             	add    $0x1,%eax
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	eb ea                	jmp    800a67 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a7d:	0f b6 c1             	movzbl %cl,%eax
  800a80:	0f b6 db             	movzbl %bl,%ebx
  800a83:	29 d8                	sub    %ebx,%eax
  800a85:	eb 05                	jmp    800a8c <memcmp+0x35>
	}

	return 0;
  800a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a8c:	5b                   	pop    %ebx
  800a8d:	5e                   	pop    %esi
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 45 08             	mov    0x8(%ebp),%eax
  800a96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a99:	89 c2                	mov    %eax,%edx
  800a9b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a9e:	39 d0                	cmp    %edx,%eax
  800aa0:	73 09                	jae    800aab <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa2:	38 08                	cmp    %cl,(%eax)
  800aa4:	74 05                	je     800aab <memfind+0x1b>
	for (; s < ends; s++)
  800aa6:	83 c0 01             	add    $0x1,%eax
  800aa9:	eb f3                	jmp    800a9e <memfind+0xe>
			break;
	return (void *) s;
}
  800aab:	5d                   	pop    %ebp
  800aac:	c3                   	ret    

00800aad <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	57                   	push   %edi
  800ab1:	56                   	push   %esi
  800ab2:	53                   	push   %ebx
  800ab3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ab6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab9:	eb 03                	jmp    800abe <strtol+0x11>
		s++;
  800abb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800abe:	0f b6 01             	movzbl (%ecx),%eax
  800ac1:	3c 20                	cmp    $0x20,%al
  800ac3:	74 f6                	je     800abb <strtol+0xe>
  800ac5:	3c 09                	cmp    $0x9,%al
  800ac7:	74 f2                	je     800abb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ac9:	3c 2b                	cmp    $0x2b,%al
  800acb:	74 2e                	je     800afb <strtol+0x4e>
	int neg = 0;
  800acd:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad2:	3c 2d                	cmp    $0x2d,%al
  800ad4:	74 2f                	je     800b05 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad6:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800adc:	75 05                	jne    800ae3 <strtol+0x36>
  800ade:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae1:	74 2c                	je     800b0f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae3:	85 db                	test   %ebx,%ebx
  800ae5:	75 0a                	jne    800af1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ae7:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aec:	80 39 30             	cmpb   $0x30,(%ecx)
  800aef:	74 28                	je     800b19 <strtol+0x6c>
		base = 10;
  800af1:	b8 00 00 00 00       	mov    $0x0,%eax
  800af6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800af9:	eb 50                	jmp    800b4b <strtol+0x9e>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800afe:	bf 00 00 00 00       	mov    $0x0,%edi
  800b03:	eb d1                	jmp    800ad6 <strtol+0x29>
		s++, neg = 1;
  800b05:	83 c1 01             	add    $0x1,%ecx
  800b08:	bf 01 00 00 00       	mov    $0x1,%edi
  800b0d:	eb c7                	jmp    800ad6 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b13:	74 0e                	je     800b23 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b15:	85 db                	test   %ebx,%ebx
  800b17:	75 d8                	jne    800af1 <strtol+0x44>
		s++, base = 8;
  800b19:	83 c1 01             	add    $0x1,%ecx
  800b1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b21:	eb ce                	jmp    800af1 <strtol+0x44>
		s += 2, base = 16;
  800b23:	83 c1 02             	add    $0x2,%ecx
  800b26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b2b:	eb c4                	jmp    800af1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b2d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b30:	89 f3                	mov    %esi,%ebx
  800b32:	80 fb 19             	cmp    $0x19,%bl
  800b35:	77 29                	ja     800b60 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b37:	0f be d2             	movsbl %dl,%edx
  800b3a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b3d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b40:	7d 30                	jge    800b72 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b42:	83 c1 01             	add    $0x1,%ecx
  800b45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b49:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b4b:	0f b6 11             	movzbl (%ecx),%edx
  800b4e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b51:	89 f3                	mov    %esi,%ebx
  800b53:	80 fb 09             	cmp    $0x9,%bl
  800b56:	77 d5                	ja     800b2d <strtol+0x80>
			dig = *s - '0';
  800b58:	0f be d2             	movsbl %dl,%edx
  800b5b:	83 ea 30             	sub    $0x30,%edx
  800b5e:	eb dd                	jmp    800b3d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b63:	89 f3                	mov    %esi,%ebx
  800b65:	80 fb 19             	cmp    $0x19,%bl
  800b68:	77 08                	ja     800b72 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b6a:	0f be d2             	movsbl %dl,%edx
  800b6d:	83 ea 37             	sub    $0x37,%edx
  800b70:	eb cb                	jmp    800b3d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 05                	je     800b7d <strtol+0xd0>
		*endptr = (char *) s;
  800b78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b7d:	89 c2                	mov    %eax,%edx
  800b7f:	f7 da                	neg    %edx
  800b81:	85 ff                	test   %edi,%edi
  800b83:	0f 45 c2             	cmovne %edx,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5f                   	pop    %edi
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	57                   	push   %edi
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	89 c7                	mov    %eax,%edi
  800ba0:	89 c6                	mov    %eax,%esi
  800ba2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5e                   	pop    %esi
  800ba6:	5f                   	pop    %edi
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800baf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb9:	89 d1                	mov    %edx,%ecx
  800bbb:	89 d3                	mov    %edx,%ebx
  800bbd:	89 d7                	mov    %edx,%edi
  800bbf:	89 d6                	mov    %edx,%esi
  800bc1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc3:	5b                   	pop    %ebx
  800bc4:	5e                   	pop    %esi
  800bc5:	5f                   	pop    %edi
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	57                   	push   %edi
  800bcc:	56                   	push   %esi
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800bde:	89 cb                	mov    %ecx,%ebx
  800be0:	89 cf                	mov    %ecx,%edi
  800be2:	89 ce                	mov    %ecx,%esi
  800be4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be6:	85 c0                	test   %eax,%eax
  800be8:	7f 08                	jg     800bf2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf2:	83 ec 0c             	sub    $0xc,%esp
  800bf5:	50                   	push   %eax
  800bf6:	6a 03                	push   $0x3
  800bf8:	68 7f 26 80 00       	push   $0x80267f
  800bfd:	6a 23                	push   $0x23
  800bff:	68 9c 26 80 00       	push   $0x80269c
  800c04:	e8 4b f5 ff ff       	call   800154 <_panic>

00800c09 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	57                   	push   %edi
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c14:	b8 02 00 00 00       	mov    $0x2,%eax
  800c19:	89 d1                	mov    %edx,%ecx
  800c1b:	89 d3                	mov    %edx,%ebx
  800c1d:	89 d7                	mov    %edx,%edi
  800c1f:	89 d6                	mov    %edx,%esi
  800c21:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    

00800c28 <sys_yield>:

void
sys_yield(void)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	57                   	push   %edi
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c33:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c38:	89 d1                	mov    %edx,%ecx
  800c3a:	89 d3                	mov    %edx,%ebx
  800c3c:	89 d7                	mov    %edx,%edi
  800c3e:	89 d6                	mov    %edx,%esi
  800c40:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c50:	be 00 00 00 00       	mov    $0x0,%esi
  800c55:	8b 55 08             	mov    0x8(%ebp),%edx
  800c58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5b:	b8 04 00 00 00       	mov    $0x4,%eax
  800c60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c63:	89 f7                	mov    %esi,%edi
  800c65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7f 08                	jg     800c73 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	50                   	push   %eax
  800c77:	6a 04                	push   $0x4
  800c79:	68 7f 26 80 00       	push   $0x80267f
  800c7e:	6a 23                	push   $0x23
  800c80:	68 9c 26 80 00       	push   $0x80269c
  800c85:	e8 ca f4 ff ff       	call   800154 <_panic>

00800c8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	b8 05 00 00 00       	mov    $0x5,%eax
  800c9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7f 08                	jg     800cb5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb5:	83 ec 0c             	sub    $0xc,%esp
  800cb8:	50                   	push   %eax
  800cb9:	6a 05                	push   $0x5
  800cbb:	68 7f 26 80 00       	push   $0x80267f
  800cc0:	6a 23                	push   $0x23
  800cc2:	68 9c 26 80 00       	push   $0x80269c
  800cc7:	e8 88 f4 ff ff       	call   800154 <_panic>

00800ccc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	57                   	push   %edi
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce0:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce5:	89 df                	mov    %ebx,%edi
  800ce7:	89 de                	mov    %ebx,%esi
  800ce9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ceb:	85 c0                	test   %eax,%eax
  800ced:	7f 08                	jg     800cf7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf7:	83 ec 0c             	sub    $0xc,%esp
  800cfa:	50                   	push   %eax
  800cfb:	6a 06                	push   $0x6
  800cfd:	68 7f 26 80 00       	push   $0x80267f
  800d02:	6a 23                	push   $0x23
  800d04:	68 9c 26 80 00       	push   $0x80269c
  800d09:	e8 46 f4 ff ff       	call   800154 <_panic>

00800d0e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
  800d14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d22:	b8 08 00 00 00       	mov    $0x8,%eax
  800d27:	89 df                	mov    %ebx,%edi
  800d29:	89 de                	mov    %ebx,%esi
  800d2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	7f 08                	jg     800d39 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d39:	83 ec 0c             	sub    $0xc,%esp
  800d3c:	50                   	push   %eax
  800d3d:	6a 08                	push   $0x8
  800d3f:	68 7f 26 80 00       	push   $0x80267f
  800d44:	6a 23                	push   $0x23
  800d46:	68 9c 26 80 00       	push   $0x80269c
  800d4b:	e8 04 f4 ff ff       	call   800154 <_panic>

00800d50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d64:	b8 09 00 00 00       	mov    $0x9,%eax
  800d69:	89 df                	mov    %ebx,%edi
  800d6b:	89 de                	mov    %ebx,%esi
  800d6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6f:	85 c0                	test   %eax,%eax
  800d71:	7f 08                	jg     800d7b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7b:	83 ec 0c             	sub    $0xc,%esp
  800d7e:	50                   	push   %eax
  800d7f:	6a 09                	push   $0x9
  800d81:	68 7f 26 80 00       	push   $0x80267f
  800d86:	6a 23                	push   $0x23
  800d88:	68 9c 26 80 00       	push   $0x80269c
  800d8d:	e8 c2 f3 ff ff       	call   800154 <_panic>

00800d92 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	57                   	push   %edi
  800d96:	56                   	push   %esi
  800d97:	53                   	push   %ebx
  800d98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dab:	89 df                	mov    %ebx,%edi
  800dad:	89 de                	mov    %ebx,%esi
  800daf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db1:	85 c0                	test   %eax,%eax
  800db3:	7f 08                	jg     800dbd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	83 ec 0c             	sub    $0xc,%esp
  800dc0:	50                   	push   %eax
  800dc1:	6a 0a                	push   $0xa
  800dc3:	68 7f 26 80 00       	push   $0x80267f
  800dc8:	6a 23                	push   $0x23
  800dca:	68 9c 26 80 00       	push   $0x80269c
  800dcf:	e8 80 f3 ff ff       	call   800154 <_panic>

00800dd4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de5:	be 00 00 00 00       	mov    $0x0,%esi
  800dea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ded:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    

00800df7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	57                   	push   %edi
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0d:	89 cb                	mov    %ecx,%ebx
  800e0f:	89 cf                	mov    %ecx,%edi
  800e11:	89 ce                	mov    %ecx,%esi
  800e13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	7f 08                	jg     800e21 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	50                   	push   %eax
  800e25:	6a 0d                	push   $0xd
  800e27:	68 7f 26 80 00       	push   $0x80267f
  800e2c:	6a 23                	push   $0x23
  800e2e:	68 9c 26 80 00       	push   $0x80269c
  800e33:	e8 1c f3 ff ff       	call   800154 <_panic>

00800e38 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	57                   	push   %edi
  800e3c:	56                   	push   %esi
  800e3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e43:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e48:	89 d1                	mov    %edx,%ecx
  800e4a:	89 d3                	mov    %edx,%ebx
  800e4c:	89 d7                	mov    %edx,%edi
  800e4e:	89 d6                	mov    %edx,%esi
  800e50:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5d:	05 00 00 00 30       	add    $0x30000000,%eax
  800e62:	c1 e8 0c             	shr    $0xc,%eax
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e77:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e84:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e89:	89 c2                	mov    %eax,%edx
  800e8b:	c1 ea 16             	shr    $0x16,%edx
  800e8e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e95:	f6 c2 01             	test   $0x1,%dl
  800e98:	74 2a                	je     800ec4 <fd_alloc+0x46>
  800e9a:	89 c2                	mov    %eax,%edx
  800e9c:	c1 ea 0c             	shr    $0xc,%edx
  800e9f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ea6:	f6 c2 01             	test   $0x1,%dl
  800ea9:	74 19                	je     800ec4 <fd_alloc+0x46>
  800eab:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eb0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eb5:	75 d2                	jne    800e89 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eb7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ebd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ec2:	eb 07                	jmp    800ecb <fd_alloc+0x4d>
			*fd_store = fd;
  800ec4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ed3:	83 f8 1f             	cmp    $0x1f,%eax
  800ed6:	77 36                	ja     800f0e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ed8:	c1 e0 0c             	shl    $0xc,%eax
  800edb:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ee0:	89 c2                	mov    %eax,%edx
  800ee2:	c1 ea 16             	shr    $0x16,%edx
  800ee5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eec:	f6 c2 01             	test   $0x1,%dl
  800eef:	74 24                	je     800f15 <fd_lookup+0x48>
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	c1 ea 0c             	shr    $0xc,%edx
  800ef6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800efd:	f6 c2 01             	test   $0x1,%dl
  800f00:	74 1a                	je     800f1c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f05:	89 02                	mov    %eax,(%edx)
	return 0;
  800f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0c:	5d                   	pop    %ebp
  800f0d:	c3                   	ret    
		return -E_INVAL;
  800f0e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f13:	eb f7                	jmp    800f0c <fd_lookup+0x3f>
		return -E_INVAL;
  800f15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1a:	eb f0                	jmp    800f0c <fd_lookup+0x3f>
  800f1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f21:	eb e9                	jmp    800f0c <fd_lookup+0x3f>

00800f23 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2c:	ba 2c 27 80 00       	mov    $0x80272c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f31:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f36:	39 08                	cmp    %ecx,(%eax)
  800f38:	74 33                	je     800f6d <dev_lookup+0x4a>
  800f3a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f3d:	8b 02                	mov    (%edx),%eax
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	75 f3                	jne    800f36 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f43:	a1 08 40 80 00       	mov    0x804008,%eax
  800f48:	8b 40 48             	mov    0x48(%eax),%eax
  800f4b:	83 ec 04             	sub    $0x4,%esp
  800f4e:	51                   	push   %ecx
  800f4f:	50                   	push   %eax
  800f50:	68 ac 26 80 00       	push   $0x8026ac
  800f55:	e8 d5 f2 ff ff       	call   80022f <cprintf>
	*dev = 0;
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f63:	83 c4 10             	add    $0x10,%esp
  800f66:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f6b:	c9                   	leave  
  800f6c:	c3                   	ret    
			*dev = devtab[i];
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
  800f77:	eb f2                	jmp    800f6b <dev_lookup+0x48>

00800f79 <fd_close>:
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 1c             	sub    $0x1c,%esp
  800f82:	8b 75 08             	mov    0x8(%ebp),%esi
  800f85:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f88:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f8b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f8c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f92:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f95:	50                   	push   %eax
  800f96:	e8 32 ff ff ff       	call   800ecd <fd_lookup>
  800f9b:	89 c3                	mov    %eax,%ebx
  800f9d:	83 c4 08             	add    $0x8,%esp
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	78 05                	js     800fa9 <fd_close+0x30>
	    || fd != fd2)
  800fa4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fa7:	74 16                	je     800fbf <fd_close+0x46>
		return (must_exist ? r : 0);
  800fa9:	89 f8                	mov    %edi,%eax
  800fab:	84 c0                	test   %al,%al
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	0f 44 d8             	cmove  %eax,%ebx
}
  800fb5:	89 d8                	mov    %ebx,%eax
  800fb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5f                   	pop    %edi
  800fbd:	5d                   	pop    %ebp
  800fbe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fbf:	83 ec 08             	sub    $0x8,%esp
  800fc2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fc5:	50                   	push   %eax
  800fc6:	ff 36                	pushl  (%esi)
  800fc8:	e8 56 ff ff ff       	call   800f23 <dev_lookup>
  800fcd:	89 c3                	mov    %eax,%ebx
  800fcf:	83 c4 10             	add    $0x10,%esp
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	78 15                	js     800feb <fd_close+0x72>
		if (dev->dev_close)
  800fd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd9:	8b 40 10             	mov    0x10(%eax),%eax
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	74 1b                	je     800ffb <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fe0:	83 ec 0c             	sub    $0xc,%esp
  800fe3:	56                   	push   %esi
  800fe4:	ff d0                	call   *%eax
  800fe6:	89 c3                	mov    %eax,%ebx
  800fe8:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800feb:	83 ec 08             	sub    $0x8,%esp
  800fee:	56                   	push   %esi
  800fef:	6a 00                	push   $0x0
  800ff1:	e8 d6 fc ff ff       	call   800ccc <sys_page_unmap>
	return r;
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	eb ba                	jmp    800fb5 <fd_close+0x3c>
			r = 0;
  800ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801000:	eb e9                	jmp    800feb <fd_close+0x72>

00801002 <close>:

int
close(int fdnum)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801008:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80100b:	50                   	push   %eax
  80100c:	ff 75 08             	pushl  0x8(%ebp)
  80100f:	e8 b9 fe ff ff       	call   800ecd <fd_lookup>
  801014:	83 c4 08             	add    $0x8,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	78 10                	js     80102b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80101b:	83 ec 08             	sub    $0x8,%esp
  80101e:	6a 01                	push   $0x1
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	e8 51 ff ff ff       	call   800f79 <fd_close>
  801028:	83 c4 10             	add    $0x10,%esp
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <close_all>:

void
close_all(void)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	53                   	push   %ebx
  801031:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801034:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801039:	83 ec 0c             	sub    $0xc,%esp
  80103c:	53                   	push   %ebx
  80103d:	e8 c0 ff ff ff       	call   801002 <close>
	for (i = 0; i < MAXFD; i++)
  801042:	83 c3 01             	add    $0x1,%ebx
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	83 fb 20             	cmp    $0x20,%ebx
  80104b:	75 ec                	jne    801039 <close_all+0xc>
}
  80104d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	57                   	push   %edi
  801056:	56                   	push   %esi
  801057:	53                   	push   %ebx
  801058:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80105b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80105e:	50                   	push   %eax
  80105f:	ff 75 08             	pushl  0x8(%ebp)
  801062:	e8 66 fe ff ff       	call   800ecd <fd_lookup>
  801067:	89 c3                	mov    %eax,%ebx
  801069:	83 c4 08             	add    $0x8,%esp
  80106c:	85 c0                	test   %eax,%eax
  80106e:	0f 88 81 00 00 00    	js     8010f5 <dup+0xa3>
		return r;
	close(newfdnum);
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	ff 75 0c             	pushl  0xc(%ebp)
  80107a:	e8 83 ff ff ff       	call   801002 <close>

	newfd = INDEX2FD(newfdnum);
  80107f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801082:	c1 e6 0c             	shl    $0xc,%esi
  801085:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80108b:	83 c4 04             	add    $0x4,%esp
  80108e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801091:	e8 d1 fd ff ff       	call   800e67 <fd2data>
  801096:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801098:	89 34 24             	mov    %esi,(%esp)
  80109b:	e8 c7 fd ff ff       	call   800e67 <fd2data>
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010a5:	89 d8                	mov    %ebx,%eax
  8010a7:	c1 e8 16             	shr    $0x16,%eax
  8010aa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010b1:	a8 01                	test   $0x1,%al
  8010b3:	74 11                	je     8010c6 <dup+0x74>
  8010b5:	89 d8                	mov    %ebx,%eax
  8010b7:	c1 e8 0c             	shr    $0xc,%eax
  8010ba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010c1:	f6 c2 01             	test   $0x1,%dl
  8010c4:	75 39                	jne    8010ff <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
  8010ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d5:	83 ec 0c             	sub    $0xc,%esp
  8010d8:	25 07 0e 00 00       	and    $0xe07,%eax
  8010dd:	50                   	push   %eax
  8010de:	56                   	push   %esi
  8010df:	6a 00                	push   $0x0
  8010e1:	52                   	push   %edx
  8010e2:	6a 00                	push   $0x0
  8010e4:	e8 a1 fb ff ff       	call   800c8a <sys_page_map>
  8010e9:	89 c3                	mov    %eax,%ebx
  8010eb:	83 c4 20             	add    $0x20,%esp
  8010ee:	85 c0                	test   %eax,%eax
  8010f0:	78 31                	js     801123 <dup+0xd1>
		goto err;

	return newfdnum;
  8010f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010f5:	89 d8                	mov    %ebx,%eax
  8010f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fa:	5b                   	pop    %ebx
  8010fb:	5e                   	pop    %esi
  8010fc:	5f                   	pop    %edi
  8010fd:	5d                   	pop    %ebp
  8010fe:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	25 07 0e 00 00       	and    $0xe07,%eax
  80110e:	50                   	push   %eax
  80110f:	57                   	push   %edi
  801110:	6a 00                	push   $0x0
  801112:	53                   	push   %ebx
  801113:	6a 00                	push   $0x0
  801115:	e8 70 fb ff ff       	call   800c8a <sys_page_map>
  80111a:	89 c3                	mov    %eax,%ebx
  80111c:	83 c4 20             	add    $0x20,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	79 a3                	jns    8010c6 <dup+0x74>
	sys_page_unmap(0, newfd);
  801123:	83 ec 08             	sub    $0x8,%esp
  801126:	56                   	push   %esi
  801127:	6a 00                	push   $0x0
  801129:	e8 9e fb ff ff       	call   800ccc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80112e:	83 c4 08             	add    $0x8,%esp
  801131:	57                   	push   %edi
  801132:	6a 00                	push   $0x0
  801134:	e8 93 fb ff ff       	call   800ccc <sys_page_unmap>
	return r;
  801139:	83 c4 10             	add    $0x10,%esp
  80113c:	eb b7                	jmp    8010f5 <dup+0xa3>

0080113e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	53                   	push   %ebx
  801142:	83 ec 14             	sub    $0x14,%esp
  801145:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801148:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80114b:	50                   	push   %eax
  80114c:	53                   	push   %ebx
  80114d:	e8 7b fd ff ff       	call   800ecd <fd_lookup>
  801152:	83 c4 08             	add    $0x8,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	78 3f                	js     801198 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115f:	50                   	push   %eax
  801160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801163:	ff 30                	pushl  (%eax)
  801165:	e8 b9 fd ff ff       	call   800f23 <dev_lookup>
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	78 27                	js     801198 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801171:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801174:	8b 42 08             	mov    0x8(%edx),%eax
  801177:	83 e0 03             	and    $0x3,%eax
  80117a:	83 f8 01             	cmp    $0x1,%eax
  80117d:	74 1e                	je     80119d <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80117f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801182:	8b 40 08             	mov    0x8(%eax),%eax
  801185:	85 c0                	test   %eax,%eax
  801187:	74 35                	je     8011be <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801189:	83 ec 04             	sub    $0x4,%esp
  80118c:	ff 75 10             	pushl  0x10(%ebp)
  80118f:	ff 75 0c             	pushl  0xc(%ebp)
  801192:	52                   	push   %edx
  801193:	ff d0                	call   *%eax
  801195:	83 c4 10             	add    $0x10,%esp
}
  801198:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80119b:	c9                   	leave  
  80119c:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80119d:	a1 08 40 80 00       	mov    0x804008,%eax
  8011a2:	8b 40 48             	mov    0x48(%eax),%eax
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	53                   	push   %ebx
  8011a9:	50                   	push   %eax
  8011aa:	68 f0 26 80 00       	push   $0x8026f0
  8011af:	e8 7b f0 ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  8011b4:	83 c4 10             	add    $0x10,%esp
  8011b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011bc:	eb da                	jmp    801198 <read+0x5a>
		return -E_NOT_SUPP;
  8011be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c3:	eb d3                	jmp    801198 <read+0x5a>

008011c5 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	57                   	push   %edi
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 0c             	sub    $0xc,%esp
  8011ce:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d9:	39 f3                	cmp    %esi,%ebx
  8011db:	73 25                	jae    801202 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	89 f0                	mov    %esi,%eax
  8011e2:	29 d8                	sub    %ebx,%eax
  8011e4:	50                   	push   %eax
  8011e5:	89 d8                	mov    %ebx,%eax
  8011e7:	03 45 0c             	add    0xc(%ebp),%eax
  8011ea:	50                   	push   %eax
  8011eb:	57                   	push   %edi
  8011ec:	e8 4d ff ff ff       	call   80113e <read>
		if (m < 0)
  8011f1:	83 c4 10             	add    $0x10,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	78 08                	js     801200 <readn+0x3b>
			return m;
		if (m == 0)
  8011f8:	85 c0                	test   %eax,%eax
  8011fa:	74 06                	je     801202 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011fc:	01 c3                	add    %eax,%ebx
  8011fe:	eb d9                	jmp    8011d9 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801200:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801202:	89 d8                	mov    %ebx,%eax
  801204:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	53                   	push   %ebx
  801210:	83 ec 14             	sub    $0x14,%esp
  801213:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801216:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801219:	50                   	push   %eax
  80121a:	53                   	push   %ebx
  80121b:	e8 ad fc ff ff       	call   800ecd <fd_lookup>
  801220:	83 c4 08             	add    $0x8,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	78 3a                	js     801261 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122d:	50                   	push   %eax
  80122e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801231:	ff 30                	pushl  (%eax)
  801233:	e8 eb fc ff ff       	call   800f23 <dev_lookup>
  801238:	83 c4 10             	add    $0x10,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	78 22                	js     801261 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801246:	74 1e                	je     801266 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124b:	8b 52 0c             	mov    0xc(%edx),%edx
  80124e:	85 d2                	test   %edx,%edx
  801250:	74 35                	je     801287 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801252:	83 ec 04             	sub    $0x4,%esp
  801255:	ff 75 10             	pushl  0x10(%ebp)
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	50                   	push   %eax
  80125c:	ff d2                	call   *%edx
  80125e:	83 c4 10             	add    $0x10,%esp
}
  801261:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801264:	c9                   	leave  
  801265:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801266:	a1 08 40 80 00       	mov    0x804008,%eax
  80126b:	8b 40 48             	mov    0x48(%eax),%eax
  80126e:	83 ec 04             	sub    $0x4,%esp
  801271:	53                   	push   %ebx
  801272:	50                   	push   %eax
  801273:	68 0c 27 80 00       	push   $0x80270c
  801278:	e8 b2 ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  80127d:	83 c4 10             	add    $0x10,%esp
  801280:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801285:	eb da                	jmp    801261 <write+0x55>
		return -E_NOT_SUPP;
  801287:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80128c:	eb d3                	jmp    801261 <write+0x55>

0080128e <seek>:

int
seek(int fdnum, off_t offset)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801294:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801297:	50                   	push   %eax
  801298:	ff 75 08             	pushl  0x8(%ebp)
  80129b:	e8 2d fc ff ff       	call   800ecd <fd_lookup>
  8012a0:	83 c4 08             	add    $0x8,%esp
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	78 0e                	js     8012b5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ad:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    

008012b7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	53                   	push   %ebx
  8012bb:	83 ec 14             	sub    $0x14,%esp
  8012be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c4:	50                   	push   %eax
  8012c5:	53                   	push   %ebx
  8012c6:	e8 02 fc ff ff       	call   800ecd <fd_lookup>
  8012cb:	83 c4 08             	add    $0x8,%esp
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	78 37                	js     801309 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d2:	83 ec 08             	sub    $0x8,%esp
  8012d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d8:	50                   	push   %eax
  8012d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012dc:	ff 30                	pushl  (%eax)
  8012de:	e8 40 fc ff ff       	call   800f23 <dev_lookup>
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	85 c0                	test   %eax,%eax
  8012e8:	78 1f                	js     801309 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012f1:	74 1b                	je     80130e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f6:	8b 52 18             	mov    0x18(%edx),%edx
  8012f9:	85 d2                	test   %edx,%edx
  8012fb:	74 32                	je     80132f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	ff 75 0c             	pushl  0xc(%ebp)
  801303:	50                   	push   %eax
  801304:	ff d2                	call   *%edx
  801306:	83 c4 10             	add    $0x10,%esp
}
  801309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80130c:	c9                   	leave  
  80130d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80130e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801313:	8b 40 48             	mov    0x48(%eax),%eax
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	53                   	push   %ebx
  80131a:	50                   	push   %eax
  80131b:	68 cc 26 80 00       	push   $0x8026cc
  801320:	e8 0a ef ff ff       	call   80022f <cprintf>
		return -E_INVAL;
  801325:	83 c4 10             	add    $0x10,%esp
  801328:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132d:	eb da                	jmp    801309 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80132f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801334:	eb d3                	jmp    801309 <ftruncate+0x52>

00801336 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
  801339:	53                   	push   %ebx
  80133a:	83 ec 14             	sub    $0x14,%esp
  80133d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801340:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801343:	50                   	push   %eax
  801344:	ff 75 08             	pushl  0x8(%ebp)
  801347:	e8 81 fb ff ff       	call   800ecd <fd_lookup>
  80134c:	83 c4 08             	add    $0x8,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 4b                	js     80139e <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801353:	83 ec 08             	sub    $0x8,%esp
  801356:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801359:	50                   	push   %eax
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	ff 30                	pushl  (%eax)
  80135f:	e8 bf fb ff ff       	call   800f23 <dev_lookup>
  801364:	83 c4 10             	add    $0x10,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 33                	js     80139e <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136e:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801372:	74 2f                	je     8013a3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801374:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801377:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80137e:	00 00 00 
	stat->st_isdir = 0;
  801381:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801388:	00 00 00 
	stat->st_dev = dev;
  80138b:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	53                   	push   %ebx
  801395:	ff 75 f0             	pushl  -0x10(%ebp)
  801398:	ff 50 14             	call   *0x14(%eax)
  80139b:	83 c4 10             	add    $0x10,%esp
}
  80139e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    
		return -E_NOT_SUPP;
  8013a3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a8:	eb f4                	jmp    80139e <fstat+0x68>

008013aa <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	56                   	push   %esi
  8013ae:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013af:	83 ec 08             	sub    $0x8,%esp
  8013b2:	6a 00                	push   $0x0
  8013b4:	ff 75 08             	pushl  0x8(%ebp)
  8013b7:	e8 e7 01 00 00       	call   8015a3 <open>
  8013bc:	89 c3                	mov    %eax,%ebx
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	78 1b                	js     8013e0 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	50                   	push   %eax
  8013cc:	e8 65 ff ff ff       	call   801336 <fstat>
  8013d1:	89 c6                	mov    %eax,%esi
	close(fd);
  8013d3:	89 1c 24             	mov    %ebx,(%esp)
  8013d6:	e8 27 fc ff ff       	call   801002 <close>
	return r;
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	89 f3                	mov    %esi,%ebx
}
  8013e0:	89 d8                	mov    %ebx,%eax
  8013e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e5:	5b                   	pop    %ebx
  8013e6:	5e                   	pop    %esi
  8013e7:	5d                   	pop    %ebp
  8013e8:	c3                   	ret    

008013e9 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
  8013ec:	56                   	push   %esi
  8013ed:	53                   	push   %ebx
  8013ee:	89 c6                	mov    %eax,%esi
  8013f0:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013f2:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013f9:	74 27                	je     801422 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013fb:	6a 07                	push   $0x7
  8013fd:	68 00 50 80 00       	push   $0x805000
  801402:	56                   	push   %esi
  801403:	ff 35 00 40 80 00    	pushl  0x804000
  801409:	e8 d0 0b 00 00       	call   801fde <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80140e:	83 c4 0c             	add    $0xc,%esp
  801411:	6a 00                	push   $0x0
  801413:	53                   	push   %ebx
  801414:	6a 00                	push   $0x0
  801416:	e8 5c 0b 00 00       	call   801f77 <ipc_recv>
}
  80141b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80141e:	5b                   	pop    %ebx
  80141f:	5e                   	pop    %esi
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801422:	83 ec 0c             	sub    $0xc,%esp
  801425:	6a 01                	push   $0x1
  801427:	e8 06 0c 00 00       	call   802032 <ipc_find_env>
  80142c:	a3 00 40 80 00       	mov    %eax,0x804000
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	eb c5                	jmp    8013fb <fsipc+0x12>

00801436 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8b 40 0c             	mov    0xc(%eax),%eax
  801442:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80144f:	ba 00 00 00 00       	mov    $0x0,%edx
  801454:	b8 02 00 00 00       	mov    $0x2,%eax
  801459:	e8 8b ff ff ff       	call   8013e9 <fsipc>
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <devfile_flush>:
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8b 40 0c             	mov    0xc(%eax),%eax
  80146c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801471:	ba 00 00 00 00       	mov    $0x0,%edx
  801476:	b8 06 00 00 00       	mov    $0x6,%eax
  80147b:	e8 69 ff ff ff       	call   8013e9 <fsipc>
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <devfile_stat>:
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	53                   	push   %ebx
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8b 40 0c             	mov    0xc(%eax),%eax
  801492:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801497:	ba 00 00 00 00       	mov    $0x0,%edx
  80149c:	b8 05 00 00 00       	mov    $0x5,%eax
  8014a1:	e8 43 ff ff ff       	call   8013e9 <fsipc>
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 2c                	js     8014d6 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	68 00 50 80 00       	push   $0x805000
  8014b2:	53                   	push   %ebx
  8014b3:	e8 96 f3 ff ff       	call   80084e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014b8:	a1 80 50 80 00       	mov    0x805080,%eax
  8014bd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014c3:	a1 84 50 80 00       	mov    0x805084,%eax
  8014c8:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <devfile_write>:
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 0c             	sub    $0xc,%esp
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014e9:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014ee:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8014f7:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8014fd:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801502:	50                   	push   %eax
  801503:	ff 75 0c             	pushl  0xc(%ebp)
  801506:	68 08 50 80 00       	push   $0x805008
  80150b:	e8 cc f4 ff ff       	call   8009dc <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801510:	ba 00 00 00 00       	mov    $0x0,%edx
  801515:	b8 04 00 00 00       	mov    $0x4,%eax
  80151a:	e8 ca fe ff ff       	call   8013e9 <fsipc>
}
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <devfile_read>:
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801529:	8b 45 08             	mov    0x8(%ebp),%eax
  80152c:	8b 40 0c             	mov    0xc(%eax),%eax
  80152f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801534:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80153a:	ba 00 00 00 00       	mov    $0x0,%edx
  80153f:	b8 03 00 00 00       	mov    $0x3,%eax
  801544:	e8 a0 fe ff ff       	call   8013e9 <fsipc>
  801549:	89 c3                	mov    %eax,%ebx
  80154b:	85 c0                	test   %eax,%eax
  80154d:	78 1f                	js     80156e <devfile_read+0x4d>
	assert(r <= n);
  80154f:	39 f0                	cmp    %esi,%eax
  801551:	77 24                	ja     801577 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801553:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801558:	7f 33                	jg     80158d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	50                   	push   %eax
  80155e:	68 00 50 80 00       	push   $0x805000
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	e8 71 f4 ff ff       	call   8009dc <memmove>
	return r;
  80156b:	83 c4 10             	add    $0x10,%esp
}
  80156e:	89 d8                	mov    %ebx,%eax
  801570:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801573:	5b                   	pop    %ebx
  801574:	5e                   	pop    %esi
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    
	assert(r <= n);
  801577:	68 40 27 80 00       	push   $0x802740
  80157c:	68 47 27 80 00       	push   $0x802747
  801581:	6a 7b                	push   $0x7b
  801583:	68 5c 27 80 00       	push   $0x80275c
  801588:	e8 c7 eb ff ff       	call   800154 <_panic>
	assert(r <= PGSIZE);
  80158d:	68 67 27 80 00       	push   $0x802767
  801592:	68 47 27 80 00       	push   $0x802747
  801597:	6a 7c                	push   $0x7c
  801599:	68 5c 27 80 00       	push   $0x80275c
  80159e:	e8 b1 eb ff ff       	call   800154 <_panic>

008015a3 <open>:
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 1c             	sub    $0x1c,%esp
  8015ab:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015ae:	56                   	push   %esi
  8015af:	e8 63 f2 ff ff       	call   800817 <strlen>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015bc:	7f 6c                	jg     80162a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015be:	83 ec 0c             	sub    $0xc,%esp
  8015c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c4:	50                   	push   %eax
  8015c5:	e8 b4 f8 ff ff       	call   800e7e <fd_alloc>
  8015ca:	89 c3                	mov    %eax,%ebx
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 3c                	js     80160f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015d3:	83 ec 08             	sub    $0x8,%esp
  8015d6:	56                   	push   %esi
  8015d7:	68 00 50 80 00       	push   $0x805000
  8015dc:	e8 6d f2 ff ff       	call   80084e <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8015e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f1:	e8 f3 fd ff ff       	call   8013e9 <fsipc>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 19                	js     801618 <open+0x75>
	return fd2num(fd);
  8015ff:	83 ec 0c             	sub    $0xc,%esp
  801602:	ff 75 f4             	pushl  -0xc(%ebp)
  801605:	e8 4d f8 ff ff       	call   800e57 <fd2num>
  80160a:	89 c3                	mov    %eax,%ebx
  80160c:	83 c4 10             	add    $0x10,%esp
}
  80160f:	89 d8                	mov    %ebx,%eax
  801611:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801614:	5b                   	pop    %ebx
  801615:	5e                   	pop    %esi
  801616:	5d                   	pop    %ebp
  801617:	c3                   	ret    
		fd_close(fd, 0);
  801618:	83 ec 08             	sub    $0x8,%esp
  80161b:	6a 00                	push   $0x0
  80161d:	ff 75 f4             	pushl  -0xc(%ebp)
  801620:	e8 54 f9 ff ff       	call   800f79 <fd_close>
		return r;
  801625:	83 c4 10             	add    $0x10,%esp
  801628:	eb e5                	jmp    80160f <open+0x6c>
		return -E_BAD_PATH;
  80162a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80162f:	eb de                	jmp    80160f <open+0x6c>

00801631 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	b8 08 00 00 00       	mov    $0x8,%eax
  801641:	e8 a3 fd ff ff       	call   8013e9 <fsipc>
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80164e:	68 73 27 80 00       	push   $0x802773
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	e8 f3 f1 ff ff       	call   80084e <strcpy>
	return 0;
}
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <devsock_close>:
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	53                   	push   %ebx
  801666:	83 ec 10             	sub    $0x10,%esp
  801669:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80166c:	53                   	push   %ebx
  80166d:	e8 f9 09 00 00       	call   80206b <pageref>
  801672:	83 c4 10             	add    $0x10,%esp
		return 0;
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80167a:	83 f8 01             	cmp    $0x1,%eax
  80167d:	74 07                	je     801686 <devsock_close+0x24>
}
  80167f:	89 d0                	mov    %edx,%eax
  801681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801684:	c9                   	leave  
  801685:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801686:	83 ec 0c             	sub    $0xc,%esp
  801689:	ff 73 0c             	pushl  0xc(%ebx)
  80168c:	e8 b7 02 00 00       	call   801948 <nsipc_close>
  801691:	89 c2                	mov    %eax,%edx
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	eb e7                	jmp    80167f <devsock_close+0x1d>

00801698 <devsock_write>:
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	ff 75 10             	pushl  0x10(%ebp)
  8016a3:	ff 75 0c             	pushl  0xc(%ebp)
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	ff 70 0c             	pushl  0xc(%eax)
  8016ac:	e8 74 03 00 00       	call   801a25 <nsipc_send>
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <devsock_read>:
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	ff 75 10             	pushl  0x10(%ebp)
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	ff 70 0c             	pushl  0xc(%eax)
  8016c7:	e8 ed 02 00 00       	call   8019b9 <nsipc_recv>
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <fd2sockid>:
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016d4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016d7:	52                   	push   %edx
  8016d8:	50                   	push   %eax
  8016d9:	e8 ef f7 ff ff       	call   800ecd <fd_lookup>
  8016de:	83 c4 10             	add    $0x10,%esp
  8016e1:	85 c0                	test   %eax,%eax
  8016e3:	78 10                	js     8016f5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e8:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016ee:	39 08                	cmp    %ecx,(%eax)
  8016f0:	75 05                	jne    8016f7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    
		return -E_NOT_SUPP;
  8016f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016fc:	eb f7                	jmp    8016f5 <fd2sockid+0x27>

008016fe <alloc_sockfd>:
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
  801703:	83 ec 1c             	sub    $0x1c,%esp
  801706:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801708:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170b:	50                   	push   %eax
  80170c:	e8 6d f7 ff ff       	call   800e7e <fd_alloc>
  801711:	89 c3                	mov    %eax,%ebx
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	78 43                	js     80175d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	68 07 04 00 00       	push   $0x407
  801722:	ff 75 f4             	pushl  -0xc(%ebp)
  801725:	6a 00                	push   $0x0
  801727:	e8 1b f5 ff ff       	call   800c47 <sys_page_alloc>
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	85 c0                	test   %eax,%eax
  801733:	78 28                	js     80175d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801738:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80173e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801743:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80174a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	50                   	push   %eax
  801751:	e8 01 f7 ff ff       	call   800e57 <fd2num>
  801756:	89 c3                	mov    %eax,%ebx
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	eb 0c                	jmp    801769 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80175d:	83 ec 0c             	sub    $0xc,%esp
  801760:	56                   	push   %esi
  801761:	e8 e2 01 00 00       	call   801948 <nsipc_close>
		return r;
  801766:	83 c4 10             	add    $0x10,%esp
}
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176e:	5b                   	pop    %ebx
  80176f:	5e                   	pop    %esi
  801770:	5d                   	pop    %ebp
  801771:	c3                   	ret    

00801772 <accept>:
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	e8 4e ff ff ff       	call   8016ce <fd2sockid>
  801780:	85 c0                	test   %eax,%eax
  801782:	78 1b                	js     80179f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	ff 75 10             	pushl  0x10(%ebp)
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	50                   	push   %eax
  80178e:	e8 0e 01 00 00       	call   8018a1 <nsipc_accept>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	85 c0                	test   %eax,%eax
  801798:	78 05                	js     80179f <accept+0x2d>
	return alloc_sockfd(r);
  80179a:	e8 5f ff ff ff       	call   8016fe <alloc_sockfd>
}
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    

008017a1 <bind>:
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	e8 1f ff ff ff       	call   8016ce <fd2sockid>
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 12                	js     8017c5 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	ff 75 10             	pushl  0x10(%ebp)
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	50                   	push   %eax
  8017bd:	e8 2f 01 00 00       	call   8018f1 <nsipc_bind>
  8017c2:	83 c4 10             	add    $0x10,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <shutdown>:
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	e8 f9 fe ff ff       	call   8016ce <fd2sockid>
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 0f                	js     8017e8 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8017d9:	83 ec 08             	sub    $0x8,%esp
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	50                   	push   %eax
  8017e0:	e8 41 01 00 00       	call   801926 <nsipc_shutdown>
  8017e5:	83 c4 10             	add    $0x10,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <connect>:
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	e8 d6 fe ff ff       	call   8016ce <fd2sockid>
  8017f8:	85 c0                	test   %eax,%eax
  8017fa:	78 12                	js     80180e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	ff 75 10             	pushl  0x10(%ebp)
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	50                   	push   %eax
  801806:	e8 57 01 00 00       	call   801962 <nsipc_connect>
  80180b:	83 c4 10             	add    $0x10,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <listen>:
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	e8 b0 fe ff ff       	call   8016ce <fd2sockid>
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 0f                	js     801831 <listen+0x21>
	return nsipc_listen(r, backlog);
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	50                   	push   %eax
  801829:	e8 69 01 00 00       	call   801997 <nsipc_listen>
  80182e:	83 c4 10             	add    $0x10,%esp
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <socket>:

int
socket(int domain, int type, int protocol)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801839:	ff 75 10             	pushl  0x10(%ebp)
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 3c 02 00 00       	call   801a83 <nsipc_socket>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	85 c0                	test   %eax,%eax
  80184c:	78 05                	js     801853 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80184e:	e8 ab fe ff ff       	call   8016fe <alloc_sockfd>
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	53                   	push   %ebx
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80185e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801865:	74 26                	je     80188d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801867:	6a 07                	push   $0x7
  801869:	68 00 60 80 00       	push   $0x806000
  80186e:	53                   	push   %ebx
  80186f:	ff 35 04 40 80 00    	pushl  0x804004
  801875:	e8 64 07 00 00       	call   801fde <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80187a:	83 c4 0c             	add    $0xc,%esp
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	e8 ef 06 00 00       	call   801f77 <ipc_recv>
}
  801888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80188d:	83 ec 0c             	sub    $0xc,%esp
  801890:	6a 02                	push   $0x2
  801892:	e8 9b 07 00 00       	call   802032 <ipc_find_env>
  801897:	a3 04 40 80 00       	mov    %eax,0x804004
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	eb c6                	jmp    801867 <nsipc+0x12>

008018a1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	56                   	push   %esi
  8018a5:	53                   	push   %ebx
  8018a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8018b1:	8b 06                	mov    (%esi),%eax
  8018b3:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018bd:	e8 93 ff ff ff       	call   801855 <nsipc>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 20                	js     8018e8 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018c8:	83 ec 04             	sub    $0x4,%esp
  8018cb:	ff 35 10 60 80 00    	pushl  0x806010
  8018d1:	68 00 60 80 00       	push   $0x806000
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	e8 fe f0 ff ff       	call   8009dc <memmove>
		*addrlen = ret->ret_addrlen;
  8018de:	a1 10 60 80 00       	mov    0x806010,%eax
  8018e3:	89 06                	mov    %eax,(%esi)
  8018e5:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8018e8:	89 d8                	mov    %ebx,%eax
  8018ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 08             	sub    $0x8,%esp
  8018f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801903:	53                   	push   %ebx
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	68 04 60 80 00       	push   $0x806004
  80190c:	e8 cb f0 ff ff       	call   8009dc <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801911:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801917:	b8 02 00 00 00       	mov    $0x2,%eax
  80191c:	e8 34 ff ff ff       	call   801855 <nsipc>
}
  801921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80193c:	b8 03 00 00 00       	mov    $0x3,%eax
  801941:	e8 0f ff ff ff       	call   801855 <nsipc>
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <nsipc_close>:

int
nsipc_close(int s)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801956:	b8 04 00 00 00       	mov    $0x4,%eax
  80195b:	e8 f5 fe ff ff       	call   801855 <nsipc>
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	53                   	push   %ebx
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801974:	53                   	push   %ebx
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	68 04 60 80 00       	push   $0x806004
  80197d:	e8 5a f0 ff ff       	call   8009dc <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801982:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801988:	b8 05 00 00 00       	mov    $0x5,%eax
  80198d:	e8 c3 fe ff ff       	call   801855 <nsipc>
}
  801992:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8019ad:	b8 06 00 00 00       	mov    $0x6,%eax
  8019b2:	e8 9e fe ff ff       	call   801855 <nsipc>
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	56                   	push   %esi
  8019bd:	53                   	push   %ebx
  8019be:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8019c9:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8019cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d2:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8019d7:	b8 07 00 00 00       	mov    $0x7,%eax
  8019dc:	e8 74 fe ff ff       	call   801855 <nsipc>
  8019e1:	89 c3                	mov    %eax,%ebx
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 1f                	js     801a06 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8019e7:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8019ec:	7f 21                	jg     801a0f <nsipc_recv+0x56>
  8019ee:	39 c6                	cmp    %eax,%esi
  8019f0:	7c 1d                	jl     801a0f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	50                   	push   %eax
  8019f6:	68 00 60 80 00       	push   $0x806000
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	e8 d9 ef ff ff       	call   8009dc <memmove>
  801a03:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a06:	89 d8                	mov    %ebx,%eax
  801a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a0f:	68 7f 27 80 00       	push   $0x80277f
  801a14:	68 47 27 80 00       	push   $0x802747
  801a19:	6a 62                	push   $0x62
  801a1b:	68 94 27 80 00       	push   $0x802794
  801a20:	e8 2f e7 ff ff       	call   800154 <_panic>

00801a25 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 04             	sub    $0x4,%esp
  801a2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a37:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a3d:	7f 2e                	jg     801a6d <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	53                   	push   %ebx
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	68 0c 60 80 00       	push   $0x80600c
  801a4b:	e8 8c ef ff ff       	call   8009dc <memmove>
	nsipcbuf.send.req_size = size;
  801a50:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801a56:	8b 45 14             	mov    0x14(%ebp),%eax
  801a59:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801a5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a63:	e8 ed fd ff ff       	call   801855 <nsipc>
}
  801a68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    
	assert(size < 1600);
  801a6d:	68 a0 27 80 00       	push   $0x8027a0
  801a72:	68 47 27 80 00       	push   $0x802747
  801a77:	6a 6d                	push   $0x6d
  801a79:	68 94 27 80 00       	push   $0x802794
  801a7e:	e8 d1 e6 ff ff       	call   800154 <_panic>

00801a83 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801a99:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801aa1:	b8 09 00 00 00       	mov    $0x9,%eax
  801aa6:	e8 aa fd ff ff       	call   801855 <nsipc>
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	56                   	push   %esi
  801ab1:	53                   	push   %ebx
  801ab2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ab5:	83 ec 0c             	sub    $0xc,%esp
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	e8 a7 f3 ff ff       	call   800e67 <fd2data>
  801ac0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ac2:	83 c4 08             	add    $0x8,%esp
  801ac5:	68 ac 27 80 00       	push   $0x8027ac
  801aca:	53                   	push   %ebx
  801acb:	e8 7e ed ff ff       	call   80084e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ad0:	8b 46 04             	mov    0x4(%esi),%eax
  801ad3:	2b 06                	sub    (%esi),%eax
  801ad5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801adb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ae2:	00 00 00 
	stat->st_dev = &devpipe;
  801ae5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801aec:	30 80 00 
	return 0;
}
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af7:	5b                   	pop    %ebx
  801af8:	5e                   	pop    %esi
  801af9:	5d                   	pop    %ebp
  801afa:	c3                   	ret    

00801afb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	53                   	push   %ebx
  801aff:	83 ec 0c             	sub    $0xc,%esp
  801b02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b05:	53                   	push   %ebx
  801b06:	6a 00                	push   $0x0
  801b08:	e8 bf f1 ff ff       	call   800ccc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b0d:	89 1c 24             	mov    %ebx,(%esp)
  801b10:	e8 52 f3 ff ff       	call   800e67 <fd2data>
  801b15:	83 c4 08             	add    $0x8,%esp
  801b18:	50                   	push   %eax
  801b19:	6a 00                	push   $0x0
  801b1b:	e8 ac f1 ff ff       	call   800ccc <sys_page_unmap>
}
  801b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <_pipeisclosed>:
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	57                   	push   %edi
  801b29:	56                   	push   %esi
  801b2a:	53                   	push   %ebx
  801b2b:	83 ec 1c             	sub    $0x1c,%esp
  801b2e:	89 c7                	mov    %eax,%edi
  801b30:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b32:	a1 08 40 80 00       	mov    0x804008,%eax
  801b37:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b3a:	83 ec 0c             	sub    $0xc,%esp
  801b3d:	57                   	push   %edi
  801b3e:	e8 28 05 00 00       	call   80206b <pageref>
  801b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b46:	89 34 24             	mov    %esi,(%esp)
  801b49:	e8 1d 05 00 00       	call   80206b <pageref>
		nn = thisenv->env_runs;
  801b4e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b54:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	39 cb                	cmp    %ecx,%ebx
  801b5c:	74 1b                	je     801b79 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b5e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b61:	75 cf                	jne    801b32 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b63:	8b 42 58             	mov    0x58(%edx),%eax
  801b66:	6a 01                	push   $0x1
  801b68:	50                   	push   %eax
  801b69:	53                   	push   %ebx
  801b6a:	68 b3 27 80 00       	push   $0x8027b3
  801b6f:	e8 bb e6 ff ff       	call   80022f <cprintf>
  801b74:	83 c4 10             	add    $0x10,%esp
  801b77:	eb b9                	jmp    801b32 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b79:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b7c:	0f 94 c0             	sete   %al
  801b7f:	0f b6 c0             	movzbl %al,%eax
}
  801b82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b85:	5b                   	pop    %ebx
  801b86:	5e                   	pop    %esi
  801b87:	5f                   	pop    %edi
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    

00801b8a <devpipe_write>:
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	57                   	push   %edi
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 28             	sub    $0x28,%esp
  801b93:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b96:	56                   	push   %esi
  801b97:	e8 cb f2 ff ff       	call   800e67 <fd2data>
  801b9c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b9e:	83 c4 10             	add    $0x10,%esp
  801ba1:	bf 00 00 00 00       	mov    $0x0,%edi
  801ba6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ba9:	74 4f                	je     801bfa <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bab:	8b 43 04             	mov    0x4(%ebx),%eax
  801bae:	8b 0b                	mov    (%ebx),%ecx
  801bb0:	8d 51 20             	lea    0x20(%ecx),%edx
  801bb3:	39 d0                	cmp    %edx,%eax
  801bb5:	72 14                	jb     801bcb <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bb7:	89 da                	mov    %ebx,%edx
  801bb9:	89 f0                	mov    %esi,%eax
  801bbb:	e8 65 ff ff ff       	call   801b25 <_pipeisclosed>
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	75 3a                	jne    801bfe <devpipe_write+0x74>
			sys_yield();
  801bc4:	e8 5f f0 ff ff       	call   800c28 <sys_yield>
  801bc9:	eb e0                	jmp    801bab <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bce:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bd2:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bd5:	89 c2                	mov    %eax,%edx
  801bd7:	c1 fa 1f             	sar    $0x1f,%edx
  801bda:	89 d1                	mov    %edx,%ecx
  801bdc:	c1 e9 1b             	shr    $0x1b,%ecx
  801bdf:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801be2:	83 e2 1f             	and    $0x1f,%edx
  801be5:	29 ca                	sub    %ecx,%edx
  801be7:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801beb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bef:	83 c0 01             	add    $0x1,%eax
  801bf2:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bf5:	83 c7 01             	add    $0x1,%edi
  801bf8:	eb ac                	jmp    801ba6 <devpipe_write+0x1c>
	return i;
  801bfa:	89 f8                	mov    %edi,%eax
  801bfc:	eb 05                	jmp    801c03 <devpipe_write+0x79>
				return 0;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5e                   	pop    %esi
  801c08:	5f                   	pop    %edi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    

00801c0b <devpipe_read>:
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	57                   	push   %edi
  801c0f:	56                   	push   %esi
  801c10:	53                   	push   %ebx
  801c11:	83 ec 18             	sub    $0x18,%esp
  801c14:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c17:	57                   	push   %edi
  801c18:	e8 4a f2 ff ff       	call   800e67 <fd2data>
  801c1d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	be 00 00 00 00       	mov    $0x0,%esi
  801c27:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c2a:	74 47                	je     801c73 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c2c:	8b 03                	mov    (%ebx),%eax
  801c2e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c31:	75 22                	jne    801c55 <devpipe_read+0x4a>
			if (i > 0)
  801c33:	85 f6                	test   %esi,%esi
  801c35:	75 14                	jne    801c4b <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c37:	89 da                	mov    %ebx,%edx
  801c39:	89 f8                	mov    %edi,%eax
  801c3b:	e8 e5 fe ff ff       	call   801b25 <_pipeisclosed>
  801c40:	85 c0                	test   %eax,%eax
  801c42:	75 33                	jne    801c77 <devpipe_read+0x6c>
			sys_yield();
  801c44:	e8 df ef ff ff       	call   800c28 <sys_yield>
  801c49:	eb e1                	jmp    801c2c <devpipe_read+0x21>
				return i;
  801c4b:	89 f0                	mov    %esi,%eax
}
  801c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5e                   	pop    %esi
  801c52:	5f                   	pop    %edi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c55:	99                   	cltd   
  801c56:	c1 ea 1b             	shr    $0x1b,%edx
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	83 e0 1f             	and    $0x1f,%eax
  801c5e:	29 d0                	sub    %edx,%eax
  801c60:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c68:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c6b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c6e:	83 c6 01             	add    $0x1,%esi
  801c71:	eb b4                	jmp    801c27 <devpipe_read+0x1c>
	return i;
  801c73:	89 f0                	mov    %esi,%eax
  801c75:	eb d6                	jmp    801c4d <devpipe_read+0x42>
				return 0;
  801c77:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7c:	eb cf                	jmp    801c4d <devpipe_read+0x42>

00801c7e <pipe>:
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	56                   	push   %esi
  801c82:	53                   	push   %ebx
  801c83:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c89:	50                   	push   %eax
  801c8a:	e8 ef f1 ff ff       	call   800e7e <fd_alloc>
  801c8f:	89 c3                	mov    %eax,%ebx
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	85 c0                	test   %eax,%eax
  801c96:	78 5b                	js     801cf3 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	68 07 04 00 00       	push   $0x407
  801ca0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 9d ef ff ff       	call   800c47 <sys_page_alloc>
  801caa:	89 c3                	mov    %eax,%ebx
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 40                	js     801cf3 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb9:	50                   	push   %eax
  801cba:	e8 bf f1 ff ff       	call   800e7e <fd_alloc>
  801cbf:	89 c3                	mov    %eax,%ebx
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	78 1b                	js     801ce3 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cc8:	83 ec 04             	sub    $0x4,%esp
  801ccb:	68 07 04 00 00       	push   $0x407
  801cd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd3:	6a 00                	push   $0x0
  801cd5:	e8 6d ef ff ff       	call   800c47 <sys_page_alloc>
  801cda:	89 c3                	mov    %eax,%ebx
  801cdc:	83 c4 10             	add    $0x10,%esp
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	79 19                	jns    801cfc <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ce3:	83 ec 08             	sub    $0x8,%esp
  801ce6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ce9:	6a 00                	push   $0x0
  801ceb:	e8 dc ef ff ff       	call   800ccc <sys_page_unmap>
  801cf0:	83 c4 10             	add    $0x10,%esp
}
  801cf3:	89 d8                	mov    %ebx,%eax
  801cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
	va = fd2data(fd0);
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	ff 75 f4             	pushl  -0xc(%ebp)
  801d02:	e8 60 f1 ff ff       	call   800e67 <fd2data>
  801d07:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d09:	83 c4 0c             	add    $0xc,%esp
  801d0c:	68 07 04 00 00       	push   $0x407
  801d11:	50                   	push   %eax
  801d12:	6a 00                	push   $0x0
  801d14:	e8 2e ef ff ff       	call   800c47 <sys_page_alloc>
  801d19:	89 c3                	mov    %eax,%ebx
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	0f 88 8c 00 00 00    	js     801db2 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d26:	83 ec 0c             	sub    $0xc,%esp
  801d29:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2c:	e8 36 f1 ff ff       	call   800e67 <fd2data>
  801d31:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d38:	50                   	push   %eax
  801d39:	6a 00                	push   $0x0
  801d3b:	56                   	push   %esi
  801d3c:	6a 00                	push   $0x0
  801d3e:	e8 47 ef ff ff       	call   800c8a <sys_page_map>
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	83 c4 20             	add    $0x20,%esp
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 58                	js     801da4 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d55:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d64:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d6a:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	ff 75 f4             	pushl  -0xc(%ebp)
  801d7c:	e8 d6 f0 ff ff       	call   800e57 <fd2num>
  801d81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d84:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d86:	83 c4 04             	add    $0x4,%esp
  801d89:	ff 75 f0             	pushl  -0x10(%ebp)
  801d8c:	e8 c6 f0 ff ff       	call   800e57 <fd2num>
  801d91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d94:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d9f:	e9 4f ff ff ff       	jmp    801cf3 <pipe+0x75>
	sys_page_unmap(0, va);
  801da4:	83 ec 08             	sub    $0x8,%esp
  801da7:	56                   	push   %esi
  801da8:	6a 00                	push   $0x0
  801daa:	e8 1d ef ff ff       	call   800ccc <sys_page_unmap>
  801daf:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801db2:	83 ec 08             	sub    $0x8,%esp
  801db5:	ff 75 f0             	pushl  -0x10(%ebp)
  801db8:	6a 00                	push   $0x0
  801dba:	e8 0d ef ff ff       	call   800ccc <sys_page_unmap>
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	e9 1c ff ff ff       	jmp    801ce3 <pipe+0x65>

00801dc7 <pipeisclosed>:
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd0:	50                   	push   %eax
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	e8 f4 f0 ff ff       	call   800ecd <fd_lookup>
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	78 18                	js     801df8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 f4             	pushl  -0xc(%ebp)
  801de6:	e8 7c f0 ff ff       	call   800e67 <fd2data>
	return _pipeisclosed(fd, p);
  801deb:	89 c2                	mov    %eax,%edx
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	e8 30 fd ff ff       	call   801b25 <_pipeisclosed>
  801df5:	83 c4 10             	add    $0x10,%esp
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    

00801e04 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e0a:	68 cb 27 80 00       	push   $0x8027cb
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	e8 37 ea ff ff       	call   80084e <strcpy>
	return 0;
}
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <devcons_write>:
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	57                   	push   %edi
  801e22:	56                   	push   %esi
  801e23:	53                   	push   %ebx
  801e24:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e2a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e2f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e35:	eb 2f                	jmp    801e66 <devcons_write+0x48>
		m = n - tot;
  801e37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e3a:	29 f3                	sub    %esi,%ebx
  801e3c:	83 fb 7f             	cmp    $0x7f,%ebx
  801e3f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e44:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	53                   	push   %ebx
  801e4b:	89 f0                	mov    %esi,%eax
  801e4d:	03 45 0c             	add    0xc(%ebp),%eax
  801e50:	50                   	push   %eax
  801e51:	57                   	push   %edi
  801e52:	e8 85 eb ff ff       	call   8009dc <memmove>
		sys_cputs(buf, m);
  801e57:	83 c4 08             	add    $0x8,%esp
  801e5a:	53                   	push   %ebx
  801e5b:	57                   	push   %edi
  801e5c:	e8 2a ed ff ff       	call   800b8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e61:	01 de                	add    %ebx,%esi
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e69:	72 cc                	jb     801e37 <devcons_write+0x19>
}
  801e6b:	89 f0                	mov    %esi,%eax
  801e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5e                   	pop    %esi
  801e72:	5f                   	pop    %edi
  801e73:	5d                   	pop    %ebp
  801e74:	c3                   	ret    

00801e75 <devcons_read>:
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 08             	sub    $0x8,%esp
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e84:	75 07                	jne    801e8d <devcons_read+0x18>
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    
		sys_yield();
  801e88:	e8 9b ed ff ff       	call   800c28 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e8d:	e8 17 ed ff ff       	call   800ba9 <sys_cgetc>
  801e92:	85 c0                	test   %eax,%eax
  801e94:	74 f2                	je     801e88 <devcons_read+0x13>
	if (c < 0)
  801e96:	85 c0                	test   %eax,%eax
  801e98:	78 ec                	js     801e86 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e9a:	83 f8 04             	cmp    $0x4,%eax
  801e9d:	74 0c                	je     801eab <devcons_read+0x36>
	*(char*)vbuf = c;
  801e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea2:	88 02                	mov    %al,(%edx)
	return 1;
  801ea4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea9:	eb db                	jmp    801e86 <devcons_read+0x11>
		return 0;
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	eb d4                	jmp    801e86 <devcons_read+0x11>

00801eb2 <cputchar>:
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ebe:	6a 01                	push   $0x1
  801ec0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec3:	50                   	push   %eax
  801ec4:	e8 c2 ec ff ff       	call   800b8b <sys_cputs>
}
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <getchar>:
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ed4:	6a 01                	push   $0x1
  801ed6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ed9:	50                   	push   %eax
  801eda:	6a 00                	push   $0x0
  801edc:	e8 5d f2 ff ff       	call   80113e <read>
	if (r < 0)
  801ee1:	83 c4 10             	add    $0x10,%esp
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	78 08                	js     801ef0 <getchar+0x22>
	if (r < 1)
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	7e 06                	jle    801ef2 <getchar+0x24>
	return c;
  801eec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    
		return -E_EOF;
  801ef2:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ef7:	eb f7                	jmp    801ef0 <getchar+0x22>

00801ef9 <iscons>:
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f02:	50                   	push   %eax
  801f03:	ff 75 08             	pushl  0x8(%ebp)
  801f06:	e8 c2 ef ff ff       	call   800ecd <fd_lookup>
  801f0b:	83 c4 10             	add    $0x10,%esp
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 11                	js     801f23 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f1b:	39 10                	cmp    %edx,(%eax)
  801f1d:	0f 94 c0             	sete   %al
  801f20:	0f b6 c0             	movzbl %al,%eax
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <opencons>:
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2e:	50                   	push   %eax
  801f2f:	e8 4a ef ff ff       	call   800e7e <fd_alloc>
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 3a                	js     801f75 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	68 07 04 00 00       	push   $0x407
  801f43:	ff 75 f4             	pushl  -0xc(%ebp)
  801f46:	6a 00                	push   $0x0
  801f48:	e8 fa ec ff ff       	call   800c47 <sys_page_alloc>
  801f4d:	83 c4 10             	add    $0x10,%esp
  801f50:	85 c0                	test   %eax,%eax
  801f52:	78 21                	js     801f75 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f5d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	50                   	push   %eax
  801f6d:	e8 e5 ee ff ff       	call   800e57 <fd2num>
  801f72:	83 c4 10             	add    $0x10,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	56                   	push   %esi
  801f7b:	53                   	push   %ebx
  801f7c:	8b 75 08             	mov    0x8(%ebp),%esi
  801f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f85:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f87:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f8c:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	50                   	push   %eax
  801f93:	e8 5f ee ff ff       	call   800df7 <sys_ipc_recv>
	if (from_env_store)
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	85 f6                	test   %esi,%esi
  801f9d:	74 14                	je     801fb3 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 09                	js     801fb1 <ipc_recv+0x3a>
  801fa8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fae:	8b 52 74             	mov    0x74(%edx),%edx
  801fb1:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801fb3:	85 db                	test   %ebx,%ebx
  801fb5:	74 14                	je     801fcb <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801fb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	78 09                	js     801fc9 <ipc_recv+0x52>
  801fc0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fc6:	8b 52 78             	mov    0x78(%edx),%edx
  801fc9:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	78 08                	js     801fd7 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801fcf:	a1 08 40 80 00       	mov    0x804008,%eax
  801fd4:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801fd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fda:	5b                   	pop    %ebx
  801fdb:	5e                   	pop    %esi
  801fdc:	5d                   	pop    %ebp
  801fdd:	c3                   	ret    

00801fde <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fde:	55                   	push   %ebp
  801fdf:	89 e5                	mov    %esp,%ebp
  801fe1:	57                   	push   %edi
  801fe2:	56                   	push   %esi
  801fe3:	53                   	push   %ebx
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fea:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ff0:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801ff2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801ff7:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801ffa:	ff 75 14             	pushl  0x14(%ebp)
  801ffd:	53                   	push   %ebx
  801ffe:	56                   	push   %esi
  801fff:	57                   	push   %edi
  802000:	e8 cf ed ff ff       	call   800dd4 <sys_ipc_try_send>
		if (ret == 0)
  802005:	83 c4 10             	add    $0x10,%esp
  802008:	85 c0                	test   %eax,%eax
  80200a:	74 1e                	je     80202a <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80200c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80200f:	75 07                	jne    802018 <ipc_send+0x3a>
			sys_yield();
  802011:	e8 12 ec ff ff       	call   800c28 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802016:	eb e2                	jmp    801ffa <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802018:	50                   	push   %eax
  802019:	68 d7 27 80 00       	push   $0x8027d7
  80201e:	6a 3d                	push   $0x3d
  802020:	68 eb 27 80 00       	push   $0x8027eb
  802025:	e8 2a e1 ff ff       	call   800154 <_panic>
	}
	// panic("ipc_send not implemented");
}
  80202a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80202d:	5b                   	pop    %ebx
  80202e:	5e                   	pop    %esi
  80202f:	5f                   	pop    %edi
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802038:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80203d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802040:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802046:	8b 52 50             	mov    0x50(%edx),%edx
  802049:	39 ca                	cmp    %ecx,%edx
  80204b:	74 11                	je     80205e <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80204d:	83 c0 01             	add    $0x1,%eax
  802050:	3d 00 04 00 00       	cmp    $0x400,%eax
  802055:	75 e6                	jne    80203d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	eb 0b                	jmp    802069 <ipc_find_env+0x37>
			return envs[i].env_id;
  80205e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802061:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802066:	8b 40 48             	mov    0x48(%eax),%eax
}
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802071:	89 d0                	mov    %edx,%eax
  802073:	c1 e8 16             	shr    $0x16,%eax
  802076:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802082:	f6 c1 01             	test   $0x1,%cl
  802085:	74 1d                	je     8020a4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802087:	c1 ea 0c             	shr    $0xc,%edx
  80208a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802091:	f6 c2 01             	test   $0x1,%dl
  802094:	74 0e                	je     8020a4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802096:	c1 ea 0c             	shr    $0xc,%edx
  802099:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020a0:	ef 
  8020a1:	0f b7 c0             	movzwl %ax,%eax
}
  8020a4:	5d                   	pop    %ebp
  8020a5:	c3                   	ret    
  8020a6:	66 90                	xchg   %ax,%ax
  8020a8:	66 90                	xchg   %ax,%ax
  8020aa:	66 90                	xchg   %ax,%ax
  8020ac:	66 90                	xchg   %ax,%ax
  8020ae:	66 90                	xchg   %ax,%ax

008020b0 <__udivdi3>:
  8020b0:	55                   	push   %ebp
  8020b1:	57                   	push   %edi
  8020b2:	56                   	push   %esi
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
  8020b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020c7:	85 d2                	test   %edx,%edx
  8020c9:	75 35                	jne    802100 <__udivdi3+0x50>
  8020cb:	39 f3                	cmp    %esi,%ebx
  8020cd:	0f 87 bd 00 00 00    	ja     802190 <__udivdi3+0xe0>
  8020d3:	85 db                	test   %ebx,%ebx
  8020d5:	89 d9                	mov    %ebx,%ecx
  8020d7:	75 0b                	jne    8020e4 <__udivdi3+0x34>
  8020d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020de:	31 d2                	xor    %edx,%edx
  8020e0:	f7 f3                	div    %ebx
  8020e2:	89 c1                	mov    %eax,%ecx
  8020e4:	31 d2                	xor    %edx,%edx
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	f7 f1                	div    %ecx
  8020ea:	89 c6                	mov    %eax,%esi
  8020ec:	89 e8                	mov    %ebp,%eax
  8020ee:	89 f7                	mov    %esi,%edi
  8020f0:	f7 f1                	div    %ecx
  8020f2:	89 fa                	mov    %edi,%edx
  8020f4:	83 c4 1c             	add    $0x1c,%esp
  8020f7:	5b                   	pop    %ebx
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    
  8020fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802100:	39 f2                	cmp    %esi,%edx
  802102:	77 7c                	ja     802180 <__udivdi3+0xd0>
  802104:	0f bd fa             	bsr    %edx,%edi
  802107:	83 f7 1f             	xor    $0x1f,%edi
  80210a:	0f 84 98 00 00 00    	je     8021a8 <__udivdi3+0xf8>
  802110:	89 f9                	mov    %edi,%ecx
  802112:	b8 20 00 00 00       	mov    $0x20,%eax
  802117:	29 f8                	sub    %edi,%eax
  802119:	d3 e2                	shl    %cl,%edx
  80211b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80211f:	89 c1                	mov    %eax,%ecx
  802121:	89 da                	mov    %ebx,%edx
  802123:	d3 ea                	shr    %cl,%edx
  802125:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802129:	09 d1                	or     %edx,%ecx
  80212b:	89 f2                	mov    %esi,%edx
  80212d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802131:	89 f9                	mov    %edi,%ecx
  802133:	d3 e3                	shl    %cl,%ebx
  802135:	89 c1                	mov    %eax,%ecx
  802137:	d3 ea                	shr    %cl,%edx
  802139:	89 f9                	mov    %edi,%ecx
  80213b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80213f:	d3 e6                	shl    %cl,%esi
  802141:	89 eb                	mov    %ebp,%ebx
  802143:	89 c1                	mov    %eax,%ecx
  802145:	d3 eb                	shr    %cl,%ebx
  802147:	09 de                	or     %ebx,%esi
  802149:	89 f0                	mov    %esi,%eax
  80214b:	f7 74 24 08          	divl   0x8(%esp)
  80214f:	89 d6                	mov    %edx,%esi
  802151:	89 c3                	mov    %eax,%ebx
  802153:	f7 64 24 0c          	mull   0xc(%esp)
  802157:	39 d6                	cmp    %edx,%esi
  802159:	72 0c                	jb     802167 <__udivdi3+0xb7>
  80215b:	89 f9                	mov    %edi,%ecx
  80215d:	d3 e5                	shl    %cl,%ebp
  80215f:	39 c5                	cmp    %eax,%ebp
  802161:	73 5d                	jae    8021c0 <__udivdi3+0x110>
  802163:	39 d6                	cmp    %edx,%esi
  802165:	75 59                	jne    8021c0 <__udivdi3+0x110>
  802167:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80216a:	31 ff                	xor    %edi,%edi
  80216c:	89 fa                	mov    %edi,%edx
  80216e:	83 c4 1c             	add    $0x1c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    
  802176:	8d 76 00             	lea    0x0(%esi),%esi
  802179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802180:	31 ff                	xor    %edi,%edi
  802182:	31 c0                	xor    %eax,%eax
  802184:	89 fa                	mov    %edi,%edx
  802186:	83 c4 1c             	add    $0x1c,%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    
  80218e:	66 90                	xchg   %ax,%ax
  802190:	31 ff                	xor    %edi,%edi
  802192:	89 e8                	mov    %ebp,%eax
  802194:	89 f2                	mov    %esi,%edx
  802196:	f7 f3                	div    %ebx
  802198:	89 fa                	mov    %edi,%edx
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
  8021a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021a8:	39 f2                	cmp    %esi,%edx
  8021aa:	72 06                	jb     8021b2 <__udivdi3+0x102>
  8021ac:	31 c0                	xor    %eax,%eax
  8021ae:	39 eb                	cmp    %ebp,%ebx
  8021b0:	77 d2                	ja     802184 <__udivdi3+0xd4>
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b7:	eb cb                	jmp    802184 <__udivdi3+0xd4>
  8021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021c0:	89 d8                	mov    %ebx,%eax
  8021c2:	31 ff                	xor    %edi,%edi
  8021c4:	eb be                	jmp    802184 <__udivdi3+0xd4>
  8021c6:	66 90                	xchg   %ax,%ax
  8021c8:	66 90                	xchg   %ax,%ax
  8021ca:	66 90                	xchg   %ax,%ax
  8021cc:	66 90                	xchg   %ax,%ax
  8021ce:	66 90                	xchg   %ax,%ax

008021d0 <__umoddi3>:
  8021d0:	55                   	push   %ebp
  8021d1:	57                   	push   %edi
  8021d2:	56                   	push   %esi
  8021d3:	53                   	push   %ebx
  8021d4:	83 ec 1c             	sub    $0x1c,%esp
  8021d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021e7:	85 ed                	test   %ebp,%ebp
  8021e9:	89 f0                	mov    %esi,%eax
  8021eb:	89 da                	mov    %ebx,%edx
  8021ed:	75 19                	jne    802208 <__umoddi3+0x38>
  8021ef:	39 df                	cmp    %ebx,%edi
  8021f1:	0f 86 b1 00 00 00    	jbe    8022a8 <__umoddi3+0xd8>
  8021f7:	f7 f7                	div    %edi
  8021f9:	89 d0                	mov    %edx,%eax
  8021fb:	31 d2                	xor    %edx,%edx
  8021fd:	83 c4 1c             	add    $0x1c,%esp
  802200:	5b                   	pop    %ebx
  802201:	5e                   	pop    %esi
  802202:	5f                   	pop    %edi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    
  802205:	8d 76 00             	lea    0x0(%esi),%esi
  802208:	39 dd                	cmp    %ebx,%ebp
  80220a:	77 f1                	ja     8021fd <__umoddi3+0x2d>
  80220c:	0f bd cd             	bsr    %ebp,%ecx
  80220f:	83 f1 1f             	xor    $0x1f,%ecx
  802212:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802216:	0f 84 b4 00 00 00    	je     8022d0 <__umoddi3+0x100>
  80221c:	b8 20 00 00 00       	mov    $0x20,%eax
  802221:	89 c2                	mov    %eax,%edx
  802223:	8b 44 24 04          	mov    0x4(%esp),%eax
  802227:	29 c2                	sub    %eax,%edx
  802229:	89 c1                	mov    %eax,%ecx
  80222b:	89 f8                	mov    %edi,%eax
  80222d:	d3 e5                	shl    %cl,%ebp
  80222f:	89 d1                	mov    %edx,%ecx
  802231:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802235:	d3 e8                	shr    %cl,%eax
  802237:	09 c5                	or     %eax,%ebp
  802239:	8b 44 24 04          	mov    0x4(%esp),%eax
  80223d:	89 c1                	mov    %eax,%ecx
  80223f:	d3 e7                	shl    %cl,%edi
  802241:	89 d1                	mov    %edx,%ecx
  802243:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802247:	89 df                	mov    %ebx,%edi
  802249:	d3 ef                	shr    %cl,%edi
  80224b:	89 c1                	mov    %eax,%ecx
  80224d:	89 f0                	mov    %esi,%eax
  80224f:	d3 e3                	shl    %cl,%ebx
  802251:	89 d1                	mov    %edx,%ecx
  802253:	89 fa                	mov    %edi,%edx
  802255:	d3 e8                	shr    %cl,%eax
  802257:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80225c:	09 d8                	or     %ebx,%eax
  80225e:	f7 f5                	div    %ebp
  802260:	d3 e6                	shl    %cl,%esi
  802262:	89 d1                	mov    %edx,%ecx
  802264:	f7 64 24 08          	mull   0x8(%esp)
  802268:	39 d1                	cmp    %edx,%ecx
  80226a:	89 c3                	mov    %eax,%ebx
  80226c:	89 d7                	mov    %edx,%edi
  80226e:	72 06                	jb     802276 <__umoddi3+0xa6>
  802270:	75 0e                	jne    802280 <__umoddi3+0xb0>
  802272:	39 c6                	cmp    %eax,%esi
  802274:	73 0a                	jae    802280 <__umoddi3+0xb0>
  802276:	2b 44 24 08          	sub    0x8(%esp),%eax
  80227a:	19 ea                	sbb    %ebp,%edx
  80227c:	89 d7                	mov    %edx,%edi
  80227e:	89 c3                	mov    %eax,%ebx
  802280:	89 ca                	mov    %ecx,%edx
  802282:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802287:	29 de                	sub    %ebx,%esi
  802289:	19 fa                	sbb    %edi,%edx
  80228b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80228f:	89 d0                	mov    %edx,%eax
  802291:	d3 e0                	shl    %cl,%eax
  802293:	89 d9                	mov    %ebx,%ecx
  802295:	d3 ee                	shr    %cl,%esi
  802297:	d3 ea                	shr    %cl,%edx
  802299:	09 f0                	or     %esi,%eax
  80229b:	83 c4 1c             	add    $0x1c,%esp
  80229e:	5b                   	pop    %ebx
  80229f:	5e                   	pop    %esi
  8022a0:	5f                   	pop    %edi
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    
  8022a3:	90                   	nop
  8022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	85 ff                	test   %edi,%edi
  8022aa:	89 f9                	mov    %edi,%ecx
  8022ac:	75 0b                	jne    8022b9 <__umoddi3+0xe9>
  8022ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b3:	31 d2                	xor    %edx,%edx
  8022b5:	f7 f7                	div    %edi
  8022b7:	89 c1                	mov    %eax,%ecx
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	31 d2                	xor    %edx,%edx
  8022bd:	f7 f1                	div    %ecx
  8022bf:	89 f0                	mov    %esi,%eax
  8022c1:	f7 f1                	div    %ecx
  8022c3:	e9 31 ff ff ff       	jmp    8021f9 <__umoddi3+0x29>
  8022c8:	90                   	nop
  8022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	39 dd                	cmp    %ebx,%ebp
  8022d2:	72 08                	jb     8022dc <__umoddi3+0x10c>
  8022d4:	39 f7                	cmp    %esi,%edi
  8022d6:	0f 87 21 ff ff ff    	ja     8021fd <__umoddi3+0x2d>
  8022dc:	89 da                	mov    %ebx,%edx
  8022de:	89 f0                	mov    %esi,%eax
  8022e0:	29 f8                	sub    %edi,%eax
  8022e2:	19 ea                	sbb    %ebp,%edx
  8022e4:	e9 14 ff ff ff       	jmp    8021fd <__umoddi3+0x2d>

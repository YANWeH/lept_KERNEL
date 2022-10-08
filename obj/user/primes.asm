
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	83 ec 04             	sub    $0x4,%esp
  800042:	6a 00                	push   $0x0
  800044:	6a 00                	push   $0x0
  800046:	56                   	push   %esi
  800047:	e8 ad 10 00 00       	call   8010f9 <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  80004e:	a1 08 40 80 00       	mov    0x804008,%eax
  800053:	8b 40 5c             	mov    0x5c(%eax),%eax
  800056:	83 c4 0c             	add    $0xc,%esp
  800059:	53                   	push   %ebx
  80005a:	50                   	push   %eax
  80005b:	68 20 26 80 00       	push   $0x802620
  800060:	e8 ce 01 00 00       	call   800233 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800065:	e8 ca 0e 00 00       	call   800f34 <fork>
  80006a:	89 c7                	mov    %eax,%edi
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	85 c0                	test   %eax,%eax
  800071:	78 30                	js     8000a3 <primeproc+0x70>
		panic("fork: %e", id);
	if (id == 0)
  800073:	85 c0                	test   %eax,%eax
  800075:	74 c8                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800077:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 00                	push   $0x0
  80007f:	6a 00                	push   $0x0
  800081:	56                   	push   %esi
  800082:	e8 72 10 00 00       	call   8010f9 <ipc_recv>
  800087:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800089:	99                   	cltd   
  80008a:	f7 fb                	idiv   %ebx
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	85 d2                	test   %edx,%edx
  800091:	74 e7                	je     80007a <primeproc+0x47>
			ipc_send(id, i, 0, 0);
  800093:	6a 00                	push   $0x0
  800095:	6a 00                	push   $0x0
  800097:	51                   	push   %ecx
  800098:	57                   	push   %edi
  800099:	e8 c2 10 00 00       	call   801160 <ipc_send>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	eb d7                	jmp    80007a <primeproc+0x47>
		panic("fork: %e", id);
  8000a3:	50                   	push   %eax
  8000a4:	68 2c 26 80 00       	push   $0x80262c
  8000a9:	6a 1a                	push   $0x1a
  8000ab:	68 35 26 80 00       	push   $0x802635
  8000b0:	e8 a3 00 00 00       	call   800158 <_panic>

008000b5 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ba:	e8 75 0e 00 00       	call   800f34 <fork>
  8000bf:	89 c6                	mov    %eax,%esi
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	78 1c                	js     8000e1 <umain+0x2c>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  8000c5:	bb 02 00 00 00       	mov    $0x2,%ebx
	if (id == 0)
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	74 25                	je     8000f3 <umain+0x3e>
		ipc_send(id, i, 0, 0);
  8000ce:	6a 00                	push   $0x0
  8000d0:	6a 00                	push   $0x0
  8000d2:	53                   	push   %ebx
  8000d3:	56                   	push   %esi
  8000d4:	e8 87 10 00 00       	call   801160 <ipc_send>
	for (i = 2; ; i++)
  8000d9:	83 c3 01             	add    $0x1,%ebx
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	eb ed                	jmp    8000ce <umain+0x19>
		panic("fork: %e", id);
  8000e1:	50                   	push   %eax
  8000e2:	68 2c 26 80 00       	push   $0x80262c
  8000e7:	6a 2d                	push   $0x2d
  8000e9:	68 35 26 80 00       	push   $0x802635
  8000ee:	e8 65 00 00 00       	call   800158 <_panic>
		primeproc();
  8000f3:	e8 3b ff ff ff       	call   800033 <primeproc>

008000f8 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800100:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800103:	e8 05 0b 00 00       	call   800c0d <sys_getenvid>
  800108:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800110:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800115:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011a:	85 db                	test   %ebx,%ebx
  80011c:	7e 07                	jle    800125 <libmain+0x2d>
		binaryname = argv[0];
  80011e:	8b 06                	mov    (%esi),%eax
  800120:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800125:	83 ec 08             	sub    $0x8,%esp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	e8 86 ff ff ff       	call   8000b5 <umain>

	// exit gracefully
	exit();
  80012f:	e8 0a 00 00 00       	call   80013e <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80013a:	5b                   	pop    %ebx
  80013b:	5e                   	pop    %esi
  80013c:	5d                   	pop    %ebp
  80013d:	c3                   	ret    

0080013e <exit>:

#include <inc/lib.h>

void exit(void)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800144:	e8 7a 12 00 00       	call   8013c3 <close_all>
	sys_env_destroy(0);
  800149:	83 ec 0c             	sub    $0xc,%esp
  80014c:	6a 00                	push   $0x0
  80014e:	e8 79 0a 00 00       	call   800bcc <sys_env_destroy>
}
  800153:	83 c4 10             	add    $0x10,%esp
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80015d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800160:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800166:	e8 a2 0a 00 00       	call   800c0d <sys_getenvid>
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	ff 75 0c             	pushl  0xc(%ebp)
  800171:	ff 75 08             	pushl  0x8(%ebp)
  800174:	56                   	push   %esi
  800175:	50                   	push   %eax
  800176:	68 50 26 80 00       	push   $0x802650
  80017b:	e8 b3 00 00 00       	call   800233 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800180:	83 c4 18             	add    $0x18,%esp
  800183:	53                   	push   %ebx
  800184:	ff 75 10             	pushl  0x10(%ebp)
  800187:	e8 56 00 00 00       	call   8001e2 <vcprintf>
	cprintf("\n");
  80018c:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  800193:	e8 9b 00 00 00       	call   800233 <cprintf>
  800198:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019b:	cc                   	int3   
  80019c:	eb fd                	jmp    80019b <_panic+0x43>

0080019e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	53                   	push   %ebx
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a8:	8b 13                	mov    (%ebx),%edx
  8001aa:	8d 42 01             	lea    0x1(%edx),%eax
  8001ad:	89 03                	mov    %eax,(%ebx)
  8001af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bb:	74 09                	je     8001c6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c6:	83 ec 08             	sub    $0x8,%esp
  8001c9:	68 ff 00 00 00       	push   $0xff
  8001ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d1:	50                   	push   %eax
  8001d2:	e8 b8 09 00 00       	call   800b8f <sys_cputs>
		b->idx = 0;
  8001d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001dd:	83 c4 10             	add    $0x10,%esp
  8001e0:	eb db                	jmp    8001bd <putch+0x1f>

008001e2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f2:	00 00 00 
	b.cnt = 0;
  8001f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fc:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ff:	ff 75 0c             	pushl  0xc(%ebp)
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020b:	50                   	push   %eax
  80020c:	68 9e 01 80 00       	push   $0x80019e
  800211:	e8 1a 01 00 00       	call   800330 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800216:	83 c4 08             	add    $0x8,%esp
  800219:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80021f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800225:	50                   	push   %eax
  800226:	e8 64 09 00 00       	call   800b8f <sys_cputs>

	return b.cnt;
}
  80022b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800239:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 08             	pushl  0x8(%ebp)
  800240:	e8 9d ff ff ff       	call   8001e2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	57                   	push   %edi
  80024b:	56                   	push   %esi
  80024c:	53                   	push   %ebx
  80024d:	83 ec 1c             	sub    $0x1c,%esp
  800250:	89 c7                	mov    %eax,%edi
  800252:	89 d6                	mov    %edx,%esi
  800254:	8b 45 08             	mov    0x8(%ebp),%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800260:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800263:	bb 00 00 00 00       	mov    $0x0,%ebx
  800268:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80026b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80026e:	39 d3                	cmp    %edx,%ebx
  800270:	72 05                	jb     800277 <printnum+0x30>
  800272:	39 45 10             	cmp    %eax,0x10(%ebp)
  800275:	77 7a                	ja     8002f1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	ff 75 18             	pushl  0x18(%ebp)
  80027d:	8b 45 14             	mov    0x14(%ebp),%eax
  800280:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800283:	53                   	push   %ebx
  800284:	ff 75 10             	pushl  0x10(%ebp)
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80028d:	ff 75 e0             	pushl  -0x20(%ebp)
  800290:	ff 75 dc             	pushl  -0x24(%ebp)
  800293:	ff 75 d8             	pushl  -0x28(%ebp)
  800296:	e8 45 21 00 00       	call   8023e0 <__udivdi3>
  80029b:	83 c4 18             	add    $0x18,%esp
  80029e:	52                   	push   %edx
  80029f:	50                   	push   %eax
  8002a0:	89 f2                	mov    %esi,%edx
  8002a2:	89 f8                	mov    %edi,%eax
  8002a4:	e8 9e ff ff ff       	call   800247 <printnum>
  8002a9:	83 c4 20             	add    $0x20,%esp
  8002ac:	eb 13                	jmp    8002c1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	56                   	push   %esi
  8002b2:	ff 75 18             	pushl  0x18(%ebp)
  8002b5:	ff d7                	call   *%edi
  8002b7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002ba:	83 eb 01             	sub    $0x1,%ebx
  8002bd:	85 db                	test   %ebx,%ebx
  8002bf:	7f ed                	jg     8002ae <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	56                   	push   %esi
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002cb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d4:	e8 27 22 00 00       	call   802500 <__umoddi3>
  8002d9:	83 c4 14             	add    $0x14,%esp
  8002dc:	0f be 80 73 26 80 00 	movsbl 0x802673(%eax),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff d7                	call   *%edi
}
  8002e6:	83 c4 10             	add    $0x10,%esp
  8002e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ec:	5b                   	pop    %ebx
  8002ed:	5e                   	pop    %esi
  8002ee:	5f                   	pop    %edi
  8002ef:	5d                   	pop    %ebp
  8002f0:	c3                   	ret    
  8002f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002f4:	eb c4                	jmp    8002ba <printnum+0x73>

008002f6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002fc:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800300:	8b 10                	mov    (%eax),%edx
  800302:	3b 50 04             	cmp    0x4(%eax),%edx
  800305:	73 0a                	jae    800311 <sprintputch+0x1b>
		*b->buf++ = ch;
  800307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030a:	89 08                	mov    %ecx,(%eax)
  80030c:	8b 45 08             	mov    0x8(%ebp),%eax
  80030f:	88 02                	mov    %al,(%edx)
}
  800311:	5d                   	pop    %ebp
  800312:	c3                   	ret    

00800313 <printfmt>:
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800319:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031c:	50                   	push   %eax
  80031d:	ff 75 10             	pushl  0x10(%ebp)
  800320:	ff 75 0c             	pushl  0xc(%ebp)
  800323:	ff 75 08             	pushl  0x8(%ebp)
  800326:	e8 05 00 00 00       	call   800330 <vprintfmt>
}
  80032b:	83 c4 10             	add    $0x10,%esp
  80032e:	c9                   	leave  
  80032f:	c3                   	ret    

00800330 <vprintfmt>:
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 2c             	sub    $0x2c,%esp
  800339:	8b 75 08             	mov    0x8(%ebp),%esi
  80033c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80033f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800342:	e9 c1 03 00 00       	jmp    800708 <vprintfmt+0x3d8>
		padc = ' ';
  800347:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80034b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800352:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800359:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800360:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8d 47 01             	lea    0x1(%edi),%eax
  800368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036b:	0f b6 17             	movzbl (%edi),%edx
  80036e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800371:	3c 55                	cmp    $0x55,%al
  800373:	0f 87 12 04 00 00    	ja     80078b <vprintfmt+0x45b>
  800379:	0f b6 c0             	movzbl %al,%eax
  80037c:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800386:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80038a:	eb d9                	jmp    800365 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800393:	eb d0                	jmp    800365 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800395:	0f b6 d2             	movzbl %dl,%edx
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039b:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ad:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003b0:	83 f9 09             	cmp    $0x9,%ecx
  8003b3:	77 55                	ja     80040a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003b5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003b8:	eb e9                	jmp    8003a3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 40 04             	lea    0x4(%eax),%eax
  8003c8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d2:	79 91                	jns    800365 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003da:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003e1:	eb 82                	jmp    800365 <vprintfmt+0x35>
  8003e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e6:	85 c0                	test   %eax,%eax
  8003e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ed:	0f 49 d0             	cmovns %eax,%edx
  8003f0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f6:	e9 6a ff ff ff       	jmp    800365 <vprintfmt+0x35>
  8003fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fe:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800405:	e9 5b ff ff ff       	jmp    800365 <vprintfmt+0x35>
  80040a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80040d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800410:	eb bc                	jmp    8003ce <vprintfmt+0x9e>
			lflag++;
  800412:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800418:	e9 48 ff ff ff       	jmp    800365 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8d 78 04             	lea    0x4(%eax),%edi
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	53                   	push   %ebx
  800427:	ff 30                	pushl  (%eax)
  800429:	ff d6                	call   *%esi
			break;
  80042b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800431:	e9 cf 02 00 00       	jmp    800705 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8d 78 04             	lea    0x4(%eax),%edi
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	99                   	cltd   
  80043f:	31 d0                	xor    %edx,%eax
  800441:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800443:	83 f8 0f             	cmp    $0xf,%eax
  800446:	7f 23                	jg     80046b <vprintfmt+0x13b>
  800448:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  80044f:	85 d2                	test   %edx,%edx
  800451:	74 18                	je     80046b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800453:	52                   	push   %edx
  800454:	68 61 2b 80 00       	push   $0x802b61
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 b3 fe ff ff       	call   800313 <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
  800466:	e9 9a 02 00 00       	jmp    800705 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80046b:	50                   	push   %eax
  80046c:	68 8b 26 80 00       	push   $0x80268b
  800471:	53                   	push   %ebx
  800472:	56                   	push   %esi
  800473:	e8 9b fe ff ff       	call   800313 <printfmt>
  800478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047e:	e9 82 02 00 00       	jmp    800705 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	83 c0 04             	add    $0x4,%eax
  800489:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800491:	85 ff                	test   %edi,%edi
  800493:	b8 84 26 80 00       	mov    $0x802684,%eax
  800498:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80049b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049f:	0f 8e bd 00 00 00    	jle    800562 <vprintfmt+0x232>
  8004a5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004a9:	75 0e                	jne    8004b9 <vprintfmt+0x189>
  8004ab:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004b1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b7:	eb 6d                	jmp    800526 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b9:	83 ec 08             	sub    $0x8,%esp
  8004bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8004bf:	57                   	push   %edi
  8004c0:	e8 6e 03 00 00       	call   800833 <strnlen>
  8004c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c8:	29 c1                	sub    %eax,%ecx
  8004ca:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004cd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004d0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004da:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	eb 0f                	jmp    8004ed <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	53                   	push   %ebx
  8004e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e7:	83 ef 01             	sub    $0x1,%edi
  8004ea:	83 c4 10             	add    $0x10,%esp
  8004ed:	85 ff                	test   %edi,%edi
  8004ef:	7f ed                	jg     8004de <vprintfmt+0x1ae>
  8004f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004f4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004f7:	85 c9                	test   %ecx,%ecx
  8004f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fe:	0f 49 c1             	cmovns %ecx,%eax
  800501:	29 c1                	sub    %eax,%ecx
  800503:	89 75 08             	mov    %esi,0x8(%ebp)
  800506:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800509:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80050c:	89 cb                	mov    %ecx,%ebx
  80050e:	eb 16                	jmp    800526 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	75 31                	jne    800547 <vprintfmt+0x217>
					putch(ch, putdat);
  800516:	83 ec 08             	sub    $0x8,%esp
  800519:	ff 75 0c             	pushl  0xc(%ebp)
  80051c:	50                   	push   %eax
  80051d:	ff 55 08             	call   *0x8(%ebp)
  800520:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800523:	83 eb 01             	sub    $0x1,%ebx
  800526:	83 c7 01             	add    $0x1,%edi
  800529:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80052d:	0f be c2             	movsbl %dl,%eax
  800530:	85 c0                	test   %eax,%eax
  800532:	74 59                	je     80058d <vprintfmt+0x25d>
  800534:	85 f6                	test   %esi,%esi
  800536:	78 d8                	js     800510 <vprintfmt+0x1e0>
  800538:	83 ee 01             	sub    $0x1,%esi
  80053b:	79 d3                	jns    800510 <vprintfmt+0x1e0>
  80053d:	89 df                	mov    %ebx,%edi
  80053f:	8b 75 08             	mov    0x8(%ebp),%esi
  800542:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800545:	eb 37                	jmp    80057e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800547:	0f be d2             	movsbl %dl,%edx
  80054a:	83 ea 20             	sub    $0x20,%edx
  80054d:	83 fa 5e             	cmp    $0x5e,%edx
  800550:	76 c4                	jbe    800516 <vprintfmt+0x1e6>
					putch('?', putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	6a 3f                	push   $0x3f
  80055a:	ff 55 08             	call   *0x8(%ebp)
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	eb c1                	jmp    800523 <vprintfmt+0x1f3>
  800562:	89 75 08             	mov    %esi,0x8(%ebp)
  800565:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800568:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80056e:	eb b6                	jmp    800526 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	53                   	push   %ebx
  800574:	6a 20                	push   $0x20
  800576:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800578:	83 ef 01             	sub    $0x1,%edi
  80057b:	83 c4 10             	add    $0x10,%esp
  80057e:	85 ff                	test   %edi,%edi
  800580:	7f ee                	jg     800570 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800582:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800585:	89 45 14             	mov    %eax,0x14(%ebp)
  800588:	e9 78 01 00 00       	jmp    800705 <vprintfmt+0x3d5>
  80058d:	89 df                	mov    %ebx,%edi
  80058f:	8b 75 08             	mov    0x8(%ebp),%esi
  800592:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800595:	eb e7                	jmp    80057e <vprintfmt+0x24e>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7e 3f                	jle    8005db <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b7:	79 5c                	jns    800615 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	53                   	push   %ebx
  8005bd:	6a 2d                	push   $0x2d
  8005bf:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c7:	f7 da                	neg    %edx
  8005c9:	83 d1 00             	adc    $0x0,%ecx
  8005cc:	f7 d9                	neg    %ecx
  8005ce:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d6:	e9 10 01 00 00       	jmp    8006eb <vprintfmt+0x3bb>
	else if (lflag)
  8005db:	85 c9                	test   %ecx,%ecx
  8005dd:	75 1b                	jne    8005fa <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e7:	89 c1                	mov    %eax,%ecx
  8005e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ec:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 40 04             	lea    0x4(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f8:	eb b9                	jmp    8005b3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800602:	89 c1                	mov    %eax,%ecx
  800604:	c1 f9 1f             	sar    $0x1f,%ecx
  800607:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	eb 9e                	jmp    8005b3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800615:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800618:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800620:	e9 c6 00 00 00       	jmp    8006eb <vprintfmt+0x3bb>
	if (lflag >= 2)
  800625:	83 f9 01             	cmp    $0x1,%ecx
  800628:	7e 18                	jle    800642 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 10                	mov    (%eax),%edx
  80062f:	8b 48 04             	mov    0x4(%eax),%ecx
  800632:	8d 40 08             	lea    0x8(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	e9 a9 00 00 00       	jmp    8006eb <vprintfmt+0x3bb>
	else if (lflag)
  800642:	85 c9                	test   %ecx,%ecx
  800644:	75 1a                	jne    800660 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8b 10                	mov    (%eax),%edx
  80064b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800656:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065b:	e9 8b 00 00 00       	jmp    8006eb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 10                	mov    (%eax),%edx
  800665:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066a:	8d 40 04             	lea    0x4(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800670:	b8 0a 00 00 00       	mov    $0xa,%eax
  800675:	eb 74                	jmp    8006eb <vprintfmt+0x3bb>
	if (lflag >= 2)
  800677:	83 f9 01             	cmp    $0x1,%ecx
  80067a:	7e 15                	jle    800691 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 10                	mov    (%eax),%edx
  800681:	8b 48 04             	mov    0x4(%eax),%ecx
  800684:	8d 40 08             	lea    0x8(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068a:	b8 08 00 00 00       	mov    $0x8,%eax
  80068f:	eb 5a                	jmp    8006eb <vprintfmt+0x3bb>
	else if (lflag)
  800691:	85 c9                	test   %ecx,%ecx
  800693:	75 17                	jne    8006ac <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069f:	8d 40 04             	lea    0x4(%eax),%eax
  8006a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006aa:	eb 3f                	jmp    8006eb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 10                	mov    (%eax),%edx
  8006b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c1:	eb 28                	jmp    8006eb <vprintfmt+0x3bb>
			putch('0', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	53                   	push   %ebx
  8006c7:	6a 30                	push   $0x30
  8006c9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006cb:	83 c4 08             	add    $0x8,%esp
  8006ce:	53                   	push   %ebx
  8006cf:	6a 78                	push   $0x78
  8006d1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d6:	8b 10                	mov    (%eax),%edx
  8006d8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006dd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e0:	8d 40 04             	lea    0x4(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006eb:	83 ec 0c             	sub    $0xc,%esp
  8006ee:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006f2:	57                   	push   %edi
  8006f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f6:	50                   	push   %eax
  8006f7:	51                   	push   %ecx
  8006f8:	52                   	push   %edx
  8006f9:	89 da                	mov    %ebx,%edx
  8006fb:	89 f0                	mov    %esi,%eax
  8006fd:	e8 45 fb ff ff       	call   800247 <printnum>
			break;
  800702:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800705:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800708:	83 c7 01             	add    $0x1,%edi
  80070b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80070f:	83 f8 25             	cmp    $0x25,%eax
  800712:	0f 84 2f fc ff ff    	je     800347 <vprintfmt+0x17>
			if (ch == '\0')
  800718:	85 c0                	test   %eax,%eax
  80071a:	0f 84 8b 00 00 00    	je     8007ab <vprintfmt+0x47b>
			putch(ch, putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	53                   	push   %ebx
  800724:	50                   	push   %eax
  800725:	ff d6                	call   *%esi
  800727:	83 c4 10             	add    $0x10,%esp
  80072a:	eb dc                	jmp    800708 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80072c:	83 f9 01             	cmp    $0x1,%ecx
  80072f:	7e 15                	jle    800746 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800731:	8b 45 14             	mov    0x14(%ebp),%eax
  800734:	8b 10                	mov    (%eax),%edx
  800736:	8b 48 04             	mov    0x4(%eax),%ecx
  800739:	8d 40 08             	lea    0x8(%eax),%eax
  80073c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073f:	b8 10 00 00 00       	mov    $0x10,%eax
  800744:	eb a5                	jmp    8006eb <vprintfmt+0x3bb>
	else if (lflag)
  800746:	85 c9                	test   %ecx,%ecx
  800748:	75 17                	jne    800761 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 10                	mov    (%eax),%edx
  80074f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075a:	b8 10 00 00 00       	mov    $0x10,%eax
  80075f:	eb 8a                	jmp    8006eb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 14             	mov    0x14(%ebp),%eax
  800764:	8b 10                	mov    (%eax),%edx
  800766:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800771:	b8 10 00 00 00       	mov    $0x10,%eax
  800776:	e9 70 ff ff ff       	jmp    8006eb <vprintfmt+0x3bb>
			putch(ch, putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 25                	push   $0x25
  800781:	ff d6                	call   *%esi
			break;
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	e9 7a ff ff ff       	jmp    800705 <vprintfmt+0x3d5>
			putch('%', putdat);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	53                   	push   %ebx
  80078f:	6a 25                	push   $0x25
  800791:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800793:	83 c4 10             	add    $0x10,%esp
  800796:	89 f8                	mov    %edi,%eax
  800798:	eb 03                	jmp    80079d <vprintfmt+0x46d>
  80079a:	83 e8 01             	sub    $0x1,%eax
  80079d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a1:	75 f7                	jne    80079a <vprintfmt+0x46a>
  8007a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a6:	e9 5a ff ff ff       	jmp    800705 <vprintfmt+0x3d5>
}
  8007ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ae:	5b                   	pop    %ebx
  8007af:	5e                   	pop    %esi
  8007b0:	5f                   	pop    %edi
  8007b1:	5d                   	pop    %ebp
  8007b2:	c3                   	ret    

008007b3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	83 ec 18             	sub    $0x18,%esp
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d0:	85 c0                	test   %eax,%eax
  8007d2:	74 26                	je     8007fa <vsnprintf+0x47>
  8007d4:	85 d2                	test   %edx,%edx
  8007d6:	7e 22                	jle    8007fa <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d8:	ff 75 14             	pushl  0x14(%ebp)
  8007db:	ff 75 10             	pushl  0x10(%ebp)
  8007de:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e1:	50                   	push   %eax
  8007e2:	68 f6 02 80 00       	push   $0x8002f6
  8007e7:	e8 44 fb ff ff       	call   800330 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ef:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    
		return -E_INVAL;
  8007fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ff:	eb f7                	jmp    8007f8 <vsnprintf+0x45>

00800801 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800807:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80080a:	50                   	push   %eax
  80080b:	ff 75 10             	pushl  0x10(%ebp)
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	ff 75 08             	pushl  0x8(%ebp)
  800814:	e8 9a ff ff ff       	call   8007b3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800819:	c9                   	leave  
  80081a:	c3                   	ret    

0080081b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
  800826:	eb 03                	jmp    80082b <strlen+0x10>
		n++;
  800828:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80082b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80082f:	75 f7                	jne    800828 <strlen+0xd>
	return n;
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800839:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80083c:	b8 00 00 00 00       	mov    $0x0,%eax
  800841:	eb 03                	jmp    800846 <strnlen+0x13>
		n++;
  800843:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800846:	39 d0                	cmp    %edx,%eax
  800848:	74 06                	je     800850 <strnlen+0x1d>
  80084a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80084e:	75 f3                	jne    800843 <strnlen+0x10>
	return n;
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	83 c1 01             	add    $0x1,%ecx
  800861:	83 c2 01             	add    $0x1,%edx
  800864:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800868:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086b:	84 db                	test   %bl,%bl
  80086d:	75 ef                	jne    80085e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80086f:	5b                   	pop    %ebx
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800879:	53                   	push   %ebx
  80087a:	e8 9c ff ff ff       	call   80081b <strlen>
  80087f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800882:	ff 75 0c             	pushl  0xc(%ebp)
  800885:	01 d8                	add    %ebx,%eax
  800887:	50                   	push   %eax
  800888:	e8 c5 ff ff ff       	call   800852 <strcpy>
	return dst;
}
  80088d:	89 d8                	mov    %ebx,%eax
  80088f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800892:	c9                   	leave  
  800893:	c3                   	ret    

00800894 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	56                   	push   %esi
  800898:	53                   	push   %ebx
  800899:	8b 75 08             	mov    0x8(%ebp),%esi
  80089c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089f:	89 f3                	mov    %esi,%ebx
  8008a1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a4:	89 f2                	mov    %esi,%edx
  8008a6:	eb 0f                	jmp    8008b7 <strncpy+0x23>
		*dst++ = *src;
  8008a8:	83 c2 01             	add    $0x1,%edx
  8008ab:	0f b6 01             	movzbl (%ecx),%eax
  8008ae:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b1:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b7:	39 da                	cmp    %ebx,%edx
  8008b9:	75 ed                	jne    8008a8 <strncpy+0x14>
	}
	return ret;
}
  8008bb:	89 f0                	mov    %esi,%eax
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	5d                   	pop    %ebp
  8008c0:	c3                   	ret    

008008c1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	56                   	push   %esi
  8008c5:	53                   	push   %ebx
  8008c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008cf:	89 f0                	mov    %esi,%eax
  8008d1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008d5:	85 c9                	test   %ecx,%ecx
  8008d7:	75 0b                	jne    8008e4 <strlcpy+0x23>
  8008d9:	eb 17                	jmp    8008f2 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008db:	83 c2 01             	add    $0x1,%edx
  8008de:	83 c0 01             	add    $0x1,%eax
  8008e1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008e4:	39 d8                	cmp    %ebx,%eax
  8008e6:	74 07                	je     8008ef <strlcpy+0x2e>
  8008e8:	0f b6 0a             	movzbl (%edx),%ecx
  8008eb:	84 c9                	test   %cl,%cl
  8008ed:	75 ec                	jne    8008db <strlcpy+0x1a>
		*dst = '\0';
  8008ef:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008f2:	29 f0                	sub    %esi,%eax
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800901:	eb 06                	jmp    800909 <strcmp+0x11>
		p++, q++;
  800903:	83 c1 01             	add    $0x1,%ecx
  800906:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800909:	0f b6 01             	movzbl (%ecx),%eax
  80090c:	84 c0                	test   %al,%al
  80090e:	74 04                	je     800914 <strcmp+0x1c>
  800910:	3a 02                	cmp    (%edx),%al
  800912:	74 ef                	je     800903 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800914:	0f b6 c0             	movzbl %al,%eax
  800917:	0f b6 12             	movzbl (%edx),%edx
  80091a:	29 d0                	sub    %edx,%eax
}
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	53                   	push   %ebx
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 55 0c             	mov    0xc(%ebp),%edx
  800928:	89 c3                	mov    %eax,%ebx
  80092a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80092d:	eb 06                	jmp    800935 <strncmp+0x17>
		n--, p++, q++;
  80092f:	83 c0 01             	add    $0x1,%eax
  800932:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800935:	39 d8                	cmp    %ebx,%eax
  800937:	74 16                	je     80094f <strncmp+0x31>
  800939:	0f b6 08             	movzbl (%eax),%ecx
  80093c:	84 c9                	test   %cl,%cl
  80093e:	74 04                	je     800944 <strncmp+0x26>
  800940:	3a 0a                	cmp    (%edx),%cl
  800942:	74 eb                	je     80092f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800944:	0f b6 00             	movzbl (%eax),%eax
  800947:	0f b6 12             	movzbl (%edx),%edx
  80094a:	29 d0                	sub    %edx,%eax
}
  80094c:	5b                   	pop    %ebx
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    
		return 0;
  80094f:	b8 00 00 00 00       	mov    $0x0,%eax
  800954:	eb f6                	jmp    80094c <strncmp+0x2e>

00800956 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800960:	0f b6 10             	movzbl (%eax),%edx
  800963:	84 d2                	test   %dl,%dl
  800965:	74 09                	je     800970 <strchr+0x1a>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	74 0a                	je     800975 <strchr+0x1f>
	for (; *s; s++)
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	eb f0                	jmp    800960 <strchr+0xa>
			return (char *) s;
	return 0;
  800970:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800981:	eb 03                	jmp    800986 <strfind+0xf>
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800989:	38 ca                	cmp    %cl,%dl
  80098b:	74 04                	je     800991 <strfind+0x1a>
  80098d:	84 d2                	test   %dl,%dl
  80098f:	75 f2                	jne    800983 <strfind+0xc>
			break;
	return (char *) s;
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	57                   	push   %edi
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	8b 7d 08             	mov    0x8(%ebp),%edi
  80099c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80099f:	85 c9                	test   %ecx,%ecx
  8009a1:	74 13                	je     8009b6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009a3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a9:	75 05                	jne    8009b0 <memset+0x1d>
  8009ab:	f6 c1 03             	test   $0x3,%cl
  8009ae:	74 0d                	je     8009bd <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	fc                   	cld    
  8009b4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009b6:	89 f8                	mov    %edi,%eax
  8009b8:	5b                   	pop    %ebx
  8009b9:	5e                   	pop    %esi
  8009ba:	5f                   	pop    %edi
  8009bb:	5d                   	pop    %ebp
  8009bc:	c3                   	ret    
		c &= 0xFF;
  8009bd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c1:	89 d3                	mov    %edx,%ebx
  8009c3:	c1 e3 08             	shl    $0x8,%ebx
  8009c6:	89 d0                	mov    %edx,%eax
  8009c8:	c1 e0 18             	shl    $0x18,%eax
  8009cb:	89 d6                	mov    %edx,%esi
  8009cd:	c1 e6 10             	shl    $0x10,%esi
  8009d0:	09 f0                	or     %esi,%eax
  8009d2:	09 c2                	or     %eax,%edx
  8009d4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009d6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009d9:	89 d0                	mov    %edx,%eax
  8009db:	fc                   	cld    
  8009dc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009de:	eb d6                	jmp    8009b6 <memset+0x23>

008009e0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	57                   	push   %edi
  8009e4:	56                   	push   %esi
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ee:	39 c6                	cmp    %eax,%esi
  8009f0:	73 35                	jae    800a27 <memmove+0x47>
  8009f2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009f5:	39 c2                	cmp    %eax,%edx
  8009f7:	76 2e                	jbe    800a27 <memmove+0x47>
		s += n;
		d += n;
  8009f9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fc:	89 d6                	mov    %edx,%esi
  8009fe:	09 fe                	or     %edi,%esi
  800a00:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a06:	74 0c                	je     800a14 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a08:	83 ef 01             	sub    $0x1,%edi
  800a0b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a0e:	fd                   	std    
  800a0f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a11:	fc                   	cld    
  800a12:	eb 21                	jmp    800a35 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	75 ef                	jne    800a08 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a19:	83 ef 04             	sub    $0x4,%edi
  800a1c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a22:	fd                   	std    
  800a23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a25:	eb ea                	jmp    800a11 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a27:	89 f2                	mov    %esi,%edx
  800a29:	09 c2                	or     %eax,%edx
  800a2b:	f6 c2 03             	test   $0x3,%dl
  800a2e:	74 09                	je     800a39 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a30:	89 c7                	mov    %eax,%edi
  800a32:	fc                   	cld    
  800a33:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a35:	5e                   	pop    %esi
  800a36:	5f                   	pop    %edi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a39:	f6 c1 03             	test   $0x3,%cl
  800a3c:	75 f2                	jne    800a30 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a3e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a41:	89 c7                	mov    %eax,%edi
  800a43:	fc                   	cld    
  800a44:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a46:	eb ed                	jmp    800a35 <memmove+0x55>

00800a48 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a4b:	ff 75 10             	pushl  0x10(%ebp)
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	ff 75 08             	pushl  0x8(%ebp)
  800a54:	e8 87 ff ff ff       	call   8009e0 <memmove>
}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	56                   	push   %esi
  800a5f:	53                   	push   %ebx
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	89 c6                	mov    %eax,%esi
  800a68:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6b:	39 f0                	cmp    %esi,%eax
  800a6d:	74 1c                	je     800a8b <memcmp+0x30>
		if (*s1 != *s2)
  800a6f:	0f b6 08             	movzbl (%eax),%ecx
  800a72:	0f b6 1a             	movzbl (%edx),%ebx
  800a75:	38 d9                	cmp    %bl,%cl
  800a77:	75 08                	jne    800a81 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	eb ea                	jmp    800a6b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a81:	0f b6 c1             	movzbl %cl,%eax
  800a84:	0f b6 db             	movzbl %bl,%ebx
  800a87:	29 d8                	sub    %ebx,%eax
  800a89:	eb 05                	jmp    800a90 <memcmp+0x35>
	}

	return 0;
  800a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a90:	5b                   	pop    %ebx
  800a91:	5e                   	pop    %esi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9d:	89 c2                	mov    %eax,%edx
  800a9f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa2:	39 d0                	cmp    %edx,%eax
  800aa4:	73 09                	jae    800aaf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa6:	38 08                	cmp    %cl,(%eax)
  800aa8:	74 05                	je     800aaf <memfind+0x1b>
	for (; s < ends; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	eb f3                	jmp    800aa2 <memfind+0xe>
			break;
	return (void *) s;
}
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	57                   	push   %edi
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
  800ab7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abd:	eb 03                	jmp    800ac2 <strtol+0x11>
		s++;
  800abf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ac2:	0f b6 01             	movzbl (%ecx),%eax
  800ac5:	3c 20                	cmp    $0x20,%al
  800ac7:	74 f6                	je     800abf <strtol+0xe>
  800ac9:	3c 09                	cmp    $0x9,%al
  800acb:	74 f2                	je     800abf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800acd:	3c 2b                	cmp    $0x2b,%al
  800acf:	74 2e                	je     800aff <strtol+0x4e>
	int neg = 0;
  800ad1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ad6:	3c 2d                	cmp    $0x2d,%al
  800ad8:	74 2f                	je     800b09 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ada:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ae0:	75 05                	jne    800ae7 <strtol+0x36>
  800ae2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae5:	74 2c                	je     800b13 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae7:	85 db                	test   %ebx,%ebx
  800ae9:	75 0a                	jne    800af5 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aeb:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800af0:	80 39 30             	cmpb   $0x30,(%ecx)
  800af3:	74 28                	je     800b1d <strtol+0x6c>
		base = 10;
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
  800afa:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800afd:	eb 50                	jmp    800b4f <strtol+0x9e>
		s++;
  800aff:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b02:	bf 00 00 00 00       	mov    $0x0,%edi
  800b07:	eb d1                	jmp    800ada <strtol+0x29>
		s++, neg = 1;
  800b09:	83 c1 01             	add    $0x1,%ecx
  800b0c:	bf 01 00 00 00       	mov    $0x1,%edi
  800b11:	eb c7                	jmp    800ada <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b13:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b17:	74 0e                	je     800b27 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b19:	85 db                	test   %ebx,%ebx
  800b1b:	75 d8                	jne    800af5 <strtol+0x44>
		s++, base = 8;
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b25:	eb ce                	jmp    800af5 <strtol+0x44>
		s += 2, base = 16;
  800b27:	83 c1 02             	add    $0x2,%ecx
  800b2a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b2f:	eb c4                	jmp    800af5 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b31:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b34:	89 f3                	mov    %esi,%ebx
  800b36:	80 fb 19             	cmp    $0x19,%bl
  800b39:	77 29                	ja     800b64 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b3b:	0f be d2             	movsbl %dl,%edx
  800b3e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b41:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b44:	7d 30                	jge    800b76 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b46:	83 c1 01             	add    $0x1,%ecx
  800b49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b4d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b4f:	0f b6 11             	movzbl (%ecx),%edx
  800b52:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b55:	89 f3                	mov    %esi,%ebx
  800b57:	80 fb 09             	cmp    $0x9,%bl
  800b5a:	77 d5                	ja     800b31 <strtol+0x80>
			dig = *s - '0';
  800b5c:	0f be d2             	movsbl %dl,%edx
  800b5f:	83 ea 30             	sub    $0x30,%edx
  800b62:	eb dd                	jmp    800b41 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b64:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b67:	89 f3                	mov    %esi,%ebx
  800b69:	80 fb 19             	cmp    $0x19,%bl
  800b6c:	77 08                	ja     800b76 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b6e:	0f be d2             	movsbl %dl,%edx
  800b71:	83 ea 37             	sub    $0x37,%edx
  800b74:	eb cb                	jmp    800b41 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7a:	74 05                	je     800b81 <strtol+0xd0>
		*endptr = (char *) s;
  800b7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b81:	89 c2                	mov    %eax,%edx
  800b83:	f7 da                	neg    %edx
  800b85:	85 ff                	test   %edi,%edi
  800b87:	0f 45 c2             	cmovne %edx,%eax
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
  800b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba0:	89 c3                	mov    %eax,%ebx
  800ba2:	89 c7                	mov    %eax,%edi
  800ba4:	89 c6                	mov    %eax,%esi
  800ba6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5f                   	pop    %edi
  800bab:	5d                   	pop    %ebp
  800bac:	c3                   	ret    

00800bad <sys_cgetc>:

int
sys_cgetc(void)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	57                   	push   %edi
  800bb1:	56                   	push   %esi
  800bb2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bbd:	89 d1                	mov    %edx,%ecx
  800bbf:	89 d3                	mov    %edx,%ebx
  800bc1:	89 d7                	mov    %edx,%edi
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5e                   	pop    %esi
  800bc9:	5f                   	pop    %edi
  800bca:	5d                   	pop    %ebp
  800bcb:	c3                   	ret    

00800bcc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bda:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800be2:	89 cb                	mov    %ecx,%ebx
  800be4:	89 cf                	mov    %ecx,%edi
  800be6:	89 ce                	mov    %ecx,%esi
  800be8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bea:	85 c0                	test   %eax,%eax
  800bec:	7f 08                	jg     800bf6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf6:	83 ec 0c             	sub    $0xc,%esp
  800bf9:	50                   	push   %eax
  800bfa:	6a 03                	push   $0x3
  800bfc:	68 7f 29 80 00       	push   $0x80297f
  800c01:	6a 23                	push   $0x23
  800c03:	68 9c 29 80 00       	push   $0x80299c
  800c08:	e8 4b f5 ff ff       	call   800158 <_panic>

00800c0d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	57                   	push   %edi
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c13:	ba 00 00 00 00       	mov    $0x0,%edx
  800c18:	b8 02 00 00 00       	mov    $0x2,%eax
  800c1d:	89 d1                	mov    %edx,%ecx
  800c1f:	89 d3                	mov    %edx,%ebx
  800c21:	89 d7                	mov    %edx,%edi
  800c23:	89 d6                	mov    %edx,%esi
  800c25:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    

00800c2c <sys_yield>:

void
sys_yield(void)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
  800c37:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c3c:	89 d1                	mov    %edx,%ecx
  800c3e:	89 d3                	mov    %edx,%ebx
  800c40:	89 d7                	mov    %edx,%edi
  800c42:	89 d6                	mov    %edx,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c54:	be 00 00 00 00       	mov    $0x0,%esi
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5f:	b8 04 00 00 00       	mov    $0x4,%eax
  800c64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c67:	89 f7                	mov    %esi,%edi
  800c69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6b:	85 c0                	test   %eax,%eax
  800c6d:	7f 08                	jg     800c77 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c77:	83 ec 0c             	sub    $0xc,%esp
  800c7a:	50                   	push   %eax
  800c7b:	6a 04                	push   $0x4
  800c7d:	68 7f 29 80 00       	push   $0x80297f
  800c82:	6a 23                	push   $0x23
  800c84:	68 9c 29 80 00       	push   $0x80299c
  800c89:	e8 ca f4 ff ff       	call   800158 <_panic>

00800c8e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	57                   	push   %edi
  800c92:	56                   	push   %esi
  800c93:	53                   	push   %ebx
  800c94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c97:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9d:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca8:	8b 75 18             	mov    0x18(%ebp),%esi
  800cab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cad:	85 c0                	test   %eax,%eax
  800caf:	7f 08                	jg     800cb9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb9:	83 ec 0c             	sub    $0xc,%esp
  800cbc:	50                   	push   %eax
  800cbd:	6a 05                	push   $0x5
  800cbf:	68 7f 29 80 00       	push   $0x80297f
  800cc4:	6a 23                	push   $0x23
  800cc6:	68 9c 29 80 00       	push   $0x80299c
  800ccb:	e8 88 f4 ff ff       	call   800158 <_panic>

00800cd0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	57                   	push   %edi
  800cd4:	56                   	push   %esi
  800cd5:	53                   	push   %ebx
  800cd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cde:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce9:	89 df                	mov    %ebx,%edi
  800ceb:	89 de                	mov    %ebx,%esi
  800ced:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cef:	85 c0                	test   %eax,%eax
  800cf1:	7f 08                	jg     800cfb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfb:	83 ec 0c             	sub    $0xc,%esp
  800cfe:	50                   	push   %eax
  800cff:	6a 06                	push   $0x6
  800d01:	68 7f 29 80 00       	push   $0x80297f
  800d06:	6a 23                	push   $0x23
  800d08:	68 9c 29 80 00       	push   $0x80299c
  800d0d:	e8 46 f4 ff ff       	call   800158 <_panic>

00800d12 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	b8 08 00 00 00       	mov    $0x8,%eax
  800d2b:	89 df                	mov    %ebx,%edi
  800d2d:	89 de                	mov    %ebx,%esi
  800d2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d31:	85 c0                	test   %eax,%eax
  800d33:	7f 08                	jg     800d3d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3d:	83 ec 0c             	sub    $0xc,%esp
  800d40:	50                   	push   %eax
  800d41:	6a 08                	push   $0x8
  800d43:	68 7f 29 80 00       	push   $0x80297f
  800d48:	6a 23                	push   $0x23
  800d4a:	68 9c 29 80 00       	push   $0x80299c
  800d4f:	e8 04 f4 ff ff       	call   800158 <_panic>

00800d54 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	b8 09 00 00 00       	mov    $0x9,%eax
  800d6d:	89 df                	mov    %ebx,%edi
  800d6f:	89 de                	mov    %ebx,%esi
  800d71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7f 08                	jg     800d7f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7a:	5b                   	pop    %ebx
  800d7b:	5e                   	pop    %esi
  800d7c:	5f                   	pop    %edi
  800d7d:	5d                   	pop    %ebp
  800d7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7f:	83 ec 0c             	sub    $0xc,%esp
  800d82:	50                   	push   %eax
  800d83:	6a 09                	push   $0x9
  800d85:	68 7f 29 80 00       	push   $0x80297f
  800d8a:	6a 23                	push   $0x23
  800d8c:	68 9c 29 80 00       	push   $0x80299c
  800d91:	e8 c2 f3 ff ff       	call   800158 <_panic>

00800d96 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
  800d9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800daa:	b8 0a 00 00 00       	mov    $0xa,%eax
  800daf:	89 df                	mov    %ebx,%edi
  800db1:	89 de                	mov    %ebx,%esi
  800db3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db5:	85 c0                	test   %eax,%eax
  800db7:	7f 08                	jg     800dc1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5f                   	pop    %edi
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc1:	83 ec 0c             	sub    $0xc,%esp
  800dc4:	50                   	push   %eax
  800dc5:	6a 0a                	push   $0xa
  800dc7:	68 7f 29 80 00       	push   $0x80297f
  800dcc:	6a 23                	push   $0x23
  800dce:	68 9c 29 80 00       	push   $0x80299c
  800dd3:	e8 80 f3 ff ff       	call   800158 <_panic>

00800dd8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
  800ddb:	57                   	push   %edi
  800ddc:	56                   	push   %esi
  800ddd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de9:	be 00 00 00 00       	mov    $0x0,%esi
  800dee:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e04:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e11:	89 cb                	mov    %ecx,%ebx
  800e13:	89 cf                	mov    %ecx,%edi
  800e15:	89 ce                	mov    %ecx,%esi
  800e17:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7f 08                	jg     800e25 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e25:	83 ec 0c             	sub    $0xc,%esp
  800e28:	50                   	push   %eax
  800e29:	6a 0d                	push   $0xd
  800e2b:	68 7f 29 80 00       	push   $0x80297f
  800e30:	6a 23                	push   $0x23
  800e32:	68 9c 29 80 00       	push   $0x80299c
  800e37:	e8 1c f3 ff ff       	call   800158 <_panic>

00800e3c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	57                   	push   %edi
  800e40:	56                   	push   %esi
  800e41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e4c:	89 d1                	mov    %edx,%ecx
  800e4e:	89 d3                	mov    %edx,%ebx
  800e50:	89 d7                	mov    %edx,%edi
  800e52:	89 d6                	mov    %edx,%esi
  800e54:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800e63:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800e65:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e69:	74 7f                	je     800eea <pgfault+0x8f>
  800e6b:	89 d8                	mov    %ebx,%eax
  800e6d:	c1 e8 0c             	shr    $0xc,%eax
  800e70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e77:	f6 c4 08             	test   $0x8,%ah
  800e7a:	74 6e                	je     800eea <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800e7c:	e8 8c fd ff ff       	call   800c0d <sys_getenvid>
  800e81:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e83:	83 ec 04             	sub    $0x4,%esp
  800e86:	6a 07                	push   $0x7
  800e88:	68 00 f0 7f 00       	push   $0x7ff000
  800e8d:	50                   	push   %eax
  800e8e:	e8 b8 fd ff ff       	call   800c4b <sys_page_alloc>
  800e93:	83 c4 10             	add    $0x10,%esp
  800e96:	85 c0                	test   %eax,%eax
  800e98:	78 64                	js     800efe <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800e9a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800ea0:	83 ec 04             	sub    $0x4,%esp
  800ea3:	68 00 10 00 00       	push   $0x1000
  800ea8:	53                   	push   %ebx
  800ea9:	68 00 f0 7f 00       	push   $0x7ff000
  800eae:	e8 2d fb ff ff       	call   8009e0 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800eb3:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800eba:	53                   	push   %ebx
  800ebb:	56                   	push   %esi
  800ebc:	68 00 f0 7f 00       	push   $0x7ff000
  800ec1:	56                   	push   %esi
  800ec2:	e8 c7 fd ff ff       	call   800c8e <sys_page_map>
  800ec7:	83 c4 20             	add    $0x20,%esp
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	78 42                	js     800f10 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800ece:	83 ec 08             	sub    $0x8,%esp
  800ed1:	68 00 f0 7f 00       	push   $0x7ff000
  800ed6:	56                   	push   %esi
  800ed7:	e8 f4 fd ff ff       	call   800cd0 <sys_page_unmap>
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	78 3f                	js     800f22 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800eea:	83 ec 04             	sub    $0x4,%esp
  800eed:	68 ac 29 80 00       	push   $0x8029ac
  800ef2:	6a 1d                	push   $0x1d
  800ef4:	68 3b 2a 80 00       	push   $0x802a3b
  800ef9:	e8 5a f2 ff ff       	call   800158 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800efe:	50                   	push   %eax
  800eff:	68 d4 29 80 00       	push   $0x8029d4
  800f04:	6a 28                	push   $0x28
  800f06:	68 3b 2a 80 00       	push   $0x802a3b
  800f0b:	e8 48 f2 ff ff       	call   800158 <_panic>
		panic("pgfault:page map failed: %e", r);
  800f10:	50                   	push   %eax
  800f11:	68 46 2a 80 00       	push   $0x802a46
  800f16:	6a 2c                	push   $0x2c
  800f18:	68 3b 2a 80 00       	push   $0x802a3b
  800f1d:	e8 36 f2 ff ff       	call   800158 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800f22:	50                   	push   %eax
  800f23:	68 f8 29 80 00       	push   $0x8029f8
  800f28:	6a 2e                	push   $0x2e
  800f2a:	68 3b 2a 80 00       	push   $0x802a3b
  800f2f:	e8 24 f2 ff ff       	call   800158 <_panic>

00800f34 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
  800f3a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800f3d:	68 5b 0e 80 00       	push   $0x800e5b
  800f42:	e8 c6 13 00 00       	call   80230d <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f47:	b8 07 00 00 00       	mov    $0x7,%eax
  800f4c:	cd 30                	int    $0x30
  800f4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800f51:	83 c4 10             	add    $0x10,%esp
  800f54:	85 c0                	test   %eax,%eax
  800f56:	78 2f                	js     800f87 <fork+0x53>
  800f58:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f5a:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800f5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f63:	75 6e                	jne    800fd3 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f65:	e8 a3 fc ff ff       	call   800c0d <sys_getenvid>
  800f6a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f6f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f72:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f77:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800f7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800f87:	50                   	push   %eax
  800f88:	68 18 2a 80 00       	push   $0x802a18
  800f8d:	6a 6e                	push   $0x6e
  800f8f:	68 3b 2a 80 00       	push   $0x802a3b
  800f94:	e8 bf f1 ff ff       	call   800158 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800f99:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fa0:	83 ec 0c             	sub    $0xc,%esp
  800fa3:	25 07 0e 00 00       	and    $0xe07,%eax
  800fa8:	50                   	push   %eax
  800fa9:	56                   	push   %esi
  800faa:	57                   	push   %edi
  800fab:	56                   	push   %esi
  800fac:	6a 00                	push   $0x0
  800fae:	e8 db fc ff ff       	call   800c8e <sys_page_map>
  800fb3:	83 c4 20             	add    $0x20,%esp
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbd:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	78 bb                	js     800f7f <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800fc4:	83 c3 01             	add    $0x1,%ebx
  800fc7:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  800fcd:	0f 84 a6 00 00 00    	je     801079 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  800fd3:	89 d8                	mov    %ebx,%eax
  800fd5:	c1 e8 0a             	shr    $0xa,%eax
  800fd8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fdf:	a8 01                	test   $0x1,%al
  800fe1:	74 e1                	je     800fc4 <fork+0x90>
  800fe3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fea:	a8 01                	test   $0x1,%al
  800fec:	74 d6                	je     800fc4 <fork+0x90>
  800fee:	89 de                	mov    %ebx,%esi
  800ff0:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  800ff3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800ffa:	f6 c4 04             	test   $0x4,%ah
  800ffd:	75 9a                	jne    800f99 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  800fff:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801006:	a8 02                	test   $0x2,%al
  801008:	75 0c                	jne    801016 <fork+0xe2>
  80100a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801011:	f6 c4 08             	test   $0x8,%ah
  801014:	74 42                	je     801058 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	68 05 08 00 00       	push   $0x805
  80101e:	56                   	push   %esi
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	6a 00                	push   $0x0
  801023:	e8 66 fc ff ff       	call   800c8e <sys_page_map>
  801028:	83 c4 20             	add    $0x20,%esp
  80102b:	85 c0                	test   %eax,%eax
  80102d:	0f 88 4c ff ff ff    	js     800f7f <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801033:	83 ec 0c             	sub    $0xc,%esp
  801036:	68 05 08 00 00       	push   $0x805
  80103b:	56                   	push   %esi
  80103c:	6a 00                	push   $0x0
  80103e:	56                   	push   %esi
  80103f:	6a 00                	push   $0x0
  801041:	e8 48 fc ff ff       	call   800c8e <sys_page_map>
  801046:	83 c4 20             	add    $0x20,%esp
  801049:	85 c0                	test   %eax,%eax
  80104b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801050:	0f 4f c1             	cmovg  %ecx,%eax
  801053:	e9 68 ff ff ff       	jmp    800fc0 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801058:	83 ec 0c             	sub    $0xc,%esp
  80105b:	6a 05                	push   $0x5
  80105d:	56                   	push   %esi
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	6a 00                	push   $0x0
  801062:	e8 27 fc ff ff       	call   800c8e <sys_page_map>
  801067:	83 c4 20             	add    $0x20,%esp
  80106a:	85 c0                	test   %eax,%eax
  80106c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801071:	0f 4f c1             	cmovg  %ecx,%eax
  801074:	e9 47 ff ff ff       	jmp    800fc0 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801079:	83 ec 04             	sub    $0x4,%esp
  80107c:	6a 07                	push   $0x7
  80107e:	68 00 f0 bf ee       	push   $0xeebff000
  801083:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801086:	57                   	push   %edi
  801087:	e8 bf fb ff ff       	call   800c4b <sys_page_alloc>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	85 c0                	test   %eax,%eax
  801091:	0f 88 e8 fe ff ff    	js     800f7f <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801097:	83 ec 08             	sub    $0x8,%esp
  80109a:	68 72 23 80 00       	push   $0x802372
  80109f:	57                   	push   %edi
  8010a0:	e8 f1 fc ff ff       	call   800d96 <sys_env_set_pgfault_upcall>
  8010a5:	83 c4 10             	add    $0x10,%esp
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	0f 88 cf fe ff ff    	js     800f7f <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  8010b0:	83 ec 08             	sub    $0x8,%esp
  8010b3:	6a 02                	push   $0x2
  8010b5:	57                   	push   %edi
  8010b6:	e8 57 fc ff ff       	call   800d12 <sys_env_set_status>
  8010bb:	83 c4 10             	add    $0x10,%esp
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	78 08                	js     8010ca <fork+0x196>
	return eid;
  8010c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010c5:	e9 b5 fe ff ff       	jmp    800f7f <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  8010ca:	50                   	push   %eax
  8010cb:	68 62 2a 80 00       	push   $0x802a62
  8010d0:	68 87 00 00 00       	push   $0x87
  8010d5:	68 3b 2a 80 00       	push   $0x802a3b
  8010da:	e8 79 f0 ff ff       	call   800158 <_panic>

008010df <sfork>:

// Challenge!
int sfork(void)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010e5:	68 80 2a 80 00       	push   $0x802a80
  8010ea:	68 8f 00 00 00       	push   $0x8f
  8010ef:	68 3b 2a 80 00       	push   $0x802a3b
  8010f4:	e8 5f f0 ff ff       	call   800158 <_panic>

008010f9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	56                   	push   %esi
  8010fd:	53                   	push   %ebx
  8010fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801107:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801109:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80110e:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	50                   	push   %eax
  801115:	e8 e1 fc ff ff       	call   800dfb <sys_ipc_recv>
	if (from_env_store)
  80111a:	83 c4 10             	add    $0x10,%esp
  80111d:	85 f6                	test   %esi,%esi
  80111f:	74 14                	je     801135 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801121:	ba 00 00 00 00       	mov    $0x0,%edx
  801126:	85 c0                	test   %eax,%eax
  801128:	78 09                	js     801133 <ipc_recv+0x3a>
  80112a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801130:	8b 52 74             	mov    0x74(%edx),%edx
  801133:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801135:	85 db                	test   %ebx,%ebx
  801137:	74 14                	je     80114d <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801139:	ba 00 00 00 00       	mov    $0x0,%edx
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 09                	js     80114b <ipc_recv+0x52>
  801142:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801148:	8b 52 78             	mov    0x78(%edx),%edx
  80114b:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	78 08                	js     801159 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801151:	a1 08 40 80 00       	mov    0x804008,%eax
  801156:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801159:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115c:	5b                   	pop    %ebx
  80115d:	5e                   	pop    %esi
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    

00801160 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 0c             	sub    $0xc,%esp
  801169:	8b 7d 08             	mov    0x8(%ebp),%edi
  80116c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80116f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801172:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801174:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801179:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80117c:	ff 75 14             	pushl  0x14(%ebp)
  80117f:	53                   	push   %ebx
  801180:	56                   	push   %esi
  801181:	57                   	push   %edi
  801182:	e8 51 fc ff ff       	call   800dd8 <sys_ipc_try_send>
		if (ret == 0)
  801187:	83 c4 10             	add    $0x10,%esp
  80118a:	85 c0                	test   %eax,%eax
  80118c:	74 1e                	je     8011ac <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80118e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801191:	75 07                	jne    80119a <ipc_send+0x3a>
			sys_yield();
  801193:	e8 94 fa ff ff       	call   800c2c <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801198:	eb e2                	jmp    80117c <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80119a:	50                   	push   %eax
  80119b:	68 96 2a 80 00       	push   $0x802a96
  8011a0:	6a 3d                	push   $0x3d
  8011a2:	68 aa 2a 80 00       	push   $0x802aaa
  8011a7:	e8 ac ef ff ff       	call   800158 <_panic>
	}
	// panic("ipc_send not implemented");
}
  8011ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011af:	5b                   	pop    %ebx
  8011b0:	5e                   	pop    %esi
  8011b1:	5f                   	pop    %edi
  8011b2:	5d                   	pop    %ebp
  8011b3:	c3                   	ret    

008011b4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8011bf:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8011c2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8011c8:	8b 52 50             	mov    0x50(%edx),%edx
  8011cb:	39 ca                	cmp    %ecx,%edx
  8011cd:	74 11                	je     8011e0 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8011cf:	83 c0 01             	add    $0x1,%eax
  8011d2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011d7:	75 e6                	jne    8011bf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8011d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011de:	eb 0b                	jmp    8011eb <ipc_find_env+0x37>
			return envs[i].env_id;
  8011e0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011e8:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	05 00 00 00 30       	add    $0x30000000,%eax
  8011f8:	c1 e8 0c             	shr    $0xc,%eax
}
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801208:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80120d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801212:	5d                   	pop    %ebp
  801213:	c3                   	ret    

00801214 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80121f:	89 c2                	mov    %eax,%edx
  801221:	c1 ea 16             	shr    $0x16,%edx
  801224:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80122b:	f6 c2 01             	test   $0x1,%dl
  80122e:	74 2a                	je     80125a <fd_alloc+0x46>
  801230:	89 c2                	mov    %eax,%edx
  801232:	c1 ea 0c             	shr    $0xc,%edx
  801235:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123c:	f6 c2 01             	test   $0x1,%dl
  80123f:	74 19                	je     80125a <fd_alloc+0x46>
  801241:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801246:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80124b:	75 d2                	jne    80121f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80124d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801253:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801258:	eb 07                	jmp    801261 <fd_alloc+0x4d>
			*fd_store = fd;
  80125a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801269:	83 f8 1f             	cmp    $0x1f,%eax
  80126c:	77 36                	ja     8012a4 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80126e:	c1 e0 0c             	shl    $0xc,%eax
  801271:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801276:	89 c2                	mov    %eax,%edx
  801278:	c1 ea 16             	shr    $0x16,%edx
  80127b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801282:	f6 c2 01             	test   $0x1,%dl
  801285:	74 24                	je     8012ab <fd_lookup+0x48>
  801287:	89 c2                	mov    %eax,%edx
  801289:	c1 ea 0c             	shr    $0xc,%edx
  80128c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801293:	f6 c2 01             	test   $0x1,%dl
  801296:	74 1a                	je     8012b2 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129b:	89 02                	mov    %eax,(%edx)
	return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    
		return -E_INVAL;
  8012a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a9:	eb f7                	jmp    8012a2 <fd_lookup+0x3f>
		return -E_INVAL;
  8012ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b0:	eb f0                	jmp    8012a2 <fd_lookup+0x3f>
  8012b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b7:	eb e9                	jmp    8012a2 <fd_lookup+0x3f>

008012b9 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	83 ec 08             	sub    $0x8,%esp
  8012bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012c2:	ba 34 2b 80 00       	mov    $0x802b34,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012c7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012cc:	39 08                	cmp    %ecx,(%eax)
  8012ce:	74 33                	je     801303 <dev_lookup+0x4a>
  8012d0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012d3:	8b 02                	mov    (%edx),%eax
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	75 f3                	jne    8012cc <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8012de:	8b 40 48             	mov    0x48(%eax),%eax
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	51                   	push   %ecx
  8012e5:	50                   	push   %eax
  8012e6:	68 b4 2a 80 00       	push   $0x802ab4
  8012eb:	e8 43 ef ff ff       	call   800233 <cprintf>
	*dev = 0;
  8012f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012f9:	83 c4 10             	add    $0x10,%esp
  8012fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    
			*dev = devtab[i];
  801303:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801306:	89 01                	mov    %eax,(%ecx)
			return 0;
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
  80130d:	eb f2                	jmp    801301 <dev_lookup+0x48>

0080130f <fd_close>:
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	57                   	push   %edi
  801313:	56                   	push   %esi
  801314:	53                   	push   %ebx
  801315:	83 ec 1c             	sub    $0x1c,%esp
  801318:	8b 75 08             	mov    0x8(%ebp),%esi
  80131b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80131e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801321:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801322:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801328:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80132b:	50                   	push   %eax
  80132c:	e8 32 ff ff ff       	call   801263 <fd_lookup>
  801331:	89 c3                	mov    %eax,%ebx
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 05                	js     80133f <fd_close+0x30>
	    || fd != fd2)
  80133a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80133d:	74 16                	je     801355 <fd_close+0x46>
		return (must_exist ? r : 0);
  80133f:	89 f8                	mov    %edi,%eax
  801341:	84 c0                	test   %al,%al
  801343:	b8 00 00 00 00       	mov    $0x0,%eax
  801348:	0f 44 d8             	cmove  %eax,%ebx
}
  80134b:	89 d8                	mov    %ebx,%eax
  80134d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801350:	5b                   	pop    %ebx
  801351:	5e                   	pop    %esi
  801352:	5f                   	pop    %edi
  801353:	5d                   	pop    %ebp
  801354:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801355:	83 ec 08             	sub    $0x8,%esp
  801358:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80135b:	50                   	push   %eax
  80135c:	ff 36                	pushl  (%esi)
  80135e:	e8 56 ff ff ff       	call   8012b9 <dev_lookup>
  801363:	89 c3                	mov    %eax,%ebx
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	85 c0                	test   %eax,%eax
  80136a:	78 15                	js     801381 <fd_close+0x72>
		if (dev->dev_close)
  80136c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136f:	8b 40 10             	mov    0x10(%eax),%eax
  801372:	85 c0                	test   %eax,%eax
  801374:	74 1b                	je     801391 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801376:	83 ec 0c             	sub    $0xc,%esp
  801379:	56                   	push   %esi
  80137a:	ff d0                	call   *%eax
  80137c:	89 c3                	mov    %eax,%ebx
  80137e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	56                   	push   %esi
  801385:	6a 00                	push   $0x0
  801387:	e8 44 f9 ff ff       	call   800cd0 <sys_page_unmap>
	return r;
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	eb ba                	jmp    80134b <fd_close+0x3c>
			r = 0;
  801391:	bb 00 00 00 00       	mov    $0x0,%ebx
  801396:	eb e9                	jmp    801381 <fd_close+0x72>

00801398 <close>:

int
close(int fdnum)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80139e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a1:	50                   	push   %eax
  8013a2:	ff 75 08             	pushl  0x8(%ebp)
  8013a5:	e8 b9 fe ff ff       	call   801263 <fd_lookup>
  8013aa:	83 c4 08             	add    $0x8,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 10                	js     8013c1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013b1:	83 ec 08             	sub    $0x8,%esp
  8013b4:	6a 01                	push   $0x1
  8013b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b9:	e8 51 ff ff ff       	call   80130f <fd_close>
  8013be:	83 c4 10             	add    $0x10,%esp
}
  8013c1:	c9                   	leave  
  8013c2:	c3                   	ret    

008013c3 <close_all>:

void
close_all(void)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	53                   	push   %ebx
  8013c7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013ca:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013cf:	83 ec 0c             	sub    $0xc,%esp
  8013d2:	53                   	push   %ebx
  8013d3:	e8 c0 ff ff ff       	call   801398 <close>
	for (i = 0; i < MAXFD; i++)
  8013d8:	83 c3 01             	add    $0x1,%ebx
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	83 fb 20             	cmp    $0x20,%ebx
  8013e1:	75 ec                	jne    8013cf <close_all+0xc>
}
  8013e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	57                   	push   %edi
  8013ec:	56                   	push   %esi
  8013ed:	53                   	push   %ebx
  8013ee:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013f4:	50                   	push   %eax
  8013f5:	ff 75 08             	pushl  0x8(%ebp)
  8013f8:	e8 66 fe ff ff       	call   801263 <fd_lookup>
  8013fd:	89 c3                	mov    %eax,%ebx
  8013ff:	83 c4 08             	add    $0x8,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	0f 88 81 00 00 00    	js     80148b <dup+0xa3>
		return r;
	close(newfdnum);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	ff 75 0c             	pushl  0xc(%ebp)
  801410:	e8 83 ff ff ff       	call   801398 <close>

	newfd = INDEX2FD(newfdnum);
  801415:	8b 75 0c             	mov    0xc(%ebp),%esi
  801418:	c1 e6 0c             	shl    $0xc,%esi
  80141b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801421:	83 c4 04             	add    $0x4,%esp
  801424:	ff 75 e4             	pushl  -0x1c(%ebp)
  801427:	e8 d1 fd ff ff       	call   8011fd <fd2data>
  80142c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80142e:	89 34 24             	mov    %esi,(%esp)
  801431:	e8 c7 fd ff ff       	call   8011fd <fd2data>
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80143b:	89 d8                	mov    %ebx,%eax
  80143d:	c1 e8 16             	shr    $0x16,%eax
  801440:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801447:	a8 01                	test   $0x1,%al
  801449:	74 11                	je     80145c <dup+0x74>
  80144b:	89 d8                	mov    %ebx,%eax
  80144d:	c1 e8 0c             	shr    $0xc,%eax
  801450:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801457:	f6 c2 01             	test   $0x1,%dl
  80145a:	75 39                	jne    801495 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80145c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80145f:	89 d0                	mov    %edx,%eax
  801461:	c1 e8 0c             	shr    $0xc,%eax
  801464:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	25 07 0e 00 00       	and    $0xe07,%eax
  801473:	50                   	push   %eax
  801474:	56                   	push   %esi
  801475:	6a 00                	push   $0x0
  801477:	52                   	push   %edx
  801478:	6a 00                	push   $0x0
  80147a:	e8 0f f8 ff ff       	call   800c8e <sys_page_map>
  80147f:	89 c3                	mov    %eax,%ebx
  801481:	83 c4 20             	add    $0x20,%esp
  801484:	85 c0                	test   %eax,%eax
  801486:	78 31                	js     8014b9 <dup+0xd1>
		goto err;

	return newfdnum;
  801488:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80148b:	89 d8                	mov    %ebx,%eax
  80148d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801490:	5b                   	pop    %ebx
  801491:	5e                   	pop    %esi
  801492:	5f                   	pop    %edi
  801493:	5d                   	pop    %ebp
  801494:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801495:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	25 07 0e 00 00       	and    $0xe07,%eax
  8014a4:	50                   	push   %eax
  8014a5:	57                   	push   %edi
  8014a6:	6a 00                	push   $0x0
  8014a8:	53                   	push   %ebx
  8014a9:	6a 00                	push   $0x0
  8014ab:	e8 de f7 ff ff       	call   800c8e <sys_page_map>
  8014b0:	89 c3                	mov    %eax,%ebx
  8014b2:	83 c4 20             	add    $0x20,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	79 a3                	jns    80145c <dup+0x74>
	sys_page_unmap(0, newfd);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	56                   	push   %esi
  8014bd:	6a 00                	push   $0x0
  8014bf:	e8 0c f8 ff ff       	call   800cd0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014c4:	83 c4 08             	add    $0x8,%esp
  8014c7:	57                   	push   %edi
  8014c8:	6a 00                	push   $0x0
  8014ca:	e8 01 f8 ff ff       	call   800cd0 <sys_page_unmap>
	return r;
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	eb b7                	jmp    80148b <dup+0xa3>

008014d4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 14             	sub    $0x14,%esp
  8014db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e1:	50                   	push   %eax
  8014e2:	53                   	push   %ebx
  8014e3:	e8 7b fd ff ff       	call   801263 <fd_lookup>
  8014e8:	83 c4 08             	add    $0x8,%esp
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 3f                	js     80152e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ef:	83 ec 08             	sub    $0x8,%esp
  8014f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f5:	50                   	push   %eax
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	ff 30                	pushl  (%eax)
  8014fb:	e8 b9 fd ff ff       	call   8012b9 <dev_lookup>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	85 c0                	test   %eax,%eax
  801505:	78 27                	js     80152e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801507:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150a:	8b 42 08             	mov    0x8(%edx),%eax
  80150d:	83 e0 03             	and    $0x3,%eax
  801510:	83 f8 01             	cmp    $0x1,%eax
  801513:	74 1e                	je     801533 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801518:	8b 40 08             	mov    0x8(%eax),%eax
  80151b:	85 c0                	test   %eax,%eax
  80151d:	74 35                	je     801554 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	ff 75 10             	pushl  0x10(%ebp)
  801525:	ff 75 0c             	pushl  0xc(%ebp)
  801528:	52                   	push   %edx
  801529:	ff d0                	call   *%eax
  80152b:	83 c4 10             	add    $0x10,%esp
}
  80152e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801531:	c9                   	leave  
  801532:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801533:	a1 08 40 80 00       	mov    0x804008,%eax
  801538:	8b 40 48             	mov    0x48(%eax),%eax
  80153b:	83 ec 04             	sub    $0x4,%esp
  80153e:	53                   	push   %ebx
  80153f:	50                   	push   %eax
  801540:	68 f8 2a 80 00       	push   $0x802af8
  801545:	e8 e9 ec ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801552:	eb da                	jmp    80152e <read+0x5a>
		return -E_NOT_SUPP;
  801554:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801559:	eb d3                	jmp    80152e <read+0x5a>

0080155b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	57                   	push   %edi
  80155f:	56                   	push   %esi
  801560:	53                   	push   %ebx
  801561:	83 ec 0c             	sub    $0xc,%esp
  801564:	8b 7d 08             	mov    0x8(%ebp),%edi
  801567:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80156a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80156f:	39 f3                	cmp    %esi,%ebx
  801571:	73 25                	jae    801598 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	89 f0                	mov    %esi,%eax
  801578:	29 d8                	sub    %ebx,%eax
  80157a:	50                   	push   %eax
  80157b:	89 d8                	mov    %ebx,%eax
  80157d:	03 45 0c             	add    0xc(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	57                   	push   %edi
  801582:	e8 4d ff ff ff       	call   8014d4 <read>
		if (m < 0)
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	85 c0                	test   %eax,%eax
  80158c:	78 08                	js     801596 <readn+0x3b>
			return m;
		if (m == 0)
  80158e:	85 c0                	test   %eax,%eax
  801590:	74 06                	je     801598 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801592:	01 c3                	add    %eax,%ebx
  801594:	eb d9                	jmp    80156f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801596:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801598:	89 d8                	mov    %ebx,%eax
  80159a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5f                   	pop    %edi
  8015a0:	5d                   	pop    %ebp
  8015a1:	c3                   	ret    

008015a2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 14             	sub    $0x14,%esp
  8015a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	53                   	push   %ebx
  8015b1:	e8 ad fc ff ff       	call   801263 <fd_lookup>
  8015b6:	83 c4 08             	add    $0x8,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 3a                	js     8015f7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bd:	83 ec 08             	sub    $0x8,%esp
  8015c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015c3:	50                   	push   %eax
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c7:	ff 30                	pushl  (%eax)
  8015c9:	e8 eb fc ff ff       	call   8012b9 <dev_lookup>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 22                	js     8015f7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015dc:	74 1e                	je     8015fc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e1:	8b 52 0c             	mov    0xc(%edx),%edx
  8015e4:	85 d2                	test   %edx,%edx
  8015e6:	74 35                	je     80161d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	ff 75 10             	pushl  0x10(%ebp)
  8015ee:	ff 75 0c             	pushl  0xc(%ebp)
  8015f1:	50                   	push   %eax
  8015f2:	ff d2                	call   *%edx
  8015f4:	83 c4 10             	add    $0x10,%esp
}
  8015f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015fc:	a1 08 40 80 00       	mov    0x804008,%eax
  801601:	8b 40 48             	mov    0x48(%eax),%eax
  801604:	83 ec 04             	sub    $0x4,%esp
  801607:	53                   	push   %ebx
  801608:	50                   	push   %eax
  801609:	68 14 2b 80 00       	push   $0x802b14
  80160e:	e8 20 ec ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161b:	eb da                	jmp    8015f7 <write+0x55>
		return -E_NOT_SUPP;
  80161d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801622:	eb d3                	jmp    8015f7 <write+0x55>

00801624 <seek>:

int
seek(int fdnum, off_t offset)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80162d:	50                   	push   %eax
  80162e:	ff 75 08             	pushl  0x8(%ebp)
  801631:	e8 2d fc ff ff       	call   801263 <fd_lookup>
  801636:	83 c4 08             	add    $0x8,%esp
  801639:	85 c0                	test   %eax,%eax
  80163b:	78 0e                	js     80164b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80163d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801640:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801643:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	53                   	push   %ebx
  801651:	83 ec 14             	sub    $0x14,%esp
  801654:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801657:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165a:	50                   	push   %eax
  80165b:	53                   	push   %ebx
  80165c:	e8 02 fc ff ff       	call   801263 <fd_lookup>
  801661:	83 c4 08             	add    $0x8,%esp
  801664:	85 c0                	test   %eax,%eax
  801666:	78 37                	js     80169f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801668:	83 ec 08             	sub    $0x8,%esp
  80166b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166e:	50                   	push   %eax
  80166f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801672:	ff 30                	pushl  (%eax)
  801674:	e8 40 fc ff ff       	call   8012b9 <dev_lookup>
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 1f                	js     80169f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801687:	74 1b                	je     8016a4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168c:	8b 52 18             	mov    0x18(%edx),%edx
  80168f:	85 d2                	test   %edx,%edx
  801691:	74 32                	je     8016c5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801693:	83 ec 08             	sub    $0x8,%esp
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	50                   	push   %eax
  80169a:	ff d2                	call   *%edx
  80169c:	83 c4 10             	add    $0x10,%esp
}
  80169f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016a4:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016a9:	8b 40 48             	mov    0x48(%eax),%eax
  8016ac:	83 ec 04             	sub    $0x4,%esp
  8016af:	53                   	push   %ebx
  8016b0:	50                   	push   %eax
  8016b1:	68 d4 2a 80 00       	push   $0x802ad4
  8016b6:	e8 78 eb ff ff       	call   800233 <cprintf>
		return -E_INVAL;
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c3:	eb da                	jmp    80169f <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ca:	eb d3                	jmp    80169f <ftruncate+0x52>

008016cc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	53                   	push   %ebx
  8016d0:	83 ec 14             	sub    $0x14,%esp
  8016d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 81 fb ff ff       	call   801263 <fd_lookup>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 4b                	js     801734 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	ff 30                	pushl  (%eax)
  8016f5:	e8 bf fb ff ff       	call   8012b9 <dev_lookup>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 33                	js     801734 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801704:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801708:	74 2f                	je     801739 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80170a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80170d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801714:	00 00 00 
	stat->st_isdir = 0;
  801717:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80171e:	00 00 00 
	stat->st_dev = dev;
  801721:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	53                   	push   %ebx
  80172b:	ff 75 f0             	pushl  -0x10(%ebp)
  80172e:	ff 50 14             	call   *0x14(%eax)
  801731:	83 c4 10             	add    $0x10,%esp
}
  801734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801737:	c9                   	leave  
  801738:	c3                   	ret    
		return -E_NOT_SUPP;
  801739:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173e:	eb f4                	jmp    801734 <fstat+0x68>

00801740 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	6a 00                	push   $0x0
  80174a:	ff 75 08             	pushl  0x8(%ebp)
  80174d:	e8 e7 01 00 00       	call   801939 <open>
  801752:	89 c3                	mov    %eax,%ebx
  801754:	83 c4 10             	add    $0x10,%esp
  801757:	85 c0                	test   %eax,%eax
  801759:	78 1b                	js     801776 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	ff 75 0c             	pushl  0xc(%ebp)
  801761:	50                   	push   %eax
  801762:	e8 65 ff ff ff       	call   8016cc <fstat>
  801767:	89 c6                	mov    %eax,%esi
	close(fd);
  801769:	89 1c 24             	mov    %ebx,(%esp)
  80176c:	e8 27 fc ff ff       	call   801398 <close>
	return r;
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	89 f3                	mov    %esi,%ebx
}
  801776:	89 d8                	mov    %ebx,%eax
  801778:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	56                   	push   %esi
  801783:	53                   	push   %ebx
  801784:	89 c6                	mov    %eax,%esi
  801786:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801788:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80178f:	74 27                	je     8017b8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801791:	6a 07                	push   $0x7
  801793:	68 00 50 80 00       	push   $0x805000
  801798:	56                   	push   %esi
  801799:	ff 35 00 40 80 00    	pushl  0x804000
  80179f:	e8 bc f9 ff ff       	call   801160 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017a4:	83 c4 0c             	add    $0xc,%esp
  8017a7:	6a 00                	push   $0x0
  8017a9:	53                   	push   %ebx
  8017aa:	6a 00                	push   $0x0
  8017ac:	e8 48 f9 ff ff       	call   8010f9 <ipc_recv>
}
  8017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b4:	5b                   	pop    %ebx
  8017b5:	5e                   	pop    %esi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	6a 01                	push   $0x1
  8017bd:	e8 f2 f9 ff ff       	call   8011b4 <ipc_find_env>
  8017c2:	a3 00 40 80 00       	mov    %eax,0x804000
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	eb c5                	jmp    801791 <fsipc+0x12>

008017cc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ef:	e8 8b ff ff ff       	call   80177f <fsipc>
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <devfile_flush>:
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801802:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
  80180c:	b8 06 00 00 00       	mov    $0x6,%eax
  801811:	e8 69 ff ff ff       	call   80177f <fsipc>
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <devfile_stat>:
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	53                   	push   %ebx
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	8b 40 0c             	mov    0xc(%eax),%eax
  801828:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80182d:	ba 00 00 00 00       	mov    $0x0,%edx
  801832:	b8 05 00 00 00       	mov    $0x5,%eax
  801837:	e8 43 ff ff ff       	call   80177f <fsipc>
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 2c                	js     80186c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801840:	83 ec 08             	sub    $0x8,%esp
  801843:	68 00 50 80 00       	push   $0x805000
  801848:	53                   	push   %ebx
  801849:	e8 04 f0 ff ff       	call   800852 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80184e:	a1 80 50 80 00       	mov    0x805080,%eax
  801853:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801859:	a1 84 50 80 00       	mov    0x805084,%eax
  80185e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <devfile_write>:
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	83 ec 0c             	sub    $0xc,%esp
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80187f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801884:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801887:	8b 55 08             	mov    0x8(%ebp),%edx
  80188a:	8b 52 0c             	mov    0xc(%edx),%edx
  80188d:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801893:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801898:	50                   	push   %eax
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	68 08 50 80 00       	push   $0x805008
  8018a1:	e8 3a f1 ff ff       	call   8009e0 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8018a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8018b0:	e8 ca fe ff ff       	call   80177f <fsipc>
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <devfile_read>:
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018ca:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d5:	b8 03 00 00 00       	mov    $0x3,%eax
  8018da:	e8 a0 fe ff ff       	call   80177f <fsipc>
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 1f                	js     801904 <devfile_read+0x4d>
	assert(r <= n);
  8018e5:	39 f0                	cmp    %esi,%eax
  8018e7:	77 24                	ja     80190d <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018e9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ee:	7f 33                	jg     801923 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	50                   	push   %eax
  8018f4:	68 00 50 80 00       	push   $0x805000
  8018f9:	ff 75 0c             	pushl  0xc(%ebp)
  8018fc:	e8 df f0 ff ff       	call   8009e0 <memmove>
	return r;
  801901:	83 c4 10             	add    $0x10,%esp
}
  801904:	89 d8                	mov    %ebx,%eax
  801906:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801909:	5b                   	pop    %ebx
  80190a:	5e                   	pop    %esi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    
	assert(r <= n);
  80190d:	68 48 2b 80 00       	push   $0x802b48
  801912:	68 4f 2b 80 00       	push   $0x802b4f
  801917:	6a 7b                	push   $0x7b
  801919:	68 64 2b 80 00       	push   $0x802b64
  80191e:	e8 35 e8 ff ff       	call   800158 <_panic>
	assert(r <= PGSIZE);
  801923:	68 6f 2b 80 00       	push   $0x802b6f
  801928:	68 4f 2b 80 00       	push   $0x802b4f
  80192d:	6a 7c                	push   $0x7c
  80192f:	68 64 2b 80 00       	push   $0x802b64
  801934:	e8 1f e8 ff ff       	call   800158 <_panic>

00801939 <open>:
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	56                   	push   %esi
  80193d:	53                   	push   %ebx
  80193e:	83 ec 1c             	sub    $0x1c,%esp
  801941:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801944:	56                   	push   %esi
  801945:	e8 d1 ee ff ff       	call   80081b <strlen>
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801952:	7f 6c                	jg     8019c0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801954:	83 ec 0c             	sub    $0xc,%esp
  801957:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195a:	50                   	push   %eax
  80195b:	e8 b4 f8 ff ff       	call   801214 <fd_alloc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	85 c0                	test   %eax,%eax
  801967:	78 3c                	js     8019a5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	56                   	push   %esi
  80196d:	68 00 50 80 00       	push   $0x805000
  801972:	e8 db ee ff ff       	call   800852 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80197f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801982:	b8 01 00 00 00       	mov    $0x1,%eax
  801987:	e8 f3 fd ff ff       	call   80177f <fsipc>
  80198c:	89 c3                	mov    %eax,%ebx
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	85 c0                	test   %eax,%eax
  801993:	78 19                	js     8019ae <open+0x75>
	return fd2num(fd);
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	ff 75 f4             	pushl  -0xc(%ebp)
  80199b:	e8 4d f8 ff ff       	call   8011ed <fd2num>
  8019a0:	89 c3                	mov    %eax,%ebx
  8019a2:	83 c4 10             	add    $0x10,%esp
}
  8019a5:	89 d8                	mov    %ebx,%eax
  8019a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019aa:	5b                   	pop    %ebx
  8019ab:	5e                   	pop    %esi
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    
		fd_close(fd, 0);
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b6:	e8 54 f9 ff ff       	call   80130f <fd_close>
		return r;
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	eb e5                	jmp    8019a5 <open+0x6c>
		return -E_BAD_PATH;
  8019c0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019c5:	eb de                	jmp    8019a5 <open+0x6c>

008019c7 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019d7:	e8 a3 fd ff ff       	call   80177f <fsipc>
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019e4:	68 7b 2b 80 00       	push   $0x802b7b
  8019e9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ec:	e8 61 ee ff ff       	call   800852 <strcpy>
	return 0;
}
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <devsock_close>:
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 10             	sub    $0x10,%esp
  8019ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a02:	53                   	push   %ebx
  801a03:	e8 90 09 00 00       	call   802398 <pageref>
  801a08:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a0b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a10:	83 f8 01             	cmp    $0x1,%eax
  801a13:	74 07                	je     801a1c <devsock_close+0x24>
}
  801a15:	89 d0                	mov    %edx,%eax
  801a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a1c:	83 ec 0c             	sub    $0xc,%esp
  801a1f:	ff 73 0c             	pushl  0xc(%ebx)
  801a22:	e8 b7 02 00 00       	call   801cde <nsipc_close>
  801a27:	89 c2                	mov    %eax,%edx
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	eb e7                	jmp    801a15 <devsock_close+0x1d>

00801a2e <devsock_write>:
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 10             	pushl  0x10(%ebp)
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	ff 70 0c             	pushl  0xc(%eax)
  801a42:	e8 74 03 00 00       	call   801dbb <nsipc_send>
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <devsock_read>:
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	ff 75 10             	pushl  0x10(%ebp)
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	ff 70 0c             	pushl  0xc(%eax)
  801a5d:	e8 ed 02 00 00       	call   801d4f <nsipc_recv>
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <fd2sockid>:
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a6a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	e8 ef f7 ff ff       	call   801263 <fd_lookup>
  801a74:	83 c4 10             	add    $0x10,%esp
  801a77:	85 c0                	test   %eax,%eax
  801a79:	78 10                	js     801a8b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a84:	39 08                	cmp    %ecx,(%eax)
  801a86:	75 05                	jne    801a8d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a88:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    
		return -E_NOT_SUPP;
  801a8d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a92:	eb f7                	jmp    801a8b <fd2sockid+0x27>

00801a94 <alloc_sockfd>:
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	83 ec 1c             	sub    $0x1c,%esp
  801a9c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa1:	50                   	push   %eax
  801aa2:	e8 6d f7 ff ff       	call   801214 <fd_alloc>
  801aa7:	89 c3                	mov    %eax,%ebx
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 43                	js     801af3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ab0:	83 ec 04             	sub    $0x4,%esp
  801ab3:	68 07 04 00 00       	push   $0x407
  801ab8:	ff 75 f4             	pushl  -0xc(%ebp)
  801abb:	6a 00                	push   $0x0
  801abd:	e8 89 f1 ff ff       	call   800c4b <sys_page_alloc>
  801ac2:	89 c3                	mov    %eax,%ebx
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 28                	js     801af3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ace:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ad4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ae0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ae3:	83 ec 0c             	sub    $0xc,%esp
  801ae6:	50                   	push   %eax
  801ae7:	e8 01 f7 ff ff       	call   8011ed <fd2num>
  801aec:	89 c3                	mov    %eax,%ebx
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	eb 0c                	jmp    801aff <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801af3:	83 ec 0c             	sub    $0xc,%esp
  801af6:	56                   	push   %esi
  801af7:	e8 e2 01 00 00       	call   801cde <nsipc_close>
		return r;
  801afc:	83 c4 10             	add    $0x10,%esp
}
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    

00801b08 <accept>:
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	e8 4e ff ff ff       	call   801a64 <fd2sockid>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	78 1b                	js     801b35 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	50                   	push   %eax
  801b24:	e8 0e 01 00 00       	call   801c37 <nsipc_accept>
  801b29:	83 c4 10             	add    $0x10,%esp
  801b2c:	85 c0                	test   %eax,%eax
  801b2e:	78 05                	js     801b35 <accept+0x2d>
	return alloc_sockfd(r);
  801b30:	e8 5f ff ff ff       	call   801a94 <alloc_sockfd>
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <bind>:
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	e8 1f ff ff ff       	call   801a64 <fd2sockid>
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 12                	js     801b5b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	50                   	push   %eax
  801b53:	e8 2f 01 00 00       	call   801c87 <nsipc_bind>
  801b58:	83 c4 10             	add    $0x10,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <shutdown>:
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	e8 f9 fe ff ff       	call   801a64 <fd2sockid>
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 0f                	js     801b7e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b6f:	83 ec 08             	sub    $0x8,%esp
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	50                   	push   %eax
  801b76:	e8 41 01 00 00       	call   801cbc <nsipc_shutdown>
  801b7b:	83 c4 10             	add    $0x10,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <connect>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	e8 d6 fe ff ff       	call   801a64 <fd2sockid>
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 12                	js     801ba4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	ff 75 0c             	pushl  0xc(%ebp)
  801b9b:	50                   	push   %eax
  801b9c:	e8 57 01 00 00       	call   801cf8 <nsipc_connect>
  801ba1:	83 c4 10             	add    $0x10,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <listen>:
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	e8 b0 fe ff ff       	call   801a64 <fd2sockid>
  801bb4:	85 c0                	test   %eax,%eax
  801bb6:	78 0f                	js     801bc7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801bb8:	83 ec 08             	sub    $0x8,%esp
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	e8 69 01 00 00       	call   801d2d <nsipc_listen>
  801bc4:	83 c4 10             	add    $0x10,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bcf:	ff 75 10             	pushl  0x10(%ebp)
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	ff 75 08             	pushl  0x8(%ebp)
  801bd8:	e8 3c 02 00 00       	call   801e19 <nsipc_socket>
  801bdd:	83 c4 10             	add    $0x10,%esp
  801be0:	85 c0                	test   %eax,%eax
  801be2:	78 05                	js     801be9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801be4:	e8 ab fe ff ff       	call   801a94 <alloc_sockfd>
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	53                   	push   %ebx
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bf4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bfb:	74 26                	je     801c23 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bfd:	6a 07                	push   $0x7
  801bff:	68 00 60 80 00       	push   $0x806000
  801c04:	53                   	push   %ebx
  801c05:	ff 35 04 40 80 00    	pushl  0x804004
  801c0b:	e8 50 f5 ff ff       	call   801160 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c10:	83 c4 0c             	add    $0xc,%esp
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	e8 db f4 ff ff       	call   8010f9 <ipc_recv>
}
  801c1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c23:	83 ec 0c             	sub    $0xc,%esp
  801c26:	6a 02                	push   $0x2
  801c28:	e8 87 f5 ff ff       	call   8011b4 <ipc_find_env>
  801c2d:	a3 04 40 80 00       	mov    %eax,0x804004
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	eb c6                	jmp    801bfd <nsipc+0x12>

00801c37 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c47:	8b 06                	mov    (%esi),%eax
  801c49:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c53:	e8 93 ff ff ff       	call   801beb <nsipc>
  801c58:	89 c3                	mov    %eax,%ebx
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 20                	js     801c7e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c5e:	83 ec 04             	sub    $0x4,%esp
  801c61:	ff 35 10 60 80 00    	pushl  0x806010
  801c67:	68 00 60 80 00       	push   $0x806000
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	e8 6c ed ff ff       	call   8009e0 <memmove>
		*addrlen = ret->ret_addrlen;
  801c74:	a1 10 60 80 00       	mov    0x806010,%eax
  801c79:	89 06                	mov    %eax,(%esi)
  801c7b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c7e:	89 d8                	mov    %ebx,%eax
  801c80:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c83:	5b                   	pop    %ebx
  801c84:	5e                   	pop    %esi
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	53                   	push   %ebx
  801c8b:	83 ec 08             	sub    $0x8,%esp
  801c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c99:	53                   	push   %ebx
  801c9a:	ff 75 0c             	pushl  0xc(%ebp)
  801c9d:	68 04 60 80 00       	push   $0x806004
  801ca2:	e8 39 ed ff ff       	call   8009e0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ca7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cad:	b8 02 00 00 00       	mov    $0x2,%eax
  801cb2:	e8 34 ff ff ff       	call   801beb <nsipc>
}
  801cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cd2:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd7:	e8 0f ff ff ff       	call   801beb <nsipc>
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <nsipc_close>:

int
nsipc_close(int s)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cec:	b8 04 00 00 00       	mov    $0x4,%eax
  801cf1:	e8 f5 fe ff ff       	call   801beb <nsipc>
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	53                   	push   %ebx
  801cfc:	83 ec 08             	sub    $0x8,%esp
  801cff:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d0a:	53                   	push   %ebx
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	68 04 60 80 00       	push   $0x806004
  801d13:	e8 c8 ec ff ff       	call   8009e0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d18:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d1e:	b8 05 00 00 00       	mov    $0x5,%eax
  801d23:	e8 c3 fe ff ff       	call   801beb <nsipc>
}
  801d28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d43:	b8 06 00 00 00       	mov    $0x6,%eax
  801d48:	e8 9e fe ff ff       	call   801beb <nsipc>
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	56                   	push   %esi
  801d53:	53                   	push   %ebx
  801d54:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d57:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d5f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d65:	8b 45 14             	mov    0x14(%ebp),%eax
  801d68:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d6d:	b8 07 00 00 00       	mov    $0x7,%eax
  801d72:	e8 74 fe ff ff       	call   801beb <nsipc>
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	78 1f                	js     801d9c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d7d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d82:	7f 21                	jg     801da5 <nsipc_recv+0x56>
  801d84:	39 c6                	cmp    %eax,%esi
  801d86:	7c 1d                	jl     801da5 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	50                   	push   %eax
  801d8c:	68 00 60 80 00       	push   $0x806000
  801d91:	ff 75 0c             	pushl  0xc(%ebp)
  801d94:	e8 47 ec ff ff       	call   8009e0 <memmove>
  801d99:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d9c:	89 d8                	mov    %ebx,%eax
  801d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801da5:	68 87 2b 80 00       	push   $0x802b87
  801daa:	68 4f 2b 80 00       	push   $0x802b4f
  801daf:	6a 62                	push   $0x62
  801db1:	68 9c 2b 80 00       	push   $0x802b9c
  801db6:	e8 9d e3 ff ff       	call   800158 <_panic>

00801dbb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dcd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dd3:	7f 2e                	jg     801e03 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dd5:	83 ec 04             	sub    $0x4,%esp
  801dd8:	53                   	push   %ebx
  801dd9:	ff 75 0c             	pushl  0xc(%ebp)
  801ddc:	68 0c 60 80 00       	push   $0x80600c
  801de1:	e8 fa eb ff ff       	call   8009e0 <memmove>
	nsipcbuf.send.req_size = size;
  801de6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dec:	8b 45 14             	mov    0x14(%ebp),%eax
  801def:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801df4:	b8 08 00 00 00       	mov    $0x8,%eax
  801df9:	e8 ed fd ff ff       	call   801beb <nsipc>
}
  801dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    
	assert(size < 1600);
  801e03:	68 a8 2b 80 00       	push   $0x802ba8
  801e08:	68 4f 2b 80 00       	push   $0x802b4f
  801e0d:	6a 6d                	push   $0x6d
  801e0f:	68 9c 2b 80 00       	push   $0x802b9c
  801e14:	e8 3f e3 ff ff       	call   800158 <_panic>

00801e19 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e32:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e37:	b8 09 00 00 00       	mov    $0x9,%eax
  801e3c:	e8 aa fd ff ff       	call   801beb <nsipc>
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	56                   	push   %esi
  801e47:	53                   	push   %ebx
  801e48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e4b:	83 ec 0c             	sub    $0xc,%esp
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	e8 a7 f3 ff ff       	call   8011fd <fd2data>
  801e56:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e58:	83 c4 08             	add    $0x8,%esp
  801e5b:	68 b4 2b 80 00       	push   $0x802bb4
  801e60:	53                   	push   %ebx
  801e61:	e8 ec e9 ff ff       	call   800852 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e66:	8b 46 04             	mov    0x4(%esi),%eax
  801e69:	2b 06                	sub    (%esi),%eax
  801e6b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e71:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e78:	00 00 00 
	stat->st_dev = &devpipe;
  801e7b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e82:	30 80 00 
	return 0;
}
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5e                   	pop    %esi
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    

00801e91 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	53                   	push   %ebx
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e9b:	53                   	push   %ebx
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 2d ee ff ff       	call   800cd0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ea3:	89 1c 24             	mov    %ebx,(%esp)
  801ea6:	e8 52 f3 ff ff       	call   8011fd <fd2data>
  801eab:	83 c4 08             	add    $0x8,%esp
  801eae:	50                   	push   %eax
  801eaf:	6a 00                	push   $0x0
  801eb1:	e8 1a ee ff ff       	call   800cd0 <sys_page_unmap>
}
  801eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <_pipeisclosed>:
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	57                   	push   %edi
  801ebf:	56                   	push   %esi
  801ec0:	53                   	push   %ebx
  801ec1:	83 ec 1c             	sub    $0x1c,%esp
  801ec4:	89 c7                	mov    %eax,%edi
  801ec6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ec8:	a1 08 40 80 00       	mov    0x804008,%eax
  801ecd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	57                   	push   %edi
  801ed4:	e8 bf 04 00 00       	call   802398 <pageref>
  801ed9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801edc:	89 34 24             	mov    %esi,(%esp)
  801edf:	e8 b4 04 00 00       	call   802398 <pageref>
		nn = thisenv->env_runs;
  801ee4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801eea:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	39 cb                	cmp    %ecx,%ebx
  801ef2:	74 1b                	je     801f0f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ef4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef7:	75 cf                	jne    801ec8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ef9:	8b 42 58             	mov    0x58(%edx),%eax
  801efc:	6a 01                	push   $0x1
  801efe:	50                   	push   %eax
  801eff:	53                   	push   %ebx
  801f00:	68 bb 2b 80 00       	push   $0x802bbb
  801f05:	e8 29 e3 ff ff       	call   800233 <cprintf>
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	eb b9                	jmp    801ec8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f0f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f12:	0f 94 c0             	sete   %al
  801f15:	0f b6 c0             	movzbl %al,%eax
}
  801f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1b:	5b                   	pop    %ebx
  801f1c:	5e                   	pop    %esi
  801f1d:	5f                   	pop    %edi
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    

00801f20 <devpipe_write>:
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	57                   	push   %edi
  801f24:	56                   	push   %esi
  801f25:	53                   	push   %ebx
  801f26:	83 ec 28             	sub    $0x28,%esp
  801f29:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f2c:	56                   	push   %esi
  801f2d:	e8 cb f2 ff ff       	call   8011fd <fd2data>
  801f32:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	bf 00 00 00 00       	mov    $0x0,%edi
  801f3c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f3f:	74 4f                	je     801f90 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f41:	8b 43 04             	mov    0x4(%ebx),%eax
  801f44:	8b 0b                	mov    (%ebx),%ecx
  801f46:	8d 51 20             	lea    0x20(%ecx),%edx
  801f49:	39 d0                	cmp    %edx,%eax
  801f4b:	72 14                	jb     801f61 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f4d:	89 da                	mov    %ebx,%edx
  801f4f:	89 f0                	mov    %esi,%eax
  801f51:	e8 65 ff ff ff       	call   801ebb <_pipeisclosed>
  801f56:	85 c0                	test   %eax,%eax
  801f58:	75 3a                	jne    801f94 <devpipe_write+0x74>
			sys_yield();
  801f5a:	e8 cd ec ff ff       	call   800c2c <sys_yield>
  801f5f:	eb e0                	jmp    801f41 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f64:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f68:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f6b:	89 c2                	mov    %eax,%edx
  801f6d:	c1 fa 1f             	sar    $0x1f,%edx
  801f70:	89 d1                	mov    %edx,%ecx
  801f72:	c1 e9 1b             	shr    $0x1b,%ecx
  801f75:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f78:	83 e2 1f             	and    $0x1f,%edx
  801f7b:	29 ca                	sub    %ecx,%edx
  801f7d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f81:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f85:	83 c0 01             	add    $0x1,%eax
  801f88:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f8b:	83 c7 01             	add    $0x1,%edi
  801f8e:	eb ac                	jmp    801f3c <devpipe_write+0x1c>
	return i;
  801f90:	89 f8                	mov    %edi,%eax
  801f92:	eb 05                	jmp    801f99 <devpipe_write+0x79>
				return 0;
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f9c:	5b                   	pop    %ebx
  801f9d:	5e                   	pop    %esi
  801f9e:	5f                   	pop    %edi
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    

00801fa1 <devpipe_read>:
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	57                   	push   %edi
  801fa5:	56                   	push   %esi
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 18             	sub    $0x18,%esp
  801faa:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801fad:	57                   	push   %edi
  801fae:	e8 4a f2 ff ff       	call   8011fd <fd2data>
  801fb3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801fb5:	83 c4 10             	add    $0x10,%esp
  801fb8:	be 00 00 00 00       	mov    $0x0,%esi
  801fbd:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc0:	74 47                	je     802009 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801fc2:	8b 03                	mov    (%ebx),%eax
  801fc4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fc7:	75 22                	jne    801feb <devpipe_read+0x4a>
			if (i > 0)
  801fc9:	85 f6                	test   %esi,%esi
  801fcb:	75 14                	jne    801fe1 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801fcd:	89 da                	mov    %ebx,%edx
  801fcf:	89 f8                	mov    %edi,%eax
  801fd1:	e8 e5 fe ff ff       	call   801ebb <_pipeisclosed>
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	75 33                	jne    80200d <devpipe_read+0x6c>
			sys_yield();
  801fda:	e8 4d ec ff ff       	call   800c2c <sys_yield>
  801fdf:	eb e1                	jmp    801fc2 <devpipe_read+0x21>
				return i;
  801fe1:	89 f0                	mov    %esi,%eax
}
  801fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fe6:	5b                   	pop    %ebx
  801fe7:	5e                   	pop    %esi
  801fe8:	5f                   	pop    %edi
  801fe9:	5d                   	pop    %ebp
  801fea:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801feb:	99                   	cltd   
  801fec:	c1 ea 1b             	shr    $0x1b,%edx
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	83 e0 1f             	and    $0x1f,%eax
  801ff4:	29 d0                	sub    %edx,%eax
  801ff6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ffe:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802001:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802004:	83 c6 01             	add    $0x1,%esi
  802007:	eb b4                	jmp    801fbd <devpipe_read+0x1c>
	return i;
  802009:	89 f0                	mov    %esi,%eax
  80200b:	eb d6                	jmp    801fe3 <devpipe_read+0x42>
				return 0;
  80200d:	b8 00 00 00 00       	mov    $0x0,%eax
  802012:	eb cf                	jmp    801fe3 <devpipe_read+0x42>

00802014 <pipe>:
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	56                   	push   %esi
  802018:	53                   	push   %ebx
  802019:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80201c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201f:	50                   	push   %eax
  802020:	e8 ef f1 ff ff       	call   801214 <fd_alloc>
  802025:	89 c3                	mov    %eax,%ebx
  802027:	83 c4 10             	add    $0x10,%esp
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 5b                	js     802089 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202e:	83 ec 04             	sub    $0x4,%esp
  802031:	68 07 04 00 00       	push   $0x407
  802036:	ff 75 f4             	pushl  -0xc(%ebp)
  802039:	6a 00                	push   $0x0
  80203b:	e8 0b ec ff ff       	call   800c4b <sys_page_alloc>
  802040:	89 c3                	mov    %eax,%ebx
  802042:	83 c4 10             	add    $0x10,%esp
  802045:	85 c0                	test   %eax,%eax
  802047:	78 40                	js     802089 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80204f:	50                   	push   %eax
  802050:	e8 bf f1 ff ff       	call   801214 <fd_alloc>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 1b                	js     802079 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	68 07 04 00 00       	push   $0x407
  802066:	ff 75 f0             	pushl  -0x10(%ebp)
  802069:	6a 00                	push   $0x0
  80206b:	e8 db eb ff ff       	call   800c4b <sys_page_alloc>
  802070:	89 c3                	mov    %eax,%ebx
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	79 19                	jns    802092 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802079:	83 ec 08             	sub    $0x8,%esp
  80207c:	ff 75 f4             	pushl  -0xc(%ebp)
  80207f:	6a 00                	push   $0x0
  802081:	e8 4a ec ff ff       	call   800cd0 <sys_page_unmap>
  802086:	83 c4 10             	add    $0x10,%esp
}
  802089:	89 d8                	mov    %ebx,%eax
  80208b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80208e:	5b                   	pop    %ebx
  80208f:	5e                   	pop    %esi
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    
	va = fd2data(fd0);
  802092:	83 ec 0c             	sub    $0xc,%esp
  802095:	ff 75 f4             	pushl  -0xc(%ebp)
  802098:	e8 60 f1 ff ff       	call   8011fd <fd2data>
  80209d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209f:	83 c4 0c             	add    $0xc,%esp
  8020a2:	68 07 04 00 00       	push   $0x407
  8020a7:	50                   	push   %eax
  8020a8:	6a 00                	push   $0x0
  8020aa:	e8 9c eb ff ff       	call   800c4b <sys_page_alloc>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	83 c4 10             	add    $0x10,%esp
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	0f 88 8c 00 00 00    	js     802148 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8020c2:	e8 36 f1 ff ff       	call   8011fd <fd2data>
  8020c7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020ce:	50                   	push   %eax
  8020cf:	6a 00                	push   $0x0
  8020d1:	56                   	push   %esi
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 b5 eb ff ff       	call   800c8e <sys_page_map>
  8020d9:	89 c3                	mov    %eax,%ebx
  8020db:	83 c4 20             	add    $0x20,%esp
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	78 58                	js     80213a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020eb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8020f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802100:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802105:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80210c:	83 ec 0c             	sub    $0xc,%esp
  80210f:	ff 75 f4             	pushl  -0xc(%ebp)
  802112:	e8 d6 f0 ff ff       	call   8011ed <fd2num>
  802117:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80211a:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80211c:	83 c4 04             	add    $0x4,%esp
  80211f:	ff 75 f0             	pushl  -0x10(%ebp)
  802122:	e8 c6 f0 ff ff       	call   8011ed <fd2num>
  802127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80212a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	bb 00 00 00 00       	mov    $0x0,%ebx
  802135:	e9 4f ff ff ff       	jmp    802089 <pipe+0x75>
	sys_page_unmap(0, va);
  80213a:	83 ec 08             	sub    $0x8,%esp
  80213d:	56                   	push   %esi
  80213e:	6a 00                	push   $0x0
  802140:	e8 8b eb ff ff       	call   800cd0 <sys_page_unmap>
  802145:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802148:	83 ec 08             	sub    $0x8,%esp
  80214b:	ff 75 f0             	pushl  -0x10(%ebp)
  80214e:	6a 00                	push   $0x0
  802150:	e8 7b eb ff ff       	call   800cd0 <sys_page_unmap>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	e9 1c ff ff ff       	jmp    802079 <pipe+0x65>

0080215d <pipeisclosed>:
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802163:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	ff 75 08             	pushl  0x8(%ebp)
  80216a:	e8 f4 f0 ff ff       	call   801263 <fd_lookup>
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	85 c0                	test   %eax,%eax
  802174:	78 18                	js     80218e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802176:	83 ec 0c             	sub    $0xc,%esp
  802179:	ff 75 f4             	pushl  -0xc(%ebp)
  80217c:	e8 7c f0 ff ff       	call   8011fd <fd2data>
	return _pipeisclosed(fd, p);
  802181:	89 c2                	mov    %eax,%edx
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	e8 30 fd ff ff       	call   801ebb <_pipeisclosed>
  80218b:	83 c4 10             	add    $0x10,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    

0080219a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021a0:	68 d3 2b 80 00       	push   $0x802bd3
  8021a5:	ff 75 0c             	pushl  0xc(%ebp)
  8021a8:	e8 a5 e6 ff ff       	call   800852 <strcpy>
	return 0;
}
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <devcons_write>:
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	57                   	push   %edi
  8021b8:	56                   	push   %esi
  8021b9:	53                   	push   %ebx
  8021ba:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021c0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021c5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021cb:	eb 2f                	jmp    8021fc <devcons_write+0x48>
		m = n - tot;
  8021cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021d0:	29 f3                	sub    %esi,%ebx
  8021d2:	83 fb 7f             	cmp    $0x7f,%ebx
  8021d5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021da:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021dd:	83 ec 04             	sub    $0x4,%esp
  8021e0:	53                   	push   %ebx
  8021e1:	89 f0                	mov    %esi,%eax
  8021e3:	03 45 0c             	add    0xc(%ebp),%eax
  8021e6:	50                   	push   %eax
  8021e7:	57                   	push   %edi
  8021e8:	e8 f3 e7 ff ff       	call   8009e0 <memmove>
		sys_cputs(buf, m);
  8021ed:	83 c4 08             	add    $0x8,%esp
  8021f0:	53                   	push   %ebx
  8021f1:	57                   	push   %edi
  8021f2:	e8 98 e9 ff ff       	call   800b8f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021f7:	01 de                	add    %ebx,%esi
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021ff:	72 cc                	jb     8021cd <devcons_write+0x19>
}
  802201:	89 f0                	mov    %esi,%eax
  802203:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802206:	5b                   	pop    %ebx
  802207:	5e                   	pop    %esi
  802208:	5f                   	pop    %edi
  802209:	5d                   	pop    %ebp
  80220a:	c3                   	ret    

0080220b <devcons_read>:
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 08             	sub    $0x8,%esp
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80221a:	75 07                	jne    802223 <devcons_read+0x18>
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    
		sys_yield();
  80221e:	e8 09 ea ff ff       	call   800c2c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802223:	e8 85 e9 ff ff       	call   800bad <sys_cgetc>
  802228:	85 c0                	test   %eax,%eax
  80222a:	74 f2                	je     80221e <devcons_read+0x13>
	if (c < 0)
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 ec                	js     80221c <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802230:	83 f8 04             	cmp    $0x4,%eax
  802233:	74 0c                	je     802241 <devcons_read+0x36>
	*(char*)vbuf = c;
  802235:	8b 55 0c             	mov    0xc(%ebp),%edx
  802238:	88 02                	mov    %al,(%edx)
	return 1;
  80223a:	b8 01 00 00 00       	mov    $0x1,%eax
  80223f:	eb db                	jmp    80221c <devcons_read+0x11>
		return 0;
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
  802246:	eb d4                	jmp    80221c <devcons_read+0x11>

00802248 <cputchar>:
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802254:	6a 01                	push   $0x1
  802256:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802259:	50                   	push   %eax
  80225a:	e8 30 e9 ff ff       	call   800b8f <sys_cputs>
}
  80225f:	83 c4 10             	add    $0x10,%esp
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <getchar>:
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80226a:	6a 01                	push   $0x1
  80226c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80226f:	50                   	push   %eax
  802270:	6a 00                	push   $0x0
  802272:	e8 5d f2 ff ff       	call   8014d4 <read>
	if (r < 0)
  802277:	83 c4 10             	add    $0x10,%esp
  80227a:	85 c0                	test   %eax,%eax
  80227c:	78 08                	js     802286 <getchar+0x22>
	if (r < 1)
  80227e:	85 c0                	test   %eax,%eax
  802280:	7e 06                	jle    802288 <getchar+0x24>
	return c;
  802282:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    
		return -E_EOF;
  802288:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80228d:	eb f7                	jmp    802286 <getchar+0x22>

0080228f <iscons>:
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802295:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802298:	50                   	push   %eax
  802299:	ff 75 08             	pushl  0x8(%ebp)
  80229c:	e8 c2 ef ff ff       	call   801263 <fd_lookup>
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 11                	js     8022b9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022b1:	39 10                	cmp    %edx,(%eax)
  8022b3:	0f 94 c0             	sete   %al
  8022b6:	0f b6 c0             	movzbl %al,%eax
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <opencons>:
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c4:	50                   	push   %eax
  8022c5:	e8 4a ef ff ff       	call   801214 <fd_alloc>
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	78 3a                	js     80230b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 07 04 00 00       	push   $0x407
  8022d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8022dc:	6a 00                	push   $0x0
  8022de:	e8 68 e9 ff ff       	call   800c4b <sys_page_alloc>
  8022e3:	83 c4 10             	add    $0x10,%esp
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	78 21                	js     80230b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022f3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022ff:	83 ec 0c             	sub    $0xc,%esp
  802302:	50                   	push   %eax
  802303:	e8 e5 ee ff ff       	call   8011ed <fd2num>
  802308:	83 c4 10             	add    $0x10,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  802313:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80231a:	74 0a                	je     802326 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802326:	a1 08 40 80 00       	mov    0x804008,%eax
  80232b:	8b 40 48             	mov    0x48(%eax),%eax
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	6a 07                	push   $0x7
  802333:	68 00 f0 bf ee       	push   $0xeebff000
  802338:	50                   	push   %eax
  802339:	e8 0d e9 ff ff       	call   800c4b <sys_page_alloc>
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	85 c0                	test   %eax,%eax
  802343:	78 1b                	js     802360 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802345:	a1 08 40 80 00       	mov    0x804008,%eax
  80234a:	8b 40 48             	mov    0x48(%eax),%eax
  80234d:	83 ec 08             	sub    $0x8,%esp
  802350:	68 72 23 80 00       	push   $0x802372
  802355:	50                   	push   %eax
  802356:	e8 3b ea ff ff       	call   800d96 <sys_env_set_pgfault_upcall>
  80235b:	83 c4 10             	add    $0x10,%esp
  80235e:	eb bc                	jmp    80231c <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802360:	50                   	push   %eax
  802361:	68 df 2b 80 00       	push   $0x802bdf
  802366:	6a 22                	push   $0x22
  802368:	68 f7 2b 80 00       	push   $0x802bf7
  80236d:	e8 e6 dd ff ff       	call   800158 <_panic>

00802372 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802372:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802373:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802378:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80237a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  80237d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802381:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  802384:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802388:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  80238c:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  80238e:	83 c4 08             	add    $0x8,%esp
	popal
  802391:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802392:	83 c4 04             	add    $0x4,%esp
	popfl
  802395:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802396:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802397:	c3                   	ret    

00802398 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80239e:	89 d0                	mov    %edx,%eax
  8023a0:	c1 e8 16             	shr    $0x16,%eax
  8023a3:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023aa:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023af:	f6 c1 01             	test   $0x1,%cl
  8023b2:	74 1d                	je     8023d1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023b4:	c1 ea 0c             	shr    $0xc,%edx
  8023b7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023be:	f6 c2 01             	test   $0x1,%dl
  8023c1:	74 0e                	je     8023d1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023c3:	c1 ea 0c             	shr    $0xc,%edx
  8023c6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023cd:	ef 
  8023ce:	0f b7 c0             	movzwl %ax,%eax
}
  8023d1:	5d                   	pop    %ebp
  8023d2:	c3                   	ret    
  8023d3:	66 90                	xchg   %ax,%ax
  8023d5:	66 90                	xchg   %ax,%ax
  8023d7:	66 90                	xchg   %ax,%ax
  8023d9:	66 90                	xchg   %ax,%ax
  8023db:	66 90                	xchg   %ax,%ax
  8023dd:	66 90                	xchg   %ax,%ax
  8023df:	90                   	nop

008023e0 <__udivdi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023f7:	85 d2                	test   %edx,%edx
  8023f9:	75 35                	jne    802430 <__udivdi3+0x50>
  8023fb:	39 f3                	cmp    %esi,%ebx
  8023fd:	0f 87 bd 00 00 00    	ja     8024c0 <__udivdi3+0xe0>
  802403:	85 db                	test   %ebx,%ebx
  802405:	89 d9                	mov    %ebx,%ecx
  802407:	75 0b                	jne    802414 <__udivdi3+0x34>
  802409:	b8 01 00 00 00       	mov    $0x1,%eax
  80240e:	31 d2                	xor    %edx,%edx
  802410:	f7 f3                	div    %ebx
  802412:	89 c1                	mov    %eax,%ecx
  802414:	31 d2                	xor    %edx,%edx
  802416:	89 f0                	mov    %esi,%eax
  802418:	f7 f1                	div    %ecx
  80241a:	89 c6                	mov    %eax,%esi
  80241c:	89 e8                	mov    %ebp,%eax
  80241e:	89 f7                	mov    %esi,%edi
  802420:	f7 f1                	div    %ecx
  802422:	89 fa                	mov    %edi,%edx
  802424:	83 c4 1c             	add    $0x1c,%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5f                   	pop    %edi
  80242a:	5d                   	pop    %ebp
  80242b:	c3                   	ret    
  80242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802430:	39 f2                	cmp    %esi,%edx
  802432:	77 7c                	ja     8024b0 <__udivdi3+0xd0>
  802434:	0f bd fa             	bsr    %edx,%edi
  802437:	83 f7 1f             	xor    $0x1f,%edi
  80243a:	0f 84 98 00 00 00    	je     8024d8 <__udivdi3+0xf8>
  802440:	89 f9                	mov    %edi,%ecx
  802442:	b8 20 00 00 00       	mov    $0x20,%eax
  802447:	29 f8                	sub    %edi,%eax
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	89 da                	mov    %ebx,%edx
  802453:	d3 ea                	shr    %cl,%edx
  802455:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802459:	09 d1                	or     %edx,%ecx
  80245b:	89 f2                	mov    %esi,%edx
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e3                	shl    %cl,%ebx
  802465:	89 c1                	mov    %eax,%ecx
  802467:	d3 ea                	shr    %cl,%edx
  802469:	89 f9                	mov    %edi,%ecx
  80246b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80246f:	d3 e6                	shl    %cl,%esi
  802471:	89 eb                	mov    %ebp,%ebx
  802473:	89 c1                	mov    %eax,%ecx
  802475:	d3 eb                	shr    %cl,%ebx
  802477:	09 de                	or     %ebx,%esi
  802479:	89 f0                	mov    %esi,%eax
  80247b:	f7 74 24 08          	divl   0x8(%esp)
  80247f:	89 d6                	mov    %edx,%esi
  802481:	89 c3                	mov    %eax,%ebx
  802483:	f7 64 24 0c          	mull   0xc(%esp)
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 0c                	jb     802497 <__udivdi3+0xb7>
  80248b:	89 f9                	mov    %edi,%ecx
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	39 c5                	cmp    %eax,%ebp
  802491:	73 5d                	jae    8024f0 <__udivdi3+0x110>
  802493:	39 d6                	cmp    %edx,%esi
  802495:	75 59                	jne    8024f0 <__udivdi3+0x110>
  802497:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80249a:	31 ff                	xor    %edi,%edi
  80249c:	89 fa                	mov    %edi,%edx
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d 76 00             	lea    0x0(%esi),%esi
  8024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8024b0:	31 ff                	xor    %edi,%edi
  8024b2:	31 c0                	xor    %eax,%eax
  8024b4:	89 fa                	mov    %edi,%edx
  8024b6:	83 c4 1c             	add    $0x1c,%esp
  8024b9:	5b                   	pop    %ebx
  8024ba:	5e                   	pop    %esi
  8024bb:	5f                   	pop    %edi
  8024bc:	5d                   	pop    %ebp
  8024bd:	c3                   	ret    
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	31 ff                	xor    %edi,%edi
  8024c2:	89 e8                	mov    %ebp,%eax
  8024c4:	89 f2                	mov    %esi,%edx
  8024c6:	f7 f3                	div    %ebx
  8024c8:	89 fa                	mov    %edi,%edx
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	39 f2                	cmp    %esi,%edx
  8024da:	72 06                	jb     8024e2 <__udivdi3+0x102>
  8024dc:	31 c0                	xor    %eax,%eax
  8024de:	39 eb                	cmp    %ebp,%ebx
  8024e0:	77 d2                	ja     8024b4 <__udivdi3+0xd4>
  8024e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e7:	eb cb                	jmp    8024b4 <__udivdi3+0xd4>
  8024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f0:	89 d8                	mov    %ebx,%eax
  8024f2:	31 ff                	xor    %edi,%edi
  8024f4:	eb be                	jmp    8024b4 <__udivdi3+0xd4>
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80250b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80250f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802517:	85 ed                	test   %ebp,%ebp
  802519:	89 f0                	mov    %esi,%eax
  80251b:	89 da                	mov    %ebx,%edx
  80251d:	75 19                	jne    802538 <__umoddi3+0x38>
  80251f:	39 df                	cmp    %ebx,%edi
  802521:	0f 86 b1 00 00 00    	jbe    8025d8 <__umoddi3+0xd8>
  802527:	f7 f7                	div    %edi
  802529:	89 d0                	mov    %edx,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	39 dd                	cmp    %ebx,%ebp
  80253a:	77 f1                	ja     80252d <__umoddi3+0x2d>
  80253c:	0f bd cd             	bsr    %ebp,%ecx
  80253f:	83 f1 1f             	xor    $0x1f,%ecx
  802542:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802546:	0f 84 b4 00 00 00    	je     802600 <__umoddi3+0x100>
  80254c:	b8 20 00 00 00       	mov    $0x20,%eax
  802551:	89 c2                	mov    %eax,%edx
  802553:	8b 44 24 04          	mov    0x4(%esp),%eax
  802557:	29 c2                	sub    %eax,%edx
  802559:	89 c1                	mov    %eax,%ecx
  80255b:	89 f8                	mov    %edi,%eax
  80255d:	d3 e5                	shl    %cl,%ebp
  80255f:	89 d1                	mov    %edx,%ecx
  802561:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802565:	d3 e8                	shr    %cl,%eax
  802567:	09 c5                	or     %eax,%ebp
  802569:	8b 44 24 04          	mov    0x4(%esp),%eax
  80256d:	89 c1                	mov    %eax,%ecx
  80256f:	d3 e7                	shl    %cl,%edi
  802571:	89 d1                	mov    %edx,%ecx
  802573:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802577:	89 df                	mov    %ebx,%edi
  802579:	d3 ef                	shr    %cl,%edi
  80257b:	89 c1                	mov    %eax,%ecx
  80257d:	89 f0                	mov    %esi,%eax
  80257f:	d3 e3                	shl    %cl,%ebx
  802581:	89 d1                	mov    %edx,%ecx
  802583:	89 fa                	mov    %edi,%edx
  802585:	d3 e8                	shr    %cl,%eax
  802587:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258c:	09 d8                	or     %ebx,%eax
  80258e:	f7 f5                	div    %ebp
  802590:	d3 e6                	shl    %cl,%esi
  802592:	89 d1                	mov    %edx,%ecx
  802594:	f7 64 24 08          	mull   0x8(%esp)
  802598:	39 d1                	cmp    %edx,%ecx
  80259a:	89 c3                	mov    %eax,%ebx
  80259c:	89 d7                	mov    %edx,%edi
  80259e:	72 06                	jb     8025a6 <__umoddi3+0xa6>
  8025a0:	75 0e                	jne    8025b0 <__umoddi3+0xb0>
  8025a2:	39 c6                	cmp    %eax,%esi
  8025a4:	73 0a                	jae    8025b0 <__umoddi3+0xb0>
  8025a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8025aa:	19 ea                	sbb    %ebp,%edx
  8025ac:	89 d7                	mov    %edx,%edi
  8025ae:	89 c3                	mov    %eax,%ebx
  8025b0:	89 ca                	mov    %ecx,%edx
  8025b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8025b7:	29 de                	sub    %ebx,%esi
  8025b9:	19 fa                	sbb    %edi,%edx
  8025bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8025bf:	89 d0                	mov    %edx,%eax
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 d9                	mov    %ebx,%ecx
  8025c5:	d3 ee                	shr    %cl,%esi
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	09 f0                	or     %esi,%eax
  8025cb:	83 c4 1c             	add    $0x1c,%esp
  8025ce:	5b                   	pop    %ebx
  8025cf:	5e                   	pop    %esi
  8025d0:	5f                   	pop    %edi
  8025d1:	5d                   	pop    %ebp
  8025d2:	c3                   	ret    
  8025d3:	90                   	nop
  8025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	85 ff                	test   %edi,%edi
  8025da:	89 f9                	mov    %edi,%ecx
  8025dc:	75 0b                	jne    8025e9 <__umoddi3+0xe9>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	f7 f7                	div    %edi
  8025e7:	89 c1                	mov    %eax,%ecx
  8025e9:	89 d8                	mov    %ebx,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f1                	div    %ecx
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	f7 f1                	div    %ecx
  8025f3:	e9 31 ff ff ff       	jmp    802529 <__umoddi3+0x29>
  8025f8:	90                   	nop
  8025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802600:	39 dd                	cmp    %ebx,%ebp
  802602:	72 08                	jb     80260c <__umoddi3+0x10c>
  802604:	39 f7                	cmp    %esi,%edi
  802606:	0f 87 21 ff ff ff    	ja     80252d <__umoddi3+0x2d>
  80260c:	89 da                	mov    %ebx,%edx
  80260e:	89 f0                	mov    %esi,%eax
  802610:	29 f8                	sub    %edi,%eax
  802612:	19 ea                	sbb    %ebp,%edx
  802614:	e9 14 ff ff ff       	jmp    80252d <__umoddi3+0x2d>

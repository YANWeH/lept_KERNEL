
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fe 00 00 00       	call   80012f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 2b 11 00 00       	call   801179 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 e0 11 00 00       	call   801247 <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 40 24 80 00       	push   $0x802440
  80007a:	6a 0d                	push   $0xd
  80007c:	68 5b 24 80 00       	push   $0x80245b
  800081:	e8 09 01 00 00       	call   80018f <_panic>
	if (n < 0)
  800086:	85 c0                	test   %eax,%eax
  800088:	78 07                	js     800091 <cat+0x5e>
		panic("error reading %s: %e", s, n);
}
  80008a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	50                   	push   %eax
  800095:	ff 75 0c             	pushl  0xc(%ebp)
  800098:	68 66 24 80 00       	push   $0x802466
  80009d:	6a 0f                	push   $0xf
  80009f:	68 5b 24 80 00       	push   $0x80245b
  8000a4:	e8 e6 00 00 00       	call   80018f <_panic>

008000a9 <umain>:

void
umain(int argc, char **argv)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b5:	c7 05 00 30 80 00 7b 	movl   $0x80247b,0x803000
  8000bc:	24 80 00 
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8000bf:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c8:	75 31                	jne    8000fb <umain+0x52>
		cat(0, "<stdin>");
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	68 7f 24 80 00       	push   $0x80247f
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 5a ff ff ff       	call   800033 <cat>
  8000d9:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	50                   	push   %eax
  8000e8:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000eb:	68 87 24 80 00       	push   $0x802487
  8000f0:	e8 8d 16 00 00       	call   801782 <printf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f8:	83 c3 01             	add    $0x1,%ebx
  8000fb:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fe:	7d dc                	jge    8000dc <umain+0x33>
			f = open(argv[i], O_RDONLY);
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	6a 00                	push   $0x0
  800105:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800108:	e8 d1 14 00 00       	call   8015de <open>
  80010d:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	85 c0                	test   %eax,%eax
  800114:	78 ce                	js     8000e4 <umain+0x3b>
				cat(f, argv[i]);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011c:	50                   	push   %eax
  80011d:	e8 11 ff ff ff       	call   800033 <cat>
				close(f);
  800122:	89 34 24             	mov    %esi,(%esp)
  800125:	e8 13 0f 00 00       	call   80103d <close>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	eb c9                	jmp    8000f8 <umain+0x4f>

0080012f <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
  800134:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800137:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013a:	e8 05 0b 00 00       	call   800c44 <sys_getenvid>
  80013f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800144:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800151:	85 db                	test   %ebx,%ebx
  800153:	7e 07                	jle    80015c <libmain+0x2d>
		binaryname = argv[0];
  800155:	8b 06                	mov    (%esi),%eax
  800157:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015c:	83 ec 08             	sub    $0x8,%esp
  80015f:	56                   	push   %esi
  800160:	53                   	push   %ebx
  800161:	e8 43 ff ff ff       	call   8000a9 <umain>

	// exit gracefully
	exit();
  800166:	e8 0a 00 00 00       	call   800175 <exit>
}
  80016b:	83 c4 10             	add    $0x10,%esp
  80016e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800171:	5b                   	pop    %ebx
  800172:	5e                   	pop    %esi
  800173:	5d                   	pop    %ebp
  800174:	c3                   	ret    

00800175 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80017b:	e8 e8 0e 00 00       	call   801068 <close_all>
	sys_env_destroy(0);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	6a 00                	push   $0x0
  800185:	e8 79 0a 00 00       	call   800c03 <sys_env_destroy>
}
  80018a:	83 c4 10             	add    $0x10,%esp
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800197:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80019d:	e8 a2 0a 00 00       	call   800c44 <sys_getenvid>
  8001a2:	83 ec 0c             	sub    $0xc,%esp
  8001a5:	ff 75 0c             	pushl  0xc(%ebp)
  8001a8:	ff 75 08             	pushl  0x8(%ebp)
  8001ab:	56                   	push   %esi
  8001ac:	50                   	push   %eax
  8001ad:	68 a4 24 80 00       	push   $0x8024a4
  8001b2:	e8 b3 00 00 00       	call   80026a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b7:	83 c4 18             	add    $0x18,%esp
  8001ba:	53                   	push   %ebx
  8001bb:	ff 75 10             	pushl  0x10(%ebp)
  8001be:	e8 56 00 00 00       	call   800219 <vcprintf>
	cprintf("\n");
  8001c3:	c7 04 24 04 29 80 00 	movl   $0x802904,(%esp)
  8001ca:	e8 9b 00 00 00       	call   80026a <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d2:	cc                   	int3   
  8001d3:	eb fd                	jmp    8001d2 <_panic+0x43>

008001d5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001df:	8b 13                	mov    (%ebx),%edx
  8001e1:	8d 42 01             	lea    0x1(%edx),%eax
  8001e4:	89 03                	mov    %eax,(%ebx)
  8001e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f2:	74 09                	je     8001fd <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	68 ff 00 00 00       	push   $0xff
  800205:	8d 43 08             	lea    0x8(%ebx),%eax
  800208:	50                   	push   %eax
  800209:	e8 b8 09 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  80020e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800214:	83 c4 10             	add    $0x10,%esp
  800217:	eb db                	jmp    8001f4 <putch+0x1f>

00800219 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800222:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800229:	00 00 00 
	b.cnt = 0;
  80022c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800233:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800236:	ff 75 0c             	pushl  0xc(%ebp)
  800239:	ff 75 08             	pushl  0x8(%ebp)
  80023c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800242:	50                   	push   %eax
  800243:	68 d5 01 80 00       	push   $0x8001d5
  800248:	e8 1a 01 00 00       	call   800367 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024d:	83 c4 08             	add    $0x8,%esp
  800250:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800256:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 64 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800270:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800273:	50                   	push   %eax
  800274:	ff 75 08             	pushl  0x8(%ebp)
  800277:	e8 9d ff ff ff       	call   800219 <vcprintf>
	va_end(ap);

	return cnt;
}
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	83 ec 1c             	sub    $0x1c,%esp
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 d6                	mov    %edx,%esi
  80028b:	8b 45 08             	mov    0x8(%ebp),%eax
  80028e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800294:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80029f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002a5:	39 d3                	cmp    %edx,%ebx
  8002a7:	72 05                	jb     8002ae <printnum+0x30>
  8002a9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002ac:	77 7a                	ja     800328 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 18             	pushl  0x18(%ebp)
  8002b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002b7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ba:	53                   	push   %ebx
  8002bb:	ff 75 10             	pushl  0x10(%ebp)
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ca:	ff 75 d8             	pushl  -0x28(%ebp)
  8002cd:	e8 2e 1f 00 00       	call   802200 <__udivdi3>
  8002d2:	83 c4 18             	add    $0x18,%esp
  8002d5:	52                   	push   %edx
  8002d6:	50                   	push   %eax
  8002d7:	89 f2                	mov    %esi,%edx
  8002d9:	89 f8                	mov    %edi,%eax
  8002db:	e8 9e ff ff ff       	call   80027e <printnum>
  8002e0:	83 c4 20             	add    $0x20,%esp
  8002e3:	eb 13                	jmp    8002f8 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e5:	83 ec 08             	sub    $0x8,%esp
  8002e8:	56                   	push   %esi
  8002e9:	ff 75 18             	pushl  0x18(%ebp)
  8002ec:	ff d7                	call   *%edi
  8002ee:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f1:	83 eb 01             	sub    $0x1,%ebx
  8002f4:	85 db                	test   %ebx,%ebx
  8002f6:	7f ed                	jg     8002e5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	56                   	push   %esi
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800302:	ff 75 e0             	pushl  -0x20(%ebp)
  800305:	ff 75 dc             	pushl  -0x24(%ebp)
  800308:	ff 75 d8             	pushl  -0x28(%ebp)
  80030b:	e8 10 20 00 00       	call   802320 <__umoddi3>
  800310:	83 c4 14             	add    $0x14,%esp
  800313:	0f be 80 c7 24 80 00 	movsbl 0x8024c7(%eax),%eax
  80031a:	50                   	push   %eax
  80031b:	ff d7                	call   *%edi
}
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    
  800328:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80032b:	eb c4                	jmp    8002f1 <printnum+0x73>

0080032d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800333:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800337:	8b 10                	mov    (%eax),%edx
  800339:	3b 50 04             	cmp    0x4(%eax),%edx
  80033c:	73 0a                	jae    800348 <sprintputch+0x1b>
		*b->buf++ = ch;
  80033e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800341:	89 08                	mov    %ecx,(%eax)
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	88 02                	mov    %al,(%edx)
}
  800348:	5d                   	pop    %ebp
  800349:	c3                   	ret    

0080034a <printfmt>:
{
  80034a:	55                   	push   %ebp
  80034b:	89 e5                	mov    %esp,%ebp
  80034d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800350:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800353:	50                   	push   %eax
  800354:	ff 75 10             	pushl  0x10(%ebp)
  800357:	ff 75 0c             	pushl  0xc(%ebp)
  80035a:	ff 75 08             	pushl  0x8(%ebp)
  80035d:	e8 05 00 00 00       	call   800367 <vprintfmt>
}
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	c9                   	leave  
  800366:	c3                   	ret    

00800367 <vprintfmt>:
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
  80036d:	83 ec 2c             	sub    $0x2c,%esp
  800370:	8b 75 08             	mov    0x8(%ebp),%esi
  800373:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800376:	8b 7d 10             	mov    0x10(%ebp),%edi
  800379:	e9 c1 03 00 00       	jmp    80073f <vprintfmt+0x3d8>
		padc = ' ';
  80037e:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800382:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800389:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800390:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800397:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8d 47 01             	lea    0x1(%edi),%eax
  80039f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a2:	0f b6 17             	movzbl (%edi),%edx
  8003a5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003a8:	3c 55                	cmp    $0x55,%al
  8003aa:	0f 87 12 04 00 00    	ja     8007c2 <vprintfmt+0x45b>
  8003b0:	0f b6 c0             	movzbl %al,%eax
  8003b3:	ff 24 85 00 26 80 00 	jmp    *0x802600(,%eax,4)
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003bd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c1:	eb d9                	jmp    80039c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003c6:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ca:	eb d0                	jmp    80039c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	0f b6 d2             	movzbl %dl,%edx
  8003cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003da:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003dd:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e1:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e4:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003e7:	83 f9 09             	cmp    $0x9,%ecx
  8003ea:	77 55                	ja     800441 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003ec:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003ef:	eb e9                	jmp    8003da <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fc:	8d 40 04             	lea    0x4(%eax),%eax
  8003ff:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800405:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800409:	79 91                	jns    80039c <vprintfmt+0x35>
				width = precision, precision = -1;
  80040b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800411:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800418:	eb 82                	jmp    80039c <vprintfmt+0x35>
  80041a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041d:	85 c0                	test   %eax,%eax
  80041f:	ba 00 00 00 00       	mov    $0x0,%edx
  800424:	0f 49 d0             	cmovns %eax,%edx
  800427:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80042d:	e9 6a ff ff ff       	jmp    80039c <vprintfmt+0x35>
  800432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800435:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80043c:	e9 5b ff ff ff       	jmp    80039c <vprintfmt+0x35>
  800441:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800444:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800447:	eb bc                	jmp    800405 <vprintfmt+0x9e>
			lflag++;
  800449:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80044c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80044f:	e9 48 ff ff ff       	jmp    80039c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 78 04             	lea    0x4(%eax),%edi
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	ff 30                	pushl  (%eax)
  800460:	ff d6                	call   *%esi
			break;
  800462:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800465:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800468:	e9 cf 02 00 00       	jmp    80073c <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80046d:	8b 45 14             	mov    0x14(%ebp),%eax
  800470:	8d 78 04             	lea    0x4(%eax),%edi
  800473:	8b 00                	mov    (%eax),%eax
  800475:	99                   	cltd   
  800476:	31 d0                	xor    %edx,%eax
  800478:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047a:	83 f8 0f             	cmp    $0xf,%eax
  80047d:	7f 23                	jg     8004a2 <vprintfmt+0x13b>
  80047f:	8b 14 85 60 27 80 00 	mov    0x802760(,%eax,4),%edx
  800486:	85 d2                	test   %edx,%edx
  800488:	74 18                	je     8004a2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80048a:	52                   	push   %edx
  80048b:	68 99 28 80 00       	push   $0x802899
  800490:	53                   	push   %ebx
  800491:	56                   	push   %esi
  800492:	e8 b3 fe ff ff       	call   80034a <printfmt>
  800497:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80049d:	e9 9a 02 00 00       	jmp    80073c <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8004a2:	50                   	push   %eax
  8004a3:	68 df 24 80 00       	push   $0x8024df
  8004a8:	53                   	push   %ebx
  8004a9:	56                   	push   %esi
  8004aa:	e8 9b fe ff ff       	call   80034a <printfmt>
  8004af:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004b5:	e9 82 02 00 00       	jmp    80073c <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	83 c0 04             	add    $0x4,%eax
  8004c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004c8:	85 ff                	test   %edi,%edi
  8004ca:	b8 d8 24 80 00       	mov    $0x8024d8,%eax
  8004cf:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d6:	0f 8e bd 00 00 00    	jle    800599 <vprintfmt+0x232>
  8004dc:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004e0:	75 0e                	jne    8004f0 <vprintfmt+0x189>
  8004e2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004e8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004eb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ee:	eb 6d                	jmp    80055d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f0:	83 ec 08             	sub    $0x8,%esp
  8004f3:	ff 75 d0             	pushl  -0x30(%ebp)
  8004f6:	57                   	push   %edi
  8004f7:	e8 6e 03 00 00       	call   80086a <strnlen>
  8004fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ff:	29 c1                	sub    %eax,%ecx
  800501:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800507:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800511:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	eb 0f                	jmp    800524 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	ff 75 e0             	pushl  -0x20(%ebp)
  80051c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80051e:	83 ef 01             	sub    $0x1,%edi
  800521:	83 c4 10             	add    $0x10,%esp
  800524:	85 ff                	test   %edi,%edi
  800526:	7f ed                	jg     800515 <vprintfmt+0x1ae>
  800528:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80052b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c1             	cmovns %ecx,%eax
  800538:	29 c1                	sub    %eax,%ecx
  80053a:	89 75 08             	mov    %esi,0x8(%ebp)
  80053d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800540:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800543:	89 cb                	mov    %ecx,%ebx
  800545:	eb 16                	jmp    80055d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800547:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80054b:	75 31                	jne    80057e <vprintfmt+0x217>
					putch(ch, putdat);
  80054d:	83 ec 08             	sub    $0x8,%esp
  800550:	ff 75 0c             	pushl  0xc(%ebp)
  800553:	50                   	push   %eax
  800554:	ff 55 08             	call   *0x8(%ebp)
  800557:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055a:	83 eb 01             	sub    $0x1,%ebx
  80055d:	83 c7 01             	add    $0x1,%edi
  800560:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800564:	0f be c2             	movsbl %dl,%eax
  800567:	85 c0                	test   %eax,%eax
  800569:	74 59                	je     8005c4 <vprintfmt+0x25d>
  80056b:	85 f6                	test   %esi,%esi
  80056d:	78 d8                	js     800547 <vprintfmt+0x1e0>
  80056f:	83 ee 01             	sub    $0x1,%esi
  800572:	79 d3                	jns    800547 <vprintfmt+0x1e0>
  800574:	89 df                	mov    %ebx,%edi
  800576:	8b 75 08             	mov    0x8(%ebp),%esi
  800579:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80057c:	eb 37                	jmp    8005b5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80057e:	0f be d2             	movsbl %dl,%edx
  800581:	83 ea 20             	sub    $0x20,%edx
  800584:	83 fa 5e             	cmp    $0x5e,%edx
  800587:	76 c4                	jbe    80054d <vprintfmt+0x1e6>
					putch('?', putdat);
  800589:	83 ec 08             	sub    $0x8,%esp
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	6a 3f                	push   $0x3f
  800591:	ff 55 08             	call   *0x8(%ebp)
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	eb c1                	jmp    80055a <vprintfmt+0x1f3>
  800599:	89 75 08             	mov    %esi,0x8(%ebp)
  80059c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80059f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005a5:	eb b6                	jmp    80055d <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 20                	push   $0x20
  8005ad:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005af:	83 ef 01             	sub    $0x1,%edi
  8005b2:	83 c4 10             	add    $0x10,%esp
  8005b5:	85 ff                	test   %edi,%edi
  8005b7:	7f ee                	jg     8005a7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005b9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	e9 78 01 00 00       	jmp    80073c <vprintfmt+0x3d5>
  8005c4:	89 df                	mov    %ebx,%edi
  8005c6:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005cc:	eb e7                	jmp    8005b5 <vprintfmt+0x24e>
	if (lflag >= 2)
  8005ce:	83 f9 01             	cmp    $0x1,%ecx
  8005d1:	7e 3f                	jle    800612 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8b 50 04             	mov    0x4(%eax),%edx
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005ee:	79 5c                	jns    80064c <vprintfmt+0x2e5>
				putch('-', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2d                	push   $0x2d
  8005f6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005fe:	f7 da                	neg    %edx
  800600:	83 d1 00             	adc    $0x0,%ecx
  800603:	f7 d9                	neg    %ecx
  800605:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800608:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060d:	e9 10 01 00 00       	jmp    800722 <vprintfmt+0x3bb>
	else if (lflag)
  800612:	85 c9                	test   %ecx,%ecx
  800614:	75 1b                	jne    800631 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800616:	8b 45 14             	mov    0x14(%ebp),%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061e:	89 c1                	mov    %eax,%ecx
  800620:	c1 f9 1f             	sar    $0x1f,%ecx
  800623:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	8d 40 04             	lea    0x4(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	eb b9                	jmp    8005ea <vprintfmt+0x283>
		return va_arg(*ap, long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800639:	89 c1                	mov    %eax,%ecx
  80063b:	c1 f9 1f             	sar    $0x1f,%ecx
  80063e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	eb 9e                	jmp    8005ea <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80064c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800652:	b8 0a 00 00 00       	mov    $0xa,%eax
  800657:	e9 c6 00 00 00       	jmp    800722 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80065c:	83 f9 01             	cmp    $0x1,%ecx
  80065f:	7e 18                	jle    800679 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 10                	mov    (%eax),%edx
  800666:	8b 48 04             	mov    0x4(%eax),%ecx
  800669:	8d 40 08             	lea    0x8(%eax),%eax
  80066c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	e9 a9 00 00 00       	jmp    800722 <vprintfmt+0x3bb>
	else if (lflag)
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	75 1a                	jne    800697 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 10                	mov    (%eax),%edx
  800682:	b9 00 00 00 00       	mov    $0x0,%ecx
  800687:	8d 40 04             	lea    0x4(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800692:	e9 8b 00 00 00       	jmp    800722 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 10                	mov    (%eax),%edx
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a1:	8d 40 04             	lea    0x4(%eax),%eax
  8006a4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ac:	eb 74                	jmp    800722 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006ae:	83 f9 01             	cmp    $0x1,%ecx
  8006b1:	7e 15                	jle    8006c8 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 10                	mov    (%eax),%edx
  8006b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bb:	8d 40 08             	lea    0x8(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c6:	eb 5a                	jmp    800722 <vprintfmt+0x3bb>
	else if (lflag)
  8006c8:	85 c9                	test   %ecx,%ecx
  8006ca:	75 17                	jne    8006e3 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
  8006d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e1:	eb 3f                	jmp    800722 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 10                	mov    (%eax),%edx
  8006e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f8:	eb 28                	jmp    800722 <vprintfmt+0x3bb>
			putch('0', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 30                	push   $0x30
  800700:	ff d6                	call   *%esi
			putch('x', putdat);
  800702:	83 c4 08             	add    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 78                	push   $0x78
  800708:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8b 10                	mov    (%eax),%edx
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800714:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800722:	83 ec 0c             	sub    $0xc,%esp
  800725:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800729:	57                   	push   %edi
  80072a:	ff 75 e0             	pushl  -0x20(%ebp)
  80072d:	50                   	push   %eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	89 da                	mov    %ebx,%edx
  800732:	89 f0                	mov    %esi,%eax
  800734:	e8 45 fb ff ff       	call   80027e <printnum>
			break;
  800739:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80073c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	83 c7 01             	add    $0x1,%edi
  800742:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800746:	83 f8 25             	cmp    $0x25,%eax
  800749:	0f 84 2f fc ff ff    	je     80037e <vprintfmt+0x17>
			if (ch == '\0')
  80074f:	85 c0                	test   %eax,%eax
  800751:	0f 84 8b 00 00 00    	je     8007e2 <vprintfmt+0x47b>
			putch(ch, putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	53                   	push   %ebx
  80075b:	50                   	push   %eax
  80075c:	ff d6                	call   *%esi
  80075e:	83 c4 10             	add    $0x10,%esp
  800761:	eb dc                	jmp    80073f <vprintfmt+0x3d8>
	if (lflag >= 2)
  800763:	83 f9 01             	cmp    $0x1,%ecx
  800766:	7e 15                	jle    80077d <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	8b 10                	mov    (%eax),%edx
  80076d:	8b 48 04             	mov    0x4(%eax),%ecx
  800770:	8d 40 08             	lea    0x8(%eax),%eax
  800773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800776:	b8 10 00 00 00       	mov    $0x10,%eax
  80077b:	eb a5                	jmp    800722 <vprintfmt+0x3bb>
	else if (lflag)
  80077d:	85 c9                	test   %ecx,%ecx
  80077f:	75 17                	jne    800798 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	8b 10                	mov    (%eax),%edx
  800786:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078b:	8d 40 04             	lea    0x4(%eax),%eax
  80078e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800791:	b8 10 00 00 00       	mov    $0x10,%eax
  800796:	eb 8a                	jmp    800722 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8b 10                	mov    (%eax),%edx
  80079d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a2:	8d 40 04             	lea    0x4(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ad:	e9 70 ff ff ff       	jmp    800722 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 25                	push   $0x25
  8007b8:	ff d6                	call   *%esi
			break;
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	e9 7a ff ff ff       	jmp    80073c <vprintfmt+0x3d5>
			putch('%', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	6a 25                	push   $0x25
  8007c8:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	89 f8                	mov    %edi,%eax
  8007cf:	eb 03                	jmp    8007d4 <vprintfmt+0x46d>
  8007d1:	83 e8 01             	sub    $0x1,%eax
  8007d4:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007d8:	75 f7                	jne    8007d1 <vprintfmt+0x46a>
  8007da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007dd:	e9 5a ff ff ff       	jmp    80073c <vprintfmt+0x3d5>
}
  8007e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007e5:	5b                   	pop    %ebx
  8007e6:	5e                   	pop    %esi
  8007e7:	5f                   	pop    %edi
  8007e8:	5d                   	pop    %ebp
  8007e9:	c3                   	ret    

008007ea <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 18             	sub    $0x18,%esp
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007fd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800800:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800807:	85 c0                	test   %eax,%eax
  800809:	74 26                	je     800831 <vsnprintf+0x47>
  80080b:	85 d2                	test   %edx,%edx
  80080d:	7e 22                	jle    800831 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80080f:	ff 75 14             	pushl  0x14(%ebp)
  800812:	ff 75 10             	pushl  0x10(%ebp)
  800815:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800818:	50                   	push   %eax
  800819:	68 2d 03 80 00       	push   $0x80032d
  80081e:	e8 44 fb ff ff       	call   800367 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800826:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80082c:	83 c4 10             	add    $0x10,%esp
}
  80082f:	c9                   	leave  
  800830:	c3                   	ret    
		return -E_INVAL;
  800831:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800836:	eb f7                	jmp    80082f <vsnprintf+0x45>

00800838 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800841:	50                   	push   %eax
  800842:	ff 75 10             	pushl  0x10(%ebp)
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 9a ff ff ff       	call   8007ea <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    

00800852 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
  80085d:	eb 03                	jmp    800862 <strlen+0x10>
		n++;
  80085f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800862:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800866:	75 f7                	jne    80085f <strlen+0xd>
	return n;
}
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800870:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800873:	b8 00 00 00 00       	mov    $0x0,%eax
  800878:	eb 03                	jmp    80087d <strnlen+0x13>
		n++;
  80087a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087d:	39 d0                	cmp    %edx,%eax
  80087f:	74 06                	je     800887 <strnlen+0x1d>
  800881:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800885:	75 f3                	jne    80087a <strnlen+0x10>
	return n;
}
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800893:	89 c2                	mov    %eax,%edx
  800895:	83 c1 01             	add    $0x1,%ecx
  800898:	83 c2 01             	add    $0x1,%edx
  80089b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80089f:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a2:	84 db                	test   %bl,%bl
  8008a4:	75 ef                	jne    800895 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a6:	5b                   	pop    %ebx
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	53                   	push   %ebx
  8008ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b0:	53                   	push   %ebx
  8008b1:	e8 9c ff ff ff       	call   800852 <strlen>
  8008b6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	01 d8                	add    %ebx,%eax
  8008be:	50                   	push   %eax
  8008bf:	e8 c5 ff ff ff       	call   800889 <strcpy>
	return dst;
}
  8008c4:	89 d8                	mov    %ebx,%eax
  8008c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	56                   	push   %esi
  8008cf:	53                   	push   %ebx
  8008d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008d6:	89 f3                	mov    %esi,%ebx
  8008d8:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008db:	89 f2                	mov    %esi,%edx
  8008dd:	eb 0f                	jmp    8008ee <strncpy+0x23>
		*dst++ = *src;
  8008df:	83 c2 01             	add    $0x1,%edx
  8008e2:	0f b6 01             	movzbl (%ecx),%eax
  8008e5:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e8:	80 39 01             	cmpb   $0x1,(%ecx)
  8008eb:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008ee:	39 da                	cmp    %ebx,%edx
  8008f0:	75 ed                	jne    8008df <strncpy+0x14>
	}
	return ret;
}
  8008f2:	89 f0                	mov    %esi,%eax
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800900:	8b 55 0c             	mov    0xc(%ebp),%edx
  800903:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800906:	89 f0                	mov    %esi,%eax
  800908:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80090c:	85 c9                	test   %ecx,%ecx
  80090e:	75 0b                	jne    80091b <strlcpy+0x23>
  800910:	eb 17                	jmp    800929 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800912:	83 c2 01             	add    $0x1,%edx
  800915:	83 c0 01             	add    $0x1,%eax
  800918:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80091b:	39 d8                	cmp    %ebx,%eax
  80091d:	74 07                	je     800926 <strlcpy+0x2e>
  80091f:	0f b6 0a             	movzbl (%edx),%ecx
  800922:	84 c9                	test   %cl,%cl
  800924:	75 ec                	jne    800912 <strlcpy+0x1a>
		*dst = '\0';
  800926:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800929:	29 f0                	sub    %esi,%eax
}
  80092b:	5b                   	pop    %ebx
  80092c:	5e                   	pop    %esi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    

0080092f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092f:	55                   	push   %ebp
  800930:	89 e5                	mov    %esp,%ebp
  800932:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800935:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800938:	eb 06                	jmp    800940 <strcmp+0x11>
		p++, q++;
  80093a:	83 c1 01             	add    $0x1,%ecx
  80093d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800940:	0f b6 01             	movzbl (%ecx),%eax
  800943:	84 c0                	test   %al,%al
  800945:	74 04                	je     80094b <strcmp+0x1c>
  800947:	3a 02                	cmp    (%edx),%al
  800949:	74 ef                	je     80093a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80094b:	0f b6 c0             	movzbl %al,%eax
  80094e:	0f b6 12             	movzbl (%edx),%edx
  800951:	29 d0                	sub    %edx,%eax
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095f:	89 c3                	mov    %eax,%ebx
  800961:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800964:	eb 06                	jmp    80096c <strncmp+0x17>
		n--, p++, q++;
  800966:	83 c0 01             	add    $0x1,%eax
  800969:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  80096c:	39 d8                	cmp    %ebx,%eax
  80096e:	74 16                	je     800986 <strncmp+0x31>
  800970:	0f b6 08             	movzbl (%eax),%ecx
  800973:	84 c9                	test   %cl,%cl
  800975:	74 04                	je     80097b <strncmp+0x26>
  800977:	3a 0a                	cmp    (%edx),%cl
  800979:	74 eb                	je     800966 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80097b:	0f b6 00             	movzbl (%eax),%eax
  80097e:	0f b6 12             	movzbl (%edx),%edx
  800981:	29 d0                	sub    %edx,%eax
}
  800983:	5b                   	pop    %ebx
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    
		return 0;
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	eb f6                	jmp    800983 <strncmp+0x2e>

0080098d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800997:	0f b6 10             	movzbl (%eax),%edx
  80099a:	84 d2                	test   %dl,%dl
  80099c:	74 09                	je     8009a7 <strchr+0x1a>
		if (*s == c)
  80099e:	38 ca                	cmp    %cl,%dl
  8009a0:	74 0a                	je     8009ac <strchr+0x1f>
	for (; *s; s++)
  8009a2:	83 c0 01             	add    $0x1,%eax
  8009a5:	eb f0                	jmp    800997 <strchr+0xa>
			return (char *) s;
	return 0;
  8009a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b8:	eb 03                	jmp    8009bd <strfind+0xf>
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009c0:	38 ca                	cmp    %cl,%dl
  8009c2:	74 04                	je     8009c8 <strfind+0x1a>
  8009c4:	84 d2                	test   %dl,%dl
  8009c6:	75 f2                	jne    8009ba <strfind+0xc>
			break;
	return (char *) s;
}
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	57                   	push   %edi
  8009ce:	56                   	push   %esi
  8009cf:	53                   	push   %ebx
  8009d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d6:	85 c9                	test   %ecx,%ecx
  8009d8:	74 13                	je     8009ed <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009da:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e0:	75 05                	jne    8009e7 <memset+0x1d>
  8009e2:	f6 c1 03             	test   $0x3,%cl
  8009e5:	74 0d                	je     8009f4 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	fc                   	cld    
  8009eb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ed:	89 f8                	mov    %edi,%eax
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5f                   	pop    %edi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    
		c &= 0xFF;
  8009f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f8:	89 d3                	mov    %edx,%ebx
  8009fa:	c1 e3 08             	shl    $0x8,%ebx
  8009fd:	89 d0                	mov    %edx,%eax
  8009ff:	c1 e0 18             	shl    $0x18,%eax
  800a02:	89 d6                	mov    %edx,%esi
  800a04:	c1 e6 10             	shl    $0x10,%esi
  800a07:	09 f0                	or     %esi,%eax
  800a09:	09 c2                	or     %eax,%edx
  800a0b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a0d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a10:	89 d0                	mov    %edx,%eax
  800a12:	fc                   	cld    
  800a13:	f3 ab                	rep stos %eax,%es:(%edi)
  800a15:	eb d6                	jmp    8009ed <memset+0x23>

00800a17 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a22:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a25:	39 c6                	cmp    %eax,%esi
  800a27:	73 35                	jae    800a5e <memmove+0x47>
  800a29:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a2c:	39 c2                	cmp    %eax,%edx
  800a2e:	76 2e                	jbe    800a5e <memmove+0x47>
		s += n;
		d += n;
  800a30:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a33:	89 d6                	mov    %edx,%esi
  800a35:	09 fe                	or     %edi,%esi
  800a37:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3d:	74 0c                	je     800a4b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 21                	jmp    800a6c <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4b:	f6 c1 03             	test   $0x3,%cl
  800a4e:	75 ef                	jne    800a3f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a50:	83 ef 04             	sub    $0x4,%edi
  800a53:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a56:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a59:	fd                   	std    
  800a5a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5c:	eb ea                	jmp    800a48 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5e:	89 f2                	mov    %esi,%edx
  800a60:	09 c2                	or     %eax,%edx
  800a62:	f6 c2 03             	test   $0x3,%dl
  800a65:	74 09                	je     800a70 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a67:	89 c7                	mov    %eax,%edi
  800a69:	fc                   	cld    
  800a6a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a6c:	5e                   	pop    %esi
  800a6d:	5f                   	pop    %edi
  800a6e:	5d                   	pop    %ebp
  800a6f:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a70:	f6 c1 03             	test   $0x3,%cl
  800a73:	75 f2                	jne    800a67 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a75:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a78:	89 c7                	mov    %eax,%edi
  800a7a:	fc                   	cld    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb ed                	jmp    800a6c <memmove+0x55>

00800a7f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a82:	ff 75 10             	pushl  0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 87 ff ff ff       	call   800a17 <memmove>
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9d:	89 c6                	mov    %eax,%esi
  800a9f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa2:	39 f0                	cmp    %esi,%eax
  800aa4:	74 1c                	je     800ac2 <memcmp+0x30>
		if (*s1 != *s2)
  800aa6:	0f b6 08             	movzbl (%eax),%ecx
  800aa9:	0f b6 1a             	movzbl (%edx),%ebx
  800aac:	38 d9                	cmp    %bl,%cl
  800aae:	75 08                	jne    800ab8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ab0:	83 c0 01             	add    $0x1,%eax
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	eb ea                	jmp    800aa2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ab8:	0f b6 c1             	movzbl %cl,%eax
  800abb:	0f b6 db             	movzbl %bl,%ebx
  800abe:	29 d8                	sub    %ebx,%eax
  800ac0:	eb 05                	jmp    800ac7 <memcmp+0x35>
	}

	return 0;
  800ac2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac7:	5b                   	pop    %ebx
  800ac8:	5e                   	pop    %esi
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad4:	89 c2                	mov    %eax,%edx
  800ad6:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad9:	39 d0                	cmp    %edx,%eax
  800adb:	73 09                	jae    800ae6 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800add:	38 08                	cmp    %cl,(%eax)
  800adf:	74 05                	je     800ae6 <memfind+0x1b>
	for (; s < ends; s++)
  800ae1:	83 c0 01             	add    $0x1,%eax
  800ae4:	eb f3                	jmp    800ad9 <memfind+0xe>
			break;
	return (void *) s;
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af4:	eb 03                	jmp    800af9 <strtol+0x11>
		s++;
  800af6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	3c 20                	cmp    $0x20,%al
  800afe:	74 f6                	je     800af6 <strtol+0xe>
  800b00:	3c 09                	cmp    $0x9,%al
  800b02:	74 f2                	je     800af6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b04:	3c 2b                	cmp    $0x2b,%al
  800b06:	74 2e                	je     800b36 <strtol+0x4e>
	int neg = 0;
  800b08:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b0d:	3c 2d                	cmp    $0x2d,%al
  800b0f:	74 2f                	je     800b40 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b11:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b17:	75 05                	jne    800b1e <strtol+0x36>
  800b19:	80 39 30             	cmpb   $0x30,(%ecx)
  800b1c:	74 2c                	je     800b4a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b1e:	85 db                	test   %ebx,%ebx
  800b20:	75 0a                	jne    800b2c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b22:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b27:	80 39 30             	cmpb   $0x30,(%ecx)
  800b2a:	74 28                	je     800b54 <strtol+0x6c>
		base = 10;
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b34:	eb 50                	jmp    800b86 <strtol+0x9e>
		s++;
  800b36:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb d1                	jmp    800b11 <strtol+0x29>
		s++, neg = 1;
  800b40:	83 c1 01             	add    $0x1,%ecx
  800b43:	bf 01 00 00 00       	mov    $0x1,%edi
  800b48:	eb c7                	jmp    800b11 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b4e:	74 0e                	je     800b5e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b50:	85 db                	test   %ebx,%ebx
  800b52:	75 d8                	jne    800b2c <strtol+0x44>
		s++, base = 8;
  800b54:	83 c1 01             	add    $0x1,%ecx
  800b57:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b5c:	eb ce                	jmp    800b2c <strtol+0x44>
		s += 2, base = 16;
  800b5e:	83 c1 02             	add    $0x2,%ecx
  800b61:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b66:	eb c4                	jmp    800b2c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b6b:	89 f3                	mov    %esi,%ebx
  800b6d:	80 fb 19             	cmp    $0x19,%bl
  800b70:	77 29                	ja     800b9b <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b72:	0f be d2             	movsbl %dl,%edx
  800b75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b7b:	7d 30                	jge    800bad <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b86:	0f b6 11             	movzbl (%ecx),%edx
  800b89:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b8c:	89 f3                	mov    %esi,%ebx
  800b8e:	80 fb 09             	cmp    $0x9,%bl
  800b91:	77 d5                	ja     800b68 <strtol+0x80>
			dig = *s - '0';
  800b93:	0f be d2             	movsbl %dl,%edx
  800b96:	83 ea 30             	sub    $0x30,%edx
  800b99:	eb dd                	jmp    800b78 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b9b:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b9e:	89 f3                	mov    %esi,%ebx
  800ba0:	80 fb 19             	cmp    $0x19,%bl
  800ba3:	77 08                	ja     800bad <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ba5:	0f be d2             	movsbl %dl,%edx
  800ba8:	83 ea 37             	sub    $0x37,%edx
  800bab:	eb cb                	jmp    800b78 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 05                	je     800bb8 <strtol+0xd0>
		*endptr = (char *) s;
  800bb3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bb8:	89 c2                	mov    %eax,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 45 c2             	cmovne %edx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	b8 03 00 00 00       	mov    $0x3,%eax
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7f 08                	jg     800c2d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2d:	83 ec 0c             	sub    $0xc,%esp
  800c30:	50                   	push   %eax
  800c31:	6a 03                	push   $0x3
  800c33:	68 bf 27 80 00       	push   $0x8027bf
  800c38:	6a 23                	push   $0x23
  800c3a:	68 dc 27 80 00       	push   $0x8027dc
  800c3f:	e8 4b f5 ff ff       	call   80018f <_panic>

00800c44 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 02 00 00 00       	mov    $0x2,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_yield>:

void
sys_yield(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c73:	89 d1                	mov    %edx,%ecx
  800c75:	89 d3                	mov    %edx,%ebx
  800c77:	89 d7                	mov    %edx,%edi
  800c79:	89 d6                	mov    %edx,%esi
  800c7b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7d:	5b                   	pop    %ebx
  800c7e:	5e                   	pop    %esi
  800c7f:	5f                   	pop    %edi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8b:	be 00 00 00 00       	mov    $0x0,%esi
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9e:	89 f7                	mov    %esi,%edi
  800ca0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	7f 08                	jg     800cae <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cae:	83 ec 0c             	sub    $0xc,%esp
  800cb1:	50                   	push   %eax
  800cb2:	6a 04                	push   $0x4
  800cb4:	68 bf 27 80 00       	push   $0x8027bf
  800cb9:	6a 23                	push   $0x23
  800cbb:	68 dc 27 80 00       	push   $0x8027dc
  800cc0:	e8 ca f4 ff ff       	call   80018f <_panic>

00800cc5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
  800ccb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cdf:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce4:	85 c0                	test   %eax,%eax
  800ce6:	7f 08                	jg     800cf0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf0:	83 ec 0c             	sub    $0xc,%esp
  800cf3:	50                   	push   %eax
  800cf4:	6a 05                	push   $0x5
  800cf6:	68 bf 27 80 00       	push   $0x8027bf
  800cfb:	6a 23                	push   $0x23
  800cfd:	68 dc 27 80 00       	push   $0x8027dc
  800d02:	e8 88 f4 ff ff       	call   80018f <_panic>

00800d07 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1b:	b8 06 00 00 00       	mov    $0x6,%eax
  800d20:	89 df                	mov    %ebx,%edi
  800d22:	89 de                	mov    %ebx,%esi
  800d24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7f 08                	jg     800d32 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2d:	5b                   	pop    %ebx
  800d2e:	5e                   	pop    %esi
  800d2f:	5f                   	pop    %edi
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d32:	83 ec 0c             	sub    $0xc,%esp
  800d35:	50                   	push   %eax
  800d36:	6a 06                	push   $0x6
  800d38:	68 bf 27 80 00       	push   $0x8027bf
  800d3d:	6a 23                	push   $0x23
  800d3f:	68 dc 27 80 00       	push   $0x8027dc
  800d44:	e8 46 f4 ff ff       	call   80018f <_panic>

00800d49 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d52:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d57:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5d:	b8 08 00 00 00       	mov    $0x8,%eax
  800d62:	89 df                	mov    %ebx,%edi
  800d64:	89 de                	mov    %ebx,%esi
  800d66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d68:	85 c0                	test   %eax,%eax
  800d6a:	7f 08                	jg     800d74 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 08                	push   $0x8
  800d7a:	68 bf 27 80 00       	push   $0x8027bf
  800d7f:	6a 23                	push   $0x23
  800d81:	68 dc 27 80 00       	push   $0x8027dc
  800d86:	e8 04 f4 ff ff       	call   80018f <_panic>

00800d8b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9f:	b8 09 00 00 00       	mov    $0x9,%eax
  800da4:	89 df                	mov    %ebx,%edi
  800da6:	89 de                	mov    %ebx,%esi
  800da8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 09                	push   $0x9
  800dbc:	68 bf 27 80 00       	push   $0x8027bf
  800dc1:	6a 23                	push   $0x23
  800dc3:	68 dc 27 80 00       	push   $0x8027dc
  800dc8:	e8 c2 f3 ff ff       	call   80018f <_panic>

00800dcd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de6:	89 df                	mov    %ebx,%edi
  800de8:	89 de                	mov    %ebx,%esi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 0a                	push   $0xa
  800dfe:	68 bf 27 80 00       	push   $0x8027bf
  800e03:	6a 23                	push   $0x23
  800e05:	68 dc 27 80 00       	push   $0x8027dc
  800e0a:	e8 80 f3 ff ff       	call   80018f <_panic>

00800e0f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e15:	8b 55 08             	mov    0x8(%ebp),%edx
  800e18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e20:	be 00 00 00 00       	mov    $0x0,%esi
  800e25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e2b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e2d:	5b                   	pop    %ebx
  800e2e:	5e                   	pop    %esi
  800e2f:	5f                   	pop    %edi
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	57                   	push   %edi
  800e36:	56                   	push   %esi
  800e37:	53                   	push   %ebx
  800e38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e48:	89 cb                	mov    %ecx,%ebx
  800e4a:	89 cf                	mov    %ecx,%edi
  800e4c:	89 ce                	mov    %ecx,%esi
  800e4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	7f 08                	jg     800e5c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5c:	83 ec 0c             	sub    $0xc,%esp
  800e5f:	50                   	push   %eax
  800e60:	6a 0d                	push   $0xd
  800e62:	68 bf 27 80 00       	push   $0x8027bf
  800e67:	6a 23                	push   $0x23
  800e69:	68 dc 27 80 00       	push   $0x8027dc
  800e6e:	e8 1c f3 ff ff       	call   80018f <_panic>

00800e73 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	57                   	push   %edi
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e79:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e83:	89 d1                	mov    %edx,%ecx
  800e85:	89 d3                	mov    %edx,%ebx
  800e87:	89 d7                	mov    %edx,%edi
  800e89:	89 d6                	mov    %edx,%esi
  800e8b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	5d                   	pop    %ebp
  800e91:	c3                   	ret    

00800e92 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	05 00 00 00 30       	add    $0x30000000,%eax
  800e9d:	c1 e8 0c             	shr    $0xc,%eax
}
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    

00800ea2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eb2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ec4:	89 c2                	mov    %eax,%edx
  800ec6:	c1 ea 16             	shr    $0x16,%edx
  800ec9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed0:	f6 c2 01             	test   $0x1,%dl
  800ed3:	74 2a                	je     800eff <fd_alloc+0x46>
  800ed5:	89 c2                	mov    %eax,%edx
  800ed7:	c1 ea 0c             	shr    $0xc,%edx
  800eda:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee1:	f6 c2 01             	test   $0x1,%dl
  800ee4:	74 19                	je     800eff <fd_alloc+0x46>
  800ee6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eeb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ef0:	75 d2                	jne    800ec4 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ef2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ef8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800efd:	eb 07                	jmp    800f06 <fd_alloc+0x4d>
			*fd_store = fd;
  800eff:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    

00800f08 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f0e:	83 f8 1f             	cmp    $0x1f,%eax
  800f11:	77 36                	ja     800f49 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f13:	c1 e0 0c             	shl    $0xc,%eax
  800f16:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	c1 ea 16             	shr    $0x16,%edx
  800f20:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f27:	f6 c2 01             	test   $0x1,%dl
  800f2a:	74 24                	je     800f50 <fd_lookup+0x48>
  800f2c:	89 c2                	mov    %eax,%edx
  800f2e:	c1 ea 0c             	shr    $0xc,%edx
  800f31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f38:	f6 c2 01             	test   $0x1,%dl
  800f3b:	74 1a                	je     800f57 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	89 02                	mov    %eax,(%edx)
	return 0;
  800f42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
		return -E_INVAL;
  800f49:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f4e:	eb f7                	jmp    800f47 <fd_lookup+0x3f>
		return -E_INVAL;
  800f50:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f55:	eb f0                	jmp    800f47 <fd_lookup+0x3f>
  800f57:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5c:	eb e9                	jmp    800f47 <fd_lookup+0x3f>

00800f5e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f5e:	55                   	push   %ebp
  800f5f:	89 e5                	mov    %esp,%ebp
  800f61:	83 ec 08             	sub    $0x8,%esp
  800f64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f67:	ba 6c 28 80 00       	mov    $0x80286c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f6c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f71:	39 08                	cmp    %ecx,(%eax)
  800f73:	74 33                	je     800fa8 <dev_lookup+0x4a>
  800f75:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f78:	8b 02                	mov    (%edx),%eax
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	75 f3                	jne    800f71 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f7e:	a1 20 60 80 00       	mov    0x806020,%eax
  800f83:	8b 40 48             	mov    0x48(%eax),%eax
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	51                   	push   %ecx
  800f8a:	50                   	push   %eax
  800f8b:	68 ec 27 80 00       	push   $0x8027ec
  800f90:	e8 d5 f2 ff ff       	call   80026a <cprintf>
	*dev = 0;
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f9e:	83 c4 10             	add    $0x10,%esp
  800fa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fa6:	c9                   	leave  
  800fa7:	c3                   	ret    
			*dev = devtab[i];
  800fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fab:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fad:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb2:	eb f2                	jmp    800fa6 <dev_lookup+0x48>

00800fb4 <fd_close>:
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	83 ec 1c             	sub    $0x1c,%esp
  800fbd:	8b 75 08             	mov    0x8(%ebp),%esi
  800fc0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fc3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fc6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fcd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd0:	50                   	push   %eax
  800fd1:	e8 32 ff ff ff       	call   800f08 <fd_lookup>
  800fd6:	89 c3                	mov    %eax,%ebx
  800fd8:	83 c4 08             	add    $0x8,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	78 05                	js     800fe4 <fd_close+0x30>
	    || fd != fd2)
  800fdf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fe2:	74 16                	je     800ffa <fd_close+0x46>
		return (must_exist ? r : 0);
  800fe4:	89 f8                	mov    %edi,%eax
  800fe6:	84 c0                	test   %al,%al
  800fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  800fed:	0f 44 d8             	cmove  %eax,%ebx
}
  800ff0:	89 d8                	mov    %ebx,%eax
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ffa:	83 ec 08             	sub    $0x8,%esp
  800ffd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801000:	50                   	push   %eax
  801001:	ff 36                	pushl  (%esi)
  801003:	e8 56 ff ff ff       	call   800f5e <dev_lookup>
  801008:	89 c3                	mov    %eax,%ebx
  80100a:	83 c4 10             	add    $0x10,%esp
  80100d:	85 c0                	test   %eax,%eax
  80100f:	78 15                	js     801026 <fd_close+0x72>
		if (dev->dev_close)
  801011:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801014:	8b 40 10             	mov    0x10(%eax),%eax
  801017:	85 c0                	test   %eax,%eax
  801019:	74 1b                	je     801036 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	56                   	push   %esi
  80101f:	ff d0                	call   *%eax
  801021:	89 c3                	mov    %eax,%ebx
  801023:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801026:	83 ec 08             	sub    $0x8,%esp
  801029:	56                   	push   %esi
  80102a:	6a 00                	push   $0x0
  80102c:	e8 d6 fc ff ff       	call   800d07 <sys_page_unmap>
	return r;
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	eb ba                	jmp    800ff0 <fd_close+0x3c>
			r = 0;
  801036:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103b:	eb e9                	jmp    801026 <fd_close+0x72>

0080103d <close>:

int
close(int fdnum)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801043:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801046:	50                   	push   %eax
  801047:	ff 75 08             	pushl  0x8(%ebp)
  80104a:	e8 b9 fe ff ff       	call   800f08 <fd_lookup>
  80104f:	83 c4 08             	add    $0x8,%esp
  801052:	85 c0                	test   %eax,%eax
  801054:	78 10                	js     801066 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801056:	83 ec 08             	sub    $0x8,%esp
  801059:	6a 01                	push   $0x1
  80105b:	ff 75 f4             	pushl  -0xc(%ebp)
  80105e:	e8 51 ff ff ff       	call   800fb4 <fd_close>
  801063:	83 c4 10             	add    $0x10,%esp
}
  801066:	c9                   	leave  
  801067:	c3                   	ret    

00801068 <close_all>:

void
close_all(void)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	53                   	push   %ebx
  80106c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80106f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	53                   	push   %ebx
  801078:	e8 c0 ff ff ff       	call   80103d <close>
	for (i = 0; i < MAXFD; i++)
  80107d:	83 c3 01             	add    $0x1,%ebx
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	83 fb 20             	cmp    $0x20,%ebx
  801086:	75 ec                	jne    801074 <close_all+0xc>
}
  801088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80108b:	c9                   	leave  
  80108c:	c3                   	ret    

0080108d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	57                   	push   %edi
  801091:	56                   	push   %esi
  801092:	53                   	push   %ebx
  801093:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801096:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801099:	50                   	push   %eax
  80109a:	ff 75 08             	pushl  0x8(%ebp)
  80109d:	e8 66 fe ff ff       	call   800f08 <fd_lookup>
  8010a2:	89 c3                	mov    %eax,%ebx
  8010a4:	83 c4 08             	add    $0x8,%esp
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	0f 88 81 00 00 00    	js     801130 <dup+0xa3>
		return r;
	close(newfdnum);
  8010af:	83 ec 0c             	sub    $0xc,%esp
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	e8 83 ff ff ff       	call   80103d <close>

	newfd = INDEX2FD(newfdnum);
  8010ba:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010bd:	c1 e6 0c             	shl    $0xc,%esi
  8010c0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010c6:	83 c4 04             	add    $0x4,%esp
  8010c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010cc:	e8 d1 fd ff ff       	call   800ea2 <fd2data>
  8010d1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010d3:	89 34 24             	mov    %esi,(%esp)
  8010d6:	e8 c7 fd ff ff       	call   800ea2 <fd2data>
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010e0:	89 d8                	mov    %ebx,%eax
  8010e2:	c1 e8 16             	shr    $0x16,%eax
  8010e5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ec:	a8 01                	test   $0x1,%al
  8010ee:	74 11                	je     801101 <dup+0x74>
  8010f0:	89 d8                	mov    %ebx,%eax
  8010f2:	c1 e8 0c             	shr    $0xc,%eax
  8010f5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010fc:	f6 c2 01             	test   $0x1,%dl
  8010ff:	75 39                	jne    80113a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801101:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801104:	89 d0                	mov    %edx,%eax
  801106:	c1 e8 0c             	shr    $0xc,%eax
  801109:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801110:	83 ec 0c             	sub    $0xc,%esp
  801113:	25 07 0e 00 00       	and    $0xe07,%eax
  801118:	50                   	push   %eax
  801119:	56                   	push   %esi
  80111a:	6a 00                	push   $0x0
  80111c:	52                   	push   %edx
  80111d:	6a 00                	push   $0x0
  80111f:	e8 a1 fb ff ff       	call   800cc5 <sys_page_map>
  801124:	89 c3                	mov    %eax,%ebx
  801126:	83 c4 20             	add    $0x20,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 31                	js     80115e <dup+0xd1>
		goto err;

	return newfdnum;
  80112d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801130:	89 d8                	mov    %ebx,%eax
  801132:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80113a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801141:	83 ec 0c             	sub    $0xc,%esp
  801144:	25 07 0e 00 00       	and    $0xe07,%eax
  801149:	50                   	push   %eax
  80114a:	57                   	push   %edi
  80114b:	6a 00                	push   $0x0
  80114d:	53                   	push   %ebx
  80114e:	6a 00                	push   $0x0
  801150:	e8 70 fb ff ff       	call   800cc5 <sys_page_map>
  801155:	89 c3                	mov    %eax,%ebx
  801157:	83 c4 20             	add    $0x20,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	79 a3                	jns    801101 <dup+0x74>
	sys_page_unmap(0, newfd);
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	56                   	push   %esi
  801162:	6a 00                	push   $0x0
  801164:	e8 9e fb ff ff       	call   800d07 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801169:	83 c4 08             	add    $0x8,%esp
  80116c:	57                   	push   %edi
  80116d:	6a 00                	push   $0x0
  80116f:	e8 93 fb ff ff       	call   800d07 <sys_page_unmap>
	return r;
  801174:	83 c4 10             	add    $0x10,%esp
  801177:	eb b7                	jmp    801130 <dup+0xa3>

00801179 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	53                   	push   %ebx
  80117d:	83 ec 14             	sub    $0x14,%esp
  801180:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801183:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	53                   	push   %ebx
  801188:	e8 7b fd ff ff       	call   800f08 <fd_lookup>
  80118d:	83 c4 08             	add    $0x8,%esp
  801190:	85 c0                	test   %eax,%eax
  801192:	78 3f                	js     8011d3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801194:	83 ec 08             	sub    $0x8,%esp
  801197:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119a:	50                   	push   %eax
  80119b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80119e:	ff 30                	pushl  (%eax)
  8011a0:	e8 b9 fd ff ff       	call   800f5e <dev_lookup>
  8011a5:	83 c4 10             	add    $0x10,%esp
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	78 27                	js     8011d3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011af:	8b 42 08             	mov    0x8(%edx),%eax
  8011b2:	83 e0 03             	and    $0x3,%eax
  8011b5:	83 f8 01             	cmp    $0x1,%eax
  8011b8:	74 1e                	je     8011d8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	8b 40 08             	mov    0x8(%eax),%eax
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	74 35                	je     8011f9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	ff 75 10             	pushl  0x10(%ebp)
  8011ca:	ff 75 0c             	pushl  0xc(%ebp)
  8011cd:	52                   	push   %edx
  8011ce:	ff d0                	call   *%eax
  8011d0:	83 c4 10             	add    $0x10,%esp
}
  8011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011d8:	a1 20 60 80 00       	mov    0x806020,%eax
  8011dd:	8b 40 48             	mov    0x48(%eax),%eax
  8011e0:	83 ec 04             	sub    $0x4,%esp
  8011e3:	53                   	push   %ebx
  8011e4:	50                   	push   %eax
  8011e5:	68 30 28 80 00       	push   $0x802830
  8011ea:	e8 7b f0 ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  8011ef:	83 c4 10             	add    $0x10,%esp
  8011f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f7:	eb da                	jmp    8011d3 <read+0x5a>
		return -E_NOT_SUPP;
  8011f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011fe:	eb d3                	jmp    8011d3 <read+0x5a>

00801200 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	8b 7d 08             	mov    0x8(%ebp),%edi
  80120c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80120f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801214:	39 f3                	cmp    %esi,%ebx
  801216:	73 25                	jae    80123d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	89 f0                	mov    %esi,%eax
  80121d:	29 d8                	sub    %ebx,%eax
  80121f:	50                   	push   %eax
  801220:	89 d8                	mov    %ebx,%eax
  801222:	03 45 0c             	add    0xc(%ebp),%eax
  801225:	50                   	push   %eax
  801226:	57                   	push   %edi
  801227:	e8 4d ff ff ff       	call   801179 <read>
		if (m < 0)
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	78 08                	js     80123b <readn+0x3b>
			return m;
		if (m == 0)
  801233:	85 c0                	test   %eax,%eax
  801235:	74 06                	je     80123d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801237:	01 c3                	add    %eax,%ebx
  801239:	eb d9                	jmp    801214 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80123b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80123d:	89 d8                	mov    %ebx,%eax
  80123f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801242:	5b                   	pop    %ebx
  801243:	5e                   	pop    %esi
  801244:	5f                   	pop    %edi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	53                   	push   %ebx
  80124b:	83 ec 14             	sub    $0x14,%esp
  80124e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801251:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801254:	50                   	push   %eax
  801255:	53                   	push   %ebx
  801256:	e8 ad fc ff ff       	call   800f08 <fd_lookup>
  80125b:	83 c4 08             	add    $0x8,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 3a                	js     80129c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801262:	83 ec 08             	sub    $0x8,%esp
  801265:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80126c:	ff 30                	pushl  (%eax)
  80126e:	e8 eb fc ff ff       	call   800f5e <dev_lookup>
  801273:	83 c4 10             	add    $0x10,%esp
  801276:	85 c0                	test   %eax,%eax
  801278:	78 22                	js     80129c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801281:	74 1e                	je     8012a1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801286:	8b 52 0c             	mov    0xc(%edx),%edx
  801289:	85 d2                	test   %edx,%edx
  80128b:	74 35                	je     8012c2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	ff 75 10             	pushl  0x10(%ebp)
  801293:	ff 75 0c             	pushl  0xc(%ebp)
  801296:	50                   	push   %eax
  801297:	ff d2                	call   *%edx
  801299:	83 c4 10             	add    $0x10,%esp
}
  80129c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8012a6:	8b 40 48             	mov    0x48(%eax),%eax
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	53                   	push   %ebx
  8012ad:	50                   	push   %eax
  8012ae:	68 4c 28 80 00       	push   $0x80284c
  8012b3:	e8 b2 ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  8012b8:	83 c4 10             	add    $0x10,%esp
  8012bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c0:	eb da                	jmp    80129c <write+0x55>
		return -E_NOT_SUPP;
  8012c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012c7:	eb d3                	jmp    80129c <write+0x55>

008012c9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012cf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 08             	pushl  0x8(%ebp)
  8012d6:	e8 2d fc ff ff       	call   800f08 <fd_lookup>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 0e                	js     8012f0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f0:	c9                   	leave  
  8012f1:	c3                   	ret    

008012f2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	53                   	push   %ebx
  8012f6:	83 ec 14             	sub    $0x14,%esp
  8012f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ff:	50                   	push   %eax
  801300:	53                   	push   %ebx
  801301:	e8 02 fc ff ff       	call   800f08 <fd_lookup>
  801306:	83 c4 08             	add    $0x8,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 37                	js     801344 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80130d:	83 ec 08             	sub    $0x8,%esp
  801310:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801313:	50                   	push   %eax
  801314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801317:	ff 30                	pushl  (%eax)
  801319:	e8 40 fc ff ff       	call   800f5e <dev_lookup>
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	78 1f                	js     801344 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80132c:	74 1b                	je     801349 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80132e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801331:	8b 52 18             	mov    0x18(%edx),%edx
  801334:	85 d2                	test   %edx,%edx
  801336:	74 32                	je     80136a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	ff 75 0c             	pushl  0xc(%ebp)
  80133e:	50                   	push   %eax
  80133f:	ff d2                	call   *%edx
  801341:	83 c4 10             	add    $0x10,%esp
}
  801344:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801347:	c9                   	leave  
  801348:	c3                   	ret    
			thisenv->env_id, fdnum);
  801349:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80134e:	8b 40 48             	mov    0x48(%eax),%eax
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	53                   	push   %ebx
  801355:	50                   	push   %eax
  801356:	68 0c 28 80 00       	push   $0x80280c
  80135b:	e8 0a ef ff ff       	call   80026a <cprintf>
		return -E_INVAL;
  801360:	83 c4 10             	add    $0x10,%esp
  801363:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801368:	eb da                	jmp    801344 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80136a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80136f:	eb d3                	jmp    801344 <ftruncate+0x52>

00801371 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	53                   	push   %ebx
  801375:	83 ec 14             	sub    $0x14,%esp
  801378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137e:	50                   	push   %eax
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	e8 81 fb ff ff       	call   800f08 <fd_lookup>
  801387:	83 c4 08             	add    $0x8,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 4b                	js     8013d9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801398:	ff 30                	pushl  (%eax)
  80139a:	e8 bf fb ff ff       	call   800f5e <dev_lookup>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	78 33                	js     8013d9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013ad:	74 2f                	je     8013de <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013af:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013b2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013b9:	00 00 00 
	stat->st_isdir = 0;
  8013bc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013c3:	00 00 00 
	stat->st_dev = dev;
  8013c6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	53                   	push   %ebx
  8013d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d3:	ff 50 14             	call   *0x14(%eax)
  8013d6:	83 c4 10             	add    $0x10,%esp
}
  8013d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    
		return -E_NOT_SUPP;
  8013de:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e3:	eb f4                	jmp    8013d9 <fstat+0x68>

008013e5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013ea:	83 ec 08             	sub    $0x8,%esp
  8013ed:	6a 00                	push   $0x0
  8013ef:	ff 75 08             	pushl  0x8(%ebp)
  8013f2:	e8 e7 01 00 00       	call   8015de <open>
  8013f7:	89 c3                	mov    %eax,%ebx
  8013f9:	83 c4 10             	add    $0x10,%esp
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 1b                	js     80141b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	50                   	push   %eax
  801407:	e8 65 ff ff ff       	call   801371 <fstat>
  80140c:	89 c6                	mov    %eax,%esi
	close(fd);
  80140e:	89 1c 24             	mov    %ebx,(%esp)
  801411:	e8 27 fc ff ff       	call   80103d <close>
	return r;
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	89 f3                	mov    %esi,%ebx
}
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	89 c6                	mov    %eax,%esi
  80142b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80142d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801434:	74 27                	je     80145d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801436:	6a 07                	push   $0x7
  801438:	68 00 70 80 00       	push   $0x807000
  80143d:	56                   	push   %esi
  80143e:	ff 35 00 40 80 00    	pushl  0x804000
  801444:	e8 e5 0c 00 00       	call   80212e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801449:	83 c4 0c             	add    $0xc,%esp
  80144c:	6a 00                	push   $0x0
  80144e:	53                   	push   %ebx
  80144f:	6a 00                	push   $0x0
  801451:	e8 71 0c 00 00       	call   8020c7 <ipc_recv>
}
  801456:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5d                   	pop    %ebp
  80145c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	6a 01                	push   $0x1
  801462:	e8 1b 0d 00 00       	call   802182 <ipc_find_env>
  801467:	a3 00 40 80 00       	mov    %eax,0x804000
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	eb c5                	jmp    801436 <fsipc+0x12>

00801471 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8b 40 0c             	mov    0xc(%eax),%eax
  80147d:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	b8 02 00 00 00       	mov    $0x2,%eax
  801494:	e8 8b ff ff ff       	call   801424 <fsipc>
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <devfile_flush>:
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a7:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8014ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b1:	b8 06 00 00 00       	mov    $0x6,%eax
  8014b6:	e8 69 ff ff ff       	call   801424 <fsipc>
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <devfile_stat>:
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	53                   	push   %ebx
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8014cd:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8014dc:	e8 43 ff ff ff       	call   801424 <fsipc>
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	78 2c                	js     801511 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	68 00 70 80 00       	push   $0x807000
  8014ed:	53                   	push   %ebx
  8014ee:	e8 96 f3 ff ff       	call   800889 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014f3:	a1 80 70 80 00       	mov    0x807080,%eax
  8014f8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014fe:	a1 84 70 80 00       	mov    0x807084,%eax
  801503:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801511:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <devfile_write>:
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	8b 45 10             	mov    0x10(%ebp),%eax
  80151f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801524:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801529:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80152c:	8b 55 08             	mov    0x8(%ebp),%edx
  80152f:	8b 52 0c             	mov    0xc(%edx),%edx
  801532:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = n;
  801538:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80153d:	50                   	push   %eax
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	68 08 70 80 00       	push   $0x807008
  801546:	e8 cc f4 ff ff       	call   800a17 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80154b:	ba 00 00 00 00       	mov    $0x0,%edx
  801550:	b8 04 00 00 00       	mov    $0x4,%eax
  801555:	e8 ca fe ff ff       	call   801424 <fsipc>
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <devfile_read>:
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	56                   	push   %esi
  801560:	53                   	push   %ebx
  801561:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8b 40 0c             	mov    0xc(%eax),%eax
  80156a:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80156f:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	b8 03 00 00 00       	mov    $0x3,%eax
  80157f:	e8 a0 fe ff ff       	call   801424 <fsipc>
  801584:	89 c3                	mov    %eax,%ebx
  801586:	85 c0                	test   %eax,%eax
  801588:	78 1f                	js     8015a9 <devfile_read+0x4d>
	assert(r <= n);
  80158a:	39 f0                	cmp    %esi,%eax
  80158c:	77 24                	ja     8015b2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80158e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801593:	7f 33                	jg     8015c8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	50                   	push   %eax
  801599:	68 00 70 80 00       	push   $0x807000
  80159e:	ff 75 0c             	pushl  0xc(%ebp)
  8015a1:	e8 71 f4 ff ff       	call   800a17 <memmove>
	return r;
  8015a6:	83 c4 10             	add    $0x10,%esp
}
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ae:	5b                   	pop    %ebx
  8015af:	5e                   	pop    %esi
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    
	assert(r <= n);
  8015b2:	68 80 28 80 00       	push   $0x802880
  8015b7:	68 87 28 80 00       	push   $0x802887
  8015bc:	6a 7b                	push   $0x7b
  8015be:	68 9c 28 80 00       	push   $0x80289c
  8015c3:	e8 c7 eb ff ff       	call   80018f <_panic>
	assert(r <= PGSIZE);
  8015c8:	68 a7 28 80 00       	push   $0x8028a7
  8015cd:	68 87 28 80 00       	push   $0x802887
  8015d2:	6a 7c                	push   $0x7c
  8015d4:	68 9c 28 80 00       	push   $0x80289c
  8015d9:	e8 b1 eb ff ff       	call   80018f <_panic>

008015de <open>:
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	56                   	push   %esi
  8015e2:	53                   	push   %ebx
  8015e3:	83 ec 1c             	sub    $0x1c,%esp
  8015e6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015e9:	56                   	push   %esi
  8015ea:	e8 63 f2 ff ff       	call   800852 <strlen>
  8015ef:	83 c4 10             	add    $0x10,%esp
  8015f2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015f7:	7f 6c                	jg     801665 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	e8 b4 f8 ff ff       	call   800eb9 <fd_alloc>
  801605:	89 c3                	mov    %eax,%ebx
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	85 c0                	test   %eax,%eax
  80160c:	78 3c                	js     80164a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	56                   	push   %esi
  801612:	68 00 70 80 00       	push   $0x807000
  801617:	e8 6d f2 ff ff       	call   800889 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801627:	b8 01 00 00 00       	mov    $0x1,%eax
  80162c:	e8 f3 fd ff ff       	call   801424 <fsipc>
  801631:	89 c3                	mov    %eax,%ebx
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	85 c0                	test   %eax,%eax
  801638:	78 19                	js     801653 <open+0x75>
	return fd2num(fd);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	ff 75 f4             	pushl  -0xc(%ebp)
  801640:	e8 4d f8 ff ff       	call   800e92 <fd2num>
  801645:	89 c3                	mov    %eax,%ebx
  801647:	83 c4 10             	add    $0x10,%esp
}
  80164a:	89 d8                	mov    %ebx,%eax
  80164c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    
		fd_close(fd, 0);
  801653:	83 ec 08             	sub    $0x8,%esp
  801656:	6a 00                	push   $0x0
  801658:	ff 75 f4             	pushl  -0xc(%ebp)
  80165b:	e8 54 f9 ff ff       	call   800fb4 <fd_close>
		return r;
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	eb e5                	jmp    80164a <open+0x6c>
		return -E_BAD_PATH;
  801665:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80166a:	eb de                	jmp    80164a <open+0x6c>

0080166c <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	b8 08 00 00 00       	mov    $0x8,%eax
  80167c:	e8 a3 fd ff ff       	call   801424 <fsipc>
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801683:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801687:	7e 38                	jle    8016c1 <writebuf+0x3e>
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	53                   	push   %ebx
  80168d:	83 ec 08             	sub    $0x8,%esp
  801690:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801692:	ff 70 04             	pushl  0x4(%eax)
  801695:	8d 40 10             	lea    0x10(%eax),%eax
  801698:	50                   	push   %eax
  801699:	ff 33                	pushl  (%ebx)
  80169b:	e8 a7 fb ff ff       	call   801247 <write>
		if (result > 0)
  8016a0:	83 c4 10             	add    $0x10,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	7e 03                	jle    8016aa <writebuf+0x27>
			b->result += result;
  8016a7:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016aa:	39 43 04             	cmp    %eax,0x4(%ebx)
  8016ad:	74 0d                	je     8016bc <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	0f 4f c2             	cmovg  %edx,%eax
  8016b9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8016bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    
  8016c1:	f3 c3                	repz ret 

008016c3 <putch>:

static void
putch(int ch, void *thunk)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	53                   	push   %ebx
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016cd:	8b 53 04             	mov    0x4(%ebx),%edx
  8016d0:	8d 42 01             	lea    0x1(%edx),%eax
  8016d3:	89 43 04             	mov    %eax,0x4(%ebx)
  8016d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016d9:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8016dd:	3d 00 01 00 00       	cmp    $0x100,%eax
  8016e2:	74 06                	je     8016ea <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8016e4:	83 c4 04             	add    $0x4,%esp
  8016e7:	5b                   	pop    %ebx
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    
		writebuf(b);
  8016ea:	89 d8                	mov    %ebx,%eax
  8016ec:	e8 92 ff ff ff       	call   801683 <writebuf>
		b->idx = 0;
  8016f1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8016f8:	eb ea                	jmp    8016e4 <putch+0x21>

008016fa <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80170c:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801713:	00 00 00 
	b.result = 0;
  801716:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80171d:	00 00 00 
	b.error = 1;
  801720:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801727:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80172a:	ff 75 10             	pushl  0x10(%ebp)
  80172d:	ff 75 0c             	pushl  0xc(%ebp)
  801730:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801736:	50                   	push   %eax
  801737:	68 c3 16 80 00       	push   $0x8016c3
  80173c:	e8 26 ec ff ff       	call   800367 <vprintfmt>
	if (b.idx > 0)
  801741:	83 c4 10             	add    $0x10,%esp
  801744:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80174b:	7f 11                	jg     80175e <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80174d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801753:	85 c0                	test   %eax,%eax
  801755:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    
		writebuf(&b);
  80175e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801764:	e8 1a ff ff ff       	call   801683 <writebuf>
  801769:	eb e2                	jmp    80174d <vfprintf+0x53>

0080176b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801771:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801774:	50                   	push   %eax
  801775:	ff 75 0c             	pushl  0xc(%ebp)
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	e8 7a ff ff ff       	call   8016fa <vfprintf>
	va_end(ap);

	return cnt;
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <printf>:

int
printf(const char *fmt, ...)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801788:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80178b:	50                   	push   %eax
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 01                	push   $0x1
  801791:	e8 64 ff ff ff       	call   8016fa <vfprintf>
	va_end(ap);

	return cnt;
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80179e:	68 b3 28 80 00       	push   $0x8028b3
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	e8 de f0 ff ff       	call   800889 <strcpy>
	return 0;
}
  8017ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <devsock_close>:
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	53                   	push   %ebx
  8017b6:	83 ec 10             	sub    $0x10,%esp
  8017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017bc:	53                   	push   %ebx
  8017bd:	e8 f9 09 00 00       	call   8021bb <pageref>
  8017c2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8017ca:	83 f8 01             	cmp    $0x1,%eax
  8017cd:	74 07                	je     8017d6 <devsock_close+0x24>
}
  8017cf:	89 d0                	mov    %edx,%eax
  8017d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	ff 73 0c             	pushl  0xc(%ebx)
  8017dc:	e8 b7 02 00 00       	call   801a98 <nsipc_close>
  8017e1:	89 c2                	mov    %eax,%edx
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	eb e7                	jmp    8017cf <devsock_close+0x1d>

008017e8 <devsock_write>:
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	ff 75 10             	pushl  0x10(%ebp)
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	ff 70 0c             	pushl  0xc(%eax)
  8017fc:	e8 74 03 00 00       	call   801b75 <nsipc_send>
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devsock_read>:
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 10             	pushl  0x10(%ebp)
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	ff 70 0c             	pushl  0xc(%eax)
  801817:	e8 ed 02 00 00       	call   801b09 <nsipc_recv>
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <fd2sockid>:
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801824:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801827:	52                   	push   %edx
  801828:	50                   	push   %eax
  801829:	e8 da f6 ff ff       	call   800f08 <fd_lookup>
  80182e:	83 c4 10             	add    $0x10,%esp
  801831:	85 c0                	test   %eax,%eax
  801833:	78 10                	js     801845 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801838:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80183e:	39 08                	cmp    %ecx,(%eax)
  801840:	75 05                	jne    801847 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801842:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    
		return -E_NOT_SUPP;
  801847:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184c:	eb f7                	jmp    801845 <fd2sockid+0x27>

0080184e <alloc_sockfd>:
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	83 ec 1c             	sub    $0x1c,%esp
  801856:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801858:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185b:	50                   	push   %eax
  80185c:	e8 58 f6 ff ff       	call   800eb9 <fd_alloc>
  801861:	89 c3                	mov    %eax,%ebx
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	85 c0                	test   %eax,%eax
  801868:	78 43                	js     8018ad <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 07 04 00 00       	push   $0x407
  801872:	ff 75 f4             	pushl  -0xc(%ebp)
  801875:	6a 00                	push   $0x0
  801877:	e8 06 f4 ff ff       	call   800c82 <sys_page_alloc>
  80187c:	89 c3                	mov    %eax,%ebx
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 28                	js     8018ad <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801888:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80188e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801893:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80189a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80189d:	83 ec 0c             	sub    $0xc,%esp
  8018a0:	50                   	push   %eax
  8018a1:	e8 ec f5 ff ff       	call   800e92 <fd2num>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	eb 0c                	jmp    8018b9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018ad:	83 ec 0c             	sub    $0xc,%esp
  8018b0:	56                   	push   %esi
  8018b1:	e8 e2 01 00 00       	call   801a98 <nsipc_close>
		return r;
  8018b6:	83 c4 10             	add    $0x10,%esp
}
  8018b9:	89 d8                	mov    %ebx,%eax
  8018bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <accept>:
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	e8 4e ff ff ff       	call   80181e <fd2sockid>
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	78 1b                	js     8018ef <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	ff 75 10             	pushl  0x10(%ebp)
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	50                   	push   %eax
  8018de:	e8 0e 01 00 00       	call   8019f1 <nsipc_accept>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 05                	js     8018ef <accept+0x2d>
	return alloc_sockfd(r);
  8018ea:	e8 5f ff ff ff       	call   80184e <alloc_sockfd>
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <bind>:
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	e8 1f ff ff ff       	call   80181e <fd2sockid>
  8018ff:	85 c0                	test   %eax,%eax
  801901:	78 12                	js     801915 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	ff 75 10             	pushl  0x10(%ebp)
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	50                   	push   %eax
  80190d:	e8 2f 01 00 00       	call   801a41 <nsipc_bind>
  801912:	83 c4 10             	add    $0x10,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <shutdown>:
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	e8 f9 fe ff ff       	call   80181e <fd2sockid>
  801925:	85 c0                	test   %eax,%eax
  801927:	78 0f                	js     801938 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801929:	83 ec 08             	sub    $0x8,%esp
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	50                   	push   %eax
  801930:	e8 41 01 00 00       	call   801a76 <nsipc_shutdown>
  801935:	83 c4 10             	add    $0x10,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <connect>:
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	e8 d6 fe ff ff       	call   80181e <fd2sockid>
  801948:	85 c0                	test   %eax,%eax
  80194a:	78 12                	js     80195e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	ff 75 10             	pushl  0x10(%ebp)
  801952:	ff 75 0c             	pushl  0xc(%ebp)
  801955:	50                   	push   %eax
  801956:	e8 57 01 00 00       	call   801ab2 <nsipc_connect>
  80195b:	83 c4 10             	add    $0x10,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <listen>:
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	e8 b0 fe ff ff       	call   80181e <fd2sockid>
  80196e:	85 c0                	test   %eax,%eax
  801970:	78 0f                	js     801981 <listen+0x21>
	return nsipc_listen(r, backlog);
  801972:	83 ec 08             	sub    $0x8,%esp
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	50                   	push   %eax
  801979:	e8 69 01 00 00       	call   801ae7 <nsipc_listen>
  80197e:	83 c4 10             	add    $0x10,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <socket>:

int
socket(int domain, int type, int protocol)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801989:	ff 75 10             	pushl  0x10(%ebp)
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	e8 3c 02 00 00       	call   801bd3 <nsipc_socket>
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 05                	js     8019a3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80199e:	e8 ab fe ff ff       	call   80184e <alloc_sockfd>
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	53                   	push   %ebx
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019ae:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019b5:	74 26                	je     8019dd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019b7:	6a 07                	push   $0x7
  8019b9:	68 00 80 80 00       	push   $0x808000
  8019be:	53                   	push   %ebx
  8019bf:	ff 35 04 40 80 00    	pushl  0x804004
  8019c5:	e8 64 07 00 00       	call   80212e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8019ca:	83 c4 0c             	add    $0xc,%esp
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	e8 ef 06 00 00       	call   8020c7 <ipc_recv>
}
  8019d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	6a 02                	push   $0x2
  8019e2:	e8 9b 07 00 00       	call   802182 <ipc_find_env>
  8019e7:	a3 04 40 80 00       	mov    %eax,0x804004
  8019ec:	83 c4 10             	add    $0x10,%esp
  8019ef:	eb c6                	jmp    8019b7 <nsipc+0x12>

008019f1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a01:	8b 06                	mov    (%esi),%eax
  801a03:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a08:	b8 01 00 00 00       	mov    $0x1,%eax
  801a0d:	e8 93 ff ff ff       	call   8019a5 <nsipc>
  801a12:	89 c3                	mov    %eax,%ebx
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 20                	js     801a38 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a18:	83 ec 04             	sub    $0x4,%esp
  801a1b:	ff 35 10 80 80 00    	pushl  0x808010
  801a21:	68 00 80 80 00       	push   $0x808000
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	e8 e9 ef ff ff       	call   800a17 <memmove>
		*addrlen = ret->ret_addrlen;
  801a2e:	a1 10 80 80 00       	mov    0x808010,%eax
  801a33:	89 06                	mov    %eax,(%esi)
  801a35:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801a38:	89 d8                	mov    %ebx,%eax
  801a3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5e                   	pop    %esi
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	53                   	push   %ebx
  801a45:	83 ec 08             	sub    $0x8,%esp
  801a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a53:	53                   	push   %ebx
  801a54:	ff 75 0c             	pushl  0xc(%ebp)
  801a57:	68 04 80 80 00       	push   $0x808004
  801a5c:	e8 b6 ef ff ff       	call   800a17 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a61:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801a67:	b8 02 00 00 00       	mov    $0x2,%eax
  801a6c:	e8 34 ff ff ff       	call   8019a5 <nsipc>
}
  801a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801a8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801a91:	e8 0f ff ff ff       	call   8019a5 <nsipc>
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <nsipc_close>:

int
nsipc_close(int s)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801aa6:	b8 04 00 00 00       	mov    $0x4,%eax
  801aab:	e8 f5 fe ff ff       	call   8019a5 <nsipc>
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 08             	sub    $0x8,%esp
  801ab9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ac4:	53                   	push   %ebx
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	68 04 80 80 00       	push   $0x808004
  801acd:	e8 45 ef ff ff       	call   800a17 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ad2:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801ad8:	b8 05 00 00 00       	mov    $0x5,%eax
  801add:	e8 c3 fe ff ff       	call   8019a5 <nsipc>
}
  801ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af8:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801afd:	b8 06 00 00 00       	mov    $0x6,%eax
  801b02:	e8 9e fe ff ff       	call   8019a5 <nsipc>
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	56                   	push   %esi
  801b0d:	53                   	push   %ebx
  801b0e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801b19:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801b1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b22:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b27:	b8 07 00 00 00       	mov    $0x7,%eax
  801b2c:	e8 74 fe ff ff       	call   8019a5 <nsipc>
  801b31:	89 c3                	mov    %eax,%ebx
  801b33:	85 c0                	test   %eax,%eax
  801b35:	78 1f                	js     801b56 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b37:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b3c:	7f 21                	jg     801b5f <nsipc_recv+0x56>
  801b3e:	39 c6                	cmp    %eax,%esi
  801b40:	7c 1d                	jl     801b5f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	50                   	push   %eax
  801b46:	68 00 80 80 00       	push   $0x808000
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	e8 c4 ee ff ff       	call   800a17 <memmove>
  801b53:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b56:	89 d8                	mov    %ebx,%eax
  801b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801b5f:	68 bf 28 80 00       	push   $0x8028bf
  801b64:	68 87 28 80 00       	push   $0x802887
  801b69:	6a 62                	push   $0x62
  801b6b:	68 d4 28 80 00       	push   $0x8028d4
  801b70:	e8 1a e6 ff ff       	call   80018f <_panic>

00801b75 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	53                   	push   %ebx
  801b79:	83 ec 04             	sub    $0x4,%esp
  801b7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801b87:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801b8d:	7f 2e                	jg     801bbd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801b8f:	83 ec 04             	sub    $0x4,%esp
  801b92:	53                   	push   %ebx
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	68 0c 80 80 00       	push   $0x80800c
  801b9b:	e8 77 ee ff ff       	call   800a17 <memmove>
	nsipcbuf.send.req_size = size;
  801ba0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801ba6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801bae:	b8 08 00 00 00       	mov    $0x8,%eax
  801bb3:	e8 ed fd ff ff       	call   8019a5 <nsipc>
}
  801bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    
	assert(size < 1600);
  801bbd:	68 e0 28 80 00       	push   $0x8028e0
  801bc2:	68 87 28 80 00       	push   $0x802887
  801bc7:	6a 6d                	push   $0x6d
  801bc9:	68 d4 28 80 00       	push   $0x8028d4
  801bce:	e8 bc e5 ff ff       	call   80018f <_panic>

00801bd3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801be1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be4:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801be9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bec:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801bf1:	b8 09 00 00 00       	mov    $0x9,%eax
  801bf6:	e8 aa fd ff ff       	call   8019a5 <nsipc>
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
  801c02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	e8 92 f2 ff ff       	call   800ea2 <fd2data>
  801c10:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c12:	83 c4 08             	add    $0x8,%esp
  801c15:	68 ec 28 80 00       	push   $0x8028ec
  801c1a:	53                   	push   %ebx
  801c1b:	e8 69 ec ff ff       	call   800889 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c20:	8b 46 04             	mov    0x4(%esi),%eax
  801c23:	2b 06                	sub    (%esi),%eax
  801c25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c32:	00 00 00 
	stat->st_dev = &devpipe;
  801c35:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c3c:	30 80 00 
	return 0;
}
  801c3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    

00801c4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	53                   	push   %ebx
  801c4f:	83 ec 0c             	sub    $0xc,%esp
  801c52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c55:	53                   	push   %ebx
  801c56:	6a 00                	push   $0x0
  801c58:	e8 aa f0 ff ff       	call   800d07 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c5d:	89 1c 24             	mov    %ebx,(%esp)
  801c60:	e8 3d f2 ff ff       	call   800ea2 <fd2data>
  801c65:	83 c4 08             	add    $0x8,%esp
  801c68:	50                   	push   %eax
  801c69:	6a 00                	push   $0x0
  801c6b:	e8 97 f0 ff ff       	call   800d07 <sys_page_unmap>
}
  801c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <_pipeisclosed>:
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	57                   	push   %edi
  801c79:	56                   	push   %esi
  801c7a:	53                   	push   %ebx
  801c7b:	83 ec 1c             	sub    $0x1c,%esp
  801c7e:	89 c7                	mov    %eax,%edi
  801c80:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801c82:	a1 20 60 80 00       	mov    0x806020,%eax
  801c87:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	57                   	push   %edi
  801c8e:	e8 28 05 00 00       	call   8021bb <pageref>
  801c93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801c96:	89 34 24             	mov    %esi,(%esp)
  801c99:	e8 1d 05 00 00       	call   8021bb <pageref>
		nn = thisenv->env_runs;
  801c9e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801ca4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	39 cb                	cmp    %ecx,%ebx
  801cac:	74 1b                	je     801cc9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cb1:	75 cf                	jne    801c82 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cb3:	8b 42 58             	mov    0x58(%edx),%eax
  801cb6:	6a 01                	push   $0x1
  801cb8:	50                   	push   %eax
  801cb9:	53                   	push   %ebx
  801cba:	68 f3 28 80 00       	push   $0x8028f3
  801cbf:	e8 a6 e5 ff ff       	call   80026a <cprintf>
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	eb b9                	jmp    801c82 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cc9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ccc:	0f 94 c0             	sete   %al
  801ccf:	0f b6 c0             	movzbl %al,%eax
}
  801cd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cd5:	5b                   	pop    %ebx
  801cd6:	5e                   	pop    %esi
  801cd7:	5f                   	pop    %edi
  801cd8:	5d                   	pop    %ebp
  801cd9:	c3                   	ret    

00801cda <devpipe_write>:
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	57                   	push   %edi
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	83 ec 28             	sub    $0x28,%esp
  801ce3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ce6:	56                   	push   %esi
  801ce7:	e8 b6 f1 ff ff       	call   800ea2 <fd2data>
  801cec:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801cee:	83 c4 10             	add    $0x10,%esp
  801cf1:	bf 00 00 00 00       	mov    $0x0,%edi
  801cf6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801cf9:	74 4f                	je     801d4a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801cfb:	8b 43 04             	mov    0x4(%ebx),%eax
  801cfe:	8b 0b                	mov    (%ebx),%ecx
  801d00:	8d 51 20             	lea    0x20(%ecx),%edx
  801d03:	39 d0                	cmp    %edx,%eax
  801d05:	72 14                	jb     801d1b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d07:	89 da                	mov    %ebx,%edx
  801d09:	89 f0                	mov    %esi,%eax
  801d0b:	e8 65 ff ff ff       	call   801c75 <_pipeisclosed>
  801d10:	85 c0                	test   %eax,%eax
  801d12:	75 3a                	jne    801d4e <devpipe_write+0x74>
			sys_yield();
  801d14:	e8 4a ef ff ff       	call   800c63 <sys_yield>
  801d19:	eb e0                	jmp    801cfb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d1e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d22:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d25:	89 c2                	mov    %eax,%edx
  801d27:	c1 fa 1f             	sar    $0x1f,%edx
  801d2a:	89 d1                	mov    %edx,%ecx
  801d2c:	c1 e9 1b             	shr    $0x1b,%ecx
  801d2f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d32:	83 e2 1f             	and    $0x1f,%edx
  801d35:	29 ca                	sub    %ecx,%edx
  801d37:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d3b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d3f:	83 c0 01             	add    $0x1,%eax
  801d42:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d45:	83 c7 01             	add    $0x1,%edi
  801d48:	eb ac                	jmp    801cf6 <devpipe_write+0x1c>
	return i;
  801d4a:	89 f8                	mov    %edi,%eax
  801d4c:	eb 05                	jmp    801d53 <devpipe_write+0x79>
				return 0;
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5e                   	pop    %esi
  801d58:	5f                   	pop    %edi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <devpipe_read>:
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	57                   	push   %edi
  801d5f:	56                   	push   %esi
  801d60:	53                   	push   %ebx
  801d61:	83 ec 18             	sub    $0x18,%esp
  801d64:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d67:	57                   	push   %edi
  801d68:	e8 35 f1 ff ff       	call   800ea2 <fd2data>
  801d6d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d6f:	83 c4 10             	add    $0x10,%esp
  801d72:	be 00 00 00 00       	mov    $0x0,%esi
  801d77:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d7a:	74 47                	je     801dc3 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801d7c:	8b 03                	mov    (%ebx),%eax
  801d7e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d81:	75 22                	jne    801da5 <devpipe_read+0x4a>
			if (i > 0)
  801d83:	85 f6                	test   %esi,%esi
  801d85:	75 14                	jne    801d9b <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801d87:	89 da                	mov    %ebx,%edx
  801d89:	89 f8                	mov    %edi,%eax
  801d8b:	e8 e5 fe ff ff       	call   801c75 <_pipeisclosed>
  801d90:	85 c0                	test   %eax,%eax
  801d92:	75 33                	jne    801dc7 <devpipe_read+0x6c>
			sys_yield();
  801d94:	e8 ca ee ff ff       	call   800c63 <sys_yield>
  801d99:	eb e1                	jmp    801d7c <devpipe_read+0x21>
				return i;
  801d9b:	89 f0                	mov    %esi,%eax
}
  801d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5e                   	pop    %esi
  801da2:	5f                   	pop    %edi
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801da5:	99                   	cltd   
  801da6:	c1 ea 1b             	shr    $0x1b,%edx
  801da9:	01 d0                	add    %edx,%eax
  801dab:	83 e0 1f             	and    $0x1f,%eax
  801dae:	29 d0                	sub    %edx,%eax
  801db0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801dbb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801dbe:	83 c6 01             	add    $0x1,%esi
  801dc1:	eb b4                	jmp    801d77 <devpipe_read+0x1c>
	return i;
  801dc3:	89 f0                	mov    %esi,%eax
  801dc5:	eb d6                	jmp    801d9d <devpipe_read+0x42>
				return 0;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	eb cf                	jmp    801d9d <devpipe_read+0x42>

00801dce <pipe>:
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801dd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dd9:	50                   	push   %eax
  801dda:	e8 da f0 ff ff       	call   800eb9 <fd_alloc>
  801ddf:	89 c3                	mov    %eax,%ebx
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 5b                	js     801e43 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	68 07 04 00 00       	push   $0x407
  801df0:	ff 75 f4             	pushl  -0xc(%ebp)
  801df3:	6a 00                	push   $0x0
  801df5:	e8 88 ee ff ff       	call   800c82 <sys_page_alloc>
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	83 c4 10             	add    $0x10,%esp
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 40                	js     801e43 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e09:	50                   	push   %eax
  801e0a:	e8 aa f0 ff ff       	call   800eb9 <fd_alloc>
  801e0f:	89 c3                	mov    %eax,%ebx
  801e11:	83 c4 10             	add    $0x10,%esp
  801e14:	85 c0                	test   %eax,%eax
  801e16:	78 1b                	js     801e33 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	68 07 04 00 00       	push   $0x407
  801e20:	ff 75 f0             	pushl  -0x10(%ebp)
  801e23:	6a 00                	push   $0x0
  801e25:	e8 58 ee ff ff       	call   800c82 <sys_page_alloc>
  801e2a:	89 c3                	mov    %eax,%ebx
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	79 19                	jns    801e4c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e33:	83 ec 08             	sub    $0x8,%esp
  801e36:	ff 75 f4             	pushl  -0xc(%ebp)
  801e39:	6a 00                	push   $0x0
  801e3b:	e8 c7 ee ff ff       	call   800d07 <sys_page_unmap>
  801e40:	83 c4 10             	add    $0x10,%esp
}
  801e43:	89 d8                	mov    %ebx,%eax
  801e45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5d                   	pop    %ebp
  801e4b:	c3                   	ret    
	va = fd2data(fd0);
  801e4c:	83 ec 0c             	sub    $0xc,%esp
  801e4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e52:	e8 4b f0 ff ff       	call   800ea2 <fd2data>
  801e57:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e59:	83 c4 0c             	add    $0xc,%esp
  801e5c:	68 07 04 00 00       	push   $0x407
  801e61:	50                   	push   %eax
  801e62:	6a 00                	push   $0x0
  801e64:	e8 19 ee ff ff       	call   800c82 <sys_page_alloc>
  801e69:	89 c3                	mov    %eax,%ebx
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	0f 88 8c 00 00 00    	js     801f02 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	ff 75 f0             	pushl  -0x10(%ebp)
  801e7c:	e8 21 f0 ff ff       	call   800ea2 <fd2data>
  801e81:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e88:	50                   	push   %eax
  801e89:	6a 00                	push   $0x0
  801e8b:	56                   	push   %esi
  801e8c:	6a 00                	push   $0x0
  801e8e:	e8 32 ee ff ff       	call   800cc5 <sys_page_map>
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	83 c4 20             	add    $0x20,%esp
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	78 58                	js     801ef4 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ea5:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801eba:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ecc:	e8 c1 ef ff ff       	call   800e92 <fd2num>
  801ed1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ed4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ed6:	83 c4 04             	add    $0x4,%esp
  801ed9:	ff 75 f0             	pushl  -0x10(%ebp)
  801edc:	e8 b1 ef ff ff       	call   800e92 <fd2num>
  801ee1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ee7:	83 c4 10             	add    $0x10,%esp
  801eea:	bb 00 00 00 00       	mov    $0x0,%ebx
  801eef:	e9 4f ff ff ff       	jmp    801e43 <pipe+0x75>
	sys_page_unmap(0, va);
  801ef4:	83 ec 08             	sub    $0x8,%esp
  801ef7:	56                   	push   %esi
  801ef8:	6a 00                	push   $0x0
  801efa:	e8 08 ee ff ff       	call   800d07 <sys_page_unmap>
  801eff:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f02:	83 ec 08             	sub    $0x8,%esp
  801f05:	ff 75 f0             	pushl  -0x10(%ebp)
  801f08:	6a 00                	push   $0x0
  801f0a:	e8 f8 ed ff ff       	call   800d07 <sys_page_unmap>
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	e9 1c ff ff ff       	jmp    801e33 <pipe+0x65>

00801f17 <pipeisclosed>:
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f1d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f20:	50                   	push   %eax
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	e8 df ef ff ff       	call   800f08 <fd_lookup>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	78 18                	js     801f48 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f30:	83 ec 0c             	sub    $0xc,%esp
  801f33:	ff 75 f4             	pushl  -0xc(%ebp)
  801f36:	e8 67 ef ff ff       	call   800ea2 <fd2data>
	return _pipeisclosed(fd, p);
  801f3b:	89 c2                	mov    %eax,%edx
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	e8 30 fd ff ff       	call   801c75 <_pipeisclosed>
  801f45:	83 c4 10             	add    $0x10,%esp
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f5a:	68 0b 29 80 00       	push   $0x80290b
  801f5f:	ff 75 0c             	pushl  0xc(%ebp)
  801f62:	e8 22 e9 ff ff       	call   800889 <strcpy>
	return 0;
}
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <devcons_write>:
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	57                   	push   %edi
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801f7a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801f7f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801f85:	eb 2f                	jmp    801fb6 <devcons_write+0x48>
		m = n - tot;
  801f87:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f8a:	29 f3                	sub    %esi,%ebx
  801f8c:	83 fb 7f             	cmp    $0x7f,%ebx
  801f8f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801f94:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f97:	83 ec 04             	sub    $0x4,%esp
  801f9a:	53                   	push   %ebx
  801f9b:	89 f0                	mov    %esi,%eax
  801f9d:	03 45 0c             	add    0xc(%ebp),%eax
  801fa0:	50                   	push   %eax
  801fa1:	57                   	push   %edi
  801fa2:	e8 70 ea ff ff       	call   800a17 <memmove>
		sys_cputs(buf, m);
  801fa7:	83 c4 08             	add    $0x8,%esp
  801faa:	53                   	push   %ebx
  801fab:	57                   	push   %edi
  801fac:	e8 15 ec ff ff       	call   800bc6 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fb1:	01 de                	add    %ebx,%esi
  801fb3:	83 c4 10             	add    $0x10,%esp
  801fb6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb9:	72 cc                	jb     801f87 <devcons_write+0x19>
}
  801fbb:	89 f0                	mov    %esi,%eax
  801fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5f                   	pop    %edi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <devcons_read>:
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
  801fcb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd4:	75 07                	jne    801fdd <devcons_read+0x18>
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    
		sys_yield();
  801fd8:	e8 86 ec ff ff       	call   800c63 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801fdd:	e8 02 ec ff ff       	call   800be4 <sys_cgetc>
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	74 f2                	je     801fd8 <devcons_read+0x13>
	if (c < 0)
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	78 ec                	js     801fd6 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801fea:	83 f8 04             	cmp    $0x4,%eax
  801fed:	74 0c                	je     801ffb <devcons_read+0x36>
	*(char*)vbuf = c;
  801fef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff2:	88 02                	mov    %al,(%edx)
	return 1;
  801ff4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff9:	eb db                	jmp    801fd6 <devcons_read+0x11>
		return 0;
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  802000:	eb d4                	jmp    801fd6 <devcons_read+0x11>

00802002 <cputchar>:
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80200e:	6a 01                	push   $0x1
  802010:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802013:	50                   	push   %eax
  802014:	e8 ad eb ff ff       	call   800bc6 <sys_cputs>
}
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <getchar>:
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802024:	6a 01                	push   $0x1
  802026:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802029:	50                   	push   %eax
  80202a:	6a 00                	push   $0x0
  80202c:	e8 48 f1 ff ff       	call   801179 <read>
	if (r < 0)
  802031:	83 c4 10             	add    $0x10,%esp
  802034:	85 c0                	test   %eax,%eax
  802036:	78 08                	js     802040 <getchar+0x22>
	if (r < 1)
  802038:	85 c0                	test   %eax,%eax
  80203a:	7e 06                	jle    802042 <getchar+0x24>
	return c;
  80203c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    
		return -E_EOF;
  802042:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802047:	eb f7                	jmp    802040 <getchar+0x22>

00802049 <iscons>:
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80204f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802052:	50                   	push   %eax
  802053:	ff 75 08             	pushl  0x8(%ebp)
  802056:	e8 ad ee ff ff       	call   800f08 <fd_lookup>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	85 c0                	test   %eax,%eax
  802060:	78 11                	js     802073 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80206b:	39 10                	cmp    %edx,(%eax)
  80206d:	0f 94 c0             	sete   %al
  802070:	0f b6 c0             	movzbl %al,%eax
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <opencons>:
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80207b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80207e:	50                   	push   %eax
  80207f:	e8 35 ee ff ff       	call   800eb9 <fd_alloc>
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	85 c0                	test   %eax,%eax
  802089:	78 3a                	js     8020c5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 07 04 00 00       	push   $0x407
  802093:	ff 75 f4             	pushl  -0xc(%ebp)
  802096:	6a 00                	push   $0x0
  802098:	e8 e5 eb ff ff       	call   800c82 <sys_page_alloc>
  80209d:	83 c4 10             	add    $0x10,%esp
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 21                	js     8020c5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020ad:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	50                   	push   %eax
  8020bd:	e8 d0 ed ff ff       	call   800e92 <fd2num>
  8020c2:	83 c4 10             	add    $0x10,%esp
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	56                   	push   %esi
  8020cb:	53                   	push   %ebx
  8020cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8020d5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8020d7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8020dc:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8020df:	83 ec 0c             	sub    $0xc,%esp
  8020e2:	50                   	push   %eax
  8020e3:	e8 4a ed ff ff       	call   800e32 <sys_ipc_recv>
	if (from_env_store)
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	85 f6                	test   %esi,%esi
  8020ed:	74 14                	je     802103 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8020ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 09                	js     802101 <ipc_recv+0x3a>
  8020f8:	8b 15 20 60 80 00    	mov    0x806020,%edx
  8020fe:	8b 52 74             	mov    0x74(%edx),%edx
  802101:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802103:	85 db                	test   %ebx,%ebx
  802105:	74 14                	je     80211b <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802107:	ba 00 00 00 00       	mov    $0x0,%edx
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 09                	js     802119 <ipc_recv+0x52>
  802110:	8b 15 20 60 80 00    	mov    0x806020,%edx
  802116:	8b 52 78             	mov    0x78(%edx),%edx
  802119:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80211b:	85 c0                	test   %eax,%eax
  80211d:	78 08                	js     802127 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80211f:	a1 20 60 80 00       	mov    0x806020,%eax
  802124:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212a:	5b                   	pop    %ebx
  80212b:	5e                   	pop    %esi
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	57                   	push   %edi
  802132:	56                   	push   %esi
  802133:	53                   	push   %ebx
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	8b 7d 08             	mov    0x8(%ebp),%edi
  80213a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80213d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802140:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802142:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802147:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80214a:	ff 75 14             	pushl  0x14(%ebp)
  80214d:	53                   	push   %ebx
  80214e:	56                   	push   %esi
  80214f:	57                   	push   %edi
  802150:	e8 ba ec ff ff       	call   800e0f <sys_ipc_try_send>
		if (ret == 0)
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	74 1e                	je     80217a <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80215c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80215f:	75 07                	jne    802168 <ipc_send+0x3a>
			sys_yield();
  802161:	e8 fd ea ff ff       	call   800c63 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802166:	eb e2                	jmp    80214a <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802168:	50                   	push   %eax
  802169:	68 17 29 80 00       	push   $0x802917
  80216e:	6a 3d                	push   $0x3d
  802170:	68 2b 29 80 00       	push   $0x80292b
  802175:	e8 15 e0 ff ff       	call   80018f <_panic>
	}
	// panic("ipc_send not implemented");
}
  80217a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5f                   	pop    %edi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    

00802182 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802188:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80218d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802190:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802196:	8b 52 50             	mov    0x50(%edx),%edx
  802199:	39 ca                	cmp    %ecx,%edx
  80219b:	74 11                	je     8021ae <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80219d:	83 c0 01             	add    $0x1,%eax
  8021a0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021a5:	75 e6                	jne    80218d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ac:	eb 0b                	jmp    8021b9 <ipc_find_env+0x37>
			return envs[i].env_id;
  8021ae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8021b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8021b6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8021b9:	5d                   	pop    %ebp
  8021ba:	c3                   	ret    

008021bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8021c1:	89 d0                	mov    %edx,%eax
  8021c3:	c1 e8 16             	shr    $0x16,%eax
  8021c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8021cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8021d2:	f6 c1 01             	test   $0x1,%cl
  8021d5:	74 1d                	je     8021f4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8021d7:	c1 ea 0c             	shr    $0xc,%edx
  8021da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8021e1:	f6 c2 01             	test   $0x1,%dl
  8021e4:	74 0e                	je     8021f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8021e6:	c1 ea 0c             	shr    $0xc,%edx
  8021e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8021f0:	ef 
  8021f1:	0f b7 c0             	movzwl %ax,%eax
}
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    
  8021f6:	66 90                	xchg   %ax,%ax
  8021f8:	66 90                	xchg   %ax,%ax
  8021fa:	66 90                	xchg   %ax,%ax
  8021fc:	66 90                	xchg   %ax,%ax
  8021fe:	66 90                	xchg   %ax,%ax

00802200 <__udivdi3>:
  802200:	55                   	push   %ebp
  802201:	57                   	push   %edi
  802202:	56                   	push   %esi
  802203:	53                   	push   %ebx
  802204:	83 ec 1c             	sub    $0x1c,%esp
  802207:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80220b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80220f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802213:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802217:	85 d2                	test   %edx,%edx
  802219:	75 35                	jne    802250 <__udivdi3+0x50>
  80221b:	39 f3                	cmp    %esi,%ebx
  80221d:	0f 87 bd 00 00 00    	ja     8022e0 <__udivdi3+0xe0>
  802223:	85 db                	test   %ebx,%ebx
  802225:	89 d9                	mov    %ebx,%ecx
  802227:	75 0b                	jne    802234 <__udivdi3+0x34>
  802229:	b8 01 00 00 00       	mov    $0x1,%eax
  80222e:	31 d2                	xor    %edx,%edx
  802230:	f7 f3                	div    %ebx
  802232:	89 c1                	mov    %eax,%ecx
  802234:	31 d2                	xor    %edx,%edx
  802236:	89 f0                	mov    %esi,%eax
  802238:	f7 f1                	div    %ecx
  80223a:	89 c6                	mov    %eax,%esi
  80223c:	89 e8                	mov    %ebp,%eax
  80223e:	89 f7                	mov    %esi,%edi
  802240:	f7 f1                	div    %ecx
  802242:	89 fa                	mov    %edi,%edx
  802244:	83 c4 1c             	add    $0x1c,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5f                   	pop    %edi
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    
  80224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802250:	39 f2                	cmp    %esi,%edx
  802252:	77 7c                	ja     8022d0 <__udivdi3+0xd0>
  802254:	0f bd fa             	bsr    %edx,%edi
  802257:	83 f7 1f             	xor    $0x1f,%edi
  80225a:	0f 84 98 00 00 00    	je     8022f8 <__udivdi3+0xf8>
  802260:	89 f9                	mov    %edi,%ecx
  802262:	b8 20 00 00 00       	mov    $0x20,%eax
  802267:	29 f8                	sub    %edi,%eax
  802269:	d3 e2                	shl    %cl,%edx
  80226b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226f:	89 c1                	mov    %eax,%ecx
  802271:	89 da                	mov    %ebx,%edx
  802273:	d3 ea                	shr    %cl,%edx
  802275:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802279:	09 d1                	or     %edx,%ecx
  80227b:	89 f2                	mov    %esi,%edx
  80227d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802281:	89 f9                	mov    %edi,%ecx
  802283:	d3 e3                	shl    %cl,%ebx
  802285:	89 c1                	mov    %eax,%ecx
  802287:	d3 ea                	shr    %cl,%edx
  802289:	89 f9                	mov    %edi,%ecx
  80228b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80228f:	d3 e6                	shl    %cl,%esi
  802291:	89 eb                	mov    %ebp,%ebx
  802293:	89 c1                	mov    %eax,%ecx
  802295:	d3 eb                	shr    %cl,%ebx
  802297:	09 de                	or     %ebx,%esi
  802299:	89 f0                	mov    %esi,%eax
  80229b:	f7 74 24 08          	divl   0x8(%esp)
  80229f:	89 d6                	mov    %edx,%esi
  8022a1:	89 c3                	mov    %eax,%ebx
  8022a3:	f7 64 24 0c          	mull   0xc(%esp)
  8022a7:	39 d6                	cmp    %edx,%esi
  8022a9:	72 0c                	jb     8022b7 <__udivdi3+0xb7>
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e5                	shl    %cl,%ebp
  8022af:	39 c5                	cmp    %eax,%ebp
  8022b1:	73 5d                	jae    802310 <__udivdi3+0x110>
  8022b3:	39 d6                	cmp    %edx,%esi
  8022b5:	75 59                	jne    802310 <__udivdi3+0x110>
  8022b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022ba:	31 ff                	xor    %edi,%edi
  8022bc:	89 fa                	mov    %edi,%edx
  8022be:	83 c4 1c             	add    $0x1c,%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5f                   	pop    %edi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    
  8022c6:	8d 76 00             	lea    0x0(%esi),%esi
  8022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8022d0:	31 ff                	xor    %edi,%edi
  8022d2:	31 c0                	xor    %eax,%eax
  8022d4:	89 fa                	mov    %edi,%edx
  8022d6:	83 c4 1c             	add    $0x1c,%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5e                   	pop    %esi
  8022db:	5f                   	pop    %edi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    
  8022de:	66 90                	xchg   %ax,%ax
  8022e0:	31 ff                	xor    %edi,%edi
  8022e2:	89 e8                	mov    %ebp,%eax
  8022e4:	89 f2                	mov    %esi,%edx
  8022e6:	f7 f3                	div    %ebx
  8022e8:	89 fa                	mov    %edi,%edx
  8022ea:	83 c4 1c             	add    $0x1c,%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5e                   	pop    %esi
  8022ef:	5f                   	pop    %edi
  8022f0:	5d                   	pop    %ebp
  8022f1:	c3                   	ret    
  8022f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8022f8:	39 f2                	cmp    %esi,%edx
  8022fa:	72 06                	jb     802302 <__udivdi3+0x102>
  8022fc:	31 c0                	xor    %eax,%eax
  8022fe:	39 eb                	cmp    %ebp,%ebx
  802300:	77 d2                	ja     8022d4 <__udivdi3+0xd4>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	eb cb                	jmp    8022d4 <__udivdi3+0xd4>
  802309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802310:	89 d8                	mov    %ebx,%eax
  802312:	31 ff                	xor    %edi,%edi
  802314:	eb be                	jmp    8022d4 <__udivdi3+0xd4>
  802316:	66 90                	xchg   %ax,%ax
  802318:	66 90                	xchg   %ax,%ax
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <__umoddi3>:
  802320:	55                   	push   %ebp
  802321:	57                   	push   %edi
  802322:	56                   	push   %esi
  802323:	53                   	push   %ebx
  802324:	83 ec 1c             	sub    $0x1c,%esp
  802327:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80232b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80232f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802337:	85 ed                	test   %ebp,%ebp
  802339:	89 f0                	mov    %esi,%eax
  80233b:	89 da                	mov    %ebx,%edx
  80233d:	75 19                	jne    802358 <__umoddi3+0x38>
  80233f:	39 df                	cmp    %ebx,%edi
  802341:	0f 86 b1 00 00 00    	jbe    8023f8 <__umoddi3+0xd8>
  802347:	f7 f7                	div    %edi
  802349:	89 d0                	mov    %edx,%eax
  80234b:	31 d2                	xor    %edx,%edx
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    
  802355:	8d 76 00             	lea    0x0(%esi),%esi
  802358:	39 dd                	cmp    %ebx,%ebp
  80235a:	77 f1                	ja     80234d <__umoddi3+0x2d>
  80235c:	0f bd cd             	bsr    %ebp,%ecx
  80235f:	83 f1 1f             	xor    $0x1f,%ecx
  802362:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802366:	0f 84 b4 00 00 00    	je     802420 <__umoddi3+0x100>
  80236c:	b8 20 00 00 00       	mov    $0x20,%eax
  802371:	89 c2                	mov    %eax,%edx
  802373:	8b 44 24 04          	mov    0x4(%esp),%eax
  802377:	29 c2                	sub    %eax,%edx
  802379:	89 c1                	mov    %eax,%ecx
  80237b:	89 f8                	mov    %edi,%eax
  80237d:	d3 e5                	shl    %cl,%ebp
  80237f:	89 d1                	mov    %edx,%ecx
  802381:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802385:	d3 e8                	shr    %cl,%eax
  802387:	09 c5                	or     %eax,%ebp
  802389:	8b 44 24 04          	mov    0x4(%esp),%eax
  80238d:	89 c1                	mov    %eax,%ecx
  80238f:	d3 e7                	shl    %cl,%edi
  802391:	89 d1                	mov    %edx,%ecx
  802393:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802397:	89 df                	mov    %ebx,%edi
  802399:	d3 ef                	shr    %cl,%edi
  80239b:	89 c1                	mov    %eax,%ecx
  80239d:	89 f0                	mov    %esi,%eax
  80239f:	d3 e3                	shl    %cl,%ebx
  8023a1:	89 d1                	mov    %edx,%ecx
  8023a3:	89 fa                	mov    %edi,%edx
  8023a5:	d3 e8                	shr    %cl,%eax
  8023a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023ac:	09 d8                	or     %ebx,%eax
  8023ae:	f7 f5                	div    %ebp
  8023b0:	d3 e6                	shl    %cl,%esi
  8023b2:	89 d1                	mov    %edx,%ecx
  8023b4:	f7 64 24 08          	mull   0x8(%esp)
  8023b8:	39 d1                	cmp    %edx,%ecx
  8023ba:	89 c3                	mov    %eax,%ebx
  8023bc:	89 d7                	mov    %edx,%edi
  8023be:	72 06                	jb     8023c6 <__umoddi3+0xa6>
  8023c0:	75 0e                	jne    8023d0 <__umoddi3+0xb0>
  8023c2:	39 c6                	cmp    %eax,%esi
  8023c4:	73 0a                	jae    8023d0 <__umoddi3+0xb0>
  8023c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8023ca:	19 ea                	sbb    %ebp,%edx
  8023cc:	89 d7                	mov    %edx,%edi
  8023ce:	89 c3                	mov    %eax,%ebx
  8023d0:	89 ca                	mov    %ecx,%edx
  8023d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8023d7:	29 de                	sub    %ebx,%esi
  8023d9:	19 fa                	sbb    %edi,%edx
  8023db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8023df:	89 d0                	mov    %edx,%eax
  8023e1:	d3 e0                	shl    %cl,%eax
  8023e3:	89 d9                	mov    %ebx,%ecx
  8023e5:	d3 ee                	shr    %cl,%esi
  8023e7:	d3 ea                	shr    %cl,%edx
  8023e9:	09 f0                	or     %esi,%eax
  8023eb:	83 c4 1c             	add    $0x1c,%esp
  8023ee:	5b                   	pop    %ebx
  8023ef:	5e                   	pop    %esi
  8023f0:	5f                   	pop    %edi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    
  8023f3:	90                   	nop
  8023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	85 ff                	test   %edi,%edi
  8023fa:	89 f9                	mov    %edi,%ecx
  8023fc:	75 0b                	jne    802409 <__umoddi3+0xe9>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f7                	div    %edi
  802407:	89 c1                	mov    %eax,%ecx
  802409:	89 d8                	mov    %ebx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f1                	div    %ecx
  80240f:	89 f0                	mov    %esi,%eax
  802411:	f7 f1                	div    %ecx
  802413:	e9 31 ff ff ff       	jmp    802349 <__umoddi3+0x29>
  802418:	90                   	nop
  802419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802420:	39 dd                	cmp    %ebx,%ebp
  802422:	72 08                	jb     80242c <__umoddi3+0x10c>
  802424:	39 f7                	cmp    %esi,%edi
  802426:	0f 87 21 ff ff ff    	ja     80234d <__umoddi3+0x2d>
  80242c:	89 da                	mov    %ebx,%edx
  80242e:	89 f0                	mov    %esi,%eax
  802430:	29 f8                	sub    %edi,%eax
  802432:	19 ea                	sbb    %ebp,%edx
  802434:	e9 14 ff ff ff       	jmp    80234d <__umoddi3+0x2d>

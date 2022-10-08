
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 e0 25 80 00       	push   $0x8025e0
  80003f:	e8 66 01 00 00       	call   8001aa <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 62 0e 00 00       	call   800eab <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 58 26 80 00       	push   $0x802658
  800058:	e8 4d 01 00 00       	call   8001aa <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 08 26 80 00       	push   $0x802608
  80006c:	e8 39 01 00 00       	call   8001aa <cprintf>
	sys_yield();
  800071:	e8 2d 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  800076:	e8 28 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  80007b:	e8 23 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  800080:	e8 1e 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  800085:	e8 19 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  80008a:	e8 14 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  80008f:	e8 0f 0b 00 00       	call   800ba3 <sys_yield>
	sys_yield();
  800094:	e8 0a 0b 00 00       	call   800ba3 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 30 26 80 00 	movl   $0x802630,(%esp)
  8000a0:	e8 05 01 00 00       	call   8001aa <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 96 0a 00 00       	call   800b43 <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 bf 0a 00 00       	call   800b84 <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 47 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 40 11 00 00       	call   801246 <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 33 0a 00 00       	call   800b43 <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	53                   	push   %ebx
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80011f:	8b 13                	mov    (%ebx),%edx
  800121:	8d 42 01             	lea    0x1(%edx),%eax
  800124:	89 03                	mov    %eax,(%ebx)
  800126:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800129:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800132:	74 09                	je     80013d <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800134:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800138:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 ff 00 00 00       	push   $0xff
  800145:	8d 43 08             	lea    0x8(%ebx),%eax
  800148:	50                   	push   %eax
  800149:	e8 b8 09 00 00       	call   800b06 <sys_cputs>
		b->idx = 0;
  80014e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	eb db                	jmp    800134 <putch+0x1f>

00800159 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800162:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800169:	00 00 00 
	b.cnt = 0;
  80016c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800173:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800176:	ff 75 0c             	pushl  0xc(%ebp)
  800179:	ff 75 08             	pushl  0x8(%ebp)
  80017c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800182:	50                   	push   %eax
  800183:	68 15 01 80 00       	push   $0x800115
  800188:	e8 1a 01 00 00       	call   8002a7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018d:	83 c4 08             	add    $0x8,%esp
  800190:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	50                   	push   %eax
  80019d:	e8 64 09 00 00       	call   800b06 <sys_cputs>

	return b.cnt;
}
  8001a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b3:	50                   	push   %eax
  8001b4:	ff 75 08             	pushl  0x8(%ebp)
  8001b7:	e8 9d ff ff ff       	call   800159 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    

008001be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	57                   	push   %edi
  8001c2:	56                   	push   %esi
  8001c3:	53                   	push   %ebx
  8001c4:	83 ec 1c             	sub    $0x1c,%esp
  8001c7:	89 c7                	mov    %eax,%edi
  8001c9:	89 d6                	mov    %edx,%esi
  8001cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001df:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e5:	39 d3                	cmp    %edx,%ebx
  8001e7:	72 05                	jb     8001ee <printnum+0x30>
  8001e9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001ec:	77 7a                	ja     800268 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	ff 75 18             	pushl  0x18(%ebp)
  8001f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001fa:	53                   	push   %ebx
  8001fb:	ff 75 10             	pushl  0x10(%ebp)
  8001fe:	83 ec 08             	sub    $0x8,%esp
  800201:	ff 75 e4             	pushl  -0x1c(%ebp)
  800204:	ff 75 e0             	pushl  -0x20(%ebp)
  800207:	ff 75 dc             	pushl  -0x24(%ebp)
  80020a:	ff 75 d8             	pushl  -0x28(%ebp)
  80020d:	e8 7e 21 00 00       	call   802390 <__udivdi3>
  800212:	83 c4 18             	add    $0x18,%esp
  800215:	52                   	push   %edx
  800216:	50                   	push   %eax
  800217:	89 f2                	mov    %esi,%edx
  800219:	89 f8                	mov    %edi,%eax
  80021b:	e8 9e ff ff ff       	call   8001be <printnum>
  800220:	83 c4 20             	add    $0x20,%esp
  800223:	eb 13                	jmp    800238 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	56                   	push   %esi
  800229:	ff 75 18             	pushl  0x18(%ebp)
  80022c:	ff d7                	call   *%edi
  80022e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800231:	83 eb 01             	sub    $0x1,%ebx
  800234:	85 db                	test   %ebx,%ebx
  800236:	7f ed                	jg     800225 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800238:	83 ec 08             	sub    $0x8,%esp
  80023b:	56                   	push   %esi
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800242:	ff 75 e0             	pushl  -0x20(%ebp)
  800245:	ff 75 dc             	pushl  -0x24(%ebp)
  800248:	ff 75 d8             	pushl  -0x28(%ebp)
  80024b:	e8 60 22 00 00       	call   8024b0 <__umoddi3>
  800250:	83 c4 14             	add    $0x14,%esp
  800253:	0f be 80 80 26 80 00 	movsbl 0x802680(%eax),%eax
  80025a:	50                   	push   %eax
  80025b:	ff d7                	call   *%edi
}
  80025d:	83 c4 10             	add    $0x10,%esp
  800260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800263:	5b                   	pop    %ebx
  800264:	5e                   	pop    %esi
  800265:	5f                   	pop    %edi
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    
  800268:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026b:	eb c4                	jmp    800231 <printnum+0x73>

0080026d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800273:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800277:	8b 10                	mov    (%eax),%edx
  800279:	3b 50 04             	cmp    0x4(%eax),%edx
  80027c:	73 0a                	jae    800288 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800281:	89 08                	mov    %ecx,(%eax)
  800283:	8b 45 08             	mov    0x8(%ebp),%eax
  800286:	88 02                	mov    %al,(%edx)
}
  800288:	5d                   	pop    %ebp
  800289:	c3                   	ret    

0080028a <printfmt>:
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800290:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800293:	50                   	push   %eax
  800294:	ff 75 10             	pushl  0x10(%ebp)
  800297:	ff 75 0c             	pushl  0xc(%ebp)
  80029a:	ff 75 08             	pushl  0x8(%ebp)
  80029d:	e8 05 00 00 00       	call   8002a7 <vprintfmt>
}
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <vprintfmt>:
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 2c             	sub    $0x2c,%esp
  8002b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b9:	e9 c1 03 00 00       	jmp    80067f <vprintfmt+0x3d8>
		padc = ' ';
  8002be:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002c2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002c9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002d0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002d7:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002dc:	8d 47 01             	lea    0x1(%edi),%eax
  8002df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e2:	0f b6 17             	movzbl (%edi),%edx
  8002e5:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e8:	3c 55                	cmp    $0x55,%al
  8002ea:	0f 87 12 04 00 00    	ja     800702 <vprintfmt+0x45b>
  8002f0:	0f b6 c0             	movzbl %al,%eax
  8002f3:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002fd:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800301:	eb d9                	jmp    8002dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800306:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030a:	eb d0                	jmp    8002dc <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	0f b6 d2             	movzbl %dl,%edx
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800312:	b8 00 00 00 00       	mov    $0x0,%eax
  800317:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800321:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800324:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800327:	83 f9 09             	cmp    $0x9,%ecx
  80032a:	77 55                	ja     800381 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80032c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032f:	eb e9                	jmp    80031a <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800331:	8b 45 14             	mov    0x14(%ebp),%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800339:	8b 45 14             	mov    0x14(%ebp),%eax
  80033c:	8d 40 04             	lea    0x4(%eax),%eax
  80033f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800342:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800349:	79 91                	jns    8002dc <vprintfmt+0x35>
				width = precision, precision = -1;
  80034b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80034e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800351:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800358:	eb 82                	jmp    8002dc <vprintfmt+0x35>
  80035a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80035d:	85 c0                	test   %eax,%eax
  80035f:	ba 00 00 00 00       	mov    $0x0,%edx
  800364:	0f 49 d0             	cmovns %eax,%edx
  800367:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80036d:	e9 6a ff ff ff       	jmp    8002dc <vprintfmt+0x35>
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800375:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80037c:	e9 5b ff ff ff       	jmp    8002dc <vprintfmt+0x35>
  800381:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	eb bc                	jmp    800345 <vprintfmt+0x9e>
			lflag++;
  800389:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038f:	e9 48 ff ff ff       	jmp    8002dc <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800394:	8b 45 14             	mov    0x14(%ebp),%eax
  800397:	8d 78 04             	lea    0x4(%eax),%edi
  80039a:	83 ec 08             	sub    $0x8,%esp
  80039d:	53                   	push   %ebx
  80039e:	ff 30                	pushl  (%eax)
  8003a0:	ff d6                	call   *%esi
			break;
  8003a2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a8:	e9 cf 02 00 00       	jmp    80067c <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b0:	8d 78 04             	lea    0x4(%eax),%edi
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	99                   	cltd   
  8003b6:	31 d0                	xor    %edx,%eax
  8003b8:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003ba:	83 f8 0f             	cmp    $0xf,%eax
  8003bd:	7f 23                	jg     8003e2 <vprintfmt+0x13b>
  8003bf:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  8003c6:	85 d2                	test   %edx,%edx
  8003c8:	74 18                	je     8003e2 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003ca:	52                   	push   %edx
  8003cb:	68 41 2b 80 00       	push   $0x802b41
  8003d0:	53                   	push   %ebx
  8003d1:	56                   	push   %esi
  8003d2:	e8 b3 fe ff ff       	call   80028a <printfmt>
  8003d7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003da:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003dd:	e9 9a 02 00 00       	jmp    80067c <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003e2:	50                   	push   %eax
  8003e3:	68 98 26 80 00       	push   $0x802698
  8003e8:	53                   	push   %ebx
  8003e9:	56                   	push   %esi
  8003ea:	e8 9b fe ff ff       	call   80028a <printfmt>
  8003ef:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f5:	e9 82 02 00 00       	jmp    80067c <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800408:	85 ff                	test   %edi,%edi
  80040a:	b8 91 26 80 00       	mov    $0x802691,%eax
  80040f:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800412:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800416:	0f 8e bd 00 00 00    	jle    8004d9 <vprintfmt+0x232>
  80041c:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800420:	75 0e                	jne    800430 <vprintfmt+0x189>
  800422:	89 75 08             	mov    %esi,0x8(%ebp)
  800425:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800428:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80042e:	eb 6d                	jmp    80049d <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800430:	83 ec 08             	sub    $0x8,%esp
  800433:	ff 75 d0             	pushl  -0x30(%ebp)
  800436:	57                   	push   %edi
  800437:	e8 6e 03 00 00       	call   8007aa <strnlen>
  80043c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80043f:	29 c1                	sub    %eax,%ecx
  800441:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800444:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800447:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80044b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80044e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800451:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800453:	eb 0f                	jmp    800464 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	53                   	push   %ebx
  800459:	ff 75 e0             	pushl  -0x20(%ebp)
  80045c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ef 01             	sub    $0x1,%edi
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	85 ff                	test   %edi,%edi
  800466:	7f ed                	jg     800455 <vprintfmt+0x1ae>
  800468:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80046b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80046e:	85 c9                	test   %ecx,%ecx
  800470:	b8 00 00 00 00       	mov    $0x0,%eax
  800475:	0f 49 c1             	cmovns %ecx,%eax
  800478:	29 c1                	sub    %eax,%ecx
  80047a:	89 75 08             	mov    %esi,0x8(%ebp)
  80047d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800480:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800483:	89 cb                	mov    %ecx,%ebx
  800485:	eb 16                	jmp    80049d <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800487:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80048b:	75 31                	jne    8004be <vprintfmt+0x217>
					putch(ch, putdat);
  80048d:	83 ec 08             	sub    $0x8,%esp
  800490:	ff 75 0c             	pushl  0xc(%ebp)
  800493:	50                   	push   %eax
  800494:	ff 55 08             	call   *0x8(%ebp)
  800497:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80049a:	83 eb 01             	sub    $0x1,%ebx
  80049d:	83 c7 01             	add    $0x1,%edi
  8004a0:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004a4:	0f be c2             	movsbl %dl,%eax
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	74 59                	je     800504 <vprintfmt+0x25d>
  8004ab:	85 f6                	test   %esi,%esi
  8004ad:	78 d8                	js     800487 <vprintfmt+0x1e0>
  8004af:	83 ee 01             	sub    $0x1,%esi
  8004b2:	79 d3                	jns    800487 <vprintfmt+0x1e0>
  8004b4:	89 df                	mov    %ebx,%edi
  8004b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004bc:	eb 37                	jmp    8004f5 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004be:	0f be d2             	movsbl %dl,%edx
  8004c1:	83 ea 20             	sub    $0x20,%edx
  8004c4:	83 fa 5e             	cmp    $0x5e,%edx
  8004c7:	76 c4                	jbe    80048d <vprintfmt+0x1e6>
					putch('?', putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	6a 3f                	push   $0x3f
  8004d1:	ff 55 08             	call   *0x8(%ebp)
  8004d4:	83 c4 10             	add    $0x10,%esp
  8004d7:	eb c1                	jmp    80049a <vprintfmt+0x1f3>
  8004d9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004dc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004df:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e5:	eb b6                	jmp    80049d <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	6a 20                	push   $0x20
  8004ed:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ef:	83 ef 01             	sub    $0x1,%edi
  8004f2:	83 c4 10             	add    $0x10,%esp
  8004f5:	85 ff                	test   %edi,%edi
  8004f7:	7f ee                	jg     8004e7 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ff:	e9 78 01 00 00       	jmp    80067c <vprintfmt+0x3d5>
  800504:	89 df                	mov    %ebx,%edi
  800506:	8b 75 08             	mov    0x8(%ebp),%esi
  800509:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050c:	eb e7                	jmp    8004f5 <vprintfmt+0x24e>
	if (lflag >= 2)
  80050e:	83 f9 01             	cmp    $0x1,%ecx
  800511:	7e 3f                	jle    800552 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	8b 50 04             	mov    0x4(%eax),%edx
  800519:	8b 00                	mov    (%eax),%eax
  80051b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 40 08             	lea    0x8(%eax),%eax
  800527:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80052a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80052e:	79 5c                	jns    80058c <vprintfmt+0x2e5>
				putch('-', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 2d                	push   $0x2d
  800536:	ff d6                	call   *%esi
				num = -(long long) num;
  800538:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80053e:	f7 da                	neg    %edx
  800540:	83 d1 00             	adc    $0x0,%ecx
  800543:	f7 d9                	neg    %ecx
  800545:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800548:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054d:	e9 10 01 00 00       	jmp    800662 <vprintfmt+0x3bb>
	else if (lflag)
  800552:	85 c9                	test   %ecx,%ecx
  800554:	75 1b                	jne    800571 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055e:	89 c1                	mov    %eax,%ecx
  800560:	c1 f9 1f             	sar    $0x1f,%ecx
  800563:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
  80056f:	eb b9                	jmp    80052a <vprintfmt+0x283>
		return va_arg(*ap, long);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 00                	mov    (%eax),%eax
  800576:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800579:	89 c1                	mov    %eax,%ecx
  80057b:	c1 f9 1f             	sar    $0x1f,%ecx
  80057e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 40 04             	lea    0x4(%eax),%eax
  800587:	89 45 14             	mov    %eax,0x14(%ebp)
  80058a:	eb 9e                	jmp    80052a <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80058c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800592:	b8 0a 00 00 00       	mov    $0xa,%eax
  800597:	e9 c6 00 00 00       	jmp    800662 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80059c:	83 f9 01             	cmp    $0x1,%ecx
  80059f:	7e 18                	jle    8005b9 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8b 10                	mov    (%eax),%edx
  8005a6:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b4:	e9 a9 00 00 00       	jmp    800662 <vprintfmt+0x3bb>
	else if (lflag)
  8005b9:	85 c9                	test   %ecx,%ecx
  8005bb:	75 1a                	jne    8005d7 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 10                	mov    (%eax),%edx
  8005c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d2:	e9 8b 00 00 00       	jmp    800662 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 10                	mov    (%eax),%edx
  8005dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ec:	eb 74                	jmp    800662 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005ee:	83 f9 01             	cmp    $0x1,%ecx
  8005f1:	7e 15                	jle    800608 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	8b 48 04             	mov    0x4(%eax),%ecx
  8005fb:	8d 40 08             	lea    0x8(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800601:	b8 08 00 00 00       	mov    $0x8,%eax
  800606:	eb 5a                	jmp    800662 <vprintfmt+0x3bb>
	else if (lflag)
  800608:	85 c9                	test   %ecx,%ecx
  80060a:	75 17                	jne    800623 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80060c:	8b 45 14             	mov    0x14(%ebp),%eax
  80060f:	8b 10                	mov    (%eax),%edx
  800611:	b9 00 00 00 00       	mov    $0x0,%ecx
  800616:	8d 40 04             	lea    0x4(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80061c:	b8 08 00 00 00       	mov    $0x8,%eax
  800621:	eb 3f                	jmp    800662 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8b 10                	mov    (%eax),%edx
  800628:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062d:	8d 40 04             	lea    0x4(%eax),%eax
  800630:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800633:	b8 08 00 00 00       	mov    $0x8,%eax
  800638:	eb 28                	jmp    800662 <vprintfmt+0x3bb>
			putch('0', putdat);
  80063a:	83 ec 08             	sub    $0x8,%esp
  80063d:	53                   	push   %ebx
  80063e:	6a 30                	push   $0x30
  800640:	ff d6                	call   *%esi
			putch('x', putdat);
  800642:	83 c4 08             	add    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	6a 78                	push   $0x78
  800648:	ff d6                	call   *%esi
			num = (unsigned long long)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	8b 10                	mov    (%eax),%edx
  80064f:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800654:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800657:	8d 40 04             	lea    0x4(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800662:	83 ec 0c             	sub    $0xc,%esp
  800665:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800669:	57                   	push   %edi
  80066a:	ff 75 e0             	pushl  -0x20(%ebp)
  80066d:	50                   	push   %eax
  80066e:	51                   	push   %ecx
  80066f:	52                   	push   %edx
  800670:	89 da                	mov    %ebx,%edx
  800672:	89 f0                	mov    %esi,%eax
  800674:	e8 45 fb ff ff       	call   8001be <printnum>
			break;
  800679:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80067c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80067f:	83 c7 01             	add    $0x1,%edi
  800682:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800686:	83 f8 25             	cmp    $0x25,%eax
  800689:	0f 84 2f fc ff ff    	je     8002be <vprintfmt+0x17>
			if (ch == '\0')
  80068f:	85 c0                	test   %eax,%eax
  800691:	0f 84 8b 00 00 00    	je     800722 <vprintfmt+0x47b>
			putch(ch, putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	53                   	push   %ebx
  80069b:	50                   	push   %eax
  80069c:	ff d6                	call   *%esi
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	eb dc                	jmp    80067f <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006a3:	83 f9 01             	cmp    $0x1,%ecx
  8006a6:	7e 15                	jle    8006bd <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8b 10                	mov    (%eax),%edx
  8006ad:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b0:	8d 40 08             	lea    0x8(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bb:	eb a5                	jmp    800662 <vprintfmt+0x3bb>
	else if (lflag)
  8006bd:	85 c9                	test   %ecx,%ecx
  8006bf:	75 17                	jne    8006d8 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 10                	mov    (%eax),%edx
  8006c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d6:	eb 8a                	jmp    800662 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8b 10                	mov    (%eax),%edx
  8006dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ed:	e9 70 ff ff ff       	jmp    800662 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006f2:	83 ec 08             	sub    $0x8,%esp
  8006f5:	53                   	push   %ebx
  8006f6:	6a 25                	push   $0x25
  8006f8:	ff d6                	call   *%esi
			break;
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	e9 7a ff ff ff       	jmp    80067c <vprintfmt+0x3d5>
			putch('%', putdat);
  800702:	83 ec 08             	sub    $0x8,%esp
  800705:	53                   	push   %ebx
  800706:	6a 25                	push   $0x25
  800708:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80070a:	83 c4 10             	add    $0x10,%esp
  80070d:	89 f8                	mov    %edi,%eax
  80070f:	eb 03                	jmp    800714 <vprintfmt+0x46d>
  800711:	83 e8 01             	sub    $0x1,%eax
  800714:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800718:	75 f7                	jne    800711 <vprintfmt+0x46a>
  80071a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071d:	e9 5a ff ff ff       	jmp    80067c <vprintfmt+0x3d5>
}
  800722:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800725:	5b                   	pop    %ebx
  800726:	5e                   	pop    %esi
  800727:	5f                   	pop    %edi
  800728:	5d                   	pop    %ebp
  800729:	c3                   	ret    

0080072a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 18             	sub    $0x18,%esp
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800736:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800739:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80073d:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800740:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800747:	85 c0                	test   %eax,%eax
  800749:	74 26                	je     800771 <vsnprintf+0x47>
  80074b:	85 d2                	test   %edx,%edx
  80074d:	7e 22                	jle    800771 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80074f:	ff 75 14             	pushl  0x14(%ebp)
  800752:	ff 75 10             	pushl  0x10(%ebp)
  800755:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800758:	50                   	push   %eax
  800759:	68 6d 02 80 00       	push   $0x80026d
  80075e:	e8 44 fb ff ff       	call   8002a7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800766:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	c9                   	leave  
  800770:	c3                   	ret    
		return -E_INVAL;
  800771:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800776:	eb f7                	jmp    80076f <vsnprintf+0x45>

00800778 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800781:	50                   	push   %eax
  800782:	ff 75 10             	pushl  0x10(%ebp)
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	ff 75 08             	pushl  0x8(%ebp)
  80078b:	e8 9a ff ff ff       	call   80072a <vsnprintf>
	va_end(ap);

	return rc;
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    

00800792 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800798:	b8 00 00 00 00       	mov    $0x0,%eax
  80079d:	eb 03                	jmp    8007a2 <strlen+0x10>
		n++;
  80079f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007a2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a6:	75 f7                	jne    80079f <strlen+0xd>
	return n;
}
  8007a8:	5d                   	pop    %ebp
  8007a9:	c3                   	ret    

008007aa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b8:	eb 03                	jmp    8007bd <strnlen+0x13>
		n++;
  8007ba:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bd:	39 d0                	cmp    %edx,%eax
  8007bf:	74 06                	je     8007c7 <strnlen+0x1d>
  8007c1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c5:	75 f3                	jne    8007ba <strnlen+0x10>
	return n;
}
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d3:	89 c2                	mov    %eax,%edx
  8007d5:	83 c1 01             	add    $0x1,%ecx
  8007d8:	83 c2 01             	add    $0x1,%edx
  8007db:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007df:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e2:	84 db                	test   %bl,%bl
  8007e4:	75 ef                	jne    8007d5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e6:	5b                   	pop    %ebx
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	53                   	push   %ebx
  8007ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f0:	53                   	push   %ebx
  8007f1:	e8 9c ff ff ff       	call   800792 <strlen>
  8007f6:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007f9:	ff 75 0c             	pushl  0xc(%ebp)
  8007fc:	01 d8                	add    %ebx,%eax
  8007fe:	50                   	push   %eax
  8007ff:	e8 c5 ff ff ff       	call   8007c9 <strcpy>
	return dst;
}
  800804:	89 d8                	mov    %ebx,%eax
  800806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	56                   	push   %esi
  80080f:	53                   	push   %ebx
  800810:	8b 75 08             	mov    0x8(%ebp),%esi
  800813:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800816:	89 f3                	mov    %esi,%ebx
  800818:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80081b:	89 f2                	mov    %esi,%edx
  80081d:	eb 0f                	jmp    80082e <strncpy+0x23>
		*dst++ = *src;
  80081f:	83 c2 01             	add    $0x1,%edx
  800822:	0f b6 01             	movzbl (%ecx),%eax
  800825:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800828:	80 39 01             	cmpb   $0x1,(%ecx)
  80082b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80082e:	39 da                	cmp    %ebx,%edx
  800830:	75 ed                	jne    80081f <strncpy+0x14>
	}
	return ret;
}
  800832:	89 f0                	mov    %esi,%eax
  800834:	5b                   	pop    %ebx
  800835:	5e                   	pop    %esi
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	56                   	push   %esi
  80083c:	53                   	push   %ebx
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
  800843:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800846:	89 f0                	mov    %esi,%eax
  800848:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80084c:	85 c9                	test   %ecx,%ecx
  80084e:	75 0b                	jne    80085b <strlcpy+0x23>
  800850:	eb 17                	jmp    800869 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800852:	83 c2 01             	add    $0x1,%edx
  800855:	83 c0 01             	add    $0x1,%eax
  800858:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80085b:	39 d8                	cmp    %ebx,%eax
  80085d:	74 07                	je     800866 <strlcpy+0x2e>
  80085f:	0f b6 0a             	movzbl (%edx),%ecx
  800862:	84 c9                	test   %cl,%cl
  800864:	75 ec                	jne    800852 <strlcpy+0x1a>
		*dst = '\0';
  800866:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800869:	29 f0                	sub    %esi,%eax
}
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800875:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800878:	eb 06                	jmp    800880 <strcmp+0x11>
		p++, q++;
  80087a:	83 c1 01             	add    $0x1,%ecx
  80087d:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800880:	0f b6 01             	movzbl (%ecx),%eax
  800883:	84 c0                	test   %al,%al
  800885:	74 04                	je     80088b <strcmp+0x1c>
  800887:	3a 02                	cmp    (%edx),%al
  800889:	74 ef                	je     80087a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80088b:	0f b6 c0             	movzbl %al,%eax
  80088e:	0f b6 12             	movzbl (%edx),%edx
  800891:	29 d0                	sub    %edx,%eax
}
  800893:	5d                   	pop    %ebp
  800894:	c3                   	ret    

00800895 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800895:	55                   	push   %ebp
  800896:	89 e5                	mov    %esp,%ebp
  800898:	53                   	push   %ebx
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089f:	89 c3                	mov    %eax,%ebx
  8008a1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a4:	eb 06                	jmp    8008ac <strncmp+0x17>
		n--, p++, q++;
  8008a6:	83 c0 01             	add    $0x1,%eax
  8008a9:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008ac:	39 d8                	cmp    %ebx,%eax
  8008ae:	74 16                	je     8008c6 <strncmp+0x31>
  8008b0:	0f b6 08             	movzbl (%eax),%ecx
  8008b3:	84 c9                	test   %cl,%cl
  8008b5:	74 04                	je     8008bb <strncmp+0x26>
  8008b7:	3a 0a                	cmp    (%edx),%cl
  8008b9:	74 eb                	je     8008a6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008bb:	0f b6 00             	movzbl (%eax),%eax
  8008be:	0f b6 12             	movzbl (%edx),%edx
  8008c1:	29 d0                	sub    %edx,%eax
}
  8008c3:	5b                   	pop    %ebx
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    
		return 0;
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	eb f6                	jmp    8008c3 <strncmp+0x2e>

008008cd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008cd:	55                   	push   %ebp
  8008ce:	89 e5                	mov    %esp,%ebp
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d7:	0f b6 10             	movzbl (%eax),%edx
  8008da:	84 d2                	test   %dl,%dl
  8008dc:	74 09                	je     8008e7 <strchr+0x1a>
		if (*s == c)
  8008de:	38 ca                	cmp    %cl,%dl
  8008e0:	74 0a                	je     8008ec <strchr+0x1f>
	for (; *s; s++)
  8008e2:	83 c0 01             	add    $0x1,%eax
  8008e5:	eb f0                	jmp    8008d7 <strchr+0xa>
			return (char *) s;
	return 0;
  8008e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f8:	eb 03                	jmp    8008fd <strfind+0xf>
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800900:	38 ca                	cmp    %cl,%dl
  800902:	74 04                	je     800908 <strfind+0x1a>
  800904:	84 d2                	test   %dl,%dl
  800906:	75 f2                	jne    8008fa <strfind+0xc>
			break;
	return (char *) s;
}
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	57                   	push   %edi
  80090e:	56                   	push   %esi
  80090f:	53                   	push   %ebx
  800910:	8b 7d 08             	mov    0x8(%ebp),%edi
  800913:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800916:	85 c9                	test   %ecx,%ecx
  800918:	74 13                	je     80092d <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091a:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800920:	75 05                	jne    800927 <memset+0x1d>
  800922:	f6 c1 03             	test   $0x3,%cl
  800925:	74 0d                	je     800934 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	fc                   	cld    
  80092b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092d:	89 f8                	mov    %edi,%eax
  80092f:	5b                   	pop    %ebx
  800930:	5e                   	pop    %esi
  800931:	5f                   	pop    %edi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    
		c &= 0xFF;
  800934:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800938:	89 d3                	mov    %edx,%ebx
  80093a:	c1 e3 08             	shl    $0x8,%ebx
  80093d:	89 d0                	mov    %edx,%eax
  80093f:	c1 e0 18             	shl    $0x18,%eax
  800942:	89 d6                	mov    %edx,%esi
  800944:	c1 e6 10             	shl    $0x10,%esi
  800947:	09 f0                	or     %esi,%eax
  800949:	09 c2                	or     %eax,%edx
  80094b:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80094d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800950:	89 d0                	mov    %edx,%eax
  800952:	fc                   	cld    
  800953:	f3 ab                	rep stos %eax,%es:(%edi)
  800955:	eb d6                	jmp    80092d <memset+0x23>

00800957 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	57                   	push   %edi
  80095b:	56                   	push   %esi
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800962:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800965:	39 c6                	cmp    %eax,%esi
  800967:	73 35                	jae    80099e <memmove+0x47>
  800969:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096c:	39 c2                	cmp    %eax,%edx
  80096e:	76 2e                	jbe    80099e <memmove+0x47>
		s += n;
		d += n;
  800970:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800973:	89 d6                	mov    %edx,%esi
  800975:	09 fe                	or     %edi,%esi
  800977:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80097d:	74 0c                	je     80098b <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80097f:	83 ef 01             	sub    $0x1,%edi
  800982:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800985:	fd                   	std    
  800986:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800988:	fc                   	cld    
  800989:	eb 21                	jmp    8009ac <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098b:	f6 c1 03             	test   $0x3,%cl
  80098e:	75 ef                	jne    80097f <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800990:	83 ef 04             	sub    $0x4,%edi
  800993:	8d 72 fc             	lea    -0x4(%edx),%esi
  800996:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800999:	fd                   	std    
  80099a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099c:	eb ea                	jmp    800988 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	89 f2                	mov    %esi,%edx
  8009a0:	09 c2                	or     %eax,%edx
  8009a2:	f6 c2 03             	test   $0x3,%dl
  8009a5:	74 09                	je     8009b0 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009a7:	89 c7                	mov    %eax,%edi
  8009a9:	fc                   	cld    
  8009aa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009ac:	5e                   	pop    %esi
  8009ad:	5f                   	pop    %edi
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b0:	f6 c1 03             	test   $0x3,%cl
  8009b3:	75 f2                	jne    8009a7 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b8:	89 c7                	mov    %eax,%edi
  8009ba:	fc                   	cld    
  8009bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bd:	eb ed                	jmp    8009ac <memmove+0x55>

008009bf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009c2:	ff 75 10             	pushl  0x10(%ebp)
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 08             	pushl  0x8(%ebp)
  8009cb:	e8 87 ff ff ff       	call   800957 <memmove>
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dd:	89 c6                	mov    %eax,%esi
  8009df:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e2:	39 f0                	cmp    %esi,%eax
  8009e4:	74 1c                	je     800a02 <memcmp+0x30>
		if (*s1 != *s2)
  8009e6:	0f b6 08             	movzbl (%eax),%ecx
  8009e9:	0f b6 1a             	movzbl (%edx),%ebx
  8009ec:	38 d9                	cmp    %bl,%cl
  8009ee:	75 08                	jne    8009f8 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009f0:	83 c0 01             	add    $0x1,%eax
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	eb ea                	jmp    8009e2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009f8:	0f b6 c1             	movzbl %cl,%eax
  8009fb:	0f b6 db             	movzbl %bl,%ebx
  8009fe:	29 d8                	sub    %ebx,%eax
  800a00:	eb 05                	jmp    800a07 <memcmp+0x35>
	}

	return 0;
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a07:	5b                   	pop    %ebx
  800a08:	5e                   	pop    %esi
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a14:	89 c2                	mov    %eax,%edx
  800a16:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 09                	jae    800a26 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a1d:	38 08                	cmp    %cl,(%eax)
  800a1f:	74 05                	je     800a26 <memfind+0x1b>
	for (; s < ends; s++)
  800a21:	83 c0 01             	add    $0x1,%eax
  800a24:	eb f3                	jmp    800a19 <memfind+0xe>
			break;
	return (void *) s;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	57                   	push   %edi
  800a2c:	56                   	push   %esi
  800a2d:	53                   	push   %ebx
  800a2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a34:	eb 03                	jmp    800a39 <strtol+0x11>
		s++;
  800a36:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a39:	0f b6 01             	movzbl (%ecx),%eax
  800a3c:	3c 20                	cmp    $0x20,%al
  800a3e:	74 f6                	je     800a36 <strtol+0xe>
  800a40:	3c 09                	cmp    $0x9,%al
  800a42:	74 f2                	je     800a36 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a44:	3c 2b                	cmp    $0x2b,%al
  800a46:	74 2e                	je     800a76 <strtol+0x4e>
	int neg = 0;
  800a48:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a4d:	3c 2d                	cmp    $0x2d,%al
  800a4f:	74 2f                	je     800a80 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a51:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a57:	75 05                	jne    800a5e <strtol+0x36>
  800a59:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5c:	74 2c                	je     800a8a <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a5e:	85 db                	test   %ebx,%ebx
  800a60:	75 0a                	jne    800a6c <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a62:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a67:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6a:	74 28                	je     800a94 <strtol+0x6c>
		base = 10;
  800a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a71:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a74:	eb 50                	jmp    800ac6 <strtol+0x9e>
		s++;
  800a76:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a79:	bf 00 00 00 00       	mov    $0x0,%edi
  800a7e:	eb d1                	jmp    800a51 <strtol+0x29>
		s++, neg = 1;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	bf 01 00 00 00       	mov    $0x1,%edi
  800a88:	eb c7                	jmp    800a51 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a8a:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a8e:	74 0e                	je     800a9e <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a90:	85 db                	test   %ebx,%ebx
  800a92:	75 d8                	jne    800a6c <strtol+0x44>
		s++, base = 8;
  800a94:	83 c1 01             	add    $0x1,%ecx
  800a97:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a9c:	eb ce                	jmp    800a6c <strtol+0x44>
		s += 2, base = 16;
  800a9e:	83 c1 02             	add    $0x2,%ecx
  800aa1:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aa6:	eb c4                	jmp    800a6c <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aa8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aab:	89 f3                	mov    %esi,%ebx
  800aad:	80 fb 19             	cmp    $0x19,%bl
  800ab0:	77 29                	ja     800adb <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ab2:	0f be d2             	movsbl %dl,%edx
  800ab5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ab8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800abb:	7d 30                	jge    800aed <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800abd:	83 c1 01             	add    $0x1,%ecx
  800ac0:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ac4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ac6:	0f b6 11             	movzbl (%ecx),%edx
  800ac9:	8d 72 d0             	lea    -0x30(%edx),%esi
  800acc:	89 f3                	mov    %esi,%ebx
  800ace:	80 fb 09             	cmp    $0x9,%bl
  800ad1:	77 d5                	ja     800aa8 <strtol+0x80>
			dig = *s - '0';
  800ad3:	0f be d2             	movsbl %dl,%edx
  800ad6:	83 ea 30             	sub    $0x30,%edx
  800ad9:	eb dd                	jmp    800ab8 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800adb:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ade:	89 f3                	mov    %esi,%ebx
  800ae0:	80 fb 19             	cmp    $0x19,%bl
  800ae3:	77 08                	ja     800aed <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ae5:	0f be d2             	movsbl %dl,%edx
  800ae8:	83 ea 37             	sub    $0x37,%edx
  800aeb:	eb cb                	jmp    800ab8 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af1:	74 05                	je     800af8 <strtol+0xd0>
		*endptr = (char *) s;
  800af3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af6:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800af8:	89 c2                	mov    %eax,%edx
  800afa:	f7 da                	neg    %edx
  800afc:	85 ff                	test   %edi,%edi
  800afe:	0f 45 c2             	cmovne %edx,%eax
}
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	8b 55 08             	mov    0x8(%ebp),%edx
  800b14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b17:	89 c3                	mov    %eax,%ebx
  800b19:	89 c7                	mov    %eax,%edi
  800b1b:	89 c6                	mov    %eax,%esi
  800b1d:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b1f:	5b                   	pop    %ebx
  800b20:	5e                   	pop    %esi
  800b21:	5f                   	pop    %edi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	57                   	push   %edi
  800b28:	56                   	push   %esi
  800b29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b34:	89 d1                	mov    %edx,%ecx
  800b36:	89 d3                	mov    %edx,%ebx
  800b38:	89 d7                	mov    %edx,%edi
  800b3a:	89 d6                	mov    %edx,%esi
  800b3c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b51:	8b 55 08             	mov    0x8(%ebp),%edx
  800b54:	b8 03 00 00 00       	mov    $0x3,%eax
  800b59:	89 cb                	mov    %ecx,%ebx
  800b5b:	89 cf                	mov    %ecx,%edi
  800b5d:	89 ce                	mov    %ecx,%esi
  800b5f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b61:	85 c0                	test   %eax,%eax
  800b63:	7f 08                	jg     800b6d <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5f                   	pop    %edi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b6d:	83 ec 0c             	sub    $0xc,%esp
  800b70:	50                   	push   %eax
  800b71:	6a 03                	push   $0x3
  800b73:	68 7f 29 80 00       	push   $0x80297f
  800b78:	6a 23                	push   $0x23
  800b7a:	68 9c 29 80 00       	push   $0x80299c
  800b7f:	e8 0c 16 00 00       	call   802190 <_panic>

00800b84 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 02 00 00 00       	mov    $0x2,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_yield>:

void
sys_yield(void)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bae:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bb3:	89 d1                	mov    %edx,%ecx
  800bb5:	89 d3                	mov    %edx,%ebx
  800bb7:	89 d7                	mov    %edx,%edi
  800bb9:	89 d6                	mov    %edx,%esi
  800bbb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5f                   	pop    %edi
  800bc0:	5d                   	pop    %ebp
  800bc1:	c3                   	ret    

00800bc2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	57                   	push   %edi
  800bc6:	56                   	push   %esi
  800bc7:	53                   	push   %ebx
  800bc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bcb:	be 00 00 00 00       	mov    $0x0,%esi
  800bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd6:	b8 04 00 00 00       	mov    $0x4,%eax
  800bdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bde:	89 f7                	mov    %esi,%edi
  800be0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800be2:	85 c0                	test   %eax,%eax
  800be4:	7f 08                	jg     800bee <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be9:	5b                   	pop    %ebx
  800bea:	5e                   	pop    %esi
  800beb:	5f                   	pop    %edi
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bee:	83 ec 0c             	sub    $0xc,%esp
  800bf1:	50                   	push   %eax
  800bf2:	6a 04                	push   $0x4
  800bf4:	68 7f 29 80 00       	push   $0x80297f
  800bf9:	6a 23                	push   $0x23
  800bfb:	68 9c 29 80 00       	push   $0x80299c
  800c00:	e8 8b 15 00 00       	call   802190 <_panic>

00800c05 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
  800c0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c14:	b8 05 00 00 00       	mov    $0x5,%eax
  800c19:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c1f:	8b 75 18             	mov    0x18(%ebp),%esi
  800c22:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c24:	85 c0                	test   %eax,%eax
  800c26:	7f 08                	jg     800c30 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2b:	5b                   	pop    %ebx
  800c2c:	5e                   	pop    %esi
  800c2d:	5f                   	pop    %edi
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c30:	83 ec 0c             	sub    $0xc,%esp
  800c33:	50                   	push   %eax
  800c34:	6a 05                	push   $0x5
  800c36:	68 7f 29 80 00       	push   $0x80297f
  800c3b:	6a 23                	push   $0x23
  800c3d:	68 9c 29 80 00       	push   $0x80299c
  800c42:	e8 49 15 00 00       	call   802190 <_panic>

00800c47 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c55:	8b 55 08             	mov    0x8(%ebp),%edx
  800c58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c60:	89 df                	mov    %ebx,%edi
  800c62:	89 de                	mov    %ebx,%esi
  800c64:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c66:	85 c0                	test   %eax,%eax
  800c68:	7f 08                	jg     800c72 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c72:	83 ec 0c             	sub    $0xc,%esp
  800c75:	50                   	push   %eax
  800c76:	6a 06                	push   $0x6
  800c78:	68 7f 29 80 00       	push   $0x80297f
  800c7d:	6a 23                	push   $0x23
  800c7f:	68 9c 29 80 00       	push   $0x80299c
  800c84:	e8 07 15 00 00       	call   802190 <_panic>

00800c89 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c97:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9d:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca2:	89 df                	mov    %ebx,%edi
  800ca4:	89 de                	mov    %ebx,%esi
  800ca6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca8:	85 c0                	test   %eax,%eax
  800caa:	7f 08                	jg     800cb4 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb4:	83 ec 0c             	sub    $0xc,%esp
  800cb7:	50                   	push   %eax
  800cb8:	6a 08                	push   $0x8
  800cba:	68 7f 29 80 00       	push   $0x80297f
  800cbf:	6a 23                	push   $0x23
  800cc1:	68 9c 29 80 00       	push   $0x80299c
  800cc6:	e8 c5 14 00 00       	call   802190 <_panic>

00800ccb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdf:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce4:	89 df                	mov    %ebx,%edi
  800ce6:	89 de                	mov    %ebx,%esi
  800ce8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cea:	85 c0                	test   %eax,%eax
  800cec:	7f 08                	jg     800cf6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf6:	83 ec 0c             	sub    $0xc,%esp
  800cf9:	50                   	push   %eax
  800cfa:	6a 09                	push   $0x9
  800cfc:	68 7f 29 80 00       	push   $0x80297f
  800d01:	6a 23                	push   $0x23
  800d03:	68 9c 29 80 00       	push   $0x80299c
  800d08:	e8 83 14 00 00       	call   802190 <_panic>

00800d0d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d26:	89 df                	mov    %ebx,%edi
  800d28:	89 de                	mov    %ebx,%esi
  800d2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7f 08                	jg     800d38 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d38:	83 ec 0c             	sub    $0xc,%esp
  800d3b:	50                   	push   %eax
  800d3c:	6a 0a                	push   $0xa
  800d3e:	68 7f 29 80 00       	push   $0x80297f
  800d43:	6a 23                	push   $0x23
  800d45:	68 9c 29 80 00       	push   $0x80299c
  800d4a:	e8 41 14 00 00       	call   802190 <_panic>

00800d4f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	57                   	push   %edi
  800d53:	56                   	push   %esi
  800d54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d60:	be 00 00 00 00       	mov    $0x0,%esi
  800d65:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d68:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d6d:	5b                   	pop    %ebx
  800d6e:	5e                   	pop    %esi
  800d6f:	5f                   	pop    %edi
  800d70:	5d                   	pop    %ebp
  800d71:	c3                   	ret    

00800d72 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	57                   	push   %edi
  800d76:	56                   	push   %esi
  800d77:	53                   	push   %ebx
  800d78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d88:	89 cb                	mov    %ecx,%ebx
  800d8a:	89 cf                	mov    %ecx,%edi
  800d8c:	89 ce                	mov    %ecx,%esi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 0d                	push   $0xd
  800da2:	68 7f 29 80 00       	push   $0x80297f
  800da7:	6a 23                	push   $0x23
  800da9:	68 9c 29 80 00       	push   $0x80299c
  800dae:	e8 dd 13 00 00       	call   802190 <_panic>

00800db3 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbe:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dc3:	89 d1                	mov    %edx,%ecx
  800dc5:	89 d3                	mov    %edx,%ebx
  800dc7:	89 d7                	mov    %edx,%edi
  800dc9:	89 d6                	mov    %edx,%esi
  800dcb:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dcd:	5b                   	pop    %ebx
  800dce:	5e                   	pop    %esi
  800dcf:	5f                   	pop    %edi
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800dda:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800ddc:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800de0:	74 7f                	je     800e61 <pgfault+0x8f>
  800de2:	89 d8                	mov    %ebx,%eax
  800de4:	c1 e8 0c             	shr    $0xc,%eax
  800de7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800dee:	f6 c4 08             	test   $0x8,%ah
  800df1:	74 6e                	je     800e61 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800df3:	e8 8c fd ff ff       	call   800b84 <sys_getenvid>
  800df8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800dfa:	83 ec 04             	sub    $0x4,%esp
  800dfd:	6a 07                	push   $0x7
  800dff:	68 00 f0 7f 00       	push   $0x7ff000
  800e04:	50                   	push   %eax
  800e05:	e8 b8 fd ff ff       	call   800bc2 <sys_page_alloc>
  800e0a:	83 c4 10             	add    $0x10,%esp
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	78 64                	js     800e75 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800e11:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800e17:	83 ec 04             	sub    $0x4,%esp
  800e1a:	68 00 10 00 00       	push   $0x1000
  800e1f:	53                   	push   %ebx
  800e20:	68 00 f0 7f 00       	push   $0x7ff000
  800e25:	e8 2d fb ff ff       	call   800957 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800e2a:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e31:	53                   	push   %ebx
  800e32:	56                   	push   %esi
  800e33:	68 00 f0 7f 00       	push   $0x7ff000
  800e38:	56                   	push   %esi
  800e39:	e8 c7 fd ff ff       	call   800c05 <sys_page_map>
  800e3e:	83 c4 20             	add    $0x20,%esp
  800e41:	85 c0                	test   %eax,%eax
  800e43:	78 42                	js     800e87 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e45:	83 ec 08             	sub    $0x8,%esp
  800e48:	68 00 f0 7f 00       	push   $0x7ff000
  800e4d:	56                   	push   %esi
  800e4e:	e8 f4 fd ff ff       	call   800c47 <sys_page_unmap>
  800e53:	83 c4 10             	add    $0x10,%esp
  800e56:	85 c0                	test   %eax,%eax
  800e58:	78 3f                	js     800e99 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800e5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800e61:	83 ec 04             	sub    $0x4,%esp
  800e64:	68 ac 29 80 00       	push   $0x8029ac
  800e69:	6a 1d                	push   $0x1d
  800e6b:	68 3b 2a 80 00       	push   $0x802a3b
  800e70:	e8 1b 13 00 00       	call   802190 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800e75:	50                   	push   %eax
  800e76:	68 d4 29 80 00       	push   $0x8029d4
  800e7b:	6a 28                	push   $0x28
  800e7d:	68 3b 2a 80 00       	push   $0x802a3b
  800e82:	e8 09 13 00 00       	call   802190 <_panic>
		panic("pgfault:page map failed: %e", r);
  800e87:	50                   	push   %eax
  800e88:	68 46 2a 80 00       	push   $0x802a46
  800e8d:	6a 2c                	push   $0x2c
  800e8f:	68 3b 2a 80 00       	push   $0x802a3b
  800e94:	e8 f7 12 00 00       	call   802190 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800e99:	50                   	push   %eax
  800e9a:	68 f8 29 80 00       	push   $0x8029f8
  800e9f:	6a 2e                	push   $0x2e
  800ea1:	68 3b 2a 80 00       	push   $0x802a3b
  800ea6:	e8 e5 12 00 00       	call   802190 <_panic>

00800eab <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800eb4:	68 d2 0d 80 00       	push   $0x800dd2
  800eb9:	e8 18 13 00 00       	call   8021d6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ebe:	b8 07 00 00 00       	mov    $0x7,%eax
  800ec3:	cd 30                	int    $0x30
  800ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800ec8:	83 c4 10             	add    $0x10,%esp
  800ecb:	85 c0                	test   %eax,%eax
  800ecd:	78 2f                	js     800efe <fork+0x53>
  800ecf:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800ed1:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800ed6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eda:	75 6e                	jne    800f4a <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800edc:	e8 a3 fc ff ff       	call   800b84 <sys_getenvid>
  800ee1:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ee6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ee9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800eee:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800ef3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5e                   	pop    %esi
  800efb:	5f                   	pop    %edi
  800efc:	5d                   	pop    %ebp
  800efd:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800efe:	50                   	push   %eax
  800eff:	68 18 2a 80 00       	push   $0x802a18
  800f04:	6a 6e                	push   $0x6e
  800f06:	68 3b 2a 80 00       	push   $0x802a3b
  800f0b:	e8 80 12 00 00       	call   802190 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800f10:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	25 07 0e 00 00       	and    $0xe07,%eax
  800f1f:	50                   	push   %eax
  800f20:	56                   	push   %esi
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	6a 00                	push   $0x0
  800f25:	e8 db fc ff ff       	call   800c05 <sys_page_map>
  800f2a:	83 c4 20             	add    $0x20,%esp
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f34:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	78 bb                	js     800ef6 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f3b:	83 c3 01             	add    $0x1,%ebx
  800f3e:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  800f44:	0f 84 a6 00 00 00    	je     800ff0 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  800f4a:	89 d8                	mov    %ebx,%eax
  800f4c:	c1 e8 0a             	shr    $0xa,%eax
  800f4f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f56:	a8 01                	test   $0x1,%al
  800f58:	74 e1                	je     800f3b <fork+0x90>
  800f5a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f61:	a8 01                	test   $0x1,%al
  800f63:	74 d6                	je     800f3b <fork+0x90>
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  800f6a:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f71:	f6 c4 04             	test   $0x4,%ah
  800f74:	75 9a                	jne    800f10 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  800f76:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f7d:	a8 02                	test   $0x2,%al
  800f7f:	75 0c                	jne    800f8d <fork+0xe2>
  800f81:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f88:	f6 c4 08             	test   $0x8,%ah
  800f8b:	74 42                	je     800fcf <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	68 05 08 00 00       	push   $0x805
  800f95:	56                   	push   %esi
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	6a 00                	push   $0x0
  800f9a:	e8 66 fc ff ff       	call   800c05 <sys_page_map>
  800f9f:	83 c4 20             	add    $0x20,%esp
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	0f 88 4c ff ff ff    	js     800ef6 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	68 05 08 00 00       	push   $0x805
  800fb2:	56                   	push   %esi
  800fb3:	6a 00                	push   $0x0
  800fb5:	56                   	push   %esi
  800fb6:	6a 00                	push   $0x0
  800fb8:	e8 48 fc ff ff       	call   800c05 <sys_page_map>
  800fbd:	83 c4 20             	add    $0x20,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc7:	0f 4f c1             	cmovg  %ecx,%eax
  800fca:	e9 68 ff ff ff       	jmp    800f37 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	6a 05                	push   $0x5
  800fd4:	56                   	push   %esi
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 27 fc ff ff       	call   800c05 <sys_page_map>
  800fde:	83 c4 20             	add    $0x20,%esp
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe8:	0f 4f c1             	cmovg  %ecx,%eax
  800feb:	e9 47 ff ff ff       	jmp    800f37 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  800ff0:	83 ec 04             	sub    $0x4,%esp
  800ff3:	6a 07                	push   $0x7
  800ff5:	68 00 f0 bf ee       	push   $0xeebff000
  800ffa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800ffd:	57                   	push   %edi
  800ffe:	e8 bf fb ff ff       	call   800bc2 <sys_page_alloc>
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	0f 88 e8 fe ff ff    	js     800ef6 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  80100e:	83 ec 08             	sub    $0x8,%esp
  801011:	68 3b 22 80 00       	push   $0x80223b
  801016:	57                   	push   %edi
  801017:	e8 f1 fc ff ff       	call   800d0d <sys_env_set_pgfault_upcall>
  80101c:	83 c4 10             	add    $0x10,%esp
  80101f:	85 c0                	test   %eax,%eax
  801021:	0f 88 cf fe ff ff    	js     800ef6 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	6a 02                	push   $0x2
  80102c:	57                   	push   %edi
  80102d:	e8 57 fc ff ff       	call   800c89 <sys_env_set_status>
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	85 c0                	test   %eax,%eax
  801037:	78 08                	js     801041 <fork+0x196>
	return eid;
  801039:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80103c:	e9 b5 fe ff ff       	jmp    800ef6 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  801041:	50                   	push   %eax
  801042:	68 62 2a 80 00       	push   $0x802a62
  801047:	68 87 00 00 00       	push   $0x87
  80104c:	68 3b 2a 80 00       	push   $0x802a3b
  801051:	e8 3a 11 00 00       	call   802190 <_panic>

00801056 <sfork>:

// Challenge!
int sfork(void)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80105c:	68 80 2a 80 00       	push   $0x802a80
  801061:	68 8f 00 00 00       	push   $0x8f
  801066:	68 3b 2a 80 00       	push   $0x802a3b
  80106b:	e8 20 11 00 00       	call   802190 <_panic>

00801070 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
  80107b:	c1 e8 0c             	shr    $0xc,%eax
}
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80108b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801090:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	c1 ea 16             	shr    $0x16,%edx
  8010a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ae:	f6 c2 01             	test   $0x1,%dl
  8010b1:	74 2a                	je     8010dd <fd_alloc+0x46>
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	c1 ea 0c             	shr    $0xc,%edx
  8010b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010bf:	f6 c2 01             	test   $0x1,%dl
  8010c2:	74 19                	je     8010dd <fd_alloc+0x46>
  8010c4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010c9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010ce:	75 d2                	jne    8010a2 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010d0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010d6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010db:	eb 07                	jmp    8010e4 <fd_alloc+0x4d>
			*fd_store = fd;
  8010dd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ec:	83 f8 1f             	cmp    $0x1f,%eax
  8010ef:	77 36                	ja     801127 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010f1:	c1 e0 0c             	shl    $0xc,%eax
  8010f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	c1 ea 16             	shr    $0x16,%edx
  8010fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801105:	f6 c2 01             	test   $0x1,%dl
  801108:	74 24                	je     80112e <fd_lookup+0x48>
  80110a:	89 c2                	mov    %eax,%edx
  80110c:	c1 ea 0c             	shr    $0xc,%edx
  80110f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801116:	f6 c2 01             	test   $0x1,%dl
  801119:	74 1a                	je     801135 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80111b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111e:	89 02                	mov    %eax,(%edx)
	return 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    
		return -E_INVAL;
  801127:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112c:	eb f7                	jmp    801125 <fd_lookup+0x3f>
		return -E_INVAL;
  80112e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801133:	eb f0                	jmp    801125 <fd_lookup+0x3f>
  801135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113a:	eb e9                	jmp    801125 <fd_lookup+0x3f>

0080113c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 08             	sub    $0x8,%esp
  801142:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801145:	ba 14 2b 80 00       	mov    $0x802b14,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80114a:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80114f:	39 08                	cmp    %ecx,(%eax)
  801151:	74 33                	je     801186 <dev_lookup+0x4a>
  801153:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801156:	8b 02                	mov    (%edx),%eax
  801158:	85 c0                	test   %eax,%eax
  80115a:	75 f3                	jne    80114f <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80115c:	a1 08 40 80 00       	mov    0x804008,%eax
  801161:	8b 40 48             	mov    0x48(%eax),%eax
  801164:	83 ec 04             	sub    $0x4,%esp
  801167:	51                   	push   %ecx
  801168:	50                   	push   %eax
  801169:	68 98 2a 80 00       	push   $0x802a98
  80116e:	e8 37 f0 ff ff       	call   8001aa <cprintf>
	*dev = 0;
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    
			*dev = devtab[i];
  801186:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801189:	89 01                	mov    %eax,(%ecx)
			return 0;
  80118b:	b8 00 00 00 00       	mov    $0x0,%eax
  801190:	eb f2                	jmp    801184 <dev_lookup+0x48>

00801192 <fd_close>:
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	57                   	push   %edi
  801196:	56                   	push   %esi
  801197:	53                   	push   %ebx
  801198:	83 ec 1c             	sub    $0x1c,%esp
  80119b:	8b 75 08             	mov    0x8(%ebp),%esi
  80119e:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011a4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011a5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011ab:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ae:	50                   	push   %eax
  8011af:	e8 32 ff ff ff       	call   8010e6 <fd_lookup>
  8011b4:	89 c3                	mov    %eax,%ebx
  8011b6:	83 c4 08             	add    $0x8,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 05                	js     8011c2 <fd_close+0x30>
	    || fd != fd2)
  8011bd:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011c0:	74 16                	je     8011d8 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011c2:	89 f8                	mov    %edi,%eax
  8011c4:	84 c0                	test   %al,%al
  8011c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8011cb:	0f 44 d8             	cmove  %eax,%ebx
}
  8011ce:	89 d8                	mov    %ebx,%eax
  8011d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5f                   	pop    %edi
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011de:	50                   	push   %eax
  8011df:	ff 36                	pushl  (%esi)
  8011e1:	e8 56 ff ff ff       	call   80113c <dev_lookup>
  8011e6:	89 c3                	mov    %eax,%ebx
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	78 15                	js     801204 <fd_close+0x72>
		if (dev->dev_close)
  8011ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f2:	8b 40 10             	mov    0x10(%eax),%eax
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	74 1b                	je     801214 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	56                   	push   %esi
  8011fd:	ff d0                	call   *%eax
  8011ff:	89 c3                	mov    %eax,%ebx
  801201:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801204:	83 ec 08             	sub    $0x8,%esp
  801207:	56                   	push   %esi
  801208:	6a 00                	push   $0x0
  80120a:	e8 38 fa ff ff       	call   800c47 <sys_page_unmap>
	return r;
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	eb ba                	jmp    8011ce <fd_close+0x3c>
			r = 0;
  801214:	bb 00 00 00 00       	mov    $0x0,%ebx
  801219:	eb e9                	jmp    801204 <fd_close+0x72>

0080121b <close>:

int
close(int fdnum)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801221:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	ff 75 08             	pushl  0x8(%ebp)
  801228:	e8 b9 fe ff ff       	call   8010e6 <fd_lookup>
  80122d:	83 c4 08             	add    $0x8,%esp
  801230:	85 c0                	test   %eax,%eax
  801232:	78 10                	js     801244 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	6a 01                	push   $0x1
  801239:	ff 75 f4             	pushl  -0xc(%ebp)
  80123c:	e8 51 ff ff ff       	call   801192 <fd_close>
  801241:	83 c4 10             	add    $0x10,%esp
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <close_all>:

void
close_all(void)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	53                   	push   %ebx
  80124a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80124d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801252:	83 ec 0c             	sub    $0xc,%esp
  801255:	53                   	push   %ebx
  801256:	e8 c0 ff ff ff       	call   80121b <close>
	for (i = 0; i < MAXFD; i++)
  80125b:	83 c3 01             	add    $0x1,%ebx
  80125e:	83 c4 10             	add    $0x10,%esp
  801261:	83 fb 20             	cmp    $0x20,%ebx
  801264:	75 ec                	jne    801252 <close_all+0xc>
}
  801266:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	57                   	push   %edi
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
  801271:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801274:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801277:	50                   	push   %eax
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 66 fe ff ff       	call   8010e6 <fd_lookup>
  801280:	89 c3                	mov    %eax,%ebx
  801282:	83 c4 08             	add    $0x8,%esp
  801285:	85 c0                	test   %eax,%eax
  801287:	0f 88 81 00 00 00    	js     80130e <dup+0xa3>
		return r;
	close(newfdnum);
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	ff 75 0c             	pushl  0xc(%ebp)
  801293:	e8 83 ff ff ff       	call   80121b <close>

	newfd = INDEX2FD(newfdnum);
  801298:	8b 75 0c             	mov    0xc(%ebp),%esi
  80129b:	c1 e6 0c             	shl    $0xc,%esi
  80129e:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012a4:	83 c4 04             	add    $0x4,%esp
  8012a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012aa:	e8 d1 fd ff ff       	call   801080 <fd2data>
  8012af:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012b1:	89 34 24             	mov    %esi,(%esp)
  8012b4:	e8 c7 fd ff ff       	call   801080 <fd2data>
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012be:	89 d8                	mov    %ebx,%eax
  8012c0:	c1 e8 16             	shr    $0x16,%eax
  8012c3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ca:	a8 01                	test   $0x1,%al
  8012cc:	74 11                	je     8012df <dup+0x74>
  8012ce:	89 d8                	mov    %ebx,%eax
  8012d0:	c1 e8 0c             	shr    $0xc,%eax
  8012d3:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012da:	f6 c2 01             	test   $0x1,%dl
  8012dd:	75 39                	jne    801318 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012e2:	89 d0                	mov    %edx,%eax
  8012e4:	c1 e8 0c             	shr    $0xc,%eax
  8012e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ee:	83 ec 0c             	sub    $0xc,%esp
  8012f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f6:	50                   	push   %eax
  8012f7:	56                   	push   %esi
  8012f8:	6a 00                	push   $0x0
  8012fa:	52                   	push   %edx
  8012fb:	6a 00                	push   $0x0
  8012fd:	e8 03 f9 ff ff       	call   800c05 <sys_page_map>
  801302:	89 c3                	mov    %eax,%ebx
  801304:	83 c4 20             	add    $0x20,%esp
  801307:	85 c0                	test   %eax,%eax
  801309:	78 31                	js     80133c <dup+0xd1>
		goto err;

	return newfdnum;
  80130b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80130e:	89 d8                	mov    %ebx,%eax
  801310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801313:	5b                   	pop    %ebx
  801314:	5e                   	pop    %esi
  801315:	5f                   	pop    %edi
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801318:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131f:	83 ec 0c             	sub    $0xc,%esp
  801322:	25 07 0e 00 00       	and    $0xe07,%eax
  801327:	50                   	push   %eax
  801328:	57                   	push   %edi
  801329:	6a 00                	push   $0x0
  80132b:	53                   	push   %ebx
  80132c:	6a 00                	push   $0x0
  80132e:	e8 d2 f8 ff ff       	call   800c05 <sys_page_map>
  801333:	89 c3                	mov    %eax,%ebx
  801335:	83 c4 20             	add    $0x20,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	79 a3                	jns    8012df <dup+0x74>
	sys_page_unmap(0, newfd);
  80133c:	83 ec 08             	sub    $0x8,%esp
  80133f:	56                   	push   %esi
  801340:	6a 00                	push   $0x0
  801342:	e8 00 f9 ff ff       	call   800c47 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801347:	83 c4 08             	add    $0x8,%esp
  80134a:	57                   	push   %edi
  80134b:	6a 00                	push   $0x0
  80134d:	e8 f5 f8 ff ff       	call   800c47 <sys_page_unmap>
	return r;
  801352:	83 c4 10             	add    $0x10,%esp
  801355:	eb b7                	jmp    80130e <dup+0xa3>

00801357 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	53                   	push   %ebx
  80135b:	83 ec 14             	sub    $0x14,%esp
  80135e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801361:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801364:	50                   	push   %eax
  801365:	53                   	push   %ebx
  801366:	e8 7b fd ff ff       	call   8010e6 <fd_lookup>
  80136b:	83 c4 08             	add    $0x8,%esp
  80136e:	85 c0                	test   %eax,%eax
  801370:	78 3f                	js     8013b1 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801372:	83 ec 08             	sub    $0x8,%esp
  801375:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801378:	50                   	push   %eax
  801379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137c:	ff 30                	pushl  (%eax)
  80137e:	e8 b9 fd ff ff       	call   80113c <dev_lookup>
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	78 27                	js     8013b1 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80138a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80138d:	8b 42 08             	mov    0x8(%edx),%eax
  801390:	83 e0 03             	and    $0x3,%eax
  801393:	83 f8 01             	cmp    $0x1,%eax
  801396:	74 1e                	je     8013b6 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139b:	8b 40 08             	mov    0x8(%eax),%eax
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	74 35                	je     8013d7 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	ff 75 10             	pushl  0x10(%ebp)
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	52                   	push   %edx
  8013ac:	ff d0                	call   *%eax
  8013ae:	83 c4 10             	add    $0x10,%esp
}
  8013b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8013bb:	8b 40 48             	mov    0x48(%eax),%eax
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	53                   	push   %ebx
  8013c2:	50                   	push   %eax
  8013c3:	68 d9 2a 80 00       	push   $0x802ad9
  8013c8:	e8 dd ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013d5:	eb da                	jmp    8013b1 <read+0x5a>
		return -E_NOT_SUPP;
  8013d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013dc:	eb d3                	jmp    8013b1 <read+0x5a>

008013de <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	57                   	push   %edi
  8013e2:	56                   	push   %esi
  8013e3:	53                   	push   %ebx
  8013e4:	83 ec 0c             	sub    $0xc,%esp
  8013e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ea:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f2:	39 f3                	cmp    %esi,%ebx
  8013f4:	73 25                	jae    80141b <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f6:	83 ec 04             	sub    $0x4,%esp
  8013f9:	89 f0                	mov    %esi,%eax
  8013fb:	29 d8                	sub    %ebx,%eax
  8013fd:	50                   	push   %eax
  8013fe:	89 d8                	mov    %ebx,%eax
  801400:	03 45 0c             	add    0xc(%ebp),%eax
  801403:	50                   	push   %eax
  801404:	57                   	push   %edi
  801405:	e8 4d ff ff ff       	call   801357 <read>
		if (m < 0)
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 08                	js     801419 <readn+0x3b>
			return m;
		if (m == 0)
  801411:	85 c0                	test   %eax,%eax
  801413:	74 06                	je     80141b <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801415:	01 c3                	add    %eax,%ebx
  801417:	eb d9                	jmp    8013f2 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801419:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5f                   	pop    %edi
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	53                   	push   %ebx
  801429:	83 ec 14             	sub    $0x14,%esp
  80142c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	53                   	push   %ebx
  801434:	e8 ad fc ff ff       	call   8010e6 <fd_lookup>
  801439:	83 c4 08             	add    $0x8,%esp
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 3a                	js     80147a <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801440:	83 ec 08             	sub    $0x8,%esp
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144a:	ff 30                	pushl  (%eax)
  80144c:	e8 eb fc ff ff       	call   80113c <dev_lookup>
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	78 22                	js     80147a <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145f:	74 1e                	je     80147f <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	8b 52 0c             	mov    0xc(%edx),%edx
  801467:	85 d2                	test   %edx,%edx
  801469:	74 35                	je     8014a0 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	ff 75 10             	pushl  0x10(%ebp)
  801471:	ff 75 0c             	pushl  0xc(%ebp)
  801474:	50                   	push   %eax
  801475:	ff d2                	call   *%edx
  801477:	83 c4 10             	add    $0x10,%esp
}
  80147a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80147f:	a1 08 40 80 00       	mov    0x804008,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	53                   	push   %ebx
  80148b:	50                   	push   %eax
  80148c:	68 f5 2a 80 00       	push   $0x802af5
  801491:	e8 14 ed ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149e:	eb da                	jmp    80147a <write+0x55>
		return -E_NOT_SUPP;
  8014a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014a5:	eb d3                	jmp    80147a <write+0x55>

008014a7 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ad:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 08             	pushl  0x8(%ebp)
  8014b4:	e8 2d fc ff ff       	call   8010e6 <fd_lookup>
  8014b9:	83 c4 08             	add    $0x8,%esp
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 0e                	js     8014ce <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 14             	sub    $0x14,%esp
  8014d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014dd:	50                   	push   %eax
  8014de:	53                   	push   %ebx
  8014df:	e8 02 fc ff ff       	call   8010e6 <fd_lookup>
  8014e4:	83 c4 08             	add    $0x8,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 37                	js     801522 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f5:	ff 30                	pushl  (%eax)
  8014f7:	e8 40 fc ff ff       	call   80113c <dev_lookup>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 1f                	js     801522 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801506:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80150a:	74 1b                	je     801527 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	8b 52 18             	mov    0x18(%edx),%edx
  801512:	85 d2                	test   %edx,%edx
  801514:	74 32                	je     801548 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	ff 75 0c             	pushl  0xc(%ebp)
  80151c:	50                   	push   %eax
  80151d:	ff d2                	call   *%edx
  80151f:	83 c4 10             	add    $0x10,%esp
}
  801522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801525:	c9                   	leave  
  801526:	c3                   	ret    
			thisenv->env_id, fdnum);
  801527:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80152c:	8b 40 48             	mov    0x48(%eax),%eax
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	53                   	push   %ebx
  801533:	50                   	push   %eax
  801534:	68 b8 2a 80 00       	push   $0x802ab8
  801539:	e8 6c ec ff ff       	call   8001aa <cprintf>
		return -E_INVAL;
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801546:	eb da                	jmp    801522 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801548:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80154d:	eb d3                	jmp    801522 <ftruncate+0x52>

0080154f <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	53                   	push   %ebx
  801553:	83 ec 14             	sub    $0x14,%esp
  801556:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801559:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155c:	50                   	push   %eax
  80155d:	ff 75 08             	pushl  0x8(%ebp)
  801560:	e8 81 fb ff ff       	call   8010e6 <fd_lookup>
  801565:	83 c4 08             	add    $0x8,%esp
  801568:	85 c0                	test   %eax,%eax
  80156a:	78 4b                	js     8015b7 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801572:	50                   	push   %eax
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	ff 30                	pushl  (%eax)
  801578:	e8 bf fb ff ff       	call   80113c <dev_lookup>
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 33                	js     8015b7 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801587:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80158b:	74 2f                	je     8015bc <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80158d:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801590:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801597:	00 00 00 
	stat->st_isdir = 0;
  80159a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015a1:	00 00 00 
	stat->st_dev = dev;
  8015a4:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	53                   	push   %ebx
  8015ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8015b1:	ff 50 14             	call   *0x14(%eax)
  8015b4:	83 c4 10             	add    $0x10,%esp
}
  8015b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    
		return -E_NOT_SUPP;
  8015bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c1:	eb f4                	jmp    8015b7 <fstat+0x68>

008015c3 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	6a 00                	push   $0x0
  8015cd:	ff 75 08             	pushl  0x8(%ebp)
  8015d0:	e8 e7 01 00 00       	call   8017bc <open>
  8015d5:	89 c3                	mov    %eax,%ebx
  8015d7:	83 c4 10             	add    $0x10,%esp
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	78 1b                	js     8015f9 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015de:	83 ec 08             	sub    $0x8,%esp
  8015e1:	ff 75 0c             	pushl  0xc(%ebp)
  8015e4:	50                   	push   %eax
  8015e5:	e8 65 ff ff ff       	call   80154f <fstat>
  8015ea:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ec:	89 1c 24             	mov    %ebx,(%esp)
  8015ef:	e8 27 fc ff ff       	call   80121b <close>
	return r;
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	89 f3                	mov    %esi,%ebx
}
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5d                   	pop    %ebp
  801601:	c3                   	ret    

00801602 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
  801607:	89 c6                	mov    %eax,%esi
  801609:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80160b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801612:	74 27                	je     80163b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801614:	6a 07                	push   $0x7
  801616:	68 00 50 80 00       	push   $0x805000
  80161b:	56                   	push   %esi
  80161c:	ff 35 00 40 80 00    	pushl  0x804000
  801622:	e8 a1 0c 00 00       	call   8022c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801627:	83 c4 0c             	add    $0xc,%esp
  80162a:	6a 00                	push   $0x0
  80162c:	53                   	push   %ebx
  80162d:	6a 00                	push   $0x0
  80162f:	e8 2d 0c 00 00       	call   802261 <ipc_recv>
}
  801634:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801637:	5b                   	pop    %ebx
  801638:	5e                   	pop    %esi
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80163b:	83 ec 0c             	sub    $0xc,%esp
  80163e:	6a 01                	push   $0x1
  801640:	e8 d7 0c 00 00       	call   80231c <ipc_find_env>
  801645:	a3 00 40 80 00       	mov    %eax,0x804000
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	eb c5                	jmp    801614 <fsipc+0x12>

0080164f <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8b 40 0c             	mov    0xc(%eax),%eax
  80165b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801668:	ba 00 00 00 00       	mov    $0x0,%edx
  80166d:	b8 02 00 00 00       	mov    $0x2,%eax
  801672:	e8 8b ff ff ff       	call   801602 <fsipc>
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <devfile_flush>:
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80168a:	ba 00 00 00 00       	mov    $0x0,%edx
  80168f:	b8 06 00 00 00       	mov    $0x6,%eax
  801694:	e8 69 ff ff ff       	call   801602 <fsipc>
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <devfile_stat>:
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	53                   	push   %ebx
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ab:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b5:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ba:	e8 43 ff ff ff       	call   801602 <fsipc>
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 2c                	js     8016ef <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016c3:	83 ec 08             	sub    $0x8,%esp
  8016c6:	68 00 50 80 00       	push   $0x805000
  8016cb:	53                   	push   %ebx
  8016cc:	e8 f8 f0 ff ff       	call   8007c9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016d1:	a1 80 50 80 00       	mov    0x805080,%eax
  8016d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016dc:	a1 84 50 80 00       	mov    0x805084,%eax
  8016e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <devfile_write>:
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801702:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801707:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80170a:	8b 55 08             	mov    0x8(%ebp),%edx
  80170d:	8b 52 0c             	mov    0xc(%edx),%edx
  801710:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801716:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80171b:	50                   	push   %eax
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	68 08 50 80 00       	push   $0x805008
  801724:	e8 2e f2 ff ff       	call   800957 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801729:	ba 00 00 00 00       	mov    $0x0,%edx
  80172e:	b8 04 00 00 00       	mov    $0x4,%eax
  801733:	e8 ca fe ff ff       	call   801602 <fsipc>
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <devfile_read>:
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 40 0c             	mov    0xc(%eax),%eax
  801748:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80174d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801753:	ba 00 00 00 00       	mov    $0x0,%edx
  801758:	b8 03 00 00 00       	mov    $0x3,%eax
  80175d:	e8 a0 fe ff ff       	call   801602 <fsipc>
  801762:	89 c3                	mov    %eax,%ebx
  801764:	85 c0                	test   %eax,%eax
  801766:	78 1f                	js     801787 <devfile_read+0x4d>
	assert(r <= n);
  801768:	39 f0                	cmp    %esi,%eax
  80176a:	77 24                	ja     801790 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80176c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801771:	7f 33                	jg     8017a6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	50                   	push   %eax
  801777:	68 00 50 80 00       	push   $0x805000
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	e8 d3 f1 ff ff       	call   800957 <memmove>
	return r;
  801784:	83 c4 10             	add    $0x10,%esp
}
  801787:	89 d8                	mov    %ebx,%eax
  801789:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178c:	5b                   	pop    %ebx
  80178d:	5e                   	pop    %esi
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    
	assert(r <= n);
  801790:	68 28 2b 80 00       	push   $0x802b28
  801795:	68 2f 2b 80 00       	push   $0x802b2f
  80179a:	6a 7b                	push   $0x7b
  80179c:	68 44 2b 80 00       	push   $0x802b44
  8017a1:	e8 ea 09 00 00       	call   802190 <_panic>
	assert(r <= PGSIZE);
  8017a6:	68 4f 2b 80 00       	push   $0x802b4f
  8017ab:	68 2f 2b 80 00       	push   $0x802b2f
  8017b0:	6a 7c                	push   $0x7c
  8017b2:	68 44 2b 80 00       	push   $0x802b44
  8017b7:	e8 d4 09 00 00       	call   802190 <_panic>

008017bc <open>:
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
  8017c1:	83 ec 1c             	sub    $0x1c,%esp
  8017c4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c7:	56                   	push   %esi
  8017c8:	e8 c5 ef ff ff       	call   800792 <strlen>
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d5:	7f 6c                	jg     801843 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d7:	83 ec 0c             	sub    $0xc,%esp
  8017da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017dd:	50                   	push   %eax
  8017de:	e8 b4 f8 ff ff       	call   801097 <fd_alloc>
  8017e3:	89 c3                	mov    %eax,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 3c                	js     801828 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ec:	83 ec 08             	sub    $0x8,%esp
  8017ef:	56                   	push   %esi
  8017f0:	68 00 50 80 00       	push   $0x805000
  8017f5:	e8 cf ef ff ff       	call   8007c9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fd:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801805:	b8 01 00 00 00       	mov    $0x1,%eax
  80180a:	e8 f3 fd ff ff       	call   801602 <fsipc>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	85 c0                	test   %eax,%eax
  801816:	78 19                	js     801831 <open+0x75>
	return fd2num(fd);
  801818:	83 ec 0c             	sub    $0xc,%esp
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	e8 4d f8 ff ff       	call   801070 <fd2num>
  801823:	89 c3                	mov    %eax,%ebx
  801825:	83 c4 10             	add    $0x10,%esp
}
  801828:	89 d8                	mov    %ebx,%eax
  80182a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5e                   	pop    %esi
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    
		fd_close(fd, 0);
  801831:	83 ec 08             	sub    $0x8,%esp
  801834:	6a 00                	push   $0x0
  801836:	ff 75 f4             	pushl  -0xc(%ebp)
  801839:	e8 54 f9 ff ff       	call   801192 <fd_close>
		return r;
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	eb e5                	jmp    801828 <open+0x6c>
		return -E_BAD_PATH;
  801843:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801848:	eb de                	jmp    801828 <open+0x6c>

0080184a <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801850:	ba 00 00 00 00       	mov    $0x0,%edx
  801855:	b8 08 00 00 00       	mov    $0x8,%eax
  80185a:	e8 a3 fd ff ff       	call   801602 <fsipc>
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801867:	68 5b 2b 80 00       	push   $0x802b5b
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	e8 55 ef ff ff       	call   8007c9 <strcpy>
	return 0;
}
  801874:	b8 00 00 00 00       	mov    $0x0,%eax
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <devsock_close>:
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	53                   	push   %ebx
  80187f:	83 ec 10             	sub    $0x10,%esp
  801882:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801885:	53                   	push   %ebx
  801886:	e8 ca 0a 00 00       	call   802355 <pageref>
  80188b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801893:	83 f8 01             	cmp    $0x1,%eax
  801896:	74 07                	je     80189f <devsock_close+0x24>
}
  801898:	89 d0                	mov    %edx,%eax
  80189a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	ff 73 0c             	pushl  0xc(%ebx)
  8018a5:	e8 b7 02 00 00       	call   801b61 <nsipc_close>
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	eb e7                	jmp    801898 <devsock_close+0x1d>

008018b1 <devsock_write>:
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	ff 75 10             	pushl  0x10(%ebp)
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	ff 70 0c             	pushl  0xc(%eax)
  8018c5:	e8 74 03 00 00       	call   801c3e <nsipc_send>
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <devsock_read>:
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	ff 75 10             	pushl  0x10(%ebp)
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dd:	ff 70 0c             	pushl  0xc(%eax)
  8018e0:	e8 ed 02 00 00       	call   801bd2 <nsipc_recv>
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <fd2sockid>:
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ed:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018f0:	52                   	push   %edx
  8018f1:	50                   	push   %eax
  8018f2:	e8 ef f7 ff ff       	call   8010e6 <fd_lookup>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 10                	js     80190e <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801901:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801907:	39 08                	cmp    %ecx,(%eax)
  801909:	75 05                	jne    801910 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80190b:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    
		return -E_NOT_SUPP;
  801910:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801915:	eb f7                	jmp    80190e <fd2sockid+0x27>

00801917 <alloc_sockfd>:
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	83 ec 1c             	sub    $0x1c,%esp
  80191f:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801921:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801924:	50                   	push   %eax
  801925:	e8 6d f7 ff ff       	call   801097 <fd_alloc>
  80192a:	89 c3                	mov    %eax,%ebx
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 43                	js     801976 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	68 07 04 00 00       	push   $0x407
  80193b:	ff 75 f4             	pushl  -0xc(%ebp)
  80193e:	6a 00                	push   $0x0
  801940:	e8 7d f2 ff ff       	call   800bc2 <sys_page_alloc>
  801945:	89 c3                	mov    %eax,%ebx
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	85 c0                	test   %eax,%eax
  80194c:	78 28                	js     801976 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80194e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801951:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801957:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801963:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801966:	83 ec 0c             	sub    $0xc,%esp
  801969:	50                   	push   %eax
  80196a:	e8 01 f7 ff ff       	call   801070 <fd2num>
  80196f:	89 c3                	mov    %eax,%ebx
  801971:	83 c4 10             	add    $0x10,%esp
  801974:	eb 0c                	jmp    801982 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801976:	83 ec 0c             	sub    $0xc,%esp
  801979:	56                   	push   %esi
  80197a:	e8 e2 01 00 00       	call   801b61 <nsipc_close>
		return r;
  80197f:	83 c4 10             	add    $0x10,%esp
}
  801982:	89 d8                	mov    %ebx,%eax
  801984:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <accept>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	e8 4e ff ff ff       	call   8018e7 <fd2sockid>
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 1b                	js     8019b8 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	ff 75 10             	pushl  0x10(%ebp)
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	50                   	push   %eax
  8019a7:	e8 0e 01 00 00       	call   801aba <nsipc_accept>
  8019ac:	83 c4 10             	add    $0x10,%esp
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 05                	js     8019b8 <accept+0x2d>
	return alloc_sockfd(r);
  8019b3:	e8 5f ff ff ff       	call   801917 <alloc_sockfd>
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <bind>:
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	e8 1f ff ff ff       	call   8018e7 <fd2sockid>
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 12                	js     8019de <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	ff 75 10             	pushl  0x10(%ebp)
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	e8 2f 01 00 00       	call   801b0a <nsipc_bind>
  8019db:	83 c4 10             	add    $0x10,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <shutdown>:
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	e8 f9 fe ff ff       	call   8018e7 <fd2sockid>
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 0f                	js     801a01 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	50                   	push   %eax
  8019f9:	e8 41 01 00 00       	call   801b3f <nsipc_shutdown>
  8019fe:	83 c4 10             	add    $0x10,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <connect>:
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	e8 d6 fe ff ff       	call   8018e7 <fd2sockid>
  801a11:	85 c0                	test   %eax,%eax
  801a13:	78 12                	js     801a27 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a15:	83 ec 04             	sub    $0x4,%esp
  801a18:	ff 75 10             	pushl  0x10(%ebp)
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	e8 57 01 00 00       	call   801b7b <nsipc_connect>
  801a24:	83 c4 10             	add    $0x10,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <listen>:
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	e8 b0 fe ff ff       	call   8018e7 <fd2sockid>
  801a37:	85 c0                	test   %eax,%eax
  801a39:	78 0f                	js     801a4a <listen+0x21>
	return nsipc_listen(r, backlog);
  801a3b:	83 ec 08             	sub    $0x8,%esp
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	50                   	push   %eax
  801a42:	e8 69 01 00 00       	call   801bb0 <nsipc_listen>
  801a47:	83 c4 10             	add    $0x10,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <socket>:

int
socket(int domain, int type, int protocol)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a52:	ff 75 10             	pushl  0x10(%ebp)
  801a55:	ff 75 0c             	pushl  0xc(%ebp)
  801a58:	ff 75 08             	pushl  0x8(%ebp)
  801a5b:	e8 3c 02 00 00       	call   801c9c <nsipc_socket>
  801a60:	83 c4 10             	add    $0x10,%esp
  801a63:	85 c0                	test   %eax,%eax
  801a65:	78 05                	js     801a6c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a67:	e8 ab fe ff ff       	call   801917 <alloc_sockfd>
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	53                   	push   %ebx
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a77:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a7e:	74 26                	je     801aa6 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a80:	6a 07                	push   $0x7
  801a82:	68 00 60 80 00       	push   $0x806000
  801a87:	53                   	push   %ebx
  801a88:	ff 35 04 40 80 00    	pushl  0x804004
  801a8e:	e8 35 08 00 00       	call   8022c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a93:	83 c4 0c             	add    $0xc,%esp
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	e8 c0 07 00 00       	call   802261 <ipc_recv>
}
  801aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa6:	83 ec 0c             	sub    $0xc,%esp
  801aa9:	6a 02                	push   $0x2
  801aab:	e8 6c 08 00 00       	call   80231c <ipc_find_env>
  801ab0:	a3 04 40 80 00       	mov    %eax,0x804004
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	eb c6                	jmp    801a80 <nsipc+0x12>

00801aba <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aca:	8b 06                	mov    (%esi),%eax
  801acc:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ad1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad6:	e8 93 ff ff ff       	call   801a6e <nsipc>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 20                	js     801b01 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	ff 35 10 60 80 00    	pushl  0x806010
  801aea:	68 00 60 80 00       	push   $0x806000
  801aef:	ff 75 0c             	pushl  0xc(%ebp)
  801af2:	e8 60 ee ff ff       	call   800957 <memmove>
		*addrlen = ret->ret_addrlen;
  801af7:	a1 10 60 80 00       	mov    0x806010,%eax
  801afc:	89 06                	mov    %eax,(%esi)
  801afe:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801b01:	89 d8                	mov    %ebx,%eax
  801b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
  801b0d:	53                   	push   %ebx
  801b0e:	83 ec 08             	sub    $0x8,%esp
  801b11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b1c:	53                   	push   %ebx
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	68 04 60 80 00       	push   $0x806004
  801b25:	e8 2d ee ff ff       	call   800957 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b2a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b30:	b8 02 00 00 00       	mov    $0x2,%eax
  801b35:	e8 34 ff ff ff       	call   801a6e <nsipc>
}
  801b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b50:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b55:	b8 03 00 00 00       	mov    $0x3,%eax
  801b5a:	e8 0f ff ff ff       	call   801a6e <nsipc>
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <nsipc_close>:

int
nsipc_close(int s)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b6f:	b8 04 00 00 00       	mov    $0x4,%eax
  801b74:	e8 f5 fe ff ff       	call   801a6e <nsipc>
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	53                   	push   %ebx
  801b7f:	83 ec 08             	sub    $0x8,%esp
  801b82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b8d:	53                   	push   %ebx
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	68 04 60 80 00       	push   $0x806004
  801b96:	e8 bc ed ff ff       	call   800957 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b9b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ba1:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba6:	e8 c3 fe ff ff       	call   801a6e <nsipc>
}
  801bab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc6:	b8 06 00 00 00       	mov    $0x6,%eax
  801bcb:	e8 9e fe ff ff       	call   801a6e <nsipc>
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	56                   	push   %esi
  801bd6:	53                   	push   %ebx
  801bd7:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be2:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be8:	8b 45 14             	mov    0x14(%ebp),%eax
  801beb:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bf0:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf5:	e8 74 fe ff ff       	call   801a6e <nsipc>
  801bfa:	89 c3                	mov    %eax,%ebx
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	78 1f                	js     801c1f <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c05:	7f 21                	jg     801c28 <nsipc_recv+0x56>
  801c07:	39 c6                	cmp    %eax,%esi
  801c09:	7c 1d                	jl     801c28 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c0b:	83 ec 04             	sub    $0x4,%esp
  801c0e:	50                   	push   %eax
  801c0f:	68 00 60 80 00       	push   $0x806000
  801c14:	ff 75 0c             	pushl  0xc(%ebp)
  801c17:	e8 3b ed ff ff       	call   800957 <memmove>
  801c1c:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c1f:	89 d8                	mov    %ebx,%eax
  801c21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5d                   	pop    %ebp
  801c27:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c28:	68 67 2b 80 00       	push   $0x802b67
  801c2d:	68 2f 2b 80 00       	push   $0x802b2f
  801c32:	6a 62                	push   $0x62
  801c34:	68 7c 2b 80 00       	push   $0x802b7c
  801c39:	e8 52 05 00 00       	call   802190 <_panic>

00801c3e <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	53                   	push   %ebx
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c50:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c56:	7f 2e                	jg     801c86 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c58:	83 ec 04             	sub    $0x4,%esp
  801c5b:	53                   	push   %ebx
  801c5c:	ff 75 0c             	pushl  0xc(%ebp)
  801c5f:	68 0c 60 80 00       	push   $0x80600c
  801c64:	e8 ee ec ff ff       	call   800957 <memmove>
	nsipcbuf.send.req_size = size;
  801c69:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c72:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c77:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7c:	e8 ed fd ff ff       	call   801a6e <nsipc>
}
  801c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    
	assert(size < 1600);
  801c86:	68 88 2b 80 00       	push   $0x802b88
  801c8b:	68 2f 2b 80 00       	push   $0x802b2f
  801c90:	6a 6d                	push   $0x6d
  801c92:	68 7c 2b 80 00       	push   $0x802b7c
  801c97:	e8 f4 04 00 00       	call   802190 <_panic>

00801c9c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cba:	b8 09 00 00 00       	mov    $0x9,%eax
  801cbf:	e8 aa fd ff ff       	call   801a6e <nsipc>
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	56                   	push   %esi
  801cca:	53                   	push   %ebx
  801ccb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cce:	83 ec 0c             	sub    $0xc,%esp
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	e8 a7 f3 ff ff       	call   801080 <fd2data>
  801cd9:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cdb:	83 c4 08             	add    $0x8,%esp
  801cde:	68 94 2b 80 00       	push   $0x802b94
  801ce3:	53                   	push   %ebx
  801ce4:	e8 e0 ea ff ff       	call   8007c9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ce9:	8b 46 04             	mov    0x4(%esi),%eax
  801cec:	2b 06                	sub    (%esi),%eax
  801cee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cfb:	00 00 00 
	stat->st_dev = &devpipe;
  801cfe:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d05:	30 80 00 
	return 0;
}
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    

00801d14 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	53                   	push   %ebx
  801d18:	83 ec 0c             	sub    $0xc,%esp
  801d1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d1e:	53                   	push   %ebx
  801d1f:	6a 00                	push   $0x0
  801d21:	e8 21 ef ff ff       	call   800c47 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d26:	89 1c 24             	mov    %ebx,(%esp)
  801d29:	e8 52 f3 ff ff       	call   801080 <fd2data>
  801d2e:	83 c4 08             	add    $0x8,%esp
  801d31:	50                   	push   %eax
  801d32:	6a 00                	push   $0x0
  801d34:	e8 0e ef ff ff       	call   800c47 <sys_page_unmap>
}
  801d39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <_pipeisclosed>:
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	57                   	push   %edi
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	83 ec 1c             	sub    $0x1c,%esp
  801d47:	89 c7                	mov    %eax,%edi
  801d49:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d4b:	a1 08 40 80 00       	mov    0x804008,%eax
  801d50:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	57                   	push   %edi
  801d57:	e8 f9 05 00 00       	call   802355 <pageref>
  801d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d5f:	89 34 24             	mov    %esi,(%esp)
  801d62:	e8 ee 05 00 00       	call   802355 <pageref>
		nn = thisenv->env_runs;
  801d67:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d6d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	39 cb                	cmp    %ecx,%ebx
  801d75:	74 1b                	je     801d92 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d77:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d7a:	75 cf                	jne    801d4b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d7c:	8b 42 58             	mov    0x58(%edx),%eax
  801d7f:	6a 01                	push   $0x1
  801d81:	50                   	push   %eax
  801d82:	53                   	push   %ebx
  801d83:	68 9b 2b 80 00       	push   $0x802b9b
  801d88:	e8 1d e4 ff ff       	call   8001aa <cprintf>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	eb b9                	jmp    801d4b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d92:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d95:	0f 94 c0             	sete   %al
  801d98:	0f b6 c0             	movzbl %al,%eax
}
  801d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5f                   	pop    %edi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <devpipe_write>:
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	57                   	push   %edi
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	83 ec 28             	sub    $0x28,%esp
  801dac:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801daf:	56                   	push   %esi
  801db0:	e8 cb f2 ff ff       	call   801080 <fd2data>
  801db5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db7:	83 c4 10             	add    $0x10,%esp
  801dba:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbf:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc2:	74 4f                	je     801e13 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc4:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc7:	8b 0b                	mov    (%ebx),%ecx
  801dc9:	8d 51 20             	lea    0x20(%ecx),%edx
  801dcc:	39 d0                	cmp    %edx,%eax
  801dce:	72 14                	jb     801de4 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dd0:	89 da                	mov    %ebx,%edx
  801dd2:	89 f0                	mov    %esi,%eax
  801dd4:	e8 65 ff ff ff       	call   801d3e <_pipeisclosed>
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	75 3a                	jne    801e17 <devpipe_write+0x74>
			sys_yield();
  801ddd:	e8 c1 ed ff ff       	call   800ba3 <sys_yield>
  801de2:	eb e0                	jmp    801dc4 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de7:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801deb:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dee:	89 c2                	mov    %eax,%edx
  801df0:	c1 fa 1f             	sar    $0x1f,%edx
  801df3:	89 d1                	mov    %edx,%ecx
  801df5:	c1 e9 1b             	shr    $0x1b,%ecx
  801df8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dfb:	83 e2 1f             	and    $0x1f,%edx
  801dfe:	29 ca                	sub    %ecx,%edx
  801e00:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e04:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e08:	83 c0 01             	add    $0x1,%eax
  801e0b:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e0e:	83 c7 01             	add    $0x1,%edi
  801e11:	eb ac                	jmp    801dbf <devpipe_write+0x1c>
	return i;
  801e13:	89 f8                	mov    %edi,%eax
  801e15:	eb 05                	jmp    801e1c <devpipe_write+0x79>
				return 0;
  801e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    

00801e24 <devpipe_read>:
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	57                   	push   %edi
  801e28:	56                   	push   %esi
  801e29:	53                   	push   %ebx
  801e2a:	83 ec 18             	sub    $0x18,%esp
  801e2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e30:	57                   	push   %edi
  801e31:	e8 4a f2 ff ff       	call   801080 <fd2data>
  801e36:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	be 00 00 00 00       	mov    $0x0,%esi
  801e40:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e43:	74 47                	je     801e8c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801e45:	8b 03                	mov    (%ebx),%eax
  801e47:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e4a:	75 22                	jne    801e6e <devpipe_read+0x4a>
			if (i > 0)
  801e4c:	85 f6                	test   %esi,%esi
  801e4e:	75 14                	jne    801e64 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801e50:	89 da                	mov    %ebx,%edx
  801e52:	89 f8                	mov    %edi,%eax
  801e54:	e8 e5 fe ff ff       	call   801d3e <_pipeisclosed>
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	75 33                	jne    801e90 <devpipe_read+0x6c>
			sys_yield();
  801e5d:	e8 41 ed ff ff       	call   800ba3 <sys_yield>
  801e62:	eb e1                	jmp    801e45 <devpipe_read+0x21>
				return i;
  801e64:	89 f0                	mov    %esi,%eax
}
  801e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e69:	5b                   	pop    %ebx
  801e6a:	5e                   	pop    %esi
  801e6b:	5f                   	pop    %edi
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6e:	99                   	cltd   
  801e6f:	c1 ea 1b             	shr    $0x1b,%edx
  801e72:	01 d0                	add    %edx,%eax
  801e74:	83 e0 1f             	and    $0x1f,%eax
  801e77:	29 d0                	sub    %edx,%eax
  801e79:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e81:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e84:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e87:	83 c6 01             	add    $0x1,%esi
  801e8a:	eb b4                	jmp    801e40 <devpipe_read+0x1c>
	return i;
  801e8c:	89 f0                	mov    %esi,%eax
  801e8e:	eb d6                	jmp    801e66 <devpipe_read+0x42>
				return 0;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
  801e95:	eb cf                	jmp    801e66 <devpipe_read+0x42>

00801e97 <pipe>:
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	56                   	push   %esi
  801e9b:	53                   	push   %ebx
  801e9c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e9f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea2:	50                   	push   %eax
  801ea3:	e8 ef f1 ff ff       	call   801097 <fd_alloc>
  801ea8:	89 c3                	mov    %eax,%ebx
  801eaa:	83 c4 10             	add    $0x10,%esp
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	78 5b                	js     801f0c <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	68 07 04 00 00       	push   $0x407
  801eb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebc:	6a 00                	push   $0x0
  801ebe:	e8 ff ec ff ff       	call   800bc2 <sys_page_alloc>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	78 40                	js     801f0c <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ed2:	50                   	push   %eax
  801ed3:	e8 bf f1 ff ff       	call   801097 <fd_alloc>
  801ed8:	89 c3                	mov    %eax,%ebx
  801eda:	83 c4 10             	add    $0x10,%esp
  801edd:	85 c0                	test   %eax,%eax
  801edf:	78 1b                	js     801efc <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 07 04 00 00       	push   $0x407
  801ee9:	ff 75 f0             	pushl  -0x10(%ebp)
  801eec:	6a 00                	push   $0x0
  801eee:	e8 cf ec ff ff       	call   800bc2 <sys_page_alloc>
  801ef3:	89 c3                	mov    %eax,%ebx
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	79 19                	jns    801f15 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801efc:	83 ec 08             	sub    $0x8,%esp
  801eff:	ff 75 f4             	pushl  -0xc(%ebp)
  801f02:	6a 00                	push   $0x0
  801f04:	e8 3e ed ff ff       	call   800c47 <sys_page_unmap>
  801f09:	83 c4 10             	add    $0x10,%esp
}
  801f0c:	89 d8                	mov    %ebx,%eax
  801f0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f11:	5b                   	pop    %ebx
  801f12:	5e                   	pop    %esi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    
	va = fd2data(fd0);
  801f15:	83 ec 0c             	sub    $0xc,%esp
  801f18:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1b:	e8 60 f1 ff ff       	call   801080 <fd2data>
  801f20:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f22:	83 c4 0c             	add    $0xc,%esp
  801f25:	68 07 04 00 00       	push   $0x407
  801f2a:	50                   	push   %eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	e8 90 ec ff ff       	call   800bc2 <sys_page_alloc>
  801f32:	89 c3                	mov    %eax,%ebx
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	0f 88 8c 00 00 00    	js     801fcb <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	ff 75 f0             	pushl  -0x10(%ebp)
  801f45:	e8 36 f1 ff ff       	call   801080 <fd2data>
  801f4a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f51:	50                   	push   %eax
  801f52:	6a 00                	push   $0x0
  801f54:	56                   	push   %esi
  801f55:	6a 00                	push   $0x0
  801f57:	e8 a9 ec ff ff       	call   800c05 <sys_page_map>
  801f5c:	89 c3                	mov    %eax,%ebx
  801f5e:	83 c4 20             	add    $0x20,%esp
  801f61:	85 c0                	test   %eax,%eax
  801f63:	78 58                	js     801fbd <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f6e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801f7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f83:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	e8 d6 f0 ff ff       	call   801070 <fd2num>
  801f9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f9f:	83 c4 04             	add    $0x4,%esp
  801fa2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa5:	e8 c6 f0 ff ff       	call   801070 <fd2num>
  801faa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fad:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fb0:	83 c4 10             	add    $0x10,%esp
  801fb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fb8:	e9 4f ff ff ff       	jmp    801f0c <pipe+0x75>
	sys_page_unmap(0, va);
  801fbd:	83 ec 08             	sub    $0x8,%esp
  801fc0:	56                   	push   %esi
  801fc1:	6a 00                	push   $0x0
  801fc3:	e8 7f ec ff ff       	call   800c47 <sys_page_unmap>
  801fc8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fcb:	83 ec 08             	sub    $0x8,%esp
  801fce:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd1:	6a 00                	push   $0x0
  801fd3:	e8 6f ec ff ff       	call   800c47 <sys_page_unmap>
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	e9 1c ff ff ff       	jmp    801efc <pipe+0x65>

00801fe0 <pipeisclosed>:
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe9:	50                   	push   %eax
  801fea:	ff 75 08             	pushl  0x8(%ebp)
  801fed:	e8 f4 f0 ff ff       	call   8010e6 <fd_lookup>
  801ff2:	83 c4 10             	add    $0x10,%esp
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	78 18                	js     802011 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fff:	e8 7c f0 ff ff       	call   801080 <fd2data>
	return _pipeisclosed(fd, p);
  802004:	89 c2                	mov    %eax,%edx
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	e8 30 fd ff ff       	call   801d3e <_pipeisclosed>
  80200e:	83 c4 10             	add    $0x10,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    

0080201d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802023:	68 b3 2b 80 00       	push   $0x802bb3
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	e8 99 e7 ff ff       	call   8007c9 <strcpy>
	return 0;
}
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <devcons_write>:
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	57                   	push   %edi
  80203b:	56                   	push   %esi
  80203c:	53                   	push   %ebx
  80203d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802043:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802048:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80204e:	eb 2f                	jmp    80207f <devcons_write+0x48>
		m = n - tot;
  802050:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802053:	29 f3                	sub    %esi,%ebx
  802055:	83 fb 7f             	cmp    $0x7f,%ebx
  802058:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80205d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	53                   	push   %ebx
  802064:	89 f0                	mov    %esi,%eax
  802066:	03 45 0c             	add    0xc(%ebp),%eax
  802069:	50                   	push   %eax
  80206a:	57                   	push   %edi
  80206b:	e8 e7 e8 ff ff       	call   800957 <memmove>
		sys_cputs(buf, m);
  802070:	83 c4 08             	add    $0x8,%esp
  802073:	53                   	push   %ebx
  802074:	57                   	push   %edi
  802075:	e8 8c ea ff ff       	call   800b06 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80207a:	01 de                	add    %ebx,%esi
  80207c:	83 c4 10             	add    $0x10,%esp
  80207f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802082:	72 cc                	jb     802050 <devcons_write+0x19>
}
  802084:	89 f0                	mov    %esi,%eax
  802086:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802089:	5b                   	pop    %ebx
  80208a:	5e                   	pop    %esi
  80208b:	5f                   	pop    %edi
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    

0080208e <devcons_read>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802099:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80209d:	75 07                	jne    8020a6 <devcons_read+0x18>
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    
		sys_yield();
  8020a1:	e8 fd ea ff ff       	call   800ba3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8020a6:	e8 79 ea ff ff       	call   800b24 <sys_cgetc>
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	74 f2                	je     8020a1 <devcons_read+0x13>
	if (c < 0)
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 ec                	js     80209f <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8020b3:	83 f8 04             	cmp    $0x4,%eax
  8020b6:	74 0c                	je     8020c4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	88 02                	mov    %al,(%edx)
	return 1;
  8020bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c2:	eb db                	jmp    80209f <devcons_read+0x11>
		return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c9:	eb d4                	jmp    80209f <devcons_read+0x11>

008020cb <cputchar>:
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020d7:	6a 01                	push   $0x1
  8020d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020dc:	50                   	push   %eax
  8020dd:	e8 24 ea ff ff       	call   800b06 <sys_cputs>
}
  8020e2:	83 c4 10             	add    $0x10,%esp
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <getchar>:
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020ed:	6a 01                	push   $0x1
  8020ef:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f2:	50                   	push   %eax
  8020f3:	6a 00                	push   $0x0
  8020f5:	e8 5d f2 ff ff       	call   801357 <read>
	if (r < 0)
  8020fa:	83 c4 10             	add    $0x10,%esp
  8020fd:	85 c0                	test   %eax,%eax
  8020ff:	78 08                	js     802109 <getchar+0x22>
	if (r < 1)
  802101:	85 c0                	test   %eax,%eax
  802103:	7e 06                	jle    80210b <getchar+0x24>
	return c;
  802105:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    
		return -E_EOF;
  80210b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802110:	eb f7                	jmp    802109 <getchar+0x22>

00802112 <iscons>:
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802118:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80211b:	50                   	push   %eax
  80211c:	ff 75 08             	pushl  0x8(%ebp)
  80211f:	e8 c2 ef ff ff       	call   8010e6 <fd_lookup>
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	78 11                	js     80213c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802134:	39 10                	cmp    %edx,(%eax)
  802136:	0f 94 c0             	sete   %al
  802139:	0f b6 c0             	movzbl %al,%eax
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <opencons>:
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802144:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802147:	50                   	push   %eax
  802148:	e8 4a ef ff ff       	call   801097 <fd_alloc>
  80214d:	83 c4 10             	add    $0x10,%esp
  802150:	85 c0                	test   %eax,%eax
  802152:	78 3a                	js     80218e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 07 04 00 00       	push   $0x407
  80215c:	ff 75 f4             	pushl  -0xc(%ebp)
  80215f:	6a 00                	push   $0x0
  802161:	e8 5c ea ff ff       	call   800bc2 <sys_page_alloc>
  802166:	83 c4 10             	add    $0x10,%esp
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 21                	js     80218e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802176:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802182:	83 ec 0c             	sub    $0xc,%esp
  802185:	50                   	push   %eax
  802186:	e8 e5 ee ff ff       	call   801070 <fd2num>
  80218b:	83 c4 10             	add    $0x10,%esp
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	56                   	push   %esi
  802194:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802195:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802198:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80219e:	e8 e1 e9 ff ff       	call   800b84 <sys_getenvid>
  8021a3:	83 ec 0c             	sub    $0xc,%esp
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	ff 75 08             	pushl  0x8(%ebp)
  8021ac:	56                   	push   %esi
  8021ad:	50                   	push   %eax
  8021ae:	68 c0 2b 80 00       	push   $0x802bc0
  8021b3:	e8 f2 df ff ff       	call   8001aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021b8:	83 c4 18             	add    $0x18,%esp
  8021bb:	53                   	push   %ebx
  8021bc:	ff 75 10             	pushl  0x10(%ebp)
  8021bf:	e8 95 df ff ff       	call   800159 <vcprintf>
	cprintf("\n");
  8021c4:	c7 04 24 74 26 80 00 	movl   $0x802674,(%esp)
  8021cb:	e8 da df ff ff       	call   8001aa <cprintf>
  8021d0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021d3:	cc                   	int3   
  8021d4:	eb fd                	jmp    8021d3 <_panic+0x43>

008021d6 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  8021dc:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8021e3:	74 0a                	je     8021ef <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  8021ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f4:	8b 40 48             	mov    0x48(%eax),%eax
  8021f7:	83 ec 04             	sub    $0x4,%esp
  8021fa:	6a 07                	push   $0x7
  8021fc:	68 00 f0 bf ee       	push   $0xeebff000
  802201:	50                   	push   %eax
  802202:	e8 bb e9 ff ff       	call   800bc2 <sys_page_alloc>
  802207:	83 c4 10             	add    $0x10,%esp
  80220a:	85 c0                	test   %eax,%eax
  80220c:	78 1b                	js     802229 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80220e:	a1 08 40 80 00       	mov    0x804008,%eax
  802213:	8b 40 48             	mov    0x48(%eax),%eax
  802216:	83 ec 08             	sub    $0x8,%esp
  802219:	68 3b 22 80 00       	push   $0x80223b
  80221e:	50                   	push   %eax
  80221f:	e8 e9 ea ff ff       	call   800d0d <sys_env_set_pgfault_upcall>
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	eb bc                	jmp    8021e5 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802229:	50                   	push   %eax
  80222a:	68 e4 2b 80 00       	push   $0x802be4
  80222f:	6a 22                	push   $0x22
  802231:	68 fc 2b 80 00       	push   $0x802bfc
  802236:	e8 55 ff ff ff       	call   802190 <_panic>

0080223b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80223b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80223c:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802241:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802243:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802246:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  80224a:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  80224d:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802251:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802255:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802257:	83 c4 08             	add    $0x8,%esp
	popal
  80225a:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80225b:	83 c4 04             	add    $0x4,%esp
	popfl
  80225e:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80225f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802260:	c3                   	ret    

00802261 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	56                   	push   %esi
  802265:	53                   	push   %ebx
  802266:	8b 75 08             	mov    0x8(%ebp),%esi
  802269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80226f:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802271:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802276:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802279:	83 ec 0c             	sub    $0xc,%esp
  80227c:	50                   	push   %eax
  80227d:	e8 f0 ea ff ff       	call   800d72 <sys_ipc_recv>
	if (from_env_store)
  802282:	83 c4 10             	add    $0x10,%esp
  802285:	85 f6                	test   %esi,%esi
  802287:	74 14                	je     80229d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802289:	ba 00 00 00 00       	mov    $0x0,%edx
  80228e:	85 c0                	test   %eax,%eax
  802290:	78 09                	js     80229b <ipc_recv+0x3a>
  802292:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802298:	8b 52 74             	mov    0x74(%edx),%edx
  80229b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80229d:	85 db                	test   %ebx,%ebx
  80229f:	74 14                	je     8022b5 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8022a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 09                	js     8022b3 <ipc_recv+0x52>
  8022aa:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8022b0:	8b 52 78             	mov    0x78(%edx),%edx
  8022b3:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	78 08                	js     8022c1 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8022b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022be:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8022c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    

008022c8 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	57                   	push   %edi
  8022cc:	56                   	push   %esi
  8022cd:	53                   	push   %ebx
  8022ce:	83 ec 0c             	sub    $0xc,%esp
  8022d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8022da:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8022dc:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022e1:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8022e4:	ff 75 14             	pushl  0x14(%ebp)
  8022e7:	53                   	push   %ebx
  8022e8:	56                   	push   %esi
  8022e9:	57                   	push   %edi
  8022ea:	e8 60 ea ff ff       	call   800d4f <sys_ipc_try_send>
		if (ret == 0)
  8022ef:	83 c4 10             	add    $0x10,%esp
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	74 1e                	je     802314 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8022f6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022f9:	75 07                	jne    802302 <ipc_send+0x3a>
			sys_yield();
  8022fb:	e8 a3 e8 ff ff       	call   800ba3 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802300:	eb e2                	jmp    8022e4 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802302:	50                   	push   %eax
  802303:	68 0a 2c 80 00       	push   $0x802c0a
  802308:	6a 3d                	push   $0x3d
  80230a:	68 1e 2c 80 00       	push   $0x802c1e
  80230f:	e8 7c fe ff ff       	call   802190 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802314:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802317:	5b                   	pop    %ebx
  802318:	5e                   	pop    %esi
  802319:	5f                   	pop    %edi
  80231a:	5d                   	pop    %ebp
  80231b:	c3                   	ret    

0080231c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802322:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802327:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80232a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802330:	8b 52 50             	mov    0x50(%edx),%edx
  802333:	39 ca                	cmp    %ecx,%edx
  802335:	74 11                	je     802348 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802337:	83 c0 01             	add    $0x1,%eax
  80233a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80233f:	75 e6                	jne    802327 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802341:	b8 00 00 00 00       	mov    $0x0,%eax
  802346:	eb 0b                	jmp    802353 <ipc_find_env+0x37>
			return envs[i].env_id;
  802348:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80234b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802350:	8b 40 48             	mov    0x48(%eax),%eax
}
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    

00802355 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80235b:	89 d0                	mov    %edx,%eax
  80235d:	c1 e8 16             	shr    $0x16,%eax
  802360:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80236c:	f6 c1 01             	test   $0x1,%cl
  80236f:	74 1d                	je     80238e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802371:	c1 ea 0c             	shr    $0xc,%edx
  802374:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80237b:	f6 c2 01             	test   $0x1,%dl
  80237e:	74 0e                	je     80238e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802380:	c1 ea 0c             	shr    $0xc,%edx
  802383:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80238a:	ef 
  80238b:	0f b7 c0             	movzwl %ax,%eax
}
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    

00802390 <__udivdi3>:
  802390:	55                   	push   %ebp
  802391:	57                   	push   %edi
  802392:	56                   	push   %esi
  802393:	53                   	push   %ebx
  802394:	83 ec 1c             	sub    $0x1c,%esp
  802397:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80239b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80239f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023a7:	85 d2                	test   %edx,%edx
  8023a9:	75 35                	jne    8023e0 <__udivdi3+0x50>
  8023ab:	39 f3                	cmp    %esi,%ebx
  8023ad:	0f 87 bd 00 00 00    	ja     802470 <__udivdi3+0xe0>
  8023b3:	85 db                	test   %ebx,%ebx
  8023b5:	89 d9                	mov    %ebx,%ecx
  8023b7:	75 0b                	jne    8023c4 <__udivdi3+0x34>
  8023b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023be:	31 d2                	xor    %edx,%edx
  8023c0:	f7 f3                	div    %ebx
  8023c2:	89 c1                	mov    %eax,%ecx
  8023c4:	31 d2                	xor    %edx,%edx
  8023c6:	89 f0                	mov    %esi,%eax
  8023c8:	f7 f1                	div    %ecx
  8023ca:	89 c6                	mov    %eax,%esi
  8023cc:	89 e8                	mov    %ebp,%eax
  8023ce:	89 f7                	mov    %esi,%edi
  8023d0:	f7 f1                	div    %ecx
  8023d2:	89 fa                	mov    %edi,%edx
  8023d4:	83 c4 1c             	add    $0x1c,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5f                   	pop    %edi
  8023da:	5d                   	pop    %ebp
  8023db:	c3                   	ret    
  8023dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023e0:	39 f2                	cmp    %esi,%edx
  8023e2:	77 7c                	ja     802460 <__udivdi3+0xd0>
  8023e4:	0f bd fa             	bsr    %edx,%edi
  8023e7:	83 f7 1f             	xor    $0x1f,%edi
  8023ea:	0f 84 98 00 00 00    	je     802488 <__udivdi3+0xf8>
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	d3 e6                	shl    %cl,%esi
  802421:	89 eb                	mov    %ebp,%ebx
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 0c                	jb     802447 <__udivdi3+0xb7>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 5d                	jae    8024a0 <__udivdi3+0x110>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	75 59                	jne    8024a0 <__udivdi3+0x110>
  802447:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80244a:	31 ff                	xor    %edi,%edi
  80244c:	89 fa                	mov    %edi,%edx
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d 76 00             	lea    0x0(%esi),%esi
  802459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802460:	31 ff                	xor    %edi,%edi
  802462:	31 c0                	xor    %eax,%eax
  802464:	89 fa                	mov    %edi,%edx
  802466:	83 c4 1c             	add    $0x1c,%esp
  802469:	5b                   	pop    %ebx
  80246a:	5e                   	pop    %esi
  80246b:	5f                   	pop    %edi
  80246c:	5d                   	pop    %ebp
  80246d:	c3                   	ret    
  80246e:	66 90                	xchg   %ax,%ax
  802470:	31 ff                	xor    %edi,%edi
  802472:	89 e8                	mov    %ebp,%eax
  802474:	89 f2                	mov    %esi,%edx
  802476:	f7 f3                	div    %ebx
  802478:	89 fa                	mov    %edi,%edx
  80247a:	83 c4 1c             	add    $0x1c,%esp
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5f                   	pop    %edi
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    
  802482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802488:	39 f2                	cmp    %esi,%edx
  80248a:	72 06                	jb     802492 <__udivdi3+0x102>
  80248c:	31 c0                	xor    %eax,%eax
  80248e:	39 eb                	cmp    %ebp,%ebx
  802490:	77 d2                	ja     802464 <__udivdi3+0xd4>
  802492:	b8 01 00 00 00       	mov    $0x1,%eax
  802497:	eb cb                	jmp    802464 <__udivdi3+0xd4>
  802499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a0:	89 d8                	mov    %ebx,%eax
  8024a2:	31 ff                	xor    %edi,%edi
  8024a4:	eb be                	jmp    802464 <__udivdi3+0xd4>
  8024a6:	66 90                	xchg   %ax,%ax
  8024a8:	66 90                	xchg   %ax,%ax
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__umoddi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8024bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024c7:	85 ed                	test   %ebp,%ebp
  8024c9:	89 f0                	mov    %esi,%eax
  8024cb:	89 da                	mov    %ebx,%edx
  8024cd:	75 19                	jne    8024e8 <__umoddi3+0x38>
  8024cf:	39 df                	cmp    %ebx,%edi
  8024d1:	0f 86 b1 00 00 00    	jbe    802588 <__umoddi3+0xd8>
  8024d7:	f7 f7                	div    %edi
  8024d9:	89 d0                	mov    %edx,%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	83 c4 1c             	add    $0x1c,%esp
  8024e0:	5b                   	pop    %ebx
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	39 dd                	cmp    %ebx,%ebp
  8024ea:	77 f1                	ja     8024dd <__umoddi3+0x2d>
  8024ec:	0f bd cd             	bsr    %ebp,%ecx
  8024ef:	83 f1 1f             	xor    $0x1f,%ecx
  8024f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024f6:	0f 84 b4 00 00 00    	je     8025b0 <__umoddi3+0x100>
  8024fc:	b8 20 00 00 00       	mov    $0x20,%eax
  802501:	89 c2                	mov    %eax,%edx
  802503:	8b 44 24 04          	mov    0x4(%esp),%eax
  802507:	29 c2                	sub    %eax,%edx
  802509:	89 c1                	mov    %eax,%ecx
  80250b:	89 f8                	mov    %edi,%eax
  80250d:	d3 e5                	shl    %cl,%ebp
  80250f:	89 d1                	mov    %edx,%ecx
  802511:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802515:	d3 e8                	shr    %cl,%eax
  802517:	09 c5                	or     %eax,%ebp
  802519:	8b 44 24 04          	mov    0x4(%esp),%eax
  80251d:	89 c1                	mov    %eax,%ecx
  80251f:	d3 e7                	shl    %cl,%edi
  802521:	89 d1                	mov    %edx,%ecx
  802523:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802527:	89 df                	mov    %ebx,%edi
  802529:	d3 ef                	shr    %cl,%edi
  80252b:	89 c1                	mov    %eax,%ecx
  80252d:	89 f0                	mov    %esi,%eax
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 d1                	mov    %edx,%ecx
  802533:	89 fa                	mov    %edi,%edx
  802535:	d3 e8                	shr    %cl,%eax
  802537:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	f7 f5                	div    %ebp
  802540:	d3 e6                	shl    %cl,%esi
  802542:	89 d1                	mov    %edx,%ecx
  802544:	f7 64 24 08          	mull   0x8(%esp)
  802548:	39 d1                	cmp    %edx,%ecx
  80254a:	89 c3                	mov    %eax,%ebx
  80254c:	89 d7                	mov    %edx,%edi
  80254e:	72 06                	jb     802556 <__umoddi3+0xa6>
  802550:	75 0e                	jne    802560 <__umoddi3+0xb0>
  802552:	39 c6                	cmp    %eax,%esi
  802554:	73 0a                	jae    802560 <__umoddi3+0xb0>
  802556:	2b 44 24 08          	sub    0x8(%esp),%eax
  80255a:	19 ea                	sbb    %ebp,%edx
  80255c:	89 d7                	mov    %edx,%edi
  80255e:	89 c3                	mov    %eax,%ebx
  802560:	89 ca                	mov    %ecx,%edx
  802562:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802567:	29 de                	sub    %ebx,%esi
  802569:	19 fa                	sbb    %edi,%edx
  80256b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80256f:	89 d0                	mov    %edx,%eax
  802571:	d3 e0                	shl    %cl,%eax
  802573:	89 d9                	mov    %ebx,%ecx
  802575:	d3 ee                	shr    %cl,%esi
  802577:	d3 ea                	shr    %cl,%edx
  802579:	09 f0                	or     %esi,%eax
  80257b:	83 c4 1c             	add    $0x1c,%esp
  80257e:	5b                   	pop    %ebx
  80257f:	5e                   	pop    %esi
  802580:	5f                   	pop    %edi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    
  802583:	90                   	nop
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	85 ff                	test   %edi,%edi
  80258a:	89 f9                	mov    %edi,%ecx
  80258c:	75 0b                	jne    802599 <__umoddi3+0xe9>
  80258e:	b8 01 00 00 00       	mov    $0x1,%eax
  802593:	31 d2                	xor    %edx,%edx
  802595:	f7 f7                	div    %edi
  802597:	89 c1                	mov    %eax,%ecx
  802599:	89 d8                	mov    %ebx,%eax
  80259b:	31 d2                	xor    %edx,%edx
  80259d:	f7 f1                	div    %ecx
  80259f:	89 f0                	mov    %esi,%eax
  8025a1:	f7 f1                	div    %ecx
  8025a3:	e9 31 ff ff ff       	jmp    8024d9 <__umoddi3+0x29>
  8025a8:	90                   	nop
  8025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	39 dd                	cmp    %ebx,%ebp
  8025b2:	72 08                	jb     8025bc <__umoddi3+0x10c>
  8025b4:	39 f7                	cmp    %esi,%edi
  8025b6:	0f 87 21 ff ff ff    	ja     8024dd <__umoddi3+0x2d>
  8025bc:	89 da                	mov    %ebx,%edx
  8025be:	89 f0                	mov    %esi,%eax
  8025c0:	29 f8                	sub    %edi,%eax
  8025c2:	19 ea                	sbb    %ebp,%edx
  8025c4:	e9 14 ff ff ff       	jmp    8024dd <__umoddi3+0x2d>

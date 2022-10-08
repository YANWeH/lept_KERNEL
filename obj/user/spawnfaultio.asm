
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 4a 00 00 00       	call   80007b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 40 80 00       	mov    0x804008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	50                   	push   %eax
  800042:	68 80 28 80 00       	push   $0x802880
  800047:	e8 6a 01 00 00       	call   8001b6 <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  80004c:	83 c4 0c             	add    $0xc,%esp
  80004f:	6a 00                	push   $0x0
  800051:	68 9e 28 80 00       	push   $0x80289e
  800056:	68 9e 28 80 00       	push   $0x80289e
  80005b:	e8 e9 1a 00 00       	call   801b49 <spawnl>
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	85 c0                	test   %eax,%eax
  800065:	78 02                	js     800069 <umain+0x36>
		panic("spawn(faultio) failed: %e", r);
}
  800067:	c9                   	leave  
  800068:	c3                   	ret    
		panic("spawn(faultio) failed: %e", r);
  800069:	50                   	push   %eax
  80006a:	68 a6 28 80 00       	push   $0x8028a6
  80006f:	6a 09                	push   $0x9
  800071:	68 c0 28 80 00       	push   $0x8028c0
  800076:	e8 60 00 00 00       	call   8000db <_panic>

0080007b <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80007b:	55                   	push   %ebp
  80007c:	89 e5                	mov    %esp,%ebp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800083:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800086:	e8 05 0b 00 00       	call   800b90 <sys_getenvid>
  80008b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800090:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800093:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800098:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	85 db                	test   %ebx,%ebx
  80009f:	7e 07                	jle    8000a8 <libmain+0x2d>
		binaryname = argv[0];
  8000a1:	8b 06                	mov    (%esi),%eax
  8000a3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a8:	83 ec 08             	sub    $0x8,%esp
  8000ab:	56                   	push   %esi
  8000ac:	53                   	push   %ebx
  8000ad:	e8 81 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b2:	e8 0a 00 00 00       	call   8000c1 <exit>
}
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000bd:	5b                   	pop    %ebx
  8000be:	5e                   	pop    %esi
  8000bf:	5d                   	pop    %ebp
  8000c0:	c3                   	ret    

008000c1 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000c1:	55                   	push   %ebp
  8000c2:	89 e5                	mov    %esp,%ebp
  8000c4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000c7:	e8 e8 0e 00 00       	call   800fb4 <close_all>
	sys_env_destroy(0);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 00                	push   $0x0
  8000d1:	e8 79 0a 00 00       	call   800b4f <sys_env_destroy>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	56                   	push   %esi
  8000df:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8000e0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000e3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8000e9:	e8 a2 0a 00 00       	call   800b90 <sys_getenvid>
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 0c             	pushl  0xc(%ebp)
  8000f4:	ff 75 08             	pushl  0x8(%ebp)
  8000f7:	56                   	push   %esi
  8000f8:	50                   	push   %eax
  8000f9:	68 e0 28 80 00       	push   $0x8028e0
  8000fe:	e8 b3 00 00 00       	call   8001b6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800103:	83 c4 18             	add    $0x18,%esp
  800106:	53                   	push   %ebx
  800107:	ff 75 10             	pushl  0x10(%ebp)
  80010a:	e8 56 00 00 00       	call   800165 <vcprintf>
	cprintf("\n");
  80010f:	c7 04 24 f5 2d 80 00 	movl   $0x802df5,(%esp)
  800116:	e8 9b 00 00 00       	call   8001b6 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80011e:	cc                   	int3   
  80011f:	eb fd                	jmp    80011e <_panic+0x43>

00800121 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800121:	55                   	push   %ebp
  800122:	89 e5                	mov    %esp,%ebp
  800124:	53                   	push   %ebx
  800125:	83 ec 04             	sub    $0x4,%esp
  800128:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012b:	8b 13                	mov    (%ebx),%edx
  80012d:	8d 42 01             	lea    0x1(%edx),%eax
  800130:	89 03                	mov    %eax,(%ebx)
  800132:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800135:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800139:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013e:	74 09                	je     800149 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800140:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800144:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800147:	c9                   	leave  
  800148:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 ff 00 00 00       	push   $0xff
  800151:	8d 43 08             	lea    0x8(%ebx),%eax
  800154:	50                   	push   %eax
  800155:	e8 b8 09 00 00       	call   800b12 <sys_cputs>
		b->idx = 0;
  80015a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800160:	83 c4 10             	add    $0x10,%esp
  800163:	eb db                	jmp    800140 <putch+0x1f>

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018e:	50                   	push   %eax
  80018f:	68 21 01 80 00       	push   $0x800121
  800194:	e8 1a 01 00 00       	call   8002b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800199:	83 c4 08             	add    $0x8,%esp
  80019c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a8:	50                   	push   %eax
  8001a9:	e8 64 09 00 00       	call   800b12 <sys_cputs>

	return b.cnt;
}
  8001ae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    

008001b6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b6:	55                   	push   %ebp
  8001b7:	89 e5                	mov    %esp,%ebp
  8001b9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001bf:	50                   	push   %eax
  8001c0:	ff 75 08             	pushl  0x8(%ebp)
  8001c3:	e8 9d ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c8:	c9                   	leave  
  8001c9:	c3                   	ret    

008001ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 1c             	sub    $0x1c,%esp
  8001d3:	89 c7                	mov    %eax,%edi
  8001d5:	89 d6                	mov    %edx,%esi
  8001d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001eb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ee:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f1:	39 d3                	cmp    %edx,%ebx
  8001f3:	72 05                	jb     8001fa <printnum+0x30>
  8001f5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f8:	77 7a                	ja     800274 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001fa:	83 ec 0c             	sub    $0xc,%esp
  8001fd:	ff 75 18             	pushl  0x18(%ebp)
  800200:	8b 45 14             	mov    0x14(%ebp),%eax
  800203:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800206:	53                   	push   %ebx
  800207:	ff 75 10             	pushl  0x10(%ebp)
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800210:	ff 75 e0             	pushl  -0x20(%ebp)
  800213:	ff 75 dc             	pushl  -0x24(%ebp)
  800216:	ff 75 d8             	pushl  -0x28(%ebp)
  800219:	e8 12 24 00 00       	call   802630 <__udivdi3>
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	52                   	push   %edx
  800222:	50                   	push   %eax
  800223:	89 f2                	mov    %esi,%edx
  800225:	89 f8                	mov    %edi,%eax
  800227:	e8 9e ff ff ff       	call   8001ca <printnum>
  80022c:	83 c4 20             	add    $0x20,%esp
  80022f:	eb 13                	jmp    800244 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	56                   	push   %esi
  800235:	ff 75 18             	pushl  0x18(%ebp)
  800238:	ff d7                	call   *%edi
  80023a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023d:	83 eb 01             	sub    $0x1,%ebx
  800240:	85 db                	test   %ebx,%ebx
  800242:	7f ed                	jg     800231 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	56                   	push   %esi
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024e:	ff 75 e0             	pushl  -0x20(%ebp)
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	e8 f4 24 00 00       	call   802750 <__umoddi3>
  80025c:	83 c4 14             	add    $0x14,%esp
  80025f:	0f be 80 03 29 80 00 	movsbl 0x802903(%eax),%eax
  800266:	50                   	push   %eax
  800267:	ff d7                	call   *%edi
}
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026f:	5b                   	pop    %ebx
  800270:	5e                   	pop    %esi
  800271:	5f                   	pop    %edi
  800272:	5d                   	pop    %ebp
  800273:	c3                   	ret    
  800274:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800277:	eb c4                	jmp    80023d <printnum+0x73>

00800279 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800283:	8b 10                	mov    (%eax),%edx
  800285:	3b 50 04             	cmp    0x4(%eax),%edx
  800288:	73 0a                	jae    800294 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028d:	89 08                	mov    %ecx,(%eax)
  80028f:	8b 45 08             	mov    0x8(%ebp),%eax
  800292:	88 02                	mov    %al,(%edx)
}
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <printfmt>:
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029f:	50                   	push   %eax
  8002a0:	ff 75 10             	pushl  0x10(%ebp)
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 05 00 00 00       	call   8002b3 <vprintfmt>
}
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	c9                   	leave  
  8002b2:	c3                   	ret    

008002b3 <vprintfmt>:
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	57                   	push   %edi
  8002b7:	56                   	push   %esi
  8002b8:	53                   	push   %ebx
  8002b9:	83 ec 2c             	sub    $0x2c,%esp
  8002bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c5:	e9 c1 03 00 00       	jmp    80068b <vprintfmt+0x3d8>
		padc = ' ';
  8002ca:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ce:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002dc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8d 47 01             	lea    0x1(%edi),%eax
  8002eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ee:	0f b6 17             	movzbl (%edi),%edx
  8002f1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f4:	3c 55                	cmp    $0x55,%al
  8002f6:	0f 87 12 04 00 00    	ja     80070e <vprintfmt+0x45b>
  8002fc:	0f b6 c0             	movzbl %al,%eax
  8002ff:	ff 24 85 40 2a 80 00 	jmp    *0x802a40(,%eax,4)
  800306:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800309:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030d:	eb d9                	jmp    8002e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800312:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800316:	eb d0                	jmp    8002e8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800318:	0f b6 d2             	movzbl %dl,%edx
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
  800323:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800326:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800329:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800330:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800333:	83 f9 09             	cmp    $0x9,%ecx
  800336:	77 55                	ja     80038d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800338:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033b:	eb e9                	jmp    800326 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800345:	8b 45 14             	mov    0x14(%ebp),%eax
  800348:	8d 40 04             	lea    0x4(%eax),%eax
  80034b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800351:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800355:	79 91                	jns    8002e8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800357:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800364:	eb 82                	jmp    8002e8 <vprintfmt+0x35>
  800366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800369:	85 c0                	test   %eax,%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	0f 49 d0             	cmovns %eax,%edx
  800373:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800379:	e9 6a ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
  80037e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800381:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800388:	e9 5b ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
  80038d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800390:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800393:	eb bc                	jmp    800351 <vprintfmt+0x9e>
			lflag++;
  800395:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039b:	e9 48 ff ff ff       	jmp    8002e8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a3:	8d 78 04             	lea    0x4(%eax),%edi
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	53                   	push   %ebx
  8003aa:	ff 30                	pushl  (%eax)
  8003ac:	ff d6                	call   *%esi
			break;
  8003ae:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b4:	e9 cf 02 00 00       	jmp    800688 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8d 78 04             	lea    0x4(%eax),%edi
  8003bf:	8b 00                	mov    (%eax),%eax
  8003c1:	99                   	cltd   
  8003c2:	31 d0                	xor    %edx,%eax
  8003c4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c6:	83 f8 0f             	cmp    $0xf,%eax
  8003c9:	7f 23                	jg     8003ee <vprintfmt+0x13b>
  8003cb:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  8003d2:	85 d2                	test   %edx,%edx
  8003d4:	74 18                	je     8003ee <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003d6:	52                   	push   %edx
  8003d7:	68 d5 2c 80 00       	push   $0x802cd5
  8003dc:	53                   	push   %ebx
  8003dd:	56                   	push   %esi
  8003de:	e8 b3 fe ff ff       	call   800296 <printfmt>
  8003e3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e9:	e9 9a 02 00 00       	jmp    800688 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003ee:	50                   	push   %eax
  8003ef:	68 1b 29 80 00       	push   $0x80291b
  8003f4:	53                   	push   %ebx
  8003f5:	56                   	push   %esi
  8003f6:	e8 9b fe ff ff       	call   800296 <printfmt>
  8003fb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fe:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800401:	e9 82 02 00 00       	jmp    800688 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	83 c0 04             	add    $0x4,%eax
  80040c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040f:	8b 45 14             	mov    0x14(%ebp),%eax
  800412:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800414:	85 ff                	test   %edi,%edi
  800416:	b8 14 29 80 00       	mov    $0x802914,%eax
  80041b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80041e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800422:	0f 8e bd 00 00 00    	jle    8004e5 <vprintfmt+0x232>
  800428:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80042c:	75 0e                	jne    80043c <vprintfmt+0x189>
  80042e:	89 75 08             	mov    %esi,0x8(%ebp)
  800431:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800434:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800437:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80043a:	eb 6d                	jmp    8004a9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 d0             	pushl  -0x30(%ebp)
  800442:	57                   	push   %edi
  800443:	e8 6e 03 00 00       	call   8007b6 <strnlen>
  800448:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044b:	29 c1                	sub    %eax,%ecx
  80044d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800450:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800453:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800457:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80045a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80045d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045f:	eb 0f                	jmp    800470 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	53                   	push   %ebx
  800465:	ff 75 e0             	pushl  -0x20(%ebp)
  800468:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80046a:	83 ef 01             	sub    $0x1,%edi
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	85 ff                	test   %edi,%edi
  800472:	7f ed                	jg     800461 <vprintfmt+0x1ae>
  800474:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800477:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80047a:	85 c9                	test   %ecx,%ecx
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	0f 49 c1             	cmovns %ecx,%eax
  800484:	29 c1                	sub    %eax,%ecx
  800486:	89 75 08             	mov    %esi,0x8(%ebp)
  800489:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048f:	89 cb                	mov    %ecx,%ebx
  800491:	eb 16                	jmp    8004a9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800493:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800497:	75 31                	jne    8004ca <vprintfmt+0x217>
					putch(ch, putdat);
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	ff 75 0c             	pushl  0xc(%ebp)
  80049f:	50                   	push   %eax
  8004a0:	ff 55 08             	call   *0x8(%ebp)
  8004a3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a6:	83 eb 01             	sub    $0x1,%ebx
  8004a9:	83 c7 01             	add    $0x1,%edi
  8004ac:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004b0:	0f be c2             	movsbl %dl,%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	74 59                	je     800510 <vprintfmt+0x25d>
  8004b7:	85 f6                	test   %esi,%esi
  8004b9:	78 d8                	js     800493 <vprintfmt+0x1e0>
  8004bb:	83 ee 01             	sub    $0x1,%esi
  8004be:	79 d3                	jns    800493 <vprintfmt+0x1e0>
  8004c0:	89 df                	mov    %ebx,%edi
  8004c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c8:	eb 37                	jmp    800501 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ca:	0f be d2             	movsbl %dl,%edx
  8004cd:	83 ea 20             	sub    $0x20,%edx
  8004d0:	83 fa 5e             	cmp    $0x5e,%edx
  8004d3:	76 c4                	jbe    800499 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004d5:	83 ec 08             	sub    $0x8,%esp
  8004d8:	ff 75 0c             	pushl  0xc(%ebp)
  8004db:	6a 3f                	push   $0x3f
  8004dd:	ff 55 08             	call   *0x8(%ebp)
  8004e0:	83 c4 10             	add    $0x10,%esp
  8004e3:	eb c1                	jmp    8004a6 <vprintfmt+0x1f3>
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f1:	eb b6                	jmp    8004a9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	6a 20                	push   $0x20
  8004f9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fb:	83 ef 01             	sub    $0x1,%edi
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	85 ff                	test   %edi,%edi
  800503:	7f ee                	jg     8004f3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800505:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800508:	89 45 14             	mov    %eax,0x14(%ebp)
  80050b:	e9 78 01 00 00       	jmp    800688 <vprintfmt+0x3d5>
  800510:	89 df                	mov    %ebx,%edi
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	eb e7                	jmp    800501 <vprintfmt+0x24e>
	if (lflag >= 2)
  80051a:	83 f9 01             	cmp    $0x1,%ecx
  80051d:	7e 3f                	jle    80055e <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80051f:	8b 45 14             	mov    0x14(%ebp),%eax
  800522:	8b 50 04             	mov    0x4(%eax),%edx
  800525:	8b 00                	mov    (%eax),%eax
  800527:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8d 40 08             	lea    0x8(%eax),%eax
  800533:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800536:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80053a:	79 5c                	jns    800598 <vprintfmt+0x2e5>
				putch('-', putdat);
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	53                   	push   %ebx
  800540:	6a 2d                	push   $0x2d
  800542:	ff d6                	call   *%esi
				num = -(long long) num;
  800544:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800547:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80054a:	f7 da                	neg    %edx
  80054c:	83 d1 00             	adc    $0x0,%ecx
  80054f:	f7 d9                	neg    %ecx
  800551:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800554:	b8 0a 00 00 00       	mov    $0xa,%eax
  800559:	e9 10 01 00 00       	jmp    80066e <vprintfmt+0x3bb>
	else if (lflag)
  80055e:	85 c9                	test   %ecx,%ecx
  800560:	75 1b                	jne    80057d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800562:	8b 45 14             	mov    0x14(%ebp),%eax
  800565:	8b 00                	mov    (%eax),%eax
  800567:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056a:	89 c1                	mov    %eax,%ecx
  80056c:	c1 f9 1f             	sar    $0x1f,%ecx
  80056f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8d 40 04             	lea    0x4(%eax),%eax
  800578:	89 45 14             	mov    %eax,0x14(%ebp)
  80057b:	eb b9                	jmp    800536 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	89 c1                	mov    %eax,%ecx
  800587:	c1 f9 1f             	sar    $0x1f,%ecx
  80058a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb 9e                	jmp    800536 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800598:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059e:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a3:	e9 c6 00 00 00       	jmp    80066e <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7e 18                	jle    8005c5 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b5:	8d 40 08             	lea    0x8(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c0:	e9 a9 00 00 00       	jmp    80066e <vprintfmt+0x3bb>
	else if (lflag)
  8005c5:	85 c9                	test   %ecx,%ecx
  8005c7:	75 1a                	jne    8005e3 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8b 10                	mov    (%eax),%edx
  8005ce:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d3:	8d 40 04             	lea    0x4(%eax),%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005de:	e9 8b 00 00 00       	jmp    80066e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 10                	mov    (%eax),%edx
  8005e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	eb 74                	jmp    80066e <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005fa:	83 f9 01             	cmp    $0x1,%ecx
  8005fd:	7e 15                	jle    800614 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8b 10                	mov    (%eax),%edx
  800604:	8b 48 04             	mov    0x4(%eax),%ecx
  800607:	8d 40 08             	lea    0x8(%eax),%eax
  80060a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060d:	b8 08 00 00 00       	mov    $0x8,%eax
  800612:	eb 5a                	jmp    80066e <vprintfmt+0x3bb>
	else if (lflag)
  800614:	85 c9                	test   %ecx,%ecx
  800616:	75 17                	jne    80062f <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	8b 10                	mov    (%eax),%edx
  80061d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800628:	b8 08 00 00 00       	mov    $0x8,%eax
  80062d:	eb 3f                	jmp    80066e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 10                	mov    (%eax),%edx
  800634:	b9 00 00 00 00       	mov    $0x0,%ecx
  800639:	8d 40 04             	lea    0x4(%eax),%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063f:	b8 08 00 00 00       	mov    $0x8,%eax
  800644:	eb 28                	jmp    80066e <vprintfmt+0x3bb>
			putch('0', putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	53                   	push   %ebx
  80064a:	6a 30                	push   $0x30
  80064c:	ff d6                	call   *%esi
			putch('x', putdat);
  80064e:	83 c4 08             	add    $0x8,%esp
  800651:	53                   	push   %ebx
  800652:	6a 78                	push   $0x78
  800654:	ff d6                	call   *%esi
			num = (unsigned long long)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8b 10                	mov    (%eax),%edx
  80065b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800660:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800663:	8d 40 04             	lea    0x4(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800669:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80066e:	83 ec 0c             	sub    $0xc,%esp
  800671:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800675:	57                   	push   %edi
  800676:	ff 75 e0             	pushl  -0x20(%ebp)
  800679:	50                   	push   %eax
  80067a:	51                   	push   %ecx
  80067b:	52                   	push   %edx
  80067c:	89 da                	mov    %ebx,%edx
  80067e:	89 f0                	mov    %esi,%eax
  800680:	e8 45 fb ff ff       	call   8001ca <printnum>
			break;
  800685:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800688:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068b:	83 c7 01             	add    $0x1,%edi
  80068e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800692:	83 f8 25             	cmp    $0x25,%eax
  800695:	0f 84 2f fc ff ff    	je     8002ca <vprintfmt+0x17>
			if (ch == '\0')
  80069b:	85 c0                	test   %eax,%eax
  80069d:	0f 84 8b 00 00 00    	je     80072e <vprintfmt+0x47b>
			putch(ch, putdat);
  8006a3:	83 ec 08             	sub    $0x8,%esp
  8006a6:	53                   	push   %ebx
  8006a7:	50                   	push   %eax
  8006a8:	ff d6                	call   *%esi
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	eb dc                	jmp    80068b <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006af:	83 f9 01             	cmp    $0x1,%ecx
  8006b2:	7e 15                	jle    8006c9 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8b 10                	mov    (%eax),%edx
  8006b9:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bc:	8d 40 08             	lea    0x8(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c7:	eb a5                	jmp    80066e <vprintfmt+0x3bb>
	else if (lflag)
  8006c9:	85 c9                	test   %ecx,%ecx
  8006cb:	75 17                	jne    8006e4 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d0:	8b 10                	mov    (%eax),%edx
  8006d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d7:	8d 40 04             	lea    0x4(%eax),%eax
  8006da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e2:	eb 8a                	jmp    80066e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f9:	e9 70 ff ff ff       	jmp    80066e <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	53                   	push   %ebx
  800702:	6a 25                	push   $0x25
  800704:	ff d6                	call   *%esi
			break;
  800706:	83 c4 10             	add    $0x10,%esp
  800709:	e9 7a ff ff ff       	jmp    800688 <vprintfmt+0x3d5>
			putch('%', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 25                	push   $0x25
  800714:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	89 f8                	mov    %edi,%eax
  80071b:	eb 03                	jmp    800720 <vprintfmt+0x46d>
  80071d:	83 e8 01             	sub    $0x1,%eax
  800720:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800724:	75 f7                	jne    80071d <vprintfmt+0x46a>
  800726:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800729:	e9 5a ff ff ff       	jmp    800688 <vprintfmt+0x3d5>
}
  80072e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800731:	5b                   	pop    %ebx
  800732:	5e                   	pop    %esi
  800733:	5f                   	pop    %edi
  800734:	5d                   	pop    %ebp
  800735:	c3                   	ret    

00800736 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800742:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800745:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800749:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80074c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800753:	85 c0                	test   %eax,%eax
  800755:	74 26                	je     80077d <vsnprintf+0x47>
  800757:	85 d2                	test   %edx,%edx
  800759:	7e 22                	jle    80077d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80075b:	ff 75 14             	pushl  0x14(%ebp)
  80075e:	ff 75 10             	pushl  0x10(%ebp)
  800761:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 79 02 80 00       	push   $0x800279
  80076a:	e8 44 fb ff ff       	call   8002b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80076f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800772:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800778:	83 c4 10             	add    $0x10,%esp
}
  80077b:	c9                   	leave  
  80077c:	c3                   	ret    
		return -E_INVAL;
  80077d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800782:	eb f7                	jmp    80077b <vsnprintf+0x45>

00800784 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80078a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80078d:	50                   	push   %eax
  80078e:	ff 75 10             	pushl  0x10(%ebp)
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	ff 75 08             	pushl  0x8(%ebp)
  800797:	e8 9a ff ff ff       	call   800736 <vsnprintf>
	va_end(ap);

	return rc;
}
  80079c:	c9                   	leave  
  80079d:	c3                   	ret    

0080079e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a9:	eb 03                	jmp    8007ae <strlen+0x10>
		n++;
  8007ab:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007ae:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b2:	75 f7                	jne    8007ab <strlen+0xd>
	return n;
}
  8007b4:	5d                   	pop    %ebp
  8007b5:	c3                   	ret    

008007b6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bc:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	eb 03                	jmp    8007c9 <strnlen+0x13>
		n++;
  8007c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c9:	39 d0                	cmp    %edx,%eax
  8007cb:	74 06                	je     8007d3 <strnlen+0x1d>
  8007cd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d1:	75 f3                	jne    8007c6 <strnlen+0x10>
	return n;
}
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	53                   	push   %ebx
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007df:	89 c2                	mov    %eax,%edx
  8007e1:	83 c1 01             	add    $0x1,%ecx
  8007e4:	83 c2 01             	add    $0x1,%edx
  8007e7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007eb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ee:	84 db                	test   %bl,%bl
  8007f0:	75 ef                	jne    8007e1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f2:	5b                   	pop    %ebx
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	53                   	push   %ebx
  8007f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fc:	53                   	push   %ebx
  8007fd:	e8 9c ff ff ff       	call   80079e <strlen>
  800802:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800805:	ff 75 0c             	pushl  0xc(%ebp)
  800808:	01 d8                	add    %ebx,%eax
  80080a:	50                   	push   %eax
  80080b:	e8 c5 ff ff ff       	call   8007d5 <strcpy>
	return dst;
}
  800810:	89 d8                	mov    %ebx,%eax
  800812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800815:	c9                   	leave  
  800816:	c3                   	ret    

00800817 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	56                   	push   %esi
  80081b:	53                   	push   %ebx
  80081c:	8b 75 08             	mov    0x8(%ebp),%esi
  80081f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800822:	89 f3                	mov    %esi,%ebx
  800824:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800827:	89 f2                	mov    %esi,%edx
  800829:	eb 0f                	jmp    80083a <strncpy+0x23>
		*dst++ = *src;
  80082b:	83 c2 01             	add    $0x1,%edx
  80082e:	0f b6 01             	movzbl (%ecx),%eax
  800831:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800834:	80 39 01             	cmpb   $0x1,(%ecx)
  800837:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80083a:	39 da                	cmp    %ebx,%edx
  80083c:	75 ed                	jne    80082b <strncpy+0x14>
	}
	return ret;
}
  80083e:	89 f0                	mov    %esi,%eax
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5d                   	pop    %ebp
  800843:	c3                   	ret    

00800844 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800844:	55                   	push   %ebp
  800845:	89 e5                	mov    %esp,%ebp
  800847:	56                   	push   %esi
  800848:	53                   	push   %ebx
  800849:	8b 75 08             	mov    0x8(%ebp),%esi
  80084c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800852:	89 f0                	mov    %esi,%eax
  800854:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800858:	85 c9                	test   %ecx,%ecx
  80085a:	75 0b                	jne    800867 <strlcpy+0x23>
  80085c:	eb 17                	jmp    800875 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80085e:	83 c2 01             	add    $0x1,%edx
  800861:	83 c0 01             	add    $0x1,%eax
  800864:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800867:	39 d8                	cmp    %ebx,%eax
  800869:	74 07                	je     800872 <strlcpy+0x2e>
  80086b:	0f b6 0a             	movzbl (%edx),%ecx
  80086e:	84 c9                	test   %cl,%cl
  800870:	75 ec                	jne    80085e <strlcpy+0x1a>
		*dst = '\0';
  800872:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800875:	29 f0                	sub    %esi,%eax
}
  800877:	5b                   	pop    %ebx
  800878:	5e                   	pop    %esi
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800884:	eb 06                	jmp    80088c <strcmp+0x11>
		p++, q++;
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80088c:	0f b6 01             	movzbl (%ecx),%eax
  80088f:	84 c0                	test   %al,%al
  800891:	74 04                	je     800897 <strcmp+0x1c>
  800893:	3a 02                	cmp    (%edx),%al
  800895:	74 ef                	je     800886 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800897:	0f b6 c0             	movzbl %al,%eax
  80089a:	0f b6 12             	movzbl (%edx),%edx
  80089d:	29 d0                	sub    %edx,%eax
}
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	53                   	push   %ebx
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ab:	89 c3                	mov    %eax,%ebx
  8008ad:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b0:	eb 06                	jmp    8008b8 <strncmp+0x17>
		n--, p++, q++;
  8008b2:	83 c0 01             	add    $0x1,%eax
  8008b5:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b8:	39 d8                	cmp    %ebx,%eax
  8008ba:	74 16                	je     8008d2 <strncmp+0x31>
  8008bc:	0f b6 08             	movzbl (%eax),%ecx
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	74 04                	je     8008c7 <strncmp+0x26>
  8008c3:	3a 0a                	cmp    (%edx),%cl
  8008c5:	74 eb                	je     8008b2 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c7:	0f b6 00             	movzbl (%eax),%eax
  8008ca:	0f b6 12             	movzbl (%edx),%edx
  8008cd:	29 d0                	sub    %edx,%eax
}
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d7:	eb f6                	jmp    8008cf <strncmp+0x2e>

008008d9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d9:	55                   	push   %ebp
  8008da:	89 e5                	mov    %esp,%ebp
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e3:	0f b6 10             	movzbl (%eax),%edx
  8008e6:	84 d2                	test   %dl,%dl
  8008e8:	74 09                	je     8008f3 <strchr+0x1a>
		if (*s == c)
  8008ea:	38 ca                	cmp    %cl,%dl
  8008ec:	74 0a                	je     8008f8 <strchr+0x1f>
	for (; *s; s++)
  8008ee:	83 c0 01             	add    $0x1,%eax
  8008f1:	eb f0                	jmp    8008e3 <strchr+0xa>
			return (char *) s;
	return 0;
  8008f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800904:	eb 03                	jmp    800909 <strfind+0xf>
  800906:	83 c0 01             	add    $0x1,%eax
  800909:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090c:	38 ca                	cmp    %cl,%dl
  80090e:	74 04                	je     800914 <strfind+0x1a>
  800910:	84 d2                	test   %dl,%dl
  800912:	75 f2                	jne    800906 <strfind+0xc>
			break;
	return (char *) s;
}
  800914:	5d                   	pop    %ebp
  800915:	c3                   	ret    

00800916 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	57                   	push   %edi
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80091f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800922:	85 c9                	test   %ecx,%ecx
  800924:	74 13                	je     800939 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800926:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092c:	75 05                	jne    800933 <memset+0x1d>
  80092e:	f6 c1 03             	test   $0x3,%cl
  800931:	74 0d                	je     800940 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	fc                   	cld    
  800937:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800939:	89 f8                	mov    %edi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5f                   	pop    %edi
  80093e:	5d                   	pop    %ebp
  80093f:	c3                   	ret    
		c &= 0xFF;
  800940:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800944:	89 d3                	mov    %edx,%ebx
  800946:	c1 e3 08             	shl    $0x8,%ebx
  800949:	89 d0                	mov    %edx,%eax
  80094b:	c1 e0 18             	shl    $0x18,%eax
  80094e:	89 d6                	mov    %edx,%esi
  800950:	c1 e6 10             	shl    $0x10,%esi
  800953:	09 f0                	or     %esi,%eax
  800955:	09 c2                	or     %eax,%edx
  800957:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800959:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80095c:	89 d0                	mov    %edx,%eax
  80095e:	fc                   	cld    
  80095f:	f3 ab                	rep stos %eax,%es:(%edi)
  800961:	eb d6                	jmp    800939 <memset+0x23>

00800963 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	57                   	push   %edi
  800967:	56                   	push   %esi
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800971:	39 c6                	cmp    %eax,%esi
  800973:	73 35                	jae    8009aa <memmove+0x47>
  800975:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800978:	39 c2                	cmp    %eax,%edx
  80097a:	76 2e                	jbe    8009aa <memmove+0x47>
		s += n;
		d += n;
  80097c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097f:	89 d6                	mov    %edx,%esi
  800981:	09 fe                	or     %edi,%esi
  800983:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800989:	74 0c                	je     800997 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80098b:	83 ef 01             	sub    $0x1,%edi
  80098e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800991:	fd                   	std    
  800992:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800994:	fc                   	cld    
  800995:	eb 21                	jmp    8009b8 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800997:	f6 c1 03             	test   $0x3,%cl
  80099a:	75 ef                	jne    80098b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80099c:	83 ef 04             	sub    $0x4,%edi
  80099f:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a8:	eb ea                	jmp    800994 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009aa:	89 f2                	mov    %esi,%edx
  8009ac:	09 c2                	or     %eax,%edx
  8009ae:	f6 c2 03             	test   $0x3,%dl
  8009b1:	74 09                	je     8009bc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009b3:	89 c7                	mov    %eax,%edi
  8009b5:	fc                   	cld    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b8:	5e                   	pop    %esi
  8009b9:	5f                   	pop    %edi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bc:	f6 c1 03             	test   $0x3,%cl
  8009bf:	75 f2                	jne    8009b3 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c4:	89 c7                	mov    %eax,%edi
  8009c6:	fc                   	cld    
  8009c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c9:	eb ed                	jmp    8009b8 <memmove+0x55>

008009cb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009ce:	ff 75 10             	pushl  0x10(%ebp)
  8009d1:	ff 75 0c             	pushl  0xc(%ebp)
  8009d4:	ff 75 08             	pushl  0x8(%ebp)
  8009d7:	e8 87 ff ff ff       	call   800963 <memmove>
}
  8009dc:	c9                   	leave  
  8009dd:	c3                   	ret    

008009de <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	56                   	push   %esi
  8009e2:	53                   	push   %ebx
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e9:	89 c6                	mov    %eax,%esi
  8009eb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ee:	39 f0                	cmp    %esi,%eax
  8009f0:	74 1c                	je     800a0e <memcmp+0x30>
		if (*s1 != *s2)
  8009f2:	0f b6 08             	movzbl (%eax),%ecx
  8009f5:	0f b6 1a             	movzbl (%edx),%ebx
  8009f8:	38 d9                	cmp    %bl,%cl
  8009fa:	75 08                	jne    800a04 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009fc:	83 c0 01             	add    $0x1,%eax
  8009ff:	83 c2 01             	add    $0x1,%edx
  800a02:	eb ea                	jmp    8009ee <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a04:	0f b6 c1             	movzbl %cl,%eax
  800a07:	0f b6 db             	movzbl %bl,%ebx
  800a0a:	29 d8                	sub    %ebx,%eax
  800a0c:	eb 05                	jmp    800a13 <memcmp+0x35>
	}

	return 0;
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a13:	5b                   	pop    %ebx
  800a14:	5e                   	pop    %esi
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a20:	89 c2                	mov    %eax,%edx
  800a22:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a25:	39 d0                	cmp    %edx,%eax
  800a27:	73 09                	jae    800a32 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a29:	38 08                	cmp    %cl,(%eax)
  800a2b:	74 05                	je     800a32 <memfind+0x1b>
	for (; s < ends; s++)
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	eb f3                	jmp    800a25 <memfind+0xe>
			break;
	return (void *) s;
}
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	53                   	push   %ebx
  800a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a40:	eb 03                	jmp    800a45 <strtol+0x11>
		s++;
  800a42:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a45:	0f b6 01             	movzbl (%ecx),%eax
  800a48:	3c 20                	cmp    $0x20,%al
  800a4a:	74 f6                	je     800a42 <strtol+0xe>
  800a4c:	3c 09                	cmp    $0x9,%al
  800a4e:	74 f2                	je     800a42 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a50:	3c 2b                	cmp    $0x2b,%al
  800a52:	74 2e                	je     800a82 <strtol+0x4e>
	int neg = 0;
  800a54:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a59:	3c 2d                	cmp    $0x2d,%al
  800a5b:	74 2f                	je     800a8c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a63:	75 05                	jne    800a6a <strtol+0x36>
  800a65:	80 39 30             	cmpb   $0x30,(%ecx)
  800a68:	74 2c                	je     800a96 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a6a:	85 db                	test   %ebx,%ebx
  800a6c:	75 0a                	jne    800a78 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a6e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a73:	80 39 30             	cmpb   $0x30,(%ecx)
  800a76:	74 28                	je     800aa0 <strtol+0x6c>
		base = 10;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a80:	eb 50                	jmp    800ad2 <strtol+0x9e>
		s++;
  800a82:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a85:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8a:	eb d1                	jmp    800a5d <strtol+0x29>
		s++, neg = 1;
  800a8c:	83 c1 01             	add    $0x1,%ecx
  800a8f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a94:	eb c7                	jmp    800a5d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a96:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a9a:	74 0e                	je     800aaa <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a9c:	85 db                	test   %ebx,%ebx
  800a9e:	75 d8                	jne    800a78 <strtol+0x44>
		s++, base = 8;
  800aa0:	83 c1 01             	add    $0x1,%ecx
  800aa3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aa8:	eb ce                	jmp    800a78 <strtol+0x44>
		s += 2, base = 16;
  800aaa:	83 c1 02             	add    $0x2,%ecx
  800aad:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab2:	eb c4                	jmp    800a78 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab7:	89 f3                	mov    %esi,%ebx
  800ab9:	80 fb 19             	cmp    $0x19,%bl
  800abc:	77 29                	ja     800ae7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800abe:	0f be d2             	movsbl %dl,%edx
  800ac1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac7:	7d 30                	jge    800af9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac9:	83 c1 01             	add    $0x1,%ecx
  800acc:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad2:	0f b6 11             	movzbl (%ecx),%edx
  800ad5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad8:	89 f3                	mov    %esi,%ebx
  800ada:	80 fb 09             	cmp    $0x9,%bl
  800add:	77 d5                	ja     800ab4 <strtol+0x80>
			dig = *s - '0';
  800adf:	0f be d2             	movsbl %dl,%edx
  800ae2:	83 ea 30             	sub    $0x30,%edx
  800ae5:	eb dd                	jmp    800ac4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ae7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aea:	89 f3                	mov    %esi,%ebx
  800aec:	80 fb 19             	cmp    $0x19,%bl
  800aef:	77 08                	ja     800af9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af1:	0f be d2             	movsbl %dl,%edx
  800af4:	83 ea 37             	sub    $0x37,%edx
  800af7:	eb cb                	jmp    800ac4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afd:	74 05                	je     800b04 <strtol+0xd0>
		*endptr = (char *) s;
  800aff:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b02:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	f7 da                	neg    %edx
  800b08:	85 ff                	test   %edi,%edi
  800b0a:	0f 45 c2             	cmovne %edx,%eax
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5f                   	pop    %edi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	57                   	push   %edi
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b18:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b23:	89 c3                	mov    %eax,%ebx
  800b25:	89 c7                	mov    %eax,%edi
  800b27:	89 c6                	mov    %eax,%esi
  800b29:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2b:	5b                   	pop    %ebx
  800b2c:	5e                   	pop    %esi
  800b2d:	5f                   	pop    %edi
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	57                   	push   %edi
  800b34:	56                   	push   %esi
  800b35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b36:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b40:	89 d1                	mov    %edx,%ecx
  800b42:	89 d3                	mov    %edx,%ebx
  800b44:	89 d7                	mov    %edx,%edi
  800b46:	89 d6                	mov    %edx,%esi
  800b48:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b58:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	89 cb                	mov    %ecx,%ebx
  800b67:	89 cf                	mov    %ecx,%edi
  800b69:	89 ce                	mov    %ecx,%esi
  800b6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	7f 08                	jg     800b79 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5f                   	pop    %edi
  800b77:	5d                   	pop    %ebp
  800b78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b79:	83 ec 0c             	sub    $0xc,%esp
  800b7c:	50                   	push   %eax
  800b7d:	6a 03                	push   $0x3
  800b7f:	68 ff 2b 80 00       	push   $0x802bff
  800b84:	6a 23                	push   $0x23
  800b86:	68 1c 2c 80 00       	push   $0x802c1c
  800b8b:	e8 4b f5 ff ff       	call   8000db <_panic>

00800b90 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	57                   	push   %edi
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b96:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9b:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba0:	89 d1                	mov    %edx,%ecx
  800ba2:	89 d3                	mov    %edx,%ebx
  800ba4:	89 d7                	mov    %edx,%edi
  800ba6:	89 d6                	mov    %edx,%esi
  800ba8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <sys_yield>:

void
sys_yield(void)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800bba:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bbf:	89 d1                	mov    %edx,%ecx
  800bc1:	89 d3                	mov    %edx,%ebx
  800bc3:	89 d7                	mov    %edx,%edi
  800bc5:	89 d6                	mov    %edx,%esi
  800bc7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bc9:	5b                   	pop    %ebx
  800bca:	5e                   	pop    %esi
  800bcb:	5f                   	pop    %edi
  800bcc:	5d                   	pop    %ebp
  800bcd:	c3                   	ret    

00800bce <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd7:	be 00 00 00 00       	mov    $0x0,%esi
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be2:	b8 04 00 00 00       	mov    $0x4,%eax
  800be7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bea:	89 f7                	mov    %esi,%edi
  800bec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bee:	85 c0                	test   %eax,%eax
  800bf0:	7f 08                	jg     800bfa <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf5:	5b                   	pop    %ebx
  800bf6:	5e                   	pop    %esi
  800bf7:	5f                   	pop    %edi
  800bf8:	5d                   	pop    %ebp
  800bf9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfa:	83 ec 0c             	sub    $0xc,%esp
  800bfd:	50                   	push   %eax
  800bfe:	6a 04                	push   $0x4
  800c00:	68 ff 2b 80 00       	push   $0x802bff
  800c05:	6a 23                	push   $0x23
  800c07:	68 1c 2c 80 00       	push   $0x802c1c
  800c0c:	e8 ca f4 ff ff       	call   8000db <_panic>

00800c11 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	57                   	push   %edi
  800c15:	56                   	push   %esi
  800c16:	53                   	push   %ebx
  800c17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c20:	b8 05 00 00 00       	mov    $0x5,%eax
  800c25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c28:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c2b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 05                	push   $0x5
  800c42:	68 ff 2b 80 00       	push   $0x802bff
  800c47:	6a 23                	push   $0x23
  800c49:	68 1c 2c 80 00       	push   $0x802c1c
  800c4e:	e8 88 f4 ff ff       	call   8000db <_panic>

00800c53 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c61:	8b 55 08             	mov    0x8(%ebp),%edx
  800c64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c67:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6c:	89 df                	mov    %ebx,%edi
  800c6e:	89 de                	mov    %ebx,%esi
  800c70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 06                	push   $0x6
  800c84:	68 ff 2b 80 00       	push   $0x802bff
  800c89:	6a 23                	push   $0x23
  800c8b:	68 1c 2c 80 00       	push   $0x802c1c
  800c90:	e8 46 f4 ff ff       	call   8000db <_panic>

00800c95 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cae:	89 df                	mov    %ebx,%edi
  800cb0:	89 de                	mov    %ebx,%esi
  800cb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	7f 08                	jg     800cc0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	83 ec 0c             	sub    $0xc,%esp
  800cc3:	50                   	push   %eax
  800cc4:	6a 08                	push   $0x8
  800cc6:	68 ff 2b 80 00       	push   $0x802bff
  800ccb:	6a 23                	push   $0x23
  800ccd:	68 1c 2c 80 00       	push   $0x802c1c
  800cd2:	e8 04 f4 ff ff       	call   8000db <_panic>

00800cd7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	89 de                	mov    %ebx,%esi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	50                   	push   %eax
  800d06:	6a 09                	push   $0x9
  800d08:	68 ff 2b 80 00       	push   $0x802bff
  800d0d:	6a 23                	push   $0x23
  800d0f:	68 1c 2c 80 00       	push   $0x802c1c
  800d14:	e8 c2 f3 ff ff       	call   8000db <_panic>

00800d19 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d32:	89 df                	mov    %ebx,%edi
  800d34:	89 de                	mov    %ebx,%esi
  800d36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	7f 08                	jg     800d44 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	50                   	push   %eax
  800d48:	6a 0a                	push   $0xa
  800d4a:	68 ff 2b 80 00       	push   $0x802bff
  800d4f:	6a 23                	push   $0x23
  800d51:	68 1c 2c 80 00       	push   $0x802c1c
  800d56:	e8 80 f3 ff ff       	call   8000db <_panic>

00800d5b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6c:	be 00 00 00 00       	mov    $0x0,%esi
  800d71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d74:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d77:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
  800d84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d94:	89 cb                	mov    %ecx,%ebx
  800d96:	89 cf                	mov    %ecx,%edi
  800d98:	89 ce                	mov    %ecx,%esi
  800d9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7f 08                	jg     800da8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	50                   	push   %eax
  800dac:	6a 0d                	push   $0xd
  800dae:	68 ff 2b 80 00       	push   $0x802bff
  800db3:	6a 23                	push   $0x23
  800db5:	68 1c 2c 80 00       	push   $0x802c1c
  800dba:	e8 1c f3 ff ff       	call   8000db <_panic>

00800dbf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800dca:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dcf:	89 d1                	mov    %edx,%ecx
  800dd1:	89 d3                	mov    %edx,%ebx
  800dd3:	89 d7                	mov    %edx,%edi
  800dd5:	89 d6                	mov    %edx,%esi
  800dd7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	05 00 00 00 30       	add    $0x30000000,%eax
  800de9:	c1 e8 0c             	shr    $0xc,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800df9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dfe:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e0b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e10:	89 c2                	mov    %eax,%edx
  800e12:	c1 ea 16             	shr    $0x16,%edx
  800e15:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e1c:	f6 c2 01             	test   $0x1,%dl
  800e1f:	74 2a                	je     800e4b <fd_alloc+0x46>
  800e21:	89 c2                	mov    %eax,%edx
  800e23:	c1 ea 0c             	shr    $0xc,%edx
  800e26:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e2d:	f6 c2 01             	test   $0x1,%dl
  800e30:	74 19                	je     800e4b <fd_alloc+0x46>
  800e32:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e37:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e3c:	75 d2                	jne    800e10 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e3e:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e44:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e49:	eb 07                	jmp    800e52 <fd_alloc+0x4d>
			*fd_store = fd;
  800e4b:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    

00800e54 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e5a:	83 f8 1f             	cmp    $0x1f,%eax
  800e5d:	77 36                	ja     800e95 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e5f:	c1 e0 0c             	shl    $0xc,%eax
  800e62:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	c1 ea 16             	shr    $0x16,%edx
  800e6c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e73:	f6 c2 01             	test   $0x1,%dl
  800e76:	74 24                	je     800e9c <fd_lookup+0x48>
  800e78:	89 c2                	mov    %eax,%edx
  800e7a:	c1 ea 0c             	shr    $0xc,%edx
  800e7d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e84:	f6 c2 01             	test   $0x1,%dl
  800e87:	74 1a                	je     800ea3 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8c:	89 02                	mov    %eax,(%edx)
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
		return -E_INVAL;
  800e95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e9a:	eb f7                	jmp    800e93 <fd_lookup+0x3f>
		return -E_INVAL;
  800e9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea1:	eb f0                	jmp    800e93 <fd_lookup+0x3f>
  800ea3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ea8:	eb e9                	jmp    800e93 <fd_lookup+0x3f>

00800eaa <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	83 ec 08             	sub    $0x8,%esp
  800eb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eb3:	ba a8 2c 80 00       	mov    $0x802ca8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800eb8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800ebd:	39 08                	cmp    %ecx,(%eax)
  800ebf:	74 33                	je     800ef4 <dev_lookup+0x4a>
  800ec1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ec4:	8b 02                	mov    (%edx),%eax
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	75 f3                	jne    800ebd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800eca:	a1 08 40 80 00       	mov    0x804008,%eax
  800ecf:	8b 40 48             	mov    0x48(%eax),%eax
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	51                   	push   %ecx
  800ed6:	50                   	push   %eax
  800ed7:	68 2c 2c 80 00       	push   $0x802c2c
  800edc:	e8 d5 f2 ff ff       	call   8001b6 <cprintf>
	*dev = 0;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    
			*dev = devtab[i];
  800ef4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef7:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  800efe:	eb f2                	jmp    800ef2 <dev_lookup+0x48>

00800f00 <fd_close>:
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 1c             	sub    $0x1c,%esp
  800f09:	8b 75 08             	mov    0x8(%ebp),%esi
  800f0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f0f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f12:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f13:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f19:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f1c:	50                   	push   %eax
  800f1d:	e8 32 ff ff ff       	call   800e54 <fd_lookup>
  800f22:	89 c3                	mov    %eax,%ebx
  800f24:	83 c4 08             	add    $0x8,%esp
  800f27:	85 c0                	test   %eax,%eax
  800f29:	78 05                	js     800f30 <fd_close+0x30>
	    || fd != fd2)
  800f2b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f2e:	74 16                	je     800f46 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f30:	89 f8                	mov    %edi,%eax
  800f32:	84 c0                	test   %al,%al
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	0f 44 d8             	cmove  %eax,%ebx
}
  800f3c:	89 d8                	mov    %ebx,%eax
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f46:	83 ec 08             	sub    $0x8,%esp
  800f49:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f4c:	50                   	push   %eax
  800f4d:	ff 36                	pushl  (%esi)
  800f4f:	e8 56 ff ff ff       	call   800eaa <dev_lookup>
  800f54:	89 c3                	mov    %eax,%ebx
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	78 15                	js     800f72 <fd_close+0x72>
		if (dev->dev_close)
  800f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f60:	8b 40 10             	mov    0x10(%eax),%eax
  800f63:	85 c0                	test   %eax,%eax
  800f65:	74 1b                	je     800f82 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f67:	83 ec 0c             	sub    $0xc,%esp
  800f6a:	56                   	push   %esi
  800f6b:	ff d0                	call   *%eax
  800f6d:	89 c3                	mov    %eax,%ebx
  800f6f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	56                   	push   %esi
  800f76:	6a 00                	push   $0x0
  800f78:	e8 d6 fc ff ff       	call   800c53 <sys_page_unmap>
	return r;
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	eb ba                	jmp    800f3c <fd_close+0x3c>
			r = 0;
  800f82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f87:	eb e9                	jmp    800f72 <fd_close+0x72>

00800f89 <close>:

int
close(int fdnum)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f92:	50                   	push   %eax
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 b9 fe ff ff       	call   800e54 <fd_lookup>
  800f9b:	83 c4 08             	add    $0x8,%esp
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	78 10                	js     800fb2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	6a 01                	push   $0x1
  800fa7:	ff 75 f4             	pushl  -0xc(%ebp)
  800faa:	e8 51 ff ff ff       	call   800f00 <fd_close>
  800faf:	83 c4 10             	add    $0x10,%esp
}
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <close_all>:

void
close_all(void)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	53                   	push   %ebx
  800fb8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	53                   	push   %ebx
  800fc4:	e8 c0 ff ff ff       	call   800f89 <close>
	for (i = 0; i < MAXFD; i++)
  800fc9:	83 c3 01             	add    $0x1,%ebx
  800fcc:	83 c4 10             	add    $0x10,%esp
  800fcf:	83 fb 20             	cmp    $0x20,%ebx
  800fd2:	75 ec                	jne    800fc0 <close_all+0xc>
}
  800fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fe2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fe5:	50                   	push   %eax
  800fe6:	ff 75 08             	pushl  0x8(%ebp)
  800fe9:	e8 66 fe ff ff       	call   800e54 <fd_lookup>
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	83 c4 08             	add    $0x8,%esp
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	0f 88 81 00 00 00    	js     80107c <dup+0xa3>
		return r;
	close(newfdnum);
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	e8 83 ff ff ff       	call   800f89 <close>

	newfd = INDEX2FD(newfdnum);
  801006:	8b 75 0c             	mov    0xc(%ebp),%esi
  801009:	c1 e6 0c             	shl    $0xc,%esi
  80100c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801012:	83 c4 04             	add    $0x4,%esp
  801015:	ff 75 e4             	pushl  -0x1c(%ebp)
  801018:	e8 d1 fd ff ff       	call   800dee <fd2data>
  80101d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80101f:	89 34 24             	mov    %esi,(%esp)
  801022:	e8 c7 fd ff ff       	call   800dee <fd2data>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80102c:	89 d8                	mov    %ebx,%eax
  80102e:	c1 e8 16             	shr    $0x16,%eax
  801031:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801038:	a8 01                	test   $0x1,%al
  80103a:	74 11                	je     80104d <dup+0x74>
  80103c:	89 d8                	mov    %ebx,%eax
  80103e:	c1 e8 0c             	shr    $0xc,%eax
  801041:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801048:	f6 c2 01             	test   $0x1,%dl
  80104b:	75 39                	jne    801086 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80104d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801050:	89 d0                	mov    %edx,%eax
  801052:	c1 e8 0c             	shr    $0xc,%eax
  801055:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	25 07 0e 00 00       	and    $0xe07,%eax
  801064:	50                   	push   %eax
  801065:	56                   	push   %esi
  801066:	6a 00                	push   $0x0
  801068:	52                   	push   %edx
  801069:	6a 00                	push   $0x0
  80106b:	e8 a1 fb ff ff       	call   800c11 <sys_page_map>
  801070:	89 c3                	mov    %eax,%ebx
  801072:	83 c4 20             	add    $0x20,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	78 31                	js     8010aa <dup+0xd1>
		goto err;

	return newfdnum;
  801079:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80107c:	89 d8                	mov    %ebx,%eax
  80107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801086:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	25 07 0e 00 00       	and    $0xe07,%eax
  801095:	50                   	push   %eax
  801096:	57                   	push   %edi
  801097:	6a 00                	push   $0x0
  801099:	53                   	push   %ebx
  80109a:	6a 00                	push   $0x0
  80109c:	e8 70 fb ff ff       	call   800c11 <sys_page_map>
  8010a1:	89 c3                	mov    %eax,%ebx
  8010a3:	83 c4 20             	add    $0x20,%esp
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	79 a3                	jns    80104d <dup+0x74>
	sys_page_unmap(0, newfd);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	56                   	push   %esi
  8010ae:	6a 00                	push   $0x0
  8010b0:	e8 9e fb ff ff       	call   800c53 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010b5:	83 c4 08             	add    $0x8,%esp
  8010b8:	57                   	push   %edi
  8010b9:	6a 00                	push   $0x0
  8010bb:	e8 93 fb ff ff       	call   800c53 <sys_page_unmap>
	return r;
  8010c0:	83 c4 10             	add    $0x10,%esp
  8010c3:	eb b7                	jmp    80107c <dup+0xa3>

008010c5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	53                   	push   %ebx
  8010c9:	83 ec 14             	sub    $0x14,%esp
  8010cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d2:	50                   	push   %eax
  8010d3:	53                   	push   %ebx
  8010d4:	e8 7b fd ff ff       	call   800e54 <fd_lookup>
  8010d9:	83 c4 08             	add    $0x8,%esp
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	78 3f                	js     80111f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010e0:	83 ec 08             	sub    $0x8,%esp
  8010e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e6:	50                   	push   %eax
  8010e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ea:	ff 30                	pushl  (%eax)
  8010ec:	e8 b9 fd ff ff       	call   800eaa <dev_lookup>
  8010f1:	83 c4 10             	add    $0x10,%esp
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	78 27                	js     80111f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fb:	8b 42 08             	mov    0x8(%edx),%eax
  8010fe:	83 e0 03             	and    $0x3,%eax
  801101:	83 f8 01             	cmp    $0x1,%eax
  801104:	74 1e                	je     801124 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801109:	8b 40 08             	mov    0x8(%eax),%eax
  80110c:	85 c0                	test   %eax,%eax
  80110e:	74 35                	je     801145 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801110:	83 ec 04             	sub    $0x4,%esp
  801113:	ff 75 10             	pushl  0x10(%ebp)
  801116:	ff 75 0c             	pushl  0xc(%ebp)
  801119:	52                   	push   %edx
  80111a:	ff d0                	call   *%eax
  80111c:	83 c4 10             	add    $0x10,%esp
}
  80111f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801122:	c9                   	leave  
  801123:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801124:	a1 08 40 80 00       	mov    0x804008,%eax
  801129:	8b 40 48             	mov    0x48(%eax),%eax
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	53                   	push   %ebx
  801130:	50                   	push   %eax
  801131:	68 6d 2c 80 00       	push   $0x802c6d
  801136:	e8 7b f0 ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801143:	eb da                	jmp    80111f <read+0x5a>
		return -E_NOT_SUPP;
  801145:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80114a:	eb d3                	jmp    80111f <read+0x5a>

0080114c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 0c             	sub    $0xc,%esp
  801155:	8b 7d 08             	mov    0x8(%ebp),%edi
  801158:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80115b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801160:	39 f3                	cmp    %esi,%ebx
  801162:	73 25                	jae    801189 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801164:	83 ec 04             	sub    $0x4,%esp
  801167:	89 f0                	mov    %esi,%eax
  801169:	29 d8                	sub    %ebx,%eax
  80116b:	50                   	push   %eax
  80116c:	89 d8                	mov    %ebx,%eax
  80116e:	03 45 0c             	add    0xc(%ebp),%eax
  801171:	50                   	push   %eax
  801172:	57                   	push   %edi
  801173:	e8 4d ff ff ff       	call   8010c5 <read>
		if (m < 0)
  801178:	83 c4 10             	add    $0x10,%esp
  80117b:	85 c0                	test   %eax,%eax
  80117d:	78 08                	js     801187 <readn+0x3b>
			return m;
		if (m == 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	74 06                	je     801189 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801183:	01 c3                	add    %eax,%ebx
  801185:	eb d9                	jmp    801160 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801187:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801189:	89 d8                	mov    %ebx,%eax
  80118b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118e:	5b                   	pop    %ebx
  80118f:	5e                   	pop    %esi
  801190:	5f                   	pop    %edi
  801191:	5d                   	pop    %ebp
  801192:	c3                   	ret    

00801193 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
  801196:	53                   	push   %ebx
  801197:	83 ec 14             	sub    $0x14,%esp
  80119a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80119d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a0:	50                   	push   %eax
  8011a1:	53                   	push   %ebx
  8011a2:	e8 ad fc ff ff       	call   800e54 <fd_lookup>
  8011a7:	83 c4 08             	add    $0x8,%esp
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	78 3a                	js     8011e8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011ae:	83 ec 08             	sub    $0x8,%esp
  8011b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b4:	50                   	push   %eax
  8011b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b8:	ff 30                	pushl  (%eax)
  8011ba:	e8 eb fc ff ff       	call   800eaa <dev_lookup>
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	78 22                	js     8011e8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011cd:	74 1e                	je     8011ed <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011d2:	8b 52 0c             	mov    0xc(%edx),%edx
  8011d5:	85 d2                	test   %edx,%edx
  8011d7:	74 35                	je     80120e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011d9:	83 ec 04             	sub    $0x4,%esp
  8011dc:	ff 75 10             	pushl  0x10(%ebp)
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	50                   	push   %eax
  8011e3:	ff d2                	call   *%edx
  8011e5:	83 c4 10             	add    $0x10,%esp
}
  8011e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8011f2:	8b 40 48             	mov    0x48(%eax),%eax
  8011f5:	83 ec 04             	sub    $0x4,%esp
  8011f8:	53                   	push   %ebx
  8011f9:	50                   	push   %eax
  8011fa:	68 89 2c 80 00       	push   $0x802c89
  8011ff:	e8 b2 ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80120c:	eb da                	jmp    8011e8 <write+0x55>
		return -E_NOT_SUPP;
  80120e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801213:	eb d3                	jmp    8011e8 <write+0x55>

00801215 <seek>:

int
seek(int fdnum, off_t offset)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80121b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80121e:	50                   	push   %eax
  80121f:	ff 75 08             	pushl  0x8(%ebp)
  801222:	e8 2d fc ff ff       	call   800e54 <fd_lookup>
  801227:	83 c4 08             	add    $0x8,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 0e                	js     80123c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80122e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801234:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801237:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	53                   	push   %ebx
  801242:	83 ec 14             	sub    $0x14,%esp
  801245:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801248:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80124b:	50                   	push   %eax
  80124c:	53                   	push   %ebx
  80124d:	e8 02 fc ff ff       	call   800e54 <fd_lookup>
  801252:	83 c4 08             	add    $0x8,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	78 37                	js     801290 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801259:	83 ec 08             	sub    $0x8,%esp
  80125c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125f:	50                   	push   %eax
  801260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801263:	ff 30                	pushl  (%eax)
  801265:	e8 40 fc ff ff       	call   800eaa <dev_lookup>
  80126a:	83 c4 10             	add    $0x10,%esp
  80126d:	85 c0                	test   %eax,%eax
  80126f:	78 1f                	js     801290 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801274:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801278:	74 1b                	je     801295 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80127a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127d:	8b 52 18             	mov    0x18(%edx),%edx
  801280:	85 d2                	test   %edx,%edx
  801282:	74 32                	je     8012b6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	ff 75 0c             	pushl  0xc(%ebp)
  80128a:	50                   	push   %eax
  80128b:	ff d2                	call   *%edx
  80128d:	83 c4 10             	add    $0x10,%esp
}
  801290:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801293:	c9                   	leave  
  801294:	c3                   	ret    
			thisenv->env_id, fdnum);
  801295:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80129a:	8b 40 48             	mov    0x48(%eax),%eax
  80129d:	83 ec 04             	sub    $0x4,%esp
  8012a0:	53                   	push   %ebx
  8012a1:	50                   	push   %eax
  8012a2:	68 4c 2c 80 00       	push   $0x802c4c
  8012a7:	e8 0a ef ff ff       	call   8001b6 <cprintf>
		return -E_INVAL;
  8012ac:	83 c4 10             	add    $0x10,%esp
  8012af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012b4:	eb da                	jmp    801290 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012b6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012bb:	eb d3                	jmp    801290 <ftruncate+0x52>

008012bd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	53                   	push   %ebx
  8012c1:	83 ec 14             	sub    $0x14,%esp
  8012c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ca:	50                   	push   %eax
  8012cb:	ff 75 08             	pushl  0x8(%ebp)
  8012ce:	e8 81 fb ff ff       	call   800e54 <fd_lookup>
  8012d3:	83 c4 08             	add    $0x8,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 4b                	js     801325 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012da:	83 ec 08             	sub    $0x8,%esp
  8012dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e0:	50                   	push   %eax
  8012e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e4:	ff 30                	pushl  (%eax)
  8012e6:	e8 bf fb ff ff       	call   800eaa <dev_lookup>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 33                	js     801325 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012f9:	74 2f                	je     80132a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012fb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012fe:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801305:	00 00 00 
	stat->st_isdir = 0;
  801308:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80130f:	00 00 00 
	stat->st_dev = dev;
  801312:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801318:	83 ec 08             	sub    $0x8,%esp
  80131b:	53                   	push   %ebx
  80131c:	ff 75 f0             	pushl  -0x10(%ebp)
  80131f:	ff 50 14             	call   *0x14(%eax)
  801322:	83 c4 10             	add    $0x10,%esp
}
  801325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801328:	c9                   	leave  
  801329:	c3                   	ret    
		return -E_NOT_SUPP;
  80132a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132f:	eb f4                	jmp    801325 <fstat+0x68>

00801331 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	6a 00                	push   $0x0
  80133b:	ff 75 08             	pushl  0x8(%ebp)
  80133e:	e8 e7 01 00 00       	call   80152a <open>
  801343:	89 c3                	mov    %eax,%ebx
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 1b                	js     801367 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80134c:	83 ec 08             	sub    $0x8,%esp
  80134f:	ff 75 0c             	pushl  0xc(%ebp)
  801352:	50                   	push   %eax
  801353:	e8 65 ff ff ff       	call   8012bd <fstat>
  801358:	89 c6                	mov    %eax,%esi
	close(fd);
  80135a:	89 1c 24             	mov    %ebx,(%esp)
  80135d:	e8 27 fc ff ff       	call   800f89 <close>
	return r;
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	89 f3                	mov    %esi,%ebx
}
  801367:	89 d8                	mov    %ebx,%eax
  801369:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80136c:	5b                   	pop    %ebx
  80136d:	5e                   	pop    %esi
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	56                   	push   %esi
  801374:	53                   	push   %ebx
  801375:	89 c6                	mov    %eax,%esi
  801377:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801379:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801380:	74 27                	je     8013a9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801382:	6a 07                	push   $0x7
  801384:	68 00 50 80 00       	push   $0x805000
  801389:	56                   	push   %esi
  80138a:	ff 35 00 40 80 00    	pushl  0x804000
  801390:	e8 c7 11 00 00       	call   80255c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801395:	83 c4 0c             	add    $0xc,%esp
  801398:	6a 00                	push   $0x0
  80139a:	53                   	push   %ebx
  80139b:	6a 00                	push   $0x0
  80139d:	e8 53 11 00 00       	call   8024f5 <ipc_recv>
}
  8013a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013a5:	5b                   	pop    %ebx
  8013a6:	5e                   	pop    %esi
  8013a7:	5d                   	pop    %ebp
  8013a8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013a9:	83 ec 0c             	sub    $0xc,%esp
  8013ac:	6a 01                	push   $0x1
  8013ae:	e8 fd 11 00 00       	call   8025b0 <ipc_find_env>
  8013b3:	a3 00 40 80 00       	mov    %eax,0x804000
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb c5                	jmp    801382 <fsipc+0x12>

008013bd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013db:	b8 02 00 00 00       	mov    $0x2,%eax
  8013e0:	e8 8b ff ff ff       	call   801370 <fsipc>
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <devfile_flush>:
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fd:	b8 06 00 00 00       	mov    $0x6,%eax
  801402:	e8 69 ff ff ff       	call   801370 <fsipc>
}
  801407:	c9                   	leave  
  801408:	c3                   	ret    

00801409 <devfile_stat>:
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	53                   	push   %ebx
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	8b 40 0c             	mov    0xc(%eax),%eax
  801419:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80141e:	ba 00 00 00 00       	mov    $0x0,%edx
  801423:	b8 05 00 00 00       	mov    $0x5,%eax
  801428:	e8 43 ff ff ff       	call   801370 <fsipc>
  80142d:	85 c0                	test   %eax,%eax
  80142f:	78 2c                	js     80145d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801431:	83 ec 08             	sub    $0x8,%esp
  801434:	68 00 50 80 00       	push   $0x805000
  801439:	53                   	push   %ebx
  80143a:	e8 96 f3 ff ff       	call   8007d5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80143f:	a1 80 50 80 00       	mov    0x805080,%eax
  801444:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80144a:	a1 84 50 80 00       	mov    0x805084,%eax
  80144f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <devfile_write>:
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801470:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801475:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	8b 52 0c             	mov    0xc(%edx),%edx
  80147e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801484:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801489:	50                   	push   %eax
  80148a:	ff 75 0c             	pushl  0xc(%ebp)
  80148d:	68 08 50 80 00       	push   $0x805008
  801492:	e8 cc f4 ff ff       	call   800963 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801497:	ba 00 00 00 00       	mov    $0x0,%edx
  80149c:	b8 04 00 00 00       	mov    $0x4,%eax
  8014a1:	e8 ca fe ff ff       	call   801370 <fsipc>
}
  8014a6:	c9                   	leave  
  8014a7:	c3                   	ret    

008014a8 <devfile_read>:
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	56                   	push   %esi
  8014ac:	53                   	push   %ebx
  8014ad:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014bb:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8014cb:	e8 a0 fe ff ff       	call   801370 <fsipc>
  8014d0:	89 c3                	mov    %eax,%ebx
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 1f                	js     8014f5 <devfile_read+0x4d>
	assert(r <= n);
  8014d6:	39 f0                	cmp    %esi,%eax
  8014d8:	77 24                	ja     8014fe <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014da:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014df:	7f 33                	jg     801514 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	50                   	push   %eax
  8014e5:	68 00 50 80 00       	push   $0x805000
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	e8 71 f4 ff ff       	call   800963 <memmove>
	return r;
  8014f2:	83 c4 10             	add    $0x10,%esp
}
  8014f5:	89 d8                	mov    %ebx,%eax
  8014f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014fa:	5b                   	pop    %ebx
  8014fb:	5e                   	pop    %esi
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    
	assert(r <= n);
  8014fe:	68 bc 2c 80 00       	push   $0x802cbc
  801503:	68 c3 2c 80 00       	push   $0x802cc3
  801508:	6a 7b                	push   $0x7b
  80150a:	68 d8 2c 80 00       	push   $0x802cd8
  80150f:	e8 c7 eb ff ff       	call   8000db <_panic>
	assert(r <= PGSIZE);
  801514:	68 e3 2c 80 00       	push   $0x802ce3
  801519:	68 c3 2c 80 00       	push   $0x802cc3
  80151e:	6a 7c                	push   $0x7c
  801520:	68 d8 2c 80 00       	push   $0x802cd8
  801525:	e8 b1 eb ff ff       	call   8000db <_panic>

0080152a <open>:
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	56                   	push   %esi
  80152e:	53                   	push   %ebx
  80152f:	83 ec 1c             	sub    $0x1c,%esp
  801532:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801535:	56                   	push   %esi
  801536:	e8 63 f2 ff ff       	call   80079e <strlen>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801543:	7f 6c                	jg     8015b1 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801545:	83 ec 0c             	sub    $0xc,%esp
  801548:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154b:	50                   	push   %eax
  80154c:	e8 b4 f8 ff ff       	call   800e05 <fd_alloc>
  801551:	89 c3                	mov    %eax,%ebx
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	85 c0                	test   %eax,%eax
  801558:	78 3c                	js     801596 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	56                   	push   %esi
  80155e:	68 00 50 80 00       	push   $0x805000
  801563:	e8 6d f2 ff ff       	call   8007d5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801573:	b8 01 00 00 00       	mov    $0x1,%eax
  801578:	e8 f3 fd ff ff       	call   801370 <fsipc>
  80157d:	89 c3                	mov    %eax,%ebx
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	85 c0                	test   %eax,%eax
  801584:	78 19                	js     80159f <open+0x75>
	return fd2num(fd);
  801586:	83 ec 0c             	sub    $0xc,%esp
  801589:	ff 75 f4             	pushl  -0xc(%ebp)
  80158c:	e8 4d f8 ff ff       	call   800dde <fd2num>
  801591:	89 c3                	mov    %eax,%ebx
  801593:	83 c4 10             	add    $0x10,%esp
}
  801596:	89 d8                	mov    %ebx,%eax
  801598:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5e                   	pop    %esi
  80159d:	5d                   	pop    %ebp
  80159e:	c3                   	ret    
		fd_close(fd, 0);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	6a 00                	push   $0x0
  8015a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a7:	e8 54 f9 ff ff       	call   800f00 <fd_close>
		return r;
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	eb e5                	jmp    801596 <open+0x6c>
		return -E_BAD_PATH;
  8015b1:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015b6:	eb de                	jmp    801596 <open+0x6c>

008015b8 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015be:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8015c8:	e8 a3 fd ff ff       	call   801370 <fsipc>
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <spawn>:
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int spawn(const char *prog, const char **argv)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	57                   	push   %edi
  8015d3:	56                   	push   %esi
  8015d4:	53                   	push   %ebx
  8015d5:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8015db:	6a 00                	push   $0x0
  8015dd:	ff 75 08             	pushl  0x8(%ebp)
  8015e0:	e8 45 ff ff ff       	call   80152a <open>
  8015e5:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8015eb:	83 c4 10             	add    $0x10,%esp
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	0f 88 40 03 00 00    	js     801936 <spawn+0x367>
  8015f6:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *)elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) || elf->e_magic != ELF_MAGIC)
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 00 02 00 00       	push   $0x200
  801600:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801606:	50                   	push   %eax
  801607:	51                   	push   %ecx
  801608:	e8 3f fb ff ff       	call   80114c <readn>
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	3d 00 02 00 00       	cmp    $0x200,%eax
  801615:	75 5d                	jne    801674 <spawn+0xa5>
  801617:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80161e:	45 4c 46 
  801621:	75 51                	jne    801674 <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801623:	b8 07 00 00 00       	mov    $0x7,%eax
  801628:	cd 30                	int    $0x30
  80162a:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801630:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801636:	85 c0                	test   %eax,%eax
  801638:	0f 88 62 04 00 00    	js     801aa0 <spawn+0x4d1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80163e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801643:	6b f0 7c             	imul   $0x7c,%eax,%esi
  801646:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80164c:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801652:	b9 11 00 00 00       	mov    $0x11,%ecx
  801657:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801659:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  80165f:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801665:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  80166a:	be 00 00 00 00       	mov    $0x0,%esi
  80166f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801672:	eb 4b                	jmp    8016bf <spawn+0xf0>
		close(fd);
  801674:	83 ec 0c             	sub    $0xc,%esp
  801677:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80167d:	e8 07 f9 ff ff       	call   800f89 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801682:	83 c4 0c             	add    $0xc,%esp
  801685:	68 7f 45 4c 46       	push   $0x464c457f
  80168a:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801690:	68 ef 2c 80 00       	push   $0x802cef
  801695:	e8 1c eb ff ff       	call   8001b6 <cprintf>
		return -E_NOT_EXEC;
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  8016a4:	ff ff ff 
  8016a7:	e9 8a 02 00 00       	jmp    801936 <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	50                   	push   %eax
  8016b0:	e8 e9 f0 ff ff       	call   80079e <strlen>
  8016b5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  8016b9:	83 c3 01             	add    $0x1,%ebx
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8016c6:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	75 df                	jne    8016ac <spawn+0xdd>
  8016cd:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8016d3:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *)UTEMP + PGSIZE - string_size;
  8016d9:	bf 00 10 40 00       	mov    $0x401000,%edi
  8016de:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *)(ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8016e0:	89 fa                	mov    %edi,%edx
  8016e2:	83 e2 fc             	and    $0xfffffffc,%edx
  8016e5:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8016ec:	29 c2                	sub    %eax,%edx
  8016ee:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *)(argv_store - 2) < (void *)UTEMP)
  8016f4:	8d 42 f8             	lea    -0x8(%edx),%eax
  8016f7:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8016fc:	0f 86 af 03 00 00    	jbe    801ab1 <spawn+0x4e2>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	6a 07                	push   $0x7
  801707:	68 00 00 40 00       	push   $0x400000
  80170c:	6a 00                	push   $0x0
  80170e:	e8 bb f4 ff ff       	call   800bce <sys_page_alloc>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	85 c0                	test   %eax,%eax
  801718:	0f 88 98 03 00 00    	js     801ab6 <spawn+0x4e7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++)
  80171e:	be 00 00 00 00       	mov    $0x0,%esi
  801723:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801729:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80172c:	eb 30                	jmp    80175e <spawn+0x18f>
	{
		argv_store[i] = UTEMP2USTACK(string_store);
  80172e:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801734:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80173a:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80173d:	83 ec 08             	sub    $0x8,%esp
  801740:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801743:	57                   	push   %edi
  801744:	e8 8c f0 ff ff       	call   8007d5 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801749:	83 c4 04             	add    $0x4,%esp
  80174c:	ff 34 b3             	pushl  (%ebx,%esi,4)
  80174f:	e8 4a f0 ff ff       	call   80079e <strlen>
  801754:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++)
  801758:	83 c6 01             	add    $0x1,%esi
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801764:	7f c8                	jg     80172e <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801766:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80176c:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801772:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *)UTEMP + PGSIZE);
  801779:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80177f:	0f 85 8c 00 00 00    	jne    801811 <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801785:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  80178b:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801791:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801794:	89 f8                	mov    %edi,%eax
  801796:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  80179c:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80179f:	2d 08 30 80 11       	sub    $0x11803008,%eax
  8017a4:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void *)(USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	6a 07                	push   $0x7
  8017af:	68 00 d0 bf ee       	push   $0xeebfd000
  8017b4:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8017ba:	68 00 00 40 00       	push   $0x400000
  8017bf:	6a 00                	push   $0x0
  8017c1:	e8 4b f4 ff ff       	call   800c11 <sys_page_map>
  8017c6:	89 c3                	mov    %eax,%ebx
  8017c8:	83 c4 20             	add    $0x20,%esp
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	0f 88 59 03 00 00    	js     801b2c <spawn+0x55d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	68 00 00 40 00       	push   $0x400000
  8017db:	6a 00                	push   $0x0
  8017dd:	e8 71 f4 ff ff       	call   800c53 <sys_page_unmap>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	0f 88 3d 03 00 00    	js     801b2c <spawn+0x55d>
	ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8017ef:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8017f5:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8017fc:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801802:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801809:	00 00 00 
  80180c:	e9 56 01 00 00       	jmp    801967 <spawn+0x398>
	assert(string_store == (char *)UTEMP + PGSIZE);
  801811:	68 7c 2d 80 00       	push   $0x802d7c
  801816:	68 c3 2c 80 00       	push   $0x802cc3
  80181b:	68 f0 00 00 00       	push   $0xf0
  801820:	68 09 2d 80 00       	push   $0x802d09
  801825:	e8 b1 e8 ff ff       	call   8000db <_panic>
				return r;
		}
		else
		{
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	6a 07                	push   $0x7
  80182f:	68 00 00 40 00       	push   $0x400000
  801834:	6a 00                	push   $0x0
  801836:	e8 93 f3 ff ff       	call   800bce <sys_page_alloc>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	0f 88 7b 02 00 00    	js     801ac1 <spawn+0x4f2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801846:	83 ec 08             	sub    $0x8,%esp
  801849:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80184f:	01 f0                	add    %esi,%eax
  801851:	50                   	push   %eax
  801852:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801858:	e8 b8 f9 ff ff       	call   801215 <seek>
  80185d:	83 c4 10             	add    $0x10,%esp
  801860:	85 c0                	test   %eax,%eax
  801862:	0f 88 60 02 00 00    	js     801ac8 <spawn+0x4f9>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801871:	29 f0                	sub    %esi,%eax
  801873:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801878:	b9 00 10 00 00       	mov    $0x1000,%ecx
  80187d:	0f 47 c1             	cmova  %ecx,%eax
  801880:	50                   	push   %eax
  801881:	68 00 00 40 00       	push   $0x400000
  801886:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  80188c:	e8 bb f8 ff ff       	call   80114c <readn>
  801891:	83 c4 10             	add    $0x10,%esp
  801894:	85 c0                	test   %eax,%eax
  801896:	0f 88 33 02 00 00    	js     801acf <spawn+0x500>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void *)(va + i), perm)) < 0)
  80189c:	83 ec 0c             	sub    $0xc,%esp
  80189f:	57                   	push   %edi
  8018a0:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8018a6:	56                   	push   %esi
  8018a7:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8018ad:	68 00 00 40 00       	push   $0x400000
  8018b2:	6a 00                	push   $0x0
  8018b4:	e8 58 f3 ff ff       	call   800c11 <sys_page_map>
  8018b9:	83 c4 20             	add    $0x20,%esp
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	0f 88 80 00 00 00    	js     801944 <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  8018c4:	83 ec 08             	sub    $0x8,%esp
  8018c7:	68 00 00 40 00       	push   $0x400000
  8018cc:	6a 00                	push   $0x0
  8018ce:	e8 80 f3 ff ff       	call   800c53 <sys_page_unmap>
  8018d3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE)
  8018d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8018dc:	89 de                	mov    %ebx,%esi
  8018de:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  8018e4:	76 73                	jbe    801959 <spawn+0x38a>
		if (i >= filesz)
  8018e6:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8018ec:	0f 87 38 ff ff ff    	ja     80182a <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void *)(va + i), perm)) < 0)
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	57                   	push   %edi
  8018f6:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8018fc:	56                   	push   %esi
  8018fd:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801903:	e8 c6 f2 ff ff       	call   800bce <sys_page_alloc>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	79 c7                	jns    8018d6 <spawn+0x307>
  80190f:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801911:	83 ec 0c             	sub    $0xc,%esp
  801914:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80191a:	e8 30 f2 ff ff       	call   800b4f <sys_env_destroy>
	close(fd);
  80191f:	83 c4 04             	add    $0x4,%esp
  801922:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801928:	e8 5c f6 ff ff       	call   800f89 <close>
	return r;
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801936:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  80193c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5f                   	pop    %edi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801944:	50                   	push   %eax
  801945:	68 15 2d 80 00       	push   $0x802d15
  80194a:	68 28 01 00 00       	push   $0x128
  80194f:	68 09 2d 80 00       	push   $0x802d09
  801954:	e8 82 e7 ff ff       	call   8000db <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801959:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801960:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801967:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80196e:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801974:	7e 71                	jle    8019e7 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801976:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  80197c:	83 3a 01             	cmpl   $0x1,(%edx)
  80197f:	75 d8                	jne    801959 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801981:	8b 42 18             	mov    0x18(%edx),%eax
  801984:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801987:	83 f8 01             	cmp    $0x1,%eax
  80198a:	19 ff                	sbb    %edi,%edi
  80198c:	83 e7 fe             	and    $0xfffffffe,%edi
  80198f:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801992:	8b 72 04             	mov    0x4(%edx),%esi
  801995:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  80199b:	8b 5a 10             	mov    0x10(%edx),%ebx
  80199e:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  8019a4:	8b 42 14             	mov    0x14(%edx),%eax
  8019a7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8019ad:	8b 4a 08             	mov    0x8(%edx),%ecx
  8019b0:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
	if ((i = PGOFF(va)))
  8019b6:	89 c8                	mov    %ecx,%eax
  8019b8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8019bd:	74 1e                	je     8019dd <spawn+0x40e>
		va -= i;
  8019bf:	29 c1                	sub    %eax,%ecx
  8019c1:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
		memsz += i;
  8019c7:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8019cd:	01 c3                	add    %eax,%ebx
  8019cf:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  8019d5:	29 c6                	sub    %eax,%esi
  8019d7:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE)
  8019dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019e2:	e9 f5 fe ff ff       	jmp    8018dc <spawn+0x30d>
	close(fd);
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8019f0:	e8 94 f5 ff ff       	call   800f89 <close>
  8019f5:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int r, pn;
	struct Env *e;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8019f8:	bb 00 08 00 00       	mov    $0x800,%ebx
  8019fd:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801a03:	eb 0f                	jmp    801a14 <spawn+0x445>
  801a05:	83 c3 01             	add    $0x1,%ebx
  801a08:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801a0e:	0f 84 c2 00 00 00    	je     801ad6 <spawn+0x507>
	{
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801a14:	89 d8                	mov    %ebx,%eax
  801a16:	c1 f8 0a             	sar    $0xa,%eax
  801a19:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a20:	a8 01                	test   $0x1,%al
  801a22:	74 e1                	je     801a05 <spawn+0x436>
  801a24:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a2b:	a8 01                	test   $0x1,%al
  801a2d:	74 d6                	je     801a05 <spawn+0x436>
		{
			if (uvpt[pn] & PTE_SHARE)
  801a2f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a36:	f6 c4 04             	test   $0x4,%ah
  801a39:	74 ca                	je     801a05 <spawn+0x436>
			{
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
									  child, (void *)(pn * PGSIZE),
									  uvpt[pn] & PTE_SYSCALL)) < 0)
  801a3b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a42:	89 da                	mov    %ebx,%edx
  801a44:	c1 e2 0c             	shl    $0xc,%edx
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
  801a47:	83 ec 0c             	sub    $0xc,%esp
  801a4a:	25 07 0e 00 00       	and    $0xe07,%eax
  801a4f:	50                   	push   %eax
  801a50:	52                   	push   %edx
  801a51:	56                   	push   %esi
  801a52:	52                   	push   %edx
  801a53:	6a 00                	push   $0x0
  801a55:	e8 b7 f1 ff ff       	call   800c11 <sys_page_map>
  801a5a:	83 c4 20             	add    $0x20,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	79 a4                	jns    801a05 <spawn+0x436>
		panic("copy_shared_pages: %e", r);
  801a61:	50                   	push   %eax
  801a62:	68 63 2d 80 00       	push   $0x802d63
  801a67:	68 82 00 00 00       	push   $0x82
  801a6c:	68 09 2d 80 00       	push   $0x802d09
  801a71:	e8 65 e6 ff ff       	call   8000db <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801a76:	50                   	push   %eax
  801a77:	68 32 2d 80 00       	push   $0x802d32
  801a7c:	68 86 00 00 00       	push   $0x86
  801a81:	68 09 2d 80 00       	push   $0x802d09
  801a86:	e8 50 e6 ff ff       	call   8000db <_panic>
		panic("sys_env_set_status: %e", r);
  801a8b:	50                   	push   %eax
  801a8c:	68 4c 2d 80 00       	push   $0x802d4c
  801a91:	68 89 00 00 00       	push   $0x89
  801a96:	68 09 2d 80 00       	push   $0x802d09
  801a9b:	e8 3b e6 ff ff       	call   8000db <_panic>
		return r;
  801aa0:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801aa6:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801aac:	e9 85 fe ff ff       	jmp    801936 <spawn+0x367>
		return -E_NO_MEM;
  801ab1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801ab6:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801abc:	e9 75 fe ff ff       	jmp    801936 <spawn+0x367>
  801ac1:	89 c7                	mov    %eax,%edi
  801ac3:	e9 49 fe ff ff       	jmp    801911 <spawn+0x342>
  801ac8:	89 c7                	mov    %eax,%edi
  801aca:	e9 42 fe ff ff       	jmp    801911 <spawn+0x342>
  801acf:	89 c7                	mov    %eax,%edi
  801ad1:	e9 3b fe ff ff       	jmp    801911 <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3; // devious: see user/faultio.c
  801ad6:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801add:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801ae0:	83 ec 08             	sub    $0x8,%esp
  801ae3:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ae9:	50                   	push   %eax
  801aea:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801af0:	e8 e2 f1 ff ff       	call   800cd7 <sys_env_set_trapframe>
  801af5:	83 c4 10             	add    $0x10,%esp
  801af8:	85 c0                	test   %eax,%eax
  801afa:	0f 88 76 ff ff ff    	js     801a76 <spawn+0x4a7>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801b00:	83 ec 08             	sub    $0x8,%esp
  801b03:	6a 02                	push   $0x2
  801b05:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b0b:	e8 85 f1 ff ff       	call   800c95 <sys_env_set_status>
  801b10:	83 c4 10             	add    $0x10,%esp
  801b13:	85 c0                	test   %eax,%eax
  801b15:	0f 88 70 ff ff ff    	js     801a8b <spawn+0x4bc>
	return child;
  801b1b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b21:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b27:	e9 0a fe ff ff       	jmp    801936 <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	68 00 00 40 00       	push   $0x400000
  801b34:	6a 00                	push   $0x0
  801b36:	e8 18 f1 ff ff       	call   800c53 <sys_page_unmap>
  801b3b:	83 c4 10             	add    $0x10,%esp
  801b3e:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b44:	e9 ed fd ff ff       	jmp    801936 <spawn+0x367>

00801b49 <spawnl>:
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	57                   	push   %edi
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801b52:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  801b55:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  801b5a:	eb 05                	jmp    801b61 <spawnl+0x18>
		argc++;
  801b5c:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  801b5f:	89 ca                	mov    %ecx,%edx
  801b61:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b64:	83 3a 00             	cmpl   $0x0,(%edx)
  801b67:	75 f3                	jne    801b5c <spawnl+0x13>
	const char *argv[argc + 2];
  801b69:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801b70:	83 e2 f0             	and    $0xfffffff0,%edx
  801b73:	29 d4                	sub    %edx,%esp
  801b75:	8d 54 24 03          	lea    0x3(%esp),%edx
  801b79:	c1 ea 02             	shr    $0x2,%edx
  801b7c:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801b83:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b88:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801b8f:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801b96:	00 
	va_start(vl, arg0);
  801b97:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801b9a:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  801b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba1:	eb 0b                	jmp    801bae <spawnl+0x65>
		argv[i + 1] = va_arg(vl, const char *);
  801ba3:	83 c0 01             	add    $0x1,%eax
  801ba6:	8b 39                	mov    (%ecx),%edi
  801ba8:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801bab:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  801bae:	39 d0                	cmp    %edx,%eax
  801bb0:	75 f1                	jne    801ba3 <spawnl+0x5a>
	return spawn(prog, argv);
  801bb2:	83 ec 08             	sub    $0x8,%esp
  801bb5:	56                   	push   %esi
  801bb6:	ff 75 08             	pushl  0x8(%ebp)
  801bb9:	e8 11 fa ff ff       	call   8015cf <spawn>
}
  801bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5e                   	pop    %esi
  801bc3:	5f                   	pop    %edi
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    

00801bc6 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801bcc:	68 a4 2d 80 00       	push   $0x802da4
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	e8 fc eb ff ff       	call   8007d5 <strcpy>
	return 0;
}
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <devsock_close>:
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	53                   	push   %ebx
  801be4:	83 ec 10             	sub    $0x10,%esp
  801be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bea:	53                   	push   %ebx
  801beb:	e8 f9 09 00 00       	call   8025e9 <pageref>
  801bf0:	83 c4 10             	add    $0x10,%esp
		return 0;
  801bf3:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801bf8:	83 f8 01             	cmp    $0x1,%eax
  801bfb:	74 07                	je     801c04 <devsock_close+0x24>
}
  801bfd:	89 d0                	mov    %edx,%eax
  801bff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801c04:	83 ec 0c             	sub    $0xc,%esp
  801c07:	ff 73 0c             	pushl  0xc(%ebx)
  801c0a:	e8 b7 02 00 00       	call   801ec6 <nsipc_close>
  801c0f:	89 c2                	mov    %eax,%edx
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	eb e7                	jmp    801bfd <devsock_close+0x1d>

00801c16 <devsock_write>:
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	ff 75 10             	pushl  0x10(%ebp)
  801c21:	ff 75 0c             	pushl  0xc(%ebp)
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	ff 70 0c             	pushl  0xc(%eax)
  801c2a:	e8 74 03 00 00       	call   801fa3 <nsipc_send>
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <devsock_read>:
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 10             	pushl  0x10(%ebp)
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	ff 70 0c             	pushl  0xc(%eax)
  801c45:	e8 ed 02 00 00       	call   801f37 <nsipc_recv>
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <fd2sockid>:
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c52:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	e8 f8 f1 ff ff       	call   800e54 <fd_lookup>
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 10                	js     801c73 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801c6c:	39 08                	cmp    %ecx,(%eax)
  801c6e:	75 05                	jne    801c75 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801c70:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    
		return -E_NOT_SUPP;
  801c75:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c7a:	eb f7                	jmp    801c73 <fd2sockid+0x27>

00801c7c <alloc_sockfd>:
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	56                   	push   %esi
  801c80:	53                   	push   %ebx
  801c81:	83 ec 1c             	sub    $0x1c,%esp
  801c84:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c89:	50                   	push   %eax
  801c8a:	e8 76 f1 ff ff       	call   800e05 <fd_alloc>
  801c8f:	89 c3                	mov    %eax,%ebx
  801c91:	83 c4 10             	add    $0x10,%esp
  801c94:	85 c0                	test   %eax,%eax
  801c96:	78 43                	js     801cdb <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	68 07 04 00 00       	push   $0x407
  801ca0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 24 ef ff ff       	call   800bce <sys_page_alloc>
  801caa:	89 c3                	mov    %eax,%ebx
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 28                	js     801cdb <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cbc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cc8:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ccb:	83 ec 0c             	sub    $0xc,%esp
  801cce:	50                   	push   %eax
  801ccf:	e8 0a f1 ff ff       	call   800dde <fd2num>
  801cd4:	89 c3                	mov    %eax,%ebx
  801cd6:	83 c4 10             	add    $0x10,%esp
  801cd9:	eb 0c                	jmp    801ce7 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801cdb:	83 ec 0c             	sub    $0xc,%esp
  801cde:	56                   	push   %esi
  801cdf:	e8 e2 01 00 00       	call   801ec6 <nsipc_close>
		return r;
  801ce4:	83 c4 10             	add    $0x10,%esp
}
  801ce7:	89 d8                	mov    %ebx,%eax
  801ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cec:	5b                   	pop    %ebx
  801ced:	5e                   	pop    %esi
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <accept>:
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	e8 4e ff ff ff       	call   801c4c <fd2sockid>
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 1b                	js     801d1d <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	ff 75 10             	pushl  0x10(%ebp)
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	50                   	push   %eax
  801d0c:	e8 0e 01 00 00       	call   801e1f <nsipc_accept>
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	85 c0                	test   %eax,%eax
  801d16:	78 05                	js     801d1d <accept+0x2d>
	return alloc_sockfd(r);
  801d18:	e8 5f ff ff ff       	call   801c7c <alloc_sockfd>
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <bind>:
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	e8 1f ff ff ff       	call   801c4c <fd2sockid>
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	78 12                	js     801d43 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801d31:	83 ec 04             	sub    $0x4,%esp
  801d34:	ff 75 10             	pushl  0x10(%ebp)
  801d37:	ff 75 0c             	pushl  0xc(%ebp)
  801d3a:	50                   	push   %eax
  801d3b:	e8 2f 01 00 00       	call   801e6f <nsipc_bind>
  801d40:	83 c4 10             	add    $0x10,%esp
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <shutdown>:
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	e8 f9 fe ff ff       	call   801c4c <fd2sockid>
  801d53:	85 c0                	test   %eax,%eax
  801d55:	78 0f                	js     801d66 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801d57:	83 ec 08             	sub    $0x8,%esp
  801d5a:	ff 75 0c             	pushl  0xc(%ebp)
  801d5d:	50                   	push   %eax
  801d5e:	e8 41 01 00 00       	call   801ea4 <nsipc_shutdown>
  801d63:	83 c4 10             	add    $0x10,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <connect>:
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	e8 d6 fe ff ff       	call   801c4c <fd2sockid>
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 12                	js     801d8c <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801d7a:	83 ec 04             	sub    $0x4,%esp
  801d7d:	ff 75 10             	pushl  0x10(%ebp)
  801d80:	ff 75 0c             	pushl  0xc(%ebp)
  801d83:	50                   	push   %eax
  801d84:	e8 57 01 00 00       	call   801ee0 <nsipc_connect>
  801d89:	83 c4 10             	add    $0x10,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <listen>:
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	e8 b0 fe ff ff       	call   801c4c <fd2sockid>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 0f                	js     801daf <listen+0x21>
	return nsipc_listen(r, backlog);
  801da0:	83 ec 08             	sub    $0x8,%esp
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	50                   	push   %eax
  801da7:	e8 69 01 00 00       	call   801f15 <nsipc_listen>
  801dac:	83 c4 10             	add    $0x10,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <socket>:

int
socket(int domain, int type, int protocol)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801db7:	ff 75 10             	pushl  0x10(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 3c 02 00 00       	call   802001 <nsipc_socket>
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	78 05                	js     801dd1 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801dcc:	e8 ab fe ff ff       	call   801c7c <alloc_sockfd>
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	53                   	push   %ebx
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ddc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801de3:	74 26                	je     801e0b <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801de5:	6a 07                	push   $0x7
  801de7:	68 00 60 80 00       	push   $0x806000
  801dec:	53                   	push   %ebx
  801ded:	ff 35 04 40 80 00    	pushl  0x804004
  801df3:	e8 64 07 00 00       	call   80255c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801df8:	83 c4 0c             	add    $0xc,%esp
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	e8 ef 06 00 00       	call   8024f5 <ipc_recv>
}
  801e06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e0b:	83 ec 0c             	sub    $0xc,%esp
  801e0e:	6a 02                	push   $0x2
  801e10:	e8 9b 07 00 00       	call   8025b0 <ipc_find_env>
  801e15:	a3 04 40 80 00       	mov    %eax,0x804004
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	eb c6                	jmp    801de5 <nsipc+0x12>

00801e1f <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	56                   	push   %esi
  801e23:	53                   	push   %ebx
  801e24:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e2f:	8b 06                	mov    (%esi),%eax
  801e31:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	e8 93 ff ff ff       	call   801dd3 <nsipc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 20                	js     801e66 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e46:	83 ec 04             	sub    $0x4,%esp
  801e49:	ff 35 10 60 80 00    	pushl  0x806010
  801e4f:	68 00 60 80 00       	push   $0x806000
  801e54:	ff 75 0c             	pushl  0xc(%ebp)
  801e57:	e8 07 eb ff ff       	call   800963 <memmove>
		*addrlen = ret->ret_addrlen;
  801e5c:	a1 10 60 80 00       	mov    0x806010,%eax
  801e61:	89 06                	mov    %eax,(%esi)
  801e63:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801e66:	89 d8                	mov    %ebx,%eax
  801e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5e                   	pop    %esi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e81:	53                   	push   %ebx
  801e82:	ff 75 0c             	pushl  0xc(%ebp)
  801e85:	68 04 60 80 00       	push   $0x806004
  801e8a:	e8 d4 ea ff ff       	call   800963 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e8f:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e95:	b8 02 00 00 00       	mov    $0x2,%eax
  801e9a:	e8 34 ff ff ff       	call   801dd3 <nsipc>
}
  801e9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb5:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801eba:	b8 03 00 00 00       	mov    $0x3,%eax
  801ebf:	e8 0f ff ff ff       	call   801dd3 <nsipc>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <nsipc_close>:

int
nsipc_close(int s)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ed4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ed9:	e8 f5 fe ff ff       	call   801dd3 <nsipc>
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	53                   	push   %ebx
  801ee4:	83 ec 08             	sub    $0x8,%esp
  801ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ef2:	53                   	push   %ebx
  801ef3:	ff 75 0c             	pushl  0xc(%ebp)
  801ef6:	68 04 60 80 00       	push   $0x806004
  801efb:	e8 63 ea ff ff       	call   800963 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f00:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801f06:	b8 05 00 00 00       	mov    $0x5,%eax
  801f0b:	e8 c3 fe ff ff       	call   801dd3 <nsipc>
}
  801f10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f2b:	b8 06 00 00 00       	mov    $0x6,%eax
  801f30:	e8 9e fe ff ff       	call   801dd3 <nsipc>
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	56                   	push   %esi
  801f3b:	53                   	push   %ebx
  801f3c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f47:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f50:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f55:	b8 07 00 00 00       	mov    $0x7,%eax
  801f5a:	e8 74 fe ff ff       	call   801dd3 <nsipc>
  801f5f:	89 c3                	mov    %eax,%ebx
  801f61:	85 c0                	test   %eax,%eax
  801f63:	78 1f                	js     801f84 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801f65:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f6a:	7f 21                	jg     801f8d <nsipc_recv+0x56>
  801f6c:	39 c6                	cmp    %eax,%esi
  801f6e:	7c 1d                	jl     801f8d <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	50                   	push   %eax
  801f74:	68 00 60 80 00       	push   $0x806000
  801f79:	ff 75 0c             	pushl  0xc(%ebp)
  801f7c:	e8 e2 e9 ff ff       	call   800963 <memmove>
  801f81:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801f84:	89 d8                	mov    %ebx,%eax
  801f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f89:	5b                   	pop    %ebx
  801f8a:	5e                   	pop    %esi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801f8d:	68 b0 2d 80 00       	push   $0x802db0
  801f92:	68 c3 2c 80 00       	push   $0x802cc3
  801f97:	6a 62                	push   $0x62
  801f99:	68 c5 2d 80 00       	push   $0x802dc5
  801f9e:	e8 38 e1 ff ff       	call   8000db <_panic>

00801fa3 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fb5:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fbb:	7f 2e                	jg     801feb <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	53                   	push   %ebx
  801fc1:	ff 75 0c             	pushl  0xc(%ebp)
  801fc4:	68 0c 60 80 00       	push   $0x80600c
  801fc9:	e8 95 e9 ff ff       	call   800963 <memmove>
	nsipcbuf.send.req_size = size;
  801fce:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fd7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801fdc:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe1:	e8 ed fd ff ff       	call   801dd3 <nsipc>
}
  801fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    
	assert(size < 1600);
  801feb:	68 d1 2d 80 00       	push   $0x802dd1
  801ff0:	68 c3 2c 80 00       	push   $0x802cc3
  801ff5:	6a 6d                	push   $0x6d
  801ff7:	68 c5 2d 80 00       	push   $0x802dc5
  801ffc:	e8 da e0 ff ff       	call   8000db <_panic>

00802001 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80200f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802012:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802017:	8b 45 10             	mov    0x10(%ebp),%eax
  80201a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80201f:	b8 09 00 00 00       	mov    $0x9,%eax
  802024:	e8 aa fd ff ff       	call   801dd3 <nsipc>
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	56                   	push   %esi
  80202f:	53                   	push   %ebx
  802030:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	ff 75 08             	pushl  0x8(%ebp)
  802039:	e8 b0 ed ff ff       	call   800dee <fd2data>
  80203e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802040:	83 c4 08             	add    $0x8,%esp
  802043:	68 dd 2d 80 00       	push   $0x802ddd
  802048:	53                   	push   %ebx
  802049:	e8 87 e7 ff ff       	call   8007d5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80204e:	8b 46 04             	mov    0x4(%esi),%eax
  802051:	2b 06                	sub    (%esi),%eax
  802053:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802059:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802060:	00 00 00 
	stat->st_dev = &devpipe;
  802063:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80206a:	30 80 00 
	return 0;
}
  80206d:	b8 00 00 00 00       	mov    $0x0,%eax
  802072:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802075:	5b                   	pop    %ebx
  802076:	5e                   	pop    %esi
  802077:	5d                   	pop    %ebp
  802078:	c3                   	ret    

00802079 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	53                   	push   %ebx
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802083:	53                   	push   %ebx
  802084:	6a 00                	push   $0x0
  802086:	e8 c8 eb ff ff       	call   800c53 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80208b:	89 1c 24             	mov    %ebx,(%esp)
  80208e:	e8 5b ed ff ff       	call   800dee <fd2data>
  802093:	83 c4 08             	add    $0x8,%esp
  802096:	50                   	push   %eax
  802097:	6a 00                	push   $0x0
  802099:	e8 b5 eb ff ff       	call   800c53 <sys_page_unmap>
}
  80209e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <_pipeisclosed>:
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	57                   	push   %edi
  8020a7:	56                   	push   %esi
  8020a8:	53                   	push   %ebx
  8020a9:	83 ec 1c             	sub    $0x1c,%esp
  8020ac:	89 c7                	mov    %eax,%edi
  8020ae:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8020b0:	a1 08 40 80 00       	mov    0x804008,%eax
  8020b5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	57                   	push   %edi
  8020bc:	e8 28 05 00 00       	call   8025e9 <pageref>
  8020c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8020c4:	89 34 24             	mov    %esi,(%esp)
  8020c7:	e8 1d 05 00 00       	call   8025e9 <pageref>
		nn = thisenv->env_runs;
  8020cc:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8020d2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020d5:	83 c4 10             	add    $0x10,%esp
  8020d8:	39 cb                	cmp    %ecx,%ebx
  8020da:	74 1b                	je     8020f7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8020dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020df:	75 cf                	jne    8020b0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020e1:	8b 42 58             	mov    0x58(%edx),%eax
  8020e4:	6a 01                	push   $0x1
  8020e6:	50                   	push   %eax
  8020e7:	53                   	push   %ebx
  8020e8:	68 e4 2d 80 00       	push   $0x802de4
  8020ed:	e8 c4 e0 ff ff       	call   8001b6 <cprintf>
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	eb b9                	jmp    8020b0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8020f7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8020fa:	0f 94 c0             	sete   %al
  8020fd:	0f b6 c0             	movzbl %al,%eax
}
  802100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802103:	5b                   	pop    %ebx
  802104:	5e                   	pop    %esi
  802105:	5f                   	pop    %edi
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    

00802108 <devpipe_write>:
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	57                   	push   %edi
  80210c:	56                   	push   %esi
  80210d:	53                   	push   %ebx
  80210e:	83 ec 28             	sub    $0x28,%esp
  802111:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802114:	56                   	push   %esi
  802115:	e8 d4 ec ff ff       	call   800dee <fd2data>
  80211a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80211c:	83 c4 10             	add    $0x10,%esp
  80211f:	bf 00 00 00 00       	mov    $0x0,%edi
  802124:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802127:	74 4f                	je     802178 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802129:	8b 43 04             	mov    0x4(%ebx),%eax
  80212c:	8b 0b                	mov    (%ebx),%ecx
  80212e:	8d 51 20             	lea    0x20(%ecx),%edx
  802131:	39 d0                	cmp    %edx,%eax
  802133:	72 14                	jb     802149 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802135:	89 da                	mov    %ebx,%edx
  802137:	89 f0                	mov    %esi,%eax
  802139:	e8 65 ff ff ff       	call   8020a3 <_pipeisclosed>
  80213e:	85 c0                	test   %eax,%eax
  802140:	75 3a                	jne    80217c <devpipe_write+0x74>
			sys_yield();
  802142:	e8 68 ea ff ff       	call   800baf <sys_yield>
  802147:	eb e0                	jmp    802129 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802149:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80214c:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802150:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802153:	89 c2                	mov    %eax,%edx
  802155:	c1 fa 1f             	sar    $0x1f,%edx
  802158:	89 d1                	mov    %edx,%ecx
  80215a:	c1 e9 1b             	shr    $0x1b,%ecx
  80215d:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802160:	83 e2 1f             	and    $0x1f,%edx
  802163:	29 ca                	sub    %ecx,%edx
  802165:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802169:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80216d:	83 c0 01             	add    $0x1,%eax
  802170:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802173:	83 c7 01             	add    $0x1,%edi
  802176:	eb ac                	jmp    802124 <devpipe_write+0x1c>
	return i;
  802178:	89 f8                	mov    %edi,%eax
  80217a:	eb 05                	jmp    802181 <devpipe_write+0x79>
				return 0;
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802181:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802184:	5b                   	pop    %ebx
  802185:	5e                   	pop    %esi
  802186:	5f                   	pop    %edi
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    

00802189 <devpipe_read>:
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	57                   	push   %edi
  80218d:	56                   	push   %esi
  80218e:	53                   	push   %ebx
  80218f:	83 ec 18             	sub    $0x18,%esp
  802192:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802195:	57                   	push   %edi
  802196:	e8 53 ec ff ff       	call   800dee <fd2data>
  80219b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	be 00 00 00 00       	mov    $0x0,%esi
  8021a5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a8:	74 47                	je     8021f1 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8021aa:	8b 03                	mov    (%ebx),%eax
  8021ac:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021af:	75 22                	jne    8021d3 <devpipe_read+0x4a>
			if (i > 0)
  8021b1:	85 f6                	test   %esi,%esi
  8021b3:	75 14                	jne    8021c9 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  8021b5:	89 da                	mov    %ebx,%edx
  8021b7:	89 f8                	mov    %edi,%eax
  8021b9:	e8 e5 fe ff ff       	call   8020a3 <_pipeisclosed>
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	75 33                	jne    8021f5 <devpipe_read+0x6c>
			sys_yield();
  8021c2:	e8 e8 e9 ff ff       	call   800baf <sys_yield>
  8021c7:	eb e1                	jmp    8021aa <devpipe_read+0x21>
				return i;
  8021c9:	89 f0                	mov    %esi,%eax
}
  8021cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ce:	5b                   	pop    %ebx
  8021cf:	5e                   	pop    %esi
  8021d0:	5f                   	pop    %edi
  8021d1:	5d                   	pop    %ebp
  8021d2:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021d3:	99                   	cltd   
  8021d4:	c1 ea 1b             	shr    $0x1b,%edx
  8021d7:	01 d0                	add    %edx,%eax
  8021d9:	83 e0 1f             	and    $0x1f,%eax
  8021dc:	29 d0                	sub    %edx,%eax
  8021de:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e6:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021e9:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8021ec:	83 c6 01             	add    $0x1,%esi
  8021ef:	eb b4                	jmp    8021a5 <devpipe_read+0x1c>
	return i;
  8021f1:	89 f0                	mov    %esi,%eax
  8021f3:	eb d6                	jmp    8021cb <devpipe_read+0x42>
				return 0;
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fa:	eb cf                	jmp    8021cb <devpipe_read+0x42>

008021fc <pipe>:
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	56                   	push   %esi
  802200:	53                   	push   %ebx
  802201:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802204:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802207:	50                   	push   %eax
  802208:	e8 f8 eb ff ff       	call   800e05 <fd_alloc>
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	83 c4 10             	add    $0x10,%esp
  802212:	85 c0                	test   %eax,%eax
  802214:	78 5b                	js     802271 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	68 07 04 00 00       	push   $0x407
  80221e:	ff 75 f4             	pushl  -0xc(%ebp)
  802221:	6a 00                	push   $0x0
  802223:	e8 a6 e9 ff ff       	call   800bce <sys_page_alloc>
  802228:	89 c3                	mov    %eax,%ebx
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	85 c0                	test   %eax,%eax
  80222f:	78 40                	js     802271 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802231:	83 ec 0c             	sub    $0xc,%esp
  802234:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802237:	50                   	push   %eax
  802238:	e8 c8 eb ff ff       	call   800e05 <fd_alloc>
  80223d:	89 c3                	mov    %eax,%ebx
  80223f:	83 c4 10             	add    $0x10,%esp
  802242:	85 c0                	test   %eax,%eax
  802244:	78 1b                	js     802261 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	68 07 04 00 00       	push   $0x407
  80224e:	ff 75 f0             	pushl  -0x10(%ebp)
  802251:	6a 00                	push   $0x0
  802253:	e8 76 e9 ff ff       	call   800bce <sys_page_alloc>
  802258:	89 c3                	mov    %eax,%ebx
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	85 c0                	test   %eax,%eax
  80225f:	79 19                	jns    80227a <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802261:	83 ec 08             	sub    $0x8,%esp
  802264:	ff 75 f4             	pushl  -0xc(%ebp)
  802267:	6a 00                	push   $0x0
  802269:	e8 e5 e9 ff ff       	call   800c53 <sys_page_unmap>
  80226e:	83 c4 10             	add    $0x10,%esp
}
  802271:	89 d8                	mov    %ebx,%eax
  802273:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802276:	5b                   	pop    %ebx
  802277:	5e                   	pop    %esi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    
	va = fd2data(fd0);
  80227a:	83 ec 0c             	sub    $0xc,%esp
  80227d:	ff 75 f4             	pushl  -0xc(%ebp)
  802280:	e8 69 eb ff ff       	call   800dee <fd2data>
  802285:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802287:	83 c4 0c             	add    $0xc,%esp
  80228a:	68 07 04 00 00       	push   $0x407
  80228f:	50                   	push   %eax
  802290:	6a 00                	push   $0x0
  802292:	e8 37 e9 ff ff       	call   800bce <sys_page_alloc>
  802297:	89 c3                	mov    %eax,%ebx
  802299:	83 c4 10             	add    $0x10,%esp
  80229c:	85 c0                	test   %eax,%eax
  80229e:	0f 88 8c 00 00 00    	js     802330 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022a4:	83 ec 0c             	sub    $0xc,%esp
  8022a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8022aa:	e8 3f eb ff ff       	call   800dee <fd2data>
  8022af:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8022b6:	50                   	push   %eax
  8022b7:	6a 00                	push   $0x0
  8022b9:	56                   	push   %esi
  8022ba:	6a 00                	push   $0x0
  8022bc:	e8 50 e9 ff ff       	call   800c11 <sys_page_map>
  8022c1:	89 c3                	mov    %eax,%ebx
  8022c3:	83 c4 20             	add    $0x20,%esp
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	78 58                	js     802322 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022d3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022e8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8022f4:	83 ec 0c             	sub    $0xc,%esp
  8022f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8022fa:	e8 df ea ff ff       	call   800dde <fd2num>
  8022ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802302:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802304:	83 c4 04             	add    $0x4,%esp
  802307:	ff 75 f0             	pushl  -0x10(%ebp)
  80230a:	e8 cf ea ff ff       	call   800dde <fd2num>
  80230f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802312:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802315:	83 c4 10             	add    $0x10,%esp
  802318:	bb 00 00 00 00       	mov    $0x0,%ebx
  80231d:	e9 4f ff ff ff       	jmp    802271 <pipe+0x75>
	sys_page_unmap(0, va);
  802322:	83 ec 08             	sub    $0x8,%esp
  802325:	56                   	push   %esi
  802326:	6a 00                	push   $0x0
  802328:	e8 26 e9 ff ff       	call   800c53 <sys_page_unmap>
  80232d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802330:	83 ec 08             	sub    $0x8,%esp
  802333:	ff 75 f0             	pushl  -0x10(%ebp)
  802336:	6a 00                	push   $0x0
  802338:	e8 16 e9 ff ff       	call   800c53 <sys_page_unmap>
  80233d:	83 c4 10             	add    $0x10,%esp
  802340:	e9 1c ff ff ff       	jmp    802261 <pipe+0x65>

00802345 <pipeisclosed>:
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80234b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80234e:	50                   	push   %eax
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	e8 fd ea ff ff       	call   800e54 <fd_lookup>
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 18                	js     802376 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80235e:	83 ec 0c             	sub    $0xc,%esp
  802361:	ff 75 f4             	pushl  -0xc(%ebp)
  802364:	e8 85 ea ff ff       	call   800dee <fd2data>
	return _pipeisclosed(fd, p);
  802369:	89 c2                	mov    %eax,%edx
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	e8 30 fd ff ff       	call   8020a3 <_pipeisclosed>
  802373:	83 c4 10             	add    $0x10,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
  802380:	5d                   	pop    %ebp
  802381:	c3                   	ret    

00802382 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802388:	68 fc 2d 80 00       	push   $0x802dfc
  80238d:	ff 75 0c             	pushl  0xc(%ebp)
  802390:	e8 40 e4 ff ff       	call   8007d5 <strcpy>
	return 0;
}
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <devcons_write>:
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	57                   	push   %edi
  8023a0:	56                   	push   %esi
  8023a1:	53                   	push   %ebx
  8023a2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8023a8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8023ad:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8023b3:	eb 2f                	jmp    8023e4 <devcons_write+0x48>
		m = n - tot;
  8023b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023b8:	29 f3                	sub    %esi,%ebx
  8023ba:	83 fb 7f             	cmp    $0x7f,%ebx
  8023bd:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8023c2:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	53                   	push   %ebx
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	03 45 0c             	add    0xc(%ebp),%eax
  8023ce:	50                   	push   %eax
  8023cf:	57                   	push   %edi
  8023d0:	e8 8e e5 ff ff       	call   800963 <memmove>
		sys_cputs(buf, m);
  8023d5:	83 c4 08             	add    $0x8,%esp
  8023d8:	53                   	push   %ebx
  8023d9:	57                   	push   %edi
  8023da:	e8 33 e7 ff ff       	call   800b12 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8023df:	01 de                	add    %ebx,%esi
  8023e1:	83 c4 10             	add    $0x10,%esp
  8023e4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023e7:	72 cc                	jb     8023b5 <devcons_write+0x19>
}
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ee:	5b                   	pop    %ebx
  8023ef:	5e                   	pop    %esi
  8023f0:	5f                   	pop    %edi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    

008023f3 <devcons_read>:
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
  8023f6:	83 ec 08             	sub    $0x8,%esp
  8023f9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8023fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802402:	75 07                	jne    80240b <devcons_read+0x18>
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    
		sys_yield();
  802406:	e8 a4 e7 ff ff       	call   800baf <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80240b:	e8 20 e7 ff ff       	call   800b30 <sys_cgetc>
  802410:	85 c0                	test   %eax,%eax
  802412:	74 f2                	je     802406 <devcons_read+0x13>
	if (c < 0)
  802414:	85 c0                	test   %eax,%eax
  802416:	78 ec                	js     802404 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802418:	83 f8 04             	cmp    $0x4,%eax
  80241b:	74 0c                	je     802429 <devcons_read+0x36>
	*(char*)vbuf = c;
  80241d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802420:	88 02                	mov    %al,(%edx)
	return 1;
  802422:	b8 01 00 00 00       	mov    $0x1,%eax
  802427:	eb db                	jmp    802404 <devcons_read+0x11>
		return 0;
  802429:	b8 00 00 00 00       	mov    $0x0,%eax
  80242e:	eb d4                	jmp    802404 <devcons_read+0x11>

00802430 <cputchar>:
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80243c:	6a 01                	push   $0x1
  80243e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802441:	50                   	push   %eax
  802442:	e8 cb e6 ff ff       	call   800b12 <sys_cputs>
}
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <getchar>:
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802452:	6a 01                	push   $0x1
  802454:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802457:	50                   	push   %eax
  802458:	6a 00                	push   $0x0
  80245a:	e8 66 ec ff ff       	call   8010c5 <read>
	if (r < 0)
  80245f:	83 c4 10             	add    $0x10,%esp
  802462:	85 c0                	test   %eax,%eax
  802464:	78 08                	js     80246e <getchar+0x22>
	if (r < 1)
  802466:	85 c0                	test   %eax,%eax
  802468:	7e 06                	jle    802470 <getchar+0x24>
	return c;
  80246a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    
		return -E_EOF;
  802470:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802475:	eb f7                	jmp    80246e <getchar+0x22>

00802477 <iscons>:
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80247d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802480:	50                   	push   %eax
  802481:	ff 75 08             	pushl  0x8(%ebp)
  802484:	e8 cb e9 ff ff       	call   800e54 <fd_lookup>
  802489:	83 c4 10             	add    $0x10,%esp
  80248c:	85 c0                	test   %eax,%eax
  80248e:	78 11                	js     8024a1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802499:	39 10                	cmp    %edx,(%eax)
  80249b:	0f 94 c0             	sete   %al
  80249e:	0f b6 c0             	movzbl %al,%eax
}
  8024a1:	c9                   	leave  
  8024a2:	c3                   	ret    

008024a3 <opencons>:
{
  8024a3:	55                   	push   %ebp
  8024a4:	89 e5                	mov    %esp,%ebp
  8024a6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8024a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ac:	50                   	push   %eax
  8024ad:	e8 53 e9 ff ff       	call   800e05 <fd_alloc>
  8024b2:	83 c4 10             	add    $0x10,%esp
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	78 3a                	js     8024f3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024b9:	83 ec 04             	sub    $0x4,%esp
  8024bc:	68 07 04 00 00       	push   $0x407
  8024c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8024c4:	6a 00                	push   $0x0
  8024c6:	e8 03 e7 ff ff       	call   800bce <sys_page_alloc>
  8024cb:	83 c4 10             	add    $0x10,%esp
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	78 21                	js     8024f3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024db:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024e7:	83 ec 0c             	sub    $0xc,%esp
  8024ea:	50                   	push   %eax
  8024eb:	e8 ee e8 ff ff       	call   800dde <fd2num>
  8024f0:	83 c4 10             	add    $0x10,%esp
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	56                   	push   %esi
  8024f9:	53                   	push   %ebx
  8024fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8024fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802500:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802503:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802505:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80250a:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  80250d:	83 ec 0c             	sub    $0xc,%esp
  802510:	50                   	push   %eax
  802511:	e8 68 e8 ff ff       	call   800d7e <sys_ipc_recv>
	if (from_env_store)
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	85 f6                	test   %esi,%esi
  80251b:	74 14                	je     802531 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  80251d:	ba 00 00 00 00       	mov    $0x0,%edx
  802522:	85 c0                	test   %eax,%eax
  802524:	78 09                	js     80252f <ipc_recv+0x3a>
  802526:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80252c:	8b 52 74             	mov    0x74(%edx),%edx
  80252f:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802531:	85 db                	test   %ebx,%ebx
  802533:	74 14                	je     802549 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802535:	ba 00 00 00 00       	mov    $0x0,%edx
  80253a:	85 c0                	test   %eax,%eax
  80253c:	78 09                	js     802547 <ipc_recv+0x52>
  80253e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802544:	8b 52 78             	mov    0x78(%edx),%edx
  802547:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802549:	85 c0                	test   %eax,%eax
  80254b:	78 08                	js     802555 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80254d:	a1 08 40 80 00       	mov    0x804008,%eax
  802552:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802555:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802558:	5b                   	pop    %ebx
  802559:	5e                   	pop    %esi
  80255a:	5d                   	pop    %ebp
  80255b:	c3                   	ret    

0080255c <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	57                   	push   %edi
  802560:	56                   	push   %esi
  802561:	53                   	push   %ebx
  802562:	83 ec 0c             	sub    $0xc,%esp
  802565:	8b 7d 08             	mov    0x8(%ebp),%edi
  802568:	8b 75 0c             	mov    0xc(%ebp),%esi
  80256b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80256e:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802570:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802575:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802578:	ff 75 14             	pushl  0x14(%ebp)
  80257b:	53                   	push   %ebx
  80257c:	56                   	push   %esi
  80257d:	57                   	push   %edi
  80257e:	e8 d8 e7 ff ff       	call   800d5b <sys_ipc_try_send>
		if (ret == 0)
  802583:	83 c4 10             	add    $0x10,%esp
  802586:	85 c0                	test   %eax,%eax
  802588:	74 1e                	je     8025a8 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80258a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80258d:	75 07                	jne    802596 <ipc_send+0x3a>
			sys_yield();
  80258f:	e8 1b e6 ff ff       	call   800baf <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802594:	eb e2                	jmp    802578 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802596:	50                   	push   %eax
  802597:	68 08 2e 80 00       	push   $0x802e08
  80259c:	6a 3d                	push   $0x3d
  80259e:	68 1c 2e 80 00       	push   $0x802e1c
  8025a3:	e8 33 db ff ff       	call   8000db <_panic>
	}
	// panic("ipc_send not implemented");
}
  8025a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    

008025b0 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025bb:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025be:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025c4:	8b 52 50             	mov    0x50(%edx),%edx
  8025c7:	39 ca                	cmp    %ecx,%edx
  8025c9:	74 11                	je     8025dc <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8025cb:	83 c0 01             	add    $0x1,%eax
  8025ce:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025d3:	75 e6                	jne    8025bb <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025da:	eb 0b                	jmp    8025e7 <ipc_find_env+0x37>
			return envs[i].env_id;
  8025dc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8025e4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8025e7:	5d                   	pop    %ebp
  8025e8:	c3                   	ret    

008025e9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025ef:	89 d0                	mov    %edx,%eax
  8025f1:	c1 e8 16             	shr    $0x16,%eax
  8025f4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802600:	f6 c1 01             	test   $0x1,%cl
  802603:	74 1d                	je     802622 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802605:	c1 ea 0c             	shr    $0xc,%edx
  802608:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80260f:	f6 c2 01             	test   $0x1,%dl
  802612:	74 0e                	je     802622 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802614:	c1 ea 0c             	shr    $0xc,%edx
  802617:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80261e:	ef 
  80261f:	0f b7 c0             	movzwl %ax,%eax
}
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
  802624:	66 90                	xchg   %ax,%ax
  802626:	66 90                	xchg   %ax,%ax
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__udivdi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	53                   	push   %ebx
  802634:	83 ec 1c             	sub    $0x1c,%esp
  802637:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80263b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80263f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802643:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802647:	85 d2                	test   %edx,%edx
  802649:	75 35                	jne    802680 <__udivdi3+0x50>
  80264b:	39 f3                	cmp    %esi,%ebx
  80264d:	0f 87 bd 00 00 00    	ja     802710 <__udivdi3+0xe0>
  802653:	85 db                	test   %ebx,%ebx
  802655:	89 d9                	mov    %ebx,%ecx
  802657:	75 0b                	jne    802664 <__udivdi3+0x34>
  802659:	b8 01 00 00 00       	mov    $0x1,%eax
  80265e:	31 d2                	xor    %edx,%edx
  802660:	f7 f3                	div    %ebx
  802662:	89 c1                	mov    %eax,%ecx
  802664:	31 d2                	xor    %edx,%edx
  802666:	89 f0                	mov    %esi,%eax
  802668:	f7 f1                	div    %ecx
  80266a:	89 c6                	mov    %eax,%esi
  80266c:	89 e8                	mov    %ebp,%eax
  80266e:	89 f7                	mov    %esi,%edi
  802670:	f7 f1                	div    %ecx
  802672:	89 fa                	mov    %edi,%edx
  802674:	83 c4 1c             	add    $0x1c,%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5f                   	pop    %edi
  80267a:	5d                   	pop    %ebp
  80267b:	c3                   	ret    
  80267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802680:	39 f2                	cmp    %esi,%edx
  802682:	77 7c                	ja     802700 <__udivdi3+0xd0>
  802684:	0f bd fa             	bsr    %edx,%edi
  802687:	83 f7 1f             	xor    $0x1f,%edi
  80268a:	0f 84 98 00 00 00    	je     802728 <__udivdi3+0xf8>
  802690:	89 f9                	mov    %edi,%ecx
  802692:	b8 20 00 00 00       	mov    $0x20,%eax
  802697:	29 f8                	sub    %edi,%eax
  802699:	d3 e2                	shl    %cl,%edx
  80269b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80269f:	89 c1                	mov    %eax,%ecx
  8026a1:	89 da                	mov    %ebx,%edx
  8026a3:	d3 ea                	shr    %cl,%edx
  8026a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8026a9:	09 d1                	or     %edx,%ecx
  8026ab:	89 f2                	mov    %esi,%edx
  8026ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026b1:	89 f9                	mov    %edi,%ecx
  8026b3:	d3 e3                	shl    %cl,%ebx
  8026b5:	89 c1                	mov    %eax,%ecx
  8026b7:	d3 ea                	shr    %cl,%edx
  8026b9:	89 f9                	mov    %edi,%ecx
  8026bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8026bf:	d3 e6                	shl    %cl,%esi
  8026c1:	89 eb                	mov    %ebp,%ebx
  8026c3:	89 c1                	mov    %eax,%ecx
  8026c5:	d3 eb                	shr    %cl,%ebx
  8026c7:	09 de                	or     %ebx,%esi
  8026c9:	89 f0                	mov    %esi,%eax
  8026cb:	f7 74 24 08          	divl   0x8(%esp)
  8026cf:	89 d6                	mov    %edx,%esi
  8026d1:	89 c3                	mov    %eax,%ebx
  8026d3:	f7 64 24 0c          	mull   0xc(%esp)
  8026d7:	39 d6                	cmp    %edx,%esi
  8026d9:	72 0c                	jb     8026e7 <__udivdi3+0xb7>
  8026db:	89 f9                	mov    %edi,%ecx
  8026dd:	d3 e5                	shl    %cl,%ebp
  8026df:	39 c5                	cmp    %eax,%ebp
  8026e1:	73 5d                	jae    802740 <__udivdi3+0x110>
  8026e3:	39 d6                	cmp    %edx,%esi
  8026e5:	75 59                	jne    802740 <__udivdi3+0x110>
  8026e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8026ea:	31 ff                	xor    %edi,%edi
  8026ec:	89 fa                	mov    %edi,%edx
  8026ee:	83 c4 1c             	add    $0x1c,%esp
  8026f1:	5b                   	pop    %ebx
  8026f2:	5e                   	pop    %esi
  8026f3:	5f                   	pop    %edi
  8026f4:	5d                   	pop    %ebp
  8026f5:	c3                   	ret    
  8026f6:	8d 76 00             	lea    0x0(%esi),%esi
  8026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802700:	31 ff                	xor    %edi,%edi
  802702:	31 c0                	xor    %eax,%eax
  802704:	89 fa                	mov    %edi,%edx
  802706:	83 c4 1c             	add    $0x1c,%esp
  802709:	5b                   	pop    %ebx
  80270a:	5e                   	pop    %esi
  80270b:	5f                   	pop    %edi
  80270c:	5d                   	pop    %ebp
  80270d:	c3                   	ret    
  80270e:	66 90                	xchg   %ax,%ax
  802710:	31 ff                	xor    %edi,%edi
  802712:	89 e8                	mov    %ebp,%eax
  802714:	89 f2                	mov    %esi,%edx
  802716:	f7 f3                	div    %ebx
  802718:	89 fa                	mov    %edi,%edx
  80271a:	83 c4 1c             	add    $0x1c,%esp
  80271d:	5b                   	pop    %ebx
  80271e:	5e                   	pop    %esi
  80271f:	5f                   	pop    %edi
  802720:	5d                   	pop    %ebp
  802721:	c3                   	ret    
  802722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802728:	39 f2                	cmp    %esi,%edx
  80272a:	72 06                	jb     802732 <__udivdi3+0x102>
  80272c:	31 c0                	xor    %eax,%eax
  80272e:	39 eb                	cmp    %ebp,%ebx
  802730:	77 d2                	ja     802704 <__udivdi3+0xd4>
  802732:	b8 01 00 00 00       	mov    $0x1,%eax
  802737:	eb cb                	jmp    802704 <__udivdi3+0xd4>
  802739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802740:	89 d8                	mov    %ebx,%eax
  802742:	31 ff                	xor    %edi,%edi
  802744:	eb be                	jmp    802704 <__udivdi3+0xd4>
  802746:	66 90                	xchg   %ax,%ax
  802748:	66 90                	xchg   %ax,%ax
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	66 90                	xchg   %ax,%ax
  80274e:	66 90                	xchg   %ax,%ax

00802750 <__umoddi3>:
  802750:	55                   	push   %ebp
  802751:	57                   	push   %edi
  802752:	56                   	push   %esi
  802753:	53                   	push   %ebx
  802754:	83 ec 1c             	sub    $0x1c,%esp
  802757:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80275b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80275f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802763:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802767:	85 ed                	test   %ebp,%ebp
  802769:	89 f0                	mov    %esi,%eax
  80276b:	89 da                	mov    %ebx,%edx
  80276d:	75 19                	jne    802788 <__umoddi3+0x38>
  80276f:	39 df                	cmp    %ebx,%edi
  802771:	0f 86 b1 00 00 00    	jbe    802828 <__umoddi3+0xd8>
  802777:	f7 f7                	div    %edi
  802779:	89 d0                	mov    %edx,%eax
  80277b:	31 d2                	xor    %edx,%edx
  80277d:	83 c4 1c             	add    $0x1c,%esp
  802780:	5b                   	pop    %ebx
  802781:	5e                   	pop    %esi
  802782:	5f                   	pop    %edi
  802783:	5d                   	pop    %ebp
  802784:	c3                   	ret    
  802785:	8d 76 00             	lea    0x0(%esi),%esi
  802788:	39 dd                	cmp    %ebx,%ebp
  80278a:	77 f1                	ja     80277d <__umoddi3+0x2d>
  80278c:	0f bd cd             	bsr    %ebp,%ecx
  80278f:	83 f1 1f             	xor    $0x1f,%ecx
  802792:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802796:	0f 84 b4 00 00 00    	je     802850 <__umoddi3+0x100>
  80279c:	b8 20 00 00 00       	mov    $0x20,%eax
  8027a1:	89 c2                	mov    %eax,%edx
  8027a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027a7:	29 c2                	sub    %eax,%edx
  8027a9:	89 c1                	mov    %eax,%ecx
  8027ab:	89 f8                	mov    %edi,%eax
  8027ad:	d3 e5                	shl    %cl,%ebp
  8027af:	89 d1                	mov    %edx,%ecx
  8027b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027b5:	d3 e8                	shr    %cl,%eax
  8027b7:	09 c5                	or     %eax,%ebp
  8027b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027bd:	89 c1                	mov    %eax,%ecx
  8027bf:	d3 e7                	shl    %cl,%edi
  8027c1:	89 d1                	mov    %edx,%ecx
  8027c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027c7:	89 df                	mov    %ebx,%edi
  8027c9:	d3 ef                	shr    %cl,%edi
  8027cb:	89 c1                	mov    %eax,%ecx
  8027cd:	89 f0                	mov    %esi,%eax
  8027cf:	d3 e3                	shl    %cl,%ebx
  8027d1:	89 d1                	mov    %edx,%ecx
  8027d3:	89 fa                	mov    %edi,%edx
  8027d5:	d3 e8                	shr    %cl,%eax
  8027d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8027dc:	09 d8                	or     %ebx,%eax
  8027de:	f7 f5                	div    %ebp
  8027e0:	d3 e6                	shl    %cl,%esi
  8027e2:	89 d1                	mov    %edx,%ecx
  8027e4:	f7 64 24 08          	mull   0x8(%esp)
  8027e8:	39 d1                	cmp    %edx,%ecx
  8027ea:	89 c3                	mov    %eax,%ebx
  8027ec:	89 d7                	mov    %edx,%edi
  8027ee:	72 06                	jb     8027f6 <__umoddi3+0xa6>
  8027f0:	75 0e                	jne    802800 <__umoddi3+0xb0>
  8027f2:	39 c6                	cmp    %eax,%esi
  8027f4:	73 0a                	jae    802800 <__umoddi3+0xb0>
  8027f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8027fa:	19 ea                	sbb    %ebp,%edx
  8027fc:	89 d7                	mov    %edx,%edi
  8027fe:	89 c3                	mov    %eax,%ebx
  802800:	89 ca                	mov    %ecx,%edx
  802802:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802807:	29 de                	sub    %ebx,%esi
  802809:	19 fa                	sbb    %edi,%edx
  80280b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80280f:	89 d0                	mov    %edx,%eax
  802811:	d3 e0                	shl    %cl,%eax
  802813:	89 d9                	mov    %ebx,%ecx
  802815:	d3 ee                	shr    %cl,%esi
  802817:	d3 ea                	shr    %cl,%edx
  802819:	09 f0                	or     %esi,%eax
  80281b:	83 c4 1c             	add    $0x1c,%esp
  80281e:	5b                   	pop    %ebx
  80281f:	5e                   	pop    %esi
  802820:	5f                   	pop    %edi
  802821:	5d                   	pop    %ebp
  802822:	c3                   	ret    
  802823:	90                   	nop
  802824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802828:	85 ff                	test   %edi,%edi
  80282a:	89 f9                	mov    %edi,%ecx
  80282c:	75 0b                	jne    802839 <__umoddi3+0xe9>
  80282e:	b8 01 00 00 00       	mov    $0x1,%eax
  802833:	31 d2                	xor    %edx,%edx
  802835:	f7 f7                	div    %edi
  802837:	89 c1                	mov    %eax,%ecx
  802839:	89 d8                	mov    %ebx,%eax
  80283b:	31 d2                	xor    %edx,%edx
  80283d:	f7 f1                	div    %ecx
  80283f:	89 f0                	mov    %esi,%eax
  802841:	f7 f1                	div    %ecx
  802843:	e9 31 ff ff ff       	jmp    802779 <__umoddi3+0x29>
  802848:	90                   	nop
  802849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802850:	39 dd                	cmp    %ebx,%ebp
  802852:	72 08                	jb     80285c <__umoddi3+0x10c>
  802854:	39 f7                	cmp    %esi,%edi
  802856:	0f 87 21 ff ff ff    	ja     80277d <__umoddi3+0x2d>
  80285c:	89 da                	mov    %ebx,%edx
  80285e:	89 f0                	mov    %esi,%eax
  802860:	29 f8                	sub    %edi,%eax
  802862:	19 ea                	sbb    %ebp,%edx
  802864:	e9 14 ff ff ff       	jmp    80277d <__umoddi3+0x2d>

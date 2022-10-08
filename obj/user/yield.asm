
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 69 00 00 00       	call   80009a <libmain>
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
  800037:	83 ec 0c             	sub    $0xc,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	50                   	push   %eax
  800043:	68 a0 22 80 00       	push   $0x8022a0
  800048:	e8 42 01 00 00       	call   80018f <cprintf>
  80004d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 5; i++) {
  800050:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800055:	e8 2e 0b 00 00       	call   800b88 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("Back in environment %08x, iteration %d.\n",
  80005f:	8b 40 48             	mov    0x48(%eax),%eax
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	53                   	push   %ebx
  800066:	50                   	push   %eax
  800067:	68 c0 22 80 00       	push   $0x8022c0
  80006c:	e8 1e 01 00 00       	call   80018f <cprintf>
	for (i = 0; i < 5; i++) {
  800071:	83 c3 01             	add    $0x1,%ebx
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	83 fb 05             	cmp    $0x5,%ebx
  80007a:	75 d9                	jne    800055 <umain+0x22>
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  80007c:	a1 08 40 80 00       	mov    0x804008,%eax
  800081:	8b 40 48             	mov    0x48(%eax),%eax
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	50                   	push   %eax
  800088:	68 ec 22 80 00       	push   $0x8022ec
  80008d:	e8 fd 00 00 00       	call   80018f <cprintf>
}
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800098:	c9                   	leave  
  800099:	c3                   	ret    

0080009a <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	56                   	push   %esi
  80009e:	53                   	push   %ebx
  80009f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a5:	e8 bf 0a 00 00       	call   800b69 <sys_getenvid>
  8000aa:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000af:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b7:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bc:	85 db                	test   %ebx,%ebx
  8000be:	7e 07                	jle    8000c7 <libmain+0x2d>
		binaryname = argv[0];
  8000c0:	8b 06                	mov    (%esi),%eax
  8000c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
  8000cc:	e8 62 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d1:	e8 0a 00 00 00       	call   8000e0 <exit>
}
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000dc:	5b                   	pop    %ebx
  8000dd:	5e                   	pop    %esi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000e6:	e8 a2 0e 00 00       	call   800f8d <close_all>
	sys_env_destroy(0);
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	6a 00                	push   $0x0
  8000f0:	e8 33 0a 00 00       	call   800b28 <sys_env_destroy>
}
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	c9                   	leave  
  8000f9:	c3                   	ret    

008000fa <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fa:	55                   	push   %ebp
  8000fb:	89 e5                	mov    %esp,%ebp
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 04             	sub    $0x4,%esp
  800101:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800104:	8b 13                	mov    (%ebx),%edx
  800106:	8d 42 01             	lea    0x1(%edx),%eax
  800109:	89 03                	mov    %eax,(%ebx)
  80010b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80010e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800112:	3d ff 00 00 00       	cmp    $0xff,%eax
  800117:	74 09                	je     800122 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800119:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80011d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800120:	c9                   	leave  
  800121:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800122:	83 ec 08             	sub    $0x8,%esp
  800125:	68 ff 00 00 00       	push   $0xff
  80012a:	8d 43 08             	lea    0x8(%ebx),%eax
  80012d:	50                   	push   %eax
  80012e:	e8 b8 09 00 00       	call   800aeb <sys_cputs>
		b->idx = 0;
  800133:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	eb db                	jmp    800119 <putch+0x1f>

0080013e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013e:	55                   	push   %ebp
  80013f:	89 e5                	mov    %esp,%ebp
  800141:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800147:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014e:	00 00 00 
	b.cnt = 0;
  800151:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800158:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015b:	ff 75 0c             	pushl  0xc(%ebp)
  80015e:	ff 75 08             	pushl  0x8(%ebp)
  800161:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	68 fa 00 80 00       	push   $0x8000fa
  80016d:	e8 1a 01 00 00       	call   80028c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800172:	83 c4 08             	add    $0x8,%esp
  800175:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80017b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	e8 64 09 00 00       	call   800aeb <sys_cputs>

	return b.cnt;
}
  800187:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80018d:	c9                   	leave  
  80018e:	c3                   	ret    

0080018f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800195:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800198:	50                   	push   %eax
  800199:	ff 75 08             	pushl  0x8(%ebp)
  80019c:	e8 9d ff ff ff       	call   80013e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a1:	c9                   	leave  
  8001a2:	c3                   	ret    

008001a3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 1c             	sub    $0x1c,%esp
  8001ac:	89 c7                	mov    %eax,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001c4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001c7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001ca:	39 d3                	cmp    %edx,%ebx
  8001cc:	72 05                	jb     8001d3 <printnum+0x30>
  8001ce:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d1:	77 7a                	ja     80024d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001d3:	83 ec 0c             	sub    $0xc,%esp
  8001d6:	ff 75 18             	pushl  0x18(%ebp)
  8001d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8001dc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001df:	53                   	push   %ebx
  8001e0:	ff 75 10             	pushl  0x10(%ebp)
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ec:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ef:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f2:	e8 59 1e 00 00       	call   802050 <__udivdi3>
  8001f7:	83 c4 18             	add    $0x18,%esp
  8001fa:	52                   	push   %edx
  8001fb:	50                   	push   %eax
  8001fc:	89 f2                	mov    %esi,%edx
  8001fe:	89 f8                	mov    %edi,%eax
  800200:	e8 9e ff ff ff       	call   8001a3 <printnum>
  800205:	83 c4 20             	add    $0x20,%esp
  800208:	eb 13                	jmp    80021d <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80020a:	83 ec 08             	sub    $0x8,%esp
  80020d:	56                   	push   %esi
  80020e:	ff 75 18             	pushl  0x18(%ebp)
  800211:	ff d7                	call   *%edi
  800213:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800216:	83 eb 01             	sub    $0x1,%ebx
  800219:	85 db                	test   %ebx,%ebx
  80021b:	7f ed                	jg     80020a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	83 ec 04             	sub    $0x4,%esp
  800224:	ff 75 e4             	pushl  -0x1c(%ebp)
  800227:	ff 75 e0             	pushl  -0x20(%ebp)
  80022a:	ff 75 dc             	pushl  -0x24(%ebp)
  80022d:	ff 75 d8             	pushl  -0x28(%ebp)
  800230:	e8 3b 1f 00 00       	call   802170 <__umoddi3>
  800235:	83 c4 14             	add    $0x14,%esp
  800238:	0f be 80 15 23 80 00 	movsbl 0x802315(%eax),%eax
  80023f:	50                   	push   %eax
  800240:	ff d7                	call   *%edi
}
  800242:	83 c4 10             	add    $0x10,%esp
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
  80024d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800250:	eb c4                	jmp    800216 <printnum+0x73>

00800252 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800258:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80025c:	8b 10                	mov    (%eax),%edx
  80025e:	3b 50 04             	cmp    0x4(%eax),%edx
  800261:	73 0a                	jae    80026d <sprintputch+0x1b>
		*b->buf++ = ch;
  800263:	8d 4a 01             	lea    0x1(%edx),%ecx
  800266:	89 08                	mov    %ecx,(%eax)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	88 02                	mov    %al,(%edx)
}
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <printfmt>:
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800275:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 10             	pushl  0x10(%ebp)
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	ff 75 08             	pushl  0x8(%ebp)
  800282:	e8 05 00 00 00       	call   80028c <vprintfmt>
}
  800287:	83 c4 10             	add    $0x10,%esp
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <vprintfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	57                   	push   %edi
  800290:	56                   	push   %esi
  800291:	53                   	push   %ebx
  800292:	83 ec 2c             	sub    $0x2c,%esp
  800295:	8b 75 08             	mov    0x8(%ebp),%esi
  800298:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80029b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80029e:	e9 c1 03 00 00       	jmp    800664 <vprintfmt+0x3d8>
		padc = ' ';
  8002a3:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002a7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c1:	8d 47 01             	lea    0x1(%edi),%eax
  8002c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002c7:	0f b6 17             	movzbl (%edi),%edx
  8002ca:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002cd:	3c 55                	cmp    $0x55,%al
  8002cf:	0f 87 12 04 00 00    	ja     8006e7 <vprintfmt+0x45b>
  8002d5:	0f b6 c0             	movzbl %al,%eax
  8002d8:	ff 24 85 60 24 80 00 	jmp    *0x802460(,%eax,4)
  8002df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002e6:	eb d9                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002eb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002ef:	eb d0                	jmp    8002c1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f1:	0f b6 d2             	movzbl %dl,%edx
  8002f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8002fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002ff:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800302:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800306:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800309:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80030c:	83 f9 09             	cmp    $0x9,%ecx
  80030f:	77 55                	ja     800366 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800311:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800314:	eb e9                	jmp    8002ff <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800316:	8b 45 14             	mov    0x14(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80031e:	8b 45 14             	mov    0x14(%ebp),%eax
  800321:	8d 40 04             	lea    0x4(%eax),%eax
  800324:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80032a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032e:	79 91                	jns    8002c1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800330:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800333:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800336:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80033d:	eb 82                	jmp    8002c1 <vprintfmt+0x35>
  80033f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800342:	85 c0                	test   %eax,%eax
  800344:	ba 00 00 00 00       	mov    $0x0,%edx
  800349:	0f 49 d0             	cmovns %eax,%edx
  80034c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800352:	e9 6a ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80035a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800361:	e9 5b ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
  800366:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800369:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80036c:	eb bc                	jmp    80032a <vprintfmt+0x9e>
			lflag++;
  80036e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800374:	e9 48 ff ff ff       	jmp    8002c1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800379:	8b 45 14             	mov    0x14(%ebp),%eax
  80037c:	8d 78 04             	lea    0x4(%eax),%edi
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	53                   	push   %ebx
  800383:	ff 30                	pushl  (%eax)
  800385:	ff d6                	call   *%esi
			break;
  800387:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80038a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80038d:	e9 cf 02 00 00       	jmp    800661 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	8d 78 04             	lea    0x4(%eax),%edi
  800398:	8b 00                	mov    (%eax),%eax
  80039a:	99                   	cltd   
  80039b:	31 d0                	xor    %edx,%eax
  80039d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80039f:	83 f8 0f             	cmp    $0xf,%eax
  8003a2:	7f 23                	jg     8003c7 <vprintfmt+0x13b>
  8003a4:	8b 14 85 c0 25 80 00 	mov    0x8025c0(,%eax,4),%edx
  8003ab:	85 d2                	test   %edx,%edx
  8003ad:	74 18                	je     8003c7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003af:	52                   	push   %edx
  8003b0:	68 f5 26 80 00       	push   $0x8026f5
  8003b5:	53                   	push   %ebx
  8003b6:	56                   	push   %esi
  8003b7:	e8 b3 fe ff ff       	call   80026f <printfmt>
  8003bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c2:	e9 9a 02 00 00       	jmp    800661 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003c7:	50                   	push   %eax
  8003c8:	68 2d 23 80 00       	push   $0x80232d
  8003cd:	53                   	push   %ebx
  8003ce:	56                   	push   %esi
  8003cf:	e8 9b fe ff ff       	call   80026f <printfmt>
  8003d4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003da:	e9 82 02 00 00       	jmp    800661 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003df:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e2:	83 c0 04             	add    $0x4,%eax
  8003e5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003ed:	85 ff                	test   %edi,%edi
  8003ef:	b8 26 23 80 00       	mov    $0x802326,%eax
  8003f4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003fb:	0f 8e bd 00 00 00    	jle    8004be <vprintfmt+0x232>
  800401:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800405:	75 0e                	jne    800415 <vprintfmt+0x189>
  800407:	89 75 08             	mov    %esi,0x8(%ebp)
  80040a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80040d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800410:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800413:	eb 6d                	jmp    800482 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800415:	83 ec 08             	sub    $0x8,%esp
  800418:	ff 75 d0             	pushl  -0x30(%ebp)
  80041b:	57                   	push   %edi
  80041c:	e8 6e 03 00 00       	call   80078f <strnlen>
  800421:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800424:	29 c1                	sub    %eax,%ecx
  800426:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800429:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80042c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800436:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800438:	eb 0f                	jmp    800449 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80043a:	83 ec 08             	sub    $0x8,%esp
  80043d:	53                   	push   %ebx
  80043e:	ff 75 e0             	pushl  -0x20(%ebp)
  800441:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800443:	83 ef 01             	sub    $0x1,%edi
  800446:	83 c4 10             	add    $0x10,%esp
  800449:	85 ff                	test   %edi,%edi
  80044b:	7f ed                	jg     80043a <vprintfmt+0x1ae>
  80044d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800450:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800453:	85 c9                	test   %ecx,%ecx
  800455:	b8 00 00 00 00       	mov    $0x0,%eax
  80045a:	0f 49 c1             	cmovns %ecx,%eax
  80045d:	29 c1                	sub    %eax,%ecx
  80045f:	89 75 08             	mov    %esi,0x8(%ebp)
  800462:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800465:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800468:	89 cb                	mov    %ecx,%ebx
  80046a:	eb 16                	jmp    800482 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80046c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800470:	75 31                	jne    8004a3 <vprintfmt+0x217>
					putch(ch, putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	50                   	push   %eax
  800479:	ff 55 08             	call   *0x8(%ebp)
  80047c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80047f:	83 eb 01             	sub    $0x1,%ebx
  800482:	83 c7 01             	add    $0x1,%edi
  800485:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800489:	0f be c2             	movsbl %dl,%eax
  80048c:	85 c0                	test   %eax,%eax
  80048e:	74 59                	je     8004e9 <vprintfmt+0x25d>
  800490:	85 f6                	test   %esi,%esi
  800492:	78 d8                	js     80046c <vprintfmt+0x1e0>
  800494:	83 ee 01             	sub    $0x1,%esi
  800497:	79 d3                	jns    80046c <vprintfmt+0x1e0>
  800499:	89 df                	mov    %ebx,%edi
  80049b:	8b 75 08             	mov    0x8(%ebp),%esi
  80049e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a1:	eb 37                	jmp    8004da <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a3:	0f be d2             	movsbl %dl,%edx
  8004a6:	83 ea 20             	sub    $0x20,%edx
  8004a9:	83 fa 5e             	cmp    $0x5e,%edx
  8004ac:	76 c4                	jbe    800472 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	ff 75 0c             	pushl  0xc(%ebp)
  8004b4:	6a 3f                	push   $0x3f
  8004b6:	ff 55 08             	call   *0x8(%ebp)
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	eb c1                	jmp    80047f <vprintfmt+0x1f3>
  8004be:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004ca:	eb b6                	jmp    800482 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	53                   	push   %ebx
  8004d0:	6a 20                	push   $0x20
  8004d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d4:	83 ef 01             	sub    $0x1,%edi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	85 ff                	test   %edi,%edi
  8004dc:	7f ee                	jg     8004cc <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e4:	e9 78 01 00 00       	jmp    800661 <vprintfmt+0x3d5>
  8004e9:	89 df                	mov    %ebx,%edi
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f1:	eb e7                	jmp    8004da <vprintfmt+0x24e>
	if (lflag >= 2)
  8004f3:	83 f9 01             	cmp    $0x1,%ecx
  8004f6:	7e 3f                	jle    800537 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8b 50 04             	mov    0x4(%eax),%edx
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800503:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8d 40 08             	lea    0x8(%eax),%eax
  80050c:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80050f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800513:	79 5c                	jns    800571 <vprintfmt+0x2e5>
				putch('-', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 2d                	push   $0x2d
  80051b:	ff d6                	call   *%esi
				num = -(long long) num;
  80051d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800520:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800523:	f7 da                	neg    %edx
  800525:	83 d1 00             	adc    $0x0,%ecx
  800528:	f7 d9                	neg    %ecx
  80052a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800532:	e9 10 01 00 00       	jmp    800647 <vprintfmt+0x3bb>
	else if (lflag)
  800537:	85 c9                	test   %ecx,%ecx
  800539:	75 1b                	jne    800556 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	89 c1                	mov    %eax,%ecx
  800545:	c1 f9 1f             	sar    $0x1f,%ecx
  800548:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 40 04             	lea    0x4(%eax),%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	eb b9                	jmp    80050f <vprintfmt+0x283>
		return va_arg(*ap, long);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055e:	89 c1                	mov    %eax,%ecx
  800560:	c1 f9 1f             	sar    $0x1f,%ecx
  800563:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
  80056f:	eb 9e                	jmp    80050f <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800577:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057c:	e9 c6 00 00 00       	jmp    800647 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800581:	83 f9 01             	cmp    $0x1,%ecx
  800584:	7e 18                	jle    80059e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	8b 10                	mov    (%eax),%edx
  80058b:	8b 48 04             	mov    0x4(%eax),%ecx
  80058e:	8d 40 08             	lea    0x8(%eax),%eax
  800591:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800594:	b8 0a 00 00 00       	mov    $0xa,%eax
  800599:	e9 a9 00 00 00       	jmp    800647 <vprintfmt+0x3bb>
	else if (lflag)
  80059e:	85 c9                	test   %ecx,%ecx
  8005a0:	75 1a                	jne    8005bc <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ac:	8d 40 04             	lea    0x4(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b7:	e9 8b 00 00 00       	jmp    800647 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8b 10                	mov    (%eax),%edx
  8005c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d1:	eb 74                	jmp    800647 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005d3:	83 f9 01             	cmp    $0x1,%ecx
  8005d6:	7e 15                	jle    8005ed <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 10                	mov    (%eax),%edx
  8005dd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e0:	8d 40 08             	lea    0x8(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8005eb:	eb 5a                	jmp    800647 <vprintfmt+0x3bb>
	else if (lflag)
  8005ed:	85 c9                	test   %ecx,%ecx
  8005ef:	75 17                	jne    800608 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8b 10                	mov    (%eax),%edx
  8005f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fb:	8d 40 04             	lea    0x4(%eax),%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800601:	b8 08 00 00 00       	mov    $0x8,%eax
  800606:	eb 3f                	jmp    800647 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8b 10                	mov    (%eax),%edx
  80060d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800612:	8d 40 04             	lea    0x4(%eax),%eax
  800615:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800618:	b8 08 00 00 00       	mov    $0x8,%eax
  80061d:	eb 28                	jmp    800647 <vprintfmt+0x3bb>
			putch('0', putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	53                   	push   %ebx
  800623:	6a 30                	push   $0x30
  800625:	ff d6                	call   *%esi
			putch('x', putdat);
  800627:	83 c4 08             	add    $0x8,%esp
  80062a:	53                   	push   %ebx
  80062b:	6a 78                	push   $0x78
  80062d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 10                	mov    (%eax),%edx
  800634:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800639:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800642:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80064e:	57                   	push   %edi
  80064f:	ff 75 e0             	pushl  -0x20(%ebp)
  800652:	50                   	push   %eax
  800653:	51                   	push   %ecx
  800654:	52                   	push   %edx
  800655:	89 da                	mov    %ebx,%edx
  800657:	89 f0                	mov    %esi,%eax
  800659:	e8 45 fb ff ff       	call   8001a3 <printnum>
			break;
  80065e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800661:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800664:	83 c7 01             	add    $0x1,%edi
  800667:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80066b:	83 f8 25             	cmp    $0x25,%eax
  80066e:	0f 84 2f fc ff ff    	je     8002a3 <vprintfmt+0x17>
			if (ch == '\0')
  800674:	85 c0                	test   %eax,%eax
  800676:	0f 84 8b 00 00 00    	je     800707 <vprintfmt+0x47b>
			putch(ch, putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	53                   	push   %ebx
  800680:	50                   	push   %eax
  800681:	ff d6                	call   *%esi
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	eb dc                	jmp    800664 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800688:	83 f9 01             	cmp    $0x1,%ecx
  80068b:	7e 15                	jle    8006a2 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8b 10                	mov    (%eax),%edx
  800692:	8b 48 04             	mov    0x4(%eax),%ecx
  800695:	8d 40 08             	lea    0x8(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069b:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a0:	eb a5                	jmp    800647 <vprintfmt+0x3bb>
	else if (lflag)
  8006a2:	85 c9                	test   %ecx,%ecx
  8006a4:	75 17                	jne    8006bd <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b0:	8d 40 04             	lea    0x4(%eax),%eax
  8006b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8006bb:	eb 8a                	jmp    800647 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c0:	8b 10                	mov    (%eax),%edx
  8006c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006c7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d2:	e9 70 ff ff ff       	jmp    800647 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	6a 25                	push   $0x25
  8006dd:	ff d6                	call   *%esi
			break;
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	e9 7a ff ff ff       	jmp    800661 <vprintfmt+0x3d5>
			putch('%', putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	53                   	push   %ebx
  8006eb:	6a 25                	push   $0x25
  8006ed:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006ef:	83 c4 10             	add    $0x10,%esp
  8006f2:	89 f8                	mov    %edi,%eax
  8006f4:	eb 03                	jmp    8006f9 <vprintfmt+0x46d>
  8006f6:	83 e8 01             	sub    $0x1,%eax
  8006f9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006fd:	75 f7                	jne    8006f6 <vprintfmt+0x46a>
  8006ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800702:	e9 5a ff ff ff       	jmp    800661 <vprintfmt+0x3d5>
}
  800707:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80070a:	5b                   	pop    %ebx
  80070b:	5e                   	pop    %esi
  80070c:	5f                   	pop    %edi
  80070d:	5d                   	pop    %ebp
  80070e:	c3                   	ret    

0080070f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	83 ec 18             	sub    $0x18,%esp
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80071b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80071e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800722:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800725:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80072c:	85 c0                	test   %eax,%eax
  80072e:	74 26                	je     800756 <vsnprintf+0x47>
  800730:	85 d2                	test   %edx,%edx
  800732:	7e 22                	jle    800756 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800734:	ff 75 14             	pushl  0x14(%ebp)
  800737:	ff 75 10             	pushl  0x10(%ebp)
  80073a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80073d:	50                   	push   %eax
  80073e:	68 52 02 80 00       	push   $0x800252
  800743:	e8 44 fb ff ff       	call   80028c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800751:	83 c4 10             	add    $0x10,%esp
}
  800754:	c9                   	leave  
  800755:	c3                   	ret    
		return -E_INVAL;
  800756:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075b:	eb f7                	jmp    800754 <vsnprintf+0x45>

0080075d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800766:	50                   	push   %eax
  800767:	ff 75 10             	pushl  0x10(%ebp)
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	ff 75 08             	pushl  0x8(%ebp)
  800770:	e8 9a ff ff ff       	call   80070f <vsnprintf>
	va_end(ap);

	return rc;
}
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	eb 03                	jmp    800787 <strlen+0x10>
		n++;
  800784:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800787:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80078b:	75 f7                	jne    800784 <strlen+0xd>
	return n;
}
  80078d:	5d                   	pop    %ebp
  80078e:	c3                   	ret    

0080078f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800795:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800798:	b8 00 00 00 00       	mov    $0x0,%eax
  80079d:	eb 03                	jmp    8007a2 <strnlen+0x13>
		n++;
  80079f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a2:	39 d0                	cmp    %edx,%eax
  8007a4:	74 06                	je     8007ac <strnlen+0x1d>
  8007a6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007aa:	75 f3                	jne    80079f <strnlen+0x10>
	return n;
}
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	53                   	push   %ebx
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b8:	89 c2                	mov    %eax,%edx
  8007ba:	83 c1 01             	add    $0x1,%ecx
  8007bd:	83 c2 01             	add    $0x1,%edx
  8007c0:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007c4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007c7:	84 db                	test   %bl,%bl
  8007c9:	75 ef                	jne    8007ba <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007cb:	5b                   	pop    %ebx
  8007cc:	5d                   	pop    %ebp
  8007cd:	c3                   	ret    

008007ce <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	53                   	push   %ebx
  8007d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d5:	53                   	push   %ebx
  8007d6:	e8 9c ff ff ff       	call   800777 <strlen>
  8007db:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	50                   	push   %eax
  8007e4:	e8 c5 ff ff ff       	call   8007ae <strcpy>
	return dst;
}
  8007e9:	89 d8                	mov    %ebx,%eax
  8007eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ee:	c9                   	leave  
  8007ef:	c3                   	ret    

008007f0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	56                   	push   %esi
  8007f4:	53                   	push   %ebx
  8007f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007fb:	89 f3                	mov    %esi,%ebx
  8007fd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800800:	89 f2                	mov    %esi,%edx
  800802:	eb 0f                	jmp    800813 <strncpy+0x23>
		*dst++ = *src;
  800804:	83 c2 01             	add    $0x1,%edx
  800807:	0f b6 01             	movzbl (%ecx),%eax
  80080a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80080d:	80 39 01             	cmpb   $0x1,(%ecx)
  800810:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800813:	39 da                	cmp    %ebx,%edx
  800815:	75 ed                	jne    800804 <strncpy+0x14>
	}
	return ret;
}
  800817:	89 f0                	mov    %esi,%eax
  800819:	5b                   	pop    %ebx
  80081a:	5e                   	pop    %esi
  80081b:	5d                   	pop    %ebp
  80081c:	c3                   	ret    

0080081d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	56                   	push   %esi
  800821:	53                   	push   %ebx
  800822:	8b 75 08             	mov    0x8(%ebp),%esi
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
  800828:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80082b:	89 f0                	mov    %esi,%eax
  80082d:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800831:	85 c9                	test   %ecx,%ecx
  800833:	75 0b                	jne    800840 <strlcpy+0x23>
  800835:	eb 17                	jmp    80084e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800837:	83 c2 01             	add    $0x1,%edx
  80083a:	83 c0 01             	add    $0x1,%eax
  80083d:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800840:	39 d8                	cmp    %ebx,%eax
  800842:	74 07                	je     80084b <strlcpy+0x2e>
  800844:	0f b6 0a             	movzbl (%edx),%ecx
  800847:	84 c9                	test   %cl,%cl
  800849:	75 ec                	jne    800837 <strlcpy+0x1a>
		*dst = '\0';
  80084b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80084e:	29 f0                	sub    %esi,%eax
}
  800850:	5b                   	pop    %ebx
  800851:	5e                   	pop    %esi
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80085d:	eb 06                	jmp    800865 <strcmp+0x11>
		p++, q++;
  80085f:	83 c1 01             	add    $0x1,%ecx
  800862:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800865:	0f b6 01             	movzbl (%ecx),%eax
  800868:	84 c0                	test   %al,%al
  80086a:	74 04                	je     800870 <strcmp+0x1c>
  80086c:	3a 02                	cmp    (%edx),%al
  80086e:	74 ef                	je     80085f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800870:	0f b6 c0             	movzbl %al,%eax
  800873:	0f b6 12             	movzbl (%edx),%edx
  800876:	29 d0                	sub    %edx,%eax
}
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	53                   	push   %ebx
  80087e:	8b 45 08             	mov    0x8(%ebp),%eax
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
  800884:	89 c3                	mov    %eax,%ebx
  800886:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800889:	eb 06                	jmp    800891 <strncmp+0x17>
		n--, p++, q++;
  80088b:	83 c0 01             	add    $0x1,%eax
  80088e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800891:	39 d8                	cmp    %ebx,%eax
  800893:	74 16                	je     8008ab <strncmp+0x31>
  800895:	0f b6 08             	movzbl (%eax),%ecx
  800898:	84 c9                	test   %cl,%cl
  80089a:	74 04                	je     8008a0 <strncmp+0x26>
  80089c:	3a 0a                	cmp    (%edx),%cl
  80089e:	74 eb                	je     80088b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a0:	0f b6 00             	movzbl (%eax),%eax
  8008a3:	0f b6 12             	movzbl (%edx),%edx
  8008a6:	29 d0                	sub    %edx,%eax
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    
		return 0;
  8008ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b0:	eb f6                	jmp    8008a8 <strncmp+0x2e>

008008b2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008bc:	0f b6 10             	movzbl (%eax),%edx
  8008bf:	84 d2                	test   %dl,%dl
  8008c1:	74 09                	je     8008cc <strchr+0x1a>
		if (*s == c)
  8008c3:	38 ca                	cmp    %cl,%dl
  8008c5:	74 0a                	je     8008d1 <strchr+0x1f>
	for (; *s; s++)
  8008c7:	83 c0 01             	add    $0x1,%eax
  8008ca:	eb f0                	jmp    8008bc <strchr+0xa>
			return (char *) s;
	return 0;
  8008cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008dd:	eb 03                	jmp    8008e2 <strfind+0xf>
  8008df:	83 c0 01             	add    $0x1,%eax
  8008e2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008e5:	38 ca                	cmp    %cl,%dl
  8008e7:	74 04                	je     8008ed <strfind+0x1a>
  8008e9:	84 d2                	test   %dl,%dl
  8008eb:	75 f2                	jne    8008df <strfind+0xc>
			break;
	return (char *) s;
}
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	57                   	push   %edi
  8008f3:	56                   	push   %esi
  8008f4:	53                   	push   %ebx
  8008f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008fb:	85 c9                	test   %ecx,%ecx
  8008fd:	74 13                	je     800912 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ff:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800905:	75 05                	jne    80090c <memset+0x1d>
  800907:	f6 c1 03             	test   $0x3,%cl
  80090a:	74 0d                	je     800919 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	fc                   	cld    
  800910:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800912:	89 f8                	mov    %edi,%eax
  800914:	5b                   	pop    %ebx
  800915:	5e                   	pop    %esi
  800916:	5f                   	pop    %edi
  800917:	5d                   	pop    %ebp
  800918:	c3                   	ret    
		c &= 0xFF;
  800919:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80091d:	89 d3                	mov    %edx,%ebx
  80091f:	c1 e3 08             	shl    $0x8,%ebx
  800922:	89 d0                	mov    %edx,%eax
  800924:	c1 e0 18             	shl    $0x18,%eax
  800927:	89 d6                	mov    %edx,%esi
  800929:	c1 e6 10             	shl    $0x10,%esi
  80092c:	09 f0                	or     %esi,%eax
  80092e:	09 c2                	or     %eax,%edx
  800930:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800932:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800935:	89 d0                	mov    %edx,%eax
  800937:	fc                   	cld    
  800938:	f3 ab                	rep stos %eax,%es:(%edi)
  80093a:	eb d6                	jmp    800912 <memset+0x23>

0080093c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	57                   	push   %edi
  800940:	56                   	push   %esi
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 75 0c             	mov    0xc(%ebp),%esi
  800947:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80094a:	39 c6                	cmp    %eax,%esi
  80094c:	73 35                	jae    800983 <memmove+0x47>
  80094e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800951:	39 c2                	cmp    %eax,%edx
  800953:	76 2e                	jbe    800983 <memmove+0x47>
		s += n;
		d += n;
  800955:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800958:	89 d6                	mov    %edx,%esi
  80095a:	09 fe                	or     %edi,%esi
  80095c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800962:	74 0c                	je     800970 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800964:	83 ef 01             	sub    $0x1,%edi
  800967:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80096a:	fd                   	std    
  80096b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096d:	fc                   	cld    
  80096e:	eb 21                	jmp    800991 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800970:	f6 c1 03             	test   $0x3,%cl
  800973:	75 ef                	jne    800964 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800975:	83 ef 04             	sub    $0x4,%edi
  800978:	8d 72 fc             	lea    -0x4(%edx),%esi
  80097b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80097e:	fd                   	std    
  80097f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800981:	eb ea                	jmp    80096d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800983:	89 f2                	mov    %esi,%edx
  800985:	09 c2                	or     %eax,%edx
  800987:	f6 c2 03             	test   $0x3,%dl
  80098a:	74 09                	je     800995 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80098c:	89 c7                	mov    %eax,%edi
  80098e:	fc                   	cld    
  80098f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800991:	5e                   	pop    %esi
  800992:	5f                   	pop    %edi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800995:	f6 c1 03             	test   $0x3,%cl
  800998:	75 f2                	jne    80098c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80099a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80099d:	89 c7                	mov    %eax,%edi
  80099f:	fc                   	cld    
  8009a0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a2:	eb ed                	jmp    800991 <memmove+0x55>

008009a4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009a7:	ff 75 10             	pushl  0x10(%ebp)
  8009aa:	ff 75 0c             	pushl  0xc(%ebp)
  8009ad:	ff 75 08             	pushl  0x8(%ebp)
  8009b0:	e8 87 ff ff ff       	call   80093c <memmove>
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	56                   	push   %esi
  8009bb:	53                   	push   %ebx
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c2:	89 c6                	mov    %eax,%esi
  8009c4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c7:	39 f0                	cmp    %esi,%eax
  8009c9:	74 1c                	je     8009e7 <memcmp+0x30>
		if (*s1 != *s2)
  8009cb:	0f b6 08             	movzbl (%eax),%ecx
  8009ce:	0f b6 1a             	movzbl (%edx),%ebx
  8009d1:	38 d9                	cmp    %bl,%cl
  8009d3:	75 08                	jne    8009dd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d5:	83 c0 01             	add    $0x1,%eax
  8009d8:	83 c2 01             	add    $0x1,%edx
  8009db:	eb ea                	jmp    8009c7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009dd:	0f b6 c1             	movzbl %cl,%eax
  8009e0:	0f b6 db             	movzbl %bl,%ebx
  8009e3:	29 d8                	sub    %ebx,%eax
  8009e5:	eb 05                	jmp    8009ec <memcmp+0x35>
	}

	return 0;
  8009e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ec:	5b                   	pop    %ebx
  8009ed:	5e                   	pop    %esi
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009f9:	89 c2                	mov    %eax,%edx
  8009fb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009fe:	39 d0                	cmp    %edx,%eax
  800a00:	73 09                	jae    800a0b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a02:	38 08                	cmp    %cl,(%eax)
  800a04:	74 05                	je     800a0b <memfind+0x1b>
	for (; s < ends; s++)
  800a06:	83 c0 01             	add    $0x1,%eax
  800a09:	eb f3                	jmp    8009fe <memfind+0xe>
			break;
	return (void *) s;
}
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	57                   	push   %edi
  800a11:	56                   	push   %esi
  800a12:	53                   	push   %ebx
  800a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a19:	eb 03                	jmp    800a1e <strtol+0x11>
		s++;
  800a1b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a1e:	0f b6 01             	movzbl (%ecx),%eax
  800a21:	3c 20                	cmp    $0x20,%al
  800a23:	74 f6                	je     800a1b <strtol+0xe>
  800a25:	3c 09                	cmp    $0x9,%al
  800a27:	74 f2                	je     800a1b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a29:	3c 2b                	cmp    $0x2b,%al
  800a2b:	74 2e                	je     800a5b <strtol+0x4e>
	int neg = 0;
  800a2d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a32:	3c 2d                	cmp    $0x2d,%al
  800a34:	74 2f                	je     800a65 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a36:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a3c:	75 05                	jne    800a43 <strtol+0x36>
  800a3e:	80 39 30             	cmpb   $0x30,(%ecx)
  800a41:	74 2c                	je     800a6f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a43:	85 db                	test   %ebx,%ebx
  800a45:	75 0a                	jne    800a51 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a47:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a4c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4f:	74 28                	je     800a79 <strtol+0x6c>
		base = 10;
  800a51:	b8 00 00 00 00       	mov    $0x0,%eax
  800a56:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a59:	eb 50                	jmp    800aab <strtol+0x9e>
		s++;
  800a5b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a5e:	bf 00 00 00 00       	mov    $0x0,%edi
  800a63:	eb d1                	jmp    800a36 <strtol+0x29>
		s++, neg = 1;
  800a65:	83 c1 01             	add    $0x1,%ecx
  800a68:	bf 01 00 00 00       	mov    $0x1,%edi
  800a6d:	eb c7                	jmp    800a36 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a6f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a73:	74 0e                	je     800a83 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a75:	85 db                	test   %ebx,%ebx
  800a77:	75 d8                	jne    800a51 <strtol+0x44>
		s++, base = 8;
  800a79:	83 c1 01             	add    $0x1,%ecx
  800a7c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a81:	eb ce                	jmp    800a51 <strtol+0x44>
		s += 2, base = 16;
  800a83:	83 c1 02             	add    $0x2,%ecx
  800a86:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a8b:	eb c4                	jmp    800a51 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a8d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a90:	89 f3                	mov    %esi,%ebx
  800a92:	80 fb 19             	cmp    $0x19,%bl
  800a95:	77 29                	ja     800ac0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a97:	0f be d2             	movsbl %dl,%edx
  800a9a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a9d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aa0:	7d 30                	jge    800ad2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aa2:	83 c1 01             	add    $0x1,%ecx
  800aa5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800aa9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800aab:	0f b6 11             	movzbl (%ecx),%edx
  800aae:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ab1:	89 f3                	mov    %esi,%ebx
  800ab3:	80 fb 09             	cmp    $0x9,%bl
  800ab6:	77 d5                	ja     800a8d <strtol+0x80>
			dig = *s - '0';
  800ab8:	0f be d2             	movsbl %dl,%edx
  800abb:	83 ea 30             	sub    $0x30,%edx
  800abe:	eb dd                	jmp    800a9d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ac0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac3:	89 f3                	mov    %esi,%ebx
  800ac5:	80 fb 19             	cmp    $0x19,%bl
  800ac8:	77 08                	ja     800ad2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800aca:	0f be d2             	movsbl %dl,%edx
  800acd:	83 ea 37             	sub    $0x37,%edx
  800ad0:	eb cb                	jmp    800a9d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad6:	74 05                	je     800add <strtol+0xd0>
		*endptr = (char *) s;
  800ad8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800add:	89 c2                	mov    %eax,%edx
  800adf:	f7 da                	neg    %edx
  800ae1:	85 ff                	test   %edi,%edi
  800ae3:	0f 45 c2             	cmovne %edx,%eax
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5e                   	pop    %esi
  800ae8:	5f                   	pop    %edi
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	57                   	push   %edi
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af1:	b8 00 00 00 00       	mov    $0x0,%eax
  800af6:	8b 55 08             	mov    0x8(%ebp),%edx
  800af9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afc:	89 c3                	mov    %eax,%ebx
  800afe:	89 c7                	mov    %eax,%edi
  800b00:	89 c6                	mov    %eax,%esi
  800b02:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b04:	5b                   	pop    %ebx
  800b05:	5e                   	pop    %esi
  800b06:	5f                   	pop    %edi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	57                   	push   %edi
  800b0d:	56                   	push   %esi
  800b0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b14:	b8 01 00 00 00       	mov    $0x1,%eax
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	89 d3                	mov    %edx,%ebx
  800b1d:	89 d7                	mov    %edx,%edi
  800b1f:	89 d6                	mov    %edx,%esi
  800b21:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b23:	5b                   	pop    %ebx
  800b24:	5e                   	pop    %esi
  800b25:	5f                   	pop    %edi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	57                   	push   %edi
  800b2c:	56                   	push   %esi
  800b2d:	53                   	push   %ebx
  800b2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b31:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b36:	8b 55 08             	mov    0x8(%ebp),%edx
  800b39:	b8 03 00 00 00       	mov    $0x3,%eax
  800b3e:	89 cb                	mov    %ecx,%ebx
  800b40:	89 cf                	mov    %ecx,%edi
  800b42:	89 ce                	mov    %ecx,%esi
  800b44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b46:	85 c0                	test   %eax,%eax
  800b48:	7f 08                	jg     800b52 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b52:	83 ec 0c             	sub    $0xc,%esp
  800b55:	50                   	push   %eax
  800b56:	6a 03                	push   $0x3
  800b58:	68 1f 26 80 00       	push   $0x80261f
  800b5d:	6a 23                	push   $0x23
  800b5f:	68 3c 26 80 00       	push   $0x80263c
  800b64:	e8 6e 13 00 00       	call   801ed7 <_panic>

00800b69 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	b8 02 00 00 00       	mov    $0x2,%eax
  800b79:	89 d1                	mov    %edx,%ecx
  800b7b:	89 d3                	mov    %edx,%ebx
  800b7d:	89 d7                	mov    %edx,%edi
  800b7f:	89 d6                	mov    %edx,%esi
  800b81:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_yield>:

void
sys_yield(void)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b93:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b98:	89 d1                	mov    %edx,%ecx
  800b9a:	89 d3                	mov    %edx,%ebx
  800b9c:	89 d7                	mov    %edx,%edi
  800b9e:	89 d6                	mov    %edx,%esi
  800ba0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5f                   	pop    %edi
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb0:	be 00 00 00 00       	mov    $0x0,%esi
  800bb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbb:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc3:	89 f7                	mov    %esi,%edi
  800bc5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bc7:	85 c0                	test   %eax,%eax
  800bc9:	7f 08                	jg     800bd3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd3:	83 ec 0c             	sub    $0xc,%esp
  800bd6:	50                   	push   %eax
  800bd7:	6a 04                	push   $0x4
  800bd9:	68 1f 26 80 00       	push   $0x80261f
  800bde:	6a 23                	push   $0x23
  800be0:	68 3c 26 80 00       	push   $0x80263c
  800be5:	e8 ed 12 00 00       	call   801ed7 <_panic>

00800bea <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	57                   	push   %edi
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
  800bf0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	b8 05 00 00 00       	mov    $0x5,%eax
  800bfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c01:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c04:	8b 75 18             	mov    0x18(%ebp),%esi
  800c07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	7f 08                	jg     800c15 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	6a 05                	push   $0x5
  800c1b:	68 1f 26 80 00       	push   $0x80261f
  800c20:	6a 23                	push   $0x23
  800c22:	68 3c 26 80 00       	push   $0x80263c
  800c27:	e8 ab 12 00 00       	call   801ed7 <_panic>

00800c2c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	57                   	push   %edi
  800c30:	56                   	push   %esi
  800c31:	53                   	push   %ebx
  800c32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c40:	b8 06 00 00 00       	mov    $0x6,%eax
  800c45:	89 df                	mov    %ebx,%edi
  800c47:	89 de                	mov    %ebx,%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 06                	push   $0x6
  800c5d:	68 1f 26 80 00       	push   $0x80261f
  800c62:	6a 23                	push   $0x23
  800c64:	68 3c 26 80 00       	push   $0x80263c
  800c69:	e8 69 12 00 00       	call   801ed7 <_panic>

00800c6e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	b8 08 00 00 00       	mov    $0x8,%eax
  800c87:	89 df                	mov    %ebx,%edi
  800c89:	89 de                	mov    %ebx,%esi
  800c8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 08                	push   $0x8
  800c9f:	68 1f 26 80 00       	push   $0x80261f
  800ca4:	6a 23                	push   $0x23
  800ca6:	68 3c 26 80 00       	push   $0x80263c
  800cab:	e8 27 12 00 00       	call   801ed7 <_panic>

00800cb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	b8 09 00 00 00       	mov    $0x9,%eax
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 09                	push   $0x9
  800ce1:	68 1f 26 80 00       	push   $0x80261f
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 3c 26 80 00       	push   $0x80263c
  800ced:	e8 e5 11 00 00       	call   801ed7 <_panic>

00800cf2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	89 de                	mov    %ebx,%esi
  800d0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7f 08                	jg     800d1d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	50                   	push   %eax
  800d21:	6a 0a                	push   $0xa
  800d23:	68 1f 26 80 00       	push   $0x80261f
  800d28:	6a 23                	push   $0x23
  800d2a:	68 3c 26 80 00       	push   $0x80263c
  800d2f:	e8 a3 11 00 00       	call   801ed7 <_panic>

00800d34 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d45:	be 00 00 00 00       	mov    $0x0,%esi
  800d4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d50:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d60:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d65:	8b 55 08             	mov    0x8(%ebp),%edx
  800d68:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d6d:	89 cb                	mov    %ecx,%ebx
  800d6f:	89 cf                	mov    %ecx,%edi
  800d71:	89 ce                	mov    %ecx,%esi
  800d73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d75:	85 c0                	test   %eax,%eax
  800d77:	7f 08                	jg     800d81 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7c:	5b                   	pop    %ebx
  800d7d:	5e                   	pop    %esi
  800d7e:	5f                   	pop    %edi
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	50                   	push   %eax
  800d85:	6a 0d                	push   $0xd
  800d87:	68 1f 26 80 00       	push   $0x80261f
  800d8c:	6a 23                	push   $0x23
  800d8e:	68 3c 26 80 00       	push   $0x80263c
  800d93:	e8 3f 11 00 00       	call   801ed7 <_panic>

00800d98 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800da3:	b8 0e 00 00 00       	mov    $0xe,%eax
  800da8:	89 d1                	mov    %edx,%ecx
  800daa:	89 d3                	mov    %edx,%ebx
  800dac:	89 d7                	mov    %edx,%edi
  800dae:	89 d6                	mov    %edx,%esi
  800db0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	05 00 00 00 30       	add    $0x30000000,%eax
  800dc2:	c1 e8 0c             	shr    $0xc,%eax
}
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800dd2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dd7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800de9:	89 c2                	mov    %eax,%edx
  800deb:	c1 ea 16             	shr    $0x16,%edx
  800dee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800df5:	f6 c2 01             	test   $0x1,%dl
  800df8:	74 2a                	je     800e24 <fd_alloc+0x46>
  800dfa:	89 c2                	mov    %eax,%edx
  800dfc:	c1 ea 0c             	shr    $0xc,%edx
  800dff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e06:	f6 c2 01             	test   $0x1,%dl
  800e09:	74 19                	je     800e24 <fd_alloc+0x46>
  800e0b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e10:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e15:	75 d2                	jne    800de9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e17:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e1d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e22:	eb 07                	jmp    800e2b <fd_alloc+0x4d>
			*fd_store = fd;
  800e24:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e33:	83 f8 1f             	cmp    $0x1f,%eax
  800e36:	77 36                	ja     800e6e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e38:	c1 e0 0c             	shl    $0xc,%eax
  800e3b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	c1 ea 16             	shr    $0x16,%edx
  800e45:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e4c:	f6 c2 01             	test   $0x1,%dl
  800e4f:	74 24                	je     800e75 <fd_lookup+0x48>
  800e51:	89 c2                	mov    %eax,%edx
  800e53:	c1 ea 0c             	shr    $0xc,%edx
  800e56:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e5d:	f6 c2 01             	test   $0x1,%dl
  800e60:	74 1a                	je     800e7c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e65:	89 02                	mov    %eax,(%edx)
	return 0;
  800e67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
		return -E_INVAL;
  800e6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e73:	eb f7                	jmp    800e6c <fd_lookup+0x3f>
		return -E_INVAL;
  800e75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e7a:	eb f0                	jmp    800e6c <fd_lookup+0x3f>
  800e7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e81:	eb e9                	jmp    800e6c <fd_lookup+0x3f>

00800e83 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8c:	ba c8 26 80 00       	mov    $0x8026c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e91:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e96:	39 08                	cmp    %ecx,(%eax)
  800e98:	74 33                	je     800ecd <dev_lookup+0x4a>
  800e9a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e9d:	8b 02                	mov    (%edx),%eax
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	75 f3                	jne    800e96 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ea3:	a1 08 40 80 00       	mov    0x804008,%eax
  800ea8:	8b 40 48             	mov    0x48(%eax),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	51                   	push   %ecx
  800eaf:	50                   	push   %eax
  800eb0:	68 4c 26 80 00       	push   $0x80264c
  800eb5:	e8 d5 f2 ff ff       	call   80018f <cprintf>
	*dev = 0;
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ec3:	83 c4 10             	add    $0x10,%esp
  800ec6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    
			*dev = devtab[i];
  800ecd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed7:	eb f2                	jmp    800ecb <dev_lookup+0x48>

00800ed9 <fd_close>:
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 1c             	sub    $0x1c,%esp
  800ee2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ee5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ee8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eeb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eec:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ef2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ef5:	50                   	push   %eax
  800ef6:	e8 32 ff ff ff       	call   800e2d <fd_lookup>
  800efb:	89 c3                	mov    %eax,%ebx
  800efd:	83 c4 08             	add    $0x8,%esp
  800f00:	85 c0                	test   %eax,%eax
  800f02:	78 05                	js     800f09 <fd_close+0x30>
	    || fd != fd2)
  800f04:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f07:	74 16                	je     800f1f <fd_close+0x46>
		return (must_exist ? r : 0);
  800f09:	89 f8                	mov    %edi,%eax
  800f0b:	84 c0                	test   %al,%al
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f12:	0f 44 d8             	cmove  %eax,%ebx
}
  800f15:	89 d8                	mov    %ebx,%eax
  800f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f25:	50                   	push   %eax
  800f26:	ff 36                	pushl  (%esi)
  800f28:	e8 56 ff ff ff       	call   800e83 <dev_lookup>
  800f2d:	89 c3                	mov    %eax,%ebx
  800f2f:	83 c4 10             	add    $0x10,%esp
  800f32:	85 c0                	test   %eax,%eax
  800f34:	78 15                	js     800f4b <fd_close+0x72>
		if (dev->dev_close)
  800f36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f39:	8b 40 10             	mov    0x10(%eax),%eax
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	74 1b                	je     800f5b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f40:	83 ec 0c             	sub    $0xc,%esp
  800f43:	56                   	push   %esi
  800f44:	ff d0                	call   *%eax
  800f46:	89 c3                	mov    %eax,%ebx
  800f48:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f4b:	83 ec 08             	sub    $0x8,%esp
  800f4e:	56                   	push   %esi
  800f4f:	6a 00                	push   $0x0
  800f51:	e8 d6 fc ff ff       	call   800c2c <sys_page_unmap>
	return r;
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	eb ba                	jmp    800f15 <fd_close+0x3c>
			r = 0;
  800f5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f60:	eb e9                	jmp    800f4b <fd_close+0x72>

00800f62 <close>:

int
close(int fdnum)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f6b:	50                   	push   %eax
  800f6c:	ff 75 08             	pushl  0x8(%ebp)
  800f6f:	e8 b9 fe ff ff       	call   800e2d <fd_lookup>
  800f74:	83 c4 08             	add    $0x8,%esp
  800f77:	85 c0                	test   %eax,%eax
  800f79:	78 10                	js     800f8b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f7b:	83 ec 08             	sub    $0x8,%esp
  800f7e:	6a 01                	push   $0x1
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	e8 51 ff ff ff       	call   800ed9 <fd_close>
  800f88:	83 c4 10             	add    $0x10,%esp
}
  800f8b:	c9                   	leave  
  800f8c:	c3                   	ret    

00800f8d <close_all>:

void
close_all(void)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	53                   	push   %ebx
  800f91:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f99:	83 ec 0c             	sub    $0xc,%esp
  800f9c:	53                   	push   %ebx
  800f9d:	e8 c0 ff ff ff       	call   800f62 <close>
	for (i = 0; i < MAXFD; i++)
  800fa2:	83 c3 01             	add    $0x1,%ebx
  800fa5:	83 c4 10             	add    $0x10,%esp
  800fa8:	83 fb 20             	cmp    $0x20,%ebx
  800fab:	75 ec                	jne    800f99 <close_all+0xc>
}
  800fad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

00800fb2 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	57                   	push   %edi
  800fb6:	56                   	push   %esi
  800fb7:	53                   	push   %ebx
  800fb8:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fbb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fbe:	50                   	push   %eax
  800fbf:	ff 75 08             	pushl  0x8(%ebp)
  800fc2:	e8 66 fe ff ff       	call   800e2d <fd_lookup>
  800fc7:	89 c3                	mov    %eax,%ebx
  800fc9:	83 c4 08             	add    $0x8,%esp
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	0f 88 81 00 00 00    	js     801055 <dup+0xa3>
		return r;
	close(newfdnum);
  800fd4:	83 ec 0c             	sub    $0xc,%esp
  800fd7:	ff 75 0c             	pushl  0xc(%ebp)
  800fda:	e8 83 ff ff ff       	call   800f62 <close>

	newfd = INDEX2FD(newfdnum);
  800fdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fe2:	c1 e6 0c             	shl    $0xc,%esi
  800fe5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800feb:	83 c4 04             	add    $0x4,%esp
  800fee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ff1:	e8 d1 fd ff ff       	call   800dc7 <fd2data>
  800ff6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800ff8:	89 34 24             	mov    %esi,(%esp)
  800ffb:	e8 c7 fd ff ff       	call   800dc7 <fd2data>
  801000:	83 c4 10             	add    $0x10,%esp
  801003:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801005:	89 d8                	mov    %ebx,%eax
  801007:	c1 e8 16             	shr    $0x16,%eax
  80100a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801011:	a8 01                	test   $0x1,%al
  801013:	74 11                	je     801026 <dup+0x74>
  801015:	89 d8                	mov    %ebx,%eax
  801017:	c1 e8 0c             	shr    $0xc,%eax
  80101a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801021:	f6 c2 01             	test   $0x1,%dl
  801024:	75 39                	jne    80105f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801026:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801029:	89 d0                	mov    %edx,%eax
  80102b:	c1 e8 0c             	shr    $0xc,%eax
  80102e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801035:	83 ec 0c             	sub    $0xc,%esp
  801038:	25 07 0e 00 00       	and    $0xe07,%eax
  80103d:	50                   	push   %eax
  80103e:	56                   	push   %esi
  80103f:	6a 00                	push   $0x0
  801041:	52                   	push   %edx
  801042:	6a 00                	push   $0x0
  801044:	e8 a1 fb ff ff       	call   800bea <sys_page_map>
  801049:	89 c3                	mov    %eax,%ebx
  80104b:	83 c4 20             	add    $0x20,%esp
  80104e:	85 c0                	test   %eax,%eax
  801050:	78 31                	js     801083 <dup+0xd1>
		goto err;

	return newfdnum;
  801052:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801055:	89 d8                	mov    %ebx,%eax
  801057:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105a:	5b                   	pop    %ebx
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80105f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801066:	83 ec 0c             	sub    $0xc,%esp
  801069:	25 07 0e 00 00       	and    $0xe07,%eax
  80106e:	50                   	push   %eax
  80106f:	57                   	push   %edi
  801070:	6a 00                	push   $0x0
  801072:	53                   	push   %ebx
  801073:	6a 00                	push   $0x0
  801075:	e8 70 fb ff ff       	call   800bea <sys_page_map>
  80107a:	89 c3                	mov    %eax,%ebx
  80107c:	83 c4 20             	add    $0x20,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	79 a3                	jns    801026 <dup+0x74>
	sys_page_unmap(0, newfd);
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	56                   	push   %esi
  801087:	6a 00                	push   $0x0
  801089:	e8 9e fb ff ff       	call   800c2c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80108e:	83 c4 08             	add    $0x8,%esp
  801091:	57                   	push   %edi
  801092:	6a 00                	push   $0x0
  801094:	e8 93 fb ff ff       	call   800c2c <sys_page_unmap>
	return r;
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	eb b7                	jmp    801055 <dup+0xa3>

0080109e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	53                   	push   %ebx
  8010a2:	83 ec 14             	sub    $0x14,%esp
  8010a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ab:	50                   	push   %eax
  8010ac:	53                   	push   %ebx
  8010ad:	e8 7b fd ff ff       	call   800e2d <fd_lookup>
  8010b2:	83 c4 08             	add    $0x8,%esp
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	78 3f                	js     8010f8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010b9:	83 ec 08             	sub    $0x8,%esp
  8010bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010bf:	50                   	push   %eax
  8010c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c3:	ff 30                	pushl  (%eax)
  8010c5:	e8 b9 fd ff ff       	call   800e83 <dev_lookup>
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	78 27                	js     8010f8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010d4:	8b 42 08             	mov    0x8(%edx),%eax
  8010d7:	83 e0 03             	and    $0x3,%eax
  8010da:	83 f8 01             	cmp    $0x1,%eax
  8010dd:	74 1e                	je     8010fd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e2:	8b 40 08             	mov    0x8(%eax),%eax
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	74 35                	je     80111e <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010e9:	83 ec 04             	sub    $0x4,%esp
  8010ec:	ff 75 10             	pushl  0x10(%ebp)
  8010ef:	ff 75 0c             	pushl  0xc(%ebp)
  8010f2:	52                   	push   %edx
  8010f3:	ff d0                	call   *%eax
  8010f5:	83 c4 10             	add    $0x10,%esp
}
  8010f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010fd:	a1 08 40 80 00       	mov    0x804008,%eax
  801102:	8b 40 48             	mov    0x48(%eax),%eax
  801105:	83 ec 04             	sub    $0x4,%esp
  801108:	53                   	push   %ebx
  801109:	50                   	push   %eax
  80110a:	68 8d 26 80 00       	push   $0x80268d
  80110f:	e8 7b f0 ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801114:	83 c4 10             	add    $0x10,%esp
  801117:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111c:	eb da                	jmp    8010f8 <read+0x5a>
		return -E_NOT_SUPP;
  80111e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801123:	eb d3                	jmp    8010f8 <read+0x5a>

00801125 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801131:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801134:	bb 00 00 00 00       	mov    $0x0,%ebx
  801139:	39 f3                	cmp    %esi,%ebx
  80113b:	73 25                	jae    801162 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80113d:	83 ec 04             	sub    $0x4,%esp
  801140:	89 f0                	mov    %esi,%eax
  801142:	29 d8                	sub    %ebx,%eax
  801144:	50                   	push   %eax
  801145:	89 d8                	mov    %ebx,%eax
  801147:	03 45 0c             	add    0xc(%ebp),%eax
  80114a:	50                   	push   %eax
  80114b:	57                   	push   %edi
  80114c:	e8 4d ff ff ff       	call   80109e <read>
		if (m < 0)
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 08                	js     801160 <readn+0x3b>
			return m;
		if (m == 0)
  801158:	85 c0                	test   %eax,%eax
  80115a:	74 06                	je     801162 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80115c:	01 c3                	add    %eax,%ebx
  80115e:	eb d9                	jmp    801139 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801160:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801162:	89 d8                	mov    %ebx,%eax
  801164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	53                   	push   %ebx
  801170:	83 ec 14             	sub    $0x14,%esp
  801173:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801176:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801179:	50                   	push   %eax
  80117a:	53                   	push   %ebx
  80117b:	e8 ad fc ff ff       	call   800e2d <fd_lookup>
  801180:	83 c4 08             	add    $0x8,%esp
  801183:	85 c0                	test   %eax,%eax
  801185:	78 3a                	js     8011c1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801187:	83 ec 08             	sub    $0x8,%esp
  80118a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118d:	50                   	push   %eax
  80118e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801191:	ff 30                	pushl  (%eax)
  801193:	e8 eb fc ff ff       	call   800e83 <dev_lookup>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	85 c0                	test   %eax,%eax
  80119d:	78 22                	js     8011c1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011a6:	74 1e                	je     8011c6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ab:	8b 52 0c             	mov    0xc(%edx),%edx
  8011ae:	85 d2                	test   %edx,%edx
  8011b0:	74 35                	je     8011e7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	ff 75 10             	pushl  0x10(%ebp)
  8011b8:	ff 75 0c             	pushl  0xc(%ebp)
  8011bb:	50                   	push   %eax
  8011bc:	ff d2                	call   *%edx
  8011be:	83 c4 10             	add    $0x10,%esp
}
  8011c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011c6:	a1 08 40 80 00       	mov    0x804008,%eax
  8011cb:	8b 40 48             	mov    0x48(%eax),%eax
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	53                   	push   %ebx
  8011d2:	50                   	push   %eax
  8011d3:	68 a9 26 80 00       	push   $0x8026a9
  8011d8:	e8 b2 ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e5:	eb da                	jmp    8011c1 <write+0x55>
		return -E_NOT_SUPP;
  8011e7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011ec:	eb d3                	jmp    8011c1 <write+0x55>

008011ee <seek>:

int
seek(int fdnum, off_t offset)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011f4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011f7:	50                   	push   %eax
  8011f8:	ff 75 08             	pushl  0x8(%ebp)
  8011fb:	e8 2d fc ff ff       	call   800e2d <fd_lookup>
  801200:	83 c4 08             	add    $0x8,%esp
  801203:	85 c0                	test   %eax,%eax
  801205:	78 0e                	js     801215 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120d:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801210:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801215:	c9                   	leave  
  801216:	c3                   	ret    

00801217 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	53                   	push   %ebx
  80121b:	83 ec 14             	sub    $0x14,%esp
  80121e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801224:	50                   	push   %eax
  801225:	53                   	push   %ebx
  801226:	e8 02 fc ff ff       	call   800e2d <fd_lookup>
  80122b:	83 c4 08             	add    $0x8,%esp
  80122e:	85 c0                	test   %eax,%eax
  801230:	78 37                	js     801269 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123c:	ff 30                	pushl  (%eax)
  80123e:	e8 40 fc ff ff       	call   800e83 <dev_lookup>
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	78 1f                	js     801269 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80124a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801251:	74 1b                	je     80126e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801256:	8b 52 18             	mov    0x18(%edx),%edx
  801259:	85 d2                	test   %edx,%edx
  80125b:	74 32                	je     80128f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80125d:	83 ec 08             	sub    $0x8,%esp
  801260:	ff 75 0c             	pushl  0xc(%ebp)
  801263:	50                   	push   %eax
  801264:	ff d2                	call   *%edx
  801266:	83 c4 10             	add    $0x10,%esp
}
  801269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80126e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801273:	8b 40 48             	mov    0x48(%eax),%eax
  801276:	83 ec 04             	sub    $0x4,%esp
  801279:	53                   	push   %ebx
  80127a:	50                   	push   %eax
  80127b:	68 6c 26 80 00       	push   $0x80266c
  801280:	e8 0a ef ff ff       	call   80018f <cprintf>
		return -E_INVAL;
  801285:	83 c4 10             	add    $0x10,%esp
  801288:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128d:	eb da                	jmp    801269 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80128f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801294:	eb d3                	jmp    801269 <ftruncate+0x52>

00801296 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 14             	sub    $0x14,%esp
  80129d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	ff 75 08             	pushl  0x8(%ebp)
  8012a7:	e8 81 fb ff ff       	call   800e2d <fd_lookup>
  8012ac:	83 c4 08             	add    $0x8,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	78 4b                	js     8012fe <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b3:	83 ec 08             	sub    $0x8,%esp
  8012b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b9:	50                   	push   %eax
  8012ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bd:	ff 30                	pushl  (%eax)
  8012bf:	e8 bf fb ff ff       	call   800e83 <dev_lookup>
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	85 c0                	test   %eax,%eax
  8012c9:	78 33                	js     8012fe <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ce:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012d2:	74 2f                	je     801303 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012d4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012d7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012de:	00 00 00 
	stat->st_isdir = 0;
  8012e1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012e8:	00 00 00 
	stat->st_dev = dev;
  8012eb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012f1:	83 ec 08             	sub    $0x8,%esp
  8012f4:	53                   	push   %ebx
  8012f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f8:	ff 50 14             	call   *0x14(%eax)
  8012fb:	83 c4 10             	add    $0x10,%esp
}
  8012fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801301:	c9                   	leave  
  801302:	c3                   	ret    
		return -E_NOT_SUPP;
  801303:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801308:	eb f4                	jmp    8012fe <fstat+0x68>

0080130a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	56                   	push   %esi
  80130e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80130f:	83 ec 08             	sub    $0x8,%esp
  801312:	6a 00                	push   $0x0
  801314:	ff 75 08             	pushl  0x8(%ebp)
  801317:	e8 e7 01 00 00       	call   801503 <open>
  80131c:	89 c3                	mov    %eax,%ebx
  80131e:	83 c4 10             	add    $0x10,%esp
  801321:	85 c0                	test   %eax,%eax
  801323:	78 1b                	js     801340 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801325:	83 ec 08             	sub    $0x8,%esp
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	50                   	push   %eax
  80132c:	e8 65 ff ff ff       	call   801296 <fstat>
  801331:	89 c6                	mov    %eax,%esi
	close(fd);
  801333:	89 1c 24             	mov    %ebx,(%esp)
  801336:	e8 27 fc ff ff       	call   800f62 <close>
	return r;
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	89 f3                	mov    %esi,%ebx
}
  801340:	89 d8                	mov    %ebx,%eax
  801342:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	56                   	push   %esi
  80134d:	53                   	push   %ebx
  80134e:	89 c6                	mov    %eax,%esi
  801350:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801352:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801359:	74 27                	je     801382 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80135b:	6a 07                	push   $0x7
  80135d:	68 00 50 80 00       	push   $0x805000
  801362:	56                   	push   %esi
  801363:	ff 35 00 40 80 00    	pushl  0x804000
  801369:	e8 16 0c 00 00       	call   801f84 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80136e:	83 c4 0c             	add    $0xc,%esp
  801371:	6a 00                	push   $0x0
  801373:	53                   	push   %ebx
  801374:	6a 00                	push   $0x0
  801376:	e8 a2 0b 00 00       	call   801f1d <ipc_recv>
}
  80137b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137e:	5b                   	pop    %ebx
  80137f:	5e                   	pop    %esi
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801382:	83 ec 0c             	sub    $0xc,%esp
  801385:	6a 01                	push   $0x1
  801387:	e8 4c 0c 00 00       	call   801fd8 <ipc_find_env>
  80138c:	a3 00 40 80 00       	mov    %eax,0x804000
  801391:	83 c4 10             	add    $0x10,%esp
  801394:	eb c5                	jmp    80135b <fsipc+0x12>

00801396 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80139c:	8b 45 08             	mov    0x8(%ebp),%eax
  80139f:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a2:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013aa:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013af:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b4:	b8 02 00 00 00       	mov    $0x2,%eax
  8013b9:	e8 8b ff ff ff       	call   801349 <fsipc>
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <devfile_flush>:
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8013cc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d6:	b8 06 00 00 00       	mov    $0x6,%eax
  8013db:	e8 69 ff ff ff       	call   801349 <fsipc>
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <devfile_stat>:
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fc:	b8 05 00 00 00       	mov    $0x5,%eax
  801401:	e8 43 ff ff ff       	call   801349 <fsipc>
  801406:	85 c0                	test   %eax,%eax
  801408:	78 2c                	js     801436 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	68 00 50 80 00       	push   $0x805000
  801412:	53                   	push   %ebx
  801413:	e8 96 f3 ff ff       	call   8007ae <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801418:	a1 80 50 80 00       	mov    0x805080,%eax
  80141d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801423:	a1 84 50 80 00       	mov    0x805084,%eax
  801428:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801436:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801439:	c9                   	leave  
  80143a:	c3                   	ret    

0080143b <devfile_write>:
{
  80143b:	55                   	push   %ebp
  80143c:	89 e5                	mov    %esp,%ebp
  80143e:	83 ec 0c             	sub    $0xc,%esp
  801441:	8b 45 10             	mov    0x10(%ebp),%eax
  801444:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801449:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80144e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801451:	8b 55 08             	mov    0x8(%ebp),%edx
  801454:	8b 52 0c             	mov    0xc(%edx),%edx
  801457:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80145d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801462:	50                   	push   %eax
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	68 08 50 80 00       	push   $0x805008
  80146b:	e8 cc f4 ff ff       	call   80093c <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801470:	ba 00 00 00 00       	mov    $0x0,%edx
  801475:	b8 04 00 00 00       	mov    $0x4,%eax
  80147a:	e8 ca fe ff ff       	call   801349 <fsipc>
}
  80147f:	c9                   	leave  
  801480:	c3                   	ret    

00801481 <devfile_read>:
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	56                   	push   %esi
  801485:	53                   	push   %ebx
  801486:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8b 40 0c             	mov    0xc(%eax),%eax
  80148f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801494:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80149a:	ba 00 00 00 00       	mov    $0x0,%edx
  80149f:	b8 03 00 00 00       	mov    $0x3,%eax
  8014a4:	e8 a0 fe ff ff       	call   801349 <fsipc>
  8014a9:	89 c3                	mov    %eax,%ebx
  8014ab:	85 c0                	test   %eax,%eax
  8014ad:	78 1f                	js     8014ce <devfile_read+0x4d>
	assert(r <= n);
  8014af:	39 f0                	cmp    %esi,%eax
  8014b1:	77 24                	ja     8014d7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014b3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014b8:	7f 33                	jg     8014ed <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	50                   	push   %eax
  8014be:	68 00 50 80 00       	push   $0x805000
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	e8 71 f4 ff ff       	call   80093c <memmove>
	return r;
  8014cb:	83 c4 10             	add    $0x10,%esp
}
  8014ce:	89 d8                	mov    %ebx,%eax
  8014d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d3:	5b                   	pop    %ebx
  8014d4:	5e                   	pop    %esi
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    
	assert(r <= n);
  8014d7:	68 dc 26 80 00       	push   $0x8026dc
  8014dc:	68 e3 26 80 00       	push   $0x8026e3
  8014e1:	6a 7b                	push   $0x7b
  8014e3:	68 f8 26 80 00       	push   $0x8026f8
  8014e8:	e8 ea 09 00 00       	call   801ed7 <_panic>
	assert(r <= PGSIZE);
  8014ed:	68 03 27 80 00       	push   $0x802703
  8014f2:	68 e3 26 80 00       	push   $0x8026e3
  8014f7:	6a 7c                	push   $0x7c
  8014f9:	68 f8 26 80 00       	push   $0x8026f8
  8014fe:	e8 d4 09 00 00       	call   801ed7 <_panic>

00801503 <open>:
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
  801508:	83 ec 1c             	sub    $0x1c,%esp
  80150b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80150e:	56                   	push   %esi
  80150f:	e8 63 f2 ff ff       	call   800777 <strlen>
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80151c:	7f 6c                	jg     80158a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801524:	50                   	push   %eax
  801525:	e8 b4 f8 ff ff       	call   800dde <fd_alloc>
  80152a:	89 c3                	mov    %eax,%ebx
  80152c:	83 c4 10             	add    $0x10,%esp
  80152f:	85 c0                	test   %eax,%eax
  801531:	78 3c                	js     80156f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	56                   	push   %esi
  801537:	68 00 50 80 00       	push   $0x805000
  80153c:	e8 6d f2 ff ff       	call   8007ae <strcpy>
	fsipcbuf.open.req_omode = mode;
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154c:	b8 01 00 00 00       	mov    $0x1,%eax
  801551:	e8 f3 fd ff ff       	call   801349 <fsipc>
  801556:	89 c3                	mov    %eax,%ebx
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 19                	js     801578 <open+0x75>
	return fd2num(fd);
  80155f:	83 ec 0c             	sub    $0xc,%esp
  801562:	ff 75 f4             	pushl  -0xc(%ebp)
  801565:	e8 4d f8 ff ff       	call   800db7 <fd2num>
  80156a:	89 c3                	mov    %eax,%ebx
  80156c:	83 c4 10             	add    $0x10,%esp
}
  80156f:	89 d8                	mov    %ebx,%eax
  801571:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801574:	5b                   	pop    %ebx
  801575:	5e                   	pop    %esi
  801576:	5d                   	pop    %ebp
  801577:	c3                   	ret    
		fd_close(fd, 0);
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	6a 00                	push   $0x0
  80157d:	ff 75 f4             	pushl  -0xc(%ebp)
  801580:	e8 54 f9 ff ff       	call   800ed9 <fd_close>
		return r;
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	eb e5                	jmp    80156f <open+0x6c>
		return -E_BAD_PATH;
  80158a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80158f:	eb de                	jmp    80156f <open+0x6c>

00801591 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801597:	ba 00 00 00 00       	mov    $0x0,%edx
  80159c:	b8 08 00 00 00       	mov    $0x8,%eax
  8015a1:	e8 a3 fd ff ff       	call   801349 <fsipc>
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8015ae:	68 0f 27 80 00       	push   $0x80270f
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	e8 f3 f1 ff ff       	call   8007ae <strcpy>
	return 0;
}
  8015bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <devsock_close>:
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	53                   	push   %ebx
  8015c6:	83 ec 10             	sub    $0x10,%esp
  8015c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8015cc:	53                   	push   %ebx
  8015cd:	e8 3f 0a 00 00       	call   802011 <pageref>
  8015d2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8015d5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8015da:	83 f8 01             	cmp    $0x1,%eax
  8015dd:	74 07                	je     8015e6 <devsock_close+0x24>
}
  8015df:	89 d0                	mov    %edx,%eax
  8015e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	ff 73 0c             	pushl  0xc(%ebx)
  8015ec:	e8 b7 02 00 00       	call   8018a8 <nsipc_close>
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	eb e7                	jmp    8015df <devsock_close+0x1d>

008015f8 <devsock_write>:
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015fe:	6a 00                	push   $0x0
  801600:	ff 75 10             	pushl  0x10(%ebp)
  801603:	ff 75 0c             	pushl  0xc(%ebp)
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	ff 70 0c             	pushl  0xc(%eax)
  80160c:	e8 74 03 00 00       	call   801985 <nsipc_send>
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <devsock_read>:
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801619:	6a 00                	push   $0x0
  80161b:	ff 75 10             	pushl  0x10(%ebp)
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	ff 70 0c             	pushl  0xc(%eax)
  801627:	e8 ed 02 00 00       	call   801919 <nsipc_recv>
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <fd2sockid>:
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801634:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801637:	52                   	push   %edx
  801638:	50                   	push   %eax
  801639:	e8 ef f7 ff ff       	call   800e2d <fd_lookup>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 10                	js     801655 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801648:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80164e:	39 08                	cmp    %ecx,(%eax)
  801650:	75 05                	jne    801657 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801652:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    
		return -E_NOT_SUPP;
  801657:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80165c:	eb f7                	jmp    801655 <fd2sockid+0x27>

0080165e <alloc_sockfd>:
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	83 ec 1c             	sub    $0x1c,%esp
  801666:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801668:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166b:	50                   	push   %eax
  80166c:	e8 6d f7 ff ff       	call   800dde <fd_alloc>
  801671:	89 c3                	mov    %eax,%ebx
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	85 c0                	test   %eax,%eax
  801678:	78 43                	js     8016bd <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	68 07 04 00 00       	push   $0x407
  801682:	ff 75 f4             	pushl  -0xc(%ebp)
  801685:	6a 00                	push   $0x0
  801687:	e8 1b f5 ff ff       	call   800ba7 <sys_page_alloc>
  80168c:	89 c3                	mov    %eax,%ebx
  80168e:	83 c4 10             	add    $0x10,%esp
  801691:	85 c0                	test   %eax,%eax
  801693:	78 28                	js     8016bd <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801698:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80169e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8016aa:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	50                   	push   %eax
  8016b1:	e8 01 f7 ff ff       	call   800db7 <fd2num>
  8016b6:	89 c3                	mov    %eax,%ebx
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	eb 0c                	jmp    8016c9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8016bd:	83 ec 0c             	sub    $0xc,%esp
  8016c0:	56                   	push   %esi
  8016c1:	e8 e2 01 00 00       	call   8018a8 <nsipc_close>
		return r;
  8016c6:	83 c4 10             	add    $0x10,%esp
}
  8016c9:	89 d8                	mov    %ebx,%eax
  8016cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5d                   	pop    %ebp
  8016d1:	c3                   	ret    

008016d2 <accept>:
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	e8 4e ff ff ff       	call   80162e <fd2sockid>
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 1b                	js     8016ff <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8016e4:	83 ec 04             	sub    $0x4,%esp
  8016e7:	ff 75 10             	pushl  0x10(%ebp)
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	50                   	push   %eax
  8016ee:	e8 0e 01 00 00       	call   801801 <nsipc_accept>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 05                	js     8016ff <accept+0x2d>
	return alloc_sockfd(r);
  8016fa:	e8 5f ff ff ff       	call   80165e <alloc_sockfd>
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <bind>:
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	e8 1f ff ff ff       	call   80162e <fd2sockid>
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 12                	js     801725 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801713:	83 ec 04             	sub    $0x4,%esp
  801716:	ff 75 10             	pushl  0x10(%ebp)
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	50                   	push   %eax
  80171d:	e8 2f 01 00 00       	call   801851 <nsipc_bind>
  801722:	83 c4 10             	add    $0x10,%esp
}
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <shutdown>:
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80172d:	8b 45 08             	mov    0x8(%ebp),%eax
  801730:	e8 f9 fe ff ff       	call   80162e <fd2sockid>
  801735:	85 c0                	test   %eax,%eax
  801737:	78 0f                	js     801748 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801739:	83 ec 08             	sub    $0x8,%esp
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	50                   	push   %eax
  801740:	e8 41 01 00 00       	call   801886 <nsipc_shutdown>
  801745:	83 c4 10             	add    $0x10,%esp
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <connect>:
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	e8 d6 fe ff ff       	call   80162e <fd2sockid>
  801758:	85 c0                	test   %eax,%eax
  80175a:	78 12                	js     80176e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80175c:	83 ec 04             	sub    $0x4,%esp
  80175f:	ff 75 10             	pushl  0x10(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	50                   	push   %eax
  801766:	e8 57 01 00 00       	call   8018c2 <nsipc_connect>
  80176b:	83 c4 10             	add    $0x10,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <listen>:
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	e8 b0 fe ff ff       	call   80162e <fd2sockid>
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 0f                	js     801791 <listen+0x21>
	return nsipc_listen(r, backlog);
  801782:	83 ec 08             	sub    $0x8,%esp
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	50                   	push   %eax
  801789:	e8 69 01 00 00       	call   8018f7 <nsipc_listen>
  80178e:	83 c4 10             	add    $0x10,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <socket>:

int
socket(int domain, int type, int protocol)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801799:	ff 75 10             	pushl  0x10(%ebp)
  80179c:	ff 75 0c             	pushl  0xc(%ebp)
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	e8 3c 02 00 00       	call   8019e3 <nsipc_socket>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 05                	js     8017b3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8017ae:	e8 ab fe ff ff       	call   80165e <alloc_sockfd>
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	53                   	push   %ebx
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8017be:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8017c5:	74 26                	je     8017ed <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8017c7:	6a 07                	push   $0x7
  8017c9:	68 00 60 80 00       	push   $0x806000
  8017ce:	53                   	push   %ebx
  8017cf:	ff 35 04 40 80 00    	pushl  0x804004
  8017d5:	e8 aa 07 00 00       	call   801f84 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8017da:	83 c4 0c             	add    $0xc,%esp
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	e8 35 07 00 00       	call   801f1d <ipc_recv>
}
  8017e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	6a 02                	push   $0x2
  8017f2:	e8 e1 07 00 00       	call   801fd8 <ipc_find_env>
  8017f7:	a3 04 40 80 00       	mov    %eax,0x804004
  8017fc:	83 c4 10             	add    $0x10,%esp
  8017ff:	eb c6                	jmp    8017c7 <nsipc+0x12>

00801801 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	56                   	push   %esi
  801805:	53                   	push   %ebx
  801806:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801811:	8b 06                	mov    (%esi),%eax
  801813:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801818:	b8 01 00 00 00       	mov    $0x1,%eax
  80181d:	e8 93 ff ff ff       	call   8017b5 <nsipc>
  801822:	89 c3                	mov    %eax,%ebx
  801824:	85 c0                	test   %eax,%eax
  801826:	78 20                	js     801848 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	ff 35 10 60 80 00    	pushl  0x806010
  801831:	68 00 60 80 00       	push   $0x806000
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	e8 fe f0 ff ff       	call   80093c <memmove>
		*addrlen = ret->ret_addrlen;
  80183e:	a1 10 60 80 00       	mov    0x806010,%eax
  801843:	89 06                	mov    %eax,(%esi)
  801845:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801848:	89 d8                	mov    %ebx,%eax
  80184a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184d:	5b                   	pop    %ebx
  80184e:	5e                   	pop    %esi
  80184f:	5d                   	pop    %ebp
  801850:	c3                   	ret    

00801851 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	53                   	push   %ebx
  801855:	83 ec 08             	sub    $0x8,%esp
  801858:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801863:	53                   	push   %ebx
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	68 04 60 80 00       	push   $0x806004
  80186c:	e8 cb f0 ff ff       	call   80093c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801871:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801877:	b8 02 00 00 00       	mov    $0x2,%eax
  80187c:	e8 34 ff ff ff       	call   8017b5 <nsipc>
}
  801881:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801894:	8b 45 0c             	mov    0xc(%ebp),%eax
  801897:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80189c:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a1:	e8 0f ff ff ff       	call   8017b5 <nsipc>
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <nsipc_close>:

int
nsipc_close(int s)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8018b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8018bb:	e8 f5 fe ff ff       	call   8017b5 <nsipc>
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 08             	sub    $0x8,%esp
  8018c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8018d4:	53                   	push   %ebx
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	68 04 60 80 00       	push   $0x806004
  8018dd:	e8 5a f0 ff ff       	call   80093c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8018e2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8018e8:	b8 05 00 00 00       	mov    $0x5,%eax
  8018ed:	e8 c3 fe ff ff       	call   8017b5 <nsipc>
}
  8018f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801905:	8b 45 0c             	mov    0xc(%ebp),%eax
  801908:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80190d:	b8 06 00 00 00       	mov    $0x6,%eax
  801912:	e8 9e fe ff ff       	call   8017b5 <nsipc>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801929:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80192f:	8b 45 14             	mov    0x14(%ebp),%eax
  801932:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801937:	b8 07 00 00 00       	mov    $0x7,%eax
  80193c:	e8 74 fe ff ff       	call   8017b5 <nsipc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	85 c0                	test   %eax,%eax
  801945:	78 1f                	js     801966 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801947:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  80194c:	7f 21                	jg     80196f <nsipc_recv+0x56>
  80194e:	39 c6                	cmp    %eax,%esi
  801950:	7c 1d                	jl     80196f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	50                   	push   %eax
  801956:	68 00 60 80 00       	push   $0x806000
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	e8 d9 ef ff ff       	call   80093c <memmove>
  801963:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801966:	89 d8                	mov    %ebx,%eax
  801968:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  80196f:	68 1b 27 80 00       	push   $0x80271b
  801974:	68 e3 26 80 00       	push   $0x8026e3
  801979:	6a 62                	push   $0x62
  80197b:	68 30 27 80 00       	push   $0x802730
  801980:	e8 52 05 00 00       	call   801ed7 <_panic>

00801985 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	53                   	push   %ebx
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801997:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  80199d:	7f 2e                	jg     8019cd <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	53                   	push   %ebx
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	68 0c 60 80 00       	push   $0x80600c
  8019ab:	e8 8c ef ff ff       	call   80093c <memmove>
	nsipcbuf.send.req_size = size;
  8019b0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8019b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8019be:	b8 08 00 00 00       	mov    $0x8,%eax
  8019c3:	e8 ed fd ff ff       	call   8017b5 <nsipc>
}
  8019c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    
	assert(size < 1600);
  8019cd:	68 3c 27 80 00       	push   $0x80273c
  8019d2:	68 e3 26 80 00       	push   $0x8026e3
  8019d7:	6a 6d                	push   $0x6d
  8019d9:	68 30 27 80 00       	push   $0x802730
  8019de:	e8 f4 04 00 00       	call   801ed7 <_panic>

008019e3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8019f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801a01:	b8 09 00 00 00       	mov    $0x9,%eax
  801a06:	e8 aa fd ff ff       	call   8017b5 <nsipc>
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	e8 a7 f3 ff ff       	call   800dc7 <fd2data>
  801a20:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a22:	83 c4 08             	add    $0x8,%esp
  801a25:	68 48 27 80 00       	push   $0x802748
  801a2a:	53                   	push   %ebx
  801a2b:	e8 7e ed ff ff       	call   8007ae <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a30:	8b 46 04             	mov    0x4(%esi),%eax
  801a33:	2b 06                	sub    (%esi),%eax
  801a35:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a3b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a42:	00 00 00 
	stat->st_dev = &devpipe;
  801a45:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a4c:	30 80 00 
	return 0;
}
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    

00801a5b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	53                   	push   %ebx
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a65:	53                   	push   %ebx
  801a66:	6a 00                	push   $0x0
  801a68:	e8 bf f1 ff ff       	call   800c2c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a6d:	89 1c 24             	mov    %ebx,(%esp)
  801a70:	e8 52 f3 ff ff       	call   800dc7 <fd2data>
  801a75:	83 c4 08             	add    $0x8,%esp
  801a78:	50                   	push   %eax
  801a79:	6a 00                	push   $0x0
  801a7b:	e8 ac f1 ff ff       	call   800c2c <sys_page_unmap>
}
  801a80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <_pipeisclosed>:
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	57                   	push   %edi
  801a89:	56                   	push   %esi
  801a8a:	53                   	push   %ebx
  801a8b:	83 ec 1c             	sub    $0x1c,%esp
  801a8e:	89 c7                	mov    %eax,%edi
  801a90:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a92:	a1 08 40 80 00       	mov    0x804008,%eax
  801a97:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a9a:	83 ec 0c             	sub    $0xc,%esp
  801a9d:	57                   	push   %edi
  801a9e:	e8 6e 05 00 00       	call   802011 <pageref>
  801aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801aa6:	89 34 24             	mov    %esi,(%esp)
  801aa9:	e8 63 05 00 00       	call   802011 <pageref>
		nn = thisenv->env_runs;
  801aae:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ab4:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	39 cb                	cmp    %ecx,%ebx
  801abc:	74 1b                	je     801ad9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801abe:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ac1:	75 cf                	jne    801a92 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ac3:	8b 42 58             	mov    0x58(%edx),%eax
  801ac6:	6a 01                	push   $0x1
  801ac8:	50                   	push   %eax
  801ac9:	53                   	push   %ebx
  801aca:	68 4f 27 80 00       	push   $0x80274f
  801acf:	e8 bb e6 ff ff       	call   80018f <cprintf>
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	eb b9                	jmp    801a92 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ad9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801adc:	0f 94 c0             	sete   %al
  801adf:	0f b6 c0             	movzbl %al,%eax
}
  801ae2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5f                   	pop    %edi
  801ae8:	5d                   	pop    %ebp
  801ae9:	c3                   	ret    

00801aea <devpipe_write>:
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	57                   	push   %edi
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 28             	sub    $0x28,%esp
  801af3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801af6:	56                   	push   %esi
  801af7:	e8 cb f2 ff ff       	call   800dc7 <fd2data>
  801afc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	bf 00 00 00 00       	mov    $0x0,%edi
  801b06:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b09:	74 4f                	je     801b5a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b0b:	8b 43 04             	mov    0x4(%ebx),%eax
  801b0e:	8b 0b                	mov    (%ebx),%ecx
  801b10:	8d 51 20             	lea    0x20(%ecx),%edx
  801b13:	39 d0                	cmp    %edx,%eax
  801b15:	72 14                	jb     801b2b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b17:	89 da                	mov    %ebx,%edx
  801b19:	89 f0                	mov    %esi,%eax
  801b1b:	e8 65 ff ff ff       	call   801a85 <_pipeisclosed>
  801b20:	85 c0                	test   %eax,%eax
  801b22:	75 3a                	jne    801b5e <devpipe_write+0x74>
			sys_yield();
  801b24:	e8 5f f0 ff ff       	call   800b88 <sys_yield>
  801b29:	eb e0                	jmp    801b0b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b2e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b32:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b35:	89 c2                	mov    %eax,%edx
  801b37:	c1 fa 1f             	sar    $0x1f,%edx
  801b3a:	89 d1                	mov    %edx,%ecx
  801b3c:	c1 e9 1b             	shr    $0x1b,%ecx
  801b3f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b42:	83 e2 1f             	and    $0x1f,%edx
  801b45:	29 ca                	sub    %ecx,%edx
  801b47:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b4b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b4f:	83 c0 01             	add    $0x1,%eax
  801b52:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b55:	83 c7 01             	add    $0x1,%edi
  801b58:	eb ac                	jmp    801b06 <devpipe_write+0x1c>
	return i;
  801b5a:	89 f8                	mov    %edi,%eax
  801b5c:	eb 05                	jmp    801b63 <devpipe_write+0x79>
				return 0;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5e                   	pop    %esi
  801b68:	5f                   	pop    %edi
  801b69:	5d                   	pop    %ebp
  801b6a:	c3                   	ret    

00801b6b <devpipe_read>:
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	57                   	push   %edi
  801b6f:	56                   	push   %esi
  801b70:	53                   	push   %ebx
  801b71:	83 ec 18             	sub    $0x18,%esp
  801b74:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b77:	57                   	push   %edi
  801b78:	e8 4a f2 ff ff       	call   800dc7 <fd2data>
  801b7d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b7f:	83 c4 10             	add    $0x10,%esp
  801b82:	be 00 00 00 00       	mov    $0x0,%esi
  801b87:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b8a:	74 47                	je     801bd3 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b8c:	8b 03                	mov    (%ebx),%eax
  801b8e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b91:	75 22                	jne    801bb5 <devpipe_read+0x4a>
			if (i > 0)
  801b93:	85 f6                	test   %esi,%esi
  801b95:	75 14                	jne    801bab <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b97:	89 da                	mov    %ebx,%edx
  801b99:	89 f8                	mov    %edi,%eax
  801b9b:	e8 e5 fe ff ff       	call   801a85 <_pipeisclosed>
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	75 33                	jne    801bd7 <devpipe_read+0x6c>
			sys_yield();
  801ba4:	e8 df ef ff ff       	call   800b88 <sys_yield>
  801ba9:	eb e1                	jmp    801b8c <devpipe_read+0x21>
				return i;
  801bab:	89 f0                	mov    %esi,%eax
}
  801bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801bb5:	99                   	cltd   
  801bb6:	c1 ea 1b             	shr    $0x1b,%edx
  801bb9:	01 d0                	add    %edx,%eax
  801bbb:	83 e0 1f             	and    $0x1f,%eax
  801bbe:	29 d0                	sub    %edx,%eax
  801bc0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bc8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801bcb:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801bce:	83 c6 01             	add    $0x1,%esi
  801bd1:	eb b4                	jmp    801b87 <devpipe_read+0x1c>
	return i;
  801bd3:	89 f0                	mov    %esi,%eax
  801bd5:	eb d6                	jmp    801bad <devpipe_read+0x42>
				return 0;
  801bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdc:	eb cf                	jmp    801bad <devpipe_read+0x42>

00801bde <pipe>:
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	56                   	push   %esi
  801be2:	53                   	push   %ebx
  801be3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801be6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801be9:	50                   	push   %eax
  801bea:	e8 ef f1 ff ff       	call   800dde <fd_alloc>
  801bef:	89 c3                	mov    %eax,%ebx
  801bf1:	83 c4 10             	add    $0x10,%esp
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 5b                	js     801c53 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	68 07 04 00 00       	push   $0x407
  801c00:	ff 75 f4             	pushl  -0xc(%ebp)
  801c03:	6a 00                	push   $0x0
  801c05:	e8 9d ef ff ff       	call   800ba7 <sys_page_alloc>
  801c0a:	89 c3                	mov    %eax,%ebx
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	78 40                	js     801c53 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c13:	83 ec 0c             	sub    $0xc,%esp
  801c16:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c19:	50                   	push   %eax
  801c1a:	e8 bf f1 ff ff       	call   800dde <fd_alloc>
  801c1f:	89 c3                	mov    %eax,%ebx
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	85 c0                	test   %eax,%eax
  801c26:	78 1b                	js     801c43 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 07 04 00 00       	push   $0x407
  801c30:	ff 75 f0             	pushl  -0x10(%ebp)
  801c33:	6a 00                	push   $0x0
  801c35:	e8 6d ef ff ff       	call   800ba7 <sys_page_alloc>
  801c3a:	89 c3                	mov    %eax,%ebx
  801c3c:	83 c4 10             	add    $0x10,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	79 19                	jns    801c5c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c43:	83 ec 08             	sub    $0x8,%esp
  801c46:	ff 75 f4             	pushl  -0xc(%ebp)
  801c49:	6a 00                	push   $0x0
  801c4b:	e8 dc ef ff ff       	call   800c2c <sys_page_unmap>
  801c50:	83 c4 10             	add    $0x10,%esp
}
  801c53:	89 d8                	mov    %ebx,%eax
  801c55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c58:	5b                   	pop    %ebx
  801c59:	5e                   	pop    %esi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
	va = fd2data(fd0);
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c62:	e8 60 f1 ff ff       	call   800dc7 <fd2data>
  801c67:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c69:	83 c4 0c             	add    $0xc,%esp
  801c6c:	68 07 04 00 00       	push   $0x407
  801c71:	50                   	push   %eax
  801c72:	6a 00                	push   $0x0
  801c74:	e8 2e ef ff ff       	call   800ba7 <sys_page_alloc>
  801c79:	89 c3                	mov    %eax,%ebx
  801c7b:	83 c4 10             	add    $0x10,%esp
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	0f 88 8c 00 00 00    	js     801d12 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c86:	83 ec 0c             	sub    $0xc,%esp
  801c89:	ff 75 f0             	pushl  -0x10(%ebp)
  801c8c:	e8 36 f1 ff ff       	call   800dc7 <fd2data>
  801c91:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c98:	50                   	push   %eax
  801c99:	6a 00                	push   $0x0
  801c9b:	56                   	push   %esi
  801c9c:	6a 00                	push   $0x0
  801c9e:	e8 47 ef ff ff       	call   800bea <sys_page_map>
  801ca3:	89 c3                	mov    %eax,%ebx
  801ca5:	83 c4 20             	add    $0x20,%esp
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	78 58                	js     801d04 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cb5:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801cca:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ccf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	ff 75 f4             	pushl  -0xc(%ebp)
  801cdc:	e8 d6 f0 ff ff       	call   800db7 <fd2num>
  801ce1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ce6:	83 c4 04             	add    $0x4,%esp
  801ce9:	ff 75 f0             	pushl  -0x10(%ebp)
  801cec:	e8 c6 f0 ff ff       	call   800db7 <fd2num>
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cff:	e9 4f ff ff ff       	jmp    801c53 <pipe+0x75>
	sys_page_unmap(0, va);
  801d04:	83 ec 08             	sub    $0x8,%esp
  801d07:	56                   	push   %esi
  801d08:	6a 00                	push   $0x0
  801d0a:	e8 1d ef ff ff       	call   800c2c <sys_page_unmap>
  801d0f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d12:	83 ec 08             	sub    $0x8,%esp
  801d15:	ff 75 f0             	pushl  -0x10(%ebp)
  801d18:	6a 00                	push   $0x0
  801d1a:	e8 0d ef ff ff       	call   800c2c <sys_page_unmap>
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	e9 1c ff ff ff       	jmp    801c43 <pipe+0x65>

00801d27 <pipeisclosed>:
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d30:	50                   	push   %eax
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	e8 f4 f0 ff ff       	call   800e2d <fd_lookup>
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	85 c0                	test   %eax,%eax
  801d3e:	78 18                	js     801d58 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d40:	83 ec 0c             	sub    $0xc,%esp
  801d43:	ff 75 f4             	pushl  -0xc(%ebp)
  801d46:	e8 7c f0 ff ff       	call   800dc7 <fd2data>
	return _pipeisclosed(fd, p);
  801d4b:	89 c2                	mov    %eax,%edx
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	e8 30 fd ff ff       	call   801a85 <_pipeisclosed>
  801d55:	83 c4 10             	add    $0x10,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d6a:	68 67 27 80 00       	push   $0x802767
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	e8 37 ea ff ff       	call   8007ae <strcpy>
	return 0;
}
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <devcons_write>:
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	57                   	push   %edi
  801d82:	56                   	push   %esi
  801d83:	53                   	push   %ebx
  801d84:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d8a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d8f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d95:	eb 2f                	jmp    801dc6 <devcons_write+0x48>
		m = n - tot;
  801d97:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d9a:	29 f3                	sub    %esi,%ebx
  801d9c:	83 fb 7f             	cmp    $0x7f,%ebx
  801d9f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801da4:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	53                   	push   %ebx
  801dab:	89 f0                	mov    %esi,%eax
  801dad:	03 45 0c             	add    0xc(%ebp),%eax
  801db0:	50                   	push   %eax
  801db1:	57                   	push   %edi
  801db2:	e8 85 eb ff ff       	call   80093c <memmove>
		sys_cputs(buf, m);
  801db7:	83 c4 08             	add    $0x8,%esp
  801dba:	53                   	push   %ebx
  801dbb:	57                   	push   %edi
  801dbc:	e8 2a ed ff ff       	call   800aeb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801dc1:	01 de                	add    %ebx,%esi
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dc9:	72 cc                	jb     801d97 <devcons_write+0x19>
}
  801dcb:	89 f0                	mov    %esi,%eax
  801dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5e                   	pop    %esi
  801dd2:	5f                   	pop    %edi
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    

00801dd5 <devcons_read>:
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801de0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801de4:	75 07                	jne    801ded <devcons_read+0x18>
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    
		sys_yield();
  801de8:	e8 9b ed ff ff       	call   800b88 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ded:	e8 17 ed ff ff       	call   800b09 <sys_cgetc>
  801df2:	85 c0                	test   %eax,%eax
  801df4:	74 f2                	je     801de8 <devcons_read+0x13>
	if (c < 0)
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 ec                	js     801de6 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801dfa:	83 f8 04             	cmp    $0x4,%eax
  801dfd:	74 0c                	je     801e0b <devcons_read+0x36>
	*(char*)vbuf = c;
  801dff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e02:	88 02                	mov    %al,(%edx)
	return 1;
  801e04:	b8 01 00 00 00       	mov    $0x1,%eax
  801e09:	eb db                	jmp    801de6 <devcons_read+0x11>
		return 0;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e10:	eb d4                	jmp    801de6 <devcons_read+0x11>

00801e12 <cputchar>:
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e1e:	6a 01                	push   $0x1
  801e20:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e23:	50                   	push   %eax
  801e24:	e8 c2 ec ff ff       	call   800aeb <sys_cputs>
}
  801e29:	83 c4 10             	add    $0x10,%esp
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <getchar>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e34:	6a 01                	push   $0x1
  801e36:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e39:	50                   	push   %eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	e8 5d f2 ff ff       	call   80109e <read>
	if (r < 0)
  801e41:	83 c4 10             	add    $0x10,%esp
  801e44:	85 c0                	test   %eax,%eax
  801e46:	78 08                	js     801e50 <getchar+0x22>
	if (r < 1)
  801e48:	85 c0                	test   %eax,%eax
  801e4a:	7e 06                	jle    801e52 <getchar+0x24>
	return c;
  801e4c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    
		return -E_EOF;
  801e52:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e57:	eb f7                	jmp    801e50 <getchar+0x22>

00801e59 <iscons>:
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e62:	50                   	push   %eax
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	e8 c2 ef ff ff       	call   800e2d <fd_lookup>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 11                	js     801e83 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e7b:	39 10                	cmp    %edx,(%eax)
  801e7d:	0f 94 c0             	sete   %al
  801e80:	0f b6 c0             	movzbl %al,%eax
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <opencons>:
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8e:	50                   	push   %eax
  801e8f:	e8 4a ef ff ff       	call   800dde <fd_alloc>
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	85 c0                	test   %eax,%eax
  801e99:	78 3a                	js     801ed5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 07 04 00 00       	push   $0x407
  801ea3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea6:	6a 00                	push   $0x0
  801ea8:	e8 fa ec ff ff       	call   800ba7 <sys_page_alloc>
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	78 21                	js     801ed5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801ebd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ec9:	83 ec 0c             	sub    $0xc,%esp
  801ecc:	50                   	push   %eax
  801ecd:	e8 e5 ee ff ff       	call   800db7 <fd2num>
  801ed2:	83 c4 10             	add    $0x10,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	56                   	push   %esi
  801edb:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801edc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801edf:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ee5:	e8 7f ec ff ff       	call   800b69 <sys_getenvid>
  801eea:	83 ec 0c             	sub    $0xc,%esp
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	56                   	push   %esi
  801ef4:	50                   	push   %eax
  801ef5:	68 74 27 80 00       	push   $0x802774
  801efa:	e8 90 e2 ff ff       	call   80018f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801eff:	83 c4 18             	add    $0x18,%esp
  801f02:	53                   	push   %ebx
  801f03:	ff 75 10             	pushl  0x10(%ebp)
  801f06:	e8 33 e2 ff ff       	call   80013e <vcprintf>
	cprintf("\n");
  801f0b:	c7 04 24 60 27 80 00 	movl   $0x802760,(%esp)
  801f12:	e8 78 e2 ff ff       	call   80018f <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f1a:	cc                   	int3   
  801f1b:	eb fd                	jmp    801f1a <_panic+0x43>

00801f1d <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	56                   	push   %esi
  801f21:	53                   	push   %ebx
  801f22:	8b 75 08             	mov    0x8(%ebp),%esi
  801f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f2b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f2d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f32:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	50                   	push   %eax
  801f39:	e8 19 ee ff ff       	call   800d57 <sys_ipc_recv>
	if (from_env_store)
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	85 f6                	test   %esi,%esi
  801f43:	74 14                	je     801f59 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f45:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 09                	js     801f57 <ipc_recv+0x3a>
  801f4e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f54:	8b 52 74             	mov    0x74(%edx),%edx
  801f57:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f59:	85 db                	test   %ebx,%ebx
  801f5b:	74 14                	je     801f71 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f62:	85 c0                	test   %eax,%eax
  801f64:	78 09                	js     801f6f <ipc_recv+0x52>
  801f66:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f6c:	8b 52 78             	mov    0x78(%edx),%edx
  801f6f:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f71:	85 c0                	test   %eax,%eax
  801f73:	78 08                	js     801f7d <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f75:	a1 08 40 80 00       	mov    0x804008,%eax
  801f7a:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f80:	5b                   	pop    %ebx
  801f81:	5e                   	pop    %esi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	57                   	push   %edi
  801f88:	56                   	push   %esi
  801f89:	53                   	push   %ebx
  801f8a:	83 ec 0c             	sub    $0xc,%esp
  801f8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f90:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f93:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f96:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f98:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f9d:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801fa0:	ff 75 14             	pushl  0x14(%ebp)
  801fa3:	53                   	push   %ebx
  801fa4:	56                   	push   %esi
  801fa5:	57                   	push   %edi
  801fa6:	e8 89 ed ff ff       	call   800d34 <sys_ipc_try_send>
		if (ret == 0)
  801fab:	83 c4 10             	add    $0x10,%esp
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	74 1e                	je     801fd0 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801fb2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801fb5:	75 07                	jne    801fbe <ipc_send+0x3a>
			sys_yield();
  801fb7:	e8 cc eb ff ff       	call   800b88 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801fbc:	eb e2                	jmp    801fa0 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801fbe:	50                   	push   %eax
  801fbf:	68 98 27 80 00       	push   $0x802798
  801fc4:	6a 3d                	push   $0x3d
  801fc6:	68 ac 27 80 00       	push   $0x8027ac
  801fcb:	e8 07 ff ff ff       	call   801ed7 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fd3:	5b                   	pop    %ebx
  801fd4:	5e                   	pop    %esi
  801fd5:	5f                   	pop    %edi
  801fd6:	5d                   	pop    %ebp
  801fd7:	c3                   	ret    

00801fd8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fde:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fe3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fe6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fec:	8b 52 50             	mov    0x50(%edx),%edx
  801fef:	39 ca                	cmp    %ecx,%edx
  801ff1:	74 11                	je     802004 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801ff3:	83 c0 01             	add    $0x1,%eax
  801ff6:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ffb:	75 e6                	jne    801fe3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	eb 0b                	jmp    80200f <ipc_find_env+0x37>
			return envs[i].env_id;
  802004:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802007:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80200c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802017:	89 d0                	mov    %edx,%eax
  802019:	c1 e8 16             	shr    $0x16,%eax
  80201c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802028:	f6 c1 01             	test   $0x1,%cl
  80202b:	74 1d                	je     80204a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80202d:	c1 ea 0c             	shr    $0xc,%edx
  802030:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802037:	f6 c2 01             	test   $0x1,%dl
  80203a:	74 0e                	je     80204a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80203c:	c1 ea 0c             	shr    $0xc,%edx
  80203f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802046:	ef 
  802047:	0f b7 c0             	movzwl %ax,%eax
}
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
  80204c:	66 90                	xchg   %ax,%ax
  80204e:	66 90                	xchg   %ax,%ax

00802050 <__udivdi3>:
  802050:	55                   	push   %ebp
  802051:	57                   	push   %edi
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	83 ec 1c             	sub    $0x1c,%esp
  802057:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80205b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80205f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802063:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802067:	85 d2                	test   %edx,%edx
  802069:	75 35                	jne    8020a0 <__udivdi3+0x50>
  80206b:	39 f3                	cmp    %esi,%ebx
  80206d:	0f 87 bd 00 00 00    	ja     802130 <__udivdi3+0xe0>
  802073:	85 db                	test   %ebx,%ebx
  802075:	89 d9                	mov    %ebx,%ecx
  802077:	75 0b                	jne    802084 <__udivdi3+0x34>
  802079:	b8 01 00 00 00       	mov    $0x1,%eax
  80207e:	31 d2                	xor    %edx,%edx
  802080:	f7 f3                	div    %ebx
  802082:	89 c1                	mov    %eax,%ecx
  802084:	31 d2                	xor    %edx,%edx
  802086:	89 f0                	mov    %esi,%eax
  802088:	f7 f1                	div    %ecx
  80208a:	89 c6                	mov    %eax,%esi
  80208c:	89 e8                	mov    %ebp,%eax
  80208e:	89 f7                	mov    %esi,%edi
  802090:	f7 f1                	div    %ecx
  802092:	89 fa                	mov    %edi,%edx
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
  80209c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020a0:	39 f2                	cmp    %esi,%edx
  8020a2:	77 7c                	ja     802120 <__udivdi3+0xd0>
  8020a4:	0f bd fa             	bsr    %edx,%edi
  8020a7:	83 f7 1f             	xor    $0x1f,%edi
  8020aa:	0f 84 98 00 00 00    	je     802148 <__udivdi3+0xf8>
  8020b0:	89 f9                	mov    %edi,%ecx
  8020b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020b7:	29 f8                	sub    %edi,%eax
  8020b9:	d3 e2                	shl    %cl,%edx
  8020bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020bf:	89 c1                	mov    %eax,%ecx
  8020c1:	89 da                	mov    %ebx,%edx
  8020c3:	d3 ea                	shr    %cl,%edx
  8020c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020c9:	09 d1                	or     %edx,%ecx
  8020cb:	89 f2                	mov    %esi,%edx
  8020cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d1:	89 f9                	mov    %edi,%ecx
  8020d3:	d3 e3                	shl    %cl,%ebx
  8020d5:	89 c1                	mov    %eax,%ecx
  8020d7:	d3 ea                	shr    %cl,%edx
  8020d9:	89 f9                	mov    %edi,%ecx
  8020db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020df:	d3 e6                	shl    %cl,%esi
  8020e1:	89 eb                	mov    %ebp,%ebx
  8020e3:	89 c1                	mov    %eax,%ecx
  8020e5:	d3 eb                	shr    %cl,%ebx
  8020e7:	09 de                	or     %ebx,%esi
  8020e9:	89 f0                	mov    %esi,%eax
  8020eb:	f7 74 24 08          	divl   0x8(%esp)
  8020ef:	89 d6                	mov    %edx,%esi
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	f7 64 24 0c          	mull   0xc(%esp)
  8020f7:	39 d6                	cmp    %edx,%esi
  8020f9:	72 0c                	jb     802107 <__udivdi3+0xb7>
  8020fb:	89 f9                	mov    %edi,%ecx
  8020fd:	d3 e5                	shl    %cl,%ebp
  8020ff:	39 c5                	cmp    %eax,%ebp
  802101:	73 5d                	jae    802160 <__udivdi3+0x110>
  802103:	39 d6                	cmp    %edx,%esi
  802105:	75 59                	jne    802160 <__udivdi3+0x110>
  802107:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80210a:	31 ff                	xor    %edi,%edi
  80210c:	89 fa                	mov    %edi,%edx
  80210e:	83 c4 1c             	add    $0x1c,%esp
  802111:	5b                   	pop    %ebx
  802112:	5e                   	pop    %esi
  802113:	5f                   	pop    %edi
  802114:	5d                   	pop    %ebp
  802115:	c3                   	ret    
  802116:	8d 76 00             	lea    0x0(%esi),%esi
  802119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802120:	31 ff                	xor    %edi,%edi
  802122:	31 c0                	xor    %eax,%eax
  802124:	89 fa                	mov    %edi,%edx
  802126:	83 c4 1c             	add    $0x1c,%esp
  802129:	5b                   	pop    %ebx
  80212a:	5e                   	pop    %esi
  80212b:	5f                   	pop    %edi
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    
  80212e:	66 90                	xchg   %ax,%ax
  802130:	31 ff                	xor    %edi,%edi
  802132:	89 e8                	mov    %ebp,%eax
  802134:	89 f2                	mov    %esi,%edx
  802136:	f7 f3                	div    %ebx
  802138:	89 fa                	mov    %edi,%edx
  80213a:	83 c4 1c             	add    $0x1c,%esp
  80213d:	5b                   	pop    %ebx
  80213e:	5e                   	pop    %esi
  80213f:	5f                   	pop    %edi
  802140:	5d                   	pop    %ebp
  802141:	c3                   	ret    
  802142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802148:	39 f2                	cmp    %esi,%edx
  80214a:	72 06                	jb     802152 <__udivdi3+0x102>
  80214c:	31 c0                	xor    %eax,%eax
  80214e:	39 eb                	cmp    %ebp,%ebx
  802150:	77 d2                	ja     802124 <__udivdi3+0xd4>
  802152:	b8 01 00 00 00       	mov    $0x1,%eax
  802157:	eb cb                	jmp    802124 <__udivdi3+0xd4>
  802159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802160:	89 d8                	mov    %ebx,%eax
  802162:	31 ff                	xor    %edi,%edi
  802164:	eb be                	jmp    802124 <__udivdi3+0xd4>
  802166:	66 90                	xchg   %ax,%ax
  802168:	66 90                	xchg   %ax,%ax
  80216a:	66 90                	xchg   %ax,%ax
  80216c:	66 90                	xchg   %ax,%ax
  80216e:	66 90                	xchg   %ax,%ax

00802170 <__umoddi3>:
  802170:	55                   	push   %ebp
  802171:	57                   	push   %edi
  802172:	56                   	push   %esi
  802173:	53                   	push   %ebx
  802174:	83 ec 1c             	sub    $0x1c,%esp
  802177:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80217b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80217f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802187:	85 ed                	test   %ebp,%ebp
  802189:	89 f0                	mov    %esi,%eax
  80218b:	89 da                	mov    %ebx,%edx
  80218d:	75 19                	jne    8021a8 <__umoddi3+0x38>
  80218f:	39 df                	cmp    %ebx,%edi
  802191:	0f 86 b1 00 00 00    	jbe    802248 <__umoddi3+0xd8>
  802197:	f7 f7                	div    %edi
  802199:	89 d0                	mov    %edx,%eax
  80219b:	31 d2                	xor    %edx,%edx
  80219d:	83 c4 1c             	add    $0x1c,%esp
  8021a0:	5b                   	pop    %ebx
  8021a1:	5e                   	pop    %esi
  8021a2:	5f                   	pop    %edi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    
  8021a5:	8d 76 00             	lea    0x0(%esi),%esi
  8021a8:	39 dd                	cmp    %ebx,%ebp
  8021aa:	77 f1                	ja     80219d <__umoddi3+0x2d>
  8021ac:	0f bd cd             	bsr    %ebp,%ecx
  8021af:	83 f1 1f             	xor    $0x1f,%ecx
  8021b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021b6:	0f 84 b4 00 00 00    	je     802270 <__umoddi3+0x100>
  8021bc:	b8 20 00 00 00       	mov    $0x20,%eax
  8021c1:	89 c2                	mov    %eax,%edx
  8021c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021c7:	29 c2                	sub    %eax,%edx
  8021c9:	89 c1                	mov    %eax,%ecx
  8021cb:	89 f8                	mov    %edi,%eax
  8021cd:	d3 e5                	shl    %cl,%ebp
  8021cf:	89 d1                	mov    %edx,%ecx
  8021d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021d5:	d3 e8                	shr    %cl,%eax
  8021d7:	09 c5                	or     %eax,%ebp
  8021d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021dd:	89 c1                	mov    %eax,%ecx
  8021df:	d3 e7                	shl    %cl,%edi
  8021e1:	89 d1                	mov    %edx,%ecx
  8021e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021e7:	89 df                	mov    %ebx,%edi
  8021e9:	d3 ef                	shr    %cl,%edi
  8021eb:	89 c1                	mov    %eax,%ecx
  8021ed:	89 f0                	mov    %esi,%eax
  8021ef:	d3 e3                	shl    %cl,%ebx
  8021f1:	89 d1                	mov    %edx,%ecx
  8021f3:	89 fa                	mov    %edi,%edx
  8021f5:	d3 e8                	shr    %cl,%eax
  8021f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021fc:	09 d8                	or     %ebx,%eax
  8021fe:	f7 f5                	div    %ebp
  802200:	d3 e6                	shl    %cl,%esi
  802202:	89 d1                	mov    %edx,%ecx
  802204:	f7 64 24 08          	mull   0x8(%esp)
  802208:	39 d1                	cmp    %edx,%ecx
  80220a:	89 c3                	mov    %eax,%ebx
  80220c:	89 d7                	mov    %edx,%edi
  80220e:	72 06                	jb     802216 <__umoddi3+0xa6>
  802210:	75 0e                	jne    802220 <__umoddi3+0xb0>
  802212:	39 c6                	cmp    %eax,%esi
  802214:	73 0a                	jae    802220 <__umoddi3+0xb0>
  802216:	2b 44 24 08          	sub    0x8(%esp),%eax
  80221a:	19 ea                	sbb    %ebp,%edx
  80221c:	89 d7                	mov    %edx,%edi
  80221e:	89 c3                	mov    %eax,%ebx
  802220:	89 ca                	mov    %ecx,%edx
  802222:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802227:	29 de                	sub    %ebx,%esi
  802229:	19 fa                	sbb    %edi,%edx
  80222b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80222f:	89 d0                	mov    %edx,%eax
  802231:	d3 e0                	shl    %cl,%eax
  802233:	89 d9                	mov    %ebx,%ecx
  802235:	d3 ee                	shr    %cl,%esi
  802237:	d3 ea                	shr    %cl,%edx
  802239:	09 f0                	or     %esi,%eax
  80223b:	83 c4 1c             	add    $0x1c,%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5e                   	pop    %esi
  802240:	5f                   	pop    %edi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    
  802243:	90                   	nop
  802244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802248:	85 ff                	test   %edi,%edi
  80224a:	89 f9                	mov    %edi,%ecx
  80224c:	75 0b                	jne    802259 <__umoddi3+0xe9>
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	31 d2                	xor    %edx,%edx
  802255:	f7 f7                	div    %edi
  802257:	89 c1                	mov    %eax,%ecx
  802259:	89 d8                	mov    %ebx,%eax
  80225b:	31 d2                	xor    %edx,%edx
  80225d:	f7 f1                	div    %ecx
  80225f:	89 f0                	mov    %esi,%eax
  802261:	f7 f1                	div    %ecx
  802263:	e9 31 ff ff ff       	jmp    802199 <__umoddi3+0x29>
  802268:	90                   	nop
  802269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802270:	39 dd                	cmp    %ebx,%ebp
  802272:	72 08                	jb     80227c <__umoddi3+0x10c>
  802274:	39 f7                	cmp    %esi,%edi
  802276:	0f 87 21 ff ff ff    	ja     80219d <__umoddi3+0x2d>
  80227c:	89 da                	mov    %ebx,%edx
  80227e:	89 f0                	mov    %esi,%eax
  802280:	29 f8                	sub    %edi,%eax
  802282:	19 ea                	sbb    %ebp,%edx
  802284:	e9 14 ff ff ff       	jmp    80219d <__umoddi3+0x2d>

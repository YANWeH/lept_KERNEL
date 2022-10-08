
obj/user/faultread.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 40 22 80 00       	push   $0x802240
  800044:	e8 fa 00 00 00       	call   800143 <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 bf 0a 00 00       	call   800b1d <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800066:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80006b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800070:	85 db                	test   %ebx,%ebx
  800072:	7e 07                	jle    80007b <libmain+0x2d>
		binaryname = argv[0];
  800074:	8b 06                	mov    (%esi),%eax
  800076:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007b:	83 ec 08             	sub    $0x8,%esp
  80007e:	56                   	push   %esi
  80007f:	53                   	push   %ebx
  800080:	e8 ae ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800085:	e8 0a 00 00 00       	call   800094 <exit>
}
  80008a:	83 c4 10             	add    $0x10,%esp
  80008d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800090:	5b                   	pop    %ebx
  800091:	5e                   	pop    %esi
  800092:	5d                   	pop    %ebp
  800093:	c3                   	ret    

00800094 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800094:	55                   	push   %ebp
  800095:	89 e5                	mov    %esp,%ebp
  800097:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009a:	e8 a2 0e 00 00       	call   800f41 <close_all>
	sys_env_destroy(0);
  80009f:	83 ec 0c             	sub    $0xc,%esp
  8000a2:	6a 00                	push   $0x0
  8000a4:	e8 33 0a 00 00       	call   800adc <sys_env_destroy>
}
  8000a9:	83 c4 10             	add    $0x10,%esp
  8000ac:	c9                   	leave  
  8000ad:	c3                   	ret    

008000ae <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	53                   	push   %ebx
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000b8:	8b 13                	mov    (%ebx),%edx
  8000ba:	8d 42 01             	lea    0x1(%edx),%eax
  8000bd:	89 03                	mov    %eax,(%ebx)
  8000bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000cb:	74 09                	je     8000d6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000cd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000d6:	83 ec 08             	sub    $0x8,%esp
  8000d9:	68 ff 00 00 00       	push   $0xff
  8000de:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e1:	50                   	push   %eax
  8000e2:	e8 b8 09 00 00       	call   800a9f <sys_cputs>
		b->idx = 0;
  8000e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	eb db                	jmp    8000cd <putch+0x1f>

008000f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8000fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800102:	00 00 00 
	b.cnt = 0;
  800105:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80010f:	ff 75 0c             	pushl  0xc(%ebp)
  800112:	ff 75 08             	pushl  0x8(%ebp)
  800115:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80011b:	50                   	push   %eax
  80011c:	68 ae 00 80 00       	push   $0x8000ae
  800121:	e8 1a 01 00 00       	call   800240 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800126:	83 c4 08             	add    $0x8,%esp
  800129:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80012f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800135:	50                   	push   %eax
  800136:	e8 64 09 00 00       	call   800a9f <sys_cputs>

	return b.cnt;
}
  80013b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800149:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80014c:	50                   	push   %eax
  80014d:	ff 75 08             	pushl  0x8(%ebp)
  800150:	e8 9d ff ff ff       	call   8000f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 1c             	sub    $0x1c,%esp
  800160:	89 c7                	mov    %eax,%edi
  800162:	89 d6                	mov    %edx,%esi
  800164:	8b 45 08             	mov    0x8(%ebp),%eax
  800167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80016d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800170:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800173:	bb 00 00 00 00       	mov    $0x0,%ebx
  800178:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80017b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80017e:	39 d3                	cmp    %edx,%ebx
  800180:	72 05                	jb     800187 <printnum+0x30>
  800182:	39 45 10             	cmp    %eax,0x10(%ebp)
  800185:	77 7a                	ja     800201 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	ff 75 18             	pushl  0x18(%ebp)
  80018d:	8b 45 14             	mov    0x14(%ebp),%eax
  800190:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800193:	53                   	push   %ebx
  800194:	ff 75 10             	pushl  0x10(%ebp)
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80019d:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001a6:	e8 55 1e 00 00       	call   802000 <__udivdi3>
  8001ab:	83 c4 18             	add    $0x18,%esp
  8001ae:	52                   	push   %edx
  8001af:	50                   	push   %eax
  8001b0:	89 f2                	mov    %esi,%edx
  8001b2:	89 f8                	mov    %edi,%eax
  8001b4:	e8 9e ff ff ff       	call   800157 <printnum>
  8001b9:	83 c4 20             	add    $0x20,%esp
  8001bc:	eb 13                	jmp    8001d1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	56                   	push   %esi
  8001c2:	ff 75 18             	pushl  0x18(%ebp)
  8001c5:	ff d7                	call   *%edi
  8001c7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001ca:	83 eb 01             	sub    $0x1,%ebx
  8001cd:	85 db                	test   %ebx,%ebx
  8001cf:	7f ed                	jg     8001be <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d1:	83 ec 08             	sub    $0x8,%esp
  8001d4:	56                   	push   %esi
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001db:	ff 75 e0             	pushl  -0x20(%ebp)
  8001de:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e4:	e8 37 1f 00 00       	call   802120 <__umoddi3>
  8001e9:	83 c4 14             	add    $0x14,%esp
  8001ec:	0f be 80 68 22 80 00 	movsbl 0x802268(%eax),%eax
  8001f3:	50                   	push   %eax
  8001f4:	ff d7                	call   *%edi
}
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    
  800201:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800204:	eb c4                	jmp    8001ca <printnum+0x73>

00800206 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800210:	8b 10                	mov    (%eax),%edx
  800212:	3b 50 04             	cmp    0x4(%eax),%edx
  800215:	73 0a                	jae    800221 <sprintputch+0x1b>
		*b->buf++ = ch;
  800217:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021a:	89 08                	mov    %ecx,(%eax)
  80021c:	8b 45 08             	mov    0x8(%ebp),%eax
  80021f:	88 02                	mov    %al,(%edx)
}
  800221:	5d                   	pop    %ebp
  800222:	c3                   	ret    

00800223 <printfmt>:
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800229:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 10             	pushl  0x10(%ebp)
  800230:	ff 75 0c             	pushl  0xc(%ebp)
  800233:	ff 75 08             	pushl  0x8(%ebp)
  800236:	e8 05 00 00 00       	call   800240 <vprintfmt>
}
  80023b:	83 c4 10             	add    $0x10,%esp
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <vprintfmt>:
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	57                   	push   %edi
  800244:	56                   	push   %esi
  800245:	53                   	push   %ebx
  800246:	83 ec 2c             	sub    $0x2c,%esp
  800249:	8b 75 08             	mov    0x8(%ebp),%esi
  80024c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80024f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800252:	e9 c1 03 00 00       	jmp    800618 <vprintfmt+0x3d8>
		padc = ' ';
  800257:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80025b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800262:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800269:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800270:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800275:	8d 47 01             	lea    0x1(%edi),%eax
  800278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027b:	0f b6 17             	movzbl (%edi),%edx
  80027e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800281:	3c 55                	cmp    $0x55,%al
  800283:	0f 87 12 04 00 00    	ja     80069b <vprintfmt+0x45b>
  800289:	0f b6 c0             	movzbl %al,%eax
  80028c:	ff 24 85 a0 23 80 00 	jmp    *0x8023a0(,%eax,4)
  800293:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800296:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80029a:	eb d9                	jmp    800275 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80029c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80029f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002a3:	eb d0                	jmp    800275 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002a5:	0f b6 d2             	movzbl %dl,%edx
  8002a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002c0:	83 f9 09             	cmp    $0x9,%ecx
  8002c3:	77 55                	ja     80031a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002c5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002c8:	eb e9                	jmp    8002b3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8002cd:	8b 00                	mov    (%eax),%eax
  8002cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d5:	8d 40 04             	lea    0x4(%eax),%eax
  8002d8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002e2:	79 91                	jns    800275 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002ea:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f1:	eb 82                	jmp    800275 <vprintfmt+0x35>
  8002f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f6:	85 c0                	test   %eax,%eax
  8002f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8002fd:	0f 49 d0             	cmovns %eax,%edx
  800300:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800303:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800306:	e9 6a ff ff ff       	jmp    800275 <vprintfmt+0x35>
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80030e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800315:	e9 5b ff ff ff       	jmp    800275 <vprintfmt+0x35>
  80031a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800320:	eb bc                	jmp    8002de <vprintfmt+0x9e>
			lflag++;
  800322:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800325:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800328:	e9 48 ff ff ff       	jmp    800275 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80032d:	8b 45 14             	mov    0x14(%ebp),%eax
  800330:	8d 78 04             	lea    0x4(%eax),%edi
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	53                   	push   %ebx
  800337:	ff 30                	pushl  (%eax)
  800339:	ff d6                	call   *%esi
			break;
  80033b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80033e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800341:	e9 cf 02 00 00       	jmp    800615 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800346:	8b 45 14             	mov    0x14(%ebp),%eax
  800349:	8d 78 04             	lea    0x4(%eax),%edi
  80034c:	8b 00                	mov    (%eax),%eax
  80034e:	99                   	cltd   
  80034f:	31 d0                	xor    %edx,%eax
  800351:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800353:	83 f8 0f             	cmp    $0xf,%eax
  800356:	7f 23                	jg     80037b <vprintfmt+0x13b>
  800358:	8b 14 85 00 25 80 00 	mov    0x802500(,%eax,4),%edx
  80035f:	85 d2                	test   %edx,%edx
  800361:	74 18                	je     80037b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800363:	52                   	push   %edx
  800364:	68 35 26 80 00       	push   $0x802635
  800369:	53                   	push   %ebx
  80036a:	56                   	push   %esi
  80036b:	e8 b3 fe ff ff       	call   800223 <printfmt>
  800370:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800373:	89 7d 14             	mov    %edi,0x14(%ebp)
  800376:	e9 9a 02 00 00       	jmp    800615 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80037b:	50                   	push   %eax
  80037c:	68 80 22 80 00       	push   $0x802280
  800381:	53                   	push   %ebx
  800382:	56                   	push   %esi
  800383:	e8 9b fe ff ff       	call   800223 <printfmt>
  800388:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80038e:	e9 82 02 00 00       	jmp    800615 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800393:	8b 45 14             	mov    0x14(%ebp),%eax
  800396:	83 c0 04             	add    $0x4,%eax
  800399:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80039c:	8b 45 14             	mov    0x14(%ebp),%eax
  80039f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003a1:	85 ff                	test   %edi,%edi
  8003a3:	b8 79 22 80 00       	mov    $0x802279,%eax
  8003a8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003af:	0f 8e bd 00 00 00    	jle    800472 <vprintfmt+0x232>
  8003b5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003b9:	75 0e                	jne    8003c9 <vprintfmt+0x189>
  8003bb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003be:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003c1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003c4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003c7:	eb 6d                	jmp    800436 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	ff 75 d0             	pushl  -0x30(%ebp)
  8003cf:	57                   	push   %edi
  8003d0:	e8 6e 03 00 00       	call   800743 <strnlen>
  8003d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003d8:	29 c1                	sub    %eax,%ecx
  8003da:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003dd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003ea:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ec:	eb 0f                	jmp    8003fd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	53                   	push   %ebx
  8003f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8003f5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f7:	83 ef 01             	sub    $0x1,%edi
  8003fa:	83 c4 10             	add    $0x10,%esp
  8003fd:	85 ff                	test   %edi,%edi
  8003ff:	7f ed                	jg     8003ee <vprintfmt+0x1ae>
  800401:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800404:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800407:	85 c9                	test   %ecx,%ecx
  800409:	b8 00 00 00 00       	mov    $0x0,%eax
  80040e:	0f 49 c1             	cmovns %ecx,%eax
  800411:	29 c1                	sub    %eax,%ecx
  800413:	89 75 08             	mov    %esi,0x8(%ebp)
  800416:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800419:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80041c:	89 cb                	mov    %ecx,%ebx
  80041e:	eb 16                	jmp    800436 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800420:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800424:	75 31                	jne    800457 <vprintfmt+0x217>
					putch(ch, putdat);
  800426:	83 ec 08             	sub    $0x8,%esp
  800429:	ff 75 0c             	pushl  0xc(%ebp)
  80042c:	50                   	push   %eax
  80042d:	ff 55 08             	call   *0x8(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800433:	83 eb 01             	sub    $0x1,%ebx
  800436:	83 c7 01             	add    $0x1,%edi
  800439:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80043d:	0f be c2             	movsbl %dl,%eax
  800440:	85 c0                	test   %eax,%eax
  800442:	74 59                	je     80049d <vprintfmt+0x25d>
  800444:	85 f6                	test   %esi,%esi
  800446:	78 d8                	js     800420 <vprintfmt+0x1e0>
  800448:	83 ee 01             	sub    $0x1,%esi
  80044b:	79 d3                	jns    800420 <vprintfmt+0x1e0>
  80044d:	89 df                	mov    %ebx,%edi
  80044f:	8b 75 08             	mov    0x8(%ebp),%esi
  800452:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800455:	eb 37                	jmp    80048e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800457:	0f be d2             	movsbl %dl,%edx
  80045a:	83 ea 20             	sub    $0x20,%edx
  80045d:	83 fa 5e             	cmp    $0x5e,%edx
  800460:	76 c4                	jbe    800426 <vprintfmt+0x1e6>
					putch('?', putdat);
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	ff 75 0c             	pushl  0xc(%ebp)
  800468:	6a 3f                	push   $0x3f
  80046a:	ff 55 08             	call   *0x8(%ebp)
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	eb c1                	jmp    800433 <vprintfmt+0x1f3>
  800472:	89 75 08             	mov    %esi,0x8(%ebp)
  800475:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800478:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80047b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80047e:	eb b6                	jmp    800436 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800480:	83 ec 08             	sub    $0x8,%esp
  800483:	53                   	push   %ebx
  800484:	6a 20                	push   $0x20
  800486:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800488:	83 ef 01             	sub    $0x1,%edi
  80048b:	83 c4 10             	add    $0x10,%esp
  80048e:	85 ff                	test   %edi,%edi
  800490:	7f ee                	jg     800480 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800492:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800495:	89 45 14             	mov    %eax,0x14(%ebp)
  800498:	e9 78 01 00 00       	jmp    800615 <vprintfmt+0x3d5>
  80049d:	89 df                	mov    %ebx,%edi
  80049f:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a5:	eb e7                	jmp    80048e <vprintfmt+0x24e>
	if (lflag >= 2)
  8004a7:	83 f9 01             	cmp    $0x1,%ecx
  8004aa:	7e 3f                	jle    8004eb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8004af:	8b 50 04             	mov    0x4(%eax),%edx
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 08             	lea    0x8(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004c3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c7:	79 5c                	jns    800525 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004c9:	83 ec 08             	sub    $0x8,%esp
  8004cc:	53                   	push   %ebx
  8004cd:	6a 2d                	push   $0x2d
  8004cf:	ff d6                	call   *%esi
				num = -(long long) num;
  8004d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004d7:	f7 da                	neg    %edx
  8004d9:	83 d1 00             	adc    $0x0,%ecx
  8004dc:	f7 d9                	neg    %ecx
  8004de:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004e6:	e9 10 01 00 00       	jmp    8005fb <vprintfmt+0x3bb>
	else if (lflag)
  8004eb:	85 c9                	test   %ecx,%ecx
  8004ed:	75 1b                	jne    80050a <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f7:	89 c1                	mov    %eax,%ecx
  8004f9:	c1 f9 1f             	sar    $0x1f,%ecx
  8004fc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8d 40 04             	lea    0x4(%eax),%eax
  800505:	89 45 14             	mov    %eax,0x14(%ebp)
  800508:	eb b9                	jmp    8004c3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8b 00                	mov    (%eax),%eax
  80050f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800512:	89 c1                	mov    %eax,%ecx
  800514:	c1 f9 1f             	sar    $0x1f,%ecx
  800517:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8d 40 04             	lea    0x4(%eax),%eax
  800520:	89 45 14             	mov    %eax,0x14(%ebp)
  800523:	eb 9e                	jmp    8004c3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800525:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800528:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80052b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800530:	e9 c6 00 00 00       	jmp    8005fb <vprintfmt+0x3bb>
	if (lflag >= 2)
  800535:	83 f9 01             	cmp    $0x1,%ecx
  800538:	7e 18                	jle    800552 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80053a:	8b 45 14             	mov    0x14(%ebp),%eax
  80053d:	8b 10                	mov    (%eax),%edx
  80053f:	8b 48 04             	mov    0x4(%eax),%ecx
  800542:	8d 40 08             	lea    0x8(%eax),%eax
  800545:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800548:	b8 0a 00 00 00       	mov    $0xa,%eax
  80054d:	e9 a9 00 00 00       	jmp    8005fb <vprintfmt+0x3bb>
	else if (lflag)
  800552:	85 c9                	test   %ecx,%ecx
  800554:	75 1a                	jne    800570 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800556:	8b 45 14             	mov    0x14(%ebp),%eax
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800560:	8d 40 04             	lea    0x4(%eax),%eax
  800563:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 8b 00 00 00       	jmp    8005fb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 10                	mov    (%eax),%edx
  800575:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057a:	8d 40 04             	lea    0x4(%eax),%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800580:	b8 0a 00 00 00       	mov    $0xa,%eax
  800585:	eb 74                	jmp    8005fb <vprintfmt+0x3bb>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7e 15                	jle    8005a1 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 10                	mov    (%eax),%edx
  800591:	8b 48 04             	mov    0x4(%eax),%ecx
  800594:	8d 40 08             	lea    0x8(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059a:	b8 08 00 00 00       	mov    $0x8,%eax
  80059f:	eb 5a                	jmp    8005fb <vprintfmt+0x3bb>
	else if (lflag)
  8005a1:	85 c9                	test   %ecx,%ecx
  8005a3:	75 17                	jne    8005bc <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	8b 10                	mov    (%eax),%edx
  8005aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005af:	8d 40 04             	lea    0x4(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8005ba:	eb 3f                	jmp    8005fb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bf:	8b 10                	mov    (%eax),%edx
  8005c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c6:	8d 40 04             	lea    0x4(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d1:	eb 28                	jmp    8005fb <vprintfmt+0x3bb>
			putch('0', putdat);
  8005d3:	83 ec 08             	sub    $0x8,%esp
  8005d6:	53                   	push   %ebx
  8005d7:	6a 30                	push   $0x30
  8005d9:	ff d6                	call   *%esi
			putch('x', putdat);
  8005db:	83 c4 08             	add    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 78                	push   $0x78
  8005e1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 10                	mov    (%eax),%edx
  8005e8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ed:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005fb:	83 ec 0c             	sub    $0xc,%esp
  8005fe:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800602:	57                   	push   %edi
  800603:	ff 75 e0             	pushl  -0x20(%ebp)
  800606:	50                   	push   %eax
  800607:	51                   	push   %ecx
  800608:	52                   	push   %edx
  800609:	89 da                	mov    %ebx,%edx
  80060b:	89 f0                	mov    %esi,%eax
  80060d:	e8 45 fb ff ff       	call   800157 <printnum>
			break;
  800612:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800615:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800618:	83 c7 01             	add    $0x1,%edi
  80061b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061f:	83 f8 25             	cmp    $0x25,%eax
  800622:	0f 84 2f fc ff ff    	je     800257 <vprintfmt+0x17>
			if (ch == '\0')
  800628:	85 c0                	test   %eax,%eax
  80062a:	0f 84 8b 00 00 00    	je     8006bb <vprintfmt+0x47b>
			putch(ch, putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	53                   	push   %ebx
  800634:	50                   	push   %eax
  800635:	ff d6                	call   *%esi
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	eb dc                	jmp    800618 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80063c:	83 f9 01             	cmp    $0x1,%ecx
  80063f:	7e 15                	jle    800656 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 10                	mov    (%eax),%edx
  800646:	8b 48 04             	mov    0x4(%eax),%ecx
  800649:	8d 40 08             	lea    0x8(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064f:	b8 10 00 00 00       	mov    $0x10,%eax
  800654:	eb a5                	jmp    8005fb <vprintfmt+0x3bb>
	else if (lflag)
  800656:	85 c9                	test   %ecx,%ecx
  800658:	75 17                	jne    800671 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066a:	b8 10 00 00 00       	mov    $0x10,%eax
  80066f:	eb 8a                	jmp    8005fb <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800681:	b8 10 00 00 00       	mov    $0x10,%eax
  800686:	e9 70 ff ff ff       	jmp    8005fb <vprintfmt+0x3bb>
			putch(ch, putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 25                	push   $0x25
  800691:	ff d6                	call   *%esi
			break;
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	e9 7a ff ff ff       	jmp    800615 <vprintfmt+0x3d5>
			putch('%', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 25                	push   $0x25
  8006a1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	89 f8                	mov    %edi,%eax
  8006a8:	eb 03                	jmp    8006ad <vprintfmt+0x46d>
  8006aa:	83 e8 01             	sub    $0x1,%eax
  8006ad:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006b1:	75 f7                	jne    8006aa <vprintfmt+0x46a>
  8006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b6:	e9 5a ff ff ff       	jmp    800615 <vprintfmt+0x3d5>
}
  8006bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5e                   	pop    %esi
  8006c0:	5f                   	pop    %edi
  8006c1:	5d                   	pop    %ebp
  8006c2:	c3                   	ret    

008006c3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c3:	55                   	push   %ebp
  8006c4:	89 e5                	mov    %esp,%ebp
  8006c6:	83 ec 18             	sub    $0x18,%esp
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006e0:	85 c0                	test   %eax,%eax
  8006e2:	74 26                	je     80070a <vsnprintf+0x47>
  8006e4:	85 d2                	test   %edx,%edx
  8006e6:	7e 22                	jle    80070a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e8:	ff 75 14             	pushl  0x14(%ebp)
  8006eb:	ff 75 10             	pushl  0x10(%ebp)
  8006ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f1:	50                   	push   %eax
  8006f2:	68 06 02 80 00       	push   $0x800206
  8006f7:	e8 44 fb ff ff       	call   800240 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ff:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800705:	83 c4 10             	add    $0x10,%esp
}
  800708:	c9                   	leave  
  800709:	c3                   	ret    
		return -E_INVAL;
  80070a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070f:	eb f7                	jmp    800708 <vsnprintf+0x45>

00800711 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800717:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071a:	50                   	push   %eax
  80071b:	ff 75 10             	pushl  0x10(%ebp)
  80071e:	ff 75 0c             	pushl  0xc(%ebp)
  800721:	ff 75 08             	pushl  0x8(%ebp)
  800724:	e8 9a ff ff ff       	call   8006c3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800731:	b8 00 00 00 00       	mov    $0x0,%eax
  800736:	eb 03                	jmp    80073b <strlen+0x10>
		n++;
  800738:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80073b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80073f:	75 f7                	jne    800738 <strlen+0xd>
	return n;
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800749:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074c:	b8 00 00 00 00       	mov    $0x0,%eax
  800751:	eb 03                	jmp    800756 <strnlen+0x13>
		n++;
  800753:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800756:	39 d0                	cmp    %edx,%eax
  800758:	74 06                	je     800760 <strnlen+0x1d>
  80075a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80075e:	75 f3                	jne    800753 <strnlen+0x10>
	return n;
}
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	53                   	push   %ebx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80076c:	89 c2                	mov    %eax,%edx
  80076e:	83 c1 01             	add    $0x1,%ecx
  800771:	83 c2 01             	add    $0x1,%edx
  800774:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800778:	88 5a ff             	mov    %bl,-0x1(%edx)
  80077b:	84 db                	test   %bl,%bl
  80077d:	75 ef                	jne    80076e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80077f:	5b                   	pop    %ebx
  800780:	5d                   	pop    %ebp
  800781:	c3                   	ret    

00800782 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	53                   	push   %ebx
  800786:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800789:	53                   	push   %ebx
  80078a:	e8 9c ff ff ff       	call   80072b <strlen>
  80078f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	01 d8                	add    %ebx,%eax
  800797:	50                   	push   %eax
  800798:	e8 c5 ff ff ff       	call   800762 <strcpy>
	return dst;
}
  80079d:	89 d8                	mov    %ebx,%eax
  80079f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007a2:	c9                   	leave  
  8007a3:	c3                   	ret    

008007a4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	56                   	push   %esi
  8007a8:	53                   	push   %ebx
  8007a9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007af:	89 f3                	mov    %esi,%ebx
  8007b1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007b4:	89 f2                	mov    %esi,%edx
  8007b6:	eb 0f                	jmp    8007c7 <strncpy+0x23>
		*dst++ = *src;
  8007b8:	83 c2 01             	add    $0x1,%edx
  8007bb:	0f b6 01             	movzbl (%ecx),%eax
  8007be:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007c1:	80 39 01             	cmpb   $0x1,(%ecx)
  8007c4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007c7:	39 da                	cmp    %ebx,%edx
  8007c9:	75 ed                	jne    8007b8 <strncpy+0x14>
	}
	return ret;
}
  8007cb:	89 f0                	mov    %esi,%eax
  8007cd:	5b                   	pop    %ebx
  8007ce:	5e                   	pop    %esi
  8007cf:	5d                   	pop    %ebp
  8007d0:	c3                   	ret    

008007d1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007d1:	55                   	push   %ebp
  8007d2:	89 e5                	mov    %esp,%ebp
  8007d4:	56                   	push   %esi
  8007d5:	53                   	push   %ebx
  8007d6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007df:	89 f0                	mov    %esi,%eax
  8007e1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007e5:	85 c9                	test   %ecx,%ecx
  8007e7:	75 0b                	jne    8007f4 <strlcpy+0x23>
  8007e9:	eb 17                	jmp    800802 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007eb:	83 c2 01             	add    $0x1,%edx
  8007ee:	83 c0 01             	add    $0x1,%eax
  8007f1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007f4:	39 d8                	cmp    %ebx,%eax
  8007f6:	74 07                	je     8007ff <strlcpy+0x2e>
  8007f8:	0f b6 0a             	movzbl (%edx),%ecx
  8007fb:	84 c9                	test   %cl,%cl
  8007fd:	75 ec                	jne    8007eb <strlcpy+0x1a>
		*dst = '\0';
  8007ff:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800802:	29 f0                	sub    %esi,%eax
}
  800804:	5b                   	pop    %ebx
  800805:	5e                   	pop    %esi
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800811:	eb 06                	jmp    800819 <strcmp+0x11>
		p++, q++;
  800813:	83 c1 01             	add    $0x1,%ecx
  800816:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800819:	0f b6 01             	movzbl (%ecx),%eax
  80081c:	84 c0                	test   %al,%al
  80081e:	74 04                	je     800824 <strcmp+0x1c>
  800820:	3a 02                	cmp    (%edx),%al
  800822:	74 ef                	je     800813 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800824:	0f b6 c0             	movzbl %al,%eax
  800827:	0f b6 12             	movzbl (%edx),%edx
  80082a:	29 d0                	sub    %edx,%eax
}
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	53                   	push   %ebx
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	8b 55 0c             	mov    0xc(%ebp),%edx
  800838:	89 c3                	mov    %eax,%ebx
  80083a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80083d:	eb 06                	jmp    800845 <strncmp+0x17>
		n--, p++, q++;
  80083f:	83 c0 01             	add    $0x1,%eax
  800842:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800845:	39 d8                	cmp    %ebx,%eax
  800847:	74 16                	je     80085f <strncmp+0x31>
  800849:	0f b6 08             	movzbl (%eax),%ecx
  80084c:	84 c9                	test   %cl,%cl
  80084e:	74 04                	je     800854 <strncmp+0x26>
  800850:	3a 0a                	cmp    (%edx),%cl
  800852:	74 eb                	je     80083f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800854:	0f b6 00             	movzbl (%eax),%eax
  800857:	0f b6 12             	movzbl (%edx),%edx
  80085a:	29 d0                	sub    %edx,%eax
}
  80085c:	5b                   	pop    %ebx
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    
		return 0;
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	eb f6                	jmp    80085c <strncmp+0x2e>

00800866 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800870:	0f b6 10             	movzbl (%eax),%edx
  800873:	84 d2                	test   %dl,%dl
  800875:	74 09                	je     800880 <strchr+0x1a>
		if (*s == c)
  800877:	38 ca                	cmp    %cl,%dl
  800879:	74 0a                	je     800885 <strchr+0x1f>
	for (; *s; s++)
  80087b:	83 c0 01             	add    $0x1,%eax
  80087e:	eb f0                	jmp    800870 <strchr+0xa>
			return (char *) s;
	return 0;
  800880:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800891:	eb 03                	jmp    800896 <strfind+0xf>
  800893:	83 c0 01             	add    $0x1,%eax
  800896:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800899:	38 ca                	cmp    %cl,%dl
  80089b:	74 04                	je     8008a1 <strfind+0x1a>
  80089d:	84 d2                	test   %dl,%dl
  80089f:	75 f2                	jne    800893 <strfind+0xc>
			break;
	return (char *) s;
}
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	57                   	push   %edi
  8008a7:	56                   	push   %esi
  8008a8:	53                   	push   %ebx
  8008a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008af:	85 c9                	test   %ecx,%ecx
  8008b1:	74 13                	je     8008c6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008b3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008b9:	75 05                	jne    8008c0 <memset+0x1d>
  8008bb:	f6 c1 03             	test   $0x3,%cl
  8008be:	74 0d                	je     8008cd <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c3:	fc                   	cld    
  8008c4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008c6:	89 f8                	mov    %edi,%eax
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5f                   	pop    %edi
  8008cb:	5d                   	pop    %ebp
  8008cc:	c3                   	ret    
		c &= 0xFF;
  8008cd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008d1:	89 d3                	mov    %edx,%ebx
  8008d3:	c1 e3 08             	shl    $0x8,%ebx
  8008d6:	89 d0                	mov    %edx,%eax
  8008d8:	c1 e0 18             	shl    $0x18,%eax
  8008db:	89 d6                	mov    %edx,%esi
  8008dd:	c1 e6 10             	shl    $0x10,%esi
  8008e0:	09 f0                	or     %esi,%eax
  8008e2:	09 c2                	or     %eax,%edx
  8008e4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008e6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008e9:	89 d0                	mov    %edx,%eax
  8008eb:	fc                   	cld    
  8008ec:	f3 ab                	rep stos %eax,%es:(%edi)
  8008ee:	eb d6                	jmp    8008c6 <memset+0x23>

008008f0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	57                   	push   %edi
  8008f4:	56                   	push   %esi
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008fe:	39 c6                	cmp    %eax,%esi
  800900:	73 35                	jae    800937 <memmove+0x47>
  800902:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800905:	39 c2                	cmp    %eax,%edx
  800907:	76 2e                	jbe    800937 <memmove+0x47>
		s += n;
		d += n;
  800909:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80090c:	89 d6                	mov    %edx,%esi
  80090e:	09 fe                	or     %edi,%esi
  800910:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800916:	74 0c                	je     800924 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800918:	83 ef 01             	sub    $0x1,%edi
  80091b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80091e:	fd                   	std    
  80091f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800921:	fc                   	cld    
  800922:	eb 21                	jmp    800945 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800924:	f6 c1 03             	test   $0x3,%cl
  800927:	75 ef                	jne    800918 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800929:	83 ef 04             	sub    $0x4,%edi
  80092c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80092f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800932:	fd                   	std    
  800933:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800935:	eb ea                	jmp    800921 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800937:	89 f2                	mov    %esi,%edx
  800939:	09 c2                	or     %eax,%edx
  80093b:	f6 c2 03             	test   $0x3,%dl
  80093e:	74 09                	je     800949 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800940:	89 c7                	mov    %eax,%edi
  800942:	fc                   	cld    
  800943:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800945:	5e                   	pop    %esi
  800946:	5f                   	pop    %edi
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800949:	f6 c1 03             	test   $0x3,%cl
  80094c:	75 f2                	jne    800940 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80094e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800951:	89 c7                	mov    %eax,%edi
  800953:	fc                   	cld    
  800954:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800956:	eb ed                	jmp    800945 <memmove+0x55>

00800958 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80095b:	ff 75 10             	pushl  0x10(%ebp)
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	ff 75 08             	pushl  0x8(%ebp)
  800964:	e8 87 ff ff ff       	call   8008f0 <memmove>
}
  800969:	c9                   	leave  
  80096a:	c3                   	ret    

0080096b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	56                   	push   %esi
  80096f:	53                   	push   %ebx
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	89 c6                	mov    %eax,%esi
  800978:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80097b:	39 f0                	cmp    %esi,%eax
  80097d:	74 1c                	je     80099b <memcmp+0x30>
		if (*s1 != *s2)
  80097f:	0f b6 08             	movzbl (%eax),%ecx
  800982:	0f b6 1a             	movzbl (%edx),%ebx
  800985:	38 d9                	cmp    %bl,%cl
  800987:	75 08                	jne    800991 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800989:	83 c0 01             	add    $0x1,%eax
  80098c:	83 c2 01             	add    $0x1,%edx
  80098f:	eb ea                	jmp    80097b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800991:	0f b6 c1             	movzbl %cl,%eax
  800994:	0f b6 db             	movzbl %bl,%ebx
  800997:	29 d8                	sub    %ebx,%eax
  800999:	eb 05                	jmp    8009a0 <memcmp+0x35>
	}

	return 0;
  80099b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a0:	5b                   	pop    %ebx
  8009a1:	5e                   	pop    %esi
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    

008009a4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ad:	89 c2                	mov    %eax,%edx
  8009af:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009b2:	39 d0                	cmp    %edx,%eax
  8009b4:	73 09                	jae    8009bf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009b6:	38 08                	cmp    %cl,(%eax)
  8009b8:	74 05                	je     8009bf <memfind+0x1b>
	for (; s < ends; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	eb f3                	jmp    8009b2 <memfind+0xe>
			break;
	return (void *) s;
}
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    

008009c1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	57                   	push   %edi
  8009c5:	56                   	push   %esi
  8009c6:	53                   	push   %ebx
  8009c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009cd:	eb 03                	jmp    8009d2 <strtol+0x11>
		s++;
  8009cf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009d2:	0f b6 01             	movzbl (%ecx),%eax
  8009d5:	3c 20                	cmp    $0x20,%al
  8009d7:	74 f6                	je     8009cf <strtol+0xe>
  8009d9:	3c 09                	cmp    $0x9,%al
  8009db:	74 f2                	je     8009cf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009dd:	3c 2b                	cmp    $0x2b,%al
  8009df:	74 2e                	je     800a0f <strtol+0x4e>
	int neg = 0;
  8009e1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009e6:	3c 2d                	cmp    $0x2d,%al
  8009e8:	74 2f                	je     800a19 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ea:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  8009f0:	75 05                	jne    8009f7 <strtol+0x36>
  8009f2:	80 39 30             	cmpb   $0x30,(%ecx)
  8009f5:	74 2c                	je     800a23 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009f7:	85 db                	test   %ebx,%ebx
  8009f9:	75 0a                	jne    800a05 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009fb:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a00:	80 39 30             	cmpb   $0x30,(%ecx)
  800a03:	74 28                	je     800a2d <strtol+0x6c>
		base = 10;
  800a05:	b8 00 00 00 00       	mov    $0x0,%eax
  800a0a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a0d:	eb 50                	jmp    800a5f <strtol+0x9e>
		s++;
  800a0f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a12:	bf 00 00 00 00       	mov    $0x0,%edi
  800a17:	eb d1                	jmp    8009ea <strtol+0x29>
		s++, neg = 1;
  800a19:	83 c1 01             	add    $0x1,%ecx
  800a1c:	bf 01 00 00 00       	mov    $0x1,%edi
  800a21:	eb c7                	jmp    8009ea <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a23:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a27:	74 0e                	je     800a37 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	75 d8                	jne    800a05 <strtol+0x44>
		s++, base = 8;
  800a2d:	83 c1 01             	add    $0x1,%ecx
  800a30:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a35:	eb ce                	jmp    800a05 <strtol+0x44>
		s += 2, base = 16;
  800a37:	83 c1 02             	add    $0x2,%ecx
  800a3a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a3f:	eb c4                	jmp    800a05 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a41:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a44:	89 f3                	mov    %esi,%ebx
  800a46:	80 fb 19             	cmp    $0x19,%bl
  800a49:	77 29                	ja     800a74 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a4b:	0f be d2             	movsbl %dl,%edx
  800a4e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a51:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a54:	7d 30                	jge    800a86 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a5f:	0f b6 11             	movzbl (%ecx),%edx
  800a62:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a65:	89 f3                	mov    %esi,%ebx
  800a67:	80 fb 09             	cmp    $0x9,%bl
  800a6a:	77 d5                	ja     800a41 <strtol+0x80>
			dig = *s - '0';
  800a6c:	0f be d2             	movsbl %dl,%edx
  800a6f:	83 ea 30             	sub    $0x30,%edx
  800a72:	eb dd                	jmp    800a51 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a74:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a77:	89 f3                	mov    %esi,%ebx
  800a79:	80 fb 19             	cmp    $0x19,%bl
  800a7c:	77 08                	ja     800a86 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a7e:	0f be d2             	movsbl %dl,%edx
  800a81:	83 ea 37             	sub    $0x37,%edx
  800a84:	eb cb                	jmp    800a51 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a8a:	74 05                	je     800a91 <strtol+0xd0>
		*endptr = (char *) s;
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a91:	89 c2                	mov    %eax,%edx
  800a93:	f7 da                	neg    %edx
  800a95:	85 ff                	test   %edi,%edi
  800a97:	0f 45 c2             	cmovne %edx,%eax
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5f                   	pop    %edi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	57                   	push   %edi
  800aa3:	56                   	push   %esi
  800aa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aa5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab0:	89 c3                	mov    %eax,%ebx
  800ab2:	89 c7                	mov    %eax,%edi
  800ab4:	89 c6                	mov    %eax,%esi
  800ab6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ab8:	5b                   	pop    %ebx
  800ab9:	5e                   	pop    %esi
  800aba:	5f                   	pop    %edi
  800abb:	5d                   	pop    %ebp
  800abc:	c3                   	ret    

00800abd <sys_cgetc>:

int
sys_cgetc(void)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	57                   	push   %edi
  800ac1:	56                   	push   %esi
  800ac2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac8:	b8 01 00 00 00       	mov    $0x1,%eax
  800acd:	89 d1                	mov    %edx,%ecx
  800acf:	89 d3                	mov    %edx,%ebx
  800ad1:	89 d7                	mov    %edx,%edi
  800ad3:	89 d6                	mov    %edx,%esi
  800ad5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	57                   	push   %edi
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ae5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800aea:	8b 55 08             	mov    0x8(%ebp),%edx
  800aed:	b8 03 00 00 00       	mov    $0x3,%eax
  800af2:	89 cb                	mov    %ecx,%ebx
  800af4:	89 cf                	mov    %ecx,%edi
  800af6:	89 ce                	mov    %ecx,%esi
  800af8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800afa:	85 c0                	test   %eax,%eax
  800afc:	7f 08                	jg     800b06 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b06:	83 ec 0c             	sub    $0xc,%esp
  800b09:	50                   	push   %eax
  800b0a:	6a 03                	push   $0x3
  800b0c:	68 5f 25 80 00       	push   $0x80255f
  800b11:	6a 23                	push   $0x23
  800b13:	68 7c 25 80 00       	push   $0x80257c
  800b18:	e8 6e 13 00 00       	call   801e8b <_panic>

00800b1d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	57                   	push   %edi
  800b21:	56                   	push   %esi
  800b22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b23:	ba 00 00 00 00       	mov    $0x0,%edx
  800b28:	b8 02 00 00 00       	mov    $0x2,%eax
  800b2d:	89 d1                	mov    %edx,%ecx
  800b2f:	89 d3                	mov    %edx,%ebx
  800b31:	89 d7                	mov    %edx,%edi
  800b33:	89 d6                	mov    %edx,%esi
  800b35:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <sys_yield>:

void
sys_yield(void)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b4c:	89 d1                	mov    %edx,%ecx
  800b4e:	89 d3                	mov    %edx,%ebx
  800b50:	89 d7                	mov    %edx,%edi
  800b52:	89 d6                	mov    %edx,%esi
  800b54:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b64:	be 00 00 00 00       	mov    $0x0,%esi
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6f:	b8 04 00 00 00       	mov    $0x4,%eax
  800b74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b77:	89 f7                	mov    %esi,%edi
  800b79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b7b:	85 c0                	test   %eax,%eax
  800b7d:	7f 08                	jg     800b87 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b87:	83 ec 0c             	sub    $0xc,%esp
  800b8a:	50                   	push   %eax
  800b8b:	6a 04                	push   $0x4
  800b8d:	68 5f 25 80 00       	push   $0x80255f
  800b92:	6a 23                	push   $0x23
  800b94:	68 7c 25 80 00       	push   $0x80257c
  800b99:	e8 ed 12 00 00       	call   801e8b <_panic>

00800b9e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b9e:	55                   	push   %ebp
  800b9f:	89 e5                	mov    %esp,%ebp
  800ba1:	57                   	push   %edi
  800ba2:	56                   	push   %esi
  800ba3:	53                   	push   %ebx
  800ba4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  800baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bad:	b8 05 00 00 00       	mov    $0x5,%eax
  800bb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bb8:	8b 75 18             	mov    0x18(%ebp),%esi
  800bbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	7f 08                	jg     800bc9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc9:	83 ec 0c             	sub    $0xc,%esp
  800bcc:	50                   	push   %eax
  800bcd:	6a 05                	push   $0x5
  800bcf:	68 5f 25 80 00       	push   $0x80255f
  800bd4:	6a 23                	push   $0x23
  800bd6:	68 7c 25 80 00       	push   $0x80257c
  800bdb:	e8 ab 12 00 00       	call   801e8b <_panic>

00800be0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
  800be6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	b8 06 00 00 00       	mov    $0x6,%eax
  800bf9:	89 df                	mov    %ebx,%edi
  800bfb:	89 de                	mov    %ebx,%esi
  800bfd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bff:	85 c0                	test   %eax,%eax
  800c01:	7f 08                	jg     800c0b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0b:	83 ec 0c             	sub    $0xc,%esp
  800c0e:	50                   	push   %eax
  800c0f:	6a 06                	push   $0x6
  800c11:	68 5f 25 80 00       	push   $0x80255f
  800c16:	6a 23                	push   $0x23
  800c18:	68 7c 25 80 00       	push   $0x80257c
  800c1d:	e8 69 12 00 00       	call   801e8b <_panic>

00800c22 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c36:	b8 08 00 00 00       	mov    $0x8,%eax
  800c3b:	89 df                	mov    %ebx,%edi
  800c3d:	89 de                	mov    %ebx,%esi
  800c3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c41:	85 c0                	test   %eax,%eax
  800c43:	7f 08                	jg     800c4d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	5d                   	pop    %ebp
  800c4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4d:	83 ec 0c             	sub    $0xc,%esp
  800c50:	50                   	push   %eax
  800c51:	6a 08                	push   $0x8
  800c53:	68 5f 25 80 00       	push   $0x80255f
  800c58:	6a 23                	push   $0x23
  800c5a:	68 7c 25 80 00       	push   $0x80257c
  800c5f:	e8 27 12 00 00       	call   801e8b <_panic>

00800c64 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
  800c6a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	b8 09 00 00 00       	mov    $0x9,%eax
  800c7d:	89 df                	mov    %ebx,%edi
  800c7f:	89 de                	mov    %ebx,%esi
  800c81:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c83:	85 c0                	test   %eax,%eax
  800c85:	7f 08                	jg     800c8f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8f:	83 ec 0c             	sub    $0xc,%esp
  800c92:	50                   	push   %eax
  800c93:	6a 09                	push   $0x9
  800c95:	68 5f 25 80 00       	push   $0x80255f
  800c9a:	6a 23                	push   $0x23
  800c9c:	68 7c 25 80 00       	push   $0x80257c
  800ca1:	e8 e5 11 00 00       	call   801e8b <_panic>

00800ca6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cbf:	89 df                	mov    %ebx,%edi
  800cc1:	89 de                	mov    %ebx,%esi
  800cc3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc5:	85 c0                	test   %eax,%eax
  800cc7:	7f 08                	jg     800cd1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	5d                   	pop    %ebp
  800cd0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd1:	83 ec 0c             	sub    $0xc,%esp
  800cd4:	50                   	push   %eax
  800cd5:	6a 0a                	push   $0xa
  800cd7:	68 5f 25 80 00       	push   $0x80255f
  800cdc:	6a 23                	push   $0x23
  800cde:	68 7c 25 80 00       	push   $0x80257c
  800ce3:	e8 a3 11 00 00       	call   801e8b <_panic>

00800ce8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cf9:	be 00 00 00 00       	mov    $0x0,%esi
  800cfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d01:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d04:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5f                   	pop    %edi
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d14:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d21:	89 cb                	mov    %ecx,%ebx
  800d23:	89 cf                	mov    %ecx,%edi
  800d25:	89 ce                	mov    %ecx,%esi
  800d27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d29:	85 c0                	test   %eax,%eax
  800d2b:	7f 08                	jg     800d35 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d35:	83 ec 0c             	sub    $0xc,%esp
  800d38:	50                   	push   %eax
  800d39:	6a 0d                	push   $0xd
  800d3b:	68 5f 25 80 00       	push   $0x80255f
  800d40:	6a 23                	push   $0x23
  800d42:	68 7c 25 80 00       	push   $0x80257c
  800d47:	e8 3f 11 00 00       	call   801e8b <_panic>

00800d4c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d52:	ba 00 00 00 00       	mov    $0x0,%edx
  800d57:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d5c:	89 d1                	mov    %edx,%ecx
  800d5e:	89 d3                	mov    %edx,%ebx
  800d60:	89 d7                	mov    %edx,%edi
  800d62:	89 d6                	mov    %edx,%esi
  800d64:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	05 00 00 00 30       	add    $0x30000000,%eax
  800d76:	c1 e8 0c             	shr    $0xc,%eax
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d8b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800d90:	5d                   	pop    %ebp
  800d91:	c3                   	ret    

00800d92 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800d92:	55                   	push   %ebp
  800d93:	89 e5                	mov    %esp,%ebp
  800d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d98:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800d9d:	89 c2                	mov    %eax,%edx
  800d9f:	c1 ea 16             	shr    $0x16,%edx
  800da2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800da9:	f6 c2 01             	test   $0x1,%dl
  800dac:	74 2a                	je     800dd8 <fd_alloc+0x46>
  800dae:	89 c2                	mov    %eax,%edx
  800db0:	c1 ea 0c             	shr    $0xc,%edx
  800db3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dba:	f6 c2 01             	test   $0x1,%dl
  800dbd:	74 19                	je     800dd8 <fd_alloc+0x46>
  800dbf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dc4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dc9:	75 d2                	jne    800d9d <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dcb:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800dd1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800dd6:	eb 07                	jmp    800ddf <fd_alloc+0x4d>
			*fd_store = fd;
  800dd8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800de7:	83 f8 1f             	cmp    $0x1f,%eax
  800dea:	77 36                	ja     800e22 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dec:	c1 e0 0c             	shl    $0xc,%eax
  800def:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800df4:	89 c2                	mov    %eax,%edx
  800df6:	c1 ea 16             	shr    $0x16,%edx
  800df9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e00:	f6 c2 01             	test   $0x1,%dl
  800e03:	74 24                	je     800e29 <fd_lookup+0x48>
  800e05:	89 c2                	mov    %eax,%edx
  800e07:	c1 ea 0c             	shr    $0xc,%edx
  800e0a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e11:	f6 c2 01             	test   $0x1,%dl
  800e14:	74 1a                	je     800e30 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e19:	89 02                	mov    %eax,(%edx)
	return 0;
  800e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    
		return -E_INVAL;
  800e22:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e27:	eb f7                	jmp    800e20 <fd_lookup+0x3f>
		return -E_INVAL;
  800e29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e2e:	eb f0                	jmp    800e20 <fd_lookup+0x3f>
  800e30:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e35:	eb e9                	jmp    800e20 <fd_lookup+0x3f>

00800e37 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e40:	ba 08 26 80 00       	mov    $0x802608,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e45:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e4a:	39 08                	cmp    %ecx,(%eax)
  800e4c:	74 33                	je     800e81 <dev_lookup+0x4a>
  800e4e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e51:	8b 02                	mov    (%edx),%eax
  800e53:	85 c0                	test   %eax,%eax
  800e55:	75 f3                	jne    800e4a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e57:	a1 08 40 80 00       	mov    0x804008,%eax
  800e5c:	8b 40 48             	mov    0x48(%eax),%eax
  800e5f:	83 ec 04             	sub    $0x4,%esp
  800e62:	51                   	push   %ecx
  800e63:	50                   	push   %eax
  800e64:	68 8c 25 80 00       	push   $0x80258c
  800e69:	e8 d5 f2 ff ff       	call   800143 <cprintf>
	*dev = 0;
  800e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e77:	83 c4 10             	add    $0x10,%esp
  800e7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    
			*dev = devtab[i];
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e86:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8b:	eb f2                	jmp    800e7f <dev_lookup+0x48>

00800e8d <fd_close>:
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 1c             	sub    $0x1c,%esp
  800e96:	8b 75 08             	mov    0x8(%ebp),%esi
  800e99:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e9c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800e9f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ea6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ea9:	50                   	push   %eax
  800eaa:	e8 32 ff ff ff       	call   800de1 <fd_lookup>
  800eaf:	89 c3                	mov    %eax,%ebx
  800eb1:	83 c4 08             	add    $0x8,%esp
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	78 05                	js     800ebd <fd_close+0x30>
	    || fd != fd2)
  800eb8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ebb:	74 16                	je     800ed3 <fd_close+0x46>
		return (must_exist ? r : 0);
  800ebd:	89 f8                	mov    %edi,%eax
  800ebf:	84 c0                	test   %al,%al
  800ec1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ec6:	0f 44 d8             	cmove  %eax,%ebx
}
  800ec9:	89 d8                	mov    %ebx,%eax
  800ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ed3:	83 ec 08             	sub    $0x8,%esp
  800ed6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	ff 36                	pushl  (%esi)
  800edc:	e8 56 ff ff ff       	call   800e37 <dev_lookup>
  800ee1:	89 c3                	mov    %eax,%ebx
  800ee3:	83 c4 10             	add    $0x10,%esp
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	78 15                	js     800eff <fd_close+0x72>
		if (dev->dev_close)
  800eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eed:	8b 40 10             	mov    0x10(%eax),%eax
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	74 1b                	je     800f0f <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	56                   	push   %esi
  800ef8:	ff d0                	call   *%eax
  800efa:	89 c3                	mov    %eax,%ebx
  800efc:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800eff:	83 ec 08             	sub    $0x8,%esp
  800f02:	56                   	push   %esi
  800f03:	6a 00                	push   $0x0
  800f05:	e8 d6 fc ff ff       	call   800be0 <sys_page_unmap>
	return r;
  800f0a:	83 c4 10             	add    $0x10,%esp
  800f0d:	eb ba                	jmp    800ec9 <fd_close+0x3c>
			r = 0;
  800f0f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f14:	eb e9                	jmp    800eff <fd_close+0x72>

00800f16 <close>:

int
close(int fdnum)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f1f:	50                   	push   %eax
  800f20:	ff 75 08             	pushl  0x8(%ebp)
  800f23:	e8 b9 fe ff ff       	call   800de1 <fd_lookup>
  800f28:	83 c4 08             	add    $0x8,%esp
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	78 10                	js     800f3f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	6a 01                	push   $0x1
  800f34:	ff 75 f4             	pushl  -0xc(%ebp)
  800f37:	e8 51 ff ff ff       	call   800e8d <fd_close>
  800f3c:	83 c4 10             	add    $0x10,%esp
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <close_all>:

void
close_all(void)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	53                   	push   %ebx
  800f45:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f48:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	53                   	push   %ebx
  800f51:	e8 c0 ff ff ff       	call   800f16 <close>
	for (i = 0; i < MAXFD; i++)
  800f56:	83 c3 01             	add    $0x1,%ebx
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	83 fb 20             	cmp    $0x20,%ebx
  800f5f:	75 ec                	jne    800f4d <close_all+0xc>
}
  800f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
  800f6c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f6f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f72:	50                   	push   %eax
  800f73:	ff 75 08             	pushl  0x8(%ebp)
  800f76:	e8 66 fe ff ff       	call   800de1 <fd_lookup>
  800f7b:	89 c3                	mov    %eax,%ebx
  800f7d:	83 c4 08             	add    $0x8,%esp
  800f80:	85 c0                	test   %eax,%eax
  800f82:	0f 88 81 00 00 00    	js     801009 <dup+0xa3>
		return r;
	close(newfdnum);
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	e8 83 ff ff ff       	call   800f16 <close>

	newfd = INDEX2FD(newfdnum);
  800f93:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f96:	c1 e6 0c             	shl    $0xc,%esi
  800f99:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800f9f:	83 c4 04             	add    $0x4,%esp
  800fa2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fa5:	e8 d1 fd ff ff       	call   800d7b <fd2data>
  800faa:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fac:	89 34 24             	mov    %esi,(%esp)
  800faf:	e8 c7 fd ff ff       	call   800d7b <fd2data>
  800fb4:	83 c4 10             	add    $0x10,%esp
  800fb7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	c1 e8 16             	shr    $0x16,%eax
  800fbe:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc5:	a8 01                	test   $0x1,%al
  800fc7:	74 11                	je     800fda <dup+0x74>
  800fc9:	89 d8                	mov    %ebx,%eax
  800fcb:	c1 e8 0c             	shr    $0xc,%eax
  800fce:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fd5:	f6 c2 01             	test   $0x1,%dl
  800fd8:	75 39                	jne    801013 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	c1 e8 0c             	shr    $0xc,%eax
  800fe2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe9:	83 ec 0c             	sub    $0xc,%esp
  800fec:	25 07 0e 00 00       	and    $0xe07,%eax
  800ff1:	50                   	push   %eax
  800ff2:	56                   	push   %esi
  800ff3:	6a 00                	push   $0x0
  800ff5:	52                   	push   %edx
  800ff6:	6a 00                	push   $0x0
  800ff8:	e8 a1 fb ff ff       	call   800b9e <sys_page_map>
  800ffd:	89 c3                	mov    %eax,%ebx
  800fff:	83 c4 20             	add    $0x20,%esp
  801002:	85 c0                	test   %eax,%eax
  801004:	78 31                	js     801037 <dup+0xd1>
		goto err;

	return newfdnum;
  801006:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801009:	89 d8                	mov    %ebx,%eax
  80100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80100e:	5b                   	pop    %ebx
  80100f:	5e                   	pop    %esi
  801010:	5f                   	pop    %edi
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801013:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	25 07 0e 00 00       	and    $0xe07,%eax
  801022:	50                   	push   %eax
  801023:	57                   	push   %edi
  801024:	6a 00                	push   $0x0
  801026:	53                   	push   %ebx
  801027:	6a 00                	push   $0x0
  801029:	e8 70 fb ff ff       	call   800b9e <sys_page_map>
  80102e:	89 c3                	mov    %eax,%ebx
  801030:	83 c4 20             	add    $0x20,%esp
  801033:	85 c0                	test   %eax,%eax
  801035:	79 a3                	jns    800fda <dup+0x74>
	sys_page_unmap(0, newfd);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	56                   	push   %esi
  80103b:	6a 00                	push   $0x0
  80103d:	e8 9e fb ff ff       	call   800be0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801042:	83 c4 08             	add    $0x8,%esp
  801045:	57                   	push   %edi
  801046:	6a 00                	push   $0x0
  801048:	e8 93 fb ff ff       	call   800be0 <sys_page_unmap>
	return r;
  80104d:	83 c4 10             	add    $0x10,%esp
  801050:	eb b7                	jmp    801009 <dup+0xa3>

00801052 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	53                   	push   %ebx
  801056:	83 ec 14             	sub    $0x14,%esp
  801059:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80105c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80105f:	50                   	push   %eax
  801060:	53                   	push   %ebx
  801061:	e8 7b fd ff ff       	call   800de1 <fd_lookup>
  801066:	83 c4 08             	add    $0x8,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	78 3f                	js     8010ac <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80106d:	83 ec 08             	sub    $0x8,%esp
  801070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801077:	ff 30                	pushl  (%eax)
  801079:	e8 b9 fd ff ff       	call   800e37 <dev_lookup>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	78 27                	js     8010ac <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801085:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801088:	8b 42 08             	mov    0x8(%edx),%eax
  80108b:	83 e0 03             	and    $0x3,%eax
  80108e:	83 f8 01             	cmp    $0x1,%eax
  801091:	74 1e                	je     8010b1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801096:	8b 40 08             	mov    0x8(%eax),%eax
  801099:	85 c0                	test   %eax,%eax
  80109b:	74 35                	je     8010d2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80109d:	83 ec 04             	sub    $0x4,%esp
  8010a0:	ff 75 10             	pushl  0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	52                   	push   %edx
  8010a7:	ff d0                	call   *%eax
  8010a9:	83 c4 10             	add    $0x10,%esp
}
  8010ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010af:	c9                   	leave  
  8010b0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b6:	8b 40 48             	mov    0x48(%eax),%eax
  8010b9:	83 ec 04             	sub    $0x4,%esp
  8010bc:	53                   	push   %ebx
  8010bd:	50                   	push   %eax
  8010be:	68 cd 25 80 00       	push   $0x8025cd
  8010c3:	e8 7b f0 ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  8010c8:	83 c4 10             	add    $0x10,%esp
  8010cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d0:	eb da                	jmp    8010ac <read+0x5a>
		return -E_NOT_SUPP;
  8010d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010d7:	eb d3                	jmp    8010ac <read+0x5a>

008010d9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 0c             	sub    $0xc,%esp
  8010e2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010e5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ed:	39 f3                	cmp    %esi,%ebx
  8010ef:	73 25                	jae    801116 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8010f1:	83 ec 04             	sub    $0x4,%esp
  8010f4:	89 f0                	mov    %esi,%eax
  8010f6:	29 d8                	sub    %ebx,%eax
  8010f8:	50                   	push   %eax
  8010f9:	89 d8                	mov    %ebx,%eax
  8010fb:	03 45 0c             	add    0xc(%ebp),%eax
  8010fe:	50                   	push   %eax
  8010ff:	57                   	push   %edi
  801100:	e8 4d ff ff ff       	call   801052 <read>
		if (m < 0)
  801105:	83 c4 10             	add    $0x10,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	78 08                	js     801114 <readn+0x3b>
			return m;
		if (m == 0)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	74 06                	je     801116 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801110:	01 c3                	add    %eax,%ebx
  801112:	eb d9                	jmp    8010ed <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801114:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801116:	89 d8                	mov    %ebx,%eax
  801118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80111b:	5b                   	pop    %ebx
  80111c:	5e                   	pop    %esi
  80111d:	5f                   	pop    %edi
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	53                   	push   %ebx
  801124:	83 ec 14             	sub    $0x14,%esp
  801127:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80112a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80112d:	50                   	push   %eax
  80112e:	53                   	push   %ebx
  80112f:	e8 ad fc ff ff       	call   800de1 <fd_lookup>
  801134:	83 c4 08             	add    $0x8,%esp
  801137:	85 c0                	test   %eax,%eax
  801139:	78 3a                	js     801175 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801141:	50                   	push   %eax
  801142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801145:	ff 30                	pushl  (%eax)
  801147:	e8 eb fc ff ff       	call   800e37 <dev_lookup>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	78 22                	js     801175 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801156:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80115a:	74 1e                	je     80117a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80115c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115f:	8b 52 0c             	mov    0xc(%edx),%edx
  801162:	85 d2                	test   %edx,%edx
  801164:	74 35                	je     80119b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801166:	83 ec 04             	sub    $0x4,%esp
  801169:	ff 75 10             	pushl  0x10(%ebp)
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	50                   	push   %eax
  801170:	ff d2                	call   *%edx
  801172:	83 c4 10             	add    $0x10,%esp
}
  801175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801178:	c9                   	leave  
  801179:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80117a:	a1 08 40 80 00       	mov    0x804008,%eax
  80117f:	8b 40 48             	mov    0x48(%eax),%eax
  801182:	83 ec 04             	sub    $0x4,%esp
  801185:	53                   	push   %ebx
  801186:	50                   	push   %eax
  801187:	68 e9 25 80 00       	push   $0x8025e9
  80118c:	e8 b2 ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801199:	eb da                	jmp    801175 <write+0x55>
		return -E_NOT_SUPP;
  80119b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011a0:	eb d3                	jmp    801175 <write+0x55>

008011a2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a8:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011ab:	50                   	push   %eax
  8011ac:	ff 75 08             	pushl  0x8(%ebp)
  8011af:	e8 2d fc ff ff       	call   800de1 <fd_lookup>
  8011b4:	83 c4 08             	add    $0x8,%esp
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	78 0e                	js     8011c9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 14             	sub    $0x14,%esp
  8011d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d8:	50                   	push   %eax
  8011d9:	53                   	push   %ebx
  8011da:	e8 02 fc ff ff       	call   800de1 <fd_lookup>
  8011df:	83 c4 08             	add    $0x8,%esp
  8011e2:	85 c0                	test   %eax,%eax
  8011e4:	78 37                	js     80121d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e6:	83 ec 08             	sub    $0x8,%esp
  8011e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ec:	50                   	push   %eax
  8011ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f0:	ff 30                	pushl  (%eax)
  8011f2:	e8 40 fc ff ff       	call   800e37 <dev_lookup>
  8011f7:	83 c4 10             	add    $0x10,%esp
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	78 1f                	js     80121d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801201:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801205:	74 1b                	je     801222 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120a:	8b 52 18             	mov    0x18(%edx),%edx
  80120d:	85 d2                	test   %edx,%edx
  80120f:	74 32                	je     801243 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	50                   	push   %eax
  801218:	ff d2                	call   *%edx
  80121a:	83 c4 10             	add    $0x10,%esp
}
  80121d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801220:	c9                   	leave  
  801221:	c3                   	ret    
			thisenv->env_id, fdnum);
  801222:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801227:	8b 40 48             	mov    0x48(%eax),%eax
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	53                   	push   %ebx
  80122e:	50                   	push   %eax
  80122f:	68 ac 25 80 00       	push   $0x8025ac
  801234:	e8 0a ef ff ff       	call   800143 <cprintf>
		return -E_INVAL;
  801239:	83 c4 10             	add    $0x10,%esp
  80123c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801241:	eb da                	jmp    80121d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801243:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801248:	eb d3                	jmp    80121d <ftruncate+0x52>

0080124a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 14             	sub    $0x14,%esp
  801251:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801257:	50                   	push   %eax
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 81 fb ff ff       	call   800de1 <fd_lookup>
  801260:	83 c4 08             	add    $0x8,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 4b                	js     8012b2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126d:	50                   	push   %eax
  80126e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801271:	ff 30                	pushl  (%eax)
  801273:	e8 bf fb ff ff       	call   800e37 <dev_lookup>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	78 33                	js     8012b2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80127f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801282:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801286:	74 2f                	je     8012b7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801288:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80128b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801292:	00 00 00 
	stat->st_isdir = 0;
  801295:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80129c:	00 00 00 
	stat->st_dev = dev;
  80129f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	53                   	push   %ebx
  8012a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8012ac:	ff 50 14             	call   *0x14(%eax)
  8012af:	83 c4 10             	add    $0x10,%esp
}
  8012b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b5:	c9                   	leave  
  8012b6:	c3                   	ret    
		return -E_NOT_SUPP;
  8012b7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012bc:	eb f4                	jmp    8012b2 <fstat+0x68>

008012be <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	56                   	push   %esi
  8012c2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	ff 75 08             	pushl  0x8(%ebp)
  8012cb:	e8 e7 01 00 00       	call   8014b7 <open>
  8012d0:	89 c3                	mov    %eax,%ebx
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 1b                	js     8012f4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	50                   	push   %eax
  8012e0:	e8 65 ff ff ff       	call   80124a <fstat>
  8012e5:	89 c6                	mov    %eax,%esi
	close(fd);
  8012e7:	89 1c 24             	mov    %ebx,(%esp)
  8012ea:	e8 27 fc ff ff       	call   800f16 <close>
	return r;
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	89 f3                	mov    %esi,%ebx
}
  8012f4:	89 d8                	mov    %ebx,%eax
  8012f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012f9:	5b                   	pop    %ebx
  8012fa:	5e                   	pop    %esi
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	56                   	push   %esi
  801301:	53                   	push   %ebx
  801302:	89 c6                	mov    %eax,%esi
  801304:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801306:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80130d:	74 27                	je     801336 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80130f:	6a 07                	push   $0x7
  801311:	68 00 50 80 00       	push   $0x805000
  801316:	56                   	push   %esi
  801317:	ff 35 00 40 80 00    	pushl  0x804000
  80131d:	e8 16 0c 00 00       	call   801f38 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801322:	83 c4 0c             	add    $0xc,%esp
  801325:	6a 00                	push   $0x0
  801327:	53                   	push   %ebx
  801328:	6a 00                	push   $0x0
  80132a:	e8 a2 0b 00 00       	call   801ed1 <ipc_recv>
}
  80132f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 01                	push   $0x1
  80133b:	e8 4c 0c 00 00       	call   801f8c <ipc_find_env>
  801340:	a3 00 40 80 00       	mov    %eax,0x804000
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	eb c5                	jmp    80130f <fsipc+0x12>

0080134a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	8b 40 0c             	mov    0xc(%eax),%eax
  801356:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801363:	ba 00 00 00 00       	mov    $0x0,%edx
  801368:	b8 02 00 00 00       	mov    $0x2,%eax
  80136d:	e8 8b ff ff ff       	call   8012fd <fsipc>
}
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <devfile_flush>:
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80137a:	8b 45 08             	mov    0x8(%ebp),%eax
  80137d:	8b 40 0c             	mov    0xc(%eax),%eax
  801380:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801385:	ba 00 00 00 00       	mov    $0x0,%edx
  80138a:	b8 06 00 00 00       	mov    $0x6,%eax
  80138f:	e8 69 ff ff ff       	call   8012fd <fsipc>
}
  801394:	c9                   	leave  
  801395:	c3                   	ret    

00801396 <devfile_stat>:
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	53                   	push   %ebx
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a6:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8013b5:	e8 43 ff ff ff       	call   8012fd <fsipc>
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	78 2c                	js     8013ea <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013be:	83 ec 08             	sub    $0x8,%esp
  8013c1:	68 00 50 80 00       	push   $0x805000
  8013c6:	53                   	push   %ebx
  8013c7:	e8 96 f3 ff ff       	call   800762 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013cc:	a1 80 50 80 00       	mov    0x805080,%eax
  8013d1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013d7:	a1 84 50 80 00       	mov    0x805084,%eax
  8013dc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <devfile_write>:
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 0c             	sub    $0xc,%esp
  8013f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f8:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8013fd:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801402:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801405:	8b 55 08             	mov    0x8(%ebp),%edx
  801408:	8b 52 0c             	mov    0xc(%edx),%edx
  80140b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801411:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801416:	50                   	push   %eax
  801417:	ff 75 0c             	pushl  0xc(%ebp)
  80141a:	68 08 50 80 00       	push   $0x805008
  80141f:	e8 cc f4 ff ff       	call   8008f0 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801424:	ba 00 00 00 00       	mov    $0x0,%edx
  801429:	b8 04 00 00 00       	mov    $0x4,%eax
  80142e:	e8 ca fe ff ff       	call   8012fd <fsipc>
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <devfile_read>:
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
  80143a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8b 40 0c             	mov    0xc(%eax),%eax
  801443:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801448:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80144e:	ba 00 00 00 00       	mov    $0x0,%edx
  801453:	b8 03 00 00 00       	mov    $0x3,%eax
  801458:	e8 a0 fe ff ff       	call   8012fd <fsipc>
  80145d:	89 c3                	mov    %eax,%ebx
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 1f                	js     801482 <devfile_read+0x4d>
	assert(r <= n);
  801463:	39 f0                	cmp    %esi,%eax
  801465:	77 24                	ja     80148b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801467:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80146c:	7f 33                	jg     8014a1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	50                   	push   %eax
  801472:	68 00 50 80 00       	push   $0x805000
  801477:	ff 75 0c             	pushl  0xc(%ebp)
  80147a:	e8 71 f4 ff ff       	call   8008f0 <memmove>
	return r;
  80147f:	83 c4 10             	add    $0x10,%esp
}
  801482:	89 d8                	mov    %ebx,%eax
  801484:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801487:	5b                   	pop    %ebx
  801488:	5e                   	pop    %esi
  801489:	5d                   	pop    %ebp
  80148a:	c3                   	ret    
	assert(r <= n);
  80148b:	68 1c 26 80 00       	push   $0x80261c
  801490:	68 23 26 80 00       	push   $0x802623
  801495:	6a 7b                	push   $0x7b
  801497:	68 38 26 80 00       	push   $0x802638
  80149c:	e8 ea 09 00 00       	call   801e8b <_panic>
	assert(r <= PGSIZE);
  8014a1:	68 43 26 80 00       	push   $0x802643
  8014a6:	68 23 26 80 00       	push   $0x802623
  8014ab:	6a 7c                	push   $0x7c
  8014ad:	68 38 26 80 00       	push   $0x802638
  8014b2:	e8 d4 09 00 00       	call   801e8b <_panic>

008014b7 <open>:
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 1c             	sub    $0x1c,%esp
  8014bf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014c2:	56                   	push   %esi
  8014c3:	e8 63 f2 ff ff       	call   80072b <strlen>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014d0:	7f 6c                	jg     80153e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014d2:	83 ec 0c             	sub    $0xc,%esp
  8014d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d8:	50                   	push   %eax
  8014d9:	e8 b4 f8 ff ff       	call   800d92 <fd_alloc>
  8014de:	89 c3                	mov    %eax,%ebx
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 3c                	js     801523 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	56                   	push   %esi
  8014eb:	68 00 50 80 00       	push   $0x805000
  8014f0:	e8 6d f2 ff ff       	call   800762 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8014f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8014fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801500:	b8 01 00 00 00       	mov    $0x1,%eax
  801505:	e8 f3 fd ff ff       	call   8012fd <fsipc>
  80150a:	89 c3                	mov    %eax,%ebx
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 19                	js     80152c <open+0x75>
	return fd2num(fd);
  801513:	83 ec 0c             	sub    $0xc,%esp
  801516:	ff 75 f4             	pushl  -0xc(%ebp)
  801519:	e8 4d f8 ff ff       	call   800d6b <fd2num>
  80151e:	89 c3                	mov    %eax,%ebx
  801520:	83 c4 10             	add    $0x10,%esp
}
  801523:	89 d8                	mov    %ebx,%eax
  801525:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801528:	5b                   	pop    %ebx
  801529:	5e                   	pop    %esi
  80152a:	5d                   	pop    %ebp
  80152b:	c3                   	ret    
		fd_close(fd, 0);
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	6a 00                	push   $0x0
  801531:	ff 75 f4             	pushl  -0xc(%ebp)
  801534:	e8 54 f9 ff ff       	call   800e8d <fd_close>
		return r;
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	eb e5                	jmp    801523 <open+0x6c>
		return -E_BAD_PATH;
  80153e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801543:	eb de                	jmp    801523 <open+0x6c>

00801545 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80154b:	ba 00 00 00 00       	mov    $0x0,%edx
  801550:	b8 08 00 00 00       	mov    $0x8,%eax
  801555:	e8 a3 fd ff ff       	call   8012fd <fsipc>
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801562:	68 4f 26 80 00       	push   $0x80264f
  801567:	ff 75 0c             	pushl  0xc(%ebp)
  80156a:	e8 f3 f1 ff ff       	call   800762 <strcpy>
	return 0;
}
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <devsock_close>:
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 10             	sub    $0x10,%esp
  80157d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801580:	53                   	push   %ebx
  801581:	e8 3f 0a 00 00       	call   801fc5 <pageref>
  801586:	83 c4 10             	add    $0x10,%esp
		return 0;
  801589:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80158e:	83 f8 01             	cmp    $0x1,%eax
  801591:	74 07                	je     80159a <devsock_close+0x24>
}
  801593:	89 d0                	mov    %edx,%eax
  801595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801598:	c9                   	leave  
  801599:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	ff 73 0c             	pushl  0xc(%ebx)
  8015a0:	e8 b7 02 00 00       	call   80185c <nsipc_close>
  8015a5:	89 c2                	mov    %eax,%edx
  8015a7:	83 c4 10             	add    $0x10,%esp
  8015aa:	eb e7                	jmp    801593 <devsock_close+0x1d>

008015ac <devsock_write>:
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	ff 75 10             	pushl  0x10(%ebp)
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	ff 70 0c             	pushl  0xc(%eax)
  8015c0:	e8 74 03 00 00       	call   801939 <nsipc_send>
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <devsock_read>:
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	ff 75 10             	pushl  0x10(%ebp)
  8015d2:	ff 75 0c             	pushl  0xc(%ebp)
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	ff 70 0c             	pushl  0xc(%eax)
  8015db:	e8 ed 02 00 00       	call   8018cd <nsipc_recv>
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <fd2sockid>:
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8015e8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8015eb:	52                   	push   %edx
  8015ec:	50                   	push   %eax
  8015ed:	e8 ef f7 ff ff       	call   800de1 <fd_lookup>
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 10                	js     801609 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801602:	39 08                	cmp    %ecx,(%eax)
  801604:	75 05                	jne    80160b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801606:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    
		return -E_NOT_SUPP;
  80160b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801610:	eb f7                	jmp    801609 <fd2sockid+0x27>

00801612 <alloc_sockfd>:
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	56                   	push   %esi
  801616:	53                   	push   %ebx
  801617:	83 ec 1c             	sub    $0x1c,%esp
  80161a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80161c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161f:	50                   	push   %eax
  801620:	e8 6d f7 ff ff       	call   800d92 <fd_alloc>
  801625:	89 c3                	mov    %eax,%ebx
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 43                	js     801671 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	68 07 04 00 00       	push   $0x407
  801636:	ff 75 f4             	pushl  -0xc(%ebp)
  801639:	6a 00                	push   $0x0
  80163b:	e8 1b f5 ff ff       	call   800b5b <sys_page_alloc>
  801640:	89 c3                	mov    %eax,%ebx
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 28                	js     801671 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801652:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801657:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80165e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	50                   	push   %eax
  801665:	e8 01 f7 ff ff       	call   800d6b <fd2num>
  80166a:	89 c3                	mov    %eax,%ebx
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	eb 0c                	jmp    80167d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	56                   	push   %esi
  801675:	e8 e2 01 00 00       	call   80185c <nsipc_close>
		return r;
  80167a:	83 c4 10             	add    $0x10,%esp
}
  80167d:	89 d8                	mov    %ebx,%eax
  80167f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    

00801686 <accept>:
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	e8 4e ff ff ff       	call   8015e2 <fd2sockid>
  801694:	85 c0                	test   %eax,%eax
  801696:	78 1b                	js     8016b3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	ff 75 10             	pushl  0x10(%ebp)
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	50                   	push   %eax
  8016a2:	e8 0e 01 00 00       	call   8017b5 <nsipc_accept>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 05                	js     8016b3 <accept+0x2d>
	return alloc_sockfd(r);
  8016ae:	e8 5f ff ff ff       	call   801612 <alloc_sockfd>
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <bind>:
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	e8 1f ff ff ff       	call   8015e2 <fd2sockid>
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 12                	js     8016d9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8016c7:	83 ec 04             	sub    $0x4,%esp
  8016ca:	ff 75 10             	pushl  0x10(%ebp)
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	50                   	push   %eax
  8016d1:	e8 2f 01 00 00       	call   801805 <nsipc_bind>
  8016d6:	83 c4 10             	add    $0x10,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <shutdown>:
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	e8 f9 fe ff ff       	call   8015e2 <fd2sockid>
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	78 0f                	js     8016fc <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8016ed:	83 ec 08             	sub    $0x8,%esp
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	50                   	push   %eax
  8016f4:	e8 41 01 00 00       	call   80183a <nsipc_shutdown>
  8016f9:	83 c4 10             	add    $0x10,%esp
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <connect>:
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	e8 d6 fe ff ff       	call   8015e2 <fd2sockid>
  80170c:	85 c0                	test   %eax,%eax
  80170e:	78 12                	js     801722 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	ff 75 10             	pushl  0x10(%ebp)
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	50                   	push   %eax
  80171a:	e8 57 01 00 00       	call   801876 <nsipc_connect>
  80171f:	83 c4 10             	add    $0x10,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <listen>:
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	e8 b0 fe ff ff       	call   8015e2 <fd2sockid>
  801732:	85 c0                	test   %eax,%eax
  801734:	78 0f                	js     801745 <listen+0x21>
	return nsipc_listen(r, backlog);
  801736:	83 ec 08             	sub    $0x8,%esp
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	50                   	push   %eax
  80173d:	e8 69 01 00 00       	call   8018ab <nsipc_listen>
  801742:	83 c4 10             	add    $0x10,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <socket>:

int
socket(int domain, int type, int protocol)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80174d:	ff 75 10             	pushl  0x10(%ebp)
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 3c 02 00 00       	call   801997 <nsipc_socket>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 05                	js     801767 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801762:	e8 ab fe ff ff       	call   801612 <alloc_sockfd>
}
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	53                   	push   %ebx
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801772:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801779:	74 26                	je     8017a1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80177b:	6a 07                	push   $0x7
  80177d:	68 00 60 80 00       	push   $0x806000
  801782:	53                   	push   %ebx
  801783:	ff 35 04 40 80 00    	pushl  0x804004
  801789:	e8 aa 07 00 00       	call   801f38 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80178e:	83 c4 0c             	add    $0xc,%esp
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	e8 35 07 00 00       	call   801ed1 <ipc_recv>
}
  80179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	6a 02                	push   $0x2
  8017a6:	e8 e1 07 00 00       	call   801f8c <ipc_find_env>
  8017ab:	a3 04 40 80 00       	mov    %eax,0x804004
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	eb c6                	jmp    80177b <nsipc+0x12>

008017b5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	56                   	push   %esi
  8017b9:	53                   	push   %ebx
  8017ba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8017c5:	8b 06                	mov    (%esi),%eax
  8017c7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8017cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d1:	e8 93 ff ff ff       	call   801769 <nsipc>
  8017d6:	89 c3                	mov    %eax,%ebx
  8017d8:	85 c0                	test   %eax,%eax
  8017da:	78 20                	js     8017fc <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	ff 35 10 60 80 00    	pushl  0x806010
  8017e5:	68 00 60 80 00       	push   $0x806000
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	e8 fe f0 ff ff       	call   8008f0 <memmove>
		*addrlen = ret->ret_addrlen;
  8017f2:	a1 10 60 80 00       	mov    0x806010,%eax
  8017f7:	89 06                	mov    %eax,(%esi)
  8017f9:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8017fc:	89 d8                	mov    %ebx,%eax
  8017fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801817:	53                   	push   %ebx
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	68 04 60 80 00       	push   $0x806004
  801820:	e8 cb f0 ff ff       	call   8008f0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801825:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80182b:	b8 02 00 00 00       	mov    $0x2,%eax
  801830:	e8 34 ff ff ff       	call   801769 <nsipc>
}
  801835:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801850:	b8 03 00 00 00       	mov    $0x3,%eax
  801855:	e8 0f ff ff ff       	call   801769 <nsipc>
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <nsipc_close>:

int
nsipc_close(int s)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80186a:	b8 04 00 00 00       	mov    $0x4,%eax
  80186f:	e8 f5 fe ff ff       	call   801769 <nsipc>
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	53                   	push   %ebx
  80187a:	83 ec 08             	sub    $0x8,%esp
  80187d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801888:	53                   	push   %ebx
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	68 04 60 80 00       	push   $0x806004
  801891:	e8 5a f0 ff ff       	call   8008f0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801896:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  80189c:	b8 05 00 00 00       	mov    $0x5,%eax
  8018a1:	e8 c3 fe ff ff       	call   801769 <nsipc>
}
  8018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8018b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8018c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8018c6:	e8 9e fe ff ff       	call   801769 <nsipc>
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8018dd:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8018e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8018eb:	b8 07 00 00 00       	mov    $0x7,%eax
  8018f0:	e8 74 fe ff ff       	call   801769 <nsipc>
  8018f5:	89 c3                	mov    %eax,%ebx
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 1f                	js     80191a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8018fb:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801900:	7f 21                	jg     801923 <nsipc_recv+0x56>
  801902:	39 c6                	cmp    %eax,%esi
  801904:	7c 1d                	jl     801923 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	50                   	push   %eax
  80190a:	68 00 60 80 00       	push   $0x806000
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	e8 d9 ef ff ff       	call   8008f0 <memmove>
  801917:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80191a:	89 d8                	mov    %ebx,%eax
  80191c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80191f:	5b                   	pop    %ebx
  801920:	5e                   	pop    %esi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801923:	68 5b 26 80 00       	push   $0x80265b
  801928:	68 23 26 80 00       	push   $0x802623
  80192d:	6a 62                	push   $0x62
  80192f:	68 70 26 80 00       	push   $0x802670
  801934:	e8 52 05 00 00       	call   801e8b <_panic>

00801939 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	53                   	push   %ebx
  80193d:	83 ec 04             	sub    $0x4,%esp
  801940:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80194b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801951:	7f 2e                	jg     801981 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801953:	83 ec 04             	sub    $0x4,%esp
  801956:	53                   	push   %ebx
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	68 0c 60 80 00       	push   $0x80600c
  80195f:	e8 8c ef ff ff       	call   8008f0 <memmove>
	nsipcbuf.send.req_size = size;
  801964:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801972:	b8 08 00 00 00       	mov    $0x8,%eax
  801977:	e8 ed fd ff ff       	call   801769 <nsipc>
}
  80197c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197f:	c9                   	leave  
  801980:	c3                   	ret    
	assert(size < 1600);
  801981:	68 7c 26 80 00       	push   $0x80267c
  801986:	68 23 26 80 00       	push   $0x802623
  80198b:	6a 6d                	push   $0x6d
  80198d:	68 70 26 80 00       	push   $0x802670
  801992:	e8 f4 04 00 00       	call   801e8b <_panic>

00801997 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8019ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8019b5:	b8 09 00 00 00       	mov    $0x9,%eax
  8019ba:	e8 aa fd ff ff       	call   801769 <nsipc>
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	56                   	push   %esi
  8019c5:	53                   	push   %ebx
  8019c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019c9:	83 ec 0c             	sub    $0xc,%esp
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	e8 a7 f3 ff ff       	call   800d7b <fd2data>
  8019d4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019d6:	83 c4 08             	add    $0x8,%esp
  8019d9:	68 88 26 80 00       	push   $0x802688
  8019de:	53                   	push   %ebx
  8019df:	e8 7e ed ff ff       	call   800762 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019e4:	8b 46 04             	mov    0x4(%esi),%eax
  8019e7:	2b 06                	sub    (%esi),%eax
  8019e9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019f6:	00 00 00 
	stat->st_dev = &devpipe;
  8019f9:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a00:	30 80 00 
	return 0;
}
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
  801a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    

00801a0f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	53                   	push   %ebx
  801a13:	83 ec 0c             	sub    $0xc,%esp
  801a16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a19:	53                   	push   %ebx
  801a1a:	6a 00                	push   $0x0
  801a1c:	e8 bf f1 ff ff       	call   800be0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a21:	89 1c 24             	mov    %ebx,(%esp)
  801a24:	e8 52 f3 ff ff       	call   800d7b <fd2data>
  801a29:	83 c4 08             	add    $0x8,%esp
  801a2c:	50                   	push   %eax
  801a2d:	6a 00                	push   $0x0
  801a2f:	e8 ac f1 ff ff       	call   800be0 <sys_page_unmap>
}
  801a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <_pipeisclosed>:
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	57                   	push   %edi
  801a3d:	56                   	push   %esi
  801a3e:	53                   	push   %ebx
  801a3f:	83 ec 1c             	sub    $0x1c,%esp
  801a42:	89 c7                	mov    %eax,%edi
  801a44:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a46:	a1 08 40 80 00       	mov    0x804008,%eax
  801a4b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a4e:	83 ec 0c             	sub    $0xc,%esp
  801a51:	57                   	push   %edi
  801a52:	e8 6e 05 00 00       	call   801fc5 <pageref>
  801a57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a5a:	89 34 24             	mov    %esi,(%esp)
  801a5d:	e8 63 05 00 00       	call   801fc5 <pageref>
		nn = thisenv->env_runs;
  801a62:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a68:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	39 cb                	cmp    %ecx,%ebx
  801a70:	74 1b                	je     801a8d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a72:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a75:	75 cf                	jne    801a46 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a77:	8b 42 58             	mov    0x58(%edx),%eax
  801a7a:	6a 01                	push   $0x1
  801a7c:	50                   	push   %eax
  801a7d:	53                   	push   %ebx
  801a7e:	68 8f 26 80 00       	push   $0x80268f
  801a83:	e8 bb e6 ff ff       	call   800143 <cprintf>
  801a88:	83 c4 10             	add    $0x10,%esp
  801a8b:	eb b9                	jmp    801a46 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a8d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a90:	0f 94 c0             	sete   %al
  801a93:	0f b6 c0             	movzbl %al,%eax
}
  801a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5e                   	pop    %esi
  801a9b:	5f                   	pop    %edi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <devpipe_write>:
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 28             	sub    $0x28,%esp
  801aa7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801aaa:	56                   	push   %esi
  801aab:	e8 cb f2 ff ff       	call   800d7b <fd2data>
  801ab0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ab2:	83 c4 10             	add    $0x10,%esp
  801ab5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aba:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801abd:	74 4f                	je     801b0e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801abf:	8b 43 04             	mov    0x4(%ebx),%eax
  801ac2:	8b 0b                	mov    (%ebx),%ecx
  801ac4:	8d 51 20             	lea    0x20(%ecx),%edx
  801ac7:	39 d0                	cmp    %edx,%eax
  801ac9:	72 14                	jb     801adf <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801acb:	89 da                	mov    %ebx,%edx
  801acd:	89 f0                	mov    %esi,%eax
  801acf:	e8 65 ff ff ff       	call   801a39 <_pipeisclosed>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	75 3a                	jne    801b12 <devpipe_write+0x74>
			sys_yield();
  801ad8:	e8 5f f0 ff ff       	call   800b3c <sys_yield>
  801add:	eb e0                	jmp    801abf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ae2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ae6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ae9:	89 c2                	mov    %eax,%edx
  801aeb:	c1 fa 1f             	sar    $0x1f,%edx
  801aee:	89 d1                	mov    %edx,%ecx
  801af0:	c1 e9 1b             	shr    $0x1b,%ecx
  801af3:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801af6:	83 e2 1f             	and    $0x1f,%edx
  801af9:	29 ca                	sub    %ecx,%edx
  801afb:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801aff:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b03:	83 c0 01             	add    $0x1,%eax
  801b06:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b09:	83 c7 01             	add    $0x1,%edi
  801b0c:	eb ac                	jmp    801aba <devpipe_write+0x1c>
	return i;
  801b0e:	89 f8                	mov    %edi,%eax
  801b10:	eb 05                	jmp    801b17 <devpipe_write+0x79>
				return 0;
  801b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5f                   	pop    %edi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <devpipe_read>:
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	57                   	push   %edi
  801b23:	56                   	push   %esi
  801b24:	53                   	push   %ebx
  801b25:	83 ec 18             	sub    $0x18,%esp
  801b28:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b2b:	57                   	push   %edi
  801b2c:	e8 4a f2 ff ff       	call   800d7b <fd2data>
  801b31:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	be 00 00 00 00       	mov    $0x0,%esi
  801b3b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b3e:	74 47                	je     801b87 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b40:	8b 03                	mov    (%ebx),%eax
  801b42:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b45:	75 22                	jne    801b69 <devpipe_read+0x4a>
			if (i > 0)
  801b47:	85 f6                	test   %esi,%esi
  801b49:	75 14                	jne    801b5f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b4b:	89 da                	mov    %ebx,%edx
  801b4d:	89 f8                	mov    %edi,%eax
  801b4f:	e8 e5 fe ff ff       	call   801a39 <_pipeisclosed>
  801b54:	85 c0                	test   %eax,%eax
  801b56:	75 33                	jne    801b8b <devpipe_read+0x6c>
			sys_yield();
  801b58:	e8 df ef ff ff       	call   800b3c <sys_yield>
  801b5d:	eb e1                	jmp    801b40 <devpipe_read+0x21>
				return i;
  801b5f:	89 f0                	mov    %esi,%eax
}
  801b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b64:	5b                   	pop    %ebx
  801b65:	5e                   	pop    %esi
  801b66:	5f                   	pop    %edi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b69:	99                   	cltd   
  801b6a:	c1 ea 1b             	shr    $0x1b,%edx
  801b6d:	01 d0                	add    %edx,%eax
  801b6f:	83 e0 1f             	and    $0x1f,%eax
  801b72:	29 d0                	sub    %edx,%eax
  801b74:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b7c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b7f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b82:	83 c6 01             	add    $0x1,%esi
  801b85:	eb b4                	jmp    801b3b <devpipe_read+0x1c>
	return i;
  801b87:	89 f0                	mov    %esi,%eax
  801b89:	eb d6                	jmp    801b61 <devpipe_read+0x42>
				return 0;
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	eb cf                	jmp    801b61 <devpipe_read+0x42>

00801b92 <pipe>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	56                   	push   %esi
  801b96:	53                   	push   %ebx
  801b97:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b9d:	50                   	push   %eax
  801b9e:	e8 ef f1 ff ff       	call   800d92 <fd_alloc>
  801ba3:	89 c3                	mov    %eax,%ebx
  801ba5:	83 c4 10             	add    $0x10,%esp
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	78 5b                	js     801c07 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bac:	83 ec 04             	sub    $0x4,%esp
  801baf:	68 07 04 00 00       	push   $0x407
  801bb4:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb7:	6a 00                	push   $0x0
  801bb9:	e8 9d ef ff ff       	call   800b5b <sys_page_alloc>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	85 c0                	test   %eax,%eax
  801bc5:	78 40                	js     801c07 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bcd:	50                   	push   %eax
  801bce:	e8 bf f1 ff ff       	call   800d92 <fd_alloc>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 1b                	js     801bf7 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bdc:	83 ec 04             	sub    $0x4,%esp
  801bdf:	68 07 04 00 00       	push   $0x407
  801be4:	ff 75 f0             	pushl  -0x10(%ebp)
  801be7:	6a 00                	push   $0x0
  801be9:	e8 6d ef ff ff       	call   800b5b <sys_page_alloc>
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	79 19                	jns    801c10 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801bf7:	83 ec 08             	sub    $0x8,%esp
  801bfa:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 dc ef ff ff       	call   800be0 <sys_page_unmap>
  801c04:	83 c4 10             	add    $0x10,%esp
}
  801c07:	89 d8                	mov    %ebx,%eax
  801c09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c0c:	5b                   	pop    %ebx
  801c0d:	5e                   	pop    %esi
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    
	va = fd2data(fd0);
  801c10:	83 ec 0c             	sub    $0xc,%esp
  801c13:	ff 75 f4             	pushl  -0xc(%ebp)
  801c16:	e8 60 f1 ff ff       	call   800d7b <fd2data>
  801c1b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c1d:	83 c4 0c             	add    $0xc,%esp
  801c20:	68 07 04 00 00       	push   $0x407
  801c25:	50                   	push   %eax
  801c26:	6a 00                	push   $0x0
  801c28:	e8 2e ef ff ff       	call   800b5b <sys_page_alloc>
  801c2d:	89 c3                	mov    %eax,%ebx
  801c2f:	83 c4 10             	add    $0x10,%esp
  801c32:	85 c0                	test   %eax,%eax
  801c34:	0f 88 8c 00 00 00    	js     801cc6 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c40:	e8 36 f1 ff ff       	call   800d7b <fd2data>
  801c45:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c4c:	50                   	push   %eax
  801c4d:	6a 00                	push   $0x0
  801c4f:	56                   	push   %esi
  801c50:	6a 00                	push   $0x0
  801c52:	e8 47 ef ff ff       	call   800b9e <sys_page_map>
  801c57:	89 c3                	mov    %eax,%ebx
  801c59:	83 c4 20             	add    $0x20,%esp
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	78 58                	js     801cb8 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c69:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c78:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c7e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c83:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c90:	e8 d6 f0 ff ff       	call   800d6b <fd2num>
  801c95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c98:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c9a:	83 c4 04             	add    $0x4,%esp
  801c9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca0:	e8 c6 f0 ff ff       	call   800d6b <fd2num>
  801ca5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cab:	83 c4 10             	add    $0x10,%esp
  801cae:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb3:	e9 4f ff ff ff       	jmp    801c07 <pipe+0x75>
	sys_page_unmap(0, va);
  801cb8:	83 ec 08             	sub    $0x8,%esp
  801cbb:	56                   	push   %esi
  801cbc:	6a 00                	push   $0x0
  801cbe:	e8 1d ef ff ff       	call   800be0 <sys_page_unmap>
  801cc3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cc6:	83 ec 08             	sub    $0x8,%esp
  801cc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801ccc:	6a 00                	push   $0x0
  801cce:	e8 0d ef ff ff       	call   800be0 <sys_page_unmap>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	e9 1c ff ff ff       	jmp    801bf7 <pipe+0x65>

00801cdb <pipeisclosed>:
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce4:	50                   	push   %eax
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	e8 f4 f0 ff ff       	call   800de1 <fd_lookup>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 18                	js     801d0c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801cf4:	83 ec 0c             	sub    $0xc,%esp
  801cf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfa:	e8 7c f0 ff ff       	call   800d7b <fd2data>
	return _pipeisclosed(fd, p);
  801cff:	89 c2                	mov    %eax,%edx
  801d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d04:	e8 30 fd ff ff       	call   801a39 <_pipeisclosed>
  801d09:	83 c4 10             	add    $0x10,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    

00801d18 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d1e:	68 a7 26 80 00       	push   $0x8026a7
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	e8 37 ea ff ff       	call   800762 <strcpy>
	return 0;
}
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <devcons_write>:
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	57                   	push   %edi
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d3e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d43:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d49:	eb 2f                	jmp    801d7a <devcons_write+0x48>
		m = n - tot;
  801d4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d4e:	29 f3                	sub    %esi,%ebx
  801d50:	83 fb 7f             	cmp    $0x7f,%ebx
  801d53:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d58:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d5b:	83 ec 04             	sub    $0x4,%esp
  801d5e:	53                   	push   %ebx
  801d5f:	89 f0                	mov    %esi,%eax
  801d61:	03 45 0c             	add    0xc(%ebp),%eax
  801d64:	50                   	push   %eax
  801d65:	57                   	push   %edi
  801d66:	e8 85 eb ff ff       	call   8008f0 <memmove>
		sys_cputs(buf, m);
  801d6b:	83 c4 08             	add    $0x8,%esp
  801d6e:	53                   	push   %ebx
  801d6f:	57                   	push   %edi
  801d70:	e8 2a ed ff ff       	call   800a9f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d75:	01 de                	add    %ebx,%esi
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d7d:	72 cc                	jb     801d4b <devcons_write+0x19>
}
  801d7f:	89 f0                	mov    %esi,%eax
  801d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5f                   	pop    %edi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <devcons_read>:
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 08             	sub    $0x8,%esp
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801d94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d98:	75 07                	jne    801da1 <devcons_read+0x18>
}
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    
		sys_yield();
  801d9c:	e8 9b ed ff ff       	call   800b3c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801da1:	e8 17 ed ff ff       	call   800abd <sys_cgetc>
  801da6:	85 c0                	test   %eax,%eax
  801da8:	74 f2                	je     801d9c <devcons_read+0x13>
	if (c < 0)
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 ec                	js     801d9a <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801dae:	83 f8 04             	cmp    $0x4,%eax
  801db1:	74 0c                	je     801dbf <devcons_read+0x36>
	*(char*)vbuf = c;
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	88 02                	mov    %al,(%edx)
	return 1;
  801db8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbd:	eb db                	jmp    801d9a <devcons_read+0x11>
		return 0;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	eb d4                	jmp    801d9a <devcons_read+0x11>

00801dc6 <cputchar>:
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801dd2:	6a 01                	push   $0x1
  801dd4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dd7:	50                   	push   %eax
  801dd8:	e8 c2 ec ff ff       	call   800a9f <sys_cputs>
}
  801ddd:	83 c4 10             	add    $0x10,%esp
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <getchar>:
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
  801de5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801de8:	6a 01                	push   $0x1
  801dea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ded:	50                   	push   %eax
  801dee:	6a 00                	push   $0x0
  801df0:	e8 5d f2 ff ff       	call   801052 <read>
	if (r < 0)
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 08                	js     801e04 <getchar+0x22>
	if (r < 1)
  801dfc:	85 c0                	test   %eax,%eax
  801dfe:	7e 06                	jle    801e06 <getchar+0x24>
	return c;
  801e00:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    
		return -E_EOF;
  801e06:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e0b:	eb f7                	jmp    801e04 <getchar+0x22>

00801e0d <iscons>:
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e16:	50                   	push   %eax
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	e8 c2 ef ff ff       	call   800de1 <fd_lookup>
  801e1f:	83 c4 10             	add    $0x10,%esp
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 11                	js     801e37 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e2f:	39 10                	cmp    %edx,(%eax)
  801e31:	0f 94 c0             	sete   %al
  801e34:	0f b6 c0             	movzbl %al,%eax
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <opencons>:
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e42:	50                   	push   %eax
  801e43:	e8 4a ef ff ff       	call   800d92 <fd_alloc>
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	85 c0                	test   %eax,%eax
  801e4d:	78 3a                	js     801e89 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	68 07 04 00 00       	push   $0x407
  801e57:	ff 75 f4             	pushl  -0xc(%ebp)
  801e5a:	6a 00                	push   $0x0
  801e5c:	e8 fa ec ff ff       	call   800b5b <sys_page_alloc>
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	85 c0                	test   %eax,%eax
  801e66:	78 21                	js     801e89 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e71:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	50                   	push   %eax
  801e81:	e8 e5 ee ff ff       	call   800d6b <fd2num>
  801e86:	83 c4 10             	add    $0x10,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801e90:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801e93:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801e99:	e8 7f ec ff ff       	call   800b1d <sys_getenvid>
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	ff 75 0c             	pushl  0xc(%ebp)
  801ea4:	ff 75 08             	pushl  0x8(%ebp)
  801ea7:	56                   	push   %esi
  801ea8:	50                   	push   %eax
  801ea9:	68 b4 26 80 00       	push   $0x8026b4
  801eae:	e8 90 e2 ff ff       	call   800143 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801eb3:	83 c4 18             	add    $0x18,%esp
  801eb6:	53                   	push   %ebx
  801eb7:	ff 75 10             	pushl  0x10(%ebp)
  801eba:	e8 33 e2 ff ff       	call   8000f2 <vcprintf>
	cprintf("\n");
  801ebf:	c7 04 24 5c 22 80 00 	movl   $0x80225c,(%esp)
  801ec6:	e8 78 e2 ff ff       	call   800143 <cprintf>
  801ecb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ece:	cc                   	int3   
  801ecf:	eb fd                	jmp    801ece <_panic+0x43>

00801ed1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	8b 75 08             	mov    0x8(%ebp),%esi
  801ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801edf:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ee1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ee6:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	50                   	push   %eax
  801eed:	e8 19 ee ff ff       	call   800d0b <sys_ipc_recv>
	if (from_env_store)
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	85 f6                	test   %esi,%esi
  801ef7:	74 14                	je     801f0d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 09                	js     801f0b <ipc_recv+0x3a>
  801f02:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f08:	8b 52 74             	mov    0x74(%edx),%edx
  801f0b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f0d:	85 db                	test   %ebx,%ebx
  801f0f:	74 14                	je     801f25 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f11:	ba 00 00 00 00       	mov    $0x0,%edx
  801f16:	85 c0                	test   %eax,%eax
  801f18:	78 09                	js     801f23 <ipc_recv+0x52>
  801f1a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f20:	8b 52 78             	mov    0x78(%edx),%edx
  801f23:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f25:	85 c0                	test   %eax,%eax
  801f27:	78 08                	js     801f31 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f29:	a1 08 40 80 00       	mov    0x804008,%eax
  801f2e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f34:	5b                   	pop    %ebx
  801f35:	5e                   	pop    %esi
  801f36:	5d                   	pop    %ebp
  801f37:	c3                   	ret    

00801f38 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
  801f3b:	57                   	push   %edi
  801f3c:	56                   	push   %esi
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 0c             	sub    $0xc,%esp
  801f41:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f44:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f4a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f4c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f51:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f54:	ff 75 14             	pushl  0x14(%ebp)
  801f57:	53                   	push   %ebx
  801f58:	56                   	push   %esi
  801f59:	57                   	push   %edi
  801f5a:	e8 89 ed ff ff       	call   800ce8 <sys_ipc_try_send>
		if (ret == 0)
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	85 c0                	test   %eax,%eax
  801f64:	74 1e                	je     801f84 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f66:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f69:	75 07                	jne    801f72 <ipc_send+0x3a>
			sys_yield();
  801f6b:	e8 cc eb ff ff       	call   800b3c <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f70:	eb e2                	jmp    801f54 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f72:	50                   	push   %eax
  801f73:	68 d8 26 80 00       	push   $0x8026d8
  801f78:	6a 3d                	push   $0x3d
  801f7a:	68 ec 26 80 00       	push   $0x8026ec
  801f7f:	e8 07 ff ff ff       	call   801e8b <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f87:	5b                   	pop    %ebx
  801f88:	5e                   	pop    %esi
  801f89:	5f                   	pop    %edi
  801f8a:	5d                   	pop    %ebp
  801f8b:	c3                   	ret    

00801f8c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f97:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801f9a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fa0:	8b 52 50             	mov    0x50(%edx),%edx
  801fa3:	39 ca                	cmp    %ecx,%edx
  801fa5:	74 11                	je     801fb8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fa7:	83 c0 01             	add    $0x1,%eax
  801faa:	3d 00 04 00 00       	cmp    $0x400,%eax
  801faf:	75 e6                	jne    801f97 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	eb 0b                	jmp    801fc3 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fb8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fbb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fc0:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	c1 e8 16             	shr    $0x16,%eax
  801fd0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fdc:	f6 c1 01             	test   $0x1,%cl
  801fdf:	74 1d                	je     801ffe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801fe1:	c1 ea 0c             	shr    $0xc,%edx
  801fe4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801feb:	f6 c2 01             	test   $0x1,%dl
  801fee:	74 0e                	je     801ffe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ff0:	c1 ea 0c             	shr    $0xc,%edx
  801ff3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ffa:	ef 
  801ffb:	0f b7 c0             	movzwl %ax,%eax
}
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    

00802000 <__udivdi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80200b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80200f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802013:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802017:	85 d2                	test   %edx,%edx
  802019:	75 35                	jne    802050 <__udivdi3+0x50>
  80201b:	39 f3                	cmp    %esi,%ebx
  80201d:	0f 87 bd 00 00 00    	ja     8020e0 <__udivdi3+0xe0>
  802023:	85 db                	test   %ebx,%ebx
  802025:	89 d9                	mov    %ebx,%ecx
  802027:	75 0b                	jne    802034 <__udivdi3+0x34>
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	31 d2                	xor    %edx,%edx
  802030:	f7 f3                	div    %ebx
  802032:	89 c1                	mov    %eax,%ecx
  802034:	31 d2                	xor    %edx,%edx
  802036:	89 f0                	mov    %esi,%eax
  802038:	f7 f1                	div    %ecx
  80203a:	89 c6                	mov    %eax,%esi
  80203c:	89 e8                	mov    %ebp,%eax
  80203e:	89 f7                	mov    %esi,%edi
  802040:	f7 f1                	div    %ecx
  802042:	89 fa                	mov    %edi,%edx
  802044:	83 c4 1c             	add    $0x1c,%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
  80204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802050:	39 f2                	cmp    %esi,%edx
  802052:	77 7c                	ja     8020d0 <__udivdi3+0xd0>
  802054:	0f bd fa             	bsr    %edx,%edi
  802057:	83 f7 1f             	xor    $0x1f,%edi
  80205a:	0f 84 98 00 00 00    	je     8020f8 <__udivdi3+0xf8>
  802060:	89 f9                	mov    %edi,%ecx
  802062:	b8 20 00 00 00       	mov    $0x20,%eax
  802067:	29 f8                	sub    %edi,%eax
  802069:	d3 e2                	shl    %cl,%edx
  80206b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80206f:	89 c1                	mov    %eax,%ecx
  802071:	89 da                	mov    %ebx,%edx
  802073:	d3 ea                	shr    %cl,%edx
  802075:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802079:	09 d1                	or     %edx,%ecx
  80207b:	89 f2                	mov    %esi,%edx
  80207d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802081:	89 f9                	mov    %edi,%ecx
  802083:	d3 e3                	shl    %cl,%ebx
  802085:	89 c1                	mov    %eax,%ecx
  802087:	d3 ea                	shr    %cl,%edx
  802089:	89 f9                	mov    %edi,%ecx
  80208b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80208f:	d3 e6                	shl    %cl,%esi
  802091:	89 eb                	mov    %ebp,%ebx
  802093:	89 c1                	mov    %eax,%ecx
  802095:	d3 eb                	shr    %cl,%ebx
  802097:	09 de                	or     %ebx,%esi
  802099:	89 f0                	mov    %esi,%eax
  80209b:	f7 74 24 08          	divl   0x8(%esp)
  80209f:	89 d6                	mov    %edx,%esi
  8020a1:	89 c3                	mov    %eax,%ebx
  8020a3:	f7 64 24 0c          	mull   0xc(%esp)
  8020a7:	39 d6                	cmp    %edx,%esi
  8020a9:	72 0c                	jb     8020b7 <__udivdi3+0xb7>
  8020ab:	89 f9                	mov    %edi,%ecx
  8020ad:	d3 e5                	shl    %cl,%ebp
  8020af:	39 c5                	cmp    %eax,%ebp
  8020b1:	73 5d                	jae    802110 <__udivdi3+0x110>
  8020b3:	39 d6                	cmp    %edx,%esi
  8020b5:	75 59                	jne    802110 <__udivdi3+0x110>
  8020b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ba:	31 ff                	xor    %edi,%edi
  8020bc:	89 fa                	mov    %edi,%edx
  8020be:	83 c4 1c             	add    $0x1c,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5f                   	pop    %edi
  8020c4:	5d                   	pop    %ebp
  8020c5:	c3                   	ret    
  8020c6:	8d 76 00             	lea    0x0(%esi),%esi
  8020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8020d0:	31 ff                	xor    %edi,%edi
  8020d2:	31 c0                	xor    %eax,%eax
  8020d4:	89 fa                	mov    %edi,%edx
  8020d6:	83 c4 1c             	add    $0x1c,%esp
  8020d9:	5b                   	pop    %ebx
  8020da:	5e                   	pop    %esi
  8020db:	5f                   	pop    %edi
  8020dc:	5d                   	pop    %ebp
  8020dd:	c3                   	ret    
  8020de:	66 90                	xchg   %ax,%ax
  8020e0:	31 ff                	xor    %edi,%edi
  8020e2:	89 e8                	mov    %ebp,%eax
  8020e4:	89 f2                	mov    %esi,%edx
  8020e6:	f7 f3                	div    %ebx
  8020e8:	89 fa                	mov    %edi,%edx
  8020ea:	83 c4 1c             	add    $0x1c,%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5e                   	pop    %esi
  8020ef:	5f                   	pop    %edi
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
  8020f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8020f8:	39 f2                	cmp    %esi,%edx
  8020fa:	72 06                	jb     802102 <__udivdi3+0x102>
  8020fc:	31 c0                	xor    %eax,%eax
  8020fe:	39 eb                	cmp    %ebp,%ebx
  802100:	77 d2                	ja     8020d4 <__udivdi3+0xd4>
  802102:	b8 01 00 00 00       	mov    $0x1,%eax
  802107:	eb cb                	jmp    8020d4 <__udivdi3+0xd4>
  802109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802110:	89 d8                	mov    %ebx,%eax
  802112:	31 ff                	xor    %edi,%edi
  802114:	eb be                	jmp    8020d4 <__udivdi3+0xd4>
  802116:	66 90                	xchg   %ax,%ax
  802118:	66 90                	xchg   %ax,%ax
  80211a:	66 90                	xchg   %ax,%ax
  80211c:	66 90                	xchg   %ax,%ax
  80211e:	66 90                	xchg   %ax,%ax

00802120 <__umoddi3>:
  802120:	55                   	push   %ebp
  802121:	57                   	push   %edi
  802122:	56                   	push   %esi
  802123:	53                   	push   %ebx
  802124:	83 ec 1c             	sub    $0x1c,%esp
  802127:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80212b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80212f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802137:	85 ed                	test   %ebp,%ebp
  802139:	89 f0                	mov    %esi,%eax
  80213b:	89 da                	mov    %ebx,%edx
  80213d:	75 19                	jne    802158 <__umoddi3+0x38>
  80213f:	39 df                	cmp    %ebx,%edi
  802141:	0f 86 b1 00 00 00    	jbe    8021f8 <__umoddi3+0xd8>
  802147:	f7 f7                	div    %edi
  802149:	89 d0                	mov    %edx,%eax
  80214b:	31 d2                	xor    %edx,%edx
  80214d:	83 c4 1c             	add    $0x1c,%esp
  802150:	5b                   	pop    %ebx
  802151:	5e                   	pop    %esi
  802152:	5f                   	pop    %edi
  802153:	5d                   	pop    %ebp
  802154:	c3                   	ret    
  802155:	8d 76 00             	lea    0x0(%esi),%esi
  802158:	39 dd                	cmp    %ebx,%ebp
  80215a:	77 f1                	ja     80214d <__umoddi3+0x2d>
  80215c:	0f bd cd             	bsr    %ebp,%ecx
  80215f:	83 f1 1f             	xor    $0x1f,%ecx
  802162:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802166:	0f 84 b4 00 00 00    	je     802220 <__umoddi3+0x100>
  80216c:	b8 20 00 00 00       	mov    $0x20,%eax
  802171:	89 c2                	mov    %eax,%edx
  802173:	8b 44 24 04          	mov    0x4(%esp),%eax
  802177:	29 c2                	sub    %eax,%edx
  802179:	89 c1                	mov    %eax,%ecx
  80217b:	89 f8                	mov    %edi,%eax
  80217d:	d3 e5                	shl    %cl,%ebp
  80217f:	89 d1                	mov    %edx,%ecx
  802181:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802185:	d3 e8                	shr    %cl,%eax
  802187:	09 c5                	or     %eax,%ebp
  802189:	8b 44 24 04          	mov    0x4(%esp),%eax
  80218d:	89 c1                	mov    %eax,%ecx
  80218f:	d3 e7                	shl    %cl,%edi
  802191:	89 d1                	mov    %edx,%ecx
  802193:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802197:	89 df                	mov    %ebx,%edi
  802199:	d3 ef                	shr    %cl,%edi
  80219b:	89 c1                	mov    %eax,%ecx
  80219d:	89 f0                	mov    %esi,%eax
  80219f:	d3 e3                	shl    %cl,%ebx
  8021a1:	89 d1                	mov    %edx,%ecx
  8021a3:	89 fa                	mov    %edi,%edx
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021ac:	09 d8                	or     %ebx,%eax
  8021ae:	f7 f5                	div    %ebp
  8021b0:	d3 e6                	shl    %cl,%esi
  8021b2:	89 d1                	mov    %edx,%ecx
  8021b4:	f7 64 24 08          	mull   0x8(%esp)
  8021b8:	39 d1                	cmp    %edx,%ecx
  8021ba:	89 c3                	mov    %eax,%ebx
  8021bc:	89 d7                	mov    %edx,%edi
  8021be:	72 06                	jb     8021c6 <__umoddi3+0xa6>
  8021c0:	75 0e                	jne    8021d0 <__umoddi3+0xb0>
  8021c2:	39 c6                	cmp    %eax,%esi
  8021c4:	73 0a                	jae    8021d0 <__umoddi3+0xb0>
  8021c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021ca:	19 ea                	sbb    %ebp,%edx
  8021cc:	89 d7                	mov    %edx,%edi
  8021ce:	89 c3                	mov    %eax,%ebx
  8021d0:	89 ca                	mov    %ecx,%edx
  8021d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8021d7:	29 de                	sub    %ebx,%esi
  8021d9:	19 fa                	sbb    %edi,%edx
  8021db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021df:	89 d0                	mov    %edx,%eax
  8021e1:	d3 e0                	shl    %cl,%eax
  8021e3:	89 d9                	mov    %ebx,%ecx
  8021e5:	d3 ee                	shr    %cl,%esi
  8021e7:	d3 ea                	shr    %cl,%edx
  8021e9:	09 f0                	or     %esi,%eax
  8021eb:	83 c4 1c             	add    $0x1c,%esp
  8021ee:	5b                   	pop    %ebx
  8021ef:	5e                   	pop    %esi
  8021f0:	5f                   	pop    %edi
  8021f1:	5d                   	pop    %ebp
  8021f2:	c3                   	ret    
  8021f3:	90                   	nop
  8021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f8:	85 ff                	test   %edi,%edi
  8021fa:	89 f9                	mov    %edi,%ecx
  8021fc:	75 0b                	jne    802209 <__umoddi3+0xe9>
  8021fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802203:	31 d2                	xor    %edx,%edx
  802205:	f7 f7                	div    %edi
  802207:	89 c1                	mov    %eax,%ecx
  802209:	89 d8                	mov    %ebx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	f7 f1                	div    %ecx
  80220f:	89 f0                	mov    %esi,%eax
  802211:	f7 f1                	div    %ecx
  802213:	e9 31 ff ff ff       	jmp    802149 <__umoddi3+0x29>
  802218:	90                   	nop
  802219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802220:	39 dd                	cmp    %ebx,%ebp
  802222:	72 08                	jb     80222c <__umoddi3+0x10c>
  802224:	39 f7                	cmp    %esi,%edi
  802226:	0f 87 21 ff ff ff    	ja     80214d <__umoddi3+0x2d>
  80222c:	89 da                	mov    %ebx,%edx
  80222e:	89 f0                	mov    %esi,%eax
  802230:	29 f8                	sub    %edi,%eax
  802232:	19 ea                	sbb    %ebp,%edx
  802234:	e9 14 ff ff ff       	jmp    80214d <__umoddi3+0x2d>

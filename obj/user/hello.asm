
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 60 22 80 00       	push   $0x802260
  80003e:	e8 10 01 00 00       	call   800153 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 08 40 80 00       	mov    0x804008,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 6e 22 80 00       	push   $0x80226e
  800054:	e8 fa 00 00 00       	call   800153 <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 bf 0a 00 00       	call   800b2d <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800076:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007b:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800080:	85 db                	test   %ebx,%ebx
  800082:	7e 07                	jle    80008b <libmain+0x2d>
		binaryname = argv[0];
  800084:	8b 06                	mov    (%esi),%eax
  800086:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008b:	83 ec 08             	sub    $0x8,%esp
  80008e:	56                   	push   %esi
  80008f:	53                   	push   %ebx
  800090:	e8 9e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800095:	e8 0a 00 00 00       	call   8000a4 <exit>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a0:	5b                   	pop    %ebx
  8000a1:	5e                   	pop    %esi
  8000a2:	5d                   	pop    %ebp
  8000a3:	c3                   	ret    

008000a4 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000a4:	55                   	push   %ebp
  8000a5:	89 e5                	mov    %esp,%ebp
  8000a7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000aa:	e8 a2 0e 00 00       	call   800f51 <close_all>
	sys_env_destroy(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 33 0a 00 00       	call   800aec <sys_env_destroy>
}
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	c9                   	leave  
  8000bd:	c3                   	ret    

008000be <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	53                   	push   %ebx
  8000c2:	83 ec 04             	sub    $0x4,%esp
  8000c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c8:	8b 13                	mov    (%ebx),%edx
  8000ca:	8d 42 01             	lea    0x1(%edx),%eax
  8000cd:	89 03                	mov    %eax,(%ebx)
  8000cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000db:	74 09                	je     8000e6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000dd:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e6:	83 ec 08             	sub    $0x8,%esp
  8000e9:	68 ff 00 00 00       	push   $0xff
  8000ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f1:	50                   	push   %eax
  8000f2:	e8 b8 09 00 00       	call   800aaf <sys_cputs>
		b->idx = 0;
  8000f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	eb db                	jmp    8000dd <putch+0x1f>

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800112:	00 00 00 
	b.cnt = 0;
  800115:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011f:	ff 75 0c             	pushl  0xc(%ebp)
  800122:	ff 75 08             	pushl  0x8(%ebp)
  800125:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012b:	50                   	push   %eax
  80012c:	68 be 00 80 00       	push   $0x8000be
  800131:	e8 1a 01 00 00       	call   800250 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800136:	83 c4 08             	add    $0x8,%esp
  800139:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80013f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800145:	50                   	push   %eax
  800146:	e8 64 09 00 00       	call   800aaf <sys_cputs>

	return b.cnt;
}
  80014b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800151:	c9                   	leave  
  800152:	c3                   	ret    

00800153 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800159:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015c:	50                   	push   %eax
  80015d:	ff 75 08             	pushl  0x8(%ebp)
  800160:	e8 9d ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	57                   	push   %edi
  80016b:	56                   	push   %esi
  80016c:	53                   	push   %ebx
  80016d:	83 ec 1c             	sub    $0x1c,%esp
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	8b 45 08             	mov    0x8(%ebp),%eax
  800177:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800180:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800183:	bb 00 00 00 00       	mov    $0x0,%ebx
  800188:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80018e:	39 d3                	cmp    %edx,%ebx
  800190:	72 05                	jb     800197 <printnum+0x30>
  800192:	39 45 10             	cmp    %eax,0x10(%ebp)
  800195:	77 7a                	ja     800211 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	ff 75 18             	pushl  0x18(%ebp)
  80019d:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a3:	53                   	push   %ebx
  8001a4:	ff 75 10             	pushl  0x10(%ebp)
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ad:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b6:	e8 55 1e 00 00       	call   802010 <__udivdi3>
  8001bb:	83 c4 18             	add    $0x18,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	89 f2                	mov    %esi,%edx
  8001c2:	89 f8                	mov    %edi,%eax
  8001c4:	e8 9e ff ff ff       	call   800167 <printnum>
  8001c9:	83 c4 20             	add    $0x20,%esp
  8001cc:	eb 13                	jmp    8001e1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	56                   	push   %esi
  8001d2:	ff 75 18             	pushl  0x18(%ebp)
  8001d5:	ff d7                	call   *%edi
  8001d7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001da:	83 eb 01             	sub    $0x1,%ebx
  8001dd:	85 db                	test   %ebx,%ebx
  8001df:	7f ed                	jg     8001ce <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	56                   	push   %esi
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ee:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f1:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f4:	e8 37 1f 00 00       	call   802130 <__umoddi3>
  8001f9:	83 c4 14             	add    $0x14,%esp
  8001fc:	0f be 80 8f 22 80 00 	movsbl 0x80228f(%eax),%eax
  800203:	50                   	push   %eax
  800204:	ff d7                	call   *%edi
}
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5e                   	pop    %esi
  80020e:	5f                   	pop    %edi
  80020f:	5d                   	pop    %ebp
  800210:	c3                   	ret    
  800211:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800214:	eb c4                	jmp    8001da <printnum+0x73>

00800216 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800220:	8b 10                	mov    (%eax),%edx
  800222:	3b 50 04             	cmp    0x4(%eax),%edx
  800225:	73 0a                	jae    800231 <sprintputch+0x1b>
		*b->buf++ = ch;
  800227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022a:	89 08                	mov    %ecx,(%eax)
  80022c:	8b 45 08             	mov    0x8(%ebp),%eax
  80022f:	88 02                	mov    %al,(%edx)
}
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <printfmt>:
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800239:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023c:	50                   	push   %eax
  80023d:	ff 75 10             	pushl  0x10(%ebp)
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 05 00 00 00       	call   800250 <vprintfmt>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <vprintfmt>:
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 2c             	sub    $0x2c,%esp
  800259:	8b 75 08             	mov    0x8(%ebp),%esi
  80025c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80025f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800262:	e9 c1 03 00 00       	jmp    800628 <vprintfmt+0x3d8>
		padc = ' ';
  800267:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800272:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800279:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800280:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800285:	8d 47 01             	lea    0x1(%edi),%eax
  800288:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028b:	0f b6 17             	movzbl (%edi),%edx
  80028e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800291:	3c 55                	cmp    $0x55,%al
  800293:	0f 87 12 04 00 00    	ja     8006ab <vprintfmt+0x45b>
  800299:	0f b6 c0             	movzbl %al,%eax
  80029c:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  8002a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a6:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002aa:	eb d9                	jmp    800285 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002af:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b3:	eb d0                	jmp    800285 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b5:	0f b6 d2             	movzbl %dl,%edx
  8002b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c0:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ca:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002cd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d0:	83 f9 09             	cmp    $0x9,%ecx
  8002d3:	77 55                	ja     80032a <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002d5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002d8:	eb e9                	jmp    8002c3 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002da:	8b 45 14             	mov    0x14(%ebp),%eax
  8002dd:	8b 00                	mov    (%eax),%eax
  8002df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e5:	8d 40 04             	lea    0x4(%eax),%eax
  8002e8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f2:	79 91                	jns    800285 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800301:	eb 82                	jmp    800285 <vprintfmt+0x35>
  800303:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	0f 49 d0             	cmovns %eax,%edx
  800310:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800313:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800316:	e9 6a ff ff ff       	jmp    800285 <vprintfmt+0x35>
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80031e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800325:	e9 5b ff ff ff       	jmp    800285 <vprintfmt+0x35>
  80032a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800330:	eb bc                	jmp    8002ee <vprintfmt+0x9e>
			lflag++;
  800332:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800338:	e9 48 ff ff ff       	jmp    800285 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 78 04             	lea    0x4(%eax),%edi
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	53                   	push   %ebx
  800347:	ff 30                	pushl  (%eax)
  800349:	ff d6                	call   *%esi
			break;
  80034b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800351:	e9 cf 02 00 00       	jmp    800625 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800356:	8b 45 14             	mov    0x14(%ebp),%eax
  800359:	8d 78 04             	lea    0x4(%eax),%edi
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	99                   	cltd   
  80035f:	31 d0                	xor    %edx,%eax
  800361:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800363:	83 f8 0f             	cmp    $0xf,%eax
  800366:	7f 23                	jg     80038b <vprintfmt+0x13b>
  800368:	8b 14 85 40 25 80 00 	mov    0x802540(,%eax,4),%edx
  80036f:	85 d2                	test   %edx,%edx
  800371:	74 18                	je     80038b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800373:	52                   	push   %edx
  800374:	68 75 26 80 00       	push   $0x802675
  800379:	53                   	push   %ebx
  80037a:	56                   	push   %esi
  80037b:	e8 b3 fe ff ff       	call   800233 <printfmt>
  800380:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800383:	89 7d 14             	mov    %edi,0x14(%ebp)
  800386:	e9 9a 02 00 00       	jmp    800625 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80038b:	50                   	push   %eax
  80038c:	68 a7 22 80 00       	push   $0x8022a7
  800391:	53                   	push   %ebx
  800392:	56                   	push   %esi
  800393:	e8 9b fe ff ff       	call   800233 <printfmt>
  800398:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80039e:	e9 82 02 00 00       	jmp    800625 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8003af:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b1:	85 ff                	test   %edi,%edi
  8003b3:	b8 a0 22 80 00       	mov    $0x8022a0,%eax
  8003b8:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bf:	0f 8e bd 00 00 00    	jle    800482 <vprintfmt+0x232>
  8003c5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c9:	75 0e                	jne    8003d9 <vprintfmt+0x189>
  8003cb:	89 75 08             	mov    %esi,0x8(%ebp)
  8003ce:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003d4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d7:	eb 6d                	jmp    800446 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003d9:	83 ec 08             	sub    $0x8,%esp
  8003dc:	ff 75 d0             	pushl  -0x30(%ebp)
  8003df:	57                   	push   %edi
  8003e0:	e8 6e 03 00 00       	call   800753 <strnlen>
  8003e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e8:	29 c1                	sub    %eax,%ecx
  8003ea:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003ed:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003fa:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fc:	eb 0f                	jmp    80040d <vprintfmt+0x1bd>
					putch(padc, putdat);
  8003fe:	83 ec 08             	sub    $0x8,%esp
  800401:	53                   	push   %ebx
  800402:	ff 75 e0             	pushl  -0x20(%ebp)
  800405:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800407:	83 ef 01             	sub    $0x1,%edi
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	85 ff                	test   %edi,%edi
  80040f:	7f ed                	jg     8003fe <vprintfmt+0x1ae>
  800411:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800414:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800417:	85 c9                	test   %ecx,%ecx
  800419:	b8 00 00 00 00       	mov    $0x0,%eax
  80041e:	0f 49 c1             	cmovns %ecx,%eax
  800421:	29 c1                	sub    %eax,%ecx
  800423:	89 75 08             	mov    %esi,0x8(%ebp)
  800426:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800429:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042c:	89 cb                	mov    %ecx,%ebx
  80042e:	eb 16                	jmp    800446 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800430:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800434:	75 31                	jne    800467 <vprintfmt+0x217>
					putch(ch, putdat);
  800436:	83 ec 08             	sub    $0x8,%esp
  800439:	ff 75 0c             	pushl  0xc(%ebp)
  80043c:	50                   	push   %eax
  80043d:	ff 55 08             	call   *0x8(%ebp)
  800440:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800443:	83 eb 01             	sub    $0x1,%ebx
  800446:	83 c7 01             	add    $0x1,%edi
  800449:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044d:	0f be c2             	movsbl %dl,%eax
  800450:	85 c0                	test   %eax,%eax
  800452:	74 59                	je     8004ad <vprintfmt+0x25d>
  800454:	85 f6                	test   %esi,%esi
  800456:	78 d8                	js     800430 <vprintfmt+0x1e0>
  800458:	83 ee 01             	sub    $0x1,%esi
  80045b:	79 d3                	jns    800430 <vprintfmt+0x1e0>
  80045d:	89 df                	mov    %ebx,%edi
  80045f:	8b 75 08             	mov    0x8(%ebp),%esi
  800462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800465:	eb 37                	jmp    80049e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800467:	0f be d2             	movsbl %dl,%edx
  80046a:	83 ea 20             	sub    $0x20,%edx
  80046d:	83 fa 5e             	cmp    $0x5e,%edx
  800470:	76 c4                	jbe    800436 <vprintfmt+0x1e6>
					putch('?', putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	6a 3f                	push   $0x3f
  80047a:	ff 55 08             	call   *0x8(%ebp)
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	eb c1                	jmp    800443 <vprintfmt+0x1f3>
  800482:	89 75 08             	mov    %esi,0x8(%ebp)
  800485:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800488:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048e:	eb b6                	jmp    800446 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800490:	83 ec 08             	sub    $0x8,%esp
  800493:	53                   	push   %ebx
  800494:	6a 20                	push   $0x20
  800496:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800498:	83 ef 01             	sub    $0x1,%edi
  80049b:	83 c4 10             	add    $0x10,%esp
  80049e:	85 ff                	test   %edi,%edi
  8004a0:	7f ee                	jg     800490 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004a8:	e9 78 01 00 00       	jmp    800625 <vprintfmt+0x3d5>
  8004ad:	89 df                	mov    %ebx,%edi
  8004af:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b5:	eb e7                	jmp    80049e <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b7:	83 f9 01             	cmp    $0x1,%ecx
  8004ba:	7e 3f                	jle    8004fb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bf:	8b 50 04             	mov    0x4(%eax),%edx
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8d 40 08             	lea    0x8(%eax),%eax
  8004d0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d7:	79 5c                	jns    800535 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	6a 2d                	push   $0x2d
  8004df:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e7:	f7 da                	neg    %edx
  8004e9:	83 d1 00             	adc    $0x0,%ecx
  8004ec:	f7 d9                	neg    %ecx
  8004ee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f6:	e9 10 01 00 00       	jmp    80060b <vprintfmt+0x3bb>
	else if (lflag)
  8004fb:	85 c9                	test   %ecx,%ecx
  8004fd:	75 1b                	jne    80051a <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800507:	89 c1                	mov    %eax,%ecx
  800509:	c1 f9 1f             	sar    $0x1f,%ecx
  80050c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	8d 40 04             	lea    0x4(%eax),%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
  800518:	eb b9                	jmp    8004d3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80051a:	8b 45 14             	mov    0x14(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800522:	89 c1                	mov    %eax,%ecx
  800524:	c1 f9 1f             	sar    $0x1f,%ecx
  800527:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8d 40 04             	lea    0x4(%eax),%eax
  800530:	89 45 14             	mov    %eax,0x14(%ebp)
  800533:	eb 9e                	jmp    8004d3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800535:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800538:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80053b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800540:	e9 c6 00 00 00       	jmp    80060b <vprintfmt+0x3bb>
	if (lflag >= 2)
  800545:	83 f9 01             	cmp    $0x1,%ecx
  800548:	7e 18                	jle    800562 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	8b 10                	mov    (%eax),%edx
  80054f:	8b 48 04             	mov    0x4(%eax),%ecx
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800558:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055d:	e9 a9 00 00 00       	jmp    80060b <vprintfmt+0x3bb>
	else if (lflag)
  800562:	85 c9                	test   %ecx,%ecx
  800564:	75 1a                	jne    800580 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 10                	mov    (%eax),%edx
  80056b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800570:	8d 40 04             	lea    0x4(%eax),%eax
  800573:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 8b 00 00 00       	jmp    80060b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 10                	mov    (%eax),%edx
  800585:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058a:	8d 40 04             	lea    0x4(%eax),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800590:	b8 0a 00 00 00       	mov    $0xa,%eax
  800595:	eb 74                	jmp    80060b <vprintfmt+0x3bb>
	if (lflag >= 2)
  800597:	83 f9 01             	cmp    $0x1,%ecx
  80059a:	7e 15                	jle    8005b1 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 10                	mov    (%eax),%edx
  8005a1:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a4:	8d 40 08             	lea    0x8(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8005af:	eb 5a                	jmp    80060b <vprintfmt+0x3bb>
	else if (lflag)
  8005b1:	85 c9                	test   %ecx,%ecx
  8005b3:	75 17                	jne    8005cc <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8b 10                	mov    (%eax),%edx
  8005ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bf:	8d 40 04             	lea    0x4(%eax),%eax
  8005c2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c5:	b8 08 00 00 00       	mov    $0x8,%eax
  8005ca:	eb 3f                	jmp    80060b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	8b 10                	mov    (%eax),%edx
  8005d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d6:	8d 40 04             	lea    0x4(%eax),%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8005e1:	eb 28                	jmp    80060b <vprintfmt+0x3bb>
			putch('0', putdat);
  8005e3:	83 ec 08             	sub    $0x8,%esp
  8005e6:	53                   	push   %ebx
  8005e7:	6a 30                	push   $0x30
  8005e9:	ff d6                	call   *%esi
			putch('x', putdat);
  8005eb:	83 c4 08             	add    $0x8,%esp
  8005ee:	53                   	push   %ebx
  8005ef:	6a 78                	push   $0x78
  8005f1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f6:	8b 10                	mov    (%eax),%edx
  8005f8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005fd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800600:	8d 40 04             	lea    0x4(%eax),%eax
  800603:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800606:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800612:	57                   	push   %edi
  800613:	ff 75 e0             	pushl  -0x20(%ebp)
  800616:	50                   	push   %eax
  800617:	51                   	push   %ecx
  800618:	52                   	push   %edx
  800619:	89 da                	mov    %ebx,%edx
  80061b:	89 f0                	mov    %esi,%eax
  80061d:	e8 45 fb ff ff       	call   800167 <printnum>
			break;
  800622:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800625:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800628:	83 c7 01             	add    $0x1,%edi
  80062b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80062f:	83 f8 25             	cmp    $0x25,%eax
  800632:	0f 84 2f fc ff ff    	je     800267 <vprintfmt+0x17>
			if (ch == '\0')
  800638:	85 c0                	test   %eax,%eax
  80063a:	0f 84 8b 00 00 00    	je     8006cb <vprintfmt+0x47b>
			putch(ch, putdat);
  800640:	83 ec 08             	sub    $0x8,%esp
  800643:	53                   	push   %ebx
  800644:	50                   	push   %eax
  800645:	ff d6                	call   *%esi
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	eb dc                	jmp    800628 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80064c:	83 f9 01             	cmp    $0x1,%ecx
  80064f:	7e 15                	jle    800666 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	8b 48 04             	mov    0x4(%eax),%ecx
  800659:	8d 40 08             	lea    0x8(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80065f:	b8 10 00 00 00       	mov    $0x10,%eax
  800664:	eb a5                	jmp    80060b <vprintfmt+0x3bb>
	else if (lflag)
  800666:	85 c9                	test   %ecx,%ecx
  800668:	75 17                	jne    800681 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 10                	mov    (%eax),%edx
  80066f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067a:	b8 10 00 00 00       	mov    $0x10,%eax
  80067f:	eb 8a                	jmp    80060b <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 10                	mov    (%eax),%edx
  800686:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800691:	b8 10 00 00 00       	mov    $0x10,%eax
  800696:	e9 70 ff ff ff       	jmp    80060b <vprintfmt+0x3bb>
			putch(ch, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 25                	push   $0x25
  8006a1:	ff d6                	call   *%esi
			break;
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	e9 7a ff ff ff       	jmp    800625 <vprintfmt+0x3d5>
			putch('%', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 25                	push   $0x25
  8006b1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006b3:	83 c4 10             	add    $0x10,%esp
  8006b6:	89 f8                	mov    %edi,%eax
  8006b8:	eb 03                	jmp    8006bd <vprintfmt+0x46d>
  8006ba:	83 e8 01             	sub    $0x1,%eax
  8006bd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c1:	75 f7                	jne    8006ba <vprintfmt+0x46a>
  8006c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c6:	e9 5a ff ff ff       	jmp    800625 <vprintfmt+0x3d5>
}
  8006cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006ce:	5b                   	pop    %ebx
  8006cf:	5e                   	pop    %esi
  8006d0:	5f                   	pop    %edi
  8006d1:	5d                   	pop    %ebp
  8006d2:	c3                   	ret    

008006d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 18             	sub    $0x18,%esp
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f0:	85 c0                	test   %eax,%eax
  8006f2:	74 26                	je     80071a <vsnprintf+0x47>
  8006f4:	85 d2                	test   %edx,%edx
  8006f6:	7e 22                	jle    80071a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f8:	ff 75 14             	pushl  0x14(%ebp)
  8006fb:	ff 75 10             	pushl  0x10(%ebp)
  8006fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	68 16 02 80 00       	push   $0x800216
  800707:	e8 44 fb ff ff       	call   800250 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800715:	83 c4 10             	add    $0x10,%esp
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    
		return -E_INVAL;
  80071a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80071f:	eb f7                	jmp    800718 <vsnprintf+0x45>

00800721 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
  800724:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800727:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80072a:	50                   	push   %eax
  80072b:	ff 75 10             	pushl  0x10(%ebp)
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	ff 75 08             	pushl  0x8(%ebp)
  800734:	e8 9a ff ff ff       	call   8006d3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800741:	b8 00 00 00 00       	mov    $0x0,%eax
  800746:	eb 03                	jmp    80074b <strlen+0x10>
		n++;
  800748:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80074b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80074f:	75 f7                	jne    800748 <strlen+0xd>
	return n;
}
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800759:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80075c:	b8 00 00 00 00       	mov    $0x0,%eax
  800761:	eb 03                	jmp    800766 <strnlen+0x13>
		n++;
  800763:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800766:	39 d0                	cmp    %edx,%eax
  800768:	74 06                	je     800770 <strnlen+0x1d>
  80076a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80076e:	75 f3                	jne    800763 <strnlen+0x10>
	return n;
}
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	53                   	push   %ebx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80077c:	89 c2                	mov    %eax,%edx
  80077e:	83 c1 01             	add    $0x1,%ecx
  800781:	83 c2 01             	add    $0x1,%edx
  800784:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800788:	88 5a ff             	mov    %bl,-0x1(%edx)
  80078b:	84 db                	test   %bl,%bl
  80078d:	75 ef                	jne    80077e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80078f:	5b                   	pop    %ebx
  800790:	5d                   	pop    %ebp
  800791:	c3                   	ret    

00800792 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	53                   	push   %ebx
  800796:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800799:	53                   	push   %ebx
  80079a:	e8 9c ff ff ff       	call   80073b <strlen>
  80079f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007a2:	ff 75 0c             	pushl  0xc(%ebp)
  8007a5:	01 d8                	add    %ebx,%eax
  8007a7:	50                   	push   %eax
  8007a8:	e8 c5 ff ff ff       	call   800772 <strcpy>
	return dst;
}
  8007ad:	89 d8                	mov    %ebx,%eax
  8007af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    

008007b4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007bf:	89 f3                	mov    %esi,%ebx
  8007c1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c4:	89 f2                	mov    %esi,%edx
  8007c6:	eb 0f                	jmp    8007d7 <strncpy+0x23>
		*dst++ = *src;
  8007c8:	83 c2 01             	add    $0x1,%edx
  8007cb:	0f b6 01             	movzbl (%ecx),%eax
  8007ce:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d1:	80 39 01             	cmpb   $0x1,(%ecx)
  8007d4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007d7:	39 da                	cmp    %ebx,%edx
  8007d9:	75 ed                	jne    8007c8 <strncpy+0x14>
	}
	return ret;
}
  8007db:	89 f0                	mov    %esi,%eax
  8007dd:	5b                   	pop    %ebx
  8007de:	5e                   	pop    %esi
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	56                   	push   %esi
  8007e5:	53                   	push   %ebx
  8007e6:	8b 75 08             	mov    0x8(%ebp),%esi
  8007e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007ef:	89 f0                	mov    %esi,%eax
  8007f1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f5:	85 c9                	test   %ecx,%ecx
  8007f7:	75 0b                	jne    800804 <strlcpy+0x23>
  8007f9:	eb 17                	jmp    800812 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007fb:	83 c2 01             	add    $0x1,%edx
  8007fe:	83 c0 01             	add    $0x1,%eax
  800801:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800804:	39 d8                	cmp    %ebx,%eax
  800806:	74 07                	je     80080f <strlcpy+0x2e>
  800808:	0f b6 0a             	movzbl (%edx),%ecx
  80080b:	84 c9                	test   %cl,%cl
  80080d:	75 ec                	jne    8007fb <strlcpy+0x1a>
		*dst = '\0';
  80080f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800812:	29 f0                	sub    %esi,%eax
}
  800814:	5b                   	pop    %ebx
  800815:	5e                   	pop    %esi
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081e:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800821:	eb 06                	jmp    800829 <strcmp+0x11>
		p++, q++;
  800823:	83 c1 01             	add    $0x1,%ecx
  800826:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800829:	0f b6 01             	movzbl (%ecx),%eax
  80082c:	84 c0                	test   %al,%al
  80082e:	74 04                	je     800834 <strcmp+0x1c>
  800830:	3a 02                	cmp    (%edx),%al
  800832:	74 ef                	je     800823 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	0f b6 12             	movzbl (%edx),%edx
  80083a:	29 d0                	sub    %edx,%eax
}
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 55 0c             	mov    0xc(%ebp),%edx
  800848:	89 c3                	mov    %eax,%ebx
  80084a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80084d:	eb 06                	jmp    800855 <strncmp+0x17>
		n--, p++, q++;
  80084f:	83 c0 01             	add    $0x1,%eax
  800852:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800855:	39 d8                	cmp    %ebx,%eax
  800857:	74 16                	je     80086f <strncmp+0x31>
  800859:	0f b6 08             	movzbl (%eax),%ecx
  80085c:	84 c9                	test   %cl,%cl
  80085e:	74 04                	je     800864 <strncmp+0x26>
  800860:	3a 0a                	cmp    (%edx),%cl
  800862:	74 eb                	je     80084f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800864:	0f b6 00             	movzbl (%eax),%eax
  800867:	0f b6 12             	movzbl (%edx),%edx
  80086a:	29 d0                	sub    %edx,%eax
}
  80086c:	5b                   	pop    %ebx
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    
		return 0;
  80086f:	b8 00 00 00 00       	mov    $0x0,%eax
  800874:	eb f6                	jmp    80086c <strncmp+0x2e>

00800876 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800880:	0f b6 10             	movzbl (%eax),%edx
  800883:	84 d2                	test   %dl,%dl
  800885:	74 09                	je     800890 <strchr+0x1a>
		if (*s == c)
  800887:	38 ca                	cmp    %cl,%dl
  800889:	74 0a                	je     800895 <strchr+0x1f>
	for (; *s; s++)
  80088b:	83 c0 01             	add    $0x1,%eax
  80088e:	eb f0                	jmp    800880 <strchr+0xa>
			return (char *) s;
	return 0;
  800890:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a1:	eb 03                	jmp    8008a6 <strfind+0xf>
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008a9:	38 ca                	cmp    %cl,%dl
  8008ab:	74 04                	je     8008b1 <strfind+0x1a>
  8008ad:	84 d2                	test   %dl,%dl
  8008af:	75 f2                	jne    8008a3 <strfind+0xc>
			break;
	return (char *) s;
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	57                   	push   %edi
  8008b7:	56                   	push   %esi
  8008b8:	53                   	push   %ebx
  8008b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008bf:	85 c9                	test   %ecx,%ecx
  8008c1:	74 13                	je     8008d6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008c3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008c9:	75 05                	jne    8008d0 <memset+0x1d>
  8008cb:	f6 c1 03             	test   $0x3,%cl
  8008ce:	74 0d                	je     8008dd <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d3:	fc                   	cld    
  8008d4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008d6:	89 f8                	mov    %edi,%eax
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5f                   	pop    %edi
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    
		c &= 0xFF;
  8008dd:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008e1:	89 d3                	mov    %edx,%ebx
  8008e3:	c1 e3 08             	shl    $0x8,%ebx
  8008e6:	89 d0                	mov    %edx,%eax
  8008e8:	c1 e0 18             	shl    $0x18,%eax
  8008eb:	89 d6                	mov    %edx,%esi
  8008ed:	c1 e6 10             	shl    $0x10,%esi
  8008f0:	09 f0                	or     %esi,%eax
  8008f2:	09 c2                	or     %eax,%edx
  8008f4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008f6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	fc                   	cld    
  8008fc:	f3 ab                	rep stos %eax,%es:(%edi)
  8008fe:	eb d6                	jmp    8008d6 <memset+0x23>

00800900 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	57                   	push   %edi
  800904:	56                   	push   %esi
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	8b 75 0c             	mov    0xc(%ebp),%esi
  80090b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80090e:	39 c6                	cmp    %eax,%esi
  800910:	73 35                	jae    800947 <memmove+0x47>
  800912:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800915:	39 c2                	cmp    %eax,%edx
  800917:	76 2e                	jbe    800947 <memmove+0x47>
		s += n;
		d += n;
  800919:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80091c:	89 d6                	mov    %edx,%esi
  80091e:	09 fe                	or     %edi,%esi
  800920:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800926:	74 0c                	je     800934 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800928:	83 ef 01             	sub    $0x1,%edi
  80092b:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80092e:	fd                   	std    
  80092f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800931:	fc                   	cld    
  800932:	eb 21                	jmp    800955 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800934:	f6 c1 03             	test   $0x3,%cl
  800937:	75 ef                	jne    800928 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800939:	83 ef 04             	sub    $0x4,%edi
  80093c:	8d 72 fc             	lea    -0x4(%edx),%esi
  80093f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800942:	fd                   	std    
  800943:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800945:	eb ea                	jmp    800931 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800947:	89 f2                	mov    %esi,%edx
  800949:	09 c2                	or     %eax,%edx
  80094b:	f6 c2 03             	test   $0x3,%dl
  80094e:	74 09                	je     800959 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800950:	89 c7                	mov    %eax,%edi
  800952:	fc                   	cld    
  800953:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800955:	5e                   	pop    %esi
  800956:	5f                   	pop    %edi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800959:	f6 c1 03             	test   $0x3,%cl
  80095c:	75 f2                	jne    800950 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80095e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800961:	89 c7                	mov    %eax,%edi
  800963:	fc                   	cld    
  800964:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800966:	eb ed                	jmp    800955 <memmove+0x55>

00800968 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80096b:	ff 75 10             	pushl  0x10(%ebp)
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	ff 75 08             	pushl  0x8(%ebp)
  800974:	e8 87 ff ff ff       	call   800900 <memmove>
}
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	56                   	push   %esi
  80097f:	53                   	push   %ebx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	89 c6                	mov    %eax,%esi
  800988:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80098b:	39 f0                	cmp    %esi,%eax
  80098d:	74 1c                	je     8009ab <memcmp+0x30>
		if (*s1 != *s2)
  80098f:	0f b6 08             	movzbl (%eax),%ecx
  800992:	0f b6 1a             	movzbl (%edx),%ebx
  800995:	38 d9                	cmp    %bl,%cl
  800997:	75 08                	jne    8009a1 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800999:	83 c0 01             	add    $0x1,%eax
  80099c:	83 c2 01             	add    $0x1,%edx
  80099f:	eb ea                	jmp    80098b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009a1:	0f b6 c1             	movzbl %cl,%eax
  8009a4:	0f b6 db             	movzbl %bl,%ebx
  8009a7:	29 d8                	sub    %ebx,%eax
  8009a9:	eb 05                	jmp    8009b0 <memcmp+0x35>
	}

	return 0;
  8009ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009bd:	89 c2                	mov    %eax,%edx
  8009bf:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009c2:	39 d0                	cmp    %edx,%eax
  8009c4:	73 09                	jae    8009cf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c6:	38 08                	cmp    %cl,(%eax)
  8009c8:	74 05                	je     8009cf <memfind+0x1b>
	for (; s < ends; s++)
  8009ca:	83 c0 01             	add    $0x1,%eax
  8009cd:	eb f3                	jmp    8009c2 <memfind+0xe>
			break;
	return (void *) s;
}
  8009cf:	5d                   	pop    %ebp
  8009d0:	c3                   	ret    

008009d1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	57                   	push   %edi
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009da:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009dd:	eb 03                	jmp    8009e2 <strtol+0x11>
		s++;
  8009df:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009e2:	0f b6 01             	movzbl (%ecx),%eax
  8009e5:	3c 20                	cmp    $0x20,%al
  8009e7:	74 f6                	je     8009df <strtol+0xe>
  8009e9:	3c 09                	cmp    $0x9,%al
  8009eb:	74 f2                	je     8009df <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009ed:	3c 2b                	cmp    $0x2b,%al
  8009ef:	74 2e                	je     800a1f <strtol+0x4e>
	int neg = 0;
  8009f1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009f6:	3c 2d                	cmp    $0x2d,%al
  8009f8:	74 2f                	je     800a29 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009fa:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a00:	75 05                	jne    800a07 <strtol+0x36>
  800a02:	80 39 30             	cmpb   $0x30,(%ecx)
  800a05:	74 2c                	je     800a33 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a07:	85 db                	test   %ebx,%ebx
  800a09:	75 0a                	jne    800a15 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a0b:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a10:	80 39 30             	cmpb   $0x30,(%ecx)
  800a13:	74 28                	je     800a3d <strtol+0x6c>
		base = 10;
  800a15:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1a:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a1d:	eb 50                	jmp    800a6f <strtol+0x9e>
		s++;
  800a1f:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a22:	bf 00 00 00 00       	mov    $0x0,%edi
  800a27:	eb d1                	jmp    8009fa <strtol+0x29>
		s++, neg = 1;
  800a29:	83 c1 01             	add    $0x1,%ecx
  800a2c:	bf 01 00 00 00       	mov    $0x1,%edi
  800a31:	eb c7                	jmp    8009fa <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a33:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a37:	74 0e                	je     800a47 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a39:	85 db                	test   %ebx,%ebx
  800a3b:	75 d8                	jne    800a15 <strtol+0x44>
		s++, base = 8;
  800a3d:	83 c1 01             	add    $0x1,%ecx
  800a40:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a45:	eb ce                	jmp    800a15 <strtol+0x44>
		s += 2, base = 16;
  800a47:	83 c1 02             	add    $0x2,%ecx
  800a4a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a4f:	eb c4                	jmp    800a15 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a51:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a54:	89 f3                	mov    %esi,%ebx
  800a56:	80 fb 19             	cmp    $0x19,%bl
  800a59:	77 29                	ja     800a84 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a5b:	0f be d2             	movsbl %dl,%edx
  800a5e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a61:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a64:	7d 30                	jge    800a96 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a66:	83 c1 01             	add    $0x1,%ecx
  800a69:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a6d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a6f:	0f b6 11             	movzbl (%ecx),%edx
  800a72:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a75:	89 f3                	mov    %esi,%ebx
  800a77:	80 fb 09             	cmp    $0x9,%bl
  800a7a:	77 d5                	ja     800a51 <strtol+0x80>
			dig = *s - '0';
  800a7c:	0f be d2             	movsbl %dl,%edx
  800a7f:	83 ea 30             	sub    $0x30,%edx
  800a82:	eb dd                	jmp    800a61 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a84:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a87:	89 f3                	mov    %esi,%ebx
  800a89:	80 fb 19             	cmp    $0x19,%bl
  800a8c:	77 08                	ja     800a96 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a8e:	0f be d2             	movsbl %dl,%edx
  800a91:	83 ea 37             	sub    $0x37,%edx
  800a94:	eb cb                	jmp    800a61 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9a:	74 05                	je     800aa1 <strtol+0xd0>
		*endptr = (char *) s;
  800a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	f7 da                	neg    %edx
  800aa5:	85 ff                	test   %edi,%edi
  800aa7:	0f 45 c2             	cmovne %edx,%eax
}
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5f                   	pop    %edi
  800aad:	5d                   	pop    %ebp
  800aae:	c3                   	ret    

00800aaf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800aaf:	55                   	push   %ebp
  800ab0:	89 e5                	mov    %esp,%ebp
  800ab2:	57                   	push   %edi
  800ab3:	56                   	push   %esi
  800ab4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aba:	8b 55 08             	mov    0x8(%ebp),%edx
  800abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac0:	89 c3                	mov    %eax,%ebx
  800ac2:	89 c7                	mov    %eax,%edi
  800ac4:	89 c6                	mov    %eax,%esi
  800ac6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ac8:	5b                   	pop    %ebx
  800ac9:	5e                   	pop    %esi
  800aca:	5f                   	pop    %edi
  800acb:	5d                   	pop    %ebp
  800acc:	c3                   	ret    

00800acd <sys_cgetc>:

int
sys_cgetc(void)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	57                   	push   %edi
  800ad1:	56                   	push   %esi
  800ad2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  800add:	89 d1                	mov    %edx,%ecx
  800adf:	89 d3                	mov    %edx,%ebx
  800ae1:	89 d7                	mov    %edx,%edi
  800ae3:	89 d6                	mov    %edx,%esi
  800ae5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800af5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afa:	8b 55 08             	mov    0x8(%ebp),%edx
  800afd:	b8 03 00 00 00       	mov    $0x3,%eax
  800b02:	89 cb                	mov    %ecx,%ebx
  800b04:	89 cf                	mov    %ecx,%edi
  800b06:	89 ce                	mov    %ecx,%esi
  800b08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b0a:	85 c0                	test   %eax,%eax
  800b0c:	7f 08                	jg     800b16 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b16:	83 ec 0c             	sub    $0xc,%esp
  800b19:	50                   	push   %eax
  800b1a:	6a 03                	push   $0x3
  800b1c:	68 9f 25 80 00       	push   $0x80259f
  800b21:	6a 23                	push   $0x23
  800b23:	68 bc 25 80 00       	push   $0x8025bc
  800b28:	e8 6e 13 00 00       	call   801e9b <_panic>

00800b2d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b33:	ba 00 00 00 00       	mov    $0x0,%edx
  800b38:	b8 02 00 00 00       	mov    $0x2,%eax
  800b3d:	89 d1                	mov    %edx,%ecx
  800b3f:	89 d3                	mov    %edx,%ebx
  800b41:	89 d7                	mov    %edx,%edi
  800b43:	89 d6                	mov    %edx,%esi
  800b45:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <sys_yield>:

void
sys_yield(void)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b5c:	89 d1                	mov    %edx,%ecx
  800b5e:	89 d3                	mov    %edx,%ebx
  800b60:	89 d7                	mov    %edx,%edi
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b66:	5b                   	pop    %ebx
  800b67:	5e                   	pop    %esi
  800b68:	5f                   	pop    %edi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b74:	be 00 00 00 00       	mov    $0x0,%esi
  800b79:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7f:	b8 04 00 00 00       	mov    $0x4,%eax
  800b84:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b87:	89 f7                	mov    %esi,%edi
  800b89:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8b:	85 c0                	test   %eax,%eax
  800b8d:	7f 08                	jg     800b97 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5f                   	pop    %edi
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b97:	83 ec 0c             	sub    $0xc,%esp
  800b9a:	50                   	push   %eax
  800b9b:	6a 04                	push   $0x4
  800b9d:	68 9f 25 80 00       	push   $0x80259f
  800ba2:	6a 23                	push   $0x23
  800ba4:	68 bc 25 80 00       	push   $0x8025bc
  800ba9:	e8 ed 12 00 00       	call   801e9b <_panic>

00800bae <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
  800bb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbd:	b8 05 00 00 00       	mov    $0x5,%eax
  800bc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bc8:	8b 75 18             	mov    0x18(%ebp),%esi
  800bcb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcd:	85 c0                	test   %eax,%eax
  800bcf:	7f 08                	jg     800bd9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5f                   	pop    %edi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd9:	83 ec 0c             	sub    $0xc,%esp
  800bdc:	50                   	push   %eax
  800bdd:	6a 05                	push   $0x5
  800bdf:	68 9f 25 80 00       	push   $0x80259f
  800be4:	6a 23                	push   $0x23
  800be6:	68 bc 25 80 00       	push   $0x8025bc
  800beb:	e8 ab 12 00 00       	call   801e9b <_panic>

00800bf0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c04:	b8 06 00 00 00       	mov    $0x6,%eax
  800c09:	89 df                	mov    %ebx,%edi
  800c0b:	89 de                	mov    %ebx,%esi
  800c0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0f:	85 c0                	test   %eax,%eax
  800c11:	7f 08                	jg     800c1b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c16:	5b                   	pop    %ebx
  800c17:	5e                   	pop    %esi
  800c18:	5f                   	pop    %edi
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1b:	83 ec 0c             	sub    $0xc,%esp
  800c1e:	50                   	push   %eax
  800c1f:	6a 06                	push   $0x6
  800c21:	68 9f 25 80 00       	push   $0x80259f
  800c26:	6a 23                	push   $0x23
  800c28:	68 bc 25 80 00       	push   $0x8025bc
  800c2d:	e8 69 12 00 00       	call   801e9b <_panic>

00800c32 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c46:	b8 08 00 00 00       	mov    $0x8,%eax
  800c4b:	89 df                	mov    %ebx,%edi
  800c4d:	89 de                	mov    %ebx,%esi
  800c4f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	7f 08                	jg     800c5d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c58:	5b                   	pop    %ebx
  800c59:	5e                   	pop    %esi
  800c5a:	5f                   	pop    %edi
  800c5b:	5d                   	pop    %ebp
  800c5c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5d:	83 ec 0c             	sub    $0xc,%esp
  800c60:	50                   	push   %eax
  800c61:	6a 08                	push   $0x8
  800c63:	68 9f 25 80 00       	push   $0x80259f
  800c68:	6a 23                	push   $0x23
  800c6a:	68 bc 25 80 00       	push   $0x8025bc
  800c6f:	e8 27 12 00 00       	call   801e9b <_panic>

00800c74 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c82:	8b 55 08             	mov    0x8(%ebp),%edx
  800c85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c88:	b8 09 00 00 00       	mov    $0x9,%eax
  800c8d:	89 df                	mov    %ebx,%edi
  800c8f:	89 de                	mov    %ebx,%esi
  800c91:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c93:	85 c0                	test   %eax,%eax
  800c95:	7f 08                	jg     800c9f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	50                   	push   %eax
  800ca3:	6a 09                	push   $0x9
  800ca5:	68 9f 25 80 00       	push   $0x80259f
  800caa:	6a 23                	push   $0x23
  800cac:	68 bc 25 80 00       	push   $0x8025bc
  800cb1:	e8 e5 11 00 00       	call   801e9b <_panic>

00800cb6 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
  800cbc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cca:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ccf:	89 df                	mov    %ebx,%edi
  800cd1:	89 de                	mov    %ebx,%esi
  800cd3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd5:	85 c0                	test   %eax,%eax
  800cd7:	7f 08                	jg     800ce1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	5d                   	pop    %ebp
  800ce0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce1:	83 ec 0c             	sub    $0xc,%esp
  800ce4:	50                   	push   %eax
  800ce5:	6a 0a                	push   $0xa
  800ce7:	68 9f 25 80 00       	push   $0x80259f
  800cec:	6a 23                	push   $0x23
  800cee:	68 bc 25 80 00       	push   $0x8025bc
  800cf3:	e8 a3 11 00 00       	call   801e9b <_panic>

00800cf8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	57                   	push   %edi
  800cfc:	56                   	push   %esi
  800cfd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d09:	be 00 00 00 00       	mov    $0x0,%esi
  800d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d11:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d14:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d24:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d31:	89 cb                	mov    %ecx,%ebx
  800d33:	89 cf                	mov    %ecx,%edi
  800d35:	89 ce                	mov    %ecx,%esi
  800d37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	7f 08                	jg     800d45 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	83 ec 0c             	sub    $0xc,%esp
  800d48:	50                   	push   %eax
  800d49:	6a 0d                	push   $0xd
  800d4b:	68 9f 25 80 00       	push   $0x80259f
  800d50:	6a 23                	push   $0x23
  800d52:	68 bc 25 80 00       	push   $0x8025bc
  800d57:	e8 3f 11 00 00       	call   801e9b <_panic>

00800d5c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d62:	ba 00 00 00 00       	mov    $0x0,%edx
  800d67:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d6c:	89 d1                	mov    %edx,%ecx
  800d6e:	89 d3                	mov    %edx,%ebx
  800d70:	89 d7                	mov    %edx,%edi
  800d72:	89 d6                	mov    %edx,%esi
  800d74:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	05 00 00 00 30       	add    $0x30000000,%eax
  800d86:	c1 e8 0c             	shr    $0xc,%eax
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d9b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800da8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dad:	89 c2                	mov    %eax,%edx
  800daf:	c1 ea 16             	shr    $0x16,%edx
  800db2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800db9:	f6 c2 01             	test   $0x1,%dl
  800dbc:	74 2a                	je     800de8 <fd_alloc+0x46>
  800dbe:	89 c2                	mov    %eax,%edx
  800dc0:	c1 ea 0c             	shr    $0xc,%edx
  800dc3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dca:	f6 c2 01             	test   $0x1,%dl
  800dcd:	74 19                	je     800de8 <fd_alloc+0x46>
  800dcf:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dd4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dd9:	75 d2                	jne    800dad <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ddb:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800de1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800de6:	eb 07                	jmp    800def <fd_alloc+0x4d>
			*fd_store = fd;
  800de8:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800df7:	83 f8 1f             	cmp    $0x1f,%eax
  800dfa:	77 36                	ja     800e32 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dfc:	c1 e0 0c             	shl    $0xc,%eax
  800dff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e04:	89 c2                	mov    %eax,%edx
  800e06:	c1 ea 16             	shr    $0x16,%edx
  800e09:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e10:	f6 c2 01             	test   $0x1,%dl
  800e13:	74 24                	je     800e39 <fd_lookup+0x48>
  800e15:	89 c2                	mov    %eax,%edx
  800e17:	c1 ea 0c             	shr    $0xc,%edx
  800e1a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e21:	f6 c2 01             	test   $0x1,%dl
  800e24:	74 1a                	je     800e40 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e29:	89 02                	mov    %eax,(%edx)
	return 0;
  800e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    
		return -E_INVAL;
  800e32:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e37:	eb f7                	jmp    800e30 <fd_lookup+0x3f>
		return -E_INVAL;
  800e39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e3e:	eb f0                	jmp    800e30 <fd_lookup+0x3f>
  800e40:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e45:	eb e9                	jmp    800e30 <fd_lookup+0x3f>

00800e47 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e50:	ba 48 26 80 00       	mov    $0x802648,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e55:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e5a:	39 08                	cmp    %ecx,(%eax)
  800e5c:	74 33                	je     800e91 <dev_lookup+0x4a>
  800e5e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e61:	8b 02                	mov    (%edx),%eax
  800e63:	85 c0                	test   %eax,%eax
  800e65:	75 f3                	jne    800e5a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e67:	a1 08 40 80 00       	mov    0x804008,%eax
  800e6c:	8b 40 48             	mov    0x48(%eax),%eax
  800e6f:	83 ec 04             	sub    $0x4,%esp
  800e72:	51                   	push   %ecx
  800e73:	50                   	push   %eax
  800e74:	68 cc 25 80 00       	push   $0x8025cc
  800e79:	e8 d5 f2 ff ff       	call   800153 <cprintf>
	*dev = 0;
  800e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e87:	83 c4 10             	add    $0x10,%esp
  800e8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e8f:	c9                   	leave  
  800e90:	c3                   	ret    
			*dev = devtab[i];
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e96:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9b:	eb f2                	jmp    800e8f <dev_lookup+0x48>

00800e9d <fd_close>:
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
  800ea3:	83 ec 1c             	sub    $0x1c,%esp
  800ea6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ea9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eaf:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800eb6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eb9:	50                   	push   %eax
  800eba:	e8 32 ff ff ff       	call   800df1 <fd_lookup>
  800ebf:	89 c3                	mov    %eax,%ebx
  800ec1:	83 c4 08             	add    $0x8,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	78 05                	js     800ecd <fd_close+0x30>
	    || fd != fd2)
  800ec8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ecb:	74 16                	je     800ee3 <fd_close+0x46>
		return (must_exist ? r : 0);
  800ecd:	89 f8                	mov    %edi,%eax
  800ecf:	84 c0                	test   %al,%al
  800ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed6:	0f 44 d8             	cmove  %eax,%ebx
}
  800ed9:	89 d8                	mov    %ebx,%eax
  800edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800ee9:	50                   	push   %eax
  800eea:	ff 36                	pushl  (%esi)
  800eec:	e8 56 ff ff ff       	call   800e47 <dev_lookup>
  800ef1:	89 c3                	mov    %eax,%ebx
  800ef3:	83 c4 10             	add    $0x10,%esp
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	78 15                	js     800f0f <fd_close+0x72>
		if (dev->dev_close)
  800efa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800efd:	8b 40 10             	mov    0x10(%eax),%eax
  800f00:	85 c0                	test   %eax,%eax
  800f02:	74 1b                	je     800f1f <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f04:	83 ec 0c             	sub    $0xc,%esp
  800f07:	56                   	push   %esi
  800f08:	ff d0                	call   *%eax
  800f0a:	89 c3                	mov    %eax,%ebx
  800f0c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f0f:	83 ec 08             	sub    $0x8,%esp
  800f12:	56                   	push   %esi
  800f13:	6a 00                	push   $0x0
  800f15:	e8 d6 fc ff ff       	call   800bf0 <sys_page_unmap>
	return r;
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	eb ba                	jmp    800ed9 <fd_close+0x3c>
			r = 0;
  800f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f24:	eb e9                	jmp    800f0f <fd_close+0x72>

00800f26 <close>:

int
close(int fdnum)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f2f:	50                   	push   %eax
  800f30:	ff 75 08             	pushl  0x8(%ebp)
  800f33:	e8 b9 fe ff ff       	call   800df1 <fd_lookup>
  800f38:	83 c4 08             	add    $0x8,%esp
  800f3b:	85 c0                	test   %eax,%eax
  800f3d:	78 10                	js     800f4f <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f3f:	83 ec 08             	sub    $0x8,%esp
  800f42:	6a 01                	push   $0x1
  800f44:	ff 75 f4             	pushl  -0xc(%ebp)
  800f47:	e8 51 ff ff ff       	call   800e9d <fd_close>
  800f4c:	83 c4 10             	add    $0x10,%esp
}
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    

00800f51 <close_all>:

void
close_all(void)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	53                   	push   %ebx
  800f55:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f58:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f5d:	83 ec 0c             	sub    $0xc,%esp
  800f60:	53                   	push   %ebx
  800f61:	e8 c0 ff ff ff       	call   800f26 <close>
	for (i = 0; i < MAXFD; i++)
  800f66:	83 c3 01             	add    $0x1,%ebx
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	83 fb 20             	cmp    $0x20,%ebx
  800f6f:	75 ec                	jne    800f5d <close_all+0xc>
}
  800f71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
  800f7c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f7f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f82:	50                   	push   %eax
  800f83:	ff 75 08             	pushl  0x8(%ebp)
  800f86:	e8 66 fe ff ff       	call   800df1 <fd_lookup>
  800f8b:	89 c3                	mov    %eax,%ebx
  800f8d:	83 c4 08             	add    $0x8,%esp
  800f90:	85 c0                	test   %eax,%eax
  800f92:	0f 88 81 00 00 00    	js     801019 <dup+0xa3>
		return r;
	close(newfdnum);
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	ff 75 0c             	pushl  0xc(%ebp)
  800f9e:	e8 83 ff ff ff       	call   800f26 <close>

	newfd = INDEX2FD(newfdnum);
  800fa3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fa6:	c1 e6 0c             	shl    $0xc,%esi
  800fa9:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800faf:	83 c4 04             	add    $0x4,%esp
  800fb2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fb5:	e8 d1 fd ff ff       	call   800d8b <fd2data>
  800fba:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fbc:	89 34 24             	mov    %esi,(%esp)
  800fbf:	e8 c7 fd ff ff       	call   800d8b <fd2data>
  800fc4:	83 c4 10             	add    $0x10,%esp
  800fc7:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fc9:	89 d8                	mov    %ebx,%eax
  800fcb:	c1 e8 16             	shr    $0x16,%eax
  800fce:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd5:	a8 01                	test   $0x1,%al
  800fd7:	74 11                	je     800fea <dup+0x74>
  800fd9:	89 d8                	mov    %ebx,%eax
  800fdb:	c1 e8 0c             	shr    $0xc,%eax
  800fde:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fe5:	f6 c2 01             	test   $0x1,%dl
  800fe8:	75 39                	jne    801023 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fed:	89 d0                	mov    %edx,%eax
  800fef:	c1 e8 0c             	shr    $0xc,%eax
  800ff2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ff9:	83 ec 0c             	sub    $0xc,%esp
  800ffc:	25 07 0e 00 00       	and    $0xe07,%eax
  801001:	50                   	push   %eax
  801002:	56                   	push   %esi
  801003:	6a 00                	push   $0x0
  801005:	52                   	push   %edx
  801006:	6a 00                	push   $0x0
  801008:	e8 a1 fb ff ff       	call   800bae <sys_page_map>
  80100d:	89 c3                	mov    %eax,%ebx
  80100f:	83 c4 20             	add    $0x20,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 31                	js     801047 <dup+0xd1>
		goto err;

	return newfdnum;
  801016:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801019:	89 d8                	mov    %ebx,%eax
  80101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101e:	5b                   	pop    %ebx
  80101f:	5e                   	pop    %esi
  801020:	5f                   	pop    %edi
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801023:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80102a:	83 ec 0c             	sub    $0xc,%esp
  80102d:	25 07 0e 00 00       	and    $0xe07,%eax
  801032:	50                   	push   %eax
  801033:	57                   	push   %edi
  801034:	6a 00                	push   $0x0
  801036:	53                   	push   %ebx
  801037:	6a 00                	push   $0x0
  801039:	e8 70 fb ff ff       	call   800bae <sys_page_map>
  80103e:	89 c3                	mov    %eax,%ebx
  801040:	83 c4 20             	add    $0x20,%esp
  801043:	85 c0                	test   %eax,%eax
  801045:	79 a3                	jns    800fea <dup+0x74>
	sys_page_unmap(0, newfd);
  801047:	83 ec 08             	sub    $0x8,%esp
  80104a:	56                   	push   %esi
  80104b:	6a 00                	push   $0x0
  80104d:	e8 9e fb ff ff       	call   800bf0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801052:	83 c4 08             	add    $0x8,%esp
  801055:	57                   	push   %edi
  801056:	6a 00                	push   $0x0
  801058:	e8 93 fb ff ff       	call   800bf0 <sys_page_unmap>
	return r;
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	eb b7                	jmp    801019 <dup+0xa3>

00801062 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	53                   	push   %ebx
  801066:	83 ec 14             	sub    $0x14,%esp
  801069:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80106c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80106f:	50                   	push   %eax
  801070:	53                   	push   %ebx
  801071:	e8 7b fd ff ff       	call   800df1 <fd_lookup>
  801076:	83 c4 08             	add    $0x8,%esp
  801079:	85 c0                	test   %eax,%eax
  80107b:	78 3f                	js     8010bc <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801083:	50                   	push   %eax
  801084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801087:	ff 30                	pushl  (%eax)
  801089:	e8 b9 fd ff ff       	call   800e47 <dev_lookup>
  80108e:	83 c4 10             	add    $0x10,%esp
  801091:	85 c0                	test   %eax,%eax
  801093:	78 27                	js     8010bc <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801095:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801098:	8b 42 08             	mov    0x8(%edx),%eax
  80109b:	83 e0 03             	and    $0x3,%eax
  80109e:	83 f8 01             	cmp    $0x1,%eax
  8010a1:	74 1e                	je     8010c1 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a6:	8b 40 08             	mov    0x8(%eax),%eax
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	74 35                	je     8010e2 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010ad:	83 ec 04             	sub    $0x4,%esp
  8010b0:	ff 75 10             	pushl  0x10(%ebp)
  8010b3:	ff 75 0c             	pushl  0xc(%ebp)
  8010b6:	52                   	push   %edx
  8010b7:	ff d0                	call   *%eax
  8010b9:	83 c4 10             	add    $0x10,%esp
}
  8010bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010bf:	c9                   	leave  
  8010c0:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8010c6:	8b 40 48             	mov    0x48(%eax),%eax
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	53                   	push   %ebx
  8010cd:	50                   	push   %eax
  8010ce:	68 0d 26 80 00       	push   $0x80260d
  8010d3:	e8 7b f0 ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e0:	eb da                	jmp    8010bc <read+0x5a>
		return -E_NOT_SUPP;
  8010e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010e7:	eb d3                	jmp    8010bc <read+0x5a>

008010e9 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
  8010ec:	57                   	push   %edi
  8010ed:	56                   	push   %esi
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 0c             	sub    $0xc,%esp
  8010f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010f5:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fd:	39 f3                	cmp    %esi,%ebx
  8010ff:	73 25                	jae    801126 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801101:	83 ec 04             	sub    $0x4,%esp
  801104:	89 f0                	mov    %esi,%eax
  801106:	29 d8                	sub    %ebx,%eax
  801108:	50                   	push   %eax
  801109:	89 d8                	mov    %ebx,%eax
  80110b:	03 45 0c             	add    0xc(%ebp),%eax
  80110e:	50                   	push   %eax
  80110f:	57                   	push   %edi
  801110:	e8 4d ff ff ff       	call   801062 <read>
		if (m < 0)
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	85 c0                	test   %eax,%eax
  80111a:	78 08                	js     801124 <readn+0x3b>
			return m;
		if (m == 0)
  80111c:	85 c0                	test   %eax,%eax
  80111e:	74 06                	je     801126 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801120:	01 c3                	add    %eax,%ebx
  801122:	eb d9                	jmp    8010fd <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801124:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801126:	89 d8                	mov    %ebx,%eax
  801128:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112b:	5b                   	pop    %ebx
  80112c:	5e                   	pop    %esi
  80112d:	5f                   	pop    %edi
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	53                   	push   %ebx
  801134:	83 ec 14             	sub    $0x14,%esp
  801137:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80113a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80113d:	50                   	push   %eax
  80113e:	53                   	push   %ebx
  80113f:	e8 ad fc ff ff       	call   800df1 <fd_lookup>
  801144:	83 c4 08             	add    $0x8,%esp
  801147:	85 c0                	test   %eax,%eax
  801149:	78 3a                	js     801185 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80114b:	83 ec 08             	sub    $0x8,%esp
  80114e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801151:	50                   	push   %eax
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	ff 30                	pushl  (%eax)
  801157:	e8 eb fc ff ff       	call   800e47 <dev_lookup>
  80115c:	83 c4 10             	add    $0x10,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	78 22                	js     801185 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801166:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80116a:	74 1e                	je     80118a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80116c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116f:	8b 52 0c             	mov    0xc(%edx),%edx
  801172:	85 d2                	test   %edx,%edx
  801174:	74 35                	je     8011ab <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801176:	83 ec 04             	sub    $0x4,%esp
  801179:	ff 75 10             	pushl  0x10(%ebp)
  80117c:	ff 75 0c             	pushl  0xc(%ebp)
  80117f:	50                   	push   %eax
  801180:	ff d2                	call   *%edx
  801182:	83 c4 10             	add    $0x10,%esp
}
  801185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801188:	c9                   	leave  
  801189:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80118a:	a1 08 40 80 00       	mov    0x804008,%eax
  80118f:	8b 40 48             	mov    0x48(%eax),%eax
  801192:	83 ec 04             	sub    $0x4,%esp
  801195:	53                   	push   %ebx
  801196:	50                   	push   %eax
  801197:	68 29 26 80 00       	push   $0x802629
  80119c:	e8 b2 ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a9:	eb da                	jmp    801185 <write+0x55>
		return -E_NOT_SUPP;
  8011ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011b0:	eb d3                	jmp    801185 <write+0x55>

008011b2 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
  8011b5:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011b8:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	ff 75 08             	pushl  0x8(%ebp)
  8011bf:	e8 2d fc ff ff       	call   800df1 <fd_lookup>
  8011c4:	83 c4 08             	add    $0x8,%esp
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 0e                	js     8011d9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	53                   	push   %ebx
  8011df:	83 ec 14             	sub    $0x14,%esp
  8011e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e8:	50                   	push   %eax
  8011e9:	53                   	push   %ebx
  8011ea:	e8 02 fc ff ff       	call   800df1 <fd_lookup>
  8011ef:	83 c4 08             	add    $0x8,%esp
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	78 37                	js     80122d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fc:	50                   	push   %eax
  8011fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801200:	ff 30                	pushl  (%eax)
  801202:	e8 40 fc ff ff       	call   800e47 <dev_lookup>
  801207:	83 c4 10             	add    $0x10,%esp
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 1f                	js     80122d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801211:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801215:	74 1b                	je     801232 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121a:	8b 52 18             	mov    0x18(%edx),%edx
  80121d:	85 d2                	test   %edx,%edx
  80121f:	74 32                	je     801253 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	50                   	push   %eax
  801228:	ff d2                	call   *%edx
  80122a:	83 c4 10             	add    $0x10,%esp
}
  80122d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801230:	c9                   	leave  
  801231:	c3                   	ret    
			thisenv->env_id, fdnum);
  801232:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801237:	8b 40 48             	mov    0x48(%eax),%eax
  80123a:	83 ec 04             	sub    $0x4,%esp
  80123d:	53                   	push   %ebx
  80123e:	50                   	push   %eax
  80123f:	68 ec 25 80 00       	push   $0x8025ec
  801244:	e8 0a ef ff ff       	call   800153 <cprintf>
		return -E_INVAL;
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801251:	eb da                	jmp    80122d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801253:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801258:	eb d3                	jmp    80122d <ftruncate+0x52>

0080125a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	53                   	push   %ebx
  80125e:	83 ec 14             	sub    $0x14,%esp
  801261:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801264:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801267:	50                   	push   %eax
  801268:	ff 75 08             	pushl  0x8(%ebp)
  80126b:	e8 81 fb ff ff       	call   800df1 <fd_lookup>
  801270:	83 c4 08             	add    $0x8,%esp
  801273:	85 c0                	test   %eax,%eax
  801275:	78 4b                	js     8012c2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801277:	83 ec 08             	sub    $0x8,%esp
  80127a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127d:	50                   	push   %eax
  80127e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801281:	ff 30                	pushl  (%eax)
  801283:	e8 bf fb ff ff       	call   800e47 <dev_lookup>
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 33                	js     8012c2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80128f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801292:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801296:	74 2f                	je     8012c7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801298:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80129b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012a2:	00 00 00 
	stat->st_isdir = 0;
  8012a5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012ac:	00 00 00 
	stat->st_dev = dev;
  8012af:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012b5:	83 ec 08             	sub    $0x8,%esp
  8012b8:	53                   	push   %ebx
  8012b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8012bc:	ff 50 14             	call   *0x14(%eax)
  8012bf:	83 c4 10             	add    $0x10,%esp
}
  8012c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c5:	c9                   	leave  
  8012c6:	c3                   	ret    
		return -E_NOT_SUPP;
  8012c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012cc:	eb f4                	jmp    8012c2 <fstat+0x68>

008012ce <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	56                   	push   %esi
  8012d2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012d3:	83 ec 08             	sub    $0x8,%esp
  8012d6:	6a 00                	push   $0x0
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 e7 01 00 00       	call   8014c7 <open>
  8012e0:	89 c3                	mov    %eax,%ebx
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	78 1b                	js     801304 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	ff 75 0c             	pushl  0xc(%ebp)
  8012ef:	50                   	push   %eax
  8012f0:	e8 65 ff ff ff       	call   80125a <fstat>
  8012f5:	89 c6                	mov    %eax,%esi
	close(fd);
  8012f7:	89 1c 24             	mov    %ebx,(%esp)
  8012fa:	e8 27 fc ff ff       	call   800f26 <close>
	return r;
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	89 f3                	mov    %esi,%ebx
}
  801304:	89 d8                	mov    %ebx,%eax
  801306:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801309:	5b                   	pop    %ebx
  80130a:	5e                   	pop    %esi
  80130b:	5d                   	pop    %ebp
  80130c:	c3                   	ret    

0080130d <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
  801312:	89 c6                	mov    %eax,%esi
  801314:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801316:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80131d:	74 27                	je     801346 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80131f:	6a 07                	push   $0x7
  801321:	68 00 50 80 00       	push   $0x805000
  801326:	56                   	push   %esi
  801327:	ff 35 00 40 80 00    	pushl  0x804000
  80132d:	e8 16 0c 00 00       	call   801f48 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801332:	83 c4 0c             	add    $0xc,%esp
  801335:	6a 00                	push   $0x0
  801337:	53                   	push   %ebx
  801338:	6a 00                	push   $0x0
  80133a:	e8 a2 0b 00 00       	call   801ee1 <ipc_recv>
}
  80133f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801342:	5b                   	pop    %ebx
  801343:	5e                   	pop    %esi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801346:	83 ec 0c             	sub    $0xc,%esp
  801349:	6a 01                	push   $0x1
  80134b:	e8 4c 0c 00 00       	call   801f9c <ipc_find_env>
  801350:	a3 00 40 80 00       	mov    %eax,0x804000
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	eb c5                	jmp    80131f <fsipc+0x12>

0080135a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	8b 40 0c             	mov    0xc(%eax),%eax
  801366:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801373:	ba 00 00 00 00       	mov    $0x0,%edx
  801378:	b8 02 00 00 00       	mov    $0x2,%eax
  80137d:	e8 8b ff ff ff       	call   80130d <fsipc>
}
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <devfile_flush>:
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8b 40 0c             	mov    0xc(%eax),%eax
  801390:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801395:	ba 00 00 00 00       	mov    $0x0,%edx
  80139a:	b8 06 00 00 00       	mov    $0x6,%eax
  80139f:	e8 69 ff ff ff       	call   80130d <fsipc>
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <devfile_stat>:
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	53                   	push   %ebx
  8013aa:	83 ec 04             	sub    $0x4,%esp
  8013ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b6:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8013c5:	e8 43 ff ff ff       	call   80130d <fsipc>
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	78 2c                	js     8013fa <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	68 00 50 80 00       	push   $0x805000
  8013d6:	53                   	push   %ebx
  8013d7:	e8 96 f3 ff ff       	call   800772 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013dc:	a1 80 50 80 00       	mov    0x805080,%eax
  8013e1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013e7:	a1 84 50 80 00       	mov    0x805084,%eax
  8013ec:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013f2:	83 c4 10             	add    $0x10,%esp
  8013f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <devfile_write>:
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 0c             	sub    $0xc,%esp
  801405:	8b 45 10             	mov    0x10(%ebp),%eax
  801408:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80140d:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801412:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801415:	8b 55 08             	mov    0x8(%ebp),%edx
  801418:	8b 52 0c             	mov    0xc(%edx),%edx
  80141b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801421:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801426:	50                   	push   %eax
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	68 08 50 80 00       	push   $0x805008
  80142f:	e8 cc f4 ff ff       	call   800900 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801434:	ba 00 00 00 00       	mov    $0x0,%edx
  801439:	b8 04 00 00 00       	mov    $0x4,%eax
  80143e:	e8 ca fe ff ff       	call   80130d <fsipc>
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <devfile_read>:
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	56                   	push   %esi
  801449:	53                   	push   %ebx
  80144a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
  801450:	8b 40 0c             	mov    0xc(%eax),%eax
  801453:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801458:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80145e:	ba 00 00 00 00       	mov    $0x0,%edx
  801463:	b8 03 00 00 00       	mov    $0x3,%eax
  801468:	e8 a0 fe ff ff       	call   80130d <fsipc>
  80146d:	89 c3                	mov    %eax,%ebx
  80146f:	85 c0                	test   %eax,%eax
  801471:	78 1f                	js     801492 <devfile_read+0x4d>
	assert(r <= n);
  801473:	39 f0                	cmp    %esi,%eax
  801475:	77 24                	ja     80149b <devfile_read+0x56>
	assert(r <= PGSIZE);
  801477:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80147c:	7f 33                	jg     8014b1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	50                   	push   %eax
  801482:	68 00 50 80 00       	push   $0x805000
  801487:	ff 75 0c             	pushl  0xc(%ebp)
  80148a:	e8 71 f4 ff ff       	call   800900 <memmove>
	return r;
  80148f:	83 c4 10             	add    $0x10,%esp
}
  801492:	89 d8                	mov    %ebx,%eax
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    
	assert(r <= n);
  80149b:	68 5c 26 80 00       	push   $0x80265c
  8014a0:	68 63 26 80 00       	push   $0x802663
  8014a5:	6a 7b                	push   $0x7b
  8014a7:	68 78 26 80 00       	push   $0x802678
  8014ac:	e8 ea 09 00 00       	call   801e9b <_panic>
	assert(r <= PGSIZE);
  8014b1:	68 83 26 80 00       	push   $0x802683
  8014b6:	68 63 26 80 00       	push   $0x802663
  8014bb:	6a 7c                	push   $0x7c
  8014bd:	68 78 26 80 00       	push   $0x802678
  8014c2:	e8 d4 09 00 00       	call   801e9b <_panic>

008014c7 <open>:
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	56                   	push   %esi
  8014cb:	53                   	push   %ebx
  8014cc:	83 ec 1c             	sub    $0x1c,%esp
  8014cf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014d2:	56                   	push   %esi
  8014d3:	e8 63 f2 ff ff       	call   80073b <strlen>
  8014d8:	83 c4 10             	add    $0x10,%esp
  8014db:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014e0:	7f 6c                	jg     80154e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e8:	50                   	push   %eax
  8014e9:	e8 b4 f8 ff ff       	call   800da2 <fd_alloc>
  8014ee:	89 c3                	mov    %eax,%ebx
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 3c                	js     801533 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	56                   	push   %esi
  8014fb:	68 00 50 80 00       	push   $0x805000
  801500:	e8 6d f2 ff ff       	call   800772 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80150d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801510:	b8 01 00 00 00       	mov    $0x1,%eax
  801515:	e8 f3 fd ff ff       	call   80130d <fsipc>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	83 c4 10             	add    $0x10,%esp
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 19                	js     80153c <open+0x75>
	return fd2num(fd);
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	ff 75 f4             	pushl  -0xc(%ebp)
  801529:	e8 4d f8 ff ff       	call   800d7b <fd2num>
  80152e:	89 c3                	mov    %eax,%ebx
  801530:	83 c4 10             	add    $0x10,%esp
}
  801533:	89 d8                	mov    %ebx,%eax
  801535:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    
		fd_close(fd, 0);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	6a 00                	push   $0x0
  801541:	ff 75 f4             	pushl  -0xc(%ebp)
  801544:	e8 54 f9 ff ff       	call   800e9d <fd_close>
		return r;
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	eb e5                	jmp    801533 <open+0x6c>
		return -E_BAD_PATH;
  80154e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801553:	eb de                	jmp    801533 <open+0x6c>

00801555 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	b8 08 00 00 00       	mov    $0x8,%eax
  801565:	e8 a3 fd ff ff       	call   80130d <fsipc>
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801572:	68 8f 26 80 00       	push   $0x80268f
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	e8 f3 f1 ff ff       	call   800772 <strcpy>
	return 0;
}
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <devsock_close>:
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	53                   	push   %ebx
  80158a:	83 ec 10             	sub    $0x10,%esp
  80158d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801590:	53                   	push   %ebx
  801591:	e8 3f 0a 00 00       	call   801fd5 <pageref>
  801596:	83 c4 10             	add    $0x10,%esp
		return 0;
  801599:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80159e:	83 f8 01             	cmp    $0x1,%eax
  8015a1:	74 07                	je     8015aa <devsock_close+0x24>
}
  8015a3:	89 d0                	mov    %edx,%eax
  8015a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	ff 73 0c             	pushl  0xc(%ebx)
  8015b0:	e8 b7 02 00 00       	call   80186c <nsipc_close>
  8015b5:	89 c2                	mov    %eax,%edx
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	eb e7                	jmp    8015a3 <devsock_close+0x1d>

008015bc <devsock_write>:
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	ff 75 10             	pushl  0x10(%ebp)
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	ff 70 0c             	pushl  0xc(%eax)
  8015d0:	e8 74 03 00 00       	call   801949 <nsipc_send>
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <devsock_read>:
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	ff 75 10             	pushl  0x10(%ebp)
  8015e2:	ff 75 0c             	pushl  0xc(%ebp)
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	ff 70 0c             	pushl  0xc(%eax)
  8015eb:	e8 ed 02 00 00       	call   8018dd <nsipc_recv>
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <fd2sockid>:
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8015f8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8015fb:	52                   	push   %edx
  8015fc:	50                   	push   %eax
  8015fd:	e8 ef f7 ff ff       	call   800df1 <fd_lookup>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	85 c0                	test   %eax,%eax
  801607:	78 10                	js     801619 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160c:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801612:	39 08                	cmp    %ecx,(%eax)
  801614:	75 05                	jne    80161b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801616:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    
		return -E_NOT_SUPP;
  80161b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801620:	eb f7                	jmp    801619 <fd2sockid+0x27>

00801622 <alloc_sockfd>:
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	56                   	push   %esi
  801626:	53                   	push   %ebx
  801627:	83 ec 1c             	sub    $0x1c,%esp
  80162a:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80162c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162f:	50                   	push   %eax
  801630:	e8 6d f7 ff ff       	call   800da2 <fd_alloc>
  801635:	89 c3                	mov    %eax,%ebx
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 43                	js     801681 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80163e:	83 ec 04             	sub    $0x4,%esp
  801641:	68 07 04 00 00       	push   $0x407
  801646:	ff 75 f4             	pushl  -0xc(%ebp)
  801649:	6a 00                	push   $0x0
  80164b:	e8 1b f5 ff ff       	call   800b6b <sys_page_alloc>
  801650:	89 c3                	mov    %eax,%ebx
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	85 c0                	test   %eax,%eax
  801657:	78 28                	js     801681 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801662:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801667:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80166e:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	50                   	push   %eax
  801675:	e8 01 f7 ff ff       	call   800d7b <fd2num>
  80167a:	89 c3                	mov    %eax,%ebx
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	eb 0c                	jmp    80168d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	56                   	push   %esi
  801685:	e8 e2 01 00 00       	call   80186c <nsipc_close>
		return r;
  80168a:	83 c4 10             	add    $0x10,%esp
}
  80168d:	89 d8                	mov    %ebx,%eax
  80168f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801692:	5b                   	pop    %ebx
  801693:	5e                   	pop    %esi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    

00801696 <accept>:
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	e8 4e ff ff ff       	call   8015f2 <fd2sockid>
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	78 1b                	js     8016c3 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8016a8:	83 ec 04             	sub    $0x4,%esp
  8016ab:	ff 75 10             	pushl  0x10(%ebp)
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	50                   	push   %eax
  8016b2:	e8 0e 01 00 00       	call   8017c5 <nsipc_accept>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 05                	js     8016c3 <accept+0x2d>
	return alloc_sockfd(r);
  8016be:	e8 5f ff ff ff       	call   801622 <alloc_sockfd>
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <bind>:
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	e8 1f ff ff ff       	call   8015f2 <fd2sockid>
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	78 12                	js     8016e9 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	ff 75 10             	pushl  0x10(%ebp)
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	50                   	push   %eax
  8016e1:	e8 2f 01 00 00       	call   801815 <nsipc_bind>
  8016e6:	83 c4 10             	add    $0x10,%esp
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <shutdown>:
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	e8 f9 fe ff ff       	call   8015f2 <fd2sockid>
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	78 0f                	js     80170c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	50                   	push   %eax
  801704:	e8 41 01 00 00       	call   80184a <nsipc_shutdown>
  801709:	83 c4 10             	add    $0x10,%esp
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <connect>:
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	e8 d6 fe ff ff       	call   8015f2 <fd2sockid>
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 12                	js     801732 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	ff 75 10             	pushl  0x10(%ebp)
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	50                   	push   %eax
  80172a:	e8 57 01 00 00       	call   801886 <nsipc_connect>
  80172f:	83 c4 10             	add    $0x10,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <listen>:
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	e8 b0 fe ff ff       	call   8015f2 <fd2sockid>
  801742:	85 c0                	test   %eax,%eax
  801744:	78 0f                	js     801755 <listen+0x21>
	return nsipc_listen(r, backlog);
  801746:	83 ec 08             	sub    $0x8,%esp
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	50                   	push   %eax
  80174d:	e8 69 01 00 00       	call   8018bb <nsipc_listen>
  801752:	83 c4 10             	add    $0x10,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <socket>:

int
socket(int domain, int type, int protocol)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80175d:	ff 75 10             	pushl  0x10(%ebp)
  801760:	ff 75 0c             	pushl  0xc(%ebp)
  801763:	ff 75 08             	pushl  0x8(%ebp)
  801766:	e8 3c 02 00 00       	call   8019a7 <nsipc_socket>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 05                	js     801777 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801772:	e8 ab fe ff ff       	call   801622 <alloc_sockfd>
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	53                   	push   %ebx
  80177d:	83 ec 04             	sub    $0x4,%esp
  801780:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801782:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801789:	74 26                	je     8017b1 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80178b:	6a 07                	push   $0x7
  80178d:	68 00 60 80 00       	push   $0x806000
  801792:	53                   	push   %ebx
  801793:	ff 35 04 40 80 00    	pushl  0x804004
  801799:	e8 aa 07 00 00       	call   801f48 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80179e:	83 c4 0c             	add    $0xc,%esp
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	e8 35 07 00 00       	call   801ee1 <ipc_recv>
}
  8017ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8017b1:	83 ec 0c             	sub    $0xc,%esp
  8017b4:	6a 02                	push   $0x2
  8017b6:	e8 e1 07 00 00       	call   801f9c <ipc_find_env>
  8017bb:	a3 04 40 80 00       	mov    %eax,0x804004
  8017c0:	83 c4 10             	add    $0x10,%esp
  8017c3:	eb c6                	jmp    80178b <nsipc+0x12>

008017c5 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	56                   	push   %esi
  8017c9:	53                   	push   %ebx
  8017ca:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8017d5:	8b 06                	mov    (%esi),%eax
  8017d7:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8017dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e1:	e8 93 ff ff ff       	call   801779 <nsipc>
  8017e6:	89 c3                	mov    %eax,%ebx
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	78 20                	js     80180c <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	ff 35 10 60 80 00    	pushl  0x806010
  8017f5:	68 00 60 80 00       	push   $0x806000
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	e8 fe f0 ff ff       	call   800900 <memmove>
		*addrlen = ret->ret_addrlen;
  801802:	a1 10 60 80 00       	mov    0x806010,%eax
  801807:	89 06                	mov    %eax,(%esi)
  801809:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80180c:	89 d8                	mov    %ebx,%eax
  80180e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801811:	5b                   	pop    %ebx
  801812:	5e                   	pop    %esi
  801813:	5d                   	pop    %ebp
  801814:	c3                   	ret    

00801815 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	53                   	push   %ebx
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801827:	53                   	push   %ebx
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	68 04 60 80 00       	push   $0x806004
  801830:	e8 cb f0 ff ff       	call   800900 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801835:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80183b:	b8 02 00 00 00       	mov    $0x2,%eax
  801840:	e8 34 ff ff ff       	call   801779 <nsipc>
}
  801845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801860:	b8 03 00 00 00       	mov    $0x3,%eax
  801865:	e8 0f ff ff ff       	call   801779 <nsipc>
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <nsipc_close>:

int
nsipc_close(int s)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80187a:	b8 04 00 00 00       	mov    $0x4,%eax
  80187f:	e8 f5 fe ff ff       	call   801779 <nsipc>
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801898:	53                   	push   %ebx
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	68 04 60 80 00       	push   $0x806004
  8018a1:	e8 5a f0 ff ff       	call   800900 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8018a6:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8018ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8018b1:	e8 c3 fe ff ff       	call   801779 <nsipc>
}
  8018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8018d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d6:	e8 9e fe ff ff       	call   801779 <nsipc>
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	56                   	push   %esi
  8018e1:	53                   	push   %ebx
  8018e2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8018ed:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8018fb:	b8 07 00 00 00       	mov    $0x7,%eax
  801900:	e8 74 fe ff ff       	call   801779 <nsipc>
  801905:	89 c3                	mov    %eax,%ebx
  801907:	85 c0                	test   %eax,%eax
  801909:	78 1f                	js     80192a <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80190b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801910:	7f 21                	jg     801933 <nsipc_recv+0x56>
  801912:	39 c6                	cmp    %eax,%esi
  801914:	7c 1d                	jl     801933 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801916:	83 ec 04             	sub    $0x4,%esp
  801919:	50                   	push   %eax
  80191a:	68 00 60 80 00       	push   $0x806000
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	e8 d9 ef ff ff       	call   800900 <memmove>
  801927:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80192a:	89 d8                	mov    %ebx,%eax
  80192c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801933:	68 9b 26 80 00       	push   $0x80269b
  801938:	68 63 26 80 00       	push   $0x802663
  80193d:	6a 62                	push   $0x62
  80193f:	68 b0 26 80 00       	push   $0x8026b0
  801944:	e8 52 05 00 00       	call   801e9b <_panic>

00801949 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	53                   	push   %ebx
  80194d:	83 ec 04             	sub    $0x4,%esp
  801950:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80195b:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801961:	7f 2e                	jg     801991 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801963:	83 ec 04             	sub    $0x4,%esp
  801966:	53                   	push   %ebx
  801967:	ff 75 0c             	pushl  0xc(%ebp)
  80196a:	68 0c 60 80 00       	push   $0x80600c
  80196f:	e8 8c ef ff ff       	call   800900 <memmove>
	nsipcbuf.send.req_size = size;
  801974:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80197a:	8b 45 14             	mov    0x14(%ebp),%eax
  80197d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801982:	b8 08 00 00 00       	mov    $0x8,%eax
  801987:	e8 ed fd ff ff       	call   801779 <nsipc>
}
  80198c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80198f:	c9                   	leave  
  801990:	c3                   	ret    
	assert(size < 1600);
  801991:	68 bc 26 80 00       	push   $0x8026bc
  801996:	68 63 26 80 00       	push   $0x802663
  80199b:	6a 6d                	push   $0x6d
  80199d:	68 b0 26 80 00       	push   $0x8026b0
  8019a2:	e8 f4 04 00 00       	call   801e9b <_panic>

008019a7 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8019bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8019c5:	b8 09 00 00 00       	mov    $0x9,%eax
  8019ca:	e8 aa fd ff ff       	call   801779 <nsipc>
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
  8019d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019d9:	83 ec 0c             	sub    $0xc,%esp
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	e8 a7 f3 ff ff       	call   800d8b <fd2data>
  8019e4:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019e6:	83 c4 08             	add    $0x8,%esp
  8019e9:	68 c8 26 80 00       	push   $0x8026c8
  8019ee:	53                   	push   %ebx
  8019ef:	e8 7e ed ff ff       	call   800772 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019f4:	8b 46 04             	mov    0x4(%esi),%eax
  8019f7:	2b 06                	sub    (%esi),%eax
  8019f9:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8019ff:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a06:	00 00 00 
	stat->st_dev = &devpipe;
  801a09:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a10:	30 80 00 
	return 0;
}
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
  801a18:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1b:	5b                   	pop    %ebx
  801a1c:	5e                   	pop    %esi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    

00801a1f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	53                   	push   %ebx
  801a23:	83 ec 0c             	sub    $0xc,%esp
  801a26:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a29:	53                   	push   %ebx
  801a2a:	6a 00                	push   $0x0
  801a2c:	e8 bf f1 ff ff       	call   800bf0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a31:	89 1c 24             	mov    %ebx,(%esp)
  801a34:	e8 52 f3 ff ff       	call   800d8b <fd2data>
  801a39:	83 c4 08             	add    $0x8,%esp
  801a3c:	50                   	push   %eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	e8 ac f1 ff ff       	call   800bf0 <sys_page_unmap>
}
  801a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <_pipeisclosed>:
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	57                   	push   %edi
  801a4d:	56                   	push   %esi
  801a4e:	53                   	push   %ebx
  801a4f:	83 ec 1c             	sub    $0x1c,%esp
  801a52:	89 c7                	mov    %eax,%edi
  801a54:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a56:	a1 08 40 80 00       	mov    0x804008,%eax
  801a5b:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a5e:	83 ec 0c             	sub    $0xc,%esp
  801a61:	57                   	push   %edi
  801a62:	e8 6e 05 00 00       	call   801fd5 <pageref>
  801a67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a6a:	89 34 24             	mov    %esi,(%esp)
  801a6d:	e8 63 05 00 00       	call   801fd5 <pageref>
		nn = thisenv->env_runs;
  801a72:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a78:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a7b:	83 c4 10             	add    $0x10,%esp
  801a7e:	39 cb                	cmp    %ecx,%ebx
  801a80:	74 1b                	je     801a9d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a82:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a85:	75 cf                	jne    801a56 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a87:	8b 42 58             	mov    0x58(%edx),%eax
  801a8a:	6a 01                	push   $0x1
  801a8c:	50                   	push   %eax
  801a8d:	53                   	push   %ebx
  801a8e:	68 cf 26 80 00       	push   $0x8026cf
  801a93:	e8 bb e6 ff ff       	call   800153 <cprintf>
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	eb b9                	jmp    801a56 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a9d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aa0:	0f 94 c0             	sete   %al
  801aa3:	0f b6 c0             	movzbl %al,%eax
}
  801aa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aa9:	5b                   	pop    %ebx
  801aaa:	5e                   	pop    %esi
  801aab:	5f                   	pop    %edi
  801aac:	5d                   	pop    %ebp
  801aad:	c3                   	ret    

00801aae <devpipe_write>:
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	57                   	push   %edi
  801ab2:	56                   	push   %esi
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 28             	sub    $0x28,%esp
  801ab7:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801aba:	56                   	push   %esi
  801abb:	e8 cb f2 ff ff       	call   800d8b <fd2data>
  801ac0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	bf 00 00 00 00       	mov    $0x0,%edi
  801aca:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801acd:	74 4f                	je     801b1e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801acf:	8b 43 04             	mov    0x4(%ebx),%eax
  801ad2:	8b 0b                	mov    (%ebx),%ecx
  801ad4:	8d 51 20             	lea    0x20(%ecx),%edx
  801ad7:	39 d0                	cmp    %edx,%eax
  801ad9:	72 14                	jb     801aef <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801adb:	89 da                	mov    %ebx,%edx
  801add:	89 f0                	mov    %esi,%eax
  801adf:	e8 65 ff ff ff       	call   801a49 <_pipeisclosed>
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	75 3a                	jne    801b22 <devpipe_write+0x74>
			sys_yield();
  801ae8:	e8 5f f0 ff ff       	call   800b4c <sys_yield>
  801aed:	eb e0                	jmp    801acf <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801aef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af2:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801af6:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801af9:	89 c2                	mov    %eax,%edx
  801afb:	c1 fa 1f             	sar    $0x1f,%edx
  801afe:	89 d1                	mov    %edx,%ecx
  801b00:	c1 e9 1b             	shr    $0x1b,%ecx
  801b03:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b06:	83 e2 1f             	and    $0x1f,%edx
  801b09:	29 ca                	sub    %ecx,%edx
  801b0b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b0f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b13:	83 c0 01             	add    $0x1,%eax
  801b16:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b19:	83 c7 01             	add    $0x1,%edi
  801b1c:	eb ac                	jmp    801aca <devpipe_write+0x1c>
	return i;
  801b1e:	89 f8                	mov    %edi,%eax
  801b20:	eb 05                	jmp    801b27 <devpipe_write+0x79>
				return 0;
  801b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2a:	5b                   	pop    %ebx
  801b2b:	5e                   	pop    %esi
  801b2c:	5f                   	pop    %edi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <devpipe_read>:
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	57                   	push   %edi
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	83 ec 18             	sub    $0x18,%esp
  801b38:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b3b:	57                   	push   %edi
  801b3c:	e8 4a f2 ff ff       	call   800d8b <fd2data>
  801b41:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b43:	83 c4 10             	add    $0x10,%esp
  801b46:	be 00 00 00 00       	mov    $0x0,%esi
  801b4b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b4e:	74 47                	je     801b97 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b50:	8b 03                	mov    (%ebx),%eax
  801b52:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b55:	75 22                	jne    801b79 <devpipe_read+0x4a>
			if (i > 0)
  801b57:	85 f6                	test   %esi,%esi
  801b59:	75 14                	jne    801b6f <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b5b:	89 da                	mov    %ebx,%edx
  801b5d:	89 f8                	mov    %edi,%eax
  801b5f:	e8 e5 fe ff ff       	call   801a49 <_pipeisclosed>
  801b64:	85 c0                	test   %eax,%eax
  801b66:	75 33                	jne    801b9b <devpipe_read+0x6c>
			sys_yield();
  801b68:	e8 df ef ff ff       	call   800b4c <sys_yield>
  801b6d:	eb e1                	jmp    801b50 <devpipe_read+0x21>
				return i;
  801b6f:	89 f0                	mov    %esi,%eax
}
  801b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b74:	5b                   	pop    %ebx
  801b75:	5e                   	pop    %esi
  801b76:	5f                   	pop    %edi
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b79:	99                   	cltd   
  801b7a:	c1 ea 1b             	shr    $0x1b,%edx
  801b7d:	01 d0                	add    %edx,%eax
  801b7f:	83 e0 1f             	and    $0x1f,%eax
  801b82:	29 d0                	sub    %edx,%eax
  801b84:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b8c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b8f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b92:	83 c6 01             	add    $0x1,%esi
  801b95:	eb b4                	jmp    801b4b <devpipe_read+0x1c>
	return i;
  801b97:	89 f0                	mov    %esi,%eax
  801b99:	eb d6                	jmp    801b71 <devpipe_read+0x42>
				return 0;
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba0:	eb cf                	jmp    801b71 <devpipe_read+0x42>

00801ba2 <pipe>:
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	56                   	push   %esi
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801baa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	e8 ef f1 ff ff       	call   800da2 <fd_alloc>
  801bb3:	89 c3                	mov    %eax,%ebx
  801bb5:	83 c4 10             	add    $0x10,%esp
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 5b                	js     801c17 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	68 07 04 00 00       	push   $0x407
  801bc4:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc7:	6a 00                	push   $0x0
  801bc9:	e8 9d ef ff ff       	call   800b6b <sys_page_alloc>
  801bce:	89 c3                	mov    %eax,%ebx
  801bd0:	83 c4 10             	add    $0x10,%esp
  801bd3:	85 c0                	test   %eax,%eax
  801bd5:	78 40                	js     801c17 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bdd:	50                   	push   %eax
  801bde:	e8 bf f1 ff ff       	call   800da2 <fd_alloc>
  801be3:	89 c3                	mov    %eax,%ebx
  801be5:	83 c4 10             	add    $0x10,%esp
  801be8:	85 c0                	test   %eax,%eax
  801bea:	78 1b                	js     801c07 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bec:	83 ec 04             	sub    $0x4,%esp
  801bef:	68 07 04 00 00       	push   $0x407
  801bf4:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf7:	6a 00                	push   $0x0
  801bf9:	e8 6d ef ff ff       	call   800b6b <sys_page_alloc>
  801bfe:	89 c3                	mov    %eax,%ebx
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	85 c0                	test   %eax,%eax
  801c05:	79 19                	jns    801c20 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c07:	83 ec 08             	sub    $0x8,%esp
  801c0a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0d:	6a 00                	push   $0x0
  801c0f:	e8 dc ef ff ff       	call   800bf0 <sys_page_unmap>
  801c14:	83 c4 10             	add    $0x10,%esp
}
  801c17:	89 d8                	mov    %ebx,%eax
  801c19:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1c:	5b                   	pop    %ebx
  801c1d:	5e                   	pop    %esi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
	va = fd2data(fd0);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	ff 75 f4             	pushl  -0xc(%ebp)
  801c26:	e8 60 f1 ff ff       	call   800d8b <fd2data>
  801c2b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c2d:	83 c4 0c             	add    $0xc,%esp
  801c30:	68 07 04 00 00       	push   $0x407
  801c35:	50                   	push   %eax
  801c36:	6a 00                	push   $0x0
  801c38:	e8 2e ef ff ff       	call   800b6b <sys_page_alloc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	85 c0                	test   %eax,%eax
  801c44:	0f 88 8c 00 00 00    	js     801cd6 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c50:	e8 36 f1 ff ff       	call   800d8b <fd2data>
  801c55:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c5c:	50                   	push   %eax
  801c5d:	6a 00                	push   $0x0
  801c5f:	56                   	push   %esi
  801c60:	6a 00                	push   $0x0
  801c62:	e8 47 ef ff ff       	call   800bae <sys_page_map>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	83 c4 20             	add    $0x20,%esp
  801c6c:	85 c0                	test   %eax,%eax
  801c6e:	78 58                	js     801cc8 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c79:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c88:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c8e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c93:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca0:	e8 d6 f0 ff ff       	call   800d7b <fd2num>
  801ca5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca8:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801caa:	83 c4 04             	add    $0x4,%esp
  801cad:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb0:	e8 c6 f0 ff ff       	call   800d7b <fd2num>
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb8:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cbb:	83 c4 10             	add    $0x10,%esp
  801cbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc3:	e9 4f ff ff ff       	jmp    801c17 <pipe+0x75>
	sys_page_unmap(0, va);
  801cc8:	83 ec 08             	sub    $0x8,%esp
  801ccb:	56                   	push   %esi
  801ccc:	6a 00                	push   $0x0
  801cce:	e8 1d ef ff ff       	call   800bf0 <sys_page_unmap>
  801cd3:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdc:	6a 00                	push   $0x0
  801cde:	e8 0d ef ff ff       	call   800bf0 <sys_page_unmap>
  801ce3:	83 c4 10             	add    $0x10,%esp
  801ce6:	e9 1c ff ff ff       	jmp    801c07 <pipe+0x65>

00801ceb <pipeisclosed>:
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cf1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf4:	50                   	push   %eax
  801cf5:	ff 75 08             	pushl  0x8(%ebp)
  801cf8:	e8 f4 f0 ff ff       	call   800df1 <fd_lookup>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	85 c0                	test   %eax,%eax
  801d02:	78 18                	js     801d1c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0a:	e8 7c f0 ff ff       	call   800d8b <fd2data>
	return _pipeisclosed(fd, p);
  801d0f:	89 c2                	mov    %eax,%edx
  801d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d14:	e8 30 fd ff ff       	call   801a49 <_pipeisclosed>
  801d19:	83 c4 10             	add    $0x10,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    

00801d28 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d2e:	68 e7 26 80 00       	push   $0x8026e7
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 37 ea ff ff       	call   800772 <strcpy>
	return 0;
}
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <devcons_write>:
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d4e:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d53:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d59:	eb 2f                	jmp    801d8a <devcons_write+0x48>
		m = n - tot;
  801d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d5e:	29 f3                	sub    %esi,%ebx
  801d60:	83 fb 7f             	cmp    $0x7f,%ebx
  801d63:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d68:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d6b:	83 ec 04             	sub    $0x4,%esp
  801d6e:	53                   	push   %ebx
  801d6f:	89 f0                	mov    %esi,%eax
  801d71:	03 45 0c             	add    0xc(%ebp),%eax
  801d74:	50                   	push   %eax
  801d75:	57                   	push   %edi
  801d76:	e8 85 eb ff ff       	call   800900 <memmove>
		sys_cputs(buf, m);
  801d7b:	83 c4 08             	add    $0x8,%esp
  801d7e:	53                   	push   %ebx
  801d7f:	57                   	push   %edi
  801d80:	e8 2a ed ff ff       	call   800aaf <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d85:	01 de                	add    %ebx,%esi
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d8d:	72 cc                	jb     801d5b <devcons_write+0x19>
}
  801d8f:	89 f0                	mov    %esi,%eax
  801d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d94:	5b                   	pop    %ebx
  801d95:	5e                   	pop    %esi
  801d96:	5f                   	pop    %edi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <devcons_read>:
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 08             	sub    $0x8,%esp
  801d9f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801da4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801da8:	75 07                	jne    801db1 <devcons_read+0x18>
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    
		sys_yield();
  801dac:	e8 9b ed ff ff       	call   800b4c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801db1:	e8 17 ed ff ff       	call   800acd <sys_cgetc>
  801db6:	85 c0                	test   %eax,%eax
  801db8:	74 f2                	je     801dac <devcons_read+0x13>
	if (c < 0)
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 ec                	js     801daa <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801dbe:	83 f8 04             	cmp    $0x4,%eax
  801dc1:	74 0c                	je     801dcf <devcons_read+0x36>
	*(char*)vbuf = c;
  801dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc6:	88 02                	mov    %al,(%edx)
	return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb db                	jmp    801daa <devcons_read+0x11>
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd4:	eb d4                	jmp    801daa <devcons_read+0x11>

00801dd6 <cputchar>:
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801de2:	6a 01                	push   $0x1
  801de4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de7:	50                   	push   %eax
  801de8:	e8 c2 ec ff ff       	call   800aaf <sys_cputs>
}
  801ded:	83 c4 10             	add    $0x10,%esp
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <getchar>:
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801df8:	6a 01                	push   $0x1
  801dfa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dfd:	50                   	push   %eax
  801dfe:	6a 00                	push   $0x0
  801e00:	e8 5d f2 ff ff       	call   801062 <read>
	if (r < 0)
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	78 08                	js     801e14 <getchar+0x22>
	if (r < 1)
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	7e 06                	jle    801e16 <getchar+0x24>
	return c;
  801e10:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    
		return -E_EOF;
  801e16:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e1b:	eb f7                	jmp    801e14 <getchar+0x22>

00801e1d <iscons>:
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e26:	50                   	push   %eax
  801e27:	ff 75 08             	pushl  0x8(%ebp)
  801e2a:	e8 c2 ef ff ff       	call   800df1 <fd_lookup>
  801e2f:	83 c4 10             	add    $0x10,%esp
  801e32:	85 c0                	test   %eax,%eax
  801e34:	78 11                	js     801e47 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e3f:	39 10                	cmp    %edx,(%eax)
  801e41:	0f 94 c0             	sete   %al
  801e44:	0f b6 c0             	movzbl %al,%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <opencons>:
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e52:	50                   	push   %eax
  801e53:	e8 4a ef ff ff       	call   800da2 <fd_alloc>
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	85 c0                	test   %eax,%eax
  801e5d:	78 3a                	js     801e99 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	68 07 04 00 00       	push   $0x407
  801e67:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6a:	6a 00                	push   $0x0
  801e6c:	e8 fa ec ff ff       	call   800b6b <sys_page_alloc>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	85 c0                	test   %eax,%eax
  801e76:	78 21                	js     801e99 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e81:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e8d:	83 ec 0c             	sub    $0xc,%esp
  801e90:	50                   	push   %eax
  801e91:	e8 e5 ee ff ff       	call   800d7b <fd2num>
  801e96:	83 c4 10             	add    $0x10,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	56                   	push   %esi
  801e9f:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ea0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ea3:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801ea9:	e8 7f ec ff ff       	call   800b2d <sys_getenvid>
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	ff 75 0c             	pushl  0xc(%ebp)
  801eb4:	ff 75 08             	pushl  0x8(%ebp)
  801eb7:	56                   	push   %esi
  801eb8:	50                   	push   %eax
  801eb9:	68 f4 26 80 00       	push   $0x8026f4
  801ebe:	e8 90 e2 ff ff       	call   800153 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ec3:	83 c4 18             	add    $0x18,%esp
  801ec6:	53                   	push   %ebx
  801ec7:	ff 75 10             	pushl  0x10(%ebp)
  801eca:	e8 33 e2 ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  801ecf:	c7 04 24 e0 26 80 00 	movl   $0x8026e0,(%esp)
  801ed6:	e8 78 e2 ff ff       	call   800153 <cprintf>
  801edb:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ede:	cc                   	int3   
  801edf:	eb fd                	jmp    801ede <_panic+0x43>

00801ee1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	56                   	push   %esi
  801ee5:	53                   	push   %ebx
  801ee6:	8b 75 08             	mov    0x8(%ebp),%esi
  801ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801eef:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ef1:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ef6:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	50                   	push   %eax
  801efd:	e8 19 ee ff ff       	call   800d1b <sys_ipc_recv>
	if (from_env_store)
  801f02:	83 c4 10             	add    $0x10,%esp
  801f05:	85 f6                	test   %esi,%esi
  801f07:	74 14                	je     801f1d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f09:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	78 09                	js     801f1b <ipc_recv+0x3a>
  801f12:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f18:	8b 52 74             	mov    0x74(%edx),%edx
  801f1b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f1d:	85 db                	test   %ebx,%ebx
  801f1f:	74 14                	je     801f35 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f21:	ba 00 00 00 00       	mov    $0x0,%edx
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 09                	js     801f33 <ipc_recv+0x52>
  801f2a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f30:	8b 52 78             	mov    0x78(%edx),%edx
  801f33:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f35:	85 c0                	test   %eax,%eax
  801f37:	78 08                	js     801f41 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f39:	a1 08 40 80 00       	mov    0x804008,%eax
  801f3e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5e                   	pop    %esi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    

00801f48 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	57                   	push   %edi
  801f4c:	56                   	push   %esi
  801f4d:	53                   	push   %ebx
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f54:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f5a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f5c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f61:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f64:	ff 75 14             	pushl  0x14(%ebp)
  801f67:	53                   	push   %ebx
  801f68:	56                   	push   %esi
  801f69:	57                   	push   %edi
  801f6a:	e8 89 ed ff ff       	call   800cf8 <sys_ipc_try_send>
		if (ret == 0)
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	85 c0                	test   %eax,%eax
  801f74:	74 1e                	je     801f94 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f76:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f79:	75 07                	jne    801f82 <ipc_send+0x3a>
			sys_yield();
  801f7b:	e8 cc eb ff ff       	call   800b4c <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f80:	eb e2                	jmp    801f64 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f82:	50                   	push   %eax
  801f83:	68 18 27 80 00       	push   $0x802718
  801f88:	6a 3d                	push   $0x3d
  801f8a:	68 2c 27 80 00       	push   $0x80272c
  801f8f:	e8 07 ff ff ff       	call   801e9b <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f97:	5b                   	pop    %ebx
  801f98:	5e                   	pop    %esi
  801f99:	5f                   	pop    %edi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fa7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801faa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fb0:	8b 52 50             	mov    0x50(%edx),%edx
  801fb3:	39 ca                	cmp    %ecx,%edx
  801fb5:	74 11                	je     801fc8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fb7:	83 c0 01             	add    $0x1,%eax
  801fba:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fbf:	75 e6                	jne    801fa7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc6:	eb 0b                	jmp    801fd3 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fc8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fcb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fd0:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    

00801fd5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fdb:	89 d0                	mov    %edx,%eax
  801fdd:	c1 e8 16             	shr    $0x16,%eax
  801fe0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fec:	f6 c1 01             	test   $0x1,%cl
  801fef:	74 1d                	je     80200e <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ff1:	c1 ea 0c             	shr    $0xc,%edx
  801ff4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ffb:	f6 c2 01             	test   $0x1,%dl
  801ffe:	74 0e                	je     80200e <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802000:	c1 ea 0c             	shr    $0xc,%edx
  802003:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80200a:	ef 
  80200b:	0f b7 c0             	movzwl %ax,%eax
}
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    

00802010 <__udivdi3>:
  802010:	55                   	push   %ebp
  802011:	57                   	push   %edi
  802012:	56                   	push   %esi
  802013:	53                   	push   %ebx
  802014:	83 ec 1c             	sub    $0x1c,%esp
  802017:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80201b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80201f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802023:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802027:	85 d2                	test   %edx,%edx
  802029:	75 35                	jne    802060 <__udivdi3+0x50>
  80202b:	39 f3                	cmp    %esi,%ebx
  80202d:	0f 87 bd 00 00 00    	ja     8020f0 <__udivdi3+0xe0>
  802033:	85 db                	test   %ebx,%ebx
  802035:	89 d9                	mov    %ebx,%ecx
  802037:	75 0b                	jne    802044 <__udivdi3+0x34>
  802039:	b8 01 00 00 00       	mov    $0x1,%eax
  80203e:	31 d2                	xor    %edx,%edx
  802040:	f7 f3                	div    %ebx
  802042:	89 c1                	mov    %eax,%ecx
  802044:	31 d2                	xor    %edx,%edx
  802046:	89 f0                	mov    %esi,%eax
  802048:	f7 f1                	div    %ecx
  80204a:	89 c6                	mov    %eax,%esi
  80204c:	89 e8                	mov    %ebp,%eax
  80204e:	89 f7                	mov    %esi,%edi
  802050:	f7 f1                	div    %ecx
  802052:	89 fa                	mov    %edi,%edx
  802054:	83 c4 1c             	add    $0x1c,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    
  80205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802060:	39 f2                	cmp    %esi,%edx
  802062:	77 7c                	ja     8020e0 <__udivdi3+0xd0>
  802064:	0f bd fa             	bsr    %edx,%edi
  802067:	83 f7 1f             	xor    $0x1f,%edi
  80206a:	0f 84 98 00 00 00    	je     802108 <__udivdi3+0xf8>
  802070:	89 f9                	mov    %edi,%ecx
  802072:	b8 20 00 00 00       	mov    $0x20,%eax
  802077:	29 f8                	sub    %edi,%eax
  802079:	d3 e2                	shl    %cl,%edx
  80207b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80207f:	89 c1                	mov    %eax,%ecx
  802081:	89 da                	mov    %ebx,%edx
  802083:	d3 ea                	shr    %cl,%edx
  802085:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802089:	09 d1                	or     %edx,%ecx
  80208b:	89 f2                	mov    %esi,%edx
  80208d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802091:	89 f9                	mov    %edi,%ecx
  802093:	d3 e3                	shl    %cl,%ebx
  802095:	89 c1                	mov    %eax,%ecx
  802097:	d3 ea                	shr    %cl,%edx
  802099:	89 f9                	mov    %edi,%ecx
  80209b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80209f:	d3 e6                	shl    %cl,%esi
  8020a1:	89 eb                	mov    %ebp,%ebx
  8020a3:	89 c1                	mov    %eax,%ecx
  8020a5:	d3 eb                	shr    %cl,%ebx
  8020a7:	09 de                	or     %ebx,%esi
  8020a9:	89 f0                	mov    %esi,%eax
  8020ab:	f7 74 24 08          	divl   0x8(%esp)
  8020af:	89 d6                	mov    %edx,%esi
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	f7 64 24 0c          	mull   0xc(%esp)
  8020b7:	39 d6                	cmp    %edx,%esi
  8020b9:	72 0c                	jb     8020c7 <__udivdi3+0xb7>
  8020bb:	89 f9                	mov    %edi,%ecx
  8020bd:	d3 e5                	shl    %cl,%ebp
  8020bf:	39 c5                	cmp    %eax,%ebp
  8020c1:	73 5d                	jae    802120 <__udivdi3+0x110>
  8020c3:	39 d6                	cmp    %edx,%esi
  8020c5:	75 59                	jne    802120 <__udivdi3+0x110>
  8020c7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ca:	31 ff                	xor    %edi,%edi
  8020cc:	89 fa                	mov    %edi,%edx
  8020ce:	83 c4 1c             	add    $0x1c,%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    
  8020d6:	8d 76 00             	lea    0x0(%esi),%esi
  8020d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8020e0:	31 ff                	xor    %edi,%edi
  8020e2:	31 c0                	xor    %eax,%eax
  8020e4:	89 fa                	mov    %edi,%edx
  8020e6:	83 c4 1c             	add    $0x1c,%esp
  8020e9:	5b                   	pop    %ebx
  8020ea:	5e                   	pop    %esi
  8020eb:	5f                   	pop    %edi
  8020ec:	5d                   	pop    %ebp
  8020ed:	c3                   	ret    
  8020ee:	66 90                	xchg   %ax,%ax
  8020f0:	31 ff                	xor    %edi,%edi
  8020f2:	89 e8                	mov    %ebp,%eax
  8020f4:	89 f2                	mov    %esi,%edx
  8020f6:	f7 f3                	div    %ebx
  8020f8:	89 fa                	mov    %edi,%edx
  8020fa:	83 c4 1c             	add    $0x1c,%esp
  8020fd:	5b                   	pop    %ebx
  8020fe:	5e                   	pop    %esi
  8020ff:	5f                   	pop    %edi
  802100:	5d                   	pop    %ebp
  802101:	c3                   	ret    
  802102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802108:	39 f2                	cmp    %esi,%edx
  80210a:	72 06                	jb     802112 <__udivdi3+0x102>
  80210c:	31 c0                	xor    %eax,%eax
  80210e:	39 eb                	cmp    %ebp,%ebx
  802110:	77 d2                	ja     8020e4 <__udivdi3+0xd4>
  802112:	b8 01 00 00 00       	mov    $0x1,%eax
  802117:	eb cb                	jmp    8020e4 <__udivdi3+0xd4>
  802119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802120:	89 d8                	mov    %ebx,%eax
  802122:	31 ff                	xor    %edi,%edi
  802124:	eb be                	jmp    8020e4 <__udivdi3+0xd4>
  802126:	66 90                	xchg   %ax,%ax
  802128:	66 90                	xchg   %ax,%ax
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	66 90                	xchg   %ax,%ax
  80212e:	66 90                	xchg   %ax,%ax

00802130 <__umoddi3>:
  802130:	55                   	push   %ebp
  802131:	57                   	push   %edi
  802132:	56                   	push   %esi
  802133:	53                   	push   %ebx
  802134:	83 ec 1c             	sub    $0x1c,%esp
  802137:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80213b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80213f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802143:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802147:	85 ed                	test   %ebp,%ebp
  802149:	89 f0                	mov    %esi,%eax
  80214b:	89 da                	mov    %ebx,%edx
  80214d:	75 19                	jne    802168 <__umoddi3+0x38>
  80214f:	39 df                	cmp    %ebx,%edi
  802151:	0f 86 b1 00 00 00    	jbe    802208 <__umoddi3+0xd8>
  802157:	f7 f7                	div    %edi
  802159:	89 d0                	mov    %edx,%eax
  80215b:	31 d2                	xor    %edx,%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	39 dd                	cmp    %ebx,%ebp
  80216a:	77 f1                	ja     80215d <__umoddi3+0x2d>
  80216c:	0f bd cd             	bsr    %ebp,%ecx
  80216f:	83 f1 1f             	xor    $0x1f,%ecx
  802172:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802176:	0f 84 b4 00 00 00    	je     802230 <__umoddi3+0x100>
  80217c:	b8 20 00 00 00       	mov    $0x20,%eax
  802181:	89 c2                	mov    %eax,%edx
  802183:	8b 44 24 04          	mov    0x4(%esp),%eax
  802187:	29 c2                	sub    %eax,%edx
  802189:	89 c1                	mov    %eax,%ecx
  80218b:	89 f8                	mov    %edi,%eax
  80218d:	d3 e5                	shl    %cl,%ebp
  80218f:	89 d1                	mov    %edx,%ecx
  802191:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802195:	d3 e8                	shr    %cl,%eax
  802197:	09 c5                	or     %eax,%ebp
  802199:	8b 44 24 04          	mov    0x4(%esp),%eax
  80219d:	89 c1                	mov    %eax,%ecx
  80219f:	d3 e7                	shl    %cl,%edi
  8021a1:	89 d1                	mov    %edx,%ecx
  8021a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021a7:	89 df                	mov    %ebx,%edi
  8021a9:	d3 ef                	shr    %cl,%edi
  8021ab:	89 c1                	mov    %eax,%ecx
  8021ad:	89 f0                	mov    %esi,%eax
  8021af:	d3 e3                	shl    %cl,%ebx
  8021b1:	89 d1                	mov    %edx,%ecx
  8021b3:	89 fa                	mov    %edi,%edx
  8021b5:	d3 e8                	shr    %cl,%eax
  8021b7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021bc:	09 d8                	or     %ebx,%eax
  8021be:	f7 f5                	div    %ebp
  8021c0:	d3 e6                	shl    %cl,%esi
  8021c2:	89 d1                	mov    %edx,%ecx
  8021c4:	f7 64 24 08          	mull   0x8(%esp)
  8021c8:	39 d1                	cmp    %edx,%ecx
  8021ca:	89 c3                	mov    %eax,%ebx
  8021cc:	89 d7                	mov    %edx,%edi
  8021ce:	72 06                	jb     8021d6 <__umoddi3+0xa6>
  8021d0:	75 0e                	jne    8021e0 <__umoddi3+0xb0>
  8021d2:	39 c6                	cmp    %eax,%esi
  8021d4:	73 0a                	jae    8021e0 <__umoddi3+0xb0>
  8021d6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021da:	19 ea                	sbb    %ebp,%edx
  8021dc:	89 d7                	mov    %edx,%edi
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	89 ca                	mov    %ecx,%edx
  8021e2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8021e7:	29 de                	sub    %ebx,%esi
  8021e9:	19 fa                	sbb    %edi,%edx
  8021eb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021ef:	89 d0                	mov    %edx,%eax
  8021f1:	d3 e0                	shl    %cl,%eax
  8021f3:	89 d9                	mov    %ebx,%ecx
  8021f5:	d3 ee                	shr    %cl,%esi
  8021f7:	d3 ea                	shr    %cl,%edx
  8021f9:	09 f0                	or     %esi,%eax
  8021fb:	83 c4 1c             	add    $0x1c,%esp
  8021fe:	5b                   	pop    %ebx
  8021ff:	5e                   	pop    %esi
  802200:	5f                   	pop    %edi
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    
  802203:	90                   	nop
  802204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802208:	85 ff                	test   %edi,%edi
  80220a:	89 f9                	mov    %edi,%ecx
  80220c:	75 0b                	jne    802219 <__umoddi3+0xe9>
  80220e:	b8 01 00 00 00       	mov    $0x1,%eax
  802213:	31 d2                	xor    %edx,%edx
  802215:	f7 f7                	div    %edi
  802217:	89 c1                	mov    %eax,%ecx
  802219:	89 d8                	mov    %ebx,%eax
  80221b:	31 d2                	xor    %edx,%edx
  80221d:	f7 f1                	div    %ecx
  80221f:	89 f0                	mov    %esi,%eax
  802221:	f7 f1                	div    %ecx
  802223:	e9 31 ff ff ff       	jmp    802159 <__umoddi3+0x29>
  802228:	90                   	nop
  802229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802230:	39 dd                	cmp    %ebx,%ebp
  802232:	72 08                	jb     80223c <__umoddi3+0x10c>
  802234:	39 f7                	cmp    %esi,%edi
  802236:	0f 87 21 ff ff ff    	ja     80215d <__umoddi3+0x2d>
  80223c:	89 da                	mov    %ebx,%edx
  80223e:	89 f0                	mov    %esi,%eax
  802240:	29 f8                	sub    %edi,%eax
  802242:	19 ea                	sbb    %ebp,%edx
  802244:	e9 14 ff ff ff       	jmp    80215d <__umoddi3+0x2d>


obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 00 23 80 00       	push   $0x802300
  80004a:	e8 26 01 00 00       	call   800175 <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 fb 0a 00 00       	call   800b4f <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 b2 0a 00 00       	call   800b0e <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 2c 0d 00 00       	call   800d9d <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 bf 0a 00 00       	call   800b4f <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800098:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80009d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a2:	85 db                	test   %ebx,%ebx
  8000a4:	7e 07                	jle    8000ad <libmain+0x2d>
		binaryname = argv[0];
  8000a6:	8b 06                	mov    (%esi),%eax
  8000a8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	56                   	push   %esi
  8000b1:	53                   	push   %ebx
  8000b2:	e8 aa ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000b7:	e8 0a 00 00 00       	call   8000c6 <exit>
}
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c2:	5b                   	pop    %ebx
  8000c3:	5e                   	pop    %esi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000cc:	e8 2d 0f 00 00       	call   800ffe <close_all>
	sys_env_destroy(0);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	6a 00                	push   $0x0
  8000d6:	e8 33 0a 00 00       	call   800b0e <sys_env_destroy>
}
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ea:	8b 13                	mov    (%ebx),%edx
  8000ec:	8d 42 01             	lea    0x1(%edx),%eax
  8000ef:	89 03                	mov    %eax,(%ebx)
  8000f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000fd:	74 09                	je     800108 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800103:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800106:	c9                   	leave  
  800107:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800108:	83 ec 08             	sub    $0x8,%esp
  80010b:	68 ff 00 00 00       	push   $0xff
  800110:	8d 43 08             	lea    0x8(%ebx),%eax
  800113:	50                   	push   %eax
  800114:	e8 b8 09 00 00       	call   800ad1 <sys_cputs>
		b->idx = 0;
  800119:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	eb db                	jmp    8000ff <putch+0x1f>

00800124 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800134:	00 00 00 
	b.cnt = 0;
  800137:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80013e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800141:	ff 75 0c             	pushl  0xc(%ebp)
  800144:	ff 75 08             	pushl  0x8(%ebp)
  800147:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014d:	50                   	push   %eax
  80014e:	68 e0 00 80 00       	push   $0x8000e0
  800153:	e8 1a 01 00 00       	call   800272 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800158:	83 c4 08             	add    $0x8,%esp
  80015b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800161:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800167:	50                   	push   %eax
  800168:	e8 64 09 00 00       	call   800ad1 <sys_cputs>

	return b.cnt;
}
  80016d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80017e:	50                   	push   %eax
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	e8 9d ff ff ff       	call   800124 <vcprintf>
	va_end(ap);

	return cnt;
}
  800187:	c9                   	leave  
  800188:	c3                   	ret    

00800189 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800189:	55                   	push   %ebp
  80018a:	89 e5                	mov    %esp,%ebp
  80018c:	57                   	push   %edi
  80018d:	56                   	push   %esi
  80018e:	53                   	push   %ebx
  80018f:	83 ec 1c             	sub    $0x1c,%esp
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 d6                	mov    %edx,%esi
  800196:	8b 45 08             	mov    0x8(%ebp),%eax
  800199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001aa:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b0:	39 d3                	cmp    %edx,%ebx
  8001b2:	72 05                	jb     8001b9 <printnum+0x30>
  8001b4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001b7:	77 7a                	ja     800233 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	ff 75 18             	pushl  0x18(%ebp)
  8001bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001c5:	53                   	push   %ebx
  8001c6:	ff 75 10             	pushl  0x10(%ebp)
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001d8:	e8 e3 1e 00 00       	call   8020c0 <__udivdi3>
  8001dd:	83 c4 18             	add    $0x18,%esp
  8001e0:	52                   	push   %edx
  8001e1:	50                   	push   %eax
  8001e2:	89 f2                	mov    %esi,%edx
  8001e4:	89 f8                	mov    %edi,%eax
  8001e6:	e8 9e ff ff ff       	call   800189 <printnum>
  8001eb:	83 c4 20             	add    $0x20,%esp
  8001ee:	eb 13                	jmp    800203 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f0:	83 ec 08             	sub    $0x8,%esp
  8001f3:	56                   	push   %esi
  8001f4:	ff 75 18             	pushl  0x18(%ebp)
  8001f7:	ff d7                	call   *%edi
  8001f9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001fc:	83 eb 01             	sub    $0x1,%ebx
  8001ff:	85 db                	test   %ebx,%ebx
  800201:	7f ed                	jg     8001f0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	56                   	push   %esi
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020d:	ff 75 e0             	pushl  -0x20(%ebp)
  800210:	ff 75 dc             	pushl  -0x24(%ebp)
  800213:	ff 75 d8             	pushl  -0x28(%ebp)
  800216:	e8 c5 1f 00 00       	call   8021e0 <__umoddi3>
  80021b:	83 c4 14             	add    $0x14,%esp
  80021e:	0f be 80 26 23 80 00 	movsbl 0x802326(%eax),%eax
  800225:	50                   	push   %eax
  800226:	ff d7                	call   *%edi
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5f                   	pop    %edi
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    
  800233:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800236:	eb c4                	jmp    8001fc <printnum+0x73>

00800238 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80023e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800242:	8b 10                	mov    (%eax),%edx
  800244:	3b 50 04             	cmp    0x4(%eax),%edx
  800247:	73 0a                	jae    800253 <sprintputch+0x1b>
		*b->buf++ = ch;
  800249:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024c:	89 08                	mov    %ecx,(%eax)
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	88 02                	mov    %al,(%edx)
}
  800253:	5d                   	pop    %ebp
  800254:	c3                   	ret    

00800255 <printfmt>:
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80025e:	50                   	push   %eax
  80025f:	ff 75 10             	pushl  0x10(%ebp)
  800262:	ff 75 0c             	pushl  0xc(%ebp)
  800265:	ff 75 08             	pushl  0x8(%ebp)
  800268:	e8 05 00 00 00       	call   800272 <vprintfmt>
}
  80026d:	83 c4 10             	add    $0x10,%esp
  800270:	c9                   	leave  
  800271:	c3                   	ret    

00800272 <vprintfmt>:
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	57                   	push   %edi
  800276:	56                   	push   %esi
  800277:	53                   	push   %ebx
  800278:	83 ec 2c             	sub    $0x2c,%esp
  80027b:	8b 75 08             	mov    0x8(%ebp),%esi
  80027e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800281:	8b 7d 10             	mov    0x10(%ebp),%edi
  800284:	e9 c1 03 00 00       	jmp    80064a <vprintfmt+0x3d8>
		padc = ' ';
  800289:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80028d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800294:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80029b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a7:	8d 47 01             	lea    0x1(%edi),%eax
  8002aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ad:	0f b6 17             	movzbl (%edi),%edx
  8002b0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b3:	3c 55                	cmp    $0x55,%al
  8002b5:	0f 87 12 04 00 00    	ja     8006cd <vprintfmt+0x45b>
  8002bb:	0f b6 c0             	movzbl %al,%eax
  8002be:	ff 24 85 60 24 80 00 	jmp    *0x802460(,%eax,4)
  8002c5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002cc:	eb d9                	jmp    8002a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002d1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002d5:	eb d0                	jmp    8002a7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d7:	0f b6 d2             	movzbl %dl,%edx
  8002da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002ec:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002ef:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f2:	83 f9 09             	cmp    $0x9,%ecx
  8002f5:	77 55                	ja     80034c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002f7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002fa:	eb e9                	jmp    8002e5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ff:	8b 00                	mov    (%eax),%eax
  800301:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800304:	8b 45 14             	mov    0x14(%ebp),%eax
  800307:	8d 40 04             	lea    0x4(%eax),%eax
  80030a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800310:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800314:	79 91                	jns    8002a7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800316:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800319:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800323:	eb 82                	jmp    8002a7 <vprintfmt+0x35>
  800325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800328:	85 c0                	test   %eax,%eax
  80032a:	ba 00 00 00 00       	mov    $0x0,%edx
  80032f:	0f 49 d0             	cmovns %eax,%edx
  800332:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800338:	e9 6a ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800340:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800347:	e9 5b ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
  80034c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800352:	eb bc                	jmp    800310 <vprintfmt+0x9e>
			lflag++;
  800354:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80035a:	e9 48 ff ff ff       	jmp    8002a7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8d 78 04             	lea    0x4(%eax),%edi
  800365:	83 ec 08             	sub    $0x8,%esp
  800368:	53                   	push   %ebx
  800369:	ff 30                	pushl  (%eax)
  80036b:	ff d6                	call   *%esi
			break;
  80036d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800370:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800373:	e9 cf 02 00 00       	jmp    800647 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800378:	8b 45 14             	mov    0x14(%ebp),%eax
  80037b:	8d 78 04             	lea    0x4(%eax),%edi
  80037e:	8b 00                	mov    (%eax),%eax
  800380:	99                   	cltd   
  800381:	31 d0                	xor    %edx,%eax
  800383:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800385:	83 f8 0f             	cmp    $0xf,%eax
  800388:	7f 23                	jg     8003ad <vprintfmt+0x13b>
  80038a:	8b 14 85 c0 25 80 00 	mov    0x8025c0(,%eax,4),%edx
  800391:	85 d2                	test   %edx,%edx
  800393:	74 18                	je     8003ad <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800395:	52                   	push   %edx
  800396:	68 19 27 80 00       	push   $0x802719
  80039b:	53                   	push   %ebx
  80039c:	56                   	push   %esi
  80039d:	e8 b3 fe ff ff       	call   800255 <printfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a8:	e9 9a 02 00 00       	jmp    800647 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003ad:	50                   	push   %eax
  8003ae:	68 3e 23 80 00       	push   $0x80233e
  8003b3:	53                   	push   %ebx
  8003b4:	56                   	push   %esi
  8003b5:	e8 9b fe ff ff       	call   800255 <printfmt>
  8003ba:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003bd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c0:	e9 82 02 00 00       	jmp    800647 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	83 c0 04             	add    $0x4,%eax
  8003cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003d3:	85 ff                	test   %edi,%edi
  8003d5:	b8 37 23 80 00       	mov    $0x802337,%eax
  8003da:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003e1:	0f 8e bd 00 00 00    	jle    8004a4 <vprintfmt+0x232>
  8003e7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003eb:	75 0e                	jne    8003fb <vprintfmt+0x189>
  8003ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8003f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003f9:	eb 6d                	jmp    800468 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fb:	83 ec 08             	sub    $0x8,%esp
  8003fe:	ff 75 d0             	pushl  -0x30(%ebp)
  800401:	57                   	push   %edi
  800402:	e8 6e 03 00 00       	call   800775 <strnlen>
  800407:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80040a:	29 c1                	sub    %eax,%ecx
  80040c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80040f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800412:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800416:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800419:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80041c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80041e:	eb 0f                	jmp    80042f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	53                   	push   %ebx
  800424:	ff 75 e0             	pushl  -0x20(%ebp)
  800427:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800429:	83 ef 01             	sub    $0x1,%edi
  80042c:	83 c4 10             	add    $0x10,%esp
  80042f:	85 ff                	test   %edi,%edi
  800431:	7f ed                	jg     800420 <vprintfmt+0x1ae>
  800433:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800436:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800439:	85 c9                	test   %ecx,%ecx
  80043b:	b8 00 00 00 00       	mov    $0x0,%eax
  800440:	0f 49 c1             	cmovns %ecx,%eax
  800443:	29 c1                	sub    %eax,%ecx
  800445:	89 75 08             	mov    %esi,0x8(%ebp)
  800448:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80044b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80044e:	89 cb                	mov    %ecx,%ebx
  800450:	eb 16                	jmp    800468 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800452:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800456:	75 31                	jne    800489 <vprintfmt+0x217>
					putch(ch, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 0c             	pushl  0xc(%ebp)
  80045e:	50                   	push   %eax
  80045f:	ff 55 08             	call   *0x8(%ebp)
  800462:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800465:	83 eb 01             	sub    $0x1,%ebx
  800468:	83 c7 01             	add    $0x1,%edi
  80046b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80046f:	0f be c2             	movsbl %dl,%eax
  800472:	85 c0                	test   %eax,%eax
  800474:	74 59                	je     8004cf <vprintfmt+0x25d>
  800476:	85 f6                	test   %esi,%esi
  800478:	78 d8                	js     800452 <vprintfmt+0x1e0>
  80047a:	83 ee 01             	sub    $0x1,%esi
  80047d:	79 d3                	jns    800452 <vprintfmt+0x1e0>
  80047f:	89 df                	mov    %ebx,%edi
  800481:	8b 75 08             	mov    0x8(%ebp),%esi
  800484:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800487:	eb 37                	jmp    8004c0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800489:	0f be d2             	movsbl %dl,%edx
  80048c:	83 ea 20             	sub    $0x20,%edx
  80048f:	83 fa 5e             	cmp    $0x5e,%edx
  800492:	76 c4                	jbe    800458 <vprintfmt+0x1e6>
					putch('?', putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	6a 3f                	push   $0x3f
  80049c:	ff 55 08             	call   *0x8(%ebp)
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	eb c1                	jmp    800465 <vprintfmt+0x1f3>
  8004a4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004aa:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004b0:	eb b6                	jmp    800468 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	6a 20                	push   $0x20
  8004b8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ee                	jg     8004b2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	e9 78 01 00 00       	jmp    800647 <vprintfmt+0x3d5>
  8004cf:	89 df                	mov    %ebx,%edi
  8004d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004d7:	eb e7                	jmp    8004c0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004d9:	83 f9 01             	cmp    $0x1,%ecx
  8004dc:	7e 3f                	jle    80051d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004de:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004e9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8d 40 08             	lea    0x8(%eax),%eax
  8004f2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004f9:	79 5c                	jns    800557 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004fb:	83 ec 08             	sub    $0x8,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	6a 2d                	push   $0x2d
  800501:	ff d6                	call   *%esi
				num = -(long long) num;
  800503:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800506:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800509:	f7 da                	neg    %edx
  80050b:	83 d1 00             	adc    $0x0,%ecx
  80050e:	f7 d9                	neg    %ecx
  800510:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800513:	b8 0a 00 00 00       	mov    $0xa,%eax
  800518:	e9 10 01 00 00       	jmp    80062d <vprintfmt+0x3bb>
	else if (lflag)
  80051d:	85 c9                	test   %ecx,%ecx
  80051f:	75 1b                	jne    80053c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	89 c1                	mov    %eax,%ecx
  80052b:	c1 f9 1f             	sar    $0x1f,%ecx
  80052e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 40 04             	lea    0x4(%eax),%eax
  800537:	89 45 14             	mov    %eax,0x14(%ebp)
  80053a:	eb b9                	jmp    8004f5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	89 c1                	mov    %eax,%ecx
  800546:	c1 f9 1f             	sar    $0x1f,%ecx
  800549:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8d 40 04             	lea    0x4(%eax),%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
  800555:	eb 9e                	jmp    8004f5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800557:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80055a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80055d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800562:	e9 c6 00 00 00       	jmp    80062d <vprintfmt+0x3bb>
	if (lflag >= 2)
  800567:	83 f9 01             	cmp    $0x1,%ecx
  80056a:	7e 18                	jle    800584 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80056c:	8b 45 14             	mov    0x14(%ebp),%eax
  80056f:	8b 10                	mov    (%eax),%edx
  800571:	8b 48 04             	mov    0x4(%eax),%ecx
  800574:	8d 40 08             	lea    0x8(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057f:	e9 a9 00 00 00       	jmp    80062d <vprintfmt+0x3bb>
	else if (lflag)
  800584:	85 c9                	test   %ecx,%ecx
  800586:	75 1a                	jne    8005a2 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8b 10                	mov    (%eax),%edx
  80058d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800592:	8d 40 04             	lea    0x4(%eax),%eax
  800595:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800598:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059d:	e9 8b 00 00 00       	jmp    80062d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 10                	mov    (%eax),%edx
  8005a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ac:	8d 40 04             	lea    0x4(%eax),%eax
  8005af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b7:	eb 74                	jmp    80062d <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005b9:	83 f9 01             	cmp    $0x1,%ecx
  8005bc:	7e 15                	jle    8005d3 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005be:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c1:	8b 10                	mov    (%eax),%edx
  8005c3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005c6:	8d 40 08             	lea    0x8(%eax),%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d1:	eb 5a                	jmp    80062d <vprintfmt+0x3bb>
	else if (lflag)
  8005d3:	85 c9                	test   %ecx,%ecx
  8005d5:	75 17                	jne    8005ee <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8b 10                	mov    (%eax),%edx
  8005dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e1:	8d 40 04             	lea    0x4(%eax),%eax
  8005e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8005ec:	eb 3f                	jmp    80062d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 10                	mov    (%eax),%edx
  8005f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005fe:	b8 08 00 00 00       	mov    $0x8,%eax
  800603:	eb 28                	jmp    80062d <vprintfmt+0x3bb>
			putch('0', putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	53                   	push   %ebx
  800609:	6a 30                	push   $0x30
  80060b:	ff d6                	call   *%esi
			putch('x', putdat);
  80060d:	83 c4 08             	add    $0x8,%esp
  800610:	53                   	push   %ebx
  800611:	6a 78                	push   $0x78
  800613:	ff d6                	call   *%esi
			num = (unsigned long long)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80061f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800622:	8d 40 04             	lea    0x4(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800628:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800634:	57                   	push   %edi
  800635:	ff 75 e0             	pushl  -0x20(%ebp)
  800638:	50                   	push   %eax
  800639:	51                   	push   %ecx
  80063a:	52                   	push   %edx
  80063b:	89 da                	mov    %ebx,%edx
  80063d:	89 f0                	mov    %esi,%eax
  80063f:	e8 45 fb ff ff       	call   800189 <printnum>
			break;
  800644:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80064a:	83 c7 01             	add    $0x1,%edi
  80064d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800651:	83 f8 25             	cmp    $0x25,%eax
  800654:	0f 84 2f fc ff ff    	je     800289 <vprintfmt+0x17>
			if (ch == '\0')
  80065a:	85 c0                	test   %eax,%eax
  80065c:	0f 84 8b 00 00 00    	je     8006ed <vprintfmt+0x47b>
			putch(ch, putdat);
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	53                   	push   %ebx
  800666:	50                   	push   %eax
  800667:	ff d6                	call   *%esi
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	eb dc                	jmp    80064a <vprintfmt+0x3d8>
	if (lflag >= 2)
  80066e:	83 f9 01             	cmp    $0x1,%ecx
  800671:	7e 15                	jle    800688 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	8b 10                	mov    (%eax),%edx
  800678:	8b 48 04             	mov    0x4(%eax),%ecx
  80067b:	8d 40 08             	lea    0x8(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800681:	b8 10 00 00 00       	mov    $0x10,%eax
  800686:	eb a5                	jmp    80062d <vprintfmt+0x3bb>
	else if (lflag)
  800688:	85 c9                	test   %ecx,%ecx
  80068a:	75 17                	jne    8006a3 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8b 10                	mov    (%eax),%edx
  800691:	b9 00 00 00 00       	mov    $0x0,%ecx
  800696:	8d 40 04             	lea    0x4(%eax),%eax
  800699:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069c:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a1:	eb 8a                	jmp    80062d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 10                	mov    (%eax),%edx
  8006a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ad:	8d 40 04             	lea    0x4(%eax),%eax
  8006b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006b8:	e9 70 ff ff ff       	jmp    80062d <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	53                   	push   %ebx
  8006c1:	6a 25                	push   $0x25
  8006c3:	ff d6                	call   *%esi
			break;
  8006c5:	83 c4 10             	add    $0x10,%esp
  8006c8:	e9 7a ff ff ff       	jmp    800647 <vprintfmt+0x3d5>
			putch('%', putdat);
  8006cd:	83 ec 08             	sub    $0x8,%esp
  8006d0:	53                   	push   %ebx
  8006d1:	6a 25                	push   $0x25
  8006d3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	89 f8                	mov    %edi,%eax
  8006da:	eb 03                	jmp    8006df <vprintfmt+0x46d>
  8006dc:	83 e8 01             	sub    $0x1,%eax
  8006df:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006e3:	75 f7                	jne    8006dc <vprintfmt+0x46a>
  8006e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006e8:	e9 5a ff ff ff       	jmp    800647 <vprintfmt+0x3d5>
}
  8006ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006f0:	5b                   	pop    %ebx
  8006f1:	5e                   	pop    %esi
  8006f2:	5f                   	pop    %edi
  8006f3:	5d                   	pop    %ebp
  8006f4:	c3                   	ret    

008006f5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800704:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800708:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80070b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800712:	85 c0                	test   %eax,%eax
  800714:	74 26                	je     80073c <vsnprintf+0x47>
  800716:	85 d2                	test   %edx,%edx
  800718:	7e 22                	jle    80073c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80071a:	ff 75 14             	pushl  0x14(%ebp)
  80071d:	ff 75 10             	pushl  0x10(%ebp)
  800720:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800723:	50                   	push   %eax
  800724:	68 38 02 80 00       	push   $0x800238
  800729:	e8 44 fb ff ff       	call   800272 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800731:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800737:	83 c4 10             	add    $0x10,%esp
}
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    
		return -E_INVAL;
  80073c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800741:	eb f7                	jmp    80073a <vsnprintf+0x45>

00800743 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800749:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80074c:	50                   	push   %eax
  80074d:	ff 75 10             	pushl  0x10(%ebp)
  800750:	ff 75 0c             	pushl  0xc(%ebp)
  800753:	ff 75 08             	pushl  0x8(%ebp)
  800756:	e8 9a ff ff ff       	call   8006f5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80075b:	c9                   	leave  
  80075c:	c3                   	ret    

0080075d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80075d:	55                   	push   %ebp
  80075e:	89 e5                	mov    %esp,%ebp
  800760:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800763:	b8 00 00 00 00       	mov    $0x0,%eax
  800768:	eb 03                	jmp    80076d <strlen+0x10>
		n++;
  80076a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80076d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800771:	75 f7                	jne    80076a <strlen+0xd>
	return n;
}
  800773:	5d                   	pop    %ebp
  800774:	c3                   	ret    

00800775 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077e:	b8 00 00 00 00       	mov    $0x0,%eax
  800783:	eb 03                	jmp    800788 <strnlen+0x13>
		n++;
  800785:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800788:	39 d0                	cmp    %edx,%eax
  80078a:	74 06                	je     800792 <strnlen+0x1d>
  80078c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800790:	75 f3                	jne    800785 <strnlen+0x10>
	return n;
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	53                   	push   %ebx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80079e:	89 c2                	mov    %eax,%edx
  8007a0:	83 c1 01             	add    $0x1,%ecx
  8007a3:	83 c2 01             	add    $0x1,%edx
  8007a6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007aa:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ad:	84 db                	test   %bl,%bl
  8007af:	75 ef                	jne    8007a0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b1:	5b                   	pop    %ebx
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	53                   	push   %ebx
  8007b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007bb:	53                   	push   %ebx
  8007bc:	e8 9c ff ff ff       	call   80075d <strlen>
  8007c1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	01 d8                	add    %ebx,%eax
  8007c9:	50                   	push   %eax
  8007ca:	e8 c5 ff ff ff       	call   800794 <strcpy>
	return dst;
}
  8007cf:	89 d8                	mov    %ebx,%eax
  8007d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007d4:	c9                   	leave  
  8007d5:	c3                   	ret    

008007d6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d6:	55                   	push   %ebp
  8007d7:	89 e5                	mov    %esp,%ebp
  8007d9:	56                   	push   %esi
  8007da:	53                   	push   %ebx
  8007db:	8b 75 08             	mov    0x8(%ebp),%esi
  8007de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e1:	89 f3                	mov    %esi,%ebx
  8007e3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e6:	89 f2                	mov    %esi,%edx
  8007e8:	eb 0f                	jmp    8007f9 <strncpy+0x23>
		*dst++ = *src;
  8007ea:	83 c2 01             	add    $0x1,%edx
  8007ed:	0f b6 01             	movzbl (%ecx),%eax
  8007f0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007f3:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007f9:	39 da                	cmp    %ebx,%edx
  8007fb:	75 ed                	jne    8007ea <strncpy+0x14>
	}
	return ret;
}
  8007fd:	89 f0                	mov    %esi,%eax
  8007ff:	5b                   	pop    %ebx
  800800:	5e                   	pop    %esi
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	56                   	push   %esi
  800807:	53                   	push   %ebx
  800808:	8b 75 08             	mov    0x8(%ebp),%esi
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800811:	89 f0                	mov    %esi,%eax
  800813:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800817:	85 c9                	test   %ecx,%ecx
  800819:	75 0b                	jne    800826 <strlcpy+0x23>
  80081b:	eb 17                	jmp    800834 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80081d:	83 c2 01             	add    $0x1,%edx
  800820:	83 c0 01             	add    $0x1,%eax
  800823:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800826:	39 d8                	cmp    %ebx,%eax
  800828:	74 07                	je     800831 <strlcpy+0x2e>
  80082a:	0f b6 0a             	movzbl (%edx),%ecx
  80082d:	84 c9                	test   %cl,%cl
  80082f:	75 ec                	jne    80081d <strlcpy+0x1a>
		*dst = '\0';
  800831:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800834:	29 f0                	sub    %esi,%eax
}
  800836:	5b                   	pop    %ebx
  800837:	5e                   	pop    %esi
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800843:	eb 06                	jmp    80084b <strcmp+0x11>
		p++, q++;
  800845:	83 c1 01             	add    $0x1,%ecx
  800848:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80084b:	0f b6 01             	movzbl (%ecx),%eax
  80084e:	84 c0                	test   %al,%al
  800850:	74 04                	je     800856 <strcmp+0x1c>
  800852:	3a 02                	cmp    (%edx),%al
  800854:	74 ef                	je     800845 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800856:	0f b6 c0             	movzbl %al,%eax
  800859:	0f b6 12             	movzbl (%edx),%edx
  80085c:	29 d0                	sub    %edx,%eax
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	53                   	push   %ebx
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	89 c3                	mov    %eax,%ebx
  80086c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80086f:	eb 06                	jmp    800877 <strncmp+0x17>
		n--, p++, q++;
  800871:	83 c0 01             	add    $0x1,%eax
  800874:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800877:	39 d8                	cmp    %ebx,%eax
  800879:	74 16                	je     800891 <strncmp+0x31>
  80087b:	0f b6 08             	movzbl (%eax),%ecx
  80087e:	84 c9                	test   %cl,%cl
  800880:	74 04                	je     800886 <strncmp+0x26>
  800882:	3a 0a                	cmp    (%edx),%cl
  800884:	74 eb                	je     800871 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800886:	0f b6 00             	movzbl (%eax),%eax
  800889:	0f b6 12             	movzbl (%edx),%edx
  80088c:	29 d0                	sub    %edx,%eax
}
  80088e:	5b                   	pop    %ebx
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    
		return 0;
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	eb f6                	jmp    80088e <strncmp+0x2e>

00800898 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a2:	0f b6 10             	movzbl (%eax),%edx
  8008a5:	84 d2                	test   %dl,%dl
  8008a7:	74 09                	je     8008b2 <strchr+0x1a>
		if (*s == c)
  8008a9:	38 ca                	cmp    %cl,%dl
  8008ab:	74 0a                	je     8008b7 <strchr+0x1f>
	for (; *s; s++)
  8008ad:	83 c0 01             	add    $0x1,%eax
  8008b0:	eb f0                	jmp    8008a2 <strchr+0xa>
			return (char *) s;
	return 0;
  8008b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b7:	5d                   	pop    %ebp
  8008b8:	c3                   	ret    

008008b9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c3:	eb 03                	jmp    8008c8 <strfind+0xf>
  8008c5:	83 c0 01             	add    $0x1,%eax
  8008c8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008cb:	38 ca                	cmp    %cl,%dl
  8008cd:	74 04                	je     8008d3 <strfind+0x1a>
  8008cf:	84 d2                	test   %dl,%dl
  8008d1:	75 f2                	jne    8008c5 <strfind+0xc>
			break;
	return (char *) s;
}
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	57                   	push   %edi
  8008d9:	56                   	push   %esi
  8008da:	53                   	push   %ebx
  8008db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008de:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e1:	85 c9                	test   %ecx,%ecx
  8008e3:	74 13                	je     8008f8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008eb:	75 05                	jne    8008f2 <memset+0x1d>
  8008ed:	f6 c1 03             	test   $0x3,%cl
  8008f0:	74 0d                	je     8008ff <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f5:	fc                   	cld    
  8008f6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008f8:	89 f8                	mov    %edi,%eax
  8008fa:	5b                   	pop    %ebx
  8008fb:	5e                   	pop    %esi
  8008fc:	5f                   	pop    %edi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    
		c &= 0xFF;
  8008ff:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800903:	89 d3                	mov    %edx,%ebx
  800905:	c1 e3 08             	shl    $0x8,%ebx
  800908:	89 d0                	mov    %edx,%eax
  80090a:	c1 e0 18             	shl    $0x18,%eax
  80090d:	89 d6                	mov    %edx,%esi
  80090f:	c1 e6 10             	shl    $0x10,%esi
  800912:	09 f0                	or     %esi,%eax
  800914:	09 c2                	or     %eax,%edx
  800916:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800918:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	fc                   	cld    
  80091e:	f3 ab                	rep stos %eax,%es:(%edi)
  800920:	eb d6                	jmp    8008f8 <memset+0x23>

00800922 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	57                   	push   %edi
  800926:	56                   	push   %esi
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800930:	39 c6                	cmp    %eax,%esi
  800932:	73 35                	jae    800969 <memmove+0x47>
  800934:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800937:	39 c2                	cmp    %eax,%edx
  800939:	76 2e                	jbe    800969 <memmove+0x47>
		s += n;
		d += n;
  80093b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093e:	89 d6                	mov    %edx,%esi
  800940:	09 fe                	or     %edi,%esi
  800942:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800948:	74 0c                	je     800956 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80094a:	83 ef 01             	sub    $0x1,%edi
  80094d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800950:	fd                   	std    
  800951:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800953:	fc                   	cld    
  800954:	eb 21                	jmp    800977 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800956:	f6 c1 03             	test   $0x3,%cl
  800959:	75 ef                	jne    80094a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80095b:	83 ef 04             	sub    $0x4,%edi
  80095e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800961:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800964:	fd                   	std    
  800965:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800967:	eb ea                	jmp    800953 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800969:	89 f2                	mov    %esi,%edx
  80096b:	09 c2                	or     %eax,%edx
  80096d:	f6 c2 03             	test   $0x3,%dl
  800970:	74 09                	je     80097b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800972:	89 c7                	mov    %eax,%edi
  800974:	fc                   	cld    
  800975:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800977:	5e                   	pop    %esi
  800978:	5f                   	pop    %edi
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097b:	f6 c1 03             	test   $0x3,%cl
  80097e:	75 f2                	jne    800972 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800980:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800983:	89 c7                	mov    %eax,%edi
  800985:	fc                   	cld    
  800986:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800988:	eb ed                	jmp    800977 <memmove+0x55>

0080098a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80098d:	ff 75 10             	pushl  0x10(%ebp)
  800990:	ff 75 0c             	pushl  0xc(%ebp)
  800993:	ff 75 08             	pushl  0x8(%ebp)
  800996:	e8 87 ff ff ff       	call   800922 <memmove>
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a8:	89 c6                	mov    %eax,%esi
  8009aa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ad:	39 f0                	cmp    %esi,%eax
  8009af:	74 1c                	je     8009cd <memcmp+0x30>
		if (*s1 != *s2)
  8009b1:	0f b6 08             	movzbl (%eax),%ecx
  8009b4:	0f b6 1a             	movzbl (%edx),%ebx
  8009b7:	38 d9                	cmp    %bl,%cl
  8009b9:	75 08                	jne    8009c3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	83 c2 01             	add    $0x1,%edx
  8009c1:	eb ea                	jmp    8009ad <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009c3:	0f b6 c1             	movzbl %cl,%eax
  8009c6:	0f b6 db             	movzbl %bl,%ebx
  8009c9:	29 d8                	sub    %ebx,%eax
  8009cb:	eb 05                	jmp    8009d2 <memcmp+0x35>
	}

	return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e4:	39 d0                	cmp    %edx,%eax
  8009e6:	73 09                	jae    8009f1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e8:	38 08                	cmp    %cl,(%eax)
  8009ea:	74 05                	je     8009f1 <memfind+0x1b>
	for (; s < ends; s++)
  8009ec:	83 c0 01             	add    $0x1,%eax
  8009ef:	eb f3                	jmp    8009e4 <memfind+0xe>
			break;
	return (void *) s;
}
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	57                   	push   %edi
  8009f7:	56                   	push   %esi
  8009f8:	53                   	push   %ebx
  8009f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ff:	eb 03                	jmp    800a04 <strtol+0x11>
		s++;
  800a01:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a04:	0f b6 01             	movzbl (%ecx),%eax
  800a07:	3c 20                	cmp    $0x20,%al
  800a09:	74 f6                	je     800a01 <strtol+0xe>
  800a0b:	3c 09                	cmp    $0x9,%al
  800a0d:	74 f2                	je     800a01 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a0f:	3c 2b                	cmp    $0x2b,%al
  800a11:	74 2e                	je     800a41 <strtol+0x4e>
	int neg = 0;
  800a13:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a18:	3c 2d                	cmp    $0x2d,%al
  800a1a:	74 2f                	je     800a4b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a1c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a22:	75 05                	jne    800a29 <strtol+0x36>
  800a24:	80 39 30             	cmpb   $0x30,(%ecx)
  800a27:	74 2c                	je     800a55 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	75 0a                	jne    800a37 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a2d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a32:	80 39 30             	cmpb   $0x30,(%ecx)
  800a35:	74 28                	je     800a5f <strtol+0x6c>
		base = 10;
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a3f:	eb 50                	jmp    800a91 <strtol+0x9e>
		s++;
  800a41:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a44:	bf 00 00 00 00       	mov    $0x0,%edi
  800a49:	eb d1                	jmp    800a1c <strtol+0x29>
		s++, neg = 1;
  800a4b:	83 c1 01             	add    $0x1,%ecx
  800a4e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a53:	eb c7                	jmp    800a1c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a55:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a59:	74 0e                	je     800a69 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	75 d8                	jne    800a37 <strtol+0x44>
		s++, base = 8;
  800a5f:	83 c1 01             	add    $0x1,%ecx
  800a62:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a67:	eb ce                	jmp    800a37 <strtol+0x44>
		s += 2, base = 16;
  800a69:	83 c1 02             	add    $0x2,%ecx
  800a6c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a71:	eb c4                	jmp    800a37 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a73:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a76:	89 f3                	mov    %esi,%ebx
  800a78:	80 fb 19             	cmp    $0x19,%bl
  800a7b:	77 29                	ja     800aa6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a7d:	0f be d2             	movsbl %dl,%edx
  800a80:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a83:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a86:	7d 30                	jge    800ab8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a88:	83 c1 01             	add    $0x1,%ecx
  800a8b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a8f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a91:	0f b6 11             	movzbl (%ecx),%edx
  800a94:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a97:	89 f3                	mov    %esi,%ebx
  800a99:	80 fb 09             	cmp    $0x9,%bl
  800a9c:	77 d5                	ja     800a73 <strtol+0x80>
			dig = *s - '0';
  800a9e:	0f be d2             	movsbl %dl,%edx
  800aa1:	83 ea 30             	sub    $0x30,%edx
  800aa4:	eb dd                	jmp    800a83 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800aa6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aa9:	89 f3                	mov    %esi,%ebx
  800aab:	80 fb 19             	cmp    $0x19,%bl
  800aae:	77 08                	ja     800ab8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ab0:	0f be d2             	movsbl %dl,%edx
  800ab3:	83 ea 37             	sub    $0x37,%edx
  800ab6:	eb cb                	jmp    800a83 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ab8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800abc:	74 05                	je     800ac3 <strtol+0xd0>
		*endptr = (char *) s;
  800abe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ac3:	89 c2                	mov    %eax,%edx
  800ac5:	f7 da                	neg    %edx
  800ac7:	85 ff                	test   %edi,%edi
  800ac9:	0f 45 c2             	cmovne %edx,%eax
}
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5f                   	pop    %edi
  800acf:	5d                   	pop    %ebp
  800ad0:	c3                   	ret    

00800ad1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	57                   	push   %edi
  800ad5:	56                   	push   %esi
  800ad6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  800adc:	8b 55 08             	mov    0x8(%ebp),%edx
  800adf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae2:	89 c3                	mov    %eax,%ebx
  800ae4:	89 c7                	mov    %eax,%edi
  800ae6:	89 c6                	mov    %eax,%esi
  800ae8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <sys_cgetc>:

int
sys_cgetc(void)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	57                   	push   %edi
  800af3:	56                   	push   %esi
  800af4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af5:	ba 00 00 00 00       	mov    $0x0,%edx
  800afa:	b8 01 00 00 00       	mov    $0x1,%eax
  800aff:	89 d1                	mov    %edx,%ecx
  800b01:	89 d3                	mov    %edx,%ebx
  800b03:	89 d7                	mov    %edx,%edi
  800b05:	89 d6                	mov    %edx,%esi
  800b07:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5f                   	pop    %edi
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
  800b11:	57                   	push   %edi
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b17:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b24:	89 cb                	mov    %ecx,%ebx
  800b26:	89 cf                	mov    %ecx,%edi
  800b28:	89 ce                	mov    %ecx,%esi
  800b2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b2c:	85 c0                	test   %eax,%eax
  800b2e:	7f 08                	jg     800b38 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	50                   	push   %eax
  800b3c:	6a 03                	push   $0x3
  800b3e:	68 1f 26 80 00       	push   $0x80261f
  800b43:	6a 23                	push   $0x23
  800b45:	68 3c 26 80 00       	push   $0x80263c
  800b4a:	e8 f9 13 00 00       	call   801f48 <_panic>

00800b4f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b55:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b5f:	89 d1                	mov    %edx,%ecx
  800b61:	89 d3                	mov    %edx,%ebx
  800b63:	89 d7                	mov    %edx,%edi
  800b65:	89 d6                	mov    %edx,%esi
  800b67:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b69:	5b                   	pop    %ebx
  800b6a:	5e                   	pop    %esi
  800b6b:	5f                   	pop    %edi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <sys_yield>:

void
sys_yield(void)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b7e:	89 d1                	mov    %edx,%ecx
  800b80:	89 d3                	mov    %edx,%ebx
  800b82:	89 d7                	mov    %edx,%edi
  800b84:	89 d6                	mov    %edx,%esi
  800b86:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
  800b93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b96:	be 00 00 00 00       	mov    $0x0,%esi
  800b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ba9:	89 f7                	mov    %esi,%edi
  800bab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bad:	85 c0                	test   %eax,%eax
  800baf:	7f 08                	jg     800bb9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb4:	5b                   	pop    %ebx
  800bb5:	5e                   	pop    %esi
  800bb6:	5f                   	pop    %edi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb9:	83 ec 0c             	sub    $0xc,%esp
  800bbc:	50                   	push   %eax
  800bbd:	6a 04                	push   $0x4
  800bbf:	68 1f 26 80 00       	push   $0x80261f
  800bc4:	6a 23                	push   $0x23
  800bc6:	68 3c 26 80 00       	push   $0x80263c
  800bcb:	e8 78 13 00 00       	call   801f48 <_panic>

00800bd0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	57                   	push   %edi
  800bd4:	56                   	push   %esi
  800bd5:	53                   	push   %ebx
  800bd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdf:	b8 05 00 00 00       	mov    $0x5,%eax
  800be4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bea:	8b 75 18             	mov    0x18(%ebp),%esi
  800bed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	7f 08                	jg     800bfb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bfb:	83 ec 0c             	sub    $0xc,%esp
  800bfe:	50                   	push   %eax
  800bff:	6a 05                	push   $0x5
  800c01:	68 1f 26 80 00       	push   $0x80261f
  800c06:	6a 23                	push   $0x23
  800c08:	68 3c 26 80 00       	push   $0x80263c
  800c0d:	e8 36 13 00 00       	call   801f48 <_panic>

00800c12 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c26:	b8 06 00 00 00       	mov    $0x6,%eax
  800c2b:	89 df                	mov    %ebx,%edi
  800c2d:	89 de                	mov    %ebx,%esi
  800c2f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	7f 08                	jg     800c3d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5f                   	pop    %edi
  800c3b:	5d                   	pop    %ebp
  800c3c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3d:	83 ec 0c             	sub    $0xc,%esp
  800c40:	50                   	push   %eax
  800c41:	6a 06                	push   $0x6
  800c43:	68 1f 26 80 00       	push   $0x80261f
  800c48:	6a 23                	push   $0x23
  800c4a:	68 3c 26 80 00       	push   $0x80263c
  800c4f:	e8 f4 12 00 00       	call   801f48 <_panic>

00800c54 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	b8 08 00 00 00       	mov    $0x8,%eax
  800c6d:	89 df                	mov    %ebx,%edi
  800c6f:	89 de                	mov    %ebx,%esi
  800c71:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	7f 08                	jg     800c7f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7f:	83 ec 0c             	sub    $0xc,%esp
  800c82:	50                   	push   %eax
  800c83:	6a 08                	push   $0x8
  800c85:	68 1f 26 80 00       	push   $0x80261f
  800c8a:	6a 23                	push   $0x23
  800c8c:	68 3c 26 80 00       	push   $0x80263c
  800c91:	e8 b2 12 00 00       	call   801f48 <_panic>

00800c96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
  800c9c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caa:	b8 09 00 00 00       	mov    $0x9,%eax
  800caf:	89 df                	mov    %ebx,%edi
  800cb1:	89 de                	mov    %ebx,%esi
  800cb3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	7f 08                	jg     800cc1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbc:	5b                   	pop    %ebx
  800cbd:	5e                   	pop    %esi
  800cbe:	5f                   	pop    %edi
  800cbf:	5d                   	pop    %ebp
  800cc0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc1:	83 ec 0c             	sub    $0xc,%esp
  800cc4:	50                   	push   %eax
  800cc5:	6a 09                	push   $0x9
  800cc7:	68 1f 26 80 00       	push   $0x80261f
  800ccc:	6a 23                	push   $0x23
  800cce:	68 3c 26 80 00       	push   $0x80263c
  800cd3:	e8 70 12 00 00       	call   801f48 <_panic>

00800cd8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf1:	89 df                	mov    %ebx,%edi
  800cf3:	89 de                	mov    %ebx,%esi
  800cf5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	7f 08                	jg     800d03 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	83 ec 0c             	sub    $0xc,%esp
  800d06:	50                   	push   %eax
  800d07:	6a 0a                	push   $0xa
  800d09:	68 1f 26 80 00       	push   $0x80261f
  800d0e:	6a 23                	push   $0x23
  800d10:	68 3c 26 80 00       	push   $0x80263c
  800d15:	e8 2e 12 00 00       	call   801f48 <_panic>

00800d1a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d20:	8b 55 08             	mov    0x8(%ebp),%edx
  800d23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d26:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d2b:	be 00 00 00 00       	mov    $0x0,%esi
  800d30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d36:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d53:	89 cb                	mov    %ecx,%ebx
  800d55:	89 cf                	mov    %ecx,%edi
  800d57:	89 ce                	mov    %ecx,%esi
  800d59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5b:	85 c0                	test   %eax,%eax
  800d5d:	7f 08                	jg     800d67 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	83 ec 0c             	sub    $0xc,%esp
  800d6a:	50                   	push   %eax
  800d6b:	6a 0d                	push   $0xd
  800d6d:	68 1f 26 80 00       	push   $0x80261f
  800d72:	6a 23                	push   $0x23
  800d74:	68 3c 26 80 00       	push   $0x80263c
  800d79:	e8 ca 11 00 00       	call   801f48 <_panic>

00800d7e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	57                   	push   %edi
  800d82:	56                   	push   %esi
  800d83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d84:	ba 00 00 00 00       	mov    $0x0,%edx
  800d89:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d8e:	89 d1                	mov    %edx,%ecx
  800d90:	89 d3                	mov    %edx,%ebx
  800d92:	89 d7                	mov    %edx,%edi
  800d94:	89 d6                	mov    %edx,%esi
  800d96:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  800da3:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800daa:	74 0a                	je     800db6 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  800db6:	a1 08 40 80 00       	mov    0x804008,%eax
  800dbb:	8b 40 48             	mov    0x48(%eax),%eax
  800dbe:	83 ec 04             	sub    $0x4,%esp
  800dc1:	6a 07                	push   $0x7
  800dc3:	68 00 f0 bf ee       	push   $0xeebff000
  800dc8:	50                   	push   %eax
  800dc9:	e8 bf fd ff ff       	call   800b8d <sys_page_alloc>
  800dce:	83 c4 10             	add    $0x10,%esp
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	78 1b                	js     800df0 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800dd5:	a1 08 40 80 00       	mov    0x804008,%eax
  800dda:	8b 40 48             	mov    0x48(%eax),%eax
  800ddd:	83 ec 08             	sub    $0x8,%esp
  800de0:	68 02 0e 80 00       	push   $0x800e02
  800de5:	50                   	push   %eax
  800de6:	e8 ed fe ff ff       	call   800cd8 <sys_env_set_pgfault_upcall>
  800deb:	83 c4 10             	add    $0x10,%esp
  800dee:	eb bc                	jmp    800dac <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  800df0:	50                   	push   %eax
  800df1:	68 4a 26 80 00       	push   $0x80264a
  800df6:	6a 22                	push   $0x22
  800df8:	68 62 26 80 00       	push   $0x802662
  800dfd:	e8 46 11 00 00       	call   801f48 <_panic>

00800e02 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e02:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e03:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e08:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e0a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  800e0d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  800e11:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  800e14:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  800e18:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  800e1c:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  800e1e:	83 c4 08             	add    $0x8,%esp
	popal
  800e21:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800e22:	83 c4 04             	add    $0x4,%esp
	popfl
  800e25:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800e26:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800e27:	c3                   	ret    

00800e28 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	05 00 00 00 30       	add    $0x30000000,%eax
  800e33:	c1 e8 0c             	shr    $0xc,%eax
}
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    

00800e38 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e48:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e55:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e5a:	89 c2                	mov    %eax,%edx
  800e5c:	c1 ea 16             	shr    $0x16,%edx
  800e5f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e66:	f6 c2 01             	test   $0x1,%dl
  800e69:	74 2a                	je     800e95 <fd_alloc+0x46>
  800e6b:	89 c2                	mov    %eax,%edx
  800e6d:	c1 ea 0c             	shr    $0xc,%edx
  800e70:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e77:	f6 c2 01             	test   $0x1,%dl
  800e7a:	74 19                	je     800e95 <fd_alloc+0x46>
  800e7c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e81:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e86:	75 d2                	jne    800e5a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e88:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e8e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e93:	eb 07                	jmp    800e9c <fd_alloc+0x4d>
			*fd_store = fd;
  800e95:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ea4:	83 f8 1f             	cmp    $0x1f,%eax
  800ea7:	77 36                	ja     800edf <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ea9:	c1 e0 0c             	shl    $0xc,%eax
  800eac:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800eb1:	89 c2                	mov    %eax,%edx
  800eb3:	c1 ea 16             	shr    $0x16,%edx
  800eb6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ebd:	f6 c2 01             	test   $0x1,%dl
  800ec0:	74 24                	je     800ee6 <fd_lookup+0x48>
  800ec2:	89 c2                	mov    %eax,%edx
  800ec4:	c1 ea 0c             	shr    $0xc,%edx
  800ec7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ece:	f6 c2 01             	test   $0x1,%dl
  800ed1:	74 1a                	je     800eed <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ed3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed6:	89 02                	mov    %eax,(%edx)
	return 0;
  800ed8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edd:	5d                   	pop    %ebp
  800ede:	c3                   	ret    
		return -E_INVAL;
  800edf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ee4:	eb f7                	jmp    800edd <fd_lookup+0x3f>
		return -E_INVAL;
  800ee6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800eeb:	eb f0                	jmp    800edd <fd_lookup+0x3f>
  800eed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ef2:	eb e9                	jmp    800edd <fd_lookup+0x3f>

00800ef4 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efd:	ba ec 26 80 00       	mov    $0x8026ec,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f02:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f07:	39 08                	cmp    %ecx,(%eax)
  800f09:	74 33                	je     800f3e <dev_lookup+0x4a>
  800f0b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f0e:	8b 02                	mov    (%edx),%eax
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 f3                	jne    800f07 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f14:	a1 08 40 80 00       	mov    0x804008,%eax
  800f19:	8b 40 48             	mov    0x48(%eax),%eax
  800f1c:	83 ec 04             	sub    $0x4,%esp
  800f1f:	51                   	push   %ecx
  800f20:	50                   	push   %eax
  800f21:	68 70 26 80 00       	push   $0x802670
  800f26:	e8 4a f2 ff ff       	call   800175 <cprintf>
	*dev = 0;
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f34:	83 c4 10             	add    $0x10,%esp
  800f37:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    
			*dev = devtab[i];
  800f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f41:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f43:	b8 00 00 00 00       	mov    $0x0,%eax
  800f48:	eb f2                	jmp    800f3c <dev_lookup+0x48>

00800f4a <fd_close>:
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 1c             	sub    $0x1c,%esp
  800f53:	8b 75 08             	mov    0x8(%ebp),%esi
  800f56:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f59:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f5c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f5d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f63:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f66:	50                   	push   %eax
  800f67:	e8 32 ff ff ff       	call   800e9e <fd_lookup>
  800f6c:	89 c3                	mov    %eax,%ebx
  800f6e:	83 c4 08             	add    $0x8,%esp
  800f71:	85 c0                	test   %eax,%eax
  800f73:	78 05                	js     800f7a <fd_close+0x30>
	    || fd != fd2)
  800f75:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f78:	74 16                	je     800f90 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f7a:	89 f8                	mov    %edi,%eax
  800f7c:	84 c0                	test   %al,%al
  800f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f83:	0f 44 d8             	cmove  %eax,%ebx
}
  800f86:	89 d8                	mov    %ebx,%eax
  800f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f8b:	5b                   	pop    %ebx
  800f8c:	5e                   	pop    %esi
  800f8d:	5f                   	pop    %edi
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f90:	83 ec 08             	sub    $0x8,%esp
  800f93:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f96:	50                   	push   %eax
  800f97:	ff 36                	pushl  (%esi)
  800f99:	e8 56 ff ff ff       	call   800ef4 <dev_lookup>
  800f9e:	89 c3                	mov    %eax,%ebx
  800fa0:	83 c4 10             	add    $0x10,%esp
  800fa3:	85 c0                	test   %eax,%eax
  800fa5:	78 15                	js     800fbc <fd_close+0x72>
		if (dev->dev_close)
  800fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800faa:	8b 40 10             	mov    0x10(%eax),%eax
  800fad:	85 c0                	test   %eax,%eax
  800faf:	74 1b                	je     800fcc <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fb1:	83 ec 0c             	sub    $0xc,%esp
  800fb4:	56                   	push   %esi
  800fb5:	ff d0                	call   *%eax
  800fb7:	89 c3                	mov    %eax,%ebx
  800fb9:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fbc:	83 ec 08             	sub    $0x8,%esp
  800fbf:	56                   	push   %esi
  800fc0:	6a 00                	push   $0x0
  800fc2:	e8 4b fc ff ff       	call   800c12 <sys_page_unmap>
	return r;
  800fc7:	83 c4 10             	add    $0x10,%esp
  800fca:	eb ba                	jmp    800f86 <fd_close+0x3c>
			r = 0;
  800fcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd1:	eb e9                	jmp    800fbc <fd_close+0x72>

00800fd3 <close>:

int
close(int fdnum)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fdc:	50                   	push   %eax
  800fdd:	ff 75 08             	pushl  0x8(%ebp)
  800fe0:	e8 b9 fe ff ff       	call   800e9e <fd_lookup>
  800fe5:	83 c4 08             	add    $0x8,%esp
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	78 10                	js     800ffc <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	6a 01                	push   $0x1
  800ff1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff4:	e8 51 ff ff ff       	call   800f4a <fd_close>
  800ff9:	83 c4 10             	add    $0x10,%esp
}
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <close_all>:

void
close_all(void)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	53                   	push   %ebx
  801002:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801005:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	53                   	push   %ebx
  80100e:	e8 c0 ff ff ff       	call   800fd3 <close>
	for (i = 0; i < MAXFD; i++)
  801013:	83 c3 01             	add    $0x1,%ebx
  801016:	83 c4 10             	add    $0x10,%esp
  801019:	83 fb 20             	cmp    $0x20,%ebx
  80101c:	75 ec                	jne    80100a <close_all+0xc>
}
  80101e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801021:	c9                   	leave  
  801022:	c3                   	ret    

00801023 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
  801029:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80102c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80102f:	50                   	push   %eax
  801030:	ff 75 08             	pushl  0x8(%ebp)
  801033:	e8 66 fe ff ff       	call   800e9e <fd_lookup>
  801038:	89 c3                	mov    %eax,%ebx
  80103a:	83 c4 08             	add    $0x8,%esp
  80103d:	85 c0                	test   %eax,%eax
  80103f:	0f 88 81 00 00 00    	js     8010c6 <dup+0xa3>
		return r;
	close(newfdnum);
  801045:	83 ec 0c             	sub    $0xc,%esp
  801048:	ff 75 0c             	pushl  0xc(%ebp)
  80104b:	e8 83 ff ff ff       	call   800fd3 <close>

	newfd = INDEX2FD(newfdnum);
  801050:	8b 75 0c             	mov    0xc(%ebp),%esi
  801053:	c1 e6 0c             	shl    $0xc,%esi
  801056:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80105c:	83 c4 04             	add    $0x4,%esp
  80105f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801062:	e8 d1 fd ff ff       	call   800e38 <fd2data>
  801067:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801069:	89 34 24             	mov    %esi,(%esp)
  80106c:	e8 c7 fd ff ff       	call   800e38 <fd2data>
  801071:	83 c4 10             	add    $0x10,%esp
  801074:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801076:	89 d8                	mov    %ebx,%eax
  801078:	c1 e8 16             	shr    $0x16,%eax
  80107b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801082:	a8 01                	test   $0x1,%al
  801084:	74 11                	je     801097 <dup+0x74>
  801086:	89 d8                	mov    %ebx,%eax
  801088:	c1 e8 0c             	shr    $0xc,%eax
  80108b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801092:	f6 c2 01             	test   $0x1,%dl
  801095:	75 39                	jne    8010d0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801097:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80109a:	89 d0                	mov    %edx,%eax
  80109c:	c1 e8 0c             	shr    $0xc,%eax
  80109f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8010ae:	50                   	push   %eax
  8010af:	56                   	push   %esi
  8010b0:	6a 00                	push   $0x0
  8010b2:	52                   	push   %edx
  8010b3:	6a 00                	push   $0x0
  8010b5:	e8 16 fb ff ff       	call   800bd0 <sys_page_map>
  8010ba:	89 c3                	mov    %eax,%ebx
  8010bc:	83 c4 20             	add    $0x20,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	78 31                	js     8010f4 <dup+0xd1>
		goto err;

	return newfdnum;
  8010c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010c6:	89 d8                	mov    %ebx,%eax
  8010c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010cb:	5b                   	pop    %ebx
  8010cc:	5e                   	pop    %esi
  8010cd:	5f                   	pop    %edi
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	25 07 0e 00 00       	and    $0xe07,%eax
  8010df:	50                   	push   %eax
  8010e0:	57                   	push   %edi
  8010e1:	6a 00                	push   $0x0
  8010e3:	53                   	push   %ebx
  8010e4:	6a 00                	push   $0x0
  8010e6:	e8 e5 fa ff ff       	call   800bd0 <sys_page_map>
  8010eb:	89 c3                	mov    %eax,%ebx
  8010ed:	83 c4 20             	add    $0x20,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	79 a3                	jns    801097 <dup+0x74>
	sys_page_unmap(0, newfd);
  8010f4:	83 ec 08             	sub    $0x8,%esp
  8010f7:	56                   	push   %esi
  8010f8:	6a 00                	push   $0x0
  8010fa:	e8 13 fb ff ff       	call   800c12 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010ff:	83 c4 08             	add    $0x8,%esp
  801102:	57                   	push   %edi
  801103:	6a 00                	push   $0x0
  801105:	e8 08 fb ff ff       	call   800c12 <sys_page_unmap>
	return r;
  80110a:	83 c4 10             	add    $0x10,%esp
  80110d:	eb b7                	jmp    8010c6 <dup+0xa3>

0080110f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	53                   	push   %ebx
  801113:	83 ec 14             	sub    $0x14,%esp
  801116:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801119:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80111c:	50                   	push   %eax
  80111d:	53                   	push   %ebx
  80111e:	e8 7b fd ff ff       	call   800e9e <fd_lookup>
  801123:	83 c4 08             	add    $0x8,%esp
  801126:	85 c0                	test   %eax,%eax
  801128:	78 3f                	js     801169 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80112a:	83 ec 08             	sub    $0x8,%esp
  80112d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801130:	50                   	push   %eax
  801131:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801134:	ff 30                	pushl  (%eax)
  801136:	e8 b9 fd ff ff       	call   800ef4 <dev_lookup>
  80113b:	83 c4 10             	add    $0x10,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	78 27                	js     801169 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801142:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801145:	8b 42 08             	mov    0x8(%edx),%eax
  801148:	83 e0 03             	and    $0x3,%eax
  80114b:	83 f8 01             	cmp    $0x1,%eax
  80114e:	74 1e                	je     80116e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8b 40 08             	mov    0x8(%eax),%eax
  801156:	85 c0                	test   %eax,%eax
  801158:	74 35                	je     80118f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80115a:	83 ec 04             	sub    $0x4,%esp
  80115d:	ff 75 10             	pushl  0x10(%ebp)
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	52                   	push   %edx
  801164:	ff d0                	call   *%eax
  801166:	83 c4 10             	add    $0x10,%esp
}
  801169:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80116e:	a1 08 40 80 00       	mov    0x804008,%eax
  801173:	8b 40 48             	mov    0x48(%eax),%eax
  801176:	83 ec 04             	sub    $0x4,%esp
  801179:	53                   	push   %ebx
  80117a:	50                   	push   %eax
  80117b:	68 b1 26 80 00       	push   $0x8026b1
  801180:	e8 f0 ef ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118d:	eb da                	jmp    801169 <read+0x5a>
		return -E_NOT_SUPP;
  80118f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801194:	eb d3                	jmp    801169 <read+0x5a>

00801196 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011aa:	39 f3                	cmp    %esi,%ebx
  8011ac:	73 25                	jae    8011d3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	89 f0                	mov    %esi,%eax
  8011b3:	29 d8                	sub    %ebx,%eax
  8011b5:	50                   	push   %eax
  8011b6:	89 d8                	mov    %ebx,%eax
  8011b8:	03 45 0c             	add    0xc(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	57                   	push   %edi
  8011bd:	e8 4d ff ff ff       	call   80110f <read>
		if (m < 0)
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	78 08                	js     8011d1 <readn+0x3b>
			return m;
		if (m == 0)
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	74 06                	je     8011d3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011cd:	01 c3                	add    %eax,%ebx
  8011cf:	eb d9                	jmp    8011aa <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011d1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011d3:	89 d8                	mov    %ebx,%eax
  8011d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 14             	sub    $0x14,%esp
  8011e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011ea:	50                   	push   %eax
  8011eb:	53                   	push   %ebx
  8011ec:	e8 ad fc ff ff       	call   800e9e <fd_lookup>
  8011f1:	83 c4 08             	add    $0x8,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	78 3a                	js     801232 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801202:	ff 30                	pushl  (%eax)
  801204:	e8 eb fc ff ff       	call   800ef4 <dev_lookup>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 22                	js     801232 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801213:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801217:	74 1e                	je     801237 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121c:	8b 52 0c             	mov    0xc(%edx),%edx
  80121f:	85 d2                	test   %edx,%edx
  801221:	74 35                	je     801258 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801223:	83 ec 04             	sub    $0x4,%esp
  801226:	ff 75 10             	pushl  0x10(%ebp)
  801229:	ff 75 0c             	pushl  0xc(%ebp)
  80122c:	50                   	push   %eax
  80122d:	ff d2                	call   *%edx
  80122f:	83 c4 10             	add    $0x10,%esp
}
  801232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801235:	c9                   	leave  
  801236:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801237:	a1 08 40 80 00       	mov    0x804008,%eax
  80123c:	8b 40 48             	mov    0x48(%eax),%eax
  80123f:	83 ec 04             	sub    $0x4,%esp
  801242:	53                   	push   %ebx
  801243:	50                   	push   %eax
  801244:	68 cd 26 80 00       	push   $0x8026cd
  801249:	e8 27 ef ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  80124e:	83 c4 10             	add    $0x10,%esp
  801251:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801256:	eb da                	jmp    801232 <write+0x55>
		return -E_NOT_SUPP;
  801258:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80125d:	eb d3                	jmp    801232 <write+0x55>

0080125f <seek>:

int
seek(int fdnum, off_t offset)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801265:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801268:	50                   	push   %eax
  801269:	ff 75 08             	pushl  0x8(%ebp)
  80126c:	e8 2d fc ff ff       	call   800e9e <fd_lookup>
  801271:	83 c4 08             	add    $0x8,%esp
  801274:	85 c0                	test   %eax,%eax
  801276:	78 0e                	js     801286 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80127e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801286:	c9                   	leave  
  801287:	c3                   	ret    

00801288 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	53                   	push   %ebx
  80128c:	83 ec 14             	sub    $0x14,%esp
  80128f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801292:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801295:	50                   	push   %eax
  801296:	53                   	push   %ebx
  801297:	e8 02 fc ff ff       	call   800e9e <fd_lookup>
  80129c:	83 c4 08             	add    $0x8,%esp
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	78 37                	js     8012da <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012a3:	83 ec 08             	sub    $0x8,%esp
  8012a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a9:	50                   	push   %eax
  8012aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ad:	ff 30                	pushl  (%eax)
  8012af:	e8 40 fc ff ff       	call   800ef4 <dev_lookup>
  8012b4:	83 c4 10             	add    $0x10,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	78 1f                	js     8012da <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012be:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012c2:	74 1b                	je     8012df <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012c7:	8b 52 18             	mov    0x18(%edx),%edx
  8012ca:	85 d2                	test   %edx,%edx
  8012cc:	74 32                	je     801300 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012ce:	83 ec 08             	sub    $0x8,%esp
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	50                   	push   %eax
  8012d5:	ff d2                	call   *%edx
  8012d7:	83 c4 10             	add    $0x10,%esp
}
  8012da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012df:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012e4:	8b 40 48             	mov    0x48(%eax),%eax
  8012e7:	83 ec 04             	sub    $0x4,%esp
  8012ea:	53                   	push   %ebx
  8012eb:	50                   	push   %eax
  8012ec:	68 90 26 80 00       	push   $0x802690
  8012f1:	e8 7f ee ff ff       	call   800175 <cprintf>
		return -E_INVAL;
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fe:	eb da                	jmp    8012da <ftruncate+0x52>
		return -E_NOT_SUPP;
  801300:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801305:	eb d3                	jmp    8012da <ftruncate+0x52>

00801307 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	53                   	push   %ebx
  80130b:	83 ec 14             	sub    $0x14,%esp
  80130e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801314:	50                   	push   %eax
  801315:	ff 75 08             	pushl  0x8(%ebp)
  801318:	e8 81 fb ff ff       	call   800e9e <fd_lookup>
  80131d:	83 c4 08             	add    $0x8,%esp
  801320:	85 c0                	test   %eax,%eax
  801322:	78 4b                	js     80136f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801324:	83 ec 08             	sub    $0x8,%esp
  801327:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132e:	ff 30                	pushl  (%eax)
  801330:	e8 bf fb ff ff       	call   800ef4 <dev_lookup>
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 33                	js     80136f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801343:	74 2f                	je     801374 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801345:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801348:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80134f:	00 00 00 
	stat->st_isdir = 0;
  801352:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801359:	00 00 00 
	stat->st_dev = dev;
  80135c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	53                   	push   %ebx
  801366:	ff 75 f0             	pushl  -0x10(%ebp)
  801369:	ff 50 14             	call   *0x14(%eax)
  80136c:	83 c4 10             	add    $0x10,%esp
}
  80136f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801372:	c9                   	leave  
  801373:	c3                   	ret    
		return -E_NOT_SUPP;
  801374:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801379:	eb f4                	jmp    80136f <fstat+0x68>

0080137b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801380:	83 ec 08             	sub    $0x8,%esp
  801383:	6a 00                	push   $0x0
  801385:	ff 75 08             	pushl  0x8(%ebp)
  801388:	e8 e7 01 00 00       	call   801574 <open>
  80138d:	89 c3                	mov    %eax,%ebx
  80138f:	83 c4 10             	add    $0x10,%esp
  801392:	85 c0                	test   %eax,%eax
  801394:	78 1b                	js     8013b1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801396:	83 ec 08             	sub    $0x8,%esp
  801399:	ff 75 0c             	pushl  0xc(%ebp)
  80139c:	50                   	push   %eax
  80139d:	e8 65 ff ff ff       	call   801307 <fstat>
  8013a2:	89 c6                	mov    %eax,%esi
	close(fd);
  8013a4:	89 1c 24             	mov    %ebx,(%esp)
  8013a7:	e8 27 fc ff ff       	call   800fd3 <close>
	return r;
  8013ac:	83 c4 10             	add    $0x10,%esp
  8013af:	89 f3                	mov    %esi,%ebx
}
  8013b1:	89 d8                	mov    %ebx,%eax
  8013b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b6:	5b                   	pop    %ebx
  8013b7:	5e                   	pop    %esi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	56                   	push   %esi
  8013be:	53                   	push   %ebx
  8013bf:	89 c6                	mov    %eax,%esi
  8013c1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013c3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013ca:	74 27                	je     8013f3 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013cc:	6a 07                	push   $0x7
  8013ce:	68 00 50 80 00       	push   $0x805000
  8013d3:	56                   	push   %esi
  8013d4:	ff 35 00 40 80 00    	pushl  0x804000
  8013da:	e8 16 0c 00 00       	call   801ff5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013df:	83 c4 0c             	add    $0xc,%esp
  8013e2:	6a 00                	push   $0x0
  8013e4:	53                   	push   %ebx
  8013e5:	6a 00                	push   $0x0
  8013e7:	e8 a2 0b 00 00       	call   801f8e <ipc_recv>
}
  8013ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013ef:	5b                   	pop    %ebx
  8013f0:	5e                   	pop    %esi
  8013f1:	5d                   	pop    %ebp
  8013f2:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8013f3:	83 ec 0c             	sub    $0xc,%esp
  8013f6:	6a 01                	push   $0x1
  8013f8:	e8 4c 0c 00 00       	call   802049 <ipc_find_env>
  8013fd:	a3 00 40 80 00       	mov    %eax,0x804000
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	eb c5                	jmp    8013cc <fsipc+0x12>

00801407 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	8b 40 0c             	mov    0xc(%eax),%eax
  801413:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801420:	ba 00 00 00 00       	mov    $0x0,%edx
  801425:	b8 02 00 00 00       	mov    $0x2,%eax
  80142a:	e8 8b ff ff ff       	call   8013ba <fsipc>
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <devfile_flush>:
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	8b 40 0c             	mov    0xc(%eax),%eax
  80143d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801442:	ba 00 00 00 00       	mov    $0x0,%edx
  801447:	b8 06 00 00 00       	mov    $0x6,%eax
  80144c:	e8 69 ff ff ff       	call   8013ba <fsipc>
}
  801451:	c9                   	leave  
  801452:	c3                   	ret    

00801453 <devfile_stat>:
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	53                   	push   %ebx
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8b 40 0c             	mov    0xc(%eax),%eax
  801463:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801468:	ba 00 00 00 00       	mov    $0x0,%edx
  80146d:	b8 05 00 00 00       	mov    $0x5,%eax
  801472:	e8 43 ff ff ff       	call   8013ba <fsipc>
  801477:	85 c0                	test   %eax,%eax
  801479:	78 2c                	js     8014a7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	68 00 50 80 00       	push   $0x805000
  801483:	53                   	push   %ebx
  801484:	e8 0b f3 ff ff       	call   800794 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801489:	a1 80 50 80 00       	mov    0x805080,%eax
  80148e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801494:	a1 84 50 80 00       	mov    0x805084,%eax
  801499:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80149f:	83 c4 10             	add    $0x10,%esp
  8014a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <devfile_write>:
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 0c             	sub    $0xc,%esp
  8014b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b5:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014ba:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014bf:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c8:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8014ce:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014d3:	50                   	push   %eax
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	68 08 50 80 00       	push   $0x805008
  8014dc:	e8 41 f4 ff ff       	call   800922 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8014e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e6:	b8 04 00 00 00       	mov    $0x4,%eax
  8014eb:	e8 ca fe ff ff       	call   8013ba <fsipc>
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <devfile_read>:
{
  8014f2:	55                   	push   %ebp
  8014f3:	89 e5                	mov    %esp,%ebp
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
  8014f7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801500:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801505:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80150b:	ba 00 00 00 00       	mov    $0x0,%edx
  801510:	b8 03 00 00 00       	mov    $0x3,%eax
  801515:	e8 a0 fe ff ff       	call   8013ba <fsipc>
  80151a:	89 c3                	mov    %eax,%ebx
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 1f                	js     80153f <devfile_read+0x4d>
	assert(r <= n);
  801520:	39 f0                	cmp    %esi,%eax
  801522:	77 24                	ja     801548 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801524:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801529:	7f 33                	jg     80155e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	50                   	push   %eax
  80152f:	68 00 50 80 00       	push   $0x805000
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	e8 e6 f3 ff ff       	call   800922 <memmove>
	return r;
  80153c:	83 c4 10             	add    $0x10,%esp
}
  80153f:	89 d8                	mov    %ebx,%eax
  801541:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801544:	5b                   	pop    %ebx
  801545:	5e                   	pop    %esi
  801546:	5d                   	pop    %ebp
  801547:	c3                   	ret    
	assert(r <= n);
  801548:	68 00 27 80 00       	push   $0x802700
  80154d:	68 07 27 80 00       	push   $0x802707
  801552:	6a 7b                	push   $0x7b
  801554:	68 1c 27 80 00       	push   $0x80271c
  801559:	e8 ea 09 00 00       	call   801f48 <_panic>
	assert(r <= PGSIZE);
  80155e:	68 27 27 80 00       	push   $0x802727
  801563:	68 07 27 80 00       	push   $0x802707
  801568:	6a 7c                	push   $0x7c
  80156a:	68 1c 27 80 00       	push   $0x80271c
  80156f:	e8 d4 09 00 00       	call   801f48 <_panic>

00801574 <open>:
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	56                   	push   %esi
  801578:	53                   	push   %ebx
  801579:	83 ec 1c             	sub    $0x1c,%esp
  80157c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80157f:	56                   	push   %esi
  801580:	e8 d8 f1 ff ff       	call   80075d <strlen>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80158d:	7f 6c                	jg     8015fb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80158f:	83 ec 0c             	sub    $0xc,%esp
  801592:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	e8 b4 f8 ff ff       	call   800e4f <fd_alloc>
  80159b:	89 c3                	mov    %eax,%ebx
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 3c                	js     8015e0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	56                   	push   %esi
  8015a8:	68 00 50 80 00       	push   $0x805000
  8015ad:	e8 e2 f1 ff ff       	call   800794 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8015ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015c2:	e8 f3 fd ff ff       	call   8013ba <fsipc>
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 19                	js     8015e9 <open+0x75>
	return fd2num(fd);
  8015d0:	83 ec 0c             	sub    $0xc,%esp
  8015d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d6:	e8 4d f8 ff ff       	call   800e28 <fd2num>
  8015db:	89 c3                	mov    %eax,%ebx
  8015dd:	83 c4 10             	add    $0x10,%esp
}
  8015e0:	89 d8                	mov    %ebx,%eax
  8015e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    
		fd_close(fd, 0);
  8015e9:	83 ec 08             	sub    $0x8,%esp
  8015ec:	6a 00                	push   $0x0
  8015ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f1:	e8 54 f9 ff ff       	call   800f4a <fd_close>
		return r;
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	eb e5                	jmp    8015e0 <open+0x6c>
		return -E_BAD_PATH;
  8015fb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801600:	eb de                	jmp    8015e0 <open+0x6c>

00801602 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	b8 08 00 00 00       	mov    $0x8,%eax
  801612:	e8 a3 fd ff ff       	call   8013ba <fsipc>
}
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80161f:	68 33 27 80 00       	push   $0x802733
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	e8 68 f1 ff ff       	call   800794 <strcpy>
	return 0;
}
  80162c:	b8 00 00 00 00       	mov    $0x0,%eax
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <devsock_close>:
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	53                   	push   %ebx
  801637:	83 ec 10             	sub    $0x10,%esp
  80163a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80163d:	53                   	push   %ebx
  80163e:	e8 3f 0a 00 00       	call   802082 <pageref>
  801643:	83 c4 10             	add    $0x10,%esp
		return 0;
  801646:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80164b:	83 f8 01             	cmp    $0x1,%eax
  80164e:	74 07                	je     801657 <devsock_close+0x24>
}
  801650:	89 d0                	mov    %edx,%eax
  801652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801655:	c9                   	leave  
  801656:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801657:	83 ec 0c             	sub    $0xc,%esp
  80165a:	ff 73 0c             	pushl  0xc(%ebx)
  80165d:	e8 b7 02 00 00       	call   801919 <nsipc_close>
  801662:	89 c2                	mov    %eax,%edx
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	eb e7                	jmp    801650 <devsock_close+0x1d>

00801669 <devsock_write>:
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80166f:	6a 00                	push   $0x0
  801671:	ff 75 10             	pushl  0x10(%ebp)
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	ff 70 0c             	pushl  0xc(%eax)
  80167d:	e8 74 03 00 00       	call   8019f6 <nsipc_send>
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <devsock_read>:
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 10             	pushl  0x10(%ebp)
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	ff 70 0c             	pushl  0xc(%eax)
  801698:	e8 ed 02 00 00       	call   80198a <nsipc_recv>
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <fd2sockid>:
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	e8 ef f7 ff ff       	call   800e9e <fd_lookup>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	85 c0                	test   %eax,%eax
  8016b4:	78 10                	js     8016c6 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b9:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016bf:	39 08                	cmp    %ecx,(%eax)
  8016c1:	75 05                	jne    8016c8 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016c3:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    
		return -E_NOT_SUPP;
  8016c8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cd:	eb f7                	jmp    8016c6 <fd2sockid+0x27>

008016cf <alloc_sockfd>:
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
  8016d4:	83 ec 1c             	sub    $0x1c,%esp
  8016d7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8016d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016dc:	50                   	push   %eax
  8016dd:	e8 6d f7 ff ff       	call   800e4f <fd_alloc>
  8016e2:	89 c3                	mov    %eax,%ebx
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	78 43                	js     80172e <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	68 07 04 00 00       	push   $0x407
  8016f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f6:	6a 00                	push   $0x0
  8016f8:	e8 90 f4 ff ff       	call   800b8d <sys_page_alloc>
  8016fd:	89 c3                	mov    %eax,%ebx
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	85 c0                	test   %eax,%eax
  801704:	78 28                	js     80172e <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801709:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80170f:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801714:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80171b:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80171e:	83 ec 0c             	sub    $0xc,%esp
  801721:	50                   	push   %eax
  801722:	e8 01 f7 ff ff       	call   800e28 <fd2num>
  801727:	89 c3                	mov    %eax,%ebx
  801729:	83 c4 10             	add    $0x10,%esp
  80172c:	eb 0c                	jmp    80173a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80172e:	83 ec 0c             	sub    $0xc,%esp
  801731:	56                   	push   %esi
  801732:	e8 e2 01 00 00       	call   801919 <nsipc_close>
		return r;
  801737:	83 c4 10             	add    $0x10,%esp
}
  80173a:	89 d8                	mov    %ebx,%eax
  80173c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    

00801743 <accept>:
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	e8 4e ff ff ff       	call   80169f <fd2sockid>
  801751:	85 c0                	test   %eax,%eax
  801753:	78 1b                	js     801770 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801755:	83 ec 04             	sub    $0x4,%esp
  801758:	ff 75 10             	pushl  0x10(%ebp)
  80175b:	ff 75 0c             	pushl  0xc(%ebp)
  80175e:	50                   	push   %eax
  80175f:	e8 0e 01 00 00       	call   801872 <nsipc_accept>
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	85 c0                	test   %eax,%eax
  801769:	78 05                	js     801770 <accept+0x2d>
	return alloc_sockfd(r);
  80176b:	e8 5f ff ff ff       	call   8016cf <alloc_sockfd>
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <bind>:
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	e8 1f ff ff ff       	call   80169f <fd2sockid>
  801780:	85 c0                	test   %eax,%eax
  801782:	78 12                	js     801796 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	ff 75 10             	pushl  0x10(%ebp)
  80178a:	ff 75 0c             	pushl  0xc(%ebp)
  80178d:	50                   	push   %eax
  80178e:	e8 2f 01 00 00       	call   8018c2 <nsipc_bind>
  801793:	83 c4 10             	add    $0x10,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <shutdown>:
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	e8 f9 fe ff ff       	call   80169f <fd2sockid>
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	78 0f                	js     8017b9 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	50                   	push   %eax
  8017b1:	e8 41 01 00 00       	call   8018f7 <nsipc_shutdown>
  8017b6:	83 c4 10             	add    $0x10,%esp
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <connect>:
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	e8 d6 fe ff ff       	call   80169f <fd2sockid>
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 12                	js     8017df <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	ff 75 10             	pushl  0x10(%ebp)
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	50                   	push   %eax
  8017d7:	e8 57 01 00 00       	call   801933 <nsipc_connect>
  8017dc:	83 c4 10             	add    $0x10,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <listen>:
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	e8 b0 fe ff ff       	call   80169f <fd2sockid>
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 0f                	js     801802 <listen+0x21>
	return nsipc_listen(r, backlog);
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	ff 75 0c             	pushl  0xc(%ebp)
  8017f9:	50                   	push   %eax
  8017fa:	e8 69 01 00 00       	call   801968 <nsipc_listen>
  8017ff:	83 c4 10             	add    $0x10,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <socket>:

int
socket(int domain, int type, int protocol)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80180a:	ff 75 10             	pushl  0x10(%ebp)
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	e8 3c 02 00 00       	call   801a54 <nsipc_socket>
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 05                	js     801824 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80181f:	e8 ab fe ff ff       	call   8016cf <alloc_sockfd>
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	53                   	push   %ebx
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80182f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801836:	74 26                	je     80185e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801838:	6a 07                	push   $0x7
  80183a:	68 00 60 80 00       	push   $0x806000
  80183f:	53                   	push   %ebx
  801840:	ff 35 04 40 80 00    	pushl  0x804004
  801846:	e8 aa 07 00 00       	call   801ff5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  80184b:	83 c4 0c             	add    $0xc,%esp
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	e8 35 07 00 00       	call   801f8e <ipc_recv>
}
  801859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  80185e:	83 ec 0c             	sub    $0xc,%esp
  801861:	6a 02                	push   $0x2
  801863:	e8 e1 07 00 00       	call   802049 <ipc_find_env>
  801868:	a3 04 40 80 00       	mov    %eax,0x804004
  80186d:	83 c4 10             	add    $0x10,%esp
  801870:	eb c6                	jmp    801838 <nsipc+0x12>

00801872 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	56                   	push   %esi
  801876:	53                   	push   %ebx
  801877:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801882:	8b 06                	mov    (%esi),%eax
  801884:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801889:	b8 01 00 00 00       	mov    $0x1,%eax
  80188e:	e8 93 ff ff ff       	call   801826 <nsipc>
  801893:	89 c3                	mov    %eax,%ebx
  801895:	85 c0                	test   %eax,%eax
  801897:	78 20                	js     8018b9 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	ff 35 10 60 80 00    	pushl  0x806010
  8018a2:	68 00 60 80 00       	push   $0x806000
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	e8 73 f0 ff ff       	call   800922 <memmove>
		*addrlen = ret->ret_addrlen;
  8018af:	a1 10 60 80 00       	mov    0x806010,%eax
  8018b4:	89 06                	mov    %eax,(%esi)
  8018b6:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8018b9:	89 d8                	mov    %ebx,%eax
  8018bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5e                   	pop    %esi
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 08             	sub    $0x8,%esp
  8018c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8018d4:	53                   	push   %ebx
  8018d5:	ff 75 0c             	pushl  0xc(%ebp)
  8018d8:	68 04 60 80 00       	push   $0x806004
  8018dd:	e8 40 f0 ff ff       	call   800922 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8018e2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8018e8:	b8 02 00 00 00       	mov    $0x2,%eax
  8018ed:	e8 34 ff ff ff       	call   801826 <nsipc>
}
  8018f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801905:	8b 45 0c             	mov    0xc(%ebp),%eax
  801908:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  80190d:	b8 03 00 00 00       	mov    $0x3,%eax
  801912:	e8 0f ff ff ff       	call   801826 <nsipc>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <nsipc_close>:

int
nsipc_close(int s)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801927:	b8 04 00 00 00       	mov    $0x4,%eax
  80192c:	e8 f5 fe ff ff       	call   801826 <nsipc>
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	53                   	push   %ebx
  801937:	83 ec 08             	sub    $0x8,%esp
  80193a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801945:	53                   	push   %ebx
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	68 04 60 80 00       	push   $0x806004
  80194e:	e8 cf ef ff ff       	call   800922 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801953:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801959:	b8 05 00 00 00       	mov    $0x5,%eax
  80195e:	e8 c3 fe ff ff       	call   801826 <nsipc>
}
  801963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801976:	8b 45 0c             	mov    0xc(%ebp),%eax
  801979:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80197e:	b8 06 00 00 00       	mov    $0x6,%eax
  801983:	e8 9e fe ff ff       	call   801826 <nsipc>
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	56                   	push   %esi
  80198e:	53                   	push   %ebx
  80198f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80199a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8019a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a3:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8019a8:	b8 07 00 00 00       	mov    $0x7,%eax
  8019ad:	e8 74 fe ff ff       	call   801826 <nsipc>
  8019b2:	89 c3                	mov    %eax,%ebx
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	78 1f                	js     8019d7 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8019b8:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8019bd:	7f 21                	jg     8019e0 <nsipc_recv+0x56>
  8019bf:	39 c6                	cmp    %eax,%esi
  8019c1:	7c 1d                	jl     8019e0 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	50                   	push   %eax
  8019c7:	68 00 60 80 00       	push   $0x806000
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	e8 4e ef ff ff       	call   800922 <memmove>
  8019d4:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8019d7:	89 d8                	mov    %ebx,%eax
  8019d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019dc:	5b                   	pop    %ebx
  8019dd:	5e                   	pop    %esi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8019e0:	68 3f 27 80 00       	push   $0x80273f
  8019e5:	68 07 27 80 00       	push   $0x802707
  8019ea:	6a 62                	push   $0x62
  8019ec:	68 54 27 80 00       	push   $0x802754
  8019f1:	e8 52 05 00 00       	call   801f48 <_panic>

008019f6 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	53                   	push   %ebx
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a08:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a0e:	7f 2e                	jg     801a3e <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	53                   	push   %ebx
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	68 0c 60 80 00       	push   $0x80600c
  801a1c:	e8 01 ef ff ff       	call   800922 <memmove>
	nsipcbuf.send.req_size = size;
  801a21:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801a27:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801a2f:	b8 08 00 00 00       	mov    $0x8,%eax
  801a34:	e8 ed fd ff ff       	call   801826 <nsipc>
}
  801a39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    
	assert(size < 1600);
  801a3e:	68 60 27 80 00       	push   $0x802760
  801a43:	68 07 27 80 00       	push   $0x802707
  801a48:	6a 6d                	push   $0x6d
  801a4a:	68 54 27 80 00       	push   $0x802754
  801a4f:	e8 f4 04 00 00       	call   801f48 <_panic>

00801a54 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a65:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801a72:	b8 09 00 00 00       	mov    $0x9,%eax
  801a77:	e8 aa fd ff ff       	call   801826 <nsipc>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a86:	83 ec 0c             	sub    $0xc,%esp
  801a89:	ff 75 08             	pushl  0x8(%ebp)
  801a8c:	e8 a7 f3 ff ff       	call   800e38 <fd2data>
  801a91:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a93:	83 c4 08             	add    $0x8,%esp
  801a96:	68 6c 27 80 00       	push   $0x80276c
  801a9b:	53                   	push   %ebx
  801a9c:	e8 f3 ec ff ff       	call   800794 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801aa1:	8b 46 04             	mov    0x4(%esi),%eax
  801aa4:	2b 06                	sub    (%esi),%eax
  801aa6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801aac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ab3:	00 00 00 
	stat->st_dev = &devpipe;
  801ab6:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801abd:	30 80 00 
	return 0;
}
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac8:	5b                   	pop    %ebx
  801ac9:	5e                   	pop    %esi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ad6:	53                   	push   %ebx
  801ad7:	6a 00                	push   $0x0
  801ad9:	e8 34 f1 ff ff       	call   800c12 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ade:	89 1c 24             	mov    %ebx,(%esp)
  801ae1:	e8 52 f3 ff ff       	call   800e38 <fd2data>
  801ae6:	83 c4 08             	add    $0x8,%esp
  801ae9:	50                   	push   %eax
  801aea:	6a 00                	push   $0x0
  801aec:	e8 21 f1 ff ff       	call   800c12 <sys_page_unmap>
}
  801af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <_pipeisclosed>:
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	53                   	push   %ebx
  801afc:	83 ec 1c             	sub    $0x1c,%esp
  801aff:	89 c7                	mov    %eax,%edi
  801b01:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b03:	a1 08 40 80 00       	mov    0x804008,%eax
  801b08:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	57                   	push   %edi
  801b0f:	e8 6e 05 00 00       	call   802082 <pageref>
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b17:	89 34 24             	mov    %esi,(%esp)
  801b1a:	e8 63 05 00 00       	call   802082 <pageref>
		nn = thisenv->env_runs;
  801b1f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b25:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	39 cb                	cmp    %ecx,%ebx
  801b2d:	74 1b                	je     801b4a <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b2f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b32:	75 cf                	jne    801b03 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b34:	8b 42 58             	mov    0x58(%edx),%eax
  801b37:	6a 01                	push   $0x1
  801b39:	50                   	push   %eax
  801b3a:	53                   	push   %ebx
  801b3b:	68 73 27 80 00       	push   $0x802773
  801b40:	e8 30 e6 ff ff       	call   800175 <cprintf>
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	eb b9                	jmp    801b03 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b4a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b4d:	0f 94 c0             	sete   %al
  801b50:	0f b6 c0             	movzbl %al,%eax
}
  801b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5e                   	pop    %esi
  801b58:	5f                   	pop    %edi
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <devpipe_write>:
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	57                   	push   %edi
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	83 ec 28             	sub    $0x28,%esp
  801b64:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b67:	56                   	push   %esi
  801b68:	e8 cb f2 ff ff       	call   800e38 <fd2data>
  801b6d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	bf 00 00 00 00       	mov    $0x0,%edi
  801b77:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b7a:	74 4f                	je     801bcb <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b7c:	8b 43 04             	mov    0x4(%ebx),%eax
  801b7f:	8b 0b                	mov    (%ebx),%ecx
  801b81:	8d 51 20             	lea    0x20(%ecx),%edx
  801b84:	39 d0                	cmp    %edx,%eax
  801b86:	72 14                	jb     801b9c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b88:	89 da                	mov    %ebx,%edx
  801b8a:	89 f0                	mov    %esi,%eax
  801b8c:	e8 65 ff ff ff       	call   801af6 <_pipeisclosed>
  801b91:	85 c0                	test   %eax,%eax
  801b93:	75 3a                	jne    801bcf <devpipe_write+0x74>
			sys_yield();
  801b95:	e8 d4 ef ff ff       	call   800b6e <sys_yield>
  801b9a:	eb e0                	jmp    801b7c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ba3:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	c1 fa 1f             	sar    $0x1f,%edx
  801bab:	89 d1                	mov    %edx,%ecx
  801bad:	c1 e9 1b             	shr    $0x1b,%ecx
  801bb0:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bb3:	83 e2 1f             	and    $0x1f,%edx
  801bb6:	29 ca                	sub    %ecx,%edx
  801bb8:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bbc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bc0:	83 c0 01             	add    $0x1,%eax
  801bc3:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bc6:	83 c7 01             	add    $0x1,%edi
  801bc9:	eb ac                	jmp    801b77 <devpipe_write+0x1c>
	return i;
  801bcb:	89 f8                	mov    %edi,%eax
  801bcd:	eb 05                	jmp    801bd4 <devpipe_write+0x79>
				return 0;
  801bcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    

00801bdc <devpipe_read>:
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	57                   	push   %edi
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	83 ec 18             	sub    $0x18,%esp
  801be5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801be8:	57                   	push   %edi
  801be9:	e8 4a f2 ff ff       	call   800e38 <fd2data>
  801bee:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	be 00 00 00 00       	mov    $0x0,%esi
  801bf8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801bfb:	74 47                	je     801c44 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801bfd:	8b 03                	mov    (%ebx),%eax
  801bff:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c02:	75 22                	jne    801c26 <devpipe_read+0x4a>
			if (i > 0)
  801c04:	85 f6                	test   %esi,%esi
  801c06:	75 14                	jne    801c1c <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c08:	89 da                	mov    %ebx,%edx
  801c0a:	89 f8                	mov    %edi,%eax
  801c0c:	e8 e5 fe ff ff       	call   801af6 <_pipeisclosed>
  801c11:	85 c0                	test   %eax,%eax
  801c13:	75 33                	jne    801c48 <devpipe_read+0x6c>
			sys_yield();
  801c15:	e8 54 ef ff ff       	call   800b6e <sys_yield>
  801c1a:	eb e1                	jmp    801bfd <devpipe_read+0x21>
				return i;
  801c1c:	89 f0                	mov    %esi,%eax
}
  801c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c21:	5b                   	pop    %ebx
  801c22:	5e                   	pop    %esi
  801c23:	5f                   	pop    %edi
  801c24:	5d                   	pop    %ebp
  801c25:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c26:	99                   	cltd   
  801c27:	c1 ea 1b             	shr    $0x1b,%edx
  801c2a:	01 d0                	add    %edx,%eax
  801c2c:	83 e0 1f             	and    $0x1f,%eax
  801c2f:	29 d0                	sub    %edx,%eax
  801c31:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c39:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c3c:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c3f:	83 c6 01             	add    $0x1,%esi
  801c42:	eb b4                	jmp    801bf8 <devpipe_read+0x1c>
	return i;
  801c44:	89 f0                	mov    %esi,%eax
  801c46:	eb d6                	jmp    801c1e <devpipe_read+0x42>
				return 0;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4d:	eb cf                	jmp    801c1e <devpipe_read+0x42>

00801c4f <pipe>:
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c57:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5a:	50                   	push   %eax
  801c5b:	e8 ef f1 ff ff       	call   800e4f <fd_alloc>
  801c60:	89 c3                	mov    %eax,%ebx
  801c62:	83 c4 10             	add    $0x10,%esp
  801c65:	85 c0                	test   %eax,%eax
  801c67:	78 5b                	js     801cc4 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	68 07 04 00 00       	push   $0x407
  801c71:	ff 75 f4             	pushl  -0xc(%ebp)
  801c74:	6a 00                	push   $0x0
  801c76:	e8 12 ef ff ff       	call   800b8d <sys_page_alloc>
  801c7b:	89 c3                	mov    %eax,%ebx
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	85 c0                	test   %eax,%eax
  801c82:	78 40                	js     801cc4 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c8a:	50                   	push   %eax
  801c8b:	e8 bf f1 ff ff       	call   800e4f <fd_alloc>
  801c90:	89 c3                	mov    %eax,%ebx
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 1b                	js     801cb4 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	68 07 04 00 00       	push   $0x407
  801ca1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca4:	6a 00                	push   $0x0
  801ca6:	e8 e2 ee ff ff       	call   800b8d <sys_page_alloc>
  801cab:	89 c3                	mov    %eax,%ebx
  801cad:	83 c4 10             	add    $0x10,%esp
  801cb0:	85 c0                	test   %eax,%eax
  801cb2:	79 19                	jns    801ccd <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801cb4:	83 ec 08             	sub    $0x8,%esp
  801cb7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cba:	6a 00                	push   $0x0
  801cbc:	e8 51 ef ff ff       	call   800c12 <sys_page_unmap>
  801cc1:	83 c4 10             	add    $0x10,%esp
}
  801cc4:	89 d8                	mov    %ebx,%eax
  801cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5d                   	pop    %ebp
  801ccc:	c3                   	ret    
	va = fd2data(fd0);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd3:	e8 60 f1 ff ff       	call   800e38 <fd2data>
  801cd8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cda:	83 c4 0c             	add    $0xc,%esp
  801cdd:	68 07 04 00 00       	push   $0x407
  801ce2:	50                   	push   %eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	e8 a3 ee ff ff       	call   800b8d <sys_page_alloc>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	0f 88 8c 00 00 00    	js     801d83 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	ff 75 f0             	pushl  -0x10(%ebp)
  801cfd:	e8 36 f1 ff ff       	call   800e38 <fd2data>
  801d02:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d09:	50                   	push   %eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	56                   	push   %esi
  801d0d:	6a 00                	push   $0x0
  801d0f:	e8 bc ee ff ff       	call   800bd0 <sys_page_map>
  801d14:	89 c3                	mov    %eax,%ebx
  801d16:	83 c4 20             	add    $0x20,%esp
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	78 58                	js     801d75 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d20:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d26:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d35:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d3b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d40:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4d:	e8 d6 f0 ff ff       	call   800e28 <fd2num>
  801d52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d55:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d57:	83 c4 04             	add    $0x4,%esp
  801d5a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d5d:	e8 c6 f0 ff ff       	call   800e28 <fd2num>
  801d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d65:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d70:	e9 4f ff ff ff       	jmp    801cc4 <pipe+0x75>
	sys_page_unmap(0, va);
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	56                   	push   %esi
  801d79:	6a 00                	push   $0x0
  801d7b:	e8 92 ee ff ff       	call   800c12 <sys_page_unmap>
  801d80:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d83:	83 ec 08             	sub    $0x8,%esp
  801d86:	ff 75 f0             	pushl  -0x10(%ebp)
  801d89:	6a 00                	push   $0x0
  801d8b:	e8 82 ee ff ff       	call   800c12 <sys_page_unmap>
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	e9 1c ff ff ff       	jmp    801cb4 <pipe+0x65>

00801d98 <pipeisclosed>:
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da1:	50                   	push   %eax
  801da2:	ff 75 08             	pushl  0x8(%ebp)
  801da5:	e8 f4 f0 ff ff       	call   800e9e <fd_lookup>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	85 c0                	test   %eax,%eax
  801daf:	78 18                	js     801dc9 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	ff 75 f4             	pushl  -0xc(%ebp)
  801db7:	e8 7c f0 ff ff       	call   800e38 <fd2data>
	return _pipeisclosed(fd, p);
  801dbc:	89 c2                	mov    %eax,%edx
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	e8 30 fd ff ff       	call   801af6 <_pipeisclosed>
  801dc6:	83 c4 10             	add    $0x10,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	5d                   	pop    %ebp
  801dd4:	c3                   	ret    

00801dd5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801ddb:	68 8b 27 80 00       	push   $0x80278b
  801de0:	ff 75 0c             	pushl  0xc(%ebp)
  801de3:	e8 ac e9 ff ff       	call   800794 <strcpy>
	return 0;
}
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <devcons_write>:
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	57                   	push   %edi
  801df3:	56                   	push   %esi
  801df4:	53                   	push   %ebx
  801df5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801dfb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e00:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e06:	eb 2f                	jmp    801e37 <devcons_write+0x48>
		m = n - tot;
  801e08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e0b:	29 f3                	sub    %esi,%ebx
  801e0d:	83 fb 7f             	cmp    $0x7f,%ebx
  801e10:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e15:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	53                   	push   %ebx
  801e1c:	89 f0                	mov    %esi,%eax
  801e1e:	03 45 0c             	add    0xc(%ebp),%eax
  801e21:	50                   	push   %eax
  801e22:	57                   	push   %edi
  801e23:	e8 fa ea ff ff       	call   800922 <memmove>
		sys_cputs(buf, m);
  801e28:	83 c4 08             	add    $0x8,%esp
  801e2b:	53                   	push   %ebx
  801e2c:	57                   	push   %edi
  801e2d:	e8 9f ec ff ff       	call   800ad1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e32:	01 de                	add    %ebx,%esi
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e3a:	72 cc                	jb     801e08 <devcons_write+0x19>
}
  801e3c:	89 f0                	mov    %esi,%eax
  801e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e41:	5b                   	pop    %ebx
  801e42:	5e                   	pop    %esi
  801e43:	5f                   	pop    %edi
  801e44:	5d                   	pop    %ebp
  801e45:	c3                   	ret    

00801e46 <devcons_read>:
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 08             	sub    $0x8,%esp
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e55:	75 07                	jne    801e5e <devcons_read+0x18>
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    
		sys_yield();
  801e59:	e8 10 ed ff ff       	call   800b6e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e5e:	e8 8c ec ff ff       	call   800aef <sys_cgetc>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	74 f2                	je     801e59 <devcons_read+0x13>
	if (c < 0)
  801e67:	85 c0                	test   %eax,%eax
  801e69:	78 ec                	js     801e57 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e6b:	83 f8 04             	cmp    $0x4,%eax
  801e6e:	74 0c                	je     801e7c <devcons_read+0x36>
	*(char*)vbuf = c;
  801e70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e73:	88 02                	mov    %al,(%edx)
	return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb db                	jmp    801e57 <devcons_read+0x11>
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e81:	eb d4                	jmp    801e57 <devcons_read+0x11>

00801e83 <cputchar>:
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e8f:	6a 01                	push   $0x1
  801e91:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e94:	50                   	push   %eax
  801e95:	e8 37 ec ff ff       	call   800ad1 <sys_cputs>
}
  801e9a:	83 c4 10             	add    $0x10,%esp
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <getchar>:
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ea5:	6a 01                	push   $0x1
  801ea7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eaa:	50                   	push   %eax
  801eab:	6a 00                	push   $0x0
  801ead:	e8 5d f2 ff ff       	call   80110f <read>
	if (r < 0)
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	78 08                	js     801ec1 <getchar+0x22>
	if (r < 1)
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	7e 06                	jle    801ec3 <getchar+0x24>
	return c;
  801ebd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    
		return -E_EOF;
  801ec3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ec8:	eb f7                	jmp    801ec1 <getchar+0x22>

00801eca <iscons>:
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ed0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed3:	50                   	push   %eax
  801ed4:	ff 75 08             	pushl  0x8(%ebp)
  801ed7:	e8 c2 ef ff ff       	call   800e9e <fd_lookup>
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	85 c0                	test   %eax,%eax
  801ee1:	78 11                	js     801ef4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801eec:	39 10                	cmp    %edx,(%eax)
  801eee:	0f 94 c0             	sete   %al
  801ef1:	0f b6 c0             	movzbl %al,%eax
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <opencons>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eff:	50                   	push   %eax
  801f00:	e8 4a ef ff ff       	call   800e4f <fd_alloc>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 3a                	js     801f46 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	68 07 04 00 00       	push   $0x407
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	6a 00                	push   $0x0
  801f19:	e8 6f ec ff ff       	call   800b8d <sys_page_alloc>
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	78 21                	js     801f46 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f2e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	50                   	push   %eax
  801f3e:	e8 e5 ee ff ff       	call   800e28 <fd2num>
  801f43:	83 c4 10             	add    $0x10,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	56                   	push   %esi
  801f4c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801f4d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801f50:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801f56:	e8 f4 eb ff ff       	call   800b4f <sys_getenvid>
  801f5b:	83 ec 0c             	sub    $0xc,%esp
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	ff 75 08             	pushl  0x8(%ebp)
  801f64:	56                   	push   %esi
  801f65:	50                   	push   %eax
  801f66:	68 98 27 80 00       	push   $0x802798
  801f6b:	e8 05 e2 ff ff       	call   800175 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801f70:	83 c4 18             	add    $0x18,%esp
  801f73:	53                   	push   %ebx
  801f74:	ff 75 10             	pushl  0x10(%ebp)
  801f77:	e8 a8 e1 ff ff       	call   800124 <vcprintf>
	cprintf("\n");
  801f7c:	c7 04 24 84 27 80 00 	movl   $0x802784,(%esp)
  801f83:	e8 ed e1 ff ff       	call   800175 <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801f8b:	cc                   	int3   
  801f8c:	eb fd                	jmp    801f8b <_panic+0x43>

00801f8e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	56                   	push   %esi
  801f92:	53                   	push   %ebx
  801f93:	8b 75 08             	mov    0x8(%ebp),%esi
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f9c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f9e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fa3:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	50                   	push   %eax
  801faa:	e8 8e ed ff ff       	call   800d3d <sys_ipc_recv>
	if (from_env_store)
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	85 f6                	test   %esi,%esi
  801fb4:	74 14                	je     801fca <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801fb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	78 09                	js     801fc8 <ipc_recv+0x3a>
  801fbf:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fc5:	8b 52 74             	mov    0x74(%edx),%edx
  801fc8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801fca:	85 db                	test   %ebx,%ebx
  801fcc:	74 14                	je     801fe2 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801fce:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 09                	js     801fe0 <ipc_recv+0x52>
  801fd7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801fdd:	8b 52 78             	mov    0x78(%edx),%edx
  801fe0:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 08                	js     801fee <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801fe6:	a1 08 40 80 00       	mov    0x804008,%eax
  801feb:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	57                   	push   %edi
  801ff9:	56                   	push   %esi
  801ffa:	53                   	push   %ebx
  801ffb:	83 ec 0c             	sub    $0xc,%esp
  801ffe:	8b 7d 08             	mov    0x8(%ebp),%edi
  802001:	8b 75 0c             	mov    0xc(%ebp),%esi
  802004:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802007:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802009:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80200e:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802011:	ff 75 14             	pushl  0x14(%ebp)
  802014:	53                   	push   %ebx
  802015:	56                   	push   %esi
  802016:	57                   	push   %edi
  802017:	e8 fe ec ff ff       	call   800d1a <sys_ipc_try_send>
		if (ret == 0)
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	85 c0                	test   %eax,%eax
  802021:	74 1e                	je     802041 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802023:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802026:	75 07                	jne    80202f <ipc_send+0x3a>
			sys_yield();
  802028:	e8 41 eb ff ff       	call   800b6e <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80202d:	eb e2                	jmp    802011 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80202f:	50                   	push   %eax
  802030:	68 bc 27 80 00       	push   $0x8027bc
  802035:	6a 3d                	push   $0x3d
  802037:	68 d0 27 80 00       	push   $0x8027d0
  80203c:	e8 07 ff ff ff       	call   801f48 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802041:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802044:	5b                   	pop    %ebx
  802045:	5e                   	pop    %esi
  802046:	5f                   	pop    %edi
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802054:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802057:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80205d:	8b 52 50             	mov    0x50(%edx),%edx
  802060:	39 ca                	cmp    %ecx,%edx
  802062:	74 11                	je     802075 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802064:	83 c0 01             	add    $0x1,%eax
  802067:	3d 00 04 00 00       	cmp    $0x400,%eax
  80206c:	75 e6                	jne    802054 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	eb 0b                	jmp    802080 <ipc_find_env+0x37>
			return envs[i].env_id;
  802075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80207d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802080:	5d                   	pop    %ebp
  802081:	c3                   	ret    

00802082 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802088:	89 d0                	mov    %edx,%eax
  80208a:	c1 e8 16             	shr    $0x16,%eax
  80208d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802099:	f6 c1 01             	test   $0x1,%cl
  80209c:	74 1d                	je     8020bb <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80209e:	c1 ea 0c             	shr    $0xc,%edx
  8020a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020a8:	f6 c2 01             	test   $0x1,%dl
  8020ab:	74 0e                	je     8020bb <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ad:	c1 ea 0c             	shr    $0xc,%edx
  8020b0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020b7:	ef 
  8020b8:	0f b7 c0             	movzwl %ax,%eax
}
  8020bb:	5d                   	pop    %ebp
  8020bc:	c3                   	ret    
  8020bd:	66 90                	xchg   %ax,%ax
  8020bf:	90                   	nop

008020c0 <__udivdi3>:
  8020c0:	55                   	push   %ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 1c             	sub    $0x1c,%esp
  8020c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8020cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8020cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020d7:	85 d2                	test   %edx,%edx
  8020d9:	75 35                	jne    802110 <__udivdi3+0x50>
  8020db:	39 f3                	cmp    %esi,%ebx
  8020dd:	0f 87 bd 00 00 00    	ja     8021a0 <__udivdi3+0xe0>
  8020e3:	85 db                	test   %ebx,%ebx
  8020e5:	89 d9                	mov    %ebx,%ecx
  8020e7:	75 0b                	jne    8020f4 <__udivdi3+0x34>
  8020e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ee:	31 d2                	xor    %edx,%edx
  8020f0:	f7 f3                	div    %ebx
  8020f2:	89 c1                	mov    %eax,%ecx
  8020f4:	31 d2                	xor    %edx,%edx
  8020f6:	89 f0                	mov    %esi,%eax
  8020f8:	f7 f1                	div    %ecx
  8020fa:	89 c6                	mov    %eax,%esi
  8020fc:	89 e8                	mov    %ebp,%eax
  8020fe:	89 f7                	mov    %esi,%edi
  802100:	f7 f1                	div    %ecx
  802102:	89 fa                	mov    %edi,%edx
  802104:	83 c4 1c             	add    $0x1c,%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5f                   	pop    %edi
  80210a:	5d                   	pop    %ebp
  80210b:	c3                   	ret    
  80210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802110:	39 f2                	cmp    %esi,%edx
  802112:	77 7c                	ja     802190 <__udivdi3+0xd0>
  802114:	0f bd fa             	bsr    %edx,%edi
  802117:	83 f7 1f             	xor    $0x1f,%edi
  80211a:	0f 84 98 00 00 00    	je     8021b8 <__udivdi3+0xf8>
  802120:	89 f9                	mov    %edi,%ecx
  802122:	b8 20 00 00 00       	mov    $0x20,%eax
  802127:	29 f8                	sub    %edi,%eax
  802129:	d3 e2                	shl    %cl,%edx
  80212b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212f:	89 c1                	mov    %eax,%ecx
  802131:	89 da                	mov    %ebx,%edx
  802133:	d3 ea                	shr    %cl,%edx
  802135:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802139:	09 d1                	or     %edx,%ecx
  80213b:	89 f2                	mov    %esi,%edx
  80213d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802141:	89 f9                	mov    %edi,%ecx
  802143:	d3 e3                	shl    %cl,%ebx
  802145:	89 c1                	mov    %eax,%ecx
  802147:	d3 ea                	shr    %cl,%edx
  802149:	89 f9                	mov    %edi,%ecx
  80214b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80214f:	d3 e6                	shl    %cl,%esi
  802151:	89 eb                	mov    %ebp,%ebx
  802153:	89 c1                	mov    %eax,%ecx
  802155:	d3 eb                	shr    %cl,%ebx
  802157:	09 de                	or     %ebx,%esi
  802159:	89 f0                	mov    %esi,%eax
  80215b:	f7 74 24 08          	divl   0x8(%esp)
  80215f:	89 d6                	mov    %edx,%esi
  802161:	89 c3                	mov    %eax,%ebx
  802163:	f7 64 24 0c          	mull   0xc(%esp)
  802167:	39 d6                	cmp    %edx,%esi
  802169:	72 0c                	jb     802177 <__udivdi3+0xb7>
  80216b:	89 f9                	mov    %edi,%ecx
  80216d:	d3 e5                	shl    %cl,%ebp
  80216f:	39 c5                	cmp    %eax,%ebp
  802171:	73 5d                	jae    8021d0 <__udivdi3+0x110>
  802173:	39 d6                	cmp    %edx,%esi
  802175:	75 59                	jne    8021d0 <__udivdi3+0x110>
  802177:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80217a:	31 ff                	xor    %edi,%edi
  80217c:	89 fa                	mov    %edi,%edx
  80217e:	83 c4 1c             	add    $0x1c,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    
  802186:	8d 76 00             	lea    0x0(%esi),%esi
  802189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802190:	31 ff                	xor    %edi,%edi
  802192:	31 c0                	xor    %eax,%eax
  802194:	89 fa                	mov    %edi,%edx
  802196:	83 c4 1c             	add    $0x1c,%esp
  802199:	5b                   	pop    %ebx
  80219a:	5e                   	pop    %esi
  80219b:	5f                   	pop    %edi
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	31 ff                	xor    %edi,%edi
  8021a2:	89 e8                	mov    %ebp,%eax
  8021a4:	89 f2                	mov    %esi,%edx
  8021a6:	f7 f3                	div    %ebx
  8021a8:	89 fa                	mov    %edi,%edx
  8021aa:	83 c4 1c             	add    $0x1c,%esp
  8021ad:	5b                   	pop    %ebx
  8021ae:	5e                   	pop    %esi
  8021af:	5f                   	pop    %edi
  8021b0:	5d                   	pop    %ebp
  8021b1:	c3                   	ret    
  8021b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021b8:	39 f2                	cmp    %esi,%edx
  8021ba:	72 06                	jb     8021c2 <__udivdi3+0x102>
  8021bc:	31 c0                	xor    %eax,%eax
  8021be:	39 eb                	cmp    %ebp,%ebx
  8021c0:	77 d2                	ja     802194 <__udivdi3+0xd4>
  8021c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c7:	eb cb                	jmp    802194 <__udivdi3+0xd4>
  8021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021d0:	89 d8                	mov    %ebx,%eax
  8021d2:	31 ff                	xor    %edi,%edi
  8021d4:	eb be                	jmp    802194 <__udivdi3+0xd4>
  8021d6:	66 90                	xchg   %ax,%ax
  8021d8:	66 90                	xchg   %ax,%ax
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <__umoddi3>:
  8021e0:	55                   	push   %ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 1c             	sub    $0x1c,%esp
  8021e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021f7:	85 ed                	test   %ebp,%ebp
  8021f9:	89 f0                	mov    %esi,%eax
  8021fb:	89 da                	mov    %ebx,%edx
  8021fd:	75 19                	jne    802218 <__umoddi3+0x38>
  8021ff:	39 df                	cmp    %ebx,%edi
  802201:	0f 86 b1 00 00 00    	jbe    8022b8 <__umoddi3+0xd8>
  802207:	f7 f7                	div    %edi
  802209:	89 d0                	mov    %edx,%eax
  80220b:	31 d2                	xor    %edx,%edx
  80220d:	83 c4 1c             	add    $0x1c,%esp
  802210:	5b                   	pop    %ebx
  802211:	5e                   	pop    %esi
  802212:	5f                   	pop    %edi
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    
  802215:	8d 76 00             	lea    0x0(%esi),%esi
  802218:	39 dd                	cmp    %ebx,%ebp
  80221a:	77 f1                	ja     80220d <__umoddi3+0x2d>
  80221c:	0f bd cd             	bsr    %ebp,%ecx
  80221f:	83 f1 1f             	xor    $0x1f,%ecx
  802222:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802226:	0f 84 b4 00 00 00    	je     8022e0 <__umoddi3+0x100>
  80222c:	b8 20 00 00 00       	mov    $0x20,%eax
  802231:	89 c2                	mov    %eax,%edx
  802233:	8b 44 24 04          	mov    0x4(%esp),%eax
  802237:	29 c2                	sub    %eax,%edx
  802239:	89 c1                	mov    %eax,%ecx
  80223b:	89 f8                	mov    %edi,%eax
  80223d:	d3 e5                	shl    %cl,%ebp
  80223f:	89 d1                	mov    %edx,%ecx
  802241:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802245:	d3 e8                	shr    %cl,%eax
  802247:	09 c5                	or     %eax,%ebp
  802249:	8b 44 24 04          	mov    0x4(%esp),%eax
  80224d:	89 c1                	mov    %eax,%ecx
  80224f:	d3 e7                	shl    %cl,%edi
  802251:	89 d1                	mov    %edx,%ecx
  802253:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802257:	89 df                	mov    %ebx,%edi
  802259:	d3 ef                	shr    %cl,%edi
  80225b:	89 c1                	mov    %eax,%ecx
  80225d:	89 f0                	mov    %esi,%eax
  80225f:	d3 e3                	shl    %cl,%ebx
  802261:	89 d1                	mov    %edx,%ecx
  802263:	89 fa                	mov    %edi,%edx
  802265:	d3 e8                	shr    %cl,%eax
  802267:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80226c:	09 d8                	or     %ebx,%eax
  80226e:	f7 f5                	div    %ebp
  802270:	d3 e6                	shl    %cl,%esi
  802272:	89 d1                	mov    %edx,%ecx
  802274:	f7 64 24 08          	mull   0x8(%esp)
  802278:	39 d1                	cmp    %edx,%ecx
  80227a:	89 c3                	mov    %eax,%ebx
  80227c:	89 d7                	mov    %edx,%edi
  80227e:	72 06                	jb     802286 <__umoddi3+0xa6>
  802280:	75 0e                	jne    802290 <__umoddi3+0xb0>
  802282:	39 c6                	cmp    %eax,%esi
  802284:	73 0a                	jae    802290 <__umoddi3+0xb0>
  802286:	2b 44 24 08          	sub    0x8(%esp),%eax
  80228a:	19 ea                	sbb    %ebp,%edx
  80228c:	89 d7                	mov    %edx,%edi
  80228e:	89 c3                	mov    %eax,%ebx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802297:	29 de                	sub    %ebx,%esi
  802299:	19 fa                	sbb    %edi,%edx
  80229b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80229f:	89 d0                	mov    %edx,%eax
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 d9                	mov    %ebx,%ecx
  8022a5:	d3 ee                	shr    %cl,%esi
  8022a7:	d3 ea                	shr    %cl,%edx
  8022a9:	09 f0                	or     %esi,%eax
  8022ab:	83 c4 1c             	add    $0x1c,%esp
  8022ae:	5b                   	pop    %ebx
  8022af:	5e                   	pop    %esi
  8022b0:	5f                   	pop    %edi
  8022b1:	5d                   	pop    %ebp
  8022b2:	c3                   	ret    
  8022b3:	90                   	nop
  8022b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022b8:	85 ff                	test   %edi,%edi
  8022ba:	89 f9                	mov    %edi,%ecx
  8022bc:	75 0b                	jne    8022c9 <__umoddi3+0xe9>
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	31 d2                	xor    %edx,%edx
  8022c5:	f7 f7                	div    %edi
  8022c7:	89 c1                	mov    %eax,%ecx
  8022c9:	89 d8                	mov    %ebx,%eax
  8022cb:	31 d2                	xor    %edx,%edx
  8022cd:	f7 f1                	div    %ecx
  8022cf:	89 f0                	mov    %esi,%eax
  8022d1:	f7 f1                	div    %ecx
  8022d3:	e9 31 ff ff ff       	jmp    802209 <__umoddi3+0x29>
  8022d8:	90                   	nop
  8022d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e0:	39 dd                	cmp    %ebx,%ebp
  8022e2:	72 08                	jb     8022ec <__umoddi3+0x10c>
  8022e4:	39 f7                	cmp    %esi,%edi
  8022e6:	0f 87 21 ff ff ff    	ja     80220d <__umoddi3+0x2d>
  8022ec:	89 da                	mov    %ebx,%edx
  8022ee:	89 f0                	mov    %esi,%eax
  8022f0:	29 f8                	sub    %edi,%eax
  8022f2:	19 ea                	sbb    %ebp,%edx
  8022f4:	e9 14 ff ff ff       	jmp    80220d <__umoddi3+0x2d>

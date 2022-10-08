
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 60 22 80 00       	push   $0x802260
  800056:	e8 fa 00 00 00       	call   800155 <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 bf 0a 00 00       	call   800b2f <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800078:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007d:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800082:	85 db                	test   %ebx,%ebx
  800084:	7e 07                	jle    80008d <libmain+0x2d>
		binaryname = argv[0];
  800086:	8b 06                	mov    (%esi),%eax
  800088:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008d:	83 ec 08             	sub    $0x8,%esp
  800090:	56                   	push   %esi
  800091:	53                   	push   %ebx
  800092:	e8 9c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800097:	e8 0a 00 00 00       	call   8000a6 <exit>
}
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a2:	5b                   	pop    %ebx
  8000a3:	5e                   	pop    %esi
  8000a4:	5d                   	pop    %ebp
  8000a5:	c3                   	ret    

008000a6 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000a6:	55                   	push   %ebp
  8000a7:	89 e5                	mov    %esp,%ebp
  8000a9:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ac:	e8 a2 0e 00 00       	call   800f53 <close_all>
	sys_env_destroy(0);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	6a 00                	push   $0x0
  8000b6:	e8 33 0a 00 00       	call   800aee <sys_env_destroy>
}
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 04             	sub    $0x4,%esp
  8000c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ca:	8b 13                	mov    (%ebx),%edx
  8000cc:	8d 42 01             	lea    0x1(%edx),%eax
  8000cf:	89 03                	mov    %eax,(%ebx)
  8000d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dd:	74 09                	je     8000e8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e6:	c9                   	leave  
  8000e7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	68 ff 00 00 00       	push   $0xff
  8000f0:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f3:	50                   	push   %eax
  8000f4:	e8 b8 09 00 00       	call   800ab1 <sys_cputs>
		b->idx = 0;
  8000f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	eb db                	jmp    8000df <putch+0x1f>

00800104 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80010d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800114:	00 00 00 
	b.cnt = 0;
  800117:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800121:	ff 75 0c             	pushl  0xc(%ebp)
  800124:	ff 75 08             	pushl  0x8(%ebp)
  800127:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80012d:	50                   	push   %eax
  80012e:	68 c0 00 80 00       	push   $0x8000c0
  800133:	e8 1a 01 00 00       	call   800252 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800138:	83 c4 08             	add    $0x8,%esp
  80013b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800141:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800147:	50                   	push   %eax
  800148:	e8 64 09 00 00       	call   800ab1 <sys_cputs>

	return b.cnt;
}
  80014d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015e:	50                   	push   %eax
  80015f:	ff 75 08             	pushl  0x8(%ebp)
  800162:	e8 9d ff ff ff       	call   800104 <vcprintf>
	va_end(ap);

	return cnt;
}
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
  80016f:	83 ec 1c             	sub    $0x1c,%esp
  800172:	89 c7                	mov    %eax,%edi
  800174:	89 d6                	mov    %edx,%esi
  800176:	8b 45 08             	mov    0x8(%ebp),%eax
  800179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80017f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800182:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80018d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800190:	39 d3                	cmp    %edx,%ebx
  800192:	72 05                	jb     800199 <printnum+0x30>
  800194:	39 45 10             	cmp    %eax,0x10(%ebp)
  800197:	77 7a                	ja     800213 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800199:	83 ec 0c             	sub    $0xc,%esp
  80019c:	ff 75 18             	pushl  0x18(%ebp)
  80019f:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a5:	53                   	push   %ebx
  8001a6:	ff 75 10             	pushl  0x10(%ebp)
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001af:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8001b8:	e8 63 1e 00 00       	call   802020 <__udivdi3>
  8001bd:	83 c4 18             	add    $0x18,%esp
  8001c0:	52                   	push   %edx
  8001c1:	50                   	push   %eax
  8001c2:	89 f2                	mov    %esi,%edx
  8001c4:	89 f8                	mov    %edi,%eax
  8001c6:	e8 9e ff ff ff       	call   800169 <printnum>
  8001cb:	83 c4 20             	add    $0x20,%esp
  8001ce:	eb 13                	jmp    8001e3 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d0:	83 ec 08             	sub    $0x8,%esp
  8001d3:	56                   	push   %esi
  8001d4:	ff 75 18             	pushl  0x18(%ebp)
  8001d7:	ff d7                	call   *%edi
  8001d9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001dc:	83 eb 01             	sub    $0x1,%ebx
  8001df:	85 db                	test   %ebx,%ebx
  8001e1:	7f ed                	jg     8001d0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	56                   	push   %esi
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f3:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f6:	e8 45 1f 00 00       	call   802140 <__umoddi3>
  8001fb:	83 c4 14             	add    $0x14,%esp
  8001fe:	0f be 80 78 22 80 00 	movsbl 0x802278(%eax),%eax
  800205:	50                   	push   %eax
  800206:	ff d7                	call   *%edi
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    
  800213:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800216:	eb c4                	jmp    8001dc <printnum+0x73>

00800218 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800222:	8b 10                	mov    (%eax),%edx
  800224:	3b 50 04             	cmp    0x4(%eax),%edx
  800227:	73 0a                	jae    800233 <sprintputch+0x1b>
		*b->buf++ = ch;
  800229:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022c:	89 08                	mov    %ecx,(%eax)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	88 02                	mov    %al,(%edx)
}
  800233:	5d                   	pop    %ebp
  800234:	c3                   	ret    

00800235 <printfmt>:
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 05 00 00 00       	call   800252 <vprintfmt>
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <vprintfmt>:
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 2c             	sub    $0x2c,%esp
  80025b:	8b 75 08             	mov    0x8(%ebp),%esi
  80025e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800261:	8b 7d 10             	mov    0x10(%ebp),%edi
  800264:	e9 c1 03 00 00       	jmp    80062a <vprintfmt+0x3d8>
		padc = ' ';
  800269:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80026d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800274:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80027b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800287:	8d 47 01             	lea    0x1(%edi),%eax
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028d:	0f b6 17             	movzbl (%edi),%edx
  800290:	8d 42 dd             	lea    -0x23(%edx),%eax
  800293:	3c 55                	cmp    $0x55,%al
  800295:	0f 87 12 04 00 00    	ja     8006ad <vprintfmt+0x45b>
  80029b:	0f b6 c0             	movzbl %al,%eax
  80029e:	ff 24 85 c0 23 80 00 	jmp    *0x8023c0(,%eax,4)
  8002a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a8:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ac:	eb d9                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b1:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b5:	eb d0                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b7:	0f b6 d2             	movzbl %dl,%edx
  8002ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c5:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c8:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002cc:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002cf:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d2:	83 f9 09             	cmp    $0x9,%ecx
  8002d5:	77 55                	ja     80032c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002d7:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002da:	eb e9                	jmp    8002c5 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8002df:	8b 00                	mov    (%eax),%eax
  8002e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e7:	8d 40 04             	lea    0x4(%eax),%eax
  8002ea:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f4:	79 91                	jns    800287 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800303:	eb 82                	jmp    800287 <vprintfmt+0x35>
  800305:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800308:	85 c0                	test   %eax,%eax
  80030a:	ba 00 00 00 00       	mov    $0x0,%edx
  80030f:	0f 49 d0             	cmovns %eax,%edx
  800312:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800318:	e9 6a ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800320:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800327:	e9 5b ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80032c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800332:	eb bc                	jmp    8002f0 <vprintfmt+0x9e>
			lflag++;
  800334:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80033a:	e9 48 ff ff ff       	jmp    800287 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033f:	8b 45 14             	mov    0x14(%ebp),%eax
  800342:	8d 78 04             	lea    0x4(%eax),%edi
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	53                   	push   %ebx
  800349:	ff 30                	pushl  (%eax)
  80034b:	ff d6                	call   *%esi
			break;
  80034d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800350:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800353:	e9 cf 02 00 00       	jmp    800627 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800358:	8b 45 14             	mov    0x14(%ebp),%eax
  80035b:	8d 78 04             	lea    0x4(%eax),%edi
  80035e:	8b 00                	mov    (%eax),%eax
  800360:	99                   	cltd   
  800361:	31 d0                	xor    %edx,%eax
  800363:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800365:	83 f8 0f             	cmp    $0xf,%eax
  800368:	7f 23                	jg     80038d <vprintfmt+0x13b>
  80036a:	8b 14 85 20 25 80 00 	mov    0x802520(,%eax,4),%edx
  800371:	85 d2                	test   %edx,%edx
  800373:	74 18                	je     80038d <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800375:	52                   	push   %edx
  800376:	68 55 26 80 00       	push   $0x802655
  80037b:	53                   	push   %ebx
  80037c:	56                   	push   %esi
  80037d:	e8 b3 fe ff ff       	call   800235 <printfmt>
  800382:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800385:	89 7d 14             	mov    %edi,0x14(%ebp)
  800388:	e9 9a 02 00 00       	jmp    800627 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80038d:	50                   	push   %eax
  80038e:	68 90 22 80 00       	push   $0x802290
  800393:	53                   	push   %ebx
  800394:	56                   	push   %esi
  800395:	e8 9b fe ff ff       	call   800235 <printfmt>
  80039a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a0:	e9 82 02 00 00       	jmp    800627 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a8:	83 c0 04             	add    $0x4,%eax
  8003ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003b3:	85 ff                	test   %edi,%edi
  8003b5:	b8 89 22 80 00       	mov    $0x802289,%eax
  8003ba:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c1:	0f 8e bd 00 00 00    	jle    800484 <vprintfmt+0x232>
  8003c7:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003cb:	75 0e                	jne    8003db <vprintfmt+0x189>
  8003cd:	89 75 08             	mov    %esi,0x8(%ebp)
  8003d0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003d3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003d6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003d9:	eb 6d                	jmp    800448 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e1:	57                   	push   %edi
  8003e2:	e8 6e 03 00 00       	call   800755 <strnlen>
  8003e7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003ea:	29 c1                	sub    %eax,%ecx
  8003ec:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003ef:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003f2:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003fc:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003fe:	eb 0f                	jmp    80040f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800400:	83 ec 08             	sub    $0x8,%esp
  800403:	53                   	push   %ebx
  800404:	ff 75 e0             	pushl  -0x20(%ebp)
  800407:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800409:	83 ef 01             	sub    $0x1,%edi
  80040c:	83 c4 10             	add    $0x10,%esp
  80040f:	85 ff                	test   %edi,%edi
  800411:	7f ed                	jg     800400 <vprintfmt+0x1ae>
  800413:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800416:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800419:	85 c9                	test   %ecx,%ecx
  80041b:	b8 00 00 00 00       	mov    $0x0,%eax
  800420:	0f 49 c1             	cmovns %ecx,%eax
  800423:	29 c1                	sub    %eax,%ecx
  800425:	89 75 08             	mov    %esi,0x8(%ebp)
  800428:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80042b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80042e:	89 cb                	mov    %ecx,%ebx
  800430:	eb 16                	jmp    800448 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800432:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800436:	75 31                	jne    800469 <vprintfmt+0x217>
					putch(ch, putdat);
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	ff 75 0c             	pushl  0xc(%ebp)
  80043e:	50                   	push   %eax
  80043f:	ff 55 08             	call   *0x8(%ebp)
  800442:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800445:	83 eb 01             	sub    $0x1,%ebx
  800448:	83 c7 01             	add    $0x1,%edi
  80044b:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80044f:	0f be c2             	movsbl %dl,%eax
  800452:	85 c0                	test   %eax,%eax
  800454:	74 59                	je     8004af <vprintfmt+0x25d>
  800456:	85 f6                	test   %esi,%esi
  800458:	78 d8                	js     800432 <vprintfmt+0x1e0>
  80045a:	83 ee 01             	sub    $0x1,%esi
  80045d:	79 d3                	jns    800432 <vprintfmt+0x1e0>
  80045f:	89 df                	mov    %ebx,%edi
  800461:	8b 75 08             	mov    0x8(%ebp),%esi
  800464:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800467:	eb 37                	jmp    8004a0 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800469:	0f be d2             	movsbl %dl,%edx
  80046c:	83 ea 20             	sub    $0x20,%edx
  80046f:	83 fa 5e             	cmp    $0x5e,%edx
  800472:	76 c4                	jbe    800438 <vprintfmt+0x1e6>
					putch('?', putdat);
  800474:	83 ec 08             	sub    $0x8,%esp
  800477:	ff 75 0c             	pushl  0xc(%ebp)
  80047a:	6a 3f                	push   $0x3f
  80047c:	ff 55 08             	call   *0x8(%ebp)
  80047f:	83 c4 10             	add    $0x10,%esp
  800482:	eb c1                	jmp    800445 <vprintfmt+0x1f3>
  800484:	89 75 08             	mov    %esi,0x8(%ebp)
  800487:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800490:	eb b6                	jmp    800448 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	53                   	push   %ebx
  800496:	6a 20                	push   $0x20
  800498:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80049a:	83 ef 01             	sub    $0x1,%edi
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	85 ff                	test   %edi,%edi
  8004a2:	7f ee                	jg     800492 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004aa:	e9 78 01 00 00       	jmp    800627 <vprintfmt+0x3d5>
  8004af:	89 df                	mov    %ebx,%edi
  8004b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004b7:	eb e7                	jmp    8004a0 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004b9:	83 f9 01             	cmp    $0x1,%ecx
  8004bc:	7e 3f                	jle    8004fd <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004be:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c1:	8b 50 04             	mov    0x4(%eax),%edx
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8d 40 08             	lea    0x8(%eax),%eax
  8004d2:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d9:	79 5c                	jns    800537 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	53                   	push   %ebx
  8004df:	6a 2d                	push   $0x2d
  8004e1:	ff d6                	call   *%esi
				num = -(long long) num;
  8004e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004e9:	f7 da                	neg    %edx
  8004eb:	83 d1 00             	adc    $0x0,%ecx
  8004ee:	f7 d9                	neg    %ecx
  8004f0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8004f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f8:	e9 10 01 00 00       	jmp    80060d <vprintfmt+0x3bb>
	else if (lflag)
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	75 1b                	jne    80051c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800509:	89 c1                	mov    %eax,%ecx
  80050b:	c1 f9 1f             	sar    $0x1f,%ecx
  80050e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	8d 40 04             	lea    0x4(%eax),%eax
  800517:	89 45 14             	mov    %eax,0x14(%ebp)
  80051a:	eb b9                	jmp    8004d5 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 00                	mov    (%eax),%eax
  800521:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800524:	89 c1                	mov    %eax,%ecx
  800526:	c1 f9 1f             	sar    $0x1f,%ecx
  800529:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 04             	lea    0x4(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
  800535:	eb 9e                	jmp    8004d5 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800537:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80053d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800542:	e9 c6 00 00 00       	jmp    80060d <vprintfmt+0x3bb>
	if (lflag >= 2)
  800547:	83 f9 01             	cmp    $0x1,%ecx
  80054a:	7e 18                	jle    800564 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	8b 10                	mov    (%eax),%edx
  800551:	8b 48 04             	mov    0x4(%eax),%ecx
  800554:	8d 40 08             	lea    0x8(%eax),%eax
  800557:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80055a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055f:	e9 a9 00 00 00       	jmp    80060d <vprintfmt+0x3bb>
	else if (lflag)
  800564:	85 c9                	test   %ecx,%ecx
  800566:	75 1a                	jne    800582 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8b 10                	mov    (%eax),%edx
  80056d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800572:	8d 40 04             	lea    0x4(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800578:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057d:	e9 8b 00 00 00       	jmp    80060d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 10                	mov    (%eax),%edx
  800587:	b9 00 00 00 00       	mov    $0x0,%ecx
  80058c:	8d 40 04             	lea    0x4(%eax),%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800592:	b8 0a 00 00 00       	mov    $0xa,%eax
  800597:	eb 74                	jmp    80060d <vprintfmt+0x3bb>
	if (lflag >= 2)
  800599:	83 f9 01             	cmp    $0x1,%ecx
  80059c:	7e 15                	jle    8005b3 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	8b 10                	mov    (%eax),%edx
  8005a3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005a6:	8d 40 08             	lea    0x8(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b1:	eb 5a                	jmp    80060d <vprintfmt+0x3bb>
	else if (lflag)
  8005b3:	85 c9                	test   %ecx,%ecx
  8005b5:	75 17                	jne    8005ce <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 10                	mov    (%eax),%edx
  8005bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c1:	8d 40 04             	lea    0x4(%eax),%eax
  8005c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c7:	b8 08 00 00 00       	mov    $0x8,%eax
  8005cc:	eb 3f                	jmp    80060d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d8:	8d 40 04             	lea    0x4(%eax),%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005de:	b8 08 00 00 00       	mov    $0x8,%eax
  8005e3:	eb 28                	jmp    80060d <vprintfmt+0x3bb>
			putch('0', putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	53                   	push   %ebx
  8005e9:	6a 30                	push   $0x30
  8005eb:	ff d6                	call   *%esi
			putch('x', putdat);
  8005ed:	83 c4 08             	add    $0x8,%esp
  8005f0:	53                   	push   %ebx
  8005f1:	6a 78                	push   $0x78
  8005f3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 10                	mov    (%eax),%edx
  8005fa:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ff:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800608:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80060d:	83 ec 0c             	sub    $0xc,%esp
  800610:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800614:	57                   	push   %edi
  800615:	ff 75 e0             	pushl  -0x20(%ebp)
  800618:	50                   	push   %eax
  800619:	51                   	push   %ecx
  80061a:	52                   	push   %edx
  80061b:	89 da                	mov    %ebx,%edx
  80061d:	89 f0                	mov    %esi,%eax
  80061f:	e8 45 fb ff ff       	call   800169 <printnum>
			break;
  800624:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800627:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80062a:	83 c7 01             	add    $0x1,%edi
  80062d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800631:	83 f8 25             	cmp    $0x25,%eax
  800634:	0f 84 2f fc ff ff    	je     800269 <vprintfmt+0x17>
			if (ch == '\0')
  80063a:	85 c0                	test   %eax,%eax
  80063c:	0f 84 8b 00 00 00    	je     8006cd <vprintfmt+0x47b>
			putch(ch, putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	53                   	push   %ebx
  800646:	50                   	push   %eax
  800647:	ff d6                	call   *%esi
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb dc                	jmp    80062a <vprintfmt+0x3d8>
	if (lflag >= 2)
  80064e:	83 f9 01             	cmp    $0x1,%ecx
  800651:	7e 15                	jle    800668 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	8b 10                	mov    (%eax),%edx
  800658:	8b 48 04             	mov    0x4(%eax),%ecx
  80065b:	8d 40 08             	lea    0x8(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800661:	b8 10 00 00 00       	mov    $0x10,%eax
  800666:	eb a5                	jmp    80060d <vprintfmt+0x3bb>
	else if (lflag)
  800668:	85 c9                	test   %ecx,%ecx
  80066a:	75 17                	jne    800683 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	b9 00 00 00 00       	mov    $0x0,%ecx
  800676:	8d 40 04             	lea    0x4(%eax),%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067c:	b8 10 00 00 00       	mov    $0x10,%eax
  800681:	eb 8a                	jmp    80060d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	8b 10                	mov    (%eax),%edx
  800688:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068d:	8d 40 04             	lea    0x4(%eax),%eax
  800690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800693:	b8 10 00 00 00       	mov    $0x10,%eax
  800698:	e9 70 ff ff ff       	jmp    80060d <vprintfmt+0x3bb>
			putch(ch, putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	53                   	push   %ebx
  8006a1:	6a 25                	push   $0x25
  8006a3:	ff d6                	call   *%esi
			break;
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	e9 7a ff ff ff       	jmp    800627 <vprintfmt+0x3d5>
			putch('%', putdat);
  8006ad:	83 ec 08             	sub    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 25                	push   $0x25
  8006b3:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006b5:	83 c4 10             	add    $0x10,%esp
  8006b8:	89 f8                	mov    %edi,%eax
  8006ba:	eb 03                	jmp    8006bf <vprintfmt+0x46d>
  8006bc:	83 e8 01             	sub    $0x1,%eax
  8006bf:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006c3:	75 f7                	jne    8006bc <vprintfmt+0x46a>
  8006c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c8:	e9 5a ff ff ff       	jmp    800627 <vprintfmt+0x3d5>
}
  8006cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d0:	5b                   	pop    %ebx
  8006d1:	5e                   	pop    %esi
  8006d2:	5f                   	pop    %edi
  8006d3:	5d                   	pop    %ebp
  8006d4:	c3                   	ret    

008006d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006f2:	85 c0                	test   %eax,%eax
  8006f4:	74 26                	je     80071c <vsnprintf+0x47>
  8006f6:	85 d2                	test   %edx,%edx
  8006f8:	7e 22                	jle    80071c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006fa:	ff 75 14             	pushl  0x14(%ebp)
  8006fd:	ff 75 10             	pushl  0x10(%ebp)
  800700:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800703:	50                   	push   %eax
  800704:	68 18 02 80 00       	push   $0x800218
  800709:	e8 44 fb ff ff       	call   800252 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80070e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800711:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800717:	83 c4 10             	add    $0x10,%esp
}
  80071a:	c9                   	leave  
  80071b:	c3                   	ret    
		return -E_INVAL;
  80071c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800721:	eb f7                	jmp    80071a <vsnprintf+0x45>

00800723 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800723:	55                   	push   %ebp
  800724:	89 e5                	mov    %esp,%ebp
  800726:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800729:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80072c:	50                   	push   %eax
  80072d:	ff 75 10             	pushl  0x10(%ebp)
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	ff 75 08             	pushl  0x8(%ebp)
  800736:	e8 9a ff ff ff       	call   8006d5 <vsnprintf>
	va_end(ap);

	return rc;
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800743:	b8 00 00 00 00       	mov    $0x0,%eax
  800748:	eb 03                	jmp    80074d <strlen+0x10>
		n++;
  80074a:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80074d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800751:	75 f7                	jne    80074a <strlen+0xd>
	return n;
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
  800758:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80075b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80075e:	b8 00 00 00 00       	mov    $0x0,%eax
  800763:	eb 03                	jmp    800768 <strnlen+0x13>
		n++;
  800765:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800768:	39 d0                	cmp    %edx,%eax
  80076a:	74 06                	je     800772 <strnlen+0x1d>
  80076c:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800770:	75 f3                	jne    800765 <strnlen+0x10>
	return n;
}
  800772:	5d                   	pop    %ebp
  800773:	c3                   	ret    

00800774 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80077e:	89 c2                	mov    %eax,%edx
  800780:	83 c1 01             	add    $0x1,%ecx
  800783:	83 c2 01             	add    $0x1,%edx
  800786:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80078a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80078d:	84 db                	test   %bl,%bl
  80078f:	75 ef                	jne    800780 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800791:	5b                   	pop    %ebx
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	53                   	push   %ebx
  800798:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80079b:	53                   	push   %ebx
  80079c:	e8 9c ff ff ff       	call   80073d <strlen>
  8007a1:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	01 d8                	add    %ebx,%eax
  8007a9:	50                   	push   %eax
  8007aa:	e8 c5 ff ff ff       	call   800774 <strcpy>
	return dst;
}
  8007af:	89 d8                	mov    %ebx,%eax
  8007b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007b4:	c9                   	leave  
  8007b5:	c3                   	ret    

008007b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	56                   	push   %esi
  8007ba:	53                   	push   %ebx
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c1:	89 f3                	mov    %esi,%ebx
  8007c3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007c6:	89 f2                	mov    %esi,%edx
  8007c8:	eb 0f                	jmp    8007d9 <strncpy+0x23>
		*dst++ = *src;
  8007ca:	83 c2 01             	add    $0x1,%edx
  8007cd:	0f b6 01             	movzbl (%ecx),%eax
  8007d0:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d3:	80 39 01             	cmpb   $0x1,(%ecx)
  8007d6:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007d9:	39 da                	cmp    %ebx,%edx
  8007db:	75 ed                	jne    8007ca <strncpy+0x14>
	}
	return ret;
}
  8007dd:	89 f0                	mov    %esi,%eax
  8007df:	5b                   	pop    %ebx
  8007e0:	5e                   	pop    %esi
  8007e1:	5d                   	pop    %ebp
  8007e2:	c3                   	ret    

008007e3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	56                   	push   %esi
  8007e7:	53                   	push   %ebx
  8007e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007f1:	89 f0                	mov    %esi,%eax
  8007f3:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f7:	85 c9                	test   %ecx,%ecx
  8007f9:	75 0b                	jne    800806 <strlcpy+0x23>
  8007fb:	eb 17                	jmp    800814 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007fd:	83 c2 01             	add    $0x1,%edx
  800800:	83 c0 01             	add    $0x1,%eax
  800803:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800806:	39 d8                	cmp    %ebx,%eax
  800808:	74 07                	je     800811 <strlcpy+0x2e>
  80080a:	0f b6 0a             	movzbl (%edx),%ecx
  80080d:	84 c9                	test   %cl,%cl
  80080f:	75 ec                	jne    8007fd <strlcpy+0x1a>
		*dst = '\0';
  800811:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800814:	29 f0                	sub    %esi,%eax
}
  800816:	5b                   	pop    %ebx
  800817:	5e                   	pop    %esi
  800818:	5d                   	pop    %ebp
  800819:	c3                   	ret    

0080081a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800820:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800823:	eb 06                	jmp    80082b <strcmp+0x11>
		p++, q++;
  800825:	83 c1 01             	add    $0x1,%ecx
  800828:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80082b:	0f b6 01             	movzbl (%ecx),%eax
  80082e:	84 c0                	test   %al,%al
  800830:	74 04                	je     800836 <strcmp+0x1c>
  800832:	3a 02                	cmp    (%edx),%al
  800834:	74 ef                	je     800825 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800836:	0f b6 c0             	movzbl %al,%eax
  800839:	0f b6 12             	movzbl (%edx),%edx
  80083c:	29 d0                	sub    %edx,%eax
}
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	89 c3                	mov    %eax,%ebx
  80084c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80084f:	eb 06                	jmp    800857 <strncmp+0x17>
		n--, p++, q++;
  800851:	83 c0 01             	add    $0x1,%eax
  800854:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800857:	39 d8                	cmp    %ebx,%eax
  800859:	74 16                	je     800871 <strncmp+0x31>
  80085b:	0f b6 08             	movzbl (%eax),%ecx
  80085e:	84 c9                	test   %cl,%cl
  800860:	74 04                	je     800866 <strncmp+0x26>
  800862:	3a 0a                	cmp    (%edx),%cl
  800864:	74 eb                	je     800851 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800866:	0f b6 00             	movzbl (%eax),%eax
  800869:	0f b6 12             	movzbl (%edx),%edx
  80086c:	29 d0                	sub    %edx,%eax
}
  80086e:	5b                   	pop    %ebx
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    
		return 0;
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	eb f6                	jmp    80086e <strncmp+0x2e>

00800878 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800882:	0f b6 10             	movzbl (%eax),%edx
  800885:	84 d2                	test   %dl,%dl
  800887:	74 09                	je     800892 <strchr+0x1a>
		if (*s == c)
  800889:	38 ca                	cmp    %cl,%dl
  80088b:	74 0a                	je     800897 <strchr+0x1f>
	for (; *s; s++)
  80088d:	83 c0 01             	add    $0x1,%eax
  800890:	eb f0                	jmp    800882 <strchr+0xa>
			return (char *) s;
	return 0;
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800897:	5d                   	pop    %ebp
  800898:	c3                   	ret    

00800899 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800899:	55                   	push   %ebp
  80089a:	89 e5                	mov    %esp,%ebp
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a3:	eb 03                	jmp    8008a8 <strfind+0xf>
  8008a5:	83 c0 01             	add    $0x1,%eax
  8008a8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ab:	38 ca                	cmp    %cl,%dl
  8008ad:	74 04                	je     8008b3 <strfind+0x1a>
  8008af:	84 d2                	test   %dl,%dl
  8008b1:	75 f2                	jne    8008a5 <strfind+0xc>
			break;
	return (char *) s;
}
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	57                   	push   %edi
  8008b9:	56                   	push   %esi
  8008ba:	53                   	push   %ebx
  8008bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008be:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008c1:	85 c9                	test   %ecx,%ecx
  8008c3:	74 13                	je     8008d8 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008c5:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008cb:	75 05                	jne    8008d2 <memset+0x1d>
  8008cd:	f6 c1 03             	test   $0x3,%cl
  8008d0:	74 0d                	je     8008df <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d5:	fc                   	cld    
  8008d6:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008d8:	89 f8                	mov    %edi,%eax
  8008da:	5b                   	pop    %ebx
  8008db:	5e                   	pop    %esi
  8008dc:	5f                   	pop    %edi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    
		c &= 0xFF;
  8008df:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008e3:	89 d3                	mov    %edx,%ebx
  8008e5:	c1 e3 08             	shl    $0x8,%ebx
  8008e8:	89 d0                	mov    %edx,%eax
  8008ea:	c1 e0 18             	shl    $0x18,%eax
  8008ed:	89 d6                	mov    %edx,%esi
  8008ef:	c1 e6 10             	shl    $0x10,%esi
  8008f2:	09 f0                	or     %esi,%eax
  8008f4:	09 c2                	or     %eax,%edx
  8008f6:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008f8:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008fb:	89 d0                	mov    %edx,%eax
  8008fd:	fc                   	cld    
  8008fe:	f3 ab                	rep stos %eax,%es:(%edi)
  800900:	eb d6                	jmp    8008d8 <memset+0x23>

00800902 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	57                   	push   %edi
  800906:	56                   	push   %esi
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80090d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800910:	39 c6                	cmp    %eax,%esi
  800912:	73 35                	jae    800949 <memmove+0x47>
  800914:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800917:	39 c2                	cmp    %eax,%edx
  800919:	76 2e                	jbe    800949 <memmove+0x47>
		s += n;
		d += n;
  80091b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80091e:	89 d6                	mov    %edx,%esi
  800920:	09 fe                	or     %edi,%esi
  800922:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800928:	74 0c                	je     800936 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80092a:	83 ef 01             	sub    $0x1,%edi
  80092d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800930:	fd                   	std    
  800931:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800933:	fc                   	cld    
  800934:	eb 21                	jmp    800957 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800936:	f6 c1 03             	test   $0x3,%cl
  800939:	75 ef                	jne    80092a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80093b:	83 ef 04             	sub    $0x4,%edi
  80093e:	8d 72 fc             	lea    -0x4(%edx),%esi
  800941:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800944:	fd                   	std    
  800945:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800947:	eb ea                	jmp    800933 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800949:	89 f2                	mov    %esi,%edx
  80094b:	09 c2                	or     %eax,%edx
  80094d:	f6 c2 03             	test   $0x3,%dl
  800950:	74 09                	je     80095b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800952:	89 c7                	mov    %eax,%edi
  800954:	fc                   	cld    
  800955:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800957:	5e                   	pop    %esi
  800958:	5f                   	pop    %edi
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095b:	f6 c1 03             	test   $0x3,%cl
  80095e:	75 f2                	jne    800952 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800960:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800963:	89 c7                	mov    %eax,%edi
  800965:	fc                   	cld    
  800966:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800968:	eb ed                	jmp    800957 <memmove+0x55>

0080096a <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80096d:	ff 75 10             	pushl  0x10(%ebp)
  800970:	ff 75 0c             	pushl  0xc(%ebp)
  800973:	ff 75 08             	pushl  0x8(%ebp)
  800976:	e8 87 ff ff ff       	call   800902 <memmove>
}
  80097b:	c9                   	leave  
  80097c:	c3                   	ret    

0080097d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	56                   	push   %esi
  800981:	53                   	push   %ebx
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 55 0c             	mov    0xc(%ebp),%edx
  800988:	89 c6                	mov    %eax,%esi
  80098a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80098d:	39 f0                	cmp    %esi,%eax
  80098f:	74 1c                	je     8009ad <memcmp+0x30>
		if (*s1 != *s2)
  800991:	0f b6 08             	movzbl (%eax),%ecx
  800994:	0f b6 1a             	movzbl (%edx),%ebx
  800997:	38 d9                	cmp    %bl,%cl
  800999:	75 08                	jne    8009a3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	83 c2 01             	add    $0x1,%edx
  8009a1:	eb ea                	jmp    80098d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009a3:	0f b6 c1             	movzbl %cl,%eax
  8009a6:	0f b6 db             	movzbl %bl,%ebx
  8009a9:	29 d8                	sub    %ebx,%eax
  8009ab:	eb 05                	jmp    8009b2 <memcmp+0x35>
	}

	return 0;
  8009ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b2:	5b                   	pop    %ebx
  8009b3:	5e                   	pop    %esi
  8009b4:	5d                   	pop    %ebp
  8009b5:	c3                   	ret    

008009b6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009b6:	55                   	push   %ebp
  8009b7:	89 e5                	mov    %esp,%ebp
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009bf:	89 c2                	mov    %eax,%edx
  8009c1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009c4:	39 d0                	cmp    %edx,%eax
  8009c6:	73 09                	jae    8009d1 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009c8:	38 08                	cmp    %cl,(%eax)
  8009ca:	74 05                	je     8009d1 <memfind+0x1b>
	for (; s < ends; s++)
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	eb f3                	jmp    8009c4 <memfind+0xe>
			break;
	return (void *) s;
}
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    

008009d3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	57                   	push   %edi
  8009d7:	56                   	push   %esi
  8009d8:	53                   	push   %ebx
  8009d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009df:	eb 03                	jmp    8009e4 <strtol+0x11>
		s++;
  8009e1:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009e4:	0f b6 01             	movzbl (%ecx),%eax
  8009e7:	3c 20                	cmp    $0x20,%al
  8009e9:	74 f6                	je     8009e1 <strtol+0xe>
  8009eb:	3c 09                	cmp    $0x9,%al
  8009ed:	74 f2                	je     8009e1 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009ef:	3c 2b                	cmp    $0x2b,%al
  8009f1:	74 2e                	je     800a21 <strtol+0x4e>
	int neg = 0;
  8009f3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  8009f8:	3c 2d                	cmp    $0x2d,%al
  8009fa:	74 2f                	je     800a2b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009fc:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a02:	75 05                	jne    800a09 <strtol+0x36>
  800a04:	80 39 30             	cmpb   $0x30,(%ecx)
  800a07:	74 2c                	je     800a35 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a09:	85 db                	test   %ebx,%ebx
  800a0b:	75 0a                	jne    800a17 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a0d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a12:	80 39 30             	cmpb   $0x30,(%ecx)
  800a15:	74 28                	je     800a3f <strtol+0x6c>
		base = 10;
  800a17:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a1f:	eb 50                	jmp    800a71 <strtol+0x9e>
		s++;
  800a21:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a24:	bf 00 00 00 00       	mov    $0x0,%edi
  800a29:	eb d1                	jmp    8009fc <strtol+0x29>
		s++, neg = 1;
  800a2b:	83 c1 01             	add    $0x1,%ecx
  800a2e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a33:	eb c7                	jmp    8009fc <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a35:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a39:	74 0e                	je     800a49 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a3b:	85 db                	test   %ebx,%ebx
  800a3d:	75 d8                	jne    800a17 <strtol+0x44>
		s++, base = 8;
  800a3f:	83 c1 01             	add    $0x1,%ecx
  800a42:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a47:	eb ce                	jmp    800a17 <strtol+0x44>
		s += 2, base = 16;
  800a49:	83 c1 02             	add    $0x2,%ecx
  800a4c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a51:	eb c4                	jmp    800a17 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a53:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a56:	89 f3                	mov    %esi,%ebx
  800a58:	80 fb 19             	cmp    $0x19,%bl
  800a5b:	77 29                	ja     800a86 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a5d:	0f be d2             	movsbl %dl,%edx
  800a60:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a63:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a66:	7d 30                	jge    800a98 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a68:	83 c1 01             	add    $0x1,%ecx
  800a6b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a71:	0f b6 11             	movzbl (%ecx),%edx
  800a74:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a77:	89 f3                	mov    %esi,%ebx
  800a79:	80 fb 09             	cmp    $0x9,%bl
  800a7c:	77 d5                	ja     800a53 <strtol+0x80>
			dig = *s - '0';
  800a7e:	0f be d2             	movsbl %dl,%edx
  800a81:	83 ea 30             	sub    $0x30,%edx
  800a84:	eb dd                	jmp    800a63 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a86:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a89:	89 f3                	mov    %esi,%ebx
  800a8b:	80 fb 19             	cmp    $0x19,%bl
  800a8e:	77 08                	ja     800a98 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a90:	0f be d2             	movsbl %dl,%edx
  800a93:	83 ea 37             	sub    $0x37,%edx
  800a96:	eb cb                	jmp    800a63 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a9c:	74 05                	je     800aa3 <strtol+0xd0>
		*endptr = (char *) s;
  800a9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aa1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800aa3:	89 c2                	mov    %eax,%edx
  800aa5:	f7 da                	neg    %edx
  800aa7:	85 ff                	test   %edi,%edi
  800aa9:	0f 45 c2             	cmovne %edx,%eax
}
  800aac:	5b                   	pop    %ebx
  800aad:	5e                   	pop    %esi
  800aae:	5f                   	pop    %edi
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	57                   	push   %edi
  800ab5:	56                   	push   %esi
  800ab6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
  800abc:	8b 55 08             	mov    0x8(%ebp),%edx
  800abf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac2:	89 c3                	mov    %eax,%ebx
  800ac4:	89 c7                	mov    %eax,%edi
  800ac6:	89 c6                	mov    %eax,%esi
  800ac8:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5f                   	pop    %edi
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    

00800acf <sys_cgetc>:

int
sys_cgetc(void)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	b8 01 00 00 00       	mov    $0x1,%eax
  800adf:	89 d1                	mov    %edx,%ecx
  800ae1:	89 d3                	mov    %edx,%ebx
  800ae3:	89 d7                	mov    %edx,%edi
  800ae5:	89 d6                	mov    %edx,%esi
  800ae7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ae9:	5b                   	pop    %ebx
  800aea:	5e                   	pop    %esi
  800aeb:	5f                   	pop    %edi
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	57                   	push   %edi
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800af7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800afc:	8b 55 08             	mov    0x8(%ebp),%edx
  800aff:	b8 03 00 00 00       	mov    $0x3,%eax
  800b04:	89 cb                	mov    %ecx,%ebx
  800b06:	89 cf                	mov    %ecx,%edi
  800b08:	89 ce                	mov    %ecx,%esi
  800b0a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b0c:	85 c0                	test   %eax,%eax
  800b0e:	7f 08                	jg     800b18 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b13:	5b                   	pop    %ebx
  800b14:	5e                   	pop    %esi
  800b15:	5f                   	pop    %edi
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b18:	83 ec 0c             	sub    $0xc,%esp
  800b1b:	50                   	push   %eax
  800b1c:	6a 03                	push   $0x3
  800b1e:	68 7f 25 80 00       	push   $0x80257f
  800b23:	6a 23                	push   $0x23
  800b25:	68 9c 25 80 00       	push   $0x80259c
  800b2a:	e8 6e 13 00 00       	call   801e9d <_panic>

00800b2f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b3f:	89 d1                	mov    %edx,%ecx
  800b41:	89 d3                	mov    %edx,%ebx
  800b43:	89 d7                	mov    %edx,%edi
  800b45:	89 d6                	mov    %edx,%esi
  800b47:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <sys_yield>:

void
sys_yield(void)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b54:	ba 00 00 00 00       	mov    $0x0,%edx
  800b59:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b5e:	89 d1                	mov    %edx,%ecx
  800b60:	89 d3                	mov    %edx,%ebx
  800b62:	89 d7                	mov    %edx,%edi
  800b64:	89 d6                	mov    %edx,%esi
  800b66:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5f                   	pop    %edi
  800b6b:	5d                   	pop    %ebp
  800b6c:	c3                   	ret    

00800b6d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	57                   	push   %edi
  800b71:	56                   	push   %esi
  800b72:	53                   	push   %ebx
  800b73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b76:	be 00 00 00 00       	mov    $0x0,%esi
  800b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b81:	b8 04 00 00 00       	mov    $0x4,%eax
  800b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b89:	89 f7                	mov    %esi,%edi
  800b8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8d:	85 c0                	test   %eax,%eax
  800b8f:	7f 08                	jg     800b99 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5f                   	pop    %edi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	50                   	push   %eax
  800b9d:	6a 04                	push   $0x4
  800b9f:	68 7f 25 80 00       	push   $0x80257f
  800ba4:	6a 23                	push   $0x23
  800ba6:	68 9c 25 80 00       	push   $0x80259c
  800bab:	e8 ed 12 00 00       	call   801e9d <_panic>

00800bb0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbf:	b8 05 00 00 00       	mov    $0x5,%eax
  800bc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bca:	8b 75 18             	mov    0x18(%ebp),%esi
  800bcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bcf:	85 c0                	test   %eax,%eax
  800bd1:	7f 08                	jg     800bdb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bdb:	83 ec 0c             	sub    $0xc,%esp
  800bde:	50                   	push   %eax
  800bdf:	6a 05                	push   $0x5
  800be1:	68 7f 25 80 00       	push   $0x80257f
  800be6:	6a 23                	push   $0x23
  800be8:	68 9c 25 80 00       	push   $0x80259c
  800bed:	e8 ab 12 00 00       	call   801e9d <_panic>

00800bf2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	57                   	push   %edi
  800bf6:	56                   	push   %esi
  800bf7:	53                   	push   %ebx
  800bf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c00:	8b 55 08             	mov    0x8(%ebp),%edx
  800c03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c06:	b8 06 00 00 00       	mov    $0x6,%eax
  800c0b:	89 df                	mov    %ebx,%edi
  800c0d:	89 de                	mov    %ebx,%esi
  800c0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7f 08                	jg     800c1d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1d:	83 ec 0c             	sub    $0xc,%esp
  800c20:	50                   	push   %eax
  800c21:	6a 06                	push   $0x6
  800c23:	68 7f 25 80 00       	push   $0x80257f
  800c28:	6a 23                	push   $0x23
  800c2a:	68 9c 25 80 00       	push   $0x80259c
  800c2f:	e8 69 12 00 00       	call   801e9d <_panic>

00800c34 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	b8 08 00 00 00       	mov    $0x8,%eax
  800c4d:	89 df                	mov    %ebx,%edi
  800c4f:	89 de                	mov    %ebx,%esi
  800c51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7f 08                	jg     800c5f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c5a:	5b                   	pop    %ebx
  800c5b:	5e                   	pop    %esi
  800c5c:	5f                   	pop    %edi
  800c5d:	5d                   	pop    %ebp
  800c5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	50                   	push   %eax
  800c63:	6a 08                	push   $0x8
  800c65:	68 7f 25 80 00       	push   $0x80257f
  800c6a:	6a 23                	push   $0x23
  800c6c:	68 9c 25 80 00       	push   $0x80259c
  800c71:	e8 27 12 00 00       	call   801e9d <_panic>

00800c76 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	57                   	push   %edi
  800c7a:	56                   	push   %esi
  800c7b:	53                   	push   %ebx
  800c7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8a:	b8 09 00 00 00       	mov    $0x9,%eax
  800c8f:	89 df                	mov    %ebx,%edi
  800c91:	89 de                	mov    %ebx,%esi
  800c93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	7f 08                	jg     800ca1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca1:	83 ec 0c             	sub    $0xc,%esp
  800ca4:	50                   	push   %eax
  800ca5:	6a 09                	push   $0x9
  800ca7:	68 7f 25 80 00       	push   $0x80257f
  800cac:	6a 23                	push   $0x23
  800cae:	68 9c 25 80 00       	push   $0x80259c
  800cb3:	e8 e5 11 00 00       	call   801e9d <_panic>

00800cb8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	57                   	push   %edi
  800cbc:	56                   	push   %esi
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd1:	89 df                	mov    %ebx,%edi
  800cd3:	89 de                	mov    %ebx,%esi
  800cd5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd7:	85 c0                	test   %eax,%eax
  800cd9:	7f 08                	jg     800ce3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	50                   	push   %eax
  800ce7:	6a 0a                	push   $0xa
  800ce9:	68 7f 25 80 00       	push   $0x80257f
  800cee:	6a 23                	push   $0x23
  800cf0:	68 9c 25 80 00       	push   $0x80259c
  800cf5:	e8 a3 11 00 00       	call   801e9d <_panic>

00800cfa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d0b:	be 00 00 00 00       	mov    $0x0,%esi
  800d10:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d13:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d16:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
  800d23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d26:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d33:	89 cb                	mov    %ecx,%ebx
  800d35:	89 cf                	mov    %ecx,%edi
  800d37:	89 ce                	mov    %ecx,%esi
  800d39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3b:	85 c0                	test   %eax,%eax
  800d3d:	7f 08                	jg     800d47 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d47:	83 ec 0c             	sub    $0xc,%esp
  800d4a:	50                   	push   %eax
  800d4b:	6a 0d                	push   $0xd
  800d4d:	68 7f 25 80 00       	push   $0x80257f
  800d52:	6a 23                	push   $0x23
  800d54:	68 9c 25 80 00       	push   $0x80259c
  800d59:	e8 3f 11 00 00       	call   801e9d <_panic>

00800d5e <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d64:	ba 00 00 00 00       	mov    $0x0,%edx
  800d69:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d6e:	89 d1                	mov    %edx,%ecx
  800d70:	89 d3                	mov    %edx,%ebx
  800d72:	89 d7                	mov    %edx,%edi
  800d74:	89 d6                	mov    %edx,%esi
  800d76:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	05 00 00 00 30       	add    $0x30000000,%eax
  800d88:	c1 e8 0c             	shr    $0xc,%eax
}
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800d98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d9d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800daa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	c1 ea 16             	shr    $0x16,%edx
  800db4:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dbb:	f6 c2 01             	test   $0x1,%dl
  800dbe:	74 2a                	je     800dea <fd_alloc+0x46>
  800dc0:	89 c2                	mov    %eax,%edx
  800dc2:	c1 ea 0c             	shr    $0xc,%edx
  800dc5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800dcc:	f6 c2 01             	test   $0x1,%dl
  800dcf:	74 19                	je     800dea <fd_alloc+0x46>
  800dd1:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800dd6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ddb:	75 d2                	jne    800daf <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ddd:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800de3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800de8:	eb 07                	jmp    800df1 <fd_alloc+0x4d>
			*fd_store = fd;
  800dea:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800df9:	83 f8 1f             	cmp    $0x1f,%eax
  800dfc:	77 36                	ja     800e34 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800dfe:	c1 e0 0c             	shl    $0xc,%eax
  800e01:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e06:	89 c2                	mov    %eax,%edx
  800e08:	c1 ea 16             	shr    $0x16,%edx
  800e0b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e12:	f6 c2 01             	test   $0x1,%dl
  800e15:	74 24                	je     800e3b <fd_lookup+0x48>
  800e17:	89 c2                	mov    %eax,%edx
  800e19:	c1 ea 0c             	shr    $0xc,%edx
  800e1c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e23:	f6 c2 01             	test   $0x1,%dl
  800e26:	74 1a                	je     800e42 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2b:	89 02                	mov    %eax,(%edx)
	return 0;
  800e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    
		return -E_INVAL;
  800e34:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e39:	eb f7                	jmp    800e32 <fd_lookup+0x3f>
		return -E_INVAL;
  800e3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e40:	eb f0                	jmp    800e32 <fd_lookup+0x3f>
  800e42:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e47:	eb e9                	jmp    800e32 <fd_lookup+0x3f>

00800e49 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e52:	ba 28 26 80 00       	mov    $0x802628,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e57:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e5c:	39 08                	cmp    %ecx,(%eax)
  800e5e:	74 33                	je     800e93 <dev_lookup+0x4a>
  800e60:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e63:	8b 02                	mov    (%edx),%eax
  800e65:	85 c0                	test   %eax,%eax
  800e67:	75 f3                	jne    800e5c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e69:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800e6e:	8b 40 48             	mov    0x48(%eax),%eax
  800e71:	83 ec 04             	sub    $0x4,%esp
  800e74:	51                   	push   %ecx
  800e75:	50                   	push   %eax
  800e76:	68 ac 25 80 00       	push   $0x8025ac
  800e7b:	e8 d5 f2 ff ff       	call   800155 <cprintf>
	*dev = 0;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e89:	83 c4 10             	add    $0x10,%esp
  800e8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800e91:	c9                   	leave  
  800e92:	c3                   	ret    
			*dev = devtab[i];
  800e93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e96:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e98:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9d:	eb f2                	jmp    800e91 <dev_lookup+0x48>

00800e9f <fd_close>:
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 1c             	sub    $0x1c,%esp
  800ea8:	8b 75 08             	mov    0x8(%ebp),%esi
  800eab:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eb1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800eb8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ebb:	50                   	push   %eax
  800ebc:	e8 32 ff ff ff       	call   800df3 <fd_lookup>
  800ec1:	89 c3                	mov    %eax,%ebx
  800ec3:	83 c4 08             	add    $0x8,%esp
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	78 05                	js     800ecf <fd_close+0x30>
	    || fd != fd2)
  800eca:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ecd:	74 16                	je     800ee5 <fd_close+0x46>
		return (must_exist ? r : 0);
  800ecf:	89 f8                	mov    %edi,%eax
  800ed1:	84 c0                	test   %al,%al
  800ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed8:	0f 44 d8             	cmove  %eax,%ebx
}
  800edb:	89 d8                	mov    %ebx,%eax
  800edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ee0:	5b                   	pop    %ebx
  800ee1:	5e                   	pop    %esi
  800ee2:	5f                   	pop    %edi
  800ee3:	5d                   	pop    %ebp
  800ee4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800eeb:	50                   	push   %eax
  800eec:	ff 36                	pushl  (%esi)
  800eee:	e8 56 ff ff ff       	call   800e49 <dev_lookup>
  800ef3:	89 c3                	mov    %eax,%ebx
  800ef5:	83 c4 10             	add    $0x10,%esp
  800ef8:	85 c0                	test   %eax,%eax
  800efa:	78 15                	js     800f11 <fd_close+0x72>
		if (dev->dev_close)
  800efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800eff:	8b 40 10             	mov    0x10(%eax),%eax
  800f02:	85 c0                	test   %eax,%eax
  800f04:	74 1b                	je     800f21 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	56                   	push   %esi
  800f0a:	ff d0                	call   *%eax
  800f0c:	89 c3                	mov    %eax,%ebx
  800f0e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f11:	83 ec 08             	sub    $0x8,%esp
  800f14:	56                   	push   %esi
  800f15:	6a 00                	push   $0x0
  800f17:	e8 d6 fc ff ff       	call   800bf2 <sys_page_unmap>
	return r;
  800f1c:	83 c4 10             	add    $0x10,%esp
  800f1f:	eb ba                	jmp    800edb <fd_close+0x3c>
			r = 0;
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f26:	eb e9                	jmp    800f11 <fd_close+0x72>

00800f28 <close>:

int
close(int fdnum)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f31:	50                   	push   %eax
  800f32:	ff 75 08             	pushl  0x8(%ebp)
  800f35:	e8 b9 fe ff ff       	call   800df3 <fd_lookup>
  800f3a:	83 c4 08             	add    $0x8,%esp
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	78 10                	js     800f51 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	6a 01                	push   $0x1
  800f46:	ff 75 f4             	pushl  -0xc(%ebp)
  800f49:	e8 51 ff ff ff       	call   800e9f <fd_close>
  800f4e:	83 c4 10             	add    $0x10,%esp
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <close_all>:

void
close_all(void)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	53                   	push   %ebx
  800f57:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f5a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f5f:	83 ec 0c             	sub    $0xc,%esp
  800f62:	53                   	push   %ebx
  800f63:	e8 c0 ff ff ff       	call   800f28 <close>
	for (i = 0; i < MAXFD; i++)
  800f68:	83 c3 01             	add    $0x1,%ebx
  800f6b:	83 c4 10             	add    $0x10,%esp
  800f6e:	83 fb 20             	cmp    $0x20,%ebx
  800f71:	75 ec                	jne    800f5f <close_all+0xc>
}
  800f73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	57                   	push   %edi
  800f7c:	56                   	push   %esi
  800f7d:	53                   	push   %ebx
  800f7e:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f81:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f84:	50                   	push   %eax
  800f85:	ff 75 08             	pushl  0x8(%ebp)
  800f88:	e8 66 fe ff ff       	call   800df3 <fd_lookup>
  800f8d:	89 c3                	mov    %eax,%ebx
  800f8f:	83 c4 08             	add    $0x8,%esp
  800f92:	85 c0                	test   %eax,%eax
  800f94:	0f 88 81 00 00 00    	js     80101b <dup+0xa3>
		return r;
	close(newfdnum);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	ff 75 0c             	pushl  0xc(%ebp)
  800fa0:	e8 83 ff ff ff       	call   800f28 <close>

	newfd = INDEX2FD(newfdnum);
  800fa5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fa8:	c1 e6 0c             	shl    $0xc,%esi
  800fab:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fb1:	83 c4 04             	add    $0x4,%esp
  800fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fb7:	e8 d1 fd ff ff       	call   800d8d <fd2data>
  800fbc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fbe:	89 34 24             	mov    %esi,(%esp)
  800fc1:	e8 c7 fd ff ff       	call   800d8d <fd2data>
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	c1 e8 16             	shr    $0x16,%eax
  800fd0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd7:	a8 01                	test   $0x1,%al
  800fd9:	74 11                	je     800fec <dup+0x74>
  800fdb:	89 d8                	mov    %ebx,%eax
  800fdd:	c1 e8 0c             	shr    $0xc,%eax
  800fe0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fe7:	f6 c2 01             	test   $0x1,%dl
  800fea:	75 39                	jne    801025 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800fec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fef:	89 d0                	mov    %edx,%eax
  800ff1:	c1 e8 0c             	shr    $0xc,%eax
  800ff4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	25 07 0e 00 00       	and    $0xe07,%eax
  801003:	50                   	push   %eax
  801004:	56                   	push   %esi
  801005:	6a 00                	push   $0x0
  801007:	52                   	push   %edx
  801008:	6a 00                	push   $0x0
  80100a:	e8 a1 fb ff ff       	call   800bb0 <sys_page_map>
  80100f:	89 c3                	mov    %eax,%ebx
  801011:	83 c4 20             	add    $0x20,%esp
  801014:	85 c0                	test   %eax,%eax
  801016:	78 31                	js     801049 <dup+0xd1>
		goto err;

	return newfdnum;
  801018:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80101b:	89 d8                	mov    %ebx,%eax
  80101d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801025:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	25 07 0e 00 00       	and    $0xe07,%eax
  801034:	50                   	push   %eax
  801035:	57                   	push   %edi
  801036:	6a 00                	push   $0x0
  801038:	53                   	push   %ebx
  801039:	6a 00                	push   $0x0
  80103b:	e8 70 fb ff ff       	call   800bb0 <sys_page_map>
  801040:	89 c3                	mov    %eax,%ebx
  801042:	83 c4 20             	add    $0x20,%esp
  801045:	85 c0                	test   %eax,%eax
  801047:	79 a3                	jns    800fec <dup+0x74>
	sys_page_unmap(0, newfd);
  801049:	83 ec 08             	sub    $0x8,%esp
  80104c:	56                   	push   %esi
  80104d:	6a 00                	push   $0x0
  80104f:	e8 9e fb ff ff       	call   800bf2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801054:	83 c4 08             	add    $0x8,%esp
  801057:	57                   	push   %edi
  801058:	6a 00                	push   $0x0
  80105a:	e8 93 fb ff ff       	call   800bf2 <sys_page_unmap>
	return r;
  80105f:	83 c4 10             	add    $0x10,%esp
  801062:	eb b7                	jmp    80101b <dup+0xa3>

00801064 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	53                   	push   %ebx
  801068:	83 ec 14             	sub    $0x14,%esp
  80106b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80106e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	53                   	push   %ebx
  801073:	e8 7b fd ff ff       	call   800df3 <fd_lookup>
  801078:	83 c4 08             	add    $0x8,%esp
  80107b:	85 c0                	test   %eax,%eax
  80107d:	78 3f                	js     8010be <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80107f:	83 ec 08             	sub    $0x8,%esp
  801082:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801085:	50                   	push   %eax
  801086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801089:	ff 30                	pushl  (%eax)
  80108b:	e8 b9 fd ff ff       	call   800e49 <dev_lookup>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 27                	js     8010be <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801097:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80109a:	8b 42 08             	mov    0x8(%edx),%eax
  80109d:	83 e0 03             	and    $0x3,%eax
  8010a0:	83 f8 01             	cmp    $0x1,%eax
  8010a3:	74 1e                	je     8010c3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a8:	8b 40 08             	mov    0x8(%eax),%eax
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	74 35                	je     8010e4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010af:	83 ec 04             	sub    $0x4,%esp
  8010b2:	ff 75 10             	pushl  0x10(%ebp)
  8010b5:	ff 75 0c             	pushl  0xc(%ebp)
  8010b8:	52                   	push   %edx
  8010b9:	ff d0                	call   *%eax
  8010bb:	83 c4 10             	add    $0x10,%esp
}
  8010be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010c3:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8010c8:	8b 40 48             	mov    0x48(%eax),%eax
  8010cb:	83 ec 04             	sub    $0x4,%esp
  8010ce:	53                   	push   %ebx
  8010cf:	50                   	push   %eax
  8010d0:	68 ed 25 80 00       	push   $0x8025ed
  8010d5:	e8 7b f0 ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  8010da:	83 c4 10             	add    $0x10,%esp
  8010dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e2:	eb da                	jmp    8010be <read+0x5a>
		return -E_NOT_SUPP;
  8010e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010e9:	eb d3                	jmp    8010be <read+0x5a>

008010eb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	57                   	push   %edi
  8010ef:	56                   	push   %esi
  8010f0:	53                   	push   %ebx
  8010f1:	83 ec 0c             	sub    $0xc,%esp
  8010f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010f7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8010fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ff:	39 f3                	cmp    %esi,%ebx
  801101:	73 25                	jae    801128 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	89 f0                	mov    %esi,%eax
  801108:	29 d8                	sub    %ebx,%eax
  80110a:	50                   	push   %eax
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	03 45 0c             	add    0xc(%ebp),%eax
  801110:	50                   	push   %eax
  801111:	57                   	push   %edi
  801112:	e8 4d ff ff ff       	call   801064 <read>
		if (m < 0)
  801117:	83 c4 10             	add    $0x10,%esp
  80111a:	85 c0                	test   %eax,%eax
  80111c:	78 08                	js     801126 <readn+0x3b>
			return m;
		if (m == 0)
  80111e:	85 c0                	test   %eax,%eax
  801120:	74 06                	je     801128 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801122:	01 c3                	add    %eax,%ebx
  801124:	eb d9                	jmp    8010ff <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801126:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801128:	89 d8                	mov    %ebx,%eax
  80112a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5e                   	pop    %esi
  80112f:	5f                   	pop    %edi
  801130:	5d                   	pop    %ebp
  801131:	c3                   	ret    

00801132 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801132:	55                   	push   %ebp
  801133:	89 e5                	mov    %esp,%ebp
  801135:	53                   	push   %ebx
  801136:	83 ec 14             	sub    $0x14,%esp
  801139:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80113c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80113f:	50                   	push   %eax
  801140:	53                   	push   %ebx
  801141:	e8 ad fc ff ff       	call   800df3 <fd_lookup>
  801146:	83 c4 08             	add    $0x8,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 3a                	js     801187 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801153:	50                   	push   %eax
  801154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801157:	ff 30                	pushl  (%eax)
  801159:	e8 eb fc ff ff       	call   800e49 <dev_lookup>
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	78 22                	js     801187 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801168:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80116c:	74 1e                	je     80118c <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80116e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801171:	8b 52 0c             	mov    0xc(%edx),%edx
  801174:	85 d2                	test   %edx,%edx
  801176:	74 35                	je     8011ad <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801178:	83 ec 04             	sub    $0x4,%esp
  80117b:	ff 75 10             	pushl  0x10(%ebp)
  80117e:	ff 75 0c             	pushl  0xc(%ebp)
  801181:	50                   	push   %eax
  801182:	ff d2                	call   *%edx
  801184:	83 c4 10             	add    $0x10,%esp
}
  801187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80118c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801191:	8b 40 48             	mov    0x48(%eax),%eax
  801194:	83 ec 04             	sub    $0x4,%esp
  801197:	53                   	push   %ebx
  801198:	50                   	push   %eax
  801199:	68 09 26 80 00       	push   $0x802609
  80119e:	e8 b2 ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ab:	eb da                	jmp    801187 <write+0x55>
		return -E_NOT_SUPP;
  8011ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011b2:	eb d3                	jmp    801187 <write+0x55>

008011b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011bd:	50                   	push   %eax
  8011be:	ff 75 08             	pushl  0x8(%ebp)
  8011c1:	e8 2d fc ff ff       	call   800df3 <fd_lookup>
  8011c6:	83 c4 08             	add    $0x8,%esp
  8011c9:	85 c0                	test   %eax,%eax
  8011cb:	78 0e                	js     8011db <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d3:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
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
  8011ec:	e8 02 fc ff ff       	call   800df3 <fd_lookup>
  8011f1:	83 c4 08             	add    $0x8,%esp
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	78 37                	js     80122f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011f8:	83 ec 08             	sub    $0x8,%esp
  8011fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011fe:	50                   	push   %eax
  8011ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801202:	ff 30                	pushl  (%eax)
  801204:	e8 40 fc ff ff       	call   800e49 <dev_lookup>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 1f                	js     80122f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801213:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801217:	74 1b                	je     801234 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121c:	8b 52 18             	mov    0x18(%edx),%edx
  80121f:	85 d2                	test   %edx,%edx
  801221:	74 32                	je     801255 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801223:	83 ec 08             	sub    $0x8,%esp
  801226:	ff 75 0c             	pushl  0xc(%ebp)
  801229:	50                   	push   %eax
  80122a:	ff d2                	call   *%edx
  80122c:	83 c4 10             	add    $0x10,%esp
}
  80122f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801232:	c9                   	leave  
  801233:	c3                   	ret    
			thisenv->env_id, fdnum);
  801234:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801239:	8b 40 48             	mov    0x48(%eax),%eax
  80123c:	83 ec 04             	sub    $0x4,%esp
  80123f:	53                   	push   %ebx
  801240:	50                   	push   %eax
  801241:	68 cc 25 80 00       	push   $0x8025cc
  801246:	e8 0a ef ff ff       	call   800155 <cprintf>
		return -E_INVAL;
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801253:	eb da                	jmp    80122f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801255:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80125a:	eb d3                	jmp    80122f <ftruncate+0x52>

0080125c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80125c:	55                   	push   %ebp
  80125d:	89 e5                	mov    %esp,%ebp
  80125f:	53                   	push   %ebx
  801260:	83 ec 14             	sub    $0x14,%esp
  801263:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801266:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 81 fb ff ff       	call   800df3 <fd_lookup>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	78 4b                	js     8012c4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801279:	83 ec 08             	sub    $0x8,%esp
  80127c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80127f:	50                   	push   %eax
  801280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801283:	ff 30                	pushl  (%eax)
  801285:	e8 bf fb ff ff       	call   800e49 <dev_lookup>
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	78 33                	js     8012c4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801294:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801298:	74 2f                	je     8012c9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80129a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80129d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012a4:	00 00 00 
	stat->st_isdir = 0;
  8012a7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012ae:	00 00 00 
	stat->st_dev = dev;
  8012b1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012b7:	83 ec 08             	sub    $0x8,%esp
  8012ba:	53                   	push   %ebx
  8012bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8012be:	ff 50 14             	call   *0x14(%eax)
  8012c1:	83 c4 10             	add    $0x10,%esp
}
  8012c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    
		return -E_NOT_SUPP;
  8012c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ce:	eb f4                	jmp    8012c4 <fstat+0x68>

008012d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	56                   	push   %esi
  8012d4:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	6a 00                	push   $0x0
  8012da:	ff 75 08             	pushl  0x8(%ebp)
  8012dd:	e8 e7 01 00 00       	call   8014c9 <open>
  8012e2:	89 c3                	mov    %eax,%ebx
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	78 1b                	js     801306 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012eb:	83 ec 08             	sub    $0x8,%esp
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	50                   	push   %eax
  8012f2:	e8 65 ff ff ff       	call   80125c <fstat>
  8012f7:	89 c6                	mov    %eax,%esi
	close(fd);
  8012f9:	89 1c 24             	mov    %ebx,(%esp)
  8012fc:	e8 27 fc ff ff       	call   800f28 <close>
	return r;
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	89 f3                	mov    %esi,%ebx
}
  801306:	89 d8                	mov    %ebx,%eax
  801308:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80130b:	5b                   	pop    %ebx
  80130c:	5e                   	pop    %esi
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	56                   	push   %esi
  801313:	53                   	push   %ebx
  801314:	89 c6                	mov    %eax,%esi
  801316:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801318:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80131f:	74 27                	je     801348 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801321:	6a 07                	push   $0x7
  801323:	68 00 50 80 00       	push   $0x805000
  801328:	56                   	push   %esi
  801329:	ff 35 00 40 80 00    	pushl  0x804000
  80132f:	e8 16 0c 00 00       	call   801f4a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801334:	83 c4 0c             	add    $0xc,%esp
  801337:	6a 00                	push   $0x0
  801339:	53                   	push   %ebx
  80133a:	6a 00                	push   $0x0
  80133c:	e8 a2 0b 00 00       	call   801ee3 <ipc_recv>
}
  801341:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801348:	83 ec 0c             	sub    $0xc,%esp
  80134b:	6a 01                	push   $0x1
  80134d:	e8 4c 0c 00 00       	call   801f9e <ipc_find_env>
  801352:	a3 00 40 80 00       	mov    %eax,0x804000
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	eb c5                	jmp    801321 <fsipc+0x12>

0080135c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8b 40 0c             	mov    0xc(%eax),%eax
  801368:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80136d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801370:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801375:	ba 00 00 00 00       	mov    $0x0,%edx
  80137a:	b8 02 00 00 00       	mov    $0x2,%eax
  80137f:	e8 8b ff ff ff       	call   80130f <fsipc>
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <devfile_flush>:
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	8b 40 0c             	mov    0xc(%eax),%eax
  801392:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801397:	ba 00 00 00 00       	mov    $0x0,%edx
  80139c:	b8 06 00 00 00       	mov    $0x6,%eax
  8013a1:	e8 69 ff ff ff       	call   80130f <fsipc>
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <devfile_stat>:
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	53                   	push   %ebx
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8013c7:	e8 43 ff ff ff       	call   80130f <fsipc>
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 2c                	js     8013fc <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	68 00 50 80 00       	push   $0x805000
  8013d8:	53                   	push   %ebx
  8013d9:	e8 96 f3 ff ff       	call   800774 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013de:	a1 80 50 80 00       	mov    0x805080,%eax
  8013e3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013e9:	a1 84 50 80 00       	mov    0x805084,%eax
  8013ee:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8013f4:	83 c4 10             	add    $0x10,%esp
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <devfile_write>:
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 0c             	sub    $0xc,%esp
  801407:	8b 45 10             	mov    0x10(%ebp),%eax
  80140a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80140f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801414:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801417:	8b 55 08             	mov    0x8(%ebp),%edx
  80141a:	8b 52 0c             	mov    0xc(%edx),%edx
  80141d:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801423:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801428:	50                   	push   %eax
  801429:	ff 75 0c             	pushl  0xc(%ebp)
  80142c:	68 08 50 80 00       	push   $0x805008
  801431:	e8 cc f4 ff ff       	call   800902 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801436:	ba 00 00 00 00       	mov    $0x0,%edx
  80143b:	b8 04 00 00 00       	mov    $0x4,%eax
  801440:	e8 ca fe ff ff       	call   80130f <fsipc>
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <devfile_read>:
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	56                   	push   %esi
  80144b:	53                   	push   %ebx
  80144c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	8b 40 0c             	mov    0xc(%eax),%eax
  801455:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80145a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801460:	ba 00 00 00 00       	mov    $0x0,%edx
  801465:	b8 03 00 00 00       	mov    $0x3,%eax
  80146a:	e8 a0 fe ff ff       	call   80130f <fsipc>
  80146f:	89 c3                	mov    %eax,%ebx
  801471:	85 c0                	test   %eax,%eax
  801473:	78 1f                	js     801494 <devfile_read+0x4d>
	assert(r <= n);
  801475:	39 f0                	cmp    %esi,%eax
  801477:	77 24                	ja     80149d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801479:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80147e:	7f 33                	jg     8014b3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	50                   	push   %eax
  801484:	68 00 50 80 00       	push   $0x805000
  801489:	ff 75 0c             	pushl  0xc(%ebp)
  80148c:	e8 71 f4 ff ff       	call   800902 <memmove>
	return r;
  801491:	83 c4 10             	add    $0x10,%esp
}
  801494:	89 d8                	mov    %ebx,%eax
  801496:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801499:	5b                   	pop    %ebx
  80149a:	5e                   	pop    %esi
  80149b:	5d                   	pop    %ebp
  80149c:	c3                   	ret    
	assert(r <= n);
  80149d:	68 3c 26 80 00       	push   $0x80263c
  8014a2:	68 43 26 80 00       	push   $0x802643
  8014a7:	6a 7b                	push   $0x7b
  8014a9:	68 58 26 80 00       	push   $0x802658
  8014ae:	e8 ea 09 00 00       	call   801e9d <_panic>
	assert(r <= PGSIZE);
  8014b3:	68 63 26 80 00       	push   $0x802663
  8014b8:	68 43 26 80 00       	push   $0x802643
  8014bd:	6a 7c                	push   $0x7c
  8014bf:	68 58 26 80 00       	push   $0x802658
  8014c4:	e8 d4 09 00 00       	call   801e9d <_panic>

008014c9 <open>:
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	56                   	push   %esi
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 1c             	sub    $0x1c,%esp
  8014d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014d4:	56                   	push   %esi
  8014d5:	e8 63 f2 ff ff       	call   80073d <strlen>
  8014da:	83 c4 10             	add    $0x10,%esp
  8014dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014e2:	7f 6c                	jg     801550 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014e4:	83 ec 0c             	sub    $0xc,%esp
  8014e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ea:	50                   	push   %eax
  8014eb:	e8 b4 f8 ff ff       	call   800da4 <fd_alloc>
  8014f0:	89 c3                	mov    %eax,%ebx
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 3c                	js     801535 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	56                   	push   %esi
  8014fd:	68 00 50 80 00       	push   $0x805000
  801502:	e8 6d f2 ff ff       	call   800774 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80150f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801512:	b8 01 00 00 00       	mov    $0x1,%eax
  801517:	e8 f3 fd ff ff       	call   80130f <fsipc>
  80151c:	89 c3                	mov    %eax,%ebx
  80151e:	83 c4 10             	add    $0x10,%esp
  801521:	85 c0                	test   %eax,%eax
  801523:	78 19                	js     80153e <open+0x75>
	return fd2num(fd);
  801525:	83 ec 0c             	sub    $0xc,%esp
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	e8 4d f8 ff ff       	call   800d7d <fd2num>
  801530:	89 c3                	mov    %eax,%ebx
  801532:	83 c4 10             	add    $0x10,%esp
}
  801535:	89 d8                	mov    %ebx,%eax
  801537:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153a:	5b                   	pop    %ebx
  80153b:	5e                   	pop    %esi
  80153c:	5d                   	pop    %ebp
  80153d:	c3                   	ret    
		fd_close(fd, 0);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	6a 00                	push   $0x0
  801543:	ff 75 f4             	pushl  -0xc(%ebp)
  801546:	e8 54 f9 ff ff       	call   800e9f <fd_close>
		return r;
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	eb e5                	jmp    801535 <open+0x6c>
		return -E_BAD_PATH;
  801550:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801555:	eb de                	jmp    801535 <open+0x6c>

00801557 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80155d:	ba 00 00 00 00       	mov    $0x0,%edx
  801562:	b8 08 00 00 00       	mov    $0x8,%eax
  801567:	e8 a3 fd ff ff       	call   80130f <fsipc>
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801574:	68 6f 26 80 00       	push   $0x80266f
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	e8 f3 f1 ff ff       	call   800774 <strcpy>
	return 0;
}
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <devsock_close>:
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	53                   	push   %ebx
  80158c:	83 ec 10             	sub    $0x10,%esp
  80158f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801592:	53                   	push   %ebx
  801593:	e8 3f 0a 00 00       	call   801fd7 <pageref>
  801598:	83 c4 10             	add    $0x10,%esp
		return 0;
  80159b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8015a0:	83 f8 01             	cmp    $0x1,%eax
  8015a3:	74 07                	je     8015ac <devsock_close+0x24>
}
  8015a5:	89 d0                	mov    %edx,%eax
  8015a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	ff 73 0c             	pushl  0xc(%ebx)
  8015b2:	e8 b7 02 00 00       	call   80186e <nsipc_close>
  8015b7:	89 c2                	mov    %eax,%edx
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	eb e7                	jmp    8015a5 <devsock_close+0x1d>

008015be <devsock_write>:
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	ff 75 10             	pushl  0x10(%ebp)
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	ff 70 0c             	pushl  0xc(%eax)
  8015d2:	e8 74 03 00 00       	call   80194b <nsipc_send>
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <devsock_read>:
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8015df:	6a 00                	push   $0x0
  8015e1:	ff 75 10             	pushl  0x10(%ebp)
  8015e4:	ff 75 0c             	pushl  0xc(%ebp)
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	ff 70 0c             	pushl  0xc(%eax)
  8015ed:	e8 ed 02 00 00       	call   8018df <nsipc_recv>
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <fd2sockid>:
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8015fa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	e8 ef f7 ff ff       	call   800df3 <fd_lookup>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	85 c0                	test   %eax,%eax
  801609:	78 10                	js     80161b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801614:	39 08                	cmp    %ecx,(%eax)
  801616:	75 05                	jne    80161d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801618:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    
		return -E_NOT_SUPP;
  80161d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801622:	eb f7                	jmp    80161b <fd2sockid+0x27>

00801624 <alloc_sockfd>:
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	56                   	push   %esi
  801628:	53                   	push   %ebx
  801629:	83 ec 1c             	sub    $0x1c,%esp
  80162c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80162e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801631:	50                   	push   %eax
  801632:	e8 6d f7 ff ff       	call   800da4 <fd_alloc>
  801637:	89 c3                	mov    %eax,%ebx
  801639:	83 c4 10             	add    $0x10,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 43                	js     801683 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	68 07 04 00 00       	push   $0x407
  801648:	ff 75 f4             	pushl  -0xc(%ebp)
  80164b:	6a 00                	push   $0x0
  80164d:	e8 1b f5 ff ff       	call   800b6d <sys_page_alloc>
  801652:	89 c3                	mov    %eax,%ebx
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	85 c0                	test   %eax,%eax
  801659:	78 28                	js     801683 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80165b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801664:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801670:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801673:	83 ec 0c             	sub    $0xc,%esp
  801676:	50                   	push   %eax
  801677:	e8 01 f7 ff ff       	call   800d7d <fd2num>
  80167c:	89 c3                	mov    %eax,%ebx
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	eb 0c                	jmp    80168f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801683:	83 ec 0c             	sub    $0xc,%esp
  801686:	56                   	push   %esi
  801687:	e8 e2 01 00 00       	call   80186e <nsipc_close>
		return r;
  80168c:	83 c4 10             	add    $0x10,%esp
}
  80168f:	89 d8                	mov    %ebx,%eax
  801691:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801694:	5b                   	pop    %ebx
  801695:	5e                   	pop    %esi
  801696:	5d                   	pop    %ebp
  801697:	c3                   	ret    

00801698 <accept>:
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	e8 4e ff ff ff       	call   8015f4 <fd2sockid>
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	78 1b                	js     8016c5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	ff 75 10             	pushl  0x10(%ebp)
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	50                   	push   %eax
  8016b4:	e8 0e 01 00 00       	call   8017c7 <nsipc_accept>
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	78 05                	js     8016c5 <accept+0x2d>
	return alloc_sockfd(r);
  8016c0:	e8 5f ff ff ff       	call   801624 <alloc_sockfd>
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <bind>:
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	e8 1f ff ff ff       	call   8015f4 <fd2sockid>
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 12                	js     8016eb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	ff 75 10             	pushl  0x10(%ebp)
  8016df:	ff 75 0c             	pushl  0xc(%ebp)
  8016e2:	50                   	push   %eax
  8016e3:	e8 2f 01 00 00       	call   801817 <nsipc_bind>
  8016e8:	83 c4 10             	add    $0x10,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <shutdown>:
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	e8 f9 fe ff ff       	call   8015f4 <fd2sockid>
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 0f                	js     80170e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	50                   	push   %eax
  801706:	e8 41 01 00 00       	call   80184c <nsipc_shutdown>
  80170b:	83 c4 10             	add    $0x10,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <connect>:
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	e8 d6 fe ff ff       	call   8015f4 <fd2sockid>
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 12                	js     801734 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	ff 75 10             	pushl  0x10(%ebp)
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	50                   	push   %eax
  80172c:	e8 57 01 00 00       	call   801888 <nsipc_connect>
  801731:	83 c4 10             	add    $0x10,%esp
}
  801734:	c9                   	leave  
  801735:	c3                   	ret    

00801736 <listen>:
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	e8 b0 fe ff ff       	call   8015f4 <fd2sockid>
  801744:	85 c0                	test   %eax,%eax
  801746:	78 0f                	js     801757 <listen+0x21>
	return nsipc_listen(r, backlog);
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	50                   	push   %eax
  80174f:	e8 69 01 00 00       	call   8018bd <nsipc_listen>
  801754:	83 c4 10             	add    $0x10,%esp
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <socket>:

int
socket(int domain, int type, int protocol)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80175f:	ff 75 10             	pushl  0x10(%ebp)
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	e8 3c 02 00 00       	call   8019a9 <nsipc_socket>
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	85 c0                	test   %eax,%eax
  801772:	78 05                	js     801779 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801774:	e8 ab fe ff ff       	call   801624 <alloc_sockfd>
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	53                   	push   %ebx
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801784:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80178b:	74 26                	je     8017b3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80178d:	6a 07                	push   $0x7
  80178f:	68 00 60 80 00       	push   $0x806000
  801794:	53                   	push   %ebx
  801795:	ff 35 04 40 80 00    	pushl  0x804004
  80179b:	e8 aa 07 00 00       	call   801f4a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8017a0:	83 c4 0c             	add    $0xc,%esp
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	e8 35 07 00 00       	call   801ee3 <ipc_recv>
}
  8017ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8017b3:	83 ec 0c             	sub    $0xc,%esp
  8017b6:	6a 02                	push   $0x2
  8017b8:	e8 e1 07 00 00       	call   801f9e <ipc_find_env>
  8017bd:	a3 04 40 80 00       	mov    %eax,0x804004
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	eb c6                	jmp    80178d <nsipc+0x12>

008017c7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	56                   	push   %esi
  8017cb:	53                   	push   %ebx
  8017cc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8017d7:	8b 06                	mov    (%esi),%eax
  8017d9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8017de:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e3:	e8 93 ff ff ff       	call   80177b <nsipc>
  8017e8:	89 c3                	mov    %eax,%ebx
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 20                	js     80180e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	ff 35 10 60 80 00    	pushl  0x806010
  8017f7:	68 00 60 80 00       	push   $0x806000
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	e8 fe f0 ff ff       	call   800902 <memmove>
		*addrlen = ret->ret_addrlen;
  801804:	a1 10 60 80 00       	mov    0x806010,%eax
  801809:	89 06                	mov    %eax,(%esi)
  80180b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80180e:	89 d8                	mov    %ebx,%eax
  801810:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	53                   	push   %ebx
  80181b:	83 ec 08             	sub    $0x8,%esp
  80181e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801829:	53                   	push   %ebx
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	68 04 60 80 00       	push   $0x806004
  801832:	e8 cb f0 ff ff       	call   800902 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801837:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80183d:	b8 02 00 00 00       	mov    $0x2,%eax
  801842:	e8 34 ff ff ff       	call   80177b <nsipc>
}
  801847:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80185a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801862:	b8 03 00 00 00       	mov    $0x3,%eax
  801867:	e8 0f ff ff ff       	call   80177b <nsipc>
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <nsipc_close>:

int
nsipc_close(int s)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801874:	8b 45 08             	mov    0x8(%ebp),%eax
  801877:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80187c:	b8 04 00 00 00       	mov    $0x4,%eax
  801881:	e8 f5 fe ff ff       	call   80177b <nsipc>
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	53                   	push   %ebx
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80189a:	53                   	push   %ebx
  80189b:	ff 75 0c             	pushl  0xc(%ebp)
  80189e:	68 04 60 80 00       	push   $0x806004
  8018a3:	e8 5a f0 ff ff       	call   800902 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8018a8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8018ae:	b8 05 00 00 00       	mov    $0x5,%eax
  8018b3:	e8 c3 fe ff ff       	call   80177b <nsipc>
}
  8018b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8018cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ce:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8018d3:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d8:	e8 9e fe ff ff       	call   80177b <nsipc>
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	56                   	push   %esi
  8018e3:	53                   	push   %ebx
  8018e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8018ef:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8018f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f8:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8018fd:	b8 07 00 00 00       	mov    $0x7,%eax
  801902:	e8 74 fe ff ff       	call   80177b <nsipc>
  801907:	89 c3                	mov    %eax,%ebx
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 1f                	js     80192c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80190d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801912:	7f 21                	jg     801935 <nsipc_recv+0x56>
  801914:	39 c6                	cmp    %eax,%esi
  801916:	7c 1d                	jl     801935 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	50                   	push   %eax
  80191c:	68 00 60 80 00       	push   $0x806000
  801921:	ff 75 0c             	pushl  0xc(%ebp)
  801924:	e8 d9 ef ff ff       	call   800902 <memmove>
  801929:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801931:	5b                   	pop    %ebx
  801932:	5e                   	pop    %esi
  801933:	5d                   	pop    %ebp
  801934:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801935:	68 7b 26 80 00       	push   $0x80267b
  80193a:	68 43 26 80 00       	push   $0x802643
  80193f:	6a 62                	push   $0x62
  801941:	68 90 26 80 00       	push   $0x802690
  801946:	e8 52 05 00 00       	call   801e9d <_panic>

0080194b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80195d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801963:	7f 2e                	jg     801993 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	53                   	push   %ebx
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	68 0c 60 80 00       	push   $0x80600c
  801971:	e8 8c ef ff ff       	call   800902 <memmove>
	nsipcbuf.send.req_size = size;
  801976:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80197c:	8b 45 14             	mov    0x14(%ebp),%eax
  80197f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801984:	b8 08 00 00 00       	mov    $0x8,%eax
  801989:	e8 ed fd ff ff       	call   80177b <nsipc>
}
  80198e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801991:	c9                   	leave  
  801992:	c3                   	ret    
	assert(size < 1600);
  801993:	68 9c 26 80 00       	push   $0x80269c
  801998:	68 43 26 80 00       	push   $0x802643
  80199d:	6a 6d                	push   $0x6d
  80199f:	68 90 26 80 00       	push   $0x802690
  8019a4:	e8 f4 04 00 00       	call   801e9d <_panic>

008019a9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8019c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8019cc:	e8 aa fd ff ff       	call   80177b <nsipc>
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019db:	83 ec 0c             	sub    $0xc,%esp
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	e8 a7 f3 ff ff       	call   800d8d <fd2data>
  8019e6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019e8:	83 c4 08             	add    $0x8,%esp
  8019eb:	68 a8 26 80 00       	push   $0x8026a8
  8019f0:	53                   	push   %ebx
  8019f1:	e8 7e ed ff ff       	call   800774 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8019f6:	8b 46 04             	mov    0x4(%esi),%eax
  8019f9:	2b 06                	sub    (%esi),%eax
  8019fb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a01:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a08:	00 00 00 
	stat->st_dev = &devpipe;
  801a0b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a12:	30 80 00 
	return 0;
}
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5e                   	pop    %esi
  801a1f:	5d                   	pop    %ebp
  801a20:	c3                   	ret    

00801a21 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	53                   	push   %ebx
  801a25:	83 ec 0c             	sub    $0xc,%esp
  801a28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a2b:	53                   	push   %ebx
  801a2c:	6a 00                	push   $0x0
  801a2e:	e8 bf f1 ff ff       	call   800bf2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a33:	89 1c 24             	mov    %ebx,(%esp)
  801a36:	e8 52 f3 ff ff       	call   800d8d <fd2data>
  801a3b:	83 c4 08             	add    $0x8,%esp
  801a3e:	50                   	push   %eax
  801a3f:	6a 00                	push   $0x0
  801a41:	e8 ac f1 ff ff       	call   800bf2 <sys_page_unmap>
}
  801a46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <_pipeisclosed>:
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	57                   	push   %edi
  801a4f:	56                   	push   %esi
  801a50:	53                   	push   %ebx
  801a51:	83 ec 1c             	sub    $0x1c,%esp
  801a54:	89 c7                	mov    %eax,%edi
  801a56:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a58:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801a5d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a60:	83 ec 0c             	sub    $0xc,%esp
  801a63:	57                   	push   %edi
  801a64:	e8 6e 05 00 00       	call   801fd7 <pageref>
  801a69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a6c:	89 34 24             	mov    %esi,(%esp)
  801a6f:	e8 63 05 00 00       	call   801fd7 <pageref>
		nn = thisenv->env_runs;
  801a74:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801a7a:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a7d:	83 c4 10             	add    $0x10,%esp
  801a80:	39 cb                	cmp    %ecx,%ebx
  801a82:	74 1b                	je     801a9f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a84:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a87:	75 cf                	jne    801a58 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a89:	8b 42 58             	mov    0x58(%edx),%eax
  801a8c:	6a 01                	push   $0x1
  801a8e:	50                   	push   %eax
  801a8f:	53                   	push   %ebx
  801a90:	68 af 26 80 00       	push   $0x8026af
  801a95:	e8 bb e6 ff ff       	call   800155 <cprintf>
  801a9a:	83 c4 10             	add    $0x10,%esp
  801a9d:	eb b9                	jmp    801a58 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a9f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801aa2:	0f 94 c0             	sete   %al
  801aa5:	0f b6 c0             	movzbl %al,%eax
}
  801aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5f                   	pop    %edi
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <devpipe_write>:
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	57                   	push   %edi
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 28             	sub    $0x28,%esp
  801ab9:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801abc:	56                   	push   %esi
  801abd:	e8 cb f2 ff ff       	call   800d8d <fd2data>
  801ac2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ac4:	83 c4 10             	add    $0x10,%esp
  801ac7:	bf 00 00 00 00       	mov    $0x0,%edi
  801acc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801acf:	74 4f                	je     801b20 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ad1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ad4:	8b 0b                	mov    (%ebx),%ecx
  801ad6:	8d 51 20             	lea    0x20(%ecx),%edx
  801ad9:	39 d0                	cmp    %edx,%eax
  801adb:	72 14                	jb     801af1 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801add:	89 da                	mov    %ebx,%edx
  801adf:	89 f0                	mov    %esi,%eax
  801ae1:	e8 65 ff ff ff       	call   801a4b <_pipeisclosed>
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	75 3a                	jne    801b24 <devpipe_write+0x74>
			sys_yield();
  801aea:	e8 5f f0 ff ff       	call   800b4e <sys_yield>
  801aef:	eb e0                	jmp    801ad1 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801af1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801af4:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801af8:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801afb:	89 c2                	mov    %eax,%edx
  801afd:	c1 fa 1f             	sar    $0x1f,%edx
  801b00:	89 d1                	mov    %edx,%ecx
  801b02:	c1 e9 1b             	shr    $0x1b,%ecx
  801b05:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b08:	83 e2 1f             	and    $0x1f,%edx
  801b0b:	29 ca                	sub    %ecx,%edx
  801b0d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b11:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b15:	83 c0 01             	add    $0x1,%eax
  801b18:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b1b:	83 c7 01             	add    $0x1,%edi
  801b1e:	eb ac                	jmp    801acc <devpipe_write+0x1c>
	return i;
  801b20:	89 f8                	mov    %edi,%eax
  801b22:	eb 05                	jmp    801b29 <devpipe_write+0x79>
				return 0;
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5e                   	pop    %esi
  801b2e:	5f                   	pop    %edi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <devpipe_read>:
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	57                   	push   %edi
  801b35:	56                   	push   %esi
  801b36:	53                   	push   %ebx
  801b37:	83 ec 18             	sub    $0x18,%esp
  801b3a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b3d:	57                   	push   %edi
  801b3e:	e8 4a f2 ff ff       	call   800d8d <fd2data>
  801b43:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b45:	83 c4 10             	add    $0x10,%esp
  801b48:	be 00 00 00 00       	mov    $0x0,%esi
  801b4d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b50:	74 47                	je     801b99 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b52:	8b 03                	mov    (%ebx),%eax
  801b54:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b57:	75 22                	jne    801b7b <devpipe_read+0x4a>
			if (i > 0)
  801b59:	85 f6                	test   %esi,%esi
  801b5b:	75 14                	jne    801b71 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b5d:	89 da                	mov    %ebx,%edx
  801b5f:	89 f8                	mov    %edi,%eax
  801b61:	e8 e5 fe ff ff       	call   801a4b <_pipeisclosed>
  801b66:	85 c0                	test   %eax,%eax
  801b68:	75 33                	jne    801b9d <devpipe_read+0x6c>
			sys_yield();
  801b6a:	e8 df ef ff ff       	call   800b4e <sys_yield>
  801b6f:	eb e1                	jmp    801b52 <devpipe_read+0x21>
				return i;
  801b71:	89 f0                	mov    %esi,%eax
}
  801b73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5e                   	pop    %esi
  801b78:	5f                   	pop    %edi
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b7b:	99                   	cltd   
  801b7c:	c1 ea 1b             	shr    $0x1b,%edx
  801b7f:	01 d0                	add    %edx,%eax
  801b81:	83 e0 1f             	and    $0x1f,%eax
  801b84:	29 d0                	sub    %edx,%eax
  801b86:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b8e:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801b91:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801b94:	83 c6 01             	add    $0x1,%esi
  801b97:	eb b4                	jmp    801b4d <devpipe_read+0x1c>
	return i;
  801b99:	89 f0                	mov    %esi,%eax
  801b9b:	eb d6                	jmp    801b73 <devpipe_read+0x42>
				return 0;
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba2:	eb cf                	jmp    801b73 <devpipe_read+0x42>

00801ba4 <pipe>:
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	56                   	push   %esi
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801baf:	50                   	push   %eax
  801bb0:	e8 ef f1 ff ff       	call   800da4 <fd_alloc>
  801bb5:	89 c3                	mov    %eax,%ebx
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	78 5b                	js     801c19 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	68 07 04 00 00       	push   $0x407
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	6a 00                	push   $0x0
  801bcb:	e8 9d ef ff ff       	call   800b6d <sys_page_alloc>
  801bd0:	89 c3                	mov    %eax,%ebx
  801bd2:	83 c4 10             	add    $0x10,%esp
  801bd5:	85 c0                	test   %eax,%eax
  801bd7:	78 40                	js     801c19 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bdf:	50                   	push   %eax
  801be0:	e8 bf f1 ff ff       	call   800da4 <fd_alloc>
  801be5:	89 c3                	mov    %eax,%ebx
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 1b                	js     801c09 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	68 07 04 00 00       	push   $0x407
  801bf6:	ff 75 f0             	pushl  -0x10(%ebp)
  801bf9:	6a 00                	push   $0x0
  801bfb:	e8 6d ef ff ff       	call   800b6d <sys_page_alloc>
  801c00:	89 c3                	mov    %eax,%ebx
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	85 c0                	test   %eax,%eax
  801c07:	79 19                	jns    801c22 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c09:	83 ec 08             	sub    $0x8,%esp
  801c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0f:	6a 00                	push   $0x0
  801c11:	e8 dc ef ff ff       	call   800bf2 <sys_page_unmap>
  801c16:	83 c4 10             	add    $0x10,%esp
}
  801c19:	89 d8                	mov    %ebx,%eax
  801c1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1e:	5b                   	pop    %ebx
  801c1f:	5e                   	pop    %esi
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    
	va = fd2data(fd0);
  801c22:	83 ec 0c             	sub    $0xc,%esp
  801c25:	ff 75 f4             	pushl  -0xc(%ebp)
  801c28:	e8 60 f1 ff ff       	call   800d8d <fd2data>
  801c2d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c2f:	83 c4 0c             	add    $0xc,%esp
  801c32:	68 07 04 00 00       	push   $0x407
  801c37:	50                   	push   %eax
  801c38:	6a 00                	push   $0x0
  801c3a:	e8 2e ef ff ff       	call   800b6d <sys_page_alloc>
  801c3f:	89 c3                	mov    %eax,%ebx
  801c41:	83 c4 10             	add    $0x10,%esp
  801c44:	85 c0                	test   %eax,%eax
  801c46:	0f 88 8c 00 00 00    	js     801cd8 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  801c52:	e8 36 f1 ff ff       	call   800d8d <fd2data>
  801c57:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c5e:	50                   	push   %eax
  801c5f:	6a 00                	push   $0x0
  801c61:	56                   	push   %esi
  801c62:	6a 00                	push   $0x0
  801c64:	e8 47 ef ff ff       	call   800bb0 <sys_page_map>
  801c69:	89 c3                	mov    %eax,%ebx
  801c6b:	83 c4 20             	add    $0x20,%esp
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	78 58                	js     801cca <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c75:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c7b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c90:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c95:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801c9c:	83 ec 0c             	sub    $0xc,%esp
  801c9f:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca2:	e8 d6 f0 ff ff       	call   800d7d <fd2num>
  801ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801caa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cac:	83 c4 04             	add    $0x4,%esp
  801caf:	ff 75 f0             	pushl  -0x10(%ebp)
  801cb2:	e8 c6 f0 ff ff       	call   800d7d <fd2num>
  801cb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cba:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801cbd:	83 c4 10             	add    $0x10,%esp
  801cc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc5:	e9 4f ff ff ff       	jmp    801c19 <pipe+0x75>
	sys_page_unmap(0, va);
  801cca:	83 ec 08             	sub    $0x8,%esp
  801ccd:	56                   	push   %esi
  801cce:	6a 00                	push   $0x0
  801cd0:	e8 1d ef ff ff       	call   800bf2 <sys_page_unmap>
  801cd5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801cd8:	83 ec 08             	sub    $0x8,%esp
  801cdb:	ff 75 f0             	pushl  -0x10(%ebp)
  801cde:	6a 00                	push   $0x0
  801ce0:	e8 0d ef ff ff       	call   800bf2 <sys_page_unmap>
  801ce5:	83 c4 10             	add    $0x10,%esp
  801ce8:	e9 1c ff ff ff       	jmp    801c09 <pipe+0x65>

00801ced <pipeisclosed>:
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cf3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf6:	50                   	push   %eax
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	e8 f4 f0 ff ff       	call   800df3 <fd_lookup>
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 18                	js     801d1e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d06:	83 ec 0c             	sub    $0xc,%esp
  801d09:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0c:	e8 7c f0 ff ff       	call   800d8d <fd2data>
	return _pipeisclosed(fd, p);
  801d11:	89 c2                	mov    %eax,%edx
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	e8 30 fd ff ff       	call   801a4b <_pipeisclosed>
  801d1b:	83 c4 10             	add    $0x10,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    

00801d2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d30:	68 c7 26 80 00       	push   $0x8026c7
  801d35:	ff 75 0c             	pushl  0xc(%ebp)
  801d38:	e8 37 ea ff ff       	call   800774 <strcpy>
	return 0;
}
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <devcons_write>:
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	57                   	push   %edi
  801d48:	56                   	push   %esi
  801d49:	53                   	push   %ebx
  801d4a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d50:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d55:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d5b:	eb 2f                	jmp    801d8c <devcons_write+0x48>
		m = n - tot;
  801d5d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d60:	29 f3                	sub    %esi,%ebx
  801d62:	83 fb 7f             	cmp    $0x7f,%ebx
  801d65:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d6a:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	53                   	push   %ebx
  801d71:	89 f0                	mov    %esi,%eax
  801d73:	03 45 0c             	add    0xc(%ebp),%eax
  801d76:	50                   	push   %eax
  801d77:	57                   	push   %edi
  801d78:	e8 85 eb ff ff       	call   800902 <memmove>
		sys_cputs(buf, m);
  801d7d:	83 c4 08             	add    $0x8,%esp
  801d80:	53                   	push   %ebx
  801d81:	57                   	push   %edi
  801d82:	e8 2a ed ff ff       	call   800ab1 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d87:	01 de                	add    %ebx,%esi
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d8f:	72 cc                	jb     801d5d <devcons_write+0x19>
}
  801d91:	89 f0                	mov    %esi,%eax
  801d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d96:	5b                   	pop    %ebx
  801d97:	5e                   	pop    %esi
  801d98:	5f                   	pop    %edi
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <devcons_read>:
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 08             	sub    $0x8,%esp
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801daa:	75 07                	jne    801db3 <devcons_read+0x18>
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    
		sys_yield();
  801dae:	e8 9b ed ff ff       	call   800b4e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801db3:	e8 17 ed ff ff       	call   800acf <sys_cgetc>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	74 f2                	je     801dae <devcons_read+0x13>
	if (c < 0)
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	78 ec                	js     801dac <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801dc0:	83 f8 04             	cmp    $0x4,%eax
  801dc3:	74 0c                	je     801dd1 <devcons_read+0x36>
	*(char*)vbuf = c;
  801dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc8:	88 02                	mov    %al,(%edx)
	return 1;
  801dca:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcf:	eb db                	jmp    801dac <devcons_read+0x11>
		return 0;
  801dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd6:	eb d4                	jmp    801dac <devcons_read+0x11>

00801dd8 <cputchar>:
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801de4:	6a 01                	push   $0x1
  801de6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801de9:	50                   	push   %eax
  801dea:	e8 c2 ec ff ff       	call   800ab1 <sys_cputs>
}
  801def:	83 c4 10             	add    $0x10,%esp
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <getchar>:
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801dfa:	6a 01                	push   $0x1
  801dfc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dff:	50                   	push   %eax
  801e00:	6a 00                	push   $0x0
  801e02:	e8 5d f2 ff ff       	call   801064 <read>
	if (r < 0)
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 08                	js     801e16 <getchar+0x22>
	if (r < 1)
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	7e 06                	jle    801e18 <getchar+0x24>
	return c;
  801e12:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    
		return -E_EOF;
  801e18:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e1d:	eb f7                	jmp    801e16 <getchar+0x22>

00801e1f <iscons>:
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
  801e22:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e28:	50                   	push   %eax
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	e8 c2 ef ff ff       	call   800df3 <fd_lookup>
  801e31:	83 c4 10             	add    $0x10,%esp
  801e34:	85 c0                	test   %eax,%eax
  801e36:	78 11                	js     801e49 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e41:	39 10                	cmp    %edx,(%eax)
  801e43:	0f 94 c0             	sete   %al
  801e46:	0f b6 c0             	movzbl %al,%eax
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <opencons>:
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e54:	50                   	push   %eax
  801e55:	e8 4a ef ff ff       	call   800da4 <fd_alloc>
  801e5a:	83 c4 10             	add    $0x10,%esp
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	78 3a                	js     801e9b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 07 04 00 00       	push   $0x407
  801e69:	ff 75 f4             	pushl  -0xc(%ebp)
  801e6c:	6a 00                	push   $0x0
  801e6e:	e8 fa ec ff ff       	call   800b6d <sys_page_alloc>
  801e73:	83 c4 10             	add    $0x10,%esp
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 21                	js     801e9b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e83:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	50                   	push   %eax
  801e93:	e8 e5 ee ff ff       	call   800d7d <fd2num>
  801e98:	83 c4 10             	add    $0x10,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	56                   	push   %esi
  801ea1:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801ea2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801ea5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801eab:	e8 7f ec ff ff       	call   800b2f <sys_getenvid>
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	56                   	push   %esi
  801eba:	50                   	push   %eax
  801ebb:	68 d4 26 80 00       	push   $0x8026d4
  801ec0:	e8 90 e2 ff ff       	call   800155 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ec5:	83 c4 18             	add    $0x18,%esp
  801ec8:	53                   	push   %ebx
  801ec9:	ff 75 10             	pushl  0x10(%ebp)
  801ecc:	e8 33 e2 ff ff       	call   800104 <vcprintf>
	cprintf("\n");
  801ed1:	c7 04 24 6c 22 80 00 	movl   $0x80226c,(%esp)
  801ed8:	e8 78 e2 ff ff       	call   800155 <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801ee0:	cc                   	int3   
  801ee1:	eb fd                	jmp    801ee0 <_panic+0x43>

00801ee3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	56                   	push   %esi
  801ee7:	53                   	push   %ebx
  801ee8:	8b 75 08             	mov    0x8(%ebp),%esi
  801eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801ef1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801ef3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ef8:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801efb:	83 ec 0c             	sub    $0xc,%esp
  801efe:	50                   	push   %eax
  801eff:	e8 19 ee ff ff       	call   800d1d <sys_ipc_recv>
	if (from_env_store)
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	85 f6                	test   %esi,%esi
  801f09:	74 14                	je     801f1f <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 09                	js     801f1d <ipc_recv+0x3a>
  801f14:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801f1a:	8b 52 74             	mov    0x74(%edx),%edx
  801f1d:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f1f:	85 db                	test   %ebx,%ebx
  801f21:	74 14                	je     801f37 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f23:	ba 00 00 00 00       	mov    $0x0,%edx
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	78 09                	js     801f35 <ipc_recv+0x52>
  801f2c:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801f32:	8b 52 78             	mov    0x78(%edx),%edx
  801f35:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 08                	js     801f43 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f3b:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801f40:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5e                   	pop    %esi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    

00801f4a <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	57                   	push   %edi
  801f4e:	56                   	push   %esi
  801f4f:	53                   	push   %ebx
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f56:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f59:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f5c:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f5e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f63:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f66:	ff 75 14             	pushl  0x14(%ebp)
  801f69:	53                   	push   %ebx
  801f6a:	56                   	push   %esi
  801f6b:	57                   	push   %edi
  801f6c:	e8 89 ed ff ff       	call   800cfa <sys_ipc_try_send>
		if (ret == 0)
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	74 1e                	je     801f96 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f78:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f7b:	75 07                	jne    801f84 <ipc_send+0x3a>
			sys_yield();
  801f7d:	e8 cc eb ff ff       	call   800b4e <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f82:	eb e2                	jmp    801f66 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f84:	50                   	push   %eax
  801f85:	68 f8 26 80 00       	push   $0x8026f8
  801f8a:	6a 3d                	push   $0x3d
  801f8c:	68 0c 27 80 00       	push   $0x80270c
  801f91:	e8 07 ff ff ff       	call   801e9d <_panic>
	}
	// panic("ipc_send not implemented");
}
  801f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f99:	5b                   	pop    %ebx
  801f9a:	5e                   	pop    %esi
  801f9b:	5f                   	pop    %edi
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fa9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fac:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fb2:	8b 52 50             	mov    0x50(%edx),%edx
  801fb5:	39 ca                	cmp    %ecx,%edx
  801fb7:	74 11                	je     801fca <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fb9:	83 c0 01             	add    $0x1,%eax
  801fbc:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fc1:	75 e6                	jne    801fa9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	eb 0b                	jmp    801fd5 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fcd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fd2:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fd5:	5d                   	pop    %ebp
  801fd6:	c3                   	ret    

00801fd7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fdd:	89 d0                	mov    %edx,%eax
  801fdf:	c1 e8 16             	shr    $0x16,%eax
  801fe2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801fee:	f6 c1 01             	test   $0x1,%cl
  801ff1:	74 1d                	je     802010 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801ff3:	c1 ea 0c             	shr    $0xc,%edx
  801ff6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ffd:	f6 c2 01             	test   $0x1,%dl
  802000:	74 0e                	je     802010 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802002:	c1 ea 0c             	shr    $0xc,%edx
  802005:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80200c:	ef 
  80200d:	0f b7 c0             	movzwl %ax,%eax
}
  802010:	5d                   	pop    %ebp
  802011:	c3                   	ret    
  802012:	66 90                	xchg   %ax,%ax
  802014:	66 90                	xchg   %ax,%ax
  802016:	66 90                	xchg   %ax,%ax
  802018:	66 90                	xchg   %ax,%ax
  80201a:	66 90                	xchg   %ax,%ax
  80201c:	66 90                	xchg   %ax,%ax
  80201e:	66 90                	xchg   %ax,%ax

00802020 <__udivdi3>:
  802020:	55                   	push   %ebp
  802021:	57                   	push   %edi
  802022:	56                   	push   %esi
  802023:	53                   	push   %ebx
  802024:	83 ec 1c             	sub    $0x1c,%esp
  802027:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80202b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80202f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802033:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802037:	85 d2                	test   %edx,%edx
  802039:	75 35                	jne    802070 <__udivdi3+0x50>
  80203b:	39 f3                	cmp    %esi,%ebx
  80203d:	0f 87 bd 00 00 00    	ja     802100 <__udivdi3+0xe0>
  802043:	85 db                	test   %ebx,%ebx
  802045:	89 d9                	mov    %ebx,%ecx
  802047:	75 0b                	jne    802054 <__udivdi3+0x34>
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	31 d2                	xor    %edx,%edx
  802050:	f7 f3                	div    %ebx
  802052:	89 c1                	mov    %eax,%ecx
  802054:	31 d2                	xor    %edx,%edx
  802056:	89 f0                	mov    %esi,%eax
  802058:	f7 f1                	div    %ecx
  80205a:	89 c6                	mov    %eax,%esi
  80205c:	89 e8                	mov    %ebp,%eax
  80205e:	89 f7                	mov    %esi,%edi
  802060:	f7 f1                	div    %ecx
  802062:	89 fa                	mov    %edi,%edx
  802064:	83 c4 1c             	add    $0x1c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    
  80206c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802070:	39 f2                	cmp    %esi,%edx
  802072:	77 7c                	ja     8020f0 <__udivdi3+0xd0>
  802074:	0f bd fa             	bsr    %edx,%edi
  802077:	83 f7 1f             	xor    $0x1f,%edi
  80207a:	0f 84 98 00 00 00    	je     802118 <__udivdi3+0xf8>
  802080:	89 f9                	mov    %edi,%ecx
  802082:	b8 20 00 00 00       	mov    $0x20,%eax
  802087:	29 f8                	sub    %edi,%eax
  802089:	d3 e2                	shl    %cl,%edx
  80208b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80208f:	89 c1                	mov    %eax,%ecx
  802091:	89 da                	mov    %ebx,%edx
  802093:	d3 ea                	shr    %cl,%edx
  802095:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802099:	09 d1                	or     %edx,%ecx
  80209b:	89 f2                	mov    %esi,%edx
  80209d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020a1:	89 f9                	mov    %edi,%ecx
  8020a3:	d3 e3                	shl    %cl,%ebx
  8020a5:	89 c1                	mov    %eax,%ecx
  8020a7:	d3 ea                	shr    %cl,%edx
  8020a9:	89 f9                	mov    %edi,%ecx
  8020ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020af:	d3 e6                	shl    %cl,%esi
  8020b1:	89 eb                	mov    %ebp,%ebx
  8020b3:	89 c1                	mov    %eax,%ecx
  8020b5:	d3 eb                	shr    %cl,%ebx
  8020b7:	09 de                	or     %ebx,%esi
  8020b9:	89 f0                	mov    %esi,%eax
  8020bb:	f7 74 24 08          	divl   0x8(%esp)
  8020bf:	89 d6                	mov    %edx,%esi
  8020c1:	89 c3                	mov    %eax,%ebx
  8020c3:	f7 64 24 0c          	mull   0xc(%esp)
  8020c7:	39 d6                	cmp    %edx,%esi
  8020c9:	72 0c                	jb     8020d7 <__udivdi3+0xb7>
  8020cb:	89 f9                	mov    %edi,%ecx
  8020cd:	d3 e5                	shl    %cl,%ebp
  8020cf:	39 c5                	cmp    %eax,%ebp
  8020d1:	73 5d                	jae    802130 <__udivdi3+0x110>
  8020d3:	39 d6                	cmp    %edx,%esi
  8020d5:	75 59                	jne    802130 <__udivdi3+0x110>
  8020d7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020da:	31 ff                	xor    %edi,%edi
  8020dc:	89 fa                	mov    %edi,%edx
  8020de:	83 c4 1c             	add    $0x1c,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    
  8020e6:	8d 76 00             	lea    0x0(%esi),%esi
  8020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8020f0:	31 ff                	xor    %edi,%edi
  8020f2:	31 c0                	xor    %eax,%eax
  8020f4:	89 fa                	mov    %edi,%edx
  8020f6:	83 c4 1c             	add    $0x1c,%esp
  8020f9:	5b                   	pop    %ebx
  8020fa:	5e                   	pop    %esi
  8020fb:	5f                   	pop    %edi
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    
  8020fe:	66 90                	xchg   %ax,%ax
  802100:	31 ff                	xor    %edi,%edi
  802102:	89 e8                	mov    %ebp,%eax
  802104:	89 f2                	mov    %esi,%edx
  802106:	f7 f3                	div    %ebx
  802108:	89 fa                	mov    %edi,%edx
  80210a:	83 c4 1c             	add    $0x1c,%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5f                   	pop    %edi
  802110:	5d                   	pop    %ebp
  802111:	c3                   	ret    
  802112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802118:	39 f2                	cmp    %esi,%edx
  80211a:	72 06                	jb     802122 <__udivdi3+0x102>
  80211c:	31 c0                	xor    %eax,%eax
  80211e:	39 eb                	cmp    %ebp,%ebx
  802120:	77 d2                	ja     8020f4 <__udivdi3+0xd4>
  802122:	b8 01 00 00 00       	mov    $0x1,%eax
  802127:	eb cb                	jmp    8020f4 <__udivdi3+0xd4>
  802129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802130:	89 d8                	mov    %ebx,%eax
  802132:	31 ff                	xor    %edi,%edi
  802134:	eb be                	jmp    8020f4 <__udivdi3+0xd4>
  802136:	66 90                	xchg   %ax,%ax
  802138:	66 90                	xchg   %ax,%ax
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	66 90                	xchg   %ax,%ax
  80213e:	66 90                	xchg   %ax,%ax

00802140 <__umoddi3>:
  802140:	55                   	push   %ebp
  802141:	57                   	push   %edi
  802142:	56                   	push   %esi
  802143:	53                   	push   %ebx
  802144:	83 ec 1c             	sub    $0x1c,%esp
  802147:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80214b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80214f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802153:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802157:	85 ed                	test   %ebp,%ebp
  802159:	89 f0                	mov    %esi,%eax
  80215b:	89 da                	mov    %ebx,%edx
  80215d:	75 19                	jne    802178 <__umoddi3+0x38>
  80215f:	39 df                	cmp    %ebx,%edi
  802161:	0f 86 b1 00 00 00    	jbe    802218 <__umoddi3+0xd8>
  802167:	f7 f7                	div    %edi
  802169:	89 d0                	mov    %edx,%eax
  80216b:	31 d2                	xor    %edx,%edx
  80216d:	83 c4 1c             	add    $0x1c,%esp
  802170:	5b                   	pop    %ebx
  802171:	5e                   	pop    %esi
  802172:	5f                   	pop    %edi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    
  802175:	8d 76 00             	lea    0x0(%esi),%esi
  802178:	39 dd                	cmp    %ebx,%ebp
  80217a:	77 f1                	ja     80216d <__umoddi3+0x2d>
  80217c:	0f bd cd             	bsr    %ebp,%ecx
  80217f:	83 f1 1f             	xor    $0x1f,%ecx
  802182:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802186:	0f 84 b4 00 00 00    	je     802240 <__umoddi3+0x100>
  80218c:	b8 20 00 00 00       	mov    $0x20,%eax
  802191:	89 c2                	mov    %eax,%edx
  802193:	8b 44 24 04          	mov    0x4(%esp),%eax
  802197:	29 c2                	sub    %eax,%edx
  802199:	89 c1                	mov    %eax,%ecx
  80219b:	89 f8                	mov    %edi,%eax
  80219d:	d3 e5                	shl    %cl,%ebp
  80219f:	89 d1                	mov    %edx,%ecx
  8021a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021a5:	d3 e8                	shr    %cl,%eax
  8021a7:	09 c5                	or     %eax,%ebp
  8021a9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ad:	89 c1                	mov    %eax,%ecx
  8021af:	d3 e7                	shl    %cl,%edi
  8021b1:	89 d1                	mov    %edx,%ecx
  8021b3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021b7:	89 df                	mov    %ebx,%edi
  8021b9:	d3 ef                	shr    %cl,%edi
  8021bb:	89 c1                	mov    %eax,%ecx
  8021bd:	89 f0                	mov    %esi,%eax
  8021bf:	d3 e3                	shl    %cl,%ebx
  8021c1:	89 d1                	mov    %edx,%ecx
  8021c3:	89 fa                	mov    %edi,%edx
  8021c5:	d3 e8                	shr    %cl,%eax
  8021c7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021cc:	09 d8                	or     %ebx,%eax
  8021ce:	f7 f5                	div    %ebp
  8021d0:	d3 e6                	shl    %cl,%esi
  8021d2:	89 d1                	mov    %edx,%ecx
  8021d4:	f7 64 24 08          	mull   0x8(%esp)
  8021d8:	39 d1                	cmp    %edx,%ecx
  8021da:	89 c3                	mov    %eax,%ebx
  8021dc:	89 d7                	mov    %edx,%edi
  8021de:	72 06                	jb     8021e6 <__umoddi3+0xa6>
  8021e0:	75 0e                	jne    8021f0 <__umoddi3+0xb0>
  8021e2:	39 c6                	cmp    %eax,%esi
  8021e4:	73 0a                	jae    8021f0 <__umoddi3+0xb0>
  8021e6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021ea:	19 ea                	sbb    %ebp,%edx
  8021ec:	89 d7                	mov    %edx,%edi
  8021ee:	89 c3                	mov    %eax,%ebx
  8021f0:	89 ca                	mov    %ecx,%edx
  8021f2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8021f7:	29 de                	sub    %ebx,%esi
  8021f9:	19 fa                	sbb    %edi,%edx
  8021fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021ff:	89 d0                	mov    %edx,%eax
  802201:	d3 e0                	shl    %cl,%eax
  802203:	89 d9                	mov    %ebx,%ecx
  802205:	d3 ee                	shr    %cl,%esi
  802207:	d3 ea                	shr    %cl,%edx
  802209:	09 f0                	or     %esi,%eax
  80220b:	83 c4 1c             	add    $0x1c,%esp
  80220e:	5b                   	pop    %ebx
  80220f:	5e                   	pop    %esi
  802210:	5f                   	pop    %edi
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    
  802213:	90                   	nop
  802214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802218:	85 ff                	test   %edi,%edi
  80221a:	89 f9                	mov    %edi,%ecx
  80221c:	75 0b                	jne    802229 <__umoddi3+0xe9>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f7                	div    %edi
  802227:	89 c1                	mov    %eax,%ecx
  802229:	89 d8                	mov    %ebx,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f1                	div    %ecx
  80222f:	89 f0                	mov    %esi,%eax
  802231:	f7 f1                	div    %ecx
  802233:	e9 31 ff ff ff       	jmp    802169 <__umoddi3+0x29>
  802238:	90                   	nop
  802239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802240:	39 dd                	cmp    %ebx,%ebp
  802242:	72 08                	jb     80224c <__umoddi3+0x10c>
  802244:	39 f7                	cmp    %esi,%edi
  802246:	0f 87 21 ff ff ff    	ja     80216d <__umoddi3+0x2d>
  80224c:	89 da                	mov    %ebx,%edx
  80224e:	89 f0                	mov    %esi,%eax
  802250:	29 f8                	sub    %edi,%eax
  802252:	19 ea                	sbb    %ebp,%edx
  802254:	e9 14 ff ff ff       	jmp    80216d <__umoddi3+0x2d>

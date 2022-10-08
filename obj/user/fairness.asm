
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 30 0b 00 00       	call   800b70 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 7c 	cmpl   $0xeec0007c,0x804008
  800049:	00 c0 ee 
  80004c:	75 26                	jne    800074 <umain+0x41>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	6a 00                	push   $0x0
  800056:	6a 00                	push   $0x0
  800058:	56                   	push   %esi
  800059:	e8 60 0d 00 00       	call   800dbe <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80005e:	83 c4 0c             	add    $0xc,%esp
  800061:	ff 75 f4             	pushl  -0xc(%ebp)
  800064:	53                   	push   %ebx
  800065:	68 a0 22 80 00       	push   $0x8022a0
  80006a:	e8 27 01 00 00       	call   800196 <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	eb dd                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800074:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	68 b1 22 80 00       	push   $0x8022b1
  800083:	e8 0e 01 00 00       	call   800196 <cprintf>
  800088:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80008b:	a1 c4 00 c0 ee       	mov    0xeec000c4,%eax
  800090:	6a 00                	push   $0x0
  800092:	6a 00                	push   $0x0
  800094:	6a 00                	push   $0x0
  800096:	50                   	push   %eax
  800097:	e8 89 0d 00 00       	call   800e25 <ipc_send>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb ea                	jmp    80008b <umain+0x58>

008000a1 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 bf 0a 00 00       	call   800b70 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x2d>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ce:	83 ec 08             	sub    $0x8,%esp
  8000d1:	56                   	push   %esi
  8000d2:	53                   	push   %ebx
  8000d3:	e8 5b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 0a 00 00 00       	call   8000e7 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e3:	5b                   	pop    %ebx
  8000e4:	5e                   	pop    %esi
  8000e5:	5d                   	pop    %ebp
  8000e6:	c3                   	ret    

008000e7 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000e7:	55                   	push   %ebp
  8000e8:	89 e5                	mov    %esp,%ebp
  8000ea:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ed:	e8 96 0f 00 00       	call   801088 <close_all>
	sys_env_destroy(0);
  8000f2:	83 ec 0c             	sub    $0xc,%esp
  8000f5:	6a 00                	push   $0x0
  8000f7:	e8 33 0a 00 00       	call   800b2f <sys_env_destroy>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	c9                   	leave  
  800100:	c3                   	ret    

00800101 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	53                   	push   %ebx
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010b:	8b 13                	mov    (%ebx),%edx
  80010d:	8d 42 01             	lea    0x1(%edx),%eax
  800110:	89 03                	mov    %eax,(%ebx)
  800112:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800115:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800119:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011e:	74 09                	je     800129 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800120:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800124:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800127:	c9                   	leave  
  800128:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800129:	83 ec 08             	sub    $0x8,%esp
  80012c:	68 ff 00 00 00       	push   $0xff
  800131:	8d 43 08             	lea    0x8(%ebx),%eax
  800134:	50                   	push   %eax
  800135:	e8 b8 09 00 00       	call   800af2 <sys_cputs>
		b->idx = 0;
  80013a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	eb db                	jmp    800120 <putch+0x1f>

00800145 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80014e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800155:	00 00 00 
	b.cnt = 0;
  800158:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800162:	ff 75 0c             	pushl  0xc(%ebp)
  800165:	ff 75 08             	pushl  0x8(%ebp)
  800168:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80016e:	50                   	push   %eax
  80016f:	68 01 01 80 00       	push   $0x800101
  800174:	e8 1a 01 00 00       	call   800293 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800179:	83 c4 08             	add    $0x8,%esp
  80017c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800182:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	e8 64 09 00 00       	call   800af2 <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	50                   	push   %eax
  8001a0:	ff 75 08             	pushl  0x8(%ebp)
  8001a3:	e8 9d ff ff ff       	call   800145 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	57                   	push   %edi
  8001ae:	56                   	push   %esi
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 1c             	sub    $0x1c,%esp
  8001b3:	89 c7                	mov    %eax,%edi
  8001b5:	89 d6                	mov    %edx,%esi
  8001b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ce:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001d1:	39 d3                	cmp    %edx,%ebx
  8001d3:	72 05                	jb     8001da <printnum+0x30>
  8001d5:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001d8:	77 7a                	ja     800254 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	ff 75 18             	pushl  0x18(%ebp)
  8001e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8001e3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001e6:	53                   	push   %ebx
  8001e7:	ff 75 10             	pushl  0x10(%ebp)
  8001ea:	83 ec 08             	sub    $0x8,%esp
  8001ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f9:	e8 62 1e 00 00       	call   802060 <__udivdi3>
  8001fe:	83 c4 18             	add    $0x18,%esp
  800201:	52                   	push   %edx
  800202:	50                   	push   %eax
  800203:	89 f2                	mov    %esi,%edx
  800205:	89 f8                	mov    %edi,%eax
  800207:	e8 9e ff ff ff       	call   8001aa <printnum>
  80020c:	83 c4 20             	add    $0x20,%esp
  80020f:	eb 13                	jmp    800224 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	83 ec 08             	sub    $0x8,%esp
  800214:	56                   	push   %esi
  800215:	ff 75 18             	pushl  0x18(%ebp)
  800218:	ff d7                	call   *%edi
  80021a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80021d:	83 eb 01             	sub    $0x1,%ebx
  800220:	85 db                	test   %ebx,%ebx
  800222:	7f ed                	jg     800211 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	56                   	push   %esi
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80022e:	ff 75 e0             	pushl  -0x20(%ebp)
  800231:	ff 75 dc             	pushl  -0x24(%ebp)
  800234:	ff 75 d8             	pushl  -0x28(%ebp)
  800237:	e8 44 1f 00 00       	call   802180 <__umoddi3>
  80023c:	83 c4 14             	add    $0x14,%esp
  80023f:	0f be 80 d2 22 80 00 	movsbl 0x8022d2(%eax),%eax
  800246:	50                   	push   %eax
  800247:	ff d7                	call   *%edi
}
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80024f:	5b                   	pop    %ebx
  800250:	5e                   	pop    %esi
  800251:	5f                   	pop    %edi
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    
  800254:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800257:	eb c4                	jmp    80021d <printnum+0x73>

00800259 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80025f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800263:	8b 10                	mov    (%eax),%edx
  800265:	3b 50 04             	cmp    0x4(%eax),%edx
  800268:	73 0a                	jae    800274 <sprintputch+0x1b>
		*b->buf++ = ch;
  80026a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80026d:	89 08                	mov    %ecx,(%eax)
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	88 02                	mov    %al,(%edx)
}
  800274:	5d                   	pop    %ebp
  800275:	c3                   	ret    

00800276 <printfmt>:
{
  800276:	55                   	push   %ebp
  800277:	89 e5                	mov    %esp,%ebp
  800279:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80027c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80027f:	50                   	push   %eax
  800280:	ff 75 10             	pushl  0x10(%ebp)
  800283:	ff 75 0c             	pushl  0xc(%ebp)
  800286:	ff 75 08             	pushl  0x8(%ebp)
  800289:	e8 05 00 00 00       	call   800293 <vprintfmt>
}
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	c9                   	leave  
  800292:	c3                   	ret    

00800293 <vprintfmt>:
{
  800293:	55                   	push   %ebp
  800294:	89 e5                	mov    %esp,%ebp
  800296:	57                   	push   %edi
  800297:	56                   	push   %esi
  800298:	53                   	push   %ebx
  800299:	83 ec 2c             	sub    $0x2c,%esp
  80029c:	8b 75 08             	mov    0x8(%ebp),%esi
  80029f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002a2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002a5:	e9 c1 03 00 00       	jmp    80066b <vprintfmt+0x3d8>
		padc = ' ';
  8002aa:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002ae:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002b5:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002bc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002c3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002c8:	8d 47 01             	lea    0x1(%edi),%eax
  8002cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ce:	0f b6 17             	movzbl (%edi),%edx
  8002d1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002d4:	3c 55                	cmp    $0x55,%al
  8002d6:	0f 87 12 04 00 00    	ja     8006ee <vprintfmt+0x45b>
  8002dc:	0f b6 c0             	movzbl %al,%eax
  8002df:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
  8002e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002e9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ed:	eb d9                	jmp    8002c8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002f2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002f6:	eb d0                	jmp    8002c8 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002f8:	0f b6 d2             	movzbl %dl,%edx
  8002fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002fe:	b8 00 00 00 00       	mov    $0x0,%eax
  800303:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800306:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800309:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80030d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800310:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800313:	83 f9 09             	cmp    $0x9,%ecx
  800316:	77 55                	ja     80036d <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800318:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80031b:	eb e9                	jmp    800306 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80031d:	8b 45 14             	mov    0x14(%ebp),%eax
  800320:	8b 00                	mov    (%eax),%eax
  800322:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800325:	8b 45 14             	mov    0x14(%ebp),%eax
  800328:	8d 40 04             	lea    0x4(%eax),%eax
  80032b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80032e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800331:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800335:	79 91                	jns    8002c8 <vprintfmt+0x35>
				width = precision, precision = -1;
  800337:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80033a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80033d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800344:	eb 82                	jmp    8002c8 <vprintfmt+0x35>
  800346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	ba 00 00 00 00       	mov    $0x0,%edx
  800350:	0f 49 d0             	cmovns %eax,%edx
  800353:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800359:	e9 6a ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
  80035e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800361:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800368:	e9 5b ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
  80036d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800370:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800373:	eb bc                	jmp    800331 <vprintfmt+0x9e>
			lflag++;
  800375:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800378:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80037b:	e9 48 ff ff ff       	jmp    8002c8 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800380:	8b 45 14             	mov    0x14(%ebp),%eax
  800383:	8d 78 04             	lea    0x4(%eax),%edi
  800386:	83 ec 08             	sub    $0x8,%esp
  800389:	53                   	push   %ebx
  80038a:	ff 30                	pushl  (%eax)
  80038c:	ff d6                	call   *%esi
			break;
  80038e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800391:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800394:	e9 cf 02 00 00       	jmp    800668 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800399:	8b 45 14             	mov    0x14(%ebp),%eax
  80039c:	8d 78 04             	lea    0x4(%eax),%edi
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	99                   	cltd   
  8003a2:	31 d0                	xor    %edx,%eax
  8003a4:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003a6:	83 f8 0f             	cmp    $0xf,%eax
  8003a9:	7f 23                	jg     8003ce <vprintfmt+0x13b>
  8003ab:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  8003b2:	85 d2                	test   %edx,%edx
  8003b4:	74 18                	je     8003ce <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003b6:	52                   	push   %edx
  8003b7:	68 d1 26 80 00       	push   $0x8026d1
  8003bc:	53                   	push   %ebx
  8003bd:	56                   	push   %esi
  8003be:	e8 b3 fe ff ff       	call   800276 <printfmt>
  8003c3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c6:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003c9:	e9 9a 02 00 00       	jmp    800668 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003ce:	50                   	push   %eax
  8003cf:	68 ea 22 80 00       	push   $0x8022ea
  8003d4:	53                   	push   %ebx
  8003d5:	56                   	push   %esi
  8003d6:	e8 9b fe ff ff       	call   800276 <printfmt>
  8003db:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003de:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003e1:	e9 82 02 00 00       	jmp    800668 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	83 c0 04             	add    $0x4,%eax
  8003ec:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f2:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003f4:	85 ff                	test   %edi,%edi
  8003f6:	b8 e3 22 80 00       	mov    $0x8022e3,%eax
  8003fb:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800402:	0f 8e bd 00 00 00    	jle    8004c5 <vprintfmt+0x232>
  800408:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80040c:	75 0e                	jne    80041c <vprintfmt+0x189>
  80040e:	89 75 08             	mov    %esi,0x8(%ebp)
  800411:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800414:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800417:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80041a:	eb 6d                	jmp    800489 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	ff 75 d0             	pushl  -0x30(%ebp)
  800422:	57                   	push   %edi
  800423:	e8 6e 03 00 00       	call   800796 <strnlen>
  800428:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80042b:	29 c1                	sub    %eax,%ecx
  80042d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800430:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800433:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800437:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80043d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80043f:	eb 0f                	jmp    800450 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800441:	83 ec 08             	sub    $0x8,%esp
  800444:	53                   	push   %ebx
  800445:	ff 75 e0             	pushl  -0x20(%ebp)
  800448:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80044a:	83 ef 01             	sub    $0x1,%edi
  80044d:	83 c4 10             	add    $0x10,%esp
  800450:	85 ff                	test   %edi,%edi
  800452:	7f ed                	jg     800441 <vprintfmt+0x1ae>
  800454:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800457:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80045a:	85 c9                	test   %ecx,%ecx
  80045c:	b8 00 00 00 00       	mov    $0x0,%eax
  800461:	0f 49 c1             	cmovns %ecx,%eax
  800464:	29 c1                	sub    %eax,%ecx
  800466:	89 75 08             	mov    %esi,0x8(%ebp)
  800469:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80046f:	89 cb                	mov    %ecx,%ebx
  800471:	eb 16                	jmp    800489 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800473:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800477:	75 31                	jne    8004aa <vprintfmt+0x217>
					putch(ch, putdat);
  800479:	83 ec 08             	sub    $0x8,%esp
  80047c:	ff 75 0c             	pushl  0xc(%ebp)
  80047f:	50                   	push   %eax
  800480:	ff 55 08             	call   *0x8(%ebp)
  800483:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800486:	83 eb 01             	sub    $0x1,%ebx
  800489:	83 c7 01             	add    $0x1,%edi
  80048c:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800490:	0f be c2             	movsbl %dl,%eax
  800493:	85 c0                	test   %eax,%eax
  800495:	74 59                	je     8004f0 <vprintfmt+0x25d>
  800497:	85 f6                	test   %esi,%esi
  800499:	78 d8                	js     800473 <vprintfmt+0x1e0>
  80049b:	83 ee 01             	sub    $0x1,%esi
  80049e:	79 d3                	jns    800473 <vprintfmt+0x1e0>
  8004a0:	89 df                	mov    %ebx,%edi
  8004a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004a8:	eb 37                	jmp    8004e1 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004aa:	0f be d2             	movsbl %dl,%edx
  8004ad:	83 ea 20             	sub    $0x20,%edx
  8004b0:	83 fa 5e             	cmp    $0x5e,%edx
  8004b3:	76 c4                	jbe    800479 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	6a 3f                	push   $0x3f
  8004bd:	ff 55 08             	call   *0x8(%ebp)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	eb c1                	jmp    800486 <vprintfmt+0x1f3>
  8004c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004cb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ce:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004d1:	eb b6                	jmp    800489 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	6a 20                	push   $0x20
  8004d9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004db:	83 ef 01             	sub    $0x1,%edi
  8004de:	83 c4 10             	add    $0x10,%esp
  8004e1:	85 ff                	test   %edi,%edi
  8004e3:	7f ee                	jg     8004d3 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004eb:	e9 78 01 00 00       	jmp    800668 <vprintfmt+0x3d5>
  8004f0:	89 df                	mov    %ebx,%edi
  8004f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004f8:	eb e7                	jmp    8004e1 <vprintfmt+0x24e>
	if (lflag >= 2)
  8004fa:	83 f9 01             	cmp    $0x1,%ecx
  8004fd:	7e 3f                	jle    80053e <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800502:	8b 50 04             	mov    0x4(%eax),%edx
  800505:	8b 00                	mov    (%eax),%eax
  800507:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80050d:	8b 45 14             	mov    0x14(%ebp),%eax
  800510:	8d 40 08             	lea    0x8(%eax),%eax
  800513:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800516:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80051a:	79 5c                	jns    800578 <vprintfmt+0x2e5>
				putch('-', putdat);
  80051c:	83 ec 08             	sub    $0x8,%esp
  80051f:	53                   	push   %ebx
  800520:	6a 2d                	push   $0x2d
  800522:	ff d6                	call   *%esi
				num = -(long long) num;
  800524:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800527:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80052a:	f7 da                	neg    %edx
  80052c:	83 d1 00             	adc    $0x0,%ecx
  80052f:	f7 d9                	neg    %ecx
  800531:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800534:	b8 0a 00 00 00       	mov    $0xa,%eax
  800539:	e9 10 01 00 00       	jmp    80064e <vprintfmt+0x3bb>
	else if (lflag)
  80053e:	85 c9                	test   %ecx,%ecx
  800540:	75 1b                	jne    80055d <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800542:	8b 45 14             	mov    0x14(%ebp),%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054a:	89 c1                	mov    %eax,%ecx
  80054c:	c1 f9 1f             	sar    $0x1f,%ecx
  80054f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 04             	lea    0x4(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	eb b9                	jmp    800516 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800565:	89 c1                	mov    %eax,%ecx
  800567:	c1 f9 1f             	sar    $0x1f,%ecx
  80056a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8d 40 04             	lea    0x4(%eax),%eax
  800573:	89 45 14             	mov    %eax,0x14(%ebp)
  800576:	eb 9e                	jmp    800516 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800578:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80057e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800583:	e9 c6 00 00 00       	jmp    80064e <vprintfmt+0x3bb>
	if (lflag >= 2)
  800588:	83 f9 01             	cmp    $0x1,%ecx
  80058b:	7e 18                	jle    8005a5 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8b 10                	mov    (%eax),%edx
  800592:	8b 48 04             	mov    0x4(%eax),%ecx
  800595:	8d 40 08             	lea    0x8(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80059b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a0:	e9 a9 00 00 00       	jmp    80064e <vprintfmt+0x3bb>
	else if (lflag)
  8005a5:	85 c9                	test   %ecx,%ecx
  8005a7:	75 1a                	jne    8005c3 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ac:	8b 10                	mov    (%eax),%edx
  8005ae:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b3:	8d 40 04             	lea    0x4(%eax),%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005be:	e9 8b 00 00 00       	jmp    80064e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 10                	mov    (%eax),%edx
  8005c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d8:	eb 74                	jmp    80064e <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005da:	83 f9 01             	cmp    $0x1,%ecx
  8005dd:	7e 15                	jle    8005f4 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 10                	mov    (%eax),%edx
  8005e4:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e7:	8d 40 08             	lea    0x8(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f2:	eb 5a                	jmp    80064e <vprintfmt+0x3bb>
	else if (lflag)
  8005f4:	85 c9                	test   %ecx,%ecx
  8005f6:	75 17                	jne    80060f <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8b 10                	mov    (%eax),%edx
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800608:	b8 08 00 00 00       	mov    $0x8,%eax
  80060d:	eb 3f                	jmp    80064e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8b 10                	mov    (%eax),%edx
  800614:	b9 00 00 00 00       	mov    $0x0,%ecx
  800619:	8d 40 04             	lea    0x4(%eax),%eax
  80061c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80061f:	b8 08 00 00 00       	mov    $0x8,%eax
  800624:	eb 28                	jmp    80064e <vprintfmt+0x3bb>
			putch('0', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 30                	push   $0x30
  80062c:	ff d6                	call   *%esi
			putch('x', putdat);
  80062e:	83 c4 08             	add    $0x8,%esp
  800631:	53                   	push   %ebx
  800632:	6a 78                	push   $0x78
  800634:	ff d6                	call   *%esi
			num = (unsigned long long)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 10                	mov    (%eax),%edx
  80063b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800640:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800643:	8d 40 04             	lea    0x4(%eax),%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800649:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800655:	57                   	push   %edi
  800656:	ff 75 e0             	pushl  -0x20(%ebp)
  800659:	50                   	push   %eax
  80065a:	51                   	push   %ecx
  80065b:	52                   	push   %edx
  80065c:	89 da                	mov    %ebx,%edx
  80065e:	89 f0                	mov    %esi,%eax
  800660:	e8 45 fb ff ff       	call   8001aa <printnum>
			break;
  800665:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800668:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066b:	83 c7 01             	add    $0x1,%edi
  80066e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800672:	83 f8 25             	cmp    $0x25,%eax
  800675:	0f 84 2f fc ff ff    	je     8002aa <vprintfmt+0x17>
			if (ch == '\0')
  80067b:	85 c0                	test   %eax,%eax
  80067d:	0f 84 8b 00 00 00    	je     80070e <vprintfmt+0x47b>
			putch(ch, putdat);
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	53                   	push   %ebx
  800687:	50                   	push   %eax
  800688:	ff d6                	call   *%esi
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	eb dc                	jmp    80066b <vprintfmt+0x3d8>
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 15                	jle    8006a9 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
  800699:	8b 48 04             	mov    0x4(%eax),%ecx
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a7:	eb a5                	jmp    80064e <vprintfmt+0x3bb>
	else if (lflag)
  8006a9:	85 c9                	test   %ecx,%ecx
  8006ab:	75 17                	jne    8006c4 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006bd:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c2:	eb 8a                	jmp    80064e <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8b 10                	mov    (%eax),%edx
  8006c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ce:	8d 40 04             	lea    0x4(%eax),%eax
  8006d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006d9:	e9 70 ff ff ff       	jmp    80064e <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	53                   	push   %ebx
  8006e2:	6a 25                	push   $0x25
  8006e4:	ff d6                	call   *%esi
			break;
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	e9 7a ff ff ff       	jmp    800668 <vprintfmt+0x3d5>
			putch('%', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	6a 25                	push   $0x25
  8006f4:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	89 f8                	mov    %edi,%eax
  8006fb:	eb 03                	jmp    800700 <vprintfmt+0x46d>
  8006fd:	83 e8 01             	sub    $0x1,%eax
  800700:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800704:	75 f7                	jne    8006fd <vprintfmt+0x46a>
  800706:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800709:	e9 5a ff ff ff       	jmp    800668 <vprintfmt+0x3d5>
}
  80070e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800711:	5b                   	pop    %ebx
  800712:	5e                   	pop    %esi
  800713:	5f                   	pop    %edi
  800714:	5d                   	pop    %ebp
  800715:	c3                   	ret    

00800716 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800716:	55                   	push   %ebp
  800717:	89 e5                	mov    %esp,%ebp
  800719:	83 ec 18             	sub    $0x18,%esp
  80071c:	8b 45 08             	mov    0x8(%ebp),%eax
  80071f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800722:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800725:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800729:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80072c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800733:	85 c0                	test   %eax,%eax
  800735:	74 26                	je     80075d <vsnprintf+0x47>
  800737:	85 d2                	test   %edx,%edx
  800739:	7e 22                	jle    80075d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80073b:	ff 75 14             	pushl  0x14(%ebp)
  80073e:	ff 75 10             	pushl  0x10(%ebp)
  800741:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800744:	50                   	push   %eax
  800745:	68 59 02 80 00       	push   $0x800259
  80074a:	e8 44 fb ff ff       	call   800293 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80074f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800752:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800758:	83 c4 10             	add    $0x10,%esp
}
  80075b:	c9                   	leave  
  80075c:	c3                   	ret    
		return -E_INVAL;
  80075d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800762:	eb f7                	jmp    80075b <vsnprintf+0x45>

00800764 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80076a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80076d:	50                   	push   %eax
  80076e:	ff 75 10             	pushl  0x10(%ebp)
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	ff 75 08             	pushl  0x8(%ebp)
  800777:	e8 9a ff ff ff       	call   800716 <vsnprintf>
	va_end(ap);

	return rc;
}
  80077c:	c9                   	leave  
  80077d:	c3                   	ret    

0080077e <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80077e:	55                   	push   %ebp
  80077f:	89 e5                	mov    %esp,%ebp
  800781:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800784:	b8 00 00 00 00       	mov    $0x0,%eax
  800789:	eb 03                	jmp    80078e <strlen+0x10>
		n++;
  80078b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80078e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800792:	75 f7                	jne    80078b <strlen+0xd>
	return n;
}
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80079c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079f:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a4:	eb 03                	jmp    8007a9 <strnlen+0x13>
		n++;
  8007a6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a9:	39 d0                	cmp    %edx,%eax
  8007ab:	74 06                	je     8007b3 <strnlen+0x1d>
  8007ad:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007b1:	75 f3                	jne    8007a6 <strnlen+0x10>
	return n;
}
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	53                   	push   %ebx
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007bf:	89 c2                	mov    %eax,%edx
  8007c1:	83 c1 01             	add    $0x1,%ecx
  8007c4:	83 c2 01             	add    $0x1,%edx
  8007c7:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007cb:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ce:	84 db                	test   %bl,%bl
  8007d0:	75 ef                	jne    8007c1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007d2:	5b                   	pop    %ebx
  8007d3:	5d                   	pop    %ebp
  8007d4:	c3                   	ret    

008007d5 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d5:	55                   	push   %ebp
  8007d6:	89 e5                	mov    %esp,%ebp
  8007d8:	53                   	push   %ebx
  8007d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007dc:	53                   	push   %ebx
  8007dd:	e8 9c ff ff ff       	call   80077e <strlen>
  8007e2:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	01 d8                	add    %ebx,%eax
  8007ea:	50                   	push   %eax
  8007eb:	e8 c5 ff ff ff       	call   8007b5 <strcpy>
	return dst;
}
  8007f0:	89 d8                	mov    %ebx,%eax
  8007f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f5:	c9                   	leave  
  8007f6:	c3                   	ret    

008007f7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	56                   	push   %esi
  8007fb:	53                   	push   %ebx
  8007fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800802:	89 f3                	mov    %esi,%ebx
  800804:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800807:	89 f2                	mov    %esi,%edx
  800809:	eb 0f                	jmp    80081a <strncpy+0x23>
		*dst++ = *src;
  80080b:	83 c2 01             	add    $0x1,%edx
  80080e:	0f b6 01             	movzbl (%ecx),%eax
  800811:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800814:	80 39 01             	cmpb   $0x1,(%ecx)
  800817:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80081a:	39 da                	cmp    %ebx,%edx
  80081c:	75 ed                	jne    80080b <strncpy+0x14>
	}
	return ret;
}
  80081e:	89 f0                	mov    %esi,%eax
  800820:	5b                   	pop    %ebx
  800821:	5e                   	pop    %esi
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	56                   	push   %esi
  800828:	53                   	push   %ebx
  800829:	8b 75 08             	mov    0x8(%ebp),%esi
  80082c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800832:	89 f0                	mov    %esi,%eax
  800834:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800838:	85 c9                	test   %ecx,%ecx
  80083a:	75 0b                	jne    800847 <strlcpy+0x23>
  80083c:	eb 17                	jmp    800855 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80083e:	83 c2 01             	add    $0x1,%edx
  800841:	83 c0 01             	add    $0x1,%eax
  800844:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800847:	39 d8                	cmp    %ebx,%eax
  800849:	74 07                	je     800852 <strlcpy+0x2e>
  80084b:	0f b6 0a             	movzbl (%edx),%ecx
  80084e:	84 c9                	test   %cl,%cl
  800850:	75 ec                	jne    80083e <strlcpy+0x1a>
		*dst = '\0';
  800852:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800855:	29 f0                	sub    %esi,%eax
}
  800857:	5b                   	pop    %ebx
  800858:	5e                   	pop    %esi
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800861:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800864:	eb 06                	jmp    80086c <strcmp+0x11>
		p++, q++;
  800866:	83 c1 01             	add    $0x1,%ecx
  800869:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80086c:	0f b6 01             	movzbl (%ecx),%eax
  80086f:	84 c0                	test   %al,%al
  800871:	74 04                	je     800877 <strcmp+0x1c>
  800873:	3a 02                	cmp    (%edx),%al
  800875:	74 ef                	je     800866 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800877:	0f b6 c0             	movzbl %al,%eax
  80087a:	0f b6 12             	movzbl (%edx),%edx
  80087d:	29 d0                	sub    %edx,%eax
}
  80087f:	5d                   	pop    %ebp
  800880:	c3                   	ret    

00800881 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800881:	55                   	push   %ebp
  800882:	89 e5                	mov    %esp,%ebp
  800884:	53                   	push   %ebx
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088b:	89 c3                	mov    %eax,%ebx
  80088d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800890:	eb 06                	jmp    800898 <strncmp+0x17>
		n--, p++, q++;
  800892:	83 c0 01             	add    $0x1,%eax
  800895:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800898:	39 d8                	cmp    %ebx,%eax
  80089a:	74 16                	je     8008b2 <strncmp+0x31>
  80089c:	0f b6 08             	movzbl (%eax),%ecx
  80089f:	84 c9                	test   %cl,%cl
  8008a1:	74 04                	je     8008a7 <strncmp+0x26>
  8008a3:	3a 0a                	cmp    (%edx),%cl
  8008a5:	74 eb                	je     800892 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a7:	0f b6 00             	movzbl (%eax),%eax
  8008aa:	0f b6 12             	movzbl (%edx),%edx
  8008ad:	29 d0                	sub    %edx,%eax
}
  8008af:	5b                   	pop    %ebx
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    
		return 0;
  8008b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b7:	eb f6                	jmp    8008af <strncmp+0x2e>

008008b9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c3:	0f b6 10             	movzbl (%eax),%edx
  8008c6:	84 d2                	test   %dl,%dl
  8008c8:	74 09                	je     8008d3 <strchr+0x1a>
		if (*s == c)
  8008ca:	38 ca                	cmp    %cl,%dl
  8008cc:	74 0a                	je     8008d8 <strchr+0x1f>
	for (; *s; s++)
  8008ce:	83 c0 01             	add    $0x1,%eax
  8008d1:	eb f0                	jmp    8008c3 <strchr+0xa>
			return (char *) s;
	return 0;
  8008d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e4:	eb 03                	jmp    8008e9 <strfind+0xf>
  8008e6:	83 c0 01             	add    $0x1,%eax
  8008e9:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ec:	38 ca                	cmp    %cl,%dl
  8008ee:	74 04                	je     8008f4 <strfind+0x1a>
  8008f0:	84 d2                	test   %dl,%dl
  8008f2:	75 f2                	jne    8008e6 <strfind+0xc>
			break;
	return (char *) s;
}
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	57                   	push   %edi
  8008fa:	56                   	push   %esi
  8008fb:	53                   	push   %ebx
  8008fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800902:	85 c9                	test   %ecx,%ecx
  800904:	74 13                	je     800919 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800906:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80090c:	75 05                	jne    800913 <memset+0x1d>
  80090e:	f6 c1 03             	test   $0x3,%cl
  800911:	74 0d                	je     800920 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800913:	8b 45 0c             	mov    0xc(%ebp),%eax
  800916:	fc                   	cld    
  800917:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800919:	89 f8                	mov    %edi,%eax
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5f                   	pop    %edi
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    
		c &= 0xFF;
  800920:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800924:	89 d3                	mov    %edx,%ebx
  800926:	c1 e3 08             	shl    $0x8,%ebx
  800929:	89 d0                	mov    %edx,%eax
  80092b:	c1 e0 18             	shl    $0x18,%eax
  80092e:	89 d6                	mov    %edx,%esi
  800930:	c1 e6 10             	shl    $0x10,%esi
  800933:	09 f0                	or     %esi,%eax
  800935:	09 c2                	or     %eax,%edx
  800937:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800939:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80093c:	89 d0                	mov    %edx,%eax
  80093e:	fc                   	cld    
  80093f:	f3 ab                	rep stos %eax,%es:(%edi)
  800941:	eb d6                	jmp    800919 <memset+0x23>

00800943 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800943:	55                   	push   %ebp
  800944:	89 e5                	mov    %esp,%ebp
  800946:	57                   	push   %edi
  800947:	56                   	push   %esi
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80094e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800951:	39 c6                	cmp    %eax,%esi
  800953:	73 35                	jae    80098a <memmove+0x47>
  800955:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	76 2e                	jbe    80098a <memmove+0x47>
		s += n;
		d += n;
  80095c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095f:	89 d6                	mov    %edx,%esi
  800961:	09 fe                	or     %edi,%esi
  800963:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800969:	74 0c                	je     800977 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80096b:	83 ef 01             	sub    $0x1,%edi
  80096e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800971:	fd                   	std    
  800972:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800974:	fc                   	cld    
  800975:	eb 21                	jmp    800998 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800977:	f6 c1 03             	test   $0x3,%cl
  80097a:	75 ef                	jne    80096b <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80097c:	83 ef 04             	sub    $0x4,%edi
  80097f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800982:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800985:	fd                   	std    
  800986:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800988:	eb ea                	jmp    800974 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80098a:	89 f2                	mov    %esi,%edx
  80098c:	09 c2                	or     %eax,%edx
  80098e:	f6 c2 03             	test   $0x3,%dl
  800991:	74 09                	je     80099c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800993:	89 c7                	mov    %eax,%edi
  800995:	fc                   	cld    
  800996:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800998:	5e                   	pop    %esi
  800999:	5f                   	pop    %edi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099c:	f6 c1 03             	test   $0x3,%cl
  80099f:	75 f2                	jne    800993 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009a4:	89 c7                	mov    %eax,%edi
  8009a6:	fc                   	cld    
  8009a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a9:	eb ed                	jmp    800998 <memmove+0x55>

008009ab <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009ae:	ff 75 10             	pushl  0x10(%ebp)
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	ff 75 08             	pushl  0x8(%ebp)
  8009b7:	e8 87 ff ff ff       	call   800943 <memmove>
}
  8009bc:	c9                   	leave  
  8009bd:	c3                   	ret    

008009be <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	56                   	push   %esi
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c9:	89 c6                	mov    %eax,%esi
  8009cb:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ce:	39 f0                	cmp    %esi,%eax
  8009d0:	74 1c                	je     8009ee <memcmp+0x30>
		if (*s1 != *s2)
  8009d2:	0f b6 08             	movzbl (%eax),%ecx
  8009d5:	0f b6 1a             	movzbl (%edx),%ebx
  8009d8:	38 d9                	cmp    %bl,%cl
  8009da:	75 08                	jne    8009e4 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009dc:	83 c0 01             	add    $0x1,%eax
  8009df:	83 c2 01             	add    $0x1,%edx
  8009e2:	eb ea                	jmp    8009ce <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009e4:	0f b6 c1             	movzbl %cl,%eax
  8009e7:	0f b6 db             	movzbl %bl,%ebx
  8009ea:	29 d8                	sub    %ebx,%eax
  8009ec:	eb 05                	jmp    8009f3 <memcmp+0x35>
	}

	return 0;
  8009ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f3:	5b                   	pop    %ebx
  8009f4:	5e                   	pop    %esi
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a00:	89 c2                	mov    %eax,%edx
  800a02:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a05:	39 d0                	cmp    %edx,%eax
  800a07:	73 09                	jae    800a12 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a09:	38 08                	cmp    %cl,(%eax)
  800a0b:	74 05                	je     800a12 <memfind+0x1b>
	for (; s < ends; s++)
  800a0d:	83 c0 01             	add    $0x1,%eax
  800a10:	eb f3                	jmp    800a05 <memfind+0xe>
			break;
	return (void *) s;
}
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	53                   	push   %ebx
  800a1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a20:	eb 03                	jmp    800a25 <strtol+0x11>
		s++;
  800a22:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a25:	0f b6 01             	movzbl (%ecx),%eax
  800a28:	3c 20                	cmp    $0x20,%al
  800a2a:	74 f6                	je     800a22 <strtol+0xe>
  800a2c:	3c 09                	cmp    $0x9,%al
  800a2e:	74 f2                	je     800a22 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a30:	3c 2b                	cmp    $0x2b,%al
  800a32:	74 2e                	je     800a62 <strtol+0x4e>
	int neg = 0;
  800a34:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a39:	3c 2d                	cmp    $0x2d,%al
  800a3b:	74 2f                	je     800a6c <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a3d:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a43:	75 05                	jne    800a4a <strtol+0x36>
  800a45:	80 39 30             	cmpb   $0x30,(%ecx)
  800a48:	74 2c                	je     800a76 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a4a:	85 db                	test   %ebx,%ebx
  800a4c:	75 0a                	jne    800a58 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a4e:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a53:	80 39 30             	cmpb   $0x30,(%ecx)
  800a56:	74 28                	je     800a80 <strtol+0x6c>
		base = 10;
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5d:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a60:	eb 50                	jmp    800ab2 <strtol+0x9e>
		s++;
  800a62:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a65:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6a:	eb d1                	jmp    800a3d <strtol+0x29>
		s++, neg = 1;
  800a6c:	83 c1 01             	add    $0x1,%ecx
  800a6f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a74:	eb c7                	jmp    800a3d <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a76:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a7a:	74 0e                	je     800a8a <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a7c:	85 db                	test   %ebx,%ebx
  800a7e:	75 d8                	jne    800a58 <strtol+0x44>
		s++, base = 8;
  800a80:	83 c1 01             	add    $0x1,%ecx
  800a83:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a88:	eb ce                	jmp    800a58 <strtol+0x44>
		s += 2, base = 16;
  800a8a:	83 c1 02             	add    $0x2,%ecx
  800a8d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a92:	eb c4                	jmp    800a58 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a94:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a97:	89 f3                	mov    %esi,%ebx
  800a99:	80 fb 19             	cmp    $0x19,%bl
  800a9c:	77 29                	ja     800ac7 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a9e:	0f be d2             	movsbl %dl,%edx
  800aa1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aa4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aa7:	7d 30                	jge    800ad9 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aa9:	83 c1 01             	add    $0x1,%ecx
  800aac:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab2:	0f b6 11             	movzbl (%ecx),%edx
  800ab5:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ab8:	89 f3                	mov    %esi,%ebx
  800aba:	80 fb 09             	cmp    $0x9,%bl
  800abd:	77 d5                	ja     800a94 <strtol+0x80>
			dig = *s - '0';
  800abf:	0f be d2             	movsbl %dl,%edx
  800ac2:	83 ea 30             	sub    $0x30,%edx
  800ac5:	eb dd                	jmp    800aa4 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ac7:	8d 72 bf             	lea    -0x41(%edx),%esi
  800aca:	89 f3                	mov    %esi,%ebx
  800acc:	80 fb 19             	cmp    $0x19,%bl
  800acf:	77 08                	ja     800ad9 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800ad1:	0f be d2             	movsbl %dl,%edx
  800ad4:	83 ea 37             	sub    $0x37,%edx
  800ad7:	eb cb                	jmp    800aa4 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800add:	74 05                	je     800ae4 <strtol+0xd0>
		*endptr = (char *) s;
  800adf:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae2:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae4:	89 c2                	mov    %eax,%edx
  800ae6:	f7 da                	neg    %edx
  800ae8:	85 ff                	test   %edi,%edi
  800aea:	0f 45 c2             	cmovne %edx,%eax
}
  800aed:	5b                   	pop    %ebx
  800aee:	5e                   	pop    %esi
  800aef:	5f                   	pop    %edi
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	57                   	push   %edi
  800af6:	56                   	push   %esi
  800af7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af8:	b8 00 00 00 00       	mov    $0x0,%eax
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b03:	89 c3                	mov    %eax,%ebx
  800b05:	89 c7                	mov    %eax,%edi
  800b07:	89 c6                	mov    %eax,%esi
  800b09:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5f                   	pop    %edi
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	57                   	push   %edi
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b16:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b20:	89 d1                	mov    %edx,%ecx
  800b22:	89 d3                	mov    %edx,%ebx
  800b24:	89 d7                	mov    %edx,%edi
  800b26:	89 d6                	mov    %edx,%esi
  800b28:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b2a:	5b                   	pop    %ebx
  800b2b:	5e                   	pop    %esi
  800b2c:	5f                   	pop    %edi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b38:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b40:	b8 03 00 00 00       	mov    $0x3,%eax
  800b45:	89 cb                	mov    %ecx,%ebx
  800b47:	89 cf                	mov    %ecx,%edi
  800b49:	89 ce                	mov    %ecx,%esi
  800b4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	7f 08                	jg     800b59 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5f                   	pop    %edi
  800b57:	5d                   	pop    %ebp
  800b58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	50                   	push   %eax
  800b5d:	6a 03                	push   $0x3
  800b5f:	68 df 25 80 00       	push   $0x8025df
  800b64:	6a 23                	push   $0x23
  800b66:	68 fc 25 80 00       	push   $0x8025fc
  800b6b:	e8 62 14 00 00       	call   801fd2 <_panic>

00800b70 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	57                   	push   %edi
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b76:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7b:	b8 02 00 00 00       	mov    $0x2,%eax
  800b80:	89 d1                	mov    %edx,%ecx
  800b82:	89 d3                	mov    %edx,%ebx
  800b84:	89 d7                	mov    %edx,%edi
  800b86:	89 d6                	mov    %edx,%esi
  800b88:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5f                   	pop    %edi
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <sys_yield>:

void
sys_yield(void)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b9f:	89 d1                	mov    %edx,%ecx
  800ba1:	89 d3                	mov    %edx,%ebx
  800ba3:	89 d7                	mov    %edx,%edi
  800ba5:	89 d6                	mov    %edx,%esi
  800ba7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
  800bb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb7:	be 00 00 00 00       	mov    $0x0,%esi
  800bbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc2:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bca:	89 f7                	mov    %esi,%edi
  800bcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bce:	85 c0                	test   %eax,%eax
  800bd0:	7f 08                	jg     800bda <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5f                   	pop    %edi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bda:	83 ec 0c             	sub    $0xc,%esp
  800bdd:	50                   	push   %eax
  800bde:	6a 04                	push   $0x4
  800be0:	68 df 25 80 00       	push   $0x8025df
  800be5:	6a 23                	push   $0x23
  800be7:	68 fc 25 80 00       	push   $0x8025fc
  800bec:	e8 e1 13 00 00       	call   801fd2 <_panic>

00800bf1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
  800bf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c00:	b8 05 00 00 00       	mov    $0x5,%eax
  800c05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c08:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c0b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c10:	85 c0                	test   %eax,%eax
  800c12:	7f 08                	jg     800c1c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1c:	83 ec 0c             	sub    $0xc,%esp
  800c1f:	50                   	push   %eax
  800c20:	6a 05                	push   $0x5
  800c22:	68 df 25 80 00       	push   $0x8025df
  800c27:	6a 23                	push   $0x23
  800c29:	68 fc 25 80 00       	push   $0x8025fc
  800c2e:	e8 9f 13 00 00       	call   801fd2 <_panic>

00800c33 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c41:	8b 55 08             	mov    0x8(%ebp),%edx
  800c44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c47:	b8 06 00 00 00       	mov    $0x6,%eax
  800c4c:	89 df                	mov    %ebx,%edi
  800c4e:	89 de                	mov    %ebx,%esi
  800c50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c52:	85 c0                	test   %eax,%eax
  800c54:	7f 08                	jg     800c5e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c59:	5b                   	pop    %ebx
  800c5a:	5e                   	pop    %esi
  800c5b:	5f                   	pop    %edi
  800c5c:	5d                   	pop    %ebp
  800c5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5e:	83 ec 0c             	sub    $0xc,%esp
  800c61:	50                   	push   %eax
  800c62:	6a 06                	push   $0x6
  800c64:	68 df 25 80 00       	push   $0x8025df
  800c69:	6a 23                	push   $0x23
  800c6b:	68 fc 25 80 00       	push   $0x8025fc
  800c70:	e8 5d 13 00 00       	call   801fd2 <_panic>

00800c75 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c89:	b8 08 00 00 00       	mov    $0x8,%eax
  800c8e:	89 df                	mov    %ebx,%edi
  800c90:	89 de                	mov    %ebx,%esi
  800c92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c94:	85 c0                	test   %eax,%eax
  800c96:	7f 08                	jg     800ca0 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c9b:	5b                   	pop    %ebx
  800c9c:	5e                   	pop    %esi
  800c9d:	5f                   	pop    %edi
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca0:	83 ec 0c             	sub    $0xc,%esp
  800ca3:	50                   	push   %eax
  800ca4:	6a 08                	push   $0x8
  800ca6:	68 df 25 80 00       	push   $0x8025df
  800cab:	6a 23                	push   $0x23
  800cad:	68 fc 25 80 00       	push   $0x8025fc
  800cb2:	e8 1b 13 00 00       	call   801fd2 <_panic>

00800cb7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
  800cbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccb:	b8 09 00 00 00       	mov    $0x9,%eax
  800cd0:	89 df                	mov    %ebx,%edi
  800cd2:	89 de                	mov    %ebx,%esi
  800cd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	7f 08                	jg     800ce2 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	5d                   	pop    %ebp
  800ce1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce2:	83 ec 0c             	sub    $0xc,%esp
  800ce5:	50                   	push   %eax
  800ce6:	6a 09                	push   $0x9
  800ce8:	68 df 25 80 00       	push   $0x8025df
  800ced:	6a 23                	push   $0x23
  800cef:	68 fc 25 80 00       	push   $0x8025fc
  800cf4:	e8 d9 12 00 00       	call   801fd2 <_panic>

00800cf9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	57                   	push   %edi
  800cfd:	56                   	push   %esi
  800cfe:	53                   	push   %ebx
  800cff:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d02:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d12:	89 df                	mov    %ebx,%edi
  800d14:	89 de                	mov    %ebx,%esi
  800d16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	7f 08                	jg     800d24 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d24:	83 ec 0c             	sub    $0xc,%esp
  800d27:	50                   	push   %eax
  800d28:	6a 0a                	push   $0xa
  800d2a:	68 df 25 80 00       	push   $0x8025df
  800d2f:	6a 23                	push   $0x23
  800d31:	68 fc 25 80 00       	push   $0x8025fc
  800d36:	e8 97 12 00 00       	call   801fd2 <_panic>

00800d3b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d41:	8b 55 08             	mov    0x8(%ebp),%edx
  800d44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d47:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d4c:	be 00 00 00 00       	mov    $0x0,%esi
  800d51:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d54:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d57:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    

00800d5e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	57                   	push   %edi
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d67:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d74:	89 cb                	mov    %ecx,%ebx
  800d76:	89 cf                	mov    %ecx,%edi
  800d78:	89 ce                	mov    %ecx,%esi
  800d7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7f 08                	jg     800d88 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 0d                	push   $0xd
  800d8e:	68 df 25 80 00       	push   $0x8025df
  800d93:	6a 23                	push   $0x23
  800d95:	68 fc 25 80 00       	push   $0x8025fc
  800d9a:	e8 33 12 00 00       	call   801fd2 <_panic>

00800d9f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da5:	ba 00 00 00 00       	mov    $0x0,%edx
  800daa:	b8 0e 00 00 00       	mov    $0xe,%eax
  800daf:	89 d1                	mov    %edx,%ecx
  800db1:	89 d3                	mov    %edx,%ebx
  800db3:	89 d7                	mov    %edx,%edi
  800db5:	89 d6                	mov    %edx,%esi
  800db7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    

00800dbe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	8b 75 08             	mov    0x8(%ebp),%esi
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  800dcc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  800dce:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800dd3:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	50                   	push   %eax
  800dda:	e8 7f ff ff ff       	call   800d5e <sys_ipc_recv>
	if (from_env_store)
  800ddf:	83 c4 10             	add    $0x10,%esp
  800de2:	85 f6                	test   %esi,%esi
  800de4:	74 14                	je     800dfa <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  800de6:	ba 00 00 00 00       	mov    $0x0,%edx
  800deb:	85 c0                	test   %eax,%eax
  800ded:	78 09                	js     800df8 <ipc_recv+0x3a>
  800def:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800df5:	8b 52 74             	mov    0x74(%edx),%edx
  800df8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  800dfa:	85 db                	test   %ebx,%ebx
  800dfc:	74 14                	je     800e12 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  800dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800e03:	85 c0                	test   %eax,%eax
  800e05:	78 09                	js     800e10 <ipc_recv+0x52>
  800e07:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800e0d:	8b 52 78             	mov    0x78(%edx),%edx
  800e10:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	78 08                	js     800e1e <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  800e16:	a1 08 40 80 00       	mov    0x804008,%eax
  800e1b:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  800e1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e31:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  800e37:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  800e39:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800e3e:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  800e41:	ff 75 14             	pushl  0x14(%ebp)
  800e44:	53                   	push   %ebx
  800e45:	56                   	push   %esi
  800e46:	57                   	push   %edi
  800e47:	e8 ef fe ff ff       	call   800d3b <sys_ipc_try_send>
		if (ret == 0)
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	74 1e                	je     800e71 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  800e53:	83 f8 f9             	cmp    $0xfffffff9,%eax
  800e56:	75 07                	jne    800e5f <ipc_send+0x3a>
			sys_yield();
  800e58:	e8 32 fd ff ff       	call   800b8f <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  800e5d:	eb e2                	jmp    800e41 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  800e5f:	50                   	push   %eax
  800e60:	68 0a 26 80 00       	push   $0x80260a
  800e65:	6a 3d                	push   $0x3d
  800e67:	68 1e 26 80 00       	push   $0x80261e
  800e6c:	e8 61 11 00 00       	call   801fd2 <_panic>
	}
	// panic("ipc_send not implemented");
}
  800e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  800e7f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  800e84:	6b d0 7c             	imul   $0x7c,%eax,%edx
  800e87:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800e8d:	8b 52 50             	mov    0x50(%edx),%edx
  800e90:	39 ca                	cmp    %ecx,%edx
  800e92:	74 11                	je     800ea5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  800e94:	83 c0 01             	add    $0x1,%eax
  800e97:	3d 00 04 00 00       	cmp    $0x400,%eax
  800e9c:	75 e6                	jne    800e84 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  800e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea3:	eb 0b                	jmp    800eb0 <ipc_find_env+0x37>
			return envs[i].env_id;
  800ea5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ea8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ead:	8b 40 48             	mov    0x48(%eax),%eax
}
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    

00800eb2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	05 00 00 00 30       	add    $0x30000000,%eax
  800ebd:	c1 e8 0c             	shr    $0xc,%eax
}
  800ec0:	5d                   	pop    %ebp
  800ec1:	c3                   	ret    

00800ec2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ecd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ed2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ee4:	89 c2                	mov    %eax,%edx
  800ee6:	c1 ea 16             	shr    $0x16,%edx
  800ee9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ef0:	f6 c2 01             	test   $0x1,%dl
  800ef3:	74 2a                	je     800f1f <fd_alloc+0x46>
  800ef5:	89 c2                	mov    %eax,%edx
  800ef7:	c1 ea 0c             	shr    $0xc,%edx
  800efa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f01:	f6 c2 01             	test   $0x1,%dl
  800f04:	74 19                	je     800f1f <fd_alloc+0x46>
  800f06:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f0b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f10:	75 d2                	jne    800ee4 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f12:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f18:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f1d:	eb 07                	jmp    800f26 <fd_alloc+0x4d>
			*fd_store = fd;
  800f1f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f2e:	83 f8 1f             	cmp    $0x1f,%eax
  800f31:	77 36                	ja     800f69 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f33:	c1 e0 0c             	shl    $0xc,%eax
  800f36:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f3b:	89 c2                	mov    %eax,%edx
  800f3d:	c1 ea 16             	shr    $0x16,%edx
  800f40:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f47:	f6 c2 01             	test   $0x1,%dl
  800f4a:	74 24                	je     800f70 <fd_lookup+0x48>
  800f4c:	89 c2                	mov    %eax,%edx
  800f4e:	c1 ea 0c             	shr    $0xc,%edx
  800f51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f58:	f6 c2 01             	test   $0x1,%dl
  800f5b:	74 1a                	je     800f77 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f60:	89 02                	mov    %eax,(%edx)
	return 0;
  800f62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
		return -E_INVAL;
  800f69:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6e:	eb f7                	jmp    800f67 <fd_lookup+0x3f>
		return -E_INVAL;
  800f70:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f75:	eb f0                	jmp    800f67 <fd_lookup+0x3f>
  800f77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7c:	eb e9                	jmp    800f67 <fd_lookup+0x3f>

00800f7e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f87:	ba a4 26 80 00       	mov    $0x8026a4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f8c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f91:	39 08                	cmp    %ecx,(%eax)
  800f93:	74 33                	je     800fc8 <dev_lookup+0x4a>
  800f95:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f98:	8b 02                	mov    (%edx),%eax
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	75 f3                	jne    800f91 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f9e:	a1 08 40 80 00       	mov    0x804008,%eax
  800fa3:	8b 40 48             	mov    0x48(%eax),%eax
  800fa6:	83 ec 04             	sub    $0x4,%esp
  800fa9:	51                   	push   %ecx
  800faa:	50                   	push   %eax
  800fab:	68 28 26 80 00       	push   $0x802628
  800fb0:	e8 e1 f1 ff ff       	call   800196 <cprintf>
	*dev = 0;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fbe:	83 c4 10             	add    $0x10,%esp
  800fc1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    
			*dev = devtab[i];
  800fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcb:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd2:	eb f2                	jmp    800fc6 <dev_lookup+0x48>

00800fd4 <fd_close>:
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 1c             	sub    $0x1c,%esp
  800fdd:	8b 75 08             	mov    0x8(%ebp),%esi
  800fe0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fe3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fe6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fed:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ff0:	50                   	push   %eax
  800ff1:	e8 32 ff ff ff       	call   800f28 <fd_lookup>
  800ff6:	89 c3                	mov    %eax,%ebx
  800ff8:	83 c4 08             	add    $0x8,%esp
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	78 05                	js     801004 <fd_close+0x30>
	    || fd != fd2)
  800fff:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801002:	74 16                	je     80101a <fd_close+0x46>
		return (must_exist ? r : 0);
  801004:	89 f8                	mov    %edi,%eax
  801006:	84 c0                	test   %al,%al
  801008:	b8 00 00 00 00       	mov    $0x0,%eax
  80100d:	0f 44 d8             	cmove  %eax,%ebx
}
  801010:	89 d8                	mov    %ebx,%eax
  801012:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80101a:	83 ec 08             	sub    $0x8,%esp
  80101d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801020:	50                   	push   %eax
  801021:	ff 36                	pushl  (%esi)
  801023:	e8 56 ff ff ff       	call   800f7e <dev_lookup>
  801028:	89 c3                	mov    %eax,%ebx
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	85 c0                	test   %eax,%eax
  80102f:	78 15                	js     801046 <fd_close+0x72>
		if (dev->dev_close)
  801031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801034:	8b 40 10             	mov    0x10(%eax),%eax
  801037:	85 c0                	test   %eax,%eax
  801039:	74 1b                	je     801056 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	56                   	push   %esi
  80103f:	ff d0                	call   *%eax
  801041:	89 c3                	mov    %eax,%ebx
  801043:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801046:	83 ec 08             	sub    $0x8,%esp
  801049:	56                   	push   %esi
  80104a:	6a 00                	push   $0x0
  80104c:	e8 e2 fb ff ff       	call   800c33 <sys_page_unmap>
	return r;
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	eb ba                	jmp    801010 <fd_close+0x3c>
			r = 0;
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105b:	eb e9                	jmp    801046 <fd_close+0x72>

0080105d <close>:

int
close(int fdnum)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801063:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801066:	50                   	push   %eax
  801067:	ff 75 08             	pushl  0x8(%ebp)
  80106a:	e8 b9 fe ff ff       	call   800f28 <fd_lookup>
  80106f:	83 c4 08             	add    $0x8,%esp
  801072:	85 c0                	test   %eax,%eax
  801074:	78 10                	js     801086 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801076:	83 ec 08             	sub    $0x8,%esp
  801079:	6a 01                	push   $0x1
  80107b:	ff 75 f4             	pushl  -0xc(%ebp)
  80107e:	e8 51 ff ff ff       	call   800fd4 <fd_close>
  801083:	83 c4 10             	add    $0x10,%esp
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <close_all>:

void
close_all(void)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	53                   	push   %ebx
  80108c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80108f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	53                   	push   %ebx
  801098:	e8 c0 ff ff ff       	call   80105d <close>
	for (i = 0; i < MAXFD; i++)
  80109d:	83 c3 01             	add    $0x1,%ebx
  8010a0:	83 c4 10             	add    $0x10,%esp
  8010a3:	83 fb 20             	cmp    $0x20,%ebx
  8010a6:	75 ec                	jne    801094 <close_all+0xc>
}
  8010a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010b9:	50                   	push   %eax
  8010ba:	ff 75 08             	pushl  0x8(%ebp)
  8010bd:	e8 66 fe ff ff       	call   800f28 <fd_lookup>
  8010c2:	89 c3                	mov    %eax,%ebx
  8010c4:	83 c4 08             	add    $0x8,%esp
  8010c7:	85 c0                	test   %eax,%eax
  8010c9:	0f 88 81 00 00 00    	js     801150 <dup+0xa3>
		return r;
	close(newfdnum);
  8010cf:	83 ec 0c             	sub    $0xc,%esp
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 83 ff ff ff       	call   80105d <close>

	newfd = INDEX2FD(newfdnum);
  8010da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010dd:	c1 e6 0c             	shl    $0xc,%esi
  8010e0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010e6:	83 c4 04             	add    $0x4,%esp
  8010e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ec:	e8 d1 fd ff ff       	call   800ec2 <fd2data>
  8010f1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010f3:	89 34 24             	mov    %esi,(%esp)
  8010f6:	e8 c7 fd ff ff       	call   800ec2 <fd2data>
  8010fb:	83 c4 10             	add    $0x10,%esp
  8010fe:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801100:	89 d8                	mov    %ebx,%eax
  801102:	c1 e8 16             	shr    $0x16,%eax
  801105:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80110c:	a8 01                	test   $0x1,%al
  80110e:	74 11                	je     801121 <dup+0x74>
  801110:	89 d8                	mov    %ebx,%eax
  801112:	c1 e8 0c             	shr    $0xc,%eax
  801115:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80111c:	f6 c2 01             	test   $0x1,%dl
  80111f:	75 39                	jne    80115a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801121:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	c1 e8 0c             	shr    $0xc,%eax
  801129:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	25 07 0e 00 00       	and    $0xe07,%eax
  801138:	50                   	push   %eax
  801139:	56                   	push   %esi
  80113a:	6a 00                	push   $0x0
  80113c:	52                   	push   %edx
  80113d:	6a 00                	push   $0x0
  80113f:	e8 ad fa ff ff       	call   800bf1 <sys_page_map>
  801144:	89 c3                	mov    %eax,%ebx
  801146:	83 c4 20             	add    $0x20,%esp
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 31                	js     80117e <dup+0xd1>
		goto err;

	return newfdnum;
  80114d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801150:	89 d8                	mov    %ebx,%eax
  801152:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801155:	5b                   	pop    %ebx
  801156:	5e                   	pop    %esi
  801157:	5f                   	pop    %edi
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80115a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	25 07 0e 00 00       	and    $0xe07,%eax
  801169:	50                   	push   %eax
  80116a:	57                   	push   %edi
  80116b:	6a 00                	push   $0x0
  80116d:	53                   	push   %ebx
  80116e:	6a 00                	push   $0x0
  801170:	e8 7c fa ff ff       	call   800bf1 <sys_page_map>
  801175:	89 c3                	mov    %eax,%ebx
  801177:	83 c4 20             	add    $0x20,%esp
  80117a:	85 c0                	test   %eax,%eax
  80117c:	79 a3                	jns    801121 <dup+0x74>
	sys_page_unmap(0, newfd);
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	56                   	push   %esi
  801182:	6a 00                	push   $0x0
  801184:	e8 aa fa ff ff       	call   800c33 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801189:	83 c4 08             	add    $0x8,%esp
  80118c:	57                   	push   %edi
  80118d:	6a 00                	push   $0x0
  80118f:	e8 9f fa ff ff       	call   800c33 <sys_page_unmap>
	return r;
  801194:	83 c4 10             	add    $0x10,%esp
  801197:	eb b7                	jmp    801150 <dup+0xa3>

00801199 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	53                   	push   %ebx
  80119d:	83 ec 14             	sub    $0x14,%esp
  8011a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	53                   	push   %ebx
  8011a8:	e8 7b fd ff ff       	call   800f28 <fd_lookup>
  8011ad:	83 c4 08             	add    $0x8,%esp
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 3f                	js     8011f3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011b4:	83 ec 08             	sub    $0x8,%esp
  8011b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ba:	50                   	push   %eax
  8011bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011be:	ff 30                	pushl  (%eax)
  8011c0:	e8 b9 fd ff ff       	call   800f7e <dev_lookup>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	78 27                	js     8011f3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011cf:	8b 42 08             	mov    0x8(%edx),%eax
  8011d2:	83 e0 03             	and    $0x3,%eax
  8011d5:	83 f8 01             	cmp    $0x1,%eax
  8011d8:	74 1e                	je     8011f8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011dd:	8b 40 08             	mov    0x8(%eax),%eax
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	74 35                	je     801219 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	ff 75 10             	pushl  0x10(%ebp)
  8011ea:	ff 75 0c             	pushl  0xc(%ebp)
  8011ed:	52                   	push   %edx
  8011ee:	ff d0                	call   *%eax
  8011f0:	83 c4 10             	add    $0x10,%esp
}
  8011f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011f8:	a1 08 40 80 00       	mov    0x804008,%eax
  8011fd:	8b 40 48             	mov    0x48(%eax),%eax
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	53                   	push   %ebx
  801204:	50                   	push   %eax
  801205:	68 69 26 80 00       	push   $0x802669
  80120a:	e8 87 ef ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801217:	eb da                	jmp    8011f3 <read+0x5a>
		return -E_NOT_SUPP;
  801219:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80121e:	eb d3                	jmp    8011f3 <read+0x5a>

00801220 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	57                   	push   %edi
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	83 ec 0c             	sub    $0xc,%esp
  801229:	8b 7d 08             	mov    0x8(%ebp),%edi
  80122c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80122f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801234:	39 f3                	cmp    %esi,%ebx
  801236:	73 25                	jae    80125d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801238:	83 ec 04             	sub    $0x4,%esp
  80123b:	89 f0                	mov    %esi,%eax
  80123d:	29 d8                	sub    %ebx,%eax
  80123f:	50                   	push   %eax
  801240:	89 d8                	mov    %ebx,%eax
  801242:	03 45 0c             	add    0xc(%ebp),%eax
  801245:	50                   	push   %eax
  801246:	57                   	push   %edi
  801247:	e8 4d ff ff ff       	call   801199 <read>
		if (m < 0)
  80124c:	83 c4 10             	add    $0x10,%esp
  80124f:	85 c0                	test   %eax,%eax
  801251:	78 08                	js     80125b <readn+0x3b>
			return m;
		if (m == 0)
  801253:	85 c0                	test   %eax,%eax
  801255:	74 06                	je     80125d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801257:	01 c3                	add    %eax,%ebx
  801259:	eb d9                	jmp    801234 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80125b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80125d:	89 d8                	mov    %ebx,%eax
  80125f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801262:	5b                   	pop    %ebx
  801263:	5e                   	pop    %esi
  801264:	5f                   	pop    %edi
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	53                   	push   %ebx
  80126b:	83 ec 14             	sub    $0x14,%esp
  80126e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801271:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801274:	50                   	push   %eax
  801275:	53                   	push   %ebx
  801276:	e8 ad fc ff ff       	call   800f28 <fd_lookup>
  80127b:	83 c4 08             	add    $0x8,%esp
  80127e:	85 c0                	test   %eax,%eax
  801280:	78 3a                	js     8012bc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801282:	83 ec 08             	sub    $0x8,%esp
  801285:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801288:	50                   	push   %eax
  801289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128c:	ff 30                	pushl  (%eax)
  80128e:	e8 eb fc ff ff       	call   800f7e <dev_lookup>
  801293:	83 c4 10             	add    $0x10,%esp
  801296:	85 c0                	test   %eax,%eax
  801298:	78 22                	js     8012bc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80129a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80129d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a1:	74 1e                	je     8012c1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 52 0c             	mov    0xc(%edx),%edx
  8012a9:	85 d2                	test   %edx,%edx
  8012ab:	74 35                	je     8012e2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012ad:	83 ec 04             	sub    $0x4,%esp
  8012b0:	ff 75 10             	pushl  0x10(%ebp)
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	ff d2                	call   *%edx
  8012b9:	83 c4 10             	add    $0x10,%esp
}
  8012bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8012c6:	8b 40 48             	mov    0x48(%eax),%eax
  8012c9:	83 ec 04             	sub    $0x4,%esp
  8012cc:	53                   	push   %ebx
  8012cd:	50                   	push   %eax
  8012ce:	68 85 26 80 00       	push   $0x802685
  8012d3:	e8 be ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e0:	eb da                	jmp    8012bc <write+0x55>
		return -E_NOT_SUPP;
  8012e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012e7:	eb d3                	jmp    8012bc <write+0x55>

008012e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012f2:	50                   	push   %eax
  8012f3:	ff 75 08             	pushl  0x8(%ebp)
  8012f6:	e8 2d fc ff ff       	call   800f28 <fd_lookup>
  8012fb:	83 c4 08             	add    $0x8,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	78 0e                	js     801310 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801302:	8b 55 0c             	mov    0xc(%ebp),%edx
  801305:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801308:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80130b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	53                   	push   %ebx
  801316:	83 ec 14             	sub    $0x14,%esp
  801319:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80131c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131f:	50                   	push   %eax
  801320:	53                   	push   %ebx
  801321:	e8 02 fc ff ff       	call   800f28 <fd_lookup>
  801326:	83 c4 08             	add    $0x8,%esp
  801329:	85 c0                	test   %eax,%eax
  80132b:	78 37                	js     801364 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801333:	50                   	push   %eax
  801334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801337:	ff 30                	pushl  (%eax)
  801339:	e8 40 fc ff ff       	call   800f7e <dev_lookup>
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	78 1f                	js     801364 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801348:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80134c:	74 1b                	je     801369 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80134e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801351:	8b 52 18             	mov    0x18(%edx),%edx
  801354:	85 d2                	test   %edx,%edx
  801356:	74 32                	je     80138a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801358:	83 ec 08             	sub    $0x8,%esp
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	50                   	push   %eax
  80135f:	ff d2                	call   *%edx
  801361:	83 c4 10             	add    $0x10,%esp
}
  801364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801367:	c9                   	leave  
  801368:	c3                   	ret    
			thisenv->env_id, fdnum);
  801369:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80136e:	8b 40 48             	mov    0x48(%eax),%eax
  801371:	83 ec 04             	sub    $0x4,%esp
  801374:	53                   	push   %ebx
  801375:	50                   	push   %eax
  801376:	68 48 26 80 00       	push   $0x802648
  80137b:	e8 16 ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801388:	eb da                	jmp    801364 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80138a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80138f:	eb d3                	jmp    801364 <ftruncate+0x52>

00801391 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	53                   	push   %ebx
  801395:	83 ec 14             	sub    $0x14,%esp
  801398:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139e:	50                   	push   %eax
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 81 fb ff ff       	call   800f28 <fd_lookup>
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	78 4b                	js     8013f9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ae:	83 ec 08             	sub    $0x8,%esp
  8013b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b8:	ff 30                	pushl  (%eax)
  8013ba:	e8 bf fb ff ff       	call   800f7e <dev_lookup>
  8013bf:	83 c4 10             	add    $0x10,%esp
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	78 33                	js     8013f9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013cd:	74 2f                	je     8013fe <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013cf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013d2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013d9:	00 00 00 
	stat->st_isdir = 0;
  8013dc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013e3:	00 00 00 
	stat->st_dev = dev;
  8013e6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013ec:	83 ec 08             	sub    $0x8,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8013f3:	ff 50 14             	call   *0x14(%eax)
  8013f6:	83 c4 10             	add    $0x10,%esp
}
  8013f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    
		return -E_NOT_SUPP;
  8013fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801403:	eb f4                	jmp    8013f9 <fstat+0x68>

00801405 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	6a 00                	push   $0x0
  80140f:	ff 75 08             	pushl  0x8(%ebp)
  801412:	e8 e7 01 00 00       	call   8015fe <open>
  801417:	89 c3                	mov    %eax,%ebx
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 1b                	js     80143b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801420:	83 ec 08             	sub    $0x8,%esp
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	50                   	push   %eax
  801427:	e8 65 ff ff ff       	call   801391 <fstat>
  80142c:	89 c6                	mov    %eax,%esi
	close(fd);
  80142e:	89 1c 24             	mov    %ebx,(%esp)
  801431:	e8 27 fc ff ff       	call   80105d <close>
	return r;
  801436:	83 c4 10             	add    $0x10,%esp
  801439:	89 f3                	mov    %esi,%ebx
}
  80143b:	89 d8                	mov    %ebx,%eax
  80143d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801440:	5b                   	pop    %ebx
  801441:	5e                   	pop    %esi
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	89 c6                	mov    %eax,%esi
  80144b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80144d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801454:	74 27                	je     80147d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801456:	6a 07                	push   $0x7
  801458:	68 00 50 80 00       	push   $0x805000
  80145d:	56                   	push   %esi
  80145e:	ff 35 00 40 80 00    	pushl  0x804000
  801464:	e8 bc f9 ff ff       	call   800e25 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801469:	83 c4 0c             	add    $0xc,%esp
  80146c:	6a 00                	push   $0x0
  80146e:	53                   	push   %ebx
  80146f:	6a 00                	push   $0x0
  801471:	e8 48 f9 ff ff       	call   800dbe <ipc_recv>
}
  801476:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801479:	5b                   	pop    %ebx
  80147a:	5e                   	pop    %esi
  80147b:	5d                   	pop    %ebp
  80147c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80147d:	83 ec 0c             	sub    $0xc,%esp
  801480:	6a 01                	push   $0x1
  801482:	e8 f2 f9 ff ff       	call   800e79 <ipc_find_env>
  801487:	a3 00 40 80 00       	mov    %eax,0x804000
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	eb c5                	jmp    801456 <fsipc+0x12>

00801491 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8b 40 0c             	mov    0xc(%eax),%eax
  80149d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014af:	b8 02 00 00 00       	mov    $0x2,%eax
  8014b4:	e8 8b ff ff ff       	call   801444 <fsipc>
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <devfile_flush>:
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014c7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8014d6:	e8 69 ff ff ff       	call   801444 <fsipc>
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <devfile_stat>:
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	53                   	push   %ebx
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ed:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8014fc:	e8 43 ff ff ff       	call   801444 <fsipc>
  801501:	85 c0                	test   %eax,%eax
  801503:	78 2c                	js     801531 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	68 00 50 80 00       	push   $0x805000
  80150d:	53                   	push   %ebx
  80150e:	e8 a2 f2 ff ff       	call   8007b5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801513:	a1 80 50 80 00       	mov    0x805080,%eax
  801518:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80151e:	a1 84 50 80 00       	mov    0x805084,%eax
  801523:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <devfile_write>:
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	8b 45 10             	mov    0x10(%ebp),%eax
  80153f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801544:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801549:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80154c:	8b 55 08             	mov    0x8(%ebp),%edx
  80154f:	8b 52 0c             	mov    0xc(%edx),%edx
  801552:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801558:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80155d:	50                   	push   %eax
  80155e:	ff 75 0c             	pushl  0xc(%ebp)
  801561:	68 08 50 80 00       	push   $0x805008
  801566:	e8 d8 f3 ff ff       	call   800943 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80156b:	ba 00 00 00 00       	mov    $0x0,%edx
  801570:	b8 04 00 00 00       	mov    $0x4,%eax
  801575:	e8 ca fe ff ff       	call   801444 <fsipc>
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <devfile_read>:
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	56                   	push   %esi
  801580:	53                   	push   %ebx
  801581:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	8b 40 0c             	mov    0xc(%eax),%eax
  80158a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80158f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801595:	ba 00 00 00 00       	mov    $0x0,%edx
  80159a:	b8 03 00 00 00       	mov    $0x3,%eax
  80159f:	e8 a0 fe ff ff       	call   801444 <fsipc>
  8015a4:	89 c3                	mov    %eax,%ebx
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	78 1f                	js     8015c9 <devfile_read+0x4d>
	assert(r <= n);
  8015aa:	39 f0                	cmp    %esi,%eax
  8015ac:	77 24                	ja     8015d2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015ae:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015b3:	7f 33                	jg     8015e8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015b5:	83 ec 04             	sub    $0x4,%esp
  8015b8:	50                   	push   %eax
  8015b9:	68 00 50 80 00       	push   $0x805000
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	e8 7d f3 ff ff       	call   800943 <memmove>
	return r;
  8015c6:	83 c4 10             	add    $0x10,%esp
}
  8015c9:	89 d8                	mov    %ebx,%eax
  8015cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ce:	5b                   	pop    %ebx
  8015cf:	5e                   	pop    %esi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    
	assert(r <= n);
  8015d2:	68 b8 26 80 00       	push   $0x8026b8
  8015d7:	68 bf 26 80 00       	push   $0x8026bf
  8015dc:	6a 7b                	push   $0x7b
  8015de:	68 d4 26 80 00       	push   $0x8026d4
  8015e3:	e8 ea 09 00 00       	call   801fd2 <_panic>
	assert(r <= PGSIZE);
  8015e8:	68 df 26 80 00       	push   $0x8026df
  8015ed:	68 bf 26 80 00       	push   $0x8026bf
  8015f2:	6a 7c                	push   $0x7c
  8015f4:	68 d4 26 80 00       	push   $0x8026d4
  8015f9:	e8 d4 09 00 00       	call   801fd2 <_panic>

008015fe <open>:
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	56                   	push   %esi
  801602:	53                   	push   %ebx
  801603:	83 ec 1c             	sub    $0x1c,%esp
  801606:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801609:	56                   	push   %esi
  80160a:	e8 6f f1 ff ff       	call   80077e <strlen>
  80160f:	83 c4 10             	add    $0x10,%esp
  801612:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801617:	7f 6c                	jg     801685 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801619:	83 ec 0c             	sub    $0xc,%esp
  80161c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161f:	50                   	push   %eax
  801620:	e8 b4 f8 ff ff       	call   800ed9 <fd_alloc>
  801625:	89 c3                	mov    %eax,%ebx
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	85 c0                	test   %eax,%eax
  80162c:	78 3c                	js     80166a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	56                   	push   %esi
  801632:	68 00 50 80 00       	push   $0x805000
  801637:	e8 79 f1 ff ff       	call   8007b5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	b8 01 00 00 00       	mov    $0x1,%eax
  80164c:	e8 f3 fd ff ff       	call   801444 <fsipc>
  801651:	89 c3                	mov    %eax,%ebx
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	85 c0                	test   %eax,%eax
  801658:	78 19                	js     801673 <open+0x75>
	return fd2num(fd);
  80165a:	83 ec 0c             	sub    $0xc,%esp
  80165d:	ff 75 f4             	pushl  -0xc(%ebp)
  801660:	e8 4d f8 ff ff       	call   800eb2 <fd2num>
  801665:	89 c3                	mov    %eax,%ebx
  801667:	83 c4 10             	add    $0x10,%esp
}
  80166a:	89 d8                	mov    %ebx,%eax
  80166c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    
		fd_close(fd, 0);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	6a 00                	push   $0x0
  801678:	ff 75 f4             	pushl  -0xc(%ebp)
  80167b:	e8 54 f9 ff ff       	call   800fd4 <fd_close>
		return r;
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	eb e5                	jmp    80166a <open+0x6c>
		return -E_BAD_PATH;
  801685:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80168a:	eb de                	jmp    80166a <open+0x6c>

0080168c <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801692:	ba 00 00 00 00       	mov    $0x0,%edx
  801697:	b8 08 00 00 00       	mov    $0x8,%eax
  80169c:	e8 a3 fd ff ff       	call   801444 <fsipc>
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8016a9:	68 eb 26 80 00       	push   $0x8026eb
  8016ae:	ff 75 0c             	pushl  0xc(%ebp)
  8016b1:	e8 ff f0 ff ff       	call   8007b5 <strcpy>
	return 0;
}
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <devsock_close>:
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	53                   	push   %ebx
  8016c1:	83 ec 10             	sub    $0x10,%esp
  8016c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016c7:	53                   	push   %ebx
  8016c8:	e8 4b 09 00 00       	call   802018 <pageref>
  8016cd:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016d0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8016d5:	83 f8 01             	cmp    $0x1,%eax
  8016d8:	74 07                	je     8016e1 <devsock_close+0x24>
}
  8016da:	89 d0                	mov    %edx,%eax
  8016dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	ff 73 0c             	pushl  0xc(%ebx)
  8016e7:	e8 b7 02 00 00       	call   8019a3 <nsipc_close>
  8016ec:	89 c2                	mov    %eax,%edx
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	eb e7                	jmp    8016da <devsock_close+0x1d>

008016f3 <devsock_write>:
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	ff 75 10             	pushl  0x10(%ebp)
  8016fe:	ff 75 0c             	pushl  0xc(%ebp)
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	ff 70 0c             	pushl  0xc(%eax)
  801707:	e8 74 03 00 00       	call   801a80 <nsipc_send>
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <devsock_read>:
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801714:	6a 00                	push   $0x0
  801716:	ff 75 10             	pushl  0x10(%ebp)
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	ff 70 0c             	pushl  0xc(%eax)
  801722:	e8 ed 02 00 00       	call   801a14 <nsipc_recv>
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <fd2sockid>:
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80172f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801732:	52                   	push   %edx
  801733:	50                   	push   %eax
  801734:	e8 ef f7 ff ff       	call   800f28 <fd_lookup>
  801739:	83 c4 10             	add    $0x10,%esp
  80173c:	85 c0                	test   %eax,%eax
  80173e:	78 10                	js     801750 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801743:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801749:	39 08                	cmp    %ecx,(%eax)
  80174b:	75 05                	jne    801752 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80174d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    
		return -E_NOT_SUPP;
  801752:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801757:	eb f7                	jmp    801750 <fd2sockid+0x27>

00801759 <alloc_sockfd>:
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	56                   	push   %esi
  80175d:	53                   	push   %ebx
  80175e:	83 ec 1c             	sub    $0x1c,%esp
  801761:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	e8 6d f7 ff ff       	call   800ed9 <fd_alloc>
  80176c:	89 c3                	mov    %eax,%ebx
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 43                	js     8017b8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	68 07 04 00 00       	push   $0x407
  80177d:	ff 75 f4             	pushl  -0xc(%ebp)
  801780:	6a 00                	push   $0x0
  801782:	e8 27 f4 ff ff       	call   800bae <sys_page_alloc>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 28                	js     8017b8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801793:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801799:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8017a5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	50                   	push   %eax
  8017ac:	e8 01 f7 ff ff       	call   800eb2 <fd2num>
  8017b1:	89 c3                	mov    %eax,%ebx
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	eb 0c                	jmp    8017c4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	56                   	push   %esi
  8017bc:	e8 e2 01 00 00       	call   8019a3 <nsipc_close>
		return r;
  8017c1:	83 c4 10             	add    $0x10,%esp
}
  8017c4:	89 d8                	mov    %ebx,%eax
  8017c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5d                   	pop    %ebp
  8017cc:	c3                   	ret    

008017cd <accept>:
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
  8017d0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	e8 4e ff ff ff       	call   801729 <fd2sockid>
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 1b                	js     8017fa <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	ff 75 10             	pushl  0x10(%ebp)
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	50                   	push   %eax
  8017e9:	e8 0e 01 00 00       	call   8018fc <nsipc_accept>
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	78 05                	js     8017fa <accept+0x2d>
	return alloc_sockfd(r);
  8017f5:	e8 5f ff ff ff       	call   801759 <alloc_sockfd>
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <bind>:
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	e8 1f ff ff ff       	call   801729 <fd2sockid>
  80180a:	85 c0                	test   %eax,%eax
  80180c:	78 12                	js     801820 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	ff 75 10             	pushl  0x10(%ebp)
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	50                   	push   %eax
  801818:	e8 2f 01 00 00       	call   80194c <nsipc_bind>
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <shutdown>:
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	e8 f9 fe ff ff       	call   801729 <fd2sockid>
  801830:	85 c0                	test   %eax,%eax
  801832:	78 0f                	js     801843 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801834:	83 ec 08             	sub    $0x8,%esp
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	50                   	push   %eax
  80183b:	e8 41 01 00 00       	call   801981 <nsipc_shutdown>
  801840:	83 c4 10             	add    $0x10,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <connect>:
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	e8 d6 fe ff ff       	call   801729 <fd2sockid>
  801853:	85 c0                	test   %eax,%eax
  801855:	78 12                	js     801869 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	e8 57 01 00 00       	call   8019bd <nsipc_connect>
  801866:	83 c4 10             	add    $0x10,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <listen>:
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	e8 b0 fe ff ff       	call   801729 <fd2sockid>
  801879:	85 c0                	test   %eax,%eax
  80187b:	78 0f                	js     80188c <listen+0x21>
	return nsipc_listen(r, backlog);
  80187d:	83 ec 08             	sub    $0x8,%esp
  801880:	ff 75 0c             	pushl  0xc(%ebp)
  801883:	50                   	push   %eax
  801884:	e8 69 01 00 00       	call   8019f2 <nsipc_listen>
  801889:	83 c4 10             	add    $0x10,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <socket>:

int
socket(int domain, int type, int protocol)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801894:	ff 75 10             	pushl  0x10(%ebp)
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	ff 75 08             	pushl  0x8(%ebp)
  80189d:	e8 3c 02 00 00       	call   801ade <nsipc_socket>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 05                	js     8018ae <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8018a9:	e8 ab fe ff ff       	call   801759 <alloc_sockfd>
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018b9:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8018c0:	74 26                	je     8018e8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8018c2:	6a 07                	push   $0x7
  8018c4:	68 00 60 80 00       	push   $0x806000
  8018c9:	53                   	push   %ebx
  8018ca:	ff 35 04 40 80 00    	pushl  0x804004
  8018d0:	e8 50 f5 ff ff       	call   800e25 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8018d5:	83 c4 0c             	add    $0xc,%esp
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	e8 db f4 ff ff       	call   800dbe <ipc_recv>
}
  8018e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018e8:	83 ec 0c             	sub    $0xc,%esp
  8018eb:	6a 02                	push   $0x2
  8018ed:	e8 87 f5 ff ff       	call   800e79 <ipc_find_env>
  8018f2:	a3 04 40 80 00       	mov    %eax,0x804004
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	eb c6                	jmp    8018c2 <nsipc+0x12>

008018fc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
  801901:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80190c:	8b 06                	mov    (%esi),%eax
  80190e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801913:	b8 01 00 00 00       	mov    $0x1,%eax
  801918:	e8 93 ff ff ff       	call   8018b0 <nsipc>
  80191d:	89 c3                	mov    %eax,%ebx
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 20                	js     801943 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	ff 35 10 60 80 00    	pushl  0x806010
  80192c:	68 00 60 80 00       	push   $0x806000
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	e8 0a f0 ff ff       	call   800943 <memmove>
		*addrlen = ret->ret_addrlen;
  801939:	a1 10 60 80 00       	mov    0x806010,%eax
  80193e:	89 06                	mov    %eax,(%esi)
  801940:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801943:	89 d8                	mov    %ebx,%eax
  801945:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801948:	5b                   	pop    %ebx
  801949:	5e                   	pop    %esi
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	53                   	push   %ebx
  801950:	83 ec 08             	sub    $0x8,%esp
  801953:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80195e:	53                   	push   %ebx
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	68 04 60 80 00       	push   $0x806004
  801967:	e8 d7 ef ff ff       	call   800943 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80196c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801972:	b8 02 00 00 00       	mov    $0x2,%eax
  801977:	e8 34 ff ff ff       	call   8018b0 <nsipc>
}
  80197c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80198f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801992:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801997:	b8 03 00 00 00       	mov    $0x3,%eax
  80199c:	e8 0f ff ff ff       	call   8018b0 <nsipc>
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <nsipc_close>:

int
nsipc_close(int s)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8019b1:	b8 04 00 00 00       	mov    $0x4,%eax
  8019b6:	e8 f5 fe ff ff       	call   8018b0 <nsipc>
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	53                   	push   %ebx
  8019c1:	83 ec 08             	sub    $0x8,%esp
  8019c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019cf:	53                   	push   %ebx
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	68 04 60 80 00       	push   $0x806004
  8019d8:	e8 66 ef ff ff       	call   800943 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019dd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019e3:	b8 05 00 00 00       	mov    $0x5,%eax
  8019e8:	e8 c3 fe ff ff       	call   8018b0 <nsipc>
}
  8019ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
  8019f5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a03:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801a08:	b8 06 00 00 00       	mov    $0x6,%eax
  801a0d:	e8 9e fe ff ff       	call   8018b0 <nsipc>
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a24:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a32:	b8 07 00 00 00       	mov    $0x7,%eax
  801a37:	e8 74 fe ff ff       	call   8018b0 <nsipc>
  801a3c:	89 c3                	mov    %eax,%ebx
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 1f                	js     801a61 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801a42:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801a47:	7f 21                	jg     801a6a <nsipc_recv+0x56>
  801a49:	39 c6                	cmp    %eax,%esi
  801a4b:	7c 1d                	jl     801a6a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	50                   	push   %eax
  801a51:	68 00 60 80 00       	push   $0x806000
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	e8 e5 ee ff ff       	call   800943 <memmove>
  801a5e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a61:	89 d8                	mov    %ebx,%eax
  801a63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a6a:	68 f7 26 80 00       	push   $0x8026f7
  801a6f:	68 bf 26 80 00       	push   $0x8026bf
  801a74:	6a 62                	push   $0x62
  801a76:	68 0c 27 80 00       	push   $0x80270c
  801a7b:	e8 52 05 00 00       	call   801fd2 <_panic>

00801a80 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	53                   	push   %ebx
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a92:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a98:	7f 2e                	jg     801ac8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	53                   	push   %ebx
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	68 0c 60 80 00       	push   $0x80600c
  801aa6:	e8 98 ee ff ff       	call   800943 <memmove>
	nsipcbuf.send.req_size = size;
  801aab:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ab9:	b8 08 00 00 00       	mov    $0x8,%eax
  801abe:	e8 ed fd ff ff       	call   8018b0 <nsipc>
}
  801ac3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    
	assert(size < 1600);
  801ac8:	68 18 27 80 00       	push   $0x802718
  801acd:	68 bf 26 80 00       	push   $0x8026bf
  801ad2:	6a 6d                	push   $0x6d
  801ad4:	68 0c 27 80 00       	push   $0x80270c
  801ad9:	e8 f4 04 00 00       	call   801fd2 <_panic>

00801ade <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aef:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801af4:	8b 45 10             	mov    0x10(%ebp),%eax
  801af7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801afc:	b8 09 00 00 00       	mov    $0x9,%eax
  801b01:	e8 aa fd ff ff       	call   8018b0 <nsipc>
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b10:	83 ec 0c             	sub    $0xc,%esp
  801b13:	ff 75 08             	pushl  0x8(%ebp)
  801b16:	e8 a7 f3 ff ff       	call   800ec2 <fd2data>
  801b1b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b1d:	83 c4 08             	add    $0x8,%esp
  801b20:	68 24 27 80 00       	push   $0x802724
  801b25:	53                   	push   %ebx
  801b26:	e8 8a ec ff ff       	call   8007b5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b2b:	8b 46 04             	mov    0x4(%esi),%eax
  801b2e:	2b 06                	sub    (%esi),%eax
  801b30:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b3d:	00 00 00 
	stat->st_dev = &devpipe;
  801b40:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b47:	30 80 00 
	return 0;
}
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b52:	5b                   	pop    %ebx
  801b53:	5e                   	pop    %esi
  801b54:	5d                   	pop    %ebp
  801b55:	c3                   	ret    

00801b56 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b60:	53                   	push   %ebx
  801b61:	6a 00                	push   $0x0
  801b63:	e8 cb f0 ff ff       	call   800c33 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b68:	89 1c 24             	mov    %ebx,(%esp)
  801b6b:	e8 52 f3 ff ff       	call   800ec2 <fd2data>
  801b70:	83 c4 08             	add    $0x8,%esp
  801b73:	50                   	push   %eax
  801b74:	6a 00                	push   $0x0
  801b76:	e8 b8 f0 ff ff       	call   800c33 <sys_page_unmap>
}
  801b7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <_pipeisclosed>:
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	57                   	push   %edi
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
  801b86:	83 ec 1c             	sub    $0x1c,%esp
  801b89:	89 c7                	mov    %eax,%edi
  801b8b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b8d:	a1 08 40 80 00       	mov    0x804008,%eax
  801b92:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	57                   	push   %edi
  801b99:	e8 7a 04 00 00       	call   802018 <pageref>
  801b9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ba1:	89 34 24             	mov    %esi,(%esp)
  801ba4:	e8 6f 04 00 00       	call   802018 <pageref>
		nn = thisenv->env_runs;
  801ba9:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801baf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	39 cb                	cmp    %ecx,%ebx
  801bb7:	74 1b                	je     801bd4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801bb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbc:	75 cf                	jne    801b8d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801bbe:	8b 42 58             	mov    0x58(%edx),%eax
  801bc1:	6a 01                	push   $0x1
  801bc3:	50                   	push   %eax
  801bc4:	53                   	push   %ebx
  801bc5:	68 2b 27 80 00       	push   $0x80272b
  801bca:	e8 c7 e5 ff ff       	call   800196 <cprintf>
  801bcf:	83 c4 10             	add    $0x10,%esp
  801bd2:	eb b9                	jmp    801b8d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bd4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bd7:	0f 94 c0             	sete   %al
  801bda:	0f b6 c0             	movzbl %al,%eax
}
  801bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <devpipe_write>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	57                   	push   %edi
  801be9:	56                   	push   %esi
  801bea:	53                   	push   %ebx
  801beb:	83 ec 28             	sub    $0x28,%esp
  801bee:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bf1:	56                   	push   %esi
  801bf2:	e8 cb f2 ff ff       	call   800ec2 <fd2data>
  801bf7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bf9:	83 c4 10             	add    $0x10,%esp
  801bfc:	bf 00 00 00 00       	mov    $0x0,%edi
  801c01:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801c04:	74 4f                	je     801c55 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801c06:	8b 43 04             	mov    0x4(%ebx),%eax
  801c09:	8b 0b                	mov    (%ebx),%ecx
  801c0b:	8d 51 20             	lea    0x20(%ecx),%edx
  801c0e:	39 d0                	cmp    %edx,%eax
  801c10:	72 14                	jb     801c26 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c12:	89 da                	mov    %ebx,%edx
  801c14:	89 f0                	mov    %esi,%eax
  801c16:	e8 65 ff ff ff       	call   801b80 <_pipeisclosed>
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	75 3a                	jne    801c59 <devpipe_write+0x74>
			sys_yield();
  801c1f:	e8 6b ef ff ff       	call   800b8f <sys_yield>
  801c24:	eb e0                	jmp    801c06 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c29:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c2d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	c1 fa 1f             	sar    $0x1f,%edx
  801c35:	89 d1                	mov    %edx,%ecx
  801c37:	c1 e9 1b             	shr    $0x1b,%ecx
  801c3a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c3d:	83 e2 1f             	and    $0x1f,%edx
  801c40:	29 ca                	sub    %ecx,%edx
  801c42:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c46:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c4a:	83 c0 01             	add    $0x1,%eax
  801c4d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c50:	83 c7 01             	add    $0x1,%edi
  801c53:	eb ac                	jmp    801c01 <devpipe_write+0x1c>
	return i;
  801c55:	89 f8                	mov    %edi,%eax
  801c57:	eb 05                	jmp    801c5e <devpipe_write+0x79>
				return 0;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c61:	5b                   	pop    %ebx
  801c62:	5e                   	pop    %esi
  801c63:	5f                   	pop    %edi
  801c64:	5d                   	pop    %ebp
  801c65:	c3                   	ret    

00801c66 <devpipe_read>:
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	57                   	push   %edi
  801c6a:	56                   	push   %esi
  801c6b:	53                   	push   %ebx
  801c6c:	83 ec 18             	sub    $0x18,%esp
  801c6f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c72:	57                   	push   %edi
  801c73:	e8 4a f2 ff ff       	call   800ec2 <fd2data>
  801c78:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c7a:	83 c4 10             	add    $0x10,%esp
  801c7d:	be 00 00 00 00       	mov    $0x0,%esi
  801c82:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c85:	74 47                	je     801cce <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c87:	8b 03                	mov    (%ebx),%eax
  801c89:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c8c:	75 22                	jne    801cb0 <devpipe_read+0x4a>
			if (i > 0)
  801c8e:	85 f6                	test   %esi,%esi
  801c90:	75 14                	jne    801ca6 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c92:	89 da                	mov    %ebx,%edx
  801c94:	89 f8                	mov    %edi,%eax
  801c96:	e8 e5 fe ff ff       	call   801b80 <_pipeisclosed>
  801c9b:	85 c0                	test   %eax,%eax
  801c9d:	75 33                	jne    801cd2 <devpipe_read+0x6c>
			sys_yield();
  801c9f:	e8 eb ee ff ff       	call   800b8f <sys_yield>
  801ca4:	eb e1                	jmp    801c87 <devpipe_read+0x21>
				return i;
  801ca6:	89 f0                	mov    %esi,%eax
}
  801ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5e                   	pop    %esi
  801cad:	5f                   	pop    %edi
  801cae:	5d                   	pop    %ebp
  801caf:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801cb0:	99                   	cltd   
  801cb1:	c1 ea 1b             	shr    $0x1b,%edx
  801cb4:	01 d0                	add    %edx,%eax
  801cb6:	83 e0 1f             	and    $0x1f,%eax
  801cb9:	29 d0                	sub    %edx,%eax
  801cbb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cc3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cc6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cc9:	83 c6 01             	add    $0x1,%esi
  801ccc:	eb b4                	jmp    801c82 <devpipe_read+0x1c>
	return i;
  801cce:	89 f0                	mov    %esi,%eax
  801cd0:	eb d6                	jmp    801ca8 <devpipe_read+0x42>
				return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd7:	eb cf                	jmp    801ca8 <devpipe_read+0x42>

00801cd9 <pipe>:
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ce1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce4:	50                   	push   %eax
  801ce5:	e8 ef f1 ff ff       	call   800ed9 <fd_alloc>
  801cea:	89 c3                	mov    %eax,%ebx
  801cec:	83 c4 10             	add    $0x10,%esp
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 5b                	js     801d4e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	68 07 04 00 00       	push   $0x407
  801cfb:	ff 75 f4             	pushl  -0xc(%ebp)
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 a9 ee ff ff       	call   800bae <sys_page_alloc>
  801d05:	89 c3                	mov    %eax,%ebx
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 40                	js     801d4e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d14:	50                   	push   %eax
  801d15:	e8 bf f1 ff ff       	call   800ed9 <fd_alloc>
  801d1a:	89 c3                	mov    %eax,%ebx
  801d1c:	83 c4 10             	add    $0x10,%esp
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 1b                	js     801d3e <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	68 07 04 00 00       	push   $0x407
  801d2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2e:	6a 00                	push   $0x0
  801d30:	e8 79 ee ff ff       	call   800bae <sys_page_alloc>
  801d35:	89 c3                	mov    %eax,%ebx
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	79 19                	jns    801d57 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d3e:	83 ec 08             	sub    $0x8,%esp
  801d41:	ff 75 f4             	pushl  -0xc(%ebp)
  801d44:	6a 00                	push   $0x0
  801d46:	e8 e8 ee ff ff       	call   800c33 <sys_page_unmap>
  801d4b:	83 c4 10             	add    $0x10,%esp
}
  801d4e:	89 d8                	mov    %ebx,%eax
  801d50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    
	va = fd2data(fd0);
  801d57:	83 ec 0c             	sub    $0xc,%esp
  801d5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5d:	e8 60 f1 ff ff       	call   800ec2 <fd2data>
  801d62:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d64:	83 c4 0c             	add    $0xc,%esp
  801d67:	68 07 04 00 00       	push   $0x407
  801d6c:	50                   	push   %eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	e8 3a ee ff ff       	call   800bae <sys_page_alloc>
  801d74:	89 c3                	mov    %eax,%ebx
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	0f 88 8c 00 00 00    	js     801e0d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	ff 75 f0             	pushl  -0x10(%ebp)
  801d87:	e8 36 f1 ff ff       	call   800ec2 <fd2data>
  801d8c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d93:	50                   	push   %eax
  801d94:	6a 00                	push   $0x0
  801d96:	56                   	push   %esi
  801d97:	6a 00                	push   $0x0
  801d99:	e8 53 ee ff ff       	call   800bf1 <sys_page_map>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	83 c4 20             	add    $0x20,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	78 58                	js     801dff <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801db0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dc5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	ff 75 f4             	pushl  -0xc(%ebp)
  801dd7:	e8 d6 f0 ff ff       	call   800eb2 <fd2num>
  801ddc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddf:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801de1:	83 c4 04             	add    $0x4,%esp
  801de4:	ff 75 f0             	pushl  -0x10(%ebp)
  801de7:	e8 c6 f0 ff ff       	call   800eb2 <fd2num>
  801dec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801def:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfa:	e9 4f ff ff ff       	jmp    801d4e <pipe+0x75>
	sys_page_unmap(0, va);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	56                   	push   %esi
  801e03:	6a 00                	push   $0x0
  801e05:	e8 29 ee ff ff       	call   800c33 <sys_page_unmap>
  801e0a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801e0d:	83 ec 08             	sub    $0x8,%esp
  801e10:	ff 75 f0             	pushl  -0x10(%ebp)
  801e13:	6a 00                	push   $0x0
  801e15:	e8 19 ee ff ff       	call   800c33 <sys_page_unmap>
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	e9 1c ff ff ff       	jmp    801d3e <pipe+0x65>

00801e22 <pipeisclosed>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2b:	50                   	push   %eax
  801e2c:	ff 75 08             	pushl  0x8(%ebp)
  801e2f:	e8 f4 f0 ff ff       	call   800f28 <fd_lookup>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	78 18                	js     801e53 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e41:	e8 7c f0 ff ff       	call   800ec2 <fd2data>
	return _pipeisclosed(fd, p);
  801e46:	89 c2                	mov    %eax,%edx
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	e8 30 fd ff ff       	call   801b80 <_pipeisclosed>
  801e50:	83 c4 10             	add    $0x10,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e65:	68 43 27 80 00       	push   $0x802743
  801e6a:	ff 75 0c             	pushl  0xc(%ebp)
  801e6d:	e8 43 e9 ff ff       	call   8007b5 <strcpy>
	return 0;
}
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <devcons_write>:
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	57                   	push   %edi
  801e7d:	56                   	push   %esi
  801e7e:	53                   	push   %ebx
  801e7f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e85:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e8a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e90:	eb 2f                	jmp    801ec1 <devcons_write+0x48>
		m = n - tot;
  801e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e95:	29 f3                	sub    %esi,%ebx
  801e97:	83 fb 7f             	cmp    $0x7f,%ebx
  801e9a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e9f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	53                   	push   %ebx
  801ea6:	89 f0                	mov    %esi,%eax
  801ea8:	03 45 0c             	add    0xc(%ebp),%eax
  801eab:	50                   	push   %eax
  801eac:	57                   	push   %edi
  801ead:	e8 91 ea ff ff       	call   800943 <memmove>
		sys_cputs(buf, m);
  801eb2:	83 c4 08             	add    $0x8,%esp
  801eb5:	53                   	push   %ebx
  801eb6:	57                   	push   %edi
  801eb7:	e8 36 ec ff ff       	call   800af2 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ebc:	01 de                	add    %ebx,%esi
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ec4:	72 cc                	jb     801e92 <devcons_write+0x19>
}
  801ec6:	89 f0                	mov    %esi,%eax
  801ec8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5f                   	pop    %edi
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    

00801ed0 <devcons_read>:
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 08             	sub    $0x8,%esp
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801edb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801edf:	75 07                	jne    801ee8 <devcons_read+0x18>
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    
		sys_yield();
  801ee3:	e8 a7 ec ff ff       	call   800b8f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ee8:	e8 23 ec ff ff       	call   800b10 <sys_cgetc>
  801eed:	85 c0                	test   %eax,%eax
  801eef:	74 f2                	je     801ee3 <devcons_read+0x13>
	if (c < 0)
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	78 ec                	js     801ee1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801ef5:	83 f8 04             	cmp    $0x4,%eax
  801ef8:	74 0c                	je     801f06 <devcons_read+0x36>
	*(char*)vbuf = c;
  801efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efd:	88 02                	mov    %al,(%edx)
	return 1;
  801eff:	b8 01 00 00 00       	mov    $0x1,%eax
  801f04:	eb db                	jmp    801ee1 <devcons_read+0x11>
		return 0;
  801f06:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0b:	eb d4                	jmp    801ee1 <devcons_read+0x11>

00801f0d <cputchar>:
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f19:	6a 01                	push   $0x1
  801f1b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f1e:	50                   	push   %eax
  801f1f:	e8 ce eb ff ff       	call   800af2 <sys_cputs>
}
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <getchar>:
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f2f:	6a 01                	push   $0x1
  801f31:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f34:	50                   	push   %eax
  801f35:	6a 00                	push   $0x0
  801f37:	e8 5d f2 ff ff       	call   801199 <read>
	if (r < 0)
  801f3c:	83 c4 10             	add    $0x10,%esp
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	78 08                	js     801f4b <getchar+0x22>
	if (r < 1)
  801f43:	85 c0                	test   %eax,%eax
  801f45:	7e 06                	jle    801f4d <getchar+0x24>
	return c;
  801f47:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    
		return -E_EOF;
  801f4d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f52:	eb f7                	jmp    801f4b <getchar+0x22>

00801f54 <iscons>:
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5d:	50                   	push   %eax
  801f5e:	ff 75 08             	pushl  0x8(%ebp)
  801f61:	e8 c2 ef ff ff       	call   800f28 <fd_lookup>
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	85 c0                	test   %eax,%eax
  801f6b:	78 11                	js     801f7e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f76:	39 10                	cmp    %edx,(%eax)
  801f78:	0f 94 c0             	sete   %al
  801f7b:	0f b6 c0             	movzbl %al,%eax
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <opencons>:
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	50                   	push   %eax
  801f8a:	e8 4a ef ff ff       	call   800ed9 <fd_alloc>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	85 c0                	test   %eax,%eax
  801f94:	78 3a                	js     801fd0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 07 04 00 00       	push   $0x407
  801f9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 06 ec ff ff       	call   800bae <sys_page_alloc>
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	78 21                	js     801fd0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fb8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	50                   	push   %eax
  801fc8:	e8 e5 ee ff ff       	call   800eb2 <fd2num>
  801fcd:	83 c4 10             	add    $0x10,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	56                   	push   %esi
  801fd6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801fd7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801fda:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801fe0:	e8 8b eb ff ff       	call   800b70 <sys_getenvid>
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	56                   	push   %esi
  801fef:	50                   	push   %eax
  801ff0:	68 50 27 80 00       	push   $0x802750
  801ff5:	e8 9c e1 ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ffa:	83 c4 18             	add    $0x18,%esp
  801ffd:	53                   	push   %ebx
  801ffe:	ff 75 10             	pushl  0x10(%ebp)
  802001:	e8 3f e1 ff ff       	call   800145 <vcprintf>
	cprintf("\n");
  802006:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  80200d:	e8 84 e1 ff ff       	call   800196 <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802015:	cc                   	int3   
  802016:	eb fd                	jmp    802015 <_panic+0x43>

00802018 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80201e:	89 d0                	mov    %edx,%eax
  802020:	c1 e8 16             	shr    $0x16,%eax
  802023:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80202a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80202f:	f6 c1 01             	test   $0x1,%cl
  802032:	74 1d                	je     802051 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802034:	c1 ea 0c             	shr    $0xc,%edx
  802037:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80203e:	f6 c2 01             	test   $0x1,%dl
  802041:	74 0e                	je     802051 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802043:	c1 ea 0c             	shr    $0xc,%edx
  802046:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80204d:	ef 
  80204e:	0f b7 c0             	movzwl %ax,%eax
}
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    
  802053:	66 90                	xchg   %ax,%ax
  802055:	66 90                	xchg   %ax,%ax
  802057:	66 90                	xchg   %ax,%ax
  802059:	66 90                	xchg   %ax,%ax
  80205b:	66 90                	xchg   %ax,%ax
  80205d:	66 90                	xchg   %ax,%ax
  80205f:	90                   	nop

00802060 <__udivdi3>:
  802060:	55                   	push   %ebp
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	83 ec 1c             	sub    $0x1c,%esp
  802067:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80206b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80206f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802073:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802077:	85 d2                	test   %edx,%edx
  802079:	75 35                	jne    8020b0 <__udivdi3+0x50>
  80207b:	39 f3                	cmp    %esi,%ebx
  80207d:	0f 87 bd 00 00 00    	ja     802140 <__udivdi3+0xe0>
  802083:	85 db                	test   %ebx,%ebx
  802085:	89 d9                	mov    %ebx,%ecx
  802087:	75 0b                	jne    802094 <__udivdi3+0x34>
  802089:	b8 01 00 00 00       	mov    $0x1,%eax
  80208e:	31 d2                	xor    %edx,%edx
  802090:	f7 f3                	div    %ebx
  802092:	89 c1                	mov    %eax,%ecx
  802094:	31 d2                	xor    %edx,%edx
  802096:	89 f0                	mov    %esi,%eax
  802098:	f7 f1                	div    %ecx
  80209a:	89 c6                	mov    %eax,%esi
  80209c:	89 e8                	mov    %ebp,%eax
  80209e:	89 f7                	mov    %esi,%edi
  8020a0:	f7 f1                	div    %ecx
  8020a2:	89 fa                	mov    %edi,%edx
  8020a4:	83 c4 1c             	add    $0x1c,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5f                   	pop    %edi
  8020aa:	5d                   	pop    %ebp
  8020ab:	c3                   	ret    
  8020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020b0:	39 f2                	cmp    %esi,%edx
  8020b2:	77 7c                	ja     802130 <__udivdi3+0xd0>
  8020b4:	0f bd fa             	bsr    %edx,%edi
  8020b7:	83 f7 1f             	xor    $0x1f,%edi
  8020ba:	0f 84 98 00 00 00    	je     802158 <__udivdi3+0xf8>
  8020c0:	89 f9                	mov    %edi,%ecx
  8020c2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020c7:	29 f8                	sub    %edi,%eax
  8020c9:	d3 e2                	shl    %cl,%edx
  8020cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020cf:	89 c1                	mov    %eax,%ecx
  8020d1:	89 da                	mov    %ebx,%edx
  8020d3:	d3 ea                	shr    %cl,%edx
  8020d5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020d9:	09 d1                	or     %edx,%ecx
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e1:	89 f9                	mov    %edi,%ecx
  8020e3:	d3 e3                	shl    %cl,%ebx
  8020e5:	89 c1                	mov    %eax,%ecx
  8020e7:	d3 ea                	shr    %cl,%edx
  8020e9:	89 f9                	mov    %edi,%ecx
  8020eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020ef:	d3 e6                	shl    %cl,%esi
  8020f1:	89 eb                	mov    %ebp,%ebx
  8020f3:	89 c1                	mov    %eax,%ecx
  8020f5:	d3 eb                	shr    %cl,%ebx
  8020f7:	09 de                	or     %ebx,%esi
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	f7 74 24 08          	divl   0x8(%esp)
  8020ff:	89 d6                	mov    %edx,%esi
  802101:	89 c3                	mov    %eax,%ebx
  802103:	f7 64 24 0c          	mull   0xc(%esp)
  802107:	39 d6                	cmp    %edx,%esi
  802109:	72 0c                	jb     802117 <__udivdi3+0xb7>
  80210b:	89 f9                	mov    %edi,%ecx
  80210d:	d3 e5                	shl    %cl,%ebp
  80210f:	39 c5                	cmp    %eax,%ebp
  802111:	73 5d                	jae    802170 <__udivdi3+0x110>
  802113:	39 d6                	cmp    %edx,%esi
  802115:	75 59                	jne    802170 <__udivdi3+0x110>
  802117:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80211a:	31 ff                	xor    %edi,%edi
  80211c:	89 fa                	mov    %edi,%edx
  80211e:	83 c4 1c             	add    $0x1c,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    
  802126:	8d 76 00             	lea    0x0(%esi),%esi
  802129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802130:	31 ff                	xor    %edi,%edi
  802132:	31 c0                	xor    %eax,%eax
  802134:	89 fa                	mov    %edi,%edx
  802136:	83 c4 1c             	add    $0x1c,%esp
  802139:	5b                   	pop    %ebx
  80213a:	5e                   	pop    %esi
  80213b:	5f                   	pop    %edi
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    
  80213e:	66 90                	xchg   %ax,%ax
  802140:	31 ff                	xor    %edi,%edi
  802142:	89 e8                	mov    %ebp,%eax
  802144:	89 f2                	mov    %esi,%edx
  802146:	f7 f3                	div    %ebx
  802148:	89 fa                	mov    %edi,%edx
  80214a:	83 c4 1c             	add    $0x1c,%esp
  80214d:	5b                   	pop    %ebx
  80214e:	5e                   	pop    %esi
  80214f:	5f                   	pop    %edi
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    
  802152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802158:	39 f2                	cmp    %esi,%edx
  80215a:	72 06                	jb     802162 <__udivdi3+0x102>
  80215c:	31 c0                	xor    %eax,%eax
  80215e:	39 eb                	cmp    %ebp,%ebx
  802160:	77 d2                	ja     802134 <__udivdi3+0xd4>
  802162:	b8 01 00 00 00       	mov    $0x1,%eax
  802167:	eb cb                	jmp    802134 <__udivdi3+0xd4>
  802169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802170:	89 d8                	mov    %ebx,%eax
  802172:	31 ff                	xor    %edi,%edi
  802174:	eb be                	jmp    802134 <__udivdi3+0xd4>
  802176:	66 90                	xchg   %ax,%ax
  802178:	66 90                	xchg   %ax,%ax
  80217a:	66 90                	xchg   %ax,%ax
  80217c:	66 90                	xchg   %ax,%ax
  80217e:	66 90                	xchg   %ax,%ax

00802180 <__umoddi3>:
  802180:	55                   	push   %ebp
  802181:	57                   	push   %edi
  802182:	56                   	push   %esi
  802183:	53                   	push   %ebx
  802184:	83 ec 1c             	sub    $0x1c,%esp
  802187:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80218b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80218f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802197:	85 ed                	test   %ebp,%ebp
  802199:	89 f0                	mov    %esi,%eax
  80219b:	89 da                	mov    %ebx,%edx
  80219d:	75 19                	jne    8021b8 <__umoddi3+0x38>
  80219f:	39 df                	cmp    %ebx,%edi
  8021a1:	0f 86 b1 00 00 00    	jbe    802258 <__umoddi3+0xd8>
  8021a7:	f7 f7                	div    %edi
  8021a9:	89 d0                	mov    %edx,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	83 c4 1c             	add    $0x1c,%esp
  8021b0:	5b                   	pop    %ebx
  8021b1:	5e                   	pop    %esi
  8021b2:	5f                   	pop    %edi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    
  8021b5:	8d 76 00             	lea    0x0(%esi),%esi
  8021b8:	39 dd                	cmp    %ebx,%ebp
  8021ba:	77 f1                	ja     8021ad <__umoddi3+0x2d>
  8021bc:	0f bd cd             	bsr    %ebp,%ecx
  8021bf:	83 f1 1f             	xor    $0x1f,%ecx
  8021c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021c6:	0f 84 b4 00 00 00    	je     802280 <__umoddi3+0x100>
  8021cc:	b8 20 00 00 00       	mov    $0x20,%eax
  8021d1:	89 c2                	mov    %eax,%edx
  8021d3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021d7:	29 c2                	sub    %eax,%edx
  8021d9:	89 c1                	mov    %eax,%ecx
  8021db:	89 f8                	mov    %edi,%eax
  8021dd:	d3 e5                	shl    %cl,%ebp
  8021df:	89 d1                	mov    %edx,%ecx
  8021e1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021e5:	d3 e8                	shr    %cl,%eax
  8021e7:	09 c5                	or     %eax,%ebp
  8021e9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021ed:	89 c1                	mov    %eax,%ecx
  8021ef:	d3 e7                	shl    %cl,%edi
  8021f1:	89 d1                	mov    %edx,%ecx
  8021f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021f7:	89 df                	mov    %ebx,%edi
  8021f9:	d3 ef                	shr    %cl,%edi
  8021fb:	89 c1                	mov    %eax,%ecx
  8021fd:	89 f0                	mov    %esi,%eax
  8021ff:	d3 e3                	shl    %cl,%ebx
  802201:	89 d1                	mov    %edx,%ecx
  802203:	89 fa                	mov    %edi,%edx
  802205:	d3 e8                	shr    %cl,%eax
  802207:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80220c:	09 d8                	or     %ebx,%eax
  80220e:	f7 f5                	div    %ebp
  802210:	d3 e6                	shl    %cl,%esi
  802212:	89 d1                	mov    %edx,%ecx
  802214:	f7 64 24 08          	mull   0x8(%esp)
  802218:	39 d1                	cmp    %edx,%ecx
  80221a:	89 c3                	mov    %eax,%ebx
  80221c:	89 d7                	mov    %edx,%edi
  80221e:	72 06                	jb     802226 <__umoddi3+0xa6>
  802220:	75 0e                	jne    802230 <__umoddi3+0xb0>
  802222:	39 c6                	cmp    %eax,%esi
  802224:	73 0a                	jae    802230 <__umoddi3+0xb0>
  802226:	2b 44 24 08          	sub    0x8(%esp),%eax
  80222a:	19 ea                	sbb    %ebp,%edx
  80222c:	89 d7                	mov    %edx,%edi
  80222e:	89 c3                	mov    %eax,%ebx
  802230:	89 ca                	mov    %ecx,%edx
  802232:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802237:	29 de                	sub    %ebx,%esi
  802239:	19 fa                	sbb    %edi,%edx
  80223b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80223f:	89 d0                	mov    %edx,%eax
  802241:	d3 e0                	shl    %cl,%eax
  802243:	89 d9                	mov    %ebx,%ecx
  802245:	d3 ee                	shr    %cl,%esi
  802247:	d3 ea                	shr    %cl,%edx
  802249:	09 f0                	or     %esi,%eax
  80224b:	83 c4 1c             	add    $0x1c,%esp
  80224e:	5b                   	pop    %ebx
  80224f:	5e                   	pop    %esi
  802250:	5f                   	pop    %edi
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    
  802253:	90                   	nop
  802254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802258:	85 ff                	test   %edi,%edi
  80225a:	89 f9                	mov    %edi,%ecx
  80225c:	75 0b                	jne    802269 <__umoddi3+0xe9>
  80225e:	b8 01 00 00 00       	mov    $0x1,%eax
  802263:	31 d2                	xor    %edx,%edx
  802265:	f7 f7                	div    %edi
  802267:	89 c1                	mov    %eax,%ecx
  802269:	89 d8                	mov    %ebx,%eax
  80226b:	31 d2                	xor    %edx,%edx
  80226d:	f7 f1                	div    %ecx
  80226f:	89 f0                	mov    %esi,%eax
  802271:	f7 f1                	div    %ecx
  802273:	e9 31 ff ff ff       	jmp    8021a9 <__umoddi3+0x29>
  802278:	90                   	nop
  802279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802280:	39 dd                	cmp    %ebx,%ebp
  802282:	72 08                	jb     80228c <__umoddi3+0x10c>
  802284:	39 f7                	cmp    %esi,%edi
  802286:	0f 87 21 ff ff ff    	ja     8021ad <__umoddi3+0x2d>
  80228c:	89 da                	mov    %ebx,%edx
  80228e:	89 f0                	mov    %esi,%eax
  802290:	29 f8                	sub    %edi,%eax
  802292:	19 ea                	sbb    %ebp,%edx
  802294:	e9 14 ff ff ff       	jmp    8021ad <__umoddi3+0x2d>

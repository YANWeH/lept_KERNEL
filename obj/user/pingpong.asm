
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 8f 00 00 00       	call   8000c0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 75 0e 00 00       	call   800eb6 <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 4f                	jne    800097 <umain+0x64>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800048:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004b:	83 ec 04             	sub    $0x4,%esp
  80004e:	6a 00                	push   $0x0
  800050:	6a 00                	push   $0x0
  800052:	56                   	push   %esi
  800053:	e8 23 10 00 00       	call   80107b <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  80005a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80005d:	e8 2d 0b 00 00       	call   800b8f <sys_getenvid>
  800062:	57                   	push   %edi
  800063:	53                   	push   %ebx
  800064:	50                   	push   %eax
  800065:	68 f6 25 80 00       	push   $0x8025f6
  80006a:	e8 46 01 00 00       	call   8001b5 <cprintf>
		if (i == 10)
  80006f:	83 c4 20             	add    $0x20,%esp
  800072:	83 fb 0a             	cmp    $0xa,%ebx
  800075:	74 18                	je     80008f <umain+0x5c>
			return;
		i++;
  800077:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  80007a:	6a 00                	push   $0x0
  80007c:	6a 00                	push   $0x0
  80007e:	53                   	push   %ebx
  80007f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800082:	e8 5b 10 00 00       	call   8010e2 <ipc_send>
		if (i == 10)
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	83 fb 0a             	cmp    $0xa,%ebx
  80008d:	75 bc                	jne    80004b <umain+0x18>
			return;
	}

}
  80008f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5f                   	pop    %edi
  800095:	5d                   	pop    %ebp
  800096:	c3                   	ret    
  800097:	89 c3                	mov    %eax,%ebx
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800099:	e8 f1 0a 00 00       	call   800b8f <sys_getenvid>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	53                   	push   %ebx
  8000a2:	50                   	push   %eax
  8000a3:	68 e0 25 80 00       	push   $0x8025e0
  8000a8:	e8 08 01 00 00       	call   8001b5 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 00                	push   $0x0
  8000b1:	6a 00                	push   $0x0
  8000b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000b6:	e8 27 10 00 00       	call   8010e2 <ipc_send>
  8000bb:	83 c4 20             	add    $0x20,%esp
  8000be:	eb 88                	jmp    800048 <umain+0x15>

008000c0 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	56                   	push   %esi
  8000c4:	53                   	push   %ebx
  8000c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cb:	e8 bf 0a 00 00       	call   800b8f <sys_getenvid>
  8000d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e2:	85 db                	test   %ebx,%ebx
  8000e4:	7e 07                	jle    8000ed <libmain+0x2d>
		binaryname = argv[0];
  8000e6:	8b 06                	mov    (%esi),%eax
  8000e8:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 3c ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f7:	e8 0a 00 00 00       	call   800106 <exit>
}
  8000fc:	83 c4 10             	add    $0x10,%esp
  8000ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800102:	5b                   	pop    %ebx
  800103:	5e                   	pop    %esi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    

00800106 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010c:	e8 34 12 00 00       	call   801345 <close_all>
	sys_env_destroy(0);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	6a 00                	push   $0x0
  800116:	e8 33 0a 00 00       	call   800b4e <sys_env_destroy>
}
  80011b:	83 c4 10             	add    $0x10,%esp
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 13                	mov    (%ebx),%edx
  80012c:	8d 42 01             	lea    0x1(%edx),%eax
  80012f:	89 03                	mov    %eax,(%ebx)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800138:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013d:	74 09                	je     800148 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800146:	c9                   	leave  
  800147:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 ff 00 00 00       	push   $0xff
  800150:	8d 43 08             	lea    0x8(%ebx),%eax
  800153:	50                   	push   %eax
  800154:	e8 b8 09 00 00       	call   800b11 <sys_cputs>
		b->idx = 0;
  800159:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80015f:	83 c4 10             	add    $0x10,%esp
  800162:	eb db                	jmp    80013f <putch+0x1f>

00800164 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	ff 75 0c             	pushl  0xc(%ebp)
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80018d:	50                   	push   %eax
  80018e:	68 20 01 80 00       	push   $0x800120
  800193:	e8 1a 01 00 00       	call   8002b2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800198:	83 c4 08             	add    $0x8,%esp
  80019b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001a1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a7:	50                   	push   %eax
  8001a8:	e8 64 09 00 00       	call   800b11 <sys_cputs>

	return b.cnt;
}
  8001ad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001bb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001be:	50                   	push   %eax
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	e8 9d ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	57                   	push   %edi
  8001cd:	56                   	push   %esi
  8001ce:	53                   	push   %ebx
  8001cf:	83 ec 1c             	sub    $0x1c,%esp
  8001d2:	89 c7                	mov    %eax,%edi
  8001d4:	89 d6                	mov    %edx,%esi
  8001d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001df:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ea:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001f0:	39 d3                	cmp    %edx,%ebx
  8001f2:	72 05                	jb     8001f9 <printnum+0x30>
  8001f4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f7:	77 7a                	ja     800273 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	ff 75 18             	pushl  0x18(%ebp)
  8001ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800202:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800205:	53                   	push   %ebx
  800206:	ff 75 10             	pushl  0x10(%ebp)
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80020f:	ff 75 e0             	pushl  -0x20(%ebp)
  800212:	ff 75 dc             	pushl  -0x24(%ebp)
  800215:	ff 75 d8             	pushl  -0x28(%ebp)
  800218:	e8 83 21 00 00       	call   8023a0 <__udivdi3>
  80021d:	83 c4 18             	add    $0x18,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	89 f2                	mov    %esi,%edx
  800224:	89 f8                	mov    %edi,%eax
  800226:	e8 9e ff ff ff       	call   8001c9 <printnum>
  80022b:	83 c4 20             	add    $0x20,%esp
  80022e:	eb 13                	jmp    800243 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	56                   	push   %esi
  800234:	ff 75 18             	pushl  0x18(%ebp)
  800237:	ff d7                	call   *%edi
  800239:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80023c:	83 eb 01             	sub    $0x1,%ebx
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7f ed                	jg     800230 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	56                   	push   %esi
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024d:	ff 75 e0             	pushl  -0x20(%ebp)
  800250:	ff 75 dc             	pushl  -0x24(%ebp)
  800253:	ff 75 d8             	pushl  -0x28(%ebp)
  800256:	e8 65 22 00 00       	call   8024c0 <__umoddi3>
  80025b:	83 c4 14             	add    $0x14,%esp
  80025e:	0f be 80 13 26 80 00 	movsbl 0x802613(%eax),%eax
  800265:	50                   	push   %eax
  800266:	ff d7                	call   *%edi
}
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5e                   	pop    %esi
  800270:	5f                   	pop    %edi
  800271:	5d                   	pop    %ebp
  800272:	c3                   	ret    
  800273:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800276:	eb c4                	jmp    80023c <printnum+0x73>

00800278 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80027e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800282:	8b 10                	mov    (%eax),%edx
  800284:	3b 50 04             	cmp    0x4(%eax),%edx
  800287:	73 0a                	jae    800293 <sprintputch+0x1b>
		*b->buf++ = ch;
  800289:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	88 02                	mov    %al,(%edx)
}
  800293:	5d                   	pop    %ebp
  800294:	c3                   	ret    

00800295 <printfmt>:
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 10             	pushl  0x10(%ebp)
  8002a2:	ff 75 0c             	pushl  0xc(%ebp)
  8002a5:	ff 75 08             	pushl  0x8(%ebp)
  8002a8:	e8 05 00 00 00       	call   8002b2 <vprintfmt>
}
  8002ad:	83 c4 10             	add    $0x10,%esp
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <vprintfmt>:
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	57                   	push   %edi
  8002b6:	56                   	push   %esi
  8002b7:	53                   	push   %ebx
  8002b8:	83 ec 2c             	sub    $0x2c,%esp
  8002bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8002be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c1:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c4:	e9 c1 03 00 00       	jmp    80068a <vprintfmt+0x3d8>
		padc = ' ';
  8002c9:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002cd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002d4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002db:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ed:	0f b6 17             	movzbl (%edi),%edx
  8002f0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f3:	3c 55                	cmp    $0x55,%al
  8002f5:	0f 87 12 04 00 00    	ja     80070d <vprintfmt+0x45b>
  8002fb:	0f b6 c0             	movzbl %al,%eax
  8002fe:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80030c:	eb d9                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800311:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800315:	eb d0                	jmp    8002e7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800325:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800328:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80032c:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80032f:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800332:	83 f9 09             	cmp    $0x9,%ecx
  800335:	77 55                	ja     80038c <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	eb e9                	jmp    800325 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80033c:	8b 45 14             	mov    0x14(%ebp),%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 40 04             	lea    0x4(%eax),%eax
  80034a:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800350:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800354:	79 91                	jns    8002e7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800356:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800359:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80035c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800363:	eb 82                	jmp    8002e7 <vprintfmt+0x35>
  800365:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800368:	85 c0                	test   %eax,%eax
  80036a:	ba 00 00 00 00       	mov    $0x0,%edx
  80036f:	0f 49 d0             	cmovns %eax,%edx
  800372:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800378:	e9 6a ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80037d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800380:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800387:	e9 5b ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
  80038c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80038f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800392:	eb bc                	jmp    800350 <vprintfmt+0x9e>
			lflag++;
  800394:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800397:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80039a:	e9 48 ff ff ff       	jmp    8002e7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8d 78 04             	lea    0x4(%eax),%edi
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	53                   	push   %ebx
  8003a9:	ff 30                	pushl  (%eax)
  8003ab:	ff d6                	call   *%esi
			break;
  8003ad:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003b0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b3:	e9 cf 02 00 00       	jmp    800687 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bb:	8d 78 04             	lea    0x4(%eax),%edi
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	99                   	cltd   
  8003c1:	31 d0                	xor    %edx,%eax
  8003c3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c5:	83 f8 0f             	cmp    $0xf,%eax
  8003c8:	7f 23                	jg     8003ed <vprintfmt+0x13b>
  8003ca:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  8003d1:	85 d2                	test   %edx,%edx
  8003d3:	74 18                	je     8003ed <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003d5:	52                   	push   %edx
  8003d6:	68 fd 2a 80 00       	push   $0x802afd
  8003db:	53                   	push   %ebx
  8003dc:	56                   	push   %esi
  8003dd:	e8 b3 fe ff ff       	call   800295 <printfmt>
  8003e2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e8:	e9 9a 02 00 00       	jmp    800687 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8003ed:	50                   	push   %eax
  8003ee:	68 2b 26 80 00       	push   $0x80262b
  8003f3:	53                   	push   %ebx
  8003f4:	56                   	push   %esi
  8003f5:	e8 9b fe ff ff       	call   800295 <printfmt>
  8003fa:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fd:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800400:	e9 82 02 00 00       	jmp    800687 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800405:	8b 45 14             	mov    0x14(%ebp),%eax
  800408:	83 c0 04             	add    $0x4,%eax
  80040b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800413:	85 ff                	test   %edi,%edi
  800415:	b8 24 26 80 00       	mov    $0x802624,%eax
  80041a:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80041d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800421:	0f 8e bd 00 00 00    	jle    8004e4 <vprintfmt+0x232>
  800427:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80042b:	75 0e                	jne    80043b <vprintfmt+0x189>
  80042d:	89 75 08             	mov    %esi,0x8(%ebp)
  800430:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800433:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800436:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800439:	eb 6d                	jmp    8004a8 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	83 ec 08             	sub    $0x8,%esp
  80043e:	ff 75 d0             	pushl  -0x30(%ebp)
  800441:	57                   	push   %edi
  800442:	e8 6e 03 00 00       	call   8007b5 <strnlen>
  800447:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80044a:	29 c1                	sub    %eax,%ecx
  80044c:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80044f:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800452:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800456:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800459:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80045c:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	eb 0f                	jmp    80046f <vprintfmt+0x1bd>
					putch(padc, putdat);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	53                   	push   %ebx
  800464:	ff 75 e0             	pushl  -0x20(%ebp)
  800467:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800469:	83 ef 01             	sub    $0x1,%edi
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	85 ff                	test   %edi,%edi
  800471:	7f ed                	jg     800460 <vprintfmt+0x1ae>
  800473:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800476:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800479:	85 c9                	test   %ecx,%ecx
  80047b:	b8 00 00 00 00       	mov    $0x0,%eax
  800480:	0f 49 c1             	cmovns %ecx,%eax
  800483:	29 c1                	sub    %eax,%ecx
  800485:	89 75 08             	mov    %esi,0x8(%ebp)
  800488:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80048b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80048e:	89 cb                	mov    %ecx,%ebx
  800490:	eb 16                	jmp    8004a8 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800492:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800496:	75 31                	jne    8004c9 <vprintfmt+0x217>
					putch(ch, putdat);
  800498:	83 ec 08             	sub    $0x8,%esp
  80049b:	ff 75 0c             	pushl  0xc(%ebp)
  80049e:	50                   	push   %eax
  80049f:	ff 55 08             	call   *0x8(%ebp)
  8004a2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a5:	83 eb 01             	sub    $0x1,%ebx
  8004a8:	83 c7 01             	add    $0x1,%edi
  8004ab:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004af:	0f be c2             	movsbl %dl,%eax
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	74 59                	je     80050f <vprintfmt+0x25d>
  8004b6:	85 f6                	test   %esi,%esi
  8004b8:	78 d8                	js     800492 <vprintfmt+0x1e0>
  8004ba:	83 ee 01             	sub    $0x1,%esi
  8004bd:	79 d3                	jns    800492 <vprintfmt+0x1e0>
  8004bf:	89 df                	mov    %ebx,%edi
  8004c1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c7:	eb 37                	jmp    800500 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004c9:	0f be d2             	movsbl %dl,%edx
  8004cc:	83 ea 20             	sub    $0x20,%edx
  8004cf:	83 fa 5e             	cmp    $0x5e,%edx
  8004d2:	76 c4                	jbe    800498 <vprintfmt+0x1e6>
					putch('?', putdat);
  8004d4:	83 ec 08             	sub    $0x8,%esp
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	6a 3f                	push   $0x3f
  8004dc:	ff 55 08             	call   *0x8(%ebp)
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	eb c1                	jmp    8004a5 <vprintfmt+0x1f3>
  8004e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f0:	eb b6                	jmp    8004a8 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	53                   	push   %ebx
  8004f6:	6a 20                	push   $0x20
  8004f8:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004fa:	83 ef 01             	sub    $0x1,%edi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	85 ff                	test   %edi,%edi
  800502:	7f ee                	jg     8004f2 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800507:	89 45 14             	mov    %eax,0x14(%ebp)
  80050a:	e9 78 01 00 00       	jmp    800687 <vprintfmt+0x3d5>
  80050f:	89 df                	mov    %ebx,%edi
  800511:	8b 75 08             	mov    0x8(%ebp),%esi
  800514:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800517:	eb e7                	jmp    800500 <vprintfmt+0x24e>
	if (lflag >= 2)
  800519:	83 f9 01             	cmp    $0x1,%ecx
  80051c:	7e 3f                	jle    80055d <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 50 04             	mov    0x4(%eax),%edx
  800524:	8b 00                	mov    (%eax),%eax
  800526:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800529:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052c:	8b 45 14             	mov    0x14(%ebp),%eax
  80052f:	8d 40 08             	lea    0x8(%eax),%eax
  800532:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800539:	79 5c                	jns    800597 <vprintfmt+0x2e5>
				putch('-', putdat);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	53                   	push   %ebx
  80053f:	6a 2d                	push   $0x2d
  800541:	ff d6                	call   *%esi
				num = -(long long) num;
  800543:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800546:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800549:	f7 da                	neg    %edx
  80054b:	83 d1 00             	adc    $0x0,%ecx
  80054e:	f7 d9                	neg    %ecx
  800550:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800553:	b8 0a 00 00 00       	mov    $0xa,%eax
  800558:	e9 10 01 00 00       	jmp    80066d <vprintfmt+0x3bb>
	else if (lflag)
  80055d:	85 c9                	test   %ecx,%ecx
  80055f:	75 1b                	jne    80057c <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800569:	89 c1                	mov    %eax,%ecx
  80056b:	c1 f9 1f             	sar    $0x1f,%ecx
  80056e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8d 40 04             	lea    0x4(%eax),%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	eb b9                	jmp    800535 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	89 c1                	mov    %eax,%ecx
  800586:	c1 f9 1f             	sar    $0x1f,%ecx
  800589:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb 9e                	jmp    800535 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800597:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80059a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80059d:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a2:	e9 c6 00 00 00       	jmp    80066d <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005a7:	83 f9 01             	cmp    $0x1,%ecx
  8005aa:	7e 18                	jle    8005c4 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8b 10                	mov    (%eax),%edx
  8005b1:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b4:	8d 40 08             	lea    0x8(%eax),%eax
  8005b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005bf:	e9 a9 00 00 00       	jmp    80066d <vprintfmt+0x3bb>
	else if (lflag)
  8005c4:	85 c9                	test   %ecx,%ecx
  8005c6:	75 1a                	jne    8005e2 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 8b 00 00 00       	jmp    80066d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 10                	mov    (%eax),%edx
  8005e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ec:	8d 40 04             	lea    0x4(%eax),%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f7:	eb 74                	jmp    80066d <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005f9:	83 f9 01             	cmp    $0x1,%ecx
  8005fc:	7e 15                	jle    800613 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8b 10                	mov    (%eax),%edx
  800603:	8b 48 04             	mov    0x4(%eax),%ecx
  800606:	8d 40 08             	lea    0x8(%eax),%eax
  800609:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060c:	b8 08 00 00 00       	mov    $0x8,%eax
  800611:	eb 5a                	jmp    80066d <vprintfmt+0x3bb>
	else if (lflag)
  800613:	85 c9                	test   %ecx,%ecx
  800615:	75 17                	jne    80062e <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 10                	mov    (%eax),%edx
  80061c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800621:	8d 40 04             	lea    0x4(%eax),%eax
  800624:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800627:	b8 08 00 00 00       	mov    $0x8,%eax
  80062c:	eb 3f                	jmp    80066d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 10                	mov    (%eax),%edx
  800633:	b9 00 00 00 00       	mov    $0x0,%ecx
  800638:	8d 40 04             	lea    0x4(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063e:	b8 08 00 00 00       	mov    $0x8,%eax
  800643:	eb 28                	jmp    80066d <vprintfmt+0x3bb>
			putch('0', putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	6a 30                	push   $0x30
  80064b:	ff d6                	call   *%esi
			putch('x', putdat);
  80064d:	83 c4 08             	add    $0x8,%esp
  800650:	53                   	push   %ebx
  800651:	6a 78                	push   $0x78
  800653:	ff d6                	call   *%esi
			num = (unsigned long long)
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8b 10                	mov    (%eax),%edx
  80065a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80065f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800662:	8d 40 04             	lea    0x4(%eax),%eax
  800665:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800668:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80066d:	83 ec 0c             	sub    $0xc,%esp
  800670:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800674:	57                   	push   %edi
  800675:	ff 75 e0             	pushl  -0x20(%ebp)
  800678:	50                   	push   %eax
  800679:	51                   	push   %ecx
  80067a:	52                   	push   %edx
  80067b:	89 da                	mov    %ebx,%edx
  80067d:	89 f0                	mov    %esi,%eax
  80067f:	e8 45 fb ff ff       	call   8001c9 <printnum>
			break;
  800684:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800687:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80068a:	83 c7 01             	add    $0x1,%edi
  80068d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800691:	83 f8 25             	cmp    $0x25,%eax
  800694:	0f 84 2f fc ff ff    	je     8002c9 <vprintfmt+0x17>
			if (ch == '\0')
  80069a:	85 c0                	test   %eax,%eax
  80069c:	0f 84 8b 00 00 00    	je     80072d <vprintfmt+0x47b>
			putch(ch, putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	53                   	push   %ebx
  8006a6:	50                   	push   %eax
  8006a7:	ff d6                	call   *%esi
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	eb dc                	jmp    80068a <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006ae:	83 f9 01             	cmp    $0x1,%ecx
  8006b1:	7e 15                	jle    8006c8 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 10                	mov    (%eax),%edx
  8006b8:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bb:	8d 40 08             	lea    0x8(%eax),%eax
  8006be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c1:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c6:	eb a5                	jmp    80066d <vprintfmt+0x3bb>
	else if (lflag)
  8006c8:	85 c9                	test   %ecx,%ecx
  8006ca:	75 17                	jne    8006e3 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
  8006d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006dc:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e1:	eb 8a                	jmp    80066d <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 10                	mov    (%eax),%edx
  8006e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ed:	8d 40 04             	lea    0x4(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f3:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f8:	e9 70 ff ff ff       	jmp    80066d <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	53                   	push   %ebx
  800701:	6a 25                	push   $0x25
  800703:	ff d6                	call   *%esi
			break;
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	e9 7a ff ff ff       	jmp    800687 <vprintfmt+0x3d5>
			putch('%', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 25                	push   $0x25
  800713:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	89 f8                	mov    %edi,%eax
  80071a:	eb 03                	jmp    80071f <vprintfmt+0x46d>
  80071c:	83 e8 01             	sub    $0x1,%eax
  80071f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800723:	75 f7                	jne    80071c <vprintfmt+0x46a>
  800725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800728:	e9 5a ff ff ff       	jmp    800687 <vprintfmt+0x3d5>
}
  80072d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800730:	5b                   	pop    %ebx
  800731:	5e                   	pop    %esi
  800732:	5f                   	pop    %edi
  800733:	5d                   	pop    %ebp
  800734:	c3                   	ret    

00800735 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 18             	sub    $0x18,%esp
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800744:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800748:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80074b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800752:	85 c0                	test   %eax,%eax
  800754:	74 26                	je     80077c <vsnprintf+0x47>
  800756:	85 d2                	test   %edx,%edx
  800758:	7e 22                	jle    80077c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80075a:	ff 75 14             	pushl  0x14(%ebp)
  80075d:	ff 75 10             	pushl  0x10(%ebp)
  800760:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800763:	50                   	push   %eax
  800764:	68 78 02 80 00       	push   $0x800278
  800769:	e8 44 fb ff ff       	call   8002b2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800771:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800777:	83 c4 10             	add    $0x10,%esp
}
  80077a:	c9                   	leave  
  80077b:	c3                   	ret    
		return -E_INVAL;
  80077c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800781:	eb f7                	jmp    80077a <vsnprintf+0x45>

00800783 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800789:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80078c:	50                   	push   %eax
  80078d:	ff 75 10             	pushl  0x10(%ebp)
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	ff 75 08             	pushl  0x8(%ebp)
  800796:	e8 9a ff ff ff       	call   800735 <vsnprintf>
	va_end(ap);

	return rc;
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a8:	eb 03                	jmp    8007ad <strlen+0x10>
		n++;
  8007aa:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007ad:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b1:	75 f7                	jne    8007aa <strlen+0xd>
	return n;
}
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007be:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c3:	eb 03                	jmp    8007c8 <strnlen+0x13>
		n++;
  8007c5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c8:	39 d0                	cmp    %edx,%eax
  8007ca:	74 06                	je     8007d2 <strnlen+0x1d>
  8007cc:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d0:	75 f3                	jne    8007c5 <strnlen+0x10>
	return n;
}
  8007d2:	5d                   	pop    %ebp
  8007d3:	c3                   	ret    

008007d4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	53                   	push   %ebx
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007de:	89 c2                	mov    %eax,%edx
  8007e0:	83 c1 01             	add    $0x1,%ecx
  8007e3:	83 c2 01             	add    $0x1,%edx
  8007e6:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007ea:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007ed:	84 db                	test   %bl,%bl
  8007ef:	75 ef                	jne    8007e0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f1:	5b                   	pop    %ebx
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	53                   	push   %ebx
  8007f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007fb:	53                   	push   %ebx
  8007fc:	e8 9c ff ff ff       	call   80079d <strlen>
  800801:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	01 d8                	add    %ebx,%eax
  800809:	50                   	push   %eax
  80080a:	e8 c5 ff ff ff       	call   8007d4 <strcpy>
	return dst;
}
  80080f:	89 d8                	mov    %ebx,%eax
  800811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800814:	c9                   	leave  
  800815:	c3                   	ret    

00800816 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	56                   	push   %esi
  80081a:	53                   	push   %ebx
  80081b:	8b 75 08             	mov    0x8(%ebp),%esi
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800821:	89 f3                	mov    %esi,%ebx
  800823:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800826:	89 f2                	mov    %esi,%edx
  800828:	eb 0f                	jmp    800839 <strncpy+0x23>
		*dst++ = *src;
  80082a:	83 c2 01             	add    $0x1,%edx
  80082d:	0f b6 01             	movzbl (%ecx),%eax
  800830:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800833:	80 39 01             	cmpb   $0x1,(%ecx)
  800836:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800839:	39 da                	cmp    %ebx,%edx
  80083b:	75 ed                	jne    80082a <strncpy+0x14>
	}
	return ret;
}
  80083d:	89 f0                	mov    %esi,%eax
  80083f:	5b                   	pop    %ebx
  800840:	5e                   	pop    %esi
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	56                   	push   %esi
  800847:	53                   	push   %ebx
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800851:	89 f0                	mov    %esi,%eax
  800853:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800857:	85 c9                	test   %ecx,%ecx
  800859:	75 0b                	jne    800866 <strlcpy+0x23>
  80085b:	eb 17                	jmp    800874 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80085d:	83 c2 01             	add    $0x1,%edx
  800860:	83 c0 01             	add    $0x1,%eax
  800863:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800866:	39 d8                	cmp    %ebx,%eax
  800868:	74 07                	je     800871 <strlcpy+0x2e>
  80086a:	0f b6 0a             	movzbl (%edx),%ecx
  80086d:	84 c9                	test   %cl,%cl
  80086f:	75 ec                	jne    80085d <strlcpy+0x1a>
		*dst = '\0';
  800871:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800874:	29 f0                	sub    %esi,%eax
}
  800876:	5b                   	pop    %ebx
  800877:	5e                   	pop    %esi
  800878:	5d                   	pop    %ebp
  800879:	c3                   	ret    

0080087a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800880:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800883:	eb 06                	jmp    80088b <strcmp+0x11>
		p++, q++;
  800885:	83 c1 01             	add    $0x1,%ecx
  800888:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80088b:	0f b6 01             	movzbl (%ecx),%eax
  80088e:	84 c0                	test   %al,%al
  800890:	74 04                	je     800896 <strcmp+0x1c>
  800892:	3a 02                	cmp    (%edx),%al
  800894:	74 ef                	je     800885 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800896:	0f b6 c0             	movzbl %al,%eax
  800899:	0f b6 12             	movzbl (%edx),%edx
  80089c:	29 d0                	sub    %edx,%eax
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	53                   	push   %ebx
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	89 c3                	mov    %eax,%ebx
  8008ac:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008af:	eb 06                	jmp    8008b7 <strncmp+0x17>
		n--, p++, q++;
  8008b1:	83 c0 01             	add    $0x1,%eax
  8008b4:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008b7:	39 d8                	cmp    %ebx,%eax
  8008b9:	74 16                	je     8008d1 <strncmp+0x31>
  8008bb:	0f b6 08             	movzbl (%eax),%ecx
  8008be:	84 c9                	test   %cl,%cl
  8008c0:	74 04                	je     8008c6 <strncmp+0x26>
  8008c2:	3a 0a                	cmp    (%edx),%cl
  8008c4:	74 eb                	je     8008b1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c6:	0f b6 00             	movzbl (%eax),%eax
  8008c9:	0f b6 12             	movzbl (%edx),%edx
  8008cc:	29 d0                	sub    %edx,%eax
}
  8008ce:	5b                   	pop    %ebx
  8008cf:	5d                   	pop    %ebp
  8008d0:	c3                   	ret    
		return 0;
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	eb f6                	jmp    8008ce <strncmp+0x2e>

008008d8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e2:	0f b6 10             	movzbl (%eax),%edx
  8008e5:	84 d2                	test   %dl,%dl
  8008e7:	74 09                	je     8008f2 <strchr+0x1a>
		if (*s == c)
  8008e9:	38 ca                	cmp    %cl,%dl
  8008eb:	74 0a                	je     8008f7 <strchr+0x1f>
	for (; *s; s++)
  8008ed:	83 c0 01             	add    $0x1,%eax
  8008f0:	eb f0                	jmp    8008e2 <strchr+0xa>
			return (char *) s;
	return 0;
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f7:	5d                   	pop    %ebp
  8008f8:	c3                   	ret    

008008f9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800903:	eb 03                	jmp    800908 <strfind+0xf>
  800905:	83 c0 01             	add    $0x1,%eax
  800908:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80090b:	38 ca                	cmp    %cl,%dl
  80090d:	74 04                	je     800913 <strfind+0x1a>
  80090f:	84 d2                	test   %dl,%dl
  800911:	75 f2                	jne    800905 <strfind+0xc>
			break;
	return (char *) s;
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	57                   	push   %edi
  800919:	56                   	push   %esi
  80091a:	53                   	push   %ebx
  80091b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80091e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800921:	85 c9                	test   %ecx,%ecx
  800923:	74 13                	je     800938 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800925:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092b:	75 05                	jne    800932 <memset+0x1d>
  80092d:	f6 c1 03             	test   $0x3,%cl
  800930:	74 0d                	je     80093f <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	fc                   	cld    
  800936:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800938:	89 f8                	mov    %edi,%eax
  80093a:	5b                   	pop    %ebx
  80093b:	5e                   	pop    %esi
  80093c:	5f                   	pop    %edi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    
		c &= 0xFF;
  80093f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800943:	89 d3                	mov    %edx,%ebx
  800945:	c1 e3 08             	shl    $0x8,%ebx
  800948:	89 d0                	mov    %edx,%eax
  80094a:	c1 e0 18             	shl    $0x18,%eax
  80094d:	89 d6                	mov    %edx,%esi
  80094f:	c1 e6 10             	shl    $0x10,%esi
  800952:	09 f0                	or     %esi,%eax
  800954:	09 c2                	or     %eax,%edx
  800956:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800958:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80095b:	89 d0                	mov    %edx,%eax
  80095d:	fc                   	cld    
  80095e:	f3 ab                	rep stos %eax,%es:(%edi)
  800960:	eb d6                	jmp    800938 <memset+0x23>

00800962 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	57                   	push   %edi
  800966:	56                   	push   %esi
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800970:	39 c6                	cmp    %eax,%esi
  800972:	73 35                	jae    8009a9 <memmove+0x47>
  800974:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800977:	39 c2                	cmp    %eax,%edx
  800979:	76 2e                	jbe    8009a9 <memmove+0x47>
		s += n;
		d += n;
  80097b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097e:	89 d6                	mov    %edx,%esi
  800980:	09 fe                	or     %edi,%esi
  800982:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800988:	74 0c                	je     800996 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80098a:	83 ef 01             	sub    $0x1,%edi
  80098d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800990:	fd                   	std    
  800991:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800993:	fc                   	cld    
  800994:	eb 21                	jmp    8009b7 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800996:	f6 c1 03             	test   $0x3,%cl
  800999:	75 ef                	jne    80098a <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80099b:	83 ef 04             	sub    $0x4,%edi
  80099e:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009a4:	fd                   	std    
  8009a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009a7:	eb ea                	jmp    800993 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a9:	89 f2                	mov    %esi,%edx
  8009ab:	09 c2                	or     %eax,%edx
  8009ad:	f6 c2 03             	test   $0x3,%dl
  8009b0:	74 09                	je     8009bb <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009b2:	89 c7                	mov    %eax,%edi
  8009b4:	fc                   	cld    
  8009b5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b7:	5e                   	pop    %esi
  8009b8:	5f                   	pop    %edi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bb:	f6 c1 03             	test   $0x3,%cl
  8009be:	75 f2                	jne    8009b2 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009c3:	89 c7                	mov    %eax,%edi
  8009c5:	fc                   	cld    
  8009c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c8:	eb ed                	jmp    8009b7 <memmove+0x55>

008009ca <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009cd:	ff 75 10             	pushl  0x10(%ebp)
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	ff 75 08             	pushl  0x8(%ebp)
  8009d6:	e8 87 ff ff ff       	call   800962 <memmove>
}
  8009db:	c9                   	leave  
  8009dc:	c3                   	ret    

008009dd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	56                   	push   %esi
  8009e1:	53                   	push   %ebx
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e8:	89 c6                	mov    %eax,%esi
  8009ea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ed:	39 f0                	cmp    %esi,%eax
  8009ef:	74 1c                	je     800a0d <memcmp+0x30>
		if (*s1 != *s2)
  8009f1:	0f b6 08             	movzbl (%eax),%ecx
  8009f4:	0f b6 1a             	movzbl (%edx),%ebx
  8009f7:	38 d9                	cmp    %bl,%cl
  8009f9:	75 08                	jne    800a03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009fb:	83 c0 01             	add    $0x1,%eax
  8009fe:	83 c2 01             	add    $0x1,%edx
  800a01:	eb ea                	jmp    8009ed <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a03:	0f b6 c1             	movzbl %cl,%eax
  800a06:	0f b6 db             	movzbl %bl,%ebx
  800a09:	29 d8                	sub    %ebx,%eax
  800a0b:	eb 05                	jmp    800a12 <memcmp+0x35>
	}

	return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a1f:	89 c2                	mov    %eax,%edx
  800a21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a24:	39 d0                	cmp    %edx,%eax
  800a26:	73 09                	jae    800a31 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a28:	38 08                	cmp    %cl,(%eax)
  800a2a:	74 05                	je     800a31 <memfind+0x1b>
	for (; s < ends; s++)
  800a2c:	83 c0 01             	add    $0x1,%eax
  800a2f:	eb f3                	jmp    800a24 <memfind+0xe>
			break;
	return (void *) s;
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	57                   	push   %edi
  800a37:	56                   	push   %esi
  800a38:	53                   	push   %ebx
  800a39:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3f:	eb 03                	jmp    800a44 <strtol+0x11>
		s++;
  800a41:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a44:	0f b6 01             	movzbl (%ecx),%eax
  800a47:	3c 20                	cmp    $0x20,%al
  800a49:	74 f6                	je     800a41 <strtol+0xe>
  800a4b:	3c 09                	cmp    $0x9,%al
  800a4d:	74 f2                	je     800a41 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a4f:	3c 2b                	cmp    $0x2b,%al
  800a51:	74 2e                	je     800a81 <strtol+0x4e>
	int neg = 0;
  800a53:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a58:	3c 2d                	cmp    $0x2d,%al
  800a5a:	74 2f                	je     800a8b <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a62:	75 05                	jne    800a69 <strtol+0x36>
  800a64:	80 39 30             	cmpb   $0x30,(%ecx)
  800a67:	74 2c                	je     800a95 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a69:	85 db                	test   %ebx,%ebx
  800a6b:	75 0a                	jne    800a77 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a6d:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a72:	80 39 30             	cmpb   $0x30,(%ecx)
  800a75:	74 28                	je     800a9f <strtol+0x6c>
		base = 10;
  800a77:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7c:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a7f:	eb 50                	jmp    800ad1 <strtol+0x9e>
		s++;
  800a81:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a84:	bf 00 00 00 00       	mov    $0x0,%edi
  800a89:	eb d1                	jmp    800a5c <strtol+0x29>
		s++, neg = 1;
  800a8b:	83 c1 01             	add    $0x1,%ecx
  800a8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a93:	eb c7                	jmp    800a5c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a95:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a99:	74 0e                	je     800aa9 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a9b:	85 db                	test   %ebx,%ebx
  800a9d:	75 d8                	jne    800a77 <strtol+0x44>
		s++, base = 8;
  800a9f:	83 c1 01             	add    $0x1,%ecx
  800aa2:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aa7:	eb ce                	jmp    800a77 <strtol+0x44>
		s += 2, base = 16;
  800aa9:	83 c1 02             	add    $0x2,%ecx
  800aac:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ab1:	eb c4                	jmp    800a77 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ab6:	89 f3                	mov    %esi,%ebx
  800ab8:	80 fb 19             	cmp    $0x19,%bl
  800abb:	77 29                	ja     800ae6 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800abd:	0f be d2             	movsbl %dl,%edx
  800ac0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac6:	7d 30                	jge    800af8 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ac8:	83 c1 01             	add    $0x1,%ecx
  800acb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800acf:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad1:	0f b6 11             	movzbl (%ecx),%edx
  800ad4:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ad7:	89 f3                	mov    %esi,%ebx
  800ad9:	80 fb 09             	cmp    $0x9,%bl
  800adc:	77 d5                	ja     800ab3 <strtol+0x80>
			dig = *s - '0';
  800ade:	0f be d2             	movsbl %dl,%edx
  800ae1:	83 ea 30             	sub    $0x30,%edx
  800ae4:	eb dd                	jmp    800ac3 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ae6:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae9:	89 f3                	mov    %esi,%ebx
  800aeb:	80 fb 19             	cmp    $0x19,%bl
  800aee:	77 08                	ja     800af8 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800af0:	0f be d2             	movsbl %dl,%edx
  800af3:	83 ea 37             	sub    $0x37,%edx
  800af6:	eb cb                	jmp    800ac3 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afc:	74 05                	je     800b03 <strtol+0xd0>
		*endptr = (char *) s;
  800afe:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b01:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	f7 da                	neg    %edx
  800b07:	85 ff                	test   %edi,%edi
  800b09:	0f 45 c2             	cmovne %edx,%eax
}
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	57                   	push   %edi
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b22:	89 c3                	mov    %eax,%ebx
  800b24:	89 c7                	mov    %eax,%edi
  800b26:	89 c6                	mov    %eax,%esi
  800b28:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2a:	5b                   	pop    %ebx
  800b2b:	5e                   	pop    %esi
  800b2c:	5f                   	pop    %edi
  800b2d:	5d                   	pop    %ebp
  800b2e:	c3                   	ret    

00800b2f <sys_cgetc>:

int
sys_cgetc(void)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	57                   	push   %edi
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b35:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b3f:	89 d1                	mov    %edx,%ecx
  800b41:	89 d3                	mov    %edx,%ebx
  800b43:	89 d7                	mov    %edx,%edi
  800b45:	89 d6                	mov    %edx,%esi
  800b47:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b49:	5b                   	pop    %ebx
  800b4a:	5e                   	pop    %esi
  800b4b:	5f                   	pop    %edi
  800b4c:	5d                   	pop    %ebp
  800b4d:	c3                   	ret    

00800b4e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	57                   	push   %edi
  800b52:	56                   	push   %esi
  800b53:	53                   	push   %ebx
  800b54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b57:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b64:	89 cb                	mov    %ecx,%ebx
  800b66:	89 cf                	mov    %ecx,%edi
  800b68:	89 ce                	mov    %ecx,%esi
  800b6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b6c:	85 c0                	test   %eax,%eax
  800b6e:	7f 08                	jg     800b78 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b73:	5b                   	pop    %ebx
  800b74:	5e                   	pop    %esi
  800b75:	5f                   	pop    %edi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b78:	83 ec 0c             	sub    $0xc,%esp
  800b7b:	50                   	push   %eax
  800b7c:	6a 03                	push   $0x3
  800b7e:	68 1f 29 80 00       	push   $0x80291f
  800b83:	6a 23                	push   $0x23
  800b85:	68 3c 29 80 00       	push   $0x80293c
  800b8a:	e8 00 17 00 00       	call   80228f <_panic>

00800b8f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	57                   	push   %edi
  800b93:	56                   	push   %esi
  800b94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b95:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b9f:	89 d1                	mov    %edx,%ecx
  800ba1:	89 d3                	mov    %edx,%ebx
  800ba3:	89 d7                	mov    %edx,%edi
  800ba5:	89 d6                	mov    %edx,%esi
  800ba7:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ba9:	5b                   	pop    %ebx
  800baa:	5e                   	pop    %esi
  800bab:	5f                   	pop    %edi
  800bac:	5d                   	pop    %ebp
  800bad:	c3                   	ret    

00800bae <sys_yield>:

void
sys_yield(void)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	57                   	push   %edi
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bbe:	89 d1                	mov    %edx,%ecx
  800bc0:	89 d3                	mov    %edx,%ebx
  800bc2:	89 d7                	mov    %edx,%edi
  800bc4:	89 d6                	mov    %edx,%esi
  800bc6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bc8:	5b                   	pop    %ebx
  800bc9:	5e                   	pop    %esi
  800bca:	5f                   	pop    %edi
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bd6:	be 00 00 00 00       	mov    $0x0,%esi
  800bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be1:	b8 04 00 00 00       	mov    $0x4,%eax
  800be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800be9:	89 f7                	mov    %esi,%edi
  800beb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bed:	85 c0                	test   %eax,%eax
  800bef:	7f 08                	jg     800bf9 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	50                   	push   %eax
  800bfd:	6a 04                	push   $0x4
  800bff:	68 1f 29 80 00       	push   $0x80291f
  800c04:	6a 23                	push   $0x23
  800c06:	68 3c 29 80 00       	push   $0x80293c
  800c0b:	e8 7f 16 00 00       	call   80228f <_panic>

00800c10 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1f:	b8 05 00 00 00       	mov    $0x5,%eax
  800c24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c27:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c2a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c2d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	7f 08                	jg     800c3b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c36:	5b                   	pop    %ebx
  800c37:	5e                   	pop    %esi
  800c38:	5f                   	pop    %edi
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3b:	83 ec 0c             	sub    $0xc,%esp
  800c3e:	50                   	push   %eax
  800c3f:	6a 05                	push   $0x5
  800c41:	68 1f 29 80 00       	push   $0x80291f
  800c46:	6a 23                	push   $0x23
  800c48:	68 3c 29 80 00       	push   $0x80293c
  800c4d:	e8 3d 16 00 00       	call   80228f <_panic>

00800c52 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c60:	8b 55 08             	mov    0x8(%ebp),%edx
  800c63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c66:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6b:	89 df                	mov    %ebx,%edi
  800c6d:	89 de                	mov    %ebx,%esi
  800c6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	7f 08                	jg     800c7d <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7d:	83 ec 0c             	sub    $0xc,%esp
  800c80:	50                   	push   %eax
  800c81:	6a 06                	push   $0x6
  800c83:	68 1f 29 80 00       	push   $0x80291f
  800c88:	6a 23                	push   $0x23
  800c8a:	68 3c 29 80 00       	push   $0x80293c
  800c8f:	e8 fb 15 00 00       	call   80228f <_panic>

00800c94 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
  800c9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	b8 08 00 00 00       	mov    $0x8,%eax
  800cad:	89 df                	mov    %ebx,%edi
  800caf:	89 de                	mov    %ebx,%esi
  800cb1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	7f 08                	jg     800cbf <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cba:	5b                   	pop    %ebx
  800cbb:	5e                   	pop    %esi
  800cbc:	5f                   	pop    %edi
  800cbd:	5d                   	pop    %ebp
  800cbe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbf:	83 ec 0c             	sub    $0xc,%esp
  800cc2:	50                   	push   %eax
  800cc3:	6a 08                	push   $0x8
  800cc5:	68 1f 29 80 00       	push   $0x80291f
  800cca:	6a 23                	push   $0x23
  800ccc:	68 3c 29 80 00       	push   $0x80293c
  800cd1:	e8 b9 15 00 00       	call   80228f <_panic>

00800cd6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cea:	b8 09 00 00 00       	mov    $0x9,%eax
  800cef:	89 df                	mov    %ebx,%edi
  800cf1:	89 de                	mov    %ebx,%esi
  800cf3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf5:	85 c0                	test   %eax,%eax
  800cf7:	7f 08                	jg     800d01 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfc:	5b                   	pop    %ebx
  800cfd:	5e                   	pop    %esi
  800cfe:	5f                   	pop    %edi
  800cff:	5d                   	pop    %ebp
  800d00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d01:	83 ec 0c             	sub    $0xc,%esp
  800d04:	50                   	push   %eax
  800d05:	6a 09                	push   $0x9
  800d07:	68 1f 29 80 00       	push   $0x80291f
  800d0c:	6a 23                	push   $0x23
  800d0e:	68 3c 29 80 00       	push   $0x80293c
  800d13:	e8 77 15 00 00       	call   80228f <_panic>

00800d18 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	57                   	push   %edi
  800d1c:	56                   	push   %esi
  800d1d:	53                   	push   %ebx
  800d1e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d31:	89 df                	mov    %ebx,%edi
  800d33:	89 de                	mov    %ebx,%esi
  800d35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d37:	85 c0                	test   %eax,%eax
  800d39:	7f 08                	jg     800d43 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	83 ec 0c             	sub    $0xc,%esp
  800d46:	50                   	push   %eax
  800d47:	6a 0a                	push   $0xa
  800d49:	68 1f 29 80 00       	push   $0x80291f
  800d4e:	6a 23                	push   $0x23
  800d50:	68 3c 29 80 00       	push   $0x80293c
  800d55:	e8 35 15 00 00       	call   80228f <_panic>

00800d5a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d6b:	be 00 00 00 00       	mov    $0x0,%esi
  800d70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d73:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d76:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d93:	89 cb                	mov    %ecx,%ebx
  800d95:	89 cf                	mov    %ecx,%edi
  800d97:	89 ce                	mov    %ecx,%esi
  800d99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9b:	85 c0                	test   %eax,%eax
  800d9d:	7f 08                	jg     800da7 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da7:	83 ec 0c             	sub    $0xc,%esp
  800daa:	50                   	push   %eax
  800dab:	6a 0d                	push   $0xd
  800dad:	68 1f 29 80 00       	push   $0x80291f
  800db2:	6a 23                	push   $0x23
  800db4:	68 3c 29 80 00       	push   $0x80293c
  800db9:	e8 d1 14 00 00       	call   80228f <_panic>

00800dbe <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dbe:	55                   	push   %ebp
  800dbf:	89 e5                	mov    %esp,%ebp
  800dc1:	57                   	push   %edi
  800dc2:	56                   	push   %esi
  800dc3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dce:	89 d1                	mov    %edx,%ecx
  800dd0:	89 d3                	mov    %edx,%ebx
  800dd2:	89 d7                	mov    %edx,%edi
  800dd4:	89 d6                	mov    %edx,%esi
  800dd6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800de5:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800de7:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800deb:	74 7f                	je     800e6c <pgfault+0x8f>
  800ded:	89 d8                	mov    %ebx,%eax
  800def:	c1 e8 0c             	shr    $0xc,%eax
  800df2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800df9:	f6 c4 08             	test   $0x8,%ah
  800dfc:	74 6e                	je     800e6c <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800dfe:	e8 8c fd ff ff       	call   800b8f <sys_getenvid>
  800e03:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e05:	83 ec 04             	sub    $0x4,%esp
  800e08:	6a 07                	push   $0x7
  800e0a:	68 00 f0 7f 00       	push   $0x7ff000
  800e0f:	50                   	push   %eax
  800e10:	e8 b8 fd ff ff       	call   800bcd <sys_page_alloc>
  800e15:	83 c4 10             	add    $0x10,%esp
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	78 64                	js     800e80 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800e1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	68 00 10 00 00       	push   $0x1000
  800e2a:	53                   	push   %ebx
  800e2b:	68 00 f0 7f 00       	push   $0x7ff000
  800e30:	e8 2d fb ff ff       	call   800962 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800e35:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e3c:	53                   	push   %ebx
  800e3d:	56                   	push   %esi
  800e3e:	68 00 f0 7f 00       	push   $0x7ff000
  800e43:	56                   	push   %esi
  800e44:	e8 c7 fd ff ff       	call   800c10 <sys_page_map>
  800e49:	83 c4 20             	add    $0x20,%esp
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	78 42                	js     800e92 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e50:	83 ec 08             	sub    $0x8,%esp
  800e53:	68 00 f0 7f 00       	push   $0x7ff000
  800e58:	56                   	push   %esi
  800e59:	e8 f4 fd ff ff       	call   800c52 <sys_page_unmap>
  800e5e:	83 c4 10             	add    $0x10,%esp
  800e61:	85 c0                	test   %eax,%eax
  800e63:	78 3f                	js     800ea4 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800e65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800e6c:	83 ec 04             	sub    $0x4,%esp
  800e6f:	68 4c 29 80 00       	push   $0x80294c
  800e74:	6a 1d                	push   $0x1d
  800e76:	68 db 29 80 00       	push   $0x8029db
  800e7b:	e8 0f 14 00 00       	call   80228f <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800e80:	50                   	push   %eax
  800e81:	68 74 29 80 00       	push   $0x802974
  800e86:	6a 28                	push   $0x28
  800e88:	68 db 29 80 00       	push   $0x8029db
  800e8d:	e8 fd 13 00 00       	call   80228f <_panic>
		panic("pgfault:page map failed: %e", r);
  800e92:	50                   	push   %eax
  800e93:	68 e6 29 80 00       	push   $0x8029e6
  800e98:	6a 2c                	push   $0x2c
  800e9a:	68 db 29 80 00       	push   $0x8029db
  800e9f:	e8 eb 13 00 00       	call   80228f <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800ea4:	50                   	push   %eax
  800ea5:	68 98 29 80 00       	push   $0x802998
  800eaa:	6a 2e                	push   $0x2e
  800eac:	68 db 29 80 00       	push   $0x8029db
  800eb1:	e8 d9 13 00 00       	call   80228f <_panic>

00800eb6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
  800ebc:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800ebf:	68 dd 0d 80 00       	push   $0x800ddd
  800ec4:	e8 0c 14 00 00       	call   8022d5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ec9:	b8 07 00 00 00       	mov    $0x7,%eax
  800ece:	cd 30                	int    $0x30
  800ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800ed3:	83 c4 10             	add    $0x10,%esp
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	78 2f                	js     800f09 <fork+0x53>
  800eda:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800edc:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800ee1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ee5:	75 6e                	jne    800f55 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ee7:	e8 a3 fc ff ff       	call   800b8f <sys_getenvid>
  800eec:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ef1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800ef4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ef9:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800efe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800f09:	50                   	push   %eax
  800f0a:	68 b8 29 80 00       	push   $0x8029b8
  800f0f:	6a 6e                	push   $0x6e
  800f11:	68 db 29 80 00       	push   $0x8029db
  800f16:	e8 74 13 00 00       	call   80228f <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800f1b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f22:	83 ec 0c             	sub    $0xc,%esp
  800f25:	25 07 0e 00 00       	and    $0xe07,%eax
  800f2a:	50                   	push   %eax
  800f2b:	56                   	push   %esi
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	6a 00                	push   $0x0
  800f30:	e8 db fc ff ff       	call   800c10 <sys_page_map>
  800f35:	83 c4 20             	add    $0x20,%esp
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3f:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	78 bb                	js     800f01 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f46:	83 c3 01             	add    $0x1,%ebx
  800f49:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  800f4f:	0f 84 a6 00 00 00    	je     800ffb <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  800f55:	89 d8                	mov    %ebx,%eax
  800f57:	c1 e8 0a             	shr    $0xa,%eax
  800f5a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f61:	a8 01                	test   $0x1,%al
  800f63:	74 e1                	je     800f46 <fork+0x90>
  800f65:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f6c:	a8 01                	test   $0x1,%al
  800f6e:	74 d6                	je     800f46 <fork+0x90>
  800f70:	89 de                	mov    %ebx,%esi
  800f72:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  800f75:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f7c:	f6 c4 04             	test   $0x4,%ah
  800f7f:	75 9a                	jne    800f1b <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  800f81:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f88:	a8 02                	test   $0x2,%al
  800f8a:	75 0c                	jne    800f98 <fork+0xe2>
  800f8c:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f93:	f6 c4 08             	test   $0x8,%ah
  800f96:	74 42                	je     800fda <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	68 05 08 00 00       	push   $0x805
  800fa0:	56                   	push   %esi
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	6a 00                	push   $0x0
  800fa5:	e8 66 fc ff ff       	call   800c10 <sys_page_map>
  800faa:	83 c4 20             	add    $0x20,%esp
  800fad:	85 c0                	test   %eax,%eax
  800faf:	0f 88 4c ff ff ff    	js     800f01 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800fb5:	83 ec 0c             	sub    $0xc,%esp
  800fb8:	68 05 08 00 00       	push   $0x805
  800fbd:	56                   	push   %esi
  800fbe:	6a 00                	push   $0x0
  800fc0:	56                   	push   %esi
  800fc1:	6a 00                	push   $0x0
  800fc3:	e8 48 fc ff ff       	call   800c10 <sys_page_map>
  800fc8:	83 c4 20             	add    $0x20,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd2:	0f 4f c1             	cmovg  %ecx,%eax
  800fd5:	e9 68 ff ff ff       	jmp    800f42 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  800fda:	83 ec 0c             	sub    $0xc,%esp
  800fdd:	6a 05                	push   $0x5
  800fdf:	56                   	push   %esi
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	6a 00                	push   $0x0
  800fe4:	e8 27 fc ff ff       	call   800c10 <sys_page_map>
  800fe9:	83 c4 20             	add    $0x20,%esp
  800fec:	85 c0                	test   %eax,%eax
  800fee:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff3:	0f 4f c1             	cmovg  %ecx,%eax
  800ff6:	e9 47 ff ff ff       	jmp    800f42 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  800ffb:	83 ec 04             	sub    $0x4,%esp
  800ffe:	6a 07                	push   $0x7
  801000:	68 00 f0 bf ee       	push   $0xeebff000
  801005:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801008:	57                   	push   %edi
  801009:	e8 bf fb ff ff       	call   800bcd <sys_page_alloc>
  80100e:	83 c4 10             	add    $0x10,%esp
  801011:	85 c0                	test   %eax,%eax
  801013:	0f 88 e8 fe ff ff    	js     800f01 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801019:	83 ec 08             	sub    $0x8,%esp
  80101c:	68 3a 23 80 00       	push   $0x80233a
  801021:	57                   	push   %edi
  801022:	e8 f1 fc ff ff       	call   800d18 <sys_env_set_pgfault_upcall>
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	85 c0                	test   %eax,%eax
  80102c:	0f 88 cf fe ff ff    	js     800f01 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801032:	83 ec 08             	sub    $0x8,%esp
  801035:	6a 02                	push   $0x2
  801037:	57                   	push   %edi
  801038:	e8 57 fc ff ff       	call   800c94 <sys_env_set_status>
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	85 c0                	test   %eax,%eax
  801042:	78 08                	js     80104c <fork+0x196>
	return eid;
  801044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801047:	e9 b5 fe ff ff       	jmp    800f01 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  80104c:	50                   	push   %eax
  80104d:	68 02 2a 80 00       	push   $0x802a02
  801052:	68 87 00 00 00       	push   $0x87
  801057:	68 db 29 80 00       	push   $0x8029db
  80105c:	e8 2e 12 00 00       	call   80228f <_panic>

00801061 <sfork>:

// Challenge!
int sfork(void)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801067:	68 20 2a 80 00       	push   $0x802a20
  80106c:	68 8f 00 00 00       	push   $0x8f
  801071:	68 db 29 80 00       	push   $0x8029db
  801076:	e8 14 12 00 00       	call   80228f <_panic>

0080107b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
  801080:	8b 75 08             	mov    0x8(%ebp),%esi
  801083:	8b 45 0c             	mov    0xc(%ebp),%eax
  801086:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801089:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80108b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801090:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801093:	83 ec 0c             	sub    $0xc,%esp
  801096:	50                   	push   %eax
  801097:	e8 e1 fc ff ff       	call   800d7d <sys_ipc_recv>
	if (from_env_store)
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	85 f6                	test   %esi,%esi
  8010a1:	74 14                	je     8010b7 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8010a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	78 09                	js     8010b5 <ipc_recv+0x3a>
  8010ac:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8010b2:	8b 52 74             	mov    0x74(%edx),%edx
  8010b5:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8010b7:	85 db                	test   %ebx,%ebx
  8010b9:	74 14                	je     8010cf <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8010bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 09                	js     8010cd <ipc_recv+0x52>
  8010c4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8010ca:	8b 52 78             	mov    0x78(%edx),%edx
  8010cd:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	78 08                	js     8010db <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8010d3:	a1 08 40 80 00       	mov    0x804008,%eax
  8010d8:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8010db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	57                   	push   %edi
  8010e6:	56                   	push   %esi
  8010e7:	53                   	push   %ebx
  8010e8:	83 ec 0c             	sub    $0xc,%esp
  8010eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8010f4:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8010f6:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8010fb:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8010fe:	ff 75 14             	pushl  0x14(%ebp)
  801101:	53                   	push   %ebx
  801102:	56                   	push   %esi
  801103:	57                   	push   %edi
  801104:	e8 51 fc ff ff       	call   800d5a <sys_ipc_try_send>
		if (ret == 0)
  801109:	83 c4 10             	add    $0x10,%esp
  80110c:	85 c0                	test   %eax,%eax
  80110e:	74 1e                	je     80112e <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801110:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801113:	75 07                	jne    80111c <ipc_send+0x3a>
			sys_yield();
  801115:	e8 94 fa ff ff       	call   800bae <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80111a:	eb e2                	jmp    8010fe <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80111c:	50                   	push   %eax
  80111d:	68 36 2a 80 00       	push   $0x802a36
  801122:	6a 3d                	push   $0x3d
  801124:	68 4a 2a 80 00       	push   $0x802a4a
  801129:	e8 61 11 00 00       	call   80228f <_panic>
	}
	// panic("ipc_send not implemented");
}
  80112e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801131:	5b                   	pop    %ebx
  801132:	5e                   	pop    %esi
  801133:	5f                   	pop    %edi
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80113c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801141:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801144:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80114a:	8b 52 50             	mov    0x50(%edx),%edx
  80114d:	39 ca                	cmp    %ecx,%edx
  80114f:	74 11                	je     801162 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801151:	83 c0 01             	add    $0x1,%eax
  801154:	3d 00 04 00 00       	cmp    $0x400,%eax
  801159:	75 e6                	jne    801141 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80115b:	b8 00 00 00 00       	mov    $0x0,%eax
  801160:	eb 0b                	jmp    80116d <ipc_find_env+0x37>
			return envs[i].env_id;
  801162:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801165:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80116a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	05 00 00 00 30       	add    $0x30000000,%eax
  80117a:	c1 e8 0c             	shr    $0xc,%eax
}
  80117d:	5d                   	pop    %ebp
  80117e:	c3                   	ret    

0080117f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80118a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80118f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	c1 ea 16             	shr    $0x16,%edx
  8011a6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ad:	f6 c2 01             	test   $0x1,%dl
  8011b0:	74 2a                	je     8011dc <fd_alloc+0x46>
  8011b2:	89 c2                	mov    %eax,%edx
  8011b4:	c1 ea 0c             	shr    $0xc,%edx
  8011b7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011be:	f6 c2 01             	test   $0x1,%dl
  8011c1:	74 19                	je     8011dc <fd_alloc+0x46>
  8011c3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011c8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011cd:	75 d2                	jne    8011a1 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011cf:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011d5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011da:	eb 07                	jmp    8011e3 <fd_alloc+0x4d>
			*fd_store = fd;
  8011dc:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011eb:	83 f8 1f             	cmp    $0x1f,%eax
  8011ee:	77 36                	ja     801226 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011f0:	c1 e0 0c             	shl    $0xc,%eax
  8011f3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011f8:	89 c2                	mov    %eax,%edx
  8011fa:	c1 ea 16             	shr    $0x16,%edx
  8011fd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801204:	f6 c2 01             	test   $0x1,%dl
  801207:	74 24                	je     80122d <fd_lookup+0x48>
  801209:	89 c2                	mov    %eax,%edx
  80120b:	c1 ea 0c             	shr    $0xc,%edx
  80120e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801215:	f6 c2 01             	test   $0x1,%dl
  801218:	74 1a                	je     801234 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80121a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121d:	89 02                	mov    %eax,(%edx)
	return 0;
  80121f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801224:	5d                   	pop    %ebp
  801225:	c3                   	ret    
		return -E_INVAL;
  801226:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80122b:	eb f7                	jmp    801224 <fd_lookup+0x3f>
		return -E_INVAL;
  80122d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801232:	eb f0                	jmp    801224 <fd_lookup+0x3f>
  801234:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801239:	eb e9                	jmp    801224 <fd_lookup+0x3f>

0080123b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 08             	sub    $0x8,%esp
  801241:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801244:	ba d0 2a 80 00       	mov    $0x802ad0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801249:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80124e:	39 08                	cmp    %ecx,(%eax)
  801250:	74 33                	je     801285 <dev_lookup+0x4a>
  801252:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801255:	8b 02                	mov    (%edx),%eax
  801257:	85 c0                	test   %eax,%eax
  801259:	75 f3                	jne    80124e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80125b:	a1 08 40 80 00       	mov    0x804008,%eax
  801260:	8b 40 48             	mov    0x48(%eax),%eax
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	51                   	push   %ecx
  801267:	50                   	push   %eax
  801268:	68 54 2a 80 00       	push   $0x802a54
  80126d:	e8 43 ef ff ff       	call   8001b5 <cprintf>
	*dev = 0;
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80127b:	83 c4 10             	add    $0x10,%esp
  80127e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    
			*dev = devtab[i];
  801285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801288:	89 01                	mov    %eax,(%ecx)
			return 0;
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
  80128f:	eb f2                	jmp    801283 <dev_lookup+0x48>

00801291 <fd_close>:
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	57                   	push   %edi
  801295:	56                   	push   %esi
  801296:	53                   	push   %ebx
  801297:	83 ec 1c             	sub    $0x1c,%esp
  80129a:	8b 75 08             	mov    0x8(%ebp),%esi
  80129d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012aa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012ad:	50                   	push   %eax
  8012ae:	e8 32 ff ff ff       	call   8011e5 <fd_lookup>
  8012b3:	89 c3                	mov    %eax,%ebx
  8012b5:	83 c4 08             	add    $0x8,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 05                	js     8012c1 <fd_close+0x30>
	    || fd != fd2)
  8012bc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012bf:	74 16                	je     8012d7 <fd_close+0x46>
		return (must_exist ? r : 0);
  8012c1:	89 f8                	mov    %edi,%eax
  8012c3:	84 c0                	test   %al,%al
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ca:	0f 44 d8             	cmove  %eax,%ebx
}
  8012cd:	89 d8                	mov    %ebx,%eax
  8012cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012d7:	83 ec 08             	sub    $0x8,%esp
  8012da:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012dd:	50                   	push   %eax
  8012de:	ff 36                	pushl  (%esi)
  8012e0:	e8 56 ff ff ff       	call   80123b <dev_lookup>
  8012e5:	89 c3                	mov    %eax,%ebx
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 15                	js     801303 <fd_close+0x72>
		if (dev->dev_close)
  8012ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012f1:	8b 40 10             	mov    0x10(%eax),%eax
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	74 1b                	je     801313 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8012f8:	83 ec 0c             	sub    $0xc,%esp
  8012fb:	56                   	push   %esi
  8012fc:	ff d0                	call   *%eax
  8012fe:	89 c3                	mov    %eax,%ebx
  801300:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	56                   	push   %esi
  801307:	6a 00                	push   $0x0
  801309:	e8 44 f9 ff ff       	call   800c52 <sys_page_unmap>
	return r;
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	eb ba                	jmp    8012cd <fd_close+0x3c>
			r = 0;
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
  801318:	eb e9                	jmp    801303 <fd_close+0x72>

0080131a <close>:

int
close(int fdnum)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801320:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801323:	50                   	push   %eax
  801324:	ff 75 08             	pushl  0x8(%ebp)
  801327:	e8 b9 fe ff ff       	call   8011e5 <fd_lookup>
  80132c:	83 c4 08             	add    $0x8,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 10                	js     801343 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	6a 01                	push   $0x1
  801338:	ff 75 f4             	pushl  -0xc(%ebp)
  80133b:	e8 51 ff ff ff       	call   801291 <fd_close>
  801340:	83 c4 10             	add    $0x10,%esp
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <close_all>:

void
close_all(void)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	53                   	push   %ebx
  801349:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80134c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	53                   	push   %ebx
  801355:	e8 c0 ff ff ff       	call   80131a <close>
	for (i = 0; i < MAXFD; i++)
  80135a:	83 c3 01             	add    $0x1,%ebx
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	83 fb 20             	cmp    $0x20,%ebx
  801363:	75 ec                	jne    801351 <close_all+0xc>
}
  801365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
  801370:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801373:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801376:	50                   	push   %eax
  801377:	ff 75 08             	pushl  0x8(%ebp)
  80137a:	e8 66 fe ff ff       	call   8011e5 <fd_lookup>
  80137f:	89 c3                	mov    %eax,%ebx
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	0f 88 81 00 00 00    	js     80140d <dup+0xa3>
		return r;
	close(newfdnum);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 83 ff ff ff       	call   80131a <close>

	newfd = INDEX2FD(newfdnum);
  801397:	8b 75 0c             	mov    0xc(%ebp),%esi
  80139a:	c1 e6 0c             	shl    $0xc,%esi
  80139d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013a3:	83 c4 04             	add    $0x4,%esp
  8013a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013a9:	e8 d1 fd ff ff       	call   80117f <fd2data>
  8013ae:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013b0:	89 34 24             	mov    %esi,(%esp)
  8013b3:	e8 c7 fd ff ff       	call   80117f <fd2data>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	c1 e8 16             	shr    $0x16,%eax
  8013c2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013c9:	a8 01                	test   $0x1,%al
  8013cb:	74 11                	je     8013de <dup+0x74>
  8013cd:	89 d8                	mov    %ebx,%eax
  8013cf:	c1 e8 0c             	shr    $0xc,%eax
  8013d2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013d9:	f6 c2 01             	test   $0x1,%dl
  8013dc:	75 39                	jne    801417 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013e1:	89 d0                	mov    %edx,%eax
  8013e3:	c1 e8 0c             	shr    $0xc,%eax
  8013e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8013f5:	50                   	push   %eax
  8013f6:	56                   	push   %esi
  8013f7:	6a 00                	push   $0x0
  8013f9:	52                   	push   %edx
  8013fa:	6a 00                	push   $0x0
  8013fc:	e8 0f f8 ff ff       	call   800c10 <sys_page_map>
  801401:	89 c3                	mov    %eax,%ebx
  801403:	83 c4 20             	add    $0x20,%esp
  801406:	85 c0                	test   %eax,%eax
  801408:	78 31                	js     80143b <dup+0xd1>
		goto err;

	return newfdnum;
  80140a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80140d:	89 d8                	mov    %ebx,%eax
  80140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801417:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	25 07 0e 00 00       	and    $0xe07,%eax
  801426:	50                   	push   %eax
  801427:	57                   	push   %edi
  801428:	6a 00                	push   $0x0
  80142a:	53                   	push   %ebx
  80142b:	6a 00                	push   $0x0
  80142d:	e8 de f7 ff ff       	call   800c10 <sys_page_map>
  801432:	89 c3                	mov    %eax,%ebx
  801434:	83 c4 20             	add    $0x20,%esp
  801437:	85 c0                	test   %eax,%eax
  801439:	79 a3                	jns    8013de <dup+0x74>
	sys_page_unmap(0, newfd);
  80143b:	83 ec 08             	sub    $0x8,%esp
  80143e:	56                   	push   %esi
  80143f:	6a 00                	push   $0x0
  801441:	e8 0c f8 ff ff       	call   800c52 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801446:	83 c4 08             	add    $0x8,%esp
  801449:	57                   	push   %edi
  80144a:	6a 00                	push   $0x0
  80144c:	e8 01 f8 ff ff       	call   800c52 <sys_page_unmap>
	return r;
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	eb b7                	jmp    80140d <dup+0xa3>

00801456 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	53                   	push   %ebx
  80145a:	83 ec 14             	sub    $0x14,%esp
  80145d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801460:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	53                   	push   %ebx
  801465:	e8 7b fd ff ff       	call   8011e5 <fd_lookup>
  80146a:	83 c4 08             	add    $0x8,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 3f                	js     8014b0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801471:	83 ec 08             	sub    $0x8,%esp
  801474:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801477:	50                   	push   %eax
  801478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147b:	ff 30                	pushl  (%eax)
  80147d:	e8 b9 fd ff ff       	call   80123b <dev_lookup>
  801482:	83 c4 10             	add    $0x10,%esp
  801485:	85 c0                	test   %eax,%eax
  801487:	78 27                	js     8014b0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148c:	8b 42 08             	mov    0x8(%edx),%eax
  80148f:	83 e0 03             	and    $0x3,%eax
  801492:	83 f8 01             	cmp    $0x1,%eax
  801495:	74 1e                	je     8014b5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149a:	8b 40 08             	mov    0x8(%eax),%eax
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 35                	je     8014d6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014a1:	83 ec 04             	sub    $0x4,%esp
  8014a4:	ff 75 10             	pushl  0x10(%ebp)
  8014a7:	ff 75 0c             	pushl  0xc(%ebp)
  8014aa:	52                   	push   %edx
  8014ab:	ff d0                	call   *%eax
  8014ad:	83 c4 10             	add    $0x10,%esp
}
  8014b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b5:	a1 08 40 80 00       	mov    0x804008,%eax
  8014ba:	8b 40 48             	mov    0x48(%eax),%eax
  8014bd:	83 ec 04             	sub    $0x4,%esp
  8014c0:	53                   	push   %ebx
  8014c1:	50                   	push   %eax
  8014c2:	68 95 2a 80 00       	push   $0x802a95
  8014c7:	e8 e9 ec ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d4:	eb da                	jmp    8014b0 <read+0x5a>
		return -E_NOT_SUPP;
  8014d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014db:	eb d3                	jmp    8014b0 <read+0x5a>

008014dd <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	57                   	push   %edi
  8014e1:	56                   	push   %esi
  8014e2:	53                   	push   %ebx
  8014e3:	83 ec 0c             	sub    $0xc,%esp
  8014e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f1:	39 f3                	cmp    %esi,%ebx
  8014f3:	73 25                	jae    80151a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f5:	83 ec 04             	sub    $0x4,%esp
  8014f8:	89 f0                	mov    %esi,%eax
  8014fa:	29 d8                	sub    %ebx,%eax
  8014fc:	50                   	push   %eax
  8014fd:	89 d8                	mov    %ebx,%eax
  8014ff:	03 45 0c             	add    0xc(%ebp),%eax
  801502:	50                   	push   %eax
  801503:	57                   	push   %edi
  801504:	e8 4d ff ff ff       	call   801456 <read>
		if (m < 0)
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 08                	js     801518 <readn+0x3b>
			return m;
		if (m == 0)
  801510:	85 c0                	test   %eax,%eax
  801512:	74 06                	je     80151a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801514:	01 c3                	add    %eax,%ebx
  801516:	eb d9                	jmp    8014f1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801518:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80151a:	89 d8                	mov    %ebx,%eax
  80151c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5f                   	pop    %edi
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	53                   	push   %ebx
  801528:	83 ec 14             	sub    $0x14,%esp
  80152b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	53                   	push   %ebx
  801533:	e8 ad fc ff ff       	call   8011e5 <fd_lookup>
  801538:	83 c4 08             	add    $0x8,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 3a                	js     801579 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801549:	ff 30                	pushl  (%eax)
  80154b:	e8 eb fc ff ff       	call   80123b <dev_lookup>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 22                	js     801579 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155e:	74 1e                	je     80157e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801560:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801563:	8b 52 0c             	mov    0xc(%edx),%edx
  801566:	85 d2                	test   %edx,%edx
  801568:	74 35                	je     80159f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	ff 75 10             	pushl  0x10(%ebp)
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	50                   	push   %eax
  801574:	ff d2                	call   *%edx
  801576:	83 c4 10             	add    $0x10,%esp
}
  801579:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80157e:	a1 08 40 80 00       	mov    0x804008,%eax
  801583:	8b 40 48             	mov    0x48(%eax),%eax
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	53                   	push   %ebx
  80158a:	50                   	push   %eax
  80158b:	68 b1 2a 80 00       	push   $0x802ab1
  801590:	e8 20 ec ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159d:	eb da                	jmp    801579 <write+0x55>
		return -E_NOT_SUPP;
  80159f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a4:	eb d3                	jmp    801579 <write+0x55>

008015a6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ac:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	ff 75 08             	pushl  0x8(%ebp)
  8015b3:	e8 2d fc ff ff       	call   8011e5 <fd_lookup>
  8015b8:	83 c4 08             	add    $0x8,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 0e                	js     8015cd <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c5:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	53                   	push   %ebx
  8015d3:	83 ec 14             	sub    $0x14,%esp
  8015d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015dc:	50                   	push   %eax
  8015dd:	53                   	push   %ebx
  8015de:	e8 02 fc ff ff       	call   8011e5 <fd_lookup>
  8015e3:	83 c4 08             	add    $0x8,%esp
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 37                	js     801621 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ea:	83 ec 08             	sub    $0x8,%esp
  8015ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f0:	50                   	push   %eax
  8015f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f4:	ff 30                	pushl  (%eax)
  8015f6:	e8 40 fc ff ff       	call   80123b <dev_lookup>
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 1f                	js     801621 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801609:	74 1b                	je     801626 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80160b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160e:	8b 52 18             	mov    0x18(%edx),%edx
  801611:	85 d2                	test   %edx,%edx
  801613:	74 32                	je     801647 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	50                   	push   %eax
  80161c:	ff d2                	call   *%edx
  80161e:	83 c4 10             	add    $0x10,%esp
}
  801621:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801624:	c9                   	leave  
  801625:	c3                   	ret    
			thisenv->env_id, fdnum);
  801626:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80162b:	8b 40 48             	mov    0x48(%eax),%eax
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	53                   	push   %ebx
  801632:	50                   	push   %eax
  801633:	68 74 2a 80 00       	push   $0x802a74
  801638:	e8 78 eb ff ff       	call   8001b5 <cprintf>
		return -E_INVAL;
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801645:	eb da                	jmp    801621 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801647:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80164c:	eb d3                	jmp    801621 <ftruncate+0x52>

0080164e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	53                   	push   %ebx
  801652:	83 ec 14             	sub    $0x14,%esp
  801655:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801658:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	e8 81 fb ff ff       	call   8011e5 <fd_lookup>
  801664:	83 c4 08             	add    $0x8,%esp
  801667:	85 c0                	test   %eax,%eax
  801669:	78 4b                	js     8016b6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166b:	83 ec 08             	sub    $0x8,%esp
  80166e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801675:	ff 30                	pushl  (%eax)
  801677:	e8 bf fb ff ff       	call   80123b <dev_lookup>
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	85 c0                	test   %eax,%eax
  801681:	78 33                	js     8016b6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801686:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80168a:	74 2f                	je     8016bb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80168c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80168f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801696:	00 00 00 
	stat->st_isdir = 0;
  801699:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016a0:	00 00 00 
	stat->st_dev = dev;
  8016a3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016a9:	83 ec 08             	sub    $0x8,%esp
  8016ac:	53                   	push   %ebx
  8016ad:	ff 75 f0             	pushl  -0x10(%ebp)
  8016b0:	ff 50 14             	call   *0x14(%eax)
  8016b3:	83 c4 10             	add    $0x10,%esp
}
  8016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    
		return -E_NOT_SUPP;
  8016bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016c0:	eb f4                	jmp    8016b6 <fstat+0x68>

008016c2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	6a 00                	push   $0x0
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	e8 e7 01 00 00       	call   8018bb <open>
  8016d4:	89 c3                	mov    %eax,%ebx
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	78 1b                	js     8016f8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	50                   	push   %eax
  8016e4:	e8 65 ff ff ff       	call   80164e <fstat>
  8016e9:	89 c6                	mov    %eax,%esi
	close(fd);
  8016eb:	89 1c 24             	mov    %ebx,(%esp)
  8016ee:	e8 27 fc ff ff       	call   80131a <close>
	return r;
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	89 f3                	mov    %esi,%ebx
}
  8016f8:	89 d8                	mov    %ebx,%eax
  8016fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	56                   	push   %esi
  801705:	53                   	push   %ebx
  801706:	89 c6                	mov    %eax,%esi
  801708:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80170a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801711:	74 27                	je     80173a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801713:	6a 07                	push   $0x7
  801715:	68 00 50 80 00       	push   $0x805000
  80171a:	56                   	push   %esi
  80171b:	ff 35 00 40 80 00    	pushl  0x804000
  801721:	e8 bc f9 ff ff       	call   8010e2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801726:	83 c4 0c             	add    $0xc,%esp
  801729:	6a 00                	push   $0x0
  80172b:	53                   	push   %ebx
  80172c:	6a 00                	push   $0x0
  80172e:	e8 48 f9 ff ff       	call   80107b <ipc_recv>
}
  801733:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801736:	5b                   	pop    %ebx
  801737:	5e                   	pop    %esi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	6a 01                	push   $0x1
  80173f:	e8 f2 f9 ff ff       	call   801136 <ipc_find_env>
  801744:	a3 00 40 80 00       	mov    %eax,0x804000
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	eb c5                	jmp    801713 <fsipc+0x12>

0080174e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 40 0c             	mov    0xc(%eax),%eax
  80175a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80175f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801762:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801767:	ba 00 00 00 00       	mov    $0x0,%edx
  80176c:	b8 02 00 00 00       	mov    $0x2,%eax
  801771:	e8 8b ff ff ff       	call   801701 <fsipc>
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <devfile_flush>:
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8b 40 0c             	mov    0xc(%eax),%eax
  801784:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801789:	ba 00 00 00 00       	mov    $0x0,%edx
  80178e:	b8 06 00 00 00       	mov    $0x6,%eax
  801793:	e8 69 ff ff ff       	call   801701 <fsipc>
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <devfile_stat>:
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	53                   	push   %ebx
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017aa:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017af:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8017b9:	e8 43 ff ff ff       	call   801701 <fsipc>
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 2c                	js     8017ee <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	68 00 50 80 00       	push   $0x805000
  8017ca:	53                   	push   %ebx
  8017cb:	e8 04 f0 ff ff       	call   8007d4 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017d0:	a1 80 50 80 00       	mov    0x805080,%eax
  8017d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017db:	a1 84 50 80 00       	mov    0x805084,%eax
  8017e0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <devfile_write>:
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fc:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801801:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801806:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801809:	8b 55 08             	mov    0x8(%ebp),%edx
  80180c:	8b 52 0c             	mov    0xc(%edx),%edx
  80180f:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801815:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80181a:	50                   	push   %eax
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	68 08 50 80 00       	push   $0x805008
  801823:	e8 3a f1 ff ff       	call   800962 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801828:	ba 00 00 00 00       	mov    $0x0,%edx
  80182d:	b8 04 00 00 00       	mov    $0x4,%eax
  801832:	e8 ca fe ff ff       	call   801701 <fsipc>
}
  801837:	c9                   	leave  
  801838:	c3                   	ret    

00801839 <devfile_read>:
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	56                   	push   %esi
  80183d:	53                   	push   %ebx
  80183e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8b 40 0c             	mov    0xc(%eax),%eax
  801847:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80184c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	b8 03 00 00 00       	mov    $0x3,%eax
  80185c:	e8 a0 fe ff ff       	call   801701 <fsipc>
  801861:	89 c3                	mov    %eax,%ebx
  801863:	85 c0                	test   %eax,%eax
  801865:	78 1f                	js     801886 <devfile_read+0x4d>
	assert(r <= n);
  801867:	39 f0                	cmp    %esi,%eax
  801869:	77 24                	ja     80188f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80186b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801870:	7f 33                	jg     8018a5 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	50                   	push   %eax
  801876:	68 00 50 80 00       	push   $0x805000
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	e8 df f0 ff ff       	call   800962 <memmove>
	return r;
  801883:	83 c4 10             	add    $0x10,%esp
}
  801886:	89 d8                	mov    %ebx,%eax
  801888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    
	assert(r <= n);
  80188f:	68 e4 2a 80 00       	push   $0x802ae4
  801894:	68 eb 2a 80 00       	push   $0x802aeb
  801899:	6a 7b                	push   $0x7b
  80189b:	68 00 2b 80 00       	push   $0x802b00
  8018a0:	e8 ea 09 00 00       	call   80228f <_panic>
	assert(r <= PGSIZE);
  8018a5:	68 0b 2b 80 00       	push   $0x802b0b
  8018aa:	68 eb 2a 80 00       	push   $0x802aeb
  8018af:	6a 7c                	push   $0x7c
  8018b1:	68 00 2b 80 00       	push   $0x802b00
  8018b6:	e8 d4 09 00 00       	call   80228f <_panic>

008018bb <open>:
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 1c             	sub    $0x1c,%esp
  8018c3:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018c6:	56                   	push   %esi
  8018c7:	e8 d1 ee ff ff       	call   80079d <strlen>
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d4:	7f 6c                	jg     801942 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018d6:	83 ec 0c             	sub    $0xc,%esp
  8018d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018dc:	50                   	push   %eax
  8018dd:	e8 b4 f8 ff ff       	call   801196 <fd_alloc>
  8018e2:	89 c3                	mov    %eax,%ebx
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	78 3c                	js     801927 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	56                   	push   %esi
  8018ef:	68 00 50 80 00       	push   $0x805000
  8018f4:	e8 db ee ff ff       	call   8007d4 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801904:	b8 01 00 00 00       	mov    $0x1,%eax
  801909:	e8 f3 fd ff ff       	call   801701 <fsipc>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	85 c0                	test   %eax,%eax
  801915:	78 19                	js     801930 <open+0x75>
	return fd2num(fd);
  801917:	83 ec 0c             	sub    $0xc,%esp
  80191a:	ff 75 f4             	pushl  -0xc(%ebp)
  80191d:	e8 4d f8 ff ff       	call   80116f <fd2num>
  801922:	89 c3                	mov    %eax,%ebx
  801924:	83 c4 10             	add    $0x10,%esp
}
  801927:	89 d8                	mov    %ebx,%eax
  801929:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192c:	5b                   	pop    %ebx
  80192d:	5e                   	pop    %esi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    
		fd_close(fd, 0);
  801930:	83 ec 08             	sub    $0x8,%esp
  801933:	6a 00                	push   $0x0
  801935:	ff 75 f4             	pushl  -0xc(%ebp)
  801938:	e8 54 f9 ff ff       	call   801291 <fd_close>
		return r;
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	eb e5                	jmp    801927 <open+0x6c>
		return -E_BAD_PATH;
  801942:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801947:	eb de                	jmp    801927 <open+0x6c>

00801949 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80194f:	ba 00 00 00 00       	mov    $0x0,%edx
  801954:	b8 08 00 00 00       	mov    $0x8,%eax
  801959:	e8 a3 fd ff ff       	call   801701 <fsipc>
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801966:	68 17 2b 80 00       	push   $0x802b17
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	e8 61 ee ff ff       	call   8007d4 <strcpy>
	return 0;
}
  801973:	b8 00 00 00 00       	mov    $0x0,%eax
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <devsock_close>:
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	53                   	push   %ebx
  80197e:	83 ec 10             	sub    $0x10,%esp
  801981:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801984:	53                   	push   %ebx
  801985:	e8 d6 09 00 00       	call   802360 <pageref>
  80198a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801992:	83 f8 01             	cmp    $0x1,%eax
  801995:	74 07                	je     80199e <devsock_close+0x24>
}
  801997:	89 d0                	mov    %edx,%eax
  801999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80199e:	83 ec 0c             	sub    $0xc,%esp
  8019a1:	ff 73 0c             	pushl  0xc(%ebx)
  8019a4:	e8 b7 02 00 00       	call   801c60 <nsipc_close>
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	eb e7                	jmp    801997 <devsock_close+0x1d>

008019b0 <devsock_write>:
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	ff 75 10             	pushl  0x10(%ebp)
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	ff 70 0c             	pushl  0xc(%eax)
  8019c4:	e8 74 03 00 00       	call   801d3d <nsipc_send>
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <devsock_read>:
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	ff 70 0c             	pushl  0xc(%eax)
  8019df:	e8 ed 02 00 00       	call   801cd1 <nsipc_recv>
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <fd2sockid>:
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ec:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019ef:	52                   	push   %edx
  8019f0:	50                   	push   %eax
  8019f1:	e8 ef f7 ff ff       	call   8011e5 <fd_lookup>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	85 c0                	test   %eax,%eax
  8019fb:	78 10                	js     801a0d <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a06:	39 08                	cmp    %ecx,(%eax)
  801a08:	75 05                	jne    801a0f <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a0a:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    
		return -E_NOT_SUPP;
  801a0f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a14:	eb f7                	jmp    801a0d <fd2sockid+0x27>

00801a16 <alloc_sockfd>:
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	56                   	push   %esi
  801a1a:	53                   	push   %ebx
  801a1b:	83 ec 1c             	sub    $0x1c,%esp
  801a1e:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a23:	50                   	push   %eax
  801a24:	e8 6d f7 ff ff       	call   801196 <fd_alloc>
  801a29:	89 c3                	mov    %eax,%ebx
  801a2b:	83 c4 10             	add    $0x10,%esp
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 43                	js     801a75 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a32:	83 ec 04             	sub    $0x4,%esp
  801a35:	68 07 04 00 00       	push   $0x407
  801a3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a3d:	6a 00                	push   $0x0
  801a3f:	e8 89 f1 ff ff       	call   800bcd <sys_page_alloc>
  801a44:	89 c3                	mov    %eax,%ebx
  801a46:	83 c4 10             	add    $0x10,%esp
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	78 28                	js     801a75 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a50:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a56:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801a62:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801a65:	83 ec 0c             	sub    $0xc,%esp
  801a68:	50                   	push   %eax
  801a69:	e8 01 f7 ff ff       	call   80116f <fd2num>
  801a6e:	89 c3                	mov    %eax,%ebx
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	eb 0c                	jmp    801a81 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a75:	83 ec 0c             	sub    $0xc,%esp
  801a78:	56                   	push   %esi
  801a79:	e8 e2 01 00 00       	call   801c60 <nsipc_close>
		return r;
  801a7e:	83 c4 10             	add    $0x10,%esp
}
  801a81:	89 d8                	mov    %ebx,%eax
  801a83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5e                   	pop    %esi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    

00801a8a <accept>:
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	e8 4e ff ff ff       	call   8019e6 <fd2sockid>
  801a98:	85 c0                	test   %eax,%eax
  801a9a:	78 1b                	js     801ab7 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a9c:	83 ec 04             	sub    $0x4,%esp
  801a9f:	ff 75 10             	pushl  0x10(%ebp)
  801aa2:	ff 75 0c             	pushl  0xc(%ebp)
  801aa5:	50                   	push   %eax
  801aa6:	e8 0e 01 00 00       	call   801bb9 <nsipc_accept>
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 05                	js     801ab7 <accept+0x2d>
	return alloc_sockfd(r);
  801ab2:	e8 5f ff ff ff       	call   801a16 <alloc_sockfd>
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <bind>:
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	e8 1f ff ff ff       	call   8019e6 <fd2sockid>
  801ac7:	85 c0                	test   %eax,%eax
  801ac9:	78 12                	js     801add <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	ff 75 10             	pushl  0x10(%ebp)
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	50                   	push   %eax
  801ad5:	e8 2f 01 00 00       	call   801c09 <nsipc_bind>
  801ada:	83 c4 10             	add    $0x10,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <shutdown>:
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	e8 f9 fe ff ff       	call   8019e6 <fd2sockid>
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 0f                	js     801b00 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	e8 41 01 00 00       	call   801c3e <nsipc_shutdown>
  801afd:	83 c4 10             	add    $0x10,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <connect>:
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	e8 d6 fe ff ff       	call   8019e6 <fd2sockid>
  801b10:	85 c0                	test   %eax,%eax
  801b12:	78 12                	js     801b26 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	ff 75 10             	pushl  0x10(%ebp)
  801b1a:	ff 75 0c             	pushl  0xc(%ebp)
  801b1d:	50                   	push   %eax
  801b1e:	e8 57 01 00 00       	call   801c7a <nsipc_connect>
  801b23:	83 c4 10             	add    $0x10,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <listen>:
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	e8 b0 fe ff ff       	call   8019e6 <fd2sockid>
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 0f                	js     801b49 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b3a:	83 ec 08             	sub    $0x8,%esp
  801b3d:	ff 75 0c             	pushl  0xc(%ebp)
  801b40:	50                   	push   %eax
  801b41:	e8 69 01 00 00       	call   801caf <nsipc_listen>
  801b46:	83 c4 10             	add    $0x10,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <socket>:

int
socket(int domain, int type, int protocol)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b51:	ff 75 10             	pushl  0x10(%ebp)
  801b54:	ff 75 0c             	pushl  0xc(%ebp)
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	e8 3c 02 00 00       	call   801d9b <nsipc_socket>
  801b5f:	83 c4 10             	add    $0x10,%esp
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 05                	js     801b6b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b66:	e8 ab fe ff ff       	call   801a16 <alloc_sockfd>
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	53                   	push   %ebx
  801b71:	83 ec 04             	sub    $0x4,%esp
  801b74:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b76:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b7d:	74 26                	je     801ba5 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b7f:	6a 07                	push   $0x7
  801b81:	68 00 60 80 00       	push   $0x806000
  801b86:	53                   	push   %ebx
  801b87:	ff 35 04 40 80 00    	pushl  0x804004
  801b8d:	e8 50 f5 ff ff       	call   8010e2 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b92:	83 c4 0c             	add    $0xc,%esp
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	e8 db f4 ff ff       	call   80107b <ipc_recv>
}
  801ba0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	6a 02                	push   $0x2
  801baa:	e8 87 f5 ff ff       	call   801136 <ipc_find_env>
  801baf:	a3 04 40 80 00       	mov    %eax,0x804004
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	eb c6                	jmp    801b7f <nsipc+0x12>

00801bb9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	56                   	push   %esi
  801bbd:	53                   	push   %ebx
  801bbe:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bc9:	8b 06                	mov    (%esi),%eax
  801bcb:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd5:	e8 93 ff ff ff       	call   801b6d <nsipc>
  801bda:	89 c3                	mov    %eax,%ebx
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 20                	js     801c00 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	ff 35 10 60 80 00    	pushl  0x806010
  801be9:	68 00 60 80 00       	push   $0x806000
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	e8 6c ed ff ff       	call   800962 <memmove>
		*addrlen = ret->ret_addrlen;
  801bf6:	a1 10 60 80 00       	mov    0x806010,%eax
  801bfb:	89 06                	mov    %eax,(%esi)
  801bfd:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c00:	89 d8                	mov    %ebx,%eax
  801c02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c05:	5b                   	pop    %ebx
  801c06:	5e                   	pop    %esi
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    

00801c09 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	53                   	push   %ebx
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c1b:	53                   	push   %ebx
  801c1c:	ff 75 0c             	pushl  0xc(%ebp)
  801c1f:	68 04 60 80 00       	push   $0x806004
  801c24:	e8 39 ed ff ff       	call   800962 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c29:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c2f:	b8 02 00 00 00       	mov    $0x2,%eax
  801c34:	e8 34 ff ff ff       	call   801b6d <nsipc>
}
  801c39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c54:	b8 03 00 00 00       	mov    $0x3,%eax
  801c59:	e8 0f ff ff ff       	call   801b6d <nsipc>
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <nsipc_close>:

int
nsipc_close(int s)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c6e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c73:	e8 f5 fe ff ff       	call   801b6d <nsipc>
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	53                   	push   %ebx
  801c7e:	83 ec 08             	sub    $0x8,%esp
  801c81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c8c:	53                   	push   %ebx
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	68 04 60 80 00       	push   $0x806004
  801c95:	e8 c8 ec ff ff       	call   800962 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c9a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  801ca5:	e8 c3 fe ff ff       	call   801b6d <nsipc>
}
  801caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cc5:	b8 06 00 00 00       	mov    $0x6,%eax
  801cca:	e8 9e fe ff ff       	call   801b6d <nsipc>
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ce1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cea:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cef:	b8 07 00 00 00       	mov    $0x7,%eax
  801cf4:	e8 74 fe ff ff       	call   801b6d <nsipc>
  801cf9:	89 c3                	mov    %eax,%ebx
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 1f                	js     801d1e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801cff:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d04:	7f 21                	jg     801d27 <nsipc_recv+0x56>
  801d06:	39 c6                	cmp    %eax,%esi
  801d08:	7c 1d                	jl     801d27 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d0a:	83 ec 04             	sub    $0x4,%esp
  801d0d:	50                   	push   %eax
  801d0e:	68 00 60 80 00       	push   $0x806000
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	e8 47 ec ff ff       	call   800962 <memmove>
  801d1b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d1e:	89 d8                	mov    %ebx,%eax
  801d20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d27:	68 23 2b 80 00       	push   $0x802b23
  801d2c:	68 eb 2a 80 00       	push   $0x802aeb
  801d31:	6a 62                	push   $0x62
  801d33:	68 38 2b 80 00       	push   $0x802b38
  801d38:	e8 52 05 00 00       	call   80228f <_panic>

00801d3d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	53                   	push   %ebx
  801d41:	83 ec 04             	sub    $0x4,%esp
  801d44:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d4f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d55:	7f 2e                	jg     801d85 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d57:	83 ec 04             	sub    $0x4,%esp
  801d5a:	53                   	push   %ebx
  801d5b:	ff 75 0c             	pushl  0xc(%ebp)
  801d5e:	68 0c 60 80 00       	push   $0x80600c
  801d63:	e8 fa eb ff ff       	call   800962 <memmove>
	nsipcbuf.send.req_size = size;
  801d68:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d71:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d76:	b8 08 00 00 00       	mov    $0x8,%eax
  801d7b:	e8 ed fd ff ff       	call   801b6d <nsipc>
}
  801d80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    
	assert(size < 1600);
  801d85:	68 44 2b 80 00       	push   $0x802b44
  801d8a:	68 eb 2a 80 00       	push   $0x802aeb
  801d8f:	6a 6d                	push   $0x6d
  801d91:	68 38 2b 80 00       	push   $0x802b38
  801d96:	e8 f4 04 00 00       	call   80228f <_panic>

00801d9b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dac:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801db1:	8b 45 10             	mov    0x10(%ebp),%eax
  801db4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801db9:	b8 09 00 00 00       	mov    $0x9,%eax
  801dbe:	e8 aa fd ff ff       	call   801b6d <nsipc>
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	56                   	push   %esi
  801dc9:	53                   	push   %ebx
  801dca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	ff 75 08             	pushl  0x8(%ebp)
  801dd3:	e8 a7 f3 ff ff       	call   80117f <fd2data>
  801dd8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dda:	83 c4 08             	add    $0x8,%esp
  801ddd:	68 50 2b 80 00       	push   $0x802b50
  801de2:	53                   	push   %ebx
  801de3:	e8 ec e9 ff ff       	call   8007d4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801de8:	8b 46 04             	mov    0x4(%esi),%eax
  801deb:	2b 06                	sub    (%esi),%eax
  801ded:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801df3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dfa:	00 00 00 
	stat->st_dev = &devpipe;
  801dfd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e04:	30 80 00 
	return 0;
}
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	53                   	push   %ebx
  801e17:	83 ec 0c             	sub    $0xc,%esp
  801e1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e1d:	53                   	push   %ebx
  801e1e:	6a 00                	push   $0x0
  801e20:	e8 2d ee ff ff       	call   800c52 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e25:	89 1c 24             	mov    %ebx,(%esp)
  801e28:	e8 52 f3 ff ff       	call   80117f <fd2data>
  801e2d:	83 c4 08             	add    $0x8,%esp
  801e30:	50                   	push   %eax
  801e31:	6a 00                	push   $0x0
  801e33:	e8 1a ee ff ff       	call   800c52 <sys_page_unmap>
}
  801e38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <_pipeisclosed>:
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	57                   	push   %edi
  801e41:	56                   	push   %esi
  801e42:	53                   	push   %ebx
  801e43:	83 ec 1c             	sub    $0x1c,%esp
  801e46:	89 c7                	mov    %eax,%edi
  801e48:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e4a:	a1 08 40 80 00       	mov    0x804008,%eax
  801e4f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	57                   	push   %edi
  801e56:	e8 05 05 00 00       	call   802360 <pageref>
  801e5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e5e:	89 34 24             	mov    %esi,(%esp)
  801e61:	e8 fa 04 00 00       	call   802360 <pageref>
		nn = thisenv->env_runs;
  801e66:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e6c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e6f:	83 c4 10             	add    $0x10,%esp
  801e72:	39 cb                	cmp    %ecx,%ebx
  801e74:	74 1b                	je     801e91 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e76:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e79:	75 cf                	jne    801e4a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e7b:	8b 42 58             	mov    0x58(%edx),%eax
  801e7e:	6a 01                	push   $0x1
  801e80:	50                   	push   %eax
  801e81:	53                   	push   %ebx
  801e82:	68 57 2b 80 00       	push   $0x802b57
  801e87:	e8 29 e3 ff ff       	call   8001b5 <cprintf>
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	eb b9                	jmp    801e4a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e91:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e94:	0f 94 c0             	sete   %al
  801e97:	0f b6 c0             	movzbl %al,%eax
}
  801e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e9d:	5b                   	pop    %ebx
  801e9e:	5e                   	pop    %esi
  801e9f:	5f                   	pop    %edi
  801ea0:	5d                   	pop    %ebp
  801ea1:	c3                   	ret    

00801ea2 <devpipe_write>:
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	57                   	push   %edi
  801ea6:	56                   	push   %esi
  801ea7:	53                   	push   %ebx
  801ea8:	83 ec 28             	sub    $0x28,%esp
  801eab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801eae:	56                   	push   %esi
  801eaf:	e8 cb f2 ff ff       	call   80117f <fd2data>
  801eb4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	bf 00 00 00 00       	mov    $0x0,%edi
  801ebe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ec1:	74 4f                	je     801f12 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ec3:	8b 43 04             	mov    0x4(%ebx),%eax
  801ec6:	8b 0b                	mov    (%ebx),%ecx
  801ec8:	8d 51 20             	lea    0x20(%ecx),%edx
  801ecb:	39 d0                	cmp    %edx,%eax
  801ecd:	72 14                	jb     801ee3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ecf:	89 da                	mov    %ebx,%edx
  801ed1:	89 f0                	mov    %esi,%eax
  801ed3:	e8 65 ff ff ff       	call   801e3d <_pipeisclosed>
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	75 3a                	jne    801f16 <devpipe_write+0x74>
			sys_yield();
  801edc:	e8 cd ec ff ff       	call   800bae <sys_yield>
  801ee1:	eb e0                	jmp    801ec3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ee6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eea:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eed:	89 c2                	mov    %eax,%edx
  801eef:	c1 fa 1f             	sar    $0x1f,%edx
  801ef2:	89 d1                	mov    %edx,%ecx
  801ef4:	c1 e9 1b             	shr    $0x1b,%ecx
  801ef7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801efa:	83 e2 1f             	and    $0x1f,%edx
  801efd:	29 ca                	sub    %ecx,%edx
  801eff:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f03:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f07:	83 c0 01             	add    $0x1,%eax
  801f0a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f0d:	83 c7 01             	add    $0x1,%edi
  801f10:	eb ac                	jmp    801ebe <devpipe_write+0x1c>
	return i;
  801f12:	89 f8                	mov    %edi,%eax
  801f14:	eb 05                	jmp    801f1b <devpipe_write+0x79>
				return 0;
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5e                   	pop    %esi
  801f20:	5f                   	pop    %edi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <devpipe_read>:
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	57                   	push   %edi
  801f27:	56                   	push   %esi
  801f28:	53                   	push   %ebx
  801f29:	83 ec 18             	sub    $0x18,%esp
  801f2c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f2f:	57                   	push   %edi
  801f30:	e8 4a f2 ff ff       	call   80117f <fd2data>
  801f35:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f37:	83 c4 10             	add    $0x10,%esp
  801f3a:	be 00 00 00 00       	mov    $0x0,%esi
  801f3f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f42:	74 47                	je     801f8b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801f44:	8b 03                	mov    (%ebx),%eax
  801f46:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f49:	75 22                	jne    801f6d <devpipe_read+0x4a>
			if (i > 0)
  801f4b:	85 f6                	test   %esi,%esi
  801f4d:	75 14                	jne    801f63 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801f4f:	89 da                	mov    %ebx,%edx
  801f51:	89 f8                	mov    %edi,%eax
  801f53:	e8 e5 fe ff ff       	call   801e3d <_pipeisclosed>
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	75 33                	jne    801f8f <devpipe_read+0x6c>
			sys_yield();
  801f5c:	e8 4d ec ff ff       	call   800bae <sys_yield>
  801f61:	eb e1                	jmp    801f44 <devpipe_read+0x21>
				return i;
  801f63:	89 f0                	mov    %esi,%eax
}
  801f65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f68:	5b                   	pop    %ebx
  801f69:	5e                   	pop    %esi
  801f6a:	5f                   	pop    %edi
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f6d:	99                   	cltd   
  801f6e:	c1 ea 1b             	shr    $0x1b,%edx
  801f71:	01 d0                	add    %edx,%eax
  801f73:	83 e0 1f             	and    $0x1f,%eax
  801f76:	29 d0                	sub    %edx,%eax
  801f78:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f80:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f83:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f86:	83 c6 01             	add    $0x1,%esi
  801f89:	eb b4                	jmp    801f3f <devpipe_read+0x1c>
	return i;
  801f8b:	89 f0                	mov    %esi,%eax
  801f8d:	eb d6                	jmp    801f65 <devpipe_read+0x42>
				return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	eb cf                	jmp    801f65 <devpipe_read+0x42>

00801f96 <pipe>:
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	56                   	push   %esi
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa1:	50                   	push   %eax
  801fa2:	e8 ef f1 ff ff       	call   801196 <fd_alloc>
  801fa7:	89 c3                	mov    %eax,%ebx
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	85 c0                	test   %eax,%eax
  801fae:	78 5b                	js     80200b <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	68 07 04 00 00       	push   $0x407
  801fb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbb:	6a 00                	push   $0x0
  801fbd:	e8 0b ec ff ff       	call   800bcd <sys_page_alloc>
  801fc2:	89 c3                	mov    %eax,%ebx
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	78 40                	js     80200b <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fd1:	50                   	push   %eax
  801fd2:	e8 bf f1 ff ff       	call   801196 <fd_alloc>
  801fd7:	89 c3                	mov    %eax,%ebx
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	78 1b                	js     801ffb <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 07 04 00 00       	push   $0x407
  801fe8:	ff 75 f0             	pushl  -0x10(%ebp)
  801feb:	6a 00                	push   $0x0
  801fed:	e8 db eb ff ff       	call   800bcd <sys_page_alloc>
  801ff2:	89 c3                	mov    %eax,%ebx
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	79 19                	jns    802014 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ffb:	83 ec 08             	sub    $0x8,%esp
  801ffe:	ff 75 f4             	pushl  -0xc(%ebp)
  802001:	6a 00                	push   $0x0
  802003:	e8 4a ec ff ff       	call   800c52 <sys_page_unmap>
  802008:	83 c4 10             	add    $0x10,%esp
}
  80200b:	89 d8                	mov    %ebx,%eax
  80200d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802010:	5b                   	pop    %ebx
  802011:	5e                   	pop    %esi
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    
	va = fd2data(fd0);
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	ff 75 f4             	pushl  -0xc(%ebp)
  80201a:	e8 60 f1 ff ff       	call   80117f <fd2data>
  80201f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802021:	83 c4 0c             	add    $0xc,%esp
  802024:	68 07 04 00 00       	push   $0x407
  802029:	50                   	push   %eax
  80202a:	6a 00                	push   $0x0
  80202c:	e8 9c eb ff ff       	call   800bcd <sys_page_alloc>
  802031:	89 c3                	mov    %eax,%ebx
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	85 c0                	test   %eax,%eax
  802038:	0f 88 8c 00 00 00    	js     8020ca <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203e:	83 ec 0c             	sub    $0xc,%esp
  802041:	ff 75 f0             	pushl  -0x10(%ebp)
  802044:	e8 36 f1 ff ff       	call   80117f <fd2data>
  802049:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802050:	50                   	push   %eax
  802051:	6a 00                	push   $0x0
  802053:	56                   	push   %esi
  802054:	6a 00                	push   $0x0
  802056:	e8 b5 eb ff ff       	call   800c10 <sys_page_map>
  80205b:	89 c3                	mov    %eax,%ebx
  80205d:	83 c4 20             	add    $0x20,%esp
  802060:	85 c0                	test   %eax,%eax
  802062:	78 58                	js     8020bc <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80206d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802082:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80208e:	83 ec 0c             	sub    $0xc,%esp
  802091:	ff 75 f4             	pushl  -0xc(%ebp)
  802094:	e8 d6 f0 ff ff       	call   80116f <fd2num>
  802099:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80209e:	83 c4 04             	add    $0x4,%esp
  8020a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a4:	e8 c6 f0 ff ff       	call   80116f <fd2num>
  8020a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020b7:	e9 4f ff ff ff       	jmp    80200b <pipe+0x75>
	sys_page_unmap(0, va);
  8020bc:	83 ec 08             	sub    $0x8,%esp
  8020bf:	56                   	push   %esi
  8020c0:	6a 00                	push   $0x0
  8020c2:	e8 8b eb ff ff       	call   800c52 <sys_page_unmap>
  8020c7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8020ca:	83 ec 08             	sub    $0x8,%esp
  8020cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8020d0:	6a 00                	push   $0x0
  8020d2:	e8 7b eb ff ff       	call   800c52 <sys_page_unmap>
  8020d7:	83 c4 10             	add    $0x10,%esp
  8020da:	e9 1c ff ff ff       	jmp    801ffb <pipe+0x65>

008020df <pipeisclosed>:
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e8:	50                   	push   %eax
  8020e9:	ff 75 08             	pushl  0x8(%ebp)
  8020ec:	e8 f4 f0 ff ff       	call   8011e5 <fd_lookup>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 18                	js     802110 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020f8:	83 ec 0c             	sub    $0xc,%esp
  8020fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fe:	e8 7c f0 ff ff       	call   80117f <fd2data>
	return _pipeisclosed(fd, p);
  802103:	89 c2                	mov    %eax,%edx
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	e8 30 fd ff ff       	call   801e3d <_pipeisclosed>
  80210d:	83 c4 10             	add    $0x10,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    

0080211c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802122:	68 6f 2b 80 00       	push   $0x802b6f
  802127:	ff 75 0c             	pushl  0xc(%ebp)
  80212a:	e8 a5 e6 ff ff       	call   8007d4 <strcpy>
	return 0;
}
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <devcons_write>:
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	57                   	push   %edi
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802142:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802147:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80214d:	eb 2f                	jmp    80217e <devcons_write+0x48>
		m = n - tot;
  80214f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802152:	29 f3                	sub    %esi,%ebx
  802154:	83 fb 7f             	cmp    $0x7f,%ebx
  802157:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80215c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80215f:	83 ec 04             	sub    $0x4,%esp
  802162:	53                   	push   %ebx
  802163:	89 f0                	mov    %esi,%eax
  802165:	03 45 0c             	add    0xc(%ebp),%eax
  802168:	50                   	push   %eax
  802169:	57                   	push   %edi
  80216a:	e8 f3 e7 ff ff       	call   800962 <memmove>
		sys_cputs(buf, m);
  80216f:	83 c4 08             	add    $0x8,%esp
  802172:	53                   	push   %ebx
  802173:	57                   	push   %edi
  802174:	e8 98 e9 ff ff       	call   800b11 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802179:	01 de                	add    %ebx,%esi
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802181:	72 cc                	jb     80214f <devcons_write+0x19>
}
  802183:	89 f0                	mov    %esi,%eax
  802185:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802188:	5b                   	pop    %ebx
  802189:	5e                   	pop    %esi
  80218a:	5f                   	pop    %edi
  80218b:	5d                   	pop    %ebp
  80218c:	c3                   	ret    

0080218d <devcons_read>:
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 08             	sub    $0x8,%esp
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802198:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80219c:	75 07                	jne    8021a5 <devcons_read+0x18>
}
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    
		sys_yield();
  8021a0:	e8 09 ea ff ff       	call   800bae <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8021a5:	e8 85 e9 ff ff       	call   800b2f <sys_cgetc>
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	74 f2                	je     8021a0 <devcons_read+0x13>
	if (c < 0)
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	78 ec                	js     80219e <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8021b2:	83 f8 04             	cmp    $0x4,%eax
  8021b5:	74 0c                	je     8021c3 <devcons_read+0x36>
	*(char*)vbuf = c;
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	88 02                	mov    %al,(%edx)
	return 1;
  8021bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c1:	eb db                	jmp    80219e <devcons_read+0x11>
		return 0;
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	eb d4                	jmp    80219e <devcons_read+0x11>

008021ca <cputchar>:
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021d6:	6a 01                	push   $0x1
  8021d8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021db:	50                   	push   %eax
  8021dc:	e8 30 e9 ff ff       	call   800b11 <sys_cputs>
}
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <getchar>:
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021ec:	6a 01                	push   $0x1
  8021ee:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f1:	50                   	push   %eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	e8 5d f2 ff ff       	call   801456 <read>
	if (r < 0)
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	78 08                	js     802208 <getchar+0x22>
	if (r < 1)
  802200:	85 c0                	test   %eax,%eax
  802202:	7e 06                	jle    80220a <getchar+0x24>
	return c;
  802204:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    
		return -E_EOF;
  80220a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80220f:	eb f7                	jmp    802208 <getchar+0x22>

00802211 <iscons>:
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802217:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221a:	50                   	push   %eax
  80221b:	ff 75 08             	pushl  0x8(%ebp)
  80221e:	e8 c2 ef ff ff       	call   8011e5 <fd_lookup>
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	85 c0                	test   %eax,%eax
  802228:	78 11                	js     80223b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802233:	39 10                	cmp    %edx,(%eax)
  802235:	0f 94 c0             	sete   %al
  802238:	0f b6 c0             	movzbl %al,%eax
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <opencons>:
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802243:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802246:	50                   	push   %eax
  802247:	e8 4a ef ff ff       	call   801196 <fd_alloc>
  80224c:	83 c4 10             	add    $0x10,%esp
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 3a                	js     80228d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 07 04 00 00       	push   $0x407
  80225b:	ff 75 f4             	pushl  -0xc(%ebp)
  80225e:	6a 00                	push   $0x0
  802260:	e8 68 e9 ff ff       	call   800bcd <sys_page_alloc>
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	85 c0                	test   %eax,%eax
  80226a:	78 21                	js     80228d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802275:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802281:	83 ec 0c             	sub    $0xc,%esp
  802284:	50                   	push   %eax
  802285:	e8 e5 ee ff ff       	call   80116f <fd2num>
  80228a:	83 c4 10             	add    $0x10,%esp
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802294:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802297:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80229d:	e8 ed e8 ff ff       	call   800b8f <sys_getenvid>
  8022a2:	83 ec 0c             	sub    $0xc,%esp
  8022a5:	ff 75 0c             	pushl  0xc(%ebp)
  8022a8:	ff 75 08             	pushl  0x8(%ebp)
  8022ab:	56                   	push   %esi
  8022ac:	50                   	push   %eax
  8022ad:	68 7c 2b 80 00       	push   $0x802b7c
  8022b2:	e8 fe de ff ff       	call   8001b5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022b7:	83 c4 18             	add    $0x18,%esp
  8022ba:	53                   	push   %ebx
  8022bb:	ff 75 10             	pushl  0x10(%ebp)
  8022be:	e8 a1 de ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  8022c3:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  8022ca:	e8 e6 de ff ff       	call   8001b5 <cprintf>
  8022cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022d2:	cc                   	int3   
  8022d3:	eb fd                	jmp    8022d2 <_panic+0x43>

008022d5 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  8022db:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8022e2:	74 0a                	je     8022ee <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  8022ee:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f3:	8b 40 48             	mov    0x48(%eax),%eax
  8022f6:	83 ec 04             	sub    $0x4,%esp
  8022f9:	6a 07                	push   $0x7
  8022fb:	68 00 f0 bf ee       	push   $0xeebff000
  802300:	50                   	push   %eax
  802301:	e8 c7 e8 ff ff       	call   800bcd <sys_page_alloc>
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	85 c0                	test   %eax,%eax
  80230b:	78 1b                	js     802328 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80230d:	a1 08 40 80 00       	mov    0x804008,%eax
  802312:	8b 40 48             	mov    0x48(%eax),%eax
  802315:	83 ec 08             	sub    $0x8,%esp
  802318:	68 3a 23 80 00       	push   $0x80233a
  80231d:	50                   	push   %eax
  80231e:	e8 f5 e9 ff ff       	call   800d18 <sys_env_set_pgfault_upcall>
  802323:	83 c4 10             	add    $0x10,%esp
  802326:	eb bc                	jmp    8022e4 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802328:	50                   	push   %eax
  802329:	68 a0 2b 80 00       	push   $0x802ba0
  80232e:	6a 22                	push   $0x22
  802330:	68 b8 2b 80 00       	push   $0x802bb8
  802335:	e8 55 ff ff ff       	call   80228f <_panic>

0080233a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80233a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80233b:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802340:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802342:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802345:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802349:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  80234c:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802350:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802354:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802356:	83 c4 08             	add    $0x8,%esp
	popal
  802359:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80235a:	83 c4 04             	add    $0x4,%esp
	popfl
  80235d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80235e:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80235f:	c3                   	ret    

00802360 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802366:	89 d0                	mov    %edx,%eax
  802368:	c1 e8 16             	shr    $0x16,%eax
  80236b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802372:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802377:	f6 c1 01             	test   $0x1,%cl
  80237a:	74 1d                	je     802399 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80237c:	c1 ea 0c             	shr    $0xc,%edx
  80237f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802386:	f6 c2 01             	test   $0x1,%dl
  802389:	74 0e                	je     802399 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80238b:	c1 ea 0c             	shr    $0xc,%edx
  80238e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802395:	ef 
  802396:	0f b7 c0             	movzwl %ax,%eax
}
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    
  80239b:	66 90                	xchg   %ax,%ax
  80239d:	66 90                	xchg   %ax,%ax
  80239f:	90                   	nop

008023a0 <__udivdi3>:
  8023a0:	55                   	push   %ebp
  8023a1:	57                   	push   %edi
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 1c             	sub    $0x1c,%esp
  8023a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023b7:	85 d2                	test   %edx,%edx
  8023b9:	75 35                	jne    8023f0 <__udivdi3+0x50>
  8023bb:	39 f3                	cmp    %esi,%ebx
  8023bd:	0f 87 bd 00 00 00    	ja     802480 <__udivdi3+0xe0>
  8023c3:	85 db                	test   %ebx,%ebx
  8023c5:	89 d9                	mov    %ebx,%ecx
  8023c7:	75 0b                	jne    8023d4 <__udivdi3+0x34>
  8023c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ce:	31 d2                	xor    %edx,%edx
  8023d0:	f7 f3                	div    %ebx
  8023d2:	89 c1                	mov    %eax,%ecx
  8023d4:	31 d2                	xor    %edx,%edx
  8023d6:	89 f0                	mov    %esi,%eax
  8023d8:	f7 f1                	div    %ecx
  8023da:	89 c6                	mov    %eax,%esi
  8023dc:	89 e8                	mov    %ebp,%eax
  8023de:	89 f7                	mov    %esi,%edi
  8023e0:	f7 f1                	div    %ecx
  8023e2:	89 fa                	mov    %edi,%edx
  8023e4:	83 c4 1c             	add    $0x1c,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5f                   	pop    %edi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    
  8023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023f0:	39 f2                	cmp    %esi,%edx
  8023f2:	77 7c                	ja     802470 <__udivdi3+0xd0>
  8023f4:	0f bd fa             	bsr    %edx,%edi
  8023f7:	83 f7 1f             	xor    $0x1f,%edi
  8023fa:	0f 84 98 00 00 00    	je     802498 <__udivdi3+0xf8>
  802400:	89 f9                	mov    %edi,%ecx
  802402:	b8 20 00 00 00       	mov    $0x20,%eax
  802407:	29 f8                	sub    %edi,%eax
  802409:	d3 e2                	shl    %cl,%edx
  80240b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80240f:	89 c1                	mov    %eax,%ecx
  802411:	89 da                	mov    %ebx,%edx
  802413:	d3 ea                	shr    %cl,%edx
  802415:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802419:	09 d1                	or     %edx,%ecx
  80241b:	89 f2                	mov    %esi,%edx
  80241d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802421:	89 f9                	mov    %edi,%ecx
  802423:	d3 e3                	shl    %cl,%ebx
  802425:	89 c1                	mov    %eax,%ecx
  802427:	d3 ea                	shr    %cl,%edx
  802429:	89 f9                	mov    %edi,%ecx
  80242b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80242f:	d3 e6                	shl    %cl,%esi
  802431:	89 eb                	mov    %ebp,%ebx
  802433:	89 c1                	mov    %eax,%ecx
  802435:	d3 eb                	shr    %cl,%ebx
  802437:	09 de                	or     %ebx,%esi
  802439:	89 f0                	mov    %esi,%eax
  80243b:	f7 74 24 08          	divl   0x8(%esp)
  80243f:	89 d6                	mov    %edx,%esi
  802441:	89 c3                	mov    %eax,%ebx
  802443:	f7 64 24 0c          	mull   0xc(%esp)
  802447:	39 d6                	cmp    %edx,%esi
  802449:	72 0c                	jb     802457 <__udivdi3+0xb7>
  80244b:	89 f9                	mov    %edi,%ecx
  80244d:	d3 e5                	shl    %cl,%ebp
  80244f:	39 c5                	cmp    %eax,%ebp
  802451:	73 5d                	jae    8024b0 <__udivdi3+0x110>
  802453:	39 d6                	cmp    %edx,%esi
  802455:	75 59                	jne    8024b0 <__udivdi3+0x110>
  802457:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80245a:	31 ff                	xor    %edi,%edi
  80245c:	89 fa                	mov    %edi,%edx
  80245e:	83 c4 1c             	add    $0x1c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    
  802466:	8d 76 00             	lea    0x0(%esi),%esi
  802469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802470:	31 ff                	xor    %edi,%edi
  802472:	31 c0                	xor    %eax,%eax
  802474:	89 fa                	mov    %edi,%edx
  802476:	83 c4 1c             	add    $0x1c,%esp
  802479:	5b                   	pop    %ebx
  80247a:	5e                   	pop    %esi
  80247b:	5f                   	pop    %edi
  80247c:	5d                   	pop    %ebp
  80247d:	c3                   	ret    
  80247e:	66 90                	xchg   %ax,%ax
  802480:	31 ff                	xor    %edi,%edi
  802482:	89 e8                	mov    %ebp,%eax
  802484:	89 f2                	mov    %esi,%edx
  802486:	f7 f3                	div    %ebx
  802488:	89 fa                	mov    %edi,%edx
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	39 f2                	cmp    %esi,%edx
  80249a:	72 06                	jb     8024a2 <__udivdi3+0x102>
  80249c:	31 c0                	xor    %eax,%eax
  80249e:	39 eb                	cmp    %ebp,%ebx
  8024a0:	77 d2                	ja     802474 <__udivdi3+0xd4>
  8024a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a7:	eb cb                	jmp    802474 <__udivdi3+0xd4>
  8024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024b0:	89 d8                	mov    %ebx,%eax
  8024b2:	31 ff                	xor    %edi,%edi
  8024b4:	eb be                	jmp    802474 <__udivdi3+0xd4>
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	66 90                	xchg   %ax,%ax
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <__umoddi3>:
  8024c0:	55                   	push   %ebp
  8024c1:	57                   	push   %edi
  8024c2:	56                   	push   %esi
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 1c             	sub    $0x1c,%esp
  8024c7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8024cb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024cf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024d7:	85 ed                	test   %ebp,%ebp
  8024d9:	89 f0                	mov    %esi,%eax
  8024db:	89 da                	mov    %ebx,%edx
  8024dd:	75 19                	jne    8024f8 <__umoddi3+0x38>
  8024df:	39 df                	cmp    %ebx,%edi
  8024e1:	0f 86 b1 00 00 00    	jbe    802598 <__umoddi3+0xd8>
  8024e7:	f7 f7                	div    %edi
  8024e9:	89 d0                	mov    %edx,%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	83 c4 1c             	add    $0x1c,%esp
  8024f0:	5b                   	pop    %ebx
  8024f1:	5e                   	pop    %esi
  8024f2:	5f                   	pop    %edi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    
  8024f5:	8d 76 00             	lea    0x0(%esi),%esi
  8024f8:	39 dd                	cmp    %ebx,%ebp
  8024fa:	77 f1                	ja     8024ed <__umoddi3+0x2d>
  8024fc:	0f bd cd             	bsr    %ebp,%ecx
  8024ff:	83 f1 1f             	xor    $0x1f,%ecx
  802502:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802506:	0f 84 b4 00 00 00    	je     8025c0 <__umoddi3+0x100>
  80250c:	b8 20 00 00 00       	mov    $0x20,%eax
  802511:	89 c2                	mov    %eax,%edx
  802513:	8b 44 24 04          	mov    0x4(%esp),%eax
  802517:	29 c2                	sub    %eax,%edx
  802519:	89 c1                	mov    %eax,%ecx
  80251b:	89 f8                	mov    %edi,%eax
  80251d:	d3 e5                	shl    %cl,%ebp
  80251f:	89 d1                	mov    %edx,%ecx
  802521:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802525:	d3 e8                	shr    %cl,%eax
  802527:	09 c5                	or     %eax,%ebp
  802529:	8b 44 24 04          	mov    0x4(%esp),%eax
  80252d:	89 c1                	mov    %eax,%ecx
  80252f:	d3 e7                	shl    %cl,%edi
  802531:	89 d1                	mov    %edx,%ecx
  802533:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802537:	89 df                	mov    %ebx,%edi
  802539:	d3 ef                	shr    %cl,%edi
  80253b:	89 c1                	mov    %eax,%ecx
  80253d:	89 f0                	mov    %esi,%eax
  80253f:	d3 e3                	shl    %cl,%ebx
  802541:	89 d1                	mov    %edx,%ecx
  802543:	89 fa                	mov    %edi,%edx
  802545:	d3 e8                	shr    %cl,%eax
  802547:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254c:	09 d8                	or     %ebx,%eax
  80254e:	f7 f5                	div    %ebp
  802550:	d3 e6                	shl    %cl,%esi
  802552:	89 d1                	mov    %edx,%ecx
  802554:	f7 64 24 08          	mull   0x8(%esp)
  802558:	39 d1                	cmp    %edx,%ecx
  80255a:	89 c3                	mov    %eax,%ebx
  80255c:	89 d7                	mov    %edx,%edi
  80255e:	72 06                	jb     802566 <__umoddi3+0xa6>
  802560:	75 0e                	jne    802570 <__umoddi3+0xb0>
  802562:	39 c6                	cmp    %eax,%esi
  802564:	73 0a                	jae    802570 <__umoddi3+0xb0>
  802566:	2b 44 24 08          	sub    0x8(%esp),%eax
  80256a:	19 ea                	sbb    %ebp,%edx
  80256c:	89 d7                	mov    %edx,%edi
  80256e:	89 c3                	mov    %eax,%ebx
  802570:	89 ca                	mov    %ecx,%edx
  802572:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802577:	29 de                	sub    %ebx,%esi
  802579:	19 fa                	sbb    %edi,%edx
  80257b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80257f:	89 d0                	mov    %edx,%eax
  802581:	d3 e0                	shl    %cl,%eax
  802583:	89 d9                	mov    %ebx,%ecx
  802585:	d3 ee                	shr    %cl,%esi
  802587:	d3 ea                	shr    %cl,%edx
  802589:	09 f0                	or     %esi,%eax
  80258b:	83 c4 1c             	add    $0x1c,%esp
  80258e:	5b                   	pop    %ebx
  80258f:	5e                   	pop    %esi
  802590:	5f                   	pop    %edi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
  802593:	90                   	nop
  802594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802598:	85 ff                	test   %edi,%edi
  80259a:	89 f9                	mov    %edi,%ecx
  80259c:	75 0b                	jne    8025a9 <__umoddi3+0xe9>
  80259e:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a3:	31 d2                	xor    %edx,%edx
  8025a5:	f7 f7                	div    %edi
  8025a7:	89 c1                	mov    %eax,%ecx
  8025a9:	89 d8                	mov    %ebx,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	f7 f1                	div    %ecx
  8025af:	89 f0                	mov    %esi,%eax
  8025b1:	f7 f1                	div    %ecx
  8025b3:	e9 31 ff ff ff       	jmp    8024e9 <__umoddi3+0x29>
  8025b8:	90                   	nop
  8025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025c0:	39 dd                	cmp    %ebx,%ebp
  8025c2:	72 08                	jb     8025cc <__umoddi3+0x10c>
  8025c4:	39 f7                	cmp    %esi,%edi
  8025c6:	0f 87 21 ff ff ff    	ja     8024ed <__umoddi3+0x2d>
  8025cc:	89 da                	mov    %ebx,%edx
  8025ce:	89 f0                	mov    %esi,%eax
  8025d0:	29 f8                	sub    %edi,%eax
  8025d2:	19 ea                	sbb    %ebp,%edx
  8025d4:	e9 14 ff ff ff       	jmp    8024ed <__umoddi3+0x2d>


obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 70 0b 00 00       	call   800bb2 <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 00 26 80 00       	push   $0x802600
  80004c:	e8 87 01 00 00       	call   8001d8 <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 3d 07 00 00       	call   8007c0 <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 11 26 80 00       	push   $0x802611
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 fa 06 00 00       	call   8007a6 <snprintf>
	if (fork() == 0) {
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 25 0e 00 00       	call   800ed9 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 60 00 00 00       	call   800129 <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 10 26 80 00       	push   $0x802610
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 bf 0a 00 00       	call   800bb2 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x2d>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	83 ec 08             	sub    $0x8,%esp
  800113:	56                   	push   %esi
  800114:	53                   	push   %ebx
  800115:	e8 b4 ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  80011a:	e8 0a 00 00 00       	call   800129 <exit>
}
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800125:	5b                   	pop    %ebx
  800126:	5e                   	pop    %esi
  800127:	5d                   	pop    %ebp
  800128:	c3                   	ret    

00800129 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012f:	e8 40 11 00 00       	call   801274 <close_all>
	sys_env_destroy(0);
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	6a 00                	push   $0x0
  800139:	e8 33 0a 00 00       	call   800b71 <sys_env_destroy>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	53                   	push   %ebx
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80014d:	8b 13                	mov    (%ebx),%edx
  80014f:	8d 42 01             	lea    0x1(%edx),%eax
  800152:	89 03                	mov    %eax,(%ebx)
  800154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800157:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800160:	74 09                	je     80016b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800162:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800166:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800169:	c9                   	leave  
  80016a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	68 ff 00 00 00       	push   $0xff
  800173:	8d 43 08             	lea    0x8(%ebx),%eax
  800176:	50                   	push   %eax
  800177:	e8 b8 09 00 00       	call   800b34 <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	eb db                	jmp    800162 <putch+0x1f>

00800187 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800190:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800197:	00 00 00 
	b.cnt = 0;
  80019a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a4:	ff 75 0c             	pushl  0xc(%ebp)
  8001a7:	ff 75 08             	pushl  0x8(%ebp)
  8001aa:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b0:	50                   	push   %eax
  8001b1:	68 43 01 80 00       	push   $0x800143
  8001b6:	e8 1a 01 00 00       	call   8002d5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bb:	83 c4 08             	add    $0x8,%esp
  8001be:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ca:	50                   	push   %eax
  8001cb:	e8 64 09 00 00       	call   800b34 <sys_cputs>

	return b.cnt;
}
  8001d0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001de:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e1:	50                   	push   %eax
  8001e2:	ff 75 08             	pushl  0x8(%ebp)
  8001e5:	e8 9d ff ff ff       	call   800187 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 1c             	sub    $0x1c,%esp
  8001f5:	89 c7                	mov    %eax,%edi
  8001f7:	89 d6                	mov    %edx,%esi
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800202:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800205:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800208:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800210:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800213:	39 d3                	cmp    %edx,%ebx
  800215:	72 05                	jb     80021c <printnum+0x30>
  800217:	39 45 10             	cmp    %eax,0x10(%ebp)
  80021a:	77 7a                	ja     800296 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	ff 75 18             	pushl  0x18(%ebp)
  800222:	8b 45 14             	mov    0x14(%ebp),%eax
  800225:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800228:	53                   	push   %ebx
  800229:	ff 75 10             	pushl  0x10(%ebp)
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800232:	ff 75 e0             	pushl  -0x20(%ebp)
  800235:	ff 75 dc             	pushl  -0x24(%ebp)
  800238:	ff 75 d8             	pushl  -0x28(%ebp)
  80023b:	e8 80 21 00 00       	call   8023c0 <__udivdi3>
  800240:	83 c4 18             	add    $0x18,%esp
  800243:	52                   	push   %edx
  800244:	50                   	push   %eax
  800245:	89 f2                	mov    %esi,%edx
  800247:	89 f8                	mov    %edi,%eax
  800249:	e8 9e ff ff ff       	call   8001ec <printnum>
  80024e:	83 c4 20             	add    $0x20,%esp
  800251:	eb 13                	jmp    800266 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800253:	83 ec 08             	sub    $0x8,%esp
  800256:	56                   	push   %esi
  800257:	ff 75 18             	pushl  0x18(%ebp)
  80025a:	ff d7                	call   *%edi
  80025c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80025f:	83 eb 01             	sub    $0x1,%ebx
  800262:	85 db                	test   %ebx,%ebx
  800264:	7f ed                	jg     800253 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800266:	83 ec 08             	sub    $0x8,%esp
  800269:	56                   	push   %esi
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800270:	ff 75 e0             	pushl  -0x20(%ebp)
  800273:	ff 75 dc             	pushl  -0x24(%ebp)
  800276:	ff 75 d8             	pushl  -0x28(%ebp)
  800279:	e8 62 22 00 00       	call   8024e0 <__umoddi3>
  80027e:	83 c4 14             	add    $0x14,%esp
  800281:	0f be 80 20 26 80 00 	movsbl 0x802620(%eax),%eax
  800288:	50                   	push   %eax
  800289:	ff d7                	call   *%edi
}
  80028b:	83 c4 10             	add    $0x10,%esp
  80028e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    
  800296:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800299:	eb c4                	jmp    80025f <printnum+0x73>

0080029b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a5:	8b 10                	mov    (%eax),%edx
  8002a7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002aa:	73 0a                	jae    8002b6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002af:	89 08                	mov    %ecx,(%eax)
  8002b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b4:	88 02                	mov    %al,(%edx)
}
  8002b6:	5d                   	pop    %ebp
  8002b7:	c3                   	ret    

008002b8 <printfmt>:
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002be:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c1:	50                   	push   %eax
  8002c2:	ff 75 10             	pushl  0x10(%ebp)
  8002c5:	ff 75 0c             	pushl  0xc(%ebp)
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	e8 05 00 00 00       	call   8002d5 <vprintfmt>
}
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    

008002d5 <vprintfmt>:
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 2c             	sub    $0x2c,%esp
  8002de:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e7:	e9 c1 03 00 00       	jmp    8006ad <vprintfmt+0x3d8>
		padc = ' ';
  8002ec:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8002f0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8002f7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8002fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800305:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8d 47 01             	lea    0x1(%edi),%eax
  80030d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800310:	0f b6 17             	movzbl (%edi),%edx
  800313:	8d 42 dd             	lea    -0x23(%edx),%eax
  800316:	3c 55                	cmp    $0x55,%al
  800318:	0f 87 12 04 00 00    	ja     800730 <vprintfmt+0x45b>
  80031e:	0f b6 c0             	movzbl %al,%eax
  800321:	ff 24 85 60 27 80 00 	jmp    *0x802760(,%eax,4)
  800328:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80032f:	eb d9                	jmp    80030a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800331:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800334:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800338:	eb d0                	jmp    80030a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80033a:	0f b6 d2             	movzbl %dl,%edx
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800340:	b8 00 00 00 00       	mov    $0x0,%eax
  800345:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800348:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80034f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800352:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800355:	83 f9 09             	cmp    $0x9,%ecx
  800358:	77 55                	ja     8003af <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80035a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80035d:	eb e9                	jmp    800348 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80035f:	8b 45 14             	mov    0x14(%ebp),%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 40 04             	lea    0x4(%eax),%eax
  80036d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800373:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800377:	79 91                	jns    80030a <vprintfmt+0x35>
				width = precision, precision = -1;
  800379:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80037f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800386:	eb 82                	jmp    80030a <vprintfmt+0x35>
  800388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038b:	85 c0                	test   %eax,%eax
  80038d:	ba 00 00 00 00       	mov    $0x0,%edx
  800392:	0f 49 d0             	cmovns %eax,%edx
  800395:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800398:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039b:	e9 6a ff ff ff       	jmp    80030a <vprintfmt+0x35>
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003aa:	e9 5b ff ff ff       	jmp    80030a <vprintfmt+0x35>
  8003af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b5:	eb bc                	jmp    800373 <vprintfmt+0x9e>
			lflag++;
  8003b7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bd:	e9 48 ff ff ff       	jmp    80030a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c5:	8d 78 04             	lea    0x4(%eax),%edi
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	53                   	push   %ebx
  8003cc:	ff 30                	pushl  (%eax)
  8003ce:	ff d6                	call   *%esi
			break;
  8003d0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d6:	e9 cf 02 00 00       	jmp    8006aa <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003db:	8b 45 14             	mov    0x14(%ebp),%eax
  8003de:	8d 78 04             	lea    0x4(%eax),%edi
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	99                   	cltd   
  8003e4:	31 d0                	xor    %edx,%eax
  8003e6:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e8:	83 f8 0f             	cmp    $0xf,%eax
  8003eb:	7f 23                	jg     800410 <vprintfmt+0x13b>
  8003ed:	8b 14 85 c0 28 80 00 	mov    0x8028c0(,%eax,4),%edx
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 18                	je     800410 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8003f8:	52                   	push   %edx
  8003f9:	68 e1 2a 80 00       	push   $0x802ae1
  8003fe:	53                   	push   %ebx
  8003ff:	56                   	push   %esi
  800400:	e8 b3 fe ff ff       	call   8002b8 <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040b:	e9 9a 02 00 00       	jmp    8006aa <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800410:	50                   	push   %eax
  800411:	68 38 26 80 00       	push   $0x802638
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 9b fe ff ff       	call   8002b8 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800423:	e9 82 02 00 00       	jmp    8006aa <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	83 c0 04             	add    $0x4,%eax
  80042e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800436:	85 ff                	test   %edi,%edi
  800438:	b8 31 26 80 00       	mov    $0x802631,%eax
  80043d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800444:	0f 8e bd 00 00 00    	jle    800507 <vprintfmt+0x232>
  80044a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80044e:	75 0e                	jne    80045e <vprintfmt+0x189>
  800450:	89 75 08             	mov    %esi,0x8(%ebp)
  800453:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800456:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800459:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80045c:	eb 6d                	jmp    8004cb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80045e:	83 ec 08             	sub    $0x8,%esp
  800461:	ff 75 d0             	pushl  -0x30(%ebp)
  800464:	57                   	push   %edi
  800465:	e8 6e 03 00 00       	call   8007d8 <strnlen>
  80046a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80046d:	29 c1                	sub    %eax,%ecx
  80046f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800472:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800475:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800479:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80047c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80047f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800481:	eb 0f                	jmp    800492 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	ff 75 e0             	pushl  -0x20(%ebp)
  80048a:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ef 01             	sub    $0x1,%edi
  80048f:	83 c4 10             	add    $0x10,%esp
  800492:	85 ff                	test   %edi,%edi
  800494:	7f ed                	jg     800483 <vprintfmt+0x1ae>
  800496:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800499:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80049c:	85 c9                	test   %ecx,%ecx
  80049e:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a3:	0f 49 c1             	cmovns %ecx,%eax
  8004a6:	29 c1                	sub    %eax,%ecx
  8004a8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ab:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ae:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004b1:	89 cb                	mov    %ecx,%ebx
  8004b3:	eb 16                	jmp    8004cb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b9:	75 31                	jne    8004ec <vprintfmt+0x217>
					putch(ch, putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	ff 75 0c             	pushl  0xc(%ebp)
  8004c1:	50                   	push   %eax
  8004c2:	ff 55 08             	call   *0x8(%ebp)
  8004c5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004c8:	83 eb 01             	sub    $0x1,%ebx
  8004cb:	83 c7 01             	add    $0x1,%edi
  8004ce:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004d2:	0f be c2             	movsbl %dl,%eax
  8004d5:	85 c0                	test   %eax,%eax
  8004d7:	74 59                	je     800532 <vprintfmt+0x25d>
  8004d9:	85 f6                	test   %esi,%esi
  8004db:	78 d8                	js     8004b5 <vprintfmt+0x1e0>
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	79 d3                	jns    8004b5 <vprintfmt+0x1e0>
  8004e2:	89 df                	mov    %ebx,%edi
  8004e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8004e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004ea:	eb 37                	jmp    800523 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ec:	0f be d2             	movsbl %dl,%edx
  8004ef:	83 ea 20             	sub    $0x20,%edx
  8004f2:	83 fa 5e             	cmp    $0x5e,%edx
  8004f5:	76 c4                	jbe    8004bb <vprintfmt+0x1e6>
					putch('?', putdat);
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	ff 75 0c             	pushl  0xc(%ebp)
  8004fd:	6a 3f                	push   $0x3f
  8004ff:	ff 55 08             	call   *0x8(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	eb c1                	jmp    8004c8 <vprintfmt+0x1f3>
  800507:	89 75 08             	mov    %esi,0x8(%ebp)
  80050a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80050d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800510:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800513:	eb b6                	jmp    8004cb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800515:	83 ec 08             	sub    $0x8,%esp
  800518:	53                   	push   %ebx
  800519:	6a 20                	push   $0x20
  80051b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80051d:	83 ef 01             	sub    $0x1,%edi
  800520:	83 c4 10             	add    $0x10,%esp
  800523:	85 ff                	test   %edi,%edi
  800525:	7f ee                	jg     800515 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800527:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80052a:	89 45 14             	mov    %eax,0x14(%ebp)
  80052d:	e9 78 01 00 00       	jmp    8006aa <vprintfmt+0x3d5>
  800532:	89 df                	mov    %ebx,%edi
  800534:	8b 75 08             	mov    0x8(%ebp),%esi
  800537:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80053a:	eb e7                	jmp    800523 <vprintfmt+0x24e>
	if (lflag >= 2)
  80053c:	83 f9 01             	cmp    $0x1,%ecx
  80053f:	7e 3f                	jle    800580 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 50 04             	mov    0x4(%eax),%edx
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800558:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80055c:	79 5c                	jns    8005ba <vprintfmt+0x2e5>
				putch('-', putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	53                   	push   %ebx
  800562:	6a 2d                	push   $0x2d
  800564:	ff d6                	call   *%esi
				num = -(long long) num;
  800566:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800569:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056c:	f7 da                	neg    %edx
  80056e:	83 d1 00             	adc    $0x0,%ecx
  800571:	f7 d9                	neg    %ecx
  800573:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 10 01 00 00       	jmp    800690 <vprintfmt+0x3bb>
	else if (lflag)
  800580:	85 c9                	test   %ecx,%ecx
  800582:	75 1b                	jne    80059f <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058c:	89 c1                	mov    %eax,%ecx
  80058e:	c1 f9 1f             	sar    $0x1f,%ecx
  800591:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8d 40 04             	lea    0x4(%eax),%eax
  80059a:	89 45 14             	mov    %eax,0x14(%ebp)
  80059d:	eb b9                	jmp    800558 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a7:	89 c1                	mov    %eax,%ecx
  8005a9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ac:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 40 04             	lea    0x4(%eax),%eax
  8005b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b8:	eb 9e                	jmp    800558 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005bd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c5:	e9 c6 00 00 00       	jmp    800690 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005ca:	83 f9 01             	cmp    $0x1,%ecx
  8005cd:	7e 18                	jle    8005e7 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 10                	mov    (%eax),%edx
  8005d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d7:	8d 40 08             	lea    0x8(%eax),%eax
  8005da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e2:	e9 a9 00 00 00       	jmp    800690 <vprintfmt+0x3bb>
	else if (lflag)
  8005e7:	85 c9                	test   %ecx,%ecx
  8005e9:	75 1a                	jne    800605 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8b 10                	mov    (%eax),%edx
  8005f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800600:	e9 8b 00 00 00       	jmp    800690 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	8b 10                	mov    (%eax),%edx
  80060a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060f:	8d 40 04             	lea    0x4(%eax),%eax
  800612:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800615:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061a:	eb 74                	jmp    800690 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80061c:	83 f9 01             	cmp    $0x1,%ecx
  80061f:	7e 15                	jle    800636 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	8b 10                	mov    (%eax),%edx
  800626:	8b 48 04             	mov    0x4(%eax),%ecx
  800629:	8d 40 08             	lea    0x8(%eax),%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80062f:	b8 08 00 00 00       	mov    $0x8,%eax
  800634:	eb 5a                	jmp    800690 <vprintfmt+0x3bb>
	else if (lflag)
  800636:	85 c9                	test   %ecx,%ecx
  800638:	75 17                	jne    800651 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 10                	mov    (%eax),%edx
  80063f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064a:	b8 08 00 00 00       	mov    $0x8,%eax
  80064f:	eb 3f                	jmp    800690 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065b:	8d 40 04             	lea    0x4(%eax),%eax
  80065e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800661:	b8 08 00 00 00       	mov    $0x8,%eax
  800666:	eb 28                	jmp    800690 <vprintfmt+0x3bb>
			putch('0', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 30                	push   $0x30
  80066e:	ff d6                	call   *%esi
			putch('x', putdat);
  800670:	83 c4 08             	add    $0x8,%esp
  800673:	53                   	push   %ebx
  800674:	6a 78                	push   $0x78
  800676:	ff d6                	call   *%esi
			num = (unsigned long long)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 10                	mov    (%eax),%edx
  80067d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800682:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800697:	57                   	push   %edi
  800698:	ff 75 e0             	pushl  -0x20(%ebp)
  80069b:	50                   	push   %eax
  80069c:	51                   	push   %ecx
  80069d:	52                   	push   %edx
  80069e:	89 da                	mov    %ebx,%edx
  8006a0:	89 f0                	mov    %esi,%eax
  8006a2:	e8 45 fb ff ff       	call   8001ec <printnum>
			break;
  8006a7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ad:	83 c7 01             	add    $0x1,%edi
  8006b0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006b4:	83 f8 25             	cmp    $0x25,%eax
  8006b7:	0f 84 2f fc ff ff    	je     8002ec <vprintfmt+0x17>
			if (ch == '\0')
  8006bd:	85 c0                	test   %eax,%eax
  8006bf:	0f 84 8b 00 00 00    	je     800750 <vprintfmt+0x47b>
			putch(ch, putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	53                   	push   %ebx
  8006c9:	50                   	push   %eax
  8006ca:	ff d6                	call   *%esi
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	eb dc                	jmp    8006ad <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006d1:	83 f9 01             	cmp    $0x1,%ecx
  8006d4:	7e 15                	jle    8006eb <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 10                	mov    (%eax),%edx
  8006db:	8b 48 04             	mov    0x4(%eax),%ecx
  8006de:	8d 40 08             	lea    0x8(%eax),%eax
  8006e1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e4:	b8 10 00 00 00       	mov    $0x10,%eax
  8006e9:	eb a5                	jmp    800690 <vprintfmt+0x3bb>
	else if (lflag)
  8006eb:	85 c9                	test   %ecx,%ecx
  8006ed:	75 17                	jne    800706 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8b 10                	mov    (%eax),%edx
  8006f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f9:	8d 40 04             	lea    0x4(%eax),%eax
  8006fc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ff:	b8 10 00 00 00       	mov    $0x10,%eax
  800704:	eb 8a                	jmp    800690 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	8b 10                	mov    (%eax),%edx
  80070b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800710:	8d 40 04             	lea    0x4(%eax),%eax
  800713:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800716:	b8 10 00 00 00       	mov    $0x10,%eax
  80071b:	e9 70 ff ff ff       	jmp    800690 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	53                   	push   %ebx
  800724:	6a 25                	push   $0x25
  800726:	ff d6                	call   *%esi
			break;
  800728:	83 c4 10             	add    $0x10,%esp
  80072b:	e9 7a ff ff ff       	jmp    8006aa <vprintfmt+0x3d5>
			putch('%', putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	53                   	push   %ebx
  800734:	6a 25                	push   $0x25
  800736:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800738:	83 c4 10             	add    $0x10,%esp
  80073b:	89 f8                	mov    %edi,%eax
  80073d:	eb 03                	jmp    800742 <vprintfmt+0x46d>
  80073f:	83 e8 01             	sub    $0x1,%eax
  800742:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800746:	75 f7                	jne    80073f <vprintfmt+0x46a>
  800748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074b:	e9 5a ff ff ff       	jmp    8006aa <vprintfmt+0x3d5>
}
  800750:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800753:	5b                   	pop    %ebx
  800754:	5e                   	pop    %esi
  800755:	5f                   	pop    %edi
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	83 ec 18             	sub    $0x18,%esp
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800764:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800767:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80076b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80076e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800775:	85 c0                	test   %eax,%eax
  800777:	74 26                	je     80079f <vsnprintf+0x47>
  800779:	85 d2                	test   %edx,%edx
  80077b:	7e 22                	jle    80079f <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80077d:	ff 75 14             	pushl  0x14(%ebp)
  800780:	ff 75 10             	pushl  0x10(%ebp)
  800783:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800786:	50                   	push   %eax
  800787:	68 9b 02 80 00       	push   $0x80029b
  80078c:	e8 44 fb ff ff       	call   8002d5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800794:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80079a:	83 c4 10             	add    $0x10,%esp
}
  80079d:	c9                   	leave  
  80079e:	c3                   	ret    
		return -E_INVAL;
  80079f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007a4:	eb f7                	jmp    80079d <vsnprintf+0x45>

008007a6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ac:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007af:	50                   	push   %eax
  8007b0:	ff 75 10             	pushl  0x10(%ebp)
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	e8 9a ff ff ff       	call   800758 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007be:	c9                   	leave  
  8007bf:	c3                   	ret    

008007c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cb:	eb 03                	jmp    8007d0 <strlen+0x10>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d4:	75 f7                	jne    8007cd <strlen+0xd>
	return n;
}
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	eb 03                	jmp    8007eb <strnlen+0x13>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007eb:	39 d0                	cmp    %edx,%eax
  8007ed:	74 06                	je     8007f5 <strnlen+0x1d>
  8007ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f3:	75 f3                	jne    8007e8 <strnlen+0x10>
	return n;
}
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800801:	89 c2                	mov    %eax,%edx
  800803:	83 c1 01             	add    $0x1,%ecx
  800806:	83 c2 01             	add    $0x1,%edx
  800809:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80080d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800810:	84 db                	test   %bl,%bl
  800812:	75 ef                	jne    800803 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800814:	5b                   	pop    %ebx
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80081e:	53                   	push   %ebx
  80081f:	e8 9c ff ff ff       	call   8007c0 <strlen>
  800824:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	01 d8                	add    %ebx,%eax
  80082c:	50                   	push   %eax
  80082d:	e8 c5 ff ff ff       	call   8007f7 <strcpy>
	return dst;
}
  800832:	89 d8                	mov    %ebx,%eax
  800834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800837:	c9                   	leave  
  800838:	c3                   	ret    

00800839 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	56                   	push   %esi
  80083d:	53                   	push   %ebx
  80083e:	8b 75 08             	mov    0x8(%ebp),%esi
  800841:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800844:	89 f3                	mov    %esi,%ebx
  800846:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800849:	89 f2                	mov    %esi,%edx
  80084b:	eb 0f                	jmp    80085c <strncpy+0x23>
		*dst++ = *src;
  80084d:	83 c2 01             	add    $0x1,%edx
  800850:	0f b6 01             	movzbl (%ecx),%eax
  800853:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800856:	80 39 01             	cmpb   $0x1,(%ecx)
  800859:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80085c:	39 da                	cmp    %ebx,%edx
  80085e:	75 ed                	jne    80084d <strncpy+0x14>
	}
	return ret;
}
  800860:	89 f0                	mov    %esi,%eax
  800862:	5b                   	pop    %ebx
  800863:	5e                   	pop    %esi
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	56                   	push   %esi
  80086a:	53                   	push   %ebx
  80086b:	8b 75 08             	mov    0x8(%ebp),%esi
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800871:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800874:	89 f0                	mov    %esi,%eax
  800876:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80087a:	85 c9                	test   %ecx,%ecx
  80087c:	75 0b                	jne    800889 <strlcpy+0x23>
  80087e:	eb 17                	jmp    800897 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800880:	83 c2 01             	add    $0x1,%edx
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800889:	39 d8                	cmp    %ebx,%eax
  80088b:	74 07                	je     800894 <strlcpy+0x2e>
  80088d:	0f b6 0a             	movzbl (%edx),%ecx
  800890:	84 c9                	test   %cl,%cl
  800892:	75 ec                	jne    800880 <strlcpy+0x1a>
		*dst = '\0';
  800894:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800897:	29 f0                	sub    %esi,%eax
}
  800899:	5b                   	pop    %ebx
  80089a:	5e                   	pop    %esi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a6:	eb 06                	jmp    8008ae <strcmp+0x11>
		p++, q++;
  8008a8:	83 c1 01             	add    $0x1,%ecx
  8008ab:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008ae:	0f b6 01             	movzbl (%ecx),%eax
  8008b1:	84 c0                	test   %al,%al
  8008b3:	74 04                	je     8008b9 <strcmp+0x1c>
  8008b5:	3a 02                	cmp    (%edx),%al
  8008b7:	74 ef                	je     8008a8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b9:	0f b6 c0             	movzbl %al,%eax
  8008bc:	0f b6 12             	movzbl (%edx),%edx
  8008bf:	29 d0                	sub    %edx,%eax
}
  8008c1:	5d                   	pop    %ebp
  8008c2:	c3                   	ret    

008008c3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	53                   	push   %ebx
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cd:	89 c3                	mov    %eax,%ebx
  8008cf:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d2:	eb 06                	jmp    8008da <strncmp+0x17>
		n--, p++, q++;
  8008d4:	83 c0 01             	add    $0x1,%eax
  8008d7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008da:	39 d8                	cmp    %ebx,%eax
  8008dc:	74 16                	je     8008f4 <strncmp+0x31>
  8008de:	0f b6 08             	movzbl (%eax),%ecx
  8008e1:	84 c9                	test   %cl,%cl
  8008e3:	74 04                	je     8008e9 <strncmp+0x26>
  8008e5:	3a 0a                	cmp    (%edx),%cl
  8008e7:	74 eb                	je     8008d4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e9:	0f b6 00             	movzbl (%eax),%eax
  8008ec:	0f b6 12             	movzbl (%edx),%edx
  8008ef:	29 d0                	sub    %edx,%eax
}
  8008f1:	5b                   	pop    %ebx
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    
		return 0;
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f9:	eb f6                	jmp    8008f1 <strncmp+0x2e>

008008fb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	0f b6 10             	movzbl (%eax),%edx
  800908:	84 d2                	test   %dl,%dl
  80090a:	74 09                	je     800915 <strchr+0x1a>
		if (*s == c)
  80090c:	38 ca                	cmp    %cl,%dl
  80090e:	74 0a                	je     80091a <strchr+0x1f>
	for (; *s; s++)
  800910:	83 c0 01             	add    $0x1,%eax
  800913:	eb f0                	jmp    800905 <strchr+0xa>
			return (char *) s;
	return 0;
  800915:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 45 08             	mov    0x8(%ebp),%eax
  800922:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800926:	eb 03                	jmp    80092b <strfind+0xf>
  800928:	83 c0 01             	add    $0x1,%eax
  80092b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80092e:	38 ca                	cmp    %cl,%dl
  800930:	74 04                	je     800936 <strfind+0x1a>
  800932:	84 d2                	test   %dl,%dl
  800934:	75 f2                	jne    800928 <strfind+0xc>
			break;
	return (char *) s;
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	57                   	push   %edi
  80093c:	56                   	push   %esi
  80093d:	53                   	push   %ebx
  80093e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800941:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800944:	85 c9                	test   %ecx,%ecx
  800946:	74 13                	je     80095b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800948:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80094e:	75 05                	jne    800955 <memset+0x1d>
  800950:	f6 c1 03             	test   $0x3,%cl
  800953:	74 0d                	je     800962 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	fc                   	cld    
  800959:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095b:	89 f8                	mov    %edi,%eax
  80095d:	5b                   	pop    %ebx
  80095e:	5e                   	pop    %esi
  80095f:	5f                   	pop    %edi
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    
		c &= 0xFF;
  800962:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800966:	89 d3                	mov    %edx,%ebx
  800968:	c1 e3 08             	shl    $0x8,%ebx
  80096b:	89 d0                	mov    %edx,%eax
  80096d:	c1 e0 18             	shl    $0x18,%eax
  800970:	89 d6                	mov    %edx,%esi
  800972:	c1 e6 10             	shl    $0x10,%esi
  800975:	09 f0                	or     %esi,%eax
  800977:	09 c2                	or     %eax,%edx
  800979:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80097b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80097e:	89 d0                	mov    %edx,%eax
  800980:	fc                   	cld    
  800981:	f3 ab                	rep stos %eax,%es:(%edi)
  800983:	eb d6                	jmp    80095b <memset+0x23>

00800985 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	57                   	push   %edi
  800989:	56                   	push   %esi
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800990:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800993:	39 c6                	cmp    %eax,%esi
  800995:	73 35                	jae    8009cc <memmove+0x47>
  800997:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	76 2e                	jbe    8009cc <memmove+0x47>
		s += n;
		d += n;
  80099e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a1:	89 d6                	mov    %edx,%esi
  8009a3:	09 fe                	or     %edi,%esi
  8009a5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ab:	74 0c                	je     8009b9 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ad:	83 ef 01             	sub    $0x1,%edi
  8009b0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009b3:	fd                   	std    
  8009b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b6:	fc                   	cld    
  8009b7:	eb 21                	jmp    8009da <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b9:	f6 c1 03             	test   $0x3,%cl
  8009bc:	75 ef                	jne    8009ad <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009be:	83 ef 04             	sub    $0x4,%edi
  8009c1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009c7:	fd                   	std    
  8009c8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ca:	eb ea                	jmp    8009b6 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cc:	89 f2                	mov    %esi,%edx
  8009ce:	09 c2                	or     %eax,%edx
  8009d0:	f6 c2 03             	test   $0x3,%dl
  8009d3:	74 09                	je     8009de <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d5:	89 c7                	mov    %eax,%edi
  8009d7:	fc                   	cld    
  8009d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009da:	5e                   	pop    %esi
  8009db:	5f                   	pop    %edi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009de:	f6 c1 03             	test   $0x3,%cl
  8009e1:	75 f2                	jne    8009d5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009e6:	89 c7                	mov    %eax,%edi
  8009e8:	fc                   	cld    
  8009e9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009eb:	eb ed                	jmp    8009da <memmove+0x55>

008009ed <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009f0:	ff 75 10             	pushl  0x10(%ebp)
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	ff 75 08             	pushl  0x8(%ebp)
  8009f9:	e8 87 ff ff ff       	call   800985 <memmove>
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	56                   	push   %esi
  800a04:	53                   	push   %ebx
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0b:	89 c6                	mov    %eax,%esi
  800a0d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a10:	39 f0                	cmp    %esi,%eax
  800a12:	74 1c                	je     800a30 <memcmp+0x30>
		if (*s1 != *s2)
  800a14:	0f b6 08             	movzbl (%eax),%ecx
  800a17:	0f b6 1a             	movzbl (%edx),%ebx
  800a1a:	38 d9                	cmp    %bl,%cl
  800a1c:	75 08                	jne    800a26 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a1e:	83 c0 01             	add    $0x1,%eax
  800a21:	83 c2 01             	add    $0x1,%edx
  800a24:	eb ea                	jmp    800a10 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a26:	0f b6 c1             	movzbl %cl,%eax
  800a29:	0f b6 db             	movzbl %bl,%ebx
  800a2c:	29 d8                	sub    %ebx,%eax
  800a2e:	eb 05                	jmp    800a35 <memcmp+0x35>
	}

	return 0;
  800a30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a42:	89 c2                	mov    %eax,%edx
  800a44:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a47:	39 d0                	cmp    %edx,%eax
  800a49:	73 09                	jae    800a54 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a4b:	38 08                	cmp    %cl,(%eax)
  800a4d:	74 05                	je     800a54 <memfind+0x1b>
	for (; s < ends; s++)
  800a4f:	83 c0 01             	add    $0x1,%eax
  800a52:	eb f3                	jmp    800a47 <memfind+0xe>
			break;
	return (void *) s;
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	57                   	push   %edi
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a62:	eb 03                	jmp    800a67 <strtol+0x11>
		s++;
  800a64:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a67:	0f b6 01             	movzbl (%ecx),%eax
  800a6a:	3c 20                	cmp    $0x20,%al
  800a6c:	74 f6                	je     800a64 <strtol+0xe>
  800a6e:	3c 09                	cmp    $0x9,%al
  800a70:	74 f2                	je     800a64 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a72:	3c 2b                	cmp    $0x2b,%al
  800a74:	74 2e                	je     800aa4 <strtol+0x4e>
	int neg = 0;
  800a76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a7b:	3c 2d                	cmp    $0x2d,%al
  800a7d:	74 2f                	je     800aae <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a7f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a85:	75 05                	jne    800a8c <strtol+0x36>
  800a87:	80 39 30             	cmpb   $0x30,(%ecx)
  800a8a:	74 2c                	je     800ab8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a8c:	85 db                	test   %ebx,%ebx
  800a8e:	75 0a                	jne    800a9a <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a90:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a95:	80 39 30             	cmpb   $0x30,(%ecx)
  800a98:	74 28                	je     800ac2 <strtol+0x6c>
		base = 10;
  800a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9f:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aa2:	eb 50                	jmp    800af4 <strtol+0x9e>
		s++;
  800aa4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800aa7:	bf 00 00 00 00       	mov    $0x0,%edi
  800aac:	eb d1                	jmp    800a7f <strtol+0x29>
		s++, neg = 1;
  800aae:	83 c1 01             	add    $0x1,%ecx
  800ab1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ab6:	eb c7                	jmp    800a7f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800abc:	74 0e                	je     800acc <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800abe:	85 db                	test   %ebx,%ebx
  800ac0:	75 d8                	jne    800a9a <strtol+0x44>
		s++, base = 8;
  800ac2:	83 c1 01             	add    $0x1,%ecx
  800ac5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aca:	eb ce                	jmp    800a9a <strtol+0x44>
		s += 2, base = 16;
  800acc:	83 c1 02             	add    $0x2,%ecx
  800acf:	bb 10 00 00 00       	mov    $0x10,%ebx
  800ad4:	eb c4                	jmp    800a9a <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ad6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ad9:	89 f3                	mov    %esi,%ebx
  800adb:	80 fb 19             	cmp    $0x19,%bl
  800ade:	77 29                	ja     800b09 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800ae0:	0f be d2             	movsbl %dl,%edx
  800ae3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ae6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ae9:	7d 30                	jge    800b1b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800aeb:	83 c1 01             	add    $0x1,%ecx
  800aee:	0f af 45 10          	imul   0x10(%ebp),%eax
  800af2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800af4:	0f b6 11             	movzbl (%ecx),%edx
  800af7:	8d 72 d0             	lea    -0x30(%edx),%esi
  800afa:	89 f3                	mov    %esi,%ebx
  800afc:	80 fb 09             	cmp    $0x9,%bl
  800aff:	77 d5                	ja     800ad6 <strtol+0x80>
			dig = *s - '0';
  800b01:	0f be d2             	movsbl %dl,%edx
  800b04:	83 ea 30             	sub    $0x30,%edx
  800b07:	eb dd                	jmp    800ae6 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b09:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b0c:	89 f3                	mov    %esi,%ebx
  800b0e:	80 fb 19             	cmp    $0x19,%bl
  800b11:	77 08                	ja     800b1b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b13:	0f be d2             	movsbl %dl,%edx
  800b16:	83 ea 37             	sub    $0x37,%edx
  800b19:	eb cb                	jmp    800ae6 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1f:	74 05                	je     800b26 <strtol+0xd0>
		*endptr = (char *) s;
  800b21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b24:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b26:	89 c2                	mov    %eax,%edx
  800b28:	f7 da                	neg    %edx
  800b2a:	85 ff                	test   %edi,%edi
  800b2c:	0f 45 c2             	cmovne %edx,%eax
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b45:	89 c3                	mov    %eax,%ebx
  800b47:	89 c7                	mov    %eax,%edi
  800b49:	89 c6                	mov    %eax,%esi
  800b4b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b4d:	5b                   	pop    %ebx
  800b4e:	5e                   	pop    %esi
  800b4f:	5f                   	pop    %edi
  800b50:	5d                   	pop    %ebp
  800b51:	c3                   	ret    

00800b52 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	57                   	push   %edi
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b58:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b62:	89 d1                	mov    %edx,%ecx
  800b64:	89 d3                	mov    %edx,%ebx
  800b66:	89 d7                	mov    %edx,%edi
  800b68:	89 d6                	mov    %edx,%esi
  800b6a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5f                   	pop    %edi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	57                   	push   %edi
  800b75:	56                   	push   %esi
  800b76:	53                   	push   %ebx
  800b77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b82:	b8 03 00 00 00       	mov    $0x3,%eax
  800b87:	89 cb                	mov    %ecx,%ebx
  800b89:	89 cf                	mov    %ecx,%edi
  800b8b:	89 ce                	mov    %ecx,%esi
  800b8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	7f 08                	jg     800b9b <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5f                   	pop    %edi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b9b:	83 ec 0c             	sub    $0xc,%esp
  800b9e:	50                   	push   %eax
  800b9f:	6a 03                	push   $0x3
  800ba1:	68 1f 29 80 00       	push   $0x80291f
  800ba6:	6a 23                	push   $0x23
  800ba8:	68 3c 29 80 00       	push   $0x80293c
  800bad:	e8 0c 16 00 00       	call   8021be <_panic>

00800bb2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bb8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbd:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc2:	89 d1                	mov    %edx,%ecx
  800bc4:	89 d3                	mov    %edx,%ebx
  800bc6:	89 d7                	mov    %edx,%edi
  800bc8:	89 d6                	mov    %edx,%esi
  800bca:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bcc:	5b                   	pop    %ebx
  800bcd:	5e                   	pop    %esi
  800bce:	5f                   	pop    %edi
  800bcf:	5d                   	pop    %ebp
  800bd0:	c3                   	ret    

00800bd1 <sys_yield>:

void
sys_yield(void)
{
  800bd1:	55                   	push   %ebp
  800bd2:	89 e5                	mov    %esp,%ebp
  800bd4:	57                   	push   %edi
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be1:	89 d1                	mov    %edx,%ecx
  800be3:	89 d3                	mov    %edx,%ebx
  800be5:	89 d7                	mov    %edx,%edi
  800be7:	89 d6                	mov    %edx,%esi
  800be9:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf9:	be 00 00 00 00       	mov    $0x0,%esi
  800bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c04:	b8 04 00 00 00       	mov    $0x4,%eax
  800c09:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0c:	89 f7                	mov    %esi,%edi
  800c0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c10:	85 c0                	test   %eax,%eax
  800c12:	7f 08                	jg     800c1c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800c20:	6a 04                	push   $0x4
  800c22:	68 1f 29 80 00       	push   $0x80291f
  800c27:	6a 23                	push   $0x23
  800c29:	68 3c 29 80 00       	push   $0x80293c
  800c2e:	e8 8b 15 00 00       	call   8021be <_panic>

00800c33 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c42:	b8 05 00 00 00       	mov    $0x5,%eax
  800c47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c4d:	8b 75 18             	mov    0x18(%ebp),%esi
  800c50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c52:	85 c0                	test   %eax,%eax
  800c54:	7f 08                	jg     800c5e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800c62:	6a 05                	push   $0x5
  800c64:	68 1f 29 80 00       	push   $0x80291f
  800c69:	6a 23                	push   $0x23
  800c6b:	68 3c 29 80 00       	push   $0x80293c
  800c70:	e8 49 15 00 00       	call   8021be <_panic>

00800c75 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800c89:	b8 06 00 00 00       	mov    $0x6,%eax
  800c8e:	89 df                	mov    %ebx,%edi
  800c90:	89 de                	mov    %ebx,%esi
  800c92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c94:	85 c0                	test   %eax,%eax
  800c96:	7f 08                	jg     800ca0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800ca4:	6a 06                	push   $0x6
  800ca6:	68 1f 29 80 00       	push   $0x80291f
  800cab:	6a 23                	push   $0x23
  800cad:	68 3c 29 80 00       	push   $0x80293c
  800cb2:	e8 07 15 00 00       	call   8021be <_panic>

00800cb7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800ccb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd0:	89 df                	mov    %ebx,%edi
  800cd2:	89 de                	mov    %ebx,%esi
  800cd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	7f 08                	jg     800ce2 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800ce6:	6a 08                	push   $0x8
  800ce8:	68 1f 29 80 00       	push   $0x80291f
  800ced:	6a 23                	push   $0x23
  800cef:	68 3c 29 80 00       	push   $0x80293c
  800cf4:	e8 c5 14 00 00       	call   8021be <_panic>

00800cf9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
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
  800d0d:	b8 09 00 00 00       	mov    $0x9,%eax
  800d12:	89 df                	mov    %ebx,%edi
  800d14:	89 de                	mov    %ebx,%esi
  800d16:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	7f 08                	jg     800d24 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800d28:	6a 09                	push   $0x9
  800d2a:	68 1f 29 80 00       	push   $0x80291f
  800d2f:	6a 23                	push   $0x23
  800d31:	68 3c 29 80 00       	push   $0x80293c
  800d36:	e8 83 14 00 00       	call   8021be <_panic>

00800d3b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d54:	89 df                	mov    %ebx,%edi
  800d56:	89 de                	mov    %ebx,%esi
  800d58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5a:	85 c0                	test   %eax,%eax
  800d5c:	7f 08                	jg     800d66 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d66:	83 ec 0c             	sub    $0xc,%esp
  800d69:	50                   	push   %eax
  800d6a:	6a 0a                	push   $0xa
  800d6c:	68 1f 29 80 00       	push   $0x80291f
  800d71:	6a 23                	push   $0x23
  800d73:	68 3c 29 80 00       	push   $0x80293c
  800d78:	e8 41 14 00 00       	call   8021be <_panic>

00800d7d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d96:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d99:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db6:	89 cb                	mov    %ecx,%ebx
  800db8:	89 cf                	mov    %ecx,%edi
  800dba:	89 ce                	mov    %ecx,%esi
  800dbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7f 08                	jg     800dca <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 0d                	push   $0xd
  800dd0:	68 1f 29 80 00       	push   $0x80291f
  800dd5:	6a 23                	push   $0x23
  800dd7:	68 3c 29 80 00       	push   $0x80293c
  800ddc:	e8 dd 13 00 00       	call   8021be <_panic>

00800de1 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de7:	ba 00 00 00 00       	mov    $0x0,%edx
  800dec:	b8 0e 00 00 00       	mov    $0xe,%eax
  800df1:	89 d1                	mov    %edx,%ecx
  800df3:	89 d3                	mov    %edx,%ebx
  800df5:	89 d7                	mov    %edx,%edi
  800df7:	89 d6                	mov    %edx,%esi
  800df9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800e08:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800e0a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e0e:	74 7f                	je     800e8f <pgfault+0x8f>
  800e10:	89 d8                	mov    %ebx,%eax
  800e12:	c1 e8 0c             	shr    $0xc,%eax
  800e15:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e1c:	f6 c4 08             	test   $0x8,%ah
  800e1f:	74 6e                	je     800e8f <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800e21:	e8 8c fd ff ff       	call   800bb2 <sys_getenvid>
  800e26:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e28:	83 ec 04             	sub    $0x4,%esp
  800e2b:	6a 07                	push   $0x7
  800e2d:	68 00 f0 7f 00       	push   $0x7ff000
  800e32:	50                   	push   %eax
  800e33:	e8 b8 fd ff ff       	call   800bf0 <sys_page_alloc>
  800e38:	83 c4 10             	add    $0x10,%esp
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	78 64                	js     800ea3 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800e3f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800e45:	83 ec 04             	sub    $0x4,%esp
  800e48:	68 00 10 00 00       	push   $0x1000
  800e4d:	53                   	push   %ebx
  800e4e:	68 00 f0 7f 00       	push   $0x7ff000
  800e53:	e8 2d fb ff ff       	call   800985 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800e58:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e5f:	53                   	push   %ebx
  800e60:	56                   	push   %esi
  800e61:	68 00 f0 7f 00       	push   $0x7ff000
  800e66:	56                   	push   %esi
  800e67:	e8 c7 fd ff ff       	call   800c33 <sys_page_map>
  800e6c:	83 c4 20             	add    $0x20,%esp
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	78 42                	js     800eb5 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e73:	83 ec 08             	sub    $0x8,%esp
  800e76:	68 00 f0 7f 00       	push   $0x7ff000
  800e7b:	56                   	push   %esi
  800e7c:	e8 f4 fd ff ff       	call   800c75 <sys_page_unmap>
  800e81:	83 c4 10             	add    $0x10,%esp
  800e84:	85 c0                	test   %eax,%eax
  800e86:	78 3f                	js     800ec7 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800e88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5d                   	pop    %ebp
  800e8e:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 4c 29 80 00       	push   $0x80294c
  800e97:	6a 1d                	push   $0x1d
  800e99:	68 db 29 80 00       	push   $0x8029db
  800e9e:	e8 1b 13 00 00       	call   8021be <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800ea3:	50                   	push   %eax
  800ea4:	68 74 29 80 00       	push   $0x802974
  800ea9:	6a 28                	push   $0x28
  800eab:	68 db 29 80 00       	push   $0x8029db
  800eb0:	e8 09 13 00 00       	call   8021be <_panic>
		panic("pgfault:page map failed: %e", r);
  800eb5:	50                   	push   %eax
  800eb6:	68 e6 29 80 00       	push   $0x8029e6
  800ebb:	6a 2c                	push   $0x2c
  800ebd:	68 db 29 80 00       	push   $0x8029db
  800ec2:	e8 f7 12 00 00       	call   8021be <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800ec7:	50                   	push   %eax
  800ec8:	68 98 29 80 00       	push   $0x802998
  800ecd:	6a 2e                	push   $0x2e
  800ecf:	68 db 29 80 00       	push   $0x8029db
  800ed4:	e8 e5 12 00 00       	call   8021be <_panic>

00800ed9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800ee2:	68 00 0e 80 00       	push   $0x800e00
  800ee7:	e8 18 13 00 00       	call   802204 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800eec:	b8 07 00 00 00       	mov    $0x7,%eax
  800ef1:	cd 30                	int    $0x30
  800ef3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800ef6:	83 c4 10             	add    $0x10,%esp
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	78 2f                	js     800f2c <fork+0x53>
  800efd:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800eff:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800f04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f08:	75 6e                	jne    800f78 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f0a:	e8 a3 fc ff ff       	call   800bb2 <sys_getenvid>
  800f0f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f14:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f17:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f1c:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800f2c:	50                   	push   %eax
  800f2d:	68 b8 29 80 00       	push   $0x8029b8
  800f32:	6a 6e                	push   $0x6e
  800f34:	68 db 29 80 00       	push   $0x8029db
  800f39:	e8 80 12 00 00       	call   8021be <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800f3e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	25 07 0e 00 00       	and    $0xe07,%eax
  800f4d:	50                   	push   %eax
  800f4e:	56                   	push   %esi
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	6a 00                	push   $0x0
  800f53:	e8 db fc ff ff       	call   800c33 <sys_page_map>
  800f58:	83 c4 20             	add    $0x20,%esp
  800f5b:	85 c0                	test   %eax,%eax
  800f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f62:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  800f65:	85 c0                	test   %eax,%eax
  800f67:	78 bb                	js     800f24 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f69:	83 c3 01             	add    $0x1,%ebx
  800f6c:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  800f72:	0f 84 a6 00 00 00    	je     80101e <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  800f78:	89 d8                	mov    %ebx,%eax
  800f7a:	c1 e8 0a             	shr    $0xa,%eax
  800f7d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f84:	a8 01                	test   $0x1,%al
  800f86:	74 e1                	je     800f69 <fork+0x90>
  800f88:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f8f:	a8 01                	test   $0x1,%al
  800f91:	74 d6                	je     800f69 <fork+0x90>
  800f93:	89 de                	mov    %ebx,%esi
  800f95:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  800f98:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f9f:	f6 c4 04             	test   $0x4,%ah
  800fa2:	75 9a                	jne    800f3e <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  800fa4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fab:	a8 02                	test   $0x2,%al
  800fad:	75 0c                	jne    800fbb <fork+0xe2>
  800faf:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fb6:	f6 c4 08             	test   $0x8,%ah
  800fb9:	74 42                	je     800ffd <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	68 05 08 00 00       	push   $0x805
  800fc3:	56                   	push   %esi
  800fc4:	57                   	push   %edi
  800fc5:	56                   	push   %esi
  800fc6:	6a 00                	push   $0x0
  800fc8:	e8 66 fc ff ff       	call   800c33 <sys_page_map>
  800fcd:	83 c4 20             	add    $0x20,%esp
  800fd0:	85 c0                	test   %eax,%eax
  800fd2:	0f 88 4c ff ff ff    	js     800f24 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800fd8:	83 ec 0c             	sub    $0xc,%esp
  800fdb:	68 05 08 00 00       	push   $0x805
  800fe0:	56                   	push   %esi
  800fe1:	6a 00                	push   $0x0
  800fe3:	56                   	push   %esi
  800fe4:	6a 00                	push   $0x0
  800fe6:	e8 48 fc ff ff       	call   800c33 <sys_page_map>
  800feb:	83 c4 20             	add    $0x20,%esp
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff5:	0f 4f c1             	cmovg  %ecx,%eax
  800ff8:	e9 68 ff ff ff       	jmp    800f65 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  800ffd:	83 ec 0c             	sub    $0xc,%esp
  801000:	6a 05                	push   $0x5
  801002:	56                   	push   %esi
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	6a 00                	push   $0x0
  801007:	e8 27 fc ff ff       	call   800c33 <sys_page_map>
  80100c:	83 c4 20             	add    $0x20,%esp
  80100f:	85 c0                	test   %eax,%eax
  801011:	b9 00 00 00 00       	mov    $0x0,%ecx
  801016:	0f 4f c1             	cmovg  %ecx,%eax
  801019:	e9 47 ff ff ff       	jmp    800f65 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	6a 07                	push   $0x7
  801023:	68 00 f0 bf ee       	push   $0xeebff000
  801028:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80102b:	57                   	push   %edi
  80102c:	e8 bf fb ff ff       	call   800bf0 <sys_page_alloc>
  801031:	83 c4 10             	add    $0x10,%esp
  801034:	85 c0                	test   %eax,%eax
  801036:	0f 88 e8 fe ff ff    	js     800f24 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  80103c:	83 ec 08             	sub    $0x8,%esp
  80103f:	68 69 22 80 00       	push   $0x802269
  801044:	57                   	push   %edi
  801045:	e8 f1 fc ff ff       	call   800d3b <sys_env_set_pgfault_upcall>
  80104a:	83 c4 10             	add    $0x10,%esp
  80104d:	85 c0                	test   %eax,%eax
  80104f:	0f 88 cf fe ff ff    	js     800f24 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	6a 02                	push   $0x2
  80105a:	57                   	push   %edi
  80105b:	e8 57 fc ff ff       	call   800cb7 <sys_env_set_status>
  801060:	83 c4 10             	add    $0x10,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	78 08                	js     80106f <fork+0x196>
	return eid;
  801067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80106a:	e9 b5 fe ff ff       	jmp    800f24 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  80106f:	50                   	push   %eax
  801070:	68 02 2a 80 00       	push   $0x802a02
  801075:	68 87 00 00 00       	push   $0x87
  80107a:	68 db 29 80 00       	push   $0x8029db
  80107f:	e8 3a 11 00 00       	call   8021be <_panic>

00801084 <sfork>:

// Challenge!
int sfork(void)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80108a:	68 20 2a 80 00       	push   $0x802a20
  80108f:	68 8f 00 00 00       	push   $0x8f
  801094:	68 db 29 80 00       	push   $0x8029db
  801099:	e8 20 11 00 00       	call   8021be <_panic>

0080109e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	05 00 00 00 30       	add    $0x30000000,%eax
  8010a9:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    

008010ae <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010be:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c3:	5d                   	pop    %ebp
  8010c4:	c3                   	ret    

008010c5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cb:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d0:	89 c2                	mov    %eax,%edx
  8010d2:	c1 ea 16             	shr    $0x16,%edx
  8010d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010dc:	f6 c2 01             	test   $0x1,%dl
  8010df:	74 2a                	je     80110b <fd_alloc+0x46>
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	c1 ea 0c             	shr    $0xc,%edx
  8010e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ed:	f6 c2 01             	test   $0x1,%dl
  8010f0:	74 19                	je     80110b <fd_alloc+0x46>
  8010f2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010f7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010fc:	75 d2                	jne    8010d0 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010fe:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801104:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801109:	eb 07                	jmp    801112 <fd_alloc+0x4d>
			*fd_store = fd;
  80110b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80110d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80111a:	83 f8 1f             	cmp    $0x1f,%eax
  80111d:	77 36                	ja     801155 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80111f:	c1 e0 0c             	shl    $0xc,%eax
  801122:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801127:	89 c2                	mov    %eax,%edx
  801129:	c1 ea 16             	shr    $0x16,%edx
  80112c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801133:	f6 c2 01             	test   $0x1,%dl
  801136:	74 24                	je     80115c <fd_lookup+0x48>
  801138:	89 c2                	mov    %eax,%edx
  80113a:	c1 ea 0c             	shr    $0xc,%edx
  80113d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801144:	f6 c2 01             	test   $0x1,%dl
  801147:	74 1a                	je     801163 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114c:	89 02                	mov    %eax,(%edx)
	return 0;
  80114e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801153:	5d                   	pop    %ebp
  801154:	c3                   	ret    
		return -E_INVAL;
  801155:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115a:	eb f7                	jmp    801153 <fd_lookup+0x3f>
		return -E_INVAL;
  80115c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801161:	eb f0                	jmp    801153 <fd_lookup+0x3f>
  801163:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801168:	eb e9                	jmp    801153 <fd_lookup+0x3f>

0080116a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	83 ec 08             	sub    $0x8,%esp
  801170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801173:	ba b4 2a 80 00       	mov    $0x802ab4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801178:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80117d:	39 08                	cmp    %ecx,(%eax)
  80117f:	74 33                	je     8011b4 <dev_lookup+0x4a>
  801181:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801184:	8b 02                	mov    (%edx),%eax
  801186:	85 c0                	test   %eax,%eax
  801188:	75 f3                	jne    80117d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80118a:	a1 08 40 80 00       	mov    0x804008,%eax
  80118f:	8b 40 48             	mov    0x48(%eax),%eax
  801192:	83 ec 04             	sub    $0x4,%esp
  801195:	51                   	push   %ecx
  801196:	50                   	push   %eax
  801197:	68 38 2a 80 00       	push   $0x802a38
  80119c:	e8 37 f0 ff ff       	call   8001d8 <cprintf>
	*dev = 0;
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    
			*dev = devtab[i];
  8011b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011be:	eb f2                	jmp    8011b2 <dev_lookup+0x48>

008011c0 <fd_close>:
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
  8011c6:	83 ec 1c             	sub    $0x1c,%esp
  8011c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011d2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011d9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011dc:	50                   	push   %eax
  8011dd:	e8 32 ff ff ff       	call   801114 <fd_lookup>
  8011e2:	89 c3                	mov    %eax,%ebx
  8011e4:	83 c4 08             	add    $0x8,%esp
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	78 05                	js     8011f0 <fd_close+0x30>
	    || fd != fd2)
  8011eb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011ee:	74 16                	je     801206 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011f0:	89 f8                	mov    %edi,%eax
  8011f2:	84 c0                	test   %al,%al
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f9:	0f 44 d8             	cmove  %eax,%ebx
}
  8011fc:	89 d8                	mov    %ebx,%eax
  8011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80120c:	50                   	push   %eax
  80120d:	ff 36                	pushl  (%esi)
  80120f:	e8 56 ff ff ff       	call   80116a <dev_lookup>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 15                	js     801232 <fd_close+0x72>
		if (dev->dev_close)
  80121d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801220:	8b 40 10             	mov    0x10(%eax),%eax
  801223:	85 c0                	test   %eax,%eax
  801225:	74 1b                	je     801242 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	56                   	push   %esi
  80122b:	ff d0                	call   *%eax
  80122d:	89 c3                	mov    %eax,%ebx
  80122f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	56                   	push   %esi
  801236:	6a 00                	push   $0x0
  801238:	e8 38 fa ff ff       	call   800c75 <sys_page_unmap>
	return r;
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	eb ba                	jmp    8011fc <fd_close+0x3c>
			r = 0;
  801242:	bb 00 00 00 00       	mov    $0x0,%ebx
  801247:	eb e9                	jmp    801232 <fd_close+0x72>

00801249 <close>:

int
close(int fdnum)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801252:	50                   	push   %eax
  801253:	ff 75 08             	pushl  0x8(%ebp)
  801256:	e8 b9 fe ff ff       	call   801114 <fd_lookup>
  80125b:	83 c4 08             	add    $0x8,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 10                	js     801272 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801262:	83 ec 08             	sub    $0x8,%esp
  801265:	6a 01                	push   $0x1
  801267:	ff 75 f4             	pushl  -0xc(%ebp)
  80126a:	e8 51 ff ff ff       	call   8011c0 <fd_close>
  80126f:	83 c4 10             	add    $0x10,%esp
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <close_all>:

void
close_all(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	53                   	push   %ebx
  801278:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80127b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801280:	83 ec 0c             	sub    $0xc,%esp
  801283:	53                   	push   %ebx
  801284:	e8 c0 ff ff ff       	call   801249 <close>
	for (i = 0; i < MAXFD; i++)
  801289:	83 c3 01             	add    $0x1,%ebx
  80128c:	83 c4 10             	add    $0x10,%esp
  80128f:	83 fb 20             	cmp    $0x20,%ebx
  801292:	75 ec                	jne    801280 <close_all+0xc>
}
  801294:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a5:	50                   	push   %eax
  8012a6:	ff 75 08             	pushl  0x8(%ebp)
  8012a9:	e8 66 fe ff ff       	call   801114 <fd_lookup>
  8012ae:	89 c3                	mov    %eax,%ebx
  8012b0:	83 c4 08             	add    $0x8,%esp
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	0f 88 81 00 00 00    	js     80133c <dup+0xa3>
		return r;
	close(newfdnum);
  8012bb:	83 ec 0c             	sub    $0xc,%esp
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	e8 83 ff ff ff       	call   801249 <close>

	newfd = INDEX2FD(newfdnum);
  8012c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012c9:	c1 e6 0c             	shl    $0xc,%esi
  8012cc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012d2:	83 c4 04             	add    $0x4,%esp
  8012d5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d8:	e8 d1 fd ff ff       	call   8010ae <fd2data>
  8012dd:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012df:	89 34 24             	mov    %esi,(%esp)
  8012e2:	e8 c7 fd ff ff       	call   8010ae <fd2data>
  8012e7:	83 c4 10             	add    $0x10,%esp
  8012ea:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ec:	89 d8                	mov    %ebx,%eax
  8012ee:	c1 e8 16             	shr    $0x16,%eax
  8012f1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012f8:	a8 01                	test   $0x1,%al
  8012fa:	74 11                	je     80130d <dup+0x74>
  8012fc:	89 d8                	mov    %ebx,%eax
  8012fe:	c1 e8 0c             	shr    $0xc,%eax
  801301:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801308:	f6 c2 01             	test   $0x1,%dl
  80130b:	75 39                	jne    801346 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80130d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801310:	89 d0                	mov    %edx,%eax
  801312:	c1 e8 0c             	shr    $0xc,%eax
  801315:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	25 07 0e 00 00       	and    $0xe07,%eax
  801324:	50                   	push   %eax
  801325:	56                   	push   %esi
  801326:	6a 00                	push   $0x0
  801328:	52                   	push   %edx
  801329:	6a 00                	push   $0x0
  80132b:	e8 03 f9 ff ff       	call   800c33 <sys_page_map>
  801330:	89 c3                	mov    %eax,%ebx
  801332:	83 c4 20             	add    $0x20,%esp
  801335:	85 c0                	test   %eax,%eax
  801337:	78 31                	js     80136a <dup+0xd1>
		goto err;

	return newfdnum;
  801339:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80133c:	89 d8                	mov    %ebx,%eax
  80133e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801341:	5b                   	pop    %ebx
  801342:	5e                   	pop    %esi
  801343:	5f                   	pop    %edi
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801346:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	25 07 0e 00 00       	and    $0xe07,%eax
  801355:	50                   	push   %eax
  801356:	57                   	push   %edi
  801357:	6a 00                	push   $0x0
  801359:	53                   	push   %ebx
  80135a:	6a 00                	push   $0x0
  80135c:	e8 d2 f8 ff ff       	call   800c33 <sys_page_map>
  801361:	89 c3                	mov    %eax,%ebx
  801363:	83 c4 20             	add    $0x20,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	79 a3                	jns    80130d <dup+0x74>
	sys_page_unmap(0, newfd);
  80136a:	83 ec 08             	sub    $0x8,%esp
  80136d:	56                   	push   %esi
  80136e:	6a 00                	push   $0x0
  801370:	e8 00 f9 ff ff       	call   800c75 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801375:	83 c4 08             	add    $0x8,%esp
  801378:	57                   	push   %edi
  801379:	6a 00                	push   $0x0
  80137b:	e8 f5 f8 ff ff       	call   800c75 <sys_page_unmap>
	return r;
  801380:	83 c4 10             	add    $0x10,%esp
  801383:	eb b7                	jmp    80133c <dup+0xa3>

00801385 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	53                   	push   %ebx
  801389:	83 ec 14             	sub    $0x14,%esp
  80138c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801392:	50                   	push   %eax
  801393:	53                   	push   %ebx
  801394:	e8 7b fd ff ff       	call   801114 <fd_lookup>
  801399:	83 c4 08             	add    $0x8,%esp
  80139c:	85 c0                	test   %eax,%eax
  80139e:	78 3f                	js     8013df <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013aa:	ff 30                	pushl  (%eax)
  8013ac:	e8 b9 fd ff ff       	call   80116a <dev_lookup>
  8013b1:	83 c4 10             	add    $0x10,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	78 27                	js     8013df <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bb:	8b 42 08             	mov    0x8(%edx),%eax
  8013be:	83 e0 03             	and    $0x3,%eax
  8013c1:	83 f8 01             	cmp    $0x1,%eax
  8013c4:	74 1e                	je     8013e4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c9:	8b 40 08             	mov    0x8(%eax),%eax
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 35                	je     801405 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	ff 75 10             	pushl  0x10(%ebp)
  8013d6:	ff 75 0c             	pushl  0xc(%ebp)
  8013d9:	52                   	push   %edx
  8013da:	ff d0                	call   *%eax
  8013dc:	83 c4 10             	add    $0x10,%esp
}
  8013df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013e9:	8b 40 48             	mov    0x48(%eax),%eax
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	50                   	push   %eax
  8013f1:	68 79 2a 80 00       	push   $0x802a79
  8013f6:	e8 dd ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801403:	eb da                	jmp    8013df <read+0x5a>
		return -E_NOT_SUPP;
  801405:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140a:	eb d3                	jmp    8013df <read+0x5a>

0080140c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 0c             	sub    $0xc,%esp
  801415:	8b 7d 08             	mov    0x8(%ebp),%edi
  801418:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801420:	39 f3                	cmp    %esi,%ebx
  801422:	73 25                	jae    801449 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	89 f0                	mov    %esi,%eax
  801429:	29 d8                	sub    %ebx,%eax
  80142b:	50                   	push   %eax
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	03 45 0c             	add    0xc(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	57                   	push   %edi
  801433:	e8 4d ff ff ff       	call   801385 <read>
		if (m < 0)
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 08                	js     801447 <readn+0x3b>
			return m;
		if (m == 0)
  80143f:	85 c0                	test   %eax,%eax
  801441:	74 06                	je     801449 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801443:	01 c3                	add    %eax,%ebx
  801445:	eb d9                	jmp    801420 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801447:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	53                   	push   %ebx
  801457:	83 ec 14             	sub    $0x14,%esp
  80145a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801460:	50                   	push   %eax
  801461:	53                   	push   %ebx
  801462:	e8 ad fc ff ff       	call   801114 <fd_lookup>
  801467:	83 c4 08             	add    $0x8,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 3a                	js     8014a8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146e:	83 ec 08             	sub    $0x8,%esp
  801471:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801474:	50                   	push   %eax
  801475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801478:	ff 30                	pushl  (%eax)
  80147a:	e8 eb fc ff ff       	call   80116a <dev_lookup>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	85 c0                	test   %eax,%eax
  801484:	78 22                	js     8014a8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80148d:	74 1e                	je     8014ad <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801492:	8b 52 0c             	mov    0xc(%edx),%edx
  801495:	85 d2                	test   %edx,%edx
  801497:	74 35                	je     8014ce <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801499:	83 ec 04             	sub    $0x4,%esp
  80149c:	ff 75 10             	pushl  0x10(%ebp)
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	50                   	push   %eax
  8014a3:	ff d2                	call   *%edx
  8014a5:	83 c4 10             	add    $0x10,%esp
}
  8014a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ad:	a1 08 40 80 00       	mov    0x804008,%eax
  8014b2:	8b 40 48             	mov    0x48(%eax),%eax
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	53                   	push   %ebx
  8014b9:	50                   	push   %eax
  8014ba:	68 95 2a 80 00       	push   $0x802a95
  8014bf:	e8 14 ed ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  8014c4:	83 c4 10             	add    $0x10,%esp
  8014c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014cc:	eb da                	jmp    8014a8 <write+0x55>
		return -E_NOT_SUPP;
  8014ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d3:	eb d3                	jmp    8014a8 <write+0x55>

008014d5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 2d fc ff ff       	call   801114 <fd_lookup>
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 0e                	js     8014fc <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	53                   	push   %ebx
  801502:	83 ec 14             	sub    $0x14,%esp
  801505:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801508:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150b:	50                   	push   %eax
  80150c:	53                   	push   %ebx
  80150d:	e8 02 fc ff ff       	call   801114 <fd_lookup>
  801512:	83 c4 08             	add    $0x8,%esp
  801515:	85 c0                	test   %eax,%eax
  801517:	78 37                	js     801550 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80151f:	50                   	push   %eax
  801520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801523:	ff 30                	pushl  (%eax)
  801525:	e8 40 fc ff ff       	call   80116a <dev_lookup>
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	85 c0                	test   %eax,%eax
  80152f:	78 1f                	js     801550 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801538:	74 1b                	je     801555 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80153a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80153d:	8b 52 18             	mov    0x18(%edx),%edx
  801540:	85 d2                	test   %edx,%edx
  801542:	74 32                	je     801576 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801544:	83 ec 08             	sub    $0x8,%esp
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	50                   	push   %eax
  80154b:	ff d2                	call   *%edx
  80154d:	83 c4 10             	add    $0x10,%esp
}
  801550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801553:	c9                   	leave  
  801554:	c3                   	ret    
			thisenv->env_id, fdnum);
  801555:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80155a:	8b 40 48             	mov    0x48(%eax),%eax
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	53                   	push   %ebx
  801561:	50                   	push   %eax
  801562:	68 58 2a 80 00       	push   $0x802a58
  801567:	e8 6c ec ff ff       	call   8001d8 <cprintf>
		return -E_INVAL;
  80156c:	83 c4 10             	add    $0x10,%esp
  80156f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801574:	eb da                	jmp    801550 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801576:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80157b:	eb d3                	jmp    801550 <ftruncate+0x52>

0080157d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	53                   	push   %ebx
  801581:	83 ec 14             	sub    $0x14,%esp
  801584:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801587:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158a:	50                   	push   %eax
  80158b:	ff 75 08             	pushl  0x8(%ebp)
  80158e:	e8 81 fb ff ff       	call   801114 <fd_lookup>
  801593:	83 c4 08             	add    $0x8,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 4b                	js     8015e5 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a0:	50                   	push   %eax
  8015a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a4:	ff 30                	pushl  (%eax)
  8015a6:	e8 bf fb ff ff       	call   80116a <dev_lookup>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 33                	js     8015e5 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b9:	74 2f                	je     8015ea <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015bb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015be:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c5:	00 00 00 
	stat->st_isdir = 0;
  8015c8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cf:	00 00 00 
	stat->st_dev = dev;
  8015d2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d8:	83 ec 08             	sub    $0x8,%esp
  8015db:	53                   	push   %ebx
  8015dc:	ff 75 f0             	pushl  -0x10(%ebp)
  8015df:	ff 50 14             	call   *0x14(%eax)
  8015e2:	83 c4 10             	add    $0x10,%esp
}
  8015e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    
		return -E_NOT_SUPP;
  8015ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ef:	eb f4                	jmp    8015e5 <fstat+0x68>

008015f1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	56                   	push   %esi
  8015f5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f6:	83 ec 08             	sub    $0x8,%esp
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 08             	pushl  0x8(%ebp)
  8015fe:	e8 e7 01 00 00       	call   8017ea <open>
  801603:	89 c3                	mov    %eax,%ebx
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	85 c0                	test   %eax,%eax
  80160a:	78 1b                	js     801627 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	50                   	push   %eax
  801613:	e8 65 ff ff ff       	call   80157d <fstat>
  801618:	89 c6                	mov    %eax,%esi
	close(fd);
  80161a:	89 1c 24             	mov    %ebx,(%esp)
  80161d:	e8 27 fc ff ff       	call   801249 <close>
	return r;
  801622:	83 c4 10             	add    $0x10,%esp
  801625:	89 f3                	mov    %esi,%ebx
}
  801627:	89 d8                	mov    %ebx,%eax
  801629:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5d                   	pop    %ebp
  80162f:	c3                   	ret    

00801630 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	56                   	push   %esi
  801634:	53                   	push   %ebx
  801635:	89 c6                	mov    %eax,%esi
  801637:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801639:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801640:	74 27                	je     801669 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801642:	6a 07                	push   $0x7
  801644:	68 00 50 80 00       	push   $0x805000
  801649:	56                   	push   %esi
  80164a:	ff 35 00 40 80 00    	pushl  0x804000
  801650:	e8 a1 0c 00 00       	call   8022f6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801655:	83 c4 0c             	add    $0xc,%esp
  801658:	6a 00                	push   $0x0
  80165a:	53                   	push   %ebx
  80165b:	6a 00                	push   $0x0
  80165d:	e8 2d 0c 00 00       	call   80228f <ipc_recv>
}
  801662:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	6a 01                	push   $0x1
  80166e:	e8 d7 0c 00 00       	call   80234a <ipc_find_env>
  801673:	a3 00 40 80 00       	mov    %eax,0x804000
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	eb c5                	jmp    801642 <fsipc+0x12>

0080167d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	8b 40 0c             	mov    0xc(%eax),%eax
  801689:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80168e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801691:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801696:	ba 00 00 00 00       	mov    $0x0,%edx
  80169b:	b8 02 00 00 00       	mov    $0x2,%eax
  8016a0:	e8 8b ff ff ff       	call   801630 <fsipc>
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <devfile_flush>:
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c2:	e8 69 ff ff ff       	call   801630 <fsipc>
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <devfile_stat>:
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	53                   	push   %ebx
  8016cd:	83 ec 04             	sub    $0x4,%esp
  8016d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e8:	e8 43 ff ff ff       	call   801630 <fsipc>
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 2c                	js     80171d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f1:	83 ec 08             	sub    $0x8,%esp
  8016f4:	68 00 50 80 00       	push   $0x805000
  8016f9:	53                   	push   %ebx
  8016fa:	e8 f8 f0 ff ff       	call   8007f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ff:	a1 80 50 80 00       	mov    0x805080,%eax
  801704:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80170a:	a1 84 50 80 00       	mov    0x805084,%eax
  80170f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <devfile_write>:
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801730:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801735:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801738:	8b 55 08             	mov    0x8(%ebp),%edx
  80173b:	8b 52 0c             	mov    0xc(%edx),%edx
  80173e:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801744:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801749:	50                   	push   %eax
  80174a:	ff 75 0c             	pushl  0xc(%ebp)
  80174d:	68 08 50 80 00       	push   $0x805008
  801752:	e8 2e f2 ff ff       	call   800985 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	b8 04 00 00 00       	mov    $0x4,%eax
  801761:	e8 ca fe ff ff       	call   801630 <fsipc>
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <devfile_read>:
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 40 0c             	mov    0xc(%eax),%eax
  801776:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80177b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801781:	ba 00 00 00 00       	mov    $0x0,%edx
  801786:	b8 03 00 00 00       	mov    $0x3,%eax
  80178b:	e8 a0 fe ff ff       	call   801630 <fsipc>
  801790:	89 c3                	mov    %eax,%ebx
  801792:	85 c0                	test   %eax,%eax
  801794:	78 1f                	js     8017b5 <devfile_read+0x4d>
	assert(r <= n);
  801796:	39 f0                	cmp    %esi,%eax
  801798:	77 24                	ja     8017be <devfile_read+0x56>
	assert(r <= PGSIZE);
  80179a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80179f:	7f 33                	jg     8017d4 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	50                   	push   %eax
  8017a5:	68 00 50 80 00       	push   $0x805000
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	e8 d3 f1 ff ff       	call   800985 <memmove>
	return r;
  8017b2:	83 c4 10             	add    $0x10,%esp
}
  8017b5:	89 d8                	mov    %ebx,%eax
  8017b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ba:	5b                   	pop    %ebx
  8017bb:	5e                   	pop    %esi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    
	assert(r <= n);
  8017be:	68 c8 2a 80 00       	push   $0x802ac8
  8017c3:	68 cf 2a 80 00       	push   $0x802acf
  8017c8:	6a 7b                	push   $0x7b
  8017ca:	68 e4 2a 80 00       	push   $0x802ae4
  8017cf:	e8 ea 09 00 00       	call   8021be <_panic>
	assert(r <= PGSIZE);
  8017d4:	68 ef 2a 80 00       	push   $0x802aef
  8017d9:	68 cf 2a 80 00       	push   $0x802acf
  8017de:	6a 7c                	push   $0x7c
  8017e0:	68 e4 2a 80 00       	push   $0x802ae4
  8017e5:	e8 d4 09 00 00       	call   8021be <_panic>

008017ea <open>:
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	56                   	push   %esi
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 1c             	sub    $0x1c,%esp
  8017f2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017f5:	56                   	push   %esi
  8017f6:	e8 c5 ef ff ff       	call   8007c0 <strlen>
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801803:	7f 6c                	jg     801871 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180b:	50                   	push   %eax
  80180c:	e8 b4 f8 ff ff       	call   8010c5 <fd_alloc>
  801811:	89 c3                	mov    %eax,%ebx
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	85 c0                	test   %eax,%eax
  801818:	78 3c                	js     801856 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80181a:	83 ec 08             	sub    $0x8,%esp
  80181d:	56                   	push   %esi
  80181e:	68 00 50 80 00       	push   $0x805000
  801823:	e8 cf ef ff ff       	call   8007f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801833:	b8 01 00 00 00       	mov    $0x1,%eax
  801838:	e8 f3 fd ff ff       	call   801630 <fsipc>
  80183d:	89 c3                	mov    %eax,%ebx
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	78 19                	js     80185f <open+0x75>
	return fd2num(fd);
  801846:	83 ec 0c             	sub    $0xc,%esp
  801849:	ff 75 f4             	pushl  -0xc(%ebp)
  80184c:	e8 4d f8 ff ff       	call   80109e <fd2num>
  801851:	89 c3                	mov    %eax,%ebx
  801853:	83 c4 10             	add    $0x10,%esp
}
  801856:	89 d8                	mov    %ebx,%eax
  801858:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    
		fd_close(fd, 0);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	6a 00                	push   $0x0
  801864:	ff 75 f4             	pushl  -0xc(%ebp)
  801867:	e8 54 f9 ff ff       	call   8011c0 <fd_close>
		return r;
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	eb e5                	jmp    801856 <open+0x6c>
		return -E_BAD_PATH;
  801871:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801876:	eb de                	jmp    801856 <open+0x6c>

00801878 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80187e:	ba 00 00 00 00       	mov    $0x0,%edx
  801883:	b8 08 00 00 00       	mov    $0x8,%eax
  801888:	e8 a3 fd ff ff       	call   801630 <fsipc>
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801895:	68 fb 2a 80 00       	push   $0x802afb
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	e8 55 ef ff ff       	call   8007f7 <strcpy>
	return 0;
}
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <devsock_close>:
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	53                   	push   %ebx
  8018ad:	83 ec 10             	sub    $0x10,%esp
  8018b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018b3:	53                   	push   %ebx
  8018b4:	e8 ca 0a 00 00       	call   802383 <pageref>
  8018b9:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018bc:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018c1:	83 f8 01             	cmp    $0x1,%eax
  8018c4:	74 07                	je     8018cd <devsock_close+0x24>
}
  8018c6:	89 d0                	mov    %edx,%eax
  8018c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018cd:	83 ec 0c             	sub    $0xc,%esp
  8018d0:	ff 73 0c             	pushl  0xc(%ebx)
  8018d3:	e8 b7 02 00 00       	call   801b8f <nsipc_close>
  8018d8:	89 c2                	mov    %eax,%edx
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	eb e7                	jmp    8018c6 <devsock_close+0x1d>

008018df <devsock_write>:
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	ff 75 10             	pushl  0x10(%ebp)
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	ff 70 0c             	pushl  0xc(%eax)
  8018f3:	e8 74 03 00 00       	call   801c6c <nsipc_send>
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <devsock_read>:
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801900:	6a 00                	push   $0x0
  801902:	ff 75 10             	pushl  0x10(%ebp)
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	ff 70 0c             	pushl  0xc(%eax)
  80190e:	e8 ed 02 00 00       	call   801c00 <nsipc_recv>
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <fd2sockid>:
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80191b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	e8 ef f7 ff ff       	call   801114 <fd_lookup>
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	85 c0                	test   %eax,%eax
  80192a:	78 10                	js     80193c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80192c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801935:	39 08                	cmp    %ecx,(%eax)
  801937:	75 05                	jne    80193e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801939:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    
		return -E_NOT_SUPP;
  80193e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801943:	eb f7                	jmp    80193c <fd2sockid+0x27>

00801945 <alloc_sockfd>:
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	56                   	push   %esi
  801949:	53                   	push   %ebx
  80194a:	83 ec 1c             	sub    $0x1c,%esp
  80194d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80194f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801952:	50                   	push   %eax
  801953:	e8 6d f7 ff ff       	call   8010c5 <fd_alloc>
  801958:	89 c3                	mov    %eax,%ebx
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	85 c0                	test   %eax,%eax
  80195f:	78 43                	js     8019a4 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	68 07 04 00 00       	push   $0x407
  801969:	ff 75 f4             	pushl  -0xc(%ebp)
  80196c:	6a 00                	push   $0x0
  80196e:	e8 7d f2 ff ff       	call   800bf0 <sys_page_alloc>
  801973:	89 c3                	mov    %eax,%ebx
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	85 c0                	test   %eax,%eax
  80197a:	78 28                	js     8019a4 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801985:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801991:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801994:	83 ec 0c             	sub    $0xc,%esp
  801997:	50                   	push   %eax
  801998:	e8 01 f7 ff ff       	call   80109e <fd2num>
  80199d:	89 c3                	mov    %eax,%ebx
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	eb 0c                	jmp    8019b0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	56                   	push   %esi
  8019a8:	e8 e2 01 00 00       	call   801b8f <nsipc_close>
		return r;
  8019ad:	83 c4 10             	add    $0x10,%esp
}
  8019b0:	89 d8                	mov    %ebx,%eax
  8019b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b5:	5b                   	pop    %ebx
  8019b6:	5e                   	pop    %esi
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    

008019b9 <accept>:
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	e8 4e ff ff ff       	call   801915 <fd2sockid>
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 1b                	js     8019e6 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	ff 75 10             	pushl  0x10(%ebp)
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	50                   	push   %eax
  8019d5:	e8 0e 01 00 00       	call   801ae8 <nsipc_accept>
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	85 c0                	test   %eax,%eax
  8019df:	78 05                	js     8019e6 <accept+0x2d>
	return alloc_sockfd(r);
  8019e1:	e8 5f ff ff ff       	call   801945 <alloc_sockfd>
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <bind>:
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	e8 1f ff ff ff       	call   801915 <fd2sockid>
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 12                	js     801a0c <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	ff 75 10             	pushl  0x10(%ebp)
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	50                   	push   %eax
  801a04:	e8 2f 01 00 00       	call   801b38 <nsipc_bind>
  801a09:	83 c4 10             	add    $0x10,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <shutdown>:
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	e8 f9 fe ff ff       	call   801915 <fd2sockid>
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 0f                	js     801a2f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a20:	83 ec 08             	sub    $0x8,%esp
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	50                   	push   %eax
  801a27:	e8 41 01 00 00       	call   801b6d <nsipc_shutdown>
  801a2c:	83 c4 10             	add    $0x10,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <connect>:
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	e8 d6 fe ff ff       	call   801915 <fd2sockid>
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 12                	js     801a55 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	ff 75 10             	pushl  0x10(%ebp)
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	e8 57 01 00 00       	call   801ba9 <nsipc_connect>
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <listen>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	e8 b0 fe ff ff       	call   801915 <fd2sockid>
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 0f                	js     801a78 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a69:	83 ec 08             	sub    $0x8,%esp
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	50                   	push   %eax
  801a70:	e8 69 01 00 00       	call   801bde <nsipc_listen>
  801a75:	83 c4 10             	add    $0x10,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <socket>:

int
socket(int domain, int type, int protocol)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	e8 3c 02 00 00       	call   801cca <nsipc_socket>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	85 c0                	test   %eax,%eax
  801a93:	78 05                	js     801a9a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a95:	e8 ab fe ff ff       	call   801945 <alloc_sockfd>
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aa5:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aac:	74 26                	je     801ad4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aae:	6a 07                	push   $0x7
  801ab0:	68 00 60 80 00       	push   $0x806000
  801ab5:	53                   	push   %ebx
  801ab6:	ff 35 04 40 80 00    	pushl  0x804004
  801abc:	e8 35 08 00 00       	call   8022f6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ac1:	83 c4 0c             	add    $0xc,%esp
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	e8 c0 07 00 00       	call   80228f <ipc_recv>
}
  801acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ad4:	83 ec 0c             	sub    $0xc,%esp
  801ad7:	6a 02                	push   $0x2
  801ad9:	e8 6c 08 00 00       	call   80234a <ipc_find_env>
  801ade:	a3 04 40 80 00       	mov    %eax,0x804004
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	eb c6                	jmp    801aae <nsipc+0x12>

00801ae8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	56                   	push   %esi
  801aec:	53                   	push   %ebx
  801aed:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801af8:	8b 06                	mov    (%esi),%eax
  801afa:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aff:	b8 01 00 00 00       	mov    $0x1,%eax
  801b04:	e8 93 ff ff ff       	call   801a9c <nsipc>
  801b09:	89 c3                	mov    %eax,%ebx
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	78 20                	js     801b2f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	ff 35 10 60 80 00    	pushl  0x806010
  801b18:	68 00 60 80 00       	push   $0x806000
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	e8 60 ee ff ff       	call   800985 <memmove>
		*addrlen = ret->ret_addrlen;
  801b25:	a1 10 60 80 00       	mov    0x806010,%eax
  801b2a:	89 06                	mov    %eax,(%esi)
  801b2c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801b2f:	89 d8                	mov    %ebx,%eax
  801b31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5e                   	pop    %esi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    

00801b38 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	53                   	push   %ebx
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b4a:	53                   	push   %ebx
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	68 04 60 80 00       	push   $0x806004
  801b53:	e8 2d ee ff ff       	call   800985 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b58:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b63:	e8 34 ff ff ff       	call   801a9c <nsipc>
}
  801b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b83:	b8 03 00 00 00       	mov    $0x3,%eax
  801b88:	e8 0f ff ff ff       	call   801a9c <nsipc>
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <nsipc_close>:

int
nsipc_close(int s)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b9d:	b8 04 00 00 00       	mov    $0x4,%eax
  801ba2:	e8 f5 fe ff ff       	call   801a9c <nsipc>
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	53                   	push   %ebx
  801bad:	83 ec 08             	sub    $0x8,%esp
  801bb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bbb:	53                   	push   %ebx
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	68 04 60 80 00       	push   $0x806004
  801bc4:	e8 bc ed ff ff       	call   800985 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bc9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bcf:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd4:	e8 c3 fe ff ff       	call   801a9c <nsipc>
}
  801bd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bef:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bf4:	b8 06 00 00 00       	mov    $0x6,%eax
  801bf9:	e8 9e fe ff ff       	call   801a9c <nsipc>
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	56                   	push   %esi
  801c04:	53                   	push   %ebx
  801c05:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c10:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c16:	8b 45 14             	mov    0x14(%ebp),%eax
  801c19:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c1e:	b8 07 00 00 00       	mov    $0x7,%eax
  801c23:	e8 74 fe ff ff       	call   801a9c <nsipc>
  801c28:	89 c3                	mov    %eax,%ebx
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	78 1f                	js     801c4d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c2e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c33:	7f 21                	jg     801c56 <nsipc_recv+0x56>
  801c35:	39 c6                	cmp    %eax,%esi
  801c37:	7c 1d                	jl     801c56 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	50                   	push   %eax
  801c3d:	68 00 60 80 00       	push   $0x806000
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	e8 3b ed ff ff       	call   800985 <memmove>
  801c4a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c4d:	89 d8                	mov    %ebx,%eax
  801c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c56:	68 07 2b 80 00       	push   $0x802b07
  801c5b:	68 cf 2a 80 00       	push   $0x802acf
  801c60:	6a 62                	push   $0x62
  801c62:	68 1c 2b 80 00       	push   $0x802b1c
  801c67:	e8 52 05 00 00       	call   8021be <_panic>

00801c6c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 04             	sub    $0x4,%esp
  801c73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c7e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c84:	7f 2e                	jg     801cb4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	53                   	push   %ebx
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	68 0c 60 80 00       	push   $0x80600c
  801c92:	e8 ee ec ff ff       	call   800985 <memmove>
	nsipcbuf.send.req_size = size;
  801c97:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca0:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ca5:	b8 08 00 00 00       	mov    $0x8,%eax
  801caa:	e8 ed fd ff ff       	call   801a9c <nsipc>
}
  801caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    
	assert(size < 1600);
  801cb4:	68 28 2b 80 00       	push   $0x802b28
  801cb9:	68 cf 2a 80 00       	push   $0x802acf
  801cbe:	6a 6d                	push   $0x6d
  801cc0:	68 1c 2b 80 00       	push   $0x802b1c
  801cc5:	e8 f4 04 00 00       	call   8021be <_panic>

00801cca <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdb:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ce8:	b8 09 00 00 00       	mov    $0x9,%eax
  801ced:	e8 aa fd ff ff       	call   801a9c <nsipc>
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	56                   	push   %esi
  801cf8:	53                   	push   %ebx
  801cf9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	e8 a7 f3 ff ff       	call   8010ae <fd2data>
  801d07:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d09:	83 c4 08             	add    $0x8,%esp
  801d0c:	68 34 2b 80 00       	push   $0x802b34
  801d11:	53                   	push   %ebx
  801d12:	e8 e0 ea ff ff       	call   8007f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d17:	8b 46 04             	mov    0x4(%esi),%eax
  801d1a:	2b 06                	sub    (%esi),%eax
  801d1c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d22:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d29:	00 00 00 
	stat->st_dev = &devpipe;
  801d2c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d33:	30 80 00 
	return 0;
}
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3e:	5b                   	pop    %ebx
  801d3f:	5e                   	pop    %esi
  801d40:	5d                   	pop    %ebp
  801d41:	c3                   	ret    

00801d42 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d4c:	53                   	push   %ebx
  801d4d:	6a 00                	push   $0x0
  801d4f:	e8 21 ef ff ff       	call   800c75 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d54:	89 1c 24             	mov    %ebx,(%esp)
  801d57:	e8 52 f3 ff ff       	call   8010ae <fd2data>
  801d5c:	83 c4 08             	add    $0x8,%esp
  801d5f:	50                   	push   %eax
  801d60:	6a 00                	push   $0x0
  801d62:	e8 0e ef ff ff       	call   800c75 <sys_page_unmap>
}
  801d67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <_pipeisclosed>:
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	57                   	push   %edi
  801d70:	56                   	push   %esi
  801d71:	53                   	push   %ebx
  801d72:	83 ec 1c             	sub    $0x1c,%esp
  801d75:	89 c7                	mov    %eax,%edi
  801d77:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d79:	a1 08 40 80 00       	mov    0x804008,%eax
  801d7e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	57                   	push   %edi
  801d85:	e8 f9 05 00 00       	call   802383 <pageref>
  801d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d8d:	89 34 24             	mov    %esi,(%esp)
  801d90:	e8 ee 05 00 00       	call   802383 <pageref>
		nn = thisenv->env_runs;
  801d95:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d9b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d9e:	83 c4 10             	add    $0x10,%esp
  801da1:	39 cb                	cmp    %ecx,%ebx
  801da3:	74 1b                	je     801dc0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801da5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da8:	75 cf                	jne    801d79 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801daa:	8b 42 58             	mov    0x58(%edx),%eax
  801dad:	6a 01                	push   $0x1
  801daf:	50                   	push   %eax
  801db0:	53                   	push   %ebx
  801db1:	68 3b 2b 80 00       	push   $0x802b3b
  801db6:	e8 1d e4 ff ff       	call   8001d8 <cprintf>
  801dbb:	83 c4 10             	add    $0x10,%esp
  801dbe:	eb b9                	jmp    801d79 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dc0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dc3:	0f 94 c0             	sete   %al
  801dc6:	0f b6 c0             	movzbl %al,%eax
}
  801dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dcc:	5b                   	pop    %ebx
  801dcd:	5e                   	pop    %esi
  801dce:	5f                   	pop    %edi
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    

00801dd1 <devpipe_write>:
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	57                   	push   %edi
  801dd5:	56                   	push   %esi
  801dd6:	53                   	push   %ebx
  801dd7:	83 ec 28             	sub    $0x28,%esp
  801dda:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ddd:	56                   	push   %esi
  801dde:	e8 cb f2 ff ff       	call   8010ae <fd2data>
  801de3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ded:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801df0:	74 4f                	je     801e41 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801df2:	8b 43 04             	mov    0x4(%ebx),%eax
  801df5:	8b 0b                	mov    (%ebx),%ecx
  801df7:	8d 51 20             	lea    0x20(%ecx),%edx
  801dfa:	39 d0                	cmp    %edx,%eax
  801dfc:	72 14                	jb     801e12 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dfe:	89 da                	mov    %ebx,%edx
  801e00:	89 f0                	mov    %esi,%eax
  801e02:	e8 65 ff ff ff       	call   801d6c <_pipeisclosed>
  801e07:	85 c0                	test   %eax,%eax
  801e09:	75 3a                	jne    801e45 <devpipe_write+0x74>
			sys_yield();
  801e0b:	e8 c1 ed ff ff       	call   800bd1 <sys_yield>
  801e10:	eb e0                	jmp    801df2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e15:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e19:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e1c:	89 c2                	mov    %eax,%edx
  801e1e:	c1 fa 1f             	sar    $0x1f,%edx
  801e21:	89 d1                	mov    %edx,%ecx
  801e23:	c1 e9 1b             	shr    $0x1b,%ecx
  801e26:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e29:	83 e2 1f             	and    $0x1f,%edx
  801e2c:	29 ca                	sub    %ecx,%edx
  801e2e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e32:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e36:	83 c0 01             	add    $0x1,%eax
  801e39:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e3c:	83 c7 01             	add    $0x1,%edi
  801e3f:	eb ac                	jmp    801ded <devpipe_write+0x1c>
	return i;
  801e41:	89 f8                	mov    %edi,%eax
  801e43:	eb 05                	jmp    801e4a <devpipe_write+0x79>
				return 0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4d:	5b                   	pop    %ebx
  801e4e:	5e                   	pop    %esi
  801e4f:	5f                   	pop    %edi
  801e50:	5d                   	pop    %ebp
  801e51:	c3                   	ret    

00801e52 <devpipe_read>:
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 18             	sub    $0x18,%esp
  801e5b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e5e:	57                   	push   %edi
  801e5f:	e8 4a f2 ff ff       	call   8010ae <fd2data>
  801e64:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e66:	83 c4 10             	add    $0x10,%esp
  801e69:	be 00 00 00 00       	mov    $0x0,%esi
  801e6e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e71:	74 47                	je     801eba <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801e73:	8b 03                	mov    (%ebx),%eax
  801e75:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e78:	75 22                	jne    801e9c <devpipe_read+0x4a>
			if (i > 0)
  801e7a:	85 f6                	test   %esi,%esi
  801e7c:	75 14                	jne    801e92 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801e7e:	89 da                	mov    %ebx,%edx
  801e80:	89 f8                	mov    %edi,%eax
  801e82:	e8 e5 fe ff ff       	call   801d6c <_pipeisclosed>
  801e87:	85 c0                	test   %eax,%eax
  801e89:	75 33                	jne    801ebe <devpipe_read+0x6c>
			sys_yield();
  801e8b:	e8 41 ed ff ff       	call   800bd1 <sys_yield>
  801e90:	eb e1                	jmp    801e73 <devpipe_read+0x21>
				return i;
  801e92:	89 f0                	mov    %esi,%eax
}
  801e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5f                   	pop    %edi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e9c:	99                   	cltd   
  801e9d:	c1 ea 1b             	shr    $0x1b,%edx
  801ea0:	01 d0                	add    %edx,%eax
  801ea2:	83 e0 1f             	and    $0x1f,%eax
  801ea5:	29 d0                	sub    %edx,%eax
  801ea7:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eaf:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eb2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eb5:	83 c6 01             	add    $0x1,%esi
  801eb8:	eb b4                	jmp    801e6e <devpipe_read+0x1c>
	return i;
  801eba:	89 f0                	mov    %esi,%eax
  801ebc:	eb d6                	jmp    801e94 <devpipe_read+0x42>
				return 0;
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	eb cf                	jmp    801e94 <devpipe_read+0x42>

00801ec5 <pipe>:
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	56                   	push   %esi
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ecd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed0:	50                   	push   %eax
  801ed1:	e8 ef f1 ff ff       	call   8010c5 <fd_alloc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	78 5b                	js     801f3a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 07 04 00 00       	push   $0x407
  801ee7:	ff 75 f4             	pushl  -0xc(%ebp)
  801eea:	6a 00                	push   $0x0
  801eec:	e8 ff ec ff ff       	call   800bf0 <sys_page_alloc>
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	78 40                	js     801f3a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f00:	50                   	push   %eax
  801f01:	e8 bf f1 ff ff       	call   8010c5 <fd_alloc>
  801f06:	89 c3                	mov    %eax,%ebx
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	78 1b                	js     801f2a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	68 07 04 00 00       	push   $0x407
  801f17:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1a:	6a 00                	push   $0x0
  801f1c:	e8 cf ec ff ff       	call   800bf0 <sys_page_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	79 19                	jns    801f43 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801f2a:	83 ec 08             	sub    $0x8,%esp
  801f2d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f30:	6a 00                	push   $0x0
  801f32:	e8 3e ed ff ff       	call   800c75 <sys_page_unmap>
  801f37:	83 c4 10             	add    $0x10,%esp
}
  801f3a:	89 d8                	mov    %ebx,%eax
  801f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    
	va = fd2data(fd0);
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	ff 75 f4             	pushl  -0xc(%ebp)
  801f49:	e8 60 f1 ff ff       	call   8010ae <fd2data>
  801f4e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f50:	83 c4 0c             	add    $0xc,%esp
  801f53:	68 07 04 00 00       	push   $0x407
  801f58:	50                   	push   %eax
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 90 ec ff ff       	call   800bf0 <sys_page_alloc>
  801f60:	89 c3                	mov    %eax,%ebx
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	0f 88 8c 00 00 00    	js     801ff9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	ff 75 f0             	pushl  -0x10(%ebp)
  801f73:	e8 36 f1 ff ff       	call   8010ae <fd2data>
  801f78:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f7f:	50                   	push   %eax
  801f80:	6a 00                	push   $0x0
  801f82:	56                   	push   %esi
  801f83:	6a 00                	push   $0x0
  801f85:	e8 a9 ec ff ff       	call   800c33 <sys_page_map>
  801f8a:	89 c3                	mov    %eax,%ebx
  801f8c:	83 c4 20             	add    $0x20,%esp
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	78 58                	js     801feb <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f9c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fb1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc3:	e8 d6 f0 ff ff       	call   80109e <fd2num>
  801fc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fcd:	83 c4 04             	add    $0x4,%esp
  801fd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd3:	e8 c6 f0 ff ff       	call   80109e <fd2num>
  801fd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fdb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fde:	83 c4 10             	add    $0x10,%esp
  801fe1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fe6:	e9 4f ff ff ff       	jmp    801f3a <pipe+0x75>
	sys_page_unmap(0, va);
  801feb:	83 ec 08             	sub    $0x8,%esp
  801fee:	56                   	push   %esi
  801fef:	6a 00                	push   $0x0
  801ff1:	e8 7f ec ff ff       	call   800c75 <sys_page_unmap>
  801ff6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fff:	6a 00                	push   $0x0
  802001:	e8 6f ec ff ff       	call   800c75 <sys_page_unmap>
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	e9 1c ff ff ff       	jmp    801f2a <pipe+0x65>

0080200e <pipeisclosed>:
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802014:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	ff 75 08             	pushl  0x8(%ebp)
  80201b:	e8 f4 f0 ff ff       	call   801114 <fd_lookup>
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	85 c0                	test   %eax,%eax
  802025:	78 18                	js     80203f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	ff 75 f4             	pushl  -0xc(%ebp)
  80202d:	e8 7c f0 ff ff       	call   8010ae <fd2data>
	return _pipeisclosed(fd, p);
  802032:	89 c2                	mov    %eax,%edx
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	e8 30 fd ff ff       	call   801d6c <_pipeisclosed>
  80203c:	83 c4 10             	add    $0x10,%esp
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	5d                   	pop    %ebp
  80204a:	c3                   	ret    

0080204b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802051:	68 53 2b 80 00       	push   $0x802b53
  802056:	ff 75 0c             	pushl  0xc(%ebp)
  802059:	e8 99 e7 ff ff       	call   8007f7 <strcpy>
	return 0;
}
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <devcons_write>:
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	57                   	push   %edi
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802071:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802076:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80207c:	eb 2f                	jmp    8020ad <devcons_write+0x48>
		m = n - tot;
  80207e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802081:	29 f3                	sub    %esi,%ebx
  802083:	83 fb 7f             	cmp    $0x7f,%ebx
  802086:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80208b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	53                   	push   %ebx
  802092:	89 f0                	mov    %esi,%eax
  802094:	03 45 0c             	add    0xc(%ebp),%eax
  802097:	50                   	push   %eax
  802098:	57                   	push   %edi
  802099:	e8 e7 e8 ff ff       	call   800985 <memmove>
		sys_cputs(buf, m);
  80209e:	83 c4 08             	add    $0x8,%esp
  8020a1:	53                   	push   %ebx
  8020a2:	57                   	push   %edi
  8020a3:	e8 8c ea ff ff       	call   800b34 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a8:	01 de                	add    %ebx,%esi
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020b0:	72 cc                	jb     80207e <devcons_write+0x19>
}
  8020b2:	89 f0                	mov    %esi,%eax
  8020b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5f                   	pop    %edi
  8020ba:	5d                   	pop    %ebp
  8020bb:	c3                   	ret    

008020bc <devcons_read>:
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
  8020bf:	83 ec 08             	sub    $0x8,%esp
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020cb:	75 07                	jne    8020d4 <devcons_read+0x18>
}
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    
		sys_yield();
  8020cf:	e8 fd ea ff ff       	call   800bd1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8020d4:	e8 79 ea ff ff       	call   800b52 <sys_cgetc>
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	74 f2                	je     8020cf <devcons_read+0x13>
	if (c < 0)
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	78 ec                	js     8020cd <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8020e1:	83 f8 04             	cmp    $0x4,%eax
  8020e4:	74 0c                	je     8020f2 <devcons_read+0x36>
	*(char*)vbuf = c;
  8020e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e9:	88 02                	mov    %al,(%edx)
	return 1;
  8020eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f0:	eb db                	jmp    8020cd <devcons_read+0x11>
		return 0;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f7:	eb d4                	jmp    8020cd <devcons_read+0x11>

008020f9 <cputchar>:
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802105:	6a 01                	push   $0x1
  802107:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210a:	50                   	push   %eax
  80210b:	e8 24 ea ff ff       	call   800b34 <sys_cputs>
}
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <getchar>:
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80211b:	6a 01                	push   $0x1
  80211d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802120:	50                   	push   %eax
  802121:	6a 00                	push   $0x0
  802123:	e8 5d f2 ff ff       	call   801385 <read>
	if (r < 0)
  802128:	83 c4 10             	add    $0x10,%esp
  80212b:	85 c0                	test   %eax,%eax
  80212d:	78 08                	js     802137 <getchar+0x22>
	if (r < 1)
  80212f:	85 c0                	test   %eax,%eax
  802131:	7e 06                	jle    802139 <getchar+0x24>
	return c;
  802133:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    
		return -E_EOF;
  802139:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80213e:	eb f7                	jmp    802137 <getchar+0x22>

00802140 <iscons>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802146:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802149:	50                   	push   %eax
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	e8 c2 ef ff ff       	call   801114 <fd_lookup>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	78 11                	js     80216a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802162:	39 10                	cmp    %edx,(%eax)
  802164:	0f 94 c0             	sete   %al
  802167:	0f b6 c0             	movzbl %al,%eax
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <opencons>:
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802172:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802175:	50                   	push   %eax
  802176:	e8 4a ef ff ff       	call   8010c5 <fd_alloc>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	85 c0                	test   %eax,%eax
  802180:	78 3a                	js     8021bc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	68 07 04 00 00       	push   $0x407
  80218a:	ff 75 f4             	pushl  -0xc(%ebp)
  80218d:	6a 00                	push   $0x0
  80218f:	e8 5c ea ff ff       	call   800bf0 <sys_page_alloc>
  802194:	83 c4 10             	add    $0x10,%esp
  802197:	85 c0                	test   %eax,%eax
  802199:	78 21                	js     8021bc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021b0:	83 ec 0c             	sub    $0xc,%esp
  8021b3:	50                   	push   %eax
  8021b4:	e8 e5 ee ff ff       	call   80109e <fd2num>
  8021b9:	83 c4 10             	add    $0x10,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	56                   	push   %esi
  8021c2:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8021c3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021c6:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021cc:	e8 e1 e9 ff ff       	call   800bb2 <sys_getenvid>
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	ff 75 08             	pushl  0x8(%ebp)
  8021da:	56                   	push   %esi
  8021db:	50                   	push   %eax
  8021dc:	68 60 2b 80 00       	push   $0x802b60
  8021e1:	e8 f2 df ff ff       	call   8001d8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021e6:	83 c4 18             	add    $0x18,%esp
  8021e9:	53                   	push   %ebx
  8021ea:	ff 75 10             	pushl  0x10(%ebp)
  8021ed:	e8 95 df ff ff       	call   800187 <vcprintf>
	cprintf("\n");
  8021f2:	c7 04 24 0f 26 80 00 	movl   $0x80260f,(%esp)
  8021f9:	e8 da df ff ff       	call   8001d8 <cprintf>
  8021fe:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802201:	cc                   	int3   
  802202:	eb fd                	jmp    802201 <_panic+0x43>

00802204 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  80220a:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802211:	74 0a                	je     80221d <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80221d:	a1 08 40 80 00       	mov    0x804008,%eax
  802222:	8b 40 48             	mov    0x48(%eax),%eax
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	6a 07                	push   $0x7
  80222a:	68 00 f0 bf ee       	push   $0xeebff000
  80222f:	50                   	push   %eax
  802230:	e8 bb e9 ff ff       	call   800bf0 <sys_page_alloc>
  802235:	83 c4 10             	add    $0x10,%esp
  802238:	85 c0                	test   %eax,%eax
  80223a:	78 1b                	js     802257 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80223c:	a1 08 40 80 00       	mov    0x804008,%eax
  802241:	8b 40 48             	mov    0x48(%eax),%eax
  802244:	83 ec 08             	sub    $0x8,%esp
  802247:	68 69 22 80 00       	push   $0x802269
  80224c:	50                   	push   %eax
  80224d:	e8 e9 ea ff ff       	call   800d3b <sys_env_set_pgfault_upcall>
  802252:	83 c4 10             	add    $0x10,%esp
  802255:	eb bc                	jmp    802213 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802257:	50                   	push   %eax
  802258:	68 84 2b 80 00       	push   $0x802b84
  80225d:	6a 22                	push   $0x22
  80225f:	68 9c 2b 80 00       	push   $0x802b9c
  802264:	e8 55 ff ff ff       	call   8021be <_panic>

00802269 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802269:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80226a:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80226f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802271:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802274:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802278:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  80227b:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  80227f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802283:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802285:	83 c4 08             	add    $0x8,%esp
	popal
  802288:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802289:	83 c4 04             	add    $0x4,%esp
	popfl
  80228c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80228d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80228e:	c3                   	ret    

0080228f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	8b 75 08             	mov    0x8(%ebp),%esi
  802297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80229d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80229f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022a4:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8022a7:	83 ec 0c             	sub    $0xc,%esp
  8022aa:	50                   	push   %eax
  8022ab:	e8 f0 ea ff ff       	call   800da0 <sys_ipc_recv>
	if (from_env_store)
  8022b0:	83 c4 10             	add    $0x10,%esp
  8022b3:	85 f6                	test   %esi,%esi
  8022b5:	74 14                	je     8022cb <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8022b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	78 09                	js     8022c9 <ipc_recv+0x3a>
  8022c0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8022c6:	8b 52 74             	mov    0x74(%edx),%edx
  8022c9:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8022cb:	85 db                	test   %ebx,%ebx
  8022cd:	74 14                	je     8022e3 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8022cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	78 09                	js     8022e1 <ipc_recv+0x52>
  8022d8:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8022de:	8b 52 78             	mov    0x78(%edx),%edx
  8022e1:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8022e3:	85 c0                	test   %eax,%eax
  8022e5:	78 08                	js     8022ef <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8022e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ec:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8022ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f2:	5b                   	pop    %ebx
  8022f3:	5e                   	pop    %esi
  8022f4:	5d                   	pop    %ebp
  8022f5:	c3                   	ret    

008022f6 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	57                   	push   %edi
  8022fa:	56                   	push   %esi
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  802302:	8b 75 0c             	mov    0xc(%ebp),%esi
  802305:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802308:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80230a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80230f:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802312:	ff 75 14             	pushl  0x14(%ebp)
  802315:	53                   	push   %ebx
  802316:	56                   	push   %esi
  802317:	57                   	push   %edi
  802318:	e8 60 ea ff ff       	call   800d7d <sys_ipc_try_send>
		if (ret == 0)
  80231d:	83 c4 10             	add    $0x10,%esp
  802320:	85 c0                	test   %eax,%eax
  802322:	74 1e                	je     802342 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802324:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802327:	75 07                	jne    802330 <ipc_send+0x3a>
			sys_yield();
  802329:	e8 a3 e8 ff ff       	call   800bd1 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80232e:	eb e2                	jmp    802312 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802330:	50                   	push   %eax
  802331:	68 aa 2b 80 00       	push   $0x802baa
  802336:	6a 3d                	push   $0x3d
  802338:	68 be 2b 80 00       	push   $0x802bbe
  80233d:	e8 7c fe ff ff       	call   8021be <_panic>
	}
	// panic("ipc_send not implemented");
}
  802342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5f                   	pop    %edi
  802348:	5d                   	pop    %ebp
  802349:	c3                   	ret    

0080234a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
  80234d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802350:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802355:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802358:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80235e:	8b 52 50             	mov    0x50(%edx),%edx
  802361:	39 ca                	cmp    %ecx,%edx
  802363:	74 11                	je     802376 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802365:	83 c0 01             	add    $0x1,%eax
  802368:	3d 00 04 00 00       	cmp    $0x400,%eax
  80236d:	75 e6                	jne    802355 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	eb 0b                	jmp    802381 <ipc_find_env+0x37>
			return envs[i].env_id;
  802376:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802379:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80237e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802381:	5d                   	pop    %ebp
  802382:	c3                   	ret    

00802383 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802389:	89 d0                	mov    %edx,%eax
  80238b:	c1 e8 16             	shr    $0x16,%eax
  80238e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80239a:	f6 c1 01             	test   $0x1,%cl
  80239d:	74 1d                	je     8023bc <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80239f:	c1 ea 0c             	shr    $0xc,%edx
  8023a2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023a9:	f6 c2 01             	test   $0x1,%dl
  8023ac:	74 0e                	je     8023bc <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023ae:	c1 ea 0c             	shr    $0xc,%edx
  8023b1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023b8:	ef 
  8023b9:	0f b7 c0             	movzwl %ax,%eax
}
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__udivdi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023d7:	85 d2                	test   %edx,%edx
  8023d9:	75 35                	jne    802410 <__udivdi3+0x50>
  8023db:	39 f3                	cmp    %esi,%ebx
  8023dd:	0f 87 bd 00 00 00    	ja     8024a0 <__udivdi3+0xe0>
  8023e3:	85 db                	test   %ebx,%ebx
  8023e5:	89 d9                	mov    %ebx,%ecx
  8023e7:	75 0b                	jne    8023f4 <__udivdi3+0x34>
  8023e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ee:	31 d2                	xor    %edx,%edx
  8023f0:	f7 f3                	div    %ebx
  8023f2:	89 c1                	mov    %eax,%ecx
  8023f4:	31 d2                	xor    %edx,%edx
  8023f6:	89 f0                	mov    %esi,%eax
  8023f8:	f7 f1                	div    %ecx
  8023fa:	89 c6                	mov    %eax,%esi
  8023fc:	89 e8                	mov    %ebp,%eax
  8023fe:	89 f7                	mov    %esi,%edi
  802400:	f7 f1                	div    %ecx
  802402:	89 fa                	mov    %edi,%edx
  802404:	83 c4 1c             	add    $0x1c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    
  80240c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802410:	39 f2                	cmp    %esi,%edx
  802412:	77 7c                	ja     802490 <__udivdi3+0xd0>
  802414:	0f bd fa             	bsr    %edx,%edi
  802417:	83 f7 1f             	xor    $0x1f,%edi
  80241a:	0f 84 98 00 00 00    	je     8024b8 <__udivdi3+0xf8>
  802420:	89 f9                	mov    %edi,%ecx
  802422:	b8 20 00 00 00       	mov    $0x20,%eax
  802427:	29 f8                	sub    %edi,%eax
  802429:	d3 e2                	shl    %cl,%edx
  80242b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80242f:	89 c1                	mov    %eax,%ecx
  802431:	89 da                	mov    %ebx,%edx
  802433:	d3 ea                	shr    %cl,%edx
  802435:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802439:	09 d1                	or     %edx,%ecx
  80243b:	89 f2                	mov    %esi,%edx
  80243d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802441:	89 f9                	mov    %edi,%ecx
  802443:	d3 e3                	shl    %cl,%ebx
  802445:	89 c1                	mov    %eax,%ecx
  802447:	d3 ea                	shr    %cl,%edx
  802449:	89 f9                	mov    %edi,%ecx
  80244b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80244f:	d3 e6                	shl    %cl,%esi
  802451:	89 eb                	mov    %ebp,%ebx
  802453:	89 c1                	mov    %eax,%ecx
  802455:	d3 eb                	shr    %cl,%ebx
  802457:	09 de                	or     %ebx,%esi
  802459:	89 f0                	mov    %esi,%eax
  80245b:	f7 74 24 08          	divl   0x8(%esp)
  80245f:	89 d6                	mov    %edx,%esi
  802461:	89 c3                	mov    %eax,%ebx
  802463:	f7 64 24 0c          	mull   0xc(%esp)
  802467:	39 d6                	cmp    %edx,%esi
  802469:	72 0c                	jb     802477 <__udivdi3+0xb7>
  80246b:	89 f9                	mov    %edi,%ecx
  80246d:	d3 e5                	shl    %cl,%ebp
  80246f:	39 c5                	cmp    %eax,%ebp
  802471:	73 5d                	jae    8024d0 <__udivdi3+0x110>
  802473:	39 d6                	cmp    %edx,%esi
  802475:	75 59                	jne    8024d0 <__udivdi3+0x110>
  802477:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80247a:	31 ff                	xor    %edi,%edi
  80247c:	89 fa                	mov    %edi,%edx
  80247e:	83 c4 1c             	add    $0x1c,%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5f                   	pop    %edi
  802484:	5d                   	pop    %ebp
  802485:	c3                   	ret    
  802486:	8d 76 00             	lea    0x0(%esi),%esi
  802489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802490:	31 ff                	xor    %edi,%edi
  802492:	31 c0                	xor    %eax,%eax
  802494:	89 fa                	mov    %edi,%edx
  802496:	83 c4 1c             	add    $0x1c,%esp
  802499:	5b                   	pop    %ebx
  80249a:	5e                   	pop    %esi
  80249b:	5f                   	pop    %edi
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	31 ff                	xor    %edi,%edi
  8024a2:	89 e8                	mov    %ebp,%eax
  8024a4:	89 f2                	mov    %esi,%edx
  8024a6:	f7 f3                	div    %ebx
  8024a8:	89 fa                	mov    %edi,%edx
  8024aa:	83 c4 1c             	add    $0x1c,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5e                   	pop    %esi
  8024af:	5f                   	pop    %edi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    
  8024b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b8:	39 f2                	cmp    %esi,%edx
  8024ba:	72 06                	jb     8024c2 <__udivdi3+0x102>
  8024bc:	31 c0                	xor    %eax,%eax
  8024be:	39 eb                	cmp    %ebp,%ebx
  8024c0:	77 d2                	ja     802494 <__udivdi3+0xd4>
  8024c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c7:	eb cb                	jmp    802494 <__udivdi3+0xd4>
  8024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024d0:	89 d8                	mov    %ebx,%eax
  8024d2:	31 ff                	xor    %edi,%edi
  8024d4:	eb be                	jmp    802494 <__udivdi3+0xd4>
  8024d6:	66 90                	xchg   %ax,%ax
  8024d8:	66 90                	xchg   %ax,%ax
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <__umoddi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 1c             	sub    $0x1c,%esp
  8024e7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8024eb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024ef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024f7:	85 ed                	test   %ebp,%ebp
  8024f9:	89 f0                	mov    %esi,%eax
  8024fb:	89 da                	mov    %ebx,%edx
  8024fd:	75 19                	jne    802518 <__umoddi3+0x38>
  8024ff:	39 df                	cmp    %ebx,%edi
  802501:	0f 86 b1 00 00 00    	jbe    8025b8 <__umoddi3+0xd8>
  802507:	f7 f7                	div    %edi
  802509:	89 d0                	mov    %edx,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	83 c4 1c             	add    $0x1c,%esp
  802510:	5b                   	pop    %ebx
  802511:	5e                   	pop    %esi
  802512:	5f                   	pop    %edi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    
  802515:	8d 76 00             	lea    0x0(%esi),%esi
  802518:	39 dd                	cmp    %ebx,%ebp
  80251a:	77 f1                	ja     80250d <__umoddi3+0x2d>
  80251c:	0f bd cd             	bsr    %ebp,%ecx
  80251f:	83 f1 1f             	xor    $0x1f,%ecx
  802522:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802526:	0f 84 b4 00 00 00    	je     8025e0 <__umoddi3+0x100>
  80252c:	b8 20 00 00 00       	mov    $0x20,%eax
  802531:	89 c2                	mov    %eax,%edx
  802533:	8b 44 24 04          	mov    0x4(%esp),%eax
  802537:	29 c2                	sub    %eax,%edx
  802539:	89 c1                	mov    %eax,%ecx
  80253b:	89 f8                	mov    %edi,%eax
  80253d:	d3 e5                	shl    %cl,%ebp
  80253f:	89 d1                	mov    %edx,%ecx
  802541:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802545:	d3 e8                	shr    %cl,%eax
  802547:	09 c5                	or     %eax,%ebp
  802549:	8b 44 24 04          	mov    0x4(%esp),%eax
  80254d:	89 c1                	mov    %eax,%ecx
  80254f:	d3 e7                	shl    %cl,%edi
  802551:	89 d1                	mov    %edx,%ecx
  802553:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802557:	89 df                	mov    %ebx,%edi
  802559:	d3 ef                	shr    %cl,%edi
  80255b:	89 c1                	mov    %eax,%ecx
  80255d:	89 f0                	mov    %esi,%eax
  80255f:	d3 e3                	shl    %cl,%ebx
  802561:	89 d1                	mov    %edx,%ecx
  802563:	89 fa                	mov    %edi,%edx
  802565:	d3 e8                	shr    %cl,%eax
  802567:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256c:	09 d8                	or     %ebx,%eax
  80256e:	f7 f5                	div    %ebp
  802570:	d3 e6                	shl    %cl,%esi
  802572:	89 d1                	mov    %edx,%ecx
  802574:	f7 64 24 08          	mull   0x8(%esp)
  802578:	39 d1                	cmp    %edx,%ecx
  80257a:	89 c3                	mov    %eax,%ebx
  80257c:	89 d7                	mov    %edx,%edi
  80257e:	72 06                	jb     802586 <__umoddi3+0xa6>
  802580:	75 0e                	jne    802590 <__umoddi3+0xb0>
  802582:	39 c6                	cmp    %eax,%esi
  802584:	73 0a                	jae    802590 <__umoddi3+0xb0>
  802586:	2b 44 24 08          	sub    0x8(%esp),%eax
  80258a:	19 ea                	sbb    %ebp,%edx
  80258c:	89 d7                	mov    %edx,%edi
  80258e:	89 c3                	mov    %eax,%ebx
  802590:	89 ca                	mov    %ecx,%edx
  802592:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802597:	29 de                	sub    %ebx,%esi
  802599:	19 fa                	sbb    %edi,%edx
  80259b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80259f:	89 d0                	mov    %edx,%eax
  8025a1:	d3 e0                	shl    %cl,%eax
  8025a3:	89 d9                	mov    %ebx,%ecx
  8025a5:	d3 ee                	shr    %cl,%esi
  8025a7:	d3 ea                	shr    %cl,%edx
  8025a9:	09 f0                	or     %esi,%eax
  8025ab:	83 c4 1c             	add    $0x1c,%esp
  8025ae:	5b                   	pop    %ebx
  8025af:	5e                   	pop    %esi
  8025b0:	5f                   	pop    %edi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    
  8025b3:	90                   	nop
  8025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	85 ff                	test   %edi,%edi
  8025ba:	89 f9                	mov    %edi,%ecx
  8025bc:	75 0b                	jne    8025c9 <__umoddi3+0xe9>
  8025be:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c3:	31 d2                	xor    %edx,%edx
  8025c5:	f7 f7                	div    %edi
  8025c7:	89 c1                	mov    %eax,%ecx
  8025c9:	89 d8                	mov    %ebx,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	f7 f1                	div    %ecx
  8025cf:	89 f0                	mov    %esi,%eax
  8025d1:	f7 f1                	div    %ecx
  8025d3:	e9 31 ff ff ff       	jmp    802509 <__umoddi3+0x29>
  8025d8:	90                   	nop
  8025d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	39 dd                	cmp    %ebx,%ebp
  8025e2:	72 08                	jb     8025ec <__umoddi3+0x10c>
  8025e4:	39 f7                	cmp    %esi,%edi
  8025e6:	0f 87 21 ff ff ff    	ja     80250d <__umoddi3+0x2d>
  8025ec:	89 da                	mov    %ebx,%edx
  8025ee:	89 f0                	mov    %esi,%eax
  8025f0:	29 f8                	sub    %edi,%eax
  8025f2:	19 ea                	sbb    %ebp,%edx
  8025f4:	e9 14 ff ff ff       	jmp    80250d <__umoddi3+0x2d>

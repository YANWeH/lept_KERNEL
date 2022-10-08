
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 ab 00 00 00       	call   8000dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 e0 22 80 00       	push   $0x8022e0
  80003e:	e8 d4 01 00 00       	call   800217 <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	75 63                	jne    8000b8 <umain+0x85>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	83 c0 01             	add    $0x1,%eax
  800058:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005d:	75 ec                	jne    80004b <umain+0x18>
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
  80005f:	b8 00 00 00 00       	mov    $0x0,%eax
		bigarray[i] = i;
  800064:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  80006b:	83 c0 01             	add    $0x1,%eax
  80006e:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800073:	75 ef                	jne    800064 <umain+0x31>
	for (i = 0; i < ARRAYSIZE; i++)
  800075:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != i)
  80007a:	39 04 85 20 40 80 00 	cmp    %eax,0x804020(,%eax,4)
  800081:	75 47                	jne    8000ca <umain+0x97>
	for (i = 0; i < ARRAYSIZE; i++)
  800083:	83 c0 01             	add    $0x1,%eax
  800086:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80008b:	75 ed                	jne    80007a <umain+0x47>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80008d:	83 ec 0c             	sub    $0xc,%esp
  800090:	68 28 23 80 00       	push   $0x802328
  800095:	e8 7d 01 00 00       	call   800217 <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  80009a:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  8000a1:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  8000a4:	83 c4 0c             	add    $0xc,%esp
  8000a7:	68 87 23 80 00       	push   $0x802387
  8000ac:	6a 1a                	push   $0x1a
  8000ae:	68 78 23 80 00       	push   $0x802378
  8000b3:	e8 84 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b8:	50                   	push   %eax
  8000b9:	68 5b 23 80 00       	push   $0x80235b
  8000be:	6a 11                	push   $0x11
  8000c0:	68 78 23 80 00       	push   $0x802378
  8000c5:	e8 72 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000ca:	50                   	push   %eax
  8000cb:	68 00 23 80 00       	push   $0x802300
  8000d0:	6a 16                	push   $0x16
  8000d2:	68 78 23 80 00       	push   $0x802378
  8000d7:	e8 60 00 00 00       	call   80013c <_panic>

008000dc <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	56                   	push   %esi
  8000e0:	53                   	push   %ebx
  8000e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000e4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e7:	e8 05 0b 00 00       	call   800bf1 <sys_getenvid>
  8000ec:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000f4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f9:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x2d>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800128:	e8 e8 0e 00 00       	call   801015 <close_all>
	sys_env_destroy(0);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	6a 00                	push   $0x0
  800132:	e8 79 0a 00 00       	call   800bb0 <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	56                   	push   %esi
  800140:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800141:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800144:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80014a:	e8 a2 0a 00 00       	call   800bf1 <sys_getenvid>
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	ff 75 0c             	pushl  0xc(%ebp)
  800155:	ff 75 08             	pushl  0x8(%ebp)
  800158:	56                   	push   %esi
  800159:	50                   	push   %eax
  80015a:	68 a8 23 80 00       	push   $0x8023a8
  80015f:	e8 b3 00 00 00       	call   800217 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800164:	83 c4 18             	add    $0x18,%esp
  800167:	53                   	push   %ebx
  800168:	ff 75 10             	pushl  0x10(%ebp)
  80016b:	e8 56 00 00 00       	call   8001c6 <vcprintf>
	cprintf("\n");
  800170:	c7 04 24 76 23 80 00 	movl   $0x802376,(%esp)
  800177:	e8 9b 00 00 00       	call   800217 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80017f:	cc                   	int3   
  800180:	eb fd                	jmp    80017f <_panic+0x43>

00800182 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	53                   	push   %ebx
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80018c:	8b 13                	mov    (%ebx),%edx
  80018e:	8d 42 01             	lea    0x1(%edx),%eax
  800191:	89 03                	mov    %eax,(%ebx)
  800193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800196:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80019a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80019f:	74 09                	je     8001aa <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001a1:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	68 ff 00 00 00       	push   $0xff
  8001b2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001b5:	50                   	push   %eax
  8001b6:	e8 b8 09 00 00       	call   800b73 <sys_cputs>
		b->idx = 0;
  8001bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	eb db                	jmp    8001a1 <putch+0x1f>

008001c6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d6:	00 00 00 
	b.cnt = 0;
  8001d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e3:	ff 75 0c             	pushl  0xc(%ebp)
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ef:	50                   	push   %eax
  8001f0:	68 82 01 80 00       	push   $0x800182
  8001f5:	e8 1a 01 00 00       	call   800314 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001fa:	83 c4 08             	add    $0x8,%esp
  8001fd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800203:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800209:	50                   	push   %eax
  80020a:	e8 64 09 00 00       	call   800b73 <sys_cputs>

	return b.cnt;
}
  80020f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80021d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800220:	50                   	push   %eax
  800221:	ff 75 08             	pushl  0x8(%ebp)
  800224:	e8 9d ff ff ff       	call   8001c6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	57                   	push   %edi
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	83 ec 1c             	sub    $0x1c,%esp
  800234:	89 c7                	mov    %eax,%edi
  800236:	89 d6                	mov    %edx,%esi
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800241:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800244:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800247:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80024f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800252:	39 d3                	cmp    %edx,%ebx
  800254:	72 05                	jb     80025b <printnum+0x30>
  800256:	39 45 10             	cmp    %eax,0x10(%ebp)
  800259:	77 7a                	ja     8002d5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	ff 75 18             	pushl  0x18(%ebp)
  800261:	8b 45 14             	mov    0x14(%ebp),%eax
  800264:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800267:	53                   	push   %ebx
  800268:	ff 75 10             	pushl  0x10(%ebp)
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800271:	ff 75 e0             	pushl  -0x20(%ebp)
  800274:	ff 75 dc             	pushl  -0x24(%ebp)
  800277:	ff 75 d8             	pushl  -0x28(%ebp)
  80027a:	e8 11 1e 00 00       	call   802090 <__udivdi3>
  80027f:	83 c4 18             	add    $0x18,%esp
  800282:	52                   	push   %edx
  800283:	50                   	push   %eax
  800284:	89 f2                	mov    %esi,%edx
  800286:	89 f8                	mov    %edi,%eax
  800288:	e8 9e ff ff ff       	call   80022b <printnum>
  80028d:	83 c4 20             	add    $0x20,%esp
  800290:	eb 13                	jmp    8002a5 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	56                   	push   %esi
  800296:	ff 75 18             	pushl  0x18(%ebp)
  800299:	ff d7                	call   *%edi
  80029b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80029e:	83 eb 01             	sub    $0x1,%ebx
  8002a1:	85 db                	test   %ebx,%ebx
  8002a3:	7f ed                	jg     800292 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	56                   	push   %esi
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b8:	e8 f3 1e 00 00       	call   8021b0 <__umoddi3>
  8002bd:	83 c4 14             	add    $0x14,%esp
  8002c0:	0f be 80 cb 23 80 00 	movsbl 0x8023cb(%eax),%eax
  8002c7:	50                   	push   %eax
  8002c8:	ff d7                	call   *%edi
}
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    
  8002d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002d8:	eb c4                	jmp    80029e <printnum+0x73>

008002da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e4:	8b 10                	mov    (%eax),%edx
  8002e6:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e9:	73 0a                	jae    8002f5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	88 02                	mov    %al,(%edx)
}
  8002f5:	5d                   	pop    %ebp
  8002f6:	c3                   	ret    

008002f7 <printfmt>:
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002fd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800300:	50                   	push   %eax
  800301:	ff 75 10             	pushl  0x10(%ebp)
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	e8 05 00 00 00       	call   800314 <vprintfmt>
}
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	c9                   	leave  
  800313:	c3                   	ret    

00800314 <vprintfmt>:
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 2c             	sub    $0x2c,%esp
  80031d:	8b 75 08             	mov    0x8(%ebp),%esi
  800320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800323:	8b 7d 10             	mov    0x10(%ebp),%edi
  800326:	e9 c1 03 00 00       	jmp    8006ec <vprintfmt+0x3d8>
		padc = ' ';
  80032b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80032f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800336:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80033d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800344:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8d 47 01             	lea    0x1(%edi),%eax
  80034c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034f:	0f b6 17             	movzbl (%edi),%edx
  800352:	8d 42 dd             	lea    -0x23(%edx),%eax
  800355:	3c 55                	cmp    $0x55,%al
  800357:	0f 87 12 04 00 00    	ja     80076f <vprintfmt+0x45b>
  80035d:	0f b6 c0             	movzbl %al,%eax
  800360:	ff 24 85 00 25 80 00 	jmp    *0x802500(,%eax,4)
  800367:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80036e:	eb d9                	jmp    800349 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800373:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800377:	eb d0                	jmp    800349 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800379:	0f b6 d2             	movzbl %dl,%edx
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80037f:	b8 00 00 00 00       	mov    $0x0,%eax
  800384:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800387:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80038a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80038e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800391:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800394:	83 f9 09             	cmp    $0x9,%ecx
  800397:	77 55                	ja     8003ee <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	eb e9                	jmp    800387 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	8d 40 04             	lea    0x4(%eax),%eax
  8003ac:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003b6:	79 91                	jns    800349 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003be:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003c5:	eb 82                	jmp    800349 <vprintfmt+0x35>
  8003c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d1:	0f 49 d0             	cmovns %eax,%edx
  8003d4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003da:	e9 6a ff ff ff       	jmp    800349 <vprintfmt+0x35>
  8003df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003e2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003e9:	e9 5b ff ff ff       	jmp    800349 <vprintfmt+0x35>
  8003ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003f4:	eb bc                	jmp    8003b2 <vprintfmt+0x9e>
			lflag++;
  8003f6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fc:	e9 48 ff ff ff       	jmp    800349 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	8d 78 04             	lea    0x4(%eax),%edi
  800407:	83 ec 08             	sub    $0x8,%esp
  80040a:	53                   	push   %ebx
  80040b:	ff 30                	pushl  (%eax)
  80040d:	ff d6                	call   *%esi
			break;
  80040f:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800412:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800415:	e9 cf 02 00 00       	jmp    8006e9 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80041a:	8b 45 14             	mov    0x14(%ebp),%eax
  80041d:	8d 78 04             	lea    0x4(%eax),%edi
  800420:	8b 00                	mov    (%eax),%eax
  800422:	99                   	cltd   
  800423:	31 d0                	xor    %edx,%eax
  800425:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800427:	83 f8 0f             	cmp    $0xf,%eax
  80042a:	7f 23                	jg     80044f <vprintfmt+0x13b>
  80042c:	8b 14 85 60 26 80 00 	mov    0x802660(,%eax,4),%edx
  800433:	85 d2                	test   %edx,%edx
  800435:	74 18                	je     80044f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800437:	52                   	push   %edx
  800438:	68 99 27 80 00       	push   $0x802799
  80043d:	53                   	push   %ebx
  80043e:	56                   	push   %esi
  80043f:	e8 b3 fe ff ff       	call   8002f7 <printfmt>
  800444:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800447:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044a:	e9 9a 02 00 00       	jmp    8006e9 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80044f:	50                   	push   %eax
  800450:	68 e3 23 80 00       	push   $0x8023e3
  800455:	53                   	push   %ebx
  800456:	56                   	push   %esi
  800457:	e8 9b fe ff ff       	call   8002f7 <printfmt>
  80045c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800462:	e9 82 02 00 00       	jmp    8006e9 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800467:	8b 45 14             	mov    0x14(%ebp),%eax
  80046a:	83 c0 04             	add    $0x4,%eax
  80046d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800470:	8b 45 14             	mov    0x14(%ebp),%eax
  800473:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800475:	85 ff                	test   %edi,%edi
  800477:	b8 dc 23 80 00       	mov    $0x8023dc,%eax
  80047c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80047f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800483:	0f 8e bd 00 00 00    	jle    800546 <vprintfmt+0x232>
  800489:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80048d:	75 0e                	jne    80049d <vprintfmt+0x189>
  80048f:	89 75 08             	mov    %esi,0x8(%ebp)
  800492:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800495:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800498:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049b:	eb 6d                	jmp    80050a <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a3:	57                   	push   %edi
  8004a4:	e8 6e 03 00 00       	call   800817 <strnlen>
  8004a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ac:	29 c1                	sub    %eax,%ecx
  8004ae:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bb:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004be:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c0:	eb 0f                	jmp    8004d1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	53                   	push   %ebx
  8004c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cb:	83 ef 01             	sub    $0x1,%edi
  8004ce:	83 c4 10             	add    $0x10,%esp
  8004d1:	85 ff                	test   %edi,%edi
  8004d3:	7f ed                	jg     8004c2 <vprintfmt+0x1ae>
  8004d5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004d8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004db:	85 c9                	test   %ecx,%ecx
  8004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e2:	0f 49 c1             	cmovns %ecx,%eax
  8004e5:	29 c1                	sub    %eax,%ecx
  8004e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f0:	89 cb                	mov    %ecx,%ebx
  8004f2:	eb 16                	jmp    80050a <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f8:	75 31                	jne    80052b <vprintfmt+0x217>
					putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	ff 75 0c             	pushl  0xc(%ebp)
  800500:	50                   	push   %eax
  800501:	ff 55 08             	call   *0x8(%ebp)
  800504:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800507:	83 eb 01             	sub    $0x1,%ebx
  80050a:	83 c7 01             	add    $0x1,%edi
  80050d:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800511:	0f be c2             	movsbl %dl,%eax
  800514:	85 c0                	test   %eax,%eax
  800516:	74 59                	je     800571 <vprintfmt+0x25d>
  800518:	85 f6                	test   %esi,%esi
  80051a:	78 d8                	js     8004f4 <vprintfmt+0x1e0>
  80051c:	83 ee 01             	sub    $0x1,%esi
  80051f:	79 d3                	jns    8004f4 <vprintfmt+0x1e0>
  800521:	89 df                	mov    %ebx,%edi
  800523:	8b 75 08             	mov    0x8(%ebp),%esi
  800526:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800529:	eb 37                	jmp    800562 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80052b:	0f be d2             	movsbl %dl,%edx
  80052e:	83 ea 20             	sub    $0x20,%edx
  800531:	83 fa 5e             	cmp    $0x5e,%edx
  800534:	76 c4                	jbe    8004fa <vprintfmt+0x1e6>
					putch('?', putdat);
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	ff 75 0c             	pushl  0xc(%ebp)
  80053c:	6a 3f                	push   $0x3f
  80053e:	ff 55 08             	call   *0x8(%ebp)
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	eb c1                	jmp    800507 <vprintfmt+0x1f3>
  800546:	89 75 08             	mov    %esi,0x8(%ebp)
  800549:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80054f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800552:	eb b6                	jmp    80050a <vprintfmt+0x1f6>
				putch(' ', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 20                	push   $0x20
  80055a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055c:	83 ef 01             	sub    $0x1,%edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f ee                	jg     800554 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 78 01 00 00       	jmp    8006e9 <vprintfmt+0x3d5>
  800571:	89 df                	mov    %ebx,%edi
  800573:	8b 75 08             	mov    0x8(%ebp),%esi
  800576:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800579:	eb e7                	jmp    800562 <vprintfmt+0x24e>
	if (lflag >= 2)
  80057b:	83 f9 01             	cmp    $0x1,%ecx
  80057e:	7e 3f                	jle    8005bf <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 50 04             	mov    0x4(%eax),%edx
  800586:	8b 00                	mov    (%eax),%eax
  800588:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	8d 40 08             	lea    0x8(%eax),%eax
  800594:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800597:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80059b:	79 5c                	jns    8005f9 <vprintfmt+0x2e5>
				putch('-', putdat);
  80059d:	83 ec 08             	sub    $0x8,%esp
  8005a0:	53                   	push   %ebx
  8005a1:	6a 2d                	push   $0x2d
  8005a3:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005ab:	f7 da                	neg    %edx
  8005ad:	83 d1 00             	adc    $0x0,%ecx
  8005b0:	f7 d9                	neg    %ecx
  8005b2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ba:	e9 10 01 00 00       	jmp    8006cf <vprintfmt+0x3bb>
	else if (lflag)
  8005bf:	85 c9                	test   %ecx,%ecx
  8005c1:	75 1b                	jne    8005de <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 00                	mov    (%eax),%eax
  8005c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cb:	89 c1                	mov    %eax,%ecx
  8005cd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	8d 40 04             	lea    0x4(%eax),%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dc:	eb b9                	jmp    800597 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e6:	89 c1                	mov    %eax,%ecx
  8005e8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005eb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8d 40 04             	lea    0x4(%eax),%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f7:	eb 9e                	jmp    800597 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ff:	b8 0a 00 00 00       	mov    $0xa,%eax
  800604:	e9 c6 00 00 00       	jmp    8006cf <vprintfmt+0x3bb>
	if (lflag >= 2)
  800609:	83 f9 01             	cmp    $0x1,%ecx
  80060c:	7e 18                	jle    800626 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	8b 10                	mov    (%eax),%edx
  800613:	8b 48 04             	mov    0x4(%eax),%ecx
  800616:	8d 40 08             	lea    0x8(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	e9 a9 00 00 00       	jmp    8006cf <vprintfmt+0x3bb>
	else if (lflag)
  800626:	85 c9                	test   %ecx,%ecx
  800628:	75 1a                	jne    800644 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 10                	mov    (%eax),%edx
  80062f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800634:	8d 40 04             	lea    0x4(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063f:	e9 8b 00 00 00       	jmp    8006cf <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 10                	mov    (%eax),%edx
  800649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800654:	b8 0a 00 00 00       	mov    $0xa,%eax
  800659:	eb 74                	jmp    8006cf <vprintfmt+0x3bb>
	if (lflag >= 2)
  80065b:	83 f9 01             	cmp    $0x1,%ecx
  80065e:	7e 15                	jle    800675 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	8b 10                	mov    (%eax),%edx
  800665:	8b 48 04             	mov    0x4(%eax),%ecx
  800668:	8d 40 08             	lea    0x8(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066e:	b8 08 00 00 00       	mov    $0x8,%eax
  800673:	eb 5a                	jmp    8006cf <vprintfmt+0x3bb>
	else if (lflag)
  800675:	85 c9                	test   %ecx,%ecx
  800677:	75 17                	jne    800690 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 10                	mov    (%eax),%edx
  80067e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800683:	8d 40 04             	lea    0x4(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800689:	b8 08 00 00 00       	mov    $0x8,%eax
  80068e:	eb 3f                	jmp    8006cf <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a5:	eb 28                	jmp    8006cf <vprintfmt+0x3bb>
			putch('0', putdat);
  8006a7:	83 ec 08             	sub    $0x8,%esp
  8006aa:	53                   	push   %ebx
  8006ab:	6a 30                	push   $0x30
  8006ad:	ff d6                	call   *%esi
			putch('x', putdat);
  8006af:	83 c4 08             	add    $0x8,%esp
  8006b2:	53                   	push   %ebx
  8006b3:	6a 78                	push   $0x78
  8006b5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 10                	mov    (%eax),%edx
  8006bc:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006c1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c4:	8d 40 04             	lea    0x4(%eax),%eax
  8006c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ca:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006cf:	83 ec 0c             	sub    $0xc,%esp
  8006d2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006d6:	57                   	push   %edi
  8006d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8006da:	50                   	push   %eax
  8006db:	51                   	push   %ecx
  8006dc:	52                   	push   %edx
  8006dd:	89 da                	mov    %ebx,%edx
  8006df:	89 f0                	mov    %esi,%eax
  8006e1:	e8 45 fb ff ff       	call   80022b <printnum>
			break;
  8006e6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ec:	83 c7 01             	add    $0x1,%edi
  8006ef:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f3:	83 f8 25             	cmp    $0x25,%eax
  8006f6:	0f 84 2f fc ff ff    	je     80032b <vprintfmt+0x17>
			if (ch == '\0')
  8006fc:	85 c0                	test   %eax,%eax
  8006fe:	0f 84 8b 00 00 00    	je     80078f <vprintfmt+0x47b>
			putch(ch, putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	53                   	push   %ebx
  800708:	50                   	push   %eax
  800709:	ff d6                	call   *%esi
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	eb dc                	jmp    8006ec <vprintfmt+0x3d8>
	if (lflag >= 2)
  800710:	83 f9 01             	cmp    $0x1,%ecx
  800713:	7e 15                	jle    80072a <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 10                	mov    (%eax),%edx
  80071a:	8b 48 04             	mov    0x4(%eax),%ecx
  80071d:	8d 40 08             	lea    0x8(%eax),%eax
  800720:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800723:	b8 10 00 00 00       	mov    $0x10,%eax
  800728:	eb a5                	jmp    8006cf <vprintfmt+0x3bb>
	else if (lflag)
  80072a:	85 c9                	test   %ecx,%ecx
  80072c:	75 17                	jne    800745 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8b 10                	mov    (%eax),%edx
  800733:	b9 00 00 00 00       	mov    $0x0,%ecx
  800738:	8d 40 04             	lea    0x4(%eax),%eax
  80073b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073e:	b8 10 00 00 00       	mov    $0x10,%eax
  800743:	eb 8a                	jmp    8006cf <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8b 10                	mov    (%eax),%edx
  80074a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074f:	8d 40 04             	lea    0x4(%eax),%eax
  800752:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800755:	b8 10 00 00 00       	mov    $0x10,%eax
  80075a:	e9 70 ff ff ff       	jmp    8006cf <vprintfmt+0x3bb>
			putch(ch, putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	53                   	push   %ebx
  800763:	6a 25                	push   $0x25
  800765:	ff d6                	call   *%esi
			break;
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	e9 7a ff ff ff       	jmp    8006e9 <vprintfmt+0x3d5>
			putch('%', putdat);
  80076f:	83 ec 08             	sub    $0x8,%esp
  800772:	53                   	push   %ebx
  800773:	6a 25                	push   $0x25
  800775:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800777:	83 c4 10             	add    $0x10,%esp
  80077a:	89 f8                	mov    %edi,%eax
  80077c:	eb 03                	jmp    800781 <vprintfmt+0x46d>
  80077e:	83 e8 01             	sub    $0x1,%eax
  800781:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800785:	75 f7                	jne    80077e <vprintfmt+0x46a>
  800787:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80078a:	e9 5a ff ff ff       	jmp    8006e9 <vprintfmt+0x3d5>
}
  80078f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800792:	5b                   	pop    %ebx
  800793:	5e                   	pop    %esi
  800794:	5f                   	pop    %edi
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	83 ec 18             	sub    $0x18,%esp
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007b4:	85 c0                	test   %eax,%eax
  8007b6:	74 26                	je     8007de <vsnprintf+0x47>
  8007b8:	85 d2                	test   %edx,%edx
  8007ba:	7e 22                	jle    8007de <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007bc:	ff 75 14             	pushl  0x14(%ebp)
  8007bf:	ff 75 10             	pushl  0x10(%ebp)
  8007c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c5:	50                   	push   %eax
  8007c6:	68 da 02 80 00       	push   $0x8002da
  8007cb:	e8 44 fb ff ff       	call   800314 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007d3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d9:	83 c4 10             	add    $0x10,%esp
}
  8007dc:	c9                   	leave  
  8007dd:	c3                   	ret    
		return -E_INVAL;
  8007de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e3:	eb f7                	jmp    8007dc <vsnprintf+0x45>

008007e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007eb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ee:	50                   	push   %eax
  8007ef:	ff 75 10             	pushl  0x10(%ebp)
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	ff 75 08             	pushl  0x8(%ebp)
  8007f8:	e8 9a ff ff ff       	call   800797 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    

008007ff <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800805:	b8 00 00 00 00       	mov    $0x0,%eax
  80080a:	eb 03                	jmp    80080f <strlen+0x10>
		n++;
  80080c:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80080f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800813:	75 f7                	jne    80080c <strlen+0xd>
	return n;
}
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800820:	b8 00 00 00 00       	mov    $0x0,%eax
  800825:	eb 03                	jmp    80082a <strnlen+0x13>
		n++;
  800827:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082a:	39 d0                	cmp    %edx,%eax
  80082c:	74 06                	je     800834 <strnlen+0x1d>
  80082e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800832:	75 f3                	jne    800827 <strnlen+0x10>
	return n;
}
  800834:	5d                   	pop    %ebp
  800835:	c3                   	ret    

00800836 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
  800839:	53                   	push   %ebx
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800840:	89 c2                	mov    %eax,%edx
  800842:	83 c1 01             	add    $0x1,%ecx
  800845:	83 c2 01             	add    $0x1,%edx
  800848:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80084c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80084f:	84 db                	test   %bl,%bl
  800851:	75 ef                	jne    800842 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800853:	5b                   	pop    %ebx
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	53                   	push   %ebx
  80085a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80085d:	53                   	push   %ebx
  80085e:	e8 9c ff ff ff       	call   8007ff <strlen>
  800863:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	01 d8                	add    %ebx,%eax
  80086b:	50                   	push   %eax
  80086c:	e8 c5 ff ff ff       	call   800836 <strcpy>
	return dst;
}
  800871:	89 d8                	mov    %ebx,%eax
  800873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800876:	c9                   	leave  
  800877:	c3                   	ret    

00800878 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	56                   	push   %esi
  80087c:	53                   	push   %ebx
  80087d:	8b 75 08             	mov    0x8(%ebp),%esi
  800880:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800883:	89 f3                	mov    %esi,%ebx
  800885:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800888:	89 f2                	mov    %esi,%edx
  80088a:	eb 0f                	jmp    80089b <strncpy+0x23>
		*dst++ = *src;
  80088c:	83 c2 01             	add    $0x1,%edx
  80088f:	0f b6 01             	movzbl (%ecx),%eax
  800892:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800895:	80 39 01             	cmpb   $0x1,(%ecx)
  800898:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80089b:	39 da                	cmp    %ebx,%edx
  80089d:	75 ed                	jne    80088c <strncpy+0x14>
	}
	return ret;
}
  80089f:	89 f0                	mov    %esi,%eax
  8008a1:	5b                   	pop    %ebx
  8008a2:	5e                   	pop    %esi
  8008a3:	5d                   	pop    %ebp
  8008a4:	c3                   	ret    

008008a5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
  8008a8:	56                   	push   %esi
  8008a9:	53                   	push   %ebx
  8008aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b3:	89 f0                	mov    %esi,%eax
  8008b5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b9:	85 c9                	test   %ecx,%ecx
  8008bb:	75 0b                	jne    8008c8 <strlcpy+0x23>
  8008bd:	eb 17                	jmp    8008d6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008bf:	83 c2 01             	add    $0x1,%edx
  8008c2:	83 c0 01             	add    $0x1,%eax
  8008c5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008c8:	39 d8                	cmp    %ebx,%eax
  8008ca:	74 07                	je     8008d3 <strlcpy+0x2e>
  8008cc:	0f b6 0a             	movzbl (%edx),%ecx
  8008cf:	84 c9                	test   %cl,%cl
  8008d1:	75 ec                	jne    8008bf <strlcpy+0x1a>
		*dst = '\0';
  8008d3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008d6:	29 f0                	sub    %esi,%eax
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e5:	eb 06                	jmp    8008ed <strcmp+0x11>
		p++, q++;
  8008e7:	83 c1 01             	add    $0x1,%ecx
  8008ea:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008ed:	0f b6 01             	movzbl (%ecx),%eax
  8008f0:	84 c0                	test   %al,%al
  8008f2:	74 04                	je     8008f8 <strcmp+0x1c>
  8008f4:	3a 02                	cmp    (%edx),%al
  8008f6:	74 ef                	je     8008e7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 c0             	movzbl %al,%eax
  8008fb:	0f b6 12             	movzbl (%edx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
}
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 c3                	mov    %eax,%ebx
  80090e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800911:	eb 06                	jmp    800919 <strncmp+0x17>
		n--, p++, q++;
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800919:	39 d8                	cmp    %ebx,%eax
  80091b:	74 16                	je     800933 <strncmp+0x31>
  80091d:	0f b6 08             	movzbl (%eax),%ecx
  800920:	84 c9                	test   %cl,%cl
  800922:	74 04                	je     800928 <strncmp+0x26>
  800924:	3a 0a                	cmp    (%edx),%cl
  800926:	74 eb                	je     800913 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800928:	0f b6 00             	movzbl (%eax),%eax
  80092b:	0f b6 12             	movzbl (%edx),%edx
  80092e:	29 d0                	sub    %edx,%eax
}
  800930:	5b                   	pop    %ebx
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    
		return 0;
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	eb f6                	jmp    800930 <strncmp+0x2e>

0080093a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800944:	0f b6 10             	movzbl (%eax),%edx
  800947:	84 d2                	test   %dl,%dl
  800949:	74 09                	je     800954 <strchr+0x1a>
		if (*s == c)
  80094b:	38 ca                	cmp    %cl,%dl
  80094d:	74 0a                	je     800959 <strchr+0x1f>
	for (; *s; s++)
  80094f:	83 c0 01             	add    $0x1,%eax
  800952:	eb f0                	jmp    800944 <strchr+0xa>
			return (char *) s;
	return 0;
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800965:	eb 03                	jmp    80096a <strfind+0xf>
  800967:	83 c0 01             	add    $0x1,%eax
  80096a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80096d:	38 ca                	cmp    %cl,%dl
  80096f:	74 04                	je     800975 <strfind+0x1a>
  800971:	84 d2                	test   %dl,%dl
  800973:	75 f2                	jne    800967 <strfind+0xc>
			break;
	return (char *) s;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800980:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800983:	85 c9                	test   %ecx,%ecx
  800985:	74 13                	je     80099a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800987:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098d:	75 05                	jne    800994 <memset+0x1d>
  80098f:	f6 c1 03             	test   $0x3,%cl
  800992:	74 0d                	je     8009a1 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	fc                   	cld    
  800998:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80099a:	89 f8                	mov    %edi,%eax
  80099c:	5b                   	pop    %ebx
  80099d:	5e                   	pop    %esi
  80099e:	5f                   	pop    %edi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    
		c &= 0xFF;
  8009a1:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a5:	89 d3                	mov    %edx,%ebx
  8009a7:	c1 e3 08             	shl    $0x8,%ebx
  8009aa:	89 d0                	mov    %edx,%eax
  8009ac:	c1 e0 18             	shl    $0x18,%eax
  8009af:	89 d6                	mov    %edx,%esi
  8009b1:	c1 e6 10             	shl    $0x10,%esi
  8009b4:	09 f0                	or     %esi,%eax
  8009b6:	09 c2                	or     %eax,%edx
  8009b8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009ba:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009bd:	89 d0                	mov    %edx,%eax
  8009bf:	fc                   	cld    
  8009c0:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c2:	eb d6                	jmp    80099a <memset+0x23>

008009c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d2:	39 c6                	cmp    %eax,%esi
  8009d4:	73 35                	jae    800a0b <memmove+0x47>
  8009d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d9:	39 c2                	cmp    %eax,%edx
  8009db:	76 2e                	jbe    800a0b <memmove+0x47>
		s += n;
		d += n;
  8009dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	09 fe                	or     %edi,%esi
  8009e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ea:	74 0c                	je     8009f8 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ec:	83 ef 01             	sub    $0x1,%edi
  8009ef:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009f2:	fd                   	std    
  8009f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f5:	fc                   	cld    
  8009f6:	eb 21                	jmp    800a19 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f8:	f6 c1 03             	test   $0x3,%cl
  8009fb:	75 ef                	jne    8009ec <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009fd:	83 ef 04             	sub    $0x4,%edi
  800a00:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a06:	fd                   	std    
  800a07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a09:	eb ea                	jmp    8009f5 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0b:	89 f2                	mov    %esi,%edx
  800a0d:	09 c2                	or     %eax,%edx
  800a0f:	f6 c2 03             	test   $0x3,%dl
  800a12:	74 09                	je     800a1d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a14:	89 c7                	mov    %eax,%edi
  800a16:	fc                   	cld    
  800a17:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a19:	5e                   	pop    %esi
  800a1a:	5f                   	pop    %edi
  800a1b:	5d                   	pop    %ebp
  800a1c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1d:	f6 c1 03             	test   $0x3,%cl
  800a20:	75 f2                	jne    800a14 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a22:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a25:	89 c7                	mov    %eax,%edi
  800a27:	fc                   	cld    
  800a28:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2a:	eb ed                	jmp    800a19 <memmove+0x55>

00800a2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a2f:	ff 75 10             	pushl  0x10(%ebp)
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	ff 75 08             	pushl  0x8(%ebp)
  800a38:	e8 87 ff ff ff       	call   8009c4 <memmove>
}
  800a3d:	c9                   	leave  
  800a3e:	c3                   	ret    

00800a3f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	56                   	push   %esi
  800a43:	53                   	push   %ebx
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4a:	89 c6                	mov    %eax,%esi
  800a4c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4f:	39 f0                	cmp    %esi,%eax
  800a51:	74 1c                	je     800a6f <memcmp+0x30>
		if (*s1 != *s2)
  800a53:	0f b6 08             	movzbl (%eax),%ecx
  800a56:	0f b6 1a             	movzbl (%edx),%ebx
  800a59:	38 d9                	cmp    %bl,%cl
  800a5b:	75 08                	jne    800a65 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a5d:	83 c0 01             	add    $0x1,%eax
  800a60:	83 c2 01             	add    $0x1,%edx
  800a63:	eb ea                	jmp    800a4f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a65:	0f b6 c1             	movzbl %cl,%eax
  800a68:	0f b6 db             	movzbl %bl,%ebx
  800a6b:	29 d8                	sub    %ebx,%eax
  800a6d:	eb 05                	jmp    800a74 <memcmp+0x35>
	}

	return 0;
  800a6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a74:	5b                   	pop    %ebx
  800a75:	5e                   	pop    %esi
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a81:	89 c2                	mov    %eax,%edx
  800a83:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a86:	39 d0                	cmp    %edx,%eax
  800a88:	73 09                	jae    800a93 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a8a:	38 08                	cmp    %cl,(%eax)
  800a8c:	74 05                	je     800a93 <memfind+0x1b>
	for (; s < ends; s++)
  800a8e:	83 c0 01             	add    $0x1,%eax
  800a91:	eb f3                	jmp    800a86 <memfind+0xe>
			break;
	return (void *) s;
}
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	57                   	push   %edi
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa1:	eb 03                	jmp    800aa6 <strtol+0x11>
		s++;
  800aa3:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800aa6:	0f b6 01             	movzbl (%ecx),%eax
  800aa9:	3c 20                	cmp    $0x20,%al
  800aab:	74 f6                	je     800aa3 <strtol+0xe>
  800aad:	3c 09                	cmp    $0x9,%al
  800aaf:	74 f2                	je     800aa3 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ab1:	3c 2b                	cmp    $0x2b,%al
  800ab3:	74 2e                	je     800ae3 <strtol+0x4e>
	int neg = 0;
  800ab5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aba:	3c 2d                	cmp    $0x2d,%al
  800abc:	74 2f                	je     800aed <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800abe:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ac4:	75 05                	jne    800acb <strtol+0x36>
  800ac6:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac9:	74 2c                	je     800af7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800acb:	85 db                	test   %ebx,%ebx
  800acd:	75 0a                	jne    800ad9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800acf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ad4:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad7:	74 28                	je     800b01 <strtol+0x6c>
		base = 10;
  800ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ade:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ae1:	eb 50                	jmp    800b33 <strtol+0x9e>
		s++;
  800ae3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ae6:	bf 00 00 00 00       	mov    $0x0,%edi
  800aeb:	eb d1                	jmp    800abe <strtol+0x29>
		s++, neg = 1;
  800aed:	83 c1 01             	add    $0x1,%ecx
  800af0:	bf 01 00 00 00       	mov    $0x1,%edi
  800af5:	eb c7                	jmp    800abe <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800afb:	74 0e                	je     800b0b <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800afd:	85 db                	test   %ebx,%ebx
  800aff:	75 d8                	jne    800ad9 <strtol+0x44>
		s++, base = 8;
  800b01:	83 c1 01             	add    $0x1,%ecx
  800b04:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b09:	eb ce                	jmp    800ad9 <strtol+0x44>
		s += 2, base = 16;
  800b0b:	83 c1 02             	add    $0x2,%ecx
  800b0e:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b13:	eb c4                	jmp    800ad9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b15:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b18:	89 f3                	mov    %esi,%ebx
  800b1a:	80 fb 19             	cmp    $0x19,%bl
  800b1d:	77 29                	ja     800b48 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b1f:	0f be d2             	movsbl %dl,%edx
  800b22:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b25:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b28:	7d 30                	jge    800b5a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b2a:	83 c1 01             	add    $0x1,%ecx
  800b2d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b31:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b33:	0f b6 11             	movzbl (%ecx),%edx
  800b36:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b39:	89 f3                	mov    %esi,%ebx
  800b3b:	80 fb 09             	cmp    $0x9,%bl
  800b3e:	77 d5                	ja     800b15 <strtol+0x80>
			dig = *s - '0';
  800b40:	0f be d2             	movsbl %dl,%edx
  800b43:	83 ea 30             	sub    $0x30,%edx
  800b46:	eb dd                	jmp    800b25 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b48:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b4b:	89 f3                	mov    %esi,%ebx
  800b4d:	80 fb 19             	cmp    $0x19,%bl
  800b50:	77 08                	ja     800b5a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b52:	0f be d2             	movsbl %dl,%edx
  800b55:	83 ea 37             	sub    $0x37,%edx
  800b58:	eb cb                	jmp    800b25 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	74 05                	je     800b65 <strtol+0xd0>
		*endptr = (char *) s;
  800b60:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b63:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b65:	89 c2                	mov    %eax,%edx
  800b67:	f7 da                	neg    %edx
  800b69:	85 ff                	test   %edi,%edi
  800b6b:	0f 45 c2             	cmovne %edx,%eax
}
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b79:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b84:	89 c3                	mov    %eax,%ebx
  800b86:	89 c7                	mov    %eax,%edi
  800b88:	89 c6                	mov    %eax,%esi
  800b8a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	57                   	push   %edi
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9c:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba1:	89 d1                	mov    %edx,%ecx
  800ba3:	89 d3                	mov    %edx,%ebx
  800ba5:	89 d7                	mov    %edx,%edi
  800ba7:	89 d6                	mov    %edx,%esi
  800ba9:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5f                   	pop    %edi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc6:	89 cb                	mov    %ecx,%ebx
  800bc8:	89 cf                	mov    %ecx,%edi
  800bca:	89 ce                	mov    %ecx,%esi
  800bcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bce:	85 c0                	test   %eax,%eax
  800bd0:	7f 08                	jg     800bda <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800bde:	6a 03                	push   $0x3
  800be0:	68 bf 26 80 00       	push   $0x8026bf
  800be5:	6a 23                	push   $0x23
  800be7:	68 dc 26 80 00       	push   $0x8026dc
  800bec:	e8 4b f5 ff ff       	call   80013c <_panic>

00800bf1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfc:	b8 02 00 00 00       	mov    $0x2,%eax
  800c01:	89 d1                	mov    %edx,%ecx
  800c03:	89 d3                	mov    %edx,%ebx
  800c05:	89 d7                	mov    %edx,%edi
  800c07:	89 d6                	mov    %edx,%esi
  800c09:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <sys_yield>:

void
sys_yield(void)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c16:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c20:	89 d1                	mov    %edx,%ecx
  800c22:	89 d3                	mov    %edx,%ebx
  800c24:	89 d7                	mov    %edx,%edi
  800c26:	89 d6                	mov    %edx,%esi
  800c28:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c2a:	5b                   	pop    %ebx
  800c2b:	5e                   	pop    %esi
  800c2c:	5f                   	pop    %edi
  800c2d:	5d                   	pop    %ebp
  800c2e:	c3                   	ret    

00800c2f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	57                   	push   %edi
  800c33:	56                   	push   %esi
  800c34:	53                   	push   %ebx
  800c35:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c38:	be 00 00 00 00       	mov    $0x0,%esi
  800c3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c43:	b8 04 00 00 00       	mov    $0x4,%eax
  800c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4b:	89 f7                	mov    %esi,%edi
  800c4d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	7f 08                	jg     800c5b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5f                   	pop    %edi
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5b:	83 ec 0c             	sub    $0xc,%esp
  800c5e:	50                   	push   %eax
  800c5f:	6a 04                	push   $0x4
  800c61:	68 bf 26 80 00       	push   $0x8026bf
  800c66:	6a 23                	push   $0x23
  800c68:	68 dc 26 80 00       	push   $0x8026dc
  800c6d:	e8 ca f4 ff ff       	call   80013c <_panic>

00800c72 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	b8 05 00 00 00       	mov    $0x5,%eax
  800c86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c89:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c8c:	8b 75 18             	mov    0x18(%ebp),%esi
  800c8f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7f 08                	jg     800c9d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	50                   	push   %eax
  800ca1:	6a 05                	push   $0x5
  800ca3:	68 bf 26 80 00       	push   $0x8026bf
  800ca8:	6a 23                	push   $0x23
  800caa:	68 dc 26 80 00       	push   $0x8026dc
  800caf:	e8 88 f4 ff ff       	call   80013c <_panic>

00800cb4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ccd:	89 df                	mov    %ebx,%edi
  800ccf:	89 de                	mov    %ebx,%esi
  800cd1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7f 08                	jg     800cdf <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cda:	5b                   	pop    %ebx
  800cdb:	5e                   	pop    %esi
  800cdc:	5f                   	pop    %edi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdf:	83 ec 0c             	sub    $0xc,%esp
  800ce2:	50                   	push   %eax
  800ce3:	6a 06                	push   $0x6
  800ce5:	68 bf 26 80 00       	push   $0x8026bf
  800cea:	6a 23                	push   $0x23
  800cec:	68 dc 26 80 00       	push   $0x8026dc
  800cf1:	e8 46 f4 ff ff       	call   80013c <_panic>

00800cf6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
  800cfc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0a:	b8 08 00 00 00       	mov    $0x8,%eax
  800d0f:	89 df                	mov    %ebx,%edi
  800d11:	89 de                	mov    %ebx,%esi
  800d13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d15:	85 c0                	test   %eax,%eax
  800d17:	7f 08                	jg     800d21 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d1c:	5b                   	pop    %ebx
  800d1d:	5e                   	pop    %esi
  800d1e:	5f                   	pop    %edi
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	50                   	push   %eax
  800d25:	6a 08                	push   $0x8
  800d27:	68 bf 26 80 00       	push   $0x8026bf
  800d2c:	6a 23                	push   $0x23
  800d2e:	68 dc 26 80 00       	push   $0x8026dc
  800d33:	e8 04 f4 ff ff       	call   80013c <_panic>

00800d38 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
  800d3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4c:	b8 09 00 00 00       	mov    $0x9,%eax
  800d51:	89 df                	mov    %ebx,%edi
  800d53:	89 de                	mov    %ebx,%esi
  800d55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d57:	85 c0                	test   %eax,%eax
  800d59:	7f 08                	jg     800d63 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	50                   	push   %eax
  800d67:	6a 09                	push   $0x9
  800d69:	68 bf 26 80 00       	push   $0x8026bf
  800d6e:	6a 23                	push   $0x23
  800d70:	68 dc 26 80 00       	push   $0x8026dc
  800d75:	e8 c2 f3 ff ff       	call   80013c <_panic>

00800d7a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d93:	89 df                	mov    %ebx,%edi
  800d95:	89 de                	mov    %ebx,%esi
  800d97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d99:	85 c0                	test   %eax,%eax
  800d9b:	7f 08                	jg     800da5 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	50                   	push   %eax
  800da9:	6a 0a                	push   $0xa
  800dab:	68 bf 26 80 00       	push   $0x8026bf
  800db0:	6a 23                	push   $0x23
  800db2:	68 dc 26 80 00       	push   $0x8026dc
  800db7:	e8 80 f3 ff ff       	call   80013c <_panic>

00800dbc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	57                   	push   %edi
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dcd:	be 00 00 00 00       	mov    $0x0,%esi
  800dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800df5:	89 cb                	mov    %ecx,%ebx
  800df7:	89 cf                	mov    %ecx,%edi
  800df9:	89 ce                	mov    %ecx,%esi
  800dfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfd:	85 c0                	test   %eax,%eax
  800dff:	7f 08                	jg     800e09 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	50                   	push   %eax
  800e0d:	6a 0d                	push   $0xd
  800e0f:	68 bf 26 80 00       	push   $0x8026bf
  800e14:	6a 23                	push   $0x23
  800e16:	68 dc 26 80 00       	push   $0x8026dc
  800e1b:	e8 1c f3 ff ff       	call   80013c <_panic>

00800e20 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	57                   	push   %edi
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e26:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e30:	89 d1                	mov    %edx,%ecx
  800e32:	89 d3                	mov    %edx,%ebx
  800e34:	89 d7                	mov    %edx,%edi
  800e36:	89 d6                	mov    %edx,%esi
  800e38:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	05 00 00 00 30       	add    $0x30000000,%eax
  800e4a:	c1 e8 0c             	shr    $0xc,%eax
}
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    

00800e66 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e71:	89 c2                	mov    %eax,%edx
  800e73:	c1 ea 16             	shr    $0x16,%edx
  800e76:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e7d:	f6 c2 01             	test   $0x1,%dl
  800e80:	74 2a                	je     800eac <fd_alloc+0x46>
  800e82:	89 c2                	mov    %eax,%edx
  800e84:	c1 ea 0c             	shr    $0xc,%edx
  800e87:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e8e:	f6 c2 01             	test   $0x1,%dl
  800e91:	74 19                	je     800eac <fd_alloc+0x46>
  800e93:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e98:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e9d:	75 d2                	jne    800e71 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e9f:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ea5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800eaa:	eb 07                	jmp    800eb3 <fd_alloc+0x4d>
			*fd_store = fd;
  800eac:	89 01                	mov    %eax,(%ecx)
			return 0;
  800eae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ebb:	83 f8 1f             	cmp    $0x1f,%eax
  800ebe:	77 36                	ja     800ef6 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ec0:	c1 e0 0c             	shl    $0xc,%eax
  800ec3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ec8:	89 c2                	mov    %eax,%edx
  800eca:	c1 ea 16             	shr    $0x16,%edx
  800ecd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed4:	f6 c2 01             	test   $0x1,%dl
  800ed7:	74 24                	je     800efd <fd_lookup+0x48>
  800ed9:	89 c2                	mov    %eax,%edx
  800edb:	c1 ea 0c             	shr    $0xc,%edx
  800ede:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee5:	f6 c2 01             	test   $0x1,%dl
  800ee8:	74 1a                	je     800f04 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eed:	89 02                	mov    %eax,(%edx)
	return 0;
  800eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
		return -E_INVAL;
  800ef6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800efb:	eb f7                	jmp    800ef4 <fd_lookup+0x3f>
		return -E_INVAL;
  800efd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f02:	eb f0                	jmp    800ef4 <fd_lookup+0x3f>
  800f04:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f09:	eb e9                	jmp    800ef4 <fd_lookup+0x3f>

00800f0b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f14:	ba 6c 27 80 00       	mov    $0x80276c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f19:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f1e:	39 08                	cmp    %ecx,(%eax)
  800f20:	74 33                	je     800f55 <dev_lookup+0x4a>
  800f22:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f25:	8b 02                	mov    (%edx),%eax
  800f27:	85 c0                	test   %eax,%eax
  800f29:	75 f3                	jne    800f1e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f2b:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800f30:	8b 40 48             	mov    0x48(%eax),%eax
  800f33:	83 ec 04             	sub    $0x4,%esp
  800f36:	51                   	push   %ecx
  800f37:	50                   	push   %eax
  800f38:	68 ec 26 80 00       	push   $0x8026ec
  800f3d:	e8 d5 f2 ff ff       	call   800217 <cprintf>
	*dev = 0;
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f4b:	83 c4 10             	add    $0x10,%esp
  800f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    
			*dev = devtab[i];
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5f:	eb f2                	jmp    800f53 <dev_lookup+0x48>

00800f61 <fd_close>:
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
  800f67:	83 ec 1c             	sub    $0x1c,%esp
  800f6a:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f70:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f73:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f74:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f7a:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f7d:	50                   	push   %eax
  800f7e:	e8 32 ff ff ff       	call   800eb5 <fd_lookup>
  800f83:	89 c3                	mov    %eax,%ebx
  800f85:	83 c4 08             	add    $0x8,%esp
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	78 05                	js     800f91 <fd_close+0x30>
	    || fd != fd2)
  800f8c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800f8f:	74 16                	je     800fa7 <fd_close+0x46>
		return (must_exist ? r : 0);
  800f91:	89 f8                	mov    %edi,%eax
  800f93:	84 c0                	test   %al,%al
  800f95:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9a:	0f 44 d8             	cmove  %eax,%ebx
}
  800f9d:	89 d8                	mov    %ebx,%eax
  800f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fad:	50                   	push   %eax
  800fae:	ff 36                	pushl  (%esi)
  800fb0:	e8 56 ff ff ff       	call   800f0b <dev_lookup>
  800fb5:	89 c3                	mov    %eax,%ebx
  800fb7:	83 c4 10             	add    $0x10,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	78 15                	js     800fd3 <fd_close+0x72>
		if (dev->dev_close)
  800fbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fc1:	8b 40 10             	mov    0x10(%eax),%eax
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	74 1b                	je     800fe3 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800fc8:	83 ec 0c             	sub    $0xc,%esp
  800fcb:	56                   	push   %esi
  800fcc:	ff d0                	call   *%eax
  800fce:	89 c3                	mov    %eax,%ebx
  800fd0:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fd3:	83 ec 08             	sub    $0x8,%esp
  800fd6:	56                   	push   %esi
  800fd7:	6a 00                	push   $0x0
  800fd9:	e8 d6 fc ff ff       	call   800cb4 <sys_page_unmap>
	return r;
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	eb ba                	jmp    800f9d <fd_close+0x3c>
			r = 0;
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe8:	eb e9                	jmp    800fd3 <fd_close+0x72>

00800fea <close>:

int
close(int fdnum)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ff0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff3:	50                   	push   %eax
  800ff4:	ff 75 08             	pushl  0x8(%ebp)
  800ff7:	e8 b9 fe ff ff       	call   800eb5 <fd_lookup>
  800ffc:	83 c4 08             	add    $0x8,%esp
  800fff:	85 c0                	test   %eax,%eax
  801001:	78 10                	js     801013 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801003:	83 ec 08             	sub    $0x8,%esp
  801006:	6a 01                	push   $0x1
  801008:	ff 75 f4             	pushl  -0xc(%ebp)
  80100b:	e8 51 ff ff ff       	call   800f61 <fd_close>
  801010:	83 c4 10             	add    $0x10,%esp
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <close_all>:

void
close_all(void)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	53                   	push   %ebx
  801019:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80101c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801021:	83 ec 0c             	sub    $0xc,%esp
  801024:	53                   	push   %ebx
  801025:	e8 c0 ff ff ff       	call   800fea <close>
	for (i = 0; i < MAXFD; i++)
  80102a:	83 c3 01             	add    $0x1,%ebx
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	83 fb 20             	cmp    $0x20,%ebx
  801033:	75 ec                	jne    801021 <close_all+0xc>
}
  801035:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
  801040:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801043:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801046:	50                   	push   %eax
  801047:	ff 75 08             	pushl  0x8(%ebp)
  80104a:	e8 66 fe ff ff       	call   800eb5 <fd_lookup>
  80104f:	89 c3                	mov    %eax,%ebx
  801051:	83 c4 08             	add    $0x8,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	0f 88 81 00 00 00    	js     8010dd <dup+0xa3>
		return r;
	close(newfdnum);
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	e8 83 ff ff ff       	call   800fea <close>

	newfd = INDEX2FD(newfdnum);
  801067:	8b 75 0c             	mov    0xc(%ebp),%esi
  80106a:	c1 e6 0c             	shl    $0xc,%esi
  80106d:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801073:	83 c4 04             	add    $0x4,%esp
  801076:	ff 75 e4             	pushl  -0x1c(%ebp)
  801079:	e8 d1 fd ff ff       	call   800e4f <fd2data>
  80107e:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801080:	89 34 24             	mov    %esi,(%esp)
  801083:	e8 c7 fd ff ff       	call   800e4f <fd2data>
  801088:	83 c4 10             	add    $0x10,%esp
  80108b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80108d:	89 d8                	mov    %ebx,%eax
  80108f:	c1 e8 16             	shr    $0x16,%eax
  801092:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801099:	a8 01                	test   $0x1,%al
  80109b:	74 11                	je     8010ae <dup+0x74>
  80109d:	89 d8                	mov    %ebx,%eax
  80109f:	c1 e8 0c             	shr    $0xc,%eax
  8010a2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010a9:	f6 c2 01             	test   $0x1,%dl
  8010ac:	75 39                	jne    8010e7 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010b1:	89 d0                	mov    %edx,%eax
  8010b3:	c1 e8 0c             	shr    $0xc,%eax
  8010b6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010bd:	83 ec 0c             	sub    $0xc,%esp
  8010c0:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c5:	50                   	push   %eax
  8010c6:	56                   	push   %esi
  8010c7:	6a 00                	push   $0x0
  8010c9:	52                   	push   %edx
  8010ca:	6a 00                	push   $0x0
  8010cc:	e8 a1 fb ff ff       	call   800c72 <sys_page_map>
  8010d1:	89 c3                	mov    %eax,%ebx
  8010d3:	83 c4 20             	add    $0x20,%esp
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	78 31                	js     80110b <dup+0xd1>
		goto err;

	return newfdnum;
  8010da:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010dd:	89 d8                	mov    %ebx,%eax
  8010df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010e7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f6:	50                   	push   %eax
  8010f7:	57                   	push   %edi
  8010f8:	6a 00                	push   $0x0
  8010fa:	53                   	push   %ebx
  8010fb:	6a 00                	push   $0x0
  8010fd:	e8 70 fb ff ff       	call   800c72 <sys_page_map>
  801102:	89 c3                	mov    %eax,%ebx
  801104:	83 c4 20             	add    $0x20,%esp
  801107:	85 c0                	test   %eax,%eax
  801109:	79 a3                	jns    8010ae <dup+0x74>
	sys_page_unmap(0, newfd);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	56                   	push   %esi
  80110f:	6a 00                	push   $0x0
  801111:	e8 9e fb ff ff       	call   800cb4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801116:	83 c4 08             	add    $0x8,%esp
  801119:	57                   	push   %edi
  80111a:	6a 00                	push   $0x0
  80111c:	e8 93 fb ff ff       	call   800cb4 <sys_page_unmap>
	return r;
  801121:	83 c4 10             	add    $0x10,%esp
  801124:	eb b7                	jmp    8010dd <dup+0xa3>

00801126 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	53                   	push   %ebx
  80112a:	83 ec 14             	sub    $0x14,%esp
  80112d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801130:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801133:	50                   	push   %eax
  801134:	53                   	push   %ebx
  801135:	e8 7b fd ff ff       	call   800eb5 <fd_lookup>
  80113a:	83 c4 08             	add    $0x8,%esp
  80113d:	85 c0                	test   %eax,%eax
  80113f:	78 3f                	js     801180 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801141:	83 ec 08             	sub    $0x8,%esp
  801144:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801147:	50                   	push   %eax
  801148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114b:	ff 30                	pushl  (%eax)
  80114d:	e8 b9 fd ff ff       	call   800f0b <dev_lookup>
  801152:	83 c4 10             	add    $0x10,%esp
  801155:	85 c0                	test   %eax,%eax
  801157:	78 27                	js     801180 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801159:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80115c:	8b 42 08             	mov    0x8(%edx),%eax
  80115f:	83 e0 03             	and    $0x3,%eax
  801162:	83 f8 01             	cmp    $0x1,%eax
  801165:	74 1e                	je     801185 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116a:	8b 40 08             	mov    0x8(%eax),%eax
  80116d:	85 c0                	test   %eax,%eax
  80116f:	74 35                	je     8011a6 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	ff 75 10             	pushl  0x10(%ebp)
  801177:	ff 75 0c             	pushl  0xc(%ebp)
  80117a:	52                   	push   %edx
  80117b:	ff d0                	call   *%eax
  80117d:	83 c4 10             	add    $0x10,%esp
}
  801180:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801183:	c9                   	leave  
  801184:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801185:	a1 20 40 c0 00       	mov    0xc04020,%eax
  80118a:	8b 40 48             	mov    0x48(%eax),%eax
  80118d:	83 ec 04             	sub    $0x4,%esp
  801190:	53                   	push   %ebx
  801191:	50                   	push   %eax
  801192:	68 30 27 80 00       	push   $0x802730
  801197:	e8 7b f0 ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a4:	eb da                	jmp    801180 <read+0x5a>
		return -E_NOT_SUPP;
  8011a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011ab:	eb d3                	jmp    801180 <read+0x5a>

008011ad <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	57                   	push   %edi
  8011b1:	56                   	push   %esi
  8011b2:	53                   	push   %ebx
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c1:	39 f3                	cmp    %esi,%ebx
  8011c3:	73 25                	jae    8011ea <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011c5:	83 ec 04             	sub    $0x4,%esp
  8011c8:	89 f0                	mov    %esi,%eax
  8011ca:	29 d8                	sub    %ebx,%eax
  8011cc:	50                   	push   %eax
  8011cd:	89 d8                	mov    %ebx,%eax
  8011cf:	03 45 0c             	add    0xc(%ebp),%eax
  8011d2:	50                   	push   %eax
  8011d3:	57                   	push   %edi
  8011d4:	e8 4d ff ff ff       	call   801126 <read>
		if (m < 0)
  8011d9:	83 c4 10             	add    $0x10,%esp
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	78 08                	js     8011e8 <readn+0x3b>
			return m;
		if (m == 0)
  8011e0:	85 c0                	test   %eax,%eax
  8011e2:	74 06                	je     8011ea <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011e4:	01 c3                	add    %eax,%ebx
  8011e6:	eb d9                	jmp    8011c1 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011e8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ea:	89 d8                	mov    %ebx,%eax
  8011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011ef:	5b                   	pop    %ebx
  8011f0:	5e                   	pop    %esi
  8011f1:	5f                   	pop    %edi
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    

008011f4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	53                   	push   %ebx
  8011f8:	83 ec 14             	sub    $0x14,%esp
  8011fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801201:	50                   	push   %eax
  801202:	53                   	push   %ebx
  801203:	e8 ad fc ff ff       	call   800eb5 <fd_lookup>
  801208:	83 c4 08             	add    $0x8,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	78 3a                	js     801249 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80120f:	83 ec 08             	sub    $0x8,%esp
  801212:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801215:	50                   	push   %eax
  801216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801219:	ff 30                	pushl  (%eax)
  80121b:	e8 eb fc ff ff       	call   800f0b <dev_lookup>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	78 22                	js     801249 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80122e:	74 1e                	je     80124e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801233:	8b 52 0c             	mov    0xc(%edx),%edx
  801236:	85 d2                	test   %edx,%edx
  801238:	74 35                	je     80126f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80123a:	83 ec 04             	sub    $0x4,%esp
  80123d:	ff 75 10             	pushl  0x10(%ebp)
  801240:	ff 75 0c             	pushl  0xc(%ebp)
  801243:	50                   	push   %eax
  801244:	ff d2                	call   *%edx
  801246:	83 c4 10             	add    $0x10,%esp
}
  801249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80124e:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801253:	8b 40 48             	mov    0x48(%eax),%eax
  801256:	83 ec 04             	sub    $0x4,%esp
  801259:	53                   	push   %ebx
  80125a:	50                   	push   %eax
  80125b:	68 4c 27 80 00       	push   $0x80274c
  801260:	e8 b2 ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  801265:	83 c4 10             	add    $0x10,%esp
  801268:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126d:	eb da                	jmp    801249 <write+0x55>
		return -E_NOT_SUPP;
  80126f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801274:	eb d3                	jmp    801249 <write+0x55>

00801276 <seek>:

int
seek(int fdnum, off_t offset)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127c:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80127f:	50                   	push   %eax
  801280:	ff 75 08             	pushl  0x8(%ebp)
  801283:	e8 2d fc ff ff       	call   800eb5 <fd_lookup>
  801288:	83 c4 08             	add    $0x8,%esp
  80128b:	85 c0                	test   %eax,%eax
  80128d:	78 0e                	js     80129d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80128f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801292:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801295:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	53                   	push   %ebx
  8012a3:	83 ec 14             	sub    $0x14,%esp
  8012a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012ac:	50                   	push   %eax
  8012ad:	53                   	push   %ebx
  8012ae:	e8 02 fc ff ff       	call   800eb5 <fd_lookup>
  8012b3:	83 c4 08             	add    $0x8,%esp
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	78 37                	js     8012f1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	50                   	push   %eax
  8012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c4:	ff 30                	pushl  (%eax)
  8012c6:	e8 40 fc ff ff       	call   800f0b <dev_lookup>
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	78 1f                	js     8012f1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d9:	74 1b                	je     8012f6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012de:	8b 52 18             	mov    0x18(%edx),%edx
  8012e1:	85 d2                	test   %edx,%edx
  8012e3:	74 32                	je     801317 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012e5:	83 ec 08             	sub    $0x8,%esp
  8012e8:	ff 75 0c             	pushl  0xc(%ebp)
  8012eb:	50                   	push   %eax
  8012ec:	ff d2                	call   *%edx
  8012ee:	83 c4 10             	add    $0x10,%esp
}
  8012f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f4:	c9                   	leave  
  8012f5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8012f6:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012fb:	8b 40 48             	mov    0x48(%eax),%eax
  8012fe:	83 ec 04             	sub    $0x4,%esp
  801301:	53                   	push   %ebx
  801302:	50                   	push   %eax
  801303:	68 0c 27 80 00       	push   $0x80270c
  801308:	e8 0a ef ff ff       	call   800217 <cprintf>
		return -E_INVAL;
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801315:	eb da                	jmp    8012f1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801317:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131c:	eb d3                	jmp    8012f1 <ftruncate+0x52>

0080131e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	53                   	push   %ebx
  801322:	83 ec 14             	sub    $0x14,%esp
  801325:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801328:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132b:	50                   	push   %eax
  80132c:	ff 75 08             	pushl  0x8(%ebp)
  80132f:	e8 81 fb ff ff       	call   800eb5 <fd_lookup>
  801334:	83 c4 08             	add    $0x8,%esp
  801337:	85 c0                	test   %eax,%eax
  801339:	78 4b                	js     801386 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801341:	50                   	push   %eax
  801342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801345:	ff 30                	pushl  (%eax)
  801347:	e8 bf fb ff ff       	call   800f0b <dev_lookup>
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 33                	js     801386 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801356:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80135a:	74 2f                	je     80138b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80135c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80135f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801366:	00 00 00 
	stat->st_isdir = 0;
  801369:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801370:	00 00 00 
	stat->st_dev = dev;
  801373:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	53                   	push   %ebx
  80137d:	ff 75 f0             	pushl  -0x10(%ebp)
  801380:	ff 50 14             	call   *0x14(%eax)
  801383:	83 c4 10             	add    $0x10,%esp
}
  801386:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801389:	c9                   	leave  
  80138a:	c3                   	ret    
		return -E_NOT_SUPP;
  80138b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801390:	eb f4                	jmp    801386 <fstat+0x68>

00801392 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	56                   	push   %esi
  801396:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801397:	83 ec 08             	sub    $0x8,%esp
  80139a:	6a 00                	push   $0x0
  80139c:	ff 75 08             	pushl  0x8(%ebp)
  80139f:	e8 e7 01 00 00       	call   80158b <open>
  8013a4:	89 c3                	mov    %eax,%ebx
  8013a6:	83 c4 10             	add    $0x10,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 1b                	js     8013c8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	50                   	push   %eax
  8013b4:	e8 65 ff ff ff       	call   80131e <fstat>
  8013b9:	89 c6                	mov    %eax,%esi
	close(fd);
  8013bb:	89 1c 24             	mov    %ebx,(%esp)
  8013be:	e8 27 fc ff ff       	call   800fea <close>
	return r;
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	89 f3                	mov    %esi,%ebx
}
  8013c8:	89 d8                	mov    %ebx,%eax
  8013ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013cd:	5b                   	pop    %ebx
  8013ce:	5e                   	pop    %esi
  8013cf:	5d                   	pop    %ebp
  8013d0:	c3                   	ret    

008013d1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	56                   	push   %esi
  8013d5:	53                   	push   %ebx
  8013d6:	89 c6                	mov    %eax,%esi
  8013d8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013da:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013e1:	74 27                	je     80140a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013e3:	6a 07                	push   $0x7
  8013e5:	68 00 50 c0 00       	push   $0xc05000
  8013ea:	56                   	push   %esi
  8013eb:	ff 35 00 40 80 00    	pushl  0x804000
  8013f1:	e8 d0 0b 00 00       	call   801fc6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8013f6:	83 c4 0c             	add    $0xc,%esp
  8013f9:	6a 00                	push   $0x0
  8013fb:	53                   	push   %ebx
  8013fc:	6a 00                	push   $0x0
  8013fe:	e8 5c 0b 00 00       	call   801f5f <ipc_recv>
}
  801403:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801406:	5b                   	pop    %ebx
  801407:	5e                   	pop    %esi
  801408:	5d                   	pop    %ebp
  801409:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	6a 01                	push   $0x1
  80140f:	e8 06 0c 00 00       	call   80201a <ipc_find_env>
  801414:	a3 00 40 80 00       	mov    %eax,0x804000
  801419:	83 c4 10             	add    $0x10,%esp
  80141c:	eb c5                	jmp    8013e3 <fsipc+0x12>

0080141e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8b 40 0c             	mov    0xc(%eax),%eax
  80142a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  80142f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801432:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801437:	ba 00 00 00 00       	mov    $0x0,%edx
  80143c:	b8 02 00 00 00       	mov    $0x2,%eax
  801441:	e8 8b ff ff ff       	call   8013d1 <fsipc>
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <devfile_flush>:
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8b 40 0c             	mov    0xc(%eax),%eax
  801454:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  801459:	ba 00 00 00 00       	mov    $0x0,%edx
  80145e:	b8 06 00 00 00       	mov    $0x6,%eax
  801463:	e8 69 ff ff ff       	call   8013d1 <fsipc>
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <devfile_stat>:
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	53                   	push   %ebx
  80146e:	83 ec 04             	sub    $0x4,%esp
  801471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801474:	8b 45 08             	mov    0x8(%ebp),%eax
  801477:	8b 40 0c             	mov    0xc(%eax),%eax
  80147a:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80147f:	ba 00 00 00 00       	mov    $0x0,%edx
  801484:	b8 05 00 00 00       	mov    $0x5,%eax
  801489:	e8 43 ff ff ff       	call   8013d1 <fsipc>
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 2c                	js     8014be <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801492:	83 ec 08             	sub    $0x8,%esp
  801495:	68 00 50 c0 00       	push   $0xc05000
  80149a:	53                   	push   %ebx
  80149b:	e8 96 f3 ff ff       	call   800836 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014a0:	a1 80 50 c0 00       	mov    0xc05080,%eax
  8014a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8014ab:	a1 84 50 c0 00       	mov    0xc05084,%eax
  8014b0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <devfile_write>:
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 0c             	sub    $0xc,%esp
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8014d1:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8014d6:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8014df:	89 15 00 50 c0 00    	mov    %edx,0xc05000
	fsipcbuf.write.req_n = n;
  8014e5:	a3 04 50 c0 00       	mov    %eax,0xc05004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8014ea:	50                   	push   %eax
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	68 08 50 c0 00       	push   $0xc05008
  8014f3:	e8 cc f4 ff ff       	call   8009c4 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8014f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fd:	b8 04 00 00 00       	mov    $0x4,%eax
  801502:	e8 ca fe ff ff       	call   8013d1 <fsipc>
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <devfile_read>:
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	56                   	push   %esi
  80150d:	53                   	push   %ebx
  80150e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	8b 40 0c             	mov    0xc(%eax),%eax
  801517:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  80151c:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801522:	ba 00 00 00 00       	mov    $0x0,%edx
  801527:	b8 03 00 00 00       	mov    $0x3,%eax
  80152c:	e8 a0 fe ff ff       	call   8013d1 <fsipc>
  801531:	89 c3                	mov    %eax,%ebx
  801533:	85 c0                	test   %eax,%eax
  801535:	78 1f                	js     801556 <devfile_read+0x4d>
	assert(r <= n);
  801537:	39 f0                	cmp    %esi,%eax
  801539:	77 24                	ja     80155f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80153b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801540:	7f 33                	jg     801575 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801542:	83 ec 04             	sub    $0x4,%esp
  801545:	50                   	push   %eax
  801546:	68 00 50 c0 00       	push   $0xc05000
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	e8 71 f4 ff ff       	call   8009c4 <memmove>
	return r;
  801553:	83 c4 10             	add    $0x10,%esp
}
  801556:	89 d8                	mov    %ebx,%eax
  801558:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155b:	5b                   	pop    %ebx
  80155c:	5e                   	pop    %esi
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    
	assert(r <= n);
  80155f:	68 80 27 80 00       	push   $0x802780
  801564:	68 87 27 80 00       	push   $0x802787
  801569:	6a 7b                	push   $0x7b
  80156b:	68 9c 27 80 00       	push   $0x80279c
  801570:	e8 c7 eb ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  801575:	68 a7 27 80 00       	push   $0x8027a7
  80157a:	68 87 27 80 00       	push   $0x802787
  80157f:	6a 7c                	push   $0x7c
  801581:	68 9c 27 80 00       	push   $0x80279c
  801586:	e8 b1 eb ff ff       	call   80013c <_panic>

0080158b <open>:
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	56                   	push   %esi
  80158f:	53                   	push   %ebx
  801590:	83 ec 1c             	sub    $0x1c,%esp
  801593:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801596:	56                   	push   %esi
  801597:	e8 63 f2 ff ff       	call   8007ff <strlen>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015a4:	7f 6c                	jg     801612 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	e8 b4 f8 ff ff       	call   800e66 <fd_alloc>
  8015b2:	89 c3                	mov    %eax,%ebx
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 3c                	js     8015f7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	56                   	push   %esi
  8015bf:	68 00 50 c0 00       	push   $0xc05000
  8015c4:	e8 6d f2 ff ff       	call   800836 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cc:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d9:	e8 f3 fd ff ff       	call   8013d1 <fsipc>
  8015de:	89 c3                	mov    %eax,%ebx
  8015e0:	83 c4 10             	add    $0x10,%esp
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 19                	js     801600 <open+0x75>
	return fd2num(fd);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ed:	e8 4d f8 ff ff       	call   800e3f <fd2num>
  8015f2:	89 c3                	mov    %eax,%ebx
  8015f4:	83 c4 10             	add    $0x10,%esp
}
  8015f7:	89 d8                	mov    %ebx,%eax
  8015f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fc:	5b                   	pop    %ebx
  8015fd:	5e                   	pop    %esi
  8015fe:	5d                   	pop    %ebp
  8015ff:	c3                   	ret    
		fd_close(fd, 0);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	6a 00                	push   $0x0
  801605:	ff 75 f4             	pushl  -0xc(%ebp)
  801608:	e8 54 f9 ff ff       	call   800f61 <fd_close>
		return r;
  80160d:	83 c4 10             	add    $0x10,%esp
  801610:	eb e5                	jmp    8015f7 <open+0x6c>
		return -E_BAD_PATH;
  801612:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801617:	eb de                	jmp    8015f7 <open+0x6c>

00801619 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
  80161c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80161f:	ba 00 00 00 00       	mov    $0x0,%edx
  801624:	b8 08 00 00 00       	mov    $0x8,%eax
  801629:	e8 a3 fd ff ff       	call   8013d1 <fsipc>
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801636:	68 b3 27 80 00       	push   $0x8027b3
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	e8 f3 f1 ff ff       	call   800836 <strcpy>
	return 0;
}
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <devsock_close>:
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	53                   	push   %ebx
  80164e:	83 ec 10             	sub    $0x10,%esp
  801651:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801654:	53                   	push   %ebx
  801655:	e8 f9 09 00 00       	call   802053 <pageref>
  80165a:	83 c4 10             	add    $0x10,%esp
		return 0;
  80165d:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801662:	83 f8 01             	cmp    $0x1,%eax
  801665:	74 07                	je     80166e <devsock_close+0x24>
}
  801667:	89 d0                	mov    %edx,%eax
  801669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80166e:	83 ec 0c             	sub    $0xc,%esp
  801671:	ff 73 0c             	pushl  0xc(%ebx)
  801674:	e8 b7 02 00 00       	call   801930 <nsipc_close>
  801679:	89 c2                	mov    %eax,%edx
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	eb e7                	jmp    801667 <devsock_close+0x1d>

00801680 <devsock_write>:
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801686:	6a 00                	push   $0x0
  801688:	ff 75 10             	pushl  0x10(%ebp)
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	ff 70 0c             	pushl  0xc(%eax)
  801694:	e8 74 03 00 00       	call   801a0d <nsipc_send>
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <devsock_read>:
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	ff 75 10             	pushl  0x10(%ebp)
  8016a6:	ff 75 0c             	pushl  0xc(%ebp)
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	ff 70 0c             	pushl  0xc(%eax)
  8016af:	e8 ed 02 00 00       	call   8019a1 <nsipc_recv>
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <fd2sockid>:
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016bc:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	e8 ef f7 ff ff       	call   800eb5 <fd_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 10                	js     8016dd <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8016d6:	39 08                	cmp    %ecx,(%eax)
  8016d8:	75 05                	jne    8016df <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8016da:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    
		return -E_NOT_SUPP;
  8016df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e4:	eb f7                	jmp    8016dd <fd2sockid+0x27>

008016e6 <alloc_sockfd>:
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	56                   	push   %esi
  8016ea:	53                   	push   %ebx
  8016eb:	83 ec 1c             	sub    $0x1c,%esp
  8016ee:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8016f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f3:	50                   	push   %eax
  8016f4:	e8 6d f7 ff ff       	call   800e66 <fd_alloc>
  8016f9:	89 c3                	mov    %eax,%ebx
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 43                	js     801745 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 07 04 00 00       	push   $0x407
  80170a:	ff 75 f4             	pushl  -0xc(%ebp)
  80170d:	6a 00                	push   $0x0
  80170f:	e8 1b f5 ff ff       	call   800c2f <sys_page_alloc>
  801714:	89 c3                	mov    %eax,%ebx
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	78 28                	js     801745 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801726:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801732:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801735:	83 ec 0c             	sub    $0xc,%esp
  801738:	50                   	push   %eax
  801739:	e8 01 f7 ff ff       	call   800e3f <fd2num>
  80173e:	89 c3                	mov    %eax,%ebx
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	eb 0c                	jmp    801751 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801745:	83 ec 0c             	sub    $0xc,%esp
  801748:	56                   	push   %esi
  801749:	e8 e2 01 00 00       	call   801930 <nsipc_close>
		return r;
  80174e:	83 c4 10             	add    $0x10,%esp
}
  801751:	89 d8                	mov    %ebx,%eax
  801753:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <accept>:
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	e8 4e ff ff ff       	call   8016b6 <fd2sockid>
  801768:	85 c0                	test   %eax,%eax
  80176a:	78 1b                	js     801787 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	ff 75 10             	pushl  0x10(%ebp)
  801772:	ff 75 0c             	pushl  0xc(%ebp)
  801775:	50                   	push   %eax
  801776:	e8 0e 01 00 00       	call   801889 <nsipc_accept>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 05                	js     801787 <accept+0x2d>
	return alloc_sockfd(r);
  801782:	e8 5f ff ff ff       	call   8016e6 <alloc_sockfd>
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <bind>:
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	e8 1f ff ff ff       	call   8016b6 <fd2sockid>
  801797:	85 c0                	test   %eax,%eax
  801799:	78 12                	js     8017ad <bind+0x24>
	return nsipc_bind(r, name, namelen);
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	ff 75 10             	pushl  0x10(%ebp)
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	50                   	push   %eax
  8017a5:	e8 2f 01 00 00       	call   8018d9 <nsipc_bind>
  8017aa:	83 c4 10             	add    $0x10,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <shutdown>:
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	e8 f9 fe ff ff       	call   8016b6 <fd2sockid>
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 0f                	js     8017d0 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	50                   	push   %eax
  8017c8:	e8 41 01 00 00       	call   80190e <nsipc_shutdown>
  8017cd:	83 c4 10             	add    $0x10,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <connect>:
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017db:	e8 d6 fe ff ff       	call   8016b6 <fd2sockid>
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	78 12                	js     8017f6 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	ff 75 10             	pushl  0x10(%ebp)
  8017ea:	ff 75 0c             	pushl  0xc(%ebp)
  8017ed:	50                   	push   %eax
  8017ee:	e8 57 01 00 00       	call   80194a <nsipc_connect>
  8017f3:	83 c4 10             	add    $0x10,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <listen>:
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	e8 b0 fe ff ff       	call   8016b6 <fd2sockid>
  801806:	85 c0                	test   %eax,%eax
  801808:	78 0f                	js     801819 <listen+0x21>
	return nsipc_listen(r, backlog);
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	50                   	push   %eax
  801811:	e8 69 01 00 00       	call   80197f <nsipc_listen>
  801816:	83 c4 10             	add    $0x10,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <socket>:

int
socket(int domain, int type, int protocol)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801821:	ff 75 10             	pushl  0x10(%ebp)
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	e8 3c 02 00 00       	call   801a6b <nsipc_socket>
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	85 c0                	test   %eax,%eax
  801834:	78 05                	js     80183b <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801836:	e8 ab fe ff ff       	call   8016e6 <alloc_sockfd>
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	53                   	push   %ebx
  801841:	83 ec 04             	sub    $0x4,%esp
  801844:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801846:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80184d:	74 26                	je     801875 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80184f:	6a 07                	push   $0x7
  801851:	68 00 60 c0 00       	push   $0xc06000
  801856:	53                   	push   %ebx
  801857:	ff 35 04 40 80 00    	pushl  0x804004
  80185d:	e8 64 07 00 00       	call   801fc6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801862:	83 c4 0c             	add    $0xc,%esp
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	e8 ef 06 00 00       	call   801f5f <ipc_recv>
}
  801870:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801873:	c9                   	leave  
  801874:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801875:	83 ec 0c             	sub    $0xc,%esp
  801878:	6a 02                	push   $0x2
  80187a:	e8 9b 07 00 00       	call   80201a <ipc_find_env>
  80187f:	a3 04 40 80 00       	mov    %eax,0x804004
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	eb c6                	jmp    80184f <nsipc+0x12>

00801889 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	56                   	push   %esi
  80188d:	53                   	push   %ebx
  80188e:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801899:	8b 06                	mov    (%esi),%eax
  80189b:	a3 04 60 c0 00       	mov    %eax,0xc06004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8018a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a5:	e8 93 ff ff ff       	call   80183d <nsipc>
  8018aa:	89 c3                	mov    %eax,%ebx
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 20                	js     8018d0 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	ff 35 10 60 c0 00    	pushl  0xc06010
  8018b9:	68 00 60 c0 00       	push   $0xc06000
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	e8 fe f0 ff ff       	call   8009c4 <memmove>
		*addrlen = ret->ret_addrlen;
  8018c6:	a1 10 60 c0 00       	mov    0xc06010,%eax
  8018cb:	89 06                	mov    %eax,(%esi)
  8018cd:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  8018d0:	89 d8                	mov    %ebx,%eax
  8018d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    

008018d9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 08             	sub    $0x8,%esp
  8018e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e6:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8018eb:	53                   	push   %ebx
  8018ec:	ff 75 0c             	pushl  0xc(%ebp)
  8018ef:	68 04 60 c0 00       	push   $0xc06004
  8018f4:	e8 cb f0 ff ff       	call   8009c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8018f9:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_BIND);
  8018ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801904:	e8 34 ff ff ff       	call   80183d <nsipc>
}
  801909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.shutdown.req_how = how;
  80191c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191f:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_SHUTDOWN);
  801924:	b8 03 00 00 00       	mov    $0x3,%eax
  801929:	e8 0f ff ff ff       	call   80183d <nsipc>
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <nsipc_close>:

int
nsipc_close(int s)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	a3 00 60 c0 00       	mov    %eax,0xc06000
	return nsipc(NSREQ_CLOSE);
  80193e:	b8 04 00 00 00       	mov    $0x4,%eax
  801943:	e8 f5 fe ff ff       	call   80183d <nsipc>
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	53                   	push   %ebx
  80194e:	83 ec 08             	sub    $0x8,%esp
  801951:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	a3 00 60 c0 00       	mov    %eax,0xc06000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80195c:	53                   	push   %ebx
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	68 04 60 c0 00       	push   $0xc06004
  801965:	e8 5a f0 ff ff       	call   8009c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80196a:	89 1d 14 60 c0 00    	mov    %ebx,0xc06014
	return nsipc(NSREQ_CONNECT);
  801970:	b8 05 00 00 00       	mov    $0x5,%eax
  801975:	e8 c3 fe ff ff       	call   80183d <nsipc>
}
  80197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.listen.req_backlog = backlog;
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	a3 04 60 c0 00       	mov    %eax,0xc06004
	return nsipc(NSREQ_LISTEN);
  801995:	b8 06 00 00 00       	mov    $0x6,%eax
  80199a:	e8 9e fe ff ff       	call   80183d <nsipc>
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	56                   	push   %esi
  8019a5:	53                   	push   %ebx
  8019a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.recv.req_len = len;
  8019b1:	89 35 04 60 c0 00    	mov    %esi,0xc06004
	nsipcbuf.recv.req_flags = flags;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	a3 08 60 c0 00       	mov    %eax,0xc06008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8019bf:	b8 07 00 00 00       	mov    $0x7,%eax
  8019c4:	e8 74 fe ff ff       	call   80183d <nsipc>
  8019c9:	89 c3                	mov    %eax,%ebx
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 1f                	js     8019ee <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  8019cf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8019d4:	7f 21                	jg     8019f7 <nsipc_recv+0x56>
  8019d6:	39 c6                	cmp    %eax,%esi
  8019d8:	7c 1d                	jl     8019f7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8019da:	83 ec 04             	sub    $0x4,%esp
  8019dd:	50                   	push   %eax
  8019de:	68 00 60 c0 00       	push   $0xc06000
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	e8 d9 ef ff ff       	call   8009c4 <memmove>
  8019eb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  8019ee:	89 d8                	mov    %ebx,%eax
  8019f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  8019f7:	68 bf 27 80 00       	push   $0x8027bf
  8019fc:	68 87 27 80 00       	push   $0x802787
  801a01:	6a 62                	push   $0x62
  801a03:	68 d4 27 80 00       	push   $0x8027d4
  801a08:	e8 2f e7 ff ff       	call   80013c <_panic>

00801a0d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	53                   	push   %ebx
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	a3 00 60 c0 00       	mov    %eax,0xc06000
	assert(size < 1600);
  801a1f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a25:	7f 2e                	jg     801a55 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	53                   	push   %ebx
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	68 0c 60 c0 00       	push   $0xc0600c
  801a33:	e8 8c ef ff ff       	call   8009c4 <memmove>
	nsipcbuf.send.req_size = size;
  801a38:	89 1d 04 60 c0 00    	mov    %ebx,0xc06004
	nsipcbuf.send.req_flags = flags;
  801a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a41:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SEND);
  801a46:	b8 08 00 00 00       	mov    $0x8,%eax
  801a4b:	e8 ed fd ff ff       	call   80183d <nsipc>
}
  801a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    
	assert(size < 1600);
  801a55:	68 e0 27 80 00       	push   $0x8027e0
  801a5a:	68 87 27 80 00       	push   $0x802787
  801a5f:	6a 6d                	push   $0x6d
  801a61:	68 d4 27 80 00       	push   $0x8027d4
  801a66:	e8 d1 e6 ff ff       	call   80013c <_panic>

00801a6b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	a3 00 60 c0 00       	mov    %eax,0xc06000
	nsipcbuf.socket.req_type = type;
  801a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7c:	a3 04 60 c0 00       	mov    %eax,0xc06004
	nsipcbuf.socket.req_protocol = protocol;
  801a81:	8b 45 10             	mov    0x10(%ebp),%eax
  801a84:	a3 08 60 c0 00       	mov    %eax,0xc06008
	return nsipc(NSREQ_SOCKET);
  801a89:	b8 09 00 00 00       	mov    $0x9,%eax
  801a8e:	e8 aa fd ff ff       	call   80183d <nsipc>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	56                   	push   %esi
  801a99:	53                   	push   %ebx
  801a9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a9d:	83 ec 0c             	sub    $0xc,%esp
  801aa0:	ff 75 08             	pushl  0x8(%ebp)
  801aa3:	e8 a7 f3 ff ff       	call   800e4f <fd2data>
  801aa8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801aaa:	83 c4 08             	add    $0x8,%esp
  801aad:	68 ec 27 80 00       	push   $0x8027ec
  801ab2:	53                   	push   %ebx
  801ab3:	e8 7e ed ff ff       	call   800836 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ab8:	8b 46 04             	mov    0x4(%esi),%eax
  801abb:	2b 06                	sub    (%esi),%eax
  801abd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ac3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aca:	00 00 00 
	stat->st_dev = &devpipe;
  801acd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ad4:	30 80 00 
	return 0;
}
  801ad7:	b8 00 00 00 00       	mov    $0x0,%eax
  801adc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5d                   	pop    %ebp
  801ae2:	c3                   	ret    

00801ae3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801aed:	53                   	push   %ebx
  801aee:	6a 00                	push   $0x0
  801af0:	e8 bf f1 ff ff       	call   800cb4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801af5:	89 1c 24             	mov    %ebx,(%esp)
  801af8:	e8 52 f3 ff ff       	call   800e4f <fd2data>
  801afd:	83 c4 08             	add    $0x8,%esp
  801b00:	50                   	push   %eax
  801b01:	6a 00                	push   $0x0
  801b03:	e8 ac f1 ff ff       	call   800cb4 <sys_page_unmap>
}
  801b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <_pipeisclosed>:
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	57                   	push   %edi
  801b11:	56                   	push   %esi
  801b12:	53                   	push   %ebx
  801b13:	83 ec 1c             	sub    $0x1c,%esp
  801b16:	89 c7                	mov    %eax,%edi
  801b18:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b1a:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801b1f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b22:	83 ec 0c             	sub    $0xc,%esp
  801b25:	57                   	push   %edi
  801b26:	e8 28 05 00 00       	call   802053 <pageref>
  801b2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b2e:	89 34 24             	mov    %esi,(%esp)
  801b31:	e8 1d 05 00 00       	call   802053 <pageref>
		nn = thisenv->env_runs;
  801b36:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801b3c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b3f:	83 c4 10             	add    $0x10,%esp
  801b42:	39 cb                	cmp    %ecx,%ebx
  801b44:	74 1b                	je     801b61 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b46:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b49:	75 cf                	jne    801b1a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b4b:	8b 42 58             	mov    0x58(%edx),%eax
  801b4e:	6a 01                	push   $0x1
  801b50:	50                   	push   %eax
  801b51:	53                   	push   %ebx
  801b52:	68 f3 27 80 00       	push   $0x8027f3
  801b57:	e8 bb e6 ff ff       	call   800217 <cprintf>
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	eb b9                	jmp    801b1a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b61:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b64:	0f 94 c0             	sete   %al
  801b67:	0f b6 c0             	movzbl %al,%eax
}
  801b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5e                   	pop    %esi
  801b6f:	5f                   	pop    %edi
  801b70:	5d                   	pop    %ebp
  801b71:	c3                   	ret    

00801b72 <devpipe_write>:
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 28             	sub    $0x28,%esp
  801b7b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b7e:	56                   	push   %esi
  801b7f:	e8 cb f2 ff ff       	call   800e4f <fd2data>
  801b84:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b86:	83 c4 10             	add    $0x10,%esp
  801b89:	bf 00 00 00 00       	mov    $0x0,%edi
  801b8e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b91:	74 4f                	je     801be2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b93:	8b 43 04             	mov    0x4(%ebx),%eax
  801b96:	8b 0b                	mov    (%ebx),%ecx
  801b98:	8d 51 20             	lea    0x20(%ecx),%edx
  801b9b:	39 d0                	cmp    %edx,%eax
  801b9d:	72 14                	jb     801bb3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b9f:	89 da                	mov    %ebx,%edx
  801ba1:	89 f0                	mov    %esi,%eax
  801ba3:	e8 65 ff ff ff       	call   801b0d <_pipeisclosed>
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	75 3a                	jne    801be6 <devpipe_write+0x74>
			sys_yield();
  801bac:	e8 5f f0 ff ff       	call   800c10 <sys_yield>
  801bb1:	eb e0                	jmp    801b93 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801bba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801bbd:	89 c2                	mov    %eax,%edx
  801bbf:	c1 fa 1f             	sar    $0x1f,%edx
  801bc2:	89 d1                	mov    %edx,%ecx
  801bc4:	c1 e9 1b             	shr    $0x1b,%ecx
  801bc7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801bca:	83 e2 1f             	and    $0x1f,%edx
  801bcd:	29 ca                	sub    %ecx,%edx
  801bcf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801bd3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801bd7:	83 c0 01             	add    $0x1,%eax
  801bda:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bdd:	83 c7 01             	add    $0x1,%edi
  801be0:	eb ac                	jmp    801b8e <devpipe_write+0x1c>
	return i;
  801be2:	89 f8                	mov    %edi,%eax
  801be4:	eb 05                	jmp    801beb <devpipe_write+0x79>
				return 0;
  801be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bee:	5b                   	pop    %ebx
  801bef:	5e                   	pop    %esi
  801bf0:	5f                   	pop    %edi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <devpipe_read>:
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	57                   	push   %edi
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 18             	sub    $0x18,%esp
  801bfc:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bff:	57                   	push   %edi
  801c00:	e8 4a f2 ff ff       	call   800e4f <fd2data>
  801c05:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c07:	83 c4 10             	add    $0x10,%esp
  801c0a:	be 00 00 00 00       	mov    $0x0,%esi
  801c0f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c12:	74 47                	je     801c5b <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c14:	8b 03                	mov    (%ebx),%eax
  801c16:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c19:	75 22                	jne    801c3d <devpipe_read+0x4a>
			if (i > 0)
  801c1b:	85 f6                	test   %esi,%esi
  801c1d:	75 14                	jne    801c33 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c1f:	89 da                	mov    %ebx,%edx
  801c21:	89 f8                	mov    %edi,%eax
  801c23:	e8 e5 fe ff ff       	call   801b0d <_pipeisclosed>
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	75 33                	jne    801c5f <devpipe_read+0x6c>
			sys_yield();
  801c2c:	e8 df ef ff ff       	call   800c10 <sys_yield>
  801c31:	eb e1                	jmp    801c14 <devpipe_read+0x21>
				return i;
  801c33:	89 f0                	mov    %esi,%eax
}
  801c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c3d:	99                   	cltd   
  801c3e:	c1 ea 1b             	shr    $0x1b,%edx
  801c41:	01 d0                	add    %edx,%eax
  801c43:	83 e0 1f             	and    $0x1f,%eax
  801c46:	29 d0                	sub    %edx,%eax
  801c48:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c50:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801c53:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801c56:	83 c6 01             	add    $0x1,%esi
  801c59:	eb b4                	jmp    801c0f <devpipe_read+0x1c>
	return i;
  801c5b:	89 f0                	mov    %esi,%eax
  801c5d:	eb d6                	jmp    801c35 <devpipe_read+0x42>
				return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c64:	eb cf                	jmp    801c35 <devpipe_read+0x42>

00801c66 <pipe>:
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	56                   	push   %esi
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c71:	50                   	push   %eax
  801c72:	e8 ef f1 ff ff       	call   800e66 <fd_alloc>
  801c77:	89 c3                	mov    %eax,%ebx
  801c79:	83 c4 10             	add    $0x10,%esp
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	78 5b                	js     801cdb <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	68 07 04 00 00       	push   $0x407
  801c88:	ff 75 f4             	pushl  -0xc(%ebp)
  801c8b:	6a 00                	push   $0x0
  801c8d:	e8 9d ef ff ff       	call   800c2f <sys_page_alloc>
  801c92:	89 c3                	mov    %eax,%ebx
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 40                	js     801cdb <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801c9b:	83 ec 0c             	sub    $0xc,%esp
  801c9e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ca1:	50                   	push   %eax
  801ca2:	e8 bf f1 ff ff       	call   800e66 <fd_alloc>
  801ca7:	89 c3                	mov    %eax,%ebx
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 1b                	js     801ccb <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	68 07 04 00 00       	push   $0x407
  801cb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbb:	6a 00                	push   $0x0
  801cbd:	e8 6d ef ff ff       	call   800c2f <sys_page_alloc>
  801cc2:	89 c3                	mov    %eax,%ebx
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	79 19                	jns    801ce4 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801ccb:	83 ec 08             	sub    $0x8,%esp
  801cce:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd1:	6a 00                	push   $0x0
  801cd3:	e8 dc ef ff ff       	call   800cb4 <sys_page_unmap>
  801cd8:	83 c4 10             	add    $0x10,%esp
}
  801cdb:	89 d8                	mov    %ebx,%eax
  801cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5e                   	pop    %esi
  801ce2:	5d                   	pop    %ebp
  801ce3:	c3                   	ret    
	va = fd2data(fd0);
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	ff 75 f4             	pushl  -0xc(%ebp)
  801cea:	e8 60 f1 ff ff       	call   800e4f <fd2data>
  801cef:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cf1:	83 c4 0c             	add    $0xc,%esp
  801cf4:	68 07 04 00 00       	push   $0x407
  801cf9:	50                   	push   %eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	e8 2e ef ff ff       	call   800c2f <sys_page_alloc>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	85 c0                	test   %eax,%eax
  801d08:	0f 88 8c 00 00 00    	js     801d9a <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	ff 75 f0             	pushl  -0x10(%ebp)
  801d14:	e8 36 f1 ff ff       	call   800e4f <fd2data>
  801d19:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d20:	50                   	push   %eax
  801d21:	6a 00                	push   $0x0
  801d23:	56                   	push   %esi
  801d24:	6a 00                	push   $0x0
  801d26:	e8 47 ef ff ff       	call   800c72 <sys_page_map>
  801d2b:	89 c3                	mov    %eax,%ebx
  801d2d:	83 c4 20             	add    $0x20,%esp
  801d30:	85 c0                	test   %eax,%eax
  801d32:	78 58                	js     801d8c <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d37:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d3d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d52:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d5e:	83 ec 0c             	sub    $0xc,%esp
  801d61:	ff 75 f4             	pushl  -0xc(%ebp)
  801d64:	e8 d6 f0 ff ff       	call   800e3f <fd2num>
  801d69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d6e:	83 c4 04             	add    $0x4,%esp
  801d71:	ff 75 f0             	pushl  -0x10(%ebp)
  801d74:	e8 c6 f0 ff ff       	call   800e3f <fd2num>
  801d79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d87:	e9 4f ff ff ff       	jmp    801cdb <pipe+0x75>
	sys_page_unmap(0, va);
  801d8c:	83 ec 08             	sub    $0x8,%esp
  801d8f:	56                   	push   %esi
  801d90:	6a 00                	push   $0x0
  801d92:	e8 1d ef ff ff       	call   800cb4 <sys_page_unmap>
  801d97:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	ff 75 f0             	pushl  -0x10(%ebp)
  801da0:	6a 00                	push   $0x0
  801da2:	e8 0d ef ff ff       	call   800cb4 <sys_page_unmap>
  801da7:	83 c4 10             	add    $0x10,%esp
  801daa:	e9 1c ff ff ff       	jmp    801ccb <pipe+0x65>

00801daf <pipeisclosed>:
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db8:	50                   	push   %eax
  801db9:	ff 75 08             	pushl  0x8(%ebp)
  801dbc:	e8 f4 f0 ff ff       	call   800eb5 <fd_lookup>
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	78 18                	js     801de0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dce:	e8 7c f0 ff ff       	call   800e4f <fd2data>
	return _pipeisclosed(fd, p);
  801dd3:	89 c2                	mov    %eax,%edx
  801dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd8:	e8 30 fd ff ff       	call   801b0d <_pipeisclosed>
  801ddd:	83 c4 10             	add    $0x10,%esp
}
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801df2:	68 0b 28 80 00       	push   $0x80280b
  801df7:	ff 75 0c             	pushl  0xc(%ebp)
  801dfa:	e8 37 ea ff ff       	call   800836 <strcpy>
	return 0;
}
  801dff:	b8 00 00 00 00       	mov    $0x0,%eax
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <devcons_write>:
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	57                   	push   %edi
  801e0a:	56                   	push   %esi
  801e0b:	53                   	push   %ebx
  801e0c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e12:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e17:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e1d:	eb 2f                	jmp    801e4e <devcons_write+0x48>
		m = n - tot;
  801e1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e22:	29 f3                	sub    %esi,%ebx
  801e24:	83 fb 7f             	cmp    $0x7f,%ebx
  801e27:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e2c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	53                   	push   %ebx
  801e33:	89 f0                	mov    %esi,%eax
  801e35:	03 45 0c             	add    0xc(%ebp),%eax
  801e38:	50                   	push   %eax
  801e39:	57                   	push   %edi
  801e3a:	e8 85 eb ff ff       	call   8009c4 <memmove>
		sys_cputs(buf, m);
  801e3f:	83 c4 08             	add    $0x8,%esp
  801e42:	53                   	push   %ebx
  801e43:	57                   	push   %edi
  801e44:	e8 2a ed ff ff       	call   800b73 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e49:	01 de                	add    %ebx,%esi
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e51:	72 cc                	jb     801e1f <devcons_write+0x19>
}
  801e53:	89 f0                	mov    %esi,%eax
  801e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e58:	5b                   	pop    %ebx
  801e59:	5e                   	pop    %esi
  801e5a:	5f                   	pop    %edi
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    

00801e5d <devcons_read>:
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 08             	sub    $0x8,%esp
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801e68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e6c:	75 07                	jne    801e75 <devcons_read+0x18>
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    
		sys_yield();
  801e70:	e8 9b ed ff ff       	call   800c10 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e75:	e8 17 ed ff ff       	call   800b91 <sys_cgetc>
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	74 f2                	je     801e70 <devcons_read+0x13>
	if (c < 0)
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	78 ec                	js     801e6e <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801e82:	83 f8 04             	cmp    $0x4,%eax
  801e85:	74 0c                	je     801e93 <devcons_read+0x36>
	*(char*)vbuf = c;
  801e87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e8a:	88 02                	mov    %al,(%edx)
	return 1;
  801e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e91:	eb db                	jmp    801e6e <devcons_read+0x11>
		return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
  801e98:	eb d4                	jmp    801e6e <devcons_read+0x11>

00801e9a <cputchar>:
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ea6:	6a 01                	push   $0x1
  801ea8:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801eab:	50                   	push   %eax
  801eac:	e8 c2 ec ff ff       	call   800b73 <sys_cputs>
}
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <getchar>:
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ebc:	6a 01                	push   $0x1
  801ebe:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ec1:	50                   	push   %eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	e8 5d f2 ff ff       	call   801126 <read>
	if (r < 0)
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 08                	js     801ed8 <getchar+0x22>
	if (r < 1)
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	7e 06                	jle    801eda <getchar+0x24>
	return c;
  801ed4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    
		return -E_EOF;
  801eda:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801edf:	eb f7                	jmp    801ed8 <getchar+0x22>

00801ee1 <iscons>:
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ee7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eea:	50                   	push   %eax
  801eeb:	ff 75 08             	pushl  0x8(%ebp)
  801eee:	e8 c2 ef ff ff       	call   800eb5 <fd_lookup>
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	78 11                	js     801f0b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efd:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f03:	39 10                	cmp    %edx,(%eax)
  801f05:	0f 94 c0             	sete   %al
  801f08:	0f b6 c0             	movzbl %al,%eax
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <opencons>:
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f13:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f16:	50                   	push   %eax
  801f17:	e8 4a ef ff ff       	call   800e66 <fd_alloc>
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 3a                	js     801f5d <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f23:	83 ec 04             	sub    $0x4,%esp
  801f26:	68 07 04 00 00       	push   $0x407
  801f2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2e:	6a 00                	push   $0x0
  801f30:	e8 fa ec ff ff       	call   800c2f <sys_page_alloc>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	78 21                	js     801f5d <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f45:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	50                   	push   %eax
  801f55:	e8 e5 ee ff ff       	call   800e3f <fd2num>
  801f5a:	83 c4 10             	add    $0x10,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	8b 75 08             	mov    0x8(%ebp),%esi
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f6d:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f6f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f74:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f77:	83 ec 0c             	sub    $0xc,%esp
  801f7a:	50                   	push   %eax
  801f7b:	e8 5f ee ff ff       	call   800ddf <sys_ipc_recv>
	if (from_env_store)
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 f6                	test   %esi,%esi
  801f85:	74 14                	je     801f9b <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f87:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	78 09                	js     801f99 <ipc_recv+0x3a>
  801f90:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801f96:	8b 52 74             	mov    0x74(%edx),%edx
  801f99:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f9b:	85 db                	test   %ebx,%ebx
  801f9d:	74 14                	je     801fb3 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	78 09                	js     801fb1 <ipc_recv+0x52>
  801fa8:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801fae:	8b 52 78             	mov    0x78(%edx),%edx
  801fb1:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 08                	js     801fbf <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801fb7:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801fbc:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801fbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    

00801fc6 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	57                   	push   %edi
  801fca:	56                   	push   %esi
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 0c             	sub    $0xc,%esp
  801fcf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801fd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801fd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801fd8:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801fda:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801fdf:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801fe2:	ff 75 14             	pushl  0x14(%ebp)
  801fe5:	53                   	push   %ebx
  801fe6:	56                   	push   %esi
  801fe7:	57                   	push   %edi
  801fe8:	e8 cf ed ff ff       	call   800dbc <sys_ipc_try_send>
		if (ret == 0)
  801fed:	83 c4 10             	add    $0x10,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	74 1e                	je     802012 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801ff4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801ff7:	75 07                	jne    802000 <ipc_send+0x3a>
			sys_yield();
  801ff9:	e8 12 ec ff ff       	call   800c10 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801ffe:	eb e2                	jmp    801fe2 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802000:	50                   	push   %eax
  802001:	68 17 28 80 00       	push   $0x802817
  802006:	6a 3d                	push   $0x3d
  802008:	68 2b 28 80 00       	push   $0x80282b
  80200d:	e8 2a e1 ff ff       	call   80013c <_panic>
	}
	// panic("ipc_send not implemented");
}
  802012:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802015:	5b                   	pop    %ebx
  802016:	5e                   	pop    %esi
  802017:	5f                   	pop    %edi
  802018:	5d                   	pop    %ebp
  802019:	c3                   	ret    

0080201a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802025:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802028:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80202e:	8b 52 50             	mov    0x50(%edx),%edx
  802031:	39 ca                	cmp    %ecx,%edx
  802033:	74 11                	je     802046 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802035:	83 c0 01             	add    $0x1,%eax
  802038:	3d 00 04 00 00       	cmp    $0x400,%eax
  80203d:	75 e6                	jne    802025 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	eb 0b                	jmp    802051 <ipc_find_env+0x37>
			return envs[i].env_id;
  802046:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802049:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80204e:	8b 40 48             	mov    0x48(%eax),%eax
}
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802059:	89 d0                	mov    %edx,%eax
  80205b:	c1 e8 16             	shr    $0x16,%eax
  80205e:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80206a:	f6 c1 01             	test   $0x1,%cl
  80206d:	74 1d                	je     80208c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80206f:	c1 ea 0c             	shr    $0xc,%edx
  802072:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802079:	f6 c2 01             	test   $0x1,%dl
  80207c:	74 0e                	je     80208c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80207e:	c1 ea 0c             	shr    $0xc,%edx
  802081:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802088:	ef 
  802089:	0f b7 c0             	movzwl %ax,%eax
}
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    
  80208e:	66 90                	xchg   %ax,%ax

00802090 <__udivdi3>:
  802090:	55                   	push   %ebp
  802091:	57                   	push   %edi
  802092:	56                   	push   %esi
  802093:	53                   	push   %ebx
  802094:	83 ec 1c             	sub    $0x1c,%esp
  802097:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80209b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80209f:	8b 74 24 34          	mov    0x34(%esp),%esi
  8020a3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8020a7:	85 d2                	test   %edx,%edx
  8020a9:	75 35                	jne    8020e0 <__udivdi3+0x50>
  8020ab:	39 f3                	cmp    %esi,%ebx
  8020ad:	0f 87 bd 00 00 00    	ja     802170 <__udivdi3+0xe0>
  8020b3:	85 db                	test   %ebx,%ebx
  8020b5:	89 d9                	mov    %ebx,%ecx
  8020b7:	75 0b                	jne    8020c4 <__udivdi3+0x34>
  8020b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020be:	31 d2                	xor    %edx,%edx
  8020c0:	f7 f3                	div    %ebx
  8020c2:	89 c1                	mov    %eax,%ecx
  8020c4:	31 d2                	xor    %edx,%edx
  8020c6:	89 f0                	mov    %esi,%eax
  8020c8:	f7 f1                	div    %ecx
  8020ca:	89 c6                	mov    %eax,%esi
  8020cc:	89 e8                	mov    %ebp,%eax
  8020ce:	89 f7                	mov    %esi,%edi
  8020d0:	f7 f1                	div    %ecx
  8020d2:	89 fa                	mov    %edi,%edx
  8020d4:	83 c4 1c             	add    $0x1c,%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5f                   	pop    %edi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    
  8020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	39 f2                	cmp    %esi,%edx
  8020e2:	77 7c                	ja     802160 <__udivdi3+0xd0>
  8020e4:	0f bd fa             	bsr    %edx,%edi
  8020e7:	83 f7 1f             	xor    $0x1f,%edi
  8020ea:	0f 84 98 00 00 00    	je     802188 <__udivdi3+0xf8>
  8020f0:	89 f9                	mov    %edi,%ecx
  8020f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8020f7:	29 f8                	sub    %edi,%eax
  8020f9:	d3 e2                	shl    %cl,%edx
  8020fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ff:	89 c1                	mov    %eax,%ecx
  802101:	89 da                	mov    %ebx,%edx
  802103:	d3 ea                	shr    %cl,%edx
  802105:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802109:	09 d1                	or     %edx,%ecx
  80210b:	89 f2                	mov    %esi,%edx
  80210d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802111:	89 f9                	mov    %edi,%ecx
  802113:	d3 e3                	shl    %cl,%ebx
  802115:	89 c1                	mov    %eax,%ecx
  802117:	d3 ea                	shr    %cl,%edx
  802119:	89 f9                	mov    %edi,%ecx
  80211b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80211f:	d3 e6                	shl    %cl,%esi
  802121:	89 eb                	mov    %ebp,%ebx
  802123:	89 c1                	mov    %eax,%ecx
  802125:	d3 eb                	shr    %cl,%ebx
  802127:	09 de                	or     %ebx,%esi
  802129:	89 f0                	mov    %esi,%eax
  80212b:	f7 74 24 08          	divl   0x8(%esp)
  80212f:	89 d6                	mov    %edx,%esi
  802131:	89 c3                	mov    %eax,%ebx
  802133:	f7 64 24 0c          	mull   0xc(%esp)
  802137:	39 d6                	cmp    %edx,%esi
  802139:	72 0c                	jb     802147 <__udivdi3+0xb7>
  80213b:	89 f9                	mov    %edi,%ecx
  80213d:	d3 e5                	shl    %cl,%ebp
  80213f:	39 c5                	cmp    %eax,%ebp
  802141:	73 5d                	jae    8021a0 <__udivdi3+0x110>
  802143:	39 d6                	cmp    %edx,%esi
  802145:	75 59                	jne    8021a0 <__udivdi3+0x110>
  802147:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80214a:	31 ff                	xor    %edi,%edi
  80214c:	89 fa                	mov    %edi,%edx
  80214e:	83 c4 1c             	add    $0x1c,%esp
  802151:	5b                   	pop    %ebx
  802152:	5e                   	pop    %esi
  802153:	5f                   	pop    %edi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    
  802156:	8d 76 00             	lea    0x0(%esi),%esi
  802159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802160:	31 ff                	xor    %edi,%edi
  802162:	31 c0                	xor    %eax,%eax
  802164:	89 fa                	mov    %edi,%edx
  802166:	83 c4 1c             	add    $0x1c,%esp
  802169:	5b                   	pop    %ebx
  80216a:	5e                   	pop    %esi
  80216b:	5f                   	pop    %edi
  80216c:	5d                   	pop    %ebp
  80216d:	c3                   	ret    
  80216e:	66 90                	xchg   %ax,%ax
  802170:	31 ff                	xor    %edi,%edi
  802172:	89 e8                	mov    %ebp,%eax
  802174:	89 f2                	mov    %esi,%edx
  802176:	f7 f3                	div    %ebx
  802178:	89 fa                	mov    %edi,%edx
  80217a:	83 c4 1c             	add    $0x1c,%esp
  80217d:	5b                   	pop    %ebx
  80217e:	5e                   	pop    %esi
  80217f:	5f                   	pop    %edi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    
  802182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802188:	39 f2                	cmp    %esi,%edx
  80218a:	72 06                	jb     802192 <__udivdi3+0x102>
  80218c:	31 c0                	xor    %eax,%eax
  80218e:	39 eb                	cmp    %ebp,%ebx
  802190:	77 d2                	ja     802164 <__udivdi3+0xd4>
  802192:	b8 01 00 00 00       	mov    $0x1,%eax
  802197:	eb cb                	jmp    802164 <__udivdi3+0xd4>
  802199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8021a0:	89 d8                	mov    %ebx,%eax
  8021a2:	31 ff                	xor    %edi,%edi
  8021a4:	eb be                	jmp    802164 <__udivdi3+0xd4>
  8021a6:	66 90                	xchg   %ax,%ax
  8021a8:	66 90                	xchg   %ax,%ax
  8021aa:	66 90                	xchg   %ax,%ax
  8021ac:	66 90                	xchg   %ax,%ax
  8021ae:	66 90                	xchg   %ax,%ax

008021b0 <__umoddi3>:
  8021b0:	55                   	push   %ebp
  8021b1:	57                   	push   %edi
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
  8021b4:	83 ec 1c             	sub    $0x1c,%esp
  8021b7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8021bb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8021bf:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8021c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021c7:	85 ed                	test   %ebp,%ebp
  8021c9:	89 f0                	mov    %esi,%eax
  8021cb:	89 da                	mov    %ebx,%edx
  8021cd:	75 19                	jne    8021e8 <__umoddi3+0x38>
  8021cf:	39 df                	cmp    %ebx,%edi
  8021d1:	0f 86 b1 00 00 00    	jbe    802288 <__umoddi3+0xd8>
  8021d7:	f7 f7                	div    %edi
  8021d9:	89 d0                	mov    %edx,%eax
  8021db:	31 d2                	xor    %edx,%edx
  8021dd:	83 c4 1c             	add    $0x1c,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5e                   	pop    %esi
  8021e2:	5f                   	pop    %edi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    
  8021e5:	8d 76 00             	lea    0x0(%esi),%esi
  8021e8:	39 dd                	cmp    %ebx,%ebp
  8021ea:	77 f1                	ja     8021dd <__umoddi3+0x2d>
  8021ec:	0f bd cd             	bsr    %ebp,%ecx
  8021ef:	83 f1 1f             	xor    $0x1f,%ecx
  8021f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8021f6:	0f 84 b4 00 00 00    	je     8022b0 <__umoddi3+0x100>
  8021fc:	b8 20 00 00 00       	mov    $0x20,%eax
  802201:	89 c2                	mov    %eax,%edx
  802203:	8b 44 24 04          	mov    0x4(%esp),%eax
  802207:	29 c2                	sub    %eax,%edx
  802209:	89 c1                	mov    %eax,%ecx
  80220b:	89 f8                	mov    %edi,%eax
  80220d:	d3 e5                	shl    %cl,%ebp
  80220f:	89 d1                	mov    %edx,%ecx
  802211:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802215:	d3 e8                	shr    %cl,%eax
  802217:	09 c5                	or     %eax,%ebp
  802219:	8b 44 24 04          	mov    0x4(%esp),%eax
  80221d:	89 c1                	mov    %eax,%ecx
  80221f:	d3 e7                	shl    %cl,%edi
  802221:	89 d1                	mov    %edx,%ecx
  802223:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802227:	89 df                	mov    %ebx,%edi
  802229:	d3 ef                	shr    %cl,%edi
  80222b:	89 c1                	mov    %eax,%ecx
  80222d:	89 f0                	mov    %esi,%eax
  80222f:	d3 e3                	shl    %cl,%ebx
  802231:	89 d1                	mov    %edx,%ecx
  802233:	89 fa                	mov    %edi,%edx
  802235:	d3 e8                	shr    %cl,%eax
  802237:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80223c:	09 d8                	or     %ebx,%eax
  80223e:	f7 f5                	div    %ebp
  802240:	d3 e6                	shl    %cl,%esi
  802242:	89 d1                	mov    %edx,%ecx
  802244:	f7 64 24 08          	mull   0x8(%esp)
  802248:	39 d1                	cmp    %edx,%ecx
  80224a:	89 c3                	mov    %eax,%ebx
  80224c:	89 d7                	mov    %edx,%edi
  80224e:	72 06                	jb     802256 <__umoddi3+0xa6>
  802250:	75 0e                	jne    802260 <__umoddi3+0xb0>
  802252:	39 c6                	cmp    %eax,%esi
  802254:	73 0a                	jae    802260 <__umoddi3+0xb0>
  802256:	2b 44 24 08          	sub    0x8(%esp),%eax
  80225a:	19 ea                	sbb    %ebp,%edx
  80225c:	89 d7                	mov    %edx,%edi
  80225e:	89 c3                	mov    %eax,%ebx
  802260:	89 ca                	mov    %ecx,%edx
  802262:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802267:	29 de                	sub    %ebx,%esi
  802269:	19 fa                	sbb    %edi,%edx
  80226b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80226f:	89 d0                	mov    %edx,%eax
  802271:	d3 e0                	shl    %cl,%eax
  802273:	89 d9                	mov    %ebx,%ecx
  802275:	d3 ee                	shr    %cl,%esi
  802277:	d3 ea                	shr    %cl,%edx
  802279:	09 f0                	or     %esi,%eax
  80227b:	83 c4 1c             	add    $0x1c,%esp
  80227e:	5b                   	pop    %ebx
  80227f:	5e                   	pop    %esi
  802280:	5f                   	pop    %edi
  802281:	5d                   	pop    %ebp
  802282:	c3                   	ret    
  802283:	90                   	nop
  802284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802288:	85 ff                	test   %edi,%edi
  80228a:	89 f9                	mov    %edi,%ecx
  80228c:	75 0b                	jne    802299 <__umoddi3+0xe9>
  80228e:	b8 01 00 00 00       	mov    $0x1,%eax
  802293:	31 d2                	xor    %edx,%edx
  802295:	f7 f7                	div    %edi
  802297:	89 c1                	mov    %eax,%ecx
  802299:	89 d8                	mov    %ebx,%eax
  80229b:	31 d2                	xor    %edx,%edx
  80229d:	f7 f1                	div    %ecx
  80229f:	89 f0                	mov    %esi,%eax
  8022a1:	f7 f1                	div    %ecx
  8022a3:	e9 31 ff ff ff       	jmp    8021d9 <__umoddi3+0x29>
  8022a8:	90                   	nop
  8022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022b0:	39 dd                	cmp    %ebx,%ebp
  8022b2:	72 08                	jb     8022bc <__umoddi3+0x10c>
  8022b4:	39 f7                	cmp    %esi,%edi
  8022b6:	0f 87 21 ff ff ff    	ja     8021dd <__umoddi3+0x2d>
  8022bc:	89 da                	mov    %ebx,%edx
  8022be:	89 f0                	mov    %esi,%eax
  8022c0:	29 f8                	sub    %edi,%eax
  8022c2:	19 ea                	sbb    %ebp,%edx
  8022c4:	e9 14 ff ff ff       	jmp    8021dd <__umoddi3+0x2d>

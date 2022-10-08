
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 03 01 00 00       	call   800134 <libmain>
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
  800038:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 30 80 00 20 	movl   $0x802920,0x803000
  800045:	29 80 00 

	cprintf("icode startup\n");
  800048:	68 26 29 80 00       	push   $0x802926
  80004d:	e8 1d 02 00 00       	call   80026f <cprintf>

	cprintf("icode: open /motd\n");
  800052:	c7 04 24 35 29 80 00 	movl   $0x802935,(%esp)
  800059:	e8 11 02 00 00       	call   80026f <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  80005e:	83 c4 08             	add    $0x8,%esp
  800061:	6a 00                	push   $0x0
  800063:	68 48 29 80 00       	push   $0x802948
  800068:	e8 76 15 00 00       	call   8015e3 <open>
  80006d:	89 c6                	mov    %eax,%esi
  80006f:	83 c4 10             	add    $0x10,%esp
  800072:	85 c0                	test   %eax,%eax
  800074:	78 18                	js     80008e <umain+0x5b>
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 71 29 80 00       	push   $0x802971
  80007e:	e8 ec 01 00 00       	call   80026f <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  80008c:	eb 1f                	jmp    8000ad <umain+0x7a>
		panic("icode: open /motd: %e", fd);
  80008e:	50                   	push   %eax
  80008f:	68 4e 29 80 00       	push   $0x80294e
  800094:	6a 0f                	push   $0xf
  800096:	68 64 29 80 00       	push   $0x802964
  80009b:	e8 f4 00 00 00       	call   800194 <_panic>
		sys_cputs(buf, n);
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	50                   	push   %eax
  8000a4:	53                   	push   %ebx
  8000a5:	e8 21 0b 00 00       	call   800bcb <sys_cputs>
  8000aa:	83 c4 10             	add    $0x10,%esp
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	68 00 02 00 00       	push   $0x200
  8000b5:	53                   	push   %ebx
  8000b6:	56                   	push   %esi
  8000b7:	e8 c2 10 00 00       	call   80117e <read>
  8000bc:	83 c4 10             	add    $0x10,%esp
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	7f dd                	jg     8000a0 <umain+0x6d>

	cprintf("icode: close /motd\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 84 29 80 00       	push   $0x802984
  8000cb:	e8 9f 01 00 00       	call   80026f <cprintf>
	close(fd);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 6a 0f 00 00       	call   801042 <close>

	cprintf("icode: spawn /init\n");
  8000d8:	c7 04 24 98 29 80 00 	movl   $0x802998,(%esp)
  8000df:	e8 8b 01 00 00       	call   80026f <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000eb:	68 ac 29 80 00       	push   $0x8029ac
  8000f0:	68 b5 29 80 00       	push   $0x8029b5
  8000f5:	68 bf 29 80 00       	push   $0x8029bf
  8000fa:	68 be 29 80 00       	push   $0x8029be
  8000ff:	e8 fe 1a 00 00       	call   801c02 <spawnl>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	85 c0                	test   %eax,%eax
  800109:	78 17                	js     800122 <umain+0xef>
		panic("icode: spawn /init: %e", r);

	cprintf("icode: exiting\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 db 29 80 00       	push   $0x8029db
  800113:	e8 57 01 00 00       	call   80026f <cprintf>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    
		panic("icode: spawn /init: %e", r);
  800122:	50                   	push   %eax
  800123:	68 c4 29 80 00       	push   $0x8029c4
  800128:	6a 1a                	push   $0x1a
  80012a:	68 64 29 80 00       	push   $0x802964
  80012f:	e8 60 00 00 00       	call   800194 <_panic>

00800134 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	56                   	push   %esi
  800138:	53                   	push   %ebx
  800139:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013f:	e8 05 0b 00 00       	call   800c49 <sys_getenvid>
  800144:	25 ff 03 00 00       	and    $0x3ff,%eax
  800149:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80014c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800151:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800156:	85 db                	test   %ebx,%ebx
  800158:	7e 07                	jle    800161 <libmain+0x2d>
		binaryname = argv[0];
  80015a:	8b 06                	mov    (%esi),%eax
  80015c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800161:	83 ec 08             	sub    $0x8,%esp
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	e8 c8 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80016b:	e8 0a 00 00 00       	call   80017a <exit>
}
  800170:	83 c4 10             	add    $0x10,%esp
  800173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800180:	e8 e8 0e 00 00       	call   80106d <close_all>
	sys_env_destroy(0);
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	6a 00                	push   $0x0
  80018a:	e8 79 0a 00 00       	call   800c08 <sys_env_destroy>
}
  80018f:	83 c4 10             	add    $0x10,%esp
  800192:	c9                   	leave  
  800193:	c3                   	ret    

00800194 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800199:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80019c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001a2:	e8 a2 0a 00 00       	call   800c49 <sys_getenvid>
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	56                   	push   %esi
  8001b1:	50                   	push   %eax
  8001b2:	68 f8 29 80 00       	push   $0x8029f8
  8001b7:	e8 b3 00 00 00       	call   80026f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001bc:	83 c4 18             	add    $0x18,%esp
  8001bf:	53                   	push   %ebx
  8001c0:	ff 75 10             	pushl  0x10(%ebp)
  8001c3:	e8 56 00 00 00       	call   80021e <vcprintf>
	cprintf("\n");
  8001c8:	c7 04 24 15 2f 80 00 	movl   $0x802f15,(%esp)
  8001cf:	e8 9b 00 00 00       	call   80026f <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d7:	cc                   	int3   
  8001d8:	eb fd                	jmp    8001d7 <_panic+0x43>

008001da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	53                   	push   %ebx
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e4:	8b 13                	mov    (%ebx),%edx
  8001e6:	8d 42 01             	lea    0x1(%edx),%eax
  8001e9:	89 03                	mov    %eax,(%ebx)
  8001eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f7:	74 09                	je     800202 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001f9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800200:	c9                   	leave  
  800201:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800202:	83 ec 08             	sub    $0x8,%esp
  800205:	68 ff 00 00 00       	push   $0xff
  80020a:	8d 43 08             	lea    0x8(%ebx),%eax
  80020d:	50                   	push   %eax
  80020e:	e8 b8 09 00 00       	call   800bcb <sys_cputs>
		b->idx = 0;
  800213:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	eb db                	jmp    8001f9 <putch+0x1f>

0080021e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800227:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80022e:	00 00 00 
	b.cnt = 0;
  800231:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800238:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80023b:	ff 75 0c             	pushl  0xc(%ebp)
  80023e:	ff 75 08             	pushl  0x8(%ebp)
  800241:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800247:	50                   	push   %eax
  800248:	68 da 01 80 00       	push   $0x8001da
  80024d:	e8 1a 01 00 00       	call   80036c <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800252:	83 c4 08             	add    $0x8,%esp
  800255:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80025b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800261:	50                   	push   %eax
  800262:	e8 64 09 00 00       	call   800bcb <sys_cputs>

	return b.cnt;
}
  800267:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800275:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800278:	50                   	push   %eax
  800279:	ff 75 08             	pushl  0x8(%ebp)
  80027c:	e8 9d ff ff ff       	call   80021e <vcprintf>
	va_end(ap);

	return cnt;
}
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	57                   	push   %edi
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 1c             	sub    $0x1c,%esp
  80028c:	89 c7                	mov    %eax,%edi
  80028e:	89 d6                	mov    %edx,%esi
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	8b 55 0c             	mov    0xc(%ebp),%edx
  800296:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800299:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002a7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002aa:	39 d3                	cmp    %edx,%ebx
  8002ac:	72 05                	jb     8002b3 <printnum+0x30>
  8002ae:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002b1:	77 7a                	ja     80032d <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	ff 75 18             	pushl  0x18(%ebp)
  8002b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002bf:	53                   	push   %ebx
  8002c0:	ff 75 10             	pushl  0x10(%ebp)
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	ff 75 dc             	pushl  -0x24(%ebp)
  8002cf:	ff 75 d8             	pushl  -0x28(%ebp)
  8002d2:	e8 09 24 00 00       	call   8026e0 <__udivdi3>
  8002d7:	83 c4 18             	add    $0x18,%esp
  8002da:	52                   	push   %edx
  8002db:	50                   	push   %eax
  8002dc:	89 f2                	mov    %esi,%edx
  8002de:	89 f8                	mov    %edi,%eax
  8002e0:	e8 9e ff ff ff       	call   800283 <printnum>
  8002e5:	83 c4 20             	add    $0x20,%esp
  8002e8:	eb 13                	jmp    8002fd <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	56                   	push   %esi
  8002ee:	ff 75 18             	pushl  0x18(%ebp)
  8002f1:	ff d7                	call   *%edi
  8002f3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002f6:	83 eb 01             	sub    $0x1,%ebx
  8002f9:	85 db                	test   %ebx,%ebx
  8002fb:	7f ed                	jg     8002ea <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	56                   	push   %esi
  800301:	83 ec 04             	sub    $0x4,%esp
  800304:	ff 75 e4             	pushl  -0x1c(%ebp)
  800307:	ff 75 e0             	pushl  -0x20(%ebp)
  80030a:	ff 75 dc             	pushl  -0x24(%ebp)
  80030d:	ff 75 d8             	pushl  -0x28(%ebp)
  800310:	e8 eb 24 00 00       	call   802800 <__umoddi3>
  800315:	83 c4 14             	add    $0x14,%esp
  800318:	0f be 80 1b 2a 80 00 	movsbl 0x802a1b(%eax),%eax
  80031f:	50                   	push   %eax
  800320:	ff d7                	call   *%edi
}
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    
  80032d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800330:	eb c4                	jmp    8002f6 <printnum+0x73>

00800332 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800338:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80033c:	8b 10                	mov    (%eax),%edx
  80033e:	3b 50 04             	cmp    0x4(%eax),%edx
  800341:	73 0a                	jae    80034d <sprintputch+0x1b>
		*b->buf++ = ch;
  800343:	8d 4a 01             	lea    0x1(%edx),%ecx
  800346:	89 08                	mov    %ecx,(%eax)
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	88 02                	mov    %al,(%edx)
}
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <printfmt>:
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800355:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800358:	50                   	push   %eax
  800359:	ff 75 10             	pushl  0x10(%ebp)
  80035c:	ff 75 0c             	pushl  0xc(%ebp)
  80035f:	ff 75 08             	pushl  0x8(%ebp)
  800362:	e8 05 00 00 00       	call   80036c <vprintfmt>
}
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <vprintfmt>:
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	57                   	push   %edi
  800370:	56                   	push   %esi
  800371:	53                   	push   %ebx
  800372:	83 ec 2c             	sub    $0x2c,%esp
  800375:	8b 75 08             	mov    0x8(%ebp),%esi
  800378:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80037b:	8b 7d 10             	mov    0x10(%ebp),%edi
  80037e:	e9 c1 03 00 00       	jmp    800744 <vprintfmt+0x3d8>
		padc = ' ';
  800383:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800387:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80038e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800395:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80039c:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a1:	8d 47 01             	lea    0x1(%edi),%eax
  8003a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003a7:	0f b6 17             	movzbl (%edi),%edx
  8003aa:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003ad:	3c 55                	cmp    $0x55,%al
  8003af:	0f 87 12 04 00 00    	ja     8007c7 <vprintfmt+0x45b>
  8003b5:	0f b6 c0             	movzbl %al,%eax
  8003b8:	ff 24 85 60 2b 80 00 	jmp    *0x802b60(,%eax,4)
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c2:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003c6:	eb d9                	jmp    8003a1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003cb:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003cf:	eb d0                	jmp    8003a1 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003d1:	0f b6 d2             	movzbl %dl,%edx
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8003dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003df:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003e2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003e6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003e9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ec:	83 f9 09             	cmp    $0x9,%ecx
  8003ef:	77 55                	ja     800446 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003f1:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003f4:	eb e9                	jmp    8003df <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8d 40 04             	lea    0x4(%eax),%eax
  800404:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80040a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80040e:	79 91                	jns    8003a1 <vprintfmt+0x35>
				width = precision, precision = -1;
  800410:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800413:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800416:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80041d:	eb 82                	jmp    8003a1 <vprintfmt+0x35>
  80041f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800422:	85 c0                	test   %eax,%eax
  800424:	ba 00 00 00 00       	mov    $0x0,%edx
  800429:	0f 49 d0             	cmovns %eax,%edx
  80042c:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800432:	e9 6a ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
  800437:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80043a:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800441:	e9 5b ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
  800446:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800449:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80044c:	eb bc                	jmp    80040a <vprintfmt+0x9e>
			lflag++;
  80044e:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800451:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800454:	e9 48 ff ff ff       	jmp    8003a1 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800459:	8b 45 14             	mov    0x14(%ebp),%eax
  80045c:	8d 78 04             	lea    0x4(%eax),%edi
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	ff 30                	pushl  (%eax)
  800465:	ff d6                	call   *%esi
			break;
  800467:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80046a:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80046d:	e9 cf 02 00 00       	jmp    800741 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8d 78 04             	lea    0x4(%eax),%edi
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	99                   	cltd   
  80047b:	31 d0                	xor    %edx,%eax
  80047d:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047f:	83 f8 0f             	cmp    $0xf,%eax
  800482:	7f 23                	jg     8004a7 <vprintfmt+0x13b>
  800484:	8b 14 85 c0 2c 80 00 	mov    0x802cc0(,%eax,4),%edx
  80048b:	85 d2                	test   %edx,%edx
  80048d:	74 18                	je     8004a7 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80048f:	52                   	push   %edx
  800490:	68 f5 2d 80 00       	push   $0x802df5
  800495:	53                   	push   %ebx
  800496:	56                   	push   %esi
  800497:	e8 b3 fe ff ff       	call   80034f <printfmt>
  80049c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80049f:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a2:	e9 9a 02 00 00       	jmp    800741 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8004a7:	50                   	push   %eax
  8004a8:	68 33 2a 80 00       	push   $0x802a33
  8004ad:	53                   	push   %ebx
  8004ae:	56                   	push   %esi
  8004af:	e8 9b fe ff ff       	call   80034f <printfmt>
  8004b4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004b7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004ba:	e9 82 02 00 00       	jmp    800741 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	83 c0 04             	add    $0x4,%eax
  8004c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004cd:	85 ff                	test   %edi,%edi
  8004cf:	b8 2c 2a 80 00       	mov    $0x802a2c,%eax
  8004d4:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004db:	0f 8e bd 00 00 00    	jle    80059e <vprintfmt+0x232>
  8004e1:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004e5:	75 0e                	jne    8004f5 <vprintfmt+0x189>
  8004e7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004ea:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ed:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004f0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f3:	eb 6d                	jmp    800562 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	ff 75 d0             	pushl  -0x30(%ebp)
  8004fb:	57                   	push   %edi
  8004fc:	e8 6e 03 00 00       	call   80086f <strnlen>
  800501:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800504:	29 c1                	sub    %eax,%ecx
  800506:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800509:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80050c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800510:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800513:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800516:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800518:	eb 0f                	jmp    800529 <vprintfmt+0x1bd>
					putch(padc, putdat);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	53                   	push   %ebx
  80051e:	ff 75 e0             	pushl  -0x20(%ebp)
  800521:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	83 ef 01             	sub    $0x1,%edi
  800526:	83 c4 10             	add    $0x10,%esp
  800529:	85 ff                	test   %edi,%edi
  80052b:	7f ed                	jg     80051a <vprintfmt+0x1ae>
  80052d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800530:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800533:	85 c9                	test   %ecx,%ecx
  800535:	b8 00 00 00 00       	mov    $0x0,%eax
  80053a:	0f 49 c1             	cmovns %ecx,%eax
  80053d:	29 c1                	sub    %eax,%ecx
  80053f:	89 75 08             	mov    %esi,0x8(%ebp)
  800542:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800545:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800548:	89 cb                	mov    %ecx,%ebx
  80054a:	eb 16                	jmp    800562 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80054c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800550:	75 31                	jne    800583 <vprintfmt+0x217>
					putch(ch, putdat);
  800552:	83 ec 08             	sub    $0x8,%esp
  800555:	ff 75 0c             	pushl  0xc(%ebp)
  800558:	50                   	push   %eax
  800559:	ff 55 08             	call   *0x8(%ebp)
  80055c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80055f:	83 eb 01             	sub    $0x1,%ebx
  800562:	83 c7 01             	add    $0x1,%edi
  800565:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800569:	0f be c2             	movsbl %dl,%eax
  80056c:	85 c0                	test   %eax,%eax
  80056e:	74 59                	je     8005c9 <vprintfmt+0x25d>
  800570:	85 f6                	test   %esi,%esi
  800572:	78 d8                	js     80054c <vprintfmt+0x1e0>
  800574:	83 ee 01             	sub    $0x1,%esi
  800577:	79 d3                	jns    80054c <vprintfmt+0x1e0>
  800579:	89 df                	mov    %ebx,%edi
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800581:	eb 37                	jmp    8005ba <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800583:	0f be d2             	movsbl %dl,%edx
  800586:	83 ea 20             	sub    $0x20,%edx
  800589:	83 fa 5e             	cmp    $0x5e,%edx
  80058c:	76 c4                	jbe    800552 <vprintfmt+0x1e6>
					putch('?', putdat);
  80058e:	83 ec 08             	sub    $0x8,%esp
  800591:	ff 75 0c             	pushl  0xc(%ebp)
  800594:	6a 3f                	push   $0x3f
  800596:	ff 55 08             	call   *0x8(%ebp)
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	eb c1                	jmp    80055f <vprintfmt+0x1f3>
  80059e:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a4:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005a7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005aa:	eb b6                	jmp    800562 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 20                	push   $0x20
  8005b2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005b4:	83 ef 01             	sub    $0x1,%edi
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	85 ff                	test   %edi,%edi
  8005bc:	7f ee                	jg     8005ac <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005be:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c4:	e9 78 01 00 00       	jmp    800741 <vprintfmt+0x3d5>
  8005c9:	89 df                	mov    %ebx,%edi
  8005cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d1:	eb e7                	jmp    8005ba <vprintfmt+0x24e>
	if (lflag >= 2)
  8005d3:	83 f9 01             	cmp    $0x1,%ecx
  8005d6:	7e 3f                	jle    800617 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8b 50 04             	mov    0x4(%eax),%edx
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005e3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f3:	79 5c                	jns    800651 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	53                   	push   %ebx
  8005f9:	6a 2d                	push   $0x2d
  8005fb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800600:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800603:	f7 da                	neg    %edx
  800605:	83 d1 00             	adc    $0x0,%ecx
  800608:	f7 d9                	neg    %ecx
  80060a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800612:	e9 10 01 00 00       	jmp    800727 <vprintfmt+0x3bb>
	else if (lflag)
  800617:	85 c9                	test   %ecx,%ecx
  800619:	75 1b                	jne    800636 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8b 00                	mov    (%eax),%eax
  800620:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800623:	89 c1                	mov    %eax,%ecx
  800625:	c1 f9 1f             	sar    $0x1f,%ecx
  800628:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8d 40 04             	lea    0x4(%eax),%eax
  800631:	89 45 14             	mov    %eax,0x14(%ebp)
  800634:	eb b9                	jmp    8005ef <vprintfmt+0x283>
		return va_arg(*ap, long);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 00                	mov    (%eax),%eax
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	89 c1                	mov    %eax,%ecx
  800640:	c1 f9 1f             	sar    $0x1f,%ecx
  800643:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	8d 40 04             	lea    0x4(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
  80064f:	eb 9e                	jmp    8005ef <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800651:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800654:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800657:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065c:	e9 c6 00 00 00       	jmp    800727 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800661:	83 f9 01             	cmp    $0x1,%ecx
  800664:	7e 18                	jle    80067e <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	8b 48 04             	mov    0x4(%eax),%ecx
  80066e:	8d 40 08             	lea    0x8(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800674:	b8 0a 00 00 00       	mov    $0xa,%eax
  800679:	e9 a9 00 00 00       	jmp    800727 <vprintfmt+0x3bb>
	else if (lflag)
  80067e:	85 c9                	test   %ecx,%ecx
  800680:	75 1a                	jne    80069c <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 10                	mov    (%eax),%edx
  800687:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068c:	8d 40 04             	lea    0x4(%eax),%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800692:	b8 0a 00 00 00       	mov    $0xa,%eax
  800697:	e9 8b 00 00 00       	jmp    800727 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 10                	mov    (%eax),%edx
  8006a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b1:	eb 74                	jmp    800727 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006b3:	83 f9 01             	cmp    $0x1,%ecx
  8006b6:	7e 15                	jle    8006cd <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8b 10                	mov    (%eax),%edx
  8006bd:	8b 48 04             	mov    0x4(%eax),%ecx
  8006c0:	8d 40 08             	lea    0x8(%eax),%eax
  8006c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006cb:	eb 5a                	jmp    800727 <vprintfmt+0x3bb>
	else if (lflag)
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	75 17                	jne    8006e8 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e6:	eb 3f                	jmp    800727 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fd:	eb 28                	jmp    800727 <vprintfmt+0x3bb>
			putch('0', putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	6a 30                	push   $0x30
  800705:	ff d6                	call   *%esi
			putch('x', putdat);
  800707:	83 c4 08             	add    $0x8,%esp
  80070a:	53                   	push   %ebx
  80070b:	6a 78                	push   $0x78
  80070d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800719:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80071c:	8d 40 04             	lea    0x4(%eax),%eax
  80071f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800722:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80072e:	57                   	push   %edi
  80072f:	ff 75 e0             	pushl  -0x20(%ebp)
  800732:	50                   	push   %eax
  800733:	51                   	push   %ecx
  800734:	52                   	push   %edx
  800735:	89 da                	mov    %ebx,%edx
  800737:	89 f0                	mov    %esi,%eax
  800739:	e8 45 fb ff ff       	call   800283 <printnum>
			break;
  80073e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800741:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800744:	83 c7 01             	add    $0x1,%edi
  800747:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80074b:	83 f8 25             	cmp    $0x25,%eax
  80074e:	0f 84 2f fc ff ff    	je     800383 <vprintfmt+0x17>
			if (ch == '\0')
  800754:	85 c0                	test   %eax,%eax
  800756:	0f 84 8b 00 00 00    	je     8007e7 <vprintfmt+0x47b>
			putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	53                   	push   %ebx
  800760:	50                   	push   %eax
  800761:	ff d6                	call   *%esi
  800763:	83 c4 10             	add    $0x10,%esp
  800766:	eb dc                	jmp    800744 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800768:	83 f9 01             	cmp    $0x1,%ecx
  80076b:	7e 15                	jle    800782 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	8b 10                	mov    (%eax),%edx
  800772:	8b 48 04             	mov    0x4(%eax),%ecx
  800775:	8d 40 08             	lea    0x8(%eax),%eax
  800778:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80077b:	b8 10 00 00 00       	mov    $0x10,%eax
  800780:	eb a5                	jmp    800727 <vprintfmt+0x3bb>
	else if (lflag)
  800782:	85 c9                	test   %ecx,%ecx
  800784:	75 17                	jne    80079d <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800796:	b8 10 00 00 00       	mov    $0x10,%eax
  80079b:	eb 8a                	jmp    800727 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80079d:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a0:	8b 10                	mov    (%eax),%edx
  8007a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ad:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b2:	e9 70 ff ff ff       	jmp    800727 <vprintfmt+0x3bb>
			putch(ch, putdat);
  8007b7:	83 ec 08             	sub    $0x8,%esp
  8007ba:	53                   	push   %ebx
  8007bb:	6a 25                	push   $0x25
  8007bd:	ff d6                	call   *%esi
			break;
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	e9 7a ff ff ff       	jmp    800741 <vprintfmt+0x3d5>
			putch('%', putdat);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	6a 25                	push   $0x25
  8007cd:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	89 f8                	mov    %edi,%eax
  8007d4:	eb 03                	jmp    8007d9 <vprintfmt+0x46d>
  8007d6:	83 e8 01             	sub    $0x1,%eax
  8007d9:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007dd:	75 f7                	jne    8007d6 <vprintfmt+0x46a>
  8007df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e2:	e9 5a ff ff ff       	jmp    800741 <vprintfmt+0x3d5>
}
  8007e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ea:	5b                   	pop    %ebx
  8007eb:	5e                   	pop    %esi
  8007ec:	5f                   	pop    %edi
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	83 ec 18             	sub    $0x18,%esp
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007fe:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800802:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800805:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80080c:	85 c0                	test   %eax,%eax
  80080e:	74 26                	je     800836 <vsnprintf+0x47>
  800810:	85 d2                	test   %edx,%edx
  800812:	7e 22                	jle    800836 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800814:	ff 75 14             	pushl  0x14(%ebp)
  800817:	ff 75 10             	pushl  0x10(%ebp)
  80081a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80081d:	50                   	push   %eax
  80081e:	68 32 03 80 00       	push   $0x800332
  800823:	e8 44 fb ff ff       	call   80036c <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80082e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800831:	83 c4 10             	add    $0x10,%esp
}
  800834:	c9                   	leave  
  800835:	c3                   	ret    
		return -E_INVAL;
  800836:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80083b:	eb f7                	jmp    800834 <vsnprintf+0x45>

0080083d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80083d:	55                   	push   %ebp
  80083e:	89 e5                	mov    %esp,%ebp
  800840:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800843:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800846:	50                   	push   %eax
  800847:	ff 75 10             	pushl  0x10(%ebp)
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	ff 75 08             	pushl  0x8(%ebp)
  800850:	e8 9a ff ff ff       	call   8007ef <vsnprintf>
	va_end(ap);

	return rc;
}
  800855:	c9                   	leave  
  800856:	c3                   	ret    

00800857 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80085d:	b8 00 00 00 00       	mov    $0x0,%eax
  800862:	eb 03                	jmp    800867 <strlen+0x10>
		n++;
  800864:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800867:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80086b:	75 f7                	jne    800864 <strlen+0xd>
	return n;
}
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800875:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800878:	b8 00 00 00 00       	mov    $0x0,%eax
  80087d:	eb 03                	jmp    800882 <strnlen+0x13>
		n++;
  80087f:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800882:	39 d0                	cmp    %edx,%eax
  800884:	74 06                	je     80088c <strnlen+0x1d>
  800886:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80088a:	75 f3                	jne    80087f <strnlen+0x10>
	return n;
}
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	53                   	push   %ebx
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800898:	89 c2                	mov    %eax,%edx
  80089a:	83 c1 01             	add    $0x1,%ecx
  80089d:	83 c2 01             	add    $0x1,%edx
  8008a0:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008a4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a7:	84 db                	test   %bl,%bl
  8008a9:	75 ef                	jne    80089a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008ab:	5b                   	pop    %ebx
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	53                   	push   %ebx
  8008b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b5:	53                   	push   %ebx
  8008b6:	e8 9c ff ff ff       	call   800857 <strlen>
  8008bb:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	50                   	push   %eax
  8008c4:	e8 c5 ff ff ff       	call   80088e <strcpy>
	return dst;
}
  8008c9:	89 d8                	mov    %ebx,%eax
  8008cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	56                   	push   %esi
  8008d4:	53                   	push   %ebx
  8008d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008db:	89 f3                	mov    %esi,%ebx
  8008dd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e0:	89 f2                	mov    %esi,%edx
  8008e2:	eb 0f                	jmp    8008f3 <strncpy+0x23>
		*dst++ = *src;
  8008e4:	83 c2 01             	add    $0x1,%edx
  8008e7:	0f b6 01             	movzbl (%ecx),%eax
  8008ea:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ed:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f0:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008f3:	39 da                	cmp    %ebx,%edx
  8008f5:	75 ed                	jne    8008e4 <strncpy+0x14>
	}
	return ret;
}
  8008f7:	89 f0                	mov    %esi,%eax
  8008f9:	5b                   	pop    %ebx
  8008fa:	5e                   	pop    %esi
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    

008008fd <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	56                   	push   %esi
  800901:	53                   	push   %ebx
  800902:	8b 75 08             	mov    0x8(%ebp),%esi
  800905:	8b 55 0c             	mov    0xc(%ebp),%edx
  800908:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80090b:	89 f0                	mov    %esi,%eax
  80090d:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800911:	85 c9                	test   %ecx,%ecx
  800913:	75 0b                	jne    800920 <strlcpy+0x23>
  800915:	eb 17                	jmp    80092e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800917:	83 c2 01             	add    $0x1,%edx
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800920:	39 d8                	cmp    %ebx,%eax
  800922:	74 07                	je     80092b <strlcpy+0x2e>
  800924:	0f b6 0a             	movzbl (%edx),%ecx
  800927:	84 c9                	test   %cl,%cl
  800929:	75 ec                	jne    800917 <strlcpy+0x1a>
		*dst = '\0';
  80092b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80092e:	29 f0                	sub    %esi,%eax
}
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80093d:	eb 06                	jmp    800945 <strcmp+0x11>
		p++, q++;
  80093f:	83 c1 01             	add    $0x1,%ecx
  800942:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800945:	0f b6 01             	movzbl (%ecx),%eax
  800948:	84 c0                	test   %al,%al
  80094a:	74 04                	je     800950 <strcmp+0x1c>
  80094c:	3a 02                	cmp    (%edx),%al
  80094e:	74 ef                	je     80093f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800950:	0f b6 c0             	movzbl %al,%eax
  800953:	0f b6 12             	movzbl (%edx),%edx
  800956:	29 d0                	sub    %edx,%eax
}
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 55 0c             	mov    0xc(%ebp),%edx
  800964:	89 c3                	mov    %eax,%ebx
  800966:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800969:	eb 06                	jmp    800971 <strncmp+0x17>
		n--, p++, q++;
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800971:	39 d8                	cmp    %ebx,%eax
  800973:	74 16                	je     80098b <strncmp+0x31>
  800975:	0f b6 08             	movzbl (%eax),%ecx
  800978:	84 c9                	test   %cl,%cl
  80097a:	74 04                	je     800980 <strncmp+0x26>
  80097c:	3a 0a                	cmp    (%edx),%cl
  80097e:	74 eb                	je     80096b <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800980:	0f b6 00             	movzbl (%eax),%eax
  800983:	0f b6 12             	movzbl (%edx),%edx
  800986:	29 d0                	sub    %edx,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    
		return 0;
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
  800990:	eb f6                	jmp    800988 <strncmp+0x2e>

00800992 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80099c:	0f b6 10             	movzbl (%eax),%edx
  80099f:	84 d2                	test   %dl,%dl
  8009a1:	74 09                	je     8009ac <strchr+0x1a>
		if (*s == c)
  8009a3:	38 ca                	cmp    %cl,%dl
  8009a5:	74 0a                	je     8009b1 <strchr+0x1f>
	for (; *s; s++)
  8009a7:	83 c0 01             	add    $0x1,%eax
  8009aa:	eb f0                	jmp    80099c <strchr+0xa>
			return (char *) s;
	return 0;
  8009ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b1:	5d                   	pop    %ebp
  8009b2:	c3                   	ret    

008009b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009bd:	eb 03                	jmp    8009c2 <strfind+0xf>
  8009bf:	83 c0 01             	add    $0x1,%eax
  8009c2:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009c5:	38 ca                	cmp    %cl,%dl
  8009c7:	74 04                	je     8009cd <strfind+0x1a>
  8009c9:	84 d2                	test   %dl,%dl
  8009cb:	75 f2                	jne    8009bf <strfind+0xc>
			break;
	return (char *) s;
}
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	57                   	push   %edi
  8009d3:	56                   	push   %esi
  8009d4:	53                   	push   %ebx
  8009d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009db:	85 c9                	test   %ecx,%ecx
  8009dd:	74 13                	je     8009f2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009df:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e5:	75 05                	jne    8009ec <memset+0x1d>
  8009e7:	f6 c1 03             	test   $0x3,%cl
  8009ea:	74 0d                	je     8009f9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ef:	fc                   	cld    
  8009f0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009f2:	89 f8                	mov    %edi,%eax
  8009f4:	5b                   	pop    %ebx
  8009f5:	5e                   	pop    %esi
  8009f6:	5f                   	pop    %edi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    
		c &= 0xFF;
  8009f9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009fd:	89 d3                	mov    %edx,%ebx
  8009ff:	c1 e3 08             	shl    $0x8,%ebx
  800a02:	89 d0                	mov    %edx,%eax
  800a04:	c1 e0 18             	shl    $0x18,%eax
  800a07:	89 d6                	mov    %edx,%esi
  800a09:	c1 e6 10             	shl    $0x10,%esi
  800a0c:	09 f0                	or     %esi,%eax
  800a0e:	09 c2                	or     %eax,%edx
  800a10:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a12:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	fc                   	cld    
  800a18:	f3 ab                	rep stos %eax,%es:(%edi)
  800a1a:	eb d6                	jmp    8009f2 <memset+0x23>

00800a1c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	57                   	push   %edi
  800a20:	56                   	push   %esi
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a2a:	39 c6                	cmp    %eax,%esi
  800a2c:	73 35                	jae    800a63 <memmove+0x47>
  800a2e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a31:	39 c2                	cmp    %eax,%edx
  800a33:	76 2e                	jbe    800a63 <memmove+0x47>
		s += n;
		d += n;
  800a35:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a38:	89 d6                	mov    %edx,%esi
  800a3a:	09 fe                	or     %edi,%esi
  800a3c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a42:	74 0c                	je     800a50 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a44:	83 ef 01             	sub    $0x1,%edi
  800a47:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a4d:	fc                   	cld    
  800a4e:	eb 21                	jmp    800a71 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a50:	f6 c1 03             	test   $0x3,%cl
  800a53:	75 ef                	jne    800a44 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a55:	83 ef 04             	sub    $0x4,%edi
  800a58:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a5b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a5e:	fd                   	std    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb ea                	jmp    800a4d <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a63:	89 f2                	mov    %esi,%edx
  800a65:	09 c2                	or     %eax,%edx
  800a67:	f6 c2 03             	test   $0x3,%dl
  800a6a:	74 09                	je     800a75 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a71:	5e                   	pop    %esi
  800a72:	5f                   	pop    %edi
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a75:	f6 c1 03             	test   $0x3,%cl
  800a78:	75 f2                	jne    800a6c <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a7a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a7d:	89 c7                	mov    %eax,%edi
  800a7f:	fc                   	cld    
  800a80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a82:	eb ed                	jmp    800a71 <memmove+0x55>

00800a84 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a87:	ff 75 10             	pushl  0x10(%ebp)
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	ff 75 08             	pushl  0x8(%ebp)
  800a90:	e8 87 ff ff ff       	call   800a1c <memmove>
}
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa2:	89 c6                	mov    %eax,%esi
  800aa4:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa7:	39 f0                	cmp    %esi,%eax
  800aa9:	74 1c                	je     800ac7 <memcmp+0x30>
		if (*s1 != *s2)
  800aab:	0f b6 08             	movzbl (%eax),%ecx
  800aae:	0f b6 1a             	movzbl (%edx),%ebx
  800ab1:	38 d9                	cmp    %bl,%cl
  800ab3:	75 08                	jne    800abd <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ab5:	83 c0 01             	add    $0x1,%eax
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	eb ea                	jmp    800aa7 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800abd:	0f b6 c1             	movzbl %cl,%eax
  800ac0:	0f b6 db             	movzbl %bl,%ebx
  800ac3:	29 d8                	sub    %ebx,%eax
  800ac5:	eb 05                	jmp    800acc <memcmp+0x35>
	}

	return 0;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acc:	5b                   	pop    %ebx
  800acd:	5e                   	pop    %esi
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad9:	89 c2                	mov    %eax,%edx
  800adb:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ade:	39 d0                	cmp    %edx,%eax
  800ae0:	73 09                	jae    800aeb <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae2:	38 08                	cmp    %cl,(%eax)
  800ae4:	74 05                	je     800aeb <memfind+0x1b>
	for (; s < ends; s++)
  800ae6:	83 c0 01             	add    $0x1,%eax
  800ae9:	eb f3                	jmp    800ade <memfind+0xe>
			break;
	return (void *) s;
}
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	57                   	push   %edi
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
  800af3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af9:	eb 03                	jmp    800afe <strtol+0x11>
		s++;
  800afb:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800afe:	0f b6 01             	movzbl (%ecx),%eax
  800b01:	3c 20                	cmp    $0x20,%al
  800b03:	74 f6                	je     800afb <strtol+0xe>
  800b05:	3c 09                	cmp    $0x9,%al
  800b07:	74 f2                	je     800afb <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b09:	3c 2b                	cmp    $0x2b,%al
  800b0b:	74 2e                	je     800b3b <strtol+0x4e>
	int neg = 0;
  800b0d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b12:	3c 2d                	cmp    $0x2d,%al
  800b14:	74 2f                	je     800b45 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b16:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b1c:	75 05                	jne    800b23 <strtol+0x36>
  800b1e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b21:	74 2c                	je     800b4f <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b23:	85 db                	test   %ebx,%ebx
  800b25:	75 0a                	jne    800b31 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b27:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b2c:	80 39 30             	cmpb   $0x30,(%ecx)
  800b2f:	74 28                	je     800b59 <strtol+0x6c>
		base = 10;
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b39:	eb 50                	jmp    800b8b <strtol+0x9e>
		s++;
  800b3b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b3e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b43:	eb d1                	jmp    800b16 <strtol+0x29>
		s++, neg = 1;
  800b45:	83 c1 01             	add    $0x1,%ecx
  800b48:	bf 01 00 00 00       	mov    $0x1,%edi
  800b4d:	eb c7                	jmp    800b16 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b4f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b53:	74 0e                	je     800b63 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b55:	85 db                	test   %ebx,%ebx
  800b57:	75 d8                	jne    800b31 <strtol+0x44>
		s++, base = 8;
  800b59:	83 c1 01             	add    $0x1,%ecx
  800b5c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b61:	eb ce                	jmp    800b31 <strtol+0x44>
		s += 2, base = 16;
  800b63:	83 c1 02             	add    $0x2,%ecx
  800b66:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b6b:	eb c4                	jmp    800b31 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b6d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b70:	89 f3                	mov    %esi,%ebx
  800b72:	80 fb 19             	cmp    $0x19,%bl
  800b75:	77 29                	ja     800ba0 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b77:	0f be d2             	movsbl %dl,%edx
  800b7a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b7d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b80:	7d 30                	jge    800bb2 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b82:	83 c1 01             	add    $0x1,%ecx
  800b85:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b89:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b8b:	0f b6 11             	movzbl (%ecx),%edx
  800b8e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b91:	89 f3                	mov    %esi,%ebx
  800b93:	80 fb 09             	cmp    $0x9,%bl
  800b96:	77 d5                	ja     800b6d <strtol+0x80>
			dig = *s - '0';
  800b98:	0f be d2             	movsbl %dl,%edx
  800b9b:	83 ea 30             	sub    $0x30,%edx
  800b9e:	eb dd                	jmp    800b7d <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800ba0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ba3:	89 f3                	mov    %esi,%ebx
  800ba5:	80 fb 19             	cmp    $0x19,%bl
  800ba8:	77 08                	ja     800bb2 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800baa:	0f be d2             	movsbl %dl,%edx
  800bad:	83 ea 37             	sub    $0x37,%edx
  800bb0:	eb cb                	jmp    800b7d <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bb2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb6:	74 05                	je     800bbd <strtol+0xd0>
		*endptr = (char *) s;
  800bb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bbb:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bbd:	89 c2                	mov    %eax,%edx
  800bbf:	f7 da                	neg    %edx
  800bc1:	85 ff                	test   %edi,%edi
  800bc3:	0f 45 c2             	cmovne %edx,%eax
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5f                   	pop    %edi
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	89 c7                	mov    %eax,%edi
  800be0:	89 c6                	mov    %eax,%esi
  800be2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bef:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf4:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf9:	89 d1                	mov    %edx,%ecx
  800bfb:	89 d3                	mov    %edx,%ebx
  800bfd:	89 d7                	mov    %edx,%edi
  800bff:	89 d6                	mov    %edx,%esi
  800c01:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c11:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1e:	89 cb                	mov    %ecx,%ebx
  800c20:	89 cf                	mov    %ecx,%edi
  800c22:	89 ce                	mov    %ecx,%esi
  800c24:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7f 08                	jg     800c32 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2d:	5b                   	pop    %ebx
  800c2e:	5e                   	pop    %esi
  800c2f:	5f                   	pop    %edi
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	50                   	push   %eax
  800c36:	6a 03                	push   $0x3
  800c38:	68 1f 2d 80 00       	push   $0x802d1f
  800c3d:	6a 23                	push   $0x23
  800c3f:	68 3c 2d 80 00       	push   $0x802d3c
  800c44:	e8 4b f5 ff ff       	call   800194 <_panic>

00800c49 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c54:	b8 02 00 00 00       	mov    $0x2,%eax
  800c59:	89 d1                	mov    %edx,%ecx
  800c5b:	89 d3                	mov    %edx,%ebx
  800c5d:	89 d7                	mov    %edx,%edi
  800c5f:	89 d6                	mov    %edx,%esi
  800c61:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <sys_yield>:

void
sys_yield(void)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	57                   	push   %edi
  800c6c:	56                   	push   %esi
  800c6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c73:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c78:	89 d1                	mov    %edx,%ecx
  800c7a:	89 d3                	mov    %edx,%ebx
  800c7c:	89 d7                	mov    %edx,%edi
  800c7e:	89 d6                	mov    %edx,%esi
  800c80:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c90:	be 00 00 00 00       	mov    $0x0,%esi
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9b:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca3:	89 f7                	mov    %esi,%edi
  800ca5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca7:	85 c0                	test   %eax,%eax
  800ca9:	7f 08                	jg     800cb3 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb3:	83 ec 0c             	sub    $0xc,%esp
  800cb6:	50                   	push   %eax
  800cb7:	6a 04                	push   $0x4
  800cb9:	68 1f 2d 80 00       	push   $0x802d1f
  800cbe:	6a 23                	push   $0x23
  800cc0:	68 3c 2d 80 00       	push   $0x802d3c
  800cc5:	e8 ca f4 ff ff       	call   800194 <_panic>

00800cca <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
  800cd0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	b8 05 00 00 00       	mov    $0x5,%eax
  800cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce4:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce9:	85 c0                	test   %eax,%eax
  800ceb:	7f 08                	jg     800cf5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf0:	5b                   	pop    %ebx
  800cf1:	5e                   	pop    %esi
  800cf2:	5f                   	pop    %edi
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf5:	83 ec 0c             	sub    $0xc,%esp
  800cf8:	50                   	push   %eax
  800cf9:	6a 05                	push   $0x5
  800cfb:	68 1f 2d 80 00       	push   $0x802d1f
  800d00:	6a 23                	push   $0x23
  800d02:	68 3c 2d 80 00       	push   $0x802d3c
  800d07:	e8 88 f4 ff ff       	call   800194 <_panic>

00800d0c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	57                   	push   %edi
  800d10:	56                   	push   %esi
  800d11:	53                   	push   %ebx
  800d12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d20:	b8 06 00 00 00       	mov    $0x6,%eax
  800d25:	89 df                	mov    %ebx,%edi
  800d27:	89 de                	mov    %ebx,%esi
  800d29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	7f 08                	jg     800d37 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	83 ec 0c             	sub    $0xc,%esp
  800d3a:	50                   	push   %eax
  800d3b:	6a 06                	push   $0x6
  800d3d:	68 1f 2d 80 00       	push   $0x802d1f
  800d42:	6a 23                	push   $0x23
  800d44:	68 3c 2d 80 00       	push   $0x802d3c
  800d49:	e8 46 f4 ff ff       	call   800194 <_panic>

00800d4e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	57                   	push   %edi
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d57:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	b8 08 00 00 00       	mov    $0x8,%eax
  800d67:	89 df                	mov    %ebx,%edi
  800d69:	89 de                	mov    %ebx,%esi
  800d6b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	7f 08                	jg     800d79 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d74:	5b                   	pop    %ebx
  800d75:	5e                   	pop    %esi
  800d76:	5f                   	pop    %edi
  800d77:	5d                   	pop    %ebp
  800d78:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d79:	83 ec 0c             	sub    $0xc,%esp
  800d7c:	50                   	push   %eax
  800d7d:	6a 08                	push   $0x8
  800d7f:	68 1f 2d 80 00       	push   $0x802d1f
  800d84:	6a 23                	push   $0x23
  800d86:	68 3c 2d 80 00       	push   $0x802d3c
  800d8b:	e8 04 f4 ff ff       	call   800194 <_panic>

00800d90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 09 00 00 00       	mov    $0x9,%eax
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7f 08                	jg     800dbb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db6:	5b                   	pop    %ebx
  800db7:	5e                   	pop    %esi
  800db8:	5f                   	pop    %edi
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbb:	83 ec 0c             	sub    $0xc,%esp
  800dbe:	50                   	push   %eax
  800dbf:	6a 09                	push   $0x9
  800dc1:	68 1f 2d 80 00       	push   $0x802d1f
  800dc6:	6a 23                	push   $0x23
  800dc8:	68 3c 2d 80 00       	push   $0x802d3c
  800dcd:	e8 c2 f3 ff ff       	call   800194 <_panic>

00800dd2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	57                   	push   %edi
  800dd6:	56                   	push   %esi
  800dd7:	53                   	push   %ebx
  800dd8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800deb:	89 df                	mov    %ebx,%edi
  800ded:	89 de                	mov    %ebx,%esi
  800def:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7f 08                	jg     800dfd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfd:	83 ec 0c             	sub    $0xc,%esp
  800e00:	50                   	push   %eax
  800e01:	6a 0a                	push   $0xa
  800e03:	68 1f 2d 80 00       	push   $0x802d1f
  800e08:	6a 23                	push   $0x23
  800e0a:	68 3c 2d 80 00       	push   $0x802d3c
  800e0f:	e8 80 f3 ff ff       	call   800194 <_panic>

00800e14 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e25:	be 00 00 00 00       	mov    $0x0,%esi
  800e2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e30:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e32:	5b                   	pop    %ebx
  800e33:	5e                   	pop    %esi
  800e34:	5f                   	pop    %edi
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e4d:	89 cb                	mov    %ecx,%ebx
  800e4f:	89 cf                	mov    %ecx,%edi
  800e51:	89 ce                	mov    %ecx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 0d                	push   $0xd
  800e67:	68 1f 2d 80 00       	push   $0x802d1f
  800e6c:	6a 23                	push   $0x23
  800e6e:	68 3c 2d 80 00       	push   $0x802d3c
  800e73:	e8 1c f3 ff ff       	call   800194 <_panic>

00800e78 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e83:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e88:	89 d1                	mov    %edx,%ecx
  800e8a:	89 d3                	mov    %edx,%ebx
  800e8c:	89 d7                	mov    %edx,%edi
  800e8e:	89 d6                	mov    %edx,%esi
  800e90:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5f                   	pop    %edi
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9d:	05 00 00 00 30       	add    $0x30000000,%eax
  800ea2:	c1 e8 0c             	shr    $0xc,%eax
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800eb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eb7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ebc:	5d                   	pop    %ebp
  800ebd:	c3                   	ret    

00800ebe <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ec9:	89 c2                	mov    %eax,%edx
  800ecb:	c1 ea 16             	shr    $0x16,%edx
  800ece:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ed5:	f6 c2 01             	test   $0x1,%dl
  800ed8:	74 2a                	je     800f04 <fd_alloc+0x46>
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	c1 ea 0c             	shr    $0xc,%edx
  800edf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ee6:	f6 c2 01             	test   $0x1,%dl
  800ee9:	74 19                	je     800f04 <fd_alloc+0x46>
  800eeb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ef0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ef5:	75 d2                	jne    800ec9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ef7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800efd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f02:	eb 07                	jmp    800f0b <fd_alloc+0x4d>
			*fd_store = fd;
  800f04:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f13:	83 f8 1f             	cmp    $0x1f,%eax
  800f16:	77 36                	ja     800f4e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f18:	c1 e0 0c             	shl    $0xc,%eax
  800f1b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f20:	89 c2                	mov    %eax,%edx
  800f22:	c1 ea 16             	shr    $0x16,%edx
  800f25:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f2c:	f6 c2 01             	test   $0x1,%dl
  800f2f:	74 24                	je     800f55 <fd_lookup+0x48>
  800f31:	89 c2                	mov    %eax,%edx
  800f33:	c1 ea 0c             	shr    $0xc,%edx
  800f36:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3d:	f6 c2 01             	test   $0x1,%dl
  800f40:	74 1a                	je     800f5c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	89 02                	mov    %eax,(%edx)
	return 0;
  800f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    
		return -E_INVAL;
  800f4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f53:	eb f7                	jmp    800f4c <fd_lookup+0x3f>
		return -E_INVAL;
  800f55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5a:	eb f0                	jmp    800f4c <fd_lookup+0x3f>
  800f5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f61:	eb e9                	jmp    800f4c <fd_lookup+0x3f>

00800f63 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f6c:	ba c8 2d 80 00       	mov    $0x802dc8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f71:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f76:	39 08                	cmp    %ecx,(%eax)
  800f78:	74 33                	je     800fad <dev_lookup+0x4a>
  800f7a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f7d:	8b 02                	mov    (%edx),%eax
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	75 f3                	jne    800f76 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f83:	a1 08 40 80 00       	mov    0x804008,%eax
  800f88:	8b 40 48             	mov    0x48(%eax),%eax
  800f8b:	83 ec 04             	sub    $0x4,%esp
  800f8e:	51                   	push   %ecx
  800f8f:	50                   	push   %eax
  800f90:	68 4c 2d 80 00       	push   $0x802d4c
  800f95:	e8 d5 f2 ff ff       	call   80026f <cprintf>
	*dev = 0;
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fa3:	83 c4 10             	add    $0x10,%esp
  800fa6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    
			*dev = devtab[i];
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb7:	eb f2                	jmp    800fab <dev_lookup+0x48>

00800fb9 <fd_close>:
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 1c             	sub    $0x1c,%esp
  800fc2:	8b 75 08             	mov    0x8(%ebp),%esi
  800fc5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fc8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fcb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fcc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fd2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd5:	50                   	push   %eax
  800fd6:	e8 32 ff ff ff       	call   800f0d <fd_lookup>
  800fdb:	89 c3                	mov    %eax,%ebx
  800fdd:	83 c4 08             	add    $0x8,%esp
  800fe0:	85 c0                	test   %eax,%eax
  800fe2:	78 05                	js     800fe9 <fd_close+0x30>
	    || fd != fd2)
  800fe4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800fe7:	74 16                	je     800fff <fd_close+0x46>
		return (must_exist ? r : 0);
  800fe9:	89 f8                	mov    %edi,%eax
  800feb:	84 c0                	test   %al,%al
  800fed:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff2:	0f 44 d8             	cmove  %eax,%ebx
}
  800ff5:	89 d8                	mov    %ebx,%eax
  800ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fff:	83 ec 08             	sub    $0x8,%esp
  801002:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801005:	50                   	push   %eax
  801006:	ff 36                	pushl  (%esi)
  801008:	e8 56 ff ff ff       	call   800f63 <dev_lookup>
  80100d:	89 c3                	mov    %eax,%ebx
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	85 c0                	test   %eax,%eax
  801014:	78 15                	js     80102b <fd_close+0x72>
		if (dev->dev_close)
  801016:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801019:	8b 40 10             	mov    0x10(%eax),%eax
  80101c:	85 c0                	test   %eax,%eax
  80101e:	74 1b                	je     80103b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801020:	83 ec 0c             	sub    $0xc,%esp
  801023:	56                   	push   %esi
  801024:	ff d0                	call   *%eax
  801026:	89 c3                	mov    %eax,%ebx
  801028:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	56                   	push   %esi
  80102f:	6a 00                	push   $0x0
  801031:	e8 d6 fc ff ff       	call   800d0c <sys_page_unmap>
	return r;
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	eb ba                	jmp    800ff5 <fd_close+0x3c>
			r = 0;
  80103b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801040:	eb e9                	jmp    80102b <fd_close+0x72>

00801042 <close>:

int
close(int fdnum)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801048:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80104b:	50                   	push   %eax
  80104c:	ff 75 08             	pushl  0x8(%ebp)
  80104f:	e8 b9 fe ff ff       	call   800f0d <fd_lookup>
  801054:	83 c4 08             	add    $0x8,%esp
  801057:	85 c0                	test   %eax,%eax
  801059:	78 10                	js     80106b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80105b:	83 ec 08             	sub    $0x8,%esp
  80105e:	6a 01                	push   $0x1
  801060:	ff 75 f4             	pushl  -0xc(%ebp)
  801063:	e8 51 ff ff ff       	call   800fb9 <fd_close>
  801068:	83 c4 10             	add    $0x10,%esp
}
  80106b:	c9                   	leave  
  80106c:	c3                   	ret    

0080106d <close_all>:

void
close_all(void)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	53                   	push   %ebx
  801071:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801074:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	53                   	push   %ebx
  80107d:	e8 c0 ff ff ff       	call   801042 <close>
	for (i = 0; i < MAXFD; i++)
  801082:	83 c3 01             	add    $0x1,%ebx
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	83 fb 20             	cmp    $0x20,%ebx
  80108b:	75 ec                	jne    801079 <close_all+0xc>
}
  80108d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	57                   	push   %edi
  801096:	56                   	push   %esi
  801097:	53                   	push   %ebx
  801098:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80109b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 08             	pushl  0x8(%ebp)
  8010a2:	e8 66 fe ff ff       	call   800f0d <fd_lookup>
  8010a7:	89 c3                	mov    %eax,%ebx
  8010a9:	83 c4 08             	add    $0x8,%esp
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	0f 88 81 00 00 00    	js     801135 <dup+0xa3>
		return r;
	close(newfdnum);
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ba:	e8 83 ff ff ff       	call   801042 <close>

	newfd = INDEX2FD(newfdnum);
  8010bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010c2:	c1 e6 0c             	shl    $0xc,%esi
  8010c5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010cb:	83 c4 04             	add    $0x4,%esp
  8010ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d1:	e8 d1 fd ff ff       	call   800ea7 <fd2data>
  8010d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010d8:	89 34 24             	mov    %esi,(%esp)
  8010db:	e8 c7 fd ff ff       	call   800ea7 <fd2data>
  8010e0:	83 c4 10             	add    $0x10,%esp
  8010e3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010e5:	89 d8                	mov    %ebx,%eax
  8010e7:	c1 e8 16             	shr    $0x16,%eax
  8010ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010f1:	a8 01                	test   $0x1,%al
  8010f3:	74 11                	je     801106 <dup+0x74>
  8010f5:	89 d8                	mov    %ebx,%eax
  8010f7:	c1 e8 0c             	shr    $0xc,%eax
  8010fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801101:	f6 c2 01             	test   $0x1,%dl
  801104:	75 39                	jne    80113f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801106:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801109:	89 d0                	mov    %edx,%eax
  80110b:	c1 e8 0c             	shr    $0xc,%eax
  80110e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801115:	83 ec 0c             	sub    $0xc,%esp
  801118:	25 07 0e 00 00       	and    $0xe07,%eax
  80111d:	50                   	push   %eax
  80111e:	56                   	push   %esi
  80111f:	6a 00                	push   $0x0
  801121:	52                   	push   %edx
  801122:	6a 00                	push   $0x0
  801124:	e8 a1 fb ff ff       	call   800cca <sys_page_map>
  801129:	89 c3                	mov    %eax,%ebx
  80112b:	83 c4 20             	add    $0x20,%esp
  80112e:	85 c0                	test   %eax,%eax
  801130:	78 31                	js     801163 <dup+0xd1>
		goto err;

	return newfdnum;
  801132:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801135:	89 d8                	mov    %ebx,%eax
  801137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5f                   	pop    %edi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80113f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801146:	83 ec 0c             	sub    $0xc,%esp
  801149:	25 07 0e 00 00       	and    $0xe07,%eax
  80114e:	50                   	push   %eax
  80114f:	57                   	push   %edi
  801150:	6a 00                	push   $0x0
  801152:	53                   	push   %ebx
  801153:	6a 00                	push   $0x0
  801155:	e8 70 fb ff ff       	call   800cca <sys_page_map>
  80115a:	89 c3                	mov    %eax,%ebx
  80115c:	83 c4 20             	add    $0x20,%esp
  80115f:	85 c0                	test   %eax,%eax
  801161:	79 a3                	jns    801106 <dup+0x74>
	sys_page_unmap(0, newfd);
  801163:	83 ec 08             	sub    $0x8,%esp
  801166:	56                   	push   %esi
  801167:	6a 00                	push   $0x0
  801169:	e8 9e fb ff ff       	call   800d0c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80116e:	83 c4 08             	add    $0x8,%esp
  801171:	57                   	push   %edi
  801172:	6a 00                	push   $0x0
  801174:	e8 93 fb ff ff       	call   800d0c <sys_page_unmap>
	return r;
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	eb b7                	jmp    801135 <dup+0xa3>

0080117e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	53                   	push   %ebx
  801182:	83 ec 14             	sub    $0x14,%esp
  801185:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801188:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80118b:	50                   	push   %eax
  80118c:	53                   	push   %ebx
  80118d:	e8 7b fd ff ff       	call   800f0d <fd_lookup>
  801192:	83 c4 08             	add    $0x8,%esp
  801195:	85 c0                	test   %eax,%eax
  801197:	78 3f                	js     8011d8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119f:	50                   	push   %eax
  8011a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a3:	ff 30                	pushl  (%eax)
  8011a5:	e8 b9 fd ff ff       	call   800f63 <dev_lookup>
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	78 27                	js     8011d8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b4:	8b 42 08             	mov    0x8(%edx),%eax
  8011b7:	83 e0 03             	and    $0x3,%eax
  8011ba:	83 f8 01             	cmp    $0x1,%eax
  8011bd:	74 1e                	je     8011dd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c2:	8b 40 08             	mov    0x8(%eax),%eax
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	74 35                	je     8011fe <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011c9:	83 ec 04             	sub    $0x4,%esp
  8011cc:	ff 75 10             	pushl  0x10(%ebp)
  8011cf:	ff 75 0c             	pushl  0xc(%ebp)
  8011d2:	52                   	push   %edx
  8011d3:	ff d0                	call   *%eax
  8011d5:	83 c4 10             	add    $0x10,%esp
}
  8011d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8011e2:	8b 40 48             	mov    0x48(%eax),%eax
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	53                   	push   %ebx
  8011e9:	50                   	push   %eax
  8011ea:	68 8d 2d 80 00       	push   $0x802d8d
  8011ef:	e8 7b f0 ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fc:	eb da                	jmp    8011d8 <read+0x5a>
		return -E_NOT_SUPP;
  8011fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801203:	eb d3                	jmp    8011d8 <read+0x5a>

00801205 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	57                   	push   %edi
  801209:	56                   	push   %esi
  80120a:	53                   	push   %ebx
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801211:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801214:	bb 00 00 00 00       	mov    $0x0,%ebx
  801219:	39 f3                	cmp    %esi,%ebx
  80121b:	73 25                	jae    801242 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	89 f0                	mov    %esi,%eax
  801222:	29 d8                	sub    %ebx,%eax
  801224:	50                   	push   %eax
  801225:	89 d8                	mov    %ebx,%eax
  801227:	03 45 0c             	add    0xc(%ebp),%eax
  80122a:	50                   	push   %eax
  80122b:	57                   	push   %edi
  80122c:	e8 4d ff ff ff       	call   80117e <read>
		if (m < 0)
  801231:	83 c4 10             	add    $0x10,%esp
  801234:	85 c0                	test   %eax,%eax
  801236:	78 08                	js     801240 <readn+0x3b>
			return m;
		if (m == 0)
  801238:	85 c0                	test   %eax,%eax
  80123a:	74 06                	je     801242 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80123c:	01 c3                	add    %eax,%ebx
  80123e:	eb d9                	jmp    801219 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801240:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801242:	89 d8                	mov    %ebx,%eax
  801244:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801247:	5b                   	pop    %ebx
  801248:	5e                   	pop    %esi
  801249:	5f                   	pop    %edi
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	53                   	push   %ebx
  801250:	83 ec 14             	sub    $0x14,%esp
  801253:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801256:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801259:	50                   	push   %eax
  80125a:	53                   	push   %ebx
  80125b:	e8 ad fc ff ff       	call   800f0d <fd_lookup>
  801260:	83 c4 08             	add    $0x8,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	78 3a                	js     8012a1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80126d:	50                   	push   %eax
  80126e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801271:	ff 30                	pushl  (%eax)
  801273:	e8 eb fc ff ff       	call   800f63 <dev_lookup>
  801278:	83 c4 10             	add    $0x10,%esp
  80127b:	85 c0                	test   %eax,%eax
  80127d:	78 22                	js     8012a1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80127f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801282:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801286:	74 1e                	je     8012a6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801288:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128b:	8b 52 0c             	mov    0xc(%edx),%edx
  80128e:	85 d2                	test   %edx,%edx
  801290:	74 35                	je     8012c7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801292:	83 ec 04             	sub    $0x4,%esp
  801295:	ff 75 10             	pushl  0x10(%ebp)
  801298:	ff 75 0c             	pushl  0xc(%ebp)
  80129b:	50                   	push   %eax
  80129c:	ff d2                	call   *%edx
  80129e:	83 c4 10             	add    $0x10,%esp
}
  8012a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012a6:	a1 08 40 80 00       	mov    0x804008,%eax
  8012ab:	8b 40 48             	mov    0x48(%eax),%eax
  8012ae:	83 ec 04             	sub    $0x4,%esp
  8012b1:	53                   	push   %ebx
  8012b2:	50                   	push   %eax
  8012b3:	68 a9 2d 80 00       	push   $0x802da9
  8012b8:	e8 b2 ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  8012bd:	83 c4 10             	add    $0x10,%esp
  8012c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c5:	eb da                	jmp    8012a1 <write+0x55>
		return -E_NOT_SUPP;
  8012c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012cc:	eb d3                	jmp    8012a1 <write+0x55>

008012ce <seek>:

int
seek(int fdnum, off_t offset)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012d4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 2d fc ff ff       	call   800f0d <fd_lookup>
  8012e0:	83 c4 08             	add    $0x8,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 0e                	js     8012f5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	53                   	push   %ebx
  8012fb:	83 ec 14             	sub    $0x14,%esp
  8012fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801301:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	53                   	push   %ebx
  801306:	e8 02 fc ff ff       	call   800f0d <fd_lookup>
  80130b:	83 c4 08             	add    $0x8,%esp
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 37                	js     801349 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801318:	50                   	push   %eax
  801319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131c:	ff 30                	pushl  (%eax)
  80131e:	e8 40 fc ff ff       	call   800f63 <dev_lookup>
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	78 1f                	js     801349 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80132a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80132d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801331:	74 1b                	je     80134e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801336:	8b 52 18             	mov    0x18(%edx),%edx
  801339:	85 d2                	test   %edx,%edx
  80133b:	74 32                	je     80136f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80133d:	83 ec 08             	sub    $0x8,%esp
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	50                   	push   %eax
  801344:	ff d2                	call   *%edx
  801346:	83 c4 10             	add    $0x10,%esp
}
  801349:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80134e:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801353:	8b 40 48             	mov    0x48(%eax),%eax
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	53                   	push   %ebx
  80135a:	50                   	push   %eax
  80135b:	68 6c 2d 80 00       	push   $0x802d6c
  801360:	e8 0a ef ff ff       	call   80026f <cprintf>
		return -E_INVAL;
  801365:	83 c4 10             	add    $0x10,%esp
  801368:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80136d:	eb da                	jmp    801349 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80136f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801374:	eb d3                	jmp    801349 <ftruncate+0x52>

00801376 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	53                   	push   %ebx
  80137a:	83 ec 14             	sub    $0x14,%esp
  80137d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801380:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	ff 75 08             	pushl  0x8(%ebp)
  801387:	e8 81 fb ff ff       	call   800f0d <fd_lookup>
  80138c:	83 c4 08             	add    $0x8,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	78 4b                	js     8013de <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801393:	83 ec 08             	sub    $0x8,%esp
  801396:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801399:	50                   	push   %eax
  80139a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139d:	ff 30                	pushl  (%eax)
  80139f:	e8 bf fb ff ff       	call   800f63 <dev_lookup>
  8013a4:	83 c4 10             	add    $0x10,%esp
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	78 33                	js     8013de <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ae:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013b2:	74 2f                	je     8013e3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013b4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013b7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013be:	00 00 00 
	stat->st_isdir = 0;
  8013c1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013c8:	00 00 00 
	stat->st_dev = dev;
  8013cb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013d1:	83 ec 08             	sub    $0x8,%esp
  8013d4:	53                   	push   %ebx
  8013d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8013d8:	ff 50 14             	call   *0x14(%eax)
  8013db:	83 c4 10             	add    $0x10,%esp
}
  8013de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    
		return -E_NOT_SUPP;
  8013e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e8:	eb f4                	jmp    8013de <fstat+0x68>

008013ea <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	56                   	push   %esi
  8013ee:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013ef:	83 ec 08             	sub    $0x8,%esp
  8013f2:	6a 00                	push   $0x0
  8013f4:	ff 75 08             	pushl  0x8(%ebp)
  8013f7:	e8 e7 01 00 00       	call   8015e3 <open>
  8013fc:	89 c3                	mov    %eax,%ebx
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 1b                	js     801420 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801405:	83 ec 08             	sub    $0x8,%esp
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	50                   	push   %eax
  80140c:	e8 65 ff ff ff       	call   801376 <fstat>
  801411:	89 c6                	mov    %eax,%esi
	close(fd);
  801413:	89 1c 24             	mov    %ebx,(%esp)
  801416:	e8 27 fc ff ff       	call   801042 <close>
	return r;
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 f3                	mov    %esi,%ebx
}
  801420:	89 d8                	mov    %ebx,%eax
  801422:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801425:	5b                   	pop    %ebx
  801426:	5e                   	pop    %esi
  801427:	5d                   	pop    %ebp
  801428:	c3                   	ret    

00801429 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	56                   	push   %esi
  80142d:	53                   	push   %ebx
  80142e:	89 c6                	mov    %eax,%esi
  801430:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801432:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801439:	74 27                	je     801462 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80143b:	6a 07                	push   $0x7
  80143d:	68 00 50 80 00       	push   $0x805000
  801442:	56                   	push   %esi
  801443:	ff 35 00 40 80 00    	pushl  0x804000
  801449:	e8 c7 11 00 00       	call   802615 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80144e:	83 c4 0c             	add    $0xc,%esp
  801451:	6a 00                	push   $0x0
  801453:	53                   	push   %ebx
  801454:	6a 00                	push   $0x0
  801456:	e8 53 11 00 00       	call   8025ae <ipc_recv>
}
  80145b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5d                   	pop    %ebp
  801461:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801462:	83 ec 0c             	sub    $0xc,%esp
  801465:	6a 01                	push   $0x1
  801467:	e8 fd 11 00 00       	call   802669 <ipc_find_env>
  80146c:	a3 00 40 80 00       	mov    %eax,0x804000
  801471:	83 c4 10             	add    $0x10,%esp
  801474:	eb c5                	jmp    80143b <fsipc+0x12>

00801476 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	8b 40 0c             	mov    0xc(%eax),%eax
  801482:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148a:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80148f:	ba 00 00 00 00       	mov    $0x0,%edx
  801494:	b8 02 00 00 00       	mov    $0x2,%eax
  801499:	e8 8b ff ff ff       	call   801429 <fsipc>
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <devfile_flush>:
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ac:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8014bb:	e8 69 ff ff ff       	call   801429 <fsipc>
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <devfile_stat>:
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d2:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8014e1:	e8 43 ff ff ff       	call   801429 <fsipc>
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 2c                	js     801516 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014ea:	83 ec 08             	sub    $0x8,%esp
  8014ed:	68 00 50 80 00       	push   $0x805000
  8014f2:	53                   	push   %ebx
  8014f3:	e8 96 f3 ff ff       	call   80088e <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014f8:	a1 80 50 80 00       	mov    0x805080,%eax
  8014fd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801503:	a1 84 50 80 00       	mov    0x805084,%eax
  801508:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <devfile_write>:
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 0c             	sub    $0xc,%esp
  801521:	8b 45 10             	mov    0x10(%ebp),%eax
  801524:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801529:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80152e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	8b 52 0c             	mov    0xc(%edx),%edx
  801537:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80153d:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801542:	50                   	push   %eax
  801543:	ff 75 0c             	pushl  0xc(%ebp)
  801546:	68 08 50 80 00       	push   $0x805008
  80154b:	e8 cc f4 ff ff       	call   800a1c <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801550:	ba 00 00 00 00       	mov    $0x0,%edx
  801555:	b8 04 00 00 00       	mov    $0x4,%eax
  80155a:	e8 ca fe ff ff       	call   801429 <fsipc>
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <devfile_read>:
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	56                   	push   %esi
  801565:	53                   	push   %ebx
  801566:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8b 40 0c             	mov    0xc(%eax),%eax
  80156f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801574:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	b8 03 00 00 00       	mov    $0x3,%eax
  801584:	e8 a0 fe ff ff       	call   801429 <fsipc>
  801589:	89 c3                	mov    %eax,%ebx
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 1f                	js     8015ae <devfile_read+0x4d>
	assert(r <= n);
  80158f:	39 f0                	cmp    %esi,%eax
  801591:	77 24                	ja     8015b7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801593:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801598:	7f 33                	jg     8015cd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80159a:	83 ec 04             	sub    $0x4,%esp
  80159d:	50                   	push   %eax
  80159e:	68 00 50 80 00       	push   $0x805000
  8015a3:	ff 75 0c             	pushl  0xc(%ebp)
  8015a6:	e8 71 f4 ff ff       	call   800a1c <memmove>
	return r;
  8015ab:	83 c4 10             	add    $0x10,%esp
}
  8015ae:	89 d8                	mov    %ebx,%eax
  8015b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b3:	5b                   	pop    %ebx
  8015b4:	5e                   	pop    %esi
  8015b5:	5d                   	pop    %ebp
  8015b6:	c3                   	ret    
	assert(r <= n);
  8015b7:	68 dc 2d 80 00       	push   $0x802ddc
  8015bc:	68 e3 2d 80 00       	push   $0x802de3
  8015c1:	6a 7b                	push   $0x7b
  8015c3:	68 f8 2d 80 00       	push   $0x802df8
  8015c8:	e8 c7 eb ff ff       	call   800194 <_panic>
	assert(r <= PGSIZE);
  8015cd:	68 03 2e 80 00       	push   $0x802e03
  8015d2:	68 e3 2d 80 00       	push   $0x802de3
  8015d7:	6a 7c                	push   $0x7c
  8015d9:	68 f8 2d 80 00       	push   $0x802df8
  8015de:	e8 b1 eb ff ff       	call   800194 <_panic>

008015e3 <open>:
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	56                   	push   %esi
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 1c             	sub    $0x1c,%esp
  8015eb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015ee:	56                   	push   %esi
  8015ef:	e8 63 f2 ff ff       	call   800857 <strlen>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015fc:	7f 6c                	jg     80166a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	e8 b4 f8 ff ff       	call   800ebe <fd_alloc>
  80160a:	89 c3                	mov    %eax,%ebx
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	85 c0                	test   %eax,%eax
  801611:	78 3c                	js     80164f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801613:	83 ec 08             	sub    $0x8,%esp
  801616:	56                   	push   %esi
  801617:	68 00 50 80 00       	push   $0x805000
  80161c:	e8 6d f2 ff ff       	call   80088e <strcpy>
	fsipcbuf.open.req_omode = mode;
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162c:	b8 01 00 00 00       	mov    $0x1,%eax
  801631:	e8 f3 fd ff ff       	call   801429 <fsipc>
  801636:	89 c3                	mov    %eax,%ebx
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 19                	js     801658 <open+0x75>
	return fd2num(fd);
  80163f:	83 ec 0c             	sub    $0xc,%esp
  801642:	ff 75 f4             	pushl  -0xc(%ebp)
  801645:	e8 4d f8 ff ff       	call   800e97 <fd2num>
  80164a:	89 c3                	mov    %eax,%ebx
  80164c:	83 c4 10             	add    $0x10,%esp
}
  80164f:	89 d8                	mov    %ebx,%eax
  801651:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5d                   	pop    %ebp
  801657:	c3                   	ret    
		fd_close(fd, 0);
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	6a 00                	push   $0x0
  80165d:	ff 75 f4             	pushl  -0xc(%ebp)
  801660:	e8 54 f9 ff ff       	call   800fb9 <fd_close>
		return r;
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	eb e5                	jmp    80164f <open+0x6c>
		return -E_BAD_PATH;
  80166a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80166f:	eb de                	jmp    80164f <open+0x6c>

00801671 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
  801674:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	b8 08 00 00 00       	mov    $0x8,%eax
  801681:	e8 a3 fd ff ff       	call   801429 <fsipc>
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <spawn>:
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int spawn(const char *prog, const char **argv)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	57                   	push   %edi
  80168c:	56                   	push   %esi
  80168d:	53                   	push   %ebx
  80168e:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801694:	6a 00                	push   $0x0
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 45 ff ff ff       	call   8015e3 <open>
  80169e:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	0f 88 40 03 00 00    	js     8019ef <spawn+0x367>
  8016af:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *)elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) || elf->e_magic != ELF_MAGIC)
  8016b1:	83 ec 04             	sub    $0x4,%esp
  8016b4:	68 00 02 00 00       	push   $0x200
  8016b9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	51                   	push   %ecx
  8016c1:	e8 3f fb ff ff       	call   801205 <readn>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8016ce:	75 5d                	jne    80172d <spawn+0xa5>
  8016d0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8016d7:	45 4c 46 
  8016da:	75 51                	jne    80172d <spawn+0xa5>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8016dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8016e1:	cd 30                	int    $0x30
  8016e3:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8016e9:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	0f 88 62 04 00 00    	js     801b59 <spawn+0x4d1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8016f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8016fc:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8016ff:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801705:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80170b:	b9 11 00 00 00       	mov    $0x11,%ecx
  801710:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801712:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801718:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80171e:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801723:	be 00 00 00 00       	mov    $0x0,%esi
  801728:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80172b:	eb 4b                	jmp    801778 <spawn+0xf0>
		close(fd);
  80172d:	83 ec 0c             	sub    $0xc,%esp
  801730:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801736:	e8 07 f9 ff ff       	call   801042 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80173b:	83 c4 0c             	add    $0xc,%esp
  80173e:	68 7f 45 4c 46       	push   $0x464c457f
  801743:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801749:	68 0f 2e 80 00       	push   $0x802e0f
  80174e:	e8 1c eb ff ff       	call   80026f <cprintf>
		return -E_NOT_EXEC;
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  80175d:	ff ff ff 
  801760:	e9 8a 02 00 00       	jmp    8019ef <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801765:	83 ec 0c             	sub    $0xc,%esp
  801768:	50                   	push   %eax
  801769:	e8 e9 f0 ff ff       	call   800857 <strlen>
  80176e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801772:	83 c3 01             	add    $0x1,%ebx
  801775:	83 c4 10             	add    $0x10,%esp
  801778:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80177f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801782:	85 c0                	test   %eax,%eax
  801784:	75 df                	jne    801765 <spawn+0xdd>
  801786:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  80178c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *)UTEMP + PGSIZE - string_size;
  801792:	bf 00 10 40 00       	mov    $0x401000,%edi
  801797:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *)(ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801799:	89 fa                	mov    %edi,%edx
  80179b:	83 e2 fc             	and    $0xfffffffc,%edx
  80179e:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8017a5:	29 c2                	sub    %eax,%edx
  8017a7:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *)(argv_store - 2) < (void *)UTEMP)
  8017ad:	8d 42 f8             	lea    -0x8(%edx),%eax
  8017b0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8017b5:	0f 86 af 03 00 00    	jbe    801b6a <spawn+0x4e2>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	6a 07                	push   $0x7
  8017c0:	68 00 00 40 00       	push   $0x400000
  8017c5:	6a 00                	push   $0x0
  8017c7:	e8 bb f4 ff ff       	call   800c87 <sys_page_alloc>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	0f 88 98 03 00 00    	js     801b6f <spawn+0x4e7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++)
  8017d7:	be 00 00 00 00       	mov    $0x0,%esi
  8017dc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8017e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017e5:	eb 30                	jmp    801817 <spawn+0x18f>
	{
		argv_store[i] = UTEMP2USTACK(string_store);
  8017e7:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8017ed:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8017f3:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8017f6:	83 ec 08             	sub    $0x8,%esp
  8017f9:	ff 34 b3             	pushl  (%ebx,%esi,4)
  8017fc:	57                   	push   %edi
  8017fd:	e8 8c f0 ff ff       	call   80088e <strcpy>
		string_store += strlen(argv[i]) + 1;
  801802:	83 c4 04             	add    $0x4,%esp
  801805:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801808:	e8 4a f0 ff ff       	call   800857 <strlen>
  80180d:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++)
  801811:	83 c6 01             	add    $0x1,%esi
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80181d:	7f c8                	jg     8017e7 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  80181f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801825:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  80182b:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *)UTEMP + PGSIZE);
  801832:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801838:	0f 85 8c 00 00 00    	jne    8018ca <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80183e:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801844:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  80184a:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  80184d:	89 f8                	mov    %edi,%eax
  80184f:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801855:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801858:	2d 08 30 80 11       	sub    $0x11803008,%eax
  80185d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void *)(USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801863:	83 ec 0c             	sub    $0xc,%esp
  801866:	6a 07                	push   $0x7
  801868:	68 00 d0 bf ee       	push   $0xeebfd000
  80186d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801873:	68 00 00 40 00       	push   $0x400000
  801878:	6a 00                	push   $0x0
  80187a:	e8 4b f4 ff ff       	call   800cca <sys_page_map>
  80187f:	89 c3                	mov    %eax,%ebx
  801881:	83 c4 20             	add    $0x20,%esp
  801884:	85 c0                	test   %eax,%eax
  801886:	0f 88 59 03 00 00    	js     801be5 <spawn+0x55d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80188c:	83 ec 08             	sub    $0x8,%esp
  80188f:	68 00 00 40 00       	push   $0x400000
  801894:	6a 00                	push   $0x0
  801896:	e8 71 f4 ff ff       	call   800d0c <sys_page_unmap>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	0f 88 3d 03 00 00    	js     801be5 <spawn+0x55d>
	ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  8018a8:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8018ae:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8018b5:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++)
  8018bb:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8018c2:	00 00 00 
  8018c5:	e9 56 01 00 00       	jmp    801a20 <spawn+0x398>
	assert(string_store == (char *)UTEMP + PGSIZE);
  8018ca:	68 9c 2e 80 00       	push   $0x802e9c
  8018cf:	68 e3 2d 80 00       	push   $0x802de3
  8018d4:	68 f0 00 00 00       	push   $0xf0
  8018d9:	68 29 2e 80 00       	push   $0x802e29
  8018de:	e8 b1 e8 ff ff       	call   800194 <_panic>
				return r;
		}
		else
		{
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8018e3:	83 ec 04             	sub    $0x4,%esp
  8018e6:	6a 07                	push   $0x7
  8018e8:	68 00 00 40 00       	push   $0x400000
  8018ed:	6a 00                	push   $0x0
  8018ef:	e8 93 f3 ff ff       	call   800c87 <sys_page_alloc>
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	0f 88 7b 02 00 00    	js     801b7a <spawn+0x4f2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8018ff:	83 ec 08             	sub    $0x8,%esp
  801902:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801908:	01 f0                	add    %esi,%eax
  80190a:	50                   	push   %eax
  80190b:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801911:	e8 b8 f9 ff ff       	call   8012ce <seek>
  801916:	83 c4 10             	add    $0x10,%esp
  801919:	85 c0                	test   %eax,%eax
  80191b:	0f 88 60 02 00 00    	js     801b81 <spawn+0x4f9>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801921:	83 ec 04             	sub    $0x4,%esp
  801924:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80192a:	29 f0                	sub    %esi,%eax
  80192c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801931:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801936:	0f 47 c1             	cmova  %ecx,%eax
  801939:	50                   	push   %eax
  80193a:	68 00 00 40 00       	push   $0x400000
  80193f:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801945:	e8 bb f8 ff ff       	call   801205 <readn>
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	0f 88 33 02 00 00    	js     801b88 <spawn+0x500>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void *)(va + i), perm)) < 0)
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	57                   	push   %edi
  801959:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  80195f:	56                   	push   %esi
  801960:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801966:	68 00 00 40 00       	push   $0x400000
  80196b:	6a 00                	push   $0x0
  80196d:	e8 58 f3 ff ff       	call   800cca <sys_page_map>
  801972:	83 c4 20             	add    $0x20,%esp
  801975:	85 c0                	test   %eax,%eax
  801977:	0f 88 80 00 00 00    	js     8019fd <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	68 00 00 40 00       	push   $0x400000
  801985:	6a 00                	push   $0x0
  801987:	e8 80 f3 ff ff       	call   800d0c <sys_page_unmap>
  80198c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE)
  80198f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801995:	89 de                	mov    %ebx,%esi
  801997:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  80199d:	76 73                	jbe    801a12 <spawn+0x38a>
		if (i >= filesz)
  80199f:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8019a5:	0f 87 38 ff ff ff    	ja     8018e3 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void *)(va + i), perm)) < 0)
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	57                   	push   %edi
  8019af:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  8019b5:	56                   	push   %esi
  8019b6:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  8019bc:	e8 c6 f2 ff ff       	call   800c87 <sys_page_alloc>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	79 c7                	jns    80198f <spawn+0x307>
  8019c8:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8019ca:	83 ec 0c             	sub    $0xc,%esp
  8019cd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8019d3:	e8 30 f2 ff ff       	call   800c08 <sys_env_destroy>
	close(fd);
  8019d8:	83 c4 04             	add    $0x4,%esp
  8019db:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  8019e1:	e8 5c f6 ff ff       	call   801042 <close>
	return r;
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  8019ef:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8019f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5f                   	pop    %edi
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8019fd:	50                   	push   %eax
  8019fe:	68 35 2e 80 00       	push   $0x802e35
  801a03:	68 28 01 00 00       	push   $0x128
  801a08:	68 29 2e 80 00       	push   $0x802e29
  801a0d:	e8 82 e7 ff ff       	call   800194 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801a12:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801a19:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801a20:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801a27:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801a2d:	7e 71                	jle    801aa0 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801a2f:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801a35:	83 3a 01             	cmpl   $0x1,(%edx)
  801a38:	75 d8                	jne    801a12 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a3a:	8b 42 18             	mov    0x18(%edx),%eax
  801a3d:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801a40:	83 f8 01             	cmp    $0x1,%eax
  801a43:	19 ff                	sbb    %edi,%edi
  801a45:	83 e7 fe             	and    $0xfffffffe,%edi
  801a48:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801a4b:	8b 72 04             	mov    0x4(%edx),%esi
  801a4e:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801a54:	8b 5a 10             	mov    0x10(%edx),%ebx
  801a57:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801a5d:	8b 42 14             	mov    0x14(%edx),%eax
  801a60:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801a66:	8b 4a 08             	mov    0x8(%edx),%ecx
  801a69:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
	if ((i = PGOFF(va)))
  801a6f:	89 c8                	mov    %ecx,%eax
  801a71:	25 ff 0f 00 00       	and    $0xfff,%eax
  801a76:	74 1e                	je     801a96 <spawn+0x40e>
		va -= i;
  801a78:	29 c1                	sub    %eax,%ecx
  801a7a:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
		memsz += i;
  801a80:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801a86:	01 c3                	add    %eax,%ebx
  801a88:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801a8e:	29 c6                	sub    %eax,%esi
  801a90:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE)
  801a96:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a9b:	e9 f5 fe ff ff       	jmp    801995 <spawn+0x30d>
	close(fd);
  801aa0:	83 ec 0c             	sub    $0xc,%esp
  801aa3:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801aa9:	e8 94 f5 ff ff       	call   801042 <close>
  801aae:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int r, pn;
	struct Env *e;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801ab1:	bb 00 08 00 00       	mov    $0x800,%ebx
  801ab6:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801abc:	eb 0f                	jmp    801acd <spawn+0x445>
  801abe:	83 c3 01             	add    $0x1,%ebx
  801ac1:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801ac7:	0f 84 c2 00 00 00    	je     801b8f <spawn+0x507>
	{
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801acd:	89 d8                	mov    %ebx,%eax
  801acf:	c1 f8 0a             	sar    $0xa,%eax
  801ad2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ad9:	a8 01                	test   $0x1,%al
  801adb:	74 e1                	je     801abe <spawn+0x436>
  801add:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801ae4:	a8 01                	test   $0x1,%al
  801ae6:	74 d6                	je     801abe <spawn+0x436>
		{
			if (uvpt[pn] & PTE_SHARE)
  801ae8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801aef:	f6 c4 04             	test   $0x4,%ah
  801af2:	74 ca                	je     801abe <spawn+0x436>
			{
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
									  child, (void *)(pn * PGSIZE),
									  uvpt[pn] & PTE_SYSCALL)) < 0)
  801af4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801afb:	89 da                	mov    %ebx,%edx
  801afd:	c1 e2 0c             	shl    $0xc,%edx
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
  801b00:	83 ec 0c             	sub    $0xc,%esp
  801b03:	25 07 0e 00 00       	and    $0xe07,%eax
  801b08:	50                   	push   %eax
  801b09:	52                   	push   %edx
  801b0a:	56                   	push   %esi
  801b0b:	52                   	push   %edx
  801b0c:	6a 00                	push   $0x0
  801b0e:	e8 b7 f1 ff ff       	call   800cca <sys_page_map>
  801b13:	83 c4 20             	add    $0x20,%esp
  801b16:	85 c0                	test   %eax,%eax
  801b18:	79 a4                	jns    801abe <spawn+0x436>
		panic("copy_shared_pages: %e", r);
  801b1a:	50                   	push   %eax
  801b1b:	68 83 2e 80 00       	push   $0x802e83
  801b20:	68 82 00 00 00       	push   $0x82
  801b25:	68 29 2e 80 00       	push   $0x802e29
  801b2a:	e8 65 e6 ff ff       	call   800194 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801b2f:	50                   	push   %eax
  801b30:	68 52 2e 80 00       	push   $0x802e52
  801b35:	68 86 00 00 00       	push   $0x86
  801b3a:	68 29 2e 80 00       	push   $0x802e29
  801b3f:	e8 50 e6 ff ff       	call   800194 <_panic>
		panic("sys_env_set_status: %e", r);
  801b44:	50                   	push   %eax
  801b45:	68 6c 2e 80 00       	push   $0x802e6c
  801b4a:	68 89 00 00 00       	push   $0x89
  801b4f:	68 29 2e 80 00       	push   $0x802e29
  801b54:	e8 3b e6 ff ff       	call   800194 <_panic>
		return r;
  801b59:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801b5f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b65:	e9 85 fe ff ff       	jmp    8019ef <spawn+0x367>
		return -E_NO_MEM;
  801b6a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801b6f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b75:	e9 75 fe ff ff       	jmp    8019ef <spawn+0x367>
  801b7a:	89 c7                	mov    %eax,%edi
  801b7c:	e9 49 fe ff ff       	jmp    8019ca <spawn+0x342>
  801b81:	89 c7                	mov    %eax,%edi
  801b83:	e9 42 fe ff ff       	jmp    8019ca <spawn+0x342>
  801b88:	89 c7                	mov    %eax,%edi
  801b8a:	e9 3b fe ff ff       	jmp    8019ca <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3; // devious: see user/faultio.c
  801b8f:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801b96:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801b99:	83 ec 08             	sub    $0x8,%esp
  801b9c:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ba2:	50                   	push   %eax
  801ba3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ba9:	e8 e2 f1 ff ff       	call   800d90 <sys_env_set_trapframe>
  801bae:	83 c4 10             	add    $0x10,%esp
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	0f 88 76 ff ff ff    	js     801b2f <spawn+0x4a7>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801bb9:	83 ec 08             	sub    $0x8,%esp
  801bbc:	6a 02                	push   $0x2
  801bbe:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bc4:	e8 85 f1 ff ff       	call   800d4e <sys_env_set_status>
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	0f 88 70 ff ff ff    	js     801b44 <spawn+0x4bc>
	return child;
  801bd4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801bda:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801be0:	e9 0a fe ff ff       	jmp    8019ef <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801be5:	83 ec 08             	sub    $0x8,%esp
  801be8:	68 00 00 40 00       	push   $0x400000
  801bed:	6a 00                	push   $0x0
  801bef:	e8 18 f1 ff ff       	call   800d0c <sys_page_unmap>
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801bfd:	e9 ed fd ff ff       	jmp    8019ef <spawn+0x367>

00801c02 <spawnl>:
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	57                   	push   %edi
  801c06:	56                   	push   %esi
  801c07:	53                   	push   %ebx
  801c08:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801c0b:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  801c13:	eb 05                	jmp    801c1a <spawnl+0x18>
		argc++;
  801c15:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  801c18:	89 ca                	mov    %ecx,%edx
  801c1a:	8d 4a 04             	lea    0x4(%edx),%ecx
  801c1d:	83 3a 00             	cmpl   $0x0,(%edx)
  801c20:	75 f3                	jne    801c15 <spawnl+0x13>
	const char *argv[argc + 2];
  801c22:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801c29:	83 e2 f0             	and    $0xfffffff0,%edx
  801c2c:	29 d4                	sub    %edx,%esp
  801c2e:	8d 54 24 03          	lea    0x3(%esp),%edx
  801c32:	c1 ea 02             	shr    $0x2,%edx
  801c35:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801c3c:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c41:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801c48:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801c4f:	00 
	va_start(vl, arg0);
  801c50:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801c53:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5a:	eb 0b                	jmp    801c67 <spawnl+0x65>
		argv[i + 1] = va_arg(vl, const char *);
  801c5c:	83 c0 01             	add    $0x1,%eax
  801c5f:	8b 39                	mov    (%ecx),%edi
  801c61:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801c64:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  801c67:	39 d0                	cmp    %edx,%eax
  801c69:	75 f1                	jne    801c5c <spawnl+0x5a>
	return spawn(prog, argv);
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	56                   	push   %esi
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	e8 11 fa ff ff       	call   801688 <spawn>
}
  801c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5e                   	pop    %esi
  801c7c:	5f                   	pop    %edi
  801c7d:	5d                   	pop    %ebp
  801c7e:	c3                   	ret    

00801c7f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801c85:	68 c4 2e 80 00       	push   $0x802ec4
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	e8 fc eb ff ff       	call   80088e <strcpy>
	return 0;
}
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <devsock_close>:
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	53                   	push   %ebx
  801c9d:	83 ec 10             	sub    $0x10,%esp
  801ca0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ca3:	53                   	push   %ebx
  801ca4:	e8 f9 09 00 00       	call   8026a2 <pageref>
  801ca9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801cac:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801cb1:	83 f8 01             	cmp    $0x1,%eax
  801cb4:	74 07                	je     801cbd <devsock_close+0x24>
}
  801cb6:	89 d0                	mov    %edx,%eax
  801cb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801cbd:	83 ec 0c             	sub    $0xc,%esp
  801cc0:	ff 73 0c             	pushl  0xc(%ebx)
  801cc3:	e8 b7 02 00 00       	call   801f7f <nsipc_close>
  801cc8:	89 c2                	mov    %eax,%edx
  801cca:	83 c4 10             	add    $0x10,%esp
  801ccd:	eb e7                	jmp    801cb6 <devsock_close+0x1d>

00801ccf <devsock_write>:
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	ff 75 10             	pushl  0x10(%ebp)
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	ff 70 0c             	pushl  0xc(%eax)
  801ce3:	e8 74 03 00 00       	call   80205c <nsipc_send>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <devsock_read>:
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	ff 75 10             	pushl  0x10(%ebp)
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	ff 70 0c             	pushl  0xc(%eax)
  801cfe:	e8 ed 02 00 00       	call   801ff0 <nsipc_recv>
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <fd2sockid>:
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d0b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d0e:	52                   	push   %edx
  801d0f:	50                   	push   %eax
  801d10:	e8 f8 f1 ff ff       	call   800f0d <fd_lookup>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	78 10                	js     801d2c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1f:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801d25:	39 08                	cmp    %ecx,(%eax)
  801d27:	75 05                	jne    801d2e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801d29:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    
		return -E_NOT_SUPP;
  801d2e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d33:	eb f7                	jmp    801d2c <fd2sockid+0x27>

00801d35 <alloc_sockfd>:
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	83 ec 1c             	sub    $0x1c,%esp
  801d3d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801d3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d42:	50                   	push   %eax
  801d43:	e8 76 f1 ff ff       	call   800ebe <fd_alloc>
  801d48:	89 c3                	mov    %eax,%ebx
  801d4a:	83 c4 10             	add    $0x10,%esp
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	78 43                	js     801d94 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	68 07 04 00 00       	push   $0x407
  801d59:	ff 75 f4             	pushl  -0xc(%ebp)
  801d5c:	6a 00                	push   $0x0
  801d5e:	e8 24 ef ff ff       	call   800c87 <sys_page_alloc>
  801d63:	89 c3                	mov    %eax,%ebx
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 28                	js     801d94 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d75:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d81:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	50                   	push   %eax
  801d88:	e8 0a f1 ff ff       	call   800e97 <fd2num>
  801d8d:	89 c3                	mov    %eax,%ebx
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	eb 0c                	jmp    801da0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801d94:	83 ec 0c             	sub    $0xc,%esp
  801d97:	56                   	push   %esi
  801d98:	e8 e2 01 00 00       	call   801f7f <nsipc_close>
		return r;
  801d9d:	83 c4 10             	add    $0x10,%esp
}
  801da0:	89 d8                	mov    %ebx,%eax
  801da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5d                   	pop    %ebp
  801da8:	c3                   	ret    

00801da9 <accept>:
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	e8 4e ff ff ff       	call   801d05 <fd2sockid>
  801db7:	85 c0                	test   %eax,%eax
  801db9:	78 1b                	js     801dd6 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	ff 75 10             	pushl  0x10(%ebp)
  801dc1:	ff 75 0c             	pushl  0xc(%ebp)
  801dc4:	50                   	push   %eax
  801dc5:	e8 0e 01 00 00       	call   801ed8 <nsipc_accept>
  801dca:	83 c4 10             	add    $0x10,%esp
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	78 05                	js     801dd6 <accept+0x2d>
	return alloc_sockfd(r);
  801dd1:	e8 5f ff ff ff       	call   801d35 <alloc_sockfd>
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <bind>:
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	e8 1f ff ff ff       	call   801d05 <fd2sockid>
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 12                	js     801dfc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	ff 75 10             	pushl  0x10(%ebp)
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	50                   	push   %eax
  801df4:	e8 2f 01 00 00       	call   801f28 <nsipc_bind>
  801df9:	83 c4 10             	add    $0x10,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <shutdown>:
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	e8 f9 fe ff ff       	call   801d05 <fd2sockid>
  801e0c:	85 c0                	test   %eax,%eax
  801e0e:	78 0f                	js     801e1f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801e10:	83 ec 08             	sub    $0x8,%esp
  801e13:	ff 75 0c             	pushl  0xc(%ebp)
  801e16:	50                   	push   %eax
  801e17:	e8 41 01 00 00       	call   801f5d <nsipc_shutdown>
  801e1c:	83 c4 10             	add    $0x10,%esp
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <connect>:
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	e8 d6 fe ff ff       	call   801d05 <fd2sockid>
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 12                	js     801e45 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801e33:	83 ec 04             	sub    $0x4,%esp
  801e36:	ff 75 10             	pushl  0x10(%ebp)
  801e39:	ff 75 0c             	pushl  0xc(%ebp)
  801e3c:	50                   	push   %eax
  801e3d:	e8 57 01 00 00       	call   801f99 <nsipc_connect>
  801e42:	83 c4 10             	add    $0x10,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <listen>:
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	e8 b0 fe ff ff       	call   801d05 <fd2sockid>
  801e55:	85 c0                	test   %eax,%eax
  801e57:	78 0f                	js     801e68 <listen+0x21>
	return nsipc_listen(r, backlog);
  801e59:	83 ec 08             	sub    $0x8,%esp
  801e5c:	ff 75 0c             	pushl  0xc(%ebp)
  801e5f:	50                   	push   %eax
  801e60:	e8 69 01 00 00       	call   801fce <nsipc_listen>
  801e65:	83 c4 10             	add    $0x10,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <socket>:

int
socket(int domain, int type, int protocol)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e70:	ff 75 10             	pushl  0x10(%ebp)
  801e73:	ff 75 0c             	pushl  0xc(%ebp)
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	e8 3c 02 00 00       	call   8020ba <nsipc_socket>
  801e7e:	83 c4 10             	add    $0x10,%esp
  801e81:	85 c0                	test   %eax,%eax
  801e83:	78 05                	js     801e8a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801e85:	e8 ab fe ff ff       	call   801d35 <alloc_sockfd>
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e95:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801e9c:	74 26                	je     801ec4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e9e:	6a 07                	push   $0x7
  801ea0:	68 00 60 80 00       	push   $0x806000
  801ea5:	53                   	push   %ebx
  801ea6:	ff 35 04 40 80 00    	pushl  0x804004
  801eac:	e8 64 07 00 00       	call   802615 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801eb1:	83 c4 0c             	add    $0xc,%esp
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	e8 ef 06 00 00       	call   8025ae <ipc_recv>
}
  801ebf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	6a 02                	push   $0x2
  801ec9:	e8 9b 07 00 00       	call   802669 <ipc_find_env>
  801ece:	a3 04 40 80 00       	mov    %eax,0x804004
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	eb c6                	jmp    801e9e <nsipc+0x12>

00801ed8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
  801edd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ee8:	8b 06                	mov    (%esi),%eax
  801eea:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801eef:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef4:	e8 93 ff ff ff       	call   801e8c <nsipc>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 20                	js     801f1f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801eff:	83 ec 04             	sub    $0x4,%esp
  801f02:	ff 35 10 60 80 00    	pushl  0x806010
  801f08:	68 00 60 80 00       	push   $0x806000
  801f0d:	ff 75 0c             	pushl  0xc(%ebp)
  801f10:	e8 07 eb ff ff       	call   800a1c <memmove>
		*addrlen = ret->ret_addrlen;
  801f15:	a1 10 60 80 00       	mov    0x806010,%eax
  801f1a:	89 06                	mov    %eax,(%esi)
  801f1c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801f1f:	89 d8                	mov    %ebx,%eax
  801f21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f24:	5b                   	pop    %ebx
  801f25:	5e                   	pop    %esi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    

00801f28 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	53                   	push   %ebx
  801f2c:	83 ec 08             	sub    $0x8,%esp
  801f2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f3a:	53                   	push   %ebx
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	68 04 60 80 00       	push   $0x806004
  801f43:	e8 d4 ea ff ff       	call   800a1c <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f48:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f53:	e8 34 ff ff ff       	call   801e8c <nsipc>
}
  801f58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801f73:	b8 03 00 00 00       	mov    $0x3,%eax
  801f78:	e8 0f ff ff ff       	call   801e8c <nsipc>
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <nsipc_close>:

int
nsipc_close(int s)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801f8d:	b8 04 00 00 00       	mov    $0x4,%eax
  801f92:	e8 f5 fe ff ff       	call   801e8c <nsipc>
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	53                   	push   %ebx
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fab:	53                   	push   %ebx
  801fac:	ff 75 0c             	pushl  0xc(%ebp)
  801faf:	68 04 60 80 00       	push   $0x806004
  801fb4:	e8 63 ea ff ff       	call   800a1c <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fb9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801fbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801fc4:	e8 c3 fe ff ff       	call   801e8c <nsipc>
}
  801fc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801fe4:	b8 06 00 00 00       	mov    $0x6,%eax
  801fe9:	e8 9e fe ff ff       	call   801e8c <nsipc>
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	56                   	push   %esi
  801ff4:	53                   	push   %ebx
  801ff5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802000:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802006:	8b 45 14             	mov    0x14(%ebp),%eax
  802009:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80200e:	b8 07 00 00 00       	mov    $0x7,%eax
  802013:	e8 74 fe ff ff       	call   801e8c <nsipc>
  802018:	89 c3                	mov    %eax,%ebx
  80201a:	85 c0                	test   %eax,%eax
  80201c:	78 1f                	js     80203d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80201e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802023:	7f 21                	jg     802046 <nsipc_recv+0x56>
  802025:	39 c6                	cmp    %eax,%esi
  802027:	7c 1d                	jl     802046 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802029:	83 ec 04             	sub    $0x4,%esp
  80202c:	50                   	push   %eax
  80202d:	68 00 60 80 00       	push   $0x806000
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	e8 e2 e9 ff ff       	call   800a1c <memmove>
  80203a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80203d:	89 d8                	mov    %ebx,%eax
  80203f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802042:	5b                   	pop    %ebx
  802043:	5e                   	pop    %esi
  802044:	5d                   	pop    %ebp
  802045:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802046:	68 d0 2e 80 00       	push   $0x802ed0
  80204b:	68 e3 2d 80 00       	push   $0x802de3
  802050:	6a 62                	push   $0x62
  802052:	68 e5 2e 80 00       	push   $0x802ee5
  802057:	e8 38 e1 ff ff       	call   800194 <_panic>

0080205c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	53                   	push   %ebx
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80206e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802074:	7f 2e                	jg     8020a4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802076:	83 ec 04             	sub    $0x4,%esp
  802079:	53                   	push   %ebx
  80207a:	ff 75 0c             	pushl  0xc(%ebp)
  80207d:	68 0c 60 80 00       	push   $0x80600c
  802082:	e8 95 e9 ff ff       	call   800a1c <memmove>
	nsipcbuf.send.req_size = size;
  802087:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80208d:	8b 45 14             	mov    0x14(%ebp),%eax
  802090:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802095:	b8 08 00 00 00       	mov    $0x8,%eax
  80209a:	e8 ed fd ff ff       	call   801e8c <nsipc>
}
  80209f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    
	assert(size < 1600);
  8020a4:	68 f1 2e 80 00       	push   $0x802ef1
  8020a9:	68 e3 2d 80 00       	push   $0x802de3
  8020ae:	6a 6d                	push   $0x6d
  8020b0:	68 e5 2e 80 00       	push   $0x802ee5
  8020b5:	e8 da e0 ff ff       	call   800194 <_panic>

008020ba <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8020c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cb:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8020d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d3:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8020d8:	b8 09 00 00 00       	mov    $0x9,%eax
  8020dd:	e8 aa fd ff ff       	call   801e8c <nsipc>
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	56                   	push   %esi
  8020e8:	53                   	push   %ebx
  8020e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	ff 75 08             	pushl  0x8(%ebp)
  8020f2:	e8 b0 ed ff ff       	call   800ea7 <fd2data>
  8020f7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020f9:	83 c4 08             	add    $0x8,%esp
  8020fc:	68 fd 2e 80 00       	push   $0x802efd
  802101:	53                   	push   %ebx
  802102:	e8 87 e7 ff ff       	call   80088e <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802107:	8b 46 04             	mov    0x4(%esi),%eax
  80210a:	2b 06                	sub    (%esi),%eax
  80210c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802112:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802119:	00 00 00 
	stat->st_dev = &devpipe;
  80211c:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  802123:	30 80 00 
	return 0;
}
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
  80212b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80212e:	5b                   	pop    %ebx
  80212f:	5e                   	pop    %esi
  802130:	5d                   	pop    %ebp
  802131:	c3                   	ret    

00802132 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	53                   	push   %ebx
  802136:	83 ec 0c             	sub    $0xc,%esp
  802139:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80213c:	53                   	push   %ebx
  80213d:	6a 00                	push   $0x0
  80213f:	e8 c8 eb ff ff       	call   800d0c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802144:	89 1c 24             	mov    %ebx,(%esp)
  802147:	e8 5b ed ff ff       	call   800ea7 <fd2data>
  80214c:	83 c4 08             	add    $0x8,%esp
  80214f:	50                   	push   %eax
  802150:	6a 00                	push   $0x0
  802152:	e8 b5 eb ff ff       	call   800d0c <sys_page_unmap>
}
  802157:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <_pipeisclosed>:
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	57                   	push   %edi
  802160:	56                   	push   %esi
  802161:	53                   	push   %ebx
  802162:	83 ec 1c             	sub    $0x1c,%esp
  802165:	89 c7                	mov    %eax,%edi
  802167:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802169:	a1 08 40 80 00       	mov    0x804008,%eax
  80216e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	57                   	push   %edi
  802175:	e8 28 05 00 00       	call   8026a2 <pageref>
  80217a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80217d:	89 34 24             	mov    %esi,(%esp)
  802180:	e8 1d 05 00 00       	call   8026a2 <pageref>
		nn = thisenv->env_runs;
  802185:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80218b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	39 cb                	cmp    %ecx,%ebx
  802193:	74 1b                	je     8021b0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802195:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802198:	75 cf                	jne    802169 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80219a:	8b 42 58             	mov    0x58(%edx),%eax
  80219d:	6a 01                	push   $0x1
  80219f:	50                   	push   %eax
  8021a0:	53                   	push   %ebx
  8021a1:	68 04 2f 80 00       	push   $0x802f04
  8021a6:	e8 c4 e0 ff ff       	call   80026f <cprintf>
  8021ab:	83 c4 10             	add    $0x10,%esp
  8021ae:	eb b9                	jmp    802169 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8021b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8021b3:	0f 94 c0             	sete   %al
  8021b6:	0f b6 c0             	movzbl %al,%eax
}
  8021b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021bc:	5b                   	pop    %ebx
  8021bd:	5e                   	pop    %esi
  8021be:	5f                   	pop    %edi
  8021bf:	5d                   	pop    %ebp
  8021c0:	c3                   	ret    

008021c1 <devpipe_write>:
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	57                   	push   %edi
  8021c5:	56                   	push   %esi
  8021c6:	53                   	push   %ebx
  8021c7:	83 ec 28             	sub    $0x28,%esp
  8021ca:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8021cd:	56                   	push   %esi
  8021ce:	e8 d4 ec ff ff       	call   800ea7 <fd2data>
  8021d3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8021d5:	83 c4 10             	add    $0x10,%esp
  8021d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8021dd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021e0:	74 4f                	je     802231 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021e2:	8b 43 04             	mov    0x4(%ebx),%eax
  8021e5:	8b 0b                	mov    (%ebx),%ecx
  8021e7:	8d 51 20             	lea    0x20(%ecx),%edx
  8021ea:	39 d0                	cmp    %edx,%eax
  8021ec:	72 14                	jb     802202 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8021ee:	89 da                	mov    %ebx,%edx
  8021f0:	89 f0                	mov    %esi,%eax
  8021f2:	e8 65 ff ff ff       	call   80215c <_pipeisclosed>
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	75 3a                	jne    802235 <devpipe_write+0x74>
			sys_yield();
  8021fb:	e8 68 ea ff ff       	call   800c68 <sys_yield>
  802200:	eb e0                	jmp    8021e2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802202:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802205:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802209:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80220c:	89 c2                	mov    %eax,%edx
  80220e:	c1 fa 1f             	sar    $0x1f,%edx
  802211:	89 d1                	mov    %edx,%ecx
  802213:	c1 e9 1b             	shr    $0x1b,%ecx
  802216:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802219:	83 e2 1f             	and    $0x1f,%edx
  80221c:	29 ca                	sub    %ecx,%edx
  80221e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802222:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802226:	83 c0 01             	add    $0x1,%eax
  802229:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80222c:	83 c7 01             	add    $0x1,%edi
  80222f:	eb ac                	jmp    8021dd <devpipe_write+0x1c>
	return i;
  802231:	89 f8                	mov    %edi,%eax
  802233:	eb 05                	jmp    80223a <devpipe_write+0x79>
				return 0;
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80223d:	5b                   	pop    %ebx
  80223e:	5e                   	pop    %esi
  80223f:	5f                   	pop    %edi
  802240:	5d                   	pop    %ebp
  802241:	c3                   	ret    

00802242 <devpipe_read>:
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	57                   	push   %edi
  802246:	56                   	push   %esi
  802247:	53                   	push   %ebx
  802248:	83 ec 18             	sub    $0x18,%esp
  80224b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80224e:	57                   	push   %edi
  80224f:	e8 53 ec ff ff       	call   800ea7 <fd2data>
  802254:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	be 00 00 00 00       	mov    $0x0,%esi
  80225e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802261:	74 47                	je     8022aa <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802263:	8b 03                	mov    (%ebx),%eax
  802265:	3b 43 04             	cmp    0x4(%ebx),%eax
  802268:	75 22                	jne    80228c <devpipe_read+0x4a>
			if (i > 0)
  80226a:	85 f6                	test   %esi,%esi
  80226c:	75 14                	jne    802282 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80226e:	89 da                	mov    %ebx,%edx
  802270:	89 f8                	mov    %edi,%eax
  802272:	e8 e5 fe ff ff       	call   80215c <_pipeisclosed>
  802277:	85 c0                	test   %eax,%eax
  802279:	75 33                	jne    8022ae <devpipe_read+0x6c>
			sys_yield();
  80227b:	e8 e8 e9 ff ff       	call   800c68 <sys_yield>
  802280:	eb e1                	jmp    802263 <devpipe_read+0x21>
				return i;
  802282:	89 f0                	mov    %esi,%eax
}
  802284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802287:	5b                   	pop    %ebx
  802288:	5e                   	pop    %esi
  802289:	5f                   	pop    %edi
  80228a:	5d                   	pop    %ebp
  80228b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80228c:	99                   	cltd   
  80228d:	c1 ea 1b             	shr    $0x1b,%edx
  802290:	01 d0                	add    %edx,%eax
  802292:	83 e0 1f             	and    $0x1f,%eax
  802295:	29 d0                	sub    %edx,%eax
  802297:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80229c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80229f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022a2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8022a5:	83 c6 01             	add    $0x1,%esi
  8022a8:	eb b4                	jmp    80225e <devpipe_read+0x1c>
	return i;
  8022aa:	89 f0                	mov    %esi,%eax
  8022ac:	eb d6                	jmp    802284 <devpipe_read+0x42>
				return 0;
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b3:	eb cf                	jmp    802284 <devpipe_read+0x42>

008022b5 <pipe>:
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	56                   	push   %esi
  8022b9:	53                   	push   %ebx
  8022ba:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8022bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c0:	50                   	push   %eax
  8022c1:	e8 f8 eb ff ff       	call   800ebe <fd_alloc>
  8022c6:	89 c3                	mov    %eax,%ebx
  8022c8:	83 c4 10             	add    $0x10,%esp
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	78 5b                	js     80232a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022cf:	83 ec 04             	sub    $0x4,%esp
  8022d2:	68 07 04 00 00       	push   $0x407
  8022d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8022da:	6a 00                	push   $0x0
  8022dc:	e8 a6 e9 ff ff       	call   800c87 <sys_page_alloc>
  8022e1:	89 c3                	mov    %eax,%ebx
  8022e3:	83 c4 10             	add    $0x10,%esp
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	78 40                	js     80232a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022f0:	50                   	push   %eax
  8022f1:	e8 c8 eb ff ff       	call   800ebe <fd_alloc>
  8022f6:	89 c3                	mov    %eax,%ebx
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	78 1b                	js     80231a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ff:	83 ec 04             	sub    $0x4,%esp
  802302:	68 07 04 00 00       	push   $0x407
  802307:	ff 75 f0             	pushl  -0x10(%ebp)
  80230a:	6a 00                	push   $0x0
  80230c:	e8 76 e9 ff ff       	call   800c87 <sys_page_alloc>
  802311:	89 c3                	mov    %eax,%ebx
  802313:	83 c4 10             	add    $0x10,%esp
  802316:	85 c0                	test   %eax,%eax
  802318:	79 19                	jns    802333 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80231a:	83 ec 08             	sub    $0x8,%esp
  80231d:	ff 75 f4             	pushl  -0xc(%ebp)
  802320:	6a 00                	push   $0x0
  802322:	e8 e5 e9 ff ff       	call   800d0c <sys_page_unmap>
  802327:	83 c4 10             	add    $0x10,%esp
}
  80232a:	89 d8                	mov    %ebx,%eax
  80232c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    
	va = fd2data(fd0);
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	ff 75 f4             	pushl  -0xc(%ebp)
  802339:	e8 69 eb ff ff       	call   800ea7 <fd2data>
  80233e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802340:	83 c4 0c             	add    $0xc,%esp
  802343:	68 07 04 00 00       	push   $0x407
  802348:	50                   	push   %eax
  802349:	6a 00                	push   $0x0
  80234b:	e8 37 e9 ff ff       	call   800c87 <sys_page_alloc>
  802350:	89 c3                	mov    %eax,%ebx
  802352:	83 c4 10             	add    $0x10,%esp
  802355:	85 c0                	test   %eax,%eax
  802357:	0f 88 8c 00 00 00    	js     8023e9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80235d:	83 ec 0c             	sub    $0xc,%esp
  802360:	ff 75 f0             	pushl  -0x10(%ebp)
  802363:	e8 3f eb ff ff       	call   800ea7 <fd2data>
  802368:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80236f:	50                   	push   %eax
  802370:	6a 00                	push   $0x0
  802372:	56                   	push   %esi
  802373:	6a 00                	push   $0x0
  802375:	e8 50 e9 ff ff       	call   800cca <sys_page_map>
  80237a:	89 c3                	mov    %eax,%ebx
  80237c:	83 c4 20             	add    $0x20,%esp
  80237f:	85 c0                	test   %eax,%eax
  802381:	78 58                	js     8023db <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80238c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8023a1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8023ad:	83 ec 0c             	sub    $0xc,%esp
  8023b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b3:	e8 df ea ff ff       	call   800e97 <fd2num>
  8023b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023bb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023bd:	83 c4 04             	add    $0x4,%esp
  8023c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8023c3:	e8 cf ea ff ff       	call   800e97 <fd2num>
  8023c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023cb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023ce:	83 c4 10             	add    $0x10,%esp
  8023d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023d6:	e9 4f ff ff ff       	jmp    80232a <pipe+0x75>
	sys_page_unmap(0, va);
  8023db:	83 ec 08             	sub    $0x8,%esp
  8023de:	56                   	push   %esi
  8023df:	6a 00                	push   $0x0
  8023e1:	e8 26 e9 ff ff       	call   800d0c <sys_page_unmap>
  8023e6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8023e9:	83 ec 08             	sub    $0x8,%esp
  8023ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8023ef:	6a 00                	push   $0x0
  8023f1:	e8 16 e9 ff ff       	call   800d0c <sys_page_unmap>
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	e9 1c ff ff ff       	jmp    80231a <pipe+0x65>

008023fe <pipeisclosed>:
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802404:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802407:	50                   	push   %eax
  802408:	ff 75 08             	pushl  0x8(%ebp)
  80240b:	e8 fd ea ff ff       	call   800f0d <fd_lookup>
  802410:	83 c4 10             	add    $0x10,%esp
  802413:	85 c0                	test   %eax,%eax
  802415:	78 18                	js     80242f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802417:	83 ec 0c             	sub    $0xc,%esp
  80241a:	ff 75 f4             	pushl  -0xc(%ebp)
  80241d:	e8 85 ea ff ff       	call   800ea7 <fd2data>
	return _pipeisclosed(fd, p);
  802422:	89 c2                	mov    %eax,%edx
  802424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802427:	e8 30 fd ff ff       	call   80215c <_pipeisclosed>
  80242c:	83 c4 10             	add    $0x10,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802441:	68 1c 2f 80 00       	push   $0x802f1c
  802446:	ff 75 0c             	pushl  0xc(%ebp)
  802449:	e8 40 e4 ff ff       	call   80088e <strcpy>
	return 0;
}
  80244e:	b8 00 00 00 00       	mov    $0x0,%eax
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <devcons_write>:
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
  802458:	57                   	push   %edi
  802459:	56                   	push   %esi
  80245a:	53                   	push   %ebx
  80245b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802461:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802466:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80246c:	eb 2f                	jmp    80249d <devcons_write+0x48>
		m = n - tot;
  80246e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802471:	29 f3                	sub    %esi,%ebx
  802473:	83 fb 7f             	cmp    $0x7f,%ebx
  802476:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80247b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80247e:	83 ec 04             	sub    $0x4,%esp
  802481:	53                   	push   %ebx
  802482:	89 f0                	mov    %esi,%eax
  802484:	03 45 0c             	add    0xc(%ebp),%eax
  802487:	50                   	push   %eax
  802488:	57                   	push   %edi
  802489:	e8 8e e5 ff ff       	call   800a1c <memmove>
		sys_cputs(buf, m);
  80248e:	83 c4 08             	add    $0x8,%esp
  802491:	53                   	push   %ebx
  802492:	57                   	push   %edi
  802493:	e8 33 e7 ff ff       	call   800bcb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802498:	01 de                	add    %ebx,%esi
  80249a:	83 c4 10             	add    $0x10,%esp
  80249d:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a0:	72 cc                	jb     80246e <devcons_write+0x19>
}
  8024a2:	89 f0                	mov    %esi,%eax
  8024a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024a7:	5b                   	pop    %ebx
  8024a8:	5e                   	pop    %esi
  8024a9:	5f                   	pop    %edi
  8024aa:	5d                   	pop    %ebp
  8024ab:	c3                   	ret    

008024ac <devcons_read>:
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 08             	sub    $0x8,%esp
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8024b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bb:	75 07                	jne    8024c4 <devcons_read+0x18>
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    
		sys_yield();
  8024bf:	e8 a4 e7 ff ff       	call   800c68 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8024c4:	e8 20 e7 ff ff       	call   800be9 <sys_cgetc>
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	74 f2                	je     8024bf <devcons_read+0x13>
	if (c < 0)
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	78 ec                	js     8024bd <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8024d1:	83 f8 04             	cmp    $0x4,%eax
  8024d4:	74 0c                	je     8024e2 <devcons_read+0x36>
	*(char*)vbuf = c;
  8024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d9:	88 02                	mov    %al,(%edx)
	return 1;
  8024db:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e0:	eb db                	jmp    8024bd <devcons_read+0x11>
		return 0;
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e7:	eb d4                	jmp    8024bd <devcons_read+0x11>

008024e9 <cputchar>:
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8024f5:	6a 01                	push   $0x1
  8024f7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024fa:	50                   	push   %eax
  8024fb:	e8 cb e6 ff ff       	call   800bcb <sys_cputs>
}
  802500:	83 c4 10             	add    $0x10,%esp
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <getchar>:
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80250b:	6a 01                	push   $0x1
  80250d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802510:	50                   	push   %eax
  802511:	6a 00                	push   $0x0
  802513:	e8 66 ec ff ff       	call   80117e <read>
	if (r < 0)
  802518:	83 c4 10             	add    $0x10,%esp
  80251b:	85 c0                	test   %eax,%eax
  80251d:	78 08                	js     802527 <getchar+0x22>
	if (r < 1)
  80251f:	85 c0                	test   %eax,%eax
  802521:	7e 06                	jle    802529 <getchar+0x24>
	return c;
  802523:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    
		return -E_EOF;
  802529:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80252e:	eb f7                	jmp    802527 <getchar+0x22>

00802530 <iscons>:
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802536:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802539:	50                   	push   %eax
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	e8 cb e9 ff ff       	call   800f0d <fd_lookup>
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	85 c0                	test   %eax,%eax
  802547:	78 11                	js     80255a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802552:	39 10                	cmp    %edx,(%eax)
  802554:	0f 94 c0             	sete   %al
  802557:	0f b6 c0             	movzbl %al,%eax
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <opencons>:
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802562:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802565:	50                   	push   %eax
  802566:	e8 53 e9 ff ff       	call   800ebe <fd_alloc>
  80256b:	83 c4 10             	add    $0x10,%esp
  80256e:	85 c0                	test   %eax,%eax
  802570:	78 3a                	js     8025ac <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802572:	83 ec 04             	sub    $0x4,%esp
  802575:	68 07 04 00 00       	push   $0x407
  80257a:	ff 75 f4             	pushl  -0xc(%ebp)
  80257d:	6a 00                	push   $0x0
  80257f:	e8 03 e7 ff ff       	call   800c87 <sys_page_alloc>
  802584:	83 c4 10             	add    $0x10,%esp
  802587:	85 c0                	test   %eax,%eax
  802589:	78 21                	js     8025ac <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802594:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025a0:	83 ec 0c             	sub    $0xc,%esp
  8025a3:	50                   	push   %eax
  8025a4:	e8 ee e8 ff ff       	call   800e97 <fd2num>
  8025a9:	83 c4 10             	add    $0x10,%esp
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	56                   	push   %esi
  8025b2:	53                   	push   %ebx
  8025b3:	8b 75 08             	mov    0x8(%ebp),%esi
  8025b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8025bc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8025be:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8025c3:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8025c6:	83 ec 0c             	sub    $0xc,%esp
  8025c9:	50                   	push   %eax
  8025ca:	e8 68 e8 ff ff       	call   800e37 <sys_ipc_recv>
	if (from_env_store)
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	85 f6                	test   %esi,%esi
  8025d4:	74 14                	je     8025ea <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8025d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	78 09                	js     8025e8 <ipc_recv+0x3a>
  8025df:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8025e5:	8b 52 74             	mov    0x74(%edx),%edx
  8025e8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8025ea:	85 db                	test   %ebx,%ebx
  8025ec:	74 14                	je     802602 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8025ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	78 09                	js     802600 <ipc_recv+0x52>
  8025f7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8025fd:	8b 52 78             	mov    0x78(%edx),%edx
  802600:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802602:	85 c0                	test   %eax,%eax
  802604:	78 08                	js     80260e <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802606:	a1 08 40 80 00       	mov    0x804008,%eax
  80260b:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80260e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    

00802615 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	57                   	push   %edi
  802619:	56                   	push   %esi
  80261a:	53                   	push   %ebx
  80261b:	83 ec 0c             	sub    $0xc,%esp
  80261e:	8b 7d 08             	mov    0x8(%ebp),%edi
  802621:	8b 75 0c             	mov    0xc(%ebp),%esi
  802624:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802627:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802629:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80262e:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802631:	ff 75 14             	pushl  0x14(%ebp)
  802634:	53                   	push   %ebx
  802635:	56                   	push   %esi
  802636:	57                   	push   %edi
  802637:	e8 d8 e7 ff ff       	call   800e14 <sys_ipc_try_send>
		if (ret == 0)
  80263c:	83 c4 10             	add    $0x10,%esp
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 1e                	je     802661 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802643:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802646:	75 07                	jne    80264f <ipc_send+0x3a>
			sys_yield();
  802648:	e8 1b e6 ff ff       	call   800c68 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80264d:	eb e2                	jmp    802631 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80264f:	50                   	push   %eax
  802650:	68 28 2f 80 00       	push   $0x802f28
  802655:	6a 3d                	push   $0x3d
  802657:	68 3c 2f 80 00       	push   $0x802f3c
  80265c:	e8 33 db ff ff       	call   800194 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802661:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802664:	5b                   	pop    %ebx
  802665:	5e                   	pop    %esi
  802666:	5f                   	pop    %edi
  802667:	5d                   	pop    %ebp
  802668:	c3                   	ret    

00802669 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80266f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802674:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802677:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80267d:	8b 52 50             	mov    0x50(%edx),%edx
  802680:	39 ca                	cmp    %ecx,%edx
  802682:	74 11                	je     802695 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802684:	83 c0 01             	add    $0x1,%eax
  802687:	3d 00 04 00 00       	cmp    $0x400,%eax
  80268c:	75 e6                	jne    802674 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80268e:	b8 00 00 00 00       	mov    $0x0,%eax
  802693:	eb 0b                	jmp    8026a0 <ipc_find_env+0x37>
			return envs[i].env_id;
  802695:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802698:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80269d:	8b 40 48             	mov    0x48(%eax),%eax
}
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    

008026a2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026a8:	89 d0                	mov    %edx,%eax
  8026aa:	c1 e8 16             	shr    $0x16,%eax
  8026ad:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8026b4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8026b9:	f6 c1 01             	test   $0x1,%cl
  8026bc:	74 1d                	je     8026db <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8026be:	c1 ea 0c             	shr    $0xc,%edx
  8026c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026c8:	f6 c2 01             	test   $0x1,%dl
  8026cb:	74 0e                	je     8026db <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026cd:	c1 ea 0c             	shr    $0xc,%edx
  8026d0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026d7:	ef 
  8026d8:	0f b7 c0             	movzwl %ax,%eax
}
  8026db:	5d                   	pop    %ebp
  8026dc:	c3                   	ret    
  8026dd:	66 90                	xchg   %ax,%ax
  8026df:	90                   	nop

008026e0 <__udivdi3>:
  8026e0:	55                   	push   %ebp
  8026e1:	57                   	push   %edi
  8026e2:	56                   	push   %esi
  8026e3:	53                   	push   %ebx
  8026e4:	83 ec 1c             	sub    $0x1c,%esp
  8026e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8026eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8026ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8026f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8026f7:	85 d2                	test   %edx,%edx
  8026f9:	75 35                	jne    802730 <__udivdi3+0x50>
  8026fb:	39 f3                	cmp    %esi,%ebx
  8026fd:	0f 87 bd 00 00 00    	ja     8027c0 <__udivdi3+0xe0>
  802703:	85 db                	test   %ebx,%ebx
  802705:	89 d9                	mov    %ebx,%ecx
  802707:	75 0b                	jne    802714 <__udivdi3+0x34>
  802709:	b8 01 00 00 00       	mov    $0x1,%eax
  80270e:	31 d2                	xor    %edx,%edx
  802710:	f7 f3                	div    %ebx
  802712:	89 c1                	mov    %eax,%ecx
  802714:	31 d2                	xor    %edx,%edx
  802716:	89 f0                	mov    %esi,%eax
  802718:	f7 f1                	div    %ecx
  80271a:	89 c6                	mov    %eax,%esi
  80271c:	89 e8                	mov    %ebp,%eax
  80271e:	89 f7                	mov    %esi,%edi
  802720:	f7 f1                	div    %ecx
  802722:	89 fa                	mov    %edi,%edx
  802724:	83 c4 1c             	add    $0x1c,%esp
  802727:	5b                   	pop    %ebx
  802728:	5e                   	pop    %esi
  802729:	5f                   	pop    %edi
  80272a:	5d                   	pop    %ebp
  80272b:	c3                   	ret    
  80272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802730:	39 f2                	cmp    %esi,%edx
  802732:	77 7c                	ja     8027b0 <__udivdi3+0xd0>
  802734:	0f bd fa             	bsr    %edx,%edi
  802737:	83 f7 1f             	xor    $0x1f,%edi
  80273a:	0f 84 98 00 00 00    	je     8027d8 <__udivdi3+0xf8>
  802740:	89 f9                	mov    %edi,%ecx
  802742:	b8 20 00 00 00       	mov    $0x20,%eax
  802747:	29 f8                	sub    %edi,%eax
  802749:	d3 e2                	shl    %cl,%edx
  80274b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80274f:	89 c1                	mov    %eax,%ecx
  802751:	89 da                	mov    %ebx,%edx
  802753:	d3 ea                	shr    %cl,%edx
  802755:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802759:	09 d1                	or     %edx,%ecx
  80275b:	89 f2                	mov    %esi,%edx
  80275d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802761:	89 f9                	mov    %edi,%ecx
  802763:	d3 e3                	shl    %cl,%ebx
  802765:	89 c1                	mov    %eax,%ecx
  802767:	d3 ea                	shr    %cl,%edx
  802769:	89 f9                	mov    %edi,%ecx
  80276b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80276f:	d3 e6                	shl    %cl,%esi
  802771:	89 eb                	mov    %ebp,%ebx
  802773:	89 c1                	mov    %eax,%ecx
  802775:	d3 eb                	shr    %cl,%ebx
  802777:	09 de                	or     %ebx,%esi
  802779:	89 f0                	mov    %esi,%eax
  80277b:	f7 74 24 08          	divl   0x8(%esp)
  80277f:	89 d6                	mov    %edx,%esi
  802781:	89 c3                	mov    %eax,%ebx
  802783:	f7 64 24 0c          	mull   0xc(%esp)
  802787:	39 d6                	cmp    %edx,%esi
  802789:	72 0c                	jb     802797 <__udivdi3+0xb7>
  80278b:	89 f9                	mov    %edi,%ecx
  80278d:	d3 e5                	shl    %cl,%ebp
  80278f:	39 c5                	cmp    %eax,%ebp
  802791:	73 5d                	jae    8027f0 <__udivdi3+0x110>
  802793:	39 d6                	cmp    %edx,%esi
  802795:	75 59                	jne    8027f0 <__udivdi3+0x110>
  802797:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80279a:	31 ff                	xor    %edi,%edi
  80279c:	89 fa                	mov    %edi,%edx
  80279e:	83 c4 1c             	add    $0x1c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    
  8027a6:	8d 76 00             	lea    0x0(%esi),%esi
  8027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8027b0:	31 ff                	xor    %edi,%edi
  8027b2:	31 c0                	xor    %eax,%eax
  8027b4:	89 fa                	mov    %edi,%edx
  8027b6:	83 c4 1c             	add    $0x1c,%esp
  8027b9:	5b                   	pop    %ebx
  8027ba:	5e                   	pop    %esi
  8027bb:	5f                   	pop    %edi
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	31 ff                	xor    %edi,%edi
  8027c2:	89 e8                	mov    %ebp,%eax
  8027c4:	89 f2                	mov    %esi,%edx
  8027c6:	f7 f3                	div    %ebx
  8027c8:	89 fa                	mov    %edi,%edx
  8027ca:	83 c4 1c             	add    $0x1c,%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5f                   	pop    %edi
  8027d0:	5d                   	pop    %ebp
  8027d1:	c3                   	ret    
  8027d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027d8:	39 f2                	cmp    %esi,%edx
  8027da:	72 06                	jb     8027e2 <__udivdi3+0x102>
  8027dc:	31 c0                	xor    %eax,%eax
  8027de:	39 eb                	cmp    %ebp,%ebx
  8027e0:	77 d2                	ja     8027b4 <__udivdi3+0xd4>
  8027e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e7:	eb cb                	jmp    8027b4 <__udivdi3+0xd4>
  8027e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027f0:	89 d8                	mov    %ebx,%eax
  8027f2:	31 ff                	xor    %edi,%edi
  8027f4:	eb be                	jmp    8027b4 <__udivdi3+0xd4>
  8027f6:	66 90                	xchg   %ax,%ax
  8027f8:	66 90                	xchg   %ax,%ax
  8027fa:	66 90                	xchg   %ax,%ax
  8027fc:	66 90                	xchg   %ax,%ax
  8027fe:	66 90                	xchg   %ax,%ax

00802800 <__umoddi3>:
  802800:	55                   	push   %ebp
  802801:	57                   	push   %edi
  802802:	56                   	push   %esi
  802803:	53                   	push   %ebx
  802804:	83 ec 1c             	sub    $0x1c,%esp
  802807:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80280b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80280f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802813:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802817:	85 ed                	test   %ebp,%ebp
  802819:	89 f0                	mov    %esi,%eax
  80281b:	89 da                	mov    %ebx,%edx
  80281d:	75 19                	jne    802838 <__umoddi3+0x38>
  80281f:	39 df                	cmp    %ebx,%edi
  802821:	0f 86 b1 00 00 00    	jbe    8028d8 <__umoddi3+0xd8>
  802827:	f7 f7                	div    %edi
  802829:	89 d0                	mov    %edx,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	83 c4 1c             	add    $0x1c,%esp
  802830:	5b                   	pop    %ebx
  802831:	5e                   	pop    %esi
  802832:	5f                   	pop    %edi
  802833:	5d                   	pop    %ebp
  802834:	c3                   	ret    
  802835:	8d 76 00             	lea    0x0(%esi),%esi
  802838:	39 dd                	cmp    %ebx,%ebp
  80283a:	77 f1                	ja     80282d <__umoddi3+0x2d>
  80283c:	0f bd cd             	bsr    %ebp,%ecx
  80283f:	83 f1 1f             	xor    $0x1f,%ecx
  802842:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802846:	0f 84 b4 00 00 00    	je     802900 <__umoddi3+0x100>
  80284c:	b8 20 00 00 00       	mov    $0x20,%eax
  802851:	89 c2                	mov    %eax,%edx
  802853:	8b 44 24 04          	mov    0x4(%esp),%eax
  802857:	29 c2                	sub    %eax,%edx
  802859:	89 c1                	mov    %eax,%ecx
  80285b:	89 f8                	mov    %edi,%eax
  80285d:	d3 e5                	shl    %cl,%ebp
  80285f:	89 d1                	mov    %edx,%ecx
  802861:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802865:	d3 e8                	shr    %cl,%eax
  802867:	09 c5                	or     %eax,%ebp
  802869:	8b 44 24 04          	mov    0x4(%esp),%eax
  80286d:	89 c1                	mov    %eax,%ecx
  80286f:	d3 e7                	shl    %cl,%edi
  802871:	89 d1                	mov    %edx,%ecx
  802873:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802877:	89 df                	mov    %ebx,%edi
  802879:	d3 ef                	shr    %cl,%edi
  80287b:	89 c1                	mov    %eax,%ecx
  80287d:	89 f0                	mov    %esi,%eax
  80287f:	d3 e3                	shl    %cl,%ebx
  802881:	89 d1                	mov    %edx,%ecx
  802883:	89 fa                	mov    %edi,%edx
  802885:	d3 e8                	shr    %cl,%eax
  802887:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80288c:	09 d8                	or     %ebx,%eax
  80288e:	f7 f5                	div    %ebp
  802890:	d3 e6                	shl    %cl,%esi
  802892:	89 d1                	mov    %edx,%ecx
  802894:	f7 64 24 08          	mull   0x8(%esp)
  802898:	39 d1                	cmp    %edx,%ecx
  80289a:	89 c3                	mov    %eax,%ebx
  80289c:	89 d7                	mov    %edx,%edi
  80289e:	72 06                	jb     8028a6 <__umoddi3+0xa6>
  8028a0:	75 0e                	jne    8028b0 <__umoddi3+0xb0>
  8028a2:	39 c6                	cmp    %eax,%esi
  8028a4:	73 0a                	jae    8028b0 <__umoddi3+0xb0>
  8028a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8028aa:	19 ea                	sbb    %ebp,%edx
  8028ac:	89 d7                	mov    %edx,%edi
  8028ae:	89 c3                	mov    %eax,%ebx
  8028b0:	89 ca                	mov    %ecx,%edx
  8028b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8028b7:	29 de                	sub    %ebx,%esi
  8028b9:	19 fa                	sbb    %edi,%edx
  8028bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8028bf:	89 d0                	mov    %edx,%eax
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 d9                	mov    %ebx,%ecx
  8028c5:	d3 ee                	shr    %cl,%esi
  8028c7:	d3 ea                	shr    %cl,%edx
  8028c9:	09 f0                	or     %esi,%eax
  8028cb:	83 c4 1c             	add    $0x1c,%esp
  8028ce:	5b                   	pop    %ebx
  8028cf:	5e                   	pop    %esi
  8028d0:	5f                   	pop    %edi
  8028d1:	5d                   	pop    %ebp
  8028d2:	c3                   	ret    
  8028d3:	90                   	nop
  8028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	85 ff                	test   %edi,%edi
  8028da:	89 f9                	mov    %edi,%ecx
  8028dc:	75 0b                	jne    8028e9 <__umoddi3+0xe9>
  8028de:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e3:	31 d2                	xor    %edx,%edx
  8028e5:	f7 f7                	div    %edi
  8028e7:	89 c1                	mov    %eax,%ecx
  8028e9:	89 d8                	mov    %ebx,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	f7 f1                	div    %ecx
  8028ef:	89 f0                	mov    %esi,%eax
  8028f1:	f7 f1                	div    %ecx
  8028f3:	e9 31 ff ff ff       	jmp    802829 <__umoddi3+0x29>
  8028f8:	90                   	nop
  8028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802900:	39 dd                	cmp    %ebx,%ebp
  802902:	72 08                	jb     80290c <__umoddi3+0x10c>
  802904:	39 f7                	cmp    %esi,%edi
  802906:	0f 87 21 ff ff ff    	ja     80282d <__umoddi3+0x2d>
  80290c:	89 da                	mov    %ebx,%edx
  80290e:	89 f0                	mov    %esi,%eax
  802910:	29 f8                	sub    %edi,%eax
  802912:	19 ea                	sbb    %ebp,%edx
  802914:	e9 14 ff ff ff       	jmp    80282d <__umoddi3+0x2d>

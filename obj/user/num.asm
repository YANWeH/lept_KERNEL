
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 52 01 00 00       	call   800183 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	eb 1b                	jmp    80005e <num+0x2b>
		if (bol) {
			printf("%5d ", ++line);
			bol = 0;
		}
		if ((r = write(1, &c, 1)) != 1)
  800043:	83 ec 04             	sub    $0x4,%esp
  800046:	6a 01                	push   $0x1
  800048:	53                   	push   %ebx
  800049:	6a 01                	push   $0x1
  80004b:	e8 4b 12 00 00       	call   80129b <write>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	83 f8 01             	cmp    $0x1,%eax
  800056:	75 4c                	jne    8000a4 <num+0x71>
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
  800058:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  80005c:	74 5e                	je     8000bc <num+0x89>
	while ((n = read(f, &c, 1)) > 0) {
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	6a 01                	push   $0x1
  800063:	53                   	push   %ebx
  800064:	56                   	push   %esi
  800065:	e8 63 11 00 00       	call   8011cd <read>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	85 c0                	test   %eax,%eax
  80006f:	7e 57                	jle    8000c8 <num+0x95>
		if (bol) {
  800071:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  800078:	74 c9                	je     800043 <num+0x10>
			printf("%5d ", ++line);
  80007a:	a1 00 40 80 00       	mov    0x804000,%eax
  80007f:	83 c0 01             	add    $0x1,%eax
  800082:	a3 00 40 80 00       	mov    %eax,0x804000
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	50                   	push   %eax
  80008b:	68 a0 24 80 00       	push   $0x8024a0
  800090:	e8 41 17 00 00       	call   8017d6 <printf>
			bol = 0;
  800095:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  80009c:	00 00 00 
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	eb 9f                	jmp    800043 <num+0x10>
			panic("write error copying %s: %e", s, r);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	50                   	push   %eax
  8000a8:	ff 75 0c             	pushl  0xc(%ebp)
  8000ab:	68 a5 24 80 00       	push   $0x8024a5
  8000b0:	6a 13                	push   $0x13
  8000b2:	68 c0 24 80 00       	push   $0x8024c0
  8000b7:	e8 27 01 00 00       	call   8001e3 <_panic>
			bol = 1;
  8000bc:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c3:	00 00 00 
  8000c6:	eb 96                	jmp    80005e <num+0x2b>
	}
	if (n < 0)
  8000c8:	85 c0                	test   %eax,%eax
  8000ca:	78 07                	js     8000d3 <num+0xa0>
		panic("error reading %s: %e", s, n);
}
  8000cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	50                   	push   %eax
  8000d7:	ff 75 0c             	pushl  0xc(%ebp)
  8000da:	68 cb 24 80 00       	push   $0x8024cb
  8000df:	6a 18                	push   $0x18
  8000e1:	68 c0 24 80 00       	push   $0x8024c0
  8000e6:	e8 f8 00 00 00       	call   8001e3 <_panic>

008000eb <umain>:

void
umain(int argc, char **argv)
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 1c             	sub    $0x1c,%esp
	int f, i;

	binaryname = "num";
  8000f4:	c7 05 04 30 80 00 e0 	movl   $0x8024e0,0x803004
  8000fb:	24 80 00 
	if (argc == 1)
  8000fe:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800102:	74 46                	je     80014a <umain+0x5f>
  800104:	8b 45 0c             	mov    0xc(%ebp),%eax
  800107:	8d 58 04             	lea    0x4(%eax),%ebx
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  80010a:	bf 01 00 00 00       	mov    $0x1,%edi
  80010f:	3b 7d 08             	cmp    0x8(%ebp),%edi
  800112:	7d 48                	jge    80015c <umain+0x71>
			f = open(argv[i], O_RDONLY);
  800114:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	6a 00                	push   $0x0
  80011c:	ff 33                	pushl  (%ebx)
  80011e:	e8 0f 15 00 00       	call   801632 <open>
  800123:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	85 c0                	test   %eax,%eax
  80012a:	78 3d                	js     800169 <umain+0x7e>
				panic("can't open %s: %e", argv[i], f);
			else {
				num(f, argv[i]);
  80012c:	83 ec 08             	sub    $0x8,%esp
  80012f:	ff 33                	pushl  (%ebx)
  800131:	50                   	push   %eax
  800132:	e8 fc fe ff ff       	call   800033 <num>
				close(f);
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 52 0f 00 00       	call   801091 <close>
		for (i = 1; i < argc; i++) {
  80013f:	83 c7 01             	add    $0x1,%edi
  800142:	83 c3 04             	add    $0x4,%ebx
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	eb c5                	jmp    80010f <umain+0x24>
		num(0, "<stdin>");
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	68 e4 24 80 00       	push   $0x8024e4
  800152:	6a 00                	push   $0x0
  800154:	e8 da fe ff ff       	call   800033 <num>
  800159:	83 c4 10             	add    $0x10,%esp
			}
		}
	exit();
  80015c:	e8 68 00 00 00       	call   8001c9 <exit>
}
  800161:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
				panic("can't open %s: %e", argv[i], f);
  800169:	83 ec 0c             	sub    $0xc,%esp
  80016c:	50                   	push   %eax
  80016d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800170:	ff 30                	pushl  (%eax)
  800172:	68 ec 24 80 00       	push   $0x8024ec
  800177:	6a 27                	push   $0x27
  800179:	68 c0 24 80 00       	push   $0x8024c0
  80017e:	e8 60 00 00 00       	call   8001e3 <_panic>

00800183 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	56                   	push   %esi
  800187:	53                   	push   %ebx
  800188:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80018b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80018e:	e8 05 0b 00 00       	call   800c98 <sys_getenvid>
  800193:	25 ff 03 00 00       	and    $0x3ff,%eax
  800198:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80019b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a0:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a5:	85 db                	test   %ebx,%ebx
  8001a7:	7e 07                	jle    8001b0 <libmain+0x2d>
		binaryname = argv[0];
  8001a9:	8b 06                	mov    (%esi),%eax
  8001ab:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001b0:	83 ec 08             	sub    $0x8,%esp
  8001b3:	56                   	push   %esi
  8001b4:	53                   	push   %ebx
  8001b5:	e8 31 ff ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8001ba:	e8 0a 00 00 00       	call   8001c9 <exit>
}
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001c5:	5b                   	pop    %ebx
  8001c6:	5e                   	pop    %esi
  8001c7:	5d                   	pop    %ebp
  8001c8:	c3                   	ret    

008001c9 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001cf:	e8 e8 0e 00 00       	call   8010bc <close_all>
	sys_env_destroy(0);
  8001d4:	83 ec 0c             	sub    $0xc,%esp
  8001d7:	6a 00                	push   $0x0
  8001d9:	e8 79 0a 00 00       	call   800c57 <sys_env_destroy>
}
  8001de:	83 c4 10             	add    $0x10,%esp
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	56                   	push   %esi
  8001e7:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001e8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001eb:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8001f1:	e8 a2 0a 00 00       	call   800c98 <sys_getenvid>
  8001f6:	83 ec 0c             	sub    $0xc,%esp
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	56                   	push   %esi
  800200:	50                   	push   %eax
  800201:	68 08 25 80 00       	push   $0x802508
  800206:	e8 b3 00 00 00       	call   8002be <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80020b:	83 c4 18             	add    $0x18,%esp
  80020e:	53                   	push   %ebx
  80020f:	ff 75 10             	pushl  0x10(%ebp)
  800212:	e8 56 00 00 00       	call   80026d <vcprintf>
	cprintf("\n");
  800217:	c7 04 24 64 29 80 00 	movl   $0x802964,(%esp)
  80021e:	e8 9b 00 00 00       	call   8002be <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800226:	cc                   	int3   
  800227:	eb fd                	jmp    800226 <_panic+0x43>

00800229 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	53                   	push   %ebx
  80022d:	83 ec 04             	sub    $0x4,%esp
  800230:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800233:	8b 13                	mov    (%ebx),%edx
  800235:	8d 42 01             	lea    0x1(%edx),%eax
  800238:	89 03                	mov    %eax,(%ebx)
  80023a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80023d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800241:	3d ff 00 00 00       	cmp    $0xff,%eax
  800246:	74 09                	je     800251 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800248:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80024f:	c9                   	leave  
  800250:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	68 ff 00 00 00       	push   $0xff
  800259:	8d 43 08             	lea    0x8(%ebx),%eax
  80025c:	50                   	push   %eax
  80025d:	e8 b8 09 00 00       	call   800c1a <sys_cputs>
		b->idx = 0;
  800262:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800268:	83 c4 10             	add    $0x10,%esp
  80026b:	eb db                	jmp    800248 <putch+0x1f>

0080026d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800276:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80027d:	00 00 00 
	b.cnt = 0;
  800280:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800287:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 08             	pushl  0x8(%ebp)
  800290:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800296:	50                   	push   %eax
  800297:	68 29 02 80 00       	push   $0x800229
  80029c:	e8 1a 01 00 00       	call   8003bb <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a1:	83 c4 08             	add    $0x8,%esp
  8002a4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002aa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 64 09 00 00       	call   800c1a <sys_cputs>

	return b.cnt;
}
  8002b6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c7:	50                   	push   %eax
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	e8 9d ff ff ff       	call   80026d <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	57                   	push   %edi
  8002d6:	56                   	push   %esi
  8002d7:	53                   	push   %ebx
  8002d8:	83 ec 1c             	sub    $0x1c,%esp
  8002db:	89 c7                	mov    %eax,%edi
  8002dd:	89 d6                	mov    %edx,%esi
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002f6:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002f9:	39 d3                	cmp    %edx,%ebx
  8002fb:	72 05                	jb     800302 <printnum+0x30>
  8002fd:	39 45 10             	cmp    %eax,0x10(%ebp)
  800300:	77 7a                	ja     80037c <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800302:	83 ec 0c             	sub    $0xc,%esp
  800305:	ff 75 18             	pushl  0x18(%ebp)
  800308:	8b 45 14             	mov    0x14(%ebp),%eax
  80030b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80030e:	53                   	push   %ebx
  80030f:	ff 75 10             	pushl  0x10(%ebp)
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	ff 75 e4             	pushl  -0x1c(%ebp)
  800318:	ff 75 e0             	pushl  -0x20(%ebp)
  80031b:	ff 75 dc             	pushl  -0x24(%ebp)
  80031e:	ff 75 d8             	pushl  -0x28(%ebp)
  800321:	e8 2a 1f 00 00       	call   802250 <__udivdi3>
  800326:	83 c4 18             	add    $0x18,%esp
  800329:	52                   	push   %edx
  80032a:	50                   	push   %eax
  80032b:	89 f2                	mov    %esi,%edx
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	e8 9e ff ff ff       	call   8002d2 <printnum>
  800334:	83 c4 20             	add    $0x20,%esp
  800337:	eb 13                	jmp    80034c <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	56                   	push   %esi
  80033d:	ff 75 18             	pushl  0x18(%ebp)
  800340:	ff d7                	call   *%edi
  800342:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800345:	83 eb 01             	sub    $0x1,%ebx
  800348:	85 db                	test   %ebx,%ebx
  80034a:	7f ed                	jg     800339 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	83 ec 04             	sub    $0x4,%esp
  800353:	ff 75 e4             	pushl  -0x1c(%ebp)
  800356:	ff 75 e0             	pushl  -0x20(%ebp)
  800359:	ff 75 dc             	pushl  -0x24(%ebp)
  80035c:	ff 75 d8             	pushl  -0x28(%ebp)
  80035f:	e8 0c 20 00 00       	call   802370 <__umoddi3>
  800364:	83 c4 14             	add    $0x14,%esp
  800367:	0f be 80 2b 25 80 00 	movsbl 0x80252b(%eax),%eax
  80036e:	50                   	push   %eax
  80036f:	ff d7                	call   *%edi
}
  800371:	83 c4 10             	add    $0x10,%esp
  800374:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	5d                   	pop    %ebp
  80037b:	c3                   	ret    
  80037c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80037f:	eb c4                	jmp    800345 <printnum+0x73>

00800381 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800387:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80038b:	8b 10                	mov    (%eax),%edx
  80038d:	3b 50 04             	cmp    0x4(%eax),%edx
  800390:	73 0a                	jae    80039c <sprintputch+0x1b>
		*b->buf++ = ch;
  800392:	8d 4a 01             	lea    0x1(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	88 02                	mov    %al,(%edx)
}
  80039c:	5d                   	pop    %ebp
  80039d:	c3                   	ret    

0080039e <printfmt>:
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003a4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a7:	50                   	push   %eax
  8003a8:	ff 75 10             	pushl  0x10(%ebp)
  8003ab:	ff 75 0c             	pushl  0xc(%ebp)
  8003ae:	ff 75 08             	pushl  0x8(%ebp)
  8003b1:	e8 05 00 00 00       	call   8003bb <vprintfmt>
}
  8003b6:	83 c4 10             	add    $0x10,%esp
  8003b9:	c9                   	leave  
  8003ba:	c3                   	ret    

008003bb <vprintfmt>:
{
  8003bb:	55                   	push   %ebp
  8003bc:	89 e5                	mov    %esp,%ebp
  8003be:	57                   	push   %edi
  8003bf:	56                   	push   %esi
  8003c0:	53                   	push   %ebx
  8003c1:	83 ec 2c             	sub    $0x2c,%esp
  8003c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003ca:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003cd:	e9 c1 03 00 00       	jmp    800793 <vprintfmt+0x3d8>
		padc = ' ';
  8003d2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003dd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003eb:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8d 47 01             	lea    0x1(%edi),%eax
  8003f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003f6:	0f b6 17             	movzbl (%edi),%edx
  8003f9:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003fc:	3c 55                	cmp    $0x55,%al
  8003fe:	0f 87 12 04 00 00    	ja     800816 <vprintfmt+0x45b>
  800404:	0f b6 c0             	movzbl %al,%eax
  800407:	ff 24 85 60 26 80 00 	jmp    *0x802660(,%eax,4)
  80040e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800411:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800415:	eb d9                	jmp    8003f0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800417:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80041a:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80041e:	eb d0                	jmp    8003f0 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800420:	0f b6 d2             	movzbl %dl,%edx
  800423:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80042e:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800431:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800435:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800438:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80043b:	83 f9 09             	cmp    $0x9,%ecx
  80043e:	77 55                	ja     800495 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800440:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800443:	eb e9                	jmp    80042e <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800445:	8b 45 14             	mov    0x14(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80044d:	8b 45 14             	mov    0x14(%ebp),%eax
  800450:	8d 40 04             	lea    0x4(%eax),%eax
  800453:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800456:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800459:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045d:	79 91                	jns    8003f0 <vprintfmt+0x35>
				width = precision, precision = -1;
  80045f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800465:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80046c:	eb 82                	jmp    8003f0 <vprintfmt+0x35>
  80046e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800471:	85 c0                	test   %eax,%eax
  800473:	ba 00 00 00 00       	mov    $0x0,%edx
  800478:	0f 49 d0             	cmovns %eax,%edx
  80047b:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800481:	e9 6a ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
  800486:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800489:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800490:	e9 5b ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
  800495:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800498:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049b:	eb bc                	jmp    800459 <vprintfmt+0x9e>
			lflag++;
  80049d:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a3:	e9 48 ff ff ff       	jmp    8003f0 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 78 04             	lea    0x4(%eax),%edi
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	53                   	push   %ebx
  8004b2:	ff 30                	pushl  (%eax)
  8004b4:	ff d6                	call   *%esi
			break;
  8004b6:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004b9:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004bc:	e9 cf 02 00 00       	jmp    800790 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 78 04             	lea    0x4(%eax),%edi
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	31 d0                	xor    %edx,%eax
  8004cc:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ce:	83 f8 0f             	cmp    $0xf,%eax
  8004d1:	7f 23                	jg     8004f6 <vprintfmt+0x13b>
  8004d3:	8b 14 85 c0 27 80 00 	mov    0x8027c0(,%eax,4),%edx
  8004da:	85 d2                	test   %edx,%edx
  8004dc:	74 18                	je     8004f6 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004de:	52                   	push   %edx
  8004df:	68 f9 28 80 00       	push   $0x8028f9
  8004e4:	53                   	push   %ebx
  8004e5:	56                   	push   %esi
  8004e6:	e8 b3 fe ff ff       	call   80039e <printfmt>
  8004eb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ee:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f1:	e9 9a 02 00 00       	jmp    800790 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8004f6:	50                   	push   %eax
  8004f7:	68 43 25 80 00       	push   $0x802543
  8004fc:	53                   	push   %ebx
  8004fd:	56                   	push   %esi
  8004fe:	e8 9b fe ff ff       	call   80039e <printfmt>
  800503:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800506:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800509:	e9 82 02 00 00       	jmp    800790 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80050e:	8b 45 14             	mov    0x14(%ebp),%eax
  800511:	83 c0 04             	add    $0x4,%eax
  800514:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800517:	8b 45 14             	mov    0x14(%ebp),%eax
  80051a:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80051c:	85 ff                	test   %edi,%edi
  80051e:	b8 3c 25 80 00       	mov    $0x80253c,%eax
  800523:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800526:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80052a:	0f 8e bd 00 00 00    	jle    8005ed <vprintfmt+0x232>
  800530:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800534:	75 0e                	jne    800544 <vprintfmt+0x189>
  800536:	89 75 08             	mov    %esi,0x8(%ebp)
  800539:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800542:	eb 6d                	jmp    8005b1 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800544:	83 ec 08             	sub    $0x8,%esp
  800547:	ff 75 d0             	pushl  -0x30(%ebp)
  80054a:	57                   	push   %edi
  80054b:	e8 6e 03 00 00       	call   8008be <strnlen>
  800550:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800553:	29 c1                	sub    %eax,%ecx
  800555:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800558:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80055b:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80055f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800562:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800565:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	eb 0f                	jmp    800578 <vprintfmt+0x1bd>
					putch(padc, putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	ff 75 e0             	pushl  -0x20(%ebp)
  800570:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800572:	83 ef 01             	sub    $0x1,%edi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 ff                	test   %edi,%edi
  80057a:	7f ed                	jg     800569 <vprintfmt+0x1ae>
  80057c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80057f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800582:	85 c9                	test   %ecx,%ecx
  800584:	b8 00 00 00 00       	mov    $0x0,%eax
  800589:	0f 49 c1             	cmovns %ecx,%eax
  80058c:	29 c1                	sub    %eax,%ecx
  80058e:	89 75 08             	mov    %esi,0x8(%ebp)
  800591:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800594:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800597:	89 cb                	mov    %ecx,%ebx
  800599:	eb 16                	jmp    8005b1 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  80059b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80059f:	75 31                	jne    8005d2 <vprintfmt+0x217>
					putch(ch, putdat);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	50                   	push   %eax
  8005a8:	ff 55 08             	call   *0x8(%ebp)
  8005ab:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ae:	83 eb 01             	sub    $0x1,%ebx
  8005b1:	83 c7 01             	add    $0x1,%edi
  8005b4:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005b8:	0f be c2             	movsbl %dl,%eax
  8005bb:	85 c0                	test   %eax,%eax
  8005bd:	74 59                	je     800618 <vprintfmt+0x25d>
  8005bf:	85 f6                	test   %esi,%esi
  8005c1:	78 d8                	js     80059b <vprintfmt+0x1e0>
  8005c3:	83 ee 01             	sub    $0x1,%esi
  8005c6:	79 d3                	jns    80059b <vprintfmt+0x1e0>
  8005c8:	89 df                	mov    %ebx,%edi
  8005ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8005cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005d0:	eb 37                	jmp    800609 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d2:	0f be d2             	movsbl %dl,%edx
  8005d5:	83 ea 20             	sub    $0x20,%edx
  8005d8:	83 fa 5e             	cmp    $0x5e,%edx
  8005db:	76 c4                	jbe    8005a1 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	ff 75 0c             	pushl  0xc(%ebp)
  8005e3:	6a 3f                	push   $0x3f
  8005e5:	ff 55 08             	call   *0x8(%ebp)
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	eb c1                	jmp    8005ae <vprintfmt+0x1f3>
  8005ed:	89 75 08             	mov    %esi,0x8(%ebp)
  8005f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005f3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005f6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005f9:	eb b6                	jmp    8005b1 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005fb:	83 ec 08             	sub    $0x8,%esp
  8005fe:	53                   	push   %ebx
  8005ff:	6a 20                	push   $0x20
  800601:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800603:	83 ef 01             	sub    $0x1,%edi
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	85 ff                	test   %edi,%edi
  80060b:	7f ee                	jg     8005fb <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80060d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	e9 78 01 00 00       	jmp    800790 <vprintfmt+0x3d5>
  800618:	89 df                	mov    %ebx,%edi
  80061a:	8b 75 08             	mov    0x8(%ebp),%esi
  80061d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800620:	eb e7                	jmp    800609 <vprintfmt+0x24e>
	if (lflag >= 2)
  800622:	83 f9 01             	cmp    $0x1,%ecx
  800625:	7e 3f                	jle    800666 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8b 50 04             	mov    0x4(%eax),%edx
  80062d:	8b 00                	mov    (%eax),%eax
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 40 08             	lea    0x8(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80063e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800642:	79 5c                	jns    8006a0 <vprintfmt+0x2e5>
				putch('-', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 2d                	push   $0x2d
  80064a:	ff d6                	call   *%esi
				num = -(long long) num;
  80064c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80064f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800652:	f7 da                	neg    %edx
  800654:	83 d1 00             	adc    $0x0,%ecx
  800657:	f7 d9                	neg    %ecx
  800659:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80065c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800661:	e9 10 01 00 00       	jmp    800776 <vprintfmt+0x3bb>
	else if (lflag)
  800666:	85 c9                	test   %ecx,%ecx
  800668:	75 1b                	jne    800685 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800672:	89 c1                	mov    %eax,%ecx
  800674:	c1 f9 1f             	sar    $0x1f,%ecx
  800677:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8d 40 04             	lea    0x4(%eax),%eax
  800680:	89 45 14             	mov    %eax,0x14(%ebp)
  800683:	eb b9                	jmp    80063e <vprintfmt+0x283>
		return va_arg(*ap, long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 00                	mov    (%eax),%eax
  80068a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068d:	89 c1                	mov    %eax,%ecx
  80068f:	c1 f9 1f             	sar    $0x1f,%ecx
  800692:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
  80069e:	eb 9e                	jmp    80063e <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006a6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ab:	e9 c6 00 00 00       	jmp    800776 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006b0:	83 f9 01             	cmp    $0x1,%ecx
  8006b3:	7e 18                	jle    8006cd <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	8b 48 04             	mov    0x4(%eax),%ecx
  8006bd:	8d 40 08             	lea    0x8(%eax),%eax
  8006c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006c3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c8:	e9 a9 00 00 00       	jmp    800776 <vprintfmt+0x3bb>
	else if (lflag)
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	75 1a                	jne    8006eb <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8b 10                	mov    (%eax),%edx
  8006d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006db:	8d 40 04             	lea    0x4(%eax),%eax
  8006de:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006e6:	e9 8b 00 00 00       	jmp    800776 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006fb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800700:	eb 74                	jmp    800776 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800702:	83 f9 01             	cmp    $0x1,%ecx
  800705:	7e 15                	jle    80071c <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	8b 48 04             	mov    0x4(%eax),%ecx
  80070f:	8d 40 08             	lea    0x8(%eax),%eax
  800712:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800715:	b8 08 00 00 00       	mov    $0x8,%eax
  80071a:	eb 5a                	jmp    800776 <vprintfmt+0x3bb>
	else if (lflag)
  80071c:	85 c9                	test   %ecx,%ecx
  80071e:	75 17                	jne    800737 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 10                	mov    (%eax),%edx
  800725:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800730:	b8 08 00 00 00       	mov    $0x8,%eax
  800735:	eb 3f                	jmp    800776 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8b 10                	mov    (%eax),%edx
  80073c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800747:	b8 08 00 00 00       	mov    $0x8,%eax
  80074c:	eb 28                	jmp    800776 <vprintfmt+0x3bb>
			putch('0', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 30                	push   $0x30
  800754:	ff d6                	call   *%esi
			putch('x', putdat);
  800756:	83 c4 08             	add    $0x8,%esp
  800759:	53                   	push   %ebx
  80075a:	6a 78                	push   $0x78
  80075c:	ff d6                	call   *%esi
			num = (unsigned long long)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 10                	mov    (%eax),%edx
  800763:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800768:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80076b:	8d 40 04             	lea    0x4(%eax),%eax
  80076e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800771:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800776:	83 ec 0c             	sub    $0xc,%esp
  800779:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80077d:	57                   	push   %edi
  80077e:	ff 75 e0             	pushl  -0x20(%ebp)
  800781:	50                   	push   %eax
  800782:	51                   	push   %ecx
  800783:	52                   	push   %edx
  800784:	89 da                	mov    %ebx,%edx
  800786:	89 f0                	mov    %esi,%eax
  800788:	e8 45 fb ff ff       	call   8002d2 <printnum>
			break;
  80078d:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800790:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800793:	83 c7 01             	add    $0x1,%edi
  800796:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80079a:	83 f8 25             	cmp    $0x25,%eax
  80079d:	0f 84 2f fc ff ff    	je     8003d2 <vprintfmt+0x17>
			if (ch == '\0')
  8007a3:	85 c0                	test   %eax,%eax
  8007a5:	0f 84 8b 00 00 00    	je     800836 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	53                   	push   %ebx
  8007af:	50                   	push   %eax
  8007b0:	ff d6                	call   *%esi
  8007b2:	83 c4 10             	add    $0x10,%esp
  8007b5:	eb dc                	jmp    800793 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8007b7:	83 f9 01             	cmp    $0x1,%ecx
  8007ba:	7e 15                	jle    8007d1 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 10                	mov    (%eax),%edx
  8007c1:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c4:	8d 40 08             	lea    0x8(%eax),%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ca:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cf:	eb a5                	jmp    800776 <vprintfmt+0x3bb>
	else if (lflag)
  8007d1:	85 c9                	test   %ecx,%ecx
  8007d3:	75 17                	jne    8007ec <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8b 10                	mov    (%eax),%edx
  8007da:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007df:	8d 40 04             	lea    0x4(%eax),%eax
  8007e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ea:	eb 8a                	jmp    800776 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	8b 10                	mov    (%eax),%edx
  8007f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f6:	8d 40 04             	lea    0x4(%eax),%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800801:	e9 70 ff ff ff       	jmp    800776 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800806:	83 ec 08             	sub    $0x8,%esp
  800809:	53                   	push   %ebx
  80080a:	6a 25                	push   $0x25
  80080c:	ff d6                	call   *%esi
			break;
  80080e:	83 c4 10             	add    $0x10,%esp
  800811:	e9 7a ff ff ff       	jmp    800790 <vprintfmt+0x3d5>
			putch('%', putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	6a 25                	push   $0x25
  80081c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	89 f8                	mov    %edi,%eax
  800823:	eb 03                	jmp    800828 <vprintfmt+0x46d>
  800825:	83 e8 01             	sub    $0x1,%eax
  800828:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80082c:	75 f7                	jne    800825 <vprintfmt+0x46a>
  80082e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800831:	e9 5a ff ff ff       	jmp    800790 <vprintfmt+0x3d5>
}
  800836:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800839:	5b                   	pop    %ebx
  80083a:	5e                   	pop    %esi
  80083b:	5f                   	pop    %edi
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	83 ec 18             	sub    $0x18,%esp
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80084a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80084d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800851:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800854:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80085b:	85 c0                	test   %eax,%eax
  80085d:	74 26                	je     800885 <vsnprintf+0x47>
  80085f:	85 d2                	test   %edx,%edx
  800861:	7e 22                	jle    800885 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800863:	ff 75 14             	pushl  0x14(%ebp)
  800866:	ff 75 10             	pushl  0x10(%ebp)
  800869:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	68 81 03 80 00       	push   $0x800381
  800872:	e8 44 fb ff ff       	call   8003bb <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	c9                   	leave  
  800884:	c3                   	ret    
		return -E_INVAL;
  800885:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088a:	eb f7                	jmp    800883 <vsnprintf+0x45>

0080088c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800892:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800895:	50                   	push   %eax
  800896:	ff 75 10             	pushl  0x10(%ebp)
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	ff 75 08             	pushl  0x8(%ebp)
  80089f:	e8 9a ff ff ff       	call   80083e <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a4:	c9                   	leave  
  8008a5:	c3                   	ret    

008008a6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b1:	eb 03                	jmp    8008b6 <strlen+0x10>
		n++;
  8008b3:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008b6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ba:	75 f7                	jne    8008b3 <strlen+0xd>
	return n;
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c4:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cc:	eb 03                	jmp    8008d1 <strnlen+0x13>
		n++;
  8008ce:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	39 d0                	cmp    %edx,%eax
  8008d3:	74 06                	je     8008db <strnlen+0x1d>
  8008d5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d9:	75 f3                	jne    8008ce <strnlen+0x10>
	return n;
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	53                   	push   %ebx
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e7:	89 c2                	mov    %eax,%edx
  8008e9:	83 c1 01             	add    $0x1,%ecx
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008f3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f6:	84 db                	test   %bl,%bl
  8008f8:	75 ef                	jne    8008e9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008fa:	5b                   	pop    %ebx
  8008fb:	5d                   	pop    %ebp
  8008fc:	c3                   	ret    

008008fd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008fd:	55                   	push   %ebp
  8008fe:	89 e5                	mov    %esp,%ebp
  800900:	53                   	push   %ebx
  800901:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800904:	53                   	push   %ebx
  800905:	e8 9c ff ff ff       	call   8008a6 <strlen>
  80090a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	01 d8                	add    %ebx,%eax
  800912:	50                   	push   %eax
  800913:	e8 c5 ff ff ff       	call   8008dd <strcpy>
	return dst;
}
  800918:	89 d8                	mov    %ebx,%eax
  80091a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80091d:	c9                   	leave  
  80091e:	c3                   	ret    

0080091f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	56                   	push   %esi
  800923:	53                   	push   %ebx
  800924:	8b 75 08             	mov    0x8(%ebp),%esi
  800927:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092a:	89 f3                	mov    %esi,%ebx
  80092c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092f:	89 f2                	mov    %esi,%edx
  800931:	eb 0f                	jmp    800942 <strncpy+0x23>
		*dst++ = *src;
  800933:	83 c2 01             	add    $0x1,%edx
  800936:	0f b6 01             	movzbl (%ecx),%eax
  800939:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093c:	80 39 01             	cmpb   $0x1,(%ecx)
  80093f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800942:	39 da                	cmp    %ebx,%edx
  800944:	75 ed                	jne    800933 <strncpy+0x14>
	}
	return ret;
}
  800946:	89 f0                	mov    %esi,%eax
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	56                   	push   %esi
  800950:	53                   	push   %ebx
  800951:	8b 75 08             	mov    0x8(%ebp),%esi
  800954:	8b 55 0c             	mov    0xc(%ebp),%edx
  800957:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095a:	89 f0                	mov    %esi,%eax
  80095c:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800960:	85 c9                	test   %ecx,%ecx
  800962:	75 0b                	jne    80096f <strlcpy+0x23>
  800964:	eb 17                	jmp    80097d <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800966:	83 c2 01             	add    $0x1,%edx
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80096f:	39 d8                	cmp    %ebx,%eax
  800971:	74 07                	je     80097a <strlcpy+0x2e>
  800973:	0f b6 0a             	movzbl (%edx),%ecx
  800976:	84 c9                	test   %cl,%cl
  800978:	75 ec                	jne    800966 <strlcpy+0x1a>
		*dst = '\0';
  80097a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097d:	29 f0                	sub    %esi,%eax
}
  80097f:	5b                   	pop    %ebx
  800980:	5e                   	pop    %esi
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098c:	eb 06                	jmp    800994 <strcmp+0x11>
		p++, q++;
  80098e:	83 c1 01             	add    $0x1,%ecx
  800991:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800994:	0f b6 01             	movzbl (%ecx),%eax
  800997:	84 c0                	test   %al,%al
  800999:	74 04                	je     80099f <strcmp+0x1c>
  80099b:	3a 02                	cmp    (%edx),%al
  80099d:	74 ef                	je     80098e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80099f:	0f b6 c0             	movzbl %al,%eax
  8009a2:	0f b6 12             	movzbl (%edx),%edx
  8009a5:	29 d0                	sub    %edx,%eax
}
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	53                   	push   %ebx
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b3:	89 c3                	mov    %eax,%ebx
  8009b5:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b8:	eb 06                	jmp    8009c0 <strncmp+0x17>
		n--, p++, q++;
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009c0:	39 d8                	cmp    %ebx,%eax
  8009c2:	74 16                	je     8009da <strncmp+0x31>
  8009c4:	0f b6 08             	movzbl (%eax),%ecx
  8009c7:	84 c9                	test   %cl,%cl
  8009c9:	74 04                	je     8009cf <strncmp+0x26>
  8009cb:	3a 0a                	cmp    (%edx),%cl
  8009cd:	74 eb                	je     8009ba <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cf:	0f b6 00             	movzbl (%eax),%eax
  8009d2:	0f b6 12             	movzbl (%edx),%edx
  8009d5:	29 d0                	sub    %edx,%eax
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    
		return 0;
  8009da:	b8 00 00 00 00       	mov    $0x0,%eax
  8009df:	eb f6                	jmp    8009d7 <strncmp+0x2e>

008009e1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009eb:	0f b6 10             	movzbl (%eax),%edx
  8009ee:	84 d2                	test   %dl,%dl
  8009f0:	74 09                	je     8009fb <strchr+0x1a>
		if (*s == c)
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	74 0a                	je     800a00 <strchr+0x1f>
	for (; *s; s++)
  8009f6:	83 c0 01             	add    $0x1,%eax
  8009f9:	eb f0                	jmp    8009eb <strchr+0xa>
			return (char *) s;
	return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0c:	eb 03                	jmp    800a11 <strfind+0xf>
  800a0e:	83 c0 01             	add    $0x1,%eax
  800a11:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a14:	38 ca                	cmp    %cl,%dl
  800a16:	74 04                	je     800a1c <strfind+0x1a>
  800a18:	84 d2                	test   %dl,%dl
  800a1a:	75 f2                	jne    800a0e <strfind+0xc>
			break;
	return (char *) s;
}
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    

00800a1e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a1e:	55                   	push   %ebp
  800a1f:	89 e5                	mov    %esp,%ebp
  800a21:	57                   	push   %edi
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a27:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a2a:	85 c9                	test   %ecx,%ecx
  800a2c:	74 13                	je     800a41 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a34:	75 05                	jne    800a3b <memset+0x1d>
  800a36:	f6 c1 03             	test   $0x3,%cl
  800a39:	74 0d                	je     800a48 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	fc                   	cld    
  800a3f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a41:	89 f8                	mov    %edi,%eax
  800a43:	5b                   	pop    %ebx
  800a44:	5e                   	pop    %esi
  800a45:	5f                   	pop    %edi
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    
		c &= 0xFF;
  800a48:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a4c:	89 d3                	mov    %edx,%ebx
  800a4e:	c1 e3 08             	shl    $0x8,%ebx
  800a51:	89 d0                	mov    %edx,%eax
  800a53:	c1 e0 18             	shl    $0x18,%eax
  800a56:	89 d6                	mov    %edx,%esi
  800a58:	c1 e6 10             	shl    $0x10,%esi
  800a5b:	09 f0                	or     %esi,%eax
  800a5d:	09 c2                	or     %eax,%edx
  800a5f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a61:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	fc                   	cld    
  800a67:	f3 ab                	rep stos %eax,%es:(%edi)
  800a69:	eb d6                	jmp    800a41 <memset+0x23>

00800a6b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	57                   	push   %edi
  800a6f:	56                   	push   %esi
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a79:	39 c6                	cmp    %eax,%esi
  800a7b:	73 35                	jae    800ab2 <memmove+0x47>
  800a7d:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a80:	39 c2                	cmp    %eax,%edx
  800a82:	76 2e                	jbe    800ab2 <memmove+0x47>
		s += n;
		d += n;
  800a84:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a87:	89 d6                	mov    %edx,%esi
  800a89:	09 fe                	or     %edi,%esi
  800a8b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a91:	74 0c                	je     800a9f <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a93:	83 ef 01             	sub    $0x1,%edi
  800a96:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a99:	fd                   	std    
  800a9a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a9c:	fc                   	cld    
  800a9d:	eb 21                	jmp    800ac0 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9f:	f6 c1 03             	test   $0x3,%cl
  800aa2:	75 ef                	jne    800a93 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa4:	83 ef 04             	sub    $0x4,%edi
  800aa7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aaa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aad:	fd                   	std    
  800aae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ab0:	eb ea                	jmp    800a9c <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab2:	89 f2                	mov    %esi,%edx
  800ab4:	09 c2                	or     %eax,%edx
  800ab6:	f6 c2 03             	test   $0x3,%dl
  800ab9:	74 09                	je     800ac4 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800abb:	89 c7                	mov    %eax,%edi
  800abd:	fc                   	cld    
  800abe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac4:	f6 c1 03             	test   $0x3,%cl
  800ac7:	75 f2                	jne    800abb <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad1:	eb ed                	jmp    800ac0 <memmove+0x55>

00800ad3 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ad6:	ff 75 10             	pushl  0x10(%ebp)
  800ad9:	ff 75 0c             	pushl  0xc(%ebp)
  800adc:	ff 75 08             	pushl  0x8(%ebp)
  800adf:	e8 87 ff ff ff       	call   800a6b <memmove>
}
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	56                   	push   %esi
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	89 c6                	mov    %eax,%esi
  800af3:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af6:	39 f0                	cmp    %esi,%eax
  800af8:	74 1c                	je     800b16 <memcmp+0x30>
		if (*s1 != *s2)
  800afa:	0f b6 08             	movzbl (%eax),%ecx
  800afd:	0f b6 1a             	movzbl (%edx),%ebx
  800b00:	38 d9                	cmp    %bl,%cl
  800b02:	75 08                	jne    800b0c <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b04:	83 c0 01             	add    $0x1,%eax
  800b07:	83 c2 01             	add    $0x1,%edx
  800b0a:	eb ea                	jmp    800af6 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b0c:	0f b6 c1             	movzbl %cl,%eax
  800b0f:	0f b6 db             	movzbl %bl,%ebx
  800b12:	29 d8                	sub    %ebx,%eax
  800b14:	eb 05                	jmp    800b1b <memcmp+0x35>
	}

	return 0;
  800b16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b2d:	39 d0                	cmp    %edx,%eax
  800b2f:	73 09                	jae    800b3a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b31:	38 08                	cmp    %cl,(%eax)
  800b33:	74 05                	je     800b3a <memfind+0x1b>
	for (; s < ends; s++)
  800b35:	83 c0 01             	add    $0x1,%eax
  800b38:	eb f3                	jmp    800b2d <memfind+0xe>
			break;
	return (void *) s;
}
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
  800b42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b45:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b48:	eb 03                	jmp    800b4d <strtol+0x11>
		s++;
  800b4a:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b4d:	0f b6 01             	movzbl (%ecx),%eax
  800b50:	3c 20                	cmp    $0x20,%al
  800b52:	74 f6                	je     800b4a <strtol+0xe>
  800b54:	3c 09                	cmp    $0x9,%al
  800b56:	74 f2                	je     800b4a <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b58:	3c 2b                	cmp    $0x2b,%al
  800b5a:	74 2e                	je     800b8a <strtol+0x4e>
	int neg = 0;
  800b5c:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b61:	3c 2d                	cmp    $0x2d,%al
  800b63:	74 2f                	je     800b94 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b65:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b6b:	75 05                	jne    800b72 <strtol+0x36>
  800b6d:	80 39 30             	cmpb   $0x30,(%ecx)
  800b70:	74 2c                	je     800b9e <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	75 0a                	jne    800b80 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b76:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b7b:	80 39 30             	cmpb   $0x30,(%ecx)
  800b7e:	74 28                	je     800ba8 <strtol+0x6c>
		base = 10;
  800b80:	b8 00 00 00 00       	mov    $0x0,%eax
  800b85:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b88:	eb 50                	jmp    800bda <strtol+0x9e>
		s++;
  800b8a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b92:	eb d1                	jmp    800b65 <strtol+0x29>
		s++, neg = 1;
  800b94:	83 c1 01             	add    $0x1,%ecx
  800b97:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9c:	eb c7                	jmp    800b65 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba2:	74 0e                	je     800bb2 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ba4:	85 db                	test   %ebx,%ebx
  800ba6:	75 d8                	jne    800b80 <strtol+0x44>
		s++, base = 8;
  800ba8:	83 c1 01             	add    $0x1,%ecx
  800bab:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb0:	eb ce                	jmp    800b80 <strtol+0x44>
		s += 2, base = 16;
  800bb2:	83 c1 02             	add    $0x2,%ecx
  800bb5:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bba:	eb c4                	jmp    800b80 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bbc:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bbf:	89 f3                	mov    %esi,%ebx
  800bc1:	80 fb 19             	cmp    $0x19,%bl
  800bc4:	77 29                	ja     800bef <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bc6:	0f be d2             	movsbl %dl,%edx
  800bc9:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bcc:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bcf:	7d 30                	jge    800c01 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800bd1:	83 c1 01             	add    $0x1,%ecx
  800bd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bd8:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bda:	0f b6 11             	movzbl (%ecx),%edx
  800bdd:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be0:	89 f3                	mov    %esi,%ebx
  800be2:	80 fb 09             	cmp    $0x9,%bl
  800be5:	77 d5                	ja     800bbc <strtol+0x80>
			dig = *s - '0';
  800be7:	0f be d2             	movsbl %dl,%edx
  800bea:	83 ea 30             	sub    $0x30,%edx
  800bed:	eb dd                	jmp    800bcc <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bef:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf2:	89 f3                	mov    %esi,%ebx
  800bf4:	80 fb 19             	cmp    $0x19,%bl
  800bf7:	77 08                	ja     800c01 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bf9:	0f be d2             	movsbl %dl,%edx
  800bfc:	83 ea 37             	sub    $0x37,%edx
  800bff:	eb cb                	jmp    800bcc <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 05                	je     800c0c <strtol+0xd0>
		*endptr = (char *) s;
  800c07:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c0c:	89 c2                	mov    %eax,%edx
  800c0e:	f7 da                	neg    %edx
  800c10:	85 ff                	test   %edi,%edi
  800c12:	0f 45 c2             	cmovne %edx,%eax
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5f                   	pop    %edi
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    

00800c1a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1a:	55                   	push   %ebp
  800c1b:	89 e5                	mov    %esp,%ebp
  800c1d:	57                   	push   %edi
  800c1e:	56                   	push   %esi
  800c1f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c20:	b8 00 00 00 00       	mov    $0x0,%eax
  800c25:	8b 55 08             	mov    0x8(%ebp),%edx
  800c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2b:	89 c3                	mov    %eax,%ebx
  800c2d:	89 c7                	mov    %eax,%edi
  800c2f:	89 c6                	mov    %eax,%esi
  800c31:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5f                   	pop    %edi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	57                   	push   %edi
  800c3c:	56                   	push   %esi
  800c3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c43:	b8 01 00 00 00       	mov    $0x1,%eax
  800c48:	89 d1                	mov    %edx,%ecx
  800c4a:	89 d3                	mov    %edx,%ebx
  800c4c:	89 d7                	mov    %edx,%edi
  800c4e:	89 d6                	mov    %edx,%esi
  800c50:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
  800c5d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c60:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c65:	8b 55 08             	mov    0x8(%ebp),%edx
  800c68:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6d:	89 cb                	mov    %ecx,%ebx
  800c6f:	89 cf                	mov    %ecx,%edi
  800c71:	89 ce                	mov    %ecx,%esi
  800c73:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c75:	85 c0                	test   %eax,%eax
  800c77:	7f 08                	jg     800c81 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c81:	83 ec 0c             	sub    $0xc,%esp
  800c84:	50                   	push   %eax
  800c85:	6a 03                	push   $0x3
  800c87:	68 1f 28 80 00       	push   $0x80281f
  800c8c:	6a 23                	push   $0x23
  800c8e:	68 3c 28 80 00       	push   $0x80283c
  800c93:	e8 4b f5 ff ff       	call   8001e3 <_panic>

00800c98 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	57                   	push   %edi
  800c9c:	56                   	push   %esi
  800c9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca3:	b8 02 00 00 00       	mov    $0x2,%eax
  800ca8:	89 d1                	mov    %edx,%ecx
  800caa:	89 d3                	mov    %edx,%ebx
  800cac:	89 d7                	mov    %edx,%edi
  800cae:	89 d6                	mov    %edx,%esi
  800cb0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb2:	5b                   	pop    %ebx
  800cb3:	5e                   	pop    %esi
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <sys_yield>:

void
sys_yield(void)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	57                   	push   %edi
  800cbb:	56                   	push   %esi
  800cbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd1:	5b                   	pop    %ebx
  800cd2:	5e                   	pop    %esi
  800cd3:	5f                   	pop    %edi
  800cd4:	5d                   	pop    %ebp
  800cd5:	c3                   	ret    

00800cd6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd6:	55                   	push   %ebp
  800cd7:	89 e5                	mov    %esp,%ebp
  800cd9:	57                   	push   %edi
  800cda:	56                   	push   %esi
  800cdb:	53                   	push   %ebx
  800cdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cdf:	be 00 00 00 00       	mov    $0x0,%esi
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cea:	b8 04 00 00 00       	mov    $0x4,%eax
  800cef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf2:	89 f7                	mov    %esi,%edi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	50                   	push   %eax
  800d06:	6a 04                	push   $0x4
  800d08:	68 1f 28 80 00       	push   $0x80281f
  800d0d:	6a 23                	push   $0x23
  800d0f:	68 3c 28 80 00       	push   $0x80283c
  800d14:	e8 ca f4 ff ff       	call   8001e3 <_panic>

00800d19 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d30:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d33:	8b 75 18             	mov    0x18(%ebp),%esi
  800d36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	7f 08                	jg     800d44 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	50                   	push   %eax
  800d48:	6a 05                	push   $0x5
  800d4a:	68 1f 28 80 00       	push   $0x80281f
  800d4f:	6a 23                	push   $0x23
  800d51:	68 3c 28 80 00       	push   $0x80283c
  800d56:	e8 88 f4 ff ff       	call   8001e3 <_panic>

00800d5b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	57                   	push   %edi
  800d5f:	56                   	push   %esi
  800d60:	53                   	push   %ebx
  800d61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	b8 06 00 00 00       	mov    $0x6,%eax
  800d74:	89 df                	mov    %ebx,%edi
  800d76:	89 de                	mov    %ebx,%esi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 06                	push   $0x6
  800d8c:	68 1f 28 80 00       	push   $0x80281f
  800d91:	6a 23                	push   $0x23
  800d93:	68 3c 28 80 00       	push   $0x80283c
  800d98:	e8 46 f4 ff ff       	call   8001e3 <_panic>

00800d9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	8b 55 08             	mov    0x8(%ebp),%edx
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	b8 08 00 00 00       	mov    $0x8,%eax
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7f 08                	jg     800dc8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5e                   	pop    %esi
  800dc5:	5f                   	pop    %edi
  800dc6:	5d                   	pop    %ebp
  800dc7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	50                   	push   %eax
  800dcc:	6a 08                	push   $0x8
  800dce:	68 1f 28 80 00       	push   $0x80281f
  800dd3:	6a 23                	push   $0x23
  800dd5:	68 3c 28 80 00       	push   $0x80283c
  800dda:	e8 04 f4 ff ff       	call   8001e3 <_panic>

00800ddf <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
  800de5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ded:	8b 55 08             	mov    0x8(%ebp),%edx
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	b8 09 00 00 00       	mov    $0x9,%eax
  800df8:	89 df                	mov    %ebx,%edi
  800dfa:	89 de                	mov    %ebx,%esi
  800dfc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	7f 08                	jg     800e0a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	50                   	push   %eax
  800e0e:	6a 09                	push   $0x9
  800e10:	68 1f 28 80 00       	push   $0x80281f
  800e15:	6a 23                	push   $0x23
  800e17:	68 3c 28 80 00       	push   $0x80283c
  800e1c:	e8 c2 f3 ff ff       	call   8001e3 <_panic>

00800e21 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	57                   	push   %edi
  800e25:	56                   	push   %esi
  800e26:	53                   	push   %ebx
  800e27:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e35:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3a:	89 df                	mov    %ebx,%edi
  800e3c:	89 de                	mov    %ebx,%esi
  800e3e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7f 08                	jg     800e4c <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e47:	5b                   	pop    %ebx
  800e48:	5e                   	pop    %esi
  800e49:	5f                   	pop    %edi
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 0a                	push   $0xa
  800e52:	68 1f 28 80 00       	push   $0x80281f
  800e57:	6a 23                	push   $0x23
  800e59:	68 3c 28 80 00       	push   $0x80283c
  800e5e:	e8 80 f3 ff ff       	call   8001e3 <_panic>

00800e63 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e74:	be 00 00 00 00       	mov    $0x0,%esi
  800e79:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
  800e8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9c:	89 cb                	mov    %ecx,%ebx
  800e9e:	89 cf                	mov    %ecx,%edi
  800ea0:	89 ce                	mov    %ecx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 0d                	push   $0xd
  800eb6:	68 1f 28 80 00       	push   $0x80281f
  800ebb:	6a 23                	push   $0x23
  800ebd:	68 3c 28 80 00       	push   $0x80283c
  800ec2:	e8 1c f3 ff ff       	call   8001e3 <_panic>

00800ec7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ed7:	89 d1                	mov    %edx,%ecx
  800ed9:	89 d3                	mov    %edx,%ebx
  800edb:	89 d7                	mov    %edx,%edi
  800edd:	89 d6                	mov    %edx,%esi
  800edf:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eec:	05 00 00 00 30       	add    $0x30000000,%eax
  800ef1:	c1 e8 0c             	shr    $0xc,%eax
}
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f06:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f18:	89 c2                	mov    %eax,%edx
  800f1a:	c1 ea 16             	shr    $0x16,%edx
  800f1d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f24:	f6 c2 01             	test   $0x1,%dl
  800f27:	74 2a                	je     800f53 <fd_alloc+0x46>
  800f29:	89 c2                	mov    %eax,%edx
  800f2b:	c1 ea 0c             	shr    $0xc,%edx
  800f2e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f35:	f6 c2 01             	test   $0x1,%dl
  800f38:	74 19                	je     800f53 <fd_alloc+0x46>
  800f3a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f3f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f44:	75 d2                	jne    800f18 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f46:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f4c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f51:	eb 07                	jmp    800f5a <fd_alloc+0x4d>
			*fd_store = fd;
  800f53:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f62:	83 f8 1f             	cmp    $0x1f,%eax
  800f65:	77 36                	ja     800f9d <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f67:	c1 e0 0c             	shl    $0xc,%eax
  800f6a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f6f:	89 c2                	mov    %eax,%edx
  800f71:	c1 ea 16             	shr    $0x16,%edx
  800f74:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f7b:	f6 c2 01             	test   $0x1,%dl
  800f7e:	74 24                	je     800fa4 <fd_lookup+0x48>
  800f80:	89 c2                	mov    %eax,%edx
  800f82:	c1 ea 0c             	shr    $0xc,%edx
  800f85:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f8c:	f6 c2 01             	test   $0x1,%dl
  800f8f:	74 1a                	je     800fab <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f94:	89 02                	mov    %eax,(%edx)
	return 0;
  800f96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    
		return -E_INVAL;
  800f9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa2:	eb f7                	jmp    800f9b <fd_lookup+0x3f>
		return -E_INVAL;
  800fa4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa9:	eb f0                	jmp    800f9b <fd_lookup+0x3f>
  800fab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb0:	eb e9                	jmp    800f9b <fd_lookup+0x3f>

00800fb2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fbb:	ba cc 28 80 00       	mov    $0x8028cc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800fc0:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fc5:	39 08                	cmp    %ecx,(%eax)
  800fc7:	74 33                	je     800ffc <dev_lookup+0x4a>
  800fc9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fcc:	8b 02                	mov    (%edx),%eax
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	75 f3                	jne    800fc5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fd2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  800fd7:	8b 40 48             	mov    0x48(%eax),%eax
  800fda:	83 ec 04             	sub    $0x4,%esp
  800fdd:	51                   	push   %ecx
  800fde:	50                   	push   %eax
  800fdf:	68 4c 28 80 00       	push   $0x80284c
  800fe4:	e8 d5 f2 ff ff       	call   8002be <cprintf>
	*dev = 0;
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ff2:	83 c4 10             	add    $0x10,%esp
  800ff5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ffa:	c9                   	leave  
  800ffb:	c3                   	ret    
			*dev = devtab[i];
  800ffc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fff:	89 01                	mov    %eax,(%ecx)
			return 0;
  801001:	b8 00 00 00 00       	mov    $0x0,%eax
  801006:	eb f2                	jmp    800ffa <dev_lookup+0x48>

00801008 <fd_close>:
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
  80100e:	83 ec 1c             	sub    $0x1c,%esp
  801011:	8b 75 08             	mov    0x8(%ebp),%esi
  801014:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801017:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80101a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80101b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801021:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801024:	50                   	push   %eax
  801025:	e8 32 ff ff ff       	call   800f5c <fd_lookup>
  80102a:	89 c3                	mov    %eax,%ebx
  80102c:	83 c4 08             	add    $0x8,%esp
  80102f:	85 c0                	test   %eax,%eax
  801031:	78 05                	js     801038 <fd_close+0x30>
	    || fd != fd2)
  801033:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801036:	74 16                	je     80104e <fd_close+0x46>
		return (must_exist ? r : 0);
  801038:	89 f8                	mov    %edi,%eax
  80103a:	84 c0                	test   %al,%al
  80103c:	b8 00 00 00 00       	mov    $0x0,%eax
  801041:	0f 44 d8             	cmove  %eax,%ebx
}
  801044:	89 d8                	mov    %ebx,%eax
  801046:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	5d                   	pop    %ebp
  80104d:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80104e:	83 ec 08             	sub    $0x8,%esp
  801051:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801054:	50                   	push   %eax
  801055:	ff 36                	pushl  (%esi)
  801057:	e8 56 ff ff ff       	call   800fb2 <dev_lookup>
  80105c:	89 c3                	mov    %eax,%ebx
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	78 15                	js     80107a <fd_close+0x72>
		if (dev->dev_close)
  801065:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801068:	8b 40 10             	mov    0x10(%eax),%eax
  80106b:	85 c0                	test   %eax,%eax
  80106d:	74 1b                	je     80108a <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80106f:	83 ec 0c             	sub    $0xc,%esp
  801072:	56                   	push   %esi
  801073:	ff d0                	call   *%eax
  801075:	89 c3                	mov    %eax,%ebx
  801077:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	56                   	push   %esi
  80107e:	6a 00                	push   $0x0
  801080:	e8 d6 fc ff ff       	call   800d5b <sys_page_unmap>
	return r;
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	eb ba                	jmp    801044 <fd_close+0x3c>
			r = 0;
  80108a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108f:	eb e9                	jmp    80107a <fd_close+0x72>

00801091 <close>:

int
close(int fdnum)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801097:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80109a:	50                   	push   %eax
  80109b:	ff 75 08             	pushl  0x8(%ebp)
  80109e:	e8 b9 fe ff ff       	call   800f5c <fd_lookup>
  8010a3:	83 c4 08             	add    $0x8,%esp
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	78 10                	js     8010ba <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	6a 01                	push   $0x1
  8010af:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b2:	e8 51 ff ff ff       	call   801008 <fd_close>
  8010b7:	83 c4 10             	add    $0x10,%esp
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <close_all>:

void
close_all(void)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010c8:	83 ec 0c             	sub    $0xc,%esp
  8010cb:	53                   	push   %ebx
  8010cc:	e8 c0 ff ff ff       	call   801091 <close>
	for (i = 0; i < MAXFD; i++)
  8010d1:	83 c3 01             	add    $0x1,%ebx
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	83 fb 20             	cmp    $0x20,%ebx
  8010da:	75 ec                	jne    8010c8 <close_all+0xc>
}
  8010dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010df:	c9                   	leave  
  8010e0:	c3                   	ret    

008010e1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010ed:	50                   	push   %eax
  8010ee:	ff 75 08             	pushl  0x8(%ebp)
  8010f1:	e8 66 fe ff ff       	call   800f5c <fd_lookup>
  8010f6:	89 c3                	mov    %eax,%ebx
  8010f8:	83 c4 08             	add    $0x8,%esp
  8010fb:	85 c0                	test   %eax,%eax
  8010fd:	0f 88 81 00 00 00    	js     801184 <dup+0xa3>
		return r;
	close(newfdnum);
  801103:	83 ec 0c             	sub    $0xc,%esp
  801106:	ff 75 0c             	pushl  0xc(%ebp)
  801109:	e8 83 ff ff ff       	call   801091 <close>

	newfd = INDEX2FD(newfdnum);
  80110e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801111:	c1 e6 0c             	shl    $0xc,%esi
  801114:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80111a:	83 c4 04             	add    $0x4,%esp
  80111d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801120:	e8 d1 fd ff ff       	call   800ef6 <fd2data>
  801125:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801127:	89 34 24             	mov    %esi,(%esp)
  80112a:	e8 c7 fd ff ff       	call   800ef6 <fd2data>
  80112f:	83 c4 10             	add    $0x10,%esp
  801132:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801134:	89 d8                	mov    %ebx,%eax
  801136:	c1 e8 16             	shr    $0x16,%eax
  801139:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801140:	a8 01                	test   $0x1,%al
  801142:	74 11                	je     801155 <dup+0x74>
  801144:	89 d8                	mov    %ebx,%eax
  801146:	c1 e8 0c             	shr    $0xc,%eax
  801149:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801150:	f6 c2 01             	test   $0x1,%dl
  801153:	75 39                	jne    80118e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801155:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	c1 e8 0c             	shr    $0xc,%eax
  80115d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801164:	83 ec 0c             	sub    $0xc,%esp
  801167:	25 07 0e 00 00       	and    $0xe07,%eax
  80116c:	50                   	push   %eax
  80116d:	56                   	push   %esi
  80116e:	6a 00                	push   $0x0
  801170:	52                   	push   %edx
  801171:	6a 00                	push   $0x0
  801173:	e8 a1 fb ff ff       	call   800d19 <sys_page_map>
  801178:	89 c3                	mov    %eax,%ebx
  80117a:	83 c4 20             	add    $0x20,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	78 31                	js     8011b2 <dup+0xd1>
		goto err;

	return newfdnum;
  801181:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801184:	89 d8                	mov    %ebx,%eax
  801186:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801189:	5b                   	pop    %ebx
  80118a:	5e                   	pop    %esi
  80118b:	5f                   	pop    %edi
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80118e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	25 07 0e 00 00       	and    $0xe07,%eax
  80119d:	50                   	push   %eax
  80119e:	57                   	push   %edi
  80119f:	6a 00                	push   $0x0
  8011a1:	53                   	push   %ebx
  8011a2:	6a 00                	push   $0x0
  8011a4:	e8 70 fb ff ff       	call   800d19 <sys_page_map>
  8011a9:	89 c3                	mov    %eax,%ebx
  8011ab:	83 c4 20             	add    $0x20,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	79 a3                	jns    801155 <dup+0x74>
	sys_page_unmap(0, newfd);
  8011b2:	83 ec 08             	sub    $0x8,%esp
  8011b5:	56                   	push   %esi
  8011b6:	6a 00                	push   $0x0
  8011b8:	e8 9e fb ff ff       	call   800d5b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011bd:	83 c4 08             	add    $0x8,%esp
  8011c0:	57                   	push   %edi
  8011c1:	6a 00                	push   $0x0
  8011c3:	e8 93 fb ff ff       	call   800d5b <sys_page_unmap>
	return r;
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	eb b7                	jmp    801184 <dup+0xa3>

008011cd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	53                   	push   %ebx
  8011d1:	83 ec 14             	sub    $0x14,%esp
  8011d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	53                   	push   %ebx
  8011dc:	e8 7b fd ff ff       	call   800f5c <fd_lookup>
  8011e1:	83 c4 08             	add    $0x8,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 3f                	js     801227 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011e8:	83 ec 08             	sub    $0x8,%esp
  8011eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ee:	50                   	push   %eax
  8011ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011f2:	ff 30                	pushl  (%eax)
  8011f4:	e8 b9 fd ff ff       	call   800fb2 <dev_lookup>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 27                	js     801227 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801200:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801203:	8b 42 08             	mov    0x8(%edx),%eax
  801206:	83 e0 03             	and    $0x3,%eax
  801209:	83 f8 01             	cmp    $0x1,%eax
  80120c:	74 1e                	je     80122c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80120e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801211:	8b 40 08             	mov    0x8(%eax),%eax
  801214:	85 c0                	test   %eax,%eax
  801216:	74 35                	je     80124d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801218:	83 ec 04             	sub    $0x4,%esp
  80121b:	ff 75 10             	pushl  0x10(%ebp)
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	52                   	push   %edx
  801222:	ff d0                	call   *%eax
  801224:	83 c4 10             	add    $0x10,%esp
}
  801227:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80122c:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801231:	8b 40 48             	mov    0x48(%eax),%eax
  801234:	83 ec 04             	sub    $0x4,%esp
  801237:	53                   	push   %ebx
  801238:	50                   	push   %eax
  801239:	68 90 28 80 00       	push   $0x802890
  80123e:	e8 7b f0 ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80124b:	eb da                	jmp    801227 <read+0x5a>
		return -E_NOT_SUPP;
  80124d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801252:	eb d3                	jmp    801227 <read+0x5a>

00801254 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
  801257:	57                   	push   %edi
  801258:	56                   	push   %esi
  801259:	53                   	push   %ebx
  80125a:	83 ec 0c             	sub    $0xc,%esp
  80125d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801260:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801263:	bb 00 00 00 00       	mov    $0x0,%ebx
  801268:	39 f3                	cmp    %esi,%ebx
  80126a:	73 25                	jae    801291 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80126c:	83 ec 04             	sub    $0x4,%esp
  80126f:	89 f0                	mov    %esi,%eax
  801271:	29 d8                	sub    %ebx,%eax
  801273:	50                   	push   %eax
  801274:	89 d8                	mov    %ebx,%eax
  801276:	03 45 0c             	add    0xc(%ebp),%eax
  801279:	50                   	push   %eax
  80127a:	57                   	push   %edi
  80127b:	e8 4d ff ff ff       	call   8011cd <read>
		if (m < 0)
  801280:	83 c4 10             	add    $0x10,%esp
  801283:	85 c0                	test   %eax,%eax
  801285:	78 08                	js     80128f <readn+0x3b>
			return m;
		if (m == 0)
  801287:	85 c0                	test   %eax,%eax
  801289:	74 06                	je     801291 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80128b:	01 c3                	add    %eax,%ebx
  80128d:	eb d9                	jmp    801268 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80128f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801291:	89 d8                	mov    %ebx,%eax
  801293:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801296:	5b                   	pop    %ebx
  801297:	5e                   	pop    %esi
  801298:	5f                   	pop    %edi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	53                   	push   %ebx
  80129f:	83 ec 14             	sub    $0x14,%esp
  8012a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a8:	50                   	push   %eax
  8012a9:	53                   	push   %ebx
  8012aa:	e8 ad fc ff ff       	call   800f5c <fd_lookup>
  8012af:	83 c4 08             	add    $0x8,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 3a                	js     8012f0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b6:	83 ec 08             	sub    $0x8,%esp
  8012b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012bc:	50                   	push   %eax
  8012bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c0:	ff 30                	pushl  (%eax)
  8012c2:	e8 eb fc ff ff       	call   800fb2 <dev_lookup>
  8012c7:	83 c4 10             	add    $0x10,%esp
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	78 22                	js     8012f0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012d5:	74 1e                	je     8012f5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012da:	8b 52 0c             	mov    0xc(%edx),%edx
  8012dd:	85 d2                	test   %edx,%edx
  8012df:	74 35                	je     801316 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	ff 75 10             	pushl  0x10(%ebp)
  8012e7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ea:	50                   	push   %eax
  8012eb:	ff d2                	call   *%edx
  8012ed:	83 c4 10             	add    $0x10,%esp
}
  8012f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012fa:	8b 40 48             	mov    0x48(%eax),%eax
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	53                   	push   %ebx
  801301:	50                   	push   %eax
  801302:	68 ac 28 80 00       	push   $0x8028ac
  801307:	e8 b2 ef ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801314:	eb da                	jmp    8012f0 <write+0x55>
		return -E_NOT_SUPP;
  801316:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131b:	eb d3                	jmp    8012f0 <write+0x55>

0080131d <seek>:

int
seek(int fdnum, off_t offset)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801323:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801326:	50                   	push   %eax
  801327:	ff 75 08             	pushl  0x8(%ebp)
  80132a:	e8 2d fc ff ff       	call   800f5c <fd_lookup>
  80132f:	83 c4 08             	add    $0x8,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	78 0e                	js     801344 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801336:	8b 55 0c             	mov    0xc(%ebp),%edx
  801339:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80133c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80133f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	53                   	push   %ebx
  80134a:	83 ec 14             	sub    $0x14,%esp
  80134d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801350:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801353:	50                   	push   %eax
  801354:	53                   	push   %ebx
  801355:	e8 02 fc ff ff       	call   800f5c <fd_lookup>
  80135a:	83 c4 08             	add    $0x8,%esp
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 37                	js     801398 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801361:	83 ec 08             	sub    $0x8,%esp
  801364:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801367:	50                   	push   %eax
  801368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136b:	ff 30                	pushl  (%eax)
  80136d:	e8 40 fc ff ff       	call   800fb2 <dev_lookup>
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	85 c0                	test   %eax,%eax
  801377:	78 1f                	js     801398 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801380:	74 1b                	je     80139d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801385:	8b 52 18             	mov    0x18(%edx),%edx
  801388:	85 d2                	test   %edx,%edx
  80138a:	74 32                	je     8013be <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80138c:	83 ec 08             	sub    $0x8,%esp
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	50                   	push   %eax
  801393:	ff d2                	call   *%edx
  801395:	83 c4 10             	add    $0x10,%esp
}
  801398:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80139d:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013a2:	8b 40 48             	mov    0x48(%eax),%eax
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	53                   	push   %ebx
  8013a9:	50                   	push   %eax
  8013aa:	68 6c 28 80 00       	push   $0x80286c
  8013af:	e8 0a ef ff ff       	call   8002be <cprintf>
		return -E_INVAL;
  8013b4:	83 c4 10             	add    $0x10,%esp
  8013b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013bc:	eb da                	jmp    801398 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8013be:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c3:	eb d3                	jmp    801398 <ftruncate+0x52>

008013c5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	53                   	push   %ebx
  8013c9:	83 ec 14             	sub    $0x14,%esp
  8013cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d2:	50                   	push   %eax
  8013d3:	ff 75 08             	pushl  0x8(%ebp)
  8013d6:	e8 81 fb ff ff       	call   800f5c <fd_lookup>
  8013db:	83 c4 08             	add    $0x8,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 4b                	js     80142d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ec:	ff 30                	pushl  (%eax)
  8013ee:	e8 bf fb ff ff       	call   800fb2 <dev_lookup>
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 33                	js     80142d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801401:	74 2f                	je     801432 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801403:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801406:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80140d:	00 00 00 
	stat->st_isdir = 0;
  801410:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801417:	00 00 00 
	stat->st_dev = dev;
  80141a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801420:	83 ec 08             	sub    $0x8,%esp
  801423:	53                   	push   %ebx
  801424:	ff 75 f0             	pushl  -0x10(%ebp)
  801427:	ff 50 14             	call   *0x14(%eax)
  80142a:	83 c4 10             	add    $0x10,%esp
}
  80142d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801430:	c9                   	leave  
  801431:	c3                   	ret    
		return -E_NOT_SUPP;
  801432:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801437:	eb f4                	jmp    80142d <fstat+0x68>

00801439 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	6a 00                	push   $0x0
  801443:	ff 75 08             	pushl  0x8(%ebp)
  801446:	e8 e7 01 00 00       	call   801632 <open>
  80144b:	89 c3                	mov    %eax,%ebx
  80144d:	83 c4 10             	add    $0x10,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	78 1b                	js     80146f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	ff 75 0c             	pushl  0xc(%ebp)
  80145a:	50                   	push   %eax
  80145b:	e8 65 ff ff ff       	call   8013c5 <fstat>
  801460:	89 c6                	mov    %eax,%esi
	close(fd);
  801462:	89 1c 24             	mov    %ebx,(%esp)
  801465:	e8 27 fc ff ff       	call   801091 <close>
	return r;
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	89 f3                	mov    %esi,%ebx
}
  80146f:	89 d8                	mov    %ebx,%eax
  801471:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801474:	5b                   	pop    %ebx
  801475:	5e                   	pop    %esi
  801476:	5d                   	pop    %ebp
  801477:	c3                   	ret    

00801478 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	56                   	push   %esi
  80147c:	53                   	push   %ebx
  80147d:	89 c6                	mov    %eax,%esi
  80147f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801481:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801488:	74 27                	je     8014b1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80148a:	6a 07                	push   $0x7
  80148c:	68 00 50 80 00       	push   $0x805000
  801491:	56                   	push   %esi
  801492:	ff 35 04 40 80 00    	pushl  0x804004
  801498:	e8 e5 0c 00 00       	call   802182 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80149d:	83 c4 0c             	add    $0xc,%esp
  8014a0:	6a 00                	push   $0x0
  8014a2:	53                   	push   %ebx
  8014a3:	6a 00                	push   $0x0
  8014a5:	e8 71 0c 00 00       	call   80211b <ipc_recv>
}
  8014aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014ad:	5b                   	pop    %ebx
  8014ae:	5e                   	pop    %esi
  8014af:	5d                   	pop    %ebp
  8014b0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	6a 01                	push   $0x1
  8014b6:	e8 1b 0d 00 00       	call   8021d6 <ipc_find_env>
  8014bb:	a3 04 40 80 00       	mov    %eax,0x804004
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	eb c5                	jmp    80148a <fsipc+0x12>

008014c5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014de:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8014e8:	e8 8b ff ff ff       	call   801478 <fsipc>
}
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <devfile_flush>:
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8014fb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801500:	ba 00 00 00 00       	mov    $0x0,%edx
  801505:	b8 06 00 00 00       	mov    $0x6,%eax
  80150a:	e8 69 ff ff ff       	call   801478 <fsipc>
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <devfile_stat>:
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	53                   	push   %ebx
  801515:	83 ec 04             	sub    $0x4,%esp
  801518:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8b 40 0c             	mov    0xc(%eax),%eax
  801521:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	b8 05 00 00 00       	mov    $0x5,%eax
  801530:	e8 43 ff ff ff       	call   801478 <fsipc>
  801535:	85 c0                	test   %eax,%eax
  801537:	78 2c                	js     801565 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801539:	83 ec 08             	sub    $0x8,%esp
  80153c:	68 00 50 80 00       	push   $0x805000
  801541:	53                   	push   %ebx
  801542:	e8 96 f3 ff ff       	call   8008dd <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801547:	a1 80 50 80 00       	mov    0x805080,%eax
  80154c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801552:	a1 84 50 80 00       	mov    0x805084,%eax
  801557:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80155d:	83 c4 10             	add    $0x10,%esp
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <devfile_write>:
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 0c             	sub    $0xc,%esp
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801578:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80157d:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801580:	8b 55 08             	mov    0x8(%ebp),%edx
  801583:	8b 52 0c             	mov    0xc(%edx),%edx
  801586:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80158c:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801591:	50                   	push   %eax
  801592:	ff 75 0c             	pushl  0xc(%ebp)
  801595:	68 08 50 80 00       	push   $0x805008
  80159a:	e8 cc f4 ff ff       	call   800a6b <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8015a9:	e8 ca fe ff ff       	call   801478 <fsipc>
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <devfile_read>:
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
  8015b5:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8015be:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8015c3:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ce:	b8 03 00 00 00       	mov    $0x3,%eax
  8015d3:	e8 a0 fe ff ff       	call   801478 <fsipc>
  8015d8:	89 c3                	mov    %eax,%ebx
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	78 1f                	js     8015fd <devfile_read+0x4d>
	assert(r <= n);
  8015de:	39 f0                	cmp    %esi,%eax
  8015e0:	77 24                	ja     801606 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015e2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015e7:	7f 33                	jg     80161c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	50                   	push   %eax
  8015ed:	68 00 50 80 00       	push   $0x805000
  8015f2:	ff 75 0c             	pushl  0xc(%ebp)
  8015f5:	e8 71 f4 ff ff       	call   800a6b <memmove>
	return r;
  8015fa:	83 c4 10             	add    $0x10,%esp
}
  8015fd:	89 d8                	mov    %ebx,%eax
  8015ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801602:	5b                   	pop    %ebx
  801603:	5e                   	pop    %esi
  801604:	5d                   	pop    %ebp
  801605:	c3                   	ret    
	assert(r <= n);
  801606:	68 e0 28 80 00       	push   $0x8028e0
  80160b:	68 e7 28 80 00       	push   $0x8028e7
  801610:	6a 7b                	push   $0x7b
  801612:	68 fc 28 80 00       	push   $0x8028fc
  801617:	e8 c7 eb ff ff       	call   8001e3 <_panic>
	assert(r <= PGSIZE);
  80161c:	68 07 29 80 00       	push   $0x802907
  801621:	68 e7 28 80 00       	push   $0x8028e7
  801626:	6a 7c                	push   $0x7c
  801628:	68 fc 28 80 00       	push   $0x8028fc
  80162d:	e8 b1 eb ff ff       	call   8001e3 <_panic>

00801632 <open>:
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	56                   	push   %esi
  801636:	53                   	push   %ebx
  801637:	83 ec 1c             	sub    $0x1c,%esp
  80163a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80163d:	56                   	push   %esi
  80163e:	e8 63 f2 ff ff       	call   8008a6 <strlen>
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80164b:	7f 6c                	jg     8016b9 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80164d:	83 ec 0c             	sub    $0xc,%esp
  801650:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801653:	50                   	push   %eax
  801654:	e8 b4 f8 ff ff       	call   800f0d <fd_alloc>
  801659:	89 c3                	mov    %eax,%ebx
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 3c                	js     80169e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	56                   	push   %esi
  801666:	68 00 50 80 00       	push   $0x805000
  80166b:	e8 6d f2 ff ff       	call   8008dd <strcpy>
	fsipcbuf.open.req_omode = mode;
  801670:	8b 45 0c             	mov    0xc(%ebp),%eax
  801673:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801678:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167b:	b8 01 00 00 00       	mov    $0x1,%eax
  801680:	e8 f3 fd ff ff       	call   801478 <fsipc>
  801685:	89 c3                	mov    %eax,%ebx
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	85 c0                	test   %eax,%eax
  80168c:	78 19                	js     8016a7 <open+0x75>
	return fd2num(fd);
  80168e:	83 ec 0c             	sub    $0xc,%esp
  801691:	ff 75 f4             	pushl  -0xc(%ebp)
  801694:	e8 4d f8 ff ff       	call   800ee6 <fd2num>
  801699:	89 c3                	mov    %eax,%ebx
  80169b:	83 c4 10             	add    $0x10,%esp
}
  80169e:	89 d8                	mov    %ebx,%eax
  8016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    
		fd_close(fd, 0);
  8016a7:	83 ec 08             	sub    $0x8,%esp
  8016aa:	6a 00                	push   $0x0
  8016ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8016af:	e8 54 f9 ff ff       	call   801008 <fd_close>
		return r;
  8016b4:	83 c4 10             	add    $0x10,%esp
  8016b7:	eb e5                	jmp    80169e <open+0x6c>
		return -E_BAD_PATH;
  8016b9:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016be:	eb de                	jmp    80169e <open+0x6c>

008016c0 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8016d0:	e8 a3 fd ff ff       	call   801478 <fsipc>
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8016d7:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8016db:	7e 38                	jle    801715 <writebuf+0x3e>
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	53                   	push   %ebx
  8016e1:	83 ec 08             	sub    $0x8,%esp
  8016e4:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8016e6:	ff 70 04             	pushl  0x4(%eax)
  8016e9:	8d 40 10             	lea    0x10(%eax),%eax
  8016ec:	50                   	push   %eax
  8016ed:	ff 33                	pushl  (%ebx)
  8016ef:	e8 a7 fb ff ff       	call   80129b <write>
		if (result > 0)
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	7e 03                	jle    8016fe <writebuf+0x27>
			b->result += result;
  8016fb:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016fe:	39 43 04             	cmp    %eax,0x4(%ebx)
  801701:	74 0d                	je     801710 <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  801703:	85 c0                	test   %eax,%eax
  801705:	ba 00 00 00 00       	mov    $0x0,%edx
  80170a:	0f 4f c2             	cmovg  %edx,%eax
  80170d:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801710:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801713:	c9                   	leave  
  801714:	c3                   	ret    
  801715:	f3 c3                	repz ret 

00801717 <putch>:

static void
putch(int ch, void *thunk)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	53                   	push   %ebx
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801721:	8b 53 04             	mov    0x4(%ebx),%edx
  801724:	8d 42 01             	lea    0x1(%edx),%eax
  801727:	89 43 04             	mov    %eax,0x4(%ebx)
  80172a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172d:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801731:	3d 00 01 00 00       	cmp    $0x100,%eax
  801736:	74 06                	je     80173e <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801738:	83 c4 04             	add    $0x4,%esp
  80173b:	5b                   	pop    %ebx
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    
		writebuf(b);
  80173e:	89 d8                	mov    %ebx,%eax
  801740:	e8 92 ff ff ff       	call   8016d7 <writebuf>
		b->idx = 0;
  801745:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80174c:	eb ea                	jmp    801738 <putch+0x21>

0080174e <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801760:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801767:	00 00 00 
	b.result = 0;
  80176a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801771:	00 00 00 
	b.error = 1;
  801774:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80177b:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80177e:	ff 75 10             	pushl  0x10(%ebp)
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80178a:	50                   	push   %eax
  80178b:	68 17 17 80 00       	push   $0x801717
  801790:	e8 26 ec ff ff       	call   8003bb <vprintfmt>
	if (b.idx > 0)
  801795:	83 c4 10             	add    $0x10,%esp
  801798:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80179f:	7f 11                	jg     8017b2 <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  8017a1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    
		writebuf(&b);
  8017b2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8017b8:	e8 1a ff ff ff       	call   8016d7 <writebuf>
  8017bd:	eb e2                	jmp    8017a1 <vfprintf+0x53>

008017bf <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017c5:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8017c8:	50                   	push   %eax
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	ff 75 08             	pushl  0x8(%ebp)
  8017cf:	e8 7a ff ff ff       	call   80174e <vfprintf>
	va_end(ap);

	return cnt;
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <printf>:

int
printf(const char *fmt, ...)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017dc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8017df:	50                   	push   %eax
  8017e0:	ff 75 08             	pushl  0x8(%ebp)
  8017e3:	6a 01                	push   $0x1
  8017e5:	e8 64 ff ff ff       	call   80174e <vfprintf>
	va_end(ap);

	return cnt;
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017f2:	68 13 29 80 00       	push   $0x802913
  8017f7:	ff 75 0c             	pushl  0xc(%ebp)
  8017fa:	e8 de f0 ff ff       	call   8008dd <strcpy>
	return 0;
}
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <devsock_close>:
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	53                   	push   %ebx
  80180a:	83 ec 10             	sub    $0x10,%esp
  80180d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801810:	53                   	push   %ebx
  801811:	e8 f9 09 00 00       	call   80220f <pageref>
  801816:	83 c4 10             	add    $0x10,%esp
		return 0;
  801819:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80181e:	83 f8 01             	cmp    $0x1,%eax
  801821:	74 07                	je     80182a <devsock_close+0x24>
}
  801823:	89 d0                	mov    %edx,%eax
  801825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801828:	c9                   	leave  
  801829:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80182a:	83 ec 0c             	sub    $0xc,%esp
  80182d:	ff 73 0c             	pushl  0xc(%ebx)
  801830:	e8 b7 02 00 00       	call   801aec <nsipc_close>
  801835:	89 c2                	mov    %eax,%edx
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	eb e7                	jmp    801823 <devsock_close+0x1d>

0080183c <devsock_write>:
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801842:	6a 00                	push   $0x0
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	8b 45 08             	mov    0x8(%ebp),%eax
  80184d:	ff 70 0c             	pushl  0xc(%eax)
  801850:	e8 74 03 00 00       	call   801bc9 <nsipc_send>
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <devsock_read>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 10             	pushl  0x10(%ebp)
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	ff 70 0c             	pushl  0xc(%eax)
  80186b:	e8 ed 02 00 00       	call   801b5d <nsipc_recv>
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <fd2sockid>:
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801878:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	e8 da f6 ff ff       	call   800f5c <fd_lookup>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	85 c0                	test   %eax,%eax
  801887:	78 10                	js     801899 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801892:	39 08                	cmp    %ecx,(%eax)
  801894:	75 05                	jne    80189b <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801896:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    
		return -E_NOT_SUPP;
  80189b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a0:	eb f7                	jmp    801899 <fd2sockid+0x27>

008018a2 <alloc_sockfd>:
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	56                   	push   %esi
  8018a6:	53                   	push   %ebx
  8018a7:	83 ec 1c             	sub    $0x1c,%esp
  8018aa:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018af:	50                   	push   %eax
  8018b0:	e8 58 f6 ff ff       	call   800f0d <fd_alloc>
  8018b5:	89 c3                	mov    %eax,%ebx
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 43                	js     801901 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	68 07 04 00 00       	push   $0x407
  8018c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c9:	6a 00                	push   $0x0
  8018cb:	e8 06 f4 ff ff       	call   800cd6 <sys_page_alloc>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	78 28                	js     801901 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018dc:	8b 15 24 30 80 00    	mov    0x803024,%edx
  8018e2:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018ee:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018f1:	83 ec 0c             	sub    $0xc,%esp
  8018f4:	50                   	push   %eax
  8018f5:	e8 ec f5 ff ff       	call   800ee6 <fd2num>
  8018fa:	89 c3                	mov    %eax,%ebx
  8018fc:	83 c4 10             	add    $0x10,%esp
  8018ff:	eb 0c                	jmp    80190d <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801901:	83 ec 0c             	sub    $0xc,%esp
  801904:	56                   	push   %esi
  801905:	e8 e2 01 00 00       	call   801aec <nsipc_close>
		return r;
  80190a:	83 c4 10             	add    $0x10,%esp
}
  80190d:	89 d8                	mov    %ebx,%eax
  80190f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801912:	5b                   	pop    %ebx
  801913:	5e                   	pop    %esi
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <accept>:
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	e8 4e ff ff ff       	call   801872 <fd2sockid>
  801924:	85 c0                	test   %eax,%eax
  801926:	78 1b                	js     801943 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	ff 75 10             	pushl  0x10(%ebp)
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	50                   	push   %eax
  801932:	e8 0e 01 00 00       	call   801a45 <nsipc_accept>
  801937:	83 c4 10             	add    $0x10,%esp
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 05                	js     801943 <accept+0x2d>
	return alloc_sockfd(r);
  80193e:	e8 5f ff ff ff       	call   8018a2 <alloc_sockfd>
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <bind>:
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	e8 1f ff ff ff       	call   801872 <fd2sockid>
  801953:	85 c0                	test   %eax,%eax
  801955:	78 12                	js     801969 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801957:	83 ec 04             	sub    $0x4,%esp
  80195a:	ff 75 10             	pushl  0x10(%ebp)
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	50                   	push   %eax
  801961:	e8 2f 01 00 00       	call   801a95 <nsipc_bind>
  801966:	83 c4 10             	add    $0x10,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <shutdown>:
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	e8 f9 fe ff ff       	call   801872 <fd2sockid>
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 0f                	js     80198c <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	e8 41 01 00 00       	call   801aca <nsipc_shutdown>
  801989:	83 c4 10             	add    $0x10,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <connect>:
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	e8 d6 fe ff ff       	call   801872 <fd2sockid>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 12                	js     8019b2 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	ff 75 10             	pushl  0x10(%ebp)
  8019a6:	ff 75 0c             	pushl  0xc(%ebp)
  8019a9:	50                   	push   %eax
  8019aa:	e8 57 01 00 00       	call   801b06 <nsipc_connect>
  8019af:	83 c4 10             	add    $0x10,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <listen>:
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	e8 b0 fe ff ff       	call   801872 <fd2sockid>
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 0f                	js     8019d5 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019c6:	83 ec 08             	sub    $0x8,%esp
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	50                   	push   %eax
  8019cd:	e8 69 01 00 00       	call   801b3b <nsipc_listen>
  8019d2:	83 c4 10             	add    $0x10,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019dd:	ff 75 10             	pushl  0x10(%ebp)
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	e8 3c 02 00 00       	call   801c27 <nsipc_socket>
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 05                	js     8019f7 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019f2:	e8 ab fe ff ff       	call   8018a2 <alloc_sockfd>
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	53                   	push   %ebx
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a02:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801a09:	74 26                	je     801a31 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a0b:	6a 07                	push   $0x7
  801a0d:	68 00 60 80 00       	push   $0x806000
  801a12:	53                   	push   %ebx
  801a13:	ff 35 08 40 80 00    	pushl  0x804008
  801a19:	e8 64 07 00 00       	call   802182 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a1e:	83 c4 0c             	add    $0xc,%esp
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	e8 ef 06 00 00       	call   80211b <ipc_recv>
}
  801a2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a31:	83 ec 0c             	sub    $0xc,%esp
  801a34:	6a 02                	push   $0x2
  801a36:	e8 9b 07 00 00       	call   8021d6 <ipc_find_env>
  801a3b:	a3 08 40 80 00       	mov    %eax,0x804008
  801a40:	83 c4 10             	add    $0x10,%esp
  801a43:	eb c6                	jmp    801a0b <nsipc+0x12>

00801a45 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	56                   	push   %esi
  801a49:	53                   	push   %ebx
  801a4a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a55:	8b 06                	mov    (%esi),%eax
  801a57:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a61:	e8 93 ff ff ff       	call   8019f9 <nsipc>
  801a66:	89 c3                	mov    %eax,%ebx
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 20                	js     801a8c <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	ff 35 10 60 80 00    	pushl  0x806010
  801a75:	68 00 60 80 00       	push   $0x806000
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	e8 e9 ef ff ff       	call   800a6b <memmove>
		*addrlen = ret->ret_addrlen;
  801a82:	a1 10 60 80 00       	mov    0x806010,%eax
  801a87:	89 06                	mov    %eax,(%esi)
  801a89:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801a8c:	89 d8                	mov    %ebx,%eax
  801a8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aa7:	53                   	push   %ebx
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	68 04 60 80 00       	push   $0x806004
  801ab0:	e8 b6 ef ff ff       	call   800a6b <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ab5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801abb:	b8 02 00 00 00       	mov    $0x2,%eax
  801ac0:	e8 34 ff ff ff       	call   8019f9 <nsipc>
}
  801ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ae0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae5:	e8 0f ff ff ff       	call   8019f9 <nsipc>
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <nsipc_close>:

int
nsipc_close(int s)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801afa:	b8 04 00 00 00       	mov    $0x4,%eax
  801aff:	e8 f5 fe ff ff       	call   8019f9 <nsipc>
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	53                   	push   %ebx
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b18:	53                   	push   %ebx
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	68 04 60 80 00       	push   $0x806004
  801b21:	e8 45 ef ff ff       	call   800a6b <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b26:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b2c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b31:	e8 c3 fe ff ff       	call   8019f9 <nsipc>
}
  801b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b51:	b8 06 00 00 00       	mov    $0x6,%eax
  801b56:	e8 9e fe ff ff       	call   8019f9 <nsipc>
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b6d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b73:	8b 45 14             	mov    0x14(%ebp),%eax
  801b76:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b7b:	b8 07 00 00 00       	mov    $0x7,%eax
  801b80:	e8 74 fe ff ff       	call   8019f9 <nsipc>
  801b85:	89 c3                	mov    %eax,%ebx
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 1f                	js     801baa <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b8b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b90:	7f 21                	jg     801bb3 <nsipc_recv+0x56>
  801b92:	39 c6                	cmp    %eax,%esi
  801b94:	7c 1d                	jl     801bb3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	50                   	push   %eax
  801b9a:	68 00 60 80 00       	push   $0x806000
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	e8 c4 ee ff ff       	call   800a6b <memmove>
  801ba7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801baa:	89 d8                	mov    %ebx,%eax
  801bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bb3:	68 1f 29 80 00       	push   $0x80291f
  801bb8:	68 e7 28 80 00       	push   $0x8028e7
  801bbd:	6a 62                	push   $0x62
  801bbf:	68 34 29 80 00       	push   $0x802934
  801bc4:	e8 1a e6 ff ff       	call   8001e3 <_panic>

00801bc9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	53                   	push   %ebx
  801bcd:	83 ec 04             	sub    $0x4,%esp
  801bd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bdb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801be1:	7f 2e                	jg     801c11 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	53                   	push   %ebx
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	68 0c 60 80 00       	push   $0x80600c
  801bef:	e8 77 ee ff ff       	call   800a6b <memmove>
	nsipcbuf.send.req_size = size;
  801bf4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c02:	b8 08 00 00 00       	mov    $0x8,%eax
  801c07:	e8 ed fd ff ff       	call   8019f9 <nsipc>
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    
	assert(size < 1600);
  801c11:	68 40 29 80 00       	push   $0x802940
  801c16:	68 e7 28 80 00       	push   $0x8028e7
  801c1b:	6a 6d                	push   $0x6d
  801c1d:	68 34 29 80 00       	push   $0x802934
  801c22:	e8 bc e5 ff ff       	call   8001e3 <_panic>

00801c27 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c38:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c40:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c45:	b8 09 00 00 00       	mov    $0x9,%eax
  801c4a:	e8 aa fd ff ff       	call   8019f9 <nsipc>
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 92 f2 ff ff       	call   800ef6 <fd2data>
  801c64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c66:	83 c4 08             	add    $0x8,%esp
  801c69:	68 4c 29 80 00       	push   $0x80294c
  801c6e:	53                   	push   %ebx
  801c6f:	e8 69 ec ff ff       	call   8008dd <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c74:	8b 46 04             	mov    0x4(%esi),%eax
  801c77:	2b 06                	sub    (%esi),%eax
  801c79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c86:	00 00 00 
	stat->st_dev = &devpipe;
  801c89:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801c90:	30 80 00 
	return 0;
}
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    

00801c9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	53                   	push   %ebx
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca9:	53                   	push   %ebx
  801caa:	6a 00                	push   $0x0
  801cac:	e8 aa f0 ff ff       	call   800d5b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb1:	89 1c 24             	mov    %ebx,(%esp)
  801cb4:	e8 3d f2 ff ff       	call   800ef6 <fd2data>
  801cb9:	83 c4 08             	add    $0x8,%esp
  801cbc:	50                   	push   %eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	e8 97 f0 ff ff       	call   800d5b <sys_page_unmap>
}
  801cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <_pipeisclosed>:
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 1c             	sub    $0x1c,%esp
  801cd2:	89 c7                	mov    %eax,%edi
  801cd4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd6:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801cdb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	57                   	push   %edi
  801ce2:	e8 28 05 00 00       	call   80220f <pageref>
  801ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cea:	89 34 24             	mov    %esi,(%esp)
  801ced:	e8 1d 05 00 00       	call   80220f <pageref>
		nn = thisenv->env_runs;
  801cf2:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801cf8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	39 cb                	cmp    %ecx,%ebx
  801d00:	74 1b                	je     801d1d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d02:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d05:	75 cf                	jne    801cd6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d07:	8b 42 58             	mov    0x58(%edx),%eax
  801d0a:	6a 01                	push   $0x1
  801d0c:	50                   	push   %eax
  801d0d:	53                   	push   %ebx
  801d0e:	68 53 29 80 00       	push   $0x802953
  801d13:	e8 a6 e5 ff ff       	call   8002be <cprintf>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	eb b9                	jmp    801cd6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d1d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d20:	0f 94 c0             	sete   %al
  801d23:	0f b6 c0             	movzbl %al,%eax
}
  801d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d29:	5b                   	pop    %ebx
  801d2a:	5e                   	pop    %esi
  801d2b:	5f                   	pop    %edi
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <devpipe_write>:
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	57                   	push   %edi
  801d32:	56                   	push   %esi
  801d33:	53                   	push   %ebx
  801d34:	83 ec 28             	sub    $0x28,%esp
  801d37:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d3a:	56                   	push   %esi
  801d3b:	e8 b6 f1 ff ff       	call   800ef6 <fd2data>
  801d40:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d4d:	74 4f                	je     801d9e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d4f:	8b 43 04             	mov    0x4(%ebx),%eax
  801d52:	8b 0b                	mov    (%ebx),%ecx
  801d54:	8d 51 20             	lea    0x20(%ecx),%edx
  801d57:	39 d0                	cmp    %edx,%eax
  801d59:	72 14                	jb     801d6f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d5b:	89 da                	mov    %ebx,%edx
  801d5d:	89 f0                	mov    %esi,%eax
  801d5f:	e8 65 ff ff ff       	call   801cc9 <_pipeisclosed>
  801d64:	85 c0                	test   %eax,%eax
  801d66:	75 3a                	jne    801da2 <devpipe_write+0x74>
			sys_yield();
  801d68:	e8 4a ef ff ff       	call   800cb7 <sys_yield>
  801d6d:	eb e0                	jmp    801d4f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d72:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d76:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d79:	89 c2                	mov    %eax,%edx
  801d7b:	c1 fa 1f             	sar    $0x1f,%edx
  801d7e:	89 d1                	mov    %edx,%ecx
  801d80:	c1 e9 1b             	shr    $0x1b,%ecx
  801d83:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d86:	83 e2 1f             	and    $0x1f,%edx
  801d89:	29 ca                	sub    %ecx,%edx
  801d8b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d8f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d93:	83 c0 01             	add    $0x1,%eax
  801d96:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d99:	83 c7 01             	add    $0x1,%edi
  801d9c:	eb ac                	jmp    801d4a <devpipe_write+0x1c>
	return i;
  801d9e:	89 f8                	mov    %edi,%eax
  801da0:	eb 05                	jmp    801da7 <devpipe_write+0x79>
				return 0;
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5f                   	pop    %edi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    

00801daf <devpipe_read>:
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	57                   	push   %edi
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	83 ec 18             	sub    $0x18,%esp
  801db8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dbb:	57                   	push   %edi
  801dbc:	e8 35 f1 ff ff       	call   800ef6 <fd2data>
  801dc1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	be 00 00 00 00       	mov    $0x0,%esi
  801dcb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dce:	74 47                	je     801e17 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801dd0:	8b 03                	mov    (%ebx),%eax
  801dd2:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dd5:	75 22                	jne    801df9 <devpipe_read+0x4a>
			if (i > 0)
  801dd7:	85 f6                	test   %esi,%esi
  801dd9:	75 14                	jne    801def <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801ddb:	89 da                	mov    %ebx,%edx
  801ddd:	89 f8                	mov    %edi,%eax
  801ddf:	e8 e5 fe ff ff       	call   801cc9 <_pipeisclosed>
  801de4:	85 c0                	test   %eax,%eax
  801de6:	75 33                	jne    801e1b <devpipe_read+0x6c>
			sys_yield();
  801de8:	e8 ca ee ff ff       	call   800cb7 <sys_yield>
  801ded:	eb e1                	jmp    801dd0 <devpipe_read+0x21>
				return i;
  801def:	89 f0                	mov    %esi,%eax
}
  801df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801df4:	5b                   	pop    %ebx
  801df5:	5e                   	pop    %esi
  801df6:	5f                   	pop    %edi
  801df7:	5d                   	pop    %ebp
  801df8:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801df9:	99                   	cltd   
  801dfa:	c1 ea 1b             	shr    $0x1b,%edx
  801dfd:	01 d0                	add    %edx,%eax
  801dff:	83 e0 1f             	and    $0x1f,%eax
  801e02:	29 d0                	sub    %edx,%eax
  801e04:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e0f:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e12:	83 c6 01             	add    $0x1,%esi
  801e15:	eb b4                	jmp    801dcb <devpipe_read+0x1c>
	return i;
  801e17:	89 f0                	mov    %esi,%eax
  801e19:	eb d6                	jmp    801df1 <devpipe_read+0x42>
				return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	eb cf                	jmp    801df1 <devpipe_read+0x42>

00801e22 <pipe>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	56                   	push   %esi
  801e26:	53                   	push   %ebx
  801e27:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2d:	50                   	push   %eax
  801e2e:	e8 da f0 ff ff       	call   800f0d <fd_alloc>
  801e33:	89 c3                	mov    %eax,%ebx
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 5b                	js     801e97 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	68 07 04 00 00       	push   $0x407
  801e44:	ff 75 f4             	pushl  -0xc(%ebp)
  801e47:	6a 00                	push   $0x0
  801e49:	e8 88 ee ff ff       	call   800cd6 <sys_page_alloc>
  801e4e:	89 c3                	mov    %eax,%ebx
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	85 c0                	test   %eax,%eax
  801e55:	78 40                	js     801e97 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e5d:	50                   	push   %eax
  801e5e:	e8 aa f0 ff ff       	call   800f0d <fd_alloc>
  801e63:	89 c3                	mov    %eax,%ebx
  801e65:	83 c4 10             	add    $0x10,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	78 1b                	js     801e87 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	68 07 04 00 00       	push   $0x407
  801e74:	ff 75 f0             	pushl  -0x10(%ebp)
  801e77:	6a 00                	push   $0x0
  801e79:	e8 58 ee ff ff       	call   800cd6 <sys_page_alloc>
  801e7e:	89 c3                	mov    %eax,%ebx
  801e80:	83 c4 10             	add    $0x10,%esp
  801e83:	85 c0                	test   %eax,%eax
  801e85:	79 19                	jns    801ea0 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801e87:	83 ec 08             	sub    $0x8,%esp
  801e8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8d:	6a 00                	push   $0x0
  801e8f:	e8 c7 ee ff ff       	call   800d5b <sys_page_unmap>
  801e94:	83 c4 10             	add    $0x10,%esp
}
  801e97:	89 d8                	mov    %ebx,%eax
  801e99:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e9c:	5b                   	pop    %ebx
  801e9d:	5e                   	pop    %esi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
	va = fd2data(fd0);
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea6:	e8 4b f0 ff ff       	call   800ef6 <fd2data>
  801eab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ead:	83 c4 0c             	add    $0xc,%esp
  801eb0:	68 07 04 00 00       	push   $0x407
  801eb5:	50                   	push   %eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	e8 19 ee ff ff       	call   800cd6 <sys_page_alloc>
  801ebd:	89 c3                	mov    %eax,%ebx
  801ebf:	83 c4 10             	add    $0x10,%esp
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	0f 88 8c 00 00 00    	js     801f56 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eca:	83 ec 0c             	sub    $0xc,%esp
  801ecd:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed0:	e8 21 f0 ff ff       	call   800ef6 <fd2data>
  801ed5:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801edc:	50                   	push   %eax
  801edd:	6a 00                	push   $0x0
  801edf:	56                   	push   %esi
  801ee0:	6a 00                	push   $0x0
  801ee2:	e8 32 ee ff ff       	call   800d19 <sys_page_map>
  801ee7:	89 c3                	mov    %eax,%ebx
  801ee9:	83 c4 20             	add    $0x20,%esp
  801eec:	85 c0                	test   %eax,%eax
  801eee:	78 58                	js     801f48 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801ef9:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f08:	8b 15 40 30 80 00    	mov    0x803040,%edx
  801f0e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f13:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f1a:	83 ec 0c             	sub    $0xc,%esp
  801f1d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f20:	e8 c1 ef ff ff       	call   800ee6 <fd2num>
  801f25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f28:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f2a:	83 c4 04             	add    $0x4,%esp
  801f2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f30:	e8 b1 ef ff ff       	call   800ee6 <fd2num>
  801f35:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f38:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f3b:	83 c4 10             	add    $0x10,%esp
  801f3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f43:	e9 4f ff ff ff       	jmp    801e97 <pipe+0x75>
	sys_page_unmap(0, va);
  801f48:	83 ec 08             	sub    $0x8,%esp
  801f4b:	56                   	push   %esi
  801f4c:	6a 00                	push   $0x0
  801f4e:	e8 08 ee ff ff       	call   800d5b <sys_page_unmap>
  801f53:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f56:	83 ec 08             	sub    $0x8,%esp
  801f59:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5c:	6a 00                	push   $0x0
  801f5e:	e8 f8 ed ff ff       	call   800d5b <sys_page_unmap>
  801f63:	83 c4 10             	add    $0x10,%esp
  801f66:	e9 1c ff ff ff       	jmp    801e87 <pipe+0x65>

00801f6b <pipeisclosed>:
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	ff 75 08             	pushl  0x8(%ebp)
  801f78:	e8 df ef ff ff       	call   800f5c <fd_lookup>
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 18                	js     801f9c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8a:	e8 67 ef ff ff       	call   800ef6 <fd2data>
	return _pipeisclosed(fd, p);
  801f8f:	89 c2                	mov    %eax,%edx
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	e8 30 fd ff ff       	call   801cc9 <_pipeisclosed>
  801f99:	83 c4 10             	add    $0x10,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa6:	5d                   	pop    %ebp
  801fa7:	c3                   	ret    

00801fa8 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fae:	68 6b 29 80 00       	push   $0x80296b
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	e8 22 e9 ff ff       	call   8008dd <strcpy>
	return 0;
}
  801fbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <devcons_write>:
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	57                   	push   %edi
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fce:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fd3:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd9:	eb 2f                	jmp    80200a <devcons_write+0x48>
		m = n - tot;
  801fdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fde:	29 f3                	sub    %esi,%ebx
  801fe0:	83 fb 7f             	cmp    $0x7f,%ebx
  801fe3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	53                   	push   %ebx
  801fef:	89 f0                	mov    %esi,%eax
  801ff1:	03 45 0c             	add    0xc(%ebp),%eax
  801ff4:	50                   	push   %eax
  801ff5:	57                   	push   %edi
  801ff6:	e8 70 ea ff ff       	call   800a6b <memmove>
		sys_cputs(buf, m);
  801ffb:	83 c4 08             	add    $0x8,%esp
  801ffe:	53                   	push   %ebx
  801fff:	57                   	push   %edi
  802000:	e8 15 ec ff ff       	call   800c1a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802005:	01 de                	add    %ebx,%esi
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80200d:	72 cc                	jb     801fdb <devcons_write+0x19>
}
  80200f:	89 f0                	mov    %esi,%eax
  802011:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802014:	5b                   	pop    %ebx
  802015:	5e                   	pop    %esi
  802016:	5f                   	pop    %edi
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <devcons_read>:
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 08             	sub    $0x8,%esp
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802024:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802028:	75 07                	jne    802031 <devcons_read+0x18>
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    
		sys_yield();
  80202c:	e8 86 ec ff ff       	call   800cb7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802031:	e8 02 ec ff ff       	call   800c38 <sys_cgetc>
  802036:	85 c0                	test   %eax,%eax
  802038:	74 f2                	je     80202c <devcons_read+0x13>
	if (c < 0)
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 ec                	js     80202a <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80203e:	83 f8 04             	cmp    $0x4,%eax
  802041:	74 0c                	je     80204f <devcons_read+0x36>
	*(char*)vbuf = c;
  802043:	8b 55 0c             	mov    0xc(%ebp),%edx
  802046:	88 02                	mov    %al,(%edx)
	return 1;
  802048:	b8 01 00 00 00       	mov    $0x1,%eax
  80204d:	eb db                	jmp    80202a <devcons_read+0x11>
		return 0;
  80204f:	b8 00 00 00 00       	mov    $0x0,%eax
  802054:	eb d4                	jmp    80202a <devcons_read+0x11>

00802056 <cputchar>:
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802062:	6a 01                	push   $0x1
  802064:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802067:	50                   	push   %eax
  802068:	e8 ad eb ff ff       	call   800c1a <sys_cputs>
}
  80206d:	83 c4 10             	add    $0x10,%esp
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <getchar>:
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802078:	6a 01                	push   $0x1
  80207a:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80207d:	50                   	push   %eax
  80207e:	6a 00                	push   $0x0
  802080:	e8 48 f1 ff ff       	call   8011cd <read>
	if (r < 0)
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	85 c0                	test   %eax,%eax
  80208a:	78 08                	js     802094 <getchar+0x22>
	if (r < 1)
  80208c:	85 c0                	test   %eax,%eax
  80208e:	7e 06                	jle    802096 <getchar+0x24>
	return c;
  802090:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    
		return -E_EOF;
  802096:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80209b:	eb f7                	jmp    802094 <getchar+0x22>

0080209d <iscons>:
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020a6:	50                   	push   %eax
  8020a7:	ff 75 08             	pushl  0x8(%ebp)
  8020aa:	e8 ad ee ff ff       	call   800f5c <fd_lookup>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 c0                	test   %eax,%eax
  8020b4:	78 11                	js     8020c7 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8020bf:	39 10                	cmp    %edx,(%eax)
  8020c1:	0f 94 c0             	sete   %al
  8020c4:	0f b6 c0             	movzbl %al,%eax
}
  8020c7:	c9                   	leave  
  8020c8:	c3                   	ret    

008020c9 <opencons>:
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d2:	50                   	push   %eax
  8020d3:	e8 35 ee ff ff       	call   800f0d <fd_alloc>
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 3a                	js     802119 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	68 07 04 00 00       	push   $0x407
  8020e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020ea:	6a 00                	push   $0x0
  8020ec:	e8 e5 eb ff ff       	call   800cd6 <sys_page_alloc>
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 21                	js     802119 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802101:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	50                   	push   %eax
  802111:	e8 d0 ed ff ff       	call   800ee6 <fd2num>
  802116:	83 c4 10             	add    $0x10,%esp
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	56                   	push   %esi
  80211f:	53                   	push   %ebx
  802120:	8b 75 08             	mov    0x8(%ebp),%esi
  802123:	8b 45 0c             	mov    0xc(%ebp),%eax
  802126:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802129:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80212b:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802130:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	50                   	push   %eax
  802137:	e8 4a ed ff ff       	call   800e86 <sys_ipc_recv>
	if (from_env_store)
  80213c:	83 c4 10             	add    $0x10,%esp
  80213f:	85 f6                	test   %esi,%esi
  802141:	74 14                	je     802157 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802143:	ba 00 00 00 00       	mov    $0x0,%edx
  802148:	85 c0                	test   %eax,%eax
  80214a:	78 09                	js     802155 <ipc_recv+0x3a>
  80214c:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  802152:	8b 52 74             	mov    0x74(%edx),%edx
  802155:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802157:	85 db                	test   %ebx,%ebx
  802159:	74 14                	je     80216f <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  80215b:	ba 00 00 00 00       	mov    $0x0,%edx
  802160:	85 c0                	test   %eax,%eax
  802162:	78 09                	js     80216d <ipc_recv+0x52>
  802164:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80216a:	8b 52 78             	mov    0x78(%edx),%edx
  80216d:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 08                	js     80217b <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802173:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802178:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80217b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217e:	5b                   	pop    %ebx
  80217f:	5e                   	pop    %esi
  802180:	5d                   	pop    %ebp
  802181:	c3                   	ret    

00802182 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	57                   	push   %edi
  802186:	56                   	push   %esi
  802187:	53                   	push   %ebx
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80218e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802191:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802194:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802196:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80219b:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80219e:	ff 75 14             	pushl  0x14(%ebp)
  8021a1:	53                   	push   %ebx
  8021a2:	56                   	push   %esi
  8021a3:	57                   	push   %edi
  8021a4:	e8 ba ec ff ff       	call   800e63 <sys_ipc_try_send>
		if (ret == 0)
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	74 1e                	je     8021ce <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8021b0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021b3:	75 07                	jne    8021bc <ipc_send+0x3a>
			sys_yield();
  8021b5:	e8 fd ea ff ff       	call   800cb7 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8021ba:	eb e2                	jmp    80219e <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  8021bc:	50                   	push   %eax
  8021bd:	68 77 29 80 00       	push   $0x802977
  8021c2:	6a 3d                	push   $0x3d
  8021c4:	68 8b 29 80 00       	push   $0x80298b
  8021c9:	e8 15 e0 ff ff       	call   8001e3 <_panic>
	}
	// panic("ipc_send not implemented");
}
  8021ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021d1:	5b                   	pop    %ebx
  8021d2:	5e                   	pop    %esi
  8021d3:	5f                   	pop    %edi
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021e1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8021e4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8021ea:	8b 52 50             	mov    0x50(%edx),%edx
  8021ed:	39 ca                	cmp    %ecx,%edx
  8021ef:	74 11                	je     802202 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8021f1:	83 c0 01             	add    $0x1,%eax
  8021f4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8021f9:	75 e6                	jne    8021e1 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	eb 0b                	jmp    80220d <ipc_find_env+0x37>
			return envs[i].env_id;
  802202:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802205:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80220a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80220d:	5d                   	pop    %ebp
  80220e:	c3                   	ret    

0080220f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802215:	89 d0                	mov    %edx,%eax
  802217:	c1 e8 16             	shr    $0x16,%eax
  80221a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802226:	f6 c1 01             	test   $0x1,%cl
  802229:	74 1d                	je     802248 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80222b:	c1 ea 0c             	shr    $0xc,%edx
  80222e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802235:	f6 c2 01             	test   $0x1,%dl
  802238:	74 0e                	je     802248 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80223a:	c1 ea 0c             	shr    $0xc,%edx
  80223d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802244:	ef 
  802245:	0f b7 c0             	movzwl %ax,%eax
}
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <__udivdi3>:
  802250:	55                   	push   %ebp
  802251:	57                   	push   %edi
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
  802254:	83 ec 1c             	sub    $0x1c,%esp
  802257:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80225b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80225f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802263:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802267:	85 d2                	test   %edx,%edx
  802269:	75 35                	jne    8022a0 <__udivdi3+0x50>
  80226b:	39 f3                	cmp    %esi,%ebx
  80226d:	0f 87 bd 00 00 00    	ja     802330 <__udivdi3+0xe0>
  802273:	85 db                	test   %ebx,%ebx
  802275:	89 d9                	mov    %ebx,%ecx
  802277:	75 0b                	jne    802284 <__udivdi3+0x34>
  802279:	b8 01 00 00 00       	mov    $0x1,%eax
  80227e:	31 d2                	xor    %edx,%edx
  802280:	f7 f3                	div    %ebx
  802282:	89 c1                	mov    %eax,%ecx
  802284:	31 d2                	xor    %edx,%edx
  802286:	89 f0                	mov    %esi,%eax
  802288:	f7 f1                	div    %ecx
  80228a:	89 c6                	mov    %eax,%esi
  80228c:	89 e8                	mov    %ebp,%eax
  80228e:	89 f7                	mov    %esi,%edi
  802290:	f7 f1                	div    %ecx
  802292:	89 fa                	mov    %edi,%edx
  802294:	83 c4 1c             	add    $0x1c,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    
  80229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a0:	39 f2                	cmp    %esi,%edx
  8022a2:	77 7c                	ja     802320 <__udivdi3+0xd0>
  8022a4:	0f bd fa             	bsr    %edx,%edi
  8022a7:	83 f7 1f             	xor    $0x1f,%edi
  8022aa:	0f 84 98 00 00 00    	je     802348 <__udivdi3+0xf8>
  8022b0:	89 f9                	mov    %edi,%ecx
  8022b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b7:	29 f8                	sub    %edi,%eax
  8022b9:	d3 e2                	shl    %cl,%edx
  8022bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bf:	89 c1                	mov    %eax,%ecx
  8022c1:	89 da                	mov    %ebx,%edx
  8022c3:	d3 ea                	shr    %cl,%edx
  8022c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8022c9:	09 d1                	or     %edx,%ecx
  8022cb:	89 f2                	mov    %esi,%edx
  8022cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022d1:	89 f9                	mov    %edi,%ecx
  8022d3:	d3 e3                	shl    %cl,%ebx
  8022d5:	89 c1                	mov    %eax,%ecx
  8022d7:	d3 ea                	shr    %cl,%edx
  8022d9:	89 f9                	mov    %edi,%ecx
  8022db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8022df:	d3 e6                	shl    %cl,%esi
  8022e1:	89 eb                	mov    %ebp,%ebx
  8022e3:	89 c1                	mov    %eax,%ecx
  8022e5:	d3 eb                	shr    %cl,%ebx
  8022e7:	09 de                	or     %ebx,%esi
  8022e9:	89 f0                	mov    %esi,%eax
  8022eb:	f7 74 24 08          	divl   0x8(%esp)
  8022ef:	89 d6                	mov    %edx,%esi
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	f7 64 24 0c          	mull   0xc(%esp)
  8022f7:	39 d6                	cmp    %edx,%esi
  8022f9:	72 0c                	jb     802307 <__udivdi3+0xb7>
  8022fb:	89 f9                	mov    %edi,%ecx
  8022fd:	d3 e5                	shl    %cl,%ebp
  8022ff:	39 c5                	cmp    %eax,%ebp
  802301:	73 5d                	jae    802360 <__udivdi3+0x110>
  802303:	39 d6                	cmp    %edx,%esi
  802305:	75 59                	jne    802360 <__udivdi3+0x110>
  802307:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80230a:	31 ff                	xor    %edi,%edi
  80230c:	89 fa                	mov    %edi,%edx
  80230e:	83 c4 1c             	add    $0x1c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    
  802316:	8d 76 00             	lea    0x0(%esi),%esi
  802319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802320:	31 ff                	xor    %edi,%edi
  802322:	31 c0                	xor    %eax,%eax
  802324:	89 fa                	mov    %edi,%edx
  802326:	83 c4 1c             	add    $0x1c,%esp
  802329:	5b                   	pop    %ebx
  80232a:	5e                   	pop    %esi
  80232b:	5f                   	pop    %edi
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    
  80232e:	66 90                	xchg   %ax,%ax
  802330:	31 ff                	xor    %edi,%edi
  802332:	89 e8                	mov    %ebp,%eax
  802334:	89 f2                	mov    %esi,%edx
  802336:	f7 f3                	div    %ebx
  802338:	89 fa                	mov    %edi,%edx
  80233a:	83 c4 1c             	add    $0x1c,%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5f                   	pop    %edi
  802340:	5d                   	pop    %ebp
  802341:	c3                   	ret    
  802342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802348:	39 f2                	cmp    %esi,%edx
  80234a:	72 06                	jb     802352 <__udivdi3+0x102>
  80234c:	31 c0                	xor    %eax,%eax
  80234e:	39 eb                	cmp    %ebp,%ebx
  802350:	77 d2                	ja     802324 <__udivdi3+0xd4>
  802352:	b8 01 00 00 00       	mov    $0x1,%eax
  802357:	eb cb                	jmp    802324 <__udivdi3+0xd4>
  802359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802360:	89 d8                	mov    %ebx,%eax
  802362:	31 ff                	xor    %edi,%edi
  802364:	eb be                	jmp    802324 <__udivdi3+0xd4>
  802366:	66 90                	xchg   %ax,%ax
  802368:	66 90                	xchg   %ax,%ax
  80236a:	66 90                	xchg   %ax,%ax
  80236c:	66 90                	xchg   %ax,%ax
  80236e:	66 90                	xchg   %ax,%ax

00802370 <__umoddi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80237b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80237f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802383:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802387:	85 ed                	test   %ebp,%ebp
  802389:	89 f0                	mov    %esi,%eax
  80238b:	89 da                	mov    %ebx,%edx
  80238d:	75 19                	jne    8023a8 <__umoddi3+0x38>
  80238f:	39 df                	cmp    %ebx,%edi
  802391:	0f 86 b1 00 00 00    	jbe    802448 <__umoddi3+0xd8>
  802397:	f7 f7                	div    %edi
  802399:	89 d0                	mov    %edx,%eax
  80239b:	31 d2                	xor    %edx,%edx
  80239d:	83 c4 1c             	add    $0x1c,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	39 dd                	cmp    %ebx,%ebp
  8023aa:	77 f1                	ja     80239d <__umoddi3+0x2d>
  8023ac:	0f bd cd             	bsr    %ebp,%ecx
  8023af:	83 f1 1f             	xor    $0x1f,%ecx
  8023b2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023b6:	0f 84 b4 00 00 00    	je     802470 <__umoddi3+0x100>
  8023bc:	b8 20 00 00 00       	mov    $0x20,%eax
  8023c1:	89 c2                	mov    %eax,%edx
  8023c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023c7:	29 c2                	sub    %eax,%edx
  8023c9:	89 c1                	mov    %eax,%ecx
  8023cb:	89 f8                	mov    %edi,%eax
  8023cd:	d3 e5                	shl    %cl,%ebp
  8023cf:	89 d1                	mov    %edx,%ecx
  8023d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023d5:	d3 e8                	shr    %cl,%eax
  8023d7:	09 c5                	or     %eax,%ebp
  8023d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8023dd:	89 c1                	mov    %eax,%ecx
  8023df:	d3 e7                	shl    %cl,%edi
  8023e1:	89 d1                	mov    %edx,%ecx
  8023e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023e7:	89 df                	mov    %ebx,%edi
  8023e9:	d3 ef                	shr    %cl,%edi
  8023eb:	89 c1                	mov    %eax,%ecx
  8023ed:	89 f0                	mov    %esi,%eax
  8023ef:	d3 e3                	shl    %cl,%ebx
  8023f1:	89 d1                	mov    %edx,%ecx
  8023f3:	89 fa                	mov    %edi,%edx
  8023f5:	d3 e8                	shr    %cl,%eax
  8023f7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8023fc:	09 d8                	or     %ebx,%eax
  8023fe:	f7 f5                	div    %ebp
  802400:	d3 e6                	shl    %cl,%esi
  802402:	89 d1                	mov    %edx,%ecx
  802404:	f7 64 24 08          	mull   0x8(%esp)
  802408:	39 d1                	cmp    %edx,%ecx
  80240a:	89 c3                	mov    %eax,%ebx
  80240c:	89 d7                	mov    %edx,%edi
  80240e:	72 06                	jb     802416 <__umoddi3+0xa6>
  802410:	75 0e                	jne    802420 <__umoddi3+0xb0>
  802412:	39 c6                	cmp    %eax,%esi
  802414:	73 0a                	jae    802420 <__umoddi3+0xb0>
  802416:	2b 44 24 08          	sub    0x8(%esp),%eax
  80241a:	19 ea                	sbb    %ebp,%edx
  80241c:	89 d7                	mov    %edx,%edi
  80241e:	89 c3                	mov    %eax,%ebx
  802420:	89 ca                	mov    %ecx,%edx
  802422:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802427:	29 de                	sub    %ebx,%esi
  802429:	19 fa                	sbb    %edi,%edx
  80242b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80242f:	89 d0                	mov    %edx,%eax
  802431:	d3 e0                	shl    %cl,%eax
  802433:	89 d9                	mov    %ebx,%ecx
  802435:	d3 ee                	shr    %cl,%esi
  802437:	d3 ea                	shr    %cl,%edx
  802439:	09 f0                	or     %esi,%eax
  80243b:	83 c4 1c             	add    $0x1c,%esp
  80243e:	5b                   	pop    %ebx
  80243f:	5e                   	pop    %esi
  802440:	5f                   	pop    %edi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    
  802443:	90                   	nop
  802444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802448:	85 ff                	test   %edi,%edi
  80244a:	89 f9                	mov    %edi,%ecx
  80244c:	75 0b                	jne    802459 <__umoddi3+0xe9>
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	31 d2                	xor    %edx,%edx
  802455:	f7 f7                	div    %edi
  802457:	89 c1                	mov    %eax,%ecx
  802459:	89 d8                	mov    %ebx,%eax
  80245b:	31 d2                	xor    %edx,%edx
  80245d:	f7 f1                	div    %ecx
  80245f:	89 f0                	mov    %esi,%eax
  802461:	f7 f1                	div    %ecx
  802463:	e9 31 ff ff ff       	jmp    802399 <__umoddi3+0x29>
  802468:	90                   	nop
  802469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802470:	39 dd                	cmp    %ebx,%ebp
  802472:	72 08                	jb     80247c <__umoddi3+0x10c>
  802474:	39 f7                	cmp    %esi,%edi
  802476:	0f 87 21 ff ff ff    	ja     80239d <__umoddi3+0x2d>
  80247c:	89 da                	mov    %ebx,%edx
  80247e:	89 f0                	mov    %esi,%eax
  802480:	29 f8                	sub    %edi,%eax
  802482:	19 ea                	sbb    %ebp,%edx
  802484:	e9 14 ff ff ff       	jmp    80239d <__umoddi3+0x2d>

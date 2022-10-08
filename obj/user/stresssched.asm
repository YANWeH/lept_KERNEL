
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 b7 00 00 00       	call   8000e8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800038:	e8 c0 0b 00 00       	call   800bfd <sys_getenvid>
  80003d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80003f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800044:	e8 db 0e 00 00       	call   800f24 <fork>
  800049:	85 c0                	test   %eax,%eax
  80004b:	74 0f                	je     80005c <umain+0x29>
	for (i = 0; i < 20; i++)
  80004d:	83 c3 01             	add    $0x1,%ebx
  800050:	83 fb 14             	cmp    $0x14,%ebx
  800053:	75 ef                	jne    800044 <umain+0x11>
			break;
	if (i == 20) {
		sys_yield();
  800055:	e8 c2 0b 00 00       	call   800c1c <sys_yield>
		return;
  80005a:	eb 6e                	jmp    8000ca <umain+0x97>
	if (i == 20) {
  80005c:	83 fb 14             	cmp    $0x14,%ebx
  80005f:	74 f4                	je     800055 <umain+0x22>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800061:	89 f0                	mov    %esi,%eax
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	eb 02                	jmp    800074 <umain+0x41>
		asm volatile("pause");
  800072:	f3 90                	pause  
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800074:	8b 50 54             	mov    0x54(%eax),%edx
  800077:	85 d2                	test   %edx,%edx
  800079:	75 f7                	jne    800072 <umain+0x3f>
  80007b:	bb 0a 00 00 00       	mov    $0xa,%ebx

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800080:	e8 97 0b 00 00       	call   800c1c <sys_yield>
  800085:	ba 10 27 00 00       	mov    $0x2710,%edx
		for (j = 0; j < 10000; j++)
			counter++;
  80008a:	a1 08 40 80 00       	mov    0x804008,%eax
  80008f:	83 c0 01             	add    $0x1,%eax
  800092:	a3 08 40 80 00       	mov    %eax,0x804008
		for (j = 0; j < 10000; j++)
  800097:	83 ea 01             	sub    $0x1,%edx
  80009a:	75 ee                	jne    80008a <umain+0x57>
	for (i = 0; i < 10; i++) {
  80009c:	83 eb 01             	sub    $0x1,%ebx
  80009f:	75 df                	jne    800080 <umain+0x4d>
	}

	if (counter != 10*10000)
  8000a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000a6:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000ab:	75 24                	jne    8000d1 <umain+0x9e>
		panic("ran on two CPUs at once (counter is %d)", counter);

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000ad:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8000b2:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000b5:	8b 40 48             	mov    0x48(%eax),%eax
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	52                   	push   %edx
  8000bc:	50                   	push   %eax
  8000bd:	68 5b 26 80 00       	push   $0x80265b
  8000c2:	e8 5c 01 00 00       	call   800223 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp

}
  8000ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d6:	50                   	push   %eax
  8000d7:	68 20 26 80 00       	push   $0x802620
  8000dc:	6a 21                	push   $0x21
  8000de:	68 48 26 80 00       	push   $0x802648
  8000e3:	e8 60 00 00 00       	call   800148 <_panic>

008000e8 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000e8:	55                   	push   %ebp
  8000e9:	89 e5                	mov    %esp,%ebp
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000f3:	e8 05 0b 00 00       	call   800bfd <sys_getenvid>
  8000f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800100:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800105:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010a:	85 db                	test   %ebx,%ebx
  80010c:	7e 07                	jle    800115 <libmain+0x2d>
		binaryname = argv[0];
  80010e:	8b 06                	mov    (%esi),%eax
  800110:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800115:	83 ec 08             	sub    $0x8,%esp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
  80011a:	e8 14 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011f:	e8 0a 00 00 00       	call   80012e <exit>
}
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <exit>:

#include <inc/lib.h>

void exit(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800134:	e8 86 11 00 00       	call   8012bf <close_all>
	sys_env_destroy(0);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 00                	push   $0x0
  80013e:	e8 79 0a 00 00       	call   800bbc <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80014d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800150:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800156:	e8 a2 0a 00 00       	call   800bfd <sys_getenvid>
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	ff 75 0c             	pushl  0xc(%ebp)
  800161:	ff 75 08             	pushl  0x8(%ebp)
  800164:	56                   	push   %esi
  800165:	50                   	push   %eax
  800166:	68 84 26 80 00       	push   $0x802684
  80016b:	e8 b3 00 00 00       	call   800223 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800170:	83 c4 18             	add    $0x18,%esp
  800173:	53                   	push   %ebx
  800174:	ff 75 10             	pushl  0x10(%ebp)
  800177:	e8 56 00 00 00       	call   8001d2 <vcprintf>
	cprintf("\n");
  80017c:	c7 04 24 77 26 80 00 	movl   $0x802677,(%esp)
  800183:	e8 9b 00 00 00       	call   800223 <cprintf>
  800188:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80018b:	cc                   	int3   
  80018c:	eb fd                	jmp    80018b <_panic+0x43>

0080018e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	53                   	push   %ebx
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800198:	8b 13                	mov    (%ebx),%edx
  80019a:	8d 42 01             	lea    0x1(%edx),%eax
  80019d:	89 03                	mov    %eax,(%ebx)
  80019f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ab:	74 09                	je     8001b6 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001ad:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001b4:	c9                   	leave  
  8001b5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	68 ff 00 00 00       	push   $0xff
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	50                   	push   %eax
  8001c2:	e8 b8 09 00 00       	call   800b7f <sys_cputs>
		b->idx = 0;
  8001c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001cd:	83 c4 10             	add    $0x10,%esp
  8001d0:	eb db                	jmp    8001ad <putch+0x1f>

008001d2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e2:	00 00 00 
	b.cnt = 0;
  8001e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ec:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001ef:	ff 75 0c             	pushl  0xc(%ebp)
  8001f2:	ff 75 08             	pushl  0x8(%ebp)
  8001f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001fb:	50                   	push   %eax
  8001fc:	68 8e 01 80 00       	push   $0x80018e
  800201:	e8 1a 01 00 00       	call   800320 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800206:	83 c4 08             	add    $0x8,%esp
  800209:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80020f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800215:	50                   	push   %eax
  800216:	e8 64 09 00 00       	call   800b7f <sys_cputs>

	return b.cnt;
}
  80021b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800229:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80022c:	50                   	push   %eax
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 9d ff ff ff       	call   8001d2 <vcprintf>
	va_end(ap);

	return cnt;
}
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	57                   	push   %edi
  80023b:	56                   	push   %esi
  80023c:	53                   	push   %ebx
  80023d:	83 ec 1c             	sub    $0x1c,%esp
  800240:	89 c7                	mov    %eax,%edi
  800242:	89 d6                	mov    %edx,%esi
  800244:	8b 45 08             	mov    0x8(%ebp),%eax
  800247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800250:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800253:	bb 00 00 00 00       	mov    $0x0,%ebx
  800258:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80025b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80025e:	39 d3                	cmp    %edx,%ebx
  800260:	72 05                	jb     800267 <printnum+0x30>
  800262:	39 45 10             	cmp    %eax,0x10(%ebp)
  800265:	77 7a                	ja     8002e1 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	ff 75 18             	pushl  0x18(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800273:	53                   	push   %ebx
  800274:	ff 75 10             	pushl  0x10(%ebp)
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027d:	ff 75 e0             	pushl  -0x20(%ebp)
  800280:	ff 75 dc             	pushl  -0x24(%ebp)
  800283:	ff 75 d8             	pushl  -0x28(%ebp)
  800286:	e8 45 21 00 00       	call   8023d0 <__udivdi3>
  80028b:	83 c4 18             	add    $0x18,%esp
  80028e:	52                   	push   %edx
  80028f:	50                   	push   %eax
  800290:	89 f2                	mov    %esi,%edx
  800292:	89 f8                	mov    %edi,%eax
  800294:	e8 9e ff ff ff       	call   800237 <printnum>
  800299:	83 c4 20             	add    $0x20,%esp
  80029c:	eb 13                	jmp    8002b1 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80029e:	83 ec 08             	sub    $0x8,%esp
  8002a1:	56                   	push   %esi
  8002a2:	ff 75 18             	pushl  0x18(%ebp)
  8002a5:	ff d7                	call   *%edi
  8002a7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002aa:	83 eb 01             	sub    $0x1,%ebx
  8002ad:	85 db                	test   %ebx,%ebx
  8002af:	7f ed                	jg     80029e <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	56                   	push   %esi
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8002be:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c4:	e8 27 22 00 00       	call   8024f0 <__umoddi3>
  8002c9:	83 c4 14             	add    $0x14,%esp
  8002cc:	0f be 80 a7 26 80 00 	movsbl 0x8026a7(%eax),%eax
  8002d3:	50                   	push   %eax
  8002d4:	ff d7                	call   *%edi
}
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    
  8002e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002e4:	eb c4                	jmp    8002aa <printnum+0x73>

008002e6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ec:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f0:	8b 10                	mov    (%eax),%edx
  8002f2:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f5:	73 0a                	jae    800301 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fa:	89 08                	mov    %ecx,(%eax)
  8002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ff:	88 02                	mov    %al,(%edx)
}
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    

00800303 <printfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800309:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030c:	50                   	push   %eax
  80030d:	ff 75 10             	pushl  0x10(%ebp)
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 05 00 00 00       	call   800320 <vprintfmt>
}
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <vprintfmt>:
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 2c             	sub    $0x2c,%esp
  800329:	8b 75 08             	mov    0x8(%ebp),%esi
  80032c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032f:	8b 7d 10             	mov    0x10(%ebp),%edi
  800332:	e9 c1 03 00 00       	jmp    8006f8 <vprintfmt+0x3d8>
		padc = ' ';
  800337:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80033b:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800342:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8d 47 01             	lea    0x1(%edi),%eax
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035b:	0f b6 17             	movzbl (%edi),%edx
  80035e:	8d 42 dd             	lea    -0x23(%edx),%eax
  800361:	3c 55                	cmp    $0x55,%al
  800363:	0f 87 12 04 00 00    	ja     80077b <vprintfmt+0x45b>
  800369:	0f b6 c0             	movzbl %al,%eax
  80036c:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800376:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80037a:	eb d9                	jmp    800355 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80037f:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800383:	eb d0                	jmp    800355 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800385:	0f b6 d2             	movzbl %dl,%edx
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038b:	b8 00 00 00 00       	mov    $0x0,%eax
  800390:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800393:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800396:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80039a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a0:	83 f9 09             	cmp    $0x9,%ecx
  8003a3:	77 55                	ja     8003fa <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8003a5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a8:	eb e9                	jmp    800393 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 40 04             	lea    0x4(%eax),%eax
  8003b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c2:	79 91                	jns    800355 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d1:	eb 82                	jmp    800355 <vprintfmt+0x35>
  8003d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d6:	85 c0                	test   %eax,%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	0f 49 d0             	cmovns %eax,%edx
  8003e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e6:	e9 6a ff ff ff       	jmp    800355 <vprintfmt+0x35>
  8003eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ee:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003f5:	e9 5b ff ff ff       	jmp    800355 <vprintfmt+0x35>
  8003fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800400:	eb bc                	jmp    8003be <vprintfmt+0x9e>
			lflag++;
  800402:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800405:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800408:	e9 48 ff ff ff       	jmp    800355 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8d 78 04             	lea    0x4(%eax),%edi
  800413:	83 ec 08             	sub    $0x8,%esp
  800416:	53                   	push   %ebx
  800417:	ff 30                	pushl  (%eax)
  800419:	ff d6                	call   *%esi
			break;
  80041b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800421:	e9 cf 02 00 00       	jmp    8006f5 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800426:	8b 45 14             	mov    0x14(%ebp),%eax
  800429:	8d 78 04             	lea    0x4(%eax),%edi
  80042c:	8b 00                	mov    (%eax),%eax
  80042e:	99                   	cltd   
  80042f:	31 d0                	xor    %edx,%eax
  800431:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800433:	83 f8 0f             	cmp    $0xf,%eax
  800436:	7f 23                	jg     80045b <vprintfmt+0x13b>
  800438:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  80043f:	85 d2                	test   %edx,%edx
  800441:	74 18                	je     80045b <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800443:	52                   	push   %edx
  800444:	68 65 2b 80 00       	push   $0x802b65
  800449:	53                   	push   %ebx
  80044a:	56                   	push   %esi
  80044b:	e8 b3 fe ff ff       	call   800303 <printfmt>
  800450:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800453:	89 7d 14             	mov    %edi,0x14(%ebp)
  800456:	e9 9a 02 00 00       	jmp    8006f5 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80045b:	50                   	push   %eax
  80045c:	68 bf 26 80 00       	push   $0x8026bf
  800461:	53                   	push   %ebx
  800462:	56                   	push   %esi
  800463:	e8 9b fe ff ff       	call   800303 <printfmt>
  800468:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80046e:	e9 82 02 00 00       	jmp    8006f5 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	83 c0 04             	add    $0x4,%eax
  800479:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80047c:	8b 45 14             	mov    0x14(%ebp),%eax
  80047f:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800481:	85 ff                	test   %edi,%edi
  800483:	b8 b8 26 80 00       	mov    $0x8026b8,%eax
  800488:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80048b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048f:	0f 8e bd 00 00 00    	jle    800552 <vprintfmt+0x232>
  800495:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800499:	75 0e                	jne    8004a9 <vprintfmt+0x189>
  80049b:	89 75 08             	mov    %esi,0x8(%ebp)
  80049e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a1:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004a7:	eb 6d                	jmp    800516 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a9:	83 ec 08             	sub    $0x8,%esp
  8004ac:	ff 75 d0             	pushl  -0x30(%ebp)
  8004af:	57                   	push   %edi
  8004b0:	e8 6e 03 00 00       	call   800823 <strnlen>
  8004b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b8:	29 c1                	sub    %eax,%ecx
  8004ba:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004bd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004c0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ca:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cc:	eb 0f                	jmp    8004dd <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004ce:	83 ec 08             	sub    $0x8,%esp
  8004d1:	53                   	push   %ebx
  8004d2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	83 ef 01             	sub    $0x1,%edi
  8004da:	83 c4 10             	add    $0x10,%esp
  8004dd:	85 ff                	test   %edi,%edi
  8004df:	7f ed                	jg     8004ce <vprintfmt+0x1ae>
  8004e1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004e4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004e7:	85 c9                	test   %ecx,%ecx
  8004e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ee:	0f 49 c1             	cmovns %ecx,%eax
  8004f1:	29 c1                	sub    %eax,%ecx
  8004f3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004fc:	89 cb                	mov    %ecx,%ebx
  8004fe:	eb 16                	jmp    800516 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800500:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800504:	75 31                	jne    800537 <vprintfmt+0x217>
					putch(ch, putdat);
  800506:	83 ec 08             	sub    $0x8,%esp
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	50                   	push   %eax
  80050d:	ff 55 08             	call   *0x8(%ebp)
  800510:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800513:	83 eb 01             	sub    $0x1,%ebx
  800516:	83 c7 01             	add    $0x1,%edi
  800519:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80051d:	0f be c2             	movsbl %dl,%eax
  800520:	85 c0                	test   %eax,%eax
  800522:	74 59                	je     80057d <vprintfmt+0x25d>
  800524:	85 f6                	test   %esi,%esi
  800526:	78 d8                	js     800500 <vprintfmt+0x1e0>
  800528:	83 ee 01             	sub    $0x1,%esi
  80052b:	79 d3                	jns    800500 <vprintfmt+0x1e0>
  80052d:	89 df                	mov    %ebx,%edi
  80052f:	8b 75 08             	mov    0x8(%ebp),%esi
  800532:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800535:	eb 37                	jmp    80056e <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800537:	0f be d2             	movsbl %dl,%edx
  80053a:	83 ea 20             	sub    $0x20,%edx
  80053d:	83 fa 5e             	cmp    $0x5e,%edx
  800540:	76 c4                	jbe    800506 <vprintfmt+0x1e6>
					putch('?', putdat);
  800542:	83 ec 08             	sub    $0x8,%esp
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	6a 3f                	push   $0x3f
  80054a:	ff 55 08             	call   *0x8(%ebp)
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	eb c1                	jmp    800513 <vprintfmt+0x1f3>
  800552:	89 75 08             	mov    %esi,0x8(%ebp)
  800555:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800558:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80055b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80055e:	eb b6                	jmp    800516 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	53                   	push   %ebx
  800564:	6a 20                	push   $0x20
  800566:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800568:	83 ef 01             	sub    $0x1,%edi
  80056b:	83 c4 10             	add    $0x10,%esp
  80056e:	85 ff                	test   %edi,%edi
  800570:	7f ee                	jg     800560 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800572:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
  800578:	e9 78 01 00 00       	jmp    8006f5 <vprintfmt+0x3d5>
  80057d:	89 df                	mov    %ebx,%edi
  80057f:	8b 75 08             	mov    0x8(%ebp),%esi
  800582:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800585:	eb e7                	jmp    80056e <vprintfmt+0x24e>
	if (lflag >= 2)
  800587:	83 f9 01             	cmp    $0x1,%ecx
  80058a:	7e 3f                	jle    8005cb <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8b 50 04             	mov    0x4(%eax),%edx
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800597:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	8d 40 08             	lea    0x8(%eax),%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8005a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a7:	79 5c                	jns    800605 <vprintfmt+0x2e5>
				putch('-', putdat);
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	53                   	push   %ebx
  8005ad:	6a 2d                	push   $0x2d
  8005af:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b7:	f7 da                	neg    %edx
  8005b9:	83 d1 00             	adc    $0x0,%ecx
  8005bc:	f7 d9                	neg    %ecx
  8005be:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c6:	e9 10 01 00 00       	jmp    8006db <vprintfmt+0x3bb>
	else if (lflag)
  8005cb:	85 c9                	test   %ecx,%ecx
  8005cd:	75 1b                	jne    8005ea <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d7:	89 c1                	mov    %eax,%ecx
  8005d9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005dc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	eb b9                	jmp    8005a3 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 00                	mov    (%eax),%eax
  8005ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f2:	89 c1                	mov    %eax,%ecx
  8005f4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fd:	8d 40 04             	lea    0x4(%eax),%eax
  800600:	89 45 14             	mov    %eax,0x14(%ebp)
  800603:	eb 9e                	jmp    8005a3 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800605:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800608:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 c6 00 00 00       	jmp    8006db <vprintfmt+0x3bb>
	if (lflag >= 2)
  800615:	83 f9 01             	cmp    $0x1,%ecx
  800618:	7e 18                	jle    800632 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	8b 10                	mov    (%eax),%edx
  80061f:	8b 48 04             	mov    0x4(%eax),%ecx
  800622:	8d 40 08             	lea    0x8(%eax),%eax
  800625:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062d:	e9 a9 00 00 00       	jmp    8006db <vprintfmt+0x3bb>
	else if (lflag)
  800632:	85 c9                	test   %ecx,%ecx
  800634:	75 1a                	jne    800650 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	8b 10                	mov    (%eax),%edx
  80063b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800640:	8d 40 04             	lea    0x4(%eax),%eax
  800643:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800646:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064b:	e9 8b 00 00 00       	jmp    8006db <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8b 10                	mov    (%eax),%edx
  800655:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065a:	8d 40 04             	lea    0x4(%eax),%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800660:	b8 0a 00 00 00       	mov    $0xa,%eax
  800665:	eb 74                	jmp    8006db <vprintfmt+0x3bb>
	if (lflag >= 2)
  800667:	83 f9 01             	cmp    $0x1,%ecx
  80066a:	7e 15                	jle    800681 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	8b 10                	mov    (%eax),%edx
  800671:	8b 48 04             	mov    0x4(%eax),%ecx
  800674:	8d 40 08             	lea    0x8(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80067a:	b8 08 00 00 00       	mov    $0x8,%eax
  80067f:	eb 5a                	jmp    8006db <vprintfmt+0x3bb>
	else if (lflag)
  800681:	85 c9                	test   %ecx,%ecx
  800683:	75 17                	jne    80069c <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8b 10                	mov    (%eax),%edx
  80068a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800695:	b8 08 00 00 00       	mov    $0x8,%eax
  80069a:	eb 3f                	jmp    8006db <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 10                	mov    (%eax),%edx
  8006a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a6:	8d 40 04             	lea    0x4(%eax),%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b1:	eb 28                	jmp    8006db <vprintfmt+0x3bb>
			putch('0', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 30                	push   $0x30
  8006b9:	ff d6                	call   *%esi
			putch('x', putdat);
  8006bb:	83 c4 08             	add    $0x8,%esp
  8006be:	53                   	push   %ebx
  8006bf:	6a 78                	push   $0x78
  8006c1:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 10                	mov    (%eax),%edx
  8006c8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006cd:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006d0:	8d 40 04             	lea    0x4(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006e2:	57                   	push   %edi
  8006e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e6:	50                   	push   %eax
  8006e7:	51                   	push   %ecx
  8006e8:	52                   	push   %edx
  8006e9:	89 da                	mov    %ebx,%edx
  8006eb:	89 f0                	mov    %esi,%eax
  8006ed:	e8 45 fb ff ff       	call   800237 <printnum>
			break;
  8006f2:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f8:	83 c7 01             	add    $0x1,%edi
  8006fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ff:	83 f8 25             	cmp    $0x25,%eax
  800702:	0f 84 2f fc ff ff    	je     800337 <vprintfmt+0x17>
			if (ch == '\0')
  800708:	85 c0                	test   %eax,%eax
  80070a:	0f 84 8b 00 00 00    	je     80079b <vprintfmt+0x47b>
			putch(ch, putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	50                   	push   %eax
  800715:	ff d6                	call   *%esi
  800717:	83 c4 10             	add    $0x10,%esp
  80071a:	eb dc                	jmp    8006f8 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80071c:	83 f9 01             	cmp    $0x1,%ecx
  80071f:	7e 15                	jle    800736 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8b 10                	mov    (%eax),%edx
  800726:	8b 48 04             	mov    0x4(%eax),%ecx
  800729:	8d 40 08             	lea    0x8(%eax),%eax
  80072c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072f:	b8 10 00 00 00       	mov    $0x10,%eax
  800734:	eb a5                	jmp    8006db <vprintfmt+0x3bb>
	else if (lflag)
  800736:	85 c9                	test   %ecx,%ecx
  800738:	75 17                	jne    800751 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 10                	mov    (%eax),%edx
  80073f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80074a:	b8 10 00 00 00       	mov    $0x10,%eax
  80074f:	eb 8a                	jmp    8006db <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8b 10                	mov    (%eax),%edx
  800756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075b:	8d 40 04             	lea    0x4(%eax),%eax
  80075e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800761:	b8 10 00 00 00       	mov    $0x10,%eax
  800766:	e9 70 ff ff ff       	jmp    8006db <vprintfmt+0x3bb>
			putch(ch, putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	6a 25                	push   $0x25
  800771:	ff d6                	call   *%esi
			break;
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	e9 7a ff ff ff       	jmp    8006f5 <vprintfmt+0x3d5>
			putch('%', putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	53                   	push   %ebx
  80077f:	6a 25                	push   $0x25
  800781:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	89 f8                	mov    %edi,%eax
  800788:	eb 03                	jmp    80078d <vprintfmt+0x46d>
  80078a:	83 e8 01             	sub    $0x1,%eax
  80078d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800791:	75 f7                	jne    80078a <vprintfmt+0x46a>
  800793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800796:	e9 5a ff ff ff       	jmp    8006f5 <vprintfmt+0x3d5>
}
  80079b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079e:	5b                   	pop    %ebx
  80079f:	5e                   	pop    %esi
  8007a0:	5f                   	pop    %edi
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	83 ec 18             	sub    $0x18,%esp
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b2:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b6:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007c0:	85 c0                	test   %eax,%eax
  8007c2:	74 26                	je     8007ea <vsnprintf+0x47>
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	7e 22                	jle    8007ea <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c8:	ff 75 14             	pushl  0x14(%ebp)
  8007cb:	ff 75 10             	pushl  0x10(%ebp)
  8007ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d1:	50                   	push   %eax
  8007d2:	68 e6 02 80 00       	push   $0x8002e6
  8007d7:	e8 44 fb ff ff       	call   800320 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007df:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e5:	83 c4 10             	add    $0x10,%esp
}
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    
		return -E_INVAL;
  8007ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ef:	eb f7                	jmp    8007e8 <vsnprintf+0x45>

008007f1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007f1:	55                   	push   %ebp
  8007f2:	89 e5                	mov    %esp,%ebp
  8007f4:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f7:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007fa:	50                   	push   %eax
  8007fb:	ff 75 10             	pushl  0x10(%ebp)
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 9a ff ff ff       	call   8007a3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800809:	c9                   	leave  
  80080a:	c3                   	ret    

0080080b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	eb 03                	jmp    80081b <strlen+0x10>
		n++;
  800818:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80081b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80081f:	75 f7                	jne    800818 <strlen+0xd>
	return n;
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082c:	b8 00 00 00 00       	mov    $0x0,%eax
  800831:	eb 03                	jmp    800836 <strnlen+0x13>
		n++;
  800833:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800836:	39 d0                	cmp    %edx,%eax
  800838:	74 06                	je     800840 <strnlen+0x1d>
  80083a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80083e:	75 f3                	jne    800833 <strnlen+0x10>
	return n;
}
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	53                   	push   %ebx
  800846:	8b 45 08             	mov    0x8(%ebp),%eax
  800849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	83 c1 01             	add    $0x1,%ecx
  800851:	83 c2 01             	add    $0x1,%edx
  800854:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800858:	88 5a ff             	mov    %bl,-0x1(%edx)
  80085b:	84 db                	test   %bl,%bl
  80085d:	75 ef                	jne    80084e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80085f:	5b                   	pop    %ebx
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800869:	53                   	push   %ebx
  80086a:	e8 9c ff ff ff       	call   80080b <strlen>
  80086f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	01 d8                	add    %ebx,%eax
  800877:	50                   	push   %eax
  800878:	e8 c5 ff ff ff       	call   800842 <strcpy>
	return dst;
}
  80087d:	89 d8                	mov    %ebx,%eax
  80087f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800882:	c9                   	leave  
  800883:	c3                   	ret    

00800884 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800884:	55                   	push   %ebp
  800885:	89 e5                	mov    %esp,%ebp
  800887:	56                   	push   %esi
  800888:	53                   	push   %ebx
  800889:	8b 75 08             	mov    0x8(%ebp),%esi
  80088c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088f:	89 f3                	mov    %esi,%ebx
  800891:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800894:	89 f2                	mov    %esi,%edx
  800896:	eb 0f                	jmp    8008a7 <strncpy+0x23>
		*dst++ = *src;
  800898:	83 c2 01             	add    $0x1,%edx
  80089b:	0f b6 01             	movzbl (%ecx),%eax
  80089e:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008a1:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a4:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008a7:	39 da                	cmp    %ebx,%edx
  8008a9:	75 ed                	jne    800898 <strncpy+0x14>
	}
	return ret;
}
  8008ab:	89 f0                	mov    %esi,%eax
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	56                   	push   %esi
  8008b5:	53                   	push   %ebx
  8008b6:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008bf:	89 f0                	mov    %esi,%eax
  8008c1:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c5:	85 c9                	test   %ecx,%ecx
  8008c7:	75 0b                	jne    8008d4 <strlcpy+0x23>
  8008c9:	eb 17                	jmp    8008e2 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008cb:	83 c2 01             	add    $0x1,%edx
  8008ce:	83 c0 01             	add    $0x1,%eax
  8008d1:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008d4:	39 d8                	cmp    %ebx,%eax
  8008d6:	74 07                	je     8008df <strlcpy+0x2e>
  8008d8:	0f b6 0a             	movzbl (%edx),%ecx
  8008db:	84 c9                	test   %cl,%cl
  8008dd:	75 ec                	jne    8008cb <strlcpy+0x1a>
		*dst = '\0';
  8008df:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008e2:	29 f0                	sub    %esi,%eax
}
  8008e4:	5b                   	pop    %ebx
  8008e5:	5e                   	pop    %esi
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f1:	eb 06                	jmp    8008f9 <strcmp+0x11>
		p++, q++;
  8008f3:	83 c1 01             	add    $0x1,%ecx
  8008f6:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008f9:	0f b6 01             	movzbl (%ecx),%eax
  8008fc:	84 c0                	test   %al,%al
  8008fe:	74 04                	je     800904 <strcmp+0x1c>
  800900:	3a 02                	cmp    (%edx),%al
  800902:	74 ef                	je     8008f3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800904:	0f b6 c0             	movzbl %al,%eax
  800907:	0f b6 12             	movzbl (%edx),%edx
  80090a:	29 d0                	sub    %edx,%eax
}
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	53                   	push   %ebx
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	8b 55 0c             	mov    0xc(%ebp),%edx
  800918:	89 c3                	mov    %eax,%ebx
  80091a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80091d:	eb 06                	jmp    800925 <strncmp+0x17>
		n--, p++, q++;
  80091f:	83 c0 01             	add    $0x1,%eax
  800922:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800925:	39 d8                	cmp    %ebx,%eax
  800927:	74 16                	je     80093f <strncmp+0x31>
  800929:	0f b6 08             	movzbl (%eax),%ecx
  80092c:	84 c9                	test   %cl,%cl
  80092e:	74 04                	je     800934 <strncmp+0x26>
  800930:	3a 0a                	cmp    (%edx),%cl
  800932:	74 eb                	je     80091f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 00             	movzbl (%eax),%eax
  800937:	0f b6 12             	movzbl (%edx),%edx
  80093a:	29 d0                	sub    %edx,%eax
}
  80093c:	5b                   	pop    %ebx
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    
		return 0;
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
  800944:	eb f6                	jmp    80093c <strncmp+0x2e>

00800946 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800950:	0f b6 10             	movzbl (%eax),%edx
  800953:	84 d2                	test   %dl,%dl
  800955:	74 09                	je     800960 <strchr+0x1a>
		if (*s == c)
  800957:	38 ca                	cmp    %cl,%dl
  800959:	74 0a                	je     800965 <strchr+0x1f>
	for (; *s; s++)
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	eb f0                	jmp    800950 <strchr+0xa>
			return (char *) s;
	return 0;
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800971:	eb 03                	jmp    800976 <strfind+0xf>
  800973:	83 c0 01             	add    $0x1,%eax
  800976:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800979:	38 ca                	cmp    %cl,%dl
  80097b:	74 04                	je     800981 <strfind+0x1a>
  80097d:	84 d2                	test   %dl,%dl
  80097f:	75 f2                	jne    800973 <strfind+0xc>
			break;
	return (char *) s;
}
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    

00800983 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	57                   	push   %edi
  800987:	56                   	push   %esi
  800988:	53                   	push   %ebx
  800989:	8b 7d 08             	mov    0x8(%ebp),%edi
  80098c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80098f:	85 c9                	test   %ecx,%ecx
  800991:	74 13                	je     8009a6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800993:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800999:	75 05                	jne    8009a0 <memset+0x1d>
  80099b:	f6 c1 03             	test   $0x3,%cl
  80099e:	74 0d                	je     8009ad <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	fc                   	cld    
  8009a4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a6:	89 f8                	mov    %edi,%eax
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5f                   	pop    %edi
  8009ab:	5d                   	pop    %ebp
  8009ac:	c3                   	ret    
		c &= 0xFF;
  8009ad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009b1:	89 d3                	mov    %edx,%ebx
  8009b3:	c1 e3 08             	shl    $0x8,%ebx
  8009b6:	89 d0                	mov    %edx,%eax
  8009b8:	c1 e0 18             	shl    $0x18,%eax
  8009bb:	89 d6                	mov    %edx,%esi
  8009bd:	c1 e6 10             	shl    $0x10,%esi
  8009c0:	09 f0                	or     %esi,%eax
  8009c2:	09 c2                	or     %eax,%edx
  8009c4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009c6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c9:	89 d0                	mov    %edx,%eax
  8009cb:	fc                   	cld    
  8009cc:	f3 ab                	rep stos %eax,%es:(%edi)
  8009ce:	eb d6                	jmp    8009a6 <memset+0x23>

008009d0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	57                   	push   %edi
  8009d4:	56                   	push   %esi
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009db:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009de:	39 c6                	cmp    %eax,%esi
  8009e0:	73 35                	jae    800a17 <memmove+0x47>
  8009e2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e5:	39 c2                	cmp    %eax,%edx
  8009e7:	76 2e                	jbe    800a17 <memmove+0x47>
		s += n;
		d += n;
  8009e9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 d6                	mov    %edx,%esi
  8009ee:	09 fe                	or     %edi,%esi
  8009f0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f6:	74 0c                	je     800a04 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009f8:	83 ef 01             	sub    $0x1,%edi
  8009fb:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009fe:	fd                   	std    
  8009ff:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a01:	fc                   	cld    
  800a02:	eb 21                	jmp    800a25 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a04:	f6 c1 03             	test   $0x3,%cl
  800a07:	75 ef                	jne    8009f8 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a09:	83 ef 04             	sub    $0x4,%edi
  800a0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a12:	fd                   	std    
  800a13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a15:	eb ea                	jmp    800a01 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a17:	89 f2                	mov    %esi,%edx
  800a19:	09 c2                	or     %eax,%edx
  800a1b:	f6 c2 03             	test   $0x3,%dl
  800a1e:	74 09                	je     800a29 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a20:	89 c7                	mov    %eax,%edi
  800a22:	fc                   	cld    
  800a23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a25:	5e                   	pop    %esi
  800a26:	5f                   	pop    %edi
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a29:	f6 c1 03             	test   $0x3,%cl
  800a2c:	75 f2                	jne    800a20 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a2e:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a31:	89 c7                	mov    %eax,%edi
  800a33:	fc                   	cld    
  800a34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a36:	eb ed                	jmp    800a25 <memmove+0x55>

00800a38 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a38:	55                   	push   %ebp
  800a39:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a3b:	ff 75 10             	pushl  0x10(%ebp)
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	ff 75 08             	pushl  0x8(%ebp)
  800a44:	e8 87 ff ff ff       	call   8009d0 <memmove>
}
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    

00800a4b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	56                   	push   %esi
  800a4f:	53                   	push   %ebx
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a56:	89 c6                	mov    %eax,%esi
  800a58:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5b:	39 f0                	cmp    %esi,%eax
  800a5d:	74 1c                	je     800a7b <memcmp+0x30>
		if (*s1 != *s2)
  800a5f:	0f b6 08             	movzbl (%eax),%ecx
  800a62:	0f b6 1a             	movzbl (%edx),%ebx
  800a65:	38 d9                	cmp    %bl,%cl
  800a67:	75 08                	jne    800a71 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	83 c2 01             	add    $0x1,%edx
  800a6f:	eb ea                	jmp    800a5b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a71:	0f b6 c1             	movzbl %cl,%eax
  800a74:	0f b6 db             	movzbl %bl,%ebx
  800a77:	29 d8                	sub    %ebx,%eax
  800a79:	eb 05                	jmp    800a80 <memcmp+0x35>
	}

	return 0;
  800a7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8d:	89 c2                	mov    %eax,%edx
  800a8f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a92:	39 d0                	cmp    %edx,%eax
  800a94:	73 09                	jae    800a9f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a96:	38 08                	cmp    %cl,(%eax)
  800a98:	74 05                	je     800a9f <memfind+0x1b>
	for (; s < ends; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	eb f3                	jmp    800a92 <memfind+0xe>
			break;
	return (void *) s;
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	57                   	push   %edi
  800aa5:	56                   	push   %esi
  800aa6:	53                   	push   %ebx
  800aa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aaa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aad:	eb 03                	jmp    800ab2 <strtol+0x11>
		s++;
  800aaf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ab2:	0f b6 01             	movzbl (%ecx),%eax
  800ab5:	3c 20                	cmp    $0x20,%al
  800ab7:	74 f6                	je     800aaf <strtol+0xe>
  800ab9:	3c 09                	cmp    $0x9,%al
  800abb:	74 f2                	je     800aaf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800abd:	3c 2b                	cmp    $0x2b,%al
  800abf:	74 2e                	je     800aef <strtol+0x4e>
	int neg = 0;
  800ac1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800ac6:	3c 2d                	cmp    $0x2d,%al
  800ac8:	74 2f                	je     800af9 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aca:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ad0:	75 05                	jne    800ad7 <strtol+0x36>
  800ad2:	80 39 30             	cmpb   $0x30,(%ecx)
  800ad5:	74 2c                	je     800b03 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad7:	85 db                	test   %ebx,%ebx
  800ad9:	75 0a                	jne    800ae5 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800adb:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ae0:	80 39 30             	cmpb   $0x30,(%ecx)
  800ae3:	74 28                	je     800b0d <strtol+0x6c>
		base = 10;
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aea:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aed:	eb 50                	jmp    800b3f <strtol+0x9e>
		s++;
  800aef:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800af2:	bf 00 00 00 00       	mov    $0x0,%edi
  800af7:	eb d1                	jmp    800aca <strtol+0x29>
		s++, neg = 1;
  800af9:	83 c1 01             	add    $0x1,%ecx
  800afc:	bf 01 00 00 00       	mov    $0x1,%edi
  800b01:	eb c7                	jmp    800aca <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b03:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b07:	74 0e                	je     800b17 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b09:	85 db                	test   %ebx,%ebx
  800b0b:	75 d8                	jne    800ae5 <strtol+0x44>
		s++, base = 8;
  800b0d:	83 c1 01             	add    $0x1,%ecx
  800b10:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b15:	eb ce                	jmp    800ae5 <strtol+0x44>
		s += 2, base = 16;
  800b17:	83 c1 02             	add    $0x2,%ecx
  800b1a:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b1f:	eb c4                	jmp    800ae5 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b21:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b24:	89 f3                	mov    %esi,%ebx
  800b26:	80 fb 19             	cmp    $0x19,%bl
  800b29:	77 29                	ja     800b54 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b2b:	0f be d2             	movsbl %dl,%edx
  800b2e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b31:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b34:	7d 30                	jge    800b66 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b36:	83 c1 01             	add    $0x1,%ecx
  800b39:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b3d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b3f:	0f b6 11             	movzbl (%ecx),%edx
  800b42:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b45:	89 f3                	mov    %esi,%ebx
  800b47:	80 fb 09             	cmp    $0x9,%bl
  800b4a:	77 d5                	ja     800b21 <strtol+0x80>
			dig = *s - '0';
  800b4c:	0f be d2             	movsbl %dl,%edx
  800b4f:	83 ea 30             	sub    $0x30,%edx
  800b52:	eb dd                	jmp    800b31 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b54:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b57:	89 f3                	mov    %esi,%ebx
  800b59:	80 fb 19             	cmp    $0x19,%bl
  800b5c:	77 08                	ja     800b66 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b5e:	0f be d2             	movsbl %dl,%edx
  800b61:	83 ea 37             	sub    $0x37,%edx
  800b64:	eb cb                	jmp    800b31 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6a:	74 05                	je     800b71 <strtol+0xd0>
		*endptr = (char *) s;
  800b6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b6f:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b71:	89 c2                	mov    %eax,%edx
  800b73:	f7 da                	neg    %edx
  800b75:	85 ff                	test   %edi,%edi
  800b77:	0f 45 c2             	cmovne %edx,%eax
}
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	57                   	push   %edi
  800b83:	56                   	push   %esi
  800b84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b90:	89 c3                	mov    %eax,%ebx
  800b92:	89 c7                	mov    %eax,%edi
  800b94:	89 c6                	mov    %eax,%esi
  800b96:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b98:	5b                   	pop    %ebx
  800b99:	5e                   	pop    %esi
  800b9a:	5f                   	pop    %edi
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	57                   	push   %edi
  800ba1:	56                   	push   %esi
  800ba2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bad:	89 d1                	mov    %edx,%ecx
  800baf:	89 d3                	mov    %edx,%ebx
  800bb1:	89 d7                	mov    %edx,%edi
  800bb3:	89 d6                	mov    %edx,%esi
  800bb5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5f                   	pop    %edi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bca:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcd:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd2:	89 cb                	mov    %ecx,%ebx
  800bd4:	89 cf                	mov    %ecx,%edi
  800bd6:	89 ce                	mov    %ecx,%esi
  800bd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bda:	85 c0                	test   %eax,%eax
  800bdc:	7f 08                	jg     800be6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be6:	83 ec 0c             	sub    $0xc,%esp
  800be9:	50                   	push   %eax
  800bea:	6a 03                	push   $0x3
  800bec:	68 9f 29 80 00       	push   $0x80299f
  800bf1:	6a 23                	push   $0x23
  800bf3:	68 bc 29 80 00       	push   $0x8029bc
  800bf8:	e8 4b f5 ff ff       	call   800148 <_panic>

00800bfd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c03:	ba 00 00 00 00       	mov    $0x0,%edx
  800c08:	b8 02 00 00 00       	mov    $0x2,%eax
  800c0d:	89 d1                	mov    %edx,%ecx
  800c0f:	89 d3                	mov    %edx,%ebx
  800c11:	89 d7                	mov    %edx,%edi
  800c13:	89 d6                	mov    %edx,%esi
  800c15:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <sys_yield>:

void
sys_yield(void)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c22:	ba 00 00 00 00       	mov    $0x0,%edx
  800c27:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c2c:	89 d1                	mov    %edx,%ecx
  800c2e:	89 d3                	mov    %edx,%ebx
  800c30:	89 d7                	mov    %edx,%edi
  800c32:	89 d6                	mov    %edx,%esi
  800c34:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c36:	5b                   	pop    %ebx
  800c37:	5e                   	pop    %esi
  800c38:	5f                   	pop    %edi
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c44:	be 00 00 00 00       	mov    $0x0,%esi
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4f:	b8 04 00 00 00       	mov    $0x4,%eax
  800c54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c57:	89 f7                	mov    %esi,%edi
  800c59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5b:	85 c0                	test   %eax,%eax
  800c5d:	7f 08                	jg     800c67 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	83 ec 0c             	sub    $0xc,%esp
  800c6a:	50                   	push   %eax
  800c6b:	6a 04                	push   $0x4
  800c6d:	68 9f 29 80 00       	push   $0x80299f
  800c72:	6a 23                	push   $0x23
  800c74:	68 bc 29 80 00       	push   $0x8029bc
  800c79:	e8 ca f4 ff ff       	call   800148 <_panic>

00800c7e <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c87:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c92:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c95:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c98:	8b 75 18             	mov    0x18(%ebp),%esi
  800c9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	7f 08                	jg     800ca9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	50                   	push   %eax
  800cad:	6a 05                	push   $0x5
  800caf:	68 9f 29 80 00       	push   $0x80299f
  800cb4:	6a 23                	push   $0x23
  800cb6:	68 bc 29 80 00       	push   $0x8029bc
  800cbb:	e8 88 f4 ff ff       	call   800148 <_panic>

00800cc0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cce:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	b8 06 00 00 00       	mov    $0x6,%eax
  800cd9:	89 df                	mov    %ebx,%edi
  800cdb:	89 de                	mov    %ebx,%esi
  800cdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 06                	push   $0x6
  800cf1:	68 9f 29 80 00       	push   $0x80299f
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 bc 29 80 00       	push   $0x8029bc
  800cfd:	e8 46 f4 ff ff       	call   800148 <_panic>

00800d02 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	b8 08 00 00 00       	mov    $0x8,%eax
  800d1b:	89 df                	mov    %ebx,%edi
  800d1d:	89 de                	mov    %ebx,%esi
  800d1f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7f 08                	jg     800d2d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	50                   	push   %eax
  800d31:	6a 08                	push   $0x8
  800d33:	68 9f 29 80 00       	push   $0x80299f
  800d38:	6a 23                	push   $0x23
  800d3a:	68 bc 29 80 00       	push   $0x8029bc
  800d3f:	e8 04 f4 ff ff       	call   800148 <_panic>

00800d44 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d52:	8b 55 08             	mov    0x8(%ebp),%edx
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	b8 09 00 00 00       	mov    $0x9,%eax
  800d5d:	89 df                	mov    %ebx,%edi
  800d5f:	89 de                	mov    %ebx,%esi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6a:	5b                   	pop    %ebx
  800d6b:	5e                   	pop    %esi
  800d6c:	5f                   	pop    %edi
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	50                   	push   %eax
  800d73:	6a 09                	push   $0x9
  800d75:	68 9f 29 80 00       	push   $0x80299f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 bc 29 80 00       	push   $0x8029bc
  800d81:	e8 c2 f3 ff ff       	call   800148 <_panic>

00800d86 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d9f:	89 df                	mov    %ebx,%edi
  800da1:	89 de                	mov    %ebx,%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db1:	83 ec 0c             	sub    $0xc,%esp
  800db4:	50                   	push   %eax
  800db5:	6a 0a                	push   $0xa
  800db7:	68 9f 29 80 00       	push   $0x80299f
  800dbc:	6a 23                	push   $0x23
  800dbe:	68 bc 29 80 00       	push   $0x8029bc
  800dc3:	e8 80 f3 ff ff       	call   800148 <_panic>

00800dc8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd4:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd9:	be 00 00 00 00       	mov    $0x0,%esi
  800dde:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	5d                   	pop    %ebp
  800dea:	c3                   	ret    

00800deb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
  800df1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e01:	89 cb                	mov    %ecx,%ebx
  800e03:	89 cf                	mov    %ecx,%edi
  800e05:	89 ce                	mov    %ecx,%esi
  800e07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	7f 08                	jg     800e15 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	50                   	push   %eax
  800e19:	6a 0d                	push   $0xd
  800e1b:	68 9f 29 80 00       	push   $0x80299f
  800e20:	6a 23                	push   $0x23
  800e22:	68 bc 29 80 00       	push   $0x8029bc
  800e27:	e8 1c f3 ff ff       	call   800148 <_panic>

00800e2c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	57                   	push   %edi
  800e30:	56                   	push   %esi
  800e31:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e32:	ba 00 00 00 00       	mov    $0x0,%edx
  800e37:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e3c:	89 d1                	mov    %edx,%ecx
  800e3e:	89 d3                	mov    %edx,%ebx
  800e40:	89 d7                	mov    %edx,%edi
  800e42:	89 d6                	mov    %edx,%esi
  800e44:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800e53:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800e55:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e59:	74 7f                	je     800eda <pgfault+0x8f>
  800e5b:	89 d8                	mov    %ebx,%eax
  800e5d:	c1 e8 0c             	shr    $0xc,%eax
  800e60:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e67:	f6 c4 08             	test   $0x8,%ah
  800e6a:	74 6e                	je     800eda <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800e6c:	e8 8c fd ff ff       	call   800bfd <sys_getenvid>
  800e71:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e73:	83 ec 04             	sub    $0x4,%esp
  800e76:	6a 07                	push   $0x7
  800e78:	68 00 f0 7f 00       	push   $0x7ff000
  800e7d:	50                   	push   %eax
  800e7e:	e8 b8 fd ff ff       	call   800c3b <sys_page_alloc>
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	85 c0                	test   %eax,%eax
  800e88:	78 64                	js     800eee <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800e8a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800e90:	83 ec 04             	sub    $0x4,%esp
  800e93:	68 00 10 00 00       	push   $0x1000
  800e98:	53                   	push   %ebx
  800e99:	68 00 f0 7f 00       	push   $0x7ff000
  800e9e:	e8 2d fb ff ff       	call   8009d0 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800ea3:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800eaa:	53                   	push   %ebx
  800eab:	56                   	push   %esi
  800eac:	68 00 f0 7f 00       	push   $0x7ff000
  800eb1:	56                   	push   %esi
  800eb2:	e8 c7 fd ff ff       	call   800c7e <sys_page_map>
  800eb7:	83 c4 20             	add    $0x20,%esp
  800eba:	85 c0                	test   %eax,%eax
  800ebc:	78 42                	js     800f00 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800ebe:	83 ec 08             	sub    $0x8,%esp
  800ec1:	68 00 f0 7f 00       	push   $0x7ff000
  800ec6:	56                   	push   %esi
  800ec7:	e8 f4 fd ff ff       	call   800cc0 <sys_page_unmap>
  800ecc:	83 c4 10             	add    $0x10,%esp
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	78 3f                	js     800f12 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800ed3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	68 cc 29 80 00       	push   $0x8029cc
  800ee2:	6a 1d                	push   $0x1d
  800ee4:	68 5b 2a 80 00       	push   $0x802a5b
  800ee9:	e8 5a f2 ff ff       	call   800148 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800eee:	50                   	push   %eax
  800eef:	68 f4 29 80 00       	push   $0x8029f4
  800ef4:	6a 28                	push   $0x28
  800ef6:	68 5b 2a 80 00       	push   $0x802a5b
  800efb:	e8 48 f2 ff ff       	call   800148 <_panic>
		panic("pgfault:page map failed: %e", r);
  800f00:	50                   	push   %eax
  800f01:	68 66 2a 80 00       	push   $0x802a66
  800f06:	6a 2c                	push   $0x2c
  800f08:	68 5b 2a 80 00       	push   $0x802a5b
  800f0d:	e8 36 f2 ff ff       	call   800148 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800f12:	50                   	push   %eax
  800f13:	68 18 2a 80 00       	push   $0x802a18
  800f18:	6a 2e                	push   $0x2e
  800f1a:	68 5b 2a 80 00       	push   $0x802a5b
  800f1f:	e8 24 f2 ff ff       	call   800148 <_panic>

00800f24 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800f2d:	68 4b 0e 80 00       	push   $0x800e4b
  800f32:	e8 d2 12 00 00       	call   802209 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f37:	b8 07 00 00 00       	mov    $0x7,%eax
  800f3c:	cd 30                	int    $0x30
  800f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800f41:	83 c4 10             	add    $0x10,%esp
  800f44:	85 c0                	test   %eax,%eax
  800f46:	78 2f                	js     800f77 <fork+0x53>
  800f48:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f4a:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800f4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f53:	75 6e                	jne    800fc3 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f55:	e8 a3 fc ff ff       	call   800bfd <sys_getenvid>
  800f5a:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f5f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f62:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f67:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  800f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800f6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5f                   	pop    %edi
  800f75:	5d                   	pop    %ebp
  800f76:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800f77:	50                   	push   %eax
  800f78:	68 38 2a 80 00       	push   $0x802a38
  800f7d:	6a 6e                	push   $0x6e
  800f7f:	68 5b 2a 80 00       	push   $0x802a5b
  800f84:	e8 bf f1 ff ff       	call   800148 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800f89:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	25 07 0e 00 00       	and    $0xe07,%eax
  800f98:	50                   	push   %eax
  800f99:	56                   	push   %esi
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	6a 00                	push   $0x0
  800f9e:	e8 db fc ff ff       	call   800c7e <sys_page_map>
  800fa3:	83 c4 20             	add    $0x20,%esp
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fad:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  800fb0:	85 c0                	test   %eax,%eax
  800fb2:	78 bb                	js     800f6f <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800fb4:	83 c3 01             	add    $0x1,%ebx
  800fb7:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  800fbd:	0f 84 a6 00 00 00    	je     801069 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  800fc3:	89 d8                	mov    %ebx,%eax
  800fc5:	c1 e8 0a             	shr    $0xa,%eax
  800fc8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fcf:	a8 01                	test   $0x1,%al
  800fd1:	74 e1                	je     800fb4 <fork+0x90>
  800fd3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fda:	a8 01                	test   $0x1,%al
  800fdc:	74 d6                	je     800fb4 <fork+0x90>
  800fde:	89 de                	mov    %ebx,%esi
  800fe0:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  800fe3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fea:	f6 c4 04             	test   $0x4,%ah
  800fed:	75 9a                	jne    800f89 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  800fef:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800ff6:	a8 02                	test   $0x2,%al
  800ff8:	75 0c                	jne    801006 <fork+0xe2>
  800ffa:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801001:	f6 c4 08             	test   $0x8,%ah
  801004:	74 42                	je     801048 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801006:	83 ec 0c             	sub    $0xc,%esp
  801009:	68 05 08 00 00       	push   $0x805
  80100e:	56                   	push   %esi
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	6a 00                	push   $0x0
  801013:	e8 66 fc ff ff       	call   800c7e <sys_page_map>
  801018:	83 c4 20             	add    $0x20,%esp
  80101b:	85 c0                	test   %eax,%eax
  80101d:	0f 88 4c ff ff ff    	js     800f6f <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801023:	83 ec 0c             	sub    $0xc,%esp
  801026:	68 05 08 00 00       	push   $0x805
  80102b:	56                   	push   %esi
  80102c:	6a 00                	push   $0x0
  80102e:	56                   	push   %esi
  80102f:	6a 00                	push   $0x0
  801031:	e8 48 fc ff ff       	call   800c7e <sys_page_map>
  801036:	83 c4 20             	add    $0x20,%esp
  801039:	85 c0                	test   %eax,%eax
  80103b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801040:	0f 4f c1             	cmovg  %ecx,%eax
  801043:	e9 68 ff ff ff       	jmp    800fb0 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	6a 05                	push   $0x5
  80104d:	56                   	push   %esi
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	6a 00                	push   $0x0
  801052:	e8 27 fc ff ff       	call   800c7e <sys_page_map>
  801057:	83 c4 20             	add    $0x20,%esp
  80105a:	85 c0                	test   %eax,%eax
  80105c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801061:	0f 4f c1             	cmovg  %ecx,%eax
  801064:	e9 47 ff ff ff       	jmp    800fb0 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801069:	83 ec 04             	sub    $0x4,%esp
  80106c:	6a 07                	push   $0x7
  80106e:	68 00 f0 bf ee       	push   $0xeebff000
  801073:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801076:	57                   	push   %edi
  801077:	e8 bf fb ff ff       	call   800c3b <sys_page_alloc>
  80107c:	83 c4 10             	add    $0x10,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	0f 88 e8 fe ff ff    	js     800f6f <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801087:	83 ec 08             	sub    $0x8,%esp
  80108a:	68 6e 22 80 00       	push   $0x80226e
  80108f:	57                   	push   %edi
  801090:	e8 f1 fc ff ff       	call   800d86 <sys_env_set_pgfault_upcall>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	85 c0                	test   %eax,%eax
  80109a:	0f 88 cf fe ff ff    	js     800f6f <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  8010a0:	83 ec 08             	sub    $0x8,%esp
  8010a3:	6a 02                	push   $0x2
  8010a5:	57                   	push   %edi
  8010a6:	e8 57 fc ff ff       	call   800d02 <sys_env_set_status>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	78 08                	js     8010ba <fork+0x196>
	return eid;
  8010b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010b5:	e9 b5 fe ff ff       	jmp    800f6f <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  8010ba:	50                   	push   %eax
  8010bb:	68 82 2a 80 00       	push   $0x802a82
  8010c0:	68 87 00 00 00       	push   $0x87
  8010c5:	68 5b 2a 80 00       	push   $0x802a5b
  8010ca:	e8 79 f0 ff ff       	call   800148 <_panic>

008010cf <sfork>:

// Challenge!
int sfork(void)
{
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
  8010d2:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010d5:	68 a0 2a 80 00       	push   $0x802aa0
  8010da:	68 8f 00 00 00       	push   $0x8f
  8010df:	68 5b 2a 80 00       	push   $0x802a5b
  8010e4:	e8 5f f0 ff ff       	call   800148 <_panic>

008010e9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	05 00 00 00 30       	add    $0x30000000,%eax
  8010f4:	c1 e8 0c             	shr    $0xc,%eax
}
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801104:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801109:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801116:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80111b:	89 c2                	mov    %eax,%edx
  80111d:	c1 ea 16             	shr    $0x16,%edx
  801120:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	74 2a                	je     801156 <fd_alloc+0x46>
  80112c:	89 c2                	mov    %eax,%edx
  80112e:	c1 ea 0c             	shr    $0xc,%edx
  801131:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801138:	f6 c2 01             	test   $0x1,%dl
  80113b:	74 19                	je     801156 <fd_alloc+0x46>
  80113d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801142:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801147:	75 d2                	jne    80111b <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801149:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80114f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801154:	eb 07                	jmp    80115d <fd_alloc+0x4d>
			*fd_store = fd;
  801156:	89 01                	mov    %eax,(%ecx)
			return 0;
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115d:	5d                   	pop    %ebp
  80115e:	c3                   	ret    

0080115f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801165:	83 f8 1f             	cmp    $0x1f,%eax
  801168:	77 36                	ja     8011a0 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80116a:	c1 e0 0c             	shl    $0xc,%eax
  80116d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801172:	89 c2                	mov    %eax,%edx
  801174:	c1 ea 16             	shr    $0x16,%edx
  801177:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117e:	f6 c2 01             	test   $0x1,%dl
  801181:	74 24                	je     8011a7 <fd_lookup+0x48>
  801183:	89 c2                	mov    %eax,%edx
  801185:	c1 ea 0c             	shr    $0xc,%edx
  801188:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118f:	f6 c2 01             	test   $0x1,%dl
  801192:	74 1a                	je     8011ae <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801194:	8b 55 0c             	mov    0xc(%ebp),%edx
  801197:	89 02                	mov    %eax,(%edx)
	return 0;
  801199:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
		return -E_INVAL;
  8011a0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011a5:	eb f7                	jmp    80119e <fd_lookup+0x3f>
		return -E_INVAL;
  8011a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ac:	eb f0                	jmp    80119e <fd_lookup+0x3f>
  8011ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b3:	eb e9                	jmp    80119e <fd_lookup+0x3f>

008011b5 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011be:	ba 38 2b 80 00       	mov    $0x802b38,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011c3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011c8:	39 08                	cmp    %ecx,(%eax)
  8011ca:	74 33                	je     8011ff <dev_lookup+0x4a>
  8011cc:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011cf:	8b 02                	mov    (%edx),%eax
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	75 f3                	jne    8011c8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011d5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011da:	8b 40 48             	mov    0x48(%eax),%eax
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	51                   	push   %ecx
  8011e1:	50                   	push   %eax
  8011e2:	68 b8 2a 80 00       	push   $0x802ab8
  8011e7:	e8 37 f0 ff ff       	call   800223 <cprintf>
	*dev = 0;
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011f5:	83 c4 10             	add    $0x10,%esp
  8011f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    
			*dev = devtab[i];
  8011ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801202:	89 01                	mov    %eax,(%ecx)
			return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb f2                	jmp    8011fd <dev_lookup+0x48>

0080120b <fd_close>:
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
  801211:	83 ec 1c             	sub    $0x1c,%esp
  801214:	8b 75 08             	mov    0x8(%ebp),%esi
  801217:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80121a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80121e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801224:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801227:	50                   	push   %eax
  801228:	e8 32 ff ff ff       	call   80115f <fd_lookup>
  80122d:	89 c3                	mov    %eax,%ebx
  80122f:	83 c4 08             	add    $0x8,%esp
  801232:	85 c0                	test   %eax,%eax
  801234:	78 05                	js     80123b <fd_close+0x30>
	    || fd != fd2)
  801236:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801239:	74 16                	je     801251 <fd_close+0x46>
		return (must_exist ? r : 0);
  80123b:	89 f8                	mov    %edi,%eax
  80123d:	84 c0                	test   %al,%al
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	0f 44 d8             	cmove  %eax,%ebx
}
  801247:	89 d8                	mov    %ebx,%eax
  801249:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80124c:	5b                   	pop    %ebx
  80124d:	5e                   	pop    %esi
  80124e:	5f                   	pop    %edi
  80124f:	5d                   	pop    %ebp
  801250:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801251:	83 ec 08             	sub    $0x8,%esp
  801254:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801257:	50                   	push   %eax
  801258:	ff 36                	pushl  (%esi)
  80125a:	e8 56 ff ff ff       	call   8011b5 <dev_lookup>
  80125f:	89 c3                	mov    %eax,%ebx
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	78 15                	js     80127d <fd_close+0x72>
		if (dev->dev_close)
  801268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126b:	8b 40 10             	mov    0x10(%eax),%eax
  80126e:	85 c0                	test   %eax,%eax
  801270:	74 1b                	je     80128d <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801272:	83 ec 0c             	sub    $0xc,%esp
  801275:	56                   	push   %esi
  801276:	ff d0                	call   *%eax
  801278:	89 c3                	mov    %eax,%ebx
  80127a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80127d:	83 ec 08             	sub    $0x8,%esp
  801280:	56                   	push   %esi
  801281:	6a 00                	push   $0x0
  801283:	e8 38 fa ff ff       	call   800cc0 <sys_page_unmap>
	return r;
  801288:	83 c4 10             	add    $0x10,%esp
  80128b:	eb ba                	jmp    801247 <fd_close+0x3c>
			r = 0;
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801292:	eb e9                	jmp    80127d <fd_close+0x72>

00801294 <close>:

int
close(int fdnum)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
  801297:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80129a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129d:	50                   	push   %eax
  80129e:	ff 75 08             	pushl  0x8(%ebp)
  8012a1:	e8 b9 fe ff ff       	call   80115f <fd_lookup>
  8012a6:	83 c4 08             	add    $0x8,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	78 10                	js     8012bd <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8012ad:	83 ec 08             	sub    $0x8,%esp
  8012b0:	6a 01                	push   $0x1
  8012b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8012b5:	e8 51 ff ff ff       	call   80120b <fd_close>
  8012ba:	83 c4 10             	add    $0x10,%esp
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <close_all>:

void
close_all(void)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	53                   	push   %ebx
  8012c3:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012cb:	83 ec 0c             	sub    $0xc,%esp
  8012ce:	53                   	push   %ebx
  8012cf:	e8 c0 ff ff ff       	call   801294 <close>
	for (i = 0; i < MAXFD; i++)
  8012d4:	83 c3 01             	add    $0x1,%ebx
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	83 fb 20             	cmp    $0x20,%ebx
  8012dd:	75 ec                	jne    8012cb <close_all+0xc>
}
  8012df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012e2:	c9                   	leave  
  8012e3:	c3                   	ret    

008012e4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012e4:	55                   	push   %ebp
  8012e5:	89 e5                	mov    %esp,%ebp
  8012e7:	57                   	push   %edi
  8012e8:	56                   	push   %esi
  8012e9:	53                   	push   %ebx
  8012ea:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012ed:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012f0:	50                   	push   %eax
  8012f1:	ff 75 08             	pushl  0x8(%ebp)
  8012f4:	e8 66 fe ff ff       	call   80115f <fd_lookup>
  8012f9:	89 c3                	mov    %eax,%ebx
  8012fb:	83 c4 08             	add    $0x8,%esp
  8012fe:	85 c0                	test   %eax,%eax
  801300:	0f 88 81 00 00 00    	js     801387 <dup+0xa3>
		return r;
	close(newfdnum);
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	ff 75 0c             	pushl  0xc(%ebp)
  80130c:	e8 83 ff ff ff       	call   801294 <close>

	newfd = INDEX2FD(newfdnum);
  801311:	8b 75 0c             	mov    0xc(%ebp),%esi
  801314:	c1 e6 0c             	shl    $0xc,%esi
  801317:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80131d:	83 c4 04             	add    $0x4,%esp
  801320:	ff 75 e4             	pushl  -0x1c(%ebp)
  801323:	e8 d1 fd ff ff       	call   8010f9 <fd2data>
  801328:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80132a:	89 34 24             	mov    %esi,(%esp)
  80132d:	e8 c7 fd ff ff       	call   8010f9 <fd2data>
  801332:	83 c4 10             	add    $0x10,%esp
  801335:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801337:	89 d8                	mov    %ebx,%eax
  801339:	c1 e8 16             	shr    $0x16,%eax
  80133c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801343:	a8 01                	test   $0x1,%al
  801345:	74 11                	je     801358 <dup+0x74>
  801347:	89 d8                	mov    %ebx,%eax
  801349:	c1 e8 0c             	shr    $0xc,%eax
  80134c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801353:	f6 c2 01             	test   $0x1,%dl
  801356:	75 39                	jne    801391 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801358:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80135b:	89 d0                	mov    %edx,%eax
  80135d:	c1 e8 0c             	shr    $0xc,%eax
  801360:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	25 07 0e 00 00       	and    $0xe07,%eax
  80136f:	50                   	push   %eax
  801370:	56                   	push   %esi
  801371:	6a 00                	push   $0x0
  801373:	52                   	push   %edx
  801374:	6a 00                	push   $0x0
  801376:	e8 03 f9 ff ff       	call   800c7e <sys_page_map>
  80137b:	89 c3                	mov    %eax,%ebx
  80137d:	83 c4 20             	add    $0x20,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	78 31                	js     8013b5 <dup+0xd1>
		goto err;

	return newfdnum;
  801384:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801387:	89 d8                	mov    %ebx,%eax
  801389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801391:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801398:	83 ec 0c             	sub    $0xc,%esp
  80139b:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a0:	50                   	push   %eax
  8013a1:	57                   	push   %edi
  8013a2:	6a 00                	push   $0x0
  8013a4:	53                   	push   %ebx
  8013a5:	6a 00                	push   $0x0
  8013a7:	e8 d2 f8 ff ff       	call   800c7e <sys_page_map>
  8013ac:	89 c3                	mov    %eax,%ebx
  8013ae:	83 c4 20             	add    $0x20,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	79 a3                	jns    801358 <dup+0x74>
	sys_page_unmap(0, newfd);
  8013b5:	83 ec 08             	sub    $0x8,%esp
  8013b8:	56                   	push   %esi
  8013b9:	6a 00                	push   $0x0
  8013bb:	e8 00 f9 ff ff       	call   800cc0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013c0:	83 c4 08             	add    $0x8,%esp
  8013c3:	57                   	push   %edi
  8013c4:	6a 00                	push   $0x0
  8013c6:	e8 f5 f8 ff ff       	call   800cc0 <sys_page_unmap>
	return r;
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	eb b7                	jmp    801387 <dup+0xa3>

008013d0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 14             	sub    $0x14,%esp
  8013d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013dd:	50                   	push   %eax
  8013de:	53                   	push   %ebx
  8013df:	e8 7b fd ff ff       	call   80115f <fd_lookup>
  8013e4:	83 c4 08             	add    $0x8,%esp
  8013e7:	85 c0                	test   %eax,%eax
  8013e9:	78 3f                	js     80142a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f1:	50                   	push   %eax
  8013f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f5:	ff 30                	pushl  (%eax)
  8013f7:	e8 b9 fd ff ff       	call   8011b5 <dev_lookup>
  8013fc:	83 c4 10             	add    $0x10,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	78 27                	js     80142a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801403:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801406:	8b 42 08             	mov    0x8(%edx),%eax
  801409:	83 e0 03             	and    $0x3,%eax
  80140c:	83 f8 01             	cmp    $0x1,%eax
  80140f:	74 1e                	je     80142f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801414:	8b 40 08             	mov    0x8(%eax),%eax
  801417:	85 c0                	test   %eax,%eax
  801419:	74 35                	je     801450 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	ff 75 10             	pushl  0x10(%ebp)
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	52                   	push   %edx
  801425:	ff d0                	call   *%eax
  801427:	83 c4 10             	add    $0x10,%esp
}
  80142a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142d:	c9                   	leave  
  80142e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80142f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801434:	8b 40 48             	mov    0x48(%eax),%eax
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	53                   	push   %ebx
  80143b:	50                   	push   %eax
  80143c:	68 fc 2a 80 00       	push   $0x802afc
  801441:	e8 dd ed ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144e:	eb da                	jmp    80142a <read+0x5a>
		return -E_NOT_SUPP;
  801450:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801455:	eb d3                	jmp    80142a <read+0x5a>

00801457 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	57                   	push   %edi
  80145b:	56                   	push   %esi
  80145c:	53                   	push   %ebx
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	8b 7d 08             	mov    0x8(%ebp),%edi
  801463:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801466:	bb 00 00 00 00       	mov    $0x0,%ebx
  80146b:	39 f3                	cmp    %esi,%ebx
  80146d:	73 25                	jae    801494 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	89 f0                	mov    %esi,%eax
  801474:	29 d8                	sub    %ebx,%eax
  801476:	50                   	push   %eax
  801477:	89 d8                	mov    %ebx,%eax
  801479:	03 45 0c             	add    0xc(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	57                   	push   %edi
  80147e:	e8 4d ff ff ff       	call   8013d0 <read>
		if (m < 0)
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 08                	js     801492 <readn+0x3b>
			return m;
		if (m == 0)
  80148a:	85 c0                	test   %eax,%eax
  80148c:	74 06                	je     801494 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80148e:	01 c3                	add    %eax,%ebx
  801490:	eb d9                	jmp    80146b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801492:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801494:	89 d8                	mov    %ebx,%eax
  801496:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801499:	5b                   	pop    %ebx
  80149a:	5e                   	pop    %esi
  80149b:	5f                   	pop    %edi
  80149c:	5d                   	pop    %ebp
  80149d:	c3                   	ret    

0080149e <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	53                   	push   %ebx
  8014a2:	83 ec 14             	sub    $0x14,%esp
  8014a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ab:	50                   	push   %eax
  8014ac:	53                   	push   %ebx
  8014ad:	e8 ad fc ff ff       	call   80115f <fd_lookup>
  8014b2:	83 c4 08             	add    $0x8,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 3a                	js     8014f3 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bf:	50                   	push   %eax
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c3:	ff 30                	pushl  (%eax)
  8014c5:	e8 eb fc ff ff       	call   8011b5 <dev_lookup>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 22                	js     8014f3 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d8:	74 1e                	je     8014f8 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8014e0:	85 d2                	test   %edx,%edx
  8014e2:	74 35                	je     801519 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	ff 75 10             	pushl  0x10(%ebp)
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	50                   	push   %eax
  8014ee:	ff d2                	call   *%edx
  8014f0:	83 c4 10             	add    $0x10,%esp
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014fd:	8b 40 48             	mov    0x48(%eax),%eax
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	53                   	push   %ebx
  801504:	50                   	push   %eax
  801505:	68 18 2b 80 00       	push   $0x802b18
  80150a:	e8 14 ed ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801517:	eb da                	jmp    8014f3 <write+0x55>
		return -E_NOT_SUPP;
  801519:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151e:	eb d3                	jmp    8014f3 <write+0x55>

00801520 <seek>:

int
seek(int fdnum, off_t offset)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801526:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801529:	50                   	push   %eax
  80152a:	ff 75 08             	pushl  0x8(%ebp)
  80152d:	e8 2d fc ff ff       	call   80115f <fd_lookup>
  801532:	83 c4 08             	add    $0x8,%esp
  801535:	85 c0                	test   %eax,%eax
  801537:	78 0e                	js     801547 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801542:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	53                   	push   %ebx
  80154d:	83 ec 14             	sub    $0x14,%esp
  801550:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801553:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801556:	50                   	push   %eax
  801557:	53                   	push   %ebx
  801558:	e8 02 fc ff ff       	call   80115f <fd_lookup>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	78 37                	js     80159b <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801564:	83 ec 08             	sub    $0x8,%esp
  801567:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156a:	50                   	push   %eax
  80156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156e:	ff 30                	pushl  (%eax)
  801570:	e8 40 fc ff ff       	call   8011b5 <dev_lookup>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	85 c0                	test   %eax,%eax
  80157a:	78 1f                	js     80159b <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801583:	74 1b                	je     8015a0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801588:	8b 52 18             	mov    0x18(%edx),%edx
  80158b:	85 d2                	test   %edx,%edx
  80158d:	74 32                	je     8015c1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	ff 75 0c             	pushl  0xc(%ebp)
  801595:	50                   	push   %eax
  801596:	ff d2                	call   *%edx
  801598:	83 c4 10             	add    $0x10,%esp
}
  80159b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    
			thisenv->env_id, fdnum);
  8015a0:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015a5:	8b 40 48             	mov    0x48(%eax),%eax
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	53                   	push   %ebx
  8015ac:	50                   	push   %eax
  8015ad:	68 d8 2a 80 00       	push   $0x802ad8
  8015b2:	e8 6c ec ff ff       	call   800223 <cprintf>
		return -E_INVAL;
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015bf:	eb da                	jmp    80159b <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015c6:	eb d3                	jmp    80159b <ftruncate+0x52>

008015c8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	53                   	push   %ebx
  8015cc:	83 ec 14             	sub    $0x14,%esp
  8015cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d5:	50                   	push   %eax
  8015d6:	ff 75 08             	pushl  0x8(%ebp)
  8015d9:	e8 81 fb ff ff       	call   80115f <fd_lookup>
  8015de:	83 c4 08             	add    $0x8,%esp
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	78 4b                	js     801630 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015eb:	50                   	push   %eax
  8015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ef:	ff 30                	pushl  (%eax)
  8015f1:	e8 bf fb ff ff       	call   8011b5 <dev_lookup>
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	78 33                	js     801630 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801600:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801604:	74 2f                	je     801635 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801606:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801609:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801610:	00 00 00 
	stat->st_isdir = 0;
  801613:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80161a:	00 00 00 
	stat->st_dev = dev;
  80161d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801623:	83 ec 08             	sub    $0x8,%esp
  801626:	53                   	push   %ebx
  801627:	ff 75 f0             	pushl  -0x10(%ebp)
  80162a:	ff 50 14             	call   *0x14(%eax)
  80162d:	83 c4 10             	add    $0x10,%esp
}
  801630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801633:	c9                   	leave  
  801634:	c3                   	ret    
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80163a:	eb f4                	jmp    801630 <fstat+0x68>

0080163c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	6a 00                	push   $0x0
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 e7 01 00 00       	call   801835 <open>
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	85 c0                	test   %eax,%eax
  801655:	78 1b                	js     801672 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801657:	83 ec 08             	sub    $0x8,%esp
  80165a:	ff 75 0c             	pushl  0xc(%ebp)
  80165d:	50                   	push   %eax
  80165e:	e8 65 ff ff ff       	call   8015c8 <fstat>
  801663:	89 c6                	mov    %eax,%esi
	close(fd);
  801665:	89 1c 24             	mov    %ebx,(%esp)
  801668:	e8 27 fc ff ff       	call   801294 <close>
	return r;
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	89 f3                	mov    %esi,%ebx
}
  801672:	89 d8                	mov    %ebx,%eax
  801674:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801677:	5b                   	pop    %ebx
  801678:	5e                   	pop    %esi
  801679:	5d                   	pop    %ebp
  80167a:	c3                   	ret    

0080167b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
  801680:	89 c6                	mov    %eax,%esi
  801682:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801684:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80168b:	74 27                	je     8016b4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80168d:	6a 07                	push   $0x7
  80168f:	68 00 50 80 00       	push   $0x805000
  801694:	56                   	push   %esi
  801695:	ff 35 00 40 80 00    	pushl  0x804000
  80169b:	e8 5b 0c 00 00       	call   8022fb <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016a0:	83 c4 0c             	add    $0xc,%esp
  8016a3:	6a 00                	push   $0x0
  8016a5:	53                   	push   %ebx
  8016a6:	6a 00                	push   $0x0
  8016a8:	e8 e7 0b 00 00       	call   802294 <ipc_recv>
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5e                   	pop    %esi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	6a 01                	push   $0x1
  8016b9:	e8 91 0c 00 00       	call   80234f <ipc_find_env>
  8016be:	a3 00 40 80 00       	mov    %eax,0x804000
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	eb c5                	jmp    80168d <fsipc+0x12>

008016c8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dc:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8016eb:	e8 8b ff ff ff       	call   80167b <fsipc>
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <devfile_flush>:
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fe:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801703:	ba 00 00 00 00       	mov    $0x0,%edx
  801708:	b8 06 00 00 00       	mov    $0x6,%eax
  80170d:	e8 69 ff ff ff       	call   80167b <fsipc>
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <devfile_stat>:
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	53                   	push   %ebx
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 40 0c             	mov    0xc(%eax),%eax
  801724:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801729:	ba 00 00 00 00       	mov    $0x0,%edx
  80172e:	b8 05 00 00 00       	mov    $0x5,%eax
  801733:	e8 43 ff ff ff       	call   80167b <fsipc>
  801738:	85 c0                	test   %eax,%eax
  80173a:	78 2c                	js     801768 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	68 00 50 80 00       	push   $0x805000
  801744:	53                   	push   %ebx
  801745:	e8 f8 f0 ff ff       	call   800842 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80174a:	a1 80 50 80 00       	mov    0x805080,%eax
  80174f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801755:	a1 84 50 80 00       	mov    0x805084,%eax
  80175a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801768:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <devfile_write>:
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	8b 45 10             	mov    0x10(%ebp),%eax
  801776:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80177b:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801780:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801783:	8b 55 08             	mov    0x8(%ebp),%edx
  801786:	8b 52 0c             	mov    0xc(%edx),%edx
  801789:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80178f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801794:	50                   	push   %eax
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	68 08 50 80 00       	push   $0x805008
  80179d:	e8 2e f2 ff ff       	call   8009d0 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017ac:	e8 ca fe ff ff       	call   80167b <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_read>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	56                   	push   %esi
  8017b7:	53                   	push   %ebx
  8017b8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017c6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 03 00 00 00       	mov    $0x3,%eax
  8017d6:	e8 a0 fe ff ff       	call   80167b <fsipc>
  8017db:	89 c3                	mov    %eax,%ebx
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 1f                	js     801800 <devfile_read+0x4d>
	assert(r <= n);
  8017e1:	39 f0                	cmp    %esi,%eax
  8017e3:	77 24                	ja     801809 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ea:	7f 33                	jg     80181f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017ec:	83 ec 04             	sub    $0x4,%esp
  8017ef:	50                   	push   %eax
  8017f0:	68 00 50 80 00       	push   $0x805000
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	e8 d3 f1 ff ff       	call   8009d0 <memmove>
	return r;
  8017fd:	83 c4 10             	add    $0x10,%esp
}
  801800:	89 d8                	mov    %ebx,%eax
  801802:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801805:	5b                   	pop    %ebx
  801806:	5e                   	pop    %esi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    
	assert(r <= n);
  801809:	68 4c 2b 80 00       	push   $0x802b4c
  80180e:	68 53 2b 80 00       	push   $0x802b53
  801813:	6a 7b                	push   $0x7b
  801815:	68 68 2b 80 00       	push   $0x802b68
  80181a:	e8 29 e9 ff ff       	call   800148 <_panic>
	assert(r <= PGSIZE);
  80181f:	68 73 2b 80 00       	push   $0x802b73
  801824:	68 53 2b 80 00       	push   $0x802b53
  801829:	6a 7c                	push   $0x7c
  80182b:	68 68 2b 80 00       	push   $0x802b68
  801830:	e8 13 e9 ff ff       	call   800148 <_panic>

00801835 <open>:
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	83 ec 1c             	sub    $0x1c,%esp
  80183d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801840:	56                   	push   %esi
  801841:	e8 c5 ef ff ff       	call   80080b <strlen>
  801846:	83 c4 10             	add    $0x10,%esp
  801849:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184e:	7f 6c                	jg     8018bc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801856:	50                   	push   %eax
  801857:	e8 b4 f8 ff ff       	call   801110 <fd_alloc>
  80185c:	89 c3                	mov    %eax,%ebx
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 c0                	test   %eax,%eax
  801863:	78 3c                	js     8018a1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	56                   	push   %esi
  801869:	68 00 50 80 00       	push   $0x805000
  80186e:	e8 cf ef ff ff       	call   800842 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80187b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187e:	b8 01 00 00 00       	mov    $0x1,%eax
  801883:	e8 f3 fd ff ff       	call   80167b <fsipc>
  801888:	89 c3                	mov    %eax,%ebx
  80188a:	83 c4 10             	add    $0x10,%esp
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 19                	js     8018aa <open+0x75>
	return fd2num(fd);
  801891:	83 ec 0c             	sub    $0xc,%esp
  801894:	ff 75 f4             	pushl  -0xc(%ebp)
  801897:	e8 4d f8 ff ff       	call   8010e9 <fd2num>
  80189c:	89 c3                	mov    %eax,%ebx
  80189e:	83 c4 10             	add    $0x10,%esp
}
  8018a1:	89 d8                	mov    %ebx,%eax
  8018a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    
		fd_close(fd, 0);
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b2:	e8 54 f9 ff ff       	call   80120b <fd_close>
		return r;
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	eb e5                	jmp    8018a1 <open+0x6c>
		return -E_BAD_PATH;
  8018bc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018c1:	eb de                	jmp    8018a1 <open+0x6c>

008018c3 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d3:	e8 a3 fd ff ff       	call   80167b <fsipc>
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018e0:	68 7f 2b 80 00       	push   $0x802b7f
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	e8 55 ef ff ff       	call   800842 <strcpy>
	return 0;
}
  8018ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <devsock_close>:
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	53                   	push   %ebx
  8018f8:	83 ec 10             	sub    $0x10,%esp
  8018fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018fe:	53                   	push   %ebx
  8018ff:	e8 84 0a 00 00       	call   802388 <pageref>
  801904:	83 c4 10             	add    $0x10,%esp
		return 0;
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80190c:	83 f8 01             	cmp    $0x1,%eax
  80190f:	74 07                	je     801918 <devsock_close+0x24>
}
  801911:	89 d0                	mov    %edx,%eax
  801913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801916:	c9                   	leave  
  801917:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801918:	83 ec 0c             	sub    $0xc,%esp
  80191b:	ff 73 0c             	pushl  0xc(%ebx)
  80191e:	e8 b7 02 00 00       	call   801bda <nsipc_close>
  801923:	89 c2                	mov    %eax,%edx
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	eb e7                	jmp    801911 <devsock_close+0x1d>

0080192a <devsock_write>:
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801930:	6a 00                	push   $0x0
  801932:	ff 75 10             	pushl  0x10(%ebp)
  801935:	ff 75 0c             	pushl  0xc(%ebp)
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	ff 70 0c             	pushl  0xc(%eax)
  80193e:	e8 74 03 00 00       	call   801cb7 <nsipc_send>
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <devsock_read>:
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	ff 75 10             	pushl  0x10(%ebp)
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	ff 70 0c             	pushl  0xc(%eax)
  801959:	e8 ed 02 00 00       	call   801c4b <nsipc_recv>
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <fd2sockid>:
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801966:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	e8 ef f7 ff ff       	call   80115f <fd_lookup>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	85 c0                	test   %eax,%eax
  801975:	78 10                	js     801987 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801980:	39 08                	cmp    %ecx,(%eax)
  801982:	75 05                	jne    801989 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801984:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    
		return -E_NOT_SUPP;
  801989:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198e:	eb f7                	jmp    801987 <fd2sockid+0x27>

00801990 <alloc_sockfd>:
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	56                   	push   %esi
  801994:	53                   	push   %ebx
  801995:	83 ec 1c             	sub    $0x1c,%esp
  801998:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80199a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	e8 6d f7 ff ff       	call   801110 <fd_alloc>
  8019a3:	89 c3                	mov    %eax,%ebx
  8019a5:	83 c4 10             	add    $0x10,%esp
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	78 43                	js     8019ef <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019ac:	83 ec 04             	sub    $0x4,%esp
  8019af:	68 07 04 00 00       	push   $0x407
  8019b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b7:	6a 00                	push   $0x0
  8019b9:	e8 7d f2 ff ff       	call   800c3b <sys_page_alloc>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	78 28                	js     8019ef <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ca:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019d0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019dc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019df:	83 ec 0c             	sub    $0xc,%esp
  8019e2:	50                   	push   %eax
  8019e3:	e8 01 f7 ff ff       	call   8010e9 <fd2num>
  8019e8:	89 c3                	mov    %eax,%ebx
  8019ea:	83 c4 10             	add    $0x10,%esp
  8019ed:	eb 0c                	jmp    8019fb <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	56                   	push   %esi
  8019f3:	e8 e2 01 00 00       	call   801bda <nsipc_close>
		return r;
  8019f8:	83 c4 10             	add    $0x10,%esp
}
  8019fb:	89 d8                	mov    %ebx,%eax
  8019fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    

00801a04 <accept>:
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	e8 4e ff ff ff       	call   801960 <fd2sockid>
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 1b                	js     801a31 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	ff 75 10             	pushl  0x10(%ebp)
  801a1c:	ff 75 0c             	pushl  0xc(%ebp)
  801a1f:	50                   	push   %eax
  801a20:	e8 0e 01 00 00       	call   801b33 <nsipc_accept>
  801a25:	83 c4 10             	add    $0x10,%esp
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 05                	js     801a31 <accept+0x2d>
	return alloc_sockfd(r);
  801a2c:	e8 5f ff ff ff       	call   801990 <alloc_sockfd>
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <bind>:
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	e8 1f ff ff ff       	call   801960 <fd2sockid>
  801a41:	85 c0                	test   %eax,%eax
  801a43:	78 12                	js     801a57 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	ff 75 10             	pushl  0x10(%ebp)
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	50                   	push   %eax
  801a4f:	e8 2f 01 00 00       	call   801b83 <nsipc_bind>
  801a54:	83 c4 10             	add    $0x10,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <shutdown>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	e8 f9 fe ff ff       	call   801960 <fd2sockid>
  801a67:	85 c0                	test   %eax,%eax
  801a69:	78 0f                	js     801a7a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	50                   	push   %eax
  801a72:	e8 41 01 00 00       	call   801bb8 <nsipc_shutdown>
  801a77:	83 c4 10             	add    $0x10,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <connect>:
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	e8 d6 fe ff ff       	call   801960 <fd2sockid>
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 12                	js     801aa0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a8e:	83 ec 04             	sub    $0x4,%esp
  801a91:	ff 75 10             	pushl  0x10(%ebp)
  801a94:	ff 75 0c             	pushl  0xc(%ebp)
  801a97:	50                   	push   %eax
  801a98:	e8 57 01 00 00       	call   801bf4 <nsipc_connect>
  801a9d:	83 c4 10             	add    $0x10,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <listen>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	e8 b0 fe ff ff       	call   801960 <fd2sockid>
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 0f                	js     801ac3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	50                   	push   %eax
  801abb:	e8 69 01 00 00       	call   801c29 <nsipc_listen>
  801ac0:	83 c4 10             	add    $0x10,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801acb:	ff 75 10             	pushl  0x10(%ebp)
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	e8 3c 02 00 00       	call   801d15 <nsipc_socket>
  801ad9:	83 c4 10             	add    $0x10,%esp
  801adc:	85 c0                	test   %eax,%eax
  801ade:	78 05                	js     801ae5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ae0:	e8 ab fe ff ff       	call   801990 <alloc_sockfd>
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	53                   	push   %ebx
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801af0:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801af7:	74 26                	je     801b1f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801af9:	6a 07                	push   $0x7
  801afb:	68 00 60 80 00       	push   $0x806000
  801b00:	53                   	push   %ebx
  801b01:	ff 35 04 40 80 00    	pushl  0x804004
  801b07:	e8 ef 07 00 00       	call   8022fb <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b0c:	83 c4 0c             	add    $0xc,%esp
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	e8 7a 07 00 00       	call   802294 <ipc_recv>
}
  801b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	6a 02                	push   $0x2
  801b24:	e8 26 08 00 00       	call   80234f <ipc_find_env>
  801b29:	a3 04 40 80 00       	mov    %eax,0x804004
  801b2e:	83 c4 10             	add    $0x10,%esp
  801b31:	eb c6                	jmp    801af9 <nsipc+0x12>

00801b33 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b43:	8b 06                	mov    (%esi),%eax
  801b45:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4f:	e8 93 ff ff ff       	call   801ae7 <nsipc>
  801b54:	89 c3                	mov    %eax,%ebx
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 20                	js     801b7a <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	ff 35 10 60 80 00    	pushl  0x806010
  801b63:	68 00 60 80 00       	push   $0x806000
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	e8 60 ee ff ff       	call   8009d0 <memmove>
		*addrlen = ret->ret_addrlen;
  801b70:	a1 10 60 80 00       	mov    0x806010,%eax
  801b75:	89 06                	mov    %eax,(%esi)
  801b77:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	53                   	push   %ebx
  801b87:	83 ec 08             	sub    $0x8,%esp
  801b8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b95:	53                   	push   %ebx
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	68 04 60 80 00       	push   $0x806004
  801b9e:	e8 2d ee ff ff       	call   8009d0 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ba3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ba9:	b8 02 00 00 00       	mov    $0x2,%eax
  801bae:	e8 34 ff ff ff       	call   801ae7 <nsipc>
}
  801bb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bce:	b8 03 00 00 00       	mov    $0x3,%eax
  801bd3:	e8 0f ff ff ff       	call   801ae7 <nsipc>
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <nsipc_close>:

int
nsipc_close(int s)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801be8:	b8 04 00 00 00       	mov    $0x4,%eax
  801bed:	e8 f5 fe ff ff       	call   801ae7 <nsipc>
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c06:	53                   	push   %ebx
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	68 04 60 80 00       	push   $0x806004
  801c0f:	e8 bc ed ff ff       	call   8009d0 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c14:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c1a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c1f:	e8 c3 fe ff ff       	call   801ae7 <nsipc>
}
  801c24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c44:	e8 9e fe ff ff       	call   801ae7 <nsipc>
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c5b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c61:	8b 45 14             	mov    0x14(%ebp),%eax
  801c64:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c69:	b8 07 00 00 00       	mov    $0x7,%eax
  801c6e:	e8 74 fe ff ff       	call   801ae7 <nsipc>
  801c73:	89 c3                	mov    %eax,%ebx
  801c75:	85 c0                	test   %eax,%eax
  801c77:	78 1f                	js     801c98 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c79:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c7e:	7f 21                	jg     801ca1 <nsipc_recv+0x56>
  801c80:	39 c6                	cmp    %eax,%esi
  801c82:	7c 1d                	jl     801ca1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	50                   	push   %eax
  801c88:	68 00 60 80 00       	push   $0x806000
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	e8 3b ed ff ff       	call   8009d0 <memmove>
  801c95:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ca1:	68 8b 2b 80 00       	push   $0x802b8b
  801ca6:	68 53 2b 80 00       	push   $0x802b53
  801cab:	6a 62                	push   $0x62
  801cad:	68 a0 2b 80 00       	push   $0x802ba0
  801cb2:	e8 91 e4 ff ff       	call   800148 <_panic>

00801cb7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cc9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ccf:	7f 2e                	jg     801cff <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	53                   	push   %ebx
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	68 0c 60 80 00       	push   $0x80600c
  801cdd:	e8 ee ec ff ff       	call   8009d0 <memmove>
	nsipcbuf.send.req_size = size;
  801ce2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ceb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cf0:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf5:	e8 ed fd ff ff       	call   801ae7 <nsipc>
}
  801cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    
	assert(size < 1600);
  801cff:	68 ac 2b 80 00       	push   $0x802bac
  801d04:	68 53 2b 80 00       	push   $0x802b53
  801d09:	6a 6d                	push   $0x6d
  801d0b:	68 a0 2b 80 00       	push   $0x802ba0
  801d10:	e8 33 e4 ff ff       	call   800148 <_panic>

00801d15 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d26:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d33:	b8 09 00 00 00       	mov    $0x9,%eax
  801d38:	e8 aa fd ff ff       	call   801ae7 <nsipc>
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 a7 f3 ff ff       	call   8010f9 <fd2data>
  801d52:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d54:	83 c4 08             	add    $0x8,%esp
  801d57:	68 b8 2b 80 00       	push   $0x802bb8
  801d5c:	53                   	push   %ebx
  801d5d:	e8 e0 ea ff ff       	call   800842 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d62:	8b 46 04             	mov    0x4(%esi),%eax
  801d65:	2b 06                	sub    (%esi),%eax
  801d67:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d6d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d74:	00 00 00 
	stat->st_dev = &devpipe;
  801d77:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d7e:	30 80 00 
	return 0;
}
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
  801d86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    

00801d8d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	53                   	push   %ebx
  801d91:	83 ec 0c             	sub    $0xc,%esp
  801d94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d97:	53                   	push   %ebx
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 21 ef ff ff       	call   800cc0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d9f:	89 1c 24             	mov    %ebx,(%esp)
  801da2:	e8 52 f3 ff ff       	call   8010f9 <fd2data>
  801da7:	83 c4 08             	add    $0x8,%esp
  801daa:	50                   	push   %eax
  801dab:	6a 00                	push   $0x0
  801dad:	e8 0e ef ff ff       	call   800cc0 <sys_page_unmap>
}
  801db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <_pipeisclosed>:
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	57                   	push   %edi
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 1c             	sub    $0x1c,%esp
  801dc0:	89 c7                	mov    %eax,%edi
  801dc2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dc4:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801dc9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	57                   	push   %edi
  801dd0:	e8 b3 05 00 00       	call   802388 <pageref>
  801dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd8:	89 34 24             	mov    %esi,(%esp)
  801ddb:	e8 a8 05 00 00       	call   802388 <pageref>
		nn = thisenv->env_runs;
  801de0:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801de6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	39 cb                	cmp    %ecx,%ebx
  801dee:	74 1b                	je     801e0b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801df0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801df3:	75 cf                	jne    801dc4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801df5:	8b 42 58             	mov    0x58(%edx),%eax
  801df8:	6a 01                	push   $0x1
  801dfa:	50                   	push   %eax
  801dfb:	53                   	push   %ebx
  801dfc:	68 bf 2b 80 00       	push   $0x802bbf
  801e01:	e8 1d e4 ff ff       	call   800223 <cprintf>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	eb b9                	jmp    801dc4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e0b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e0e:	0f 94 c0             	sete   %al
  801e11:	0f b6 c0             	movzbl %al,%eax
}
  801e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    

00801e1c <devpipe_write>:
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	57                   	push   %edi
  801e20:	56                   	push   %esi
  801e21:	53                   	push   %ebx
  801e22:	83 ec 28             	sub    $0x28,%esp
  801e25:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e28:	56                   	push   %esi
  801e29:	e8 cb f2 ff ff       	call   8010f9 <fd2data>
  801e2e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	bf 00 00 00 00       	mov    $0x0,%edi
  801e38:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e3b:	74 4f                	je     801e8c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e3d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e40:	8b 0b                	mov    (%ebx),%ecx
  801e42:	8d 51 20             	lea    0x20(%ecx),%edx
  801e45:	39 d0                	cmp    %edx,%eax
  801e47:	72 14                	jb     801e5d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e49:	89 da                	mov    %ebx,%edx
  801e4b:	89 f0                	mov    %esi,%eax
  801e4d:	e8 65 ff ff ff       	call   801db7 <_pipeisclosed>
  801e52:	85 c0                	test   %eax,%eax
  801e54:	75 3a                	jne    801e90 <devpipe_write+0x74>
			sys_yield();
  801e56:	e8 c1 ed ff ff       	call   800c1c <sys_yield>
  801e5b:	eb e0                	jmp    801e3d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e60:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e64:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e67:	89 c2                	mov    %eax,%edx
  801e69:	c1 fa 1f             	sar    $0x1f,%edx
  801e6c:	89 d1                	mov    %edx,%ecx
  801e6e:	c1 e9 1b             	shr    $0x1b,%ecx
  801e71:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e74:	83 e2 1f             	and    $0x1f,%edx
  801e77:	29 ca                	sub    %ecx,%edx
  801e79:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e7d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e81:	83 c0 01             	add    $0x1,%eax
  801e84:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e87:	83 c7 01             	add    $0x1,%edi
  801e8a:	eb ac                	jmp    801e38 <devpipe_write+0x1c>
	return i;
  801e8c:	89 f8                	mov    %edi,%eax
  801e8e:	eb 05                	jmp    801e95 <devpipe_write+0x79>
				return 0;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e95:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e98:	5b                   	pop    %ebx
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    

00801e9d <devpipe_read>:
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	57                   	push   %edi
  801ea1:	56                   	push   %esi
  801ea2:	53                   	push   %ebx
  801ea3:	83 ec 18             	sub    $0x18,%esp
  801ea6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ea9:	57                   	push   %edi
  801eaa:	e8 4a f2 ff ff       	call   8010f9 <fd2data>
  801eaf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	be 00 00 00 00       	mov    $0x0,%esi
  801eb9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ebc:	74 47                	je     801f05 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801ebe:	8b 03                	mov    (%ebx),%eax
  801ec0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ec3:	75 22                	jne    801ee7 <devpipe_read+0x4a>
			if (i > 0)
  801ec5:	85 f6                	test   %esi,%esi
  801ec7:	75 14                	jne    801edd <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801ec9:	89 da                	mov    %ebx,%edx
  801ecb:	89 f8                	mov    %edi,%eax
  801ecd:	e8 e5 fe ff ff       	call   801db7 <_pipeisclosed>
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	75 33                	jne    801f09 <devpipe_read+0x6c>
			sys_yield();
  801ed6:	e8 41 ed ff ff       	call   800c1c <sys_yield>
  801edb:	eb e1                	jmp    801ebe <devpipe_read+0x21>
				return i;
  801edd:	89 f0                	mov    %esi,%eax
}
  801edf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee2:	5b                   	pop    %ebx
  801ee3:	5e                   	pop    %esi
  801ee4:	5f                   	pop    %edi
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee7:	99                   	cltd   
  801ee8:	c1 ea 1b             	shr    $0x1b,%edx
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	83 e0 1f             	and    $0x1f,%eax
  801ef0:	29 d0                	sub    %edx,%eax
  801ef2:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ef7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801efa:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801efd:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f00:	83 c6 01             	add    $0x1,%esi
  801f03:	eb b4                	jmp    801eb9 <devpipe_read+0x1c>
	return i;
  801f05:	89 f0                	mov    %esi,%eax
  801f07:	eb d6                	jmp    801edf <devpipe_read+0x42>
				return 0;
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0e:	eb cf                	jmp    801edf <devpipe_read+0x42>

00801f10 <pipe>:
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	56                   	push   %esi
  801f14:	53                   	push   %ebx
  801f15:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1b:	50                   	push   %eax
  801f1c:	e8 ef f1 ff ff       	call   801110 <fd_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 5b                	js     801f85 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2a:	83 ec 04             	sub    $0x4,%esp
  801f2d:	68 07 04 00 00       	push   $0x407
  801f32:	ff 75 f4             	pushl  -0xc(%ebp)
  801f35:	6a 00                	push   $0x0
  801f37:	e8 ff ec ff ff       	call   800c3b <sys_page_alloc>
  801f3c:	89 c3                	mov    %eax,%ebx
  801f3e:	83 c4 10             	add    $0x10,%esp
  801f41:	85 c0                	test   %eax,%eax
  801f43:	78 40                	js     801f85 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f4b:	50                   	push   %eax
  801f4c:	e8 bf f1 ff ff       	call   801110 <fd_alloc>
  801f51:	89 c3                	mov    %eax,%ebx
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 1b                	js     801f75 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	68 07 04 00 00       	push   $0x407
  801f62:	ff 75 f0             	pushl  -0x10(%ebp)
  801f65:	6a 00                	push   $0x0
  801f67:	e8 cf ec ff ff       	call   800c3b <sys_page_alloc>
  801f6c:	89 c3                	mov    %eax,%ebx
  801f6e:	83 c4 10             	add    $0x10,%esp
  801f71:	85 c0                	test   %eax,%eax
  801f73:	79 19                	jns    801f8e <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801f75:	83 ec 08             	sub    $0x8,%esp
  801f78:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7b:	6a 00                	push   $0x0
  801f7d:	e8 3e ed ff ff       	call   800cc0 <sys_page_unmap>
  801f82:	83 c4 10             	add    $0x10,%esp
}
  801f85:	89 d8                	mov    %ebx,%eax
  801f87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f8a:	5b                   	pop    %ebx
  801f8b:	5e                   	pop    %esi
  801f8c:	5d                   	pop    %ebp
  801f8d:	c3                   	ret    
	va = fd2data(fd0);
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	e8 60 f1 ff ff       	call   8010f9 <fd2data>
  801f99:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9b:	83 c4 0c             	add    $0xc,%esp
  801f9e:	68 07 04 00 00       	push   $0x407
  801fa3:	50                   	push   %eax
  801fa4:	6a 00                	push   $0x0
  801fa6:	e8 90 ec ff ff       	call   800c3b <sys_page_alloc>
  801fab:	89 c3                	mov    %eax,%ebx
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	0f 88 8c 00 00 00    	js     802044 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbe:	e8 36 f1 ff ff       	call   8010f9 <fd2data>
  801fc3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fca:	50                   	push   %eax
  801fcb:	6a 00                	push   $0x0
  801fcd:	56                   	push   %esi
  801fce:	6a 00                	push   $0x0
  801fd0:	e8 a9 ec ff ff       	call   800c7e <sys_page_map>
  801fd5:	89 c3                	mov    %eax,%ebx
  801fd7:	83 c4 20             	add    $0x20,%esp
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 58                	js     802036 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fe7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ffc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802001:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	ff 75 f4             	pushl  -0xc(%ebp)
  80200e:	e8 d6 f0 ff ff       	call   8010e9 <fd2num>
  802013:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802016:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802018:	83 c4 04             	add    $0x4,%esp
  80201b:	ff 75 f0             	pushl  -0x10(%ebp)
  80201e:	e8 c6 f0 ff ff       	call   8010e9 <fd2num>
  802023:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802026:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802031:	e9 4f ff ff ff       	jmp    801f85 <pipe+0x75>
	sys_page_unmap(0, va);
  802036:	83 ec 08             	sub    $0x8,%esp
  802039:	56                   	push   %esi
  80203a:	6a 00                	push   $0x0
  80203c:	e8 7f ec ff ff       	call   800cc0 <sys_page_unmap>
  802041:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802044:	83 ec 08             	sub    $0x8,%esp
  802047:	ff 75 f0             	pushl  -0x10(%ebp)
  80204a:	6a 00                	push   $0x0
  80204c:	e8 6f ec ff ff       	call   800cc0 <sys_page_unmap>
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	e9 1c ff ff ff       	jmp    801f75 <pipe+0x65>

00802059 <pipeisclosed>:
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80205f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802062:	50                   	push   %eax
  802063:	ff 75 08             	pushl  0x8(%ebp)
  802066:	e8 f4 f0 ff ff       	call   80115f <fd_lookup>
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	85 c0                	test   %eax,%eax
  802070:	78 18                	js     80208a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	ff 75 f4             	pushl  -0xc(%ebp)
  802078:	e8 7c f0 ff ff       	call   8010f9 <fd2data>
	return _pipeisclosed(fd, p);
  80207d:	89 c2                	mov    %eax,%edx
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	e8 30 fd ff ff       	call   801db7 <_pipeisclosed>
  802087:	83 c4 10             	add    $0x10,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80209c:	68 d7 2b 80 00       	push   $0x802bd7
  8020a1:	ff 75 0c             	pushl  0xc(%ebp)
  8020a4:	e8 99 e7 ff ff       	call   800842 <strcpy>
	return 0;
}
  8020a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <devcons_write>:
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	57                   	push   %edi
  8020b4:	56                   	push   %esi
  8020b5:	53                   	push   %ebx
  8020b6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020bc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020c1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020c7:	eb 2f                	jmp    8020f8 <devcons_write+0x48>
		m = n - tot;
  8020c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020cc:	29 f3                	sub    %esi,%ebx
  8020ce:	83 fb 7f             	cmp    $0x7f,%ebx
  8020d1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020d6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	53                   	push   %ebx
  8020dd:	89 f0                	mov    %esi,%eax
  8020df:	03 45 0c             	add    0xc(%ebp),%eax
  8020e2:	50                   	push   %eax
  8020e3:	57                   	push   %edi
  8020e4:	e8 e7 e8 ff ff       	call   8009d0 <memmove>
		sys_cputs(buf, m);
  8020e9:	83 c4 08             	add    $0x8,%esp
  8020ec:	53                   	push   %ebx
  8020ed:	57                   	push   %edi
  8020ee:	e8 8c ea ff ff       	call   800b7f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020f3:	01 de                	add    %ebx,%esi
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020fb:	72 cc                	jb     8020c9 <devcons_write+0x19>
}
  8020fd:	89 f0                	mov    %esi,%eax
  8020ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802102:	5b                   	pop    %ebx
  802103:	5e                   	pop    %esi
  802104:	5f                   	pop    %edi
  802105:	5d                   	pop    %ebp
  802106:	c3                   	ret    

00802107 <devcons_read>:
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 08             	sub    $0x8,%esp
  80210d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802116:	75 07                	jne    80211f <devcons_read+0x18>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    
		sys_yield();
  80211a:	e8 fd ea ff ff       	call   800c1c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80211f:	e8 79 ea ff ff       	call   800b9d <sys_cgetc>
  802124:	85 c0                	test   %eax,%eax
  802126:	74 f2                	je     80211a <devcons_read+0x13>
	if (c < 0)
  802128:	85 c0                	test   %eax,%eax
  80212a:	78 ec                	js     802118 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80212c:	83 f8 04             	cmp    $0x4,%eax
  80212f:	74 0c                	je     80213d <devcons_read+0x36>
	*(char*)vbuf = c;
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	88 02                	mov    %al,(%edx)
	return 1;
  802136:	b8 01 00 00 00       	mov    $0x1,%eax
  80213b:	eb db                	jmp    802118 <devcons_read+0x11>
		return 0;
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
  802142:	eb d4                	jmp    802118 <devcons_read+0x11>

00802144 <cputchar>:
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802150:	6a 01                	push   $0x1
  802152:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802155:	50                   	push   %eax
  802156:	e8 24 ea ff ff       	call   800b7f <sys_cputs>
}
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <getchar>:
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802166:	6a 01                	push   $0x1
  802168:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80216b:	50                   	push   %eax
  80216c:	6a 00                	push   $0x0
  80216e:	e8 5d f2 ff ff       	call   8013d0 <read>
	if (r < 0)
  802173:	83 c4 10             	add    $0x10,%esp
  802176:	85 c0                	test   %eax,%eax
  802178:	78 08                	js     802182 <getchar+0x22>
	if (r < 1)
  80217a:	85 c0                	test   %eax,%eax
  80217c:	7e 06                	jle    802184 <getchar+0x24>
	return c;
  80217e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    
		return -E_EOF;
  802184:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802189:	eb f7                	jmp    802182 <getchar+0x22>

0080218b <iscons>:
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802191:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802194:	50                   	push   %eax
  802195:	ff 75 08             	pushl  0x8(%ebp)
  802198:	e8 c2 ef ff ff       	call   80115f <fd_lookup>
  80219d:	83 c4 10             	add    $0x10,%esp
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	78 11                	js     8021b5 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021ad:	39 10                	cmp    %edx,(%eax)
  8021af:	0f 94 c0             	sete   %al
  8021b2:	0f b6 c0             	movzbl %al,%eax
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <opencons>:
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c0:	50                   	push   %eax
  8021c1:	e8 4a ef ff ff       	call   801110 <fd_alloc>
  8021c6:	83 c4 10             	add    $0x10,%esp
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	78 3a                	js     802207 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	68 07 04 00 00       	push   $0x407
  8021d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d8:	6a 00                	push   $0x0
  8021da:	e8 5c ea ff ff       	call   800c3b <sys_page_alloc>
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	78 21                	js     802207 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021ef:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	50                   	push   %eax
  8021ff:	e8 e5 ee ff ff       	call   8010e9 <fd2num>
  802204:	83 c4 10             	add    $0x10,%esp
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  80220f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802216:	74 0a                	je     802222 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802222:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802227:	8b 40 48             	mov    0x48(%eax),%eax
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	6a 07                	push   $0x7
  80222f:	68 00 f0 bf ee       	push   $0xeebff000
  802234:	50                   	push   %eax
  802235:	e8 01 ea ff ff       	call   800c3b <sys_page_alloc>
  80223a:	83 c4 10             	add    $0x10,%esp
  80223d:	85 c0                	test   %eax,%eax
  80223f:	78 1b                	js     80225c <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802241:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802246:	8b 40 48             	mov    0x48(%eax),%eax
  802249:	83 ec 08             	sub    $0x8,%esp
  80224c:	68 6e 22 80 00       	push   $0x80226e
  802251:	50                   	push   %eax
  802252:	e8 2f eb ff ff       	call   800d86 <sys_env_set_pgfault_upcall>
  802257:	83 c4 10             	add    $0x10,%esp
  80225a:	eb bc                	jmp    802218 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  80225c:	50                   	push   %eax
  80225d:	68 e3 2b 80 00       	push   $0x802be3
  802262:	6a 22                	push   $0x22
  802264:	68 fb 2b 80 00       	push   $0x802bfb
  802269:	e8 da de ff ff       	call   800148 <_panic>

0080226e <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80226e:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80226f:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802274:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802276:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802279:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  80227d:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  802280:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802284:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802288:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  80228a:	83 c4 08             	add    $0x8,%esp
	popal
  80228d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80228e:	83 c4 04             	add    $0x4,%esp
	popfl
  802291:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802292:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802293:	c3                   	ret    

00802294 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	56                   	push   %esi
  802298:	53                   	push   %ebx
  802299:	8b 75 08             	mov    0x8(%ebp),%esi
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8022a2:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8022a4:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8022a9:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	50                   	push   %eax
  8022b0:	e8 36 eb ff ff       	call   800deb <sys_ipc_recv>
	if (from_env_store)
  8022b5:	83 c4 10             	add    $0x10,%esp
  8022b8:	85 f6                	test   %esi,%esi
  8022ba:	74 14                	je     8022d0 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8022bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	78 09                	js     8022ce <ipc_recv+0x3a>
  8022c5:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8022cb:	8b 52 74             	mov    0x74(%edx),%edx
  8022ce:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8022d0:	85 db                	test   %ebx,%ebx
  8022d2:	74 14                	je     8022e8 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8022d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	78 09                	js     8022e6 <ipc_recv+0x52>
  8022dd:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8022e3:	8b 52 78             	mov    0x78(%edx),%edx
  8022e6:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	78 08                	js     8022f4 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8022ec:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8022f1:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8022f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	57                   	push   %edi
  8022ff:	56                   	push   %esi
  802300:	53                   	push   %ebx
  802301:	83 ec 0c             	sub    $0xc,%esp
  802304:	8b 7d 08             	mov    0x8(%ebp),%edi
  802307:	8b 75 0c             	mov    0xc(%ebp),%esi
  80230a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80230d:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80230f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802314:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802317:	ff 75 14             	pushl  0x14(%ebp)
  80231a:	53                   	push   %ebx
  80231b:	56                   	push   %esi
  80231c:	57                   	push   %edi
  80231d:	e8 a6 ea ff ff       	call   800dc8 <sys_ipc_try_send>
		if (ret == 0)
  802322:	83 c4 10             	add    $0x10,%esp
  802325:	85 c0                	test   %eax,%eax
  802327:	74 1e                	je     802347 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802329:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80232c:	75 07                	jne    802335 <ipc_send+0x3a>
			sys_yield();
  80232e:	e8 e9 e8 ff ff       	call   800c1c <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802333:	eb e2                	jmp    802317 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802335:	50                   	push   %eax
  802336:	68 09 2c 80 00       	push   $0x802c09
  80233b:	6a 3d                	push   $0x3d
  80233d:	68 1d 2c 80 00       	push   $0x802c1d
  802342:	e8 01 de ff ff       	call   800148 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802347:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80234a:	5b                   	pop    %ebx
  80234b:	5e                   	pop    %esi
  80234c:	5f                   	pop    %edi
  80234d:	5d                   	pop    %ebp
  80234e:	c3                   	ret    

0080234f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80235a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80235d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802363:	8b 52 50             	mov    0x50(%edx),%edx
  802366:	39 ca                	cmp    %ecx,%edx
  802368:	74 11                	je     80237b <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80236a:	83 c0 01             	add    $0x1,%eax
  80236d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802372:	75 e6                	jne    80235a <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	eb 0b                	jmp    802386 <ipc_find_env+0x37>
			return envs[i].env_id;
  80237b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80237e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802383:	8b 40 48             	mov    0x48(%eax),%eax
}
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    

00802388 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80238e:	89 d0                	mov    %edx,%eax
  802390:	c1 e8 16             	shr    $0x16,%eax
  802393:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80239f:	f6 c1 01             	test   $0x1,%cl
  8023a2:	74 1d                	je     8023c1 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023a4:	c1 ea 0c             	shr    $0xc,%edx
  8023a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023ae:	f6 c2 01             	test   $0x1,%dl
  8023b1:	74 0e                	je     8023c1 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b3:	c1 ea 0c             	shr    $0xc,%edx
  8023b6:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023bd:	ef 
  8023be:	0f b7 c0             	movzwl %ax,%eax
}
  8023c1:	5d                   	pop    %ebp
  8023c2:	c3                   	ret    
  8023c3:	66 90                	xchg   %ax,%ax
  8023c5:	66 90                	xchg   %ax,%ax
  8023c7:	66 90                	xchg   %ax,%ax
  8023c9:	66 90                	xchg   %ax,%ax
  8023cb:	66 90                	xchg   %ax,%ax
  8023cd:	66 90                	xchg   %ax,%ax
  8023cf:	90                   	nop

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	53                   	push   %ebx
  8023d4:	83 ec 1c             	sub    $0x1c,%esp
  8023d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023e7:	85 d2                	test   %edx,%edx
  8023e9:	75 35                	jne    802420 <__udivdi3+0x50>
  8023eb:	39 f3                	cmp    %esi,%ebx
  8023ed:	0f 87 bd 00 00 00    	ja     8024b0 <__udivdi3+0xe0>
  8023f3:	85 db                	test   %ebx,%ebx
  8023f5:	89 d9                	mov    %ebx,%ecx
  8023f7:	75 0b                	jne    802404 <__udivdi3+0x34>
  8023f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023fe:	31 d2                	xor    %edx,%edx
  802400:	f7 f3                	div    %ebx
  802402:	89 c1                	mov    %eax,%ecx
  802404:	31 d2                	xor    %edx,%edx
  802406:	89 f0                	mov    %esi,%eax
  802408:	f7 f1                	div    %ecx
  80240a:	89 c6                	mov    %eax,%esi
  80240c:	89 e8                	mov    %ebp,%eax
  80240e:	89 f7                	mov    %esi,%edi
  802410:	f7 f1                	div    %ecx
  802412:	89 fa                	mov    %edi,%edx
  802414:	83 c4 1c             	add    $0x1c,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5f                   	pop    %edi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    
  80241c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802420:	39 f2                	cmp    %esi,%edx
  802422:	77 7c                	ja     8024a0 <__udivdi3+0xd0>
  802424:	0f bd fa             	bsr    %edx,%edi
  802427:	83 f7 1f             	xor    $0x1f,%edi
  80242a:	0f 84 98 00 00 00    	je     8024c8 <__udivdi3+0xf8>
  802430:	89 f9                	mov    %edi,%ecx
  802432:	b8 20 00 00 00       	mov    $0x20,%eax
  802437:	29 f8                	sub    %edi,%eax
  802439:	d3 e2                	shl    %cl,%edx
  80243b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80243f:	89 c1                	mov    %eax,%ecx
  802441:	89 da                	mov    %ebx,%edx
  802443:	d3 ea                	shr    %cl,%edx
  802445:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802449:	09 d1                	or     %edx,%ecx
  80244b:	89 f2                	mov    %esi,%edx
  80244d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802451:	89 f9                	mov    %edi,%ecx
  802453:	d3 e3                	shl    %cl,%ebx
  802455:	89 c1                	mov    %eax,%ecx
  802457:	d3 ea                	shr    %cl,%edx
  802459:	89 f9                	mov    %edi,%ecx
  80245b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80245f:	d3 e6                	shl    %cl,%esi
  802461:	89 eb                	mov    %ebp,%ebx
  802463:	89 c1                	mov    %eax,%ecx
  802465:	d3 eb                	shr    %cl,%ebx
  802467:	09 de                	or     %ebx,%esi
  802469:	89 f0                	mov    %esi,%eax
  80246b:	f7 74 24 08          	divl   0x8(%esp)
  80246f:	89 d6                	mov    %edx,%esi
  802471:	89 c3                	mov    %eax,%ebx
  802473:	f7 64 24 0c          	mull   0xc(%esp)
  802477:	39 d6                	cmp    %edx,%esi
  802479:	72 0c                	jb     802487 <__udivdi3+0xb7>
  80247b:	89 f9                	mov    %edi,%ecx
  80247d:	d3 e5                	shl    %cl,%ebp
  80247f:	39 c5                	cmp    %eax,%ebp
  802481:	73 5d                	jae    8024e0 <__udivdi3+0x110>
  802483:	39 d6                	cmp    %edx,%esi
  802485:	75 59                	jne    8024e0 <__udivdi3+0x110>
  802487:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80248a:	31 ff                	xor    %edi,%edi
  80248c:	89 fa                	mov    %edi,%edx
  80248e:	83 c4 1c             	add    $0x1c,%esp
  802491:	5b                   	pop    %ebx
  802492:	5e                   	pop    %esi
  802493:	5f                   	pop    %edi
  802494:	5d                   	pop    %ebp
  802495:	c3                   	ret    
  802496:	8d 76 00             	lea    0x0(%esi),%esi
  802499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8024a0:	31 ff                	xor    %edi,%edi
  8024a2:	31 c0                	xor    %eax,%eax
  8024a4:	89 fa                	mov    %edi,%edx
  8024a6:	83 c4 1c             	add    $0x1c,%esp
  8024a9:	5b                   	pop    %ebx
  8024aa:	5e                   	pop    %esi
  8024ab:	5f                   	pop    %edi
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	31 ff                	xor    %edi,%edi
  8024b2:	89 e8                	mov    %ebp,%eax
  8024b4:	89 f2                	mov    %esi,%edx
  8024b6:	f7 f3                	div    %ebx
  8024b8:	89 fa                	mov    %edi,%edx
  8024ba:	83 c4 1c             	add    $0x1c,%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5e                   	pop    %esi
  8024bf:	5f                   	pop    %edi
  8024c0:	5d                   	pop    %ebp
  8024c1:	c3                   	ret    
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	39 f2                	cmp    %esi,%edx
  8024ca:	72 06                	jb     8024d2 <__udivdi3+0x102>
  8024cc:	31 c0                	xor    %eax,%eax
  8024ce:	39 eb                	cmp    %ebp,%ebx
  8024d0:	77 d2                	ja     8024a4 <__udivdi3+0xd4>
  8024d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d7:	eb cb                	jmp    8024a4 <__udivdi3+0xd4>
  8024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e0:	89 d8                	mov    %ebx,%eax
  8024e2:	31 ff                	xor    %edi,%edi
  8024e4:	eb be                	jmp    8024a4 <__udivdi3+0xd4>
  8024e6:	66 90                	xchg   %ax,%ax
  8024e8:	66 90                	xchg   %ax,%ax
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <__umoddi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	53                   	push   %ebx
  8024f4:	83 ec 1c             	sub    $0x1c,%esp
  8024f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8024fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802507:	85 ed                	test   %ebp,%ebp
  802509:	89 f0                	mov    %esi,%eax
  80250b:	89 da                	mov    %ebx,%edx
  80250d:	75 19                	jne    802528 <__umoddi3+0x38>
  80250f:	39 df                	cmp    %ebx,%edi
  802511:	0f 86 b1 00 00 00    	jbe    8025c8 <__umoddi3+0xd8>
  802517:	f7 f7                	div    %edi
  802519:	89 d0                	mov    %edx,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	83 c4 1c             	add    $0x1c,%esp
  802520:	5b                   	pop    %ebx
  802521:	5e                   	pop    %esi
  802522:	5f                   	pop    %edi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
  802525:	8d 76 00             	lea    0x0(%esi),%esi
  802528:	39 dd                	cmp    %ebx,%ebp
  80252a:	77 f1                	ja     80251d <__umoddi3+0x2d>
  80252c:	0f bd cd             	bsr    %ebp,%ecx
  80252f:	83 f1 1f             	xor    $0x1f,%ecx
  802532:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802536:	0f 84 b4 00 00 00    	je     8025f0 <__umoddi3+0x100>
  80253c:	b8 20 00 00 00       	mov    $0x20,%eax
  802541:	89 c2                	mov    %eax,%edx
  802543:	8b 44 24 04          	mov    0x4(%esp),%eax
  802547:	29 c2                	sub    %eax,%edx
  802549:	89 c1                	mov    %eax,%ecx
  80254b:	89 f8                	mov    %edi,%eax
  80254d:	d3 e5                	shl    %cl,%ebp
  80254f:	89 d1                	mov    %edx,%ecx
  802551:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802555:	d3 e8                	shr    %cl,%eax
  802557:	09 c5                	or     %eax,%ebp
  802559:	8b 44 24 04          	mov    0x4(%esp),%eax
  80255d:	89 c1                	mov    %eax,%ecx
  80255f:	d3 e7                	shl    %cl,%edi
  802561:	89 d1                	mov    %edx,%ecx
  802563:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802567:	89 df                	mov    %ebx,%edi
  802569:	d3 ef                	shr    %cl,%edi
  80256b:	89 c1                	mov    %eax,%ecx
  80256d:	89 f0                	mov    %esi,%eax
  80256f:	d3 e3                	shl    %cl,%ebx
  802571:	89 d1                	mov    %edx,%ecx
  802573:	89 fa                	mov    %edi,%edx
  802575:	d3 e8                	shr    %cl,%eax
  802577:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	f7 f5                	div    %ebp
  802580:	d3 e6                	shl    %cl,%esi
  802582:	89 d1                	mov    %edx,%ecx
  802584:	f7 64 24 08          	mull   0x8(%esp)
  802588:	39 d1                	cmp    %edx,%ecx
  80258a:	89 c3                	mov    %eax,%ebx
  80258c:	89 d7                	mov    %edx,%edi
  80258e:	72 06                	jb     802596 <__umoddi3+0xa6>
  802590:	75 0e                	jne    8025a0 <__umoddi3+0xb0>
  802592:	39 c6                	cmp    %eax,%esi
  802594:	73 0a                	jae    8025a0 <__umoddi3+0xb0>
  802596:	2b 44 24 08          	sub    0x8(%esp),%eax
  80259a:	19 ea                	sbb    %ebp,%edx
  80259c:	89 d7                	mov    %edx,%edi
  80259e:	89 c3                	mov    %eax,%ebx
  8025a0:	89 ca                	mov    %ecx,%edx
  8025a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8025a7:	29 de                	sub    %ebx,%esi
  8025a9:	19 fa                	sbb    %edi,%edx
  8025ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8025af:	89 d0                	mov    %edx,%eax
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 d9                	mov    %ebx,%ecx
  8025b5:	d3 ee                	shr    %cl,%esi
  8025b7:	d3 ea                	shr    %cl,%edx
  8025b9:	09 f0                	or     %esi,%eax
  8025bb:	83 c4 1c             	add    $0x1c,%esp
  8025be:	5b                   	pop    %ebx
  8025bf:	5e                   	pop    %esi
  8025c0:	5f                   	pop    %edi
  8025c1:	5d                   	pop    %ebp
  8025c2:	c3                   	ret    
  8025c3:	90                   	nop
  8025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025c8:	85 ff                	test   %edi,%edi
  8025ca:	89 f9                	mov    %edi,%ecx
  8025cc:	75 0b                	jne    8025d9 <__umoddi3+0xe9>
  8025ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d3:	31 d2                	xor    %edx,%edx
  8025d5:	f7 f7                	div    %edi
  8025d7:	89 c1                	mov    %eax,%ecx
  8025d9:	89 d8                	mov    %ebx,%eax
  8025db:	31 d2                	xor    %edx,%edx
  8025dd:	f7 f1                	div    %ecx
  8025df:	89 f0                	mov    %esi,%eax
  8025e1:	f7 f1                	div    %ecx
  8025e3:	e9 31 ff ff ff       	jmp    802519 <__umoddi3+0x29>
  8025e8:	90                   	nop
  8025e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025f0:	39 dd                	cmp    %ebx,%ebp
  8025f2:	72 08                	jb     8025fc <__umoddi3+0x10c>
  8025f4:	39 f7                	cmp    %esi,%edi
  8025f6:	0f 87 21 ff ff ff    	ja     80251d <__umoddi3+0x2d>
  8025fc:	89 da                	mov    %ebx,%edx
  8025fe:	89 f0                	mov    %esi,%eax
  802600:	29 f8                	sub    %edi,%eax
  802602:	19 ea                	sbb    %ebp,%edx
  802604:	e9 14 ff ff ff       	jmp    80251d <__umoddi3+0x2d>

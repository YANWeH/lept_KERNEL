
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 a1 01 00 00       	call   8001d2 <libmain>
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
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 00 27 80 00       	push   $0x802700
  800041:	e8 c7 02 00 00       	call   80030d <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 a9 1f 00 00       	call   801ffa <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 5d                	js     8000b5 <umain+0x82>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 b1 0f 00 00       	call   80100e <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 64                	js     8000c7 <umain+0x94>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	85 c0                	test   %eax,%eax
  800065:	74 72                	je     8000d9 <umain+0xa6>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800067:	89 fb                	mov    %edi,%ebx
  800069:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80006f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800072:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  800078:	8b 43 54             	mov    0x54(%ebx),%eax
  80007b:	83 f8 02             	cmp    $0x2,%eax
  80007e:	0f 85 d1 00 00 00    	jne    800155 <umain+0x122>
		if (pipeisclosed(p[0]) != 0) {
  800084:	83 ec 0c             	sub    $0xc,%esp
  800087:	ff 75 e0             	pushl  -0x20(%ebp)
  80008a:	e8 b4 20 00 00       	call   802143 <pipeisclosed>
  80008f:	83 c4 10             	add    $0x10,%esp
  800092:	85 c0                	test   %eax,%eax
  800094:	74 e2                	je     800078 <umain+0x45>
			cprintf("\nRACE: pipe appears closed\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 79 27 80 00       	push   $0x802779
  80009e:	e8 6a 02 00 00       	call   80030d <cprintf>
			sys_env_destroy(r);
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 fb 0b 00 00       	call   800ca6 <sys_env_destroy>
			exit();
  8000ab:	e8 68 01 00 00       	call   800218 <exit>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	eb c3                	jmp    800078 <umain+0x45>
		panic("pipe: %e", r);
  8000b5:	50                   	push   %eax
  8000b6:	68 4e 27 80 00       	push   $0x80274e
  8000bb:	6a 0d                	push   $0xd
  8000bd:	68 57 27 80 00       	push   $0x802757
  8000c2:	e8 6b 01 00 00       	call   800232 <_panic>
		panic("fork: %e", r);
  8000c7:	50                   	push   %eax
  8000c8:	68 6c 27 80 00       	push   $0x80276c
  8000cd:	6a 0f                	push   $0xf
  8000cf:	68 57 27 80 00       	push   $0x802757
  8000d4:	e8 59 01 00 00       	call   800232 <_panic>
		close(p[1]);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000df:	e8 9a 12 00 00       	call   80137e <close>
  8000e4:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000e7:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000e9:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000ee:	eb 31                	jmp    800121 <umain+0xee>
			dup(p[0], 10);
  8000f0:	83 ec 08             	sub    $0x8,%esp
  8000f3:	6a 0a                	push   $0xa
  8000f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f8:	e8 d1 12 00 00       	call   8013ce <dup>
			sys_yield();
  8000fd:	e8 04 0c 00 00       	call   800d06 <sys_yield>
			close(10);
  800102:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800109:	e8 70 12 00 00       	call   80137e <close>
			sys_yield();
  80010e:	e8 f3 0b 00 00       	call   800d06 <sys_yield>
		for (i = 0; i < 200; i++) {
  800113:	83 c3 01             	add    $0x1,%ebx
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  80011f:	74 2a                	je     80014b <umain+0x118>
			if (i % 10 == 0)
  800121:	89 d8                	mov    %ebx,%eax
  800123:	f7 ee                	imul   %esi
  800125:	c1 fa 02             	sar    $0x2,%edx
  800128:	89 d8                	mov    %ebx,%eax
  80012a:	c1 f8 1f             	sar    $0x1f,%eax
  80012d:	29 c2                	sub    %eax,%edx
  80012f:	8d 04 92             	lea    (%edx,%edx,4),%eax
  800132:	01 c0                	add    %eax,%eax
  800134:	39 c3                	cmp    %eax,%ebx
  800136:	75 b8                	jne    8000f0 <umain+0xbd>
				cprintf("%d.", i);
  800138:	83 ec 08             	sub    $0x8,%esp
  80013b:	53                   	push   %ebx
  80013c:	68 75 27 80 00       	push   $0x802775
  800141:	e8 c7 01 00 00       	call   80030d <cprintf>
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	eb a5                	jmp    8000f0 <umain+0xbd>
		exit();
  80014b:	e8 c8 00 00 00       	call   800218 <exit>
  800150:	e9 12 ff ff ff       	jmp    800067 <umain+0x34>
		}
	cprintf("child done with loop\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 95 27 80 00       	push   $0x802795
  80015d:	e8 ab 01 00 00       	call   80030d <cprintf>
	if (pipeisclosed(p[0]))
  800162:	83 c4 04             	add    $0x4,%esp
  800165:	ff 75 e0             	pushl  -0x20(%ebp)
  800168:	e8 d6 1f 00 00       	call   802143 <pipeisclosed>
  80016d:	83 c4 10             	add    $0x10,%esp
  800170:	85 c0                	test   %eax,%eax
  800172:	75 38                	jne    8001ac <umain+0x179>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800174:	83 ec 08             	sub    $0x8,%esp
  800177:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80017a:	50                   	push   %eax
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 c6 10 00 00       	call   801249 <fd_lookup>
  800183:	83 c4 10             	add    $0x10,%esp
  800186:	85 c0                	test   %eax,%eax
  800188:	78 36                	js     8001c0 <umain+0x18d>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	ff 75 dc             	pushl  -0x24(%ebp)
  800190:	e8 4e 10 00 00       	call   8011e3 <fd2data>
	cprintf("race didn't happen\n");
  800195:	c7 04 24 c3 27 80 00 	movl   $0x8027c3,(%esp)
  80019c:	e8 6c 01 00 00       	call   80030d <cprintf>
}
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a7:	5b                   	pop    %ebx
  8001a8:	5e                   	pop    %esi
  8001a9:	5f                   	pop    %edi
  8001aa:	5d                   	pop    %ebp
  8001ab:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001ac:	83 ec 04             	sub    $0x4,%esp
  8001af:	68 24 27 80 00       	push   $0x802724
  8001b4:	6a 40                	push   $0x40
  8001b6:	68 57 27 80 00       	push   $0x802757
  8001bb:	e8 72 00 00 00       	call   800232 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c0:	50                   	push   %eax
  8001c1:	68 ab 27 80 00       	push   $0x8027ab
  8001c6:	6a 42                	push   $0x42
  8001c8:	68 57 27 80 00       	push   $0x802757
  8001cd:	e8 60 00 00 00       	call   800232 <_panic>

008001d2 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	56                   	push   %esi
  8001d6:	53                   	push   %ebx
  8001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001da:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001dd:	e8 05 0b 00 00       	call   800ce7 <sys_getenvid>
  8001e2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ef:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x2d>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80021e:	e8 86 11 00 00       	call   8013a9 <close_all>
	sys_env_destroy(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 79 0a 00 00       	call   800ca6 <sys_env_destroy>
}
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	56                   	push   %esi
  800236:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800237:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800240:	e8 a2 0a 00 00       	call   800ce7 <sys_getenvid>
  800245:	83 ec 0c             	sub    $0xc,%esp
  800248:	ff 75 0c             	pushl  0xc(%ebp)
  80024b:	ff 75 08             	pushl  0x8(%ebp)
  80024e:	56                   	push   %esi
  80024f:	50                   	push   %eax
  800250:	68 e4 27 80 00       	push   $0x8027e4
  800255:	e8 b3 00 00 00       	call   80030d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	83 c4 18             	add    $0x18,%esp
  80025d:	53                   	push   %ebx
  80025e:	ff 75 10             	pushl  0x10(%ebp)
  800261:	e8 56 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  800266:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  80026d:	e8 9b 00 00 00       	call   80030d <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x43>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	53                   	push   %ebx
  80027c:	83 ec 04             	sub    $0x4,%esp
  80027f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800282:	8b 13                	mov    (%ebx),%edx
  800284:	8d 42 01             	lea    0x1(%edx),%eax
  800287:	89 03                	mov    %eax,(%ebx)
  800289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800290:	3d ff 00 00 00       	cmp    $0xff,%eax
  800295:	74 09                	je     8002a0 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800297:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	68 ff 00 00 00       	push   $0xff
  8002a8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002ab:	50                   	push   %eax
  8002ac:	e8 b8 09 00 00       	call   800c69 <sys_cputs>
		b->idx = 0;
  8002b1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	eb db                	jmp    800297 <putch+0x1f>

008002bc <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	ff 75 0c             	pushl  0xc(%ebp)
  8002dc:	ff 75 08             	pushl  0x8(%ebp)
  8002df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	68 78 02 80 00       	push   $0x800278
  8002eb:	e8 1a 01 00 00       	call   80040a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f0:	83 c4 08             	add    $0x8,%esp
  8002f3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ff:	50                   	push   %eax
  800300:	e8 64 09 00 00       	call   800c69 <sys_cputs>

	return b.cnt;
}
  800305:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800316:	50                   	push   %eax
  800317:	ff 75 08             	pushl  0x8(%ebp)
  80031a:	e8 9d ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	57                   	push   %edi
  800325:	56                   	push   %esi
  800326:	53                   	push   %ebx
  800327:	83 ec 1c             	sub    $0x1c,%esp
  80032a:	89 c7                	mov    %eax,%edi
  80032c:	89 d6                	mov    %edx,%esi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	8b 55 0c             	mov    0xc(%ebp),%edx
  800334:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800337:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80033a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80033d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800342:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800345:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800348:	39 d3                	cmp    %edx,%ebx
  80034a:	72 05                	jb     800351 <printnum+0x30>
  80034c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80034f:	77 7a                	ja     8003cb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	ff 75 18             	pushl  0x18(%ebp)
  800357:	8b 45 14             	mov    0x14(%ebp),%eax
  80035a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035d:	53                   	push   %ebx
  80035e:	ff 75 10             	pushl  0x10(%ebp)
  800361:	83 ec 08             	sub    $0x8,%esp
  800364:	ff 75 e4             	pushl  -0x1c(%ebp)
  800367:	ff 75 e0             	pushl  -0x20(%ebp)
  80036a:	ff 75 dc             	pushl  -0x24(%ebp)
  80036d:	ff 75 d8             	pushl  -0x28(%ebp)
  800370:	e8 3b 21 00 00       	call   8024b0 <__udivdi3>
  800375:	83 c4 18             	add    $0x18,%esp
  800378:	52                   	push   %edx
  800379:	50                   	push   %eax
  80037a:	89 f2                	mov    %esi,%edx
  80037c:	89 f8                	mov    %edi,%eax
  80037e:	e8 9e ff ff ff       	call   800321 <printnum>
  800383:	83 c4 20             	add    $0x20,%esp
  800386:	eb 13                	jmp    80039b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	56                   	push   %esi
  80038c:	ff 75 18             	pushl  0x18(%ebp)
  80038f:	ff d7                	call   *%edi
  800391:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800394:	83 eb 01             	sub    $0x1,%ebx
  800397:	85 db                	test   %ebx,%ebx
  800399:	7f ed                	jg     800388 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	56                   	push   %esi
  80039f:	83 ec 04             	sub    $0x4,%esp
  8003a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ae:	e8 1d 22 00 00       	call   8025d0 <__umoddi3>
  8003b3:	83 c4 14             	add    $0x14,%esp
  8003b6:	0f be 80 07 28 80 00 	movsbl 0x802807(%eax),%eax
  8003bd:	50                   	push   %eax
  8003be:	ff d7                	call   *%edi
}
  8003c0:	83 c4 10             	add    $0x10,%esp
  8003c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5e                   	pop    %esi
  8003c8:	5f                   	pop    %edi
  8003c9:	5d                   	pop    %ebp
  8003ca:	c3                   	ret    
  8003cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ce:	eb c4                	jmp    800394 <printnum+0x73>

008003d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003da:	8b 10                	mov    (%eax),%edx
  8003dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003df:	73 0a                	jae    8003eb <sprintputch+0x1b>
		*b->buf++ = ch;
  8003e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003e4:	89 08                	mov    %ecx,(%eax)
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	88 02                	mov    %al,(%edx)
}
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <printfmt>:
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003f3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f6:	50                   	push   %eax
  8003f7:	ff 75 10             	pushl  0x10(%ebp)
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	ff 75 08             	pushl  0x8(%ebp)
  800400:	e8 05 00 00 00       	call   80040a <vprintfmt>
}
  800405:	83 c4 10             	add    $0x10,%esp
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <vprintfmt>:
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	57                   	push   %edi
  80040e:	56                   	push   %esi
  80040f:	53                   	push   %ebx
  800410:	83 ec 2c             	sub    $0x2c,%esp
  800413:	8b 75 08             	mov    0x8(%ebp),%esi
  800416:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800419:	8b 7d 10             	mov    0x10(%ebp),%edi
  80041c:	e9 c1 03 00 00       	jmp    8007e2 <vprintfmt+0x3d8>
		padc = ' ';
  800421:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800425:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80042c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800433:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80043a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80043f:	8d 47 01             	lea    0x1(%edi),%eax
  800442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800445:	0f b6 17             	movzbl (%edi),%edx
  800448:	8d 42 dd             	lea    -0x23(%edx),%eax
  80044b:	3c 55                	cmp    $0x55,%al
  80044d:	0f 87 12 04 00 00    	ja     800865 <vprintfmt+0x45b>
  800453:	0f b6 c0             	movzbl %al,%eax
  800456:	ff 24 85 40 29 80 00 	jmp    *0x802940(,%eax,4)
  80045d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800460:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800464:	eb d9                	jmp    80043f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800469:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80046d:	eb d0                	jmp    80043f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	0f b6 d2             	movzbl %dl,%edx
  800472:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800475:	b8 00 00 00 00       	mov    $0x0,%eax
  80047a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80047d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800480:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800484:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800487:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80048a:	83 f9 09             	cmp    $0x9,%ecx
  80048d:	77 55                	ja     8004e4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80048f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800492:	eb e9                	jmp    80047d <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80049c:	8b 45 14             	mov    0x14(%ebp),%eax
  80049f:	8d 40 04             	lea    0x4(%eax),%eax
  8004a2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ac:	79 91                	jns    80043f <vprintfmt+0x35>
				width = precision, precision = -1;
  8004ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004bb:	eb 82                	jmp    80043f <vprintfmt+0x35>
  8004bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c0:	85 c0                	test   %eax,%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	0f 49 d0             	cmovns %eax,%edx
  8004ca:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004cd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004d0:	e9 6a ff ff ff       	jmp    80043f <vprintfmt+0x35>
  8004d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004df:	e9 5b ff ff ff       	jmp    80043f <vprintfmt+0x35>
  8004e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ea:	eb bc                	jmp    8004a8 <vprintfmt+0x9e>
			lflag++;
  8004ec:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ef:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004f2:	e9 48 ff ff ff       	jmp    80043f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 78 04             	lea    0x4(%eax),%edi
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	53                   	push   %ebx
  800501:	ff 30                	pushl  (%eax)
  800503:	ff d6                	call   *%esi
			break;
  800505:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800508:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80050b:	e9 cf 02 00 00       	jmp    8007df <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8d 78 04             	lea    0x4(%eax),%edi
  800516:	8b 00                	mov    (%eax),%eax
  800518:	99                   	cltd   
  800519:	31 d0                	xor    %edx,%eax
  80051b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051d:	83 f8 0f             	cmp    $0xf,%eax
  800520:	7f 23                	jg     800545 <vprintfmt+0x13b>
  800522:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  800529:	85 d2                	test   %edx,%edx
  80052b:	74 18                	je     800545 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80052d:	52                   	push   %edx
  80052e:	68 c5 2c 80 00       	push   $0x802cc5
  800533:	53                   	push   %ebx
  800534:	56                   	push   %esi
  800535:	e8 b3 fe ff ff       	call   8003ed <printfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80053d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800540:	e9 9a 02 00 00       	jmp    8007df <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800545:	50                   	push   %eax
  800546:	68 1f 28 80 00       	push   $0x80281f
  80054b:	53                   	push   %ebx
  80054c:	56                   	push   %esi
  80054d:	e8 9b fe ff ff       	call   8003ed <printfmt>
  800552:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800555:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800558:	e9 82 02 00 00       	jmp    8007df <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	83 c0 04             	add    $0x4,%eax
  800563:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800566:	8b 45 14             	mov    0x14(%ebp),%eax
  800569:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80056b:	85 ff                	test   %edi,%edi
  80056d:	b8 18 28 80 00       	mov    $0x802818,%eax
  800572:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800575:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800579:	0f 8e bd 00 00 00    	jle    80063c <vprintfmt+0x232>
  80057f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800583:	75 0e                	jne    800593 <vprintfmt+0x189>
  800585:	89 75 08             	mov    %esi,0x8(%ebp)
  800588:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80058b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80058e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800591:	eb 6d                	jmp    800600 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 d0             	pushl  -0x30(%ebp)
  800599:	57                   	push   %edi
  80059a:	e8 6e 03 00 00       	call   80090d <strnlen>
  80059f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a2:	29 c1                	sub    %eax,%ecx
  8005a4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005aa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005b1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005b4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b6:	eb 0f                	jmp    8005c7 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8005bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	83 ef 01             	sub    $0x1,%edi
  8005c4:	83 c4 10             	add    $0x10,%esp
  8005c7:	85 ff                	test   %edi,%edi
  8005c9:	7f ed                	jg     8005b8 <vprintfmt+0x1ae>
  8005cb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005ce:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005d1:	85 c9                	test   %ecx,%ecx
  8005d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d8:	0f 49 c1             	cmovns %ecx,%eax
  8005db:	29 c1                	sub    %eax,%ecx
  8005dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005e3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e6:	89 cb                	mov    %ecx,%ebx
  8005e8:	eb 16                	jmp    800600 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005ee:	75 31                	jne    800621 <vprintfmt+0x217>
					putch(ch, putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	ff 55 08             	call   *0x8(%ebp)
  8005fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fd:	83 eb 01             	sub    $0x1,%ebx
  800600:	83 c7 01             	add    $0x1,%edi
  800603:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800607:	0f be c2             	movsbl %dl,%eax
  80060a:	85 c0                	test   %eax,%eax
  80060c:	74 59                	je     800667 <vprintfmt+0x25d>
  80060e:	85 f6                	test   %esi,%esi
  800610:	78 d8                	js     8005ea <vprintfmt+0x1e0>
  800612:	83 ee 01             	sub    $0x1,%esi
  800615:	79 d3                	jns    8005ea <vprintfmt+0x1e0>
  800617:	89 df                	mov    %ebx,%edi
  800619:	8b 75 08             	mov    0x8(%ebp),%esi
  80061c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80061f:	eb 37                	jmp    800658 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800621:	0f be d2             	movsbl %dl,%edx
  800624:	83 ea 20             	sub    $0x20,%edx
  800627:	83 fa 5e             	cmp    $0x5e,%edx
  80062a:	76 c4                	jbe    8005f0 <vprintfmt+0x1e6>
					putch('?', putdat);
  80062c:	83 ec 08             	sub    $0x8,%esp
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	6a 3f                	push   $0x3f
  800634:	ff 55 08             	call   *0x8(%ebp)
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	eb c1                	jmp    8005fd <vprintfmt+0x1f3>
  80063c:	89 75 08             	mov    %esi,0x8(%ebp)
  80063f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800642:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800645:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800648:	eb b6                	jmp    800600 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 20                	push   $0x20
  800650:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800652:	83 ef 01             	sub    $0x1,%edi
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	85 ff                	test   %edi,%edi
  80065a:	7f ee                	jg     80064a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80065c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
  800662:	e9 78 01 00 00       	jmp    8007df <vprintfmt+0x3d5>
  800667:	89 df                	mov    %ebx,%edi
  800669:	8b 75 08             	mov    0x8(%ebp),%esi
  80066c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80066f:	eb e7                	jmp    800658 <vprintfmt+0x24e>
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7e 3f                	jle    8006b5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800676:	8b 45 14             	mov    0x14(%ebp),%eax
  800679:	8b 50 04             	mov    0x4(%eax),%edx
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800681:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 40 08             	lea    0x8(%eax),%eax
  80068a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  80068d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800691:	79 5c                	jns    8006ef <vprintfmt+0x2e5>
				putch('-', putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	53                   	push   %ebx
  800697:	6a 2d                	push   $0x2d
  800699:	ff d6                	call   *%esi
				num = -(long long) num;
  80069b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80069e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006a1:	f7 da                	neg    %edx
  8006a3:	83 d1 00             	adc    $0x0,%ecx
  8006a6:	f7 d9                	neg    %ecx
  8006a8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ab:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b0:	e9 10 01 00 00       	jmp    8007c5 <vprintfmt+0x3bb>
	else if (lflag)
  8006b5:	85 c9                	test   %ecx,%ecx
  8006b7:	75 1b                	jne    8006d4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bc:	8b 00                	mov    (%eax),%eax
  8006be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c1:	89 c1                	mov    %eax,%ecx
  8006c3:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 40 04             	lea    0x4(%eax),%eax
  8006cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8006d2:	eb b9                	jmp    80068d <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dc:	89 c1                	mov    %eax,%ecx
  8006de:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 04             	lea    0x4(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ed:	eb 9e                	jmp    80068d <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006f2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006fa:	e9 c6 00 00 00       	jmp    8007c5 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7e 18                	jle    80071c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 10                	mov    (%eax),%edx
  800709:	8b 48 04             	mov    0x4(%eax),%ecx
  80070c:	8d 40 08             	lea    0x8(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
  800717:	e9 a9 00 00 00       	jmp    8007c5 <vprintfmt+0x3bb>
	else if (lflag)
  80071c:	85 c9                	test   %ecx,%ecx
  80071e:	75 1a                	jne    80073a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 10                	mov    (%eax),%edx
  800725:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072a:	8d 40 04             	lea    0x4(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	e9 8b 00 00 00       	jmp    8007c5 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8b 10                	mov    (%eax),%edx
  80073f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800744:	8d 40 04             	lea    0x4(%eax),%eax
  800747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80074f:	eb 74                	jmp    8007c5 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800751:	83 f9 01             	cmp    $0x1,%ecx
  800754:	7e 15                	jle    80076b <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800756:	8b 45 14             	mov    0x14(%ebp),%eax
  800759:	8b 10                	mov    (%eax),%edx
  80075b:	8b 48 04             	mov    0x4(%eax),%ecx
  80075e:	8d 40 08             	lea    0x8(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800764:	b8 08 00 00 00       	mov    $0x8,%eax
  800769:	eb 5a                	jmp    8007c5 <vprintfmt+0x3bb>
	else if (lflag)
  80076b:	85 c9                	test   %ecx,%ecx
  80076d:	75 17                	jne    800786 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8b 10                	mov    (%eax),%edx
  800774:	b9 00 00 00 00       	mov    $0x0,%ecx
  800779:	8d 40 04             	lea    0x4(%eax),%eax
  80077c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80077f:	b8 08 00 00 00       	mov    $0x8,%eax
  800784:	eb 3f                	jmp    8007c5 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800786:	8b 45 14             	mov    0x14(%ebp),%eax
  800789:	8b 10                	mov    (%eax),%edx
  80078b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800790:	8d 40 04             	lea    0x4(%eax),%eax
  800793:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800796:	b8 08 00 00 00       	mov    $0x8,%eax
  80079b:	eb 28                	jmp    8007c5 <vprintfmt+0x3bb>
			putch('0', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	53                   	push   %ebx
  8007a1:	6a 30                	push   $0x30
  8007a3:	ff d6                	call   *%esi
			putch('x', putdat);
  8007a5:	83 c4 08             	add    $0x8,%esp
  8007a8:	53                   	push   %ebx
  8007a9:	6a 78                	push   $0x78
  8007ab:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b0:	8b 10                	mov    (%eax),%edx
  8007b2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007b7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007ba:	8d 40 04             	lea    0x4(%eax),%eax
  8007bd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007c5:	83 ec 0c             	sub    $0xc,%esp
  8007c8:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007cc:	57                   	push   %edi
  8007cd:	ff 75 e0             	pushl  -0x20(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	51                   	push   %ecx
  8007d2:	52                   	push   %edx
  8007d3:	89 da                	mov    %ebx,%edx
  8007d5:	89 f0                	mov    %esi,%eax
  8007d7:	e8 45 fb ff ff       	call   800321 <printnum>
			break;
  8007dc:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e2:	83 c7 01             	add    $0x1,%edi
  8007e5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e9:	83 f8 25             	cmp    $0x25,%eax
  8007ec:	0f 84 2f fc ff ff    	je     800421 <vprintfmt+0x17>
			if (ch == '\0')
  8007f2:	85 c0                	test   %eax,%eax
  8007f4:	0f 84 8b 00 00 00    	je     800885 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	53                   	push   %ebx
  8007fe:	50                   	push   %eax
  8007ff:	ff d6                	call   *%esi
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	eb dc                	jmp    8007e2 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800806:	83 f9 01             	cmp    $0x1,%ecx
  800809:	7e 15                	jle    800820 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8b 10                	mov    (%eax),%edx
  800810:	8b 48 04             	mov    0x4(%eax),%ecx
  800813:	8d 40 08             	lea    0x8(%eax),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800819:	b8 10 00 00 00       	mov    $0x10,%eax
  80081e:	eb a5                	jmp    8007c5 <vprintfmt+0x3bb>
	else if (lflag)
  800820:	85 c9                	test   %ecx,%ecx
  800822:	75 17                	jne    80083b <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	8b 10                	mov    (%eax),%edx
  800829:	b9 00 00 00 00       	mov    $0x0,%ecx
  80082e:	8d 40 04             	lea    0x4(%eax),%eax
  800831:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800834:	b8 10 00 00 00       	mov    $0x10,%eax
  800839:	eb 8a                	jmp    8007c5 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	8b 10                	mov    (%eax),%edx
  800840:	b9 00 00 00 00       	mov    $0x0,%ecx
  800845:	8d 40 04             	lea    0x4(%eax),%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084b:	b8 10 00 00 00       	mov    $0x10,%eax
  800850:	e9 70 ff ff ff       	jmp    8007c5 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	53                   	push   %ebx
  800859:	6a 25                	push   $0x25
  80085b:	ff d6                	call   *%esi
			break;
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	e9 7a ff ff ff       	jmp    8007df <vprintfmt+0x3d5>
			putch('%', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	53                   	push   %ebx
  800869:	6a 25                	push   $0x25
  80086b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 f8                	mov    %edi,%eax
  800872:	eb 03                	jmp    800877 <vprintfmt+0x46d>
  800874:	83 e8 01             	sub    $0x1,%eax
  800877:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80087b:	75 f7                	jne    800874 <vprintfmt+0x46a>
  80087d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800880:	e9 5a ff ff ff       	jmp    8007df <vprintfmt+0x3d5>
}
  800885:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5f                   	pop    %edi
  80088b:	5d                   	pop    %ebp
  80088c:	c3                   	ret    

0080088d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088d:	55                   	push   %ebp
  80088e:	89 e5                	mov    %esp,%ebp
  800890:	83 ec 18             	sub    $0x18,%esp
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a0:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008aa:	85 c0                	test   %eax,%eax
  8008ac:	74 26                	je     8008d4 <vsnprintf+0x47>
  8008ae:	85 d2                	test   %edx,%edx
  8008b0:	7e 22                	jle    8008d4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b2:	ff 75 14             	pushl  0x14(%ebp)
  8008b5:	ff 75 10             	pushl  0x10(%ebp)
  8008b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008bb:	50                   	push   %eax
  8008bc:	68 d0 03 80 00       	push   $0x8003d0
  8008c1:	e8 44 fb ff ff       	call   80040a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
}
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    
		return -E_INVAL;
  8008d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d9:	eb f7                	jmp    8008d2 <vsnprintf+0x45>

008008db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e4:	50                   	push   %eax
  8008e5:	ff 75 10             	pushl  0x10(%ebp)
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 9a ff ff ff       	call   80088d <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    

008008f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800900:	eb 03                	jmp    800905 <strlen+0x10>
		n++;
  800902:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800905:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800909:	75 f7                	jne    800902 <strlen+0xd>
	return n;
}
  80090b:	5d                   	pop    %ebp
  80090c:	c3                   	ret    

0080090d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800913:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	eb 03                	jmp    800920 <strnlen+0x13>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800920:	39 d0                	cmp    %edx,%eax
  800922:	74 06                	je     80092a <strnlen+0x1d>
  800924:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800928:	75 f3                	jne    80091d <strnlen+0x10>
	return n;
}
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800936:	89 c2                	mov    %eax,%edx
  800938:	83 c1 01             	add    $0x1,%ecx
  80093b:	83 c2 01             	add    $0x1,%edx
  80093e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800942:	88 5a ff             	mov    %bl,-0x1(%edx)
  800945:	84 db                	test   %bl,%bl
  800947:	75 ef                	jne    800938 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800949:	5b                   	pop    %ebx
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	53                   	push   %ebx
  800950:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800953:	53                   	push   %ebx
  800954:	e8 9c ff ff ff       	call   8008f5 <strlen>
  800959:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	01 d8                	add    %ebx,%eax
  800961:	50                   	push   %eax
  800962:	e8 c5 ff ff ff       	call   80092c <strcpy>
	return dst;
}
  800967:	89 d8                	mov    %ebx,%eax
  800969:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	8b 75 08             	mov    0x8(%ebp),%esi
  800976:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800979:	89 f3                	mov    %esi,%ebx
  80097b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80097e:	89 f2                	mov    %esi,%edx
  800980:	eb 0f                	jmp    800991 <strncpy+0x23>
		*dst++ = *src;
  800982:	83 c2 01             	add    $0x1,%edx
  800985:	0f b6 01             	movzbl (%ecx),%eax
  800988:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098b:	80 39 01             	cmpb   $0x1,(%ecx)
  80098e:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800991:	39 da                	cmp    %ebx,%edx
  800993:	75 ed                	jne    800982 <strncpy+0x14>
	}
	return ret;
}
  800995:	89 f0                	mov    %esi,%eax
  800997:	5b                   	pop    %ebx
  800998:	5e                   	pop    %esi
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009a9:	89 f0                	mov    %esi,%eax
  8009ab:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009af:	85 c9                	test   %ecx,%ecx
  8009b1:	75 0b                	jne    8009be <strlcpy+0x23>
  8009b3:	eb 17                	jmp    8009cc <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009b5:	83 c2 01             	add    $0x1,%edx
  8009b8:	83 c0 01             	add    $0x1,%eax
  8009bb:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009be:	39 d8                	cmp    %ebx,%eax
  8009c0:	74 07                	je     8009c9 <strlcpy+0x2e>
  8009c2:	0f b6 0a             	movzbl (%edx),%ecx
  8009c5:	84 c9                	test   %cl,%cl
  8009c7:	75 ec                	jne    8009b5 <strlcpy+0x1a>
		*dst = '\0';
  8009c9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009cc:	29 f0                	sub    %esi,%eax
}
  8009ce:	5b                   	pop    %ebx
  8009cf:	5e                   	pop    %esi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009db:	eb 06                	jmp    8009e3 <strcmp+0x11>
		p++, q++;
  8009dd:	83 c1 01             	add    $0x1,%ecx
  8009e0:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009e3:	0f b6 01             	movzbl (%ecx),%eax
  8009e6:	84 c0                	test   %al,%al
  8009e8:	74 04                	je     8009ee <strcmp+0x1c>
  8009ea:	3a 02                	cmp    (%edx),%al
  8009ec:	74 ef                	je     8009dd <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ee:	0f b6 c0             	movzbl %al,%eax
  8009f1:	0f b6 12             	movzbl (%edx),%edx
  8009f4:	29 d0                	sub    %edx,%eax
}
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	53                   	push   %ebx
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a02:	89 c3                	mov    %eax,%ebx
  800a04:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a07:	eb 06                	jmp    800a0f <strncmp+0x17>
		n--, p++, q++;
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a0f:	39 d8                	cmp    %ebx,%eax
  800a11:	74 16                	je     800a29 <strncmp+0x31>
  800a13:	0f b6 08             	movzbl (%eax),%ecx
  800a16:	84 c9                	test   %cl,%cl
  800a18:	74 04                	je     800a1e <strncmp+0x26>
  800a1a:	3a 0a                	cmp    (%edx),%cl
  800a1c:	74 eb                	je     800a09 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1e:	0f b6 00             	movzbl (%eax),%eax
  800a21:	0f b6 12             	movzbl (%edx),%edx
  800a24:	29 d0                	sub    %edx,%eax
}
  800a26:	5b                   	pop    %ebx
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    
		return 0;
  800a29:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2e:	eb f6                	jmp    800a26 <strncmp+0x2e>

00800a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a3a:	0f b6 10             	movzbl (%eax),%edx
  800a3d:	84 d2                	test   %dl,%dl
  800a3f:	74 09                	je     800a4a <strchr+0x1a>
		if (*s == c)
  800a41:	38 ca                	cmp    %cl,%dl
  800a43:	74 0a                	je     800a4f <strchr+0x1f>
	for (; *s; s++)
  800a45:	83 c0 01             	add    $0x1,%eax
  800a48:	eb f0                	jmp    800a3a <strchr+0xa>
			return (char *) s;
	return 0;
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5b:	eb 03                	jmp    800a60 <strfind+0xf>
  800a5d:	83 c0 01             	add    $0x1,%eax
  800a60:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a63:	38 ca                	cmp    %cl,%dl
  800a65:	74 04                	je     800a6b <strfind+0x1a>
  800a67:	84 d2                	test   %dl,%dl
  800a69:	75 f2                	jne    800a5d <strfind+0xc>
			break;
	return (char *) s;
}
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	57                   	push   %edi
  800a71:	56                   	push   %esi
  800a72:	53                   	push   %ebx
  800a73:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a76:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a79:	85 c9                	test   %ecx,%ecx
  800a7b:	74 13                	je     800a90 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a83:	75 05                	jne    800a8a <memset+0x1d>
  800a85:	f6 c1 03             	test   $0x3,%cl
  800a88:	74 0d                	je     800a97 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8d:	fc                   	cld    
  800a8e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a90:	89 f8                	mov    %edi,%eax
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5f                   	pop    %edi
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    
		c &= 0xFF;
  800a97:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9b:	89 d3                	mov    %edx,%ebx
  800a9d:	c1 e3 08             	shl    $0x8,%ebx
  800aa0:	89 d0                	mov    %edx,%eax
  800aa2:	c1 e0 18             	shl    $0x18,%eax
  800aa5:	89 d6                	mov    %edx,%esi
  800aa7:	c1 e6 10             	shl    $0x10,%esi
  800aaa:	09 f0                	or     %esi,%eax
  800aac:	09 c2                	or     %eax,%edx
  800aae:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ab0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab3:	89 d0                	mov    %edx,%eax
  800ab5:	fc                   	cld    
  800ab6:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab8:	eb d6                	jmp    800a90 <memset+0x23>

00800aba <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	57                   	push   %edi
  800abe:	56                   	push   %esi
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac8:	39 c6                	cmp    %eax,%esi
  800aca:	73 35                	jae    800b01 <memmove+0x47>
  800acc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800acf:	39 c2                	cmp    %eax,%edx
  800ad1:	76 2e                	jbe    800b01 <memmove+0x47>
		s += n;
		d += n;
  800ad3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad6:	89 d6                	mov    %edx,%esi
  800ad8:	09 fe                	or     %edi,%esi
  800ada:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae0:	74 0c                	je     800aee <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ae2:	83 ef 01             	sub    $0x1,%edi
  800ae5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ae8:	fd                   	std    
  800ae9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aeb:	fc                   	cld    
  800aec:	eb 21                	jmp    800b0f <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aee:	f6 c1 03             	test   $0x3,%cl
  800af1:	75 ef                	jne    800ae2 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af3:	83 ef 04             	sub    $0x4,%edi
  800af6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afc:	fd                   	std    
  800afd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aff:	eb ea                	jmp    800aeb <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b01:	89 f2                	mov    %esi,%edx
  800b03:	09 c2                	or     %eax,%edx
  800b05:	f6 c2 03             	test   $0x3,%dl
  800b08:	74 09                	je     800b13 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b0a:	89 c7                	mov    %eax,%edi
  800b0c:	fc                   	cld    
  800b0d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b0f:	5e                   	pop    %esi
  800b10:	5f                   	pop    %edi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b13:	f6 c1 03             	test   $0x3,%cl
  800b16:	75 f2                	jne    800b0a <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1b:	89 c7                	mov    %eax,%edi
  800b1d:	fc                   	cld    
  800b1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b20:	eb ed                	jmp    800b0f <memmove+0x55>

00800b22 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b25:	ff 75 10             	pushl  0x10(%ebp)
  800b28:	ff 75 0c             	pushl  0xc(%ebp)
  800b2b:	ff 75 08             	pushl  0x8(%ebp)
  800b2e:	e8 87 ff ff ff       	call   800aba <memmove>
}
  800b33:	c9                   	leave  
  800b34:	c3                   	ret    

00800b35 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b40:	89 c6                	mov    %eax,%esi
  800b42:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b45:	39 f0                	cmp    %esi,%eax
  800b47:	74 1c                	je     800b65 <memcmp+0x30>
		if (*s1 != *s2)
  800b49:	0f b6 08             	movzbl (%eax),%ecx
  800b4c:	0f b6 1a             	movzbl (%edx),%ebx
  800b4f:	38 d9                	cmp    %bl,%cl
  800b51:	75 08                	jne    800b5b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b53:	83 c0 01             	add    $0x1,%eax
  800b56:	83 c2 01             	add    $0x1,%edx
  800b59:	eb ea                	jmp    800b45 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b5b:	0f b6 c1             	movzbl %cl,%eax
  800b5e:	0f b6 db             	movzbl %bl,%ebx
  800b61:	29 d8                	sub    %ebx,%eax
  800b63:	eb 05                	jmp    800b6a <memcmp+0x35>
	}

	return 0;
  800b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6a:	5b                   	pop    %ebx
  800b6b:	5e                   	pop    %esi
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b77:	89 c2                	mov    %eax,%edx
  800b79:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7c:	39 d0                	cmp    %edx,%eax
  800b7e:	73 09                	jae    800b89 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b80:	38 08                	cmp    %cl,(%eax)
  800b82:	74 05                	je     800b89 <memfind+0x1b>
	for (; s < ends; s++)
  800b84:	83 c0 01             	add    $0x1,%eax
  800b87:	eb f3                	jmp    800b7c <memfind+0xe>
			break;
	return (void *) s;
}
  800b89:	5d                   	pop    %ebp
  800b8a:	c3                   	ret    

00800b8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	57                   	push   %edi
  800b8f:	56                   	push   %esi
  800b90:	53                   	push   %ebx
  800b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b94:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b97:	eb 03                	jmp    800b9c <strtol+0x11>
		s++;
  800b99:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b9c:	0f b6 01             	movzbl (%ecx),%eax
  800b9f:	3c 20                	cmp    $0x20,%al
  800ba1:	74 f6                	je     800b99 <strtol+0xe>
  800ba3:	3c 09                	cmp    $0x9,%al
  800ba5:	74 f2                	je     800b99 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba7:	3c 2b                	cmp    $0x2b,%al
  800ba9:	74 2e                	je     800bd9 <strtol+0x4e>
	int neg = 0;
  800bab:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bb0:	3c 2d                	cmp    $0x2d,%al
  800bb2:	74 2f                	je     800be3 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bba:	75 05                	jne    800bc1 <strtol+0x36>
  800bbc:	80 39 30             	cmpb   $0x30,(%ecx)
  800bbf:	74 2c                	je     800bed <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc1:	85 db                	test   %ebx,%ebx
  800bc3:	75 0a                	jne    800bcf <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc5:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bca:	80 39 30             	cmpb   $0x30,(%ecx)
  800bcd:	74 28                	je     800bf7 <strtol+0x6c>
		base = 10;
  800bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd4:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd7:	eb 50                	jmp    800c29 <strtol+0x9e>
		s++;
  800bd9:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  800be1:	eb d1                	jmp    800bb4 <strtol+0x29>
		s++, neg = 1;
  800be3:	83 c1 01             	add    $0x1,%ecx
  800be6:	bf 01 00 00 00       	mov    $0x1,%edi
  800beb:	eb c7                	jmp    800bb4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bed:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf1:	74 0e                	je     800c01 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bf3:	85 db                	test   %ebx,%ebx
  800bf5:	75 d8                	jne    800bcf <strtol+0x44>
		s++, base = 8;
  800bf7:	83 c1 01             	add    $0x1,%ecx
  800bfa:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bff:	eb ce                	jmp    800bcf <strtol+0x44>
		s += 2, base = 16;
  800c01:	83 c1 02             	add    $0x2,%ecx
  800c04:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c09:	eb c4                	jmp    800bcf <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c0b:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c0e:	89 f3                	mov    %esi,%ebx
  800c10:	80 fb 19             	cmp    $0x19,%bl
  800c13:	77 29                	ja     800c3e <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c15:	0f be d2             	movsbl %dl,%edx
  800c18:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c1b:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c1e:	7d 30                	jge    800c50 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c20:	83 c1 01             	add    $0x1,%ecx
  800c23:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c27:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c29:	0f b6 11             	movzbl (%ecx),%edx
  800c2c:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c2f:	89 f3                	mov    %esi,%ebx
  800c31:	80 fb 09             	cmp    $0x9,%bl
  800c34:	77 d5                	ja     800c0b <strtol+0x80>
			dig = *s - '0';
  800c36:	0f be d2             	movsbl %dl,%edx
  800c39:	83 ea 30             	sub    $0x30,%edx
  800c3c:	eb dd                	jmp    800c1b <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c3e:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c41:	89 f3                	mov    %esi,%ebx
  800c43:	80 fb 19             	cmp    $0x19,%bl
  800c46:	77 08                	ja     800c50 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c48:	0f be d2             	movsbl %dl,%edx
  800c4b:	83 ea 37             	sub    $0x37,%edx
  800c4e:	eb cb                	jmp    800c1b <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c54:	74 05                	je     800c5b <strtol+0xd0>
		*endptr = (char *) s;
  800c56:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c59:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c5b:	89 c2                	mov    %eax,%edx
  800c5d:	f7 da                	neg    %edx
  800c5f:	85 ff                	test   %edi,%edi
  800c61:	0f 45 c2             	cmovne %edx,%eax
}
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    

00800c69 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c74:	8b 55 08             	mov    0x8(%ebp),%edx
  800c77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c7a:	89 c3                	mov    %eax,%ebx
  800c7c:	89 c7                	mov    %eax,%edi
  800c7e:	89 c6                	mov    %eax,%esi
  800c80:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c92:	b8 01 00 00 00       	mov    $0x1,%eax
  800c97:	89 d1                	mov    %edx,%ecx
  800c99:	89 d3                	mov    %edx,%ebx
  800c9b:	89 d7                	mov    %edx,%edi
  800c9d:	89 d6                	mov    %edx,%esi
  800c9f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
  800cac:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	b8 03 00 00 00       	mov    $0x3,%eax
  800cbc:	89 cb                	mov    %ecx,%ebx
  800cbe:	89 cf                	mov    %ecx,%edi
  800cc0:	89 ce                	mov    %ecx,%esi
  800cc2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	7f 08                	jg     800cd0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5f                   	pop    %edi
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	83 ec 0c             	sub    $0xc,%esp
  800cd3:	50                   	push   %eax
  800cd4:	6a 03                	push   $0x3
  800cd6:	68 ff 2a 80 00       	push   $0x802aff
  800cdb:	6a 23                	push   $0x23
  800cdd:	68 1c 2b 80 00       	push   $0x802b1c
  800ce2:	e8 4b f5 ff ff       	call   800232 <_panic>

00800ce7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf7:	89 d1                	mov    %edx,%ecx
  800cf9:	89 d3                	mov    %edx,%ebx
  800cfb:	89 d7                	mov    %edx,%edi
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d01:	5b                   	pop    %ebx
  800d02:	5e                   	pop    %esi
  800d03:	5f                   	pop    %edi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <sys_yield>:

void
sys_yield(void)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	57                   	push   %edi
  800d0a:	56                   	push   %esi
  800d0b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d11:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d16:	89 d1                	mov    %edx,%ecx
  800d18:	89 d3                	mov    %edx,%ebx
  800d1a:	89 d7                	mov    %edx,%edi
  800d1c:	89 d6                	mov    %edx,%esi
  800d1e:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2e:	be 00 00 00 00       	mov    $0x0,%esi
  800d33:	8b 55 08             	mov    0x8(%ebp),%edx
  800d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d39:	b8 04 00 00 00       	mov    $0x4,%eax
  800d3e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d41:	89 f7                	mov    %esi,%edi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 04                	push   $0x4
  800d57:	68 ff 2a 80 00       	push   $0x802aff
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 1c 2b 80 00       	push   $0x802b1c
  800d63:	e8 ca f4 ff ff       	call   800232 <_panic>

00800d68 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
  800d6e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d71:	8b 55 08             	mov    0x8(%ebp),%edx
  800d74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d77:	b8 05 00 00 00       	mov    $0x5,%eax
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d82:	8b 75 18             	mov    0x18(%ebp),%esi
  800d85:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d87:	85 c0                	test   %eax,%eax
  800d89:	7f 08                	jg     800d93 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d93:	83 ec 0c             	sub    $0xc,%esp
  800d96:	50                   	push   %eax
  800d97:	6a 05                	push   $0x5
  800d99:	68 ff 2a 80 00       	push   $0x802aff
  800d9e:	6a 23                	push   $0x23
  800da0:	68 1c 2b 80 00       	push   $0x802b1c
  800da5:	e8 88 f4 ff ff       	call   800232 <_panic>

00800daa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbe:	b8 06 00 00 00       	mov    $0x6,%eax
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 06                	push   $0x6
  800ddb:	68 ff 2a 80 00       	push   $0x802aff
  800de0:	6a 23                	push   $0x23
  800de2:	68 1c 2b 80 00       	push   $0x802b1c
  800de7:	e8 46 f4 ff ff       	call   800232 <_panic>

00800dec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	b8 08 00 00 00       	mov    $0x8,%eax
  800e05:	89 df                	mov    %ebx,%edi
  800e07:	89 de                	mov    %ebx,%esi
  800e09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	7f 08                	jg     800e17 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	83 ec 0c             	sub    $0xc,%esp
  800e1a:	50                   	push   %eax
  800e1b:	6a 08                	push   $0x8
  800e1d:	68 ff 2a 80 00       	push   $0x802aff
  800e22:	6a 23                	push   $0x23
  800e24:	68 1c 2b 80 00       	push   $0x802b1c
  800e29:	e8 04 f4 ff ff       	call   800232 <_panic>

00800e2e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e42:	b8 09 00 00 00       	mov    $0x9,%eax
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	89 de                	mov    %ebx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 09                	push   $0x9
  800e5f:	68 ff 2a 80 00       	push   $0x802aff
  800e64:	6a 23                	push   $0x23
  800e66:	68 1c 2b 80 00       	push   $0x802b1c
  800e6b:	e8 c2 f3 ff ff       	call   800232 <_panic>

00800e70 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e84:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e89:	89 df                	mov    %ebx,%edi
  800e8b:	89 de                	mov    %ebx,%esi
  800e8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7f 08                	jg     800e9b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	50                   	push   %eax
  800e9f:	6a 0a                	push   $0xa
  800ea1:	68 ff 2a 80 00       	push   $0x802aff
  800ea6:	6a 23                	push   $0x23
  800ea8:	68 1c 2b 80 00       	push   $0x802b1c
  800ead:	e8 80 f3 ff ff       	call   800232 <_panic>

00800eb2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb2:	55                   	push   %ebp
  800eb3:	89 e5                	mov    %esp,%ebp
  800eb5:	57                   	push   %edi
  800eb6:	56                   	push   %esi
  800eb7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec3:	be 00 00 00 00       	mov    $0x0,%esi
  800ec8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ece:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
  800edb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ede:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eeb:	89 cb                	mov    %ecx,%ebx
  800eed:	89 cf                	mov    %ecx,%edi
  800eef:	89 ce                	mov    %ecx,%esi
  800ef1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	7f 08                	jg     800eff <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efa:	5b                   	pop    %ebx
  800efb:	5e                   	pop    %esi
  800efc:	5f                   	pop    %edi
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	50                   	push   %eax
  800f03:	6a 0d                	push   $0xd
  800f05:	68 ff 2a 80 00       	push   $0x802aff
  800f0a:	6a 23                	push   $0x23
  800f0c:	68 1c 2b 80 00       	push   $0x802b1c
  800f11:	e8 1c f3 ff ff       	call   800232 <_panic>

00800f16 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800f21:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f26:	89 d1                	mov    %edx,%ecx
  800f28:	89 d3                	mov    %edx,%ebx
  800f2a:	89 d7                	mov    %edx,%edi
  800f2c:	89 d6                	mov    %edx,%esi
  800f2e:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f30:	5b                   	pop    %ebx
  800f31:	5e                   	pop    %esi
  800f32:	5f                   	pop    %edi
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800f3d:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f3f:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f43:	74 7f                	je     800fc4 <pgfault+0x8f>
  800f45:	89 d8                	mov    %ebx,%eax
  800f47:	c1 e8 0c             	shr    $0xc,%eax
  800f4a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f51:	f6 c4 08             	test   $0x8,%ah
  800f54:	74 6e                	je     800fc4 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800f56:	e8 8c fd ff ff       	call   800ce7 <sys_getenvid>
  800f5b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	6a 07                	push   $0x7
  800f62:	68 00 f0 7f 00       	push   $0x7ff000
  800f67:	50                   	push   %eax
  800f68:	e8 b8 fd ff ff       	call   800d25 <sys_page_alloc>
  800f6d:	83 c4 10             	add    $0x10,%esp
  800f70:	85 c0                	test   %eax,%eax
  800f72:	78 64                	js     800fd8 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800f74:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800f7a:	83 ec 04             	sub    $0x4,%esp
  800f7d:	68 00 10 00 00       	push   $0x1000
  800f82:	53                   	push   %ebx
  800f83:	68 00 f0 7f 00       	push   $0x7ff000
  800f88:	e8 2d fb ff ff       	call   800aba <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800f8d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f94:	53                   	push   %ebx
  800f95:	56                   	push   %esi
  800f96:	68 00 f0 7f 00       	push   $0x7ff000
  800f9b:	56                   	push   %esi
  800f9c:	e8 c7 fd ff ff       	call   800d68 <sys_page_map>
  800fa1:	83 c4 20             	add    $0x20,%esp
  800fa4:	85 c0                	test   %eax,%eax
  800fa6:	78 42                	js     800fea <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	68 00 f0 7f 00       	push   $0x7ff000
  800fb0:	56                   	push   %esi
  800fb1:	e8 f4 fd ff ff       	call   800daa <sys_page_unmap>
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	78 3f                	js     800ffc <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fc0:	5b                   	pop    %ebx
  800fc1:	5e                   	pop    %esi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800fc4:	83 ec 04             	sub    $0x4,%esp
  800fc7:	68 2c 2b 80 00       	push   $0x802b2c
  800fcc:	6a 1d                	push   $0x1d
  800fce:	68 bb 2b 80 00       	push   $0x802bbb
  800fd3:	e8 5a f2 ff ff       	call   800232 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800fd8:	50                   	push   %eax
  800fd9:	68 54 2b 80 00       	push   $0x802b54
  800fde:	6a 28                	push   $0x28
  800fe0:	68 bb 2b 80 00       	push   $0x802bbb
  800fe5:	e8 48 f2 ff ff       	call   800232 <_panic>
		panic("pgfault:page map failed: %e", r);
  800fea:	50                   	push   %eax
  800feb:	68 c6 2b 80 00       	push   $0x802bc6
  800ff0:	6a 2c                	push   $0x2c
  800ff2:	68 bb 2b 80 00       	push   $0x802bbb
  800ff7:	e8 36 f2 ff ff       	call   800232 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800ffc:	50                   	push   %eax
  800ffd:	68 78 2b 80 00       	push   $0x802b78
  801002:	6a 2e                	push   $0x2e
  801004:	68 bb 2b 80 00       	push   $0x802bbb
  801009:	e8 24 f2 ff ff       	call   800232 <_panic>

0080100e <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	57                   	push   %edi
  801012:	56                   	push   %esi
  801013:	53                   	push   %ebx
  801014:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  801017:	68 35 0f 80 00       	push   $0x800f35
  80101c:	e8 d2 12 00 00       	call   8022f3 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801021:	b8 07 00 00 00       	mov    $0x7,%eax
  801026:	cd 30                	int    $0x30
  801028:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  80102b:	83 c4 10             	add    $0x10,%esp
  80102e:	85 c0                	test   %eax,%eax
  801030:	78 2f                	js     801061 <fork+0x53>
  801032:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801034:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  801039:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80103d:	75 6e                	jne    8010ad <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80103f:	e8 a3 fc ff ff       	call   800ce7 <sys_getenvid>
  801044:	25 ff 03 00 00       	and    $0x3ff,%eax
  801049:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80104c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801051:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  801059:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  801061:	50                   	push   %eax
  801062:	68 98 2b 80 00       	push   $0x802b98
  801067:	6a 6e                	push   $0x6e
  801069:	68 bb 2b 80 00       	push   $0x802bbb
  80106e:	e8 bf f1 ff ff       	call   800232 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801073:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80107a:	83 ec 0c             	sub    $0xc,%esp
  80107d:	25 07 0e 00 00       	and    $0xe07,%eax
  801082:	50                   	push   %eax
  801083:	56                   	push   %esi
  801084:	57                   	push   %edi
  801085:	56                   	push   %esi
  801086:	6a 00                	push   $0x0
  801088:	e8 db fc ff ff       	call   800d68 <sys_page_map>
  80108d:	83 c4 20             	add    $0x20,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	ba 00 00 00 00       	mov    $0x0,%edx
  801097:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	78 bb                	js     801059 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  80109e:	83 c3 01             	add    $0x1,%ebx
  8010a1:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8010a7:	0f 84 a6 00 00 00    	je     801153 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8010ad:	89 d8                	mov    %ebx,%eax
  8010af:	c1 e8 0a             	shr    $0xa,%eax
  8010b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010b9:	a8 01                	test   $0x1,%al
  8010bb:	74 e1                	je     80109e <fork+0x90>
  8010bd:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010c4:	a8 01                	test   $0x1,%al
  8010c6:	74 d6                	je     80109e <fork+0x90>
  8010c8:	89 de                	mov    %ebx,%esi
  8010ca:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  8010cd:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010d4:	f6 c4 04             	test   $0x4,%ah
  8010d7:	75 9a                	jne    801073 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8010d9:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010e0:	a8 02                	test   $0x2,%al
  8010e2:	75 0c                	jne    8010f0 <fork+0xe2>
  8010e4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010eb:	f6 c4 08             	test   $0x8,%ah
  8010ee:	74 42                	je     801132 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	68 05 08 00 00       	push   $0x805
  8010f8:	56                   	push   %esi
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	6a 00                	push   $0x0
  8010fd:	e8 66 fc ff ff       	call   800d68 <sys_page_map>
  801102:	83 c4 20             	add    $0x20,%esp
  801105:	85 c0                	test   %eax,%eax
  801107:	0f 88 4c ff ff ff    	js     801059 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  80110d:	83 ec 0c             	sub    $0xc,%esp
  801110:	68 05 08 00 00       	push   $0x805
  801115:	56                   	push   %esi
  801116:	6a 00                	push   $0x0
  801118:	56                   	push   %esi
  801119:	6a 00                	push   $0x0
  80111b:	e8 48 fc ff ff       	call   800d68 <sys_page_map>
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	b9 00 00 00 00       	mov    $0x0,%ecx
  80112a:	0f 4f c1             	cmovg  %ecx,%eax
  80112d:	e9 68 ff ff ff       	jmp    80109a <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801132:	83 ec 0c             	sub    $0xc,%esp
  801135:	6a 05                	push   $0x5
  801137:	56                   	push   %esi
  801138:	57                   	push   %edi
  801139:	56                   	push   %esi
  80113a:	6a 00                	push   $0x0
  80113c:	e8 27 fc ff ff       	call   800d68 <sys_page_map>
  801141:	83 c4 20             	add    $0x20,%esp
  801144:	85 c0                	test   %eax,%eax
  801146:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114b:	0f 4f c1             	cmovg  %ecx,%eax
  80114e:	e9 47 ff ff ff       	jmp    80109a <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801153:	83 ec 04             	sub    $0x4,%esp
  801156:	6a 07                	push   $0x7
  801158:	68 00 f0 bf ee       	push   $0xeebff000
  80115d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801160:	57                   	push   %edi
  801161:	e8 bf fb ff ff       	call   800d25 <sys_page_alloc>
  801166:	83 c4 10             	add    $0x10,%esp
  801169:	85 c0                	test   %eax,%eax
  80116b:	0f 88 e8 fe ff ff    	js     801059 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	68 58 23 80 00       	push   $0x802358
  801179:	57                   	push   %edi
  80117a:	e8 f1 fc ff ff       	call   800e70 <sys_env_set_pgfault_upcall>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	0f 88 cf fe ff ff    	js     801059 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	6a 02                	push   $0x2
  80118f:	57                   	push   %edi
  801190:	e8 57 fc ff ff       	call   800dec <sys_env_set_status>
  801195:	83 c4 10             	add    $0x10,%esp
  801198:	85 c0                	test   %eax,%eax
  80119a:	78 08                	js     8011a4 <fork+0x196>
	return eid;
  80119c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80119f:	e9 b5 fe ff ff       	jmp    801059 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  8011a4:	50                   	push   %eax
  8011a5:	68 e2 2b 80 00       	push   $0x802be2
  8011aa:	68 87 00 00 00       	push   $0x87
  8011af:	68 bb 2b 80 00       	push   $0x802bbb
  8011b4:	e8 79 f0 ff ff       	call   800232 <_panic>

008011b9 <sfork>:

// Challenge!
int sfork(void)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011bf:	68 00 2c 80 00       	push   $0x802c00
  8011c4:	68 8f 00 00 00       	push   $0x8f
  8011c9:	68 bb 2b 80 00       	push   $0x802bbb
  8011ce:	e8 5f f0 ff ff       	call   800232 <_panic>

008011d3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	05 00 00 00 30       	add    $0x30000000,%eax
  8011de:	c1 e8 0c             	shr    $0xc,%eax
}
  8011e1:	5d                   	pop    %ebp
  8011e2:	c3                   	ret    

008011e3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011e3:	55                   	push   %ebp
  8011e4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801200:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801205:	89 c2                	mov    %eax,%edx
  801207:	c1 ea 16             	shr    $0x16,%edx
  80120a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801211:	f6 c2 01             	test   $0x1,%dl
  801214:	74 2a                	je     801240 <fd_alloc+0x46>
  801216:	89 c2                	mov    %eax,%edx
  801218:	c1 ea 0c             	shr    $0xc,%edx
  80121b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801222:	f6 c2 01             	test   $0x1,%dl
  801225:	74 19                	je     801240 <fd_alloc+0x46>
  801227:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80122c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801231:	75 d2                	jne    801205 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801233:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801239:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80123e:	eb 07                	jmp    801247 <fd_alloc+0x4d>
			*fd_store = fd;
  801240:	89 01                	mov    %eax,(%ecx)
			return 0;
  801242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80124f:	83 f8 1f             	cmp    $0x1f,%eax
  801252:	77 36                	ja     80128a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801254:	c1 e0 0c             	shl    $0xc,%eax
  801257:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80125c:	89 c2                	mov    %eax,%edx
  80125e:	c1 ea 16             	shr    $0x16,%edx
  801261:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801268:	f6 c2 01             	test   $0x1,%dl
  80126b:	74 24                	je     801291 <fd_lookup+0x48>
  80126d:	89 c2                	mov    %eax,%edx
  80126f:	c1 ea 0c             	shr    $0xc,%edx
  801272:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801279:	f6 c2 01             	test   $0x1,%dl
  80127c:	74 1a                	je     801298 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80127e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801281:	89 02                	mov    %eax,(%edx)
	return 0;
  801283:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    
		return -E_INVAL;
  80128a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128f:	eb f7                	jmp    801288 <fd_lookup+0x3f>
		return -E_INVAL;
  801291:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801296:	eb f0                	jmp    801288 <fd_lookup+0x3f>
  801298:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129d:	eb e9                	jmp    801288 <fd_lookup+0x3f>

0080129f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	83 ec 08             	sub    $0x8,%esp
  8012a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a8:	ba 98 2c 80 00       	mov    $0x802c98,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012ad:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012b2:	39 08                	cmp    %ecx,(%eax)
  8012b4:	74 33                	je     8012e9 <dev_lookup+0x4a>
  8012b6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012b9:	8b 02                	mov    (%edx),%eax
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	75 f3                	jne    8012b2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8012c4:	8b 40 48             	mov    0x48(%eax),%eax
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	51                   	push   %ecx
  8012cb:	50                   	push   %eax
  8012cc:	68 18 2c 80 00       	push   $0x802c18
  8012d1:	e8 37 f0 ff ff       	call   80030d <cprintf>
	*dev = 0;
  8012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    
			*dev = devtab[i];
  8012e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ec:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f3:	eb f2                	jmp    8012e7 <dev_lookup+0x48>

008012f5 <fd_close>:
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	57                   	push   %edi
  8012f9:	56                   	push   %esi
  8012fa:	53                   	push   %ebx
  8012fb:	83 ec 1c             	sub    $0x1c,%esp
  8012fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801301:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801304:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801307:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801308:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80130e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801311:	50                   	push   %eax
  801312:	e8 32 ff ff ff       	call   801249 <fd_lookup>
  801317:	89 c3                	mov    %eax,%ebx
  801319:	83 c4 08             	add    $0x8,%esp
  80131c:	85 c0                	test   %eax,%eax
  80131e:	78 05                	js     801325 <fd_close+0x30>
	    || fd != fd2)
  801320:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801323:	74 16                	je     80133b <fd_close+0x46>
		return (must_exist ? r : 0);
  801325:	89 f8                	mov    %edi,%eax
  801327:	84 c0                	test   %al,%al
  801329:	b8 00 00 00 00       	mov    $0x0,%eax
  80132e:	0f 44 d8             	cmove  %eax,%ebx
}
  801331:	89 d8                	mov    %ebx,%eax
  801333:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801336:	5b                   	pop    %ebx
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80133b:	83 ec 08             	sub    $0x8,%esp
  80133e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801341:	50                   	push   %eax
  801342:	ff 36                	pushl  (%esi)
  801344:	e8 56 ff ff ff       	call   80129f <dev_lookup>
  801349:	89 c3                	mov    %eax,%ebx
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 15                	js     801367 <fd_close+0x72>
		if (dev->dev_close)
  801352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801355:	8b 40 10             	mov    0x10(%eax),%eax
  801358:	85 c0                	test   %eax,%eax
  80135a:	74 1b                	je     801377 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80135c:	83 ec 0c             	sub    $0xc,%esp
  80135f:	56                   	push   %esi
  801360:	ff d0                	call   *%eax
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801367:	83 ec 08             	sub    $0x8,%esp
  80136a:	56                   	push   %esi
  80136b:	6a 00                	push   $0x0
  80136d:	e8 38 fa ff ff       	call   800daa <sys_page_unmap>
	return r;
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	eb ba                	jmp    801331 <fd_close+0x3c>
			r = 0;
  801377:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137c:	eb e9                	jmp    801367 <fd_close+0x72>

0080137e <close>:

int
close(int fdnum)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801384:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801387:	50                   	push   %eax
  801388:	ff 75 08             	pushl  0x8(%ebp)
  80138b:	e8 b9 fe ff ff       	call   801249 <fd_lookup>
  801390:	83 c4 08             	add    $0x8,%esp
  801393:	85 c0                	test   %eax,%eax
  801395:	78 10                	js     8013a7 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801397:	83 ec 08             	sub    $0x8,%esp
  80139a:	6a 01                	push   $0x1
  80139c:	ff 75 f4             	pushl  -0xc(%ebp)
  80139f:	e8 51 ff ff ff       	call   8012f5 <fd_close>
  8013a4:	83 c4 10             	add    $0x10,%esp
}
  8013a7:	c9                   	leave  
  8013a8:	c3                   	ret    

008013a9 <close_all>:

void
close_all(void)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
  8013ac:	53                   	push   %ebx
  8013ad:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013b0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013b5:	83 ec 0c             	sub    $0xc,%esp
  8013b8:	53                   	push   %ebx
  8013b9:	e8 c0 ff ff ff       	call   80137e <close>
	for (i = 0; i < MAXFD; i++)
  8013be:	83 c3 01             	add    $0x1,%ebx
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	83 fb 20             	cmp    $0x20,%ebx
  8013c7:	75 ec                	jne    8013b5 <close_all+0xc>
}
  8013c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	57                   	push   %edi
  8013d2:	56                   	push   %esi
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013da:	50                   	push   %eax
  8013db:	ff 75 08             	pushl  0x8(%ebp)
  8013de:	e8 66 fe ff ff       	call   801249 <fd_lookup>
  8013e3:	89 c3                	mov    %eax,%ebx
  8013e5:	83 c4 08             	add    $0x8,%esp
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	0f 88 81 00 00 00    	js     801471 <dup+0xa3>
		return r;
	close(newfdnum);
  8013f0:	83 ec 0c             	sub    $0xc,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	e8 83 ff ff ff       	call   80137e <close>

	newfd = INDEX2FD(newfdnum);
  8013fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013fe:	c1 e6 0c             	shl    $0xc,%esi
  801401:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801407:	83 c4 04             	add    $0x4,%esp
  80140a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80140d:	e8 d1 fd ff ff       	call   8011e3 <fd2data>
  801412:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801414:	89 34 24             	mov    %esi,(%esp)
  801417:	e8 c7 fd ff ff       	call   8011e3 <fd2data>
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801421:	89 d8                	mov    %ebx,%eax
  801423:	c1 e8 16             	shr    $0x16,%eax
  801426:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80142d:	a8 01                	test   $0x1,%al
  80142f:	74 11                	je     801442 <dup+0x74>
  801431:	89 d8                	mov    %ebx,%eax
  801433:	c1 e8 0c             	shr    $0xc,%eax
  801436:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80143d:	f6 c2 01             	test   $0x1,%dl
  801440:	75 39                	jne    80147b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801442:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801445:	89 d0                	mov    %edx,%eax
  801447:	c1 e8 0c             	shr    $0xc,%eax
  80144a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	25 07 0e 00 00       	and    $0xe07,%eax
  801459:	50                   	push   %eax
  80145a:	56                   	push   %esi
  80145b:	6a 00                	push   $0x0
  80145d:	52                   	push   %edx
  80145e:	6a 00                	push   $0x0
  801460:	e8 03 f9 ff ff       	call   800d68 <sys_page_map>
  801465:	89 c3                	mov    %eax,%ebx
  801467:	83 c4 20             	add    $0x20,%esp
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 31                	js     80149f <dup+0xd1>
		goto err;

	return newfdnum;
  80146e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801471:	89 d8                	mov    %ebx,%eax
  801473:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801476:	5b                   	pop    %ebx
  801477:	5e                   	pop    %esi
  801478:	5f                   	pop    %edi
  801479:	5d                   	pop    %ebp
  80147a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80147b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801482:	83 ec 0c             	sub    $0xc,%esp
  801485:	25 07 0e 00 00       	and    $0xe07,%eax
  80148a:	50                   	push   %eax
  80148b:	57                   	push   %edi
  80148c:	6a 00                	push   $0x0
  80148e:	53                   	push   %ebx
  80148f:	6a 00                	push   $0x0
  801491:	e8 d2 f8 ff ff       	call   800d68 <sys_page_map>
  801496:	89 c3                	mov    %eax,%ebx
  801498:	83 c4 20             	add    $0x20,%esp
  80149b:	85 c0                	test   %eax,%eax
  80149d:	79 a3                	jns    801442 <dup+0x74>
	sys_page_unmap(0, newfd);
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	56                   	push   %esi
  8014a3:	6a 00                	push   $0x0
  8014a5:	e8 00 f9 ff ff       	call   800daa <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014aa:	83 c4 08             	add    $0x8,%esp
  8014ad:	57                   	push   %edi
  8014ae:	6a 00                	push   $0x0
  8014b0:	e8 f5 f8 ff ff       	call   800daa <sys_page_unmap>
	return r;
  8014b5:	83 c4 10             	add    $0x10,%esp
  8014b8:	eb b7                	jmp    801471 <dup+0xa3>

008014ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	53                   	push   %ebx
  8014be:	83 ec 14             	sub    $0x14,%esp
  8014c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c7:	50                   	push   %eax
  8014c8:	53                   	push   %ebx
  8014c9:	e8 7b fd ff ff       	call   801249 <fd_lookup>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 3f                	js     801514 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d5:	83 ec 08             	sub    $0x8,%esp
  8014d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014db:	50                   	push   %eax
  8014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014df:	ff 30                	pushl  (%eax)
  8014e1:	e8 b9 fd ff ff       	call   80129f <dev_lookup>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	78 27                	js     801514 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f0:	8b 42 08             	mov    0x8(%edx),%eax
  8014f3:	83 e0 03             	and    $0x3,%eax
  8014f6:	83 f8 01             	cmp    $0x1,%eax
  8014f9:	74 1e                	je     801519 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fe:	8b 40 08             	mov    0x8(%eax),%eax
  801501:	85 c0                	test   %eax,%eax
  801503:	74 35                	je     80153a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	ff 75 10             	pushl  0x10(%ebp)
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	52                   	push   %edx
  80150f:	ff d0                	call   *%eax
  801511:	83 c4 10             	add    $0x10,%esp
}
  801514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801517:	c9                   	leave  
  801518:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801519:	a1 08 40 80 00       	mov    0x804008,%eax
  80151e:	8b 40 48             	mov    0x48(%eax),%eax
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	53                   	push   %ebx
  801525:	50                   	push   %eax
  801526:	68 5c 2c 80 00       	push   $0x802c5c
  80152b:	e8 dd ed ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801538:	eb da                	jmp    801514 <read+0x5a>
		return -E_NOT_SUPP;
  80153a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153f:	eb d3                	jmp    801514 <read+0x5a>

00801541 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	57                   	push   %edi
  801545:	56                   	push   %esi
  801546:	53                   	push   %ebx
  801547:	83 ec 0c             	sub    $0xc,%esp
  80154a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80154d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801550:	bb 00 00 00 00       	mov    $0x0,%ebx
  801555:	39 f3                	cmp    %esi,%ebx
  801557:	73 25                	jae    80157e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801559:	83 ec 04             	sub    $0x4,%esp
  80155c:	89 f0                	mov    %esi,%eax
  80155e:	29 d8                	sub    %ebx,%eax
  801560:	50                   	push   %eax
  801561:	89 d8                	mov    %ebx,%eax
  801563:	03 45 0c             	add    0xc(%ebp),%eax
  801566:	50                   	push   %eax
  801567:	57                   	push   %edi
  801568:	e8 4d ff ff ff       	call   8014ba <read>
		if (m < 0)
  80156d:	83 c4 10             	add    $0x10,%esp
  801570:	85 c0                	test   %eax,%eax
  801572:	78 08                	js     80157c <readn+0x3b>
			return m;
		if (m == 0)
  801574:	85 c0                	test   %eax,%eax
  801576:	74 06                	je     80157e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801578:	01 c3                	add    %eax,%ebx
  80157a:	eb d9                	jmp    801555 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80157c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80157e:	89 d8                	mov    %ebx,%eax
  801580:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801583:	5b                   	pop    %ebx
  801584:	5e                   	pop    %esi
  801585:	5f                   	pop    %edi
  801586:	5d                   	pop    %ebp
  801587:	c3                   	ret    

00801588 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	53                   	push   %ebx
  80158c:	83 ec 14             	sub    $0x14,%esp
  80158f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801592:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801595:	50                   	push   %eax
  801596:	53                   	push   %ebx
  801597:	e8 ad fc ff ff       	call   801249 <fd_lookup>
  80159c:	83 c4 08             	add    $0x8,%esp
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	78 3a                	js     8015dd <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a9:	50                   	push   %eax
  8015aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ad:	ff 30                	pushl  (%eax)
  8015af:	e8 eb fc ff ff       	call   80129f <dev_lookup>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 22                	js     8015dd <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015c2:	74 1e                	je     8015e2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c7:	8b 52 0c             	mov    0xc(%edx),%edx
  8015ca:	85 d2                	test   %edx,%edx
  8015cc:	74 35                	je     801603 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	ff 75 10             	pushl  0x10(%ebp)
  8015d4:	ff 75 0c             	pushl  0xc(%ebp)
  8015d7:	50                   	push   %eax
  8015d8:	ff d2                	call   *%edx
  8015da:	83 c4 10             	add    $0x10,%esp
}
  8015dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015e2:	a1 08 40 80 00       	mov    0x804008,%eax
  8015e7:	8b 40 48             	mov    0x48(%eax),%eax
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	53                   	push   %ebx
  8015ee:	50                   	push   %eax
  8015ef:	68 78 2c 80 00       	push   $0x802c78
  8015f4:	e8 14 ed ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801601:	eb da                	jmp    8015dd <write+0x55>
		return -E_NOT_SUPP;
  801603:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801608:	eb d3                	jmp    8015dd <write+0x55>

0080160a <seek>:

int
seek(int fdnum, off_t offset)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801610:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801613:	50                   	push   %eax
  801614:	ff 75 08             	pushl  0x8(%ebp)
  801617:	e8 2d fc ff ff       	call   801249 <fd_lookup>
  80161c:	83 c4 08             	add    $0x8,%esp
  80161f:	85 c0                	test   %eax,%eax
  801621:	78 0e                	js     801631 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801629:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80162c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	53                   	push   %ebx
  801637:	83 ec 14             	sub    $0x14,%esp
  80163a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80163d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801640:	50                   	push   %eax
  801641:	53                   	push   %ebx
  801642:	e8 02 fc ff ff       	call   801249 <fd_lookup>
  801647:	83 c4 08             	add    $0x8,%esp
  80164a:	85 c0                	test   %eax,%eax
  80164c:	78 37                	js     801685 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80164e:	83 ec 08             	sub    $0x8,%esp
  801651:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801654:	50                   	push   %eax
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	ff 30                	pushl  (%eax)
  80165a:	e8 40 fc ff ff       	call   80129f <dev_lookup>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	85 c0                	test   %eax,%eax
  801664:	78 1f                	js     801685 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80166d:	74 1b                	je     80168a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80166f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801672:	8b 52 18             	mov    0x18(%edx),%edx
  801675:	85 d2                	test   %edx,%edx
  801677:	74 32                	je     8016ab <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	50                   	push   %eax
  801680:	ff d2                	call   *%edx
  801682:	83 c4 10             	add    $0x10,%esp
}
  801685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801688:	c9                   	leave  
  801689:	c3                   	ret    
			thisenv->env_id, fdnum);
  80168a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80168f:	8b 40 48             	mov    0x48(%eax),%eax
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	53                   	push   %ebx
  801696:	50                   	push   %eax
  801697:	68 38 2c 80 00       	push   $0x802c38
  80169c:	e8 6c ec ff ff       	call   80030d <cprintf>
		return -E_INVAL;
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a9:	eb da                	jmp    801685 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016b0:	eb d3                	jmp    801685 <ftruncate+0x52>

008016b2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	53                   	push   %ebx
  8016b6:	83 ec 14             	sub    $0x14,%esp
  8016b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bf:	50                   	push   %eax
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	e8 81 fb ff ff       	call   801249 <fd_lookup>
  8016c8:	83 c4 08             	add    $0x8,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 4b                	js     80171a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	ff 30                	pushl  (%eax)
  8016db:	e8 bf fb ff ff       	call   80129f <dev_lookup>
  8016e0:	83 c4 10             	add    $0x10,%esp
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	78 33                	js     80171a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ea:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016ee:	74 2f                	je     80171f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016fa:	00 00 00 
	stat->st_isdir = 0;
  8016fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801704:	00 00 00 
	stat->st_dev = dev;
  801707:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80170d:	83 ec 08             	sub    $0x8,%esp
  801710:	53                   	push   %ebx
  801711:	ff 75 f0             	pushl  -0x10(%ebp)
  801714:	ff 50 14             	call   *0x14(%eax)
  801717:	83 c4 10             	add    $0x10,%esp
}
  80171a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    
		return -E_NOT_SUPP;
  80171f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801724:	eb f4                	jmp    80171a <fstat+0x68>

00801726 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80172b:	83 ec 08             	sub    $0x8,%esp
  80172e:	6a 00                	push   $0x0
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	e8 e7 01 00 00       	call   80191f <open>
  801738:	89 c3                	mov    %eax,%ebx
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 1b                	js     80175c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801741:	83 ec 08             	sub    $0x8,%esp
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	50                   	push   %eax
  801748:	e8 65 ff ff ff       	call   8016b2 <fstat>
  80174d:	89 c6                	mov    %eax,%esi
	close(fd);
  80174f:	89 1c 24             	mov    %ebx,(%esp)
  801752:	e8 27 fc ff ff       	call   80137e <close>
	return r;
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 f3                	mov    %esi,%ebx
}
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801761:	5b                   	pop    %ebx
  801762:	5e                   	pop    %esi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
  80176a:	89 c6                	mov    %eax,%esi
  80176c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80176e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801775:	74 27                	je     80179e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801777:	6a 07                	push   $0x7
  801779:	68 00 50 80 00       	push   $0x805000
  80177e:	56                   	push   %esi
  80177f:	ff 35 00 40 80 00    	pushl  0x804000
  801785:	e8 5b 0c 00 00       	call   8023e5 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80178a:	83 c4 0c             	add    $0xc,%esp
  80178d:	6a 00                	push   $0x0
  80178f:	53                   	push   %ebx
  801790:	6a 00                	push   $0x0
  801792:	e8 e7 0b 00 00       	call   80237e <ipc_recv>
}
  801797:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80179e:	83 ec 0c             	sub    $0xc,%esp
  8017a1:	6a 01                	push   $0x1
  8017a3:	e8 91 0c 00 00       	call   802439 <ipc_find_env>
  8017a8:	a3 00 40 80 00       	mov    %eax,0x804000
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	eb c5                	jmp    801777 <fsipc+0x12>

008017b2 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8017be:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c6:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	b8 02 00 00 00       	mov    $0x2,%eax
  8017d5:	e8 8b ff ff ff       	call   801765 <fsipc>
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <devfile_flush>:
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f2:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f7:	e8 69 ff ff ff       	call   801765 <fsipc>
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <devfile_stat>:
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	53                   	push   %ebx
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8b 40 0c             	mov    0xc(%eax),%eax
  80180e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801813:	ba 00 00 00 00       	mov    $0x0,%edx
  801818:	b8 05 00 00 00       	mov    $0x5,%eax
  80181d:	e8 43 ff ff ff       	call   801765 <fsipc>
  801822:	85 c0                	test   %eax,%eax
  801824:	78 2c                	js     801852 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801826:	83 ec 08             	sub    $0x8,%esp
  801829:	68 00 50 80 00       	push   $0x805000
  80182e:	53                   	push   %ebx
  80182f:	e8 f8 f0 ff ff       	call   80092c <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801834:	a1 80 50 80 00       	mov    0x805080,%eax
  801839:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80183f:	a1 84 50 80 00       	mov    0x805084,%eax
  801844:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <devfile_write>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 0c             	sub    $0xc,%esp
  80185d:	8b 45 10             	mov    0x10(%ebp),%eax
  801860:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801865:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80186a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80186d:	8b 55 08             	mov    0x8(%ebp),%edx
  801870:	8b 52 0c             	mov    0xc(%edx),%edx
  801873:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801879:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80187e:	50                   	push   %eax
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	68 08 50 80 00       	push   $0x805008
  801887:	e8 2e f2 ff ff       	call   800aba <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80188c:	ba 00 00 00 00       	mov    $0x0,%edx
  801891:	b8 04 00 00 00       	mov    $0x4,%eax
  801896:	e8 ca fe ff ff       	call   801765 <fsipc>
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <devfile_read>:
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ab:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018b0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	b8 03 00 00 00       	mov    $0x3,%eax
  8018c0:	e8 a0 fe ff ff       	call   801765 <fsipc>
  8018c5:	89 c3                	mov    %eax,%ebx
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 1f                	js     8018ea <devfile_read+0x4d>
	assert(r <= n);
  8018cb:	39 f0                	cmp    %esi,%eax
  8018cd:	77 24                	ja     8018f3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018cf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d4:	7f 33                	jg     801909 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	50                   	push   %eax
  8018da:	68 00 50 80 00       	push   $0x805000
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	e8 d3 f1 ff ff       	call   800aba <memmove>
	return r;
  8018e7:	83 c4 10             	add    $0x10,%esp
}
  8018ea:	89 d8                	mov    %ebx,%eax
  8018ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5d                   	pop    %ebp
  8018f2:	c3                   	ret    
	assert(r <= n);
  8018f3:	68 ac 2c 80 00       	push   $0x802cac
  8018f8:	68 b3 2c 80 00       	push   $0x802cb3
  8018fd:	6a 7b                	push   $0x7b
  8018ff:	68 c8 2c 80 00       	push   $0x802cc8
  801904:	e8 29 e9 ff ff       	call   800232 <_panic>
	assert(r <= PGSIZE);
  801909:	68 d3 2c 80 00       	push   $0x802cd3
  80190e:	68 b3 2c 80 00       	push   $0x802cb3
  801913:	6a 7c                	push   $0x7c
  801915:	68 c8 2c 80 00       	push   $0x802cc8
  80191a:	e8 13 e9 ff ff       	call   800232 <_panic>

0080191f <open>:
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	83 ec 1c             	sub    $0x1c,%esp
  801927:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80192a:	56                   	push   %esi
  80192b:	e8 c5 ef ff ff       	call   8008f5 <strlen>
  801930:	83 c4 10             	add    $0x10,%esp
  801933:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801938:	7f 6c                	jg     8019a6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80193a:	83 ec 0c             	sub    $0xc,%esp
  80193d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801940:	50                   	push   %eax
  801941:	e8 b4 f8 ff ff       	call   8011fa <fd_alloc>
  801946:	89 c3                	mov    %eax,%ebx
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 3c                	js     80198b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	56                   	push   %esi
  801953:	68 00 50 80 00       	push   $0x805000
  801958:	e8 cf ef ff ff       	call   80092c <strcpy>
	fsipcbuf.open.req_omode = mode;
  80195d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801960:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801968:	b8 01 00 00 00       	mov    $0x1,%eax
  80196d:	e8 f3 fd ff ff       	call   801765 <fsipc>
  801972:	89 c3                	mov    %eax,%ebx
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	78 19                	js     801994 <open+0x75>
	return fd2num(fd);
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	ff 75 f4             	pushl  -0xc(%ebp)
  801981:	e8 4d f8 ff ff       	call   8011d3 <fd2num>
  801986:	89 c3                	mov    %eax,%ebx
  801988:	83 c4 10             	add    $0x10,%esp
}
  80198b:	89 d8                	mov    %ebx,%eax
  80198d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801990:	5b                   	pop    %ebx
  801991:	5e                   	pop    %esi
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    
		fd_close(fd, 0);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	6a 00                	push   $0x0
  801999:	ff 75 f4             	pushl  -0xc(%ebp)
  80199c:	e8 54 f9 ff ff       	call   8012f5 <fd_close>
		return r;
  8019a1:	83 c4 10             	add    $0x10,%esp
  8019a4:	eb e5                	jmp    80198b <open+0x6c>
		return -E_BAD_PATH;
  8019a6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019ab:	eb de                	jmp    80198b <open+0x6c>

008019ad <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8019bd:	e8 a3 fd ff ff       	call   801765 <fsipc>
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019ca:	68 df 2c 80 00       	push   $0x802cdf
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	e8 55 ef ff ff       	call   80092c <strcpy>
	return 0;
}
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <devsock_close>:
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	53                   	push   %ebx
  8019e2:	83 ec 10             	sub    $0x10,%esp
  8019e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019e8:	53                   	push   %ebx
  8019e9:	e8 84 0a 00 00       	call   802472 <pageref>
  8019ee:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019f6:	83 f8 01             	cmp    $0x1,%eax
  8019f9:	74 07                	je     801a02 <devsock_close+0x24>
}
  8019fb:	89 d0                	mov    %edx,%eax
  8019fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a02:	83 ec 0c             	sub    $0xc,%esp
  801a05:	ff 73 0c             	pushl  0xc(%ebx)
  801a08:	e8 b7 02 00 00       	call   801cc4 <nsipc_close>
  801a0d:	89 c2                	mov    %eax,%edx
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	eb e7                	jmp    8019fb <devsock_close+0x1d>

00801a14 <devsock_write>:
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	ff 70 0c             	pushl  0xc(%eax)
  801a28:	e8 74 03 00 00       	call   801da1 <nsipc_send>
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <devsock_read>:
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	ff 70 0c             	pushl  0xc(%eax)
  801a43:	e8 ed 02 00 00       	call   801d35 <nsipc_recv>
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <fd2sockid>:
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a50:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	e8 ef f7 ff ff       	call   801249 <fd_lookup>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 10                	js     801a71 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a64:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a6a:	39 08                	cmp    %ecx,(%eax)
  801a6c:	75 05                	jne    801a73 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a6e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    
		return -E_NOT_SUPP;
  801a73:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a78:	eb f7                	jmp    801a71 <fd2sockid+0x27>

00801a7a <alloc_sockfd>:
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	56                   	push   %esi
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 1c             	sub    $0x1c,%esp
  801a82:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a87:	50                   	push   %eax
  801a88:	e8 6d f7 ff ff       	call   8011fa <fd_alloc>
  801a8d:	89 c3                	mov    %eax,%ebx
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	85 c0                	test   %eax,%eax
  801a94:	78 43                	js     801ad9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	68 07 04 00 00       	push   $0x407
  801a9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa1:	6a 00                	push   $0x0
  801aa3:	e8 7d f2 ff ff       	call   800d25 <sys_page_alloc>
  801aa8:	89 c3                	mov    %eax,%ebx
  801aaa:	83 c4 10             	add    $0x10,%esp
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	78 28                	js     801ad9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab4:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801aba:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abf:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ac6:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 01 f7 ff ff       	call   8011d3 <fd2num>
  801ad2:	89 c3                	mov    %eax,%ebx
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	eb 0c                	jmp    801ae5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	56                   	push   %esi
  801add:	e8 e2 01 00 00       	call   801cc4 <nsipc_close>
		return r;
  801ae2:	83 c4 10             	add    $0x10,%esp
}
  801ae5:	89 d8                	mov    %ebx,%eax
  801ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    

00801aee <accept>:
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	e8 4e ff ff ff       	call   801a4a <fd2sockid>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 1b                	js     801b1b <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	ff 75 10             	pushl  0x10(%ebp)
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	50                   	push   %eax
  801b0a:	e8 0e 01 00 00       	call   801c1d <nsipc_accept>
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 05                	js     801b1b <accept+0x2d>
	return alloc_sockfd(r);
  801b16:	e8 5f ff ff ff       	call   801a7a <alloc_sockfd>
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <bind>:
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	e8 1f ff ff ff       	call   801a4a <fd2sockid>
  801b2b:	85 c0                	test   %eax,%eax
  801b2d:	78 12                	js     801b41 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b2f:	83 ec 04             	sub    $0x4,%esp
  801b32:	ff 75 10             	pushl  0x10(%ebp)
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	50                   	push   %eax
  801b39:	e8 2f 01 00 00       	call   801c6d <nsipc_bind>
  801b3e:	83 c4 10             	add    $0x10,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <shutdown>:
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	e8 f9 fe ff ff       	call   801a4a <fd2sockid>
  801b51:	85 c0                	test   %eax,%eax
  801b53:	78 0f                	js     801b64 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	50                   	push   %eax
  801b5c:	e8 41 01 00 00       	call   801ca2 <nsipc_shutdown>
  801b61:	83 c4 10             	add    $0x10,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <connect>:
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	e8 d6 fe ff ff       	call   801a4a <fd2sockid>
  801b74:	85 c0                	test   %eax,%eax
  801b76:	78 12                	js     801b8a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	ff 75 10             	pushl  0x10(%ebp)
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	e8 57 01 00 00       	call   801cde <nsipc_connect>
  801b87:	83 c4 10             	add    $0x10,%esp
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <listen>:
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	e8 b0 fe ff ff       	call   801a4a <fd2sockid>
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 0f                	js     801bad <listen+0x21>
	return nsipc_listen(r, backlog);
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	e8 69 01 00 00       	call   801d13 <nsipc_listen>
  801baa:	83 c4 10             	add    $0x10,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <socket>:

int
socket(int domain, int type, int protocol)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bb5:	ff 75 10             	pushl  0x10(%ebp)
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	e8 3c 02 00 00       	call   801dff <nsipc_socket>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 05                	js     801bcf <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bca:	e8 ab fe ff ff       	call   801a7a <alloc_sockfd>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 04             	sub    $0x4,%esp
  801bd8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bda:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801be1:	74 26                	je     801c09 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801be3:	6a 07                	push   $0x7
  801be5:	68 00 60 80 00       	push   $0x806000
  801bea:	53                   	push   %ebx
  801beb:	ff 35 04 40 80 00    	pushl  0x804004
  801bf1:	e8 ef 07 00 00       	call   8023e5 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf6:	83 c4 0c             	add    $0xc,%esp
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	e8 7a 07 00 00       	call   80237e <ipc_recv>
}
  801c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	6a 02                	push   $0x2
  801c0e:	e8 26 08 00 00       	call   802439 <ipc_find_env>
  801c13:	a3 04 40 80 00       	mov    %eax,0x804004
  801c18:	83 c4 10             	add    $0x10,%esp
  801c1b:	eb c6                	jmp    801be3 <nsipc+0x12>

00801c1d <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	56                   	push   %esi
  801c21:	53                   	push   %ebx
  801c22:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c2d:	8b 06                	mov    (%esi),%eax
  801c2f:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c34:	b8 01 00 00 00       	mov    $0x1,%eax
  801c39:	e8 93 ff ff ff       	call   801bd1 <nsipc>
  801c3e:	89 c3                	mov    %eax,%ebx
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 20                	js     801c64 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	ff 35 10 60 80 00    	pushl  0x806010
  801c4d:	68 00 60 80 00       	push   $0x806000
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	e8 60 ee ff ff       	call   800aba <memmove>
		*addrlen = ret->ret_addrlen;
  801c5a:	a1 10 60 80 00       	mov    0x806010,%eax
  801c5f:	89 06                	mov    %eax,(%esi)
  801c61:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c64:	89 d8                	mov    %ebx,%eax
  801c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c69:	5b                   	pop    %ebx
  801c6a:	5e                   	pop    %esi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	83 ec 08             	sub    $0x8,%esp
  801c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c7f:	53                   	push   %ebx
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	68 04 60 80 00       	push   $0x806004
  801c88:	e8 2d ee ff ff       	call   800aba <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c8d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c93:	b8 02 00 00 00       	mov    $0x2,%eax
  801c98:	e8 34 ff ff ff       	call   801bd1 <nsipc>
}
  801c9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb3:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cb8:	b8 03 00 00 00       	mov    $0x3,%eax
  801cbd:	e8 0f ff ff ff       	call   801bd1 <nsipc>
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <nsipc_close>:

int
nsipc_close(int s)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cd2:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd7:	e8 f5 fe ff ff       	call   801bd1 <nsipc>
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	53                   	push   %ebx
  801ce2:	83 ec 08             	sub    $0x8,%esp
  801ce5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cf0:	53                   	push   %ebx
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	68 04 60 80 00       	push   $0x806004
  801cf9:	e8 bc ed ff ff       	call   800aba <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cfe:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d04:	b8 05 00 00 00       	mov    $0x5,%eax
  801d09:	e8 c3 fe ff ff       	call   801bd1 <nsipc>
}
  801d0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d29:	b8 06 00 00 00       	mov    $0x6,%eax
  801d2e:	e8 9e fe ff ff       	call   801bd1 <nsipc>
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	56                   	push   %esi
  801d39:	53                   	push   %ebx
  801d3a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d45:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d4b:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d53:	b8 07 00 00 00       	mov    $0x7,%eax
  801d58:	e8 74 fe ff ff       	call   801bd1 <nsipc>
  801d5d:	89 c3                	mov    %eax,%ebx
  801d5f:	85 c0                	test   %eax,%eax
  801d61:	78 1f                	js     801d82 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d63:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d68:	7f 21                	jg     801d8b <nsipc_recv+0x56>
  801d6a:	39 c6                	cmp    %eax,%esi
  801d6c:	7c 1d                	jl     801d8b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d6e:	83 ec 04             	sub    $0x4,%esp
  801d71:	50                   	push   %eax
  801d72:	68 00 60 80 00       	push   $0x806000
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	e8 3b ed ff ff       	call   800aba <memmove>
  801d7f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d82:	89 d8                	mov    %ebx,%eax
  801d84:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d8b:	68 eb 2c 80 00       	push   $0x802ceb
  801d90:	68 b3 2c 80 00       	push   $0x802cb3
  801d95:	6a 62                	push   $0x62
  801d97:	68 00 2d 80 00       	push   $0x802d00
  801d9c:	e8 91 e4 ff ff       	call   800232 <_panic>

00801da1 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	53                   	push   %ebx
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801db3:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801db9:	7f 2e                	jg     801de9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	53                   	push   %ebx
  801dbf:	ff 75 0c             	pushl  0xc(%ebp)
  801dc2:	68 0c 60 80 00       	push   $0x80600c
  801dc7:	e8 ee ec ff ff       	call   800aba <memmove>
	nsipcbuf.send.req_size = size;
  801dcc:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dd2:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dda:	b8 08 00 00 00       	mov    $0x8,%eax
  801ddf:	e8 ed fd ff ff       	call   801bd1 <nsipc>
}
  801de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de7:	c9                   	leave  
  801de8:	c3                   	ret    
	assert(size < 1600);
  801de9:	68 0c 2d 80 00       	push   $0x802d0c
  801dee:	68 b3 2c 80 00       	push   $0x802cb3
  801df3:	6a 6d                	push   $0x6d
  801df5:	68 00 2d 80 00       	push   $0x802d00
  801dfa:	e8 33 e4 ff ff       	call   800232 <_panic>

00801dff <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e05:	8b 45 08             	mov    0x8(%ebp),%eax
  801e08:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e15:	8b 45 10             	mov    0x10(%ebp),%eax
  801e18:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e1d:	b8 09 00 00 00       	mov    $0x9,%eax
  801e22:	e8 aa fd ff ff       	call   801bd1 <nsipc>
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	56                   	push   %esi
  801e2d:	53                   	push   %ebx
  801e2e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	e8 a7 f3 ff ff       	call   8011e3 <fd2data>
  801e3c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e3e:	83 c4 08             	add    $0x8,%esp
  801e41:	68 18 2d 80 00       	push   $0x802d18
  801e46:	53                   	push   %ebx
  801e47:	e8 e0 ea ff ff       	call   80092c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e4c:	8b 46 04             	mov    0x4(%esi),%eax
  801e4f:	2b 06                	sub    (%esi),%eax
  801e51:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e57:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e5e:	00 00 00 
	stat->st_dev = &devpipe;
  801e61:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e68:	30 80 00 
	return 0;
}
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5d                   	pop    %ebp
  801e76:	c3                   	ret    

00801e77 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	53                   	push   %ebx
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e81:	53                   	push   %ebx
  801e82:	6a 00                	push   $0x0
  801e84:	e8 21 ef ff ff       	call   800daa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e89:	89 1c 24             	mov    %ebx,(%esp)
  801e8c:	e8 52 f3 ff ff       	call   8011e3 <fd2data>
  801e91:	83 c4 08             	add    $0x8,%esp
  801e94:	50                   	push   %eax
  801e95:	6a 00                	push   $0x0
  801e97:	e8 0e ef ff ff       	call   800daa <sys_page_unmap>
}
  801e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <_pipeisclosed>:
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	57                   	push   %edi
  801ea5:	56                   	push   %esi
  801ea6:	53                   	push   %ebx
  801ea7:	83 ec 1c             	sub    $0x1c,%esp
  801eaa:	89 c7                	mov    %eax,%edi
  801eac:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801eae:	a1 08 40 80 00       	mov    0x804008,%eax
  801eb3:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eb6:	83 ec 0c             	sub    $0xc,%esp
  801eb9:	57                   	push   %edi
  801eba:	e8 b3 05 00 00       	call   802472 <pageref>
  801ebf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ec2:	89 34 24             	mov    %esi,(%esp)
  801ec5:	e8 a8 05 00 00       	call   802472 <pageref>
		nn = thisenv->env_runs;
  801eca:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ed0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	39 cb                	cmp    %ecx,%ebx
  801ed8:	74 1b                	je     801ef5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801eda:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801edd:	75 cf                	jne    801eae <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801edf:	8b 42 58             	mov    0x58(%edx),%eax
  801ee2:	6a 01                	push   $0x1
  801ee4:	50                   	push   %eax
  801ee5:	53                   	push   %ebx
  801ee6:	68 1f 2d 80 00       	push   $0x802d1f
  801eeb:	e8 1d e4 ff ff       	call   80030d <cprintf>
  801ef0:	83 c4 10             	add    $0x10,%esp
  801ef3:	eb b9                	jmp    801eae <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ef5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef8:	0f 94 c0             	sete   %al
  801efb:	0f b6 c0             	movzbl %al,%eax
}
  801efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f01:	5b                   	pop    %ebx
  801f02:	5e                   	pop    %esi
  801f03:	5f                   	pop    %edi
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    

00801f06 <devpipe_write>:
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	57                   	push   %edi
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 28             	sub    $0x28,%esp
  801f0f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f12:	56                   	push   %esi
  801f13:	e8 cb f2 ff ff       	call   8011e3 <fd2data>
  801f18:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	bf 00 00 00 00       	mov    $0x0,%edi
  801f22:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f25:	74 4f                	je     801f76 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f27:	8b 43 04             	mov    0x4(%ebx),%eax
  801f2a:	8b 0b                	mov    (%ebx),%ecx
  801f2c:	8d 51 20             	lea    0x20(%ecx),%edx
  801f2f:	39 d0                	cmp    %edx,%eax
  801f31:	72 14                	jb     801f47 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f33:	89 da                	mov    %ebx,%edx
  801f35:	89 f0                	mov    %esi,%eax
  801f37:	e8 65 ff ff ff       	call   801ea1 <_pipeisclosed>
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	75 3a                	jne    801f7a <devpipe_write+0x74>
			sys_yield();
  801f40:	e8 c1 ed ff ff       	call   800d06 <sys_yield>
  801f45:	eb e0                	jmp    801f27 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f4a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f4e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f51:	89 c2                	mov    %eax,%edx
  801f53:	c1 fa 1f             	sar    $0x1f,%edx
  801f56:	89 d1                	mov    %edx,%ecx
  801f58:	c1 e9 1b             	shr    $0x1b,%ecx
  801f5b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f5e:	83 e2 1f             	and    $0x1f,%edx
  801f61:	29 ca                	sub    %ecx,%edx
  801f63:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f67:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f6b:	83 c0 01             	add    $0x1,%eax
  801f6e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f71:	83 c7 01             	add    $0x1,%edi
  801f74:	eb ac                	jmp    801f22 <devpipe_write+0x1c>
	return i;
  801f76:	89 f8                	mov    %edi,%eax
  801f78:	eb 05                	jmp    801f7f <devpipe_write+0x79>
				return 0;
  801f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f82:	5b                   	pop    %ebx
  801f83:	5e                   	pop    %esi
  801f84:	5f                   	pop    %edi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    

00801f87 <devpipe_read>:
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	57                   	push   %edi
  801f8b:	56                   	push   %esi
  801f8c:	53                   	push   %ebx
  801f8d:	83 ec 18             	sub    $0x18,%esp
  801f90:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f93:	57                   	push   %edi
  801f94:	e8 4a f2 ff ff       	call   8011e3 <fd2data>
  801f99:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f9b:	83 c4 10             	add    $0x10,%esp
  801f9e:	be 00 00 00 00       	mov    $0x0,%esi
  801fa3:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa6:	74 47                	je     801fef <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801fa8:	8b 03                	mov    (%ebx),%eax
  801faa:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fad:	75 22                	jne    801fd1 <devpipe_read+0x4a>
			if (i > 0)
  801faf:	85 f6                	test   %esi,%esi
  801fb1:	75 14                	jne    801fc7 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801fb3:	89 da                	mov    %ebx,%edx
  801fb5:	89 f8                	mov    %edi,%eax
  801fb7:	e8 e5 fe ff ff       	call   801ea1 <_pipeisclosed>
  801fbc:	85 c0                	test   %eax,%eax
  801fbe:	75 33                	jne    801ff3 <devpipe_read+0x6c>
			sys_yield();
  801fc0:	e8 41 ed ff ff       	call   800d06 <sys_yield>
  801fc5:	eb e1                	jmp    801fa8 <devpipe_read+0x21>
				return i;
  801fc7:	89 f0                	mov    %esi,%eax
}
  801fc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5e                   	pop    %esi
  801fce:	5f                   	pop    %edi
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fd1:	99                   	cltd   
  801fd2:	c1 ea 1b             	shr    $0x1b,%edx
  801fd5:	01 d0                	add    %edx,%eax
  801fd7:	83 e0 1f             	and    $0x1f,%eax
  801fda:	29 d0                	sub    %edx,%eax
  801fdc:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fe4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fea:	83 c6 01             	add    $0x1,%esi
  801fed:	eb b4                	jmp    801fa3 <devpipe_read+0x1c>
	return i;
  801fef:	89 f0                	mov    %esi,%eax
  801ff1:	eb d6                	jmp    801fc9 <devpipe_read+0x42>
				return 0;
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff8:	eb cf                	jmp    801fc9 <devpipe_read+0x42>

00801ffa <pipe>:
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	56                   	push   %esi
  801ffe:	53                   	push   %ebx
  801fff:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802002:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802005:	50                   	push   %eax
  802006:	e8 ef f1 ff ff       	call   8011fa <fd_alloc>
  80200b:	89 c3                	mov    %eax,%ebx
  80200d:	83 c4 10             	add    $0x10,%esp
  802010:	85 c0                	test   %eax,%eax
  802012:	78 5b                	js     80206f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802014:	83 ec 04             	sub    $0x4,%esp
  802017:	68 07 04 00 00       	push   $0x407
  80201c:	ff 75 f4             	pushl  -0xc(%ebp)
  80201f:	6a 00                	push   $0x0
  802021:	e8 ff ec ff ff       	call   800d25 <sys_page_alloc>
  802026:	89 c3                	mov    %eax,%ebx
  802028:	83 c4 10             	add    $0x10,%esp
  80202b:	85 c0                	test   %eax,%eax
  80202d:	78 40                	js     80206f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802035:	50                   	push   %eax
  802036:	e8 bf f1 ff ff       	call   8011fa <fd_alloc>
  80203b:	89 c3                	mov    %eax,%ebx
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	85 c0                	test   %eax,%eax
  802042:	78 1b                	js     80205f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802044:	83 ec 04             	sub    $0x4,%esp
  802047:	68 07 04 00 00       	push   $0x407
  80204c:	ff 75 f0             	pushl  -0x10(%ebp)
  80204f:	6a 00                	push   $0x0
  802051:	e8 cf ec ff ff       	call   800d25 <sys_page_alloc>
  802056:	89 c3                	mov    %eax,%ebx
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	85 c0                	test   %eax,%eax
  80205d:	79 19                	jns    802078 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80205f:	83 ec 08             	sub    $0x8,%esp
  802062:	ff 75 f4             	pushl  -0xc(%ebp)
  802065:	6a 00                	push   $0x0
  802067:	e8 3e ed ff ff       	call   800daa <sys_page_unmap>
  80206c:	83 c4 10             	add    $0x10,%esp
}
  80206f:	89 d8                	mov    %ebx,%eax
  802071:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802074:	5b                   	pop    %ebx
  802075:	5e                   	pop    %esi
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    
	va = fd2data(fd0);
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	ff 75 f4             	pushl  -0xc(%ebp)
  80207e:	e8 60 f1 ff ff       	call   8011e3 <fd2data>
  802083:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802085:	83 c4 0c             	add    $0xc,%esp
  802088:	68 07 04 00 00       	push   $0x407
  80208d:	50                   	push   %eax
  80208e:	6a 00                	push   $0x0
  802090:	e8 90 ec ff ff       	call   800d25 <sys_page_alloc>
  802095:	89 c3                	mov    %eax,%ebx
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	0f 88 8c 00 00 00    	js     80212e <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a8:	e8 36 f1 ff ff       	call   8011e3 <fd2data>
  8020ad:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020b4:	50                   	push   %eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	56                   	push   %esi
  8020b8:	6a 00                	push   $0x0
  8020ba:	e8 a9 ec ff ff       	call   800d68 <sys_page_map>
  8020bf:	89 c3                	mov    %eax,%ebx
  8020c1:	83 c4 20             	add    $0x20,%esp
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	78 58                	js     802120 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020d1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020e6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f8:	e8 d6 f0 ff ff       	call   8011d3 <fd2num>
  8020fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802100:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802102:	83 c4 04             	add    $0x4,%esp
  802105:	ff 75 f0             	pushl  -0x10(%ebp)
  802108:	e8 c6 f0 ff ff       	call   8011d3 <fd2num>
  80210d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802110:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	bb 00 00 00 00       	mov    $0x0,%ebx
  80211b:	e9 4f ff ff ff       	jmp    80206f <pipe+0x75>
	sys_page_unmap(0, va);
  802120:	83 ec 08             	sub    $0x8,%esp
  802123:	56                   	push   %esi
  802124:	6a 00                	push   $0x0
  802126:	e8 7f ec ff ff       	call   800daa <sys_page_unmap>
  80212b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80212e:	83 ec 08             	sub    $0x8,%esp
  802131:	ff 75 f0             	pushl  -0x10(%ebp)
  802134:	6a 00                	push   $0x0
  802136:	e8 6f ec ff ff       	call   800daa <sys_page_unmap>
  80213b:	83 c4 10             	add    $0x10,%esp
  80213e:	e9 1c ff ff ff       	jmp    80205f <pipe+0x65>

00802143 <pipeisclosed>:
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802149:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214c:	50                   	push   %eax
  80214d:	ff 75 08             	pushl  0x8(%ebp)
  802150:	e8 f4 f0 ff ff       	call   801249 <fd_lookup>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 18                	js     802174 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80215c:	83 ec 0c             	sub    $0xc,%esp
  80215f:	ff 75 f4             	pushl  -0xc(%ebp)
  802162:	e8 7c f0 ff ff       	call   8011e3 <fd2data>
	return _pipeisclosed(fd, p);
  802167:	89 c2                	mov    %eax,%edx
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	e8 30 fd ff ff       	call   801ea1 <_pipeisclosed>
  802171:	83 c4 10             	add    $0x10,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802179:	b8 00 00 00 00       	mov    $0x0,%eax
  80217e:	5d                   	pop    %ebp
  80217f:	c3                   	ret    

00802180 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802186:	68 37 2d 80 00       	push   $0x802d37
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	e8 99 e7 ff ff       	call   80092c <strcpy>
	return 0;
}
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <devcons_write>:
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	57                   	push   %edi
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021a6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021b1:	eb 2f                	jmp    8021e2 <devcons_write+0x48>
		m = n - tot;
  8021b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021b6:	29 f3                	sub    %esi,%ebx
  8021b8:	83 fb 7f             	cmp    $0x7f,%ebx
  8021bb:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8021c0:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	53                   	push   %ebx
  8021c7:	89 f0                	mov    %esi,%eax
  8021c9:	03 45 0c             	add    0xc(%ebp),%eax
  8021cc:	50                   	push   %eax
  8021cd:	57                   	push   %edi
  8021ce:	e8 e7 e8 ff ff       	call   800aba <memmove>
		sys_cputs(buf, m);
  8021d3:	83 c4 08             	add    $0x8,%esp
  8021d6:	53                   	push   %ebx
  8021d7:	57                   	push   %edi
  8021d8:	e8 8c ea ff ff       	call   800c69 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021dd:	01 de                	add    %ebx,%esi
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021e5:	72 cc                	jb     8021b3 <devcons_write+0x19>
}
  8021e7:	89 f0                	mov    %esi,%eax
  8021e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021ec:	5b                   	pop    %ebx
  8021ed:	5e                   	pop    %esi
  8021ee:	5f                   	pop    %edi
  8021ef:	5d                   	pop    %ebp
  8021f0:	c3                   	ret    

008021f1 <devcons_read>:
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 08             	sub    $0x8,%esp
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802200:	75 07                	jne    802209 <devcons_read+0x18>
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    
		sys_yield();
  802204:	e8 fd ea ff ff       	call   800d06 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802209:	e8 79 ea ff ff       	call   800c87 <sys_cgetc>
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 f2                	je     802204 <devcons_read+0x13>
	if (c < 0)
  802212:	85 c0                	test   %eax,%eax
  802214:	78 ec                	js     802202 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802216:	83 f8 04             	cmp    $0x4,%eax
  802219:	74 0c                	je     802227 <devcons_read+0x36>
	*(char*)vbuf = c;
  80221b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221e:	88 02                	mov    %al,(%edx)
	return 1;
  802220:	b8 01 00 00 00       	mov    $0x1,%eax
  802225:	eb db                	jmp    802202 <devcons_read+0x11>
		return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
  80222c:	eb d4                	jmp    802202 <devcons_read+0x11>

0080222e <cputchar>:
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80223a:	6a 01                	push   $0x1
  80223c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223f:	50                   	push   %eax
  802240:	e8 24 ea ff ff       	call   800c69 <sys_cputs>
}
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <getchar>:
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802250:	6a 01                	push   $0x1
  802252:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802255:	50                   	push   %eax
  802256:	6a 00                	push   $0x0
  802258:	e8 5d f2 ff ff       	call   8014ba <read>
	if (r < 0)
  80225d:	83 c4 10             	add    $0x10,%esp
  802260:	85 c0                	test   %eax,%eax
  802262:	78 08                	js     80226c <getchar+0x22>
	if (r < 1)
  802264:	85 c0                	test   %eax,%eax
  802266:	7e 06                	jle    80226e <getchar+0x24>
	return c;
  802268:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    
		return -E_EOF;
  80226e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802273:	eb f7                	jmp    80226c <getchar+0x22>

00802275 <iscons>:
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80227b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227e:	50                   	push   %eax
  80227f:	ff 75 08             	pushl  0x8(%ebp)
  802282:	e8 c2 ef ff ff       	call   801249 <fd_lookup>
  802287:	83 c4 10             	add    $0x10,%esp
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 11                	js     80229f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802297:	39 10                	cmp    %edx,(%eax)
  802299:	0f 94 c0             	sete   %al
  80229c:	0f b6 c0             	movzbl %al,%eax
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <opencons>:
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022aa:	50                   	push   %eax
  8022ab:	e8 4a ef ff ff       	call   8011fa <fd_alloc>
  8022b0:	83 c4 10             	add    $0x10,%esp
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	78 3a                	js     8022f1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	68 07 04 00 00       	push   $0x407
  8022bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8022c2:	6a 00                	push   $0x0
  8022c4:	e8 5c ea ff ff       	call   800d25 <sys_page_alloc>
  8022c9:	83 c4 10             	add    $0x10,%esp
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	78 21                	js     8022f1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022d9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	50                   	push   %eax
  8022e9:	e8 e5 ee ff ff       	call   8011d3 <fd2num>
  8022ee:	83 c4 10             	add    $0x10,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  8022f9:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802300:	74 0a                	je     80230c <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  80230c:	a1 08 40 80 00       	mov    0x804008,%eax
  802311:	8b 40 48             	mov    0x48(%eax),%eax
  802314:	83 ec 04             	sub    $0x4,%esp
  802317:	6a 07                	push   $0x7
  802319:	68 00 f0 bf ee       	push   $0xeebff000
  80231e:	50                   	push   %eax
  80231f:	e8 01 ea ff ff       	call   800d25 <sys_page_alloc>
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	85 c0                	test   %eax,%eax
  802329:	78 1b                	js     802346 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80232b:	a1 08 40 80 00       	mov    0x804008,%eax
  802330:	8b 40 48             	mov    0x48(%eax),%eax
  802333:	83 ec 08             	sub    $0x8,%esp
  802336:	68 58 23 80 00       	push   $0x802358
  80233b:	50                   	push   %eax
  80233c:	e8 2f eb ff ff       	call   800e70 <sys_env_set_pgfault_upcall>
  802341:	83 c4 10             	add    $0x10,%esp
  802344:	eb bc                	jmp    802302 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802346:	50                   	push   %eax
  802347:	68 43 2d 80 00       	push   $0x802d43
  80234c:	6a 22                	push   $0x22
  80234e:	68 5b 2d 80 00       	push   $0x802d5b
  802353:	e8 da de ff ff       	call   800232 <_panic>

00802358 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802358:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802359:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80235e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802360:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802363:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802367:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  80236a:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  80236e:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802372:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802374:	83 c4 08             	add    $0x8,%esp
	popal
  802377:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802378:	83 c4 04             	add    $0x4,%esp
	popfl
  80237b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80237c:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80237d:	c3                   	ret    

0080237e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	56                   	push   %esi
  802382:	53                   	push   %ebx
  802383:	8b 75 08             	mov    0x8(%ebp),%esi
  802386:	8b 45 0c             	mov    0xc(%ebp),%eax
  802389:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80238c:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80238e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802393:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	50                   	push   %eax
  80239a:	e8 36 eb ff ff       	call   800ed5 <sys_ipc_recv>
	if (from_env_store)
  80239f:	83 c4 10             	add    $0x10,%esp
  8023a2:	85 f6                	test   %esi,%esi
  8023a4:	74 14                	je     8023ba <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8023a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	78 09                	js     8023b8 <ipc_recv+0x3a>
  8023af:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8023b5:	8b 52 74             	mov    0x74(%edx),%edx
  8023b8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8023ba:	85 db                	test   %ebx,%ebx
  8023bc:	74 14                	je     8023d2 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8023be:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	78 09                	js     8023d0 <ipc_recv+0x52>
  8023c7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8023cd:	8b 52 78             	mov    0x78(%edx),%edx
  8023d0:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	78 08                	js     8023de <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8023d6:	a1 08 40 80 00       	mov    0x804008,%eax
  8023db:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8023de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5d                   	pop    %ebp
  8023e4:	c3                   	ret    

008023e5 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	57                   	push   %edi
  8023e9:	56                   	push   %esi
  8023ea:	53                   	push   %ebx
  8023eb:	83 ec 0c             	sub    $0xc,%esp
  8023ee:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023f7:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8023f9:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8023fe:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802401:	ff 75 14             	pushl  0x14(%ebp)
  802404:	53                   	push   %ebx
  802405:	56                   	push   %esi
  802406:	57                   	push   %edi
  802407:	e8 a6 ea ff ff       	call   800eb2 <sys_ipc_try_send>
		if (ret == 0)
  80240c:	83 c4 10             	add    $0x10,%esp
  80240f:	85 c0                	test   %eax,%eax
  802411:	74 1e                	je     802431 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802413:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802416:	75 07                	jne    80241f <ipc_send+0x3a>
			sys_yield();
  802418:	e8 e9 e8 ff ff       	call   800d06 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80241d:	eb e2                	jmp    802401 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80241f:	50                   	push   %eax
  802420:	68 69 2d 80 00       	push   $0x802d69
  802425:	6a 3d                	push   $0x3d
  802427:	68 7d 2d 80 00       	push   $0x802d7d
  80242c:	e8 01 de ff ff       	call   800232 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802431:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802434:	5b                   	pop    %ebx
  802435:	5e                   	pop    %esi
  802436:	5f                   	pop    %edi
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802444:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802447:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80244d:	8b 52 50             	mov    0x50(%edx),%edx
  802450:	39 ca                	cmp    %ecx,%edx
  802452:	74 11                	je     802465 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802454:	83 c0 01             	add    $0x1,%eax
  802457:	3d 00 04 00 00       	cmp    $0x400,%eax
  80245c:	75 e6                	jne    802444 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
  802463:	eb 0b                	jmp    802470 <ipc_find_env+0x37>
			return envs[i].env_id;
  802465:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802468:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80246d:	8b 40 48             	mov    0x48(%eax),%eax
}
  802470:	5d                   	pop    %ebp
  802471:	c3                   	ret    

00802472 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802478:	89 d0                	mov    %edx,%eax
  80247a:	c1 e8 16             	shr    $0x16,%eax
  80247d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802489:	f6 c1 01             	test   $0x1,%cl
  80248c:	74 1d                	je     8024ab <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80248e:	c1 ea 0c             	shr    $0xc,%edx
  802491:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802498:	f6 c2 01             	test   $0x1,%dl
  80249b:	74 0e                	je     8024ab <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80249d:	c1 ea 0c             	shr    $0xc,%edx
  8024a0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024a7:	ef 
  8024a8:	0f b7 c0             	movzwl %ax,%eax
}
  8024ab:	5d                   	pop    %ebp
  8024ac:	c3                   	ret    
  8024ad:	66 90                	xchg   %ax,%ax
  8024af:	90                   	nop

008024b0 <__udivdi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024c7:	85 d2                	test   %edx,%edx
  8024c9:	75 35                	jne    802500 <__udivdi3+0x50>
  8024cb:	39 f3                	cmp    %esi,%ebx
  8024cd:	0f 87 bd 00 00 00    	ja     802590 <__udivdi3+0xe0>
  8024d3:	85 db                	test   %ebx,%ebx
  8024d5:	89 d9                	mov    %ebx,%ecx
  8024d7:	75 0b                	jne    8024e4 <__udivdi3+0x34>
  8024d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024de:	31 d2                	xor    %edx,%edx
  8024e0:	f7 f3                	div    %ebx
  8024e2:	89 c1                	mov    %eax,%ecx
  8024e4:	31 d2                	xor    %edx,%edx
  8024e6:	89 f0                	mov    %esi,%eax
  8024e8:	f7 f1                	div    %ecx
  8024ea:	89 c6                	mov    %eax,%esi
  8024ec:	89 e8                	mov    %ebp,%eax
  8024ee:	89 f7                	mov    %esi,%edi
  8024f0:	f7 f1                	div    %ecx
  8024f2:	89 fa                	mov    %edi,%edx
  8024f4:	83 c4 1c             	add    $0x1c,%esp
  8024f7:	5b                   	pop    %ebx
  8024f8:	5e                   	pop    %esi
  8024f9:	5f                   	pop    %edi
  8024fa:	5d                   	pop    %ebp
  8024fb:	c3                   	ret    
  8024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802500:	39 f2                	cmp    %esi,%edx
  802502:	77 7c                	ja     802580 <__udivdi3+0xd0>
  802504:	0f bd fa             	bsr    %edx,%edi
  802507:	83 f7 1f             	xor    $0x1f,%edi
  80250a:	0f 84 98 00 00 00    	je     8025a8 <__udivdi3+0xf8>
  802510:	89 f9                	mov    %edi,%ecx
  802512:	b8 20 00 00 00       	mov    $0x20,%eax
  802517:	29 f8                	sub    %edi,%eax
  802519:	d3 e2                	shl    %cl,%edx
  80251b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80251f:	89 c1                	mov    %eax,%ecx
  802521:	89 da                	mov    %ebx,%edx
  802523:	d3 ea                	shr    %cl,%edx
  802525:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802529:	09 d1                	or     %edx,%ecx
  80252b:	89 f2                	mov    %esi,%edx
  80252d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802531:	89 f9                	mov    %edi,%ecx
  802533:	d3 e3                	shl    %cl,%ebx
  802535:	89 c1                	mov    %eax,%ecx
  802537:	d3 ea                	shr    %cl,%edx
  802539:	89 f9                	mov    %edi,%ecx
  80253b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80253f:	d3 e6                	shl    %cl,%esi
  802541:	89 eb                	mov    %ebp,%ebx
  802543:	89 c1                	mov    %eax,%ecx
  802545:	d3 eb                	shr    %cl,%ebx
  802547:	09 de                	or     %ebx,%esi
  802549:	89 f0                	mov    %esi,%eax
  80254b:	f7 74 24 08          	divl   0x8(%esp)
  80254f:	89 d6                	mov    %edx,%esi
  802551:	89 c3                	mov    %eax,%ebx
  802553:	f7 64 24 0c          	mull   0xc(%esp)
  802557:	39 d6                	cmp    %edx,%esi
  802559:	72 0c                	jb     802567 <__udivdi3+0xb7>
  80255b:	89 f9                	mov    %edi,%ecx
  80255d:	d3 e5                	shl    %cl,%ebp
  80255f:	39 c5                	cmp    %eax,%ebp
  802561:	73 5d                	jae    8025c0 <__udivdi3+0x110>
  802563:	39 d6                	cmp    %edx,%esi
  802565:	75 59                	jne    8025c0 <__udivdi3+0x110>
  802567:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80256a:	31 ff                	xor    %edi,%edi
  80256c:	89 fa                	mov    %edi,%edx
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	8d 76 00             	lea    0x0(%esi),%esi
  802579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802580:	31 ff                	xor    %edi,%edi
  802582:	31 c0                	xor    %eax,%eax
  802584:	89 fa                	mov    %edi,%edx
  802586:	83 c4 1c             	add    $0x1c,%esp
  802589:	5b                   	pop    %ebx
  80258a:	5e                   	pop    %esi
  80258b:	5f                   	pop    %edi
  80258c:	5d                   	pop    %ebp
  80258d:	c3                   	ret    
  80258e:	66 90                	xchg   %ax,%ax
  802590:	31 ff                	xor    %edi,%edi
  802592:	89 e8                	mov    %ebp,%eax
  802594:	89 f2                	mov    %esi,%edx
  802596:	f7 f3                	div    %ebx
  802598:	89 fa                	mov    %edi,%edx
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    
  8025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a8:	39 f2                	cmp    %esi,%edx
  8025aa:	72 06                	jb     8025b2 <__udivdi3+0x102>
  8025ac:	31 c0                	xor    %eax,%eax
  8025ae:	39 eb                	cmp    %ebp,%ebx
  8025b0:	77 d2                	ja     802584 <__udivdi3+0xd4>
  8025b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b7:	eb cb                	jmp    802584 <__udivdi3+0xd4>
  8025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025c0:	89 d8                	mov    %ebx,%eax
  8025c2:	31 ff                	xor    %edi,%edi
  8025c4:	eb be                	jmp    802584 <__udivdi3+0xd4>
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	66 90                	xchg   %ax,%ax
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <__umoddi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	53                   	push   %ebx
  8025d4:	83 ec 1c             	sub    $0x1c,%esp
  8025d7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8025db:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025df:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025e7:	85 ed                	test   %ebp,%ebp
  8025e9:	89 f0                	mov    %esi,%eax
  8025eb:	89 da                	mov    %ebx,%edx
  8025ed:	75 19                	jne    802608 <__umoddi3+0x38>
  8025ef:	39 df                	cmp    %ebx,%edi
  8025f1:	0f 86 b1 00 00 00    	jbe    8026a8 <__umoddi3+0xd8>
  8025f7:	f7 f7                	div    %edi
  8025f9:	89 d0                	mov    %edx,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	83 c4 1c             	add    $0x1c,%esp
  802600:	5b                   	pop    %ebx
  802601:	5e                   	pop    %esi
  802602:	5f                   	pop    %edi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    
  802605:	8d 76 00             	lea    0x0(%esi),%esi
  802608:	39 dd                	cmp    %ebx,%ebp
  80260a:	77 f1                	ja     8025fd <__umoddi3+0x2d>
  80260c:	0f bd cd             	bsr    %ebp,%ecx
  80260f:	83 f1 1f             	xor    $0x1f,%ecx
  802612:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802616:	0f 84 b4 00 00 00    	je     8026d0 <__umoddi3+0x100>
  80261c:	b8 20 00 00 00       	mov    $0x20,%eax
  802621:	89 c2                	mov    %eax,%edx
  802623:	8b 44 24 04          	mov    0x4(%esp),%eax
  802627:	29 c2                	sub    %eax,%edx
  802629:	89 c1                	mov    %eax,%ecx
  80262b:	89 f8                	mov    %edi,%eax
  80262d:	d3 e5                	shl    %cl,%ebp
  80262f:	89 d1                	mov    %edx,%ecx
  802631:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802635:	d3 e8                	shr    %cl,%eax
  802637:	09 c5                	or     %eax,%ebp
  802639:	8b 44 24 04          	mov    0x4(%esp),%eax
  80263d:	89 c1                	mov    %eax,%ecx
  80263f:	d3 e7                	shl    %cl,%edi
  802641:	89 d1                	mov    %edx,%ecx
  802643:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802647:	89 df                	mov    %ebx,%edi
  802649:	d3 ef                	shr    %cl,%edi
  80264b:	89 c1                	mov    %eax,%ecx
  80264d:	89 f0                	mov    %esi,%eax
  80264f:	d3 e3                	shl    %cl,%ebx
  802651:	89 d1                	mov    %edx,%ecx
  802653:	89 fa                	mov    %edi,%edx
  802655:	d3 e8                	shr    %cl,%eax
  802657:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80265c:	09 d8                	or     %ebx,%eax
  80265e:	f7 f5                	div    %ebp
  802660:	d3 e6                	shl    %cl,%esi
  802662:	89 d1                	mov    %edx,%ecx
  802664:	f7 64 24 08          	mull   0x8(%esp)
  802668:	39 d1                	cmp    %edx,%ecx
  80266a:	89 c3                	mov    %eax,%ebx
  80266c:	89 d7                	mov    %edx,%edi
  80266e:	72 06                	jb     802676 <__umoddi3+0xa6>
  802670:	75 0e                	jne    802680 <__umoddi3+0xb0>
  802672:	39 c6                	cmp    %eax,%esi
  802674:	73 0a                	jae    802680 <__umoddi3+0xb0>
  802676:	2b 44 24 08          	sub    0x8(%esp),%eax
  80267a:	19 ea                	sbb    %ebp,%edx
  80267c:	89 d7                	mov    %edx,%edi
  80267e:	89 c3                	mov    %eax,%ebx
  802680:	89 ca                	mov    %ecx,%edx
  802682:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802687:	29 de                	sub    %ebx,%esi
  802689:	19 fa                	sbb    %edi,%edx
  80268b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80268f:	89 d0                	mov    %edx,%eax
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 d9                	mov    %ebx,%ecx
  802695:	d3 ee                	shr    %cl,%esi
  802697:	d3 ea                	shr    %cl,%edx
  802699:	09 f0                	or     %esi,%eax
  80269b:	83 c4 1c             	add    $0x1c,%esp
  80269e:	5b                   	pop    %ebx
  80269f:	5e                   	pop    %esi
  8026a0:	5f                   	pop    %edi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	85 ff                	test   %edi,%edi
  8026aa:	89 f9                	mov    %edi,%ecx
  8026ac:	75 0b                	jne    8026b9 <__umoddi3+0xe9>
  8026ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b3:	31 d2                	xor    %edx,%edx
  8026b5:	f7 f7                	div    %edi
  8026b7:	89 c1                	mov    %eax,%ecx
  8026b9:	89 d8                	mov    %ebx,%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	f7 f1                	div    %ecx
  8026bf:	89 f0                	mov    %esi,%eax
  8026c1:	f7 f1                	div    %ecx
  8026c3:	e9 31 ff ff ff       	jmp    8025f9 <__umoddi3+0x29>
  8026c8:	90                   	nop
  8026c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026d0:	39 dd                	cmp    %ebx,%ebp
  8026d2:	72 08                	jb     8026dc <__umoddi3+0x10c>
  8026d4:	39 f7                	cmp    %esi,%edi
  8026d6:	0f 87 21 ff ff ff    	ja     8025fd <__umoddi3+0x2d>
  8026dc:	89 da                	mov    %ebx,%edx
  8026de:	89 f0                	mov    %esi,%eax
  8026e0:	29 f8                	sub    %edi,%eax
  8026e2:	19 ea                	sbb    %ebp,%edx
  8026e4:	e9 14 ff ff ff       	jmp    8025fd <__umoddi3+0x2d>

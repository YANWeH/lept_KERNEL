
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 bf 01 00 00       	call   8001f0 <libmain>
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
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 20 27 80 00       	push   $0x802720
  800040:	e8 e6 02 00 00       	call   80032b <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 f7 20 00 00       	call   802147 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 5b                	js     8000b2 <umain+0x7f>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 d0 0f 00 00       	call   80102c <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	78 62                	js     8000c4 <umain+0x91>
		panic("fork: %e", r);
	if (r == 0) {
  800062:	85 c0                	test   %eax,%eax
  800064:	74 70                	je     8000d6 <umain+0xa3>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800066:	83 ec 08             	sub    $0x8,%esp
  800069:	56                   	push   %esi
  80006a:	68 7a 27 80 00       	push   $0x80277a
  80006f:	e8 b7 02 00 00       	call   80032b <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800074:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  80007a:	83 c4 08             	add    $0x8,%esp
  80007d:	6b c6 7c             	imul   $0x7c,%esi,%eax
  800080:	c1 f8 02             	sar    $0x2,%eax
  800083:	69 c0 df 7b ef bd    	imul   $0xbdef7bdf,%eax,%eax
  800089:	50                   	push   %eax
  80008a:	68 85 27 80 00       	push   $0x802785
  80008f:	e8 97 02 00 00       	call   80032b <cprintf>
	dup(p[0], 10);
  800094:	83 c4 08             	add    $0x8,%esp
  800097:	6a 0a                	push   $0xa
  800099:	ff 75 f0             	pushl  -0x10(%ebp)
  80009c:	e8 3f 14 00 00       	call   8014e0 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	6b de 7c             	imul   $0x7c,%esi,%ebx
  8000a7:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ad:	e9 92 00 00 00       	jmp    800144 <umain+0x111>
		panic("pipe: %e", r);
  8000b2:	50                   	push   %eax
  8000b3:	68 39 27 80 00       	push   $0x802739
  8000b8:	6a 0d                	push   $0xd
  8000ba:	68 42 27 80 00       	push   $0x802742
  8000bf:	e8 8c 01 00 00       	call   800250 <_panic>
		panic("fork: %e", r);
  8000c4:	50                   	push   %eax
  8000c5:	68 56 27 80 00       	push   $0x802756
  8000ca:	6a 10                	push   $0x10
  8000cc:	68 42 27 80 00       	push   $0x802742
  8000d1:	e8 7a 01 00 00       	call   800250 <_panic>
		close(p[1]);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8000dc:	e8 af 13 00 00       	call   801490 <close>
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	bb c8 00 00 00       	mov    $0xc8,%ebx
  8000e9:	eb 0a                	jmp    8000f5 <umain+0xc2>
			sys_yield();
  8000eb:	e8 34 0c 00 00       	call   800d24 <sys_yield>
		for (i=0; i<max; i++) {
  8000f0:	83 eb 01             	sub    $0x1,%ebx
  8000f3:	74 29                	je     80011e <umain+0xeb>
			if(pipeisclosed(p[0])){
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000fb:	e8 90 21 00 00       	call   802290 <pipeisclosed>
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	85 c0                	test   %eax,%eax
  800105:	74 e4                	je     8000eb <umain+0xb8>
				cprintf("RACE: pipe appears closed\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 5f 27 80 00       	push   $0x80275f
  80010f:	e8 17 02 00 00       	call   80032b <cprintf>
				exit();
  800114:	e8 1d 01 00 00       	call   800236 <exit>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	eb cd                	jmp    8000eb <umain+0xb8>
		ipc_recv(0,0,0);
  80011e:	83 ec 04             	sub    $0x4,%esp
  800121:	6a 00                	push   $0x0
  800123:	6a 00                	push   $0x0
  800125:	6a 00                	push   $0x0
  800127:	e8 c5 10 00 00       	call   8011f1 <ipc_recv>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	e9 32 ff ff ff       	jmp    800066 <umain+0x33>
		dup(p[0], 10);
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	6a 0a                	push   $0xa
  800139:	ff 75 f0             	pushl  -0x10(%ebp)
  80013c:	e8 9f 13 00 00       	call   8014e0 <dup>
  800141:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800144:	8b 53 54             	mov    0x54(%ebx),%edx
  800147:	83 fa 02             	cmp    $0x2,%edx
  80014a:	74 e8                	je     800134 <umain+0x101>

	cprintf("child done with loop\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 90 27 80 00       	push   $0x802790
  800154:	e8 d2 01 00 00       	call   80032b <cprintf>
	if (pipeisclosed(p[0]))
  800159:	83 c4 04             	add    $0x4,%esp
  80015c:	ff 75 f0             	pushl  -0x10(%ebp)
  80015f:	e8 2c 21 00 00       	call   802290 <pipeisclosed>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	85 c0                	test   %eax,%eax
  800169:	75 48                	jne    8001b3 <umain+0x180>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80016b:	83 ec 08             	sub    $0x8,%esp
  80016e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800171:	50                   	push   %eax
  800172:	ff 75 f0             	pushl  -0x10(%ebp)
  800175:	e8 e1 11 00 00       	call   80135b <fd_lookup>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	78 46                	js     8001c7 <umain+0x194>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  800181:	83 ec 0c             	sub    $0xc,%esp
  800184:	ff 75 ec             	pushl  -0x14(%ebp)
  800187:	e8 69 11 00 00       	call   8012f5 <fd2data>
	if (pageref(va) != 3+1)
  80018c:	89 04 24             	mov    %eax,(%esp)
  80018f:	e8 42 19 00 00       	call   801ad6 <pageref>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	83 f8 04             	cmp    $0x4,%eax
  80019a:	74 3d                	je     8001d9 <umain+0x1a6>
		cprintf("\nchild detected race\n");
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 be 27 80 00       	push   $0x8027be
  8001a4:	e8 82 01 00 00       	call   80032b <cprintf>
  8001a9:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001af:	5b                   	pop    %ebx
  8001b0:	5e                   	pop    %esi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001b3:	83 ec 04             	sub    $0x4,%esp
  8001b6:	68 ec 27 80 00       	push   $0x8027ec
  8001bb:	6a 3a                	push   $0x3a
  8001bd:	68 42 27 80 00       	push   $0x802742
  8001c2:	e8 89 00 00 00       	call   800250 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001c7:	50                   	push   %eax
  8001c8:	68 a6 27 80 00       	push   $0x8027a6
  8001cd:	6a 3c                	push   $0x3c
  8001cf:	68 42 27 80 00       	push   $0x802742
  8001d4:	e8 77 00 00 00       	call   800250 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	68 c8 00 00 00       	push   $0xc8
  8001e1:	68 d4 27 80 00       	push   $0x8027d4
  8001e6:	e8 40 01 00 00       	call   80032b <cprintf>
  8001eb:	83 c4 10             	add    $0x10,%esp
}
  8001ee:	eb bc                	jmp    8001ac <umain+0x179>

008001f0 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001fb:	e8 05 0b 00 00       	call   800d05 <sys_getenvid>
  800200:	25 ff 03 00 00       	and    $0x3ff,%eax
  800205:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800212:	85 db                	test   %ebx,%ebx
  800214:	7e 07                	jle    80021d <libmain+0x2d>
		binaryname = argv[0];
  800216:	8b 06                	mov    (%esi),%eax
  800218:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	56                   	push   %esi
  800221:	53                   	push   %ebx
  800222:	e8 0c fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800227:	e8 0a 00 00 00       	call   800236 <exit>
}
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800232:	5b                   	pop    %ebx
  800233:	5e                   	pop    %esi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023c:	e8 7a 12 00 00       	call   8014bb <close_all>
	sys_env_destroy(0);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	6a 00                	push   $0x0
  800246:	e8 79 0a 00 00       	call   800cc4 <sys_env_destroy>
}
  80024b:	83 c4 10             	add    $0x10,%esp
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	56                   	push   %esi
  800254:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800255:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800258:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80025e:	e8 a2 0a 00 00       	call   800d05 <sys_getenvid>
  800263:	83 ec 0c             	sub    $0xc,%esp
  800266:	ff 75 0c             	pushl  0xc(%ebp)
  800269:	ff 75 08             	pushl  0x8(%ebp)
  80026c:	56                   	push   %esi
  80026d:	50                   	push   %eax
  80026e:	68 20 28 80 00       	push   $0x802820
  800273:	e8 b3 00 00 00       	call   80032b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800278:	83 c4 18             	add    $0x18,%esp
  80027b:	53                   	push   %ebx
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	e8 56 00 00 00       	call   8002da <vcprintf>
	cprintf("\n");
  800284:	c7 04 24 37 27 80 00 	movl   $0x802737,(%esp)
  80028b:	e8 9b 00 00 00       	call   80032b <cprintf>
  800290:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800293:	cc                   	int3   
  800294:	eb fd                	jmp    800293 <_panic+0x43>

00800296 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	53                   	push   %ebx
  80029a:	83 ec 04             	sub    $0x4,%esp
  80029d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002a0:	8b 13                	mov    (%ebx),%edx
  8002a2:	8d 42 01             	lea    0x1(%edx),%eax
  8002a5:	89 03                	mov    %eax,(%ebx)
  8002a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002aa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002b3:	74 09                	je     8002be <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	68 ff 00 00 00       	push   $0xff
  8002c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002c9:	50                   	push   %eax
  8002ca:	e8 b8 09 00 00       	call   800c87 <sys_cputs>
		b->idx = 0;
  8002cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002d5:	83 c4 10             	add    $0x10,%esp
  8002d8:	eb db                	jmp    8002b5 <putch+0x1f>

008002da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ea:	00 00 00 
	b.cnt = 0;
  8002ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	68 96 02 80 00       	push   $0x800296
  800309:	e8 1a 01 00 00       	call   800428 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030e:	83 c4 08             	add    $0x8,%esp
  800311:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800317:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031d:	50                   	push   %eax
  80031e:	e8 64 09 00 00       	call   800c87 <sys_cputs>

	return b.cnt;
}
  800323:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800331:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800334:	50                   	push   %eax
  800335:	ff 75 08             	pushl  0x8(%ebp)
  800338:	e8 9d ff ff ff       	call   8002da <vcprintf>
	va_end(ap);

	return cnt;
}
  80033d:	c9                   	leave  
  80033e:	c3                   	ret    

0080033f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
  800342:	57                   	push   %edi
  800343:	56                   	push   %esi
  800344:	53                   	push   %ebx
  800345:	83 ec 1c             	sub    $0x1c,%esp
  800348:	89 c7                	mov    %eax,%edi
  80034a:	89 d6                	mov    %edx,%esi
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800355:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800358:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80035b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800360:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800363:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800366:	39 d3                	cmp    %edx,%ebx
  800368:	72 05                	jb     80036f <printnum+0x30>
  80036a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80036d:	77 7a                	ja     8003e9 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	ff 75 18             	pushl  0x18(%ebp)
  800375:	8b 45 14             	mov    0x14(%ebp),%eax
  800378:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037b:	53                   	push   %ebx
  80037c:	ff 75 10             	pushl  0x10(%ebp)
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 e4             	pushl  -0x1c(%ebp)
  800385:	ff 75 e0             	pushl  -0x20(%ebp)
  800388:	ff 75 dc             	pushl  -0x24(%ebp)
  80038b:	ff 75 d8             	pushl  -0x28(%ebp)
  80038e:	e8 3d 21 00 00       	call   8024d0 <__udivdi3>
  800393:	83 c4 18             	add    $0x18,%esp
  800396:	52                   	push   %edx
  800397:	50                   	push   %eax
  800398:	89 f2                	mov    %esi,%edx
  80039a:	89 f8                	mov    %edi,%eax
  80039c:	e8 9e ff ff ff       	call   80033f <printnum>
  8003a1:	83 c4 20             	add    $0x20,%esp
  8003a4:	eb 13                	jmp    8003b9 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a6:	83 ec 08             	sub    $0x8,%esp
  8003a9:	56                   	push   %esi
  8003aa:	ff 75 18             	pushl  0x18(%ebp)
  8003ad:	ff d7                	call   *%edi
  8003af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003b2:	83 eb 01             	sub    $0x1,%ebx
  8003b5:	85 db                	test   %ebx,%ebx
  8003b7:	7f ed                	jg     8003a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	56                   	push   %esi
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8003c6:	ff 75 dc             	pushl  -0x24(%ebp)
  8003c9:	ff 75 d8             	pushl  -0x28(%ebp)
  8003cc:	e8 1f 22 00 00       	call   8025f0 <__umoddi3>
  8003d1:	83 c4 14             	add    $0x14,%esp
  8003d4:	0f be 80 43 28 80 00 	movsbl 0x802843(%eax),%eax
  8003db:	50                   	push   %eax
  8003dc:	ff d7                	call   *%edi
}
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    
  8003e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ec:	eb c4                	jmp    8003b2 <printnum+0x73>

008003ee <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003f4:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	3b 50 04             	cmp    0x4(%eax),%edx
  8003fd:	73 0a                	jae    800409 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ff:	8d 4a 01             	lea    0x1(%edx),%ecx
  800402:	89 08                	mov    %ecx,(%eax)
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	88 02                	mov    %al,(%edx)
}
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <printfmt>:
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800411:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800414:	50                   	push   %eax
  800415:	ff 75 10             	pushl  0x10(%ebp)
  800418:	ff 75 0c             	pushl  0xc(%ebp)
  80041b:	ff 75 08             	pushl  0x8(%ebp)
  80041e:	e8 05 00 00 00       	call   800428 <vprintfmt>
}
  800423:	83 c4 10             	add    $0x10,%esp
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <vprintfmt>:
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	57                   	push   %edi
  80042c:	56                   	push   %esi
  80042d:	53                   	push   %ebx
  80042e:	83 ec 2c             	sub    $0x2c,%esp
  800431:	8b 75 08             	mov    0x8(%ebp),%esi
  800434:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800437:	8b 7d 10             	mov    0x10(%ebp),%edi
  80043a:	e9 c1 03 00 00       	jmp    800800 <vprintfmt+0x3d8>
		padc = ' ';
  80043f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800443:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80044a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800451:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800458:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80045d:	8d 47 01             	lea    0x1(%edi),%eax
  800460:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800463:	0f b6 17             	movzbl (%edi),%edx
  800466:	8d 42 dd             	lea    -0x23(%edx),%eax
  800469:	3c 55                	cmp    $0x55,%al
  80046b:	0f 87 12 04 00 00    	ja     800883 <vprintfmt+0x45b>
  800471:	0f b6 c0             	movzbl %al,%eax
  800474:	ff 24 85 80 29 80 00 	jmp    *0x802980(,%eax,4)
  80047b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80047e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800482:	eb d9                	jmp    80045d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800484:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800487:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80048b:	eb d0                	jmp    80045d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	0f b6 d2             	movzbl %dl,%edx
  800490:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80049b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80049e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8004a2:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004a5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004a8:	83 f9 09             	cmp    $0x9,%ecx
  8004ab:	77 55                	ja     800502 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8004ad:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8004b0:	eb e9                	jmp    80049b <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8004b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8d 40 04             	lea    0x4(%eax),%eax
  8004c0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004ca:	79 91                	jns    80045d <vprintfmt+0x35>
				width = precision, precision = -1;
  8004cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004d9:	eb 82                	jmp    80045d <vprintfmt+0x35>
  8004db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004de:	85 c0                	test   %eax,%eax
  8004e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e5:	0f 49 d0             	cmovns %eax,%edx
  8004e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ee:	e9 6a ff ff ff       	jmp    80045d <vprintfmt+0x35>
  8004f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004fd:	e9 5b ff ff ff       	jmp    80045d <vprintfmt+0x35>
  800502:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800505:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800508:	eb bc                	jmp    8004c6 <vprintfmt+0x9e>
			lflag++;
  80050a:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800510:	e9 48 ff ff ff       	jmp    80045d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	8d 78 04             	lea    0x4(%eax),%edi
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	53                   	push   %ebx
  80051f:	ff 30                	pushl  (%eax)
  800521:	ff d6                	call   *%esi
			break;
  800523:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800526:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800529:	e9 cf 02 00 00       	jmp    8007fd <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8d 78 04             	lea    0x4(%eax),%edi
  800534:	8b 00                	mov    (%eax),%eax
  800536:	99                   	cltd   
  800537:	31 d0                	xor    %edx,%eax
  800539:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80053b:	83 f8 0f             	cmp    $0xf,%eax
  80053e:	7f 23                	jg     800563 <vprintfmt+0x13b>
  800540:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800547:	85 d2                	test   %edx,%edx
  800549:	74 18                	je     800563 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  80054b:	52                   	push   %edx
  80054c:	68 21 2d 80 00       	push   $0x802d21
  800551:	53                   	push   %ebx
  800552:	56                   	push   %esi
  800553:	e8 b3 fe ff ff       	call   80040b <printfmt>
  800558:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80055b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80055e:	e9 9a 02 00 00       	jmp    8007fd <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800563:	50                   	push   %eax
  800564:	68 5b 28 80 00       	push   $0x80285b
  800569:	53                   	push   %ebx
  80056a:	56                   	push   %esi
  80056b:	e8 9b fe ff ff       	call   80040b <printfmt>
  800570:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800573:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800576:	e9 82 02 00 00       	jmp    8007fd <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	83 c0 04             	add    $0x4,%eax
  800581:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800589:	85 ff                	test   %edi,%edi
  80058b:	b8 54 28 80 00       	mov    $0x802854,%eax
  800590:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800593:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800597:	0f 8e bd 00 00 00    	jle    80065a <vprintfmt+0x232>
  80059d:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005a1:	75 0e                	jne    8005b1 <vprintfmt+0x189>
  8005a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005ac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005af:	eb 6d                	jmp    80061e <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 d0             	pushl  -0x30(%ebp)
  8005b7:	57                   	push   %edi
  8005b8:	e8 6e 03 00 00       	call   80092b <strnlen>
  8005bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c0:	29 c1                	sub    %eax,%ecx
  8005c2:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005c5:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005c8:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005cf:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d2:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	eb 0f                	jmp    8005e5 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005d6:	83 ec 08             	sub    $0x8,%esp
  8005d9:	53                   	push   %ebx
  8005da:	ff 75 e0             	pushl  -0x20(%ebp)
  8005dd:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005df:	83 ef 01             	sub    $0x1,%edi
  8005e2:	83 c4 10             	add    $0x10,%esp
  8005e5:	85 ff                	test   %edi,%edi
  8005e7:	7f ed                	jg     8005d6 <vprintfmt+0x1ae>
  8005e9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005ec:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005ef:	85 c9                	test   %ecx,%ecx
  8005f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f6:	0f 49 c1             	cmovns %ecx,%eax
  8005f9:	29 c1                	sub    %eax,%ecx
  8005fb:	89 75 08             	mov    %esi,0x8(%ebp)
  8005fe:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800601:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800604:	89 cb                	mov    %ecx,%ebx
  800606:	eb 16                	jmp    80061e <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800608:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80060c:	75 31                	jne    80063f <vprintfmt+0x217>
					putch(ch, putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	ff 55 08             	call   *0x8(%ebp)
  800618:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061b:	83 eb 01             	sub    $0x1,%ebx
  80061e:	83 c7 01             	add    $0x1,%edi
  800621:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800625:	0f be c2             	movsbl %dl,%eax
  800628:	85 c0                	test   %eax,%eax
  80062a:	74 59                	je     800685 <vprintfmt+0x25d>
  80062c:	85 f6                	test   %esi,%esi
  80062e:	78 d8                	js     800608 <vprintfmt+0x1e0>
  800630:	83 ee 01             	sub    $0x1,%esi
  800633:	79 d3                	jns    800608 <vprintfmt+0x1e0>
  800635:	89 df                	mov    %ebx,%edi
  800637:	8b 75 08             	mov    0x8(%ebp),%esi
  80063a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80063d:	eb 37                	jmp    800676 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80063f:	0f be d2             	movsbl %dl,%edx
  800642:	83 ea 20             	sub    $0x20,%edx
  800645:	83 fa 5e             	cmp    $0x5e,%edx
  800648:	76 c4                	jbe    80060e <vprintfmt+0x1e6>
					putch('?', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	6a 3f                	push   $0x3f
  800652:	ff 55 08             	call   *0x8(%ebp)
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb c1                	jmp    80061b <vprintfmt+0x1f3>
  80065a:	89 75 08             	mov    %esi,0x8(%ebp)
  80065d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800660:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800663:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800666:	eb b6                	jmp    80061e <vprintfmt+0x1f6>
				putch(' ', putdat);
  800668:	83 ec 08             	sub    $0x8,%esp
  80066b:	53                   	push   %ebx
  80066c:	6a 20                	push   $0x20
  80066e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800670:	83 ef 01             	sub    $0x1,%edi
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	85 ff                	test   %edi,%edi
  800678:	7f ee                	jg     800668 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80067a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
  800680:	e9 78 01 00 00       	jmp    8007fd <vprintfmt+0x3d5>
  800685:	89 df                	mov    %ebx,%edi
  800687:	8b 75 08             	mov    0x8(%ebp),%esi
  80068a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80068d:	eb e7                	jmp    800676 <vprintfmt+0x24e>
	if (lflag >= 2)
  80068f:	83 f9 01             	cmp    $0x1,%ecx
  800692:	7e 3f                	jle    8006d3 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 50 04             	mov    0x4(%eax),%edx
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8d 40 08             	lea    0x8(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8006ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006af:	79 5c                	jns    80070d <vprintfmt+0x2e5>
				putch('-', putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	53                   	push   %ebx
  8006b5:	6a 2d                	push   $0x2d
  8006b7:	ff d6                	call   *%esi
				num = -(long long) num;
  8006b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006bc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bf:	f7 da                	neg    %edx
  8006c1:	83 d1 00             	adc    $0x0,%ecx
  8006c4:	f7 d9                	neg    %ecx
  8006c6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006c9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ce:	e9 10 01 00 00       	jmp    8007e3 <vprintfmt+0x3bb>
	else if (lflag)
  8006d3:	85 c9                	test   %ecx,%ecx
  8006d5:	75 1b                	jne    8006f2 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006df:	89 c1                	mov    %eax,%ecx
  8006e1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006e4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	8d 40 04             	lea    0x4(%eax),%eax
  8006ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f0:	eb b9                	jmp    8006ab <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 c1                	mov    %eax,%ecx
  8006fc:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ff:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800702:	8b 45 14             	mov    0x14(%ebp),%eax
  800705:	8d 40 04             	lea    0x4(%eax),%eax
  800708:	89 45 14             	mov    %eax,0x14(%ebp)
  80070b:	eb 9e                	jmp    8006ab <vprintfmt+0x283>
			num = getint(&ap, lflag);
  80070d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800710:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  800713:	b8 0a 00 00 00       	mov    $0xa,%eax
  800718:	e9 c6 00 00 00       	jmp    8007e3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80071d:	83 f9 01             	cmp    $0x1,%ecx
  800720:	7e 18                	jle    80073a <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8b 10                	mov    (%eax),%edx
  800727:	8b 48 04             	mov    0x4(%eax),%ecx
  80072a:	8d 40 08             	lea    0x8(%eax),%eax
  80072d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800730:	b8 0a 00 00 00       	mov    $0xa,%eax
  800735:	e9 a9 00 00 00       	jmp    8007e3 <vprintfmt+0x3bb>
	else if (lflag)
  80073a:	85 c9                	test   %ecx,%ecx
  80073c:	75 1a                	jne    800758 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 10                	mov    (%eax),%edx
  800743:	b9 00 00 00 00       	mov    $0x0,%ecx
  800748:	8d 40 04             	lea    0x4(%eax),%eax
  80074b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800753:	e9 8b 00 00 00       	jmp    8007e3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800758:	8b 45 14             	mov    0x14(%ebp),%eax
  80075b:	8b 10                	mov    (%eax),%edx
  80075d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800762:	8d 40 04             	lea    0x4(%eax),%eax
  800765:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800768:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076d:	eb 74                	jmp    8007e3 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80076f:	83 f9 01             	cmp    $0x1,%ecx
  800772:	7e 15                	jle    800789 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8b 10                	mov    (%eax),%edx
  800779:	8b 48 04             	mov    0x4(%eax),%ecx
  80077c:	8d 40 08             	lea    0x8(%eax),%eax
  80077f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800782:	b8 08 00 00 00       	mov    $0x8,%eax
  800787:	eb 5a                	jmp    8007e3 <vprintfmt+0x3bb>
	else if (lflag)
  800789:	85 c9                	test   %ecx,%ecx
  80078b:	75 17                	jne    8007a4 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80078d:	8b 45 14             	mov    0x14(%ebp),%eax
  800790:	8b 10                	mov    (%eax),%edx
  800792:	b9 00 00 00 00       	mov    $0x0,%ecx
  800797:	8d 40 04             	lea    0x4(%eax),%eax
  80079a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079d:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a2:	eb 3f                	jmp    8007e3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8b 10                	mov    (%eax),%edx
  8007a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ae:	8d 40 04             	lea    0x4(%eax),%eax
  8007b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b9:	eb 28                	jmp    8007e3 <vprintfmt+0x3bb>
			putch('0', putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	53                   	push   %ebx
  8007bf:	6a 30                	push   $0x30
  8007c1:	ff d6                	call   *%esi
			putch('x', putdat);
  8007c3:	83 c4 08             	add    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	6a 78                	push   $0x78
  8007c9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	8b 10                	mov    (%eax),%edx
  8007d0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007d5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d8:	8d 40 04             	lea    0x4(%eax),%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007de:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007e3:	83 ec 0c             	sub    $0xc,%esp
  8007e6:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007ea:	57                   	push   %edi
  8007eb:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ee:	50                   	push   %eax
  8007ef:	51                   	push   %ecx
  8007f0:	52                   	push   %edx
  8007f1:	89 da                	mov    %ebx,%edx
  8007f3:	89 f0                	mov    %esi,%eax
  8007f5:	e8 45 fb ff ff       	call   80033f <printnum>
			break;
  8007fa:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	83 c7 01             	add    $0x1,%edi
  800803:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800807:	83 f8 25             	cmp    $0x25,%eax
  80080a:	0f 84 2f fc ff ff    	je     80043f <vprintfmt+0x17>
			if (ch == '\0')
  800810:	85 c0                	test   %eax,%eax
  800812:	0f 84 8b 00 00 00    	je     8008a3 <vprintfmt+0x47b>
			putch(ch, putdat);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	53                   	push   %ebx
  80081c:	50                   	push   %eax
  80081d:	ff d6                	call   *%esi
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	eb dc                	jmp    800800 <vprintfmt+0x3d8>
	if (lflag >= 2)
  800824:	83 f9 01             	cmp    $0x1,%ecx
  800827:	7e 15                	jle    80083e <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800829:	8b 45 14             	mov    0x14(%ebp),%eax
  80082c:	8b 10                	mov    (%eax),%edx
  80082e:	8b 48 04             	mov    0x4(%eax),%ecx
  800831:	8d 40 08             	lea    0x8(%eax),%eax
  800834:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800837:	b8 10 00 00 00       	mov    $0x10,%eax
  80083c:	eb a5                	jmp    8007e3 <vprintfmt+0x3bb>
	else if (lflag)
  80083e:	85 c9                	test   %ecx,%ecx
  800840:	75 17                	jne    800859 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	8b 10                	mov    (%eax),%edx
  800847:	b9 00 00 00 00       	mov    $0x0,%ecx
  80084c:	8d 40 04             	lea    0x4(%eax),%eax
  80084f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800852:	b8 10 00 00 00       	mov    $0x10,%eax
  800857:	eb 8a                	jmp    8007e3 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8b 10                	mov    (%eax),%edx
  80085e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800863:	8d 40 04             	lea    0x4(%eax),%eax
  800866:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800869:	b8 10 00 00 00       	mov    $0x10,%eax
  80086e:	e9 70 ff ff ff       	jmp    8007e3 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	53                   	push   %ebx
  800877:	6a 25                	push   $0x25
  800879:	ff d6                	call   *%esi
			break;
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	e9 7a ff ff ff       	jmp    8007fd <vprintfmt+0x3d5>
			putch('%', putdat);
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	53                   	push   %ebx
  800887:	6a 25                	push   $0x25
  800889:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088b:	83 c4 10             	add    $0x10,%esp
  80088e:	89 f8                	mov    %edi,%eax
  800890:	eb 03                	jmp    800895 <vprintfmt+0x46d>
  800892:	83 e8 01             	sub    $0x1,%eax
  800895:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800899:	75 f7                	jne    800892 <vprintfmt+0x46a>
  80089b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089e:	e9 5a ff ff ff       	jmp    8007fd <vprintfmt+0x3d5>
}
  8008a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a6:	5b                   	pop    %ebx
  8008a7:	5e                   	pop    %esi
  8008a8:	5f                   	pop    %edi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	83 ec 18             	sub    $0x18,%esp
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ba:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	74 26                	je     8008f2 <vsnprintf+0x47>
  8008cc:	85 d2                	test   %edx,%edx
  8008ce:	7e 22                	jle    8008f2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d0:	ff 75 14             	pushl  0x14(%ebp)
  8008d3:	ff 75 10             	pushl  0x10(%ebp)
  8008d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d9:	50                   	push   %eax
  8008da:	68 ee 03 80 00       	push   $0x8003ee
  8008df:	e8 44 fb ff ff       	call   800428 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
		return -E_INVAL;
  8008f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f7:	eb f7                	jmp    8008f0 <vsnprintf+0x45>

008008f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ff:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800902:	50                   	push   %eax
  800903:	ff 75 10             	pushl  0x10(%ebp)
  800906:	ff 75 0c             	pushl  0xc(%ebp)
  800909:	ff 75 08             	pushl  0x8(%ebp)
  80090c:	e8 9a ff ff ff       	call   8008ab <vsnprintf>
	va_end(ap);

	return rc;
}
  800911:	c9                   	leave  
  800912:	c3                   	ret    

00800913 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800919:	b8 00 00 00 00       	mov    $0x0,%eax
  80091e:	eb 03                	jmp    800923 <strlen+0x10>
		n++;
  800920:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  800923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800927:	75 f7                	jne    800920 <strlen+0xd>
	return n;
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	eb 03                	jmp    80093e <strnlen+0x13>
		n++;
  80093b:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093e:	39 d0                	cmp    %edx,%eax
  800940:	74 06                	je     800948 <strnlen+0x1d>
  800942:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800946:	75 f3                	jne    80093b <strnlen+0x10>
	return n;
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800954:	89 c2                	mov    %eax,%edx
  800956:	83 c1 01             	add    $0x1,%ecx
  800959:	83 c2 01             	add    $0x1,%edx
  80095c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800960:	88 5a ff             	mov    %bl,-0x1(%edx)
  800963:	84 db                	test   %bl,%bl
  800965:	75 ef                	jne    800956 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	53                   	push   %ebx
  80096e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800971:	53                   	push   %ebx
  800972:	e8 9c ff ff ff       	call   800913 <strlen>
  800977:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	01 d8                	add    %ebx,%eax
  80097f:	50                   	push   %eax
  800980:	e8 c5 ff ff ff       	call   80094a <strcpy>
	return dst;
}
  800985:	89 d8                	mov    %ebx,%eax
  800987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	8b 75 08             	mov    0x8(%ebp),%esi
  800994:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800997:	89 f3                	mov    %esi,%ebx
  800999:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099c:	89 f2                	mov    %esi,%edx
  80099e:	eb 0f                	jmp    8009af <strncpy+0x23>
		*dst++ = *src;
  8009a0:	83 c2 01             	add    $0x1,%edx
  8009a3:	0f b6 01             	movzbl (%ecx),%eax
  8009a6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a9:	80 39 01             	cmpb   $0x1,(%ecx)
  8009ac:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009af:	39 da                	cmp    %ebx,%edx
  8009b1:	75 ed                	jne    8009a0 <strncpy+0x14>
	}
	return ret;
}
  8009b3:	89 f0                	mov    %esi,%eax
  8009b5:	5b                   	pop    %ebx
  8009b6:	5e                   	pop    %esi
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	56                   	push   %esi
  8009bd:	53                   	push   %ebx
  8009be:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009c7:	89 f0                	mov    %esi,%eax
  8009c9:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cd:	85 c9                	test   %ecx,%ecx
  8009cf:	75 0b                	jne    8009dc <strlcpy+0x23>
  8009d1:	eb 17                	jmp    8009ea <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	83 c0 01             	add    $0x1,%eax
  8009d9:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009dc:	39 d8                	cmp    %ebx,%eax
  8009de:	74 07                	je     8009e7 <strlcpy+0x2e>
  8009e0:	0f b6 0a             	movzbl (%edx),%ecx
  8009e3:	84 c9                	test   %cl,%cl
  8009e5:	75 ec                	jne    8009d3 <strlcpy+0x1a>
		*dst = '\0';
  8009e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ea:	29 f0                	sub    %esi,%eax
}
  8009ec:	5b                   	pop    %ebx
  8009ed:	5e                   	pop    %esi
  8009ee:	5d                   	pop    %ebp
  8009ef:	c3                   	ret    

008009f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f9:	eb 06                	jmp    800a01 <strcmp+0x11>
		p++, q++;
  8009fb:	83 c1 01             	add    $0x1,%ecx
  8009fe:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  800a01:	0f b6 01             	movzbl (%ecx),%eax
  800a04:	84 c0                	test   %al,%al
  800a06:	74 04                	je     800a0c <strcmp+0x1c>
  800a08:	3a 02                	cmp    (%edx),%al
  800a0a:	74 ef                	je     8009fb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0c:	0f b6 c0             	movzbl %al,%eax
  800a0f:	0f b6 12             	movzbl (%edx),%edx
  800a12:	29 d0                	sub    %edx,%eax
}
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a20:	89 c3                	mov    %eax,%ebx
  800a22:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a25:	eb 06                	jmp    800a2d <strncmp+0x17>
		n--, p++, q++;
  800a27:	83 c0 01             	add    $0x1,%eax
  800a2a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a2d:	39 d8                	cmp    %ebx,%eax
  800a2f:	74 16                	je     800a47 <strncmp+0x31>
  800a31:	0f b6 08             	movzbl (%eax),%ecx
  800a34:	84 c9                	test   %cl,%cl
  800a36:	74 04                	je     800a3c <strncmp+0x26>
  800a38:	3a 0a                	cmp    (%edx),%cl
  800a3a:	74 eb                	je     800a27 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3c:	0f b6 00             	movzbl (%eax),%eax
  800a3f:	0f b6 12             	movzbl (%edx),%edx
  800a42:	29 d0                	sub    %edx,%eax
}
  800a44:	5b                   	pop    %ebx
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    
		return 0;
  800a47:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4c:	eb f6                	jmp    800a44 <strncmp+0x2e>

00800a4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a58:	0f b6 10             	movzbl (%eax),%edx
  800a5b:	84 d2                	test   %dl,%dl
  800a5d:	74 09                	je     800a68 <strchr+0x1a>
		if (*s == c)
  800a5f:	38 ca                	cmp    %cl,%dl
  800a61:	74 0a                	je     800a6d <strchr+0x1f>
	for (; *s; s++)
  800a63:	83 c0 01             	add    $0x1,%eax
  800a66:	eb f0                	jmp    800a58 <strchr+0xa>
			return (char *) s;
	return 0;
  800a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a79:	eb 03                	jmp    800a7e <strfind+0xf>
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a81:	38 ca                	cmp    %cl,%dl
  800a83:	74 04                	je     800a89 <strfind+0x1a>
  800a85:	84 d2                	test   %dl,%dl
  800a87:	75 f2                	jne    800a7b <strfind+0xc>
			break;
	return (char *) s;
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	57                   	push   %edi
  800a8f:	56                   	push   %esi
  800a90:	53                   	push   %ebx
  800a91:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a97:	85 c9                	test   %ecx,%ecx
  800a99:	74 13                	je     800aae <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a9b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aa1:	75 05                	jne    800aa8 <memset+0x1d>
  800aa3:	f6 c1 03             	test   $0x3,%cl
  800aa6:	74 0d                	je     800ab5 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	fc                   	cld    
  800aac:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aae:	89 f8                	mov    %edi,%eax
  800ab0:	5b                   	pop    %ebx
  800ab1:	5e                   	pop    %esi
  800ab2:	5f                   	pop    %edi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    
		c &= 0xFF;
  800ab5:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab9:	89 d3                	mov    %edx,%ebx
  800abb:	c1 e3 08             	shl    $0x8,%ebx
  800abe:	89 d0                	mov    %edx,%eax
  800ac0:	c1 e0 18             	shl    $0x18,%eax
  800ac3:	89 d6                	mov    %edx,%esi
  800ac5:	c1 e6 10             	shl    $0x10,%esi
  800ac8:	09 f0                	or     %esi,%eax
  800aca:	09 c2                	or     %eax,%edx
  800acc:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ace:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ad1:	89 d0                	mov    %edx,%eax
  800ad3:	fc                   	cld    
  800ad4:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad6:	eb d6                	jmp    800aae <memset+0x23>

00800ad8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	57                   	push   %edi
  800adc:	56                   	push   %esi
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae6:	39 c6                	cmp    %eax,%esi
  800ae8:	73 35                	jae    800b1f <memmove+0x47>
  800aea:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aed:	39 c2                	cmp    %eax,%edx
  800aef:	76 2e                	jbe    800b1f <memmove+0x47>
		s += n;
		d += n;
  800af1:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af4:	89 d6                	mov    %edx,%esi
  800af6:	09 fe                	or     %edi,%esi
  800af8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afe:	74 0c                	je     800b0c <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b00:	83 ef 01             	sub    $0x1,%edi
  800b03:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b06:	fd                   	std    
  800b07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b09:	fc                   	cld    
  800b0a:	eb 21                	jmp    800b2d <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 ef                	jne    800b00 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb ea                	jmp    800b09 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1f:	89 f2                	mov    %esi,%edx
  800b21:	09 c2                	or     %eax,%edx
  800b23:	f6 c2 03             	test   $0x3,%dl
  800b26:	74 09                	je     800b31 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	fc                   	cld    
  800b2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b2d:	5e                   	pop    %esi
  800b2e:	5f                   	pop    %edi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b31:	f6 c1 03             	test   $0x3,%cl
  800b34:	75 f2                	jne    800b28 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b36:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	fc                   	cld    
  800b3c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3e:	eb ed                	jmp    800b2d <memmove+0x55>

00800b40 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b43:	ff 75 10             	pushl  0x10(%ebp)
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	ff 75 08             	pushl  0x8(%ebp)
  800b4c:	e8 87 ff ff ff       	call   800ad8 <memmove>
}
  800b51:	c9                   	leave  
  800b52:	c3                   	ret    

00800b53 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	56                   	push   %esi
  800b57:	53                   	push   %ebx
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	89 c6                	mov    %eax,%esi
  800b60:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b63:	39 f0                	cmp    %esi,%eax
  800b65:	74 1c                	je     800b83 <memcmp+0x30>
		if (*s1 != *s2)
  800b67:	0f b6 08             	movzbl (%eax),%ecx
  800b6a:	0f b6 1a             	movzbl (%edx),%ebx
  800b6d:	38 d9                	cmp    %bl,%cl
  800b6f:	75 08                	jne    800b79 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b71:	83 c0 01             	add    $0x1,%eax
  800b74:	83 c2 01             	add    $0x1,%edx
  800b77:	eb ea                	jmp    800b63 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b79:	0f b6 c1             	movzbl %cl,%eax
  800b7c:	0f b6 db             	movzbl %bl,%ebx
  800b7f:	29 d8                	sub    %ebx,%eax
  800b81:	eb 05                	jmp    800b88 <memcmp+0x35>
	}

	return 0;
  800b83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9a:	39 d0                	cmp    %edx,%eax
  800b9c:	73 09                	jae    800ba7 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9e:	38 08                	cmp    %cl,(%eax)
  800ba0:	74 05                	je     800ba7 <memfind+0x1b>
	for (; s < ends; s++)
  800ba2:	83 c0 01             	add    $0x1,%eax
  800ba5:	eb f3                	jmp    800b9a <memfind+0xe>
			break;
	return (void *) s;
}
  800ba7:	5d                   	pop    %ebp
  800ba8:	c3                   	ret    

00800ba9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	57                   	push   %edi
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb5:	eb 03                	jmp    800bba <strtol+0x11>
		s++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bba:	0f b6 01             	movzbl (%ecx),%eax
  800bbd:	3c 20                	cmp    $0x20,%al
  800bbf:	74 f6                	je     800bb7 <strtol+0xe>
  800bc1:	3c 09                	cmp    $0x9,%al
  800bc3:	74 f2                	je     800bb7 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc5:	3c 2b                	cmp    $0x2b,%al
  800bc7:	74 2e                	je     800bf7 <strtol+0x4e>
	int neg = 0;
  800bc9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bce:	3c 2d                	cmp    $0x2d,%al
  800bd0:	74 2f                	je     800c01 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd2:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd8:	75 05                	jne    800bdf <strtol+0x36>
  800bda:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdd:	74 2c                	je     800c0b <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bdf:	85 db                	test   %ebx,%ebx
  800be1:	75 0a                	jne    800bed <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be3:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800be8:	80 39 30             	cmpb   $0x30,(%ecx)
  800beb:	74 28                	je     800c15 <strtol+0x6c>
		base = 10;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf2:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf5:	eb 50                	jmp    800c47 <strtol+0x9e>
		s++;
  800bf7:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bfa:	bf 00 00 00 00       	mov    $0x0,%edi
  800bff:	eb d1                	jmp    800bd2 <strtol+0x29>
		s++, neg = 1;
  800c01:	83 c1 01             	add    $0x1,%ecx
  800c04:	bf 01 00 00 00       	mov    $0x1,%edi
  800c09:	eb c7                	jmp    800bd2 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0b:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0f:	74 0e                	je     800c1f <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800c11:	85 db                	test   %ebx,%ebx
  800c13:	75 d8                	jne    800bed <strtol+0x44>
		s++, base = 8;
  800c15:	83 c1 01             	add    $0x1,%ecx
  800c18:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c1d:	eb ce                	jmp    800bed <strtol+0x44>
		s += 2, base = 16;
  800c1f:	83 c1 02             	add    $0x2,%ecx
  800c22:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c27:	eb c4                	jmp    800bed <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c29:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2c:	89 f3                	mov    %esi,%ebx
  800c2e:	80 fb 19             	cmp    $0x19,%bl
  800c31:	77 29                	ja     800c5c <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c33:	0f be d2             	movsbl %dl,%edx
  800c36:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c39:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3c:	7d 30                	jge    800c6e <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c3e:	83 c1 01             	add    $0x1,%ecx
  800c41:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c45:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c47:	0f b6 11             	movzbl (%ecx),%edx
  800c4a:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c4d:	89 f3                	mov    %esi,%ebx
  800c4f:	80 fb 09             	cmp    $0x9,%bl
  800c52:	77 d5                	ja     800c29 <strtol+0x80>
			dig = *s - '0';
  800c54:	0f be d2             	movsbl %dl,%edx
  800c57:	83 ea 30             	sub    $0x30,%edx
  800c5a:	eb dd                	jmp    800c39 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c5c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5f:	89 f3                	mov    %esi,%ebx
  800c61:	80 fb 19             	cmp    $0x19,%bl
  800c64:	77 08                	ja     800c6e <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c66:	0f be d2             	movsbl %dl,%edx
  800c69:	83 ea 37             	sub    $0x37,%edx
  800c6c:	eb cb                	jmp    800c39 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c72:	74 05                	je     800c79 <strtol+0xd0>
		*endptr = (char *) s;
  800c74:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c77:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c79:	89 c2                	mov    %eax,%edx
  800c7b:	f7 da                	neg    %edx
  800c7d:	85 ff                	test   %edi,%edi
  800c7f:	0f 45 c2             	cmovne %edx,%eax
}
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c92:	8b 55 08             	mov    0x8(%ebp),%edx
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c98:	89 c3                	mov    %eax,%ebx
  800c9a:	89 c7                	mov    %eax,%edi
  800c9c:	89 c6                	mov    %eax,%esi
  800c9e:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	89 cb                	mov    %ecx,%ebx
  800cdc:	89 cf                	mov    %ecx,%edi
  800cde:	89 ce                	mov    %ecx,%esi
  800ce0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce2:	85 c0                	test   %eax,%eax
  800ce4:	7f 08                	jg     800cee <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce9:	5b                   	pop    %ebx
  800cea:	5e                   	pop    %esi
  800ceb:	5f                   	pop    %edi
  800cec:	5d                   	pop    %ebp
  800ced:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cee:	83 ec 0c             	sub    $0xc,%esp
  800cf1:	50                   	push   %eax
  800cf2:	6a 03                	push   $0x3
  800cf4:	68 3f 2b 80 00       	push   $0x802b3f
  800cf9:	6a 23                	push   $0x23
  800cfb:	68 5c 2b 80 00       	push   $0x802b5c
  800d00:	e8 4b f5 ff ff       	call   800250 <_panic>

00800d05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 02 00 00 00       	mov    $0x2,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_yield>:

void
sys_yield(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d34:	89 d1                	mov    %edx,%ecx
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	89 d7                	mov    %edx,%edi
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4c:	be 00 00 00 00       	mov    $0x0,%esi
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d57:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5f:	89 f7                	mov    %esi,%edi
  800d61:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7f 08                	jg     800d6f <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d73:	6a 04                	push   $0x4
  800d75:	68 3f 2b 80 00       	push   $0x802b3f
  800d7a:	6a 23                	push   $0x23
  800d7c:	68 5c 2b 80 00       	push   $0x802b5c
  800d81:	e8 ca f4 ff ff       	call   800250 <_panic>

00800d86 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da0:	8b 75 18             	mov    0x18(%ebp),%esi
  800da3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da5:	85 c0                	test   %eax,%eax
  800da7:	7f 08                	jg     800db1 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800db5:	6a 05                	push   $0x5
  800db7:	68 3f 2b 80 00       	push   $0x802b3f
  800dbc:	6a 23                	push   $0x23
  800dbe:	68 5c 2b 80 00       	push   $0x802b5c
  800dc3:	e8 88 f4 ff ff       	call   800250 <_panic>

00800dc8 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	57                   	push   %edi
  800dcc:	56                   	push   %esi
  800dcd:	53                   	push   %ebx
  800dce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	b8 06 00 00 00       	mov    $0x6,%eax
  800de1:	89 df                	mov    %ebx,%edi
  800de3:	89 de                	mov    %ebx,%esi
  800de5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7f 08                	jg     800df3 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	50                   	push   %eax
  800df7:	6a 06                	push   $0x6
  800df9:	68 3f 2b 80 00       	push   $0x802b3f
  800dfe:	6a 23                	push   $0x23
  800e00:	68 5c 2b 80 00       	push   $0x802b5c
  800e05:	e8 46 f4 ff ff       	call   800250 <_panic>

00800e0a <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1e:	b8 08 00 00 00       	mov    $0x8,%eax
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7f 08                	jg     800e35 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e35:	83 ec 0c             	sub    $0xc,%esp
  800e38:	50                   	push   %eax
  800e39:	6a 08                	push   $0x8
  800e3b:	68 3f 2b 80 00       	push   $0x802b3f
  800e40:	6a 23                	push   $0x23
  800e42:	68 5c 2b 80 00       	push   $0x802b5c
  800e47:	e8 04 f4 ff ff       	call   800250 <_panic>

00800e4c <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	57                   	push   %edi
  800e50:	56                   	push   %esi
  800e51:	53                   	push   %ebx
  800e52:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e55:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e60:	b8 09 00 00 00       	mov    $0x9,%eax
  800e65:	89 df                	mov    %ebx,%edi
  800e67:	89 de                	mov    %ebx,%esi
  800e69:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	7f 08                	jg     800e77 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	50                   	push   %eax
  800e7b:	6a 09                	push   $0x9
  800e7d:	68 3f 2b 80 00       	push   $0x802b3f
  800e82:	6a 23                	push   $0x23
  800e84:	68 5c 2b 80 00       	push   $0x802b5c
  800e89:	e8 c2 f3 ff ff       	call   800250 <_panic>

00800e8e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	57                   	push   %edi
  800e92:	56                   	push   %esi
  800e93:	53                   	push   %ebx
  800e94:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e97:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea7:	89 df                	mov    %ebx,%edi
  800ea9:	89 de                	mov    %ebx,%esi
  800eab:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	7f 08                	jg     800eb9 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb9:	83 ec 0c             	sub    $0xc,%esp
  800ebc:	50                   	push   %eax
  800ebd:	6a 0a                	push   $0xa
  800ebf:	68 3f 2b 80 00       	push   $0x802b3f
  800ec4:	6a 23                	push   $0x23
  800ec6:	68 5c 2b 80 00       	push   $0x802b5c
  800ecb:	e8 80 f3 ff ff       	call   800250 <_panic>

00800ed0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee1:	be 00 00 00 00       	mov    $0x0,%esi
  800ee6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee9:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eec:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f01:	8b 55 08             	mov    0x8(%ebp),%edx
  800f04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f09:	89 cb                	mov    %ecx,%ebx
  800f0b:	89 cf                	mov    %ecx,%edi
  800f0d:	89 ce                	mov    %ecx,%esi
  800f0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	7f 08                	jg     800f1d <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	50                   	push   %eax
  800f21:	6a 0d                	push   $0xd
  800f23:	68 3f 2b 80 00       	push   $0x802b3f
  800f28:	6a 23                	push   $0x23
  800f2a:	68 5c 2b 80 00       	push   $0x802b5c
  800f2f:	e8 1c f3 ff ff       	call   800250 <_panic>

00800f34 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f44:	89 d1                	mov    %edx,%ecx
  800f46:	89 d3                	mov    %edx,%ebx
  800f48:	89 d7                	mov    %edx,%edi
  800f4a:	89 d6                	mov    %edx,%esi
  800f4c:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	56                   	push   %esi
  800f57:	53                   	push   %ebx
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800f5b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f5d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f61:	74 7f                	je     800fe2 <pgfault+0x8f>
  800f63:	89 d8                	mov    %ebx,%eax
  800f65:	c1 e8 0c             	shr    $0xc,%eax
  800f68:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f6f:	f6 c4 08             	test   $0x8,%ah
  800f72:	74 6e                	je     800fe2 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800f74:	e8 8c fd ff ff       	call   800d05 <sys_getenvid>
  800f79:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f7b:	83 ec 04             	sub    $0x4,%esp
  800f7e:	6a 07                	push   $0x7
  800f80:	68 00 f0 7f 00       	push   $0x7ff000
  800f85:	50                   	push   %eax
  800f86:	e8 b8 fd ff ff       	call   800d43 <sys_page_alloc>
  800f8b:	83 c4 10             	add    $0x10,%esp
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	78 64                	js     800ff6 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800f92:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800f98:	83 ec 04             	sub    $0x4,%esp
  800f9b:	68 00 10 00 00       	push   $0x1000
  800fa0:	53                   	push   %ebx
  800fa1:	68 00 f0 7f 00       	push   $0x7ff000
  800fa6:	e8 2d fb ff ff       	call   800ad8 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800fab:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800fb2:	53                   	push   %ebx
  800fb3:	56                   	push   %esi
  800fb4:	68 00 f0 7f 00       	push   $0x7ff000
  800fb9:	56                   	push   %esi
  800fba:	e8 c7 fd ff ff       	call   800d86 <sys_page_map>
  800fbf:	83 c4 20             	add    $0x20,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	78 42                	js     801008 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fc6:	83 ec 08             	sub    $0x8,%esp
  800fc9:	68 00 f0 7f 00       	push   $0x7ff000
  800fce:	56                   	push   %esi
  800fcf:	e8 f4 fd ff ff       	call   800dc8 <sys_page_unmap>
  800fd4:	83 c4 10             	add    $0x10,%esp
  800fd7:	85 c0                	test   %eax,%eax
  800fd9:	78 3f                	js     80101a <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800fdb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800fe2:	83 ec 04             	sub    $0x4,%esp
  800fe5:	68 6c 2b 80 00       	push   $0x802b6c
  800fea:	6a 1d                	push   $0x1d
  800fec:	68 fb 2b 80 00       	push   $0x802bfb
  800ff1:	e8 5a f2 ff ff       	call   800250 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800ff6:	50                   	push   %eax
  800ff7:	68 94 2b 80 00       	push   $0x802b94
  800ffc:	6a 28                	push   $0x28
  800ffe:	68 fb 2b 80 00       	push   $0x802bfb
  801003:	e8 48 f2 ff ff       	call   800250 <_panic>
		panic("pgfault:page map failed: %e", r);
  801008:	50                   	push   %eax
  801009:	68 06 2c 80 00       	push   $0x802c06
  80100e:	6a 2c                	push   $0x2c
  801010:	68 fb 2b 80 00       	push   $0x802bfb
  801015:	e8 36 f2 ff ff       	call   800250 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  80101a:	50                   	push   %eax
  80101b:	68 b8 2b 80 00       	push   $0x802bb8
  801020:	6a 2e                	push   $0x2e
  801022:	68 fb 2b 80 00       	push   $0x802bfb
  801027:	e8 24 f2 ff ff       	call   800250 <_panic>

0080102c <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
  801032:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  801035:	68 53 0f 80 00       	push   $0x800f53
  80103a:	e8 01 14 00 00       	call   802440 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80103f:	b8 07 00 00 00       	mov    $0x7,%eax
  801044:	cd 30                	int    $0x30
  801046:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 2f                	js     80107f <fork+0x53>
  801050:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801052:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  801057:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80105b:	75 6e                	jne    8010cb <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  80105d:	e8 a3 fc ff ff       	call   800d05 <sys_getenvid>
  801062:	25 ff 03 00 00       	and    $0x3ff,%eax
  801067:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80106a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80106f:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  801074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  801077:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80107a:	5b                   	pop    %ebx
  80107b:	5e                   	pop    %esi
  80107c:	5f                   	pop    %edi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  80107f:	50                   	push   %eax
  801080:	68 d8 2b 80 00       	push   $0x802bd8
  801085:	6a 6e                	push   $0x6e
  801087:	68 fb 2b 80 00       	push   $0x802bfb
  80108c:	e8 bf f1 ff ff       	call   800250 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801091:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801098:	83 ec 0c             	sub    $0xc,%esp
  80109b:	25 07 0e 00 00       	and    $0xe07,%eax
  8010a0:	50                   	push   %eax
  8010a1:	56                   	push   %esi
  8010a2:	57                   	push   %edi
  8010a3:	56                   	push   %esi
  8010a4:	6a 00                	push   $0x0
  8010a6:	e8 db fc ff ff       	call   800d86 <sys_page_map>
  8010ab:	83 c4 20             	add    $0x20,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b5:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 bb                	js     801077 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  8010bc:	83 c3 01             	add    $0x1,%ebx
  8010bf:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8010c5:	0f 84 a6 00 00 00    	je     801171 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8010cb:	89 d8                	mov    %ebx,%eax
  8010cd:	c1 e8 0a             	shr    $0xa,%eax
  8010d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010d7:	a8 01                	test   $0x1,%al
  8010d9:	74 e1                	je     8010bc <fork+0x90>
  8010db:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010e2:	a8 01                	test   $0x1,%al
  8010e4:	74 d6                	je     8010bc <fork+0x90>
  8010e6:	89 de                	mov    %ebx,%esi
  8010e8:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  8010eb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010f2:	f6 c4 04             	test   $0x4,%ah
  8010f5:	75 9a                	jne    801091 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8010f7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010fe:	a8 02                	test   $0x2,%al
  801100:	75 0c                	jne    80110e <fork+0xe2>
  801102:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801109:	f6 c4 08             	test   $0x8,%ah
  80110c:	74 42                	je     801150 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	68 05 08 00 00       	push   $0x805
  801116:	56                   	push   %esi
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	6a 00                	push   $0x0
  80111b:	e8 66 fc ff ff       	call   800d86 <sys_page_map>
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	85 c0                	test   %eax,%eax
  801125:	0f 88 4c ff ff ff    	js     801077 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	68 05 08 00 00       	push   $0x805
  801133:	56                   	push   %esi
  801134:	6a 00                	push   $0x0
  801136:	56                   	push   %esi
  801137:	6a 00                	push   $0x0
  801139:	e8 48 fc ff ff       	call   800d86 <sys_page_map>
  80113e:	83 c4 20             	add    $0x20,%esp
  801141:	85 c0                	test   %eax,%eax
  801143:	b9 00 00 00 00       	mov    $0x0,%ecx
  801148:	0f 4f c1             	cmovg  %ecx,%eax
  80114b:	e9 68 ff ff ff       	jmp    8010b8 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  801150:	83 ec 0c             	sub    $0xc,%esp
  801153:	6a 05                	push   $0x5
  801155:	56                   	push   %esi
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	6a 00                	push   $0x0
  80115a:	e8 27 fc ff ff       	call   800d86 <sys_page_map>
  80115f:	83 c4 20             	add    $0x20,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	b9 00 00 00 00       	mov    $0x0,%ecx
  801169:	0f 4f c1             	cmovg  %ecx,%eax
  80116c:	e9 47 ff ff ff       	jmp    8010b8 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	6a 07                	push   $0x7
  801176:	68 00 f0 bf ee       	push   $0xeebff000
  80117b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80117e:	57                   	push   %edi
  80117f:	e8 bf fb ff ff       	call   800d43 <sys_page_alloc>
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	0f 88 e8 fe ff ff    	js     801077 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  80118f:	83 ec 08             	sub    $0x8,%esp
  801192:	68 a5 24 80 00       	push   $0x8024a5
  801197:	57                   	push   %edi
  801198:	e8 f1 fc ff ff       	call   800e8e <sys_env_set_pgfault_upcall>
  80119d:	83 c4 10             	add    $0x10,%esp
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	0f 88 cf fe ff ff    	js     801077 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  8011a8:	83 ec 08             	sub    $0x8,%esp
  8011ab:	6a 02                	push   $0x2
  8011ad:	57                   	push   %edi
  8011ae:	e8 57 fc ff ff       	call   800e0a <sys_env_set_status>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	78 08                	js     8011c2 <fork+0x196>
	return eid;
  8011ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011bd:	e9 b5 fe ff ff       	jmp    801077 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  8011c2:	50                   	push   %eax
  8011c3:	68 22 2c 80 00       	push   $0x802c22
  8011c8:	68 87 00 00 00       	push   $0x87
  8011cd:	68 fb 2b 80 00       	push   $0x802bfb
  8011d2:	e8 79 f0 ff ff       	call   800250 <_panic>

008011d7 <sfork>:

// Challenge!
int sfork(void)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011dd:	68 40 2c 80 00       	push   $0x802c40
  8011e2:	68 8f 00 00 00       	push   $0x8f
  8011e7:	68 fb 2b 80 00       	push   $0x802bfb
  8011ec:	e8 5f f0 ff ff       	call   800250 <_panic>

008011f1 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	56                   	push   %esi
  8011f5:	53                   	push   %ebx
  8011f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8011ff:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801201:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801206:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801209:	83 ec 0c             	sub    $0xc,%esp
  80120c:	50                   	push   %eax
  80120d:	e8 e1 fc ff ff       	call   800ef3 <sys_ipc_recv>
	if (from_env_store)
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 f6                	test   %esi,%esi
  801217:	74 14                	je     80122d <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801219:	ba 00 00 00 00       	mov    $0x0,%edx
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 09                	js     80122b <ipc_recv+0x3a>
  801222:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801228:	8b 52 74             	mov    0x74(%edx),%edx
  80122b:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  80122d:	85 db                	test   %ebx,%ebx
  80122f:	74 14                	je     801245 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801231:	ba 00 00 00 00       	mov    $0x0,%edx
  801236:	85 c0                	test   %eax,%eax
  801238:	78 09                	js     801243 <ipc_recv+0x52>
  80123a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801240:	8b 52 78             	mov    0x78(%edx),%edx
  801243:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801245:	85 c0                	test   %eax,%eax
  801247:	78 08                	js     801251 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801249:	a1 08 40 80 00       	mov    0x804008,%eax
  80124e:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801251:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801254:	5b                   	pop    %ebx
  801255:	5e                   	pop    %esi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	57                   	push   %edi
  80125c:	56                   	push   %esi
  80125d:	53                   	push   %ebx
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	8b 7d 08             	mov    0x8(%ebp),%edi
  801264:	8b 75 0c             	mov    0xc(%ebp),%esi
  801267:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80126a:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80126c:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801271:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801274:	ff 75 14             	pushl  0x14(%ebp)
  801277:	53                   	push   %ebx
  801278:	56                   	push   %esi
  801279:	57                   	push   %edi
  80127a:	e8 51 fc ff ff       	call   800ed0 <sys_ipc_try_send>
		if (ret == 0)
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	85 c0                	test   %eax,%eax
  801284:	74 1e                	je     8012a4 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801286:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801289:	75 07                	jne    801292 <ipc_send+0x3a>
			sys_yield();
  80128b:	e8 94 fa ff ff       	call   800d24 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801290:	eb e2                	jmp    801274 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801292:	50                   	push   %eax
  801293:	68 56 2c 80 00       	push   $0x802c56
  801298:	6a 3d                	push   $0x3d
  80129a:	68 6a 2c 80 00       	push   $0x802c6a
  80129f:	e8 ac ef ff ff       	call   800250 <_panic>
	}
	// panic("ipc_send not implemented");
}
  8012a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8012b7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8012ba:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8012c0:	8b 52 50             	mov    0x50(%edx),%edx
  8012c3:	39 ca                	cmp    %ecx,%edx
  8012c5:	74 11                	je     8012d8 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8012c7:	83 c0 01             	add    $0x1,%eax
  8012ca:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012cf:	75 e6                	jne    8012b7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb 0b                	jmp    8012e3 <ipc_find_env+0x37>
			return envs[i].env_id;
  8012d8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012db:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012e0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012eb:	05 00 00 00 30       	add    $0x30000000,%eax
  8012f0:	c1 e8 0c             	shr    $0xc,%eax
}
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801300:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801305:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801312:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801317:	89 c2                	mov    %eax,%edx
  801319:	c1 ea 16             	shr    $0x16,%edx
  80131c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801323:	f6 c2 01             	test   $0x1,%dl
  801326:	74 2a                	je     801352 <fd_alloc+0x46>
  801328:	89 c2                	mov    %eax,%edx
  80132a:	c1 ea 0c             	shr    $0xc,%edx
  80132d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801334:	f6 c2 01             	test   $0x1,%dl
  801337:	74 19                	je     801352 <fd_alloc+0x46>
  801339:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80133e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801343:	75 d2                	jne    801317 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801345:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80134b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801350:	eb 07                	jmp    801359 <fd_alloc+0x4d>
			*fd_store = fd;
  801352:	89 01                	mov    %eax,(%ecx)
			return 0;
  801354:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801361:	83 f8 1f             	cmp    $0x1f,%eax
  801364:	77 36                	ja     80139c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801366:	c1 e0 0c             	shl    $0xc,%eax
  801369:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80136e:	89 c2                	mov    %eax,%edx
  801370:	c1 ea 16             	shr    $0x16,%edx
  801373:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80137a:	f6 c2 01             	test   $0x1,%dl
  80137d:	74 24                	je     8013a3 <fd_lookup+0x48>
  80137f:	89 c2                	mov    %eax,%edx
  801381:	c1 ea 0c             	shr    $0xc,%edx
  801384:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138b:	f6 c2 01             	test   $0x1,%dl
  80138e:	74 1a                	je     8013aa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801390:	8b 55 0c             	mov    0xc(%ebp),%edx
  801393:	89 02                	mov    %eax,(%edx)
	return 0;
  801395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    
		return -E_INVAL;
  80139c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a1:	eb f7                	jmp    80139a <fd_lookup+0x3f>
		return -E_INVAL;
  8013a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a8:	eb f0                	jmp    80139a <fd_lookup+0x3f>
  8013aa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013af:	eb e9                	jmp    80139a <fd_lookup+0x3f>

008013b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	83 ec 08             	sub    $0x8,%esp
  8013b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ba:	ba f4 2c 80 00       	mov    $0x802cf4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8013bf:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8013c4:	39 08                	cmp    %ecx,(%eax)
  8013c6:	74 33                	je     8013fb <dev_lookup+0x4a>
  8013c8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8013cb:	8b 02                	mov    (%edx),%eax
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	75 f3                	jne    8013c4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d6:	8b 40 48             	mov    0x48(%eax),%eax
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	51                   	push   %ecx
  8013dd:	50                   	push   %eax
  8013de:	68 74 2c 80 00       	push   $0x802c74
  8013e3:	e8 43 ef ff ff       	call   80032b <cprintf>
	*dev = 0;
  8013e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013f1:	83 c4 10             	add    $0x10,%esp
  8013f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    
			*dev = devtab[i];
  8013fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013fe:	89 01                	mov    %eax,(%ecx)
			return 0;
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	eb f2                	jmp    8013f9 <dev_lookup+0x48>

00801407 <fd_close>:
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	57                   	push   %edi
  80140b:	56                   	push   %esi
  80140c:	53                   	push   %ebx
  80140d:	83 ec 1c             	sub    $0x1c,%esp
  801410:	8b 75 08             	mov    0x8(%ebp),%esi
  801413:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801416:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801419:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80141a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801420:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801423:	50                   	push   %eax
  801424:	e8 32 ff ff ff       	call   80135b <fd_lookup>
  801429:	89 c3                	mov    %eax,%ebx
  80142b:	83 c4 08             	add    $0x8,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 05                	js     801437 <fd_close+0x30>
	    || fd != fd2)
  801432:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801435:	74 16                	je     80144d <fd_close+0x46>
		return (must_exist ? r : 0);
  801437:	89 f8                	mov    %edi,%eax
  801439:	84 c0                	test   %al,%al
  80143b:	b8 00 00 00 00       	mov    $0x0,%eax
  801440:	0f 44 d8             	cmove  %eax,%ebx
}
  801443:	89 d8                	mov    %ebx,%eax
  801445:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801448:	5b                   	pop    %ebx
  801449:	5e                   	pop    %esi
  80144a:	5f                   	pop    %edi
  80144b:	5d                   	pop    %ebp
  80144c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80144d:	83 ec 08             	sub    $0x8,%esp
  801450:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801453:	50                   	push   %eax
  801454:	ff 36                	pushl  (%esi)
  801456:	e8 56 ff ff ff       	call   8013b1 <dev_lookup>
  80145b:	89 c3                	mov    %eax,%ebx
  80145d:	83 c4 10             	add    $0x10,%esp
  801460:	85 c0                	test   %eax,%eax
  801462:	78 15                	js     801479 <fd_close+0x72>
		if (dev->dev_close)
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	8b 40 10             	mov    0x10(%eax),%eax
  80146a:	85 c0                	test   %eax,%eax
  80146c:	74 1b                	je     801489 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	56                   	push   %esi
  801472:	ff d0                	call   *%eax
  801474:	89 c3                	mov    %eax,%ebx
  801476:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	56                   	push   %esi
  80147d:	6a 00                	push   $0x0
  80147f:	e8 44 f9 ff ff       	call   800dc8 <sys_page_unmap>
	return r;
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	eb ba                	jmp    801443 <fd_close+0x3c>
			r = 0;
  801489:	bb 00 00 00 00       	mov    $0x0,%ebx
  80148e:	eb e9                	jmp    801479 <fd_close+0x72>

00801490 <close>:

int
close(int fdnum)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801496:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801499:	50                   	push   %eax
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	e8 b9 fe ff ff       	call   80135b <fd_lookup>
  8014a2:	83 c4 08             	add    $0x8,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 10                	js     8014b9 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8014a9:	83 ec 08             	sub    $0x8,%esp
  8014ac:	6a 01                	push   $0x1
  8014ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b1:	e8 51 ff ff ff       	call   801407 <fd_close>
  8014b6:	83 c4 10             	add    $0x10,%esp
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <close_all>:

void
close_all(void)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014c7:	83 ec 0c             	sub    $0xc,%esp
  8014ca:	53                   	push   %ebx
  8014cb:	e8 c0 ff ff ff       	call   801490 <close>
	for (i = 0; i < MAXFD; i++)
  8014d0:	83 c3 01             	add    $0x1,%ebx
  8014d3:	83 c4 10             	add    $0x10,%esp
  8014d6:	83 fb 20             	cmp    $0x20,%ebx
  8014d9:	75 ec                	jne    8014c7 <close_all+0xc>
}
  8014db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	57                   	push   %edi
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	ff 75 08             	pushl  0x8(%ebp)
  8014f0:	e8 66 fe ff ff       	call   80135b <fd_lookup>
  8014f5:	89 c3                	mov    %eax,%ebx
  8014f7:	83 c4 08             	add    $0x8,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	0f 88 81 00 00 00    	js     801583 <dup+0xa3>
		return r;
	close(newfdnum);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	ff 75 0c             	pushl  0xc(%ebp)
  801508:	e8 83 ff ff ff       	call   801490 <close>

	newfd = INDEX2FD(newfdnum);
  80150d:	8b 75 0c             	mov    0xc(%ebp),%esi
  801510:	c1 e6 0c             	shl    $0xc,%esi
  801513:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801519:	83 c4 04             	add    $0x4,%esp
  80151c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80151f:	e8 d1 fd ff ff       	call   8012f5 <fd2data>
  801524:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801526:	89 34 24             	mov    %esi,(%esp)
  801529:	e8 c7 fd ff ff       	call   8012f5 <fd2data>
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801533:	89 d8                	mov    %ebx,%eax
  801535:	c1 e8 16             	shr    $0x16,%eax
  801538:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80153f:	a8 01                	test   $0x1,%al
  801541:	74 11                	je     801554 <dup+0x74>
  801543:	89 d8                	mov    %ebx,%eax
  801545:	c1 e8 0c             	shr    $0xc,%eax
  801548:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80154f:	f6 c2 01             	test   $0x1,%dl
  801552:	75 39                	jne    80158d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801554:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801557:	89 d0                	mov    %edx,%eax
  801559:	c1 e8 0c             	shr    $0xc,%eax
  80155c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801563:	83 ec 0c             	sub    $0xc,%esp
  801566:	25 07 0e 00 00       	and    $0xe07,%eax
  80156b:	50                   	push   %eax
  80156c:	56                   	push   %esi
  80156d:	6a 00                	push   $0x0
  80156f:	52                   	push   %edx
  801570:	6a 00                	push   $0x0
  801572:	e8 0f f8 ff ff       	call   800d86 <sys_page_map>
  801577:	89 c3                	mov    %eax,%ebx
  801579:	83 c4 20             	add    $0x20,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 31                	js     8015b1 <dup+0xd1>
		goto err;

	return newfdnum;
  801580:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801583:	89 d8                	mov    %ebx,%eax
  801585:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801588:	5b                   	pop    %ebx
  801589:	5e                   	pop    %esi
  80158a:	5f                   	pop    %edi
  80158b:	5d                   	pop    %ebp
  80158c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80158d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801594:	83 ec 0c             	sub    $0xc,%esp
  801597:	25 07 0e 00 00       	and    $0xe07,%eax
  80159c:	50                   	push   %eax
  80159d:	57                   	push   %edi
  80159e:	6a 00                	push   $0x0
  8015a0:	53                   	push   %ebx
  8015a1:	6a 00                	push   $0x0
  8015a3:	e8 de f7 ff ff       	call   800d86 <sys_page_map>
  8015a8:	89 c3                	mov    %eax,%ebx
  8015aa:	83 c4 20             	add    $0x20,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	79 a3                	jns    801554 <dup+0x74>
	sys_page_unmap(0, newfd);
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	56                   	push   %esi
  8015b5:	6a 00                	push   $0x0
  8015b7:	e8 0c f8 ff ff       	call   800dc8 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015bc:	83 c4 08             	add    $0x8,%esp
  8015bf:	57                   	push   %edi
  8015c0:	6a 00                	push   $0x0
  8015c2:	e8 01 f8 ff ff       	call   800dc8 <sys_page_unmap>
	return r;
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	eb b7                	jmp    801583 <dup+0xa3>

008015cc <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 14             	sub    $0x14,%esp
  8015d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d9:	50                   	push   %eax
  8015da:	53                   	push   %ebx
  8015db:	e8 7b fd ff ff       	call   80135b <fd_lookup>
  8015e0:	83 c4 08             	add    $0x8,%esp
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 3f                	js     801626 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e7:	83 ec 08             	sub    $0x8,%esp
  8015ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ed:	50                   	push   %eax
  8015ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f1:	ff 30                	pushl  (%eax)
  8015f3:	e8 b9 fd ff ff       	call   8013b1 <dev_lookup>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	78 27                	js     801626 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801602:	8b 42 08             	mov    0x8(%edx),%eax
  801605:	83 e0 03             	and    $0x3,%eax
  801608:	83 f8 01             	cmp    $0x1,%eax
  80160b:	74 1e                	je     80162b <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	8b 40 08             	mov    0x8(%eax),%eax
  801613:	85 c0                	test   %eax,%eax
  801615:	74 35                	je     80164c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	ff 75 10             	pushl  0x10(%ebp)
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	52                   	push   %edx
  801621:	ff d0                	call   *%eax
  801623:	83 c4 10             	add    $0x10,%esp
}
  801626:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801629:	c9                   	leave  
  80162a:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80162b:	a1 08 40 80 00       	mov    0x804008,%eax
  801630:	8b 40 48             	mov    0x48(%eax),%eax
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	53                   	push   %ebx
  801637:	50                   	push   %eax
  801638:	68 b8 2c 80 00       	push   $0x802cb8
  80163d:	e8 e9 ec ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80164a:	eb da                	jmp    801626 <read+0x5a>
		return -E_NOT_SUPP;
  80164c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801651:	eb d3                	jmp    801626 <read+0x5a>

00801653 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	57                   	push   %edi
  801657:	56                   	push   %esi
  801658:	53                   	push   %ebx
  801659:	83 ec 0c             	sub    $0xc,%esp
  80165c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80165f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801662:	bb 00 00 00 00       	mov    $0x0,%ebx
  801667:	39 f3                	cmp    %esi,%ebx
  801669:	73 25                	jae    801690 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	89 f0                	mov    %esi,%eax
  801670:	29 d8                	sub    %ebx,%eax
  801672:	50                   	push   %eax
  801673:	89 d8                	mov    %ebx,%eax
  801675:	03 45 0c             	add    0xc(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	57                   	push   %edi
  80167a:	e8 4d ff ff ff       	call   8015cc <read>
		if (m < 0)
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	78 08                	js     80168e <readn+0x3b>
			return m;
		if (m == 0)
  801686:	85 c0                	test   %eax,%eax
  801688:	74 06                	je     801690 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80168a:	01 c3                	add    %eax,%ebx
  80168c:	eb d9                	jmp    801667 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80168e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801690:	89 d8                	mov    %ebx,%eax
  801692:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 14             	sub    $0x14,%esp
  8016a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a7:	50                   	push   %eax
  8016a8:	53                   	push   %ebx
  8016a9:	e8 ad fc ff ff       	call   80135b <fd_lookup>
  8016ae:	83 c4 08             	add    $0x8,%esp
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 3a                	js     8016ef <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bf:	ff 30                	pushl  (%eax)
  8016c1:	e8 eb fc ff ff       	call   8013b1 <dev_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 22                	js     8016ef <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d0:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016d4:	74 1e                	je     8016f4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d9:	8b 52 0c             	mov    0xc(%edx),%edx
  8016dc:	85 d2                	test   %edx,%edx
  8016de:	74 35                	je     801715 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	ff 75 10             	pushl  0x10(%ebp)
  8016e6:	ff 75 0c             	pushl  0xc(%ebp)
  8016e9:	50                   	push   %eax
  8016ea:	ff d2                	call   *%edx
  8016ec:	83 c4 10             	add    $0x10,%esp
}
  8016ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8016f9:	8b 40 48             	mov    0x48(%eax),%eax
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	53                   	push   %ebx
  801700:	50                   	push   %eax
  801701:	68 d4 2c 80 00       	push   $0x802cd4
  801706:	e8 20 ec ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801713:	eb da                	jmp    8016ef <write+0x55>
		return -E_NOT_SUPP;
  801715:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171a:	eb d3                	jmp    8016ef <write+0x55>

0080171c <seek>:

int
seek(int fdnum, off_t offset)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801722:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801725:	50                   	push   %eax
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	e8 2d fc ff ff       	call   80135b <fd_lookup>
  80172e:	83 c4 08             	add    $0x8,%esp
  801731:	85 c0                	test   %eax,%eax
  801733:	78 0e                	js     801743 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801735:	8b 55 0c             	mov    0xc(%ebp),%edx
  801738:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80173b:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 14             	sub    $0x14,%esp
  80174c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801752:	50                   	push   %eax
  801753:	53                   	push   %ebx
  801754:	e8 02 fc ff ff       	call   80135b <fd_lookup>
  801759:	83 c4 08             	add    $0x8,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 37                	js     801797 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	ff 30                	pushl  (%eax)
  80176c:	e8 40 fc ff ff       	call   8013b1 <dev_lookup>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	85 c0                	test   %eax,%eax
  801776:	78 1f                	js     801797 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80177f:	74 1b                	je     80179c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801784:	8b 52 18             	mov    0x18(%edx),%edx
  801787:	85 d2                	test   %edx,%edx
  801789:	74 32                	je     8017bd <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80178b:	83 ec 08             	sub    $0x8,%esp
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	50                   	push   %eax
  801792:	ff d2                	call   *%edx
  801794:	83 c4 10             	add    $0x10,%esp
}
  801797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80179c:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017a1:	8b 40 48             	mov    0x48(%eax),%eax
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	53                   	push   %ebx
  8017a8:	50                   	push   %eax
  8017a9:	68 94 2c 80 00       	push   $0x802c94
  8017ae:	e8 78 eb ff ff       	call   80032b <cprintf>
		return -E_INVAL;
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017bb:	eb da                	jmp    801797 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8017bd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c2:	eb d3                	jmp    801797 <ftruncate+0x52>

008017c4 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	53                   	push   %ebx
  8017c8:	83 ec 14             	sub    $0x14,%esp
  8017cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d1:	50                   	push   %eax
  8017d2:	ff 75 08             	pushl  0x8(%ebp)
  8017d5:	e8 81 fb ff ff       	call   80135b <fd_lookup>
  8017da:	83 c4 08             	add    $0x8,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 4b                	js     80182c <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e7:	50                   	push   %eax
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	ff 30                	pushl  (%eax)
  8017ed:	e8 bf fb ff ff       	call   8013b1 <dev_lookup>
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 33                	js     80182c <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801800:	74 2f                	je     801831 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801802:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801805:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80180c:	00 00 00 
	stat->st_isdir = 0;
  80180f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801816:	00 00 00 
	stat->st_dev = dev;
  801819:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80181f:	83 ec 08             	sub    $0x8,%esp
  801822:	53                   	push   %ebx
  801823:	ff 75 f0             	pushl  -0x10(%ebp)
  801826:	ff 50 14             	call   *0x14(%eax)
  801829:	83 c4 10             	add    $0x10,%esp
}
  80182c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80182f:	c9                   	leave  
  801830:	c3                   	ret    
		return -E_NOT_SUPP;
  801831:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801836:	eb f4                	jmp    80182c <fstat+0x68>

00801838 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	56                   	push   %esi
  80183c:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80183d:	83 ec 08             	sub    $0x8,%esp
  801840:	6a 00                	push   $0x0
  801842:	ff 75 08             	pushl  0x8(%ebp)
  801845:	e8 e7 01 00 00       	call   801a31 <open>
  80184a:	89 c3                	mov    %eax,%ebx
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	85 c0                	test   %eax,%eax
  801851:	78 1b                	js     80186e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	ff 75 0c             	pushl  0xc(%ebp)
  801859:	50                   	push   %eax
  80185a:	e8 65 ff ff ff       	call   8017c4 <fstat>
  80185f:	89 c6                	mov    %eax,%esi
	close(fd);
  801861:	89 1c 24             	mov    %ebx,(%esp)
  801864:	e8 27 fc ff ff       	call   801490 <close>
	return r;
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	89 f3                	mov    %esi,%ebx
}
  80186e:	89 d8                	mov    %ebx,%eax
  801870:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5d                   	pop    %ebp
  801876:	c3                   	ret    

00801877 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
  80187c:	89 c6                	mov    %eax,%esi
  80187e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801880:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801887:	74 27                	je     8018b0 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801889:	6a 07                	push   $0x7
  80188b:	68 00 50 80 00       	push   $0x805000
  801890:	56                   	push   %esi
  801891:	ff 35 00 40 80 00    	pushl  0x804000
  801897:	e8 bc f9 ff ff       	call   801258 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80189c:	83 c4 0c             	add    $0xc,%esp
  80189f:	6a 00                	push   $0x0
  8018a1:	53                   	push   %ebx
  8018a2:	6a 00                	push   $0x0
  8018a4:	e8 48 f9 ff ff       	call   8011f1 <ipc_recv>
}
  8018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018b0:	83 ec 0c             	sub    $0xc,%esp
  8018b3:	6a 01                	push   $0x1
  8018b5:	e8 f2 f9 ff ff       	call   8012ac <ipc_find_env>
  8018ba:	a3 00 40 80 00       	mov    %eax,0x804000
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	eb c5                	jmp    801889 <fsipc+0x12>

008018c4 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d8:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e2:	b8 02 00 00 00       	mov    $0x2,%eax
  8018e7:	e8 8b ff ff ff       	call   801877 <fsipc>
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <devfile_flush>:
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fa:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801904:	b8 06 00 00 00       	mov    $0x6,%eax
  801909:	e8 69 ff ff ff       	call   801877 <fsipc>
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <devfile_stat>:
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	53                   	push   %ebx
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	8b 40 0c             	mov    0xc(%eax),%eax
  801920:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
  80192a:	b8 05 00 00 00       	mov    $0x5,%eax
  80192f:	e8 43 ff ff ff       	call   801877 <fsipc>
  801934:	85 c0                	test   %eax,%eax
  801936:	78 2c                	js     801964 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	68 00 50 80 00       	push   $0x805000
  801940:	53                   	push   %ebx
  801941:	e8 04 f0 ff ff       	call   80094a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801946:	a1 80 50 80 00       	mov    0x805080,%eax
  80194b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801951:	a1 84 50 80 00       	mov    0x805084,%eax
  801956:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801964:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <devfile_write>:
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 0c             	sub    $0xc,%esp
  80196f:	8b 45 10             	mov    0x10(%ebp),%eax
  801972:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801977:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80197c:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80197f:	8b 55 08             	mov    0x8(%ebp),%edx
  801982:	8b 52 0c             	mov    0xc(%edx),%edx
  801985:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  80198b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	68 08 50 80 00       	push   $0x805008
  801999:	e8 3a f1 ff ff       	call   800ad8 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80199e:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a8:	e8 ca fe ff ff       	call   801877 <fsipc>
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <devfile_read>:
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019c2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cd:	b8 03 00 00 00       	mov    $0x3,%eax
  8019d2:	e8 a0 fe ff ff       	call   801877 <fsipc>
  8019d7:	89 c3                	mov    %eax,%ebx
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	78 1f                	js     8019fc <devfile_read+0x4d>
	assert(r <= n);
  8019dd:	39 f0                	cmp    %esi,%eax
  8019df:	77 24                	ja     801a05 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019e1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019e6:	7f 33                	jg     801a1b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	50                   	push   %eax
  8019ec:	68 00 50 80 00       	push   $0x805000
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	e8 df f0 ff ff       	call   800ad8 <memmove>
	return r;
  8019f9:	83 c4 10             	add    $0x10,%esp
}
  8019fc:	89 d8                	mov    %ebx,%eax
  8019fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a01:	5b                   	pop    %ebx
  801a02:	5e                   	pop    %esi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    
	assert(r <= n);
  801a05:	68 08 2d 80 00       	push   $0x802d08
  801a0a:	68 0f 2d 80 00       	push   $0x802d0f
  801a0f:	6a 7b                	push   $0x7b
  801a11:	68 24 2d 80 00       	push   $0x802d24
  801a16:	e8 35 e8 ff ff       	call   800250 <_panic>
	assert(r <= PGSIZE);
  801a1b:	68 2f 2d 80 00       	push   $0x802d2f
  801a20:	68 0f 2d 80 00       	push   $0x802d0f
  801a25:	6a 7c                	push   $0x7c
  801a27:	68 24 2d 80 00       	push   $0x802d24
  801a2c:	e8 1f e8 ff ff       	call   800250 <_panic>

00801a31 <open>:
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	83 ec 1c             	sub    $0x1c,%esp
  801a39:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a3c:	56                   	push   %esi
  801a3d:	e8 d1 ee ff ff       	call   800913 <strlen>
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a4a:	7f 6c                	jg     801ab8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a4c:	83 ec 0c             	sub    $0xc,%esp
  801a4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a52:	50                   	push   %eax
  801a53:	e8 b4 f8 ff ff       	call   80130c <fd_alloc>
  801a58:	89 c3                	mov    %eax,%ebx
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 3c                	js     801a9d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	56                   	push   %esi
  801a65:	68 00 50 80 00       	push   $0x805000
  801a6a:	e8 db ee ff ff       	call   80094a <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a72:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801a77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	e8 f3 fd ff ff       	call   801877 <fsipc>
  801a84:	89 c3                	mov    %eax,%ebx
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	85 c0                	test   %eax,%eax
  801a8b:	78 19                	js     801aa6 <open+0x75>
	return fd2num(fd);
  801a8d:	83 ec 0c             	sub    $0xc,%esp
  801a90:	ff 75 f4             	pushl  -0xc(%ebp)
  801a93:	e8 4d f8 ff ff       	call   8012e5 <fd2num>
  801a98:	89 c3                	mov    %eax,%ebx
  801a9a:	83 c4 10             	add    $0x10,%esp
}
  801a9d:	89 d8                	mov    %ebx,%eax
  801a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa2:	5b                   	pop    %ebx
  801aa3:	5e                   	pop    %esi
  801aa4:	5d                   	pop    %ebp
  801aa5:	c3                   	ret    
		fd_close(fd, 0);
  801aa6:	83 ec 08             	sub    $0x8,%esp
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 f4             	pushl  -0xc(%ebp)
  801aae:	e8 54 f9 ff ff       	call   801407 <fd_close>
		return r;
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	eb e5                	jmp    801a9d <open+0x6c>
		return -E_BAD_PATH;
  801ab8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801abd:	eb de                	jmp    801a9d <open+0x6c>

00801abf <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aca:	b8 08 00 00 00       	mov    $0x8,%eax
  801acf:	e8 a3 fd ff ff       	call   801877 <fsipc>
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801adc:	89 d0                	mov    %edx,%eax
  801ade:	c1 e8 16             	shr    $0x16,%eax
  801ae1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801aed:	f6 c1 01             	test   $0x1,%cl
  801af0:	74 1d                	je     801b0f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  801af2:	c1 ea 0c             	shr    $0xc,%edx
  801af5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801afc:	f6 c2 01             	test   $0x1,%dl
  801aff:	74 0e                	je     801b0f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801b01:	c1 ea 0c             	shr    $0xc,%edx
  801b04:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801b0b:	ef 
  801b0c:	0f b7 c0             	movzwl %ax,%eax
}
  801b0f:	5d                   	pop    %ebp
  801b10:	c3                   	ret    

00801b11 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801b17:	68 3b 2d 80 00       	push   $0x802d3b
  801b1c:	ff 75 0c             	pushl  0xc(%ebp)
  801b1f:	e8 26 ee ff ff       	call   80094a <strcpy>
	return 0;
}
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <devsock_close>:
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	53                   	push   %ebx
  801b2f:	83 ec 10             	sub    $0x10,%esp
  801b32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b35:	53                   	push   %ebx
  801b36:	e8 9b ff ff ff       	call   801ad6 <pageref>
  801b3b:	83 c4 10             	add    $0x10,%esp
		return 0;
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801b43:	83 f8 01             	cmp    $0x1,%eax
  801b46:	74 07                	je     801b4f <devsock_close+0x24>
}
  801b48:	89 d0                	mov    %edx,%eax
  801b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801b4f:	83 ec 0c             	sub    $0xc,%esp
  801b52:	ff 73 0c             	pushl  0xc(%ebx)
  801b55:	e8 b7 02 00 00       	call   801e11 <nsipc_close>
  801b5a:	89 c2                	mov    %eax,%edx
  801b5c:	83 c4 10             	add    $0x10,%esp
  801b5f:	eb e7                	jmp    801b48 <devsock_close+0x1d>

00801b61 <devsock_write>:
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	ff 70 0c             	pushl  0xc(%eax)
  801b75:	e8 74 03 00 00       	call   801eee <nsipc_send>
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <devsock_read>:
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 10             	pushl  0x10(%ebp)
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff 70 0c             	pushl  0xc(%eax)
  801b90:	e8 ed 02 00 00       	call   801e82 <nsipc_recv>
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <fd2sockid>:
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b9d:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ba0:	52                   	push   %edx
  801ba1:	50                   	push   %eax
  801ba2:	e8 b4 f7 ff ff       	call   80135b <fd_lookup>
  801ba7:	83 c4 10             	add    $0x10,%esp
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 10                	js     801bbe <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801bb7:	39 08                	cmp    %ecx,(%eax)
  801bb9:	75 05                	jne    801bc0 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801bbb:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    
		return -E_NOT_SUPP;
  801bc0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bc5:	eb f7                	jmp    801bbe <fd2sockid+0x27>

00801bc7 <alloc_sockfd>:
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 1c             	sub    $0x1c,%esp
  801bcf:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801bd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd4:	50                   	push   %eax
  801bd5:	e8 32 f7 ff ff       	call   80130c <fd_alloc>
  801bda:	89 c3                	mov    %eax,%ebx
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 43                	js     801c26 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	68 07 04 00 00       	push   $0x407
  801beb:	ff 75 f4             	pushl  -0xc(%ebp)
  801bee:	6a 00                	push   $0x0
  801bf0:	e8 4e f1 ff ff       	call   800d43 <sys_page_alloc>
  801bf5:	89 c3                	mov    %eax,%ebx
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	78 28                	js     801c26 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c01:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c07:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c13:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c16:	83 ec 0c             	sub    $0xc,%esp
  801c19:	50                   	push   %eax
  801c1a:	e8 c6 f6 ff ff       	call   8012e5 <fd2num>
  801c1f:	89 c3                	mov    %eax,%ebx
  801c21:	83 c4 10             	add    $0x10,%esp
  801c24:	eb 0c                	jmp    801c32 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	56                   	push   %esi
  801c2a:	e8 e2 01 00 00       	call   801e11 <nsipc_close>
		return r;
  801c2f:	83 c4 10             	add    $0x10,%esp
}
  801c32:	89 d8                	mov    %ebx,%eax
  801c34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <accept>:
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	e8 4e ff ff ff       	call   801b97 <fd2sockid>
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	78 1b                	js     801c68 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	ff 75 10             	pushl  0x10(%ebp)
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	50                   	push   %eax
  801c57:	e8 0e 01 00 00       	call   801d6a <nsipc_accept>
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	78 05                	js     801c68 <accept+0x2d>
	return alloc_sockfd(r);
  801c63:	e8 5f ff ff ff       	call   801bc7 <alloc_sockfd>
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <bind>:
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	e8 1f ff ff ff       	call   801b97 <fd2sockid>
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	78 12                	js     801c8e <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801c7c:	83 ec 04             	sub    $0x4,%esp
  801c7f:	ff 75 10             	pushl  0x10(%ebp)
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	50                   	push   %eax
  801c86:	e8 2f 01 00 00       	call   801dba <nsipc_bind>
  801c8b:	83 c4 10             	add    $0x10,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <shutdown>:
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	e8 f9 fe ff ff       	call   801b97 <fd2sockid>
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 0f                	js     801cb1 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801ca2:	83 ec 08             	sub    $0x8,%esp
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	50                   	push   %eax
  801ca9:	e8 41 01 00 00       	call   801def <nsipc_shutdown>
  801cae:	83 c4 10             	add    $0x10,%esp
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <connect>:
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	e8 d6 fe ff ff       	call   801b97 <fd2sockid>
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	78 12                	js     801cd7 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	ff 75 10             	pushl  0x10(%ebp)
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	50                   	push   %eax
  801ccf:	e8 57 01 00 00       	call   801e2b <nsipc_connect>
  801cd4:	83 c4 10             	add    $0x10,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <listen>:
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	e8 b0 fe ff ff       	call   801b97 <fd2sockid>
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 0f                	js     801cfa <listen+0x21>
	return nsipc_listen(r, backlog);
  801ceb:	83 ec 08             	sub    $0x8,%esp
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	50                   	push   %eax
  801cf2:	e8 69 01 00 00       	call   801e60 <nsipc_listen>
  801cf7:	83 c4 10             	add    $0x10,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <socket>:

int
socket(int domain, int type, int protocol)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d02:	ff 75 10             	pushl  0x10(%ebp)
  801d05:	ff 75 0c             	pushl  0xc(%ebp)
  801d08:	ff 75 08             	pushl  0x8(%ebp)
  801d0b:	e8 3c 02 00 00       	call   801f4c <nsipc_socket>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 05                	js     801d1c <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801d17:	e8 ab fe ff ff       	call   801bc7 <alloc_sockfd>
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	53                   	push   %ebx
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d27:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d2e:	74 26                	je     801d56 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d30:	6a 07                	push   $0x7
  801d32:	68 00 60 80 00       	push   $0x806000
  801d37:	53                   	push   %ebx
  801d38:	ff 35 04 40 80 00    	pushl  0x804004
  801d3e:	e8 15 f5 ff ff       	call   801258 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d43:	83 c4 0c             	add    $0xc,%esp
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	e8 a0 f4 ff ff       	call   8011f1 <ipc_recv>
}
  801d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d56:	83 ec 0c             	sub    $0xc,%esp
  801d59:	6a 02                	push   $0x2
  801d5b:	e8 4c f5 ff ff       	call   8012ac <ipc_find_env>
  801d60:	a3 04 40 80 00       	mov    %eax,0x804004
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	eb c6                	jmp    801d30 <nsipc+0x12>

00801d6a <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	56                   	push   %esi
  801d6e:	53                   	push   %ebx
  801d6f:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d7a:	8b 06                	mov    (%esi),%eax
  801d7c:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	e8 93 ff ff ff       	call   801d1e <nsipc>
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	78 20                	js     801db1 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	ff 35 10 60 80 00    	pushl  0x806010
  801d9a:	68 00 60 80 00       	push   $0x806000
  801d9f:	ff 75 0c             	pushl  0xc(%ebp)
  801da2:	e8 31 ed ff ff       	call   800ad8 <memmove>
		*addrlen = ret->ret_addrlen;
  801da7:	a1 10 60 80 00       	mov    0x806010,%eax
  801dac:	89 06                	mov    %eax,(%esi)
  801dae:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801db1:	89 d8                	mov    %ebx,%eax
  801db3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	53                   	push   %ebx
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801dcc:	53                   	push   %ebx
  801dcd:	ff 75 0c             	pushl  0xc(%ebp)
  801dd0:	68 04 60 80 00       	push   $0x806004
  801dd5:	e8 fe ec ff ff       	call   800ad8 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801dda:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801de0:	b8 02 00 00 00       	mov    $0x2,%eax
  801de5:	e8 34 ff ff ff       	call   801d1e <nsipc>
}
  801dea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e05:	b8 03 00 00 00       	mov    $0x3,%eax
  801e0a:	e8 0f ff ff ff       	call   801d1e <nsipc>
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <nsipc_close>:

int
nsipc_close(int s)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e1f:	b8 04 00 00 00       	mov    $0x4,%eax
  801e24:	e8 f5 fe ff ff       	call   801d1e <nsipc>
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 08             	sub    $0x8,%esp
  801e32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e3d:	53                   	push   %ebx
  801e3e:	ff 75 0c             	pushl  0xc(%ebp)
  801e41:	68 04 60 80 00       	push   $0x806004
  801e46:	e8 8d ec ff ff       	call   800ad8 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e4b:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e51:	b8 05 00 00 00       	mov    $0x5,%eax
  801e56:	e8 c3 fe ff ff       	call   801d1e <nsipc>
}
  801e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e71:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e76:	b8 06 00 00 00       	mov    $0x6,%eax
  801e7b:	e8 9e fe ff ff       	call   801d1e <nsipc>
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	56                   	push   %esi
  801e86:	53                   	push   %ebx
  801e87:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e92:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ea0:	b8 07 00 00 00       	mov    $0x7,%eax
  801ea5:	e8 74 fe ff ff       	call   801d1e <nsipc>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	85 c0                	test   %eax,%eax
  801eae:	78 1f                	js     801ecf <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801eb0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801eb5:	7f 21                	jg     801ed8 <nsipc_recv+0x56>
  801eb7:	39 c6                	cmp    %eax,%esi
  801eb9:	7c 1d                	jl     801ed8 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	50                   	push   %eax
  801ebf:	68 00 60 80 00       	push   $0x806000
  801ec4:	ff 75 0c             	pushl  0xc(%ebp)
  801ec7:	e8 0c ec ff ff       	call   800ad8 <memmove>
  801ecc:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ecf:	89 d8                	mov    %ebx,%eax
  801ed1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5e                   	pop    %esi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ed8:	68 47 2d 80 00       	push   $0x802d47
  801edd:	68 0f 2d 80 00       	push   $0x802d0f
  801ee2:	6a 62                	push   $0x62
  801ee4:	68 5c 2d 80 00       	push   $0x802d5c
  801ee9:	e8 62 e3 ff ff       	call   800250 <_panic>

00801eee <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 04             	sub    $0x4,%esp
  801ef5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f00:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f06:	7f 2e                	jg     801f36 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	53                   	push   %ebx
  801f0c:	ff 75 0c             	pushl  0xc(%ebp)
  801f0f:	68 0c 60 80 00       	push   $0x80600c
  801f14:	e8 bf eb ff ff       	call   800ad8 <memmove>
	nsipcbuf.send.req_size = size;
  801f19:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f1f:	8b 45 14             	mov    0x14(%ebp),%eax
  801f22:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f27:	b8 08 00 00 00       	mov    $0x8,%eax
  801f2c:	e8 ed fd ff ff       	call   801d1e <nsipc>
}
  801f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    
	assert(size < 1600);
  801f36:	68 68 2d 80 00       	push   $0x802d68
  801f3b:	68 0f 2d 80 00       	push   $0x802d0f
  801f40:	6a 6d                	push   $0x6d
  801f42:	68 5c 2d 80 00       	push   $0x802d5c
  801f47:	e8 04 e3 ff ff       	call   800250 <_panic>

00801f4c <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5d:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f62:	8b 45 10             	mov    0x10(%ebp),%eax
  801f65:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f6a:	b8 09 00 00 00       	mov    $0x9,%eax
  801f6f:	e8 aa fd ff ff       	call   801d1e <nsipc>
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	ff 75 08             	pushl  0x8(%ebp)
  801f84:	e8 6c f3 ff ff       	call   8012f5 <fd2data>
  801f89:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f8b:	83 c4 08             	add    $0x8,%esp
  801f8e:	68 74 2d 80 00       	push   $0x802d74
  801f93:	53                   	push   %ebx
  801f94:	e8 b1 e9 ff ff       	call   80094a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f99:	8b 46 04             	mov    0x4(%esi),%eax
  801f9c:	2b 06                	sub    (%esi),%eax
  801f9e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fa4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fab:	00 00 00 
	stat->st_dev = &devpipe;
  801fae:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801fb5:	30 80 00 
	return 0;
}
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	53                   	push   %ebx
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fce:	53                   	push   %ebx
  801fcf:	6a 00                	push   $0x0
  801fd1:	e8 f2 ed ff ff       	call   800dc8 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd6:	89 1c 24             	mov    %ebx,(%esp)
  801fd9:	e8 17 f3 ff ff       	call   8012f5 <fd2data>
  801fde:	83 c4 08             	add    $0x8,%esp
  801fe1:	50                   	push   %eax
  801fe2:	6a 00                	push   $0x0
  801fe4:	e8 df ed ff ff       	call   800dc8 <sys_page_unmap>
}
  801fe9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <_pipeisclosed>:
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	57                   	push   %edi
  801ff2:	56                   	push   %esi
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 1c             	sub    $0x1c,%esp
  801ff7:	89 c7                	mov    %eax,%edi
  801ff9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ffb:	a1 08 40 80 00       	mov    0x804008,%eax
  802000:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	57                   	push   %edi
  802007:	e8 ca fa ff ff       	call   801ad6 <pageref>
  80200c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80200f:	89 34 24             	mov    %esi,(%esp)
  802012:	e8 bf fa ff ff       	call   801ad6 <pageref>
		nn = thisenv->env_runs;
  802017:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80201d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	39 cb                	cmp    %ecx,%ebx
  802025:	74 1b                	je     802042 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802027:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80202a:	75 cf                	jne    801ffb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80202c:	8b 42 58             	mov    0x58(%edx),%eax
  80202f:	6a 01                	push   $0x1
  802031:	50                   	push   %eax
  802032:	53                   	push   %ebx
  802033:	68 7b 2d 80 00       	push   $0x802d7b
  802038:	e8 ee e2 ff ff       	call   80032b <cprintf>
  80203d:	83 c4 10             	add    $0x10,%esp
  802040:	eb b9                	jmp    801ffb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802042:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802045:	0f 94 c0             	sete   %al
  802048:	0f b6 c0             	movzbl %al,%eax
}
  80204b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80204e:	5b                   	pop    %ebx
  80204f:	5e                   	pop    %esi
  802050:	5f                   	pop    %edi
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <devpipe_write>:
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	57                   	push   %edi
  802057:	56                   	push   %esi
  802058:	53                   	push   %ebx
  802059:	83 ec 28             	sub    $0x28,%esp
  80205c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80205f:	56                   	push   %esi
  802060:	e8 90 f2 ff ff       	call   8012f5 <fd2data>
  802065:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	bf 00 00 00 00       	mov    $0x0,%edi
  80206f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802072:	74 4f                	je     8020c3 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802074:	8b 43 04             	mov    0x4(%ebx),%eax
  802077:	8b 0b                	mov    (%ebx),%ecx
  802079:	8d 51 20             	lea    0x20(%ecx),%edx
  80207c:	39 d0                	cmp    %edx,%eax
  80207e:	72 14                	jb     802094 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802080:	89 da                	mov    %ebx,%edx
  802082:	89 f0                	mov    %esi,%eax
  802084:	e8 65 ff ff ff       	call   801fee <_pipeisclosed>
  802089:	85 c0                	test   %eax,%eax
  80208b:	75 3a                	jne    8020c7 <devpipe_write+0x74>
			sys_yield();
  80208d:	e8 92 ec ff ff       	call   800d24 <sys_yield>
  802092:	eb e0                	jmp    802074 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802094:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802097:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80209b:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80209e:	89 c2                	mov    %eax,%edx
  8020a0:	c1 fa 1f             	sar    $0x1f,%edx
  8020a3:	89 d1                	mov    %edx,%ecx
  8020a5:	c1 e9 1b             	shr    $0x1b,%ecx
  8020a8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  8020ab:	83 e2 1f             	and    $0x1f,%edx
  8020ae:	29 ca                	sub    %ecx,%edx
  8020b0:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  8020b4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8020b8:	83 c0 01             	add    $0x1,%eax
  8020bb:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020be:	83 c7 01             	add    $0x1,%edi
  8020c1:	eb ac                	jmp    80206f <devpipe_write+0x1c>
	return i;
  8020c3:	89 f8                	mov    %edi,%eax
  8020c5:	eb 05                	jmp    8020cc <devpipe_write+0x79>
				return 0;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    

008020d4 <devpipe_read>:
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	57                   	push   %edi
  8020d8:	56                   	push   %esi
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 18             	sub    $0x18,%esp
  8020dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8020e0:	57                   	push   %edi
  8020e1:	e8 0f f2 ff ff       	call   8012f5 <fd2data>
  8020e6:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	be 00 00 00 00       	mov    $0x0,%esi
  8020f0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f3:	74 47                	je     80213c <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  8020f5:	8b 03                	mov    (%ebx),%eax
  8020f7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020fa:	75 22                	jne    80211e <devpipe_read+0x4a>
			if (i > 0)
  8020fc:	85 f6                	test   %esi,%esi
  8020fe:	75 14                	jne    802114 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  802100:	89 da                	mov    %ebx,%edx
  802102:	89 f8                	mov    %edi,%eax
  802104:	e8 e5 fe ff ff       	call   801fee <_pipeisclosed>
  802109:	85 c0                	test   %eax,%eax
  80210b:	75 33                	jne    802140 <devpipe_read+0x6c>
			sys_yield();
  80210d:	e8 12 ec ff ff       	call   800d24 <sys_yield>
  802112:	eb e1                	jmp    8020f5 <devpipe_read+0x21>
				return i;
  802114:	89 f0                	mov    %esi,%eax
}
  802116:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802119:	5b                   	pop    %ebx
  80211a:	5e                   	pop    %esi
  80211b:	5f                   	pop    %edi
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80211e:	99                   	cltd   
  80211f:	c1 ea 1b             	shr    $0x1b,%edx
  802122:	01 d0                	add    %edx,%eax
  802124:	83 e0 1f             	and    $0x1f,%eax
  802127:	29 d0                	sub    %edx,%eax
  802129:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80212e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802131:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802134:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802137:	83 c6 01             	add    $0x1,%esi
  80213a:	eb b4                	jmp    8020f0 <devpipe_read+0x1c>
	return i;
  80213c:	89 f0                	mov    %esi,%eax
  80213e:	eb d6                	jmp    802116 <devpipe_read+0x42>
				return 0;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
  802145:	eb cf                	jmp    802116 <devpipe_read+0x42>

00802147 <pipe>:
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	56                   	push   %esi
  80214b:	53                   	push   %ebx
  80214c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80214f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802152:	50                   	push   %eax
  802153:	e8 b4 f1 ff ff       	call   80130c <fd_alloc>
  802158:	89 c3                	mov    %eax,%ebx
  80215a:	83 c4 10             	add    $0x10,%esp
  80215d:	85 c0                	test   %eax,%eax
  80215f:	78 5b                	js     8021bc <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 07 04 00 00       	push   $0x407
  802169:	ff 75 f4             	pushl  -0xc(%ebp)
  80216c:	6a 00                	push   $0x0
  80216e:	e8 d0 eb ff ff       	call   800d43 <sys_page_alloc>
  802173:	89 c3                	mov    %eax,%ebx
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 40                	js     8021bc <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802182:	50                   	push   %eax
  802183:	e8 84 f1 ff ff       	call   80130c <fd_alloc>
  802188:	89 c3                	mov    %eax,%ebx
  80218a:	83 c4 10             	add    $0x10,%esp
  80218d:	85 c0                	test   %eax,%eax
  80218f:	78 1b                	js     8021ac <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 07 04 00 00       	push   $0x407
  802199:	ff 75 f0             	pushl  -0x10(%ebp)
  80219c:	6a 00                	push   $0x0
  80219e:	e8 a0 eb ff ff       	call   800d43 <sys_page_alloc>
  8021a3:	89 c3                	mov    %eax,%ebx
  8021a5:	83 c4 10             	add    $0x10,%esp
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	79 19                	jns    8021c5 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8021ac:	83 ec 08             	sub    $0x8,%esp
  8021af:	ff 75 f4             	pushl  -0xc(%ebp)
  8021b2:	6a 00                	push   $0x0
  8021b4:	e8 0f ec ff ff       	call   800dc8 <sys_page_unmap>
  8021b9:	83 c4 10             	add    $0x10,%esp
}
  8021bc:	89 d8                	mov    %ebx,%eax
  8021be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5d                   	pop    %ebp
  8021c4:	c3                   	ret    
	va = fd2data(fd0);
  8021c5:	83 ec 0c             	sub    $0xc,%esp
  8021c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8021cb:	e8 25 f1 ff ff       	call   8012f5 <fd2data>
  8021d0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d2:	83 c4 0c             	add    $0xc,%esp
  8021d5:	68 07 04 00 00       	push   $0x407
  8021da:	50                   	push   %eax
  8021db:	6a 00                	push   $0x0
  8021dd:	e8 61 eb ff ff       	call   800d43 <sys_page_alloc>
  8021e2:	89 c3                	mov    %eax,%ebx
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	0f 88 8c 00 00 00    	js     80227b <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ef:	83 ec 0c             	sub    $0xc,%esp
  8021f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f5:	e8 fb f0 ff ff       	call   8012f5 <fd2data>
  8021fa:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802201:	50                   	push   %eax
  802202:	6a 00                	push   $0x0
  802204:	56                   	push   %esi
  802205:	6a 00                	push   $0x0
  802207:	e8 7a eb ff ff       	call   800d86 <sys_page_map>
  80220c:	89 c3                	mov    %eax,%ebx
  80220e:	83 c4 20             	add    $0x20,%esp
  802211:	85 c0                	test   %eax,%eax
  802213:	78 58                	js     80226d <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80221e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802233:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802238:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80223f:	83 ec 0c             	sub    $0xc,%esp
  802242:	ff 75 f4             	pushl  -0xc(%ebp)
  802245:	e8 9b f0 ff ff       	call   8012e5 <fd2num>
  80224a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80224d:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80224f:	83 c4 04             	add    $0x4,%esp
  802252:	ff 75 f0             	pushl  -0x10(%ebp)
  802255:	e8 8b f0 ff ff       	call   8012e5 <fd2num>
  80225a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225d:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	bb 00 00 00 00       	mov    $0x0,%ebx
  802268:	e9 4f ff ff ff       	jmp    8021bc <pipe+0x75>
	sys_page_unmap(0, va);
  80226d:	83 ec 08             	sub    $0x8,%esp
  802270:	56                   	push   %esi
  802271:	6a 00                	push   $0x0
  802273:	e8 50 eb ff ff       	call   800dc8 <sys_page_unmap>
  802278:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80227b:	83 ec 08             	sub    $0x8,%esp
  80227e:	ff 75 f0             	pushl  -0x10(%ebp)
  802281:	6a 00                	push   $0x0
  802283:	e8 40 eb ff ff       	call   800dc8 <sys_page_unmap>
  802288:	83 c4 10             	add    $0x10,%esp
  80228b:	e9 1c ff ff ff       	jmp    8021ac <pipe+0x65>

00802290 <pipeisclosed>:
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802296:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802299:	50                   	push   %eax
  80229a:	ff 75 08             	pushl  0x8(%ebp)
  80229d:	e8 b9 f0 ff ff       	call   80135b <fd_lookup>
  8022a2:	83 c4 10             	add    $0x10,%esp
  8022a5:	85 c0                	test   %eax,%eax
  8022a7:	78 18                	js     8022c1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022a9:	83 ec 0c             	sub    $0xc,%esp
  8022ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8022af:	e8 41 f0 ff ff       	call   8012f5 <fd2data>
	return _pipeisclosed(fd, p);
  8022b4:	89 c2                	mov    %eax,%edx
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	e8 30 fd ff ff       	call   801fee <_pipeisclosed>
  8022be:	83 c4 10             	add    $0x10,%esp
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cb:	5d                   	pop    %ebp
  8022cc:	c3                   	ret    

008022cd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
  8022d0:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8022d3:	68 93 2d 80 00       	push   $0x802d93
  8022d8:	ff 75 0c             	pushl  0xc(%ebp)
  8022db:	e8 6a e6 ff ff       	call   80094a <strcpy>
	return 0;
}
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <devcons_write>:
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
  8022ea:	57                   	push   %edi
  8022eb:	56                   	push   %esi
  8022ec:	53                   	push   %ebx
  8022ed:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8022f3:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8022f8:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8022fe:	eb 2f                	jmp    80232f <devcons_write+0x48>
		m = n - tot;
  802300:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802303:	29 f3                	sub    %esi,%ebx
  802305:	83 fb 7f             	cmp    $0x7f,%ebx
  802308:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80230d:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	53                   	push   %ebx
  802314:	89 f0                	mov    %esi,%eax
  802316:	03 45 0c             	add    0xc(%ebp),%eax
  802319:	50                   	push   %eax
  80231a:	57                   	push   %edi
  80231b:	e8 b8 e7 ff ff       	call   800ad8 <memmove>
		sys_cputs(buf, m);
  802320:	83 c4 08             	add    $0x8,%esp
  802323:	53                   	push   %ebx
  802324:	57                   	push   %edi
  802325:	e8 5d e9 ff ff       	call   800c87 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80232a:	01 de                	add    %ebx,%esi
  80232c:	83 c4 10             	add    $0x10,%esp
  80232f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802332:	72 cc                	jb     802300 <devcons_write+0x19>
}
  802334:	89 f0                	mov    %esi,%eax
  802336:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802339:	5b                   	pop    %ebx
  80233a:	5e                   	pop    %esi
  80233b:	5f                   	pop    %edi
  80233c:	5d                   	pop    %ebp
  80233d:	c3                   	ret    

0080233e <devcons_read>:
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	83 ec 08             	sub    $0x8,%esp
  802344:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802349:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80234d:	75 07                	jne    802356 <devcons_read+0x18>
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    
		sys_yield();
  802351:	e8 ce e9 ff ff       	call   800d24 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802356:	e8 4a e9 ff ff       	call   800ca5 <sys_cgetc>
  80235b:	85 c0                	test   %eax,%eax
  80235d:	74 f2                	je     802351 <devcons_read+0x13>
	if (c < 0)
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 ec                	js     80234f <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802363:	83 f8 04             	cmp    $0x4,%eax
  802366:	74 0c                	je     802374 <devcons_read+0x36>
	*(char*)vbuf = c;
  802368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236b:	88 02                	mov    %al,(%edx)
	return 1;
  80236d:	b8 01 00 00 00       	mov    $0x1,%eax
  802372:	eb db                	jmp    80234f <devcons_read+0x11>
		return 0;
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
  802379:	eb d4                	jmp    80234f <devcons_read+0x11>

0080237b <cputchar>:
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802387:	6a 01                	push   $0x1
  802389:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80238c:	50                   	push   %eax
  80238d:	e8 f5 e8 ff ff       	call   800c87 <sys_cputs>
}
  802392:	83 c4 10             	add    $0x10,%esp
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <getchar>:
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80239d:	6a 01                	push   $0x1
  80239f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a2:	50                   	push   %eax
  8023a3:	6a 00                	push   $0x0
  8023a5:	e8 22 f2 ff ff       	call   8015cc <read>
	if (r < 0)
  8023aa:	83 c4 10             	add    $0x10,%esp
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	78 08                	js     8023b9 <getchar+0x22>
	if (r < 1)
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	7e 06                	jle    8023bb <getchar+0x24>
	return c;
  8023b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    
		return -E_EOF;
  8023bb:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8023c0:	eb f7                	jmp    8023b9 <getchar+0x22>

008023c2 <iscons>:
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023cb:	50                   	push   %eax
  8023cc:	ff 75 08             	pushl  0x8(%ebp)
  8023cf:	e8 87 ef ff ff       	call   80135b <fd_lookup>
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	78 11                	js     8023ec <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023e4:	39 10                	cmp    %edx,(%eax)
  8023e6:	0f 94 c0             	sete   %al
  8023e9:	0f b6 c0             	movzbl %al,%eax
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <opencons>:
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8023f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f7:	50                   	push   %eax
  8023f8:	e8 0f ef ff ff       	call   80130c <fd_alloc>
  8023fd:	83 c4 10             	add    $0x10,%esp
  802400:	85 c0                	test   %eax,%eax
  802402:	78 3a                	js     80243e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802404:	83 ec 04             	sub    $0x4,%esp
  802407:	68 07 04 00 00       	push   $0x407
  80240c:	ff 75 f4             	pushl  -0xc(%ebp)
  80240f:	6a 00                	push   $0x0
  802411:	e8 2d e9 ff ff       	call   800d43 <sys_page_alloc>
  802416:	83 c4 10             	add    $0x10,%esp
  802419:	85 c0                	test   %eax,%eax
  80241b:	78 21                	js     80243e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802426:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802432:	83 ec 0c             	sub    $0xc,%esp
  802435:	50                   	push   %eax
  802436:	e8 aa ee ff ff       	call   8012e5 <fd2num>
  80243b:	83 c4 10             	add    $0x10,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  802446:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  80244d:	74 0a                	je     802459 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802459:	a1 08 40 80 00       	mov    0x804008,%eax
  80245e:	8b 40 48             	mov    0x48(%eax),%eax
  802461:	83 ec 04             	sub    $0x4,%esp
  802464:	6a 07                	push   $0x7
  802466:	68 00 f0 bf ee       	push   $0xeebff000
  80246b:	50                   	push   %eax
  80246c:	e8 d2 e8 ff ff       	call   800d43 <sys_page_alloc>
  802471:	83 c4 10             	add    $0x10,%esp
  802474:	85 c0                	test   %eax,%eax
  802476:	78 1b                	js     802493 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802478:	a1 08 40 80 00       	mov    0x804008,%eax
  80247d:	8b 40 48             	mov    0x48(%eax),%eax
  802480:	83 ec 08             	sub    $0x8,%esp
  802483:	68 a5 24 80 00       	push   $0x8024a5
  802488:	50                   	push   %eax
  802489:	e8 00 ea ff ff       	call   800e8e <sys_env_set_pgfault_upcall>
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	eb bc                	jmp    80244f <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802493:	50                   	push   %eax
  802494:	68 9f 2d 80 00       	push   $0x802d9f
  802499:	6a 22                	push   $0x22
  80249b:	68 b7 2d 80 00       	push   $0x802db7
  8024a0:	e8 ab dd ff ff       	call   800250 <_panic>

008024a5 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024a5:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024a6:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8024ab:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024ad:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8024b0:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8024b4:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8024b7:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8024bb:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8024bf:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8024c1:	83 c4 08             	add    $0x8,%esp
	popal
  8024c4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8024c5:	83 c4 04             	add    $0x4,%esp
	popfl
  8024c8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8024c9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8024ca:	c3                   	ret    
  8024cb:	66 90                	xchg   %ax,%ax
  8024cd:	66 90                	xchg   %ax,%ax
  8024cf:	90                   	nop

008024d0 <__udivdi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 1c             	sub    $0x1c,%esp
  8024d7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8024db:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8024df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8024e3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8024e7:	85 d2                	test   %edx,%edx
  8024e9:	75 35                	jne    802520 <__udivdi3+0x50>
  8024eb:	39 f3                	cmp    %esi,%ebx
  8024ed:	0f 87 bd 00 00 00    	ja     8025b0 <__udivdi3+0xe0>
  8024f3:	85 db                	test   %ebx,%ebx
  8024f5:	89 d9                	mov    %ebx,%ecx
  8024f7:	75 0b                	jne    802504 <__udivdi3+0x34>
  8024f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fe:	31 d2                	xor    %edx,%edx
  802500:	f7 f3                	div    %ebx
  802502:	89 c1                	mov    %eax,%ecx
  802504:	31 d2                	xor    %edx,%edx
  802506:	89 f0                	mov    %esi,%eax
  802508:	f7 f1                	div    %ecx
  80250a:	89 c6                	mov    %eax,%esi
  80250c:	89 e8                	mov    %ebp,%eax
  80250e:	89 f7                	mov    %esi,%edi
  802510:	f7 f1                	div    %ecx
  802512:	89 fa                	mov    %edi,%edx
  802514:	83 c4 1c             	add    $0x1c,%esp
  802517:	5b                   	pop    %ebx
  802518:	5e                   	pop    %esi
  802519:	5f                   	pop    %edi
  80251a:	5d                   	pop    %ebp
  80251b:	c3                   	ret    
  80251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802520:	39 f2                	cmp    %esi,%edx
  802522:	77 7c                	ja     8025a0 <__udivdi3+0xd0>
  802524:	0f bd fa             	bsr    %edx,%edi
  802527:	83 f7 1f             	xor    $0x1f,%edi
  80252a:	0f 84 98 00 00 00    	je     8025c8 <__udivdi3+0xf8>
  802530:	89 f9                	mov    %edi,%ecx
  802532:	b8 20 00 00 00       	mov    $0x20,%eax
  802537:	29 f8                	sub    %edi,%eax
  802539:	d3 e2                	shl    %cl,%edx
  80253b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80253f:	89 c1                	mov    %eax,%ecx
  802541:	89 da                	mov    %ebx,%edx
  802543:	d3 ea                	shr    %cl,%edx
  802545:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802549:	09 d1                	or     %edx,%ecx
  80254b:	89 f2                	mov    %esi,%edx
  80254d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802551:	89 f9                	mov    %edi,%ecx
  802553:	d3 e3                	shl    %cl,%ebx
  802555:	89 c1                	mov    %eax,%ecx
  802557:	d3 ea                	shr    %cl,%edx
  802559:	89 f9                	mov    %edi,%ecx
  80255b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80255f:	d3 e6                	shl    %cl,%esi
  802561:	89 eb                	mov    %ebp,%ebx
  802563:	89 c1                	mov    %eax,%ecx
  802565:	d3 eb                	shr    %cl,%ebx
  802567:	09 de                	or     %ebx,%esi
  802569:	89 f0                	mov    %esi,%eax
  80256b:	f7 74 24 08          	divl   0x8(%esp)
  80256f:	89 d6                	mov    %edx,%esi
  802571:	89 c3                	mov    %eax,%ebx
  802573:	f7 64 24 0c          	mull   0xc(%esp)
  802577:	39 d6                	cmp    %edx,%esi
  802579:	72 0c                	jb     802587 <__udivdi3+0xb7>
  80257b:	89 f9                	mov    %edi,%ecx
  80257d:	d3 e5                	shl    %cl,%ebp
  80257f:	39 c5                	cmp    %eax,%ebp
  802581:	73 5d                	jae    8025e0 <__udivdi3+0x110>
  802583:	39 d6                	cmp    %edx,%esi
  802585:	75 59                	jne    8025e0 <__udivdi3+0x110>
  802587:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80258a:	31 ff                	xor    %edi,%edi
  80258c:	89 fa                	mov    %edi,%edx
  80258e:	83 c4 1c             	add    $0x1c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    
  802596:	8d 76 00             	lea    0x0(%esi),%esi
  802599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8025a0:	31 ff                	xor    %edi,%edi
  8025a2:	31 c0                	xor    %eax,%eax
  8025a4:	89 fa                	mov    %edi,%edx
  8025a6:	83 c4 1c             	add    $0x1c,%esp
  8025a9:	5b                   	pop    %ebx
  8025aa:	5e                   	pop    %esi
  8025ab:	5f                   	pop    %edi
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    
  8025ae:	66 90                	xchg   %ax,%ax
  8025b0:	31 ff                	xor    %edi,%edi
  8025b2:	89 e8                	mov    %ebp,%eax
  8025b4:	89 f2                	mov    %esi,%edx
  8025b6:	f7 f3                	div    %ebx
  8025b8:	89 fa                	mov    %edi,%edx
  8025ba:	83 c4 1c             	add    $0x1c,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5e                   	pop    %esi
  8025bf:	5f                   	pop    %edi
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    
  8025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c8:	39 f2                	cmp    %esi,%edx
  8025ca:	72 06                	jb     8025d2 <__udivdi3+0x102>
  8025cc:	31 c0                	xor    %eax,%eax
  8025ce:	39 eb                	cmp    %ebp,%ebx
  8025d0:	77 d2                	ja     8025a4 <__udivdi3+0xd4>
  8025d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d7:	eb cb                	jmp    8025a4 <__udivdi3+0xd4>
  8025d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	89 d8                	mov    %ebx,%eax
  8025e2:	31 ff                	xor    %edi,%edi
  8025e4:	eb be                	jmp    8025a4 <__udivdi3+0xd4>
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	66 90                	xchg   %ax,%ax
  8025ea:	66 90                	xchg   %ax,%ax
  8025ec:	66 90                	xchg   %ax,%ax
  8025ee:	66 90                	xchg   %ax,%ax

008025f0 <__umoddi3>:
  8025f0:	55                   	push   %ebp
  8025f1:	57                   	push   %edi
  8025f2:	56                   	push   %esi
  8025f3:	53                   	push   %ebx
  8025f4:	83 ec 1c             	sub    $0x1c,%esp
  8025f7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8025fb:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025ff:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802603:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802607:	85 ed                	test   %ebp,%ebp
  802609:	89 f0                	mov    %esi,%eax
  80260b:	89 da                	mov    %ebx,%edx
  80260d:	75 19                	jne    802628 <__umoddi3+0x38>
  80260f:	39 df                	cmp    %ebx,%edi
  802611:	0f 86 b1 00 00 00    	jbe    8026c8 <__umoddi3+0xd8>
  802617:	f7 f7                	div    %edi
  802619:	89 d0                	mov    %edx,%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	83 c4 1c             	add    $0x1c,%esp
  802620:	5b                   	pop    %ebx
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	39 dd                	cmp    %ebx,%ebp
  80262a:	77 f1                	ja     80261d <__umoddi3+0x2d>
  80262c:	0f bd cd             	bsr    %ebp,%ecx
  80262f:	83 f1 1f             	xor    $0x1f,%ecx
  802632:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802636:	0f 84 b4 00 00 00    	je     8026f0 <__umoddi3+0x100>
  80263c:	b8 20 00 00 00       	mov    $0x20,%eax
  802641:	89 c2                	mov    %eax,%edx
  802643:	8b 44 24 04          	mov    0x4(%esp),%eax
  802647:	29 c2                	sub    %eax,%edx
  802649:	89 c1                	mov    %eax,%ecx
  80264b:	89 f8                	mov    %edi,%eax
  80264d:	d3 e5                	shl    %cl,%ebp
  80264f:	89 d1                	mov    %edx,%ecx
  802651:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802655:	d3 e8                	shr    %cl,%eax
  802657:	09 c5                	or     %eax,%ebp
  802659:	8b 44 24 04          	mov    0x4(%esp),%eax
  80265d:	89 c1                	mov    %eax,%ecx
  80265f:	d3 e7                	shl    %cl,%edi
  802661:	89 d1                	mov    %edx,%ecx
  802663:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802667:	89 df                	mov    %ebx,%edi
  802669:	d3 ef                	shr    %cl,%edi
  80266b:	89 c1                	mov    %eax,%ecx
  80266d:	89 f0                	mov    %esi,%eax
  80266f:	d3 e3                	shl    %cl,%ebx
  802671:	89 d1                	mov    %edx,%ecx
  802673:	89 fa                	mov    %edi,%edx
  802675:	d3 e8                	shr    %cl,%eax
  802677:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80267c:	09 d8                	or     %ebx,%eax
  80267e:	f7 f5                	div    %ebp
  802680:	d3 e6                	shl    %cl,%esi
  802682:	89 d1                	mov    %edx,%ecx
  802684:	f7 64 24 08          	mull   0x8(%esp)
  802688:	39 d1                	cmp    %edx,%ecx
  80268a:	89 c3                	mov    %eax,%ebx
  80268c:	89 d7                	mov    %edx,%edi
  80268e:	72 06                	jb     802696 <__umoddi3+0xa6>
  802690:	75 0e                	jne    8026a0 <__umoddi3+0xb0>
  802692:	39 c6                	cmp    %eax,%esi
  802694:	73 0a                	jae    8026a0 <__umoddi3+0xb0>
  802696:	2b 44 24 08          	sub    0x8(%esp),%eax
  80269a:	19 ea                	sbb    %ebp,%edx
  80269c:	89 d7                	mov    %edx,%edi
  80269e:	89 c3                	mov    %eax,%ebx
  8026a0:	89 ca                	mov    %ecx,%edx
  8026a2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8026a7:	29 de                	sub    %ebx,%esi
  8026a9:	19 fa                	sbb    %edi,%edx
  8026ab:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8026af:	89 d0                	mov    %edx,%eax
  8026b1:	d3 e0                	shl    %cl,%eax
  8026b3:	89 d9                	mov    %ebx,%ecx
  8026b5:	d3 ee                	shr    %cl,%esi
  8026b7:	d3 ea                	shr    %cl,%edx
  8026b9:	09 f0                	or     %esi,%eax
  8026bb:	83 c4 1c             	add    $0x1c,%esp
  8026be:	5b                   	pop    %ebx
  8026bf:	5e                   	pop    %esi
  8026c0:	5f                   	pop    %edi
  8026c1:	5d                   	pop    %ebp
  8026c2:	c3                   	ret    
  8026c3:	90                   	nop
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	85 ff                	test   %edi,%edi
  8026ca:	89 f9                	mov    %edi,%ecx
  8026cc:	75 0b                	jne    8026d9 <__umoddi3+0xe9>
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	31 d2                	xor    %edx,%edx
  8026d5:	f7 f7                	div    %edi
  8026d7:	89 c1                	mov    %eax,%ecx
  8026d9:	89 d8                	mov    %ebx,%eax
  8026db:	31 d2                	xor    %edx,%edx
  8026dd:	f7 f1                	div    %ecx
  8026df:	89 f0                	mov    %esi,%eax
  8026e1:	f7 f1                	div    %ecx
  8026e3:	e9 31 ff ff ff       	jmp    802619 <__umoddi3+0x29>
  8026e8:	90                   	nop
  8026e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	39 dd                	cmp    %ebx,%ebp
  8026f2:	72 08                	jb     8026fc <__umoddi3+0x10c>
  8026f4:	39 f7                	cmp    %esi,%edi
  8026f6:	0f 87 21 ff ff ff    	ja     80261d <__umoddi3+0x2d>
  8026fc:	89 da                	mov    %ebx,%edx
  8026fe:	89 f0                	mov    %esi,%eax
  802700:	29 f8                	sub    %edi,%eax
  802702:	19 ea                	sbb    %ebp,%edx
  802704:	e9 14 ff ff ff       	jmp    80261d <__umoddi3+0x2d>

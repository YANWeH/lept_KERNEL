
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 40 27 80 00       	push   $0x802740
  800043:	e8 d1 18 00 00       	call   801919 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 01 01 00 00    	js     800156 <umain+0x123>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 a4 15 00 00       	call   801604 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 c8 14 00 00       	call   80153b <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e8 00 00 00    	jle    800168 <umain+0x135>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 83 0f 00 00       	call   801008 <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 eb 00 00 00    	js     80017a <umain+0x147>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	85 c0                	test   %eax,%eax
  800091:	75 7b                	jne    80010e <umain+0xdb>
		seek(fd, 0);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	6a 00                	push   $0x0
  800098:	53                   	push   %ebx
  800099:	e8 66 15 00 00       	call   801604 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009e:	c7 04 24 b0 27 80 00 	movl   $0x8027b0,(%esp)
  8000a5:	e8 5d 02 00 00       	call   800307 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 02 00 00       	push   $0x200
  8000b2:	68 20 40 80 00       	push   $0x804020
  8000b7:	53                   	push   %ebx
  8000b8:	e8 7e 14 00 00       	call   80153b <readn>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	39 c6                	cmp    %eax,%esi
  8000c2:	0f 85 c4 00 00 00    	jne    80018c <umain+0x159>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	56                   	push   %esi
  8000cc:	68 20 40 80 00       	push   $0x804020
  8000d1:	68 20 42 80 00       	push   $0x804220
  8000d6:	e8 54 0a 00 00       	call   800b2f <memcmp>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 85 bc 00 00 00    	jne    8001a2 <umain+0x16f>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 7b 27 80 00       	push   $0x80277b
  8000ee:	e8 14 02 00 00       	call   800307 <cprintf>
		seek(fd, 0);
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	53                   	push   %ebx
  8000f9:	e8 06 15 00 00       	call   801604 <seek>
		close(fd);
  8000fe:	89 1c 24             	mov    %ebx,(%esp)
  800101:	e8 72 12 00 00       	call   801378 <close>
		exit();
  800106:	e8 07 01 00 00       	call   800212 <exit>
  80010b:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	57                   	push   %edi
  800112:	e8 59 20 00 00       	call   802170 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800117:	83 c4 0c             	add    $0xc,%esp
  80011a:	68 00 02 00 00       	push   $0x200
  80011f:	68 20 40 80 00       	push   $0x804020
  800124:	53                   	push   %ebx
  800125:	e8 11 14 00 00       	call   80153b <readn>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	39 c6                	cmp    %eax,%esi
  80012f:	0f 85 81 00 00 00    	jne    8001b6 <umain+0x183>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 94 27 80 00       	push   $0x802794
  80013d:	e8 c5 01 00 00       	call   800307 <cprintf>
	close(fd);
  800142:	89 1c 24             	mov    %ebx,(%esp)
  800145:	e8 2e 12 00 00       	call   801378 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014a:	cc                   	int3   

	breakpoint();
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    
		panic("open motd: %e", fd);
  800156:	50                   	push   %eax
  800157:	68 45 27 80 00       	push   $0x802745
  80015c:	6a 0c                	push   $0xc
  80015e:	68 53 27 80 00       	push   $0x802753
  800163:	e8 c4 00 00 00       	call   80022c <_panic>
		panic("readn: %e", n);
  800168:	50                   	push   %eax
  800169:	68 68 27 80 00       	push   $0x802768
  80016e:	6a 0f                	push   $0xf
  800170:	68 53 27 80 00       	push   $0x802753
  800175:	e8 b2 00 00 00       	call   80022c <_panic>
		panic("fork: %e", r);
  80017a:	50                   	push   %eax
  80017b:	68 72 27 80 00       	push   $0x802772
  800180:	6a 12                	push   $0x12
  800182:	68 53 27 80 00       	push   $0x802753
  800187:	e8 a0 00 00 00       	call   80022c <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	56                   	push   %esi
  800191:	68 f4 27 80 00       	push   $0x8027f4
  800196:	6a 17                	push   $0x17
  800198:	68 53 27 80 00       	push   $0x802753
  80019d:	e8 8a 00 00 00       	call   80022c <_panic>
			panic("read in parent got different bytes from read in child");
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 20 28 80 00       	push   $0x802820
  8001aa:	6a 19                	push   $0x19
  8001ac:	68 53 27 80 00       	push   $0x802753
  8001b1:	e8 76 00 00 00       	call   80022c <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	56                   	push   %esi
  8001bb:	68 58 28 80 00       	push   $0x802858
  8001c0:	6a 21                	push   $0x21
  8001c2:	68 53 27 80 00       	push   $0x802753
  8001c7:	e8 60 00 00 00       	call   80022c <_panic>

008001cc <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d7:	e8 05 0b 00 00       	call   800ce1 <sys_getenvid>
  8001dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e9:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7e 07                	jle    8001f9 <libmain+0x2d>
		binaryname = argv[0];
  8001f2:	8b 06                	mov    (%esi),%eax
  8001f4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001f9:	83 ec 08             	sub    $0x8,%esp
  8001fc:	56                   	push   %esi
  8001fd:	53                   	push   %ebx
  8001fe:	e8 30 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800203:	e8 0a 00 00 00       	call   800212 <exit>
}
  800208:	83 c4 10             	add    $0x10,%esp
  80020b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5d                   	pop    %ebp
  800211:	c3                   	ret    

00800212 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800218:	e8 86 11 00 00       	call   8013a3 <close_all>
	sys_env_destroy(0);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	6a 00                	push   $0x0
  800222:	e8 79 0a 00 00       	call   800ca0 <sys_env_destroy>
}
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	c9                   	leave  
  80022b:	c3                   	ret    

0080022c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  800231:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800234:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80023a:	e8 a2 0a 00 00       	call   800ce1 <sys_getenvid>
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	56                   	push   %esi
  800249:	50                   	push   %eax
  80024a:	68 88 28 80 00       	push   $0x802888
  80024f:	e8 b3 00 00 00       	call   800307 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800254:	83 c4 18             	add    $0x18,%esp
  800257:	53                   	push   %ebx
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	e8 56 00 00 00       	call   8002b6 <vcprintf>
	cprintf("\n");
  800260:	c7 04 24 92 27 80 00 	movl   $0x802792,(%esp)
  800267:	e8 9b 00 00 00       	call   800307 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026f:	cc                   	int3   
  800270:	eb fd                	jmp    80026f <_panic+0x43>

00800272 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	83 ec 04             	sub    $0x4,%esp
  800279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80027c:	8b 13                	mov    (%ebx),%edx
  80027e:	8d 42 01             	lea    0x1(%edx),%eax
  800281:	89 03                	mov    %eax,(%ebx)
  800283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800286:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80028a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028f:	74 09                	je     80029a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800291:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800298:	c9                   	leave  
  800299:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	68 ff 00 00 00       	push   $0xff
  8002a2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a5:	50                   	push   %eax
  8002a6:	e8 b8 09 00 00       	call   800c63 <sys_cputs>
		b->idx = 0;
  8002ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	eb db                	jmp    800291 <putch+0x1f>

008002b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c6:	00 00 00 
	b.cnt = 0;
  8002c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002df:	50                   	push   %eax
  8002e0:	68 72 02 80 00       	push   $0x800272
  8002e5:	e8 1a 01 00 00       	call   800404 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ea:	83 c4 08             	add    $0x8,%esp
  8002ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f9:	50                   	push   %eax
  8002fa:	e8 64 09 00 00       	call   800c63 <sys_cputs>

	return b.cnt;
}
  8002ff:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800310:	50                   	push   %eax
  800311:	ff 75 08             	pushl  0x8(%ebp)
  800314:	e8 9d ff ff ff       	call   8002b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	57                   	push   %edi
  80031f:	56                   	push   %esi
  800320:	53                   	push   %ebx
  800321:	83 ec 1c             	sub    $0x1c,%esp
  800324:	89 c7                	mov    %eax,%edi
  800326:	89 d6                	mov    %edx,%esi
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80032e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800331:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800334:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800337:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80033f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800342:	39 d3                	cmp    %edx,%ebx
  800344:	72 05                	jb     80034b <printnum+0x30>
  800346:	39 45 10             	cmp    %eax,0x10(%ebp)
  800349:	77 7a                	ja     8003c5 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	ff 75 18             	pushl  0x18(%ebp)
  800351:	8b 45 14             	mov    0x14(%ebp),%eax
  800354:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800357:	53                   	push   %ebx
  800358:	ff 75 10             	pushl  0x10(%ebp)
  80035b:	83 ec 08             	sub    $0x8,%esp
  80035e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800361:	ff 75 e0             	pushl  -0x20(%ebp)
  800364:	ff 75 dc             	pushl  -0x24(%ebp)
  800367:	ff 75 d8             	pushl  -0x28(%ebp)
  80036a:	e8 91 21 00 00       	call   802500 <__udivdi3>
  80036f:	83 c4 18             	add    $0x18,%esp
  800372:	52                   	push   %edx
  800373:	50                   	push   %eax
  800374:	89 f2                	mov    %esi,%edx
  800376:	89 f8                	mov    %edi,%eax
  800378:	e8 9e ff ff ff       	call   80031b <printnum>
  80037d:	83 c4 20             	add    $0x20,%esp
  800380:	eb 13                	jmp    800395 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	56                   	push   %esi
  800386:	ff 75 18             	pushl  0x18(%ebp)
  800389:	ff d7                	call   *%edi
  80038b:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80038e:	83 eb 01             	sub    $0x1,%ebx
  800391:	85 db                	test   %ebx,%ebx
  800393:	7f ed                	jg     800382 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800395:	83 ec 08             	sub    $0x8,%esp
  800398:	56                   	push   %esi
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039f:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a8:	e8 73 22 00 00       	call   802620 <__umoddi3>
  8003ad:	83 c4 14             	add    $0x14,%esp
  8003b0:	0f be 80 ab 28 80 00 	movsbl 0x8028ab(%eax),%eax
  8003b7:	50                   	push   %eax
  8003b8:	ff d7                	call   *%edi
}
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003c0:	5b                   	pop    %ebx
  8003c1:	5e                   	pop    %esi
  8003c2:	5f                   	pop    %edi
  8003c3:	5d                   	pop    %ebp
  8003c4:	c3                   	ret    
  8003c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003c8:	eb c4                	jmp    80038e <printnum+0x73>

008003ca <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003d0:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d4:	8b 10                	mov    (%eax),%edx
  8003d6:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d9:	73 0a                	jae    8003e5 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003db:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	88 02                	mov    %al,(%edx)
}
  8003e5:	5d                   	pop    %ebp
  8003e6:	c3                   	ret    

008003e7 <printfmt>:
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003ed:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003f0:	50                   	push   %eax
  8003f1:	ff 75 10             	pushl  0x10(%ebp)
  8003f4:	ff 75 0c             	pushl  0xc(%ebp)
  8003f7:	ff 75 08             	pushl  0x8(%ebp)
  8003fa:	e8 05 00 00 00       	call   800404 <vprintfmt>
}
  8003ff:	83 c4 10             	add    $0x10,%esp
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <vprintfmt>:
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	57                   	push   %edi
  800408:	56                   	push   %esi
  800409:	53                   	push   %ebx
  80040a:	83 ec 2c             	sub    $0x2c,%esp
  80040d:	8b 75 08             	mov    0x8(%ebp),%esi
  800410:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800413:	8b 7d 10             	mov    0x10(%ebp),%edi
  800416:	e9 c1 03 00 00       	jmp    8007dc <vprintfmt+0x3d8>
		padc = ' ';
  80041b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80041f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800426:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80042d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800434:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8d 47 01             	lea    0x1(%edi),%eax
  80043c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80043f:	0f b6 17             	movzbl (%edi),%edx
  800442:	8d 42 dd             	lea    -0x23(%edx),%eax
  800445:	3c 55                	cmp    $0x55,%al
  800447:	0f 87 12 04 00 00    	ja     80085f <vprintfmt+0x45b>
  80044d:	0f b6 c0             	movzbl %al,%eax
  800450:	ff 24 85 e0 29 80 00 	jmp    *0x8029e0(,%eax,4)
  800457:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80045a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80045e:	eb d9                	jmp    800439 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800460:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800463:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800467:	eb d0                	jmp    800439 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800469:	0f b6 d2             	movzbl %dl,%edx
  80046c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80046f:	b8 00 00 00 00       	mov    $0x0,%eax
  800474:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800477:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80047a:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80047e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800481:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800484:	83 f9 09             	cmp    $0x9,%ecx
  800487:	77 55                	ja     8004de <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800489:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80048c:	eb e9                	jmp    800477 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80048e:	8b 45 14             	mov    0x14(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800496:	8b 45 14             	mov    0x14(%ebp),%eax
  800499:	8d 40 04             	lea    0x4(%eax),%eax
  80049c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80049f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a6:	79 91                	jns    800439 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ae:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004b5:	eb 82                	jmp    800439 <vprintfmt+0x35>
  8004b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ba:	85 c0                	test   %eax,%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c1:	0f 49 d0             	cmovns %eax,%edx
  8004c4:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ca:	e9 6a ff ff ff       	jmp    800439 <vprintfmt+0x35>
  8004cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8004d2:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004d9:	e9 5b ff ff ff       	jmp    800439 <vprintfmt+0x35>
  8004de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004e4:	eb bc                	jmp    8004a2 <vprintfmt+0x9e>
			lflag++;
  8004e6:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004ec:	e9 48 ff ff ff       	jmp    800439 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 78 04             	lea    0x4(%eax),%edi
  8004f7:	83 ec 08             	sub    $0x8,%esp
  8004fa:	53                   	push   %ebx
  8004fb:	ff 30                	pushl  (%eax)
  8004fd:	ff d6                	call   *%esi
			break;
  8004ff:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800502:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800505:	e9 cf 02 00 00       	jmp    8007d9 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	8d 78 04             	lea    0x4(%eax),%edi
  800510:	8b 00                	mov    (%eax),%eax
  800512:	99                   	cltd   
  800513:	31 d0                	xor    %edx,%eax
  800515:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800517:	83 f8 0f             	cmp    $0xf,%eax
  80051a:	7f 23                	jg     80053f <vprintfmt+0x13b>
  80051c:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  800523:	85 d2                	test   %edx,%edx
  800525:	74 18                	je     80053f <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800527:	52                   	push   %edx
  800528:	68 65 2d 80 00       	push   $0x802d65
  80052d:	53                   	push   %ebx
  80052e:	56                   	push   %esi
  80052f:	e8 b3 fe ff ff       	call   8003e7 <printfmt>
  800534:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800537:	89 7d 14             	mov    %edi,0x14(%ebp)
  80053a:	e9 9a 02 00 00       	jmp    8007d9 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80053f:	50                   	push   %eax
  800540:	68 c3 28 80 00       	push   $0x8028c3
  800545:	53                   	push   %ebx
  800546:	56                   	push   %esi
  800547:	e8 9b fe ff ff       	call   8003e7 <printfmt>
  80054c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80054f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800552:	e9 82 02 00 00       	jmp    8007d9 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 c0 04             	add    $0x4,%eax
  80055d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800565:	85 ff                	test   %edi,%edi
  800567:	b8 bc 28 80 00       	mov    $0x8028bc,%eax
  80056c:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80056f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800573:	0f 8e bd 00 00 00    	jle    800636 <vprintfmt+0x232>
  800579:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80057d:	75 0e                	jne    80058d <vprintfmt+0x189>
  80057f:	89 75 08             	mov    %esi,0x8(%ebp)
  800582:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800585:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800588:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80058b:	eb 6d                	jmp    8005fa <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 d0             	pushl  -0x30(%ebp)
  800593:	57                   	push   %edi
  800594:	e8 6e 03 00 00       	call   800907 <strnlen>
  800599:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059c:	29 c1                	sub    %eax,%ecx
  80059e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005a1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005a4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ab:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005ae:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b0:	eb 0f                	jmp    8005c1 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	53                   	push   %ebx
  8005b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b9:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bb:	83 ef 01             	sub    $0x1,%edi
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	85 ff                	test   %edi,%edi
  8005c3:	7f ed                	jg     8005b2 <vprintfmt+0x1ae>
  8005c5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005c8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005cb:	85 c9                	test   %ecx,%ecx
  8005cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d2:	0f 49 c1             	cmovns %ecx,%eax
  8005d5:	29 c1                	sub    %eax,%ecx
  8005d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8005da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005e0:	89 cb                	mov    %ecx,%ebx
  8005e2:	eb 16                	jmp    8005fa <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005e8:	75 31                	jne    80061b <vprintfmt+0x217>
					putch(ch, putdat);
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 0c             	pushl  0xc(%ebp)
  8005f0:	50                   	push   %eax
  8005f1:	ff 55 08             	call   *0x8(%ebp)
  8005f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f7:	83 eb 01             	sub    $0x1,%ebx
  8005fa:	83 c7 01             	add    $0x1,%edi
  8005fd:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800601:	0f be c2             	movsbl %dl,%eax
  800604:	85 c0                	test   %eax,%eax
  800606:	74 59                	je     800661 <vprintfmt+0x25d>
  800608:	85 f6                	test   %esi,%esi
  80060a:	78 d8                	js     8005e4 <vprintfmt+0x1e0>
  80060c:	83 ee 01             	sub    $0x1,%esi
  80060f:	79 d3                	jns    8005e4 <vprintfmt+0x1e0>
  800611:	89 df                	mov    %ebx,%edi
  800613:	8b 75 08             	mov    0x8(%ebp),%esi
  800616:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800619:	eb 37                	jmp    800652 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80061b:	0f be d2             	movsbl %dl,%edx
  80061e:	83 ea 20             	sub    $0x20,%edx
  800621:	83 fa 5e             	cmp    $0x5e,%edx
  800624:	76 c4                	jbe    8005ea <vprintfmt+0x1e6>
					putch('?', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	6a 3f                	push   $0x3f
  80062e:	ff 55 08             	call   *0x8(%ebp)
  800631:	83 c4 10             	add    $0x10,%esp
  800634:	eb c1                	jmp    8005f7 <vprintfmt+0x1f3>
  800636:	89 75 08             	mov    %esi,0x8(%ebp)
  800639:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80063c:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80063f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800642:	eb b6                	jmp    8005fa <vprintfmt+0x1f6>
				putch(' ', putdat);
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	53                   	push   %ebx
  800648:	6a 20                	push   $0x20
  80064a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80064c:	83 ef 01             	sub    $0x1,%edi
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	85 ff                	test   %edi,%edi
  800654:	7f ee                	jg     800644 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800656:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
  80065c:	e9 78 01 00 00       	jmp    8007d9 <vprintfmt+0x3d5>
  800661:	89 df                	mov    %ebx,%edi
  800663:	8b 75 08             	mov    0x8(%ebp),%esi
  800666:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800669:	eb e7                	jmp    800652 <vprintfmt+0x24e>
	if (lflag >= 2)
  80066b:	83 f9 01             	cmp    $0x1,%ecx
  80066e:	7e 3f                	jle    8006af <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 50 04             	mov    0x4(%eax),%edx
  800676:	8b 00                	mov    (%eax),%eax
  800678:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 40 08             	lea    0x8(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068b:	79 5c                	jns    8006e9 <vprintfmt+0x2e5>
				putch('-', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	53                   	push   %ebx
  800691:	6a 2d                	push   $0x2d
  800693:	ff d6                	call   *%esi
				num = -(long long) num;
  800695:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800698:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80069b:	f7 da                	neg    %edx
  80069d:	83 d1 00             	adc    $0x0,%ecx
  8006a0:	f7 d9                	neg    %ecx
  8006a2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006a5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006aa:	e9 10 01 00 00       	jmp    8007bf <vprintfmt+0x3bb>
	else if (lflag)
  8006af:	85 c9                	test   %ecx,%ecx
  8006b1:	75 1b                	jne    8006ce <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bb:	89 c1                	mov    %eax,%ecx
  8006bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8d 40 04             	lea    0x4(%eax),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	eb b9                	jmp    800687 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d6:	89 c1                	mov    %eax,%ecx
  8006d8:	c1 f9 1f             	sar    $0x1f,%ecx
  8006db:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e7:	eb 9e                	jmp    800687 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ec:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f4:	e9 c6 00 00 00       	jmp    8007bf <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006f9:	83 f9 01             	cmp    $0x1,%ecx
  8006fc:	7e 18                	jle    800716 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	8b 48 04             	mov    0x4(%eax),%ecx
  800706:	8d 40 08             	lea    0x8(%eax),%eax
  800709:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800711:	e9 a9 00 00 00       	jmp    8007bf <vprintfmt+0x3bb>
	else if (lflag)
  800716:	85 c9                	test   %ecx,%ecx
  800718:	75 1a                	jne    800734 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 10                	mov    (%eax),%edx
  80071f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800724:	8d 40 04             	lea    0x4(%eax),%eax
  800727:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80072f:	e9 8b 00 00 00       	jmp    8007bf <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800744:	b8 0a 00 00 00       	mov    $0xa,%eax
  800749:	eb 74                	jmp    8007bf <vprintfmt+0x3bb>
	if (lflag >= 2)
  80074b:	83 f9 01             	cmp    $0x1,%ecx
  80074e:	7e 15                	jle    800765 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 10                	mov    (%eax),%edx
  800755:	8b 48 04             	mov    0x4(%eax),%ecx
  800758:	8d 40 08             	lea    0x8(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075e:	b8 08 00 00 00       	mov    $0x8,%eax
  800763:	eb 5a                	jmp    8007bf <vprintfmt+0x3bb>
	else if (lflag)
  800765:	85 c9                	test   %ecx,%ecx
  800767:	75 17                	jne    800780 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 10                	mov    (%eax),%edx
  80076e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800773:	8d 40 04             	lea    0x4(%eax),%eax
  800776:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800779:	b8 08 00 00 00       	mov    $0x8,%eax
  80077e:	eb 3f                	jmp    8007bf <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800780:	8b 45 14             	mov    0x14(%ebp),%eax
  800783:	8b 10                	mov    (%eax),%edx
  800785:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078a:	8d 40 04             	lea    0x4(%eax),%eax
  80078d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800790:	b8 08 00 00 00       	mov    $0x8,%eax
  800795:	eb 28                	jmp    8007bf <vprintfmt+0x3bb>
			putch('0', putdat);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	53                   	push   %ebx
  80079b:	6a 30                	push   $0x30
  80079d:	ff d6                	call   *%esi
			putch('x', putdat);
  80079f:	83 c4 08             	add    $0x8,%esp
  8007a2:	53                   	push   %ebx
  8007a3:	6a 78                	push   $0x78
  8007a5:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8b 10                	mov    (%eax),%edx
  8007ac:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007b1:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007b4:	8d 40 04             	lea    0x4(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ba:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007bf:	83 ec 0c             	sub    $0xc,%esp
  8007c2:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007c6:	57                   	push   %edi
  8007c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	51                   	push   %ecx
  8007cc:	52                   	push   %edx
  8007cd:	89 da                	mov    %ebx,%edx
  8007cf:	89 f0                	mov    %esi,%eax
  8007d1:	e8 45 fb ff ff       	call   80031b <printnum>
			break;
  8007d6:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dc:	83 c7 01             	add    $0x1,%edi
  8007df:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007e3:	83 f8 25             	cmp    $0x25,%eax
  8007e6:	0f 84 2f fc ff ff    	je     80041b <vprintfmt+0x17>
			if (ch == '\0')
  8007ec:	85 c0                	test   %eax,%eax
  8007ee:	0f 84 8b 00 00 00    	je     80087f <vprintfmt+0x47b>
			putch(ch, putdat);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	53                   	push   %ebx
  8007f8:	50                   	push   %eax
  8007f9:	ff d6                	call   *%esi
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	eb dc                	jmp    8007dc <vprintfmt+0x3d8>
	if (lflag >= 2)
  800800:	83 f9 01             	cmp    $0x1,%ecx
  800803:	7e 15                	jle    80081a <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	8b 10                	mov    (%eax),%edx
  80080a:	8b 48 04             	mov    0x4(%eax),%ecx
  80080d:	8d 40 08             	lea    0x8(%eax),%eax
  800810:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800813:	b8 10 00 00 00       	mov    $0x10,%eax
  800818:	eb a5                	jmp    8007bf <vprintfmt+0x3bb>
	else if (lflag)
  80081a:	85 c9                	test   %ecx,%ecx
  80081c:	75 17                	jne    800835 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8b 10                	mov    (%eax),%edx
  800823:	b9 00 00 00 00       	mov    $0x0,%ecx
  800828:	8d 40 04             	lea    0x4(%eax),%eax
  80082b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80082e:	b8 10 00 00 00       	mov    $0x10,%eax
  800833:	eb 8a                	jmp    8007bf <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	8b 10                	mov    (%eax),%edx
  80083a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80083f:	8d 40 04             	lea    0x4(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800845:	b8 10 00 00 00       	mov    $0x10,%eax
  80084a:	e9 70 ff ff ff       	jmp    8007bf <vprintfmt+0x3bb>
			putch(ch, putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	53                   	push   %ebx
  800853:	6a 25                	push   $0x25
  800855:	ff d6                	call   *%esi
			break;
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	e9 7a ff ff ff       	jmp    8007d9 <vprintfmt+0x3d5>
			putch('%', putdat);
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	53                   	push   %ebx
  800863:	6a 25                	push   $0x25
  800865:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	89 f8                	mov    %edi,%eax
  80086c:	eb 03                	jmp    800871 <vprintfmt+0x46d>
  80086e:	83 e8 01             	sub    $0x1,%eax
  800871:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800875:	75 f7                	jne    80086e <vprintfmt+0x46a>
  800877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80087a:	e9 5a ff ff ff       	jmp    8007d9 <vprintfmt+0x3d5>
}
  80087f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800882:	5b                   	pop    %ebx
  800883:	5e                   	pop    %esi
  800884:	5f                   	pop    %edi
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	83 ec 18             	sub    $0x18,%esp
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800893:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800896:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80089a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80089d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	74 26                	je     8008ce <vsnprintf+0x47>
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	7e 22                	jle    8008ce <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008ac:	ff 75 14             	pushl  0x14(%ebp)
  8008af:	ff 75 10             	pushl  0x10(%ebp)
  8008b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b5:	50                   	push   %eax
  8008b6:	68 ca 03 80 00       	push   $0x8003ca
  8008bb:	e8 44 fb ff ff       	call   800404 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c9:	83 c4 10             	add    $0x10,%esp
}
  8008cc:	c9                   	leave  
  8008cd:	c3                   	ret    
		return -E_INVAL;
  8008ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d3:	eb f7                	jmp    8008cc <vsnprintf+0x45>

008008d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008db:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008de:	50                   	push   %eax
  8008df:	ff 75 10             	pushl  0x10(%ebp)
  8008e2:	ff 75 0c             	pushl  0xc(%ebp)
  8008e5:	ff 75 08             	pushl  0x8(%ebp)
  8008e8:	e8 9a ff ff ff       	call   800887 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ed:	c9                   	leave  
  8008ee:	c3                   	ret    

008008ef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fa:	eb 03                	jmp    8008ff <strlen+0x10>
		n++;
  8008fc:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008ff:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800903:	75 f7                	jne    8008fc <strlen+0xd>
	return n;
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090d:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800910:	b8 00 00 00 00       	mov    $0x0,%eax
  800915:	eb 03                	jmp    80091a <strnlen+0x13>
		n++;
  800917:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091a:	39 d0                	cmp    %edx,%eax
  80091c:	74 06                	je     800924 <strnlen+0x1d>
  80091e:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800922:	75 f3                	jne    800917 <strnlen+0x10>
	return n;
}
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	53                   	push   %ebx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800930:	89 c2                	mov    %eax,%edx
  800932:	83 c1 01             	add    $0x1,%ecx
  800935:	83 c2 01             	add    $0x1,%edx
  800938:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80093c:	88 5a ff             	mov    %bl,-0x1(%edx)
  80093f:	84 db                	test   %bl,%bl
  800941:	75 ef                	jne    800932 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800943:	5b                   	pop    %ebx
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	53                   	push   %ebx
  80094a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80094d:	53                   	push   %ebx
  80094e:	e8 9c ff ff ff       	call   8008ef <strlen>
  800953:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	01 d8                	add    %ebx,%eax
  80095b:	50                   	push   %eax
  80095c:	e8 c5 ff ff ff       	call   800926 <strcpy>
	return dst;
}
  800961:	89 d8                	mov    %ebx,%eax
  800963:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 75 08             	mov    0x8(%ebp),%esi
  800970:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800973:	89 f3                	mov    %esi,%ebx
  800975:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800978:	89 f2                	mov    %esi,%edx
  80097a:	eb 0f                	jmp    80098b <strncpy+0x23>
		*dst++ = *src;
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	0f b6 01             	movzbl (%ecx),%eax
  800982:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800985:	80 39 01             	cmpb   $0x1,(%ecx)
  800988:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80098b:	39 da                	cmp    %ebx,%edx
  80098d:	75 ed                	jne    80097c <strncpy+0x14>
	}
	return ret;
}
  80098f:	89 f0                	mov    %esi,%eax
  800991:	5b                   	pop    %ebx
  800992:	5e                   	pop    %esi
  800993:	5d                   	pop    %ebp
  800994:	c3                   	ret    

00800995 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	56                   	push   %esi
  800999:	53                   	push   %ebx
  80099a:	8b 75 08             	mov    0x8(%ebp),%esi
  80099d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009a3:	89 f0                	mov    %esi,%eax
  8009a5:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a9:	85 c9                	test   %ecx,%ecx
  8009ab:	75 0b                	jne    8009b8 <strlcpy+0x23>
  8009ad:	eb 17                	jmp    8009c6 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009af:	83 c2 01             	add    $0x1,%edx
  8009b2:	83 c0 01             	add    $0x1,%eax
  8009b5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009b8:	39 d8                	cmp    %ebx,%eax
  8009ba:	74 07                	je     8009c3 <strlcpy+0x2e>
  8009bc:	0f b6 0a             	movzbl (%edx),%ecx
  8009bf:	84 c9                	test   %cl,%cl
  8009c1:	75 ec                	jne    8009af <strlcpy+0x1a>
		*dst = '\0';
  8009c3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009c6:	29 f0                	sub    %esi,%eax
}
  8009c8:	5b                   	pop    %ebx
  8009c9:	5e                   	pop    %esi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009d5:	eb 06                	jmp    8009dd <strcmp+0x11>
		p++, q++;
  8009d7:	83 c1 01             	add    $0x1,%ecx
  8009da:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009dd:	0f b6 01             	movzbl (%ecx),%eax
  8009e0:	84 c0                	test   %al,%al
  8009e2:	74 04                	je     8009e8 <strcmp+0x1c>
  8009e4:	3a 02                	cmp    (%edx),%al
  8009e6:	74 ef                	je     8009d7 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 c0             	movzbl %al,%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
}
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fc:	89 c3                	mov    %eax,%ebx
  8009fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a01:	eb 06                	jmp    800a09 <strncmp+0x17>
		n--, p++, q++;
  800a03:	83 c0 01             	add    $0x1,%eax
  800a06:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a09:	39 d8                	cmp    %ebx,%eax
  800a0b:	74 16                	je     800a23 <strncmp+0x31>
  800a0d:	0f b6 08             	movzbl (%eax),%ecx
  800a10:	84 c9                	test   %cl,%cl
  800a12:	74 04                	je     800a18 <strncmp+0x26>
  800a14:	3a 0a                	cmp    (%edx),%cl
  800a16:	74 eb                	je     800a03 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 00             	movzbl (%eax),%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
}
  800a20:	5b                   	pop    %ebx
  800a21:	5d                   	pop    %ebp
  800a22:	c3                   	ret    
		return 0;
  800a23:	b8 00 00 00 00       	mov    $0x0,%eax
  800a28:	eb f6                	jmp    800a20 <strncmp+0x2e>

00800a2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a34:	0f b6 10             	movzbl (%eax),%edx
  800a37:	84 d2                	test   %dl,%dl
  800a39:	74 09                	je     800a44 <strchr+0x1a>
		if (*s == c)
  800a3b:	38 ca                	cmp    %cl,%dl
  800a3d:	74 0a                	je     800a49 <strchr+0x1f>
	for (; *s; s++)
  800a3f:	83 c0 01             	add    $0x1,%eax
  800a42:	eb f0                	jmp    800a34 <strchr+0xa>
			return (char *) s;
	return 0;
  800a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a49:	5d                   	pop    %ebp
  800a4a:	c3                   	ret    

00800a4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a55:	eb 03                	jmp    800a5a <strfind+0xf>
  800a57:	83 c0 01             	add    $0x1,%eax
  800a5a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a5d:	38 ca                	cmp    %cl,%dl
  800a5f:	74 04                	je     800a65 <strfind+0x1a>
  800a61:	84 d2                	test   %dl,%dl
  800a63:	75 f2                	jne    800a57 <strfind+0xc>
			break;
	return (char *) s;
}
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	57                   	push   %edi
  800a6b:	56                   	push   %esi
  800a6c:	53                   	push   %ebx
  800a6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a73:	85 c9                	test   %ecx,%ecx
  800a75:	74 13                	je     800a8a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7d:	75 05                	jne    800a84 <memset+0x1d>
  800a7f:	f6 c1 03             	test   $0x3,%cl
  800a82:	74 0d                	je     800a91 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a87:	fc                   	cld    
  800a88:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a8a:	89 f8                	mov    %edi,%eax
  800a8c:	5b                   	pop    %ebx
  800a8d:	5e                   	pop    %esi
  800a8e:	5f                   	pop    %edi
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    
		c &= 0xFF;
  800a91:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a95:	89 d3                	mov    %edx,%ebx
  800a97:	c1 e3 08             	shl    $0x8,%ebx
  800a9a:	89 d0                	mov    %edx,%eax
  800a9c:	c1 e0 18             	shl    $0x18,%eax
  800a9f:	89 d6                	mov    %edx,%esi
  800aa1:	c1 e6 10             	shl    $0x10,%esi
  800aa4:	09 f0                	or     %esi,%eax
  800aa6:	09 c2                	or     %eax,%edx
  800aa8:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800aaa:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aad:	89 d0                	mov    %edx,%eax
  800aaf:	fc                   	cld    
  800ab0:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab2:	eb d6                	jmp    800a8a <memset+0x23>

00800ab4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
  800ab7:	57                   	push   %edi
  800ab8:	56                   	push   %esi
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800abf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac2:	39 c6                	cmp    %eax,%esi
  800ac4:	73 35                	jae    800afb <memmove+0x47>
  800ac6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	76 2e                	jbe    800afb <memmove+0x47>
		s += n;
		d += n;
  800acd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad0:	89 d6                	mov    %edx,%esi
  800ad2:	09 fe                	or     %edi,%esi
  800ad4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ada:	74 0c                	je     800ae8 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800adc:	83 ef 01             	sub    $0x1,%edi
  800adf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ae2:	fd                   	std    
  800ae3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae5:	fc                   	cld    
  800ae6:	eb 21                	jmp    800b09 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae8:	f6 c1 03             	test   $0x3,%cl
  800aeb:	75 ef                	jne    800adc <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aed:	83 ef 04             	sub    $0x4,%edi
  800af0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af6:	fd                   	std    
  800af7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af9:	eb ea                	jmp    800ae5 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800afb:	89 f2                	mov    %esi,%edx
  800afd:	09 c2                	or     %eax,%edx
  800aff:	f6 c2 03             	test   $0x3,%dl
  800b02:	74 09                	je     800b0d <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b04:	89 c7                	mov    %eax,%edi
  800b06:	fc                   	cld    
  800b07:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0d:	f6 c1 03             	test   $0x3,%cl
  800b10:	75 f2                	jne    800b04 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b15:	89 c7                	mov    %eax,%edi
  800b17:	fc                   	cld    
  800b18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1a:	eb ed                	jmp    800b09 <memmove+0x55>

00800b1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b1f:	ff 75 10             	pushl  0x10(%ebp)
  800b22:	ff 75 0c             	pushl  0xc(%ebp)
  800b25:	ff 75 08             	pushl  0x8(%ebp)
  800b28:	e8 87 ff ff ff       	call   800ab4 <memmove>
}
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    

00800b2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2f:	55                   	push   %ebp
  800b30:	89 e5                	mov    %esp,%ebp
  800b32:	56                   	push   %esi
  800b33:	53                   	push   %ebx
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 c6                	mov    %eax,%esi
  800b3c:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3f:	39 f0                	cmp    %esi,%eax
  800b41:	74 1c                	je     800b5f <memcmp+0x30>
		if (*s1 != *s2)
  800b43:	0f b6 08             	movzbl (%eax),%ecx
  800b46:	0f b6 1a             	movzbl (%edx),%ebx
  800b49:	38 d9                	cmp    %bl,%cl
  800b4b:	75 08                	jne    800b55 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b4d:	83 c0 01             	add    $0x1,%eax
  800b50:	83 c2 01             	add    $0x1,%edx
  800b53:	eb ea                	jmp    800b3f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b55:	0f b6 c1             	movzbl %cl,%eax
  800b58:	0f b6 db             	movzbl %bl,%ebx
  800b5b:	29 d8                	sub    %ebx,%eax
  800b5d:	eb 05                	jmp    800b64 <memcmp+0x35>
	}

	return 0;
  800b5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b71:	89 c2                	mov    %eax,%edx
  800b73:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b76:	39 d0                	cmp    %edx,%eax
  800b78:	73 09                	jae    800b83 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7a:	38 08                	cmp    %cl,(%eax)
  800b7c:	74 05                	je     800b83 <memfind+0x1b>
	for (; s < ends; s++)
  800b7e:	83 c0 01             	add    $0x1,%eax
  800b81:	eb f3                	jmp    800b76 <memfind+0xe>
			break;
	return (void *) s;
}
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	57                   	push   %edi
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
  800b8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b91:	eb 03                	jmp    800b96 <strtol+0x11>
		s++;
  800b93:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b96:	0f b6 01             	movzbl (%ecx),%eax
  800b99:	3c 20                	cmp    $0x20,%al
  800b9b:	74 f6                	je     800b93 <strtol+0xe>
  800b9d:	3c 09                	cmp    $0x9,%al
  800b9f:	74 f2                	je     800b93 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800ba1:	3c 2b                	cmp    $0x2b,%al
  800ba3:	74 2e                	je     800bd3 <strtol+0x4e>
	int neg = 0;
  800ba5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800baa:	3c 2d                	cmp    $0x2d,%al
  800bac:	74 2f                	je     800bdd <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bae:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bb4:	75 05                	jne    800bbb <strtol+0x36>
  800bb6:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb9:	74 2c                	je     800be7 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bbb:	85 db                	test   %ebx,%ebx
  800bbd:	75 0a                	jne    800bc9 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbf:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800bc4:	80 39 30             	cmpb   $0x30,(%ecx)
  800bc7:	74 28                	je     800bf1 <strtol+0x6c>
		base = 10;
  800bc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800bce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bd1:	eb 50                	jmp    800c23 <strtol+0x9e>
		s++;
  800bd3:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bd6:	bf 00 00 00 00       	mov    $0x0,%edi
  800bdb:	eb d1                	jmp    800bae <strtol+0x29>
		s++, neg = 1;
  800bdd:	83 c1 01             	add    $0x1,%ecx
  800be0:	bf 01 00 00 00       	mov    $0x1,%edi
  800be5:	eb c7                	jmp    800bae <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800beb:	74 0e                	je     800bfb <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bed:	85 db                	test   %ebx,%ebx
  800bef:	75 d8                	jne    800bc9 <strtol+0x44>
		s++, base = 8;
  800bf1:	83 c1 01             	add    $0x1,%ecx
  800bf4:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bf9:	eb ce                	jmp    800bc9 <strtol+0x44>
		s += 2, base = 16;
  800bfb:	83 c1 02             	add    $0x2,%ecx
  800bfe:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c03:	eb c4                	jmp    800bc9 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c05:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c08:	89 f3                	mov    %esi,%ebx
  800c0a:	80 fb 19             	cmp    $0x19,%bl
  800c0d:	77 29                	ja     800c38 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800c0f:	0f be d2             	movsbl %dl,%edx
  800c12:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c15:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c18:	7d 30                	jge    800c4a <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800c1a:	83 c1 01             	add    $0x1,%ecx
  800c1d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c21:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c23:	0f b6 11             	movzbl (%ecx),%edx
  800c26:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c29:	89 f3                	mov    %esi,%ebx
  800c2b:	80 fb 09             	cmp    $0x9,%bl
  800c2e:	77 d5                	ja     800c05 <strtol+0x80>
			dig = *s - '0';
  800c30:	0f be d2             	movsbl %dl,%edx
  800c33:	83 ea 30             	sub    $0x30,%edx
  800c36:	eb dd                	jmp    800c15 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c38:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c3b:	89 f3                	mov    %esi,%ebx
  800c3d:	80 fb 19             	cmp    $0x19,%bl
  800c40:	77 08                	ja     800c4a <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c42:	0f be d2             	movsbl %dl,%edx
  800c45:	83 ea 37             	sub    $0x37,%edx
  800c48:	eb cb                	jmp    800c15 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c4a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4e:	74 05                	je     800c55 <strtol+0xd0>
		*endptr = (char *) s;
  800c50:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c53:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c55:	89 c2                	mov    %eax,%edx
  800c57:	f7 da                	neg    %edx
  800c59:	85 ff                	test   %edi,%edi
  800c5b:	0f 45 c2             	cmovne %edx,%eax
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c69:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c74:	89 c3                	mov    %eax,%ebx
  800c76:	89 c7                	mov    %eax,%edi
  800c78:	89 c6                	mov    %eax,%esi
  800c7a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c87:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8c:	b8 01 00 00 00       	mov    $0x1,%eax
  800c91:	89 d1                	mov    %edx,%ecx
  800c93:	89 d3                	mov    %edx,%ebx
  800c95:	89 d7                	mov    %edx,%edi
  800c97:	89 d6                	mov    %edx,%esi
  800c99:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9b:	5b                   	pop    %ebx
  800c9c:	5e                   	pop    %esi
  800c9d:	5f                   	pop    %edi
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb6:	89 cb                	mov    %ecx,%ebx
  800cb8:	89 cf                	mov    %ecx,%edi
  800cba:	89 ce                	mov    %ecx,%esi
  800cbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	7f 08                	jg     800cca <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cca:	83 ec 0c             	sub    $0xc,%esp
  800ccd:	50                   	push   %eax
  800cce:	6a 03                	push   $0x3
  800cd0:	68 9f 2b 80 00       	push   $0x802b9f
  800cd5:	6a 23                	push   $0x23
  800cd7:	68 bc 2b 80 00       	push   $0x802bbc
  800cdc:	e8 4b f5 ff ff       	call   80022c <_panic>

00800ce1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cec:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf1:	89 d1                	mov    %edx,%ecx
  800cf3:	89 d3                	mov    %edx,%ebx
  800cf5:	89 d7                	mov    %edx,%edi
  800cf7:	89 d6                	mov    %edx,%esi
  800cf9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_yield>:

void
sys_yield(void)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d06:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d10:	89 d1                	mov    %edx,%ecx
  800d12:	89 d3                	mov    %edx,%ebx
  800d14:	89 d7                	mov    %edx,%edi
  800d16:	89 d6                	mov    %edx,%esi
  800d18:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1a:	5b                   	pop    %ebx
  800d1b:	5e                   	pop    %esi
  800d1c:	5f                   	pop    %edi
  800d1d:	5d                   	pop    %ebp
  800d1e:	c3                   	ret    

00800d1f <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	57                   	push   %edi
  800d23:	56                   	push   %esi
  800d24:	53                   	push   %ebx
  800d25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d28:	be 00 00 00 00       	mov    $0x0,%esi
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d33:	b8 04 00 00 00       	mov    $0x4,%eax
  800d38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3b:	89 f7                	mov    %esi,%edi
  800d3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7f 08                	jg     800d4b <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5f                   	pop    %edi
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4b:	83 ec 0c             	sub    $0xc,%esp
  800d4e:	50                   	push   %eax
  800d4f:	6a 04                	push   $0x4
  800d51:	68 9f 2b 80 00       	push   $0x802b9f
  800d56:	6a 23                	push   $0x23
  800d58:	68 bc 2b 80 00       	push   $0x802bbc
  800d5d:	e8 ca f4 ff ff       	call   80022c <_panic>

00800d62 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 05 00 00 00       	mov    $0x5,%eax
  800d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d79:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d7c:	8b 75 18             	mov    0x18(%ebp),%esi
  800d7f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	7f 08                	jg     800d8d <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8d:	83 ec 0c             	sub    $0xc,%esp
  800d90:	50                   	push   %eax
  800d91:	6a 05                	push   $0x5
  800d93:	68 9f 2b 80 00       	push   $0x802b9f
  800d98:	6a 23                	push   $0x23
  800d9a:	68 bc 2b 80 00       	push   $0x802bbc
  800d9f:	e8 88 f4 ff ff       	call   80022c <_panic>

00800da4 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbd:	89 df                	mov    %ebx,%edi
  800dbf:	89 de                	mov    %ebx,%esi
  800dc1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	7f 08                	jg     800dcf <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5e                   	pop    %esi
  800dcc:	5f                   	pop    %edi
  800dcd:	5d                   	pop    %ebp
  800dce:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	50                   	push   %eax
  800dd3:	6a 06                	push   $0x6
  800dd5:	68 9f 2b 80 00       	push   $0x802b9f
  800dda:	6a 23                	push   $0x23
  800ddc:	68 bc 2b 80 00       	push   $0x802bbc
  800de1:	e8 46 f4 ff ff       	call   80022c <_panic>

00800de6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
  800dec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800def:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	b8 08 00 00 00       	mov    $0x8,%eax
  800dff:	89 df                	mov    %ebx,%edi
  800e01:	89 de                	mov    %ebx,%esi
  800e03:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e05:	85 c0                	test   %eax,%eax
  800e07:	7f 08                	jg     800e11 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0c:	5b                   	pop    %ebx
  800e0d:	5e                   	pop    %esi
  800e0e:	5f                   	pop    %edi
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e11:	83 ec 0c             	sub    $0xc,%esp
  800e14:	50                   	push   %eax
  800e15:	6a 08                	push   $0x8
  800e17:	68 9f 2b 80 00       	push   $0x802b9f
  800e1c:	6a 23                	push   $0x23
  800e1e:	68 bc 2b 80 00       	push   $0x802bbc
  800e23:	e8 04 f4 ff ff       	call   80022c <_panic>

00800e28 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	57                   	push   %edi
  800e2c:	56                   	push   %esi
  800e2d:	53                   	push   %ebx
  800e2e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3c:	b8 09 00 00 00       	mov    $0x9,%eax
  800e41:	89 df                	mov    %ebx,%edi
  800e43:	89 de                	mov    %ebx,%esi
  800e45:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7f 08                	jg     800e53 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	6a 09                	push   $0x9
  800e59:	68 9f 2b 80 00       	push   $0x802b9f
  800e5e:	6a 23                	push   $0x23
  800e60:	68 bc 2b 80 00       	push   $0x802bbc
  800e65:	e8 c2 f3 ff ff       	call   80022c <_panic>

00800e6a <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	89 de                	mov    %ebx,%esi
  800e87:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7f 08                	jg     800e95 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	50                   	push   %eax
  800e99:	6a 0a                	push   $0xa
  800e9b:	68 9f 2b 80 00       	push   $0x802b9f
  800ea0:	6a 23                	push   $0x23
  800ea2:	68 bc 2b 80 00       	push   $0x802bbc
  800ea7:	e8 80 f3 ff ff       	call   80022c <_panic>

00800eac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ebd:	be 00 00 00 00       	mov    $0x0,%esi
  800ec2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec8:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eca:	5b                   	pop    %ebx
  800ecb:	5e                   	pop    %esi
  800ecc:	5f                   	pop    %edi
  800ecd:	5d                   	pop    %ebp
  800ece:	c3                   	ret    

00800ecf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	57                   	push   %edi
  800ed3:	56                   	push   %esi
  800ed4:	53                   	push   %ebx
  800ed5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ed8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee5:	89 cb                	mov    %ecx,%ebx
  800ee7:	89 cf                	mov    %ecx,%edi
  800ee9:	89 ce                	mov    %ecx,%esi
  800eeb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	7f 08                	jg     800ef9 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef9:	83 ec 0c             	sub    $0xc,%esp
  800efc:	50                   	push   %eax
  800efd:	6a 0d                	push   $0xd
  800eff:	68 9f 2b 80 00       	push   $0x802b9f
  800f04:	6a 23                	push   $0x23
  800f06:	68 bc 2b 80 00       	push   $0x802bbc
  800f0b:	e8 1c f3 ff ff       	call   80022c <_panic>

00800f10 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f16:	ba 00 00 00 00       	mov    $0x0,%edx
  800f1b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f20:	89 d1                	mov    %edx,%ecx
  800f22:	89 d3                	mov    %edx,%ebx
  800f24:	89 d7                	mov    %edx,%edi
  800f26:	89 d6                	mov    %edx,%esi
  800f28:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f2a:	5b                   	pop    %ebx
  800f2b:	5e                   	pop    %esi
  800f2c:	5f                   	pop    %edi
  800f2d:	5d                   	pop    %ebp
  800f2e:	c3                   	ret    

00800f2f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800f37:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f39:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f3d:	74 7f                	je     800fbe <pgfault+0x8f>
  800f3f:	89 d8                	mov    %ebx,%eax
  800f41:	c1 e8 0c             	shr    $0xc,%eax
  800f44:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f4b:	f6 c4 08             	test   $0x8,%ah
  800f4e:	74 6e                	je     800fbe <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800f50:	e8 8c fd ff ff       	call   800ce1 <sys_getenvid>
  800f55:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f57:	83 ec 04             	sub    $0x4,%esp
  800f5a:	6a 07                	push   $0x7
  800f5c:	68 00 f0 7f 00       	push   $0x7ff000
  800f61:	50                   	push   %eax
  800f62:	e8 b8 fd ff ff       	call   800d1f <sys_page_alloc>
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	78 64                	js     800fd2 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800f6e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 00 10 00 00       	push   $0x1000
  800f7c:	53                   	push   %ebx
  800f7d:	68 00 f0 7f 00       	push   $0x7ff000
  800f82:	e8 2d fb ff ff       	call   800ab4 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800f87:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f8e:	53                   	push   %ebx
  800f8f:	56                   	push   %esi
  800f90:	68 00 f0 7f 00       	push   $0x7ff000
  800f95:	56                   	push   %esi
  800f96:	e8 c7 fd ff ff       	call   800d62 <sys_page_map>
  800f9b:	83 c4 20             	add    $0x20,%esp
  800f9e:	85 c0                	test   %eax,%eax
  800fa0:	78 42                	js     800fe4 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800fa2:	83 ec 08             	sub    $0x8,%esp
  800fa5:	68 00 f0 7f 00       	push   $0x7ff000
  800faa:	56                   	push   %esi
  800fab:	e8 f4 fd ff ff       	call   800da4 <sys_page_unmap>
  800fb0:	83 c4 10             	add    $0x10,%esp
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	78 3f                	js     800ff6 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800fb7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fba:	5b                   	pop    %ebx
  800fbb:	5e                   	pop    %esi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800fbe:	83 ec 04             	sub    $0x4,%esp
  800fc1:	68 cc 2b 80 00       	push   $0x802bcc
  800fc6:	6a 1d                	push   $0x1d
  800fc8:	68 5b 2c 80 00       	push   $0x802c5b
  800fcd:	e8 5a f2 ff ff       	call   80022c <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800fd2:	50                   	push   %eax
  800fd3:	68 f4 2b 80 00       	push   $0x802bf4
  800fd8:	6a 28                	push   $0x28
  800fda:	68 5b 2c 80 00       	push   $0x802c5b
  800fdf:	e8 48 f2 ff ff       	call   80022c <_panic>
		panic("pgfault:page map failed: %e", r);
  800fe4:	50                   	push   %eax
  800fe5:	68 66 2c 80 00       	push   $0x802c66
  800fea:	6a 2c                	push   $0x2c
  800fec:	68 5b 2c 80 00       	push   $0x802c5b
  800ff1:	e8 36 f2 ff ff       	call   80022c <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800ff6:	50                   	push   %eax
  800ff7:	68 18 2c 80 00       	push   $0x802c18
  800ffc:	6a 2e                	push   $0x2e
  800ffe:	68 5b 2c 80 00       	push   $0x802c5b
  801003:	e8 24 f2 ff ff       	call   80022c <_panic>

00801008 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	53                   	push   %ebx
  80100e:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  801011:	68 2f 0f 80 00       	push   $0x800f2f
  801016:	e8 21 13 00 00       	call   80233c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80101b:	b8 07 00 00 00       	mov    $0x7,%eax
  801020:	cd 30                	int    $0x30
  801022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  801025:	83 c4 10             	add    $0x10,%esp
  801028:	85 c0                	test   %eax,%eax
  80102a:	78 2f                	js     80105b <fork+0x53>
  80102c:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  80102e:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  801033:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801037:	75 6e                	jne    8010a7 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801039:	e8 a3 fc ff ff       	call   800ce1 <sys_getenvid>
  80103e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801043:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801046:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80104b:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  801050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  801053:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  80105b:	50                   	push   %eax
  80105c:	68 38 2c 80 00       	push   $0x802c38
  801061:	6a 6e                	push   $0x6e
  801063:	68 5b 2c 80 00       	push   $0x802c5b
  801068:	e8 bf f1 ff ff       	call   80022c <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  80106d:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801074:	83 ec 0c             	sub    $0xc,%esp
  801077:	25 07 0e 00 00       	and    $0xe07,%eax
  80107c:	50                   	push   %eax
  80107d:	56                   	push   %esi
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	6a 00                	push   $0x0
  801082:	e8 db fc ff ff       	call   800d62 <sys_page_map>
  801087:	83 c4 20             	add    $0x20,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	ba 00 00 00 00       	mov    $0x0,%edx
  801091:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  801094:	85 c0                	test   %eax,%eax
  801096:	78 bb                	js     801053 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801098:	83 c3 01             	add    $0x1,%ebx
  80109b:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8010a1:	0f 84 a6 00 00 00    	je     80114d <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  8010a7:	89 d8                	mov    %ebx,%eax
  8010a9:	c1 e8 0a             	shr    $0xa,%eax
  8010ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010b3:	a8 01                	test   $0x1,%al
  8010b5:	74 e1                	je     801098 <fork+0x90>
  8010b7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010be:	a8 01                	test   $0x1,%al
  8010c0:	74 d6                	je     801098 <fork+0x90>
  8010c2:	89 de                	mov    %ebx,%esi
  8010c4:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  8010c7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010ce:	f6 c4 04             	test   $0x4,%ah
  8010d1:	75 9a                	jne    80106d <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  8010d3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010da:	a8 02                	test   $0x2,%al
  8010dc:	75 0c                	jne    8010ea <fork+0xe2>
  8010de:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010e5:	f6 c4 08             	test   $0x8,%ah
  8010e8:	74 42                	je     80112c <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	68 05 08 00 00       	push   $0x805
  8010f2:	56                   	push   %esi
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	6a 00                	push   $0x0
  8010f7:	e8 66 fc ff ff       	call   800d62 <sys_page_map>
  8010fc:	83 c4 20             	add    $0x20,%esp
  8010ff:	85 c0                	test   %eax,%eax
  801101:	0f 88 4c ff ff ff    	js     801053 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801107:	83 ec 0c             	sub    $0xc,%esp
  80110a:	68 05 08 00 00       	push   $0x805
  80110f:	56                   	push   %esi
  801110:	6a 00                	push   $0x0
  801112:	56                   	push   %esi
  801113:	6a 00                	push   $0x0
  801115:	e8 48 fc ff ff       	call   800d62 <sys_page_map>
  80111a:	83 c4 20             	add    $0x20,%esp
  80111d:	85 c0                	test   %eax,%eax
  80111f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801124:	0f 4f c1             	cmovg  %ecx,%eax
  801127:	e9 68 ff ff ff       	jmp    801094 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  80112c:	83 ec 0c             	sub    $0xc,%esp
  80112f:	6a 05                	push   $0x5
  801131:	56                   	push   %esi
  801132:	57                   	push   %edi
  801133:	56                   	push   %esi
  801134:	6a 00                	push   $0x0
  801136:	e8 27 fc ff ff       	call   800d62 <sys_page_map>
  80113b:	83 c4 20             	add    $0x20,%esp
  80113e:	85 c0                	test   %eax,%eax
  801140:	b9 00 00 00 00       	mov    $0x0,%ecx
  801145:	0f 4f c1             	cmovg  %ecx,%eax
  801148:	e9 47 ff ff ff       	jmp    801094 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	6a 07                	push   $0x7
  801152:	68 00 f0 bf ee       	push   $0xeebff000
  801157:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80115a:	57                   	push   %edi
  80115b:	e8 bf fb ff ff       	call   800d1f <sys_page_alloc>
  801160:	83 c4 10             	add    $0x10,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	0f 88 e8 fe ff ff    	js     801053 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	68 a1 23 80 00       	push   $0x8023a1
  801173:	57                   	push   %edi
  801174:	e8 f1 fc ff ff       	call   800e6a <sys_env_set_pgfault_upcall>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	85 c0                	test   %eax,%eax
  80117e:	0f 88 cf fe ff ff    	js     801053 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	6a 02                	push   $0x2
  801189:	57                   	push   %edi
  80118a:	e8 57 fc ff ff       	call   800de6 <sys_env_set_status>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	78 08                	js     80119e <fork+0x196>
	return eid;
  801196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801199:	e9 b5 fe ff ff       	jmp    801053 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  80119e:	50                   	push   %eax
  80119f:	68 82 2c 80 00       	push   $0x802c82
  8011a4:	68 87 00 00 00       	push   $0x87
  8011a9:	68 5b 2c 80 00       	push   $0x802c5b
  8011ae:	e8 79 f0 ff ff       	call   80022c <_panic>

008011b3 <sfork>:

// Challenge!
int sfork(void)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8011b9:	68 a0 2c 80 00       	push   $0x802ca0
  8011be:	68 8f 00 00 00       	push   $0x8f
  8011c3:	68 5b 2c 80 00       	push   $0x802c5b
  8011c8:	e8 5f f0 ff ff       	call   80022c <_panic>

008011cd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	05 00 00 00 30       	add    $0x30000000,%eax
  8011d8:	c1 e8 0c             	shr    $0xc,%eax
}
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ed:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011f2:	5d                   	pop    %ebp
  8011f3:	c3                   	ret    

008011f4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
  8011f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011fa:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	c1 ea 16             	shr    $0x16,%edx
  801204:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80120b:	f6 c2 01             	test   $0x1,%dl
  80120e:	74 2a                	je     80123a <fd_alloc+0x46>
  801210:	89 c2                	mov    %eax,%edx
  801212:	c1 ea 0c             	shr    $0xc,%edx
  801215:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80121c:	f6 c2 01             	test   $0x1,%dl
  80121f:	74 19                	je     80123a <fd_alloc+0x46>
  801221:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801226:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80122b:	75 d2                	jne    8011ff <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80122d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801233:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801238:	eb 07                	jmp    801241 <fd_alloc+0x4d>
			*fd_store = fd;
  80123a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80123c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801249:	83 f8 1f             	cmp    $0x1f,%eax
  80124c:	77 36                	ja     801284 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80124e:	c1 e0 0c             	shl    $0xc,%eax
  801251:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801256:	89 c2                	mov    %eax,%edx
  801258:	c1 ea 16             	shr    $0x16,%edx
  80125b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801262:	f6 c2 01             	test   $0x1,%dl
  801265:	74 24                	je     80128b <fd_lookup+0x48>
  801267:	89 c2                	mov    %eax,%edx
  801269:	c1 ea 0c             	shr    $0xc,%edx
  80126c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801273:	f6 c2 01             	test   $0x1,%dl
  801276:	74 1a                	je     801292 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127b:	89 02                	mov    %eax,(%edx)
	return 0;
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    
		return -E_INVAL;
  801284:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801289:	eb f7                	jmp    801282 <fd_lookup+0x3f>
		return -E_INVAL;
  80128b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801290:	eb f0                	jmp    801282 <fd_lookup+0x3f>
  801292:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801297:	eb e9                	jmp    801282 <fd_lookup+0x3f>

00801299 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
  80129f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a2:	ba 38 2d 80 00       	mov    $0x802d38,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8012a7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8012ac:	39 08                	cmp    %ecx,(%eax)
  8012ae:	74 33                	je     8012e3 <dev_lookup+0x4a>
  8012b0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8012b3:	8b 02                	mov    (%edx),%eax
  8012b5:	85 c0                	test   %eax,%eax
  8012b7:	75 f3                	jne    8012ac <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8012b9:	a1 20 44 80 00       	mov    0x804420,%eax
  8012be:	8b 40 48             	mov    0x48(%eax),%eax
  8012c1:	83 ec 04             	sub    $0x4,%esp
  8012c4:	51                   	push   %ecx
  8012c5:	50                   	push   %eax
  8012c6:	68 b8 2c 80 00       	push   $0x802cb8
  8012cb:	e8 37 f0 ff ff       	call   800307 <cprintf>
	*dev = 0;
  8012d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012d9:	83 c4 10             	add    $0x10,%esp
  8012dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    
			*dev = devtab[i];
  8012e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ed:	eb f2                	jmp    8012e1 <dev_lookup+0x48>

008012ef <fd_close>:
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	57                   	push   %edi
  8012f3:	56                   	push   %esi
  8012f4:	53                   	push   %ebx
  8012f5:	83 ec 1c             	sub    $0x1c,%esp
  8012f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8012fb:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012fe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801301:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801302:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801308:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80130b:	50                   	push   %eax
  80130c:	e8 32 ff ff ff       	call   801243 <fd_lookup>
  801311:	89 c3                	mov    %eax,%ebx
  801313:	83 c4 08             	add    $0x8,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	78 05                	js     80131f <fd_close+0x30>
	    || fd != fd2)
  80131a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80131d:	74 16                	je     801335 <fd_close+0x46>
		return (must_exist ? r : 0);
  80131f:	89 f8                	mov    %edi,%eax
  801321:	84 c0                	test   %al,%al
  801323:	b8 00 00 00 00       	mov    $0x0,%eax
  801328:	0f 44 d8             	cmove  %eax,%ebx
}
  80132b:	89 d8                	mov    %ebx,%eax
  80132d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801330:	5b                   	pop    %ebx
  801331:	5e                   	pop    %esi
  801332:	5f                   	pop    %edi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801335:	83 ec 08             	sub    $0x8,%esp
  801338:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80133b:	50                   	push   %eax
  80133c:	ff 36                	pushl  (%esi)
  80133e:	e8 56 ff ff ff       	call   801299 <dev_lookup>
  801343:	89 c3                	mov    %eax,%ebx
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	78 15                	js     801361 <fd_close+0x72>
		if (dev->dev_close)
  80134c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134f:	8b 40 10             	mov    0x10(%eax),%eax
  801352:	85 c0                	test   %eax,%eax
  801354:	74 1b                	je     801371 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	56                   	push   %esi
  80135a:	ff d0                	call   *%eax
  80135c:	89 c3                	mov    %eax,%ebx
  80135e:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801361:	83 ec 08             	sub    $0x8,%esp
  801364:	56                   	push   %esi
  801365:	6a 00                	push   $0x0
  801367:	e8 38 fa ff ff       	call   800da4 <sys_page_unmap>
	return r;
  80136c:	83 c4 10             	add    $0x10,%esp
  80136f:	eb ba                	jmp    80132b <fd_close+0x3c>
			r = 0;
  801371:	bb 00 00 00 00       	mov    $0x0,%ebx
  801376:	eb e9                	jmp    801361 <fd_close+0x72>

00801378 <close>:

int
close(int fdnum)
{
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
  80137b:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801381:	50                   	push   %eax
  801382:	ff 75 08             	pushl  0x8(%ebp)
  801385:	e8 b9 fe ff ff       	call   801243 <fd_lookup>
  80138a:	83 c4 08             	add    $0x8,%esp
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 10                	js     8013a1 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801391:	83 ec 08             	sub    $0x8,%esp
  801394:	6a 01                	push   $0x1
  801396:	ff 75 f4             	pushl  -0xc(%ebp)
  801399:	e8 51 ff ff ff       	call   8012ef <fd_close>
  80139e:	83 c4 10             	add    $0x10,%esp
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <close_all>:

void
close_all(void)
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	53                   	push   %ebx
  8013a7:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8013aa:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8013af:	83 ec 0c             	sub    $0xc,%esp
  8013b2:	53                   	push   %ebx
  8013b3:	e8 c0 ff ff ff       	call   801378 <close>
	for (i = 0; i < MAXFD; i++)
  8013b8:	83 c3 01             	add    $0x1,%ebx
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	83 fb 20             	cmp    $0x20,%ebx
  8013c1:	75 ec                	jne    8013af <close_all+0xc>
}
  8013c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	57                   	push   %edi
  8013cc:	56                   	push   %esi
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013d1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	ff 75 08             	pushl  0x8(%ebp)
  8013d8:	e8 66 fe ff ff       	call   801243 <fd_lookup>
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 08             	add    $0x8,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	0f 88 81 00 00 00    	js     80146b <dup+0xa3>
		return r;
	close(newfdnum);
  8013ea:	83 ec 0c             	sub    $0xc,%esp
  8013ed:	ff 75 0c             	pushl  0xc(%ebp)
  8013f0:	e8 83 ff ff ff       	call   801378 <close>

	newfd = INDEX2FD(newfdnum);
  8013f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013f8:	c1 e6 0c             	shl    $0xc,%esi
  8013fb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801401:	83 c4 04             	add    $0x4,%esp
  801404:	ff 75 e4             	pushl  -0x1c(%ebp)
  801407:	e8 d1 fd ff ff       	call   8011dd <fd2data>
  80140c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80140e:	89 34 24             	mov    %esi,(%esp)
  801411:	e8 c7 fd ff ff       	call   8011dd <fd2data>
  801416:	83 c4 10             	add    $0x10,%esp
  801419:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80141b:	89 d8                	mov    %ebx,%eax
  80141d:	c1 e8 16             	shr    $0x16,%eax
  801420:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801427:	a8 01                	test   $0x1,%al
  801429:	74 11                	je     80143c <dup+0x74>
  80142b:	89 d8                	mov    %ebx,%eax
  80142d:	c1 e8 0c             	shr    $0xc,%eax
  801430:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801437:	f6 c2 01             	test   $0x1,%dl
  80143a:	75 39                	jne    801475 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80143c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80143f:	89 d0                	mov    %edx,%eax
  801441:	c1 e8 0c             	shr    $0xc,%eax
  801444:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80144b:	83 ec 0c             	sub    $0xc,%esp
  80144e:	25 07 0e 00 00       	and    $0xe07,%eax
  801453:	50                   	push   %eax
  801454:	56                   	push   %esi
  801455:	6a 00                	push   $0x0
  801457:	52                   	push   %edx
  801458:	6a 00                	push   $0x0
  80145a:	e8 03 f9 ff ff       	call   800d62 <sys_page_map>
  80145f:	89 c3                	mov    %eax,%ebx
  801461:	83 c4 20             	add    $0x20,%esp
  801464:	85 c0                	test   %eax,%eax
  801466:	78 31                	js     801499 <dup+0xd1>
		goto err;

	return newfdnum;
  801468:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80146b:	89 d8                	mov    %ebx,%eax
  80146d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801470:	5b                   	pop    %ebx
  801471:	5e                   	pop    %esi
  801472:	5f                   	pop    %edi
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801475:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80147c:	83 ec 0c             	sub    $0xc,%esp
  80147f:	25 07 0e 00 00       	and    $0xe07,%eax
  801484:	50                   	push   %eax
  801485:	57                   	push   %edi
  801486:	6a 00                	push   $0x0
  801488:	53                   	push   %ebx
  801489:	6a 00                	push   $0x0
  80148b:	e8 d2 f8 ff ff       	call   800d62 <sys_page_map>
  801490:	89 c3                	mov    %eax,%ebx
  801492:	83 c4 20             	add    $0x20,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	79 a3                	jns    80143c <dup+0x74>
	sys_page_unmap(0, newfd);
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	56                   	push   %esi
  80149d:	6a 00                	push   $0x0
  80149f:	e8 00 f9 ff ff       	call   800da4 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8014a4:	83 c4 08             	add    $0x8,%esp
  8014a7:	57                   	push   %edi
  8014a8:	6a 00                	push   $0x0
  8014aa:	e8 f5 f8 ff ff       	call   800da4 <sys_page_unmap>
	return r;
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	eb b7                	jmp    80146b <dup+0xa3>

008014b4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	53                   	push   %ebx
  8014b8:	83 ec 14             	sub    $0x14,%esp
  8014bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c1:	50                   	push   %eax
  8014c2:	53                   	push   %ebx
  8014c3:	e8 7b fd ff ff       	call   801243 <fd_lookup>
  8014c8:	83 c4 08             	add    $0x8,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 3f                	js     80150e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014cf:	83 ec 08             	sub    $0x8,%esp
  8014d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d5:	50                   	push   %eax
  8014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d9:	ff 30                	pushl  (%eax)
  8014db:	e8 b9 fd ff ff       	call   801299 <dev_lookup>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	78 27                	js     80150e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ea:	8b 42 08             	mov    0x8(%edx),%eax
  8014ed:	83 e0 03             	and    $0x3,%eax
  8014f0:	83 f8 01             	cmp    $0x1,%eax
  8014f3:	74 1e                	je     801513 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f8:	8b 40 08             	mov    0x8(%eax),%eax
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	74 35                	je     801534 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	ff 75 10             	pushl  0x10(%ebp)
  801505:	ff 75 0c             	pushl  0xc(%ebp)
  801508:	52                   	push   %edx
  801509:	ff d0                	call   *%eax
  80150b:	83 c4 10             	add    $0x10,%esp
}
  80150e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801511:	c9                   	leave  
  801512:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801513:	a1 20 44 80 00       	mov    0x804420,%eax
  801518:	8b 40 48             	mov    0x48(%eax),%eax
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	53                   	push   %ebx
  80151f:	50                   	push   %eax
  801520:	68 fc 2c 80 00       	push   $0x802cfc
  801525:	e8 dd ed ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  80152a:	83 c4 10             	add    $0x10,%esp
  80152d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801532:	eb da                	jmp    80150e <read+0x5a>
		return -E_NOT_SUPP;
  801534:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801539:	eb d3                	jmp    80150e <read+0x5a>

0080153b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	57                   	push   %edi
  80153f:	56                   	push   %esi
  801540:	53                   	push   %ebx
  801541:	83 ec 0c             	sub    $0xc,%esp
  801544:	8b 7d 08             	mov    0x8(%ebp),%edi
  801547:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80154a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154f:	39 f3                	cmp    %esi,%ebx
  801551:	73 25                	jae    801578 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801553:	83 ec 04             	sub    $0x4,%esp
  801556:	89 f0                	mov    %esi,%eax
  801558:	29 d8                	sub    %ebx,%eax
  80155a:	50                   	push   %eax
  80155b:	89 d8                	mov    %ebx,%eax
  80155d:	03 45 0c             	add    0xc(%ebp),%eax
  801560:	50                   	push   %eax
  801561:	57                   	push   %edi
  801562:	e8 4d ff ff ff       	call   8014b4 <read>
		if (m < 0)
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	85 c0                	test   %eax,%eax
  80156c:	78 08                	js     801576 <readn+0x3b>
			return m;
		if (m == 0)
  80156e:	85 c0                	test   %eax,%eax
  801570:	74 06                	je     801578 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801572:	01 c3                	add    %eax,%ebx
  801574:	eb d9                	jmp    80154f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801576:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801578:	89 d8                	mov    %ebx,%eax
  80157a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5e                   	pop    %esi
  80157f:	5f                   	pop    %edi
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	53                   	push   %ebx
  801586:	83 ec 14             	sub    $0x14,%esp
  801589:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	53                   	push   %ebx
  801591:	e8 ad fc ff ff       	call   801243 <fd_lookup>
  801596:	83 c4 08             	add    $0x8,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	78 3a                	js     8015d7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a7:	ff 30                	pushl  (%eax)
  8015a9:	e8 eb fc ff ff       	call   801299 <dev_lookup>
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	78 22                	js     8015d7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015bc:	74 1e                	je     8015dc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	74 35                	je     8015fd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	ff 75 10             	pushl  0x10(%ebp)
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	50                   	push   %eax
  8015d2:	ff d2                	call   *%edx
  8015d4:	83 c4 10             	add    $0x10,%esp
}
  8015d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015dc:	a1 20 44 80 00       	mov    0x804420,%eax
  8015e1:	8b 40 48             	mov    0x48(%eax),%eax
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	53                   	push   %ebx
  8015e8:	50                   	push   %eax
  8015e9:	68 18 2d 80 00       	push   $0x802d18
  8015ee:	e8 14 ed ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015fb:	eb da                	jmp    8015d7 <write+0x55>
		return -E_NOT_SUPP;
  8015fd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801602:	eb d3                	jmp    8015d7 <write+0x55>

00801604 <seek>:

int
seek(int fdnum, off_t offset)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80160a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80160d:	50                   	push   %eax
  80160e:	ff 75 08             	pushl  0x8(%ebp)
  801611:	e8 2d fc ff ff       	call   801243 <fd_lookup>
  801616:	83 c4 08             	add    $0x8,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 0e                	js     80162b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80161d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801620:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801623:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	53                   	push   %ebx
  801631:	83 ec 14             	sub    $0x14,%esp
  801634:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801637:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80163a:	50                   	push   %eax
  80163b:	53                   	push   %ebx
  80163c:	e8 02 fc ff ff       	call   801243 <fd_lookup>
  801641:	83 c4 08             	add    $0x8,%esp
  801644:	85 c0                	test   %eax,%eax
  801646:	78 37                	js     80167f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801648:	83 ec 08             	sub    $0x8,%esp
  80164b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80164e:	50                   	push   %eax
  80164f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801652:	ff 30                	pushl  (%eax)
  801654:	e8 40 fc ff ff       	call   801299 <dev_lookup>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 1f                	js     80167f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801663:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801667:	74 1b                	je     801684 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166c:	8b 52 18             	mov    0x18(%edx),%edx
  80166f:	85 d2                	test   %edx,%edx
  801671:	74 32                	je     8016a5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	50                   	push   %eax
  80167a:	ff d2                	call   *%edx
  80167c:	83 c4 10             	add    $0x10,%esp
}
  80167f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801682:	c9                   	leave  
  801683:	c3                   	ret    
			thisenv->env_id, fdnum);
  801684:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801689:	8b 40 48             	mov    0x48(%eax),%eax
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	53                   	push   %ebx
  801690:	50                   	push   %eax
  801691:	68 d8 2c 80 00       	push   $0x802cd8
  801696:	e8 6c ec ff ff       	call   800307 <cprintf>
		return -E_INVAL;
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016a3:	eb da                	jmp    80167f <ftruncate+0x52>
		return -E_NOT_SUPP;
  8016a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016aa:	eb d3                	jmp    80167f <ftruncate+0x52>

008016ac <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	53                   	push   %ebx
  8016b0:	83 ec 14             	sub    $0x14,%esp
  8016b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b9:	50                   	push   %eax
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	e8 81 fb ff ff       	call   801243 <fd_lookup>
  8016c2:	83 c4 08             	add    $0x8,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 4b                	js     801714 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	ff 30                	pushl  (%eax)
  8016d5:	e8 bf fb ff ff       	call   801299 <dev_lookup>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 33                	js     801714 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016e8:	74 2f                	je     801719 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016ea:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ed:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016f4:	00 00 00 
	stat->st_isdir = 0;
  8016f7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016fe:	00 00 00 
	stat->st_dev = dev;
  801701:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801707:	83 ec 08             	sub    $0x8,%esp
  80170a:	53                   	push   %ebx
  80170b:	ff 75 f0             	pushl  -0x10(%ebp)
  80170e:	ff 50 14             	call   *0x14(%eax)
  801711:	83 c4 10             	add    $0x10,%esp
}
  801714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801717:	c9                   	leave  
  801718:	c3                   	ret    
		return -E_NOT_SUPP;
  801719:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171e:	eb f4                	jmp    801714 <fstat+0x68>

00801720 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	6a 00                	push   $0x0
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	e8 e7 01 00 00       	call   801919 <open>
  801732:	89 c3                	mov    %eax,%ebx
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	85 c0                	test   %eax,%eax
  801739:	78 1b                	js     801756 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80173b:	83 ec 08             	sub    $0x8,%esp
  80173e:	ff 75 0c             	pushl  0xc(%ebp)
  801741:	50                   	push   %eax
  801742:	e8 65 ff ff ff       	call   8016ac <fstat>
  801747:	89 c6                	mov    %eax,%esi
	close(fd);
  801749:	89 1c 24             	mov    %ebx,(%esp)
  80174c:	e8 27 fc ff ff       	call   801378 <close>
	return r;
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	89 f3                	mov    %esi,%ebx
}
  801756:	89 d8                	mov    %ebx,%eax
  801758:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    

0080175f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	56                   	push   %esi
  801763:	53                   	push   %ebx
  801764:	89 c6                	mov    %eax,%esi
  801766:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801768:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80176f:	74 27                	je     801798 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801771:	6a 07                	push   $0x7
  801773:	68 00 50 80 00       	push   $0x805000
  801778:	56                   	push   %esi
  801779:	ff 35 00 40 80 00    	pushl  0x804000
  80177f:	e8 aa 0c 00 00       	call   80242e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801784:	83 c4 0c             	add    $0xc,%esp
  801787:	6a 00                	push   $0x0
  801789:	53                   	push   %ebx
  80178a:	6a 00                	push   $0x0
  80178c:	e8 36 0c 00 00       	call   8023c7 <ipc_recv>
}
  801791:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801794:	5b                   	pop    %ebx
  801795:	5e                   	pop    %esi
  801796:	5d                   	pop    %ebp
  801797:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801798:	83 ec 0c             	sub    $0xc,%esp
  80179b:	6a 01                	push   $0x1
  80179d:	e8 e0 0c 00 00       	call   802482 <ipc_find_env>
  8017a2:	a3 00 40 80 00       	mov    %eax,0x804000
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	eb c5                	jmp    801771 <fsipc+0x12>

008017ac <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ca:	b8 02 00 00 00       	mov    $0x2,%eax
  8017cf:	e8 8b ff ff ff       	call   80175f <fsipc>
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <devfile_flush>:
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ec:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f1:	e8 69 ff ff ff       	call   80175f <fsipc>
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <devfile_stat>:
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	53                   	push   %ebx
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8b 40 0c             	mov    0xc(%eax),%eax
  801808:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	b8 05 00 00 00       	mov    $0x5,%eax
  801817:	e8 43 ff ff ff       	call   80175f <fsipc>
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 2c                	js     80184c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	68 00 50 80 00       	push   $0x805000
  801828:	53                   	push   %ebx
  801829:	e8 f8 f0 ff ff       	call   800926 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80182e:	a1 80 50 80 00       	mov    0x805080,%eax
  801833:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801839:	a1 84 50 80 00       	mov    0x805084,%eax
  80183e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <devfile_write>:
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	8b 45 10             	mov    0x10(%ebp),%eax
  80185a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80185f:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801864:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801867:	8b 55 08             	mov    0x8(%ebp),%edx
  80186a:	8b 52 0c             	mov    0xc(%edx),%edx
  80186d:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801873:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801878:	50                   	push   %eax
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	68 08 50 80 00       	push   $0x805008
  801881:	e8 2e f2 ff ff       	call   800ab4 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801886:	ba 00 00 00 00       	mov    $0x0,%edx
  80188b:	b8 04 00 00 00       	mov    $0x4,%eax
  801890:	e8 ca fe ff ff       	call   80175f <fsipc>
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <devfile_read>:
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	56                   	push   %esi
  80189b:	53                   	push   %ebx
  80189c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018aa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b5:	b8 03 00 00 00       	mov    $0x3,%eax
  8018ba:	e8 a0 fe ff ff       	call   80175f <fsipc>
  8018bf:	89 c3                	mov    %eax,%ebx
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 1f                	js     8018e4 <devfile_read+0x4d>
	assert(r <= n);
  8018c5:	39 f0                	cmp    %esi,%eax
  8018c7:	77 24                	ja     8018ed <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018c9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ce:	7f 33                	jg     801903 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	50                   	push   %eax
  8018d4:	68 00 50 80 00       	push   $0x805000
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 d3 f1 ff ff       	call   800ab4 <memmove>
	return r;
  8018e1:	83 c4 10             	add    $0x10,%esp
}
  8018e4:	89 d8                	mov    %ebx,%eax
  8018e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    
	assert(r <= n);
  8018ed:	68 4c 2d 80 00       	push   $0x802d4c
  8018f2:	68 53 2d 80 00       	push   $0x802d53
  8018f7:	6a 7b                	push   $0x7b
  8018f9:	68 68 2d 80 00       	push   $0x802d68
  8018fe:	e8 29 e9 ff ff       	call   80022c <_panic>
	assert(r <= PGSIZE);
  801903:	68 73 2d 80 00       	push   $0x802d73
  801908:	68 53 2d 80 00       	push   $0x802d53
  80190d:	6a 7c                	push   $0x7c
  80190f:	68 68 2d 80 00       	push   $0x802d68
  801914:	e8 13 e9 ff ff       	call   80022c <_panic>

00801919 <open>:
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	56                   	push   %esi
  80191d:	53                   	push   %ebx
  80191e:	83 ec 1c             	sub    $0x1c,%esp
  801921:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801924:	56                   	push   %esi
  801925:	e8 c5 ef ff ff       	call   8008ef <strlen>
  80192a:	83 c4 10             	add    $0x10,%esp
  80192d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801932:	7f 6c                	jg     8019a0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193a:	50                   	push   %eax
  80193b:	e8 b4 f8 ff ff       	call   8011f4 <fd_alloc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	83 c4 10             	add    $0x10,%esp
  801945:	85 c0                	test   %eax,%eax
  801947:	78 3c                	js     801985 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801949:	83 ec 08             	sub    $0x8,%esp
  80194c:	56                   	push   %esi
  80194d:	68 00 50 80 00       	push   $0x805000
  801952:	e8 cf ef ff ff       	call   800926 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80195f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801962:	b8 01 00 00 00       	mov    $0x1,%eax
  801967:	e8 f3 fd ff ff       	call   80175f <fsipc>
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	78 19                	js     80198e <open+0x75>
	return fd2num(fd);
  801975:	83 ec 0c             	sub    $0xc,%esp
  801978:	ff 75 f4             	pushl  -0xc(%ebp)
  80197b:	e8 4d f8 ff ff       	call   8011cd <fd2num>
  801980:	89 c3                	mov    %eax,%ebx
  801982:	83 c4 10             	add    $0x10,%esp
}
  801985:	89 d8                	mov    %ebx,%eax
  801987:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198a:	5b                   	pop    %ebx
  80198b:	5e                   	pop    %esi
  80198c:	5d                   	pop    %ebp
  80198d:	c3                   	ret    
		fd_close(fd, 0);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	6a 00                	push   $0x0
  801993:	ff 75 f4             	pushl  -0xc(%ebp)
  801996:	e8 54 f9 ff ff       	call   8012ef <fd_close>
		return r;
  80199b:	83 c4 10             	add    $0x10,%esp
  80199e:	eb e5                	jmp    801985 <open+0x6c>
		return -E_BAD_PATH;
  8019a0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019a5:	eb de                	jmp    801985 <open+0x6c>

008019a7 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019b7:	e8 a3 fd ff ff       	call   80175f <fsipc>
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019c4:	68 7f 2d 80 00       	push   $0x802d7f
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	e8 55 ef ff ff       	call   800926 <strcpy>
	return 0;
}
  8019d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <devsock_close>:
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	53                   	push   %ebx
  8019dc:	83 ec 10             	sub    $0x10,%esp
  8019df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019e2:	53                   	push   %ebx
  8019e3:	e8 d3 0a 00 00       	call   8024bb <pageref>
  8019e8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019eb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019f0:	83 f8 01             	cmp    $0x1,%eax
  8019f3:	74 07                	je     8019fc <devsock_close+0x24>
}
  8019f5:	89 d0                	mov    %edx,%eax
  8019f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019fc:	83 ec 0c             	sub    $0xc,%esp
  8019ff:	ff 73 0c             	pushl  0xc(%ebx)
  801a02:	e8 b7 02 00 00       	call   801cbe <nsipc_close>
  801a07:	89 c2                	mov    %eax,%edx
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	eb e7                	jmp    8019f5 <devsock_close+0x1d>

00801a0e <devsock_write>:
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	ff 70 0c             	pushl  0xc(%eax)
  801a22:	e8 74 03 00 00       	call   801d9b <nsipc_send>
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <devsock_read>:
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 10             	pushl  0x10(%ebp)
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	ff 70 0c             	pushl  0xc(%eax)
  801a3d:	e8 ed 02 00 00       	call   801d2f <nsipc_recv>
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <fd2sockid>:
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a4a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	e8 ef f7 ff ff       	call   801243 <fd_lookup>
  801a54:	83 c4 10             	add    $0x10,%esp
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 10                	js     801a6b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a64:	39 08                	cmp    %ecx,(%eax)
  801a66:	75 05                	jne    801a6d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a68:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    
		return -E_NOT_SUPP;
  801a6d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a72:	eb f7                	jmp    801a6b <fd2sockid+0x27>

00801a74 <alloc_sockfd>:
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	56                   	push   %esi
  801a78:	53                   	push   %ebx
  801a79:	83 ec 1c             	sub    $0x1c,%esp
  801a7c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a81:	50                   	push   %eax
  801a82:	e8 6d f7 ff ff       	call   8011f4 <fd_alloc>
  801a87:	89 c3                	mov    %eax,%ebx
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 43                	js     801ad3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	68 07 04 00 00       	push   $0x407
  801a98:	ff 75 f4             	pushl  -0xc(%ebp)
  801a9b:	6a 00                	push   $0x0
  801a9d:	e8 7d f2 ff ff       	call   800d1f <sys_page_alloc>
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	78 28                	js     801ad3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ab4:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ac0:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	50                   	push   %eax
  801ac7:	e8 01 f7 ff ff       	call   8011cd <fd2num>
  801acc:	89 c3                	mov    %eax,%ebx
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	eb 0c                	jmp    801adf <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	56                   	push   %esi
  801ad7:	e8 e2 01 00 00       	call   801cbe <nsipc_close>
		return r;
  801adc:	83 c4 10             	add    $0x10,%esp
}
  801adf:	89 d8                	mov    %ebx,%eax
  801ae1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    

00801ae8 <accept>:
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
  801aeb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	e8 4e ff ff ff       	call   801a44 <fd2sockid>
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 1b                	js     801b15 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	ff 75 10             	pushl  0x10(%ebp)
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	50                   	push   %eax
  801b04:	e8 0e 01 00 00       	call   801c17 <nsipc_accept>
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 05                	js     801b15 <accept+0x2d>
	return alloc_sockfd(r);
  801b10:	e8 5f ff ff ff       	call   801a74 <alloc_sockfd>
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <bind>:
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	e8 1f ff ff ff       	call   801a44 <fd2sockid>
  801b25:	85 c0                	test   %eax,%eax
  801b27:	78 12                	js     801b3b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	ff 75 10             	pushl  0x10(%ebp)
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	50                   	push   %eax
  801b33:	e8 2f 01 00 00       	call   801c67 <nsipc_bind>
  801b38:	83 c4 10             	add    $0x10,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <shutdown>:
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	e8 f9 fe ff ff       	call   801a44 <fd2sockid>
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 0f                	js     801b5e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b4f:	83 ec 08             	sub    $0x8,%esp
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	50                   	push   %eax
  801b56:	e8 41 01 00 00       	call   801c9c <nsipc_shutdown>
  801b5b:	83 c4 10             	add    $0x10,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <connect>:
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	e8 d6 fe ff ff       	call   801a44 <fd2sockid>
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 12                	js     801b84 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b72:	83 ec 04             	sub    $0x4,%esp
  801b75:	ff 75 10             	pushl  0x10(%ebp)
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	50                   	push   %eax
  801b7c:	e8 57 01 00 00       	call   801cd8 <nsipc_connect>
  801b81:	83 c4 10             	add    $0x10,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <listen>:
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	e8 b0 fe ff ff       	call   801a44 <fd2sockid>
  801b94:	85 c0                	test   %eax,%eax
  801b96:	78 0f                	js     801ba7 <listen+0x21>
	return nsipc_listen(r, backlog);
  801b98:	83 ec 08             	sub    $0x8,%esp
  801b9b:	ff 75 0c             	pushl  0xc(%ebp)
  801b9e:	50                   	push   %eax
  801b9f:	e8 69 01 00 00       	call   801d0d <nsipc_listen>
  801ba4:	83 c4 10             	add    $0x10,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801baf:	ff 75 10             	pushl  0x10(%ebp)
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	e8 3c 02 00 00       	call   801df9 <nsipc_socket>
  801bbd:	83 c4 10             	add    $0x10,%esp
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 05                	js     801bc9 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801bc4:	e8 ab fe ff ff       	call   801a74 <alloc_sockfd>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bd4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bdb:	74 26                	je     801c03 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bdd:	6a 07                	push   $0x7
  801bdf:	68 00 60 80 00       	push   $0x806000
  801be4:	53                   	push   %ebx
  801be5:	ff 35 04 40 80 00    	pushl  0x804004
  801beb:	e8 3e 08 00 00       	call   80242e <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf0:	83 c4 0c             	add    $0xc,%esp
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	e8 c9 07 00 00       	call   8023c7 <ipc_recv>
}
  801bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c03:	83 ec 0c             	sub    $0xc,%esp
  801c06:	6a 02                	push   $0x2
  801c08:	e8 75 08 00 00       	call   802482 <ipc_find_env>
  801c0d:	a3 04 40 80 00       	mov    %eax,0x804004
  801c12:	83 c4 10             	add    $0x10,%esp
  801c15:	eb c6                	jmp    801bdd <nsipc+0x12>

00801c17 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	56                   	push   %esi
  801c1b:	53                   	push   %ebx
  801c1c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c27:	8b 06                	mov    (%esi),%eax
  801c29:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	e8 93 ff ff ff       	call   801bcb <nsipc>
  801c38:	89 c3                	mov    %eax,%ebx
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 20                	js     801c5e <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c3e:	83 ec 04             	sub    $0x4,%esp
  801c41:	ff 35 10 60 80 00    	pushl  0x806010
  801c47:	68 00 60 80 00       	push   $0x806000
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	e8 60 ee ff ff       	call   800ab4 <memmove>
		*addrlen = ret->ret_addrlen;
  801c54:	a1 10 60 80 00       	mov    0x806010,%eax
  801c59:	89 06                	mov    %eax,(%esi)
  801c5b:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c5e:	89 d8                	mov    %ebx,%eax
  801c60:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c63:	5b                   	pop    %ebx
  801c64:	5e                   	pop    %esi
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    

00801c67 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	53                   	push   %ebx
  801c6b:	83 ec 08             	sub    $0x8,%esp
  801c6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c79:	53                   	push   %ebx
  801c7a:	ff 75 0c             	pushl  0xc(%ebp)
  801c7d:	68 04 60 80 00       	push   $0x806004
  801c82:	e8 2d ee ff ff       	call   800ab4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c87:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c8d:	b8 02 00 00 00       	mov    $0x2,%eax
  801c92:	e8 34 ff ff ff       	call   801bcb <nsipc>
}
  801c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cb2:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb7:	e8 0f ff ff ff       	call   801bcb <nsipc>
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <nsipc_close>:

int
nsipc_close(int s)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ccc:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd1:	e8 f5 fe ff ff       	call   801bcb <nsipc>
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	53                   	push   %ebx
  801cdc:	83 ec 08             	sub    $0x8,%esp
  801cdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cea:	53                   	push   %ebx
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	68 04 60 80 00       	push   $0x806004
  801cf3:	e8 bc ed ff ff       	call   800ab4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cf8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801cfe:	b8 05 00 00 00       	mov    $0x5,%eax
  801d03:	e8 c3 fe ff ff       	call   801bcb <nsipc>
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d23:	b8 06 00 00 00       	mov    $0x6,%eax
  801d28:	e8 9e fe ff ff       	call   801bcb <nsipc>
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	56                   	push   %esi
  801d33:	53                   	push   %ebx
  801d34:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d3f:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d45:	8b 45 14             	mov    0x14(%ebp),%eax
  801d48:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d4d:	b8 07 00 00 00       	mov    $0x7,%eax
  801d52:	e8 74 fe ff ff       	call   801bcb <nsipc>
  801d57:	89 c3                	mov    %eax,%ebx
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 1f                	js     801d7c <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d5d:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d62:	7f 21                	jg     801d85 <nsipc_recv+0x56>
  801d64:	39 c6                	cmp    %eax,%esi
  801d66:	7c 1d                	jl     801d85 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d68:	83 ec 04             	sub    $0x4,%esp
  801d6b:	50                   	push   %eax
  801d6c:	68 00 60 80 00       	push   $0x806000
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	e8 3b ed ff ff       	call   800ab4 <memmove>
  801d79:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d7c:	89 d8                	mov    %ebx,%eax
  801d7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5e                   	pop    %esi
  801d83:	5d                   	pop    %ebp
  801d84:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d85:	68 8b 2d 80 00       	push   $0x802d8b
  801d8a:	68 53 2d 80 00       	push   $0x802d53
  801d8f:	6a 62                	push   $0x62
  801d91:	68 a0 2d 80 00       	push   $0x802da0
  801d96:	e8 91 e4 ff ff       	call   80022c <_panic>

00801d9b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	53                   	push   %ebx
  801d9f:	83 ec 04             	sub    $0x4,%esp
  801da2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801da5:	8b 45 08             	mov    0x8(%ebp),%eax
  801da8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801db3:	7f 2e                	jg     801de3 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	53                   	push   %ebx
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	68 0c 60 80 00       	push   $0x80600c
  801dc1:	e8 ee ec ff ff       	call   800ab4 <memmove>
	nsipcbuf.send.req_size = size;
  801dc6:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dd4:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd9:	e8 ed fd ff ff       	call   801bcb <nsipc>
}
  801dde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    
	assert(size < 1600);
  801de3:	68 ac 2d 80 00       	push   $0x802dac
  801de8:	68 53 2d 80 00       	push   $0x802d53
  801ded:	6a 6d                	push   $0x6d
  801def:	68 a0 2d 80 00       	push   $0x802da0
  801df4:	e8 33 e4 ff ff       	call   80022c <_panic>

00801df9 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0a:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e12:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e17:	b8 09 00 00 00       	mov    $0x9,%eax
  801e1c:	e8 aa fd ff ff       	call   801bcb <nsipc>
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	56                   	push   %esi
  801e27:	53                   	push   %ebx
  801e28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	ff 75 08             	pushl  0x8(%ebp)
  801e31:	e8 a7 f3 ff ff       	call   8011dd <fd2data>
  801e36:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e38:	83 c4 08             	add    $0x8,%esp
  801e3b:	68 b8 2d 80 00       	push   $0x802db8
  801e40:	53                   	push   %ebx
  801e41:	e8 e0 ea ff ff       	call   800926 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e46:	8b 46 04             	mov    0x4(%esi),%eax
  801e49:	2b 06                	sub    (%esi),%eax
  801e4b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e51:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e58:	00 00 00 
	stat->st_dev = &devpipe;
  801e5b:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e62:	30 80 00 
	return 0;
}
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e6d:	5b                   	pop    %ebx
  801e6e:	5e                   	pop    %esi
  801e6f:	5d                   	pop    %ebp
  801e70:	c3                   	ret    

00801e71 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	53                   	push   %ebx
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e7b:	53                   	push   %ebx
  801e7c:	6a 00                	push   $0x0
  801e7e:	e8 21 ef ff ff       	call   800da4 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e83:	89 1c 24             	mov    %ebx,(%esp)
  801e86:	e8 52 f3 ff ff       	call   8011dd <fd2data>
  801e8b:	83 c4 08             	add    $0x8,%esp
  801e8e:	50                   	push   %eax
  801e8f:	6a 00                	push   $0x0
  801e91:	e8 0e ef ff ff       	call   800da4 <sys_page_unmap>
}
  801e96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <_pipeisclosed>:
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	57                   	push   %edi
  801e9f:	56                   	push   %esi
  801ea0:	53                   	push   %ebx
  801ea1:	83 ec 1c             	sub    $0x1c,%esp
  801ea4:	89 c7                	mov    %eax,%edi
  801ea6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801ea8:	a1 20 44 80 00       	mov    0x804420,%eax
  801ead:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	57                   	push   %edi
  801eb4:	e8 02 06 00 00       	call   8024bb <pageref>
  801eb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ebc:	89 34 24             	mov    %esi,(%esp)
  801ebf:	e8 f7 05 00 00       	call   8024bb <pageref>
		nn = thisenv->env_runs;
  801ec4:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801eca:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	39 cb                	cmp    %ecx,%ebx
  801ed2:	74 1b                	je     801eef <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ed4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ed7:	75 cf                	jne    801ea8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ed9:	8b 42 58             	mov    0x58(%edx),%eax
  801edc:	6a 01                	push   $0x1
  801ede:	50                   	push   %eax
  801edf:	53                   	push   %ebx
  801ee0:	68 bf 2d 80 00       	push   $0x802dbf
  801ee5:	e8 1d e4 ff ff       	call   800307 <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp
  801eed:	eb b9                	jmp    801ea8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801eef:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ef2:	0f 94 c0             	sete   %al
  801ef5:	0f b6 c0             	movzbl %al,%eax
}
  801ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801efb:	5b                   	pop    %ebx
  801efc:	5e                   	pop    %esi
  801efd:	5f                   	pop    %edi
  801efe:	5d                   	pop    %ebp
  801eff:	c3                   	ret    

00801f00 <devpipe_write>:
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	57                   	push   %edi
  801f04:	56                   	push   %esi
  801f05:	53                   	push   %ebx
  801f06:	83 ec 28             	sub    $0x28,%esp
  801f09:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f0c:	56                   	push   %esi
  801f0d:	e8 cb f2 ff ff       	call   8011dd <fd2data>
  801f12:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f14:	83 c4 10             	add    $0x10,%esp
  801f17:	bf 00 00 00 00       	mov    $0x0,%edi
  801f1c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f1f:	74 4f                	je     801f70 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f21:	8b 43 04             	mov    0x4(%ebx),%eax
  801f24:	8b 0b                	mov    (%ebx),%ecx
  801f26:	8d 51 20             	lea    0x20(%ecx),%edx
  801f29:	39 d0                	cmp    %edx,%eax
  801f2b:	72 14                	jb     801f41 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f2d:	89 da                	mov    %ebx,%edx
  801f2f:	89 f0                	mov    %esi,%eax
  801f31:	e8 65 ff ff ff       	call   801e9b <_pipeisclosed>
  801f36:	85 c0                	test   %eax,%eax
  801f38:	75 3a                	jne    801f74 <devpipe_write+0x74>
			sys_yield();
  801f3a:	e8 c1 ed ff ff       	call   800d00 <sys_yield>
  801f3f:	eb e0                	jmp    801f21 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f44:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f48:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f4b:	89 c2                	mov    %eax,%edx
  801f4d:	c1 fa 1f             	sar    $0x1f,%edx
  801f50:	89 d1                	mov    %edx,%ecx
  801f52:	c1 e9 1b             	shr    $0x1b,%ecx
  801f55:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f58:	83 e2 1f             	and    $0x1f,%edx
  801f5b:	29 ca                	sub    %ecx,%edx
  801f5d:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f61:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f65:	83 c0 01             	add    $0x1,%eax
  801f68:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f6b:	83 c7 01             	add    $0x1,%edi
  801f6e:	eb ac                	jmp    801f1c <devpipe_write+0x1c>
	return i;
  801f70:	89 f8                	mov    %edi,%eax
  801f72:	eb 05                	jmp    801f79 <devpipe_write+0x79>
				return 0;
  801f74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    

00801f81 <devpipe_read>:
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	57                   	push   %edi
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
  801f87:	83 ec 18             	sub    $0x18,%esp
  801f8a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f8d:	57                   	push   %edi
  801f8e:	e8 4a f2 ff ff       	call   8011dd <fd2data>
  801f93:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	be 00 00 00 00       	mov    $0x0,%esi
  801f9d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa0:	74 47                	je     801fe9 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801fa2:	8b 03                	mov    (%ebx),%eax
  801fa4:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fa7:	75 22                	jne    801fcb <devpipe_read+0x4a>
			if (i > 0)
  801fa9:	85 f6                	test   %esi,%esi
  801fab:	75 14                	jne    801fc1 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801fad:	89 da                	mov    %ebx,%edx
  801faf:	89 f8                	mov    %edi,%eax
  801fb1:	e8 e5 fe ff ff       	call   801e9b <_pipeisclosed>
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	75 33                	jne    801fed <devpipe_read+0x6c>
			sys_yield();
  801fba:	e8 41 ed ff ff       	call   800d00 <sys_yield>
  801fbf:	eb e1                	jmp    801fa2 <devpipe_read+0x21>
				return i;
  801fc1:	89 f0                	mov    %esi,%eax
}
  801fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fc6:	5b                   	pop    %ebx
  801fc7:	5e                   	pop    %esi
  801fc8:	5f                   	pop    %edi
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fcb:	99                   	cltd   
  801fcc:	c1 ea 1b             	shr    $0x1b,%edx
  801fcf:	01 d0                	add    %edx,%eax
  801fd1:	83 e0 1f             	and    $0x1f,%eax
  801fd4:	29 d0                	sub    %edx,%eax
  801fd6:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fde:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fe1:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fe4:	83 c6 01             	add    $0x1,%esi
  801fe7:	eb b4                	jmp    801f9d <devpipe_read+0x1c>
	return i;
  801fe9:	89 f0                	mov    %esi,%eax
  801feb:	eb d6                	jmp    801fc3 <devpipe_read+0x42>
				return 0;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	eb cf                	jmp    801fc3 <devpipe_read+0x42>

00801ff4 <pipe>:
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ffc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fff:	50                   	push   %eax
  802000:	e8 ef f1 ff ff       	call   8011f4 <fd_alloc>
  802005:	89 c3                	mov    %eax,%ebx
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 5b                	js     802069 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 07 04 00 00       	push   $0x407
  802016:	ff 75 f4             	pushl  -0xc(%ebp)
  802019:	6a 00                	push   $0x0
  80201b:	e8 ff ec ff ff       	call   800d1f <sys_page_alloc>
  802020:	89 c3                	mov    %eax,%ebx
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	85 c0                	test   %eax,%eax
  802027:	78 40                	js     802069 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80202f:	50                   	push   %eax
  802030:	e8 bf f1 ff ff       	call   8011f4 <fd_alloc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 1b                	js     802059 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	68 07 04 00 00       	push   $0x407
  802046:	ff 75 f0             	pushl  -0x10(%ebp)
  802049:	6a 00                	push   $0x0
  80204b:	e8 cf ec ff ff       	call   800d1f <sys_page_alloc>
  802050:	89 c3                	mov    %eax,%ebx
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	79 19                	jns    802072 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  802059:	83 ec 08             	sub    $0x8,%esp
  80205c:	ff 75 f4             	pushl  -0xc(%ebp)
  80205f:	6a 00                	push   $0x0
  802061:	e8 3e ed ff ff       	call   800da4 <sys_page_unmap>
  802066:	83 c4 10             	add    $0x10,%esp
}
  802069:	89 d8                	mov    %ebx,%eax
  80206b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80206e:	5b                   	pop    %ebx
  80206f:	5e                   	pop    %esi
  802070:	5d                   	pop    %ebp
  802071:	c3                   	ret    
	va = fd2data(fd0);
  802072:	83 ec 0c             	sub    $0xc,%esp
  802075:	ff 75 f4             	pushl  -0xc(%ebp)
  802078:	e8 60 f1 ff ff       	call   8011dd <fd2data>
  80207d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80207f:	83 c4 0c             	add    $0xc,%esp
  802082:	68 07 04 00 00       	push   $0x407
  802087:	50                   	push   %eax
  802088:	6a 00                	push   $0x0
  80208a:	e8 90 ec ff ff       	call   800d1f <sys_page_alloc>
  80208f:	89 c3                	mov    %eax,%ebx
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	85 c0                	test   %eax,%eax
  802096:	0f 88 8c 00 00 00    	js     802128 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209c:	83 ec 0c             	sub    $0xc,%esp
  80209f:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a2:	e8 36 f1 ff ff       	call   8011dd <fd2data>
  8020a7:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8020ae:	50                   	push   %eax
  8020af:	6a 00                	push   $0x0
  8020b1:	56                   	push   %esi
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 a9 ec ff ff       	call   800d62 <sys_page_map>
  8020b9:	89 c3                	mov    %eax,%ebx
  8020bb:	83 c4 20             	add    $0x20,%esp
  8020be:	85 c0                	test   %eax,%eax
  8020c0:	78 58                	js     80211a <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020cb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8020d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020da:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020e0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f2:	e8 d6 f0 ff ff       	call   8011cd <fd2num>
  8020f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fa:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020fc:	83 c4 04             	add    $0x4,%esp
  8020ff:	ff 75 f0             	pushl  -0x10(%ebp)
  802102:	e8 c6 f0 ff ff       	call   8011cd <fd2num>
  802107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80210a:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	bb 00 00 00 00       	mov    $0x0,%ebx
  802115:	e9 4f ff ff ff       	jmp    802069 <pipe+0x75>
	sys_page_unmap(0, va);
  80211a:	83 ec 08             	sub    $0x8,%esp
  80211d:	56                   	push   %esi
  80211e:	6a 00                	push   $0x0
  802120:	e8 7f ec ff ff       	call   800da4 <sys_page_unmap>
  802125:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802128:	83 ec 08             	sub    $0x8,%esp
  80212b:	ff 75 f0             	pushl  -0x10(%ebp)
  80212e:	6a 00                	push   $0x0
  802130:	e8 6f ec ff ff       	call   800da4 <sys_page_unmap>
  802135:	83 c4 10             	add    $0x10,%esp
  802138:	e9 1c ff ff ff       	jmp    802059 <pipe+0x65>

0080213d <pipeisclosed>:
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
  802140:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802143:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802146:	50                   	push   %eax
  802147:	ff 75 08             	pushl  0x8(%ebp)
  80214a:	e8 f4 f0 ff ff       	call   801243 <fd_lookup>
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	85 c0                	test   %eax,%eax
  802154:	78 18                	js     80216e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	ff 75 f4             	pushl  -0xc(%ebp)
  80215c:	e8 7c f0 ff ff       	call   8011dd <fd2data>
	return _pipeisclosed(fd, p);
  802161:	89 c2                	mov    %eax,%edx
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	e8 30 fd ff ff       	call   801e9b <_pipeisclosed>
  80216b:	83 c4 10             	add    $0x10,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	56                   	push   %esi
  802174:	53                   	push   %ebx
  802175:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802178:	85 f6                	test   %esi,%esi
  80217a:	74 13                	je     80218f <wait+0x1f>
	e = &envs[ENVX(envid)];
  80217c:	89 f3                	mov    %esi,%ebx
  80217e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802184:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802187:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80218d:	eb 1b                	jmp    8021aa <wait+0x3a>
	assert(envid != 0);
  80218f:	68 d7 2d 80 00       	push   $0x802dd7
  802194:	68 53 2d 80 00       	push   $0x802d53
  802199:	6a 09                	push   $0x9
  80219b:	68 e2 2d 80 00       	push   $0x802de2
  8021a0:	e8 87 e0 ff ff       	call   80022c <_panic>
		sys_yield();
  8021a5:	e8 56 eb ff ff       	call   800d00 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8021aa:	8b 43 48             	mov    0x48(%ebx),%eax
  8021ad:	39 f0                	cmp    %esi,%eax
  8021af:	75 07                	jne    8021b8 <wait+0x48>
  8021b1:	8b 43 54             	mov    0x54(%ebx),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	75 ed                	jne    8021a5 <wait+0x35>
}
  8021b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5e                   	pop    %esi
  8021bd:	5d                   	pop    %ebp
  8021be:	c3                   	ret    

008021bf <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8021cf:	68 ed 2d 80 00       	push   $0x802ded
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	e8 4a e7 ff ff       	call   800926 <strcpy>
	return 0;
}
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <devcons_write>:
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	57                   	push   %edi
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8021ef:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8021f4:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8021fa:	eb 2f                	jmp    80222b <devcons_write+0x48>
		m = n - tot;
  8021fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021ff:	29 f3                	sub    %esi,%ebx
  802201:	83 fb 7f             	cmp    $0x7f,%ebx
  802204:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802209:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	53                   	push   %ebx
  802210:	89 f0                	mov    %esi,%eax
  802212:	03 45 0c             	add    0xc(%ebp),%eax
  802215:	50                   	push   %eax
  802216:	57                   	push   %edi
  802217:	e8 98 e8 ff ff       	call   800ab4 <memmove>
		sys_cputs(buf, m);
  80221c:	83 c4 08             	add    $0x8,%esp
  80221f:	53                   	push   %ebx
  802220:	57                   	push   %edi
  802221:	e8 3d ea ff ff       	call   800c63 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802226:	01 de                	add    %ebx,%esi
  802228:	83 c4 10             	add    $0x10,%esp
  80222b:	3b 75 10             	cmp    0x10(%ebp),%esi
  80222e:	72 cc                	jb     8021fc <devcons_write+0x19>
}
  802230:	89 f0                	mov    %esi,%eax
  802232:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802235:	5b                   	pop    %ebx
  802236:	5e                   	pop    %esi
  802237:	5f                   	pop    %edi
  802238:	5d                   	pop    %ebp
  802239:	c3                   	ret    

0080223a <devcons_read>:
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 08             	sub    $0x8,%esp
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802245:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802249:	75 07                	jne    802252 <devcons_read+0x18>
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    
		sys_yield();
  80224d:	e8 ae ea ff ff       	call   800d00 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802252:	e8 2a ea ff ff       	call   800c81 <sys_cgetc>
  802257:	85 c0                	test   %eax,%eax
  802259:	74 f2                	je     80224d <devcons_read+0x13>
	if (c < 0)
  80225b:	85 c0                	test   %eax,%eax
  80225d:	78 ec                	js     80224b <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  80225f:	83 f8 04             	cmp    $0x4,%eax
  802262:	74 0c                	je     802270 <devcons_read+0x36>
	*(char*)vbuf = c;
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	88 02                	mov    %al,(%edx)
	return 1;
  802269:	b8 01 00 00 00       	mov    $0x1,%eax
  80226e:	eb db                	jmp    80224b <devcons_read+0x11>
		return 0;
  802270:	b8 00 00 00 00       	mov    $0x0,%eax
  802275:	eb d4                	jmp    80224b <devcons_read+0x11>

00802277 <cputchar>:
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802283:	6a 01                	push   $0x1
  802285:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802288:	50                   	push   %eax
  802289:	e8 d5 e9 ff ff       	call   800c63 <sys_cputs>
}
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <getchar>:
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802299:	6a 01                	push   $0x1
  80229b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80229e:	50                   	push   %eax
  80229f:	6a 00                	push   $0x0
  8022a1:	e8 0e f2 ff ff       	call   8014b4 <read>
	if (r < 0)
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	78 08                	js     8022b5 <getchar+0x22>
	if (r < 1)
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	7e 06                	jle    8022b7 <getchar+0x24>
	return c;
  8022b1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    
		return -E_EOF;
  8022b7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022bc:	eb f7                	jmp    8022b5 <getchar+0x22>

008022be <iscons>:
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c7:	50                   	push   %eax
  8022c8:	ff 75 08             	pushl  0x8(%ebp)
  8022cb:	e8 73 ef ff ff       	call   801243 <fd_lookup>
  8022d0:	83 c4 10             	add    $0x10,%esp
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	78 11                	js     8022e8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022e0:	39 10                	cmp    %edx,(%eax)
  8022e2:	0f 94 c0             	sete   %al
  8022e5:	0f b6 c0             	movzbl %al,%eax
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <opencons>:
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8022f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f3:	50                   	push   %eax
  8022f4:	e8 fb ee ff ff       	call   8011f4 <fd_alloc>
  8022f9:	83 c4 10             	add    $0x10,%esp
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	78 3a                	js     80233a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 07 04 00 00       	push   $0x407
  802308:	ff 75 f4             	pushl  -0xc(%ebp)
  80230b:	6a 00                	push   $0x0
  80230d:	e8 0d ea ff ff       	call   800d1f <sys_page_alloc>
  802312:	83 c4 10             	add    $0x10,%esp
  802315:	85 c0                	test   %eax,%eax
  802317:	78 21                	js     80233a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802322:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80232e:	83 ec 0c             	sub    $0xc,%esp
  802331:	50                   	push   %eax
  802332:	e8 96 ee ff ff       	call   8011cd <fd2num>
  802337:	83 c4 10             	add    $0x10,%esp
}
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  802342:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802349:	74 0a                	je     802355 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802355:	a1 20 44 80 00       	mov    0x804420,%eax
  80235a:	8b 40 48             	mov    0x48(%eax),%eax
  80235d:	83 ec 04             	sub    $0x4,%esp
  802360:	6a 07                	push   $0x7
  802362:	68 00 f0 bf ee       	push   $0xeebff000
  802367:	50                   	push   %eax
  802368:	e8 b2 e9 ff ff       	call   800d1f <sys_page_alloc>
  80236d:	83 c4 10             	add    $0x10,%esp
  802370:	85 c0                	test   %eax,%eax
  802372:	78 1b                	js     80238f <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802374:	a1 20 44 80 00       	mov    0x804420,%eax
  802379:	8b 40 48             	mov    0x48(%eax),%eax
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	68 a1 23 80 00       	push   $0x8023a1
  802384:	50                   	push   %eax
  802385:	e8 e0 ea ff ff       	call   800e6a <sys_env_set_pgfault_upcall>
  80238a:	83 c4 10             	add    $0x10,%esp
  80238d:	eb bc                	jmp    80234b <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  80238f:	50                   	push   %eax
  802390:	68 f9 2d 80 00       	push   $0x802df9
  802395:	6a 22                	push   $0x22
  802397:	68 11 2e 80 00       	push   $0x802e11
  80239c:	e8 8b de ff ff       	call   80022c <_panic>

008023a1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8023a1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8023a2:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8023a7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8023a9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  8023ac:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  8023b0:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  8023b3:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  8023b7:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  8023bb:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  8023bd:	83 c4 08             	add    $0x8,%esp
	popal
  8023c0:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  8023c1:	83 c4 04             	add    $0x4,%esp
	popfl
  8023c4:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8023c5:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8023c6:	c3                   	ret    

008023c7 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	56                   	push   %esi
  8023cb:	53                   	push   %ebx
  8023cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8023cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8023d5:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8023d7:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8023dc:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8023df:	83 ec 0c             	sub    $0xc,%esp
  8023e2:	50                   	push   %eax
  8023e3:	e8 e7 ea ff ff       	call   800ecf <sys_ipc_recv>
	if (from_env_store)
  8023e8:	83 c4 10             	add    $0x10,%esp
  8023eb:	85 f6                	test   %esi,%esi
  8023ed:	74 14                	je     802403 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8023ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f4:	85 c0                	test   %eax,%eax
  8023f6:	78 09                	js     802401 <ipc_recv+0x3a>
  8023f8:	8b 15 20 44 80 00    	mov    0x804420,%edx
  8023fe:	8b 52 74             	mov    0x74(%edx),%edx
  802401:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802403:	85 db                	test   %ebx,%ebx
  802405:	74 14                	je     80241b <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802407:	ba 00 00 00 00       	mov    $0x0,%edx
  80240c:	85 c0                	test   %eax,%eax
  80240e:	78 09                	js     802419 <ipc_recv+0x52>
  802410:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802416:	8b 52 78             	mov    0x78(%edx),%edx
  802419:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  80241b:	85 c0                	test   %eax,%eax
  80241d:	78 08                	js     802427 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80241f:	a1 20 44 80 00       	mov    0x804420,%eax
  802424:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802427:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242a:	5b                   	pop    %ebx
  80242b:	5e                   	pop    %esi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	53                   	push   %ebx
  802434:	83 ec 0c             	sub    $0xc,%esp
  802437:	8b 7d 08             	mov    0x8(%ebp),%edi
  80243a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80243d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802440:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802442:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802447:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80244a:	ff 75 14             	pushl  0x14(%ebp)
  80244d:	53                   	push   %ebx
  80244e:	56                   	push   %esi
  80244f:	57                   	push   %edi
  802450:	e8 57 ea ff ff       	call   800eac <sys_ipc_try_send>
		if (ret == 0)
  802455:	83 c4 10             	add    $0x10,%esp
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 1e                	je     80247a <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  80245c:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80245f:	75 07                	jne    802468 <ipc_send+0x3a>
			sys_yield();
  802461:	e8 9a e8 ff ff       	call   800d00 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802466:	eb e2                	jmp    80244a <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802468:	50                   	push   %eax
  802469:	68 1f 2e 80 00       	push   $0x802e1f
  80246e:	6a 3d                	push   $0x3d
  802470:	68 33 2e 80 00       	push   $0x802e33
  802475:	e8 b2 dd ff ff       	call   80022c <_panic>
	}
	// panic("ipc_send not implemented");
}
  80247a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5f                   	pop    %edi
  802480:	5d                   	pop    %ebp
  802481:	c3                   	ret    

00802482 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802488:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80248d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802490:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802496:	8b 52 50             	mov    0x50(%edx),%edx
  802499:	39 ca                	cmp    %ecx,%edx
  80249b:	74 11                	je     8024ae <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  80249d:	83 c0 01             	add    $0x1,%eax
  8024a0:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024a5:	75 e6                	jne    80248d <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	eb 0b                	jmp    8024b9 <ipc_find_env+0x37>
			return envs[i].env_id;
  8024ae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8024b6:	8b 40 48             	mov    0x48(%eax),%eax
}
  8024b9:	5d                   	pop    %ebp
  8024ba:	c3                   	ret    

008024bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024bb:	55                   	push   %ebp
  8024bc:	89 e5                	mov    %esp,%ebp
  8024be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024c1:	89 d0                	mov    %edx,%eax
  8024c3:	c1 e8 16             	shr    $0x16,%eax
  8024c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024cd:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8024d2:	f6 c1 01             	test   $0x1,%cl
  8024d5:	74 1d                	je     8024f4 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8024d7:	c1 ea 0c             	shr    $0xc,%edx
  8024da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024e1:	f6 c2 01             	test   $0x1,%dl
  8024e4:	74 0e                	je     8024f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024e6:	c1 ea 0c             	shr    $0xc,%edx
  8024e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024f0:	ef 
  8024f1:	0f b7 c0             	movzwl %ax,%eax
}
  8024f4:	5d                   	pop    %ebp
  8024f5:	c3                   	ret    
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80250b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80250f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802513:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802517:	85 d2                	test   %edx,%edx
  802519:	75 35                	jne    802550 <__udivdi3+0x50>
  80251b:	39 f3                	cmp    %esi,%ebx
  80251d:	0f 87 bd 00 00 00    	ja     8025e0 <__udivdi3+0xe0>
  802523:	85 db                	test   %ebx,%ebx
  802525:	89 d9                	mov    %ebx,%ecx
  802527:	75 0b                	jne    802534 <__udivdi3+0x34>
  802529:	b8 01 00 00 00       	mov    $0x1,%eax
  80252e:	31 d2                	xor    %edx,%edx
  802530:	f7 f3                	div    %ebx
  802532:	89 c1                	mov    %eax,%ecx
  802534:	31 d2                	xor    %edx,%edx
  802536:	89 f0                	mov    %esi,%eax
  802538:	f7 f1                	div    %ecx
  80253a:	89 c6                	mov    %eax,%esi
  80253c:	89 e8                	mov    %ebp,%eax
  80253e:	89 f7                	mov    %esi,%edi
  802540:	f7 f1                	div    %ecx
  802542:	89 fa                	mov    %edi,%edx
  802544:	83 c4 1c             	add    $0x1c,%esp
  802547:	5b                   	pop    %ebx
  802548:	5e                   	pop    %esi
  802549:	5f                   	pop    %edi
  80254a:	5d                   	pop    %ebp
  80254b:	c3                   	ret    
  80254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802550:	39 f2                	cmp    %esi,%edx
  802552:	77 7c                	ja     8025d0 <__udivdi3+0xd0>
  802554:	0f bd fa             	bsr    %edx,%edi
  802557:	83 f7 1f             	xor    $0x1f,%edi
  80255a:	0f 84 98 00 00 00    	je     8025f8 <__udivdi3+0xf8>
  802560:	89 f9                	mov    %edi,%ecx
  802562:	b8 20 00 00 00       	mov    $0x20,%eax
  802567:	29 f8                	sub    %edi,%eax
  802569:	d3 e2                	shl    %cl,%edx
  80256b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80256f:	89 c1                	mov    %eax,%ecx
  802571:	89 da                	mov    %ebx,%edx
  802573:	d3 ea                	shr    %cl,%edx
  802575:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802579:	09 d1                	or     %edx,%ecx
  80257b:	89 f2                	mov    %esi,%edx
  80257d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802581:	89 f9                	mov    %edi,%ecx
  802583:	d3 e3                	shl    %cl,%ebx
  802585:	89 c1                	mov    %eax,%ecx
  802587:	d3 ea                	shr    %cl,%edx
  802589:	89 f9                	mov    %edi,%ecx
  80258b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80258f:	d3 e6                	shl    %cl,%esi
  802591:	89 eb                	mov    %ebp,%ebx
  802593:	89 c1                	mov    %eax,%ecx
  802595:	d3 eb                	shr    %cl,%ebx
  802597:	09 de                	or     %ebx,%esi
  802599:	89 f0                	mov    %esi,%eax
  80259b:	f7 74 24 08          	divl   0x8(%esp)
  80259f:	89 d6                	mov    %edx,%esi
  8025a1:	89 c3                	mov    %eax,%ebx
  8025a3:	f7 64 24 0c          	mull   0xc(%esp)
  8025a7:	39 d6                	cmp    %edx,%esi
  8025a9:	72 0c                	jb     8025b7 <__udivdi3+0xb7>
  8025ab:	89 f9                	mov    %edi,%ecx
  8025ad:	d3 e5                	shl    %cl,%ebp
  8025af:	39 c5                	cmp    %eax,%ebp
  8025b1:	73 5d                	jae    802610 <__udivdi3+0x110>
  8025b3:	39 d6                	cmp    %edx,%esi
  8025b5:	75 59                	jne    802610 <__udivdi3+0x110>
  8025b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025ba:	31 ff                	xor    %edi,%edi
  8025bc:	89 fa                	mov    %edi,%edx
  8025be:	83 c4 1c             	add    $0x1c,%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	8d 76 00             	lea    0x0(%esi),%esi
  8025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8025d0:	31 ff                	xor    %edi,%edi
  8025d2:	31 c0                	xor    %eax,%eax
  8025d4:	89 fa                	mov    %edi,%edx
  8025d6:	83 c4 1c             	add    $0x1c,%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5f                   	pop    %edi
  8025dc:	5d                   	pop    %ebp
  8025dd:	c3                   	ret    
  8025de:	66 90                	xchg   %ax,%ax
  8025e0:	31 ff                	xor    %edi,%edi
  8025e2:	89 e8                	mov    %ebp,%eax
  8025e4:	89 f2                	mov    %esi,%edx
  8025e6:	f7 f3                	div    %ebx
  8025e8:	89 fa                	mov    %edi,%edx
  8025ea:	83 c4 1c             	add    $0x1c,%esp
  8025ed:	5b                   	pop    %ebx
  8025ee:	5e                   	pop    %esi
  8025ef:	5f                   	pop    %edi
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    
  8025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025f8:	39 f2                	cmp    %esi,%edx
  8025fa:	72 06                	jb     802602 <__udivdi3+0x102>
  8025fc:	31 c0                	xor    %eax,%eax
  8025fe:	39 eb                	cmp    %ebp,%ebx
  802600:	77 d2                	ja     8025d4 <__udivdi3+0xd4>
  802602:	b8 01 00 00 00       	mov    $0x1,%eax
  802607:	eb cb                	jmp    8025d4 <__udivdi3+0xd4>
  802609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802610:	89 d8                	mov    %ebx,%eax
  802612:	31 ff                	xor    %edi,%edi
  802614:	eb be                	jmp    8025d4 <__udivdi3+0xd4>
  802616:	66 90                	xchg   %ax,%ax
  802618:	66 90                	xchg   %ax,%ax
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__umoddi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	53                   	push   %ebx
  802624:	83 ec 1c             	sub    $0x1c,%esp
  802627:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80262b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80262f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802637:	85 ed                	test   %ebp,%ebp
  802639:	89 f0                	mov    %esi,%eax
  80263b:	89 da                	mov    %ebx,%edx
  80263d:	75 19                	jne    802658 <__umoddi3+0x38>
  80263f:	39 df                	cmp    %ebx,%edi
  802641:	0f 86 b1 00 00 00    	jbe    8026f8 <__umoddi3+0xd8>
  802647:	f7 f7                	div    %edi
  802649:	89 d0                	mov    %edx,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	83 c4 1c             	add    $0x1c,%esp
  802650:	5b                   	pop    %ebx
  802651:	5e                   	pop    %esi
  802652:	5f                   	pop    %edi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    
  802655:	8d 76 00             	lea    0x0(%esi),%esi
  802658:	39 dd                	cmp    %ebx,%ebp
  80265a:	77 f1                	ja     80264d <__umoddi3+0x2d>
  80265c:	0f bd cd             	bsr    %ebp,%ecx
  80265f:	83 f1 1f             	xor    $0x1f,%ecx
  802662:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802666:	0f 84 b4 00 00 00    	je     802720 <__umoddi3+0x100>
  80266c:	b8 20 00 00 00       	mov    $0x20,%eax
  802671:	89 c2                	mov    %eax,%edx
  802673:	8b 44 24 04          	mov    0x4(%esp),%eax
  802677:	29 c2                	sub    %eax,%edx
  802679:	89 c1                	mov    %eax,%ecx
  80267b:	89 f8                	mov    %edi,%eax
  80267d:	d3 e5                	shl    %cl,%ebp
  80267f:	89 d1                	mov    %edx,%ecx
  802681:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802685:	d3 e8                	shr    %cl,%eax
  802687:	09 c5                	or     %eax,%ebp
  802689:	8b 44 24 04          	mov    0x4(%esp),%eax
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	d3 e7                	shl    %cl,%edi
  802691:	89 d1                	mov    %edx,%ecx
  802693:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802697:	89 df                	mov    %ebx,%edi
  802699:	d3 ef                	shr    %cl,%edi
  80269b:	89 c1                	mov    %eax,%ecx
  80269d:	89 f0                	mov    %esi,%eax
  80269f:	d3 e3                	shl    %cl,%ebx
  8026a1:	89 d1                	mov    %edx,%ecx
  8026a3:	89 fa                	mov    %edi,%edx
  8026a5:	d3 e8                	shr    %cl,%eax
  8026a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8026ac:	09 d8                	or     %ebx,%eax
  8026ae:	f7 f5                	div    %ebp
  8026b0:	d3 e6                	shl    %cl,%esi
  8026b2:	89 d1                	mov    %edx,%ecx
  8026b4:	f7 64 24 08          	mull   0x8(%esp)
  8026b8:	39 d1                	cmp    %edx,%ecx
  8026ba:	89 c3                	mov    %eax,%ebx
  8026bc:	89 d7                	mov    %edx,%edi
  8026be:	72 06                	jb     8026c6 <__umoddi3+0xa6>
  8026c0:	75 0e                	jne    8026d0 <__umoddi3+0xb0>
  8026c2:	39 c6                	cmp    %eax,%esi
  8026c4:	73 0a                	jae    8026d0 <__umoddi3+0xb0>
  8026c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8026ca:	19 ea                	sbb    %ebp,%edx
  8026cc:	89 d7                	mov    %edx,%edi
  8026ce:	89 c3                	mov    %eax,%ebx
  8026d0:	89 ca                	mov    %ecx,%edx
  8026d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8026d7:	29 de                	sub    %ebx,%esi
  8026d9:	19 fa                	sbb    %edi,%edx
  8026db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8026df:	89 d0                	mov    %edx,%eax
  8026e1:	d3 e0                	shl    %cl,%eax
  8026e3:	89 d9                	mov    %ebx,%ecx
  8026e5:	d3 ee                	shr    %cl,%esi
  8026e7:	d3 ea                	shr    %cl,%edx
  8026e9:	09 f0                	or     %esi,%eax
  8026eb:	83 c4 1c             	add    $0x1c,%esp
  8026ee:	5b                   	pop    %ebx
  8026ef:	5e                   	pop    %esi
  8026f0:	5f                   	pop    %edi
  8026f1:	5d                   	pop    %ebp
  8026f2:	c3                   	ret    
  8026f3:	90                   	nop
  8026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	85 ff                	test   %edi,%edi
  8026fa:	89 f9                	mov    %edi,%ecx
  8026fc:	75 0b                	jne    802709 <__umoddi3+0xe9>
  8026fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802703:	31 d2                	xor    %edx,%edx
  802705:	f7 f7                	div    %edi
  802707:	89 c1                	mov    %eax,%ecx
  802709:	89 d8                	mov    %ebx,%eax
  80270b:	31 d2                	xor    %edx,%edx
  80270d:	f7 f1                	div    %ecx
  80270f:	89 f0                	mov    %esi,%eax
  802711:	f7 f1                	div    %ecx
  802713:	e9 31 ff ff ff       	jmp    802649 <__umoddi3+0x29>
  802718:	90                   	nop
  802719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802720:	39 dd                	cmp    %ebx,%ebp
  802722:	72 08                	jb     80272c <__umoddi3+0x10c>
  802724:	39 f7                	cmp    %esi,%edi
  802726:	0f 87 21 ff ff ff    	ja     80264d <__umoddi3+0x2d>
  80272c:	89 da                	mov    %ebx,%edx
  80272e:	89 f0                	mov    %esi,%eax
  802730:	29 f8                	sub    %edi,%eax
  802732:	19 ea                	sbb    %ebp,%edx
  802734:	e9 14 ff ff ff       	jmp    80264d <__umoddi3+0x2d>

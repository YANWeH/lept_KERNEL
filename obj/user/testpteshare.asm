
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 65 01 00 00       	call   800196 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  800039:	ff 35 00 40 80 00    	pushl  0x804000
  80003f:	68 00 00 00 a0       	push   $0xa0000000
  800044:	e8 a7 08 00 00       	call   8008f0 <strcpy>
	exit();
  800049:	e8 8e 01 00 00       	call   8001dc <exit>
}
  80004e:	83 c4 10             	add    $0x10,%esp
  800051:	c9                   	leave  
  800052:	c3                   	ret    

00800053 <umain>:
{
  800053:	55                   	push   %ebp
  800054:	89 e5                	mov    %esp,%ebp
  800056:	53                   	push   %ebx
  800057:	83 ec 04             	sub    $0x4,%esp
	if (argc != 0)
  80005a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80005e:	0f 85 d2 00 00 00    	jne    800136 <umain+0xe3>
	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800064:	83 ec 04             	sub    $0x4,%esp
  800067:	68 07 04 00 00       	push   $0x407
  80006c:	68 00 00 00 a0       	push   $0xa0000000
  800071:	6a 00                	push   $0x0
  800073:	e8 71 0c 00 00       	call   800ce9 <sys_page_alloc>
  800078:	83 c4 10             	add    $0x10,%esp
  80007b:	85 c0                	test   %eax,%eax
  80007d:	0f 88 bd 00 00 00    	js     800140 <umain+0xed>
	if ((r = fork()) < 0)
  800083:	e8 4a 0f 00 00       	call   800fd2 <fork>
  800088:	89 c3                	mov    %eax,%ebx
  80008a:	85 c0                	test   %eax,%eax
  80008c:	0f 88 c0 00 00 00    	js     800152 <umain+0xff>
	if (r == 0) {
  800092:	85 c0                	test   %eax,%eax
  800094:	0f 84 ca 00 00 00    	je     800164 <umain+0x111>
	wait(r);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	53                   	push   %ebx
  80009e:	e8 8e 26 00 00       	call   802731 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000a3:	83 c4 08             	add    $0x8,%esp
  8000a6:	ff 35 04 40 80 00    	pushl  0x804004
  8000ac:	68 00 00 00 a0       	push   $0xa0000000
  8000b1:	e8 e0 08 00 00       	call   800996 <strcmp>
  8000b6:	83 c4 08             	add    $0x8,%esp
  8000b9:	85 c0                	test   %eax,%eax
  8000bb:	b8 00 2d 80 00       	mov    $0x802d00,%eax
  8000c0:	ba 06 2d 80 00       	mov    $0x802d06,%edx
  8000c5:	0f 45 c2             	cmovne %edx,%eax
  8000c8:	50                   	push   %eax
  8000c9:	68 3c 2d 80 00       	push   $0x802d3c
  8000ce:	e8 fe 01 00 00       	call   8002d1 <cprintf>
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000d3:	6a 00                	push   $0x0
  8000d5:	68 57 2d 80 00       	push   $0x802d57
  8000da:	68 5c 2d 80 00       	push   $0x802d5c
  8000df:	68 5b 2d 80 00       	push   $0x802d5b
  8000e4:	e8 19 1e 00 00       	call   801f02 <spawnl>
  8000e9:	83 c4 20             	add    $0x20,%esp
  8000ec:	85 c0                	test   %eax,%eax
  8000ee:	0f 88 90 00 00 00    	js     800184 <umain+0x131>
	wait(r);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 34 26 00 00       	call   802731 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  8000fd:	83 c4 08             	add    $0x8,%esp
  800100:	ff 35 00 40 80 00    	pushl  0x804000
  800106:	68 00 00 00 a0       	push   $0xa0000000
  80010b:	e8 86 08 00 00       	call   800996 <strcmp>
  800110:	83 c4 08             	add    $0x8,%esp
  800113:	85 c0                	test   %eax,%eax
  800115:	b8 00 2d 80 00       	mov    $0x802d00,%eax
  80011a:	ba 06 2d 80 00       	mov    $0x802d06,%edx
  80011f:	0f 45 c2             	cmovne %edx,%eax
  800122:	50                   	push   %eax
  800123:	68 73 2d 80 00       	push   $0x802d73
  800128:	e8 a4 01 00 00       	call   8002d1 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80012d:	cc                   	int3   
}
  80012e:	83 c4 10             	add    $0x10,%esp
  800131:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800134:	c9                   	leave  
  800135:	c3                   	ret    
		childofspawn();
  800136:	e8 f8 fe ff ff       	call   800033 <childofspawn>
  80013b:	e9 24 ff ff ff       	jmp    800064 <umain+0x11>
		panic("sys_page_alloc: %e", r);
  800140:	50                   	push   %eax
  800141:	68 0c 2d 80 00       	push   $0x802d0c
  800146:	6a 13                	push   $0x13
  800148:	68 1f 2d 80 00       	push   $0x802d1f
  80014d:	e8 a4 00 00 00       	call   8001f6 <_panic>
		panic("fork: %e", r);
  800152:	50                   	push   %eax
  800153:	68 33 2d 80 00       	push   $0x802d33
  800158:	6a 17                	push   $0x17
  80015a:	68 1f 2d 80 00       	push   $0x802d1f
  80015f:	e8 92 00 00 00       	call   8001f6 <_panic>
		strcpy(VA, msg);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	ff 35 04 40 80 00    	pushl  0x804004
  80016d:	68 00 00 00 a0       	push   $0xa0000000
  800172:	e8 79 07 00 00       	call   8008f0 <strcpy>
		exit();
  800177:	e8 60 00 00 00       	call   8001dc <exit>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	e9 16 ff ff ff       	jmp    80009a <umain+0x47>
		panic("spawn: %e", r);
  800184:	50                   	push   %eax
  800185:	68 69 2d 80 00       	push   $0x802d69
  80018a:	6a 21                	push   $0x21
  80018c:	68 1f 2d 80 00       	push   $0x802d1f
  800191:	e8 60 00 00 00       	call   8001f6 <_panic>

00800196 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
  80019b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80019e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001a1:	e8 05 0b 00 00       	call   800cab <sys_getenvid>
  8001a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ab:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001b3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001b8:	85 db                	test   %ebx,%ebx
  8001ba:	7e 07                	jle    8001c3 <libmain+0x2d>
		binaryname = argv[0];
  8001bc:	8b 06                	mov    (%esi),%eax
  8001be:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	e8 86 fe ff ff       	call   800053 <umain>

	// exit gracefully
	exit();
  8001cd:	e8 0a 00 00 00       	call   8001dc <exit>
}
  8001d2:	83 c4 10             	add    $0x10,%esp
  8001d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d8:	5b                   	pop    %ebx
  8001d9:	5e                   	pop    %esi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <exit>:

#include <inc/lib.h>

void exit(void)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001e2:	e8 86 11 00 00       	call   80136d <close_all>
	sys_env_destroy(0);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 79 0a 00 00       	call   800c6a <sys_env_destroy>
}
  8001f1:	83 c4 10             	add    $0x10,%esp
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8001fb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001fe:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800204:	e8 a2 0a 00 00       	call   800cab <sys_getenvid>
  800209:	83 ec 0c             	sub    $0xc,%esp
  80020c:	ff 75 0c             	pushl  0xc(%ebp)
  80020f:	ff 75 08             	pushl  0x8(%ebp)
  800212:	56                   	push   %esi
  800213:	50                   	push   %eax
  800214:	68 b8 2d 80 00       	push   $0x802db8
  800219:	e8 b3 00 00 00       	call   8002d1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80021e:	83 c4 18             	add    $0x18,%esp
  800221:	53                   	push   %ebx
  800222:	ff 75 10             	pushl  0x10(%ebp)
  800225:	e8 56 00 00 00       	call   800280 <vcprintf>
	cprintf("\n");
  80022a:	c7 04 24 c1 33 80 00 	movl   $0x8033c1,(%esp)
  800231:	e8 9b 00 00 00       	call   8002d1 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800239:	cc                   	int3   
  80023a:	eb fd                	jmp    800239 <_panic+0x43>

0080023c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	53                   	push   %ebx
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800246:	8b 13                	mov    (%ebx),%edx
  800248:	8d 42 01             	lea    0x1(%edx),%eax
  80024b:	89 03                	mov    %eax,(%ebx)
  80024d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800250:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800254:	3d ff 00 00 00       	cmp    $0xff,%eax
  800259:	74 09                	je     800264 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80025b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80025f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800262:	c9                   	leave  
  800263:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	68 ff 00 00 00       	push   $0xff
  80026c:	8d 43 08             	lea    0x8(%ebx),%eax
  80026f:	50                   	push   %eax
  800270:	e8 b8 09 00 00       	call   800c2d <sys_cputs>
		b->idx = 0;
  800275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	eb db                	jmp    80025b <putch+0x1f>

00800280 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800289:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800290:	00 00 00 
	b.cnt = 0;
  800293:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	68 3c 02 80 00       	push   $0x80023c
  8002af:	e8 1a 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002b4:	83 c4 08             	add    $0x8,%esp
  8002b7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8002bd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 64 09 00 00       	call   800c2d <sys_cputs>

	return b.cnt;
}
  8002c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002d7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002da:	50                   	push   %eax
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	e8 9d ff ff ff       	call   800280 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e3:	c9                   	leave  
  8002e4:	c3                   	ret    

008002e5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 1c             	sub    $0x1c,%esp
  8002ee:	89 c7                	mov    %eax,%edi
  8002f0:	89 d6                	mov    %edx,%esi
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fb:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800301:	bb 00 00 00 00       	mov    $0x0,%ebx
  800306:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80030c:	39 d3                	cmp    %edx,%ebx
  80030e:	72 05                	jb     800315 <printnum+0x30>
  800310:	39 45 10             	cmp    %eax,0x10(%ebp)
  800313:	77 7a                	ja     80038f <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	ff 75 18             	pushl  0x18(%ebp)
  80031b:	8b 45 14             	mov    0x14(%ebp),%eax
  80031e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800321:	53                   	push   %ebx
  800322:	ff 75 10             	pushl  0x10(%ebp)
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032b:	ff 75 e0             	pushl  -0x20(%ebp)
  80032e:	ff 75 dc             	pushl  -0x24(%ebp)
  800331:	ff 75 d8             	pushl  -0x28(%ebp)
  800334:	e8 87 27 00 00       	call   802ac0 <__udivdi3>
  800339:	83 c4 18             	add    $0x18,%esp
  80033c:	52                   	push   %edx
  80033d:	50                   	push   %eax
  80033e:	89 f2                	mov    %esi,%edx
  800340:	89 f8                	mov    %edi,%eax
  800342:	e8 9e ff ff ff       	call   8002e5 <printnum>
  800347:	83 c4 20             	add    $0x20,%esp
  80034a:	eb 13                	jmp    80035f <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	56                   	push   %esi
  800350:	ff 75 18             	pushl  0x18(%ebp)
  800353:	ff d7                	call   *%edi
  800355:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	85 db                	test   %ebx,%ebx
  80035d:	7f ed                	jg     80034c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	56                   	push   %esi
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	ff 75 e4             	pushl  -0x1c(%ebp)
  800369:	ff 75 e0             	pushl  -0x20(%ebp)
  80036c:	ff 75 dc             	pushl  -0x24(%ebp)
  80036f:	ff 75 d8             	pushl  -0x28(%ebp)
  800372:	e8 69 28 00 00       	call   802be0 <__umoddi3>
  800377:	83 c4 14             	add    $0x14,%esp
  80037a:	0f be 80 db 2d 80 00 	movsbl 0x802ddb(%eax),%eax
  800381:	50                   	push   %eax
  800382:	ff d7                	call   *%edi
}
  800384:	83 c4 10             	add    $0x10,%esp
  800387:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038a:	5b                   	pop    %ebx
  80038b:	5e                   	pop    %esi
  80038c:	5f                   	pop    %edi
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    
  80038f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800392:	eb c4                	jmp    800358 <printnum+0x73>

00800394 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039a:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80039e:	8b 10                	mov    (%eax),%edx
  8003a0:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a3:	73 0a                	jae    8003af <sprintputch+0x1b>
		*b->buf++ = ch;
  8003a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003a8:	89 08                	mov    %ecx,(%eax)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	88 02                	mov    %al,(%edx)
}
  8003af:	5d                   	pop    %ebp
  8003b0:	c3                   	ret    

008003b1 <printfmt>:
{
  8003b1:	55                   	push   %ebp
  8003b2:	89 e5                	mov    %esp,%ebp
  8003b4:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8003b7:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ba:	50                   	push   %eax
  8003bb:	ff 75 10             	pushl  0x10(%ebp)
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	ff 75 08             	pushl  0x8(%ebp)
  8003c4:	e8 05 00 00 00       	call   8003ce <vprintfmt>
}
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 2c             	sub    $0x2c,%esp
  8003d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8003da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003dd:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003e0:	e9 c1 03 00 00       	jmp    8007a6 <vprintfmt+0x3d8>
		padc = ' ';
  8003e5:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003e9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003f0:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003f7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003fe:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800403:	8d 47 01             	lea    0x1(%edi),%eax
  800406:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800409:	0f b6 17             	movzbl (%edi),%edx
  80040c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80040f:	3c 55                	cmp    $0x55,%al
  800411:	0f 87 12 04 00 00    	ja     800829 <vprintfmt+0x45b>
  800417:	0f b6 c0             	movzbl %al,%eax
  80041a:	ff 24 85 20 2f 80 00 	jmp    *0x802f20(,%eax,4)
  800421:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800424:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800428:	eb d9                	jmp    800403 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80042d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800431:	eb d0                	jmp    800403 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800433:	0f b6 d2             	movzbl %dl,%edx
  800436:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800439:	b8 00 00 00 00       	mov    $0x0,%eax
  80043e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800441:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800444:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800448:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80044b:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80044e:	83 f9 09             	cmp    $0x9,%ecx
  800451:	77 55                	ja     8004a8 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800453:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800456:	eb e9                	jmp    800441 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800458:	8b 45 14             	mov    0x14(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800460:	8b 45 14             	mov    0x14(%ebp),%eax
  800463:	8d 40 04             	lea    0x4(%eax),%eax
  800466:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800469:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80046c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800470:	79 91                	jns    800403 <vprintfmt+0x35>
				width = precision, precision = -1;
  800472:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800475:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800478:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80047f:	eb 82                	jmp    800403 <vprintfmt+0x35>
  800481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800484:	85 c0                	test   %eax,%eax
  800486:	ba 00 00 00 00       	mov    $0x0,%edx
  80048b:	0f 49 d0             	cmovns %eax,%edx
  80048e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800494:	e9 6a ff ff ff       	jmp    800403 <vprintfmt+0x35>
  800499:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80049c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8004a3:	e9 5b ff ff ff       	jmp    800403 <vprintfmt+0x35>
  8004a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8004ab:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004ae:	eb bc                	jmp    80046c <vprintfmt+0x9e>
			lflag++;
  8004b0:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004b6:	e9 48 ff ff ff       	jmp    800403 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8004bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004be:	8d 78 04             	lea    0x4(%eax),%edi
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	53                   	push   %ebx
  8004c5:	ff 30                	pushl  (%eax)
  8004c7:	ff d6                	call   *%esi
			break;
  8004c9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004cc:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004cf:	e9 cf 02 00 00       	jmp    8007a3 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 78 04             	lea    0x4(%eax),%edi
  8004da:	8b 00                	mov    (%eax),%eax
  8004dc:	99                   	cltd   
  8004dd:	31 d0                	xor    %edx,%eax
  8004df:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004e1:	83 f8 0f             	cmp    $0xf,%eax
  8004e4:	7f 23                	jg     800509 <vprintfmt+0x13b>
  8004e6:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  8004ed:	85 d2                	test   %edx,%edx
  8004ef:	74 18                	je     800509 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004f1:	52                   	push   %edx
  8004f2:	68 a1 32 80 00       	push   $0x8032a1
  8004f7:	53                   	push   %ebx
  8004f8:	56                   	push   %esi
  8004f9:	e8 b3 fe ff ff       	call   8003b1 <printfmt>
  8004fe:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800501:	89 7d 14             	mov    %edi,0x14(%ebp)
  800504:	e9 9a 02 00 00       	jmp    8007a3 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800509:	50                   	push   %eax
  80050a:	68 f3 2d 80 00       	push   $0x802df3
  80050f:	53                   	push   %ebx
  800510:	56                   	push   %esi
  800511:	e8 9b fe ff ff       	call   8003b1 <printfmt>
  800516:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800519:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80051c:	e9 82 02 00 00       	jmp    8007a3 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	83 c0 04             	add    $0x4,%eax
  800527:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80052a:	8b 45 14             	mov    0x14(%ebp),%eax
  80052d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80052f:	85 ff                	test   %edi,%edi
  800531:	b8 ec 2d 80 00       	mov    $0x802dec,%eax
  800536:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800539:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053d:	0f 8e bd 00 00 00    	jle    800600 <vprintfmt+0x232>
  800543:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800547:	75 0e                	jne    800557 <vprintfmt+0x189>
  800549:	89 75 08             	mov    %esi,0x8(%ebp)
  80054c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054f:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800552:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800555:	eb 6d                	jmp    8005c4 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	ff 75 d0             	pushl  -0x30(%ebp)
  80055d:	57                   	push   %edi
  80055e:	e8 6e 03 00 00       	call   8008d1 <strnlen>
  800563:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800566:	29 c1                	sub    %eax,%ecx
  800568:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80056b:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80056e:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800572:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800575:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800578:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80057a:	eb 0f                	jmp    80058b <vprintfmt+0x1bd>
					putch(padc, putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	ff 75 e0             	pushl  -0x20(%ebp)
  800583:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800585:	83 ef 01             	sub    $0x1,%edi
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	85 ff                	test   %edi,%edi
  80058d:	7f ed                	jg     80057c <vprintfmt+0x1ae>
  80058f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800592:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800595:	85 c9                	test   %ecx,%ecx
  800597:	b8 00 00 00 00       	mov    $0x0,%eax
  80059c:	0f 49 c1             	cmovns %ecx,%eax
  80059f:	29 c1                	sub    %eax,%ecx
  8005a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005aa:	89 cb                	mov    %ecx,%ebx
  8005ac:	eb 16                	jmp    8005c4 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8005ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b2:	75 31                	jne    8005e5 <vprintfmt+0x217>
					putch(ch, putdat);
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	50                   	push   %eax
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c1:	83 eb 01             	sub    $0x1,%ebx
  8005c4:	83 c7 01             	add    $0x1,%edi
  8005c7:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	74 59                	je     80062b <vprintfmt+0x25d>
  8005d2:	85 f6                	test   %esi,%esi
  8005d4:	78 d8                	js     8005ae <vprintfmt+0x1e0>
  8005d6:	83 ee 01             	sub    $0x1,%esi
  8005d9:	79 d3                	jns    8005ae <vprintfmt+0x1e0>
  8005db:	89 df                	mov    %ebx,%edi
  8005dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005e3:	eb 37                	jmp    80061c <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005e5:	0f be d2             	movsbl %dl,%edx
  8005e8:	83 ea 20             	sub    $0x20,%edx
  8005eb:	83 fa 5e             	cmp    $0x5e,%edx
  8005ee:	76 c4                	jbe    8005b4 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 0c             	pushl  0xc(%ebp)
  8005f6:	6a 3f                	push   $0x3f
  8005f8:	ff 55 08             	call   *0x8(%ebp)
  8005fb:	83 c4 10             	add    $0x10,%esp
  8005fe:	eb c1                	jmp    8005c1 <vprintfmt+0x1f3>
  800600:	89 75 08             	mov    %esi,0x8(%ebp)
  800603:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800606:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800609:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80060c:	eb b6                	jmp    8005c4 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	53                   	push   %ebx
  800612:	6a 20                	push   $0x20
  800614:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800616:	83 ef 01             	sub    $0x1,%edi
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	85 ff                	test   %edi,%edi
  80061e:	7f ee                	jg     80060e <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800620:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800623:	89 45 14             	mov    %eax,0x14(%ebp)
  800626:	e9 78 01 00 00       	jmp    8007a3 <vprintfmt+0x3d5>
  80062b:	89 df                	mov    %ebx,%edi
  80062d:	8b 75 08             	mov    0x8(%ebp),%esi
  800630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800633:	eb e7                	jmp    80061c <vprintfmt+0x24e>
	if (lflag >= 2)
  800635:	83 f9 01             	cmp    $0x1,%ecx
  800638:	7e 3f                	jle    800679 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80063a:	8b 45 14             	mov    0x14(%ebp),%eax
  80063d:	8b 50 04             	mov    0x4(%eax),%edx
  800640:	8b 00                	mov    (%eax),%eax
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 08             	lea    0x8(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800651:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800655:	79 5c                	jns    8006b3 <vprintfmt+0x2e5>
				putch('-', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 2d                	push   $0x2d
  80065d:	ff d6                	call   *%esi
				num = -(long long) num;
  80065f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800662:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800665:	f7 da                	neg    %edx
  800667:	83 d1 00             	adc    $0x0,%ecx
  80066a:	f7 d9                	neg    %ecx
  80066c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80066f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800674:	e9 10 01 00 00       	jmp    800789 <vprintfmt+0x3bb>
	else if (lflag)
  800679:	85 c9                	test   %ecx,%ecx
  80067b:	75 1b                	jne    800698 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800685:	89 c1                	mov    %eax,%ecx
  800687:	c1 f9 1f             	sar    $0x1f,%ecx
  80068a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
  800696:	eb b9                	jmp    800651 <vprintfmt+0x283>
		return va_arg(*ap, long);
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a0:	89 c1                	mov    %eax,%ecx
  8006a2:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 40 04             	lea    0x4(%eax),%eax
  8006ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b1:	eb 9e                	jmp    800651 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8006b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8006b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006be:	e9 c6 00 00 00       	jmp    800789 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006c3:	83 f9 01             	cmp    $0x1,%ecx
  8006c6:	7e 18                	jle    8006e0 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 10                	mov    (%eax),%edx
  8006cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8006d0:	8d 40 08             	lea    0x8(%eax),%eax
  8006d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006db:	e9 a9 00 00 00       	jmp    800789 <vprintfmt+0x3bb>
	else if (lflag)
  8006e0:	85 c9                	test   %ecx,%ecx
  8006e2:	75 1a                	jne    8006fe <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 10                	mov    (%eax),%edx
  8006e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006ee:	8d 40 04             	lea    0x4(%eax),%eax
  8006f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006f9:	e9 8b 00 00 00       	jmp    800789 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800701:	8b 10                	mov    (%eax),%edx
  800703:	b9 00 00 00 00       	mov    $0x0,%ecx
  800708:	8d 40 04             	lea    0x4(%eax),%eax
  80070b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800713:	eb 74                	jmp    800789 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800715:	83 f9 01             	cmp    $0x1,%ecx
  800718:	7e 15                	jle    80072f <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	8b 10                	mov    (%eax),%edx
  80071f:	8b 48 04             	mov    0x4(%eax),%ecx
  800722:	8d 40 08             	lea    0x8(%eax),%eax
  800725:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800728:	b8 08 00 00 00       	mov    $0x8,%eax
  80072d:	eb 5a                	jmp    800789 <vprintfmt+0x3bb>
	else if (lflag)
  80072f:	85 c9                	test   %ecx,%ecx
  800731:	75 17                	jne    80074a <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8b 10                	mov    (%eax),%edx
  800738:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800743:	b8 08 00 00 00       	mov    $0x8,%eax
  800748:	eb 3f                	jmp    800789 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80074a:	8b 45 14             	mov    0x14(%ebp),%eax
  80074d:	8b 10                	mov    (%eax),%edx
  80074f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800754:	8d 40 04             	lea    0x4(%eax),%eax
  800757:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80075a:	b8 08 00 00 00       	mov    $0x8,%eax
  80075f:	eb 28                	jmp    800789 <vprintfmt+0x3bb>
			putch('0', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 30                	push   $0x30
  800767:	ff d6                	call   *%esi
			putch('x', putdat);
  800769:	83 c4 08             	add    $0x8,%esp
  80076c:	53                   	push   %ebx
  80076d:	6a 78                	push   $0x78
  80076f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 10                	mov    (%eax),%edx
  800776:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80077b:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077e:	8d 40 04             	lea    0x4(%eax),%eax
  800781:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800784:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800789:	83 ec 0c             	sub    $0xc,%esp
  80078c:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800790:	57                   	push   %edi
  800791:	ff 75 e0             	pushl  -0x20(%ebp)
  800794:	50                   	push   %eax
  800795:	51                   	push   %ecx
  800796:	52                   	push   %edx
  800797:	89 da                	mov    %ebx,%edx
  800799:	89 f0                	mov    %esi,%eax
  80079b:	e8 45 fb ff ff       	call   8002e5 <printnum>
			break;
  8007a0:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007a6:	83 c7 01             	add    $0x1,%edi
  8007a9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007ad:	83 f8 25             	cmp    $0x25,%eax
  8007b0:	0f 84 2f fc ff ff    	je     8003e5 <vprintfmt+0x17>
			if (ch == '\0')
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	0f 84 8b 00 00 00    	je     800849 <vprintfmt+0x47b>
			putch(ch, putdat);
  8007be:	83 ec 08             	sub    $0x8,%esp
  8007c1:	53                   	push   %ebx
  8007c2:	50                   	push   %eax
  8007c3:	ff d6                	call   *%esi
  8007c5:	83 c4 10             	add    $0x10,%esp
  8007c8:	eb dc                	jmp    8007a6 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8007ca:	83 f9 01             	cmp    $0x1,%ecx
  8007cd:	7e 15                	jle    8007e4 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 10                	mov    (%eax),%edx
  8007d4:	8b 48 04             	mov    0x4(%eax),%ecx
  8007d7:	8d 40 08             	lea    0x8(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e2:	eb a5                	jmp    800789 <vprintfmt+0x3bb>
	else if (lflag)
  8007e4:	85 c9                	test   %ecx,%ecx
  8007e6:	75 17                	jne    8007ff <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8b 10                	mov    (%eax),%edx
  8007ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f2:	8d 40 04             	lea    0x4(%eax),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fd:	eb 8a                	jmp    800789 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 10                	mov    (%eax),%edx
  800804:	b9 00 00 00 00       	mov    $0x0,%ecx
  800809:	8d 40 04             	lea    0x4(%eax),%eax
  80080c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80080f:	b8 10 00 00 00       	mov    $0x10,%eax
  800814:	e9 70 ff ff ff       	jmp    800789 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800819:	83 ec 08             	sub    $0x8,%esp
  80081c:	53                   	push   %ebx
  80081d:	6a 25                	push   $0x25
  80081f:	ff d6                	call   *%esi
			break;
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	e9 7a ff ff ff       	jmp    8007a3 <vprintfmt+0x3d5>
			putch('%', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	53                   	push   %ebx
  80082d:	6a 25                	push   $0x25
  80082f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	89 f8                	mov    %edi,%eax
  800836:	eb 03                	jmp    80083b <vprintfmt+0x46d>
  800838:	83 e8 01             	sub    $0x1,%eax
  80083b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80083f:	75 f7                	jne    800838 <vprintfmt+0x46a>
  800841:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800844:	e9 5a ff ff ff       	jmp    8007a3 <vprintfmt+0x3d5>
}
  800849:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80084c:	5b                   	pop    %ebx
  80084d:	5e                   	pop    %esi
  80084e:	5f                   	pop    %edi
  80084f:	5d                   	pop    %ebp
  800850:	c3                   	ret    

00800851 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	83 ec 18             	sub    $0x18,%esp
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80085d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800860:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800864:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800867:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80086e:	85 c0                	test   %eax,%eax
  800870:	74 26                	je     800898 <vsnprintf+0x47>
  800872:	85 d2                	test   %edx,%edx
  800874:	7e 22                	jle    800898 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800876:	ff 75 14             	pushl  0x14(%ebp)
  800879:	ff 75 10             	pushl  0x10(%ebp)
  80087c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80087f:	50                   	push   %eax
  800880:	68 94 03 80 00       	push   $0x800394
  800885:	e8 44 fb ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80088a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	83 c4 10             	add    $0x10,%esp
}
  800896:	c9                   	leave  
  800897:	c3                   	ret    
		return -E_INVAL;
  800898:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80089d:	eb f7                	jmp    800896 <vsnprintf+0x45>

0080089f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008a5:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a8:	50                   	push   %eax
  8008a9:	ff 75 10             	pushl  0x10(%ebp)
  8008ac:	ff 75 0c             	pushl  0xc(%ebp)
  8008af:	ff 75 08             	pushl  0x8(%ebp)
  8008b2:	e8 9a ff ff ff       	call   800851 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c4:	eb 03                	jmp    8008c9 <strlen+0x10>
		n++;
  8008c6:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8008c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008cd:	75 f7                	jne    8008c6 <strlen+0xd>
	return n;
}
  8008cf:	5d                   	pop    %ebp
  8008d0:	c3                   	ret    

008008d1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	eb 03                	jmp    8008e4 <strnlen+0x13>
		n++;
  8008e1:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e4:	39 d0                	cmp    %edx,%eax
  8008e6:	74 06                	je     8008ee <strnlen+0x1d>
  8008e8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008ec:	75 f3                	jne    8008e1 <strnlen+0x10>
	return n;
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	53                   	push   %ebx
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008fa:	89 c2                	mov    %eax,%edx
  8008fc:	83 c1 01             	add    $0x1,%ecx
  8008ff:	83 c2 01             	add    $0x1,%edx
  800902:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800906:	88 5a ff             	mov    %bl,-0x1(%edx)
  800909:	84 db                	test   %bl,%bl
  80090b:	75 ef                	jne    8008fc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80090d:	5b                   	pop    %ebx
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800917:	53                   	push   %ebx
  800918:	e8 9c ff ff ff       	call   8008b9 <strlen>
  80091d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800920:	ff 75 0c             	pushl  0xc(%ebp)
  800923:	01 d8                	add    %ebx,%eax
  800925:	50                   	push   %eax
  800926:	e8 c5 ff ff ff       	call   8008f0 <strcpy>
	return dst;
}
  80092b:	89 d8                	mov    %ebx,%eax
  80092d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800930:	c9                   	leave  
  800931:	c3                   	ret    

00800932 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 75 08             	mov    0x8(%ebp),%esi
  80093a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093d:	89 f3                	mov    %esi,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800942:	89 f2                	mov    %esi,%edx
  800944:	eb 0f                	jmp    800955 <strncpy+0x23>
		*dst++ = *src;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094f:	80 39 01             	cmpb   $0x1,(%ecx)
  800952:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800955:	39 da                	cmp    %ebx,%edx
  800957:	75 ed                	jne    800946 <strncpy+0x14>
	}
	return ret;
}
  800959:	89 f0                	mov    %esi,%eax
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 75 08             	mov    0x8(%ebp),%esi
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 0b                	jne    800982 <strlcpy+0x23>
  800977:	eb 17                	jmp    800990 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800979:	83 c2 01             	add    $0x1,%edx
  80097c:	83 c0 01             	add    $0x1,%eax
  80097f:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800982:	39 d8                	cmp    %ebx,%eax
  800984:	74 07                	je     80098d <strlcpy+0x2e>
  800986:	0f b6 0a             	movzbl (%edx),%ecx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 ec                	jne    800979 <strlcpy+0x1a>
		*dst = '\0';
  80098d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800990:	29 f0                	sub    %esi,%eax
}
  800992:	5b                   	pop    %ebx
  800993:	5e                   	pop    %esi
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099f:	eb 06                	jmp    8009a7 <strcmp+0x11>
		p++, q++;
  8009a1:	83 c1 01             	add    $0x1,%ecx
  8009a4:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8009a7:	0f b6 01             	movzbl (%ecx),%eax
  8009aa:	84 c0                	test   %al,%al
  8009ac:	74 04                	je     8009b2 <strcmp+0x1c>
  8009ae:	3a 02                	cmp    (%edx),%al
  8009b0:	74 ef                	je     8009a1 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b2:	0f b6 c0             	movzbl %al,%eax
  8009b5:	0f b6 12             	movzbl (%edx),%edx
  8009b8:	29 d0                	sub    %edx,%eax
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c6:	89 c3                	mov    %eax,%ebx
  8009c8:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009cb:	eb 06                	jmp    8009d3 <strncmp+0x17>
		n--, p++, q++;
  8009cd:	83 c0 01             	add    $0x1,%eax
  8009d0:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009d3:	39 d8                	cmp    %ebx,%eax
  8009d5:	74 16                	je     8009ed <strncmp+0x31>
  8009d7:	0f b6 08             	movzbl (%eax),%ecx
  8009da:	84 c9                	test   %cl,%cl
  8009dc:	74 04                	je     8009e2 <strncmp+0x26>
  8009de:	3a 0a                	cmp    (%edx),%cl
  8009e0:	74 eb                	je     8009cd <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e2:	0f b6 00             	movzbl (%eax),%eax
  8009e5:	0f b6 12             	movzbl (%edx),%edx
  8009e8:	29 d0                	sub    %edx,%eax
}
  8009ea:	5b                   	pop    %ebx
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    
		return 0;
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f2:	eb f6                	jmp    8009ea <strncmp+0x2e>

008009f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009fe:	0f b6 10             	movzbl (%eax),%edx
  800a01:	84 d2                	test   %dl,%dl
  800a03:	74 09                	je     800a0e <strchr+0x1a>
		if (*s == c)
  800a05:	38 ca                	cmp    %cl,%dl
  800a07:	74 0a                	je     800a13 <strchr+0x1f>
	for (; *s; s++)
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	eb f0                	jmp    8009fe <strchr+0xa>
			return (char *) s;
	return 0;
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a13:	5d                   	pop    %ebp
  800a14:	c3                   	ret    

00800a15 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a15:	55                   	push   %ebp
  800a16:	89 e5                	mov    %esp,%ebp
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1f:	eb 03                	jmp    800a24 <strfind+0xf>
  800a21:	83 c0 01             	add    $0x1,%eax
  800a24:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	74 04                	je     800a2f <strfind+0x1a>
  800a2b:	84 d2                	test   %dl,%dl
  800a2d:	75 f2                	jne    800a21 <strfind+0xc>
			break;
	return (char *) s;
}
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	57                   	push   %edi
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a3d:	85 c9                	test   %ecx,%ecx
  800a3f:	74 13                	je     800a54 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a41:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a47:	75 05                	jne    800a4e <memset+0x1d>
  800a49:	f6 c1 03             	test   $0x3,%cl
  800a4c:	74 0d                	je     800a5b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	fc                   	cld    
  800a52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a54:	89 f8                	mov    %edi,%eax
  800a56:	5b                   	pop    %ebx
  800a57:	5e                   	pop    %esi
  800a58:	5f                   	pop    %edi
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    
		c &= 0xFF;
  800a5b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5f:	89 d3                	mov    %edx,%ebx
  800a61:	c1 e3 08             	shl    $0x8,%ebx
  800a64:	89 d0                	mov    %edx,%eax
  800a66:	c1 e0 18             	shl    $0x18,%eax
  800a69:	89 d6                	mov    %edx,%esi
  800a6b:	c1 e6 10             	shl    $0x10,%esi
  800a6e:	09 f0                	or     %esi,%eax
  800a70:	09 c2                	or     %eax,%edx
  800a72:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a74:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a77:	89 d0                	mov    %edx,%eax
  800a79:	fc                   	cld    
  800a7a:	f3 ab                	rep stos %eax,%es:(%edi)
  800a7c:	eb d6                	jmp    800a54 <memset+0x23>

00800a7e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a7e:	55                   	push   %ebp
  800a7f:	89 e5                	mov    %esp,%ebp
  800a81:	57                   	push   %edi
  800a82:	56                   	push   %esi
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a89:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a8c:	39 c6                	cmp    %eax,%esi
  800a8e:	73 35                	jae    800ac5 <memmove+0x47>
  800a90:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a93:	39 c2                	cmp    %eax,%edx
  800a95:	76 2e                	jbe    800ac5 <memmove+0x47>
		s += n;
		d += n;
  800a97:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9a:	89 d6                	mov    %edx,%esi
  800a9c:	09 fe                	or     %edi,%esi
  800a9e:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aa4:	74 0c                	je     800ab2 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aa6:	83 ef 01             	sub    $0x1,%edi
  800aa9:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aac:	fd                   	std    
  800aad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aaf:	fc                   	cld    
  800ab0:	eb 21                	jmp    800ad3 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab2:	f6 c1 03             	test   $0x3,%cl
  800ab5:	75 ef                	jne    800aa6 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab7:	83 ef 04             	sub    $0x4,%edi
  800aba:	8d 72 fc             	lea    -0x4(%edx),%esi
  800abd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ac0:	fd                   	std    
  800ac1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac3:	eb ea                	jmp    800aaf <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac5:	89 f2                	mov    %esi,%edx
  800ac7:	09 c2                	or     %eax,%edx
  800ac9:	f6 c2 03             	test   $0x3,%dl
  800acc:	74 09                	je     800ad7 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ace:	89 c7                	mov    %eax,%edi
  800ad0:	fc                   	cld    
  800ad1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad3:	5e                   	pop    %esi
  800ad4:	5f                   	pop    %edi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad7:	f6 c1 03             	test   $0x3,%cl
  800ada:	75 f2                	jne    800ace <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800adc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800adf:	89 c7                	mov    %eax,%edi
  800ae1:	fc                   	cld    
  800ae2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae4:	eb ed                	jmp    800ad3 <memmove+0x55>

00800ae6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ae9:	ff 75 10             	pushl  0x10(%ebp)
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 87 ff ff ff       	call   800a7e <memmove>
}
  800af7:	c9                   	leave  
  800af8:	c3                   	ret    

00800af9 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b04:	89 c6                	mov    %eax,%esi
  800b06:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b09:	39 f0                	cmp    %esi,%eax
  800b0b:	74 1c                	je     800b29 <memcmp+0x30>
		if (*s1 != *s2)
  800b0d:	0f b6 08             	movzbl (%eax),%ecx
  800b10:	0f b6 1a             	movzbl (%edx),%ebx
  800b13:	38 d9                	cmp    %bl,%cl
  800b15:	75 08                	jne    800b1f <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b17:	83 c0 01             	add    $0x1,%eax
  800b1a:	83 c2 01             	add    $0x1,%edx
  800b1d:	eb ea                	jmp    800b09 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b1f:	0f b6 c1             	movzbl %cl,%eax
  800b22:	0f b6 db             	movzbl %bl,%ebx
  800b25:	29 d8                	sub    %ebx,%eax
  800b27:	eb 05                	jmp    800b2e <memcmp+0x35>
	}

	return 0;
  800b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2e:	5b                   	pop    %ebx
  800b2f:	5e                   	pop    %esi
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b40:	39 d0                	cmp    %edx,%eax
  800b42:	73 09                	jae    800b4d <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b44:	38 08                	cmp    %cl,(%eax)
  800b46:	74 05                	je     800b4d <memfind+0x1b>
	for (; s < ends; s++)
  800b48:	83 c0 01             	add    $0x1,%eax
  800b4b:	eb f3                	jmp    800b40 <memfind+0xe>
			break;
	return (void *) s;
}
  800b4d:	5d                   	pop    %ebp
  800b4e:	c3                   	ret    

00800b4f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
  800b52:	57                   	push   %edi
  800b53:	56                   	push   %esi
  800b54:	53                   	push   %ebx
  800b55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5b:	eb 03                	jmp    800b60 <strtol+0x11>
		s++;
  800b5d:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b60:	0f b6 01             	movzbl (%ecx),%eax
  800b63:	3c 20                	cmp    $0x20,%al
  800b65:	74 f6                	je     800b5d <strtol+0xe>
  800b67:	3c 09                	cmp    $0x9,%al
  800b69:	74 f2                	je     800b5d <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b6b:	3c 2b                	cmp    $0x2b,%al
  800b6d:	74 2e                	je     800b9d <strtol+0x4e>
	int neg = 0;
  800b6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b74:	3c 2d                	cmp    $0x2d,%al
  800b76:	74 2f                	je     800ba7 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b78:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b7e:	75 05                	jne    800b85 <strtol+0x36>
  800b80:	80 39 30             	cmpb   $0x30,(%ecx)
  800b83:	74 2c                	je     800bb1 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b85:	85 db                	test   %ebx,%ebx
  800b87:	75 0a                	jne    800b93 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b89:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b8e:	80 39 30             	cmpb   $0x30,(%ecx)
  800b91:	74 28                	je     800bbb <strtol+0x6c>
		base = 10;
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
  800b98:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9b:	eb 50                	jmp    800bed <strtol+0x9e>
		s++;
  800b9d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba5:	eb d1                	jmp    800b78 <strtol+0x29>
		s++, neg = 1;
  800ba7:	83 c1 01             	add    $0x1,%ecx
  800baa:	bf 01 00 00 00       	mov    $0x1,%edi
  800baf:	eb c7                	jmp    800b78 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb5:	74 0e                	je     800bc5 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	75 d8                	jne    800b93 <strtol+0x44>
		s++, base = 8;
  800bbb:	83 c1 01             	add    $0x1,%ecx
  800bbe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc3:	eb ce                	jmp    800b93 <strtol+0x44>
		s += 2, base = 16;
  800bc5:	83 c1 02             	add    $0x2,%ecx
  800bc8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bcd:	eb c4                	jmp    800b93 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bcf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd2:	89 f3                	mov    %esi,%ebx
  800bd4:	80 fb 19             	cmp    $0x19,%bl
  800bd7:	77 29                	ja     800c02 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800bd9:	0f be d2             	movsbl %dl,%edx
  800bdc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bdf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be2:	7d 30                	jge    800c14 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800be4:	83 c1 01             	add    $0x1,%ecx
  800be7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800beb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bed:	0f b6 11             	movzbl (%ecx),%edx
  800bf0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf3:	89 f3                	mov    %esi,%ebx
  800bf5:	80 fb 09             	cmp    $0x9,%bl
  800bf8:	77 d5                	ja     800bcf <strtol+0x80>
			dig = *s - '0';
  800bfa:	0f be d2             	movsbl %dl,%edx
  800bfd:	83 ea 30             	sub    $0x30,%edx
  800c00:	eb dd                	jmp    800bdf <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800c02:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c05:	89 f3                	mov    %esi,%ebx
  800c07:	80 fb 19             	cmp    $0x19,%bl
  800c0a:	77 08                	ja     800c14 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800c0c:	0f be d2             	movsbl %dl,%edx
  800c0f:	83 ea 37             	sub    $0x37,%edx
  800c12:	eb cb                	jmp    800bdf <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c18:	74 05                	je     800c1f <strtol+0xd0>
		*endptr = (char *) s;
  800c1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c1f:	89 c2                	mov    %eax,%edx
  800c21:	f7 da                	neg    %edx
  800c23:	85 ff                	test   %edi,%edi
  800c25:	0f 45 c2             	cmovne %edx,%eax
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	89 c3                	mov    %eax,%ebx
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5b:	89 d1                	mov    %edx,%ecx
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	89 d7                	mov    %edx,%edi
  800c61:	89 d6                	mov    %edx,%esi
  800c63:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c80:	89 cb                	mov    %ecx,%ebx
  800c82:	89 cf                	mov    %ecx,%edi
  800c84:	89 ce                	mov    %ecx,%esi
  800c86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7f 08                	jg     800c94 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	6a 03                	push   $0x3
  800c9a:	68 df 30 80 00       	push   $0x8030df
  800c9f:	6a 23                	push   $0x23
  800ca1:	68 fc 30 80 00       	push   $0x8030fc
  800ca6:	e8 4b f5 ff ff       	call   8001f6 <_panic>

00800cab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbb:	89 d1                	mov    %edx,%ecx
  800cbd:	89 d3                	mov    %edx,%ebx
  800cbf:	89 d7                	mov    %edx,%edi
  800cc1:	89 d6                	mov    %edx,%esi
  800cc3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <sys_yield>:

void
sys_yield(void)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cda:	89 d1                	mov    %edx,%ecx
  800cdc:	89 d3                	mov    %edx,%ebx
  800cde:	89 d7                	mov    %edx,%edi
  800ce0:	89 d6                	mov    %edx,%esi
  800ce2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf2:	be 00 00 00 00       	mov    $0x0,%esi
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 04 00 00 00       	mov    $0x4,%eax
  800d02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d05:	89 f7                	mov    %esi,%edi
  800d07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	7f 08                	jg     800d15 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d15:	83 ec 0c             	sub    $0xc,%esp
  800d18:	50                   	push   %eax
  800d19:	6a 04                	push   $0x4
  800d1b:	68 df 30 80 00       	push   $0x8030df
  800d20:	6a 23                	push   $0x23
  800d22:	68 fc 30 80 00       	push   $0x8030fc
  800d27:	e8 ca f4 ff ff       	call   8001f6 <_panic>

00800d2c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
  800d32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d46:	8b 75 18             	mov    0x18(%ebp),%esi
  800d49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	7f 08                	jg     800d57 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	83 ec 0c             	sub    $0xc,%esp
  800d5a:	50                   	push   %eax
  800d5b:	6a 05                	push   $0x5
  800d5d:	68 df 30 80 00       	push   $0x8030df
  800d62:	6a 23                	push   $0x23
  800d64:	68 fc 30 80 00       	push   $0x8030fc
  800d69:	e8 88 f4 ff ff       	call   8001f6 <_panic>

00800d6e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	b8 06 00 00 00       	mov    $0x6,%eax
  800d87:	89 df                	mov    %ebx,%edi
  800d89:	89 de                	mov    %ebx,%esi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 06                	push   $0x6
  800d9f:	68 df 30 80 00       	push   $0x8030df
  800da4:	6a 23                	push   $0x23
  800da6:	68 fc 30 80 00       	push   $0x8030fc
  800dab:	e8 46 f4 ff ff       	call   8001f6 <_panic>

00800db0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
  800db6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc9:	89 df                	mov    %ebx,%edi
  800dcb:	89 de                	mov    %ebx,%esi
  800dcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	7f 08                	jg     800ddb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	83 ec 0c             	sub    $0xc,%esp
  800dde:	50                   	push   %eax
  800ddf:	6a 08                	push   $0x8
  800de1:	68 df 30 80 00       	push   $0x8030df
  800de6:	6a 23                	push   $0x23
  800de8:	68 fc 30 80 00       	push   $0x8030fc
  800ded:	e8 04 f4 ff ff       	call   8001f6 <_panic>

00800df2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e06:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0b:	89 df                	mov    %ebx,%edi
  800e0d:	89 de                	mov    %ebx,%esi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 09                	push   $0x9
  800e23:	68 df 30 80 00       	push   $0x8030df
  800e28:	6a 23                	push   $0x23
  800e2a:	68 fc 30 80 00       	push   $0x8030fc
  800e2f:	e8 c2 f3 ff ff       	call   8001f6 <_panic>

00800e34 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4d:	89 df                	mov    %ebx,%edi
  800e4f:	89 de                	mov    %ebx,%esi
  800e51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7f 08                	jg     800e5f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	50                   	push   %eax
  800e63:	6a 0a                	push   $0xa
  800e65:	68 df 30 80 00       	push   $0x8030df
  800e6a:	6a 23                	push   $0x23
  800e6c:	68 fc 30 80 00       	push   $0x8030fc
  800e71:	e8 80 f3 ff ff       	call   8001f6 <_panic>

00800e76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e87:	be 00 00 00 00       	mov    $0x0,%esi
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e92:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eaf:	89 cb                	mov    %ecx,%ebx
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	89 ce                	mov    %ecx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 0d                	push   $0xd
  800ec9:	68 df 30 80 00       	push   $0x8030df
  800ece:	6a 23                	push   $0x23
  800ed0:	68 fc 30 80 00       	push   $0x8030fc
  800ed5:	e8 1c f3 ff ff       	call   8001f6 <_panic>

00800eda <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee5:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eea:	89 d1                	mov    %edx,%ecx
  800eec:	89 d3                	mov    %edx,%ebx
  800eee:	89 d7                	mov    %edx,%edi
  800ef0:	89 d6                	mov    %edx,%esi
  800ef2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	56                   	push   %esi
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800f01:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f03:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f07:	74 7f                	je     800f88 <pgfault+0x8f>
  800f09:	89 d8                	mov    %ebx,%eax
  800f0b:	c1 e8 0c             	shr    $0xc,%eax
  800f0e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f15:	f6 c4 08             	test   $0x8,%ah
  800f18:	74 6e                	je     800f88 <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800f1a:	e8 8c fd ff ff       	call   800cab <sys_getenvid>
  800f1f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800f21:	83 ec 04             	sub    $0x4,%esp
  800f24:	6a 07                	push   $0x7
  800f26:	68 00 f0 7f 00       	push   $0x7ff000
  800f2b:	50                   	push   %eax
  800f2c:	e8 b8 fd ff ff       	call   800ce9 <sys_page_alloc>
  800f31:	83 c4 10             	add    $0x10,%esp
  800f34:	85 c0                	test   %eax,%eax
  800f36:	78 64                	js     800f9c <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800f38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800f3e:	83 ec 04             	sub    $0x4,%esp
  800f41:	68 00 10 00 00       	push   $0x1000
  800f46:	53                   	push   %ebx
  800f47:	68 00 f0 7f 00       	push   $0x7ff000
  800f4c:	e8 2d fb ff ff       	call   800a7e <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800f51:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f58:	53                   	push   %ebx
  800f59:	56                   	push   %esi
  800f5a:	68 00 f0 7f 00       	push   $0x7ff000
  800f5f:	56                   	push   %esi
  800f60:	e8 c7 fd ff ff       	call   800d2c <sys_page_map>
  800f65:	83 c4 20             	add    $0x20,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	78 42                	js     800fae <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	68 00 f0 7f 00       	push   $0x7ff000
  800f74:	56                   	push   %esi
  800f75:	e8 f4 fd ff ff       	call   800d6e <sys_page_unmap>
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	78 3f                	js     800fc0 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800f81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5d                   	pop    %ebp
  800f87:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800f88:	83 ec 04             	sub    $0x4,%esp
  800f8b:	68 0c 31 80 00       	push   $0x80310c
  800f90:	6a 1d                	push   $0x1d
  800f92:	68 9b 31 80 00       	push   $0x80319b
  800f97:	e8 5a f2 ff ff       	call   8001f6 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800f9c:	50                   	push   %eax
  800f9d:	68 34 31 80 00       	push   $0x803134
  800fa2:	6a 28                	push   $0x28
  800fa4:	68 9b 31 80 00       	push   $0x80319b
  800fa9:	e8 48 f2 ff ff       	call   8001f6 <_panic>
		panic("pgfault:page map failed: %e", r);
  800fae:	50                   	push   %eax
  800faf:	68 a6 31 80 00       	push   $0x8031a6
  800fb4:	6a 2c                	push   $0x2c
  800fb6:	68 9b 31 80 00       	push   $0x80319b
  800fbb:	e8 36 f2 ff ff       	call   8001f6 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800fc0:	50                   	push   %eax
  800fc1:	68 58 31 80 00       	push   $0x803158
  800fc6:	6a 2e                	push   $0x2e
  800fc8:	68 9b 31 80 00       	push   $0x80319b
  800fcd:	e8 24 f2 ff ff       	call   8001f6 <_panic>

00800fd2 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	57                   	push   %edi
  800fd6:	56                   	push   %esi
  800fd7:	53                   	push   %ebx
  800fd8:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800fdb:	68 f9 0e 80 00       	push   $0x800ef9
  800fe0:	e8 18 19 00 00       	call   8028fd <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fe5:	b8 07 00 00 00       	mov    $0x7,%eax
  800fea:	cd 30                	int    $0x30
  800fec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	85 c0                	test   %eax,%eax
  800ff4:	78 2f                	js     801025 <fork+0x53>
  800ff6:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800ff8:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800ffd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801001:	75 6e                	jne    801071 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  801003:	e8 a3 fc ff ff       	call   800cab <sys_getenvid>
  801008:	25 ff 03 00 00       	and    $0x3ff,%eax
  80100d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801010:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801015:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80101a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  80101d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  801025:	50                   	push   %eax
  801026:	68 78 31 80 00       	push   $0x803178
  80102b:	6a 6e                	push   $0x6e
  80102d:	68 9b 31 80 00       	push   $0x80319b
  801032:	e8 bf f1 ff ff       	call   8001f6 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  801037:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	25 07 0e 00 00       	and    $0xe07,%eax
  801046:	50                   	push   %eax
  801047:	56                   	push   %esi
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	6a 00                	push   $0x0
  80104c:	e8 db fc ff ff       	call   800d2c <sys_page_map>
  801051:	83 c4 20             	add    $0x20,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	ba 00 00 00 00       	mov    $0x0,%edx
  80105b:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  80105e:	85 c0                	test   %eax,%eax
  801060:	78 bb                	js     80101d <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801062:	83 c3 01             	add    $0x1,%ebx
  801065:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80106b:	0f 84 a6 00 00 00    	je     801117 <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801071:	89 d8                	mov    %ebx,%eax
  801073:	c1 e8 0a             	shr    $0xa,%eax
  801076:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107d:	a8 01                	test   $0x1,%al
  80107f:	74 e1                	je     801062 <fork+0x90>
  801081:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801088:	a8 01                	test   $0x1,%al
  80108a:	74 d6                	je     801062 <fork+0x90>
  80108c:	89 de                	mov    %ebx,%esi
  80108e:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  801091:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801098:	f6 c4 04             	test   $0x4,%ah
  80109b:	75 9a                	jne    801037 <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  80109d:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010a4:	a8 02                	test   $0x2,%al
  8010a6:	75 0c                	jne    8010b4 <fork+0xe2>
  8010a8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010af:	f6 c4 08             	test   $0x8,%ah
  8010b2:	74 42                	je     8010f6 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	68 05 08 00 00       	push   $0x805
  8010bc:	56                   	push   %esi
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	6a 00                	push   $0x0
  8010c1:	e8 66 fc ff ff       	call   800d2c <sys_page_map>
  8010c6:	83 c4 20             	add    $0x20,%esp
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	0f 88 4c ff ff ff    	js     80101d <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  8010d1:	83 ec 0c             	sub    $0xc,%esp
  8010d4:	68 05 08 00 00       	push   $0x805
  8010d9:	56                   	push   %esi
  8010da:	6a 00                	push   $0x0
  8010dc:	56                   	push   %esi
  8010dd:	6a 00                	push   $0x0
  8010df:	e8 48 fc ff ff       	call   800d2c <sys_page_map>
  8010e4:	83 c4 20             	add    $0x20,%esp
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ee:	0f 4f c1             	cmovg  %ecx,%eax
  8010f1:	e9 68 ff ff ff       	jmp    80105e <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  8010f6:	83 ec 0c             	sub    $0xc,%esp
  8010f9:	6a 05                	push   $0x5
  8010fb:	56                   	push   %esi
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	6a 00                	push   $0x0
  801100:	e8 27 fc ff ff       	call   800d2c <sys_page_map>
  801105:	83 c4 20             	add    $0x20,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110f:	0f 4f c1             	cmovg  %ecx,%eax
  801112:	e9 47 ff ff ff       	jmp    80105e <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	6a 07                	push   $0x7
  80111c:	68 00 f0 bf ee       	push   $0xeebff000
  801121:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801124:	57                   	push   %edi
  801125:	e8 bf fb ff ff       	call   800ce9 <sys_page_alloc>
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	85 c0                	test   %eax,%eax
  80112f:	0f 88 e8 fe ff ff    	js     80101d <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  801135:	83 ec 08             	sub    $0x8,%esp
  801138:	68 62 29 80 00       	push   $0x802962
  80113d:	57                   	push   %edi
  80113e:	e8 f1 fc ff ff       	call   800e34 <sys_env_set_pgfault_upcall>
  801143:	83 c4 10             	add    $0x10,%esp
  801146:	85 c0                	test   %eax,%eax
  801148:	0f 88 cf fe ff ff    	js     80101d <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  80114e:	83 ec 08             	sub    $0x8,%esp
  801151:	6a 02                	push   $0x2
  801153:	57                   	push   %edi
  801154:	e8 57 fc ff ff       	call   800db0 <sys_env_set_status>
  801159:	83 c4 10             	add    $0x10,%esp
  80115c:	85 c0                	test   %eax,%eax
  80115e:	78 08                	js     801168 <fork+0x196>
	return eid;
  801160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801163:	e9 b5 fe ff ff       	jmp    80101d <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  801168:	50                   	push   %eax
  801169:	68 c2 31 80 00       	push   $0x8031c2
  80116e:	68 87 00 00 00       	push   $0x87
  801173:	68 9b 31 80 00       	push   $0x80319b
  801178:	e8 79 f0 ff ff       	call   8001f6 <_panic>

0080117d <sfork>:

// Challenge!
int sfork(void)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801183:	68 e0 31 80 00       	push   $0x8031e0
  801188:	68 8f 00 00 00       	push   $0x8f
  80118d:	68 9b 31 80 00       	push   $0x80319b
  801192:	e8 5f f0 ff ff       	call   8001f6 <_panic>

00801197 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	05 00 00 00 30       	add    $0x30000000,%eax
  8011a2:	c1 e8 0c             	shr    $0xc,%eax
}
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011b7:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011bc:	5d                   	pop    %ebp
  8011bd:	c3                   	ret    

008011be <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c4:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	c1 ea 16             	shr    $0x16,%edx
  8011ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d5:	f6 c2 01             	test   $0x1,%dl
  8011d8:	74 2a                	je     801204 <fd_alloc+0x46>
  8011da:	89 c2                	mov    %eax,%edx
  8011dc:	c1 ea 0c             	shr    $0xc,%edx
  8011df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e6:	f6 c2 01             	test   $0x1,%dl
  8011e9:	74 19                	je     801204 <fd_alloc+0x46>
  8011eb:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011f0:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011f5:	75 d2                	jne    8011c9 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011f7:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011fd:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801202:	eb 07                	jmp    80120b <fd_alloc+0x4d>
			*fd_store = fd;
  801204:	89 01                	mov    %eax,(%ecx)
			return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	5d                   	pop    %ebp
  80120c:	c3                   	ret    

0080120d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801213:	83 f8 1f             	cmp    $0x1f,%eax
  801216:	77 36                	ja     80124e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801218:	c1 e0 0c             	shl    $0xc,%eax
  80121b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801220:	89 c2                	mov    %eax,%edx
  801222:	c1 ea 16             	shr    $0x16,%edx
  801225:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80122c:	f6 c2 01             	test   $0x1,%dl
  80122f:	74 24                	je     801255 <fd_lookup+0x48>
  801231:	89 c2                	mov    %eax,%edx
  801233:	c1 ea 0c             	shr    $0xc,%edx
  801236:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80123d:	f6 c2 01             	test   $0x1,%dl
  801240:	74 1a                	je     80125c <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801242:	8b 55 0c             	mov    0xc(%ebp),%edx
  801245:	89 02                	mov    %eax,(%edx)
	return 0;
  801247:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    
		return -E_INVAL;
  80124e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801253:	eb f7                	jmp    80124c <fd_lookup+0x3f>
		return -E_INVAL;
  801255:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80125a:	eb f0                	jmp    80124c <fd_lookup+0x3f>
  80125c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801261:	eb e9                	jmp    80124c <fd_lookup+0x3f>

00801263 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 08             	sub    $0x8,%esp
  801269:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80126c:	ba 74 32 80 00       	mov    $0x803274,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801271:	b8 0c 40 80 00       	mov    $0x80400c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801276:	39 08                	cmp    %ecx,(%eax)
  801278:	74 33                	je     8012ad <dev_lookup+0x4a>
  80127a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80127d:	8b 02                	mov    (%edx),%eax
  80127f:	85 c0                	test   %eax,%eax
  801281:	75 f3                	jne    801276 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801283:	a1 08 50 80 00       	mov    0x805008,%eax
  801288:	8b 40 48             	mov    0x48(%eax),%eax
  80128b:	83 ec 04             	sub    $0x4,%esp
  80128e:	51                   	push   %ecx
  80128f:	50                   	push   %eax
  801290:	68 f8 31 80 00       	push   $0x8031f8
  801295:	e8 37 f0 ff ff       	call   8002d1 <cprintf>
	*dev = 0;
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012a3:	83 c4 10             	add    $0x10,%esp
  8012a6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    
			*dev = devtab[i];
  8012ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b7:	eb f2                	jmp    8012ab <dev_lookup+0x48>

008012b9 <fd_close>:
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	57                   	push   %edi
  8012bd:	56                   	push   %esi
  8012be:	53                   	push   %ebx
  8012bf:	83 ec 1c             	sub    $0x1c,%esp
  8012c2:	8b 75 08             	mov    0x8(%ebp),%esi
  8012c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012cb:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012cc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012d2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012d5:	50                   	push   %eax
  8012d6:	e8 32 ff ff ff       	call   80120d <fd_lookup>
  8012db:	89 c3                	mov    %eax,%ebx
  8012dd:	83 c4 08             	add    $0x8,%esp
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	78 05                	js     8012e9 <fd_close+0x30>
	    || fd != fd2)
  8012e4:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8012e7:	74 16                	je     8012ff <fd_close+0x46>
		return (must_exist ? r : 0);
  8012e9:	89 f8                	mov    %edi,%eax
  8012eb:	84 c0                	test   %al,%al
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f2:	0f 44 d8             	cmove  %eax,%ebx
}
  8012f5:	89 d8                	mov    %ebx,%eax
  8012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012fa:	5b                   	pop    %ebx
  8012fb:	5e                   	pop    %esi
  8012fc:	5f                   	pop    %edi
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012ff:	83 ec 08             	sub    $0x8,%esp
  801302:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801305:	50                   	push   %eax
  801306:	ff 36                	pushl  (%esi)
  801308:	e8 56 ff ff ff       	call   801263 <dev_lookup>
  80130d:	89 c3                	mov    %eax,%ebx
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	78 15                	js     80132b <fd_close+0x72>
		if (dev->dev_close)
  801316:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801319:	8b 40 10             	mov    0x10(%eax),%eax
  80131c:	85 c0                	test   %eax,%eax
  80131e:	74 1b                	je     80133b <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	56                   	push   %esi
  801324:	ff d0                	call   *%eax
  801326:	89 c3                	mov    %eax,%ebx
  801328:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80132b:	83 ec 08             	sub    $0x8,%esp
  80132e:	56                   	push   %esi
  80132f:	6a 00                	push   $0x0
  801331:	e8 38 fa ff ff       	call   800d6e <sys_page_unmap>
	return r;
  801336:	83 c4 10             	add    $0x10,%esp
  801339:	eb ba                	jmp    8012f5 <fd_close+0x3c>
			r = 0;
  80133b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801340:	eb e9                	jmp    80132b <fd_close+0x72>

00801342 <close>:

int
close(int fdnum)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801348:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134b:	50                   	push   %eax
  80134c:	ff 75 08             	pushl  0x8(%ebp)
  80134f:	e8 b9 fe ff ff       	call   80120d <fd_lookup>
  801354:	83 c4 08             	add    $0x8,%esp
  801357:	85 c0                	test   %eax,%eax
  801359:	78 10                	js     80136b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80135b:	83 ec 08             	sub    $0x8,%esp
  80135e:	6a 01                	push   $0x1
  801360:	ff 75 f4             	pushl  -0xc(%ebp)
  801363:	e8 51 ff ff ff       	call   8012b9 <fd_close>
  801368:	83 c4 10             	add    $0x10,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <close_all>:

void
close_all(void)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	53                   	push   %ebx
  801371:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801374:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801379:	83 ec 0c             	sub    $0xc,%esp
  80137c:	53                   	push   %ebx
  80137d:	e8 c0 ff ff ff       	call   801342 <close>
	for (i = 0; i < MAXFD; i++)
  801382:	83 c3 01             	add    $0x1,%ebx
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	83 fb 20             	cmp    $0x20,%ebx
  80138b:	75 ec                	jne    801379 <close_all+0xc>
}
  80138d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801390:	c9                   	leave  
  801391:	c3                   	ret    

00801392 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801392:	55                   	push   %ebp
  801393:	89 e5                	mov    %esp,%ebp
  801395:	57                   	push   %edi
  801396:	56                   	push   %esi
  801397:	53                   	push   %ebx
  801398:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80139b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80139e:	50                   	push   %eax
  80139f:	ff 75 08             	pushl  0x8(%ebp)
  8013a2:	e8 66 fe ff ff       	call   80120d <fd_lookup>
  8013a7:	89 c3                	mov    %eax,%ebx
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	0f 88 81 00 00 00    	js     801435 <dup+0xa3>
		return r;
	close(newfdnum);
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ba:	e8 83 ff ff ff       	call   801342 <close>

	newfd = INDEX2FD(newfdnum);
  8013bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013c2:	c1 e6 0c             	shl    $0xc,%esi
  8013c5:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013cb:	83 c4 04             	add    $0x4,%esp
  8013ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013d1:	e8 d1 fd ff ff       	call   8011a7 <fd2data>
  8013d6:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013d8:	89 34 24             	mov    %esi,(%esp)
  8013db:	e8 c7 fd ff ff       	call   8011a7 <fd2data>
  8013e0:	83 c4 10             	add    $0x10,%esp
  8013e3:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013e5:	89 d8                	mov    %ebx,%eax
  8013e7:	c1 e8 16             	shr    $0x16,%eax
  8013ea:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013f1:	a8 01                	test   $0x1,%al
  8013f3:	74 11                	je     801406 <dup+0x74>
  8013f5:	89 d8                	mov    %ebx,%eax
  8013f7:	c1 e8 0c             	shr    $0xc,%eax
  8013fa:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801401:	f6 c2 01             	test   $0x1,%dl
  801404:	75 39                	jne    80143f <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801406:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801409:	89 d0                	mov    %edx,%eax
  80140b:	c1 e8 0c             	shr    $0xc,%eax
  80140e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801415:	83 ec 0c             	sub    $0xc,%esp
  801418:	25 07 0e 00 00       	and    $0xe07,%eax
  80141d:	50                   	push   %eax
  80141e:	56                   	push   %esi
  80141f:	6a 00                	push   $0x0
  801421:	52                   	push   %edx
  801422:	6a 00                	push   $0x0
  801424:	e8 03 f9 ff ff       	call   800d2c <sys_page_map>
  801429:	89 c3                	mov    %eax,%ebx
  80142b:	83 c4 20             	add    $0x20,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 31                	js     801463 <dup+0xd1>
		goto err;

	return newfdnum;
  801432:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801435:	89 d8                	mov    %ebx,%eax
  801437:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5f                   	pop    %edi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80143f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	25 07 0e 00 00       	and    $0xe07,%eax
  80144e:	50                   	push   %eax
  80144f:	57                   	push   %edi
  801450:	6a 00                	push   $0x0
  801452:	53                   	push   %ebx
  801453:	6a 00                	push   $0x0
  801455:	e8 d2 f8 ff ff       	call   800d2c <sys_page_map>
  80145a:	89 c3                	mov    %eax,%ebx
  80145c:	83 c4 20             	add    $0x20,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	79 a3                	jns    801406 <dup+0x74>
	sys_page_unmap(0, newfd);
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	56                   	push   %esi
  801467:	6a 00                	push   $0x0
  801469:	e8 00 f9 ff ff       	call   800d6e <sys_page_unmap>
	sys_page_unmap(0, nva);
  80146e:	83 c4 08             	add    $0x8,%esp
  801471:	57                   	push   %edi
  801472:	6a 00                	push   $0x0
  801474:	e8 f5 f8 ff ff       	call   800d6e <sys_page_unmap>
	return r;
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	eb b7                	jmp    801435 <dup+0xa3>

0080147e <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	53                   	push   %ebx
  801482:	83 ec 14             	sub    $0x14,%esp
  801485:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801488:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148b:	50                   	push   %eax
  80148c:	53                   	push   %ebx
  80148d:	e8 7b fd ff ff       	call   80120d <fd_lookup>
  801492:	83 c4 08             	add    $0x8,%esp
  801495:	85 c0                	test   %eax,%eax
  801497:	78 3f                	js     8014d8 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801499:	83 ec 08             	sub    $0x8,%esp
  80149c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149f:	50                   	push   %eax
  8014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a3:	ff 30                	pushl  (%eax)
  8014a5:	e8 b9 fd ff ff       	call   801263 <dev_lookup>
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 27                	js     8014d8 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014b4:	8b 42 08             	mov    0x8(%edx),%eax
  8014b7:	83 e0 03             	and    $0x3,%eax
  8014ba:	83 f8 01             	cmp    $0x1,%eax
  8014bd:	74 1e                	je     8014dd <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c2:	8b 40 08             	mov    0x8(%eax),%eax
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	74 35                	je     8014fe <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	ff 75 10             	pushl  0x10(%ebp)
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	52                   	push   %edx
  8014d3:	ff d0                	call   *%eax
  8014d5:	83 c4 10             	add    $0x10,%esp
}
  8014d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014dd:	a1 08 50 80 00       	mov    0x805008,%eax
  8014e2:	8b 40 48             	mov    0x48(%eax),%eax
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	50                   	push   %eax
  8014ea:	68 39 32 80 00       	push   $0x803239
  8014ef:	e8 dd ed ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fc:	eb da                	jmp    8014d8 <read+0x5a>
		return -E_NOT_SUPP;
  8014fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801503:	eb d3                	jmp    8014d8 <read+0x5a>

00801505 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	57                   	push   %edi
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801511:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801514:	bb 00 00 00 00       	mov    $0x0,%ebx
  801519:	39 f3                	cmp    %esi,%ebx
  80151b:	73 25                	jae    801542 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	89 f0                	mov    %esi,%eax
  801522:	29 d8                	sub    %ebx,%eax
  801524:	50                   	push   %eax
  801525:	89 d8                	mov    %ebx,%eax
  801527:	03 45 0c             	add    0xc(%ebp),%eax
  80152a:	50                   	push   %eax
  80152b:	57                   	push   %edi
  80152c:	e8 4d ff ff ff       	call   80147e <read>
		if (m < 0)
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 08                	js     801540 <readn+0x3b>
			return m;
		if (m == 0)
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 06                	je     801542 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80153c:	01 c3                	add    %eax,%ebx
  80153e:	eb d9                	jmp    801519 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801540:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801542:	89 d8                	mov    %ebx,%eax
  801544:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801547:	5b                   	pop    %ebx
  801548:	5e                   	pop    %esi
  801549:	5f                   	pop    %edi
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	53                   	push   %ebx
  801550:	83 ec 14             	sub    $0x14,%esp
  801553:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801556:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801559:	50                   	push   %eax
  80155a:	53                   	push   %ebx
  80155b:	e8 ad fc ff ff       	call   80120d <fd_lookup>
  801560:	83 c4 08             	add    $0x8,%esp
  801563:	85 c0                	test   %eax,%eax
  801565:	78 3a                	js     8015a1 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801567:	83 ec 08             	sub    $0x8,%esp
  80156a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80156d:	50                   	push   %eax
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	ff 30                	pushl  (%eax)
  801573:	e8 eb fc ff ff       	call   801263 <dev_lookup>
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 22                	js     8015a1 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801586:	74 1e                	je     8015a6 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158b:	8b 52 0c             	mov    0xc(%edx),%edx
  80158e:	85 d2                	test   %edx,%edx
  801590:	74 35                	je     8015c7 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801592:	83 ec 04             	sub    $0x4,%esp
  801595:	ff 75 10             	pushl  0x10(%ebp)
  801598:	ff 75 0c             	pushl  0xc(%ebp)
  80159b:	50                   	push   %eax
  80159c:	ff d2                	call   *%edx
  80159e:	83 c4 10             	add    $0x10,%esp
}
  8015a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015a6:	a1 08 50 80 00       	mov    0x805008,%eax
  8015ab:	8b 40 48             	mov    0x48(%eax),%eax
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	53                   	push   %ebx
  8015b2:	50                   	push   %eax
  8015b3:	68 55 32 80 00       	push   $0x803255
  8015b8:	e8 14 ed ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  8015bd:	83 c4 10             	add    $0x10,%esp
  8015c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c5:	eb da                	jmp    8015a1 <write+0x55>
		return -E_NOT_SUPP;
  8015c7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015cc:	eb d3                	jmp    8015a1 <write+0x55>

008015ce <seek>:

int
seek(int fdnum, off_t offset)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015d4:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015d7:	50                   	push   %eax
  8015d8:	ff 75 08             	pushl  0x8(%ebp)
  8015db:	e8 2d fc ff ff       	call   80120d <fd_lookup>
  8015e0:	83 c4 08             	add    $0x8,%esp
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 0e                	js     8015f5 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ed:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 14             	sub    $0x14,%esp
  8015fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801601:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801604:	50                   	push   %eax
  801605:	53                   	push   %ebx
  801606:	e8 02 fc ff ff       	call   80120d <fd_lookup>
  80160b:	83 c4 08             	add    $0x8,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	78 37                	js     801649 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801612:	83 ec 08             	sub    $0x8,%esp
  801615:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801618:	50                   	push   %eax
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	ff 30                	pushl  (%eax)
  80161e:	e8 40 fc ff ff       	call   801263 <dev_lookup>
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	85 c0                	test   %eax,%eax
  801628:	78 1f                	js     801649 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80162a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801631:	74 1b                	je     80164e <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801636:	8b 52 18             	mov    0x18(%edx),%edx
  801639:	85 d2                	test   %edx,%edx
  80163b:	74 32                	je     80166f <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	ff 75 0c             	pushl  0xc(%ebp)
  801643:	50                   	push   %eax
  801644:	ff d2                	call   *%edx
  801646:	83 c4 10             	add    $0x10,%esp
}
  801649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    
			thisenv->env_id, fdnum);
  80164e:	a1 08 50 80 00       	mov    0x805008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801653:	8b 40 48             	mov    0x48(%eax),%eax
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	53                   	push   %ebx
  80165a:	50                   	push   %eax
  80165b:	68 18 32 80 00       	push   $0x803218
  801660:	e8 6c ec ff ff       	call   8002d1 <cprintf>
		return -E_INVAL;
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166d:	eb da                	jmp    801649 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80166f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801674:	eb d3                	jmp    801649 <ftruncate+0x52>

00801676 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 14             	sub    $0x14,%esp
  80167d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801680:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801683:	50                   	push   %eax
  801684:	ff 75 08             	pushl  0x8(%ebp)
  801687:	e8 81 fb ff ff       	call   80120d <fd_lookup>
  80168c:	83 c4 08             	add    $0x8,%esp
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 4b                	js     8016de <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801693:	83 ec 08             	sub    $0x8,%esp
  801696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169d:	ff 30                	pushl  (%eax)
  80169f:	e8 bf fb ff ff       	call   801263 <dev_lookup>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	78 33                	js     8016de <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ae:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016b2:	74 2f                	je     8016e3 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016b4:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016b7:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016be:	00 00 00 
	stat->st_isdir = 0;
  8016c1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016c8:	00 00 00 
	stat->st_dev = dev;
  8016cb:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	53                   	push   %ebx
  8016d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d8:	ff 50 14             	call   *0x14(%eax)
  8016db:	83 c4 10             	add    $0x10,%esp
}
  8016de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    
		return -E_NOT_SUPP;
  8016e3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e8:	eb f4                	jmp    8016de <fstat+0x68>

008016ea <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 08             	pushl  0x8(%ebp)
  8016f7:	e8 e7 01 00 00       	call   8018e3 <open>
  8016fc:	89 c3                	mov    %eax,%ebx
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 1b                	js     801720 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801705:	83 ec 08             	sub    $0x8,%esp
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	50                   	push   %eax
  80170c:	e8 65 ff ff ff       	call   801676 <fstat>
  801711:	89 c6                	mov    %eax,%esi
	close(fd);
  801713:	89 1c 24             	mov    %ebx,(%esp)
  801716:	e8 27 fc ff ff       	call   801342 <close>
	return r;
  80171b:	83 c4 10             	add    $0x10,%esp
  80171e:	89 f3                	mov    %esi,%ebx
}
  801720:	89 d8                	mov    %ebx,%eax
  801722:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801725:	5b                   	pop    %ebx
  801726:	5e                   	pop    %esi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	89 c6                	mov    %eax,%esi
  801730:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801732:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801739:	74 27                	je     801762 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80173b:	6a 07                	push   $0x7
  80173d:	68 00 60 80 00       	push   $0x806000
  801742:	56                   	push   %esi
  801743:	ff 35 00 50 80 00    	pushl  0x805000
  801749:	e8 a1 12 00 00       	call   8029ef <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80174e:	83 c4 0c             	add    $0xc,%esp
  801751:	6a 00                	push   $0x0
  801753:	53                   	push   %ebx
  801754:	6a 00                	push   $0x0
  801756:	e8 2d 12 00 00       	call   802988 <ipc_recv>
}
  80175b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175e:	5b                   	pop    %ebx
  80175f:	5e                   	pop    %esi
  801760:	5d                   	pop    %ebp
  801761:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801762:	83 ec 0c             	sub    $0xc,%esp
  801765:	6a 01                	push   $0x1
  801767:	e8 d7 12 00 00       	call   802a43 <ipc_find_env>
  80176c:	a3 00 50 80 00       	mov    %eax,0x805000
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	eb c5                	jmp    80173b <fsipc+0x12>

00801776 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	8b 40 0c             	mov    0xc(%eax),%eax
  801782:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178a:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80178f:	ba 00 00 00 00       	mov    $0x0,%edx
  801794:	b8 02 00 00 00       	mov    $0x2,%eax
  801799:	e8 8b ff ff ff       	call   801729 <fsipc>
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <devfile_flush>:
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ac:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8017bb:	e8 69 ff ff ff       	call   801729 <fsipc>
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <devfile_stat>:
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	53                   	push   %ebx
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d2:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8017e1:	e8 43 ff ff ff       	call   801729 <fsipc>
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	78 2c                	js     801816 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	68 00 60 80 00       	push   $0x806000
  8017f2:	53                   	push   %ebx
  8017f3:	e8 f8 f0 ff ff       	call   8008f0 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017f8:	a1 80 60 80 00       	mov    0x806080,%eax
  8017fd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801803:	a1 84 60 80 00       	mov    0x806084,%eax
  801808:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <devfile_write>:
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 0c             	sub    $0xc,%esp
  801821:	8b 45 10             	mov    0x10(%ebp),%eax
  801824:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801829:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80182e:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801831:	8b 55 08             	mov    0x8(%ebp),%edx
  801834:	8b 52 0c             	mov    0xc(%edx),%edx
  801837:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = n;
  80183d:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801842:	50                   	push   %eax
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	68 08 60 80 00       	push   $0x806008
  80184b:	e8 2e f2 ff ff       	call   800a7e <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801850:	ba 00 00 00 00       	mov    $0x0,%edx
  801855:	b8 04 00 00 00       	mov    $0x4,%eax
  80185a:	e8 ca fe ff ff       	call   801729 <fsipc>
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <devfile_read>:
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
  801866:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8b 40 0c             	mov    0xc(%eax),%eax
  80186f:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801874:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80187a:	ba 00 00 00 00       	mov    $0x0,%edx
  80187f:	b8 03 00 00 00       	mov    $0x3,%eax
  801884:	e8 a0 fe ff ff       	call   801729 <fsipc>
  801889:	89 c3                	mov    %eax,%ebx
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 1f                	js     8018ae <devfile_read+0x4d>
	assert(r <= n);
  80188f:	39 f0                	cmp    %esi,%eax
  801891:	77 24                	ja     8018b7 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801893:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801898:	7f 33                	jg     8018cd <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	50                   	push   %eax
  80189e:	68 00 60 80 00       	push   $0x806000
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	e8 d3 f1 ff ff       	call   800a7e <memmove>
	return r;
  8018ab:	83 c4 10             	add    $0x10,%esp
}
  8018ae:	89 d8                	mov    %ebx,%eax
  8018b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    
	assert(r <= n);
  8018b7:	68 88 32 80 00       	push   $0x803288
  8018bc:	68 8f 32 80 00       	push   $0x80328f
  8018c1:	6a 7b                	push   $0x7b
  8018c3:	68 a4 32 80 00       	push   $0x8032a4
  8018c8:	e8 29 e9 ff ff       	call   8001f6 <_panic>
	assert(r <= PGSIZE);
  8018cd:	68 af 32 80 00       	push   $0x8032af
  8018d2:	68 8f 32 80 00       	push   $0x80328f
  8018d7:	6a 7c                	push   $0x7c
  8018d9:	68 a4 32 80 00       	push   $0x8032a4
  8018de:	e8 13 e9 ff ff       	call   8001f6 <_panic>

008018e3 <open>:
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 1c             	sub    $0x1c,%esp
  8018eb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8018ee:	56                   	push   %esi
  8018ef:	e8 c5 ef ff ff       	call   8008b9 <strlen>
  8018f4:	83 c4 10             	add    $0x10,%esp
  8018f7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018fc:	7f 6c                	jg     80196a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8018fe:	83 ec 0c             	sub    $0xc,%esp
  801901:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801904:	50                   	push   %eax
  801905:	e8 b4 f8 ff ff       	call   8011be <fd_alloc>
  80190a:	89 c3                	mov    %eax,%ebx
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 3c                	js     80194f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801913:	83 ec 08             	sub    $0x8,%esp
  801916:	56                   	push   %esi
  801917:	68 00 60 80 00       	push   $0x806000
  80191c:	e8 cf ef ff ff       	call   8008f0 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801921:	8b 45 0c             	mov    0xc(%ebp),%eax
  801924:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	b8 01 00 00 00       	mov    $0x1,%eax
  801931:	e8 f3 fd ff ff       	call   801729 <fsipc>
  801936:	89 c3                	mov    %eax,%ebx
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 19                	js     801958 <open+0x75>
	return fd2num(fd);
  80193f:	83 ec 0c             	sub    $0xc,%esp
  801942:	ff 75 f4             	pushl  -0xc(%ebp)
  801945:	e8 4d f8 ff ff       	call   801197 <fd2num>
  80194a:	89 c3                	mov    %eax,%ebx
  80194c:	83 c4 10             	add    $0x10,%esp
}
  80194f:	89 d8                	mov    %ebx,%eax
  801951:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    
		fd_close(fd, 0);
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	6a 00                	push   $0x0
  80195d:	ff 75 f4             	pushl  -0xc(%ebp)
  801960:	e8 54 f9 ff ff       	call   8012b9 <fd_close>
		return r;
  801965:	83 c4 10             	add    $0x10,%esp
  801968:	eb e5                	jmp    80194f <open+0x6c>
		return -E_BAD_PATH;
  80196a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80196f:	eb de                	jmp    80194f <open+0x6c>

00801971 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801977:	ba 00 00 00 00       	mov    $0x0,%edx
  80197c:	b8 08 00 00 00       	mov    $0x8,%eax
  801981:	e8 a3 fd ff ff       	call   801729 <fsipc>
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <spawn>:
// prog: the pathname of the program to run.
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int spawn(const char *prog, const char **argv)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	57                   	push   %edi
  80198c:	56                   	push   %esi
  80198d:	53                   	push   %ebx
  80198e:	81 ec 94 02 00 00    	sub    $0x294,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801994:	6a 00                	push   $0x0
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	e8 45 ff ff ff       	call   8018e3 <open>
  80199e:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	0f 88 40 03 00 00    	js     801cef <spawn+0x367>
  8019af:	89 c1                	mov    %eax,%ecx
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf *)elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf) || elf->e_magic != ELF_MAGIC)
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	68 00 02 00 00       	push   $0x200
  8019b9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019bf:	50                   	push   %eax
  8019c0:	51                   	push   %ecx
  8019c1:	e8 3f fb ff ff       	call   801505 <readn>
  8019c6:	83 c4 10             	add    $0x10,%esp
  8019c9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8019ce:	75 5d                	jne    801a2d <spawn+0xa5>
  8019d0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8019d7:	45 4c 46 
  8019da:	75 51                	jne    801a2d <spawn+0xa5>
  8019dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8019e1:	cd 30                	int    $0x30
  8019e3:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  8019e9:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	0f 88 62 04 00 00    	js     801e59 <spawn+0x4d1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8019f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019fc:	6b f0 7c             	imul   $0x7c,%eax,%esi
  8019ff:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a05:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a0b:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a10:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a12:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a18:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a1e:	bb 00 00 00 00       	mov    $0x0,%ebx
	string_size = 0;
  801a23:	be 00 00 00 00       	mov    $0x0,%esi
  801a28:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a2b:	eb 4b                	jmp    801a78 <spawn+0xf0>
		close(fd);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801a36:	e8 07 f9 ff ff       	call   801342 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a3b:	83 c4 0c             	add    $0xc,%esp
  801a3e:	68 7f 45 4c 46       	push   $0x464c457f
  801a43:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801a49:	68 bb 32 80 00       	push   $0x8032bb
  801a4e:	e8 7e e8 ff ff       	call   8002d1 <cprintf>
		return -E_NOT_EXEC;
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	c7 85 90 fd ff ff f2 	movl   $0xfffffff2,-0x270(%ebp)
  801a5d:	ff ff ff 
  801a60:	e9 8a 02 00 00       	jmp    801cef <spawn+0x367>
		string_size += strlen(argv[argc]) + 1;
  801a65:	83 ec 0c             	sub    $0xc,%esp
  801a68:	50                   	push   %eax
  801a69:	e8 4b ee ff ff       	call   8008b9 <strlen>
  801a6e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	for (argc = 0; argv[argc] != 0; argc++)
  801a72:	83 c3 01             	add    $0x1,%ebx
  801a75:	83 c4 10             	add    $0x10,%esp
  801a78:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801a7f:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801a82:	85 c0                	test   %eax,%eax
  801a84:	75 df                	jne    801a65 <spawn+0xdd>
  801a86:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801a8c:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char *)UTEMP + PGSIZE - string_size;
  801a92:	bf 00 10 40 00       	mov    $0x401000,%edi
  801a97:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t *)(ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801a99:	89 fa                	mov    %edi,%edx
  801a9b:	83 e2 fc             	and    $0xfffffffc,%edx
  801a9e:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801aa5:	29 c2                	sub    %eax,%edx
  801aa7:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void *)(argv_store - 2) < (void *)UTEMP)
  801aad:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ab0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ab5:	0f 86 af 03 00 00    	jbe    801e6a <spawn+0x4e2>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void *)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801abb:	83 ec 04             	sub    $0x4,%esp
  801abe:	6a 07                	push   $0x7
  801ac0:	68 00 00 40 00       	push   $0x400000
  801ac5:	6a 00                	push   $0x0
  801ac7:	e8 1d f2 ff ff       	call   800ce9 <sys_page_alloc>
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	85 c0                	test   %eax,%eax
  801ad1:	0f 88 98 03 00 00    	js     801e6f <spawn+0x4e7>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++)
  801ad7:	be 00 00 00 00       	mov    $0x0,%esi
  801adc:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801ae2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ae5:	eb 30                	jmp    801b17 <spawn+0x18f>
	{
		argv_store[i] = UTEMP2USTACK(string_store);
  801ae7:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801aed:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801af3:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801af6:	83 ec 08             	sub    $0x8,%esp
  801af9:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801afc:	57                   	push   %edi
  801afd:	e8 ee ed ff ff       	call   8008f0 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b02:	83 c4 04             	add    $0x4,%esp
  801b05:	ff 34 b3             	pushl  (%ebx,%esi,4)
  801b08:	e8 ac ed ff ff       	call   8008b9 <strlen>
  801b0d:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	for (i = 0; i < argc; i++)
  801b11:	83 c6 01             	add    $0x1,%esi
  801b14:	83 c4 10             	add    $0x10,%esp
  801b17:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801b1d:	7f c8                	jg     801ae7 <spawn+0x15f>
	}
	argv_store[argc] = 0;
  801b1f:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b25:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b2b:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char *)UTEMP + PGSIZE);
  801b32:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b38:	0f 85 8c 00 00 00    	jne    801bca <spawn+0x242>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b3e:	8b bd 94 fd ff ff    	mov    -0x26c(%ebp),%edi
  801b44:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b4a:	89 47 fc             	mov    %eax,-0x4(%edi)
	argv_store[-2] = argc;
  801b4d:	89 f8                	mov    %edi,%eax
  801b4f:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801b55:	89 78 f8             	mov    %edi,-0x8(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801b58:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801b5d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void *)(USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b63:	83 ec 0c             	sub    $0xc,%esp
  801b66:	6a 07                	push   $0x7
  801b68:	68 00 d0 bf ee       	push   $0xeebfd000
  801b6d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801b73:	68 00 00 40 00       	push   $0x400000
  801b78:	6a 00                	push   $0x0
  801b7a:	e8 ad f1 ff ff       	call   800d2c <sys_page_map>
  801b7f:	89 c3                	mov    %eax,%ebx
  801b81:	83 c4 20             	add    $0x20,%esp
  801b84:	85 c0                	test   %eax,%eax
  801b86:	0f 88 59 03 00 00    	js     801ee5 <spawn+0x55d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801b8c:	83 ec 08             	sub    $0x8,%esp
  801b8f:	68 00 00 40 00       	push   $0x400000
  801b94:	6a 00                	push   $0x0
  801b96:	e8 d3 f1 ff ff       	call   800d6e <sys_page_unmap>
  801b9b:	89 c3                	mov    %eax,%ebx
  801b9d:	83 c4 10             	add    $0x10,%esp
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	0f 88 3d 03 00 00    	js     801ee5 <spawn+0x55d>
	ph = (struct Proghdr *)(elf_buf + elf->e_phoff);
  801ba8:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801bae:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801bb5:	89 85 78 fd ff ff    	mov    %eax,-0x288(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801bbb:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801bc2:	00 00 00 
  801bc5:	e9 56 01 00 00       	jmp    801d20 <spawn+0x398>
	assert(string_store == (char *)UTEMP + PGSIZE);
  801bca:	68 48 33 80 00       	push   $0x803348
  801bcf:	68 8f 32 80 00       	push   $0x80328f
  801bd4:	68 f0 00 00 00       	push   $0xf0
  801bd9:	68 d5 32 80 00       	push   $0x8032d5
  801bde:	e8 13 e6 ff ff       	call   8001f6 <_panic>
				return r;
		}
		else
		{
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	6a 07                	push   $0x7
  801be8:	68 00 00 40 00       	push   $0x400000
  801bed:	6a 00                	push   $0x0
  801bef:	e8 f5 f0 ff ff       	call   800ce9 <sys_page_alloc>
  801bf4:	83 c4 10             	add    $0x10,%esp
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	0f 88 7b 02 00 00    	js     801e7a <spawn+0x4f2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801bff:	83 ec 08             	sub    $0x8,%esp
  801c02:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c08:	01 f0                	add    %esi,%eax
  801c0a:	50                   	push   %eax
  801c0b:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c11:	e8 b8 f9 ff ff       	call   8015ce <seek>
  801c16:	83 c4 10             	add    $0x10,%esp
  801c19:	85 c0                	test   %eax,%eax
  801c1b:	0f 88 60 02 00 00    	js     801e81 <spawn+0x4f9>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz - i))) < 0)
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c2a:	29 f0                	sub    %esi,%eax
  801c2c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c31:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c36:	0f 47 c1             	cmova  %ecx,%eax
  801c39:	50                   	push   %eax
  801c3a:	68 00 00 40 00       	push   $0x400000
  801c3f:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801c45:	e8 bb f8 ff ff       	call   801505 <readn>
  801c4a:	83 c4 10             	add    $0x10,%esp
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	0f 88 33 02 00 00    	js     801e88 <spawn+0x500>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void *)(va + i), perm)) < 0)
  801c55:	83 ec 0c             	sub    $0xc,%esp
  801c58:	57                   	push   %edi
  801c59:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801c5f:	56                   	push   %esi
  801c60:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801c66:	68 00 00 40 00       	push   $0x400000
  801c6b:	6a 00                	push   $0x0
  801c6d:	e8 ba f0 ff ff       	call   800d2c <sys_page_map>
  801c72:	83 c4 20             	add    $0x20,%esp
  801c75:	85 c0                	test   %eax,%eax
  801c77:	0f 88 80 00 00 00    	js     801cfd <spawn+0x375>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801c7d:	83 ec 08             	sub    $0x8,%esp
  801c80:	68 00 00 40 00       	push   $0x400000
  801c85:	6a 00                	push   $0x0
  801c87:	e8 e2 f0 ff ff       	call   800d6e <sys_page_unmap>
  801c8c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE)
  801c8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c95:	89 de                	mov    %ebx,%esi
  801c97:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801c9d:	76 73                	jbe    801d12 <spawn+0x38a>
		if (i >= filesz)
  801c9f:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801ca5:	0f 87 38 ff ff ff    	ja     801be3 <spawn+0x25b>
			if ((r = sys_page_alloc(child, (void *)(va + i), perm)) < 0)
  801cab:	83 ec 04             	sub    $0x4,%esp
  801cae:	57                   	push   %edi
  801caf:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  801cb5:	56                   	push   %esi
  801cb6:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801cbc:	e8 28 f0 ff ff       	call   800ce9 <sys_page_alloc>
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	85 c0                	test   %eax,%eax
  801cc6:	79 c7                	jns    801c8f <spawn+0x307>
  801cc8:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801cd3:	e8 92 ef ff ff       	call   800c6a <sys_env_destroy>
	close(fd);
  801cd8:	83 c4 04             	add    $0x4,%esp
  801cdb:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801ce1:	e8 5c f6 ff ff       	call   801342 <close>
	return r;
  801ce6:	83 c4 10             	add    $0x10,%esp
  801ce9:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
}
  801cef:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801cf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5e                   	pop    %esi
  801cfa:	5f                   	pop    %edi
  801cfb:	5d                   	pop    %ebp
  801cfc:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801cfd:	50                   	push   %eax
  801cfe:	68 e1 32 80 00       	push   $0x8032e1
  801d03:	68 28 01 00 00       	push   $0x128
  801d08:	68 d5 32 80 00       	push   $0x8032d5
  801d0d:	e8 e4 e4 ff ff       	call   8001f6 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++)
  801d12:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801d19:	83 85 78 fd ff ff 20 	addl   $0x20,-0x288(%ebp)
  801d20:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d27:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801d2d:	7e 71                	jle    801da0 <spawn+0x418>
		if (ph->p_type != ELF_PROG_LOAD)
  801d2f:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801d35:	83 3a 01             	cmpl   $0x1,(%edx)
  801d38:	75 d8                	jne    801d12 <spawn+0x38a>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d3a:	8b 42 18             	mov    0x18(%edx),%eax
  801d3d:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d40:	83 f8 01             	cmp    $0x1,%eax
  801d43:	19 ff                	sbb    %edi,%edi
  801d45:	83 e7 fe             	and    $0xfffffffe,%edi
  801d48:	83 c7 07             	add    $0x7,%edi
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d4b:	8b 72 04             	mov    0x4(%edx),%esi
  801d4e:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
  801d54:	8b 5a 10             	mov    0x10(%edx),%ebx
  801d57:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
  801d5d:	8b 42 14             	mov    0x14(%edx),%eax
  801d60:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801d66:	8b 4a 08             	mov    0x8(%edx),%ecx
  801d69:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
	if ((i = PGOFF(va)))
  801d6f:	89 c8                	mov    %ecx,%eax
  801d71:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d76:	74 1e                	je     801d96 <spawn+0x40e>
		va -= i;
  801d78:	29 c1                	sub    %eax,%ecx
  801d7a:	89 8d 88 fd ff ff    	mov    %ecx,-0x278(%ebp)
		memsz += i;
  801d80:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801d86:	01 c3                	add    %eax,%ebx
  801d88:	89 9d 94 fd ff ff    	mov    %ebx,-0x26c(%ebp)
		fileoffset -= i;
  801d8e:	29 c6                	sub    %eax,%esi
  801d90:	89 b5 80 fd ff ff    	mov    %esi,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE)
  801d96:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d9b:	e9 f5 fe ff ff       	jmp    801c95 <spawn+0x30d>
	close(fd);
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	ff b5 90 fd ff ff    	pushl  -0x270(%ebp)
  801da9:	e8 94 f5 ff ff       	call   801342 <close>
  801dae:	83 c4 10             	add    $0x10,%esp
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	int r, pn;
	struct Env *e;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801db1:	bb 00 08 00 00       	mov    $0x800,%ebx
  801db6:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801dbc:	eb 0f                	jmp    801dcd <spawn+0x445>
  801dbe:	83 c3 01             	add    $0x1,%ebx
  801dc1:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801dc7:	0f 84 c2 00 00 00    	je     801e8f <spawn+0x507>
	{
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801dcd:	89 d8                	mov    %ebx,%eax
  801dcf:	c1 f8 0a             	sar    $0xa,%eax
  801dd2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801dd9:	a8 01                	test   $0x1,%al
  801ddb:	74 e1                	je     801dbe <spawn+0x436>
  801ddd:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801de4:	a8 01                	test   $0x1,%al
  801de6:	74 d6                	je     801dbe <spawn+0x436>
		{
			if (uvpt[pn] & PTE_SHARE)
  801de8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801def:	f6 c4 04             	test   $0x4,%ah
  801df2:	74 ca                	je     801dbe <spawn+0x436>
			{
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
									  child, (void *)(pn * PGSIZE),
									  uvpt[pn] & PTE_SYSCALL)) < 0)
  801df4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801dfb:	89 da                	mov    %ebx,%edx
  801dfd:	c1 e2 0c             	shl    $0xc,%edx
				if ((r = sys_page_map(0, (void *)(pn * PGSIZE),
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	25 07 0e 00 00       	and    $0xe07,%eax
  801e08:	50                   	push   %eax
  801e09:	52                   	push   %edx
  801e0a:	56                   	push   %esi
  801e0b:	52                   	push   %edx
  801e0c:	6a 00                	push   $0x0
  801e0e:	e8 19 ef ff ff       	call   800d2c <sys_page_map>
  801e13:	83 c4 20             	add    $0x20,%esp
  801e16:	85 c0                	test   %eax,%eax
  801e18:	79 a4                	jns    801dbe <spawn+0x436>
		panic("copy_shared_pages: %e", r);
  801e1a:	50                   	push   %eax
  801e1b:	68 2f 33 80 00       	push   $0x80332f
  801e20:	68 82 00 00 00       	push   $0x82
  801e25:	68 d5 32 80 00       	push   $0x8032d5
  801e2a:	e8 c7 e3 ff ff       	call   8001f6 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801e2f:	50                   	push   %eax
  801e30:	68 fe 32 80 00       	push   $0x8032fe
  801e35:	68 86 00 00 00       	push   $0x86
  801e3a:	68 d5 32 80 00       	push   $0x8032d5
  801e3f:	e8 b2 e3 ff ff       	call   8001f6 <_panic>
		panic("sys_env_set_status: %e", r);
  801e44:	50                   	push   %eax
  801e45:	68 18 33 80 00       	push   $0x803318
  801e4a:	68 89 00 00 00       	push   $0x89
  801e4f:	68 d5 32 80 00       	push   $0x8032d5
  801e54:	e8 9d e3 ff ff       	call   8001f6 <_panic>
		return r;
  801e59:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e5f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801e65:	e9 85 fe ff ff       	jmp    801cef <spawn+0x367>
		return -E_NO_MEM;
  801e6a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	return r;
  801e6f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801e75:	e9 75 fe ff ff       	jmp    801cef <spawn+0x367>
  801e7a:	89 c7                	mov    %eax,%edi
  801e7c:	e9 49 fe ff ff       	jmp    801cca <spawn+0x342>
  801e81:	89 c7                	mov    %eax,%edi
  801e83:	e9 42 fe ff ff       	jmp    801cca <spawn+0x342>
  801e88:	89 c7                	mov    %eax,%edi
  801e8a:	e9 3b fe ff ff       	jmp    801cca <spawn+0x342>
	child_tf.tf_eflags |= FL_IOPL_3; // devious: see user/faultio.c
  801e8f:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e96:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e99:	83 ec 08             	sub    $0x8,%esp
  801e9c:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801ea2:	50                   	push   %eax
  801ea3:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ea9:	e8 44 ef ff ff       	call   800df2 <sys_env_set_trapframe>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	0f 88 76 ff ff ff    	js     801e2f <spawn+0x4a7>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801eb9:	83 ec 08             	sub    $0x8,%esp
  801ebc:	6a 02                	push   $0x2
  801ebe:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ec4:	e8 e7 ee ff ff       	call   800db0 <sys_env_set_status>
  801ec9:	83 c4 10             	add    $0x10,%esp
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	0f 88 70 ff ff ff    	js     801e44 <spawn+0x4bc>
	return child;
  801ed4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801eda:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801ee0:	e9 0a fe ff ff       	jmp    801cef <spawn+0x367>
	sys_page_unmap(0, UTEMP);
  801ee5:	83 ec 08             	sub    $0x8,%esp
  801ee8:	68 00 00 40 00       	push   $0x400000
  801eed:	6a 00                	push   $0x0
  801eef:	e8 7a ee ff ff       	call   800d6e <sys_page_unmap>
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801efd:	e9 ed fd ff ff       	jmp    801cef <spawn+0x367>

00801f02 <spawnl>:
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	57                   	push   %edi
  801f06:	56                   	push   %esi
  801f07:	53                   	push   %ebx
  801f08:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f0b:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc = 0;
  801f0e:	b8 00 00 00 00       	mov    $0x0,%eax
	while (va_arg(vl, void *) != NULL)
  801f13:	eb 05                	jmp    801f1a <spawnl+0x18>
		argc++;
  801f15:	83 c0 01             	add    $0x1,%eax
	while (va_arg(vl, void *) != NULL)
  801f18:	89 ca                	mov    %ecx,%edx
  801f1a:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f1d:	83 3a 00             	cmpl   $0x0,(%edx)
  801f20:	75 f3                	jne    801f15 <spawnl+0x13>
	const char *argv[argc + 2];
  801f22:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801f29:	83 e2 f0             	and    $0xfffffff0,%edx
  801f2c:	29 d4                	sub    %edx,%esp
  801f2e:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f32:	c1 ea 02             	shr    $0x2,%edx
  801f35:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f3c:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f41:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc + 1] = NULL;
  801f48:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f4f:	00 
	va_start(vl, arg0);
  801f50:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f53:	89 c2                	mov    %eax,%edx
	for (i = 0; i < argc; i++)
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb 0b                	jmp    801f67 <spawnl+0x65>
		argv[i + 1] = va_arg(vl, const char *);
  801f5c:	83 c0 01             	add    $0x1,%eax
  801f5f:	8b 39                	mov    (%ecx),%edi
  801f61:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f64:	8d 49 04             	lea    0x4(%ecx),%ecx
	for (i = 0; i < argc; i++)
  801f67:	39 d0                	cmp    %edx,%eax
  801f69:	75 f1                	jne    801f5c <spawnl+0x5a>
	return spawn(prog, argv);
  801f6b:	83 ec 08             	sub    $0x8,%esp
  801f6e:	56                   	push   %esi
  801f6f:	ff 75 08             	pushl  0x8(%ebp)
  801f72:	e8 11 fa ff ff       	call   801988 <spawn>
}
  801f77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7a:	5b                   	pop    %ebx
  801f7b:	5e                   	pop    %esi
  801f7c:	5f                   	pop    %edi
  801f7d:	5d                   	pop    %ebp
  801f7e:	c3                   	ret    

00801f7f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801f85:	68 70 33 80 00       	push   $0x803370
  801f8a:	ff 75 0c             	pushl  0xc(%ebp)
  801f8d:	e8 5e e9 ff ff       	call   8008f0 <strcpy>
	return 0;
}
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <devsock_close>:
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	53                   	push   %ebx
  801f9d:	83 ec 10             	sub    $0x10,%esp
  801fa0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801fa3:	53                   	push   %ebx
  801fa4:	e8 d3 0a 00 00       	call   802a7c <pageref>
  801fa9:	83 c4 10             	add    $0x10,%esp
		return 0;
  801fac:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801fb1:	83 f8 01             	cmp    $0x1,%eax
  801fb4:	74 07                	je     801fbd <devsock_close+0x24>
}
  801fb6:	89 d0                	mov    %edx,%eax
  801fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	ff 73 0c             	pushl  0xc(%ebx)
  801fc3:	e8 b7 02 00 00       	call   80227f <nsipc_close>
  801fc8:	89 c2                	mov    %eax,%edx
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	eb e7                	jmp    801fb6 <devsock_close+0x1d>

00801fcf <devsock_write>:
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fd5:	6a 00                	push   $0x0
  801fd7:	ff 75 10             	pushl  0x10(%ebp)
  801fda:	ff 75 0c             	pushl  0xc(%ebp)
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	ff 70 0c             	pushl  0xc(%eax)
  801fe3:	e8 74 03 00 00       	call   80235c <nsipc_send>
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <devsock_read>:
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	ff 75 10             	pushl  0x10(%ebp)
  801ff5:	ff 75 0c             	pushl  0xc(%ebp)
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	ff 70 0c             	pushl  0xc(%eax)
  801ffe:	e8 ed 02 00 00       	call   8022f0 <nsipc_recv>
}
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <fd2sockid>:
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80200b:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80200e:	52                   	push   %edx
  80200f:	50                   	push   %eax
  802010:	e8 f8 f1 ff ff       	call   80120d <fd_lookup>
  802015:	83 c4 10             	add    $0x10,%esp
  802018:	85 c0                	test   %eax,%eax
  80201a:	78 10                	js     80202c <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  802025:	39 08                	cmp    %ecx,(%eax)
  802027:	75 05                	jne    80202e <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  802029:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    
		return -E_NOT_SUPP;
  80202e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802033:	eb f7                	jmp    80202c <fd2sockid+0x27>

00802035 <alloc_sockfd>:
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	56                   	push   %esi
  802039:	53                   	push   %ebx
  80203a:	83 ec 1c             	sub    $0x1c,%esp
  80203d:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80203f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802042:	50                   	push   %eax
  802043:	e8 76 f1 ff ff       	call   8011be <fd_alloc>
  802048:	89 c3                	mov    %eax,%ebx
  80204a:	83 c4 10             	add    $0x10,%esp
  80204d:	85 c0                	test   %eax,%eax
  80204f:	78 43                	js     802094 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802051:	83 ec 04             	sub    $0x4,%esp
  802054:	68 07 04 00 00       	push   $0x407
  802059:	ff 75 f4             	pushl  -0xc(%ebp)
  80205c:	6a 00                	push   $0x0
  80205e:	e8 86 ec ff ff       	call   800ce9 <sys_page_alloc>
  802063:	89 c3                	mov    %eax,%ebx
  802065:	83 c4 10             	add    $0x10,%esp
  802068:	85 c0                	test   %eax,%eax
  80206a:	78 28                	js     802094 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 15 28 40 80 00    	mov    0x804028,%edx
  802075:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802081:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	50                   	push   %eax
  802088:	e8 0a f1 ff ff       	call   801197 <fd2num>
  80208d:	89 c3                	mov    %eax,%ebx
  80208f:	83 c4 10             	add    $0x10,%esp
  802092:	eb 0c                	jmp    8020a0 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	56                   	push   %esi
  802098:	e8 e2 01 00 00       	call   80227f <nsipc_close>
		return r;
  80209d:	83 c4 10             	add    $0x10,%esp
}
  8020a0:	89 d8                	mov    %ebx,%eax
  8020a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020a5:	5b                   	pop    %ebx
  8020a6:	5e                   	pop    %esi
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    

008020a9 <accept>:
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	e8 4e ff ff ff       	call   802005 <fd2sockid>
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 1b                	js     8020d6 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	ff 75 10             	pushl  0x10(%ebp)
  8020c1:	ff 75 0c             	pushl  0xc(%ebp)
  8020c4:	50                   	push   %eax
  8020c5:	e8 0e 01 00 00       	call   8021d8 <nsipc_accept>
  8020ca:	83 c4 10             	add    $0x10,%esp
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 05                	js     8020d6 <accept+0x2d>
	return alloc_sockfd(r);
  8020d1:	e8 5f ff ff ff       	call   802035 <alloc_sockfd>
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <bind>:
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	e8 1f ff ff ff       	call   802005 <fd2sockid>
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	78 12                	js     8020fc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8020ea:	83 ec 04             	sub    $0x4,%esp
  8020ed:	ff 75 10             	pushl  0x10(%ebp)
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	50                   	push   %eax
  8020f4:	e8 2f 01 00 00       	call   802228 <nsipc_bind>
  8020f9:	83 c4 10             	add    $0x10,%esp
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <shutdown>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	e8 f9 fe ff ff       	call   802005 <fd2sockid>
  80210c:	85 c0                	test   %eax,%eax
  80210e:	78 0f                	js     80211f <shutdown+0x21>
	return nsipc_shutdown(r, how);
  802110:	83 ec 08             	sub    $0x8,%esp
  802113:	ff 75 0c             	pushl  0xc(%ebp)
  802116:	50                   	push   %eax
  802117:	e8 41 01 00 00       	call   80225d <nsipc_shutdown>
  80211c:	83 c4 10             	add    $0x10,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <connect>:
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	e8 d6 fe ff ff       	call   802005 <fd2sockid>
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 12                	js     802145 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	ff 75 10             	pushl  0x10(%ebp)
  802139:	ff 75 0c             	pushl  0xc(%ebp)
  80213c:	50                   	push   %eax
  80213d:	e8 57 01 00 00       	call   802299 <nsipc_connect>
  802142:	83 c4 10             	add    $0x10,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <listen>:
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	e8 b0 fe ff ff       	call   802005 <fd2sockid>
  802155:	85 c0                	test   %eax,%eax
  802157:	78 0f                	js     802168 <listen+0x21>
	return nsipc_listen(r, backlog);
  802159:	83 ec 08             	sub    $0x8,%esp
  80215c:	ff 75 0c             	pushl  0xc(%ebp)
  80215f:	50                   	push   %eax
  802160:	e8 69 01 00 00       	call   8022ce <nsipc_listen>
  802165:	83 c4 10             	add    $0x10,%esp
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <socket>:

int
socket(int domain, int type, int protocol)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802170:	ff 75 10             	pushl  0x10(%ebp)
  802173:	ff 75 0c             	pushl  0xc(%ebp)
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	e8 3c 02 00 00       	call   8023ba <nsipc_socket>
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	85 c0                	test   %eax,%eax
  802183:	78 05                	js     80218a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  802185:	e8 ab fe ff ff       	call   802035 <alloc_sockfd>
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	53                   	push   %ebx
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802195:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  80219c:	74 26                	je     8021c4 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80219e:	6a 07                	push   $0x7
  8021a0:	68 00 70 80 00       	push   $0x807000
  8021a5:	53                   	push   %ebx
  8021a6:	ff 35 04 50 80 00    	pushl  0x805004
  8021ac:	e8 3e 08 00 00       	call   8029ef <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021b1:	83 c4 0c             	add    $0xc,%esp
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	e8 c9 07 00 00       	call   802988 <ipc_recv>
}
  8021bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021c2:	c9                   	leave  
  8021c3:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021c4:	83 ec 0c             	sub    $0xc,%esp
  8021c7:	6a 02                	push   $0x2
  8021c9:	e8 75 08 00 00       	call   802a43 <ipc_find_env>
  8021ce:	a3 04 50 80 00       	mov    %eax,0x805004
  8021d3:	83 c4 10             	add    $0x10,%esp
  8021d6:	eb c6                	jmp    80219e <nsipc+0x12>

008021d8 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	56                   	push   %esi
  8021dc:	53                   	push   %ebx
  8021dd:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021e8:	8b 06                	mov    (%esi),%eax
  8021ea:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f4:	e8 93 ff ff ff       	call   80218c <nsipc>
  8021f9:	89 c3                	mov    %eax,%ebx
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 20                	js     80221f <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021ff:	83 ec 04             	sub    $0x4,%esp
  802202:	ff 35 10 70 80 00    	pushl  0x807010
  802208:	68 00 70 80 00       	push   $0x807000
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	e8 69 e8 ff ff       	call   800a7e <memmove>
		*addrlen = ret->ret_addrlen;
  802215:	a1 10 70 80 00       	mov    0x807010,%eax
  80221a:	89 06                	mov    %eax,(%esi)
  80221c:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80221f:	89 d8                	mov    %ebx,%eax
  802221:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802224:	5b                   	pop    %ebx
  802225:	5e                   	pop    %esi
  802226:	5d                   	pop    %ebp
  802227:	c3                   	ret    

00802228 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	53                   	push   %ebx
  80222c:	83 ec 08             	sub    $0x8,%esp
  80222f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80223a:	53                   	push   %ebx
  80223b:	ff 75 0c             	pushl  0xc(%ebp)
  80223e:	68 04 70 80 00       	push   $0x807004
  802243:	e8 36 e8 ff ff       	call   800a7e <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802248:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80224e:	b8 02 00 00 00       	mov    $0x2,%eax
  802253:	e8 34 ff ff ff       	call   80218c <nsipc>
}
  802258:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80226b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226e:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802273:	b8 03 00 00 00       	mov    $0x3,%eax
  802278:	e8 0f ff ff ff       	call   80218c <nsipc>
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    

0080227f <nsipc_close>:

int
nsipc_close(int s)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
  802282:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80228d:	b8 04 00 00 00       	mov    $0x4,%eax
  802292:	e8 f5 fe ff ff       	call   80218c <nsipc>
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	53                   	push   %ebx
  80229d:	83 ec 08             	sub    $0x8,%esp
  8022a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022ab:	53                   	push   %ebx
  8022ac:	ff 75 0c             	pushl  0xc(%ebp)
  8022af:	68 04 70 80 00       	push   $0x807004
  8022b4:	e8 c5 e7 ff ff       	call   800a7e <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022b9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8022bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8022c4:	e8 c3 fe ff ff       	call   80218c <nsipc>
}
  8022c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022e4:	b8 06 00 00 00       	mov    $0x6,%eax
  8022e9:	e8 9e fe ff ff       	call   80218c <nsipc>
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	56                   	push   %esi
  8022f4:	53                   	push   %ebx
  8022f5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802300:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802306:	8b 45 14             	mov    0x14(%ebp),%eax
  802309:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80230e:	b8 07 00 00 00       	mov    $0x7,%eax
  802313:	e8 74 fe ff ff       	call   80218c <nsipc>
  802318:	89 c3                	mov    %eax,%ebx
  80231a:	85 c0                	test   %eax,%eax
  80231c:	78 1f                	js     80233d <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80231e:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802323:	7f 21                	jg     802346 <nsipc_recv+0x56>
  802325:	39 c6                	cmp    %eax,%esi
  802327:	7c 1d                	jl     802346 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	50                   	push   %eax
  80232d:	68 00 70 80 00       	push   $0x807000
  802332:	ff 75 0c             	pushl  0xc(%ebp)
  802335:	e8 44 e7 ff ff       	call   800a7e <memmove>
  80233a:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80233d:	89 d8                	mov    %ebx,%eax
  80233f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802342:	5b                   	pop    %ebx
  802343:	5e                   	pop    %esi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
		assert(r < 1600 && r <= len);
  802346:	68 7c 33 80 00       	push   $0x80337c
  80234b:	68 8f 32 80 00       	push   $0x80328f
  802350:	6a 62                	push   $0x62
  802352:	68 91 33 80 00       	push   $0x803391
  802357:	e8 9a de ff ff       	call   8001f6 <_panic>

0080235c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	53                   	push   %ebx
  802360:	83 ec 04             	sub    $0x4,%esp
  802363:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80236e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802374:	7f 2e                	jg     8023a4 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	53                   	push   %ebx
  80237a:	ff 75 0c             	pushl  0xc(%ebp)
  80237d:	68 0c 70 80 00       	push   $0x80700c
  802382:	e8 f7 e6 ff ff       	call   800a7e <memmove>
	nsipcbuf.send.req_size = size;
  802387:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  80238d:	8b 45 14             	mov    0x14(%ebp),%eax
  802390:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802395:	b8 08 00 00 00       	mov    $0x8,%eax
  80239a:	e8 ed fd ff ff       	call   80218c <nsipc>
}
  80239f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    
	assert(size < 1600);
  8023a4:	68 9d 33 80 00       	push   $0x80339d
  8023a9:	68 8f 32 80 00       	push   $0x80328f
  8023ae:	6a 6d                	push   $0x6d
  8023b0:	68 91 33 80 00       	push   $0x803391
  8023b5:	e8 3c de ff ff       	call   8001f6 <_panic>

008023ba <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cb:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d3:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023d8:	b8 09 00 00 00       	mov    $0x9,%eax
  8023dd:	e8 aa fd ff ff       	call   80218c <nsipc>
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	56                   	push   %esi
  8023e8:	53                   	push   %ebx
  8023e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023ec:	83 ec 0c             	sub    $0xc,%esp
  8023ef:	ff 75 08             	pushl  0x8(%ebp)
  8023f2:	e8 b0 ed ff ff       	call   8011a7 <fd2data>
  8023f7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023f9:	83 c4 08             	add    $0x8,%esp
  8023fc:	68 a9 33 80 00       	push   $0x8033a9
  802401:	53                   	push   %ebx
  802402:	e8 e9 e4 ff ff       	call   8008f0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802407:	8b 46 04             	mov    0x4(%esi),%eax
  80240a:	2b 06                	sub    (%esi),%eax
  80240c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802412:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802419:	00 00 00 
	stat->st_dev = &devpipe;
  80241c:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802423:	40 80 00 
	return 0;
}
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80242e:	5b                   	pop    %ebx
  80242f:	5e                   	pop    %esi
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	53                   	push   %ebx
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80243c:	53                   	push   %ebx
  80243d:	6a 00                	push   $0x0
  80243f:	e8 2a e9 ff ff       	call   800d6e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802444:	89 1c 24             	mov    %ebx,(%esp)
  802447:	e8 5b ed ff ff       	call   8011a7 <fd2data>
  80244c:	83 c4 08             	add    $0x8,%esp
  80244f:	50                   	push   %eax
  802450:	6a 00                	push   $0x0
  802452:	e8 17 e9 ff ff       	call   800d6e <sys_page_unmap>
}
  802457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <_pipeisclosed>:
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	57                   	push   %edi
  802460:	56                   	push   %esi
  802461:	53                   	push   %ebx
  802462:	83 ec 1c             	sub    $0x1c,%esp
  802465:	89 c7                	mov    %eax,%edi
  802467:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802469:	a1 08 50 80 00       	mov    0x805008,%eax
  80246e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802471:	83 ec 0c             	sub    $0xc,%esp
  802474:	57                   	push   %edi
  802475:	e8 02 06 00 00       	call   802a7c <pageref>
  80247a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80247d:	89 34 24             	mov    %esi,(%esp)
  802480:	e8 f7 05 00 00       	call   802a7c <pageref>
		nn = thisenv->env_runs;
  802485:	8b 15 08 50 80 00    	mov    0x805008,%edx
  80248b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80248e:	83 c4 10             	add    $0x10,%esp
  802491:	39 cb                	cmp    %ecx,%ebx
  802493:	74 1b                	je     8024b0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802495:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802498:	75 cf                	jne    802469 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80249a:	8b 42 58             	mov    0x58(%edx),%eax
  80249d:	6a 01                	push   $0x1
  80249f:	50                   	push   %eax
  8024a0:	53                   	push   %ebx
  8024a1:	68 b0 33 80 00       	push   $0x8033b0
  8024a6:	e8 26 de ff ff       	call   8002d1 <cprintf>
  8024ab:	83 c4 10             	add    $0x10,%esp
  8024ae:	eb b9                	jmp    802469 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8024b0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8024b3:	0f 94 c0             	sete   %al
  8024b6:	0f b6 c0             	movzbl %al,%eax
}
  8024b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024bc:	5b                   	pop    %ebx
  8024bd:	5e                   	pop    %esi
  8024be:	5f                   	pop    %edi
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    

008024c1 <devpipe_write>:
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	57                   	push   %edi
  8024c5:	56                   	push   %esi
  8024c6:	53                   	push   %ebx
  8024c7:	83 ec 28             	sub    $0x28,%esp
  8024ca:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8024cd:	56                   	push   %esi
  8024ce:	e8 d4 ec ff ff       	call   8011a7 <fd2data>
  8024d3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8024d5:	83 c4 10             	add    $0x10,%esp
  8024d8:	bf 00 00 00 00       	mov    $0x0,%edi
  8024dd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024e0:	74 4f                	je     802531 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024e2:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e5:	8b 0b                	mov    (%ebx),%ecx
  8024e7:	8d 51 20             	lea    0x20(%ecx),%edx
  8024ea:	39 d0                	cmp    %edx,%eax
  8024ec:	72 14                	jb     802502 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8024ee:	89 da                	mov    %ebx,%edx
  8024f0:	89 f0                	mov    %esi,%eax
  8024f2:	e8 65 ff ff ff       	call   80245c <_pipeisclosed>
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	75 3a                	jne    802535 <devpipe_write+0x74>
			sys_yield();
  8024fb:	e8 ca e7 ff ff       	call   800cca <sys_yield>
  802500:	eb e0                	jmp    8024e2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802505:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802509:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	c1 fa 1f             	sar    $0x1f,%edx
  802511:	89 d1                	mov    %edx,%ecx
  802513:	c1 e9 1b             	shr    $0x1b,%ecx
  802516:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  802519:	83 e2 1f             	and    $0x1f,%edx
  80251c:	29 ca                	sub    %ecx,%edx
  80251e:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  802522:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802526:	83 c0 01             	add    $0x1,%eax
  802529:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80252c:	83 c7 01             	add    $0x1,%edi
  80252f:	eb ac                	jmp    8024dd <devpipe_write+0x1c>
	return i;
  802531:	89 f8                	mov    %edi,%eax
  802533:	eb 05                	jmp    80253a <devpipe_write+0x79>
				return 0;
  802535:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80253a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80253d:	5b                   	pop    %ebx
  80253e:	5e                   	pop    %esi
  80253f:	5f                   	pop    %edi
  802540:	5d                   	pop    %ebp
  802541:	c3                   	ret    

00802542 <devpipe_read>:
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	57                   	push   %edi
  802546:	56                   	push   %esi
  802547:	53                   	push   %ebx
  802548:	83 ec 18             	sub    $0x18,%esp
  80254b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80254e:	57                   	push   %edi
  80254f:	e8 53 ec ff ff       	call   8011a7 <fd2data>
  802554:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802556:	83 c4 10             	add    $0x10,%esp
  802559:	be 00 00 00 00       	mov    $0x0,%esi
  80255e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802561:	74 47                	je     8025aa <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802563:	8b 03                	mov    (%ebx),%eax
  802565:	3b 43 04             	cmp    0x4(%ebx),%eax
  802568:	75 22                	jne    80258c <devpipe_read+0x4a>
			if (i > 0)
  80256a:	85 f6                	test   %esi,%esi
  80256c:	75 14                	jne    802582 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80256e:	89 da                	mov    %ebx,%edx
  802570:	89 f8                	mov    %edi,%eax
  802572:	e8 e5 fe ff ff       	call   80245c <_pipeisclosed>
  802577:	85 c0                	test   %eax,%eax
  802579:	75 33                	jne    8025ae <devpipe_read+0x6c>
			sys_yield();
  80257b:	e8 4a e7 ff ff       	call   800cca <sys_yield>
  802580:	eb e1                	jmp    802563 <devpipe_read+0x21>
				return i;
  802582:	89 f0                	mov    %esi,%eax
}
  802584:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802587:	5b                   	pop    %ebx
  802588:	5e                   	pop    %esi
  802589:	5f                   	pop    %edi
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80258c:	99                   	cltd   
  80258d:	c1 ea 1b             	shr    $0x1b,%edx
  802590:	01 d0                	add    %edx,%eax
  802592:	83 e0 1f             	and    $0x1f,%eax
  802595:	29 d0                	sub    %edx,%eax
  802597:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80259c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80259f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025a2:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  8025a5:	83 c6 01             	add    $0x1,%esi
  8025a8:	eb b4                	jmp    80255e <devpipe_read+0x1c>
	return i;
  8025aa:	89 f0                	mov    %esi,%eax
  8025ac:	eb d6                	jmp    802584 <devpipe_read+0x42>
				return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b3:	eb cf                	jmp    802584 <devpipe_read+0x42>

008025b5 <pipe>:
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	56                   	push   %esi
  8025b9:	53                   	push   %ebx
  8025ba:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8025bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025c0:	50                   	push   %eax
  8025c1:	e8 f8 eb ff ff       	call   8011be <fd_alloc>
  8025c6:	89 c3                	mov    %eax,%ebx
  8025c8:	83 c4 10             	add    $0x10,%esp
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	78 5b                	js     80262a <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cf:	83 ec 04             	sub    $0x4,%esp
  8025d2:	68 07 04 00 00       	push   $0x407
  8025d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025da:	6a 00                	push   $0x0
  8025dc:	e8 08 e7 ff ff       	call   800ce9 <sys_page_alloc>
  8025e1:	89 c3                	mov    %eax,%ebx
  8025e3:	83 c4 10             	add    $0x10,%esp
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	78 40                	js     80262a <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8025ea:	83 ec 0c             	sub    $0xc,%esp
  8025ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025f0:	50                   	push   %eax
  8025f1:	e8 c8 eb ff ff       	call   8011be <fd_alloc>
  8025f6:	89 c3                	mov    %eax,%ebx
  8025f8:	83 c4 10             	add    $0x10,%esp
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	78 1b                	js     80261a <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ff:	83 ec 04             	sub    $0x4,%esp
  802602:	68 07 04 00 00       	push   $0x407
  802607:	ff 75 f0             	pushl  -0x10(%ebp)
  80260a:	6a 00                	push   $0x0
  80260c:	e8 d8 e6 ff ff       	call   800ce9 <sys_page_alloc>
  802611:	89 c3                	mov    %eax,%ebx
  802613:	83 c4 10             	add    $0x10,%esp
  802616:	85 c0                	test   %eax,%eax
  802618:	79 19                	jns    802633 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80261a:	83 ec 08             	sub    $0x8,%esp
  80261d:	ff 75 f4             	pushl  -0xc(%ebp)
  802620:	6a 00                	push   $0x0
  802622:	e8 47 e7 ff ff       	call   800d6e <sys_page_unmap>
  802627:	83 c4 10             	add    $0x10,%esp
}
  80262a:	89 d8                	mov    %ebx,%eax
  80262c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80262f:	5b                   	pop    %ebx
  802630:	5e                   	pop    %esi
  802631:	5d                   	pop    %ebp
  802632:	c3                   	ret    
	va = fd2data(fd0);
  802633:	83 ec 0c             	sub    $0xc,%esp
  802636:	ff 75 f4             	pushl  -0xc(%ebp)
  802639:	e8 69 eb ff ff       	call   8011a7 <fd2data>
  80263e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802640:	83 c4 0c             	add    $0xc,%esp
  802643:	68 07 04 00 00       	push   $0x407
  802648:	50                   	push   %eax
  802649:	6a 00                	push   $0x0
  80264b:	e8 99 e6 ff ff       	call   800ce9 <sys_page_alloc>
  802650:	89 c3                	mov    %eax,%ebx
  802652:	83 c4 10             	add    $0x10,%esp
  802655:	85 c0                	test   %eax,%eax
  802657:	0f 88 8c 00 00 00    	js     8026e9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265d:	83 ec 0c             	sub    $0xc,%esp
  802660:	ff 75 f0             	pushl  -0x10(%ebp)
  802663:	e8 3f eb ff ff       	call   8011a7 <fd2data>
  802668:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80266f:	50                   	push   %eax
  802670:	6a 00                	push   $0x0
  802672:	56                   	push   %esi
  802673:	6a 00                	push   $0x0
  802675:	e8 b2 e6 ff ff       	call   800d2c <sys_page_map>
  80267a:	89 c3                	mov    %eax,%ebx
  80267c:	83 c4 20             	add    $0x20,%esp
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 58                	js     8026db <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80268c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8026a1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8026ad:	83 ec 0c             	sub    $0xc,%esp
  8026b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8026b3:	e8 df ea ff ff       	call   801197 <fd2num>
  8026b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026bb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026bd:	83 c4 04             	add    $0x4,%esp
  8026c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8026c3:	e8 cf ea ff ff       	call   801197 <fd2num>
  8026c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026cb:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ce:	83 c4 10             	add    $0x10,%esp
  8026d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026d6:	e9 4f ff ff ff       	jmp    80262a <pipe+0x75>
	sys_page_unmap(0, va);
  8026db:	83 ec 08             	sub    $0x8,%esp
  8026de:	56                   	push   %esi
  8026df:	6a 00                	push   $0x0
  8026e1:	e8 88 e6 ff ff       	call   800d6e <sys_page_unmap>
  8026e6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8026e9:	83 ec 08             	sub    $0x8,%esp
  8026ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8026ef:	6a 00                	push   $0x0
  8026f1:	e8 78 e6 ff ff       	call   800d6e <sys_page_unmap>
  8026f6:	83 c4 10             	add    $0x10,%esp
  8026f9:	e9 1c ff ff ff       	jmp    80261a <pipe+0x65>

008026fe <pipeisclosed>:
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802704:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802707:	50                   	push   %eax
  802708:	ff 75 08             	pushl  0x8(%ebp)
  80270b:	e8 fd ea ff ff       	call   80120d <fd_lookup>
  802710:	83 c4 10             	add    $0x10,%esp
  802713:	85 c0                	test   %eax,%eax
  802715:	78 18                	js     80272f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802717:	83 ec 0c             	sub    $0xc,%esp
  80271a:	ff 75 f4             	pushl  -0xc(%ebp)
  80271d:	e8 85 ea ff ff       	call   8011a7 <fd2data>
	return _pipeisclosed(fd, p);
  802722:	89 c2                	mov    %eax,%edx
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	e8 30 fd ff ff       	call   80245c <_pipeisclosed>
  80272c:	83 c4 10             	add    $0x10,%esp
}
  80272f:	c9                   	leave  
  802730:	c3                   	ret    

00802731 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	56                   	push   %esi
  802735:	53                   	push   %ebx
  802736:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802739:	85 f6                	test   %esi,%esi
  80273b:	74 13                	je     802750 <wait+0x1f>
	e = &envs[ENVX(envid)];
  80273d:	89 f3                	mov    %esi,%ebx
  80273f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802745:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802748:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80274e:	eb 1b                	jmp    80276b <wait+0x3a>
	assert(envid != 0);
  802750:	68 c8 33 80 00       	push   $0x8033c8
  802755:	68 8f 32 80 00       	push   $0x80328f
  80275a:	6a 09                	push   $0x9
  80275c:	68 d3 33 80 00       	push   $0x8033d3
  802761:	e8 90 da ff ff       	call   8001f6 <_panic>
		sys_yield();
  802766:	e8 5f e5 ff ff       	call   800cca <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80276b:	8b 43 48             	mov    0x48(%ebx),%eax
  80276e:	39 f0                	cmp    %esi,%eax
  802770:	75 07                	jne    802779 <wait+0x48>
  802772:	8b 43 54             	mov    0x54(%ebx),%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	75 ed                	jne    802766 <wait+0x35>
}
  802779:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80277c:	5b                   	pop    %ebx
  80277d:	5e                   	pop    %esi
  80277e:	5d                   	pop    %ebp
  80277f:	c3                   	ret    

00802780 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    

0080278a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802790:	68 de 33 80 00       	push   $0x8033de
  802795:	ff 75 0c             	pushl  0xc(%ebp)
  802798:	e8 53 e1 ff ff       	call   8008f0 <strcpy>
	return 0;
}
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <devcons_write>:
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
  8027a7:	57                   	push   %edi
  8027a8:	56                   	push   %esi
  8027a9:	53                   	push   %ebx
  8027aa:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8027b0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8027b5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8027bb:	eb 2f                	jmp    8027ec <devcons_write+0x48>
		m = n - tot;
  8027bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027c0:	29 f3                	sub    %esi,%ebx
  8027c2:	83 fb 7f             	cmp    $0x7f,%ebx
  8027c5:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8027ca:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	53                   	push   %ebx
  8027d1:	89 f0                	mov    %esi,%eax
  8027d3:	03 45 0c             	add    0xc(%ebp),%eax
  8027d6:	50                   	push   %eax
  8027d7:	57                   	push   %edi
  8027d8:	e8 a1 e2 ff ff       	call   800a7e <memmove>
		sys_cputs(buf, m);
  8027dd:	83 c4 08             	add    $0x8,%esp
  8027e0:	53                   	push   %ebx
  8027e1:	57                   	push   %edi
  8027e2:	e8 46 e4 ff ff       	call   800c2d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8027e7:	01 de                	add    %ebx,%esi
  8027e9:	83 c4 10             	add    $0x10,%esp
  8027ec:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027ef:	72 cc                	jb     8027bd <devcons_write+0x19>
}
  8027f1:	89 f0                	mov    %esi,%eax
  8027f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8027f6:	5b                   	pop    %ebx
  8027f7:	5e                   	pop    %esi
  8027f8:	5f                   	pop    %edi
  8027f9:	5d                   	pop    %ebp
  8027fa:	c3                   	ret    

008027fb <devcons_read>:
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 08             	sub    $0x8,%esp
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80280a:	75 07                	jne    802813 <devcons_read+0x18>
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    
		sys_yield();
  80280e:	e8 b7 e4 ff ff       	call   800cca <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802813:	e8 33 e4 ff ff       	call   800c4b <sys_cgetc>
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 f2                	je     80280e <devcons_read+0x13>
	if (c < 0)
  80281c:	85 c0                	test   %eax,%eax
  80281e:	78 ec                	js     80280c <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802820:	83 f8 04             	cmp    $0x4,%eax
  802823:	74 0c                	je     802831 <devcons_read+0x36>
	*(char*)vbuf = c;
  802825:	8b 55 0c             	mov    0xc(%ebp),%edx
  802828:	88 02                	mov    %al,(%edx)
	return 1;
  80282a:	b8 01 00 00 00       	mov    $0x1,%eax
  80282f:	eb db                	jmp    80280c <devcons_read+0x11>
		return 0;
  802831:	b8 00 00 00 00       	mov    $0x0,%eax
  802836:	eb d4                	jmp    80280c <devcons_read+0x11>

00802838 <cputchar>:
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802844:	6a 01                	push   $0x1
  802846:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802849:	50                   	push   %eax
  80284a:	e8 de e3 ff ff       	call   800c2d <sys_cputs>
}
  80284f:	83 c4 10             	add    $0x10,%esp
  802852:	c9                   	leave  
  802853:	c3                   	ret    

00802854 <getchar>:
{
  802854:	55                   	push   %ebp
  802855:	89 e5                	mov    %esp,%ebp
  802857:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80285a:	6a 01                	push   $0x1
  80285c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80285f:	50                   	push   %eax
  802860:	6a 00                	push   $0x0
  802862:	e8 17 ec ff ff       	call   80147e <read>
	if (r < 0)
  802867:	83 c4 10             	add    $0x10,%esp
  80286a:	85 c0                	test   %eax,%eax
  80286c:	78 08                	js     802876 <getchar+0x22>
	if (r < 1)
  80286e:	85 c0                	test   %eax,%eax
  802870:	7e 06                	jle    802878 <getchar+0x24>
	return c;
  802872:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802876:	c9                   	leave  
  802877:	c3                   	ret    
		return -E_EOF;
  802878:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80287d:	eb f7                	jmp    802876 <getchar+0x22>

0080287f <iscons>:
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802885:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802888:	50                   	push   %eax
  802889:	ff 75 08             	pushl  0x8(%ebp)
  80288c:	e8 7c e9 ff ff       	call   80120d <fd_lookup>
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	85 c0                	test   %eax,%eax
  802896:	78 11                	js     8028a9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8028a1:	39 10                	cmp    %edx,(%eax)
  8028a3:	0f 94 c0             	sete   %al
  8028a6:	0f b6 c0             	movzbl %al,%eax
}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <opencons>:
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8028b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b4:	50                   	push   %eax
  8028b5:	e8 04 e9 ff ff       	call   8011be <fd_alloc>
  8028ba:	83 c4 10             	add    $0x10,%esp
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	78 3a                	js     8028fb <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028c1:	83 ec 04             	sub    $0x4,%esp
  8028c4:	68 07 04 00 00       	push   $0x407
  8028c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8028cc:	6a 00                	push   $0x0
  8028ce:	e8 16 e4 ff ff       	call   800ce9 <sys_page_alloc>
  8028d3:	83 c4 10             	add    $0x10,%esp
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	78 21                	js     8028fb <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8028e3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028ef:	83 ec 0c             	sub    $0xc,%esp
  8028f2:	50                   	push   %eax
  8028f3:	e8 9f e8 ff ff       	call   801197 <fd2num>
  8028f8:	83 c4 10             	add    $0x10,%esp
}
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
  802900:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  802903:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  80290a:	74 0a                	je     802916 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802916:	a1 08 50 80 00       	mov    0x805008,%eax
  80291b:	8b 40 48             	mov    0x48(%eax),%eax
  80291e:	83 ec 04             	sub    $0x4,%esp
  802921:	6a 07                	push   $0x7
  802923:	68 00 f0 bf ee       	push   $0xeebff000
  802928:	50                   	push   %eax
  802929:	e8 bb e3 ff ff       	call   800ce9 <sys_page_alloc>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	85 c0                	test   %eax,%eax
  802933:	78 1b                	js     802950 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802935:	a1 08 50 80 00       	mov    0x805008,%eax
  80293a:	8b 40 48             	mov    0x48(%eax),%eax
  80293d:	83 ec 08             	sub    $0x8,%esp
  802940:	68 62 29 80 00       	push   $0x802962
  802945:	50                   	push   %eax
  802946:	e8 e9 e4 ff ff       	call   800e34 <sys_env_set_pgfault_upcall>
  80294b:	83 c4 10             	add    $0x10,%esp
  80294e:	eb bc                	jmp    80290c <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802950:	50                   	push   %eax
  802951:	68 ea 33 80 00       	push   $0x8033ea
  802956:	6a 22                	push   $0x22
  802958:	68 02 34 80 00       	push   $0x803402
  80295d:	e8 94 d8 ff ff       	call   8001f6 <_panic>

00802962 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802962:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802963:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802968:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80296a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  80296d:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802971:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  802974:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802978:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  80297c:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  80297e:	83 c4 08             	add    $0x8,%esp
	popal
  802981:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802982:	83 c4 04             	add    $0x4,%esp
	popfl
  802985:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802986:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802987:	c3                   	ret    

00802988 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802988:	55                   	push   %ebp
  802989:	89 e5                	mov    %esp,%ebp
  80298b:	56                   	push   %esi
  80298c:	53                   	push   %ebx
  80298d:	8b 75 08             	mov    0x8(%ebp),%esi
  802990:	8b 45 0c             	mov    0xc(%ebp),%eax
  802993:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802996:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802998:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80299d:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8029a0:	83 ec 0c             	sub    $0xc,%esp
  8029a3:	50                   	push   %eax
  8029a4:	e8 f0 e4 ff ff       	call   800e99 <sys_ipc_recv>
	if (from_env_store)
  8029a9:	83 c4 10             	add    $0x10,%esp
  8029ac:	85 f6                	test   %esi,%esi
  8029ae:	74 14                	je     8029c4 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8029b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	78 09                	js     8029c2 <ipc_recv+0x3a>
  8029b9:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8029bf:	8b 52 74             	mov    0x74(%edx),%edx
  8029c2:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8029c4:	85 db                	test   %ebx,%ebx
  8029c6:	74 14                	je     8029dc <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8029c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	78 09                	js     8029da <ipc_recv+0x52>
  8029d1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8029d7:	8b 52 78             	mov    0x78(%edx),%edx
  8029da:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	78 08                	js     8029e8 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8029e0:	a1 08 50 80 00       	mov    0x805008,%eax
  8029e5:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8029e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8029eb:	5b                   	pop    %ebx
  8029ec:	5e                   	pop    %esi
  8029ed:	5d                   	pop    %ebp
  8029ee:	c3                   	ret    

008029ef <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
  8029f2:	57                   	push   %edi
  8029f3:	56                   	push   %esi
  8029f4:	53                   	push   %ebx
  8029f5:	83 ec 0c             	sub    $0xc,%esp
  8029f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802a01:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802a03:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802a08:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802a0b:	ff 75 14             	pushl  0x14(%ebp)
  802a0e:	53                   	push   %ebx
  802a0f:	56                   	push   %esi
  802a10:	57                   	push   %edi
  802a11:	e8 60 e4 ff ff       	call   800e76 <sys_ipc_try_send>
		if (ret == 0)
  802a16:	83 c4 10             	add    $0x10,%esp
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 1e                	je     802a3b <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802a1d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a20:	75 07                	jne    802a29 <ipc_send+0x3a>
			sys_yield();
  802a22:	e8 a3 e2 ff ff       	call   800cca <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802a27:	eb e2                	jmp    802a0b <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802a29:	50                   	push   %eax
  802a2a:	68 10 34 80 00       	push   $0x803410
  802a2f:	6a 3d                	push   $0x3d
  802a31:	68 24 34 80 00       	push   $0x803424
  802a36:	e8 bb d7 ff ff       	call   8001f6 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802a3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802a3e:	5b                   	pop    %ebx
  802a3f:	5e                   	pop    %esi
  802a40:	5f                   	pop    %edi
  802a41:	5d                   	pop    %ebp
  802a42:	c3                   	ret    

00802a43 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a49:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a4e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802a51:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a57:	8b 52 50             	mov    0x50(%edx),%edx
  802a5a:	39 ca                	cmp    %ecx,%edx
  802a5c:	74 11                	je     802a6f <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802a5e:	83 c0 01             	add    $0x1,%eax
  802a61:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a66:	75 e6                	jne    802a4e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802a68:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6d:	eb 0b                	jmp    802a7a <ipc_find_env+0x37>
			return envs[i].env_id;
  802a6f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802a72:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802a77:	8b 40 48             	mov    0x48(%eax),%eax
}
  802a7a:	5d                   	pop    %ebp
  802a7b:	c3                   	ret    

00802a7c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a82:	89 d0                	mov    %edx,%eax
  802a84:	c1 e8 16             	shr    $0x16,%eax
  802a87:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802a93:	f6 c1 01             	test   $0x1,%cl
  802a96:	74 1d                	je     802ab5 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802a98:	c1 ea 0c             	shr    $0xc,%edx
  802a9b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802aa2:	f6 c2 01             	test   $0x1,%dl
  802aa5:	74 0e                	je     802ab5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802aa7:	c1 ea 0c             	shr    $0xc,%edx
  802aaa:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ab1:	ef 
  802ab2:	0f b7 c0             	movzwl %ax,%eax
}
  802ab5:	5d                   	pop    %ebp
  802ab6:	c3                   	ret    
  802ab7:	66 90                	xchg   %ax,%ax
  802ab9:	66 90                	xchg   %ax,%ax
  802abb:	66 90                	xchg   %ax,%ax
  802abd:	66 90                	xchg   %ax,%ax
  802abf:	90                   	nop

00802ac0 <__udivdi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	53                   	push   %ebx
  802ac4:	83 ec 1c             	sub    $0x1c,%esp
  802ac7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  802acb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  802acf:	8b 74 24 34          	mov    0x34(%esp),%esi
  802ad3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802ad7:	85 d2                	test   %edx,%edx
  802ad9:	75 35                	jne    802b10 <__udivdi3+0x50>
  802adb:	39 f3                	cmp    %esi,%ebx
  802add:	0f 87 bd 00 00 00    	ja     802ba0 <__udivdi3+0xe0>
  802ae3:	85 db                	test   %ebx,%ebx
  802ae5:	89 d9                	mov    %ebx,%ecx
  802ae7:	75 0b                	jne    802af4 <__udivdi3+0x34>
  802ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  802aee:	31 d2                	xor    %edx,%edx
  802af0:	f7 f3                	div    %ebx
  802af2:	89 c1                	mov    %eax,%ecx
  802af4:	31 d2                	xor    %edx,%edx
  802af6:	89 f0                	mov    %esi,%eax
  802af8:	f7 f1                	div    %ecx
  802afa:	89 c6                	mov    %eax,%esi
  802afc:	89 e8                	mov    %ebp,%eax
  802afe:	89 f7                	mov    %esi,%edi
  802b00:	f7 f1                	div    %ecx
  802b02:	89 fa                	mov    %edi,%edx
  802b04:	83 c4 1c             	add    $0x1c,%esp
  802b07:	5b                   	pop    %ebx
  802b08:	5e                   	pop    %esi
  802b09:	5f                   	pop    %edi
  802b0a:	5d                   	pop    %ebp
  802b0b:	c3                   	ret    
  802b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b10:	39 f2                	cmp    %esi,%edx
  802b12:	77 7c                	ja     802b90 <__udivdi3+0xd0>
  802b14:	0f bd fa             	bsr    %edx,%edi
  802b17:	83 f7 1f             	xor    $0x1f,%edi
  802b1a:	0f 84 98 00 00 00    	je     802bb8 <__udivdi3+0xf8>
  802b20:	89 f9                	mov    %edi,%ecx
  802b22:	b8 20 00 00 00       	mov    $0x20,%eax
  802b27:	29 f8                	sub    %edi,%eax
  802b29:	d3 e2                	shl    %cl,%edx
  802b2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b2f:	89 c1                	mov    %eax,%ecx
  802b31:	89 da                	mov    %ebx,%edx
  802b33:	d3 ea                	shr    %cl,%edx
  802b35:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802b39:	09 d1                	or     %edx,%ecx
  802b3b:	89 f2                	mov    %esi,%edx
  802b3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b41:	89 f9                	mov    %edi,%ecx
  802b43:	d3 e3                	shl    %cl,%ebx
  802b45:	89 c1                	mov    %eax,%ecx
  802b47:	d3 ea                	shr    %cl,%edx
  802b49:	89 f9                	mov    %edi,%ecx
  802b4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802b4f:	d3 e6                	shl    %cl,%esi
  802b51:	89 eb                	mov    %ebp,%ebx
  802b53:	89 c1                	mov    %eax,%ecx
  802b55:	d3 eb                	shr    %cl,%ebx
  802b57:	09 de                	or     %ebx,%esi
  802b59:	89 f0                	mov    %esi,%eax
  802b5b:	f7 74 24 08          	divl   0x8(%esp)
  802b5f:	89 d6                	mov    %edx,%esi
  802b61:	89 c3                	mov    %eax,%ebx
  802b63:	f7 64 24 0c          	mull   0xc(%esp)
  802b67:	39 d6                	cmp    %edx,%esi
  802b69:	72 0c                	jb     802b77 <__udivdi3+0xb7>
  802b6b:	89 f9                	mov    %edi,%ecx
  802b6d:	d3 e5                	shl    %cl,%ebp
  802b6f:	39 c5                	cmp    %eax,%ebp
  802b71:	73 5d                	jae    802bd0 <__udivdi3+0x110>
  802b73:	39 d6                	cmp    %edx,%esi
  802b75:	75 59                	jne    802bd0 <__udivdi3+0x110>
  802b77:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802b7a:	31 ff                	xor    %edi,%edi
  802b7c:	89 fa                	mov    %edi,%edx
  802b7e:	83 c4 1c             	add    $0x1c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	8d 76 00             	lea    0x0(%esi),%esi
  802b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802b90:	31 ff                	xor    %edi,%edi
  802b92:	31 c0                	xor    %eax,%eax
  802b94:	89 fa                	mov    %edi,%edx
  802b96:	83 c4 1c             	add    $0x1c,%esp
  802b99:	5b                   	pop    %ebx
  802b9a:	5e                   	pop    %esi
  802b9b:	5f                   	pop    %edi
  802b9c:	5d                   	pop    %ebp
  802b9d:	c3                   	ret    
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	31 ff                	xor    %edi,%edi
  802ba2:	89 e8                	mov    %ebp,%eax
  802ba4:	89 f2                	mov    %esi,%edx
  802ba6:	f7 f3                	div    %ebx
  802ba8:	89 fa                	mov    %edi,%edx
  802baa:	83 c4 1c             	add    $0x1c,%esp
  802bad:	5b                   	pop    %ebx
  802bae:	5e                   	pop    %esi
  802baf:	5f                   	pop    %edi
  802bb0:	5d                   	pop    %ebp
  802bb1:	c3                   	ret    
  802bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bb8:	39 f2                	cmp    %esi,%edx
  802bba:	72 06                	jb     802bc2 <__udivdi3+0x102>
  802bbc:	31 c0                	xor    %eax,%eax
  802bbe:	39 eb                	cmp    %ebp,%ebx
  802bc0:	77 d2                	ja     802b94 <__udivdi3+0xd4>
  802bc2:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc7:	eb cb                	jmp    802b94 <__udivdi3+0xd4>
  802bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802bd0:	89 d8                	mov    %ebx,%eax
  802bd2:	31 ff                	xor    %edi,%edi
  802bd4:	eb be                	jmp    802b94 <__udivdi3+0xd4>
  802bd6:	66 90                	xchg   %ax,%ax
  802bd8:	66 90                	xchg   %ax,%ax
  802bda:	66 90                	xchg   %ax,%ax
  802bdc:	66 90                	xchg   %ax,%ax
  802bde:	66 90                	xchg   %ax,%ax

00802be0 <__umoddi3>:
  802be0:	55                   	push   %ebp
  802be1:	57                   	push   %edi
  802be2:	56                   	push   %esi
  802be3:	53                   	push   %ebx
  802be4:	83 ec 1c             	sub    $0x1c,%esp
  802be7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  802beb:	8b 74 24 30          	mov    0x30(%esp),%esi
  802bef:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802bf3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802bf7:	85 ed                	test   %ebp,%ebp
  802bf9:	89 f0                	mov    %esi,%eax
  802bfb:	89 da                	mov    %ebx,%edx
  802bfd:	75 19                	jne    802c18 <__umoddi3+0x38>
  802bff:	39 df                	cmp    %ebx,%edi
  802c01:	0f 86 b1 00 00 00    	jbe    802cb8 <__umoddi3+0xd8>
  802c07:	f7 f7                	div    %edi
  802c09:	89 d0                	mov    %edx,%eax
  802c0b:	31 d2                	xor    %edx,%edx
  802c0d:	83 c4 1c             	add    $0x1c,%esp
  802c10:	5b                   	pop    %ebx
  802c11:	5e                   	pop    %esi
  802c12:	5f                   	pop    %edi
  802c13:	5d                   	pop    %ebp
  802c14:	c3                   	ret    
  802c15:	8d 76 00             	lea    0x0(%esi),%esi
  802c18:	39 dd                	cmp    %ebx,%ebp
  802c1a:	77 f1                	ja     802c0d <__umoddi3+0x2d>
  802c1c:	0f bd cd             	bsr    %ebp,%ecx
  802c1f:	83 f1 1f             	xor    $0x1f,%ecx
  802c22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802c26:	0f 84 b4 00 00 00    	je     802ce0 <__umoddi3+0x100>
  802c2c:	b8 20 00 00 00       	mov    $0x20,%eax
  802c31:	89 c2                	mov    %eax,%edx
  802c33:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c37:	29 c2                	sub    %eax,%edx
  802c39:	89 c1                	mov    %eax,%ecx
  802c3b:	89 f8                	mov    %edi,%eax
  802c3d:	d3 e5                	shl    %cl,%ebp
  802c3f:	89 d1                	mov    %edx,%ecx
  802c41:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802c45:	d3 e8                	shr    %cl,%eax
  802c47:	09 c5                	or     %eax,%ebp
  802c49:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c4d:	89 c1                	mov    %eax,%ecx
  802c4f:	d3 e7                	shl    %cl,%edi
  802c51:	89 d1                	mov    %edx,%ecx
  802c53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c57:	89 df                	mov    %ebx,%edi
  802c59:	d3 ef                	shr    %cl,%edi
  802c5b:	89 c1                	mov    %eax,%ecx
  802c5d:	89 f0                	mov    %esi,%eax
  802c5f:	d3 e3                	shl    %cl,%ebx
  802c61:	89 d1                	mov    %edx,%ecx
  802c63:	89 fa                	mov    %edi,%edx
  802c65:	d3 e8                	shr    %cl,%eax
  802c67:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  802c6c:	09 d8                	or     %ebx,%eax
  802c6e:	f7 f5                	div    %ebp
  802c70:	d3 e6                	shl    %cl,%esi
  802c72:	89 d1                	mov    %edx,%ecx
  802c74:	f7 64 24 08          	mull   0x8(%esp)
  802c78:	39 d1                	cmp    %edx,%ecx
  802c7a:	89 c3                	mov    %eax,%ebx
  802c7c:	89 d7                	mov    %edx,%edi
  802c7e:	72 06                	jb     802c86 <__umoddi3+0xa6>
  802c80:	75 0e                	jne    802c90 <__umoddi3+0xb0>
  802c82:	39 c6                	cmp    %eax,%esi
  802c84:	73 0a                	jae    802c90 <__umoddi3+0xb0>
  802c86:	2b 44 24 08          	sub    0x8(%esp),%eax
  802c8a:	19 ea                	sbb    %ebp,%edx
  802c8c:	89 d7                	mov    %edx,%edi
  802c8e:	89 c3                	mov    %eax,%ebx
  802c90:	89 ca                	mov    %ecx,%edx
  802c92:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802c97:	29 de                	sub    %ebx,%esi
  802c99:	19 fa                	sbb    %edi,%edx
  802c9b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802c9f:	89 d0                	mov    %edx,%eax
  802ca1:	d3 e0                	shl    %cl,%eax
  802ca3:	89 d9                	mov    %ebx,%ecx
  802ca5:	d3 ee                	shr    %cl,%esi
  802ca7:	d3 ea                	shr    %cl,%edx
  802ca9:	09 f0                	or     %esi,%eax
  802cab:	83 c4 1c             	add    $0x1c,%esp
  802cae:	5b                   	pop    %ebx
  802caf:	5e                   	pop    %esi
  802cb0:	5f                   	pop    %edi
  802cb1:	5d                   	pop    %ebp
  802cb2:	c3                   	ret    
  802cb3:	90                   	nop
  802cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	85 ff                	test   %edi,%edi
  802cba:	89 f9                	mov    %edi,%ecx
  802cbc:	75 0b                	jne    802cc9 <__umoddi3+0xe9>
  802cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  802cc3:	31 d2                	xor    %edx,%edx
  802cc5:	f7 f7                	div    %edi
  802cc7:	89 c1                	mov    %eax,%ecx
  802cc9:	89 d8                	mov    %ebx,%eax
  802ccb:	31 d2                	xor    %edx,%edx
  802ccd:	f7 f1                	div    %ecx
  802ccf:	89 f0                	mov    %esi,%eax
  802cd1:	f7 f1                	div    %ecx
  802cd3:	e9 31 ff ff ff       	jmp    802c09 <__umoddi3+0x29>
  802cd8:	90                   	nop
  802cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ce0:	39 dd                	cmp    %ebx,%ebp
  802ce2:	72 08                	jb     802cec <__umoddi3+0x10c>
  802ce4:	39 f7                	cmp    %esi,%edi
  802ce6:	0f 87 21 ff ff ff    	ja     802c0d <__umoddi3+0x2d>
  802cec:	89 da                	mov    %ebx,%edx
  802cee:	89 f0                	mov    %esi,%eax
  802cf0:	29 f8                	sub    %edi,%eax
  802cf2:	19 ea                	sbb    %ebp,%edx
  802cf4:	e9 14 ff ff ff       	jmp    802c0d <__umoddi3+0x2d>

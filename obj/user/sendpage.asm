
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 6e 01 00 00       	call   80019f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 57 0f 00 00       	call   800f95 <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 9e 00 00 00    	jne    8000e7 <umain+0xb4>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	68 00 00 b0 00       	push   $0xb00000
  800053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 fe 10 00 00       	call   80115a <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	68 00 00 b0 00       	push   $0xb00000
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 c0 26 80 00       	push   $0x8026c0
  80006c:	e8 23 02 00 00       	call   800294 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800071:	83 c4 04             	add    $0x4,%esp
  800074:	ff 35 04 30 80 00    	pushl  0x803004
  80007a:	e8 fd 07 00 00       	call   80087c <strlen>
  80007f:	83 c4 0c             	add    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	ff 35 04 30 80 00    	pushl  0x803004
  800089:	68 00 00 b0 00       	push   $0xb00000
  80008e:	e8 ec 08 00 00       	call   80097f <strncmp>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	74 3b                	je     8000d5 <umain+0xa2>
			cprintf("child received correct message\n");

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 35 00 30 80 00    	pushl  0x803000
  8000a3:	e8 d4 07 00 00       	call   80087c <strlen>
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	83 c0 01             	add    $0x1,%eax
  8000ae:	50                   	push   %eax
  8000af:	ff 35 00 30 80 00    	pushl  0x803000
  8000b5:	68 00 00 b0 00       	push   $0xb00000
  8000ba:	e8 ea 09 00 00       	call   800aa9 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000bf:	6a 07                	push   $0x7
  8000c1:	68 00 00 b0 00       	push   $0xb00000
  8000c6:	6a 00                	push   $0x0
  8000c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8000cb:	e8 f1 10 00 00       	call   8011c1 <ipc_send>
		return;
  8000d0:	83 c4 20             	add    $0x20,%esp
	ipc_recv(&who, TEMP_ADDR, 0);
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
		cprintf("parent received correct message\n");
	return;
}
  8000d3:	c9                   	leave  
  8000d4:	c3                   	ret    
			cprintf("child received correct message\n");
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 d4 26 80 00       	push   $0x8026d4
  8000dd:	e8 b2 01 00 00       	call   800294 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	eb b3                	jmp    80009a <umain+0x67>
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ec:	8b 40 48             	mov    0x48(%eax),%eax
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	6a 07                	push   $0x7
  8000f4:	68 00 00 a0 00       	push   $0xa00000
  8000f9:	50                   	push   %eax
  8000fa:	e8 ad 0b 00 00       	call   800cac <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8000ff:	83 c4 04             	add    $0x4,%esp
  800102:	ff 35 04 30 80 00    	pushl  0x803004
  800108:	e8 6f 07 00 00       	call   80087c <strlen>
  80010d:	83 c4 0c             	add    $0xc,%esp
  800110:	83 c0 01             	add    $0x1,%eax
  800113:	50                   	push   %eax
  800114:	ff 35 04 30 80 00    	pushl  0x803004
  80011a:	68 00 00 a0 00       	push   $0xa00000
  80011f:	e8 85 09 00 00       	call   800aa9 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800124:	6a 07                	push   $0x7
  800126:	68 00 00 a0 00       	push   $0xa00000
  80012b:	6a 00                	push   $0x0
  80012d:	ff 75 f4             	pushl  -0xc(%ebp)
  800130:	e8 8c 10 00 00       	call   8011c1 <ipc_send>
	ipc_recv(&who, TEMP_ADDR, 0);
  800135:	83 c4 1c             	add    $0x1c,%esp
  800138:	6a 00                	push   $0x0
  80013a:	68 00 00 a0 00       	push   $0xa00000
  80013f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800142:	50                   	push   %eax
  800143:	e8 12 10 00 00       	call   80115a <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  800148:	83 c4 0c             	add    $0xc,%esp
  80014b:	68 00 00 a0 00       	push   $0xa00000
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	68 c0 26 80 00       	push   $0x8026c0
  800158:	e8 37 01 00 00       	call   800294 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  80015d:	83 c4 04             	add    $0x4,%esp
  800160:	ff 35 00 30 80 00    	pushl  0x803000
  800166:	e8 11 07 00 00       	call   80087c <strlen>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 35 00 30 80 00    	pushl  0x803000
  800175:	68 00 00 a0 00       	push   $0xa00000
  80017a:	e8 00 08 00 00       	call   80097f <strncmp>
  80017f:	83 c4 10             	add    $0x10,%esp
  800182:	85 c0                	test   %eax,%eax
  800184:	0f 85 49 ff ff ff    	jne    8000d3 <umain+0xa0>
		cprintf("parent received correct message\n");
  80018a:	83 ec 0c             	sub    $0xc,%esp
  80018d:	68 f4 26 80 00       	push   $0x8026f4
  800192:	e8 fd 00 00 00       	call   800294 <cprintf>
  800197:	83 c4 10             	add    $0x10,%esp
  80019a:	e9 34 ff ff ff       	jmp    8000d3 <umain+0xa0>

0080019f <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	56                   	push   %esi
  8001a3:	53                   	push   %ebx
  8001a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001aa:	e8 bf 0a 00 00       	call   800c6e <sys_getenvid>
  8001af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bc:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c1:	85 db                	test   %ebx,%ebx
  8001c3:	7e 07                	jle    8001cc <libmain+0x2d>
		binaryname = argv[0];
  8001c5:	8b 06                	mov    (%esi),%eax
  8001c7:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	e8 5d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001d6:	e8 0a 00 00 00       	call   8001e5 <exit>
}
  8001db:	83 c4 10             	add    $0x10,%esp
  8001de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e1:	5b                   	pop    %ebx
  8001e2:	5e                   	pop    %esi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001eb:	e8 34 12 00 00       	call   801424 <close_all>
	sys_env_destroy(0);
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	6a 00                	push   $0x0
  8001f5:	e8 33 0a 00 00       	call   800c2d <sys_env_destroy>
}
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 04             	sub    $0x4,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	74 09                	je     800227 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80021e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800225:	c9                   	leave  
  800226:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800227:	83 ec 08             	sub    $0x8,%esp
  80022a:	68 ff 00 00 00       	push   $0xff
  80022f:	8d 43 08             	lea    0x8(%ebx),%eax
  800232:	50                   	push   %eax
  800233:	e8 b8 09 00 00       	call   800bf0 <sys_cputs>
		b->idx = 0;
  800238:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023e:	83 c4 10             	add    $0x10,%esp
  800241:	eb db                	jmp    80021e <putch+0x1f>

00800243 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800253:	00 00 00 
	b.cnt = 0;
  800256:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800260:	ff 75 0c             	pushl  0xc(%ebp)
  800263:	ff 75 08             	pushl  0x8(%ebp)
  800266:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026c:	50                   	push   %eax
  80026d:	68 ff 01 80 00       	push   $0x8001ff
  800272:	e8 1a 01 00 00       	call   800391 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800277:	83 c4 08             	add    $0x8,%esp
  80027a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800280:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	e8 64 09 00 00       	call   800bf0 <sys_cputs>

	return b.cnt;
}
  80028c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800292:	c9                   	leave  
  800293:	c3                   	ret    

00800294 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029d:	50                   	push   %eax
  80029e:	ff 75 08             	pushl  0x8(%ebp)
  8002a1:	e8 9d ff ff ff       	call   800243 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	57                   	push   %edi
  8002ac:	56                   	push   %esi
  8002ad:	53                   	push   %ebx
  8002ae:	83 ec 1c             	sub    $0x1c,%esp
  8002b1:	89 c7                	mov    %eax,%edi
  8002b3:	89 d6                	mov    %edx,%esi
  8002b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002be:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002cc:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002cf:	39 d3                	cmp    %edx,%ebx
  8002d1:	72 05                	jb     8002d8 <printnum+0x30>
  8002d3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002d6:	77 7a                	ja     800352 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d8:	83 ec 0c             	sub    $0xc,%esp
  8002db:	ff 75 18             	pushl  0x18(%ebp)
  8002de:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e4:	53                   	push   %ebx
  8002e5:	ff 75 10             	pushl  0x10(%ebp)
  8002e8:	83 ec 08             	sub    $0x8,%esp
  8002eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f7:	e8 84 21 00 00       	call   802480 <__udivdi3>
  8002fc:	83 c4 18             	add    $0x18,%esp
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	89 f2                	mov    %esi,%edx
  800303:	89 f8                	mov    %edi,%eax
  800305:	e8 9e ff ff ff       	call   8002a8 <printnum>
  80030a:	83 c4 20             	add    $0x20,%esp
  80030d:	eb 13                	jmp    800322 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	56                   	push   %esi
  800313:	ff 75 18             	pushl  0x18(%ebp)
  800316:	ff d7                	call   *%edi
  800318:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031b:	83 eb 01             	sub    $0x1,%ebx
  80031e:	85 db                	test   %ebx,%ebx
  800320:	7f ed                	jg     80030f <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	56                   	push   %esi
  800326:	83 ec 04             	sub    $0x4,%esp
  800329:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032c:	ff 75 e0             	pushl  -0x20(%ebp)
  80032f:	ff 75 dc             	pushl  -0x24(%ebp)
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 66 22 00 00       	call   8025a0 <__umoddi3>
  80033a:	83 c4 14             	add    $0x14,%esp
  80033d:	0f be 80 6c 27 80 00 	movsbl 0x80276c(%eax),%eax
  800344:	50                   	push   %eax
  800345:	ff d7                	call   *%edi
}
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034d:	5b                   	pop    %ebx
  80034e:	5e                   	pop    %esi
  80034f:	5f                   	pop    %edi
  800350:	5d                   	pop    %ebp
  800351:	c3                   	ret    
  800352:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800355:	eb c4                	jmp    80031b <printnum+0x73>

00800357 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800361:	8b 10                	mov    (%eax),%edx
  800363:	3b 50 04             	cmp    0x4(%eax),%edx
  800366:	73 0a                	jae    800372 <sprintputch+0x1b>
		*b->buf++ = ch;
  800368:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036b:	89 08                	mov    %ecx,(%eax)
  80036d:	8b 45 08             	mov    0x8(%ebp),%eax
  800370:	88 02                	mov    %al,(%edx)
}
  800372:	5d                   	pop    %ebp
  800373:	c3                   	ret    

00800374 <printfmt>:
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80037a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037d:	50                   	push   %eax
  80037e:	ff 75 10             	pushl  0x10(%ebp)
  800381:	ff 75 0c             	pushl  0xc(%ebp)
  800384:	ff 75 08             	pushl  0x8(%ebp)
  800387:	e8 05 00 00 00       	call   800391 <vprintfmt>
}
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	c9                   	leave  
  800390:	c3                   	ret    

00800391 <vprintfmt>:
{
  800391:	55                   	push   %ebp
  800392:	89 e5                	mov    %esp,%ebp
  800394:	57                   	push   %edi
  800395:	56                   	push   %esi
  800396:	53                   	push   %ebx
  800397:	83 ec 2c             	sub    $0x2c,%esp
  80039a:	8b 75 08             	mov    0x8(%ebp),%esi
  80039d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003a0:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a3:	e9 c1 03 00 00       	jmp    800769 <vprintfmt+0x3d8>
		padc = ' ';
  8003a8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  8003ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  8003b3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  8003ba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003c1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8d 47 01             	lea    0x1(%edi),%eax
  8003c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003cc:	0f b6 17             	movzbl (%edi),%edx
  8003cf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003d2:	3c 55                	cmp    $0x55,%al
  8003d4:	0f 87 12 04 00 00    	ja     8007ec <vprintfmt+0x45b>
  8003da:	0f b6 c0             	movzbl %al,%eax
  8003dd:	ff 24 85 a0 28 80 00 	jmp    *0x8028a0(,%eax,4)
  8003e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003eb:	eb d9                	jmp    8003c6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003f0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f4:	eb d0                	jmp    8003c6 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	0f b6 d2             	movzbl %dl,%edx
  8003f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003fc:	b8 00 00 00 00       	mov    $0x0,%eax
  800401:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800404:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800407:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80040b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800411:	83 f9 09             	cmp    $0x9,%ecx
  800414:	77 55                	ja     80046b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800416:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800419:	eb e9                	jmp    800404 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80041b:	8b 45 14             	mov    0x14(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800423:	8b 45 14             	mov    0x14(%ebp),%eax
  800426:	8d 40 04             	lea    0x4(%eax),%eax
  800429:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80042c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800433:	79 91                	jns    8003c6 <vprintfmt+0x35>
				width = precision, precision = -1;
  800435:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800438:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80043b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800442:	eb 82                	jmp    8003c6 <vprintfmt+0x35>
  800444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800447:	85 c0                	test   %eax,%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	0f 49 d0             	cmovns %eax,%edx
  800451:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800457:	e9 6a ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
  80045c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800466:	e9 5b ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
  80046b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800471:	eb bc                	jmp    80042f <vprintfmt+0x9e>
			lflag++;
  800473:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800476:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800479:	e9 48 ff ff ff       	jmp    8003c6 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80047e:	8b 45 14             	mov    0x14(%ebp),%eax
  800481:	8d 78 04             	lea    0x4(%eax),%edi
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	53                   	push   %ebx
  800488:	ff 30                	pushl  (%eax)
  80048a:	ff d6                	call   *%esi
			break;
  80048c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80048f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800492:	e9 cf 02 00 00       	jmp    800766 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800497:	8b 45 14             	mov    0x14(%ebp),%eax
  80049a:	8d 78 04             	lea    0x4(%eax),%edi
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	99                   	cltd   
  8004a0:	31 d0                	xor    %edx,%eax
  8004a2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004a4:	83 f8 0f             	cmp    $0xf,%eax
  8004a7:	7f 23                	jg     8004cc <vprintfmt+0x13b>
  8004a9:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  8004b0:	85 d2                	test   %edx,%edx
  8004b2:	74 18                	je     8004cc <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  8004b4:	52                   	push   %edx
  8004b5:	68 3d 2c 80 00       	push   $0x802c3d
  8004ba:	53                   	push   %ebx
  8004bb:	56                   	push   %esi
  8004bc:	e8 b3 fe ff ff       	call   800374 <printfmt>
  8004c1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004c4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c7:	e9 9a 02 00 00       	jmp    800766 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  8004cc:	50                   	push   %eax
  8004cd:	68 84 27 80 00       	push   $0x802784
  8004d2:	53                   	push   %ebx
  8004d3:	56                   	push   %esi
  8004d4:	e8 9b fe ff ff       	call   800374 <printfmt>
  8004d9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004dc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004df:	e9 82 02 00 00       	jmp    800766 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e7:	83 c0 04             	add    $0x4,%eax
  8004ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8004f2:	85 ff                	test   %edi,%edi
  8004f4:	b8 7d 27 80 00       	mov    $0x80277d,%eax
  8004f9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8004fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800500:	0f 8e bd 00 00 00    	jle    8005c3 <vprintfmt+0x232>
  800506:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80050a:	75 0e                	jne    80051a <vprintfmt+0x189>
  80050c:	89 75 08             	mov    %esi,0x8(%ebp)
  80050f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800512:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800515:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800518:	eb 6d                	jmp    800587 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	ff 75 d0             	pushl  -0x30(%ebp)
  800520:	57                   	push   %edi
  800521:	e8 6e 03 00 00       	call   800894 <strnlen>
  800526:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800529:	29 c1                	sub    %eax,%ecx
  80052b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80052e:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800531:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800538:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80053b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053d:	eb 0f                	jmp    80054e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	53                   	push   %ebx
  800543:	ff 75 e0             	pushl  -0x20(%ebp)
  800546:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800548:	83 ef 01             	sub    $0x1,%edi
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	85 ff                	test   %edi,%edi
  800550:	7f ed                	jg     80053f <vprintfmt+0x1ae>
  800552:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800555:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800558:	85 c9                	test   %ecx,%ecx
  80055a:	b8 00 00 00 00       	mov    $0x0,%eax
  80055f:	0f 49 c1             	cmovns %ecx,%eax
  800562:	29 c1                	sub    %eax,%ecx
  800564:	89 75 08             	mov    %esi,0x8(%ebp)
  800567:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80056a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80056d:	89 cb                	mov    %ecx,%ebx
  80056f:	eb 16                	jmp    800587 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800571:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800575:	75 31                	jne    8005a8 <vprintfmt+0x217>
					putch(ch, putdat);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 0c             	pushl  0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	ff 55 08             	call   *0x8(%ebp)
  800581:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800584:	83 eb 01             	sub    $0x1,%ebx
  800587:	83 c7 01             	add    $0x1,%edi
  80058a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80058e:	0f be c2             	movsbl %dl,%eax
  800591:	85 c0                	test   %eax,%eax
  800593:	74 59                	je     8005ee <vprintfmt+0x25d>
  800595:	85 f6                	test   %esi,%esi
  800597:	78 d8                	js     800571 <vprintfmt+0x1e0>
  800599:	83 ee 01             	sub    $0x1,%esi
  80059c:	79 d3                	jns    800571 <vprintfmt+0x1e0>
  80059e:	89 df                	mov    %ebx,%edi
  8005a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005a6:	eb 37                	jmp    8005df <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  8005a8:	0f be d2             	movsbl %dl,%edx
  8005ab:	83 ea 20             	sub    $0x20,%edx
  8005ae:	83 fa 5e             	cmp    $0x5e,%edx
  8005b1:	76 c4                	jbe    800577 <vprintfmt+0x1e6>
					putch('?', putdat);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 0c             	pushl  0xc(%ebp)
  8005b9:	6a 3f                	push   $0x3f
  8005bb:	ff 55 08             	call   *0x8(%ebp)
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	eb c1                	jmp    800584 <vprintfmt+0x1f3>
  8005c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005c9:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8005cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005cf:	eb b6                	jmp    800587 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8005d1:	83 ec 08             	sub    $0x8,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	6a 20                	push   $0x20
  8005d7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005d9:	83 ef 01             	sub    $0x1,%edi
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	85 ff                	test   %edi,%edi
  8005e1:	7f ee                	jg     8005d1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8005e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	e9 78 01 00 00       	jmp    800766 <vprintfmt+0x3d5>
  8005ee:	89 df                	mov    %ebx,%edi
  8005f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8005f6:	eb e7                	jmp    8005df <vprintfmt+0x24e>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 3f                	jle    80063c <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 50 04             	mov    0x4(%eax),%edx
  800603:	8b 00                	mov    (%eax),%eax
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 40 08             	lea    0x8(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800614:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800618:	79 5c                	jns    800676 <vprintfmt+0x2e5>
				putch('-', putdat);
  80061a:	83 ec 08             	sub    $0x8,%esp
  80061d:	53                   	push   %ebx
  80061e:	6a 2d                	push   $0x2d
  800620:	ff d6                	call   *%esi
				num = -(long long) num;
  800622:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800625:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800628:	f7 da                	neg    %edx
  80062a:	83 d1 00             	adc    $0x0,%ecx
  80062d:	f7 d9                	neg    %ecx
  80062f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800632:	b8 0a 00 00 00       	mov    $0xa,%eax
  800637:	e9 10 01 00 00       	jmp    80074c <vprintfmt+0x3bb>
	else if (lflag)
  80063c:	85 c9                	test   %ecx,%ecx
  80063e:	75 1b                	jne    80065b <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800648:	89 c1                	mov    %eax,%ecx
  80064a:	c1 f9 1f             	sar    $0x1f,%ecx
  80064d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800650:	8b 45 14             	mov    0x14(%ebp),%eax
  800653:	8d 40 04             	lea    0x4(%eax),%eax
  800656:	89 45 14             	mov    %eax,0x14(%ebp)
  800659:	eb b9                	jmp    800614 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800663:	89 c1                	mov    %eax,%ecx
  800665:	c1 f9 1f             	sar    $0x1f,%ecx
  800668:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
  800674:	eb 9e                	jmp    800614 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800676:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800679:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80067c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800681:	e9 c6 00 00 00       	jmp    80074c <vprintfmt+0x3bb>
	if (lflag >= 2)
  800686:	83 f9 01             	cmp    $0x1,%ecx
  800689:	7e 18                	jle    8006a3 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8b 48 04             	mov    0x4(%eax),%ecx
  800693:	8d 40 08             	lea    0x8(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800699:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069e:	e9 a9 00 00 00       	jmp    80074c <vprintfmt+0x3bb>
	else if (lflag)
  8006a3:	85 c9                	test   %ecx,%ecx
  8006a5:	75 1a                	jne    8006c1 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b1:	8d 40 04             	lea    0x4(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bc:	e9 8b 00 00 00       	jmp    80074c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 10                	mov    (%eax),%edx
  8006c6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cb:	8d 40 04             	lea    0x4(%eax),%eax
  8006ce:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006d6:	eb 74                	jmp    80074c <vprintfmt+0x3bb>
	if (lflag >= 2)
  8006d8:	83 f9 01             	cmp    $0x1,%ecx
  8006db:	7e 15                	jle    8006f2 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8b 10                	mov    (%eax),%edx
  8006e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e5:	8d 40 08             	lea    0x8(%eax),%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f0:	eb 5a                	jmp    80074c <vprintfmt+0x3bb>
	else if (lflag)
  8006f2:	85 c9                	test   %ecx,%ecx
  8006f4:	75 17                	jne    80070d <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800706:	b8 08 00 00 00       	mov    $0x8,%eax
  80070b:	eb 3f                	jmp    80074c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80070d:	8b 45 14             	mov    0x14(%ebp),%eax
  800710:	8b 10                	mov    (%eax),%edx
  800712:	b9 00 00 00 00       	mov    $0x0,%ecx
  800717:	8d 40 04             	lea    0x4(%eax),%eax
  80071a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80071d:	b8 08 00 00 00       	mov    $0x8,%eax
  800722:	eb 28                	jmp    80074c <vprintfmt+0x3bb>
			putch('0', putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	6a 30                	push   $0x30
  80072a:	ff d6                	call   *%esi
			putch('x', putdat);
  80072c:	83 c4 08             	add    $0x8,%esp
  80072f:	53                   	push   %ebx
  800730:	6a 78                	push   $0x78
  800732:	ff d6                	call   *%esi
			num = (unsigned long long)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80073e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800741:	8d 40 04             	lea    0x4(%eax),%eax
  800744:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800747:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800753:	57                   	push   %edi
  800754:	ff 75 e0             	pushl  -0x20(%ebp)
  800757:	50                   	push   %eax
  800758:	51                   	push   %ecx
  800759:	52                   	push   %edx
  80075a:	89 da                	mov    %ebx,%edx
  80075c:	89 f0                	mov    %esi,%eax
  80075e:	e8 45 fb ff ff       	call   8002a8 <printnum>
			break;
  800763:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800766:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800769:	83 c7 01             	add    $0x1,%edi
  80076c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800770:	83 f8 25             	cmp    $0x25,%eax
  800773:	0f 84 2f fc ff ff    	je     8003a8 <vprintfmt+0x17>
			if (ch == '\0')
  800779:	85 c0                	test   %eax,%eax
  80077b:	0f 84 8b 00 00 00    	je     80080c <vprintfmt+0x47b>
			putch(ch, putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	53                   	push   %ebx
  800785:	50                   	push   %eax
  800786:	ff d6                	call   *%esi
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	eb dc                	jmp    800769 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80078d:	83 f9 01             	cmp    $0x1,%ecx
  800790:	7e 15                	jle    8007a7 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 10                	mov    (%eax),%edx
  800797:	8b 48 04             	mov    0x4(%eax),%ecx
  80079a:	8d 40 08             	lea    0x8(%eax),%eax
  80079d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a5:	eb a5                	jmp    80074c <vprintfmt+0x3bb>
	else if (lflag)
  8007a7:	85 c9                	test   %ecx,%ecx
  8007a9:	75 17                	jne    8007c2 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 10                	mov    (%eax),%edx
  8007b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b5:	8d 40 04             	lea    0x4(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c0:	eb 8a                	jmp    80074c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8b 10                	mov    (%eax),%edx
  8007c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007cc:	8d 40 04             	lea    0x4(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d2:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d7:	e9 70 ff ff ff       	jmp    80074c <vprintfmt+0x3bb>
			putch(ch, putdat);
  8007dc:	83 ec 08             	sub    $0x8,%esp
  8007df:	53                   	push   %ebx
  8007e0:	6a 25                	push   $0x25
  8007e2:	ff d6                	call   *%esi
			break;
  8007e4:	83 c4 10             	add    $0x10,%esp
  8007e7:	e9 7a ff ff ff       	jmp    800766 <vprintfmt+0x3d5>
			putch('%', putdat);
  8007ec:	83 ec 08             	sub    $0x8,%esp
  8007ef:	53                   	push   %ebx
  8007f0:	6a 25                	push   $0x25
  8007f2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	89 f8                	mov    %edi,%eax
  8007f9:	eb 03                	jmp    8007fe <vprintfmt+0x46d>
  8007fb:	83 e8 01             	sub    $0x1,%eax
  8007fe:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800802:	75 f7                	jne    8007fb <vprintfmt+0x46a>
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	e9 5a ff ff ff       	jmp    800766 <vprintfmt+0x3d5>
}
  80080c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80080f:	5b                   	pop    %ebx
  800810:	5e                   	pop    %esi
  800811:	5f                   	pop    %edi
  800812:	5d                   	pop    %ebp
  800813:	c3                   	ret    

00800814 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 18             	sub    $0x18,%esp
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800823:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800827:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80082a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800831:	85 c0                	test   %eax,%eax
  800833:	74 26                	je     80085b <vsnprintf+0x47>
  800835:	85 d2                	test   %edx,%edx
  800837:	7e 22                	jle    80085b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800839:	ff 75 14             	pushl  0x14(%ebp)
  80083c:	ff 75 10             	pushl  0x10(%ebp)
  80083f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800842:	50                   	push   %eax
  800843:	68 57 03 80 00       	push   $0x800357
  800848:	e8 44 fb ff ff       	call   800391 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80084d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800850:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	83 c4 10             	add    $0x10,%esp
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    
		return -E_INVAL;
  80085b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800860:	eb f7                	jmp    800859 <vsnprintf+0x45>

00800862 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800868:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80086b:	50                   	push   %eax
  80086c:	ff 75 10             	pushl  0x10(%ebp)
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	ff 75 08             	pushl  0x8(%ebp)
  800875:	e8 9a ff ff ff       	call   800814 <vsnprintf>
	va_end(ap);

	return rc;
}
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
  800887:	eb 03                	jmp    80088c <strlen+0x10>
		n++;
  800889:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80088c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800890:	75 f7                	jne    800889 <strlen+0xd>
	return n;
}
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089d:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a2:	eb 03                	jmp    8008a7 <strnlen+0x13>
		n++;
  8008a4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008a7:	39 d0                	cmp    %edx,%eax
  8008a9:	74 06                	je     8008b1 <strnlen+0x1d>
  8008ab:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008af:	75 f3                	jne    8008a4 <strnlen+0x10>
	return n;
}
  8008b1:	5d                   	pop    %ebp
  8008b2:	c3                   	ret    

008008b3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	53                   	push   %ebx
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008bd:	89 c2                	mov    %eax,%edx
  8008bf:	83 c1 01             	add    $0x1,%ecx
  8008c2:	83 c2 01             	add    $0x1,%edx
  8008c5:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008c9:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008cc:	84 db                	test   %bl,%bl
  8008ce:	75 ef                	jne    8008bf <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008d0:	5b                   	pop    %ebx
  8008d1:	5d                   	pop    %ebp
  8008d2:	c3                   	ret    

008008d3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	53                   	push   %ebx
  8008d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008da:	53                   	push   %ebx
  8008db:	e8 9c ff ff ff       	call   80087c <strlen>
  8008e0:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008e3:	ff 75 0c             	pushl  0xc(%ebp)
  8008e6:	01 d8                	add    %ebx,%eax
  8008e8:	50                   	push   %eax
  8008e9:	e8 c5 ff ff ff       	call   8008b3 <strcpy>
	return dst;
}
  8008ee:	89 d8                	mov    %ebx,%eax
  8008f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    

008008f5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	56                   	push   %esi
  8008f9:	53                   	push   %ebx
  8008fa:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800900:	89 f3                	mov    %esi,%ebx
  800902:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800905:	89 f2                	mov    %esi,%edx
  800907:	eb 0f                	jmp    800918 <strncpy+0x23>
		*dst++ = *src;
  800909:	83 c2 01             	add    $0x1,%edx
  80090c:	0f b6 01             	movzbl (%ecx),%eax
  80090f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800912:	80 39 01             	cmpb   $0x1,(%ecx)
  800915:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800918:	39 da                	cmp    %ebx,%edx
  80091a:	75 ed                	jne    800909 <strncpy+0x14>
	}
	return ret;
}
  80091c:	89 f0                	mov    %esi,%eax
  80091e:	5b                   	pop    %ebx
  80091f:	5e                   	pop    %esi
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800930:	89 f0                	mov    %esi,%eax
  800932:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800936:	85 c9                	test   %ecx,%ecx
  800938:	75 0b                	jne    800945 <strlcpy+0x23>
  80093a:	eb 17                	jmp    800953 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	83 c0 01             	add    $0x1,%eax
  800942:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800945:	39 d8                	cmp    %ebx,%eax
  800947:	74 07                	je     800950 <strlcpy+0x2e>
  800949:	0f b6 0a             	movzbl (%edx),%ecx
  80094c:	84 c9                	test   %cl,%cl
  80094e:	75 ec                	jne    80093c <strlcpy+0x1a>
		*dst = '\0';
  800950:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800953:	29 f0                	sub    %esi,%eax
}
  800955:	5b                   	pop    %ebx
  800956:	5e                   	pop    %esi
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800962:	eb 06                	jmp    80096a <strcmp+0x11>
		p++, q++;
  800964:	83 c1 01             	add    $0x1,%ecx
  800967:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80096a:	0f b6 01             	movzbl (%ecx),%eax
  80096d:	84 c0                	test   %al,%al
  80096f:	74 04                	je     800975 <strcmp+0x1c>
  800971:	3a 02                	cmp    (%edx),%al
  800973:	74 ef                	je     800964 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800975:	0f b6 c0             	movzbl %al,%eax
  800978:	0f b6 12             	movzbl (%edx),%edx
  80097b:	29 d0                	sub    %edx,%eax
}
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	53                   	push   %ebx
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8b 55 0c             	mov    0xc(%ebp),%edx
  800989:	89 c3                	mov    %eax,%ebx
  80098b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80098e:	eb 06                	jmp    800996 <strncmp+0x17>
		n--, p++, q++;
  800990:	83 c0 01             	add    $0x1,%eax
  800993:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800996:	39 d8                	cmp    %ebx,%eax
  800998:	74 16                	je     8009b0 <strncmp+0x31>
  80099a:	0f b6 08             	movzbl (%eax),%ecx
  80099d:	84 c9                	test   %cl,%cl
  80099f:	74 04                	je     8009a5 <strncmp+0x26>
  8009a1:	3a 0a                	cmp    (%edx),%cl
  8009a3:	74 eb                	je     800990 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a5:	0f b6 00             	movzbl (%eax),%eax
  8009a8:	0f b6 12             	movzbl (%edx),%edx
  8009ab:	29 d0                	sub    %edx,%eax
}
  8009ad:	5b                   	pop    %ebx
  8009ae:	5d                   	pop    %ebp
  8009af:	c3                   	ret    
		return 0;
  8009b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b5:	eb f6                	jmp    8009ad <strncmp+0x2e>

008009b7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c1:	0f b6 10             	movzbl (%eax),%edx
  8009c4:	84 d2                	test   %dl,%dl
  8009c6:	74 09                	je     8009d1 <strchr+0x1a>
		if (*s == c)
  8009c8:	38 ca                	cmp    %cl,%dl
  8009ca:	74 0a                	je     8009d6 <strchr+0x1f>
	for (; *s; s++)
  8009cc:	83 c0 01             	add    $0x1,%eax
  8009cf:	eb f0                	jmp    8009c1 <strchr+0xa>
			return (char *) s;
	return 0;
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e2:	eb 03                	jmp    8009e7 <strfind+0xf>
  8009e4:	83 c0 01             	add    $0x1,%eax
  8009e7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8009ea:	38 ca                	cmp    %cl,%dl
  8009ec:	74 04                	je     8009f2 <strfind+0x1a>
  8009ee:	84 d2                	test   %dl,%dl
  8009f0:	75 f2                	jne    8009e4 <strfind+0xc>
			break;
	return (char *) s;
}
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	57                   	push   %edi
  8009f8:	56                   	push   %esi
  8009f9:	53                   	push   %ebx
  8009fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a00:	85 c9                	test   %ecx,%ecx
  800a02:	74 13                	je     800a17 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0a:	75 05                	jne    800a11 <memset+0x1d>
  800a0c:	f6 c1 03             	test   $0x3,%cl
  800a0f:	74 0d                	je     800a1e <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	fc                   	cld    
  800a15:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a17:	89 f8                	mov    %edi,%eax
  800a19:	5b                   	pop    %ebx
  800a1a:	5e                   	pop    %esi
  800a1b:	5f                   	pop    %edi
  800a1c:	5d                   	pop    %ebp
  800a1d:	c3                   	ret    
		c &= 0xFF;
  800a1e:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a22:	89 d3                	mov    %edx,%ebx
  800a24:	c1 e3 08             	shl    $0x8,%ebx
  800a27:	89 d0                	mov    %edx,%eax
  800a29:	c1 e0 18             	shl    $0x18,%eax
  800a2c:	89 d6                	mov    %edx,%esi
  800a2e:	c1 e6 10             	shl    $0x10,%esi
  800a31:	09 f0                	or     %esi,%eax
  800a33:	09 c2                	or     %eax,%edx
  800a35:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a37:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a3a:	89 d0                	mov    %edx,%eax
  800a3c:	fc                   	cld    
  800a3d:	f3 ab                	rep stos %eax,%es:(%edi)
  800a3f:	eb d6                	jmp    800a17 <memset+0x23>

00800a41 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	57                   	push   %edi
  800a45:	56                   	push   %esi
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a4f:	39 c6                	cmp    %eax,%esi
  800a51:	73 35                	jae    800a88 <memmove+0x47>
  800a53:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a56:	39 c2                	cmp    %eax,%edx
  800a58:	76 2e                	jbe    800a88 <memmove+0x47>
		s += n;
		d += n;
  800a5a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5d:	89 d6                	mov    %edx,%esi
  800a5f:	09 fe                	or     %edi,%esi
  800a61:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a67:	74 0c                	je     800a75 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a69:	83 ef 01             	sub    $0x1,%edi
  800a6c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a6f:	fd                   	std    
  800a70:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a72:	fc                   	cld    
  800a73:	eb 21                	jmp    800a96 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a75:	f6 c1 03             	test   $0x3,%cl
  800a78:	75 ef                	jne    800a69 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a7a:	83 ef 04             	sub    $0x4,%edi
  800a7d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a80:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a83:	fd                   	std    
  800a84:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a86:	eb ea                	jmp    800a72 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a88:	89 f2                	mov    %esi,%edx
  800a8a:	09 c2                	or     %eax,%edx
  800a8c:	f6 c2 03             	test   $0x3,%dl
  800a8f:	74 09                	je     800a9a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a91:	89 c7                	mov    %eax,%edi
  800a93:	fc                   	cld    
  800a94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a96:	5e                   	pop    %esi
  800a97:	5f                   	pop    %edi
  800a98:	5d                   	pop    %ebp
  800a99:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a9a:	f6 c1 03             	test   $0x3,%cl
  800a9d:	75 f2                	jne    800a91 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a9f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800aa2:	89 c7                	mov    %eax,%edi
  800aa4:	fc                   	cld    
  800aa5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa7:	eb ed                	jmp    800a96 <memmove+0x55>

00800aa9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800aac:	ff 75 10             	pushl  0x10(%ebp)
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	ff 75 08             	pushl  0x8(%ebp)
  800ab5:	e8 87 ff ff ff       	call   800a41 <memmove>
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	56                   	push   %esi
  800ac0:	53                   	push   %ebx
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac7:	89 c6                	mov    %eax,%esi
  800ac9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acc:	39 f0                	cmp    %esi,%eax
  800ace:	74 1c                	je     800aec <memcmp+0x30>
		if (*s1 != *s2)
  800ad0:	0f b6 08             	movzbl (%eax),%ecx
  800ad3:	0f b6 1a             	movzbl (%edx),%ebx
  800ad6:	38 d9                	cmp    %bl,%cl
  800ad8:	75 08                	jne    800ae2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	83 c2 01             	add    $0x1,%edx
  800ae0:	eb ea                	jmp    800acc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ae2:	0f b6 c1             	movzbl %cl,%eax
  800ae5:	0f b6 db             	movzbl %bl,%ebx
  800ae8:	29 d8                	sub    %ebx,%eax
  800aea:	eb 05                	jmp    800af1 <memcmp+0x35>
	}

	return 0;
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af1:	5b                   	pop    %ebx
  800af2:	5e                   	pop    %esi
  800af3:	5d                   	pop    %ebp
  800af4:	c3                   	ret    

00800af5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b03:	39 d0                	cmp    %edx,%eax
  800b05:	73 09                	jae    800b10 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b07:	38 08                	cmp    %cl,(%eax)
  800b09:	74 05                	je     800b10 <memfind+0x1b>
	for (; s < ends; s++)
  800b0b:	83 c0 01             	add    $0x1,%eax
  800b0e:	eb f3                	jmp    800b03 <memfind+0xe>
			break;
	return (void *) s;
}
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	57                   	push   %edi
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
  800b18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1e:	eb 03                	jmp    800b23 <strtol+0x11>
		s++;
  800b20:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b23:	0f b6 01             	movzbl (%ecx),%eax
  800b26:	3c 20                	cmp    $0x20,%al
  800b28:	74 f6                	je     800b20 <strtol+0xe>
  800b2a:	3c 09                	cmp    $0x9,%al
  800b2c:	74 f2                	je     800b20 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b2e:	3c 2b                	cmp    $0x2b,%al
  800b30:	74 2e                	je     800b60 <strtol+0x4e>
	int neg = 0;
  800b32:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b37:	3c 2d                	cmp    $0x2d,%al
  800b39:	74 2f                	je     800b6a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b3b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b41:	75 05                	jne    800b48 <strtol+0x36>
  800b43:	80 39 30             	cmpb   $0x30,(%ecx)
  800b46:	74 2c                	je     800b74 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b48:	85 db                	test   %ebx,%ebx
  800b4a:	75 0a                	jne    800b56 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b4c:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800b51:	80 39 30             	cmpb   $0x30,(%ecx)
  800b54:	74 28                	je     800b7e <strtol+0x6c>
		base = 10;
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b5e:	eb 50                	jmp    800bb0 <strtol+0x9e>
		s++;
  800b60:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b63:	bf 00 00 00 00       	mov    $0x0,%edi
  800b68:	eb d1                	jmp    800b3b <strtol+0x29>
		s++, neg = 1;
  800b6a:	83 c1 01             	add    $0x1,%ecx
  800b6d:	bf 01 00 00 00       	mov    $0x1,%edi
  800b72:	eb c7                	jmp    800b3b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b74:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b78:	74 0e                	je     800b88 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800b7a:	85 db                	test   %ebx,%ebx
  800b7c:	75 d8                	jne    800b56 <strtol+0x44>
		s++, base = 8;
  800b7e:	83 c1 01             	add    $0x1,%ecx
  800b81:	bb 08 00 00 00       	mov    $0x8,%ebx
  800b86:	eb ce                	jmp    800b56 <strtol+0x44>
		s += 2, base = 16;
  800b88:	83 c1 02             	add    $0x2,%ecx
  800b8b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b90:	eb c4                	jmp    800b56 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b92:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b95:	89 f3                	mov    %esi,%ebx
  800b97:	80 fb 19             	cmp    $0x19,%bl
  800b9a:	77 29                	ja     800bc5 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b9c:	0f be d2             	movsbl %dl,%edx
  800b9f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ba2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ba5:	7d 30                	jge    800bd7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800ba7:	83 c1 01             	add    $0x1,%ecx
  800baa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bae:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bb0:	0f b6 11             	movzbl (%ecx),%edx
  800bb3:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bb6:	89 f3                	mov    %esi,%ebx
  800bb8:	80 fb 09             	cmp    $0x9,%bl
  800bbb:	77 d5                	ja     800b92 <strtol+0x80>
			dig = *s - '0';
  800bbd:	0f be d2             	movsbl %dl,%edx
  800bc0:	83 ea 30             	sub    $0x30,%edx
  800bc3:	eb dd                	jmp    800ba2 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800bc5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bc8:	89 f3                	mov    %esi,%ebx
  800bca:	80 fb 19             	cmp    $0x19,%bl
  800bcd:	77 08                	ja     800bd7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800bcf:	0f be d2             	movsbl %dl,%edx
  800bd2:	83 ea 37             	sub    $0x37,%edx
  800bd5:	eb cb                	jmp    800ba2 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdb:	74 05                	je     800be2 <strtol+0xd0>
		*endptr = (char *) s;
  800bdd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800be2:	89 c2                	mov    %eax,%edx
  800be4:	f7 da                	neg    %edx
  800be6:	85 ff                	test   %edi,%edi
  800be8:	0f 45 c2             	cmovne %edx,%eax
}
  800beb:	5b                   	pop    %ebx
  800bec:	5e                   	pop    %esi
  800bed:	5f                   	pop    %edi
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	89 c3                	mov    %eax,%ebx
  800c03:	89 c7                	mov    %eax,%edi
  800c05:	89 c6                	mov    %eax,%esi
  800c07:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5e                   	pop    %esi
  800c0b:	5f                   	pop    %edi
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	57                   	push   %edi
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
  800c19:	b8 01 00 00 00       	mov    $0x1,%eax
  800c1e:	89 d1                	mov    %edx,%ecx
  800c20:	89 d3                	mov    %edx,%ebx
  800c22:	89 d7                	mov    %edx,%edi
  800c24:	89 d6                	mov    %edx,%esi
  800c26:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
  800c33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c43:	89 cb                	mov    %ecx,%ebx
  800c45:	89 cf                	mov    %ecx,%edi
  800c47:	89 ce                	mov    %ecx,%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 03                	push   $0x3
  800c5d:	68 5f 2a 80 00       	push   $0x802a5f
  800c62:	6a 23                	push   $0x23
  800c64:	68 7c 2a 80 00       	push   $0x802a7c
  800c69:	e8 00 17 00 00       	call   80236e <_panic>

00800c6e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c74:	ba 00 00 00 00       	mov    $0x0,%edx
  800c79:	b8 02 00 00 00       	mov    $0x2,%eax
  800c7e:	89 d1                	mov    %edx,%ecx
  800c80:	89 d3                	mov    %edx,%ebx
  800c82:	89 d7                	mov    %edx,%edi
  800c84:	89 d6                	mov    %edx,%esi
  800c86:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <sys_yield>:

void
sys_yield(void)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c93:	ba 00 00 00 00       	mov    $0x0,%edx
  800c98:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c9d:	89 d1                	mov    %edx,%ecx
  800c9f:	89 d3                	mov    %edx,%ebx
  800ca1:	89 d7                	mov    %edx,%edi
  800ca3:	89 d6                	mov    %edx,%esi
  800ca5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb5:	be 00 00 00 00       	mov    $0x0,%esi
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc8:	89 f7                	mov    %esi,%edi
  800cca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7f 08                	jg     800cd8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd8:	83 ec 0c             	sub    $0xc,%esp
  800cdb:	50                   	push   %eax
  800cdc:	6a 04                	push   $0x4
  800cde:	68 5f 2a 80 00       	push   $0x802a5f
  800ce3:	6a 23                	push   $0x23
  800ce5:	68 7c 2a 80 00       	push   $0x802a7c
  800cea:	e8 7f 16 00 00       	call   80236e <_panic>

00800cef <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
  800cf5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfe:	b8 05 00 00 00       	mov    $0x5,%eax
  800d03:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d06:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d09:	8b 75 18             	mov    0x18(%ebp),%esi
  800d0c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d0e:	85 c0                	test   %eax,%eax
  800d10:	7f 08                	jg     800d1a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d12:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1a:	83 ec 0c             	sub    $0xc,%esp
  800d1d:	50                   	push   %eax
  800d1e:	6a 05                	push   $0x5
  800d20:	68 5f 2a 80 00       	push   $0x802a5f
  800d25:	6a 23                	push   $0x23
  800d27:	68 7c 2a 80 00       	push   $0x802a7c
  800d2c:	e8 3d 16 00 00       	call   80236e <_panic>

00800d31 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	57                   	push   %edi
  800d35:	56                   	push   %esi
  800d36:	53                   	push   %ebx
  800d37:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d45:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4a:	89 df                	mov    %ebx,%edi
  800d4c:	89 de                	mov    %ebx,%esi
  800d4e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d50:	85 c0                	test   %eax,%eax
  800d52:	7f 08                	jg     800d5c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d57:	5b                   	pop    %ebx
  800d58:	5e                   	pop    %esi
  800d59:	5f                   	pop    %edi
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5c:	83 ec 0c             	sub    $0xc,%esp
  800d5f:	50                   	push   %eax
  800d60:	6a 06                	push   $0x6
  800d62:	68 5f 2a 80 00       	push   $0x802a5f
  800d67:	6a 23                	push   $0x23
  800d69:	68 7c 2a 80 00       	push   $0x802a7c
  800d6e:	e8 fb 15 00 00       	call   80236e <_panic>

00800d73 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d87:	b8 08 00 00 00       	mov    $0x8,%eax
  800d8c:	89 df                	mov    %ebx,%edi
  800d8e:	89 de                	mov    %ebx,%esi
  800d90:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	7f 08                	jg     800d9e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d99:	5b                   	pop    %ebx
  800d9a:	5e                   	pop    %esi
  800d9b:	5f                   	pop    %edi
  800d9c:	5d                   	pop    %ebp
  800d9d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9e:	83 ec 0c             	sub    $0xc,%esp
  800da1:	50                   	push   %eax
  800da2:	6a 08                	push   $0x8
  800da4:	68 5f 2a 80 00       	push   $0x802a5f
  800da9:	6a 23                	push   $0x23
  800dab:	68 7c 2a 80 00       	push   $0x802a7c
  800db0:	e8 b9 15 00 00       	call   80236e <_panic>

00800db5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
  800dbb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	b8 09 00 00 00       	mov    $0x9,%eax
  800dce:	89 df                	mov    %ebx,%edi
  800dd0:	89 de                	mov    %ebx,%esi
  800dd2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd4:	85 c0                	test   %eax,%eax
  800dd6:	7f 08                	jg     800de0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	50                   	push   %eax
  800de4:	6a 09                	push   $0x9
  800de6:	68 5f 2a 80 00       	push   $0x802a5f
  800deb:	6a 23                	push   $0x23
  800ded:	68 7c 2a 80 00       	push   $0x802a7c
  800df2:	e8 77 15 00 00       	call   80236e <_panic>

00800df7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	57                   	push   %edi
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e10:	89 df                	mov    %ebx,%edi
  800e12:	89 de                	mov    %ebx,%esi
  800e14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	7f 08                	jg     800e22 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	50                   	push   %eax
  800e26:	6a 0a                	push   $0xa
  800e28:	68 5f 2a 80 00       	push   $0x802a5f
  800e2d:	6a 23                	push   $0x23
  800e2f:	68 7c 2a 80 00       	push   $0x802a7c
  800e34:	e8 35 15 00 00       	call   80236e <_panic>

00800e39 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e4a:	be 00 00 00 00       	mov    $0x0,%esi
  800e4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e52:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e55:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e72:	89 cb                	mov    %ecx,%ebx
  800e74:	89 cf                	mov    %ecx,%edi
  800e76:	89 ce                	mov    %ecx,%esi
  800e78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	7f 08                	jg     800e86 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 0d                	push   $0xd
  800e8c:	68 5f 2a 80 00       	push   $0x802a5f
  800e91:	6a 23                	push   $0x23
  800e93:	68 7c 2a 80 00       	push   $0x802a7c
  800e98:	e8 d1 14 00 00       	call   80236e <_panic>

00800e9d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	57                   	push   %edi
  800ea1:	56                   	push   %esi
  800ea2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ead:	89 d1                	mov    %edx,%ecx
  800eaf:	89 d3                	mov    %edx,%ebx
  800eb1:	89 d7                	mov    %edx,%edi
  800eb3:	89 d6                	mov    %edx,%esi
  800eb5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800ec4:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800ec6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800eca:	74 7f                	je     800f4b <pgfault+0x8f>
  800ecc:	89 d8                	mov    %ebx,%eax
  800ece:	c1 e8 0c             	shr    $0xc,%eax
  800ed1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800ed8:	f6 c4 08             	test   $0x8,%ah
  800edb:	74 6e                	je     800f4b <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800edd:	e8 8c fd ff ff       	call   800c6e <sys_getenvid>
  800ee2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	6a 07                	push   $0x7
  800ee9:	68 00 f0 7f 00       	push   $0x7ff000
  800eee:	50                   	push   %eax
  800eef:	e8 b8 fd ff ff       	call   800cac <sys_page_alloc>
  800ef4:	83 c4 10             	add    $0x10,%esp
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	78 64                	js     800f5f <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800efb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800f01:	83 ec 04             	sub    $0x4,%esp
  800f04:	68 00 10 00 00       	push   $0x1000
  800f09:	53                   	push   %ebx
  800f0a:	68 00 f0 7f 00       	push   $0x7ff000
  800f0f:	e8 2d fb ff ff       	call   800a41 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800f14:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f1b:	53                   	push   %ebx
  800f1c:	56                   	push   %esi
  800f1d:	68 00 f0 7f 00       	push   $0x7ff000
  800f22:	56                   	push   %esi
  800f23:	e8 c7 fd ff ff       	call   800cef <sys_page_map>
  800f28:	83 c4 20             	add    $0x20,%esp
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	78 42                	js     800f71 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	68 00 f0 7f 00       	push   $0x7ff000
  800f37:	56                   	push   %esi
  800f38:	e8 f4 fd ff ff       	call   800d31 <sys_page_unmap>
  800f3d:	83 c4 10             	add    $0x10,%esp
  800f40:	85 c0                	test   %eax,%eax
  800f42:	78 3f                	js     800f83 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800f4b:	83 ec 04             	sub    $0x4,%esp
  800f4e:	68 8c 2a 80 00       	push   $0x802a8c
  800f53:	6a 1d                	push   $0x1d
  800f55:	68 1b 2b 80 00       	push   $0x802b1b
  800f5a:	e8 0f 14 00 00       	call   80236e <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800f5f:	50                   	push   %eax
  800f60:	68 b4 2a 80 00       	push   $0x802ab4
  800f65:	6a 28                	push   $0x28
  800f67:	68 1b 2b 80 00       	push   $0x802b1b
  800f6c:	e8 fd 13 00 00       	call   80236e <_panic>
		panic("pgfault:page map failed: %e", r);
  800f71:	50                   	push   %eax
  800f72:	68 26 2b 80 00       	push   $0x802b26
  800f77:	6a 2c                	push   $0x2c
  800f79:	68 1b 2b 80 00       	push   $0x802b1b
  800f7e:	e8 eb 13 00 00       	call   80236e <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800f83:	50                   	push   %eax
  800f84:	68 d8 2a 80 00       	push   $0x802ad8
  800f89:	6a 2e                	push   $0x2e
  800f8b:	68 1b 2b 80 00       	push   $0x802b1b
  800f90:	e8 d9 13 00 00       	call   80236e <_panic>

00800f95 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800f9e:	68 bc 0e 80 00       	push   $0x800ebc
  800fa3:	e8 0c 14 00 00       	call   8023b4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fa8:	b8 07 00 00 00       	mov    $0x7,%eax
  800fad:	cd 30                	int    $0x30
  800faf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800fb2:	83 c4 10             	add    $0x10,%esp
  800fb5:	85 c0                	test   %eax,%eax
  800fb7:	78 2f                	js     800fe8 <fork+0x53>
  800fb9:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800fbb:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800fc0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fc4:	75 6e                	jne    801034 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800fc6:	e8 a3 fc ff ff       	call   800c6e <sys_getenvid>
  800fcb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800fd0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800fd3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800fd8:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800fe8:	50                   	push   %eax
  800fe9:	68 f8 2a 80 00       	push   $0x802af8
  800fee:	6a 6e                	push   $0x6e
  800ff0:	68 1b 2b 80 00       	push   $0x802b1b
  800ff5:	e8 74 13 00 00       	call   80236e <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800ffa:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801001:	83 ec 0c             	sub    $0xc,%esp
  801004:	25 07 0e 00 00       	and    $0xe07,%eax
  801009:	50                   	push   %eax
  80100a:	56                   	push   %esi
  80100b:	57                   	push   %edi
  80100c:	56                   	push   %esi
  80100d:	6a 00                	push   $0x0
  80100f:	e8 db fc ff ff       	call   800cef <sys_page_map>
  801014:	83 c4 20             	add    $0x20,%esp
  801017:	85 c0                	test   %eax,%eax
  801019:	ba 00 00 00 00       	mov    $0x0,%edx
  80101e:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  801021:	85 c0                	test   %eax,%eax
  801023:	78 bb                	js     800fe0 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  801025:	83 c3 01             	add    $0x1,%ebx
  801028:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80102e:	0f 84 a6 00 00 00    	je     8010da <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  801034:	89 d8                	mov    %ebx,%eax
  801036:	c1 e8 0a             	shr    $0xa,%eax
  801039:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801040:	a8 01                	test   $0x1,%al
  801042:	74 e1                	je     801025 <fork+0x90>
  801044:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80104b:	a8 01                	test   $0x1,%al
  80104d:	74 d6                	je     801025 <fork+0x90>
  80104f:	89 de                	mov    %ebx,%esi
  801051:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  801054:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80105b:	f6 c4 04             	test   $0x4,%ah
  80105e:	75 9a                	jne    800ffa <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  801060:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801067:	a8 02                	test   $0x2,%al
  801069:	75 0c                	jne    801077 <fork+0xe2>
  80106b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801072:	f6 c4 08             	test   $0x8,%ah
  801075:	74 42                	je     8010b9 <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	68 05 08 00 00       	push   $0x805
  80107f:	56                   	push   %esi
  801080:	57                   	push   %edi
  801081:	56                   	push   %esi
  801082:	6a 00                	push   $0x0
  801084:	e8 66 fc ff ff       	call   800cef <sys_page_map>
  801089:	83 c4 20             	add    $0x20,%esp
  80108c:	85 c0                	test   %eax,%eax
  80108e:	0f 88 4c ff ff ff    	js     800fe0 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  801094:	83 ec 0c             	sub    $0xc,%esp
  801097:	68 05 08 00 00       	push   $0x805
  80109c:	56                   	push   %esi
  80109d:	6a 00                	push   $0x0
  80109f:	56                   	push   %esi
  8010a0:	6a 00                	push   $0x0
  8010a2:	e8 48 fc ff ff       	call   800cef <sys_page_map>
  8010a7:	83 c4 20             	add    $0x20,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	0f 4f c1             	cmovg  %ecx,%eax
  8010b4:	e9 68 ff ff ff       	jmp    801021 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  8010b9:	83 ec 0c             	sub    $0xc,%esp
  8010bc:	6a 05                	push   $0x5
  8010be:	56                   	push   %esi
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	6a 00                	push   $0x0
  8010c3:	e8 27 fc ff ff       	call   800cef <sys_page_map>
  8010c8:	83 c4 20             	add    $0x20,%esp
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d2:	0f 4f c1             	cmovg  %ecx,%eax
  8010d5:	e9 47 ff ff ff       	jmp    801021 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	6a 07                	push   $0x7
  8010df:	68 00 f0 bf ee       	push   $0xeebff000
  8010e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010e7:	57                   	push   %edi
  8010e8:	e8 bf fb ff ff       	call   800cac <sys_page_alloc>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	0f 88 e8 fe ff ff    	js     800fe0 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  8010f8:	83 ec 08             	sub    $0x8,%esp
  8010fb:	68 19 24 80 00       	push   $0x802419
  801100:	57                   	push   %edi
  801101:	e8 f1 fc ff ff       	call   800df7 <sys_env_set_pgfault_upcall>
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	85 c0                	test   %eax,%eax
  80110b:	0f 88 cf fe ff ff    	js     800fe0 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801111:	83 ec 08             	sub    $0x8,%esp
  801114:	6a 02                	push   $0x2
  801116:	57                   	push   %edi
  801117:	e8 57 fc ff ff       	call   800d73 <sys_env_set_status>
  80111c:	83 c4 10             	add    $0x10,%esp
  80111f:	85 c0                	test   %eax,%eax
  801121:	78 08                	js     80112b <fork+0x196>
	return eid;
  801123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801126:	e9 b5 fe ff ff       	jmp    800fe0 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  80112b:	50                   	push   %eax
  80112c:	68 42 2b 80 00       	push   $0x802b42
  801131:	68 87 00 00 00       	push   $0x87
  801136:	68 1b 2b 80 00       	push   $0x802b1b
  80113b:	e8 2e 12 00 00       	call   80236e <_panic>

00801140 <sfork>:

// Challenge!
int sfork(void)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801146:	68 60 2b 80 00       	push   $0x802b60
  80114b:	68 8f 00 00 00       	push   $0x8f
  801150:	68 1b 2b 80 00       	push   $0x802b1b
  801155:	e8 14 12 00 00       	call   80236e <_panic>

0080115a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	56                   	push   %esi
  80115e:	53                   	push   %ebx
  80115f:	8b 75 08             	mov    0x8(%ebp),%esi
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801168:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80116a:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80116f:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801172:	83 ec 0c             	sub    $0xc,%esp
  801175:	50                   	push   %eax
  801176:	e8 e1 fc ff ff       	call   800e5c <sys_ipc_recv>
	if (from_env_store)
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	85 f6                	test   %esi,%esi
  801180:	74 14                	je     801196 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801182:	ba 00 00 00 00       	mov    $0x0,%edx
  801187:	85 c0                	test   %eax,%eax
  801189:	78 09                	js     801194 <ipc_recv+0x3a>
  80118b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801191:	8b 52 74             	mov    0x74(%edx),%edx
  801194:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801196:	85 db                	test   %ebx,%ebx
  801198:	74 14                	je     8011ae <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  80119a:	ba 00 00 00 00       	mov    $0x0,%edx
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 09                	js     8011ac <ipc_recv+0x52>
  8011a3:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8011a9:	8b 52 78             	mov    0x78(%edx),%edx
  8011ac:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	78 08                	js     8011ba <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  8011b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8011b7:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  8011ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011bd:	5b                   	pop    %ebx
  8011be:	5e                   	pop    %esi
  8011bf:	5d                   	pop    %ebp
  8011c0:	c3                   	ret    

008011c1 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	57                   	push   %edi
  8011c5:	56                   	push   %esi
  8011c6:	53                   	push   %ebx
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8011d3:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  8011d5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8011da:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8011dd:	ff 75 14             	pushl  0x14(%ebp)
  8011e0:	53                   	push   %ebx
  8011e1:	56                   	push   %esi
  8011e2:	57                   	push   %edi
  8011e3:	e8 51 fc ff ff       	call   800e39 <sys_ipc_try_send>
		if (ret == 0)
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	74 1e                	je     80120d <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  8011ef:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8011f2:	75 07                	jne    8011fb <ipc_send+0x3a>
			sys_yield();
  8011f4:	e8 94 fa ff ff       	call   800c8d <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  8011f9:	eb e2                	jmp    8011dd <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  8011fb:	50                   	push   %eax
  8011fc:	68 76 2b 80 00       	push   $0x802b76
  801201:	6a 3d                	push   $0x3d
  801203:	68 8a 2b 80 00       	push   $0x802b8a
  801208:	e8 61 11 00 00       	call   80236e <_panic>
	}
	// panic("ipc_send not implemented");
}
  80120d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801210:	5b                   	pop    %ebx
  801211:	5e                   	pop    %esi
  801212:	5f                   	pop    %edi
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80121b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801220:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801223:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801229:	8b 52 50             	mov    0x50(%edx),%edx
  80122c:	39 ca                	cmp    %ecx,%edx
  80122e:	74 11                	je     801241 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801230:	83 c0 01             	add    $0x1,%eax
  801233:	3d 00 04 00 00       	cmp    $0x400,%eax
  801238:	75 e6                	jne    801220 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80123a:	b8 00 00 00 00       	mov    $0x0,%eax
  80123f:	eb 0b                	jmp    80124c <ipc_find_env+0x37>
			return envs[i].env_id;
  801241:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801244:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801249:	8b 40 48             	mov    0x48(%eax),%eax
}
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	05 00 00 00 30       	add    $0x30000000,%eax
  801259:	c1 e8 0c             	shr    $0xc,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801269:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126e:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801273:	5d                   	pop    %ebp
  801274:	c3                   	ret    

00801275 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80127b:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801280:	89 c2                	mov    %eax,%edx
  801282:	c1 ea 16             	shr    $0x16,%edx
  801285:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80128c:	f6 c2 01             	test   $0x1,%dl
  80128f:	74 2a                	je     8012bb <fd_alloc+0x46>
  801291:	89 c2                	mov    %eax,%edx
  801293:	c1 ea 0c             	shr    $0xc,%edx
  801296:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80129d:	f6 c2 01             	test   $0x1,%dl
  8012a0:	74 19                	je     8012bb <fd_alloc+0x46>
  8012a2:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8012a7:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012ac:	75 d2                	jne    801280 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ae:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012b9:	eb 07                	jmp    8012c2 <fd_alloc+0x4d>
			*fd_store = fd;
  8012bb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012c2:	5d                   	pop    %ebp
  8012c3:	c3                   	ret    

008012c4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012ca:	83 f8 1f             	cmp    $0x1f,%eax
  8012cd:	77 36                	ja     801305 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012cf:	c1 e0 0c             	shl    $0xc,%eax
  8012d2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	c1 ea 16             	shr    $0x16,%edx
  8012dc:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012e3:	f6 c2 01             	test   $0x1,%dl
  8012e6:	74 24                	je     80130c <fd_lookup+0x48>
  8012e8:	89 c2                	mov    %eax,%edx
  8012ea:	c1 ea 0c             	shr    $0xc,%edx
  8012ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f4:	f6 c2 01             	test   $0x1,%dl
  8012f7:	74 1a                	je     801313 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fc:	89 02                	mov    %eax,(%edx)
	return 0;
  8012fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
		return -E_INVAL;
  801305:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80130a:	eb f7                	jmp    801303 <fd_lookup+0x3f>
		return -E_INVAL;
  80130c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801311:	eb f0                	jmp    801303 <fd_lookup+0x3f>
  801313:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801318:	eb e9                	jmp    801303 <fd_lookup+0x3f>

0080131a <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 08             	sub    $0x8,%esp
  801320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801323:	ba 10 2c 80 00       	mov    $0x802c10,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801328:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  80132d:	39 08                	cmp    %ecx,(%eax)
  80132f:	74 33                	je     801364 <dev_lookup+0x4a>
  801331:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801334:	8b 02                	mov    (%edx),%eax
  801336:	85 c0                	test   %eax,%eax
  801338:	75 f3                	jne    80132d <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80133a:	a1 08 40 80 00       	mov    0x804008,%eax
  80133f:	8b 40 48             	mov    0x48(%eax),%eax
  801342:	83 ec 04             	sub    $0x4,%esp
  801345:	51                   	push   %ecx
  801346:	50                   	push   %eax
  801347:	68 94 2b 80 00       	push   $0x802b94
  80134c:	e8 43 ef ff ff       	call   800294 <cprintf>
	*dev = 0;
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    
			*dev = devtab[i];
  801364:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801367:	89 01                	mov    %eax,(%ecx)
			return 0;
  801369:	b8 00 00 00 00       	mov    $0x0,%eax
  80136e:	eb f2                	jmp    801362 <dev_lookup+0x48>

00801370 <fd_close>:
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	57                   	push   %edi
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 1c             	sub    $0x1c,%esp
  801379:	8b 75 08             	mov    0x8(%ebp),%esi
  80137c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801382:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801383:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80138c:	50                   	push   %eax
  80138d:	e8 32 ff ff ff       	call   8012c4 <fd_lookup>
  801392:	89 c3                	mov    %eax,%ebx
  801394:	83 c4 08             	add    $0x8,%esp
  801397:	85 c0                	test   %eax,%eax
  801399:	78 05                	js     8013a0 <fd_close+0x30>
	    || fd != fd2)
  80139b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80139e:	74 16                	je     8013b6 <fd_close+0x46>
		return (must_exist ? r : 0);
  8013a0:	89 f8                	mov    %edi,%eax
  8013a2:	84 c0                	test   %al,%al
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	0f 44 d8             	cmove  %eax,%ebx
}
  8013ac:	89 d8                	mov    %ebx,%eax
  8013ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5f                   	pop    %edi
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013b6:	83 ec 08             	sub    $0x8,%esp
  8013b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013bc:	50                   	push   %eax
  8013bd:	ff 36                	pushl  (%esi)
  8013bf:	e8 56 ff ff ff       	call   80131a <dev_lookup>
  8013c4:	89 c3                	mov    %eax,%ebx
  8013c6:	83 c4 10             	add    $0x10,%esp
  8013c9:	85 c0                	test   %eax,%eax
  8013cb:	78 15                	js     8013e2 <fd_close+0x72>
		if (dev->dev_close)
  8013cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d0:	8b 40 10             	mov    0x10(%eax),%eax
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	74 1b                	je     8013f2 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	56                   	push   %esi
  8013db:	ff d0                	call   *%eax
  8013dd:	89 c3                	mov    %eax,%ebx
  8013df:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	56                   	push   %esi
  8013e6:	6a 00                	push   $0x0
  8013e8:	e8 44 f9 ff ff       	call   800d31 <sys_page_unmap>
	return r;
  8013ed:	83 c4 10             	add    $0x10,%esp
  8013f0:	eb ba                	jmp    8013ac <fd_close+0x3c>
			r = 0;
  8013f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f7:	eb e9                	jmp    8013e2 <fd_close+0x72>

008013f9 <close>:

int
close(int fdnum)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801402:	50                   	push   %eax
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	e8 b9 fe ff ff       	call   8012c4 <fd_lookup>
  80140b:	83 c4 08             	add    $0x8,%esp
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 10                	js     801422 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	6a 01                	push   $0x1
  801417:	ff 75 f4             	pushl  -0xc(%ebp)
  80141a:	e8 51 ff ff ff       	call   801370 <fd_close>
  80141f:	83 c4 10             	add    $0x10,%esp
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <close_all>:

void
close_all(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	53                   	push   %ebx
  801428:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80142b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	53                   	push   %ebx
  801434:	e8 c0 ff ff ff       	call   8013f9 <close>
	for (i = 0; i < MAXFD; i++)
  801439:	83 c3 01             	add    $0x1,%ebx
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	83 fb 20             	cmp    $0x20,%ebx
  801442:	75 ec                	jne    801430 <close_all+0xc>
}
  801444:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	57                   	push   %edi
  80144d:	56                   	push   %esi
  80144e:	53                   	push   %ebx
  80144f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801452:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801455:	50                   	push   %eax
  801456:	ff 75 08             	pushl  0x8(%ebp)
  801459:	e8 66 fe ff ff       	call   8012c4 <fd_lookup>
  80145e:	89 c3                	mov    %eax,%ebx
  801460:	83 c4 08             	add    $0x8,%esp
  801463:	85 c0                	test   %eax,%eax
  801465:	0f 88 81 00 00 00    	js     8014ec <dup+0xa3>
		return r;
	close(newfdnum);
  80146b:	83 ec 0c             	sub    $0xc,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	e8 83 ff ff ff       	call   8013f9 <close>

	newfd = INDEX2FD(newfdnum);
  801476:	8b 75 0c             	mov    0xc(%ebp),%esi
  801479:	c1 e6 0c             	shl    $0xc,%esi
  80147c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801482:	83 c4 04             	add    $0x4,%esp
  801485:	ff 75 e4             	pushl  -0x1c(%ebp)
  801488:	e8 d1 fd ff ff       	call   80125e <fd2data>
  80148d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80148f:	89 34 24             	mov    %esi,(%esp)
  801492:	e8 c7 fd ff ff       	call   80125e <fd2data>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80149c:	89 d8                	mov    %ebx,%eax
  80149e:	c1 e8 16             	shr    $0x16,%eax
  8014a1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014a8:	a8 01                	test   $0x1,%al
  8014aa:	74 11                	je     8014bd <dup+0x74>
  8014ac:	89 d8                	mov    %ebx,%eax
  8014ae:	c1 e8 0c             	shr    $0xc,%eax
  8014b1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014b8:	f6 c2 01             	test   $0x1,%dl
  8014bb:	75 39                	jne    8014f6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014c0:	89 d0                	mov    %edx,%eax
  8014c2:	c1 e8 0c             	shr    $0xc,%eax
  8014c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	25 07 0e 00 00       	and    $0xe07,%eax
  8014d4:	50                   	push   %eax
  8014d5:	56                   	push   %esi
  8014d6:	6a 00                	push   $0x0
  8014d8:	52                   	push   %edx
  8014d9:	6a 00                	push   $0x0
  8014db:	e8 0f f8 ff ff       	call   800cef <sys_page_map>
  8014e0:	89 c3                	mov    %eax,%ebx
  8014e2:	83 c4 20             	add    $0x20,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 31                	js     80151a <dup+0xd1>
		goto err;

	return newfdnum;
  8014e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014ec:	89 d8                	mov    %ebx,%eax
  8014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5e                   	pop    %esi
  8014f3:	5f                   	pop    %edi
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014f6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014fd:	83 ec 0c             	sub    $0xc,%esp
  801500:	25 07 0e 00 00       	and    $0xe07,%eax
  801505:	50                   	push   %eax
  801506:	57                   	push   %edi
  801507:	6a 00                	push   $0x0
  801509:	53                   	push   %ebx
  80150a:	6a 00                	push   $0x0
  80150c:	e8 de f7 ff ff       	call   800cef <sys_page_map>
  801511:	89 c3                	mov    %eax,%ebx
  801513:	83 c4 20             	add    $0x20,%esp
  801516:	85 c0                	test   %eax,%eax
  801518:	79 a3                	jns    8014bd <dup+0x74>
	sys_page_unmap(0, newfd);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	56                   	push   %esi
  80151e:	6a 00                	push   $0x0
  801520:	e8 0c f8 ff ff       	call   800d31 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801525:	83 c4 08             	add    $0x8,%esp
  801528:	57                   	push   %edi
  801529:	6a 00                	push   $0x0
  80152b:	e8 01 f8 ff ff       	call   800d31 <sys_page_unmap>
	return r;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	eb b7                	jmp    8014ec <dup+0xa3>

00801535 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	53                   	push   %ebx
  801539:	83 ec 14             	sub    $0x14,%esp
  80153c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801542:	50                   	push   %eax
  801543:	53                   	push   %ebx
  801544:	e8 7b fd ff ff       	call   8012c4 <fd_lookup>
  801549:	83 c4 08             	add    $0x8,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 3f                	js     80158f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801556:	50                   	push   %eax
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	ff 30                	pushl  (%eax)
  80155c:	e8 b9 fd ff ff       	call   80131a <dev_lookup>
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	85 c0                	test   %eax,%eax
  801566:	78 27                	js     80158f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801568:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156b:	8b 42 08             	mov    0x8(%edx),%eax
  80156e:	83 e0 03             	and    $0x3,%eax
  801571:	83 f8 01             	cmp    $0x1,%eax
  801574:	74 1e                	je     801594 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	8b 40 08             	mov    0x8(%eax),%eax
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 35                	je     8015b5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801580:	83 ec 04             	sub    $0x4,%esp
  801583:	ff 75 10             	pushl  0x10(%ebp)
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	52                   	push   %edx
  80158a:	ff d0                	call   *%eax
  80158c:	83 c4 10             	add    $0x10,%esp
}
  80158f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801592:	c9                   	leave  
  801593:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801594:	a1 08 40 80 00       	mov    0x804008,%eax
  801599:	8b 40 48             	mov    0x48(%eax),%eax
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	53                   	push   %ebx
  8015a0:	50                   	push   %eax
  8015a1:	68 d5 2b 80 00       	push   $0x802bd5
  8015a6:	e8 e9 ec ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b3:	eb da                	jmp    80158f <read+0x5a>
		return -E_NOT_SUPP;
  8015b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ba:	eb d3                	jmp    80158f <read+0x5a>

008015bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 0c             	sub    $0xc,%esp
  8015c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d0:	39 f3                	cmp    %esi,%ebx
  8015d2:	73 25                	jae    8015f9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	89 f0                	mov    %esi,%eax
  8015d9:	29 d8                	sub    %ebx,%eax
  8015db:	50                   	push   %eax
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	03 45 0c             	add    0xc(%ebp),%eax
  8015e1:	50                   	push   %eax
  8015e2:	57                   	push   %edi
  8015e3:	e8 4d ff ff ff       	call   801535 <read>
		if (m < 0)
  8015e8:	83 c4 10             	add    $0x10,%esp
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	78 08                	js     8015f7 <readn+0x3b>
			return m;
		if (m == 0)
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	74 06                	je     8015f9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015f3:	01 c3                	add    %eax,%ebx
  8015f5:	eb d9                	jmp    8015d0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015f7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015f9:	89 d8                	mov    %ebx,%eax
  8015fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5f                   	pop    %edi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	53                   	push   %ebx
  801607:	83 ec 14             	sub    $0x14,%esp
  80160a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80160d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	53                   	push   %ebx
  801612:	e8 ad fc ff ff       	call   8012c4 <fd_lookup>
  801617:	83 c4 08             	add    $0x8,%esp
  80161a:	85 c0                	test   %eax,%eax
  80161c:	78 3a                	js     801658 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801624:	50                   	push   %eax
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	ff 30                	pushl  (%eax)
  80162a:	e8 eb fc ff ff       	call   80131a <dev_lookup>
  80162f:	83 c4 10             	add    $0x10,%esp
  801632:	85 c0                	test   %eax,%eax
  801634:	78 22                	js     801658 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80163d:	74 1e                	je     80165d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80163f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801642:	8b 52 0c             	mov    0xc(%edx),%edx
  801645:	85 d2                	test   %edx,%edx
  801647:	74 35                	je     80167e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	ff 75 10             	pushl  0x10(%ebp)
  80164f:	ff 75 0c             	pushl  0xc(%ebp)
  801652:	50                   	push   %eax
  801653:	ff d2                	call   *%edx
  801655:	83 c4 10             	add    $0x10,%esp
}
  801658:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80165d:	a1 08 40 80 00       	mov    0x804008,%eax
  801662:	8b 40 48             	mov    0x48(%eax),%eax
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	53                   	push   %ebx
  801669:	50                   	push   %eax
  80166a:	68 f1 2b 80 00       	push   $0x802bf1
  80166f:	e8 20 ec ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  801674:	83 c4 10             	add    $0x10,%esp
  801677:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80167c:	eb da                	jmp    801658 <write+0x55>
		return -E_NOT_SUPP;
  80167e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801683:	eb d3                	jmp    801658 <write+0x55>

00801685 <seek>:

int
seek(int fdnum, off_t offset)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80168b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80168e:	50                   	push   %eax
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 2d fc ff ff       	call   8012c4 <fd_lookup>
  801697:	83 c4 08             	add    $0x8,%esp
  80169a:	85 c0                	test   %eax,%eax
  80169c:	78 0e                	js     8016ac <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016a4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 14             	sub    $0x14,%esp
  8016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bb:	50                   	push   %eax
  8016bc:	53                   	push   %ebx
  8016bd:	e8 02 fc ff ff       	call   8012c4 <fd_lookup>
  8016c2:	83 c4 08             	add    $0x8,%esp
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	78 37                	js     801700 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	83 ec 08             	sub    $0x8,%esp
  8016cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cf:	50                   	push   %eax
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	ff 30                	pushl  (%eax)
  8016d5:	e8 40 fc ff ff       	call   80131a <dev_lookup>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 1f                	js     801700 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016e8:	74 1b                	je     801705 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 52 18             	mov    0x18(%edx),%edx
  8016f0:	85 d2                	test   %edx,%edx
  8016f2:	74 32                	je     801726 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	50                   	push   %eax
  8016fb:	ff d2                	call   *%edx
  8016fd:	83 c4 10             	add    $0x10,%esp
}
  801700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801703:	c9                   	leave  
  801704:	c3                   	ret    
			thisenv->env_id, fdnum);
  801705:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80170a:	8b 40 48             	mov    0x48(%eax),%eax
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	53                   	push   %ebx
  801711:	50                   	push   %eax
  801712:	68 b4 2b 80 00       	push   $0x802bb4
  801717:	e8 78 eb ff ff       	call   800294 <cprintf>
		return -E_INVAL;
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801724:	eb da                	jmp    801700 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801726:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80172b:	eb d3                	jmp    801700 <ftruncate+0x52>

0080172d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	53                   	push   %ebx
  801731:	83 ec 14             	sub    $0x14,%esp
  801734:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801737:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	e8 81 fb ff ff       	call   8012c4 <fd_lookup>
  801743:	83 c4 08             	add    $0x8,%esp
  801746:	85 c0                	test   %eax,%eax
  801748:	78 4b                	js     801795 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801750:	50                   	push   %eax
  801751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801754:	ff 30                	pushl  (%eax)
  801756:	e8 bf fb ff ff       	call   80131a <dev_lookup>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 33                	js     801795 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801765:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801769:	74 2f                	je     80179a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80176b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80176e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801775:	00 00 00 
	stat->st_isdir = 0;
  801778:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80177f:	00 00 00 
	stat->st_dev = dev;
  801782:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	53                   	push   %ebx
  80178c:	ff 75 f0             	pushl  -0x10(%ebp)
  80178f:	ff 50 14             	call   *0x14(%eax)
  801792:	83 c4 10             	add    $0x10,%esp
}
  801795:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801798:	c9                   	leave  
  801799:	c3                   	ret    
		return -E_NOT_SUPP;
  80179a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179f:	eb f4                	jmp    801795 <fstat+0x68>

008017a1 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	56                   	push   %esi
  8017a5:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	6a 00                	push   $0x0
  8017ab:	ff 75 08             	pushl  0x8(%ebp)
  8017ae:	e8 e7 01 00 00       	call   80199a <open>
  8017b3:	89 c3                	mov    %eax,%ebx
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	78 1b                	js     8017d7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017bc:	83 ec 08             	sub    $0x8,%esp
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	50                   	push   %eax
  8017c3:	e8 65 ff ff ff       	call   80172d <fstat>
  8017c8:	89 c6                	mov    %eax,%esi
	close(fd);
  8017ca:	89 1c 24             	mov    %ebx,(%esp)
  8017cd:	e8 27 fc ff ff       	call   8013f9 <close>
	return r;
  8017d2:	83 c4 10             	add    $0x10,%esp
  8017d5:	89 f3                	mov    %esi,%ebx
}
  8017d7:	89 d8                	mov    %ebx,%eax
  8017d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017dc:	5b                   	pop    %ebx
  8017dd:	5e                   	pop    %esi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	56                   	push   %esi
  8017e4:	53                   	push   %ebx
  8017e5:	89 c6                	mov    %eax,%esi
  8017e7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017e9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017f0:	74 27                	je     801819 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017f2:	6a 07                	push   $0x7
  8017f4:	68 00 50 80 00       	push   $0x805000
  8017f9:	56                   	push   %esi
  8017fa:	ff 35 00 40 80 00    	pushl  0x804000
  801800:	e8 bc f9 ff ff       	call   8011c1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801805:	83 c4 0c             	add    $0xc,%esp
  801808:	6a 00                	push   $0x0
  80180a:	53                   	push   %ebx
  80180b:	6a 00                	push   $0x0
  80180d:	e8 48 f9 ff ff       	call   80115a <ipc_recv>
}
  801812:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	6a 01                	push   $0x1
  80181e:	e8 f2 f9 ff ff       	call   801215 <ipc_find_env>
  801823:	a3 00 40 80 00       	mov    %eax,0x804000
  801828:	83 c4 10             	add    $0x10,%esp
  80182b:	eb c5                	jmp    8017f2 <fsipc+0x12>

0080182d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8b 40 0c             	mov    0xc(%eax),%eax
  801839:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801846:	ba 00 00 00 00       	mov    $0x0,%edx
  80184b:	b8 02 00 00 00       	mov    $0x2,%eax
  801850:	e8 8b ff ff ff       	call   8017e0 <fsipc>
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <devfile_flush>:
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8b 40 0c             	mov    0xc(%eax),%eax
  801863:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801868:	ba 00 00 00 00       	mov    $0x0,%edx
  80186d:	b8 06 00 00 00       	mov    $0x6,%eax
  801872:	e8 69 ff ff ff       	call   8017e0 <fsipc>
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <devfile_stat>:
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	53                   	push   %ebx
  80187d:	83 ec 04             	sub    $0x4,%esp
  801880:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 40 0c             	mov    0xc(%eax),%eax
  801889:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	b8 05 00 00 00       	mov    $0x5,%eax
  801898:	e8 43 ff ff ff       	call   8017e0 <fsipc>
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 2c                	js     8018cd <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	68 00 50 80 00       	push   $0x805000
  8018a9:	53                   	push   %ebx
  8018aa:	e8 04 f0 ff ff       	call   8008b3 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018af:	a1 80 50 80 00       	mov    0x805080,%eax
  8018b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8018bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <devfile_write>:
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 0c             	sub    $0xc,%esp
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8018e0:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8018e5:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018eb:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ee:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  8018f4:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  8018f9:	50                   	push   %eax
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	68 08 50 80 00       	push   $0x805008
  801902:	e8 3a f1 ff ff       	call   800a41 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801907:	ba 00 00 00 00       	mov    $0x0,%edx
  80190c:	b8 04 00 00 00       	mov    $0x4,%eax
  801911:	e8 ca fe ff ff       	call   8017e0 <fsipc>
}
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <devfile_read>:
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	56                   	push   %esi
  80191c:	53                   	push   %ebx
  80191d:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	8b 40 0c             	mov    0xc(%eax),%eax
  801926:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80192b:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	b8 03 00 00 00       	mov    $0x3,%eax
  80193b:	e8 a0 fe ff ff       	call   8017e0 <fsipc>
  801940:	89 c3                	mov    %eax,%ebx
  801942:	85 c0                	test   %eax,%eax
  801944:	78 1f                	js     801965 <devfile_read+0x4d>
	assert(r <= n);
  801946:	39 f0                	cmp    %esi,%eax
  801948:	77 24                	ja     80196e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80194a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80194f:	7f 33                	jg     801984 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	50                   	push   %eax
  801955:	68 00 50 80 00       	push   $0x805000
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	e8 df f0 ff ff       	call   800a41 <memmove>
	return r;
  801962:	83 c4 10             	add    $0x10,%esp
}
  801965:	89 d8                	mov    %ebx,%eax
  801967:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    
	assert(r <= n);
  80196e:	68 24 2c 80 00       	push   $0x802c24
  801973:	68 2b 2c 80 00       	push   $0x802c2b
  801978:	6a 7b                	push   $0x7b
  80197a:	68 40 2c 80 00       	push   $0x802c40
  80197f:	e8 ea 09 00 00       	call   80236e <_panic>
	assert(r <= PGSIZE);
  801984:	68 4b 2c 80 00       	push   $0x802c4b
  801989:	68 2b 2c 80 00       	push   $0x802c2b
  80198e:	6a 7c                	push   $0x7c
  801990:	68 40 2c 80 00       	push   $0x802c40
  801995:	e8 d4 09 00 00       	call   80236e <_panic>

0080199a <open>:
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	56                   	push   %esi
  80199e:	53                   	push   %ebx
  80199f:	83 ec 1c             	sub    $0x1c,%esp
  8019a2:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019a5:	56                   	push   %esi
  8019a6:	e8 d1 ee ff ff       	call   80087c <strlen>
  8019ab:	83 c4 10             	add    $0x10,%esp
  8019ae:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019b3:	7f 6c                	jg     801a21 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019b5:	83 ec 0c             	sub    $0xc,%esp
  8019b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bb:	50                   	push   %eax
  8019bc:	e8 b4 f8 ff ff       	call   801275 <fd_alloc>
  8019c1:	89 c3                	mov    %eax,%ebx
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 3c                	js     801a06 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019ca:	83 ec 08             	sub    $0x8,%esp
  8019cd:	56                   	push   %esi
  8019ce:	68 00 50 80 00       	push   $0x805000
  8019d3:	e8 db ee ff ff       	call   8008b3 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019db:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  8019e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8019e8:	e8 f3 fd ff ff       	call   8017e0 <fsipc>
  8019ed:	89 c3                	mov    %eax,%ebx
  8019ef:	83 c4 10             	add    $0x10,%esp
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 19                	js     801a0f <open+0x75>
	return fd2num(fd);
  8019f6:	83 ec 0c             	sub    $0xc,%esp
  8019f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fc:	e8 4d f8 ff ff       	call   80124e <fd2num>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	83 c4 10             	add    $0x10,%esp
}
  801a06:	89 d8                	mov    %ebx,%eax
  801a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5e                   	pop    %esi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    
		fd_close(fd, 0);
  801a0f:	83 ec 08             	sub    $0x8,%esp
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 f4             	pushl  -0xc(%ebp)
  801a17:	e8 54 f9 ff ff       	call   801370 <fd_close>
		return r;
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	eb e5                	jmp    801a06 <open+0x6c>
		return -E_BAD_PATH;
  801a21:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a26:	eb de                	jmp    801a06 <open+0x6c>

00801a28 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
  801a2b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a2e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a33:	b8 08 00 00 00       	mov    $0x8,%eax
  801a38:	e8 a3 fd ff ff       	call   8017e0 <fsipc>
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801a45:	68 57 2c 80 00       	push   $0x802c57
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	e8 61 ee ff ff       	call   8008b3 <strcpy>
	return 0;
}
  801a52:	b8 00 00 00 00       	mov    $0x0,%eax
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <devsock_close>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	83 ec 10             	sub    $0x10,%esp
  801a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a63:	53                   	push   %ebx
  801a64:	e8 d6 09 00 00       	call   80243f <pageref>
  801a69:	83 c4 10             	add    $0x10,%esp
		return 0;
  801a6c:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801a71:	83 f8 01             	cmp    $0x1,%eax
  801a74:	74 07                	je     801a7d <devsock_close+0x24>
}
  801a76:	89 d0                	mov    %edx,%eax
  801a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801a7d:	83 ec 0c             	sub    $0xc,%esp
  801a80:	ff 73 0c             	pushl  0xc(%ebx)
  801a83:	e8 b7 02 00 00       	call   801d3f <nsipc_close>
  801a88:	89 c2                	mov    %eax,%edx
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	eb e7                	jmp    801a76 <devsock_close+0x1d>

00801a8f <devsock_write>:
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	ff 75 10             	pushl  0x10(%ebp)
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	ff 70 0c             	pushl  0xc(%eax)
  801aa3:	e8 74 03 00 00       	call   801e1c <nsipc_send>
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <devsock_read>:
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 10             	pushl  0x10(%ebp)
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	ff 70 0c             	pushl  0xc(%eax)
  801abe:	e8 ed 02 00 00       	call   801db0 <nsipc_recv>
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <fd2sockid>:
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801acb:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	e8 ef f7 ff ff       	call   8012c4 <fd_lookup>
  801ad5:	83 c4 10             	add    $0x10,%esp
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	78 10                	js     801aec <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adf:	8b 0d 28 30 80 00    	mov    0x803028,%ecx
  801ae5:	39 08                	cmp    %ecx,(%eax)
  801ae7:	75 05                	jne    801aee <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801ae9:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    
		return -E_NOT_SUPP;
  801aee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801af3:	eb f7                	jmp    801aec <fd2sockid+0x27>

00801af5 <alloc_sockfd>:
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	56                   	push   %esi
  801af9:	53                   	push   %ebx
  801afa:	83 ec 1c             	sub    $0x1c,%esp
  801afd:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801aff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b02:	50                   	push   %eax
  801b03:	e8 6d f7 ff ff       	call   801275 <fd_alloc>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	83 c4 10             	add    $0x10,%esp
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	78 43                	js     801b54 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	68 07 04 00 00       	push   $0x407
  801b19:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1c:	6a 00                	push   $0x0
  801b1e:	e8 89 f1 ff ff       	call   800cac <sys_page_alloc>
  801b23:	89 c3                	mov    %eax,%ebx
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 28                	js     801b54 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801b35:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801b41:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801b44:	83 ec 0c             	sub    $0xc,%esp
  801b47:	50                   	push   %eax
  801b48:	e8 01 f7 ff ff       	call   80124e <fd2num>
  801b4d:	89 c3                	mov    %eax,%ebx
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	eb 0c                	jmp    801b60 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	56                   	push   %esi
  801b58:	e8 e2 01 00 00       	call   801d3f <nsipc_close>
		return r;
  801b5d:	83 c4 10             	add    $0x10,%esp
}
  801b60:	89 d8                	mov    %ebx,%eax
  801b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <accept>:
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	e8 4e ff ff ff       	call   801ac5 <fd2sockid>
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 1b                	js     801b96 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b7b:	83 ec 04             	sub    $0x4,%esp
  801b7e:	ff 75 10             	pushl  0x10(%ebp)
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	50                   	push   %eax
  801b85:	e8 0e 01 00 00       	call   801c98 <nsipc_accept>
  801b8a:	83 c4 10             	add    $0x10,%esp
  801b8d:	85 c0                	test   %eax,%eax
  801b8f:	78 05                	js     801b96 <accept+0x2d>
	return alloc_sockfd(r);
  801b91:	e8 5f ff ff ff       	call   801af5 <alloc_sockfd>
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <bind>:
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	e8 1f ff ff ff       	call   801ac5 <fd2sockid>
  801ba6:	85 c0                	test   %eax,%eax
  801ba8:	78 12                	js     801bbc <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	ff 75 10             	pushl  0x10(%ebp)
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	50                   	push   %eax
  801bb4:	e8 2f 01 00 00       	call   801ce8 <nsipc_bind>
  801bb9:	83 c4 10             	add    $0x10,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <shutdown>:
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	e8 f9 fe ff ff       	call   801ac5 <fd2sockid>
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	78 0f                	js     801bdf <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801bd0:	83 ec 08             	sub    $0x8,%esp
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	50                   	push   %eax
  801bd7:	e8 41 01 00 00       	call   801d1d <nsipc_shutdown>
  801bdc:	83 c4 10             	add    $0x10,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <connect>:
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	e8 d6 fe ff ff       	call   801ac5 <fd2sockid>
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 12                	js     801c05 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801bf3:	83 ec 04             	sub    $0x4,%esp
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	50                   	push   %eax
  801bfd:	e8 57 01 00 00       	call   801d59 <nsipc_connect>
  801c02:	83 c4 10             	add    $0x10,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <listen>:
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	e8 b0 fe ff ff       	call   801ac5 <fd2sockid>
  801c15:	85 c0                	test   %eax,%eax
  801c17:	78 0f                	js     801c28 <listen+0x21>
	return nsipc_listen(r, backlog);
  801c19:	83 ec 08             	sub    $0x8,%esp
  801c1c:	ff 75 0c             	pushl  0xc(%ebp)
  801c1f:	50                   	push   %eax
  801c20:	e8 69 01 00 00       	call   801d8e <nsipc_listen>
  801c25:	83 c4 10             	add    $0x10,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <socket>:

int
socket(int domain, int type, int protocol)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	ff 75 08             	pushl  0x8(%ebp)
  801c39:	e8 3c 02 00 00       	call   801e7a <nsipc_socket>
  801c3e:	83 c4 10             	add    $0x10,%esp
  801c41:	85 c0                	test   %eax,%eax
  801c43:	78 05                	js     801c4a <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801c45:	e8 ab fe ff ff       	call   801af5 <alloc_sockfd>
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 04             	sub    $0x4,%esp
  801c53:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c55:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c5c:	74 26                	je     801c84 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c5e:	6a 07                	push   $0x7
  801c60:	68 00 60 80 00       	push   $0x806000
  801c65:	53                   	push   %ebx
  801c66:	ff 35 04 40 80 00    	pushl  0x804004
  801c6c:	e8 50 f5 ff ff       	call   8011c1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c71:	83 c4 0c             	add    $0xc,%esp
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	e8 db f4 ff ff       	call   80115a <ipc_recv>
}
  801c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c82:	c9                   	leave  
  801c83:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c84:	83 ec 0c             	sub    $0xc,%esp
  801c87:	6a 02                	push   $0x2
  801c89:	e8 87 f5 ff ff       	call   801215 <ipc_find_env>
  801c8e:	a3 04 40 80 00       	mov    %eax,0x804004
  801c93:	83 c4 10             	add    $0x10,%esp
  801c96:	eb c6                	jmp    801c5e <nsipc+0x12>

00801c98 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	56                   	push   %esi
  801c9c:	53                   	push   %ebx
  801c9d:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ca8:	8b 06                	mov    (%esi),%eax
  801caa:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801caf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb4:	e8 93 ff ff ff       	call   801c4c <nsipc>
  801cb9:	89 c3                	mov    %eax,%ebx
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 20                	js     801cdf <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801cbf:	83 ec 04             	sub    $0x4,%esp
  801cc2:	ff 35 10 60 80 00    	pushl  0x806010
  801cc8:	68 00 60 80 00       	push   $0x806000
  801ccd:	ff 75 0c             	pushl  0xc(%ebp)
  801cd0:	e8 6c ed ff ff       	call   800a41 <memmove>
		*addrlen = ret->ret_addrlen;
  801cd5:	a1 10 60 80 00       	mov    0x806010,%eax
  801cda:	89 06                	mov    %eax,(%esi)
  801cdc:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    

00801ce8 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	53                   	push   %ebx
  801cec:	83 ec 08             	sub    $0x8,%esp
  801cef:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cfa:	53                   	push   %ebx
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	68 04 60 80 00       	push   $0x806004
  801d03:	e8 39 ed ff ff       	call   800a41 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d13:	e8 34 ff ff ff       	call   801c4c <nsipc>
}
  801d18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2e:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d33:	b8 03 00 00 00       	mov    $0x3,%eax
  801d38:	e8 0f ff ff ff       	call   801c4c <nsipc>
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <nsipc_close>:

int
nsipc_close(int s)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d4d:	b8 04 00 00 00       	mov    $0x4,%eax
  801d52:	e8 f5 fe ff ff       	call   801c4c <nsipc>
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 08             	sub    $0x8,%esp
  801d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d6b:	53                   	push   %ebx
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	68 04 60 80 00       	push   $0x806004
  801d74:	e8 c8 ec ff ff       	call   800a41 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d84:	e8 c3 fe ff ff       	call   801c4c <nsipc>
}
  801d89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801da4:	b8 06 00 00 00       	mov    $0x6,%eax
  801da9:	e8 9e fe ff ff       	call   801c4c <nsipc>
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dc0:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801dc6:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc9:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dce:	b8 07 00 00 00       	mov    $0x7,%eax
  801dd3:	e8 74 fe ff ff       	call   801c4c <nsipc>
  801dd8:	89 c3                	mov    %eax,%ebx
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	78 1f                	js     801dfd <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801dde:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801de3:	7f 21                	jg     801e06 <nsipc_recv+0x56>
  801de5:	39 c6                	cmp    %eax,%esi
  801de7:	7c 1d                	jl     801e06 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801de9:	83 ec 04             	sub    $0x4,%esp
  801dec:	50                   	push   %eax
  801ded:	68 00 60 80 00       	push   $0x806000
  801df2:	ff 75 0c             	pushl  0xc(%ebp)
  801df5:	e8 47 ec ff ff       	call   800a41 <memmove>
  801dfa:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801dfd:	89 d8                	mov    %ebx,%eax
  801dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e02:	5b                   	pop    %ebx
  801e03:	5e                   	pop    %esi
  801e04:	5d                   	pop    %ebp
  801e05:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801e06:	68 63 2c 80 00       	push   $0x802c63
  801e0b:	68 2b 2c 80 00       	push   $0x802c2b
  801e10:	6a 62                	push   $0x62
  801e12:	68 78 2c 80 00       	push   $0x802c78
  801e17:	e8 52 05 00 00       	call   80236e <_panic>

00801e1c <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	53                   	push   %ebx
  801e20:	83 ec 04             	sub    $0x4,%esp
  801e23:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e2e:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e34:	7f 2e                	jg     801e64 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	53                   	push   %ebx
  801e3a:	ff 75 0c             	pushl  0xc(%ebp)
  801e3d:	68 0c 60 80 00       	push   $0x80600c
  801e42:	e8 fa eb ff ff       	call   800a41 <memmove>
	nsipcbuf.send.req_size = size;
  801e47:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e50:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e55:	b8 08 00 00 00       	mov    $0x8,%eax
  801e5a:	e8 ed fd ff ff       	call   801c4c <nsipc>
}
  801e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    
	assert(size < 1600);
  801e64:	68 84 2c 80 00       	push   $0x802c84
  801e69:	68 2b 2c 80 00       	push   $0x802c2b
  801e6e:	6a 6d                	push   $0x6d
  801e70:	68 78 2c 80 00       	push   $0x802c78
  801e75:	e8 f4 04 00 00       	call   80236e <_panic>

00801e7a <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e90:	8b 45 10             	mov    0x10(%ebp),%eax
  801e93:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e98:	b8 09 00 00 00       	mov    $0x9,%eax
  801e9d:	e8 aa fd ff ff       	call   801c4c <nsipc>
}
  801ea2:	c9                   	leave  
  801ea3:	c3                   	ret    

00801ea4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	56                   	push   %esi
  801ea8:	53                   	push   %ebx
  801ea9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eac:	83 ec 0c             	sub    $0xc,%esp
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	e8 a7 f3 ff ff       	call   80125e <fd2data>
  801eb7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801eb9:	83 c4 08             	add    $0x8,%esp
  801ebc:	68 90 2c 80 00       	push   $0x802c90
  801ec1:	53                   	push   %ebx
  801ec2:	e8 ec e9 ff ff       	call   8008b3 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ec7:	8b 46 04             	mov    0x4(%esi),%eax
  801eca:	2b 06                	sub    (%esi),%eax
  801ecc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ed2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ed9:	00 00 00 
	stat->st_dev = &devpipe;
  801edc:	c7 83 88 00 00 00 44 	movl   $0x803044,0x88(%ebx)
  801ee3:	30 80 00 
	return 0;
}
  801ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eeb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801eee:	5b                   	pop    %ebx
  801eef:	5e                   	pop    %esi
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    

00801ef2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	53                   	push   %ebx
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801efc:	53                   	push   %ebx
  801efd:	6a 00                	push   $0x0
  801eff:	e8 2d ee ff ff       	call   800d31 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f04:	89 1c 24             	mov    %ebx,(%esp)
  801f07:	e8 52 f3 ff ff       	call   80125e <fd2data>
  801f0c:	83 c4 08             	add    $0x8,%esp
  801f0f:	50                   	push   %eax
  801f10:	6a 00                	push   $0x0
  801f12:	e8 1a ee ff ff       	call   800d31 <sys_page_unmap>
}
  801f17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <_pipeisclosed>:
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	57                   	push   %edi
  801f20:	56                   	push   %esi
  801f21:	53                   	push   %ebx
  801f22:	83 ec 1c             	sub    $0x1c,%esp
  801f25:	89 c7                	mov    %eax,%edi
  801f27:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801f29:	a1 08 40 80 00       	mov    0x804008,%eax
  801f2e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f31:	83 ec 0c             	sub    $0xc,%esp
  801f34:	57                   	push   %edi
  801f35:	e8 05 05 00 00       	call   80243f <pageref>
  801f3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f3d:	89 34 24             	mov    %esi,(%esp)
  801f40:	e8 fa 04 00 00       	call   80243f <pageref>
		nn = thisenv->env_runs;
  801f45:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f4b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	39 cb                	cmp    %ecx,%ebx
  801f53:	74 1b                	je     801f70 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801f55:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f58:	75 cf                	jne    801f29 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f5a:	8b 42 58             	mov    0x58(%edx),%eax
  801f5d:	6a 01                	push   $0x1
  801f5f:	50                   	push   %eax
  801f60:	53                   	push   %ebx
  801f61:	68 97 2c 80 00       	push   $0x802c97
  801f66:	e8 29 e3 ff ff       	call   800294 <cprintf>
  801f6b:	83 c4 10             	add    $0x10,%esp
  801f6e:	eb b9                	jmp    801f29 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801f70:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801f73:	0f 94 c0             	sete   %al
  801f76:	0f b6 c0             	movzbl %al,%eax
}
  801f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    

00801f81 <devpipe_write>:
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	57                   	push   %edi
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
  801f87:	83 ec 28             	sub    $0x28,%esp
  801f8a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801f8d:	56                   	push   %esi
  801f8e:	e8 cb f2 ff ff       	call   80125e <fd2data>
  801f93:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f95:	83 c4 10             	add    $0x10,%esp
  801f98:	bf 00 00 00 00       	mov    $0x0,%edi
  801f9d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fa0:	74 4f                	je     801ff1 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fa2:	8b 43 04             	mov    0x4(%ebx),%eax
  801fa5:	8b 0b                	mov    (%ebx),%ecx
  801fa7:	8d 51 20             	lea    0x20(%ecx),%edx
  801faa:	39 d0                	cmp    %edx,%eax
  801fac:	72 14                	jb     801fc2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801fae:	89 da                	mov    %ebx,%edx
  801fb0:	89 f0                	mov    %esi,%eax
  801fb2:	e8 65 ff ff ff       	call   801f1c <_pipeisclosed>
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	75 3a                	jne    801ff5 <devpipe_write+0x74>
			sys_yield();
  801fbb:	e8 cd ec ff ff       	call   800c8d <sys_yield>
  801fc0:	eb e0                	jmp    801fa2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc5:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fc9:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fcc:	89 c2                	mov    %eax,%edx
  801fce:	c1 fa 1f             	sar    $0x1f,%edx
  801fd1:	89 d1                	mov    %edx,%ecx
  801fd3:	c1 e9 1b             	shr    $0x1b,%ecx
  801fd6:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801fd9:	83 e2 1f             	and    $0x1f,%edx
  801fdc:	29 ca                	sub    %ecx,%edx
  801fde:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801fe2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801fe6:	83 c0 01             	add    $0x1,%eax
  801fe9:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801fec:	83 c7 01             	add    $0x1,%edi
  801fef:	eb ac                	jmp    801f9d <devpipe_write+0x1c>
	return i;
  801ff1:	89 f8                	mov    %edi,%eax
  801ff3:	eb 05                	jmp    801ffa <devpipe_write+0x79>
				return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ffd:	5b                   	pop    %ebx
  801ffe:	5e                   	pop    %esi
  801fff:	5f                   	pop    %edi
  802000:	5d                   	pop    %ebp
  802001:	c3                   	ret    

00802002 <devpipe_read>:
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	57                   	push   %edi
  802006:	56                   	push   %esi
  802007:	53                   	push   %ebx
  802008:	83 ec 18             	sub    $0x18,%esp
  80200b:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80200e:	57                   	push   %edi
  80200f:	e8 4a f2 ff ff       	call   80125e <fd2data>
  802014:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802016:	83 c4 10             	add    $0x10,%esp
  802019:	be 00 00 00 00       	mov    $0x0,%esi
  80201e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802021:	74 47                	je     80206a <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  802023:	8b 03                	mov    (%ebx),%eax
  802025:	3b 43 04             	cmp    0x4(%ebx),%eax
  802028:	75 22                	jne    80204c <devpipe_read+0x4a>
			if (i > 0)
  80202a:	85 f6                	test   %esi,%esi
  80202c:	75 14                	jne    802042 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  80202e:	89 da                	mov    %ebx,%edx
  802030:	89 f8                	mov    %edi,%eax
  802032:	e8 e5 fe ff ff       	call   801f1c <_pipeisclosed>
  802037:	85 c0                	test   %eax,%eax
  802039:	75 33                	jne    80206e <devpipe_read+0x6c>
			sys_yield();
  80203b:	e8 4d ec ff ff       	call   800c8d <sys_yield>
  802040:	eb e1                	jmp    802023 <devpipe_read+0x21>
				return i;
  802042:	89 f0                	mov    %esi,%eax
}
  802044:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802047:	5b                   	pop    %ebx
  802048:	5e                   	pop    %esi
  802049:	5f                   	pop    %edi
  80204a:	5d                   	pop    %ebp
  80204b:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80204c:	99                   	cltd   
  80204d:	c1 ea 1b             	shr    $0x1b,%edx
  802050:	01 d0                	add    %edx,%eax
  802052:	83 e0 1f             	and    $0x1f,%eax
  802055:	29 d0                	sub    %edx,%eax
  802057:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  80205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80205f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802062:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  802065:	83 c6 01             	add    $0x1,%esi
  802068:	eb b4                	jmp    80201e <devpipe_read+0x1c>
	return i;
  80206a:	89 f0                	mov    %esi,%eax
  80206c:	eb d6                	jmp    802044 <devpipe_read+0x42>
				return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	eb cf                	jmp    802044 <devpipe_read+0x42>

00802075 <pipe>:
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	56                   	push   %esi
  802079:	53                   	push   %ebx
  80207a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80207d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802080:	50                   	push   %eax
  802081:	e8 ef f1 ff ff       	call   801275 <fd_alloc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	85 c0                	test   %eax,%eax
  80208d:	78 5b                	js     8020ea <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	68 07 04 00 00       	push   $0x407
  802097:	ff 75 f4             	pushl  -0xc(%ebp)
  80209a:	6a 00                	push   $0x0
  80209c:	e8 0b ec ff ff       	call   800cac <sys_page_alloc>
  8020a1:	89 c3                	mov    %eax,%ebx
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	78 40                	js     8020ea <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020b0:	50                   	push   %eax
  8020b1:	e8 bf f1 ff ff       	call   801275 <fd_alloc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	83 c4 10             	add    $0x10,%esp
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	78 1b                	js     8020da <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bf:	83 ec 04             	sub    $0x4,%esp
  8020c2:	68 07 04 00 00       	push   $0x407
  8020c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8020ca:	6a 00                	push   $0x0
  8020cc:	e8 db eb ff ff       	call   800cac <sys_page_alloc>
  8020d1:	89 c3                	mov    %eax,%ebx
  8020d3:	83 c4 10             	add    $0x10,%esp
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	79 19                	jns    8020f3 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  8020da:	83 ec 08             	sub    $0x8,%esp
  8020dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e0:	6a 00                	push   $0x0
  8020e2:	e8 4a ec ff ff       	call   800d31 <sys_page_unmap>
  8020e7:	83 c4 10             	add    $0x10,%esp
}
  8020ea:	89 d8                	mov    %ebx,%eax
  8020ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020ef:	5b                   	pop    %ebx
  8020f0:	5e                   	pop    %esi
  8020f1:	5d                   	pop    %ebp
  8020f2:	c3                   	ret    
	va = fd2data(fd0);
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8020f9:	e8 60 f1 ff ff       	call   80125e <fd2data>
  8020fe:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802100:	83 c4 0c             	add    $0xc,%esp
  802103:	68 07 04 00 00       	push   $0x407
  802108:	50                   	push   %eax
  802109:	6a 00                	push   $0x0
  80210b:	e8 9c eb ff ff       	call   800cac <sys_page_alloc>
  802110:	89 c3                	mov    %eax,%ebx
  802112:	83 c4 10             	add    $0x10,%esp
  802115:	85 c0                	test   %eax,%eax
  802117:	0f 88 8c 00 00 00    	js     8021a9 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211d:	83 ec 0c             	sub    $0xc,%esp
  802120:	ff 75 f0             	pushl  -0x10(%ebp)
  802123:	e8 36 f1 ff ff       	call   80125e <fd2data>
  802128:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80212f:	50                   	push   %eax
  802130:	6a 00                	push   $0x0
  802132:	56                   	push   %esi
  802133:	6a 00                	push   $0x0
  802135:	e8 b5 eb ff ff       	call   800cef <sys_page_map>
  80213a:	89 c3                	mov    %eax,%ebx
  80213c:	83 c4 20             	add    $0x20,%esp
  80213f:	85 c0                	test   %eax,%eax
  802141:	78 58                	js     80219b <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 15 44 30 80 00    	mov    0x803044,%edx
  80214c:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215b:	8b 15 44 30 80 00    	mov    0x803044,%edx
  802161:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	ff 75 f4             	pushl  -0xc(%ebp)
  802173:	e8 d6 f0 ff ff       	call   80124e <fd2num>
  802178:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80217b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80217d:	83 c4 04             	add    $0x4,%esp
  802180:	ff 75 f0             	pushl  -0x10(%ebp)
  802183:	e8 c6 f0 ff ff       	call   80124e <fd2num>
  802188:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80218b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	bb 00 00 00 00       	mov    $0x0,%ebx
  802196:	e9 4f ff ff ff       	jmp    8020ea <pipe+0x75>
	sys_page_unmap(0, va);
  80219b:	83 ec 08             	sub    $0x8,%esp
  80219e:	56                   	push   %esi
  80219f:	6a 00                	push   $0x0
  8021a1:	e8 8b eb ff ff       	call   800d31 <sys_page_unmap>
  8021a6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8021a9:	83 ec 08             	sub    $0x8,%esp
  8021ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8021af:	6a 00                	push   $0x0
  8021b1:	e8 7b eb ff ff       	call   800d31 <sys_page_unmap>
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	e9 1c ff ff ff       	jmp    8020da <pipe+0x65>

008021be <pipeisclosed>:
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c7:	50                   	push   %eax
  8021c8:	ff 75 08             	pushl  0x8(%ebp)
  8021cb:	e8 f4 f0 ff ff       	call   8012c4 <fd_lookup>
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	78 18                	js     8021ef <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8021d7:	83 ec 0c             	sub    $0xc,%esp
  8021da:	ff 75 f4             	pushl  -0xc(%ebp)
  8021dd:	e8 7c f0 ff ff       	call   80125e <fd2data>
	return _pipeisclosed(fd, p);
  8021e2:	89 c2                	mov    %eax,%edx
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	e8 30 fd ff ff       	call   801f1c <_pipeisclosed>
  8021ec:	83 c4 10             	add    $0x10,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    

008021fb <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802201:	68 af 2c 80 00       	push   $0x802caf
  802206:	ff 75 0c             	pushl  0xc(%ebp)
  802209:	e8 a5 e6 ff ff       	call   8008b3 <strcpy>
	return 0;
}
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <devcons_write>:
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	57                   	push   %edi
  802219:	56                   	push   %esi
  80221a:	53                   	push   %ebx
  80221b:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802221:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802226:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80222c:	eb 2f                	jmp    80225d <devcons_write+0x48>
		m = n - tot;
  80222e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802231:	29 f3                	sub    %esi,%ebx
  802233:	83 fb 7f             	cmp    $0x7f,%ebx
  802236:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80223b:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80223e:	83 ec 04             	sub    $0x4,%esp
  802241:	53                   	push   %ebx
  802242:	89 f0                	mov    %esi,%eax
  802244:	03 45 0c             	add    0xc(%ebp),%eax
  802247:	50                   	push   %eax
  802248:	57                   	push   %edi
  802249:	e8 f3 e7 ff ff       	call   800a41 <memmove>
		sys_cputs(buf, m);
  80224e:	83 c4 08             	add    $0x8,%esp
  802251:	53                   	push   %ebx
  802252:	57                   	push   %edi
  802253:	e8 98 e9 ff ff       	call   800bf0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802258:	01 de                	add    %ebx,%esi
  80225a:	83 c4 10             	add    $0x10,%esp
  80225d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802260:	72 cc                	jb     80222e <devcons_write+0x19>
}
  802262:	89 f0                	mov    %esi,%eax
  802264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    

0080226c <devcons_read>:
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 08             	sub    $0x8,%esp
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802277:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80227b:	75 07                	jne    802284 <devcons_read+0x18>
}
  80227d:	c9                   	leave  
  80227e:	c3                   	ret    
		sys_yield();
  80227f:	e8 09 ea ff ff       	call   800c8d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  802284:	e8 85 e9 ff ff       	call   800c0e <sys_cgetc>
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 f2                	je     80227f <devcons_read+0x13>
	if (c < 0)
  80228d:	85 c0                	test   %eax,%eax
  80228f:	78 ec                	js     80227d <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  802291:	83 f8 04             	cmp    $0x4,%eax
  802294:	74 0c                	je     8022a2 <devcons_read+0x36>
	*(char*)vbuf = c;
  802296:	8b 55 0c             	mov    0xc(%ebp),%edx
  802299:	88 02                	mov    %al,(%edx)
	return 1;
  80229b:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a0:	eb db                	jmp    80227d <devcons_read+0x11>
		return 0;
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a7:	eb d4                	jmp    80227d <devcons_read+0x11>

008022a9 <cputchar>:
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8022b5:	6a 01                	push   $0x1
  8022b7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022ba:	50                   	push   %eax
  8022bb:	e8 30 e9 ff ff       	call   800bf0 <sys_cputs>
}
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <getchar>:
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8022cb:	6a 01                	push   $0x1
  8022cd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022d0:	50                   	push   %eax
  8022d1:	6a 00                	push   $0x0
  8022d3:	e8 5d f2 ff ff       	call   801535 <read>
	if (r < 0)
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	78 08                	js     8022e7 <getchar+0x22>
	if (r < 1)
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	7e 06                	jle    8022e9 <getchar+0x24>
	return c;
  8022e3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    
		return -E_EOF;
  8022e9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022ee:	eb f7                	jmp    8022e7 <getchar+0x22>

008022f0 <iscons>:
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022f9:	50                   	push   %eax
  8022fa:	ff 75 08             	pushl  0x8(%ebp)
  8022fd:	e8 c2 ef ff ff       	call   8012c4 <fd_lookup>
  802302:	83 c4 10             	add    $0x10,%esp
  802305:	85 c0                	test   %eax,%eax
  802307:	78 11                	js     80231a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 15 60 30 80 00    	mov    0x803060,%edx
  802312:	39 10                	cmp    %edx,(%eax)
  802314:	0f 94 c0             	sete   %al
  802317:	0f b6 c0             	movzbl %al,%eax
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <opencons>:
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
  80231f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802325:	50                   	push   %eax
  802326:	e8 4a ef ff ff       	call   801275 <fd_alloc>
  80232b:	83 c4 10             	add    $0x10,%esp
  80232e:	85 c0                	test   %eax,%eax
  802330:	78 3a                	js     80236c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802332:	83 ec 04             	sub    $0x4,%esp
  802335:	68 07 04 00 00       	push   $0x407
  80233a:	ff 75 f4             	pushl  -0xc(%ebp)
  80233d:	6a 00                	push   $0x0
  80233f:	e8 68 e9 ff ff       	call   800cac <sys_page_alloc>
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	85 c0                	test   %eax,%eax
  802349:	78 21                	js     80236c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 15 60 30 80 00    	mov    0x803060,%edx
  802354:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802360:	83 ec 0c             	sub    $0xc,%esp
  802363:	50                   	push   %eax
  802364:	e8 e5 ee ff ff       	call   80124e <fd2num>
  802369:	83 c4 10             	add    $0x10,%esp
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	56                   	push   %esi
  802372:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  802373:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802376:	8b 35 08 30 80 00    	mov    0x803008,%esi
  80237c:	e8 ed e8 ff ff       	call   800c6e <sys_getenvid>
  802381:	83 ec 0c             	sub    $0xc,%esp
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	56                   	push   %esi
  80238b:	50                   	push   %eax
  80238c:	68 bc 2c 80 00       	push   $0x802cbc
  802391:	e8 fe de ff ff       	call   800294 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802396:	83 c4 18             	add    $0x18,%esp
  802399:	53                   	push   %ebx
  80239a:	ff 75 10             	pushl  0x10(%ebp)
  80239d:	e8 a1 de ff ff       	call   800243 <vcprintf>
	cprintf("\n");
  8023a2:	c7 04 24 a8 2c 80 00 	movl   $0x802ca8,(%esp)
  8023a9:	e8 e6 de ff ff       	call   800294 <cprintf>
  8023ae:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023b1:	cc                   	int3   
  8023b2:	eb fd                	jmp    8023b1 <_panic+0x43>

008023b4 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  8023ba:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8023c1:	74 0a                	je     8023cd <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  8023cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8023d2:	8b 40 48             	mov    0x48(%eax),%eax
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	6a 07                	push   $0x7
  8023da:	68 00 f0 bf ee       	push   $0xeebff000
  8023df:	50                   	push   %eax
  8023e0:	e8 c7 e8 ff ff       	call   800cac <sys_page_alloc>
  8023e5:	83 c4 10             	add    $0x10,%esp
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	78 1b                	js     802407 <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8023ec:	a1 08 40 80 00       	mov    0x804008,%eax
  8023f1:	8b 40 48             	mov    0x48(%eax),%eax
  8023f4:	83 ec 08             	sub    $0x8,%esp
  8023f7:	68 19 24 80 00       	push   $0x802419
  8023fc:	50                   	push   %eax
  8023fd:	e8 f5 e9 ff ff       	call   800df7 <sys_env_set_pgfault_upcall>
  802402:	83 c4 10             	add    $0x10,%esp
  802405:	eb bc                	jmp    8023c3 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  802407:	50                   	push   %eax
  802408:	68 e0 2c 80 00       	push   $0x802ce0
  80240d:	6a 22                	push   $0x22
  80240f:	68 f8 2c 80 00       	push   $0x802cf8
  802414:	e8 55 ff ff ff       	call   80236e <_panic>

00802419 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802419:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80241a:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  80241f:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802421:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802424:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  802428:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  80242b:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  80242f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802433:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802435:	83 c4 08             	add    $0x8,%esp
	popal
  802438:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  802439:	83 c4 04             	add    $0x4,%esp
	popfl
  80243c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80243d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80243e:	c3                   	ret    

0080243f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802445:	89 d0                	mov    %edx,%eax
  802447:	c1 e8 16             	shr    $0x16,%eax
  80244a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802456:	f6 c1 01             	test   $0x1,%cl
  802459:	74 1d                	je     802478 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80245b:	c1 ea 0c             	shr    $0xc,%edx
  80245e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802465:	f6 c2 01             	test   $0x1,%dl
  802468:	74 0e                	je     802478 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80246a:	c1 ea 0c             	shr    $0xc,%edx
  80246d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802474:	ef 
  802475:	0f b7 c0             	movzwl %ax,%eax
}
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    
  80247a:	66 90                	xchg   %ax,%ax
  80247c:	66 90                	xchg   %ax,%ax
  80247e:	66 90                	xchg   %ax,%ax

00802480 <__udivdi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80248b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80248f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802493:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802497:	85 d2                	test   %edx,%edx
  802499:	75 35                	jne    8024d0 <__udivdi3+0x50>
  80249b:	39 f3                	cmp    %esi,%ebx
  80249d:	0f 87 bd 00 00 00    	ja     802560 <__udivdi3+0xe0>
  8024a3:	85 db                	test   %ebx,%ebx
  8024a5:	89 d9                	mov    %ebx,%ecx
  8024a7:	75 0b                	jne    8024b4 <__udivdi3+0x34>
  8024a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ae:	31 d2                	xor    %edx,%edx
  8024b0:	f7 f3                	div    %ebx
  8024b2:	89 c1                	mov    %eax,%ecx
  8024b4:	31 d2                	xor    %edx,%edx
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	f7 f1                	div    %ecx
  8024ba:	89 c6                	mov    %eax,%esi
  8024bc:	89 e8                	mov    %ebp,%eax
  8024be:	89 f7                	mov    %esi,%edi
  8024c0:	f7 f1                	div    %ecx
  8024c2:	89 fa                	mov    %edi,%edx
  8024c4:	83 c4 1c             	add    $0x1c,%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5f                   	pop    %edi
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    
  8024cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d0:	39 f2                	cmp    %esi,%edx
  8024d2:	77 7c                	ja     802550 <__udivdi3+0xd0>
  8024d4:	0f bd fa             	bsr    %edx,%edi
  8024d7:	83 f7 1f             	xor    $0x1f,%edi
  8024da:	0f 84 98 00 00 00    	je     802578 <__udivdi3+0xf8>
  8024e0:	89 f9                	mov    %edi,%ecx
  8024e2:	b8 20 00 00 00       	mov    $0x20,%eax
  8024e7:	29 f8                	sub    %edi,%eax
  8024e9:	d3 e2                	shl    %cl,%edx
  8024eb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024ef:	89 c1                	mov    %eax,%ecx
  8024f1:	89 da                	mov    %ebx,%edx
  8024f3:	d3 ea                	shr    %cl,%edx
  8024f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f9:	09 d1                	or     %edx,%ecx
  8024fb:	89 f2                	mov    %esi,%edx
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 f9                	mov    %edi,%ecx
  802503:	d3 e3                	shl    %cl,%ebx
  802505:	89 c1                	mov    %eax,%ecx
  802507:	d3 ea                	shr    %cl,%edx
  802509:	89 f9                	mov    %edi,%ecx
  80250b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80250f:	d3 e6                	shl    %cl,%esi
  802511:	89 eb                	mov    %ebp,%ebx
  802513:	89 c1                	mov    %eax,%ecx
  802515:	d3 eb                	shr    %cl,%ebx
  802517:	09 de                	or     %ebx,%esi
  802519:	89 f0                	mov    %esi,%eax
  80251b:	f7 74 24 08          	divl   0x8(%esp)
  80251f:	89 d6                	mov    %edx,%esi
  802521:	89 c3                	mov    %eax,%ebx
  802523:	f7 64 24 0c          	mull   0xc(%esp)
  802527:	39 d6                	cmp    %edx,%esi
  802529:	72 0c                	jb     802537 <__udivdi3+0xb7>
  80252b:	89 f9                	mov    %edi,%ecx
  80252d:	d3 e5                	shl    %cl,%ebp
  80252f:	39 c5                	cmp    %eax,%ebp
  802531:	73 5d                	jae    802590 <__udivdi3+0x110>
  802533:	39 d6                	cmp    %edx,%esi
  802535:	75 59                	jne    802590 <__udivdi3+0x110>
  802537:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80253a:	31 ff                	xor    %edi,%edi
  80253c:	89 fa                	mov    %edi,%edx
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d 76 00             	lea    0x0(%esi),%esi
  802549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802550:	31 ff                	xor    %edi,%edi
  802552:	31 c0                	xor    %eax,%eax
  802554:	89 fa                	mov    %edi,%edx
  802556:	83 c4 1c             	add    $0x1c,%esp
  802559:	5b                   	pop    %ebx
  80255a:	5e                   	pop    %esi
  80255b:	5f                   	pop    %edi
  80255c:	5d                   	pop    %ebp
  80255d:	c3                   	ret    
  80255e:	66 90                	xchg   %ax,%ax
  802560:	31 ff                	xor    %edi,%edi
  802562:	89 e8                	mov    %ebp,%eax
  802564:	89 f2                	mov    %esi,%edx
  802566:	f7 f3                	div    %ebx
  802568:	89 fa                	mov    %edi,%edx
  80256a:	83 c4 1c             	add    $0x1c,%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5e                   	pop    %esi
  80256f:	5f                   	pop    %edi
  802570:	5d                   	pop    %ebp
  802571:	c3                   	ret    
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	39 f2                	cmp    %esi,%edx
  80257a:	72 06                	jb     802582 <__udivdi3+0x102>
  80257c:	31 c0                	xor    %eax,%eax
  80257e:	39 eb                	cmp    %ebp,%ebx
  802580:	77 d2                	ja     802554 <__udivdi3+0xd4>
  802582:	b8 01 00 00 00       	mov    $0x1,%eax
  802587:	eb cb                	jmp    802554 <__udivdi3+0xd4>
  802589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802590:	89 d8                	mov    %ebx,%eax
  802592:	31 ff                	xor    %edi,%edi
  802594:	eb be                	jmp    802554 <__udivdi3+0xd4>
  802596:	66 90                	xchg   %ax,%ax
  802598:	66 90                	xchg   %ax,%ax
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	53                   	push   %ebx
  8025a4:	83 ec 1c             	sub    $0x1c,%esp
  8025a7:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  8025ab:	8b 74 24 30          	mov    0x30(%esp),%esi
  8025af:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8025b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025b7:	85 ed                	test   %ebp,%ebp
  8025b9:	89 f0                	mov    %esi,%eax
  8025bb:	89 da                	mov    %ebx,%edx
  8025bd:	75 19                	jne    8025d8 <__umoddi3+0x38>
  8025bf:	39 df                	cmp    %ebx,%edi
  8025c1:	0f 86 b1 00 00 00    	jbe    802678 <__umoddi3+0xd8>
  8025c7:	f7 f7                	div    %edi
  8025c9:	89 d0                	mov    %edx,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	83 c4 1c             	add    $0x1c,%esp
  8025d0:	5b                   	pop    %ebx
  8025d1:	5e                   	pop    %esi
  8025d2:	5f                   	pop    %edi
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    
  8025d5:	8d 76 00             	lea    0x0(%esi),%esi
  8025d8:	39 dd                	cmp    %ebx,%ebp
  8025da:	77 f1                	ja     8025cd <__umoddi3+0x2d>
  8025dc:	0f bd cd             	bsr    %ebp,%ecx
  8025df:	83 f1 1f             	xor    $0x1f,%ecx
  8025e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025e6:	0f 84 b4 00 00 00    	je     8026a0 <__umoddi3+0x100>
  8025ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8025f1:	89 c2                	mov    %eax,%edx
  8025f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f7:	29 c2                	sub    %eax,%edx
  8025f9:	89 c1                	mov    %eax,%ecx
  8025fb:	89 f8                	mov    %edi,%eax
  8025fd:	d3 e5                	shl    %cl,%ebp
  8025ff:	89 d1                	mov    %edx,%ecx
  802601:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802605:	d3 e8                	shr    %cl,%eax
  802607:	09 c5                	or     %eax,%ebp
  802609:	8b 44 24 04          	mov    0x4(%esp),%eax
  80260d:	89 c1                	mov    %eax,%ecx
  80260f:	d3 e7                	shl    %cl,%edi
  802611:	89 d1                	mov    %edx,%ecx
  802613:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802617:	89 df                	mov    %ebx,%edi
  802619:	d3 ef                	shr    %cl,%edi
  80261b:	89 c1                	mov    %eax,%ecx
  80261d:	89 f0                	mov    %esi,%eax
  80261f:	d3 e3                	shl    %cl,%ebx
  802621:	89 d1                	mov    %edx,%ecx
  802623:	89 fa                	mov    %edi,%edx
  802625:	d3 e8                	shr    %cl,%eax
  802627:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80262c:	09 d8                	or     %ebx,%eax
  80262e:	f7 f5                	div    %ebp
  802630:	d3 e6                	shl    %cl,%esi
  802632:	89 d1                	mov    %edx,%ecx
  802634:	f7 64 24 08          	mull   0x8(%esp)
  802638:	39 d1                	cmp    %edx,%ecx
  80263a:	89 c3                	mov    %eax,%ebx
  80263c:	89 d7                	mov    %edx,%edi
  80263e:	72 06                	jb     802646 <__umoddi3+0xa6>
  802640:	75 0e                	jne    802650 <__umoddi3+0xb0>
  802642:	39 c6                	cmp    %eax,%esi
  802644:	73 0a                	jae    802650 <__umoddi3+0xb0>
  802646:	2b 44 24 08          	sub    0x8(%esp),%eax
  80264a:	19 ea                	sbb    %ebp,%edx
  80264c:	89 d7                	mov    %edx,%edi
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	89 ca                	mov    %ecx,%edx
  802652:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802657:	29 de                	sub    %ebx,%esi
  802659:	19 fa                	sbb    %edi,%edx
  80265b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80265f:	89 d0                	mov    %edx,%eax
  802661:	d3 e0                	shl    %cl,%eax
  802663:	89 d9                	mov    %ebx,%ecx
  802665:	d3 ee                	shr    %cl,%esi
  802667:	d3 ea                	shr    %cl,%edx
  802669:	09 f0                	or     %esi,%eax
  80266b:	83 c4 1c             	add    $0x1c,%esp
  80266e:	5b                   	pop    %ebx
  80266f:	5e                   	pop    %esi
  802670:	5f                   	pop    %edi
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    
  802673:	90                   	nop
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	85 ff                	test   %edi,%edi
  80267a:	89 f9                	mov    %edi,%ecx
  80267c:	75 0b                	jne    802689 <__umoddi3+0xe9>
  80267e:	b8 01 00 00 00       	mov    $0x1,%eax
  802683:	31 d2                	xor    %edx,%edx
  802685:	f7 f7                	div    %edi
  802687:	89 c1                	mov    %eax,%ecx
  802689:	89 d8                	mov    %ebx,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	f7 f1                	div    %ecx
  80268f:	89 f0                	mov    %esi,%eax
  802691:	f7 f1                	div    %ecx
  802693:	e9 31 ff ff ff       	jmp    8025c9 <__umoddi3+0x29>
  802698:	90                   	nop
  802699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026a0:	39 dd                	cmp    %ebx,%ebp
  8026a2:	72 08                	jb     8026ac <__umoddi3+0x10c>
  8026a4:	39 f7                	cmp    %esi,%edi
  8026a6:	0f 87 21 ff ff ff    	ja     8025cd <__umoddi3+0x2d>
  8026ac:	89 da                	mov    %ebx,%edx
  8026ae:	89 f0                	mov    %esi,%eax
  8026b0:	29 f8                	sub    %edi,%eax
  8026b2:	19 ea                	sbb    %ebp,%edx
  8026b4:	e9 14 ff ff ff       	jmp    8025cd <__umoddi3+0x2d>

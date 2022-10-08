
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 d2 00 00 00       	call   800103 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 63 10 00 00       	call   8010a4 <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	75 74                	jne    8000bc <umain+0x89>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  800048:	83 ec 04             	sub    $0x4,%esp
  80004b:	6a 00                	push   $0x0
  80004d:	6a 00                	push   $0x0
  80004f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	e8 66 10 00 00       	call   8010be <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  800058:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  80005e:	8b 7b 48             	mov    0x48(%ebx),%edi
  800061:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800064:	a1 08 40 80 00       	mov    0x804008,%eax
  800069:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80006c:	e8 61 0b 00 00       	call   800bd2 <sys_getenvid>
  800071:	83 c4 08             	add    $0x8,%esp
  800074:	57                   	push   %edi
  800075:	53                   	push   %ebx
  800076:	56                   	push   %esi
  800077:	ff 75 d4             	pushl  -0x2c(%ebp)
  80007a:	50                   	push   %eax
  80007b:	68 50 26 80 00       	push   $0x802650
  800080:	e8 73 01 00 00       	call   8001f8 <cprintf>
		if (val == 10)
  800085:	a1 08 40 80 00       	mov    0x804008,%eax
  80008a:	83 c4 20             	add    $0x20,%esp
  80008d:	83 f8 0a             	cmp    $0xa,%eax
  800090:	74 22                	je     8000b4 <umain+0x81>
			return;
		++val;
  800092:	83 c0 01             	add    $0x1,%eax
  800095:	a3 08 40 80 00       	mov    %eax,0x804008
		ipc_send(who, 0, 0, 0);
  80009a:	6a 00                	push   $0x0
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a3:	e8 7d 10 00 00       	call   801125 <ipc_send>
		if (val == 10)
  8000a8:	83 c4 10             	add    $0x10,%esp
  8000ab:	83 3d 08 40 80 00 0a 	cmpl   $0xa,0x804008
  8000b2:	75 94                	jne    800048 <umain+0x15>
			return;
	}

}
  8000b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b7:	5b                   	pop    %ebx
  8000b8:	5e                   	pop    %esi
  8000b9:	5f                   	pop    %edi
  8000ba:	5d                   	pop    %ebp
  8000bb:	c3                   	ret    
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  8000bc:	8b 1d 0c 40 80 00    	mov    0x80400c,%ebx
  8000c2:	e8 0b 0b 00 00       	call   800bd2 <sys_getenvid>
  8000c7:	83 ec 04             	sub    $0x4,%esp
  8000ca:	53                   	push   %ebx
  8000cb:	50                   	push   %eax
  8000cc:	68 20 26 80 00       	push   $0x802620
  8000d1:	e8 22 01 00 00       	call   8001f8 <cprintf>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  8000d6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8000d9:	e8 f4 0a 00 00       	call   800bd2 <sys_getenvid>
  8000de:	83 c4 0c             	add    $0xc,%esp
  8000e1:	53                   	push   %ebx
  8000e2:	50                   	push   %eax
  8000e3:	68 3a 26 80 00       	push   $0x80263a
  8000e8:	e8 0b 01 00 00       	call   8001f8 <cprintf>
		ipc_send(who, 0, 0, 0);
  8000ed:	6a 00                	push   $0x0
  8000ef:	6a 00                	push   $0x0
  8000f1:	6a 00                	push   $0x0
  8000f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000f6:	e8 2a 10 00 00       	call   801125 <ipc_send>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	e9 45 ff ff ff       	jmp    800048 <umain+0x15>

00800103 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80010b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80010e:	e8 bf 0a 00 00       	call   800bd2 <sys_getenvid>
  800113:	25 ff 03 00 00       	and    $0x3ff,%eax
  800118:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80011b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800120:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800125:	85 db                	test   %ebx,%ebx
  800127:	7e 07                	jle    800130 <libmain+0x2d>
		binaryname = argv[0];
  800129:	8b 06                	mov    (%esi),%eax
  80012b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800130:	83 ec 08             	sub    $0x8,%esp
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	e8 f9 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80013a:	e8 0a 00 00 00       	call   800149 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5d                   	pop    %ebp
  800148:	c3                   	ret    

00800149 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80014f:	e8 34 12 00 00       	call   801388 <close_all>
	sys_env_destroy(0);
  800154:	83 ec 0c             	sub    $0xc,%esp
  800157:	6a 00                	push   $0x0
  800159:	e8 33 0a 00 00       	call   800b91 <sys_env_destroy>
}
  80015e:	83 c4 10             	add    $0x10,%esp
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	53                   	push   %ebx
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016d:	8b 13                	mov    (%ebx),%edx
  80016f:	8d 42 01             	lea    0x1(%edx),%eax
  800172:	89 03                	mov    %eax,(%ebx)
  800174:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800177:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800180:	74 09                	je     80018b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800189:	c9                   	leave  
  80018a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	68 ff 00 00 00       	push   $0xff
  800193:	8d 43 08             	lea    0x8(%ebx),%eax
  800196:	50                   	push   %eax
  800197:	e8 b8 09 00 00       	call   800b54 <sys_cputs>
		b->idx = 0;
  80019c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a2:	83 c4 10             	add    $0x10,%esp
  8001a5:	eb db                	jmp    800182 <putch+0x1f>

008001a7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001b0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b7:	00 00 00 
	b.cnt = 0;
  8001ba:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c4:	ff 75 0c             	pushl  0xc(%ebp)
  8001c7:	ff 75 08             	pushl  0x8(%ebp)
  8001ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	68 63 01 80 00       	push   $0x800163
  8001d6:	e8 1a 01 00 00       	call   8002f5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ea:	50                   	push   %eax
  8001eb:	e8 64 09 00 00       	call   800b54 <sys_cputs>

	return b.cnt;
}
  8001f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fe:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800201:	50                   	push   %eax
  800202:	ff 75 08             	pushl  0x8(%ebp)
  800205:	e8 9d ff ff ff       	call   8001a7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020a:	c9                   	leave  
  80020b:	c3                   	ret    

0080020c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
  800212:	83 ec 1c             	sub    $0x1c,%esp
  800215:	89 c7                	mov    %eax,%edi
  800217:	89 d6                	mov    %edx,%esi
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800222:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800225:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800228:	bb 00 00 00 00       	mov    $0x0,%ebx
  80022d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800230:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800233:	39 d3                	cmp    %edx,%ebx
  800235:	72 05                	jb     80023c <printnum+0x30>
  800237:	39 45 10             	cmp    %eax,0x10(%ebp)
  80023a:	77 7a                	ja     8002b6 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80023c:	83 ec 0c             	sub    $0xc,%esp
  80023f:	ff 75 18             	pushl  0x18(%ebp)
  800242:	8b 45 14             	mov    0x14(%ebp),%eax
  800245:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800248:	53                   	push   %ebx
  800249:	ff 75 10             	pushl  0x10(%ebp)
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800252:	ff 75 e0             	pushl  -0x20(%ebp)
  800255:	ff 75 dc             	pushl  -0x24(%ebp)
  800258:	ff 75 d8             	pushl  -0x28(%ebp)
  80025b:	e8 80 21 00 00       	call   8023e0 <__udivdi3>
  800260:	83 c4 18             	add    $0x18,%esp
  800263:	52                   	push   %edx
  800264:	50                   	push   %eax
  800265:	89 f2                	mov    %esi,%edx
  800267:	89 f8                	mov    %edi,%eax
  800269:	e8 9e ff ff ff       	call   80020c <printnum>
  80026e:	83 c4 20             	add    $0x20,%esp
  800271:	eb 13                	jmp    800286 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800273:	83 ec 08             	sub    $0x8,%esp
  800276:	56                   	push   %esi
  800277:	ff 75 18             	pushl  0x18(%ebp)
  80027a:	ff d7                	call   *%edi
  80027c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80027f:	83 eb 01             	sub    $0x1,%ebx
  800282:	85 db                	test   %ebx,%ebx
  800284:	7f ed                	jg     800273 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800286:	83 ec 08             	sub    $0x8,%esp
  800289:	56                   	push   %esi
  80028a:	83 ec 04             	sub    $0x4,%esp
  80028d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800290:	ff 75 e0             	pushl  -0x20(%ebp)
  800293:	ff 75 dc             	pushl  -0x24(%ebp)
  800296:	ff 75 d8             	pushl  -0x28(%ebp)
  800299:	e8 62 22 00 00       	call   802500 <__umoddi3>
  80029e:	83 c4 14             	add    $0x14,%esp
  8002a1:	0f be 80 80 26 80 00 	movsbl 0x802680(%eax),%eax
  8002a8:	50                   	push   %eax
  8002a9:	ff d7                	call   *%edi
}
  8002ab:	83 c4 10             	add    $0x10,%esp
  8002ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5e                   	pop    %esi
  8002b3:	5f                   	pop    %edi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    
  8002b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b9:	eb c4                	jmp    80027f <printnum+0x73>

008002bb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c1:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ca:	73 0a                	jae    8002d6 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002cc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cf:	89 08                	mov    %ecx,(%eax)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	88 02                	mov    %al,(%edx)
}
  8002d6:	5d                   	pop    %ebp
  8002d7:	c3                   	ret    

008002d8 <printfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002de:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e1:	50                   	push   %eax
  8002e2:	ff 75 10             	pushl  0x10(%ebp)
  8002e5:	ff 75 0c             	pushl  0xc(%ebp)
  8002e8:	ff 75 08             	pushl  0x8(%ebp)
  8002eb:	e8 05 00 00 00       	call   8002f5 <vprintfmt>
}
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <vprintfmt>:
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	57                   	push   %edi
  8002f9:	56                   	push   %esi
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 2c             	sub    $0x2c,%esp
  8002fe:	8b 75 08             	mov    0x8(%ebp),%esi
  800301:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800304:	8b 7d 10             	mov    0x10(%ebp),%edi
  800307:	e9 c1 03 00 00       	jmp    8006cd <vprintfmt+0x3d8>
		padc = ' ';
  80030c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800310:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800317:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80031e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800325:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032a:	8d 47 01             	lea    0x1(%edi),%eax
  80032d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800330:	0f b6 17             	movzbl (%edi),%edx
  800333:	8d 42 dd             	lea    -0x23(%edx),%eax
  800336:	3c 55                	cmp    $0x55,%al
  800338:	0f 87 12 04 00 00    	ja     800750 <vprintfmt+0x45b>
  80033e:	0f b6 c0             	movzbl %al,%eax
  800341:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800348:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034b:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80034f:	eb d9                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800351:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800354:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800358:	eb d0                	jmp    80032a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	0f b6 d2             	movzbl %dl,%edx
  80035d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800368:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80036f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800372:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800375:	83 f9 09             	cmp    $0x9,%ecx
  800378:	77 55                	ja     8003cf <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  80037a:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80037d:	eb e9                	jmp    800368 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8b 00                	mov    (%eax),%eax
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	8b 45 14             	mov    0x14(%ebp),%eax
  80038a:	8d 40 04             	lea    0x4(%eax),%eax
  80038d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800393:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800397:	79 91                	jns    80032a <vprintfmt+0x35>
				width = precision, precision = -1;
  800399:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a6:	eb 82                	jmp    80032a <vprintfmt+0x35>
  8003a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b2:	0f 49 d0             	cmovns %eax,%edx
  8003b5:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003bb:	e9 6a ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ca:	e9 5b ff ff ff       	jmp    80032a <vprintfmt+0x35>
  8003cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003d5:	eb bc                	jmp    800393 <vprintfmt+0x9e>
			lflag++;
  8003d7:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003dd:	e9 48 ff ff ff       	jmp    80032a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e5:	8d 78 04             	lea    0x4(%eax),%edi
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 30                	pushl  (%eax)
  8003ee:	ff d6                	call   *%esi
			break;
  8003f0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f6:	e9 cf 02 00 00       	jmp    8006ca <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 78 04             	lea    0x4(%eax),%edi
  800401:	8b 00                	mov    (%eax),%eax
  800403:	99                   	cltd   
  800404:	31 d0                	xor    %edx,%eax
  800406:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800408:	83 f8 0f             	cmp    $0xf,%eax
  80040b:	7f 23                	jg     800430 <vprintfmt+0x13b>
  80040d:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800414:	85 d2                	test   %edx,%edx
  800416:	74 18                	je     800430 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800418:	52                   	push   %edx
  800419:	68 5d 2b 80 00       	push   $0x802b5d
  80041e:	53                   	push   %ebx
  80041f:	56                   	push   %esi
  800420:	e8 b3 fe ff ff       	call   8002d8 <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042b:	e9 9a 02 00 00       	jmp    8006ca <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800430:	50                   	push   %eax
  800431:	68 98 26 80 00       	push   $0x802698
  800436:	53                   	push   %ebx
  800437:	56                   	push   %esi
  800438:	e8 9b fe ff ff       	call   8002d8 <printfmt>
  80043d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800440:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800443:	e9 82 02 00 00       	jmp    8006ca <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	83 c0 04             	add    $0x4,%eax
  80044e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800456:	85 ff                	test   %edi,%edi
  800458:	b8 91 26 80 00       	mov    $0x802691,%eax
  80045d:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800460:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800464:	0f 8e bd 00 00 00    	jle    800527 <vprintfmt+0x232>
  80046a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80046e:	75 0e                	jne    80047e <vprintfmt+0x189>
  800470:	89 75 08             	mov    %esi,0x8(%ebp)
  800473:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800476:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800479:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80047c:	eb 6d                	jmp    8004eb <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	ff 75 d0             	pushl  -0x30(%ebp)
  800484:	57                   	push   %edi
  800485:	e8 6e 03 00 00       	call   8007f8 <strnlen>
  80048a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048d:	29 c1                	sub    %eax,%ecx
  80048f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800492:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800495:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80049f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a1:	eb 0f                	jmp    8004b2 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004a3:	83 ec 08             	sub    $0x8,%esp
  8004a6:	53                   	push   %ebx
  8004a7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004aa:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ac:	83 ef 01             	sub    $0x1,%edi
  8004af:	83 c4 10             	add    $0x10,%esp
  8004b2:	85 ff                	test   %edi,%edi
  8004b4:	7f ed                	jg     8004a3 <vprintfmt+0x1ae>
  8004b6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004bc:	85 c9                	test   %ecx,%ecx
  8004be:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c3:	0f 49 c1             	cmovns %ecx,%eax
  8004c6:	29 c1                	sub    %eax,%ecx
  8004c8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ce:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004d1:	89 cb                	mov    %ecx,%ebx
  8004d3:	eb 16                	jmp    8004eb <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d9:	75 31                	jne    80050c <vprintfmt+0x217>
					putch(ch, putdat);
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	ff 75 0c             	pushl  0xc(%ebp)
  8004e1:	50                   	push   %eax
  8004e2:	ff 55 08             	call   *0x8(%ebp)
  8004e5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e8:	83 eb 01             	sub    $0x1,%ebx
  8004eb:	83 c7 01             	add    $0x1,%edi
  8004ee:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004f2:	0f be c2             	movsbl %dl,%eax
  8004f5:	85 c0                	test   %eax,%eax
  8004f7:	74 59                	je     800552 <vprintfmt+0x25d>
  8004f9:	85 f6                	test   %esi,%esi
  8004fb:	78 d8                	js     8004d5 <vprintfmt+0x1e0>
  8004fd:	83 ee 01             	sub    $0x1,%esi
  800500:	79 d3                	jns    8004d5 <vprintfmt+0x1e0>
  800502:	89 df                	mov    %ebx,%edi
  800504:	8b 75 08             	mov    0x8(%ebp),%esi
  800507:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80050a:	eb 37                	jmp    800543 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80050c:	0f be d2             	movsbl %dl,%edx
  80050f:	83 ea 20             	sub    $0x20,%edx
  800512:	83 fa 5e             	cmp    $0x5e,%edx
  800515:	76 c4                	jbe    8004db <vprintfmt+0x1e6>
					putch('?', putdat);
  800517:	83 ec 08             	sub    $0x8,%esp
  80051a:	ff 75 0c             	pushl  0xc(%ebp)
  80051d:	6a 3f                	push   $0x3f
  80051f:	ff 55 08             	call   *0x8(%ebp)
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	eb c1                	jmp    8004e8 <vprintfmt+0x1f3>
  800527:	89 75 08             	mov    %esi,0x8(%ebp)
  80052a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80052d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800530:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800533:	eb b6                	jmp    8004eb <vprintfmt+0x1f6>
				putch(' ', putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	6a 20                	push   $0x20
  80053b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053d:	83 ef 01             	sub    $0x1,%edi
  800540:	83 c4 10             	add    $0x10,%esp
  800543:	85 ff                	test   %edi,%edi
  800545:	7f ee                	jg     800535 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800547:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	e9 78 01 00 00       	jmp    8006ca <vprintfmt+0x3d5>
  800552:	89 df                	mov    %ebx,%edi
  800554:	8b 75 08             	mov    0x8(%ebp),%esi
  800557:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80055a:	eb e7                	jmp    800543 <vprintfmt+0x24e>
	if (lflag >= 2)
  80055c:	83 f9 01             	cmp    $0x1,%ecx
  80055f:	7e 3f                	jle    8005a0 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8b 50 04             	mov    0x4(%eax),%edx
  800567:	8b 00                	mov    (%eax),%eax
  800569:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80056c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8d 40 08             	lea    0x8(%eax),%eax
  800575:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800578:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80057c:	79 5c                	jns    8005da <vprintfmt+0x2e5>
				putch('-', putdat);
  80057e:	83 ec 08             	sub    $0x8,%esp
  800581:	53                   	push   %ebx
  800582:	6a 2d                	push   $0x2d
  800584:	ff d6                	call   *%esi
				num = -(long long) num;
  800586:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800589:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80058c:	f7 da                	neg    %edx
  80058e:	83 d1 00             	adc    $0x0,%ecx
  800591:	f7 d9                	neg    %ecx
  800593:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800596:	b8 0a 00 00 00       	mov    $0xa,%eax
  80059b:	e9 10 01 00 00       	jmp    8006b0 <vprintfmt+0x3bb>
	else if (lflag)
  8005a0:	85 c9                	test   %ecx,%ecx
  8005a2:	75 1b                	jne    8005bf <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8b 00                	mov    (%eax),%eax
  8005a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ac:	89 c1                	mov    %eax,%ecx
  8005ae:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bd:	eb b9                	jmp    800578 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c7:	89 c1                	mov    %eax,%ecx
  8005c9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005cc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d8:	eb 9e                	jmp    800578 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005e0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e5:	e9 c6 00 00 00       	jmp    8006b0 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005ea:	83 f9 01             	cmp    $0x1,%ecx
  8005ed:	7e 18                	jle    800607 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 10                	mov    (%eax),%edx
  8005f4:	8b 48 04             	mov    0x4(%eax),%ecx
  8005f7:	8d 40 08             	lea    0x8(%eax),%eax
  8005fa:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800602:	e9 a9 00 00 00       	jmp    8006b0 <vprintfmt+0x3bb>
	else if (lflag)
  800607:	85 c9                	test   %ecx,%ecx
  800609:	75 1a                	jne    800625 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8b 10                	mov    (%eax),%edx
  800610:	b9 00 00 00 00       	mov    $0x0,%ecx
  800615:	8d 40 04             	lea    0x4(%eax),%eax
  800618:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800620:	e9 8b 00 00 00       	jmp    8006b0 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 10                	mov    (%eax),%edx
  80062a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80062f:	8d 40 04             	lea    0x4(%eax),%eax
  800632:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800635:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063a:	eb 74                	jmp    8006b0 <vprintfmt+0x3bb>
	if (lflag >= 2)
  80063c:	83 f9 01             	cmp    $0x1,%ecx
  80063f:	7e 15                	jle    800656 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 10                	mov    (%eax),%edx
  800646:	8b 48 04             	mov    0x4(%eax),%ecx
  800649:	8d 40 08             	lea    0x8(%eax),%eax
  80064c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80064f:	b8 08 00 00 00       	mov    $0x8,%eax
  800654:	eb 5a                	jmp    8006b0 <vprintfmt+0x3bb>
	else if (lflag)
  800656:	85 c9                	test   %ecx,%ecx
  800658:	75 17                	jne    800671 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	8b 10                	mov    (%eax),%edx
  80065f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800664:	8d 40 04             	lea    0x4(%eax),%eax
  800667:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80066a:	b8 08 00 00 00       	mov    $0x8,%eax
  80066f:	eb 3f                	jmp    8006b0 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800671:	8b 45 14             	mov    0x14(%ebp),%eax
  800674:	8b 10                	mov    (%eax),%edx
  800676:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800681:	b8 08 00 00 00       	mov    $0x8,%eax
  800686:	eb 28                	jmp    8006b0 <vprintfmt+0x3bb>
			putch('0', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 30                	push   $0x30
  80068e:	ff d6                	call   *%esi
			putch('x', putdat);
  800690:	83 c4 08             	add    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 78                	push   $0x78
  800696:	ff d6                	call   *%esi
			num = (unsigned long long)
  800698:	8b 45 14             	mov    0x14(%ebp),%eax
  80069b:	8b 10                	mov    (%eax),%edx
  80069d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006a2:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006a5:	8d 40 04             	lea    0x4(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ab:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006b0:	83 ec 0c             	sub    $0xc,%esp
  8006b3:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006b7:	57                   	push   %edi
  8006b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006bb:	50                   	push   %eax
  8006bc:	51                   	push   %ecx
  8006bd:	52                   	push   %edx
  8006be:	89 da                	mov    %ebx,%edx
  8006c0:	89 f0                	mov    %esi,%eax
  8006c2:	e8 45 fb ff ff       	call   80020c <printnum>
			break;
  8006c7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006cd:	83 c7 01             	add    $0x1,%edi
  8006d0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006d4:	83 f8 25             	cmp    $0x25,%eax
  8006d7:	0f 84 2f fc ff ff    	je     80030c <vprintfmt+0x17>
			if (ch == '\0')
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	0f 84 8b 00 00 00    	je     800770 <vprintfmt+0x47b>
			putch(ch, putdat);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	53                   	push   %ebx
  8006e9:	50                   	push   %eax
  8006ea:	ff d6                	call   *%esi
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	eb dc                	jmp    8006cd <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006f1:	83 f9 01             	cmp    $0x1,%ecx
  8006f4:	7e 15                	jle    80070b <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f9:	8b 10                	mov    (%eax),%edx
  8006fb:	8b 48 04             	mov    0x4(%eax),%ecx
  8006fe:	8d 40 08             	lea    0x8(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800704:	b8 10 00 00 00       	mov    $0x10,%eax
  800709:	eb a5                	jmp    8006b0 <vprintfmt+0x3bb>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	75 17                	jne    800726 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8b 10                	mov    (%eax),%edx
  800714:	b9 00 00 00 00       	mov    $0x0,%ecx
  800719:	8d 40 04             	lea    0x4(%eax),%eax
  80071c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80071f:	b8 10 00 00 00       	mov    $0x10,%eax
  800724:	eb 8a                	jmp    8006b0 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800726:	8b 45 14             	mov    0x14(%ebp),%eax
  800729:	8b 10                	mov    (%eax),%edx
  80072b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
  80073b:	e9 70 ff ff ff       	jmp    8006b0 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800740:	83 ec 08             	sub    $0x8,%esp
  800743:	53                   	push   %ebx
  800744:	6a 25                	push   $0x25
  800746:	ff d6                	call   *%esi
			break;
  800748:	83 c4 10             	add    $0x10,%esp
  80074b:	e9 7a ff ff ff       	jmp    8006ca <vprintfmt+0x3d5>
			putch('%', putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	53                   	push   %ebx
  800754:	6a 25                	push   $0x25
  800756:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 f8                	mov    %edi,%eax
  80075d:	eb 03                	jmp    800762 <vprintfmt+0x46d>
  80075f:	83 e8 01             	sub    $0x1,%eax
  800762:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800766:	75 f7                	jne    80075f <vprintfmt+0x46a>
  800768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80076b:	e9 5a ff ff ff       	jmp    8006ca <vprintfmt+0x3d5>
}
  800770:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800773:	5b                   	pop    %ebx
  800774:	5e                   	pop    %esi
  800775:	5f                   	pop    %edi
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800784:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800787:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80078b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80078e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800795:	85 c0                	test   %eax,%eax
  800797:	74 26                	je     8007bf <vsnprintf+0x47>
  800799:	85 d2                	test   %edx,%edx
  80079b:	7e 22                	jle    8007bf <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80079d:	ff 75 14             	pushl  0x14(%ebp)
  8007a0:	ff 75 10             	pushl  0x10(%ebp)
  8007a3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a6:	50                   	push   %eax
  8007a7:	68 bb 02 80 00       	push   $0x8002bb
  8007ac:	e8 44 fb ff ff       	call   8002f5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
}
  8007bd:	c9                   	leave  
  8007be:	c3                   	ret    
		return -E_INVAL;
  8007bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c4:	eb f7                	jmp    8007bd <vsnprintf+0x45>

008007c6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007cc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007cf:	50                   	push   %eax
  8007d0:	ff 75 10             	pushl  0x10(%ebp)
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	ff 75 08             	pushl  0x8(%ebp)
  8007d9:	e8 9a ff ff ff       	call   800778 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007de:	c9                   	leave  
  8007df:	c3                   	ret    

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	eb 03                	jmp    8007f0 <strlen+0x10>
		n++;
  8007ed:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f4:	75 f7                	jne    8007ed <strlen+0xd>
	return n;
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	eb 03                	jmp    80080b <strnlen+0x13>
		n++;
  800808:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080b:	39 d0                	cmp    %edx,%eax
  80080d:	74 06                	je     800815 <strnlen+0x1d>
  80080f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800813:	75 f3                	jne    800808 <strnlen+0x10>
	return n;
}
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800821:	89 c2                	mov    %eax,%edx
  800823:	83 c1 01             	add    $0x1,%ecx
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800830:	84 db                	test   %bl,%bl
  800832:	75 ef                	jne    800823 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800834:	5b                   	pop    %ebx
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80083e:	53                   	push   %ebx
  80083f:	e8 9c ff ff ff       	call   8007e0 <strlen>
  800844:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800847:	ff 75 0c             	pushl  0xc(%ebp)
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	50                   	push   %eax
  80084d:	e8 c5 ff ff ff       	call   800817 <strcpy>
	return dst;
}
  800852:	89 d8                	mov    %ebx,%eax
  800854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800857:	c9                   	leave  
  800858:	c3                   	ret    

00800859 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	56                   	push   %esi
  80085d:	53                   	push   %ebx
  80085e:	8b 75 08             	mov    0x8(%ebp),%esi
  800861:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800864:	89 f3                	mov    %esi,%ebx
  800866:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800869:	89 f2                	mov    %esi,%edx
  80086b:	eb 0f                	jmp    80087c <strncpy+0x23>
		*dst++ = *src;
  80086d:	83 c2 01             	add    $0x1,%edx
  800870:	0f b6 01             	movzbl (%ecx),%eax
  800873:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800876:	80 39 01             	cmpb   $0x1,(%ecx)
  800879:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80087c:	39 da                	cmp    %ebx,%edx
  80087e:	75 ed                	jne    80086d <strncpy+0x14>
	}
	return ret;
}
  800880:	89 f0                	mov    %esi,%eax
  800882:	5b                   	pop    %ebx
  800883:	5e                   	pop    %esi
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	56                   	push   %esi
  80088a:	53                   	push   %ebx
  80088b:	8b 75 08             	mov    0x8(%ebp),%esi
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800891:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800894:	89 f0                	mov    %esi,%eax
  800896:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80089a:	85 c9                	test   %ecx,%ecx
  80089c:	75 0b                	jne    8008a9 <strlcpy+0x23>
  80089e:	eb 17                	jmp    8008b7 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a0:	83 c2 01             	add    $0x1,%edx
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008a9:	39 d8                	cmp    %ebx,%eax
  8008ab:	74 07                	je     8008b4 <strlcpy+0x2e>
  8008ad:	0f b6 0a             	movzbl (%edx),%ecx
  8008b0:	84 c9                	test   %cl,%cl
  8008b2:	75 ec                	jne    8008a0 <strlcpy+0x1a>
		*dst = '\0';
  8008b4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008b7:	29 f0                	sub    %esi,%eax
}
  8008b9:	5b                   	pop    %ebx
  8008ba:	5e                   	pop    %esi
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008c6:	eb 06                	jmp    8008ce <strcmp+0x11>
		p++, q++;
  8008c8:	83 c1 01             	add    $0x1,%ecx
  8008cb:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008ce:	0f b6 01             	movzbl (%ecx),%eax
  8008d1:	84 c0                	test   %al,%al
  8008d3:	74 04                	je     8008d9 <strcmp+0x1c>
  8008d5:	3a 02                	cmp    (%edx),%al
  8008d7:	74 ef                	je     8008c8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d9:	0f b6 c0             	movzbl %al,%eax
  8008dc:	0f b6 12             	movzbl (%edx),%edx
  8008df:	29 d0                	sub    %edx,%eax
}
  8008e1:	5d                   	pop    %ebp
  8008e2:	c3                   	ret    

008008e3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	53                   	push   %ebx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ed:	89 c3                	mov    %eax,%ebx
  8008ef:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008f2:	eb 06                	jmp    8008fa <strncmp+0x17>
		n--, p++, q++;
  8008f4:	83 c0 01             	add    $0x1,%eax
  8008f7:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008fa:	39 d8                	cmp    %ebx,%eax
  8008fc:	74 16                	je     800914 <strncmp+0x31>
  8008fe:	0f b6 08             	movzbl (%eax),%ecx
  800901:	84 c9                	test   %cl,%cl
  800903:	74 04                	je     800909 <strncmp+0x26>
  800905:	3a 0a                	cmp    (%edx),%cl
  800907:	74 eb                	je     8008f4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800909:	0f b6 00             	movzbl (%eax),%eax
  80090c:	0f b6 12             	movzbl (%edx),%edx
  80090f:	29 d0                	sub    %edx,%eax
}
  800911:	5b                   	pop    %ebx
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    
		return 0;
  800914:	b8 00 00 00 00       	mov    $0x0,%eax
  800919:	eb f6                	jmp    800911 <strncmp+0x2e>

0080091b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800925:	0f b6 10             	movzbl (%eax),%edx
  800928:	84 d2                	test   %dl,%dl
  80092a:	74 09                	je     800935 <strchr+0x1a>
		if (*s == c)
  80092c:	38 ca                	cmp    %cl,%dl
  80092e:	74 0a                	je     80093a <strchr+0x1f>
	for (; *s; s++)
  800930:	83 c0 01             	add    $0x1,%eax
  800933:	eb f0                	jmp    800925 <strchr+0xa>
			return (char *) s;
	return 0;
  800935:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800946:	eb 03                	jmp    80094b <strfind+0xf>
  800948:	83 c0 01             	add    $0x1,%eax
  80094b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80094e:	38 ca                	cmp    %cl,%dl
  800950:	74 04                	je     800956 <strfind+0x1a>
  800952:	84 d2                	test   %dl,%dl
  800954:	75 f2                	jne    800948 <strfind+0xc>
			break;
	return (char *) s;
}
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	57                   	push   %edi
  80095c:	56                   	push   %esi
  80095d:	53                   	push   %ebx
  80095e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800961:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800964:	85 c9                	test   %ecx,%ecx
  800966:	74 13                	je     80097b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800968:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80096e:	75 05                	jne    800975 <memset+0x1d>
  800970:	f6 c1 03             	test   $0x3,%cl
  800973:	74 0d                	je     800982 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
  800978:	fc                   	cld    
  800979:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097b:	89 f8                	mov    %edi,%eax
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5f                   	pop    %edi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    
		c &= 0xFF;
  800982:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800986:	89 d3                	mov    %edx,%ebx
  800988:	c1 e3 08             	shl    $0x8,%ebx
  80098b:	89 d0                	mov    %edx,%eax
  80098d:	c1 e0 18             	shl    $0x18,%eax
  800990:	89 d6                	mov    %edx,%esi
  800992:	c1 e6 10             	shl    $0x10,%esi
  800995:	09 f0                	or     %esi,%eax
  800997:	09 c2                	or     %eax,%edx
  800999:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80099b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80099e:	89 d0                	mov    %edx,%eax
  8009a0:	fc                   	cld    
  8009a1:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a3:	eb d6                	jmp    80097b <memset+0x23>

008009a5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	57                   	push   %edi
  8009a9:	56                   	push   %esi
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b3:	39 c6                	cmp    %eax,%esi
  8009b5:	73 35                	jae    8009ec <memmove+0x47>
  8009b7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009ba:	39 c2                	cmp    %eax,%edx
  8009bc:	76 2e                	jbe    8009ec <memmove+0x47>
		s += n;
		d += n;
  8009be:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c1:	89 d6                	mov    %edx,%esi
  8009c3:	09 fe                	or     %edi,%esi
  8009c5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009cb:	74 0c                	je     8009d9 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009cd:	83 ef 01             	sub    $0x1,%edi
  8009d0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009d3:	fd                   	std    
  8009d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d6:	fc                   	cld    
  8009d7:	eb 21                	jmp    8009fa <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d9:	f6 c1 03             	test   $0x3,%cl
  8009dc:	75 ef                	jne    8009cd <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009de:	83 ef 04             	sub    $0x4,%edi
  8009e1:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009e7:	fd                   	std    
  8009e8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ea:	eb ea                	jmp    8009d6 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ec:	89 f2                	mov    %esi,%edx
  8009ee:	09 c2                	or     %eax,%edx
  8009f0:	f6 c2 03             	test   $0x3,%dl
  8009f3:	74 09                	je     8009fe <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f5:	89 c7                	mov    %eax,%edi
  8009f7:	fc                   	cld    
  8009f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009fa:	5e                   	pop    %esi
  8009fb:	5f                   	pop    %edi
  8009fc:	5d                   	pop    %ebp
  8009fd:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fe:	f6 c1 03             	test   $0x3,%cl
  800a01:	75 f2                	jne    8009f5 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a03:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a06:	89 c7                	mov    %eax,%edi
  800a08:	fc                   	cld    
  800a09:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0b:	eb ed                	jmp    8009fa <memmove+0x55>

00800a0d <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a10:	ff 75 10             	pushl  0x10(%ebp)
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 87 ff ff ff       	call   8009a5 <memmove>
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	56                   	push   %esi
  800a24:	53                   	push   %ebx
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2b:	89 c6                	mov    %eax,%esi
  800a2d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a30:	39 f0                	cmp    %esi,%eax
  800a32:	74 1c                	je     800a50 <memcmp+0x30>
		if (*s1 != *s2)
  800a34:	0f b6 08             	movzbl (%eax),%ecx
  800a37:	0f b6 1a             	movzbl (%edx),%ebx
  800a3a:	38 d9                	cmp    %bl,%cl
  800a3c:	75 08                	jne    800a46 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a3e:	83 c0 01             	add    $0x1,%eax
  800a41:	83 c2 01             	add    $0x1,%edx
  800a44:	eb ea                	jmp    800a30 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a46:	0f b6 c1             	movzbl %cl,%eax
  800a49:	0f b6 db             	movzbl %bl,%ebx
  800a4c:	29 d8                	sub    %ebx,%eax
  800a4e:	eb 05                	jmp    800a55 <memcmp+0x35>
	}

	return 0;
  800a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a62:	89 c2                	mov    %eax,%edx
  800a64:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a67:	39 d0                	cmp    %edx,%eax
  800a69:	73 09                	jae    800a74 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a6b:	38 08                	cmp    %cl,(%eax)
  800a6d:	74 05                	je     800a74 <memfind+0x1b>
	for (; s < ends; s++)
  800a6f:	83 c0 01             	add    $0x1,%eax
  800a72:	eb f3                	jmp    800a67 <memfind+0xe>
			break;
	return (void *) s;
}
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	57                   	push   %edi
  800a7a:	56                   	push   %esi
  800a7b:	53                   	push   %ebx
  800a7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a82:	eb 03                	jmp    800a87 <strtol+0x11>
		s++;
  800a84:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a87:	0f b6 01             	movzbl (%ecx),%eax
  800a8a:	3c 20                	cmp    $0x20,%al
  800a8c:	74 f6                	je     800a84 <strtol+0xe>
  800a8e:	3c 09                	cmp    $0x9,%al
  800a90:	74 f2                	je     800a84 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a92:	3c 2b                	cmp    $0x2b,%al
  800a94:	74 2e                	je     800ac4 <strtol+0x4e>
	int neg = 0;
  800a96:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a9b:	3c 2d                	cmp    $0x2d,%al
  800a9d:	74 2f                	je     800ace <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a9f:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800aa5:	75 05                	jne    800aac <strtol+0x36>
  800aa7:	80 39 30             	cmpb   $0x30,(%ecx)
  800aaa:	74 2c                	je     800ad8 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aac:	85 db                	test   %ebx,%ebx
  800aae:	75 0a                	jne    800aba <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ab0:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ab5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab8:	74 28                	je     800ae2 <strtol+0x6c>
		base = 10;
  800aba:	b8 00 00 00 00       	mov    $0x0,%eax
  800abf:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac2:	eb 50                	jmp    800b14 <strtol+0x9e>
		s++;
  800ac4:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ac7:	bf 00 00 00 00       	mov    $0x0,%edi
  800acc:	eb d1                	jmp    800a9f <strtol+0x29>
		s++, neg = 1;
  800ace:	83 c1 01             	add    $0x1,%ecx
  800ad1:	bf 01 00 00 00       	mov    $0x1,%edi
  800ad6:	eb c7                	jmp    800a9f <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800adc:	74 0e                	je     800aec <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ade:	85 db                	test   %ebx,%ebx
  800ae0:	75 d8                	jne    800aba <strtol+0x44>
		s++, base = 8;
  800ae2:	83 c1 01             	add    $0x1,%ecx
  800ae5:	bb 08 00 00 00       	mov    $0x8,%ebx
  800aea:	eb ce                	jmp    800aba <strtol+0x44>
		s += 2, base = 16;
  800aec:	83 c1 02             	add    $0x2,%ecx
  800aef:	bb 10 00 00 00       	mov    $0x10,%ebx
  800af4:	eb c4                	jmp    800aba <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800af6:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af9:	89 f3                	mov    %esi,%ebx
  800afb:	80 fb 19             	cmp    $0x19,%bl
  800afe:	77 29                	ja     800b29 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b00:	0f be d2             	movsbl %dl,%edx
  800b03:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b06:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b09:	7d 30                	jge    800b3b <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b0b:	83 c1 01             	add    $0x1,%ecx
  800b0e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b12:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b14:	0f b6 11             	movzbl (%ecx),%edx
  800b17:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b1a:	89 f3                	mov    %esi,%ebx
  800b1c:	80 fb 09             	cmp    $0x9,%bl
  800b1f:	77 d5                	ja     800af6 <strtol+0x80>
			dig = *s - '0';
  800b21:	0f be d2             	movsbl %dl,%edx
  800b24:	83 ea 30             	sub    $0x30,%edx
  800b27:	eb dd                	jmp    800b06 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b29:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b2c:	89 f3                	mov    %esi,%ebx
  800b2e:	80 fb 19             	cmp    $0x19,%bl
  800b31:	77 08                	ja     800b3b <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b33:	0f be d2             	movsbl %dl,%edx
  800b36:	83 ea 37             	sub    $0x37,%edx
  800b39:	eb cb                	jmp    800b06 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3f:	74 05                	je     800b46 <strtol+0xd0>
		*endptr = (char *) s;
  800b41:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b44:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b46:	89 c2                	mov    %eax,%edx
  800b48:	f7 da                	neg    %edx
  800b4a:	85 ff                	test   %edi,%edi
  800b4c:	0f 45 c2             	cmovne %edx,%eax
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b65:	89 c3                	mov    %eax,%ebx
  800b67:	89 c7                	mov    %eax,%edi
  800b69:	89 c6                	mov    %eax,%esi
  800b6b:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b82:	89 d1                	mov    %edx,%ecx
  800b84:	89 d3                	mov    %edx,%ebx
  800b86:	89 d7                	mov    %edx,%edi
  800b88:	89 d6                	mov    %edx,%esi
  800b8a:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	57                   	push   %edi
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b9a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba2:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba7:	89 cb                	mov    %ecx,%ebx
  800ba9:	89 cf                	mov    %ecx,%edi
  800bab:	89 ce                	mov    %ecx,%esi
  800bad:	cd 30                	int    $0x30
	if(check && ret > 0)
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	7f 08                	jg     800bbb <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bbb:	83 ec 0c             	sub    $0xc,%esp
  800bbe:	50                   	push   %eax
  800bbf:	6a 03                	push   $0x3
  800bc1:	68 7f 29 80 00       	push   $0x80297f
  800bc6:	6a 23                	push   $0x23
  800bc8:	68 9c 29 80 00       	push   $0x80299c
  800bcd:	e8 00 17 00 00       	call   8022d2 <_panic>

00800bd2 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	57                   	push   %edi
  800bd6:	56                   	push   %esi
  800bd7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdd:	b8 02 00 00 00       	mov    $0x2,%eax
  800be2:	89 d1                	mov    %edx,%ecx
  800be4:	89 d3                	mov    %edx,%ebx
  800be6:	89 d7                	mov    %edx,%edi
  800be8:	89 d6                	mov    %edx,%esi
  800bea:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bec:	5b                   	pop    %ebx
  800bed:	5e                   	pop    %esi
  800bee:	5f                   	pop    %edi
  800bef:	5d                   	pop    %ebp
  800bf0:	c3                   	ret    

00800bf1 <sys_yield>:

void
sys_yield(void)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bfc:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c01:	89 d1                	mov    %edx,%ecx
  800c03:	89 d3                	mov    %edx,%ebx
  800c05:	89 d7                	mov    %edx,%edi
  800c07:	89 d6                	mov    %edx,%esi
  800c09:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5f                   	pop    %edi
  800c0e:	5d                   	pop    %ebp
  800c0f:	c3                   	ret    

00800c10 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c10:	55                   	push   %ebp
  800c11:	89 e5                	mov    %esp,%ebp
  800c13:	57                   	push   %edi
  800c14:	56                   	push   %esi
  800c15:	53                   	push   %ebx
  800c16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c19:	be 00 00 00 00       	mov    $0x0,%esi
  800c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	b8 04 00 00 00       	mov    $0x4,%eax
  800c29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2c:	89 f7                	mov    %esi,%edi
  800c2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c30:	85 c0                	test   %eax,%eax
  800c32:	7f 08                	jg     800c3c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5e                   	pop    %esi
  800c39:	5f                   	pop    %edi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	50                   	push   %eax
  800c40:	6a 04                	push   $0x4
  800c42:	68 7f 29 80 00       	push   $0x80297f
  800c47:	6a 23                	push   $0x23
  800c49:	68 9c 29 80 00       	push   $0x80299c
  800c4e:	e8 7f 16 00 00       	call   8022d2 <_panic>

00800c53 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c62:	b8 05 00 00 00       	mov    $0x5,%eax
  800c67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6d:	8b 75 18             	mov    0x18(%ebp),%esi
  800c70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 05                	push   $0x5
  800c84:	68 7f 29 80 00       	push   $0x80297f
  800c89:	6a 23                	push   $0x23
  800c8b:	68 9c 29 80 00       	push   $0x80299c
  800c90:	e8 3d 16 00 00       	call   8022d2 <_panic>

00800c95 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	b8 06 00 00 00       	mov    $0x6,%eax
  800cae:	89 df                	mov    %ebx,%edi
  800cb0:	89 de                	mov    %ebx,%esi
  800cb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	7f 08                	jg     800cc0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	83 ec 0c             	sub    $0xc,%esp
  800cc3:	50                   	push   %eax
  800cc4:	6a 06                	push   $0x6
  800cc6:	68 7f 29 80 00       	push   $0x80297f
  800ccb:	6a 23                	push   $0x23
  800ccd:	68 9c 29 80 00       	push   $0x80299c
  800cd2:	e8 fb 15 00 00       	call   8022d2 <_panic>

00800cd7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	89 de                	mov    %ebx,%esi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800d06:	6a 08                	push   $0x8
  800d08:	68 7f 29 80 00       	push   $0x80297f
  800d0d:	6a 23                	push   $0x23
  800d0f:	68 9c 29 80 00       	push   $0x80299c
  800d14:	e8 b9 15 00 00       	call   8022d2 <_panic>

00800d19 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d22:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	b8 09 00 00 00       	mov    $0x9,%eax
  800d32:	89 df                	mov    %ebx,%edi
  800d34:	89 de                	mov    %ebx,%esi
  800d36:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d38:	85 c0                	test   %eax,%eax
  800d3a:	7f 08                	jg     800d44 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800d48:	6a 09                	push   $0x9
  800d4a:	68 7f 29 80 00       	push   $0x80297f
  800d4f:	6a 23                	push   $0x23
  800d51:	68 9c 29 80 00       	push   $0x80299c
  800d56:	e8 77 15 00 00       	call   8022d2 <_panic>

00800d5b <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800d6f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d74:	89 df                	mov    %ebx,%edi
  800d76:	89 de                	mov    %ebx,%esi
  800d78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7a:	85 c0                	test   %eax,%eax
  800d7c:	7f 08                	jg     800d86 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800d8a:	6a 0a                	push   $0xa
  800d8c:	68 7f 29 80 00       	push   $0x80297f
  800d91:	6a 23                	push   $0x23
  800d93:	68 9c 29 80 00       	push   $0x80299c
  800d98:	e8 35 15 00 00       	call   8022d2 <_panic>

00800d9d <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dae:	be 00 00 00 00       	mov    $0x0,%esi
  800db3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db9:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
  800dc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dce:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd1:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd6:	89 cb                	mov    %ecx,%ebx
  800dd8:	89 cf                	mov    %ecx,%edi
  800dda:	89 ce                	mov    %ecx,%esi
  800ddc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	7f 08                	jg     800dea <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	50                   	push   %eax
  800dee:	6a 0d                	push   $0xd
  800df0:	68 7f 29 80 00       	push   $0x80297f
  800df5:	6a 23                	push   $0x23
  800df7:	68 9c 29 80 00       	push   $0x80299c
  800dfc:	e8 d1 14 00 00       	call   8022d2 <_panic>

00800e01 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e11:	89 d1                	mov    %edx,%ecx
  800e13:	89 d3                	mov    %edx,%ebx
  800e15:	89 d7                	mov    %edx,%edi
  800e17:	89 d6                	mov    %edx,%esi
  800e19:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	56                   	push   %esi
  800e24:	53                   	push   %ebx
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *)utf->utf_fault_va;
  800e28:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800e2a:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e2e:	74 7f                	je     800eaf <pgfault+0x8f>
  800e30:	89 d8                	mov    %ebx,%eax
  800e32:	c1 e8 0c             	shr    $0xc,%eax
  800e35:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e3c:	f6 c4 08             	test   $0x8,%ah
  800e3f:	74 6e                	je     800eaf <pgfault+0x8f>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t envid = sys_getenvid();
  800e41:	e8 8c fd ff ff       	call   800bd2 <sys_getenvid>
  800e46:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(envid, (void *)PFTEMP, PTE_P | PTE_W | PTE_U)) < 0)
  800e48:	83 ec 04             	sub    $0x4,%esp
  800e4b:	6a 07                	push   $0x7
  800e4d:	68 00 f0 7f 00       	push   $0x7ff000
  800e52:	50                   	push   %eax
  800e53:	e8 b8 fd ff ff       	call   800c10 <sys_page_alloc>
  800e58:	83 c4 10             	add    $0x10,%esp
  800e5b:	85 c0                	test   %eax,%eax
  800e5d:	78 64                	js     800ec3 <pgfault+0xa3>
		panic("pgfault:page allocation failed: %e", r);
	addr = ROUNDDOWN(addr, PGSIZE);
  800e5f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove((void *)PFTEMP, (void *)addr, PGSIZE);
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	68 00 10 00 00       	push   $0x1000
  800e6d:	53                   	push   %ebx
  800e6e:	68 00 f0 7f 00       	push   $0x7ff000
  800e73:	e8 2d fb ff ff       	call   8009a5 <memmove>
	if ((r = sys_page_map(envid, PFTEMP, envid, addr, PTE_P | PTE_W | PTE_U)) < 0)
  800e78:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e7f:	53                   	push   %ebx
  800e80:	56                   	push   %esi
  800e81:	68 00 f0 7f 00       	push   $0x7ff000
  800e86:	56                   	push   %esi
  800e87:	e8 c7 fd ff ff       	call   800c53 <sys_page_map>
  800e8c:	83 c4 20             	add    $0x20,%esp
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	78 42                	js     800ed5 <pgfault+0xb5>
		panic("pgfault:page map failed: %e", r);
	if ((r = sys_page_unmap(envid, PFTEMP)) < 0)
  800e93:	83 ec 08             	sub    $0x8,%esp
  800e96:	68 00 f0 7f 00       	push   $0x7ff000
  800e9b:	56                   	push   %esi
  800e9c:	e8 f4 fd ff ff       	call   800c95 <sys_page_unmap>
  800ea1:	83 c4 10             	add    $0x10,%esp
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	78 3f                	js     800ee7 <pgfault+0xc7>
		panic("pgfault: page unmap failed: %e", r);

	// panic("pgfault not implemented");
}
  800ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    
		panic("pgfault:not writabled or a COW page!\n");
  800eaf:	83 ec 04             	sub    $0x4,%esp
  800eb2:	68 ac 29 80 00       	push   $0x8029ac
  800eb7:	6a 1d                	push   $0x1d
  800eb9:	68 3b 2a 80 00       	push   $0x802a3b
  800ebe:	e8 0f 14 00 00       	call   8022d2 <_panic>
		panic("pgfault:page allocation failed: %e", r);
  800ec3:	50                   	push   %eax
  800ec4:	68 d4 29 80 00       	push   $0x8029d4
  800ec9:	6a 28                	push   $0x28
  800ecb:	68 3b 2a 80 00       	push   $0x802a3b
  800ed0:	e8 fd 13 00 00       	call   8022d2 <_panic>
		panic("pgfault:page map failed: %e", r);
  800ed5:	50                   	push   %eax
  800ed6:	68 46 2a 80 00       	push   $0x802a46
  800edb:	6a 2c                	push   $0x2c
  800edd:	68 3b 2a 80 00       	push   $0x802a3b
  800ee2:	e8 eb 13 00 00       	call   8022d2 <_panic>
		panic("pgfault: page unmap failed: %e", r);
  800ee7:	50                   	push   %eax
  800ee8:	68 f8 29 80 00       	push   $0x8029f8
  800eed:	6a 2e                	push   $0x2e
  800eef:	68 3b 2a 80 00       	push   $0x802a3b
  800ef4:	e8 d9 13 00 00       	call   8022d2 <_panic>

00800ef9 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault); //创建异常栈
  800f02:	68 20 0e 80 00       	push   $0x800e20
  800f07:	e8 0c 14 00 00       	call   802318 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f0c:	b8 07 00 00 00       	mov    $0x7,%eax
  800f11:	cd 30                	int    $0x30
  800f13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t eid = sys_exofork();  //创建一个空进程
	if (eid < 0)
  800f16:	83 c4 10             	add    $0x10,%esp
  800f19:	85 c0                	test   %eax,%eax
  800f1b:	78 2f                	js     800f4c <fork+0x53>
  800f1d:	89 c7                	mov    %eax,%edi
		return 0;
	}
	// parent
	size_t pn;
	int r;
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f1f:	bb 00 08 00 00       	mov    $0x800,%ebx
	if (eid == 0)
  800f24:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f28:	75 6e                	jne    800f98 <fork+0x9f>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f2a:	e8 a3 fc ff ff       	call   800bd2 <sys_getenvid>
  800f2f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f34:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800f37:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f3c:	a3 0c 40 80 00       	mov    %eax,0x80400c
		return 0;
  800f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		return r;
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status failed: %e", r);
	return eid;
	// panic("fork not implemented");
}
  800f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    
		panic("fork failed: sys_exofork faied: %e", eid);
  800f4c:	50                   	push   %eax
  800f4d:	68 18 2a 80 00       	push   $0x802a18
  800f52:	6a 6e                	push   $0x6e
  800f54:	68 3b 2a 80 00       	push   $0x802a3b
  800f59:	e8 74 13 00 00       	call   8022d2 <_panic>
		if ((r = sys_page_map(0, addr, envid, addr, uvpt[pn] & PTE_SYSCALL)) < 0)
  800f5e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800f65:	83 ec 0c             	sub    $0xc,%esp
  800f68:	25 07 0e 00 00       	and    $0xe07,%eax
  800f6d:	50                   	push   %eax
  800f6e:	56                   	push   %esi
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	6a 00                	push   $0x0
  800f73:	e8 db fc ff ff       	call   800c53 <sys_page_map>
  800f78:	83 c4 20             	add    $0x20,%esp
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	0f 4f c2             	cmovg  %edx,%eax
			if ((r = duppage(eid, pn)) < 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	78 bb                	js     800f44 <fork+0x4b>
	for (pn = PGNUM(UTEXT); pn < PGNUM(USTACKTOP); ++pn)
  800f89:	83 c3 01             	add    $0x1,%ebx
  800f8c:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  800f92:	0f 84 a6 00 00 00    	je     80103e <fork+0x145>
		if ((uvpd[pn >> 10] & PTE_P) && (uvpt[pn] & PTE_P))
  800f98:	89 d8                	mov    %ebx,%eax
  800f9a:	c1 e8 0a             	shr    $0xa,%eax
  800f9d:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fa4:	a8 01                	test   $0x1,%al
  800fa6:	74 e1                	je     800f89 <fork+0x90>
  800fa8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800faf:	a8 01                	test   $0x1,%al
  800fb1:	74 d6                	je     800f89 <fork+0x90>
  800fb3:	89 de                	mov    %ebx,%esi
  800fb5:	c1 e6 0c             	shl    $0xc,%esi
	if (uvpt[pn] & PTE_SHARE)
  800fb8:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fbf:	f6 c4 04             	test   $0x4,%ah
  800fc2:	75 9a                	jne    800f5e <fork+0x65>
	else if ((uvpt[pn] & PTE_W) || (uvpt[pn] & PTE_COW))
  800fc4:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fcb:	a8 02                	test   $0x2,%al
  800fcd:	75 0c                	jne    800fdb <fork+0xe2>
  800fcf:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  800fd6:	f6 c4 08             	test   $0x8,%ah
  800fd9:	74 42                	je     80101d <fork+0x124>
		if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800fdb:	83 ec 0c             	sub    $0xc,%esp
  800fde:	68 05 08 00 00       	push   $0x805
  800fe3:	56                   	push   %esi
  800fe4:	57                   	push   %edi
  800fe5:	56                   	push   %esi
  800fe6:	6a 00                	push   $0x0
  800fe8:	e8 66 fc ff ff       	call   800c53 <sys_page_map>
  800fed:	83 c4 20             	add    $0x20,%esp
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	0f 88 4c ff ff ff    	js     800f44 <fork+0x4b>
		if ((r = sys_page_map(0, addr, 0, addr, PTE_P | PTE_U | PTE_COW)) < 0)
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	68 05 08 00 00       	push   $0x805
  801000:	56                   	push   %esi
  801001:	6a 00                	push   $0x0
  801003:	56                   	push   %esi
  801004:	6a 00                	push   $0x0
  801006:	e8 48 fc ff ff       	call   800c53 <sys_page_map>
  80100b:	83 c4 20             	add    $0x20,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	b9 00 00 00 00       	mov    $0x0,%ecx
  801015:	0f 4f c1             	cmovg  %ecx,%eax
  801018:	e9 68 ff ff ff       	jmp    800f85 <fork+0x8c>
	else if ((r = sys_page_map(0, addr, envid, addr, PTE_P | PTE_U)) < 0)
  80101d:	83 ec 0c             	sub    $0xc,%esp
  801020:	6a 05                	push   $0x5
  801022:	56                   	push   %esi
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	6a 00                	push   $0x0
  801027:	e8 27 fc ff ff       	call   800c53 <sys_page_map>
  80102c:	83 c4 20             	add    $0x20,%esp
  80102f:	85 c0                	test   %eax,%eax
  801031:	b9 00 00 00 00       	mov    $0x0,%ecx
  801036:	0f 4f c1             	cmovg  %ecx,%eax
  801039:	e9 47 ff ff ff       	jmp    800f85 <fork+0x8c>
	if ((r = sys_page_alloc(eid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80103e:	83 ec 04             	sub    $0x4,%esp
  801041:	6a 07                	push   $0x7
  801043:	68 00 f0 bf ee       	push   $0xeebff000
  801048:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80104b:	57                   	push   %edi
  80104c:	e8 bf fb ff ff       	call   800c10 <sys_page_alloc>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	0f 88 e8 fe ff ff    	js     800f44 <fork+0x4b>
	if ((r = sys_env_set_pgfault_upcall(eid, _pgfault_upcall)) < 0)
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	68 7d 23 80 00       	push   $0x80237d
  801064:	57                   	push   %edi
  801065:	e8 f1 fc ff ff       	call   800d5b <sys_env_set_pgfault_upcall>
  80106a:	83 c4 10             	add    $0x10,%esp
  80106d:	85 c0                	test   %eax,%eax
  80106f:	0f 88 cf fe ff ff    	js     800f44 <fork+0x4b>
	if ((r = sys_env_set_status(eid, ENV_RUNNABLE)) < 0)
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	6a 02                	push   $0x2
  80107a:	57                   	push   %edi
  80107b:	e8 57 fc ff ff       	call   800cd7 <sys_env_set_status>
  801080:	83 c4 10             	add    $0x10,%esp
  801083:	85 c0                	test   %eax,%eax
  801085:	78 08                	js     80108f <fork+0x196>
	return eid;
  801087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80108a:	e9 b5 fe ff ff       	jmp    800f44 <fork+0x4b>
		panic("sys_env_set_status failed: %e", r);
  80108f:	50                   	push   %eax
  801090:	68 62 2a 80 00       	push   $0x802a62
  801095:	68 87 00 00 00       	push   $0x87
  80109a:	68 3b 2a 80 00       	push   $0x802a3b
  80109f:	e8 2e 12 00 00       	call   8022d2 <_panic>

008010a4 <sfork>:

// Challenge!
int sfork(void)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010aa:	68 80 2a 80 00       	push   $0x802a80
  8010af:	68 8f 00 00 00       	push   $0x8f
  8010b4:	68 3b 2a 80 00       	push   $0x802a3b
  8010b9:	e8 14 12 00 00       	call   8022d2 <_panic>

008010be <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	56                   	push   %esi
  8010c2:	53                   	push   %ebx
  8010c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  8010cc:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8010ce:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8010d3:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  8010d6:	83 ec 0c             	sub    $0xc,%esp
  8010d9:	50                   	push   %eax
  8010da:	e8 e1 fc ff ff       	call   800dc0 <sys_ipc_recv>
	if (from_env_store)
  8010df:	83 c4 10             	add    $0x10,%esp
  8010e2:	85 f6                	test   %esi,%esi
  8010e4:	74 14                	je     8010fa <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  8010e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	78 09                	js     8010f8 <ipc_recv+0x3a>
  8010ef:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  8010f5:	8b 52 74             	mov    0x74(%edx),%edx
  8010f8:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  8010fa:	85 db                	test   %ebx,%ebx
  8010fc:	74 14                	je     801112 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  8010fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801103:	85 c0                	test   %eax,%eax
  801105:	78 09                	js     801110 <ipc_recv+0x52>
  801107:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  80110d:	8b 52 78             	mov    0x78(%edx),%edx
  801110:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801112:	85 c0                	test   %eax,%eax
  801114:	78 08                	js     80111e <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801116:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80111b:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80111e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801121:	5b                   	pop    %ebx
  801122:	5e                   	pop    %esi
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	57                   	push   %edi
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 0c             	sub    $0xc,%esp
  80112e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801131:	8b 75 0c             	mov    0xc(%ebp),%esi
  801134:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801137:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801139:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80113e:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801141:	ff 75 14             	pushl  0x14(%ebp)
  801144:	53                   	push   %ebx
  801145:	56                   	push   %esi
  801146:	57                   	push   %edi
  801147:	e8 51 fc ff ff       	call   800d9d <sys_ipc_try_send>
		if (ret == 0)
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	85 c0                	test   %eax,%eax
  801151:	74 1e                	je     801171 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801153:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801156:	75 07                	jne    80115f <ipc_send+0x3a>
			sys_yield();
  801158:	e8 94 fa ff ff       	call   800bf1 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80115d:	eb e2                	jmp    801141 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80115f:	50                   	push   %eax
  801160:	68 96 2a 80 00       	push   $0x802a96
  801165:	6a 3d                	push   $0x3d
  801167:	68 aa 2a 80 00       	push   $0x802aaa
  80116c:	e8 61 11 00 00       	call   8022d2 <_panic>
	}
	// panic("ipc_send not implemented");
}
  801171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801184:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801187:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80118d:	8b 52 50             	mov    0x50(%edx),%edx
  801190:	39 ca                	cmp    %ecx,%edx
  801192:	74 11                	je     8011a5 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801194:	83 c0 01             	add    $0x1,%eax
  801197:	3d 00 04 00 00       	cmp    $0x400,%eax
  80119c:	75 e6                	jne    801184 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80119e:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a3:	eb 0b                	jmp    8011b0 <ipc_find_env+0x37>
			return envs[i].env_id;
  8011a5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011ad:	8b 40 48             	mov    0x48(%eax),%eax
}
  8011b0:	5d                   	pop    %ebp
  8011b1:	c3                   	ret    

008011b2 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	05 00 00 00 30       	add    $0x30000000,%eax
  8011bd:	c1 e8 0c             	shr    $0xc,%eax
}
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    

008011c2 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011d7:	5d                   	pop    %ebp
  8011d8:	c3                   	ret    

008011d9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011df:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011e4:	89 c2                	mov    %eax,%edx
  8011e6:	c1 ea 16             	shr    $0x16,%edx
  8011e9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011f0:	f6 c2 01             	test   $0x1,%dl
  8011f3:	74 2a                	je     80121f <fd_alloc+0x46>
  8011f5:	89 c2                	mov    %eax,%edx
  8011f7:	c1 ea 0c             	shr    $0xc,%edx
  8011fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801201:	f6 c2 01             	test   $0x1,%dl
  801204:	74 19                	je     80121f <fd_alloc+0x46>
  801206:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80120b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801210:	75 d2                	jne    8011e4 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801212:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801218:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80121d:	eb 07                	jmp    801226 <fd_alloc+0x4d>
			*fd_store = fd;
  80121f:	89 01                	mov    %eax,(%ecx)
			return 0;
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80122e:	83 f8 1f             	cmp    $0x1f,%eax
  801231:	77 36                	ja     801269 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801233:	c1 e0 0c             	shl    $0xc,%eax
  801236:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80123b:	89 c2                	mov    %eax,%edx
  80123d:	c1 ea 16             	shr    $0x16,%edx
  801240:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801247:	f6 c2 01             	test   $0x1,%dl
  80124a:	74 24                	je     801270 <fd_lookup+0x48>
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	c1 ea 0c             	shr    $0xc,%edx
  801251:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801258:	f6 c2 01             	test   $0x1,%dl
  80125b:	74 1a                	je     801277 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80125d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801260:	89 02                	mov    %eax,(%edx)
	return 0;
  801262:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    
		return -E_INVAL;
  801269:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80126e:	eb f7                	jmp    801267 <fd_lookup+0x3f>
		return -E_INVAL;
  801270:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801275:	eb f0                	jmp    801267 <fd_lookup+0x3f>
  801277:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127c:	eb e9                	jmp    801267 <fd_lookup+0x3f>

0080127e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 08             	sub    $0x8,%esp
  801284:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801287:	ba 30 2b 80 00       	mov    $0x802b30,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80128c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801291:	39 08                	cmp    %ecx,(%eax)
  801293:	74 33                	je     8012c8 <dev_lookup+0x4a>
  801295:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801298:	8b 02                	mov    (%edx),%eax
  80129a:	85 c0                	test   %eax,%eax
  80129c:	75 f3                	jne    801291 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80129e:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8012a3:	8b 40 48             	mov    0x48(%eax),%eax
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	51                   	push   %ecx
  8012aa:	50                   	push   %eax
  8012ab:	68 b4 2a 80 00       	push   $0x802ab4
  8012b0:	e8 43 ef ff ff       	call   8001f8 <cprintf>
	*dev = 0;
  8012b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    
			*dev = devtab[i];
  8012c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d2:	eb f2                	jmp    8012c6 <dev_lookup+0x48>

008012d4 <fd_close>:
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
  8012d7:	57                   	push   %edi
  8012d8:	56                   	push   %esi
  8012d9:	53                   	push   %ebx
  8012da:	83 ec 1c             	sub    $0x1c,%esp
  8012dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012e3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012ed:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012f0:	50                   	push   %eax
  8012f1:	e8 32 ff ff ff       	call   801228 <fd_lookup>
  8012f6:	89 c3                	mov    %eax,%ebx
  8012f8:	83 c4 08             	add    $0x8,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 05                	js     801304 <fd_close+0x30>
	    || fd != fd2)
  8012ff:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801302:	74 16                	je     80131a <fd_close+0x46>
		return (must_exist ? r : 0);
  801304:	89 f8                	mov    %edi,%eax
  801306:	84 c0                	test   %al,%al
  801308:	b8 00 00 00 00       	mov    $0x0,%eax
  80130d:	0f 44 d8             	cmove  %eax,%ebx
}
  801310:	89 d8                	mov    %ebx,%eax
  801312:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801315:	5b                   	pop    %ebx
  801316:	5e                   	pop    %esi
  801317:	5f                   	pop    %edi
  801318:	5d                   	pop    %ebp
  801319:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	ff 36                	pushl  (%esi)
  801323:	e8 56 ff ff ff       	call   80127e <dev_lookup>
  801328:	89 c3                	mov    %eax,%ebx
  80132a:	83 c4 10             	add    $0x10,%esp
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 15                	js     801346 <fd_close+0x72>
		if (dev->dev_close)
  801331:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801334:	8b 40 10             	mov    0x10(%eax),%eax
  801337:	85 c0                	test   %eax,%eax
  801339:	74 1b                	je     801356 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	56                   	push   %esi
  80133f:	ff d0                	call   *%eax
  801341:	89 c3                	mov    %eax,%ebx
  801343:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	56                   	push   %esi
  80134a:	6a 00                	push   $0x0
  80134c:	e8 44 f9 ff ff       	call   800c95 <sys_page_unmap>
	return r;
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	eb ba                	jmp    801310 <fd_close+0x3c>
			r = 0;
  801356:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135b:	eb e9                	jmp    801346 <fd_close+0x72>

0080135d <close>:

int
close(int fdnum)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801363:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801366:	50                   	push   %eax
  801367:	ff 75 08             	pushl  0x8(%ebp)
  80136a:	e8 b9 fe ff ff       	call   801228 <fd_lookup>
  80136f:	83 c4 08             	add    $0x8,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	78 10                	js     801386 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	6a 01                	push   $0x1
  80137b:	ff 75 f4             	pushl  -0xc(%ebp)
  80137e:	e8 51 ff ff ff       	call   8012d4 <fd_close>
  801383:	83 c4 10             	add    $0x10,%esp
}
  801386:	c9                   	leave  
  801387:	c3                   	ret    

00801388 <close_all>:

void
close_all(void)
{
  801388:	55                   	push   %ebp
  801389:	89 e5                	mov    %esp,%ebp
  80138b:	53                   	push   %ebx
  80138c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80138f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801394:	83 ec 0c             	sub    $0xc,%esp
  801397:	53                   	push   %ebx
  801398:	e8 c0 ff ff ff       	call   80135d <close>
	for (i = 0; i < MAXFD; i++)
  80139d:	83 c3 01             	add    $0x1,%ebx
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	83 fb 20             	cmp    $0x20,%ebx
  8013a6:	75 ec                	jne    801394 <close_all+0xc>
}
  8013a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	57                   	push   %edi
  8013b1:	56                   	push   %esi
  8013b2:	53                   	push   %ebx
  8013b3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8013b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013b9:	50                   	push   %eax
  8013ba:	ff 75 08             	pushl  0x8(%ebp)
  8013bd:	e8 66 fe ff ff       	call   801228 <fd_lookup>
  8013c2:	89 c3                	mov    %eax,%ebx
  8013c4:	83 c4 08             	add    $0x8,%esp
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	0f 88 81 00 00 00    	js     801450 <dup+0xa3>
		return r;
	close(newfdnum);
  8013cf:	83 ec 0c             	sub    $0xc,%esp
  8013d2:	ff 75 0c             	pushl  0xc(%ebp)
  8013d5:	e8 83 ff ff ff       	call   80135d <close>

	newfd = INDEX2FD(newfdnum);
  8013da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013dd:	c1 e6 0c             	shl    $0xc,%esi
  8013e0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013e6:	83 c4 04             	add    $0x4,%esp
  8013e9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013ec:	e8 d1 fd ff ff       	call   8011c2 <fd2data>
  8013f1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013f3:	89 34 24             	mov    %esi,(%esp)
  8013f6:	e8 c7 fd ff ff       	call   8011c2 <fd2data>
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801400:	89 d8                	mov    %ebx,%eax
  801402:	c1 e8 16             	shr    $0x16,%eax
  801405:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80140c:	a8 01                	test   $0x1,%al
  80140e:	74 11                	je     801421 <dup+0x74>
  801410:	89 d8                	mov    %ebx,%eax
  801412:	c1 e8 0c             	shr    $0xc,%eax
  801415:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80141c:	f6 c2 01             	test   $0x1,%dl
  80141f:	75 39                	jne    80145a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801421:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801424:	89 d0                	mov    %edx,%eax
  801426:	c1 e8 0c             	shr    $0xc,%eax
  801429:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	25 07 0e 00 00       	and    $0xe07,%eax
  801438:	50                   	push   %eax
  801439:	56                   	push   %esi
  80143a:	6a 00                	push   $0x0
  80143c:	52                   	push   %edx
  80143d:	6a 00                	push   $0x0
  80143f:	e8 0f f8 ff ff       	call   800c53 <sys_page_map>
  801444:	89 c3                	mov    %eax,%ebx
  801446:	83 c4 20             	add    $0x20,%esp
  801449:	85 c0                	test   %eax,%eax
  80144b:	78 31                	js     80147e <dup+0xd1>
		goto err;

	return newfdnum;
  80144d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801450:	89 d8                	mov    %ebx,%eax
  801452:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80145a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801461:	83 ec 0c             	sub    $0xc,%esp
  801464:	25 07 0e 00 00       	and    $0xe07,%eax
  801469:	50                   	push   %eax
  80146a:	57                   	push   %edi
  80146b:	6a 00                	push   $0x0
  80146d:	53                   	push   %ebx
  80146e:	6a 00                	push   $0x0
  801470:	e8 de f7 ff ff       	call   800c53 <sys_page_map>
  801475:	89 c3                	mov    %eax,%ebx
  801477:	83 c4 20             	add    $0x20,%esp
  80147a:	85 c0                	test   %eax,%eax
  80147c:	79 a3                	jns    801421 <dup+0x74>
	sys_page_unmap(0, newfd);
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	56                   	push   %esi
  801482:	6a 00                	push   $0x0
  801484:	e8 0c f8 ff ff       	call   800c95 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801489:	83 c4 08             	add    $0x8,%esp
  80148c:	57                   	push   %edi
  80148d:	6a 00                	push   $0x0
  80148f:	e8 01 f8 ff ff       	call   800c95 <sys_page_unmap>
	return r;
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	eb b7                	jmp    801450 <dup+0xa3>

00801499 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	53                   	push   %ebx
  80149d:	83 ec 14             	sub    $0x14,%esp
  8014a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a6:	50                   	push   %eax
  8014a7:	53                   	push   %ebx
  8014a8:	e8 7b fd ff ff       	call   801228 <fd_lookup>
  8014ad:	83 c4 08             	add    $0x8,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 3f                	js     8014f3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b4:	83 ec 08             	sub    $0x8,%esp
  8014b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014be:	ff 30                	pushl  (%eax)
  8014c0:	e8 b9 fd ff ff       	call   80127e <dev_lookup>
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 27                	js     8014f3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014cf:	8b 42 08             	mov    0x8(%edx),%eax
  8014d2:	83 e0 03             	and    $0x3,%eax
  8014d5:	83 f8 01             	cmp    $0x1,%eax
  8014d8:	74 1e                	je     8014f8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dd:	8b 40 08             	mov    0x8(%eax),%eax
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	74 35                	je     801519 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	ff 75 10             	pushl  0x10(%ebp)
  8014ea:	ff 75 0c             	pushl  0xc(%ebp)
  8014ed:	52                   	push   %edx
  8014ee:	ff d0                	call   *%eax
  8014f0:	83 c4 10             	add    $0x10,%esp
}
  8014f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014f8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014fd:	8b 40 48             	mov    0x48(%eax),%eax
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	53                   	push   %ebx
  801504:	50                   	push   %eax
  801505:	68 f5 2a 80 00       	push   $0x802af5
  80150a:	e8 e9 ec ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801517:	eb da                	jmp    8014f3 <read+0x5a>
		return -E_NOT_SUPP;
  801519:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151e:	eb d3                	jmp    8014f3 <read+0x5a>

00801520 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	57                   	push   %edi
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	83 ec 0c             	sub    $0xc,%esp
  801529:	8b 7d 08             	mov    0x8(%ebp),%edi
  80152c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80152f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801534:	39 f3                	cmp    %esi,%ebx
  801536:	73 25                	jae    80155d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	89 f0                	mov    %esi,%eax
  80153d:	29 d8                	sub    %ebx,%eax
  80153f:	50                   	push   %eax
  801540:	89 d8                	mov    %ebx,%eax
  801542:	03 45 0c             	add    0xc(%ebp),%eax
  801545:	50                   	push   %eax
  801546:	57                   	push   %edi
  801547:	e8 4d ff ff ff       	call   801499 <read>
		if (m < 0)
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 08                	js     80155b <readn+0x3b>
			return m;
		if (m == 0)
  801553:	85 c0                	test   %eax,%eax
  801555:	74 06                	je     80155d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801557:	01 c3                	add    %eax,%ebx
  801559:	eb d9                	jmp    801534 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80155b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80155d:	89 d8                	mov    %ebx,%eax
  80155f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801562:	5b                   	pop    %ebx
  801563:	5e                   	pop    %esi
  801564:	5f                   	pop    %edi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	53                   	push   %ebx
  80156b:	83 ec 14             	sub    $0x14,%esp
  80156e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801571:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801574:	50                   	push   %eax
  801575:	53                   	push   %ebx
  801576:	e8 ad fc ff ff       	call   801228 <fd_lookup>
  80157b:	83 c4 08             	add    $0x8,%esp
  80157e:	85 c0                	test   %eax,%eax
  801580:	78 3a                	js     8015bc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801588:	50                   	push   %eax
  801589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158c:	ff 30                	pushl  (%eax)
  80158e:	e8 eb fc ff ff       	call   80127e <dev_lookup>
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	85 c0                	test   %eax,%eax
  801598:	78 22                	js     8015bc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015a1:	74 1e                	je     8015c1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8015a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a6:	8b 52 0c             	mov    0xc(%edx),%edx
  8015a9:	85 d2                	test   %edx,%edx
  8015ab:	74 35                	je     8015e2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	ff 75 10             	pushl  0x10(%ebp)
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	50                   	push   %eax
  8015b7:	ff d2                	call   *%edx
  8015b9:	83 c4 10             	add    $0x10,%esp
}
  8015bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8015c1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8015c6:	8b 40 48             	mov    0x48(%eax),%eax
  8015c9:	83 ec 04             	sub    $0x4,%esp
  8015cc:	53                   	push   %ebx
  8015cd:	50                   	push   %eax
  8015ce:	68 11 2b 80 00       	push   $0x802b11
  8015d3:	e8 20 ec ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e0:	eb da                	jmp    8015bc <write+0x55>
		return -E_NOT_SUPP;
  8015e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e7:	eb d3                	jmp    8015bc <write+0x55>

008015e9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	e8 2d fc ff ff       	call   801228 <fd_lookup>
  8015fb:	83 c4 08             	add    $0x8,%esp
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 0e                	js     801610 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801602:	8b 55 0c             	mov    0xc(%ebp),%edx
  801605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801608:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	53                   	push   %ebx
  801616:	83 ec 14             	sub    $0x14,%esp
  801619:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80161f:	50                   	push   %eax
  801620:	53                   	push   %ebx
  801621:	e8 02 fc ff ff       	call   801228 <fd_lookup>
  801626:	83 c4 08             	add    $0x8,%esp
  801629:	85 c0                	test   %eax,%eax
  80162b:	78 37                	js     801664 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801633:	50                   	push   %eax
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	ff 30                	pushl  (%eax)
  801639:	e8 40 fc ff ff       	call   80127e <dev_lookup>
  80163e:	83 c4 10             	add    $0x10,%esp
  801641:	85 c0                	test   %eax,%eax
  801643:	78 1f                	js     801664 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801648:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80164c:	74 1b                	je     801669 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80164e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801651:	8b 52 18             	mov    0x18(%edx),%edx
  801654:	85 d2                	test   %edx,%edx
  801656:	74 32                	je     80168a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	50                   	push   %eax
  80165f:	ff d2                	call   *%edx
  801661:	83 c4 10             	add    $0x10,%esp
}
  801664:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801667:	c9                   	leave  
  801668:	c3                   	ret    
			thisenv->env_id, fdnum);
  801669:	a1 0c 40 80 00       	mov    0x80400c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80166e:	8b 40 48             	mov    0x48(%eax),%eax
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	53                   	push   %ebx
  801675:	50                   	push   %eax
  801676:	68 d4 2a 80 00       	push   $0x802ad4
  80167b:	e8 78 eb ff ff       	call   8001f8 <cprintf>
		return -E_INVAL;
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801688:	eb da                	jmp    801664 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80168a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80168f:	eb d3                	jmp    801664 <ftruncate+0x52>

00801691 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	53                   	push   %ebx
  801695:	83 ec 14             	sub    $0x14,%esp
  801698:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80169e:	50                   	push   %eax
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 81 fb ff ff       	call   801228 <fd_lookup>
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 4b                	js     8016f9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b4:	50                   	push   %eax
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	ff 30                	pushl  (%eax)
  8016ba:	e8 bf fb ff ff       	call   80127e <dev_lookup>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 33                	js     8016f9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016cd:	74 2f                	je     8016fe <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016cf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016d2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016d9:	00 00 00 
	stat->st_isdir = 0;
  8016dc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016e3:	00 00 00 
	stat->st_dev = dev;
  8016e6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016ec:	83 ec 08             	sub    $0x8,%esp
  8016ef:	53                   	push   %ebx
  8016f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8016f3:	ff 50 14             	call   *0x14(%eax)
  8016f6:	83 c4 10             	add    $0x10,%esp
}
  8016f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    
		return -E_NOT_SUPP;
  8016fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801703:	eb f4                	jmp    8016f9 <fstat+0x68>

00801705 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	56                   	push   %esi
  801709:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80170a:	83 ec 08             	sub    $0x8,%esp
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	e8 e7 01 00 00       	call   8018fe <open>
  801717:	89 c3                	mov    %eax,%ebx
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 1b                	js     80173b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801720:	83 ec 08             	sub    $0x8,%esp
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	50                   	push   %eax
  801727:	e8 65 ff ff ff       	call   801691 <fstat>
  80172c:	89 c6                	mov    %eax,%esi
	close(fd);
  80172e:	89 1c 24             	mov    %ebx,(%esp)
  801731:	e8 27 fc ff ff       	call   80135d <close>
	return r;
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	89 f3                	mov    %esi,%ebx
}
  80173b:	89 d8                	mov    %ebx,%eax
  80173d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801740:	5b                   	pop    %ebx
  801741:	5e                   	pop    %esi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    

00801744 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	89 c6                	mov    %eax,%esi
  80174b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80174d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801754:	74 27                	je     80177d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801756:	6a 07                	push   $0x7
  801758:	68 00 50 80 00       	push   $0x805000
  80175d:	56                   	push   %esi
  80175e:	ff 35 00 40 80 00    	pushl  0x804000
  801764:	e8 bc f9 ff ff       	call   801125 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801769:	83 c4 0c             	add    $0xc,%esp
  80176c:	6a 00                	push   $0x0
  80176e:	53                   	push   %ebx
  80176f:	6a 00                	push   $0x0
  801771:	e8 48 f9 ff ff       	call   8010be <ipc_recv>
}
  801776:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801779:	5b                   	pop    %ebx
  80177a:	5e                   	pop    %esi
  80177b:	5d                   	pop    %ebp
  80177c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80177d:	83 ec 0c             	sub    $0xc,%esp
  801780:	6a 01                	push   $0x1
  801782:	e8 f2 f9 ff ff       	call   801179 <ipc_find_env>
  801787:	a3 00 40 80 00       	mov    %eax,0x804000
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	eb c5                	jmp    801756 <fsipc+0x12>

00801791 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8017a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	b8 02 00 00 00       	mov    $0x2,%eax
  8017b4:	e8 8b ff ff ff       	call   801744 <fsipc>
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <devfile_flush>:
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8017d6:	e8 69 ff ff ff       	call   801744 <fsipc>
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <devfile_stat>:
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ed:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8017fc:	e8 43 ff ff ff       	call   801744 <fsipc>
  801801:	85 c0                	test   %eax,%eax
  801803:	78 2c                	js     801831 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801805:	83 ec 08             	sub    $0x8,%esp
  801808:	68 00 50 80 00       	push   $0x805000
  80180d:	53                   	push   %ebx
  80180e:	e8 04 f0 ff ff       	call   800817 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801813:	a1 80 50 80 00       	mov    0x805080,%eax
  801818:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80181e:	a1 84 50 80 00       	mov    0x805084,%eax
  801823:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801829:	83 c4 10             	add    $0x10,%esp
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <devfile_write>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 0c             	sub    $0xc,%esp
  80183c:	8b 45 10             	mov    0x10(%ebp),%eax
  80183f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801844:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801849:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80184c:	8b 55 08             	mov    0x8(%ebp),%edx
  80184f:	8b 52 0c             	mov    0xc(%edx),%edx
  801852:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801858:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80185d:	50                   	push   %eax
  80185e:	ff 75 0c             	pushl  0xc(%ebp)
  801861:	68 08 50 80 00       	push   $0x805008
  801866:	e8 3a f1 ff ff       	call   8009a5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80186b:	ba 00 00 00 00       	mov    $0x0,%edx
  801870:	b8 04 00 00 00       	mov    $0x4,%eax
  801875:	e8 ca fe ff ff       	call   801744 <fsipc>
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <devfile_read>:
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	56                   	push   %esi
  801880:	53                   	push   %ebx
  801881:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801884:	8b 45 08             	mov    0x8(%ebp),%eax
  801887:	8b 40 0c             	mov    0xc(%eax),%eax
  80188a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80188f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801895:	ba 00 00 00 00       	mov    $0x0,%edx
  80189a:	b8 03 00 00 00       	mov    $0x3,%eax
  80189f:	e8 a0 fe ff ff       	call   801744 <fsipc>
  8018a4:	89 c3                	mov    %eax,%ebx
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 1f                	js     8018c9 <devfile_read+0x4d>
	assert(r <= n);
  8018aa:	39 f0                	cmp    %esi,%eax
  8018ac:	77 24                	ja     8018d2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018ae:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018b3:	7f 33                	jg     8018e8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	50                   	push   %eax
  8018b9:	68 00 50 80 00       	push   $0x805000
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	e8 df f0 ff ff       	call   8009a5 <memmove>
	return r;
  8018c6:	83 c4 10             	add    $0x10,%esp
}
  8018c9:	89 d8                	mov    %ebx,%eax
  8018cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5e                   	pop    %esi
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    
	assert(r <= n);
  8018d2:	68 44 2b 80 00       	push   $0x802b44
  8018d7:	68 4b 2b 80 00       	push   $0x802b4b
  8018dc:	6a 7b                	push   $0x7b
  8018de:	68 60 2b 80 00       	push   $0x802b60
  8018e3:	e8 ea 09 00 00       	call   8022d2 <_panic>
	assert(r <= PGSIZE);
  8018e8:	68 6b 2b 80 00       	push   $0x802b6b
  8018ed:	68 4b 2b 80 00       	push   $0x802b4b
  8018f2:	6a 7c                	push   $0x7c
  8018f4:	68 60 2b 80 00       	push   $0x802b60
  8018f9:	e8 d4 09 00 00       	call   8022d2 <_panic>

008018fe <open>:
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	56                   	push   %esi
  801902:	53                   	push   %ebx
  801903:	83 ec 1c             	sub    $0x1c,%esp
  801906:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801909:	56                   	push   %esi
  80190a:	e8 d1 ee ff ff       	call   8007e0 <strlen>
  80190f:	83 c4 10             	add    $0x10,%esp
  801912:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801917:	7f 6c                	jg     801985 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801919:	83 ec 0c             	sub    $0xc,%esp
  80191c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191f:	50                   	push   %eax
  801920:	e8 b4 f8 ff ff       	call   8011d9 <fd_alloc>
  801925:	89 c3                	mov    %eax,%ebx
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 3c                	js     80196a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80192e:	83 ec 08             	sub    $0x8,%esp
  801931:	56                   	push   %esi
  801932:	68 00 50 80 00       	push   $0x805000
  801937:	e8 db ee ff ff       	call   800817 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801944:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801947:	b8 01 00 00 00       	mov    $0x1,%eax
  80194c:	e8 f3 fd ff ff       	call   801744 <fsipc>
  801951:	89 c3                	mov    %eax,%ebx
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 19                	js     801973 <open+0x75>
	return fd2num(fd);
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	ff 75 f4             	pushl  -0xc(%ebp)
  801960:	e8 4d f8 ff ff       	call   8011b2 <fd2num>
  801965:	89 c3                	mov    %eax,%ebx
  801967:	83 c4 10             	add    $0x10,%esp
}
  80196a:	89 d8                	mov    %ebx,%eax
  80196c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    
		fd_close(fd, 0);
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	6a 00                	push   $0x0
  801978:	ff 75 f4             	pushl  -0xc(%ebp)
  80197b:	e8 54 f9 ff ff       	call   8012d4 <fd_close>
		return r;
  801980:	83 c4 10             	add    $0x10,%esp
  801983:	eb e5                	jmp    80196a <open+0x6c>
		return -E_BAD_PATH;
  801985:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80198a:	eb de                	jmp    80196a <open+0x6c>

0080198c <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
  801997:	b8 08 00 00 00       	mov    $0x8,%eax
  80199c:	e8 a3 fd ff ff       	call   801744 <fsipc>
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8019a9:	68 77 2b 80 00       	push   $0x802b77
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	e8 61 ee ff ff       	call   800817 <strcpy>
	return 0;
}
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <devsock_close>:
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	53                   	push   %ebx
  8019c1:	83 ec 10             	sub    $0x10,%esp
  8019c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019c7:	53                   	push   %ebx
  8019c8:	e8 d6 09 00 00       	call   8023a3 <pageref>
  8019cd:	83 c4 10             	add    $0x10,%esp
		return 0;
  8019d0:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8019d5:	83 f8 01             	cmp    $0x1,%eax
  8019d8:	74 07                	je     8019e1 <devsock_close+0x24>
}
  8019da:	89 d0                	mov    %edx,%eax
  8019dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	ff 73 0c             	pushl  0xc(%ebx)
  8019e7:	e8 b7 02 00 00       	call   801ca3 <nsipc_close>
  8019ec:	89 c2                	mov    %eax,%edx
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	eb e7                	jmp    8019da <devsock_close+0x1d>

008019f3 <devsock_write>:
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	ff 75 10             	pushl  0x10(%ebp)
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	ff 70 0c             	pushl  0xc(%eax)
  801a07:	e8 74 03 00 00       	call   801d80 <nsipc_send>
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <devsock_read>:
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 10             	pushl  0x10(%ebp)
  801a19:	ff 75 0c             	pushl  0xc(%ebp)
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	ff 70 0c             	pushl  0xc(%eax)
  801a22:	e8 ed 02 00 00       	call   801d14 <nsipc_recv>
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <fd2sockid>:
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a32:	52                   	push   %edx
  801a33:	50                   	push   %eax
  801a34:	e8 ef f7 ff ff       	call   801228 <fd_lookup>
  801a39:	83 c4 10             	add    $0x10,%esp
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 10                	js     801a50 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a43:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a49:	39 08                	cmp    %ecx,(%eax)
  801a4b:	75 05                	jne    801a52 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801a4d:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    
		return -E_NOT_SUPP;
  801a52:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a57:	eb f7                	jmp    801a50 <fd2sockid+0x27>

00801a59 <alloc_sockfd>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 1c             	sub    $0x1c,%esp
  801a61:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801a63:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a66:	50                   	push   %eax
  801a67:	e8 6d f7 ff ff       	call   8011d9 <fd_alloc>
  801a6c:	89 c3                	mov    %eax,%ebx
  801a6e:	83 c4 10             	add    $0x10,%esp
  801a71:	85 c0                	test   %eax,%eax
  801a73:	78 43                	js     801ab8 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	68 07 04 00 00       	push   $0x407
  801a7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a80:	6a 00                	push   $0x0
  801a82:	e8 89 f1 ff ff       	call   800c10 <sys_page_alloc>
  801a87:	89 c3                	mov    %eax,%ebx
  801a89:	83 c4 10             	add    $0x10,%esp
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 28                	js     801ab8 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a93:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a99:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a9e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801aa5:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801aa8:	83 ec 0c             	sub    $0xc,%esp
  801aab:	50                   	push   %eax
  801aac:	e8 01 f7 ff ff       	call   8011b2 <fd2num>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	83 c4 10             	add    $0x10,%esp
  801ab6:	eb 0c                	jmp    801ac4 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	56                   	push   %esi
  801abc:	e8 e2 01 00 00       	call   801ca3 <nsipc_close>
		return r;
  801ac1:	83 c4 10             	add    $0x10,%esp
}
  801ac4:	89 d8                	mov    %ebx,%eax
  801ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    

00801acd <accept>:
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	e8 4e ff ff ff       	call   801a29 <fd2sockid>
  801adb:	85 c0                	test   %eax,%eax
  801add:	78 1b                	js     801afa <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	ff 75 10             	pushl  0x10(%ebp)
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	50                   	push   %eax
  801ae9:	e8 0e 01 00 00       	call   801bfc <nsipc_accept>
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	85 c0                	test   %eax,%eax
  801af3:	78 05                	js     801afa <accept+0x2d>
	return alloc_sockfd(r);
  801af5:	e8 5f ff ff ff       	call   801a59 <alloc_sockfd>
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <bind>:
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	e8 1f ff ff ff       	call   801a29 <fd2sockid>
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 12                	js     801b20 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	ff 75 10             	pushl  0x10(%ebp)
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	e8 2f 01 00 00       	call   801c4c <nsipc_bind>
  801b1d:	83 c4 10             	add    $0x10,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <shutdown>:
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	e8 f9 fe ff ff       	call   801a29 <fd2sockid>
  801b30:	85 c0                	test   %eax,%eax
  801b32:	78 0f                	js     801b43 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801b34:	83 ec 08             	sub    $0x8,%esp
  801b37:	ff 75 0c             	pushl  0xc(%ebp)
  801b3a:	50                   	push   %eax
  801b3b:	e8 41 01 00 00       	call   801c81 <nsipc_shutdown>
  801b40:	83 c4 10             	add    $0x10,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <connect>:
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	e8 d6 fe ff ff       	call   801a29 <fd2sockid>
  801b53:	85 c0                	test   %eax,%eax
  801b55:	78 12                	js     801b69 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801b57:	83 ec 04             	sub    $0x4,%esp
  801b5a:	ff 75 10             	pushl  0x10(%ebp)
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	50                   	push   %eax
  801b61:	e8 57 01 00 00       	call   801cbd <nsipc_connect>
  801b66:	83 c4 10             	add    $0x10,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <listen>:
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
  801b6e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	e8 b0 fe ff ff       	call   801a29 <fd2sockid>
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	78 0f                	js     801b8c <listen+0x21>
	return nsipc_listen(r, backlog);
  801b7d:	83 ec 08             	sub    $0x8,%esp
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	50                   	push   %eax
  801b84:	e8 69 01 00 00       	call   801cf2 <nsipc_listen>
  801b89:	83 c4 10             	add    $0x10,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <socket>:

int
socket(int domain, int type, int protocol)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b94:	ff 75 10             	pushl  0x10(%ebp)
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	e8 3c 02 00 00       	call   801dde <nsipc_socket>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 05                	js     801bae <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ba9:	e8 ab fe ff ff       	call   801a59 <alloc_sockfd>
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	53                   	push   %ebx
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bb9:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bc0:	74 26                	je     801be8 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bc2:	6a 07                	push   $0x7
  801bc4:	68 00 60 80 00       	push   $0x806000
  801bc9:	53                   	push   %ebx
  801bca:	ff 35 04 40 80 00    	pushl  0x804004
  801bd0:	e8 50 f5 ff ff       	call   801125 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bd5:	83 c4 0c             	add    $0xc,%esp
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	e8 db f4 ff ff       	call   8010be <ipc_recv>
}
  801be3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	6a 02                	push   $0x2
  801bed:	e8 87 f5 ff ff       	call   801179 <ipc_find_env>
  801bf2:	a3 04 40 80 00       	mov    %eax,0x804004
  801bf7:	83 c4 10             	add    $0x10,%esp
  801bfa:	eb c6                	jmp    801bc2 <nsipc+0x12>

00801bfc <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	56                   	push   %esi
  801c00:	53                   	push   %ebx
  801c01:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c0c:	8b 06                	mov    (%esi),%eax
  801c0e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c13:	b8 01 00 00 00       	mov    $0x1,%eax
  801c18:	e8 93 ff ff ff       	call   801bb0 <nsipc>
  801c1d:	89 c3                	mov    %eax,%ebx
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 20                	js     801c43 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	ff 35 10 60 80 00    	pushl  0x806010
  801c2c:	68 00 60 80 00       	push   $0x806000
  801c31:	ff 75 0c             	pushl  0xc(%ebp)
  801c34:	e8 6c ed ff ff       	call   8009a5 <memmove>
		*addrlen = ret->ret_addrlen;
  801c39:	a1 10 60 80 00       	mov    0x806010,%eax
  801c3e:	89 06                	mov    %eax,(%esi)
  801c40:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801c43:	89 d8                	mov    %ebx,%eax
  801c45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c48:	5b                   	pop    %ebx
  801c49:	5e                   	pop    %esi
  801c4a:	5d                   	pop    %ebp
  801c4b:	c3                   	ret    

00801c4c <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c5e:	53                   	push   %ebx
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	68 04 60 80 00       	push   $0x806004
  801c67:	e8 39 ed ff ff       	call   8009a5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c6c:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c72:	b8 02 00 00 00       	mov    $0x2,%eax
  801c77:	e8 34 ff ff ff       	call   801bb0 <nsipc>
}
  801c7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c92:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c97:	b8 03 00 00 00       	mov    $0x3,%eax
  801c9c:	e8 0f ff ff ff       	call   801bb0 <nsipc>
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <nsipc_close>:

int
nsipc_close(int s)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  801cb6:	e8 f5 fe ff ff       	call   801bb0 <nsipc>
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	53                   	push   %ebx
  801cc1:	83 ec 08             	sub    $0x8,%esp
  801cc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ccf:	53                   	push   %ebx
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	68 04 60 80 00       	push   $0x806004
  801cd8:	e8 c8 ec ff ff       	call   8009a5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801cdd:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ce3:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce8:	e8 c3 fe ff ff       	call   801bb0 <nsipc>
}
  801ced:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d08:	b8 06 00 00 00       	mov    $0x6,%eax
  801d0d:	e8 9e fe ff ff       	call   801bb0 <nsipc>
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	56                   	push   %esi
  801d18:	53                   	push   %ebx
  801d19:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d24:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d32:	b8 07 00 00 00       	mov    $0x7,%eax
  801d37:	e8 74 fe ff ff       	call   801bb0 <nsipc>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 1f                	js     801d61 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801d42:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d47:	7f 21                	jg     801d6a <nsipc_recv+0x56>
  801d49:	39 c6                	cmp    %eax,%esi
  801d4b:	7c 1d                	jl     801d6a <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	50                   	push   %eax
  801d51:	68 00 60 80 00       	push   $0x806000
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	e8 47 ec ff ff       	call   8009a5 <memmove>
  801d5e:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801d61:	89 d8                	mov    %ebx,%eax
  801d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5d                   	pop    %ebp
  801d69:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801d6a:	68 83 2b 80 00       	push   $0x802b83
  801d6f:	68 4b 2b 80 00       	push   $0x802b4b
  801d74:	6a 62                	push   $0x62
  801d76:	68 98 2b 80 00       	push   $0x802b98
  801d7b:	e8 52 05 00 00       	call   8022d2 <_panic>

00801d80 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	53                   	push   %ebx
  801d84:	83 ec 04             	sub    $0x4,%esp
  801d87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d92:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d98:	7f 2e                	jg     801dc8 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	53                   	push   %ebx
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	68 0c 60 80 00       	push   $0x80600c
  801da6:	e8 fa eb ff ff       	call   8009a5 <memmove>
	nsipcbuf.send.req_size = size;
  801dab:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801db1:	8b 45 14             	mov    0x14(%ebp),%eax
  801db4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801db9:	b8 08 00 00 00       	mov    $0x8,%eax
  801dbe:	e8 ed fd ff ff       	call   801bb0 <nsipc>
}
  801dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc6:	c9                   	leave  
  801dc7:	c3                   	ret    
	assert(size < 1600);
  801dc8:	68 a4 2b 80 00       	push   $0x802ba4
  801dcd:	68 4b 2b 80 00       	push   $0x802b4b
  801dd2:	6a 6d                	push   $0x6d
  801dd4:	68 98 2b 80 00       	push   $0x802b98
  801dd9:	e8 f4 04 00 00       	call   8022d2 <_panic>

00801dde <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801def:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801df4:	8b 45 10             	mov    0x10(%ebp),%eax
  801df7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dfc:	b8 09 00 00 00       	mov    $0x9,%eax
  801e01:	e8 aa fd ff ff       	call   801bb0 <nsipc>
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	56                   	push   %esi
  801e0c:	53                   	push   %ebx
  801e0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	ff 75 08             	pushl  0x8(%ebp)
  801e16:	e8 a7 f3 ff ff       	call   8011c2 <fd2data>
  801e1b:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e1d:	83 c4 08             	add    $0x8,%esp
  801e20:	68 b0 2b 80 00       	push   $0x802bb0
  801e25:	53                   	push   %ebx
  801e26:	e8 ec e9 ff ff       	call   800817 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e2b:	8b 46 04             	mov    0x4(%esi),%eax
  801e2e:	2b 06                	sub    (%esi),%eax
  801e30:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e3d:	00 00 00 
	stat->st_dev = &devpipe;
  801e40:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e47:	30 80 00 
	return 0;
}
  801e4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e52:	5b                   	pop    %ebx
  801e53:	5e                   	pop    %esi
  801e54:	5d                   	pop    %ebp
  801e55:	c3                   	ret    

00801e56 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e60:	53                   	push   %ebx
  801e61:	6a 00                	push   $0x0
  801e63:	e8 2d ee ff ff       	call   800c95 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e68:	89 1c 24             	mov    %ebx,(%esp)
  801e6b:	e8 52 f3 ff ff       	call   8011c2 <fd2data>
  801e70:	83 c4 08             	add    $0x8,%esp
  801e73:	50                   	push   %eax
  801e74:	6a 00                	push   $0x0
  801e76:	e8 1a ee ff ff       	call   800c95 <sys_page_unmap>
}
  801e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <_pipeisclosed>:
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	57                   	push   %edi
  801e84:	56                   	push   %esi
  801e85:	53                   	push   %ebx
  801e86:	83 ec 1c             	sub    $0x1c,%esp
  801e89:	89 c7                	mov    %eax,%edi
  801e8b:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e8d:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801e92:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	57                   	push   %edi
  801e99:	e8 05 05 00 00       	call   8023a3 <pageref>
  801e9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ea1:	89 34 24             	mov    %esi,(%esp)
  801ea4:	e8 fa 04 00 00       	call   8023a3 <pageref>
		nn = thisenv->env_runs;
  801ea9:	8b 15 0c 40 80 00    	mov    0x80400c,%edx
  801eaf:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	39 cb                	cmp    %ecx,%ebx
  801eb7:	74 1b                	je     801ed4 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801eb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ebc:	75 cf                	jne    801e8d <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ebe:	8b 42 58             	mov    0x58(%edx),%eax
  801ec1:	6a 01                	push   $0x1
  801ec3:	50                   	push   %eax
  801ec4:	53                   	push   %ebx
  801ec5:	68 b7 2b 80 00       	push   $0x802bb7
  801eca:	e8 29 e3 ff ff       	call   8001f8 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	eb b9                	jmp    801e8d <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801ed4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ed7:	0f 94 c0             	sete   %al
  801eda:	0f b6 c0             	movzbl %al,%eax
}
  801edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    

00801ee5 <devpipe_write>:
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	57                   	push   %edi
  801ee9:	56                   	push   %esi
  801eea:	53                   	push   %ebx
  801eeb:	83 ec 28             	sub    $0x28,%esp
  801eee:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801ef1:	56                   	push   %esi
  801ef2:	e8 cb f2 ff ff       	call   8011c2 <fd2data>
  801ef7:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ef9:	83 c4 10             	add    $0x10,%esp
  801efc:	bf 00 00 00 00       	mov    $0x0,%edi
  801f01:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f04:	74 4f                	je     801f55 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f06:	8b 43 04             	mov    0x4(%ebx),%eax
  801f09:	8b 0b                	mov    (%ebx),%ecx
  801f0b:	8d 51 20             	lea    0x20(%ecx),%edx
  801f0e:	39 d0                	cmp    %edx,%eax
  801f10:	72 14                	jb     801f26 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801f12:	89 da                	mov    %ebx,%edx
  801f14:	89 f0                	mov    %esi,%eax
  801f16:	e8 65 ff ff ff       	call   801e80 <_pipeisclosed>
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	75 3a                	jne    801f59 <devpipe_write+0x74>
			sys_yield();
  801f1f:	e8 cd ec ff ff       	call   800bf1 <sys_yield>
  801f24:	eb e0                	jmp    801f06 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f29:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f2d:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	c1 fa 1f             	sar    $0x1f,%edx
  801f35:	89 d1                	mov    %edx,%ecx
  801f37:	c1 e9 1b             	shr    $0x1b,%ecx
  801f3a:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801f3d:	83 e2 1f             	and    $0x1f,%edx
  801f40:	29 ca                	sub    %ecx,%edx
  801f42:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801f46:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801f4a:	83 c0 01             	add    $0x1,%eax
  801f4d:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801f50:	83 c7 01             	add    $0x1,%edi
  801f53:	eb ac                	jmp    801f01 <devpipe_write+0x1c>
	return i;
  801f55:	89 f8                	mov    %edi,%eax
  801f57:	eb 05                	jmp    801f5e <devpipe_write+0x79>
				return 0;
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f61:	5b                   	pop    %ebx
  801f62:	5e                   	pop    %esi
  801f63:	5f                   	pop    %edi
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <devpipe_read>:
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	57                   	push   %edi
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
  801f6c:	83 ec 18             	sub    $0x18,%esp
  801f6f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f72:	57                   	push   %edi
  801f73:	e8 4a f2 ff ff       	call   8011c2 <fd2data>
  801f78:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	be 00 00 00 00       	mov    $0x0,%esi
  801f82:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f85:	74 47                	je     801fce <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801f87:	8b 03                	mov    (%ebx),%eax
  801f89:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f8c:	75 22                	jne    801fb0 <devpipe_read+0x4a>
			if (i > 0)
  801f8e:	85 f6                	test   %esi,%esi
  801f90:	75 14                	jne    801fa6 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801f92:	89 da                	mov    %ebx,%edx
  801f94:	89 f8                	mov    %edi,%eax
  801f96:	e8 e5 fe ff ff       	call   801e80 <_pipeisclosed>
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	75 33                	jne    801fd2 <devpipe_read+0x6c>
			sys_yield();
  801f9f:	e8 4d ec ff ff       	call   800bf1 <sys_yield>
  801fa4:	eb e1                	jmp    801f87 <devpipe_read+0x21>
				return i;
  801fa6:	89 f0                	mov    %esi,%eax
}
  801fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5f                   	pop    %edi
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fb0:	99                   	cltd   
  801fb1:	c1 ea 1b             	shr    $0x1b,%edx
  801fb4:	01 d0                	add    %edx,%eax
  801fb6:	83 e0 1f             	and    $0x1f,%eax
  801fb9:	29 d0                	sub    %edx,%eax
  801fbb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fc3:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fc6:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801fc9:	83 c6 01             	add    $0x1,%esi
  801fcc:	eb b4                	jmp    801f82 <devpipe_read+0x1c>
	return i;
  801fce:	89 f0                	mov    %esi,%eax
  801fd0:	eb d6                	jmp    801fa8 <devpipe_read+0x42>
				return 0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	eb cf                	jmp    801fa8 <devpipe_read+0x42>

00801fd9 <pipe>:
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801fe1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe4:	50                   	push   %eax
  801fe5:	e8 ef f1 ff ff       	call   8011d9 <fd_alloc>
  801fea:	89 c3                	mov    %eax,%ebx
  801fec:	83 c4 10             	add    $0x10,%esp
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 5b                	js     80204e <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	68 07 04 00 00       	push   $0x407
  801ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffe:	6a 00                	push   $0x0
  802000:	e8 0b ec ff ff       	call   800c10 <sys_page_alloc>
  802005:	89 c3                	mov    %eax,%ebx
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	85 c0                	test   %eax,%eax
  80200c:	78 40                	js     80204e <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  80200e:	83 ec 0c             	sub    $0xc,%esp
  802011:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802014:	50                   	push   %eax
  802015:	e8 bf f1 ff ff       	call   8011d9 <fd_alloc>
  80201a:	89 c3                	mov    %eax,%ebx
  80201c:	83 c4 10             	add    $0x10,%esp
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 1b                	js     80203e <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	68 07 04 00 00       	push   $0x407
  80202b:	ff 75 f0             	pushl  -0x10(%ebp)
  80202e:	6a 00                	push   $0x0
  802030:	e8 db eb ff ff       	call   800c10 <sys_page_alloc>
  802035:	89 c3                	mov    %eax,%ebx
  802037:	83 c4 10             	add    $0x10,%esp
  80203a:	85 c0                	test   %eax,%eax
  80203c:	79 19                	jns    802057 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  80203e:	83 ec 08             	sub    $0x8,%esp
  802041:	ff 75 f4             	pushl  -0xc(%ebp)
  802044:	6a 00                	push   $0x0
  802046:	e8 4a ec ff ff       	call   800c95 <sys_page_unmap>
  80204b:	83 c4 10             	add    $0x10,%esp
}
  80204e:	89 d8                	mov    %ebx,%eax
  802050:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    
	va = fd2data(fd0);
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	ff 75 f4             	pushl  -0xc(%ebp)
  80205d:	e8 60 f1 ff ff       	call   8011c2 <fd2data>
  802062:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802064:	83 c4 0c             	add    $0xc,%esp
  802067:	68 07 04 00 00       	push   $0x407
  80206c:	50                   	push   %eax
  80206d:	6a 00                	push   $0x0
  80206f:	e8 9c eb ff ff       	call   800c10 <sys_page_alloc>
  802074:	89 c3                	mov    %eax,%ebx
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	0f 88 8c 00 00 00    	js     80210d <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	ff 75 f0             	pushl  -0x10(%ebp)
  802087:	e8 36 f1 ff ff       	call   8011c2 <fd2data>
  80208c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802093:	50                   	push   %eax
  802094:	6a 00                	push   $0x0
  802096:	56                   	push   %esi
  802097:	6a 00                	push   $0x0
  802099:	e8 b5 eb ff ff       	call   800c53 <sys_page_map>
  80209e:	89 c3                	mov    %eax,%ebx
  8020a0:	83 c4 20             	add    $0x20,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	78 58                	js     8020ff <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  8020a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020aa:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020b0:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8020bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bf:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020c5:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ca:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d7:	e8 d6 f0 ff ff       	call   8011b2 <fd2num>
  8020dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020df:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020e1:	83 c4 04             	add    $0x4,%esp
  8020e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8020e7:	e8 c6 f0 ff ff       	call   8011b2 <fd2num>
  8020ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ef:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020f2:	83 c4 10             	add    $0x10,%esp
  8020f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020fa:	e9 4f ff ff ff       	jmp    80204e <pipe+0x75>
	sys_page_unmap(0, va);
  8020ff:	83 ec 08             	sub    $0x8,%esp
  802102:	56                   	push   %esi
  802103:	6a 00                	push   $0x0
  802105:	e8 8b eb ff ff       	call   800c95 <sys_page_unmap>
  80210a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80210d:	83 ec 08             	sub    $0x8,%esp
  802110:	ff 75 f0             	pushl  -0x10(%ebp)
  802113:	6a 00                	push   $0x0
  802115:	e8 7b eb ff ff       	call   800c95 <sys_page_unmap>
  80211a:	83 c4 10             	add    $0x10,%esp
  80211d:	e9 1c ff ff ff       	jmp    80203e <pipe+0x65>

00802122 <pipeisclosed>:
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802128:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212b:	50                   	push   %eax
  80212c:	ff 75 08             	pushl  0x8(%ebp)
  80212f:	e8 f4 f0 ff ff       	call   801228 <fd_lookup>
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	85 c0                	test   %eax,%eax
  802139:	78 18                	js     802153 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	ff 75 f4             	pushl  -0xc(%ebp)
  802141:	e8 7c f0 ff ff       	call   8011c2 <fd2data>
	return _pipeisclosed(fd, p);
  802146:	89 c2                	mov    %eax,%edx
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	e8 30 fd ff ff       	call   801e80 <_pipeisclosed>
  802150:	83 c4 10             	add    $0x10,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
  80215d:	5d                   	pop    %ebp
  80215e:	c3                   	ret    

0080215f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802165:	68 cf 2b 80 00       	push   $0x802bcf
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	e8 a5 e6 ff ff       	call   800817 <strcpy>
	return 0;
}
  802172:	b8 00 00 00 00       	mov    $0x0,%eax
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <devcons_write>:
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	57                   	push   %edi
  80217d:	56                   	push   %esi
  80217e:	53                   	push   %ebx
  80217f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802185:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80218a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802190:	eb 2f                	jmp    8021c1 <devcons_write+0x48>
		m = n - tot;
  802192:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802195:	29 f3                	sub    %esi,%ebx
  802197:	83 fb 7f             	cmp    $0x7f,%ebx
  80219a:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80219f:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	53                   	push   %ebx
  8021a6:	89 f0                	mov    %esi,%eax
  8021a8:	03 45 0c             	add    0xc(%ebp),%eax
  8021ab:	50                   	push   %eax
  8021ac:	57                   	push   %edi
  8021ad:	e8 f3 e7 ff ff       	call   8009a5 <memmove>
		sys_cputs(buf, m);
  8021b2:	83 c4 08             	add    $0x8,%esp
  8021b5:	53                   	push   %ebx
  8021b6:	57                   	push   %edi
  8021b7:	e8 98 e9 ff ff       	call   800b54 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8021bc:	01 de                	add    %ebx,%esi
  8021be:	83 c4 10             	add    $0x10,%esp
  8021c1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c4:	72 cc                	jb     802192 <devcons_write+0x19>
}
  8021c6:	89 f0                	mov    %esi,%eax
  8021c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5e                   	pop    %esi
  8021cd:	5f                   	pop    %edi
  8021ce:	5d                   	pop    %ebp
  8021cf:	c3                   	ret    

008021d0 <devcons_read>:
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8021db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021df:	75 07                	jne    8021e8 <devcons_read+0x18>
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    
		sys_yield();
  8021e3:	e8 09 ea ff ff       	call   800bf1 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8021e8:	e8 85 e9 ff ff       	call   800b72 <sys_cgetc>
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	74 f2                	je     8021e3 <devcons_read+0x13>
	if (c < 0)
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	78 ec                	js     8021e1 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8021f5:	83 f8 04             	cmp    $0x4,%eax
  8021f8:	74 0c                	je     802206 <devcons_read+0x36>
	*(char*)vbuf = c;
  8021fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fd:	88 02                	mov    %al,(%edx)
	return 1;
  8021ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802204:	eb db                	jmp    8021e1 <devcons_read+0x11>
		return 0;
  802206:	b8 00 00 00 00       	mov    $0x0,%eax
  80220b:	eb d4                	jmp    8021e1 <devcons_read+0x11>

0080220d <cputchar>:
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802219:	6a 01                	push   $0x1
  80221b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80221e:	50                   	push   %eax
  80221f:	e8 30 e9 ff ff       	call   800b54 <sys_cputs>
}
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <getchar>:
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80222f:	6a 01                	push   $0x1
  802231:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802234:	50                   	push   %eax
  802235:	6a 00                	push   $0x0
  802237:	e8 5d f2 ff ff       	call   801499 <read>
	if (r < 0)
  80223c:	83 c4 10             	add    $0x10,%esp
  80223f:	85 c0                	test   %eax,%eax
  802241:	78 08                	js     80224b <getchar+0x22>
	if (r < 1)
  802243:	85 c0                	test   %eax,%eax
  802245:	7e 06                	jle    80224d <getchar+0x24>
	return c;
  802247:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    
		return -E_EOF;
  80224d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802252:	eb f7                	jmp    80224b <getchar+0x22>

00802254 <iscons>:
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80225a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225d:	50                   	push   %eax
  80225e:	ff 75 08             	pushl  0x8(%ebp)
  802261:	e8 c2 ef ff ff       	call   801228 <fd_lookup>
  802266:	83 c4 10             	add    $0x10,%esp
  802269:	85 c0                	test   %eax,%eax
  80226b:	78 11                	js     80227e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802276:	39 10                	cmp    %edx,(%eax)
  802278:	0f 94 c0             	sete   %al
  80227b:	0f b6 c0             	movzbl %al,%eax
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <opencons>:
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802286:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802289:	50                   	push   %eax
  80228a:	e8 4a ef ff ff       	call   8011d9 <fd_alloc>
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	85 c0                	test   %eax,%eax
  802294:	78 3a                	js     8022d0 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802296:	83 ec 04             	sub    $0x4,%esp
  802299:	68 07 04 00 00       	push   $0x407
  80229e:	ff 75 f4             	pushl  -0xc(%ebp)
  8022a1:	6a 00                	push   $0x0
  8022a3:	e8 68 e9 ff ff       	call   800c10 <sys_page_alloc>
  8022a8:	83 c4 10             	add    $0x10,%esp
  8022ab:	85 c0                	test   %eax,%eax
  8022ad:	78 21                	js     8022d0 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022b8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	50                   	push   %eax
  8022c8:	e8 e5 ee ff ff       	call   8011b2 <fd2num>
  8022cd:	83 c4 10             	add    $0x10,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	56                   	push   %esi
  8022d6:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8022d7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022da:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022e0:	e8 ed e8 ff ff       	call   800bd2 <sys_getenvid>
  8022e5:	83 ec 0c             	sub    $0xc,%esp
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	ff 75 08             	pushl  0x8(%ebp)
  8022ee:	56                   	push   %esi
  8022ef:	50                   	push   %eax
  8022f0:	68 dc 2b 80 00       	push   $0x802bdc
  8022f5:	e8 fe de ff ff       	call   8001f8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8022fa:	83 c4 18             	add    $0x18,%esp
  8022fd:	53                   	push   %ebx
  8022fe:	ff 75 10             	pushl  0x10(%ebp)
  802301:	e8 a1 de ff ff       	call   8001a7 <vcprintf>
	cprintf("\n");
  802306:	c7 04 24 c8 2b 80 00 	movl   $0x802bc8,(%esp)
  80230d:	e8 e6 de ff ff       	call   8001f8 <cprintf>
  802312:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802315:	cc                   	int3   
  802316:	eb fd                	jmp    802315 <_panic+0x43>

00802318 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  80231e:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802325:	74 0a                	je     802331 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	a3 00 70 80 00       	mov    %eax,0x807000
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  802331:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802336:	8b 40 48             	mov    0x48(%eax),%eax
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	6a 07                	push   $0x7
  80233e:	68 00 f0 bf ee       	push   $0xeebff000
  802343:	50                   	push   %eax
  802344:	e8 c7 e8 ff ff       	call   800c10 <sys_page_alloc>
  802349:	83 c4 10             	add    $0x10,%esp
  80234c:	85 c0                	test   %eax,%eax
  80234e:	78 1b                	js     80236b <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802350:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802355:	8b 40 48             	mov    0x48(%eax),%eax
  802358:	83 ec 08             	sub    $0x8,%esp
  80235b:	68 7d 23 80 00       	push   $0x80237d
  802360:	50                   	push   %eax
  802361:	e8 f5 e9 ff ff       	call   800d5b <sys_env_set_pgfault_upcall>
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	eb bc                	jmp    802327 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  80236b:	50                   	push   %eax
  80236c:	68 00 2c 80 00       	push   $0x802c00
  802371:	6a 22                	push   $0x22
  802373:	68 18 2c 80 00       	push   $0x802c18
  802378:	e8 55 ff ff ff       	call   8022d2 <_panic>

0080237d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80237d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80237e:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802383:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802385:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  802388:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  80238c:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  80238f:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  802393:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  802397:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  802399:	83 c4 08             	add    $0x8,%esp
	popal
  80239c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  80239d:	83 c4 04             	add    $0x4,%esp
	popfl
  8023a0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8023a1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8023a2:	c3                   	ret    

008023a3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023a9:	89 d0                	mov    %edx,%eax
  8023ab:	c1 e8 16             	shr    $0x16,%eax
  8023ae:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8023ba:	f6 c1 01             	test   $0x1,%cl
  8023bd:	74 1d                	je     8023dc <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023bf:	c1 ea 0c             	shr    $0xc,%edx
  8023c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023c9:	f6 c2 01             	test   $0x1,%dl
  8023cc:	74 0e                	je     8023dc <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023ce:	c1 ea 0c             	shr    $0xc,%edx
  8023d1:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023d8:	ef 
  8023d9:	0f b7 c0             	movzwl %ax,%eax
}
  8023dc:	5d                   	pop    %ebp
  8023dd:	c3                   	ret    
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__udivdi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 1c             	sub    $0x1c,%esp
  8023e7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023eb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023f3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023f7:	85 d2                	test   %edx,%edx
  8023f9:	75 35                	jne    802430 <__udivdi3+0x50>
  8023fb:	39 f3                	cmp    %esi,%ebx
  8023fd:	0f 87 bd 00 00 00    	ja     8024c0 <__udivdi3+0xe0>
  802403:	85 db                	test   %ebx,%ebx
  802405:	89 d9                	mov    %ebx,%ecx
  802407:	75 0b                	jne    802414 <__udivdi3+0x34>
  802409:	b8 01 00 00 00       	mov    $0x1,%eax
  80240e:	31 d2                	xor    %edx,%edx
  802410:	f7 f3                	div    %ebx
  802412:	89 c1                	mov    %eax,%ecx
  802414:	31 d2                	xor    %edx,%edx
  802416:	89 f0                	mov    %esi,%eax
  802418:	f7 f1                	div    %ecx
  80241a:	89 c6                	mov    %eax,%esi
  80241c:	89 e8                	mov    %ebp,%eax
  80241e:	89 f7                	mov    %esi,%edi
  802420:	f7 f1                	div    %ecx
  802422:	89 fa                	mov    %edi,%edx
  802424:	83 c4 1c             	add    $0x1c,%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5f                   	pop    %edi
  80242a:	5d                   	pop    %ebp
  80242b:	c3                   	ret    
  80242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802430:	39 f2                	cmp    %esi,%edx
  802432:	77 7c                	ja     8024b0 <__udivdi3+0xd0>
  802434:	0f bd fa             	bsr    %edx,%edi
  802437:	83 f7 1f             	xor    $0x1f,%edi
  80243a:	0f 84 98 00 00 00    	je     8024d8 <__udivdi3+0xf8>
  802440:	89 f9                	mov    %edi,%ecx
  802442:	b8 20 00 00 00       	mov    $0x20,%eax
  802447:	29 f8                	sub    %edi,%eax
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	89 da                	mov    %ebx,%edx
  802453:	d3 ea                	shr    %cl,%edx
  802455:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802459:	09 d1                	or     %edx,%ecx
  80245b:	89 f2                	mov    %esi,%edx
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e3                	shl    %cl,%ebx
  802465:	89 c1                	mov    %eax,%ecx
  802467:	d3 ea                	shr    %cl,%edx
  802469:	89 f9                	mov    %edi,%ecx
  80246b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80246f:	d3 e6                	shl    %cl,%esi
  802471:	89 eb                	mov    %ebp,%ebx
  802473:	89 c1                	mov    %eax,%ecx
  802475:	d3 eb                	shr    %cl,%ebx
  802477:	09 de                	or     %ebx,%esi
  802479:	89 f0                	mov    %esi,%eax
  80247b:	f7 74 24 08          	divl   0x8(%esp)
  80247f:	89 d6                	mov    %edx,%esi
  802481:	89 c3                	mov    %eax,%ebx
  802483:	f7 64 24 0c          	mull   0xc(%esp)
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 0c                	jb     802497 <__udivdi3+0xb7>
  80248b:	89 f9                	mov    %edi,%ecx
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	39 c5                	cmp    %eax,%ebp
  802491:	73 5d                	jae    8024f0 <__udivdi3+0x110>
  802493:	39 d6                	cmp    %edx,%esi
  802495:	75 59                	jne    8024f0 <__udivdi3+0x110>
  802497:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80249a:	31 ff                	xor    %edi,%edi
  80249c:	89 fa                	mov    %edi,%edx
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	8d 76 00             	lea    0x0(%esi),%esi
  8024a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8024b0:	31 ff                	xor    %edi,%edi
  8024b2:	31 c0                	xor    %eax,%eax
  8024b4:	89 fa                	mov    %edi,%edx
  8024b6:	83 c4 1c             	add    $0x1c,%esp
  8024b9:	5b                   	pop    %ebx
  8024ba:	5e                   	pop    %esi
  8024bb:	5f                   	pop    %edi
  8024bc:	5d                   	pop    %ebp
  8024bd:	c3                   	ret    
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	31 ff                	xor    %edi,%edi
  8024c2:	89 e8                	mov    %ebp,%eax
  8024c4:	89 f2                	mov    %esi,%edx
  8024c6:	f7 f3                	div    %ebx
  8024c8:	89 fa                	mov    %edi,%edx
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	39 f2                	cmp    %esi,%edx
  8024da:	72 06                	jb     8024e2 <__udivdi3+0x102>
  8024dc:	31 c0                	xor    %eax,%eax
  8024de:	39 eb                	cmp    %ebp,%ebx
  8024e0:	77 d2                	ja     8024b4 <__udivdi3+0xd4>
  8024e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e7:	eb cb                	jmp    8024b4 <__udivdi3+0xd4>
  8024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024f0:	89 d8                	mov    %ebx,%eax
  8024f2:	31 ff                	xor    %edi,%edi
  8024f4:	eb be                	jmp    8024b4 <__udivdi3+0xd4>
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 1c             	sub    $0x1c,%esp
  802507:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80250b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80250f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802517:	85 ed                	test   %ebp,%ebp
  802519:	89 f0                	mov    %esi,%eax
  80251b:	89 da                	mov    %ebx,%edx
  80251d:	75 19                	jne    802538 <__umoddi3+0x38>
  80251f:	39 df                	cmp    %ebx,%edi
  802521:	0f 86 b1 00 00 00    	jbe    8025d8 <__umoddi3+0xd8>
  802527:	f7 f7                	div    %edi
  802529:	89 d0                	mov    %edx,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	83 c4 1c             	add    $0x1c,%esp
  802530:	5b                   	pop    %ebx
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	39 dd                	cmp    %ebx,%ebp
  80253a:	77 f1                	ja     80252d <__umoddi3+0x2d>
  80253c:	0f bd cd             	bsr    %ebp,%ecx
  80253f:	83 f1 1f             	xor    $0x1f,%ecx
  802542:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802546:	0f 84 b4 00 00 00    	je     802600 <__umoddi3+0x100>
  80254c:	b8 20 00 00 00       	mov    $0x20,%eax
  802551:	89 c2                	mov    %eax,%edx
  802553:	8b 44 24 04          	mov    0x4(%esp),%eax
  802557:	29 c2                	sub    %eax,%edx
  802559:	89 c1                	mov    %eax,%ecx
  80255b:	89 f8                	mov    %edi,%eax
  80255d:	d3 e5                	shl    %cl,%ebp
  80255f:	89 d1                	mov    %edx,%ecx
  802561:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802565:	d3 e8                	shr    %cl,%eax
  802567:	09 c5                	or     %eax,%ebp
  802569:	8b 44 24 04          	mov    0x4(%esp),%eax
  80256d:	89 c1                	mov    %eax,%ecx
  80256f:	d3 e7                	shl    %cl,%edi
  802571:	89 d1                	mov    %edx,%ecx
  802573:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802577:	89 df                	mov    %ebx,%edi
  802579:	d3 ef                	shr    %cl,%edi
  80257b:	89 c1                	mov    %eax,%ecx
  80257d:	89 f0                	mov    %esi,%eax
  80257f:	d3 e3                	shl    %cl,%ebx
  802581:	89 d1                	mov    %edx,%ecx
  802583:	89 fa                	mov    %edi,%edx
  802585:	d3 e8                	shr    %cl,%eax
  802587:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80258c:	09 d8                	or     %ebx,%eax
  80258e:	f7 f5                	div    %ebp
  802590:	d3 e6                	shl    %cl,%esi
  802592:	89 d1                	mov    %edx,%ecx
  802594:	f7 64 24 08          	mull   0x8(%esp)
  802598:	39 d1                	cmp    %edx,%ecx
  80259a:	89 c3                	mov    %eax,%ebx
  80259c:	89 d7                	mov    %edx,%edi
  80259e:	72 06                	jb     8025a6 <__umoddi3+0xa6>
  8025a0:	75 0e                	jne    8025b0 <__umoddi3+0xb0>
  8025a2:	39 c6                	cmp    %eax,%esi
  8025a4:	73 0a                	jae    8025b0 <__umoddi3+0xb0>
  8025a6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8025aa:	19 ea                	sbb    %ebp,%edx
  8025ac:	89 d7                	mov    %edx,%edi
  8025ae:	89 c3                	mov    %eax,%ebx
  8025b0:	89 ca                	mov    %ecx,%edx
  8025b2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8025b7:	29 de                	sub    %ebx,%esi
  8025b9:	19 fa                	sbb    %edi,%edx
  8025bb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8025bf:	89 d0                	mov    %edx,%eax
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 d9                	mov    %ebx,%ecx
  8025c5:	d3 ee                	shr    %cl,%esi
  8025c7:	d3 ea                	shr    %cl,%edx
  8025c9:	09 f0                	or     %esi,%eax
  8025cb:	83 c4 1c             	add    $0x1c,%esp
  8025ce:	5b                   	pop    %ebx
  8025cf:	5e                   	pop    %esi
  8025d0:	5f                   	pop    %edi
  8025d1:	5d                   	pop    %ebp
  8025d2:	c3                   	ret    
  8025d3:	90                   	nop
  8025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025d8:	85 ff                	test   %edi,%edi
  8025da:	89 f9                	mov    %edi,%ecx
  8025dc:	75 0b                	jne    8025e9 <__umoddi3+0xe9>
  8025de:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e3:	31 d2                	xor    %edx,%edx
  8025e5:	f7 f7                	div    %edi
  8025e7:	89 c1                	mov    %eax,%ecx
  8025e9:	89 d8                	mov    %ebx,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f1                	div    %ecx
  8025ef:	89 f0                	mov    %esi,%eax
  8025f1:	f7 f1                	div    %ecx
  8025f3:	e9 31 ff ff ff       	jmp    802529 <__umoddi3+0x29>
  8025f8:	90                   	nop
  8025f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802600:	39 dd                	cmp    %ebx,%ebp
  802602:	72 08                	jb     80260c <__umoddi3+0x10c>
  802604:	39 f7                	cmp    %esi,%edi
  802606:	0f 87 21 ff ff ff    	ja     80252d <__umoddi3+0x2d>
  80260c:	89 da                	mov    %ebx,%edx
  80260e:	89 f0                	mov    %esi,%eax
  802610:	29 f8                	sub    %edi,%eax
  802612:	19 ea                	sbb    %ebp,%edx
  802614:	e9 14 ff ff ff       	jmp    80252d <__umoddi3+0x2d>

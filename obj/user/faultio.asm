
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 3e 00 00 00       	call   80006f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	75 1d                	jne    80005d <umain+0x2a>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800040:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800045:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80004a:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  80004b:	83 ec 0c             	sub    $0xc,%esp
  80004e:	68 8e 22 80 00       	push   $0x80228e
  800053:	e8 0c 01 00 00       	call   800164 <cprintf>
}
  800058:	83 c4 10             	add    $0x10,%esp
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    
		cprintf("eflags wrong\n");
  80005d:	83 ec 0c             	sub    $0xc,%esp
  800060:	68 80 22 80 00       	push   $0x802280
  800065:	e8 fa 00 00 00       	call   800164 <cprintf>
  80006a:	83 c4 10             	add    $0x10,%esp
  80006d:	eb d1                	jmp    800040 <umain+0xd>

0080006f <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800077:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80007a:	e8 bf 0a 00 00       	call   800b3e <sys_getenvid>
  80007f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800084:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800087:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008c:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800091:	85 db                	test   %ebx,%ebx
  800093:	7e 07                	jle    80009c <libmain+0x2d>
		binaryname = argv[0];
  800095:	8b 06                	mov    (%esi),%eax
  800097:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009c:	83 ec 08             	sub    $0x8,%esp
  80009f:	56                   	push   %esi
  8000a0:	53                   	push   %ebx
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 0a 00 00 00       	call   8000b5 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000b1:	5b                   	pop    %ebx
  8000b2:	5e                   	pop    %esi
  8000b3:	5d                   	pop    %ebp
  8000b4:	c3                   	ret    

008000b5 <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000bb:	e8 a2 0e 00 00       	call   800f62 <close_all>
	sys_env_destroy(0);
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	6a 00                	push   $0x0
  8000c5:	e8 33 0a 00 00       	call   800afd <sys_env_destroy>
}
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	c9                   	leave  
  8000ce:	c3                   	ret    

008000cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	53                   	push   %ebx
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d9:	8b 13                	mov    (%ebx),%edx
  8000db:	8d 42 01             	lea    0x1(%edx),%eax
  8000de:	89 03                	mov    %eax,(%ebx)
  8000e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ec:	74 09                	je     8000f7 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000ee:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000f7:	83 ec 08             	sub    $0x8,%esp
  8000fa:	68 ff 00 00 00       	push   $0xff
  8000ff:	8d 43 08             	lea    0x8(%ebx),%eax
  800102:	50                   	push   %eax
  800103:	e8 b8 09 00 00       	call   800ac0 <sys_cputs>
		b->idx = 0;
  800108:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	eb db                	jmp    8000ee <putch+0x1f>

00800113 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80011c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800123:	00 00 00 
	b.cnt = 0;
  800126:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80012d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800130:	ff 75 0c             	pushl  0xc(%ebp)
  800133:	ff 75 08             	pushl  0x8(%ebp)
  800136:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80013c:	50                   	push   %eax
  80013d:	68 cf 00 80 00       	push   $0x8000cf
  800142:	e8 1a 01 00 00       	call   800261 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800147:	83 c4 08             	add    $0x8,%esp
  80014a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800150:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800156:	50                   	push   %eax
  800157:	e8 64 09 00 00       	call   800ac0 <sys_cputs>

	return b.cnt;
}
  80015c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800162:	c9                   	leave  
  800163:	c3                   	ret    

00800164 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016d:	50                   	push   %eax
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	e8 9d ff ff ff       	call   800113 <vcprintf>
	va_end(ap);

	return cnt;
}
  800176:	c9                   	leave  
  800177:	c3                   	ret    

00800178 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	57                   	push   %edi
  80017c:	56                   	push   %esi
  80017d:	53                   	push   %ebx
  80017e:	83 ec 1c             	sub    $0x1c,%esp
  800181:	89 c7                	mov    %eax,%edi
  800183:	89 d6                	mov    %edx,%esi
  800185:	8b 45 08             	mov    0x8(%ebp),%eax
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80018e:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800191:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800194:	bb 00 00 00 00       	mov    $0x0,%ebx
  800199:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80019c:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80019f:	39 d3                	cmp    %edx,%ebx
  8001a1:	72 05                	jb     8001a8 <printnum+0x30>
  8001a3:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001a6:	77 7a                	ja     800222 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	ff 75 18             	pushl  0x18(%ebp)
  8001ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8001b1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001b4:	53                   	push   %ebx
  8001b5:	ff 75 10             	pushl  0x10(%ebp)
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001be:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001c4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001c7:	e8 64 1e 00 00       	call   802030 <__udivdi3>
  8001cc:	83 c4 18             	add    $0x18,%esp
  8001cf:	52                   	push   %edx
  8001d0:	50                   	push   %eax
  8001d1:	89 f2                	mov    %esi,%edx
  8001d3:	89 f8                	mov    %edi,%eax
  8001d5:	e8 9e ff ff ff       	call   800178 <printnum>
  8001da:	83 c4 20             	add    $0x20,%esp
  8001dd:	eb 13                	jmp    8001f2 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001df:	83 ec 08             	sub    $0x8,%esp
  8001e2:	56                   	push   %esi
  8001e3:	ff 75 18             	pushl  0x18(%ebp)
  8001e6:	ff d7                	call   *%edi
  8001e8:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001eb:	83 eb 01             	sub    $0x1,%ebx
  8001ee:	85 db                	test   %ebx,%ebx
  8001f0:	7f ed                	jg     8001df <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	56                   	push   %esi
  8001f6:	83 ec 04             	sub    $0x4,%esp
  8001f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800202:	ff 75 d8             	pushl  -0x28(%ebp)
  800205:	e8 46 1f 00 00       	call   802150 <__umoddi3>
  80020a:	83 c4 14             	add    $0x14,%esp
  80020d:	0f be 80 b2 22 80 00 	movsbl 0x8022b2(%eax),%eax
  800214:	50                   	push   %eax
  800215:	ff d7                	call   *%edi
}
  800217:	83 c4 10             	add    $0x10,%esp
  80021a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5f                   	pop    %edi
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    
  800222:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800225:	eb c4                	jmp    8001eb <printnum+0x73>

00800227 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80022d:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800231:	8b 10                	mov    (%eax),%edx
  800233:	3b 50 04             	cmp    0x4(%eax),%edx
  800236:	73 0a                	jae    800242 <sprintputch+0x1b>
		*b->buf++ = ch;
  800238:	8d 4a 01             	lea    0x1(%edx),%ecx
  80023b:	89 08                	mov    %ecx,(%eax)
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	88 02                	mov    %al,(%edx)
}
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <printfmt>:
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80024a:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80024d:	50                   	push   %eax
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 0c             	pushl  0xc(%ebp)
  800254:	ff 75 08             	pushl  0x8(%ebp)
  800257:	e8 05 00 00 00       	call   800261 <vprintfmt>
}
  80025c:	83 c4 10             	add    $0x10,%esp
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <vprintfmt>:
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 2c             	sub    $0x2c,%esp
  80026a:	8b 75 08             	mov    0x8(%ebp),%esi
  80026d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800270:	8b 7d 10             	mov    0x10(%ebp),%edi
  800273:	e9 c1 03 00 00       	jmp    800639 <vprintfmt+0x3d8>
		padc = ' ';
  800278:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80027c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800283:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80028a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800291:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800296:	8d 47 01             	lea    0x1(%edi),%eax
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	0f b6 17             	movzbl (%edi),%edx
  80029f:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002a2:	3c 55                	cmp    $0x55,%al
  8002a4:	0f 87 12 04 00 00    	ja     8006bc <vprintfmt+0x45b>
  8002aa:	0f b6 c0             	movzbl %al,%eax
  8002ad:	ff 24 85 00 24 80 00 	jmp    *0x802400(,%eax,4)
  8002b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002b7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002bb:	eb d9                	jmp    800296 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002bd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002c0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002c4:	eb d0                	jmp    800296 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002c6:	0f b6 d2             	movzbl %dl,%edx
  8002c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002d1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002d4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002d7:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8002db:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002de:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002e1:	83 f9 09             	cmp    $0x9,%ecx
  8002e4:	77 55                	ja     80033b <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  8002e6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8002e9:	eb e9                	jmp    8002d4 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  8002eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ee:	8b 00                	mov    (%eax),%eax
  8002f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002f6:	8d 40 04             	lea    0x4(%eax),%eax
  8002f9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800303:	79 91                	jns    800296 <vprintfmt+0x35>
				width = precision, precision = -1;
  800305:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800308:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80030b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800312:	eb 82                	jmp    800296 <vprintfmt+0x35>
  800314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800317:	85 c0                	test   %eax,%eax
  800319:	ba 00 00 00 00       	mov    $0x0,%edx
  80031e:	0f 49 d0             	cmovns %eax,%edx
  800321:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800324:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800327:	e9 6a ff ff ff       	jmp    800296 <vprintfmt+0x35>
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80032f:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800336:	e9 5b ff ff ff       	jmp    800296 <vprintfmt+0x35>
  80033b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80033e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800341:	eb bc                	jmp    8002ff <vprintfmt+0x9e>
			lflag++;
  800343:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800346:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800349:	e9 48 ff ff ff       	jmp    800296 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80034e:	8b 45 14             	mov    0x14(%ebp),%eax
  800351:	8d 78 04             	lea    0x4(%eax),%edi
  800354:	83 ec 08             	sub    $0x8,%esp
  800357:	53                   	push   %ebx
  800358:	ff 30                	pushl  (%eax)
  80035a:	ff d6                	call   *%esi
			break;
  80035c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80035f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800362:	e9 cf 02 00 00       	jmp    800636 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800367:	8b 45 14             	mov    0x14(%ebp),%eax
  80036a:	8d 78 04             	lea    0x4(%eax),%edi
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	99                   	cltd   
  800370:	31 d0                	xor    %edx,%eax
  800372:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800374:	83 f8 0f             	cmp    $0xf,%eax
  800377:	7f 23                	jg     80039c <vprintfmt+0x13b>
  800379:	8b 14 85 60 25 80 00 	mov    0x802560(,%eax,4),%edx
  800380:	85 d2                	test   %edx,%edx
  800382:	74 18                	je     80039c <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800384:	52                   	push   %edx
  800385:	68 95 26 80 00       	push   $0x802695
  80038a:	53                   	push   %ebx
  80038b:	56                   	push   %esi
  80038c:	e8 b3 fe ff ff       	call   800244 <printfmt>
  800391:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800394:	89 7d 14             	mov    %edi,0x14(%ebp)
  800397:	e9 9a 02 00 00       	jmp    800636 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80039c:	50                   	push   %eax
  80039d:	68 ca 22 80 00       	push   $0x8022ca
  8003a2:	53                   	push   %ebx
  8003a3:	56                   	push   %esi
  8003a4:	e8 9b fe ff ff       	call   800244 <printfmt>
  8003a9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003ac:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003af:	e9 82 02 00 00       	jmp    800636 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  8003b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b7:	83 c0 04             	add    $0x4,%eax
  8003ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  8003c2:	85 ff                	test   %edi,%edi
  8003c4:	b8 c3 22 80 00       	mov    $0x8022c3,%eax
  8003c9:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  8003cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d0:	0f 8e bd 00 00 00    	jle    800493 <vprintfmt+0x232>
  8003d6:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003da:	75 0e                	jne    8003ea <vprintfmt+0x189>
  8003dc:	89 75 08             	mov    %esi,0x8(%ebp)
  8003df:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8003e2:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8003e5:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003e8:	eb 6d                	jmp    800457 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 d0             	pushl  -0x30(%ebp)
  8003f0:	57                   	push   %edi
  8003f1:	e8 6e 03 00 00       	call   800764 <strnlen>
  8003f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003f9:	29 c1                	sub    %eax,%ecx
  8003fb:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003fe:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800401:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800405:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800408:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80040b:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80040d:	eb 0f                	jmp    80041e <vprintfmt+0x1bd>
					putch(padc, putdat);
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	53                   	push   %ebx
  800413:	ff 75 e0             	pushl  -0x20(%ebp)
  800416:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800418:	83 ef 01             	sub    $0x1,%edi
  80041b:	83 c4 10             	add    $0x10,%esp
  80041e:	85 ff                	test   %edi,%edi
  800420:	7f ed                	jg     80040f <vprintfmt+0x1ae>
  800422:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800425:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800428:	85 c9                	test   %ecx,%ecx
  80042a:	b8 00 00 00 00       	mov    $0x0,%eax
  80042f:	0f 49 c1             	cmovns %ecx,%eax
  800432:	29 c1                	sub    %eax,%ecx
  800434:	89 75 08             	mov    %esi,0x8(%ebp)
  800437:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80043a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80043d:	89 cb                	mov    %ecx,%ebx
  80043f:	eb 16                	jmp    800457 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  800441:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800445:	75 31                	jne    800478 <vprintfmt+0x217>
					putch(ch, putdat);
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	ff 55 08             	call   *0x8(%ebp)
  800451:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800454:	83 eb 01             	sub    $0x1,%ebx
  800457:	83 c7 01             	add    $0x1,%edi
  80045a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  80045e:	0f be c2             	movsbl %dl,%eax
  800461:	85 c0                	test   %eax,%eax
  800463:	74 59                	je     8004be <vprintfmt+0x25d>
  800465:	85 f6                	test   %esi,%esi
  800467:	78 d8                	js     800441 <vprintfmt+0x1e0>
  800469:	83 ee 01             	sub    $0x1,%esi
  80046c:	79 d3                	jns    800441 <vprintfmt+0x1e0>
  80046e:	89 df                	mov    %ebx,%edi
  800470:	8b 75 08             	mov    0x8(%ebp),%esi
  800473:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800476:	eb 37                	jmp    8004af <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800478:	0f be d2             	movsbl %dl,%edx
  80047b:	83 ea 20             	sub    $0x20,%edx
  80047e:	83 fa 5e             	cmp    $0x5e,%edx
  800481:	76 c4                	jbe    800447 <vprintfmt+0x1e6>
					putch('?', putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	6a 3f                	push   $0x3f
  80048b:	ff 55 08             	call   *0x8(%ebp)
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	eb c1                	jmp    800454 <vprintfmt+0x1f3>
  800493:	89 75 08             	mov    %esi,0x8(%ebp)
  800496:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800499:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80049c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80049f:	eb b6                	jmp    800457 <vprintfmt+0x1f6>
				putch(' ', putdat);
  8004a1:	83 ec 08             	sub    $0x8,%esp
  8004a4:	53                   	push   %ebx
  8004a5:	6a 20                	push   $0x20
  8004a7:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004a9:	83 ef 01             	sub    $0x1,%edi
  8004ac:	83 c4 10             	add    $0x10,%esp
  8004af:	85 ff                	test   %edi,%edi
  8004b1:	7f ee                	jg     8004a1 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b9:	e9 78 01 00 00       	jmp    800636 <vprintfmt+0x3d5>
  8004be:	89 df                	mov    %ebx,%edi
  8004c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8004c6:	eb e7                	jmp    8004af <vprintfmt+0x24e>
	if (lflag >= 2)
  8004c8:	83 f9 01             	cmp    $0x1,%ecx
  8004cb:	7e 3f                	jle    80050c <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  8004cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d0:	8b 50 04             	mov    0x4(%eax),%edx
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 40 08             	lea    0x8(%eax),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  8004e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e8:	79 5c                	jns    800546 <vprintfmt+0x2e5>
				putch('-', putdat);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	53                   	push   %ebx
  8004ee:	6a 2d                	push   $0x2d
  8004f0:	ff d6                	call   *%esi
				num = -(long long) num;
  8004f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004f8:	f7 da                	neg    %edx
  8004fa:	83 d1 00             	adc    $0x0,%ecx
  8004fd:	f7 d9                	neg    %ecx
  8004ff:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800502:	b8 0a 00 00 00       	mov    $0xa,%eax
  800507:	e9 10 01 00 00       	jmp    80061c <vprintfmt+0x3bb>
	else if (lflag)
  80050c:	85 c9                	test   %ecx,%ecx
  80050e:	75 1b                	jne    80052b <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  800510:	8b 45 14             	mov    0x14(%ebp),%eax
  800513:	8b 00                	mov    (%eax),%eax
  800515:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800518:	89 c1                	mov    %eax,%ecx
  80051a:	c1 f9 1f             	sar    $0x1f,%ecx
  80051d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8d 40 04             	lea    0x4(%eax),%eax
  800526:	89 45 14             	mov    %eax,0x14(%ebp)
  800529:	eb b9                	jmp    8004e4 <vprintfmt+0x283>
		return va_arg(*ap, long);
  80052b:	8b 45 14             	mov    0x14(%ebp),%eax
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800533:	89 c1                	mov    %eax,%ecx
  800535:	c1 f9 1f             	sar    $0x1f,%ecx
  800538:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 40 04             	lea    0x4(%eax),%eax
  800541:	89 45 14             	mov    %eax,0x14(%ebp)
  800544:	eb 9e                	jmp    8004e4 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  800546:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800551:	e9 c6 00 00 00       	jmp    80061c <vprintfmt+0x3bb>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7e 18                	jle    800573 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	8b 48 04             	mov    0x4(%eax),%ecx
  800563:	8d 40 08             	lea    0x8(%eax),%eax
  800566:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800569:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056e:	e9 a9 00 00 00       	jmp    80061c <vprintfmt+0x3bb>
	else if (lflag)
  800573:	85 c9                	test   %ecx,%ecx
  800575:	75 1a                	jne    800591 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	8b 10                	mov    (%eax),%edx
  80057c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800581:	8d 40 04             	lea    0x4(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058c:	e9 8b 00 00 00       	jmp    80061c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a6:	eb 74                	jmp    80061c <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7e 15                	jle    8005c2 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b5:	8d 40 08             	lea    0x8(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c0:	eb 5a                	jmp    80061c <vprintfmt+0x3bb>
	else if (lflag)
  8005c2:	85 c9                	test   %ecx,%ecx
  8005c4:	75 17                	jne    8005dd <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8005db:	eb 3f                	jmp    80061c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f2:	eb 28                	jmp    80061c <vprintfmt+0x3bb>
			putch('0', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 30                	push   $0x30
  8005fa:	ff d6                	call   *%esi
			putch('x', putdat);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 78                	push   $0x78
  800602:	ff d6                	call   *%esi
			num = (unsigned long long)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800617:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800623:	57                   	push   %edi
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	50                   	push   %eax
  800628:	51                   	push   %ecx
  800629:	52                   	push   %edx
  80062a:	89 da                	mov    %ebx,%edx
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	e8 45 fb ff ff       	call   800178 <printnum>
			break;
  800633:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	83 c7 01             	add    $0x1,%edi
  80063c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800640:	83 f8 25             	cmp    $0x25,%eax
  800643:	0f 84 2f fc ff ff    	je     800278 <vprintfmt+0x17>
			if (ch == '\0')
  800649:	85 c0                	test   %eax,%eax
  80064b:	0f 84 8b 00 00 00    	je     8006dc <vprintfmt+0x47b>
			putch(ch, putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	53                   	push   %ebx
  800655:	50                   	push   %eax
  800656:	ff d6                	call   *%esi
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	eb dc                	jmp    800639 <vprintfmt+0x3d8>
	if (lflag >= 2)
  80065d:	83 f9 01             	cmp    $0x1,%ecx
  800660:	7e 15                	jle    800677 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 10                	mov    (%eax),%edx
  800667:	8b 48 04             	mov    0x4(%eax),%ecx
  80066a:	8d 40 08             	lea    0x8(%eax),%eax
  80066d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800670:	b8 10 00 00 00       	mov    $0x10,%eax
  800675:	eb a5                	jmp    80061c <vprintfmt+0x3bb>
	else if (lflag)
  800677:	85 c9                	test   %ecx,%ecx
  800679:	75 17                	jne    800692 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	b9 00 00 00 00       	mov    $0x0,%ecx
  800685:	8d 40 04             	lea    0x4(%eax),%eax
  800688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80068b:	b8 10 00 00 00       	mov    $0x10,%eax
  800690:	eb 8a                	jmp    80061c <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8b 10                	mov    (%eax),%edx
  800697:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069c:	8d 40 04             	lea    0x4(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a2:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a7:	e9 70 ff ff ff       	jmp    80061c <vprintfmt+0x3bb>
			putch(ch, putdat);
  8006ac:	83 ec 08             	sub    $0x8,%esp
  8006af:	53                   	push   %ebx
  8006b0:	6a 25                	push   $0x25
  8006b2:	ff d6                	call   *%esi
			break;
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	e9 7a ff ff ff       	jmp    800636 <vprintfmt+0x3d5>
			putch('%', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 25                	push   $0x25
  8006c2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	89 f8                	mov    %edi,%eax
  8006c9:	eb 03                	jmp    8006ce <vprintfmt+0x46d>
  8006cb:	83 e8 01             	sub    $0x1,%eax
  8006ce:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006d2:	75 f7                	jne    8006cb <vprintfmt+0x46a>
  8006d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d7:	e9 5a ff ff ff       	jmp    800636 <vprintfmt+0x3d5>
}
  8006dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006df:	5b                   	pop    %ebx
  8006e0:	5e                   	pop    %esi
  8006e1:	5f                   	pop    %edi
  8006e2:	5d                   	pop    %ebp
  8006e3:	c3                   	ret    

008006e4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	83 ec 18             	sub    $0x18,%esp
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006f3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800701:	85 c0                	test   %eax,%eax
  800703:	74 26                	je     80072b <vsnprintf+0x47>
  800705:	85 d2                	test   %edx,%edx
  800707:	7e 22                	jle    80072b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800709:	ff 75 14             	pushl  0x14(%ebp)
  80070c:	ff 75 10             	pushl  0x10(%ebp)
  80070f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800712:	50                   	push   %eax
  800713:	68 27 02 80 00       	push   $0x800227
  800718:	e8 44 fb ff ff       	call   800261 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80071d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800720:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800726:	83 c4 10             	add    $0x10,%esp
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    
		return -E_INVAL;
  80072b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800730:	eb f7                	jmp    800729 <vsnprintf+0x45>

00800732 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800738:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80073b:	50                   	push   %eax
  80073c:	ff 75 10             	pushl  0x10(%ebp)
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	ff 75 08             	pushl  0x8(%ebp)
  800745:	e8 9a ff ff ff       	call   8006e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800752:	b8 00 00 00 00       	mov    $0x0,%eax
  800757:	eb 03                	jmp    80075c <strlen+0x10>
		n++;
  800759:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  80075c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800760:	75 f7                	jne    800759 <strlen+0xd>
	return n;
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076d:	b8 00 00 00 00       	mov    $0x0,%eax
  800772:	eb 03                	jmp    800777 <strnlen+0x13>
		n++;
  800774:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800777:	39 d0                	cmp    %edx,%eax
  800779:	74 06                	je     800781 <strnlen+0x1d>
  80077b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80077f:	75 f3                	jne    800774 <strnlen+0x10>
	return n;
}
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	53                   	push   %ebx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80078d:	89 c2                	mov    %eax,%edx
  80078f:	83 c1 01             	add    $0x1,%ecx
  800792:	83 c2 01             	add    $0x1,%edx
  800795:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800799:	88 5a ff             	mov    %bl,-0x1(%edx)
  80079c:	84 db                	test   %bl,%bl
  80079e:	75 ef                	jne    80078f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007a0:	5b                   	pop    %ebx
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	53                   	push   %ebx
  8007a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007aa:	53                   	push   %ebx
  8007ab:	e8 9c ff ff ff       	call   80074c <strlen>
  8007b0:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	01 d8                	add    %ebx,%eax
  8007b8:	50                   	push   %eax
  8007b9:	e8 c5 ff ff ff       	call   800783 <strcpy>
	return dst;
}
  8007be:	89 d8                	mov    %ebx,%eax
  8007c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c3:	c9                   	leave  
  8007c4:	c3                   	ret    

008007c5 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	56                   	push   %esi
  8007c9:	53                   	push   %ebx
  8007ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d0:	89 f3                	mov    %esi,%ebx
  8007d2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d5:	89 f2                	mov    %esi,%edx
  8007d7:	eb 0f                	jmp    8007e8 <strncpy+0x23>
		*dst++ = *src;
  8007d9:	83 c2 01             	add    $0x1,%edx
  8007dc:	0f b6 01             	movzbl (%ecx),%eax
  8007df:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007e2:	80 39 01             	cmpb   $0x1,(%ecx)
  8007e5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007e8:	39 da                	cmp    %ebx,%edx
  8007ea:	75 ed                	jne    8007d9 <strncpy+0x14>
	}
	return ret;
}
  8007ec:	89 f0                	mov    %esi,%eax
  8007ee:	5b                   	pop    %ebx
  8007ef:	5e                   	pop    %esi
  8007f0:	5d                   	pop    %ebp
  8007f1:	c3                   	ret    

008007f2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	56                   	push   %esi
  8007f6:	53                   	push   %ebx
  8007f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800800:	89 f0                	mov    %esi,%eax
  800802:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800806:	85 c9                	test   %ecx,%ecx
  800808:	75 0b                	jne    800815 <strlcpy+0x23>
  80080a:	eb 17                	jmp    800823 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80080c:	83 c2 01             	add    $0x1,%edx
  80080f:	83 c0 01             	add    $0x1,%eax
  800812:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800815:	39 d8                	cmp    %ebx,%eax
  800817:	74 07                	je     800820 <strlcpy+0x2e>
  800819:	0f b6 0a             	movzbl (%edx),%ecx
  80081c:	84 c9                	test   %cl,%cl
  80081e:	75 ec                	jne    80080c <strlcpy+0x1a>
		*dst = '\0';
  800820:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800823:	29 f0                	sub    %esi,%eax
}
  800825:	5b                   	pop    %ebx
  800826:	5e                   	pop    %esi
  800827:	5d                   	pop    %ebp
  800828:	c3                   	ret    

00800829 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800829:	55                   	push   %ebp
  80082a:	89 e5                	mov    %esp,%ebp
  80082c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80082f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800832:	eb 06                	jmp    80083a <strcmp+0x11>
		p++, q++;
  800834:	83 c1 01             	add    $0x1,%ecx
  800837:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  80083a:	0f b6 01             	movzbl (%ecx),%eax
  80083d:	84 c0                	test   %al,%al
  80083f:	74 04                	je     800845 <strcmp+0x1c>
  800841:	3a 02                	cmp    (%edx),%al
  800843:	74 ef                	je     800834 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800845:	0f b6 c0             	movzbl %al,%eax
  800848:	0f b6 12             	movzbl (%edx),%edx
  80084b:	29 d0                	sub    %edx,%eax
}
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	53                   	push   %ebx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	8b 55 0c             	mov    0xc(%ebp),%edx
  800859:	89 c3                	mov    %eax,%ebx
  80085b:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80085e:	eb 06                	jmp    800866 <strncmp+0x17>
		n--, p++, q++;
  800860:	83 c0 01             	add    $0x1,%eax
  800863:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800866:	39 d8                	cmp    %ebx,%eax
  800868:	74 16                	je     800880 <strncmp+0x31>
  80086a:	0f b6 08             	movzbl (%eax),%ecx
  80086d:	84 c9                	test   %cl,%cl
  80086f:	74 04                	je     800875 <strncmp+0x26>
  800871:	3a 0a                	cmp    (%edx),%cl
  800873:	74 eb                	je     800860 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800875:	0f b6 00             	movzbl (%eax),%eax
  800878:	0f b6 12             	movzbl (%edx),%edx
  80087b:	29 d0                	sub    %edx,%eax
}
  80087d:	5b                   	pop    %ebx
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    
		return 0;
  800880:	b8 00 00 00 00       	mov    $0x0,%eax
  800885:	eb f6                	jmp    80087d <strncmp+0x2e>

00800887 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	8b 45 08             	mov    0x8(%ebp),%eax
  80088d:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800891:	0f b6 10             	movzbl (%eax),%edx
  800894:	84 d2                	test   %dl,%dl
  800896:	74 09                	je     8008a1 <strchr+0x1a>
		if (*s == c)
  800898:	38 ca                	cmp    %cl,%dl
  80089a:	74 0a                	je     8008a6 <strchr+0x1f>
	for (; *s; s++)
  80089c:	83 c0 01             	add    $0x1,%eax
  80089f:	eb f0                	jmp    800891 <strchr+0xa>
			return (char *) s;
	return 0;
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b2:	eb 03                	jmp    8008b7 <strfind+0xf>
  8008b4:	83 c0 01             	add    $0x1,%eax
  8008b7:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008ba:	38 ca                	cmp    %cl,%dl
  8008bc:	74 04                	je     8008c2 <strfind+0x1a>
  8008be:	84 d2                	test   %dl,%dl
  8008c0:	75 f2                	jne    8008b4 <strfind+0xc>
			break;
	return (char *) s;
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	57                   	push   %edi
  8008c8:	56                   	push   %esi
  8008c9:	53                   	push   %ebx
  8008ca:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008d0:	85 c9                	test   %ecx,%ecx
  8008d2:	74 13                	je     8008e7 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008d4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008da:	75 05                	jne    8008e1 <memset+0x1d>
  8008dc:	f6 c1 03             	test   $0x3,%cl
  8008df:	74 0d                	je     8008ee <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	fc                   	cld    
  8008e5:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008e7:	89 f8                	mov    %edi,%eax
  8008e9:	5b                   	pop    %ebx
  8008ea:	5e                   	pop    %esi
  8008eb:	5f                   	pop    %edi
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    
		c &= 0xFF;
  8008ee:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f2:	89 d3                	mov    %edx,%ebx
  8008f4:	c1 e3 08             	shl    $0x8,%ebx
  8008f7:	89 d0                	mov    %edx,%eax
  8008f9:	c1 e0 18             	shl    $0x18,%eax
  8008fc:	89 d6                	mov    %edx,%esi
  8008fe:	c1 e6 10             	shl    $0x10,%esi
  800901:	09 f0                	or     %esi,%eax
  800903:	09 c2                	or     %eax,%edx
  800905:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800907:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80090a:	89 d0                	mov    %edx,%eax
  80090c:	fc                   	cld    
  80090d:	f3 ab                	rep stos %eax,%es:(%edi)
  80090f:	eb d6                	jmp    8008e7 <memset+0x23>

00800911 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	57                   	push   %edi
  800915:	56                   	push   %esi
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 75 0c             	mov    0xc(%ebp),%esi
  80091c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80091f:	39 c6                	cmp    %eax,%esi
  800921:	73 35                	jae    800958 <memmove+0x47>
  800923:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800926:	39 c2                	cmp    %eax,%edx
  800928:	76 2e                	jbe    800958 <memmove+0x47>
		s += n;
		d += n;
  80092a:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80092d:	89 d6                	mov    %edx,%esi
  80092f:	09 fe                	or     %edi,%esi
  800931:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800937:	74 0c                	je     800945 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800939:	83 ef 01             	sub    $0x1,%edi
  80093c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80093f:	fd                   	std    
  800940:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800942:	fc                   	cld    
  800943:	eb 21                	jmp    800966 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800945:	f6 c1 03             	test   $0x3,%cl
  800948:	75 ef                	jne    800939 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80094a:	83 ef 04             	sub    $0x4,%edi
  80094d:	8d 72 fc             	lea    -0x4(%edx),%esi
  800950:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800953:	fd                   	std    
  800954:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800956:	eb ea                	jmp    800942 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800958:	89 f2                	mov    %esi,%edx
  80095a:	09 c2                	or     %eax,%edx
  80095c:	f6 c2 03             	test   $0x3,%dl
  80095f:	74 09                	je     80096a <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800961:	89 c7                	mov    %eax,%edi
  800963:	fc                   	cld    
  800964:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800966:	5e                   	pop    %esi
  800967:	5f                   	pop    %edi
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096a:	f6 c1 03             	test   $0x3,%cl
  80096d:	75 f2                	jne    800961 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80096f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800972:	89 c7                	mov    %eax,%edi
  800974:	fc                   	cld    
  800975:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800977:	eb ed                	jmp    800966 <memmove+0x55>

00800979 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80097c:	ff 75 10             	pushl  0x10(%ebp)
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	e8 87 ff ff ff       	call   800911 <memmove>
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8b 55 0c             	mov    0xc(%ebp),%edx
  800997:	89 c6                	mov    %eax,%esi
  800999:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80099c:	39 f0                	cmp    %esi,%eax
  80099e:	74 1c                	je     8009bc <memcmp+0x30>
		if (*s1 != *s2)
  8009a0:	0f b6 08             	movzbl (%eax),%ecx
  8009a3:	0f b6 1a             	movzbl (%edx),%ebx
  8009a6:	38 d9                	cmp    %bl,%cl
  8009a8:	75 08                	jne    8009b2 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	83 c2 01             	add    $0x1,%edx
  8009b0:	eb ea                	jmp    80099c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009b2:	0f b6 c1             	movzbl %cl,%eax
  8009b5:	0f b6 db             	movzbl %bl,%ebx
  8009b8:	29 d8                	sub    %ebx,%eax
  8009ba:	eb 05                	jmp    8009c1 <memcmp+0x35>
	}

	return 0;
  8009bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ce:	89 c2                	mov    %eax,%edx
  8009d0:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009d3:	39 d0                	cmp    %edx,%eax
  8009d5:	73 09                	jae    8009e0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009d7:	38 08                	cmp    %cl,(%eax)
  8009d9:	74 05                	je     8009e0 <memfind+0x1b>
	for (; s < ends; s++)
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	eb f3                	jmp    8009d3 <memfind+0xe>
			break;
	return (void *) s;
}
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	57                   	push   %edi
  8009e6:	56                   	push   %esi
  8009e7:	53                   	push   %ebx
  8009e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ee:	eb 03                	jmp    8009f3 <strtol+0x11>
		s++;
  8009f0:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	3c 20                	cmp    $0x20,%al
  8009f8:	74 f6                	je     8009f0 <strtol+0xe>
  8009fa:	3c 09                	cmp    $0x9,%al
  8009fc:	74 f2                	je     8009f0 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  8009fe:	3c 2b                	cmp    $0x2b,%al
  800a00:	74 2e                	je     800a30 <strtol+0x4e>
	int neg = 0;
  800a02:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a07:	3c 2d                	cmp    $0x2d,%al
  800a09:	74 2f                	je     800a3a <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a0b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a11:	75 05                	jne    800a18 <strtol+0x36>
  800a13:	80 39 30             	cmpb   $0x30,(%ecx)
  800a16:	74 2c                	je     800a44 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a18:	85 db                	test   %ebx,%ebx
  800a1a:	75 0a                	jne    800a26 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a1c:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800a21:	80 39 30             	cmpb   $0x30,(%ecx)
  800a24:	74 28                	je     800a4e <strtol+0x6c>
		base = 10;
  800a26:	b8 00 00 00 00       	mov    $0x0,%eax
  800a2b:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a2e:	eb 50                	jmp    800a80 <strtol+0x9e>
		s++;
  800a30:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800a33:	bf 00 00 00 00       	mov    $0x0,%edi
  800a38:	eb d1                	jmp    800a0b <strtol+0x29>
		s++, neg = 1;
  800a3a:	83 c1 01             	add    $0x1,%ecx
  800a3d:	bf 01 00 00 00       	mov    $0x1,%edi
  800a42:	eb c7                	jmp    800a0b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a44:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a48:	74 0e                	je     800a58 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800a4a:	85 db                	test   %ebx,%ebx
  800a4c:	75 d8                	jne    800a26 <strtol+0x44>
		s++, base = 8;
  800a4e:	83 c1 01             	add    $0x1,%ecx
  800a51:	bb 08 00 00 00       	mov    $0x8,%ebx
  800a56:	eb ce                	jmp    800a26 <strtol+0x44>
		s += 2, base = 16;
  800a58:	83 c1 02             	add    $0x2,%ecx
  800a5b:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a60:	eb c4                	jmp    800a26 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a62:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a65:	89 f3                	mov    %esi,%ebx
  800a67:	80 fb 19             	cmp    $0x19,%bl
  800a6a:	77 29                	ja     800a95 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800a6c:	0f be d2             	movsbl %dl,%edx
  800a6f:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a72:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a75:	7d 30                	jge    800aa7 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800a77:	83 c1 01             	add    $0x1,%ecx
  800a7a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a7e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a80:	0f b6 11             	movzbl (%ecx),%edx
  800a83:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a86:	89 f3                	mov    %esi,%ebx
  800a88:	80 fb 09             	cmp    $0x9,%bl
  800a8b:	77 d5                	ja     800a62 <strtol+0x80>
			dig = *s - '0';
  800a8d:	0f be d2             	movsbl %dl,%edx
  800a90:	83 ea 30             	sub    $0x30,%edx
  800a93:	eb dd                	jmp    800a72 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800a95:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a98:	89 f3                	mov    %esi,%ebx
  800a9a:	80 fb 19             	cmp    $0x19,%bl
  800a9d:	77 08                	ja     800aa7 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800a9f:	0f be d2             	movsbl %dl,%edx
  800aa2:	83 ea 37             	sub    $0x37,%edx
  800aa5:	eb cb                	jmp    800a72 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aa7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aab:	74 05                	je     800ab2 <strtol+0xd0>
		*endptr = (char *) s;
  800aad:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ab2:	89 c2                	mov    %eax,%edx
  800ab4:	f7 da                	neg    %edx
  800ab6:	85 ff                	test   %edi,%edi
  800ab8:	0f 45 c2             	cmovne %edx,%eax
}
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5f                   	pop    %edi
  800abe:	5d                   	pop    %ebp
  800abf:	c3                   	ret    

00800ac0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ace:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad1:	89 c3                	mov    %eax,%ebx
  800ad3:	89 c7                	mov    %eax,%edi
  800ad5:	89 c6                	mov    %eax,%esi
  800ad7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ad9:	5b                   	pop    %ebx
  800ada:	5e                   	pop    %esi
  800adb:	5f                   	pop    %edi
  800adc:	5d                   	pop    %ebp
  800add:	c3                   	ret    

00800ade <sys_cgetc>:

int
sys_cgetc(void)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	57                   	push   %edi
  800ae2:	56                   	push   %esi
  800ae3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ae4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae9:	b8 01 00 00 00       	mov    $0x1,%eax
  800aee:	89 d1                	mov    %edx,%ecx
  800af0:	89 d3                	mov    %edx,%ebx
  800af2:	89 d7                	mov    %edx,%edi
  800af4:	89 d6                	mov    %edx,%esi
  800af6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5f                   	pop    %edi
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	57                   	push   %edi
  800b01:	56                   	push   %esi
  800b02:	53                   	push   %ebx
  800b03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b06:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b13:	89 cb                	mov    %ecx,%ebx
  800b15:	89 cf                	mov    %ecx,%edi
  800b17:	89 ce                	mov    %ecx,%esi
  800b19:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b1b:	85 c0                	test   %eax,%eax
  800b1d:	7f 08                	jg     800b27 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b27:	83 ec 0c             	sub    $0xc,%esp
  800b2a:	50                   	push   %eax
  800b2b:	6a 03                	push   $0x3
  800b2d:	68 bf 25 80 00       	push   $0x8025bf
  800b32:	6a 23                	push   $0x23
  800b34:	68 dc 25 80 00       	push   $0x8025dc
  800b39:	e8 6e 13 00 00       	call   801eac <_panic>

00800b3e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	57                   	push   %edi
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	b8 02 00 00 00       	mov    $0x2,%eax
  800b4e:	89 d1                	mov    %edx,%ecx
  800b50:	89 d3                	mov    %edx,%ebx
  800b52:	89 d7                	mov    %edx,%edi
  800b54:	89 d6                	mov    %edx,%esi
  800b56:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5f                   	pop    %edi
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <sys_yield>:

void
sys_yield(void)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	57                   	push   %edi
  800b61:	56                   	push   %esi
  800b62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b6d:	89 d1                	mov    %edx,%ecx
  800b6f:	89 d3                	mov    %edx,%ebx
  800b71:	89 d7                	mov    %edx,%edi
  800b73:	89 d6                	mov    %edx,%esi
  800b75:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b85:	be 00 00 00 00       	mov    $0x0,%esi
  800b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b90:	b8 04 00 00 00       	mov    $0x4,%eax
  800b95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b98:	89 f7                	mov    %esi,%edi
  800b9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b9c:	85 c0                	test   %eax,%eax
  800b9e:	7f 08                	jg     800ba8 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba3:	5b                   	pop    %ebx
  800ba4:	5e                   	pop    %esi
  800ba5:	5f                   	pop    %edi
  800ba6:	5d                   	pop    %ebp
  800ba7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba8:	83 ec 0c             	sub    $0xc,%esp
  800bab:	50                   	push   %eax
  800bac:	6a 04                	push   $0x4
  800bae:	68 bf 25 80 00       	push   $0x8025bf
  800bb3:	6a 23                	push   $0x23
  800bb5:	68 dc 25 80 00       	push   $0x8025dc
  800bba:	e8 ed 12 00 00       	call   801eac <_panic>

00800bbf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	57                   	push   %edi
  800bc3:	56                   	push   %esi
  800bc4:	53                   	push   %ebx
  800bc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bce:	b8 05 00 00 00       	mov    $0x5,%eax
  800bd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bd9:	8b 75 18             	mov    0x18(%ebp),%esi
  800bdc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bde:	85 c0                	test   %eax,%eax
  800be0:	7f 08                	jg     800bea <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800be2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be5:	5b                   	pop    %ebx
  800be6:	5e                   	pop    %esi
  800be7:	5f                   	pop    %edi
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bea:	83 ec 0c             	sub    $0xc,%esp
  800bed:	50                   	push   %eax
  800bee:	6a 05                	push   $0x5
  800bf0:	68 bf 25 80 00       	push   $0x8025bf
  800bf5:	6a 23                	push   $0x23
  800bf7:	68 dc 25 80 00       	push   $0x8025dc
  800bfc:	e8 ab 12 00 00       	call   801eac <_panic>

00800c01 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	57                   	push   %edi
  800c05:	56                   	push   %esi
  800c06:	53                   	push   %ebx
  800c07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c15:	b8 06 00 00 00       	mov    $0x6,%eax
  800c1a:	89 df                	mov    %ebx,%edi
  800c1c:	89 de                	mov    %ebx,%esi
  800c1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c20:	85 c0                	test   %eax,%eax
  800c22:	7f 08                	jg     800c2c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c27:	5b                   	pop    %ebx
  800c28:	5e                   	pop    %esi
  800c29:	5f                   	pop    %edi
  800c2a:	5d                   	pop    %ebp
  800c2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2c:	83 ec 0c             	sub    $0xc,%esp
  800c2f:	50                   	push   %eax
  800c30:	6a 06                	push   $0x6
  800c32:	68 bf 25 80 00       	push   $0x8025bf
  800c37:	6a 23                	push   $0x23
  800c39:	68 dc 25 80 00       	push   $0x8025dc
  800c3e:	e8 69 12 00 00       	call   801eac <_panic>

00800c43 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c51:	8b 55 08             	mov    0x8(%ebp),%edx
  800c54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c57:	b8 08 00 00 00       	mov    $0x8,%eax
  800c5c:	89 df                	mov    %ebx,%edi
  800c5e:	89 de                	mov    %ebx,%esi
  800c60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c62:	85 c0                	test   %eax,%eax
  800c64:	7f 08                	jg     800c6e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c69:	5b                   	pop    %ebx
  800c6a:	5e                   	pop    %esi
  800c6b:	5f                   	pop    %edi
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6e:	83 ec 0c             	sub    $0xc,%esp
  800c71:	50                   	push   %eax
  800c72:	6a 08                	push   $0x8
  800c74:	68 bf 25 80 00       	push   $0x8025bf
  800c79:	6a 23                	push   $0x23
  800c7b:	68 dc 25 80 00       	push   $0x8025dc
  800c80:	e8 27 12 00 00       	call   801eac <_panic>

00800c85 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	b8 09 00 00 00       	mov    $0x9,%eax
  800c9e:	89 df                	mov    %ebx,%edi
  800ca0:	89 de                	mov    %ebx,%esi
  800ca2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca4:	85 c0                	test   %eax,%eax
  800ca6:	7f 08                	jg     800cb0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5f                   	pop    %edi
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb0:	83 ec 0c             	sub    $0xc,%esp
  800cb3:	50                   	push   %eax
  800cb4:	6a 09                	push   $0x9
  800cb6:	68 bf 25 80 00       	push   $0x8025bf
  800cbb:	6a 23                	push   $0x23
  800cbd:	68 dc 25 80 00       	push   $0x8025dc
  800cc2:	e8 e5 11 00 00       	call   801eac <_panic>

00800cc7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce0:	89 df                	mov    %ebx,%edi
  800ce2:	89 de                	mov    %ebx,%esi
  800ce4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	7f 08                	jg     800cf2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf2:	83 ec 0c             	sub    $0xc,%esp
  800cf5:	50                   	push   %eax
  800cf6:	6a 0a                	push   $0xa
  800cf8:	68 bf 25 80 00       	push   $0x8025bf
  800cfd:	6a 23                	push   $0x23
  800cff:	68 dc 25 80 00       	push   $0x8025dc
  800d04:	e8 a3 11 00 00       	call   801eac <_panic>

00800d09 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d15:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d1a:	be 00 00 00 00       	mov    $0x0,%esi
  800d1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d25:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d27:	5b                   	pop    %ebx
  800d28:	5e                   	pop    %esi
  800d29:	5f                   	pop    %edi
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
  800d32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d42:	89 cb                	mov    %ecx,%ebx
  800d44:	89 cf                	mov    %ecx,%edi
  800d46:	89 ce                	mov    %ecx,%esi
  800d48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4a:	85 c0                	test   %eax,%eax
  800d4c:	7f 08                	jg     800d56 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d51:	5b                   	pop    %ebx
  800d52:	5e                   	pop    %esi
  800d53:	5f                   	pop    %edi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	83 ec 0c             	sub    $0xc,%esp
  800d59:	50                   	push   %eax
  800d5a:	6a 0d                	push   $0xd
  800d5c:	68 bf 25 80 00       	push   $0x8025bf
  800d61:	6a 23                	push   $0x23
  800d63:	68 dc 25 80 00       	push   $0x8025dc
  800d68:	e8 3f 11 00 00       	call   801eac <_panic>

00800d6d <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d73:	ba 00 00 00 00       	mov    $0x0,%edx
  800d78:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d7d:	89 d1                	mov    %edx,%ecx
  800d7f:	89 d3                	mov    %edx,%ebx
  800d81:	89 d7                	mov    %edx,%edi
  800d83:	89 d6                	mov    %edx,%esi
  800d85:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	05 00 00 00 30       	add    $0x30000000,%eax
  800d97:	c1 e8 0c             	shr    $0xc,%eax
}
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800da7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dbe:	89 c2                	mov    %eax,%edx
  800dc0:	c1 ea 16             	shr    $0x16,%edx
  800dc3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800dca:	f6 c2 01             	test   $0x1,%dl
  800dcd:	74 2a                	je     800df9 <fd_alloc+0x46>
  800dcf:	89 c2                	mov    %eax,%edx
  800dd1:	c1 ea 0c             	shr    $0xc,%edx
  800dd4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ddb:	f6 c2 01             	test   $0x1,%dl
  800dde:	74 19                	je     800df9 <fd_alloc+0x46>
  800de0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800de5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800dea:	75 d2                	jne    800dbe <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800dec:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800df2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800df7:	eb 07                	jmp    800e00 <fd_alloc+0x4d>
			*fd_store = fd;
  800df9:	89 01                	mov    %eax,(%ecx)
			return 0;
  800dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e00:	5d                   	pop    %ebp
  800e01:	c3                   	ret    

00800e02 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e08:	83 f8 1f             	cmp    $0x1f,%eax
  800e0b:	77 36                	ja     800e43 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e0d:	c1 e0 0c             	shl    $0xc,%eax
  800e10:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e15:	89 c2                	mov    %eax,%edx
  800e17:	c1 ea 16             	shr    $0x16,%edx
  800e1a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e21:	f6 c2 01             	test   $0x1,%dl
  800e24:	74 24                	je     800e4a <fd_lookup+0x48>
  800e26:	89 c2                	mov    %eax,%edx
  800e28:	c1 ea 0c             	shr    $0xc,%edx
  800e2b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e32:	f6 c2 01             	test   $0x1,%dl
  800e35:	74 1a                	je     800e51 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3a:	89 02                	mov    %eax,(%edx)
	return 0;
  800e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    
		return -E_INVAL;
  800e43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e48:	eb f7                	jmp    800e41 <fd_lookup+0x3f>
		return -E_INVAL;
  800e4a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e4f:	eb f0                	jmp    800e41 <fd_lookup+0x3f>
  800e51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e56:	eb e9                	jmp    800e41 <fd_lookup+0x3f>

00800e58 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e61:	ba 68 26 80 00       	mov    $0x802668,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e66:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e6b:	39 08                	cmp    %ecx,(%eax)
  800e6d:	74 33                	je     800ea2 <dev_lookup+0x4a>
  800e6f:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800e72:	8b 02                	mov    (%edx),%eax
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 f3                	jne    800e6b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800e78:	a1 08 40 80 00       	mov    0x804008,%eax
  800e7d:	8b 40 48             	mov    0x48(%eax),%eax
  800e80:	83 ec 04             	sub    $0x4,%esp
  800e83:	51                   	push   %ecx
  800e84:	50                   	push   %eax
  800e85:	68 ec 25 80 00       	push   $0x8025ec
  800e8a:	e8 d5 f2 ff ff       	call   800164 <cprintf>
	*dev = 0;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    
			*dev = devtab[i];
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb f2                	jmp    800ea0 <dev_lookup+0x48>

00800eae <fd_close>:
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	57                   	push   %edi
  800eb2:	56                   	push   %esi
  800eb3:	53                   	push   %ebx
  800eb4:	83 ec 1c             	sub    $0x1c,%esp
  800eb7:	8b 75 08             	mov    0x8(%ebp),%esi
  800eba:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ebd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ec0:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ec1:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ec7:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eca:	50                   	push   %eax
  800ecb:	e8 32 ff ff ff       	call   800e02 <fd_lookup>
  800ed0:	89 c3                	mov    %eax,%ebx
  800ed2:	83 c4 08             	add    $0x8,%esp
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	78 05                	js     800ede <fd_close+0x30>
	    || fd != fd2)
  800ed9:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800edc:	74 16                	je     800ef4 <fd_close+0x46>
		return (must_exist ? r : 0);
  800ede:	89 f8                	mov    %edi,%eax
  800ee0:	84 c0                	test   %al,%al
  800ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee7:	0f 44 d8             	cmove  %eax,%ebx
}
  800eea:	89 d8                	mov    %ebx,%eax
  800eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800efa:	50                   	push   %eax
  800efb:	ff 36                	pushl  (%esi)
  800efd:	e8 56 ff ff ff       	call   800e58 <dev_lookup>
  800f02:	89 c3                	mov    %eax,%ebx
  800f04:	83 c4 10             	add    $0x10,%esp
  800f07:	85 c0                	test   %eax,%eax
  800f09:	78 15                	js     800f20 <fd_close+0x72>
		if (dev->dev_close)
  800f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f0e:	8b 40 10             	mov    0x10(%eax),%eax
  800f11:	85 c0                	test   %eax,%eax
  800f13:	74 1b                	je     800f30 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	56                   	push   %esi
  800f19:	ff d0                	call   *%eax
  800f1b:	89 c3                	mov    %eax,%ebx
  800f1d:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	56                   	push   %esi
  800f24:	6a 00                	push   $0x0
  800f26:	e8 d6 fc ff ff       	call   800c01 <sys_page_unmap>
	return r;
  800f2b:	83 c4 10             	add    $0x10,%esp
  800f2e:	eb ba                	jmp    800eea <fd_close+0x3c>
			r = 0;
  800f30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f35:	eb e9                	jmp    800f20 <fd_close+0x72>

00800f37 <close>:

int
close(int fdnum)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f3d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f40:	50                   	push   %eax
  800f41:	ff 75 08             	pushl  0x8(%ebp)
  800f44:	e8 b9 fe ff ff       	call   800e02 <fd_lookup>
  800f49:	83 c4 08             	add    $0x8,%esp
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	78 10                	js     800f60 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f50:	83 ec 08             	sub    $0x8,%esp
  800f53:	6a 01                	push   $0x1
  800f55:	ff 75 f4             	pushl  -0xc(%ebp)
  800f58:	e8 51 ff ff ff       	call   800eae <fd_close>
  800f5d:	83 c4 10             	add    $0x10,%esp
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <close_all>:

void
close_all(void)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	53                   	push   %ebx
  800f66:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f69:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f6e:	83 ec 0c             	sub    $0xc,%esp
  800f71:	53                   	push   %ebx
  800f72:	e8 c0 ff ff ff       	call   800f37 <close>
	for (i = 0; i < MAXFD; i++)
  800f77:	83 c3 01             	add    $0x1,%ebx
  800f7a:	83 c4 10             	add    $0x10,%esp
  800f7d:	83 fb 20             	cmp    $0x20,%ebx
  800f80:	75 ec                	jne    800f6e <close_all+0xc>
}
  800f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f90:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f93:	50                   	push   %eax
  800f94:	ff 75 08             	pushl  0x8(%ebp)
  800f97:	e8 66 fe ff ff       	call   800e02 <fd_lookup>
  800f9c:	89 c3                	mov    %eax,%ebx
  800f9e:	83 c4 08             	add    $0x8,%esp
  800fa1:	85 c0                	test   %eax,%eax
  800fa3:	0f 88 81 00 00 00    	js     80102a <dup+0xa3>
		return r;
	close(newfdnum);
  800fa9:	83 ec 0c             	sub    $0xc,%esp
  800fac:	ff 75 0c             	pushl  0xc(%ebp)
  800faf:	e8 83 ff ff ff       	call   800f37 <close>

	newfd = INDEX2FD(newfdnum);
  800fb4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fb7:	c1 e6 0c             	shl    $0xc,%esi
  800fba:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fc0:	83 c4 04             	add    $0x4,%esp
  800fc3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fc6:	e8 d1 fd ff ff       	call   800d9c <fd2data>
  800fcb:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800fcd:	89 34 24             	mov    %esi,(%esp)
  800fd0:	e8 c7 fd ff ff       	call   800d9c <fd2data>
  800fd5:	83 c4 10             	add    $0x10,%esp
  800fd8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800fda:	89 d8                	mov    %ebx,%eax
  800fdc:	c1 e8 16             	shr    $0x16,%eax
  800fdf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fe6:	a8 01                	test   $0x1,%al
  800fe8:	74 11                	je     800ffb <dup+0x74>
  800fea:	89 d8                	mov    %ebx,%eax
  800fec:	c1 e8 0c             	shr    $0xc,%eax
  800fef:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800ff6:	f6 c2 01             	test   $0x1,%dl
  800ff9:	75 39                	jne    801034 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ffb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ffe:	89 d0                	mov    %edx,%eax
  801000:	c1 e8 0c             	shr    $0xc,%eax
  801003:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80100a:	83 ec 0c             	sub    $0xc,%esp
  80100d:	25 07 0e 00 00       	and    $0xe07,%eax
  801012:	50                   	push   %eax
  801013:	56                   	push   %esi
  801014:	6a 00                	push   $0x0
  801016:	52                   	push   %edx
  801017:	6a 00                	push   $0x0
  801019:	e8 a1 fb ff ff       	call   800bbf <sys_page_map>
  80101e:	89 c3                	mov    %eax,%ebx
  801020:	83 c4 20             	add    $0x20,%esp
  801023:	85 c0                	test   %eax,%eax
  801025:	78 31                	js     801058 <dup+0xd1>
		goto err;

	return newfdnum;
  801027:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80102a:	89 d8                	mov    %ebx,%eax
  80102c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801034:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80103b:	83 ec 0c             	sub    $0xc,%esp
  80103e:	25 07 0e 00 00       	and    $0xe07,%eax
  801043:	50                   	push   %eax
  801044:	57                   	push   %edi
  801045:	6a 00                	push   $0x0
  801047:	53                   	push   %ebx
  801048:	6a 00                	push   $0x0
  80104a:	e8 70 fb ff ff       	call   800bbf <sys_page_map>
  80104f:	89 c3                	mov    %eax,%ebx
  801051:	83 c4 20             	add    $0x20,%esp
  801054:	85 c0                	test   %eax,%eax
  801056:	79 a3                	jns    800ffb <dup+0x74>
	sys_page_unmap(0, newfd);
  801058:	83 ec 08             	sub    $0x8,%esp
  80105b:	56                   	push   %esi
  80105c:	6a 00                	push   $0x0
  80105e:	e8 9e fb ff ff       	call   800c01 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801063:	83 c4 08             	add    $0x8,%esp
  801066:	57                   	push   %edi
  801067:	6a 00                	push   $0x0
  801069:	e8 93 fb ff ff       	call   800c01 <sys_page_unmap>
	return r;
  80106e:	83 c4 10             	add    $0x10,%esp
  801071:	eb b7                	jmp    80102a <dup+0xa3>

00801073 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	53                   	push   %ebx
  801077:	83 ec 14             	sub    $0x14,%esp
  80107a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80107d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801080:	50                   	push   %eax
  801081:	53                   	push   %ebx
  801082:	e8 7b fd ff ff       	call   800e02 <fd_lookup>
  801087:	83 c4 08             	add    $0x8,%esp
  80108a:	85 c0                	test   %eax,%eax
  80108c:	78 3f                	js     8010cd <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80108e:	83 ec 08             	sub    $0x8,%esp
  801091:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801094:	50                   	push   %eax
  801095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801098:	ff 30                	pushl  (%eax)
  80109a:	e8 b9 fd ff ff       	call   800e58 <dev_lookup>
  80109f:	83 c4 10             	add    $0x10,%esp
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	78 27                	js     8010cd <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010a9:	8b 42 08             	mov    0x8(%edx),%eax
  8010ac:	83 e0 03             	and    $0x3,%eax
  8010af:	83 f8 01             	cmp    $0x1,%eax
  8010b2:	74 1e                	je     8010d2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b7:	8b 40 08             	mov    0x8(%eax),%eax
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	74 35                	je     8010f3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010be:	83 ec 04             	sub    $0x4,%esp
  8010c1:	ff 75 10             	pushl  0x10(%ebp)
  8010c4:	ff 75 0c             	pushl  0xc(%ebp)
  8010c7:	52                   	push   %edx
  8010c8:	ff d0                	call   *%eax
  8010ca:	83 c4 10             	add    $0x10,%esp
}
  8010cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010d2:	a1 08 40 80 00       	mov    0x804008,%eax
  8010d7:	8b 40 48             	mov    0x48(%eax),%eax
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	53                   	push   %ebx
  8010de:	50                   	push   %eax
  8010df:	68 2d 26 80 00       	push   $0x80262d
  8010e4:	e8 7b f0 ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  8010e9:	83 c4 10             	add    $0x10,%esp
  8010ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f1:	eb da                	jmp    8010cd <read+0x5a>
		return -E_NOT_SUPP;
  8010f3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8010f8:	eb d3                	jmp    8010cd <read+0x5a>

008010fa <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	57                   	push   %edi
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
  801100:	83 ec 0c             	sub    $0xc,%esp
  801103:	8b 7d 08             	mov    0x8(%ebp),%edi
  801106:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801109:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110e:	39 f3                	cmp    %esi,%ebx
  801110:	73 25                	jae    801137 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801112:	83 ec 04             	sub    $0x4,%esp
  801115:	89 f0                	mov    %esi,%eax
  801117:	29 d8                	sub    %ebx,%eax
  801119:	50                   	push   %eax
  80111a:	89 d8                	mov    %ebx,%eax
  80111c:	03 45 0c             	add    0xc(%ebp),%eax
  80111f:	50                   	push   %eax
  801120:	57                   	push   %edi
  801121:	e8 4d ff ff ff       	call   801073 <read>
		if (m < 0)
  801126:	83 c4 10             	add    $0x10,%esp
  801129:	85 c0                	test   %eax,%eax
  80112b:	78 08                	js     801135 <readn+0x3b>
			return m;
		if (m == 0)
  80112d:	85 c0                	test   %eax,%eax
  80112f:	74 06                	je     801137 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801131:	01 c3                	add    %eax,%ebx
  801133:	eb d9                	jmp    80110e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801135:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801137:	89 d8                	mov    %ebx,%eax
  801139:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80113c:	5b                   	pop    %ebx
  80113d:	5e                   	pop    %esi
  80113e:	5f                   	pop    %edi
  80113f:	5d                   	pop    %ebp
  801140:	c3                   	ret    

00801141 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	53                   	push   %ebx
  801145:	83 ec 14             	sub    $0x14,%esp
  801148:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80114b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80114e:	50                   	push   %eax
  80114f:	53                   	push   %ebx
  801150:	e8 ad fc ff ff       	call   800e02 <fd_lookup>
  801155:	83 c4 08             	add    $0x8,%esp
  801158:	85 c0                	test   %eax,%eax
  80115a:	78 3a                	js     801196 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801162:	50                   	push   %eax
  801163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801166:	ff 30                	pushl  (%eax)
  801168:	e8 eb fc ff ff       	call   800e58 <dev_lookup>
  80116d:	83 c4 10             	add    $0x10,%esp
  801170:	85 c0                	test   %eax,%eax
  801172:	78 22                	js     801196 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801177:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80117b:	74 1e                	je     80119b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80117d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801180:	8b 52 0c             	mov    0xc(%edx),%edx
  801183:	85 d2                	test   %edx,%edx
  801185:	74 35                	je     8011bc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	ff 75 10             	pushl  0x10(%ebp)
  80118d:	ff 75 0c             	pushl  0xc(%ebp)
  801190:	50                   	push   %eax
  801191:	ff d2                	call   *%edx
  801193:	83 c4 10             	add    $0x10,%esp
}
  801196:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801199:	c9                   	leave  
  80119a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80119b:	a1 08 40 80 00       	mov    0x804008,%eax
  8011a0:	8b 40 48             	mov    0x48(%eax),%eax
  8011a3:	83 ec 04             	sub    $0x4,%esp
  8011a6:	53                   	push   %ebx
  8011a7:	50                   	push   %eax
  8011a8:	68 49 26 80 00       	push   $0x802649
  8011ad:	e8 b2 ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ba:	eb da                	jmp    801196 <write+0x55>
		return -E_NOT_SUPP;
  8011bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c1:	eb d3                	jmp    801196 <write+0x55>

008011c3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c9:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011cc:	50                   	push   %eax
  8011cd:	ff 75 08             	pushl  0x8(%ebp)
  8011d0:	e8 2d fc ff ff       	call   800e02 <fd_lookup>
  8011d5:	83 c4 08             	add    $0x8,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 0e                	js     8011ea <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8011e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 14             	sub    $0x14,%esp
  8011f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f9:	50                   	push   %eax
  8011fa:	53                   	push   %ebx
  8011fb:	e8 02 fc ff ff       	call   800e02 <fd_lookup>
  801200:	83 c4 08             	add    $0x8,%esp
  801203:	85 c0                	test   %eax,%eax
  801205:	78 37                	js     80123e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801207:	83 ec 08             	sub    $0x8,%esp
  80120a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120d:	50                   	push   %eax
  80120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801211:	ff 30                	pushl  (%eax)
  801213:	e8 40 fc ff ff       	call   800e58 <dev_lookup>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	78 1f                	js     80123e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80121f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801222:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801226:	74 1b                	je     801243 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801228:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122b:	8b 52 18             	mov    0x18(%edx),%edx
  80122e:	85 d2                	test   %edx,%edx
  801230:	74 32                	je     801264 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801232:	83 ec 08             	sub    $0x8,%esp
  801235:	ff 75 0c             	pushl  0xc(%ebp)
  801238:	50                   	push   %eax
  801239:	ff d2                	call   *%edx
  80123b:	83 c4 10             	add    $0x10,%esp
}
  80123e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801241:	c9                   	leave  
  801242:	c3                   	ret    
			thisenv->env_id, fdnum);
  801243:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801248:	8b 40 48             	mov    0x48(%eax),%eax
  80124b:	83 ec 04             	sub    $0x4,%esp
  80124e:	53                   	push   %ebx
  80124f:	50                   	push   %eax
  801250:	68 0c 26 80 00       	push   $0x80260c
  801255:	e8 0a ef ff ff       	call   800164 <cprintf>
		return -E_INVAL;
  80125a:	83 c4 10             	add    $0x10,%esp
  80125d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801262:	eb da                	jmp    80123e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801264:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801269:	eb d3                	jmp    80123e <ftruncate+0x52>

0080126b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	53                   	push   %ebx
  80126f:	83 ec 14             	sub    $0x14,%esp
  801272:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801275:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801278:	50                   	push   %eax
  801279:	ff 75 08             	pushl  0x8(%ebp)
  80127c:	e8 81 fb ff ff       	call   800e02 <fd_lookup>
  801281:	83 c4 08             	add    $0x8,%esp
  801284:	85 c0                	test   %eax,%eax
  801286:	78 4b                	js     8012d3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801288:	83 ec 08             	sub    $0x8,%esp
  80128b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128e:	50                   	push   %eax
  80128f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801292:	ff 30                	pushl  (%eax)
  801294:	e8 bf fb ff ff       	call   800e58 <dev_lookup>
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	85 c0                	test   %eax,%eax
  80129e:	78 33                	js     8012d3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012a7:	74 2f                	je     8012d8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012b3:	00 00 00 
	stat->st_isdir = 0;
  8012b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012bd:	00 00 00 
	stat->st_dev = dev;
  8012c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012c6:	83 ec 08             	sub    $0x8,%esp
  8012c9:	53                   	push   %ebx
  8012ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8012cd:	ff 50 14             	call   *0x14(%eax)
  8012d0:	83 c4 10             	add    $0x10,%esp
}
  8012d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    
		return -E_NOT_SUPP;
  8012d8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012dd:	eb f4                	jmp    8012d3 <fstat+0x68>

008012df <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	56                   	push   %esi
  8012e3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	6a 00                	push   $0x0
  8012e9:	ff 75 08             	pushl  0x8(%ebp)
  8012ec:	e8 e7 01 00 00       	call   8014d8 <open>
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	83 c4 10             	add    $0x10,%esp
  8012f6:	85 c0                	test   %eax,%eax
  8012f8:	78 1b                	js     801315 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8012fa:	83 ec 08             	sub    $0x8,%esp
  8012fd:	ff 75 0c             	pushl  0xc(%ebp)
  801300:	50                   	push   %eax
  801301:	e8 65 ff ff ff       	call   80126b <fstat>
  801306:	89 c6                	mov    %eax,%esi
	close(fd);
  801308:	89 1c 24             	mov    %ebx,(%esp)
  80130b:	e8 27 fc ff ff       	call   800f37 <close>
	return r;
  801310:	83 c4 10             	add    $0x10,%esp
  801313:	89 f3                	mov    %esi,%ebx
}
  801315:	89 d8                	mov    %ebx,%eax
  801317:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131a:	5b                   	pop    %ebx
  80131b:	5e                   	pop    %esi
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	56                   	push   %esi
  801322:	53                   	push   %ebx
  801323:	89 c6                	mov    %eax,%esi
  801325:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801327:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80132e:	74 27                	je     801357 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801330:	6a 07                	push   $0x7
  801332:	68 00 50 80 00       	push   $0x805000
  801337:	56                   	push   %esi
  801338:	ff 35 00 40 80 00    	pushl  0x804000
  80133e:	e8 16 0c 00 00       	call   801f59 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801343:	83 c4 0c             	add    $0xc,%esp
  801346:	6a 00                	push   $0x0
  801348:	53                   	push   %ebx
  801349:	6a 00                	push   $0x0
  80134b:	e8 a2 0b 00 00       	call   801ef2 <ipc_recv>
}
  801350:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801353:	5b                   	pop    %ebx
  801354:	5e                   	pop    %esi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801357:	83 ec 0c             	sub    $0xc,%esp
  80135a:	6a 01                	push   $0x1
  80135c:	e8 4c 0c 00 00       	call   801fad <ipc_find_env>
  801361:	a3 00 40 80 00       	mov    %eax,0x804000
  801366:	83 c4 10             	add    $0x10,%esp
  801369:	eb c5                	jmp    801330 <fsipc+0x12>

0080136b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80136b:	55                   	push   %ebp
  80136c:	89 e5                	mov    %esp,%ebp
  80136e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	8b 40 0c             	mov    0xc(%eax),%eax
  801377:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801384:	ba 00 00 00 00       	mov    $0x0,%edx
  801389:	b8 02 00 00 00       	mov    $0x2,%eax
  80138e:	e8 8b ff ff ff       	call   80131e <fsipc>
}
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <devfile_flush>:
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ab:	b8 06 00 00 00       	mov    $0x6,%eax
  8013b0:	e8 69 ff ff ff       	call   80131e <fsipc>
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <devfile_stat>:
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d1:	b8 05 00 00 00       	mov    $0x5,%eax
  8013d6:	e8 43 ff ff ff       	call   80131e <fsipc>
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 2c                	js     80140b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	68 00 50 80 00       	push   $0x805000
  8013e7:	53                   	push   %ebx
  8013e8:	e8 96 f3 ff ff       	call   800783 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8013ed:	a1 80 50 80 00       	mov    0x805080,%eax
  8013f2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8013f8:	a1 84 50 80 00       	mov    0x805084,%eax
  8013fd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801403:	83 c4 10             	add    $0x10,%esp
  801406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <devfile_write>:
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 0c             	sub    $0xc,%esp
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80141e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801423:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801426:	8b 55 08             	mov    0x8(%ebp),%edx
  801429:	8b 52 0c             	mov    0xc(%edx),%edx
  80142c:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801432:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  801437:	50                   	push   %eax
  801438:	ff 75 0c             	pushl  0xc(%ebp)
  80143b:	68 08 50 80 00       	push   $0x805008
  801440:	e8 cc f4 ff ff       	call   800911 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  801445:	ba 00 00 00 00       	mov    $0x0,%edx
  80144a:	b8 04 00 00 00       	mov    $0x4,%eax
  80144f:	e8 ca fe ff ff       	call   80131e <fsipc>
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <devfile_read>:
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8b 40 0c             	mov    0xc(%eax),%eax
  801464:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801469:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80146f:	ba 00 00 00 00       	mov    $0x0,%edx
  801474:	b8 03 00 00 00       	mov    $0x3,%eax
  801479:	e8 a0 fe ff ff       	call   80131e <fsipc>
  80147e:	89 c3                	mov    %eax,%ebx
  801480:	85 c0                	test   %eax,%eax
  801482:	78 1f                	js     8014a3 <devfile_read+0x4d>
	assert(r <= n);
  801484:	39 f0                	cmp    %esi,%eax
  801486:	77 24                	ja     8014ac <devfile_read+0x56>
	assert(r <= PGSIZE);
  801488:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80148d:	7f 33                	jg     8014c2 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	50                   	push   %eax
  801493:	68 00 50 80 00       	push   $0x805000
  801498:	ff 75 0c             	pushl  0xc(%ebp)
  80149b:	e8 71 f4 ff ff       	call   800911 <memmove>
	return r;
  8014a0:	83 c4 10             	add    $0x10,%esp
}
  8014a3:	89 d8                	mov    %ebx,%eax
  8014a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014a8:	5b                   	pop    %ebx
  8014a9:	5e                   	pop    %esi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    
	assert(r <= n);
  8014ac:	68 7c 26 80 00       	push   $0x80267c
  8014b1:	68 83 26 80 00       	push   $0x802683
  8014b6:	6a 7b                	push   $0x7b
  8014b8:	68 98 26 80 00       	push   $0x802698
  8014bd:	e8 ea 09 00 00       	call   801eac <_panic>
	assert(r <= PGSIZE);
  8014c2:	68 a3 26 80 00       	push   $0x8026a3
  8014c7:	68 83 26 80 00       	push   $0x802683
  8014cc:	6a 7c                	push   $0x7c
  8014ce:	68 98 26 80 00       	push   $0x802698
  8014d3:	e8 d4 09 00 00       	call   801eac <_panic>

008014d8 <open>:
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	56                   	push   %esi
  8014dc:	53                   	push   %ebx
  8014dd:	83 ec 1c             	sub    $0x1c,%esp
  8014e0:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8014e3:	56                   	push   %esi
  8014e4:	e8 63 f2 ff ff       	call   80074c <strlen>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8014f1:	7f 6c                	jg     80155f <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8014f3:	83 ec 0c             	sub    $0xc,%esp
  8014f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f9:	50                   	push   %eax
  8014fa:	e8 b4 f8 ff ff       	call   800db3 <fd_alloc>
  8014ff:	89 c3                	mov    %eax,%ebx
  801501:	83 c4 10             	add    $0x10,%esp
  801504:	85 c0                	test   %eax,%eax
  801506:	78 3c                	js     801544 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	56                   	push   %esi
  80150c:	68 00 50 80 00       	push   $0x805000
  801511:	e8 6d f2 ff ff       	call   800783 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801516:	8b 45 0c             	mov    0xc(%ebp),%eax
  801519:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  80151e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801521:	b8 01 00 00 00       	mov    $0x1,%eax
  801526:	e8 f3 fd ff ff       	call   80131e <fsipc>
  80152b:	89 c3                	mov    %eax,%ebx
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	85 c0                	test   %eax,%eax
  801532:	78 19                	js     80154d <open+0x75>
	return fd2num(fd);
  801534:	83 ec 0c             	sub    $0xc,%esp
  801537:	ff 75 f4             	pushl  -0xc(%ebp)
  80153a:	e8 4d f8 ff ff       	call   800d8c <fd2num>
  80153f:	89 c3                	mov    %eax,%ebx
  801541:	83 c4 10             	add    $0x10,%esp
}
  801544:	89 d8                	mov    %ebx,%eax
  801546:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801549:	5b                   	pop    %ebx
  80154a:	5e                   	pop    %esi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
		fd_close(fd, 0);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	6a 00                	push   $0x0
  801552:	ff 75 f4             	pushl  -0xc(%ebp)
  801555:	e8 54 f9 ff ff       	call   800eae <fd_close>
		return r;
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	eb e5                	jmp    801544 <open+0x6c>
		return -E_BAD_PATH;
  80155f:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801564:	eb de                	jmp    801544 <open+0x6c>

00801566 <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80156c:	ba 00 00 00 00       	mov    $0x0,%edx
  801571:	b8 08 00 00 00       	mov    $0x8,%eax
  801576:	e8 a3 fd ff ff       	call   80131e <fsipc>
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801583:	68 af 26 80 00       	push   $0x8026af
  801588:	ff 75 0c             	pushl  0xc(%ebp)
  80158b:	e8 f3 f1 ff ff       	call   800783 <strcpy>
	return 0;
}
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <devsock_close>:
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	53                   	push   %ebx
  80159b:	83 ec 10             	sub    $0x10,%esp
  80159e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8015a1:	53                   	push   %ebx
  8015a2:	e8 3f 0a 00 00       	call   801fe6 <pageref>
  8015a7:	83 c4 10             	add    $0x10,%esp
		return 0;
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8015af:	83 f8 01             	cmp    $0x1,%eax
  8015b2:	74 07                	je     8015bb <devsock_close+0x24>
}
  8015b4:	89 d0                	mov    %edx,%eax
  8015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	ff 73 0c             	pushl  0xc(%ebx)
  8015c1:	e8 b7 02 00 00       	call   80187d <nsipc_close>
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	eb e7                	jmp    8015b4 <devsock_close+0x1d>

008015cd <devsock_write>:
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015d3:	6a 00                	push   $0x0
  8015d5:	ff 75 10             	pushl  0x10(%ebp)
  8015d8:	ff 75 0c             	pushl  0xc(%ebp)
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	ff 70 0c             	pushl  0xc(%eax)
  8015e1:	e8 74 03 00 00       	call   80195a <nsipc_send>
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <devsock_read>:
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 10             	pushl  0x10(%ebp)
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	ff 70 0c             	pushl  0xc(%eax)
  8015fc:	e8 ed 02 00 00       	call   8018ee <nsipc_recv>
}
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <fd2sockid>:
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801609:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80160c:	52                   	push   %edx
  80160d:	50                   	push   %eax
  80160e:	e8 ef f7 ff ff       	call   800e02 <fd_lookup>
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 10                	js     80162a <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161d:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801623:	39 08                	cmp    %ecx,(%eax)
  801625:	75 05                	jne    80162c <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801627:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    
		return -E_NOT_SUPP;
  80162c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801631:	eb f7                	jmp    80162a <fd2sockid+0x27>

00801633 <alloc_sockfd>:
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 1c             	sub    $0x1c,%esp
  80163b:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80163d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801640:	50                   	push   %eax
  801641:	e8 6d f7 ff ff       	call   800db3 <fd_alloc>
  801646:	89 c3                	mov    %eax,%ebx
  801648:	83 c4 10             	add    $0x10,%esp
  80164b:	85 c0                	test   %eax,%eax
  80164d:	78 43                	js     801692 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	68 07 04 00 00       	push   $0x407
  801657:	ff 75 f4             	pushl  -0xc(%ebp)
  80165a:	6a 00                	push   $0x0
  80165c:	e8 1b f5 ff ff       	call   800b7c <sys_page_alloc>
  801661:	89 c3                	mov    %eax,%ebx
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	85 c0                	test   %eax,%eax
  801668:	78 28                	js     801692 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801673:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80167f:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801682:	83 ec 0c             	sub    $0xc,%esp
  801685:	50                   	push   %eax
  801686:	e8 01 f7 ff ff       	call   800d8c <fd2num>
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	eb 0c                	jmp    80169e <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	56                   	push   %esi
  801696:	e8 e2 01 00 00       	call   80187d <nsipc_close>
		return r;
  80169b:	83 c4 10             	add    $0x10,%esp
}
  80169e:	89 d8                	mov    %ebx,%eax
  8016a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <accept>:
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	e8 4e ff ff ff       	call   801603 <fd2sockid>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	78 1b                	js     8016d4 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	ff 75 10             	pushl  0x10(%ebp)
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	50                   	push   %eax
  8016c3:	e8 0e 01 00 00       	call   8017d6 <nsipc_accept>
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 05                	js     8016d4 <accept+0x2d>
	return alloc_sockfd(r);
  8016cf:	e8 5f ff ff ff       	call   801633 <alloc_sockfd>
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <bind>:
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	e8 1f ff ff ff       	call   801603 <fd2sockid>
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 12                	js     8016fa <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	ff 75 10             	pushl  0x10(%ebp)
  8016ee:	ff 75 0c             	pushl  0xc(%ebp)
  8016f1:	50                   	push   %eax
  8016f2:	e8 2f 01 00 00       	call   801826 <nsipc_bind>
  8016f7:	83 c4 10             	add    $0x10,%esp
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <shutdown>:
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	e8 f9 fe ff ff       	call   801603 <fd2sockid>
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 0f                	js     80171d <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	50                   	push   %eax
  801715:	e8 41 01 00 00       	call   80185b <nsipc_shutdown>
  80171a:	83 c4 10             	add    $0x10,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <connect>:
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	e8 d6 fe ff ff       	call   801603 <fd2sockid>
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 12                	js     801743 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	ff 75 10             	pushl  0x10(%ebp)
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	50                   	push   %eax
  80173b:	e8 57 01 00 00       	call   801897 <nsipc_connect>
  801740:	83 c4 10             	add    $0x10,%esp
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <listen>:
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	e8 b0 fe ff ff       	call   801603 <fd2sockid>
  801753:	85 c0                	test   %eax,%eax
  801755:	78 0f                	js     801766 <listen+0x21>
	return nsipc_listen(r, backlog);
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	50                   	push   %eax
  80175e:	e8 69 01 00 00       	call   8018cc <nsipc_listen>
  801763:	83 c4 10             	add    $0x10,%esp
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <socket>:

int
socket(int domain, int type, int protocol)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80176e:	ff 75 10             	pushl  0x10(%ebp)
  801771:	ff 75 0c             	pushl  0xc(%ebp)
  801774:	ff 75 08             	pushl  0x8(%ebp)
  801777:	e8 3c 02 00 00       	call   8019b8 <nsipc_socket>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 05                	js     801788 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801783:	e8 ab fe ff ff       	call   801633 <alloc_sockfd>
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801793:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  80179a:	74 26                	je     8017c2 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  80179c:	6a 07                	push   $0x7
  80179e:	68 00 60 80 00       	push   $0x806000
  8017a3:	53                   	push   %ebx
  8017a4:	ff 35 04 40 80 00    	pushl  0x804004
  8017aa:	e8 aa 07 00 00       	call   801f59 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8017af:	83 c4 0c             	add    $0xc,%esp
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	e8 35 07 00 00       	call   801ef2 <ipc_recv>
}
  8017bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	6a 02                	push   $0x2
  8017c7:	e8 e1 07 00 00       	call   801fad <ipc_find_env>
  8017cc:	a3 04 40 80 00       	mov    %eax,0x804004
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	eb c6                	jmp    80179c <nsipc+0x12>

008017d6 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8017e6:	8b 06                	mov    (%esi),%eax
  8017e8:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8017ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8017f2:	e8 93 ff ff ff       	call   80178a <nsipc>
  8017f7:	89 c3                	mov    %eax,%ebx
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	78 20                	js     80181d <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8017fd:	83 ec 04             	sub    $0x4,%esp
  801800:	ff 35 10 60 80 00    	pushl  0x806010
  801806:	68 00 60 80 00       	push   $0x806000
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	e8 fe f0 ff ff       	call   800911 <memmove>
		*addrlen = ret->ret_addrlen;
  801813:	a1 10 60 80 00       	mov    0x806010,%eax
  801818:	89 06                	mov    %eax,(%esi)
  80181a:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  80181d:	89 d8                	mov    %ebx,%eax
  80181f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801822:	5b                   	pop    %ebx
  801823:	5e                   	pop    %esi
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	53                   	push   %ebx
  80182a:	83 ec 08             	sub    $0x8,%esp
  80182d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801838:	53                   	push   %ebx
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	68 04 60 80 00       	push   $0x806004
  801841:	e8 cb f0 ff ff       	call   800911 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801846:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80184c:	b8 02 00 00 00       	mov    $0x2,%eax
  801851:	e8 34 ff ff ff       	call   80178a <nsipc>
}
  801856:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801869:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801871:	b8 03 00 00 00       	mov    $0x3,%eax
  801876:	e8 0f ff ff ff       	call   80178a <nsipc>
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <nsipc_close>:

int
nsipc_close(int s)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80188b:	b8 04 00 00 00       	mov    $0x4,%eax
  801890:	e8 f5 fe ff ff       	call   80178a <nsipc>
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8018a9:	53                   	push   %ebx
  8018aa:	ff 75 0c             	pushl  0xc(%ebp)
  8018ad:	68 04 60 80 00       	push   $0x806004
  8018b2:	e8 5a f0 ff ff       	call   800911 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8018b7:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8018bd:	b8 05 00 00 00       	mov    $0x5,%eax
  8018c2:	e8 c3 fe ff ff       	call   80178a <nsipc>
}
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8018e2:	b8 06 00 00 00       	mov    $0x6,%eax
  8018e7:	e8 9e fe ff ff       	call   80178a <nsipc>
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	56                   	push   %esi
  8018f2:	53                   	push   %ebx
  8018f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8018fe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80190c:	b8 07 00 00 00       	mov    $0x7,%eax
  801911:	e8 74 fe ff ff       	call   80178a <nsipc>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	85 c0                	test   %eax,%eax
  80191a:	78 1f                	js     80193b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  80191c:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801921:	7f 21                	jg     801944 <nsipc_recv+0x56>
  801923:	39 c6                	cmp    %eax,%esi
  801925:	7c 1d                	jl     801944 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	50                   	push   %eax
  80192b:	68 00 60 80 00       	push   $0x806000
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	e8 d9 ef ff ff       	call   800911 <memmove>
  801938:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  80193b:	89 d8                	mov    %ebx,%eax
  80193d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801944:	68 bb 26 80 00       	push   $0x8026bb
  801949:	68 83 26 80 00       	push   $0x802683
  80194e:	6a 62                	push   $0x62
  801950:	68 d0 26 80 00       	push   $0x8026d0
  801955:	e8 52 05 00 00       	call   801eac <_panic>

0080195a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 04             	sub    $0x4,%esp
  801961:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80196c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801972:	7f 2e                	jg     8019a2 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	53                   	push   %ebx
  801978:	ff 75 0c             	pushl  0xc(%ebp)
  80197b:	68 0c 60 80 00       	push   $0x80600c
  801980:	e8 8c ef ff ff       	call   800911 <memmove>
	nsipcbuf.send.req_size = size;
  801985:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  80198b:	8b 45 14             	mov    0x14(%ebp),%eax
  80198e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801993:	b8 08 00 00 00       	mov    $0x8,%eax
  801998:	e8 ed fd ff ff       	call   80178a <nsipc>
}
  80199d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    
	assert(size < 1600);
  8019a2:	68 dc 26 80 00       	push   $0x8026dc
  8019a7:	68 83 26 80 00       	push   $0x802683
  8019ac:	6a 6d                	push   $0x6d
  8019ae:	68 d0 26 80 00       	push   $0x8026d0
  8019b3:	e8 f4 04 00 00       	call   801eac <_panic>

008019b8 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8019ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8019d6:	b8 09 00 00 00       	mov    $0x9,%eax
  8019db:	e8 aa fd ff ff       	call   80178a <nsipc>
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	56                   	push   %esi
  8019e6:	53                   	push   %ebx
  8019e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8019ea:	83 ec 0c             	sub    $0xc,%esp
  8019ed:	ff 75 08             	pushl  0x8(%ebp)
  8019f0:	e8 a7 f3 ff ff       	call   800d9c <fd2data>
  8019f5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8019f7:	83 c4 08             	add    $0x8,%esp
  8019fa:	68 e8 26 80 00       	push   $0x8026e8
  8019ff:	53                   	push   %ebx
  801a00:	e8 7e ed ff ff       	call   800783 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a05:	8b 46 04             	mov    0x4(%esi),%eax
  801a08:	2b 06                	sub    (%esi),%eax
  801a0a:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801a10:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a17:	00 00 00 
	stat->st_dev = &devpipe;
  801a1a:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801a21:	30 80 00 
	return 0;
}
  801a24:	b8 00 00 00 00       	mov    $0x0,%eax
  801a29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	53                   	push   %ebx
  801a34:	83 ec 0c             	sub    $0xc,%esp
  801a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801a3a:	53                   	push   %ebx
  801a3b:	6a 00                	push   $0x0
  801a3d:	e8 bf f1 ff ff       	call   800c01 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801a42:	89 1c 24             	mov    %ebx,(%esp)
  801a45:	e8 52 f3 ff ff       	call   800d9c <fd2data>
  801a4a:	83 c4 08             	add    $0x8,%esp
  801a4d:	50                   	push   %eax
  801a4e:	6a 00                	push   $0x0
  801a50:	e8 ac f1 ff ff       	call   800c01 <sys_page_unmap>
}
  801a55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <_pipeisclosed>:
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	57                   	push   %edi
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	83 ec 1c             	sub    $0x1c,%esp
  801a63:	89 c7                	mov    %eax,%edi
  801a65:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801a67:	a1 08 40 80 00       	mov    0x804008,%eax
  801a6c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801a6f:	83 ec 0c             	sub    $0xc,%esp
  801a72:	57                   	push   %edi
  801a73:	e8 6e 05 00 00       	call   801fe6 <pageref>
  801a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a7b:	89 34 24             	mov    %esi,(%esp)
  801a7e:	e8 63 05 00 00       	call   801fe6 <pageref>
		nn = thisenv->env_runs;
  801a83:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801a89:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	39 cb                	cmp    %ecx,%ebx
  801a91:	74 1b                	je     801aae <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801a93:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a96:	75 cf                	jne    801a67 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801a98:	8b 42 58             	mov    0x58(%edx),%eax
  801a9b:	6a 01                	push   $0x1
  801a9d:	50                   	push   %eax
  801a9e:	53                   	push   %ebx
  801a9f:	68 ef 26 80 00       	push   $0x8026ef
  801aa4:	e8 bb e6 ff ff       	call   800164 <cprintf>
  801aa9:	83 c4 10             	add    $0x10,%esp
  801aac:	eb b9                	jmp    801a67 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801aae:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ab1:	0f 94 c0             	sete   %al
  801ab4:	0f b6 c0             	movzbl %al,%eax
}
  801ab7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801aba:	5b                   	pop    %ebx
  801abb:	5e                   	pop    %esi
  801abc:	5f                   	pop    %edi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <devpipe_write>:
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	57                   	push   %edi
  801ac3:	56                   	push   %esi
  801ac4:	53                   	push   %ebx
  801ac5:	83 ec 28             	sub    $0x28,%esp
  801ac8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801acb:	56                   	push   %esi
  801acc:	e8 cb f2 ff ff       	call   800d9c <fd2data>
  801ad1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ad3:	83 c4 10             	add    $0x10,%esp
  801ad6:	bf 00 00 00 00       	mov    $0x0,%edi
  801adb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ade:	74 4f                	je     801b2f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ae0:	8b 43 04             	mov    0x4(%ebx),%eax
  801ae3:	8b 0b                	mov    (%ebx),%ecx
  801ae5:	8d 51 20             	lea    0x20(%ecx),%edx
  801ae8:	39 d0                	cmp    %edx,%eax
  801aea:	72 14                	jb     801b00 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801aec:	89 da                	mov    %ebx,%edx
  801aee:	89 f0                	mov    %esi,%eax
  801af0:	e8 65 ff ff ff       	call   801a5a <_pipeisclosed>
  801af5:	85 c0                	test   %eax,%eax
  801af7:	75 3a                	jne    801b33 <devpipe_write+0x74>
			sys_yield();
  801af9:	e8 5f f0 ff ff       	call   800b5d <sys_yield>
  801afe:	eb e0                	jmp    801ae0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b03:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801b07:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801b0a:	89 c2                	mov    %eax,%edx
  801b0c:	c1 fa 1f             	sar    $0x1f,%edx
  801b0f:	89 d1                	mov    %edx,%ecx
  801b11:	c1 e9 1b             	shr    $0x1b,%ecx
  801b14:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801b17:	83 e2 1f             	and    $0x1f,%edx
  801b1a:	29 ca                	sub    %ecx,%edx
  801b1c:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801b20:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801b24:	83 c0 01             	add    $0x1,%eax
  801b27:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801b2a:	83 c7 01             	add    $0x1,%edi
  801b2d:	eb ac                	jmp    801adb <devpipe_write+0x1c>
	return i;
  801b2f:	89 f8                	mov    %edi,%eax
  801b31:	eb 05                	jmp    801b38 <devpipe_write+0x79>
				return 0;
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5f                   	pop    %edi
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <devpipe_read>:
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	57                   	push   %edi
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
  801b46:	83 ec 18             	sub    $0x18,%esp
  801b49:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801b4c:	57                   	push   %edi
  801b4d:	e8 4a f2 ff ff       	call   800d9c <fd2data>
  801b52:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	be 00 00 00 00       	mov    $0x0,%esi
  801b5c:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b5f:	74 47                	je     801ba8 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801b61:	8b 03                	mov    (%ebx),%eax
  801b63:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b66:	75 22                	jne    801b8a <devpipe_read+0x4a>
			if (i > 0)
  801b68:	85 f6                	test   %esi,%esi
  801b6a:	75 14                	jne    801b80 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801b6c:	89 da                	mov    %ebx,%edx
  801b6e:	89 f8                	mov    %edi,%eax
  801b70:	e8 e5 fe ff ff       	call   801a5a <_pipeisclosed>
  801b75:	85 c0                	test   %eax,%eax
  801b77:	75 33                	jne    801bac <devpipe_read+0x6c>
			sys_yield();
  801b79:	e8 df ef ff ff       	call   800b5d <sys_yield>
  801b7e:	eb e1                	jmp    801b61 <devpipe_read+0x21>
				return i;
  801b80:	89 f0                	mov    %esi,%eax
}
  801b82:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b85:	5b                   	pop    %ebx
  801b86:	5e                   	pop    %esi
  801b87:	5f                   	pop    %edi
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801b8a:	99                   	cltd   
  801b8b:	c1 ea 1b             	shr    $0x1b,%edx
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	83 e0 1f             	and    $0x1f,%eax
  801b93:	29 d0                	sub    %edx,%eax
  801b95:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b9d:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ba0:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ba3:	83 c6 01             	add    $0x1,%esi
  801ba6:	eb b4                	jmp    801b5c <devpipe_read+0x1c>
	return i;
  801ba8:	89 f0                	mov    %esi,%eax
  801baa:	eb d6                	jmp    801b82 <devpipe_read+0x42>
				return 0;
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	eb cf                	jmp    801b82 <devpipe_read+0x42>

00801bb3 <pipe>:
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	56                   	push   %esi
  801bb7:	53                   	push   %ebx
  801bb8:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801bbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbe:	50                   	push   %eax
  801bbf:	e8 ef f1 ff ff       	call   800db3 <fd_alloc>
  801bc4:	89 c3                	mov    %eax,%ebx
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	78 5b                	js     801c28 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bcd:	83 ec 04             	sub    $0x4,%esp
  801bd0:	68 07 04 00 00       	push   $0x407
  801bd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801bd8:	6a 00                	push   $0x0
  801bda:	e8 9d ef ff ff       	call   800b7c <sys_page_alloc>
  801bdf:	89 c3                	mov    %eax,%ebx
  801be1:	83 c4 10             	add    $0x10,%esp
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 40                	js     801c28 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bee:	50                   	push   %eax
  801bef:	e8 bf f1 ff ff       	call   800db3 <fd_alloc>
  801bf4:	89 c3                	mov    %eax,%ebx
  801bf6:	83 c4 10             	add    $0x10,%esp
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 1b                	js     801c18 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801bfd:	83 ec 04             	sub    $0x4,%esp
  801c00:	68 07 04 00 00       	push   $0x407
  801c05:	ff 75 f0             	pushl  -0x10(%ebp)
  801c08:	6a 00                	push   $0x0
  801c0a:	e8 6d ef ff ff       	call   800b7c <sys_page_alloc>
  801c0f:	89 c3                	mov    %eax,%ebx
  801c11:	83 c4 10             	add    $0x10,%esp
  801c14:	85 c0                	test   %eax,%eax
  801c16:	79 19                	jns    801c31 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1e:	6a 00                	push   $0x0
  801c20:	e8 dc ef ff ff       	call   800c01 <sys_page_unmap>
  801c25:	83 c4 10             	add    $0x10,%esp
}
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
	va = fd2data(fd0);
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	ff 75 f4             	pushl  -0xc(%ebp)
  801c37:	e8 60 f1 ff ff       	call   800d9c <fd2data>
  801c3c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c3e:	83 c4 0c             	add    $0xc,%esp
  801c41:	68 07 04 00 00       	push   $0x407
  801c46:	50                   	push   %eax
  801c47:	6a 00                	push   $0x0
  801c49:	e8 2e ef ff ff       	call   800b7c <sys_page_alloc>
  801c4e:	89 c3                	mov    %eax,%ebx
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	85 c0                	test   %eax,%eax
  801c55:	0f 88 8c 00 00 00    	js     801ce7 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c5b:	83 ec 0c             	sub    $0xc,%esp
  801c5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c61:	e8 36 f1 ff ff       	call   800d9c <fd2data>
  801c66:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801c6d:	50                   	push   %eax
  801c6e:	6a 00                	push   $0x0
  801c70:	56                   	push   %esi
  801c71:	6a 00                	push   $0x0
  801c73:	e8 47 ef ff ff       	call   800bbf <sys_page_map>
  801c78:	89 c3                	mov    %eax,%ebx
  801c7a:	83 c4 20             	add    $0x20,%esp
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	78 58                	js     801cd9 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c84:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c99:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c9f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb1:	e8 d6 f0 ff ff       	call   800d8c <fd2num>
  801cb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb9:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801cbb:	83 c4 04             	add    $0x4,%esp
  801cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  801cc1:	e8 c6 f0 ff ff       	call   800d8c <fd2num>
  801cc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc9:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cd4:	e9 4f ff ff ff       	jmp    801c28 <pipe+0x75>
	sys_page_unmap(0, va);
  801cd9:	83 ec 08             	sub    $0x8,%esp
  801cdc:	56                   	push   %esi
  801cdd:	6a 00                	push   $0x0
  801cdf:	e8 1d ef ff ff       	call   800c01 <sys_page_unmap>
  801ce4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ce7:	83 ec 08             	sub    $0x8,%esp
  801cea:	ff 75 f0             	pushl  -0x10(%ebp)
  801ced:	6a 00                	push   $0x0
  801cef:	e8 0d ef ff ff       	call   800c01 <sys_page_unmap>
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	e9 1c ff ff ff       	jmp    801c18 <pipe+0x65>

00801cfc <pipeisclosed>:
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d02:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d05:	50                   	push   %eax
  801d06:	ff 75 08             	pushl  0x8(%ebp)
  801d09:	e8 f4 f0 ff ff       	call   800e02 <fd_lookup>
  801d0e:	83 c4 10             	add    $0x10,%esp
  801d11:	85 c0                	test   %eax,%eax
  801d13:	78 18                	js     801d2d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d15:	83 ec 0c             	sub    $0xc,%esp
  801d18:	ff 75 f4             	pushl  -0xc(%ebp)
  801d1b:	e8 7c f0 ff ff       	call   800d9c <fd2data>
	return _pipeisclosed(fd, p);
  801d20:	89 c2                	mov    %eax,%edx
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	e8 30 fd ff ff       	call   801a5a <_pipeisclosed>
  801d2a:	83 c4 10             	add    $0x10,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801d3f:	68 07 27 80 00       	push   $0x802707
  801d44:	ff 75 0c             	pushl  0xc(%ebp)
  801d47:	e8 37 ea ff ff       	call   800783 <strcpy>
	return 0;
}
  801d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <devcons_write>:
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	57                   	push   %edi
  801d57:	56                   	push   %esi
  801d58:	53                   	push   %ebx
  801d59:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801d5f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801d64:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801d6a:	eb 2f                	jmp    801d9b <devcons_write+0x48>
		m = n - tot;
  801d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d6f:	29 f3                	sub    %esi,%ebx
  801d71:	83 fb 7f             	cmp    $0x7f,%ebx
  801d74:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801d79:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	53                   	push   %ebx
  801d80:	89 f0                	mov    %esi,%eax
  801d82:	03 45 0c             	add    0xc(%ebp),%eax
  801d85:	50                   	push   %eax
  801d86:	57                   	push   %edi
  801d87:	e8 85 eb ff ff       	call   800911 <memmove>
		sys_cputs(buf, m);
  801d8c:	83 c4 08             	add    $0x8,%esp
  801d8f:	53                   	push   %ebx
  801d90:	57                   	push   %edi
  801d91:	e8 2a ed ff ff       	call   800ac0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801d96:	01 de                	add    %ebx,%esi
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d9e:	72 cc                	jb     801d6c <devcons_write+0x19>
}
  801da0:	89 f0                	mov    %esi,%eax
  801da2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <devcons_read>:
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 08             	sub    $0x8,%esp
  801db0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801db5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801db9:	75 07                	jne    801dc2 <devcons_read+0x18>
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    
		sys_yield();
  801dbd:	e8 9b ed ff ff       	call   800b5d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801dc2:	e8 17 ed ff ff       	call   800ade <sys_cgetc>
  801dc7:	85 c0                	test   %eax,%eax
  801dc9:	74 f2                	je     801dbd <devcons_read+0x13>
	if (c < 0)
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	78 ec                	js     801dbb <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801dcf:	83 f8 04             	cmp    $0x4,%eax
  801dd2:	74 0c                	je     801de0 <devcons_read+0x36>
	*(char*)vbuf = c;
  801dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd7:	88 02                	mov    %al,(%edx)
	return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb db                	jmp    801dbb <devcons_read+0x11>
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
  801de5:	eb d4                	jmp    801dbb <devcons_read+0x11>

00801de7 <cputchar>:
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801df3:	6a 01                	push   $0x1
  801df5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801df8:	50                   	push   %eax
  801df9:	e8 c2 ec ff ff       	call   800ac0 <sys_cputs>
}
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <getchar>:
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e09:	6a 01                	push   $0x1
  801e0b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e0e:	50                   	push   %eax
  801e0f:	6a 00                	push   $0x0
  801e11:	e8 5d f2 ff ff       	call   801073 <read>
	if (r < 0)
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	85 c0                	test   %eax,%eax
  801e1b:	78 08                	js     801e25 <getchar+0x22>
	if (r < 1)
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	7e 06                	jle    801e27 <getchar+0x24>
	return c;
  801e21:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    
		return -E_EOF;
  801e27:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801e2c:	eb f7                	jmp    801e25 <getchar+0x22>

00801e2e <iscons>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e37:	50                   	push   %eax
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 c2 ef ff ff       	call   800e02 <fd_lookup>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	85 c0                	test   %eax,%eax
  801e45:	78 11                	js     801e58 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e50:	39 10                	cmp    %edx,(%eax)
  801e52:	0f 94 c0             	sete   %al
  801e55:	0f b6 c0             	movzbl %al,%eax
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <opencons>:
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801e60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e63:	50                   	push   %eax
  801e64:	e8 4a ef ff ff       	call   800db3 <fd_alloc>
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	78 3a                	js     801eaa <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 07 04 00 00       	push   $0x407
  801e78:	ff 75 f4             	pushl  -0xc(%ebp)
  801e7b:	6a 00                	push   $0x0
  801e7d:	e8 fa ec ff ff       	call   800b7c <sys_page_alloc>
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	85 c0                	test   %eax,%eax
  801e87:	78 21                	js     801eaa <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801e92:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e97:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	50                   	push   %eax
  801ea2:	e8 e5 ee ff ff       	call   800d8c <fd2num>
  801ea7:	83 c4 10             	add    $0x10,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	56                   	push   %esi
  801eb0:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801eb1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801eb4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801eba:	e8 7f ec ff ff       	call   800b3e <sys_getenvid>
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	ff 75 0c             	pushl  0xc(%ebp)
  801ec5:	ff 75 08             	pushl  0x8(%ebp)
  801ec8:	56                   	push   %esi
  801ec9:	50                   	push   %eax
  801eca:	68 14 27 80 00       	push   $0x802714
  801ecf:	e8 90 e2 ff ff       	call   800164 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801ed4:	83 c4 18             	add    $0x18,%esp
  801ed7:	53                   	push   %ebx
  801ed8:	ff 75 10             	pushl  0x10(%ebp)
  801edb:	e8 33 e2 ff ff       	call   800113 <vcprintf>
	cprintf("\n");
  801ee0:	c7 04 24 00 27 80 00 	movl   $0x802700,(%esp)
  801ee7:	e8 78 e2 ff ff       	call   800164 <cprintf>
  801eec:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801eef:	cc                   	int3   
  801ef0:	eb fd                	jmp    801eef <_panic+0x43>

00801ef2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	56                   	push   %esi
  801ef6:	53                   	push   %ebx
  801ef7:	8b 75 08             	mov    0x8(%ebp),%esi
  801efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f00:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801f02:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801f07:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	50                   	push   %eax
  801f0e:	e8 19 ee ff ff       	call   800d2c <sys_ipc_recv>
	if (from_env_store)
  801f13:	83 c4 10             	add    $0x10,%esp
  801f16:	85 f6                	test   %esi,%esi
  801f18:	74 14                	je     801f2e <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801f1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	78 09                	js     801f2c <ipc_recv+0x3a>
  801f23:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f29:	8b 52 74             	mov    0x74(%edx),%edx
  801f2c:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801f2e:	85 db                	test   %ebx,%ebx
  801f30:	74 14                	je     801f46 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  801f32:	ba 00 00 00 00       	mov    $0x0,%edx
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 09                	js     801f44 <ipc_recv+0x52>
  801f3b:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801f41:	8b 52 78             	mov    0x78(%edx),%edx
  801f44:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  801f46:	85 c0                	test   %eax,%eax
  801f48:	78 08                	js     801f52 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  801f4a:	a1 08 40 80 00       	mov    0x804008,%eax
  801f4f:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  801f52:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f55:	5b                   	pop    %ebx
  801f56:	5e                   	pop    %esi
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	57                   	push   %edi
  801f5d:	56                   	push   %esi
  801f5e:	53                   	push   %ebx
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f65:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f68:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801f6b:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  801f6d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801f72:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f75:	ff 75 14             	pushl  0x14(%ebp)
  801f78:	53                   	push   %ebx
  801f79:	56                   	push   %esi
  801f7a:	57                   	push   %edi
  801f7b:	e8 89 ed ff ff       	call   800d09 <sys_ipc_try_send>
		if (ret == 0)
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	74 1e                	je     801fa5 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  801f87:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f8a:	75 07                	jne    801f93 <ipc_send+0x3a>
			sys_yield();
  801f8c:	e8 cc eb ff ff       	call   800b5d <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  801f91:	eb e2                	jmp    801f75 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  801f93:	50                   	push   %eax
  801f94:	68 38 27 80 00       	push   $0x802738
  801f99:	6a 3d                	push   $0x3d
  801f9b:	68 4c 27 80 00       	push   $0x80274c
  801fa0:	e8 07 ff ff ff       	call   801eac <_panic>
	}
	// panic("ipc_send not implemented");
}
  801fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5f                   	pop    %edi
  801fab:	5d                   	pop    %ebp
  801fac:	c3                   	ret    

00801fad <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fb8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801fbb:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801fc1:	8b 52 50             	mov    0x50(%edx),%edx
  801fc4:	39 ca                	cmp    %ecx,%edx
  801fc6:	74 11                	je     801fd9 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  801fc8:	83 c0 01             	add    $0x1,%eax
  801fcb:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fd0:	75 e6                	jne    801fb8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	eb 0b                	jmp    801fe4 <ipc_find_env+0x37>
			return envs[i].env_id;
  801fd9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801fdc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801fe1:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    

00801fe6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fec:	89 d0                	mov    %edx,%eax
  801fee:	c1 e8 16             	shr    $0x16,%eax
  801ff1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  801ffd:	f6 c1 01             	test   $0x1,%cl
  802000:	74 1d                	je     80201f <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802002:	c1 ea 0c             	shr    $0xc,%edx
  802005:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80200c:	f6 c2 01             	test   $0x1,%dl
  80200f:	74 0e                	je     80201f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802011:	c1 ea 0c             	shr    $0xc,%edx
  802014:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80201b:	ef 
  80201c:	0f b7 c0             	movzwl %ax,%eax
}
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    
  802021:	66 90                	xchg   %ax,%ax
  802023:	66 90                	xchg   %ax,%ax
  802025:	66 90                	xchg   %ax,%ax
  802027:	66 90                	xchg   %ax,%ax
  802029:	66 90                	xchg   %ax,%ax
  80202b:	66 90                	xchg   %ax,%ax
  80202d:	66 90                	xchg   %ax,%ax
  80202f:	90                   	nop

00802030 <__udivdi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	53                   	push   %ebx
  802034:	83 ec 1c             	sub    $0x1c,%esp
  802037:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80203b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80203f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802043:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802047:	85 d2                	test   %edx,%edx
  802049:	75 35                	jne    802080 <__udivdi3+0x50>
  80204b:	39 f3                	cmp    %esi,%ebx
  80204d:	0f 87 bd 00 00 00    	ja     802110 <__udivdi3+0xe0>
  802053:	85 db                	test   %ebx,%ebx
  802055:	89 d9                	mov    %ebx,%ecx
  802057:	75 0b                	jne    802064 <__udivdi3+0x34>
  802059:	b8 01 00 00 00       	mov    $0x1,%eax
  80205e:	31 d2                	xor    %edx,%edx
  802060:	f7 f3                	div    %ebx
  802062:	89 c1                	mov    %eax,%ecx
  802064:	31 d2                	xor    %edx,%edx
  802066:	89 f0                	mov    %esi,%eax
  802068:	f7 f1                	div    %ecx
  80206a:	89 c6                	mov    %eax,%esi
  80206c:	89 e8                	mov    %ebp,%eax
  80206e:	89 f7                	mov    %esi,%edi
  802070:	f7 f1                	div    %ecx
  802072:	89 fa                	mov    %edi,%edx
  802074:	83 c4 1c             	add    $0x1c,%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5f                   	pop    %edi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    
  80207c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802080:	39 f2                	cmp    %esi,%edx
  802082:	77 7c                	ja     802100 <__udivdi3+0xd0>
  802084:	0f bd fa             	bsr    %edx,%edi
  802087:	83 f7 1f             	xor    $0x1f,%edi
  80208a:	0f 84 98 00 00 00    	je     802128 <__udivdi3+0xf8>
  802090:	89 f9                	mov    %edi,%ecx
  802092:	b8 20 00 00 00       	mov    $0x20,%eax
  802097:	29 f8                	sub    %edi,%eax
  802099:	d3 e2                	shl    %cl,%edx
  80209b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80209f:	89 c1                	mov    %eax,%ecx
  8020a1:	89 da                	mov    %ebx,%edx
  8020a3:	d3 ea                	shr    %cl,%edx
  8020a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8020a9:	09 d1                	or     %edx,%ecx
  8020ab:	89 f2                	mov    %esi,%edx
  8020ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020b1:	89 f9                	mov    %edi,%ecx
  8020b3:	d3 e3                	shl    %cl,%ebx
  8020b5:	89 c1                	mov    %eax,%ecx
  8020b7:	d3 ea                	shr    %cl,%edx
  8020b9:	89 f9                	mov    %edi,%ecx
  8020bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8020bf:	d3 e6                	shl    %cl,%esi
  8020c1:	89 eb                	mov    %ebp,%ebx
  8020c3:	89 c1                	mov    %eax,%ecx
  8020c5:	d3 eb                	shr    %cl,%ebx
  8020c7:	09 de                	or     %ebx,%esi
  8020c9:	89 f0                	mov    %esi,%eax
  8020cb:	f7 74 24 08          	divl   0x8(%esp)
  8020cf:	89 d6                	mov    %edx,%esi
  8020d1:	89 c3                	mov    %eax,%ebx
  8020d3:	f7 64 24 0c          	mull   0xc(%esp)
  8020d7:	39 d6                	cmp    %edx,%esi
  8020d9:	72 0c                	jb     8020e7 <__udivdi3+0xb7>
  8020db:	89 f9                	mov    %edi,%ecx
  8020dd:	d3 e5                	shl    %cl,%ebp
  8020df:	39 c5                	cmp    %eax,%ebp
  8020e1:	73 5d                	jae    802140 <__udivdi3+0x110>
  8020e3:	39 d6                	cmp    %edx,%esi
  8020e5:	75 59                	jne    802140 <__udivdi3+0x110>
  8020e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ea:	31 ff                	xor    %edi,%edi
  8020ec:	89 fa                	mov    %edi,%edx
  8020ee:	83 c4 1c             	add    $0x1c,%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5f                   	pop    %edi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    
  8020f6:	8d 76 00             	lea    0x0(%esi),%esi
  8020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802100:	31 ff                	xor    %edi,%edi
  802102:	31 c0                	xor    %eax,%eax
  802104:	89 fa                	mov    %edi,%edx
  802106:	83 c4 1c             	add    $0x1c,%esp
  802109:	5b                   	pop    %ebx
  80210a:	5e                   	pop    %esi
  80210b:	5f                   	pop    %edi
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    
  80210e:	66 90                	xchg   %ax,%ax
  802110:	31 ff                	xor    %edi,%edi
  802112:	89 e8                	mov    %ebp,%eax
  802114:	89 f2                	mov    %esi,%edx
  802116:	f7 f3                	div    %ebx
  802118:	89 fa                	mov    %edi,%edx
  80211a:	83 c4 1c             	add    $0x1c,%esp
  80211d:	5b                   	pop    %ebx
  80211e:	5e                   	pop    %esi
  80211f:	5f                   	pop    %edi
  802120:	5d                   	pop    %ebp
  802121:	c3                   	ret    
  802122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802128:	39 f2                	cmp    %esi,%edx
  80212a:	72 06                	jb     802132 <__udivdi3+0x102>
  80212c:	31 c0                	xor    %eax,%eax
  80212e:	39 eb                	cmp    %ebp,%ebx
  802130:	77 d2                	ja     802104 <__udivdi3+0xd4>
  802132:	b8 01 00 00 00       	mov    $0x1,%eax
  802137:	eb cb                	jmp    802104 <__udivdi3+0xd4>
  802139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802140:	89 d8                	mov    %ebx,%eax
  802142:	31 ff                	xor    %edi,%edi
  802144:	eb be                	jmp    802104 <__udivdi3+0xd4>
  802146:	66 90                	xchg   %ax,%ax
  802148:	66 90                	xchg   %ax,%ax
  80214a:	66 90                	xchg   %ax,%ax
  80214c:	66 90                	xchg   %ax,%ax
  80214e:	66 90                	xchg   %ax,%ax

00802150 <__umoddi3>:
  802150:	55                   	push   %ebp
  802151:	57                   	push   %edi
  802152:	56                   	push   %esi
  802153:	53                   	push   %ebx
  802154:	83 ec 1c             	sub    $0x1c,%esp
  802157:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80215b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80215f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802163:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802167:	85 ed                	test   %ebp,%ebp
  802169:	89 f0                	mov    %esi,%eax
  80216b:	89 da                	mov    %ebx,%edx
  80216d:	75 19                	jne    802188 <__umoddi3+0x38>
  80216f:	39 df                	cmp    %ebx,%edi
  802171:	0f 86 b1 00 00 00    	jbe    802228 <__umoddi3+0xd8>
  802177:	f7 f7                	div    %edi
  802179:	89 d0                	mov    %edx,%eax
  80217b:	31 d2                	xor    %edx,%edx
  80217d:	83 c4 1c             	add    $0x1c,%esp
  802180:	5b                   	pop    %ebx
  802181:	5e                   	pop    %esi
  802182:	5f                   	pop    %edi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    
  802185:	8d 76 00             	lea    0x0(%esi),%esi
  802188:	39 dd                	cmp    %ebx,%ebp
  80218a:	77 f1                	ja     80217d <__umoddi3+0x2d>
  80218c:	0f bd cd             	bsr    %ebp,%ecx
  80218f:	83 f1 1f             	xor    $0x1f,%ecx
  802192:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802196:	0f 84 b4 00 00 00    	je     802250 <__umoddi3+0x100>
  80219c:	b8 20 00 00 00       	mov    $0x20,%eax
  8021a1:	89 c2                	mov    %eax,%edx
  8021a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021a7:	29 c2                	sub    %eax,%edx
  8021a9:	89 c1                	mov    %eax,%ecx
  8021ab:	89 f8                	mov    %edi,%eax
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	89 d1                	mov    %edx,%ecx
  8021b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021b5:	d3 e8                	shr    %cl,%eax
  8021b7:	09 c5                	or     %eax,%ebp
  8021b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8021bd:	89 c1                	mov    %eax,%ecx
  8021bf:	d3 e7                	shl    %cl,%edi
  8021c1:	89 d1                	mov    %edx,%ecx
  8021c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021c7:	89 df                	mov    %ebx,%edi
  8021c9:	d3 ef                	shr    %cl,%edi
  8021cb:	89 c1                	mov    %eax,%ecx
  8021cd:	89 f0                	mov    %esi,%eax
  8021cf:	d3 e3                	shl    %cl,%ebx
  8021d1:	89 d1                	mov    %edx,%ecx
  8021d3:	89 fa                	mov    %edi,%edx
  8021d5:	d3 e8                	shr    %cl,%eax
  8021d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8021dc:	09 d8                	or     %ebx,%eax
  8021de:	f7 f5                	div    %ebp
  8021e0:	d3 e6                	shl    %cl,%esi
  8021e2:	89 d1                	mov    %edx,%ecx
  8021e4:	f7 64 24 08          	mull   0x8(%esp)
  8021e8:	39 d1                	cmp    %edx,%ecx
  8021ea:	89 c3                	mov    %eax,%ebx
  8021ec:	89 d7                	mov    %edx,%edi
  8021ee:	72 06                	jb     8021f6 <__umoddi3+0xa6>
  8021f0:	75 0e                	jne    802200 <__umoddi3+0xb0>
  8021f2:	39 c6                	cmp    %eax,%esi
  8021f4:	73 0a                	jae    802200 <__umoddi3+0xb0>
  8021f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8021fa:	19 ea                	sbb    %ebp,%edx
  8021fc:	89 d7                	mov    %edx,%edi
  8021fe:	89 c3                	mov    %eax,%ebx
  802200:	89 ca                	mov    %ecx,%edx
  802202:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802207:	29 de                	sub    %ebx,%esi
  802209:	19 fa                	sbb    %edi,%edx
  80220b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80220f:	89 d0                	mov    %edx,%eax
  802211:	d3 e0                	shl    %cl,%eax
  802213:	89 d9                	mov    %ebx,%ecx
  802215:	d3 ee                	shr    %cl,%esi
  802217:	d3 ea                	shr    %cl,%edx
  802219:	09 f0                	or     %esi,%eax
  80221b:	83 c4 1c             	add    $0x1c,%esp
  80221e:	5b                   	pop    %ebx
  80221f:	5e                   	pop    %esi
  802220:	5f                   	pop    %edi
  802221:	5d                   	pop    %ebp
  802222:	c3                   	ret    
  802223:	90                   	nop
  802224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802228:	85 ff                	test   %edi,%edi
  80222a:	89 f9                	mov    %edi,%ecx
  80222c:	75 0b                	jne    802239 <__umoddi3+0xe9>
  80222e:	b8 01 00 00 00       	mov    $0x1,%eax
  802233:	31 d2                	xor    %edx,%edx
  802235:	f7 f7                	div    %edi
  802237:	89 c1                	mov    %eax,%ecx
  802239:	89 d8                	mov    %ebx,%eax
  80223b:	31 d2                	xor    %edx,%edx
  80223d:	f7 f1                	div    %ecx
  80223f:	89 f0                	mov    %esi,%eax
  802241:	f7 f1                	div    %ecx
  802243:	e9 31 ff ff ff       	jmp    802179 <__umoddi3+0x29>
  802248:	90                   	nop
  802249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802250:	39 dd                	cmp    %ebx,%ebp
  802252:	72 08                	jb     80225c <__umoddi3+0x10c>
  802254:	39 f7                	cmp    %esi,%edi
  802256:	0f 87 21 ff ff ff    	ja     80217d <__umoddi3+0x2d>
  80225c:	89 da                	mov    %ebx,%edx
  80225e:	89 f0                	mov    %esi,%eax
  802260:	29 f8                	sub    %edi,%eax
  802262:	19 ea                	sbb    %ebp,%edx
  802264:	e9 14 ff ff ff       	jmp    80217d <__umoddi3+0x2d>

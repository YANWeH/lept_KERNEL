
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	53                   	push   %ebx
  800040:	68 40 23 80 00       	push   $0x802340
  800045:	e8 a6 01 00 00       	call   8001f0 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004a:	83 c4 0c             	add    $0xc,%esp
  80004d:	6a 07                	push   $0x7
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800056:	50                   	push   %eax
  800057:	6a 00                	push   $0x0
  800059:	e8 aa 0b 00 00       	call   800c08 <sys_page_alloc>
  80005e:	83 c4 10             	add    $0x10,%esp
  800061:	85 c0                	test   %eax,%eax
  800063:	78 16                	js     80007b <handler+0x48>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800065:	53                   	push   %ebx
  800066:	68 8c 23 80 00       	push   $0x80238c
  80006b:	6a 64                	push   $0x64
  80006d:	53                   	push   %ebx
  80006e:	e8 4b 07 00 00       	call   8007be <snprintf>
}
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800079:	c9                   	leave  
  80007a:	c3                   	ret    
		panic("allocating at %x in page fault handler: %e", addr, r);
  80007b:	83 ec 0c             	sub    $0xc,%esp
  80007e:	50                   	push   %eax
  80007f:	53                   	push   %ebx
  800080:	68 60 23 80 00       	push   $0x802360
  800085:	6a 0f                	push   $0xf
  800087:	68 4a 23 80 00       	push   $0x80234a
  80008c:	e8 84 00 00 00       	call   800115 <_panic>

00800091 <umain>:

void
umain(int argc, char **argv)
{
  800091:	55                   	push   %ebp
  800092:	89 e5                	mov    %esp,%ebp
  800094:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800097:	68 33 00 80 00       	push   $0x800033
  80009c:	e8 77 0d 00 00       	call   800e18 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000a1:	83 c4 08             	add    $0x8,%esp
  8000a4:	6a 04                	push   $0x4
  8000a6:	68 ef be ad de       	push   $0xdeadbeef
  8000ab:	e8 9c 0a 00 00       	call   800b4c <sys_cputs>
}
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 05 0b 00 00       	call   800bca <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000d7:	85 db                	test   %ebx,%ebx
  8000d9:	7e 07                	jle    8000e2 <libmain+0x2d>
		binaryname = argv[0];
  8000db:	8b 06                	mov    (%esi),%eax
  8000dd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e2:	83 ec 08             	sub    $0x8,%esp
  8000e5:	56                   	push   %esi
  8000e6:	53                   	push   %ebx
  8000e7:	e8 a5 ff ff ff       	call   800091 <umain>

	// exit gracefully
	exit();
  8000ec:	e8 0a 00 00 00       	call   8000fb <exit>
}
  8000f1:	83 c4 10             	add    $0x10,%esp
  8000f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <exit>:

#include <inc/lib.h>

void exit(void)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800101:	e8 73 0f 00 00       	call   801079 <close_all>
	sys_env_destroy(0);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	6a 00                	push   $0x0
  80010b:	e8 79 0a 00 00       	call   800b89 <sys_env_destroy>
}
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	c9                   	leave  
  800114:	c3                   	ret    

00800115 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800115:	55                   	push   %ebp
  800116:	89 e5                	mov    %esp,%ebp
  800118:	56                   	push   %esi
  800119:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  80011a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80011d:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800123:	e8 a2 0a 00 00       	call   800bca <sys_getenvid>
  800128:	83 ec 0c             	sub    $0xc,%esp
  80012b:	ff 75 0c             	pushl  0xc(%ebp)
  80012e:	ff 75 08             	pushl  0x8(%ebp)
  800131:	56                   	push   %esi
  800132:	50                   	push   %eax
  800133:	68 b8 23 80 00       	push   $0x8023b8
  800138:	e8 b3 00 00 00       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80013d:	83 c4 18             	add    $0x18,%esp
  800140:	53                   	push   %ebx
  800141:	ff 75 10             	pushl  0x10(%ebp)
  800144:	e8 56 00 00 00       	call   80019f <vcprintf>
	cprintf("\n");
  800149:	c7 04 24 48 28 80 00 	movl   $0x802848,(%esp)
  800150:	e8 9b 00 00 00       	call   8001f0 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800158:	cc                   	int3   
  800159:	eb fd                	jmp    800158 <_panic+0x43>

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 b8 09 00 00       	call   800b4c <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 1a 01 00 00       	call   8002ed <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 64 09 00 00       	call   800b4c <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c7                	mov    %eax,%edi
  80020f:	89 d6                	mov    %edx,%esi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80021d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800220:	bb 00 00 00 00       	mov    $0x0,%ebx
  800225:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800228:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80022b:	39 d3                	cmp    %edx,%ebx
  80022d:	72 05                	jb     800234 <printnum+0x30>
  80022f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800232:	77 7a                	ja     8002ae <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	8b 45 14             	mov    0x14(%ebp),%eax
  80023d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800240:	53                   	push   %ebx
  800241:	ff 75 10             	pushl  0x10(%ebp)
  800244:	83 ec 08             	sub    $0x8,%esp
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	ff 75 dc             	pushl  -0x24(%ebp)
  800250:	ff 75 d8             	pushl  -0x28(%ebp)
  800253:	e8 a8 1e 00 00       	call   802100 <__udivdi3>
  800258:	83 c4 18             	add    $0x18,%esp
  80025b:	52                   	push   %edx
  80025c:	50                   	push   %eax
  80025d:	89 f2                	mov    %esi,%edx
  80025f:	89 f8                	mov    %edi,%eax
  800261:	e8 9e ff ff ff       	call   800204 <printnum>
  800266:	83 c4 20             	add    $0x20,%esp
  800269:	eb 13                	jmp    80027e <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	56                   	push   %esi
  80026f:	ff 75 18             	pushl  0x18(%ebp)
  800272:	ff d7                	call   *%edi
  800274:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800277:	83 eb 01             	sub    $0x1,%ebx
  80027a:	85 db                	test   %ebx,%ebx
  80027c:	7f ed                	jg     80026b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027e:	83 ec 08             	sub    $0x8,%esp
  800281:	56                   	push   %esi
  800282:	83 ec 04             	sub    $0x4,%esp
  800285:	ff 75 e4             	pushl  -0x1c(%ebp)
  800288:	ff 75 e0             	pushl  -0x20(%ebp)
  80028b:	ff 75 dc             	pushl  -0x24(%ebp)
  80028e:	ff 75 d8             	pushl  -0x28(%ebp)
  800291:	e8 8a 1f 00 00       	call   802220 <__umoddi3>
  800296:	83 c4 14             	add    $0x14,%esp
  800299:	0f be 80 db 23 80 00 	movsbl 0x8023db(%eax),%eax
  8002a0:	50                   	push   %eax
  8002a1:	ff d7                	call   *%edi
}
  8002a3:	83 c4 10             	add    $0x10,%esp
  8002a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a9:	5b                   	pop    %ebx
  8002aa:	5e                   	pop    %esi
  8002ab:	5f                   	pop    %edi
  8002ac:	5d                   	pop    %ebp
  8002ad:	c3                   	ret    
  8002ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b1:	eb c4                	jmp    800277 <printnum+0x73>

008002b3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
  8002b6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002b9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002bd:	8b 10                	mov    (%eax),%edx
  8002bf:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c2:	73 0a                	jae    8002ce <sprintputch+0x1b>
		*b->buf++ = ch;
  8002c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002c7:	89 08                	mov    %ecx,(%eax)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	88 02                	mov    %al,(%edx)
}
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <printfmt>:
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002d6:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002d9:	50                   	push   %eax
  8002da:	ff 75 10             	pushl  0x10(%ebp)
  8002dd:	ff 75 0c             	pushl  0xc(%ebp)
  8002e0:	ff 75 08             	pushl  0x8(%ebp)
  8002e3:	e8 05 00 00 00       	call   8002ed <vprintfmt>
}
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	c9                   	leave  
  8002ec:	c3                   	ret    

008002ed <vprintfmt>:
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	57                   	push   %edi
  8002f1:	56                   	push   %esi
  8002f2:	53                   	push   %ebx
  8002f3:	83 ec 2c             	sub    $0x2c,%esp
  8002f6:	8b 75 08             	mov    0x8(%ebp),%esi
  8002f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002fc:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ff:	e9 c1 03 00 00       	jmp    8006c5 <vprintfmt+0x3d8>
		padc = ' ';
  800304:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  800308:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  80030f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  800316:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80031d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800322:	8d 47 01             	lea    0x1(%edi),%eax
  800325:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800328:	0f b6 17             	movzbl (%edi),%edx
  80032b:	8d 42 dd             	lea    -0x23(%edx),%eax
  80032e:	3c 55                	cmp    $0x55,%al
  800330:	0f 87 12 04 00 00    	ja     800748 <vprintfmt+0x45b>
  800336:	0f b6 c0             	movzbl %al,%eax
  800339:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  800340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800343:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800347:	eb d9                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800349:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80034c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800350:	eb d0                	jmp    800322 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800352:	0f b6 d2             	movzbl %dl,%edx
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800358:	b8 00 00 00 00       	mov    $0x0,%eax
  80035d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800360:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800363:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800367:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80036a:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80036d:	83 f9 09             	cmp    $0x9,%ecx
  800370:	77 55                	ja     8003c7 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800372:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800375:	eb e9                	jmp    800360 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80037f:	8b 45 14             	mov    0x14(%ebp),%eax
  800382:	8d 40 04             	lea    0x4(%eax),%eax
  800385:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800388:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	79 91                	jns    800322 <vprintfmt+0x35>
				width = precision, precision = -1;
  800391:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800397:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80039e:	eb 82                	jmp    800322 <vprintfmt+0x35>
  8003a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a3:	85 c0                	test   %eax,%eax
  8003a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003aa:	0f 49 d0             	cmovns %eax,%edx
  8003ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 6a ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003bb:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003c2:	e9 5b ff ff ff       	jmp    800322 <vprintfmt+0x35>
  8003c7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003cd:	eb bc                	jmp    80038b <vprintfmt+0x9e>
			lflag++;
  8003cf:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003d5:	e9 48 ff ff ff       	jmp    800322 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	83 ec 08             	sub    $0x8,%esp
  8003e3:	53                   	push   %ebx
  8003e4:	ff 30                	pushl  (%eax)
  8003e6:	ff d6                	call   *%esi
			break;
  8003e8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003eb:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003ee:	e9 cf 02 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  8003f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f6:	8d 78 04             	lea    0x4(%eax),%edi
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	99                   	cltd   
  8003fc:	31 d0                	xor    %edx,%eax
  8003fe:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800400:	83 f8 0f             	cmp    $0xf,%eax
  800403:	7f 23                	jg     800428 <vprintfmt+0x13b>
  800405:	8b 14 85 80 26 80 00 	mov    0x802680(,%eax,4),%edx
  80040c:	85 d2                	test   %edx,%edx
  80040e:	74 18                	je     800428 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800410:	52                   	push   %edx
  800411:	68 dd 27 80 00       	push   $0x8027dd
  800416:	53                   	push   %ebx
  800417:	56                   	push   %esi
  800418:	e8 b3 fe ff ff       	call   8002d0 <printfmt>
  80041d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800420:	89 7d 14             	mov    %edi,0x14(%ebp)
  800423:	e9 9a 02 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  800428:	50                   	push   %eax
  800429:	68 f3 23 80 00       	push   $0x8023f3
  80042e:	53                   	push   %ebx
  80042f:	56                   	push   %esi
  800430:	e8 9b fe ff ff       	call   8002d0 <printfmt>
  800435:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800438:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80043b:	e9 82 02 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800440:	8b 45 14             	mov    0x14(%ebp),%eax
  800443:	83 c0 04             	add    $0x4,%eax
  800446:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800449:	8b 45 14             	mov    0x14(%ebp),%eax
  80044c:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80044e:	85 ff                	test   %edi,%edi
  800450:	b8 ec 23 80 00       	mov    $0x8023ec,%eax
  800455:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80045c:	0f 8e bd 00 00 00    	jle    80051f <vprintfmt+0x232>
  800462:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800466:	75 0e                	jne    800476 <vprintfmt+0x189>
  800468:	89 75 08             	mov    %esi,0x8(%ebp)
  80046b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80046e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800471:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800474:	eb 6d                	jmp    8004e3 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  800476:	83 ec 08             	sub    $0x8,%esp
  800479:	ff 75 d0             	pushl  -0x30(%ebp)
  80047c:	57                   	push   %edi
  80047d:	e8 6e 03 00 00       	call   8007f0 <strnlen>
  800482:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800485:	29 c1                	sub    %eax,%ecx
  800487:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80048a:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80048d:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800491:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800494:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800497:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800499:	eb 0f                	jmp    8004aa <vprintfmt+0x1bd>
					putch(padc, putdat);
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	53                   	push   %ebx
  80049f:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	83 ef 01             	sub    $0x1,%edi
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	85 ff                	test   %edi,%edi
  8004ac:	7f ed                	jg     80049b <vprintfmt+0x1ae>
  8004ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b1:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b4:	85 c9                	test   %ecx,%ecx
  8004b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bb:	0f 49 c1             	cmovns %ecx,%eax
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c6:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004c9:	89 cb                	mov    %ecx,%ebx
  8004cb:	eb 16                	jmp    8004e3 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d1:	75 31                	jne    800504 <vprintfmt+0x217>
					putch(ch, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	50                   	push   %eax
  8004da:	ff 55 08             	call   *0x8(%ebp)
  8004dd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004e0:	83 eb 01             	sub    $0x1,%ebx
  8004e3:	83 c7 01             	add    $0x1,%edi
  8004e6:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  8004ea:	0f be c2             	movsbl %dl,%eax
  8004ed:	85 c0                	test   %eax,%eax
  8004ef:	74 59                	je     80054a <vprintfmt+0x25d>
  8004f1:	85 f6                	test   %esi,%esi
  8004f3:	78 d8                	js     8004cd <vprintfmt+0x1e0>
  8004f5:	83 ee 01             	sub    $0x1,%esi
  8004f8:	79 d3                	jns    8004cd <vprintfmt+0x1e0>
  8004fa:	89 df                	mov    %ebx,%edi
  8004fc:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800502:	eb 37                	jmp    80053b <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  800504:	0f be d2             	movsbl %dl,%edx
  800507:	83 ea 20             	sub    $0x20,%edx
  80050a:	83 fa 5e             	cmp    $0x5e,%edx
  80050d:	76 c4                	jbe    8004d3 <vprintfmt+0x1e6>
					putch('?', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	6a 3f                	push   $0x3f
  800517:	ff 55 08             	call   *0x8(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	eb c1                	jmp    8004e0 <vprintfmt+0x1f3>
  80051f:	89 75 08             	mov    %esi,0x8(%ebp)
  800522:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800525:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800528:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052b:	eb b6                	jmp    8004e3 <vprintfmt+0x1f6>
				putch(' ', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 20                	push   $0x20
  800533:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800535:	83 ef 01             	sub    $0x1,%edi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	85 ff                	test   %edi,%edi
  80053d:	7f ee                	jg     80052d <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  80053f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800542:	89 45 14             	mov    %eax,0x14(%ebp)
  800545:	e9 78 01 00 00       	jmp    8006c2 <vprintfmt+0x3d5>
  80054a:	89 df                	mov    %ebx,%edi
  80054c:	8b 75 08             	mov    0x8(%ebp),%esi
  80054f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800552:	eb e7                	jmp    80053b <vprintfmt+0x24e>
	if (lflag >= 2)
  800554:	83 f9 01             	cmp    $0x1,%ecx
  800557:	7e 3f                	jle    800598 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 50 04             	mov    0x4(%eax),%edx
  80055f:	8b 00                	mov    (%eax),%eax
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 40 08             	lea    0x8(%eax),%eax
  80056d:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800570:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800574:	79 5c                	jns    8005d2 <vprintfmt+0x2e5>
				putch('-', putdat);
  800576:	83 ec 08             	sub    $0x8,%esp
  800579:	53                   	push   %ebx
  80057a:	6a 2d                	push   $0x2d
  80057c:	ff d6                	call   *%esi
				num = -(long long) num;
  80057e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800581:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800584:	f7 da                	neg    %edx
  800586:	83 d1 00             	adc    $0x0,%ecx
  800589:	f7 d9                	neg    %ecx
  80058b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80058e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800593:	e9 10 01 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  800598:	85 c9                	test   %ecx,%ecx
  80059a:	75 1b                	jne    8005b7 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	89 c1                	mov    %eax,%ecx
  8005a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8005af:	8d 40 04             	lea    0x4(%eax),%eax
  8005b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b5:	eb b9                	jmp    800570 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bf:	89 c1                	mov    %eax,%ecx
  8005c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 40 04             	lea    0x4(%eax),%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	eb 9e                	jmp    800570 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 c6 00 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005e2:	83 f9 01             	cmp    $0x1,%ecx
  8005e5:	7e 18                	jle    8005ff <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8b 10                	mov    (%eax),%edx
  8005ec:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ef:	8d 40 08             	lea    0x8(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fa:	e9 a9 00 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  8005ff:	85 c9                	test   %ecx,%ecx
  800601:	75 1a                	jne    80061d <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 10                	mov    (%eax),%edx
  800608:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060d:	8d 40 04             	lea    0x4(%eax),%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
  800618:	e9 8b 00 00 00       	jmp    8006a8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80061d:	8b 45 14             	mov    0x14(%ebp),%eax
  800620:	8b 10                	mov    (%eax),%edx
  800622:	b9 00 00 00 00       	mov    $0x0,%ecx
  800627:	8d 40 04             	lea    0x4(%eax),%eax
  80062a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800632:	eb 74                	jmp    8006a8 <vprintfmt+0x3bb>
	if (lflag >= 2)
  800634:	83 f9 01             	cmp    $0x1,%ecx
  800637:	7e 15                	jle    80064e <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	8b 48 04             	mov    0x4(%eax),%ecx
  800641:	8d 40 08             	lea    0x8(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800647:	b8 08 00 00 00       	mov    $0x8,%eax
  80064c:	eb 5a                	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	75 17                	jne    800669 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800652:	8b 45 14             	mov    0x14(%ebp),%eax
  800655:	8b 10                	mov    (%eax),%edx
  800657:	b9 00 00 00 00       	mov    $0x0,%ecx
  80065c:	8d 40 04             	lea    0x4(%eax),%eax
  80065f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800662:	b8 08 00 00 00       	mov    $0x8,%eax
  800667:	eb 3f                	jmp    8006a8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 10                	mov    (%eax),%edx
  80066e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800673:	8d 40 04             	lea    0x4(%eax),%eax
  800676:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800679:	b8 08 00 00 00       	mov    $0x8,%eax
  80067e:	eb 28                	jmp    8006a8 <vprintfmt+0x3bb>
			putch('0', putdat);
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 30                	push   $0x30
  800686:	ff d6                	call   *%esi
			putch('x', putdat);
  800688:	83 c4 08             	add    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 78                	push   $0x78
  80068e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80069a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80069d:	8d 40 04             	lea    0x4(%eax),%eax
  8006a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a3:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a8:	83 ec 0c             	sub    $0xc,%esp
  8006ab:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006af:	57                   	push   %edi
  8006b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b3:	50                   	push   %eax
  8006b4:	51                   	push   %ecx
  8006b5:	52                   	push   %edx
  8006b6:	89 da                	mov    %ebx,%edx
  8006b8:	89 f0                	mov    %esi,%eax
  8006ba:	e8 45 fb ff ff       	call   800204 <printnum>
			break;
  8006bf:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006c5:	83 c7 01             	add    $0x1,%edi
  8006c8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006cc:	83 f8 25             	cmp    $0x25,%eax
  8006cf:	0f 84 2f fc ff ff    	je     800304 <vprintfmt+0x17>
			if (ch == '\0')
  8006d5:	85 c0                	test   %eax,%eax
  8006d7:	0f 84 8b 00 00 00    	je     800768 <vprintfmt+0x47b>
			putch(ch, putdat);
  8006dd:	83 ec 08             	sub    $0x8,%esp
  8006e0:	53                   	push   %ebx
  8006e1:	50                   	push   %eax
  8006e2:	ff d6                	call   *%esi
  8006e4:	83 c4 10             	add    $0x10,%esp
  8006e7:	eb dc                	jmp    8006c5 <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006e9:	83 f9 01             	cmp    $0x1,%ecx
  8006ec:	7e 15                	jle    800703 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8b 10                	mov    (%eax),%edx
  8006f3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f6:	8d 40 08             	lea    0x8(%eax),%eax
  8006f9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006fc:	b8 10 00 00 00       	mov    $0x10,%eax
  800701:	eb a5                	jmp    8006a8 <vprintfmt+0x3bb>
	else if (lflag)
  800703:	85 c9                	test   %ecx,%ecx
  800705:	75 17                	jne    80071e <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8b 10                	mov    (%eax),%edx
  80070c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800711:	8d 40 04             	lea    0x4(%eax),%eax
  800714:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800717:	b8 10 00 00 00       	mov    $0x10,%eax
  80071c:	eb 8a                	jmp    8006a8 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8b 10                	mov    (%eax),%edx
  800723:	b9 00 00 00 00       	mov    $0x0,%ecx
  800728:	8d 40 04             	lea    0x4(%eax),%eax
  80072b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072e:	b8 10 00 00 00       	mov    $0x10,%eax
  800733:	e9 70 ff ff ff       	jmp    8006a8 <vprintfmt+0x3bb>
			putch(ch, putdat);
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	53                   	push   %ebx
  80073c:	6a 25                	push   $0x25
  80073e:	ff d6                	call   *%esi
			break;
  800740:	83 c4 10             	add    $0x10,%esp
  800743:	e9 7a ff ff ff       	jmp    8006c2 <vprintfmt+0x3d5>
			putch('%', putdat);
  800748:	83 ec 08             	sub    $0x8,%esp
  80074b:	53                   	push   %ebx
  80074c:	6a 25                	push   $0x25
  80074e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800750:	83 c4 10             	add    $0x10,%esp
  800753:	89 f8                	mov    %edi,%eax
  800755:	eb 03                	jmp    80075a <vprintfmt+0x46d>
  800757:	83 e8 01             	sub    $0x1,%eax
  80075a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80075e:	75 f7                	jne    800757 <vprintfmt+0x46a>
  800760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800763:	e9 5a ff ff ff       	jmp    8006c2 <vprintfmt+0x3d5>
}
  800768:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80076b:	5b                   	pop    %ebx
  80076c:	5e                   	pop    %esi
  80076d:	5f                   	pop    %edi
  80076e:	5d                   	pop    %ebp
  80076f:	c3                   	ret    

00800770 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	83 ec 18             	sub    $0x18,%esp
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80077f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800783:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800786:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078d:	85 c0                	test   %eax,%eax
  80078f:	74 26                	je     8007b7 <vsnprintf+0x47>
  800791:	85 d2                	test   %edx,%edx
  800793:	7e 22                	jle    8007b7 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800795:	ff 75 14             	pushl  0x14(%ebp)
  800798:	ff 75 10             	pushl  0x10(%ebp)
  80079b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80079e:	50                   	push   %eax
  80079f:	68 b3 02 80 00       	push   $0x8002b3
  8007a4:	e8 44 fb ff ff       	call   8002ed <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b2:	83 c4 10             	add    $0x10,%esp
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    
		return -E_INVAL;
  8007b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bc:	eb f7                	jmp    8007b5 <vsnprintf+0x45>

008007be <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c4:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c7:	50                   	push   %eax
  8007c8:	ff 75 10             	pushl  0x10(%ebp)
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	ff 75 08             	pushl  0x8(%ebp)
  8007d1:	e8 9a ff ff ff       	call   800770 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    

008007d8 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007de:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e3:	eb 03                	jmp    8007e8 <strlen+0x10>
		n++;
  8007e5:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007e8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007ec:	75 f7                	jne    8007e5 <strlen+0xd>
	return n;
}
  8007ee:	5d                   	pop    %ebp
  8007ef:	c3                   	ret    

008007f0 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fe:	eb 03                	jmp    800803 <strnlen+0x13>
		n++;
  800800:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800803:	39 d0                	cmp    %edx,%eax
  800805:	74 06                	je     80080d <strnlen+0x1d>
  800807:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80080b:	75 f3                	jne    800800 <strnlen+0x10>
	return n;
}
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	53                   	push   %ebx
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800819:	89 c2                	mov    %eax,%edx
  80081b:	83 c1 01             	add    $0x1,%ecx
  80081e:	83 c2 01             	add    $0x1,%edx
  800821:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800825:	88 5a ff             	mov    %bl,-0x1(%edx)
  800828:	84 db                	test   %bl,%bl
  80082a:	75 ef                	jne    80081b <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80082c:	5b                   	pop    %ebx
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	53                   	push   %ebx
  800833:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800836:	53                   	push   %ebx
  800837:	e8 9c ff ff ff       	call   8007d8 <strlen>
  80083c:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	01 d8                	add    %ebx,%eax
  800844:	50                   	push   %eax
  800845:	e8 c5 ff ff ff       	call   80080f <strcpy>
	return dst;
}
  80084a:	89 d8                	mov    %ebx,%eax
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	56                   	push   %esi
  800855:	53                   	push   %ebx
  800856:	8b 75 08             	mov    0x8(%ebp),%esi
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085c:	89 f3                	mov    %esi,%ebx
  80085e:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800861:	89 f2                	mov    %esi,%edx
  800863:	eb 0f                	jmp    800874 <strncpy+0x23>
		*dst++ = *src;
  800865:	83 c2 01             	add    $0x1,%edx
  800868:	0f b6 01             	movzbl (%ecx),%eax
  80086b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80086e:	80 39 01             	cmpb   $0x1,(%ecx)
  800871:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800874:	39 da                	cmp    %ebx,%edx
  800876:	75 ed                	jne    800865 <strncpy+0x14>
	}
	return ret;
}
  800878:	89 f0                	mov    %esi,%eax
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	8b 75 08             	mov    0x8(%ebp),%esi
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
  800889:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80088c:	89 f0                	mov    %esi,%eax
  80088e:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800892:	85 c9                	test   %ecx,%ecx
  800894:	75 0b                	jne    8008a1 <strlcpy+0x23>
  800896:	eb 17                	jmp    8008af <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800898:	83 c2 01             	add    $0x1,%edx
  80089b:	83 c0 01             	add    $0x1,%eax
  80089e:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008a1:	39 d8                	cmp    %ebx,%eax
  8008a3:	74 07                	je     8008ac <strlcpy+0x2e>
  8008a5:	0f b6 0a             	movzbl (%edx),%ecx
  8008a8:	84 c9                	test   %cl,%cl
  8008aa:	75 ec                	jne    800898 <strlcpy+0x1a>
		*dst = '\0';
  8008ac:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008af:	29 f0                	sub    %esi,%eax
}
  8008b1:	5b                   	pop    %ebx
  8008b2:	5e                   	pop    %esi
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008be:	eb 06                	jmp    8008c6 <strcmp+0x11>
		p++, q++;
  8008c0:	83 c1 01             	add    $0x1,%ecx
  8008c3:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008c6:	0f b6 01             	movzbl (%ecx),%eax
  8008c9:	84 c0                	test   %al,%al
  8008cb:	74 04                	je     8008d1 <strcmp+0x1c>
  8008cd:	3a 02                	cmp    (%edx),%al
  8008cf:	74 ef                	je     8008c0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d1:	0f b6 c0             	movzbl %al,%eax
  8008d4:	0f b6 12             	movzbl (%edx),%edx
  8008d7:	29 d0                	sub    %edx,%eax
}
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	53                   	push   %ebx
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	89 c3                	mov    %eax,%ebx
  8008e7:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008ea:	eb 06                	jmp    8008f2 <strncmp+0x17>
		n--, p++, q++;
  8008ec:	83 c0 01             	add    $0x1,%eax
  8008ef:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8008f2:	39 d8                	cmp    %ebx,%eax
  8008f4:	74 16                	je     80090c <strncmp+0x31>
  8008f6:	0f b6 08             	movzbl (%eax),%ecx
  8008f9:	84 c9                	test   %cl,%cl
  8008fb:	74 04                	je     800901 <strncmp+0x26>
  8008fd:	3a 0a                	cmp    (%edx),%cl
  8008ff:	74 eb                	je     8008ec <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800901:	0f b6 00             	movzbl (%eax),%eax
  800904:	0f b6 12             	movzbl (%edx),%edx
  800907:	29 d0                	sub    %edx,%eax
}
  800909:	5b                   	pop    %ebx
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    
		return 0;
  80090c:	b8 00 00 00 00       	mov    $0x0,%eax
  800911:	eb f6                	jmp    800909 <strncmp+0x2e>

00800913 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800913:	55                   	push   %ebp
  800914:	89 e5                	mov    %esp,%ebp
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	84 d2                	test   %dl,%dl
  800922:	74 09                	je     80092d <strchr+0x1a>
		if (*s == c)
  800924:	38 ca                	cmp    %cl,%dl
  800926:	74 0a                	je     800932 <strchr+0x1f>
	for (; *s; s++)
  800928:	83 c0 01             	add    $0x1,%eax
  80092b:	eb f0                	jmp    80091d <strchr+0xa>
			return (char *) s;
	return 0;
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  80093e:	eb 03                	jmp    800943 <strfind+0xf>
  800940:	83 c0 01             	add    $0x1,%eax
  800943:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800946:	38 ca                	cmp    %cl,%dl
  800948:	74 04                	je     80094e <strfind+0x1a>
  80094a:	84 d2                	test   %dl,%dl
  80094c:	75 f2                	jne    800940 <strfind+0xc>
			break;
	return (char *) s;
}
  80094e:	5d                   	pop    %ebp
  80094f:	c3                   	ret    

00800950 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	57                   	push   %edi
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
  800956:	8b 7d 08             	mov    0x8(%ebp),%edi
  800959:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80095c:	85 c9                	test   %ecx,%ecx
  80095e:	74 13                	je     800973 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800960:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800966:	75 05                	jne    80096d <memset+0x1d>
  800968:	f6 c1 03             	test   $0x3,%cl
  80096b:	74 0d                	je     80097a <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80096d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800970:	fc                   	cld    
  800971:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800973:	89 f8                	mov    %edi,%eax
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5f                   	pop    %edi
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    
		c &= 0xFF;
  80097a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80097e:	89 d3                	mov    %edx,%ebx
  800980:	c1 e3 08             	shl    $0x8,%ebx
  800983:	89 d0                	mov    %edx,%eax
  800985:	c1 e0 18             	shl    $0x18,%eax
  800988:	89 d6                	mov    %edx,%esi
  80098a:	c1 e6 10             	shl    $0x10,%esi
  80098d:	09 f0                	or     %esi,%eax
  80098f:	09 c2                	or     %eax,%edx
  800991:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800993:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800996:	89 d0                	mov    %edx,%eax
  800998:	fc                   	cld    
  800999:	f3 ab                	rep stos %eax,%es:(%edi)
  80099b:	eb d6                	jmp    800973 <memset+0x23>

0080099d <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	57                   	push   %edi
  8009a1:	56                   	push   %esi
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009ab:	39 c6                	cmp    %eax,%esi
  8009ad:	73 35                	jae    8009e4 <memmove+0x47>
  8009af:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009b2:	39 c2                	cmp    %eax,%edx
  8009b4:	76 2e                	jbe    8009e4 <memmove+0x47>
		s += n;
		d += n;
  8009b6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b9:	89 d6                	mov    %edx,%esi
  8009bb:	09 fe                	or     %edi,%esi
  8009bd:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009c3:	74 0c                	je     8009d1 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009c5:	83 ef 01             	sub    $0x1,%edi
  8009c8:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009cb:	fd                   	std    
  8009cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009ce:	fc                   	cld    
  8009cf:	eb 21                	jmp    8009f2 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d1:	f6 c1 03             	test   $0x3,%cl
  8009d4:	75 ef                	jne    8009c5 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d6:	83 ef 04             	sub    $0x4,%edi
  8009d9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009dc:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009df:	fd                   	std    
  8009e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e2:	eb ea                	jmp    8009ce <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	89 f2                	mov    %esi,%edx
  8009e6:	09 c2                	or     %eax,%edx
  8009e8:	f6 c2 03             	test   $0x3,%dl
  8009eb:	74 09                	je     8009f6 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ed:	89 c7                	mov    %eax,%edi
  8009ef:	fc                   	cld    
  8009f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f2:	5e                   	pop    %esi
  8009f3:	5f                   	pop    %edi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f6:	f6 c1 03             	test   $0x3,%cl
  8009f9:	75 f2                	jne    8009ed <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009fb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009fe:	89 c7                	mov    %eax,%edi
  800a00:	fc                   	cld    
  800a01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a03:	eb ed                	jmp    8009f2 <memmove+0x55>

00800a05 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a08:	ff 75 10             	pushl  0x10(%ebp)
  800a0b:	ff 75 0c             	pushl  0xc(%ebp)
  800a0e:	ff 75 08             	pushl  0x8(%ebp)
  800a11:	e8 87 ff ff ff       	call   80099d <memmove>
}
  800a16:	c9                   	leave  
  800a17:	c3                   	ret    

00800a18 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a23:	89 c6                	mov    %eax,%esi
  800a25:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a28:	39 f0                	cmp    %esi,%eax
  800a2a:	74 1c                	je     800a48 <memcmp+0x30>
		if (*s1 != *s2)
  800a2c:	0f b6 08             	movzbl (%eax),%ecx
  800a2f:	0f b6 1a             	movzbl (%edx),%ebx
  800a32:	38 d9                	cmp    %bl,%cl
  800a34:	75 08                	jne    800a3e <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	83 c2 01             	add    $0x1,%edx
  800a3c:	eb ea                	jmp    800a28 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a3e:	0f b6 c1             	movzbl %cl,%eax
  800a41:	0f b6 db             	movzbl %bl,%ebx
  800a44:	29 d8                	sub    %ebx,%eax
  800a46:	eb 05                	jmp    800a4d <memcmp+0x35>
	}

	return 0;
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4d:	5b                   	pop    %ebx
  800a4e:	5e                   	pop    %esi
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5a:	89 c2                	mov    %eax,%edx
  800a5c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a5f:	39 d0                	cmp    %edx,%eax
  800a61:	73 09                	jae    800a6c <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a63:	38 08                	cmp    %cl,(%eax)
  800a65:	74 05                	je     800a6c <memfind+0x1b>
	for (; s < ends; s++)
  800a67:	83 c0 01             	add    $0x1,%eax
  800a6a:	eb f3                	jmp    800a5f <memfind+0xe>
			break;
	return (void *) s;
}
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	57                   	push   %edi
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a77:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7a:	eb 03                	jmp    800a7f <strtol+0x11>
		s++;
  800a7c:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a7f:	0f b6 01             	movzbl (%ecx),%eax
  800a82:	3c 20                	cmp    $0x20,%al
  800a84:	74 f6                	je     800a7c <strtol+0xe>
  800a86:	3c 09                	cmp    $0x9,%al
  800a88:	74 f2                	je     800a7c <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800a8a:	3c 2b                	cmp    $0x2b,%al
  800a8c:	74 2e                	je     800abc <strtol+0x4e>
	int neg = 0;
  800a8e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800a93:	3c 2d                	cmp    $0x2d,%al
  800a95:	74 2f                	je     800ac6 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a97:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a9d:	75 05                	jne    800aa4 <strtol+0x36>
  800a9f:	80 39 30             	cmpb   $0x30,(%ecx)
  800aa2:	74 2c                	je     800ad0 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa4:	85 db                	test   %ebx,%ebx
  800aa6:	75 0a                	jne    800ab2 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa8:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800aad:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab0:	74 28                	je     800ada <strtol+0x6c>
		base = 10;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab7:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800aba:	eb 50                	jmp    800b0c <strtol+0x9e>
		s++;
  800abc:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800abf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ac4:	eb d1                	jmp    800a97 <strtol+0x29>
		s++, neg = 1;
  800ac6:	83 c1 01             	add    $0x1,%ecx
  800ac9:	bf 01 00 00 00       	mov    $0x1,%edi
  800ace:	eb c7                	jmp    800a97 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ad4:	74 0e                	je     800ae4 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800ad6:	85 db                	test   %ebx,%ebx
  800ad8:	75 d8                	jne    800ab2 <strtol+0x44>
		s++, base = 8;
  800ada:	83 c1 01             	add    $0x1,%ecx
  800add:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ae2:	eb ce                	jmp    800ab2 <strtol+0x44>
		s += 2, base = 16;
  800ae4:	83 c1 02             	add    $0x2,%ecx
  800ae7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800aec:	eb c4                	jmp    800ab2 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800aee:	8d 72 9f             	lea    -0x61(%edx),%esi
  800af1:	89 f3                	mov    %esi,%ebx
  800af3:	80 fb 19             	cmp    $0x19,%bl
  800af6:	77 29                	ja     800b21 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800af8:	0f be d2             	movsbl %dl,%edx
  800afb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800afe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b01:	7d 30                	jge    800b33 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b03:	83 c1 01             	add    $0x1,%ecx
  800b06:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b0a:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b0c:	0f b6 11             	movzbl (%ecx),%edx
  800b0f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b12:	89 f3                	mov    %esi,%ebx
  800b14:	80 fb 09             	cmp    $0x9,%bl
  800b17:	77 d5                	ja     800aee <strtol+0x80>
			dig = *s - '0';
  800b19:	0f be d2             	movsbl %dl,%edx
  800b1c:	83 ea 30             	sub    $0x30,%edx
  800b1f:	eb dd                	jmp    800afe <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b21:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b24:	89 f3                	mov    %esi,%ebx
  800b26:	80 fb 19             	cmp    $0x19,%bl
  800b29:	77 08                	ja     800b33 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b2b:	0f be d2             	movsbl %dl,%edx
  800b2e:	83 ea 37             	sub    $0x37,%edx
  800b31:	eb cb                	jmp    800afe <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b37:	74 05                	je     800b3e <strtol+0xd0>
		*endptr = (char *) s;
  800b39:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	f7 da                	neg    %edx
  800b42:	85 ff                	test   %edi,%edi
  800b44:	0f 45 c2             	cmovne %edx,%eax
}
  800b47:	5b                   	pop    %ebx
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	57                   	push   %edi
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
  800b57:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5d:	89 c3                	mov    %eax,%ebx
  800b5f:	89 c7                	mov    %eax,%edi
  800b61:	89 c6                	mov    %eax,%esi
  800b63:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5f                   	pop    %edi
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <sys_cgetc>:

int
sys_cgetc(void)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	57                   	push   %edi
  800b6e:	56                   	push   %esi
  800b6f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b70:	ba 00 00 00 00       	mov    $0x0,%edx
  800b75:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7a:	89 d1                	mov    %edx,%ecx
  800b7c:	89 d3                	mov    %edx,%ebx
  800b7e:	89 d7                	mov    %edx,%edi
  800b80:	89 d6                	mov    %edx,%esi
  800b82:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b84:	5b                   	pop    %ebx
  800b85:	5e                   	pop    %esi
  800b86:	5f                   	pop    %edi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	57                   	push   %edi
  800b8d:	56                   	push   %esi
  800b8e:	53                   	push   %ebx
  800b8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b97:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9f:	89 cb                	mov    %ecx,%ebx
  800ba1:	89 cf                	mov    %ecx,%edi
  800ba3:	89 ce                	mov    %ecx,%esi
  800ba5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba7:	85 c0                	test   %eax,%eax
  800ba9:	7f 08                	jg     800bb3 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb3:	83 ec 0c             	sub    $0xc,%esp
  800bb6:	50                   	push   %eax
  800bb7:	6a 03                	push   $0x3
  800bb9:	68 df 26 80 00       	push   $0x8026df
  800bbe:	6a 23                	push   $0x23
  800bc0:	68 fc 26 80 00       	push   $0x8026fc
  800bc5:	e8 4b f5 ff ff       	call   800115 <_panic>

00800bca <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	57                   	push   %edi
  800bce:	56                   	push   %esi
  800bcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 02 00 00 00       	mov    $0x2,%eax
  800bda:	89 d1                	mov    %edx,%ecx
  800bdc:	89 d3                	mov    %edx,%ebx
  800bde:	89 d7                	mov    %edx,%edi
  800be0:	89 d6                	mov    %edx,%esi
  800be2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5f                   	pop    %edi
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <sys_yield>:

void
sys_yield(void)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	57                   	push   %edi
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bef:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf9:	89 d1                	mov    %edx,%ecx
  800bfb:	89 d3                	mov    %edx,%ebx
  800bfd:	89 d7                	mov    %edx,%edi
  800bff:	89 d6                	mov    %edx,%esi
  800c01:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	57                   	push   %edi
  800c0c:	56                   	push   %esi
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c11:	be 00 00 00 00       	mov    $0x0,%esi
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1c:	b8 04 00 00 00       	mov    $0x4,%eax
  800c21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c24:	89 f7                	mov    %esi,%edi
  800c26:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	7f 08                	jg     800c34 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c34:	83 ec 0c             	sub    $0xc,%esp
  800c37:	50                   	push   %eax
  800c38:	6a 04                	push   $0x4
  800c3a:	68 df 26 80 00       	push   $0x8026df
  800c3f:	6a 23                	push   $0x23
  800c41:	68 fc 26 80 00       	push   $0x8026fc
  800c46:	e8 ca f4 ff ff       	call   800115 <_panic>

00800c4b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5a:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c62:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c65:	8b 75 18             	mov    0x18(%ebp),%esi
  800c68:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7f 08                	jg     800c76 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c76:	83 ec 0c             	sub    $0xc,%esp
  800c79:	50                   	push   %eax
  800c7a:	6a 05                	push   $0x5
  800c7c:	68 df 26 80 00       	push   $0x8026df
  800c81:	6a 23                	push   $0x23
  800c83:	68 fc 26 80 00       	push   $0x8026fc
  800c88:	e8 88 f4 ff ff       	call   800115 <_panic>

00800c8d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
  800c93:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca1:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7f 08                	jg     800cb8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5e                   	pop    %esi
  800cb5:	5f                   	pop    %edi
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb8:	83 ec 0c             	sub    $0xc,%esp
  800cbb:	50                   	push   %eax
  800cbc:	6a 06                	push   $0x6
  800cbe:	68 df 26 80 00       	push   $0x8026df
  800cc3:	6a 23                	push   $0x23
  800cc5:	68 fc 26 80 00       	push   $0x8026fc
  800cca:	e8 46 f4 ff ff       	call   800115 <_panic>

00800ccf <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce8:	89 df                	mov    %ebx,%edi
  800cea:	89 de                	mov    %ebx,%esi
  800cec:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7f 08                	jg     800cfa <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	83 ec 0c             	sub    $0xc,%esp
  800cfd:	50                   	push   %eax
  800cfe:	6a 08                	push   $0x8
  800d00:	68 df 26 80 00       	push   $0x8026df
  800d05:	6a 23                	push   $0x23
  800d07:	68 fc 26 80 00       	push   $0x8026fc
  800d0c:	e8 04 f4 ff ff       	call   800115 <_panic>

00800d11 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2a:	89 df                	mov    %ebx,%edi
  800d2c:	89 de                	mov    %ebx,%esi
  800d2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7f 08                	jg     800d3c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d37:	5b                   	pop    %ebx
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3c:	83 ec 0c             	sub    $0xc,%esp
  800d3f:	50                   	push   %eax
  800d40:	6a 09                	push   $0x9
  800d42:	68 df 26 80 00       	push   $0x8026df
  800d47:	6a 23                	push   $0x23
  800d49:	68 fc 26 80 00       	push   $0x8026fc
  800d4e:	e8 c2 f3 ff ff       	call   800115 <_panic>

00800d53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	89 de                	mov    %ebx,%esi
  800d70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7f 08                	jg     800d7e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d79:	5b                   	pop    %ebx
  800d7a:	5e                   	pop    %esi
  800d7b:	5f                   	pop    %edi
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7e:	83 ec 0c             	sub    $0xc,%esp
  800d81:	50                   	push   %eax
  800d82:	6a 0a                	push   $0xa
  800d84:	68 df 26 80 00       	push   $0x8026df
  800d89:	6a 23                	push   $0x23
  800d8b:	68 fc 26 80 00       	push   $0x8026fc
  800d90:	e8 80 f3 ff ff       	call   800115 <_panic>

00800d95 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da6:	be 00 00 00 00       	mov    $0x0,%esi
  800dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db3:	5b                   	pop    %ebx
  800db4:	5e                   	pop    %esi
  800db5:	5f                   	pop    %edi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
  800dbe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dce:	89 cb                	mov    %ecx,%ebx
  800dd0:	89 cf                	mov    %ecx,%edi
  800dd2:	89 ce                	mov    %ecx,%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 0d                	push   $0xd
  800de8:	68 df 26 80 00       	push   $0x8026df
  800ded:	6a 23                	push   $0x23
  800def:	68 fc 26 80 00       	push   $0x8026fc
  800df4:	e8 1c f3 ff ff       	call   800115 <_panic>

00800df9 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dff:	ba 00 00 00 00       	mov    $0x0,%edx
  800e04:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e09:	89 d1                	mov    %edx,%ecx
  800e0b:	89 d3                	mov    %edx,%ebx
  800e0d:	89 d7                	mov    %edx,%edi
  800e0f:	89 d6                	mov    %edx,%esi
  800e11:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e13:	5b                   	pop    %ebx
  800e14:	5e                   	pop    %esi
  800e15:	5f                   	pop    %edi
  800e16:	5d                   	pop    %ebp
  800e17:	c3                   	ret    

00800e18 <set_pgfault_handler>:
// allocate an exception stack (one page of memory with its top
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0)
  800e1e:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800e25:	74 0a                	je     800e31 <set_pgfault_handler+0x19>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800e2f:	c9                   	leave  
  800e30:	c3                   	ret    
		if ((r = sys_page_alloc(thisenv->env_id,
  800e31:	a1 08 40 80 00       	mov    0x804008,%eax
  800e36:	8b 40 48             	mov    0x48(%eax),%eax
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	6a 07                	push   $0x7
  800e3e:	68 00 f0 bf ee       	push   $0xeebff000
  800e43:	50                   	push   %eax
  800e44:	e8 bf fd ff ff       	call   800c08 <sys_page_alloc>
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	78 1b                	js     800e6b <set_pgfault_handler+0x53>
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800e50:	a1 08 40 80 00       	mov    0x804008,%eax
  800e55:	8b 40 48             	mov    0x48(%eax),%eax
  800e58:	83 ec 08             	sub    $0x8,%esp
  800e5b:	68 7d 0e 80 00       	push   $0x800e7d
  800e60:	50                   	push   %eax
  800e61:	e8 ed fe ff ff       	call   800d53 <sys_env_set_pgfault_upcall>
  800e66:	83 c4 10             	add    $0x10,%esp
  800e69:	eb bc                	jmp    800e27 <set_pgfault_handler+0xf>
			panic("set_pgfault_handler: %e", r);
  800e6b:	50                   	push   %eax
  800e6c:	68 0a 27 80 00       	push   $0x80270a
  800e71:	6a 22                	push   $0x22
  800e73:	68 22 27 80 00       	push   $0x802722
  800e78:	e8 98 f2 ff ff       	call   800115 <_panic>

00800e7d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e7d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e7e:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800e83:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e85:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp),%eax	//取出栈中的trap-time esp
  800e88:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $4,%eax		// 并减4 再放入%ebp中
  800e8c:	83 e8 04             	sub    $0x4,%eax
	movl %eax,48(%esp)	//再存回%esp中
  800e8f:	89 44 24 30          	mov    %eax,0x30(%esp)
	movl 40(%esp),%ebx
  800e93:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl %ebx,(%eax)
  800e97:	89 18                	mov    %ebx,(%eax)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $8,%esp
  800e99:	83 c4 08             	add    $0x8,%esp
	popal
  800e9c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $4,%esp
  800e9d:	83 c4 04             	add    $0x4,%esp
	popfl
  800ea0:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800ea1:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800ea2:	c3                   	ret    

00800ea3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	05 00 00 00 30       	add    $0x30000000,%eax
  800eae:	c1 e8 0c             	shr    $0xc,%eax
}
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ed0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ed5:	89 c2                	mov    %eax,%edx
  800ed7:	c1 ea 16             	shr    $0x16,%edx
  800eda:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ee1:	f6 c2 01             	test   $0x1,%dl
  800ee4:	74 2a                	je     800f10 <fd_alloc+0x46>
  800ee6:	89 c2                	mov    %eax,%edx
  800ee8:	c1 ea 0c             	shr    $0xc,%edx
  800eeb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ef2:	f6 c2 01             	test   $0x1,%dl
  800ef5:	74 19                	je     800f10 <fd_alloc+0x46>
  800ef7:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800efc:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f01:	75 d2                	jne    800ed5 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f03:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f09:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f0e:	eb 07                	jmp    800f17 <fd_alloc+0x4d>
			*fd_store = fd;
  800f10:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f1f:	83 f8 1f             	cmp    $0x1f,%eax
  800f22:	77 36                	ja     800f5a <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f24:	c1 e0 0c             	shl    $0xc,%eax
  800f27:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f2c:	89 c2                	mov    %eax,%edx
  800f2e:	c1 ea 16             	shr    $0x16,%edx
  800f31:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f38:	f6 c2 01             	test   $0x1,%dl
  800f3b:	74 24                	je     800f61 <fd_lookup+0x48>
  800f3d:	89 c2                	mov    %eax,%edx
  800f3f:	c1 ea 0c             	shr    $0xc,%edx
  800f42:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f49:	f6 c2 01             	test   $0x1,%dl
  800f4c:	74 1a                	je     800f68 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f51:	89 02                	mov    %eax,(%edx)
	return 0;
  800f53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    
		return -E_INVAL;
  800f5a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f5f:	eb f7                	jmp    800f58 <fd_lookup+0x3f>
		return -E_INVAL;
  800f61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f66:	eb f0                	jmp    800f58 <fd_lookup+0x3f>
  800f68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f6d:	eb e9                	jmp    800f58 <fd_lookup+0x3f>

00800f6f <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 08             	sub    $0x8,%esp
  800f75:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f78:	ba b0 27 80 00       	mov    $0x8027b0,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f7d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f82:	39 08                	cmp    %ecx,(%eax)
  800f84:	74 33                	je     800fb9 <dev_lookup+0x4a>
  800f86:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f89:	8b 02                	mov    (%edx),%eax
  800f8b:	85 c0                	test   %eax,%eax
  800f8d:	75 f3                	jne    800f82 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f8f:	a1 08 40 80 00       	mov    0x804008,%eax
  800f94:	8b 40 48             	mov    0x48(%eax),%eax
  800f97:	83 ec 04             	sub    $0x4,%esp
  800f9a:	51                   	push   %ecx
  800f9b:	50                   	push   %eax
  800f9c:	68 30 27 80 00       	push   $0x802730
  800fa1:	e8 4a f2 ff ff       	call   8001f0 <cprintf>
	*dev = 0;
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800faf:	83 c4 10             	add    $0x10,%esp
  800fb2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    
			*dev = devtab[i];
  800fb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbc:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc3:	eb f2                	jmp    800fb7 <dev_lookup+0x48>

00800fc5 <fd_close>:
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	57                   	push   %edi
  800fc9:	56                   	push   %esi
  800fca:	53                   	push   %ebx
  800fcb:	83 ec 1c             	sub    $0x1c,%esp
  800fce:	8b 75 08             	mov    0x8(%ebp),%esi
  800fd1:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fd4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fd7:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd8:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fde:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fe1:	50                   	push   %eax
  800fe2:	e8 32 ff ff ff       	call   800f19 <fd_lookup>
  800fe7:	89 c3                	mov    %eax,%ebx
  800fe9:	83 c4 08             	add    $0x8,%esp
  800fec:	85 c0                	test   %eax,%eax
  800fee:	78 05                	js     800ff5 <fd_close+0x30>
	    || fd != fd2)
  800ff0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  800ff3:	74 16                	je     80100b <fd_close+0x46>
		return (must_exist ? r : 0);
  800ff5:	89 f8                	mov    %edi,%eax
  800ff7:	84 c0                	test   %al,%al
  800ff9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffe:	0f 44 d8             	cmove  %eax,%ebx
}
  801001:	89 d8                	mov    %ebx,%eax
  801003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80100b:	83 ec 08             	sub    $0x8,%esp
  80100e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801011:	50                   	push   %eax
  801012:	ff 36                	pushl  (%esi)
  801014:	e8 56 ff ff ff       	call   800f6f <dev_lookup>
  801019:	89 c3                	mov    %eax,%ebx
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	85 c0                	test   %eax,%eax
  801020:	78 15                	js     801037 <fd_close+0x72>
		if (dev->dev_close)
  801022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801025:	8b 40 10             	mov    0x10(%eax),%eax
  801028:	85 c0                	test   %eax,%eax
  80102a:	74 1b                	je     801047 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	56                   	push   %esi
  801030:	ff d0                	call   *%eax
  801032:	89 c3                	mov    %eax,%ebx
  801034:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	56                   	push   %esi
  80103b:	6a 00                	push   $0x0
  80103d:	e8 4b fc ff ff       	call   800c8d <sys_page_unmap>
	return r;
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	eb ba                	jmp    801001 <fd_close+0x3c>
			r = 0;
  801047:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104c:	eb e9                	jmp    801037 <fd_close+0x72>

0080104e <close>:

int
close(int fdnum)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801054:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801057:	50                   	push   %eax
  801058:	ff 75 08             	pushl  0x8(%ebp)
  80105b:	e8 b9 fe ff ff       	call   800f19 <fd_lookup>
  801060:	83 c4 08             	add    $0x8,%esp
  801063:	85 c0                	test   %eax,%eax
  801065:	78 10                	js     801077 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	6a 01                	push   $0x1
  80106c:	ff 75 f4             	pushl  -0xc(%ebp)
  80106f:	e8 51 ff ff ff       	call   800fc5 <fd_close>
  801074:	83 c4 10             	add    $0x10,%esp
}
  801077:	c9                   	leave  
  801078:	c3                   	ret    

00801079 <close_all>:

void
close_all(void)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	53                   	push   %ebx
  80107d:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801080:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801085:	83 ec 0c             	sub    $0xc,%esp
  801088:	53                   	push   %ebx
  801089:	e8 c0 ff ff ff       	call   80104e <close>
	for (i = 0; i < MAXFD; i++)
  80108e:	83 c3 01             	add    $0x1,%ebx
  801091:	83 c4 10             	add    $0x10,%esp
  801094:	83 fb 20             	cmp    $0x20,%ebx
  801097:	75 ec                	jne    801085 <close_all+0xc>
}
  801099:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	57                   	push   %edi
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010aa:	50                   	push   %eax
  8010ab:	ff 75 08             	pushl  0x8(%ebp)
  8010ae:	e8 66 fe ff ff       	call   800f19 <fd_lookup>
  8010b3:	89 c3                	mov    %eax,%ebx
  8010b5:	83 c4 08             	add    $0x8,%esp
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	0f 88 81 00 00 00    	js     801141 <dup+0xa3>
		return r;
	close(newfdnum);
  8010c0:	83 ec 0c             	sub    $0xc,%esp
  8010c3:	ff 75 0c             	pushl  0xc(%ebp)
  8010c6:	e8 83 ff ff ff       	call   80104e <close>

	newfd = INDEX2FD(newfdnum);
  8010cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010ce:	c1 e6 0c             	shl    $0xc,%esi
  8010d1:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010d7:	83 c4 04             	add    $0x4,%esp
  8010da:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010dd:	e8 d1 fd ff ff       	call   800eb3 <fd2data>
  8010e2:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010e4:	89 34 24             	mov    %esi,(%esp)
  8010e7:	e8 c7 fd ff ff       	call   800eb3 <fd2data>
  8010ec:	83 c4 10             	add    $0x10,%esp
  8010ef:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010f1:	89 d8                	mov    %ebx,%eax
  8010f3:	c1 e8 16             	shr    $0x16,%eax
  8010f6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010fd:	a8 01                	test   $0x1,%al
  8010ff:	74 11                	je     801112 <dup+0x74>
  801101:	89 d8                	mov    %ebx,%eax
  801103:	c1 e8 0c             	shr    $0xc,%eax
  801106:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80110d:	f6 c2 01             	test   $0x1,%dl
  801110:	75 39                	jne    80114b <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801112:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801115:	89 d0                	mov    %edx,%eax
  801117:	c1 e8 0c             	shr    $0xc,%eax
  80111a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801121:	83 ec 0c             	sub    $0xc,%esp
  801124:	25 07 0e 00 00       	and    $0xe07,%eax
  801129:	50                   	push   %eax
  80112a:	56                   	push   %esi
  80112b:	6a 00                	push   $0x0
  80112d:	52                   	push   %edx
  80112e:	6a 00                	push   $0x0
  801130:	e8 16 fb ff ff       	call   800c4b <sys_page_map>
  801135:	89 c3                	mov    %eax,%ebx
  801137:	83 c4 20             	add    $0x20,%esp
  80113a:	85 c0                	test   %eax,%eax
  80113c:	78 31                	js     80116f <dup+0xd1>
		goto err;

	return newfdnum;
  80113e:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801141:	89 d8                	mov    %ebx,%eax
  801143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80114b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801152:	83 ec 0c             	sub    $0xc,%esp
  801155:	25 07 0e 00 00       	and    $0xe07,%eax
  80115a:	50                   	push   %eax
  80115b:	57                   	push   %edi
  80115c:	6a 00                	push   $0x0
  80115e:	53                   	push   %ebx
  80115f:	6a 00                	push   $0x0
  801161:	e8 e5 fa ff ff       	call   800c4b <sys_page_map>
  801166:	89 c3                	mov    %eax,%ebx
  801168:	83 c4 20             	add    $0x20,%esp
  80116b:	85 c0                	test   %eax,%eax
  80116d:	79 a3                	jns    801112 <dup+0x74>
	sys_page_unmap(0, newfd);
  80116f:	83 ec 08             	sub    $0x8,%esp
  801172:	56                   	push   %esi
  801173:	6a 00                	push   $0x0
  801175:	e8 13 fb ff ff       	call   800c8d <sys_page_unmap>
	sys_page_unmap(0, nva);
  80117a:	83 c4 08             	add    $0x8,%esp
  80117d:	57                   	push   %edi
  80117e:	6a 00                	push   $0x0
  801180:	e8 08 fb ff ff       	call   800c8d <sys_page_unmap>
	return r;
  801185:	83 c4 10             	add    $0x10,%esp
  801188:	eb b7                	jmp    801141 <dup+0xa3>

0080118a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	53                   	push   %ebx
  80118e:	83 ec 14             	sub    $0x14,%esp
  801191:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801194:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801197:	50                   	push   %eax
  801198:	53                   	push   %ebx
  801199:	e8 7b fd ff ff       	call   800f19 <fd_lookup>
  80119e:	83 c4 08             	add    $0x8,%esp
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	78 3f                	js     8011e4 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011a5:	83 ec 08             	sub    $0x8,%esp
  8011a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ab:	50                   	push   %eax
  8011ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011af:	ff 30                	pushl  (%eax)
  8011b1:	e8 b9 fd ff ff       	call   800f6f <dev_lookup>
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 27                	js     8011e4 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c0:	8b 42 08             	mov    0x8(%edx),%eax
  8011c3:	83 e0 03             	and    $0x3,%eax
  8011c6:	83 f8 01             	cmp    $0x1,%eax
  8011c9:	74 1e                	je     8011e9 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ce:	8b 40 08             	mov    0x8(%eax),%eax
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	74 35                	je     80120a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	ff 75 10             	pushl  0x10(%ebp)
  8011db:	ff 75 0c             	pushl  0xc(%ebp)
  8011de:	52                   	push   %edx
  8011df:	ff d0                	call   *%eax
  8011e1:	83 c4 10             	add    $0x10,%esp
}
  8011e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8011ee:	8b 40 48             	mov    0x48(%eax),%eax
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	53                   	push   %ebx
  8011f5:	50                   	push   %eax
  8011f6:	68 74 27 80 00       	push   $0x802774
  8011fb:	e8 f0 ef ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801200:	83 c4 10             	add    $0x10,%esp
  801203:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801208:	eb da                	jmp    8011e4 <read+0x5a>
		return -E_NOT_SUPP;
  80120a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80120f:	eb d3                	jmp    8011e4 <read+0x5a>

00801211 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	57                   	push   %edi
  801215:	56                   	push   %esi
  801216:	53                   	push   %ebx
  801217:	83 ec 0c             	sub    $0xc,%esp
  80121a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80121d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801220:	bb 00 00 00 00       	mov    $0x0,%ebx
  801225:	39 f3                	cmp    %esi,%ebx
  801227:	73 25                	jae    80124e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801229:	83 ec 04             	sub    $0x4,%esp
  80122c:	89 f0                	mov    %esi,%eax
  80122e:	29 d8                	sub    %ebx,%eax
  801230:	50                   	push   %eax
  801231:	89 d8                	mov    %ebx,%eax
  801233:	03 45 0c             	add    0xc(%ebp),%eax
  801236:	50                   	push   %eax
  801237:	57                   	push   %edi
  801238:	e8 4d ff ff ff       	call   80118a <read>
		if (m < 0)
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	85 c0                	test   %eax,%eax
  801242:	78 08                	js     80124c <readn+0x3b>
			return m;
		if (m == 0)
  801244:	85 c0                	test   %eax,%eax
  801246:	74 06                	je     80124e <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801248:	01 c3                	add    %eax,%ebx
  80124a:	eb d9                	jmp    801225 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80124c:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80124e:	89 d8                	mov    %ebx,%eax
  801250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5f                   	pop    %edi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	53                   	push   %ebx
  80125c:	83 ec 14             	sub    $0x14,%esp
  80125f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801262:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801265:	50                   	push   %eax
  801266:	53                   	push   %ebx
  801267:	e8 ad fc ff ff       	call   800f19 <fd_lookup>
  80126c:	83 c4 08             	add    $0x8,%esp
  80126f:	85 c0                	test   %eax,%eax
  801271:	78 3a                	js     8012ad <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801273:	83 ec 08             	sub    $0x8,%esp
  801276:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801279:	50                   	push   %eax
  80127a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80127d:	ff 30                	pushl  (%eax)
  80127f:	e8 eb fc ff ff       	call   800f6f <dev_lookup>
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	78 22                	js     8012ad <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801292:	74 1e                	je     8012b2 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801297:	8b 52 0c             	mov    0xc(%edx),%edx
  80129a:	85 d2                	test   %edx,%edx
  80129c:	74 35                	je     8012d3 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80129e:	83 ec 04             	sub    $0x4,%esp
  8012a1:	ff 75 10             	pushl  0x10(%ebp)
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	ff d2                	call   *%edx
  8012aa:	83 c4 10             	add    $0x10,%esp
}
  8012ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8012b7:	8b 40 48             	mov    0x48(%eax),%eax
  8012ba:	83 ec 04             	sub    $0x4,%esp
  8012bd:	53                   	push   %ebx
  8012be:	50                   	push   %eax
  8012bf:	68 90 27 80 00       	push   $0x802790
  8012c4:	e8 27 ef ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012d1:	eb da                	jmp    8012ad <write+0x55>
		return -E_NOT_SUPP;
  8012d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012d8:	eb d3                	jmp    8012ad <write+0x55>

008012da <seek>:

int
seek(int fdnum, off_t offset)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012e0:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012e3:	50                   	push   %eax
  8012e4:	ff 75 08             	pushl  0x8(%ebp)
  8012e7:	e8 2d fc ff ff       	call   800f19 <fd_lookup>
  8012ec:	83 c4 08             	add    $0x8,%esp
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	78 0e                	js     801301 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f9:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	53                   	push   %ebx
  801307:	83 ec 14             	sub    $0x14,%esp
  80130a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80130d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801310:	50                   	push   %eax
  801311:	53                   	push   %ebx
  801312:	e8 02 fc ff ff       	call   800f19 <fd_lookup>
  801317:	83 c4 08             	add    $0x8,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 37                	js     801355 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801324:	50                   	push   %eax
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	ff 30                	pushl  (%eax)
  80132a:	e8 40 fc ff ff       	call   800f6f <dev_lookup>
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	78 1f                	js     801355 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801339:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80133d:	74 1b                	je     80135a <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80133f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801342:	8b 52 18             	mov    0x18(%edx),%edx
  801345:	85 d2                	test   %edx,%edx
  801347:	74 32                	je     80137b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801349:	83 ec 08             	sub    $0x8,%esp
  80134c:	ff 75 0c             	pushl  0xc(%ebp)
  80134f:	50                   	push   %eax
  801350:	ff d2                	call   *%edx
  801352:	83 c4 10             	add    $0x10,%esp
}
  801355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801358:	c9                   	leave  
  801359:	c3                   	ret    
			thisenv->env_id, fdnum);
  80135a:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80135f:	8b 40 48             	mov    0x48(%eax),%eax
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	53                   	push   %ebx
  801366:	50                   	push   %eax
  801367:	68 50 27 80 00       	push   $0x802750
  80136c:	e8 7f ee ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801379:	eb da                	jmp    801355 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80137b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801380:	eb d3                	jmp    801355 <ftruncate+0x52>

00801382 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	53                   	push   %ebx
  801386:	83 ec 14             	sub    $0x14,%esp
  801389:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80138f:	50                   	push   %eax
  801390:	ff 75 08             	pushl  0x8(%ebp)
  801393:	e8 81 fb ff ff       	call   800f19 <fd_lookup>
  801398:	83 c4 08             	add    $0x8,%esp
  80139b:	85 c0                	test   %eax,%eax
  80139d:	78 4b                	js     8013ea <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80139f:	83 ec 08             	sub    $0x8,%esp
  8013a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a5:	50                   	push   %eax
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	ff 30                	pushl  (%eax)
  8013ab:	e8 bf fb ff ff       	call   800f6f <dev_lookup>
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	78 33                	js     8013ea <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ba:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013be:	74 2f                	je     8013ef <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013ca:	00 00 00 
	stat->st_isdir = 0;
  8013cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013d4:	00 00 00 
	stat->st_dev = dev;
  8013d7:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013dd:	83 ec 08             	sub    $0x8,%esp
  8013e0:	53                   	push   %ebx
  8013e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8013e4:	ff 50 14             	call   *0x14(%eax)
  8013e7:	83 c4 10             	add    $0x10,%esp
}
  8013ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    
		return -E_NOT_SUPP;
  8013ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f4:	eb f4                	jmp    8013ea <fstat+0x68>

008013f6 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013fb:	83 ec 08             	sub    $0x8,%esp
  8013fe:	6a 00                	push   $0x0
  801400:	ff 75 08             	pushl  0x8(%ebp)
  801403:	e8 e7 01 00 00       	call   8015ef <open>
  801408:	89 c3                	mov    %eax,%ebx
  80140a:	83 c4 10             	add    $0x10,%esp
  80140d:	85 c0                	test   %eax,%eax
  80140f:	78 1b                	js     80142c <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801411:	83 ec 08             	sub    $0x8,%esp
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	50                   	push   %eax
  801418:	e8 65 ff ff ff       	call   801382 <fstat>
  80141d:	89 c6                	mov    %eax,%esi
	close(fd);
  80141f:	89 1c 24             	mov    %ebx,(%esp)
  801422:	e8 27 fc ff ff       	call   80104e <close>
	return r;
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	89 f3                	mov    %esi,%ebx
}
  80142c:	89 d8                	mov    %ebx,%eax
  80142e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
  80143a:	89 c6                	mov    %eax,%esi
  80143c:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80143e:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801445:	74 27                	je     80146e <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801447:	6a 07                	push   $0x7
  801449:	68 00 50 80 00       	push   $0x805000
  80144e:	56                   	push   %esi
  80144f:	ff 35 00 40 80 00    	pushl  0x804000
  801455:	e8 d0 0b 00 00       	call   80202a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80145a:	83 c4 0c             	add    $0xc,%esp
  80145d:	6a 00                	push   $0x0
  80145f:	53                   	push   %ebx
  801460:	6a 00                	push   $0x0
  801462:	e8 5c 0b 00 00       	call   801fc3 <ipc_recv>
}
  801467:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80146a:	5b                   	pop    %ebx
  80146b:	5e                   	pop    %esi
  80146c:	5d                   	pop    %ebp
  80146d:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	6a 01                	push   $0x1
  801473:	e8 06 0c 00 00       	call   80207e <ipc_find_env>
  801478:	a3 00 40 80 00       	mov    %eax,0x804000
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	eb c5                	jmp    801447 <fsipc+0x12>

00801482 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8b 40 0c             	mov    0xc(%eax),%eax
  80148e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80149b:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a0:	b8 02 00 00 00       	mov    $0x2,%eax
  8014a5:	e8 8b ff ff ff       	call   801435 <fsipc>
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <devfile_flush>:
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014b8:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8014bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c2:	b8 06 00 00 00       	mov    $0x6,%eax
  8014c7:	e8 69 ff ff ff       	call   801435 <fsipc>
}
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <devfile_stat>:
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 04             	sub    $0x4,%esp
  8014d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8b 40 0c             	mov    0xc(%eax),%eax
  8014de:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e8:	b8 05 00 00 00       	mov    $0x5,%eax
  8014ed:	e8 43 ff ff ff       	call   801435 <fsipc>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	78 2c                	js     801522 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	68 00 50 80 00       	push   $0x805000
  8014fe:	53                   	push   %ebx
  8014ff:	e8 0b f3 ff ff       	call   80080f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801504:	a1 80 50 80 00       	mov    0x805080,%eax
  801509:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80150f:	a1 84 50 80 00       	mov    0x805084,%eax
  801514:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <devfile_write>:
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 0c             	sub    $0xc,%esp
  80152d:	8b 45 10             	mov    0x10(%ebp),%eax
  801530:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801535:	ba f8 0f 00 00       	mov    $0xff8,%edx
  80153a:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 52 0c             	mov    0xc(%edx),%edx
  801543:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801549:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80154e:	50                   	push   %eax
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	68 08 50 80 00       	push   $0x805008
  801557:	e8 41 f4 ff ff       	call   80099d <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80155c:	ba 00 00 00 00       	mov    $0x0,%edx
  801561:	b8 04 00 00 00       	mov    $0x4,%eax
  801566:	e8 ca fe ff ff       	call   801435 <fsipc>
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <devfile_read>:
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	56                   	push   %esi
  801571:	53                   	push   %ebx
  801572:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	8b 40 0c             	mov    0xc(%eax),%eax
  80157b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801580:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801586:	ba 00 00 00 00       	mov    $0x0,%edx
  80158b:	b8 03 00 00 00       	mov    $0x3,%eax
  801590:	e8 a0 fe ff ff       	call   801435 <fsipc>
  801595:	89 c3                	mov    %eax,%ebx
  801597:	85 c0                	test   %eax,%eax
  801599:	78 1f                	js     8015ba <devfile_read+0x4d>
	assert(r <= n);
  80159b:	39 f0                	cmp    %esi,%eax
  80159d:	77 24                	ja     8015c3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80159f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015a4:	7f 33                	jg     8015d9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	50                   	push   %eax
  8015aa:	68 00 50 80 00       	push   $0x805000
  8015af:	ff 75 0c             	pushl  0xc(%ebp)
  8015b2:	e8 e6 f3 ff ff       	call   80099d <memmove>
	return r;
  8015b7:	83 c4 10             	add    $0x10,%esp
}
  8015ba:	89 d8                	mov    %ebx,%eax
  8015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bf:	5b                   	pop    %ebx
  8015c0:	5e                   	pop    %esi
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    
	assert(r <= n);
  8015c3:	68 c4 27 80 00       	push   $0x8027c4
  8015c8:	68 cb 27 80 00       	push   $0x8027cb
  8015cd:	6a 7b                	push   $0x7b
  8015cf:	68 e0 27 80 00       	push   $0x8027e0
  8015d4:	e8 3c eb ff ff       	call   800115 <_panic>
	assert(r <= PGSIZE);
  8015d9:	68 eb 27 80 00       	push   $0x8027eb
  8015de:	68 cb 27 80 00       	push   $0x8027cb
  8015e3:	6a 7c                	push   $0x7c
  8015e5:	68 e0 27 80 00       	push   $0x8027e0
  8015ea:	e8 26 eb ff ff       	call   800115 <_panic>

008015ef <open>:
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	56                   	push   %esi
  8015f3:	53                   	push   %ebx
  8015f4:	83 ec 1c             	sub    $0x1c,%esp
  8015f7:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015fa:	56                   	push   %esi
  8015fb:	e8 d8 f1 ff ff       	call   8007d8 <strlen>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801608:	7f 6c                	jg     801676 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801610:	50                   	push   %eax
  801611:	e8 b4 f8 ff ff       	call   800eca <fd_alloc>
  801616:	89 c3                	mov    %eax,%ebx
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 3c                	js     80165b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	56                   	push   %esi
  801623:	68 00 50 80 00       	push   $0x805000
  801628:	e8 e2 f1 ff ff       	call   80080f <strcpy>
	fsipcbuf.open.req_omode = mode;
  80162d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801630:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801635:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801638:	b8 01 00 00 00       	mov    $0x1,%eax
  80163d:	e8 f3 fd ff ff       	call   801435 <fsipc>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	85 c0                	test   %eax,%eax
  801649:	78 19                	js     801664 <open+0x75>
	return fd2num(fd);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 f4             	pushl  -0xc(%ebp)
  801651:	e8 4d f8 ff ff       	call   800ea3 <fd2num>
  801656:	89 c3                	mov    %eax,%ebx
  801658:	83 c4 10             	add    $0x10,%esp
}
  80165b:	89 d8                	mov    %ebx,%eax
  80165d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801660:	5b                   	pop    %ebx
  801661:	5e                   	pop    %esi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    
		fd_close(fd, 0);
  801664:	83 ec 08             	sub    $0x8,%esp
  801667:	6a 00                	push   $0x0
  801669:	ff 75 f4             	pushl  -0xc(%ebp)
  80166c:	e8 54 f9 ff ff       	call   800fc5 <fd_close>
		return r;
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	eb e5                	jmp    80165b <open+0x6c>
		return -E_BAD_PATH;
  801676:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80167b:	eb de                	jmp    80165b <open+0x6c>

0080167d <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801683:	ba 00 00 00 00       	mov    $0x0,%edx
  801688:	b8 08 00 00 00       	mov    $0x8,%eax
  80168d:	e8 a3 fd ff ff       	call   801435 <fsipc>
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80169a:	68 f7 27 80 00       	push   $0x8027f7
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	e8 68 f1 ff ff       	call   80080f <strcpy>
	return 0;
}
  8016a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <devsock_close>:
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	53                   	push   %ebx
  8016b2:	83 ec 10             	sub    $0x10,%esp
  8016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8016b8:	53                   	push   %ebx
  8016b9:	e8 f9 09 00 00       	call   8020b7 <pageref>
  8016be:	83 c4 10             	add    $0x10,%esp
		return 0;
  8016c1:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8016c6:	83 f8 01             	cmp    $0x1,%eax
  8016c9:	74 07                	je     8016d2 <devsock_close+0x24>
}
  8016cb:	89 d0                	mov    %edx,%eax
  8016cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	ff 73 0c             	pushl  0xc(%ebx)
  8016d8:	e8 b7 02 00 00       	call   801994 <nsipc_close>
  8016dd:	89 c2                	mov    %eax,%edx
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	eb e7                	jmp    8016cb <devsock_close+0x1d>

008016e4 <devsock_write>:
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8016ea:	6a 00                	push   $0x0
  8016ec:	ff 75 10             	pushl  0x10(%ebp)
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	ff 70 0c             	pushl  0xc(%eax)
  8016f8:	e8 74 03 00 00       	call   801a71 <nsipc_send>
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <devsock_read>:
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801705:	6a 00                	push   $0x0
  801707:	ff 75 10             	pushl  0x10(%ebp)
  80170a:	ff 75 0c             	pushl  0xc(%ebp)
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	ff 70 0c             	pushl  0xc(%eax)
  801713:	e8 ed 02 00 00       	call   801a05 <nsipc_recv>
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <fd2sockid>:
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801720:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801723:	52                   	push   %edx
  801724:	50                   	push   %eax
  801725:	e8 ef f7 ff ff       	call   800f19 <fd_lookup>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 10                	js     801741 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80173a:	39 08                	cmp    %ecx,(%eax)
  80173c:	75 05                	jne    801743 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80173e:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    
		return -E_NOT_SUPP;
  801743:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801748:	eb f7                	jmp    801741 <fd2sockid+0x27>

0080174a <alloc_sockfd>:
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	56                   	push   %esi
  80174e:	53                   	push   %ebx
  80174f:	83 ec 1c             	sub    $0x1c,%esp
  801752:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801754:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801757:	50                   	push   %eax
  801758:	e8 6d f7 ff ff       	call   800eca <fd_alloc>
  80175d:	89 c3                	mov    %eax,%ebx
  80175f:	83 c4 10             	add    $0x10,%esp
  801762:	85 c0                	test   %eax,%eax
  801764:	78 43                	js     8017a9 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 07 04 00 00       	push   $0x407
  80176e:	ff 75 f4             	pushl  -0xc(%ebp)
  801771:	6a 00                	push   $0x0
  801773:	e8 90 f4 ff ff       	call   800c08 <sys_page_alloc>
  801778:	89 c3                	mov    %eax,%ebx
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 28                	js     8017a9 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80178a:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801796:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801799:	83 ec 0c             	sub    $0xc,%esp
  80179c:	50                   	push   %eax
  80179d:	e8 01 f7 ff ff       	call   800ea3 <fd2num>
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	eb 0c                	jmp    8017b5 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	56                   	push   %esi
  8017ad:	e8 e2 01 00 00       	call   801994 <nsipc_close>
		return r;
  8017b2:	83 c4 10             	add    $0x10,%esp
}
  8017b5:	89 d8                	mov    %ebx,%eax
  8017b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ba:	5b                   	pop    %ebx
  8017bb:	5e                   	pop    %esi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <accept>:
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	e8 4e ff ff ff       	call   80171a <fd2sockid>
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	78 1b                	js     8017eb <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	ff 75 10             	pushl  0x10(%ebp)
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	e8 0e 01 00 00       	call   8018ed <nsipc_accept>
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 05                	js     8017eb <accept+0x2d>
	return alloc_sockfd(r);
  8017e6:	e8 5f ff ff ff       	call   80174a <alloc_sockfd>
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <bind>:
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	e8 1f ff ff ff       	call   80171a <fd2sockid>
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	78 12                	js     801811 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8017ff:	83 ec 04             	sub    $0x4,%esp
  801802:	ff 75 10             	pushl  0x10(%ebp)
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	50                   	push   %eax
  801809:	e8 2f 01 00 00       	call   80193d <nsipc_bind>
  80180e:	83 c4 10             	add    $0x10,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <shutdown>:
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	e8 f9 fe ff ff       	call   80171a <fd2sockid>
  801821:	85 c0                	test   %eax,%eax
  801823:	78 0f                	js     801834 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801825:	83 ec 08             	sub    $0x8,%esp
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	50                   	push   %eax
  80182c:	e8 41 01 00 00       	call   801972 <nsipc_shutdown>
  801831:	83 c4 10             	add    $0x10,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <connect>:
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	e8 d6 fe ff ff       	call   80171a <fd2sockid>
  801844:	85 c0                	test   %eax,%eax
  801846:	78 12                	js     80185a <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	ff 75 10             	pushl  0x10(%ebp)
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	50                   	push   %eax
  801852:	e8 57 01 00 00       	call   8019ae <nsipc_connect>
  801857:	83 c4 10             	add    $0x10,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <listen>:
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	e8 b0 fe ff ff       	call   80171a <fd2sockid>
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 0f                	js     80187d <listen+0x21>
	return nsipc_listen(r, backlog);
  80186e:	83 ec 08             	sub    $0x8,%esp
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	50                   	push   %eax
  801875:	e8 69 01 00 00       	call   8019e3 <nsipc_listen>
  80187a:	83 c4 10             	add    $0x10,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <socket>:

int
socket(int domain, int type, int protocol)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801885:	ff 75 10             	pushl  0x10(%ebp)
  801888:	ff 75 0c             	pushl  0xc(%ebp)
  80188b:	ff 75 08             	pushl  0x8(%ebp)
  80188e:	e8 3c 02 00 00       	call   801acf <nsipc_socket>
  801893:	83 c4 10             	add    $0x10,%esp
  801896:	85 c0                	test   %eax,%eax
  801898:	78 05                	js     80189f <socket+0x20>
		return r;
	return alloc_sockfd(r);
  80189a:	e8 ab fe ff ff       	call   80174a <alloc_sockfd>
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8018aa:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8018b1:	74 26                	je     8018d9 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8018b3:	6a 07                	push   $0x7
  8018b5:	68 00 60 80 00       	push   $0x806000
  8018ba:	53                   	push   %ebx
  8018bb:	ff 35 04 40 80 00    	pushl  0x804004
  8018c1:	e8 64 07 00 00       	call   80202a <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8018c6:	83 c4 0c             	add    $0xc,%esp
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	e8 ef 06 00 00       	call   801fc3 <ipc_recv>
}
  8018d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	6a 02                	push   $0x2
  8018de:	e8 9b 07 00 00       	call   80207e <ipc_find_env>
  8018e3:	a3 04 40 80 00       	mov    %eax,0x804004
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	eb c6                	jmp    8018b3 <nsipc+0x12>

008018ed <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8018fd:	8b 06                	mov    (%esi),%eax
  8018ff:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801904:	b8 01 00 00 00       	mov    $0x1,%eax
  801909:	e8 93 ff ff ff       	call   8018a1 <nsipc>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	85 c0                	test   %eax,%eax
  801912:	78 20                	js     801934 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	ff 35 10 60 80 00    	pushl  0x806010
  80191d:	68 00 60 80 00       	push   $0x806000
  801922:	ff 75 0c             	pushl  0xc(%ebp)
  801925:	e8 73 f0 ff ff       	call   80099d <memmove>
		*addrlen = ret->ret_addrlen;
  80192a:	a1 10 60 80 00       	mov    0x806010,%eax
  80192f:	89 06                	mov    %eax,(%esi)
  801931:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801934:	89 d8                	mov    %ebx,%eax
  801936:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801939:	5b                   	pop    %ebx
  80193a:	5e                   	pop    %esi
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    

0080193d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	53                   	push   %ebx
  801941:	83 ec 08             	sub    $0x8,%esp
  801944:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  80194f:	53                   	push   %ebx
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	68 04 60 80 00       	push   $0x806004
  801958:	e8 40 f0 ff ff       	call   80099d <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  80195d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801963:	b8 02 00 00 00       	mov    $0x2,%eax
  801968:	e8 34 ff ff ff       	call   8018a1 <nsipc>
}
  80196d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801988:	b8 03 00 00 00       	mov    $0x3,%eax
  80198d:	e8 0f ff ff ff       	call   8018a1 <nsipc>
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <nsipc_close>:

int
nsipc_close(int s)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8019a2:	b8 04 00 00 00       	mov    $0x4,%eax
  8019a7:	e8 f5 fe ff ff       	call   8018a1 <nsipc>
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	53                   	push   %ebx
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019c0:	53                   	push   %ebx
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	68 04 60 80 00       	push   $0x806004
  8019c9:	e8 cf ef ff ff       	call   80099d <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019ce:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019d4:	b8 05 00 00 00       	mov    $0x5,%eax
  8019d9:	e8 c3 fe ff ff       	call   8018a1 <nsipc>
}
  8019de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8019f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8019f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019fe:	e8 9e fe ff ff       	call   8018a1 <nsipc>
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	56                   	push   %esi
  801a09:	53                   	push   %ebx
  801a0a:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801a15:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1e:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801a23:	b8 07 00 00 00       	mov    $0x7,%eax
  801a28:	e8 74 fe ff ff       	call   8018a1 <nsipc>
  801a2d:	89 c3                	mov    %eax,%ebx
  801a2f:	85 c0                	test   %eax,%eax
  801a31:	78 1f                	js     801a52 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801a33:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801a38:	7f 21                	jg     801a5b <nsipc_recv+0x56>
  801a3a:	39 c6                	cmp    %eax,%esi
  801a3c:	7c 1d                	jl     801a5b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	50                   	push   %eax
  801a42:	68 00 60 80 00       	push   $0x806000
  801a47:	ff 75 0c             	pushl  0xc(%ebp)
  801a4a:	e8 4e ef ff ff       	call   80099d <memmove>
  801a4f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801a52:	89 d8                	mov    %ebx,%eax
  801a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5d                   	pop    %ebp
  801a5a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801a5b:	68 03 28 80 00       	push   $0x802803
  801a60:	68 cb 27 80 00       	push   $0x8027cb
  801a65:	6a 62                	push   $0x62
  801a67:	68 18 28 80 00       	push   $0x802818
  801a6c:	e8 a4 e6 ff ff       	call   800115 <_panic>

00801a71 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	53                   	push   %ebx
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801a83:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801a89:	7f 2e                	jg     801ab9 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801a8b:	83 ec 04             	sub    $0x4,%esp
  801a8e:	53                   	push   %ebx
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	68 0c 60 80 00       	push   $0x80600c
  801a97:	e8 01 ef ff ff       	call   80099d <memmove>
	nsipcbuf.send.req_size = size;
  801a9c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801aaa:	b8 08 00 00 00       	mov    $0x8,%eax
  801aaf:	e8 ed fd ff ff       	call   8018a1 <nsipc>
}
  801ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    
	assert(size < 1600);
  801ab9:	68 24 28 80 00       	push   $0x802824
  801abe:	68 cb 27 80 00       	push   $0x8027cb
  801ac3:	6a 6d                	push   $0x6d
  801ac5:	68 18 28 80 00       	push   $0x802818
  801aca:	e8 46 e6 ff ff       	call   800115 <_panic>

00801acf <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801add:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801aed:	b8 09 00 00 00       	mov    $0x9,%eax
  801af2:	e8 aa fd ff ff       	call   8018a1 <nsipc>
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	56                   	push   %esi
  801afd:	53                   	push   %ebx
  801afe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801b01:	83 ec 0c             	sub    $0xc,%esp
  801b04:	ff 75 08             	pushl  0x8(%ebp)
  801b07:	e8 a7 f3 ff ff       	call   800eb3 <fd2data>
  801b0c:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b0e:	83 c4 08             	add    $0x8,%esp
  801b11:	68 30 28 80 00       	push   $0x802830
  801b16:	53                   	push   %ebx
  801b17:	e8 f3 ec ff ff       	call   80080f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b1c:	8b 46 04             	mov    0x4(%esi),%eax
  801b1f:	2b 06                	sub    (%esi),%eax
  801b21:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801b27:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b2e:	00 00 00 
	stat->st_dev = &devpipe;
  801b31:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801b38:	30 80 00 
	return 0;
}
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b43:	5b                   	pop    %ebx
  801b44:	5e                   	pop    %esi
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    

00801b47 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	53                   	push   %ebx
  801b4b:	83 ec 0c             	sub    $0xc,%esp
  801b4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b51:	53                   	push   %ebx
  801b52:	6a 00                	push   $0x0
  801b54:	e8 34 f1 ff ff       	call   800c8d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b59:	89 1c 24             	mov    %ebx,(%esp)
  801b5c:	e8 52 f3 ff ff       	call   800eb3 <fd2data>
  801b61:	83 c4 08             	add    $0x8,%esp
  801b64:	50                   	push   %eax
  801b65:	6a 00                	push   $0x0
  801b67:	e8 21 f1 ff ff       	call   800c8d <sys_page_unmap>
}
  801b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <_pipeisclosed>:
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	57                   	push   %edi
  801b75:	56                   	push   %esi
  801b76:	53                   	push   %ebx
  801b77:	83 ec 1c             	sub    $0x1c,%esp
  801b7a:	89 c7                	mov    %eax,%edi
  801b7c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b7e:	a1 08 40 80 00       	mov    0x804008,%eax
  801b83:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b86:	83 ec 0c             	sub    $0xc,%esp
  801b89:	57                   	push   %edi
  801b8a:	e8 28 05 00 00       	call   8020b7 <pageref>
  801b8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b92:	89 34 24             	mov    %esi,(%esp)
  801b95:	e8 1d 05 00 00       	call   8020b7 <pageref>
		nn = thisenv->env_runs;
  801b9a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ba0:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	39 cb                	cmp    %ecx,%ebx
  801ba8:	74 1b                	je     801bc5 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801baa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bad:	75 cf                	jne    801b7e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801baf:	8b 42 58             	mov    0x58(%edx),%eax
  801bb2:	6a 01                	push   $0x1
  801bb4:	50                   	push   %eax
  801bb5:	53                   	push   %ebx
  801bb6:	68 37 28 80 00       	push   $0x802837
  801bbb:	e8 30 e6 ff ff       	call   8001f0 <cprintf>
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	eb b9                	jmp    801b7e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bc5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bc8:	0f 94 c0             	sete   %al
  801bcb:	0f b6 c0             	movzbl %al,%eax
}
  801bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bd1:	5b                   	pop    %ebx
  801bd2:	5e                   	pop    %esi
  801bd3:	5f                   	pop    %edi
  801bd4:	5d                   	pop    %ebp
  801bd5:	c3                   	ret    

00801bd6 <devpipe_write>:
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	57                   	push   %edi
  801bda:	56                   	push   %esi
  801bdb:	53                   	push   %ebx
  801bdc:	83 ec 28             	sub    $0x28,%esp
  801bdf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801be2:	56                   	push   %esi
  801be3:	e8 cb f2 ff ff       	call   800eb3 <fd2data>
  801be8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bea:	83 c4 10             	add    $0x10,%esp
  801bed:	bf 00 00 00 00       	mov    $0x0,%edi
  801bf2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801bf5:	74 4f                	je     801c46 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801bf7:	8b 43 04             	mov    0x4(%ebx),%eax
  801bfa:	8b 0b                	mov    (%ebx),%ecx
  801bfc:	8d 51 20             	lea    0x20(%ecx),%edx
  801bff:	39 d0                	cmp    %edx,%eax
  801c01:	72 14                	jb     801c17 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801c03:	89 da                	mov    %ebx,%edx
  801c05:	89 f0                	mov    %esi,%eax
  801c07:	e8 65 ff ff ff       	call   801b71 <_pipeisclosed>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	75 3a                	jne    801c4a <devpipe_write+0x74>
			sys_yield();
  801c10:	e8 d4 ef ff ff       	call   800be9 <sys_yield>
  801c15:	eb e0                	jmp    801bf7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c1a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801c1e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801c21:	89 c2                	mov    %eax,%edx
  801c23:	c1 fa 1f             	sar    $0x1f,%edx
  801c26:	89 d1                	mov    %edx,%ecx
  801c28:	c1 e9 1b             	shr    $0x1b,%ecx
  801c2b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801c2e:	83 e2 1f             	and    $0x1f,%edx
  801c31:	29 ca                	sub    %ecx,%edx
  801c33:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801c37:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801c3b:	83 c0 01             	add    $0x1,%eax
  801c3e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c41:	83 c7 01             	add    $0x1,%edi
  801c44:	eb ac                	jmp    801bf2 <devpipe_write+0x1c>
	return i;
  801c46:	89 f8                	mov    %edi,%eax
  801c48:	eb 05                	jmp    801c4f <devpipe_write+0x79>
				return 0;
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5f                   	pop    %edi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <devpipe_read>:
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	57                   	push   %edi
  801c5b:	56                   	push   %esi
  801c5c:	53                   	push   %ebx
  801c5d:	83 ec 18             	sub    $0x18,%esp
  801c60:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c63:	57                   	push   %edi
  801c64:	e8 4a f2 ff ff       	call   800eb3 <fd2data>
  801c69:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	be 00 00 00 00       	mov    $0x0,%esi
  801c73:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c76:	74 47                	je     801cbf <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801c78:	8b 03                	mov    (%ebx),%eax
  801c7a:	3b 43 04             	cmp    0x4(%ebx),%eax
  801c7d:	75 22                	jne    801ca1 <devpipe_read+0x4a>
			if (i > 0)
  801c7f:	85 f6                	test   %esi,%esi
  801c81:	75 14                	jne    801c97 <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801c83:	89 da                	mov    %ebx,%edx
  801c85:	89 f8                	mov    %edi,%eax
  801c87:	e8 e5 fe ff ff       	call   801b71 <_pipeisclosed>
  801c8c:	85 c0                	test   %eax,%eax
  801c8e:	75 33                	jne    801cc3 <devpipe_read+0x6c>
			sys_yield();
  801c90:	e8 54 ef ff ff       	call   800be9 <sys_yield>
  801c95:	eb e1                	jmp    801c78 <devpipe_read+0x21>
				return i;
  801c97:	89 f0                	mov    %esi,%eax
}
  801c99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ca1:	99                   	cltd   
  801ca2:	c1 ea 1b             	shr    $0x1b,%edx
  801ca5:	01 d0                	add    %edx,%eax
  801ca7:	83 e0 1f             	and    $0x1f,%eax
  801caa:	29 d0                	sub    %edx,%eax
  801cac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801cb7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801cba:	83 c6 01             	add    $0x1,%esi
  801cbd:	eb b4                	jmp    801c73 <devpipe_read+0x1c>
	return i;
  801cbf:	89 f0                	mov    %esi,%eax
  801cc1:	eb d6                	jmp    801c99 <devpipe_read+0x42>
				return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb cf                	jmp    801c99 <devpipe_read+0x42>

00801cca <pipe>:
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cd5:	50                   	push   %eax
  801cd6:	e8 ef f1 ff ff       	call   800eca <fd_alloc>
  801cdb:	89 c3                	mov    %eax,%ebx
  801cdd:	83 c4 10             	add    $0x10,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	78 5b                	js     801d3f <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ce4:	83 ec 04             	sub    $0x4,%esp
  801ce7:	68 07 04 00 00       	push   $0x407
  801cec:	ff 75 f4             	pushl  -0xc(%ebp)
  801cef:	6a 00                	push   $0x0
  801cf1:	e8 12 ef ff ff       	call   800c08 <sys_page_alloc>
  801cf6:	89 c3                	mov    %eax,%ebx
  801cf8:	83 c4 10             	add    $0x10,%esp
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	78 40                	js     801d3f <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801cff:	83 ec 0c             	sub    $0xc,%esp
  801d02:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d05:	50                   	push   %eax
  801d06:	e8 bf f1 ff ff       	call   800eca <fd_alloc>
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	85 c0                	test   %eax,%eax
  801d12:	78 1b                	js     801d2f <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	68 07 04 00 00       	push   $0x407
  801d1c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d1f:	6a 00                	push   $0x0
  801d21:	e8 e2 ee ff ff       	call   800c08 <sys_page_alloc>
  801d26:	89 c3                	mov    %eax,%ebx
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	79 19                	jns    801d48 <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801d2f:	83 ec 08             	sub    $0x8,%esp
  801d32:	ff 75 f4             	pushl  -0xc(%ebp)
  801d35:	6a 00                	push   $0x0
  801d37:	e8 51 ef ff ff       	call   800c8d <sys_page_unmap>
  801d3c:	83 c4 10             	add    $0x10,%esp
}
  801d3f:	89 d8                	mov    %ebx,%eax
  801d41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d44:	5b                   	pop    %ebx
  801d45:	5e                   	pop    %esi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
	va = fd2data(fd0);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801d4e:	e8 60 f1 ff ff       	call   800eb3 <fd2data>
  801d53:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d55:	83 c4 0c             	add    $0xc,%esp
  801d58:	68 07 04 00 00       	push   $0x407
  801d5d:	50                   	push   %eax
  801d5e:	6a 00                	push   $0x0
  801d60:	e8 a3 ee ff ff       	call   800c08 <sys_page_alloc>
  801d65:	89 c3                	mov    %eax,%ebx
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	85 c0                	test   %eax,%eax
  801d6c:	0f 88 8c 00 00 00    	js     801dfe <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d72:	83 ec 0c             	sub    $0xc,%esp
  801d75:	ff 75 f0             	pushl  -0x10(%ebp)
  801d78:	e8 36 f1 ff ff       	call   800eb3 <fd2data>
  801d7d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d84:	50                   	push   %eax
  801d85:	6a 00                	push   $0x0
  801d87:	56                   	push   %esi
  801d88:	6a 00                	push   $0x0
  801d8a:	e8 bc ee ff ff       	call   800c4b <sys_page_map>
  801d8f:	89 c3                	mov    %eax,%ebx
  801d91:	83 c4 20             	add    $0x20,%esp
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 58                	js     801df0 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801da1:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801db6:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc8:	e8 d6 f0 ff ff       	call   800ea3 <fd2num>
  801dcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd0:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dd2:	83 c4 04             	add    $0x4,%esp
  801dd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801dd8:	e8 c6 f0 ff ff       	call   800ea3 <fd2num>
  801ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801de0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801de3:	83 c4 10             	add    $0x10,%esp
  801de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801deb:	e9 4f ff ff ff       	jmp    801d3f <pipe+0x75>
	sys_page_unmap(0, va);
  801df0:	83 ec 08             	sub    $0x8,%esp
  801df3:	56                   	push   %esi
  801df4:	6a 00                	push   $0x0
  801df6:	e8 92 ee ff ff       	call   800c8d <sys_page_unmap>
  801dfb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dfe:	83 ec 08             	sub    $0x8,%esp
  801e01:	ff 75 f0             	pushl  -0x10(%ebp)
  801e04:	6a 00                	push   $0x0
  801e06:	e8 82 ee ff ff       	call   800c8d <sys_page_unmap>
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	e9 1c ff ff ff       	jmp    801d2f <pipe+0x65>

00801e13 <pipeisclosed>:
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1c:	50                   	push   %eax
  801e1d:	ff 75 08             	pushl  0x8(%ebp)
  801e20:	e8 f4 f0 ff ff       	call   800f19 <fd_lookup>
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	78 18                	js     801e44 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e32:	e8 7c f0 ff ff       	call   800eb3 <fd2data>
	return _pipeisclosed(fd, p);
  801e37:	89 c2                	mov    %eax,%edx
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	e8 30 fd ff ff       	call   801b71 <_pipeisclosed>
  801e41:	83 c4 10             	add    $0x10,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	5d                   	pop    %ebp
  801e4f:	c3                   	ret    

00801e50 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801e56:	68 4f 28 80 00       	push   $0x80284f
  801e5b:	ff 75 0c             	pushl  0xc(%ebp)
  801e5e:	e8 ac e9 ff ff       	call   80080f <strcpy>
	return 0;
}
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <devcons_write>:
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	57                   	push   %edi
  801e6e:	56                   	push   %esi
  801e6f:	53                   	push   %ebx
  801e70:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e76:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e7b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e81:	eb 2f                	jmp    801eb2 <devcons_write+0x48>
		m = n - tot;
  801e83:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e86:	29 f3                	sub    %esi,%ebx
  801e88:	83 fb 7f             	cmp    $0x7f,%ebx
  801e8b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801e90:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	53                   	push   %ebx
  801e97:	89 f0                	mov    %esi,%eax
  801e99:	03 45 0c             	add    0xc(%ebp),%eax
  801e9c:	50                   	push   %eax
  801e9d:	57                   	push   %edi
  801e9e:	e8 fa ea ff ff       	call   80099d <memmove>
		sys_cputs(buf, m);
  801ea3:	83 c4 08             	add    $0x8,%esp
  801ea6:	53                   	push   %ebx
  801ea7:	57                   	push   %edi
  801ea8:	e8 9f ec ff ff       	call   800b4c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ead:	01 de                	add    %ebx,%esi
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb5:	72 cc                	jb     801e83 <devcons_write+0x19>
}
  801eb7:	89 f0                	mov    %esi,%eax
  801eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ebc:	5b                   	pop    %ebx
  801ebd:	5e                   	pop    %esi
  801ebe:	5f                   	pop    %edi
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <devcons_read>:
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 08             	sub    $0x8,%esp
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  801ecc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed0:	75 07                	jne    801ed9 <devcons_read+0x18>
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    
		sys_yield();
  801ed4:	e8 10 ed ff ff       	call   800be9 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ed9:	e8 8c ec ff ff       	call   800b6a <sys_cgetc>
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	74 f2                	je     801ed4 <devcons_read+0x13>
	if (c < 0)
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	78 ec                	js     801ed2 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  801ee6:	83 f8 04             	cmp    $0x4,%eax
  801ee9:	74 0c                	je     801ef7 <devcons_read+0x36>
	*(char*)vbuf = c;
  801eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eee:	88 02                	mov    %al,(%edx)
	return 1;
  801ef0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef5:	eb db                	jmp    801ed2 <devcons_read+0x11>
		return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
  801efc:	eb d4                	jmp    801ed2 <devcons_read+0x11>

00801efe <cputchar>:
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f0a:	6a 01                	push   $0x1
  801f0c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f0f:	50                   	push   %eax
  801f10:	e8 37 ec ff ff       	call   800b4c <sys_cputs>
}
  801f15:	83 c4 10             	add    $0x10,%esp
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <getchar>:
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f20:	6a 01                	push   $0x1
  801f22:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f25:	50                   	push   %eax
  801f26:	6a 00                	push   $0x0
  801f28:	e8 5d f2 ff ff       	call   80118a <read>
	if (r < 0)
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	85 c0                	test   %eax,%eax
  801f32:	78 08                	js     801f3c <getchar+0x22>
	if (r < 1)
  801f34:	85 c0                	test   %eax,%eax
  801f36:	7e 06                	jle    801f3e <getchar+0x24>
	return c;
  801f38:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    
		return -E_EOF;
  801f3e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f43:	eb f7                	jmp    801f3c <getchar+0x22>

00801f45 <iscons>:
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4e:	50                   	push   %eax
  801f4f:	ff 75 08             	pushl  0x8(%ebp)
  801f52:	e8 c2 ef ff ff       	call   800f19 <fd_lookup>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 11                	js     801f6f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801f67:	39 10                	cmp    %edx,(%eax)
  801f69:	0f 94 c0             	sete   %al
  801f6c:	0f b6 c0             	movzbl %al,%eax
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <opencons>:
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f77:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7a:	50                   	push   %eax
  801f7b:	e8 4a ef ff ff       	call   800eca <fd_alloc>
  801f80:	83 c4 10             	add    $0x10,%esp
  801f83:	85 c0                	test   %eax,%eax
  801f85:	78 3a                	js     801fc1 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f87:	83 ec 04             	sub    $0x4,%esp
  801f8a:	68 07 04 00 00       	push   $0x407
  801f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f92:	6a 00                	push   $0x0
  801f94:	e8 6f ec ff ff       	call   800c08 <sys_page_alloc>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	85 c0                	test   %eax,%eax
  801f9e:	78 21                	js     801fc1 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801fa9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	50                   	push   %eax
  801fb9:	e8 e5 ee ff ff       	call   800ea3 <fd2num>
  801fbe:	83 c4 10             	add    $0x10,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	56                   	push   %esi
  801fc7:	53                   	push   %ebx
  801fc8:	8b 75 08             	mov    0x8(%ebp),%esi
  801fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  801fd1:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  801fd3:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801fd8:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  801fdb:	83 ec 0c             	sub    $0xc,%esp
  801fde:	50                   	push   %eax
  801fdf:	e8 d4 ed ff ff       	call   800db8 <sys_ipc_recv>
	if (from_env_store)
  801fe4:	83 c4 10             	add    $0x10,%esp
  801fe7:	85 f6                	test   %esi,%esi
  801fe9:	74 14                	je     801fff <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  801feb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 09                	js     801ffd <ipc_recv+0x3a>
  801ff4:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ffa:	8b 52 74             	mov    0x74(%edx),%edx
  801ffd:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  801fff:	85 db                	test   %ebx,%ebx
  802001:	74 14                	je     802017 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  802003:	ba 00 00 00 00       	mov    $0x0,%edx
  802008:	85 c0                	test   %eax,%eax
  80200a:	78 09                	js     802015 <ipc_recv+0x52>
  80200c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802012:	8b 52 78             	mov    0x78(%edx),%edx
  802015:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802017:	85 c0                	test   %eax,%eax
  802019:	78 08                	js     802023 <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  80201b:	a1 08 40 80 00       	mov    0x804008,%eax
  802020:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  802023:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802026:	5b                   	pop    %ebx
  802027:	5e                   	pop    %esi
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	57                   	push   %edi
  80202e:	56                   	push   %esi
  80202f:	53                   	push   %ebx
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	8b 7d 08             	mov    0x8(%ebp),%edi
  802036:	8b 75 0c             	mov    0xc(%ebp),%esi
  802039:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80203c:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  80203e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802043:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802046:	ff 75 14             	pushl  0x14(%ebp)
  802049:	53                   	push   %ebx
  80204a:	56                   	push   %esi
  80204b:	57                   	push   %edi
  80204c:	e8 44 ed ff ff       	call   800d95 <sys_ipc_try_send>
		if (ret == 0)
  802051:	83 c4 10             	add    $0x10,%esp
  802054:	85 c0                	test   %eax,%eax
  802056:	74 1e                	je     802076 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802058:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80205b:	75 07                	jne    802064 <ipc_send+0x3a>
			sys_yield();
  80205d:	e8 87 eb ff ff       	call   800be9 <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802062:	eb e2                	jmp    802046 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  802064:	50                   	push   %eax
  802065:	68 5b 28 80 00       	push   $0x80285b
  80206a:	6a 3d                	push   $0x3d
  80206c:	68 6f 28 80 00       	push   $0x80286f
  802071:	e8 9f e0 ff ff       	call   800115 <_panic>
	}
	// panic("ipc_send not implemented");
}
  802076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5f                   	pop    %edi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802089:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80208c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802092:	8b 52 50             	mov    0x50(%edx),%edx
  802095:	39 ca                	cmp    %ecx,%edx
  802097:	74 11                	je     8020aa <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  802099:	83 c0 01             	add    $0x1,%eax
  80209c:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020a1:	75 e6                	jne    802089 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a8:	eb 0b                	jmp    8020b5 <ipc_find_env+0x37>
			return envs[i].env_id;
  8020aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8020ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8020b2:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020b5:	5d                   	pop    %ebp
  8020b6:	c3                   	ret    

008020b7 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020bd:	89 d0                	mov    %edx,%eax
  8020bf:	c1 e8 16             	shr    $0x16,%eax
  8020c2:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8020c9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8020ce:	f6 c1 01             	test   $0x1,%cl
  8020d1:	74 1d                	je     8020f0 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8020d3:	c1 ea 0c             	shr    $0xc,%edx
  8020d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8020dd:	f6 c2 01             	test   $0x1,%dl
  8020e0:	74 0e                	je     8020f0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020e2:	c1 ea 0c             	shr    $0xc,%edx
  8020e5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8020ec:	ef 
  8020ed:	0f b7 c0             	movzwl %ax,%eax
}
  8020f0:	5d                   	pop    %ebp
  8020f1:	c3                   	ret    
  8020f2:	66 90                	xchg   %ax,%ax
  8020f4:	66 90                	xchg   %ax,%ax
  8020f6:	66 90                	xchg   %ax,%ax
  8020f8:	66 90                	xchg   %ax,%ax
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <__udivdi3>:
  802100:	55                   	push   %ebp
  802101:	57                   	push   %edi
  802102:	56                   	push   %esi
  802103:	53                   	push   %ebx
  802104:	83 ec 1c             	sub    $0x1c,%esp
  802107:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80210b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80210f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802113:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802117:	85 d2                	test   %edx,%edx
  802119:	75 35                	jne    802150 <__udivdi3+0x50>
  80211b:	39 f3                	cmp    %esi,%ebx
  80211d:	0f 87 bd 00 00 00    	ja     8021e0 <__udivdi3+0xe0>
  802123:	85 db                	test   %ebx,%ebx
  802125:	89 d9                	mov    %ebx,%ecx
  802127:	75 0b                	jne    802134 <__udivdi3+0x34>
  802129:	b8 01 00 00 00       	mov    $0x1,%eax
  80212e:	31 d2                	xor    %edx,%edx
  802130:	f7 f3                	div    %ebx
  802132:	89 c1                	mov    %eax,%ecx
  802134:	31 d2                	xor    %edx,%edx
  802136:	89 f0                	mov    %esi,%eax
  802138:	f7 f1                	div    %ecx
  80213a:	89 c6                	mov    %eax,%esi
  80213c:	89 e8                	mov    %ebp,%eax
  80213e:	89 f7                	mov    %esi,%edi
  802140:	f7 f1                	div    %ecx
  802142:	89 fa                	mov    %edi,%edx
  802144:	83 c4 1c             	add    $0x1c,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    
  80214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802150:	39 f2                	cmp    %esi,%edx
  802152:	77 7c                	ja     8021d0 <__udivdi3+0xd0>
  802154:	0f bd fa             	bsr    %edx,%edi
  802157:	83 f7 1f             	xor    $0x1f,%edi
  80215a:	0f 84 98 00 00 00    	je     8021f8 <__udivdi3+0xf8>
  802160:	89 f9                	mov    %edi,%ecx
  802162:	b8 20 00 00 00       	mov    $0x20,%eax
  802167:	29 f8                	sub    %edi,%eax
  802169:	d3 e2                	shl    %cl,%edx
  80216b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80216f:	89 c1                	mov    %eax,%ecx
  802171:	89 da                	mov    %ebx,%edx
  802173:	d3 ea                	shr    %cl,%edx
  802175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802179:	09 d1                	or     %edx,%ecx
  80217b:	89 f2                	mov    %esi,%edx
  80217d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802181:	89 f9                	mov    %edi,%ecx
  802183:	d3 e3                	shl    %cl,%ebx
  802185:	89 c1                	mov    %eax,%ecx
  802187:	d3 ea                	shr    %cl,%edx
  802189:	89 f9                	mov    %edi,%ecx
  80218b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80218f:	d3 e6                	shl    %cl,%esi
  802191:	89 eb                	mov    %ebp,%ebx
  802193:	89 c1                	mov    %eax,%ecx
  802195:	d3 eb                	shr    %cl,%ebx
  802197:	09 de                	or     %ebx,%esi
  802199:	89 f0                	mov    %esi,%eax
  80219b:	f7 74 24 08          	divl   0x8(%esp)
  80219f:	89 d6                	mov    %edx,%esi
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	f7 64 24 0c          	mull   0xc(%esp)
  8021a7:	39 d6                	cmp    %edx,%esi
  8021a9:	72 0c                	jb     8021b7 <__udivdi3+0xb7>
  8021ab:	89 f9                	mov    %edi,%ecx
  8021ad:	d3 e5                	shl    %cl,%ebp
  8021af:	39 c5                	cmp    %eax,%ebp
  8021b1:	73 5d                	jae    802210 <__udivdi3+0x110>
  8021b3:	39 d6                	cmp    %edx,%esi
  8021b5:	75 59                	jne    802210 <__udivdi3+0x110>
  8021b7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021ba:	31 ff                	xor    %edi,%edi
  8021bc:	89 fa                	mov    %edi,%edx
  8021be:	83 c4 1c             	add    $0x1c,%esp
  8021c1:	5b                   	pop    %ebx
  8021c2:	5e                   	pop    %esi
  8021c3:	5f                   	pop    %edi
  8021c4:	5d                   	pop    %ebp
  8021c5:	c3                   	ret    
  8021c6:	8d 76 00             	lea    0x0(%esi),%esi
  8021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  8021d0:	31 ff                	xor    %edi,%edi
  8021d2:	31 c0                	xor    %eax,%eax
  8021d4:	89 fa                	mov    %edi,%edx
  8021d6:	83 c4 1c             	add    $0x1c,%esp
  8021d9:	5b                   	pop    %ebx
  8021da:	5e                   	pop    %esi
  8021db:	5f                   	pop    %edi
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    
  8021de:	66 90                	xchg   %ax,%ax
  8021e0:	31 ff                	xor    %edi,%edi
  8021e2:	89 e8                	mov    %ebp,%eax
  8021e4:	89 f2                	mov    %esi,%edx
  8021e6:	f7 f3                	div    %ebx
  8021e8:	89 fa                	mov    %edi,%edx
  8021ea:	83 c4 1c             	add    $0x1c,%esp
  8021ed:	5b                   	pop    %ebx
  8021ee:	5e                   	pop    %esi
  8021ef:	5f                   	pop    %edi
  8021f0:	5d                   	pop    %ebp
  8021f1:	c3                   	ret    
  8021f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8021f8:	39 f2                	cmp    %esi,%edx
  8021fa:	72 06                	jb     802202 <__udivdi3+0x102>
  8021fc:	31 c0                	xor    %eax,%eax
  8021fe:	39 eb                	cmp    %ebp,%ebx
  802200:	77 d2                	ja     8021d4 <__udivdi3+0xd4>
  802202:	b8 01 00 00 00       	mov    $0x1,%eax
  802207:	eb cb                	jmp    8021d4 <__udivdi3+0xd4>
  802209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802210:	89 d8                	mov    %ebx,%eax
  802212:	31 ff                	xor    %edi,%edi
  802214:	eb be                	jmp    8021d4 <__udivdi3+0xd4>
  802216:	66 90                	xchg   %ax,%ax
  802218:	66 90                	xchg   %ax,%ax
  80221a:	66 90                	xchg   %ax,%ax
  80221c:	66 90                	xchg   %ax,%ax
  80221e:	66 90                	xchg   %ax,%ax

00802220 <__umoddi3>:
  802220:	55                   	push   %ebp
  802221:	57                   	push   %edi
  802222:	56                   	push   %esi
  802223:	53                   	push   %ebx
  802224:	83 ec 1c             	sub    $0x1c,%esp
  802227:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80222b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80222f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802233:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802237:	85 ed                	test   %ebp,%ebp
  802239:	89 f0                	mov    %esi,%eax
  80223b:	89 da                	mov    %ebx,%edx
  80223d:	75 19                	jne    802258 <__umoddi3+0x38>
  80223f:	39 df                	cmp    %ebx,%edi
  802241:	0f 86 b1 00 00 00    	jbe    8022f8 <__umoddi3+0xd8>
  802247:	f7 f7                	div    %edi
  802249:	89 d0                	mov    %edx,%eax
  80224b:	31 d2                	xor    %edx,%edx
  80224d:	83 c4 1c             	add    $0x1c,%esp
  802250:	5b                   	pop    %ebx
  802251:	5e                   	pop    %esi
  802252:	5f                   	pop    %edi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    
  802255:	8d 76 00             	lea    0x0(%esi),%esi
  802258:	39 dd                	cmp    %ebx,%ebp
  80225a:	77 f1                	ja     80224d <__umoddi3+0x2d>
  80225c:	0f bd cd             	bsr    %ebp,%ecx
  80225f:	83 f1 1f             	xor    $0x1f,%ecx
  802262:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802266:	0f 84 b4 00 00 00    	je     802320 <__umoddi3+0x100>
  80226c:	b8 20 00 00 00       	mov    $0x20,%eax
  802271:	89 c2                	mov    %eax,%edx
  802273:	8b 44 24 04          	mov    0x4(%esp),%eax
  802277:	29 c2                	sub    %eax,%edx
  802279:	89 c1                	mov    %eax,%ecx
  80227b:	89 f8                	mov    %edi,%eax
  80227d:	d3 e5                	shl    %cl,%ebp
  80227f:	89 d1                	mov    %edx,%ecx
  802281:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802285:	d3 e8                	shr    %cl,%eax
  802287:	09 c5                	or     %eax,%ebp
  802289:	8b 44 24 04          	mov    0x4(%esp),%eax
  80228d:	89 c1                	mov    %eax,%ecx
  80228f:	d3 e7                	shl    %cl,%edi
  802291:	89 d1                	mov    %edx,%ecx
  802293:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802297:	89 df                	mov    %ebx,%edi
  802299:	d3 ef                	shr    %cl,%edi
  80229b:	89 c1                	mov    %eax,%ecx
  80229d:	89 f0                	mov    %esi,%eax
  80229f:	d3 e3                	shl    %cl,%ebx
  8022a1:	89 d1                	mov    %edx,%ecx
  8022a3:	89 fa                	mov    %edi,%edx
  8022a5:	d3 e8                	shr    %cl,%eax
  8022a7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8022ac:	09 d8                	or     %ebx,%eax
  8022ae:	f7 f5                	div    %ebp
  8022b0:	d3 e6                	shl    %cl,%esi
  8022b2:	89 d1                	mov    %edx,%ecx
  8022b4:	f7 64 24 08          	mull   0x8(%esp)
  8022b8:	39 d1                	cmp    %edx,%ecx
  8022ba:	89 c3                	mov    %eax,%ebx
  8022bc:	89 d7                	mov    %edx,%edi
  8022be:	72 06                	jb     8022c6 <__umoddi3+0xa6>
  8022c0:	75 0e                	jne    8022d0 <__umoddi3+0xb0>
  8022c2:	39 c6                	cmp    %eax,%esi
  8022c4:	73 0a                	jae    8022d0 <__umoddi3+0xb0>
  8022c6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8022ca:	19 ea                	sbb    %ebp,%edx
  8022cc:	89 d7                	mov    %edx,%edi
  8022ce:	89 c3                	mov    %eax,%ebx
  8022d0:	89 ca                	mov    %ecx,%edx
  8022d2:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  8022d7:	29 de                	sub    %ebx,%esi
  8022d9:	19 fa                	sbb    %edi,%edx
  8022db:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	d3 e0                	shl    %cl,%eax
  8022e3:	89 d9                	mov    %ebx,%ecx
  8022e5:	d3 ee                	shr    %cl,%esi
  8022e7:	d3 ea                	shr    %cl,%edx
  8022e9:	09 f0                	or     %esi,%eax
  8022eb:	83 c4 1c             	add    $0x1c,%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5e                   	pop    %esi
  8022f0:	5f                   	pop    %edi
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    
  8022f3:	90                   	nop
  8022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022f8:	85 ff                	test   %edi,%edi
  8022fa:	89 f9                	mov    %edi,%ecx
  8022fc:	75 0b                	jne    802309 <__umoddi3+0xe9>
  8022fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802303:	31 d2                	xor    %edx,%edx
  802305:	f7 f7                	div    %edi
  802307:	89 c1                	mov    %eax,%ecx
  802309:	89 d8                	mov    %ebx,%eax
  80230b:	31 d2                	xor    %edx,%edx
  80230d:	f7 f1                	div    %ecx
  80230f:	89 f0                	mov    %esi,%eax
  802311:	f7 f1                	div    %ecx
  802313:	e9 31 ff ff ff       	jmp    802249 <__umoddi3+0x29>
  802318:	90                   	nop
  802319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802320:	39 dd                	cmp    %ebx,%ebp
  802322:	72 08                	jb     80232c <__umoddi3+0x10c>
  802324:	39 f7                	cmp    %esi,%edi
  802326:	0f 87 21 ff ff ff    	ja     80224d <__umoddi3+0x2d>
  80232c:	89 da                	mov    %ebx,%edx
  80232e:	89 f0                	mov    %esi,%eax
  802330:	29 f8                	sub    %edi,%eax
  802332:	19 ea                	sbb    %ebp,%edx
  802334:	e9 14 ff ff ff       	jmp    80224d <__umoddi3+0x2d>

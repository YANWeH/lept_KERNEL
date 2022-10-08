
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 80 25 80 00       	push   $0x802580
  80003e:	e8 c3 01 00 00       	call   800206 <cprintf>
	exit();
  800043:	e8 0f 01 00 00       	call   800157 <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 c2 0d 00 00       	call   800e2e <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	bf 00 00 00 00       	mov    $0x0,%edi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	be 01 00 00 00       	mov    $0x1,%esi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 d6 0d 00 00       	call   800e5e <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 f7                	mov    %esi,%edi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>

	for (i = 0; i < 32; i++)
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fstat(i, &st) >= 0) {
  8000a4:	8d b5 5c ff ff ff    	lea    -0xa4(%ebp),%esi
  8000aa:	eb 26                	jmp    8000d2 <umain+0x85>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8000b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8000bb:	56                   	push   %esi
  8000bc:	53                   	push   %ebx
  8000bd:	68 94 25 80 00       	push   $0x802594
  8000c2:	e8 3f 01 00 00       	call   800206 <cprintf>
  8000c7:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000ca:	83 c3 01             	add    $0x1,%ebx
  8000cd:	83 fb 20             	cmp    $0x20,%ebx
  8000d0:	74 37                	je     800109 <umain+0xbc>
		if (fstat(i, &st) >= 0) {
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	56                   	push   %esi
  8000d6:	53                   	push   %ebx
  8000d7:	e8 85 13 00 00       	call   801461 <fstat>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	78 e7                	js     8000ca <umain+0x7d>
			if (usefprint)
  8000e3:	85 ff                	test   %edi,%edi
  8000e5:	74 c5                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000e7:	83 ec 04             	sub    $0x4,%esp
  8000ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000ed:	ff 70 04             	pushl  0x4(%eax)
  8000f0:	ff 75 dc             	pushl  -0x24(%ebp)
  8000f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	68 94 25 80 00       	push   $0x802594
  8000fd:	6a 01                	push   $0x1
  8000ff:	e8 57 17 00 00       	call   80185b <fprintf>
  800104:	83 c4 20             	add    $0x20,%esp
  800107:	eb c1                	jmp    8000ca <umain+0x7d>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010c:	5b                   	pop    %ebx
  80010d:	5e                   	pop    %esi
  80010e:	5f                   	pop    %edi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:

const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800119:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80011c:	e8 bf 0a 00 00       	call   800be0 <sys_getenvid>
  800121:	25 ff 03 00 00       	and    $0x3ff,%eax
  800126:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800129:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800133:	85 db                	test   %ebx,%ebx
  800135:	7e 07                	jle    80013e <libmain+0x2d>
		binaryname = argv[0];
  800137:	8b 06                	mov    (%esi),%eax
  800139:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	56                   	push   %esi
  800142:	53                   	push   %ebx
  800143:	e8 05 ff ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  800148:	e8 0a 00 00 00       	call   800157 <exit>
}
  80014d:	83 c4 10             	add    $0x10,%esp
  800150:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800153:	5b                   	pop    %ebx
  800154:	5e                   	pop    %esi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <exit>:

#include <inc/lib.h>

void exit(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80015d:	e8 f6 0f 00 00       	call   801158 <close_all>
	sys_env_destroy(0);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	6a 00                	push   $0x0
  800167:	e8 33 0a 00 00       	call   800b9f <sys_env_destroy>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	c9                   	leave  
  800170:	c3                   	ret    

00800171 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800171:	55                   	push   %ebp
  800172:	89 e5                	mov    %esp,%ebp
  800174:	53                   	push   %ebx
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017b:	8b 13                	mov    (%ebx),%edx
  80017d:	8d 42 01             	lea    0x1(%edx),%eax
  800180:	89 03                	mov    %eax,(%ebx)
  800182:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800185:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800189:	3d ff 00 00 00       	cmp    $0xff,%eax
  80018e:	74 09                	je     800199 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800190:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800197:	c9                   	leave  
  800198:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800199:	83 ec 08             	sub    $0x8,%esp
  80019c:	68 ff 00 00 00       	push   $0xff
  8001a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001a4:	50                   	push   %eax
  8001a5:	e8 b8 09 00 00       	call   800b62 <sys_cputs>
		b->idx = 0;
  8001aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	eb db                	jmp    800190 <putch+0x1f>

008001b5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001be:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c5:	00 00 00 
	b.cnt = 0;
  8001c8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001cf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d2:	ff 75 0c             	pushl  0xc(%ebp)
  8001d5:	ff 75 08             	pushl  0x8(%ebp)
  8001d8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	68 71 01 80 00       	push   $0x800171
  8001e4:	e8 1a 01 00 00       	call   800303 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e9:	83 c4 08             	add    $0x8,%esp
  8001ec:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001f2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f8:	50                   	push   %eax
  8001f9:	e8 64 09 00 00       	call   800b62 <sys_cputs>

	return b.cnt;
}
  8001fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020f:	50                   	push   %eax
  800210:	ff 75 08             	pushl  0x8(%ebp)
  800213:	e8 9d ff ff ff       	call   8001b5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800218:	c9                   	leave  
  800219:	c3                   	ret    

0080021a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80021a:	55                   	push   %ebp
  80021b:	89 e5                	mov    %esp,%ebp
  80021d:	57                   	push   %edi
  80021e:	56                   	push   %esi
  80021f:	53                   	push   %ebx
  800220:	83 ec 1c             	sub    $0x1c,%esp
  800223:	89 c7                	mov    %eax,%edi
  800225:	89 d6                	mov    %edx,%esi
  800227:	8b 45 08             	mov    0x8(%ebp),%eax
  80022a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800230:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800233:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80023e:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800241:	39 d3                	cmp    %edx,%ebx
  800243:	72 05                	jb     80024a <printnum+0x30>
  800245:	39 45 10             	cmp    %eax,0x10(%ebp)
  800248:	77 7a                	ja     8002c4 <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80024a:	83 ec 0c             	sub    $0xc,%esp
  80024d:	ff 75 18             	pushl  0x18(%ebp)
  800250:	8b 45 14             	mov    0x14(%ebp),%eax
  800253:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800256:	53                   	push   %ebx
  800257:	ff 75 10             	pushl  0x10(%ebp)
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800260:	ff 75 e0             	pushl  -0x20(%ebp)
  800263:	ff 75 dc             	pushl  -0x24(%ebp)
  800266:	ff 75 d8             	pushl  -0x28(%ebp)
  800269:	e8 c2 20 00 00       	call   802330 <__udivdi3>
  80026e:	83 c4 18             	add    $0x18,%esp
  800271:	52                   	push   %edx
  800272:	50                   	push   %eax
  800273:	89 f2                	mov    %esi,%edx
  800275:	89 f8                	mov    %edi,%eax
  800277:	e8 9e ff ff ff       	call   80021a <printnum>
  80027c:	83 c4 20             	add    $0x20,%esp
  80027f:	eb 13                	jmp    800294 <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800281:	83 ec 08             	sub    $0x8,%esp
  800284:	56                   	push   %esi
  800285:	ff 75 18             	pushl  0x18(%ebp)
  800288:	ff d7                	call   *%edi
  80028a:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80028d:	83 eb 01             	sub    $0x1,%ebx
  800290:	85 db                	test   %ebx,%ebx
  800292:	7f ed                	jg     800281 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	56                   	push   %esi
  800298:	83 ec 04             	sub    $0x4,%esp
  80029b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029e:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a4:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a7:	e8 a4 21 00 00       	call   802450 <__umoddi3>
  8002ac:	83 c4 14             	add    $0x14,%esp
  8002af:	0f be 80 c6 25 80 00 	movsbl 0x8025c6(%eax),%eax
  8002b6:	50                   	push   %eax
  8002b7:	ff d7                	call   *%edi
}
  8002b9:	83 c4 10             	add    $0x10,%esp
  8002bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002bf:	5b                   	pop    %ebx
  8002c0:	5e                   	pop    %esi
  8002c1:	5f                   	pop    %edi
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
  8002c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002c7:	eb c4                	jmp    80028d <printnum+0x73>

008002c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d3:	8b 10                	mov    (%eax),%edx
  8002d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002d8:	73 0a                	jae    8002e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002dd:	89 08                	mov    %ecx,(%eax)
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	88 02                	mov    %al,(%edx)
}
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <printfmt>:
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ef:	50                   	push   %eax
  8002f0:	ff 75 10             	pushl  0x10(%ebp)
  8002f3:	ff 75 0c             	pushl  0xc(%ebp)
  8002f6:	ff 75 08             	pushl  0x8(%ebp)
  8002f9:	e8 05 00 00 00       	call   800303 <vprintfmt>
}
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <vprintfmt>:
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	57                   	push   %edi
  800307:	56                   	push   %esi
  800308:	53                   	push   %ebx
  800309:	83 ec 2c             	sub    $0x2c,%esp
  80030c:	8b 75 08             	mov    0x8(%ebp),%esi
  80030f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800312:	8b 7d 10             	mov    0x10(%ebp),%edi
  800315:	e9 c1 03 00 00       	jmp    8006db <vprintfmt+0x3d8>
		padc = ' ';
  80031a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
  80031e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
  800325:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
  80032c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800333:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800338:	8d 47 01             	lea    0x1(%edi),%eax
  80033b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033e:	0f b6 17             	movzbl (%edi),%edx
  800341:	8d 42 dd             	lea    -0x23(%edx),%eax
  800344:	3c 55                	cmp    $0x55,%al
  800346:	0f 87 12 04 00 00    	ja     80075e <vprintfmt+0x45b>
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800356:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800359:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80035d:	eb d9                	jmp    800338 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800362:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800366:	eb d0                	jmp    800338 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800368:	0f b6 d2             	movzbl %dl,%edx
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80036e:	b8 00 00 00 00       	mov    $0x0,%eax
  800373:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800376:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800379:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80037d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800380:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800383:	83 f9 09             	cmp    $0x9,%ecx
  800386:	77 55                	ja     8003dd <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
  800388:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038b:	eb e9                	jmp    800376 <vprintfmt+0x73>
			precision = va_arg(ap, int);
  80038d:	8b 45 14             	mov    0x14(%ebp),%eax
  800390:	8b 00                	mov    (%eax),%eax
  800392:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800395:	8b 45 14             	mov    0x14(%ebp),%eax
  800398:	8d 40 04             	lea    0x4(%eax),%eax
  80039b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003a5:	79 91                	jns    800338 <vprintfmt+0x35>
				width = precision, precision = -1;
  8003a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ad:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b4:	eb 82                	jmp    800338 <vprintfmt+0x35>
  8003b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b9:	85 c0                	test   %eax,%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	0f 49 d0             	cmovns %eax,%edx
  8003c3:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003c9:	e9 6a ff ff ff       	jmp    800338 <vprintfmt+0x35>
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003d1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003d8:	e9 5b ff ff ff       	jmp    800338 <vprintfmt+0x35>
  8003dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003e3:	eb bc                	jmp    8003a1 <vprintfmt+0x9e>
			lflag++;
  8003e5:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003eb:	e9 48 ff ff ff       	jmp    800338 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f3:	8d 78 04             	lea    0x4(%eax),%edi
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	53                   	push   %ebx
  8003fa:	ff 30                	pushl  (%eax)
  8003fc:	ff d6                	call   *%esi
			break;
  8003fe:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800401:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800404:	e9 cf 02 00 00       	jmp    8006d8 <vprintfmt+0x3d5>
			err = va_arg(ap, int);
  800409:	8b 45 14             	mov    0x14(%ebp),%eax
  80040c:	8d 78 04             	lea    0x4(%eax),%edi
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	99                   	cltd   
  800412:	31 d0                	xor    %edx,%eax
  800414:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800416:	83 f8 0f             	cmp    $0xf,%eax
  800419:	7f 23                	jg     80043e <vprintfmt+0x13b>
  80041b:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  800422:	85 d2                	test   %edx,%edx
  800424:	74 18                	je     80043e <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
  800426:	52                   	push   %edx
  800427:	68 95 29 80 00       	push   $0x802995
  80042c:	53                   	push   %ebx
  80042d:	56                   	push   %esi
  80042e:	e8 b3 fe ff ff       	call   8002e6 <printfmt>
  800433:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800436:	89 7d 14             	mov    %edi,0x14(%ebp)
  800439:	e9 9a 02 00 00       	jmp    8006d8 <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
  80043e:	50                   	push   %eax
  80043f:	68 de 25 80 00       	push   $0x8025de
  800444:	53                   	push   %ebx
  800445:	56                   	push   %esi
  800446:	e8 9b fe ff ff       	call   8002e6 <printfmt>
  80044b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800451:	e9 82 02 00 00       	jmp    8006d8 <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
  800456:	8b 45 14             	mov    0x14(%ebp),%eax
  800459:	83 c0 04             	add    $0x4,%eax
  80045c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80045f:	8b 45 14             	mov    0x14(%ebp),%eax
  800462:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  800464:	85 ff                	test   %edi,%edi
  800466:	b8 d7 25 80 00       	mov    $0x8025d7,%eax
  80046b:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  80046e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800472:	0f 8e bd 00 00 00    	jle    800535 <vprintfmt+0x232>
  800478:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80047c:	75 0e                	jne    80048c <vprintfmt+0x189>
  80047e:	89 75 08             	mov    %esi,0x8(%ebp)
  800481:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800484:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  800487:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80048a:	eb 6d                	jmp    8004f9 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048c:	83 ec 08             	sub    $0x8,%esp
  80048f:	ff 75 d0             	pushl  -0x30(%ebp)
  800492:	57                   	push   %edi
  800493:	e8 6e 03 00 00       	call   800806 <strnlen>
  800498:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049b:	29 c1                	sub    %eax,%ecx
  80049d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004a0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004a3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004aa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004ad:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004af:	eb 0f                	jmp    8004c0 <vprintfmt+0x1bd>
					putch(padc, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	53                   	push   %ebx
  8004b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8004b8:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	85 ff                	test   %edi,%edi
  8004c2:	7f ed                	jg     8004b1 <vprintfmt+0x1ae>
  8004c4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004c7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004ca:	85 c9                	test   %ecx,%ecx
  8004cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d1:	0f 49 c1             	cmovns %ecx,%eax
  8004d4:	29 c1                	sub    %eax,%ecx
  8004d6:	89 75 08             	mov    %esi,0x8(%ebp)
  8004d9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004dc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004df:	89 cb                	mov    %ecx,%ebx
  8004e1:	eb 16                	jmp    8004f9 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
  8004e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004e7:	75 31                	jne    80051a <vprintfmt+0x217>
					putch(ch, putdat);
  8004e9:	83 ec 08             	sub    $0x8,%esp
  8004ec:	ff 75 0c             	pushl  0xc(%ebp)
  8004ef:	50                   	push   %eax
  8004f0:	ff 55 08             	call   *0x8(%ebp)
  8004f3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f6:	83 eb 01             	sub    $0x1,%ebx
  8004f9:	83 c7 01             	add    $0x1,%edi
  8004fc:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
  800500:	0f be c2             	movsbl %dl,%eax
  800503:	85 c0                	test   %eax,%eax
  800505:	74 59                	je     800560 <vprintfmt+0x25d>
  800507:	85 f6                	test   %esi,%esi
  800509:	78 d8                	js     8004e3 <vprintfmt+0x1e0>
  80050b:	83 ee 01             	sub    $0x1,%esi
  80050e:	79 d3                	jns    8004e3 <vprintfmt+0x1e0>
  800510:	89 df                	mov    %ebx,%edi
  800512:	8b 75 08             	mov    0x8(%ebp),%esi
  800515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800518:	eb 37                	jmp    800551 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
  80051a:	0f be d2             	movsbl %dl,%edx
  80051d:	83 ea 20             	sub    $0x20,%edx
  800520:	83 fa 5e             	cmp    $0x5e,%edx
  800523:	76 c4                	jbe    8004e9 <vprintfmt+0x1e6>
					putch('?', putdat);
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 0c             	pushl  0xc(%ebp)
  80052b:	6a 3f                	push   $0x3f
  80052d:	ff 55 08             	call   *0x8(%ebp)
  800530:	83 c4 10             	add    $0x10,%esp
  800533:	eb c1                	jmp    8004f6 <vprintfmt+0x1f3>
  800535:	89 75 08             	mov    %esi,0x8(%ebp)
  800538:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80053b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  80053e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800541:	eb b6                	jmp    8004f9 <vprintfmt+0x1f6>
				putch(' ', putdat);
  800543:	83 ec 08             	sub    $0x8,%esp
  800546:	53                   	push   %ebx
  800547:	6a 20                	push   $0x20
  800549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054b:	83 ef 01             	sub    $0x1,%edi
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	85 ff                	test   %edi,%edi
  800553:	7f ee                	jg     800543 <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	e9 78 01 00 00       	jmp    8006d8 <vprintfmt+0x3d5>
  800560:	89 df                	mov    %ebx,%edi
  800562:	8b 75 08             	mov    0x8(%ebp),%esi
  800565:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800568:	eb e7                	jmp    800551 <vprintfmt+0x24e>
	if (lflag >= 2)
  80056a:	83 f9 01             	cmp    $0x1,%ecx
  80056d:	7e 3f                	jle    8005ae <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 40 08             	lea    0x8(%eax),%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
  800586:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80058a:	79 5c                	jns    8005e8 <vprintfmt+0x2e5>
				putch('-', putdat);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	53                   	push   %ebx
  800590:	6a 2d                	push   $0x2d
  800592:	ff d6                	call   *%esi
				num = -(long long) num;
  800594:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800597:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059a:	f7 da                	neg    %edx
  80059c:	83 d1 00             	adc    $0x0,%ecx
  80059f:	f7 d9                	neg    %ecx
  8005a1:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a9:	e9 10 01 00 00       	jmp    8006be <vprintfmt+0x3bb>
	else if (lflag)
  8005ae:	85 c9                	test   %ecx,%ecx
  8005b0:	75 1b                	jne    8005cd <vprintfmt+0x2ca>
		return va_arg(*ap, int);
  8005b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	89 c1                	mov    %eax,%ecx
  8005bc:	c1 f9 1f             	sar    $0x1f,%ecx
  8005bf:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cb:	eb b9                	jmp    800586 <vprintfmt+0x283>
		return va_arg(*ap, long);
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d5:	89 c1                	mov    %eax,%ecx
  8005d7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8d 40 04             	lea    0x4(%eax),%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	eb 9e                	jmp    800586 <vprintfmt+0x283>
			num = getint(&ap, lflag);
  8005e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005eb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
  8005ee:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f3:	e9 c6 00 00 00       	jmp    8006be <vprintfmt+0x3bb>
	if (lflag >= 2)
  8005f8:	83 f9 01             	cmp    $0x1,%ecx
  8005fb:	7e 18                	jle    800615 <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	8b 48 04             	mov    0x4(%eax),%ecx
  800605:	8d 40 08             	lea    0x8(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 a9 00 00 00       	jmp    8006be <vprintfmt+0x3bb>
	else if (lflag)
  800615:	85 c9                	test   %ecx,%ecx
  800617:	75 1a                	jne    800633 <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 10                	mov    (%eax),%edx
  80061e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800623:	8d 40 04             	lea    0x4(%eax),%eax
  800626:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800629:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062e:	e9 8b 00 00 00       	jmp    8006be <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	8b 10                	mov    (%eax),%edx
  800638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063d:	8d 40 04             	lea    0x4(%eax),%eax
  800640:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800643:	b8 0a 00 00 00       	mov    $0xa,%eax
  800648:	eb 74                	jmp    8006be <vprintfmt+0x3bb>
	if (lflag >= 2)
  80064a:	83 f9 01             	cmp    $0x1,%ecx
  80064d:	7e 15                	jle    800664 <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8b 10                	mov    (%eax),%edx
  800654:	8b 48 04             	mov    0x4(%eax),%ecx
  800657:	8d 40 08             	lea    0x8(%eax),%eax
  80065a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065d:	b8 08 00 00 00       	mov    $0x8,%eax
  800662:	eb 5a                	jmp    8006be <vprintfmt+0x3bb>
	else if (lflag)
  800664:	85 c9                	test   %ecx,%ecx
  800666:	75 17                	jne    80067f <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800672:	8d 40 04             	lea    0x4(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800678:	b8 08 00 00 00       	mov    $0x8,%eax
  80067d:	eb 3f                	jmp    8006be <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 10                	mov    (%eax),%edx
  800684:	b9 00 00 00 00       	mov    $0x0,%ecx
  800689:	8d 40 04             	lea    0x4(%eax),%eax
  80068c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80068f:	b8 08 00 00 00       	mov    $0x8,%eax
  800694:	eb 28                	jmp    8006be <vprintfmt+0x3bb>
			putch('0', putdat);
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	53                   	push   %ebx
  80069a:	6a 30                	push   $0x30
  80069c:	ff d6                	call   *%esi
			putch('x', putdat);
  80069e:	83 c4 08             	add    $0x8,%esp
  8006a1:	53                   	push   %ebx
  8006a2:	6a 78                	push   $0x78
  8006a4:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006b0:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006b3:	8d 40 04             	lea    0x4(%eax),%eax
  8006b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006b9:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006be:	83 ec 0c             	sub    $0xc,%esp
  8006c1:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006c5:	57                   	push   %edi
  8006c6:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c9:	50                   	push   %eax
  8006ca:	51                   	push   %ecx
  8006cb:	52                   	push   %edx
  8006cc:	89 da                	mov    %ebx,%edx
  8006ce:	89 f0                	mov    %esi,%eax
  8006d0:	e8 45 fb ff ff       	call   80021a <printnum>
			break;
  8006d5:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006db:	83 c7 01             	add    $0x1,%edi
  8006de:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006e2:	83 f8 25             	cmp    $0x25,%eax
  8006e5:	0f 84 2f fc ff ff    	je     80031a <vprintfmt+0x17>
			if (ch == '\0')
  8006eb:	85 c0                	test   %eax,%eax
  8006ed:	0f 84 8b 00 00 00    	je     80077e <vprintfmt+0x47b>
			putch(ch, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	53                   	push   %ebx
  8006f7:	50                   	push   %eax
  8006f8:	ff d6                	call   *%esi
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	eb dc                	jmp    8006db <vprintfmt+0x3d8>
	if (lflag >= 2)
  8006ff:	83 f9 01             	cmp    $0x1,%ecx
  800702:	7e 15                	jle    800719 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8b 10                	mov    (%eax),%edx
  800709:	8b 48 04             	mov    0x4(%eax),%ecx
  80070c:	8d 40 08             	lea    0x8(%eax),%eax
  80070f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800712:	b8 10 00 00 00       	mov    $0x10,%eax
  800717:	eb a5                	jmp    8006be <vprintfmt+0x3bb>
	else if (lflag)
  800719:	85 c9                	test   %ecx,%ecx
  80071b:	75 17                	jne    800734 <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 10                	mov    (%eax),%edx
  800722:	b9 00 00 00 00       	mov    $0x0,%ecx
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072d:	b8 10 00 00 00       	mov    $0x10,%eax
  800732:	eb 8a                	jmp    8006be <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8b 10                	mov    (%eax),%edx
  800739:	b9 00 00 00 00       	mov    $0x0,%ecx
  80073e:	8d 40 04             	lea    0x4(%eax),%eax
  800741:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800744:	b8 10 00 00 00       	mov    $0x10,%eax
  800749:	e9 70 ff ff ff       	jmp    8006be <vprintfmt+0x3bb>
			putch(ch, putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	53                   	push   %ebx
  800752:	6a 25                	push   $0x25
  800754:	ff d6                	call   *%esi
			break;
  800756:	83 c4 10             	add    $0x10,%esp
  800759:	e9 7a ff ff ff       	jmp    8006d8 <vprintfmt+0x3d5>
			putch('%', putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	53                   	push   %ebx
  800762:	6a 25                	push   $0x25
  800764:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800766:	83 c4 10             	add    $0x10,%esp
  800769:	89 f8                	mov    %edi,%eax
  80076b:	eb 03                	jmp    800770 <vprintfmt+0x46d>
  80076d:	83 e8 01             	sub    $0x1,%eax
  800770:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800774:	75 f7                	jne    80076d <vprintfmt+0x46a>
  800776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800779:	e9 5a ff ff ff       	jmp    8006d8 <vprintfmt+0x3d5>
}
  80077e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800781:	5b                   	pop    %ebx
  800782:	5e                   	pop    %esi
  800783:	5f                   	pop    %edi
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	83 ec 18             	sub    $0x18,%esp
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800792:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800795:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800799:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80079c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007a3:	85 c0                	test   %eax,%eax
  8007a5:	74 26                	je     8007cd <vsnprintf+0x47>
  8007a7:	85 d2                	test   %edx,%edx
  8007a9:	7e 22                	jle    8007cd <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007ab:	ff 75 14             	pushl  0x14(%ebp)
  8007ae:	ff 75 10             	pushl  0x10(%ebp)
  8007b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	68 c9 02 80 00       	push   $0x8002c9
  8007ba:	e8 44 fb ff ff       	call   800303 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c8:	83 c4 10             	add    $0x10,%esp
}
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    
		return -E_INVAL;
  8007cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007d2:	eb f7                	jmp    8007cb <vsnprintf+0x45>

008007d4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007da:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007dd:	50                   	push   %eax
  8007de:	ff 75 10             	pushl  0x10(%ebp)
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	ff 75 08             	pushl  0x8(%ebp)
  8007e7:	e8 9a ff ff ff       	call   800786 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007ec:	c9                   	leave  
  8007ed:	c3                   	ret    

008007ee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007ee:	55                   	push   %ebp
  8007ef:	89 e5                	mov    %esp,%ebp
  8007f1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f9:	eb 03                	jmp    8007fe <strlen+0x10>
		n++;
  8007fb:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
  8007fe:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800802:	75 f7                	jne    8007fb <strlen+0xd>
	return n;
}
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080f:	b8 00 00 00 00       	mov    $0x0,%eax
  800814:	eb 03                	jmp    800819 <strnlen+0x13>
		n++;
  800816:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800819:	39 d0                	cmp    %edx,%eax
  80081b:	74 06                	je     800823 <strnlen+0x1d>
  80081d:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800821:	75 f3                	jne    800816 <strnlen+0x10>
	return n;
}
  800823:	5d                   	pop    %ebp
  800824:	c3                   	ret    

00800825 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800825:	55                   	push   %ebp
  800826:	89 e5                	mov    %esp,%ebp
  800828:	53                   	push   %ebx
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80082f:	89 c2                	mov    %eax,%edx
  800831:	83 c1 01             	add    $0x1,%ecx
  800834:	83 c2 01             	add    $0x1,%edx
  800837:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80083b:	88 5a ff             	mov    %bl,-0x1(%edx)
  80083e:	84 db                	test   %bl,%bl
  800840:	75 ef                	jne    800831 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800842:	5b                   	pop    %ebx
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	53                   	push   %ebx
  800849:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80084c:	53                   	push   %ebx
  80084d:	e8 9c ff ff ff       	call   8007ee <strlen>
  800852:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800855:	ff 75 0c             	pushl  0xc(%ebp)
  800858:	01 d8                	add    %ebx,%eax
  80085a:	50                   	push   %eax
  80085b:	e8 c5 ff ff ff       	call   800825 <strcpy>
	return dst;
}
  800860:	89 d8                	mov    %ebx,%eax
  800862:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800865:	c9                   	leave  
  800866:	c3                   	ret    

00800867 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	56                   	push   %esi
  80086b:	53                   	push   %ebx
  80086c:	8b 75 08             	mov    0x8(%ebp),%esi
  80086f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800872:	89 f3                	mov    %esi,%ebx
  800874:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800877:	89 f2                	mov    %esi,%edx
  800879:	eb 0f                	jmp    80088a <strncpy+0x23>
		*dst++ = *src;
  80087b:	83 c2 01             	add    $0x1,%edx
  80087e:	0f b6 01             	movzbl (%ecx),%eax
  800881:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800884:	80 39 01             	cmpb   $0x1,(%ecx)
  800887:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80088a:	39 da                	cmp    %ebx,%edx
  80088c:	75 ed                	jne    80087b <strncpy+0x14>
	}
	return ret;
}
  80088e:	89 f0                	mov    %esi,%eax
  800890:	5b                   	pop    %ebx
  800891:	5e                   	pop    %esi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	56                   	push   %esi
  800898:	53                   	push   %ebx
  800899:	8b 75 08             	mov    0x8(%ebp),%esi
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a8:	85 c9                	test   %ecx,%ecx
  8008aa:	75 0b                	jne    8008b7 <strlcpy+0x23>
  8008ac:	eb 17                	jmp    8008c5 <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008ae:	83 c2 01             	add    $0x1,%edx
  8008b1:	83 c0 01             	add    $0x1,%eax
  8008b4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008b7:	39 d8                	cmp    %ebx,%eax
  8008b9:	74 07                	je     8008c2 <strlcpy+0x2e>
  8008bb:	0f b6 0a             	movzbl (%edx),%ecx
  8008be:	84 c9                	test   %cl,%cl
  8008c0:	75 ec                	jne    8008ae <strlcpy+0x1a>
		*dst = '\0';
  8008c2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008c5:	29 f0                	sub    %esi,%eax
}
  8008c7:	5b                   	pop    %ebx
  8008c8:	5e                   	pop    %esi
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d1:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d4:	eb 06                	jmp    8008dc <strcmp+0x11>
		p++, q++;
  8008d6:	83 c1 01             	add    $0x1,%ecx
  8008d9:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
  8008dc:	0f b6 01             	movzbl (%ecx),%eax
  8008df:	84 c0                	test   %al,%al
  8008e1:	74 04                	je     8008e7 <strcmp+0x1c>
  8008e3:	3a 02                	cmp    (%edx),%al
  8008e5:	74 ef                	je     8008d6 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e7:	0f b6 c0             	movzbl %al,%eax
  8008ea:	0f b6 12             	movzbl (%edx),%edx
  8008ed:	29 d0                	sub    %edx,%eax
}
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fb:	89 c3                	mov    %eax,%ebx
  8008fd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800900:	eb 06                	jmp    800908 <strncmp+0x17>
		n--, p++, q++;
  800902:	83 c0 01             	add    $0x1,%eax
  800905:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800908:	39 d8                	cmp    %ebx,%eax
  80090a:	74 16                	je     800922 <strncmp+0x31>
  80090c:	0f b6 08             	movzbl (%eax),%ecx
  80090f:	84 c9                	test   %cl,%cl
  800911:	74 04                	je     800917 <strncmp+0x26>
  800913:	3a 0a                	cmp    (%edx),%cl
  800915:	74 eb                	je     800902 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800917:	0f b6 00             	movzbl (%eax),%eax
  80091a:	0f b6 12             	movzbl (%edx),%edx
  80091d:	29 d0                	sub    %edx,%eax
}
  80091f:	5b                   	pop    %ebx
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    
		return 0;
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
  800927:	eb f6                	jmp    80091f <strncmp+0x2e>

00800929 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800933:	0f b6 10             	movzbl (%eax),%edx
  800936:	84 d2                	test   %dl,%dl
  800938:	74 09                	je     800943 <strchr+0x1a>
		if (*s == c)
  80093a:	38 ca                	cmp    %cl,%dl
  80093c:	74 0a                	je     800948 <strchr+0x1f>
	for (; *s; s++)
  80093e:	83 c0 01             	add    $0x1,%eax
  800941:	eb f0                	jmp    800933 <strchr+0xa>
			return (char *) s;
	return 0;
  800943:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800954:	eb 03                	jmp    800959 <strfind+0xf>
  800956:	83 c0 01             	add    $0x1,%eax
  800959:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  80095c:	38 ca                	cmp    %cl,%dl
  80095e:	74 04                	je     800964 <strfind+0x1a>
  800960:	84 d2                	test   %dl,%dl
  800962:	75 f2                	jne    800956 <strfind+0xc>
			break;
	return (char *) s;
}
  800964:	5d                   	pop    %ebp
  800965:	c3                   	ret    

00800966 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800966:	55                   	push   %ebp
  800967:	89 e5                	mov    %esp,%ebp
  800969:	57                   	push   %edi
  80096a:	56                   	push   %esi
  80096b:	53                   	push   %ebx
  80096c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80096f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800972:	85 c9                	test   %ecx,%ecx
  800974:	74 13                	je     800989 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800976:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097c:	75 05                	jne    800983 <memset+0x1d>
  80097e:	f6 c1 03             	test   $0x3,%cl
  800981:	74 0d                	je     800990 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800983:	8b 45 0c             	mov    0xc(%ebp),%eax
  800986:	fc                   	cld    
  800987:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800989:	89 f8                	mov    %edi,%eax
  80098b:	5b                   	pop    %ebx
  80098c:	5e                   	pop    %esi
  80098d:	5f                   	pop    %edi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    
		c &= 0xFF;
  800990:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800994:	89 d3                	mov    %edx,%ebx
  800996:	c1 e3 08             	shl    $0x8,%ebx
  800999:	89 d0                	mov    %edx,%eax
  80099b:	c1 e0 18             	shl    $0x18,%eax
  80099e:	89 d6                	mov    %edx,%esi
  8009a0:	c1 e6 10             	shl    $0x10,%esi
  8009a3:	09 f0                	or     %esi,%eax
  8009a5:	09 c2                	or     %eax,%edx
  8009a7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009a9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009ac:	89 d0                	mov    %edx,%eax
  8009ae:	fc                   	cld    
  8009af:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b1:	eb d6                	jmp    800989 <memset+0x23>

008009b3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b3:	55                   	push   %ebp
  8009b4:	89 e5                	mov    %esp,%ebp
  8009b6:	57                   	push   %edi
  8009b7:	56                   	push   %esi
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009be:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c1:	39 c6                	cmp    %eax,%esi
  8009c3:	73 35                	jae    8009fa <memmove+0x47>
  8009c5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c8:	39 c2                	cmp    %eax,%edx
  8009ca:	76 2e                	jbe    8009fa <memmove+0x47>
		s += n;
		d += n;
  8009cc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cf:	89 d6                	mov    %edx,%esi
  8009d1:	09 fe                	or     %edi,%esi
  8009d3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009d9:	74 0c                	je     8009e7 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009db:	83 ef 01             	sub    $0x1,%edi
  8009de:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e1:	fd                   	std    
  8009e2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e4:	fc                   	cld    
  8009e5:	eb 21                	jmp    800a08 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e7:	f6 c1 03             	test   $0x3,%cl
  8009ea:	75 ef                	jne    8009db <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009ec:	83 ef 04             	sub    $0x4,%edi
  8009ef:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009f5:	fd                   	std    
  8009f6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f8:	eb ea                	jmp    8009e4 <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009fa:	89 f2                	mov    %esi,%edx
  8009fc:	09 c2                	or     %eax,%edx
  8009fe:	f6 c2 03             	test   $0x3,%dl
  800a01:	74 09                	je     800a0c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a03:	89 c7                	mov    %eax,%edi
  800a05:	fc                   	cld    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a08:	5e                   	pop    %esi
  800a09:	5f                   	pop    %edi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0c:	f6 c1 03             	test   $0x3,%cl
  800a0f:	75 f2                	jne    800a03 <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a11:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a14:	89 c7                	mov    %eax,%edi
  800a16:	fc                   	cld    
  800a17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a19:	eb ed                	jmp    800a08 <memmove+0x55>

00800a1b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a1e:	ff 75 10             	pushl  0x10(%ebp)
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	ff 75 08             	pushl  0x8(%ebp)
  800a27:	e8 87 ff ff ff       	call   8009b3 <memmove>
}
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	56                   	push   %esi
  800a32:	53                   	push   %ebx
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a39:	89 c6                	mov    %eax,%esi
  800a3b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a3e:	39 f0                	cmp    %esi,%eax
  800a40:	74 1c                	je     800a5e <memcmp+0x30>
		if (*s1 != *s2)
  800a42:	0f b6 08             	movzbl (%eax),%ecx
  800a45:	0f b6 1a             	movzbl (%edx),%ebx
  800a48:	38 d9                	cmp    %bl,%cl
  800a4a:	75 08                	jne    800a54 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a4c:	83 c0 01             	add    $0x1,%eax
  800a4f:	83 c2 01             	add    $0x1,%edx
  800a52:	eb ea                	jmp    800a3e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a54:	0f b6 c1             	movzbl %cl,%eax
  800a57:	0f b6 db             	movzbl %bl,%ebx
  800a5a:	29 d8                	sub    %ebx,%eax
  800a5c:	eb 05                	jmp    800a63 <memcmp+0x35>
	}

	return 0;
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a63:	5b                   	pop    %ebx
  800a64:	5e                   	pop    %esi
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a70:	89 c2                	mov    %eax,%edx
  800a72:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a75:	39 d0                	cmp    %edx,%eax
  800a77:	73 09                	jae    800a82 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a79:	38 08                	cmp    %cl,(%eax)
  800a7b:	74 05                	je     800a82 <memfind+0x1b>
	for (; s < ends; s++)
  800a7d:	83 c0 01             	add    $0x1,%eax
  800a80:	eb f3                	jmp    800a75 <memfind+0xe>
			break;
	return (void *) s;
}
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	53                   	push   %ebx
  800a8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a90:	eb 03                	jmp    800a95 <strtol+0x11>
		s++;
  800a92:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800a95:	0f b6 01             	movzbl (%ecx),%eax
  800a98:	3c 20                	cmp    $0x20,%al
  800a9a:	74 f6                	je     800a92 <strtol+0xe>
  800a9c:	3c 09                	cmp    $0x9,%al
  800a9e:	74 f2                	je     800a92 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800aa0:	3c 2b                	cmp    $0x2b,%al
  800aa2:	74 2e                	je     800ad2 <strtol+0x4e>
	int neg = 0;
  800aa4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800aa9:	3c 2d                	cmp    $0x2d,%al
  800aab:	74 2f                	je     800adc <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aad:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800ab3:	75 05                	jne    800aba <strtol+0x36>
  800ab5:	80 39 30             	cmpb   $0x30,(%ecx)
  800ab8:	74 2c                	je     800ae6 <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	75 0a                	jne    800ac8 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800abe:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
  800ac3:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac6:	74 28                	je     800af0 <strtol+0x6c>
		base = 10;
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  800acd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ad0:	eb 50                	jmp    800b22 <strtol+0x9e>
		s++;
  800ad2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ad5:	bf 00 00 00 00       	mov    $0x0,%edi
  800ada:	eb d1                	jmp    800aad <strtol+0x29>
		s++, neg = 1;
  800adc:	83 c1 01             	add    $0x1,%ecx
  800adf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae4:	eb c7                	jmp    800aad <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aea:	74 0e                	je     800afa <strtol+0x76>
	else if (base == 0 && s[0] == '0')
  800aec:	85 db                	test   %ebx,%ebx
  800aee:	75 d8                	jne    800ac8 <strtol+0x44>
		s++, base = 8;
  800af0:	83 c1 01             	add    $0x1,%ecx
  800af3:	bb 08 00 00 00       	mov    $0x8,%ebx
  800af8:	eb ce                	jmp    800ac8 <strtol+0x44>
		s += 2, base = 16;
  800afa:	83 c1 02             	add    $0x2,%ecx
  800afd:	bb 10 00 00 00       	mov    $0x10,%ebx
  800b02:	eb c4                	jmp    800ac8 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b04:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b07:	89 f3                	mov    %esi,%ebx
  800b09:	80 fb 19             	cmp    $0x19,%bl
  800b0c:	77 29                	ja     800b37 <strtol+0xb3>
			dig = *s - 'a' + 10;
  800b0e:	0f be d2             	movsbl %dl,%edx
  800b11:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b14:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b17:	7d 30                	jge    800b49 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  800b19:	83 c1 01             	add    $0x1,%ecx
  800b1c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b20:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b22:	0f b6 11             	movzbl (%ecx),%edx
  800b25:	8d 72 d0             	lea    -0x30(%edx),%esi
  800b28:	89 f3                	mov    %esi,%ebx
  800b2a:	80 fb 09             	cmp    $0x9,%bl
  800b2d:	77 d5                	ja     800b04 <strtol+0x80>
			dig = *s - '0';
  800b2f:	0f be d2             	movsbl %dl,%edx
  800b32:	83 ea 30             	sub    $0x30,%edx
  800b35:	eb dd                	jmp    800b14 <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
  800b37:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b3a:	89 f3                	mov    %esi,%ebx
  800b3c:	80 fb 19             	cmp    $0x19,%bl
  800b3f:	77 08                	ja     800b49 <strtol+0xc5>
			dig = *s - 'A' + 10;
  800b41:	0f be d2             	movsbl %dl,%edx
  800b44:	83 ea 37             	sub    $0x37,%edx
  800b47:	eb cb                	jmp    800b14 <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4d:	74 05                	je     800b54 <strtol+0xd0>
		*endptr = (char *) s;
  800b4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b52:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b54:	89 c2                	mov    %eax,%edx
  800b56:	f7 da                	neg    %edx
  800b58:	85 ff                	test   %edi,%edi
  800b5a:	0f 45 c2             	cmovne %edx,%eax
}
  800b5d:	5b                   	pop    %ebx
  800b5e:	5e                   	pop    %esi
  800b5f:	5f                   	pop    %edi
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    

00800b62 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b62:	55                   	push   %ebp
  800b63:	89 e5                	mov    %esp,%ebp
  800b65:	57                   	push   %edi
  800b66:	56                   	push   %esi
  800b67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b68:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b73:	89 c3                	mov    %eax,%ebx
  800b75:	89 c7                	mov    %eax,%edi
  800b77:	89 c6                	mov    %eax,%esi
  800b79:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5f                   	pop    %edi
  800b7e:	5d                   	pop    %ebp
  800b7f:	c3                   	ret    

00800b80 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b86:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8b:	b8 01 00 00 00       	mov    $0x1,%eax
  800b90:	89 d1                	mov    %edx,%ecx
  800b92:	89 d3                	mov    %edx,%ebx
  800b94:	89 d7                	mov    %edx,%edi
  800b96:	89 d6                	mov    %edx,%esi
  800b98:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5f                   	pop    %edi
  800b9d:	5d                   	pop    %ebp
  800b9e:	c3                   	ret    

00800b9f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b9f:	55                   	push   %ebp
  800ba0:	89 e5                	mov    %esp,%ebp
  800ba2:	57                   	push   %edi
  800ba3:	56                   	push   %esi
  800ba4:	53                   	push   %ebx
  800ba5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bad:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb5:	89 cb                	mov    %ecx,%ebx
  800bb7:	89 cf                	mov    %ecx,%edi
  800bb9:	89 ce                	mov    %ecx,%esi
  800bbb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	7f 08                	jg     800bc9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc9:	83 ec 0c             	sub    $0xc,%esp
  800bcc:	50                   	push   %eax
  800bcd:	6a 03                	push   $0x3
  800bcf:	68 bf 28 80 00       	push   $0x8028bf
  800bd4:	6a 23                	push   $0x23
  800bd6:	68 dc 28 80 00       	push   $0x8028dc
  800bdb:	e8 d7 15 00 00       	call   8021b7 <_panic>

00800be0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be6:	ba 00 00 00 00       	mov    $0x0,%edx
  800beb:	b8 02 00 00 00       	mov    $0x2,%eax
  800bf0:	89 d1                	mov    %edx,%ecx
  800bf2:	89 d3                	mov    %edx,%ebx
  800bf4:	89 d7                	mov    %edx,%edi
  800bf6:	89 d6                	mov    %edx,%esi
  800bf8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <sys_yield>:

void
sys_yield(void)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	57                   	push   %edi
  800c03:	56                   	push   %esi
  800c04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c05:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0f:	89 d1                	mov    %edx,%ecx
  800c11:	89 d3                	mov    %edx,%ebx
  800c13:	89 d7                	mov    %edx,%edi
  800c15:	89 d6                	mov    %edx,%esi
  800c17:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c19:	5b                   	pop    %ebx
  800c1a:	5e                   	pop    %esi
  800c1b:	5f                   	pop    %edi
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c27:	be 00 00 00 00       	mov    $0x0,%esi
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c32:	b8 04 00 00 00       	mov    $0x4,%eax
  800c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3a:	89 f7                	mov    %esi,%edi
  800c3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	7f 08                	jg     800c4a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 04                	push   $0x4
  800c50:	68 bf 28 80 00       	push   $0x8028bf
  800c55:	6a 23                	push   $0x23
  800c57:	68 dc 28 80 00       	push   $0x8028dc
  800c5c:	e8 56 15 00 00       	call   8021b7 <_panic>

00800c61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
  800c67:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	b8 05 00 00 00       	mov    $0x5,%eax
  800c75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c78:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c7b:	8b 75 18             	mov    0x18(%ebp),%esi
  800c7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c80:	85 c0                	test   %eax,%eax
  800c82:	7f 08                	jg     800c8c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c87:	5b                   	pop    %ebx
  800c88:	5e                   	pop    %esi
  800c89:	5f                   	pop    %edi
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	50                   	push   %eax
  800c90:	6a 05                	push   $0x5
  800c92:	68 bf 28 80 00       	push   $0x8028bf
  800c97:	6a 23                	push   $0x23
  800c99:	68 dc 28 80 00       	push   $0x8028dc
  800c9e:	e8 14 15 00 00       	call   8021b7 <_panic>

00800ca3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbc:	89 df                	mov    %ebx,%edi
  800cbe:	89 de                	mov    %ebx,%esi
  800cc0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc2:	85 c0                	test   %eax,%eax
  800cc4:	7f 08                	jg     800cce <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 06                	push   $0x6
  800cd4:	68 bf 28 80 00       	push   $0x8028bf
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 dc 28 80 00       	push   $0x8028dc
  800ce0:	e8 d2 14 00 00       	call   8021b7 <_panic>

00800ce5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cee:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf9:	b8 08 00 00 00       	mov    $0x8,%eax
  800cfe:	89 df                	mov    %ebx,%edi
  800d00:	89 de                	mov    %ebx,%esi
  800d02:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d04:	85 c0                	test   %eax,%eax
  800d06:	7f 08                	jg     800d10 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0b:	5b                   	pop    %ebx
  800d0c:	5e                   	pop    %esi
  800d0d:	5f                   	pop    %edi
  800d0e:	5d                   	pop    %ebp
  800d0f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d10:	83 ec 0c             	sub    $0xc,%esp
  800d13:	50                   	push   %eax
  800d14:	6a 08                	push   $0x8
  800d16:	68 bf 28 80 00       	push   $0x8028bf
  800d1b:	6a 23                	push   $0x23
  800d1d:	68 dc 28 80 00       	push   $0x8028dc
  800d22:	e8 90 14 00 00       	call   8021b7 <_panic>

00800d27 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 09 00 00 00       	mov    $0x9,%eax
  800d40:	89 df                	mov    %ebx,%edi
  800d42:	89 de                	mov    %ebx,%esi
  800d44:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d46:	85 c0                	test   %eax,%eax
  800d48:	7f 08                	jg     800d52 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	5d                   	pop    %ebp
  800d51:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	50                   	push   %eax
  800d56:	6a 09                	push   $0x9
  800d58:	68 bf 28 80 00       	push   $0x8028bf
  800d5d:	6a 23                	push   $0x23
  800d5f:	68 dc 28 80 00       	push   $0x8028dc
  800d64:	e8 4e 14 00 00       	call   8021b7 <_panic>

00800d69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	57                   	push   %edi
  800d6d:	56                   	push   %esi
  800d6e:	53                   	push   %ebx
  800d6f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d77:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d82:	89 df                	mov    %ebx,%edi
  800d84:	89 de                	mov    %ebx,%esi
  800d86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	7f 08                	jg     800d94 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d94:	83 ec 0c             	sub    $0xc,%esp
  800d97:	50                   	push   %eax
  800d98:	6a 0a                	push   $0xa
  800d9a:	68 bf 28 80 00       	push   $0x8028bf
  800d9f:	6a 23                	push   $0x23
  800da1:	68 dc 28 80 00       	push   $0x8028dc
  800da6:	e8 0c 14 00 00       	call   8021b7 <_panic>

00800dab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dbc:	be 00 00 00 00       	mov    $0x0,%esi
  800dc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc9:	5b                   	pop    %ebx
  800dca:	5e                   	pop    %esi
  800dcb:	5f                   	pop    %edi
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	57                   	push   %edi
  800dd2:	56                   	push   %esi
  800dd3:	53                   	push   %ebx
  800dd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de4:	89 cb                	mov    %ecx,%ebx
  800de6:	89 cf                	mov    %ecx,%edi
  800de8:	89 ce                	mov    %ecx,%esi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 0d                	push   $0xd
  800dfe:	68 bf 28 80 00       	push   $0x8028bf
  800e03:	6a 23                	push   $0x23
  800e05:	68 dc 28 80 00       	push   $0x8028dc
  800e0a:	e8 a8 13 00 00       	call   8021b7 <_panic>

00800e0f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e15:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e1f:	89 d1                	mov    %edx,%ecx
  800e21:	89 d3                	mov    %edx,%ebx
  800e23:	89 d7                	mov    %edx,%edi
  800e25:	89 d6                	mov    %edx,%esi
  800e27:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800e3a:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800e3c:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800e3f:	83 3a 01             	cmpl   $0x1,(%edx)
  800e42:	7e 09                	jle    800e4d <argstart+0x1f>
  800e44:	ba 91 25 80 00       	mov    $0x802591,%edx
  800e49:	85 c9                	test   %ecx,%ecx
  800e4b:	75 05                	jne    800e52 <argstart+0x24>
  800e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e52:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800e55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800e5c:	5d                   	pop    %ebp
  800e5d:	c3                   	ret    

00800e5e <argnext>:

int
argnext(struct Argstate *args)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	53                   	push   %ebx
  800e62:	83 ec 04             	sub    $0x4,%esp
  800e65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800e68:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800e6f:	8b 43 08             	mov    0x8(%ebx),%eax
  800e72:	85 c0                	test   %eax,%eax
  800e74:	74 72                	je     800ee8 <argnext+0x8a>
		return -1;

	if (!*args->curarg) {
  800e76:	80 38 00             	cmpb   $0x0,(%eax)
  800e79:	75 48                	jne    800ec3 <argnext+0x65>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800e7b:	8b 0b                	mov    (%ebx),%ecx
  800e7d:	83 39 01             	cmpl   $0x1,(%ecx)
  800e80:	74 58                	je     800eda <argnext+0x7c>
		    || args->argv[1][0] != '-'
  800e82:	8b 53 04             	mov    0x4(%ebx),%edx
  800e85:	8b 42 04             	mov    0x4(%edx),%eax
  800e88:	80 38 2d             	cmpb   $0x2d,(%eax)
  800e8b:	75 4d                	jne    800eda <argnext+0x7c>
		    || args->argv[1][1] == '\0')
  800e8d:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800e91:	74 47                	je     800eda <argnext+0x7c>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800e93:	83 c0 01             	add    $0x1,%eax
  800e96:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800e99:	83 ec 04             	sub    $0x4,%esp
  800e9c:	8b 01                	mov    (%ecx),%eax
  800e9e:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800ea5:	50                   	push   %eax
  800ea6:	8d 42 08             	lea    0x8(%edx),%eax
  800ea9:	50                   	push   %eax
  800eaa:	83 c2 04             	add    $0x4,%edx
  800ead:	52                   	push   %edx
  800eae:	e8 00 fb ff ff       	call   8009b3 <memmove>
		(*args->argc)--;
  800eb3:	8b 03                	mov    (%ebx),%eax
  800eb5:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800eb8:	8b 43 08             	mov    0x8(%ebx),%eax
  800ebb:	83 c4 10             	add    $0x10,%esp
  800ebe:	80 38 2d             	cmpb   $0x2d,(%eax)
  800ec1:	74 11                	je     800ed4 <argnext+0x76>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800ec3:	8b 53 08             	mov    0x8(%ebx),%edx
  800ec6:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800ec9:	83 c2 01             	add    $0x1,%edx
  800ecc:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ed2:	c9                   	leave  
  800ed3:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800ed4:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800ed8:	75 e9                	jne    800ec3 <argnext+0x65>
	args->curarg = 0;
  800eda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800ee6:	eb e7                	jmp    800ecf <argnext+0x71>
		return -1;
  800ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800eed:	eb e0                	jmp    800ecf <argnext+0x71>

00800eef <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 04             	sub    $0x4,%esp
  800ef6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800ef9:	8b 43 08             	mov    0x8(%ebx),%eax
  800efc:	85 c0                	test   %eax,%eax
  800efe:	74 5b                	je     800f5b <argnextvalue+0x6c>
		return 0;
	if (*args->curarg) {
  800f00:	80 38 00             	cmpb   $0x0,(%eax)
  800f03:	74 12                	je     800f17 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800f05:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800f08:	c7 43 08 91 25 80 00 	movl   $0x802591,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800f0f:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    
	} else if (*args->argc > 1) {
  800f17:	8b 13                	mov    (%ebx),%edx
  800f19:	83 3a 01             	cmpl   $0x1,(%edx)
  800f1c:	7f 10                	jg     800f2e <argnextvalue+0x3f>
		args->argvalue = 0;
  800f1e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800f25:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800f2c:	eb e1                	jmp    800f0f <argnextvalue+0x20>
		args->argvalue = args->argv[1];
  800f2e:	8b 43 04             	mov    0x4(%ebx),%eax
  800f31:	8b 48 04             	mov    0x4(%eax),%ecx
  800f34:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f37:	83 ec 04             	sub    $0x4,%esp
  800f3a:	8b 12                	mov    (%edx),%edx
  800f3c:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800f43:	52                   	push   %edx
  800f44:	8d 50 08             	lea    0x8(%eax),%edx
  800f47:	52                   	push   %edx
  800f48:	83 c0 04             	add    $0x4,%eax
  800f4b:	50                   	push   %eax
  800f4c:	e8 62 fa ff ff       	call   8009b3 <memmove>
		(*args->argc)--;
  800f51:	8b 03                	mov    (%ebx),%eax
  800f53:	83 28 01             	subl   $0x1,(%eax)
  800f56:	83 c4 10             	add    $0x10,%esp
  800f59:	eb b4                	jmp    800f0f <argnextvalue+0x20>
		return 0;
  800f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f60:	eb b0                	jmp    800f12 <argnextvalue+0x23>

00800f62 <argvalue>:
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	8b 55 08             	mov    0x8(%ebp),%edx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f6b:	8b 42 0c             	mov    0xc(%edx),%eax
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	74 02                	je     800f74 <argvalue+0x12>
}
  800f72:	c9                   	leave  
  800f73:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800f74:	83 ec 0c             	sub    $0xc,%esp
  800f77:	52                   	push   %edx
  800f78:	e8 72 ff ff ff       	call   800eef <argnextvalue>
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	eb f0                	jmp    800f72 <argvalue+0x10>

00800f82 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	05 00 00 00 30       	add    $0x30000000,%eax
  800f8d:	c1 e8 0c             	shr    $0xc,%eax
}
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800f9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fa2:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800faf:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fb4:	89 c2                	mov    %eax,%edx
  800fb6:	c1 ea 16             	shr    $0x16,%edx
  800fb9:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fc0:	f6 c2 01             	test   $0x1,%dl
  800fc3:	74 2a                	je     800fef <fd_alloc+0x46>
  800fc5:	89 c2                	mov    %eax,%edx
  800fc7:	c1 ea 0c             	shr    $0xc,%edx
  800fca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd1:	f6 c2 01             	test   $0x1,%dl
  800fd4:	74 19                	je     800fef <fd_alloc+0x46>
  800fd6:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800fdb:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fe0:	75 d2                	jne    800fb4 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fe2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fe8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800fed:	eb 07                	jmp    800ff6 <fd_alloc+0x4d>
			*fd_store = fd;
  800fef:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ff1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ffe:	83 f8 1f             	cmp    $0x1f,%eax
  801001:	77 36                	ja     801039 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801003:	c1 e0 0c             	shl    $0xc,%eax
  801006:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80100b:	89 c2                	mov    %eax,%edx
  80100d:	c1 ea 16             	shr    $0x16,%edx
  801010:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801017:	f6 c2 01             	test   $0x1,%dl
  80101a:	74 24                	je     801040 <fd_lookup+0x48>
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	c1 ea 0c             	shr    $0xc,%edx
  801021:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801028:	f6 c2 01             	test   $0x1,%dl
  80102b:	74 1a                	je     801047 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80102d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801030:	89 02                	mov    %eax,(%edx)
	return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    
		return -E_INVAL;
  801039:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80103e:	eb f7                	jmp    801037 <fd_lookup+0x3f>
		return -E_INVAL;
  801040:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801045:	eb f0                	jmp    801037 <fd_lookup+0x3f>
  801047:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80104c:	eb e9                	jmp    801037 <fd_lookup+0x3f>

0080104e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 08             	sub    $0x8,%esp
  801054:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801057:	ba 68 29 80 00       	mov    $0x802968,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80105c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801061:	39 08                	cmp    %ecx,(%eax)
  801063:	74 33                	je     801098 <dev_lookup+0x4a>
  801065:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801068:	8b 02                	mov    (%edx),%eax
  80106a:	85 c0                	test   %eax,%eax
  80106c:	75 f3                	jne    801061 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80106e:	a1 08 40 80 00       	mov    0x804008,%eax
  801073:	8b 40 48             	mov    0x48(%eax),%eax
  801076:	83 ec 04             	sub    $0x4,%esp
  801079:	51                   	push   %ecx
  80107a:	50                   	push   %eax
  80107b:	68 ec 28 80 00       	push   $0x8028ec
  801080:	e8 81 f1 ff ff       	call   800206 <cprintf>
	*dev = 0;
  801085:	8b 45 0c             	mov    0xc(%ebp),%eax
  801088:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80108e:	83 c4 10             	add    $0x10,%esp
  801091:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801096:	c9                   	leave  
  801097:	c3                   	ret    
			*dev = devtab[i];
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80109d:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a2:	eb f2                	jmp    801096 <dev_lookup+0x48>

008010a4 <fd_close>:
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	53                   	push   %ebx
  8010aa:	83 ec 1c             	sub    $0x1c,%esp
  8010ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8010b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010b6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010bd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c0:	50                   	push   %eax
  8010c1:	e8 32 ff ff ff       	call   800ff8 <fd_lookup>
  8010c6:	89 c3                	mov    %eax,%ebx
  8010c8:	83 c4 08             	add    $0x8,%esp
  8010cb:	85 c0                	test   %eax,%eax
  8010cd:	78 05                	js     8010d4 <fd_close+0x30>
	    || fd != fd2)
  8010cf:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010d2:	74 16                	je     8010ea <fd_close+0x46>
		return (must_exist ? r : 0);
  8010d4:	89 f8                	mov    %edi,%eax
  8010d6:	84 c0                	test   %al,%al
  8010d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8010dd:	0f 44 d8             	cmove  %eax,%ebx
}
  8010e0:	89 d8                	mov    %ebx,%eax
  8010e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010ea:	83 ec 08             	sub    $0x8,%esp
  8010ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8010f0:	50                   	push   %eax
  8010f1:	ff 36                	pushl  (%esi)
  8010f3:	e8 56 ff ff ff       	call   80104e <dev_lookup>
  8010f8:	89 c3                	mov    %eax,%ebx
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	78 15                	js     801116 <fd_close+0x72>
		if (dev->dev_close)
  801101:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801104:	8b 40 10             	mov    0x10(%eax),%eax
  801107:	85 c0                	test   %eax,%eax
  801109:	74 1b                	je     801126 <fd_close+0x82>
			r = (*dev->dev_close)(fd);
  80110b:	83 ec 0c             	sub    $0xc,%esp
  80110e:	56                   	push   %esi
  80110f:	ff d0                	call   *%eax
  801111:	89 c3                	mov    %eax,%ebx
  801113:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801116:	83 ec 08             	sub    $0x8,%esp
  801119:	56                   	push   %esi
  80111a:	6a 00                	push   $0x0
  80111c:	e8 82 fb ff ff       	call   800ca3 <sys_page_unmap>
	return r;
  801121:	83 c4 10             	add    $0x10,%esp
  801124:	eb ba                	jmp    8010e0 <fd_close+0x3c>
			r = 0;
  801126:	bb 00 00 00 00       	mov    $0x0,%ebx
  80112b:	eb e9                	jmp    801116 <fd_close+0x72>

0080112d <close>:

int
close(int fdnum)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801133:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801136:	50                   	push   %eax
  801137:	ff 75 08             	pushl  0x8(%ebp)
  80113a:	e8 b9 fe ff ff       	call   800ff8 <fd_lookup>
  80113f:	83 c4 08             	add    $0x8,%esp
  801142:	85 c0                	test   %eax,%eax
  801144:	78 10                	js     801156 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801146:	83 ec 08             	sub    $0x8,%esp
  801149:	6a 01                	push   $0x1
  80114b:	ff 75 f4             	pushl  -0xc(%ebp)
  80114e:	e8 51 ff ff ff       	call   8010a4 <fd_close>
  801153:	83 c4 10             	add    $0x10,%esp
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <close_all>:

void
close_all(void)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	53                   	push   %ebx
  80115c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80115f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801164:	83 ec 0c             	sub    $0xc,%esp
  801167:	53                   	push   %ebx
  801168:	e8 c0 ff ff ff       	call   80112d <close>
	for (i = 0; i < MAXFD; i++)
  80116d:	83 c3 01             	add    $0x1,%ebx
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	83 fb 20             	cmp    $0x20,%ebx
  801176:	75 ec                	jne    801164 <close_all+0xc>
}
  801178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80117b:	c9                   	leave  
  80117c:	c3                   	ret    

0080117d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	53                   	push   %ebx
  801183:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801186:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801189:	50                   	push   %eax
  80118a:	ff 75 08             	pushl  0x8(%ebp)
  80118d:	e8 66 fe ff ff       	call   800ff8 <fd_lookup>
  801192:	89 c3                	mov    %eax,%ebx
  801194:	83 c4 08             	add    $0x8,%esp
  801197:	85 c0                	test   %eax,%eax
  801199:	0f 88 81 00 00 00    	js     801220 <dup+0xa3>
		return r;
	close(newfdnum);
  80119f:	83 ec 0c             	sub    $0xc,%esp
  8011a2:	ff 75 0c             	pushl  0xc(%ebp)
  8011a5:	e8 83 ff ff ff       	call   80112d <close>

	newfd = INDEX2FD(newfdnum);
  8011aa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ad:	c1 e6 0c             	shl    $0xc,%esi
  8011b0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011b6:	83 c4 04             	add    $0x4,%esp
  8011b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011bc:	e8 d1 fd ff ff       	call   800f92 <fd2data>
  8011c1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011c3:	89 34 24             	mov    %esi,(%esp)
  8011c6:	e8 c7 fd ff ff       	call   800f92 <fd2data>
  8011cb:	83 c4 10             	add    $0x10,%esp
  8011ce:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011d0:	89 d8                	mov    %ebx,%eax
  8011d2:	c1 e8 16             	shr    $0x16,%eax
  8011d5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011dc:	a8 01                	test   $0x1,%al
  8011de:	74 11                	je     8011f1 <dup+0x74>
  8011e0:	89 d8                	mov    %ebx,%eax
  8011e2:	c1 e8 0c             	shr    $0xc,%eax
  8011e5:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011ec:	f6 c2 01             	test   $0x1,%dl
  8011ef:	75 39                	jne    80122a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011f4:	89 d0                	mov    %edx,%eax
  8011f6:	c1 e8 0c             	shr    $0xc,%eax
  8011f9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801200:	83 ec 0c             	sub    $0xc,%esp
  801203:	25 07 0e 00 00       	and    $0xe07,%eax
  801208:	50                   	push   %eax
  801209:	56                   	push   %esi
  80120a:	6a 00                	push   $0x0
  80120c:	52                   	push   %edx
  80120d:	6a 00                	push   $0x0
  80120f:	e8 4d fa ff ff       	call   800c61 <sys_page_map>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 20             	add    $0x20,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 31                	js     80124e <dup+0xd1>
		goto err;

	return newfdnum;
  80121d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801220:	89 d8                	mov    %ebx,%eax
  801222:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80122a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	25 07 0e 00 00       	and    $0xe07,%eax
  801239:	50                   	push   %eax
  80123a:	57                   	push   %edi
  80123b:	6a 00                	push   $0x0
  80123d:	53                   	push   %ebx
  80123e:	6a 00                	push   $0x0
  801240:	e8 1c fa ff ff       	call   800c61 <sys_page_map>
  801245:	89 c3                	mov    %eax,%ebx
  801247:	83 c4 20             	add    $0x20,%esp
  80124a:	85 c0                	test   %eax,%eax
  80124c:	79 a3                	jns    8011f1 <dup+0x74>
	sys_page_unmap(0, newfd);
  80124e:	83 ec 08             	sub    $0x8,%esp
  801251:	56                   	push   %esi
  801252:	6a 00                	push   $0x0
  801254:	e8 4a fa ff ff       	call   800ca3 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801259:	83 c4 08             	add    $0x8,%esp
  80125c:	57                   	push   %edi
  80125d:	6a 00                	push   $0x0
  80125f:	e8 3f fa ff ff       	call   800ca3 <sys_page_unmap>
	return r;
  801264:	83 c4 10             	add    $0x10,%esp
  801267:	eb b7                	jmp    801220 <dup+0xa3>

00801269 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	53                   	push   %ebx
  80126d:	83 ec 14             	sub    $0x14,%esp
  801270:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801273:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801276:	50                   	push   %eax
  801277:	53                   	push   %ebx
  801278:	e8 7b fd ff ff       	call   800ff8 <fd_lookup>
  80127d:	83 c4 08             	add    $0x8,%esp
  801280:	85 c0                	test   %eax,%eax
  801282:	78 3f                	js     8012c3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801284:	83 ec 08             	sub    $0x8,%esp
  801287:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80128a:	50                   	push   %eax
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	ff 30                	pushl  (%eax)
  801290:	e8 b9 fd ff ff       	call   80104e <dev_lookup>
  801295:	83 c4 10             	add    $0x10,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 27                	js     8012c3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80129c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80129f:	8b 42 08             	mov    0x8(%edx),%eax
  8012a2:	83 e0 03             	and    $0x3,%eax
  8012a5:	83 f8 01             	cmp    $0x1,%eax
  8012a8:	74 1e                	je     8012c8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ad:	8b 40 08             	mov    0x8(%eax),%eax
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	74 35                	je     8012e9 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	ff 75 10             	pushl  0x10(%ebp)
  8012ba:	ff 75 0c             	pushl  0xc(%ebp)
  8012bd:	52                   	push   %edx
  8012be:	ff d0                	call   *%eax
  8012c0:	83 c4 10             	add    $0x10,%esp
}
  8012c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012c8:	a1 08 40 80 00       	mov    0x804008,%eax
  8012cd:	8b 40 48             	mov    0x48(%eax),%eax
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	53                   	push   %ebx
  8012d4:	50                   	push   %eax
  8012d5:	68 2d 29 80 00       	push   $0x80292d
  8012da:	e8 27 ef ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  8012df:	83 c4 10             	add    $0x10,%esp
  8012e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e7:	eb da                	jmp    8012c3 <read+0x5a>
		return -E_NOT_SUPP;
  8012e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012ee:	eb d3                	jmp    8012c3 <read+0x5a>

008012f0 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	57                   	push   %edi
  8012f4:	56                   	push   %esi
  8012f5:	53                   	push   %ebx
  8012f6:	83 ec 0c             	sub    $0xc,%esp
  8012f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012fc:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012ff:	bb 00 00 00 00       	mov    $0x0,%ebx
  801304:	39 f3                	cmp    %esi,%ebx
  801306:	73 25                	jae    80132d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	89 f0                	mov    %esi,%eax
  80130d:	29 d8                	sub    %ebx,%eax
  80130f:	50                   	push   %eax
  801310:	89 d8                	mov    %ebx,%eax
  801312:	03 45 0c             	add    0xc(%ebp),%eax
  801315:	50                   	push   %eax
  801316:	57                   	push   %edi
  801317:	e8 4d ff ff ff       	call   801269 <read>
		if (m < 0)
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	78 08                	js     80132b <readn+0x3b>
			return m;
		if (m == 0)
  801323:	85 c0                	test   %eax,%eax
  801325:	74 06                	je     80132d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801327:	01 c3                	add    %eax,%ebx
  801329:	eb d9                	jmp    801304 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80132b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80132d:	89 d8                	mov    %ebx,%eax
  80132f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5f                   	pop    %edi
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	53                   	push   %ebx
  80133b:	83 ec 14             	sub    $0x14,%esp
  80133e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801341:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801344:	50                   	push   %eax
  801345:	53                   	push   %ebx
  801346:	e8 ad fc ff ff       	call   800ff8 <fd_lookup>
  80134b:	83 c4 08             	add    $0x8,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 3a                	js     80138c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801352:	83 ec 08             	sub    $0x8,%esp
  801355:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135c:	ff 30                	pushl  (%eax)
  80135e:	e8 eb fc ff ff       	call   80104e <dev_lookup>
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	85 c0                	test   %eax,%eax
  801368:	78 22                	js     80138c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80136a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801371:	74 1e                	je     801391 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801376:	8b 52 0c             	mov    0xc(%edx),%edx
  801379:	85 d2                	test   %edx,%edx
  80137b:	74 35                	je     8013b2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80137d:	83 ec 04             	sub    $0x4,%esp
  801380:	ff 75 10             	pushl  0x10(%ebp)
  801383:	ff 75 0c             	pushl  0xc(%ebp)
  801386:	50                   	push   %eax
  801387:	ff d2                	call   *%edx
  801389:	83 c4 10             	add    $0x10,%esp
}
  80138c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80138f:	c9                   	leave  
  801390:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801391:	a1 08 40 80 00       	mov    0x804008,%eax
  801396:	8b 40 48             	mov    0x48(%eax),%eax
  801399:	83 ec 04             	sub    $0x4,%esp
  80139c:	53                   	push   %ebx
  80139d:	50                   	push   %eax
  80139e:	68 49 29 80 00       	push   $0x802949
  8013a3:	e8 5e ee ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  8013a8:	83 c4 10             	add    $0x10,%esp
  8013ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b0:	eb da                	jmp    80138c <write+0x55>
		return -E_NOT_SUPP;
  8013b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b7:	eb d3                	jmp    80138c <write+0x55>

008013b9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013bf:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	ff 75 08             	pushl  0x8(%ebp)
  8013c6:	e8 2d fc ff ff       	call   800ff8 <fd_lookup>
  8013cb:	83 c4 08             	add    $0x8,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 0e                	js     8013e0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	53                   	push   %ebx
  8013e6:	83 ec 14             	sub    $0x14,%esp
  8013e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ef:	50                   	push   %eax
  8013f0:	53                   	push   %ebx
  8013f1:	e8 02 fc ff ff       	call   800ff8 <fd_lookup>
  8013f6:	83 c4 08             	add    $0x8,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 37                	js     801434 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fd:	83 ec 08             	sub    $0x8,%esp
  801400:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801403:	50                   	push   %eax
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	ff 30                	pushl  (%eax)
  801409:	e8 40 fc ff ff       	call   80104e <dev_lookup>
  80140e:	83 c4 10             	add    $0x10,%esp
  801411:	85 c0                	test   %eax,%eax
  801413:	78 1f                	js     801434 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801418:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141c:	74 1b                	je     801439 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80141e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801421:	8b 52 18             	mov    0x18(%edx),%edx
  801424:	85 d2                	test   %edx,%edx
  801426:	74 32                	je     80145a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	ff 75 0c             	pushl  0xc(%ebp)
  80142e:	50                   	push   %eax
  80142f:	ff d2                	call   *%edx
  801431:	83 c4 10             	add    $0x10,%esp
}
  801434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801437:	c9                   	leave  
  801438:	c3                   	ret    
			thisenv->env_id, fdnum);
  801439:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80143e:	8b 40 48             	mov    0x48(%eax),%eax
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	53                   	push   %ebx
  801445:	50                   	push   %eax
  801446:	68 0c 29 80 00       	push   $0x80290c
  80144b:	e8 b6 ed ff ff       	call   800206 <cprintf>
		return -E_INVAL;
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801458:	eb da                	jmp    801434 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80145a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145f:	eb d3                	jmp    801434 <ftruncate+0x52>

00801461 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	53                   	push   %ebx
  801465:	83 ec 14             	sub    $0x14,%esp
  801468:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	ff 75 08             	pushl  0x8(%ebp)
  801472:	e8 81 fb ff ff       	call   800ff8 <fd_lookup>
  801477:	83 c4 08             	add    $0x8,%esp
  80147a:	85 c0                	test   %eax,%eax
  80147c:	78 4b                	js     8014c9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147e:	83 ec 08             	sub    $0x8,%esp
  801481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801484:	50                   	push   %eax
  801485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801488:	ff 30                	pushl  (%eax)
  80148a:	e8 bf fb ff ff       	call   80104e <dev_lookup>
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	85 c0                	test   %eax,%eax
  801494:	78 33                	js     8014c9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801499:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80149d:	74 2f                	je     8014ce <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80149f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014a2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014a9:	00 00 00 
	stat->st_isdir = 0;
  8014ac:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014b3:	00 00 00 
	stat->st_dev = dev;
  8014b6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	53                   	push   %ebx
  8014c0:	ff 75 f0             	pushl  -0x10(%ebp)
  8014c3:	ff 50 14             	call   *0x14(%eax)
  8014c6:	83 c4 10             	add    $0x10,%esp
}
  8014c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    
		return -E_NOT_SUPP;
  8014ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d3:	eb f4                	jmp    8014c9 <fstat+0x68>

008014d5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014da:	83 ec 08             	sub    $0x8,%esp
  8014dd:	6a 00                	push   $0x0
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 e7 01 00 00       	call   8016ce <open>
  8014e7:	89 c3                	mov    %eax,%ebx
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 1b                	js     80150b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8014f0:	83 ec 08             	sub    $0x8,%esp
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	50                   	push   %eax
  8014f7:	e8 65 ff ff ff       	call   801461 <fstat>
  8014fc:	89 c6                	mov    %eax,%esi
	close(fd);
  8014fe:	89 1c 24             	mov    %ebx,(%esp)
  801501:	e8 27 fc ff ff       	call   80112d <close>
	return r;
  801506:	83 c4 10             	add    $0x10,%esp
  801509:	89 f3                	mov    %esi,%ebx
}
  80150b:	89 d8                	mov    %ebx,%eax
  80150d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801510:	5b                   	pop    %ebx
  801511:	5e                   	pop    %esi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	89 c6                	mov    %eax,%esi
  80151b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80151d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801524:	74 27                	je     80154d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801526:	6a 07                	push   $0x7
  801528:	68 00 50 80 00       	push   $0x805000
  80152d:	56                   	push   %esi
  80152e:	ff 35 00 40 80 00    	pushl  0x804000
  801534:	e8 2b 0d 00 00       	call   802264 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801539:	83 c4 0c             	add    $0xc,%esp
  80153c:	6a 00                	push   $0x0
  80153e:	53                   	push   %ebx
  80153f:	6a 00                	push   $0x0
  801541:	e8 b7 0c 00 00       	call   8021fd <ipc_recv>
}
  801546:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801549:	5b                   	pop    %ebx
  80154a:	5e                   	pop    %esi
  80154b:	5d                   	pop    %ebp
  80154c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80154d:	83 ec 0c             	sub    $0xc,%esp
  801550:	6a 01                	push   $0x1
  801552:	e8 61 0d 00 00       	call   8022b8 <ipc_find_env>
  801557:	a3 00 40 80 00       	mov    %eax,0x804000
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	eb c5                	jmp    801526 <fsipc+0x12>

00801561 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	8b 40 0c             	mov    0xc(%eax),%eax
  80156d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	b8 02 00 00 00       	mov    $0x2,%eax
  801584:	e8 8b ff ff ff       	call   801514 <fsipc>
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <devfile_flush>:
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	8b 40 0c             	mov    0xc(%eax),%eax
  801597:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80159c:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a1:	b8 06 00 00 00       	mov    $0x6,%eax
  8015a6:	e8 69 ff ff ff       	call   801514 <fsipc>
}
  8015ab:	c9                   	leave  
  8015ac:	c3                   	ret    

008015ad <devfile_stat>:
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	53                   	push   %ebx
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8015cc:	e8 43 ff ff ff       	call   801514 <fsipc>
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	78 2c                	js     801601 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	68 00 50 80 00       	push   $0x805000
  8015dd:	53                   	push   %ebx
  8015de:	e8 42 f2 ff ff       	call   800825 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015e3:	a1 80 50 80 00       	mov    0x805080,%eax
  8015e8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ee:	a1 84 50 80 00       	mov    0x805084,%eax
  8015f3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015f9:	83 c4 10             	add    $0x10,%esp
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <devfile_write>:
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 0c             	sub    $0xc,%esp
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
  80160f:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801614:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801619:	0f 47 c2             	cmova  %edx,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	8b 52 0c             	mov    0xc(%edx),%edx
  801622:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  801628:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, n);
  80162d:	50                   	push   %eax
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	68 08 50 80 00       	push   $0x805008
  801636:	e8 78 f3 ff ff       	call   8009b3 <memmove>
	return fsipc(FSREQ_WRITE, NULL);
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	b8 04 00 00 00       	mov    $0x4,%eax
  801645:	e8 ca fe ff ff       	call   801514 <fsipc>
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <devfile_read>:
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	56                   	push   %esi
  801650:	53                   	push   %ebx
  801651:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8b 40 0c             	mov    0xc(%eax),%eax
  80165a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80165f:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	b8 03 00 00 00       	mov    $0x3,%eax
  80166f:	e8 a0 fe ff ff       	call   801514 <fsipc>
  801674:	89 c3                	mov    %eax,%ebx
  801676:	85 c0                	test   %eax,%eax
  801678:	78 1f                	js     801699 <devfile_read+0x4d>
	assert(r <= n);
  80167a:	39 f0                	cmp    %esi,%eax
  80167c:	77 24                	ja     8016a2 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80167e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801683:	7f 33                	jg     8016b8 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	50                   	push   %eax
  801689:	68 00 50 80 00       	push   $0x805000
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 1d f3 ff ff       	call   8009b3 <memmove>
	return r;
  801696:	83 c4 10             	add    $0x10,%esp
}
  801699:	89 d8                	mov    %ebx,%eax
  80169b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80169e:	5b                   	pop    %ebx
  80169f:	5e                   	pop    %esi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    
	assert(r <= n);
  8016a2:	68 7c 29 80 00       	push   $0x80297c
  8016a7:	68 83 29 80 00       	push   $0x802983
  8016ac:	6a 7b                	push   $0x7b
  8016ae:	68 98 29 80 00       	push   $0x802998
  8016b3:	e8 ff 0a 00 00       	call   8021b7 <_panic>
	assert(r <= PGSIZE);
  8016b8:	68 a3 29 80 00       	push   $0x8029a3
  8016bd:	68 83 29 80 00       	push   $0x802983
  8016c2:	6a 7c                	push   $0x7c
  8016c4:	68 98 29 80 00       	push   $0x802998
  8016c9:	e8 e9 0a 00 00       	call   8021b7 <_panic>

008016ce <open>:
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	56                   	push   %esi
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 1c             	sub    $0x1c,%esp
  8016d6:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8016d9:	56                   	push   %esi
  8016da:	e8 0f f1 ff ff       	call   8007ee <strlen>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8016e7:	7f 6c                	jg     801755 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8016e9:	83 ec 0c             	sub    $0xc,%esp
  8016ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	e8 b4 f8 ff ff       	call   800fa9 <fd_alloc>
  8016f5:	89 c3                	mov    %eax,%ebx
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 3c                	js     80173a <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	56                   	push   %esi
  801702:	68 00 50 80 00       	push   $0x805000
  801707:	e8 19 f1 ff ff       	call   800825 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80170c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0)
  801714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801717:	b8 01 00 00 00       	mov    $0x1,%eax
  80171c:	e8 f3 fd ff ff       	call   801514 <fsipc>
  801721:	89 c3                	mov    %eax,%ebx
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	78 19                	js     801743 <open+0x75>
	return fd2num(fd);
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	ff 75 f4             	pushl  -0xc(%ebp)
  801730:	e8 4d f8 ff ff       	call   800f82 <fd2num>
  801735:	89 c3                	mov    %eax,%ebx
  801737:	83 c4 10             	add    $0x10,%esp
}
  80173a:	89 d8                	mov    %ebx,%eax
  80173c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5d                   	pop    %ebp
  801742:	c3                   	ret    
		fd_close(fd, 0);
  801743:	83 ec 08             	sub    $0x8,%esp
  801746:	6a 00                	push   $0x0
  801748:	ff 75 f4             	pushl  -0xc(%ebp)
  80174b:	e8 54 f9 ff ff       	call   8010a4 <fd_close>
		return r;
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	eb e5                	jmp    80173a <open+0x6c>
		return -E_BAD_PATH;
  801755:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80175a:	eb de                	jmp    80173a <open+0x6c>

0080175c <sync>:

// Synchronize disk with buffer cache
int sync(void)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	b8 08 00 00 00       	mov    $0x8,%eax
  80176c:	e8 a3 fd ff ff       	call   801514 <fsipc>
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801773:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801777:	7e 38                	jle    8017b1 <writebuf+0x3e>
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	53                   	push   %ebx
  80177d:	83 ec 08             	sub    $0x8,%esp
  801780:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  801782:	ff 70 04             	pushl  0x4(%eax)
  801785:	8d 40 10             	lea    0x10(%eax),%eax
  801788:	50                   	push   %eax
  801789:	ff 33                	pushl  (%ebx)
  80178b:	e8 a7 fb ff ff       	call   801337 <write>
		if (result > 0)
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	85 c0                	test   %eax,%eax
  801795:	7e 03                	jle    80179a <writebuf+0x27>
			b->result += result;
  801797:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80179a:	39 43 04             	cmp    %eax,0x4(%ebx)
  80179d:	74 0d                	je     8017ac <writebuf+0x39>
			b->error = (result < 0 ? result : 0);
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a6:	0f 4f c2             	cmovg  %edx,%eax
  8017a9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8017ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    
  8017b1:	f3 c3                	repz ret 

008017b3 <putch>:

static void
putch(int ch, void *thunk)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8017bd:	8b 53 04             	mov    0x4(%ebx),%edx
  8017c0:	8d 42 01             	lea    0x1(%edx),%eax
  8017c3:	89 43 04             	mov    %eax,0x4(%ebx)
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8017cd:	3d 00 01 00 00       	cmp    $0x100,%eax
  8017d2:	74 06                	je     8017da <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  8017d4:	83 c4 04             	add    $0x4,%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    
		writebuf(b);
  8017da:	89 d8                	mov    %ebx,%eax
  8017dc:	e8 92 ff ff ff       	call   801773 <writebuf>
		b->idx = 0;
  8017e1:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8017e8:	eb ea                	jmp    8017d4 <putch+0x21>

008017ea <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8017fc:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801803:	00 00 00 
	b.result = 0;
  801806:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80180d:	00 00 00 
	b.error = 1;
  801810:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801817:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801826:	50                   	push   %eax
  801827:	68 b3 17 80 00       	push   $0x8017b3
  80182c:	e8 d2 ea ff ff       	call   800303 <vprintfmt>
	if (b.idx > 0)
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  80183b:	7f 11                	jg     80184e <vfprintf+0x64>
		writebuf(&b);

	return (b.result ? b.result : b.error);
  80183d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801843:	85 c0                	test   %eax,%eax
  801845:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    
		writebuf(&b);
  80184e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801854:	e8 1a ff ff ff       	call   801773 <writebuf>
  801859:	eb e2                	jmp    80183d <vfprintf+0x53>

0080185b <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801861:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801864:	50                   	push   %eax
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	ff 75 08             	pushl  0x8(%ebp)
  80186b:	e8 7a ff ff ff       	call   8017ea <vfprintf>
	va_end(ap);

	return cnt;
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <printf>:

int
printf(const char *fmt, ...)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801878:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80187b:	50                   	push   %eax
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 01                	push   $0x1
  801881:	e8 64 ff ff ff       	call   8017ea <vfprintf>
	va_end(ap);

	return cnt;
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80188e:	68 af 29 80 00       	push   $0x8029af
  801893:	ff 75 0c             	pushl  0xc(%ebp)
  801896:	e8 8a ef ff ff       	call   800825 <strcpy>
	return 0;
}
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <devsock_close>:
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 10             	sub    $0x10,%esp
  8018a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018ac:	53                   	push   %ebx
  8018ad:	e8 3f 0a 00 00       	call   8022f1 <pageref>
  8018b2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018ba:	83 f8 01             	cmp    $0x1,%eax
  8018bd:	74 07                	je     8018c6 <devsock_close+0x24>
}
  8018bf:	89 d0                	mov    %edx,%eax
  8018c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018c6:	83 ec 0c             	sub    $0xc,%esp
  8018c9:	ff 73 0c             	pushl  0xc(%ebx)
  8018cc:	e8 b7 02 00 00       	call   801b88 <nsipc_close>
  8018d1:	89 c2                	mov    %eax,%edx
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	eb e7                	jmp    8018bf <devsock_close+0x1d>

008018d8 <devsock_write>:
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	ff 75 10             	pushl  0x10(%ebp)
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	ff 70 0c             	pushl  0xc(%eax)
  8018ec:	e8 74 03 00 00       	call   801c65 <nsipc_send>
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <devsock_read>:
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 10             	pushl  0x10(%ebp)
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	ff 70 0c             	pushl  0xc(%eax)
  801907:	e8 ed 02 00 00       	call   801bf9 <nsipc_recv>
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <fd2sockid>:
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801914:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	e8 da f6 ff ff       	call   800ff8 <fd_lookup>
  80191e:	83 c4 10             	add    $0x10,%esp
  801921:	85 c0                	test   %eax,%eax
  801923:	78 10                	js     801935 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801928:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80192e:	39 08                	cmp    %ecx,(%eax)
  801930:	75 05                	jne    801937 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801932:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    
		return -E_NOT_SUPP;
  801937:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193c:	eb f7                	jmp    801935 <fd2sockid+0x27>

0080193e <alloc_sockfd>:
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	56                   	push   %esi
  801942:	53                   	push   %ebx
  801943:	83 ec 1c             	sub    $0x1c,%esp
  801946:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801948:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194b:	50                   	push   %eax
  80194c:	e8 58 f6 ff ff       	call   800fa9 <fd_alloc>
  801951:	89 c3                	mov    %eax,%ebx
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 43                	js     80199d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	68 07 04 00 00       	push   $0x407
  801962:	ff 75 f4             	pushl  -0xc(%ebp)
  801965:	6a 00                	push   $0x0
  801967:	e8 b2 f2 ff ff       	call   800c1e <sys_page_alloc>
  80196c:	89 c3                	mov    %eax,%ebx
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	78 28                	js     80199d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801978:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80197e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801983:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80198a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	50                   	push   %eax
  801991:	e8 ec f5 ff ff       	call   800f82 <fd2num>
  801996:	89 c3                	mov    %eax,%ebx
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	eb 0c                	jmp    8019a9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	56                   	push   %esi
  8019a1:	e8 e2 01 00 00       	call   801b88 <nsipc_close>
		return r;
  8019a6:	83 c4 10             	add    $0x10,%esp
}
  8019a9:	89 d8                	mov    %ebx,%eax
  8019ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    

008019b2 <accept>:
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	e8 4e ff ff ff       	call   80190e <fd2sockid>
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 1b                	js     8019df <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019c4:	83 ec 04             	sub    $0x4,%esp
  8019c7:	ff 75 10             	pushl  0x10(%ebp)
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	50                   	push   %eax
  8019ce:	e8 0e 01 00 00       	call   801ae1 <nsipc_accept>
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	78 05                	js     8019df <accept+0x2d>
	return alloc_sockfd(r);
  8019da:	e8 5f ff ff ff       	call   80193e <alloc_sockfd>
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <bind>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	e8 1f ff ff ff       	call   80190e <fd2sockid>
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 12                	js     801a05 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	ff 75 10             	pushl  0x10(%ebp)
  8019f9:	ff 75 0c             	pushl  0xc(%ebp)
  8019fc:	50                   	push   %eax
  8019fd:	e8 2f 01 00 00       	call   801b31 <nsipc_bind>
  801a02:	83 c4 10             	add    $0x10,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <shutdown>:
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a10:	e8 f9 fe ff ff       	call   80190e <fd2sockid>
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 0f                	js     801a28 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a19:	83 ec 08             	sub    $0x8,%esp
  801a1c:	ff 75 0c             	pushl  0xc(%ebp)
  801a1f:	50                   	push   %eax
  801a20:	e8 41 01 00 00       	call   801b66 <nsipc_shutdown>
  801a25:	83 c4 10             	add    $0x10,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <connect>:
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	e8 d6 fe ff ff       	call   80190e <fd2sockid>
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 12                	js     801a4e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a3c:	83 ec 04             	sub    $0x4,%esp
  801a3f:	ff 75 10             	pushl  0x10(%ebp)
  801a42:	ff 75 0c             	pushl  0xc(%ebp)
  801a45:	50                   	push   %eax
  801a46:	e8 57 01 00 00       	call   801ba2 <nsipc_connect>
  801a4b:	83 c4 10             	add    $0x10,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <listen>:
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	e8 b0 fe ff ff       	call   80190e <fd2sockid>
  801a5e:	85 c0                	test   %eax,%eax
  801a60:	78 0f                	js     801a71 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a62:	83 ec 08             	sub    $0x8,%esp
  801a65:	ff 75 0c             	pushl  0xc(%ebp)
  801a68:	50                   	push   %eax
  801a69:	e8 69 01 00 00       	call   801bd7 <nsipc_listen>
  801a6e:	83 c4 10             	add    $0x10,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a79:	ff 75 10             	pushl  0x10(%ebp)
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	e8 3c 02 00 00       	call   801cc3 <nsipc_socket>
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 05                	js     801a93 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a8e:	e8 ab fe ff ff       	call   80193e <alloc_sockfd>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a9e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aa5:	74 26                	je     801acd <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aa7:	6a 07                	push   $0x7
  801aa9:	68 00 60 80 00       	push   $0x806000
  801aae:	53                   	push   %ebx
  801aaf:	ff 35 04 40 80 00    	pushl  0x804004
  801ab5:	e8 aa 07 00 00       	call   802264 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aba:	83 c4 0c             	add    $0xc,%esp
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	e8 35 07 00 00       	call   8021fd <ipc_recv>
}
  801ac8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801acd:	83 ec 0c             	sub    $0xc,%esp
  801ad0:	6a 02                	push   $0x2
  801ad2:	e8 e1 07 00 00       	call   8022b8 <ipc_find_env>
  801ad7:	a3 04 40 80 00       	mov    %eax,0x804004
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	eb c6                	jmp    801aa7 <nsipc+0x12>

00801ae1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	56                   	push   %esi
  801ae5:	53                   	push   %ebx
  801ae6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801af1:	8b 06                	mov    (%esi),%eax
  801af3:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801af8:	b8 01 00 00 00       	mov    $0x1,%eax
  801afd:	e8 93 ff ff ff       	call   801a95 <nsipc>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	85 c0                	test   %eax,%eax
  801b06:	78 20                	js     801b28 <nsipc_accept+0x47>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b08:	83 ec 04             	sub    $0x4,%esp
  801b0b:	ff 35 10 60 80 00    	pushl  0x806010
  801b11:	68 00 60 80 00       	push   $0x806000
  801b16:	ff 75 0c             	pushl  0xc(%ebp)
  801b19:	e8 95 ee ff ff       	call   8009b3 <memmove>
		*addrlen = ret->ret_addrlen;
  801b1e:	a1 10 60 80 00       	mov    0x806010,%eax
  801b23:	89 06                	mov    %eax,(%esi)
  801b25:	83 c4 10             	add    $0x10,%esp
	}
	return r;
}
  801b28:	89 d8                	mov    %ebx,%eax
  801b2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b2d:	5b                   	pop    %ebx
  801b2e:	5e                   	pop    %esi
  801b2f:	5d                   	pop    %ebp
  801b30:	c3                   	ret    

00801b31 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	53                   	push   %ebx
  801b35:	83 ec 08             	sub    $0x8,%esp
  801b38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b43:	53                   	push   %ebx
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	68 04 60 80 00       	push   $0x806004
  801b4c:	e8 62 ee ff ff       	call   8009b3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b51:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b57:	b8 02 00 00 00       	mov    $0x2,%eax
  801b5c:	e8 34 ff ff ff       	call   801a95 <nsipc>
}
  801b61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b77:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b7c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b81:	e8 0f ff ff ff       	call   801a95 <nsipc>
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <nsipc_close>:

int
nsipc_close(int s)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b96:	b8 04 00 00 00       	mov    $0x4,%eax
  801b9b:	e8 f5 fe ff ff       	call   801a95 <nsipc>
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	53                   	push   %ebx
  801ba6:	83 ec 08             	sub    $0x8,%esp
  801ba9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bb4:	53                   	push   %ebx
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	68 04 60 80 00       	push   $0x806004
  801bbd:	e8 f1 ed ff ff       	call   8009b3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bc2:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bc8:	b8 05 00 00 00       	mov    $0x5,%eax
  801bcd:	e8 c3 fe ff ff       	call   801a95 <nsipc>
}
  801bd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bed:	b8 06 00 00 00       	mov    $0x6,%eax
  801bf2:	e8 9e fe ff ff       	call   801a95 <nsipc>
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	56                   	push   %esi
  801bfd:	53                   	push   %ebx
  801bfe:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c09:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c12:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c17:	b8 07 00 00 00       	mov    $0x7,%eax
  801c1c:	e8 74 fe ff ff       	call   801a95 <nsipc>
  801c21:	89 c3                	mov    %eax,%ebx
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 1f                	js     801c46 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c27:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c2c:	7f 21                	jg     801c4f <nsipc_recv+0x56>
  801c2e:	39 c6                	cmp    %eax,%esi
  801c30:	7c 1d                	jl     801c4f <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	50                   	push   %eax
  801c36:	68 00 60 80 00       	push   $0x806000
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	e8 70 ed ff ff       	call   8009b3 <memmove>
  801c43:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c46:	89 d8                	mov    %ebx,%eax
  801c48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4b:	5b                   	pop    %ebx
  801c4c:	5e                   	pop    %esi
  801c4d:	5d                   	pop    %ebp
  801c4e:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c4f:	68 bb 29 80 00       	push   $0x8029bb
  801c54:	68 83 29 80 00       	push   $0x802983
  801c59:	6a 62                	push   $0x62
  801c5b:	68 d0 29 80 00       	push   $0x8029d0
  801c60:	e8 52 05 00 00       	call   8021b7 <_panic>

00801c65 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
  801c69:	83 ec 04             	sub    $0x4,%esp
  801c6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c77:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c7d:	7f 2e                	jg     801cad <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c7f:	83 ec 04             	sub    $0x4,%esp
  801c82:	53                   	push   %ebx
  801c83:	ff 75 0c             	pushl  0xc(%ebp)
  801c86:	68 0c 60 80 00       	push   $0x80600c
  801c8b:	e8 23 ed ff ff       	call   8009b3 <memmove>
	nsipcbuf.send.req_size = size;
  801c90:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c96:	8b 45 14             	mov    0x14(%ebp),%eax
  801c99:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca3:	e8 ed fd ff ff       	call   801a95 <nsipc>
}
  801ca8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    
	assert(size < 1600);
  801cad:	68 dc 29 80 00       	push   $0x8029dc
  801cb2:	68 83 29 80 00       	push   $0x802983
  801cb7:	6a 6d                	push   $0x6d
  801cb9:	68 d0 29 80 00       	push   $0x8029d0
  801cbe:	e8 f4 04 00 00       	call   8021b7 <_panic>

00801cc3 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cdc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ce1:	b8 09 00 00 00       	mov    $0x9,%eax
  801ce6:	e8 aa fd ff ff       	call   801a95 <nsipc>
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	56                   	push   %esi
  801cf1:	53                   	push   %ebx
  801cf2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cf5:	83 ec 0c             	sub    $0xc,%esp
  801cf8:	ff 75 08             	pushl  0x8(%ebp)
  801cfb:	e8 92 f2 ff ff       	call   800f92 <fd2data>
  801d00:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d02:	83 c4 08             	add    $0x8,%esp
  801d05:	68 e8 29 80 00       	push   $0x8029e8
  801d0a:	53                   	push   %ebx
  801d0b:	e8 15 eb ff ff       	call   800825 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d10:	8b 46 04             	mov    0x4(%esi),%eax
  801d13:	2b 06                	sub    (%esi),%eax
  801d15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d1b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d22:	00 00 00 
	stat->st_dev = &devpipe;
  801d25:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d2c:	30 80 00 
	return 0;
}
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 0c             	sub    $0xc,%esp
  801d42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d45:	53                   	push   %ebx
  801d46:	6a 00                	push   $0x0
  801d48:	e8 56 ef ff ff       	call   800ca3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d4d:	89 1c 24             	mov    %ebx,(%esp)
  801d50:	e8 3d f2 ff ff       	call   800f92 <fd2data>
  801d55:	83 c4 08             	add    $0x8,%esp
  801d58:	50                   	push   %eax
  801d59:	6a 00                	push   $0x0
  801d5b:	e8 43 ef ff ff       	call   800ca3 <sys_page_unmap>
}
  801d60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <_pipeisclosed>:
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	57                   	push   %edi
  801d69:	56                   	push   %esi
  801d6a:	53                   	push   %ebx
  801d6b:	83 ec 1c             	sub    $0x1c,%esp
  801d6e:	89 c7                	mov    %eax,%edi
  801d70:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d72:	a1 08 40 80 00       	mov    0x804008,%eax
  801d77:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	57                   	push   %edi
  801d7e:	e8 6e 05 00 00       	call   8022f1 <pageref>
  801d83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d86:	89 34 24             	mov    %esi,(%esp)
  801d89:	e8 63 05 00 00       	call   8022f1 <pageref>
		nn = thisenv->env_runs;
  801d8e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d94:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	39 cb                	cmp    %ecx,%ebx
  801d9c:	74 1b                	je     801db9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d9e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da1:	75 cf                	jne    801d72 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801da3:	8b 42 58             	mov    0x58(%edx),%eax
  801da6:	6a 01                	push   $0x1
  801da8:	50                   	push   %eax
  801da9:	53                   	push   %ebx
  801daa:	68 ef 29 80 00       	push   $0x8029ef
  801daf:	e8 52 e4 ff ff       	call   800206 <cprintf>
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	eb b9                	jmp    801d72 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801db9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dbc:	0f 94 c0             	sete   %al
  801dbf:	0f b6 c0             	movzbl %al,%eax
}
  801dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5f                   	pop    %edi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <devpipe_write>:
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	57                   	push   %edi
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 28             	sub    $0x28,%esp
  801dd3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dd6:	56                   	push   %esi
  801dd7:	e8 b6 f1 ff ff       	call   800f92 <fd2data>
  801ddc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	bf 00 00 00 00       	mov    $0x0,%edi
  801de6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801de9:	74 4f                	je     801e3a <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801deb:	8b 43 04             	mov    0x4(%ebx),%eax
  801dee:	8b 0b                	mov    (%ebx),%ecx
  801df0:	8d 51 20             	lea    0x20(%ecx),%edx
  801df3:	39 d0                	cmp    %edx,%eax
  801df5:	72 14                	jb     801e0b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801df7:	89 da                	mov    %ebx,%edx
  801df9:	89 f0                	mov    %esi,%eax
  801dfb:	e8 65 ff ff ff       	call   801d65 <_pipeisclosed>
  801e00:	85 c0                	test   %eax,%eax
  801e02:	75 3a                	jne    801e3e <devpipe_write+0x74>
			sys_yield();
  801e04:	e8 f6 ed ff ff       	call   800bff <sys_yield>
  801e09:	eb e0                	jmp    801deb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0e:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e12:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e15:	89 c2                	mov    %eax,%edx
  801e17:	c1 fa 1f             	sar    $0x1f,%edx
  801e1a:	89 d1                	mov    %edx,%ecx
  801e1c:	c1 e9 1b             	shr    $0x1b,%ecx
  801e1f:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e22:	83 e2 1f             	and    $0x1f,%edx
  801e25:	29 ca                	sub    %ecx,%edx
  801e27:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e2b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e2f:	83 c0 01             	add    $0x1,%eax
  801e32:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e35:	83 c7 01             	add    $0x1,%edi
  801e38:	eb ac                	jmp    801de6 <devpipe_write+0x1c>
	return i;
  801e3a:	89 f8                	mov    %edi,%eax
  801e3c:	eb 05                	jmp    801e43 <devpipe_write+0x79>
				return 0;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e46:	5b                   	pop    %ebx
  801e47:	5e                   	pop    %esi
  801e48:	5f                   	pop    %edi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <devpipe_read>:
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	57                   	push   %edi
  801e4f:	56                   	push   %esi
  801e50:	53                   	push   %ebx
  801e51:	83 ec 18             	sub    $0x18,%esp
  801e54:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e57:	57                   	push   %edi
  801e58:	e8 35 f1 ff ff       	call   800f92 <fd2data>
  801e5d:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e5f:	83 c4 10             	add    $0x10,%esp
  801e62:	be 00 00 00 00       	mov    $0x0,%esi
  801e67:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6a:	74 47                	je     801eb3 <devpipe_read+0x68>
		while (p->p_rpos == p->p_wpos) {
  801e6c:	8b 03                	mov    (%ebx),%eax
  801e6e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e71:	75 22                	jne    801e95 <devpipe_read+0x4a>
			if (i > 0)
  801e73:	85 f6                	test   %esi,%esi
  801e75:	75 14                	jne    801e8b <devpipe_read+0x40>
			if (_pipeisclosed(fd, p))
  801e77:	89 da                	mov    %ebx,%edx
  801e79:	89 f8                	mov    %edi,%eax
  801e7b:	e8 e5 fe ff ff       	call   801d65 <_pipeisclosed>
  801e80:	85 c0                	test   %eax,%eax
  801e82:	75 33                	jne    801eb7 <devpipe_read+0x6c>
			sys_yield();
  801e84:	e8 76 ed ff ff       	call   800bff <sys_yield>
  801e89:	eb e1                	jmp    801e6c <devpipe_read+0x21>
				return i;
  801e8b:	89 f0                	mov    %esi,%eax
}
  801e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e90:	5b                   	pop    %ebx
  801e91:	5e                   	pop    %esi
  801e92:	5f                   	pop    %edi
  801e93:	5d                   	pop    %ebp
  801e94:	c3                   	ret    
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e95:	99                   	cltd   
  801e96:	c1 ea 1b             	shr    $0x1b,%edx
  801e99:	01 d0                	add    %edx,%eax
  801e9b:	83 e0 1f             	and    $0x1f,%eax
  801e9e:	29 d0                	sub    %edx,%eax
  801ea0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eab:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eae:	83 c6 01             	add    $0x1,%esi
  801eb1:	eb b4                	jmp    801e67 <devpipe_read+0x1c>
	return i;
  801eb3:	89 f0                	mov    %esi,%eax
  801eb5:	eb d6                	jmp    801e8d <devpipe_read+0x42>
				return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebc:	eb cf                	jmp    801e8d <devpipe_read+0x42>

00801ebe <pipe>:
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	56                   	push   %esi
  801ec2:	53                   	push   %ebx
  801ec3:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ec6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec9:	50                   	push   %eax
  801eca:	e8 da f0 ff ff       	call   800fa9 <fd_alloc>
  801ecf:	89 c3                	mov    %eax,%ebx
  801ed1:	83 c4 10             	add    $0x10,%esp
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	78 5b                	js     801f33 <pipe+0x75>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	68 07 04 00 00       	push   $0x407
  801ee0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee3:	6a 00                	push   $0x0
  801ee5:	e8 34 ed ff ff       	call   800c1e <sys_page_alloc>
  801eea:	89 c3                	mov    %eax,%ebx
  801eec:	83 c4 10             	add    $0x10,%esp
  801eef:	85 c0                	test   %eax,%eax
  801ef1:	78 40                	js     801f33 <pipe+0x75>
	if ((r = fd_alloc(&fd1)) < 0
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef9:	50                   	push   %eax
  801efa:	e8 aa f0 ff ff       	call   800fa9 <fd_alloc>
  801eff:	89 c3                	mov    %eax,%ebx
  801f01:	83 c4 10             	add    $0x10,%esp
  801f04:	85 c0                	test   %eax,%eax
  801f06:	78 1b                	js     801f23 <pipe+0x65>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f08:	83 ec 04             	sub    $0x4,%esp
  801f0b:	68 07 04 00 00       	push   $0x407
  801f10:	ff 75 f0             	pushl  -0x10(%ebp)
  801f13:	6a 00                	push   $0x0
  801f15:	e8 04 ed ff ff       	call   800c1e <sys_page_alloc>
  801f1a:	89 c3                	mov    %eax,%ebx
  801f1c:	83 c4 10             	add    $0x10,%esp
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	79 19                	jns    801f3c <pipe+0x7e>
	sys_page_unmap(0, fd0);
  801f23:	83 ec 08             	sub    $0x8,%esp
  801f26:	ff 75 f4             	pushl  -0xc(%ebp)
  801f29:	6a 00                	push   $0x0
  801f2b:	e8 73 ed ff ff       	call   800ca3 <sys_page_unmap>
  801f30:	83 c4 10             	add    $0x10,%esp
}
  801f33:	89 d8                	mov    %ebx,%eax
  801f35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5e                   	pop    %esi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
	va = fd2data(fd0);
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f42:	e8 4b f0 ff ff       	call   800f92 <fd2data>
  801f47:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f49:	83 c4 0c             	add    $0xc,%esp
  801f4c:	68 07 04 00 00       	push   $0x407
  801f51:	50                   	push   %eax
  801f52:	6a 00                	push   $0x0
  801f54:	e8 c5 ec ff ff       	call   800c1e <sys_page_alloc>
  801f59:	89 c3                	mov    %eax,%ebx
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	0f 88 8c 00 00 00    	js     801ff2 <pipe+0x134>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6c:	e8 21 f0 ff ff       	call   800f92 <fd2data>
  801f71:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f78:	50                   	push   %eax
  801f79:	6a 00                	push   $0x0
  801f7b:	56                   	push   %esi
  801f7c:	6a 00                	push   $0x0
  801f7e:	e8 de ec ff ff       	call   800c61 <sys_page_map>
  801f83:	89 c3                	mov    %eax,%ebx
  801f85:	83 c4 20             	add    $0x20,%esp
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	78 58                	js     801fe4 <pipe+0x126>
	fd0->fd_dev_id = devpipe.dev_id;
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f95:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801faa:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fbc:	e8 c1 ef ff ff       	call   800f82 <fd2num>
  801fc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc4:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fc6:	83 c4 04             	add    $0x4,%esp
  801fc9:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcc:	e8 b1 ef ff ff       	call   800f82 <fd2num>
  801fd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fd4:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fd7:	83 c4 10             	add    $0x10,%esp
  801fda:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fdf:	e9 4f ff ff ff       	jmp    801f33 <pipe+0x75>
	sys_page_unmap(0, va);
  801fe4:	83 ec 08             	sub    $0x8,%esp
  801fe7:	56                   	push   %esi
  801fe8:	6a 00                	push   $0x0
  801fea:	e8 b4 ec ff ff       	call   800ca3 <sys_page_unmap>
  801fef:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801ff2:	83 ec 08             	sub    $0x8,%esp
  801ff5:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff8:	6a 00                	push   $0x0
  801ffa:	e8 a4 ec ff ff       	call   800ca3 <sys_page_unmap>
  801fff:	83 c4 10             	add    $0x10,%esp
  802002:	e9 1c ff ff ff       	jmp    801f23 <pipe+0x65>

00802007 <pipeisclosed>:
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80200d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802010:	50                   	push   %eax
  802011:	ff 75 08             	pushl  0x8(%ebp)
  802014:	e8 df ef ff ff       	call   800ff8 <fd_lookup>
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	85 c0                	test   %eax,%eax
  80201e:	78 18                	js     802038 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	ff 75 f4             	pushl  -0xc(%ebp)
  802026:	e8 67 ef ff ff       	call   800f92 <fd2data>
	return _pipeisclosed(fd, p);
  80202b:	89 c2                	mov    %eax,%edx
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	e8 30 fd ff ff       	call   801d65 <_pipeisclosed>
  802035:	83 c4 10             	add    $0x10,%esp
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80204a:	68 07 2a 80 00       	push   $0x802a07
  80204f:	ff 75 0c             	pushl  0xc(%ebp)
  802052:	e8 ce e7 ff ff       	call   800825 <strcpy>
	return 0;
}
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <devcons_write>:
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80206a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80206f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802075:	eb 2f                	jmp    8020a6 <devcons_write+0x48>
		m = n - tot;
  802077:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80207a:	29 f3                	sub    %esi,%ebx
  80207c:	83 fb 7f             	cmp    $0x7f,%ebx
  80207f:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802084:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	53                   	push   %ebx
  80208b:	89 f0                	mov    %esi,%eax
  80208d:	03 45 0c             	add    0xc(%ebp),%eax
  802090:	50                   	push   %eax
  802091:	57                   	push   %edi
  802092:	e8 1c e9 ff ff       	call   8009b3 <memmove>
		sys_cputs(buf, m);
  802097:	83 c4 08             	add    $0x8,%esp
  80209a:	53                   	push   %ebx
  80209b:	57                   	push   %edi
  80209c:	e8 c1 ea ff ff       	call   800b62 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a1:	01 de                	add    %ebx,%esi
  8020a3:	83 c4 10             	add    $0x10,%esp
  8020a6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020a9:	72 cc                	jb     802077 <devcons_write+0x19>
}
  8020ab:	89 f0                	mov    %esi,%eax
  8020ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b0:	5b                   	pop    %ebx
  8020b1:	5e                   	pop    %esi
  8020b2:	5f                   	pop    %edi
  8020b3:	5d                   	pop    %ebp
  8020b4:	c3                   	ret    

008020b5 <devcons_read>:
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
  8020bb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c4:	75 07                	jne    8020cd <devcons_read+0x18>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    
		sys_yield();
  8020c8:	e8 32 eb ff ff       	call   800bff <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8020cd:	e8 ae ea ff ff       	call   800b80 <sys_cgetc>
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	74 f2                	je     8020c8 <devcons_read+0x13>
	if (c < 0)
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	78 ec                	js     8020c6 <devcons_read+0x11>
	if (c == 0x04)	// ctl-d is eof
  8020da:	83 f8 04             	cmp    $0x4,%eax
  8020dd:	74 0c                	je     8020eb <devcons_read+0x36>
	*(char*)vbuf = c;
  8020df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e2:	88 02                	mov    %al,(%edx)
	return 1;
  8020e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e9:	eb db                	jmp    8020c6 <devcons_read+0x11>
		return 0;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	eb d4                	jmp    8020c6 <devcons_read+0x11>

008020f2 <cputchar>:
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020fe:	6a 01                	push   $0x1
  802100:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802103:	50                   	push   %eax
  802104:	e8 59 ea ff ff       	call   800b62 <sys_cputs>
}
  802109:	83 c4 10             	add    $0x10,%esp
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <getchar>:
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802114:	6a 01                	push   $0x1
  802116:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802119:	50                   	push   %eax
  80211a:	6a 00                	push   $0x0
  80211c:	e8 48 f1 ff ff       	call   801269 <read>
	if (r < 0)
  802121:	83 c4 10             	add    $0x10,%esp
  802124:	85 c0                	test   %eax,%eax
  802126:	78 08                	js     802130 <getchar+0x22>
	if (r < 1)
  802128:	85 c0                	test   %eax,%eax
  80212a:	7e 06                	jle    802132 <getchar+0x24>
	return c;
  80212c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    
		return -E_EOF;
  802132:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802137:	eb f7                	jmp    802130 <getchar+0x22>

00802139 <iscons>:
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80213f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802142:	50                   	push   %eax
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	e8 ad ee ff ff       	call   800ff8 <fd_lookup>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 11                	js     802163 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802155:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215b:	39 10                	cmp    %edx,(%eax)
  80215d:	0f 94 c0             	sete   %al
  802160:	0f b6 c0             	movzbl %al,%eax
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <opencons>:
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80216b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80216e:	50                   	push   %eax
  80216f:	e8 35 ee ff ff       	call   800fa9 <fd_alloc>
  802174:	83 c4 10             	add    $0x10,%esp
  802177:	85 c0                	test   %eax,%eax
  802179:	78 3a                	js     8021b5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	68 07 04 00 00       	push   $0x407
  802183:	ff 75 f4             	pushl  -0xc(%ebp)
  802186:	6a 00                	push   $0x0
  802188:	e8 91 ea ff ff       	call   800c1e <sys_page_alloc>
  80218d:	83 c4 10             	add    $0x10,%esp
  802190:	85 c0                	test   %eax,%eax
  802192:	78 21                	js     8021b5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802197:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80219d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	50                   	push   %eax
  8021ad:	e8 d0 ed ff ff       	call   800f82 <fd2num>
  8021b2:	83 c4 10             	add    $0x10,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
  8021ba:	56                   	push   %esi
  8021bb:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  8021bc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021bf:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021c5:	e8 16 ea ff ff       	call   800be0 <sys_getenvid>
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	ff 75 0c             	pushl  0xc(%ebp)
  8021d0:	ff 75 08             	pushl  0x8(%ebp)
  8021d3:	56                   	push   %esi
  8021d4:	50                   	push   %eax
  8021d5:	68 14 2a 80 00       	push   $0x802a14
  8021da:	e8 27 e0 ff ff       	call   800206 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021df:	83 c4 18             	add    $0x18,%esp
  8021e2:	53                   	push   %ebx
  8021e3:	ff 75 10             	pushl  0x10(%ebp)
  8021e6:	e8 ca df ff ff       	call   8001b5 <vcprintf>
	cprintf("\n");
  8021eb:	c7 04 24 90 25 80 00 	movl   $0x802590,(%esp)
  8021f2:	e8 0f e0 ff ff       	call   800206 <cprintf>
  8021f7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021fa:	cc                   	int3   
  8021fb:	eb fd                	jmp    8021fa <_panic+0x43>

008021fd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	8b 75 08             	mov    0x8(%ebp),%esi
  802205:	8b 45 0c             	mov    0xc(%ebp),%eax
  802208:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  80220b:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  80220d:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802212:	0f 44 c2             	cmove  %edx,%eax
	int ret = sys_ipc_recv(pg);
  802215:	83 ec 0c             	sub    $0xc,%esp
  802218:	50                   	push   %eax
  802219:	e8 b0 eb ff ff       	call   800dce <sys_ipc_recv>
	if (from_env_store)
  80221e:	83 c4 10             	add    $0x10,%esp
  802221:	85 f6                	test   %esi,%esi
  802223:	74 14                	je     802239 <ipc_recv+0x3c>
		*from_env_store = ret < 0 ? 0 : thisenv->env_ipc_from;
  802225:	ba 00 00 00 00       	mov    $0x0,%edx
  80222a:	85 c0                	test   %eax,%eax
  80222c:	78 09                	js     802237 <ipc_recv+0x3a>
  80222e:	8b 15 08 40 80 00    	mov    0x804008,%edx
  802234:	8b 52 74             	mov    0x74(%edx),%edx
  802237:	89 16                	mov    %edx,(%esi)
	if (perm_store)
  802239:	85 db                	test   %ebx,%ebx
  80223b:	74 14                	je     802251 <ipc_recv+0x54>
		*perm_store = ret < 0 ? 0 : thisenv->env_ipc_perm;
  80223d:	ba 00 00 00 00       	mov    $0x0,%edx
  802242:	85 c0                	test   %eax,%eax
  802244:	78 09                	js     80224f <ipc_recv+0x52>
  802246:	8b 15 08 40 80 00    	mov    0x804008,%edx
  80224c:	8b 52 78             	mov    0x78(%edx),%edx
  80224f:	89 13                	mov    %edx,(%ebx)
	if (ret < 0)
  802251:	85 c0                	test   %eax,%eax
  802253:	78 08                	js     80225d <ipc_recv+0x60>
		return ret;
	return thisenv->env_ipc_value;
  802255:	a1 08 40 80 00       	mov    0x804008,%eax
  80225a:	8b 40 70             	mov    0x70(%eax),%eax
	// panic("ipc_recv not implemented");
}
  80225d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5d                   	pop    %ebp
  802263:	c3                   	ret    

00802264 <ipc_send>:
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	57                   	push   %edi
  802268:	56                   	push   %esi
  802269:	53                   	push   %ebx
  80226a:	83 ec 0c             	sub    $0xc,%esp
  80226d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802270:	8b 75 0c             	mov    0xc(%ebp),%esi
  802273:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	if (pg == NULL)
  802276:	85 db                	test   %ebx,%ebx
		pg = (void *)UTOP;
  802278:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80227d:	0f 44 d8             	cmove  %eax,%ebx
	int ret;
	while (true)
	{
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  802280:	ff 75 14             	pushl  0x14(%ebp)
  802283:	53                   	push   %ebx
  802284:	56                   	push   %esi
  802285:	57                   	push   %edi
  802286:	e8 20 eb ff ff       	call   800dab <sys_ipc_try_send>
		if (ret == 0)
  80228b:	83 c4 10             	add    $0x10,%esp
  80228e:	85 c0                	test   %eax,%eax
  802290:	74 1e                	je     8022b0 <ipc_send+0x4c>
			return;
		else if (ret == -E_IPC_NOT_RECV)
  802292:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802295:	75 07                	jne    80229e <ipc_send+0x3a>
			sys_yield();
  802297:	e8 63 e9 ff ff       	call   800bff <sys_yield>
		ret = sys_ipc_try_send(to_env, val, pg, perm);
  80229c:	eb e2                	jmp    802280 <ipc_send+0x1c>
		else
			panic("ipc_send failed: %e", ret);
  80229e:	50                   	push   %eax
  80229f:	68 38 2a 80 00       	push   $0x802a38
  8022a4:	6a 3d                	push   $0x3d
  8022a6:	68 4c 2a 80 00       	push   $0x802a4c
  8022ab:	e8 07 ff ff ff       	call   8021b7 <_panic>
	}
	// panic("ipc_send not implemented");
}
  8022b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022b3:	5b                   	pop    %ebx
  8022b4:	5e                   	pop    %esi
  8022b5:	5f                   	pop    %edi
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    

008022b8 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022be:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022c3:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022c6:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022cc:	8b 52 50             	mov    0x50(%edx),%edx
  8022cf:	39 ca                	cmp    %ecx,%edx
  8022d1:	74 11                	je     8022e4 <ipc_find_env+0x2c>
	for (i = 0; i < NENV; i++)
  8022d3:	83 c0 01             	add    $0x1,%eax
  8022d6:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022db:	75 e6                	jne    8022c3 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e2:	eb 0b                	jmp    8022ef <ipc_find_env+0x37>
			return envs[i].env_id;
  8022e4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022e7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ec:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022f7:	89 d0                	mov    %edx,%eax
  8022f9:	c1 e8 16             	shr    $0x16,%eax
  8022fc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802308:	f6 c1 01             	test   $0x1,%cl
  80230b:	74 1d                	je     80232a <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80230d:	c1 ea 0c             	shr    $0xc,%edx
  802310:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802317:	f6 c2 01             	test   $0x1,%dl
  80231a:	74 0e                	je     80232a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80231c:	c1 ea 0c             	shr    $0xc,%edx
  80231f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802326:	ef 
  802327:	0f b7 c0             	movzwl %ax,%eax
}
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80233f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802343:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802347:	85 d2                	test   %edx,%edx
  802349:	75 35                	jne    802380 <__udivdi3+0x50>
  80234b:	39 f3                	cmp    %esi,%ebx
  80234d:	0f 87 bd 00 00 00    	ja     802410 <__udivdi3+0xe0>
  802353:	85 db                	test   %ebx,%ebx
  802355:	89 d9                	mov    %ebx,%ecx
  802357:	75 0b                	jne    802364 <__udivdi3+0x34>
  802359:	b8 01 00 00 00       	mov    $0x1,%eax
  80235e:	31 d2                	xor    %edx,%edx
  802360:	f7 f3                	div    %ebx
  802362:	89 c1                	mov    %eax,%ecx
  802364:	31 d2                	xor    %edx,%edx
  802366:	89 f0                	mov    %esi,%eax
  802368:	f7 f1                	div    %ecx
  80236a:	89 c6                	mov    %eax,%esi
  80236c:	89 e8                	mov    %ebp,%eax
  80236e:	89 f7                	mov    %esi,%edi
  802370:	f7 f1                	div    %ecx
  802372:	89 fa                	mov    %edi,%edx
  802374:	83 c4 1c             	add    $0x1c,%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5f                   	pop    %edi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    
  80237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802380:	39 f2                	cmp    %esi,%edx
  802382:	77 7c                	ja     802400 <__udivdi3+0xd0>
  802384:	0f bd fa             	bsr    %edx,%edi
  802387:	83 f7 1f             	xor    $0x1f,%edi
  80238a:	0f 84 98 00 00 00    	je     802428 <__udivdi3+0xf8>
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	d3 e6                	shl    %cl,%esi
  8023c1:	89 eb                	mov    %ebp,%ebx
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 0c                	jb     8023e7 <__udivdi3+0xb7>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 5d                	jae    802440 <__udivdi3+0x110>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	75 59                	jne    802440 <__udivdi3+0x110>
  8023e7:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023ea:	31 ff                	xor    %edi,%edi
  8023ec:	89 fa                	mov    %edi,%edx
  8023ee:	83 c4 1c             	add    $0x1c,%esp
  8023f1:	5b                   	pop    %ebx
  8023f2:	5e                   	pop    %esi
  8023f3:	5f                   	pop    %edi
  8023f4:	5d                   	pop    %ebp
  8023f5:	c3                   	ret    
  8023f6:	8d 76 00             	lea    0x0(%esi),%esi
  8023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  802400:	31 ff                	xor    %edi,%edi
  802402:	31 c0                	xor    %eax,%eax
  802404:	89 fa                	mov    %edi,%edx
  802406:	83 c4 1c             	add    $0x1c,%esp
  802409:	5b                   	pop    %ebx
  80240a:	5e                   	pop    %esi
  80240b:	5f                   	pop    %edi
  80240c:	5d                   	pop    %ebp
  80240d:	c3                   	ret    
  80240e:	66 90                	xchg   %ax,%ax
  802410:	31 ff                	xor    %edi,%edi
  802412:	89 e8                	mov    %ebp,%eax
  802414:	89 f2                	mov    %esi,%edx
  802416:	f7 f3                	div    %ebx
  802418:	89 fa                	mov    %edi,%edx
  80241a:	83 c4 1c             	add    $0x1c,%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5f                   	pop    %edi
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    
  802422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	72 06                	jb     802432 <__udivdi3+0x102>
  80242c:	31 c0                	xor    %eax,%eax
  80242e:	39 eb                	cmp    %ebp,%ebx
  802430:	77 d2                	ja     802404 <__udivdi3+0xd4>
  802432:	b8 01 00 00 00       	mov    $0x1,%eax
  802437:	eb cb                	jmp    802404 <__udivdi3+0xd4>
  802439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802440:	89 d8                	mov    %ebx,%eax
  802442:	31 ff                	xor    %edi,%edi
  802444:	eb be                	jmp    802404 <__udivdi3+0xd4>
  802446:	66 90                	xchg   %ax,%ax
  802448:	66 90                	xchg   %ax,%ax
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <__umoddi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	53                   	push   %ebx
  802454:	83 ec 1c             	sub    $0x1c,%esp
  802457:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
  80245b:	8b 74 24 30          	mov    0x30(%esp),%esi
  80245f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  802463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802467:	85 ed                	test   %ebp,%ebp
  802469:	89 f0                	mov    %esi,%eax
  80246b:	89 da                	mov    %ebx,%edx
  80246d:	75 19                	jne    802488 <__umoddi3+0x38>
  80246f:	39 df                	cmp    %ebx,%edi
  802471:	0f 86 b1 00 00 00    	jbe    802528 <__umoddi3+0xd8>
  802477:	f7 f7                	div    %edi
  802479:	89 d0                	mov    %edx,%eax
  80247b:	31 d2                	xor    %edx,%edx
  80247d:	83 c4 1c             	add    $0x1c,%esp
  802480:	5b                   	pop    %ebx
  802481:	5e                   	pop    %esi
  802482:	5f                   	pop    %edi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    
  802485:	8d 76 00             	lea    0x0(%esi),%esi
  802488:	39 dd                	cmp    %ebx,%ebp
  80248a:	77 f1                	ja     80247d <__umoddi3+0x2d>
  80248c:	0f bd cd             	bsr    %ebp,%ecx
  80248f:	83 f1 1f             	xor    $0x1f,%ecx
  802492:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802496:	0f 84 b4 00 00 00    	je     802550 <__umoddi3+0x100>
  80249c:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a1:	89 c2                	mov    %eax,%edx
  8024a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024a7:	29 c2                	sub    %eax,%edx
  8024a9:	89 c1                	mov    %eax,%ecx
  8024ab:	89 f8                	mov    %edi,%eax
  8024ad:	d3 e5                	shl    %cl,%ebp
  8024af:	89 d1                	mov    %edx,%ecx
  8024b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024b5:	d3 e8                	shr    %cl,%eax
  8024b7:	09 c5                	or     %eax,%ebp
  8024b9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024bd:	89 c1                	mov    %eax,%ecx
  8024bf:	d3 e7                	shl    %cl,%edi
  8024c1:	89 d1                	mov    %edx,%ecx
  8024c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024c7:	89 df                	mov    %ebx,%edi
  8024c9:	d3 ef                	shr    %cl,%edi
  8024cb:	89 c1                	mov    %eax,%ecx
  8024cd:	89 f0                	mov    %esi,%eax
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 d1                	mov    %edx,%ecx
  8024d3:	89 fa                	mov    %edi,%edx
  8024d5:	d3 e8                	shr    %cl,%eax
  8024d7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	f7 f5                	div    %ebp
  8024e0:	d3 e6                	shl    %cl,%esi
  8024e2:	89 d1                	mov    %edx,%ecx
  8024e4:	f7 64 24 08          	mull   0x8(%esp)
  8024e8:	39 d1                	cmp    %edx,%ecx
  8024ea:	89 c3                	mov    %eax,%ebx
  8024ec:	89 d7                	mov    %edx,%edi
  8024ee:	72 06                	jb     8024f6 <__umoddi3+0xa6>
  8024f0:	75 0e                	jne    802500 <__umoddi3+0xb0>
  8024f2:	39 c6                	cmp    %eax,%esi
  8024f4:	73 0a                	jae    802500 <__umoddi3+0xb0>
  8024f6:	2b 44 24 08          	sub    0x8(%esp),%eax
  8024fa:	19 ea                	sbb    %ebp,%edx
  8024fc:	89 d7                	mov    %edx,%edi
  8024fe:	89 c3                	mov    %eax,%ebx
  802500:	89 ca                	mov    %ecx,%edx
  802502:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
  802507:	29 de                	sub    %ebx,%esi
  802509:	19 fa                	sbb    %edi,%edx
  80250b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80250f:	89 d0                	mov    %edx,%eax
  802511:	d3 e0                	shl    %cl,%eax
  802513:	89 d9                	mov    %ebx,%ecx
  802515:	d3 ee                	shr    %cl,%esi
  802517:	d3 ea                	shr    %cl,%edx
  802519:	09 f0                	or     %esi,%eax
  80251b:	83 c4 1c             	add    $0x1c,%esp
  80251e:	5b                   	pop    %ebx
  80251f:	5e                   	pop    %esi
  802520:	5f                   	pop    %edi
  802521:	5d                   	pop    %ebp
  802522:	c3                   	ret    
  802523:	90                   	nop
  802524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802528:	85 ff                	test   %edi,%edi
  80252a:	89 f9                	mov    %edi,%ecx
  80252c:	75 0b                	jne    802539 <__umoddi3+0xe9>
  80252e:	b8 01 00 00 00       	mov    $0x1,%eax
  802533:	31 d2                	xor    %edx,%edx
  802535:	f7 f7                	div    %edi
  802537:	89 c1                	mov    %eax,%ecx
  802539:	89 d8                	mov    %ebx,%eax
  80253b:	31 d2                	xor    %edx,%edx
  80253d:	f7 f1                	div    %ecx
  80253f:	89 f0                	mov    %esi,%eax
  802541:	f7 f1                	div    %ecx
  802543:	e9 31 ff ff ff       	jmp    802479 <__umoddi3+0x29>
  802548:	90                   	nop
  802549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802550:	39 dd                	cmp    %ebx,%ebp
  802552:	72 08                	jb     80255c <__umoddi3+0x10c>
  802554:	39 f7                	cmp    %esi,%edi
  802556:	0f 87 21 ff ff ff    	ja     80247d <__umoddi3+0x2d>
  80255c:	89 da                	mov    %ebx,%edx
  80255e:	89 f0                	mov    %esi,%eax
  802560:	29 f8                	sub    %edi,%eax
  802562:	19 ea                	sbb    %ebp,%edx
  802564:	e9 14 ff ff ff       	jmp    80247d <__umoddi3+0x2d>
